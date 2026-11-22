import Paradox.ConcessionModel

/-! Argument V: structural concessions and calm-period erosion. Prints the same text as
`python/toy/argV.py` (results/argV_output.txt). -/

open Paradox.ConcessionModel

def padL (s : String) (n : Nat) : String := String.mk (List.replicate (n - s.length) ' ') ++ s
def padR (s : String) (n : Nat) : String := s ++ String.mk (List.replicate (n - s.length) ' ')

def sweepA : IO Unit := do
  IO.println "Sweep A: structural concessions"
  IO.println s!"  clean fix: cost {cFix}, output {outFix}, {deadFix} dead tick per forced switch; concession: cost {cConc}, output {outConc}, {deadConc} dead ticks; upkeep {U}; reserves capped at {RMAX}"
  IO.println "  forced switches at ticks P, 2P, ...; starting reserves r0 = 1..10, horizons T = 4..24"
  IO.println "  crossover T*: largest horizon at which the concession is viable (all = through 24, none = not even 4)"
  IO.println ("CROSSOVER r0 \\ P " ++ " ".intercalate (ps.map fun P => padL (toString P) 4))
  for r0 in r0s do
    IO.println (s!"CROSSOVER r0={padR (toString r0) 2}   " ++ " ".intercalate (ps.map fun P => padL (crossover r0 P) 4))
  let mut concOnly := 0
  let mut both := 0
  let mut cleanOnly := 0
  let mut neither := 0
  for r0 in r0s do
    for P in ps do
      for T in ts do
        let c := viable r0 P T true
        let f := viable r0 P T false
        if c && f then both := both + 1
        else if c then concOnly := concOnly + 1
        else if f then cleanOnly := cleanOnly + 1
        else neither := neither + 1
  IO.println s!"REGIMES concession only {concOnly}, both {both}, clean only {cleanOnly}, neither {neither} (of {concOnly + both + cleanOnly + neither} cells)"
  let mut bothCells := 0
  let mut scarCells := 0
  for r0 in r0s do
    for P in ps do
      match scarWindow r0 P with
      | none => pure ()
      | some w =>
        bothCells := bothCells + 1
        if !w.isEmpty then
          scarCells := scarCells + 1
          IO.println s!"SCAR r0={r0} P={P}: {w.length} ticks {w}"
  IO.println s!"SCAR summary: {scarCells} of {bothCells} (r0, P) cells where both survive to 24 have a nonempty scar window"

def sweepB : IO Unit := do
  IO.println "Sweep B: calm-period erosion"
  IO.println s!"  shocks need reserves >= {mReq} and remove {mReq}; {nShocks} shocks, each after L calm ticks; a calm tick earns {income}; reserves start at {mMax}"
  IO.println s!"  myopic floor 0; static floor {mMax}; adaptive floor resets to {mMax} after a shock, drops by 1 every k calm ticks"
  IO.println "  survival by calm interval L = 1..25 (S = survives all shocks, x = fails):"
  let row (ctrl k : Nat) : String := String.mk (ls.map fun L => if (runB ctrl k L).1 then 'S' else 'x')
  IO.println s!"SURVIVAL myopic       {row 0 1}"
  IO.println s!"SURVIVAL static       {row 1 1}"
  for k in ks do
    IO.println s!"SURVIVAL adaptive k={k} {row 2 k}"
  for k in ks do
    let surv := ls.filter fun L => (runB 2 k L).1
    let failAfter := ls.filter fun L => !(runB 2 k L).1 && (runB 1 k L).1
    let lo := match surv.head? with | some x => toString x | none => "-"
    let hi := match surv.getLast? with | some x => toString x | none => "-"
    let lstar := match failAfter.head? with | some x => toString x | none => "none"
    IO.println s!"THRESHOLD k={k}: adaptive survives L in {lo}..{hi}; L*={lstar}; theorem bound k*(mMax-mReq+1)={k * (mMax - mReq + 1)}"
  for k in [2, 4] do
    IO.println s!"OUTPUT k={k} (myopic/static/adaptive cumulative output; * = adaptive fails):"
    for L in [2, 4, 6, 8, 10, 12, 16, 24] do
      let m := runB 0 k L
      let s := runB 1 k L
      let a := runB 2 k L
      IO.println s!"OUTPUT k={k} L={L}: {m.2}/{s.2}/{a.2}{if a.1 then "" else "*"}"

def main : IO Unit := do
  IO.println "Argument V: structural concessions and calm-period erosion"
  sweepA
  sweepB
