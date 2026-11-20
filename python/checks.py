"""Robustness checks for the two shortcuts behind the exact-kernel claims."""
import random
from climate import *
random.seed(1)

# An isolated order becomes usable after exactly the declared lead time.
for latency in (1, 2, 3):
    p = P(L=latency, r0=0.0)
    s = s0(p)
    for t in range(latency + 1):
        assert s[3] == p.D0 + (0.5 if t == latency else 0.0)
        s = step(p, s, 0.5 if t == 0 else 0.0)

p = P()
over_budget = (p.T, 1.0, p.budget + 1.0, p.D0, ())
assert not viable(p, "adapt", over_budget) and cert_reason(p, over_budget) == 1

# 1. Max deployment dominates: random sub-maximal deployment never keeps a state viable that max deployment loses.
def step_frac(p, s, x, frac, capped=True, phi=None):
    t, f, C, D, pipe = s
    full = step(p, s, x, capped, 1.0, phi)
    if full is None: return None
    f2 = f + frac * (full[1] - f)
    return (full[0], f2, full[2], full[3], full[4])

def run_frac(p, s, r, fracs, phi=None):
    rule = grow(p, r, phi=phi)
    i = 0
    while s[0] < p.T:
        s = step_frac(p, s, rule(s), fracs[i % len(fracs)], True, phi); i += 1
        if s is None or s[2] > p.budget + 1e-9: return False
    return s[1] >= 1 - 1e-9

viol = 0; tests = 0
for B in (510, 1035, 1035 * 0.45 / 0.63):
    for psi in (0.5, 1.0):
        p = P(budget=B, psi=psi)
        tr = baseline(p)
        for s in tr[:25]:
            for r in (0.0, 0.1, 0.2, 0.3):
                maxok = run(p, s, grow(p, r))[0]
                for _ in range(20):
                    fr = [random.choice([1.0, 1.0, 0.9, 0.7, 0.5, 0.0]) for _ in range(8)]
                    tests += 1
                    if run_frac(p, s, r, fr) and not maxok: viol += 1
print(f"1. dominance of max deployment: {tests} random sub-maximal schedules, {viol} beat max deployment")

# 2. Constant-rate programs vs two-phase programs (r1 for k years, then r2).
def run_two(p, s, r1, r2, k):
    t0 = s[0]
    rule1, rule2 = grow(p, r1), grow(p, r2)
    while s[0] < p.T:
        rule = rule1 if s[0] - t0 < k else rule2
        s = step(p, s, rule(s))
        if s is None or s[2] > p.budget + 1e-9: return False
    return s[1] >= 1 - 1e-9

grid = [i * 0.05 for i in range(7)]   # 0..0.30
extra = 0; checked = 0
for B in (1035, 1035 * 0.45 / 0.63):
    for psi in (0.5, 0.75, 1.0):
        p = P(budget=B, psi=psi)
        for s in baseline(p)[:30]:
            if s[2] > p.budget: break
            if viable(p, "adapt", s): continue
            checked += 1
            if any(run_two(p, s, r1, r2, k) for r1 in grid for r2 in grid for k in (2, 4, 6, 8)):
                extra += 1
print(f"2. states excluded by constant-rate programs: {checked}; rescued by some two-phase program: {extra}")
if viol or extra:
    raise SystemExit("A tested schedule contradicts the reported robustness results.")
