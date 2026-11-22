import Paradox.Theory

/-!
# Argument V: horizons, structural concessions and calm-period erosion

Built on `Sys`, `Viab` and `K` from `Paradox/Theory.lean` (unchanged). We prove, with no `sorry`
and no `native_decide`:

* `viab_shorten`, `horizon_antitone` (Theorem V.1) — a longer horizon can only shrink a kernel.
* `concession_crossover` (Theorem V.2) — a structural concession that survives now but carries a
  permanent scar is in the kernel for every horizon up to the scar's shock tick and out of it for
  every longer horizon, while a clean fix is out of every kernel when it is unaffordable and in
  every kernel when it is affordable.
* `calm_floor`, `calm_erosion_fatal` (Theorem V.3) — an adaptive floor that resets after a shock
  and relaxes by one after every `k` calm ticks survives a shock that follows a short calm and
  fails the same shock after a long one.
-/

namespace Paradox.Concession

open Paradox.Theory

/-! ## Theorem V.1: horizon monotonicity -/

/-- Viability for `n + m` steps implies viability for `n` steps. -/
theorem viab_shorten {S : Type} (sys : Sys S) :
    ∀ n m t s, Viab sys (n + m) t s → Viab sys n t s := by
  intro n
  induction n with
  | zero =>
    intro m t s h
    cases m with
    | zero => exact h
    | succ m => exact h.1
  | succ n ih =>
    intro m t s h
    have h' : Viab sys ((n + m) + 1) t s := by
      have : n + 1 + m = (n + m) + 1 := by omega
      rw [this] at h; exact h
    obtain ⟨hV, s', hstep, hrest⟩ := h'
    exact ⟨hV, s', hstep, ih m (t + 1) s' hrest⟩

/-- **Theorem V.1 (horizon antitone).** For `t ≤ T₁ ≤ T₂`, membership in the kernel for the
longer horizon implies membership for the shorter one. -/
theorem horizon_antitone {S : Type} (sys : Sys S) {T₁ T₂ t : Nat} (h₁ : t ≤ T₁) (h₂ : T₁ ≤ T₂)
    (s : S) : K sys T₂ t s → K sys T₁ t s := by
  intro h
  unfold K at *
  have : T₂ - t = (T₁ - t) + (T₂ - T₁) := by omega
  rw [this] at h
  exact viab_shorten sys _ _ t s h

/-! ## Theorem V.2: horizon reversal of a structural concession

The state is a reserve level (an integer). After the choice at tick 0:

* the **clean fix** leaves reserves `r₀ - cFix` and is invariant afterwards (recurring shocks cost
  it nothing it cannot absorb);
* the **concession** leaves reserves `r₀ - cConc` with `cConc ≤ r₀`, but carries a scar: the forced
  switch during tick `Tstar` costs it `D`, more than it can hold.

Viability is nonnegative reserves. -/

def cleanSys : Sys Int := ⟨fun _ r r' => r' = r, fun r => 0 ≤ r⟩

def concSys (Tstar : Nat) (D : Int) : Sys Int :=
  ⟨fun t r r' => r' = r - (if t = Tstar then D else 0), fun r => 0 ≤ r⟩

theorem viab_V {S : Type} (sys : Sys S) : ∀ n t s, Viab sys n t s → sys.V s := by
  intro n t s h
  cases n with
  | zero => exact h
  | succ n => exact h.1

theorem clean_viab : ∀ n t (r : Int), 0 ≤ r → Viab cleanSys n t r := by
  intro n
  induction n with
  | zero => intro t r hr; exact hr
  | succ n ih => intro t r hr; exact ⟨hr, r, rfl, ih (t + 1) r hr⟩

theorem clean_fail : ∀ n t (r : Int), r < 0 → ¬ Viab cleanSys n t r := by
  intro n t r hr h
  have := viab_V cleanSys n t r h
  simp [cleanSys] at this
  omega

theorem conc_viab (Tstar : Nat) (D : Int) :
    ∀ n t (r : Int), 0 ≤ r → t + n ≤ Tstar → Viab (concSys Tstar D) n t r := by
  intro n
  induction n with
  | zero => intro t r hr _; exact hr
  | succ n ih =>
    intro t r hr ht
    have hne : t ≠ Tstar := by omega
    refine ⟨hr, r, ?_, ih (t + 1) r hr (by omega)⟩
    simp [concSys, hne]

theorem conc_fail (Tstar : Nat) (D : Int) :
    ∀ n t (r : Int), t ≤ Tstar → Tstar < t + n → r < D → ¬ Viab (concSys Tstar D) n t r := by
  intro n
  induction n with
  | zero => intro t r h1 h2 _; omega
  | succ n ih =>
    intro t r h1 h2 hD ⟨_, r', hstep, hrest⟩
    by_cases heq : t = Tstar
    · have hr' : r' = r - D := by simp [concSys, heq] at hstep; exact hstep
      have := viab_V (concSys Tstar D) n (t + 1) r' hrest
      simp [concSys] at this
      omega
    · have hr' : r' = r := by simp [concSys, heq] at hstep; exact hstep
      subst hr'
      exact ih (t + 1) r' (by omega) (by omega) hD hrest

/-- **Theorem V.2 (concession crossover).** Suppose the concession is affordable (`cConc ≤ r₀`)
and its scar is fatal (`r₀ - cConc < D`). Then:

1. for every horizon `T ≤ Tstar` the concession is in the kernel, and if the clean fix is
   unaffordable (`r₀ < cFix`) it is out of the kernel;
2. for every horizon `T > Tstar` the concession is out of the kernel, and if the clean fix is
   affordable (`cFix ≤ r₀`) it is in the kernel. -/
theorem concession_crossover (r₀ cFix cConc D : Int) (Tstar : Nat)
    (hconc : cConc ≤ r₀) (hscar : r₀ - cConc < D) :
    (∀ T, T ≤ Tstar →
      K (concSys Tstar D) T 0 (r₀ - cConc) ∧ (r₀ < cFix → ¬ K cleanSys T 0 (r₀ - cFix))) ∧
    (∀ T, Tstar < T →
      ¬ K (concSys Tstar D) T 0 (r₀ - cConc) ∧ (cFix ≤ r₀ → K cleanSys T 0 (r₀ - cFix))) := by
  refine ⟨fun T hT => ⟨?_, fun hfix => ?_⟩, fun T hT => ⟨?_, fun hfix => ?_⟩⟩
  · exact conc_viab Tstar D (T - 0) 0 _ (by omega) (by omega)
  · exact clean_fail (T - 0) 0 _ (by omega)
  · exact conc_fail Tstar D (T - 0) 0 _ (by omega) (by omega) (by omega)
  · exact clean_viab (T - 0) 0 _ (by omega)

/-! ## Theorem V.3: calm-period erosion

An adaptive controller keeps a reserve floor `m` and counts calm ticks `c`. After a shock it resets
to `(mMax, 0)`. On a calm tick the counter advances; after `k` consecutive calm ticks the floor
drops by one (not below zero) and the counter restarts. A shock needing a floor of `mReq` is
survived iff the current floor is at least `mReq`. -/

/-- One calm tick. -/
def calmStep (k : Nat) (st : Nat × Nat) : Nat × Nat :=
  if st.2 + 1 = k then (st.1 - 1, 0) else (st.1, st.2 + 1)

/-- The controller state after `L` calm ticks since the last shock. -/
def afterCalm (mMax k : Nat) : Nat → Nat × Nat
  | 0 => (mMax, 0)
  | L + 1 => calmStep k (afterCalm mMax k L)

/-- After `L` calm ticks, `L = q * k + c` with `c < k` and the floor is `mMax - q`. -/
theorem calm_floor (mMax k : Nat) (hk : 1 ≤ k) :
    ∀ L, ∃ q c, L = q * k + c ∧ c < k ∧ afterCalm mMax k L = (mMax - q, c) := by
  intro L
  induction L with
  | zero => exact ⟨0, 0, by simp, by omega, rfl⟩
  | succ L ih =>
    obtain ⟨q, c, hL, hc, hst⟩ := ih
    simp only [afterCalm, hst, calmStep]
    by_cases h : c + 1 = k
    · refine ⟨q + 1, 0, ?_, by omega, ?_⟩
      · rw [Nat.succ_mul]; omega
      · simp [h]; omega
    · exact ⟨q, c + 1, by omega, by omega, by simp [h]⟩

/-- **Theorem V.3 (the calm paradox).** Let `1 ≤ mReq ≤ mMax` and `1 ≤ k`. A shock needing floor
`mReq` that arrives after fewer than `k` calm ticks is survived; the same shock arriving after at
least `k * (mMax - mReq + 1)` calm ticks is fatal. -/
theorem calm_erosion_fatal (mMax k mReq : Nat) (hk : 1 ≤ k) (h1 : 1 ≤ mReq) (h2 : mReq ≤ mMax) :
    (∀ L, L < k → mReq ≤ (afterCalm mMax k L).1) ∧
    (∀ L, k * (mMax - mReq + 1) ≤ L → (afterCalm mMax k L).1 < mReq) := by
  constructor
  · intro L hL
    obtain ⟨q, c, hLq, hc, hst⟩ := calm_floor mMax k hk L
    rw [hst]
    have hq : q = 0 := by
      rcases Nat.eq_zero_or_pos q with h | h
      · exact h
      · have : k ≤ q * k := Nat.le_mul_of_pos_left k h
        omega
    simp [hq]; omega
  · intro L hL
    obtain ⟨q, c, hLq, hc, hst⟩ := calm_floor mMax k hk L
    rw [hst]
    have hq : mMax - mReq + 1 ≤ q := by
      apply Nat.le_of_not_lt
      intro hlt
      have h3 : (q + 1) * k ≤ (mMax - mReq + 1) * k := Nat.mul_le_mul_right k (by omega)
      have h4 : (q + 1) * k = q * k + k := Nat.succ_mul q k
      have h5 : k * (mMax - mReq + 1) = (mMax - mReq + 1) * k := Nat.mul_comm _ _
      omega
    simp only
    omega

end Paradox.Concession
