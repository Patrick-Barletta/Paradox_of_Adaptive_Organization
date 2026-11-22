import Paradox.Climate

/-! Argument II experiments: the dilemma (stopping rules and acceleration costs), AI as accelerator
and margin consumer, and the numerical check that the required rate never falls with delay. -/

open Paradox.Climate

def yr (t : Int) : String := if t < 0 then "never" else toString (2027 + t)
def pct (r : Option Float) : String := match r with
  | some x => toString (x * 100).round.toUInt64 ++ "%" | none => "none"

def scan : List Float := (List.range 101).map fun i => i.toFloat / 100

def windowRates (p : CP) (s : CS) (throttled : Bool) : List Float :=
  scan.filter fun r =>
    if throttled then p.run s (p.grow r 1.0 p.phi) true 1.0 p.phi
    else p.run s (fun z => r * z.D) true 1.0 p.phi

def closeWith (p : CP) (b : Array CS) (throttled : Bool) : Int := Id.run do
  let mut tk : Int := -1
  for s in b do
    if s.C > p.budget + 1e-9 then break
    let ok := (p.rgrid).any fun r =>
      if throttled then p.run s (p.grow r 1.0 p.phi) true 1.0 p.phi
      else p.run s (fun z => r * z.D) true 1.0 p.phi
    if ok then tk := s.t else break
  return tk

/-- E-II.6 (printed by `argII ramp`): does a stopping-rule program acquire an upper rate limit once
acceleration has convex ramp costs or embodied emissions? Saved separately, so the default output
(results/argII_output.txt) is unchanged. -/
def rampDemo : IO Unit := do
  IO.println "E-II.6 acceleration costs (2.0C central, psi 0.5, phi 2, L 2; ramp premium above 10%/yr capacity growth)"
  for ccap in [0.3, 1.0, 3.0] do
    for (alpha, emb) in [(1.0, 0.0), (2.0, 0.0), (3.0, 0.0), (1.0, 0.3), (1.0, 1.0), (1.0, 3.0), (2.0, 1.0)] do
      let p : CP := { psi := 0.5, phi := 2.0, budget := 1035.0, ccap, alpha, embI := emb }
      let b := p.baseline
      for (nm, th) in [("stop when not binding", true), ("never stop", false)] do
        let w := windowRates p b[0]! th
        IO.println s!"RAMP ccap={ccap} alpha={alpha} emb={emb} program={nm} rmin={pct w.head?} rmax={pct w.getLast?} count={w.length} close={yr (closeWith p b th)}"

def main (args : List String) : IO Unit := do
  if args == ["ramp"] then rampDemo; return
  IO.println "E-II.2 dilemma (2.0C central, psi 0.5, phi 2)"
  for ccap in [0.3, 1.0, 3.0] do
    let p : CP := { psi := 0.5, phi := 2.0, budget := 1035.0, ccap }
    let b := p.baseline
    for (nm, th) in [("stop when not binding", true), ("never stop", false)] do
      let w := windowRates p b[0]! th
      IO.println s!"DIL ccap={ccap} program={nm} rmin={pct w.head?} rmax={pct w.getLast?} close={yr (closeWith p b th)}"
  IO.println "E-II.3 AI: capacity-building closing year (2.0C central, phi 2)"
  for psi in [0.5, 0.75] do
    for (nm, a30, a35) in [("none", 0.0, 0.0), ("IEA-base-like", 0.2, 0.3), ("high", 0.6, 1.2), ("extreme", 1.5, 3.0)] do
      for d in [0.0, 0.025, 0.05, 0.10, 0.20] do
        let p : CP := { psi := psi * (1 - d), phi := 2.0, budget := 1035.0, ai30 := a30, ai35 := a35 }
        let b := p.baseline
        IO.println s!"AI psi={psi} scen={nm} cut={d} close={yr (p.pnr 2 b)} cert={yr (p.pnrCert b)}"
  -- E-II.4: required (constant) rate never falls along the baseline
  let mut seqs := 0
  let mut viol := 0
  for psi in [0.5, 0.75, 1.0] do
    for phi in [1.5, 2.0, 3.0] do
      for B in [1035.0, 1035.0 * 0.45 / 0.63] do
        let p : CP := { psi, phi, budget := B }
        let b := p.baseline
        seqs := seqs + 1
        let mut prev : Float := -1.0
        for s in b do
          if s.C > p.budget + 1e-9 then break
          let cur := match p.rmin s with | some r => r | none => 2.0
          if cur < prev - 1e-12 then viol := viol + 1
          prev := cur
  IO.println s!"MONO sequences={seqs} violations={viol}"
  -- Bound the all-schedule rate from both sides on the headline 1 percentage-point grid.
  let head : CP := { psi := 0.5, phi := 2.0, budget := 1035.0 }
  let incumbent := head.baseline
  for t in [0, 3, 6, 8, 10, 11, 12, 13, 14, 15, 16] do
    let s := incumbent[t]!
    let excluded := scan.reverse.find? fun r => !({ head with gmax := r } : CP).certViable s
    IO.println s!"RATE year={2027 + t} maxExcluded={pct excluded} minWitness={pct (head.rmin s)}"
  -- E-II.5: carbon budget vs net-zero deadline
  IO.println "E-II.5 constraint ablation (2.0C, gmax 0.3, L 2)"
  for (tc, sc) in [("central", 1.0), ("robust", 0.45 / 0.63)] do
    for psi in [0.5, 0.75, 1.0] do
      for phi in [1.5, 2.0, 3.0] do
        let pb : CP := { psi, phi, budget := 1035.0 * sc }
        let pn : CP := { pb with requireNZ := false }
        let bb := pb.baseline
        let bn := pn.baseline
        let ta := pb.pnr 2 bb
        let k := ta + 1
        let reason : Nat :=
          if k ≥ 0 && k.toNat < bb.size then
            (if bb[k.toNat]!.C > pb.budget + 1e-9 then 1 else pb.certReason bb[k.toNat]!)
          else 0
        IO.println s!"ABL {tc} psi={psi} phi={phi} both={yr ta}/{yr (pb.pnrCert bb)}/{yr (pb.pnr 3 bb)} budgetonly={yr (pn.pnr 2 bn)}/{yr (pn.pnrCert bn)}/{yr (pn.pnr 3 bn)} reason={reason}"
  -- myopic carbon-price thresholds with and without the net-zero condition
  for psi in [0.5, 0.75, 1.0] do
    for nz in [true, false] do
      let mut thr : Option Float := none
      for pi in [0.0, 25.0, 50.0, 75.0, 100.0, 125.0, 150.0, 175.0, 200.0, 250.0, 300.0] do
        let p : CP := { psi, phi := 2.0, budget := 1035.0, requireNZ := nz }
        let (b, _) := p.hist true pi
        if thr.isNone && p.pnr 2 b ≥ p.T then thr := some pi
      IO.println s!"THR psi={psi} requireNZ={nz} threshold={match thr with | some x => toString x | none => "none"}"
