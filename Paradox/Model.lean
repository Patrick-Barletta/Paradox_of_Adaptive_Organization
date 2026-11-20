/-!
# The exact settlement model (Section I.3.10)

State `s = (t, F, P, farm, spec, prog)`:
* `x = (F, P)` — food stock, harvest arriving next tick
* `O = (farm, spec)` — farming capability, specialized foragers
* `q = prog` — worker-ticks of farm training completed (a pending capability move)
-/

namespace Paradox

structure Params where
  N : Nat := 3              -- workers; each eats 1 food per tick
  fmax : Nat := 20          -- storage capacity (surplus discarded)
  T : Nat := 16             -- fixed terminal time
  farmYield : Nat := 2      -- per farmer, harvested next tick
  specBonus : Nat := 1      -- extra forage per specialized forager while wild yield > 0
  rGen : Nat := 2           -- worker-ticks to learn farming, generalists
  rSpec : Nat := 8          -- worker-ticks to learn farming, specialists
  wild : Array Nat := #[2, 2, 2, 2, 2, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0]
  deriving Repr

def Params.base : Params := {}

structure St where
  t : Nat
  F : Nat
  P : Nat
  farm : Bool
  spec : Bool
  prog : Nat
  deriving Repr, BEq, DecidableEq, Inhabited

/-- `f` foragers, `m` farmers, `r` trainees (the rest idle); `sp`: specialize. -/
structure Act where
  f : Nat
  m : Nat
  r : Nat
  sp : Bool
  deriving Repr, BEq, DecidableEq, Inhabited

inductive Cls where
  | fixed | policy | adapt | phys
  deriving Repr, BEq, DecidableEq, Inhabited

def Cls.all : List Cls := [.fixed, .policy, .adapt, .phys]

def Cls.name : Cls → String
  | .fixed => "fixed" | .policy => "policy" | .adapt => "adapt" | .phys => "phys"

namespace Params

def R (p : Params) (spec : Bool) : Nat := if spec then p.rSpec else p.rGen
def wildAt (p : Params) (t : Nat) : Nat := p.wild.getD t 0

/-- One tick. Returns `none` on starvation (leaving `V`). -/
def step (p : Params) (phys : Bool) (s : St) (a : Act) : Option St :=
  let y := p.wildAt s.t
  let bonus := if y > 0 then p.specBonus else 0
  let forage := if phys then a.f * (y + bonus) else a.f * (y + (if s.spec then bonus else 0))
  let gain := s.F + forage + s.P
  if gain < p.N then none else
    let F2 := min p.fmax (gain - p.N)
    let P2 := p.farmYield * a.m
    let spec2 := s.spec || a.sp
    let progress := s.prog + a.r
    -- Training can finish this tick under the current threshold. On specialization,
    -- accumulated work also qualifies immediately if the new threshold is lower.
    let farm2 := s.farm || progress ≥ min (p.R s.spec) (p.R spec2)
    some { t := s.t + 1, F := F2, P := P2, farm := farm2, spec := spec2,
           prog := if farm2 then 0 else progress }

/-- Admissible actions for each control class, in the same order as the Python reference. -/
def actions (p : Params) (c : Cls) (s : St) : List Act :=
  match c with
  | .fixed => [⟨p.N, 0, 0, false⟩]
  | .phys =>
      (List.range (p.N + 1)).foldr (fun f acc =>
        (List.range (p.N + 1 - f)).map (fun m => (⟨f, m, 0, false⟩ : Act)) ++ acc) []
  | .policy =>
      (List.range (p.N + 1)).foldr (fun f acc =>
        (List.range (p.N + 1 - f)).filterMap (fun m =>
          if m > 0 && !s.farm then none else some (⟨f, m, 0, false⟩ : Act)) ++ acc) []
  | .adapt =>
      (List.range (p.N + 1)).foldr (fun f acc =>
        ((List.range (p.N + 1 - f)).foldr (fun m acc2 =>
          ((List.range (p.N + 1 - f - m)).foldr (fun r acc3 =>
            if (m > 0 && !s.farm) || (r > 0 && s.farm) then acc3
            else (if s.spec then [(⟨f, m, r, false⟩ : Act)]
                  else [⟨f, m, r, false⟩, ⟨f, m, r, true⟩]) ++ acc3) []) ++ acc2) []) ++ acc) []

/-! ### State indexing for exact backward recursion -/

def maxR (p : Params) : Nat := max 1 (max p.rGen p.rSpec)
def nP (p : Params) : Nat := p.N + 1
def stateCount (p : Params) : Nat := (p.fmax + 1) * p.nP * 4 * p.maxR

def encode (p : Params) (s : St) : Nat :=
  (((s.F * p.nP + s.P / p.farmYield) * 2 + (if s.farm then 1 else 0)) * 2
    + (if s.spec then 1 else 0)) * p.maxR + s.prog

def decode (p : Params) (t i : Nat) : St :=
  let prog := i % p.maxR
  let i1 := i / p.maxR
  let spec := i1 % 2 == 1
  let i2 := i1 / 2
  let farm := i2 % 2 == 1
  let i3 := i2 / 2
  { t, F := i3 / p.nP, P := (i3 % p.nP) * p.farmYield, farm, spec, prog }

/-- States that can actually occur (the Python `all_states`). -/
def valid (p : Params) (s : St) : Bool :=
  if s.farm then s.prog == 0 else s.prog < p.R s.spec

/-- Every successful step preserves the training-state invariant used by the kernel
table, for every pair of retraining thresholds and every combination of moves. -/
theorem step_valid (p : Params) (phys : Bool) (s : St) (a : Act) (n : St)
    (h : p.step phys s a = some n) : p.valid n = true := by
  simp only [step, Option.ite_none_left_eq_some, Option.some.injEq] at h
  obtain ⟨_, rfl⟩ := h
  simp only [valid]
  split <;> simp_all <;> omega

def allStates (p : Params) : Array St := Id.run do
  let mut out := #[]
  for t in [0:p.T + 1] do
    for i in [0:p.stateCount] do
      let s := p.decode t i
      if p.valid s then out := out.push s
  return out

end Params
end Paradox
