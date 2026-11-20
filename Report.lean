import Paradox.Kernel

/-! Demonstration states, verified witnesses, exhaustive exclusions, the paradox pair, and the
Proposition 4 checks for the base model of Section I.3.10. -/

open Paradox

def sevName : Nat → String
  | 0 => "viable as-is" | 1 => "operational mismatch" | 2 => "recoverable org. mismatch"
  | 3 => "structural lock-in" | _ => "physical nonviability"

def fmtAct (a : Act) : String :=
  let parts := (if a.f > 0 then [s!"{a.f} forage"] else []) ++
    (if a.m > 0 then [s!"{a.m} farm"] else []) ++
    (if a.r > 0 then [s!"{a.r} train"] else []) ++ (if a.sp then ["specialize"] else [])
  if parts.isEmpty then "idle" else ", ".intercalate parts

def describe (s : St) : String :=
  s!"t={s.t}, F={s.F}, P={s.P}, farm={if s.farm then "yes" else "no"}, " ++
    (if s.spec then "specialists" else "generalists")

def pad2 (n : Nat) : String := if n < 10 then s!" {n}" else s!"{n}"

def examples : List (Nat × St) :=
  [(0, ⟨11, 16, 0, false, false, 0⟩), (1, ⟨11, 9, 0, true, false, 0⟩),
   (2, ⟨11, 9, 0, false, false, 0⟩), (3, ⟨11, 9, 0, false, true, 0⟩),
   (4, ⟨11, 2, 0, false, false, 0⟩)]

def main : IO UInt32 := do
  let K := Kernels.build Params.base
  let p := K.p
  let counts := K.severityCounts
  IO.println s!"States enumerated: {p.allStates.size}; nesting violations: {K.nestingViolations}; severity counts: {counts.toList}\n"
  let mut ok := true
  for (sig, s) in examples do
    let got := K.severity s
    if got != sig then
      IO.println s!"MISMATCH: expected {sig}, got {got} for {describe s}"; ok := false
    IO.println s!"sigma={sig} ({sevName sig}): {describe s}"
    if sig < 4 then
      let c := Cls.all[sig]!
      match K.witness c s with
      | none => IO.println "  NO WITNESS"; ok := false
      | some w =>
        let v := K.verify c s w
        if !v then ok := false
        IO.println s!"  witness in K_{c.name} ({if v then "verified" else "FAILED VERIFICATION"}):"
        for (st, a) in w do
          IO.println s!"    t={pad2 st.t} F={pad2 st.F} P={st.P}  ->  {fmtAct a}"
    let excl := Cls.all.take sig
    if !excl.isEmpty then
      IO.println s!"  excluded by exhaustive enumeration: {", ".intercalate (excl.map (fun c => "K_" ++ c.name))}"
    IO.println ""

  IO.println "Paradox pair: common s0 = (t=0, F=0, P=0, no farm, generalists)."
  IO.println "History B specializes at t=0 (takes effect from t=1); both then run the incumbent."
  let s0 : St := ⟨0, 0, 0, false, false, 0⟩
  for (name, sp) in [("A generalist", false), ("B specialize at t=0", true)] do
    let traj := K.history s0 sp
    -- gross harvest and discarded food along the trajectory
    let mut gross := 0
    let mut discarded := 0
    for i in [0:traj.size - 1] do
      let s := traj[i]!
      let y := p.wildAt s.t
      let out := p.N * (y + (if s.spec && y > 0 then p.specBonus else 0))
      gross := gross + out
      discarded := discarded + (s.F + out + s.P - p.N - traj[i + 1]!.F)
    let tp := K.pointOfNoReturn .policy traj
    let ta := K.pointOfNoReturn .adapt traj
    let tph := K.pointOfNoReturn .phys traj
    let tf := match K.tFail traj with | some t => toString t | none => "None"
    IO.println s!"  {name}: stock {(traj.map (·.F)).toList}"
    IO.println s!"    severity {(traj.map K.severity).toList}"
    IO.println s!"    gross harvest {gross}, discarded at cap {discarded}, useful {gross - discarded}; t*_policy={tp}, t*_adapt={ta}, t*_phys={tph}, t_fail={tf}, Delta_lock={tph - ta}"

  IO.println ""
  let (checked, viol) := K.resourceMonotoneCheck
  IO.println s!"Proposition 4 check (same (O,q), richer (F,P)): {checked} pairs, {viol} violations"
  let (pairs, same) := K.fingerprintCheck
  IO.println s!"Fingerprint check: {pairs} strong-paradox state pairs, {same} sharing (O,q)"
  return (if ok then 0 else 1)
