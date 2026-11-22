# Argument III — The Adaptive Escape Problem

**Subtitle:** *Finding Viable Transitions Through Endogenous Constraints*

*Working draft, November 2026. Builds on Argument I (Section I.3) and Argument II. Notation follows I.3.*

## Central claim

When an adaptive system's current organization cannot sustain viability, but physically feasible alternatives may exist, the essential problem is to find an attainable sequence of interventions that changes its capabilities before the remaining recovery paths close. The objective is not to preserve the original organization. **The solution only needs to be reachable from it.**

Argument III makes four claims about that problem:

1. **Escape inherits the worst-case hardness of planning.** Theorem III.1 gives a machine-checked translation from bounded STRIPS planning to an organization with a physical terminal condition. With the horizon written in binary, Bylander’s planning result gives a PSPACE lower bound for deciding escape.
2. **Some models admit exact computations.** The examples use explicit state spaces, monotone dynamics with a dominant rule, or monotone capability acquisition without a deadline or resource competition.
3. **Checking a surviving seed set and choosing one have different costs.** In the monotone restoration model, Horn forward chaining checks a proposed seed set in linear time. Under conjunctive prerequisites, Feige and Kogan’s directed target-set theorem identifies a smallest sufficient seed set with a minimum directed feedback vertex set (Theorem III.3).
4. **Incomplete computations can give bounds.** A viable continuation proves membership in a control class. An exclusion proof, including a complete search, can rule out that class. Lock-in requires evidence of physical feasibility and an exclusion for the adaptive class (Proposition III.4).

The practical question is which states admit a verified escape, which can be excluded, and how many remain unresolved at the available search budget.

## III.1. The escape problem

A system starts in state $`s_0=(x_0,O_0,\pi_0,q_0)`$, facing a changing environment and a deadline. A target state may be physically viable yet unreachable under its current organization. The question is whether the system can develop, acquire or reorganize the capabilities needed to reach a viable state, without violating viability along the way.

**Definition III.1 (escape problem).** Given a control class $`\mathcal U`$, a viability set $`\mathcal V`$, a terminal set $`\mathcal W\subseteq\mathcal V`$, a horizon $`T`$ and an initial state $`s_0`$, decide whether some $`\mathcal U`$-admissible continuation satisfies
```math
s_t\in\mathcal V\quad\forall t\in[0,T],\qquad s_T\in\mathcal W,
```
and if so, produce one.

The escape problem is membership in the reach-avoid kernel $`\mathcal K_{\mathcal U}(0)`$ of Definition 2 (I.3.4), together with a witness. Arguments I and II computed such kernels for specific models. Argument III asks what can be said about computing them in general.

## III.2. Successful adaptive escape

A finite-horizon escape is not automatically indefinite viability.

**Definition III.2 (successful adaptive escape).** An escape is **finite-horizon successful** if it satisfies Definition III.1. It is **sustainably successful** if, in addition, its terminal state lies in the infinite-horizon kernel:
```math
\begin{aligned}s_T\in\mathcal K_{\mathcal U}^{\infty}(T)=\bigl\{s:\ &\exists\ \text{a }\mathcal U\text{-admissible continuation from }(s,T)\\ &\text{with}\ s_t\in\mathcal V\ \ \forall t\ge T\bigr\}.\end{aligned}
```

$`\mathcal K_{\mathcal U}^{\infty}(T)`$ is the largest controlled-invariant subset of $`\mathcal V`$ from time $`T`$ on. The condition is placed on the terminal state, not on $`\mathcal W`$, and the reason is A0. Under A0, $`\mathcal W=\mathcal W_x\times\mathcal O\times\Pi\times\mathcal Q`$ depends only on the physical state. It therefore contains states with a good $`x`$ paired with an organization that cannot keep $`x`$ there. I.3.9 already noted that an $`x`$-only terminal set cannot by itself certify that reserves can be maintained. Requiring every state of $`\mathcal W`$ to be controlled-invariant would fail for reasons that have nothing to do with the escape. The alternative is to relax A0 and define $`\mathcal W`$ over $`(x,O,q)`$. This argument keeps A0.

Two remarks on scope:

- Indefinite maintenance may need ongoing moves, not a static policy, which is why the definition asks for a continuation.
- In a stationary environment, $`\mathcal K_{\mathcal U}^{\infty}`$ does not depend on $`T`$.

For periodic environments, the repeatability argument of I.3.9 gives a practical sufficient test. If a continuation returns, after one period, to the same organization and commitments with at least the same physical state, repeating it is viable indefinitely. For environments that keep changing, which is Argument II's setting, finite-horizon escape is the right target, renewed as the horizon advances.

## III.3. The three requirements for escape

| Requirement | Meaning | In the framework |
|---|---|---|
| **Physical feasibility** | matter, energy, equipment and time are available | $`s_0\in\mathcal K_{\mathrm{phys}}`$ |
| **Organizational realizability** | the system has or can build the mechanisms to mobilize them | $`s_0\in\mathcal K_{\mathrm{adapt}}`$ |
| **Adaptive continuity** | the system keeps functioning while it reorganizes | the escape path stays in $`\mathcal V`$, with the transitional restrictions of I.3.1 charged on the tick each move is made |

The three rows unpack what $`s_0\in\mathcal K_{\mathrm{adapt}}`$ requires; they are not conditions outside it. Membership in $`\mathcal K_{\mathrm{adapt}}`$ already entails physical feasibility, by Proposition 1. It also entails adaptive continuity, by Definition 2.

A desirable destination is insufficient if the transition itself is infeasible. The third requirement is the one most often missed. The toy model's specialists in I.3.10 had a physically available recovery, but retraining took workers off production long enough to starve the settlement first.

## III.4. Hardness

**Theorem III.1 (planning reduces to escape).** Take a finite propositional STRIPS instance with positive preconditions, add and delete lists, an initial state and a conjunctive positive goal. Construct the escape instance as follows.

- propositions become capabilities, and operators become reorganization moves, together with the null move (A1 of Argument I);
- a physical goal bit $`x\in\{0,1\}`$ is added, initially 0, with $`\mathcal W_x=\{1\}`$ and $`\mathcal V`$ the whole space;
- one operational action, *declare*, is added. It sets $`x`$ to 1 and is admissible, under $`\mathcal A(x,O,q)`$, only when every goal capability is present in $`O`$. No action resets $`x`$, so once set to 1 it stays 1.

The terminal set depends only on $`x`$, as A0 requires. Then for every bound $`n`$:
```math
\begin{gathered}\text{a plan of length}\le n\ \text{exists}\\ \iff\ \text{the organization can escape in exactly } n+1\ \text{steps}.\end{gathered}
```

*Proof.* Machine-checked in Lean (`Escape.planning_iff_escape_A0`).

- From plan to escape: follow the plan with null actions, declare, then wait with null moves.
- From escape to plan: declaration happens at some tick $`k\le n`$, when the goal capabilities are present. The non-null moves before tick $`k`$ form a plan of length at most $`k`$. $`\square`$

Lean also proves a simpler form, `Escape.planning_iff_escape`, with equivalence at exactly $`n`$ steps. That form places the goal directly on capabilities and so does not respect A0. Both proofs use no `sorry` and no `native_decide`, and depend only on Lean's standard axioms. The mapping adds only the null move, one bit and one action, so it is computable in polynomial time. That last step is a meta-level observation, not formalized.

**Corollary III.1.** Bylander (1994, Theorem 4.1) proves bounded STRIPS plan existence PSPACE-complete, already for operators with two positive preconditions and two postconditions. The hardness proof uses step bounds of size $`2^n`$, so the bound must be written in binary. Theorem III.1 transfers this lower bound to the escape decision problem for organizations described by capabilities and moves with a binary-encoded horizon. Theorem III.1 asks for a positive goal, which loses nothing. Replace each negative goal literal $`\neg p`$ by a fresh proposition $`\bar p`$ that holds initially exactly when $`p`$ does not, is added by every operator that deletes $`p`$ without adding it, and is deleted by every operator that adds $`p`$. Then $`\bar p`$ equals $`\neg p`$ in every reachable state. Preconditions stay positive, plan lengths are unchanged, and the construction takes polynomial time. Operators may gain postconditions, which does not matter because the target is general positive STRIPS. The Lean proof establishes the plan–escape equivalence. The complexity conclusion combines that equivalence with the polynomial encoding argument above. Earlier work by Abdulaziz and Kurz (2023) machine-checked a bounded planning encoding in Isabelle/HOL with a SAT formula as its target.

**Encoding the horizon.** A planning instance with $`p`$ propositions has at most $`2^p`$ distinct states, so a binary bound of $`2^p`$ suffices for any reachable goal. A witness may contain exponentially many actions, so simply printing one can take exponential time. For deterministic finite instances with a unary or polynomially bounded horizon, a guessed continuation is verifiable in polynomial time if states and actions have polynomial representations and admissibility, transitions, viability and the terminal condition are polynomial-time checkable. With a variable unary horizon the decision problem is NP-complete for such a class containing the instances of Theorem III.1. The NP lower bound already holds for the variable deadlines in the Set Cover construction of III.5.

**What the hardness depends on.** It comes from the compositional description. A system described by $`n`$ capabilities can have $`2^n`$ organizational states. When the states are listed explicitly, as in the 17,136-state model of I.3.10, the escape problem is ordinary graph search, which takes time polynomial in the number of states.

**Related decision problems.** Planning with partial observations and hybrid reachability have their own complexity results. Their conclusions depend on the horizon, objective and representation.

- **Partial observability.** Papadimitriou and Tsitsiklis (1987) prove PSPACE-completeness for a finite partially observed Markov decision process with a polynomial number of stages and an expected-cost threshold. Madani, Hanks and Condon (1999) prove undecidability for several infinite-horizon probabilistic planning objectives. Applying these results to the probabilistic reach-avoid kernel of I.3.8 requires matching its information pattern and objective.
- **Hybrid dynamics.** Henzinger, Kopke, Puri and Varaiya (1998) establish decidable reachability for initialized rectangular automata and undecidability for specified extensions. Their results concern unbounded reachability. Transferring an undecidability result to Definition III.1 would require specifying whether the horizon bounds elapsed time, the number of transitions, or both.

The lower bounds concern worst-case families of instances. A polynomial-time algorithm for every instance in Corollary III.1 would imply P = PSPACE. For the unary-horizon class above it would imply P = NP. Neither lower bound measures the difficulty of a particular organizational model.

In Argument I, the organization must estimate its own remaining options. Whether it has the information and time to do so is an empirical question even when the model belongs to a computationally hard class.

## III.5. Tractable structure

The first three rows describe computations used in this project. The last gives a structural restriction from the planning literature.

| Structure | Method | Cost | Used in |
|---|---|---|---|
| Small explicit state space | exact backward recursion | linear in time-indexed states × actions | I.3.10 (17,136 time-indexed states $`(t,x,O,q)`$, $`t=0,\dots,16`$; all classes exact) |
| Monotone dynamics with a dominant rule | simulate the dominant rule (Lean theorems `greedy_suffices` and `viab_sim` in `Theory`) | one simulation per query | climate certificate (Argument II, Appendix A) |
| Positive, add-only capability acquisition with no binding horizon or resource limits | Horn forward chaining | linear in the total explicit rule size and seed list | III.6 |
| Binary state variables, one effect per operator, polytree causal graph with fixed maximum indegree | the algorithm of Brafman and Domshlak (2003, §3) | polynomial-time plan generation without a deadline | planning literature |

A polytree has treewidth one when edge directions are ignored. Dropping the indegree bound already makes plan existence NP-complete for binary polytrees (Giménez and Jonsson 2008, Theorem 6.3).

**Theorem III.2 (monotone acquisition is tractable).** Suppose every move only adds capabilities, and requires only that certain capabilities be present. In planning terms: no delete effects, positive preconditions. Suppose also that there is no binding step limit, and that moves neither compete for resources nor risk leaving $`\mathcal V`$. Then:

- there is a reachable state containing all requested capabilities if and only if each belongs to the closure of the seeds under the moves,
- forward chaining computes that closure in time linear in the total size of the explicit rules and seeds.

*Proof sketch.* A seed is a fact. Each explicitly listed prerequisite alternative gives a definite Horn rule for its output. For a move with several outputs, introduce one intermediate fact for its premise and a rule from that fact to each output. Every firing is justified by an enabled move, and induction on any move sequence places its outputs in the least closure. The counter-and-queue algorithm of Dowling and Gallier (1984, §4) processes each prerequisite occurrence once. This gives the linear bound. The demonstration uses repeated scans of its small rule list. $`\square`$

**Why the horizon matters.** Give each set in a Set Cover instance an unconditional move that adds its elements. Take the universe as the goal and allow one move per tick. A cover using at most $`k`$ sets exists exactly when the goal is attainable within $`k`$ ticks. Thus the bounded decision problem is NP-complete even with no deletions or prerequisites (Karp 1972, Set Covering). Erol, Nau and Subrahmanian (1992, Theorem 4) prove hardness for a positive, deletion-free fragment with at most one prerequisite per move. Bylander (1994, Theorem 4.4) records the result with no prerequisites and at most three add effects. With a deadline, the unbounded closure still certifies exclusion of every capability outside it.

Relaxations can use these tractable cases. For instance, dropping delete effects from positive-precondition rules with a positive goal preserves every original plan. If the resulting closure excludes a required goal capability, the original problem is unsolvable. III.7 uses an organizational relaxation with a different dominance argument.

## III.6. Restoration independence

A system’s recovery may depend on capabilities disabled by the same disruption. In an electrical grid this can include the ability to start a generator without an external power supply. The model below records the order in which services can become available. Engineering models of transmission restoration also coordinate repairs, load pickups and generation dispatch (Coffrin and Van Hentenryck 2015).

**Definition III.3 (independent recoverability).** Each capability has one or more alternative prerequisite sets. It can be restored once every member of one alternative is up. Given the set $`S`$ of capabilities that survive a disruption, a capability set $`R`$ is **independently recoverable** if $`R\subseteq\mathrm{closure}(S)`$.

By Theorem III.2, this is decidable in linear time when restoration has no deadline and restorations do not compete for resources. Under a deadline, the closure still bounds what can be restored.

**Redundancy is not independence.** Multiple instances of a capability do not make it independently recoverable if every instance depends on the same disabled prerequisites.

**Demonstration III.A.** A stylized regional grid has six capabilities:

| Capability | Requires |
|---|---|
| two generators | control and fuel |
| control | power and telecom |
| telecom | power |
| fuel supply | power |
| power | either generator |

The scenarios, after a total blackout:

| Scenario | Seeds that survive | Restored |
|---|---|---|
| Total blackout | none | **0 of 6** |
| Add a third generator (more redundancy) | none | **0 of 7** |
| Standalone battery, not connected to anything | battery | 1 of 7 |
| Battery backs up telecom | battery | 2 of 7 |
| Black-start hydro unit that can supply power | hydro | **7 of 7** |

Adding redundancy restores nothing. Adding one capability in the right place restores everything. The difference is whether a surviving seed breaks the dependency cycle.

**Theorem III.3 (directed target sets under conjunctive prerequisites).** Suppose each capability has a single, possibly empty, prerequisite set. Draw an edge from each prerequisite to the capability that requires it. Activation then requires every incoming neighbor, exactly the unanimous-threshold case of Feige and Kogan (2021, Theorem 3.6 in the journal article and Theorem 3.10 in the 2019 preprint). In restoration terms their characterization reads as follows.

1. $`\mathrm{closure}(S)`$ contains every capability **if and only if** $`S`$ meets every directed cycle of the dependency graph.
2. Consequently, finding a minimum seed set that guarantees full recovery is the **minimum directed feedback vertex set** problem, which is NP-hard (Karp 1972).

*Proof.*

- **(⇐)** If $`S`$ meets every cycle, the graph restricted to capabilities outside $`S`$ is acyclic. Restore those capabilities in topological order: each one's prerequisites are either in $`S`$ or restored earlier.
- **(⇒)** If some cycle avoids $`S`$, no capability on it can be restored first, because each needs its predecessor on the cycle. So none is ever restored. $`\square`$

Allowing alternative prerequisite sets preserves NP-hardness because all single-set instances remain available. The cycle characterization itself uses the single-set assumption.

In the conjunctive version of Demonstration III.A, power depends on the first generator only. Both that generator and power are sufficient one-capability seed sets, as direct enumeration confirms. In the version with alternative generators, closure still checks a proposed seed set. The two versions illustrate why the choice of prerequisite rules matters.

**Application.** An infrastructure test would need observed prerequisite alternatives and evidence of which capabilities survive a disruption. ArcWake’s grid-outage engine is a proposed setting for that test. The six-capability calculation illustrates the definitions.

## III.7. Bounds and the gap

Classical planning distinguishes a solution trace from a proof that the goal is unreachable. Eriksson, Röger and Helmert (2017, Definitions 1–2) give independently checkable unsolvability certificates, including a set that contains the initial state, is closed under successors and excludes every goal. Here the same distinction is applied separately to the physical and adaptive control classes.

- **Witnesses** are admissible continuations found by search. Each one proves membership in the kernel.
- **Certificates** prove exclusion from the stated class. For exhaustive search, cover every admissible continuation or search a relaxation that contains one whenever the original problem has a solution. A smaller search space also suffices if a completeness proof establishes that implication. An unsuccessful search over a restricted menu leaves the full class unresolved.
- **The gap** is the set of states with neither. It is reported as a severity interval, following the evidence standard of I.3.7.

**Proposition III.4 (two pieces of evidence for lock-in).** Lock-in, $`\sigma=3`$, means $`s\in\mathcal K_{\mathrm{phys}}\setminus\mathcal K_{\mathrm{adapt}}`$. Any relaxation whose kernel contains $`\mathcal K_{\mathrm{phys}}`$ accepts every lock-in state. An exclusion for the adaptive class must therefore come from evidence that distinguishes organizationally admissible trajectories, such as exhaustive search over that class or an outer relaxation that retains a binding organizational constraint.

If a state has a physical witness, any relaxation containing the entire physical kernel must also accept that state. To certify lock-in one must additionally exclude the adaptive class, for example by retaining an organizational constraint in an outer relaxation.

**Demonstration III.B.** All 17,136 states of the I.3.10 model are classified using budget-limited random search for adapt-class witnesses, under two certificates:

- the **physical class** (exact);
- an **organizational relaxation** in which training does not take workers off production. The production allocation (foragers plus farmers at most $`N=3`$) is constrained as before. Up to $`N=3`$ worker-ticks of training can be added each tick on top of it. Every adapt-class step is dominated by a relaxed step.

The results are then scored against the exact kernels.

| Certificate | Rollouts per state | Witness | Excluded | Unknown | Unknown with $`\sigma=3`$ | Wrong claims |
|---|---|---|---|---|---|---|
| physical | 1 | 9,906 | 384 | 6,846 | 1,178 | 0 |
| physical | 10 | 13,788 | 384 | 2,964 | 1,178 | 0 |
| physical | 100 | 15,064 | 384 | 1,688 | 1,178 | 0 |
| physical | 1,000 | 15,373 | 384 | 1,379 | 1,178 | 0 |
| relaxation | 1 | 9,901 | 1,470 | 5,765 | 92 | 0 |
| relaxation | 10 | 13,752 | 1,470 | 1,914 | 92 | 0 |
| relaxation | 100 | 15,060 | 1,470 | 606 | 92 | 0 |
| relaxation | 1,000 | 15,374 | 1,470 | 292 | 92 | 0 |

**Three findings.**

- **The physical certificate leaves all 1,178 lock-in states unresolved.** At 1,000 rollouts there are 1,379 unresolved states in total, including 201 recoverable states. Finding a witness for every recoverable state would still leave all 1,178 without a physical exclusion. An exhaustive proof about adaptive trajectories would supply a different certificate.
- **Paired with the exact physical class, the organizational relaxation certifies 1,086 of the 1,178 lock-in states (92%).** The relaxation alone excludes 1,470 states from $`\mathcal K_{\mathrm{adapt}}`$, which establishes only $`\sigma_{\min}\ge3`$, that is, $`\sigma\in\{3,4\}`$. The exact physical kernel splits them:
  - 1,086 have a physical witness, so $`\sigma_{\max}\le3`$ and they are certified lock-in;
  - the other 384 are the $`\sigma=4`$ states.

  Under I.3.7, a lock-in claim needs both halves. All exclusions are correct.
- **Random rollouts miss some recoverable states.** At 1,000 rollouts per state, about 200 recoverable states still have no witness found. A better witness search could reduce this part of the gap.

No claim in any run was wrong. That is the point of the bracketing method: it is honest about what it does not know.

The Python and Lean implementations reproduce every row, including the 1,000-rollout cases.

## III.8. The adaptive escape strategy

The original outline described a control loop: observe, identify threatened constraints, estimate buffers and deadlines, identify alternative configurations, estimate their costs, select interventions, execute, and update. Given the hardness results, it is best understood as an **anytime bounding procedure**: one that can be stopped at any point and still returns its current bounds.

1. **Observe** the physical and organizational state. Under partial observability, this is an estimate, and the robust kernels of I.3.8 apply.
2. **Bound the escape question.** Generate witnesses by search, and certificates by relaxation. Report the severity interval and the gap.
3. **Locate deadlines.** Estimate points of no return ($`t^*_{\mathrm{adapt}}`$, $`t^*_{\mathrm{phys}}`$) and the required rate (Argument II).
4. **Diagnose the cause** of a threatened failure from the severity interval (I.3.7). A witness in the least permissive class that has one sets $`\sigma_{\max}`$. Exclusions from the less permissive classes set $`\sigma_{\min}`$. When the interval is a single value, it names the cause:
   - an ineffective policy ($`\sigma=1`$);
   - a missing capability ($`\sigma=2`$);
   - inaccessible alternatives ($`\sigma=3`$);
   - physical impossibility ($`\sigma=4`$).

   A wider interval is reported as it stands, not collapsed to one cause.
5. **Act on the best available witness.** Where none exists, spend effort where the gap is closest to a deadline.
6. **Preserve options.** Prefer interventions that keep margin $`\mu`$ high and enlarge the recoverable closure, not only immediate output (Argument I).
7. **Execute, observe and update** the model, the bounds and the deadlines.

The loop never presumes that an escape exists. Severities 3 and 4, and "unknown", are legitimate outputs.

**An exact benchmark for step 6.** Where kernels can be computed exactly, preserving options has an exact form: a viability shield, in the sense of shielded reinforcement learning (Alshiekh et al. 2018). The short-horizon optimizer chooses freely, and it is overridden only when its choice would leave $`\mathcal K_{\mathrm{adapt}}`$. In the settlement model of Argument I, the shield saves all 6,000 settings of Experiment E. Without frictions it never lowers the optimizer's objective. With a training cost it gives up a measurable amount in each of the 4,940 settings where the unshielded rule locks in (I.7, Experiment E). Where the kernel is only bounded, a shield must use the states with known witnesses, an inner approximation. The gap of III.7 then becomes the cost of caution.

## III.9. Policy and institutional implications

The outline's candidate interventions can now be stated precisely. They remain candidates whose costs must be evaluated.

| Candidate intervention | What the framework says |
|---|---|
| Maintain substitute capabilities | In the conjunctive restoration model, a sufficient seed set intersects every directed dependency cycle. With alternative prerequisites, check the seed set by closure (III.6) |
| Preserve critical operational knowledge | Knowledge loss raises reorganization latency and shrinks margin (I.4) |
| Reduce single-provider dependencies | A single provider on every recovery path is a single point of failure: if it is disabled, no alternative prerequisite set bypasses it |
| Retain recovery and reorganization capacity | This keeps $`t^*_{\mathrm{adapt}}`$ later, enlarging the reorganization window (I.3.6) |
| Improve physical deployment throughput | Valuable when deployment is the binding constraint, not otherwise (II.2) |
| Use simulation to evaluate organizational structures | Exact on small models, bounded on large ones, never presumed complete (III.7) |
| Separate enforced policy from authority to revise it | If revising a policy requires an implementation move, its latency counts against the margin. Fast revision authority is itself a capability (I.3.1) |
| Prefer interventions that increase future options | Measure options by margin, recoverable closure and gap, not by intuition |

## III.10. Strongest objections

**"Can the escape problem be solved computationally at realistic scales?"** Theorem III.1 and Corollary III.1 establish a worst-case lower bound for a binary horizon. For a particular system the practical questions are whether it fits a tractable class (III.5), and what witnesses and exclusions can be obtained at the available budget (III.7).

**"How can viability be estimated under partial observability?"** The robust construction of I.3.8 uses the states consistent with the observations. In finite-state models, tracking a set of possible states can require exponentially many such sets. Stochastic objectives have different bounds (III.4). Early-warning signals studied by Scheffer et al. (2009) suggest observations to compare against the model’s margin. That comparison would require data from the system.

**"How should uncertainty and correlated disturbances be represented?"** As disturbance sets in robust kernels. Correlation is represented by restricting which joint disturbance paths are admissible. Proposition 3′ gives the monotonicity that survives uncertainty.

**"Are adaptive options actually measurable?"** Three quantities are: margin $`\mu`$ (I.4), the recoverable closure (III.6), and the witness–certificate gap (III.7). Each is computable in the cases where the framework applies.

**"Can maximizing future flexibility become prohibitively expensive?"** Yes. Option value competes with immediate output, and the stopping-rule result of Argument II shows that building capability without a stopping rule consumes its own margin. Options are a means to viability, not an objective in themselves. Empowerment-style measures (Klyubin, Polani & Nehaniv 2005) quantify options, but maximizing them is not the goal.

**"When does preserving optionality conflict with immediate survival?"** When an option-preserving move violates viability during the transition. Adaptive continuity (III.3) settles the priority: the path must stay in $`\mathcal V`$. An option that can be kept only by failing now is not an option.

**"How can the model avoid assuming an escape exists?"** The decision problem can have a negative answer, including when the severity is 3 or 4. A budget-limited computation may also leave the answer unresolved. Demonstration III.B reports both outcomes.

## Conclusion

The Adaptive Escape Problem asks which organizational transitions can keep a system viable as its physical and institutional constraints change. The bounded planning reduction gives a worst-case lower bound. The control classes give a way to report the evidence available for an individual system.

Four results anchor the argument:

- **Escape contains planning.** Theorem III.1 machine-checks the equivalence under A0. Corollary III.1 transfers Bylander’s PSPACE lower bound for a binary horizon.
- **Structure can permit exact computation.** The examples use an explicit time-indexed graph, a dominant monotone rule or a positive add-only restoration model.
- **Restoration has two computational tasks.** Horn closure checks a seed set in the deadline-free, resource-free model. With one conjunctive prerequisite set per capability, choosing the smallest sufficient set is the directed feedback vertex set problem characterized by Feige and Kogan.
- **Lock-in requires a physical witness and an adaptive exclusion.** Demonstration III.B measures how many states remain unresolved under two different certificates at the same rollout budget.

## The three arguments together

| Argument | Question | Core result |
|---|---|---|
| **I. The Paradox** | Why can adaptive organization reduce future adaptability? | Equal resources can conceal different recovery options. A two-tick food-stock rule can enter lock-in when ties favor continued foraging. |
| **II. The Necessity** | When does the rate of adaptation become a survival constraint? | Necessity is a kernel condition. Delay cannot restore viability under an unchanged ceiling. The valuable acceleration is the one on the binding constraint. Acceleration is an instrument, viability the objective |
| **III. The Escape** | How can a system find a viable transition before the window closes? | Escape is PSPACE-hard in general but tractable under structure. Recoverability is easy to verify and hard to design. Lock-in requires organizational certificates. Report the gap |

Together they form a research program: **diagnosis → time constraint → reachability and intervention.** The central objective is to understand not only how adaptive systems become powerful, but how they can keep the capacity to remain viable as their own success changes the conditions they live in.

## References

- Abdulaziz, M., and F. Kurz (2023). Formally verified SAT-based AI planning. *Proceedings of the AAAI Conference on Artificial Intelligence* 37(12), 14665–14673. [DOI](https://doi.org/10.1609/aaai.v37i12.26714)
- Alshiekh, M., R. Bloem, R. Ehlers, B. Könighofer, S. Niekum, and U. Topcu (2018). Safe reinforcement learning via shielding. *Proceedings of the AAAI Conference on Artificial Intelligence* 32(1). [DOI](https://doi.org/10.1609/aaai.v32i1.11797)
- Brafman, R. I., and C. Domshlak (2003). Structure and complexity in planning with unary operators. *Journal of Artificial Intelligence Research* 18, 315–349. [DOI](https://doi.org/10.1613/jair.1146)
- Bylander, T. (1994). The computational complexity of propositional STRIPS planning. *Artificial Intelligence* 69(1–2), 165–204. [DOI](https://doi.org/10.1016/0004-3702(94)90081-7)
- Coffrin, C., and P. Van Hentenryck (2015). Transmission system restoration with co-optimization of repairs, load pickups, and generation dispatch. *International Journal of Electrical Power & Energy Systems* 72, 144–154. [DOI](https://doi.org/10.1016/j.ijepes.2015.02.027)
- Dowling, W. F., and J. H. Gallier (1984). Linear-time algorithms for testing the satisfiability of propositional Horn formulae. *Journal of Logic Programming* 1(3), 267–284. [DOI](https://doi.org/10.1016/0743-1066(84)90014-1)
- Eriksson, S., G. Röger and M. Helmert (2017). Unsolvability certificates for classical planning. *Proceedings of the International Conference on Automated Planning and Scheduling* 27, 88–97. [DOI](https://doi.org/10.1609/icaps.v27i1.13818)
- Erol, K., D. S. Nau and V. S. Subrahmanian (1992). On the complexity of domain-independent planning. *Proceedings of the Tenth National Conference on Artificial Intelligence*, 381–386. [AAAI paper](https://cdn.aaai.org/AAAI/1992/AAAI92-059.pdf)
- Feige, U., and S. Kogan (2021). Target set selection for conservative populations. *Discrete Applied Mathematics* 305, 119–132. [DOI](https://doi.org/10.1016/j.dam.2021.09.003) · [Preprint, Theorem 3.10](https://arxiv.org/pdf/1909.03422#page=22)
- Giménez, O., and A. Jonsson (2008). The complexity of planning problems with simple causal graphs. *Journal of Artificial Intelligence Research* 31, 319–351. [DOI](https://doi.org/10.1613/jair.2432)
- Henzinger, T. A., P. W. Kopke, A. Puri and P. Varaiya (1998). What’s decidable about hybrid automata? *Journal of Computer and System Sciences* 57(1), 94–124. [DOI](https://doi.org/10.1006/jcss.1998.1581)
- Karp, R. M. (1972). Reducibility among combinatorial problems. In R. E. Miller and J. W. Thatcher (eds.), *Complexity of Computer Computations*, 85–103. Plenum Press. [DOI](https://doi.org/10.1007/978-1-4684-2001-2_9)
- Klyubin, A. S., D. Polani and C. L. Nehaniv (2005). Empowerment: a universal agent-centric measure of control. *2005 IEEE Congress on Evolutionary Computation*, vol. 1, 128–135. [DOI](https://doi.org/10.1109/CEC.2005.1554676)
- Madani, O., S. Hanks and A. Condon (1999). On the undecidability of probabilistic planning and infinite-horizon partially observable Markov decision problems. *Proceedings of the Sixteenth National Conference on Artificial Intelligence*, 541–548. [AAAI paper](https://cdn.aaai.org/AAAI/1999/AAAI99-077.pdf)
- Papadimitriou, C. H., and J. N. Tsitsiklis (1987). The complexity of Markov decision processes. *Mathematics of Operations Research* 12(3), 441–450. [DOI](https://doi.org/10.1287/moor.12.3.441)
- Scheffer, M., J. Bascompte, W. A. Brock, V. Brovkin, S. R. Carpenter, V. Dakos, H. Held, E. H. van Nes, M. Rietkerk and G. Sugihara (2009). Early-warning signals for critical transitions. *Nature* 461, 53–59. [DOI](https://doi.org/10.1038/nature08227)

## Code and reproducibility

- **`Paradox/Escape.lean`:** STRIPS instances, the escape problem, `escape_wait`, `planning_iff_escape`, and `planning_iff_escape_A0` (Theorem III.1).
- **`ArgIIIMain.lean`:** Demonstrations III.A and III.B.
- **`python/toy/argIII.py`:** the Python reference. Its outputs match Lean's at every overlapping setting.

All Lean results were built and reproduced on the author's machine (`argIII_output.txt`).
