/-!
# Climate viability kernels (calibrated stylized model)

Annual steps, `t = 0` is 2027. State `(t, f, C, D, pipe)`:
* `f` — fraction of no-new-deployment emissions abated; `E_t = Eref(t) * (1 - f)`   (physical)
* `C` — cumulative CO2 since 2027-01-01, GtCO2                                       (physical)
* `D` — deployment capacity, Gt/yr of abatement added per year      (organizational capability)
* `pipe` — capacity expansions in flight (latency `L`)                             (commitments)

Viability: `C ≤ budget` every year and net zero (`f = 1`) by the terminal year.

Control classes:
* fixed  — incumbent: today's spending (`phiInc`), capacity growth `r0`
* policy — spending raised to `phi`; capacity still grows only at `r0`
* adapt  — spending `phi`; any constant capacity growth rate `r ≤ gmax`
* phys   — spending `phi`; deployment not limited by capacity

Every program deploys the maximum its capacity, spending and depth cap allow (maximal deployment
dominates; see `Theory.greedy_suffices` and the numerical check in `checks.py`), and expands capacity
only while capacity, including expansions in flight, is below what spending could use.

The arithmetic mirrors `climate.py` operation for operation so results can be cross-checked exactly.
-/

namespace Paradox.Climate

structure CP where
  E0 : Float := 43.3
  gamma : Float := 0.019
  tauD : Float := 20.0
  D0 : Float := 0.75
  Y0 : Float := 2.2
  phi : Float := 2.0
  phiInc : Float := 1.0
  gdp : Float := 0.025
  n0 : Float := -50.0
  n1 : Float := 490.0
  kappa : Float := 0.534
  sFuel : Float := 100.0
  life : Float := 25.0
  psi : Float := 1.0
  ccap : Float := 0.3
  L : Nat := 2
  r0 : Float := 0.02
  gmax : Float := 0.30
  T : Nat := 60
  budget : Float := 510.0
  rstep : Float := 0.005
  ai30 : Float := 0.0       -- extra emissions from AI data-centre demand in 2030, Gt/yr
  ai35 : Float := 0.0       -- ... in 2035 (linear ramps from 0 in 2026; flat after)
  requireNZ : Bool := true  -- viability also requires net zero by the terminal year
  -- (no `deriving Repr`: deriving it for this many fields makes elaboration extremely slow)

structure CS where
  t : Nat
  f : Float
  C : Float
  D : Float
  pipe : List Float
  deriving Repr, Inhabited

namespace CP

def aiAdd (p : CP) (t : Nat) : Float :=
  let y : Float := 2027.0 + t.toFloat
  if y ≤ 2026.0 then 0.0
  else if y ≤ 2030.0 then p.ai30 * (y - 2026.0) / 4.0
  else if y ≤ 2035.0 then p.ai30 + (p.ai35 - p.ai30) * (y - 2030.0) / 5.0
  else p.ai35

def eref (p : CP) (t : Nat) : Float :=
  p.E0 * Float.exp (p.gamma * p.tauD * (1 - Float.exp (-(t.toFloat) / p.tauD))) + p.aiAdd t

def nCost (p : CP) (x : Float) : Float := p.n0 + p.n1 * (Float.exp (p.kappa * x) - 1.0)

/-- Integral of the capex density over `[a, b]`, $T per Gt/yr of reference emissions. -/
def cInt (p : CP) (a b : Float) : Float :=
  let k := p.kappa
  let nint := p.n0 * (b - a) + p.n1 * ((Float.exp (k * b) - Float.exp (k * a)) / k - (b - a))
  p.psi * (nint + p.sFuel * (b - a)) * p.life / 1000.0

/-- Largest depth reachable this year within the spending budget (bisection, 60 rounds). -/
def fAffordable (p : CP) (f budgetT er : Float) : Float := Id.run do
  if budgetT ≤ 0 then return f
  if er * p.cInt f 1.0 ≤ budgetT then return 1.0
  let mut lo := f
  let mut hi := 1.0
  for _ in [0:60] do
    let mid := (lo + hi) / 2
    if er * p.cInt f mid ≤ budgetT then lo := mid else hi := mid
  return lo

def spend (p : CP) (phi : Float) (t : Nat) : Float :=
  p.Y0 * phi * Float.pow (1 + p.gdp) t.toFloat

def step (p : CP) (s : CS) (x : Float) (capped : Bool := true) (fcap : Float := 1.0)
    (phi : Float) : Option CS :=
  let et := p.eref s.t * (1 - s.f)
  let y := p.spend phi s.t - p.ccap * x
  if y < -1e-12 then none else
    let er1 := p.eref (s.t + 1)
    let f2a := p.fAffordable s.f y er1
    let f2b := if capped then min f2a (s.f + s.D / er1) else f2a
    let f2 := max s.f (min (min f2b fcap) 1.0)
    let (d2, pipe2) := match s.pipe with
      | [] => (s.D + x, [])
      | h :: rest => (s.D + h, rest ++ [x])
    some { t := s.t + 1, f := f2, C := s.C + et, D := d2, pipe := pipe2 }

def need (p : CP) (s : CS) (fcap : Float) (phi : Float) : Float :=
  let y := p.spend phi s.t
  let er1 := p.eref (s.t + 1)
  er1 * (min (p.fAffordable s.f y er1) fcap - s.f)

/-- Expand at rate `r` only while capacity (incl. in flight) is below what spending could use. -/
def grow (p : CP) (r : Float) (fcap : Float := 1.0) (phi : Float) : CS → Float := fun z =>
  if z.D + z.pipe.foldl (· + ·) 0 < p.need z fcap phi - 1e-12 then r * z.D else 0.0

/-- Simulate a rule to `T`; viable iff the budget holds every year and net zero is reached. -/
def run (p : CP) (s : CS) (rule : CS → Float) (capped : Bool := true) (fcap : Float := 1.0)
    (phi : Float) : Bool := Id.run do
  if s.C > p.budget + 1e-9 then return false
  let mut cur := s
  for _ in [0:p.T - s.t] do
    match p.step cur (rule cur) capped fcap phi with
    | none => return false
    | some n =>
      if n.C > p.budget + 1e-9 then return false
      cur := n
  return if p.requireNZ then cur.f ≥ 1 - 1e-9 else true

def rgrid (p : CP) : List Float :=
  let n := (p.gmax / p.rstep).round.toUInt64.toNat
  (List.range (n + 1)).map fun i => i.toFloat * p.rstep

/-- Kernel membership for the four classes (0 fixed, 1 policy, 2 adapt, 3 phys). -/
def viable (p : CP) (cls : Nat) (s : CS) : Bool :=
  match cls with
  | 0 => p.run s (p.grow p.r0 1.0 p.phiInc) true 1.0 p.phiInc
  | 1 => p.run s (p.grow p.r0 1.0 p.phi) true 1.0 p.phi
  | 2 => (p.rgrid).any fun r => p.run s (p.grow r 1.0 p.phi) true 1.0 p.phi
  | _ => p.run s (fun _ => 0.0) false 1.0 p.phi

/-- Certificate: the relaxed program with free capacity expansion (`ccap = 0`), always growing at
`gmax`. It dominates every capacity schedule of the real model (more capacity never reduces
deployment once expansion is free; maximal deployment dominates), so `certViable = false` excludes
the state from the adapt kernel over all time-varying schedules, not just constant-rate ones. -/
def certViable (p : CP) (s : CS) : Bool :=
  let q := { p with ccap := 0.0 }
  q.run s (fun z => q.gmax * z.D) true 1.0 q.phi

/-- Why the dominant (free-expansion) program fails from `s`, under both constraints:
0 = viable, 1 = budget breached (or unaffordable) before the terminal year,
2 = within budget through the terminal year but not at net zero. -/
def certReason (p : CP) (s : CS) : Nat := Id.run do
  if s.C > p.budget + 1e-9 then return 1
  let q := { p with ccap := 0.0, requireNZ := true }
  let mut cur := s
  for _ in [0:q.T - s.t] do
    match q.step cur (q.gmax * cur.D) true 1.0 q.phi with
    | none => return 1
    | some n =>
      if n.C > q.budget + 1e-9 then return 1
      cur := n
  return if cur.f ≥ 1 - 1e-9 then 0 else 2

/-- Point of no return under the certificate (upper bound on the all-schedule adapt kernel). -/
def pnrCert (p : CP) (traj : Array CS) : Int := Id.run do
  let mut tk : Int := -1
  for s in traj do
    if s.C > p.budget + 1e-9 then break
    if p.certViable s then tk := s.t else break
  return tk

def severity (p : CP) (s : CS) : Nat :=
  if p.viable 0 s then 0 else if p.viable 1 s then 1
  else if p.viable 2 s then 2 else if p.viable 3 s then 3 else 4

def s0 (p : CP) : CS :=
  -- An order at t enters D at t + L. At the start of t, only L − 1 earlier orders remain.
  { t := 0, f := 0.0, C := 0.0, D := p.D0, pipe := List.replicate (p.L - 1) (p.r0 * p.D0) }

/-- The incumbent history (states only, run to `T`). -/
def baseline (p : CP) : Array CS := Id.run do
  let mut cur := p.s0
  let mut out := #[cur]
  for _ in [0:p.T] do
    match p.step cur (p.grow p.r0 1.0 p.phiInc cur) true 1.0 p.phiInc with
    | none => break
    | some n => cur := n; out := out.push n
  return out

/-- Point of no return along a trajectory for class `cls` (−1 if never in the kernel). -/
def pnr (p : CP) (cls : Nat) (traj : Array CS) : Int := Id.run do
  let mut tk : Int := -1
  for s in traj do
    if s.C > p.budget + 1e-9 then break
    if p.viable cls s then tk := s.t else break
  return tk

/-- Minimum viable constant growth rate on the 0–100 %/yr scan (1 %/yr steps), if any. -/
def rmin (p : CP) (s : CS) : Option Float :=
  ((List.range 101).map fun i => i.toFloat * 0.01).find? fun r =>
    p.run s (p.grow r 1.0 p.phi) true 1.0 p.phi

/-! ### Builder and carbon-price cutoff histories -/

/-- Annual net cost of the abatement stock at depth `f`, $B per Gt of reference emissions.
`psi` scales capex `(n + s)`; fuel savings `s` are real: net cost density `psi*(n+s) - s`. -/
def nInt (p : CP) (f : Float) : Float :=
  let k := p.kappa
  let nint := p.n0 * f + p.n1 * ((Float.exp (k * f) - 1) / k - f)
  p.psi * (nint + p.sFuel * f) - p.sFuel * f

/-- Depth where marginal net cost equals the carbon price: `psi*(n(f*)+s) - s = pi`. -/
def fstar (p : CP) (pi : Float) : Float :=
  let v := 1 + ((pi + p.sFuel) / p.psi - p.sFuel - p.n0) / p.n1
  if v ≤ 1 then 0.0 else min 1.0 (Float.log v / p.kappa)

/-- Builder (`myopic = false`): max growth and deployment. Myopic: deploy only where marginal net
cost is below the carbon price `pi`; expand at max rate while that deployment is unfinished. -/
def hist (p : CP) (myopic : Bool) (pi : Float := 0.0) : Array CS × Array Float := Id.run do
  let fs := if myopic then p.fstar pi else 1.0
  let mut cur := p.s0
  let mut traj := #[cur]
  let mut xs := #[]
  for _ in [0:p.T] do
    let x := p.grow p.gmax fs p.phi cur
    match p.step cur x true fs p.phi with
    | none => break
    | some n => xs := xs.push x; cur := n; traj := traj.push n
  return (traj, xs)

/-- Consumption proxy over the first `H` years: minus (net cost of abatement stock + capacity capex). -/
def jValue (p : CP) (traj : Array CS) (xs : Array Float) (H : Nat) : Float := Id.run do
  let mut tot := 0.0
  for t in [0:H] do
    let s := traj[t]!
    tot := tot - (p.eref s.t * p.nInt s.f / 1000.0 + p.ccap * xs[t]!)
  return tot

end CP
end Paradox.Climate
