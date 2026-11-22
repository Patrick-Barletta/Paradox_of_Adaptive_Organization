"""Argument VI: the escape ratchet (Python reference).

Each cycle a crisis arrives with a deadline D ticks away, and the organization must complete one
escape transition in time. The state between cycles is (chain depth n, reserves R, seed authorized).

  patch       duration = serial bootstrap time through the chain Seed -> Stage 1 -> ... -> Stage n
              (seed stage l0 ticks, each stage delta ticks); free; depth n -> n + 1
  prune       duration l0 + 1 + lam * n; costs PRUNE_COST reserves; depth n -> 0
  seed escape duration 1; free; depth unchanged (bypasses the chain); needs an authorized seed
  authorize   optional, alongside the cycle's escape: costs AUTH_COST reserves, needs the seed to be
              physically present; the seed can be used from the next cycle
Reserves: R' = min(CAP, R - costs + INCOME). The physical class may also use the seed escape
whenever the seed is physically present, authorized or not (the organizational restriction is the
authorization requirement; costs, durations and dynamics are identical).

Durations are computed by tick-level search: the bootstrap time by searching the serial chain (work
only on the next stage), and each escape's feasibility by searching the deadline-escape system
(start a transition, work on it, idle; fail when the deadline arrives undone). Cycle kernels are
computed by backward recursion over H cycles.

Prints the same text as the Lean executable `argVI` (results/argVI_output.txt).
"""
from functools import lru_cache

CAP, INCOME, PRUNE_COST, AUTH_COST, H = 4, 1, 2, 3, 12


@lru_cache(maxsize=None)
def chain_time(l0, delta, n):
    """Minimum ticks to complete the seed stage and n further stages, serially (search)."""
    tau = lambda i: l0 if i == 0 else delta
    frontier, t = {(0, 0)}, 0
    while True:
        if any(k == n + 1 for k, _ in frontier):
            return t
        nxt = set()
        for k, p in frontier:
            nxt.add((k, p))                                    # wait
            if k <= n:
                nxt.add((k + 1, 0) if p + 1 == tau(k) else (k, p + 1))
        frontier, t = nxt, t + 1


@lru_cache(maxsize=None)
def escapes(d, D):
    """Can a transition of duration d be completed before a deadline D ticks away? (search over
    the deadline-escape system: states (ticks left, remaining work or None, done))."""
    frontier = {(D, None, False)}
    for _ in range(D + 1):
        if any(done for _, _, done in frontier):
            return True
        nxt = set()
        for r, w, done in frontier:
            if r == 0:
                continue                                       # deadline reached undone: not viable
            nxt.add((r - 1, None, False) if w is None else (r - 1, None, True) if w == 1 else (r - 1, w - 1, False))
            if w is None:
                nxt.add((r - 1, None, True) if d == 1 else (r - 1, d - 1, False))
        frontier = nxt
    return any(done for _, _, done in frontier)


class Model:
    def __init__(self, D, l0, delta, lam, seed):
        self.D, self.l0, self.delta, self.lam, self.seed = D, l0, delta, lam, seed

    def patch_time(self, n): return chain_time(self.l0, self.delta, n)
    def prune_time(self, n): return self.l0 + 1 + self.lam * n

    def options(self, x, phys):
        """Feasible (name, next state) pairs from x = (n, R, auth), in preference order."""
        n, R, auth = x
        out = []
        escs = [("patch", self.patch_time(n), 0, n + 1)]
        if auth or (phys and self.seed):
            escs.append(("seed", 1, 0, n))
        escs.append(("prune", self.prune_time(n), PRUNE_COST, 0))
        for name, d, cost, n2 in escs:
            if not escapes(d, self.D):
                continue
            for authorize in (False, True):
                if authorize and (auth or not self.seed):
                    continue
                c = cost + (AUTH_COST if authorize else 0)
                if R < c:
                    continue
                out.append((name + ("+auth" if authorize else ""), (min(n2, H + 1), min(CAP, R - c + INCOME), auth or authorize)))
        return out

    @lru_cache(maxsize=None)
    def kernel(self, x, k, phys):
        """Viable for k more cycles."""
        if k == 0:
            return True
        return any(self.kernel(y, k - 1, phys) for _, y in self.options(x, phys))

    def run(self, x0, policy, h=None):
        """Follow a policy for H cycles. Returns (cycles survived, trajectory of states)."""
        x, traj = x0, [x0]
        for c in range(H):
            opts = dict(self.options(x, False))
            if policy == "patch":
                y = opts.get("patch")
            elif policy in ("prune1", "prune2"):
                q = int(policy[-1])
                y = opts.get("prune" if x[0] >= q else "patch")
            elif policy == "seed":
                y = opts.get("seed") or (opts.get("patch+auth") if not x[2] else None) or opts.get("patch")
            else:   # planner with lookahead h cycles
                k = min(h, H - c) - 1
                y = next((y for _, y in self.options(x, False) if self.kernel(y, k, False)), None)
            if y is None:
                return c, traj
            x = y
            traj.append(x)
        return H, traj


def bound(D, l0, delta):
    return (D - l0) // delta + 1 if l0 <= D else 0


def ref_lines():
    m = Model(7, 2, 2, 2, True)
    yield "REFERENCE D=7, l0=2, delta=2, prune time 3+2n, seed physically present but not authorized, reserves start at 4"
    for n in range(5):
        p, q = m.patch_time(n), m.prune_time(n)
        yield (f"REGIME n={n}: bootstrap {p} ticks, patch {'feasible' if escapes(p, 7) else 'infeasible'}; "
               f"prune {q} ticks, {'feasible' if escapes(q, 7) else 'infeasible'}")
    yield f"REFERENCE first infeasible patch cycle {next(n for n in range(H) if not escapes(m.patch_time(n), 7))}; bound floor((D-l0)/delta)+1 = {bound(7, 2, 2)}"
    x3 = (3, 4, False)
    adapt, phys = m.kernel(x3, H - 3, False), m.kernel(x3, H - 3, True)
    sev = 3 if (phys and not adapt) else 4 if not phys else "<3"
    yield f"WITNESS regime 3 (n=3, R=4, seed not authorized): adaptive kernel {int(adapt)}, physical kernel {int(phys)}, severity {sev}"
    m2 = Model(7, 2, 2, 2, False)
    a2, p2 = m2.kernel(x3, H - 3, False), m2.kernel(x3, H - 3, True)
    yield f"WITNESS without a seed: adaptive kernel {int(a2)}, physical kernel {int(p2)}, severity {3 if (p2 and not a2) else 4 if not p2 else '<3'}"
    x0 = (0, 4, False)
    for pol, h in (("patch", None), ("prune1", None), ("prune2", None), ("seed", None),
                   ("plan", 1), ("plan", 2), ("plan", 3), ("plan", H)):
        c, traj = m.run(x0, pol, h)
        name = pol if h is None else f"planner h={h}"
        yield f"POLICY {name}: survives {c} of {H} cycles; depths {[x[0] for x in traj]}"


def sweep_lines():
    Ds, L0s, deltas = range(4, 13), range(1, 5), range(1, 4)
    R0s = (0, 2, 4)
    configs = [(D, l0, d, lamk, seed, R0) for D in Ds for l0 in L0s for d in deltas
               for lamk in (0, 1, 2) for seed in (False, True) for R0 in R0s]
    yield (f"SWEEP D=4..12, l0=1..4, delta=1..3, prune slope lam in (0, delta, 2*delta), seed absent/present, "
           f"reserves start 0/2/4; {len(configs)} configurations, horizon {H} cycles")
    bound_ok = bound_n = 0
    sev3 = sev4 = early = survives = recoverable = 0
    surv = {k: 0 for k in ("patch", "prune1", "prune2", "seed", "plan1", "plan2", "plan3", f"plan{H}")}
    by_lam = {k: [0, 0] for k in (0, 1, 2)}
    escapes_before = {}
    latest_prune = {}
    avoided = []
    for D, l0, d, lamk, seed, R0 in configs:
        m = Model(D, l0, d, lamk * d, seed)
        x0 = (0, R0, False)
        if l0 <= D:
            bound_n += 1
            first = next((n for n in range(H + 2) if not escapes(m.patch_time(n), D)), None)
            bound_ok += first == bound(D, l0, d)
        c, traj = m.run(x0, "patch")
        excl = next((i for i, x in enumerate(traj + [None]) if x is None or not m.kernel(x, H - i, False)), None)
        if excl is None or excl >= len(traj):
            if c == H:
                survives += 1
            else:
                recoverable += 1
        else:
            x = traj[excl]
            phys = m.kernel(x, H - excl, True)
            if phys:
                sev3 += 1
            else:
                sev4 += 1
            early += excl < c
            escapes_before[excl] = escapes_before.get(excl, 0) + 1
        lp = max((n for n, x in enumerate(traj) if escapes(m.prune_time(x[0]), D) and x[1] >= PRUNE_COST), default=-1)
        latest_prune[lp] = latest_prune.get(lp, 0) + 1
        for pol in ("patch", "prune1", "prune2", "seed"):
            surv[pol] += m.run(x0, pol)[0] == H
        for h in (1, 2, 3, H):
            ok = m.run(x0, "plan", h)[0] == H
            surv[f"plan{h}"] += ok
            if h == H:
                by_lam[lamk][0] += ok
                by_lam[lamk][1] += 1
                if ok and m.run(x0, "patch")[0] < H and len(avoided) < 4:
                    avoided.append((D, l0, d, lamk * d, seed, R0))
    yield f"BOUND first infeasible patch cycle equals floor((D-l0)/delta)+1 in {bound_ok} of {bound_n} configurations with l0 <= D"
    yield (f"LOCKIN patch-only: survives all {H} cycles in {survives}; fails while its state is still in the adaptive "
           f"kernel in {recoverable}; leaves the adaptive kernel in {sev3 + sev4}, with the physical kernel holding there "
           f"(severity 3) in {sev3} and not (severity 4) in {sev4}, and before the patch failure in {early}")
    yield "LOCKIN cycle of first exclusion (= successful escapes before it): " + ", ".join(
        f"{k}: {v}" for k, v in sorted(escapes_before.items()))
    yield "PRUNE latest cycle on the patch-only path at which pruning is still feasible (-1 = never): " + ", ".join(
        f"{k}: {v}" for k, v in sorted(latest_prune.items()))
    yield ("SURVIVAL policies surviving all " + str(H) + " cycles: " + ", ".join(f"{k} {v}" for k, v in surv.items())
           + f" (of {len(configs)})")
    yield "SENSITIVITY planner (full lookahead) survival by prune slope: " + ", ".join(
        f"lam={['0', 'delta', '2*delta'][k]} {v[0]}/{v[1]}" for k, v in by_lam.items())
    for D, l0, d, lam, seed, R0 in avoided:
        m = Model(D, l0, d, lam, seed)
        c, traj = m.run((0, R0, False), "plan", H)
        yield (f"AVOIDED D={D} l0={l0} delta={d} lam={lam} seed={int(seed)} R0={R0}: patch-only fails at cycle "
               f"{m.run((0, R0, False), 'patch')[0]}, planner survives {c}; depths {[x[0] for x in traj]}")


def lines():
    yield "Argument VI: the escape ratchet"
    yield (f"  reserves capped at {CAP}, income {INCOME} per cycle; prune costs {PRUNE_COST}; authorizing the seed costs {AUTH_COST} "
           f"and takes effect next cycle; horizon {H} cycles")
    yield from ref_lines()
    yield from sweep_lines()


if __name__ == "__main__":
    for line in lines():
        print(line, flush=True)
