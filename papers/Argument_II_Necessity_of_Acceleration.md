# Argument II — On the Necessity of Acceleration

**Subtitle:** *When the Rate of Adaptation Becomes a Survival Constraint*

*Working draft, November 2026. Builds on the formal framework of Argument I (Section I.3) and the climate experiment. Notation follows I.3.*

## Central claim

When a system's environment or accumulated dependencies change faster than its adaptive processes can respond, staying viable can require increasing the rate at which capabilities are built and deployed.

This is a conditional claim about adaptation under deadlines. It is not an endorsement of growth for its own sake. Argument II makes it precise in four steps:

1. **Necessity as a kernel condition.** Acceleration is necessary exactly when some attainable rate ceiling keeps the system viable and the current rate does not (II.4). In terms of the required rate, this means the required rate exceeds the current one, provided the required rate is actually attained.
2. **Delay cannot restore viability under an unchanged ceiling.** Along the incumbent trajectory, and before its first violation, any rate ceiling at or above the current rate that suffices after a year of delay already sufficed before. Once the required rate exceeds the current one, it can only rise while the system waits (Proposition II.1, proved in Lean).
3. **Which acceleration matters depends on which constraint binds.** In the calibrated climate model, cost and spending dominate when costs are high. At lower costs, additional spending buys fewer years because capacity growth and the carbon budget constrain the window (II.2).
4. **The dilemma is about program design, not just speed.** Acceleration without a stopping rule consumes its own margin and closes the window earlier. The same acceleration with a stopping rule does not (II.6).

Claims 1 and 2 are general results within the framework. Claims 3 and 4 are findings of a calibrated, stylized model, and are conditional on its assumptions.

### Earlier work on rates and deadlines

Petschel-Held et al. (1999, §4, Fig. 4) computed feasible combinations of waiting time, transition time and sustained emissions-reduction rate under climate guardrails. Stocker (2013, Box 1 and Figs. 1–2) derived the emissions cuts required after a delayed start and distinguished the deadline under a finite mitigation rate from the limiting deadline if emissions could immediately fall to zero. Iyer et al. (2015, Table 2) varied the date of coordinated climate action and limits on the diffusion of individual low-carbon technologies in an integrated assessment model. The dependence of a climate deadline on the speed of the response is established in all three settings.

Argument II asks how this dependence changes when the system must first build the capacity to deliver the response. Proposition II.1 expresses the delay result for nested classes of admissible schedules along a specified incumbent path. The climate experiment gives the capacity orders a delivery lag and charges them to the same budget as deployment. A successful schedule bounds the last viable start from below. A relaxation that makes capacity expansion free bounds it from above. Their agreement identifies the last viable start for the modeled schedule class at the tested settings.

## II.1. Irreversible history

Organizations do not develop in stationary environments. Their actions change their own boundary conditions: accumulated greenhouse-gas forcing, ocean heat content, resource depletion, specialized infrastructure, technological dependencies, and lost skills.

**Definition II.1 (irreversible component).** A component $`x_i`$ of the physical state is **irreversible over the horizon** if no admissible action in any control class decreases it. That includes the physical class.

Cumulative CO₂ in the climate model is an example. Without carbon removal, nothing lowers it. The model's only route to removal is the expensive top tranche of the cost curve, which merely reaches net zero.

**Irreversible burdens never help.** Order the physical state so that a lower irreversible burden is better. Assume A0, A2 and A4 of Argument I, with the viability conditions upward closed in that order. Then Proposition 4 applies.

**The comparison is cross-sectional.** It holds at the same time, with the same organization and commitments, and with every other physical component equal. The stored policy must also be the same, or Argument I's assumption must hold that switching between the two policies requires no implementation move. In that comparison, a state carrying a heavier irreversible burden lies in no policy-, adapt- or physical-class kernel that the lighter state is outside of. The fixed class is excluded, as in Proposition 4, unless the incumbent policy is itself monotone in the burden.

**This is not a claim that kernels shrink over time.** A year that adds to an irreversible component also changes time, the environment, organization and the other physical components. A system can enter a kernel in a year when its burden grows, if its capacity or abatement grows fast enough. What irreversibility guarantees is narrower and permanent. The added burden can never be undone, so the cross-sectional disadvantage it creates can only be offset by other components, never removed.

**Institutional and physical restoration differ.** Commitments in $`q`$, such as debt, contracts and pending obligations, can in principle be unwound by moves, at a cost and with a latency. Debt can be restructured through institutions. Accumulated physical consequences cannot be cancelled through the same process. In the framework, this is the difference between components of $`q`$ that admissible moves can reset and components of $`x`$ that no action can.

**The system cannot assume its previous organizational arrangement remains viable under its new physical conditions.** Argument I showed that kernel membership can be lost while the system's own measures look healthy. Irreversibility means the physical part of that loss cannot be reversed. It can only be compensated.

## II.2. Four forms of acceleration

| Acceleration | Governing capability | Climate-model parameter |
|---|---|---|
| Economic | capital mobilization, investment | spending ceiling $`\varphi`$ |
| Informational | discovery, learning, modeling | cost scale $`\psi`$ (lower = cheaper abatement) |
| Material | manufacturing, construction | maximum capacity scale-up $`g_{\max}`$ |
| Organizational | coordination, decision and implementation speed | capacity latency $`L`$ |

These rates are coupled, but they are not interchangeable. Investment does not create manufacturing capacity, and discovery does not remove deployment delays.

**Experiment E-II.1: which form buys the most time?** The climate sweep (324 configurations) varies all four. For each one-step change along one axis, holding the others fixed, the table classifies the effect on the 2°C capacity-building closing year. There are 108 adjacent steps per axis, central and robust combined. Mean shift and range are computed only over steps where the window is open both before and after.

| Axis (one step) | Open → open (n) | Mean shift | Range | Never → open | Never → never |
|---|---|---|---|---|---|
| Informational: $`\psi`$ 1.0 → 0.75 → 0.5 | 55 | **+4.5 yr** | +2 to +8 | 26 | 27 |
| Economic: $`\varphi`$ 1.5 → 2 → 3 | 55 | **+4.5 yr** | +2 to +8 | 26 | 27 |
| Material: $`g_{\max}`$ 20 → 30 → 40 %/yr | 66 | +1.0 yr | 0 to +2 | 4 | 38 |
| Organizational: $`L`$ 3 → 2 → 1 yr | 64 | +1.4 yr | +1 to +2 | 6 | 38 |

No step on any axis closes an open window.

**A "step" is a property of the grid, not of the world.** It means a 33–50% relative change in $`\varphi`$, $`\psi`$ or $`g_{\max}`$, and a one-year change in $`L`$. Comparing steps across axes does not compare real-world difficulty or cost. Where the real scale-up ceiling lies is an empirical question. Historical energy-technology scale-ups (Wilson & Grubler 2011) are the natural reference for calibrating it, which the present grid does not yet do.

**Two findings, and one limitation.**

- **Cost and spending are nearly interchangeable in this model.** They enter almost entirely through their ratio $`\varphi/\psi`$, and the steps tested have equal ratios. Halving costs buys about what doubling spending buys. This is a limitation of the model, not a fact about the world: real cost reductions and real spending increases have different second-order effects, which the model does not represent.
- **The binding constraint shifts.** Averages hide a regime change.
  - **High costs ($`\psi=1`$).** Raising spending from 2 to 3 moves the closing year from 2029 to 2037, eight years.
  - **NZE-consistent costs ($`\psi=0.5`$).** The same spending step buys three years (2040 to 2043). Holding spending at 2, cutting costs by a further 20% buys two years (2040 to 2042).
  - At lower costs, deployment capacity and the carbon budget constrain how far additional spending can extend the deadline.

  The most valuable form of acceleration is the one acting on whichever constraint currently binds. Liebig's law of the minimum, applied to rates, is a fair summary.
- **No learning-by-doing.** Real abatement costs fall with cumulative deployment (Wright's law), coupling material acceleration to informational acceleration. The model holds costs fixed, so it may understate that particular benefit of material and organizational acceleration. This does not establish the direction of the model's total bias, given the other costs and feedbacks it omits.

**Sources and assumptions for the calibration.** The reported deadlines are sensitive to the cost and spending inputs. The climate companion gives the source and interpretation of each input.

| Quantity | Status |
|---|---|
| 2026 emissions of 43.3 GtCO₂ and carbon budgets of 510 and 1,035 GtCO₂ | Full-year emissions projection and assessed budgets from January 2027 (Global Carbon Budget 2026) |
| TCRE and its likely range | assessed (IPCC AR6) |
| Clean-energy investment of about $2.2 trillion in 2026 | Full-year estimate (IEA *World Energy Investment 2026*) |
| Data-centre electricity of 415 TWh in 2024 and 17% growth in 2025 | IEA estimates (2025, 2026) |
| Initial deployment capacity of 0.75 Gt/yr per yr | Assumed starting value informed by Ember’s estimate of annual generation from new capacity and an assumed rate of emissions displacement. [Climate companion, calibration](Climate_Experiment.md#calibration) |
| Cost curve $`n(f)`$ | **assumed** functional form, fitted to two anchors |
| Cost scale $`\psi`$ | **uncertain calibration parameter**, not a measured technology cost |
| Conversion of dollars into abatement | **assumed** |

The IPCC finding is that options costing $100/tCO₂-eq or less could at least halve global emissions from 2019 levels by 2030. It does not determine the exponential global marginal-cost curve used here. The IEA's $2.2 trillion spans grids, nuclear, efficiency, electrification, renewables and storage, not a single pool of interchangeable abatement spending. The conversion from dollars to deployed abatement is therefore a structural assumption, and $`\psi`$ is swept rather than estimated. Results that depend mainly on $`\psi`$ or $`\varphi`$ inherit this uncertainty.

## II.3. Competing clocks

Define, for a threatened viability condition:

- $`\tau_{\mathrm{margin}}`$: time before the condition is violated if nothing changes.
- $`\tau_{\mathrm{discover}}`$: time to identify a workable intervention.
- $`\tau_{\mathrm{engineer}}`$: time to make it implementable.
- $`\tau_{\mathrm{reorganize}}`$: time to establish the capability needed to execute it.
- $`\tau_{\mathrm{deploy}}`$: time for the intervention to produce its physical effect.

These stages overlap, so their total is not a simple sum.

Van Zalinge et al. (2017, §2.3 and Fig. 1) distinguished the delay between a policy decision and a reduction in emissions from the further delay before greenhouse-gas concentration falls. The distinction here concerns the deadline for each stage of an intervention. In particular, a stage already represented in the kernel calculation has already been allowed for in the last viable start.

**Definition II.2 (effective intervention time).** Represent an intervention plan as a directed acyclic graph of stages. Each stage has a duration, precedence constraints and resource requirements, such as a manufacturing line, a specialist team or a budget. Its effective time $`\tau_{\mathrm{eff}}`$ is the **makespan** of the resource-constrained scheduling problem: the shortest time in which all stages can finish, respecting both precedence and resource capacities.

The dependency-only critical path (Kelley & Walker 1959) is a lower bound:
```math
\tau_{\mathrm{eff}}\ \ge\ \tau_{\mathrm{CP}}.
```
It is tight only when resources are sufficient. Two independent two-year tasks have a critical path of two years. If both need the same single manufacturing line, the makespan is four years. Reorganizing the informational dependencies cannot remove a physical production bottleneck, which is exactly the constraint this theory is about.

Using the lower bound in a necessary condition stays valid: if even $`\tau_{\mathrm{CP}}`$ misses a deadline, the plan is infeasible. Using the makespan gives the sharper test.

**Link to the kernels: three clocks, not one.** The kernels already contain the stages that the model represents. The organizational margin of Argument I,
```math
\mu(s,t)=t^*_{\mathrm{adapt}}(s,t)-t,
```
is the time left to **initiate** an adapt-class response. Reorganization and deployment are priced into $`t^*_{\mathrm{adapt}}`$ by the dynamics. At $`t=t^*_{\mathrm{adapt}}`$, $`\mu=0`$, and yet the response is still feasible, although it takes years to complete. Comparing the full critical path against $`\mu`$ would count those stages twice.

The three clocks are:

1. **Initiation clock.** Stages the model does not represent, such as discovery, engineering and decision lag, must finish before the window to initiate closes:

   $`\displaystyle \tau_{\mathrm{pre}}\le\mu(s,t).`$

2. **Capability-readiness clock.** Suppose the system stays on its baseline until the new capability is ready. Then the capability must be ready before the physical deadline $`t^*_{\mathrm{phys}}`$, in the climate model the capacity-unconstrained deadline, after which no deployment can rescue the system:

   $`\displaystyle \tau_{\mathrm{pre}}+\tau_{\mathrm{reorganize}}\le t^*_{\mathrm{phys}}(s,t)-t.`$

   This bound excludes deployment time. It is a different bound from the initiation clock, not an equivalent form of it.
3. **Completion clock, for threshold interventions only.** If an intervention protects only once it is complete (all-or-nothing), its full critical path must finish before the violation:

   $`\displaystyle \tau_{\mathrm{eff}}\le\tau_{\mathrm{margin}}=t_{\mathrm{fail}}-t.`$

   For interventions whose effect builds up as they are deployed, this bound is **not** necessary. Partial deployment bends the trajectory before the violation and can push it off the horizon. In the climate model at NZE-consistent central settings, the baseline first exceeds the 2°C budget in 2054. Yet a viable 5%/yr program started in 2027 keeps deploying until it reaches net zero in 2062. For such interventions, the kernel itself is the test.

All three are necessary conditions within their scope, not sufficient ones: meeting a deadline does not guarantee the effect is large enough.

**Which accelerations help.** Accelerating an activity improves completion time only if it changes the resource-constrained optimal schedule or one of its binding constraints. The precedence critical path alone does not identify every useful acceleration.

Take two independent tasks sharing one manufacturing machine: A takes two years and B takes one. The dependency-only critical path is two years (task A), but the makespan is three. Speeding up B to six months cuts the makespan to 2.5 years, although B was never on the critical path, because B holds the bottleneck resource. Under resource constraints, relieving a shared production bottleneck can matter as much as shortening the dependency chain. This is the material-acceleration point of II.2 and II.7 in scheduling form.

**In the climate model:**

- $`\tau_{\mathrm{reorganize}}`$ is the capacity latency $`L`$.
- $`\tau_{\mathrm{deploy}}`$ is set jointly by capacity growth and spending.
- Both are inside the dynamics, so they are already priced into $`\mu`$. Abatement accumulates gradually, so the threshold completion clock does not apply.
- $`\tau_{\mathrm{pre}}`$ is zero: the technologies exist, and decision lag is not modeled. Any real decision lag must therefore fit inside $`\mu`$: at most 13 years from 2027 at NZE-consistent costs.

Cutting $`L`$ from 3 years to 1 moves the 2°C closing year by about 1.4 years per step (E-II.1), because latency binds the schedule for only part of the trajectory.

## II.4. The necessity condition

**Definition II.3 (rate-bounded classes).** For a ceiling $`r`$, let $`\mathcal U_r`$ be the class of capacity schedules whose growth never exceeds $`r`$ in any year. Schedules may vary over time. $`\mathcal U_r\subseteq\mathcal U_{r'}`$ whenever $`r\le r'`$. Write $`\mathcal K_r(t)`$ for the kernel of $`\mathcal U_r`$.

**Definition II.4 (required rate).** For a state $`s`$ at time $`t`$:
```math
r_{\mathrm{req}}(s,t)=\inf\{r:\ s\in\mathcal K_r(t)\},
```
which is $`+\infty`$ if no finite rate suffices.

**Definition II.5 (necessity of acceleration).** Let $`r_0`$ be the incumbent's rate and $`r_{\mathrm{cap}}`$ the highest attainable rate. Acceleration is **necessary** at $`(s,t)`$ if
```math
s\in\mathcal K_{r_{\mathrm{cap}}}(t)\setminus\mathcal K_{r_0}(t).
```
Some attainable rate works, and the current one does not. By nesting, this implies $`r_0\le r_{\mathrm{req}}(s,t)\le r_{\mathrm{cap}}`$. Stating it with kernels avoids the edge case where the infimum $`r_{\mathrm{req}}=r_{\mathrm{cap}}`$ is not attained.

This condenses the four conditions of the original outline:

- "No trajectory at the current rate works" and "no slower trajectory achieves the same result" together say $`s\notin\mathcal K_{r_0}(t)`$.
- "Some faster trajectory works" and "the additional capability can actually be developed in time" together say $`s\in\mathcal K_{r_{\mathrm{cap}}}(t)`$.

Latency is already built into the dynamics.

**Proposition II.1 (delay never lowers the required rate).** This is a direct consequence of the viability-kernel framework: monotone loss applied to nested rate classes. It is not presented as a new mathematical principle. The contribution is its application to deadlines for building capability. Formally: Suppose the classes are nested ($`r\le r'\Rightarrow\mathcal U_r\subseteq\mathcal U_{r'}`$) and the incumbent's step is admissible at its own rate $`r_0`$. In the climate model it is: the incumbent spends at $`\varphi_{\mathrm{inc}}=1\le\varphi`$, and spending below the ceiling is admissible. Then for every ceiling $`r\ge r_0`$, every state $`s\in\mathcal V`$, and every $`t\lt T`$:
```math
b(s)\in\mathcal K_r(t+1)\ \Longrightarrow\ s\in\mathcal K_r(t),
```
where $`b(s)`$ is the state after one year of incumbent operation.

*Proof.* The incumbent step is admissible in $`\mathcal U_{r_0}\subseteq\mathcal U_r`$. Apply Proposition 3 (monotone loss) of Argument I to the class $`\mathcal U_r`$. $`\square`$

The proof is machine-checked: `Theory.delay_never_lowers_required_rate` and `Theory.rate_upward` in the Lean project.

**The nesting assumption is substantive.** It holds when the environment reacts to the actions a system takes. It can fail when the environment reacts to the ceiling a system holds, whether or not it uses it: antitrust scrutiny triggered by capacity, or a rival arming in response to capability. Then a move available under ceiling $`r`$ can have a different outcome under $`r'\gt r`$, so $`\mathcal U_r\not\subseteq\mathcal U_{r'}`$. A higher ceiling can then shrink the kernel, and Proposition II.1 holds only within a range of ceilings where nesting holds. Lean gives a three-state counterexample (`Theory.cap_not_nested`, `Theory.cap_kernel_shrinks`, `Theory.rate_upward_needs_nesting`). In the climate model, the ceiling only limits which growth rates may be chosen. The dynamics depend on the rate actually used, never on the ceiling, so nesting holds.

**Corollary II.1.** Along the incumbent trajectory, for $`t\lt t_{\mathrm{fail}}`$:

- $`\max\bigl(r_0,\ r_{\mathrm{req}}(s_t,t)\bigr)`$ is nondecreasing in $`t`$. Equivalently, once $`r_{\mathrm{req}}`$ exceeds $`r_0`$, it never falls.
- For each ceiling $`r\ge r_0`$, the set of start years from which rate $`r`$ still works is an initial segment, ending at $`\tau^*(r)=t^*_{\mathcal U_r}`$.

The guards matter:

- **Unchanged ceiling, incumbent trajectory.** The statement concerns one fixed ceiling $`r\ge r_0`$, along the specified incumbent trajectory, under a known environment path. It does not say that delaying *any* intervention is harmful.
- **Rates below the incumbent's.** Proposition II.1 says nothing about ceilings below $`r_0`$. A year of incumbent growth can build enough capacity that a lower rate suffices afterwards, so $`r_{\mathrm{req}}`$ itself can fall *to* or *below* $`r_0`$.
- **After a violation.** As with Proposition 3, re-entry after a violation is not covered.

Within these guards, waiting can turn a modest required acceleration into an unattainable one, but never the reverse.

**Relation to rate-induced tipping.** A sufficiently rapid change in an external parameter can drive a system away from the attracting state it would track under slower change (Wieczorek et al. 2011, Ashwin et al. 2012). In Proposition II.1 the environment path is fixed. The rate being varied is a ceiling on the system's admissible responses. The proof uses the fact that a viable response available after waiting can be preceded by one admissible incumbent step. This argument applies even to a system with no attractor or bifurcation.

**In the climate model** (central 2°C, NZE-consistent costs, $`\varphi=2`$, $`L=2`$), we test annual ceilings at one-percentage-point intervals. A failed free-expansion relaxation excludes every schedule under that ceiling. A successful grow-while-binding program supplies a viable schedule at its stated rate.

| Start year | 2027 | 2030 | 2033 | 2035 | 2037 | 2038 | 2039 | 2040 | 2041 | 2042 | 2043 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Highest tested ceiling excluded for all schedules | 4% | 5% | 7% | 8% | 11% | 14% | 17% | 23% | 33% | 56% | 100% |
| Lowest tested rate with a viable program | 5% | 6% | 8% | 9% | 12% | 15% | 18% | 24% | 34% | 57% | none ≤100% |

In 2027, a ceiling of 4%/yr or lower excludes every schedule, even with the increased spending allowance. A 5%/yr program succeeds. The incumbent's 2% ceiling is therefore insufficient. At the attainable ceiling of 30% the last viable start is 2040. By 2041, even the relaxation fails at 33%. These comparisons isolate capacity acceleration by giving both sides the same spending ceiling.

The exact continuous minimum may lie between grid points. The lowest witnessed rate in the 1% scan is nondecreasing on each of the 18 tested baselines, treating the absence of a witness as above the scan. Proposition II.1 applies to the full nested ceiling classes independently of this numerical observation.

**What sets the deadline (E-II.5).** The climate viability criterion has two parts: stay within the carbon budget, and reach net zero by 2087. An ablation recomputes every closing year with only the budget constraint, across the 18 headline settings (2°C; central and robust; $`\psi\in\{0.5,0.75,1\}`$; $`\varphi\in\{1.5,2,3\}`$; $`g_{\max}=30\%`$; $`L=2`$).

- **The closing years do not change in any of the 18 settings,** for capacity building, for the certificate, or for the capacity-unconstrained class.
- **The binding constraint is the budget.** At the first excluded year, the dominant program fails by breaching the budget before 2087 in every setting, never by missing net zero.

The ablation attributes these 18 closing years to accumulated emissions. The net-zero condition matters only for the myopic paths of the climate experiment. There, dropping it lowers the carbon price at which the myopic path keeps its window by one grid step at the two lower cost scales ($100 → $75/t, $200 → $175/t), and leaves it unchanged at $`\psi=1`$ ($300/t). Part of even that drop is horizon truncation: a stalled path can stay within budget through 2087 while still emitting afterwards. At $`r=g_{\max}`$, the free-expansion certificate shows the constant-rate closing year equals the all-schedule one in every configuration.

## II.5. Application: industrial civilization and AI

The coupled infrastructure stack — energy, computation and communications, industrial production, institutional coordination — is the obvious large-scale application. Its relevant constraints include:

- the energy requirements of computational infrastructure;
- climate forcing and infrastructure exposure;
- concentration of semiconductor manufacturing;
- replacement times for specialized equipment;
- dependencies on communication and control systems;
- how quickly human expertise can be regenerated.

For each, the framework demands three separate questions: Is the dependency observed? Is a failure mechanism plausible? Is loss of viability demonstrated? Almost every item above is established on the first, arguable on the second, and undemonstrated on the third. Argument II does not claim otherwise.

**AI is both an accelerator and a margin consumer.** It can accelerate discovery, engineering and coordination, which lowers costs and latencies. It also consumes margin through energy demand. The International Energy Agency projects data-centre electricity rising from about 415 TWh in 2024 to about 945 TWh in 2030. Demand grew 17% in 2025 (IEA 2025, 2026).

**Experiment E-II.3.** AI demand enters the no-new-deployment emissions path:
```math
E_t=\bigl(E_{\mathrm{ref}}(t)+E_{\mathrm{AI}}(t)\bigr)(1-f_t).
```
$`E_{\mathrm{ref}}+E_{\mathrm{AI}}`$ also replaces $`E_{\mathrm{ref}}`$ in the spending and capacity constraints on deployment. AI emissions are therefore abatable at the same cost and depth as everything else.

New AI demand also inherits the existing abated share $`f_t`$, as background drift does. Treating new AI demand as initially fossil-powered would widen the demand penalty somewhat, so the results here are mildly favorable to AI.

**Accounting.** The drift $`\gamma`$ in $`E_{\mathrm{ref}}`$ is calibrated to the recent emissions trend, which already includes data-centre growth of the past decade. $`E_{\mathrm{AI}}`$ is meant as the increment **above** that trend. Adding the full IEA growth on top of $`\gamma`$ therefore counts some growth twice, which makes the IEA-base-like scenario an upper bound on incremental demand at base.

The conversion from electricity to emissions is: $`945-415=530`$ TWh of added demand by 2030, times an assumed intensity of about 0.4 tCO₂/MWh (roughly a global-average grid; assumed, not sourced here), gives about 0.2 Gt/yr. The high and extreme scenarios scale this. $`E_{\mathrm{AI}}`$ ramps linearly from zero in 2026 to its 2030 value, then to its 2035 value, and stays flat after. Settings: $`g_{\max}=30\%`$, $`L=2`$. The scenarios:

| Scenario | 2030 | 2035 |
|---|---|---|
| none | 0 | 0 |
| IEA-base-like | +0.2 Gt/yr | +0.3 Gt/yr |
| high | +0.6 Gt/yr | +1.2 Gt/yr |
| extreme | +1.5 Gt/yr | +3.0 Gt/yr |

AI's possible benefit is represented as a cut in transition costs of 0–20%. The table gives the 2°C capacity-building closing year (central climate response, $`\varphi=2`$). Every cell's closing year is exact over all schedules: the certificate agrees in all 40.

| Cost scale | Demand scenario | No cut | 2.5% | 5% | 10% | 20% |
|---|---|---|---|---|---|---|
| $`\psi=0.5`$ | none | 2040 | 2040 | 2041 | 2041 | 2042 |
| | IEA-base-like | 2040 | 2040 | 2040 | 2041 | 2041 |
| | high | 2039 | 2039 | 2039 | 2040 | 2040 |
| | extreme | 2037 | 2037 | 2037 | 2038 | 2039 |
| $`\psi=0.75`$ | none | 2035 | 2036 | 2036 | 2037 | 2038 |
| | IEA-base-like | 2035 | 2035 | 2036 | 2037 | 2038 |
| | high | 2034 | 2034 | 2035 | 2035 | 2037 |
| | extreme | 2032 | 2032 | 2033 | 2034 | 2035 |

**Reading the table.**

- **IEA-base-like demand** shifts the last viable start by zero or one year relative to the corresponding no-demand case.
- **High demand costs about a year, extreme demand about three.**
- **Cost cuts can offset high demand.** A 10% cut restores the no-demand, no-cut closing year at both cost scales for the high scenario. Under extreme demand at NZE-consistent costs, a 20% cut extends the window to 2039, one year short of the 2040 reference.
- **Cost cuts buy more time when initial costs are higher.** Under no added demand a 20% cut buys three years at $`\psi=0.75`$ and two at $`\psi=0.5`$.

Whether AI is net-positive for a climate window is therefore not settled by its energy demand alone. It depends on which constraint AI relieves, and whether that constraint is the binding one. AI that raised the attainable scale-up rate or cut latencies would act on different levers than AI that only cut costs. The model can evaluate any such claim once it is quantified, but cannot supply the quantities.

None of this addresses the larger question in the original outline: whether deploying increasingly capable AI changes civilizational constraints faster than restoration capacity develops. That needs the restoration-independence measurements of Argument III, and remains open.

## II.6. The acceleration dilemma

| Strategy | In framework terms | In the climate model |
|---|---|---|
| **Stopping** | rate 0; spending at or below incumbent | never viable for 2°C |
| **Slowing** | rate below the incumbent's | no more viable than the incumbent: by nesting (`rate_upward`), $`\mathcal K_{r}\subseteq\mathcal K_{r_0}`$ for $`r\lt r_0`$ |
| **Continuing unchanged** | incumbent rate $`r_0`$ | not viable for 2°C from 2027 ($`\sigma\ge2`$; $`\sigma=2`$ in the NZE-consistent central case) |
| **Selective acceleration** | rates and program designs inside the viable window | viable until the window closes |

None of these is universally doomed or universally successful. Each is evaluated against a stated system, horizon and criterion.

**Slowing remediation and slowing pressure are different.** The rate $`r`$ in this table is the growth rate of **adaptive capability**: deployment capacity. Slowing that rate shrinks the admissible class and cannot help when $`r_{\mathrm{req}}\gt r_0`$. The case made by advocates of degrowth or an AI pause is usually about slowing **pressure-generating activity**: the growth of $`E_{\mathrm{ref}}`$, or AI demand. That acts on the environment path, not the control class, and it lowers $`r_{\mathrm{req}}`$. E-II.3 shows it directly: going from extreme AI demand to none extends the 2°C window by three years. The framework supports slowing pressure where it lowers the required rate, and accelerating capability where the required rate exceeds the current one. These are not in conflict.

**Acceleration consumes margin.** Faster capability building is not free: it draws resources from the deployment it is meant to enable. The relevant object is therefore not a single rate but a window of viable programs:
```math
\mathcal R(s)=\{\text{program parameters } \theta:\ \text{the program from } s \text{ is viable}\}.
```
The outline's condition becomes a non-emptiness condition. For one-parameter families of growth rates, it is $`r_{\mathrm{req}}\le r_{\max}`$, where $`r_{\max}`$ is the highest viable rate. Whether $`r_{\max}`$ exists at all depends on the program family.

**Experiment E-II.2: stopping rules.** Two program families, under three capacity costs $`c_{\mathrm{cap}}`$. Settings: 2°C central, $`\psi=0.5`$, $`\varphi=2`$, $`L=2`$. Viable rates are scanned on a grid up to 100%/yr, the top of the tested range. The closing year allows rates up to $`g_{\max}=30\%`$.

| $`c_{\mathrm{cap}}`$ (<span>$</span>T per Gt/yr per yr) | Program | Viable rates from 2027 | Window closes |
|---|---|---|---|
| 0.3 | grow while capacity binds | 5%–100% | 2040 |
| 0.3 | grow forever | 5%–**13%** | 2038 |
| 1.0 | grow while capacity binds | 5%–100% | 2040 |
| 1.0 | grow forever | 5%–**10%** | 2036 |
| 3.0 | grow while capacity binds | 5%–**63%** | 2040 |
| 3.0 | grow forever | 5%–**8%** | 2034 |

**Acceleration with no stopping rule overbuilds.** Programs that keep growing capacity long after it can be used develop an upper rate limit, and their windows close two to six years earlier. Their overbuilt capacity diverts spending from deployment. The same acceleration with a stopping rule shows no upper limit within the tested range (up to 100%/yr) at moderate capacity costs. That does not establish that none exists beyond it.

**Start date and compounding.** At $`c_{\mathrm{cap}}=0.3`$, the grow-forever program succeeds from 2027 at tested rates of 5–13%. From 2038, 15% works. A program started later has fewer years in which accumulated capacity orders can exhaust spending. Proposition II.1 concerns the full class of schedules allowed under a ceiling. A prescribed grow-forever rule can gain viability with delay.

Selective acceleration therefore has two parts: **which** capabilities to accelerate (II.2: the binding ones) and **when to stop** (E-II.2). The dilemma is a question of program design as much as of speed.

The model does not include acceleration costs that act on the viability constraint directly. Examples are embodied emissions from building capacity, or rebound effects in which efficiency raises demand (Jevons). These would add further upper limits. They are left as extensions.

## II.7. The physical-atom constraint

A technological discovery is not a deployed solution. The climate model makes this concrete in two ways that pull against each other:

- **Capacity is necessary.** Across all 324 configurations, raising spending while keeping the incumbent capacity-growth rule never keeps a target viable. The baseline already grows capacity at up to 2%/yr.
- **Capacity's maximum growth rate is not the main lever at the margin.** Once capacity can grow, raising the scale-up ceiling from 30% to 40% per year buys about a year, while cost and spending can buy several (E-II.1).

So the atom constraint binds as a **necessity**: there must be deployment capability. It does not, in this calibration, bind as the **dominant margin**, where cost and the carbon budget take over. A discovery that cut costs sharply would matter most when costs are high, and least when capacity growth already binds.

Learning-by-doing would couple these: building capacity faster would also cut costs. The model omits that coupling, so it may understate this particular benefit of material acceleration. The net direction of bias is not established.

## II.8. Strongest objections

**"Why must AI provide the acceleration?"** It need not. Argument II's results concern rates of capability building in general. AI is one candidate accelerator, and E-II.3 shows its net effect on a climate window depends on magnitudes that have to be estimated, not assumed. At IEA-base demand, AI neither closes nor opens the 2°C window by more than about a year in this model, unless it substantially cuts costs or raises capacity growth.

**"Can existing technologies and institutions achieve the required transitions?"** The central 2°C headline model admits a viable 5%/yr program from 2027. Its relaxed upper bound excludes any ceiling of 4%/yr or lower. From 2040 the corresponding figures are 24% and 23%. The 30% ceiling first becomes insufficient in 2041. Whether a particular institution can realize any of those programs requires evidence about its deployment capacity and spending.

**"Doesn't acceleration increase pressure faster than it builds adaptation?"** It can. E-II.2 shows acceleration without a stopping rule closing the window earlier. The framework treats this as the dilemma's central question, answered by computing the viable program window $`\mathcal R(s)`$, not by assumption.

**"Isn't slowing down the answer?"** Lowering the ceiling on capacity orders removes admissible schedules. Spending less on a particular order can still help by freeing money for current deployment, as the stopping-rule comparison in II.6 illustrates. Slower growth in energy demand can also preserve time to act under the assumptions of E-II.3.

**"Are climate disruption, civilizational collapse and extinction being conflated?"** No. Every result is relative to an explicit viability criterion. The climate experiment uses carbon budgets for stated temperature limits, not collapse. Severity and closing years are statements about those criteria only.

**"What evidence establishes a deadline?"** The closing years are model-conditional, and are reported as tables over costs, spending, scale-up and latency. The ablation (E-II.5) shows they are set by the carbon budget, not by the 2087 net-zero condition. They depend most on $`\psi`$ and $`\varphi`$, the least empirically identified parameters. Proposition II.1 is general: whatever the deadline is, waiting can only move it closer. The evidence standard of I.3.7 applies. Closing years in the climate model are exact over all capacity schedules, but they inherit the model's simplifications.

**"Is the claimed necessity conditional or universal?"** Conditional. Definition II.5 defines necessity for a specified system, horizon, uncertainty set and criterion. The climate model gives one calibrated instance: 2°C, central climate response, $`\psi=0.5`$, $`\varphi=2`$, $`g_{\max}=30\%`$, $`L=2`$. There, necessity holds from 2027 to 2040. It is not universal even within the model: in 9 of the 81 central configurations, no attainable rate works from 2027.

## Conclusion

The critical quantity is not the rate of economic growth or technological discovery in isolation. It is the rate at which a system can build physically realizable, organizationally executable capability, relative to the rate at which its viability constraints change.

Four results anchor that claim:

- **Necessity is a kernel condition.** Acceleration is necessary exactly when some attainable rate ceiling keeps the system viable and the current rate does not.
- **Delay cannot restore viability under an unchanged ceiling.** Along the incumbent trajectory, once the required rate exceeds the current one, it can only rise while the system waits (Proposition II.1, machine-checked).
- **The valuable acceleration is the one acting on the binding constraint.** Which constraint binds shifts as conditions change.
- **How you accelerate matters as much as how fast.** Acceleration that never stops overbuilds, consumes its own margin and closes the window earlier.

**Acceleration is an instrument. Viability is the objective.** The appropriate rate changes as the binding constraint shifts. Once it shifts, continuing to accelerate the previous capability can shrink the viable set rather than expand it, as the stopping-rule experiment shows.

**Argument II establishes when insufficient adaptation speed becomes a structural problem, and how to measure it.** Argument III asks how to keep the required rate within reach: which reorganizations, built in which order, keep the window open.

## Appendix A. Why the climate closing years are exact: the dominance argument

The climate experiment reports closing years that are exact over **all** capacity schedules. The argument has two sides.

**Lower bound (witnesses).** Constant-rate "grow while binding" programs are admissible. When one is viable from a state, that state is in the kernel. These programs are simulated directly.

**Upper bound (certificate).** Define a relaxed program $`\mathcal P^\star`$: capacity expansion is free ($`c_{\mathrm{cap}}=0`$), it orders $`u_t=g_{\max}D_t`$ every year unconditionally, and it deploys the maximum its capacity and spending allow. On states with the same $`t`$, define the dominance relation
```math
s'\succeq s\iff f'\ge f,\quad C'\le C,\quad D'\ge D,\quad \text{pipe}'\ge\text{pipe (entrywise)}.
```

**Claim.** If $`s'\succeq s`$, then for every admissible step of the real model from $`s`$ (any capacity order $`u\le g_{\max}D`$, any deployment up to its limits, spending $`Y_t-c_{\mathrm{cap}}u`$), the step of $`\mathcal P^\star`$ from $`s'`$ reaches a state that dominates the real step's result.

*Proof, component by component.*

- **Cumulative emissions.** $`C_{t+1}=C_t+E_{\mathrm{ref}}(t)(1-f_t)`$. Since $`f'\ge f`$ and $`C'\le C`$, we get $`C'_{t+1}\le C_{t+1}`$.
- **Capacity.** For $`L>1`$, the next capacity adds the first outstanding order, which is at least as large in the relaxation. For $`L=1`$, the queue is empty and this year's order enters next year's capacity directly. The relaxation orders $`g_{\max}D'\ge u`$ in that case.
- **Pipeline.** For $`L>1`$, the relaxation appends $`g_{\max}D'\ge g_{\max}D\ge u`$ after shifting the existing orders. Dominance holds entrywise. At $`L=1`$, both queues remain empty.
- **Depth.** The real step reaches at most $`\min\{G(f,\,Y_t-c_{\mathrm{cap}}u),\ f+D/E_{\mathrm{ref}}(t+1),\ 1\}`$. Here $`G(f,Y)`$ is the deepest depth affordable from $`f`$ with budget $`Y`$, defined by $`E_{\mathrm{ref}}(t+1)\int_f^{G}c=Y`$. Because the capex density satisfies $`c\gt 0`$ on $`[0,1]`$ (since $`n(0)+s=\$50`$/t), $`G`$ is increasing in $`f`$, with $`\partial G/\partial f=c(f)/c(G)\gt 0`$, and nondecreasing in $`Y`$. $`\mathcal P^\star`$ reaches $`\min\{G(f',Y_t),\ f'+D'/E_{\mathrm{ref}}(t+1),\ 1\}`$, and each term is at least the corresponding term for the real step. So $`f'_{t+1}\ge f_{t+1}`$.

Both viability conditions, $`C\le B`$ and terminal $`f=1`$, are upward closed under $`\succeq`$. By the simulation theorem (`Theory.viab_sim`, with $`R={\succeq}`$), if $`\mathcal P^\star`$ fails from $`s`$, every schedule of the real model fails from $`s`$. $`\square`$

Maximal deployment within the real model is not needed for the certificate. $`\mathcal P^\star`$ dominates every deployment level directly. The capacity spending that competes with deployment in the real model is exactly what $`\mathcal P^\star`$ removes, so that competition cannot let a real schedule beat it.

**Exactness.** In every reported configuration, the latest year with a witness equals the latest year the certificate does not exclude: 324 of 324 rate-window configurations, 576 of 576 paradox histories, and 40 of 40 AI cells. The closing years are therefore exact over all schedules of the model.

**What is and is not machine-checked.** `viab_sim` is proved in Lean for abstract systems. The step-level hypotheses above, that $`\mathcal P^\star`$ simulates the real model under $`\succeq`$, are proved here on paper and checked numerically. They are not formally verified against the Float implementation in `Climate.lean`.

## Appendix B. The Lean statements behind Argument II

The theorems are stated for an abstract system $`\langle\mathrm{step},V\rangle`$:

```lean
def Viab {S : Type} (sys : Sys S) : Nat → Nat → S → Prop
  | 0, _, s => sys.V s
  | n + 1, t, s => sys.V s ∧ ∃ s', sys.step t s s' ∧ Viab sys n (t + 1) s'

def K {S : Type} (sys : Sys S) (T t : Nat) (s : S) : Prop := Viab sys (T - t) t s

theorem rate_upward {S R : Type} [LE R] (step : R → Nat → S → S → Prop) (V : S → Prop)
    (hnest : ∀ r r', r ≤ r' → ∀ t s s', step r t s s' → step r' t s s')
    {r r' : R} (hr : r ≤ r') :
    ∀ T t s, K ⟨step r, V⟩ T t s → K ⟨step r', V⟩ T t s

theorem delay_never_lowers_required_rate {S R : Type} [LE R]
    (step : R → Nat → S → S → Prop) (V : S → Prop)
    (hnest : ∀ r r', r ≤ r' → ∀ t s s', step r t s s' → step r' t s s')
    (r0 : R) (b : Nat → S → S) (hb : ∀ t s, step r0 t s (b t s))
    {r : R} (hr : r0 ≤ r) {T t : Nat} {s : S} (hT : t < T) (hVs : V s) :
    K ⟨step r, V⟩ T (t + 1) (b t s) → K ⟨step r, V⟩ T t s
```

Neither theorem uses `sorry` or `native_decide`. `rate_upward` depends on no axioms. `delay_never_lowers_required_rate` depends only on `propext` and `Quot.sound`, through `omega`.

**Correspondence notes.**

- **Terminal set.** Lean's `K` has no separate terminal set: $`\mathcal W=\mathcal V`$. The climate model adds a terminal net-zero condition. The proofs extend by changing only the base case, but that extension is not formalized. The ablation (E-II.5) shows the closing years are unchanged without the terminal condition.
- **Nesting hypothesis.** `hnest` holds for the rate classes $`\mathcal U_r`$ by construction: any schedule with growth at most $`r`$ has growth at most $`r'\ge r`$.
- **Incumbent hypothesis.** `hb` corresponds to the incumbent step being admissible in $`\mathcal U_{r_0}`$, as noted under Proposition II.1.
- **Instantiation.** The Float implementation is not proved to instantiate `Sys`. The correspondence is by construction and numerical cross-checking.

## References

- Ashwin, P., S. Wieczorek, R. Vitolo, and P. Cox (2012). Tipping points in open systems: bifurcation, noise-induced and rate-dependent examples in the climate system. *Philosophical Transactions of the Royal Society A* 370, 1166–1184. [DOI](https://doi.org/10.1098/rsta.2011.0306)
- Iyer, G., N. Hultman, J. Eom, H. McJeon, P. Patel, and L. Clarke (2015). Diffusion of low-carbon technologies and the feasibility of long-term climate targets. *Technological Forecasting and Social Change* 90, 103–118. [DOI](https://doi.org/10.1016/j.techfore.2013.08.025)
- Petschel-Held, G., H.-J. Schellnhuber, T. Bruckner, F. L. Tóth, and K. Hasselmann (1999). The Tolerable Windows Approach: Theoretical and Methodological Foundations. *Climatic Change* 41, 303–331. [DOI](https://doi.org/10.1023/A:1005487123751)
- Stocker, T. F. (2013). The Closing Door of Climate Targets. *Science* 339, 280–282. [DOI](https://doi.org/10.1126/science.1232468)
- van Zalinge, B. C., Q. Y. Feng, M. Aengenheyster, and H. A. Dijkstra (2017). On determining the point of no return in climate change. *Earth System Dynamics* 8, 707–717. [DOI](https://doi.org/10.5194/esd-8-707-2017)
- Wieczorek, S., P. Ashwin, C. M. Luke, and P. M. Cox (2011). Excitability in ramped systems: the compost-bomb instability. *Proceedings of the Royal Society A* 467, 1243–1269. [DOI](https://doi.org/10.1098/rspa.2010.0485)

### Scheduling, technology deployment and resource use

- Jevons, W. S. (1865). *The Coal Question: An Enquiry Concerning the Progress of the Nation, and the Probable Exhaustion of Our Coal-Mines*. London, Macmillan and Co. See chapter VII, “Of the Economy of Fuel.” [First edition](https://books.google.co.uk/books?id=gAAKAAAAIAAJ)
- Kelley, J. E., Jr., and M. R. Walker (1959). Critical-path planning and scheduling. In *Proceedings of the Eastern Joint IRE-AIEE-ACM Computer Conference*, 160–173. ACM. [DOI](https://doi.org/10.1145/1460299.1460318)
- Wilson, C., and A. Grubler (2011). Lessons from the history of technological change for clean energy scenarios and policies. *Natural Resources Forum* 35, 165–184. [DOI](https://doi.org/10.1111/j.1477-8947.2011.01386.x)
- Wright, T. P. (1936). Factors affecting the cost of airplanes. *Journal of the Aeronautical Sciences* 3(4), 122–128. [DOI](https://doi.org/10.2514/8.155)

### Climate and energy data

- Friedlingstein, P., M. O’Sullivan, R. M. Andrew, et al. (2026). Global Carbon Budget 2026. *Earth System Science Data Discussions*, preprint, 10 November 2026. The Global Carbon Project’s accompanying release gives the remaining budgets at 50% likelihood. [Preprint](https://doi.org/10.5194/essd-2026-895) · [Data](https://doi.org/10.18160/GCP-2026) · [Budget table](https://cger.nies.go.jp/gcp/pdf/20261110/Key%20Messages%20Global%20Carbon%20Budget%202026.pdf)
- International Energy Agency (2025). *Energy and AI*. Paris, IEA. See “Energy demand from AI” for the 2024 estimate and the 2030 base case. [Report chapter](https://www.iea.org/reports/energy-and-ai/energy-demand-from-ai)
- International Energy Agency (2026). *Key Questions on Energy and AI*. Paris, IEA. See the executive summary for the change in data-centre electricity demand in 2025. [Executive summary](https://www.iea.org/reports/key-questions-on-energy-and-ai/executive-summary)
- International Energy Agency (2026). *World Energy Investment 2026*. Paris, IEA. The report gives full-year investment estimates for 2026. [Report](https://www.iea.org/reports/world-energy-investment-2026)
- IPCC (2021). Summary for Policymakers. In *Climate Change 2021: The Physical Science Basis*, 3–32. Cambridge University Press. See D.1.1 and Figure SPM.10 for the assessed warming per unit of cumulative CO₂ emissions. [DOI](https://doi.org/10.1017/9781009157896.001)
- IPCC (2022). Summary for Policymakers. In *Climate Change 2022: Mitigation of Climate Change*, 3–48. Cambridge University Press. See C.12 and Figure SPM.7 for the cost and potential of mitigation options in 2030. [DOI](https://doi.org/10.1017/9781009157926.001)

## Code and reproducibility

- **Lean 4 project:** `Theory.lean` (`delay_never_lowers_required_rate`, `rate_upward`, `greedy_suffices`), `Climate.lean` (model, kernels, certificate), and `ArgIIMain.lean` (E-II.2, E-II.3, monotonicity check).
- **Python reference:** `python/experiments_ii.py`. Every Argument II result was reproduced line for line by the Lean build on the author's machine (`argII_output.txt`, `RUN_LOG.md`).
