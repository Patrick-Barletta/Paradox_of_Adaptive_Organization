# Empirical Test Plan — Pre-registration

**Status:** frozen before any case source was consulted for this project. This file is committed before evidence collection; later changes are recorded as dated amendments at the end and do not overwrite the original text.

**Design:** retrospective hypothesis testing and historical prediction reconstruction. The outcomes of all five cases are known, and the investigator has general prior knowledge of them, so no part of this work is a prospective or out-of-sample validation. Pre-registration constrains what counts as support; it cannot blind the investigator.

**Purpose:** to try to falsify the application of the existing framework to documented failures, not to find events that resemble it. A case may be reported as unsuitable for testing a given claim.

## 0. Framework under test (unchanged)

The instruments are the existing definitions, used without modification:

- `Sys`, `Viab`, `K` and the robust kernel `RSys`/`RViab` (`Paradox/Theory.lean`; I.3.4, I.3.8).
- The four control classes $`\mathcal U_{\mathrm{fixed}}\subseteq\mathcal U_{\mathrm{policy}}\subseteq\mathcal U_{\mathrm{adapt}}\subseteq\mathcal U_{\mathrm{phys}}`$ (I.3.3), assumptions A0–A3 (I.3.4), severity $`\sigma\in\{0,\dots,4\}`$ (Definition 3), points of no return $`t^*_k`$ (Definition 4) and margin $`\mu`$ (I.4).
- Argument III's timed bootstrap (`Paradox/Timed.lean`): static reachability of a capability can coexist with timed unreachability.
- Argument V (`Concession.lean`, `ConcessionModel.lean`): Theorem V.2 (horizon reversal of a structural concession) and Theorem V.3 (an experience-based floor that relaxes during calm fails a shock after long calm).
- Argument VI (`Ratchet.lean`, `RatchetModel.lean`, `SharedRatchet.lean`): Theorem VI.1 (serial latency accumulated by successive patches exhausts a bounded deadline), Theorem VI.2 (blocked state: organizational exclusion with a physical alternative), the abandonment and authorization-timing variants, Theorems VI.3–VI.5 (joint system, shared ratchet, seed governance).

No Lean proof or saved result is modified by this work. Empirical models live under `research/empirical/` and reuse the existing semantics.

## 1. Four evidentiary levels (kept separate in every report)

1. **Formal possibility:** the framework admits the mechanism (already established by the theorems).
2. **Historical mechanism:** primary records document the mechanism's necessary components in the case.
3. **Causal identification:** the mechanism survives the pre-specified rival explanations, with documented counterfactual feasibility where a counterfactual is used.
4. **Predictive validity:** indicators computed from contemporaneous information only discriminate the failure better than pre-specified simple baselines.

A result at one level is never reported as a result at a higher level.

## 2. Evidence grades (per hypothesis)

- **Supported:** necessary components documented in primary records and surviving the listed rivals within the available evidence.
- **Partially supported:** important components documented; causal identification incomplete.
- **Contradicted:** reliable evidence conflicts with a necessary prediction.
- **Not identifiable:** the evidence cannot distinguish the hypothesis from alternatives.

Formal severity is graded separately as **established**, **not identifiable**, or **ruled out**, under Section 3.

## 3. Rules for formal classification (all cases)

- **Severity 3** requires all of: (a) a physically viable alternative documented as implementable with the technology, resources and time available at the decision point; (b) its viability under the same external disturbances and causal response laws (A3, I.3.3 "what $`\mathcal U_{\mathrm{phys}}`$ relaxes"); (c) a documented organizational restriction (authority, procedure, certification, contract, governance) that excluded it; (d) its time, resource, activation and authorization requirements checked. Failing any item, severity is **not identifiable**. Failure alone never implies severity 3.
- **Severity 1 or 2** requires documentation that a policy revision (1) or a capability-changing move (2) available to the organization would have preserved viability, with its latency.
- **Hypothetical engineering alternatives** (not documented as available) may be discussed only as labeled hypotheticals and never support a severity classification.
- **No invented parameters:** no numerical $`k`$, $`L^*`$, latency or kernel membership from qualitative evidence. Missing quantities are symbolic or bounded, with the bound's source stated.
- **Serial vs parallel:** a dependency counts toward serial recovery latency only if the record shows it must complete before the next step can start.

## 4. Primary metrics (frozen)

| Metric | Definition | Cases |
|---|---|---|
| M1 Serial recovery latency | documented minimum time to reach a safe/functional configuration through mandatory sequential steps, at dated decision points | A, B, C |
| M2 Serial dependency increments | number of dated interventions each documented to add a mandatory sequential prerequisite to recovery | A, B |
| M3 Remaining margin | documented deadline (time to loss of viability) minus M1 at the decision point | A, B, C |
| M4 Concession | documented near-term benefit of a choice and documented persistent capability cost incurred later | A |
| M5 Joint viable intervention | existence of a documented intervention, within historical execution constraints, that would have preserved joint viability; and which organization held authority over it | B |
| M6 Abortability / recovery independence | whether a transition in flight could be stopped; whether affected units had a recovery path not requiring per-unit manual access | C |
| M7 Protective margin series | a dated series of an actual protective margin (haircut, buffer, limit, acceptance criterion) with a pre-specified disturbance measure | D, E |
| M8 Calm-conditioned relaxation | whether margin reductions follow calm intervals more than they follow other drivers (exposure growth, asset mix, regulation) | D, E |
| M9 Predictive discrimination | whether framework indicators from contemporaneous data separate failures from comparison units better than baselines (output, reserves, redundancy count, recent success, standard risk metrics) | any case with sufficient data |

## 5. Cases

### Case A — Boeing 737 MAX (Arguments V, VI)

- **Claims tested.** H1A (Theorem V.2 setting): a documented choice with lower near-term cost carried a persistent capability cost that became consequential later. H1B (Theorem VI.1 setting): successive dated modifications each added a mandatory serial prerequisite to reaching a safe configuration, so that recovery latency grew toward a deadline.
- **Viability.** Safe controllability of the aircraft in documented failure conditions (A0: physical state $`x`$ = aircraft functional state and operating constraints).
- **State mapping.** $`x`$: aircraft safety-relevant state; $`O`$: design architecture, subsystem dependencies, certification-related capabilities; $`\pi`$: engineering and operating decision policies; $`q`$: development commitments, modifications in progress; $`w`$: market, regulatory, physical disturbances.
- **Control classes.** fixed: the program's decision rules as executed; policy: procedural/training changes within the existing certified design; adapt: design changes requiring certification moves; phys: changes physically implementable with available technology and time (documented only).
- **Disturbance path.** A320neo competitive pressure; later in-service sensor failure conditions.
- **Mechanism and rivals.** Concession and serial accumulation vs: specific safety-analysis or implementation defects; certification/oversight failures; communication failures; financial/schedule constraints without a ratchet; a design deficiency without accumulating serial latency.
- **Minimum evidence.** H1A: dated decision with documented near-term benefit and documented later capability cost. H1B: at least two dated interventions each documented to add a mandatory sequential step to recovery (M2 ≥ 2), with a documented latency or ordering.
- **Rejection.** H1A contradicted if the documented choices had no persistent capability cost or no near-term benefit. H1B not supported if fewer than two such interventions are documented; contradicted if the record shows the remediation path did not lengthen with the modifications.
- **Missing data / confounders.** Internal cost and schedule data; counterfactual design feasibility; hindsight in post-accident reviews.

### Case B — 2003 Northeast blackout (Argument VI Part II; Argument III timing)

- **Claims tested.** H2 (Theorems VI.3–VI.5 setting): organizations with locally viable procedures formed a joint system that could not preserve viability under a shared disturbance; a fixed routine at one organization restricted collective recovery. Separately, Theorem VI.4's repeated-patching mechanism is tested only if prior dated interventions that cumulatively increased serial dependency depth are documented.
- **Viability.** Bulk system operating within thermal, voltage and stability limits (no uncontrolled cascade).
- **State mapping.** $`x`$: grid operating state (flows, line status, voltage); $`O`$: control authorities, tools (alarm/EMS), coordination arrangements; $`\pi`$: operating procedures; $`q`$: actions in progress; $`w`$: line contacts with vegetation, load, generation outages.
- **Control classes.** fixed: procedures as executed; policy: actions within each operator's existing authority and tools (load shedding, redispatch); adapt: changes to tools, authority or coordination; phys: any physically executable action within latency limits.
- **Mechanism and rivals.** Shared-dependency restriction vs: situational-awareness failure; protection-system behavior; vegetation management; tool failure without governance restriction.
- **Minimum evidence.** A timed dependency graph with edge types and control authority; a documented intervention with its execution time before the cascade; documentation of who held authority and whether it was restricted.
- **Rejection.** H2 contradicted if the record shows the responsible organization had authority and tools to execute a sufficient intervention and the failure is explained by not knowing (situational awareness), with no restriction on others' actions. Ratchet test reported as not applicable without documented prior serial increments.
- **Missing data.** Exact action latencies; counterfactual flow studies beyond those in the task force report.

### Case C — CrowdStrike 2024 (Argument VI abandonment variant; independent startup)

- **Claims tested.** H3: the system retained central control of distribution but lacked a centrally executable recovery path for affected endpoints; the inability to reverse a completed transition increased recovery latency without further physical damage.
- **Viability.** Endpoints operational (booting and running the dependent services).
- **State mapping.** $`x`$: endpoint state (crashed/operational); $`O`$: recovery capabilities (remote vs manual remediation, recovery environments); $`\pi`$: release and remediation procedures; $`q`$: update in distribution, remediation in progress; $`w`$: none beyond the defective content.
- **Mechanism and rivals.** Abortability/recovery independence vs: the defect itself determines the outcome once endpoints crash; recovery latency driven by encryption keys, access, or customer staffing rather than architecture.
- **Minimum evidence.** Time-stamped release and halt; documented remediation procedures with stated requirements (physical/console access, recovery keys); documented existence or absence of an independent recovery mechanism.
- **Rejection.** H3 contradicted if a documented centrally executable recovery path existed and was available, or if halting distribution earlier is shown not to change the set of affected endpoints. No severity class without device-level timing evidence.

### Case D — 2007–2009 financial crisis (Argument V, Theorem V.3)

- **Claims tested.** H4: a protective margin set from recent experience relaxed during long calm, leaving less protection for a later comparable disturbance. The model's $`L^*=3k`$ is not an empirical prediction; any real threshold must be estimated from data or reported unidentifiable.
- **Viability.** Ability to meet funding obligations without forced failure or emergency support.
- **State mapping.** $`x`$: usable liquid resources and funding; $`\pi`$: risk-limit or margin rule; $`q`$: calm-memory state; $`w`$: market volatility/funding shocks.
- **Mechanism and rivals.** Calm-conditioned margin erosion vs: exposure/leverage growth with stable margins; asset-quality deterioration; sudden funding withdrawal; regulatory change. Adversarial evidence to check first: New York Fed findings that tri-party repo margins were relatively stable for many borrowers in 2007–2009.
- **Minimum evidence.** A dated pre-crisis series of an actual margin (M7) and a pre-specified disturbance measure; segment kept separate (bilateral vs tri-party; internal target vs lender-imposed vs realized).
- **Stopping rule.** If no pre-crisis margin series is available from primary sources, the quantitative erosion claim stops; a qualitative assessment and a data-availability report are delivered instead.
- **Rejection.** H4 contradicted for a segment if its margins did not decline during calm, or if declines track exposure/asset mix rather than calm length.

### Case E — NASA Challenger and Columbia (Argument V, institutional analogue of V.3)

- **Claims tested.** H5: repeated successful operations despite known anomalies changed acceptance thresholds, reducing protective behavior without removing the hazard.
- **Viability.** Vehicle integrity through flight.
- **Mapping.** $`\pi`$: anomaly acceptance criteria and flight-readiness rules; $`O`$: authority structures for raising and acting on safety concerns; $`w`$: anomaly occurrences.
- **Mechanism and rivals.** Threshold change after success vs: persistent hazard with unchanged criteria; engineering-judgment failure; schedule pressure; communication failure.
- **Minimum evidence.** Dated changes in formal criteria or decision rules, with documented reliance on prior success as justification.
- **Classification.** Each documented decision classified under the control hierarchy with the stated evidence; severity 2 or 3 considered only if an organizational restriction removing corrective authority or capability is documented. No numerical $`k`$, $`L^*`$ or kernel membership.
- **Rejection.** H5 contradicted if criteria did not change and decisions followed unchanged criteria; not identifiable if changes cannot be dated or attributed.

## 6. Source policy

- Primary investigations, engineering documentation, regulatory records, contemporaneous reports and datasets first; secondary summaries only where primary evidence is inaccessible, and labeled.
- Every fact used carries a ledger entry (`SOURCE_LEDGER.md`): source, document, dates, URL, archive location, page/section, fact, confidence, limitations, and whether it is **contemporaneous** (available to decision-makers before the critical failure) or **retrospective**.
- Earlier informal case notes in this workspace (outside the repository) are not used as evidence.

## 7. Prediction test protocol

For a case with sufficient time-stamped data: build a snapshot from contemporaneous evidence only; compute M1, M2, M3, M5/M6 as available; freeze the snapshot and parameters in a dated file before comparing with post-event evidence; compare with the baselines in M9. Without comparison units, discrimination cannot be assessed and is reported as such.

## 8. Stopping and coverage

Phases follow the execution spec. A case whose records cannot support identification is closed with its negative or unidentifiable result rather than estimated. A coverage ledger records what was and was not completed.

## Amendments

(none)
