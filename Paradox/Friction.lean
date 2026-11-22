import Paradox.Kernel

/-!
# Two-tick stock rules with a viability shield and "acquire first" variants

All rules maximize the food stored over the next two ticks (as in `Decision.lean`) and replan
every tick. They differ in tie priority and in which actions are eligible:

* `forage`, `train` — ties favor foraging or training (the Experiment E rules)
* `shield` — the forage rule restricted to actions whose next state stays in `K_adapt`
* `acquireTies` — while farming is not held, no specialization and ties favor training; on the
  first tick farming is held it must specialize; after that, the forage rule
* `acquireEarly` — as `acquireTies`, but while farming is not held it first maximizes the number
  of trainees (the fastest acquisition that avoids starvation)

For the shield, the price of safety at a tick is the two-tick value of the unrestricted choice
minus that of the shielded choice, counted when both survive the same number of ticks.
-/

namespace Paradox

inductive Rule where
  | forage | train | shield | acquireTies | acquireEarly
  deriving DecidableEq

structure RuleRun where
  traj : Array St
  strict : Bool     -- some shield override lowered the two-tick value
  price : Nat       -- two-tick value given up, summed over overrides

private def tieForage (p : Params) (a : Act) : List Nat :=
  [a.f, p.N - a.r, if a.sp then 0 else 1, a.m]

private def tieTrain (a : Act) : List Nat :=
  [a.r, a.m, a.f, if a.sp then 0 else 1]

/-- Two-tick value: ticks survived in the lookahead, then the sum of their ending stocks. On the
second tick all forage attains the maximal ending stock (see `Params.stockDecision`). -/
def Params.lookValue (p : Params) (n : St) : Nat × Nat :=
  let last := if n.t < p.T then p.step false n ⟨p.N, 0, 0, false⟩ else none
  match last with
  | some n2 => (2, n.F + n2.F)
  | none => (1, n.F)

private def beats (best : Option (List Nat × St)) (rank : List Nat) : Bool :=
  match best with
  | none => true
  | some (r, _) => decide (r < rank)

def Kernels.runRule (K : Kernels) (rule : Rule) : RuleRun := Id.run do
  let p := K.p
  let acquire := rule == .acquireTies || rule == .acquireEarly
  let mut cur : St := ⟨0, 0, 0, false, false, 0⟩
  let mut traj := #[cur]
  let mut strict := false
  let mut price := 0
  for _ in [0:p.T] do
    let acquiring := acquire && !cur.farm
    let mustSpec := acquire && cur.farm && !cur.spec
    let byTrain := rule == .train || acquiring
    let mut bestAll : Option (List Nat × St) := none
    let mut bestOk : Option (List Nat × St) := none
    for a in p.actions .adapt cur do
      if (acquiring && a.sp) || (mustSpec && !a.sp) then continue
      match p.step false cur a with
      | none => pure ()
      | some n =>
        let (tk, food) := p.lookValue n
        let pre := if rule == .acquireEarly && acquiring then a.r else 0
        let rank := pre :: tk :: food :: (if byTrain then tieTrain a else tieForage p a)
        if beats bestAll rank then bestAll := some (rank, n)
        if rule != .shield || K.viable .adapt n then
          if beats bestOk rank then bestOk := some (rank, n)
    match bestAll, bestOk with
    | some (ra, _), some (ro, n) =>
      if (ra[1]!, ra[2]!) != (ro[1]!, ro[2]!) then
        strict := true
        if ra[1]! == ro[1]! then price := price + (ra[2]! - ro[2]!)
      cur := n
      traj := traj.push n
    | _, _ => break
  return { traj, strict, price }

end Paradox
