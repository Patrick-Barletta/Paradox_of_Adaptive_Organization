import Paradox.SharedRatchet

/-!
# Argument VI, Part II: the exact joint-system sweep

The computation behind `argVI multi` (results/argVI_multi_output.txt), cross-checked line by line
against `python/toy/argVI.py multi`. It evaluates the joint system `jrsys` of
`Paradox/SharedRatchet.lean`: agent 1's admissible actions (`adm₁`), the partners' classes and
disturbance sets (`pick`, `inW`) and the transition `fJ`, so the system evaluated here is the one the
theorems are about. Kernels are computed by backward recursion over the functioning states reachable
from the origin; the condition at each state is that of the robust kernel `RViab` (I.3.8), which for
assignments without adversaries is the kernel `K` (`kernel_eq`).

Two reductions leave every kernel value unchanged. Actions that lead to a non-functioning state (a
cooperative agent's null action in a chain escape) are never part of a viable continuation, so the
existential choices omit them. Partner actions that cannot change an outcome (segment actions in a
seed escape, votes when nothing is proposed or governance is not unanimous) are enumerated once.
-/

namespace Paradox.SharedRatchetModel

open Paradox.SharedRatchet

def H : Nat := 12
def ALPHA : Nat := 2

def mkPar (D l0 delta lam : Nat) (gov : Gov) (phys overt : Bool := false) : Par :=
  ⟨D, l0, delta, lam, ALPHA, gov, phys, overt⟩

/-- Agent 1's actions in preference order. -/
def cmoves : List CMove :=
  [⟨false, .patch, false⟩, ⟨false, .patch, true⟩, ⟨true, .patch, false⟩, ⟨true, .patch, true⟩,
   ⟨false, .prune, false⟩, ⟨false, .prune, true⟩]
def cnames : List String :=
  ["chain patch", "chain patch + propose", "seed", "seed + propose", "chain prune", "chain prune + propose"]
def allP : List PMove := [⟨.patch, true⟩, ⟨.patch, false⟩, ⟨.prune, true⟩, ⟨.prune, false⟩]

/-- `adm₁` as a Boolean test. -/
def adm₁b (p : Par) (s : JSt) (m : CMove) : Bool :=
  (!m.seed || (p.gov.hasSeed && (s.auth || p.phys))) && (!m.propose || (p.gov.hasSeed && !s.auth))

/-- Partner actions that can change the outcome of `m₁` (restoring the segment). -/
def pmoves (p : Par) (s : JSt) (m₁ : CMove) : List PMove :=
  let segs : List Seg := if m₁.seed then [.patch] else [.patch, .prune]
  let votes : List Bool := if proposes p s m₁ && p.gov.unan then [true, false] else [true]
  segs.foldr (fun g acc => votes.map (fun v => (⟨g, v⟩ : PMove)) ++ acc) []

/-- The adversary's disturbance set `W` (`inW`): with `overt`, withholding the segment as well. -/
def wmoves (p : Par) (s : JSt) (m₁ : CMove) : List PMove :=
  if p.overt && !m₁.seed then pmoves p s m₁ ++ [⟨.idle, true⟩, ⟨.idle, false⟩] else pmoves p s m₁

def idx (s : JSt) : Nat := ((s.n₁ * 16 + s.n₂) * 16 + s.n₃) * 2 + (if s.auth then 1 else 0)
def NS : Nat := 16 * 16 * 16 * 2

/-- All functioning states reachable from the origin under admissible actions (depths stay below
13). -/
def reachable (p : Par) : Array JSt := Id.run do
  let mut seen := mkArray NS false
  seen := seen.set! (idx origin) true
  let mut all : Array JSt := #[origin]
  let mut frontier : Array JSt := #[origin]
  for _ in [0:100000] do
    if frontier.isEmpty then break
    let mut nxt : Array JSt := #[]
    for s in frontier do
      for m₁ in cmoves.filter (adm₁b p s) do
        for m₂ in allP do
          for m₃ in allP do
            let y := fJ p s m₁ m₂ m₃
            if y.up && !seen[idx y]! then
              seen := seen.set! (idx y) true
              nxt := nxt.push y
              all := all.push y
    frontier := nxt
  return all

def ctrlPart (st : Stance) (pm : List PMove) : List PMove := if st == .adapt then pm else [dummyP]
def distPart (st : Stance) (wm : List PMove) : List PMove := if st == .adv then wm else [dummyP]

/-- `RViab`'s condition for agent 1's action `m₁` at `s`: `m₁` is admissible, and some choice of the
adapt-class partners makes every disturbance lead to a functioning state in the next-layer table. -/
def moveOk (p : Par) (r₂ r₃ : JSt → PMove) (s₂ s₃ : Stance) (s : JSt) (m₁ : CMove)
    (prev : JSt → Bool) : Bool :=
  adm₁b p s m₁ &&
  let pm := pmoves p s m₁
  let wm := wmoves p s m₁
  (ctrlPart s₂ pm).any fun c₂ => (ctrlPart s₃ pm).any fun c₃ =>
    (distPart s₂ wm).all fun w₂ => (distPart s₃ wm).all fun w₃ =>
      let y := fJ p s m₁ (pick s₂ (r₂ s) c₂ w₂) (pick s₃ (r₃ s) c₃ w₃)
      y.up && prev y

/-- `lay[k][idx s]`: `s` is in the robust kernel for `k` more cycles. -/
def layers (p : Par) (r₂ r₃ : JSt → PMove) (s₂ s₃ : Stance) (states : Array JSt) :
    Array (Array Bool) := Id.run do
  let mut lay : Array (Array Bool) := #[mkArray NS true]
  for _ in [0:H] do
    let prev := lay[lay.size - 1]!
    let mut cur := mkArray NS false
    for s in states do
      cur := cur.set! (idx s) (cmoves.any fun m₁ => moveOk p r₂ r₃ s₂ s₃ s m₁ fun y => prev[idx y]!)
    lay := lay.push cur
  return lay

def horizon (lay : Array (Array Bool)) : Nat :=
  ((List.range (H + 1)).filter fun k => lay[k]![idx origin]!).foldl max 0

/-- Cycles guaranteed (up to `k`) when agent 1 takes the first action, in preference order, that
escapes this cycle against every disturbance (assignments with no adapt-class partner). -/
def myopic (p : Par) (r₂ r₃ : JSt → PMove) (s₂ s₃ : Stance) : Nat → JSt → Nat
  | 0, _ => 0
  | k + 1, s =>
    match cmoves.find? (fun m₁ => moveOk p r₂ r₃ s₂ s₃ s m₁ fun _ => true) with
    | none => 0
    | some m₁ =>
      let wm := wmoves p s m₁
      1 + (distPart s₂ wm).foldl (fun acc w₂ => (distPart s₃ wm).foldl (fun acc w₃ =>
          let y := fJ p s m₁ (pick s₂ (r₂ s) dummyP w₂) (pick s₃ (r₃ s) dummyP w₃)
          if y.up then min acc (myopic p r₂ r₃ s₂ s₃ k y) else acc) acc) k

/-- A fixed partner's routine: patch, or prune at depth 2; it votes `vote` on a proposal (a modeling
choice reported as a variant). With `vote = true` these are `patchRoutine` and `prune2Routine`. -/
def routV (prune2 vote : Bool) (get : JSt → Nat) : JSt → PMove :=
  fun s => ⟨if prune2 && decide (2 ≤ get s) then .prune else .patch, vote⟩
def rout2 (prune2 : Bool) (vote : Bool := true) : JSt → PMove := routV prune2 vote (·.n₂)
def rout3 (prune2 : Bool) (vote : Bool := true) : JSt → PMove := routV prune2 vote (·.n₃)

/-- Class/stance assignments of partners 2 and 3: C = `𝒰_adapt`, N = `𝒰_fixed`, A = adversary. -/
def profs : Array (String × Stance × Stance) :=
  #[("CC", .adapt, .adapt), ("CN", .adapt, .fixed), ("NN", .fixed, .fixed),
    ("CA", .adapt, .adv), ("NA", .fixed, .adv), ("AA", .adv, .adv)]
def govs : List Gov := [.noSeed, .unilateral, .unanimous]
def govName : Gov → String
  | .noSeed => "none"
  | .unilateral => "unilateral"
  | .unanimous => "unanimous"

@[noinline] def allLayers (p : Par) (prune2 : Bool) (st : Array JSt) (vote : Bool := true) :
    Array (Array (Array Bool)) :=
  profs.map fun (_, s₂, s₃) => layers p (rout2 prune2 vote) (rout3 prune2 vote) s₂ s₃ st

/-- The physical class of each assignment: routines freed, the seed admissible unauthorized. -/
@[noinline] def physLayers (p : Par) (prune2 : Bool) : Array (Array (Array Bool)) :=
  let pp := physP p
  let st := reachable pp
  profs.map fun (_, s₂, s₃) => layers pp (rout2 prune2) (rout3 prune2) (physStance s₂) (physStance s₃) st

/-- Pointwise checks of the six one-step substitutions (smaller assignment ⊆ larger). -/
@[noinline] def nestCheck (lays : Array (Array (Array Bool))) (st : Array JSt) : Nat × Nat := Id.run do
  let mut checks := 0
  let mut viol := 0
  for (a, b) in [(1, 0), (3, 1), (2, 1), (4, 2), (4, 3), (5, 4)] do
    let la := lays[a]!
    let lb := lays[b]!
    for k in [0:H + 1] do
      for s in st do
        checks := checks + 1
        if la[k]![idx s]! && !lb[k]![idx s]! then viol := viol + 1
  return (checks, viol)

structure CfgRes where
  hz : Array Nat       -- index (governance * 2 + routine) * 6 + assignment
  checks : Nat
  viol : Nat
  physUnan : Nat       -- physical class of CNA under unanimity
  physNone : Array Nat -- physical class of each assignment with no seed (routine patch)
  overt : Array Nat    -- overt adversary: CCA, CNA, CAA under each governance rule
  unanNo : Array Nat   -- unanimity with neutral routines voting no: routine * 6 + assignment
  myo : Nat

@[noinline] def evalCfg (D l0 d lam : Nat) : CfgRes := Id.run do
  let mut hz : Array Nat := #[]
  let mut checks := 0
  let mut viol := 0
  for gov in govs do
    let p := mkPar D l0 d lam gov
    let st := reachable p
    for prune2 in [false, true] do
      let lays := allLayers p prune2 st
      hz := hz ++ lays.map horizon
      let (c, v) := nestCheck lays st
      checks := checks + c
      viol := viol + v
  let physUnan := horizon (physLayers (mkPar D l0 d lam .unanimous) false)[4]!
  let physNone := (physLayers (mkPar D l0 d lam .noSeed) false).map horizon
  let mut overt : Array Nat := #[]
  for gov in govs do
    let po := mkPar D l0 d lam gov false true
    let st := reachable po
    for i in [3, 4, 5] do
      let (_, s₂, s₃) := profs[i]!
      overt := overt.push (horizon (layers po (rout2 false) (rout3 false) s₂ s₃ st))
  let pu := mkPar D l0 d lam .unanimous
  let stu := reachable pu
  let unanNo := (allLayers pu false stu false ++ allLayers pu true stu false).map horizon
  let myo := myopic (mkPar D l0 d lam .unilateral) (rout2 false) (rout3 false) .fixed .adv H origin
  return ⟨hz, checks, viol, physUnan, physNone, overt, unanNo, myo⟩

def bnd (D l0 g : Nat) : Nat := (D - l0) / g + 1

def countIf {α : Type} (xs : Array α) (f : α → Bool) : Nat := (xs.filter f).size

def row (lays : Array (Array (Array Bool))) : String :=
  ", ".intercalate ((List.range 6).map fun i => s!"C{profs[i]!.1} {horizon lays[i]!}")

def refLines : IO Unit := do
  IO.println "REFERENCE D=7, l0=2, delta=2, prune time 1+2n per segment, neutral routine patch; cycles survived from the origin, by classes of partners 2 and 3 (C adapt, N fixed, A adversary)"
  for gov in govs do
    let p := mkPar 7 2 2 2 gov
    IO.println s!"GOV {govName gov}: {row (allLayers p false (reachable p))}"
  IO.println s!"GOV none, physical class (routines freed; no seed present): {row (physLayers (mkPar 7 2 2 2 .noSeed) false)}"
  IO.println s!"GOV unanimous, physical class (routines freed; seed admissible unauthorized): {row (physLayers (mkPar 7 2 2 2 .unanimous) false)}"
  let pu := mkPar 7 2 2 2 .unanimous
  IO.println s!"GOV unanimous, neutral routines vote no: {row (allLayers pu false (reachable pu) false)}"
  let pu := mkPar 7 2 2 2 .unilateral
  let lay := layers pu (rout2 false) (rout3 false) .fixed .adv (reachable pu)
  let prev := lay[H - 1]!
  let first := ((List.range 6).find? fun i =>
    moveOk pu (rout2 false) (rout3 false) .fixed .adv origin cmoves[i]! fun y => prev[idx y]!).getD 0
  let g := myopic pu (rout2 false) (rout3 false) .fixed .adv H origin
  IO.println s!"FIRST MOVE unilateral CNA (first action in preference order that keeps the origin in the kernel): {cnames[first]!}; with one-cycle lookahead agent 1 guarantees {g} of {H} cycles"
  IO.println "BOUNDS reference: one neutral patcher floor((D-l0)/delta)+1 = 3; two patchers floor((D-l0)/(2*delta))+1 = 2"

@[noinline] def sweepLines (base : Array (Nat × Nat × Nat × Nat)) (res : Array CfgRes) : IO Unit := do
  let n := base.size
  let both := base.zip res
  let checks := res.foldl (fun a r => a + r.checks) 0
  let viol := res.foldl (fun a r => a + r.viol) 0
  IO.println s!"NESTING kernel inclusions adversary <= fixed <= adapt (6 substitutions, every reachable state, horizons 0..{H}): {checks} checks, {viol} violations"
  for gi in [0:3] do
    for ri in [0:2] do
      let name := govName govs[gi]!
      let rname := if ri == 0 then "patch" else "prune2"
      let cells := (List.range 6).map fun pi =>
        s!"C{profs[pi]!.1} {countIf res fun r => r.hz[(gi * 2 + ri) * 6 + pi]! == H}"
      IO.println s!"SURVIVAL gov={name} routine={rname}: {", ".intercalate cells} (configurations surviving all {H} cycles, of {n})"
  let h (r : CfgRes) (pi : Nat) (gi : Nat := 0) : Nat := r.hz[(gi * 2) * 6 + pi]!
  let b1 (c : Nat × Nat × Nat × Nat) : Nat := bnd c.1 c.2.1 c.2.2.1
  let b2 (c : Nat × Nat × Nat × Nat) : Nat := bnd c.1 c.2.1 (2 * c.2.2.1)
  IO.println s!"BOUND no seed, routine patch, CCN: cycles survived <= floor((D-l0)/delta)+1 in {countIf both fun (c, r) => decide (h r 1 ≤ b1 c)}, equal in {countIf both fun (c, r) => h r 1 == min H (b1 c)}; CNN: <= floor((D-l0)/(2*delta))+1 in {countIf both fun (c, r) => decide (h r 2 ≤ b2 c)}, equal in {countIf both fun (c, r) => h r 2 == min H (b2 c)} (of {n})"
  IO.println s!"BOUND CNA, routine patch: <= floor((D-l0)/(2*delta))+1 with no seed in {countIf both fun (c, r) => decide (h r 4 ≤ b2 c)} and under unanimity in {countIf both fun (c, r) => decide (h r 4 2 ≤ b2 c)}; unanimity gives the no-seed survival in {countIf res fun r => h r 4 2 == h r 4}"
  let sev (pi : Nat) : String :=
    let out := res.filter fun r => decide (h r pi < H)
    s!"C{profs[pi]!.1} {out.size} (severity 3: {countIf out fun r => r.physNone[pi]! == H}, severity 4: {countIf out fun r => decide (r.physNone[pi]! < H)})"
  IO.println s!"SEVERITY no seed, routine patch, outside the {H}-cycle kernel: {", ".intercalate ((List.range 6).map sev)}"
  IO.println s!"NEUTRAL vs ADVERSARY no seed: replacing fixed partner 3 by an adversary leaves survival unchanged in {countIf res fun r => h r 4 == h r 2} (routine patch) and {countIf res fun r => r.hz[6 + 4]! == r.hz[6 + 2]!} (routine prune2) of {n}"
  let veto := res.filter fun r => h r 2 2 == H && decide (h r 4 2 < H)
  IO.println s!"VETO unanimity, routine patch: CNN survives all {H} cycles and CNA does not in {veto.size}; the physical class survives all {H} in {countIf veto fun r => r.physUnan == H} of them (severity 3)"
  let early := both.filter fun (c, _) => decide (c.2.1 + ALPHA + 2 ≤ c.1)
  IO.println s!"UNILATERAL CNA, routine patch: survives all {H} cycles in {countIf res fun r => h r 4 1 == H}; early-authorization condition l0+alpha+2 <= D holds in {early.size}, of which surviving {countIf early fun (_, r) => h r 4 1 == H}; one-cycle lookahead survives all {H} in {countIf res fun r => r.myo == H}"
  for ri in [0:2] do
    let rname := if ri == 0 then "patch" else "prune2"
    let cells := (List.range 6).map fun pi => s!"C{profs[pi]!.1} {countIf res fun r => r.unanNo[ri * 6 + pi]! == H}"
    IO.println s!"VOTE neutral routines vote no, gov=unanimous routine={rname}: {", ".intercalate cells} (configurations surviving all {H} crises, of {n})"
  IO.println s!"VOTE neutral routines vote no, routine patch: CNN survives all {H} crises in {countIf res fun r => r.unanNo[2]! == H}, CNA in {countIf res fun r => r.unanNo[4]! == H}; CNN survival equals its no-seed survival in {countIf res fun r => r.unanNo[2]! == h r 2}"
  let ov := (List.range 3).map fun gi => s!"{govName govs[gi]!} {", ".intercalate ((List.range 3).map fun j => s!"C{profs[3 + j]!.1} {countIf res fun r => r.overt[gi * 3 + j]! == H}")}"
  IO.println s!"OVERT adversary (may withhold its segment), routine patch: surviving all {H} cycles: {"; ".intercalate ov}; surviving the first cycle: {countIf res fun r => r.overt.any (· > 0)} of {n} under any rule"

def multiMain : IO Unit := do
  IO.println "Argument VI, Part II: the joint system of three agents on a shared recovery chain"
  IO.println s!"  agent 1 in the adapt class; partners 2 and 3 each adapt (C), fixed (N: incumbent routine, votes yes unless stated) or adversarial (A: a disturbance, I.3.8, covert unless stated); authorization costs {ALPHA} ticks of the current crisis and takes effect next cycle; horizon {H} cycles"
  refLines
  let mut base : Array (Nat × Nat × Nat × Nat) := #[]
  for D in [4:13] do
    for l0 in [1:5] do
      for d in [1:4] do
        for lamk in [0, 1, 2] do
          base := base.push (D, l0, d, lamk)
  IO.println s!"SWEEP D=4..12, l0=1..4, delta=1..3, prune slope lam in (0, delta, 2*delta); {base.size} configurations, each under 3 governance rules and 2 neutral routines (patch; prune at depth 2)"
  let res := base.map fun (D, l0, d, lamk) => evalCfg D l0 d (lamk * d)
  sweepLines base res

end Paradox.SharedRatchetModel
