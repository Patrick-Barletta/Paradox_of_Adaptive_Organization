/-!
# General theory: Propositions 1, 3, 3′ and 4 of Argument I, Section I.3 / I.5

Everything here is proved in full, with no `sorry` and no `native_decide`.

* `viab_sim`         — simulation theorem (the engine behind Props 1 and 4)
* `nesting`          — Proposition 1: a more permissive control class has a larger kernel
* `nesting_dominance`— Proposition 1 under the dominance form A3′
* `monotone_loss`    — Proposition 3: one admissible step into the kernel puts you in the kernel
* `loss_permanent`   — Proposition 3, contrapositive: kernel membership, once lost, is not regained
* `resources_monotone` — Proposition 4: with organization fixed, more resources never shrink the kernel
* `rate_upward`, `delay_never_lowers_required_rate` — Argument II, Proposition II.1
* `greedy_suffices`  — kernels can be computed by simulating a dominant rule (used for climate)
* `robust_strengthened` — Proposition 3′ (robust version with the strengthened premise)
* `robust_monotone_loss_fails` — Proposition 3 does NOT hold for robust kernels (explicit counterexample)
* `cap_not_nested`, `cap_kernel_shrinks`, `rate_upward_needs_nesting` — with capability-indexed
  reactions the nesting hypothesis of Proposition II.1 fails and a higher ceiling can shrink the
  kernel (explicit counterexample)
-/

namespace Paradox.Theory

/-- A discrete-time control system. `step t s s'` means some admissible action at time `t`
takes `s` to `s'`. `V` is the viability set. A control class is a choice of `step`. -/
structure Sys (S : Type) where
  step : Nat → S → S → Prop
  V : S → Prop

/-- `Viab sys n t s`: starting from `s` at time `t`, some admissible continuation stays in `V`
for the next `n` steps (and `s` itself is in `V`). -/
def Viab {S : Type} (sys : Sys S) : Nat → Nat → S → Prop
  | 0, _, s => sys.V s
  | n + 1, t, s => sys.V s ∧ ∃ s', sys.step t s s' ∧ Viab sys n (t + 1) s'

/-- The finite-horizon viability kernel at time `t` for terminal time `T`. -/
def K {S : Type} (sys : Sys S) (T t : Nat) (s : S) : Prop := Viab sys (T - t) t s

/-- **Simulation theorem.** If a relation `R` preserves viability and every step of system 1
can be matched by a step of system 2 that stays related, then viability transfers along `R`. -/
theorem viab_sim {S₁ S₂ : Type} (sys₁ : Sys S₁) (sys₂ : Sys S₂) (R : S₁ → S₂ → Prop)
    (hV : ∀ a b, R a b → sys₁.V a → sys₂.V b)
    (hstep : ∀ t a a' b, R a b → sys₁.step t a a' → ∃ b', sys₂.step t b b' ∧ R a' b') :
    ∀ n t a b, R a b → Viab sys₁ n t a → Viab sys₂ n t b := by
  intro n
  induction n with
  | zero => intro t a b hR h; exact hV a b hR h
  | succ n ih =>
    intro t a b hR h
    obtain ⟨hVa, a', hst, hv⟩ := h
    obtain ⟨b', hst', hR'⟩ := hstep t a a' b hR hst
    exact ⟨hV a b hR hVa, b', hst', ih (t + 1) a' b' hR' hv⟩

/-- **Proposition 1 (nesting).** Same viability set; every class-1 transition is a class-2
transition. Then the class-1 kernel is contained in the class-2 kernel. -/
theorem nesting {S : Type} (sys₁ sys₂ : Sys S) (hV : ∀ s, sys₁.V s → sys₂.V s)
    (hsub : ∀ t s s', sys₁.step t s s' → sys₂.step t s s') :
    ∀ T t s, K sys₁ T t s → K sys₂ T t s := by
  intro T t s h
  exact viab_sim sys₁ sys₂ (fun a b => a = b)
    (fun a b hab ha => hab ▸ hV a ha)
    (fun t a a' b hab hst => ⟨a', hab ▸ hsub t a a' hst, rfl⟩)
    (T - t) t s s rfl h

/-- **Proposition 1 under A3′ (dominance).** `ge b a` means "`b` is at least as good as `a`".
If viability is upward closed and system 2 can always match a system-1 step with a result at
least as good (from any state at least as good), the kernels nest. -/
theorem nesting_dominance {S : Type} (sys₁ sys₂ : Sys S) (ge : S → S → Prop)
    (hrefl : ∀ s, ge s s)
    (hV : ∀ a b, ge b a → sys₁.V a → sys₂.V b)
    (hsim : ∀ t a a' b, ge b a → sys₁.step t a a' → ∃ b', sys₂.step t b b' ∧ ge b' a') :
    ∀ T t s, K sys₁ T t s → K sys₂ T t s := by
  intro T t s h
  exact viab_sim sys₁ sys₂ (fun a b => ge b a) hV hsim (T - t) t s s (hrefl s) h

/-- **Proposition 3 (monotone loss), one-step form.** If `s` is viable now, an admissible step
leads to `s'`, and `s'` is in the kernel at `t+1`, then `s` is in the kernel at `t`. -/
theorem monotone_loss {S : Type} (sys : Sys S) {T t : Nat} {s s' : S} (hT : t < T)
    (hV : sys.V s) (hst : sys.step t s s') (h : K sys T (t + 1) s') : K sys T t s := by
  unfold K at *
  have e : T - t = (T - (t + 1)) + 1 := by omega
  rw [e]
  exact ⟨hV, s', hst, h⟩

/-- **Proposition 3, contrapositive.** Along any admissible step from a viable state, a state
outside the kernel leads to a state outside the kernel: membership, once lost, is not regained. -/
theorem loss_permanent {S : Type} (sys : Sys S) {T t : Nat} {s s' : S} (hT : t < T)
    (hV : sys.V s) (hst : sys.step t s s') (hout : ¬ K sys T t s) : ¬ K sys T (t + 1) s' :=
  fun h => hout (monotone_loss sys hT hV hst h)

/-- **Proposition 4 (resources cannot by themselves worsen severity).** States are pairs
`(x, o)` of physical state and organization-plus-commitments. `le x y` means `y` is at least as
good as `x`. Under upward-closed viability and organizational monotonicity (A4), a state with the
same organization and at least as good a physical state is in every kernel the poorer one is in. -/
theorem resources_monotone {X O : Type} (sys : Sys (X × O)) (le : X → X → Prop)
    (hV : ∀ x y o, le x y → sys.V (x, o) → sys.V (y, o))
    (hA4 : ∀ t x y o x' o', le x y → sys.step t (x, o) (x', o') →
            ∃ y', sys.step t (y, o) (y', o') ∧ le x' y') :
    ∀ T t x y o, le x y → K sys T t (x, o) → K sys T t (y, o) := by
  intro T t x y o hle h
  refine viab_sim sys sys (fun a b => a.2 = b.2 ∧ le a.1 b.1) ?_ ?_ (T - t) t (x, o) (y, o)
    ⟨rfl, hle⟩ h
  · rintro ⟨a1, a2⟩ ⟨b1, b2⟩ ⟨ho, hl⟩ ha
    simp only at ho hl
    subst ho
    exact hV a1 b1 a2 hl ha
  · rintro t ⟨a1, a2⟩ ⟨a1', a2'⟩ ⟨b1, b2⟩ ⟨ho, hl⟩ hst
    simp only at ho hl
    subst ho
    obtain ⟨y', hy', hle'⟩ := hA4 t a1 b1 a2 a1' a2' hl hst
    exact ⟨(y', a2'), hy', rfl, hle'⟩

/-- **Corollary (fingerprint of the paradox).** If a richer state is outside a kernel that a
poorer state is inside, the two must differ in organization or commitments. -/
theorem paradox_fingerprint {X O : Type} (sys : Sys (X × O)) (le : X → X → Prop)
    (hV : ∀ x y o, le x y → sys.V (x, o) → sys.V (y, o))
    (hA4 : ∀ t x y o x' o', le x y → sys.step t (x, o) (x', o') →
            ∃ y', sys.step t (y, o) (y', o') ∧ le x' y')
    {T t : Nat} {xA xB : X} {oA oB : O} (hle : le xA xB)
    (hA : K sys T t (xA, oA)) (hB : ¬ K sys T t (xB, oB)) : oA ≠ oB := by
  intro ho
  subst ho
  exact hB (resources_monotone sys le hV hA4 T t xA xB oA hle hA)


/-- **Greedy suffices.** If a single admissible rule `g` dominates every admissible step (from any
state at least as good, `g` reaches a state at least as good as the other step's result) and
viability is upward closed, then the kernel of the full class equals the kernel of the system that
only ever plays `g`. This is the justification for computing climate kernels by simulating maximal
deployment. -/
theorem greedy_suffices {S : Type} (sys : Sys S) (g : Nat → S → S) (ge : S → S → Prop)
    (hrefl : ∀ s, ge s s)
    (hadm : ∀ t s, sys.step t s (g t s))
    (hV : ∀ a b, ge b a → sys.V a → sys.V b)
    (hdom : ∀ t a a' b, ge b a → sys.step t a a' → ge (g t b) a') :
    ∀ T t s, K sys T t s ↔ K ⟨fun t s s' => s' = g t s, sys.V⟩ T t s := by
  intro T t s
  constructor
  · intro h
    exact viab_sim sys ⟨fun t s s' => s' = g t s, sys.V⟩ (fun a b => ge b a) hV
      (fun t a a' b hab hst => ⟨g t b, rfl, hdom t a a' b hab hst⟩) (T - t) t s s (hrefl s) h
  · intro h
    exact nesting ⟨fun t s s' => s' = g t s, sys.V⟩ sys (fun _ hs => hs)
      (fun t s s' (he : s' = g t s) => he ▸ hadm t s) T t s h


/-! ## Argument II: rate-bounded classes -/

/-- **Rate sufficiency is upward closed.** If the class of programs with acceleration ceiling `r`
is contained in the class with ceiling `r'` whenever `r ≤ r'`, then a rate that suffices keeps
sufficing at any higher ceiling. -/
theorem rate_upward {S R : Type} [LE R] (step : R → Nat → S → S → Prop) (V : S → Prop)
    (hnest : ∀ r r', r ≤ r' → ∀ t s s', step r t s s' → step r' t s s')
    {r r' : R} (hr : r ≤ r') :
    ∀ T t s, K ⟨step r, V⟩ T t s → K ⟨step r', V⟩ T t s :=
  nesting ⟨step r, V⟩ ⟨step r', V⟩ (fun _ h => h) (hnest r r' hr)

/-- **Proposition II.1 (delay never lowers the required rate).** Let the incumbent's step `b` be
admissible at its own rate `r0`. Then for every ceiling `r ≥ r0`: if `r` suffices after one more
year of incumbent operation, it already sufficed before that year. So the set of sufficient
ceilings can only shrink with delay, and the minimum required rate can only rise. -/
theorem delay_never_lowers_required_rate {S R : Type} [LE R]
    (step : R → Nat → S → S → Prop) (V : S → Prop)
    (hnest : ∀ r r', r ≤ r' → ∀ t s s', step r t s s' → step r' t s s')
    (r0 : R) (b : Nat → S → S) (hb : ∀ t s, step r0 t s (b t s))
    {r : R} (hr : r0 ≤ r) {T t : Nat} {s : S} (hT : t < T) (hVs : V s) :
    K ⟨step r, V⟩ T (t + 1) (b t s) → K ⟨step r, V⟩ T t s :=
  fun h => monotone_loss ⟨step r, V⟩ hT hVs (hnest r0 r hr t s (b t s) (hb t s)) h

/-! ## Uncertainty: robust kernels -/

/-- A system with disturbances: choosing control `u` at `s` can lead to any `s'` with
`trans s u s'`. -/
structure RSys (S U : Type) where
  avail : S → U → Prop
  trans : S → U → S → Prop
  V : S → Prop

/-- Robust viability: some available control keeps every possible successor robustly viable. -/
def RViab {S U : Type} (sys : RSys S U) : Nat → S → Prop
  | 0, s => sys.V s
  | n + 1, s => sys.V s ∧ ∃ u, sys.avail s u ∧ ∀ s', sys.trans s u s' → RViab sys n s'

/-- **Proposition 3′.** With the strengthened premise (every possible successor of the chosen
step is robustly viable), the robust analogue of monotone loss holds. -/
theorem robust_strengthened {S U : Type} (sys : RSys S U) {n : Nat} {s : S} {u : U}
    (hV : sys.V s) (hu : sys.avail s u) (hall : ∀ s', sys.trans s u s' → RViab sys n s') :
    RViab sys (n + 1) s :=
  ⟨hV, u, hu, hall⟩

/-- The counterexample system: state 0 has one control whose outcome is either 1 (safe forever)
or 2 (not viable). -/
def ex : RSys Nat Unit where
  avail _ _ := True
  trans s _ s' := (s = 0 ∧ (s' = 1 ∨ s' = 2)) ∨ (s = 1 ∧ s' = 1) ∨ (s = 2 ∧ s' = 2)
  V s := s ≠ 2

theorem ex_safe : ∀ n, RViab ex n 1 := by
  intro n
  induction n with
  | zero => show (1 : Nat) ≠ 2; decide
  | succ n ih =>
    refine ⟨by show (1 : Nat) ≠ 2; decide, (), trivial, ?_⟩
    intro s' h
    rcases h with ⟨h0, _⟩ | ⟨_, h1⟩ | ⟨h2, _⟩
    · exact absurd h0 (by decide)
    · subst h1; exact ih
    · exact absurd h2 (by decide)

theorem ex_start_not_robust : ∀ n, ¬ RViab ex (n + 1) 0 := by
  intro n h
  obtain ⟨_, u, _, hall⟩ := h
  have h2 : RViab ex n 2 := hall 2 (Or.inl ⟨rfl, Or.inr rfl⟩)
  cases n with
  | zero => exact (h2 : (2 : Nat) ≠ 2) rfl
  | succ m => exact (h2.1 : (2 : Nat) ≠ 2) rfl

/-- **Proposition 3 fails for robust kernels.** For every horizon `n` there is a viable state
`s`, a realized successor `s'`, such that `s'` is robustly viable for `n` steps but `s` is not
robustly viable for `n + 1`: robust membership can rise along a realized path. -/
theorem robust_monotone_loss_fails :
    ∀ n, ∃ (s s' : Nat) (u : Unit),
      ex.V s ∧ ex.avail s u ∧ ex.trans s u s' ∧ RViab ex n s' ∧ ¬ RViab ex (n + 1) s := by
  intro n
  exact ⟨0, 1, (), by show (0 : Nat) ≠ 2; decide, trivial, Or.inl ⟨rfl, Or.inl rfl⟩,
    ex_safe n, ex_start_not_robust n⟩

/-! ## Capability-indexed reactions: the nesting hypothesis cannot be dropped

`rate_upward` and `delay_never_lowers_required_rate` assume `hnest`: every transition available
under a lower ceiling is also available under a higher one. That holds when reactions depend on the
actions taken. It fails when they depend on the capabilities held: holding a higher ceiling changes
the outcome of a move the system could already make (antitrust triggered by capacity, a security
dilemma). Here, from state 0 the same move reaches the safe state 1 under ceiling 0, but under any
higher ceiling the reaction sends it to the non-viable state 2. -/

/-- Ceiling `r`; from state 0 the one move lands in 1 when `r = 0` and in 2 otherwise. States 1 and
2 are absorbing. -/
def capStep (r : Nat) (_t : Nat) (s s' : Nat) : Prop :=
  (s = 0 ∧ s' = (if r = 0 then 1 else 2)) ∨ (s = 1 ∧ s' = 1) ∨ (s = 2 ∧ s' = 2)

def capV (s : Nat) : Prop := s ≠ 2

abbrev capSys (r : Nat) : Sys Nat := ⟨capStep r, capV⟩

theorem cap_low_safe : ∀ n t, Viab (capSys 0) n t 1 := by
  intro n
  induction n with
  | zero => intro t; show (1 : Nat) ≠ 2; decide
  | succ n ih =>
    intro t
    exact ⟨show (1 : Nat) ≠ 2 by decide, 1, Or.inr (Or.inl ⟨rfl, rfl⟩), ih (t + 1)⟩

theorem cap_low_start : ∀ n t, Viab (capSys 0) n t 0 := by
  intro n t
  cases n with
  | zero => show (0 : Nat) ≠ 2; decide
  | succ n => exact ⟨show (0 : Nat) ≠ 2 by decide, 1, Or.inl ⟨rfl, rfl⟩, cap_low_safe n (t + 1)⟩

theorem cap_high_start : ∀ n t, ¬ Viab (capSys 1) (n + 1) t 0 := by
  intro n t h
  obtain ⟨_, s', hs, hv⟩ := h
  have e : s' = 2 := by simp [capStep] at hs; omega
  subst e
  cases n with
  | zero => exact (hv : (2 : Nat) ≠ 2) rfl
  | succ m => exact (hv.1 : (2 : Nat) ≠ 2) rfl

/-- The higher ceiling does not contain the lower ceiling's transitions: `hnest` fails. -/
theorem cap_not_nested : ¬ ∀ t s s', capStep 0 t s s' → capStep 1 t s s' := by
  intro h
  have h1 := h 0 0 1 (Or.inl ⟨rfl, rfl⟩)
  simp [capStep] at h1

/-- **Capability-indexed reactions can shrink the kernel.** For every horizon, state 0 is in the
kernel under ceiling 0 and outside it under ceiling 1. -/
theorem cap_kernel_shrinks (T t : Nat) (hT : t < T) :
    K (capSys 0) T t 0 ∧ ¬ K (capSys 1) T t 0 := by
  unfold K
  obtain ⟨n, hn⟩ : ∃ n, T - t = n + 1 := ⟨T - t - 1, by omega⟩
  rw [hn]
  exact ⟨cap_low_start (n + 1) t, cap_high_start n t⟩

/-- Without `hnest`, the conclusion of `rate_upward` is false: a rate that suffices need not keep
sufficing at a higher ceiling. -/
theorem rate_upward_needs_nesting :
    ¬ ∀ r r' : Nat, r ≤ r' → ∀ T t s, K (capSys r) T t s → K (capSys r') T t s := by
  intro h
  exact (cap_kernel_shrinks 1 0 (by omega)).2
    (h 0 1 (by omega) 1 0 0 (cap_kernel_shrinks 1 0 (by omega)).1)

end Paradox.Theory
