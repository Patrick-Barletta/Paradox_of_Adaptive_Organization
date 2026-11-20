import Paradox.Kernel
import Paradox.Decision

/-!
# Certified facts about the base model of Section I.3.10

These are checked by `native_decide`: Lean compiles the exact kernel computation and evaluates
it. This trusts the Lean compiler (the axiom `Lean.ofReduceBool`), not just the kernel; the
general propositions in `Paradox.Theory` are proved without it.

They are *not* formally linked to `Paradox.Theory`: the theory proves the propositions for any
system, and these theorems certify the computed facts for this one.
-/

namespace Paradox.Certified
open Paradox

def baseK : Kernels := Kernels.build Params.base

/-- The five demonstration states at `t = 11` have severities 0, 1, 2, 3, 4.
The σ = 1, 2, 3 states share the same physical state and differ only in organization. -/
theorem sigma0 : baseK.severity ⟨11, 16, 0, false, false, 0⟩ = 0 := by native_decide
theorem sigma1 : baseK.severity ⟨11, 9, 0, true, false, 0⟩ = 1 := by native_decide
theorem sigma2 : baseK.severity ⟨11, 9, 0, false, false, 0⟩ = 2 := by native_decide
theorem sigma3 : baseK.severity ⟨11, 9, 0, false, true, 0⟩ = 3 := by native_decide
theorem sigma4 : baseK.severity ⟨11, 2, 0, false, false, 0⟩ = 4 := by native_decide

/-- The witnesses for σ = 0–3 pass independent forward re-simulation. -/
theorem witnesses_verify :
    [(Cls.fixed, (⟨11, 16, 0, false, false, 0⟩ : St)), (.policy, ⟨11, 9, 0, true, false, 0⟩),
     (.adapt, ⟨11, 9, 0, false, false, 0⟩), (.phys, ⟨11, 9, 0, false, true, 0⟩)].all
      (fun (c, s) => match baseK.witness c s with
        | some w => baseK.verify c s w
        | none => false) = true := by native_decide

/-- Nesting holds at every one of the 17,136 states; the severity distribution. -/
theorem state_count : Params.base.allStates.size = 17136 := by native_decide
theorem no_nesting_violations : baseK.nestingViolations = 0 := by native_decide
theorem severity_counts : baseK.severityCounts = #[4992, 1957, 8625, 1178, 384] := by native_decide

def s0 : St := ⟨0, 0, 0, false, false, 0⟩
def histA : Array St := baseK.history s0 false
def histB : Array St := baseK.history s0 true

/-- The paradox pair: B (specialize at t = 0) stores at least as much food as A at every tick,
strictly more at some tick, yet its reorganization window closes two ticks earlier. -/
theorem B_dominates_storage :
    histA.size = histB.size ∧
    (List.range histA.size).all (fun i => histB[i]!.F ≥ histA[i]!.F) = true ∧
    (List.range histA.size).any (fun i => histB[i]!.F > histA[i]!.F) = true := by native_decide

theorem windows :
    baseK.pointOfNoReturn .adapt histA = 12 ∧ baseK.pointOfNoReturn .adapt histB = 10 ∧
    baseK.pointOfNoReturn .phys histA = 13 ∧ baseK.pointOfNoReturn .phys histB = 13 := by
  native_decide

/-- At t = 11 the richer specialized settlement is locked in; the generalist can reorganize. -/
theorem strong_at_11 :
    histB[11]!.F = 11 ∧ histA[11]!.F = 9 ∧
    baseK.severity histB[11]! = 3 ∧ baseK.severity histA[11]! = 2 := by native_decide

/-- Explicit two-tick stock decisions from the same start, with different tie-breaking. -/
theorem stock_decisions :
    let forage := Params.base.stockHistory .forage s0
    let train := Params.base.stockHistory .train s0
    forage[1]!.spec = true ∧ train[1]!.spec = true ∧
    forage[11]!.F = 11 ∧ baseK.severity forage[11]! = 3 ∧ forage.back!.t = 14 ∧
    train[11]!.F = 17 ∧ baseK.severity train[11]! = 0 ∧
    train.back!.t = 16 ∧ train.back!.F = 20 := by native_decide

/-- With cheaper retraining after specialization, training and specializing on the
same tick yields a valid, recoverable state in the backward table. -/
theorem cheaper_training_on_specialization :
    let p := { Params.base with rSpec := 1, fmax := 12, T := 12 }
    let next : St := ⟨1, 1, 0, true, true, 0⟩
    p.step false s0 ⟨2, 0, 1, true⟩ = some next ∧ p.valid next = true ∧
    (Kernels.build p).viable .adapt next = true := by native_decide

/-- Proposition 4 on the model: across 1,362,312 same-organization pairs, richer is never less
recoverable; all 22,484 strong-paradox state pairs differ in organization. -/
theorem prop4_check : baseK.resourceMonotoneCheck = (1362312, 0) := by native_decide
theorem fingerprint_check : baseK.fingerprintCheck = (22484, 0) := by native_decide

end Paradox.Certified
