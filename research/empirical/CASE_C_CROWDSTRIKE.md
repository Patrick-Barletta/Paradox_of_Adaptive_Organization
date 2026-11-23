# Case C: CrowdStrike Channel File 291 (19 July 2024)

> **Review.** Drafted by a second analyst independent of the evidence extraction, and checked by the lead analyst on 2026-11-22 against the frozen pre-registration (`EMPIRICAL_TEST_PLAN.md`). Severity labels follow Amendment 1 ("ruled out" when a necessary condition is contradicted by evidence, "not identifiable" when evidence is missing). The verification log is `verification/caseC_verification.md`; the evidence extraction is `evidence/caseC_crowdstrike_evidence.md`.

**Status:** written by the second, independent analyst under the frozen pre-registration (`research/empirical/EMPIRICAL_TEST_PLAN.md`, amendments 1–3 applied at review). Retrospective. The outcome is known, so nothing here is a prospective test.
**Evidence base:** the extractor's file `caseC_crowdstrike_evidence.md` and `caseC_ledger.csv`, plus my own re-verification in `verification/caseC_verification.md` (21 of 21 load-bearing facts confirmed verbatim; one ledger URL defect). Source ids S1–S12 follow the extractor's table. "V#" refers to a row of the verification log.
**Framing (study owner):** this is a recovery-architecture experiment, not a multi-crisis ratchet. Throughout, I keep two things apart: *stopping further distribution*, and *recovering endpoints that had already crashed*.

---

## 1. Scope and the four evidentiary levels

**Hypothesis H3 (pre-registration, Case C).** The system retained central control of distribution but lacked a centrally executable recovery path for affected endpoints. The inability to reverse a completed transition increased recovery latency without further physical damage.

**Viability (pre-registration):** endpoint operational (boots and runs dependent services). **Unit:** a Windows endpoint running Falcon sensor ≥7.11 that was online 04:09–05:27 UTC on 19 July 2024 and received the update (S1, What Happened?; V3).

| Level | Answer | Basis |
|---|---|---|
| 1. Formal possibility | **Yes, already established.** Argument VI Part I admits abortable and non-abortable in-flight transitions and an independent seed (VI.3, VI.5 "Whether work in flight can be abandoned"). Argument III.6 admits recovery that depends on a disabled prerequisite, and III.C admits static reachability with timed unreachability. | Theory papers; no new formal claim |
| 2. Historical mechanism | **Partly documented.** Documented: timed release and halt; remediation procedures and their requirements; post-incident independent boot media. Partly documented: a centrally initiated recovery path that depended on the affected host booting and connecting (reboot-fetch; known-bad list). Its coverage is not reported anywhere. Not found: whether WinRE was present by default; any pre-provisioned, centrally triggerable recovery path. | §2–§3 |
| 3. Causal identification | **Incomplete.** No device-level timing. No split between hosts recovered by reboot and hosts recovered manually. The rival explanation (latency set by access, keys and staffing) is entangled with the architectural mechanism and cannot be separated (§8). | §5, §8 |
| 4. Predictive validity | **Not assessable.** No source predates 04:09 UTC on 19 July. No comparison units. | §9 |

---

## 2. Timed sequence (UTC)

Every source is post-incident by publication (none predates 04:09 UTC on 19 July). In the tag column, "RETRO (pre-state)" marks a retrospective source describing the pre-incident state, "RETRO (intra)" marks a source published 19–23 July, and "RETRO (post)" marks one published 24 July or later. **No row is CONTEMPORANEOUS** in the pre-registration's sense (available to decision-makers before the critical failure).

| Time (UTC) | Event | Source / section | Tag |
|---|---|---|---|
| 2024-02-28 | Sensor 7.11 GA introduces the IPC Template Type | S1, Timeline of Events | RETRO (pre-state) |
| 2024-03-05 | IPC Template Type stress test; first IPC Template Instance released | S1, Timeline; S2 p.1 | RETRO (pre-state) |
| 2024-04-08 to 04-24 | Three more IPC Rapid Response updates "performed as expected in production" | S2 p.1 | RETRO (pre-state) |
| pre-incident | Sensor Content had a staged rollout (dogfooding, early adopters, GA) and N/N-1/N-2 customer policies. Channel-file updates "occur several times a day" | S1, Sensor Content; S4 | RETRO (pre-state) |
| 07-19 04:09 | Channel File 291 content update released | S1, What Happened? (V1); S4 | RETRO (post); S4 intra |
| 07-19 04:09–05:27 | Hosts that were online and received the file crash (out-of-bounds read, BSOD). Window = 78 min | S1, What Happened? / What Happened on July 19 (V3) | RETRO (post) |
| 07-19 05:27 | Defective content reverted (distribution halted, good file served) | S1 (V2); S4; S6d FAQ "78 minutes" | RETRO (post) |
| 07-19 10:30 | Azure relays customer reports of recovery after repeated VM restarts ("as many as 15") | S10, Update as of 10:30 UTC (V20) | RETRO (intra) |
| 07-19 ≤13:22 | Public Tech Alert: reboot to fetch the good file; otherwise Safe Mode/WinRE and delete the file; BitLocker key may be needed; cloud options (offline disk repair; snapshot from before 04:09) | S5, page stamp "Update 9:22am ET" (V6, V7) | RETRO (intra) |
| 07-19 14:20 | Azure status update (gives impact start as "04:09 UTC on the 18th") | S10 (V20) | RETRO (intra) |
| 07-19 19:30 | CEO statement "Sent 2024-07-19 1930 UTC" | S6b, Statement from our CEO | RETRO (intra) |
| 07-20 (time n/s) | Microsoft Recovery Tool post (WinPE boot media) | S8 header "Jul 20, 2024" (V9) | RETRO (intra) |
| 07-20 20:40 | Hub: wired network recommended for the reboot path. For crash-again hosts it points only to a Microsoft article (no CrowdStrike ISO yet) | S6a, "Updated 4:40pm ET, July 20" (V8) | RETRO (intra) |
| 07-21 (n/s) | Microsoft tool: safe-boot option, ISO/USB, PXE added | S8 change log (V9) | RETRO (intra) |
| 07-21 21:06 | CrowdStrike social post: "new technique" tested, opt-in being operationalized | S6b, item "Updated 2024-07-22 1528 UTC" (V11) | RETRO (intra) |
| 07-22 15:10 | Self-remediation video for remote users | S6b | RETRO (intra) |
| 07-22 17:58 | CrowdStrike "Build automated recovery ISOs with drivers" (bootable ISO/USB) | S6b (V10) | RETRO (intra) |
| 07-22 (n/s) | "automated techniques to accelerate remediation" introduced; Microsoft tool v3.1 | S6d FAQ (V13); S8 (V9) | RETRO (post / intra) |
| 07-22 22:37 | "CrowdStrike tested an update to the remediation that was deployed on ... 05:27 UTC. The update has accelerated our ability to remediate hosts." | S6c, item stamp | RETRO (intra) |
| 07-23 (time n/s; posted 17:57) | Channel-file version added to the cloud known-bad list in US-1, US-2, EU. Gov clouds on request | S6c, File Classification Status Update (V12) | RETRO (intra) |
| 07-24 (approx.) | Preliminary PIR (page shows "Updated 2024-07-25 1900 UTC") | S1 | RETRO (post) |
| 07-25 00:00 (= 24 Jul 5pm PDT) | ">97% of Windows sensors online" week over week | S6d, item "Updated 2024-07-25 1954 UTC" (V14) | RETRO (post) |
| 07-25 / 07-27 | Bounds check added / compiler input-count patch in production | S3 pp.3 (V17) | RETRO (post) |
| 07-30 00:00 (= 29 Jul 5pm PDT) | "~99% of Windows sensors online"; "~1% variance week-over-week" | S6d "Final Post-Incident Measurement Report"; S3 p.1; S2 p.1 (V14) | RETRO (post) |
| 08-06 | Full RCA and executive summary | S2, S3 | RETRO (post) |
| 08-09 / 08-19 | Planned: hotfix GA / Content Validator checks (planned as of 6 Aug) | S3 pp.3–5 (V17) | RETRO (post), planned |

"n/s" = time of day not stated.

---

## 3. Failure/recovery transition model

### 3.1 Endpoint states

- **E0 Exposed:** online in the window, sensor ≥7.11, not yet holding the 04:09 file.
- **E1 Crashed / boot-looping:** the file is loaded. An out-of-bounds read occurs "At the next IPC notification from the operating system" (S3 p.2). The driver "is loaded from an early phase of system boot" (S3 p.8). VMs "get stuck in a restarting state" (S10). S6c uses the phrase "systems in a boot loop".
- **E2 Recovered:** boots normally with a good or absent Channel File 291.
- **N Not affected:** offline during the window, Mac/Linux, Win 7/2008 R2, or provisioned after 05:27 (S1; S5; S6b).

**Vendor-level transition on the population (not on an endpoint):** **H Halt/revert** at 05:27 (S1). It moves all hosts still in E0, and every later-connecting host, to N. It does **not** move E1 to E2 (S5, "If hosts are still crashing and unable to stay online...", V5).

### 3.2 Recovery transitions E1 → E2

| Code | Transition | Documented requirements | First documented availability | Who executes | Depends on the affected OS booting? |
|---|---|---|---|---|---|
| R1 | **Reboot-fetch:** reboot so the sensor downloads the 05:27 file before the crash | Network; "wired network ... considerably faster" (S6a); someone or something triggers the reboot (S5: "Reboot the host"); for VMs, repeated restarts, "as many as 15" (S10) | Revert 05:27 (S1); public advice ≤13:22 (S5) | Vendor supplies the good file centrally. The reboot is a customer action per host, though boot-looping hosts restart without one (S10, "restarting state"). For VMs the restart can be issued from the cloud portal/CLI (S10) | **Yes.** It needs Windows, the sensor and the network to come up before the crash (a race). Coverage: **NOT FOUND** |
| R2 | **Known-bad classification:** the cloud marks the file known-bad | "strong network connectivity" (S6c). Hedged: "could also result in the automatic recovery" | 23 July (US-1, US-2, EU); Gov clouds on request (S6c) | Vendor, centrally | **Yes** (the same race as R1). Coverage: NOT FOUND |
| R3 | **"Automated techniques" / opt-in "new technique"** | Opt-in (S6b). Mechanism not described | Tested by 21 Jul 21:06; introduced 22 July (S6b; S6d FAQ) | Vendor, with customer opt-in | **Not documented** (mechanism undescribed). S6c's description ("an update to the remediation that was deployed on ... 05:27") suggests it acts through the sensor's content channel, i.e. the R1 route. That is my inference, not a source statement |
| R4 | **Safe Mode / WinRE manual deletion** | Console access implied ("Boot Windows into Safe Mode or the Windows Recovery Environment", S5). BitLocker key "may" be required (S5). Safe-mode route of the Microsoft tool requires a local administrator account (S8) | ≤13:22 on 19 July (S5) | Customer, **per endpoint** | Safe Mode boots the affected Windows installation in reduced form; WinRE is a separate environment. **Whether WinRE was present/enabled by default: NOT FOUND** |
| R5 | **External boot media** (Microsoft WinPE USB/ISO/PXE; CrowdStrike recovery ISO/USB) | A separate Windows machine with admin rights; USB 1–32 GB; "From the BIOS boot menu, choose Boot from USB"; PXE on the same subnet and hard-wired; BitLocker key may be needed (WinPE) (S8; S6b) | Microsoft: 20 July, extended 21–22 July (S8). CrowdStrike: 22 July 17:58 (S6b) | Customer, **per endpoint** (PXE serves many devices from one server, but each device needs a boot-menu selection and possibly a key, S8) | **No.** An independent startup path |
| R6 | **Offline disk repair (VMs)** | Hypervisor/cloud console; attach the disk to another VM; extra steps for encrypted disks (S5; S9); GCP Python script (S6b) | ≤13:22 on 19 July (S5); Azure 09:26 (S9); GCP script by 22 July (S6b) | Customer, **centrally per environment** (scriptable), virtual endpoints only | **No.** Independent of the affected OS |
| R7 | **Snapshot/backup rollback** | A snapshot or backup from before 04:09 must already exist (S5 Option 2; S9; S10); Windows 365 restore (S8) | 19 July (S5, S9) | Customer, centrally per environment, virtual only | **No.** Independent, but it needs a prior capability (a snapshot) |
| R8 | **Reimage** | "If the device cannot connect to a PXE network and USB is not an option" (S8) | 20–21 July (S8) | Customer, per endpoint | No |

### 3.3 Vendor-level versus customer-level capability

- **Vendor-executable:** H (halt, 05:27); R1's supply side (serving the good file); R2 (23 July); R3 (22 July, opt-in). Every vendor-executable recovery transition acts **through the sensor on a running host**. None is documented as reaching a host that cannot boot far enough to connect.
- **Customer-executable, central for an environment:** R6 and R7, and VM restarts for R1, but **only for virtual/cloud endpoints**.
- **Customer-executable, per endpoint:** R4, R5, R8, and R1 wherever a manual reboot is needed. These are the only documented paths for a physical host that stays in a crash loop.

### 3.4 Mapping to the framework

| Element | Framework analogue | Note |
|---|---|---|
| Release procedure as executed (Rapid Response Content to all eligible hosts, no staged ring for Template Instances; S3 Finding 6 "should have staged deployment") | $`\mathcal U_{\mathrm{fixed}}`$ ($`\pi_0`$) | |
| H halt/revert; R1 advice; R4; R6/R7 for customers with snapshots | $`\mathcal U_{\mathrm{policy}}`$: uses existing capabilities $`\mathcal C(O)`$ | |
| R2 known-bad | Ambiguous: policy (an existing cloud mechanism) or adapt (taking 4 days suggests something new had to be decided or configured). Not decidable from the sources | |
| R3, R5 (tools built 20–22 July), staged rings, customer RRC control (post-incident) | $`\mathcal U_{\mathrm{adapt}}`$: capability-changing moves | |
| A pre-provisioned, centrally triggerable recovery environment for physical endpoints | $`\mathcal U_{\mathrm{phys}}`$ candidate, **labelled hypothetical**: not documented as available | |
| **Independent startup path (seed)** | R5, R6, R7 (and WinRE if present) | Unlike the model's seed (VI.3: activates in one tick regardless of chain depth), each documented seed is applied **per endpoint** (or per VM environment), so its cost grows with the number of units. The model has no counterpart to per-unit cost. |
| **Abandoning a transition in flight** | H (05:27 revert) abandons the vendor's in-flight *distribution* | For an individual endpoint, receive → crash completes at "the next IPC notification" (S3 p.2). The sources give no endpoint-level window in which the transition could be abandoned. The abandonment variant therefore applies only at fleet level. |
| III.6 "Redundancy is not independence" | R1/R2/R3 depend on the disabled prerequisite (a running OS + sensor + network) | The documented loop: recovery needs the sensor online, and the sensor online crashes the host (S5 "unable to stay online to receive"). III.3: closure covers every capability only if the seed set meets every cycle. The cycle-breaking seeds here (R5–R8) all needed per-endpoint or per-VM-environment access. Whether the R1 race broke the loop for a given host was probabilistic and unquantified. |

**Not applicable:** Argument VI Part I's ratchet (Theorem VI.1). This is one crisis. No dated sequence of patches each adding a serial prerequisite is documented, so M2 is not applicable.

---

## 4. Counterfactual comparison

"Documented as available at the time" means before or during 04:09–05:27 UTC on 19 July. No row is quantified, because no source gives the arrival-time distribution of the file across hosts, a ring design, or per-device recovery times.

| Policy | What the sources document | Available at the time? | Status | (a) Effect on the set of affected endpoints | (b) Effect on recovery of already-crashed endpoints |
|---|---|---|---|---|---|
| P1 Original recovery | H at 05:27; R1/R4/R6/R7 on 19 July; R5 from 20–22 July; R2/R3 on 22–23 July (§2–§3) | Yes (as executed) | Documented | Set = hosts online 04:09–05:27 that received the file (S1) | Baseline: per-endpoint manual paths for hosts that kept crashing; the central race path had unknown coverage |
| P2 Earlier detection and halt | The affected set is defined by being online in the window and receiving the file (S1). Hosts connecting after the revert were not affected (S1; S5). **When the defect was detected inside the 78 minutes is not documented** | Halt capability existed (exercised at 05:27). An earlier trigger is not documented | Technically defensible direction; magnitude unidentifiable | Smaller set. Monotone, from S1's scope definition. Size unknown | **None.** The revert did not repair crashed hosts (S5, V5) |
| P3 More limited (staged/canary) rollout | Staged rollout existed for Sensor Content (S1). For Template Instances it is a post-incident finding/mitigation (S3 Finding 6; S1; S2 "completed with an updated deployment ring process"). S3: "Staged deployment mitigates impact if a new Template Instance causes failures such as system crashes" | The organization ran staged rollout for another content class. Not documented as available for Rapid Response Content | Technically defensible (the vendor's own mitigation); ring sizes and bake times not documented | Smaller set, conditional on the ring detecting the crash before promotion. Magnitude unidentifiable | **None** for hosts in the exposed ring: their recovery paths are the same as P1 |
| P4 Independently bootable recovery environment | R5 media were built after the incident (20–22 July). WinRE named (S5), default presence NOT FOUND. All documented independent paths need console/BIOS access, and some need a BitLocker key or admin account (S5; S8) | WinRE/Safe Mode route: yes (≤13:22). External media: not until 20–22 July. Pre-provisioned or remotely triggerable: **not documented** | Pre-built media: technically defensible (removes the 1–3 day build/distribution delay for media users). A remotely triggerable, key-free recovery environment for physical endpoints: **labelled hypothetical** | None | Pre-built media would shorten time-to-tool for the subset that used R5. It would **not** remove per-endpoint access or key entry: those requirements attach to the documented independent paths themselves (S8). Only the hypothetical remote variant would make recovery centrally executable |
| P5 Alternative authorization/deployment controls (customer control over RRC delivery) | Post-incident: "Customers can choose where and when Rapid Response Content updates are deployed" (S3 p.6); "greater control" (S1). The pre-incident absence is **implied only** by mitigation wording (extractor Q5) | Not documented as available | Labelled hypothetical for 19 July | Smaller, for customers who would have deferred. Share unknown | **None** |

**The asymmetry the table shows:** every documented lever that acts before or during distribution (P2, P3, P5) changes only *which* endpoints crash. The only lever aimed at *recovery* (P4) is limited by per-endpoint access in every documented form. Centrally executable recovery for crashed endpoints existed only (i) as the race-dependent R1/R2/R3 route, which needs the affected OS to boot and connect, and (ii) for virtual endpoints through customer hypervisor tooling (R1 restarts via portal/CLI, R6, R7).

---

## 5. Recovery latency (M1, M3, M6)

What can be bounded:

- **Exposure window:** 78 min (04:09–05:27, S1; S6d FAQ).
- **Time to first documented recovery path:** the R1 supply side existed from 05:27 (1 h 18 min after release). R4/R6/R7 were public by 13:22 at the latest (9 h 13 min; S5 page stamp; possibly earlier in the support portal, which was not read). Microsoft R5 media from 20 July (time not stated). CrowdStrike R5 ISO at 22 July 17:58 (3 d 13 h 49 min). R2 on 23 July (about 4 days; time of day not stated).
- **Fleet-level sensor connections (envelope only):** ">97%" at 25 July 00:00 UTC (5 d 19 h 51 min after release) and "~99%" at 30 July 00:00 UTC (10 d 19 h 51 min) (S6d; S3 p.1; S2 p.1). Arithmetic: 5pm PDT = 00:00 UTC next day.

**What these figures are not.** They compare *all* Windows sensors week over week, not affected hosts. The denominator is not stated. CrowdStrike gives no count of affected hosts (extractor Q2.4; Microsoft's 8.5 million, S7, uses an unstated method and was not re-verified). The ~99% figure sits within the stated "~1% variance week-over-week" (S6d), so it cannot be told apart from full recovery. Hosts that were reimaged or replaced and came back under new sensor IDs, or retired, would affect the ratio in ways the sources do not describe. **The fraction of affected hosts recovered at any date therefore cannot be derived.** "Within hours" (S2; S6d FAQ) is qualitative.

**NOT FOUND:** per-device time-to-recovery; the split between R1 and R4/R5; any 19–23 July count. **M1 (per-endpoint serial latency):** the R4 steps (obtain key → boot WinRE/Safe Mode → delete → reboot) are documented as sequential (S5), but no step durations are given. M1 is symbolic. **M3:** no documented deadline. Viability is lost at the crash itself, so for crashed endpoints the margin is ≤0 by construction and the decision points that matter are before release. M3 is not computable as a number. **M6:** abortability of the in-flight distribution: **yes** (exercised at 05:27). Recovery path for affected units without per-unit manual access: **conditional.** Yes through the R1/R2 race for hosts that came up and connected before crashing (coverage unknown), and through customer hypervisor tooling for VMs. No documented path for physical hosts in a persistent crash loop.

---

## 6. H3 grade and the falsification question

**Components:**
1. *Central control of distribution retained:* **documented** (05:27 revert, S1; known-bad 23 July, S6c).
2. *No centrally executable recovery path for affected endpoints:* **partly documented, with a qualification.** For hosts that kept crashing, the vendor's own guidance sends them to per-endpoint procedures (S5; S6a). Every vendor-side recovery mechanism acts through the sensor on a running host (S5; S6c). But a centrally initiated path (R1/R2) **did exist** and is documented as working for some hosts (S10 anecdotes; S6c "could"; S6d "within hours"). Its coverage is unreported. For VMs, customers held centrally executable paths (R6/R7, scripted restarts). So the claim holds for physical hosts stuck in a crash loop, and is contradicted for virtual hosts at the customer level.
3. *The inability to reverse the completed transition increased recovery latency without further physical damage:* the remedy is deleting one file (S5), and no source reports hardware damage, so "without physical damage" is consistent. That the **latency increase** was *caused by* the missing central recovery path, rather than by keys, access and staffing, is **not identified** (§8). No counterfactual latency is documented.

**Pre-registered rejection tests:**
- "Contradicted if a documented centrally executable recovery path existed and was available": R1 existed from 05:27. I do **not** count it as contradicting H3, because the vendor itself documents that it fails for hosts "unable to stay online" (S5). It is centrally initiated but **not independent** of the disabled prerequisite. R6/R7 are central only at the customer level and only for VMs. **Partial contradiction for the virtual subpopulation.**
- "Contradicted if halting earlier is shown not to change the set of affected endpoints": the opposite is documented. The set is defined by exposure during the window (S1). **Not contradicted.**

**Grade: Partially supported.** Level 2 components are documented for physical endpoints. The latency clause has no causal identification. For virtual endpoints the "no central recovery" claim fails at the customer level.

**Falsification question: would independent recovery materially change the outcome once endpoints were already disabled?**
On this evidence: **an independent startup path by itself would not, as documented; whether it would in a remotely executable form is not identifiable.** Reasons:
- Independent recovery paths that do not depend on the affected OS **did exist**: R5 from 20–22 July, R6/R7 on day 0, and R4 via WinRE/Safe Mode on day 0. Every documented physical-endpoint form still required console or BIOS access and possibly a BitLocker key or local admin account (S5; S8). Independence from the affected OS did not deliver central executability. The model's assumption that a seed "activates in one tick" regardless of chain depth (VI.3) does not hold here: these seeds cost per-unit labour.
- The documented factor that most plausibly separated fast from slow recovery is **where the endpoint sat**. VMs could use console-level independent paths (R6/R7) or scripted restarts. Physical hosts needed hands on the machine. The vendor says "varying degrees of complexity and architectural constraints ... significantly impact remediation timelines" (S6d FAQ). But no source measures recovery times by environment type.
- A pre-provisioned, remotely triggerable, key-free recovery environment is the only variant that would plausibly change the outcome materially. It is **not documented as available** at the time, so it remains a labelled hypothetical (pre-registration §3) and cannot carry weight.
- Earlier halting or staged rollout (P2, P3) acts on the set of affected endpoints, not on recovery. On the documented evidence, the controllable mass of the outcome sits **before** the crash. For already-crashed endpoints, the documented binding constraint is per-unit access, not whether the startup path is independent.

---

## 7. Severity (pre-registration §3)

**Not identifiable.**
- *Severity 3:* item (a) is only partly met: independent paths are documented, but a centrally executable one for physical hosts at the decision point is not. Item (c) **fails**: no organizational restriction (authority, procedure, contract, governance) is documented as excluding an available recovery path. The constraints the sources name are technical (early-boot kernel driver; disk encryption) and logistical (access, keys). Item (d) cannot be checked (no time or authorization data).
- *Severity 1/2:* staged rollout (P3) is a candidate capability move. The organization ran staged rollout for Sensor Content, and the vendor later adopted it for Template Instances. But no source documents that it would have preserved viability for any specific set of endpoints, or its latency (no ring sizes or detection times). The pre-registration forbids a class without device-level timing.
- *Ruled out:* nothing can be ruled out on reliable evidence. The absence of a documented organizational restriction leaves severity 3 not identifiable under §3 ("Failing any item, severity is not identifiable"); it does not rule it out.

No numerical $`k`$, $`L^*`$, latency parameter or kernel membership is assigned.

---

## 8. Competing explanations

| Rival | Evidence for | Evidence against / limits | Assessment |
|---|---|---|---|
| **R-a: the defect determines the outcome once endpoints crash** | The crash is deterministic for any host that loaded the file and received an IPC notification (S3 p.2). The driver loads early in boot, so the crash recurs (S3 p.8). The affected set is fixed by exposure (S1) | The defect fixes **whether** a host crashes, not **how long** it stays down. Recovery routes and their timing varied (R1 race vs R4–R8; S10; S6d FAQ) | Explains the affected set. Does not explain latency. It narrows H3 to the latency clause |
| **R-b: latency driven by BitLocker keys, physical access, customer staffing** | BitLocker keys are needed throughout (S5; S6a; S8); "Bitlocker recovery without recovery keys" manuals (S6a); per-endpoint console steps (S5; S8); the vendor "deployed personnel and engaged with strategic partner services teams" (S6d FAQ); environment-dependent timelines (S6d FAQ) | These requirements arise *because* no centrally executable recovery path existed for physical hosts. Architecture determines whether access and keys are needed at all, and staffing determines how long it takes once they are | **Not separable** on this evidence: the architectural mechanism and the rival are entangled. This is the main reason causal identification is incomplete |
| R-c: the boot-time race (network speed) decided recovery | Wired network "considerably faster" (S6a); "strong network connectivity" (S6c); up to 15 reboots (S10) | Anecdotal; no rates | A variant inside H3's mechanism (dependence on the disabled prerequisite); unquantified |

---

## 9. Negative controls and prediction-test feasibility

**Documented negative controls** (all vendor statements, RETRO):
- Hosts offline or not connecting during 04:09–05:27: not impacted (S1, V4).
- Hosts brought online or provisioned after 05:27: not impacted (S5; S6b).
- Mac and Linux hosts: not impacted (S1). Windows 7/2008 R2: not impacted (S5).
- VMs with snapshots from before 04:09: recovery by rollback documented as an option (S5; S9; S10). **No counts.**

These controls support the exposure-window account of *which* hosts crashed, and so the effect of a halt on the affected set. None of them is a control for *recovery architecture*: there is no documented comparison of recovery time between endpoints with and without an independent or central recovery path. A VM-versus-physical comparison would be the natural control, but no source reports times split that way.

**Prediction test (§7 of the pre-registration): not feasible.** No source predates 04:09 UTC on 19 July. No contemporaneous snapshot can be built. There are no comparison units (other vendors' or other incidents' recovery data were not collected). M9 is not assessable.

---

## 10. Limitations and source conflicts

- **All sources are vendor (CrowdStrike/Microsoft) self-reports and retrospective.** No independent measurement of recovery. Congressional testimony and third-party reporting were not consulted (extractor scope).
- **Unread material:** CrowdStrike support-portal manuals (bootable ISO, BitLocker, GCP) are behind a login. Microsoft KB5042421 was unreachable. The 20 July original of S8 was not seen (only v14.0).
- **R3 "automated techniques" are undescribed**, so their independence from the affected OS cannot be classified.
- **Timing conflicts (flagged by the extractor, confirmed V20):** Azure S9 gives "19:00 UTC on the 18th"; S10 gives "04:09 UTC on the 18th"; S7 says "On July 18" with no time zone. CrowdStrike's 04:09 UTC on **19** July is consistent across S1, S4, S5, S6. A separate Azure Central US storage incident (21:56 UTC 18 July to 12:15 UTC 19 July, S11) confounds any Azure-side timing.
- **Internal inconsistency:** S2 and S3 word the direction of the 20/21 mismatch differently (V18). Immaterial to H3.
- **Planned vs completed:** the 9 and 19 August mitigation dates were planned as of 6 August (V17).
- **Ledger defect:** the S6d `/en-us/` URL returns 404; the non-`/en-us/` URL works (verification log).
- **S1 publication date:** "2024-07-24" is not printed on the page; the page shows "Updated 2024-07-25 1900 UTC".
- **Absence finding (my addition):** the RCA contains no recovery-side finding or mitigation (verification log). This narrows what the vendor itself treated as cause. It does not show that no recovery work happened elsewhere.
- **Hindsight:** the mapping of R2 to the policy or adapt class is undecidable from the record.
