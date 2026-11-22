"""Friction sweep (Python reference): skill decay and training cost over the Experiment E grid.

For each friction setting (decay, train_cost) and every Experiment E setting, five rules run from
s0 = (t=0, F=0, P=0, no farm, generalists). All maximize the food stored over the next two ticks
and replan every tick:

  forage, train   ties favor foraging or training (the Experiment E rules)
  shield          the forage rule restricted to actions whose next state stays in K_adapt
  acqTies         while farming is not held: no specialization, ties favor training; on the first
                  tick farming is held it must specialize; after that, the forage rule
  acqEarly        as acqTies, but while farming is not held it first maximizes the number of
                  trainees (the fastest acquisition that avoids starvation)

The second lookahead tick is maximized over all actions here; the Lean version uses all-forage.
Prints the same text as the Lean executable `friction`.

Usage: friction.py [n]     n: first n settings only (default: all 6,000, several minutes)
"""
import sys
from functools import lru_cache
import kernels as k
from experiment_e import grid

CONFIGS = [(0, 0), (6, 0), (4, 0), (3, 0), (2, 0), (1, 0), (0, 1), (0, 2), (0, 3), (2, 1)]
COLUMNS = ("decay,trainCost,forageLock,forageSurv,trainSurv,shieldSurv,shieldStrict,shieldPrice,"
           "lockDeficit,acqTiesSurv,acqTiesLock,acqEarlySurv,acqEarlyLock")
S0 = (0, 0, 0, 0, 0, 0)
FORAGE = lambda a: (a[0], -a[2], not a[3], a[1])
TRAIN = lambda a: (a[2], a[1], a[0], not a[3])


def run(rule):
    """Returns (trajectory, strict, price)."""
    @lru_cache(maxsize=None)
    def second(s):
        if s[0] == k.T:
            return None
        return max((n[1] for a in k.actions("adapt", s) if (n := k.step(*s, *a)) is not None), default=None)

    def value(n):
        last = second(n)
        return (1, n[1]) if last is None else (2, n[1] + last)

    acquire = rule in ("acqTies", "acqEarly")
    s, traj, strict, price = S0, [S0], False, 0
    while s[0] < k.T:
        acquiring = acquire and not s[3]
        must_specialize = acquire and s[3] and not s[4]
        tie = TRAIN if (rule == "train" or acquiring) else FORAGE
        best_all = best_ok = None
        for a in k.actions("adapt", s):
            if (acquiring and a[3]) or (must_specialize and not a[3]):
                continue
            n = k.step(*s, *a)
            if n is None:
                continue
            pre = a[2] if (rule == "acqEarly" and acquiring) else 0
            rank = (pre, value(n), tie(a), n)
            if best_all is None or rank > best_all:
                best_all = rank
            if (rule != "shield" or k.viable("adapt", n)) and (best_ok is None or rank > best_ok):
                best_ok = rank
        if best_ok is None:
            break
        if best_ok[1] != best_all[1]:
            strict = True
            if best_all[1][0] == best_ok[1][0]:
                price += best_all[1][1] - best_ok[1][1]
        s = best_ok[3]
        traj.append(s)
    return traj, strict, price


def evaluate(decay, cost, setting):
    r_spec, bonus, fmax, T, on, mid = setting
    k.configure(fmax=fmax, T_=T, spec_bonus=bonus, r_spec=r_spec,
                wild=[2] * on + [1] * mid + [0] * (T - on - mid), decay=decay, train_cost=cost)
    runs = {r: run(r) for r in ("forage", "train", "shield", "acqTies", "acqEarly")}
    surv = lambda r: int(runs[r][0][-1][0] == T)
    lock_at = lambda r: next((s[0] for s in runs[r][0] if k.severity(s) == 3), None)
    lock = lambda r: int(lock_at(r) is not None)
    deficit = 0
    L, fo, sh = lock_at("forage"), runs["forage"][0], runs["shield"][0]
    if L is not None and L < len(sh):
        deficit = (fo[L][1] + fo[L][2]) - (sh[L][1] + sh[L][2])
    return (lock("forage"), surv("forage"), surv("train"), surv("shield"), int(runs["shield"][1]),
            runs["shield"][2], deficit, surv("acqTies"), lock("acqTies"), surv("acqEarly"), lock("acqEarly"))


def lines(settings):
    yield f"Friction sweep over {len(settings)} settings of the Experiment E grid"
    yield "  decay: farming is lost after this many consecutive ticks with no farmers (0 = never)"
    yield "  trainCost: food consumed per trainee-tick"
    yield "  forage, train: two-tick stock rules with ties favoring foraging or training"
    yield "  shield: the forage rule restricted to actions whose next state stays in K_adapt"
    yield ("  acqTies: acquire farming (ties favor training), then specialize; "
           "acqEarly: acquire it as fast as possible, then specialize")
    yield ("  shieldStrict: settings where a shield override lowers the two-tick value; "
           "shieldPrice: two-tick value given up, summed")
    yield ("  lockDeficit: forage minus shield food (stock + incoming harvest) "
           "at the forage rule's first lock-in tick, summed")
    yield ""
    yield COLUMNS
    for decay, cost in CONFIGS:
        totals = [0] * 11
        for setting in settings:
            totals = [x + y for x, y in zip(totals, evaluate(decay, cost, setting))]
        yield ",".join(map(str, (decay, cost, *totals)))
    k.configure()


if __name__ == "__main__":
    if len(sys.argv) > 2:
        sys.exit("usage: friction.py [number of settings]")
    settings = grid()
    if len(sys.argv) == 2:
        settings = settings[:int(sys.argv[1])]
    for line in lines(settings):
        print(line, flush=True)
