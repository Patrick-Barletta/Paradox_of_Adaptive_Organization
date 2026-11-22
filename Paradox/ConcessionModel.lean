/-!
# Argument V: exact sweeps for structural concessions and calm-period erosion

Computational companion to `Paradox/Concession.lean`; the executable `argV` prints the results,
and `python/toy/argV.py` computes the same numbers independently.

* **Sweep A (structural concessions).** At tick 0 the organization pays for a clean fix (cost 5,
  output 4, one dead tick per forced policy switch) or a structural concession (cost 1, output
  capped at 3, two dead ticks per forced switch). Upkeep is 2, a dead tick produces nothing, and
  reserves are capped at 8. Forced switches start at ticks `P, 2P, ...`. The post-choice dynamics
  are deterministic, so each kernel is decided by one simulation.
* **Sweep B (calm-period erosion).** Shocks needing and removing 4 reserves recur after every `L`
  calm ticks (4 shocks). A calm tick earns 1; reserves above the controller's floor are spent.
  Controllers: myopic (floor 0), static (floor 6), adaptive (floor resets to 6 after a shock and
  drops by 1 after every `k` calm ticks).
-/

namespace Paradox.ConcessionModel

/-! ### Sweep A -/

def U : Int := 2
def RMAX : Int := 8
def cFix : Int := 5
def cConc : Int := 1
def outFix : Int := 4
def outConc : Int := 3
def deadFix : Nat := 1
def deadConc : Nat := 2

/-- Is tick `t` a dead tick: within `d` ticks of a forced switch at `P, 2P, ... < horizon`, or of an
optional unscheduled switch starting at `extra`? -/
def isDead (P d horizon t : Nat) (extra : Option Nat) : Bool :=
  let sched := (List.range horizon).any fun s => s ≥ P && s % P == 0 && s ≤ t && t < s + d
  let ex := match extra with
    | some e => e ≤ t && t < e + d
    | none => false
  sched || ex

/-- Viability of a choice (`conc = true`: the concession) for horizon `T`. -/
def viable (r0 : Int) (P T : Nat) (conc : Bool) (extra : Option Nat := none) : Bool := Id.run do
  let cost := if conc then cConc else cFix
  let out := if conc then outConc else outFix
  let d := if conc then deadConc else deadFix
  if r0 < cost then return false
  let mut r := min RMAX (r0 - cost)
  for t in [0:T] do
    let raw := r + (if isDead P d T t extra then 0 else out) - U
    if raw < 0 then return false
    r := min RMAX raw
  return true

def r0s : List Int := (List.range 10).map fun (i : Nat) => Int.ofNat i + 1
def ps : List Nat := [3, 4, 5, 6, 7, 8]
def ts : List Nat := (List.range 21).map (· + 4)

def crossover (r0 : Int) (P : Nat) : String :=
  match (ts.filter fun T => viable r0 P T true).getLast? with
  | none => "none"
  | some T => if T == 24 then "all" else toString T

/-- Ticks at which one unscheduled forced switch kills the concession but not the clean fix, in
cells where both survive the scheduled switches to horizon 24 (`none` otherwise). -/
def scarWindow (r0 : Int) (P : Nat) : Option (List Nat) :=
  if viable r0 P 24 true && viable r0 P 24 false then
    some ((List.range 24).filter fun t => !viable r0 P 24 true (some t) && viable r0 P 24 false (some t))
  else none

/-! ### Sweep B -/

def mMax : Nat := 6
def mReq : Nat := 4
def income : Nat := 1
def nShocks : Nat := 4

/-- Controller 0 myopic, 1 static, 2 adaptive. Returns (survives all shocks, cumulative output). -/
def runB (ctrl k L : Nat) : Bool × Nat := Id.run do
  let mut r := mMax
  let mut floor := if ctrl == 0 then 0 else mMax
  let mut calm := 0
  let mut out := 0
  if ctrl == 0 then
    out := out + r
    r := 0
  for _ in [0:nShocks] do
    for _ in [0:L] do
      r := r + income
      if ctrl == 2 then
        calm := calm + 1
        if calm == k then
          floor := floor - 1
          calm := 0
      let keep := min r floor
      out := out + (r - keep)
      r := keep
    if r < mReq then return (false, out)
    r := r - mReq
    if ctrl == 2 then
      floor := mMax
      calm := 0
  return (true, out)

def ks : List Nat := (List.range 8).map (· + 1)
def ls : List Nat := (List.range 25).map (· + 1)

end Paradox.ConcessionModel
