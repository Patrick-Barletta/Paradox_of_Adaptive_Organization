/-!
# Argument III: static closure does not guarantee a timed bootstrap

Static Horn closure (III.5–III.6) answers "can every capability eventually be restored?" with no
clock and no resources. This file gives a small constructive witness that the answer can be yes
while no admissible timed trajectory ever restores the target.

* Capabilities `B, P, G, E` with static rules `B → P`, `P → G`, `G → E` and seed `{B}`.
* Activation is serial (one capability at a time) and takes `τ(P) = 3`, `τ(G) = 4`, `τ(E) = 3`
  powered ticks; a capability can be worked on only while its prerequisite is online.
* The seed `B` has finite endurance: it is online, and supplies power, only at ticks `t < L`.
  Afterwards activation needs power from `E` itself.

We prove, with no `sorry` and no `native_decide`:

* `timed_bootstrap_static_reachable`: `E` is in the static closure of `{B}`.
* `timed_unreachable_of_short_seed`: for every endurance `L ≤ 9`, no trajectory of any length
  brings `E` online. `timed_bootstrap_timed_unreachable` is the case `L = 5`.
* `timed_bootstrap_reachable_long_seed`: with `L = 10` the model does bring `E` online, at tick 10,
  so the negative result comes from the clock, not from a model in which nothing can happen.

The executable part (`earliestE`) is used by `ArgIIIMain.lean` (demonstration III.C) and is
cross-checked against `python/toy/argIII.py`. The theorems are about the same `succs` function.
-/

namespace Paradox.Timed

inductive Cap | B | P | G | E
  deriving DecidableEq, Repr

def Cap.all : List Cap := [.B, .P, .G, .E]

def Cap.name : Cap → String
  | .B => "B" | .P => "P" | .G => "G" | .E => "E"

/-- The static rules `B → P`, `P → G`, `G → E`: each capability's single prerequisite. -/
def pre : Cap → Option Cap
  | .B => none | .P => some .B | .G => some .P | .E => some .G

/-- Serial activation durations, in powered ticks. -/
def tau : Cap → Nat
  | .B => 0 | .P => 3 | .G => 4 | .E => 3

/-- Static Horn closure of a seed set under the rules (no clock, no resources). -/
inductive Closure (seed : Cap → Prop) : Cap → Prop
  | seed {c : Cap} : seed c → Closure seed c
  | rule {c d : Cap} : pre c = some d → Closure seed d → Closure seed c

/-- `E` is in the static closure of `{B}`. -/
theorem timed_bootstrap_static_reachable : Closure (· = Cap.B) Cap.E :=
  .rule rfl (.rule rfl (.rule rfl (.seed rfl)))

/-- Timed state: the tick, which of `P, G, E` are online, the capability under activation (if any)
and the powered ticks of work it has received. -/
structure TS where
  t : Nat
  P : Bool
  G : Bool
  E : Bool
  work : Option Cap
  k : Nat
  deriving DecidableEq, Repr

def TS.init : TS := ⟨0, false, false, false, none, 0⟩

/-- Whether `c` is online at `s` when the seed lasts `L` ticks. -/
def online (L : Nat) (s : TS) : Cap → Bool
  | .B => decide (s.t < L) | .P => s.P | .G => s.G | .E => s.E

/-- Power is available while the seed lasts or once `E` is online. -/
def powered (L : Nat) (s : TS) : Bool := decide (s.t < L) || s.E

/-- A capability can be worked on if it is offline and its prerequisite is online. The seed itself
cannot be re-activated. -/
def eligible (L : Nat) (s : TS) (c : Cap) : Bool :=
  match pre c with
  | none => false
  | some d => !online L s c && online L s d

def finish (s : TS) : Cap → TS
  | .P => { s with P := true } | .G => { s with G := true } | .E => { s with E := true } | .B => s

/-- One powered tick of work on `c`. Switching to a different capability abandons the progress
on the previous one (serial activation). -/
def workOn (s : TS) (c : Cap) : TS :=
  let k0 := if s.work = some c then s.k else 0
  if tau c ≤ k0 + 1 then { finish s c with t := s.t + 1, work := none, k := 0 }
  else { s with t := s.t + 1, work := some c, k := k0 + 1 }

def idle (s : TS) : TS := { s with t := s.t + 1 }

/-- Admissible successors: wait, or (if powered) put one tick of work into an eligible capability. -/
def succs (L : Nat) (s : TS) : List TS :=
  idle s :: (if powered L s then (Cap.all.filter (eligible L s)).map (workOn s) else [])

/-- `Reach L n s`: some admissible trajectory reaches `s` in `n` ticks from `TS.init`. -/
inductive Reach (L : Nat) : Nat → TS → Prop
  | init : Reach L 0 TS.init
  | step {n : Nat} {s s' : TS} : Reach L n s → s' ∈ succs L s → Reach L (n + 1) s'

/-! ## The invariant: completed work never outruns the powered ticks -/

/-- Work embodied in a state: the durations of the online capabilities plus current progress. -/
def W (s : TS) : Nat := (if s.P then 3 else 0) + (if s.G then 4 else 0) + s.k

def Inv (L : Nat) (s : TS) : Prop :=
  (s.G = true → s.P = true) ∧ s.E = false ∧ W s ≤ s.t ∧ W s ≤ L

theorem inv_init (L : Nat) : Inv L TS.init := by
  simp [Inv, TS.init, W]

theorem inv_step {L : Nat} (hL : L ≤ 9) {s s' : TS} (h : Inv L s) (hs : s' ∈ succs L s) :
    Inv L s' := by
  obtain ⟨t, P, G, E, work, k⟩ := s
  obtain ⟨hGP, hE, hWt, hWL⟩ := h
  simp only at hGP hE hWt hWL
  subst hE
  simp only [succs, List.mem_cons] at hs
  rcases hs with rfl | hs
  · simp only [Inv, idle, W] at hWt hWL ⊢
    exact ⟨hGP, by simp, by omega, hWL⟩
  · split at hs
    · rename_i hp
      have ht : t < L := by simpa [powered] using hp
      simp only [List.mem_map, List.mem_filter, Cap.all, List.mem_cons, List.mem_singleton,
        List.not_mem_nil, or_false] at hs
      obtain ⟨c, ⟨hc, hel⟩, rfl⟩ := hs
      simp only [W] at hWt hWL
      rcases hc with rfl | rfl | rfl | rfl
      · simp [eligible, pre] at hel
      · simp only [eligible, pre, online, Bool.and_eq_true, Bool.not_eq_true'] at hel
        obtain ⟨hP, -⟩ := hel
        subst hP
        cases G
        · simp only [workOn, tau]
          split <;> split <;> simp_all [Inv, finish, W] <;> omega
        · simp at hGP
      · simp only [eligible, pre, online, Bool.and_eq_true, Bool.not_eq_true'] at hel
        obtain ⟨hG, hP⟩ := hel
        subst hG hP
        simp only [workOn, tau]
        split <;> split <;> simp_all [Inv, finish, W] <;> omega
      · simp only [eligible, pre, online, Bool.and_eq_true, Bool.not_eq_true'] at hel
        obtain ⟨-, hG⟩ := hel
        subst hG
        have hP := hGP rfl
        subst hP
        simp only [workOn, tau]
        split <;> split <;> simp_all [Inv, finish, W] <;> omega
    · simp at hs

/-- With a seed that lasts at most 9 ticks, `E` never comes online, at any horizon. -/
theorem timed_unreachable_of_short_seed {L : Nat} (hL : L ≤ 9) :
    ∀ n s, Reach L n s → s.E = false := by
  have key : ∀ n s, Reach L n s → Inv L s := by
    intro n s h
    induction h with
    | init => exact inv_init L
    | step _ hs ih => exact inv_step hL ih hs
  intro n s h
  exact (key n s h).2.1

/-- **Timed bootstrap counterexample.** `E` is in the static closure of `{B}`, but with the seed
lasting 5 ticks no admissible trajectory of any length brings `E` online. -/
theorem timed_bootstrap_timed_unreachable : ∀ n s, Reach 5 n s → s.E = false :=
  timed_unreachable_of_short_seed (by decide)

/-- Positive control: with a seed lasting 10 ticks, `E` is online at tick 10. -/
theorem timed_bootstrap_reachable_long_seed :
    Reach 10 10 ⟨10, true, true, true, none, 0⟩ := by
  have h1 : Reach 10 1 ⟨1, false, false, false, some .P, 1⟩ := .step .init (by decide)
  have h2 : Reach 10 2 ⟨2, false, false, false, some .P, 2⟩ := .step h1 (by decide)
  have h3 : Reach 10 3 ⟨3, true, false, false, none, 0⟩ := .step h2 (by decide)
  have h4 : Reach 10 4 ⟨4, true, false, false, some .G, 1⟩ := .step h3 (by decide)
  have h5 : Reach 10 5 ⟨5, true, false, false, some .G, 2⟩ := .step h4 (by decide)
  have h6 : Reach 10 6 ⟨6, true, false, false, some .G, 3⟩ := .step h5 (by decide)
  have h7 : Reach 10 7 ⟨7, true, true, false, none, 0⟩ := .step h6 (by decide)
  have h8 : Reach 10 8 ⟨8, true, true, false, some .E, 1⟩ := .step h7 (by decide)
  have h9 : Reach 10 9 ⟨9, true, true, false, some .E, 2⟩ := .step h8 (by decide)
  exact .step h9 (by decide)

/-! ## Executable part (demonstration III.C) -/

/-- Static closure of a seed list, in the order capabilities are added. -/
def closureList (seeds : List Cap) : List Cap := Id.run do
  let mut up := seeds
  for _ in [0:Cap.all.length + 1] do
    for c in Cap.all do
      match pre c with
      | some d => if !up.contains c && up.contains d then up := up ++ [c]
      | none => pure ()
  return up

/-- Earliest tick at which some trajectory has `E` online, searching up to horizon `H`. -/
def earliestE (L H : Nat) : Option Nat := Id.run do
  let mut front : List TS := [TS.init]
  for n in [0:H + 1] do
    if front.any (·.E) then return some n
    front := (front.foldl (fun acc s => acc ++ succs L s) []).eraseDups
  return none

end Paradox.Timed
