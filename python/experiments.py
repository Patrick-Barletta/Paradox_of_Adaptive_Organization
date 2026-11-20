"""Climate experiments (Python reference): rate window (Argument II) and paradox (Argument I)."""
import math, sys, json
from dataclasses import replace
from climate import *

TARGETS = [("1.7C", 510.0), ("2.0C", 1035.0)]
TCRE = [("central", 1.0), ("robust", 0.45 / 0.63)]
RSCAN = [i * 0.01 for i in range(0, 101)]     # 0..100 %/yr, to locate r_min beyond the org ceiling

def viable_r(p, s, r): return run(p, s, grow(p, r))[0]

def window_scan(p, s):
    return [r for r in RSCAN if viable_r(p, s, r)]

def rate_window(p):
    """Along the incumbent baseline: for each start year, the set of viable constant growth rates."""
    tr = baseline(p)
    rows = []
    for s in tr:
        if s[2] > p.budget + 1e-9: break
        w = window_scan(p, s)
        rows.append(dict(year=2027 + s[0], rmin=min(w) if w else None, rmax=max(w) if w else None,
                         contiguous=(len(w) == 0 or len(w) == int(round((max(w) - min(w)) / 0.01)) + 1),
                         phys=viable(p, "phys", s)))
    close_org = max([r["year"] for r in rows if r["rmin"] is not None and r["rmin"] <= p.gmax + 1e-12], default=None)
    close_phys = max([r["year"] for r in rows if r["phys"]], default=None)
    return rows, close_org, close_phys

# ---------------- paradox ----------------
def N_cost(p, f):
    """annual net cost of the abatement stock at depth f per Gt of reference emissions ($B per Gt).
    psi scales capex (n + s); fuel savings s are real: net cost density = psi*(n+s) - s."""
    k = p.kappa
    nint = p.n0 * f + p.n1 * ((math.exp(k * f) - 1) / k - f)
    return p.psi * (nint + p.s_fuel * f) - p.s_fuel * f

def fstar(p, pi):
    """depth where marginal net cost equals the carbon price: psi*(n(f*)+s) - s = pi"""
    v = 1 + ((pi + p.s_fuel) / p.psi - p.s_fuel - p.n0) / p.n1
    if v <= 1: return 0.0
    return min(1.0, math.log(v) / p.kappa)

def hist(p, mode, pi=0.0):
    """A: builder (max growth, max deployment). B: myopic (deploy only where n(f) < pi;
    expand at max rate while profitable deployment remains)."""
    s = s0(p); traj = [s]; xs = []
    fs = fstar(p, pi)
    while s[0] < p.T:
        if mode == "A":
            x = grow(p, p.gmax)(s); s2 = step(p, s, x)
        else:
            x = grow(p, p.gmax, fs)(s); s2 = step(p, s, x, fcap=fs)
        if s2 is None: break                      # capacity order unaffordable: history ends here
        xs.append(x); s = s2; traj.append(s)
    return traj, xs

def J(p, traj, xs, H):
    """consumption proxy over the first H years: minus (net cost of abatement stock + capacity capex), $T"""
    tot = 0.0
    for t in range(H):
        s = traj[t]
        tot -= eref(p, s[0]) * N_cost(p, s[1]) / 1000.0 + p.ccap * xs[t]
    return tot

def ahead_each_year(p, A, xA, B, xB, H):
    """Whether the cutoff path's cumulative score matches or exceeds the builder's at every prefix."""
    return all(J(p, B, xB, h) >= J(p, A, xA, h) for h in range(1, H + 1))

def sev_traj(p, traj, upto):
    return [severity(p, s) if s[2] <= p.budget + 1e-9 else 4 for s in traj[:upto + 1]]

def paradox(p, pi, H=14):
    A, xA = hist(p, "A"); B, xB = hist(p, "B", pi)
    jA, jB = J(p, A, xA, H), J(p, B, xB, H)
    tA, tB = pnr(p, "adapt", A), pnr(p, "adapt", B)
    vA = run(p, s0(p), grow(p, p.gmax))[0]
    # organizational attribution: at each year, give B the builder's capacity and pipeline
    swap = None
    for t in range(len(B)):
        b, a = B[t], A[t]
        if b[2] > p.budget + 1e-9: break
        if severity(p, b) == 3:
            swapped = (b[0], b[1], b[2], a[3], a[4])
            swap = dict(year=2027 + t, sigma_B=3, sigma_B_with_A_capacity=severity(p, swapped))
            break
    return dict(pi=pi, fstar=round(fstar(p, pi), 3), J_A=round(jA, 2), J_B=round(jB, 2),
                cutoff_ahead_at_H=jB > jA, tA_adapt=2027 + tA if tA >= 0 else None,
                tB_adapt=2027 + tB if tB >= 0 else None,
                paradox=(jB > jA) and (tB < tA), A_viable=vA, first_lockin_B=swap)

if __name__ == "__main__":
    for psi in [0.5, 1.0]:
        for phi in [2.0]:
            for (lab, B0) in TARGETS:
                for (tc, sc) in TCRE:
                    p = P(budget=B0 * sc, psi=psi, phi=phi)
                    rows, co, cp = rate_window(p)
                    print(f"psi={psi} phi={phi} {lab} {tc}: org window closes {co}, phys closes {cp}")
                    for r in rows[:12:2]:
                        print("   ", r)
