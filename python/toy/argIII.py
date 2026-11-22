"""Argument III demonstrations (Python reference).

III.A  Restoration independence: bootstrap closure on a capability-dependency graph.
III.B  The bounds gap: budget-limited witness search vs certificates, on the I.3.10 model.
III.C  Timed bootstrap: static closure reaches E, but a finite-endurance seed cannot power the
       serial activation chain (Lean: Paradox/Timed.lean). Run with argument C.
"""
import itertools, sys
import kernels as k

# ---------------- III.A: bootstrap closure ----------------
# Each capability has alternative prerequisite sets (OR of ANDs). It can be restored once every
# member of at least one alternative is up. Seeds are intact after the disruption.
GRID = {
    "gen1":    [["control", "fuel"]],
    "gen2":    [["control", "fuel"]],
    "control": [["power", "telecom"]],
    "telecom": [["power"]],
    "fuel":    [["power"]],
    "power":   [["gen1"], ["gen2"]],
}

def closure(graph, seeds):
    up = set(seeds)
    changed = True
    while changed:
        changed = False
        for c, alts in graph.items():
            if c not in up and any(all(x in up for x in alt) for alt in alts):
                up.add(c); changed = True
    return up

def with_changes(graph, **extra):
    g = {c: [list(a) for a in alts] for c, alts in graph.items()}
    for c, alts in extra.items():
        g.setdefault(c, [])
        g[c] = g[c] + alts
    return g

SCENARIOS = [
    ("total blackout, no black-start", GRID, []),
    ("add a third generator (more redundancy)", with_changes(GRID, gen3=[["control", "fuel"]], power=[["gen3"]]), []),
    ("battery-backed telecom (seed)", with_changes(GRID, telecom_batt=[]), ["telecom_batt"]),
    ("battery telecom feeds telecom", with_changes(GRID, telecom=[["telecom_batt"]], telecom_batt=[]), ["telecom_batt"]),
    ("black-start hydro unit (seed)", with_changes(GRID, power=[["hydro_bs"]], hydro_bs=[]), ["hydro_bs"]),
]

def and_graph():
    """Pure AND version (one prerequisite set each) for the minimum-seed computation."""
    return {"gen1": ["control", "fuel"], "gen2": ["control", "fuel"], "control": ["power", "telecom"],
            "telecom": ["power"], "fuel": ["power"], "power": ["gen1"]}

def min_seed_sets(g):
    nodes = sorted(g)
    for size in range(len(nodes) + 1):
        hits = [set(c) for c in itertools.combinations(nodes, size)
                if closure({n: [g[n]] for n in nodes}, c) >= set(nodes)]
        if hits: return size, hits
    return None, []

# ---------------- III.B: the bounds gap ----------------
class LCG:
    def __init__(self, seed): self.x = seed & 0xFFFFFFFF
    def next(self):
        self.x = (1664525 * self.x + 1013904223) & 0xFFFFFFFF
        return self.x

def relax_actions(s):
    """Relaxation of the adapt class: trainees do not take workers off production
    (f + m <= N, r <= N independently). Every adapt-class step is dominated by a relaxed step."""
    t, F, P, farm, spec, prog = s
    out = []
    for f in range(k.N + 1):
        for m in range(k.N + 1 - f):
            if m and not farm: continue
            for r in range(k.N + 1):
                if r and farm: continue
                for sp in ([False, True] if not spec else [False]):
                    out.append((f, m, r, sp))
    return out

from functools import lru_cache
@lru_cache(maxsize=None)
def relax_viable(s):
    if s[0] == k.T: return True
    for a in relax_actions(s):
        n = k.step(*s, *a)
        if n is not None and relax_viable(n): return True
    return False

@lru_cache(maxsize=None)
def adapt_actions(farm, spec):
    """The adapt-class action list depends only on (farm, spec)."""
    return tuple(k.actions("adapt", (0, 0, 0, farm, spec, 0)))

def rollout_witness(s, budget, rng):
    for _ in range(budget):
        cur = s; ok = True
        while cur[0] < k.T:
            acts = adapt_actions(cur[3], cur[4])
            a = acts[rng.next() % len(acts)]
            nxt = k.step(*cur, *a)
            if nxt is None: ok = False; break
            cur = nxt
        if ok: return True
    return False

def gap(budget, cert):
    rng = LCG(12345)
    counts = dict(witness=0, excluded=0, unknown=0, unknown_by_sigma=[0]*5, wrong=0)
    for s in k.all_states():
        truth = k.viable("adapt", s)
        excluded = (not k.viable("phys", s)) if cert == "phys" else (not relax_viable(s))
        if excluded:
            counts["excluded"] += 1
            if truth: counts["wrong"] += 1
            continue
        if rollout_witness(s, budget, rng):
            counts["witness"] += 1
            if not truth: counts["wrong"] += 1
        else:
            counts["unknown"] += 1
            counts["unknown_by_sigma"][k.severity(s)] += 1
    return counts

def fmt(names):
    """Lists of names printed as the Lean executable prints them: [a, b]."""
    return "[" + ", ".join(names) + "]"

# ---------------- III.C: timed bootstrap ----------------
# Rules B -> P -> G -> E, seed B. Serial activation needs TAU powered ticks per capability, and a
# capability can be worked on only while its prerequisite is online. B is online (and supplies
# power) only at ticks t < L; afterwards power must come from E.
PRE = {"P": "B", "G": "P", "E": "G"}
TAU = {"P": 3, "G": 4, "E": 3}

def timed_successors(L, s):
    """s = (t, online frozenset of P/G/E, capability under activation or None, progress)."""
    t, on, work, k = s
    out = [(t + 1, on, work, k)]                      # wait
    if t < L or "E" in on:                            # powered
        up = set(on) | ({"B"} if t < L else set())
        for c in ("P", "G", "E"):
            if c not in up and PRE[c] in up:
                k0 = k if work == c else 0
                if k0 + 1 >= TAU[c]:
                    out.append((t + 1, on | {c}, None, 0))
                else:
                    out.append((t + 1, on, c, k0 + 1))
    return out

def earliest_e(L, H):
    front = {(0, frozenset(), None, 0)}
    for n in range(H + 1):
        if any("E" in s[1] for s in front):
            return n
        front = {n2 for s in front for n2 in timed_successors(L, s)}
    return None

def timed_demo():
    print("III.C rules B->P, P->G, G->E; serial activation P=3, G=4, E=3 powered ticks; "
          "power from B while t < L, or from E")
    rules = {c: [[p]] for c, p in PRE.items()}
    up = closure(rules, ["B"])
    print(f"III.C static closure of [B]: {fmt([c for c in 'BPGE' if c in up])}")
    for L in range(13):
        n = earliest_e(L, 20)
        print(f"III.C L={L}: " + ("E never online within 20 ticks" if n is None else f"E online at tick {n}"))

if __name__ == "__main__":
    # Usage: argIII.py [A|B|C|all]. With no argument (or all) demonstrations A and B run, and the
    # output is the same, line for line, as the Lean executable's (results/argIII_output.txt).
    # C prints demonstration III.C, matching `argIII C` (results/argIII_timed_output.txt).
    which = sys.argv[1] if len(sys.argv) > 1 else "all"
    if which not in ("A", "B", "C", "all"):
        sys.exit("usage: argIII.py [A|B|C|all]")
    if which == "C":
        timed_demo()
    if which in ("A", "all"):
        for name, g, seeds in SCENARIOS:
            up = closure(g, seeds)
            print(f"III.A {name}: restored {len(up)}/{len(g)}: {fmt(sorted(up))}")
        size, sets = min_seed_sets(and_graph())
        print(f"III.A minimum seed set (pure AND graph): size {size}; options {fmt(fmt(sorted(x)) for x in sets)}")
    if which in ("B", "all"):
        for cert in ("phys", "relax"):
            for budget in (1, 10, 100, 1000):
                c = gap(budget, cert)
                print(f"III.B cert={cert} budget={budget}: witness {c['witness']} excluded {c['excluded']} unknown {c['unknown']} "
                      f"unknown-by-sigma {c['unknown_by_sigma']} wrong {c['wrong']}", flush=True)
