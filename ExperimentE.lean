import Paradox.Kernel
import Paradox.Decision

/-!
# Experiment E — prevalence of the paradox within the model family

For every parameter setting in a grid, compare two histories from the common initial state
`s0 = (t=0, F=0, P=0, no farm, generalists)`:

* **A** stays generalist; **B** specializes at `t = 0`. Both then run the incumbent policy.

Recorded per setting:

* `stockDom`  — B's stored food is at least A's on their common path and strictly more at some
                tick; B survives at least as long as A
* `earlier`   — B's reorganization window closes strictly earlier: `t*_adapt(B) < t*_adapt(A)`
* `paradox`   — legacy CSV field for the prescribed-path tradeoff `stockDom ∧ earlier`
* `grossOnly` — `earlier` and B's gross harvest is higher, but B does not dominate in storage
* `strong`    — at some common tick B holds at least as much food, B is locked in (σ = 3),
                and A can still reorganize (σ ≤ 2)

Two decision rules choose from every adapt-class action. Each maximizes food stored over
the next two ticks, with ties resolved in favor of foraging or training. For each rule we
record the first tick at severity 3 (−1 if absent), survival to T, and whether it makes a
strong pair with prescribed generalist A at a common tick.
-/

open Paradox

structure Row where
  rSpec : Nat
  bonus : Nat
  fmax : Nat
  T : Nat
  on : Nat
  mid : Nat
  tA : Int
  tB : Int
  physA : Int
  physB : Int
  usefulA : Nat
  usefulB : Nat
  grossA : Nat
  grossB : Nat
  stockDom : Bool
  earlier : Bool
  paradox : Bool
  grossOnly : Bool
  strong : Bool
  forageFirstLock : Int
  trainFirstLock : Int
  forageSurvives : Bool
  trainSurvives : Bool
  forageStrongVsA : Bool
  trainStrongVsA : Bool

def harvest (K : Kernels) (traj : Array St) : Nat × Nat := Id.run do
  let p := K.p
  let mut gross := 0
  let mut useful := 0
  for i in [0:traj.size - 1] do
    let s := traj[i]!
    let y := p.wildAt s.t
    let out := p.N * (y + (if s.spec && y > 0 then p.specBonus else 0))
    gross := gross + out
    useful := useful + out - (s.F + out + s.P - p.N - traj[i + 1]!.F)
  return (gross, useful)

def strongVsGeneralist (K : Kernels) (A path : Array St) : Bool :=
  (List.range (min A.size path.size)).any fun i =>
    let a := A[i]!
    let b := path[i]!
    b.F ≥ a.F && b.P ≥ a.P && K.severity b == 3 && K.severity a ≤ 2

def firstLock (K : Kernels) (path : Array St) : Int :=
  match path.find? (fun s => K.severity s == 3) with
  | some s => s.t
  | none => -1

def evalParams (rSpec bonus fmax T on mid : Nat) : Row :=
  let wild := (List.replicate on 2 ++ List.replicate mid 1 ++ List.replicate (T - on - mid) 0).toArray
  let p : Params := { fmax, T, specBonus := bonus, rGen := 2, rSpec, wild }
  let K := Kernels.build p
  let s0 : St := ⟨0, 0, 0, false, false, 0⟩
  let A := K.history s0 false
  let B := K.history s0 true
  let n := min A.size B.size
  let idx := List.range n
  let geAll := idx.all fun i => B[i]!.F ≥ A[i]!.F
  let gtSome := idx.any fun i => B[i]!.F > A[i]!.F
  let stockDom := geAll && gtSome && B.size ≥ A.size
  let tA := K.pointOfNoReturn .adapt A
  let tB := K.pointOfNoReturn .adapt B
  let earlier := decide (tB < tA)
  let (gA, uA) := harvest K A
  let (gB, uB) := harvest K B
  let forage := p.stockHistory .forage s0
  let train := p.stockHistory .train s0
  { rSpec, bonus, fmax, T, on, mid, tA, tB,
    physA := K.pointOfNoReturn .phys A, physB := K.pointOfNoReturn .phys B,
    usefulA := uA, usefulB := uB, grossA := gA, grossB := gB,
    stockDom, earlier, paradox := stockDom && earlier,
    grossOnly := earlier && !stockDom && gB > gA, strong := strongVsGeneralist K A B,
    forageFirstLock := firstLock K forage, trainFirstLock := firstLock K train,
    forageSurvives := forage.back!.t == T, trainSurvives := train.back!.t == T,
    forageStrongVsA := strongVsGeneralist K A forage, trainStrongVsA := strongVsGeneralist K A train }

def grid : List (Nat × Nat × Nat × Nat × Nat × Nat) := Id.run do
  let mut out := []
  for rSpec in [1:11] do
    for bonus in [1, 2] do
      for fmax in [12, 16, 20, 24, 30] do
        for T in [12, 14, 16, 18, 20] do
          for on in [3:7] do
            for mid in [0:3] do
              out := (rSpec, bonus, fmax, T, on, mid) :: out
  return out.reverse

def pct (a b : Nat) : String :=
  if b == 0 then "  n/a" else
    let x := (a * 1000 + b / 2) / b
    let s := s!"{x / 10}.{x % 10}%"
    String.mk (List.replicate (7 - s.length) ' ') ++ s

def summarize (title : String) (rows : Array Row) (key : Row → Nat) (keys : List Nat) : IO Unit := do
  IO.println s!"\n{title}"
  IO.println "  value   settings   pairwise tradeoff   strong pair   gross-only"
  for k in keys do
    let rs := rows.filter (key · == k)
    let np := (rs.filter (·.paradox)).size
    let ns := (rs.filter (·.strong)).size
    let ng := (rs.filter (·.grossOnly)).size
    IO.println s!"  {k}\t  {rs.size}\t     {pct np rs.size}\t       {pct ns rs.size}\t   {pct ng rs.size}"

def b2s (b : Bool) : String := if b then "1" else "0"

def main (args : List String) : IO Unit := do
  let g := match args with
    | [n] => grid.take n.toNat!
    | _ => grid
  -- evaluate in parallel chunks
  let sz := (g.length + 7) / 8
  let chunks := (List.range 8).map fun k => (g.drop (k * sz)).take sz
  let tasks := chunks.map fun ch =>
    Task.spawn (prio := .dedicated) fun _ => ch.map fun (r, b, f, T, o, m) => evalParams r b f T o m
  let mut rows : Array Row := #[]
  for t in tasks do
    rows := rows ++ t.get.toArray

  let total := rows.size
  let np := (rows.filter (·.paradox)).size
  let ns := (rows.filter (·.strong)).size
  let ng := (rows.filter (·.grossOnly)).size
  IO.println s!"Experiment E: {total} parameter settings (generalist retraining fixed at 2 worker-ticks)"
  IO.println s!"  prescribed pair (stock dominance + earlier window close): {np} ({pct np total})"
  IO.println s!"  strong pair (richer B locked in while A can reorganize):              {ns} ({pct ns total})"
  IO.println s!"  gross-only paradox (window closes earlier, no storage dominance):      {ng} ({pct ng total})"
  let noPenalty := rows.filter (·.rSpec ≤ 2)
  IO.println s!"  sanity: settings with rSpec ≤ rGen = 2: {noPenalty.size}; paradox in {(noPenalty.filter (·.paradox)).size}, strong in {(noPenalty.filter (·.strong)).size}"

  IO.println "\nTwo-tick stock decisions: settings with each outcome"
  IO.println "  tie priority   entered lock-in   survived to T   strong pair vs generalist A"
  IO.println s!"  foraging       {(rows.filter (fun r => r.forageFirstLock ≥ 0)).size}   {(rows.filter (·.forageSurvives)).size}   {(rows.filter (·.forageStrongVsA)).size}"
  IO.println s!"  training       {(rows.filter (fun r => r.trainFirstLock ≥ 0)).size}   {(rows.filter (·.trainSurvives)).size}   {(rows.filter (·.trainStrongVsA)).size}"
  IO.println s!"  forage priority enters lock-in and training priority survives: {(rows.filter (fun r => r.forageFirstLock ≥ 0 && r.trainSurvives)).size}"

  summarize "By specialist retraining cost rSpec (generalists: 2)" rows (·.rSpec) (List.range' 1 10)
  summarize "By specialization bonus" rows (·.bonus) [1, 2]
  summarize "By storage capacity fmax" rows (·.fmax) [12, 16, 20, 24, 30]
  summarize "By horizon T" rows (·.T) [12, 14, 16, 18, 20]
  summarize "By ticks of full wild yield before decline" rows (·.on) [3, 4, 5, 6]
  summarize "By ticks of half wild yield" rows (·.mid) [0, 1, 2]
  let hiPen := rows.filter (·.rSpec ≥ 6)
  summarize "rSpec ≥ 6 only, by storage capacity" hiPen (·.fmax) [12, 16, 20, 24, 30]

  let header := "rSpec,bonus,fmax,T,on,mid,tA_adapt,tB_adapt,tA_phys,tB_phys,usefulA,usefulB,grossA,grossB,stockDom,earlier,paradox,grossOnly,strong,forageFirstLock,trainFirstLock,forageSurvives,trainSurvives,forageStrongVsA,trainStrongVsA"
  let lines := rows.toList.map fun r =>
    s!"{r.rSpec},{r.bonus},{r.fmax},{r.T},{r.on},{r.mid},{r.tA},{r.tB},{r.physA},{r.physB},{r.usefulA},{r.usefulB},{r.grossA},{r.grossB},{b2s r.stockDom},{b2s r.earlier},{b2s r.paradox},{b2s r.grossOnly},{b2s r.strong},{r.forageFirstLock},{r.trainFirstLock},{b2s r.forageSurvives},{b2s r.trainSurvives},{b2s r.forageStrongVsA},{b2s r.trainStrongVsA}"
  IO.FS.writeFile "experimentE_results.csv" ("\n".intercalate (header :: lines) ++ "\n")
  IO.println "\nPer-setting results written to experimentE_results.csv"
