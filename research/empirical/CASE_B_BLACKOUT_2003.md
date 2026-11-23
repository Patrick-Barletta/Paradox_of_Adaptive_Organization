# Case B: August 14, 2003 Northeast blackout

> **Review.** Drafted by a second analyst independent of the evidence extraction, and checked by the lead analyst on 2026-11-22 against the frozen pre-registration (`EMPIRICAL_TEST_PLAN.md`). Severity labels follow Amendment 1 ("ruled out" when a necessary condition is contradicted by evidence, "not identifiable" when evidence is missing). The verification log is `verification/caseB_verification.md`; the evidence extraction is `evidence/caseB_blackout_evidence.md`.

**Status:** written by the second, independent analyst under the frozen pre-registration (`research/empirical/EMPIRICAL_TEST_PLAN.md`, amendments 1–3 applied at review). Retrospective hypothesis testing only. Outcome known in advance.
**Hypotheses:** H2 (Theorems VI.3–VI.5 setting, with Argument III's timed reachability). Theorem VI.4 ratchet sub-test, conditional on M2.
**Sources:** TF2004 = U.S.-Canada Power System Outage Task Force, *Final Report* (April 2004). NERC2004 = NERC Steering Group, *Technical Analysis of the August 14, 2003, Blackout* (July 13, 2004; Wayback 2022-05-25 copy). Page numbers are printed footer pages. Every quotation used here was re-checked against a fresh download (`verification/caseB_verification.md`: 41 verified, 1 partly verified, 0 contradicted).
**Tags:** C = contemporaneous (available to at least one operating organization on Aug 14 before ~16:06). R = retrospective (established by the investigation).

---

## 1. Scope and the four evidentiary levels

**Scope.** The interval from 12:12 EDT to the 16:05:57 Sammis-Star trip, which TF2004 calls "the last point at which a cascade of line trips could have been averted" (p.73). The cascade (16:05:57–16:13) and restoration are covered only where they bear on tests (4) and (5). Viability $`\mathcal V`$ follows the pre-registration: bulk system within thermal, voltage and stability limits, with no uncontrolled cascade.

| Level | Finding for this case |
|---|---|
| 1. Formal possibility | Established by the theorems (VI.3–VI.5; Argument III Demonstration III.C), not by this case. Nothing here bears on it. |
| 2. Historical mechanism | **H2 partly.** Documented: a multi-organization system with partitioned authority (TF p.13, p.20, p.62); one organization (FE) held the only effective control (TF p.63, p.70); parallel monitoring channels failed at the same time for distinct reasons (TF pp.49, 52-55). **Not documented:** a fixed routine at one organization that restricted others' viable actions; a shared serial recovery chain with owned segments; any dated serial-increment intervention (M2 = 0). |
| 3. Causal identification | **Not achieved for H2.** Both primary investigations explain inaction by lack of situational awareness (TF p.62, p.67; NERC pp.94-97). H2's distinctive component (routine restriction) does not survive this rival as a separate mechanism (Section 10). |
| 4. Predictive validity | **Not assessable.** No comparison units with contemporaneous indicators, and the framework indicators (M1, M3) cannot be computed (Section 11). |

---

## 2. Timed event table

All times are EDT, Aug 14, 2003. "Conflict" marks a documented discrepancy between or within sources.

| Time | Event | Source, page | Tag |
|---|---|---|---|
| 12:12:47 | Cinergy Bloomington-Denois Creek 230-kV trips; its status is not updated in MISO's state estimator (SE) | NERC p.36 | C |
| ~12:15 | MISO SE high-mismatch solution | TF p.48 | C |
| 12:40 (alt.) | MISO engineer "purposely disabled the automatic periodic trigger" ("All times are approximate") | TF p.136 | C. **Conflict** with p.48 |
| 13:00 / 13:07 | Good SE solution, then a real-time contingency analysis (RTCA) solution. The trigger is left off, and the analyst goes to lunch | TF p.48 | C |
| 13:13–13:28 | FE operator calls plants for voltage support | TF p.47 | C |
| 13:31:34 | Eastlake 5 (597 MW) trips | TF pp.48-49 | C |
| 14:02 | DPL Stuart-Atlanta 345-kV trips (tree). No significant electrical effect on FE | TF p.50 | Trip C. Effect R |
| 14:14 | FE alarm and logging software fails. Neither operators nor IT are aware | TF p.52 | Failure C. Unawareness R |
| 14:20–14:54 | FE remote consoles fail (14:20), primary server fails (14:41), backup fails (14:54). IT is auto-paged each time | TF p.52, p.54 | C (to IT) |
| 14:27:15/16 | Star-South Canton trips and recloses | TF p.52, p.63 | C (AEP). 1-s conflict |
| ~14:40 / 14:44 | MISO finds the SE is not on automatic, re-enables it, and the SE fails again | TF p.49, p.136 | C |
| 15:05:00 | System N-1 secure (800+ contingencies) | TF p.41 | R |
| 15:05:41 | Harding-Chamberlin 345-kV trips (tree) at 44% of rating | TF p.59 | Event C. Not recognized by FE or MISO (TF p.60) |
| 15:06–16:06 | "The FE system was not within single contingency limits" | NERC p.100 | R |
| 15:08 | FE IT warm-reboots the primary server. Alarms stay frozen | TF p.54 | Reboot C. Frozen state R |
| 15:10 | Earliest time the MISO flowgate tool *would have* flagged Star-Juniper, given correct topology | NERC p.97 | R (counterfactual) |
| 15:32:03 | Hanna-Juniper 345-kV trips (tree, witnessed) at 88% | TF pp.60-61 | C |
| ~15:33 / 15:35 | AEP identifies the Star-South Canton risk and asks PJM for a 350-MW TLR | TF p.55, p.57 (p.66 says AEP identified the overloads at 15:36) | C. Minor conflict |
| 15:36 | MISO calls FE about the Star-Juniper post-contingency overload | TF p.57 | C |
| 15:39:17 → | First of sixteen 138-kV lines fails | TF p.68 | C |
| 15:41:35 | Star-South Canton locks out at 93% of emergency rating | TF p.63 | C |
| 15:41 | MISO RTCA solves manually | TF p.49 | C |
| 15:42 | FE operator tells IT that the EMS is compromised. A cold reboot is discussed and declined (conditions "precarious", concern about "the length of time that the reboot might take") | TF p.65, p.56 | C |
| ~15:45 | FE recognizes the Star breakers are open. The shift supervisor tells his manager "it looked as if they were losing the system". No emergency is declared | TF pp.66-67 | C |
| ~15:46 | "the only way ... would have been to drop at least 1,500 MW ... it may already have been too late" | TF p.45 | R |
| 15:46–15:59 | Both FE EMS servers are down during reboot attempts | TF p.54 | C |
| ~15:50 | AEP and PJM find "no practical way to mitigate these overloads across utility and reliability coordinator boundaries" | TF p.66 | C |
| 15:48 / 15:56 | PJM calls MISO, then FE: Sammis-Star is in emergency overload. FE cannot confirm it and believes the problems are "beyond their system" | TF p.66 | C |
| 15:59:00 | West Akron 138-kV bus trips (breaker failure) | TF p.69 | C |
| 16:04 | MISO SE/RTCA back on full automatic (TF) | TF p.49 | C. **Conflict**: NERC p.97 says "until after the blackout" |
| 16:05:55 | Dale-West Canton 138-kV trips | TF p.69 | C |
| 16:05:57 | Sammis-Star 345-kV trips on low apparent impedance (zone 3). Last averting point | TF p.69, p.73, p.77 | Event C. Status as last averting point R |
| 16:10:45 | Northeast separates. "No human intervention occurred ... to effect this split" | TF p.90 | C/R |
| by 16:13 | >508 units at 265 plants lost | TF p.74 | R |

---

## 3. Timed dependency graph

Edges run from prerequisite (or source) to dependent. A dependency counts as **serial** only where the record shows it must complete before the next step can start (pre-registration §3).

| # | From → To | Type | Serial / parallel | Activation latency | Capacity | Control authority | Source |
|---|---|---|---|---|---|---|---|
| E1 | Harding-Chamberlin, Hanna-Juniper, Star-South Canton, Sammis-Star 345-kV paths → Cleveland-Akron supply | Physical | **Parallel** paths. Their failures were sequential: each loss raised loading on the others ("Cumulative Effects of Sequential Outages") | Line trips are physical events. Star-South Canton held 120% for 10 min before tripping | 44% / 88% / 93% emergency at trip. Sammis-Star >120% | FE (Harding-Chamberlin, Hanna-Juniper, Sammis-Star); Star-South Canton is an AEP/FE tie line (TF p.66) | TF pp.57-64, p.69 |
| E2 | 345-kV losses → 138-kV network loading | Physical | Sequential cascade, not a prerequisite chain | 15:39:17–16:05:55 | Sixteen 138-kV lines failed. Dale-West Canton at 160–180% | FE | TF pp.68-69 |
| E3 | Imports → FE load | Physical | Parallel (many interfaces) | n/a | 2,575 MW of 12,080 MW (21%) at 15:00 | FE / MISO / PJM | TF p.49 |
| E4 | Eastlake 5 → Cleveland-Akron voltage support | Physical | Parallel resource | n/a | 597 MW. With it modelled in service, all overloads above emergency were eliminated | FE | TF pp.48-49 (R) |
| E5 | FE SCADA → FE alarm processor → FE operator awareness | Informational | **Serial** (operators "relied heavily" on alarms, with no map board) | FE screen refresh slowed to 59 s (found in post-event testing, R) | n/a | FE | TF p.52, p.54; NERC p.32 |
| E6 | Alarm failure → FE IT detection → IT-to-operator notification → operator alternate monitoring | Organizational / informational | **Serial** (NERC Causes 1a–1c). No formal IT-to-operator procedure | ≥40 min (14:14–14:54) during which IT was unaware (NERC pp.95-96) | n/a | FE (IT and operations) | TF p.54; NERC p.95 |
| E7 | SCADA/line status → MISO SE → MISO RTCA | Informational | **Serial** ("operates only if the state estimator solves") | SE cycle 5 min when on automatic. Out of service 12:15–16:04 (TF) | n/a | MISO | TF pp.47-49; NERC p.97 |
| E8 | Neighbor line status (Cinergy, DPL) → MISO SE | Informational | Serial input. Automatic linkage "had not yet been established" | Manual: voice confirmation with PJM 15:29–15:33 | n/a | MISO; data owners Cinergy, DPL | TF p.48, p.49, p.57 |
| E9 | NERC SDX → MISO flowgate tool | Informational | Serial input; not real-time | "no current requirement for how quickly" status is reported | n/a | Asset owners; NERC | TF p.51; NERC p.97 |
| E10 | FE EMS data → MISO, AEP, PJM computers | Informational | **Parallel** channels (independent observers) | Real-time. Continued after FE alarm failure | n/a | FE (sender) | TF p.53, p.67 |
| E11 | MISO breaker alarms → MISO operator recognition | Informational | Serial. A look-up is needed; the topology processor was not linked | Missed. Harding-Chamberlin found "that evening" | n/a | MISO | TF p.55, p.60 |
| E12 | AEP contingency analysis → AEP/PJM recognition | Informational | Parallel observer | ~15:33/15:36 | Covered lines into Star but not "enough lines within the FE system" | AEP / PJM | TF p.55, p.62 |
| E13 | Identify emergency → determine action → execute | Organizational | **Serial** ("must first identify ... and then determine effective action") | Not documented | n/a | Executing control area | TF p.66 |
| E14 | FE decision → FE load shed (Cleveland-Akron) | Physical / organizational | Serial (execution) | **Not documented.** Few SCADA load breakers; rotation "requires calling personnel out" | Required: 500 MW before 15:41; 1,500 MW before 16:05:57 (TF); 2,000 after 15:41:35 or 2,500 after 15:59 (NERC) | **FE** (control area authority, NERC Policy 5) | TF p.62, p.64, p.66, p.70; NERC p.100 |
| E15 | MISO directive → FE execution | Organizational | **Parallel trigger**, not a prerequisite: FE could act on its own authority. A directive only adds a trigger path, and execution remains FE's | Not documented | n/a | MISO (RC), but without contractual authority over FE on Aug 14 | TF p.20, p.62 |
| E16 | AEP request → PJM TLR → schedule change | Organizational | Serial | 30–60 min after issue | 350 MW requested. "little impact" (IDC, R) | PJM / AEP | TF pp.62-63 |
| E17 | Generation redispatch → line relief | Physical | Parallel option | Must work within 30 min (standard) | "would not have solved the overload problem" (R). FE had no redispatch resources within 30 min | FE / MISO | TF p.70; NERC p.99 |
| E18 | Reclose Harding-Chamberlin / Hanna-Juniper → 138-kV relief | Physical | Parallel option | Not documented | "In theory" sufficient, but "unlikely" to succeed (tree-compromised) | FE | TF p.70; NERC p.95 |
| E19 | Under-voltage load shedding (UVLS) → automatic shed | Physical | Would be an independent path | "several second delay" (generic design) | **Not installed** in Cleveland-Akron. "not mandatory" | Control area / reliability council option | TF p.92, p.19 |
| E20 | Western NY island (Niagara, St. Lawrence hydro) → NY and Ontario restoration | Physical (restoration seed) | Independent seed | Not documented | ~5,700 MW island | NYISO / Ontario (not detailed) | TF p.100, p.163 |

**Structure.** The physical supply is a set of **parallel** paths that were eroded one after another (E1–E2), not a serial chain. The documented **serial** chains are informational (E5–E9, E11) and the generic identify → decide → execute sequence (E13–E14). The one effective execution edge (E14) belongs to a single organization. Other organizations reach it only through informational or trigger edges (E10–E12, E15) or through actions documented as physically insufficient (E16–E18). The VI.8 structure, in which several agents each own one *segment* of a single serial recovery chain, **is not instantiated**. The documented structure is one executing owner with several parallel observers.

---

## 4. Governance map

| Organization | Role on Aug 14 | Authority over the decisive action (Cleveland-Akron load shed) | Other actions within authority | Documented limits |
|---|---|---|---|---|
| FirstEnergy (FE) | Control area; owns the lines and load | **Held.** NERC policy gives "the responsibility and the authority to take actions up to and including emergency generation redispatch and shedding firm load" (TF p.62). FE "did not exercise the authority" (TF p.21). Written procedures included tripping firm load (TF p.67) | Redispatch, reclosure, voltage support | Means: few SCADA load breakers, rotation by field personnel (TF p.66); no automatic schemes (TF p.70); "did not have an adequate load reduction capability, whether automatic or manual" (NERC pp.99-100); no redispatch resources within 30 min (NERC p.99); procedures "did not prepare it adequately" (TF p.67); no backup control facilities (NERC p.100, evacuation context) |
| MISO | FE's reliability coordinator (RC) since Feb 1, 2003 (NERC p.8) | **Directive only, contractually incomplete.** "MISO did not have the necessary authority as FE's Reliability Coordinator" (TF p.20). Yet it "nevertheless should have issued directives to FE" (TF p.20) | TLRs, congestion management (TF p.67) | "less reliability-related authority over its control area members than PJM" (TF p.14). "lacked clear visibility, responsibility, authority, and ability" (TF p.67). Delegated oversight to members (NERC p.98) |
| AEP | Control area adjacent to FE; RC is PJM (TF p.13) | **None** over FE load | TLR requests, own redispatch | Its own contingency analysis did not cover enough FE lines (TF p.62) |
| PJM | AEP's RC | **None** over FE load | TLR | No PJM-MISO seam procedure (Violation 6, TF p.20). "no practical way to mitigate ... across ... boundaries" (TF p.66) |
| NERC | Standards body | None (no enforcement authority, TF p.17) | n/a | n/a |

Across the system: the entities lacked "a common understanding of the functions, responsibilities, capabilities, and authorities of reliability coordinators and control areas" (TF p.158; NERC p.98). After the event, NERC required MISO to "verify its authority to ... direct actions during system emergencies, including shedding load" (TF p.153, R). It also required a 1,500 MW / 10-minute capability that either "MISO or the FE system operator" could trigger (TF p.151, R).

---

## 5. Formal mapping

| Symbol | Mapping | Evidence | Uncertainty |
|---|---|---|---|
| $`x`$ | Grid state of the FE/Cleveland-Akron area and its ties: line status, loading (% of rating), bus voltages (Star 345-kV: 91.7% before 15:41, 90.8% before 16:05:57), generation (Eastlake 5 out), imports | TF p.49, p.64, p.70 | High for documented snapshots. Continuous trajectory only from modelling (R) |
| $`\mathcal V`$ | No uncontrolled cascade. Operational proxy: lines within emergency ratings and 345-kV bus voltage at or above the 95% minimum the TF judged appropriate | TF p.70 | The 95% figure is a retrospective criterion (P-V/V-Q studies, TF pp.33-37). FE's own criterion was 90% (TF p.39) |
| Robust set $`\mathcal K^{\mathrm{rob}}`$ | **N-1 security** is the industry's robust-viability notion against the disturbance set {any single contingency}. Secure at 15:05 (TF p.41). Not secure 15:06–16:06 (NERC p.100) | TF p.41; NERC p.100 | This is a mapping of an existing criterion, not a computed kernel |
| $`O`$ (per agent) | Authority (Section 4); tools: FE EMS, alarms, manual CA; MISO SE/RTCA/flowgate tool/SDX; AEP CA. Coordination: no seam procedure; mismatched Sammis-Star ratings (FE 1,310/1,310 MVA vs 950/1,076 MVA, TF p.72 n.44) | as cited | High |
| $`y`$ (observation) | FE: alarm-based, frozen from 14:14. MISO: SE/RTCA out 12:15–16:04, alarms missed. AEP/PJM: partial CA coverage | TF pp.49, 52-55, 62 | High. **This layer carries most of the documented failure** |
| $`\pi`$ | FE written emergency procedures and yearly load-shed plan geared to energy shortages ("emergency awareness is often focused on energy shortages", TF p.66). 30-min readjustment rule (TF p.65). TLR procedures (TF p.62). MISO practice of asking FE to name critical facilities (NERC p.100) | as cited | Medium. The procedures' content is summarized, not reproduced |
| $`q`$ | MISO SE troubleshooting (12:15–16:04); FE IT reboots (15:08, 15:46–15:59); AEP's TLR request (15:35); FE voltage-support calls | Section 2 | High |
| $`w`$ | Tree contacts (15:05:41, 15:32:03, 15:41:35); Eastlake 5 trip; Cinergy and DPL outages (which disturb MISO's $`y`$, not FE's $`x`$); load and temperature. Alarm software failure (14:14) acts on FE's $`O`$/$`y`$ | Section 2 | Tree contacts are common-mode, not independent (NERC p.96) |
| $`\mathcal U_k`$ | See below | | |
| $`\tau`$ | Documented: TLR 30–60 min; 30-min readjustment standard; UVLS several-second delay (not installed); SE cycle 5 min. **Not documented:** FE time to shed 500/1,500/2,000/2,500 MW; MISO directive latency; cold reboot duration | TF pp.48, 62, 65, 92 | Execution latency of the decisive action is missing |

**Agents and classes (the joint-system reading of VI.8).**

| Agent | Class on Aug 14 | Fixed (as executed) | Policy (existing authority and tools) | Adapt (tools, authority, coordination changes) | Phys |
|---|---|---|---|---|---|
| FE | Decisive owner | No shed, no emergency declaration (TF p.67, p.70) | Manual shed by its plan, SCADA trips where available, emergency redispatch, reclosure | UVLS, more SCADA load breakers, backup control centre, 10-min capability: all post-event or not documented as possible within the day | Any physically executable shed within latency. Faster means are **not documented** |
| MISO | Partner (monitor, directive) | Troubleshoot SE. Call FE at 15:36 about a contingency overload | Directive to FE (TF says required); TLR | Contractual authority over FE (FE joined Oct 1, 2003, NERC p.8) | Same actions; no physical control of FE load |
| AEP / PJM | Partners | TLR request (15:35), calls to FE and MISO | TLR, own redispatch | Seam procedure (post-event) | No effective action: TLR "little impact", redispatch alone insufficient (R) |
| Adversaries | **None documented** | | | | |

Mapping to VI.8 roles: there is no seed stage, no segment depth $`n`$, no patch/prune choice, no crisis index and no vote. The only VI.8 premise the case instantiates is **segment ownership**: the only effective intervention lies in FE's segment, and "Agents could prune each other's segments" is false here as well (VI.12). FE's documented behavior is **not** a fixed routine in the $`\mathcal U_{\mathrm{fixed}}`$ sense, because its written policy prescribed shedding (TF p.67). The record places the failure in $`y`$: FE "did not know for most of that time" (TF p.67), and even at 15:56 it "believed that the problems existed beyond their system" (TF p.66). In the framework's terms this is the information layer of I.3.8, $`\mathcal K^{y}\subseteq\mathcal K^{\mathrm{full}}`$, not a class restriction.

---

## 6. Kernel classification at stated times

Notation: $`\tau_{\mathrm{FE}}(Q)`$ is the time FE needed to shed $`Q`$ MW in Cleveland-Akron on Aug 14 (**undocumented**). $`\tau_{\mathrm{rec}}(t)`$ is the time from $`t`$ to a decision to act (on the actual path, FE recognized trouble ~15:45 and never declared an emergency). Deadlines and quantities come from the sources. Window lengths are arithmetic on documented timestamps. Classification uses the **full-information** kernel $`\mathcal K^{\mathrm{full}}_{\mathrm{policy}}`$ (could a policy-class action have saved the system?). The observed-information kernel $`\mathcal K^{y}`$ is discussed separately.

| Decision time | State (documented) | Documented sufficient intervention and deadline | Who could execute / direct | Window | Classification |
|---|---|---|---|---|---|
| 15:05:00 | N-1 secure (TF p.41) | None needed against single contingencies. On the realized path (three common-mode tree contacts), the documented option is ≥500 MW before 15:41 (TF p.64) | FE / MISO directive | to 15:41:35: 36 min 35 s | $`\in\mathcal K^{\mathrm{rob}}`$ (N-1 sense). On the realized path: in $`\mathcal K^{\mathrm{full}}_{\mathrm{policy}}`$ **iff** $`\tau_{\mathrm{FE}}(500)\le`$ 36 min 35 s. **Not identifiable** |
| 15:06 (after 15:05:41) | In $`\mathcal V`$ ("All lines were loaded within normal limits", TF p.70). Not N-1 secure (NERC p.100). Readjustment required within 30 min (TF p.65). No redispatch resources (NERC p.99) | ≥500 MW before 15:41 prevents the Sammis-Star trip, "not clear" for Star-South Canton (TF p.64) | FE / MISO directive | ~35 min 54 s to 15:41:35. NERC: even 30 min was inadequate, since the next trip came after 27 min (NERC p.46) | $`\notin\mathcal K^{\mathrm{rob}}`$ (N-1). $`\in\mathcal K^{\mathrm{full}}_{\mathrm{policy}}`$ iff $`\tau_{\mathrm{FE}}(500)\le`$ ~35.9 min. **Not identifiable** |
| 15:32:03 | Star-South Canton and three 138-kV lines above normal (TF p.70) | ≥500 MW before 15:41 (TF p.64), or 1,500 MW before 16:05:57 (TF p.70) | FE / MISO | 9 min 32 s to 15:41:35; 33 min 54 s to 16:05:57 | iff $`\tau_{\mathrm{FE}}(500)\le`$ 9.5 min **or** $`\tau_{\mathrm{FE}}(1500)\le`$ 33.9 min. **Not identifiable** |
| 15:41:35 | Star-South Canton locked out | 2,000 MW after this point (NERC p.100); 1,500 MW before 16:05:57 (TF p.70) | FE / MISO | 24 min 22 s | iff $`\tau_{\mathrm{FE}}(Q)\le`$ 24.4 min, with $`Q\in[1500,2000]`$ depending on the source. **Not identifiable** |
| ~15:46 | FE recognizes "losing the system" (~15:45, TF p.67). FE, MISO and neighbors "had begun to realize" (TF p.45) | "at least 1,500 MW". "it may already have been too late" (TF p.45) | FE (MISO could direct) | ~19 min 57 s | iff $`\tau_{\mathrm{FE}}(Q)\le`$ ~20 min, $`Q\ge1500`$. The TF itself hedges. **Not identifiable** |
| 15:59:00 | West Akron bus failure | 2,500 MW after this point (NERC p.100). TF p.70's 1,500 MW "before that outage" does not state when shedding would start | FE | 6 min 57 s | iff $`\tau_{\mathrm{FE}}(2500)\le`$ ~7 min (NERC basis). **Not identifiable.** Sources conflict on $`Q`$ |
| 16:05 | Dale-West Canton trips at 16:05:55 | Same | FE | ≤57 s | iff $`\tau_{\mathrm{FE}}(Q)\le`$ 57 s. Not identifiable numerically. No source documents a sub-minute shed capability |
| 16:05:57+ | Sammis-Star tripped | None: "the possibility of averting ... ended" (TF p.70). A cascade "cannot be stopped by human intervention once started" (TF p.73). Separation schemes "would have been ineffective" (TF p.92) | — | 0 | $`\notin\mathcal K_{\mathrm{phys}}`$ for documented interventions (σ = 4 as documented, R) |

**Bounds that are documented.** $`t^*_{\mathrm{policy}}\le t^*_{\mathrm{phys}}\le`$ 16:05:57 (nesting plus TF p.70, p.73). No lower bound on $`t^*_{\mathrm{policy}}`$ is documented, because $`\tau_{\mathrm{FE}}`$ is missing. NERC's finding that FE "did not have an adequate load reduction capability, whether automatic or manual" (NERC pp.99-100) sits next to the 30-minute restoration standard. That placement is *consistent with* $`\tau_{\mathrm{FE}}`$ exceeding the window, but NERC gives no figure. Treating it as a bound would be an inference (Low confidence), and it is not used.

**Observed-information layer.** Up to ~15:45 FE's observation $`y`$ did not show that action was needed (TF p.67). MISO's SE/RTCA were out of service (TF p.49) and its alarms were missed (TF p.55). So for 15:05:41–~15:45, any state in $`\mathcal K^{\mathrm{full}}_{\mathrm{policy}}`$ would lie in $`\mathcal K^{\mathrm{full}}\setminus\mathcal K^{y}`$ for FE and MISO: informational, not organizational, lock-in. After ~15:45 FE's $`y`$ partly showed the problem, yet FE still misattributed it at 15:56 (TF p.66).

---

## 7. Formal tests and metrics

**(1) Did the system admit a jointly viable intervention before the cascade?** *Statically yes, timed not identifiable.* Retrospective modelling documents sufficient load-shed quantities (TF p.64, p.70; NERC p.100). Their execution within historical constraints is undocumented (Section 6). Redispatch, TLR and line reclosure are documented as insufficient or unlikely (TF pp.62-63, p.70).

**(2) Did one organization's routine restrict viable actions for others?** *No (as documented).* Only one organization (FE) held an effective action. Others' actions failed on **physics** (TLR "little impact", redispatch insufficient: TF p.63, p.70), not because FE's routine restricted them. FE's EMS failure did not blind others: its data kept flowing to MISO, AEP and PJM (TF p.53, p.67). The weaker structural claim *is* documented: in this single crisis, joint viability depended on FE's action whatever the others did (TF p.63: "The only way ... would not have been from the redispatch that AEP requested, but rather from significant load-shedding by FE"). That is a single-crisis analogue of VI.4(a)'s "whatever the others do". It comes from segment ownership, not from a patching routine.

**(3) Did coordination or authority constraints exclude an otherwise feasible intervention?** *Not established.* Two constraints are documented: MISO's missing contractual authority (TF p.20) and the absent PJM-MISO seam procedure (TF p.20). Neither is shown to have excluded a feasible action:
- MISO's directive was still required by NERC policy (TF p.20), its execution would have rested with FE (E15), and MISO did not know enough to issue one (TF p.62).
- The cross-seam actions available to AEP/PJM were physically insufficient (TF p.63).

**(4) Was there a documented independent recovery or control capability?**
- *Prevention:* none. There was no UVLS in Cleveland-Akron, and UVLS was optional (TF p.92, p.19). FE had no backup control facilities (NERC p.100).
- *Observation:* parallel channels existed (MISO, AEP, PJM received accurate FE data, TF p.53) but failed concurrently for distinct reasons (E7–E12).
- *Restoration:* yes. The western NY island was "the basis for restoration in both New York and Ontario" (TF p.100), and the ability to energize from neighbors sped recovery (TF p.163). This is an independent seed, but it is post-collapse and outside the H2 test window.

**(5) Does timed analysis change the static conclusions?** *Yes, in direction, but the change cannot be quantified.* Statically, a policy-class action (FE load shed) reaches $`\mathcal V`$ throughout 15:05:41–16:05:57. Timed analysis adds three things:
- serial stages (recognize → decide → execute, TF p.66);
- a required quantity that rises over time (500 → 1,500/2,000 → 2,500 MW; TF p.64, p.70; NERC p.100; "grew rapidly", TF p.70, NERC p.52);
- a fixed deadline of 16:05:57.

This is Argument III's structure (closure membership is a screen, not a schedule). The TF's own hedge, "it may already have been too late" at 15:46 (p.45), is a timed caveat on a static finding. Whether timing actually flips membership at any given time is **not identifiable** without $`\tau_{\mathrm{FE}}`$.

**M1 (serial recovery latency).** Not documented. Symbolically $`M_1(t)=\tau_{\mathrm{rec}}(t)+\tau_{\mathrm{dec}}+\tau_{\mathrm{FE}}(Q(t))`$, with all three terms undocumented on Aug 14. Post-collapse restoration latency is also not identifiable: NERC deferred the analysis (NERC p.5), and the durations conflict (TF p.1 vs NERC p.1).

**M3 (remaining margin).** $`M_3(t)=(\text{16:05:57}-t)-M_1(t)`$. Only the first term is documented (windows in Section 6). Not identifiable.

**M5 (joint viable intervention).**
- Documented as statically sufficient: shed of 500 MW (before 15:41), 1,500 MW (before 16:05:57, TF), or 2,000/2,500 MW (NERC).
- Authority: **FE** held it, unrestricted (TF p.62, p.21, p.67). MISO held a directive role without contractual authority (TF p.20). AEP and PJM held none.
- Executability within historical constraints: **not established**.

**M2 (serial dependency increments, ratchet).** **0 documented.** Candidates examined, none qualifying:
- Manual contingency analysis "since ... 1995" (TF p.71 n.7): undated within the period, and a discretionary step rather than a mandatory prerequisite to recovery.
- EMS patches (TF p.55): "minor", with no count or dates.
- MISO becoming FE's RC on Feb 1, 2003 (NERC p.8): added a monitoring and directive layer but no mandatory prerequisite, since FE could shed on its own authority (TF p.62).
- Voltage criteria relaxed ~1998/1999 (TF p.39; NERC p.99): a margin reduction, not a serial step. It is more relevant to Argument V than to VI.

---

## 8. Grades

**H2: Not identifiable.**
- The pre-registered minimum evidence requires "a documented intervention with its execution time before the cascade". The execution time is not documented.
- The documented components lean toward the rival. The authority holder (FE) had authority and written procedures. Both investigations attribute inaction to not knowing (TF p.62, p.67; NERC pp.94-95). Other organizations were not restricted by FE's routine: their own options were physically insufficient.
- The pre-registered contradiction rule is **nearly met but not fully**:
  - "responsible organization had authority": met (TF p.62).
  - "failure explained by not knowing": met (TF p.62, p.67).
  - "had ... tools to execute a sufficient intervention": contested. TF p.66 notes few SCADA breakers; NERC pp.99-100 finds no adequate capability.
  - "no restriction on others' actions": formally fails, because MISO's authority gap is documented (TF p.20), though it is not shown to be causally operative.
- If future evidence documented that FE could have shed the required load in time, the rule would be met and H2 would be **contradicted** for this case.

**Theorem VI.4 ratchet: not testable (not applicable).** M2 = 0. No dated intervention is documented as adding a mandatory sequential prerequisite (TF p.55 calls the patches "minor"; neither report frames prior changes as adding steps). As the case spec requires, the case is reclassified as **a test of shared dependencies and operational control**. Under that reclassification the finding is a single-owner control structure with parallel, concurrently failed observers, with the failure located in the information layer.

---

## 9. Severity (pre-registration §3)

**Severity 3: ruled out for every documented candidate intervention.** Overall σ at the decision points is **not identifiable** between σ = 1 and σ ∈ {2, 4}. The checks behind this:

| Candidate | (a) physically viable, implementable with time available | (b) viable under same disturbances and response laws | (c) documented organizational restriction excluded it | (d) time / resource / activation / authorization checked | Result |
|---|---|---|---|---|---|
| FE load shed (500/1,500/2,000/2,500 MW) | Modelled sufficient (R). Implementability in time **not documented** | Yes: modelled on the actual outage sequence (TF p.64, p.70) | **Contradicted**: FE held authority (TF p.62, p.21) and its procedures included shedding (TF p.67) | Execution time not documented | Not severity 3. The action lies in $`\mathcal U_{\mathrm{policy}}`$ → σ = 1 iff timed-feasible |
| MISO directive to FE | Depends on FE execution (above) and on MISO knowing (it did not, TF p.62) | As above | Restriction documented (TF p.20) but **not excluding**: the TF says MISO should have directed anyway (p.20), and FE could act without it | No | Not established. Failure sits in the information layer, not in organization |
| AEP/PJM TLR or redispatch | **No**: "little impact" / "would not have solved" (TF p.63, p.70) | — | Seam restriction documented (TF p.20) | TLR 30–60 min (TF p.62) | Fails (a). Physical insufficiency, not lock-in |
| Reclose Harding-Chamberlin / Hanna-Juniper | "In theory" sufficient but "unlikely" (TF p.70) | No: tree-compromised lines | None documented | No | Fails (a) and (c) |
| UVLS / 10-min capability | Not in place on Aug 14 (TF p.92; p.151 is post-event) | — | UVLS optional (TF p.92): an absence of a requirement, not an exclusion | Installation latency not documented | Hypothetical adapt move. Cannot support a classification |

Branch logic:
- If $`\tau_{\mathrm{FE}}(Q(t))`$ fit the window at a decision point, the state was in $`\mathcal K_{\mathrm{policy}}\setminus\mathcal K_{\mathrm{fixed}}`$ (σ = 1, operational mismatch, with the gap in $`y`$).
- If it did not, the remaining options are capability changes with no documented in-day path (σ = 2 unsupported) or physical limits (σ = 4).
- σ = 3 would need a physically faster action that an organizational rule excluded. No such action or rule is documented: FE's authority covered all shedding in its area.
- A faster undocumented physical method (for example, opening transmission breakers by SCADA) is a **labeled hypothetical** only. It would itself be within FE's authority, so it would point to σ ≤ 1, not 3.

---

## 10. Competing explanations and negative controls

| Rival (pre-registered) | Evidence for | Evidence against | Assessment |
|---|---|---|---|
| Situational-awareness failure | TF Cause group 2; NERC Group 1 (FE awareness) and Group 3 (RC diagnostics). "because they either did not know or understand enough" (TF p.62). "did not fully piece these clues together until ... only minutes before" (TF p.67) | After ~15:45 FE partly knew (TF p.67) but did not act. This residual is attributed to procedures and training (TF p.67: procedures "did not prepare it adequately"; "Neither group of operators had significant training ... for ... an emergency of this type") and to capability (NERC pp.99-100) | **Best supported.** Explains the 14:14–15:45 interval fully and the residual partly |
| Protection-system behavior | Sammis-Star tripped on zone 3, not a tree (TF p.69, p.77). Relays drove the cascade spread (TF p.73) | The TF says relays "operated as they were designed and set to behave" (TF p.92). Protection explains the spread after 16:05:57, not the failure to intervene | Explains the cascade, not pre-cascade inaction |
| Vegetation management | Common-mode tree contacts on three 345-kV lines (NERC p.96; TF Cause 3) | No prior tree-caused sustained outages on these lines 2001–2003 (TF p.58) | Explains $`w`$ (the disturbance), not the control failure |
| Tool failure without governance restriction | FE alarm failure (TF p.52), MISO SE failure (TF p.49), both independent of governance | MISO's tool gap is partly organizational (immature tools, unlinked topology, SDX dependence: TF p.48; NERC p.97) | Strong. Overlaps with situational awareness |
| H2 shared-dependency restriction | Single owner of the effective action (TF p.63). MISO authority gap and seam gap (TF p.20). Concurrent failure of redundant observers | No restriction shown to exclude a feasible action (Section 7(3)). FE's policy as written would have acted | Not distinguishable from the rivals |

**Negative controls (documented).**
- PJM, New York and ISO-New England "had already set up the system to maintain higher voltage levels and therefore had more reactive reserves on-line". Long lines tripped quickly "and split the grid between the sections that blacked out and those that recovered" (TF pp.91-92). The split came from "natural breaks in the system and automatic relay operations" with "No human intervention" (TF p.90).
- The western NY island survived and anchored restoration (TF p.100).

These contrasts point to **voltage/reactive margin and network topology** as discriminators between areas, not to governance structure. NPCC's standing 10-minute manual load-shedding criterion since 1965 (TF p.93) is a documented contrasting procedure in another region. Whether it was ever exercised on Aug 14 is not documented, so it cannot serve as a controlled comparison.

---

## 11. Prediction test feasibility

**Not feasible at level 4.**
- No set of comparison units (other control areas or other days) has the same contemporaneous indicators.
- The framework's indicators (M1, M3) cannot be computed even for the failing unit, because $`\tau_{\mathrm{FE}}`$ is undocumented.
- A contemporaneous snapshot (pre-14:14) could be assembled from documented items: AEP's May 21, 2003 finding of "probable cascading into voltage collapse" for nine double contingencies (TF p.39); FE's 90% voltage criterion against neighbors' 95% (TF p.39); Eastlake 4 out on Aug 13 and Eastlake 5 out at 13:31 (NERC p.100; TF p.48); imports at 21% (TF p.49). These are baseline-type indicators (reserves, redundancy, margin) under M9, not framework-specific ones, and with one unit no discrimination can be assessed.

---

## 12. Limitations and source conflicts

**Conflicts (all confirmed in the primary text, `caseB_verification.md`).**
1. **Restoration time:** TF p.1 says "4 days in some parts", with Ontario "more than a week". NERC p.1 says "most customers within hours", "two days", Ontario "up to two weeks". Unresolved. Restoration sequencing is not published (NERC p.5).
2. **MW lost:** 61,800 MW (TF p.1) vs "more than 70,000" MW (NERC p.1). Unresolved. Not load-bearing for H2.
3. **MISO tool restoration:** "back under full automatic operation ... by 16:04" (TF p.49) vs "did not operate properly in automatic mode again until after the blackout" (NERC p.97, also p.43). Also, RTCA "showed several hundred violations around 15:00" (TF p.55) despite being "effectively out of service" (TF p.49). This bears on MISO's observation layer only. Either version leaves MISO without effective automatic RTCA through the decisive window.
4. **Voltage criteria date:** "around 1998" (TF p.39) vs "In 1999" (NERC p.99). Not load-bearing for H2. Relevant to any Argument V reading.
5. **Load-shed quantity and reference time:** TF 1,500 MW "before" 16:05:57 (p.70) vs NERC 2,500 MW after 15:59 (p.100). These conflict over the overlapping 15:59–16:05:57 window unless the TF figure assumes earlier shedding (start time unstated).
6. **Minor:** MISO trigger disabled ~12:15 (TF p.48) vs 12:40 (TF p.136); AEP identification ~15:33 (TF p.55) vs 15:36 (TF p.66); Star-South Canton first trip 14:27:15 vs 14:27:16.

**Limitations.**
- The execution latency of the decisive action is missing. This alone blocks M1, M3 and timed kernel membership.
- All counterfactual quantities are from retrospective modelling (R) and are reported as the investigators stated them.
- NERC2004 is a Wayback copy (original URL 404), with an HTML prefix stripped before parsing.
- The NERC p.100 "no backup control" finding concerns evacuation facilities, not transfer of authority, and is not used as an authority restriction.
- The investigator knew the outcome in advance (pre-registration Design).
- Not retrieved: NERC's detailed modelling reports, the restoration evaluation (Rec. 11a), and the March 2004 vegetation management report.
