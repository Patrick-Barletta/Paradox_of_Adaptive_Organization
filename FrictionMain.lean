import Paradox.Friction

/-!
# Friction sweep: skill decay and training cost over the Experiment E grid

For each friction setting `(decay, trainCost)` and every Experiment E parameter setting, run the
five rules of `Paradox/Friction.lean` from `s0` and count outcomes. With both frictions off the
forage and train columns reproduce Experiment E.
-/

open Paradox

def configs : List (Nat × Nat) :=
  [(0, 0), (6, 0), (4, 0), (3, 0), (2, 0), (1, 0), (0, 1), (0, 2), (0, 3), (2, 1)]

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

/-- Per-setting outcome, in the column order of the output. -/
structure Out where
  forageLock : Nat
  forageSurv : Nat
  trainSurv : Nat
  shieldSurv : Nat
  shieldStrict : Nat
  shieldPrice : Nat
  lockDeficit : Int
  acqTiesSurv : Nat
  acqTiesLock : Nat
  acqEarlySurv : Nat
  acqEarlyLock : Nat

def Out.add (x y : Out) : Out :=
  ⟨x.forageLock + y.forageLock, x.forageSurv + y.forageSurv, x.trainSurv + y.trainSurv,
   x.shieldSurv + y.shieldSurv, x.shieldStrict + y.shieldStrict, x.shieldPrice + y.shieldPrice,
   x.lockDeficit + y.lockDeficit, x.acqTiesSurv + y.acqTiesSurv, x.acqTiesLock + y.acqTiesLock,
   x.acqEarlySurv + y.acqEarlySurv, x.acqEarlyLock + y.acqEarlyLock⟩

def Out.zero : Out := ⟨0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0⟩

def b2n (b : Bool) : Nat := if b then 1 else 0

def evalSetting (decay cost : Nat) (rSpec bonus fmax T on mid : Nat) : Out :=
  let wild := (List.replicate on 2 ++ List.replicate mid 1 ++ List.replicate (T - on - mid) 0).toArray
  let p : Params := { fmax, T, specBonus := bonus, rGen := 2, rSpec, wild, decay, trainCost := cost }
  let K := Kernels.build p
  let run := K.runRule
  let fo := run .forage
  let tr := run .train
  let sh := run .shield
  let aT := run .acquireTies
  let aE := run .acquireEarly
  let surv (r : RuleRun) := b2n (r.traj.back!.t == T)
  let lockAt (r : RuleRun) : Option Nat := (r.traj.find? (K.severity · == 3)).map (·.t)
  let lock (r : RuleRun) := b2n (lockAt r).isSome
  let deficit : Int := match lockAt fo with
    | some L =>
      if L < sh.traj.size then
        let a := fo.traj[L]!
        let b := sh.traj[L]!
        (Int.ofNat (a.F + a.P)) - (Int.ofNat (b.F + b.P))
      else 0
    | none => 0
  ⟨lock fo, surv fo, surv tr, surv sh, b2n sh.strict, sh.price, deficit,
   surv aT, lock aT, surv aE, lock aE⟩

def main (args : List String) : IO Unit := do
  let g := match args with
    | [n] => grid.take n.toNat!
    | _ => grid
  IO.println s!"Friction sweep over {g.length} settings of the Experiment E grid"
  IO.println "  decay: farming is lost after this many consecutive ticks with no farmers (0 = never)"
  IO.println "  trainCost: food consumed per trainee-tick"
  IO.println "  forage, train: two-tick stock rules with ties favoring foraging or training"
  IO.println "  shield: the forage rule restricted to actions whose next state stays in K_adapt"
  IO.println "  acqTies: acquire farming (ties favor training), then specialize; acqEarly: acquire it as fast as possible, then specialize"
  IO.println "  shieldStrict: settings where a shield override lowers the two-tick value; shieldPrice: two-tick value given up, summed"
  IO.println "  lockDeficit: forage minus shield food (stock + incoming harvest) at the forage rule's first lock-in tick, summed"
  IO.println ""
  IO.println "decay,trainCost,forageLock,forageSurv,trainSurv,shieldSurv,shieldStrict,shieldPrice,lockDeficit,acqTiesSurv,acqTiesLock,acqEarlySurv,acqEarlyLock"
  for (d, c) in configs do
    let sz := (g.length + 7) / 8
    let chunks := (List.range 8).map fun k => (g.drop (k * sz)).take sz
    let tasks := chunks.map fun ch => Task.spawn (prio := .dedicated) fun _ =>
      ch.foldl (fun acc (r, b, f, T, o, m) => acc.add (evalSetting d c r b f T o m)) Out.zero
    let o := tasks.foldl (fun acc t => acc.add t.get) Out.zero
    IO.println s!"{d},{c},{o.forageLock},{o.forageSurv},{o.trainSurv},{o.shieldSurv},{o.shieldStrict},{o.shieldPrice},{o.lockDeficit},{o.acqTiesSurv},{o.acqTiesLock},{o.acqEarlySurv},{o.acqEarlyLock}"
