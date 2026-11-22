import Paradox.Theory
import Paradox.Ratchet

/-!
# Argument VI, Part II: the joint system of three agents on a shared recovery chain

Three agents each own one segment of a shared serial recovery chain (the seed stage, then
segment 1, segment 2, segment 3). This file adds no new viability notion. It instantiates the
machinery of `Paradox/Theory.lean` on a joint state and uses its theorems:

* **State (I.3.1).** `JSt` is `s = (x, O, q)`: `up` is the physical state `x` (the shared service
  functions); the segment depths `n₁ n₂ n₃` are commitments `q` (the serial stages each agent's
  patches have added to the recovery path); `auth` is part of the organization `O` (whether the
  independent seed is an admissible action). The transition `fJ` is total: every joint action has a
  successor; a missed deadline sets `x` to "down".
* **A0.** `V` depends only on `x` (`V s := s.up = true`). Authorization, votes and routines enter only
  through admissible actions, never through `V`.
* **A1.** Every agent has a null action (`Seg.idle`: no work on its segment), and agent 1 a null move
  (no proposal); both are always admissible (`a1_null`).
* **A2.** Neutral partners run total routines `JSt → PMove`; every action is realizable, so the
  fallback map is the identity.
* **A3.** Every organizational joint step is a step of the physical class (`a3_phys`).
* **Control classes (I.3.3), per agent.** Agent 1 is in `𝒰_adapt`. A partner is in `𝒰_fixed` (a
  neutral partner: its incumbent routine and meta-policy `(π₀, μ₀)`) or in `𝒰_adapt` (a cooperative
  partner). The joint class assigns a class to each agent. The physical class `𝒰_phys` removes every
  organizational restriction: routines are freed and the seed is admissible without authorization.
* **Adversaries (I.3.8).** An adversarial partner is not a controller. Its action is a disturbance
  ranging over a disturbance set `W`, and survival is the robust kernel `RViab` of an `RSys`. Without
  adversaries the robust kernel *is* the kernel `K` of the deterministic joint `Sys` (`kernel_eq`).

Results, with no `sorry` and no `native_decide`:

* `psum_cat`, `shared_makespan`, `shared_bootstrap` — the joint bootstrap time of the shared chain is
  the seed stage plus the three segment times, and no schedule is faster (`chain_min_time`).
* `class_nesting_K` (Proposition 1, `nesting`), `rnesting` (Proposition 1 for robust kernels, as
  I.3.8 states), `stance_nesting` (Theorem VI.3) — adversary ⊆ fixed ⊆ adapt for each partner, and
  `a3_phys` — adapt ⊆ phys.
* `shared_ratchet_one`, `shared_ratchet_three`, `shared_ratchet_two`, `adversary_ratchet`
  (Theorem VI.4) — with no seed, one partner whose routine always patches bounds the survival of the
  joint system by `⌊(D - ℓ₀)/δ⌋ + 1` cycles (two such partners: `⌊(D - ℓ₀)/(2δ)⌋ + 1`), Theorem
  VI.1's latency argument along the joint path (`rviab_budget`).
* `neutral_lockin` — that exclusion is severity 3 when all-prune is physically sustainable.
* `seed_sustainable` (`invariant_viable`'s robust form), `early_authorization` (Proposition 3′,
  `robust_strengthened`), `veto_ratchet`, `veto_severity`, `overt_lockin` (Theorem VI.5).
-/

namespace Paradox.SharedRatchet

open Paradox.Theory Paradox.Ratchet

/-! ## Serial composition of segments -/

/-- Stages of `τ₁` (the first `a`), followed by the stages of `τ₂`. -/
def cat (τ₁ : Nat → Nat) (a : Nat) (τ₂ : Nat → Nat) (i : Nat) : Nat :=
  if i < a then τ₁ i else τ₂ (i - a)

theorem psum_cat_prefix (τ₁ τ₂ : Nat → Nat) (a : Nat) :
    ∀ k, k ≤ a → psum (cat τ₁ a τ₂) k = psum τ₁ k := by
  intro k
  induction k with
  | zero => intro _; rfl
  | succ k ih =>
    intro hk
    show psum (cat τ₁ a τ₂) k + cat τ₁ a τ₂ k = psum τ₁ k + τ₁ k
    have hlt : k < a := by omega
    rw [ih (by omega)]
    simp only [cat, if_pos hlt]

/-- The duration of a concatenated chain is the sum of the parts. -/
theorem psum_cat (τ₁ τ₂ : Nat → Nat) (a : Nat) :
    ∀ b, psum (cat τ₁ a τ₂) (a + b) = psum τ₁ a + psum τ₂ b := by
  intro b
  induction b with
  | zero => exact psum_cat_prefix τ₁ τ₂ a a (Nat.le_refl a)
  | succ b ih =>
    show psum (cat τ₁ a τ₂) (a + b) + cat τ₁ a τ₂ (a + b) = psum τ₁ a + (psum τ₂ b + τ₂ b)
    have hn : ¬ (a + b < a) := by omega
    rw [ih]
    simp only [cat, if_neg hn, Nat.add_sub_cancel_left]
    omega

theorem psum_const (c : Nat) : ∀ n, psum (fun _ => c) n = n * c := by
  intro n
  induction n with
  | zero => simp [psum]
  | succ n ih => show psum (fun _ => c) n + c = (n + 1) * c; rw [ih, Nat.succ_mul]

/-! ## Robust kernels (I.3.8): Proposition 1, the deterministic case, budgets and invariants -/

/-- **Proposition 1 for robust kernels** (I.3.8: "Propositions 1 and 2 carry over"). If every
admissible control of `sys` at a viable state is matched by an admissible control of `sys'` whose
possible successors are among those of the original control, robust viability transfers. -/
theorem rnesting {S U U' : Type} (sys : RSys S U) (sys' : RSys S U') (hV : ∀ s, sys.V s → sys'.V s)
    (h : ∀ s u, sys.V s → sys.avail s u →
      ∃ u', sys'.avail s u' ∧ ∀ s', sys'.trans s u' s' → sys.trans s u s') :
    ∀ n s, RViab sys n s → RViab sys' n s := by
  intro n
  induction n with
  | zero => intro s hs; exact hV s hs
  | succ n ih =>
    intro s hs
    obtain ⟨hVs, u, hu, hall⟩ := hs
    obtain ⟨u', hu', hsub⟩ := h s u hVs hu
    exact ⟨hV s hVs, u', hu', fun s' hs' => ih s' (hall s' (hsub s' hs'))⟩

/-- **The deterministic case.** If each control has exactly one successor `F s u`, the robust kernel
is the kernel of the `Sys` whose step is "some admissible control leads to `s'`". -/
theorem rviab_det {S U : Type} (sys : RSys S U) (F : S → U → S)
    (hdet : ∀ s u s', sys.trans s u s' ↔ s' = F s u) :
    ∀ n t s, RViab sys n s ↔ Viab ⟨fun _ s s' => ∃ u, sys.avail s u ∧ s' = F s u, sys.V⟩ n t s := by
  intro n
  induction n with
  | zero => intro t s; exact Iff.rfl
  | succ n ih =>
    intro t s
    constructor
    · intro hs
      obtain ⟨hV, u, hu, hall⟩ := hs
      exact ⟨hV, F s u, ⟨u, hu, rfl⟩, (ih (t + 1) _).mp (hall _ ((hdet s u _).mpr rfl))⟩
    · intro hs
      obtain ⟨hV, s', ⟨u, hu, he⟩, hv⟩ := hs
      refine ⟨hV, u, hu, fun s'' hs'' => ?_⟩
      rw [(hdet s u s'').mp hs'', ← he]
      exact (ih (t + 1) s').mpr hv

/-- **Budget along robust paths** (Theorem VI.1's latency argument, `latency_growth`, applied along
the path). If every admissible step from a viable state of an invariant set that reaches a viable
state needs `c + φ s ≤ D` and raises `φ` by at least `k`, and every control has some successor, then
robust viability for `n + 1` steps needs `c + φ s + n * k ≤ D`. -/
theorem rviab_budget {S U : Type} (sys : RSys S U)
    (hne : ∀ s u, sys.V s → sys.avail s u → ∃ s', sys.trans s u s')
    (I : S → Prop) (φ : S → Nat) (c k D : Nat)
    (h : ∀ s u s', sys.V s → I s → sys.avail s u → sys.trans s u s' → sys.V s' →
      c + φ s ≤ D ∧ φ s + k ≤ φ s' ∧ I s') :
    ∀ n s, I s → RViab sys (n + 1) s → c + φ s + n * k ≤ D := by
  intro n
  induction n with
  | zero =>
    intro s hI hs
    obtain ⟨hV, u, hu, hall⟩ := hs
    obtain ⟨s', hs'⟩ := hne s u hV hu
    have := h s u s' hV hI hu hs' (hall s' hs')
    omega
  | succ n ih =>
    intro s hI hs
    obtain ⟨hV, u, hu, hall⟩ := hs
    obtain ⟨s', hs'⟩ := hne s u hV hu
    have hn := hall s' hs'
    obtain ⟨h1, h2, h3⟩ := h s u s' hV hI hu hs' hn.1
    have := ih s' h3 hn
    rw [Nat.succ_mul]
    omega

/-- **Robust invariance** (the robust form of `invariant_viable`), built from Proposition 3′. -/
theorem rinvariant {S U : Type} (sys : RSys S U) (I : S → Prop) (hV : ∀ s, I s → sys.V s)
    (hstep : ∀ s, I s → ∃ u, sys.avail s u ∧ ∀ s', sys.trans s u s' → I s') :
    ∀ n s, I s → RViab sys n s := by
  intro n
  induction n with
  | zero => intro s hs; exact hV s hs
  | succ n ih =>
    intro s hs
    obtain ⟨u, hu, hall⟩ := hstep s hs
    exact robust_strengthened sys (hV s hs) hu (fun s' hs' => ih s' (hall s' hs'))

/-! ## The joint state and transition -/

/-- An agent's operational action on its own segment; `idle` is the null action (A1). -/
inductive Seg | patch | prune | idle
  deriving DecidableEq, Repr, Inhabited

/-- Seed governance: no seed, authorization by agent 1 alone, or by all three agents. -/
inductive Gov | noSeed | unilateral | unanimous
  deriving DecidableEq, Repr, Inhabited

def Gov.hasSeed : Gov → Bool
  | .noSeed => false
  | _ => true

def Gov.unilat : Gov → Bool
  | .unilateral => true
  | _ => false

def Gov.unan : Gov → Bool
  | .unanimous => true
  | _ => false

/-- Deadline `D`, seed stage `l0`, patch stage `delta`, prune slope `lam`, authorization time `alpha`,
governance, `phys` (the physical class: the seed is admissible without authorization) and `overt`
(an adversary's disturbance set includes withholding its segment). -/
structure Par where
  D : Nat
  l0 : Nat
  delta : Nat
  lam : Nat
  alpha : Nat
  gov : Gov
  phys : Bool
  overt : Bool

/-- The joint state `s = (x, O, q)`: `up` is `x`; the depths are commitments `q`; `auth` is part of
`O`. -/
structure JSt where
  up : Bool
  n₁ : Nat
  n₂ : Nat
  n₃ : Nat
  auth : Bool
  deriving DecidableEq, Repr, Inhabited

/-- Agent 1's action: escape through the seed instead of the chain, its own segment action, and
whether it makes the capability-changing move "propose authorizing the seed". -/
structure CMove where
  seed : Bool
  seg : Seg
  propose : Bool
  deriving DecidableEq, Repr, Inhabited

/-- A partner's action: its segment action and its vote on a proposal. -/
structure PMove where
  seg : Seg
  vote : Bool
  deriving DecidableEq, Repr, Inhabited

def segTime (p : Par) : Seg → Nat → Nat
  | .patch, n => p.delta * n
  | .prune, n => 1 + p.lam * n
  | .idle, _ => 0

def segNext : Seg → Nat → Nat
  | .patch, n => n + 1
  | .prune, _ => 0
  | .idle, n => n

/-- Whether the agent restores its segment this cycle (the null action does not). -/
def restored : Seg → Bool
  | .idle => false
  | _ => true

def allRestored (m₁ : CMove) (m₂ m₃ : PMove) : Bool :=
  restored m₁.seg && restored m₂.seg && restored m₃.seg

def proposes (p : Par) (s : JSt) (m : CMove) : Bool := m.propose && !s.auth && p.gov.hasSeed

def passes (p : Par) (s : JSt) (m₁ : CMove) (m₂ m₃ : PMove) : Bool :=
  proposes p s m₁ && (p.gov.unilat || (m₂.vote && m₃.vote))

/-- The proposal's cost: `alpha` ticks of the current crisis (the move's resource draw, I.3.1). -/
def authCost (p : Par) (s : JSt) (m₁ : CMove) : Nat := if proposes p s m₁ then p.alpha else 0

/-- Joint escape time through the chain: the seed stage plus the three segment times. -/
def jointTime (p : Par) (s : JSt) (m₁ : CMove) (m₂ m₃ : PMove) : Nat :=
  p.l0 + segTime p m₁.seg s.n₁ + segTime p m₂.seg s.n₂ + segTime p m₃.seg s.n₃

def down (s : JSt) : JSt := { s with up := false }

/-- **The transition** `(x, O, q) ↦ (f, g, h)` (I.3.1), total in the joint action. The seed escape
takes one tick; the chain escape needs every segment restored and the joint time, plus the cost of a
proposal, within the deadline. Otherwise the service goes down. -/
def fJ (p : Par) (s : JSt) (m₁ : CMove) (m₂ m₃ : PMove) : JSt :=
  if s.up = false then s
  else if m₁.seed = true then
    if 1 + authCost p s m₁ ≤ p.D then ⟨true, s.n₁, s.n₂, s.n₃, s.auth || passes p s m₁ m₂ m₃⟩
    else down s
  else if allRestored m₁ m₂ m₃ = true ∧ jointTime p s m₁ m₂ m₃ + authCost p s m₁ ≤ p.D then
    ⟨true, segNext m₁.seg s.n₁, segNext m₂.seg s.n₂, segNext m₃.seg s.n₃,
      s.auth || passes p s m₁ m₂ m₃⟩
  else down s

/-- Agent 1's admissible actions `𝒜(x, O, q)`: the seed escape needs authorization (in the physical
class, only that the seed exists); a proposal needs a seed not yet authorized. -/
def adm₁ (p : Par) (s : JSt) (m : CMove) : Prop :=
  (m.seed = true → p.gov.hasSeed = true ∧ (s.auth = true ∨ p.phys = true)) ∧
  (m.propose = true → p.gov.hasSeed = true ∧ s.auth = false)

theorem fJ_seed {p : Par} {s : JSt} {m₁ : CMove} {m₂ m₃ : PMove} (hup : s.up = true)
    (hs : m₁.seed = true) (hc : 1 + authCost p s m₁ ≤ p.D) :
    fJ p s m₁ m₂ m₃ = ⟨true, s.n₁, s.n₂, s.n₃, s.auth || passes p s m₁ m₂ m₃⟩ := by
  have hnd : ¬ (s.up = false) := by simp [hup]
  unfold fJ
  rw [if_neg hnd, if_pos hs, if_pos hc]

theorem fJ_chain {p : Par} {s : JSt} {m₁ : CMove} {m₂ m₃ : PMove} (hup : s.up = true)
    (hs : m₁.seed = false)
    (hc : allRestored m₁ m₂ m₃ = true ∧ jointTime p s m₁ m₂ m₃ + authCost p s m₁ ≤ p.D) :
    fJ p s m₁ m₂ m₃ = ⟨true, segNext m₁.seg s.n₁, segNext m₂.seg s.n₂, segNext m₃.seg s.n₃,
      s.auth || passes p s m₁ m₂ m₃⟩ := by
  have hnd : ¬ (s.up = false) := by simp [hup]
  have hs' : ¬ (m₁.seed = true) := by simp [hs]
  unfold fJ
  rw [if_neg hnd, if_neg hs', if_pos hc]

/-- A step from a functioning state that keeps the service up is a seed escape or a chain escape. -/
theorem fJ_up {p : Par} {s : JSt} {m₁ : CMove} {m₂ m₃ : PMove} (hup : s.up = true)
    (h' : (fJ p s m₁ m₂ m₃).up = true) :
    (m₁.seed = true ∧ fJ p s m₁ m₂ m₃ = ⟨true, s.n₁, s.n₂, s.n₃, s.auth || passes p s m₁ m₂ m₃⟩) ∨
    (m₁.seed = false ∧ allRestored m₁ m₂ m₃ = true ∧
      jointTime p s m₁ m₂ m₃ + authCost p s m₁ ≤ p.D ∧
      fJ p s m₁ m₂ m₃ = ⟨true, segNext m₁.seg s.n₁, segNext m₂.seg s.n₂, segNext m₃.seg s.n₃,
        s.auth || passes p s m₁ m₂ m₃⟩) := by
  have hnd : ¬ (s.up = false) := by simp [hup]
  by_cases hs : m₁.seed = true
  · by_cases hc : 1 + authCost p s m₁ ≤ p.D
    · exact Or.inl ⟨hs, fJ_seed hup hs hc⟩
    · exfalso
      unfold fJ at h'
      rw [if_neg hnd, if_pos hs, if_neg hc] at h'
      simp [down] at h'
  · by_cases hc : allRestored m₁ m₂ m₃ = true ∧ jointTime p s m₁ m₂ m₃ + authCost p s m₁ ≤ p.D
    · have hs2 : m₁.seed = false := by simpa using hs
      exact Or.inr ⟨hs2, hc.1, hc.2, fJ_chain hup hs2 hc⟩
    · exfalso
      unfold fJ at h'
      rw [if_neg hnd, if_neg hs, if_neg hc] at h'
      simp [down] at h'

/-! ## The joint escape is a serial chain -/

def segCount : Seg → Nat → Nat
  | .patch, n => n
  | .prune, _ => 1
  | .idle, _ => 0

def segDur (p : Par) : Seg → Nat → Nat → Nat
  | .patch, _ => fun _ => p.delta
  | .prune, n => fun _ => 1 + p.lam * n
  | .idle, _ => fun _ => 1

/-- A patched segment of depth `n` is `n` stages of `delta`; a pruned one is a single rebuild stage. -/
theorem seg_psum (p : Par) (s : Seg) (n : Nat) :
    psum (segDur p s n) (segCount s n) = segTime p s n := by
  cases s
  · show psum (fun _ => p.delta) n = p.delta * n
    rw [psum_const, Nat.mul_comm]
  · show psum (fun _ => 1 + p.lam * n) 1 = 1 + p.lam * n
    simp [psum]
  · rfl

def sharedStages (p : Par) (s : JSt) (m₁ : CMove) (m₂ m₃ : PMove) : Nat → Nat :=
  cat (fun _ => p.l0) 1
    (cat (segDur p m₁.seg s.n₁) (segCount m₁.seg s.n₁)
      (cat (segDur p m₂.seg s.n₂) (segCount m₂.seg s.n₂) (segDur p m₃.seg s.n₃)))

def stageCount (s : JSt) (m₁ : CMove) (m₂ m₃ : PMove) : Nat :=
  1 + (segCount m₁.seg s.n₁ + (segCount m₂.seg s.n₂ + segCount m₃.seg s.n₃))

theorem shared_makespan (p : Par) (s : JSt) (m₁ : CMove) (m₂ m₃ : PMove) :
    psum (sharedStages p s m₁ m₂ m₃) (stageCount s m₁ m₂ m₃) = jointTime p s m₁ m₂ m₃ := by
  unfold sharedStages stageCount jointTime
  rw [psum_cat, psum_cat, psum_cat, seg_psum, seg_psum, seg_psum]
  have h1 : psum (fun _ => p.l0) 1 = p.l0 := by simp [psum]
  rw [h1]
  omega

theorem stages_pos (p : Par) (hl : 1 ≤ p.l0) (hd : 1 ≤ p.delta) (s : JSt) (m₁ : CMove) (m₂ m₃ : PMove) :
    ∀ i, 1 ≤ sharedStages p s m₁ m₂ m₃ i := by
  intro i
  have hs : ∀ g n j, 1 ≤ segDur p g n j := by
    intro g n j
    cases g
    · exact hd
    · show 1 ≤ 1 + p.lam * n; omega
    · exact Nat.le_refl 1
  unfold sharedStages cat
  split
  · exact hl
  · split
    · exact hs _ _ _
    · split
      · exact hs _ _ _
      · exact hs _ _ _

/-- **Joint bootstrap time.** With serial prerequisites across the three segments, the shared chain
can be completed in `jointTime` ticks and not in fewer (`chain_min_time`). -/
theorem shared_bootstrap (p : Par) (hl : 1 ≤ p.l0) (hd : 1 ≤ p.delta) (s : JSt) (m₁ : CMove)
    (m₂ m₃ : PMove) :
    ChainReach (sharedStages p s m₁ m₂ m₃) (jointTime p s m₁ m₂ m₃) (stageCount s m₁ m₂ m₃, 0) ∧
    ∀ n q, ChainReach (sharedStages p s m₁ m₂ m₃) n (stageCount s m₁ m₂ m₃, q) →
      jointTime p s m₁ m₂ m₃ ≤ n := by
  have h := chain_min_time (sharedStages p s m₁ m₂ m₃) (stages_pos p hl hd s m₁ m₂ m₃)
    (stageCount s m₁ m₂ m₃)
  rw [shared_makespan] at h
  exact h

/-! ## The joint system: control classes and disturbances -/

/-- A partner's role: its control class (`fixed` = `𝒰_fixed`, a neutral partner running its
incumbent routine; `adapt` = `𝒰_adapt`, a cooperative partner) or an adversary, whose action is a
disturbance (I.3.8). -/
inductive Stance | fixed | adapt | adv
  deriving DecidableEq, Repr, Inhabited

def Stance.rank : Stance → Nat
  | .adv => 0
  | .fixed => 1
  | .adapt => 2

/-- The partner's realized action: its routine `r` (fixed class), the controller's choice `u`
(adapt class), or the disturbance `w` (adversary). -/
def pick : Stance → PMove → PMove → PMove → PMove
  | .fixed, r, _, _ => r
  | .adapt, _, u, _ => u
  | .adv, _, _, w => w

/-- The disturbance set `W`: an adversary chooses any segment action and vote, except withholding
its segment unless `overt`. Non-adversarial components are unconstrained (they are ignored). -/
def inW (p : Par) : Stance → PMove → Prop
  | .adv, w => p.overt = true ∨ w.seg ≠ .idle
  | _, _ => True

def dummyP : PMove := ⟨.patch, true⟩

/-- **The joint system** for a class/stance assignment, as an `RSys` (I.3.8): controls are the
actions of agent 1 and of adapt-class partners (fixed-class partners run their routines `r₂`, `r₃`);
disturbances are the adversaries' actions. `V` depends only on `x` (A0). -/
def jrsys (p : Par) (r₂ r₃ : JSt → PMove) (s₂ s₃ : Stance) : RSys JSt (CMove × PMove × PMove) where
  avail s u := adm₁ p s u.1
  trans s u s' := ∃ w : PMove × PMove, inW p s₂ w.1 ∧ inW p s₃ w.2 ∧
    s' = fJ p s u.1 (pick s₂ (r₂ s) u.2.1 w.1) (pick s₃ (r₃ s) u.2.2 w.2)
  V s := s.up = true

/-- **The deterministic joint system** (no adversary) as a `Sys`: a step is any admissible joint
action of the agents' classes. -/
def jsys (p : Par) (r₂ r₃ : JSt → PMove) (s₂ s₃ : Stance) : Sys JSt :=
  ⟨fun _ s s' => ∃ u : CMove × PMove × PMove, adm₁ p s u.1 ∧
    s' = fJ p s u.1 (pick s₂ (r₂ s) u.2.1 dummyP) (pick s₃ (r₃ s) u.2.2 dummyP),
   fun s => s.up = true⟩

/-- The physical class `𝒰_phys`: routines are freed and the seed is admissible without
authorization; adversaries, being part of the environment, remain (I.3.3, "what 𝒰_phys relaxes"). -/
def physP (p : Par) : Par := { p with phys := true }

def physStance : Stance → Stance
  | .fixed => .adapt
  | s => s

def origin : JSt := ⟨true, 0, 0, 0, false⟩

/-- Neutral routines and the patching veto strategy. -/
def patchRoutine : JSt → PMove := fun _ => ⟨.patch, true⟩
def prune2Routine (get : JSt → Nat) : JSt → PMove :=
  fun s => ⟨if 2 ≤ get s then .prune else .patch, true⟩
def vetoRoutine : JSt → PMove := fun _ => ⟨.patch, false⟩

theorem inW_dummy (p : Par) (s : Stance) : inW p s dummyP := by
  cases s <;> simp [inW, dummyP]

theorem pick_indep {s : Stance} {r u : PMove} (h : s ≠ .adv) (w w' : PMove) :
    pick s r u w = pick s r u w' := by
  cases s
  · rfl
  · rfl
  · exact absurd rfl h

theorem trans_nonempty (p : Par) (r₂ r₃ : JSt → PMove) (s₂ s₃ : Stance) :
    ∀ s u, (jrsys p r₂ r₃ s₂ s₃).V s → (jrsys p r₂ r₃ s₂ s₃).avail s u →
      ∃ s', (jrsys p r₂ r₃ s₂ s₃).trans s u s' :=
  fun _ _ _ _ => ⟨_, (dummyP, dummyP), inW_dummy p s₂, inW_dummy p s₃, rfl⟩

/-- **Without adversaries, the robust kernel is the kernel `K` of the deterministic joint `Sys`.** -/
theorem kernel_eq (p : Par) (r₂ r₃ : JSt → PMove) {s₂ s₃ : Stance} (h₂ : s₂ ≠ .adv) (h₃ : s₃ ≠ .adv) :
    ∀ n t s, RViab (jrsys p r₂ r₃ s₂ s₃) n s ↔ Viab (jsys p r₂ r₃ s₂ s₃) n t s :=
  rviab_det (jrsys p r₂ r₃ s₂ s₃)
    (fun s u => fJ p s u.1 (pick s₂ (r₂ s) u.2.1 dummyP) (pick s₃ (r₃ s) u.2.2 dummyP))
    (fun s u s' => by
      constructor
      · intro hs
        obtain ⟨w, -, -, he⟩ := hs
        rw [he, pick_indep h₂ w.1 dummyP, pick_indep h₃ w.2 dummyP]
      · intro he
        exact ⟨(dummyP, dummyP), inW_dummy p s₂, inW_dummy p s₃, he⟩)

/-! ## A1 and A3 -/

/-- **A1.** Agent 1's null action and null move are always admissible. -/
theorem a1_null (p : Par) (s : JSt) : adm₁ p s ⟨false, .idle, false⟩ :=
  ⟨fun h => absurd h (by simp), fun h => absurd h (by simp)⟩

theorem fJ_physP (p : Par) : fJ (physP p) = fJ p := rfl

/-- **A3 and Proposition 1, adapt ⊆ phys.** Every organizational joint step is a step of the
physical class, so the organizational robust kernel lies in the physical one. -/
theorem a3_phys (p : Par) (r₂ r₃ : JSt → PMove) (s₂ s₃ : Stance) :
    ∀ n s, RViab (jrsys p r₂ r₃ s₂ s₃) n s →
      RViab (jrsys (physP p) r₂ r₃ (physStance s₂) (physStance s₃)) n s := by
  refine rnesting _ _ (fun _ h => h) ?_
  intro s u _ hu
  refine ⟨(u.1, pick s₂ (r₂ s) u.2.1 dummyP, pick s₃ (r₃ s) u.2.2 dummyP),
    ⟨fun h => ⟨(hu.1 h).1, Or.inr rfl⟩, hu.2⟩, ?_⟩
  intro s' hs'
  obtain ⟨w, hw₂, hw₃, he⟩ := hs'
  refine ⟨w, ?_, ?_, ?_⟩
  · cases s₂ <;> first | trivial | exact hw₂
  · cases s₃ <;> first | trivial | exact hw₃
  · rw [he, fJ_physP]
    cases s₂ <;> cases s₃ <;> rfl

/-! ## Theorem VI.3: class and stance nesting -/

/-- **Proposition 1 on the joint system (`nesting`).** Partner 2 moved from `𝒰_fixed` to `𝒰_adapt`
can only enlarge the joint kernel `K`. -/
theorem class_nesting_K (p : Par) (r₂ r₃ : JSt → PMove) (s₃ : Stance) :
    ∀ T t s, K (jsys p r₂ r₃ .fixed s₃) T t s → K (jsys p r₂ r₃ .adapt s₃) T t s :=
  nesting _ _ (fun _ h => h) (fun _ s _ hs => by
    obtain ⟨u, hu, he⟩ := hs
    exact ⟨(u.1, r₂ s, u.2.2), hu, by rw [he]; rfl⟩)

theorem class_nesting_K₃ (p : Par) (r₂ r₃ : JSt → PMove) (s₂ : Stance) :
    ∀ T t s, K (jsys p r₂ r₃ s₂ .fixed) T t s → K (jsys p r₂ r₃ s₂ .adapt) T t s :=
  nesting _ _ (fun _ h => h) (fun _ s _ hs => by
    obtain ⟨u, hu, he⟩ := hs
    exact ⟨(u.1, u.2.1, r₃ s), hu, by rw [he]; rfl⟩)

theorem fixed_to_adapt_2 (p : Par) (r₂ r₃ : JSt → PMove) (s₃ : Stance) :
    ∀ n s, RViab (jrsys p r₂ r₃ .fixed s₃) n s → RViab (jrsys p r₂ r₃ .adapt s₃) n s :=
  rnesting _ _ (fun _ h => h) (fun s u _ hu => ⟨(u.1, r₂ s, u.2.2), hu, fun _ hs' => by
    obtain ⟨w, -, hw₃, he⟩ := hs'
    exact ⟨w, trivial, hw₃, he⟩⟩)

theorem fixed_to_adapt_3 (p : Par) (r₂ r₃ : JSt → PMove) (s₂ : Stance) :
    ∀ n s, RViab (jrsys p r₂ r₃ s₂ .fixed) n s → RViab (jrsys p r₂ r₃ s₂ .adapt) n s :=
  rnesting _ _ (fun _ h => h) (fun s u _ hu => ⟨(u.1, u.2.1, r₃ s), hu, fun _ hs' => by
    obtain ⟨w, hw₂, -, he⟩ := hs'
    exact ⟨w, hw₂, trivial, he⟩⟩)

/-- Adversary → fixed: if the routine lies in the adversary's disturbance set, playing it is one of
the adversary's options, so the robust kernel can only grow. -/
theorem adv_to_fixed_2 (p : Par) (r₂ r₃ : JSt → PMove) (s₃ : Stance) (hr : ∀ s, inW p .adv (r₂ s)) :
    ∀ n s, RViab (jrsys p r₂ r₃ .adv s₃) n s → RViab (jrsys p r₂ r₃ .fixed s₃) n s :=
  rnesting _ _ (fun _ h => h) (fun s u _ hu => ⟨u, hu, fun _ hs' => by
    obtain ⟨w, -, hw₃, he⟩ := hs'
    exact ⟨(r₂ s, w.2), hr s, hw₃, he⟩⟩)

theorem adv_to_fixed_3 (p : Par) (r₂ r₃ : JSt → PMove) (s₂ : Stance) (hr : ∀ s, inW p .adv (r₃ s)) :
    ∀ n s, RViab (jrsys p r₂ r₃ s₂ .adv) n s → RViab (jrsys p r₂ r₃ s₂ .fixed) n s :=
  rnesting _ _ (fun _ h => h) (fun s u _ hu => ⟨u, hu, fun _ hs' => by
    obtain ⟨w, hw₂, -, he⟩ := hs'
    exact ⟨(w.1, r₃ s), hw₂, hr s, he⟩⟩)

/-- An adversary's routine argument is irrelevant. -/
theorem adv_irrel_3 (p : Par) (r₂ r₃ r₃' : JSt → PMove) (s₂ : Stance) :
    ∀ n s, RViab (jrsys p r₂ r₃ s₂ .adv) n s → RViab (jrsys p r₂ r₃' s₂ .adv) n s :=
  rnesting _ _ (fun _ h => h) (fun _ u _ hu => ⟨u, hu, fun _ hs' => by
    obtain ⟨w, hw₂, hw₃, he⟩ := hs'
    exact ⟨w, hw₂, hw₃, he⟩⟩)

theorem mono_2 (p : Par) (r₂ r₃ : JSt → PMove) (s₃ : Stance) (hr : ∀ s, inW p .adv (r₂ s))
    {s₂ s₂' : Stance} (h : s₂.rank ≤ s₂'.rank) :
    ∀ n s, RViab (jrsys p r₂ r₃ s₂ s₃) n s → RViab (jrsys p r₂ r₃ s₂' s₃) n s := by
  intro n s hx
  cases s₂ <;> cases s₂'
  all_goals first
    | exact hx
    | exact fixed_to_adapt_2 p r₂ r₃ s₃ n s hx
    | exact adv_to_fixed_2 p r₂ r₃ s₃ hr n s hx
    | exact fixed_to_adapt_2 p r₂ r₃ s₃ n s (adv_to_fixed_2 p r₂ r₃ s₃ hr n s hx)
    | (exfalso; simp [Stance.rank] at h)

theorem mono_3 (p : Par) (r₂ r₃ : JSt → PMove) (s₂ : Stance) (hr : ∀ s, inW p .adv (r₃ s))
    {s₃ s₃' : Stance} (h : s₃.rank ≤ s₃'.rank) :
    ∀ n s, RViab (jrsys p r₂ r₃ s₂ s₃) n s → RViab (jrsys p r₂ r₃ s₂ s₃') n s := by
  intro n s hx
  cases s₃ <;> cases s₃'
  all_goals first
    | exact hx
    | exact fixed_to_adapt_3 p r₂ r₃ s₂ n s hx
    | exact adv_to_fixed_3 p r₂ r₃ s₂ hr n s hx
    | exact fixed_to_adapt_3 p r₂ r₃ s₂ n s (adv_to_fixed_3 p r₂ r₃ s₂ hr n s hx)
    | (exfalso; simp [Stance.rank] at h)

/-- **Theorem VI.3 (class and stance nesting).** For each partner, adversary ⊆ fixed (neutral) ⊆
adapt (cooperative), at every horizon, provided the routines lie in the adversary's disturbance set. -/
theorem stance_nesting (p : Par) (r₂ r₃ : JSt → PMove) (hr₂ : ∀ s, inW p .adv (r₂ s))
    (hr₃ : ∀ s, inW p .adv (r₃ s)) {s₂ s₃ s₂' s₃' : Stance} (h₂ : s₂.rank ≤ s₂'.rank)
    (h₃ : s₃.rank ≤ s₃'.rank) :
    ∀ n s, RViab (jrsys p r₂ r₃ s₂ s₃) n s → RViab (jrsys p r₂ r₃ s₂' s₃') n s :=
  fun n s hx => mono_3 p r₂ r₃ s₂' hr₃ h₃ n s (mono_2 p r₂ r₃ s₃ hr₂ h₂ n s hx)

/-! ## Theorem VI.4: the shared ratchet -/

/-- **Theorem VI.4(a).** With no seed, if partner 2 is in `𝒰_fixed` with a routine that always
patches, the joint system survives at most `⌊(D - ℓ₀)/δ⌋ + 1` cycles from the origin, whatever
agent 1 and partner 3 do. -/
theorem shared_ratchet_one (p : Par) (hg : p.gov = .noSeed) (hδ : 1 ≤ p.delta) (h0 : p.l0 ≤ p.D)
    (r₃ : JSt → PMove) (s₃ : Stance) :
    ¬ RViab (jrsys p patchRoutine r₃ .fixed s₃) ((p.D - p.l0) / p.delta + 1 + 1) origin := by
  intro hw
  have key := rviab_budget (jrsys p patchRoutine r₃ .fixed s₃) (trans_nonempty p _ _ _ _)
    (fun _ => True) (fun s => p.delta * s.n₂) p.l0 p.delta p.D (by
      intro s u s' hV _ hu hs' hV'
      obtain ⟨w, -, -, rfl⟩ := hs'
      rcases fJ_up hV hV' with ⟨hs, -⟩ | ⟨-, -, ht, he⟩
      · exact absurd (hu.1 hs).1 (by simp [hg, Gov.hasSeed])
      · rw [he]
        simp only [pick, patchRoutine, jointTime, segTime, segNext] at ht ⊢
        have := Nat.left_distrib p.delta s.n₂ 1
        exact ⟨by omega, by omega, trivial⟩)
    ((p.D - p.l0) / p.delta + 1) origin trivial hw
  have h2 := lt_succ_div_mul (p.D - p.l0) p.delta hδ
  simp only [origin, Nat.mul_zero, Nat.add_zero] at key
  omega

/-- The same bound with partner 3 as the patching partner. -/
theorem shared_ratchet_three (p : Par) (hg : p.gov = .noSeed) (hδ : 1 ≤ p.delta) (h0 : p.l0 ≤ p.D)
    (r₂ : JSt → PMove) (s₂ : Stance) :
    ¬ RViab (jrsys p r₂ patchRoutine s₂ .fixed) ((p.D - p.l0) / p.delta + 1 + 1) origin := by
  intro hw
  have key := rviab_budget (jrsys p r₂ patchRoutine s₂ .fixed) (trans_nonempty p _ _ _ _)
    (fun _ => True) (fun s => p.delta * s.n₃) p.l0 p.delta p.D (by
      intro s u s' hV _ hu hs' hV'
      obtain ⟨w, -, -, rfl⟩ := hs'
      rcases fJ_up hV hV' with ⟨hs, -⟩ | ⟨-, -, ht, he⟩
      · exact absurd (hu.1 hs).1 (by simp [hg, Gov.hasSeed])
      · rw [he]
        simp only [pick, patchRoutine, jointTime, segTime, segNext] at ht ⊢
        have := Nat.left_distrib p.delta s.n₃ 1
        exact ⟨by omega, by omega, trivial⟩)
    ((p.D - p.l0) / p.delta + 1) origin trivial hw
  have h2 := lt_succ_div_mul (p.D - p.l0) p.delta hδ
  simp only [origin, Nat.mul_zero, Nat.add_zero] at key
  omega

/-- **Theorem VI.4(b).** Two fixed-class partners whose routines always patch: at most
`⌊(D - ℓ₀)/(2δ)⌋ + 1` cycles, whenever authorization cannot pass (no seed, or unanimity with a
partner voting no) and the seed is not admissible unauthorized. The routines' votes are `v₂`, `v₃`. -/
theorem two_patchers (p : Par) (hδ : 1 ≤ p.delta) (h0 : p.l0 ≤ p.D) (hu : p.gov.unilat = false)
    (hph : p.phys = false) (v₂ v₃ : Bool) (hv : p.gov = .noSeed ∨ (v₂ && v₃) = false) :
    ¬ RViab (jrsys p (fun _ => ⟨.patch, v₂⟩) (fun _ => ⟨.patch, v₃⟩) .fixed .fixed)
      ((p.D - p.l0) / (2 * p.delta) + 1 + 1) origin := by
  intro hw
  have key := rviab_budget (jrsys p (fun _ => ⟨.patch, v₂⟩) (fun _ => ⟨.patch, v₃⟩) .fixed .fixed)
    (trans_nonempty p _ _ _ _) (fun s => s.auth = false)
    (fun s => p.delta * s.n₂ + p.delta * s.n₃) p.l0 (2 * p.delta) p.D (by
      intro s u s' hV hI hu' hs' hV'
      obtain ⟨w, -, -, rfl⟩ := hs'
      rcases fJ_up hV hV' with ⟨hs, -⟩ | ⟨-, -, ht, he⟩
      · have := (hu'.1 hs).2
        simp [hI, hph] at this
      · rw [he]
        simp only [pick, jointTime, segTime, segNext] at ht ⊢
        have e2 := Nat.left_distrib p.delta s.n₂ 1
        have e3 := Nat.left_distrib p.delta s.n₃ 1
        refine ⟨by omega, by omega, ?_⟩
        rcases hv with hv | hv
        · simp [passes, proposes, hI, hv, Gov.hasSeed]
        · simp [passes, hI, hu, hv])
    ((p.D - p.l0) / (2 * p.delta) + 1) origin rfl hw
  have h2 := lt_succ_div_mul (p.D - p.l0) (2 * p.delta) (by omega)
  simp only [origin, Nat.mul_zero, Nat.add_zero] at key
  omega

/-- With no seed, two neutral partners that always patch. -/
theorem shared_ratchet_two (p : Par) (hg : p.gov = .noSeed) (hδ : 1 ≤ p.delta) (h0 : p.l0 ≤ p.D)
    (hph : p.phys = false) :
    ¬ RViab (jrsys p patchRoutine patchRoutine .fixed .fixed)
      ((p.D - p.l0) / (2 * p.delta) + 1 + 1) origin :=
  two_patchers p hδ h0 (by simp [hg, Gov.unilat]) hph true true (Or.inl hg)

/-- **Theorem VI.4(c).** With no seed, an adversarial partner 3 alone bounds survival by the
one-patcher bound, whatever partner 2's class or routine: patching is in its disturbance set
(Theorem VI.3). -/
theorem adversary_ratchet (p : Par) (hg : p.gov = .noSeed) (hδ : 1 ≤ p.delta) (h0 : p.l0 ≤ p.D)
    (r₂ r₃ : JSt → PMove) (s₂ : Stance) :
    ¬ RViab (jrsys p r₂ r₃ s₂ .adv) ((p.D - p.l0) / p.delta + 1 + 1) origin := fun hw =>
  shared_ratchet_three p hg hδ h0 r₂ s₂
    (adv_to_fixed_3 p r₂ patchRoutine s₂ (fun _ => Or.inr (by simp [patchRoutine])) _ _
      (adv_irrel_3 p r₂ r₃ patchRoutine s₂ _ _ hw))

/-- **Physical sustainability without a seed.** If all three agents may prune every cycle
(`ℓ₀ + 3 ≤ D`), keeping every depth at 0 is an invariant set: viable at every horizon. -/
theorem prune_sustainable (p : Par) (hD : p.l0 + 3 ≤ p.D) (r₂ r₃ : JSt → PMove) :
    ∀ n, RViab (jrsys p r₂ r₃ .adapt .adapt) n origin := by
  intro n
  refine rinvariant (jrsys p r₂ r₃ .adapt .adapt)
    (fun s => s.up = true ∧ s.n₁ = 0 ∧ s.n₂ = 0 ∧ s.n₃ = 0) (fun _ h => h.1) ?_ n origin
    ⟨rfl, rfl, rfl, rfl⟩
  intro s ⟨hup, h1, h2, h3⟩
  refine ⟨(⟨false, .prune, false⟩, ⟨.prune, true⟩, ⟨.prune, true⟩),
    ⟨fun h => absurd h (by simp), fun h => absurd h (by simp)⟩, fun s' hs' => ?_⟩
  obtain ⟨w, -, -, rfl⟩ := hs'
  have hc : authCost p s ⟨false, .prune, false⟩ = 0 := by simp [authCost, proposes]
  have hcond : allRestored ⟨false, .prune, false⟩ ⟨.prune, true⟩ ⟨.prune, true⟩ = true ∧
      jointTime p s ⟨false, .prune, false⟩ ⟨.prune, true⟩ ⟨.prune, true⟩ +
        authCost p s ⟨false, .prune, false⟩ ≤ p.D := by
    refine ⟨rfl, ?_⟩
    rw [hc]
    simp only [jointTime, segTime, h1, h2, h3, Nat.mul_zero]
    omega
  show (fun s : JSt => s.up = true ∧ s.n₁ = 0 ∧ s.n₂ = 0 ∧ s.n₃ = 0)
    (fJ p s ⟨false, .prune, false⟩ ⟨.prune, true⟩ ⟨.prune, true⟩)
  rw [fJ_chain hup rfl hcond]
  exact ⟨rfl, rfl, rfl, rfl⟩

/-- **Severity 3 of the neutral ratchet.** With no seed and a fixed-class partner 2 that always
patches, the joint system is outside the organizational kernel after `⌊(D - ℓ₀)/δ⌋ + 1` cycles,
while the physical class (routines freed) survives at every horizon when `ℓ₀ + 3 ≤ D`: the partner's
routine is an organizational constraint, so the exclusion is structural organizational lock-in. -/
theorem neutral_lockin (p : Par) (hg : p.gov = .noSeed) (hδ : 1 ≤ p.delta) (hD : p.l0 + 3 ≤ p.D)
    (r₃ : JSt → PMove) {s₃ : Stance} (h₃ : s₃ ≠ .adv) :
    ¬ RViab (jrsys p patchRoutine r₃ .fixed s₃) ((p.D - p.l0) / p.delta + 1 + 1) origin ∧
    ∀ n, RViab (jrsys (physP p) patchRoutine r₃ (physStance .fixed) (physStance s₃)) n origin := by
  refine ⟨shared_ratchet_one p hg hδ (by omega) r₃ s₃, fun n => ?_⟩
  have e : physStance s₃ = .adapt := by cases s₃ <;> first | rfl | exact absurd rfl h₃
  rw [e]
  exact prune_sustainable (physP p) hD _ _ n

/-! ## Theorem VI.5: seed governance -/

/-- **An admissible seed sustains the system** (invariance): from any functioning state where the
seed escape is admissible, the joint system survives at every horizon, whatever the classes and
disturbances. -/
theorem seed_sustainable (p : Par) (hD : 1 ≤ p.D) (r₂ r₃ : JSt → PMove) (s₂ s₃ : Stance) :
    ∀ n s, s.up = true ∧ p.gov.hasSeed = true ∧ (s.auth = true ∨ p.phys = true) →
      RViab (jrsys p r₂ r₃ s₂ s₃) n s := by
  refine rinvariant _ _ (fun _ h => h.1) ?_
  intro s ⟨hup, hs, ha⟩
  refine ⟨(⟨true, .patch, false⟩, dummyP, dummyP),
    ⟨fun _ => ⟨hs, ha⟩, fun h => absurd h (by simp)⟩, fun s' hs' => ?_⟩
  obtain ⟨w, -, -, rfl⟩ := hs'
  have hc : 1 + authCost p s ⟨true, .patch, false⟩ ≤ p.D := by
    simp [authCost, proposes]; omega
  rw [fJ_seed hup rfl hc]
  refine ⟨rfl, hs, ?_⟩
  rcases ha with h | h
  · simp [h]
  · exact Or.inr h

/-- A partner consents to every proposal: an adapt-class partner can choose to; a fixed-class
partner's routine votes yes; an adversary does not. -/
def Consents (s : Stance) (r : JSt → PMove) : Prop :=
  match s with
  | .fixed => ∀ x, (r x).vote = true
  | .adapt => True
  | .adv => False

theorem consents_vote {s : Stance} {r : JSt → PMove} (h : Consents s r) (x : JSt) (w : PMove) :
    (pick s (r x) ⟨.patch, true⟩ w).vote = true := by
  cases s
  · exact h x
  · rfl
  · exact h.elim

theorem seg_zero_le (p : Par) (s : Seg) : segTime p s 0 ≤ 1 := by
  cases s <;> simp [segTime]

/-- Fixed routines and covert adversaries restore their segments. -/
theorem restored_pick (p : Par) {s : Stance} {r : JSt → PMove} (hr : ∀ x, restored (r x).seg = true)
    (hcov : p.overt = false ∨ s ≠ .adv) (x : JSt) {w : PMove} (hw : inW p s w) :
    restored (pick s (r x) ⟨.patch, true⟩ w).seg = true := by
  cases s
  · exact hr x
  · rfl
  · rcases hcov with hc | hc
    · have : w.seg ≠ .idle := by
        rcases hw with h | h
        · simp [hc] at h
        · exact h
      show restored w.seg = true
      cases hseg : w.seg <;> simp_all [restored]
    · exact absurd rfl hc

/-- **Theorem VI.5(a), early authorization (Proposition 3′).** If authorization passes (unilateral
governance, or unanimity with consenting partners), routines and adversaries restore their segments,
and the first crisis leaves room for the proposal (`ℓ₀ + 2 + α ≤ D`), then proposing in the first
cycle is a step all of whose successors are in the robust kernel at every horizon, so the origin is
too (`robust_strengthened`). -/
theorem early_authorization (p : Par) (hD : p.l0 + 2 + p.alpha ≤ p.D) (r₂ r₃ : JSt → PMove)
    (s₂ s₃ : Stance) (hr₂ : ∀ x, restored (r₂ x).seg = true) (hr₃ : ∀ x, restored (r₃ x).seg = true)
    (hcov₂ : p.overt = false ∨ s₂ ≠ .adv) (hcov₃ : p.overt = false ∨ s₃ ≠ .adv)
    (hcons : p.gov = .unilateral ∨ (p.gov = .unanimous ∧ Consents s₂ r₂ ∧ Consents s₃ r₃)) :
    ∀ n, RViab (jrsys p r₂ r₃ s₂ s₃) n origin := by
  intro n
  cases n with
  | zero => rfl
  | succ k =>
    have hs : p.gov.hasSeed = true := by
      rcases hcons with h | ⟨h, -⟩ <;> simp [h, Gov.hasSeed]
    refine robust_strengthened (jrsys p r₂ r₃ s₂ s₃) (n := k) (s := origin)
      (u := (⟨false, .patch, true⟩, ⟨.patch, true⟩, ⟨.patch, true⟩)) rfl
      ⟨fun h => absurd h (by simp), fun _ => ⟨hs, rfl⟩⟩ ?_
    intro s' hs'
    obtain ⟨w, hw₂, hw₃, rfl⟩ := hs'
    show RViab _ k (fJ p origin ⟨false, .patch, true⟩ (pick s₂ (r₂ origin) ⟨.patch, true⟩ w.1)
      (pick s₃ (r₃ origin) ⟨.patch, true⟩ w.2))
    have hres₂ := restored_pick p hr₂ hcov₂ origin hw₂
    have hres₃ := restored_pick p hr₃ hcov₃ origin hw₃
    have hpass : passes p origin ⟨false, .patch, true⟩ (pick s₂ (r₂ origin) ⟨.patch, true⟩ w.1)
        (pick s₃ (r₃ origin) ⟨.patch, true⟩ w.2) = true := by
      rcases hcons with h | ⟨h, h₂, h₃⟩
      · simp [passes, proposes, origin, h, Gov.unilat, Gov.hasSeed]
      · simp [passes, proposes, origin, hs, consents_vote h₂, consents_vote h₃]
    generalize pick s₂ (r₂ origin) ⟨.patch, true⟩ w.1 = m₂ at hres₂ hpass ⊢
    generalize pick s₃ (r₃ origin) ⟨.patch, true⟩ w.2 = m₃ at hres₃ hpass ⊢
    have hc : authCost p origin ⟨false, .patch, true⟩ = p.alpha := by
      simp [authCost, proposes, origin, hs]
    have h2 := seg_zero_le p m₂.seg
    have h3 := seg_zero_le p m₃.seg
    have hcond : allRestored ⟨false, .patch, true⟩ m₂ m₃ = true ∧
        jointTime p origin ⟨false, .patch, true⟩ m₂ m₃ + authCost p origin ⟨false, .patch, true⟩
          ≤ p.D := by
      refine ⟨by simp only [allRestored, hres₂, hres₃, Bool.and_true]; rfl, ?_⟩
      have hp : segTime p .patch 0 = 0 := by simp [segTime]
      rw [hc]
      simp only [jointTime, origin, hp]
      omega
    rw [fJ_chain rfl rfl hcond, hpass]
    exact seed_sustainable p (by omega) r₂ r₃ s₂ s₃ k _ ⟨rfl, hs, Or.inl rfl⟩

/-- **Theorem VI.5(b), veto ratchet.** Under unanimity with no unauthorized access, an adversarial
partner 3 facing a fixed-class partner 2 that always patches bounds survival by
`⌊(D - ℓ₀)/(2δ)⌋ + 1`: patching and voting no are in its disturbance set. -/
theorem veto_ratchet (p : Par) (hg : p.gov = .unanimous) (hph : p.phys = false) (hδ : 1 ≤ p.delta)
    (h0 : p.l0 ≤ p.D) (r₃ : JSt → PMove) :
    ¬ RViab (jrsys p patchRoutine r₃ .fixed .adv) ((p.D - p.l0) / (2 * p.delta) + 1 + 1) origin :=
  fun hw => two_patchers p hδ h0 (by simp [hg, Gov.unilat]) hph true false (Or.inr rfl)
    (adv_to_fixed_3 p patchRoutine vetoRoutine .fixed (fun _ => Or.inr (by simp [vetoRoutine])) _ _
      (adv_irrel_3 p patchRoutine r₃ vetoRoutine .fixed _ _ hw))

/-- **Theorem VI.5(c), severity 3 by veto.** In the same setting the physical class, in which the
seed is admissible without authorization, survives at every horizon. -/
theorem veto_severity (p : Par) (hg : p.gov = .unanimous) (hph : p.phys = false) (hδ : 1 ≤ p.delta)
    (h0 : p.l0 ≤ p.D) (hD : 1 ≤ p.D) (r₃ : JSt → PMove) :
    ¬ RViab (jrsys p patchRoutine r₃ .fixed .adv) ((p.D - p.l0) / (2 * p.delta) + 1 + 1) origin ∧
    ∀ n, RViab (jrsys (physP p) patchRoutine r₃ (physStance .fixed) (physStance .adv)) n origin :=
  ⟨veto_ratchet p hg hph hδ h0 r₃,
   fun n => seed_sustainable (physP p) hD _ _ _ _ n origin
     ⟨rfl, by simp [physP, hg, Gov.hasSeed], Or.inr rfl⟩⟩

/-- **Theorem VI.5(d), the overt adversary.** If an adversary may withhold its segment (its
disturbance set includes the null action of A1), no functioning state without an admissible seed
survives even one cycle. -/
theorem overt_lockin (p : Par) (hov : p.overt = true) (r₂ r₃ : JSt → PMove) (s₂ : Stance)
    (s : JSt) (hup : s.up = true) (hauth : s.auth = false) (hph : p.phys = false) :
    ¬ RViab (jrsys p r₂ r₃ s₂ .adv) 1 s := by
  intro h
  obtain ⟨_, u, hu, hall⟩ := h
  have hV := hall _ ⟨(dummyP, ⟨.idle, false⟩), inW_dummy p s₂, Or.inl hov, rfl⟩
  rcases fJ_up hup hV with ⟨hs, -⟩ | ⟨-, hr, -, -⟩
  · have := (hu.1 hs).2
    simp [hauth, hph] at this
  · simp [allRestored, restored, pick] at hr

/-- With a seed present, the physical class survives an overt adversary at every horizon. -/
theorem overt_physical (p : Par) (hs : p.gov.hasSeed = true) (hD : 1 ≤ p.D) (r₂ r₃ : JSt → PMove)
    (s₂ : Stance) : ∀ n, RViab (jrsys (physP p) r₂ r₃ (physStance s₂) .adv) n origin :=
  fun n => seed_sustainable (physP p) hD _ _ _ _ n origin ⟨rfl, hs, Or.inr rfl⟩

/-! ## The reference instance: `D = 7`, `ℓ₀ = 2`, `δ = 2`, prune `1 + 2n`, `α = 2` -/

def refP (gov : Gov) (phys overt : Bool) : Par := ⟨7, 2, 2, 2, 2, gov, phys, overt⟩

/-- No seed, partner 2 fixed and patching: at most 3 cycles. -/
theorem ref_one_patcher (r₃ : JSt → PMove) (s₃ : Stance) :
    ¬ RViab (jrsys (refP .noSeed false false) patchRoutine r₃ .fixed s₃) 4 origin :=
  shared_ratchet_one (refP .noSeed false false) rfl (by decide) (by decide) r₃ s₃

/-- The same, stated in the kernel `K` of the deterministic joint system (CCN). -/
theorem ref_one_patcher_K (r₃ : JSt → PMove) :
    ¬ K (jsys (refP .noSeed false false) patchRoutine r₃ .fixed .adapt) 4 0 origin := fun h =>
  ref_one_patcher r₃ .adapt ((kernel_eq _ _ _ (by decide) (by decide) 4 0 origin).mpr h)

/-- No seed, both partners fixed and patching (CNN): outside `K` at horizon 3, while the physical
class survives at every horizon: severity 3. -/
theorem ref_neutral_lockin :
    ¬ K (jsys (refP .noSeed false false) patchRoutine patchRoutine .fixed .fixed) 3 0 origin ∧
    ∀ n, RViab (jrsys (physP (refP .noSeed false false)) patchRoutine patchRoutine .adapt .adapt)
      n origin :=
  ⟨fun h => shared_ratchet_two (refP .noSeed false false) rfl (by decide) (by decide) rfl
      ((kernel_eq _ _ _ (by decide) (by decide) 3 0 origin).mpr h),
   prune_sustainable _ (by decide) _ _⟩

/-- Unanimity, CNA: at most 2 cycles; the physical class survives at every horizon. -/
theorem ref_veto (r₃ : JSt → PMove) :
    ¬ RViab (jrsys (refP .unanimous false false) patchRoutine r₃ .fixed .adv) 3 origin ∧
    ∀ n, RViab (jrsys (physP (refP .unanimous false false)) patchRoutine r₃ .adapt .adv) n origin :=
  veto_severity (refP .unanimous false false) rfl rfl (by decide) (by decide) (by decide) r₃

/-- Unilateral governance, covert adversaries: every class/stance assignment survives at every
horizon. -/
theorem ref_unilateral (s₂ s₃ : Stance) :
    ∀ n, RViab (jrsys (refP .unilateral false false) patchRoutine patchRoutine s₂ s₃) n origin :=
  early_authorization _ (by decide) _ _ s₂ s₃ (fun _ => rfl) (fun _ => rfl) (Or.inl rfl) (Or.inl rfl)
    (Or.inl rfl)

/-- Unanimity, two fixed patching partners (CNN): every horizon, in the kernel `K`. -/
theorem ref_consent :
    ∀ n, K (jsys (refP .unanimous false false) patchRoutine patchRoutine .fixed .fixed) n 0 origin :=
  fun n => (kernel_eq _ _ _ (by decide) (by decide) (n - 0) 0 origin).mp
    (early_authorization _ (by decide) patchRoutine patchRoutine .fixed .fixed (fun _ => rfl)
      (fun _ => rfl) (Or.inl rfl) (Or.inl rfl) (Or.inr ⟨rfl, fun _ => rfl, fun _ => rfl⟩) _)

/-- An overt adversary: no cycle survives under any governance, while the physical class survives. -/
theorem ref_overt (gov : Gov) (hs : gov.hasSeed = true) :
    ¬ RViab (jrsys (refP gov false true) patchRoutine patchRoutine .fixed .adv) 1 origin ∧
    ∀ n, RViab (jrsys (physP (refP gov false true)) patchRoutine patchRoutine .adapt .adv) n origin :=
  ⟨overt_lockin _ rfl _ _ _ origin rfl rfl rfl, overt_physical _ hs (by show 1 ≤ 7; omega) _ _ .fixed⟩

end Paradox.SharedRatchet
