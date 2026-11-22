# Argument V — Concessions and Erosion

**Subtitle:** *Horizon-Dependent Trade-offs and the Decay of Empirical Safety Margins*

*Working draft, November 2026. Builds on Arguments I–III. Notation follows I.3.*

## Central claim

Arguments I–III fix the horizon and fix the rule that guards the margin. Two failure modes appear when either one is allowed to vary. An organization can give up permanent adaptability to survive an immediate deadline, and an organization that sets its safety margin from recent experience can let that margin decay during calm periods.

Argument V makes four claims:

1. **A longer horizon can only shrink a kernel** (Theorem V.1, machine-checked). Whatever is viable to a later horizon is viable to an earlier one.
2. **Structural concessions reverse with the horizon** (Theorem V.2, machine-checked). A concession that survives now but carries a permanent scar is in the kernel for every horizon up to the tick its scar becomes fatal and out of it for every longer horizon, while an affordable clean fix stays in. In an exact sweep the crossover horizon $`T^*`$ ranges from 4 ticks to beyond the tested range, depending on how often forced policy switches occur.
3. **Calm erodes empirical margins** (Theorem V.3, machine-checked). A controller that resets its reserve floor after a shock and relaxes it during calm periods survives a shock that follows a short calm and fails the identical shock after a long one. In the exact sweep the failure threshold is $`L^*=3k`$ calm ticks, exactly the theorem's bound.
4. **Structural and empirical shields trade output for robustness.** In the sweep the adaptive shield out-produces a static one inside its survival window and fails beyond it. Margins that must survive rare shocks have to be set from the shocks, not from recent experience.

## V.1. Beyond fixed horizons and fixed shields

**Concessions are the inverse of the paradox.** In Argument I an organization degrades its future adaptability to chase output: specialization raises stored food and lengthens the retraining needed to recover. A structural concession runs the other way. The organization degrades its future adaptability to survive: it accepts a permanent capability loss (an output cap, a slower policy switch) in exchange for clearing an immediate deadline cheaply. Whether that is wise depends on the horizon, and the framework's kernels are indexed by it.

**Empirical shields decay between crises.** Argument III's viability shield (III.8) is structural when the kernel is computed exactly. Organizations rarely have exact kernels; they set safety margins from experience, raising them after a shock and relaxing them as calm continues. That rule is a controller with memory, and its memory runs out.

The Margin Gambit debrief recorded both patterns: a permanent concession accepted to remove an external deadline (W5), and a margin floor that rose after the first shock and would be expected to erode during calm (W6).

## V.2. Horizon-dependent structural concessions

**Theorem V.1 (horizon antitone).** For any system and any $`t\le T_1\le T_2`$,
```math
\mathcal K(T_2,t)\subseteq\mathcal K(T_1,t).
```

*Proof.* Machine-checked: `horizon_antitone` in `Paradox/Concession.lean`, via `viab_shorten` (viability for $`n+m`$ steps implies viability for $`n`$). $`\square`$

The theorem is elementary but it orders every comparison below. A choice that is viable to a long horizon is viable to every shorter one; the reverse can fail. Argument I's monotone-loss result (Proposition 3) needs a fixed terminal time for the same reason: with a receding horizon, the kernels being compared change.

**Theorem V.2 (concession crossover).** Model the two post-choice systems on reserves:

- the **clean fix** costs $`c_{\mathrm{fix}}`$ and leaves reserves that recurring shocks do not erode;
- the **concession** costs $`c_{\mathrm{conc}}\le r_0`$, but its scar makes the forced switch at tick $`T^*`$ cost $`D\gt r_0-c_{\mathrm{conc}}`$.

Then for every horizon $`T\le T^*`$ the concession is in the kernel, and the clean fix is out of it whenever $`r_0\lt c_{\mathrm{fix}}`$. For every horizon $`T\gt T^*`$ the concession is out of the kernel, and the clean fix is in it whenever $`c_{\mathrm{fix}}\le r_0`$.

*Proof.* Machine-checked: `concession_crossover`, from `conc_viab`, `conc_fail`, `clean_viab` and `clean_fail`. $`\square`$

**Sweep A (exact).** A generalized version of the debrief's tick-9 decision:

| Choice | Upfront cost | Output per productive tick | Dead ticks per forced policy switch |
|---|---|---|---|
| Clean fix | 5 | 4 | 1 |
| Structural concession | 1 | 3 (capped) | 2 (the scar) |

Upkeep is 2 per tick, a dead tick produces nothing, and reserves are capped at 8 after the cost is paid. Forced switches occur at ticks $`P, 2P, \dots`$. The sweep covers starting reserves $`r_0=1,\dots,10`$, switch periods $`P=3,\dots,8`$ and horizons $`T=4,\dots,24`$ (1,260 cells). After the choice the dynamics are deterministic, so each kernel is decided exactly by one simulation; Lean (`argV`) and Python agree line for line.

**Crossover horizon $`T^*(r_0,P)`$**, the largest horizon at which the concession is viable ("all": viable through 24):

| $`r_0`$ | $`P=3`$ | 4 | 5 | 6 | 7 | 8 |
|---|---|---|---|---|---|---|
| 1 | 4 | 9 | 16 | all | all | all |
| 2 | 6 | 9 | 21 | all | all | all |
| 3–4 | 7 | 13 | all | all | all | all |
| 5 | 9 | 17 | all | all | all | all |
| 6–10 | 10 | 17 | all | all | all | all |

Per switch period, the concession nets $`(P-2)\cdot1-2\cdot2=P-6`$ and the clean fix $`(P-1)\cdot2-2=2P-4`$. With frequent switches ($`P\le5`$) the concession bleeds reserves and has a finite $`T^*`$; with $`P\ge6`$ it is sustainable. The crossover horizon scales with switch frequency times the scar's cost per switch, as the debrief conjectured.

**Regimes across the 1,260 cells:**

| Regime | Cells |
|---|---|
| Concession only (clean fix unaffordable, $`T\le T^*`$) | 369 |
| Both viable (the concession keeps more reserves, the clean fix produces more) | 629 |
| Clean fix only (concession past $`T^*`$) | 127 |
| Neither | 135 |

**The scar is a hidden vulnerability even when both choices survive.** In the 24 cells $`(r_0,P)`$ where both choices survive the scheduled switches to tick 24, consider one additional, unscheduled forced switch. In 18 of them there are ticks at which that switch kills the concession but not the clean fix. With $`P=6`$ (any $`r_0\ge5`$) the window is ticks 8–10 and 14–16: the three ticks after each scheduled switch, while the concession rebuilds. With $`P=7`$ it is ticks 9–12 and 16–19, and with $`P=5`$ 18 or 19 of the 24 ticks. With $`P=8`$ there is none. Survival to the horizon does not show this cost; only the scar window does.

## V.3. Calm-period margin erosion

**Theorem V.3 (the calm paradox).** An adaptive controller keeps a reserve floor $`m`$. After a shock it resets to $`m=m_{\max}`$; after every $`k\ge1`$ consecutive calm ticks it lowers $`m`$ by one (not below 0). A shock needing a floor of $`m_{\mathrm{req}}`$, with $`1\le m_{\mathrm{req}}\le m_{\max}`$, is survived iff $`m\ge m_{\mathrm{req}}`$. Then:

- a shock arriving after $`L\lt k`$ calm ticks is survived;
- the same shock arriving after $`L\ge k\,(m_{\max}-m_{\mathrm{req}}+1)`$ calm ticks is fatal.

*Proof.* Machine-checked: `calm_erosion_fatal`, using `calm_floor`, which shows that after $`L=qk+c`$ calm ticks ($`c\lt k`$) the floor is $`m_{\max}-q`$. $`\square`$

Longer calm between identical shocks turns a survivable shock into a fatal one. Nothing about the shock changes; only the controller's memory of it does.

**Sweep B (exact).** Shocks needing and removing 4 reserves recur after every $`L`$ calm ticks, four shocks in all. A calm tick earns 1; reserves above the controller's floor are spent as output. Reserves start at 6. Three controllers:

- **myopic**: floor 0;
- **static structural shield**: floor fixed at $`m_{\max}=6`$;
- **adaptive empirical shield**: floor resets to 6 after a shock and drops by 1 after every $`k`$ calm ticks.

Survival by calm interval $`L=1,\dots,25`$ (S: survives all four shocks; x: fails):

| Controller | $`L=1\dots25`$ |
|---|---|
| myopic | `xxxxxxxxxxxxxxxxxxxxxxxxx` |
| static | `xxxSSSSSSSSSSSSSSSSSSSSSS` |
| adaptive, $`k=2`$ | `xxxSSxxxxxxxxxxxxxxxxxxxx` |
| adaptive, $`k=4`$ | `xxxSSSSSSSSxxxxxxxxxxxxxx` |
| adaptive, $`k=6`$ | `xxxSSSSSSSSSSSSSSxxxxxxxx` |
| adaptive, $`k=8`$ | `xxxSSSSSSSSSSSSSSSSSSSSxx` |

- **Too little calm fails everyone.** With $`L\le3`$ even the static shield fails: income of 1 per calm tick cannot replace the 4 each shock removes.
- **Too much calm fails the adaptive shield.** For every $`k`$ from 2 to 8 it survives exactly $`L=4,\dots,3k-1`$ and fails from $`L^*=3k`$ on (6, 9, 12, …, 24), which equals the bound $`k\,(m_{\max}-m_{\mathrm{req}}+1)`$ of Theorem V.3. With $`k=1`$ its floor erodes before income can refill it, and it never survives.
- **The survival curve is non-monotone in calm.** Short calm starves the reserves; long calm erodes the floor. Only an intermediate band survives, and its width grows linearly with the controller's memory $`k`$.

**Output.** Inside its survival window the adaptive shield out-produces the static one, because it spends reserves the static shield holds idle. With $`k=4`$, cumulative output is 13 against 12 at $`L=6`$, 22 against 20 at $`L=8`$ and 30 against 28 at $`L=10`$. At $`L=12`$ the adaptive shield fails after producing 15, while the static shield survives with 36. Output is counted until failure, so a failing controller's output is truncated.

## V.4. Relation to existing research

Minsky's financial instability hypothesis holds that stability itself encourages the build-up of fragility (Minsky 1977). Theorem V.3 is a minimal, exact instance of that idea for a single organization's safety margin: the controller relaxes because nothing has happened, and the relaxation is what makes the next shock fatal. The model does not address the financial mechanisms Minsky described.

The horizon results connect to receding-horizon control. Argument I notes (I.3.6) that monotone loss needs a fixed terminal time and can fail with a receding horizon; Theorem V.1 states the underlying order, and Theorem V.2 shows that the choice an organization makes can flip as its planning horizon lengthens.

The shield results connect to Argument III. A viability shield computed from the exact kernel (III.8) is structural: it does not depend on recent experience. Sweep B shows what happens when the shield is instead tuned to experience. It earns more while the environment cooperates and fails when calm lasts longer than its memory.

## V.5. Strongest objections

**"Isn't a concession that is fatal later still rational if you would die today?"** Yes, and Theorem V.2 says so: in the 369 concession-only cells the clean fix is unaffordable and the concession is the only way through. The argument is not that concessions are mistakes. It is that their value depends on the horizon, so a short planning horizon will choose them also where the clean fix is affordable and the horizon is long, and that the scar window carries a cost survival statistics do not show.

**"Couldn't the adaptive controller just keep a non-zero floor?"** It could. A floor that never falls below $`m_{\mathrm{req}}`$ never fails a shock of size $`m_{\mathrm{req}}`$, but it is then a static shield at $`m_{\mathrm{req}}`$, with the corresponding output cost. Choosing that lower bound requires knowing the worst credible shock, which is the structural information an empirical rule does without.

**"Why wouldn't an organization remember a severe crisis?"** Memory is the parameter $`k`$. Longer memory pushes the failure threshold out linearly ($`L^*=3k`$ in the sweep) but does not remove it: for any finite $`k`$ there is a calm interval after which the same shock is fatal. Institutional memory that does not decay is part of a structural shield.

**"The models are tiny."** Yes. Theorems V.1–V.3 are general within their stated assumptions; the sweeps are exact for stylized parameters and establish existence and threshold behavior, not prevalence.

## Conclusion

Argument V adds time variation to the framework's two fixed elements, the horizon and the margin rule.

- **Horizons order kernels** (Theorem V.1), and **structural concessions reverse with the horizon** (Theorem V.2), with crossover horizons from 4 ticks to beyond 24 in the exact sweep.
- **Calm erodes empirical margins** (Theorem V.3), with an exact failure threshold $`L^*=3k`$ in the sweep.
- **Structural shields cost output but do not decay; empirical shields earn more and fail after long calm.**

## The arguments together

| Argument | Question | Core result |
|---|---|---|
| **I. The Paradox** | Why can adaptive organization reduce future adaptability? | Equal resources can conceal different recovery options; a short-horizon rule can select lock-in |
| **II. The Necessity** | When does the rate of adaptation become a survival constraint? | Necessity is a kernel condition; delay cannot restore viability under an unchanged ceiling |
| **III. The Escape** | How can a system find a viable transition before the window closes? | Escape is PSPACE-hard in general but tractable under structure; lock-in requires organizational certificates |
| **V. Concessions and Erosion** | What changes when the horizon or the margin rule varies? | Concessions reverse with the horizon; calm erodes empirical margins until an identical shock becomes fatal |

Argument IV is not part of this public release. The numbering is kept so that cross-references stay stable.

## References

- Minsky, H. P. (1977). The financial instability hypothesis: an interpretation of Keynes and an alternative to "standard" theory. *Challenge* 20(1), 20–27. [DOI](https://doi.org/10.1080/05775132.1977.11470296)

## Code and reproducibility

- **`Paradox/Concession.lean`:** `viab_shorten`, `horizon_antitone` (Theorem V.1), `concession_crossover` (Theorem V.2), `calm_floor` and `calm_erosion_fatal` (Theorem V.3). No `sorry`, no `native_decide`.
- **`Paradox/ConcessionModel.lean`** and **`ArgVMain.lean`:** Sweeps A and B; the executable `argV` writes `results/argV_output.txt`.
- **`python/toy/argV.py`:** the independent Python reference. `python python/crosscheck_all.py argV` compares it with the saved output line for line.
