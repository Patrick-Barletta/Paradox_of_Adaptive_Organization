import Paradox.Model

namespace Paradox

/-- The two deterministic ways of breaking ties in Experiment E. -/
inductive StockTie where
  | forage | train
  deriving DecidableEq

private def tieRank (rule : StockTie) (p : Params) (a : Act) : List Nat :=
  let keepSpecialty := if a.sp then 0 else 1
  match rule with
  | .forage => [a.f, p.N - a.r, keepSpecialty, a.m]
  | .train => [a.r, a.m, a.f, keepSpecialty]

/-- Replan every tick. Prefer to survive both steps of the lookahead (one at the end
of the horizon), then maximize the sum of their ending food stocks. If all actions
starve on the second tick, maximize the first tick's stock. The final comparison
uses the action ranking; its four entries distinguish every admissible action. -/
def Params.stockDecision (p : Params) (rule : StockTie) (s : St) : Option St := Id.run do
  let mut bestRank : List Nat := []
  let mut best : Option St := none
  for a in p.actions .adapt s do
    if let some n := p.step false s a then
      -- On the final lookahead tick all forage attains maximal ending stock:
      -- farm harvest ordered then arrives later, and training has no immediate yield.
      let last := if n.t < p.T then p.step false n ⟨p.N, 0, 0, false⟩ else none
      let (ticks, food) := match last with
        | some n2 => (2, n.F + n2.F)
        | none => (1, n.F)
      let rank := ticks :: food :: tieRank rule p a
      if bestRank < rank then
        bestRank := rank
        best := some n
  return best

def Params.stockHistory (p : Params) (rule : StockTie) (s : St) : Array St := Id.run do
  let mut cur := s
  let mut traj := #[s]
  for _ in [s.t:p.T] do
    match p.stockDecision rule cur with
    | some next => cur := next; traj := traj.push next
    | none => break
  return traj

end Paradox
