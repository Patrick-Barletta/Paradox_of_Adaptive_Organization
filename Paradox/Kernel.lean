import Paradox.Model

/-!
# Exact viability kernels by backward recursion

`K_c(t)` is computed for every state and every class: a state at time `t < T` is in the kernel
iff some admissible action avoids starvation and lands in `K_c(t+1)`; every state at `T` is in.
Membership therefore comes with a witness; non-membership is an exhaustive exclusion.
-/

namespace Paradox

structure Kernels where
  p : Params
  fixedT : Array (Array Bool)
  policyT : Array (Array Bool)
  adaptT : Array (Array Bool)
  physT : Array (Array Bool)

def buildTable (p : Params) (c : Cls) : Array (Array Bool) := Id.run do
  let size := p.stateCount
  let mut tabs : Array (Array Bool) := mkArray (p.T + 1) (mkArray size true)
  for k in [0:p.T] do
    let t := p.T - 1 - k
    let next := tabs[t + 1]!
    let mut cur := mkArray size false
    for i in [0:size] do
      let s := p.decode t i
      let ok := p.valid s && (p.actions c s).any fun a =>
        match p.step (c == .phys) s a with
        | none => false
        | some n => next[p.encode n]!
      cur := cur.set! i ok
    tabs := tabs.set! t cur
  return tabs

def Kernels.build (p : Params) : Kernels :=
  { p, fixedT := buildTable p .fixed, policyT := buildTable p .policy,
    adaptT := buildTable p .adapt, physT := buildTable p .phys }

namespace Kernels

def table (K : Kernels) : Cls → Array (Array Bool)
  | .fixed => K.fixedT | .policy => K.policyT | .adapt => K.adaptT | .phys => K.physT

def viable (K : Kernels) (c : Cls) (s : St) : Bool :=
  if s.t ≥ K.p.T then true else (K.table c)[s.t]![K.p.encode s]!

/-- Severity 0–4: index of the least permissive class whose kernel contains `s`. -/
def severity (K : Kernels) (s : St) : Nat :=
  if K.viable .fixed s then 0
  else if K.viable .policy s then 1
  else if K.viable .adapt s then 2
  else if K.viable .phys s then 3
  else 4

/-- A successful continuation in class `c`, or `none` if `s ∉ K_c`. -/
def witness (K : Kernels) (c : Cls) (s : St) : Option (List (St × Act)) := Id.run do
  if !K.viable c s then return none
  let mut cur := s
  let mut path : List (St × Act) := []
  for _ in [0:K.p.T - s.t] do
    let choice := (K.p.actions c cur).find? fun a =>
      match K.p.step (c == .phys) cur a with
      | none => false
      | some n => K.viable c n
    match choice with
    | none => return none
    | some a =>
      path := path ++ [(cur, a)]
      match K.p.step (c == .phys) cur a with
      | none => return none
      | some n => cur := n
  return some path

/-- Independent forward re-simulation: every step admissible in `c`, no starvation, reaches `T`. -/
def verify (K : Kernels) (c : Cls) (s : St) (path : List (St × Act)) : Bool := Id.run do
  let mut cur := s
  for (st, a) in path do
    if st != cur then return false
    if !(K.p.actions c cur).contains a then return false
    match K.p.step (c == .phys) cur a with
    | none => return false
    | some n => cur := n
  return cur.t == K.p.T

/-- Run the incumbent from `s`, optionally specializing on the first tick. -/
def history (K : Kernels) (s : St) (specializeFirst : Bool := false) : Array St := Id.run do
  let mut cur := s
  let mut traj := #[s]
  for k in [0:K.p.T - s.t] do
    match K.p.step false cur ⟨K.p.N, 0, 0, specializeFirst && k == 0⟩ with
    | none => break
    | some n => cur := n; traj := traj.push n
  return traj

/-- Point of no return: last tick before the trajectory first leaves `K_c` (−1 if never in). -/
def pointOfNoReturn (K : Kernels) (c : Cls) (traj : Array St) : Int := Id.run do
  let mut tk : Int := -1
  for s in traj do
    if K.viable c s then tk := s.t else break
  return tk

/-- First starvation tick, or `none` if the trajectory reaches `T`. -/
def tFail (K : Kernels) (traj : Array St) : Option Nat :=
  let last := traj.back!
  if last.t < K.p.T then some (last.t + 1) else none

def nestingViolations (K : Kernels) : Nat :=
  (K.p.allStates).foldl (fun acc s =>
    let v := Cls.all.map (K.viable · s)
    let bad := (v.zip (v.drop 1)).any fun (a, b) => a && !b
    if bad then acc + 1 else acc) 0

def severityCounts (K : Kernels) : Array Nat :=
  (K.p.allStates).foldl (fun acc s => let i := K.severity s; acc.set! i (acc[i]! + 1))
    (mkArray 5 0)

/-- Proposition 4 check: with `(O, q)` fixed, richer `(F, P)` never leaves a kernel the poorer
state is in. Returns (pairs checked, violations). -/
def resourceMonotoneCheck (K : Kernels) : Nat × Nat := Id.run do
  let p := K.p
  let mut checked := 0
  let mut viol := 0
  for s in p.allStates do
    for F2 in [s.F:p.fmax + 1] do
      for m in [s.P / p.farmYield:p.N + 1] do
        let s2 := { s with F := F2, P := m * p.farmYield }
        if s2 != s then
          for c in [Cls.policy, Cls.adapt, Cls.phys] do
            checked := checked + 1
            if K.viable c s && !K.viable c s2 then viol := viol + 1
  return (checked, viol)

/-- Fingerprint check: strong-paradox state pairs (richer state at severity 3, poorer at ≤ 2,
same time) all differ in organization or commitments. Returns (pairs, pairs sharing (O,q)). -/
def fingerprintCheck (K : Kernels) : Nat × Nat := Id.run do
  let p := K.p
  let mut pairs := 0
  let mut same := 0
  for t in [0:p.T + 1] do
    let here := (p.allStates).filter (·.t == t)
    let poor := here.filter (K.severity · ≤ 2)
    let rich := here.filter (K.severity · == 3)
    for a in poor do
      for b in rich do
        if b.F ≥ a.F && b.P ≥ a.P then
          pairs := pairs + 1
          if a.farm == b.farm && a.spec == b.spec && a.prog == b.prog then same := same + 1
  return (pairs, same)

end Kernels
end Paradox
