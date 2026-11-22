# Argument VI — The Escape Ratchet

**Subtitle:** *Accumulating Structural Commitments Across Successful Adaptations*

*Working draft, November 2026. Builds on Arguments I–III and V. Notation follows I.3: the model runs on the explicit state $`(x_t,O_t,\pi_t,q_t)`$ with the four control classes of I.3.3. Part II (VI.8–VI.12) extends the argument to a joint system of three agents on a shared chain.*

## Central claim

A successful escape answers the crisis in front of it. It does not guarantee that the organization it leaves behind can escape the next one. Argument VI asks when repeated, locally successful escapes consume the feasibility of future escape, and what prevents that.

Argument VI makes three claims, at three levels, and a fourth for shared recovery paths:

1. **Mathematical.** If each patching escape adds at least $`\delta\ge1`$ ticks of unavoidable latency to the next escape and deadlines are bounded, patching becomes infeasible, no later than crisis $`\lfloor(D-\ell_0)/\delta\rfloor+1`$ and exactly then when growth is exact (Theorem VI.1, machine-checked).
2. **Constructive.** In the four control classes, an organization can make three successful patching escapes and then reach a state outside $`\mathcal K_{\mathrm{adapt}}`$ and inside $`\mathcal K_{\mathrm{phys}}`$: severity 3 (Theorem VI.2 and the reference model, machine-checked).
3. **Behavioral.** The incumbent patch routine leaves the adaptive kernel while its patches still succeed. In an exact sweep of 1,944 configurations it survives all 12 crises in 18. The adaptive kernel contains the start in 1,555. In 927 configurations the patch routine passes its adaptive point of no return during an earlier crisis than the one in which it fails.
4. **Multi-agent.** When three agents share one serial recovery chain, a single partner whose routine keeps patching bounds the survival of the joint system, whatever the others do, and an adversarial partner can always do the same (Theorem VI.4, machine-checked). An independent seed escapes this, and governance decides whether the seed can be used: under unanimity an adversary's veto produces a severity-3 state, proved in general (Theorem VI.5) and found in 297 of 324 swept configurations.

None of this says that every successful adaptation creates a ratchet, or that collapse is inevitable under unrestricted adaptation. The inevitability is conditional on a specified sequence of patching actions.

## VI.1. Local escape and long-run viability

Arguments I–III evaluate one crisis at a time: is the current state in the adaptive kernel, and if so, what transition gets it out? Argument V showed that the answer depends on the horizon. Argument VI follows the organization across a sequence of crises. Each escape changes the organization, and the change carries into the next crisis.

A **patching escape** clears the current deadline at minimal cost but adds a persistent dependency: the next recovery must traverse one more mandatory stage. Each patch works. The question is what the accumulation does.

**Definition VI.1 (successive escape regimes).** Regime $`n`$ has a minimum time $`\ell_n`$ for the next admissible reorganization, a maximum time $`D_n`$ before functional viability is lost, the margin $`m_n=D_n-\ell_n`$, and the configuration $`O_n`$ left by the previous escape. An escape is feasible when an admissible transition completes before the deadline while viability holds throughout.

## VI.2. Ratchet exhaustion

**Theorem VI.1 (ratchet exhaustion).** Suppose repeated patching satisfies $`\ell_{n+1}\ge\ell_n+\delta`$ with $`\delta\ge1`$, and $`D_n\le D_{\max}`$ for all $`n`$. Then some crisis has $`\ell_n\gt D_n`$: patching cannot remain feasible indefinitely. With a constant deadline $`D`$ and $`\ell_0\le D`$, patching is infeasible no later than crisis
```math
N=\left\lfloor\frac{D-\ell_0}{\delta}\right\rfloor+1,
```
and with exact growth $`\ell_{n+1}=\ell_n+\delta`$, every crisis before $`N`$ is feasible and crisis $`N`$ is the first infeasible one.

*Proof.* Machine-checked in `Paradox/Ratchet.lean`: `latency_growth` ($`\ell_n\ge\ell_0+n\delta`$ by induction), `ratchet_exhaustion`, `ratchet_first_failure` and `ratchet_exact_first_failure`. $`\square`$

**Corollary (margin exhaustion).** If the usable margin falls by at least $`\delta\ge1`$ per escape and nothing replenishes it, it becomes negative (`margin_exhaustion`). A negative margin is an infeasible escape; it is not clamped to zero.

**Where the latency comes from.** The theorem takes latency growth as a hypothesis. The model derives it. Recovery runs through an explicit dependency chain, seed → stage 1 → … → stage $`n`$ → new regime, in which a stage can be worked on only after its predecessor is complete. In that serial chain, completing $`N`$ stages is possible in $`\sum_{i\lt N}\tau_i`$ ticks and impossible in fewer, and adding a stage of positive duration raises the minimum by exactly its duration (`chain_lower`, `chain_upper`, `chain_min_time`, `chain_grows`). With a seed stage of $`\ell_0`$ ticks and patch stages of $`\delta`$ ticks, the bootstrap time after $`n`$ patches is $`\ell_0+n\delta`$ (`ratchet_latency`).

Seriality matters. Dependency nodes that can be worked on in parallel need not lengthen the critical path. The ratchet needs patches that add serial prerequisites.

Latency growth alone does not establish lock-in. A state where patching has become infeasible may still be recoverable by another transition, or may be physically unrecoverable. Classifying it needs the kernels of the four classes.

## VI.3. The four-class model and the lock-in witness

The model is a control system with one step per tick on an explicit I.3 state:

- $`x`$ (physical): whether the organization functions, its reserves (capped at 4), and the ticks left before the current crisis's deadline. **A0:** viability depends only on $`x`$.
- $`O`$ (organization): the depth $`n`$ of the legacy recovery chain, and whether the independent seed is authorized. Together they fix the capability structure $`\mathcal C(O)`$, which determines the recovery transitions that are admissible.
- $`q`$ (commitments): whether this crisis's escape is complete; the transition in flight and its progress (for a patch, the units of serial bootstrap work done, which places it in a stage of the chain); and an authorization in flight.
- $`\pi`$: the incumbent crisis-response policy, the patch routine.

A crisis lasts $`D`$ ticks. Its available transitions are:

- **Patch:** traverses the whole chain ($`\ell_0+n\delta`$ ticks of serial work) and adds a stage.
- **Seed escape:** takes one tick.
- **Prune:** a capability-changing move that takes $`\ell_0+1+\lambda n`$ ticks and 2 reserves and resets the depth.
- **Authorize the seed:** a capability-changing move, decided at the first tick of a crisis, that costs 3 reserves and takes effect at the next crisis.

At the deadline an unfinished escape takes the organization down. A finished one starts the next crisis with one unit of income. The null action, which does no work this tick, is always admissible (**A1**).

| Class | Admissible actions |
|---|---|
| $`\mathcal U_{\mathrm{fixed}}`$ | the incumbent patch routine $`\pi_0`$: patch, keep working, wait once done ($`m\equiv\varnothing`$) |
| $`\mathcal U_{\mathrm{policy}}`$ | any recovery within $`\mathcal C(O)`$: patch, or the seed if it is already authorized; no capability-changing move |
| $`\mathcal U_{\mathrm{adapt}}`$ | adds the capability-changing moves: prune and authorize the seed |
| $`\mathcal U_{\mathrm{phys}}`$ | adds the seed whenever it is physically present, authorized or not |

Each class's kernel is $`\mathcal K`$ of its system (Definition 2). Every organizational step is a physical step (**A3**, exactly), so **Proposition 1** holds: $`\mathcal K_{\mathrm{fixed}}\subseteq\mathcal K_{\mathrm{policy}}\subseteq\mathcal K_{\mathrm{adapt}}\subseteq\mathcal K_{\mathrm{phys}}`$ (`class_nesting`). The kernel equals a computable backward recursion (`class_ker_iff`).

**Theorem VI.2 (organizational lock-in witness).** Call a state *blocked* if it meets three conditions: no escape is complete; every organizational transition that could still be started needs more ticks than are left; and nothing in flight can finish in time. Then the state is outside $`\mathcal K_{\mathrm{adapt}}`$, and hence outside $`\mathcal K_{\mathrm{policy}}`$ and $`\mathcal K_{\mathrm{fixed}}`$, for every horizon that reaches the deadline. It is outside $`\mathcal K_{\mathrm{phys}}`$ too when no seed is present. Where the seed escape is admissible, the state is in the kernel at every horizon.

*Proof.* Machine-checked: `blocked_not_viable` (an invariant: from a blocked state every admissible step leads to a blocked state one tick closer to the deadline, and the deadline takes the organization down) and `seed_sustainable` (using the seed at each crisis and waiting otherwise is an invariant set, via `invariant_viable`). `ratchet_lockin_witness` in `Paradox/Ratchet.lean` states the single-transition form. $`\square`$

The organizational restriction is explicit: an **independent seed** that is physically present and activates in one tick but is not authorized for organizational use. The physical class pays the same costs and latency and faces the same dynamics; the only difference is the authorization.

**The reference witness.** Seed stage 2 ticks, patch stages 2 ticks, deadline 7 ticks, pruning $`3+2n`$ ticks, independent seed 1 tick, reserves starting at 4:

| Regime $`n`$ | Bootstrap time | Patch | Pruning time | Prune |
|---|---|---|---|---|
| 0 | 2 | feasible | 3 | feasible |
| 1 | 4 | feasible | 5 | feasible |
| 2 | 6 | feasible | 7 | feasible |
| 3 | 8 | **infeasible** | 9 | **infeasible** |

The rows are computed by running the tick system for one crisis. These are proved from the modeled transitions in `Paradox/RatchetModel.lean`:

- The patch routine survives three crises and fails in the fourth (`ref_patch_only`).
- After three crises it reaches depth 3 with reserves 4 and no authorization (`ref_trajectory`).
- That state is blocked. It is outside $`\mathcal K_{\mathrm{adapt}}`$, $`\mathcal K_{\mathrm{policy}}`$ and $`\mathcal K_{\mathrm{fixed}}`$ and inside $`\mathcal K_{\mathrm{phys}}`$ at every horizon (`ref_lockin`). **Three successful escapes, then a severity-3 state.**
- Without a seed it is outside $`\mathcal K_{\mathrm{phys}}`$ as well: severity 4 (`ref_no_seed`).

## VI.4. Pruning, independent seeds and sustainable landing

Three counter-forces break the ratchet in the reference case:

- **Early pruning.** Patching twice and pruning at depth 2 is viable at every horizon from depth 0 with no reserves: its trajectory enters a closed orbit of the tick system, checked state by state (`ref_prune_sustainable`, via `orbitOK_sound` and `invariant_viable`).
- **Independent startup.** Once the seed is authorized, every escape takes one tick whatever the chain's depth, and the state is in the kernel at every horizon (`seed_sustainable`).
- **Sustainable landing.** Both of the above are repeatable viable policies; both are proved invariant.

These are candidate ratchet-breaking mechanisms, not an exhaustive list. Resource expansion, slower deterioration of the deadline, parallelization of stages and demand reduction could also prevent exhaustion.

## VI.5. Computational results

The sweep covers:

- deadlines $`D=4,\dots,12`$;
- seed stages $`\ell_0=1,\dots,4`$;
- patch stages $`\delta=1,\dots,3`$;
- pruning slopes $`\lambda\in\{0,\delta,2\delta\}`$;
- the seed absent or present;
- starting reserves 0, 2 or 4.

That is 1,944 configurations, each over 12 crises. All four kernels are computed by exact backward recursion on the tick-level systems (`argVI`, `results/argVI_output.txt`). Argument VI's sweep is computed in Lean only.

**Nesting.** At every state reachable under physical actions, for the remaining horizon, the four kernels nest: 58,904,490 checks, no violation (Proposition 1).

**The bound is exact.** The patch routine fails in crisis $`\lfloor(D-\ell_0)/\delta\rfloor+1`$ in all 1,926 configurations where that crisis falls within the horizon.

**Severity at the start**, of 1,944:

| $`\sigma`$ | 0 | 1 | 2 | 3 | 4 |
|---|---|---|---|---|---|
| Configurations | 18 | 0 | 1,537 | 129 | 260 |

Severity 1 never occurs. $`\mathcal U_{\mathrm{policy}}`$ differs from $`\mathcal U_{\mathrm{fixed}}`$ only by using an already-authorized seed, and no configuration starts with one. Every rescue needs a capability-changing move.

**Points of no return on the patch routine's path.** Along the patch routine's own path, each class has a point of no return $`t^*_k`$, the last tick at which the path is in $`\mathcal K_k`$. The order $`t^*_{\mathrm{fixed}}\le t^*_{\mathrm{policy}}\le t^*_{\mathrm{adapt}}\le t^*_{\mathrm{phys}}`$ holds in all 1,944 configurations, with $`t^*_{\mathrm{policy}}=t^*_{\mathrm{fixed}}`$ in all of them. The patch routine survives all 12 crises in 18 configurations; in those the horizon is too short to reach the bound. It fails in 1,926:

- in 389 its starting state is already outside $`\mathcal K_{\mathrm{adapt}}`$;
- in 1,537 it passes $`t^*_{\mathrm{adapt}}`$ later, while still functioning. The first state outside $`\mathcal K_{\mathrm{adapt}}`$ has severity 3 in 529 of these and severity 4 in 1,008.
- In 927 of those 1,537 the path passes $`t^*_{\mathrm{adapt}}`$ during an earlier crisis than the one it fails in. **Patches keep succeeding after the point of no return**, so success is no evidence of recoverability. In the other 610 it passes $`t^*_{\mathrm{adapt}}`$ during the failing crisis.

Severities along the path while the organization functions, with repeats removed:

| Path | Configurations |
|---|---|
| $`2\to4`$ | 1,008 |
| $`2\to3\to4`$ | 529 |
| $`4`$ | 260 |
| $`3\to4`$ | 129 |
| $`0`$ | 18 |

The climb is $`2\to3`$, not $`0\to1\to2\to3`$. The incumbent is never in its own kernel unless it survives outright, and the policy class adds nothing without an authorized seed. Severity 4 follows severity 3 within the failing crisis, once the doomed patch is under way: a transition in flight cannot be abandoned, so even the seed can no longer be started.

**The reference path**, severity by tick (one group per crisis): `2222222|2222222|2333333|3444444|4`. The adaptive point of no return is $`t^*_{\mathrm{adapt}}=14`$, the first tick of crisis 2: the last moment the seed can be authorized in time for crisis 3. The physical point of no return is $`t^*_{\mathrm{phys}}=21`$, the first tick of crisis 3, before the doomed patch starts. The patch of crisis 2 still succeeds at tick 19, five ticks after the adaptive point of no return.

**Rules surviving all 12 crises** (of 1,944):

| Rule | Survives |
|---|---|
| Patch routine ($`\mathcal U_{\mathrm{fixed}}`$) | 18 |
| Prune at depth 1 | 1,040 |
| Prune at depth 2 | 1,152 |
| Authorize the seed early | 789 |
| Some rule in $`\mathcal U_{\mathrm{adapt}}`$ (full lookahead) | 1,555 |

**Sensitivity to the cost of pruning.** The adaptive kernel contains the start in 619 of 648 configurations when pruning time does not depend on depth ($`\lambda=0`$), 516 when it grows with $`\delta`$, and 420 when it grows with $`2\delta`$.

**Ratchet avoidance.** The sweep refutes a universal-ratchet reading: in 1,555 configurations some rule of the adaptive class survives all 12 crises.

## VI.6. Relation to existing research

Tainter (1988) explains the collapse of complex societies through declining marginal returns to complexity. The ratchet is a narrower, organizational mechanism: what accumulates is not complexity in general but serial recovery latency, measured against a deadline. Holling (1973) and Gunderson and Holling (2002) describe adaptive cycles in which growth phases accumulate connectedness and rigidity. The ratchet gives one such accumulation an exact membership test: the tick at which the adaptive kernel is exited, and whether the physical kernel still holds there.

Within this program, the ratchet links three earlier results. Argument III's restoration independence (III.6) reappears as the independent seed: a startup path that does not depend on the legacy chain makes recovery time independent of its depth. Argument V's horizon-dependent concessions reappear as patching: each patch is a cheap concession that is viable at short horizons and becomes unviable as they lengthen. Argument I's severity classification gives the witness its meaning: severity 3 requires both the organizational exclusion and the physical alternative, and the sweep reports how often each holds.

## VI.7. Strongest objections

**"Latency need not grow with every patch."** Correct, and Theorem VI.1 assumes it does. In the model, growth follows from serial stages (`chain_grows`). Patches that add parallelizable work, or that replace rather than add prerequisites, need not lengthen recovery. The ratchet is a claim about serial accumulation.

**"Deadlines are not uniformly bounded."** If the deadline grows at least as fast as latency, exhaustion need not occur. The theorem needs a uniform bound; slower deterioration of the environment is one of the counter-forces in VI.4.

**"Pruning is always available."** In the model it is, but its cost grows with depth unless $`\lambda=0`$. At regime 3 of the reference case pruning takes 9 ticks and misses the 7-tick deadline. The sensitivity results show how much the outcome depends on that cost.

**"The physical benchmark is too generous."** The physical class pays the same costs and latencies and faces the same dynamics. Its only extra action is the unauthorized seed, which is physically present. Without the seed, the reference state is severity 4.

**"A transition in flight could be abandoned."** In the model it cannot, which is why severity 4 follows severity 3 within the failing crisis. Allowing abandonment would add actions to every class and could only enlarge the kernels; it would not move the adaptive point of no return, which comes earlier.

**"Couldn't early pruning have prevented the failure?"** Yes. Pruning at depth 2 is sustainable in the reference case (proved), and the adaptive kernel contains the start there. The lock-in is a consequence of the patch routine, not of the environment alone. That is the behavioral claim.

**"Outside the kernel means certain failure."** Only in this deterministic model. Under uncertainty, leaving a robust infinite-horizon kernel means indefinite survival can no longer be guaranteed (I.3.8); a realized path can still be lucky.

## Part II: three agents on a shared chain

Recovery paths are often shared. A grid operator, a telecom carrier and a water utility each maintain their own systems, but restoring service runs through all three in order. Each can patch its own part. None controls the whole path. Part II asks what the ratchet does when the chain is shared, and what kind of partner is dangerous. It adds no new viability notion: it builds the joint system from the same `Sys`, kernels, control classes and A0–A3, and treats an adversary as a disturbance in the robust kernel of I.3.8.

## VI.8. The joint system

Three agents each own one segment of a single serial recovery chain: the seed stage ($`\ell_0`$ ticks), then segment 1, segment 2 and segment 3. They escape together or fail together. One step of the joint system is one crisis.

- **State (I.3.1).** $`x`$ is whether the shared service functions (**A0**: viability depends only on $`x`$); the segment depths are commitments $`q`$; whether the seed is authorized is part of $`O`$.
- **Chain escape.** Each agent either patches its segment (it takes $`\delta n`$ ticks to traverse at depth $`n`$, and the depth becomes $`n+1`$), prunes it (one rebuild stage of $`1+\lambda n`$ ticks; the depth becomes 0), or takes the null action and leaves it unrestored (**A1**). The joint escape needs every segment restored. It takes $`\ell_0`$ plus the three segment times and must fit the deadline $`D`$. Because the chain is serial, that sum is the minimum bootstrap time (`shared_makespan`, `shared_bootstrap`, from `chain_min_time`). Within a crisis, a transition of duration $`d`$ escapes a deadline $`r`$ ticks away exactly when $`d\le r`$ (`esc_viable`, `esc_not_viable`). With a single agent, these are Part I's durations.
- **Independent seed.** Agent 1 may instead escape through the seed (1 tick, depths unchanged) when it is admissible. Proposing authorization is a capability-changing move that takes $`\alpha=2`$ ticks of the current crisis and takes effect next crisis. Three governance rules: **no seed**; **unilateral** (agent 1 alone authorizes); **unanimous** (partners 2 and 3 must vote yes).
- **No reserves.** All costs are time. Part II isolates the interaction between agents.

**Classes and disturbances.** Each agent has its own class:

| Agent | Role |
|---|---|
| Agent 1 | $`\mathcal U_{\mathrm{adapt}}`$ |
| Partner in $`\mathcal U_{\mathrm{adapt}}`$ (C, cooperative) | its actions are chosen together with agent 1's |
| Partner in $`\mathcal U_{\mathrm{fixed}}`$ (N, neutral) | runs its incumbent routine and meta-policy $`(\pi_0,\mu_0)`$: always patch, or prune at depth 2; votes yes |
| Adversarial partner (A) | not a controller: its action is a disturbance (I.3.8) ranging over a disturbance set, by default any segment action and vote except withholding its segment (covert); an overt adversary may also withhold |

The physical class frees every organizational restriction: routines become choices and the seed is admissible without authorization. Adversaries are part of the environment, so they remain (I.3.3, "what $`\mathcal U_{\mathrm{phys}}`$ relaxes"). Every organizational step is a physical step (**A3**, `a3_phys`). Assignments are named by the roles of agents 1, 2 and 3, so CNA is agent 1, a neutral partner 2 and an adversarial partner 3.

**The kernel** is the robust kernel of I.3.8: some admissible joint action of agent 1 and the cooperative partners leads, for every disturbance, to a functioning state that is again in the kernel. Without adversaries it *is* the kernel $`\mathcal K`$ of the deterministic joint system (`kernel_eq`).

## VI.9. Theorems

**Theorem VI.3 (class and stance nesting).** For each partner, adversary ⊆ fixed ⊆ adapt, at every horizon, provided the routine lies in the adversary's disturbance set.

*Proof.* Machine-checked. Fixed ⊆ adapt is Proposition 1 on the joint system (`class_nesting_K`, from `nesting`). Its robust form, and adversary ⊆ fixed (the adversary may play the routine), follow from Proposition 1 for robust kernels, which I.3.8 states (`rnesting`, `stance_nesting`). $`\square`$

So $`\mathcal K_{\mathrm{CAA}}\subseteq\mathcal K_{\mathrm{CNA}}\subseteq\mathcal K_{\mathrm{CNN}}\subseteq\mathcal K_{\mathrm{CCN}}\subseteq\mathcal K_{\mathrm{CCC}}`$, and likewise for every one-step substitution. A neutral partner is never worse than an adversary and never better than a cooperator. The question is where between them it falls.

**Theorem VI.4 (shared ratchet).** With no seed, let
```math
N_1=\left\lfloor\frac{D-\ell_0}{\delta}\right\rfloor+1,\qquad N_2=\left\lfloor\frac{D-\ell_0}{2\delta}\right\rfloor+1 .
```
(a) If one partner's routine always patches, the joint system survives at most $`N_1`$ crises from the origin, whatever the others do. (b) If both partners' routines always patch, at most $`N_2`$. (c) An adversarial partner alone also bounds survival by $`N_1`$, whatever the other partner's class or routine.

*Proof.* Machine-checked: `shared_ratchet_one`, `shared_ratchet_three`, `shared_ratchet_two` and `adversary_ratchet`. The engine is Theorem VI.1's latency argument applied along the joint path (`rviab_budget`): each successful crisis needs $`\ell_0`$ plus the patching partners' segment times, and those grow by $`\delta`$ per partner per crisis. For (c), patching is in the adversary's disturbance set (Theorem VI.3). $`\square`$

**The neutral ratchet is structural lock-in.** With no seed and $`\ell_0+3\le D`$, the physical class, in which the routines are freed and all three agents may prune every crisis, survives at every horizon. A partner's routine is an organizational constraint, so the exclusion of Theorem VI.4(a) is severity 3 (`neutral_lockin`, via `prune_sustainable`).

Segments are owned. Agent 1 can prune only its own, so pruning is a private cost with a shared benefit. A cooperative agent cannot offset a partner's accumulation, and the ratchet runs at the combined speed of the partners that do not prune.

**Theorem VI.5 (seed governance).**
(a) Where the seed is admissible, the joint system survives at every horizon, whatever the classes and disturbances (`seed_sustainable`). If authorization passes (unilateral governance, or unanimity with consenting partners), fixed routines and covert adversaries restore their segments, and $`\ell_0+2+\alpha\le D`$, then the origin is in the robust kernel at every horizon. The reason is that proposing in the first crisis is a step all of whose successors are (`early_authorization`, from Proposition 3′, `robust_strengthened`).
(b) Under unanimity, with no unauthorized access, an adversarial partner 3 facing a neutral partner 2 that always patches bounds survival by $`N_2`$: patching and voting no are in its disturbance set (`veto_ratchet`).
(c) In the same setting the physical class survives at every horizon (`veto_severity`). The exclusion is a severity-3 state created by governance, not by physics.
(d) An overt adversary, one that may withhold its segment, defeats every functioning state without an admissible seed within one crisis (`overt_lockin`). With a seed present, the physical class still survives (`overt_physical`).

**The reference case.** $`D=7`$, $`\ell_0=2`$, $`\delta=2`$, pruning $`1+2n`$ per segment, $`\alpha=2`$, neutral routine always patch, so $`N_1=3`$ and $`N_2=2`$. Crises survived from the origin, of 12:

| Governance | CCC | CCN | CNN | CCA | CNA | CAA |
|---|---|---|---|---|---|---|
| No seed | 12 | 3 | 2 | 3 | 2 | 1 |
| No seed, physical class | 12 | 12 | 12 | 3 | 3 | 1 |
| Unilateral | 12 | 12 | 12 | 12 | 12 | 12 |
| Unanimous | 12 | 12 | 12 | 3 | 2 | 1 |
| Unanimous, physical class | 12 | 12 | 12 | 12 | 12 | 12 |

These reference results are proved:

- With no seed, CCN survives at most 3 crises (`ref_one_patcher`, also stated in $`\mathcal K`$ of the deterministic joint system as `ref_one_patcher_K`).
- With no seed, CNN is outside $`\mathcal K`$ at horizon 3 while its physical class survives at every horizon: severity 3 (`ref_neutral_lockin`).
- Under unanimity, CNA survives at most 2 crises while the physical class survives at every horizon (`ref_veto`).
- Under unilateral governance every assignment with covert adversaries survives at every horizon (`ref_unilateral`). Under unanimity CNN does too, in $`\mathcal K`$ (`ref_consent`).
- An overt adversary leaves no surviving crisis under any governance rule (`ref_overt`).

The exact values in the other cells are computed.

Against the adversary under unilateral governance, agent 1's first kernel action is to patch and propose in crisis 0. With a one-crisis lookahead it never proposes, because proposing costs time now and pays only later, and it is guaranteed only 1 crisis.

## VI.10. Computational results (Part II)

The sweep covers $`D=4,\dots,12`$, $`\ell_0=1,\dots,4`$, $`\delta=1,\dots,3`$ and $`\lambda\in\{0,\delta,2\delta\}`$: 324 configurations, each under the three governance rules and both neutral routines, over 12 crises. Kernels are computed by backward recursion over every reachable functioning state, using the transition function and admissible actions of the theorems. Lean (`argVI multi`) and Python agree line for line (`results/argVI_multi_output.txt`).

**Nesting.** 20,891,364 pointwise checks of the six one-step substitutions, at every reachable state and horizon, find no violation (Theorem VI.3).

**Configurations surviving all 12 crises** (of 324):

| Governance, neutral routine | CCC | CCN | CNN | CCA | CNA | CAA |
|---|---|---|---|---|---|---|
| No seed, always patch | 279 | 0 | 0 | 0 | 0 | 0 |
| No seed, prune at depth 2 | 279 | 168 | 98 | 0 | 0 | 0 |
| Unilateral (either routine) | 297 | 297 | 297 | 270 | 270 | 234 |
| Unanimous (either routine) | 297 | 297 | 297 | 0 | 0 | 0 |

Five results stand out.

1. **One patching partner is enough.** With no seed, no assignment containing an always-patching neutral partner survives 12 crises. The bounds of Theorem VI.4 hold in all 324 configurations. CNN equals $`N_2`$ in all 324; CCN equals $`N_1`$ in 219, because agent 1's own segment usually costs something too.
2. **The neutral ratchet is severity 3, the adversarial one severity 4.** With no seed, CCN and CNN each fail in all 324 configurations. They are severity 3 in 279 (freeing the routine physically rescues the system) and severity 4 in 45. With an adversary the physical class does not help: CCA, CNA and CAA are severity 4 in all 324.
3. **Indifference is often as damaging as hostility.** With no seed, replacing the neutral partner 3 by an adversary leaves survival unchanged in 216 of 324 configurations. When the neutral partner prunes at depth 2, the adversary becomes decisive: CNN survives in 98 configurations, CNA in none.
4. **A veto turns the seed off.** Under unanimity an adversary's veto gives exactly the no-seed survival in all 324 configurations. CNN survives all 12 crises and CNA does not in 297; the physical class survives in all 297 of them (severity 3).
5. **Lookahead is required.** Under unilateral governance CNA survives in 270 configurations. The early-authorization condition $`\ell_0+2+\alpha\le D`$ holds in 234, and all 234 survive (Theorem VI.5(a)); 36 more survive with later authorization. A one-crisis-lookahead agent 1 survives in none.

An overt adversary, one that may withhold its segment, leaves no configuration surviving even the first crisis under any governance rule.

The 27 configurations that fail even for three cooperators with a seed are exactly those with $`D-\ell_0\le1`$: the first crisis leaves less slack than the 2 ticks authorization takes, and the slack only shrinks afterwards.

## VI.11. Relation to existing research (Part II)

The adversary is handled by the robust kernel of I.3.8, the framework's own treatment of disturbances. Two-player viability and reach–avoid problems are classical: the discriminating kernel of viability theory (Cardaliaguet, 1996) and Hamilton–Jacobi reach–avoid games (Margellos and Lygeros, 2011) are the continuous counterparts of the robust kernel used here. Tsebelis (2002) shows that policy stability rises with the number of veto players. Here a single veto player is enough to convert a sustainable path into lock-in, because the alternative it blocks is the only escape from a partner's accumulation. Pruning one's own segment is a private cost with a shared benefit, a structure familiar from Hardin (1968). The neutral partner needs no malice to impose the ratchet on everyone.

## VI.12. Strongest objections (Part II)

**"A neutral partner would prune if it saw the deadline."** Then it would not be in $`\mathcal U_{\mathrm{fixed}}`$. The prune routine shows the effect: with no seed, CNN survival rises from 0 to 98 of 324 configurations.

**"The adversary is too strong: it sees the cooperative moves."** That is the robust kernel's information structure (I.3.8), the conservative choice. The bounds of Theorems VI.4(c) and VI.5(b) do not use the information, because the adversary's strategy (patch and veto) is fixed in advance.

**"An adversary would simply withhold its segment."** Then nothing survives without a seed already authorized (Theorem VI.5(d)). The covert disturbance set, which excludes withholding, is the one under which the comparison with a neutral partner is informative.

**"Agents could prune each other's segments."** Segment ownership is an assumption. If agent 1 could prune every segment, the shared chain would reduce to Part I's single-agent case.

**"Part II uses one step per crisis, Part I one per tick."** Part II's crisis-level step is justified by the escape lemmas (`esc_viable`, `esc_not_viable`): within a crisis, a transition fits iff its duration does. Part II has no reserves and no partial progress across ticks, and does not distinguish a policy class from the fixed one.

**"The seed bypasses everyone."** By assumption it is a fully independent startup path. Partial bypasses, which skip some segments but not others, are not modeled.

## Conclusion

Successful short-term escape consumes the feasibility of future escape when each escape adds serial recovery latency and the deadline is bounded.

- **Mathematical:** strictly positive accumulation of unavoidable latency exceeds a bounded execution window, by an exact crisis (Theorem VI.1).
- **Constructive:** in the four control classes, three successful patching escapes are followed by a severity-3 state, proved from the modeled transitions (Theorem VI.2 and the reference model).
- **Behavioral:** the patch routine survives 12 crises in 18 of 1,944 configurations, while the adaptive kernel contains the start in 1,555. In 927 the routine passes its adaptive point of no return during an earlier crisis than the one it fails in, while its patches still succeed.
- **Multi-agent:** on a shared chain, one partner whose routine keeps patching imposes the ratchet on the joint system (Theorem VI.4). The result is severity 3, structural, because the routine is organizational. With no seed, replacing that indifferent partner by an adversary changes nothing in 216 of 324 configurations. An independent seed escapes the ratchet; under unanimity an adversary's veto removes it, creating severity 3 (Theorem VI.5).

## The arguments together

| Argument | Question | Core result |
|---|---|---|
| **I. The Paradox** | Why can adaptive organization reduce future adaptability? | Equal resources can conceal different recovery options; a short-horizon rule can select lock-in |
| **II. The Necessity** | When does the rate of adaptation become a survival constraint? | Necessity is a kernel condition; delay cannot restore viability under an unchanged ceiling |
| **III. The Escape** | How can a system find a viable transition before the window closes? | Escape is PSPACE-hard in general but tractable under structure; lock-in requires organizational certificates |
| **V. Concessions and Erosion** | What changes when the horizon or the margin rule varies? | Concessions reverse with the horizon, from severity 1 to severity 3; calm erodes empirical margins until an identical shock becomes fatal |
| **VI. The Escape Ratchet** | When does successful escape consume future escape? | Serial latency accumulated by patching exhausts a bounded deadline; the patch routine passes its adaptive point of no return while patches still succeed; early pruning or an independent seed prevents it. On a shared chain one patching partner imposes the ratchet on all, and a veto over the seed creates severity 3 |

Argument IV is not part of this public release. The numbering is kept so that cross-references stay stable.

## References

- Cardaliaguet, P. (1996). A differential game with two players and one target. *SIAM Journal on Control and Optimization* 34(4), 1441–1460. [DOI](https://doi.org/10.1137/S036301299427223X)
- Gunderson, L. H., and C. S. Holling (eds.) (2002). *Panarchy: Understanding Transformations in Human and Natural Systems*. Island Press. [DOI](https://doi.org/10.2307/jj.41003716)
- Hardin, G. (1968). The tragedy of the commons. *Science* 162(3859), 1243–1248. [DOI](https://doi.org/10.1126/science.162.3859.1243)
- Holling, C. S. (1973). Resilience and stability of ecological systems. *Annual Review of Ecology and Systematics* 4, 1–23. [DOI](https://doi.org/10.1146/annurev.es.04.110173.000245)
- Margellos, K., and J. Lygeros (2011). Hamilton–Jacobi formulation for reach–avoid differential games. *IEEE Transactions on Automatic Control* 56(8), 1849–1861. [DOI](https://doi.org/10.1109/TAC.2011.2105730)
- Tainter, J. A. (1988). *The Collapse of Complex Societies*. Cambridge University Press.
- Tsebelis, G. (2002). *Veto Players: How Political Institutions Work*. Princeton University Press. [DOI](https://doi.org/10.1515/9781400831456)

## Code and reproducibility

- **`Paradox/Ratchet.lean`:** Theorem VI.1 (`latency_growth`, `ratchet_exhaustion`, `ratchet_first_failure`, `ratchet_exact_first_failure`), `margin_exhaustion`, the serial chain (`chain_lower`, `chain_upper`, `chain_min_time`, `chain_grows`, `ratchet_latency`), the single-transition deadline-escape system (`esc_viable`, `esc_not_viable`, `ratchet_lockin_witness`), and `invariant_viable`. No `sorry`, no `native_decide`.
- **`Paradox/RatchetModel.lean`:** the four-class tick-level systems. It contains Proposition 1 (`class_nesting`), `class_ker_iff`, Theorem VI.2 (`blocked_not_viable`, `seed_sustainable`), `orbitOK_sound`, the reference results (`ref_patch_only`, `ref_trajectory`, `ref_lockin`, `ref_no_seed`, `ref_prune_sustainable`) and the exact sweep. No `sorry`, no `native_decide`; the standard axioms only.
- **`ArgVIMain.lean`:** the executable `argVI` writes `results/argVI_output.txt` (Lean only).
- **`Paradox/SharedRatchet.lean`:** Part II. It contains:
  - serial composition (`psum_cat`, `shared_makespan`, `shared_bootstrap`);
  - the robust-kernel lemmas of I.3.8 (`rnesting`, `rviab_det`, `rviab_budget`, `rinvariant`);
  - the joint system (`jrsys`, `jsys`, `kernel_eq`, `a1_null`, `a3_phys`);
  - Theorem VI.3 (`class_nesting_K`, `stance_nesting`);
  - Theorem VI.4 (`shared_ratchet_one`, `shared_ratchet_three`, `two_patchers`, `shared_ratchet_two`, `adversary_ratchet`, `prune_sustainable`, `neutral_lockin`);
  - Theorem VI.5 (`seed_sustainable`, `early_authorization`, `veto_ratchet`, `veto_severity`, `overt_lockin`, `overt_physical`);
  - the reference instance (`ref_one_patcher`, `ref_one_patcher_K`, `ref_neutral_lockin`, `ref_veto`, `ref_unilateral`, `ref_consent`, `ref_overt`).

  No `sorry`, no `native_decide`; axioms `propext` and `Quot.sound` at most.
- **`Paradox/SharedRatchetModel.lean`**, **`ArgVIMain.lean`** (`argVI multi`) and **`python/toy/argVI.py`:** the Part II sweep, using the transition function and admissible actions of the theorems; `python python/crosscheck_all.py argVImulti` compares them line for line.
