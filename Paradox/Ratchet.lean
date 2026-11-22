import Paradox.Theory

/-!
# Argument VI: the escape ratchet

Built on `Sys`, `Viab` and `K` from `Paradox/Theory.lean` (unchanged). We prove, with no `sorry`
and no `native_decide`:

* `latency_growth`, `ratchet_exhaustion`, `ratchet_first_failure`, `ratchet_exact_first_failure`
  (Theorem VI.1) — if each patching escape adds at least `δ ≥ 1` to the next escape's latency and
  deadlines are bounded, patching becomes infeasible, by cycle `⌊(D - ℓ₀)/δ⌋ + 1`, exactly then
  when growth is exact.
* `margin_exhaustion` (corollary) — a margin that falls by at least `δ ≥ 1` per escape becomes
  negative; it is not clamped.
* `chain_lower`, `chain_upper`, `chain_grows` — in an explicit serial dependency chain (a stage can
  be worked on only after its predecessor is complete), the minimum bootstrap time is the sum of
  the stage durations, and adding a stage of positive duration raises it.
* `esc_viable`, `esc_not_viable`, `ratchet_lockin_witness` (Theorem VI.2) — in a deadline-escape
  system shared by both control classes, a state where every organizational transition takes longer
  than the time left, while a physically admissible transition fits, is outside the adaptive kernel
  and inside the physical one (severity 3). The organizational restriction is an explicit list of
  admissible transitions.
* `invariant_viable` — a set closed under some admissible step and contained in the viability set
  is viable at every horizon (used for sustainable-landing claims).
-/

namespace Paradox.Ratchet

open Paradox.Theory

/-! ## Theorem VI.1: ratchet exhaustion -/

/-- Latency after `n` patching escapes is at least `ℓ 0 + n * δ`. -/
theorem latency_growth (ℓ : Nat → Nat) (δ : Nat) (h : ∀ n, ℓ n + δ ≤ ℓ (n + 1)) :
    ∀ n, ℓ 0 + n * δ ≤ ℓ n := by
  intro n
  induction n with
  | zero => simp
  | succ n ih => have := h n; rw [Nat.succ_mul]; omega

/-- **Theorem VI.1(a).** With latency growth of at least `δ ≥ 1` per patch and deadlines bounded by
`Dmax`, some cycle's latency exceeds its deadline: patching cannot stay feasible. -/
theorem ratchet_exhaustion (ℓ D : Nat → Nat) (δ Dmax : Nat) (hδ : 1 ≤ δ)
    (h : ∀ n, ℓ n + δ ≤ ℓ (n + 1)) (hD : ∀ n, D n ≤ Dmax) : ∃ n, D n < ℓ n := by
  refine ⟨Dmax + 1, ?_⟩
  have h1 := latency_growth ℓ δ h (Dmax + 1)
  have h2 : Dmax + 1 ≤ (Dmax + 1) * δ := Nat.le_mul_of_pos_right _ hδ
  have h3 := hD (Dmax + 1)
  omega

/-- `a < (a / b + 1) * b` for `b ≥ 1`. -/
theorem lt_succ_div_mul (a b : Nat) (hb : 1 ≤ b) : a < (a / b + 1) * b := by
  have h1 := Nat.div_add_mod a b
  have h2 := Nat.mod_lt a (by omega : b > 0)
  rw [Nat.succ_mul, Nat.mul_comm]
  omega

/-- **Theorem VI.1(b), bound.** With constant deadline `D` and `ℓ 0 ≤ D`, patching is infeasible
no later than cycle `N = ⌊(D - ℓ 0)/δ⌋ + 1`. -/
theorem ratchet_first_failure (ℓ : Nat → Nat) (δ D : Nat) (hδ : 1 ≤ δ)
    (h : ∀ n, ℓ n + δ ≤ ℓ (n + 1)) (h0 : ℓ 0 ≤ D) :
    D < ℓ ((D - ℓ 0) / δ + 1) := by
  have h1 := latency_growth ℓ δ h ((D - ℓ 0) / δ + 1)
  have h2 := lt_succ_div_mul (D - ℓ 0) δ hδ
  omega

/-- **Theorem VI.1(c), exactness.** With exact growth `ℓ (n + 1) = ℓ n + δ`, every cycle before `N`
is feasible and cycle `N` is the first infeasible one. -/
theorem ratchet_exact_first_failure (ℓ : Nat → Nat) (δ D : Nat) (hδ : 1 ≤ δ)
    (h : ∀ n, ℓ (n + 1) = ℓ n + δ) (h0 : ℓ 0 ≤ D) :
    (∀ n, n < (D - ℓ 0) / δ + 1 → ℓ n ≤ D) ∧ D < ℓ ((D - ℓ 0) / δ + 1) := by
  have hexact : ∀ n, ℓ n = ℓ 0 + n * δ := by
    intro n
    induction n with
    | zero => simp
    | succ n ih => rw [h n, ih, Nat.succ_mul]; omega
  refine ⟨fun n hn => ?_, ratchet_first_failure ℓ δ D hδ (fun n => by have := h n; omega) h0⟩
  rw [hexact n]
  have h1 : n * δ ≤ (D - ℓ 0) / δ * δ := Nat.mul_le_mul_right δ (by omega)
  have h2 : (D - ℓ 0) / δ * δ ≤ D - ℓ 0 := Nat.div_mul_le_self _ _
  omega

/-- **Corollary (margin exhaustion).** If the usable margin falls by at least `δ ≥ 1` per escape and
nothing replenishes it, it becomes negative; a negative margin is an infeasible escape. -/
theorem margin_exhaustion (m : Nat → Int) (δ : Nat) (hδ : 1 ≤ δ)
    (h : ∀ n, m (n + 1) ≤ m n - δ) : ∃ n, m n < 0 := by
  have hb : ∀ n : Nat, m n ≤ m 0 - ((n * δ : Nat) : Int) := by
    intro n
    induction n with
    | zero => simp
    | succ n ih =>
      have h1 := h n
      rw [Nat.succ_mul]
      generalize n * δ = P at *
      omega
  refine ⟨(m 0).toNat + 1, ?_⟩
  have h1 := hb ((m 0).toNat + 1)
  have h2 : (m 0).toNat + 1 ≤ ((m 0).toNat + 1) * δ := Nat.le_mul_of_pos_right _ hδ
  have h3 : m 0 ≤ ((m 0).toNat : Int) := Int.self_le_toNat (m 0)
  generalize ((m 0).toNat + 1) * δ = Q at *
  omega
/-! ## An explicit serial dependency chain

Stage `i` takes `τ i` ticks of work. Serial prerequisites: work goes only into the next incomplete
stage. The state is (stages completed, progress on the next stage). -/

/-- Total duration of the first `k` stages. -/
def psum (τ : Nat → Nat) : Nat → Nat
  | 0 => 0
  | k + 1 => psum τ k + τ k

/-- One tick of the chain: wait, or put one tick of work into the next stage. -/
def chainStep (τ : Nat → Nat) (s s' : Nat × Nat) : Prop :=
  s' = s ∨ (s.2 + 1 = τ s.1 ∧ s' = (s.1 + 1, 0)) ∨ (s.2 + 1 < τ s.1 ∧ s' = (s.1, s.2 + 1))

/-- `ChainReach τ n s`: the chain can be in state `s` after `n` ticks from `(0, 0)`. -/
inductive ChainReach (τ : Nat → Nat) : Nat → Nat × Nat → Prop
  | init : ChainReach τ 0 (0, 0)
  | step {n s s'} : ChainReach τ n s → chainStep τ s s' → ChainReach τ (n + 1) s'

/-- Completed work never exceeds elapsed time. -/
theorem chain_lower (τ : Nat → Nat) : ∀ n s, ChainReach τ n s → psum τ s.1 + s.2 ≤ n := by
  intro n s h
  induction h with
  | init => simp [psum]
  | step _ hs ih =>
    rcases hs with rfl | ⟨h1, rfl⟩ | ⟨_, rfl⟩
    · omega
    · simp only [psum]; omega
    · simp only; omega

/-- Working every tick completes the first `k` stages in exactly `psum τ k` ticks. -/
theorem chain_upper (τ : Nat → Nat) (hpos : ∀ i, 1 ≤ τ i) :
    ∀ k, ChainReach τ (psum τ k) (k, 0) := by
  intro k
  induction k with
  | zero => exact ChainReach.init
  | succ k ih =>
    -- inside stage k: after j more ticks, progress j (for j < τ k)
    have inner : ∀ j, j < τ k → ChainReach τ (psum τ k + j) (k, j) := by
      intro j
      induction j with
      | zero => intro _; simpa using ih
      | succ j ihj =>
        intro hj
        exact ChainReach.step (ihj (by omega)) (Or.inr (Or.inr ⟨by simp; omega, rfl⟩))
    have hlast := inner (τ k - 1) (by have := hpos k; omega)
    have e : psum τ (k + 1) = (psum τ k + (τ k - 1)) + 1 := by
      simp only [psum]; have := hpos k; omega
    rw [e]
    exact ChainReach.step hlast (Or.inr (Or.inl ⟨by simp; have := hpos k; omega, rfl⟩))

/-- **Bootstrap time.** Completing `N` stages is possible in `psum τ N` ticks and impossible in
fewer. -/
theorem chain_min_time (τ : Nat → Nat) (hpos : ∀ i, 1 ≤ τ i) (N : Nat) :
    ChainReach τ (psum τ N) (N, 0) ∧ ∀ n p, ChainReach τ n (N, p) → psum τ N ≤ n :=
  ⟨chain_upper τ hpos N, fun n p h => by have := chain_lower τ n (N, p) h; simp at this; omega⟩

/-- **Depth raises the bootstrap time.** Adding a stage of duration at least 1 raises the minimum
by its duration. -/
theorem chain_grows (τ : Nat → Nat) (N : Nat) : psum τ (N + 1) = psum τ N + τ N := rfl

/-- The ratchet chain: a seed stage of `ℓ₀` ticks followed by stages of `δ` ticks. -/
def ratchetStages (ℓ₀ δ : Nat) : Nat → Nat
  | 0 => ℓ₀
  | _ + 1 => δ

/-- With `n` patch stages after the seed, the bootstrap time is `ℓ₀ + n * δ`. -/
theorem ratchet_latency (ℓ₀ δ : Nat) : ∀ n, psum (ratchetStages ℓ₀ δ) (n + 1) = ℓ₀ + n * δ := by
  intro n
  induction n with
  | zero => simp [psum, ratchetStages]
  | succ n ih =>
    show psum (ratchetStages ℓ₀ δ) (n + 1) + ratchetStages ℓ₀ δ (n + 1) = ℓ₀ + (n + 1) * δ
    rw [ih, Nat.succ_mul]; simp [ratchetStages]; omega

/-! ## Theorem VI.2: a deadline-escape system and the lock-in witness

A regime faces a deadline `r` ticks away. The organization may start one escape transition from a
list `ds` of durations (its admissible transitions) and must complete it before the deadline. A
completed escape keeps the system viable from then on. Both control classes use this same
constructor; they differ only in the list of admissible transitions. -/

structure Esc where
  r : Nat               -- ticks left before functional failure
  w : Option Nat        -- remaining work of the transition under way, if any
  done : Bool           -- escape completed
  deriving DecidableEq

def escStep (ds : List Nat) (_t : Nat) (s s' : Esc) : Prop :=
  (s.done = true ∧ s' = s) ∨
  (s.done = false ∧ s.w = none ∧ s' = ⟨s.r - 1, none, false⟩) ∨
  (s.done = false ∧ s.w = none ∧ ∃ d ∈ ds, 1 ≤ d ∧
     s' = if d = 1 then ⟨s.r - 1, none, true⟩ else ⟨s.r - 1, some (d - 1), false⟩) ∨
  (s.done = false ∧ ∃ k, s.w = some k ∧
     s' = if k = 1 then ⟨s.r - 1, none, true⟩ else ⟨s.r - 1, some (k - 1), false⟩)

def escV (s : Esc) : Prop := s.done = true ∨ 0 < s.r

def escSys (ds : List Nat) : Sys Esc := ⟨escStep ds, escV⟩

theorem esc_done_viable (ds : List Nat) : ∀ n t (s : Esc), s.done = true → Viab (escSys ds) n t s := by
  intro n
  induction n with
  | zero => intro t s h; exact Or.inl h
  | succ n ih => intro t s h; exact ⟨Or.inl h, s, Or.inl ⟨h, rfl⟩, ih (t + 1) s h⟩

/-- Work under way that fits in the time left completes in time. -/
theorem esc_work_viable (ds : List Nat) :
    ∀ k n t r, 1 ≤ k → k ≤ r → Viab (escSys ds) n t ⟨r, some k, false⟩ := by
  intro k
  induction k with
  | zero => intro _ _ _ h; omega
  | succ k ih =>
    intro n t r _ hkr
    cases n with
    | zero => exact Or.inr (by simp; omega)
    | succ n =>
      by_cases hk : k = 0
      · subst hk
        refine ⟨Or.inr (by simp; omega), ⟨r - 1, none, true⟩, ?_, esc_done_viable ds n _ _ rfl⟩
        exact Or.inr (Or.inr (Or.inr ⟨rfl, 1, rfl, by simp⟩))
      · refine ⟨Or.inr (by simp; omega), ⟨r - 1, some k, false⟩, ?_, ih n (t + 1) (r - 1) (by omega) (by omega)⟩
        refine Or.inr (Or.inr (Or.inr ⟨rfl, k + 1, rfl, ?_⟩))
        simp [hk]

/-- **Escape possible.** If some admissible transition fits in the time left, the regime is viable
at every horizon. -/
theorem esc_viable (ds : List Nat) (r : Nat) (h : ∃ d ∈ ds, 1 ≤ d ∧ d ≤ r) :
    ∀ n t, Viab (escSys ds) n t ⟨r, none, false⟩ := by
  obtain ⟨d, hd, hd1, hdr⟩ := h
  intro n t
  cases n with
  | zero => exact Or.inr (by simp; omega)
  | succ n =>
    refine ⟨Or.inr (by simp; omega),
      (if d = 1 then ⟨r - 1, none, true⟩ else ⟨r - 1, some (d - 1), false⟩),
      Or.inr (Or.inr (Or.inl ⟨rfl, rfl, d, hd, hd1, rfl⟩)), ?_⟩
    by_cases h1 : d = 1
    · simp only [h1, if_true]; exact esc_done_viable ds n _ _ rfl
    · simp only [h1, if_false]; exact esc_work_viable ds (d - 1) n (t + 1) (r - 1) (by omega) (by omega)

/-- Invariant for impossibility: not done, and whatever is under way or startable needs more time
than is left. -/
abbrev Hopeless (ds : List Nat) (s : Esc) : Prop :=
  s.done = false ∧ (s.w = none → ∀ d ∈ ds, s.r < d) ∧ (∀ k, s.w = some k → s.r < k)

theorem hopeless_step (ds : List Nat) {t : Nat} {s s' : Esc} (hV : escV s) (h : Hopeless ds s)
    (hs : escStep ds t s s') : Hopeless ds s' ∧ s'.r = s.r - 1 := by
  obtain ⟨hd, hn, hk⟩ := h
  have hr : 0 < s.r := by rcases hV with h' | h' <;> simp_all
  rcases hs with ⟨h1, _⟩ | ⟨_, hw, rfl⟩ | ⟨_, hw, d, hdm, hd1, rfl⟩ | ⟨_, k, hw, rfl⟩
  · simp_all
  · refine ⟨⟨rfl, fun _ d hdm => ?_, fun k hk' => by simp at hk'⟩, rfl⟩
    have := hn hw d hdm; simp; omega
  · have := hn hw d hdm
    by_cases h1 : d = 1
    · omega
    · rw [if_neg h1]
      refine ⟨⟨rfl, fun h' => by simp at h', fun k hk' => ?_⟩, rfl⟩
      simp only [Option.some.injEq] at hk'
      show s.r - 1 < k
      omega
  · have := hk k hw
    by_cases h1 : k = 1
    · omega
    · rw [if_neg h1]
      refine ⟨⟨rfl, fun h' => by simp at h', fun k' hk' => ?_⟩, rfl⟩
      simp only [Option.some.injEq] at hk'
      show s.r - 1 < k'
      omega

/-- **Escape impossible.** If every admissible transition needs more time than is left, the regime
is not viable for any horizon longer than the time left. -/
theorem esc_not_viable (ds : List Nat) :
    ∀ n t (s : Esc), Hopeless ds s → s.r < n → ¬ Viab (escSys ds) n t s := by
  intro n
  induction n with
  | zero => intro t s _ h; omega
  | succ n ih =>
    intro t s hh hn ⟨hV, s', hs, hrest⟩
    obtain ⟨hh', hr'⟩ := hopeless_step ds (t := t) hV hh hs
    have hpos : 0 < s.r := by rcases hV with h' | h' <;> simp_all [Hopeless]
    exact ih (t + 1) s' hh' (by omega) hrest

/-- **Theorem VI.2 (organizational lock-in witness).** Let the organizational class admit the
transitions `dsOrg` and the physical class `dsPhys`, built by the same constructor (same transition
and response laws). Suppose every organizational transition needs more than the `r` ticks left,
while some physically admissible transition fits. Then for any horizon `T > r` the state is outside
the adaptive kernel and inside the physical kernel: severity 3. The organizational restriction is the
explicit difference between the two lists (for example an unauthorized independent seed). -/
theorem ratchet_lockin_witness (dsOrg dsPhys : List Nat) (r T : Nat) (hT : r < T)
    (horg : ∀ d ∈ dsOrg, r < d) (hphys : ∃ d ∈ dsPhys, 1 ≤ d ∧ d ≤ r) :
    ¬ K (escSys dsOrg) T 0 ⟨r, none, false⟩ ∧ K (escSys dsPhys) T 0 ⟨r, none, false⟩ := by
  constructor
  · intro h
    exact esc_not_viable dsOrg (T - 0) 0 _ ⟨rfl, fun _ => horg, fun k hk => by simp at hk⟩
      (by simp; omega) h
  · exact esc_viable dsPhys r hphys (T - 0) 0

/-! ## Sustainable landing: invariant sets -/

/-- **Invariant viability.** If every state of `I` is viable and has an admissible step into `I`,
every state of `I` is viable at every horizon. -/
theorem invariant_viable {S : Type} (sys : Sys S) (I : S → Prop)
    (hV : ∀ s, I s → sys.V s) (hstep : ∀ t s, I s → ∃ s', sys.step t s s' ∧ I s') :
    ∀ n t s, I s → Viab sys n t s := by
  intro n
  induction n with
  | zero => intro t s hs; exact hV s hs
  | succ n ih =>
    intro t s hs
    obtain ⟨s', h1, h2⟩ := hstep t s hs
    exact ⟨hV s hs, s', h1, ih (t + 1) s' h2⟩

end Paradox.Ratchet
