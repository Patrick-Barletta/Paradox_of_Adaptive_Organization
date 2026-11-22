import Paradox.RatchetModel

/-! Argument VI: the escape ratchet. Prints the same text as `python/toy/argVI.py`
(results/argVI_output.txt). -/

open Paradox.RatchetModel

def feas (b : Bool) : String := if b then "feasible" else "infeasible"
def b01 (b : Bool) : String := if b then "1" else "0"
def sevTxt (adapt phys : Bool) : String :=
  if phys && !adapt then "3" else if !phys then "4" else "<3"

def depths (traj : List Cyc) : List Nat := traj.map (·.1)

def refMain : IO Unit := do
  let m := Model.mk' 7 2 2 2 true
  let tabA := m.kernelTab false
  let tabP := m.kernelTab true
  IO.println "REFERENCE D=7, l0=2, delta=2, prune time 3+2n, seed physically present but not authorized, reserves start at 4"
  for n in [0:5] do
    let p := chainTime 2 2 n
    let q := 2 + 1 + 2 * n
    IO.println s!"REGIME n={n}: bootstrap {p} ticks, patch {feas (escapes p 7)}; prune {q} ticks, {feas (escapes q 7)}"
  let first := ((List.range H).find? fun n => !escapes (chainTime 2 2 n) 7).getD 0
  IO.println s!"REFERENCE first infeasible patch cycle {first}; bound floor((D-l0)/delta)+1 = {bound 7 2 2}"
  let x3 : Cyc := (3, 4, false)
  let a := inK tabA x3 (H - 3)
  let p := inK tabP x3 (H - 3)
  IO.println s!"WITNESS regime 3 (n=3, R=4, seed not authorized): adaptive kernel {b01 a}, physical kernel {b01 p}, severity {sevTxt a p}"
  let m2 := Model.mk' 7 2 2 2 false
  let a2 := inK (m2.kernelTab false) x3 (H - 3)
  let p2 := inK (m2.kernelTab true) x3 (H - 3)
  IO.println s!"WITNESS without a seed: adaptive kernel {b01 a2}, physical kernel {b01 p2}, severity {sevTxt a2 p2}"
  let x0 : Cyc := (0, 4, false)
  for (pol, h, name) in [("patch", 0, "patch"), ("prune1", 0, "prune1"), ("prune2", 0, "prune2"), ("seed", 0, "seed"),
                         ("plan", 1, "planner h=1"), ("plan", 2, "planner h=2"), ("plan", 3, "planner h=3"),
                         ("plan", H, s!"planner h={H}")] do
    let (c, traj) := m.run tabA x0 pol h
    IO.println s!"POLICY {name}: survives {c} of {H} cycles; depths {depths traj}"

def bump (l : List (Int × Nat)) (k : Int) : List (Int × Nat) :=
  if l.any (·.1 == k) then l.map fun (a, b) => if a == k then (a, b + 1) else (a, b) else l ++ [(k, 1)]

def fmtCounts (l : List (Int × Nat)) : String :=
  ", ".intercalate (((l.toArray.qsort (fun x y => x.1 < y.1)).toList).map fun (k, v) => s!"{k}: {v}")

def sweepMain : IO Unit := do
  let mut configs : Array (Nat × Nat × Nat × Nat × Bool × Nat) := #[]
  for D in [4:13] do
    for l0 in [1:5] do
      for d in [1:4] do
        for lamk in [0, 1, 2] do
          for seed in [false, true] do
            for R0 in [0, 2, 4] do
              configs := configs.push (D, l0, d, lamk, seed, R0)
  IO.println s!"SWEEP D=4..12, l0=1..4, delta=1..3, prune slope lam in (0, delta, 2*delta), seed absent/present, reserves start 0/2/4; {configs.size} configurations, horizon {H} cycles"
  let mut boundOk := 0
  let mut boundN := 0
  let mut sev3 := 0
  let mut sev4 := 0
  let mut early := 0
  let mut survives := 0
  let mut recoverable := 0
  let mut exclAt : List (Int × Nat) := []
  let mut latest : List (Int × Nat) := []
  let mut surv : Array Nat := mkArray 8 0
  let mut byLam : Array (Nat × Nat) := mkArray 3 (0, 0)
  let mut avoided : Array (Nat × Nat × Nat × Nat × Bool × Nat) := #[]
  for (D, l0, d, lamk, seed, R0) in configs do
    let m := Model.mk' D l0 d (lamk * d) seed
    let tabA := m.kernelTab false
    let tabP := m.kernelTab true
    let x0 : Cyc := (0, R0, false)
    if l0 ≤ D then
      boundN := boundN + 1
      let first := (List.range (H + 2)).find? fun n => !escapes (chainTime l0 d n) D
      if first == some (bound D l0 d) then boundOk := boundOk + 1
    let (c, traj) := m.run tabA x0 "patch"
    let trajA := traj.toArray
    let excl := ((List.range (trajA.size + 1)).find? fun i =>
      decide (i ≥ trajA.size) || !inK tabA (trajA[i]!) (H - i)).getD trajA.size
    if excl ≥ trajA.size then
      if c == H then survives := survives + 1 else recoverable := recoverable + 1
    else
      let x := trajA[excl]!
      if inK tabP x (H - excl) then sev3 := sev3 + 1 else sev4 := sev4 + 1
      if excl < c then early := early + 1
      exclAt := bump exclAt excl
    let lp : Int := (List.range trajA.size).foldl (fun (acc : Int) (i : Nat) =>
      let x : Cyc := trajA[i]!
      if m.pruneOk[x.1]! && x.2.1 ≥ PRUNE_COST then max acc (i : Int) else acc) (-1)
    latest := bump latest lp
    let pols := ["patch", "prune1", "prune2", "seed"]
    for i in [0:4] do
      if (m.run tabA x0 pols[i]!).1 == H then surv := surv.set! i (surv[i]! + 1)
    let hs := [1, 2, 3, H]
    for j in [0:4] do
      let ok := (m.run tabA x0 "plan" hs[j]!).1 == H
      if ok then surv := surv.set! (4 + j) (surv[4 + j]! + 1)
      if hs[j]! == H then
        let (a, b) := byLam[lamk]!
        byLam := byLam.set! lamk (if ok then a + 1 else a, b + 1)
        if ok && c < H && avoided.size < 4 then avoided := avoided.push (D, l0, d, lamk * d, seed, R0)
  IO.println s!"BOUND first infeasible patch cycle equals floor((D-l0)/delta)+1 in {boundOk} of {boundN} configurations with l0 <= D"
  IO.println s!"LOCKIN patch-only: survives all {H} cycles in {survives}; fails while its state is still in the adaptive kernel in {recoverable}; leaves the adaptive kernel in {sev3 + sev4}, with the physical kernel holding there (severity 3) in {sev3} and not (severity 4) in {sev4}, and before the patch failure in {early}"
  IO.println s!"LOCKIN cycle of first exclusion (= successful escapes before it): {fmtCounts exclAt}"
  IO.println s!"PRUNE latest cycle on the patch-only path at which pruning is still feasible (-1 = never): {fmtCounts latest}"
  let names := ["patch", "prune1", "prune2", "seed", "plan1", "plan2", "plan3", s!"plan{H}"]
  IO.println s!"SURVIVAL policies surviving all {H} cycles: {", ".intercalate ((List.range 8).map fun i => s!"{names[i]!} {surv[i]!}")} (of {configs.size})"
  let lamNames := ["0", "delta", "2*delta"]
  IO.println s!"SENSITIVITY planner (full lookahead) survival by prune slope: {", ".intercalate ((List.range 3).map fun k => s!"lam={lamNames[k]!} {byLam[k]!.1}/{byLam[k]!.2}")}"
  for (D, l0, d, lam, seed, R0) in avoided do
    let m := Model.mk' D l0 d lam seed
    let tabA := m.kernelTab false
    let (c, traj) := m.run tabA (0, R0, false) "plan" H
    IO.println s!"AVOIDED D={D} l0={l0} delta={d} lam={lam} seed={b01 seed} R0={R0}: patch-only fails at cycle {(m.run tabA (0, R0, false) "patch").1}, planner survives {c}; depths {depths traj}"

def main : IO Unit := do
  IO.println "Argument VI: the escape ratchet"
  IO.println s!"  reserves capped at {CAP}, income {INCOME} per cycle; prune costs {PRUNE_COST}; authorizing the seed costs {AUTH_COST} and takes effect next cycle; horizon {H} cycles"
  refMain
  sweepMain
