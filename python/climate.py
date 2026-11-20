"""
Climate viability kernels: calibrated stylized model (Python reference).

Annual steps, t = 0 is 2027. State s = (t, f, C, D, pipe):
  f    fraction of baseline emissions abated (x)       E_t = Eref(t) * (1 - f)
  C    cumulative CO2 since 2027-01-01, GtCO2          (x)
  D    deployment capacity, Gt/yr of abatement per yr  (O: the organizational capability)
  pipe capacity expansions in flight (latency L)       (q: commitments in progress)

Viability: C <= carbon budget at every step, and net zero (f = 1) by the terminal year.

Calibration (sources in the write-up):
  Total CO2 2026: 43.3 Gt (fossil 38.2 + land use 5.1). Total grew ~0.3%/yr over 2016-25.
  Budgets from 2027 (50%): 1.5C 150, 1.7C 510, 2.0C 1035 GtCO2.
  TCRE 0.45 C per 1000 GtCO2, likely 0.27-0.63 -> robust budgets = central * 0.45/0.63.
  Clean energy investment ~$2.2T/yr; wind+solar 2025 additions ~1,046 TWh/yr (~0.7 Gt/yr displaced).
  Net abatement cost curve n(f) = -50 + 490(e^{0.534 f} - 1) $/tCO2: ~$20 at f=0.25, ~$100 at f=0.5
  (AR6 WGIII: options <= $100/t can halve emissions; options < $20/t are more than half of that).
"""
from dataclasses import dataclass, replace
import math

@dataclass(frozen=True)
class P:
    E0: float = 43.3        # GtCO2/yr total, 2026
    gamma: float = 0.019    # emissions growth absent new deployment
    D0: float = 0.75        # current deployment capacity, Gt/yr per yr
    Y0: float = 2.2         # current clean investment, $T/yr
    phi: float = 2.0        # spending ceiling available to interventions, x current clean investment
    phi_inc: float = 1.0    # incumbent spending (today's level, growing with GDP)
    gdp: float = 0.025      # ceiling grows with the economy
    n0: float = -50.0       # net abatement cost at f=0, $/t (cheap tranche: solar/wind vs fuel)
    n1: float = 490.0       # cost-curve scale, $/t
    kappa: float = 0.534    # cost-curve steepness: n(0.25)=+20, n(0.5)=+100 $/t (AR6 anchors)
    tau_d: float = 20.0     # e-folding time of the emissions drift (demand growth slows)
    psi: float = 1.0        # capex scale on the cost curve (calibration uncertainty)
    s_fuel: float = 100.0   # fuel + O&M saved per tCO2 abated, $/t
    life: float = 25.0      # asset life, years
    ccap: float = 0.3       # $T per (Gt/yr per yr) of new deployment capacity
    L: int = 2              # years from ordering capacity to having it
    r0: float = 0.02        # incumbent capacity growth rate
    gmax: float = 0.30      # maximum organizational scale-up rate
    T: int = 60             # terminal year index (2087)
    budget: float = 510.0   # GtCO2 from 2027
    rstep: float = 0.005    # grid for constant-growth programs
    ai30: float = 0.0       # extra emissions from AI data-centre demand in 2030, Gt/yr (Argument II)
    ai35: float = 0.0       # ... in 2035 (linear ramps from 0 in 2026; flat after 2035)
    require_nz: bool = True # viability also requires net zero by the terminal year

def ai_add(p, t):
    """extra no-new-deployment emissions from AI data-centre demand (t = 0 is 2027)"""
    y = 2027 + t
    if y <= 2026: return 0.0
    if y <= 2030: return p.ai30 * (y - 2026) / 4.0
    if y <= 2035: return p.ai30 + (p.ai35 - p.ai30) * (y - 2030) / 5.0
    return p.ai35

def eref(p, t):
    """no-new-deployment emissions: growth rate gamma decaying with time constant tau_d,
    plus any AI data-centre demand"""
    return p.E0 * math.exp(p.gamma * p.tau_d * (1 - math.exp(-t / p.tau_d))) + ai_add(p, t)

# capex per (Gt/yr) abated at depth x: c(x) = (n(x) + s) * life / 1000  [$T per Gt/yr]
def n_cost(p, x): return p.n0 + p.n1 * (math.exp(p.kappa * x) - 1.0)
def c_int(p, a, b):
    """integral of capex density c(x) = (n(x) + s) * life / 1000 over [a, b]"""
    k = p.kappa
    nint = p.n0 * (b - a) + p.n1 * ((math.exp(k * b) - math.exp(k * a)) / k - (b - a))
    return p.psi * (nint + p.s_fuel * (b - a)) * p.life / 1000.0

def f_affordable(p, f, budget_T, Er):
    """largest f' <= 1 with Er * c_int(f, f') <= budget_T (monotone, bisection)."""
    if budget_T <= 0: return f
    if Er * c_int(p, f, 1.0) <= budget_T: return 1.0
    lo, hi = f, 1.0
    for _ in range(60):
        mid = (lo + hi) / 2
        if Er * c_int(p, f, mid) <= budget_T: lo = mid
        else: hi = mid
    return lo

def step(p, s, x, capped=True, fcap=1.0, phi=None):
    """One year. x: capacity ordered this year. Deploys the maximum allowed by capacity,
    affordability and the optional depth cap fcap. Returns next state or None if unaffordable."""
    t, f, C, D, pipe = s
    Et = eref(p, t) * (1 - f)
    phi = p.phi if phi is None else phi
    Y = p.Y0 * phi * (1 + p.gdp) ** t - p.ccap * x
    if Y < -1e-12: return None
    Er1 = eref(p, t + 1)
    f2 = f_affordable(p, f, Y, Er1)
    if capped: f2 = min(f2, f + D / Er1)
    f2 = max(f, min(f2, fcap, 1.0))
    D2 = D + (pipe[0] if pipe else x)
    pipe2 = (pipe[1:] + (x,)) if pipe else ()
    return (t + 1, f2, C + Et, D2, pipe2)

def need(p, s, fcap=1.0, phi=None):
    """deployment this year would use if capacity were unlimited (affordability- and depth-limited)"""
    t, f, C, D, pipe = s
    Y = p.Y0 * (p.phi if phi is None else phi) * (1 + p.gdp) ** t
    Er1 = eref(p, t + 1)
    return Er1 * (min(f_affordable(p, f, Y, Er1), fcap) - f)

def grow(p, r, fcap=1.0, phi=None):
    """capacity rule: expand at rate r only while capacity (incl. in-flight) is below what can be used"""
    return lambda z: r * z[3] if z[3] + sum(z[4]) < need(p, z, fcap, phi) - 1e-12 else 0.0

def run(p, s, rule, capped=True, fcap=1.0, phi=None):
    """Simulate a rule (s -> x) to T. Returns (viable, trajectory)."""
    traj = [s]
    if s[2] > p.budget + 1e-9: return False, traj
    while s[0] < p.T:
        s2 = step(p, s, rule(s), capped, fcap, phi)
        if s2 is None or s2[2] > p.budget + 1e-9: return False, traj
        s = s2; traj.append(s)
    return (s[1] >= 1.0 - 1e-9) if p.require_nz else True, traj

def cert_reason(p, s):
    """Run the dominant (free-expansion) program from s under both constraints.
    0 = viable, 1 = budget breached (or unaffordable) before the terminal year,
    2 = within budget through the terminal year but not at net zero."""
    if s[2] > p.budget + 1e-9: return 1
    q = replace(p, ccap=0.0, require_nz=True)
    rule = lambda z: q.gmax * z[3]
    while s[0] < q.T:
        s2 = step(q, s, rule(s))
        if s2 is None or s2[2] > q.budget + 1e-9: return 1
        s = s2
    return 0 if s[1] >= 1.0 - 1e-9 else 2

def viable(p, cls, s):
    if cls == "fixed":     # incumbent: today's spending, slow capacity growth
        return run(p, s, grow(p, p.r0, phi=p.phi_inc), phi=p.phi_inc)[0]
    if cls == "policy":    # raise spending to phi; capacity still grows only at the incumbent rate
        return run(p, s, grow(p, p.r0))[0]
    if cls == "adapt":
        return any(run(p, s, grow(p, r))[0] for r in rgrid(p))
    if cls == "phys":
        return run(p, s, lambda z: 0.0, capped=False)[0]
    raise ValueError(cls)

def viable_cert(p, s):
    """Relaxed dominant program: capacity expansion is free (ccap = 0) and always at gmax.
    With free expansion, more capacity never reduces deployment, and maximal deployment dominates,
    so this program dominates every time-varying schedule of the real model. Exclusion here is
    therefore exclusion from the adapt kernel over ALL capacity schedules."""
    q = replace(p, ccap=0.0)
    return run(q, s, lambda z: q.gmax * z[3])[0]

def rgrid(p):
    n = int(round(p.gmax / p.rstep))
    return [i * p.rstep for i in range(n + 1)]

def window(p, s):
    """viable constant growth rates from state s"""
    return [r for r in rgrid(p) if run(p, s, grow(p, r))[0]]

def severity(p, s):
    for i, c in enumerate(["fixed", "policy", "adapt", "phys"]):
        if viable(p, c, s): return i
    return 4

def s0(p):
    # At the start of a year, L - 1 earlier orders still await delivery.
    return (0, 0.0, 0.0, p.D0, (p.r0 * p.D0,) * (p.L - 1))

def baseline(p):
    """incumbent history, run to T regardless of viability (states only)"""
    s = s0(p); traj = [s]
    rule = grow(p, p.r0, phi=p.phi_inc)
    while s[0] < p.T:
        s2 = step(p, s, rule(s), phi=p.phi_inc)
        if s2 is None: break                      # capacity order unaffordable: history ends here
        s = s2; traj.append(s)
    return traj

def pnr(p, cls, traj):
    tk = -1
    for s in traj:
        if s[2] > p.budget + 1e-9: break
        if viable(p, cls, s): tk = s[0]
        else: break
    return tk

if __name__ == "__main__":
    for label, B in [("1.5C", 150), ("1.7C", 510), ("2.0C", 1035)]:
        for tc, scale in [("central", 1.0), ("robust", 0.45 / 0.63)]:
            p = P(budget=B * scale)
            tr = baseline(p)
            ta, tp = pnr(p, "adapt", tr), pnr(p, "phys", tr)
            print(f"{label} {tc:7s} budget {p.budget:6.0f}: sigma(2027)={severity(p, tr[0])} "
                  f"t*_adapt={2027+ta if ta>=0 else 'never'} t*_phys={2027+tp if tp>=0 else 'never'}")
