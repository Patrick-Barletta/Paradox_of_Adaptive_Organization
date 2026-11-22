# Argument VI — The Escape Ratchet

**Subtitle:** *Accumulating Structural Commitments Across Successful Adaptations*

*Working draft, November 2026. Builds on Arguments I–III and V. Notation follows I.3.*

## Central claim

A successful escape answers the crisis in front of it. It does not guarantee that the organization it leaves behind can escape the next one. Argument VI asks when repeated, locally successful escapes consume the feasibility of future escape, and what prevents that.

Argument VI makes three claims, at three levels:

1. **Mathematical.** If each patching escape adds at least $`\delta\ge1`$ ticks of unavoidable latency to the next escape and deadlines are bounded, patching becomes infeasible, no later than cycle $`\lfloor(D-\ell_0)/\delta\rfloor+1`$ and exactly then when growth is exact (Theorem VI.1, machine-checked).
2. **Constructive.** A finite organization can make several successful patching escapes and then reach a state where no organizational escape exists although a physical one does: a severity-3 state (Theorem VI.2 and an exact reference model, machine-checked).
3. **Behavioral.** Short-horizon policies select patching where earlier pruning, or an independent startup path prepared in time, would keep the organization viable. In an exact sweep of 1,944 configurations, a policy with full lookahead survives all 12 cycles in 1,555 configurations; patching alone survives in 18.

None of this says that every successful adaptation creates a ratchet, or that collapse is inevitable under unrestricted adaptation. The inevitability is conditional on a specified sequence of patching actions.

## VI.1. Local escape and long-run viability

Arguments I–III evaluate one crisis at a time: is the current state in the adaptive kernel, and if so, what transition gets it out? Argument V showed that the answer depends on the horizon. Argument VI follows the organization across a sequence of crises. Each escape changes the organization, and the change carries into the next crisis.

A **patching escape** clears the current deadline at minimal cost but adds a persistent dependency: the next recovery must traverse one more mandatory stage. Each patch works. The question is what the accumulation does.

**Definition VI.1 (successive escape regimes).** Regime $`n`$ has a minimum time $`\ell_n`$ for the next admissible reorganization, a maximum time $`D_n`$ before functional viability is lost, the margin $`m_n=D_n-\ell_n`$, and the configuration $`O_n`$ left by the previous escape. An escape is feasible when an admissible transition completes before the deadline while viability holds throughout.

## VI.2. Ratchet exhaustion

**Theorem VI.1 (ratchet exhaustion).** Suppose repeated patching satisfies $`\ell_{n+1}\ge\ell_n+\delta`$ with $`\delta\ge1`$, and $`D_n\le D_{\max}`$ for all $`n`$. Then some cycle has $`\ell_n\gt D_n`$: patching cannot remain feasible indefinitely. With a constant deadline $`D`$ and $`\ell_0\le D`$, patching is infeasible no later than cycle
```math
N=\left\lfloor\frac{D-\ell_0}{\delta}\right\rfloor+1,
```
and with exact growth $`\ell_{n+1}=\ell_n+\delta`$, every cycle before $`N`$ is feasible and cycle $`N`$ is the first infeasible one.

*Proof.* Machine-checked in `Paradox/Ratchet.lean`: `latency_growth` ($`\ell_n\ge\ell_0+n\delta`$ by induction), `ratchet_exhaustion`, `ratchet_first_failure` and `ratchet_exact_first_failure`. $`\square`$

**Corollary (margin exhaustion).** If the usable margin falls by at least $`\delta\ge1`$ per escape and nothing replenishes it, it becomes negative (`margin_exhaustion`). A negative margin is an infeasible escape; it is not clamped to zero.

**Where the latency comes from.** The theorem takes latency growth as a hypothesis. The model derives it. Recovery runs through an explicit dependency chain, seed → stage 1 → … → stage $`n`$ → new regime, in which a stage can be worked on only after its predecessor is complete. In that serial chain, completing $`N`$ stages is possible in $`\sum_{i\lt N}\tau_i`$ ticks and impossible in fewer, and adding a stage of positive duration raises the minimum by exactly its duration (`chain_lower`, `chain_upper`, `chain_min_time`, `chain_grows`). With a seed stage of $`\ell_0`$ ticks and patch stages of $`\delta`$ ticks, the bootstrap time after $`n`$ patches is $`\ell_0+n\delta`$ (`ratchet_latency`).

Seriality matters. Dependency nodes that can be worked on in parallel need not lengthen the critical path. The ratchet needs patches that add serial prerequisites.

Latency growth alone does not establish lock-in. A state where patching has become infeasible may still be recoverable by another transition, or may be physically unrecoverable. Classifying it needs the kernels of both classes.

## VI.3. The lock-in witness

**Theorem VI.2 (organizational lock-in witness).** Model a regime's crisis as a deadline-escape system: $`r`$ ticks remain, and the organization may start one transition from its admissible list and must complete it before the deadline. The organizational and physical classes use the same constructor, with the same transition and response laws; they differ only in their lists of admissible transitions. Suppose every organizational transition needs more than $`r`$ ticks while some physically admissible transition fits. Then for any horizon $`T\gt r`$,
```math
s_N\notin\mathcal K_{\mathrm{adapt}},\qquad s_N\in\mathcal K_{\mathrm{phys}},
```
so $`s_N`$ has severity 3 in Argument I's taxonomy.

*Proof.* Machine-checked: `ratchet_lockin_witness`, from `esc_viable` (a transition that fits completes in time) and `esc_not_viable` (an invariant: while nothing admissible fits, the remaining time runs out first). $`\square`$

The organizational restriction is explicit: it is the difference between the two lists. In the model it is an **independent seed** that is physically present and activates in one tick but is not authorized for organizational use. The physical class pays the same costs and latency and faces the same dynamics; the only difference is the authorization.

**The reference witness.** Seed stage 2 ticks, patch stages 2 ticks, deadline 7 ticks, pruning $`3+2n`$ ticks, independent seed 1 tick:

| Regime $`n`$ | Bootstrap time | Patch | Pruning time | Prune |
|---|---|---|---|---|
| 0 | 2 | feasible | 3 | feasible |
| 1 | 4 | feasible | 5 | feasible |
| 2 | 6 | feasible | 7 | feasible |
| 3 | 8 | **infeasible** | 9 | **infeasible** |

Each row is proved from the modeled transitions in `Paradox/RatchetModel.lean`, not from the arithmetic: `ref_patch_time` derives the bootstrap time from the chain, `ref_patch_feasible` and `ref_patch_infeasible` decide the patch escapes in the deadline-escape system, and `ref_prune_feasible` and `ref_prune_infeasible` decide pruning. At regime 3 the organizational transitions (patch, prune) both miss the deadline and the physically present seed fits (`ref_lockin`): **three successful escapes, then a severity-3 state.** Without a seed, regime 3 is outside the physical kernel as well (severity 4).

Across cycles, `patch_only_fails` proves that patching alone fails within four cycles, and `ref_cycle_lockin` proves that depth 3 is outside the organizational cycle kernel and inside the physical one at every horizon.

## VI.4. Pruning, independent seeds and sustainable landing

The model offers four actions each cycle:

| Action | Immediate effect | Long-term consequence |
|---|---|---|
| Patch | clears the deadline in the bootstrap time; free | adds one serial stage |
| Prune | takes $`\ell_0+1+\lambda n`$ ticks and 2 reserves | resets the chain to depth 0 |
| Independent seed | escape in 1 tick once authorized; authorizing costs 3 reserves, needs the seed to be physically present, and takes effect next cycle | recovery no longer traverses the legacy chain |
| Continue | nothing | fails at the deadline |

Reserves gain 1 per cycle and are capped at 4. Three counter-forces break the ratchet in the reference case:

- **Early pruning.** Pruning at depth 1 or at depth 2 repeats indefinitely. Patching twice and then pruning is viable at every horizon from depth 0 with no reserves: the set {depth 0; depth 1 with at least 1 reserve; depth 2 with at least 2} is invariant (`early_prune_sustainable`, via `invariant_viable`).
- **Independent startup.** With the seed authorized in time, every escape takes one tick whatever the chain's depth. In the reference run, authorizing at cycle 0 keeps the depth at 1 for all 12 cycles.
- **Sustainable landing.** Both of the above are repeatable viable policies. The pruning cycle is proved invariant under the stated replenishment; the seed policy is invariant because the seed escape is always admissible once authorized.

These are candidate ratchet-breaking mechanisms, not an exhaustive list. Resource expansion, slower deterioration of the deadline, parallelization of stages and demand reduction could also prevent exhaustion.

## VI.5. Computational results

The sweep covers deadlines $`D=4,\dots,12`$, seed stages $`\ell_0=1,\dots,4`$, patch stages $`\delta=1,\dots,3`$, pruning slopes $`\lambda\in\{0,\delta,2\delta\}`$, the seed absent or present, and starting reserves 0, 2 or 4: 1,944 configurations, each followed for 12 cycles. Bootstrap times come from a tick-level search of the serial chain, each escape's feasibility from a tick-level search of the deadline-escape system, and cycle kernels from backward recursion. Lean (`argVI`) and Python agree line for line (`results/argVI_output.txt`).

**The bound is exact.** The first infeasible patch cycle equals $`\lfloor(D-\ell_0)/\delta\rfloor+1`$ in all 1,944 configurations.

**Patching only.** It survives all 12 cycles in 18 configurations. In those the horizon is too short to reach the bound, so they illustrate the horizon, not a counterexample to Theorem VI.1. In 610 configurations it fails while its state is still in the adaptive kernel: some other escape was still available, so the failure is the policy's, not lock-in. In the remaining 1,316 its path leaves the adaptive kernel:

- with the seed physically present, the physical kernel holds there (**severity 3**) in all 658 such configurations; without it, the state is severity 4 in all 658;
- in 694 of them the path leaves the kernel **before** patching becomes infeasible. Patches keep succeeding after the point of no return, so success is no evidence of recoverability.

Number of successful escapes before the first exclusion, by count of configurations:

| Escapes before exclusion | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Configurations | 389 | 23 | 206 | 215 | 177 | 108 | 57 | 36 | 36 | 33 | 24 | 12 |

In the 389 configurations at 0, the starting state itself admits no 12-cycle survival.

**Policies surviving all 12 cycles** (of 1,944):

| Policy | Survives |
|---|---|
| Patch only | 18 |
| Prune at depth 1 | 1,040 |
| Prune at depth 2 | 1,152 |
| Authorize the seed early | 789 |
| Viability-preserving planner, lookahead 1 cycle | 628 |
| lookahead 2 cycles | 1,250 |
| lookahead 3 cycles | 1,422 |
| full lookahead (12 cycles) | 1,555 |

The planner prefers patching and uses pruning or the seed only when its lookahead shows it must. With a one-cycle lookahead it patches as long as patching works and switches only when it no longer does, which saves the configurations where some other escape is still open at that moment; with two or more cycles of lookahead it acts in time. In the reference case, the planner with lookahead 2 patches to depth 3 and authorizes the seed in the same cycle, just in time, then escapes through the seed for the remaining cycles.

**Sensitivity to the cost of pruning.** With full lookahead, the planner survives in 619 of 648 configurations when pruning time does not depend on depth ($`\lambda=0`$), 516 when it grows with $`\delta`$, and 420 when it grows with $`2\delta`$. The later pruning becomes expensive, the earlier the planner must act and the fewer configurations can be saved.

**Ratchet avoidance.** The sweep refutes a universal-ratchet reading. In 1,555 configurations a policy survives all 12 cycles. For example, with $`D=4`$, $`\ell_0=1`$, $`\delta=1`$, $`\lambda=0`$, patching alone fails at cycle 4, while the planner patches to depth 4, prunes, and repeats.

## VI.6. Relation to existing research

Tainter (1988) explains the collapse of complex societies through declining marginal returns to complexity. The ratchet is a narrower, organizational mechanism: what accumulates is not complexity in general but serial recovery latency, measured against a deadline. Holling (1973) and Gunderson and Holling (2002) describe adaptive cycles in which growth phases accumulate connectedness and rigidity. The ratchet gives one such accumulation an exact membership test: the state at which the adaptive kernel is exited, and whether the physical kernel still holds there.

Within this program, the ratchet links three earlier results. Argument III's restoration independence (III.6) reappears as the independent seed: a startup path that does not depend on the legacy chain makes recovery time independent of its depth. Argument V's horizon-dependent concessions reappear as patching: each patch is a cheap concession that is viable at short horizons and becomes unviable as they lengthen. Argument I's severity classification gives the witness its meaning: severity 3 requires both the organizational exclusion and the physical alternative, and the sweep reports how often each holds.

## VI.7. Strongest objections

**"Latency need not grow with every patch."** Correct, and Theorem VI.1 assumes it does. In the model, growth follows from serial stages (`chain_grows`). Patches that add parallelizable work, or that replace rather than add prerequisites, need not lengthen recovery. The ratchet is a claim about serial accumulation.

**"Deadlines are not uniformly bounded."** If the deadline grows at least as fast as latency, exhaustion need not occur. The theorem needs a uniform bound; slower deterioration of the environment is one of the counter-forces in VI.4.

**"Pruning is always available."** In the model it is, but its cost grows with depth unless $`\lambda=0`$. At regime 3 of the reference case pruning takes 9 ticks and misses the 7-tick deadline. The sensitivity table shows how much the outcome depends on that cost.

**"The physical benchmark is too generous."** The physical class pays the same costs and latencies and faces the same dynamics. Its only extra transition is the unauthorized seed, which is physically present. Without the seed, the reference state is severity 4.

**"Couldn't early pruning have prevented the failure?"** Yes. Pruning at depth 1 or 2 is sustainable in the reference case (proved), and a planner with lookahead 2 or more avoids the ratchet there. The lock-in is a consequence of the patching policy, not of the environment alone. That is the behavioral claim.

**"Outside the kernel means certain failure."** Only in this deterministic model. Under uncertainty, leaving a robust infinite-horizon kernel means indefinite survival can no longer be guaranteed (I.3.8); a realized path can still be lucky.

## Conclusion

Successful short-term escape consumes the feasibility of future escape when each escape adds serial recovery latency and the deadline is bounded.

- **Mathematical:** strictly positive accumulation of unavoidable latency exceeds a bounded execution window, by an exact cycle (Theorem VI.1).
- **Constructive:** three successful patching escapes are followed by a severity-3 state, proved from the modeled transitions (Theorem VI.2 and the reference model).
- **Behavioral:** patching alone survives 12 cycles in 18 of 1,944 configurations; a viability-preserving planner with full lookahead survives in 1,555, by pruning early or preparing an independent seed.

## The arguments together

| Argument | Question | Core result |
|---|---|---|
| **I. The Paradox** | Why can adaptive organization reduce future adaptability? | Equal resources can conceal different recovery options; a short-horizon rule can select lock-in |
| **II. The Necessity** | When does the rate of adaptation become a survival constraint? | Necessity is a kernel condition; delay cannot restore viability under an unchanged ceiling |
| **III. The Escape** | How can a system find a viable transition before the window closes? | Escape is PSPACE-hard in general but tractable under structure; lock-in requires organizational certificates |
| **V. Concessions and Erosion** | What changes when the horizon or the margin rule varies? | Concessions reverse with the horizon; calm erodes empirical margins until an identical shock becomes fatal |
| **VI. The Escape Ratchet** | When does successful escape consume future escape? | Serial latency accumulated by patching exhausts a bounded deadline; early pruning or an independent seed prevents it |

Argument IV is not part of this public release. The numbering is kept so that cross-references stay stable.

## References

- Gunderson, L. H., and C. S. Holling (eds.) (2002). *Panarchy: Understanding Transformations in Human and Natural Systems*. Island Press. [DOI](https://doi.org/10.2307/jj.41003716)
- Holling, C. S. (1973). Resilience and stability of ecological systems. *Annual Review of Ecology and Systematics* 4, 1–23. [DOI](https://doi.org/10.1146/annurev.es.04.110173.000245)
- Tainter, J. A. (1988). *The Collapse of Complex Societies*. Cambridge University Press.

## Code and reproducibility

- **`Paradox/Ratchet.lean`:** Theorem VI.1 (`latency_growth`, `ratchet_exhaustion`, `ratchet_first_failure`, `ratchet_exact_first_failure`), `margin_exhaustion`, the serial chain (`chain_lower`, `chain_upper`, `chain_min_time`, `chain_grows`, `ratchet_latency`), the deadline-escape system and Theorem VI.2 (`esc_viable`, `esc_not_viable`, `ratchet_lockin_witness`), and `invariant_viable`. No `sorry`, no `native_decide`.
- **`Paradox/RatchetModel.lean`:** the reference witness (`ref_patch_time`, `ref_patch_feasible`, `ref_patch_infeasible`, `ref_prune_feasible`, `ref_prune_infeasible`, `ref_lockin`), the cycle-level results (`patch_only_fails`, `early_prune_sustainable`, `ref_cycle_lockin`) and the exact model behind `argVI`.
- **`ArgVIMain.lean`** and **`python/toy/argVI.py`:** the sweep; `python python/crosscheck_all.py argVI` compares them line for line.
