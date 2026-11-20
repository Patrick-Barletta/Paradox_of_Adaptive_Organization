"""Experiment E (Python reference): prevalence of the paradox within the model family.

For each parameter setting, two histories start from s0 = (t=0, F=0, P=0, no farm, generalists):
A stays generalist, B specializes at t = 0, and both then run the incumbent policy.
Two additional histories maximize the next two ticks' stored food and differ only in
their tie-breaking rules. The full run checks the grid and the complete text summary.

Usage: experiment_e.py [n]
  n     check only the first n settings (default: all 6,000, about half a minute)
"""
import csv, sys
from functools import lru_cache
from itertools import product, zip_longest
from pathlib import Path
import kernels as k

S0 = (0, 0, 0, 0, 0, 0)
COLUMNS = ("rSpec bonus fmax T on mid tA_adapt tB_adapt tA_phys tB_phys "
           "usefulA usefulB grossA grossB stockDom earlier paradox grossOnly strong "
           "forageFirstLock trainFirstLock forageSurvives trainSurvives "
           "forageStrongVsA trainStrongVsA").split()
AXES = [
    ("rSpec", "By specialist retraining cost rSpec (generalists: 2)", range(1, 11)),
    ("bonus", "By specialization bonus", (1, 2)),
    ("fmax", "By storage capacity fmax", (12, 16, 20, 24, 30)),
    ("T", "By horizon T", (12, 14, 16, 18, 20)),
    ("on", "By ticks of full wild yield before decline", range(3, 7)),
    ("mid", "By ticks of half wild yield", range(3)),
]

def grid():
    return list(product(*(values for _, _, values in AXES)))

def stock_history(tie):
    """Enumerate all admissible first and second actions. Replan after the first."""
    @lru_cache(maxsize=None)
    def best_second_stock(s):
        if s[0] == k.T:
            return None
        return max((n[1] for a in k.actions("adapt", s)
                    if (n := k.step(*s, *a)) is not None), default=None)

    s, traj = S0, [S0]
    while s[0] < k.T:
        best_rank, chosen = None, None
        for a in k.actions("adapt", s):
            n = k.step(*s, *a)
            if n is None:
                continue
            last = best_second_stock(n)
            value = (1, n[1]) if last is None else (2, n[1] + last)
            f, m, r, sp = a
            tie_rank = (f, -r, not sp, m) if tie == "forage" else (r, m, f, not sp)
            rank = (value, tie_rank)
            if best_rank is None or rank > best_rank:
                best_rank, chosen = rank, n
        if chosen is None:
            break
        s = chosen
        traj.append(s)
    return traj

def strong_vs_generalist(A, path):
    return any(b[1] >= a[1] and b[2] >= a[2] and k.severity(b) == 3 and k.severity(a) <= 2
               for a, b in zip(A, path))

def first_lock(path):
    return next((s[0] for s in path if k.severity(s) == 3), -1)

def history(specialize_first):
    """Run the incumbent from s0 until T or first starvation."""
    s, traj = S0, [S0]
    while s[0] < k.T:
        s = k.step(*s, k.N, 0, 0, specialize_first and s[0] == 0)
        if s is None: break
        traj.append(s)
    return traj

def pnr(cls, traj):
    tk = -1
    for s in traj:
        if k.viable(cls, s): tk = s[0]
        else: break
    return tk

def harvest(traj):
    """(gross harvest, useful harvest = gross minus food discarded at the storage cap)."""
    gross = useful = 0
    for s, nxt in zip(traj, traj[1:]):
        y = k.WILD[s[0]]
        out = k.N * (y + (k.SPEC_BONUS if (s[4] and y > 0) else 0))
        gross += out
        useful += out - (s[1] + out + s[2] - k.N - nxt[1])
    return gross, useful

def evaluate(setting):
    """One row of the results file, as a list of strings."""
    r_spec, bonus, fmax, T, on, mid = setting
    k.configure(fmax=fmax, T_=T, spec_bonus=bonus, r_spec=r_spec,
                wild=[2] * on + [1] * mid + [0] * (T - on - mid))
    A, B = history(False), history(True)
    pairs = list(zip(A, B))
    stock_dom = (all(b[1] >= a[1] for a, b in pairs) and any(b[1] > a[1] for a, b in pairs)
                 and len(B) >= len(A))
    tA, tB = pnr("adapt", A), pnr("adapt", B)
    earlier = tB < tA
    (gA, uA), (gB, uB) = harvest(A), harvest(B)
    strong = strong_vs_generalist(A, B)
    flags = [stock_dom, earlier, stock_dom and earlier, earlier and not stock_dom and gB > gA, strong]
    forage, train = stock_history("forage"), stock_history("train")
    decisions = (first_lock(forage), first_lock(train), forage[-1][0] == T, train[-1][0] == T,
                 strong_vs_generalist(A, forage), strong_vs_generalist(A, train))
    return [str(int(v)) for v in (*setting, tA, tB, pnr("phys", A), pnr("phys", B),
                                  uA, uB, gA, gB, *flags, *decisions)]

def percent(count, size):
    if size == 0:
        return "  n/a"
    tenths = (1000 * count + size // 2) // size
    return f"{tenths // 10}.{tenths % 10}%".rjust(7)

def summary_lines(rows):
    def count(group, name):
        return sum(row[name] for row in group)

    def breakdown(group, key, title, values):
        yield ""
        yield title
        yield "  value   settings   pairwise tradeoff   strong pair   gross-only"
        for value in values:
            subset = [r for r in group if r[key] == value]
            size = len(subset)
            tradeoff, strong, gross = (percent(count(subset, name), size)
                                       for name in ("paradox", "strong", "grossOnly"))
            yield f"  {value}\t  {size}\t     {tradeoff}\t       {strong}\t   {gross}"

    total = len(rows)
    yield f"Experiment E: {total} parameter settings (generalist retraining fixed at 2 worker-ticks)"
    for name, label in (
        ("paradox", "prescribed pair (stock dominance + earlier window close): "),
        ("strong", "strong pair (richer B locked in while A can reorganize):              "),
        ("grossOnly", "gross-only paradox (window closes earlier, no storage dominance):      "),
    ):
        n = count(rows, name)
        yield f"  {label}{n} ({percent(n, total)})"
    low = [r for r in rows if r["rSpec"] <= 2]
    yield (f"  sanity: settings with rSpec ≤ rGen = 2: {len(low)}; "
           f"paradox in {count(low, 'paradox')}, strong in {count(low, 'strong')}")
    yield ""
    yield "Two-tick stock decisions: settings with each outcome"
    yield "  tie priority   entered lock-in   survived to T   strong pair vs generalist A"
    for prefix, label in (("forage", "foraging"), ("train", "training")):
        locked = sum(r[prefix + "FirstLock"] >= 0 for r in rows)
        yield (f"  {label}       {locked}   {count(rows, prefix + 'Survives')}   "
               f"{count(rows, prefix + 'StrongVsA')}")
    contrasting = sum(r["forageFirstLock"] >= 0 and r["trainSurvives"] for r in rows)
    yield f"  forage priority enters lock-in and training priority survives: {contrasting}"
    for key, title, values in AXES:
        yield from breakdown(rows, key, title, values)
    capacities = next(values for key, _, values in AXES if key == "fmax")
    yield from breakdown([r for r in rows if r["rSpec"] >= 6], "fmax",
                         "rSpec ≥ 6 only, by storage capacity", capacities)
    yield ""
    yield "Per-setting results written to experimentE_results.csv"

def check_summary(path, rows):
    expected = summary_lines([dict(zip(COLUMNS, map(int, values))) for values in rows])
    saved = path.read_text(encoding="utf-8").splitlines()
    bad = 0
    for line, (actual, reference) in enumerate(zip_longest(saved, expected), 1):
        if actual != reference:
            bad += 1
            print(f"EXPERIMENT E SUMMARY MISMATCH at line {line}: {actual!r} != {reference!r}")
    return bad

def check(path, limit=None):
    expected = grid()
    if limit is not None and limit < 1:
        raise ValueError("the number of settings to check must be positive")
    with path.open(newline="", encoding="utf-8") as fh:
        data = csv.reader(fh)
        if next(data, None) != COLUMNS:
            raise ValueError("Experiment E CSV header does not match the expected columns")
        rows = list(data)
    selected = expected[:limit]
    if len(rows) not in (len(expected), len(selected)):
        raise ValueError(f"Experiment E expected {len(selected)} selected or {len(expected)} full rows, got {len(rows)}")
    bad = 0
    for i, row in enumerate(rows):
        if len(row) != len(COLUMNS) or row[:6] != [str(v) for v in expected[i]]:
            raise ValueError(f"Experiment E row {i + 2} has the wrong fields or grid coordinates")
        if i < len(selected):
            for name, saved, reference in zip(COLUMNS, row, evaluate(expected[i])):
                if saved != reference:
                    bad += 1
                    print("EXPERIMENT E MISMATCH", expected[i], name, "lean", saved, "python", reference)
    print(f"experimentE: {len(selected)} settings, {bad} field mismatches")
    if len(selected) == len(expected):
        bad += check_summary(path.with_name("experimentE_output.txt"), rows)
    return bad

if __name__ == "__main__":
    path = Path(__file__).resolve().parents[2] / "results" / "experimentE_results.csv"
    try:
        if len(sys.argv) > 2:
            raise ValueError("usage: experiment_e.py [number of settings]")
        sys.exit(1 if check(path, int(sys.argv[1]) if len(sys.argv) > 1 else None) else 0)
    except (OSError, ValueError, csv.Error) as err:
        sys.exit(str(err))
