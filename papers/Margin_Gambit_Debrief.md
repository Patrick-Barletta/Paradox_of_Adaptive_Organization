# The Margin Gambit: Game Debrief and Weaknesses Exposed

*Debrief of a two-operator stress-test game played on 2026-11-20 against the framework of "The Paradox of Adaptive Organization" (Arguments I–III). Operator A was played by Claude, with an exact-state solver; Operator B and the environment were adjudicated by the game master (GM).*

---

## 1. What the game was

Two energy-compute operators share a grid. Each tick, each one picks a single action. Each wants to survive the horizon and finish with the higher cumulative output.

| Mechanic | Maps to | Rule |
|---|---|---|
| Specialize | Argument I (lock-in) | Legacy output 3 → 5 and burden +1 → +3/tick from the next tick. Next-Gen build requirement rises 2 → 4. |
| Shared burden $`C_t`$ | Argument II (endogenous deadline) | Never decreases. When $`C_t \ge 18`$, Legacy output drops to 0 for good. |
| Black-Start Seed | Argument III (cycle-breaking seed) | Lets an operator act through the blackout on the first tick after the flip. |
| Market siphon | Strategic coupling | A lead of ≥ 2 output moves 1 reserve from the laggard to the leader. |
| Reserve cap 10, upkeep 2 | Bounded slack | Surplus above 10 is lost. Reserves below 0 means collapse. |

**Mid-game shocks:**

| At tick | Shock | What it changed |
|---|---|---|
| 4 | Horizon extension | $`T`$: 10 → 20 |
| 5 | Data center energized during blackout | Upkeep 3. The grid stays dark until 3 Black-Start progress. Next-Gen 4 → 5 if the data center is kept. Option to shed it. |
| 7 | Civil lawsuit (consequence of shedding the data center) | 30% output drag. 1-tick sign-off to switch policies. Settlement options 7a/7b. |
| 9 | DoJ probe targeting A (consequence of detonating the flip and siphoning B) | Upkeep 2.5. Civil settlement frozen. Asset freeze if not resolved by the end of tick 13. Options: 8a Full Forensic Audit (full restoration) or 8b Consent Decree (permanent 3.0 output cap and permanent 1-tick switch delay). |

**GM rulings during play:**
1. The horizon is fixed at 10 action ticks. This was later extended by shock.
2. Specialize after unlocking Next-Gen is allowed. Specialize raises the acquisition threshold but never deletes a capability already held.
3. The blackout freezes Next-Gen operators that lack a seed.

---

## 2. What happened

| Tick | A action | B action | A reserves after | B reserves after | $`C`$ after | Cumulative output (A / B) |
|---|---|---|---|---|---|---|
| 0 | Accelerate Build | Specialize | 0 | 6 | 1 | 1 / 3 |
| 1 | Specialize (Next-Gen already unlocked) | Legacy | 0 | 10 | 5 | 4 / 8 |
| 2 | Legacy (Spec) | Legacy | 3 | 10 | 11 | 9 / 13 |
| 3 | Legacy (Spec) | Legacy | 6 | 10 | 17 | 14 / 18 |
| 4 | Legacy (Spec) | Legacy | 9 | 10 | 23 (flip) | 19 / 23 |
| 5 | Shed Data Center | Shed Data Center | 6 | 7 | n/a | 19 / 23 |
| 6 | Standard Black-Start | Standard Black-Start | 4 | 5 | n/a | 19 / 23 |
| 7 | Compliance Sign-Off | Build (0.7) | 2.0 | 3.0 | n/a | 19 / 23 |
| 8 | Next-Gen (2.8) | Build (0.7) | 3.8 | 0.0 | n/a | 21.8 / 23 |
| 9 | Consent Decree | Build (0.7) | 2.3 | −3.0 (collapse) | n/a | 23.8 / 23 |
| 10–19 | Next-Gen (capped 3.0) | (eliminated) | → 10 (cap at tick 17) | n/a | n/a | **53.8 / 23.0** |

**Result:** A survived to $`T = 20`$ with 53.8 output. B collapsed on tick 9 with 2.1/4.0 Next-Gen progress, having led on reserves (10/10) and on cumulative output through tick 8.

### 2.1 Key decisions and what each one tested

**Tick 0: Accelerate while still a generalist.**
- At generalist latency, one Accelerate completes the transition. It left A at exactly 0 reserves. That was safe against every B action because B's maximum output on tick 0 was 3.
- The solver ranked this opening first against all five B models (pivot after the flip, at $`C \ge 12`$, at the reserve cap, seed-first, never pivot), under both horizon readings.

**Tick 0: B Specializes.**
- Specialize ties Legacy on immediate output and burden and beats it from tick 1. The doubled build requirement never appears in anything B monitors.
- This is Argument I's invisibility mechanism, exactly as predicted.

**Tick 1: Specialize after acquiring the substitute.**
- This captured specialist legacy rents with no lock-in cost.
- It also gave A control over the burden. On each tick, A could choose 5 output with +3 burden, or 4 output with no burden.

**Ticks 2–3: closing B's window.**
- An exact survival search confirmed tick 3 as B's last escape tick ($`t^*_{\mathrm{adapt}}(B) = 3`$, $`\mu_B = 0`$).
- From $`(t=4,\ C=17,\ x_B=10,\ q_B=0/4)`$, no B continuation survives. A generalist in the same physical state escapes with a single Accelerate.
- B's own Legacy supplied most of the burden: with A on Next-Gen, $`C`$ still reaches 20 one tick later. A could not hold the deadline back. It could only bring it forward by one tick.

**Tick 4: Legacy over Black-Start.**
- The solver showed Legacy kills B on every B reply. Black-Start scores 1–2 points higher but leaves B an escape (+4 lead with B alive).
- A chose elimination. **This skipped the seed**, and the tick 5 cold-load shock punished that choice.

**Tick 5: Shed the data center.**
- Keeping the data center gives the same net reserves while running (5 − 3 = 4 − 2) but raises the burn on any zero-output tick (3 vs 2).
- Once the competitive outcome was locked, the data center's extra output only padded the score while lowering A's reserve floor. A took 71 projected output with a 4-reserve floor over 84 with a 1-reserve floor.
- The shed caused the lawsuit. It also saved A: entering tick 7 at 1 reserve with upkeep 3 and a forced sign-off would have meant collapse.

**Tick 7: Sign-Off, and settle later on a feedback rule.**
- The rule was to settle once paying leaves ≥ 3.0 reserves. This is closed-loop feedback over observed reserves, not a calendar commitment.

**Tick 9: Consent Decree.**
- 8b on tick 9 still collected B's final siphon (output 2.0 vs 0). It beat "Next-Gen now, decree on tick 10" from tick 10 on in both reserves and output, and it removed exposure to DoJ escalation.
- Full Forensic Audit could never leave more than 0.7 reserves (it needs 5.0 going in, and reserves grew only 0.3/tick).
- A chose to clear the irreversible failure mode first: the indictment deadline leads to institutional lock-in, while a reserve drain is recoverable above zero. A accepted permanent damage to its organization in exchange.

**Post-game scar check.**
- Starting tick 10 at 2.3 reserves and gaining +1.0/tick, a forced policy switch (two zero-output ticks, cost 4) is fatal on ticks 10–11 and survivable from tick 12.
- An operator without the switch delay survives a single dead tick (cost 2) from tick 10 onward.
- The concession did not remove fragility. It moved it into a two-tick window, and the window grows if the horizon is extended.

---

## 3. Weaknesses exposed

Status reflects a check against the drafts in `papers/` (Argument I, II and III .md) and `Paradox/Theory.lean`.

### W1. Lock-in comes from move order unless specialization deletes or decays capabilities. *Status: tested (2026-11-22). See Argument I, I.7 Experiment E, and `results/friction_output.txt`.*

- **Result:** In the frictionless settlement model, lock-in under the two-tick rule is pure tie-breaking: a viability shield saves all 6,000 settings without lowering the objective. A training cost of one food per trainee-tick makes selection strict in all 4,940 lock-in settings. Skill decay (condition (c) below) closes "acquire first, then specialize": with decay after 2 idle ticks, that rule locks in 1,425 settings. Decay alone never makes selection strict, because the two-tick rules never hold farming idle.

- **Exposed by:** the tick 1 ruling. Specialize after acquiring the substitute is strictly better and never locks in.
- **In the drafts:** I.2 names attrition, skill loss and decay as drivers of organizational drift. Argument III §III.4 uses STRIPS delete lists in its hardness reduction. The Argument I exact settlement model, however, has specialization raise the training threshold without deleting farming once acquired. The Central claim already notes that ties favoring training preserve recovery.
- **Weakness:** within the toy model, specialization lock-in reduces to a sequencing or slack-allocation error. Specialization itself does not cause it.
- **Fix:** state the condition explicitly. Argument I's paradox requires at least one of:
  - (a) specialization deletes or degrades the substitute capability
  - (b) maintaining an unused capability costs something
  - (c) held capabilities decay over time
  - (d) no slack window exists in which to acquire the substitute first

  Add a delete-effect or attrition variant to the settlement model and show lock-in survives the "acquire first" strategy.

### W2. Shared irreversible burden becomes a strategic weapon with more than one controller. *Status: genuine gap.*

- **Exposed by:** ticks 2–4. Once A had transitioned, accelerating $`C`$ cost A nothing and pushed B past $`t^*_{\mathrm{adapt}}`$ into $`\sigma = 3`$.
- **In the drafts:** Arguments I and II are single-controller frameworks. II treats niche-constructed burden as produced by the system's own history. I.6 cites Mitchell, Bayen & Tomlin (2005), but the dynamic-game direction is not developed.
- **Weakness:** the theory has no account of the deadline as a variable that a competitor controls.
- **Two observations to carry forward:**
  1. **Asymmetric incentives.** An agent inside $`\mathcal{K}^\infty_{\mathrm{policy}}`$ on the new technology wants the shared deadline to arrive early. Agents outside it do not.
  2. **Self-inflicted deadlines.** The locked-in agent supplied most of the burden itself. A's "hold off" option delayed the flip by only one tick.
- **Fix:** a two-player viability-kernel game on the shared burden. A testable prediction follows: firms that have finished transitioning should push for faster shared deadlines (regulation, standards, capacity), while incumbents should not see their own contribution to the clock.

### W3. Robust optimization over a finite threat set undervalues cycle-breaking seeds. *Status: partial. Candidate lemma.*

- **Exposed by:** tick 4. Black-Start lost on every branch of A's minimax solver because the cold-load lock was outside the modeled threat set. It was the decisive missing capability one tick later.
- **In the drafts:** Argument I §I.4.3 cites Carlson & Doyle's "robust yet fragile" structure. Argument III identifies minimum seed sets with minimum directed feedback vertex sets (Theorem III.3), and §III.6 shows a black-start hydro unit restoring 7 of 7 while added redundancy restores nothing.
- **Weakness:** the drafts never connect these two results.
- **Fix (candidate lemma):** any robust optimizer over a fixed finite $`\mathcal{W}_{\mathrm{dist}}`$ assigns non-positive value to a cycle-breaking seed whose payoff lies only outside $`\mathcal{W}_{\mathrm{dist}}`$, because the seed costs something now and pays off on no modeled branch. **Consequence:** restoration independence cannot be left to payoff-based optimization. It has to be imposed as a structural (graph) constraint. This connects Argument I's fragility discussion to Argument III §III.6.

### W4. Reactive threats: narrower than first claimed. *Status: resolved (2026-11-22). The counterexample is proved in `Paradox/Theory.lean`, and the assumption is stated next to Proposition II.1.*

- **Exposed by:** the shed causing the lawsuit, and the detonation and siphon causing the DoJ probe. A's robust moves generated the next disturbance.
- **Original claim (withdrawn):** that policy-dependent threats break the fixed-$`\mathcal{W}_{\mathrm{dist}}`$ kernels and the `hnest` hypothesis in `Theory.lean`.
- **Why it does not hold:**
  - `Viab` is existential, so adding actions can only enlarge the kernel. The agent can decline to use them.
  - A threat that reacts to *actions taken* becomes Markov once the reaction-relevant history is put into the state. Legal exposure belongs in $`q_t`$ anyway.
  - On the augmented state, each action's transitions are fixed regardless of class. `hnest` holds, and `nesting`, `rate_upward` and `delay_never_lowers_required_rate` stand.
  - In `RSys` form, aggressive actions simply have extra successor branches. The game's shocks were representable in this way. A's solver did not include them.
  - Most of W4 is therefore W3: a misspecified threat set, which is a gap in the agent's knowledge rather than in the formalism.
- **What actually falsifies `hnest`:** *capability-indexed reactions.* These are reactions to what an agent can do, whether or not it does it. If holding a higher acceleration ceiling changes the outcome of existing actions, then `step r' t s s'` is no longer a superset of `step r t s s'`. Then:
  - a higher ceiling can *shrink* the kernel, so `rate_upward`'s conclusion fails
  - Proposition II.1's "required rate only rises with delay" holds only within a class where nesting holds

  Real-world cases include the security dilemma, antitrust triggered by capacity or market share, and regulatory scrutiny scaled to capability.
- **Fix:** state the assumption ("reactions depend on actions taken, not capabilities held") next to Proposition 1 and Proposition II.1. Add a counterexample theorem next to `robust_monotone_loss_fails`:

```lean
/-- Capability-indexed reaction: holding the high ceiling changes the outcome of the
    same physical move. `false` = low ceiling, `true` = high ceiling. -/
def capStep : Bool → Nat → Nat → Nat → Prop
  | false, _, s, s' => (s = 0 ∧ s' = 1) ∨ (s = 1 ∧ s' = 1) ∨ (s = 2 ∧ s' = 2)
  | true,  _, s, s' => (s = 0 ∧ s' = 2) ∨ (s = 1 ∧ s' = 1) ∨ (s = 2 ∧ s' = 2)

def capV (s : Nat) : Prop := s ≠ 2

-- Targets (not yet written or compiled):
--   ¬ (∀ t s s', capStep false t s s' → capStep true t s s')        -- hnest fails
--   ∀ T ≥ 1, K ⟨capStep false, capV⟩ T 0 0 ∧ ¬ K ⟨capStep true, capV⟩ T 0 0
```

*Done:* `Theory.lean` proves these with a natural-number ceiling (`cap_not_nested`, `cap_kernel_shrinks` for every `t < T`, and `rate_upward_needs_nesting`), using only `propext` and `Quot.sound`. The caveat is not needed for Proposition 1: in Argument I held capabilities are part of the state `O`, so reacting to them is ordinary state-dependent dynamics.

### W5. The value of organizational structure depends on the horizon. *Status: implicit.*

- **Exposed by:** tick 9. A traded permanent organizational capacity (output cap, halved rebuild rate, permanent switch delay) for the removal of an external deadline. The concession is dominant with 10 ticks left and becomes dominated as $`T`$ grows.
- **In the drafts:** finite-horizon kernels $`\mathcal{K}_k(t)`$ and infinite-horizon invariance are both present. §III.9 states that fast revision authority is itself a capability whose latency counts against margin.
- **Weakness:** there is no result for when degrading organization to protect resources is rational. This is the inverse of the Argument I paradox: Argument I degrades future adaptability to chase output, while here adaptability is sacrificed for survival.
- **Fix:** a crossover horizon $`T^*`$, scaling with the expected frequency of forced policy switches times the per-switch latency cost. Below $`T^*`$ the concession is dominant, and above it dominated. The post-game scar check (fatal window on ticks 10–11, cleared at tick 12) is a worked instance.

### W6. Risk appetite and the objective shift during the run. *Status: genuine gap.*

- **Exposed by:** A's floor policy across the game.
  - **Before any shock (ticks 0–1):** A ran at 0.0 reserves twice. The rules were fixed and the solver proved it safe.
  - **After the first shock:** A never went below 2.0, and repeatedly traded output for margin (84 → 71 on tick 5, the delayed settlement on tick 7, 56.6 → 53.8 on tick 9).
  - **Once output passed B's ceiling:** A dropped relative output as its objective and maximized viability margin instead.
- **In the drafts:** decision rules use a fixed objective $`J`$ and a fixed lookahead. Argument III's anytime loop updates model bounds and deadlines, but not risk posture or objective.
- **Weakness:** none of these behaviors can be expressed in the current framework:
  1. learning how stable the rules are from the history of shocks
  2. switching objectives once an outcome is secured (winning → surviving)
- **Fix:** an upper control layer that sets the margin target from observed disturbance frequency and switches the objective lexicographically. **Prediction:** a second-order cycle in which long calm periods erode the margins built after the last crisis.

### W7. Institutional constraints can be unwound; physical ones cannot. *Status: already in the draft, with two extensions.*

- **In the drafts:** §II.1 states that commitments in $`q`$ (debt, contracts, pending obligations) can be unwound at a cost and latency, while accumulated physical burden cannot. Assumption A0 keeps institutional constraints in $`\mathcal{A}, \Pi, \mathcal{M}`$ rather than $`\mathcal{V}`$.
- **What the game adds:**
  1. **Prerequisite chains inside $`q`$:** the DoJ hold blocked the civil settlement. This brings Argument III's dependency analysis into institutional commitments.
  2. **A priority rule:** clear irreversible or externally controlled deadlines before optimizing reserve floors. This is why A signed on tick 9 rather than waiting for the higher-floor tick 13 option.

---

## 4. Proposed work items, in priority order

1. **W3 lemma (seed undervaluation).** State and prove it. This bridges Argument I §I.4.3 and Argument III §III.6, and justifies restoration independence as a structural constraint.
2. ~~**W4 counterexample (capability-indexed reactions).**~~ Done 2026-11-22 (see W4).
3. ~~**W1 condition.**~~ Done 2026-11-22: skill decay and a training cost were added to the settlement model, with a viability shield and "acquire first" rules (see W1).
4. **W2 extension.** Formulate the two-player shared-burden kernel game. Derive the asymmetric-deadline incentive and the self-inflicted-deadline result.
5. **W5 result.** Derive the crossover horizon for structural concessions.
6. **W6 layer.** Add adaptive risk posture and objective switching to the decision rules. This is the largest scope and is possibly a separate paper.

---

## 5. Limits of this exercise

- **Adversarial GM.** Shocks were designed after the fact and in response to A's last decision, so they amount to a strong adversary, not a calibrated disturbance model. That is appropriate for finding weaknesses but says nothing about how often such shocks occur.
- **Solver scope.** A's solver checked fixed B policies and full B minimax over the stated rules. It never modeled the GM's shocks, which is itself the W3 finding.
- **Rule ambiguities.** A few were resolved by the GM during play: horizon length, specialize after unlock, blackout scope, siphon during collapse, and cap applied after siphon. Results are exact under those rulings.
- **Single run.** This is a worked example of each mechanism, not a statistical test.
