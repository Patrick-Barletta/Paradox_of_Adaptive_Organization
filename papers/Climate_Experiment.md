# Climate Experiment: Viability Kernels for Deployment Capacity

*Companion to Arguments I and II. November 2026. Model-conditional results from a calibrated, stylized model: not a forecast.*

## What this experiment asks

**Argument II (rate window).** How fast must deployment capacity grow for warming to stay below a given limit? How does that required rate change with every year of delay? When does the window close?

**Argument I (policy comparison).** Can a policy that deploys abatement only up to a carbon-price cutoff lose its recovery window while a capacity-building policy stays viable? How do their cumulative costs compare before the window closes?

## Relation to earlier climate studies

Petschel-Held et al. (1999, §4, Fig. 4) related the permissible waiting time to a transition period and a maximum sustained rate of emissions reduction. Stocker (2013, Box 1 and Figs. 1–2) compared the last start under a finite emissions-reduction rate with the limiting case of an immediate drop to zero. Van Zalinge et al. (2017, §2) used stochastic viability and a family of mitigation scenarios to calculate climate points of no return. Aengenheyster et al. (2018, §§2–3) computed last starts for prescribed rates of increase in renewable energy's share at a specified probability of meeting a temperature target in 2100.

Iyer et al. (2015, Table 2) studied deployment limits directly, varying the growth allowed for individual technologies and the date of coordinated action. Here the constrained quantity is the aggregate capacity to add annual abatement. An order draws on the current deployment budget and delivers capacity after a lead time. The two deadlines in §3 hold the spending ceiling fixed and ask how much earlier action must begin when capacity has to be built. The successful programs and the exclusion bound in §2 establish whether any admissible order schedule can still meet the target at the reported closing dates. The resulting years depend on this model's budget, costs and capacity assumptions.

## The model

Annual steps $`t=0,1,\dots,60`$, where $`t=0`$ is 2027. The state follows I.3.1.

| Component | Meaning | Role in I.3 |
|---|---|---|
| $`f`$ | fraction of no-new-deployment emissions abated | physical state $`x`$ |
| $`C`$ | cumulative CO₂ since 1 Jan 2027 (Gt) | physical state $`x`$ |
| $`D`$ | **deployment capacity**: Gt/yr of abatement that can be added per year | organization $`O`$ |
| pipeline | capacity expansions ordered but not yet available (latency $`L`$) | commitments $`q`$ |

### Equations

**Emissions.**
```math
E_t = E_{\mathrm{ref}}(t)\,(1-f_t),\qquad
E_{\mathrm{ref}}(t)=E_0\exp\!\bigl(\gamma\,\tau_d\,(1-e^{-t/\tau_d})\bigr),
```
with $`E_0=43.3`$ Gt, $`\gamma=0.019`$, $`\tau_d=20`$ yr. $`E_{\mathrm{ref}}`$ is the no-new-deployment path. Its growth rate decays as demand growth slows.

**Costs.** The net abatement cost at depth $`f`$, in <span>$</span>/tCO₂, is
```math
n(f)=-50+490\,(e^{0.534f}-1).
```
With fuel and O&M savings $`s=\$100`$/t and asset life 25 years, the **capex density** (in <span>$</span>T per Gt/yr of abatement) and the **net cost** (in <span>$</span>/t) are
```math
c(f)=\psi\,\frac{\bigl(n(f)+s\bigr)\cdot 25}{1000},\qquad
n_\psi(f)=\psi\,\bigl(n(f)+s\bigr)-s.
```
The cost scale $`\psi`$ multiplies capex, meaning $`n+s`$. It does not multiply $`n`$ alone, because fuel savings are real money whatever capital costs turn out to be. So the depth at which abatement stops paying for itself ($`n_\psi=0`$) moves with $`\psi`$: 18% at $`\psi=1`$, 29% at $`\psi=0.75`$, 50% at $`\psi=0.5`$.

**Spending and deployment.** In year $`t`$, the spending available is
```math
Y_t=\varphi\cdot\$2.2\mathrm T\cdot1.025^{\,t}-c_{\mathrm{cap}}\,u_t,
```
where $`u_t`$ is new capacity ordered this year and $`c_{\mathrm{cap}}=\$0.3`$T per (Gt/yr per yr). Capacity expansion therefore competes with deployment for the same budget. Deployment moves $`f_t`$ to the largest $`f_{t+1}\le 1`$ satisfying three limits:

- **Spending:** $`E_{\mathrm{ref}}(t+1)\int_{f_t}^{f_{t+1}} c\le Y_t`$.
- **Capacity:** $`E_{\mathrm{ref}}(t+1)\,(f_{t+1}-f_t)\le D_t`$.
- **Depth cap:** the actor's depth cap, if any.

Negative net costs do not enlarge $`Y_t`$: fuel savings are not recycled into the transition budget.

**Capacity dynamics.** For a lead time of at least one year, capacity ordered at $`t`$ arrives at $`t+L`$: $`D_{t+1}=D_t+u_{t-L+1}`$. A program with growth rate $`r\in[0,g_{\max}]`$ orders $`u_t=r\,D_t`$ while capacity, including expansions in flight, is below what spending could use, and orders nothing otherwise. The incumbent uses $`r=r_0=2\%`$.

**Cumulative emissions and initial state.**
```math
C_{t+1}=C_t+E_t,\qquad f_0=0,\quad C_0=0,\quad D_0=0.75,
```
with $`L-1`$ earlier orders of $`r_0D_0`$ in the queue at the start of year 0. At $`L=2`$, the one outstanding order enters capacity in year 1 and the year-0 order enters in year 2. At $`L=1`$, the queue starts empty and the year-0 order enters in year 1.

### Viability

$`C`$ must stay within the carbon budget every year, **and** emissions must reach net zero ($`f=1`$) by 2087.

Carbon removal exists only as the expensive top of the cost curve, so a path that stalls below $`f=1`$ keeps emitting.

**Which constraint binds.** An ablation, reported as E-II.5 in Argument II, recomputes the results with the budget constraint alone. The closing years are unchanged in all 18 headline settings. At every closing boundary, the binding failure is a budget breach before 2087, not a missed net-zero date. The net-zero condition affects only the myopic carbon-price thresholds in §4, and then only slightly.

### Control classes

The classes map onto I.3.3 as follows.

| Class (I.3.3) | Spending | Capacity growth | Notes |
|---|---|---|---|
| $`\mathcal U_{\mathrm{fixed}}`$ | today's level, growing with GDP ($`\varphi_{\mathrm{inc}}=1`$) | 2%/yr | Capacity growth is the incumbent's native reorganization $`\mu_0`$ (I.3.3 remark), so $`m\not\equiv\varnothing`$ here |
| $`\mathcal U_{\mathrm{policy}}`$ | raised immediately to $`\varphi\times`$ today's | still 2%/yr ($`\mu_0`$) | Deliberately generous: assumes no political or capital-allocation lag |
| $`\mathcal U_{\mathrm{adapt}}`$ | $`\varphi\times`$ today's | any schedule up to $`g_{\max}`$ per year, latency $`L`$ | Capacity expansion is the capability-changing move |
| **Capacity-unconstrained** (substitute for $`\mathcal U_{\mathrm{phys}}`$, I.8) | $`\varphi\times`$ today's | no capacity limit | Spending-bounded, *not* purely physical |

Deployment is limited only by spending in the capacity-unconstrained class, so its "never" results reflect a spending ceiling, not physical impossibility. Below, "lock-in interval" means the years in which the target is reachable under the spending ceiling with unlimited capacity, but not by any admissible capacity build-out.

The $`\mu_0`$ rule ("grow while binding") is admissible along every trajectory, satisfying the first condition of the I.3.3 remark. Proposition 4 is not used for the climate model.

### Calibration

| Quantity | Value | Basis |
|---|---|---|
| Projected CO₂ emissions, 2026 | 43.3 Gt (fossil 38.2 + land use 5.1) | Global Carbon Budget 2026 full-year projection |
| Recent trend | total CO₂ grew ~0.3%/yr over 2016–25 | Global Carbon Budget 2026 historical estimate |
| Remaining budgets from 2027 (50%) | 1.5°C: 150 Gt · 1.7°C: 510 Gt · 2.0°C: 1,035 Gt | Global Carbon Budget 2026 |
| TCRE | 0.45°C per 1,000 GtCO₂, likely 0.27–0.63 | IPCC AR6 WGI |
| Robust budgets | central × 0.45/0.63 (worst case over the likely TCRE range) | derived |
| Estimated clean-energy investment, 2026 | ~$2.2T/yr | IEA full-year estimate covering several technologies and infrastructure categories |
| Initial deployment capacity | 0.75 Gt/yr per yr | Model assumption. Ember estimates that the wind and solar capacity added in 2025 can produce 1,046 TWh each year. Attributing about 0.7 GtCO₂/yr of displacement to that output implies about 0.67 tCO₂/MWh. |
| Emissions drift $`\gamma`$ | 1.9%/yr, decaying | set so that today's deployment gives the observed ~0.3%/yr trend |
| Cost curve $`n(f)`$ | about +$20/t at 25% depth, +$100/t at 50% | Model anchors informed by IPCC AR6 WGIII's assessment of mitigation potential across greenhouse gases |
| Cost scale $`\psi`$ | 1.0 = curve as calibrated; **0.5 = NZE-consistent** | Model scenario label. At $`\psi=0.5`$, twice the investment anchor ($`\varphi=2`$) and unlimited capacity, the model reaches net zero in 2050 after emitting 444 GtCO₂, within the 510 GtCO₂ budget for 1.7°C. |

**1.5°C is excluded from the sweeps.** Its budget is under four years of current emissions. It is at $`\sigma=4`$ (unreachable even with unlimited capacity) in every setting tested: all 18 combinations of $`\psi`$, $`\varphi`$ and central or robust climate response.

**Swept:**

| Parameter | Values |
|---|---|
| Cost scale $`\psi`$ | 0.5, 0.75, 1.0 |
| Spending $`\varphi`$ | 1.5, 2, 3 × today's |
| Maximum scale-up $`g_{\max}`$ | 20, 30, 40 %/yr |
| Capacity latency $`L`$ | 1, 2, 3 years |
| Target | 1.7°C, 2.0°C |
| Climate response | central, robust |

The rate-window sweep covers all 324 combinations of these.

The paradox sweep covers 288 configurations:

| Parameter | Values |
|---|---|
| Carbon price | $0, 25, 50, 75, 100, 150, 200, 300 per t |
| Cost scale $`\psi`$ | 0.5, 0.75, 1.0 |
| Spending $`\varphi`$ | 1.5, 2, 3 |
| Target | 1.7°C, 2.0°C |
| Climate response | central, robust |

It holds $`g_{\max}=30\%`$ and $`L=2`$ fixed.

### Why the results are exact for this model

1. **Maximal deployment dominates.** For any capacity schedule, deploying the maximum each year is at least as good as deploying less. Deeper abatement now never reduces what can be reached later: the reachable next depth increases with the current depth. The Lean theorem `greedy_suffices` shows that such a dominant rule can replace the full class when computing kernels. Numerically, 12,000 random schedules that deployed less than the maximum never beat it.

2. **Points of no return are exact over every capacity schedule.** The kernel is bracketed from both sides:
   - **Lower bound.** Constant-growth-rate programs give a witness whenever they succeed.
   - **Upper bound.** A relaxed program makes capacity expansion free ($`c_{\mathrm{cap}}=0`$) and grows at $`g_{\max}`$ **unconditionally**: it orders $`u_t=g_{\max}D_t`$ every year, without the "while binding" throttle. By induction its capacity, including the pipeline, is at least that of any schedule of the real model. With free expansion, more capacity never reduces deployment. The cost density $`c(u)`$ is strictly positive on $`[0,1]`$, since $`n(0)+s=\$50`$/t, so the reachable next depth increases strictly with current depth, capacity and spending. Hence this program dominates every schedule. If it fails, every schedule fails.

     The throttled programs are used only on the lower-bound side, where they supply witnesses.

   The two bounds give **the same point of no return in all 324 rate-window configurations and in all 576 paradox histories.** The capacity-building windows and lock-in intervals below are therefore exact over all time-varying capacity schedules, not only constant-rate ones, given the two dominance arguments. This meets the I.3.7 standard for claiming $`\sigma=3`$.

3. **Implementation check.** Lean and Python reproduce the reported fields on the 324 rate-window and 288 policy-comparison settings. An isolated-order check verifies the stated delivery year for each of the three lead times.

## Results

### 1. Money alone is never enough

Across all 324 configurations, raising spending immediately while retaining the incumbent capacity rule fails to meet the target. In settings where a faster program succeeds, the existing deployment capability is insufficient. In the framework's terms, no initial state in the sweep has severity 1.

### 2. How the rate window changes with delay

For the central 2°C target at NZE-consistent costs ($`\psi=0.5`$, $`\varphi=2`$, $`L=2`$), the table brackets the required annual growth ceiling on a grid spaced one percentage point apart. Failure of the free-expansion relaxation excludes every schedule at or below that ceiling. Success of a throttled program supplies a witness.

| Start year | 2027 | 2030 | 2033 | 2035 | 2037 | 2038 | 2039 | 2040 | 2041 | 2042 | 2043 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Highest tested ceiling excluded for all schedules | 4% | 5% | 7% | 8% | 11% | 14% | 17% | 23% | 33% | 56% | 100% |
| Lowest tested rate with a viable program | 5% | 6% | 8% | 9% | 12% | 15% | 18% | 24% | 34% | 57% | none ≤100% |

For a 2027 start, a ceiling of 4%/yr is insufficient and a 5%/yr program succeeds. By 2040 those bounds are 23% and 24%. At the specified 30% limit, **2040 is the last viable start**. Unlimited deployment capacity under the same spending ceiling permits a start through **2045**, leaving a **five-year lock-in interval**.

### 3. When the windows close

Last start year that still works, for capacity building and for the capacity-unconstrained class ($`g_{\max}=30\%`$, $`L=2`$):

| 2.0°C, central | $`\varphi=1.5`$ | $`\varphi=2`$ | $`\varphi=3`$ |
|---|---|---|---|
| $`\psi=0.5`$ (NZE-consistent) | 2037 / 2041 | 2040 / 2045 | 2043 / 2048 |
| $`\psi=0.75`$ | 2029 / 2033 | 2035 / 2040 | 2040 / 2045 |
| $`\psi=1.0`$ | never / never | 2029 / 2033 | 2037 / 2041 |

| 2.0°C, robust | $`\varphi=1.5`$ | $`\varphi=2`$ | $`\varphi=3`$ |
|---|---|---|---|
| $`\psi=0.5`$ | never / 2031 | 2029 / 2035 | 2032 / 2038 |
| $`\psi=0.75`$ | never / never | never / 2029 | 2029 / 2035 |
| $`\psi=1.0`$ | never / never | never / never | never / 2031 |

**Across the full sweep:**

- **2.0°C, central.** A capacity-building path exists from 2027 in 72 of 81 configurations. Among these, the last start ranges from 2027 to 2045 and the lock-in interval spans **2–8 years (median 4)**.
- **2.0°C, robust.** A capacity-building path exists from 2027 in 29 of 81 configurations. The latest closing year is 2034 and the lock-in interval spans **3–10 years (median 6)** among the open configurations.
- **1.7°C.** One of the 81 central settings admits a capacity-building path, from 2027 only. It combines the lowest costs, highest spending, 40% maximum scale-up and one-year lead time. Its unlimited-capacity deadline is 2032. All 81 robust settings exclude capacity-building paths.

**Transition costs and spending dominate the timing.** With a 30% growth ceiling and two-year lead time, varying costs and spending moves the central 2°C last start from no viable start to 2043. At $`\psi=0.5`$ and $`\varphi=2`$, varying growth and lead time across the tested grid moves it from 2038 to 2042.

### 4. Comparing a builder with a carbon-price cutoff

Vogt-Schilb and Hallegatte (2014, §§4–5.1) showed how limited deployment speed can make early investment in expensive, slow measures cost-effective when a long-term emissions target binds. Their model optimizes the timing of mitigation across measures. Here the two policies are prescribed. The comparison asks whether one policy can score at least as well at every annual prefix through its last viable start while the other preserves the ability to meet the target.

Two histories start from 2027:

- **The builder** expands capacity at the maximum rate and deploys the maximum.
- **The carbon-price cutoff policy** deploys abatement while its marginal net cost is below the specified price. It expands capacity to support that deployment. The output files call this rule `myopic`.

Precisely:

- **Builder:** $`r=g_{\max}`$, with no depth cap.
- **Myopic:** depth cap $`f^*(\pi)`$, where $`n_\psi(f^*)=\pi`$; it grows at $`g_{\max}`$ while capacity is binding below the cap.

Both use the throttled growth rule.

We score both prescribed histories using the same consumption proxy over $`H`$ years (in <span>$</span>T).
```math
J_H=-\sum_{t=0}^{H-1}\Bigl[\frac{E_{\mathrm{ref}}(t)\,N_\psi(f_t)}{1000}+c_{\mathrm{cap}}\,u_t\Bigr],\qquad
N_\psi(f)=\psi\Bigl(\int_0^f n+s f\Bigr)-s f.
```
$`N_\psi(f)`$ is the annual net cost of the deployed abatement stock, in <span>$</span>B per Gt of reference emissions. $`J`$ is reported at two horizons:

- $`H=14`$, covering 2027–2040;
- $`H=t^*_{\mathrm{myopic}}+1`$, covering everything up to the myopic point of no return.

The score omits climate damages and carbon-price payments. Carbon price sets the deployment cutoff in the decision rule. The growth rule then determines orders. Neither rule solves a dynamic maximization of $`J_H`$.

**What the score measures.** In the central 2°C case with $`\psi=1`$ and $`\varphi=2`$, the $100/t cutoff scores $0.943T over 14 years. The feasible $0/t cutoff scores $1.919T against the same measure. This supplies a direct counterexample to interpreting the $100/t cutoff as a maximizer of the reported score.

The comparison isolates an externality in the performance measure. Continued emissions reduce the remaining budget, while the consumption proxy records only abatement and capacity costs. The price cutoff can consequently preserve measured consumption while reducing the time available to recover.

**Results.** The builder is viable in 88 of 288 configurations. In 58 of those, the cutoff policy loses its 2°C recovery window while the builder stays viable. In all 58, the cutoff policy's cumulative score equals or exceeds the builder's at every annual prefix through the cutoff policy's last viable start. Each comparison uses unrounded scores.

Selected cases (2.0°C, $`\varphi=2`$):

| Cost scale | Carbon price | Myopic window closes | $`J`$ advantage until then |
|---|---|---|---|
| $`\psi=1.0`$ | $0/t | 2035 | +$0.02T |
| $`\psi=1.0`$ | $100/t | 2046 | +$0.40T |
| $`\psi=0.75`$ | $0/t | 2042 | +$0.80T |
| $`\psi=0.5`$ (central) | $0/t | 2053 | +$6.54T |
| $`\psi=0.5`$ (robust) | $0/t | 2042 | +$0.08T |

**The carbon price at which the myopic path keeps its 2°C window** is about $100/t at $`\psi=0.5`$, $200/t at $`\psi=0.75`$, and $300/t at $`\psi=1.0`$, resolved to the tested grid. These thresholds sit close to the net cost of the last tranche, $`n_\psi(1)`$: $98, $197 and $296/t. A myopic path that stops short of net zero keeps emitting, and those residual emissions breach the budget before 2087.

Dropping the net-zero condition lowers the thresholds by one grid step at the two lower cost scales ($75 and $175/t) and leaves the highest unchanged ($300/t). Part of that drop is horizon truncation: a stalled path can stay within budget through 2087 while still emitting afterwards. So the thresholds are set mainly by the carbon budget, and only marginally by the terminal condition. Cheap carbon removal would lower them.

At NZE-consistent costs the zero-price breakeven depth is 50%. At the central headline settings, the builder and the $0/t cutoff follow the same physical trajectory through 2039. In 2040 their abatement depths first differ.

## What this means for the arguments

**Argument II.** The window structure in II.4 appears concretely:

- Viability requires a growth ceiling above the modeled incumbent rate in the central headline case.
- The viable program and the exclusion bound both rise across the displayed start years.
- Spending alone never closes the gap.
- Among configurations with an open capacity-building window, the interval between the two deadlines is 2–8 years for central 2°C and 3–10 years for robust 2°C.

**Argument I.** The two policies exhibit an externality-type tradeoff. A higher cumulative consumption score can coexist with worse emissions and a shorter recovery window. The cutoff is prescribed. A claim about which policy a consumption-maximizing decision-maker would select requires specifying the available policies and optimizing across them.

## Limits

- **Stylized.** One aggregate sector, one aggregate capability, a smooth cost curve and linear TCRE. There are no damages, tipping feedbacks, carbon removal beyond the top of the cost curve, regional differences or political economy.
- **The incumbent is optimistic.** At today's spending it implies roughly 2.1–2.4°C by 2100, below published current-policy projections of about 2.6–2.8°C. Results therefore lean toward understating the difficulty.
- **Robust budgets are approximate.** Scaling by TCRE alone is not the same as the published 67% or 83% budgets.
- **Asset replacement and growth are free.** Deployment is constrained by $`E_{\mathrm{ref}}(t+1)(f_{t+1}-f_t)\le D_t`$ over a 60-year horizon. The model never charges capacity or spending to replace 25-year assets as they retire. It also never charges for keeping abatement proportional as $`E_{\mathrm{ref}}`$ grows: a fixed $`f`$ abates more tonnes each year at no cost. Both omissions favor the transition, so results again lean toward understating the difficulty.
- **The exactness claims rest on two dominance arguments,** maximal deployment and the free-expansion relaxation. Both are argued analytically and checked numerically, but neither is formally proved in Lean for this model's step function.
- **Results depend most on transition costs and spending.** This is stated in the closing-year tables, not hidden.
- **What the model can and cannot say.** It shows the structure of the problem and how the windows move with the assumptions. It cannot say where the real world stands.

## Files

- **Lean 4 project** (`paradox-lean`): `Paradox/Climate.lean` (model, kernels and certificate), `ClimateMain.lean` (sweeps; `--check` mode), and `Paradox/Theory.lean` (`greedy_suffices`).
- **Outputs:** `climate_output.txt`, `climate_window.csv` (324 configurations, with certificate columns) and `climate_paradox.csv` (288 configurations).
- **Python reference** (`python/`): `climate.py`, `experiments.py`, `checks.py` (dominance and two-phase checks) and `crosscheck_all.py` (every field of all 612 configurations).

## Sources

### Research on mitigation timing and deployment

- Aengenheyster, M., Q. Y. Feng, F. van der Ploeg, and H. A. Dijkstra (2018). The point of no return for climate action: effects of climate uncertainty and risk tolerance. *Earth System Dynamics* 9, 1085–1095. [DOI](https://doi.org/10.5194/esd-9-1085-2018)
- Iyer, G., N. Hultman, J. Eom, H. McJeon, P. Patel, and L. Clarke (2015). Diffusion of low-carbon technologies and the feasibility of long-term climate targets. *Technological Forecasting and Social Change* 90, 103–118. [DOI](https://doi.org/10.1016/j.techfore.2013.08.025)
- Petschel-Held, G., H.-J. Schellnhuber, T. Bruckner, F. L. Tóth, and K. Hasselmann (1999). The Tolerable Windows Approach: Theoretical and Methodological Foundations. *Climatic Change* 41, 303–331. [DOI](https://doi.org/10.1023/A:1005487123751)
- Stocker, T. F. (2013). The Closing Door of Climate Targets. *Science* 339, 280–282. [DOI](https://doi.org/10.1126/science.1232468)
- van Zalinge, B. C., Q. Y. Feng, M. Aengenheyster, and H. A. Dijkstra (2017). On determining the point of no return in climate change. *Earth System Dynamics* 8, 707–717. [DOI](https://doi.org/10.5194/esd-8-707-2017)
- Vogt-Schilb, A., and S. Hallegatte (2014). Marginal abatement cost curves and the optimal timing of mitigation measures. *Energy Policy* 66, 645–653. [DOI](https://doi.org/10.1016/j.enpol.2013.11.045)

### Calibration sources

- **Friedlingstein et al. (2026), *Global Carbon Budget 2026*.** The November preprint and accompanying Global Carbon Project release project 43.3 GtCO₂ for 2026 and estimate 0.3% annual growth in total emissions over 2016–2025. The project gives remaining budgets from January 2027 of 150, 510 and 1,035 GtCO₂ for a 50% chance of limiting warming to 1.5, 1.7 and 2.0°C, respectively. [Preprint](https://doi.org/10.5194/essd-2026-895) · [Project figures and budget table](https://cger.nies.go.jp/gcp/pdf/20261110/Key%20Messages%20Global%20Carbon%20Budget%202026.pdf)
- **IPCC (2021), *Climate Change 2021: The Physical Science Basis*.** The Summary for Policymakers, D.1.1 and Figure SPM.10, gives a best estimate of 0.45°C warming per 1,000 GtCO₂ emitted and a likely range of 0.27–0.63°C. The robust-budget multiplier in the table is the model’s approximation. [Working Group I summary](https://doi.org/10.1017/9781009157896.001)
- **IPCC (2022), *Climate Change 2022: Mitigation of Climate Change*.** The Summary for Policymakers, C.12.1 and Figure SPM.7, estimates that options at or below $100/tCO₂-eq could deliver cuts by 2030 equivalent to at least half of 2019 global greenhouse-gas emissions. Options below $20/tCO₂-eq account for over half of that potential. The experiment fits its own CO₂ cost curve to these benchmarks. [Working Group III summary](https://doi.org/10.1017/9781009157926.001)
- **International Energy Agency (2026), *World Energy Investment 2026*.** The IEA’s estimate of $2.2 trillion in 2026 covers renewables, nuclear, grids, storage, low-emissions fuels, efficiency and electrification. Its 2023 net-zero roadmap puts clean-energy investment at about $4.5 trillion per year by the early 2030s. The experiment’s doubled opening budget of $4.4 trillion is a scenario assumption. [2026 investment report](https://www.iea.org/reports/world-energy-investment-2026) · [2023 net-zero scenario](https://www.iea.org/reports/net-zero-roadmap-a-global-pathway-to-keep-the-15-c-goal-in-reach/executive-summary)
- **Ember (2026), *World adds a record-breaking 814 GW of solar and wind in 2025*.** Ember reports 814 GW of installed additions and estimates their annual output at 1,046 TWh. The assumed emissions displaced by that output and the choice of 0.75 Gt/yr per yr for initial deployment capacity are model inputs. [Ember’s capacity analysis](https://ember-energy.org/latest-updates/world-adds-a-record-breaking-814-gw-of-solar-and-wind-in-2025/)
