# Argument I — The Paradox of Adaptive Organization

**Subtitle:** *How Successful Adaptation Can Destroy Its Own Preconditions*

*Working draft, November 2026. Notation is defined in I.2 and formalized in I.3.*

> **Terminology.** In this argument, *organizational* change means a change to the capability structure: what actions, policies and further reorganizations are feasible (Definition 1, I.3.2). Reallocating work within existing capabilities, which ordinary usage also calls "reorganizing," is a **policy** change here. The severity names (I.3.5) follow this usage.

## Central claim

Adaptation generates organization, and organization changes the conditions under which future adaptation must happen. As a result, raising productive efficiency does not necessarily raise resilience, recoverability or long-term viability.

The claim made here is narrower and sharper than "efficiency can cost resilience":

1. **Organization alone can set severity.** Systems in the same physical state, facing the same environment and deadline, can differ in severity purely because of their organization. One is recoverable by a policy change, another needs reorganization, and a third is locked in with physical recovery still available.
2. **Short-horizon optimization can select lock-in.** In the settlement model, a rule that maximizes food stored over the next two ticks and favors foraging on ties enters lock-in. The same objective preserves recovery when ties favor training and farming.
3. **Comparable resources give a diagnostic under monotone dynamics.** At the same time and on the same disturbance path, suppose a poorer state can reorganize and a richer state is locked in. Under Proposition 4’s assumptions, their modeled organizations or commitments must differ.

Claims 1 and 2 are established constructively in an exact model (I.3.10). Claim 3 depends on the resource order, the viability criterion and the policy-switching convention in I.5.3. How common the mechanism is in real systems is an empirical question (I.7).

## I.1. The empirical observation

**The Everfall food-scheduling failure.** A simulated settlement in *The Everfall Spiral* had accessible food resources, available workers, tools and productive capability, and unmet physiological food requirements. Yet its scheduler failed to generate enough food-production work. Workers stood idle while nutritional demand went unmet.

The failure sat between the existence of resources and their organized deployment. Correcting how work and food were coordinated changed what the settlement could accomplish without adding physical resources or new agent actions.

**Initial proposition:** physical productive capacity and organizationally realizable production are distinct.

The incident motivates the argument but does not carry it. In the formal terms of I.3 it is, at most, an operational mismatch ($`\sigma=1`$): the incumbent policy failed, and a revised policy within existing capabilities may have succeeded. Its classification is provisional, pending the controlled comparison in I.3.9. Even once confirmed, it says nothing about lock-in, which requires $`\sigma=3`$.

A second Everfall observation points closer to the argument's core. Survival was achieved by coordination changes alone. Holding reserves at a stable level over longer horizons, by contrast, required changing what agents were allowed to do. Different viability criteria demanded different classes of intervention, which is exactly the distinction the taxonomy formalizes.

The existence of every severity class, including lock-in, is established not by Everfall but by the exact model in I.3.10.

## I.2. The adaptive system

System state:
```math
s_t=(x_t,O_t,\pi_t,q_t)
```

- $`x_t`$: physical and environmental state.
- $`O_t`$: organizational structure. It determines the **capability structure** $`\mathcal C(O)`$: which operational actions, policies and reorganization moves are available.
- $`\pi_t`$: current operational policy.
- $`q_t`$: accumulated commitments, dependencies, obligations, and reorganizations in progress.

Actions change $`O_t`$ and $`q_t`$, not just $`x_t`$. Organization also drifts without deliberate change, through attrition, skill loss and decay. **Organization is endogenous to the dynamics.**

The environment $`w_t`$ is exogenous to any single decision but may be partly produced by the system's own past actions (niche construction). This is the bridge to Argument II.

I.3 makes this precise: the dynamics, the separation of policy change from capability change, four nested control classes, their viability kernels, a five-level severity classification, points of no return, an evidence standard for each classification, and an exact example.

## I.3. Control classes, viability kernels, and the failure taxonomy

### I.3.1 Model structure

State: $`s_t=(x_t,O_t,\pi_t,q_t)\in\mathcal S=\mathcal X\times\mathcal O\times\Pi\times\mathcal Q`$. Time is discrete, $`t\in\{0,\dots,T\}`$, with $`T`$ a fixed terminal time. The environment is an exogenous path $`w_{0:T}`$. It is known in the deterministic version; see I.3.8 for uncertainty.

At each step the system takes three kinds of action, in this order:

1. **Policy revision** $`\delta\pi_t`$. A revision with no implementation move takes effect immediately: the policy used this tick is $`\pi'_t=\pi_t\oplus\delta\pi_t`$, subject to $`\pi'_t\in\Pi(O_t)`$, and it is stored as $`\pi_{t+1}=\pi'_t`$. A revision paired with an implementation move takes effect only when that move completes (Definition 1).
2. **Move** $`m_t\in\mathcal M(O_t,q_t)`$, either capability-changing or implementation (Definition 1). The set always contains the null move $`\varnothing`$.
3. **Operational action** $`a_t=\phi_{O_t}\bigl(\pi'_t(y_t)\bigr)`$, where $`y_t`$ is the organization's observation and $`\phi_{O_t}`$ is the fallback map of A2, applied automatically. It must be realizable: $`a_t\in\mathcal A(x_t,O_t,q_t,m_t)`$. The move chosen this tick can restrict what is realizable this tick: workers assigned to training cannot also forage.

Each non-null move $`m`$ has:

- a latency $`\tau(m)\ge 1`$,
- a resource draw $`c(m)`$ that is charged against $`x`$ while the move is pending,
- a transitional restriction: while $`m`$ is pending, $`\mathcal A`$ may shrink. Retraining workers takes them off production, for example.

Transitional disruption need not originate inside the organization. The environment, or observers such as counterparties and customers, can react on the tick a move is announced or becomes visible, before it completes. Such reflexive reactions enter through $`m_t`$ in $`f`$ and $`\mathcal A`$ below.

Pending moves are stored in $`q`$. That is how in-flight transitions become commitments.

Dynamics:

```math
\begin{gathered}
x_{t+1}=f(x_t,a_t,q_t,m_t,w_t),\qquad O_{t+1}=g(O_t,a_t,q_t,m_t,w_t),
\\ q_{t+1}=h(q_t,a_t,m_t,w_t).
\end{gathered}
```

The move $`m_t`$ enters $`f`$ and $`\mathcal A`$ as well as $`g`$. Its cost and transitional restriction apply in the tick it is chosen; in the climate experiment, for example, a capacity order reduces the same year's spending. Because $`m_t`$ enters $`g`$ directly, a move with latency $`\tau(m)`$ chosen at $`t`$ changes $`O`$ at $`t+\tau(m)`$. A latency-1 move, such as specialization in I.3.10, takes effect at $`t+1`$. A move whose requirement is completed during tick $`t`$, such as the last worker-tick of training, likewise takes effect at $`t+1`$.

$`O`$ can change without any deliberate move, through attrition, skill loss and so on. Organization is endogenous even when nobody reorganizes.

**Assumption A0 (physical viability criterion).** The viability set $`\mathcal V`$ and the terminal set $`\mathcal W\subseteq\mathcal V`$ depend only on $`x`$:
```math
\begin{gathered}\mathcal V=\mathcal V_x\times\mathcal O\times\Pi\times\mathcal Q,\\ \mathcal W=\mathcal W_x\times\mathcal O\times\Pi\times\mathcal Q.\end{gathered}
```
Institutional and contractual constraints such as debt limits, staffing rules and obligations enter only through the admissible sets $`\mathcal A`$, $`\Pi`$ and $`\mathcal M`$, never through $`\mathcal V`$. This is what lets a physical bound be compared against an organizational one under the same criterion.

### I.3.2 Policy change versus organizational change

Call $`\mathcal C(O)=\bigl(\mathcal A(\cdot,O,\cdot),\ \Pi(O),\ \mathcal M(O,\cdot)\bigr)`$ the organization's **capability structure**.

**Definition 1.** Moves come in two kinds:

- **Capability-changing moves** $`\mathcal M_{\mathrm{cap}}`$: completing the move alters $`\mathcal C`$. It changes which actions, policies or further moves are feasible.
- **Implementation moves** $`\mathcal M_{\mathrm{impl}}`$: the move uses time or resources to put an already-admissible policy revision into effect, without altering $`\mathcal C`$. Rolling out a revised schedule across a workforce is an example. A revision paired with an implementation move takes effect when the move completes.

So $`\mathcal M=\{\varnothing\}\cup\mathcal M_{\mathrm{impl}}\cup\mathcal M_{\mathrm{cap}}`$.

A change is **organizational** if and only if it uses a capability-changing move. Every other change is a **policy** change. That includes a revision that is slow or costly to implement.

The test is what becomes realizable, not delay or cost. An instantaneous revision and a slow, costly rollout of the same admissible policy are both policy changes. In the default case, a revision with no implementation move takes effect immediately, in the tick it is made, at no cost. Capability-changing moves have latency $`\tau(m)\ge1`$, cost $`c(m)\ge0`$, and possible transitional disruption.

### I.3.3 Four control classes

Let $`\pi_0`$ be the incumbent policy. The four classes restrict which continuations are allowed:

| Class | Policy revision | Moves | Operational actions |
|---|---|---|---|
| $`\mathcal U_{\mathrm{fixed}}`$ | $`\delta\pi\equiv0`$ | $`m\equiv\varnothing`$ | $`\phi_{O_t}(\pi_0(y_t))\in\mathcal A`$ |
| $`\mathcal U_{\mathrm{policy}}`$ | free, $`\pi'_t\in\Pi(O_t)`$ | $`m_t\in\{\varnothing\}\cup\mathcal M_{\mathrm{impl}}`$ | $`\phi_{O_t}(\pi'_t(y_t))\in\mathcal A`$ |
| $`\mathcal U_{\mathrm{adapt}}`$ | free | free, $`m_t\in\mathcal M(O_t,q_t)`$ | $`\phi_{O_t}(\pi'_t(y_t))\in\mathcal A`$ |
| $`\mathcal U_{\mathrm{phys}}`$ | n/a | n/a | any $`a_t\in\mathcal A_{\mathrm{phys}}(x_t)`$ |

Because the fallback $`\phi_{O_t}`$ is applied at execution, $`\mathcal U_{\mathrm{fixed}}`$ keeps $`\delta\pi\equiv0`$ even as $`O_t`$ drifts: the stored policy never changes, and only its realized actions degrade.

$`\mathcal U_{\mathrm{phys}}`$ bypasses organization entirely. It is an idealized planner that acts directly on the physical dynamics $`x_{t+1}=f_{\mathrm{phys}}(x_t,a_t,w_t)`$.

**Remark (native reorganization).** If the incumbent organization has built-in reorganization routines (hiring rules, automatic role assignment), model them as a baseline meta-policy $`\mu_0`$ that issues moves. The classes are then defined relative to $`\mu_0`$:

- $`\mathcal U_{\mathrm{fixed}}`$ runs $`(\pi_0,\mu_0)`$.
- $`\mathcal U_{\mathrm{policy}}`$ frees $`\pi`$ and keeps $`\mu_0`$.
- $`\mathcal U_{\mathrm{adapt}}`$ frees the meta-policy.

Everything below goes through unchanged under two conditions:

- **Admissibility.** The moves $`\mu_0`$ issues must remain admissible, in $`\mathcal M(O_t,q_t)`$, along every trajectory of $`\mathcal U_{\mathrm{fixed}}`$ and $`\mathcal U_{\mathrm{policy}}`$, including trajectories that leave the baseline. Otherwise nesting (Proposition 1) can fail.
- **Monotonicity.** For Proposition 4, $`\mu_0`$ must preserve A4: from a richer physical state with the same $`(O,q)`$, it must issue the same moves.

A rule like "expand capacity while capacity is binding" depends on $`x`$. It satisfies the first condition, and must be checked against the second.

### I.3.4 Viability kernels and nesting

**Definition 2.** For class $`k\in\{\mathrm{fixed},\mathrm{policy},\mathrm{adapt},\mathrm{phys}\}`$ and start time $`t`$:
```math
\begin{aligned}\mathcal K_k(t)=\Bigl\{s\in\mathcal S:\ &\exists\ \text{a class-}k\text{ continuation from }(s,t)\ \text{with}\\ &s_\tau\in\mathcal V\ \ \forall\tau\in\{t,\dots,T\}\ \text{and}\ s_T\in\mathcal W\Bigr\}.\end{aligned}
```
With $`\mathcal W=\mathcal V`$ this is the finite-horizon viability kernel. With a strict $`\mathcal W`$ it is the reach-avoid set used in Argument III. For $`k=\mathrm{fixed}`$ there is no choice to make: membership just means the baseline trajectory from $`s`$ stays viable.

Bertsekas and Rhodes (1971) give a finite-horizon target-tube formulation for discrete-time systems under uncertainty. In the deterministic case here, start with $`\mathcal V\cap\mathcal W`$ at the horizon and work backward. A viable state belongs at the preceding tick if some admissible class-$`k`$ step leads to a state already included. Enlarging the admissible continuations preserves their existing witnesses. Proposition 1 specifies when the organizational and physical models permit that comparison.

**Conditions for nesting.**

- **A1 (null move and null action).** For all $`(O,q)`$, $`\varnothing\in\mathcal M(O,q)`$, at no cost and with no disruption. For all states, a null operational action $`a^{\varnothing}\in\mathcal A(x,O,q)`$ exists.
- **A2 (total policies with explicit fallback).** Every policy is defined on every organization. The model specifies a fallback map $`\phi_O`$ that replaces any component of $`\pi(y)`$ the organization $`O`$ cannot carry out with the null action. The admissible policy sets are required to contain the fallback-completed policies:
```math
\begin{gathered}\pi\in\Pi(O)\ \Longrightarrow\ \phi_{O'}\circ\pi\in\Pi(O')\\ \text{for every }O'\text{ reachable from }O.\end{gathered}
```
This is part of the assumption, not a consequence of defining $`\phi`$: a total function is not automatically a member of every $`\Pi(O')`$. The fallback must be stated for each simulation, because it decides what the baseline does after a capability is lost.
- **A3 (physical consistency).** Every organizational step is physically realizable. For all $`(x,O,q,w)`$ and every admissible $`(a,m)`$, there exists $`a'\in\mathcal A_{\mathrm{phys}}(x)`$ with $`f_{\mathrm{phys}}(x,a',w)=f(x,a,q,m,w)`$. Reorganization costs and transitional losses are things physics permits, not exemptions from it.

**What $`\mathcal U_{\mathrm{phys}}`$ relaxes.** The physical class removes organizational constraints on which actions can be chosen and when. It does not change how the environment responds to them. If observers react to a move when it is announced (I.3.1), that reaction is part of the environment's causal response law, and $`f_{\mathrm{phys}}`$ must carry it for the physical action that sends the same signal. A benchmark that drops the reaction makes the environment friendlier as well as the controller freer. Then $`\mathcal K_{\mathrm{phys}}\setminus\mathcal K_{\mathrm{adapt}}`$ mixes organizational lock-in with that difference, as unequal information mixes it with informational lock-in (I.3.8).

**Proposition 1 (nesting).** Under A0–A3 (or A0–A2 with A3′), for every $`t`$:
```math
\mathcal K_{\mathrm{fixed}}(t)\subseteq\mathcal K_{\mathrm{policy}}(t)\subseteq\mathcal K_{\mathrm{adapt}}(t)\subseteq\mathcal K_{\mathrm{phys}}(t).
```

*Proof.* Each step shows that a continuation in one class is also admissible in the next.

1. A fixed continuation is reproduced by a policy continuation that chooses $`\pi'_t=\phi_{O_t}\circ\pi_0`$ at every tick. This is in $`\Pi(O_t)`$ by A2, as the policy column of the I.3.3 table requires. Since the fallback is idempotent, executing it gives the same actions $`\phi_{O_t}(\pi_0(y_t))`$ as the fixed class.
2. A policy continuation is an adapt continuation, since $`\{\varnothing\}\cup\mathcal M_{\mathrm{impl}}\subseteq\mathcal M`$.
3. Take an adapt continuation and replace each step by the physical action given by A3. This produces the same $`x`$-path. Viability and the terminal condition depend only on $`x`$ (A0), so the physical continuation satisfies them. $`\square`$

**A3′ (dominance alternative to A3).** Exact equality in A3 can be replaced by dominance, under explicit order conditions. Let $`\succeq`$ be a preorder on $`\mathcal X`$ read as "at least as good for viability." It must order every viability-relevant component in its favorable direction. It is not "more output." Require:

1. **Dominance.** For every admissible organizational step from $`(x,O,q)`$ with result $`x^{+}`$, there is $`a'\in\mathcal A_{\mathrm{phys}}(x)`$ with $`f_{\mathrm{phys}}(x,a',w)\succeq x^{+}`$.
2. **Simulation.** If $`x\succeq x'`$, then for every $`a'\in\mathcal A_{\mathrm{phys}}(x')`$ there is $`a\in\mathcal A_{\mathrm{phys}}(x)`$ with $`f_{\mathrm{phys}}(x,a,w)\succeq f_{\mathrm{phys}}(x',a',w)`$.
3. **Upward closure.** $`\mathcal V_x`$ and $`\mathcal W_x`$ are upward closed under $`\succeq`$.

Under A0–A2 and A3′, Proposition 1 still holds. Inductively, (1), (2) and transitivity build a physical continuation whose $`x`$-path stays $`\succeq`$ the organizational one. (3) then keeps that continuation in $`\mathcal V_x`$ and ends it in $`\mathcal W_x`$.

A3′ is unavailable when higher output worsens some other component, such as resource depletion or environmental damage. In that case the higher-output state is not $`\succeq`$, condition (1) fails, and exact A3 must be shown. A3 remains the general assumption, and A3′ is a convenience for monotone models.

### I.3.5 The taxonomy

**Definition 3.** For a state $`s`$ at time $`t`$, its **severity** $`\sigma(s,t)\in\{0,1,2,3,4\}`$ is:

| $`\sigma`$ | Class | Condition |
|---|---|---|
| 0 | Viable as-is | $`s\in\mathcal K_{\mathrm{fixed}}(t)`$ |
| 1 | Operational mismatch | $`s\in\mathcal K_{\mathrm{policy}}(t)\setminus\mathcal K_{\mathrm{fixed}}(t)`$ |
| 2 | Recoverable organizational mismatch | $`s\in\mathcal K_{\mathrm{adapt}}(t)\setminus\mathcal K_{\mathrm{policy}}(t)`$ |
| 3 | Structural organizational lock-in | $`s\in\mathcal K_{\mathrm{phys}}(t)\setminus\mathcal K_{\mathrm{adapt}}(t)`$ |
| 4 | Physical nonviability | $`s\in\mathcal S\setminus\mathcal K_{\mathrm{phys}}(t)`$ |

**Proposition 2 (partition).** Under Proposition 1, the five classes partition $`\mathcal S`$ at each $`t`$. Every state has exactly one severity.

*Proof.* Nested sets $`A_0\subseteq A_1\subseteq A_2\subseteq A_3\subseteq\mathcal S`$ give the disjoint cover $`A_0,\ A_1\setminus A_0,\ A_2\setminus A_1,\ A_3\setminus A_2,\ \mathcal S\setminus A_3`$. $`\square`$

Physical nonviability is relative to the model. It means no trajectory satisfies $`\mathcal V`$ under the modeled physics, horizon and environment path.

### I.3.6 Points of no return

An earlier single-class version appears in vehicle safety. Söntges, Koschi and Althoff (2018, Proposition 1) define the time to react along a vehicle’s current trajectory by the last instant when an admissible maneuver can still avoid collision through the planning horizon. Definition 4 applies this last-start test separately to policy revision, capability change and physical action along an organizational baseline. The gap between the last two deadlines gives the lock-in interval.

Let $`s^{\mathrm{b}}_t`$ be the baseline trajectory: the incumbent organization running unchanged. Let $`t_{\mathrm{fail}}=\min\{t:\ s^{\mathrm b}_t\notin\mathcal V\}`$ be its first viability violation, with $`t_{\mathrm{fail}}=\infty`$ if there is none.

**Convention.** When $`\mathcal V`$ is stated as a per-tick transition condition, as in I.3.10 ("no starvation during the tick"), a failure during tick $`t`$ is recorded in the resulting state: $`s_{t+1}\notin\mathcal V`$. So $`t_{\mathrm{fail}}`$ is the index of the first failed *state*, one more than the tick in which the failure occurred.

**Definition 4.** For $`k\in\{\mathrm{policy},\mathrm{adapt},\mathrm{phys}\}`$, the **point of no return** for class $`k`$ is the last moment before the baseline first leaves the class-$`k`$ kernel:
```math
t_k^{*}=\min\{t:\ s^{\mathrm b}_t\notin\mathcal K_k(t)\}-1.
```
Set $`t_k^{*}=-1`$ if $`s_0\notin\mathcal K_k(0)`$, and $`t_k^{*}=T`$ if the baseline never leaves.

Two properties follow from this definition and nesting alone:

- **Domain.** $`t_k^{*}\lt t_{\mathrm{fail}}`$, because a state outside $`\mathcal V`$ is in no kernel. Re-entering a kernel after a viability violation is never counted. Where violation is absorbing in the simulation, such as death, this is automatic.
- **Ordering.** By Proposition 1, leaving $`\mathcal K_{\mathrm{adapt}}`$ implies leaving $`\mathcal K_{\mathrm{policy}}`$, and leaving $`\mathcal K_{\mathrm{phys}}`$ implies leaving $`\mathcal K_{\mathrm{adapt}}`$. So
```math
t_{\mathrm{policy}}^{*}\ \le\ t_{\mathrm{adapt}}^{*}\ \le\ t_{\mathrm{phys}}^{*}.
```

**Proposition 3 (monotone loss, known environment path).** For each class $`k`$: if $`s^{\mathrm{b}}_t\in\mathcal V`$ and $`s^{\mathrm{b}}_{t+1}\in\mathcal K_k(t+1)`$, then $`s^{\mathrm{b}}_t\in\mathcal K_k(t)`$. As a consequence, before the first violation, kernel membership along the baseline is exactly the prefix:
```math
\{t<t_{\mathrm{fail}}:\ s^{\mathrm b}_t\in\mathcal K_k(t)\}=[0,\ t_k^{*}].
```

*Proof.* From $`s^{\mathrm b}_t`$, take one baseline step. It is admissible in every class: the null revision and null move are admissible by A1–A2, and the step is physically admissible by A3. That step reaches $`s^{\mathrm b}_{t+1}`$, and a class-$`k`$ continuation exists from there. Since $`s^{\mathrm b}_t\in\mathcal V`$, joining the two gives a class-$`k`$ continuation from $`(s^{\mathrm b}_t,t)`$.

For the prefix claim, take the contrapositive: $`s^{\mathrm b}_t\in\mathcal V`$ and $`s^{\mathrm b}_t\notin\mathcal K_k(t)`$ imply $`s^{\mathrm b}_{t+1}\notin\mathcal K_k(t+1)`$. Induct forward from $`t_k^{*}+1`$ while the baseline remains in $`\mathcal V`$.

This needs the fixed terminal time $`T`$. With a receding horizon, monotonicity can fail. $`\square`$

If the baseline fails, the interval before the first violation splits into four parts, each labeled by the least permissive control class that still suffices:

| Interval | Least permissive sufficient class |
|---|---|
| $`[0,\ t_{\mathrm{policy}}^{*}]`$ | policy |
| $`(t_{\mathrm{policy}}^{*},\ t_{\mathrm{adapt}}^{*}]`$ | adapt: the **reorganization window** |
| $`(t_{\mathrm{adapt}}^{*},\ t_{\mathrm{phys}}^{*}]`$ | none admissible, though physical recovery exists: the **lock-in interval** |
| $`(t_{\mathrm{phys}}^{*},\ t_{\mathrm{fail}})`$ | none |

"Least permissive" orders control classes, not costs. A policy-class recovery can use more resources than an available reorganization would. Comparing costs needs a separate cost functional over continuations, such as the minimum resource draw within each class.

**Lock-in duration:** $`\Delta_{\mathrm{lock}}=t_{\mathrm{phys}}^{*}-t_{\mathrm{adapt}}^{*}`$. Structural lock-in occurs along the baseline exactly when $`\Delta_{\mathrm{lock}}\gt 0`$.

Experiment B measures $`t_{\mathrm{adapt}}^{*}`$ directly. The paradox in I.5 can then be stated with these quantities: compare $`\Delta_{\mathrm{lock}}`$, and the margin to the boundary of $`\mathcal K_{\mathrm{adapt}}`$, between an output-greedy history and alternative histories from the same $`s_0`$.

### I.3.7 Evidence burden and how to report a classification

Each claim has two parts. Membership in a kernel is **constructive**: one trajectory is a witness. Exclusion from a kernel is **universal**: no admissible continuation exists.

| Claim | Constructive part | Universal part |
|---|---|---|
| $`\sigma=0`$ | baseline run | none |
| $`\sigma=1`$ | policy-class witness | baseline failure (one run, if deterministic) |
| $`\sigma=2`$ | adapt-class witness | no policy-class continuation succeeds |
| $`\sigma=3`$ | physical witness | no admissible move sequence succeeds |
| $`\sigma=4`$ | none | no physical trajectory succeeds |

What this means in practice:

- Operational mismatch is the only failure class that can be established entirely by construction.
- Physical nonviability often has cheap certificates, such as a conservation or budget bound: available calories over the horizon are below the requirement.
- The two middle classes carry the hard universal claims. Lock-in is the hardest, because it quantifies over sequences of reorganization moves.

**Reporting rule.** Report a severity **interval** $`[\sigma_{\min},\sigma_{\max}]`$:

- A witness in $`\mathcal K_k`$ sets $`\sigma_{\max}\le`$ the index of $`k`$.
- A certificate of exclusion raises the lower severity bound above the index of the excluded class. An exhaustive search can supply it if it covers the entire class, an outer relaxation, or a reduced problem proved to preserve the existence of a solution. Exhausting a discretized subset establishes exclusion only for that subset.
- "No witness found under search budget $`B`$" is reported separately, with the escape-rate-versus-budget curve. It never counts as an exclusion.

Claim structural lock-in only when the interval is exactly $`\{3\}`$.

### I.3.8 Uncertainty

Replace the known path $`w_{0:T}`$ with a disturbance set $`\mathcal W_{\mathrm{dist}}`$, and replace open-loop sequences with feedback strategies over the observation $`y_t`$.

- **Robust kernel** $`\mathcal K^{\mathrm{rob}}_k(t)`$. Some class-$`k`$ strategy keeps $`s_\tau\in\mathcal V`$ and reaches $`\mathcal W`$ for every admissible disturbance path. Propositions 1 and 2 carry over. Definition 4 also carries over, with its domain and ordering properties, because those use only nesting.

  **Proposition 3 does not carry over as stated.** Counterexample: tomorrow brings one of two disturbances, one harmless and one fatal. No strategy guarantees survival against both, so $`s_t\notin\mathcal K^{\mathrm{rob}}_k(t)`$. If the harmless disturbance occurs, the realized $`s_{t+1}`$ can lie inside $`\mathcal K^{\mathrm{rob}}_k(t+1)`$. Robust membership can rise along a realized path. The robust analogue strengthens the premise to every baseline successor:

  **Proposition 3′.** Let $`F`$ be the one-step map and $`u^{\mathrm b}_t`$ the baseline step. Suppose $`s^{\mathrm b}_t\in\mathcal V`$ and $`F(s^{\mathrm b}_t,u^{\mathrm b}_t,w)\in\mathcal K^{\mathrm{rob}}_k(t+1)`$ for every admissible $`w`$. Then $`s^{\mathrm b}_t\in\mathcal K^{\mathrm{rob}}_k(t)`$.

  *Proof.* Play the baseline step, then follow the robust strategy of whichever successor occurs. This requires the successor to be identifiable from $`y_{t+1}`$. Under partial observability, successors that share an observation need a common continuation strategy. $`\square`$

  **Interpretation.** Under uncertainty, $`t_k^{*}`$ is the **last moment class-$`k`$ recovery is guaranteed**. Leaving the robust kernel means the guarantee is lost, not that recovery is impossible: a realized path can re-enter by luck. Points of no return in the strict sense of Proposition 3 are claims about a known environment path only.
- **$`\varepsilon`$-kernel.** Some class-$`k`$ strategy succeeds with probability at least $`1-\varepsilon`$. Nesting holds at fixed $`\varepsilon`$. Monotonicity along the baseline is not automatic, because probabilities compound; it needs the conditional formulation. Severities are reported at a stated $`\varepsilon`$.

**Information structure.** Nesting requires every class to use the same observation $`y_t`$. If $`\mathcal K_{\mathrm{phys}}`$ is computed with full state information, the gap $`\mathcal K_{\mathrm{phys}}\setminus\mathcal K_{\mathrm{adapt}}`$ mixes organizational lock-in with informational lock-in. Either keep observations fixed across classes, or treat information as its own layer:
```math
\mathcal K_{\mathrm{adapt}}^{y}\subseteq\mathcal K_{\mathrm{adapt}}^{\mathrm{full}}\subseteq\mathcal K_{\mathrm{phys}}^{\mathrm{full}}.
```

### I.3.9 Worked classification: Everfall (provisional)

Both Everfall classifications below are **provisional**. Each states exactly what would establish it or refute it.

**Three criteria, kept separate.**

1. **Survival** (finite horizon): $`\mathcal V_{\mathrm{surv}}=\{s:\ D_{\mathrm{starv}}(x)=0\}`$, with $`\mathcal W=\mathcal V_{\mathrm{surv}}`$. $`D_{\mathrm{starv}}`$ is the cumulative count of starvation deaths among the initial population, carried in $`x`$.
2. **Nutritional stability** (finite horizon): $`\mathcal V_{\mathrm{stab}}=\{s:\ \min_i r_i(x)\ge 0.25\}`$ at every tick through $`T`$, where $`r_i`$ is agent $`i`$'s reserve as a fraction of its kcal capacity. It is a per-agent minimum, fixed before any run and not adjusted to fit observed minima. There is no terminal condition: an x-only terminal set cannot by itself certify that reserves can be maintained (A0).
3. **Indefinite sustainability** is not a kernel at finite $`T`$. It needs a separate argument, such as repeatability. Suppose the environment is periodic with period $`L`$ and the dynamics are monotone in $`x`$, so that more reserves never hurt viability. Suppose also that some class-$`k`$ continuation over one period stays in $`\mathcal V_{\mathrm{stab}}`$ and returns to a state with the same $`(O,\pi,q)`$ and $`x_{t_0+L}\ge x_{t_0}`$ componentwise. Then repeating that continuation is viable indefinitely. A 300-day successful run establishes finite-horizon viability only.

Repeatability needs a stationary or periodic environment. Argument II is about environments that are neither, so in that setting indefinite sustainability is not the right target and the finite-horizon kernels are.

**Candidate Result 1: survival as operational mismatch ($`\sigma=1`$).** The survival changes are coordination changes: task generation and assignment, demand estimation, provisioning, hunger behavior, and meal portions and appetite as intake rules. Under Definition 1 they form a single policy revision $`\pi_0\to\pi_1`$. A composite revision is a valid witness, so isolating the scheduler is not required.

The open empirical question is whether $`\pi_1`$ prevents starvation **without direct foraging**. Foraging is a capability change, so it must be off in both arms. Earlier no-foraging configurations are reported to have had substantial mortality even after other improvements. If that holds for $`\pi_1`$ on a common build, no policy-class witness exists in this experiment, and survival moves to candidate $`\sigma=2`$.

*Establishing run:* $`\pi_0`$ vs $`\pi_1`$, same build, foraging off, identical physics, initial conditions and seeds, fixed $`T`$. The result is established if $`\pi_0`$ has starvation deaths and $`\pi_1`$ has none, reported per seed.

**Hypothesis 2: nutritional stability as recoverable organizational mismatch ($`\sigma=2`$).** No adapt-class witness exists yet. The runs with direct foraging enabled reached per-agent reserve minima of about 22–23%, which fails $`\mathcal V_{\mathrm{stab}}`$. A witness needs a capability change, such as food caches, local habitation or agriculture, whose run keeps every agent at or above 25% through $`T`$. That change must be modeled as an in-sim capability-changing move with latency and cost. The policy class must also be excluded, for example by a calorie-throughput certificate over the pre-change action set.

**What Everfall does not give.** Neither result bears on lock-in ($`\sigma=3`$). Nonemptiness of every class, including lock-in, is shown in the exact toy model (Section I.3.10).

### I.3.10 Exact example: all five classes are nonempty and distinct

This section gives a small deterministic settlement model in which all four kernels are computed **exactly**. The state space is finite, so backward recursion over all 17,136 states decides membership in every kernel. The four membership claims ($`\sigma=0`$ to $`3`$) each come with a witness trajectory, re-verified by independent forward simulation. The four exclusions behind $`\sigma=4`$, and every other exclusion, are exhaustive, not the result of a failed search.

**Model.**

| Component | Specification |
|---|---|
| Workers | $`N=3`$; each eats 1 food per tick |
| $`x=(F,P)`$ | food stock $`F\in\{0,\dots,20\}`$ (storage cap 20, surplus discarded), harvest $`P`$ arriving next tick |
| $`O=(\text{farm},\text{spec})`$ | farming capability; whether foragers are specialized |
| $`q`$ | worker-ticks of farm training completed |
| Environment | wild yield per forager: 2 for $`t\lt 6`$, 1 for $`6\le t\lt 8`$, 0 after; $`T=16`$ |
| Forage | yield per forager is wild yield, plus 1 if specialized and wild yield $`\gt 0`$ |
| Farm | 2 per farmer, harvested next tick; requires farm $`\in O`$ |
| Train (capability move) | trainees accumulate worker-ticks; farming is acquired at 2 (generalists) or 8 (specialists) |
| Specialize (capability move) | Takes effect next tick and is irreversible. When training and specialization coincide, training completed under the current requirement is retained. At the start of the next tick, accumulated work also qualifies if it meets the new requirement. |
| $`\mathcal V`$ | no starvation: $`F+\text{forage}+P-N\ge0`$ every tick |

**Classes.**

- **Fixed:** the incumbent policy (everyone forages, never farms).
- **Policy:** any allocation to forage, farm (if capable) or idle.
- **Adapt:** policy plus training and specialization.
- **Phys:** any allocation, with farming available without training and foraging at the best technique.

The model satisfies A3′, with $`\succeq`$ componentwise on $`(F,P)`$:

- dominance holds, because physical yields are at least organizational yields and training is physically idle labor;
- simulation holds, because physical action sets do not depend on $`x`$ and the capped dynamics are monotone;
- $`\mathcal V`$ is upward closed.

Nesting is also confirmed numerically: 0 violations across all states.

**Five demonstration states, all at $`t=11`$.**

| $`\sigma`$ | State | Least permissive witness | Exhaustively excluded |
|---|---|---|---|
| 0 | $`F=16`$, no farm, generalists | incumbent forages to $`T`$ | none |
| 1 | $`F=9`$, **farm**, generalists | farm 2 at $`t=13`$, 1 at $`t=14`$ | $`\mathcal K_{\mathrm{fixed}}`$ |
| 2 | $`F=9`$, no farm, **generalists** | train 2 at $`t=12`$, then farm | $`\mathcal K_{\mathrm{fixed}},\mathcal K_{\mathrm{policy}}`$ |
| 3 | $`F=9`$, no farm, **specialists** | physical: farm 2 at $`t=13`$, 1 at $`t=14`$ | $`\mathcal K_{\mathrm{fixed}}`$, $`\mathcal K_{\mathrm{policy}}`$, $`\mathcal K_{\mathrm{adapt}}`$ |
| 4 | $`F=2`$, no farm | none | all four kernels |

The $`\sigma=1,2,3`$ states share the same time, environment and physical state, and differ **only in organization**. The physical recovery for the locked-in settlement is the same plan the farm-capable settlement carries out at $`\sigma=1`$. The specialists cannot reach it: eight worker-ticks of retraining with no food coming in exhausts the stock before the first harvest. The generalists need two worker-ticks, so they can.

**The paradox pair, from a common initial state.** Both histories start at $`s_0=(t{=}0,F{=}0,P{=}0,\text{no farm},\text{generalists})`$. In history B the settlement **decides** at $`t=0`$ to specialize, which takes effect from $`t=1`$. After that, both run the incumbent policy.

| History | Gross harvest | Discarded at cap | Useful harvest | $`t^{*}_{\mathrm{adapt}}`$ | $`t^{*}_{\mathrm{phys}}`$ | $`t_{\mathrm{fail}}`$ | $`\Delta_{\mathrm{lock}}`$ |
|---|---|---|---|---|---|---|---|
| A: stay generalist | 42 | 0 | 42 | 12 | 13 | 15 | 1 |
| B: specialize at $`t=0`$ | 63 | 19 | 44 | 10 | 13 | 15 | 3 |

$`t^{*}_{\mathrm{policy}}=-1`$ in both, because neither can farm without training. $`t_{\mathrm{fail}}=15`$ follows the convention of I.3.6: both histories starve during tick 14 (stocks 0 and 2 against consumption 3), so $`s_{15}\notin\mathcal V`$.

B holds **at least as much stored food as A at every tick, and strictly more from $`t=2`$ through $`t=14`$**. Any objective monotone in the stock path ranks B at least as high as A. In this base case B also delivers 44 units of useful harvest to A’s 42.

Yet B's reorganization window closes two ticks earlier, and its lock-in interval is three times as long. At $`t=11`$, B holds 11 food and is at $`\sigma=3`$, while A holds 9 and is at $`\sigma=2`$. The settlement with more food is the one that can no longer reorganize.

**Which rule selects B?** At each tick, consider every admissible first action and score its best continuation over the next two ticks (or the time left to the horizon). Maximize the number of ticks survived within that lookahead, then the sum of food stocks at the ends of those ticks. Execute the first action and repeat. The Python reference enumerates second actions. Lean uses the fact that assigning everyone to forage on the final tick maximizes that tick’s ending stock: newly planted crops arrive later. Two deterministic ways of resolving equal scores give different outcomes.

- **Favor foraging.** Among equally scoring actions, prefer more foragers, fewer trainees, keeping the current specialization, then more farmers. This rule specializes at tick 0 and follows B until starvation. At tick 11 it holds 11 food and is locked in.
- **Favor training.** Break ties by more trainees, then more farmers, then more foragers, then keeping the current specialization. This rule also specializes at tick 0. It assigns two workers to training at ticks 4 and 5 while storage is full, uses one trainee at ticks 6 and 7, and completes training during tick 8. It matches B’s stock through tick 10, holds 17 at tick 11, and reaches tick 16 with 20 food.
- **Shielded.** Restrict the foraging-tie rule to actions whose next state stays in $`\mathcal K_{\mathrm{adapt}}`$. This rule also specializes at tick 0 and matches B’s stock through tick 10. It then trains during ticks 10–12, when wild yield is zero and foraging produces nothing. It acquires farming at tick 13 and reaches tick 16 with 8 food. Each override scores the same on the two-tick objective as the action it replaces.

**Remark (invisibility).** At no tick before lock-in does stored food favor the generalist history. Specialized history B crosses its point of no return between $`t=10`$ and $`t=11`$ while holding 14 and then 11 food. Generalist history A crosses its own between $`t=12`$ and $`t=13`$, while holding 6 and then 3. The quantity the settlement would naturally monitor moves in the opposite direction to its recoverability. This is the invisibility result referred to in I.5.2 and in the conclusion.

**Scope.** The example establishes that every class is nonempty and that the classes are distinct. It shows that the paradox mechanism is realizable within the formal framework: specialization raises useful output while raising reorganization latency, until a physically available recovery becomes organizationally unreachable.

The model assigns the specialist a retraining cost of eight worker-ticks and the generalist a cost of two. Leonard-Barton (1992) documents how established capabilities can obstruct new development. March (1991) models the short-run advantages of exploitation, and Repenning and Sterman (2002) trace how demands on current production compete with investments whose benefits arrive later. Here both rules initially specialize. The difference arises when the specialist can redirect labor to training without losing food on its two-tick objective: when a full store would discard the surplus, or once wild yield has run out and foraging produces nothing. Resolving that tie determines whether it retains a feasible recovery path. With a cost on training, the choice is no longer a tie (I.7, Experiment E). The example establishes existence. The origins and frequency of such costs in real organizations remain empirical questions.

The lock-in also depends on the idealized physical class, which can farm without training. That is by design: $`\mathcal K_{\mathrm{phys}}`$ marks what the physics permits, and the gap to $`\mathcal K_{\mathrm{adapt}}`$ is exactly the cost of having to learn.

*Code.* The Lean library certifies the base pair’s storage dominance, closing ticks, severities and witnesses, and the outcomes of the two decision rules at tick 11 and the horizon. Its transition proof shows that training progress stays valid for every pair of thresholds, including when training and specialization coincide. Experiment E executes the decision rules across the parameter grid in Lean and Python, and the friction sweep (`Paradox/Friction.lean`) adds the shielded rule, a training cost and skill decay. The general propositions and robust-kernel counterexample are proved separately in `Paradox/Theory.lean`.

## I.4. The mechanism

### I.4.1 What organization creates

Organization creates specialization, division of labor, infrastructure dependencies, concentrated knowledge, institutional commitments, coordination overhead, and material and informational bottlenecks. These features improve performance under some conditions. They can also:

- reduce substitutability,
- raise switching costs,
- eliminate redundant capabilities,
- lengthen recovery times.

### I.4.2 The feedback loop, in the formal terms of I.3

**Adaptation → change in $`O`$ and $`q`$ → change in $`\mathcal C(O)`$ and in move latencies → change in where the kernel boundaries fall → change in future adaptability.**

Two quantities carry the loop:

- **Reorganization latency.** For a capability $`c`$, let $`\ell(c\mid O,q)`$ be the minimum time to acquire $`c`$ from the current organization through admissible moves. In the exact model, specialization raises the latency of acquiring farming from 2 to 8 worker-ticks.
- **Substitution breadth.** The set of distinct ways the realizable action set $`\mathcal A(x,O,q)`$ can meet a given requirement. Specialization, sole-source dependencies and lost skills narrow it. Breadth is measured relative to a disturbance set $`\mathcal W_{\mathrm{dist}}`$ (I.3.8): it counts the ways of meeting the requirement that survive the disturbances in that set. Distinct activities that share an upstream prerequisite add no breadth against a disturbance that disables that prerequisite, however many of them there are. This is the settlement-scale form of "redundancy is not independence" (Argument III, III.6).

**Organizational margin.** For a state $`s`$ at time $`t`$, let
```math
\mu(s,t)=t^{*}_{\mathrm{adapt}}(s,t)-t,
```
where $`t^{*}_{\mathrm{adapt}}(s,t)`$ is the point of no return (Definition 4) of the baseline started from $`(s,t)`$. Set $`\mu=-1`$ if $`s\notin\mathcal K_{\mathrm{adapt}}(t)`$. The margin is the number of ticks the incumbent can keep running before reorganization stops being able to save it.

**Mechanism hypothesis.** An adaptation that raises output can reduce the recovery margin if it delays acquisition of a capability needed before the deadline or removes an available substitute. Additional production can offset that loss if it can be stored. The settlement experiment varies retraining requirements and storage capacity to test when the margin actually falls (I.7).

### I.4.3 The direction must be established, not assumed

The loop can run either way. Shortening the latency of a needed capability can raise the margin when that latency limits recovery. A specialized restoration crew, for example, can shorten recovery after the disturbances it was built for.

The sign depends on the disturbance. The same specialization can raise margin against anticipated disturbances and lower it against others. This is the "robust yet fragile" structure that Carlson and Doyle identified in designed systems (I.6). The framework therefore makes no unconditional claim that specialization is harmful. It measures $`\mu`$ for a specified environment path or disturbance set, and the sign is an output of the measurement.

The sign also depends on which disturbances are modeled, and optimizing over a fixed set cannot correct for the ones left out. Suppose a costly cycle-breaking capability, such as a black-start seed (Argument III, III.6), changes nothing on any modeled disturbance. Then a robust optimizer over a finite disturbance set values it at exactly minus its cost (`robust_seed_value` in `Paradox/Theory.lean`). With any positive cost it never chooses it, however decisive the seed would be against a disturbance outside the set (`robust_never_picks_seed`, `seed_example`). This is one formal route to "robust yet fragile": the organization is optimized against the modeled set and stripped of the capability that would protect it against the rest. Restoration independence therefore has to be imposed as a structural requirement; payoff-based optimization will not supply it.

## I.5. The paradox

### I.5.1 Informal statement

Consider an organization that repeatedly chooses adaptations that maximize immediate output or reduce operating costs. Each decision may be locally rational. Yet the accumulated organizational changes can contract the set of feasible recovery paths. **The adaptations that make a system more successful can make it less able to survive the consequences of its success.**

### I.5.2 Formal statement

Fix an objective $`J`$ on histories: the quantity the system's decision rule actually maximizes over its comparison horizon.

**Definition 5 (paradox pair, relative to $`J`$).** Two admissible histories $`h_A,h_B`$ from a common $`s_0`$, compared at a time $`t_1`$, form a **paradox pair for $`J`$** if:

1. $`J(h_B)\ge J(h_A)`$ over the comparison horizon, and
2. $`\mu(s^B_{t_1},t_1)\lt \mu(s^A_{t_1},t_1)`$.

The pair is **selected** for a specified decision rule if the rule, including its admissible alternatives, lookahead, and tie-breaking order, produces $`h_B`$ while maximizing its stated objective over that lookahead. The lookahead is shorter than the disturbance timescale. Pairwise dominance alone establishes the ordering of the two reported histories.

Paradox pairs come in two types, distinguished by how $`J`$ relates to viability.

- **Resource type.** $`J`$ is monotone in the physical path: dominating every viability-relevant physical quantity at every tick never lowers $`J`$. In addition, $`h_B`$'s $`x`$-path dominates $`h_A`$'s ($`x^B_t\succeq x^A_t`$ at every tick, strictly at some tick). Such a pair is a paradox pair for **every** monotone $`J`$ at once. The pair is **strong** if, in addition, there is a time $`t`$ at which

  $`\displaystyle \sigma(s^B_t,t)=3,\qquad \sigma(s^A_t,t)\le2.`$

  The system with at least as many resources is locked in, while the poorer one can still reorganize. Under the hypotheses of Proposition 4, reaching this pair of severity classes requires a difference in organization or commitments at that tick.
- **Externality type.** The reported objective can reward consumption while omitting a viability-relevant burden such as cumulative emissions. A history with the higher score can then have the lower recovery margin. The climate experiment compares two specified deployment rules on such an objective. A claim that one rule optimizes the objective would additionally require a decision model that selects it.

**The two parts of the claim.** Condition 1 together with condition 2 is a **tradeoff**: output and organizational margin can move in opposite directions. Selection is the **paradox** proper: success-seeking behavior picks the low-margin side. The tradeoff alone is the familiar efficiency–resilience relationship. Selection is what makes success erode its own preconditions, and it is the part that could be false for a given class of systems.

**Existence.** The exact model of I.3.10 contains a selected, strong paradox pair of resource type:

- Specializing at $`t=0`$ yields at least as much stored food at every tick, and strictly more from $`t=2`$ through $`t=14`$. Useful harvest is 44 against 42.
- The reorganization window closes at $`t=10`$ instead of $`t=12`$.
- At $`t=11`$ the specialized settlement holds 11 food and is at $`\sigma=3`$. The generalist settlement holds 9 food and is at $`\sigma=2`$.

I.3.10 establishes selection for the two-tick rule that favors foraging on ties. For the same lookahead and stock objective, a tie in favor of training can preserve the recovery option at zero short-term cost in food. Across the Experiment E grid, selection in the frictionless model is entirely a matter of tie-breaking. A viability shield on the foraging rule survives in all 6,000 settings without ever lowering the two-tick objective. With a training cost of one food per trainee-tick, selection becomes strict in every setting where the foraging rule locks in (I.7, Experiment E).

**Invisibility.** In this pair, the quantity the decision rule monitors gives no warning at any tick before lock-in. The specialized history is ahead on stored food at the moment it crosses its point of no return. Margin $`\mu`$ is not a function of the monitored quantity. It has to be computed separately. (See also the remark at the end of I.3.10.)

**Two mechanisms.** In the settlement, specialization raises the farming requirement from 2 to 8 worker-ticks. The stocks conceal the cost of continuing to forage while retraining could still be completed. In the climate comparison, two prescribed deployment rules invest differently in capacity. Cumulative consumption omits a burden that matters for recovery.

### I.5.3 The paradox is organizational

The informal literature often attributes fragility to complexity. The relevant variable here is narrower: the relationship between organizational structure and the reorganization moves available within the margin. The specialized settlement in I.3.10 is no more complex than the generalist one. It differs in one bit of $`O`$, and that bit changes a latency.

This is an application of viability comparison. De Lara et al. (2007) derive order properties for discrete-time viability kernels from monotone dynamics and constraints. De Lara, Gajardo and Vicencio (2020, Theorem 7) compare continuous-time viability kernels using ordered controlled trajectories. Here the comparison is over a finite horizon and matches organizational state and commitments at every step.

**A4 (organizational monotonicity).** Fix $`(O,q)`$. If $`x\succeq x'`$, then for every admissible class-$`k`$ step from $`(x',O,\pi,q)`$ there is an admissible class-$`k`$ step from $`(x,O,\pi,q)`$. Its result has an $`x`$-component that is $`\succeq`$ the result of the first step, and the same $`(O,q)`$-component. Here $`\succeq`$ and upward closure of $`\mathcal V_x,\mathcal W_x`$ are as in A3′.

**Proposition 4 (resources cannot by themselves worsen severity).** Under A0, A2 and A4, let $`s=(x,O,\pi,q)`$ and $`s'=(x',O,\pi',q)`$ be two states with the same organization and commitments, and with $`x\succeq x'`$. Assume switching between $`\pi`$ and $`\pi'`$ requires no implementation move (otherwise take $`\pi=\pi'`$). Then for $`k\in\{\mathrm{policy},\mathrm{adapt},\mathrm{phys}\}`$:
```math
s'\in\mathcal K_k(t)\ \Longrightarrow\ s\in\mathcal K_k(t).
```
In particular, if $`\sigma(s',t)\ge1`$, then $`\sigma(s,t)\le\sigma(s',t)`$.

*Proof.* Take a class-$`k`$ continuation from $`s'`$. Inductively, A4 gives a class-$`k`$ continuation from $`s`$ whose $`x`$-path dominates it at every tick and whose $`(O,q)`$-path is identical. The differing stored policies $`\pi,\pi'`$ do not matter. A revision without an implementation move takes effect in the tick it is made (I.3.1), so a policy- or adapt-class continuation chooses its time-$`t`$ action freely from either state. This assumes the model requires no implementation move to switch between $`\pi`$ and $`\pi'`$. If it does, the state already holding the better policy saves that latency, and the proposition needs $`\pi=\pi'`$, as in the Lean version. The physical class ignores $`\pi`$ altogether. Revisions awaiting an implementation move are recorded in $`q`$, which the two states share. Upward closure keeps the dominating path in $`\mathcal V_x`$ and $`\mathcal W_x`$. The fixed class is excluded because the incumbent's response to a richer state need not be monotone. $`\square`$

**Corollary (fingerprint of the paradox).** Assume the resource order, upward closure and step-matching conditions of Proposition 4. Suppose stored policies coincide or can be switched immediately. At any tick showing the severity gap of a strong resource-type pair, $`(O^B_t,q^B_t)\neq(O^A_t,q^A_t)`$. If these components were equal, the richer member could reproduce a viable adapt-class continuation from the poorer member.

The Lean statement (`Theory.resources_monotone`) takes every non-physical component, $`\pi`$ included, as a single shared component, and so requires equal $`\pi`$. The version above relaxes this using the immediate-revision convention.

The exact model satisfies A4. The corollary is confirmed numerically there:

- across about 1.36 million pairs of states with the same $`(O,q)`$, richer never means less recoverable;
- all 22,484 strong-paradox state pairs differ in $`(O,q)`$.

The corollary identifies a necessary difference in modeled state. Determining which feature produced the loss of recoverability in a particular organization requires a comparison that varies that feature while holding the others fixed.

## I.6. Relation to existing research

Leonard-Barton (1992) describes successful capabilities becoming obstacles to change. Heitzig et al. (2016) classify recoverability under default dynamics and management, and Pichancourt, Brias and Bonis (2025) already compute finite-horizon viability for nested governance arrangements. These precedents place the present contribution at the level of a specific diagnostic and a checkable example.

| Tradition | Core idea | Relation to this framework |
|---|---|---|
| Core capabilities and core rigidities (Leonard-Barton 1992) | Case studies of new product development show how skills, technical systems, management systems and values can support one project and impede another. | I.3.10 models one such impediment as a longer retraining time and computes the tick at which it closes a recovery option. |
| Competency traps and the myopia of learning (Levitt & March 1988, March 1991, Levinthal & March 1993) | March models why the faster and more local returns to exploitation can crowd out exploration. | I.3.10 makes the choice among equal short-run scores explicit. Its margin measures how long a successful intervention can be delayed. |
| Production pressure and capability traps (Repenning & Sterman 2002) | A study of two improvement efforts at one firm relates pressure to produce, delays in returns to improvement, and managers’ explanations of poor performance. | In the settlement, foraging and training compete for labor. The decision rule and retraining times are specified, and the set of successful continuations can be enumerated. |
| Ordinary and dynamic capabilities (Winter 2003) | Ordinary capabilities support current operations. Dynamic capabilities are patterned means of creating or modifying them. | The policy and adapt classes also distinguish using a capability from changing it. The adapt class additionally permits a one-off reorganization. |
| Innovator's dilemma (Christensen 1997) | Incentives to serve current customers can impede the response to disruptive change. | A candidate setting for testing selection. Establishing a pair in I.5.2 would require a decision rule, alternatives and a deadline. |
| Structural inertia (Hannan & Freeman 1984) | Selection favors reliable, reproducible, hence inert organizations | A population-level selection mechanism for low-margin organizations |
| Highly optimized tolerance (Carlson & Doyle 1999, 2002) | Designs optimized for anticipated disturbances can be fragile to unanticipated perturbations. | The settlement compares organizations on the same specified disturbance path and measures the remaining time to change capability. |
| Viability and reachability (Bertsekas & Rhodes 1971, Aubin 1991, Mitchell, Bayen & Tomlin 2005, De Lara et al. 2007) | Target tubes, viability kernels and backward recursion describe which initial states admit successful continuations. | Definition 2 applies this construction to each control class. Proposition 1 checks that the classes can be compared, including the physical relaxation. |
| Topology of sustainable management (Heitzig et al. 2016, Kittel et al. 2021) | Heitzig et al. classify states by what default dynamics and management can sustain or reach. Kittel et al. express the main partition through viability kernels and capture basins and compute it with a viability algorithm. | Our five severities record the least sufficient intervention for one horizon and terminal condition, with separate classes for policy revision, feasible capability change and physical control. |
| Dynamic adaptive policy pathways (Haasnoot et al. 2013) | Adaptation tipping points indicate when an action ceases to meet objectives under a scenario, making it necessary to switch pathways. | Here a class-specific deadline is the last baseline state from which some continuation in that entire class can meet the criterion. |
| Nested governance and viability (Pichancourt, Brias & Bonis 2025, Steps 1.4 and 4.2, Eqs. 3–4) | Adaptation pathways include operational, collective-choice and constitutional changes. A finite-horizon kernel identifies states admitting viable sequences of governance actions. | Our classes identify whether an incumbent policy, a revised policy, a feasible capability change, or an idealized physical action suffices. The gap between the last two defines organizational lock-in. |
| Path dependence and lock-in (David 1985; Arthur 1989; Pierson 2000) | Increasing returns lock in early choices | Lock-in here is defined against a physical counterfactual and a deadline, not just against efficiency |
| Resilience and adaptive cycles (Holling 1973; Gunderson & Holling 2002) | Growth phases accumulate connectedness and rigidity, reducing resilience | The conservation-phase "rigidity trap" resembles the lock-in interval. The framework gives it a membership test |
| Ascendency and the window of vitality (Ulanowicz et al. 2009) | Information-theoretic tradeoff between network efficiency and reserve capacity | A candidate measurable proxy for margin in flow networks |
| Niche construction (Odling-Smee, Laland & Feldman 2003) | Organisms modify their own selective environment | The endogenous environment path that connects Argument I to Argument II |
| Organizational slack (Cyert & March 1963, Bourgeois 1981) | Uncommitted resources buffer shocks and enable experimentation. | Proposition 4 gives conditions under which adding resources preserves a viable policy, adaptation or physical continuation. The conditions include upward-closed criteria and the ability to match the poorer state’s steps. |
| Complexity and collapse (Tainter 1988) | Declining marginal returns to complexity | The framework replaces complexity with latency relative to margin (I.5.3) |
| Normal accidents (Perrow 1984) | Tight coupling and interactive complexity produce system accidents | Coupling bears on substitution breadth and restoration independence (Argument III) |
| Coordination failure (Cooper & John 1988) | Multiple equilibria; agents fail to coordinate on the better one | Operational mismatch ($`\sigma=1`$) is the single-organization analogue |
| Requisite variety (Ashby 1956) | A controller needs at least as much variety as the disturbances it must counter | Substitution breadth is a variety measure on $`\mathcal A`$ |
| Empowerment (Klyubin, Polani & Nehaniv 2005) | Information-theoretic measure of an agent's control over its future | A candidate objective for preserving options (Argument III) |
| Early-warning signals (Scheffer et al. 2009) | Critical slowing down precedes transitions | A route to estimating margin from observable data, relevant to the invisibility result |

**Contribution of this argument.** The four control classes let the analyst ask a specific counterfactual at a specified deadline. Could a new policy succeed with the capabilities already present? If another capability is needed, can it still be acquired in time? Would recovery remain physically possible if acquisition constraints were relaxed? Applying these tests along the same baseline identifies the interval during which physical recovery remains possible after organizational recovery has closed.

The settlement supplies a reproducible existence result for that interval. In the base comparison the specialist holds 11 food at tick 11 and has lost its recovery option, while a generalist holding nine can still retrain. The two decision rules isolate a separate point about selection. Both maximize the same two-tick objective and specialize at the outset. Favoring foraging on ties carries the specialist into lock-in, while favoring training allows it to survive. Extending this finding to firms or other systems requires evidence about their action sets, retraining delays and decision rules.

## I.7. Empirical tests

All tests use fixed horizons, a viability criterion declared before any run, multiple seeds, and severity reported as an interval (I.3.7).

**Experiment A — operational mismatch.** In Everfall, compare the original and revised coordination bundles on a common build, with capability changes (direct foraging) disabled, under the survival criterion. This establishes or refutes $`\sigma=1`$ (I.3.9).

**Experiment B — the reorganization window.** Introduce a disturbance and measure $`t^{*}_{\mathrm{adapt}}`$: the latest time at which an admissible reorganization still preserves viability.

- In the exact model it is computed directly.
- In Everfall, model capability changes as in-simulation moves with latency and cost. Report an open window when a witness succeeds. Report a closed window for a stated class when a certificate or complete search excludes every continuation in it. A search over selected moves leaves the broader class unresolved.

**Experiment C — specialization against margin.** Sweep specialization level. At each level, measure output $`J`$ and margin $`\mu`$, then overlay the path a greedy decision rule actually takes.

- The tradeoff is present if the frontier slopes downward somewhere.
- The paradox is present if the greedy path selects into that region.
- A flat frontier, or a greedy path that stays at high margin, falsifies the paradox for that system.

**Experiment D — scale and restoration.** Add infrastructure and coordination layers. Measure how normal-operation output changes alongside $`t^{*}_{\mathrm{adapt}}`$, $`t^{*}_{\mathrm{phys}}`$, and restoration independence (the bootstrap closure of Argument III). ArcWake is the natural environment for this.

**Experiment E — prevalence within the model family (completed).** The exact model was swept over 6,000 parameter settings:

- specialist retraining cost 1–10 worker-ticks, with generalists fixed at 2;
- specialization bonus 1–2;
- storage capacity 12–30;
- horizon 12–20;
- 12 disturbance timings.

For each setting the experiment runs the prescribed generalist and specialist histories, then independently runs both two-tick decision rules of I.3.10. The Python reference checks the results for every setting.

- **Prescribed-pair frequency.** Storage dominance and an earlier recovery deadline coincide in 1,581 of 6,000 settings (26.4%). All 1,581 also contain a tick where the specialist is locked in while the generalist can still recover. In 798 of these settings cumulative useful harvest ties. The 26.4% describes this pairwise stock-path comparison.
- **Retraining time and the prescribed pair.** The stock-and-window tradeoff occurs in 0 of 1,800 settings with specialist cost at most 3 worker-ticks, which three trainees clear in one tick, as generalists do. With 1, 2 and 3 extra ticks it occurs in 27.3%, 41.7% and 56.5% of settings respectively. B’s recovery window closes earlier by at most the number of added ticks.
- **Banking the surplus prevents it.** Prevalence falls with storage capacity: 61.3% at capacity 12, 24.3% at 20, and 0.4% at 30. Where specialists with high retraining costs can store their extra output, the surplus pays for the longer retraining. Where storage caps it, it cannot. With 3 or more added ticks and capacity 12, the paradox occurs in 98.3% of settings.
- **Nothing hides behind gross output.** No setting shows an earlier window close without storage dominance.
- **Decisions across the grid.** The two-tick rule that favors foraging enters lock-in in 4,940 settings (82.3%) and survives to the horizon in 1,060. In the same 1,581 settings identified by the prescribed-pair comparison, this rule reaches a tick when it holds at least as much stored food and incoming harvest as generalist A, A can still recover, and the rule is locked in. With training favored on ties, the settlement survives to the horizon in all 6,000 settings and never enters lock-in. The grid and objective are the same for both rules.

The prescribed-pair tradeoff occupies a broad region of this grid. Its boundary suggests a testable mechanism: additional production can buffer a longer training delay only when the settlement can store the surplus. These frequencies describe the chosen parameter grid. Real-world prevalence requires observations of retraining times, stock limits and decisions.

**Tie-breaking versus strict selection.** A third rule restricts the foraging rule to actions whose next state stays in $`\mathcal K_{\mathrm{adapt}}`$. This viability shield is computable here because the kernels are exact. Two optional frictions, off in all the results above, separate tie-breaking from strict selection. A **training cost** $`c`$ charges food per trainee-tick. Under **skill decay**, farming is lost after $`d`$ consecutive ticks with no farmers.

- **Without friction, lock-in is tie-breaking.** The shielded rule survives in all 6,000 settings. It overrides the foraging rule in exactly the 4,940 settings where that rule locks in, and no override lowers the two-tick objective. Of the 10,868 overrides, 10,750 occur after wild yield has run out, when foraging produces nothing. Of the remaining 118, 113 occur with storage full.
- **With $`c=1`$, selection is strict.** In every one of the 4,940 settings, at least one override lowers the two-tick objective, and the shield still survives in all 6,000. The rule favoring training on ties survives in only 2,075 settings. A rule that acquires farming only when training ties with foraging, then specializes, survives in 660. In 523 settings the shield blocks specialization itself. There, specializing at tick 0 leaves $`\mathcal K_{\mathrm{adapt}}`$ immediately while scoring strictly higher on the two-tick objective. Without the training cost this never happens, because free retraining keeps specialization recoverable.
- **The food deficit understates the price.** At the tick the foraging rule locks in, the shielded rule holds on average 1.42 less food (stock plus incoming harvest). In 1,316 settings the deficit at that tick is zero, because the shield's costs fall later. In 793, the trainee's food came out of surplus that the full store would have discarded. In 523, the declined specialization bonus had not yet arrived.
- **Skill decay closes the "acquire first" route.** A rule that acquires farming as fast as it can without starving, then specializes, survives in all 6,000 settings without friction. With $`d=2`$ it locks in 1,425 settings, and 3,160 when $`c=1`$ is added. Decay leaves the two-tick rules unchanged, because they acquire farming only when they need it and then farm every tick.

One food per trainee-tick is the smallest nonzero cost in this integer model, so the threshold for strict selection cannot be located more finely here. Lean and the Python reference produce identical counts (`results/friction_output.txt`).

**Measured separately:** useful output, buffer capacity, substitution breadth, reorganization latency, $`\mu`$, $`\Delta_{\mathrm{lock}}`$, and survival.

## I.8. Strongest objections

**"Isn't this just path dependence, resilience theory or core rigidities?"** Those traditions describe much of the phenomenon. Earlier work also classifies recoverability and computes intervention deadlines (I.6). Here the specific diagnostic asks whether changing the operating policy suffices, whether a new capability can still be built in time, and whether physics permits recovery at all. The settlement makes each answer checkable and shows when the decision rule selects the lower-margin path.

**"Does one failed scheduling policy establish anything general?"** No. The scheduler incident is motivation, and its own classification is provisional. Generality rests on the formal framework and on the exact model, which establishes existence. Prevalence is left to Experiments C–E.

**"Can specialization increase resilience?"** Yes. The direction of the loop depends on the disturbance (I.4.3). The framework claims only that the sign must be measured, and supplies the measurement.

**"How do you tell structural lock-in from a poor search algorithm?"** By the evidence standard of I.3.7. Lock-in is claimed only when non-membership in $`\mathcal K_{\mathrm{adapt}}`$ is established, by exhaustive enumeration as in the exact model, or by a certificate. "No escape found under budget $`B`$" is reported as such, with its escape-rate-versus-budget curve.

**"The toy is rigged: you chose 8 versus 2."** The base case specifies the latency difference. The prescribed-pair tradeoff recurs in 26.4% of the chosen grid and in 98.3% of its low-storage, highest-latency slice. The two decision-rule runs measure the separate effect of tie-breaking on lock-in. Whether actual organizations acquire these latencies or use comparable decision rules is an empirical question.

**"Isn't the selection just a tie-breaking artifact?"** In the frictionless model, yes. A viability shield saves every setting without lowering the two-tick objective, so the foraging rule's lock-in comes from how it breaks ties. Once training costs one food per trainee-tick, every setting where the foraging rule locks in requires a strict sacrifice to stay recoverable (I.7, Experiment E). The paradox proper therefore needs acquiring the substitute capability to cost something within the decision rule's lookahead. The base model omits that cost once wild yield has run out.

**"The physical class is unrealistically idealized."** By design. $`\mathcal K_{\mathrm{phys}}`$ marks what the modeled physics permits, so that the gap to $`\mathcal K_{\mathrm{adapt}}`$ measures exactly the cost of organization. A less idealized physical class can be substituted. Proposition 1 needs only A3 or A3′.

**"What would falsify the mechanism?"**
- For a given class of systems, the paradox (selection) is falsified if $`J`$-maximizing histories never have lower margin than the available alternatives (Experiment C).
- A strong resource-type pair with identical organization and commitments would challenge the model’s diagnostic. One would need to check the resource ordering, upward closure, the step-matching assumption and any policy-switching delay before attributing the gap to a particular mechanism.
- The empirical relevance of the mechanism is undermined if, across systems where latency can be measured, specialization shows no relationship to $`t^{*}_{\mathrm{adapt}}`$.

## Conclusion

The state of an adaptive system cannot be evaluated by its current productive capability alone. Its organization determines which future states remain reachable, and how long they remain so.

Three results anchor that claim:

- **Organization alone can set severity.** In an exact model, three settlements in the same physical state, environment and deadline fall into three different severity classes because of their organization.
- **A stock-maximizing rule can select lock-in.** A two-tick rule that favors foraging on ties exhausts its recovery window while a poorer generalist can still recover. Favoring training on ties allows the specialist to survive to the horizon. In the frictionless model the difference is tie-breaking. With a training cost of one food per trainee-tick, staying recoverable requires a strict sacrifice in every setting where the foraging rule locks in.
- **Resource dominance has a conditional implication.** If a poorer state can still reorganize and a richer state is locked in, Proposition 4 implies a difference in modeled organization or commitments when its ordering and policy-switching assumptions hold.

At the tick when the specialist that keeps foraging loses its recovery option, its stored food still exceeds the generalist’s. A food-stock comparison alone gives no warning of the lost option. The available capabilities and time left to deploy them distinguish these states.

**Argument I establishes why adaptive capability must be evaluated dynamically, and supplies the quantities for doing so.** Argument II asks how fast those quantities move. Argument III asks how to keep them positive.

## References

Arthur, W. B. (1989). Competing technologies, increasing returns, and lock-in by historical events. *The Economic Journal*, 99(394), 116–131. [Article](https://doi.org/10.2307/2234208)

Ashby, W. R. (1956). *An Introduction to Cybernetics*. Chapman & Hall. [Author’s archive](https://www.ashby.info/Ashby-Introduction-to-Cybernetics.pdf)

Aubin, J.-P. (1991). *Viability Theory*. Birkhäuser. [Publisher’s 2009 reprint](https://doi.org/10.1007/978-0-8176-4910-4)

Bertsekas, D. P., and Rhodes, I. B. (1971). On the minimax reachability of target sets and target tubes. *Automatica*, 7(2), 233–247. [Article](https://doi.org/10.1016/0005-1098(71)90066-5)

Bourgeois, L. J., III. (1981). On the measurement of organizational slack. *Academy of Management Review*, 6(1), 29–39. [Article](https://doi.org/10.5465/amr.1981.4287985)

Carlson, J. M., and Doyle, J. (1999). Highly optimized tolerance: A mechanism for power laws in designed systems. *Physical Review E*, 60(2), 1412–1427. [Article](https://doi.org/10.1103/PhysRevE.60.1412)

Carlson, J. M., and Doyle, J. (2002). Complexity and robustness. *Proceedings of the National Academy of Sciences*, 99(Suppl. 1), 2538–2545. [Article](https://doi.org/10.1073/pnas.012582499)

Christensen, C. M. (1997). *The Innovator’s Dilemma: When New Technologies Cause Great Firms to Fail*. Harvard Business School Press. [Author’s institute](https://www.christenseninstitute.org/book/the-innovators-dilemma/)

Cooper, R., and John, A. (1988). Coordinating coordination failures in Keynesian models. *The Quarterly Journal of Economics*, 103(3), 441–463. [Article](https://doi.org/10.2307/1885539)

Cyert, R. M., and March, J. G. (1963). *A Behavioral Theory of the Firm*. Prentice-Hall. [1963 edition](https://books.google.com/books/about/A_Behavioral_Theory_of_the_Firm.html?id=9olEAAAAIAAJ)

David, P. A. (1985). Clio and the economics of QWERTY. *American Economic Review*, 75(2), 332–337. [Article](https://www.jstor.org/stable/1805621)

De Lara, M., Doyen, L., Guilbaud, T., and Rochet, M.-J. (2007). Monotonicity properties for the viable control of discrete-time systems. *Systems & Control Letters*, 56(4), 296–302. [Article](https://doi.org/10.1016/j.sysconle.2006.10.007)

De Lara, M., Gajardo, P., and Vicencio, D. (2020). Comparison theorem for viability kernels via conic preorders. *Systems & Control Letters*, 145, 104799. [Article](https://doi.org/10.1016/j.sysconle.2020.104799)

Gunderson, L. H., and Holling, C. S. (Eds.). (2002). *Panarchy: Understanding Transformations in Human and Natural Systems*. Island Press. [Book](https://doi.org/10.2307/jj.41003716)

Haasnoot, M., Kwakkel, J. H., Walker, W. E., and ter Maat, J. (2013). Dynamic adaptive policy pathways: A method for crafting robust decisions for a deeply uncertain world. *Global Environmental Change*, 23, 485–498. [Article](https://doi.org/10.1016/j.gloenvcha.2012.12.006)

Hannan, M. T., and Freeman, J. (1984). Structural inertia and organizational change. *American Sociological Review*, 49(2), 149–164. [Article](https://doi.org/10.2307/2095567)

Heitzig, J., Kittel, T., Donges, J. F., and Molkenthin, N. (2016). Topology of sustainable management of dynamical systems with desirable states: from defining planetary boundaries to safe operating spaces in the Earth system. *Earth System Dynamics*, 7, 21–50. [Article](https://doi.org/10.5194/esd-7-21-2016)

Holling, C. S. (1973). Resilience and stability of ecological systems. *Annual Review of Ecology and Systematics*, 4, 1–23. [Article](https://doi.org/10.1146/annurev.es.04.110173.000245)

Kittel, T., Müller-Hansen, F., Koch, R., Heitzig, J., Deffuant, G., Mathias, J.-D., and Kurths, J. (2021). From lakes and glades to viability algorithms: Automatic classification of system states according to the topology of sustainable management. *European Physical Journal Special Topics*, 230, 3133–3152. [Article](https://doi.org/10.1140/epjs/s11734-021-00262-2)

Klyubin, A. S., Polani, D., and Nehaniv, C. L. (2005). Empowerment: A universal agent-centric measure of control. *2005 IEEE Congress on Evolutionary Computation*, 1, 128–135. [Paper](https://doi.org/10.1109/CEC.2005.1554676)

Leonard-Barton, D. (1992). Core capabilities and core rigidities: A paradox in managing new product development. *Strategic Management Journal*, 13(S1), 111–125. [Article](https://doi.org/10.1002/smj.4250131009)

Levinthal, D. A., and March, J. G. (1993). The myopia of learning. *Strategic Management Journal*, 14(S2), 95–112. [Article](https://doi.org/10.1002/smj.4250141009)

Levitt, B., and March, J. G. (1988). Organizational learning. *Annual Review of Sociology*, 14, 319–340. [Article](https://doi.org/10.1146/annurev.so.14.080188.001535)

March, J. G. (1991). Exploration and exploitation in organizational learning. *Organization Science*, 2(1), 71–87. [Article](https://doi.org/10.1287/orsc.2.1.71)

Mitchell, I. M., Bayen, A. M., and Tomlin, C. J. (2005). A time-dependent Hamilton–Jacobi formulation of reachable sets for continuous dynamic games. *IEEE Transactions on Automatic Control*, 50(7), 947–957. [Article](https://doi.org/10.1109/TAC.2005.851439)

Odling-Smee, F. J., Laland, K. N., and Feldman, M. W. (2003). *Niche Construction: The Neglected Process in Evolution*. Princeton University Press. [Book](https://press.princeton.edu/books/paperback/9780691044378/niche-construction)

Perrow, C. (1984). *Normal Accidents: Living with High-Risk Technologies*. Basic Books. [1984 edition](https://openlibrary.org/books/OL3186144M/Normal_accidents)

Pichancourt, J.-B., Brias, A., and Bonis, A. (2025). Integrating adaptation pathways and Ostrom’s framework for sustainable governance of social-ecological systems in a changing world. *PeerJ*, 13, e18938. [Article](https://doi.org/10.7717/peerj.18938)

Pierson, P. (2000). Increasing returns, path dependence, and the study of politics. *American Political Science Review*, 94(2), 251–267. [Article](https://doi.org/10.2307/2586011)

Repenning, N. P., and Sterman, J. D. (2002). Capability traps and self-confirming attribution errors in the dynamics of process improvement. *Administrative Science Quarterly*, 47(2), 265–295. [Article](https://doi.org/10.2307/3094806)

Scheffer, M., Bascompte, J., Brock, W. A., Brovkin, V., Carpenter, S. R., Dakos, V., Held, H., van Nes, E. H., Rietkerk, M., and Sugihara, G. (2009). Early-warning signals for critical transitions. *Nature*, 461(7260), 53–59. [Article](https://doi.org/10.1038/nature08227)

Söntges, S., Koschi, M., and Althoff, M. (2018). Worst-case analysis of the time-to-react using reachable sets. *2018 IEEE Intelligent Vehicles Symposium*, 1891–1897. [Article](https://doi.org/10.1109/IVS.2018.8500709)

Tainter, J. A. (1988). *The Collapse of Complex Societies*. Cambridge University Press. [Publisher’s front matter](https://assets.cambridge.org/97805213/86739/frontmatter/9780521386739_frontmatter.pdf)

Ulanowicz, R. E., Goerner, S. J., Lietaer, B., and Gomez, R. (2009). Quantifying sustainability: Resilience, efficiency and the return of information theory. *Ecological Complexity*, 6(1), 27–36. [Article](https://doi.org/10.1016/j.ecocom.2008.10.005)

Winter, S. G. (2003). Understanding dynamic capabilities. *Strategic Management Journal*, 24(10), 991–995. [Article](https://doi.org/10.1002/smj.318)
