import Paradox.Climate

/-! Climate experiments: rate window / points of no return (Argument II) and the paradox
(Argument I). `climate` runs the sweeps; `climate --check` prints values for cross-checking. -/

open Paradox.Climate

def yr (t : Int) : String := if t < 0 then "never" else toString (2027 + t)
def fmt (x : Float) : String :=
  let r := (x * 100).round / 100
  toString r

def targets : List (String × Float) := [("1.7C", 510.0), ("2.0C", 1035.0)]
def tcres : List (String × Float) := [("central", 1.0), ("robust", 0.45 / 0.63)]

structure WRow where
  psi : Float
  phi : Float
  gmax : Float
  L : Nat
  target : String
  tcre : String
  sev2027 : Nat
  tPolicy : Int
  tAdapt : Int
  tPhys : Int
  tCert : Int
  rmin2027 : Option Float
  rmin2030 : Option Float
  rmin2035 : Option Float

def windowRow (psi phi gmax : Float) (L : Nat) (tg : String × Float) (tc : String × Float) : WRow :=
  let p : CP := { psi, phi, gmax, L, budget := tg.2 * tc.2 }
  let b := p.baseline
  let rm (i : Nat) := if h : i < b.size then
      (if b[i].C > p.budget + 1e-9 then none else p.rmin b[i]) else none
  { psi, phi, gmax, L, target := tg.1, tcre := tc.1, sev2027 := p.severity b[0]!,
    tPolicy := p.pnr 1 b, tAdapt := p.pnr 2 b, tPhys := p.pnr 3 b, tCert := p.pnrCert b,
    rmin2027 := rm 0, rmin2030 := rm 3, rmin2035 := rm 8 }

def optF : Option Float → String
  | some r => s!"{(r * 100).round.toUInt64}%"
  | none => "none"

structure PRow where
  psi : Float
  phi : Float
  target : String
  tcre : String
  pi : Float
  jA : Float
  jB : Float
  tA : Int
  tB : Int
  aViable : Bool
  sevB2040 : Nat
  sevA2040 : Nat
  jApnr : Float      -- J over 2027 .. myopic point of no return
  jBpnr : Float
  aheadEachYear : Bool
  tAcert : Int
  tBcert : Int

def paradoxRow (psi phi : Float) (tg tc : String × Float) (pi : Float) (H : Nat := 14) : PRow :=
  let p : CP := { psi, phi, budget := tg.2 * tc.2 }
  let (a, xa) := p.hist false
  let (b, xb) := p.hist true pi
  let sev (tr : Array CS) := if tr[13]!.C > p.budget + 1e-9 then 4 else p.severity tr[13]!
  let tB := p.pnr 2 b
  let hp : Nat := if tB ≥ 0 && tB < p.T then (tB + 1).toNat else 0
  { psi, phi, target := tg.1, tcre := tc.1, pi, jA := p.jValue a xa H, jB := p.jValue b xb H,
    tA := p.pnr 2 a, tB,
    aViable := p.run p.s0 (p.grow p.gmax 1.0 p.phi) true 1.0 p.phi,
    sevB2040 := sev b, sevA2040 := sev a,
    jApnr := p.jValue a xa hp, jBpnr := p.jValue b xb hp,
    aheadEachYear := (List.range hp).all fun i => p.jValue b xb (i+1) ≥ p.jValue a xa (i+1),
    tAcert := p.pnrCert a, tBcert := p.pnrCert b }

def b2s (b : Bool) : String := if b then "1" else "0"

def main (args : List String) : IO Unit := do
  if args == ["--check"] then
    -- values for exact cross-checking against climate.py
    for psi in [0.5, 1.0] do
      for tg in targets do
        for tc in tcres do
          let p : CP := { psi, budget := tg.2 * tc.2 }
          let b := p.baseline
          let sevs := (b.toList.take 20).map p.severity
          IO.println s!"CHECK psi={psi} {tg.1} {tc.1} sev={sevs} tpol={p.pnr 1 b} tadapt={p.pnr 2 b} tphys={p.pnr 3 b} f10={b[10]!.f} C10={b[10]!.C}"
          for pi in [0.0, 50.0, 100.0] do
            let r := paradoxRow psi 2.0 tg tc pi
            IO.println s!"PARADOX psi={psi} {tg.1} {tc.1} pi={pi} jA={r.jA} jB={r.jB} tA={r.tA} tB={r.tB} jApnr={r.jApnr} jBpnr={r.jBpnr}"
    return

  -- Sweep 1: rate window and points of no return
  let mut cfgs := #[]
  for psi in [0.5, 0.75, 1.0] do
    for phi in [1.5, 2.0, 3.0] do
      for gmax in [0.2, 0.3, 0.4] do
        for L in [1, 2, 3] do
          for tg in targets do
            for tc in tcres do
              cfgs := cfgs.push (psi, phi, gmax, L, tg, tc)
  let half := cfgs.size / 2
  let t1 := Task.spawn (prio := .dedicated) fun _ =>
    (cfgs.extract 0 half).map fun (a, b, c, d, e, f) => windowRow a b c d e f
  let t2 := Task.spawn (prio := .dedicated) fun _ =>
    (cfgs.extract half cfgs.size).map fun (a, b, c, d, e, f) => windowRow a b c d e f
  let rows := t1.get ++ t2.get
  let hdr := "psi,phi,gmax,L,target,tcre,sigma2027,tPolicy,tAdapt,tAdaptCertificate,exact_all_schedules,tCapacityUnconstrained,lockYears,rmin2027,rmin2030,rmin2035"
  let lines := rows.toList.map fun r =>
    s!"{r.psi},{r.phi},{r.gmax},{r.L},{r.target},{r.tcre},{r.sev2027},{yr r.tPolicy},{yr r.tAdapt},{yr r.tCert},{b2s (r.tCert == r.tAdapt)},{yr r.tPhys},{if r.tPhys ≥ (0 : Int) then toString (r.tPhys - max r.tAdapt (-1 : Int)) else "na"},{optF r.rmin2027},{optF r.rmin2030},{optF r.rmin2035}"
  IO.FS.writeFile "climate_window.csv" ("\n".intercalate (hdr :: lines) ++ "\n")
  IO.println s!"Sweep 1 (rate window / points of no return): {rows.size} configurations -> climate_window.csv"
  let ex := (rows.filter fun r => r.tCert == r.tAdapt).size
  IO.println s!"Capacity-building point of no return exact over all schedules (certificate = constant-rate) in {ex} of {rows.size}"

  -- headline table: L = 2, gmax = 0.3
  IO.println "\nHeadline (capacity latency 2 yr, max scale-up 30%/yr): last start year that still works"
  IO.println "  cost psi  spend phi  target  TCRE     sigma(2027)  policy-only  build capacity  capacity-unconstrained  lock-in yrs  r_min(2027)"
  for r in rows do
    if r.L == 2 && r.gmax == 0.3 then
      IO.println s!"  {r.psi}       {r.phi}        {r.target}    {r.tcre}  {r.sev2027}            {yr r.tPolicy}        {yr r.tAdapt}            {yr r.tPhys}      {if r.tPhys ≥ (0 : Int) then toString (r.tPhys - max r.tAdapt (-1 : Int)) else "-"}            {optF r.rmin2027}"

  -- Sweep 2: paradox
  let mut pc := #[]
  for psi in [0.5, 0.75, 1.0] do
    for phi in [1.5, 2.0, 3.0] do
      for tg in targets do
        for tc in tcres do
          for pi in [0.0, 25.0, 50.0, 75.0, 100.0, 150.0, 200.0, 300.0] do
            pc := pc.push (psi, phi, tg, tc, pi)
  let h2 := pc.size / 2
  let u1 := Task.spawn (prio := .dedicated) fun _ =>
    (pc.extract 0 h2).map fun (a, b, c, d, e) => paradoxRow a b c d e
  let u2 := Task.spawn (prio := .dedicated) fun _ =>
    (pc.extract h2 pc.size).map fun (a, b, c, d, e) => paradoxRow a b c d e
  let prow := u1.get ++ u2.get
  let lost (r : PRow) := r.aViable && r.tB < r.tA && r.tB ≥ 0
  let ahead (r : PRow) := r.aheadEachYear
  let ph := "psi,phi,target,tcre,carbon_price,J_builder_2027_2040,J_myopic_2027_2040,tAdapt_builder,tAdapt_myopic,cert_builder,cert_myopic,builder_viable,myopic_loses_window,J_builder_to_myopic_pnr,J_myopic_to_myopic_pnr,myopic_ahead_until_pnr,sigma2040_builder,sigma2040_myopic"
  let pl := prow.toList.map fun r =>
    s!"{r.psi},{r.phi},{r.target},{r.tcre},{r.pi},{fmt r.jA},{fmt r.jB},{yr r.tA},{yr r.tB},{yr r.tAcert},{yr r.tBcert},{b2s r.aViable},{b2s (lost r)},{fmt r.jApnr},{fmt r.jBpnr},{b2s (lost r && ahead r)},{r.sevA2040},{r.sevB2040}"
  IO.FS.writeFile "climate_paradox.csv" ("\n".intercalate (ph :: pl) ++ "\n")
  IO.println s!"\nSweep 2 (paradox): {prow.size} configurations -> climate_paradox.csv"
  IO.println "\nParadox at 2.0C, spend phi = 2. J = consumption proxy ($T) from 2027 up to the myopic point of no return"
  IO.println "  cost psi  TCRE     carbon $/t  builder window  myopic window  J builder  J myopic  myopic ahead until its window closes"
  for r in prow do
    if r.target == "2.0C" && r.phi == 2.0 && r.aViable then
      IO.println s!"  {r.psi}  {r.tcre}  {r.pi}     {yr r.tA}            {yr r.tB}           {if lost r then fmt r.jApnr else "-"}      {if lost r then fmt r.jBpnr else "-"}     {if lost r then b2s (ahead r) else "window never lost"}"
  let nl := (prow.filter lost).size
  let na := (prow.filter fun r => lost r && ahead r).size
  let nv := (prow.filter (·.aViable)).size
  IO.println s!"\nBuilder path viable in {nv} of {prow.size} configurations; myopic path loses the window in {nl} of them;"
  IO.println s!"in {na} of those {nl}, the price-cutoff rule's cumulative consumption score equals or exceeds the builder's at every annual prefix through its last viable start"
