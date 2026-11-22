import Paradox.RatchetModel
import Paradox.SharedRatchetModel

/-! Argument VI: the escape ratchet in the four control classes of I.3, on the tick-level state
`(x, O, q)` of `Paradox/RatchetModel.lean` (results/argVI_output.txt). With the argument `multi`,
Part II (the joint system of three agents): the same text as `python/toy/argVI.py multi`
(results/argVI_multi_output.txt). -/

open Paradox.RatchetModel

def feas (b : Bool) : String := if b then "feasible" else "infeasible"
def b01 (b : Bool) : String := if b then "1" else "0"

/-- Run a rule for one crisis from `s`; does the organization reach the next crisis? -/
def oneCrisis (p : RPar) (rule : RSt → Act) (s : RSt) : Bool := Id.run do
  let mut x := s
  for _ in [0:p.D] do
    x := f p x (rule x)
  return x.up

def fixedRule (s : RSt) : Act := ⟨routine s, false⟩

/-- Path analysis for the patch routine: severities, points of no return and failure. -/
structure PathRes where
  sev : Array Nat          -- severity of each state on the path
  tstar : Array Int        -- last tick in each class's kernel (-1: never)
  fail : Option Nat        -- tick of the first state that is down
  pattern : String         -- severities along the path while up, consecutive repeats removed
  deriving Inhabited

@[noinline] def analysePath (p : RPar) (s0 : RSt) : PathRes := Id.run do
  let path := rulePath p fixedRule s0
  let m := memberships p path
  let sev := (List.range path.size).toArray.map (severity m)
  let tstar := (List.range 4).toArray.map fun k =>
    (((List.range path.size).filter fun i => m[k]![i]!).foldl (fun (_ : Int) (i : Nat) => (i : Int)) (-1))
  let fail := (List.range path.size).find? fun i => !path[i]!.2.up
  let upto := fail.getD (path.size - 1)
  let mut pat : List Nat := []
  for i in [0:upto] do
    if pat.getLast? != some sev[i]! then pat := pat ++ [sev[i]!]
  return ⟨sev, tstar, fail, ">".intercalate (pat.map toString)⟩

def refMain : IO Unit := do
  let p := refP
  IO.println "REFERENCE D=7, l0=2, delta=2, prune 3+2n ticks, seed present but not authorized, reserves start at 4"
  for n in [0:5] do
    let s : RSt := ⟨true, 4, 7, n, false, false, .none, false⟩
    IO.println s!"REGIME n={n}: patch {patchTotal p n} ticks, {feas (oneCrisis p fixedRule s)}; prune {pruneTotal p n} ticks, {feas (oneCrisis p (pruneRule 0) s)}"
  let pr := analysePath p (start p 4)
  let failCrisis := (pr.fail.getD 0 - 1) / p.D
  IO.println s!"REFERENCE the patch routine fails in crisis {failCrisis} (tick {pr.fail.getD 0}); bound floor((D-l0)/delta)+1 = {bound 7 2 2}"
  let wit (q : RPar) : String := Id.run do
    let m := memberships q #[(H - 4, regime3)]
    let names := ["fixed", "policy", "adapt", "phys"]
    return s!"{", ".intercalate ((List.range 4).map fun k => s!"{names[k]!} {b01 m[k]![0]!}")}, severity {severity m 0}"
  IO.println s!"WITNESS start of crisis 3 on the patch path (n=3, R=4, not authorized), kernels for the remaining {H - 3} crises: {wit p}"
  IO.println s!"WITNESS the same state without a seed: {wit { p with seed := false }}"
  let groups := (List.range ((pr.sev.size + p.D - 1) / p.D)).map fun c =>
    String.join (((List.range p.D).filterMap fun i => pr.sev[c * p.D + i]?).map toString)
  IO.println s!"TRAJECTORY patch routine, severity by tick (one group per crisis): {"|".intercalate groups}"
  IO.println s!"TRAJECTORY points of no return t*: fixed {pr.tstar[0]!}, policy {pr.tstar[1]!}, adapt {pr.tstar[2]!}, phys {pr.tstar[3]!}; first down tick {pr.fail.getD 0}"
  let m0 := memberships p #[(H - 1, start p 4)]
  IO.println s!"POLICY survival of {H} crises from the start: patch routine {b01 (survives p fixedRule (start p 4))}, prune at depth 1 {b01 (survives p (pruneRule 1) (start p 4))}, prune at depth 2 {b01 (survives p (pruneRule 2) (start p 4))}, authorize the seed early {b01 (survives p (seedRule p) (start p 4))}; kernels at the start: fixed {b01 m0[0]![0]!}, policy {b01 m0[1]![0]!}, adapt {b01 m0[2]![0]!}, phys {b01 m0[3]![0]!}"

structure CfgRes where
  sev0 : Nat
  path : PathRes
  checks : Nat
  viol : Nat
  pol : Array Bool        -- prune1, prune2, seed, adapt kernel at the start
  boundOk : Option Bool   -- patch failure crisis = bound (when the bound is inside the horizon)
  deriving Inhabited

@[noinline] def nestAll (p : RPar) (s0 : RSt) : Nat × Nat :=
  let pts := reachable p s0
  let m := memberships p pts
  ((List.range pts.size).foldl (fun (c, v) i =>
    let b := (List.range 3).foldl (fun acc k => if m[k]![i]! && !m[k + 1]![i]! then acc + 1 else acc) 0
    (c + 3, v + b)) (0, 0))

@[noinline] def evalCfg (D l0 d lam : Nat) (seed : Bool) (R0 : Nat) : CfgRes :=
  let p : RPar := ⟨D, l0, d, lam, seed⟩
  let s0 := start p R0
  let m0 := memberships p #[(H - 1, s0)]
  let pr := analysePath p s0
  let (checks, viol) := nestAll p s0
  let b := bound D l0 d
  let boundOk := if b < H then some (pr.fail.map (fun t => (t - 1) / D) == some b) else none
  ⟨severity m0 0, pr, checks, viol,
   #[survives p (pruneRule 1) s0, survives p (pruneRule 2) s0, survives p (seedRule p) s0, m0[2]![0]!],
   boundOk⟩

def bump (l : List (String × Nat)) (k : String) : List (String × Nat) :=
  if l.any (·.1 == k) then l.map fun (a, b) => if a == k then (a, b + 1) else (a, b) else l ++ [(k, 1)]

@[noinline] def report (configs : Array (Nat × Nat × Nat × Nat × Bool × Nat)) (res : Array CfgRes) :
    IO Unit := do
  let n := res.size
  let checks := res.foldl (fun a r => a + r.checks) 0
  let viol := res.foldl (fun a r => a + r.viol) 0
  IO.println s!"NESTING fixed <= policy <= adapt <= phys at every state reachable under physical actions, for the remaining horizon: {checks} checks, {viol} violations"
  let sevCount (k : Nat) : Nat := (res.filter (·.sev0 == k)).size
  IO.println s!"SEVERITY at the start: sigma 0: {sevCount 0}, 1: {sevCount 1}, 2: {sevCount 2}, 3: {sevCount 3}, 4: {sevCount 4} (of {n})"
  let bk := res.filterMap (·.boundOk)
  IO.println s!"BOUND the patch routine fails in crisis floor((D-l0)/delta)+1 in {(bk.filter id).size} of {bk.size} configurations where that crisis is within the horizon"
  let survive := (res.filter fun r => r.path.fail.isNone).size
  let mut sev3 := 0
  let mut sev4 := 0
  let mut early := 0
  let mut atFail := 0
  let mut startOut := 0
  let mut pats : List (String × Nat) := []
  let mut tOrder := 0
  let mut polEqFixed := 0
  for i in [0:n] do
    let r : CfgRes := res[i]!
    let D := configs[i]!.1
    let ts : Array Int := r.path.tstar
    if decide (ts[0]! ≤ ts[1]! ∧ ts[1]! ≤ ts[2]! ∧ ts[2]! ≤ ts[3]!) then tOrder := tOrder + 1
    if ts[0]! == ts[1]! then polEqFixed := polEqFixed + 1
    pats := bump pats r.path.pattern
    match r.path.fail with
    | none => pure ()
    | some ft =>
      if decide (ts[2]! < 0) then startOut := startOut + 1
      else
        let ex := (ts[2]! + 1).toNat
        let failStart := ((ft - 1) / D) * D
        if ex < ft then
          if r.path.sev[ex]! == 3 then sev3 := sev3 + 1 else sev4 := sev4 + 1
          if ex < failStart then early := early + 1 else atFail := atFail + 1
  IO.println s!"LOCKIN patch routine: survives all {H} crises in {survive}; fails in {n - survive}: outside the adaptive kernel from the start in {startOut}; leaves it later while still up in {sev3 + sev4} (severity 3 there in {sev3}, severity 4 in {sev4}), during an earlier crisis than the failing one, while patches still succeed, in {early}, and during the failing crisis in {atFail}"
  let pstr := ", ".intercalate (((pats.toArray.qsort (fun a b => a.2 > b.2 || (a.2 == b.2 && a.1 < b.1))).toList).map fun (k, v) => s!"{k}: {v}")
  IO.println s!"PATTERN severities along the patch path while up (repeats removed): {pstr}"
  IO.println s!"TSTAR t*_fixed <= t*_policy <= t*_adapt <= t*_phys in {tOrder} of {n}; t*_policy = t*_fixed in {polEqFixed}"
  let polCount (j : Nat) : Nat := (res.filter fun r => r.pol[j]!).size
  IO.println s!"SURVIVAL of {H} crises: patch routine {survive}, prune at depth 1 {polCount 0}, prune at depth 2 {polCount 1}, authorize the seed early {polCount 2}, adaptive kernel (full lookahead) {polCount 3} (of {n})"
  let lamNames := ["0", "delta", "2*delta"]
  let cells := (List.range 3).map fun lk =>
    let idxs := (List.range n).filter fun i => configs[i]!.2.2.2.1 == lk
    s!"lam={lamNames[lk]!} {(idxs.filter fun i => res[i]!.pol[3]!).length}/{idxs.length}"
  IO.println s!"SENSITIVITY adaptive kernel at the start by prune slope: {", ".intercalate cells}"

def sweepMain : IO Unit := do
  let mut configs : Array (Nat × Nat × Nat × Nat × Bool × Nat) := #[]
  for D in [4:13] do
    for l0 in [1:5] do
      for d in [1:4] do
        for lamk in [0, 1, 2] do
          for seed in [false, true] do
            for R0 in [0, 2, 4] do
              configs := configs.push (D, l0, d, lamk, seed, R0)
  IO.println s!"SWEEP D=4..12, l0=1..4, delta=1..3, prune slope lam in (0, delta, 2*delta), seed absent/present, reserves start 0/2/4; {configs.size} configurations, horizon {H} crises"
  let res := configs.map fun (D, l0, d, lamk, seed, R0) => evalCfg D l0 d (lamk * d) seed R0
  report configs res

def main (args : List String) : IO Unit := do
  if args == ["multi"] then
    Paradox.SharedRatchetModel.multiMain
    return
  IO.println "Argument VI: the escape ratchet, four control classes on the tick-level state (x, O, q)"
  IO.println s!"  x = (up, reserves <= {CAP}, ticks to the deadline); O = (chain depth, seed authorized); q = (escape done, transition in flight, authorization pending); income {INCOME} per crisis; prune costs {PRUNE_COST}, authorizing {AUTH_COST} (effective at the next crisis); horizon {H} crises"
  refMain
  sweepMain
