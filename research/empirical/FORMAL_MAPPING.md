# Formal mapping of the five cases into the existing framework

This file consolidates the mappings in the five case reports. It introduces no new formal object: every row instantiates I.3.1's state $`(x,O,\pi,q)`$, the disturbance $`w`$, the viability set $`\mathcal V`$ (A0), the class-indexed admissible actions $`\mathcal U_k`$ (I.3.3), and latencies $`\tau`$ (I.3.1, Argument III). Where a quantity is not documented it is symbolic or marked missing. A mapping is an interpretation. That the Lean proofs pass says nothing about whether any mapping below is historically correct.

Evidence codes: TF = U.S.–Canada Task Force (2004); NERC = NERC Technical Analysis (2004); S-codes refer to each case report's source table. Full citations are in the case reports and `SOURCE_LEDGER.csv`.

## 1. Mappings

### Case A — Boeing 737 MAX (`CASE_A_BOEING.md` §4)

| Object | Historical interpretation | Evidence | Uncertainty |
|---|---|---|---|
| $`x_t`$ | Aircraft controllability state in the MCAS failure condition (trim state, column force) | KNKT findings (S5 p.206) | KNKT read from a third-party mirror; no official copy obtained |
| $`O_t`$ | Design architecture (single-AOA MCAS input, authority 0.6→2.5°, repeat activation), certification basis (amended type certificate) | S1 pp.7, 11, 34; S5 p.196 | Date of the reset/repeat logic not documented |
| $`\pi_t`$ | Program decision rules: Level B training commitment, flight-deck change minimization | S2 pp.24, 139, 171 | Internal rule content summarized by the House report |
| $`q_t`$ | Development commitments; 2019–2020 remediation steps in progress | S2, S3, S4 | Per-step durations not documented |
| $`w_t`$ | A320neo competitive pressure; erroneous AOA input in service | S2 p.38; S5 | — |
| $`\mathcal V_x`$ | Safe controllability, operationalized by the 14 CFR 25.143 column-force limit | S5 p.206 | — |
| $`\mathcal U_k`$ | policy: procedures and training within the certified design; adapt: design changes with certification; phys: physically implementable changes (documented only) | case report §4 | Alternatives' feasibility at decision points mostly undocumented |
| $`\tau`$ | Remediation latency ≈ 20 months grounding-to-AD (total only) | S3, S4 | No per-step latencies |

### Case B — 2003 Northeast blackout (`CASE_B_BLACKOUT_2003.md` §5)

| Object | Historical interpretation | Evidence | Uncertainty |
|---|---|---|---|
| $`x_t`$ | Grid state of FE/Cleveland-Akron: line status and loading, 345-kV bus voltage, generation | TF pp.49, 64, 70 | Continuous trajectory only from post-event modelling |
| $`O_t`$ | Authorities (FE, MISO as reliability coordinator, PJM, AEP) and tools (FE EMS/alarms, MISO state estimator and contingency analysis) | TF pp.13, 20, 62 | — |
| $y_t$ (observation, I.3.1, I.3.8) | FE alarms frozen from 14:14; MISO state estimator out 12:15–16:04 | TF pp.49, 52–55, 62 | This is where most of the documented failure lies |
| $`\pi_t`$ | FE emergency procedures (including load shedding), 30-minute readjustment rule, TLR procedures | TF pp.62, 65–67 | Procedures summarized, not reproduced |
| $`q_t`$ | Troubleshooting and reboots in progress; TLR request | TF timeline | — |
| $`w_t`$ | Tree contacts at 15:05:41, 15:32:03, 15:41:35 (common-mode); Eastlake 5 trip | TF; NERC p.96 | — |
| $`\mathcal V_x`$ | No uncontrolled cascade; proxy: lines within emergency ratings and 345-kV voltage ≥ 95% | TF p.70 | 95% is a retrospective criterion (FE used 90%) |
| Robust set | N-1 security, read as the robust kernel against single contingencies | TF p.41; NERC p.100 | A mapping of an industry criterion, not a computed kernel (interpretation) |
| $`\mathcal U_k`$ | FE policy: manual shed, SCADA trips, redispatch; adapt: UVLS, more SCADA breakers, tool changes; MISO: directive, TLR; AEP/PJM: TLR, own redispatch | TF pp.62–67, 92 | — |
| $`\tau`$ | Documented: TLR 30–60 min; 30-min readjustment standard. Missing: FE time to shed 500–2,500 MW | TF pp.48, 62, 65 | The decisive latency is missing |

### Case C — CrowdStrike 2024 (`CASE_C_CROWDSTRIKE.md` §3)

| Object | Historical interpretation | Evidence | Uncertainty |
|---|---|---|---|
| $`x_t`$ | Endpoint state: operational, crashed, boot-looping, recovered | PIR (S1); Tech Alert (S5) | No device-level counts or timing |
| $`O_t`$ | Recovery capabilities: vendor revert and known-bad list (need a running, connected host); per-endpoint Safe Mode/WinRE; external boot media (from 20–22 July); VM tooling | S1, S5, S6, S8 | Default presence of WinRE not documented |
| $`\pi_t`$ | Release procedure (no staged rings for this content class); remediation guidance | RCA (S3) Finding 6 | — |
| $`q_t`$ | Content in distribution 04:09–05:27 UTC; remediation in progress | S1 | — |
| $`w_t`$ | None beyond the defective content | S3 | — |
| $`\mathcal V_x`$ | Endpoint boots and runs dependent services | pre-registration | — |
| $`\mathcal U_k`$ | fixed: release as executed; policy: revert, reboot advice, snapshot rollback; adapt: new tools, staged rings; phys: a remotely triggerable, key-free recovery environment is a labelled hypothetical | case report §3.4 | — |
| $`\tau`$ | Exposure window 78 min; time to recovery tools from ~9 h to ~4 days; fleet-level sensor figures only (>97% by 24 July, ~99% by 29 July) | S1, S5, S6d | Per-device recovery latency not documented |

### Case D — Financial crisis (`CASE_D_FINANCIAL_CRISIS.md`)

| Object | Historical interpretation | Evidence | Uncertainty |
|---|---|---|---|
| $`x_t`$ | Usable liquid resources and funding of a dealer or segment | SR477, SR506 | Crisis window only |
| $`\pi_t`$ | Margin or risk-limit rule (tri-party contractual margins; bilateral haircuts; VaR-based limits) | SR477 p.8; CGFS 36; SSG 2008 | — |
| $`q_t`$ | The rule's calm memory (look-back window) | CGFS 36 ("usually one year") | Only qualitative |
| $`w_t`$ | Volatility and funding shocks | — | **No pre-specified disturbance measure** (Amendment 2) |
| $`\mathcal V_x`$ | Meeting funding obligations without forced failure or emergency support | pre-registration | All tri-party observations sit under the PDCF |
| Margin series (M7) | **Missing before July 2008** in every primary source checked | SR477 fn.14; SR506; primary dealer statistics | Stopping rule applied |

### Case E — NASA (`CASE_E_NASA.md`)

| Object | Historical interpretation | Evidence | Uncertainty |
|---|---|---|---|
| $`x_t`$ | Vehicle integrity through flight | Rogers; CAIB | — |
| $`O_t`$ | Authority structures for raising and acting on safety concerns (flight readiness levels, Mission Management Team, imaging channels, clearances) | Rogers p.84; CAIB pp.152–154, 192 | — |
| $`\pi_t`$ | Anomaly acceptance criteria, written and as executed (erosion margin → "within our experience base"; foam: in-flight anomaly → turnaround issue → accepted risk → in-family → "action") | Rogers pp.132, 137–138, 147; CAIB pp.124–129 | Formal criteria unchanged or tightened; the change is in practice |
| $`w_t`$ | Anomaly occurrences (O-ring erosion; foam strikes) | Rogers; CAIB | Fatal disturbances only partly comparable to earlier ones (Challenger 36°F; CAIB p.146) |
| $`\mathcal V_x`$ | Vehicle integrity | — | — |
| $`\mathcal U_k`$ | policy: delay launch, request imagery, crew inspection; adapt: rescue mission, redesign | Rogers; CAIB pp.173–174 | Rescue viability documented only conditionally ("challenging but feasible") |
| $`\tau`$ | Rescue readiness by 10 Feb with 24/7 shifts; damage determination needed before Flight Day 7 (CAIB's stated conditions) | CAIB pp.173–174 | Conditions stated by CAIB, not estimated here |

## 2. Counterfactual consistency audit (every severity-3 candidate)

Severity 3 needs all four conditions of the pre-registration's Section 3. The table lists every candidate alternative in the five reports.

| Case | Candidate alternative | (a) viable and implementable then | (b) same disturbances and causal laws | (c) organizational restriction excluded it | (d) time, resources, authorization checked | Result |
|---|---|---|---|---|---|---|
| A | Two-AOA input / AOA disagree alert / EICAS / synthetic airspeed / simulator training (pre-accident) | partly documented as available; sufficiency not documented | not documented | not documented as external restriction; internal program directives only | no | not identifiable |
| A | Grounding after LNI610; 2019–2020 redesign | yes (executed) | yes | contradicted: within FAA authority | yes | **ruled out** |
| B | FE load shed 500–2,500 MW | modelled sufficient; time to execute not documented | yes (modelled on the actual sequence) | contradicted: FE held the authority and procedures | execution time missing | **ruled out** |
| B | MISO directive; AEP/PJM TLR or redispatch; reclosing lines | depends on FE / physically insufficient | — | not excluding / none | — | **ruled out** (fails on physics or authority) |
| C | Pre-provisioned, remotely triggerable recovery environment | not documented as available (labelled hypothetical) | — | not documented | no | not identifiable |
| C | Staged rollout, earlier halt | act on which hosts crash, not on recovery | — | not documented | no ring or detection timing | not identifiable |
| D | A more conservative margin policy | not documented as preserving viability | — | — | — | not identifiable |
| E | Columbia imaging / crew inspection → Atlantis rescue | conditional ("challenging but feasible", before Flight Day 7) | yes, as far as NASA's study goes | contradicted: within the deciders' authority | documented, conditional on (a) | **ruled out** |
| E | Challenger launch delay and pre-launch alternatives | within authority | — | contradicted | — | **ruled out** |

**No severity-3 classification is established in any case.** In every case where condition (c) could be evaluated, the record shows the protective alternative was within the authority of the actors who declined it. No invented or costless intervention was used.
