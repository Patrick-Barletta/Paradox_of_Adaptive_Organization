# Empirical results summary

**Design.** Retrospective hypothesis testing and historical prediction reconstruction of Arguments V and VI against five documented failures. The outcomes were known in advance, and the investigator knew them in general terms. Nothing here is a prospective or out-of-sample validation. The research questions, metrics, evidence grades and rejection criteria were frozen in `EMPIRICAL_TEST_PLAN.md` (commit `7ee5040`) before any case source was consulted. Three later amendments clarify labels and record a gap; none changes a claim, metric or rejection criterion.

**Method.** For each case:
1. one analyst extracted dated facts, with verbatim quotes and page references, from primary sources (304 ledger rows in `SOURCE_LEDGER.csv`);
2. a second, independent analyst re-downloaded the sources, verified the load-bearing facts (verification logs in `verification/`) and wrote the case report under the pre-registration;
3. the lead analyst checked each report against the pre-registration.

Load-bearing facts checked: A 29 (27 exact, 2 partial), B 42 (41 exact, 1 partial), C 21 (all exact), D 22 (20 exact, 1 partial, 1 not checked), E 20 (18 exact, 2 qualified). No fabricated quote or figure was found. Page and wording corrections are recorded in the logs and applied in the ledgers.

The four evidentiary levels are kept separate throughout:

**formal possibility → historical mechanism → causal identification → predictive validity.**

## Comparative table

| Case | Tested argument | Primary mechanism | Evidence grade | Formal severity | Main limitation |
|---|---|---|---|---|---|
| Boeing 737 MAX | V (Theorem V.2) / VI (Theorem VI.1) | Structural concession / serial accumulation | Concession (H1A): **partially supported**. Escape Ratchet (H1B): **not identifiable** (fails its minimum evidence, M2 = 0) | Not identifiable for pre-accident design states; **ruled out** after grounding (within FAA authority) | Consequential features trace to the hazard classification, not to cost; no per-step remediation latencies; KNKT read from a mirror |
| 2003 blackout | VI Part II | Shared dependencies, governance | Shared dependency (H2): **not identifiable**. Repeated-patching ratchet: **not applicable** (M2 = 0) | Severity 3 **ruled out** for every documented intervention; σ = 1 vs σ ∈ {2, 4} not identifiable | FirstEnergy's time to shed load is undocumented; the documented failure is in information, which both investigations prefer as the explanation |
| CrowdStrike 2024 | VI (abandonment, independent startup) | Abortability / independent recovery | Recovery independence (H3): **partially supported** for physical hosts; contradicted for VMs at the customer level | Not identifiable (no device-level timing; no organizational restriction documented) | No per-device recovery timing; all sources post-incident; recovery manuals behind a login |
| Financial crisis | V (Theorem V.3) | Calm-period margin erosion | Margin erosion (H4): **not identifiable** in every segment; quantitative test **stopped** (no pre-crisis margin series) | Not identifiable (even severity 1) | No primary pre-2008 margin data; measured tri-party margins were stable and the failure was a run |
| NASA | V (institutional analogue of V.3) | Institutional memory / threshold drift | Threshold drift (H5): **partially supported** for both programs, in practice only (no formal relaxation documented) | Severity 3 **ruled out** for the Columbia imaging/rescue path and Challenger decisions; 1 vs 2 not identifiable | Calm-length dependence not identifiable; relaxation followed survived anomalies, not calm; Challenger's fatal shock not comparable to earlier ones |

## The four levels by case

| Case | Formal possibility | Historical mechanism | Causal identification | Predictive validity |
|---|---|---|---|---|
| A | established by the theorems | H1A partly documented; H1B not documented | not reached | not assessable (no comparison units) |
| B | established | partly (partitioned authority, single effective owner, concurrent observer failures); no routine restriction documented | not reached; the situational-awareness rival is better supported | not assessable |
| C | established | partly (central halt; per-endpoint recovery) | incomplete (latency rival entangled) | not assessable (no contemporaneous sources) |
| D | established | not documented in the required form | not attemptable | not testable |
| E | established | partly, as practice drift | not reached | not feasible |

## Prediction test (Task 8)

No case met the pre-registered conditions for a prediction test: time-stamped contemporaneous data sufficient to compute the framework's indicators *and* comparison units for the baselines.

- **CrowdStrike:** every source was published after the incident.
- **Financial crisis:** no contemporaneous margin series exists.
- **Boeing, the blackout and NASA:** each has contemporaneous records, but there is a single failure per case and no panel of comparable non-failing units. The framework's indicators (M1, M3) cannot be computed from the record in any case.

**Predictive validity is therefore not established for any case.** No snapshot was built and then scored, so no claim of additional predictive discrimination over simple baselines is made.

## Five questions

**1. Which mechanisms are observable in historical records?**
- *Structural concessions* (Boeing): dated near-term-benefit choices with a persistent capability dependency.
- *Experience-based drift in executed acceptance thresholds* (NASA): explicit, dated reliance on prior success.
- *Central control of distribution without central recovery* (CrowdStrike, physical endpoints).
- *Partitioned authority with a single effective owner* (blackout).
- Not observed: accumulating serial recovery prerequisites (the Escape Ratchet), and calm-conditioned erosion of measured margins.

**2. Which mechanisms have enough evidence for causal testing?** None reached causal identification. The closest is the CrowdStrike exposure-window effect on *which* endpoints crashed, which is documented (an earlier halt shrinks the affected set) but is not the hypothesis's recovery claim. In every case the pre-registered rivals remain at least as well supported.

**3. Which findings contradict or narrow the theory's proposed applications?** (`FALSIFICATION_RESULTS.md` §3)
- The Escape Ratchet was not found in either case where it was tested.
- No severity-3 lock-in is established in any case: the protective alternatives were within the deciders' authority.
- Information failure (the blackout) sits outside the class hierarchy except through I.3.8's observation layer.
- Independent recovery is not central recovery: the model's one-step seed has no per-unit cost, and per-unit cost is the binding constraint in CrowdStrike.
- NASA's mechanism is relaxation after survived anomalies, not after calm.
- Calm-period erosion is untestable on public financial data, and where margins are measured they were stable.

**4. Can the framework identify loss of adaptive reachability before visible operational failure?** **Not on this evidence.** The framework can state, case by case, what would have to be measured: decision-point latencies, deadlines, and who held authority over each action. The historical records rarely contain those quantities. The decisive one is usually missing, for example FirstEnergy's time to shed load or per-device recovery time. Where the record is rich (NASA, Boeing), the protective actions were within the organization's authority, which places the failures at severity ≤ 2 rather than lock-in. The framework's distinctive prediction, organizational lock-in while physical recovery remains possible, was not observed in any case.

**5. What would need to be measured in Everfall Spiral or ArcWake for a decisive predictive test?** Both environments allow the quantities the historical records lack to be logged prospectively, with comparison runs:
- **Latency of every admissible action** at each decision point: worker reassignment and retraining in Everfall; restoration, switching and load-shedding times in ArcWake.
- **Deadlines:** the time from each disturbance to loss of viability, under each class.
- **The four class-indexed admissible sets:** which actions the incumbent rules allow, which need a policy revision, which need a capability change, and which are only physically possible. This makes $`\mathcal K_k`$ computable rather than inferred.
- **Serial dependency structure and its history:** for ArcWake, the restoration dependency graph and each change that adds a mandatory sequential step (M2) with dates; for Everfall, the prerequisite chains of capabilities.
- **Observation channels:** what each controller observes, so information failures (the blackout's mode) can be separated from class restrictions.
- **Per-unit recovery cost:** for ArcWake, per-node restoration effort, so independent but per-unit recovery (CrowdStrike's mode) can be represented.
- **A frozen prediction protocol:** compute $`t^*_k`$, $`\mu`$ and σ from logged state before each disturbance, freeze them, and score against outcomes across many runs, against baselines (output, reserves, redundancy count, recent recovery success). Many runs supply the comparison units no historical case has.

## Coverage ledger

| Item | Status |
|---|---|
| Pre-registration (Task 0) | done; frozen at `7ee5040`; three dated amendments |
| Source ledger | done; 304 rows; all `evidence_group` values per fact |
| Case reports A–E (Tasks 1–5) | done; each with a verification log |
| Formal mapping and counterfactual audit (Task 6) | done (`FORMAL_MAPPING.md`) |
| Falsification and negative controls (Task 7) | done (`FALSIFICATION_RESULTS.md`) |
| Prediction test (Task 8) | not feasible in any case (reasons above) |
| Computational models | none built. No case supplied the latencies or series a kernel computation would need; building one would require invented parameters, which the protocol forbids |
| Not obtained | official KNKT copy (mirror used); Ethiopian 302 final report; NERC detailed modelling and restoration reports; CrowdStrike recovery manuals behind a login; Rogers Vol. 2 (Feynman appendix); capital and liquidity buffer series |
| Unresolved source conflicts | listed in each case report's limitations section |

No Lean proof or saved result was changed. The empirical material lives under `research/empirical/`, with `MANIFEST.txt` listing a SHA-256 hash for every file. `code/build_ledger.py` rebuilds the merged ledger and the manifest.
