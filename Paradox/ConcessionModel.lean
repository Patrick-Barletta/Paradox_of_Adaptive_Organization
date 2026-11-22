import Paradox.Concession
import Std.Data.HashMap

/-!
# Argument V in the four control classes of I.3

Both sweeps are control systems `Sys` on explicit states `(x, O, π, q)` (I.3.1), with the four
classes of I.3.3 given by lists of admissible actions; each class's kernel is `K` of its `Sys`
(Definition 2). Proved, with no `sorry` and no `native_decide`:

* `classA_nesting`, `classB_nesting` (**Proposition 1**): `𝒦_fixed ⊆ 𝒦_policy ⊆ 𝒦_adapt ⊆ 𝒦_phys`,
  from inclusion of the admissible-action lists (A3 holds exactly).
* `classA_horizon_antitone` (**Theorem V.1** for the class kernels).
* `ref_shift` (**Theorem V.2** in the four classes): for `r₀ = 1`, `P = 4`, the post-concession
  state is in `𝒦_policy` but not `𝒦_fixed` (severity 1) at horizon 9, and in `𝒦_phys` but not
  `𝒦_adapt` (severity 3) at horizon 10.
* `shield_fatal` (**Theorem V.3** in the four classes): the shield's floor is `calmStep`, so after
  a shock the first shock that follows at least `k (mMax - mReq + 1)` calm ticks is outside
  `𝒦_fixed`; `ref_calm` gives severity 1 at the start for `k = 2`, `L = 6`.

**Sweep A (structural concessions).** `x` = reserves `r` (A0: viable while `r ≥ 0` after upkeep);
`O` = `scar`; `π` = `aligned`; `q` = `oblig` (the acute obligation) and `impl` (an implementation
move in flight). Step 0 is the decision step: the obligation must be cleared by a
capability-changing move, the clean fix (cost 5) or the concession (cost 1, scar); left uncleared,
reserves are seized. Operating ticks: upkeep 2, output 4 (3 when scarred) on an aligned tick
without a forced switch; a forced switch (operating ticks `P, 2P, ...`) misaligns the policy and
cancels a realignment in flight; realigning is immediate, except that a scarred organization needs
a latency-1 implementation move. Classes: `fixed` never revises and makes no move; `policy`
realigns; `adapt` also makes the capability-changing moves (clean fix or concession, and a later
clean fix, effective next tick); `phys` also clears the obligation at no cost, produces 4 and
realigns without the implementation move.

**Sweep B (calm-period erosion).** `x` = reserves; `π` = the reserve floor; `q` = the calm counter.
Rounds of `L` calm ticks and a shock (needs and removes `mReq`). A calm tick earns 1 and the
organization keeps some reserves, spending the rest. `fixed` = the adaptive empirical shield (its
floor update is `calmStep`, it keeps `min(r, floor)`); `policy` keeps any amount; `adapt` and
`phys` have no further actions in this model.
-/

namespace Paradox.ConcessionModel

open Paradox.Theory Paradox.Concession

inductive Cls | fixed | policy | adapt | phys
  deriving DecidableEq, Repr, Inhabited

def Cls.rank : Cls → Nat
  | .fixed => 0
  | .policy => 1
  | .adapt => 2
  | .phys => 3

/-- Backward recursion for a time-dependent system given by successor lists. -/
def kerBt {S : Type} (up : S → Bool) (sc : Nat → S → List S) : Nat → Nat → S → Bool
  | 0, _, s => up s
  | n + 1, t, s => up s && (sc t s).any (kerBt up sc n (t + 1))

theorem kerBt_iff {S : Type} (up : S → Bool) (sc : Nat → S → List S) :
    ∀ n t s, Viab ⟨fun t s s' => s' ∈ sc t s, fun s => up s = true⟩ n t s ↔ kerBt up sc n t s = true := by
  intro n
  induction n with
  | zero => intro t s; exact Iff.rfl
  | succ n ih =>
    intro t s
    simp only [Viab, kerBt, Bool.and_eq_true, List.any_eq_true]
    constructor
    · intro ⟨hV, s', hs', hv⟩
      exact ⟨hV, s', hs', (ih (t + 1) s').mp hv⟩
    · intro ⟨hV, s', hs', hv⟩
      exact ⟨hV, s', hs', (ih (t + 1) s').mpr hv⟩

/-- A system whose successors are a sub-list of another's has a smaller kernel. -/
theorem sub_viab {S : Type} (up : S → Bool) (sc sc' : Nat → S → List S)
    (h : ∀ t s s', s' ∈ sc t s → s' ∈ sc' t s) :
    ∀ n t s, Viab ⟨fun t s s' => s' ∈ sc t s, fun s => up s = true⟩ n t s →
      Viab ⟨fun t s s' => s' ∈ sc' t s, fun s => up s = true⟩ n t s := by
  intro n t s hv
  exact viab_sim _ _ (fun a b => a = b) (fun a b hab ha => hab ▸ ha)
    (fun t a a' b hab hs => ⟨a', hab ▸ h t a a' hs, rfl⟩) n t s s rfl hv

/-! ## Sweep A -/

def U : Nat := 2
def RMAX : Nat := 8
def C_FIX : Nat := 5
def C_CONC : Nat := 1
def OUT_FIX : Nat := 4
def OUT_CONC : Nat := 3

/-- The forced-switch schedule: every `P` operating ticks, plus an optional unscheduled switch. -/
structure APar where
  P : Nat
  extra : Option Nat
  deriving DecidableEq, Repr

/-- The state `(x, O, π, q)`: `up r` are `x`, `scar` is `O`, `aligned` is `π`, `impl oblig` are
`q`. -/
structure ASt where
  up : Bool
  r : Nat
  scar : Bool
  aligned : Bool
  impl : Bool
  oblig : Bool
  deriving DecidableEq, Repr, Inhabited

inductive Dec | none | clean | conc | free
  deriving DecidableEq, Repr, Inhabited

/-- An action: the decision-step move, a policy revision (`realign`), a later clean fix, and the
physical class's unrestricted output and realignment (`free`). -/
structure AAct where
  dec : Dec
  realign : Bool
  later : Bool
  free : Bool
  deriving DecidableEq, Repr, Inhabited

/-- Forced switch at step `t` (operating tick `t - 1`)? -/
def switchAt (q : APar) (t : Nat) : Bool :=
  decide (1 ≤ t) && ((decide (q.P ≤ t - 1) && (t - 1) % q.P == 0) || q.extra == some (t - 1))

def downA (s : ASt) : ASt := { s with up := false }

/-- **The Sweep A transition** (I.3.1). -/
def stepA (q : APar) (t : Nat) (s : ASt) (a : AAct) : ASt :=
  if !s.up then s
  else if s.oblig then
    match a.dec with
    | .none => downA s
    | .clean => ⟨true, min RMAX (s.r - C_FIX), false, true, false, false⟩
    | .conc => ⟨true, min RMAX (s.r - C_CONC), true, true, false, false⟩
    | .free => ⟨true, min RMAX s.r, false, true, false, false⟩
  else
    let al1 := s.aligned || s.impl
    let im1 := false
    let al2 := al1 || (a.realign && !al1 && !(s.scar && !a.free))
    let im2 := im1 || (a.realign && !al1 && s.scar && !a.free)
    let sw := switchAt q t
    let out := if al2 && !sw then (if !s.scar || a.free then OUT_FIX else OUT_CONC) else 0
    let cost := if a.later then C_FIX else 0
    if s.r + out < U + cost then downA s
    else ⟨true, min RMAX (s.r + out - U - cost), s.scar && !a.later, al2 && !sw, im2 && !sw, false⟩

/-- **Admissible actions of each class** (I.3.3). -/
def admA (k : Cls) (s : ASt) (a : AAct) : Bool :=
  if s.oblig then
    !a.realign && !a.later && !a.free &&
    match a.dec with
    | .none => true
    | .clean => decide (2 ≤ k.rank) && decide (C_FIX ≤ s.r)
    | .conc => decide (2 ≤ k.rank) && decide (C_CONC ≤ s.r)
    | .free => k == .phys
  else
    a.dec == .none && (!a.realign || decide (1 ≤ k.rank)) &&
    (!a.later || (decide (2 ≤ k.rank) && s.scar && decide (C_FIX ≤ s.r))) &&
    (!a.free || k == .phys)

def allA : List AAct := Id.run do
  let mut out : List AAct := []
  for d in [Dec.none, .clean, .conc, .free] do
    for re in [false, true] do
      for la in [false, true] do
        for fr in [false, true] do
          out := out ++ [⟨d, re, la, fr⟩]
  return out

def actsA (k : Cls) (s : ASt) : List AAct := allA.filter (admA k s)

def succA (q : APar) (k : Cls) (t : Nat) (s : ASt) : List ASt := (actsA k s).map (stepA q t s)

/-- **The Sweep A control system of class `k`.** -/
def aSys (q : APar) (k : Cls) : Sys ASt := ⟨fun t s s' => s' ∈ succA q k t s, fun s => s.up = true⟩

theorem admA_mono {k k' : Cls} (h : k.rank ≤ k'.rank) (s : ASt) (a : AAct)
    (ha : admA k s a = true) : admA k' s a = true := by
  rcases a with ⟨d, re, la, fr⟩
  unfold admA at ha ⊢
  cases k <;> cases k' <;> simp only [Cls.rank] at h <;> (try omega) <;>
    cases d <;> cases re <;> cases la <;> cases fr <;> split at ha <;> simp_all [Cls.rank]

/-- **Proposition 1 for Sweep A.** -/
theorem classA_nesting (q : APar) {k k' : Cls} (h : k.rank ≤ k'.rank) :
    ∀ T t s, K (aSys q k) T t s → K (aSys q k') T t s :=
  nesting _ _ (fun _ h => h) (fun t s s' hs => by
    simp only [aSys, succA, actsA, List.mem_map, List.mem_filter] at hs ⊢
    obtain ⟨a, ⟨ha, hadm⟩, he⟩ := hs
    exact ⟨a, ⟨ha, admA_mono h s a hadm⟩, he⟩)

/-- **Theorem V.1 for the class kernels.** -/
theorem classA_horizon_antitone (q : APar) (k : Cls) {T₁ T₂ t : Nat} (h₁ : t ≤ T₁) (h₂ : T₁ ≤ T₂)
    (s : ASt) : K (aSys q k) T₂ t s → K (aSys q k) T₁ t s :=
  horizon_antitone (aSys q k) h₁ h₂ s

theorem aSys_iff (q : APar) (k : Cls) (n t : Nat) (s : ASt) :
    Viab (aSys q k) n t s ↔ kerBt ASt.up (succA q k) n t s = true :=
  kerBt_iff ASt.up (succA q k) n t s

/-- Following one rule (when admissible) is a sub-system of class `k`. -/
def ruleSuccA (q : APar) (k : Cls) (rule : ASt → AAct) (t : Nat) (s : ASt) : List ASt :=
  if admA k s (rule s) then [stepA q t s (rule s)] else []

theorem rule_viabA (q : APar) (k : Cls) (rule : ASt → AAct) (n t : Nat) (s : ASt)
    (h : kerBt ASt.up (ruleSuccA q k rule) n t s = true) : Viab (aSys q k) n t s := by
  refine sub_viab ASt.up (ruleSuccA q k rule) (succA q k) ?_ n t s ((kerBt_iff _ _ n t s).mpr h)
  intro t s s' hs
  simp only [ruleSuccA] at hs
  split at hs
  · simp only [List.mem_singleton] at hs
    subst hs
    simp only [succA, actsA, List.mem_map, List.mem_filter]
    refine ⟨rule s, ⟨?_, by assumption⟩, rfl⟩
    rcases hr : rule s with ⟨d, re, la, fr⟩
    cases d <;> cases re <;> cases la <;> cases fr <;> decide
  · simp at hs

def postConc (r₀ : Nat) : ASt := ⟨true, min RMAX (r₀ - C_CONC), true, true, false, false⟩
def postClean (r₀ : Nat) : ASt := ⟨true, min RMAX (r₀ - C_FIX), false, true, false, false⟩
def preA (r₀ : Nat) : ASt := ⟨true, r₀, false, true, false, true⟩

/-- The physical class's rule: realign at once whenever misaligned, producing without the cap. -/
def physRule : ASt → AAct := fun _ => ⟨.none, true, false, true⟩

/-- **Theorem V.2 in the four classes** (`r₀ = 1`, `P = 4`; the post-concession state at step 1,
viable through `T` operating ticks means `Viab … T 1`). At `T = 9` the concession needs the policy
class (severity 1); at `T = 10` no organizational class saves it while the physical class does
(severity 3). -/
theorem ref_shift :
    ¬ Viab (aSys ⟨4, none⟩ .fixed) 9 1 (postConc 1) ∧ Viab (aSys ⟨4, none⟩ .policy) 9 1 (postConc 1) ∧
    ¬ Viab (aSys ⟨4, none⟩ .adapt) 10 1 (postConc 1) ∧ Viab (aSys ⟨4, none⟩ .phys) 10 1 (postConc 1) := by
  refine ⟨?_, ?_, ?_, rule_viabA _ _ physRule 10 1 _ (by decide +kernel)⟩
  · rw [aSys_iff]; decide +kernel
  · rw [aSys_iff]; decide +kernel
  · rw [aSys_iff]; decide +kernel

/-! ## Sweep B -/

def M_MAX : Nat := 6
def M_REQ : Nat := 4
def INCOME : Nat := 1
def N_SHOCKS : Nat := 4

/-- The state `(x, π, q)`: reserves, the shield's floor, the calm counter. -/
structure BSt where
  up : Bool
  r : Nat
  floor : Nat
  calm : Nat
  deriving DecidableEq, Repr, Inhabited

def shockAt (L t : Nat) : Bool := t % (L + 1) == L

/-- **The Sweep B transition**: a shock tick, or a calm tick that keeps `keep` reserves. The
shield's floor and counter evolve by `calmStep` (Theorem V.3). -/
def stepB (k L t : Nat) (s : BSt) (keep : Nat) : BSt :=
  if !s.up then s
  else if shockAt L t then
    if s.r < M_REQ then { s with up := false } else ⟨true, s.r - M_REQ, M_MAX, 0⟩
  else
    let fc := calmStep k (s.floor, s.calm)
    if keep ≤ s.r + INCOME then ⟨true, keep, fc.1, fc.2⟩ else { s with up := false }

/-- Admissible amounts kept: the shield keeps `min(r + 1, floor')`; every other class keeps any
amount. -/
def actsB (c : Cls) (k L t : Nat) (s : BSt) : List Nat :=
  if shockAt L t then [0]
  else match c with
    | .fixed => [min (s.r + INCOME) (calmStep k (s.floor, s.calm)).1]
    | _ => List.range (s.r + INCOME + 1)

def succB (c : Cls) (k L t : Nat) (s : BSt) : List BSt := (actsB c k L t s).map (stepB k L t s)

/-- **The Sweep B control system of class `c`.** -/
def bSys (c : Cls) (k L : Nat) : Sys BSt := ⟨fun t s s' => s' ∈ succB c k L t s, fun s => s.up = true⟩

theorem actsB_mono {c c' : Cls} (h : c.rank ≤ c'.rank) (k L t : Nat) (s : BSt) (x : Nat)
    (hx : x ∈ actsB c k L t s) : x ∈ actsB c' k L t s := by
  unfold actsB at hx ⊢
  split
  · rename_i hs; simp only [hs, if_true] at hx; exact hx
  · rename_i hs
    simp only [hs, Bool.false_eq_true, if_false] at hx
    cases c <;> cases c' <;> simp only [Cls.rank] at h <;> (try omega) <;> simp_all [List.mem_range] <;>
      omega

/-- **Proposition 1 for Sweep B.** -/
theorem classB_nesting {c c' : Cls} (h : c.rank ≤ c'.rank) (k L : Nat) :
    ∀ T t s, K (bSys c k L) T t s → K (bSys c' k L) T t s :=
  nesting _ _ (fun _ h => h) (fun t s s' hs => by
    simp only [bSys, succB, List.mem_map] at hs ⊢
    obtain ⟨x, hx, he⟩ := hs
    exact ⟨x, actsB_mono h k L t s x hx, he⟩)

theorem bSys_iff (c : Cls) (k L n t : Nat) (s : BSt) :
    Viab (bSys c k L) n t s ↔ kerBt BSt.up (succB c k L) n t s = true :=
  kerBt_iff BSt.up (succB c k L) n t s

/-- The shield's state after `j` calm ticks of a round: the floor and counter are `afterCalm`
(Theorem V.3's controller), and the reserves are at most the floor. -/
theorem shield_round (k L : Nat) (hL : 1 ≤ L) (hfat : (afterCalm M_MAX k L).1 < M_REQ)
    (rnd : Nat) :
    ∀ m j (s : BSt), j + m = L → s.up = true → (s.floor, s.calm) = afterCalm M_MAX k j →
      (1 ≤ j → s.r ≤ s.floor) → ¬ Viab (bSys .fixed k L) (m + 1) (j + rnd * (L + 1)) s := by
  intro m
  induction m with
  | zero =>
    intro j s hj hup hfc hr hv
    have hjL : j = L := by omega
    subst hjL
    obtain ⟨-, s', hs', hv'⟩ := hv
    have hshock : shockAt j (j + rnd * (j + 1)) = true := by
      simp [shockAt, Nat.add_mul_mod_self_right, Nat.mod_eq_of_lt (Nat.lt_succ_self j)]
    have hfl : s.floor = (afterCalm M_MAX k j).1 := by rw [← hfc]
    have hlt : s.r < M_REQ := by have := hr hL; omega
    simp only [bSys, succB, actsB, hshock, if_true, List.map_cons, List.map_nil,
      List.mem_singleton] at hs'
    subst hs'
    simp only [stepB, hup, Bool.not_true, Bool.false_eq_true, if_false, hshock, if_true, hlt] at hv'
    simp [Viab, bSys] at hv'
  | succ m ih =>
    intro j s hj hup hfc hr hv
    obtain ⟨-, s', hs', hv'⟩ := hv
    have hcalm : shockAt L (j + rnd * (L + 1)) = false := by
      have hjL : j < L := by omega
      simp only [shockAt, Nat.add_mul_mod_self_right, Nat.mod_eq_of_lt (by omega : j < L + 1)]
      simp; omega
    simp only [bSys, succB, actsB, hcalm, Bool.false_eq_true, if_false, List.map_cons, List.map_nil,
      List.mem_singleton] at hs'
    subst hs'
    have hfc' : calmStep k (s.floor, s.calm) = afterCalm M_MAX k (j + 1) := by
      rw [hfc]; rfl
    have hstep : stepB k L (j + rnd * (L + 1)) s (min (s.r + INCOME) (calmStep k (s.floor, s.calm)).1) =
        ⟨true, min (s.r + INCOME) (calmStep k (s.floor, s.calm)).1, (calmStep k (s.floor, s.calm)).1,
          (calmStep k (s.floor, s.calm)).2⟩ := by
      simp only [stepB, hup, Bool.not_true, Bool.false_eq_true, if_false, hcalm]
      rw [if_pos (Nat.min_le_left _ _)]
    rw [hstep] at hv'
    refine ih (j + 1) ⟨true, min (s.r + INCOME) (calmStep k (s.floor, s.calm)).1,
      (calmStep k (s.floor, s.calm)).1, (calmStep k (s.floor, s.calm)).2⟩ (by omega) rfl ?_
      (fun _ => Nat.min_le_right _ _) ?_
    · rw [← hfc']
    · have e : j + 1 + rnd * (L + 1) = j + rnd * (L + 1) + 1 := by omega
      rw [e]; exact hv'

/-- **Theorem V.3 in the four classes.** After a shock (floor reset to `mMax`, counter 0, at the
start of round `rnd`), if the next shock follows at least `k (mMax - mReq + 1)` calm ticks, the
shield's state is outside `𝒦_fixed` for the round, whatever its reserves. -/
theorem shield_fatal (k L rnd : Nat) (hk : 1 ≤ k) (hL : k * (M_MAX - M_REQ + 1) ≤ L) (r : Nat) :
    ¬ Viab (bSys .fixed k L) (L + 1) (rnd * (L + 1)) ⟨true, r, M_MAX, 0⟩ := by
  have hfat := (calm_erosion_fatal M_MAX k M_REQ hk (by decide) (by decide)).2 L hL
  have hL1 : 1 ≤ L := by
    have : 1 ≤ k * (M_MAX - M_REQ + 1) := Nat.mul_pos hk (by decide)
    omega
  have h := shield_round k L hL1 hfat rnd L 0 ⟨true, r, M_MAX, 0⟩ (by omega) rfl rfl (by omega)
  simpa using h

/-- Keep everything: a rule of the policy class. -/
def keepAll (k L t : Nat) (s : BSt) : List BSt :=
  if shockAt L t then [stepB k L t s 0] else [stepB k L t s (s.r + INCOME)]

/-- **Severity 1 at the start** for `k = 2`, `L = 6`: the shield fails, keeping everything
survives all four shocks. -/
theorem ref_calm :
    ¬ Viab (bSys .fixed 2 6) 28 0 ⟨true, M_MAX, M_MAX, 0⟩ ∧ Viab (bSys .policy 2 6) 28 0 ⟨true, M_MAX, M_MAX, 0⟩ := by
  refine ⟨?_, ?_⟩
  · rw [bSys_iff]; decide +kernel
  · refine sub_viab BSt.up (keepAll 2 6) (succB .policy 2 6) ?_ 28 0 _
      ((kerBt_iff _ _ 28 0 _).mpr (by decide +kernel))
    intro t s s' hs
    simp only [keepAll] at hs
    simp only [succB, actsB, List.mem_map]
    split at hs
    · simp only [List.mem_singleton] at hs
      exact ⟨0, by simp [*], hs.symm⟩
    · simp only [List.mem_singleton] at hs
      refine ⟨s.r + INCOME, ?_, hs.symm⟩
      simp [*, List.mem_range]

/-! ## The exact sweeps (computational) -/

abbrev Memo := Std.HashMap Nat Bool

def encA (t : Nat) (s : ASt) : Nat :=
  (((((t * 16 + s.r) * 2 + (if s.scar then 1 else 0)) * 2 + (if s.aligned then 1 else 0)) * 2 +
    (if s.impl then 1 else 0)) * 2 + (if s.oblig then 1 else 0))

/-- Membership of `s` at step `t` in class `k`'s kernel through operating tick `T`. -/
partial def winA (q : APar) (k : Cls) (T t : Nat) (s : ASt) : StateM Memo Bool := do
  if !s.up then return false
  if t == T + 1 then return true
  let key := encA t s
  match (← get).get? key with
  | some v => return v
  | none =>
    let mut res := false
    for s' in succA q k t s do
      if ← winA q k T (t + 1) s' then
        res := true
        break
    modify (·.insert key res)
    return res

def kernelA (q : APar) (k : Cls) (T t : Nat) (s : ASt) : Bool := (winA q k T t s).run' {}

def classes : List Cls := [.fixed, .policy, .adapt, .phys]

def sev (ks : List Bool) : Nat := ((List.range 4).find? fun i => ks[i]!).getD 4

def concOk (r₀ P T : Nat) (extra : Option Nat := none) : Bool :=
  decide (C_CONC ≤ r₀) && kernelA ⟨P, extra⟩ .policy T 1 (postConc r₀)
def cleanOk (r₀ P T : Nat) (extra : Option Nat := none) : Bool :=
  decide (C_FIX ≤ r₀) && kernelA ⟨P, extra⟩ .policy T 1 (postClean r₀)

def r0s : List Nat := (List.range 10).map (· + 1)
def ps : List Nat := [3, 4, 5, 6, 7, 8]
def ts : List Nat := (List.range 21).map (· + 4)

def crossover (r₀ P : Nat) : String :=
  let ok := ts.filter fun T => concOk r₀ P T
  match ok.getLast? with
  | none => "none"
  | some x => if x == 24 then "all" else toString x

def scarWindow (r₀ P : Nat) : Option (List Nat) :=
  if concOk r₀ P 24 && cleanOk r₀ P 24 then
    some ((List.range 24).filter fun e => !concOk r₀ P 24 (some e) && cleanOk r₀ P 24 (some e))
  else none

def encB (t : Nat) (s : BSt) : Nat := ((t * 256 + s.r) * 8 + s.floor) * 16 + s.calm

partial def winB (c : Cls) (k L t : Nat) (s : BSt) : StateM Memo Bool := do
  if !s.up then return false
  if t == N_SHOCKS * (L + 1) then return true
  let key := encB t s
  match (← get).get? key with
  | some v => return v
  | none =>
    let mut res := false
    for s' in succB c k L t s do
      if ← winB c k L (t + 1) s' then
        res := true
        break
    modify (·.insert key res)
    return res

def kernelB (c : Cls) (k L t : Nat) (s : BSt) : Bool := (winB c k L t s).run' {}

/-- The shield's path at ticks 0, 1, ...; the first state that is down is included. -/
def pathB (k L : Nat) : List BSt := Id.run do
  let mut s : BSt := ⟨true, M_MAX, M_MAX, 0⟩
  let mut out : List BSt := []
  for t in [0:N_SHOCKS * (L + 1) + 1] do
    out := out ++ [s]
    if !s.up || t == N_SHOCKS * (L + 1) then break
    s := stepB k L t s (actsB .fixed k L t s).head!
  return out

/-- Controller 0 myopic, 1 static, 2 adaptive. Returns (survives all shocks, cumulative output). -/
def runB (ctrl k L : Nat) : Bool × Nat := Id.run do
  let mut r := M_MAX
  let mut floor := if ctrl == 0 then 0 else M_MAX
  let mut calm := 0
  let mut out := 0
  if ctrl == 0 then
    out := out + r
    r := 0
  for _ in [0:N_SHOCKS] do
    for _ in [0:L] do
      r := r + INCOME
      if ctrl == 2 then
        calm := calm + 1
        if calm == k then
          floor := floor - 1
          calm := 0
      let keep := min r floor
      out := out + (r - keep)
      r := keep
    if r < M_REQ then return (false, out)
    r := r - M_REQ
    if ctrl == 2 then
      floor := M_MAX
      calm := 0
  return (true, out)

def ks : List Nat := (List.range 8).map (· + 1)
def ls : List Nat := (List.range 25).map (· + 1)

end Paradox.ConcessionModel
