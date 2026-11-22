# Argument V — Concessions and Erosion

**Subtitle:** *Horizon-Dependent Trade-offs and the Decay of Empirical Safety Margins*

*Working draft, November 2026. Builds on Arguments I–III. Notation follows I.3: both models run on explicit states $`(x_t,O_t,\pi_t,q_t)`$ with the four control classes of I.3.3.*

## Central claim

Arguments I–III fix the horizon and fix the rule that guards the margin. Two failure modes appear when either one is allowed to vary. An organization can give up permanent adaptability to survive an immediate deadline, and an organization that sets its safety margin from recent experience can let that margin decay during calm periods.

Argument V makes four claims:

1. **A longer horizon can only shrink a kernel** (Theorem V.1, machine-checked). Whatever is viable to a later horizon is viable to an earlier one.
2. **Structural concessions reverse with the horizon** (Theorem V.2, machine-checked). A concession that survives now but carries a permanent scar is in the kernel for every horizon up to the tick its scar becomes fatal and out of it for every longer horizon, while an affordable clean fix stays in. In the four-class model the same post-concession state moves from severity 0 or 1 at short horizons to severity 3 (structural lock-in while physical recovery exists) or severity 2 (a later clean fix still rescues it) at long ones.
3. **Calm erodes empirical margins** (Theorem V.3, machine-checked). A controller that resets its reserve floor after a shock and relaxes it during calm periods survives a shock that follows a short calm and fails the identical shock after a long one. In the exact sweep the failure threshold is $`L^*=3k`$ calm ticks, exactly the theorem's bound. In the four classes this failure is a policy-level mismatch (severity 1) until a point of no return and severity 4 after it; it is never structural.
4. **Structural and empirical shields trade output for robustness.** In the sweep the adaptive shield out-produces a static one inside its survival window and fails beyond it. Margins that must survive rare shocks have to be set from the shocks, not from recent experience.

## V.1. Beyond fixed horizons and fixed shields

**Concessions are the inverse of the paradox.** In Argument I an organization degrades its future adaptability to chase output: specialization raises stored food and lengthens the retraining needed to recover. A structural concession runs the other way. The organization degrades its future adaptability to survive: it accepts a permanent capability loss (an output cap, a slower policy switch) in exchange for clearing an immediate deadline cheaply. Whether that is wise depends on the horizon, and the framework's kernels are indexed by it.

**Empirical shields decay between crises.** Argument III's viability shield (III.8) is structural when the kernel is computed exactly. Organizations rarely have exact kernels; they set safety margins from experience, raising them after a shock and relaxing them as calm continues. That rule is a controller with memory, and its memory runs out.

The Margin Gambit debrief recorded both patterns: a permanent concession accepted to remove an external deadline (W5), and a margin floor that rose after the first shock and would be expected to erode during calm (W6).

## V.2. The two models in the four control classes

Both models are control systems on explicit I.3 states. Each class is a list of admissible actions, each class's kernel is $`\mathcal K`$ of its system (Definition 2), and **A0** holds: viability depends only on reserves. Every organizational step is a physical step (**A3**, exactly), so Proposition 1 gives $`\mathcal K_{\mathrm{fixed}}\subseteq\mathcal K_{\mathrm{policy}}\subseteq\mathcal K_{\mathrm{adapt}}\subseteq\mathcal K_{\mathrm{phys}}`$ for both (`classA_nesting`, `classB_nesting`). The exact computations check the inclusions: 7,560 checks in Sweep A and 600 in Sweep B, with no violation.

**Sweep A (structural concessions).** $`x`$ = reserves; $`O`$ = whether the organization is scarred; $`\pi`$ = whether the operating policy is aligned with the environment; $`q`$ = the acute obligation and any implementation move in flight. Step 0 is a decision step. The obligation must be cleared by a capability-changing move ($`\mathcal M_{\mathrm{cap}}`$): the clean fix (cost 5) or the concession (cost 1, scar). Left uncleared, reserves are seized. On each operating tick, upkeep is 2. An aligned tick without a forced switch produces 4, or 3 when scarred. A forced switch, at operating ticks $`P,2P,\dots`$, misaligns the policy and cancels any realignment in flight. Realignment is an immediate policy revision, except that a scarred organization needs a latency-1 implementation move ($`\mathcal M_{\mathrm{impl}}`$, Definition 1). Reserves are capped at 8.

| Class | Admissible actions |
|---|---|
| $`\mathcal U_{\mathrm{fixed}}`$ | the incumbent policy, never revised; no moves |
| $`\mathcal U_{\mathrm{policy}}`$ | realignment (with the implementation move when scarred); no capability-changing move |
| $`\mathcal U_{\mathrm{adapt}}`$ | adds the clean fix and the concession, at the decision step or later (a later clean fix costs 5 and removes the scar from the next tick) |
| $`\mathcal U_{\mathrm{phys}}`$ | also clears the obligation at no cost, produces 4 and realigns without the implementation move |

**Sweep B (calm-period erosion).** $`x`$ = reserves; $`\pi`$ = the reserve floor; $`q`$ = the calm counter. Rounds of $`L`$ calm ticks are each followed by a shock that needs and removes 4. A calm tick earns 1, and the organization keeps some of its reserves and spends the rest. $`\mathcal U_{\mathrm{fixed}}`$ is the adaptive empirical shield: its floor resets to 6 after a shock and drops by 1 after every $`k`$ calm ticks, through the update `calmStep` of Theorem V.3, and it keeps $`\min(r,\text{floor})`$. $`\mathcal U_{\mathrm{policy}}`$ revises the floor freely, so it may keep any amount. The model has no capability-changing move, so $`\mathcal U_{\mathrm{adapt}}`$ and $`\mathcal U_{\mathrm{phys}}`$ add nothing and their kernels equal the policy kernel.

Lean (`argV`) and Python agree line for line on every result below (`results/argV_output.txt`).

## V.3. Horizon-dependent structural concessions

**Theorem V.1 (horizon antitone).** For any system and any $`t\le T_1\le T_2`$,
```math
\mathcal K(T_2,t)\subseteq\mathcal K(T_1,t).
```

*Proof.* Machine-checked: `horizon_antitone` in `Paradox/Concession.lean`, via `viab_shorten` (viability for $`n+m`$ steps implies viability for $`n`$); `classA_horizon_antitone` applies it to every class kernel of Sweep A. $`\square`$

The theorem is elementary but it orders every comparison below. A choice that is viable to a long horizon is viable to every shorter one; the reverse can fail. Argument I's monotone-loss result (Proposition 3) needs a fixed terminal time for the same reason: with a receding horizon, the kernels being compared change.

**Theorem V.2 (concession crossover).** Model the two post-choice systems on reserves:

- the **clean fix** costs $`c_{\mathrm{fix}}`$ and leaves reserves that recurring shocks do not erode;
- the **concession** costs $`c_{\mathrm{conc}}\le r_0`$, but its scar makes the forced switch at tick $`T^*`$ cost $`D\gt r_0-c_{\mathrm{conc}}`$.

Then for every horizon $`T\le T^*`$ the concession is in the kernel, and the clean fix is out of it whenever $`r_0\lt c_{\mathrm{fix}}`$. For every horizon $`T\gt T^*`$ the concession is out of the kernel, and the clean fix is in it whenever $`c_{\mathrm{fix}}\le r_0`$.

*Proof.* Machine-checked: `concession_crossover`, from `conc_viab`, `conc_fail`, `clean_viab` and `clean_fail`. In the four-class model, `ref_shift` proves the crossover for $`r_0=1`$, $`P=4`$ from the modeled transitions. The post-concession state is in $`\mathcal K_{\mathrm{policy}}`$ but not in $`\mathcal K_{\mathrm{fixed}}`$ at horizon 9 (severity 1). At horizon 10 it is in $`\mathcal K_{\mathrm{phys}}`$ but not in $`\mathcal K_{\mathrm{adapt}}`$ (severity 3). $`\square`$

**The crossover horizon** $`T^*(r_0,P)`$ is the largest horizon at which the post-concession state is in the policy kernel ("all": through 24):

| $`r_0`$ | $`P=3`$ | 4 | 5 | 6 | 7 | 8 |
|---|---|---|---|---|---|---|
| 1 | 4 | 9 | 16 | all | all | all |
| 2 | 6 | 9 | 21 | all | all | all |
| 3–4 | 7 | 13 | all | all | all | all |
| 5 | 9 | 17 | all | all | all | all |
| 6–10 | 10 | 17 | all | all | all | all |

Per switch period, the concession nets $`(P-2)\cdot1-2\cdot2=P-6`$ and the clean fix $`(P-1)\cdot2-2=2P-4`$. With frequent switches ($`P\le5`$) the concession bleeds reserves and has a finite $`T^*`$; with $`P\ge6`$ it is sustainable. The crossover horizon scales with switch frequency times the scar's cost per switch, as the debrief conjectured.

**Regimes across the 1,260 cells** ($`r_0=1,\dots,10`$, $`P=3,\dots,8`$, $`T=4,\dots,24`$), for the policy kernel of each post-choice state:

| Regime | Cells |
|---|---|
| Concession only (clean fix unaffordable, $`T\le T^*`$) | 369 |
| Both viable (the concession keeps more reserves, the clean fix produces more) | 629 |
| Clean fix only (concession past $`T^*`$) | 127 |
| Neither | 135 |

**Severities.** At the decision state the obligation is still pending. Neither $`\mathcal U_{\mathrm{fixed}}`$ nor $`\mathcal U_{\mathrm{policy}}`$ can clear it, so no cell has severity 0 or 1. The decision state has severity 2 in 1,136 cells and severity 3 in 124; no cell has severity 4. The adaptive class rescues 11 of the 135 "neither" cells by combining the concession now with a clean fix later. In the other 124 only the physical class survives. The post-concession state has severity 0 in 368 cells, 1 in 630, 2 in 138 and 3 in 124.

**The horizon moves one state across severity classes.** Post-concession severity by horizon $`T=4,\dots,24`$, one digit per horizon:

| $`r_0`$, $`P`$ | Severity by horizon | Reading |
|---|---|---|
| 1, 3 | `033333333333333333333` | the incumbent survives the shortest horizon; afterwards only physical recovery exists |
| 1, 4 | `000111333333333333333` | severity 0 to $`T=6`$, 1 to $`T^*=9`$, 3 from $`T=10`$ (`ref_shift`) |
| 4, 4 | `000011111122222222222` | past $`T^*=13`$ a later clean fix still rescues it (severity 2) |
| 5, 3 | `000111222222222222222` | the same, with $`T^*=9`$ |
| 1, 6 | `000000111111111111111` | sustainable with realignment: severity 1 from $`T=10`$ on |

Severity 0 at short horizons means even the never-revising incumbent survives: the horizon ends before its unrealigned policy drains the reserves. Beyond that, the concession needs the policy class to realign after every switch (severity 1). Past $`T^*`$ realignment is not enough. A later clean fix rescues it when the reserves can reach the fix's cost in time (severity 2); otherwise only the physical class survives (severity 3). The jump to severity 3 at $`T^*+1`$ is the concession's horizon reversal stated in Argument I's taxonomy: structural lock-in, with physical recovery still possible.

**The scar is a hidden vulnerability even when both choices survive.** In the 24 cells $`(r_0,P)`$ where both choices survive the scheduled switches to tick 24, consider one additional, unscheduled forced switch. In 18 of them there are ticks at which that switch kills the concession but not the clean fix. With $`P=6`$ the window is ticks 9 and 15; with $`P=7`$ it is ticks 10–11 and 17–18; with $`P=5`$ it covers 9 or 10 of the 24 ticks; with $`P=8`$ there is none. Survival to the horizon does not show this cost; only the scar window does.

## V.4. Calm-period margin erosion

**Theorem V.3 (the calm paradox).** An adaptive controller keeps a reserve floor $`m`$. After a shock it resets to $`m=m_{\max}`$; after every $`k\ge1`$ consecutive calm ticks it lowers $`m`$ by one (not below 0). A shock needing a floor of $`m_{\mathrm{req}}`$, with $`1\le m_{\mathrm{req}}\le m_{\max}`$, is survived iff $`m\ge m_{\mathrm{req}}`$. Then:

- a shock arriving after $`L\lt k`$ calm ticks is survived;
- the same shock arriving after $`L\ge k\,(m_{\max}-m_{\mathrm{req}}+1)`$ calm ticks is fatal.

*Proof.* Machine-checked: `calm_erosion_fatal`, using `calm_floor`, which shows that after $`L=qk+c`$ calm ticks ($`c\lt k`$) the floor is $`m_{\max}-q`$. In the four-class model the shield's floor update *is* `calmStep`, and `shield_fatal` concludes that after a shock, at the start of any round, the shield's state is outside $`\mathcal K_{\mathrm{fixed}}`$ for that round whenever $`L\ge k\,(m_{\max}-m_{\mathrm{req}}+1)`$, whatever its reserves. `ref_calm` proves severity 1 at the start for $`k=2`$, $`L=6`$: the shield fails, while keeping every reserve survives all four shocks. $`\square`$

Longer calm between identical shocks turns a survivable shock into a fatal one. Nothing about the shock changes; only the controller's memory of it does.

**Sweep B (exact).** Four shocks; reserves start at 6. Myopic (floor 0) and static (floor 6) are two rules of the policy class; the adaptive shield is the fixed class. Survival by calm interval $`L=1,\dots,25`$ (S: survives all four shocks; x: fails):

| Rule | $`L=1\dots25`$ |
|---|---|
| myopic | `xxxxxxxxxxxxxxxxxxxxxxxxx` |
| static | `xxxSSSSSSSSSSSSSSSSSSSSSS` |
| adaptive, $`k=2`$ | `xxxSSxxxxxxxxxxxxxxxxxxxx` |
| adaptive, $`k=4`$ | `xxxSSSSSSSSxxxxxxxxxxxxxx` |
| adaptive, $`k=6`$ | `xxxSSSSSSSSSSSSSSxxxxxxxx` |
| adaptive, $`k=8`$ | `xxxSSSSSSSSSSSSSSSSSSSSxx` |

- **Too little calm fails everyone.** With $`L\le2`$ no rule survives: income of 1 per calm tick cannot replace the 4 each shock removes. At $`L=3`$ the static floor of 6 fails, but keeping every reserve survives.
- **Too much calm fails the adaptive shield.** For every $`k`$ from 2 to 8 it survives exactly $`L=4,\dots,3k-1`$ and fails from $`L^*=3k`$ on (6, 9, 12, …, 24), which equals the bound $`k\,(m_{\max}-m_{\mathrm{req}}+1)`$ of Theorem V.3. With $`k=1`$ its floor erodes before income can refill it, and it never survives.
- **The survival curve is non-monotone in calm.** Short calm starves the reserves; long calm erodes the floor. Only an intermediate band survives, and its width grows linearly with the controller's memory $`k`$.

**Severities.** The start state has severity 4 for $`L\le2`$, severity 0 inside the shield's survival band, and severity 1 everywhere else. For $`k=4`$, for example, by $`L=1,\dots,25`$: `4410000000011111111111111`. Severities 2 and 3 never occur. The policy class already contains every physically possible spending rule, so $`\mathcal K_{\mathrm{policy}}=\mathcal K_{\mathrm{adapt}}=\mathcal K_{\mathrm{phys}}`$ in this model. The framework therefore classifies calm-period erosion as an **operational mismatch**: a different floor would save the organization, and no reorganization is needed.

**Severity migration and margin during the calm.** Along the shield's own path with $`k=4`$, $`L=12`$, severity is 1 at every calm tick of the first round and 4 from the first shock on. The point of no return is $`t^*_{\mathrm{adapt}}=11`$, the last calm tick. The margin $`\mu(s_t,t)=t^*_{\mathrm{adapt}}-t`$ falls from 11 to 0 across the calm and is $`-1`$ from the shock on. With $`k=2`$, $`L=6`$ the same pattern runs from $`\mu=5`$ to 0. The shield is never at severity 0 here, because with a known shock schedule its failure is already determined at the start. What the calm erodes is the margin: the time left in which a policy revision (keeping more) still works. The shield monitors reserves and floor, and neither signals that margin.

**Output.** Inside its survival window the adaptive shield out-produces the static one, because it spends reserves the static shield holds idle. With $`k=4`$, cumulative output is 13 against 12 at $`L=6`$, 22 against 20 at $`L=8`$ and 30 against 28 at $`L=10`$. At $`L=12`$ the adaptive shield fails after producing 15, while the static shield survives with 36. Output is counted until failure, so a failing controller's output is truncated.

## V.5. Relation to existing research

Minsky's financial instability hypothesis holds that stability itself encourages the build-up of fragility (Minsky 1977). Theorem V.3 is a minimal, exact instance of that idea for a single organization's safety margin: the controller relaxes because nothing has happened, and the relaxation is what makes the next shock fatal. The model does not address the financial mechanisms Minsky described.

The horizon results connect to receding-horizon control. Argument I notes (I.3.6) that monotone loss needs a fixed terminal time and can fail with a receding horizon; Theorem V.1 states the underlying order, and Theorem V.2 shows that the choice an organization makes can flip as its planning horizon lengthens.

The shield results connect to Argument III. A viability shield computed from the exact kernel (III.8) is structural: it does not depend on recent experience. Sweep B shows what happens when the shield is instead tuned to experience. It earns more while the environment cooperates and fails when calm lasts longer than its memory.

## V.6. Strongest objections

**"Isn't a concession that is fatal later still rational if you would die today?"** Yes, and Theorem V.2 says so: in the 369 concession-only cells the clean fix is unaffordable and the concession is the only way through. The argument is not that concessions are mistakes. It is that their value depends on the horizon, so a short planning horizon will choose them also where the clean fix is affordable and the horizon is long, and that the scar window carries a cost survival statistics do not show.

**"Couldn't the adaptive controller just keep a non-zero floor?"** It could, and the four classes say exactly that: calm erosion is severity 1, curable by a policy revision. A floor that never falls below $`m_{\mathrm{req}}`$ never fails a shock of size $`m_{\mathrm{req}}`$, but it is then a static shield at $`m_{\mathrm{req}}`$, with the corresponding output cost. Choosing that lower bound requires knowing the worst credible shock, which is the structural information an empirical rule does without.

**"Why wouldn't an organization remember a severe crisis?"** Memory is the parameter $`k`$. Longer memory pushes the failure threshold out linearly ($`L^*=3k`$ in the sweep) but does not remove it: for any finite $`k`$ there is a calm interval after which the same shock is fatal. Institutional memory that does not decay is part of a structural shield.

**"Why is the never-revising incumbent ever viable?"** Only at horizons that end before its misaligned policy drains the reserves. That is what severity 0 means: no revision is needed within the horizon. It is not a claim that the incumbent can be left alone indefinitely.

**"The models are tiny."** Yes. Theorems V.1–V.3 are general within their stated assumptions; the sweeps are exact for stylized parameters and establish existence and threshold behavior, not prevalence.

## Conclusion

Argument V adds time variation to the framework's two fixed elements, the horizon and the margin rule, and both models run in the four control classes of I.3.

- **Horizons order kernels** (Theorem V.1), and **structural concessions reverse with the horizon** (Theorem V.2). The same post-concession state moves from severity 0 or 1 to severity 3 (or 2, where a later clean fix can still be afforded) as the horizon passes $`T^*`$.
- **Calm erodes empirical margins** (Theorem V.3), with an exact failure threshold $`L^*=3k`$ in the sweep. The framework classifies the erosion as an operational mismatch (severity 1) whose margin decays to zero during the calm, after which the state is severity 4.
- **Structural shields cost output but do not decay; empirical shields earn more and fail after long calm.**

## The arguments together

| Argument | Question | Core result |
|---|---|---|
| **I. The Paradox** | Why can adaptive organization reduce future adaptability? | Equal resources can conceal different recovery options; a short-horizon rule can select lock-in |
| **II. The Necessity** | When does the rate of adaptation become a survival constraint? | Necessity is a kernel condition; delay cannot restore viability under an unchanged ceiling |
| **III. The Escape** | How can a system find a viable transition before the window closes? | Escape is PSPACE-hard in general but tractable under structure; lock-in requires organizational certificates |
| **V. Concessions and Erosion** | What changes when the horizon or the margin rule varies? | Concessions reverse with the horizon, from severity 1 to severity 3; calm erodes empirical margins until an identical shock becomes fatal |

Argument IV is not part of this public release. The numbering is kept so that cross-references stay stable.

## References

- Minsky, H. P. (1977). The financial instability hypothesis: an interpretation of Keynes and an alternative to "standard" theory. *Challenge* 20(1), 20–27. [DOI](https://doi.org/10.1080/05775132.1977.11470296)

## Code and reproducibility

- **`Paradox/Concession.lean`:** `viab_shorten`, `horizon_antitone` (Theorem V.1), `concession_crossover` (Theorem V.2), `calm_floor` and `calm_erosion_fatal` (Theorem V.3). No `sorry`, no `native_decide`.
- **`Paradox/ConcessionModel.lean`:** the two four-class systems, `classA_nesting` and `classB_nesting` (Proposition 1), `classA_horizon_antitone`, `ref_shift`, `shield_round`, `shield_fatal` and `ref_calm`, and the exact computations. No `sorry`, no `native_decide`; axioms `propext` and `Quot.sound` at most.
- **`ArgVMain.lean`:** the executable `argV` writes `results/argV_output.txt`.
- **`python/toy/argV.py`:** the independent Python reference. `python python/crosscheck_all.py argV` compares it with the saved output line for line.
