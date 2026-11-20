import Paradox.Kernel

/-! Argument III demonstrations.

III.A  Restoration independence: bootstrap closure on a capability-dependency graph
       (redundancy versus independent recoverability; minimum seed set).
III.B  The bounds gap on the I.3.10 model: budget-limited witness search against a physical
       certificate and an organizational relaxation, scored against the exact kernels. -/

open Paradox

/-! ### III.A -/

abbrev Graph := List (String × List (List String))

def closure (g : Graph) (seeds : List String) : List String := Id.run do
  let mut up := seeds
  for _ in [0:g.length + 1] do
    for (c, alts) in g do
      if !up.contains c && alts.any (fun alt => alt.all up.contains) then up := up ++ [c]
  return up

def grid : Graph :=
  [("gen1", [["control", "fuel"]]), ("gen2", [["control", "fuel"]]),
   ("control", [["power", "telecom"]]), ("telecom", [["power"]]),
   ("fuel", [["power"]]), ("power", [["gen1"], ["gen2"]])]

def addAlts (g : Graph) (extra : List (String × List (List String))) : Graph :=
  let g' := g.map fun (c, alts) => (c, alts ++ ((extra.filter (·.1 == c)).map (·.2)).foldl (· ++ ·) [])
  g' ++ (extra.filter fun (c, _) => !(g.any (·.1 == c)))

def sortStr (l : List String) : List String := (l.toArray.qsort (· < ·)).toList

def andGraph : List (String × List String) :=
  [("gen1", ["control", "fuel"]), ("gen2", ["control", "fuel"]), ("control", ["power", "telecom"]),
   ("telecom", ["power"]), ("fuel", ["power"]), ("power", ["gen1"])]

def minSeeds : Nat × List (List String) := Id.run do
  let nodes := sortStr (andGraph.map (·.1))
  let g : Graph := andGraph.map fun (c, pre) => (c, [pre])
  let n := nodes.length
  for size in [0:n + 1] do
    let mut hits : List (List String) := []
    for mask in [0:2 ^ n] do
      let chosen := (List.range n).filter (fun i => (mask >>> i) % 2 == 1) |>.map (nodes[·]!)
      if chosen.length == size then
        let up := closure g chosen
        if nodes.all up.contains then hits := hits ++ [sortStr chosen]
    if !hits.isEmpty then return (size, hits)
  return (0, [])

/-! ### III.B -/

def lcgNext (x : UInt64) : UInt64 := (1664525 * x + 1013904223) % 4294967296

def relaxActions (p : Params) (s : St) : List Act := Id.run do
  let mut out := []
  for f in [0:p.N + 1] do
    for m in [0:p.N + 1 - f] do
      if !(m > 0 && !s.farm) then
        for r in [0:p.N + 1] do
          if !(r > 0 && s.farm) then
            for sp in (if s.spec then [false] else [false, true]) do
              out := out ++ [⟨f, m, r, sp⟩]
  return out

def relaxTable (p : Params) : Array (Array Bool) := Id.run do
  let size := p.stateCount
  let mut tabs : Array (Array Bool) := mkArray (p.T + 1) (mkArray size true)
  for k in [0:p.T] do
    let t := p.T - 1 - k
    let next := tabs[t + 1]!
    let mut cur := mkArray size false
    for i in [0:size] do
      let s := p.decode t i
      let ok := p.valid s && (relaxActions p s).any fun a =>
        match p.step false s a with
        | none => false
        | some n => next[p.encode n]!
      cur := cur.set! i ok
    tabs := tabs.set! t cur
  return tabs

/-- Budget-limited random search for an adapt-class witness. Returns (found, rng state). -/
def rolloutWitness (K : Kernels) (s : St) (budget : Nat) (rng0 : UInt64) : Bool × UInt64 := Id.run do
  let p := K.p
  let mut rng := rng0
  for _ in [0:budget] do
    let mut cur := s
    let mut ok := true
    for _ in [0:p.T - s.t] do
      let acts := p.actions .adapt cur
      rng := lcgNext rng
      let a := acts[(rng % acts.length.toUInt64).toNat]!
      match p.step false cur a with
      | none => ok := false; break
      | some n => cur := n
    if ok then return (true, rng)
  return (false, rng)

def gapRun (K : Kernels) (rt : Array (Array Bool)) (budget : Nat) (certRelax : Bool) : String := Id.run do
  let p := K.p
  let mut rng : UInt64 := 12345
  let mut wit := 0
  let mut exc := 0
  let mut unk := 0
  let mut bySig := mkArray 5 0
  let mut wrong := 0
  for s in p.allStates do
    let truth := K.viable .adapt s
    let relaxOk := if s.t ≥ p.T then true else rt[s.t]![p.encode s]!
    let excluded := if certRelax then !relaxOk else !(K.viable .phys s)
    if excluded then
      exc := exc + 1
      if truth then wrong := wrong + 1
    else
      let (found, r2) := rolloutWitness K s budget rng
      rng := r2
      if found then
        wit := wit + 1
        if !truth then wrong := wrong + 1
      else
        unk := unk + 1
        let sg := K.severity s
        bySig := bySig.set! sg (bySig[sg]! + 1)
  return s!"witness {wit} excluded {exc} unknown {unk} unknown-by-sigma {bySig.toList} wrong {wrong}"

def main : IO Unit := do
  let scen : List (String × Graph × List String) :=
    [("total blackout, no black-start", grid, []),
     ("add a third generator (more redundancy)", addAlts grid [("gen3", [["control", "fuel"]]), ("power", [["gen3"]])], []),
     ("battery-backed telecom (seed)", addAlts grid [("telecom_batt", [])], ["telecom_batt"]),
     ("battery telecom feeds telecom", addAlts grid [("telecom", [["telecom_batt"]]), ("telecom_batt", [])], ["telecom_batt"]),
     ("black-start hydro unit (seed)", addAlts grid [("power", [["hydro_bs"]]), ("hydro_bs", [])], ["hydro_bs"])]
  for (name, g, seeds) in scen do
    let up := closure g seeds
    IO.println s!"III.A {name}: restored {up.length}/{g.length}: {sortStr up}"
  let (sz, opts) := minSeeds
  IO.println s!"III.A minimum seed set (pure AND graph): size {sz}; options {opts}"
  let K := Kernels.build Params.base
  let rt := relaxTable K.p
  for certRelax in [false, true] do
    for budget in [1, 10, 100, 1000] do
      IO.println s!"III.B cert={if certRelax then "relax" else "phys"} budget={budget}: {gapRun K rt budget certRelax}"
