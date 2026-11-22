import Paradox.ConcessionModel

/-! Argument V: structural concessions and calm-period erosion in the four control classes of I.3.
Prints the same text as `python/toy/argV.py` (results/argV_output.txt). -/

open Paradox.ConcessionModel

def padL (s : String) (n : Nat) : String := String.mk (List.replicate (n - s.length) ' ') ++ s
def padR (s : String) (n : Nat) : String := s ++ String.mk (List.replicate (n - s.length) ' ')

@[noinline] def kernelsA (r₀ P T : Nat) : List Bool × List Bool :=
  (classes.map fun k => kernelA ⟨P, none⟩ k T 0 (preA r₀),
   classes.map fun k => kernelA ⟨P, none⟩ k T 1 (postConc r₀))

def sweepA : IO Unit := do
  IO.println "Sweep A: structural concessions"
  IO.println s!"  state (x, O, pi, q): reserves; scarred; policy aligned; obligation pending, implementation move in flight; clean fix cost {C_FIX}, output {OUT_FIX}; concession cost {C_CONC}, output {OUT_CONC} and a latency-1 implementation move per realignment; upkeep {U}; reserves capped at {RMAX}"
  IO.println "  forced switches at operating ticks P, 2P, ...; starting reserves r0 = 1..10, horizons T = 4..24"
  IO.println "  crossover T*: largest horizon at which the post-concession state is in the policy kernel (all = through 24, none = not even 4)"
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
        let c := concOk r0 P T
        let f := cleanOk r0 P T
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
  let mut checks := 0
  let mut viol := 0
  let mut sevPre : Array Nat := mkArray 5 0
  let mut sevPost : Array Nat := mkArray 5 0
  let mut rows : Array String := #[]
  for r0 in r0s do
    for P in ps do
      let mut digits := ""
      for T in ts do
        let (kp, kc) := kernelsA r0 P T
        for ks in [kp, kc] do
          for i in [0:3] do
            checks := checks + 1
            if ks[i]! && !ks[i + 1]! then viol := viol + 1
        sevPre := sevPre.modify (sev kp) (· + 1)
        sevPost := sevPost.modify (sev kc) (· + 1)
        digits := digits ++ toString (sev kc)
      rows := rows.push s!"SHIFT r0={padR (toString r0) 2} P={P}: {digits}"
  IO.println s!"NESTING fixed <= policy <= adapt <= phys at the decision state and the post-concession state, every (r0, P, T): {checks} checks, {viol} violations"
  let fmt (a : Array Nat) : String :=
    ", ".intercalate ((List.range 5).map fun i => s!"sigma {i}: {a[i]!}")
  IO.println s!"SEVERITY decision state (obligation pending): {fmt sevPre} (of {sevPre.foldl (· + ·) 0})"
  IO.println s!"SEVERITY post-concession state: {fmt sevPost} (of {sevPost.foldl (· + ·) 0})"
  IO.println "SHIFT post-concession severity by horizon T = 4..24 (one digit per T):"
  for r in rows do IO.println r

def sweepB : IO Unit := do
  IO.println "Sweep B: calm-period erosion"
  IO.println s!"  shocks need reserves >= {M_REQ} and remove {M_REQ}; {N_SHOCKS} shocks, each after L calm ticks; a calm tick earns {INCOME}; reserves start at {M_MAX}"
  IO.println s!"  fixed class: the adaptive shield (floor resets to {M_MAX} after a shock, drops by 1 every k calm ticks); policy class: any amount kept; myopic (floor 0) and static (floor {M_MAX}) are policy-class rules"
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
    IO.println s!"THRESHOLD k={k}: adaptive survives L in {lo}..{hi}; L*={lstar}; theorem bound k*(mMax-mReq+1)={k * (M_MAX - M_REQ + 1)}"
  for k in [2, 4] do
    IO.println s!"OUTPUT k={k} (myopic/static/adaptive cumulative output; * = adaptive fails):"
    for L in [2, 4, 6, 8, 10, 12, 16, 24] do
      let m := runB 0 k L
      let s := runB 1 k L
      let a := runB 2 k L
      IO.println s!"OUTPUT k={k} L={L}: {m.2}/{s.2}/{a.2}{if a.1 then "" else "*"}"
  let start : BSt := ⟨true, M_MAX, M_MAX, 0⟩
  let mut checks := 0
  let mut viol := 0
  for k in ks do
    let mut digits := ""
    for L in ls do
      let kk := classes.map fun c => kernelB c k L 0 start
      for i in [0:3] do
        checks := checks + 1
        if kk[i]! && !kk[i + 1]! then viol := viol + 1
      digits := digits ++ toString (sev kk)
    IO.println s!"SEVERITY k={k} at the start, by L = 1..25: {digits}"
  IO.println s!"NESTING fixed <= policy <= adapt <= phys at the start, every (k, L): {checks} checks, {viol} violations"
  for (k, L) in [(4, 12), (2, 6)] do
    let path := pathB k L
    let sevs := (List.range path.length).map fun t =>
      let s := path[t]!
      if !s.up then 4 else sev (classes.map fun c => kernelB c k L t s)
    let inA := (List.range path.length).filter fun t => path[t]!.up && kernelB .adapt k L t path[t]!
    let tstar : Int := match inA.getLast? with | some x => x | none => -1
    let mus : List Int := (List.range path.length).map fun (t : Nat) =>
      if decide ((t : Int) ≤ tstar) then tstar - (t : Int) else (-1 : Int)
    let groups := (List.range ((sevs.length + L) / (L + 1))).map fun g =>
      String.join ((sevs.drop (g * (L + 1))).take (L + 1) |>.map toString)
    IO.println s!"MIGRATION k={k} L={L}, the shield's severity by tick (one group per round of L calm ticks and a shock): {"|".intercalate groups}"
    IO.println s!"MIGRATION k={k} L={L}: t*_adapt = {tstar}; margin mu by tick: {" ".intercalate (mus.map toString)}"

def main : IO Unit := do
  IO.println "Argument V: structural concessions and calm-period erosion, in the four control classes of I.3"
  sweepA
  sweepB
