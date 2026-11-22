import Paradox.Ratchet
import Std.Data.HashMap

/-!
# Argument VI: the escape ratchet in the four control classes of I.3

One `Sys` step is one tick. The state is `s = (x, O, q)` of I.3.1:

* `x` (physical): `up` (the organization functions), reserves `r`, and `left`, the ticks before the
  current crisis's deadline. **A0:** `V s := s.up = true` depends only on `x`.
* `O` (organization): `n`, the depth of the legacy recovery chain, and `auth`, whether the
  independent seed is an admissible recovery action. Together they fix the capability structure
  `𝒞(O)`: which recovery transitions are in `𝒜(x, O, q)`.
* `q` (commitments): `done` (this crisis's escape is complete), `work` (the transition in flight
  and its progress: for a patch, the units of serial bootstrap work completed, so its stage is the
  stage of the serial chain of `chain_min_time` that contains that unit), and `pend` (an
  authorization in flight, effective at the next crisis).
* `π`: the incumbent crisis-response policy is the patch routine (`routine`); revisions act through
  the operational action chosen each tick, so `π` carries no further state.

A crisis lasts `D` ticks. A patch traverses the whole chain (`ℓ₀ + n δ` ticks of serial work) and adds
a stage; a seed escape takes one tick; a prune (a capability-changing move) takes `ℓ₀ + 1 + λ n` ticks
and 2 reserves and resets the depth; authorizing the seed (a capability-changing move) costs 3
reserves and takes effect at the next crisis. At the deadline an unfinished escape takes the
organization down; a finished one starts the next crisis with one unit of income (reserves capped at
4). The **null action** `wait` (no work this tick) is always admissible (A1).

**Control classes (I.3.3)**, as lists of admissible actions (`admB`):

| class | admissible actions |
|---|---|
| `fixed` | the incumbent routine `π₀`: patch, keep working, wait once done (`m ≡ ∅`) |
| `policy` | any recovery action within `𝒞(O)`: patch, or the seed if already authorized; no capability-changing moves |
| `adapt` | adds the capability-changing moves: prune and authorize |
| `phys` | adds the seed when it is physically present, authorized or not |

Each class's kernel is `K` of the `Sys` `classSys p k`, whose step is "some admissible action leads to
`s'`" (Definition 2). Proved, with no `sorry` and no `native_decide`:

* `class_nesting` (**Proposition 1**): `𝒦_fixed ⊆ 𝒦_policy ⊆ 𝒦_adapt ⊆ 𝒦_phys`, from inclusion of the
  admissible-action lists (A3 holds exactly: every organizational step is a physical step).
* `ker_iff`: the kernel equals a computable backward recursion (`kerB`).
* `blocked_not_viable` (**Theorem VI.2 in the four classes**): if every startable organizational
  transition needs more ticks than are left, the state is outside `𝒦_adapt` (hence outside
  `𝒦_policy` and `𝒦_fixed`); `seed_sustainable`: where the seed is admissible the state is in the
  kernel at every horizon (`invariant_viable`).
* The reference instance (`D = 7`, `ℓ₀ = 2`, `δ = 2`, prune `3 + 2n`, seed present): the patch
  routine succeeds for three crises and fails in the fourth (`ref_patch_only`); the state it reaches
  after three crises is outside `𝒦_adapt` and inside `𝒦_phys`, **severity 3** (`ref_trajectory`,
  `ref_lockin`), and severity 4 without a seed (`ref_no_seed`); pruning at depth 2 is viable at every
  horizon (`ref_prune_sustainable`).
-/

namespace Paradox.RatchetModel

open Paradox.Theory Paradox.Ratchet

def CAP : Nat := 4
def INCOME : Nat := 1
def PRUNE_COST : Nat := 2
def AUTH_COST : Nat := 3
def H : Nat := 12

/-- Deadline `D` per crisis, seed stage `l0`, patch stage `delta`, prune slope `lam`, and whether the
independent seed is physically present. -/
structure RPar where
  D : Nat
  l0 : Nat
  delta : Nat
  lam : Nat
  seed : Bool
  deriving DecidableEq, Repr

/-- The transition in flight and its progress (units of work completed). -/
inductive Work | none | patch (u : Nat) | seed | prune (u : Nat)
  deriving DecidableEq, Repr, Inhabited

/-- The state `(x, O, q)`: `up r left` are `x`, `n auth` are `O`, `done work pend` are `q`. -/
structure RSt where
  up : Bool
  r : Nat
  left : Nat
  n : Nat
  auth : Bool
  done : Bool
  work : Work
  pend : Bool
  deriving DecidableEq, Repr, Inhabited

/-- Operational actions and moves: `wait` is the null action; `cont` works one tick on the
transition in flight; `patch`, `seed`, `prune` start a transition and work its first tick. `authz`
adds the move "authorize the seed". -/
inductive Op | wait | cont | patch | seed | prune
  deriving DecidableEq, Repr, Inhabited

structure Act where
  op : Op
  authz : Bool
  deriving DecidableEq, Repr, Inhabited

inductive Cls | fixed | policy | adapt | phys
  deriving DecidableEq, Repr, Inhabited

/-- Serial bootstrap work for a patch at depth `n`: the seed stage and `n` patch stages
(`ratchet_latency`). -/
def patchTotal (p : RPar) (n : Nat) : Nat := p.l0 + n * p.delta
def pruneTotal (p : RPar) (n : Nat) : Nat := p.l0 + 1 + p.lam * n

/-- One tick of work: the new work, whether the escape completed, and the new depth. -/
def advance (p : RPar) (n : Nat) : Work → Work × Bool × Nat
  | .none => (.none, false, n)
  | .patch u => if patchTotal p n ≤ u + 1 then (.none, true, n + 1) else (.patch (u + 1), false, n)
  | .seed => (.none, true, n)
  | .prune u => if pruneTotal p n ≤ u + 1 then (.none, true, 0) else (.prune (u + 1), false, n)

/-- End of a tick: the clock advances; at the deadline a finished escape starts the next crisis and
an unfinished one takes the organization down. -/
def tickEnd (p : RPar) (s : RSt) (r' : Nat) (pend' : Bool) (w : Work) (comp : Bool) (n' : Nat) : RSt :=
  if s.left ≤ 1 then
    if (s.done || comp) = true then
      ⟨true, min CAP (r' + INCOME), p.D, n', s.auth || pend', false, .none, false⟩
    else { s with up := false }
  else ⟨true, r', s.left - 1, n', s.auth, s.done || comp, w, pend'⟩

/-- **The transition** `(x, O, q) ↦ (f, g, h)` of I.3.1, total in the action. -/
def f (p : RPar) (s : RSt) (a : Act) : RSt :=
  if s.up = false then s
  else
    let r' := s.r - (if a.authz then AUTH_COST else 0)
    let pend' := s.pend || a.authz
    match a.op with
    | .wait => tickEnd p s r' pend' s.work false s.n
    | .cont =>
      let x := advance p s.n s.work
      tickEnd p s r' pend' x.1 x.2.1 x.2.2
    | .patch =>
      let x := advance p s.n (.patch 0)
      tickEnd p s r' pend' x.1 x.2.1 x.2.2
    | .seed => tickEnd p s r' pend' .none true s.n
    | .prune =>
      let x := advance p s.n (.prune 0)
      tickEnd p s (r' - PRUNE_COST) pend' x.1 x.2.1 x.2.2

def inFlight : Work → Bool
  | .none => false
  | _ => true

/-- The incumbent routine `π₀`: patch at the start of a crisis, keep working, wait once done. -/
def routine (s : RSt) : Op :=
  if s.done then .wait else if inFlight s.work then .cont else .patch

def opCost : Op → Nat
  | .prune => PRUNE_COST
  | _ => 0

/-- Physical realizability: work can be continued only while in flight, a transition can be
started only when nothing is in flight and the escape is not done, the reserves must cover the
costs, and authorization needs a present, not yet authorized seed and is decided at the first tick
of a crisis (it takes effect at the next one: a latency of one crisis). -/
def realizable (p : RPar) (s : RSt) (a : Act) : Bool :=
  (match a.op with
   | .wait => true
   | .cont => inFlight s.work && !s.done
   | _ => !inFlight s.work && !s.done) &&
  decide ((if a.authz then AUTH_COST else 0) + opCost a.op ≤ s.r) &&
  (!a.authz || (p.seed && !s.auth && !s.pend && s.left == p.D))

/-- The class restriction on an action `(op, authz)`, given whether the seed is authorized, whether
it is present, and the routine's action. -/
def classOk : Cls → Op → Bool → Bool → Bool → Op → Bool
  | .fixed, op, az, _, _, rt => !az && op == rt
  | .policy, op, az, auth, _, _ => !az && op != .prune && (op != .seed || auth)
  | .adapt, op, _, auth, _, _ => op != .seed || auth
  | .phys, op, _, auth, seed, _ => op != .seed || auth || seed

/-- **Admissible actions of each control class** (I.3.3). -/
def admB (p : RPar) (k : Cls) (s : RSt) (a : Act) : Bool :=
  realizable p s a && classOk k a.op a.authz s.auth p.seed (routine s)

def allActs : List Act :=
  [⟨.wait, false⟩, ⟨.cont, false⟩, ⟨.patch, false⟩, ⟨.seed, false⟩, ⟨.prune, false⟩,
   ⟨.wait, true⟩, ⟨.cont, true⟩, ⟨.patch, true⟩, ⟨.seed, true⟩, ⟨.prune, true⟩]

def acts (p : RPar) (k : Cls) (s : RSt) : List Act := allActs.filter (admB p k s)

def succ (p : RPar) (k : Cls) (s : RSt) : List RSt := (acts p k s).map (f p s)

/-- **The control system of class `k`** (Definition 2): a step is any admissible action. -/
def classSys (p : RPar) (k : Cls) : Sys RSt := ⟨fun _ s s' => s' ∈ succ p k s, fun s => s.up = true⟩

/-! ## Proposition 1: the four kernels nest -/

def Cls.rank : Cls → Nat
  | .fixed => 0
  | .policy => 1
  | .adapt => 2
  | .phys => 3

theorem routine_ne (s : RSt) : routine s ≠ .prune ∧ routine s ≠ .seed := by
  unfold routine
  split
  · simp
  · split <;> simp

/-- The class restrictions are nested (a finite check over all arguments). -/
theorem classOk_mono : ∀ (k k' : Cls) (op : Op) (az auth seed : Bool) (rt : Op),
    k.rank ≤ k'.rank → rt ≠ .prune → rt ≠ .seed →
    classOk k op az auth seed rt = true → classOk k' op az auth seed rt = true := by
  intro k k' op az auth seed rt h h1 h2 hk
  cases k <;> cases k' <;> simp only [Cls.rank] at h <;> (try omega) <;>
    cases op <;> cases az <;> cases rt <;> simp_all [classOk]

theorem admB_mono (p : RPar) {k k' : Cls} (h : k.rank ≤ k'.rank) (s : RSt) (a : Act)
    (ha : admB p k s a = true) : admB p k' s a = true := by
  simp only [admB, Bool.and_eq_true] at ha ⊢
  exact ⟨ha.1, classOk_mono k k' a.op a.authz s.auth p.seed (routine s) h (routine_ne s).1
    (routine_ne s).2 ha.2⟩

theorem step_mono (p : RPar) {k k' : Cls} (h : k.rank ≤ k'.rank) (s s' : RSt)
    (hs : s' ∈ succ p k s) : s' ∈ succ p k' s := by
  simp only [succ, acts, List.mem_map, List.mem_filter] at hs ⊢
  obtain ⟨a, ⟨ha, hadm⟩, he⟩ := hs
  exact ⟨a, ⟨ha, admB_mono p h s a hadm⟩, he⟩

/-- **Proposition 1 (nesting).** Same viability set; every class-`k` step is a class-`k'` step. -/
theorem class_nesting (p : RPar) {k k' : Cls} (h : k.rank ≤ k'.rank) :
    ∀ T t s, K (classSys p k) T t s → K (classSys p k') T t s :=
  nesting _ _ (fun _ h => h) (fun _ s s' hs => step_mono p h s s' hs)

/-- **A1.** The null action is admissible in every class except `fixed`, whose routine is total
(A2). -/
theorem a1_wait (p : RPar) (k : Cls) (hk : k ≠ .fixed) (s : RSt) : ⟨.wait, false⟩ ∈ acts p k s := by
  simp only [acts, List.mem_filter]
  refine ⟨by simp [allActs], ?_⟩
  cases k <;> simp_all [admB, realizable, opCost, classOk]

/-! ## The kernel as a computable backward recursion -/

/-- Backward recursion for a system given by a list of successors. -/
def kerB (sc : RSt → List RSt) : Nat → RSt → Bool
  | 0, s => s.up
  | n + 1, s => s.up && (sc s).any (kerB sc n)

theorem ker_iff (sc : RSt → List RSt) :
    ∀ n t s, Viab ⟨fun _ s s' => s' ∈ sc s, fun s => s.up = true⟩ n t s ↔ kerB sc n s = true := by
  intro n
  induction n with
  | zero => intro t s; exact Iff.rfl
  | succ n ih =>
    intro t s
    simp only [Viab, kerB, Bool.and_eq_true, List.any_eq_true]
    constructor
    · intro ⟨hV, s', hs', hv⟩
      exact ⟨hV, s', hs', (ih (t + 1) s').mp hv⟩
    · intro ⟨hV, s', hs', hv⟩
      exact ⟨hV, s', hs', (ih (t + 1) s').mpr hv⟩

theorem class_ker_iff (p : RPar) (k : Cls) (n t : Nat) (s : RSt) :
    Viab (classSys p k) n t s ↔ kerB (succ p k) n s = true :=
  ker_iff (succ p k) n t s

/-! ## Theorem VI.2 in the four classes: the blocked state -/

/-- No startable organizational transition fits in the ticks left, nothing in flight can finish in
time, and the seed is not admissible. -/
def Blocked (p : RPar) (s : RSt) : Prop :=
  s.up = true ∧ s.done = false ∧ s.auth = false ∧ 1 ≤ s.left ∧
  (s.work = .none → s.left < patchTotal p s.n ∧ s.left < pruneTotal p s.n) ∧
  (∀ u, s.work = .patch u → s.left + u < patchTotal p s.n) ∧
  (∀ u, s.work = .prune u → s.left + u < pruneTotal p s.n) ∧
  s.work ≠ .seed

theorem tickEnd_mid (p : RPar) (s : RSt) (r' : Nat) (pend' : Bool) (w : Work) (comp : Bool) (n' : Nat)
    (h : 2 ≤ s.left) :
    tickEnd p s r' pend' w comp n' = ⟨true, r', s.left - 1, n', s.auth, s.done || comp, w, pend'⟩ := by
  unfold tickEnd
  rw [if_neg (by omega)]

theorem tickEnd_down (p : RPar) (s : RSt) (r' : Nat) (pend' : Bool) (w : Work) (n' : Nat)
    (h : s.left ≤ 1) (hd : s.done = false) : (tickEnd p s r' pend' w false n').up = false := by
  unfold tickEnd
  rw [if_pos h, if_neg (by simp [hd])]

theorem blocked_step (p : RPar) {k : Cls} (hk : k = .adapt ∨ (k = .phys ∧ p.seed = false))
    {s : RSt} (hb : Blocked p s) {a : Act} (ha : a ∈ acts p k s) :
    (s.left = 1 → (f p s a).up = false) ∧
    (2 ≤ s.left → Blocked p (f p s a) ∧ (f p s a).left = s.left - 1) := by
  obtain ⟨hup, hd, hau, hl, hnone, hpat, hpru, hseed⟩ := hb
  simp only [acts, List.mem_filter] at ha
  obtain ⟨-, hadm⟩ := ha
  have hnd : ¬ (s.up = false) := by simp [hup]
  rcases a with ⟨op, az⟩
  cases op with
  | wait =>
    simp only [f, if_neg hnd]
    refine ⟨fun h1 => tickEnd_down p s _ _ _ _ (by omega) hd, fun h2 => ?_⟩
    rw [tickEnd_mid p s _ _ _ _ _ h2]
    refine ⟨⟨rfl, by simp [hd], hau, by dsimp only; omega, fun hw => ?_, fun u hw => ?_, fun u hw => ?_, hseed⟩, rfl⟩
    · have := hnone hw; dsimp only at this ⊢; omega
    · have := hpat u hw; dsimp only at this ⊢; omega
    · have := hpru u hw; dsimp only at this ⊢; omega
  | cont =>
    simp only [f, if_neg hnd]
    cases hw : s.work with
    | none => simp [admB, realizable, hw, inFlight] at hadm
    | seed => exact absurd hw hseed
    | patch u =>
      have hu := hpat u hw
      have hadv : advance p s.n (.patch u) = (.patch (u + 1), false, s.n) := by
        simp only [advance]; rw [if_neg (by omega)]
      simp only [hadv]
      refine ⟨fun h1 => tickEnd_down p s _ _ _ _ (by omega) hd, fun h2 => ?_⟩
      rw [tickEnd_mid p s _ _ _ _ _ h2]
      refine ⟨⟨rfl, by simp [hd], hau, by dsimp only; omega, fun h => by simp at h,
        fun v hv => ?_, fun v hv => by simp at hv, by simp⟩, rfl⟩
      simp only [Work.patch.injEq] at hv
      dsimp only; omega
    | prune u =>
      have hu := hpru u hw
      have hadv : advance p s.n (.prune u) = (.prune (u + 1), false, s.n) := by
        simp only [advance]; rw [if_neg (by omega)]
      simp only [hadv]
      refine ⟨fun h1 => tickEnd_down p s _ _ _ _ (by omega) hd, fun h2 => ?_⟩
      rw [tickEnd_mid p s _ _ _ _ _ h2]
      refine ⟨⟨rfl, by simp [hd], hau, by dsimp only; omega, fun h => by simp at h,
        fun v hv => by simp at hv, fun v hv => ?_, by simp⟩, rfl⟩
      simp only [Work.prune.injEq] at hv
      dsimp only; omega
  | patch =>
    simp only [f, if_neg hnd]
    have hw : s.work = .none := by
      cases hw : s.work <;> simp_all [admB, realizable, inFlight]
    have hu := (hnone hw).1
    have hadv : advance p s.n (.patch 0) = (.patch 1, false, s.n) := by
      simp only [advance]; rw [if_neg (by omega)]
    simp only [hadv]
    refine ⟨fun h1 => tickEnd_down p s _ _ _ _ (by omega) hd, fun h2 => ?_⟩
    rw [tickEnd_mid p s _ _ _ _ _ h2]
    refine ⟨⟨rfl, by simp [hd], hau, by dsimp only; omega, fun h => by simp at h,
      fun v hv => ?_, fun v hv => by simp at hv, by simp⟩, rfl⟩
    simp only [Work.patch.injEq] at hv
    dsimp only; omega
  | seed =>
    exfalso
    rcases hk with rfl | ⟨rfl, hps⟩ <;> simp_all [admB, classOk]
  | prune =>
    simp only [f, if_neg hnd]
    have hw : s.work = .none := by
      cases hw : s.work <;> simp_all [admB, realizable, inFlight]
    have hu := (hnone hw).2
    have hadv : advance p s.n (.prune 0) = (.prune 1, false, s.n) := by
      simp only [advance]; rw [if_neg (by omega)]
    simp only [hadv]
    refine ⟨fun h1 => tickEnd_down p s _ _ _ _ (by omega) hd, fun h2 => ?_⟩
    rw [tickEnd_mid p s _ _ _ _ _ h2]
    refine ⟨⟨rfl, by simp [hd], hau, by dsimp only; omega, fun h => by simp at h,
      fun v hv => by simp at hv, fun v hv => ?_, by simp⟩, rfl⟩
    simp only [Work.prune.injEq] at hv
    dsimp only; omega

/-- **Theorem VI.2 in the four classes.** A blocked state is outside the adaptive kernel for every
horizon that reaches the deadline (and outside the physical kernel when no seed is present). -/
theorem blocked_not_viable (p : RPar) {k : Cls} (hk : k = .adapt ∨ (k = .phys ∧ p.seed = false)) :
    ∀ n t s, Blocked p s → s.left ≤ n → ¬ Viab (classSys p k) n t s := by
  intro n
  induction n with
  | zero => intro t s hb hn; have := hb.2.2.2.1; omega
  | succ n ih =>
    intro t s hb hn hv
    obtain ⟨-, s', hs', hv'⟩ := hv
    simp only [classSys, succ, List.mem_map] at hs'
    obtain ⟨a, ha, rfl⟩ := hs'
    have hstep := blocked_step p hk hb ha
    by_cases h1 : s.left = 1
    · have hdown := hstep.1 h1
      cases n with
      | zero => exact absurd hv' (by simp [Viab, classSys, hdown])
      | succ m => exact absurd hv'.1 (by simp [classSys, hdown])
    · have h2 : 2 ≤ s.left := by have := hb.2.2.2.1; omega
      obtain ⟨hb', hl'⟩ := hstep.2 h2
      exact ih (t + 1) _ hb' (by omega) hv'

/-! ## Sustainability where the seed is admissible -/

/-- With the seed admissible in class `k` at every state reached (authorized, or present in the
physical class), using it at each crisis and waiting otherwise is viable at every horizon. -/
theorem seed_sustainable (p : RPar) (k : Cls) (hk : k ≠ .fixed)
    (hseed : ∀ s : RSt, s.auth = true ∨ (k = .phys ∧ p.seed = true) →
      admB p k s ⟨.seed, false⟩ = (!inFlight s.work && !s.done)) :
    ∀ n t s, s.up = true ∧ (s.auth = true ∨ (k = .phys ∧ p.seed = true)) ∧
      (s.done = true ∨ s.work = .none) → Viab (classSys p k) n t s := by
  refine invariant_viable (classSys p k) _ (fun _ h => h.1) ?_
  intro t s ⟨hup, hauth, hdw⟩
  have hnd : ¬ (s.up = false) := by simp [hup]
  by_cases hd : s.done = true
  · -- escape done: wait for the next crisis
    refine ⟨f p s ⟨.wait, false⟩, ?_, ?_⟩
    · simp only [classSys, succ, List.mem_map]
      exact ⟨_, a1_wait p k hk s, rfl⟩
    · simp only [f, if_neg hnd]
      unfold tickEnd
      split
      · rw [if_pos (by simp [hd])]
        refine ⟨rfl, ?_, Or.inr rfl⟩
        rcases hauth with h | h
        · exact Or.inl (by simp [h])
        · exact Or.inr h
      · exact ⟨rfl, hauth, Or.inl (by simp [hd])⟩
  · -- start the seed escape: it completes this tick
    have hw : s.work = .none := by simpa [hd] using hdw
    have hd' : s.done = false := by simpa using hd
    refine ⟨f p s ⟨.seed, false⟩, ?_, ?_⟩
    · simp only [classSys, succ, List.mem_map, acts, List.mem_filter]
      refine ⟨⟨.seed, false⟩, ⟨by simp [allActs], ?_⟩, rfl⟩
      rw [hseed s hauth]; simp [hw, hd', inFlight]
    · simp only [f, if_neg hnd]
      unfold tickEnd
      split
      · rw [if_pos (by simp)]
        refine ⟨rfl, ?_, Or.inr rfl⟩
        rcases hauth with h | h
        · exact Or.inl (by simp [h])
        · exact Or.inr h
      · exact ⟨rfl, hauth, Or.inl (by simp)⟩

/-- In the physical class with the seed present, the seed is admissible whenever nothing is in
flight. -/
theorem phys_seed_adm (p : RPar) (hs : p.seed = true) (s : RSt) :
    s.auth = true ∨ (Cls.phys = .phys ∧ p.seed = true) →
      admB p .phys s ⟨.seed, false⟩ = (!inFlight s.work && !s.done) := by
  intro _
  simp [admB, realizable, opCost, hs, classOk]

/-- In the adaptive class, the seed is admissible once authorized. -/
theorem adapt_seed_adm (p : RPar) (s : RSt) :
    s.auth = true ∨ (Cls.adapt = .phys ∧ p.seed = true) →
      admB p .adapt s ⟨.seed, false⟩ = (!inFlight s.work && !s.done) := by
  intro h
  have ha : s.auth = true := by simpa using h
  simp [admB, realizable, opCost, ha, classOk]

/-! ## Following a deterministic rule: orbits -/

/-- If a rule's action is admissible in class `k` on every state of a finite list, and the list is
closed under the rule's transition, every state in the list is viable at every horizon. -/
theorem orbit_viable (p : RPar) (k : Cls) (rule : RSt → Act) (L : List RSt)
    (hL : ∀ s ∈ L, s.up = true ∧ rule s ∈ acts p k s ∧ f p s (rule s) ∈ L) :
    ∀ n t s, s ∈ L → Viab (classSys p k) n t s :=
  invariant_viable (classSys p k) (· ∈ L) (fun s hs => (hL s hs).1)
    (fun _ s hs => ⟨f p s (rule s), List.mem_map.mpr ⟨_, (hL s hs).2.1, rfl⟩, (hL s hs).2.2⟩)

/-- The rule "patch, keep working, wait once done; prune instead of patching from depth `q`". -/
def pruneRule (q : Nat) (s : RSt) : Act :=
  if s.done then ⟨.wait, false⟩
  else if inFlight s.work then ⟨.cont, false⟩
  else if q ≤ s.n then ⟨.prune, false⟩ else ⟨.patch, false⟩

/-- The trajectory of a rule (`len` states). -/
def trajectory (p : RPar) (rule : RSt → Act) (s : RSt) : Nat → List RSt
  | 0 => []
  | len + 1 => s :: trajectory p rule (f p s (rule s)) len

def orbitOK (p : RPar) (k : Cls) (rule : RSt → Act) (L : List RSt) : Bool :=
  L.all fun s => s.up && (acts p k s).contains (rule s) && L.contains (f p s (rule s))

theorem orbitOK_sound (p : RPar) (k : Cls) (rule : RSt → Act) (L : List RSt)
    (h : orbitOK p k rule L = true) : ∀ n t s, s ∈ L → Viab (classSys p k) n t s :=
  orbit_viable p k rule L (fun s hs => by
    simp only [orbitOK, List.all_eq_true, Bool.and_eq_true, List.contains_iff_mem] at h
    obtain ⟨⟨h1, h2⟩, h3⟩ := h s hs
    exact ⟨h1, h2, h3⟩)

/-! ## The reference instance -/

def refP : RPar := ⟨7, 2, 2, 2, true⟩
def refStart (R : Nat) : RSt := ⟨true, R, 7, 0, false, false, .none, false⟩
/-- The start of the fourth crisis on the patch-only path: depth 3, reserves 4, not authorized. -/
def regime3 : RSt := ⟨true, 4, 7, 3, false, false, .none, false⟩

/-- **The patch routine** survives three crises (21 ticks) and not the fourth. -/
theorem ref_patch_only :
    Viab (classSys refP .fixed) 21 0 (refStart 4) ∧ ¬ Viab (classSys refP .fixed) 28 0 (refStart 4) := by
  rw [class_ker_iff, class_ker_iff]
  decide +kernel

/-- After three crises the patch routine reaches `regime3`. -/
theorem ref_trajectory :
    (trajectory refP (fun s => ⟨routine s, false⟩) (refStart 4) 22).getLast? = some regime3 := by
  decide +kernel

theorem regime3_blocked : Blocked refP regime3 := by
  refine ⟨rfl, rfl, rfl, by decide, fun _ => ⟨by decide, by decide⟩, fun u h => ?_, fun u h => ?_, by decide⟩
  · simp [regime3] at h
  · simp [regime3] at h

/-- **Severity 3 after three successful escapes.** `regime3` is outside `𝒦_adapt` (hence outside
`𝒦_policy` and `𝒦_fixed`) for the rest of the crisis, and inside `𝒦_phys` at every horizon. -/
theorem ref_lockin :
    (∀ n t, 7 ≤ n → ¬ Viab (classSys refP .adapt) n t regime3) ∧
    (∀ n t, 7 ≤ n → ¬ Viab (classSys refP .policy) n t regime3) ∧
    (∀ n t, 7 ≤ n → ¬ Viab (classSys refP .fixed) n t regime3) ∧
    (∀ n t, Viab (classSys refP .phys) n t regime3) := by
  have hA : ∀ n t, 7 ≤ n → ¬ Viab (classSys refP .adapt) n t regime3 :=
    fun n t hn => blocked_not_viable refP (Or.inl rfl) n t regime3 regime3_blocked hn
  refine ⟨hA, fun n t hn h => hA n t hn ?_, fun n t hn h => hA n t hn ?_, ?_⟩
  · have := class_nesting refP (k := .policy) (k' := .adapt) (by decide) (n + t) t regime3
    simp only [K, Nat.add_sub_cancel] at this
    exact this h
  · have := class_nesting refP (k := .fixed) (k' := .adapt) (by decide) (n + t) t regime3
    simp only [K, Nat.add_sub_cancel] at this
    exact this h
  · intro n t
    exact seed_sustainable refP .phys (by decide) (phys_seed_adm refP rfl) n t regime3
      ⟨rfl, Or.inr ⟨rfl, rfl⟩, Or.inr rfl⟩

/-- **Severity 4 without a seed.** With no seed present, `regime3` is outside `𝒦_phys` as well. -/
theorem ref_no_seed :
    ∀ n t, 7 ≤ n → ¬ Viab (classSys { refP with seed := false } .phys) n t regime3 :=
  fun n t hn => blocked_not_viable _ (Or.inr ⟨rfl, rfl⟩) n t regime3 regime3_blocked hn

/-- **Early pruning is sustainable.** Patching twice and pruning at depth 2 is viable at every
horizon from depth 0 with no reserves: its trajectory enters a closed orbit. -/
theorem ref_prune_sustainable : ∀ n t, Viab (classSys refP .adapt) n t (refStart 0) := by
  have h := orbitOK_sound refP .adapt (pruneRule 2) (trajectory refP (pruneRule 2) (refStart 0) 85)
    (by decide +kernel)
  exact fun n t => h n t (refStart 0) (by decide +kernel)

/-! ## The exact sweep (computational)

Kernels are computed by memoized backward recursion on `classSys`: `win p k c s` is
`Viab (classSys p k) (c * D + s.left) t s` (`c` further crises after the current one), by the
recursion of `kerB` (`class_ker_iff`). -/

abbrev Memo := Std.HashMap Nat Bool

def enc (c : Nat) (s : RSt) : Nat :=
  let w := match s.work with
    | .none => 0
    | .patch u => 1 + 4 * u
    | .seed => 2
    | .prune u => 3 + 4 * u
  ((((((c * 8 + s.r) * 16 + s.left) * 64 + s.n) * 2 + (if s.auth then 1 else 0)) * 2 +
    (if s.done then 1 else 0)) * 2 + (if s.pend then 1 else 0)) * 1024 + w

partial def win (p : RPar) (k : Cls) (c : Nat) (s : RSt) : StateM Memo Bool := do
  if !s.up then return false
  let key := enc c s
  match (← get).get? key with
  | some v => return v
  | none =>
    let mut res := false
    for s' in succ p k s do
      let v ← if s.left ≤ 1 then (if c == 0 then pure s'.up else win p k (c - 1) s') else win p k c s'
      if v then
        res := true
        break
    modify (·.insert key res)
    return res

def start (p : RPar) (R : Nat) : RSt := ⟨true, R, p.D, 0, false, false, .none, false⟩
def classes : List Cls := [.fixed, .policy, .adapt, .phys]

/-- A deterministic rule's path: states with their remaining crises `c`, until the horizon or a
failure (the first state that is down is included). The state at the horizon carries `c = H`. -/
def rulePath (p : RPar) (rule : RSt → Act) (s0 : RSt) : Array (Nat × RSt) := Id.run do
  let mut out : Array (Nat × RSt) := #[(H - 1, s0)]
  let mut c := H - 1
  let mut s := s0
  for _ in [0:H * p.D] do
    if !s.up then break
    let last := s.left ≤ 1
    s := f p s (rule s)
    if last && c == 0 then
      out := out.push (H, s)
      break
    if last then c := c - 1
    out := out.push (c, s)
  return out

/-- Membership of each state in the four kernels (for the remaining horizon; at the horizon,
viability itself). -/
@[noinline] def memberships (p : RPar) (pts : Array (Nat × RSt)) : Array (Array Bool) :=
  classes.toArray.map fun k =>
    (pts.mapM (m := StateM Memo) fun (c, s) => if c == H then pure s.up else win p k c s).run' {}

def severity (m : Array (Array Bool)) (i : Nat) : Nat :=
  if m[0]![i]! then 0 else if m[1]![i]! then 1 else if m[2]![i]! then 2 else if m[3]![i]! then 3 else 4

/-- All states reachable from the start under physical actions (a superset of every class), with
their remaining crises. -/
@[noinline] def reachable (p : RPar) (s0 : RSt) : Array (Nat × RSt) := Id.run do
  let mut seen : Std.HashMap Nat Unit := {}
  seen := seen.insert (enc (H - 1) s0) ()
  let mut all : Array (Nat × RSt) := #[(H - 1, s0)]
  let mut frontier : Array (Nat × RSt) := #[(H - 1, s0)]
  for _ in [0:H * p.D + 1] do
    if frontier.isEmpty then break
    let mut nxt : Array (Nat × RSt) := #[]
    for (c, s) in frontier do
      if s.up && !(s.left ≤ 1 && c == 0) then
        for s' in succ p .phys s do
          if s'.up then
            let c' := if s.left ≤ 1 then c - 1 else c
            let key := enc c' s'
            if !seen.contains key then
              seen := seen.insert key ()
              nxt := nxt.push (c', s')
              all := all.push (c', s')
    frontier := nxt
  return all

/-- A rule survives the horizon if every action it takes is admissible in the adaptive class and
the organization is up at the horizon. -/
def survives (p : RPar) (rule : RSt → Act) (s0 : RSt) : Bool :=
  let path := rulePath p rule s0
  path[path.size - 1]!.1 == H && path[path.size - 1]!.2.up &&
    (path.toList.dropLast.all fun (_, s) => (acts p .adapt s).contains (rule s))

/-- The rule "authorize the seed at the first crisis it can be afforded, then use it". -/
def seedRule (p : RPar) (s : RSt) : Act :=
  if s.done then ⟨.wait, false⟩
  else if inFlight s.work then ⟨.cont, false⟩
  else if s.auth then ⟨.seed, false⟩
  else if p.seed && !s.pend && decide (AUTH_COST ≤ s.r) then ⟨.patch, true⟩ else ⟨.patch, false⟩

def bound (D l0 delta : Nat) : Nat := if l0 ≤ D then (D - l0) / delta + 1 else 0

end Paradox.RatchetModel
