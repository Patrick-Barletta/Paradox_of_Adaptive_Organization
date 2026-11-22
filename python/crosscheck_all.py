"""Verify all three result CSVs and all seven saved executable reports."""
import csv, math, os, subprocess, sys
from itertools import product
from pathlib import Path
from climate import P, baseline, grow, pnr, run, s0, severity, viable_cert
from climate_summary import climate_summary
from experiments import ahead_each_year, hist, J

def yr(t): return "never" if t < 0 else str(2027 + t)
def pnr_cert(p, tr):
    tk = -1
    for s in tr:
        if s[2] > p.budget + 1e-9: break
        if viable_cert(p, s): tk = s[0]
        else: break
    return tk
def rmin(p, s):
    for i in range(101):
        r = i * 0.01
        if run(p, s, grow(p, r))[0]: return f"{int(round(r*100))}%"
    return "none"
TG = {"1.7C": 510.0, "2.0C": 1035.0}; TC = {"central": 1.0, "robust": 0.45 / 0.63}

WINDOW_AXES = {
    "psi": (0.5, 0.75, 1.0), "phi": (1.5, 2.0, 3.0), "gmax": (0.2, 0.3, 0.4),
    "L": (1, 2, 3), "target": TG, "tcre": TC,
}
PARADOX_AXES = {
    "psi": WINDOW_AXES["psi"], "phi": WINDOW_AXES["phi"], "target": TG, "tcre": TC,
    "carbon_price": (0, 25, 50, 75, 100, 150, 200, 300),
}
WINDOW_FIELDS = (
    "sigma2027", "tPolicy", "tAdapt", "tAdaptCertificate", "exact_all_schedules",
    "tCapacityUnconstrained", "lockYears", "rmin2027", "rmin2030", "rmin2035",
)
PARADOX_FIELDS = (
    "J_builder_2027_2040", "J_myopic_2027_2040", "tAdapt_builder", "tAdapt_myopic",
    "cert_builder", "cert_myopic", "builder_viable", "myopic_loses_window",
    "J_builder_to_myopic_pnr", "J_myopic_to_myopic_pnr", "myopic_ahead_until_pnr",
    "sigma2040_builder", "sigma2040_myopic",
)

def read_grid(path, axes, fields):
    expected = set(product(*axes.values()))
    seen = set()
    with path.open(newline="", encoding="utf-8-sig") as stream:
        reader = csv.DictReader(stream, strict=True)
        if reader.fieldnames != [*axes, *fields]:
            raise ValueError(f"{path.name}: unexpected or missing header")
        rows = []
        for row in reader:
            if None in row or None in row.values():
                raise ValueError(f"{path.name}:{reader.line_num}: wrong number of fields")
            key = tuple(row[name] if name in ("target", "tcre") else float(row[name]) for name in axes)
            if key not in expected or key in seen:
                raise ValueError(f"{path.name}:{reader.line_num}: unexpected or duplicate setting {key}")
            seen.add(key)
            rows.append(row)
    missing = expected - seen
    if missing:
        raise ValueError(f"{path.name}: missing {len(missing)} settings, including {min(missing)}")
    return rows

def check_window(path):
    rows = read_grid(path, WINDOW_AXES, WINDOW_FIELDS)
    bad = 0
    for r in rows:
        p = P(psi=float(r['psi']), phi=float(r['phi']), gmax=float(r['gmax']), L=int(r['L']),
              budget=TG[r['target']] * TC[r['tcre']])
        b = baseline(p)
        def rm(i): return rmin(p, b[i]) if i < len(b) and b[i][2] <= p.budget + 1e-9 else "none"
        adapt, cert, physical = pnr(p, "adapt", b), pnr_cert(p, b), pnr(p, "phys", b)
        got = dict(sigma2027=str(severity(p, b[0])), tPolicy=yr(pnr(p, "policy", b)), tAdapt=yr(adapt),
                   tAdaptCertificate=yr(cert), exact_all_schedules=str(int(cert == adapt)),
                   tCapacityUnconstrained=yr(physical), lockYears=str(physical - adapt) if physical >= 0 else "na",
                   rmin2027=rm(0), rmin2030=rm(3), rmin2035=rm(8))
        for k, v in got.items():
            if r[k] != v: bad += 1; print("WINDOW MISMATCH", k, r[k], v, dict(r))
    print(f"window: {len(rows)} rows, {bad} field mismatches", flush=True)
    return bad == 0

def check_paradox(path):
    rows = read_grid(path, PARADOX_AXES, PARADOX_FIELDS)
    bad = 0
    for r in rows:
        p = P(psi=float(r['psi']), phi=float(r['phi']), budget=TG[r['target']] * TC[r['tcre']])
        pi = float(r['carbon_price'])
        A, xA = hist(p, "A"); B, xB = hist(p, "B", pi)
        tA, tB = pnr(p, "adapt", A), pnr(p, "adapt", B)
        hp = tB + 1 if 0 <= tB < p.T else 0
        aV = run(p, s0(p), grow(p, p.gmax))[0]
        lost = aV and tB < tA and tB >= 0
        sev = lambda tr: 4 if tr[13][2] > p.budget + 1e-9 else severity(p, tr[13])
        jA, jB, jAp, jBp = J(p, A, xA, 14), J(p, B, xB, 14), J(p, A, xA, hp), J(p, B, xB, hp)
        ints = dict(tAdapt_builder=yr(tA), tAdapt_myopic=yr(tB), cert_builder=yr(pnr_cert(p, A)),
                    cert_myopic=yr(pnr_cert(p, B)), builder_viable=str(int(aV)), myopic_loses_window=str(int(lost)),
                    myopic_ahead_until_pnr=str(int(lost and ahead_each_year(p, A, xA, B, xB, hp))),
                    sigma2040_builder=str(sev(A)), sigma2040_myopic=str(sev(B)))
        for k, v in ints.items():
            if r[k] != v: bad += 1; print("PARADOX MISMATCH", k, r[k], v, dict(r))
        for k, v in dict(J_builder_2027_2040=jA, J_myopic_2027_2040=jB, J_builder_to_myopic_pnr=jAp, J_myopic_to_myopic_pnr=jBp).items():
            if not math.isclose(float(r[k]), round(v, 2), abs_tol=1e-8, rel_tol=0):
                bad += 1; print("PARADOX J MISMATCH", k, r[k], v)
    print(f"paradox: {len(rows)} rows, {bad} field mismatches", flush=True)
    return bad == 0

HERE = Path(__file__).resolve().parent
RESULTS = HERE.parent / "results"

def run_script(script, *args):
    """Run another reference script and return what it prints."""
    env = dict(os.environ, PYTHONIOENCODING="utf-8")
    out = subprocess.run([sys.executable, str(HERE / script), *args], capture_output=True,
                         encoding="utf-8", env=env)
    if out.returncode != 0:
        raise ValueError(f"{script} failed:\n{out.stdout}{out.stderr}")
    return out.stdout

def check_lines(name, saved, got):
    want = (RESULTS / saved).read_text(encoding="utf-8").splitlines()
    bad = sum(a != b for a, b in zip(want, got)) + abs(len(want) - len(got))
    print(f"{name}: {len(want)} lines, {bad} differ from results/{saved}", flush=True)
    return bad == 0

def check_output(name, saved, script, *args):
    return check_lines(name, saved, run_script(script, *args).splitlines())

def check_climate_summary():
    windows = read_grid(RESULTS / "climate_window.csv", WINDOW_AXES, WINDOW_FIELDS)
    comparisons = read_grid(RESULTS / "climate_paradox.csv", PARADOX_AXES, PARADOX_FIELDS)
    return check_lines("climate", "climate_output.txt", climate_summary(windows, comparisons))

def check_experiment_e():
    print(run_script("toy/experiment_e.py"), end="", flush=True)
    return True

CHECKS = {
    "window":      lambda: check_window(RESULTS / "climate_window.csv"),
    "paradox":     lambda: check_paradox(RESULTS / "climate_paradox.csv"),
    "climate":     check_climate_summary,
    "argII":       lambda: check_output("argII", "argII_output.txt", "experiments_ii.py", "lean"),
    "report":      lambda: check_output("report", "report_output.txt", "toy/report.py"),
    "argIII":      lambda: check_output("argIII", "argIII_output.txt", "toy/argIII.py"),
    "timed":       lambda: check_output("timed", "argIII_timed_output.txt", "toy/argIII.py", "C"),
    "experimentE": check_experiment_e,
    "friction":    lambda: check_output("friction", "friction_output.txt", "toy/friction.py"),
}

if __name__ == "__main__":
    # With no arguments, verify every artifact.
    which = sys.argv[1:] or list(CHECKS)
    if any(w not in CHECKS for w in which):
        sys.exit("usage: crosscheck_all.py [" + "|".join(CHECKS) + "]")
    passed = True
    for w in which:
        try:
            if not CHECKS[w]():
                passed = False
        except (OSError, ValueError, csv.Error) as error:
            print(f"{w}: {error}", file=sys.stderr, flush=True)
            passed = False
    sys.exit(0 if passed else 1)
