import Paradox.Ratchet

/-!
# Argument VI: the reference ratchet and the exact sweep

**Proved (no `sorry`, no `native_decide`).** For the reference parameters (seed stage 2 ticks, each
patch stage 2 ticks, deadline 7, pruning `3 + 2n` ticks, an independent seed that activates in one
tick), derived from the serial chain and the deadline-escape system of `Paradox/Ratchet.lean`:

* `ref_patch_time`: the bootstrap time at regime `n` is `2 + 2n` (chain of `n` patch stages);
* `ref_patch_feasible`, `ref_patch_infeasible`: patching escapes at regimes 0–2 and not at 3;
* `ref_prune_feasible`, `ref_prune_infeasible`: pruning escapes at regimes 1–2 and not at 3;
* `ref_lockin`: at regime 3 the organizational transitions (patch, prune) all miss the deadline
  while the physically present but unauthorized seed fits: severity 3 within the cycle;
* `patch_only_fails`, `early_prune_sustainable`, `ref_cycle_lockin`: at the cycle level, patching
  only fails within four cycles, patching twice and then pruning is viable at every horizon
  (an invariant set), and depth 3 is outside the organizational kernel and inside the physical one.

In the cycle-level systems, an escape is admissible exactly when its duration fits the deadline;
that equivalence is `esc_viable` / `esc_not_viable` (one transition of duration `d` is viable iff
`d ≤ r`).

**Computed.** The rest of the file is the exact model behind `argVI` (cross-checked against
`python/toy/argVI.py`): durations by tick-level search of the chain and of the escape system, cycle
kernels by backward recursion, policy runs and the sweep.
-/

namespace Paradox.RatchetModel

open Paradox.Theory Paradox.Ratchet

/-! ## Reference parameters, within one cycle -/

/-- Bootstrap time at regime `n`: the seed stage (2 ticks) and `n` patch stages (2 ticks each). -/
abbrev refPatch (n : Nat) : Nat := psum (ratchetStages 2 2) (n + 1)
def refPrune (n : Nat) : Nat := 3 + 2 * n
def refStart : Esc := ⟨7, none, false⟩

theorem ref_patch_time (n : Nat) : refPatch n = 2 + 2 * n := by
  show psum (ratchetStages 2 2) (n + 1) = 2 + 2 * n
  rw [ratchet_latency]; omega

theorem ref_patch_feasible (n : Nat) (hn : n ≤ 2) (T : Nat) :
    K (escSys [refPatch n]) T 0 refStart :=
  esc_viable _ 7 ⟨refPatch n, by simp, by rw [ref_patch_time]; omega, by rw [ref_patch_time]; omega⟩ _ _

theorem ref_patch_infeasible (T : Nat) (hT : 7 < T) : ¬ K (escSys [refPatch 3]) T 0 refStart := by
  intro h
  refine esc_not_viable [refPatch 3] (T - 0) 0 refStart ⟨rfl, fun _ d hd => ?_, fun k hk => ?_⟩ ?_ h
  · simp at hd; rw [hd, ref_patch_time]; show 7 < _; omega
  · simp [refStart] at hk
  · show 7 < T - 0; omega

theorem ref_prune_feasible (n : Nat) (h1 : 1 ≤ n) (h2 : n ≤ 2) (T : Nat) :
    K (escSys [refPrune n]) T 0 refStart :=
  esc_viable _ 7 ⟨refPrune n, by simp, by simp only [refPrune]; omega, by simp only [refPrune]; omega⟩ _ _

theorem ref_prune_infeasible (T : Nat) (hT : 7 < T) : ¬ K (escSys [refPrune 3]) T 0 refStart := by
  intro h
  refine esc_not_viable [refPrune 3] (T - 0) 0 refStart ⟨rfl, fun _ d hd => ?_, fun k hk => ?_⟩ ?_ h
  · simp at hd; rw [hd]; show 7 < 3 + 2 * 3; omega
  · simp [refStart] at hk
  · show 7 < T - 0; omega

/-- **Reference lock-in witness.** At regime 3, the organizational transitions (patch and prune)
both miss the 7-tick deadline; with the physically present seed (one tick) admitted, the physical
class escapes. -/
theorem ref_lockin (T : Nat) (hT : 7 < T) :
    ¬ K (escSys [refPatch 3, refPrune 3]) T 0 refStart ∧
    K (escSys [refPatch 3, refPrune 3, 1]) T 0 refStart :=
  ratchet_lockin_witness _ _ 7 T hT
    (fun d hd => by
      simp at hd
      rcases hd with rfl | rfl
      · rw [ref_patch_time]; omega
      · simp [refPrune])
    ⟨1, by simp, Nat.le_refl 1, by omega⟩

/-! ## Reference parameters, across cycles

State: (chain depth, reserves). Patch is free and adds a stage; prune costs 2 reserves and resets
the depth; the seed escape (physical class only) keeps the depth. Reserves gain 1 per cycle and are
capped at 4. -/

def cycleStep (allowPrune allowSeed : Bool) (_t : Nat) (s s' : Nat × Nat) : Prop :=
  (2 + 2 * s.1 ≤ 7 ∧ s' = (s.1 + 1, min 4 (s.2 + 1))) ∨
  (allowPrune = true ∧ 3 + 2 * s.1 ≤ 7 ∧ 2 ≤ s.2 ∧ s' = (0, min 4 (s.2 - 2 + 1))) ∨
  (allowSeed = true ∧ s' = (s.1, min 4 (s.2 + 1)))

def cycleSys (allowPrune allowSeed : Bool) : Sys (Nat × Nat) :=
  ⟨cycleStep allowPrune allowSeed, fun _ => True⟩

/-- Patching only: three successful escapes, then none. -/
theorem patch_only_fails (R : Nat) : ¬ Viab (cycleSys false false) 4 0 (0, R) := by
  rintro ⟨_, s1, h1, _, s2, h2, _, s3, h3, _, s4, h4, _⟩
  simp only [cycleSys, cycleStep, Bool.false_eq_true, false_and, or_false] at h1 h2 h3 h4
  obtain ⟨-, rfl⟩ := h1
  obtain ⟨-, rfl⟩ := h2
  obtain ⟨-, rfl⟩ := h3
  obtain ⟨h, -⟩ := h4
  simp at h

/-- **Sustainable landing.** Patching twice and then pruning repeats forever: viable at every
horizon from depth 0 with no reserves. -/
theorem early_prune_sustainable : ∀ n t, Viab (cycleSys true false) n t (0, 0) := by
  intro n t
  apply invariant_viable (cycleSys true false)
    (fun s => s.1 = 0 ∨ (s.1 = 1 ∧ 1 ≤ s.2) ∨ (s.1 = 2 ∧ 2 ≤ s.2))
    (fun _ _ => trivial)
  · intro t s hs
    obtain ⟨d, R⟩ := s
    simp only at hs
    rcases hs with rfl | ⟨rfl, hR⟩ | ⟨rfl, hR⟩
    · exact ⟨(1, min 4 (R + 1)), Or.inl ⟨by omega, rfl⟩, Or.inr (Or.inl ⟨rfl, by omega⟩)⟩
    · exact ⟨(2, min 4 (R + 1)), Or.inl ⟨by omega, rfl⟩, Or.inr (Or.inr ⟨rfl, by omega⟩)⟩
    · exact ⟨(0, min 4 (R - 2 + 1)), Or.inr (Or.inl ⟨rfl, by omega, hR, rfl⟩), Or.inl rfl⟩
  · simp

/-- **Cycle-level witness.** At depth 3 no organizational escape exists, while the physical class,
which may activate the present seed, is viable at every horizon. -/
theorem ref_cycle_lockin (R : Nat) :
    (∀ t, ¬ Viab (cycleSys true false) 1 t (3, R)) ∧ (∀ n t, Viab (cycleSys true true) n t (3, R)) := by
  constructor
  · rintro t ⟨_, s', h, _⟩
    simp only [cycleSys, cycleStep, Bool.false_eq_true, false_and, or_false] at h
    rcases h with ⟨h, -⟩ | ⟨-, h, -⟩ <;> omega
  · intro n t
    exact invariant_viable (cycleSys true true) (fun s => s.1 = 3) (fun _ _ => trivial)
      (fun t s hs => ⟨(s.1, min 4 (s.2 + 1)), Or.inr (Or.inr ⟨rfl, rfl⟩), hs⟩) n t (3, R) rfl

/-! ## The exact model (computational) -/

def CAP : Nat := 4
def INCOME : Nat := 1
def PRUNE_COST : Nat := 2
def AUTH_COST : Nat := 3
def H : Nat := 12

/-- Minimum ticks to complete the seed stage and `n` further stages serially (search). -/
def chainTime (l0 delta n : Nat) : Nat := Id.run do
  let tau (i : Nat) : Nat := if i == 0 then l0 else delta
  let mut frontier : List (Nat × Nat) := [(0, 0)]
  for t in [0:10000] do
    if frontier.any (fun kp => kp.1 == n + 1) then return t
    let mut nxt : List (Nat × Nat) := []
    for (k, p) in frontier do
      nxt := (k, p) :: nxt
      if k ≤ n then
        nxt := (if p + 1 == tau k then (k + 1, 0) else (k, p + 1)) :: nxt
    frontier := nxt.eraseDups
  return 0

/-- Can a transition of duration `d` be completed before a deadline `D` ticks away (search over the
deadline-escape system)? -/
def escapes (d D : Nat) : Bool := Id.run do
  let mut frontier : List (Nat × Option Nat × Bool) := [(D, none, false)]
  for _ in [0:D + 1] do
    if frontier.any (·.2.2) then return true
    let mut nxt : List (Nat × Option Nat × Bool) := []
    for (r, w, _) in frontier do
      if r != 0 then
        nxt := (match w with
          | none => (r - 1, none, false)
          | some k => if k == 1 then (r - 1, none, true) else (r - 1, some (k - 1), false)) :: nxt
        if w.isNone then
          nxt := (if d == 1 then (r - 1, none, true) else (r - 1, some (d - 1), false)) :: nxt
    frontier := nxt.eraseDups
  return frontier.any (·.2.2)

structure Model where
  D : Nat
  l0 : Nat
  delta : Nat
  lam : Nat
  seed : Bool
  patchOk : Array Bool   -- by depth 0..H+1
  pruneOk : Array Bool
  seedOk : Bool

def Model.mk' (D l0 delta lam : Nat) (seed : Bool) : Model :=
  { D, l0, delta, lam, seed,
    patchOk := (List.range (H + 2)).toArray.map fun n => escapes (chainTime l0 delta n) D,
    pruneOk := (List.range (H + 2)).toArray.map fun n => escapes (l0 + 1 + lam * n) D,
    seedOk := escapes 1 D }

abbrev Cyc := Nat × Nat × Bool   -- depth, reserves, seed authorized

/-- Feasible (name, next state) pairs from `x`, in preference order. -/
def Model.options (m : Model) (x : Cyc) (phys : Bool) : List (String × Cyc) := Id.run do
  let (n, R, auth) := x
  let mut escs : List (String × Bool × Nat × Nat) := [("patch", m.patchOk[n]!, 0, n + 1)]
  if auth || (phys && m.seed) then escs := escs ++ [("seed", m.seedOk, 0, n)]
  escs := escs ++ [("prune", m.pruneOk[n]!, PRUNE_COST, 0)]
  let mut out : List (String × Cyc) := []
  for (name, ok, cost, n2) in escs do
    if ok then
      for authorize in [false, true] do
        if !(authorize && (auth || !m.seed)) then
          let c := cost + (if authorize then AUTH_COST else 0)
          if R ≥ c then
            out := out ++ [(name ++ (if authorize then "+auth" else ""),
                            (min n2 (H + 1), min CAP (R - c + INCOME), auth || authorize))]
  return out

def idx (x : Cyc) : Nat := (x.1 * (CAP + 1) + x.2.1) * 2 + (if x.2.2 then 1 else 0)
def nStates : Nat := (H + 2) * (CAP + 1) * 2
def stateOf (i : Nat) : Cyc := (i / 2 / (CAP + 1), i / 2 % (CAP + 1), i % 2 == 1)

/-- `kernel[k][idx x]`: viable for `k` more cycles. -/
def Model.kernelTab (m : Model) (phys : Bool) : Array (Array Bool) := Id.run do
  let mut tabs : Array (Array Bool) := #[mkArray nStates true]
  for k in [1:H + 1] do
    let prev := tabs[k - 1]!
    tabs := tabs.push ((List.range nStates).toArray.map fun i =>
      (m.options (stateOf i) phys).any fun (_, y) => prev[idx y]!)
  return tabs

def inK (tab : Array (Array Bool)) (x : Cyc) (k : Nat) : Bool := (tab[k]!)[idx x]!

/-- Follow a policy for `H` cycles: "patch", "prune1", "prune2", "seed" or "plan" (lookahead `h`).
Returns (cycles survived, trajectory). -/
def Model.run (m : Model) (tabA : Array (Array Bool)) (x0 : Cyc) (policy : String) (h : Nat := 0) :
    Nat × List Cyc := Id.run do
  let mut x := x0
  let mut traj : List Cyc := [x0]
  for c in [0:H] do
    let opts := m.options x false
    let get (nm : String) : Option Cyc := (opts.find? (·.1 == nm)).map (·.2)
    let y : Option Cyc :=
      if policy == "patch" then get "patch"
      else if policy == "prune1" then get (if x.1 ≥ 1 then "prune" else "patch")
      else if policy == "prune2" then get (if x.1 ≥ 2 then "prune" else "patch")
      else if policy == "seed" then
        match get "seed" with
        | some y => some y
        | none => match (if !x.2.2 then get "patch+auth" else none) with
          | some y => some y
          | none => get "patch"
      else
        let k := min h (H - c) - 1
        (opts.find? fun (_, y) => inK tabA y k).map (·.2)
    match y with
    | none => return (c, traj)
    | some y' =>
      x := y'
      traj := traj ++ [x]
  return (H, traj)

def bound (D l0 delta : Nat) : Nat := if l0 ≤ D then (D - l0) / delta + 1 else 0

end Paradox.RatchetModel
