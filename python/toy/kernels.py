"""
Exact viability kernels for a small enumerated settlement model.

Everything is finite and deterministic, so each kernel K_k(t) is computed
exactly by backward recursion over the full state space. Membership comes
with a witness trajectory; non-membership is an exhaustive exclusion.

State s = (t, F, P, farm, spec, prog)
  x = (F, P)        F: food stock, P: harvest arriving next tick
  O = (farm, spec)  farm: farming capability; spec: foragers specialized
  q = prog          worker-ticks of farm training completed (pending move); once farming is
                    held, consecutive ticks with no farmers (used only when skill decay is on)

Two optional frictions, both off by default (the published model):
  DECAY       farming is lost after this many consecutive ticks with no farmers (0 = never)
  TRAIN_COST  food consumed per trainee-tick
"""
from functools import lru_cache
from itertools import product
import json, sys

# ---------------- parameters ----------------
N = 3                 # workers; each eats 1 food per tick
FMAX = 20             # storage capacity
T = 16                # fixed terminal time
FARM_YIELD = 2        # per farmer, harvested one tick after planting
SPEC_BONUS = 1        # extra forage per specialized forager while wild yield > 0
R = {0: 2, 1: 8}      # worker-ticks of training needed to acquire farming (generalist, specialized)
WILD = [2] * 6 + [1] * 2 + [0] * 8           # exogenous wild yield per forager
DECAY = 0             # skill decay: idle ticks before farming is lost (0 = never)
TRAIN_COST = 0        # food per trainee-tick


def configure(fmax=20, T_=16, spec_bonus=1, r_spec=8, wild=None, decay=0, train_cost=0):
    """Switch to another member of the model family (used by the Experiment E and friction
    sweeps). The defaults restore the base model of I.3.10."""
    global FMAX, T, SPEC_BONUS, R, WILD, DECAY, TRAIN_COST
    FMAX, T, SPEC_BONUS = fmax, T_, spec_bonus
    R = {0: 2, 1: r_spec}
    WILD = list(wild) if wild is not None else [2] * 6 + [1] * 2 + [0] * 8
    DECAY, TRAIN_COST = decay, train_cost
    viable.cache_clear()


@lru_cache(maxsize=None)
def _allocations(n, k):
    return tuple(c for c in product(range(n + 1), repeat=k) if sum(c) == n)


def allocations(n, k):
    """All ways to split n workers over k activities, in enumeration order."""
    return iter(_allocations(n, k))


def step(t, F, P, farm, spec, prog, f, m, r, specialize, phys=False):
    """One tick. f foragers, m farmers, r trainees (rest idle).
    Returns next state, or None on starvation."""
    y = WILD[t]
    if phys:
        forage = f * (y + (SPEC_BONUS if y > 0 else 0))   # best physical technique
    else:
        forage = f * (y + (SPEC_BONUS if (spec and y > 0) else 0))
    raw = F + forage + P - N - TRAIN_COST * r
    if raw < 0:
        return None                                      # starvation: leaves V
    F2 = min(FMAX, raw)                                  # free disposal above capacity
    P2 = FARM_YIELD * m
    spec2 = int(spec or specialize)
    if farm:
        # Skill decay: prog counts consecutive ticks with no farmers; at DECAY farming is lost.
        idle = (0 if m else prog + 1) if DECAY else 0
        if DECAY and idle >= DECAY:
            return (t + 1, F2, P2, 0, spec2, 0)
        return (t + 1, F2, P2, 1, spec2, idle)
    prog2 = prog + r
    # Finish any training earned under the current organization, then credit
    # accumulated training against the threshold of the new organization.
    farm2 = int(prog2 >= min(R[spec], R[spec2]))
    if farm2:
        prog2 = 0
    return (t + 1, F2, P2, farm2, spec2, prog2)


def actions(cls, s):
    t, F, P, farm, spec, prog = s
    if cls == "fixed":                         # incumbent: everyone forages
        yield (N, 0, 0, False)
        return
    if cls == "phys":                          # organization bypassed
        for f, m, i in allocations(N, 3):
            yield (f, m, 0, False)
        return
    if cls == "policy":                        # reallocate within current O
        for f, m, i in allocations(N, 3):
            if m and not farm:
                continue
            yield (f, m, 0, False)
        return
    if cls == "adapt":                         # policy + capability moves
        for f, m, r, i in allocations(N, 4):
            if m and not farm:
                continue
            if r and farm:
                continue
            for sp in ([False, True] if not spec else [False]):
                yield (f, m, r, sp)
        return
    raise ValueError(cls)


@lru_cache(maxsize=None)
def viable(cls, s):
    """True iff some class-cls continuation from s stays in V through T."""
    t = s[0]
    if t == T:
        return True
    for a in actions(cls, s):
        nxt = step(*s, *a, phys=(cls == "phys"))
        if nxt is not None and viable(cls, nxt):
            return True
    return False


def witness(cls, s):
    """A successful continuation (list of (state, action)), or None."""
    if not viable(cls, s):
        return None
    path = []
    while s[0] < T:
        for a in actions(cls, s):
            nxt = step(*s, *a, phys=(cls == "phys"))
            if nxt is not None and viable(cls, nxt):
                path.append((s, a))
                s = nxt
                break
    path.append((s, None))
    return path


CLASSES = ["fixed", "policy", "adapt", "phys"]


def severity(s):
    for i, c in enumerate(CLASSES):
        if viable(c, s):
            return i
    return 4


def baseline(s):
    """Incumbent trajectory until T or first starvation."""
    traj = [s]
    while s[0] < T:
        s = step(*s, N, 0, 0, False)
        if s is None:
            break
        traj.append(s)
    return traj


def points_of_no_return(s0):
    traj = baseline(s0)
    out = {}
    for c in ["policy", "adapt", "phys"]:
        tk = -1
        for s in traj:
            if viable(c, s):
                tk = s[0]
            else:
                break
        out[c] = tk
    t_fail = traj[-1][0] + 1 if traj[-1][0] < T else None
    return traj, out, t_fail


def all_states():
    for t in range(T + 1):
        for F in range(FMAX + 1):
            for P in range(0, FARM_YIELD * N + 1, FARM_YIELD):
                for farm in (0, 1):
                    for spec in (0, 1):
                        for prog in (range(R[spec]) if not farm else range(max(1, DECAY))):
                            yield (t, F, P, farm, spec, prog)


def check_nesting():
    bad, counts = 0, [0] * 5
    for s in all_states():
        v = [viable(c, s) for c in CLASSES]
        if any(v[i] and not v[i + 1] for i in range(3)):
            bad += 1
        counts[severity(s)] += 1
    return bad, counts


def resource_monotone_check():
    """Proposition 4 check: with (O, q) fixed, a richer (F, P) never leaves a kernel the poorer
    state is in. Returns (pairs checked, violations)."""
    checked = viol = 0
    for s in all_states():
        t, F, P, farm, spec, prog = s
        for F2 in range(F, FMAX + 1):
            for P2 in range(P, FARM_YIELD * N + 1, FARM_YIELD):
                s2 = (t, F2, P2, farm, spec, prog)
                if s2 == s:
                    continue
                for c in ("policy", "adapt", "phys"):
                    checked += 1
                    if viable(c, s) and not viable(c, s2):
                        viol += 1
    return checked, viol


def fingerprint_check():
    """Fingerprint check: strong-paradox state pairs (richer state at severity 3, poorer at <= 2,
    same time) all differ in organization or commitments. Returns (pairs, pairs sharing (O, q))."""
    pairs = same = 0
    by_t = {}
    for s in all_states():
        by_t.setdefault(s[0], []).append((s, severity(s)))
    for here in by_t.values():
        poor = [s for s, sig in here if sig <= 2]
        rich = [s for s, sig in here if sig == 3]
        for a in poor:
            for b in rich:
                if b[1] >= a[1] and b[2] >= a[2]:
                    pairs += 1
                    if a[3:] == b[3:]:
                        same += 1
    return pairs, same
