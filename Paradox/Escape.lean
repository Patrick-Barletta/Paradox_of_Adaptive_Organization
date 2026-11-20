/-!
# Argument III: the adaptive escape problem is as hard as classical planning

A propositional STRIPS planning instance is mapped to an escape (reach-avoid) instance:
capabilities are propositions, reorganization moves are operators, and the null move (A1 of
Argument I) lets the system stay put. We prove, with no `sorry` and no `native_decide`:

  a plan of length at most `n` exists  ⇔  an escape within exactly `n` steps exists.

`planning_iff_escape_A0` proves the same equivalence (at `n + 1` steps) with the terminal set on a
physical goal bit only, as Argument I's Assumption A0 requires.

The mapping is the identity on operators plus one null move, so it is computable in polynomial
time (a meta-level observation, not formalized here). Bounded plan existence for propositional
STRIPS, with the bound written in binary, is PSPACE-complete (Bylander 1994), so the escape problem
with a binary-encoded horizon is PSPACE-hard in general.
-/

namespace Paradox.Escape

/-- A STRIPS operator: preconditions, add list, delete list (add takes precedence). -/
structure Op (P : Type) where
  pre : List P
  add : List P
  del : List P

variable {P : Type} [DecidableEq P]

/-- A state assigns truth values to propositions (capabilities present or absent). -/
abbrev State (P : Type) := P → Bool

def holds (s : State P) (l : List P) : Prop := ∀ p ∈ l, s p = true

def applyOp (o : Op P) (s : State P) : State P :=
  fun p => if p ∈ o.add then true else if p ∈ o.del then false else s p

/-- Executing a plan (a list of operators drawn from `ops`) from `s` ends in `s'`. -/
def PlanReaches (ops : List (Op P)) : List (Op P) → State P → State P → Prop
  | [], s, s' => s' = s
  | o :: rest, s, s' => o ∈ ops ∧ holds s o.pre ∧ PlanReaches ops rest (applyOp o s) s'

/-- Bounded plan existence: some plan of length at most `n` reaches a goal state. -/
def PlanExists (ops : List (Op P)) (init : State P) (goal : List P) (n : Nat) : Prop :=
  ∃ plan s', plan.length ≤ n ∧ PlanReaches ops plan init s' ∧ holds s' goal

/-- The escape (reach-avoid) problem: stay in `V` for `n` steps and end in `W`. -/
def Escape {S : Type} (step : S → S → Prop) (V W : S → Prop) : Nat → S → Prop
  | 0, s => V s ∧ W s
  | n + 1, s => V s ∧ ∃ s', step s s' ∧ Escape step V W n s'

/-- The organizational system built from a planning instance: each step is either the null move
(stay put) or an applicable operator. -/
def orgStep (ops : List (Op P)) (s s' : State P) : Prop :=
  s' = s ∨ ∃ o ∈ ops, holds s o.pre ∧ s' = applyOp o s

/-- With the null move available, a state already in the terminal set can wait any number of steps. -/
theorem escape_wait {S : Type} (step : S → S → Prop) (V W : S → Prop)
    (hnull : ∀ s, step s s) (hV : ∀ s, V s) :
    ∀ n s, W s → Escape step V W n s := by
  intro n
  induction n with
  | zero => intro s hW; exact ⟨hV s, hW⟩
  | succ n ih => intro s hW; exact ⟨hV s, s, hnull s, ih s hW⟩

/-- **Theorem III.1 (planning reduces to escape).** For every STRIPS instance and every bound `n`,
a plan of length at most `n` exists iff the corresponding organization can escape in `n` steps. -/
theorem planning_iff_escape (ops : List (Op P)) (init : State P) (goal : List P) (n : Nat) :
    PlanExists ops init goal n ↔
      Escape (orgStep ops) (fun _ => True) (fun s => holds s goal) n init := by
  constructor
  · -- a plan yields an escape: follow the plan, then wait with null moves
    rintro ⟨plan, s', hlen, hreach, hgoal⟩
    induction plan generalizing n init with
    | nil =>
      simp only [PlanReaches] at hreach
      subst hreach
      exact escape_wait (orgStep ops) (fun _ => True) (fun s => holds s goal)
        (fun s => Or.inl rfl) (fun _ => trivial) n s' hgoal
    | cons o rest ih =>
      obtain ⟨hmem, hpre, hrest⟩ := hreach
      cases n with
      | zero => simp at hlen
      | succ m =>
        have hlen' : rest.length ≤ m := by simp at hlen; omega
        exact ⟨trivial, applyOp o init, Or.inr ⟨o, hmem, hpre, rfl⟩,
          ih (applyOp o init) m hlen' hrest⟩
  · -- an escape yields a plan: drop the null moves
    intro h
    induction n generalizing init with
    | zero => exact ⟨[], init, Nat.le_refl _, rfl, h.2⟩
    | succ m ih =>
      obtain ⟨_, s'', hstep, hesc⟩ := h
      obtain ⟨plan, sf, hlen, hreach, hgoal⟩ := ih s'' hesc
      rcases hstep with heq | ⟨o, hmem, hpre, heq⟩
      · subst heq
        exact ⟨plan, sf, Nat.le_succ_of_le hlen, hreach, hgoal⟩
      · subst heq
        exact ⟨o :: plan, sf, by simp; omega, ⟨hmem, hpre, hreach⟩, hgoal⟩

/-! ## The A0-respecting version

`planning_iff_escape` places the terminal set directly on capabilities. Argument I's Assumption A0
requires the viability and terminal sets to depend only on the physical state. The gadget below
restores A0: the state is a pair `(x, O)` with a physical goal bit `x` (initially `false`) and the
capabilities `O`. Each tick makes a reorganization move on `O` (null or an operator) and an
operational action: either the null action, which leaves `x` alone, or `declare`, which sets `x`
to `true` and is admissible only when every goal capability is present in `O`. The terminal set is
`x = true`, a condition on the physical state alone. The equivalence then holds at `n + 1` steps. -/

/-- One tick of the A0 gadget: a move on the capabilities and, optionally, the `declare` action. -/
def a0Step (ops : List (Op P)) (goal : List P) (p q : Bool × State P) : Prop :=
  orgStep ops p.2 q.2 ∧ (q.1 = p.1 ∨ (q.1 = true ∧ holds p.2 goal))

/-- **Theorem III.1, A0 form.** A plan of length at most `n` exists iff the gadget organization,
starting with the physical goal bit off, can escape to the physical terminal set `x = true` in
`n + 1` steps. -/
theorem planning_iff_escape_A0 (ops : List (Op P)) (init : State P) (goal : List P) (n : Nat) :
    PlanExists ops init goal n ↔
      Escape (a0Step ops goal) (fun _ => True) (fun p => p.1 = true) (n + 1) (false, init) := by
  constructor
  · rintro ⟨plan, s', hlen, hreach, hgoal⟩
    induction plan generalizing n init with
    | nil =>
      simp only [PlanReaches] at hreach
      subst hreach
      exact ⟨trivial, (true, s'), ⟨Or.inl rfl, Or.inr ⟨rfl, hgoal⟩⟩,
        escape_wait (a0Step ops goal) (fun _ => True) (fun p => p.1 = true)
          (fun p => ⟨Or.inl rfl, Or.inl rfl⟩) (fun _ => trivial) n (true, s') rfl⟩
    | cons o rest ih =>
      obtain ⟨hmem, hpre, hrest⟩ := hreach
      cases n with
      | zero => simp at hlen
      | succ m =>
        have hlen' : rest.length ≤ m := by simp at hlen; omega
        exact ⟨trivial, (false, applyOp o init), ⟨Or.inr ⟨o, hmem, hpre, rfl⟩, Or.inl rfl⟩,
          ih (applyOp o init) m hlen' hrest⟩
  · intro h
    induction n generalizing init with
    | zero =>
      obtain ⟨_, q, ⟨_, hq⟩, _, hW⟩ := h
      rcases hq with h1 | ⟨_, hg⟩
      · simp_all
      · exact ⟨[], init, Nat.le_refl _, rfl, hg⟩
    | succ m ih =>
      obtain ⟨_, q, ⟨hstep, hq⟩, hesc⟩ := h
      rcases hq with h1 | ⟨_, hg⟩
      · obtain ⟨b, s''⟩ := q
        simp only at h1 hstep hesc
        subst h1
        obtain ⟨plan, sf, hlen, hreach, hgoal⟩ := ih s'' hesc
        rcases hstep with heq | ⟨o, hmem, hpre, heq⟩
        · subst heq
          exact ⟨plan, sf, Nat.le_succ_of_le hlen, hreach, hgoal⟩
        · subst heq
          exact ⟨o :: plan, sf, by simp; omega, ⟨hmem, hpre, hreach⟩, hgoal⟩
      · exact ⟨[], init, Nat.zero_le _, rfl, hg⟩

end Paradox.Escape
