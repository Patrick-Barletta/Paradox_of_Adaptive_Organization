"""Argument VI, Part II: the joint system of three agents on a shared recovery chain (Python reference).

Prints the same text as the Lean executable `argVI multi` (results/argVI_multi_output.txt). Part I of
Argument VI (the four control classes on the tick-level state, `argVI` without arguments) is computed
in Lean only and has no Python mirror.
"""
from functools import lru_cache

H = 12   # horizon in crises


# ---------------------------------------------------------------------------------------------
# Part II: the joint system of three agents on a shared recovery chain (`python argVI.py multi`,
# results/argVI_multi_output.txt; Lean: `argVI multi`, theory in Paradox/SharedRatchet.lean).
#
# Joint state s = (x, O, q) of I.3.1: x = the shared service is up (A0: viability depends only on x);
# q = segment depths (n1, n2, n3), the serial stages each agent's patches have added; O includes
# whether the independent seed is authorized. States are tuples (n1, n2, n3, auth); None is "down".
# Each cycle, in a chain escape, every agent patches its segment (delta * n ticks, depth n -> n + 1),
# prunes it (1 + lam * n ticks, depth -> 0) or takes the null action (withholds its segment: the chain
# escape fails). The joint escape takes l0 plus the three segment times and must fit the deadline D.
# Agent 1 may instead escape through the seed (1 tick, depths unchanged) when it is admissible
# (authorized; in the physical class, present), and may propose authorizing it (ALPHA extra ticks this
# cycle, effective next cycle). Governance: none (no seed), unilateral, unanimous (partners vote yes).
# Control classes (I.3.3), per agent: agent 1 adapt; a partner adapt (C, chosen with agent 1) or fixed
# (N, its incumbent routine, votes yes). An adversary (A) is a disturbance (I.3.8) over the
# disturbance set W: any segment action and vote, except withholding unless overt. The kernel is the
# robust kernel: exists (agent 1, adapt partners) for all disturbances, escape and stay in the kernel
# for one cycle fewer. The physical class frees routines (N -> C) and admits the seed unauthorized.

ALPHA = 2
PATCH, PRUNE, IDLE = 0, 1, 2
GOVS = ("none", "unilateral", "unanimous")
CMOVES = [(False, PATCH, False), (False, PATCH, True), (True, PATCH, False), (True, PATCH, True),
          (False, PRUNE, False), (False, PRUNE, True)]     # (seed escape, own segment, propose)
CNAMES = ["chain patch", "chain patch + propose", "seed", "seed + propose", "chain prune", "chain prune + propose"]
ALLP = [(sg, v) for sg in (PATCH, PRUNE) for v in (True, False)]
PROFILES = ["CC", "CN", "NN", "CA", "NA", "AA"]          # classes of partners 2 and 3
ORIGIN = (0, 0, 0, False)


def phys_prof(pr):
    """The physical class frees routines: a fixed (N) partner becomes adapt (C)."""
    return pr.replace("N", "C")


class Shared:
    def __init__(self, D, l0, delta, lam, gov, routine="patch", phys=False, overt=False):
        self.D, self.l0, self.delta, self.lam, self.gov = D, l0, delta, lam, gov
        self.routine, self.phys, self.overt = routine, phys, overt

    def seg_time(self, sg, n): return self.delta * n if sg == PATCH else 1 + self.lam * n
    def seed_avail(self, x): return self.gov != "none" and (x[3] or self.phys)
    def proposes(self, x, m1): return m1[2] and not x[3] and self.gov != "none"

    def admissible(self, x, m1):
        """Agent 1's admissible actions: the seed escape needs it to be admissible, a proposal a seed
        not yet authorized."""
        return (not m1[0] or self.seed_avail(x)) and (not m1[2] or (self.gov != "none" and not x[3]))

    def out(self, x, m1, m2, m3):
        """Next functioning state, or None if the service goes down."""
        pr = self.proposes(x, m1)
        a = x[3] or (pr and (self.gov == "unilateral" or (m2[1] and m3[1])))
        cost = ALPHA if pr else 0
        if m1[0]:
            return (x[0], x[1], x[2], a) if 1 + cost <= self.D else None
        if IDLE in (m1[1], m2[0], m3[0]):
            return None
        d = self.l0 + self.seg_time(m1[1], x[0]) + self.seg_time(m2[0], x[1]) + self.seg_time(m3[0], x[2]) + cost
        nx = lambda sg, n: n + 1 if sg == PATCH else 0
        return (nx(m1[1], x[0]), nx(m2[0], x[1]), nx(m3[0], x[2]), a) if d <= self.D else None

    def rout(self, n): return (PRUNE if self.routine == "prune2" and n >= 2 else PATCH, True)

    def pmoves(self, x, m1):
        """Partner actions that can change the outcome of m1 (restoring the segment)."""
        segs = [PATCH] if m1[0] else [PATCH, PRUNE]
        votes = [True, False] if self.proposes(x, m1) and self.gov == "unanimous" else [True]
        return [(sg, v) for sg in segs for v in votes]

    def wmoves(self, x, m1):
        """The adversary's disturbance set: with `overt`, withholding the segment as well."""
        pm = self.pmoves(x, m1)
        return pm + [(IDLE, True), (IDLE, False)] if self.overt and not m1[0] else pm

    def reachable(self):
        """All functioning states reachable from the origin under admissible actions."""
        seen, frontier = {ORIGIN}, [ORIGIN]
        while frontier:
            nxt = []
            for x in frontier:
                for m1 in CMOVES:
                    if not self.admissible(x, m1):
                        continue
                    for m2 in ALLP:
                        for m3 in ALLP:
                            y = self.out(x, m1, m2, m3)
                            if y is not None and y not in seen:
                                seen.add(y)
                                nxt.append(y)
            frontier = nxt
        return sorted(seen)

    def move_ok(self, prof, x, m1, prev):
        """m1 is admissible, and some adapt-partner choice makes every disturbance lead to a
        functioning state in `prev`."""
        if not self.admissible(x, m1):
            return False
        s2, s3 = prof
        pm, wm = self.pmoves(x, m1), self.wmoves(x, m1)
        r2, r3 = self.rout(x[1]), self.rout(x[2])
        for c2 in (pm if s2 == "C" else [None]):
            for c3 in (pm if s3 == "C" else [None]):
                good = True
                for a2 in (wm if s2 == "A" else [None]):
                    m2 = c2 if s2 == "C" else r2 if s2 == "N" else a2
                    for a3 in (wm if s3 == "A" else [None]):
                        m3 = c3 if s3 == "C" else r3 if s3 == "N" else a3
                        y = self.out(x, m1, m2, m3)
                        if y is None or not prev(y):
                            good = False
                            break
                    if not good:
                        break
                if good:
                    return True
        return False

    def layers(self, prof, states):
        """layers[k][x]: x is in the robust kernel for k more cycles."""
        lay = [{x: True for x in states}]
        for _ in range(H):
            prev = lay[-1]
            lay.append({x: any(self.move_ok(prof, x, m1, prev.__getitem__) for m1 in CMOVES) for x in states})
        return lay

    def myopic(self, prof, k, x=ORIGIN):
        """Cycles guaranteed (up to k) when agent 1 takes the first action, in CMOVES order, that
        escapes this cycle against every disturbance (assignment with no adapt partner)."""
        if k == 0:
            return 0
        m1 = next((m for m in CMOVES if self.move_ok(prof, x, m, lambda y: True)), None)
        if m1 is None:
            return 0
        s2, s3 = prof
        wm = self.wmoves(x, m1)
        worst = k - 1
        for a2 in (wm if s2 == "A" else [None]):
            m2 = self.rout(x[1]) if s2 == "N" else a2
            for a3 in (wm if s3 == "A" else [None]):
                m3 = self.rout(x[2]) if s3 == "N" else a3
                y = self.out(x, m1, m2, m3)
                if y is not None:
                    worst = min(worst, self.myopic(prof, k - 1, y))
        return 1 + worst

    def phys_horizons(self):
        """Survival of each assignment in the physical class."""
        m = Shared(self.D, self.l0, self.delta, self.lam, self.gov, self.routine, True, self.overt)
        st = m.reachable()
        return [horizon(m.layers(phys_prof(pr), st)) for pr in PROFILES]


def horizon(lay):
    return max(k for k in range(H + 1) if lay[k][ORIGIN])


def multi_lines():
    yield "Argument VI, Part II: the joint system of three agents on a shared recovery chain"
    yield (f"  agent 1 in the adapt class; partners 2 and 3 each adapt (C), fixed (N: incumbent routine, votes yes) "
           f"or adversarial (A: a disturbance, I.3.8, covert unless stated); authorization costs {ALPHA} ticks of the "
           f"current crisis and takes effect next cycle; horizon {H} cycles")
    yield ("REFERENCE D=7, l0=2, delta=2, prune time 1+2n per segment, neutral routine patch; "
           "cycles survived from the origin, by classes of partners 2 and 3 (C adapt, N fixed, A adversary)")
    for gov in GOVS:
        m = Shared(7, 2, 2, 2, gov)
        st = m.reachable()
        yield f"GOV {gov}: " + ", ".join(f"C{pr} {horizon(m.layers(pr, st))}" for pr in PROFILES)
    row = lambda hs: ", ".join(f"C{pr} {h}" for pr, h in zip(PROFILES, hs))
    yield ("GOV none, physical class (routines freed; no seed present): "
           + row(Shared(7, 2, 2, 2, "none").phys_horizons()))
    yield ("GOV unanimous, physical class (routines freed; seed admissible unauthorized): "
           + row(Shared(7, 2, 2, 2, "unanimous").phys_horizons()))
    m = Shared(7, 2, 2, 2, "unilateral")
    st = m.reachable()
    lay = m.layers("NA", st)
    first = next(i for i, m1 in enumerate(CMOVES) if m.move_ok("NA", ORIGIN, m1, lay[H - 1].__getitem__))
    yield (f"FIRST MOVE unilateral CNA (first action in preference order that keeps the origin in the kernel): "
           f"{CNAMES[first]}; with one-cycle lookahead agent 1 guarantees {m.myopic('NA', H)} of {H} cycles")
    yield "BOUNDS reference: one neutral patcher floor((D-l0)/delta)+1 = 3; two patchers floor((D-l0)/(2*delta))+1 = 2"

    def bnd(D, l0, g): return (D - l0) // g + 1
    base = [(D, l0, d, lamk) for D in range(4, 13) for l0 in range(1, 5) for d in range(1, 4) for lamk in (0, 1, 2)]
    yield (f"SWEEP D=4..12, l0=1..4, delta=1..3, prune slope lam in (0, delta, 2*delta); {len(base)} configurations, "
           f"each under 3 governance rules and 2 neutral routines (patch; prune at depth 2)")
    hz = {}
    checks = viol = 0
    pairs = [("CN", "CC"), ("CA", "CN"), ("NN", "CN"), ("NA", "NN"), ("NA", "CA"), ("AA", "NA")]
    phys_unan, phys_none, overt, myo = {}, {}, {}, {}
    for c in base:
        D, l0, d, lamk = c
        for gov in GOVS:
            for routine in ("patch", "prune2"):
                m = Shared(D, l0, d, lamk * d, gov, routine)
                st = m.reachable()
                lay = {pr: m.layers(pr, st) for pr in PROFILES}
                for pr in PROFILES:
                    hz[c, gov, routine, pr] = horizon(lay[pr])
                for small, big in pairs:
                    for k in range(H + 1):
                        for x in st:
                            checks += 1
                            viol += lay[small][k][x] and not lay[big][k][x]
        phys_unan[c] = Shared(D, l0, d, lamk * d, "unanimous").phys_horizons()[4]
        phys_none[c] = Shared(D, l0, d, lamk * d, "none").phys_horizons()
        for gov in GOVS:
            mo = Shared(D, l0, d, lamk * d, gov, overt=True)
            st = mo.reachable()
            for pr in ("CA", "NA", "AA"):
                overt[c, gov, pr] = horizon(mo.layers(pr, st))
        myo[c] = Shared(D, l0, d, lamk * d, "unilateral").myopic("NA", H)
    yield (f"NESTING kernel inclusions adversary <= fixed <= adapt (6 substitutions, every reachable state, "
           f"horizons 0..{H}): {checks} checks, {viol} violations")
    for gov in GOVS:
        for routine in ("patch", "prune2"):
            yield (f"SURVIVAL gov={gov} routine={routine}: " + ", ".join(
                f"C{pr} {sum(hz[c, gov, routine, pr] == H for c in base)}" for pr in PROFILES)
                + f" (configurations surviving all {H} cycles, of {len(base)})")

    def h(c, pr, gov="none"): return hz[c, gov, "patch", pr]
    yield (f"BOUND no seed, routine patch, CCN: cycles survived <= floor((D-l0)/delta)+1 in "
           f"{sum(h(c, 'CN') <= bnd(c[0], c[1], c[2]) for c in base)}, equal in "
           f"{sum(h(c, 'CN') == min(H, bnd(c[0], c[1], c[2])) for c in base)}; CNN: <= floor((D-l0)/(2*delta))+1 in "
           f"{sum(h(c, 'NN') <= bnd(c[0], c[1], 2 * c[2]) for c in base)}, equal in "
           f"{sum(h(c, 'NN') == min(H, bnd(c[0], c[1], 2 * c[2])) for c in base)} (of {len(base)})")
    yield (f"BOUND CNA, routine patch: <= floor((D-l0)/(2*delta))+1 with no seed in "
           f"{sum(h(c, 'NA') <= bnd(c[0], c[1], 2 * c[2]) for c in base)} and under unanimity in "
           f"{sum(h(c, 'NA', 'unanimous') <= bnd(c[0], c[1], 2 * c[2]) for c in base)}; unanimity gives the no-seed "
           f"survival in {sum(h(c, 'NA', 'unanimous') == h(c, 'NA') for c in base)}")

    def sev(i, pr):
        out = [c for c in base if h(c, pr) < H]
        return (f"C{pr} {len(out)} (severity 3: {sum(phys_none[c][i] == H for c in out)}, "
                f"severity 4: {sum(phys_none[c][i] < H for c in out)})")
    yield (f"SEVERITY no seed, routine patch, outside the {H}-cycle kernel: "
           + ", ".join(sev(i, pr) for i, pr in enumerate(PROFILES)))
    yield (f"NEUTRAL vs ADVERSARY no seed: replacing fixed partner 3 by an adversary leaves survival unchanged in "
           f"{sum(h(c, 'NA') == h(c, 'NN') for c in base)} (routine patch) and "
           f"{sum(hz[c, 'none', 'prune2', 'NA'] == hz[c, 'none', 'prune2', 'NN'] for c in base)} (routine prune2) "
           f"of {len(base)}")
    veto = [c for c in base if h(c, 'NN', 'unanimous') == H and h(c, 'NA', 'unanimous') < H]
    yield (f"VETO unanimity, routine patch: CNN survives all {H} cycles and CNA does not in {len(veto)}; "
           f"the physical class survives all {H} in {sum(phys_unan[c] == H for c in veto)} of them (severity 3)")
    early = [c for c in base if c[1] + ALPHA + 2 <= c[0]]
    yield (f"UNILATERAL CNA, routine patch: survives all {H} cycles in {sum(h(c, 'NA', 'unilateral') == H for c in base)}; "
           f"early-authorization condition l0+alpha+2 <= D holds in {len(early)}, of which surviving "
           f"{sum(h(c, 'NA', 'unilateral') == H for c in early)}; one-cycle lookahead survives all {H} in "
           f"{sum(myo[c] == H for c in base)}")
    ov = "; ".join(f"{gov} " + ", ".join(f"C{pr} {sum(overt[c, gov, pr] == H for c in base)}" for pr in ("CA", "NA", "AA"))
                   for gov in GOVS)
    first_cycle = sum(any(overt[c, gov, pr] > 0 for gov in GOVS for pr in ("CA", "NA", "AA")) for c in base)
    yield (f"OVERT adversary (may withhold its segment), routine patch: surviving all {H} cycles: {ov}; "
           f"surviving the first cycle: {first_cycle} of {len(base)} under any rule")


if __name__ == "__main__":
    for line in multi_lines():
        print(line, flush=True)
