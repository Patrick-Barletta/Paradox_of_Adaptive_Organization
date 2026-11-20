"""Argument II experiments (Python reference)."""
import csv, math, sys
from dataclasses import replace
from climate import *
from climate import viable_cert, cert_reason
from experiments import hist

def pnr_rule(p, traj, ok):
    tk = -1
    for s in traj:
        if s[2] > p.budget + 1e-9: break
        if ok(s): tk = s[0]
        else: break
    return tk

# ---------- E-II.1: which form of acceleration buys the most time ----------
def sensitivity(path=None):
    if path is None:
        from pathlib import Path
        path = Path(__file__).resolve().parent.parent / "results" / "climate_window.csv"
    W = list(csv.DictReader(open(path)))
    f = lambda r, k: float(r[k])
    axes = {"psi (informational: cost)": ("psi", [1.0, 0.75, 0.5]),
            "phi (economic: spending)": ("phi", [1.5, 2.0, 3.0]),
            "gmax (material: scale-up)": ("gmax", [0.2, 0.3, 0.4]),
            "L (organizational: latency)": ("L", [3.0, 2.0, 1.0])}
    out = {}
    for name, (k, vals) in axes.items():
        shifts = []; opened = 0; steps = 0
        for r in W:
            if f(r, k) not in vals[:-1] or r['target'] != '2.0C': continue
            nxt_val = vals[vals.index(f(r, k)) + 1]
            twin = [q for q in W if q['target'] == r['target'] and q['tcre'] == r['tcre'] and
                    all(abs(f(q, kk) - (nxt_val if kk == k else f(r, kk))) < 1e-9 for kk in ("psi", "phi", "gmax", "L"))]
            q = twin[0]; steps += 1
            a, b = r['tAdapt'], q['tAdapt']
            if a != 'never' and b != 'never': shifts.append(int(b) - int(a))
            elif a == 'never' and b != 'never': opened += 1
        out[name] = (steps, sum(shifts) / len(shifts) if shifts else 0.0, min(shifts, default=0), max(shifts, default=0), opened)
    return out

# ---------- E-II.2: the dilemma: acceleration that consumes margin ----------
def unthrottled(r): return lambda z: r * z[3]

def window_rates(p, s, mk):
    return [i / 100 for i in range(101) if run(p, s, mk(i / 100))[0]]

def dilemma(psi=0.5, phi=2.0, budget=1035.0):
    rows = []
    for ccap in (0.3, 1.0, 3.0):
        p = P(psi=psi, phi=phi, budget=budget, ccap=ccap)
        b = baseline(p)
        for name, mk in (("stop when not binding", lambda r: grow(p, r)), ("never stop", unthrottled)):
            w = window_rates(p, b[0], mk)
            close = pnr_rule(p, b, lambda s: any(run(p, s, mk(r))[0] for r in rgrid(p)))
            contiguous = (not w) or len(w) == round((max(w) - min(w)) * 100) + 1
            rows.append(dict(ccap=ccap, program=name, rmin=min(w) if w else None, rmax=max(w) if w else None,
                             contiguous=contiguous, close=2027 + close if close >= 0 else None))
    return rows

# ---------- E-II.3: AI as accelerator and as margin consumer ----------
AI_SCEN = [("none", 0.0, 0.0), ("IEA-base-like", 0.2, 0.3), ("high", 0.6, 1.2), ("extreme", 1.5, 3.0)]
COST_CUT = [0.0, 0.025, 0.05, 0.10, 0.20]

def ai_grid(psi=0.5, phi=2.0, budget=1035.0):
    res = {}
    for (nm, a30, a35) in AI_SCEN:
        for d in COST_CUT:
            p = P(psi=psi * (1 - d), phi=phi, budget=budget, ai30=a30, ai35=a35)
            b = baseline(p)
            ta = pnr(p, "adapt", b); tc = pnr_rule(p, b, lambda s: viable_cert(p, s))
            res[(nm, d)] = (ta, tc)
    return res

# ---------- E-II.4: required rate never falls with delay (constant-rate programs) ----------
def monotone_check():
    viol = 0; seqs = 0
    for psi in (0.5, 0.75, 1.0):
        for phi in (1.5, 2.0, 3.0):
            for B in (1035.0, 1035.0 * 0.45 / 0.63):
                p = P(psi=psi, phi=phi, budget=B)
                b = baseline(p); prev = -1.0; seqs += 1
                for s in b:
                    if s[2] > p.budget + 1e-9: break
                    w = [i / 100 for i in range(101) if run(p, s, grow(p, i / 100))[0]]
                    cur = min(w) if w else 2.0
                    if cur < prev - 1e-12: viol += 1
                    prev = cur
    return seqs, viol

# ---------- E-II.5: carbon budget vs net-zero deadline ----------
def ablation():
    rows = []
    for tc, sc in (("central", 1.0), ("robust", 0.45 / 0.63)):
        for psi in (0.5, 0.75, 1.0):
            for phi in (1.5, 2.0, 3.0):
                out = {}
                for nz in (True, False):
                    p = P(psi=psi, phi=phi, budget=1035.0 * sc, require_nz=nz)
                    b = baseline(p)
                    out[nz] = (pnr(p, "adapt", b), pnr_rule(p, b, lambda s: viable_cert(p, s)), pnr(p, "phys", b))
                p = P(psi=psi, phi=phi, budget=1035.0 * sc)
                b = baseline(p)
                ta = out[True][0]
                k = ta + 1
                reason = cert_reason(p, b[k]) if 0 <= k < len(b) and b[k][2] <= p.budget + 1e-9 else (1 if k < len(b) else 0)
                rows.append((tc, psi, phi, out[True], out[False], reason))
    return rows

# ---------- myopic carbon-price thresholds, with and without the net-zero condition ----------
PRICES = [0.0, 25.0, 50.0, 75.0, 100.0, 125.0, 150.0, 175.0, 200.0, 250.0, 300.0]

def thresholds():
    """Lowest carbon price on the grid at which the myopic history stays in the adapt kernel
    through the terminal year (None if no price on the grid does)."""
    rows = []
    for psi in (0.5, 0.75, 1.0):
        for nz in (True, False):
            p = P(psi=psi, phi=2.0, budget=1035.0, require_nz=nz)
            thr = next((pi for pi in PRICES if pnr(p, "adapt", hist(p, "B", pi)[0]) >= p.T), None)
            rows.append((psi, nz, thr))
    return rows

# ---------- the Lean executable's output, line for line ----------
def lean_lines():
    """Everything `argII` prints (results/argII_output.txt), in the same format."""
    yr = lambda t: "never" if t < 0 else str(2027 + t)
    pct = lambda r: "none" if r is None else f"{round(r * 100)}%"
    f6 = lambda x: f"{x:.6f}"
    yield "E-II.2 dilemma (2.0C central, psi 0.5, phi 2)"
    for r in dilemma():
        close = "never" if r["close"] is None else str(r["close"])
        yield f"DIL ccap={f6(r['ccap'])} program={r['program']} rmin={pct(r['rmin'])} rmax={pct(r['rmax'])} close={close}"
    yield "E-II.3 AI: capacity-building closing year (2.0C central, phi 2)"
    for psi in (0.5, 0.75):
        g = ai_grid(psi=psi)
        for (nm, _, _) in AI_SCEN:
            for d in COST_CUT:
                yield f"AI psi={f6(psi)} scen={nm} cut={f6(d)} close={yr(g[(nm, d)][0])} cert={yr(g[(nm, d)][1])}"
    seqs, viol = monotone_check()
    yield f"MONO sequences={seqs} violations={viol}"
    head = P(psi=0.5, phi=2.0, budget=1035.0)
    incumbent = baseline(head)
    for t in (0, 3, 6, 8, 10, 11, 12, 13, 14, 15, 16):
        s = incumbent[t]
        excluded = next((i/100 for i in range(100, -1, -1)
                         if not viable_cert(replace(head, gmax=i/100), s)), None)
        witness = next((i/100 for i in range(101) if run(head, s, grow(head, i/100))[0]), None)
        yield f"RATE year={2027+t} maxExcluded={pct(excluded)} minWitness={pct(witness)}"
    yield "E-II.5 constraint ablation (2.0C, gmax 0.3, L 2)"
    for tc, psi, phi, both, bud, reason in ablation():
        yield (f"ABL {tc} psi={f6(psi)} phi={f6(phi)} both={yr(both[0])}/{yr(both[1])}/{yr(both[2])} "
               f"budgetonly={yr(bud[0])}/{yr(bud[1])}/{yr(bud[2])} reason={reason}")
    for psi, nz, thr in thresholds():
        yield f"THR psi={f6(psi)} requireNZ={'true' if nz else 'false'} threshold={'none' if thr is None else f6(thr)}"

MODES = ("all", "sens", "dil", "ai", "mono", "abl", "thr", "lean")

if __name__ == "__main__":
    # Usage: experiments_ii.py [all|sens|dil|ai|mono|abl|thr|lean]
    #   lean  prints exactly what the Lean executable prints, for comparison with results/argII_output.txt
    which = sys.argv[1] if len(sys.argv) > 1 else "all"
    if which not in MODES:
        sys.exit("usage: experiments_ii.py [" + "|".join(MODES) + "]")
    if which == "lean":
        for line in lean_lines(): print(line, flush=True)
    if which in ("all", "sens"):
        print("E-II.1 sensitivity of the 2.0C capacity-building closing year to one step along each axis")
        for k, v in sensitivity().items():
            print(f"  {k:32s}: {v[0]} steps, mean shift {v[1]:+.1f} yr (range {v[2]:+d}..{v[3]:+d}), 'never'->open {v[4]}")
    if which in ("all", "dil"):
        print("E-II.2 dilemma (2.0C central, psi 0.5, phi 2):")
        for r in dilemma(): print("  ", r)
    if which in ("all", "ai"):
        for psi in (0.5, 0.75):
            print(f"E-II.3 AI (2.0C central, psi {psi}, phi 2): capacity-building closing year [certificate]")
            g = ai_grid(psi=psi)
            for (nm, _, _) in AI_SCEN:
                print("  ", f"{nm:14s}", "  ".join(f"cut {int(d*1000)/10}%: {2027+g[(nm,d)][0] if g[(nm,d)][0]>=0 else 'never'}[{'=' if g[(nm,d)][0]==g[(nm,d)][1] else '!'}]" for d in COST_CUT))
    if which in ("all", "mono"):
        print("E-II.4 required rate nondecreasing along baselines:", monotone_check())
    if which in ("all", "abl"):
        yr = lambda t: str(2027 + t) if t >= 0 else "never"
        print("E-II.5 2.0C, gmax 0.3, L 2: closing years (adapt/cert/capacity-unconstrained), both constraints vs budget only; reason at first excluded year")
        for tc, psi, phi, both, bud, reason in ablation():
            print(f"  {tc:7s} psi={psi} phi={phi}: both {yr(both[0])}/{yr(both[1])}/{yr(both[2])}  budget-only {yr(bud[0])}/{yr(bud[1])}/{yr(bud[2])}  first-excluded fails by: {['viable','budget','net-zero'][reason]}")
    if which in ("all", "thr"):
        print("Myopic carbon-price threshold (2.0C central, phi 2): lowest price on the grid that keeps the capacity-building window open")
        for psi, nz, thr in thresholds():
            print(f"  psi={psi} net-zero required={nz}: {'none' if thr is None else f'${thr:g}/t'}")
