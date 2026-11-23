# Case A: Boeing 737 MAX (Arguments V and VI)

> **Review.** Drafted by a second analyst independent of the evidence extraction, and checked by the lead analyst on 2026-11-22 against the frozen pre-registration (`EMPIRICAL_TEST_PLAN.md`). Severity labels follow Amendment 1 ("ruled out" when a necessary condition is contradicted by evidence, "not identifiable" when evidence is missing). The verification log is `verification/caseA_verification.md`; the evidence extraction is `evidence/caseA_boeing_evidence.md`.

Status: written by the second, independent analyst, 2026-11-22, under the frozen pre-registration (`research/empirical/EMPIRICAL_TEST_PLAN.md`, amendments 1–3 applied at review). Retrospective design: outcomes are known, so nothing here is out-of-sample validation (plan, header).

Sources:

| ID | Document |
|---|---|
| S1 | JATR, 2019-10-11 |
| S2 | House T&I majority staff final report, 2020-09 |
| S3 | AD 2020-24-02, 85 FR 74560-74593, 2020-11-20 |
| S4 | FAA RTS Summary, 2020-11-18 |
| S5 | KNKT LNI610 final report, 2019-10 (read from an archived third-party mirror; no official copy obtained) |

Page conventions, full citations and hashes are in `caseA_verification.md`. Page references below are printed page numbers (85 FR page numbers for S3). Facts marked † were verified by the second analyst. All others are as reported by the extractor and were not re-read.

Labels used throughout:

- **[H]**: historical observation from a source.
- **[M]**: model or counterfactual statement.
- **CONTEMP**: the record existed before 2018-10-29.
- **RETRO**: post-accident finding or testimony.

---

## 1. Scope and the four evidentiary levels

**Scope.**
- **System:** the 737-8 MAX design and certification program (2011-2017), the in-service MCAS failure condition (LNI610, 2018-10-29), and the remediation (2019-03-13 to 2020-11-20).
- **Viability (A0):** safe controllability of the aircraft in documented failure conditions. A concrete documented boundary is the 75-lb short-term column-force limit of 14 CFR 25.143, which S5 reports was exceeded (>100 lb) on LNI610 (S5 p.206, Finding 21†).
- **Not examined:** the ET302 final report. Its in-flight timeline is therefore not used.

The four levels, each answered separately:

1. **Formal possibility.** Established by the theorems and not at issue.
   - Theorem V.2: a concession that carries a permanent scar is in the kernel up to $`T^*`$ and out of it afterwards.
   - Theorem VI.1: if $`\ell_{n+1}\ge \ell_n+\delta`$ with $`\delta\ge 1`$ and deadlines are bounded, patching becomes infeasible.
   - These are statements about models. They say nothing about this case.
2. **Historical mechanism.**
   - H1A (concession): **partly documented.** There are dated choices with stated near-term benefits and a persistent capability dependency (§6).
   - H1B (serial ratchet): **not documented.** No dated intervention is recorded as adding a mandatory sequential recovery step (M2 = 0; §5, §6).
3. **Causal identification.**
   - Not achieved for H1A. The rivals in §8 (specific safety-analysis defects, oversight and communication failures) each explain the accident outcome without requiring the concession mechanism, and the record cannot discriminate between them.
   - Not applicable for H1B, because no mechanism components were found.
4. **Predictive validity.** Not assessable. There are no comparison units and no contemporaneous M1/M2 series (§10).

---

## 2. Dated decision timeline

| Date | Decision / event | Stated short-term benefit | Cost (documented) | Introduced dependency | Documented alternatives at the time | Source / page | C/R |
|---|---|---|---|---|---|---|---|
| Dec 2010 | Airbus launches A320neo (disturbance $`w`$) | n/a | n/a | Competitive pressure | n/a | S2 p.38† | CONTEMP event |
| 2011-01-14 | Albaugh: "I don't think we will re-engine the 737" | n/a | n/a | n/a | "new small airplane" | S2 p.38† (reconstructed) | CONTEMP |
| 2011 (spring/summer); launch press release 2011-08-30 | Re-engine the 737 NG rather than develop a new airplane | "saving time, resources, and costs" (S2 p.39†); "lowest operating costs" (press release, S2 p.39†); ~$3B vs ~$10B analyst estimate (S2 p.37†) | Not stated at the time | Commits the design to the existing airframe and federated architecture ("rooted in the original 1967 certification", S1 p.7†) | Clean-sheet "Project Yellowstone" since 2005 (S2 p.39) | S2 pp.37-39† | CONTEMP (press release); RETRO (S2 characterization) |
| Dec 2011 | Southwest clause: $1M per aircraft if NG/MAX not interchangeable | Sales commitment | $200M to ~$400M exposure if Level B not obtained (S2 p.24†) | Program objective: Level B (no simulator) differences training | n/a | S2 pp.24†, 139† | CONTEMP contract, RETRO disclosure |
| Early program, no date | Larger engines mounted further forward and higher; nose gear +~8 in | Ground clearance (NG 17 in, S2 p.87†) | Aircraft "more likely to pitch upward" (S2 p.43†) | Aerodynamic characteristic that must be compensated to comply with Part 25 | n/a | S2 pp.42-43† | RETRO account |
| 2012-06-14 | EICAS exception sought | Avoid "Considerable program cost and schedule risk" | Crew alerting stays at older standard | Exception from the latest 25.1322 | Full EICAS: "cascading effects on flight deck design and other systems" | S2 pp.46-47† | CONTEMP |
| 2012 (exact date not given) | Avionics regression testing cut by 2,000 hours | Cost/schedule | Not quantified | n/a | Larger cuts examined | S2 p.17† | CONTEMP |
| 2012-11-01 | Simulator test: >10 s reaction found "catastrophic"; engineer asks whether to "step up to catastrophic" | n/a | n/a | n/a | Classify as catastrophic (not adopted) | S2 p.114† | CONTEMP |
| No date | Vortex generators tried, then MCAS added | n/a | n/a | Compliance now depends on an augmentation function (S4 p.10†, RETRO) | Vortex generators: "did not prove to be satisfactory" | S2 p.89† | RETRO account |
| Feb 2013 | Synthetic airspeed not made standard | Protect "Program directive to maintain Level B training" | Not quantified | n/a | Synthetic airspeed (recommended again 2014-03-03, S2 pp.170-171) | S2 p.171† | CONTEMP |
| 2013-05-21 / 2013-06-07 | MCAS nomenclature handled under "revised speed trim" umbrella | Avoid "greater certification and training impact" | n/a | Reduced visibility of MCAS (rival: communication) | Emphasize MCAS as new (Boeing's 2020 counter-position: it did disclose MCAS as new, S2 p.92) | S2 pp.92-95† | CONTEMP |
| 2015-12-17 | AR asks "Are we vulnerable to single AOA sensor failures ...?" | n/a | n/a | n/a | Sensor checking/voting (not adopted) | S2 p.108 | CONTEMP |
| 2016-01-26 | FAA accepts that cumulative effects need not be considered for differences training | Keeps Level B path | n/a | Training determination considers changes one by one | Consider cumulative effects | S1 p.43† | CONTEMP |
| 2016-03-30 | MCAS redesign approved: low-speed activation; authority 0.6 deg -> 2.5 deg | Mitigation "for basic stall characteristics" | n/a | Larger single-activation authority, combined with single-AOA input and reset logic (date of reset logic **not documented**) | n/a recorded at this meeting | S2 pp.103-104†; S1 p.18†; S5 p.196† | CONTEMP |
| Rev C to Rev E (2016) | SSA not updated beyond Rev C (high-speed only) | Boeing judged high-speed regime critical, so no revision needed (S1 p.34 O6.9-G) | n/a | Safety analysis no longer matches the certified function | Update SSA | S1 p.34† | RETRO finding on CONTEMP records |
| 2016-03-30 | MCAS references removed from FCOM (FAA approved) | n/a | n/a | Crews not informed of MCAS (S5 contributing factor 4, p.215†) | n/a | S2 p.86†; S1 p.47 | CONTEMP |
| 2016-06-22 | Repeated activation on fail-high AOA: "No need to redesign to address this" | "minimal / low collateral damage, therefore no additional flight testing" | n/a | Repeated-activation behavior retained | Redesign | S2 p.111† | CONTEMP |
| Aug 2016 | Provisional Level B approval (~2 h CBT) | Level B achieved | n/a | Training stays as CBT | Simulator training | S2 p.26† | CONTEMP |
| Nov-Dec 2016 | 79 of 91 certification plans delegated; stabilizer SSA delegated | n/a | n/a | Reduced FAA involvement (rival: oversight) | FAA retention | S2 p.101† | CONTEMP |
| 2017-03-08 | Amended type certificate issued | n/a | n/a | n/a | New TC (retrospectively disputed, S2 p.49) | S1 p.I fn.1† | CONTEMP |
| Aug 2017 | AOA DISAGREE alert found tied to optional indicator; fix deferred to 2020 (MAX-10) | Bundle with MAX-10 rollout | n/a | Alert absent on most aircraft | Fix immediately | S2 pp.22-23† | CONTEMP |
| 2018-11-07 | Emergency AD 2018-23-51 (procedure only) | Immediate, no design change | n/a | n/a | Design change (FAA: permanent action "was to require a design change", S2 p.212) | S2 pp.210-212; S3 p.74561 (replaced) | between accidents |
| 2019-03-13 | Emergency Order of Prohibition (grounding) | n/a | n/a | n/a | n/a | S4 p.15† | RETRO |
| 2019-03-13 to 2020-11-20 | Remediation: two-AOA MCAS input, single activation, authority limit, monitors, wire separation, AOA DISAGREE standard, 8 revised procedures, special training | n/a | ">22 months", >60,000 FAA hours (S4 p.5†) | Removes reliance on immediate crew action (S4 p.13†) | Removal of MCAS rejected (S4 p.10†) | S3 p.74561†; S4 pp.5-14† | RETRO |

---

## 3. Dependency DAG (edges)

Edge types follow plan §3. "Serial" is used only where the record states that one step must complete before the next can start. Design-causation edges are labeled "design" because they are not recovery-path edges, and Theorem VI.1 counts only recovery-path serial edges.

**Design phase**

| # | From -> To | Type | Source / page | Latency |
|---|---|---|---|---|
| D1 | A320neo launch -> re-engine decision | design (motivating) | S2 pp.38-39†, 87† | not documented |
| D2 | Re-engine -> engines forward/higher | design | S2 p.42† | not documented |
| D3 | Engine placement -> pitch-up tendency / light column feel in parts of the envelope | design | S2 p.43†; S4 p.10† | n/a |
| D4 | Pitch-up -> MCAS (vortex generators rejected) | design | S2 p.89†; S4 p.10† | not documented |
| D5 | MCAS original (high speed, 0.6 deg) -> MCAS expanded (low speed, 2.5 deg), 2016-03 | design | S1 p.18†; S2 p.103†; S5 p.196† | n/a |
| D6 | FHA classification Major -> single-AOA input permitted | conditional (classification permits; does not mandate) | S5 p.206 F19† | n/a |
| D7 | Level B objective (Southwest clause) -> rejection or limitation of synthetic airspeed, EICAS, MCAS nomenclature | conditional (stated rationale) | S2 pp.24†, 46-47†, 95†, 171† | n/a |

**In-flight recovery (as delivered)**

| # | From -> To | Type | Source / page | Latency |
|---|---|---|---|---|
| F1 | Erroneous AOA (single sensor) -> MCAS nose-down command | serial (causal) | S5 p.49†, p.215† | MCAS rate 0.27 deg/s (S1 p.14†); per-activation duration not documented |
| F2 | MCAS command -> crew response, one of three alternatives: (a) stop electric trim, (b) long electric trim to full re-trim, (c) stab trim cutout then manual wheel | **parallel / alternative (OR)** | S5 pp.193-194† | Assumed 3 s (S5 p.204†) or 4 s (S1 p.14†); observed >10 s to reach cutout in one 2012 sim test (S2 p.113) |
| F3 | Within option (c): cutout switch -> manual trim wheel | serial (implied by the procedure's logic) | S5 pp.193-194† | not documented |
| F4 | Short electric trim -> MCAS reset -> 5 s -> new MCAS command (loop) | serial loop | S5 p.49† | 5 s (documented) |
| F5 | Repeated F4 cycles without full re-trim -> cumulative mis-trim -> column force > 75 lb | conditional | S5 p.205 F9†, p.206 F21†; sim "too heavy" after two full applications, S5 p.93† | not documented as time |

**Remediation and return to service (2019-2020)**

| # | From -> To | Type | Source / page | Latency |
|---|---|---|---|---|
| R1 | MCAS software redesign -> integrated STS SSA review -> wire-separation non-compliance -> wiring change | conditional (discovered as a result) | S4 p.11† | not documented |
| R2 | eCAB testing -> FCC CPU/memory issue -> new monitors -> integrated SSA (2020-08-25) | conditional | S4 p.54† (root-cause sheet 2019-06-19) | not documented |
| R3 | TAB final report -> FAA final compliance determination | serial | S4 p.54† | not documented |
| R4 | FAA design approval -> AD issuance -> EOP rescinded | serial ("based on completion of") | S4 pp.13-14† | not documented (aggregate ">22 months", S4 p.5†) |
| R5 | JOEB (2020-09-22) -> draft FSB (2020-10-06) -> comments closed (2020-11-02) -> final FSB Rev 17 (2020-11-16 or 11-18) | serial as dated (ordering inherent in notice-and-comment) | S4 p.11†; S3 p.74561† | about 8 weeks, from documented dates |
| R6 | Final FSB -> pilot special training -> pilot may serve | serial ("before serving") | S4 p.14†; S3 p.74573† | not documented |
| R7 | AD (g) FCC software, (h) AFM, (j) MDS, (k) wiring, (l) AOA test | **parallel / unordered** (each "before further flight", no order specified) | S3 pp.74584-74592† | work-hours 1/1/1/up to 79/10, not elapsed time |
| R8 | {(g)-(l)} -> (m)(1) ORF -> (m)(2) resolve irregularities -> further flight | serial | S3 p.74592† | ORF: "no definitive data" (S3 p.74584) |
| R9 | (j), (k) done before AD effective date under June 2020 SBs, run in parallel with certification | parallel (credit allowed) | S3 p.74592† (para (o)) | n/a |
| R10 | FAA certification run alongside four foreign authorities | parallel ("concurrent validation") | S4 pp.6, 35† | n/a |

**Observation about the DAG [H].** Every recovery-path serial edge with a documented ordering (R3-R6, R8) was created by the 2019-2020 remediation process itself. None is attributed in the record to a prior, dated design modification. The one pre-accident recovery structure documented (F2) is a set of alternatives, not a chain.

---

## 4. Formal mapping

Symbolic wherever the record gives no number (plan §3, "no invented parameters").

| Symbol | Mapping | Evidence | Uncertainty |
|---|---|---|---|
| $`x`$ | Aircraft safety-relevant state: stabilizer position or mis-trim, column force, AOA sensor validity, flight phase; at fleet level, operating or grounded | S5 pp.49, 193-194, 205-206†; S4 p.15† | In-flight trajectories for ET302 not consulted |
| $`O`$ | Architecture and capabilities: MCAS (single-AOA input, 2.5 deg authority, reset-and-repeat logic); AOA DISAGREE inoperative on most aircraft; crew alerting with EICAS exception; federated 737 architecture; certification capabilities (ATC, ~40 exceptions S1 p.11; delegation 79/91 S2 p.101†) | S2 pp.22-23†, 90†, 103†; S1 p.7† | When the reset logic entered $`O`$ is not documented |
| $`\pi`$ | Decision policies: FHA classification and AC 25-7C crew-action assumptions (S1 p.XII†); Level B directive (S2 pp.98, 171†); "no need to redesign" disposition (S2 p.111†); crew NNC (runaway stabilizer) | as cited | Whether $`\pi`$ changed between 2012 and 2016 is not documented as a rule change |
| $`q`$ | Commitments and moves in flight: Southwest clause; certification schedule (application 2012-06-30, ATC 2017-03-08, S1 p.I†); MCAS Rev C to E in progress; AOA DISAGREE fix deferred to 2020; in 2019-2020 the remediation work items R1-R10 | as cited | Internal schedule margins not in the record |
| $`w`$ | Market: A320neo (S2 p.38†). Physical: erroneous AOA (mis-calibrated replacement sensor on LNI610, S5 p.215†). Regulatory: Changed Product Rule as applied (S1 p.IV†) | as cited | |
| $`V`$ | Viable iff aircraft remains controllable; operational proxy: column force within 75 lb short term (25.143) | S5 p.206†, p.193† | The proxy is a regulatory threshold, not the physical controllability limit |
| $`\mathcal U_{\mathrm{fixed}}`$ | Program rules as executed (Level B directive; FHA as classified; delivered design and procedures) | §2 | |
| $`\mathcal U_{\mathrm{policy}}`$ | Procedural or training changes within the certified design (e.g., Emergency AD 2018-23-51; adding MCAS to FCOM; simulator training) | S2 pp.161, 210-212 | |
| $`\mathcal U_{\mathrm{adapt}}`$ | Design changes requiring certification moves (two-AOA input, single activation, authority limit, monitors, wiring), as later executed | S3 p.74561†; S4 pp.7-11† | |
| $`\mathcal U_{\mathrm{phys}}`$ | Anything physically implementable with available technology and time. Only documented alternatives may be used (plan §3). A clean-sheet airplane is **not** treated as a viable counterfactual (case spec) | | |
| $`\tau`$ | **In-flight:** MCAS rate 0.27 deg/s (S1 p.14†); reset delay 5 s (S5 p.49†); assumed crew response 3 s (S5 p.204†) or 4 s (S1 p.14†); observed >10 s in one 2012 sim test (S2 p.113). **Program:** 2012-06-30 to 2017-03-08 certification. **Remediation:** 2019-03-13 to 2020-11-20 grounding-to-AD (my arithmetic, ~20 months); review ">22 months" (S4 p.5†) | as cited | |
| $`D`$ (deadline) | In-flight: $`D_{\mathrm{flt}}`$ = time from first erroneous activation to uncontrollable column force. **Symbolic; not documented as a number** in the sources read | S5 p.93† gives only an event-count bound ("two full applications" without restoring trim -> "too heavy", in one simulator session) | Cannot be computed |
| $`\ell_n`$ | Serial recovery latency after the $`n`$th modification. **Not documented for any $`n`$.** In-flight, $`\ell`$ = the time of the fastest of three alternative responses, not a sum. At remediation level, $`\ell_{\mathrm{RTS}}`$ ≈ 20 months aggregate, with no stage durations | S5 pp.193-194†; S4 p.5† | |
| $`\delta`$ | Increment per modification: **not identifiable** (no $`\ell_n`$ series) | | |
| $`T^*`$ (V.2) | The horizon at which the concession's scar becomes fatal. **Symbolic.** Candidate scar-activation event: first in-service erroneous-AOA MCAS activation (LNI610 2018-10-29, and the prior Lion Air flight described in S4 p.18†) | | $`T^*`$ is not a decision-time quantity anyone documented |

---

## 5. Metric results

| Metric | Result | Measured | Not measurable, and why |
|---|---|---|---|
| **M1** serial recovery latency at dated decision points | **Not measured at any pre-accident decision point.** | (i) In-flight, the structure is documented: one of three alternative responses, a 5-s reset loop, assumed 3-4 s response, one observed >10 s (S5 pp.49, 193-194†; S1 p.14†; S2 p.113). (ii) Remediation aggregate: grounding 2019-03-13 to AD 2020-11-20, review ">22 months" (S4 p.5†). (iii) Per-aircraft ordering: (g)-(l), then ORF, then irregularities (S3 p.74592†). | No source gives a minimum time to reach a safe configuration through mandatory steps, as of any dated design decision. Per-aircraft elapsed time is not given (work-hours only; ORF "no definitive data"). Remediation stage durations are not given (verification #18). |
| **M2** serial dependency increments | **0 documented** (pre-registered minimum: ≥ 2). | Candidates examined: (a) 2016-03 MCAS expansion (S2 p.103†) increased authority and the activation envelope, but no source says it added a sequential recovery step; the in-flight response set stayed three alternatives (S5 pp.193-194†). (b) Reset/repeat logic: date not documented (verification #9). (c) AOA DISAGREE deferral (S2 pp.22-23†) removed an alert; it did not add a step. (d) EICAS exception (S2 pp.46-47†) is described as avoiding cascading *design* changes, not as adding a recovery step. (e) AEG ordering (S2 p.147†) is a certification-sequence constraint, not a recovery step. (f) Remediation discoveries (wiring, CPU, power-up; S4 pp.11, 54†; S2 p.223†) lengthened RTS work, but they are findings during recovery, not prior modifications, and their mutual ordering is not documented. | |
| **M3** remaining margin | **Not computable.** | | Requires $`D`$ and M1 at a decision point. In-flight $`D_{\mathrm{flt}}`$ is not documented numerically, and no program-level deadline for loss of viability is documented. |
| **M4** concession | **Partially documented.** | Near-term benefits: re-engine "saving time, resources, and costs" (S2 p.39†) and ~$3B vs ~$10B (analyst estimate, S2 p.37†); Level B to avoid $200M-$400M exposure (S2 p.24†); EICAS exception to avoid "program cost and schedule risk" (S2 p.46†); synthetic airspeed foregone to protect Level B (S2 p.171†). Persistent capability cost: compliance depends permanently on MCAS ("Without MCAS, the 737 MAX would not meet FAA's regulatory requirements", S4 p.10†); FAA rejected removing MCAS in 2020 (S4 p.10†); architecture "rooted in the original 1967 certification" that "drove many design decisions" (S1 p.7†). | No internal cost or schedule data (plan §5 Case A "missing data"). No document links a specific near-term saving to the specific feature that failed (single-AOA input, repeat activation). The single-AOA rationale in the record is the FHA classification, not cost (S5 p.206 F19†). |
| **M9** predictive discrimination | **Not feasible.** | | See §10. |

---

## 6. Hypothesis assessments

### H1A: structural concession (Theorem V.2 setting)

**Pre-registered minimum evidence** (plan §5, Case A): a dated decision with a documented near-term benefit and a documented later capability cost.

**Rejection rule:** contradicted if the choices had no persistent capability cost or no near-term benefit.

**Components documented.**
1. **Dated choices with stated near-term benefits [H]:**
   - 2011 re-engine (S2 pp.37-39†);
   - Dec 2011 Level B commitment (S2 pp.24, 139†);
   - 2012 EICAS exception (S2 pp.46-47†);
   - 2013 synthetic airspeed decision (S2 p.171†);
   - 2016-06-22 "no need to redesign" (S2 p.111†).
2. **Persistent capability limitations [H]:**
   - The airframe needs a stability augmentation function to comply. This persisted through and after remediation (S4 p.10†).
   - The certification basis carried exceptions and a 1967-rooted architecture (S1 pp.7, 11†).
   - Training commonality constrained what could be added to the flight deck: "would likely jeopardize the Program directive to maintain Level B training" (S2 p.171†); EICAS exception sought with an explicit training-impact rationale (S2 pp.45-46).
3. **Consequential later [H]:** KNKT contributing factors 2-4 name the single-sensor reliance, the crew-response assumptions, and the absence of MCAS guidance in manuals and training (S5 p.215†).

**What fails or is missing.**
- (a) The chain is not documented as a single concession → scar → failure path:
  - The re-engine decision is documented as creating MCAS dependence (D2-D4).
  - The features that made MCAS hazardous (single AOA, 2.5 deg authority, repeat activation) trace to the FHA classification and safety-analysis choices (S5 p.206 F19-20†; S1 p.34†), not to a documented cost saving.
- (b) The "scar" was not permanently fatal. An adapt-class redesign restored viability in about 20 months while keeping the airframe and MCAS (S3 p.74561†; S4 p.13†). In Theorem V.2's four-class reading, that places the post-concession state at severity ≤ 2 ("a later clean fix still rescues it"), not at the severity-3 branch [M].
- (c) Rivals (§8) explain the accident outcome without the concession mechanism. The record cannot apportion causation: KNKT explicitly declines to rank factors (S5 p.215†).

**Grade: Partially supported.**
- Necessary components are documented: near-term benefit, persistent capability dependency, later consequence.
- Causal identification is incomplete. The concession and the specific-defect accounts cannot be separated with these sources, and the most consequential features have a non-cost (classification) rationale in the record.
- Not contradicted: both a near-term benefit and a persistent capability cost are documented.

### H1B: Escape Ratchet (Theorem VI.1 setting)

**Pre-registered minimum evidence:** M2 ≥ 2 dated interventions, each documented to add a mandatory sequential step to recovery, with latency or ordering.

**Rejection rule:** not supported if fewer than two; contradicted if the record shows the remediation path did not lengthen with the modifications.

**Result.**
- M2 = 0 documented (§5).
- The only dated pre-accident design modification affecting MCAS (2016-03) is documented as changing authority and envelope, not as inserting a recovery prerequisite.
- The in-flight recovery structure is a set of alternatives (S5 pp.193-194†).
- The documented serial orderings all belong to the 2019-2020 remediation and were created by it (R3-R6, R8).
- Within the AD the five corrective actions are unordered (R7), and two could be done before the AD (R9).
- The remediation removed dependence on crew trim action (S3 p.74561†; S4 p.13†) rather than adding prerequisites.
- Remediation took longer than early estimates ("six weeks-ish", S2 p.205†; "July 2019", S2 p.211†) because scope grew through findings during review (S4 pp.9, 11, 54†). That is discovery of latent defects, not accumulation of serial steps from successive modifications. The case spec says explicitly that design complexity or deficiencies do not establish a ratchet.

**Grade: Not supported under the pre-registered rule (M2 = 0 < 2). On the four-grade scale: Not identifiable.**
- "Contradicted" is not assigned. That needs a record showing the remediation path did not lengthen with the modifications, and no source states remediation latency as a function of the design modifications.
- The available evidence leans against the mechanism: alternative rather than serial recovery structure, parallelizable corrective actions, and remediation that shortened crew-dependence.
- **Report as a structural-concession candidate, not an Escape Ratchet case.**

---

## 7. Severity

Rule (plan §3): severity 3 requires all of the following, and failing any one makes severity **not identifiable**:

- (a) an alternative documented as implementable at the decision point;
- (b) its viability under the same disturbances;
- (c) a documented organizational restriction that excluded it;
- (d) its time, resource and authorization requirements checked.

Candidate alternatives:

| Candidate | Decision point | (a) implementable then | (b) viable under same $`w`$ | (c) organizational restriction excluded it | (d) requirements checked | Verdict |
|---|---|---|---|---|---|---|
| Two-AOA MCAS input / sensor voting | 2015-12 to 2016-06 | Partly. Two AOA sensors already fitted (S2 p.90†); KC-46 MCAS used ≥ 2 AOA sensors (S2 p.103†); KNKT: "could have been considered" (S5 p.206†). | Partly, retrospectively. It is part of the 2020 fix, which FAA found removes reliance on immediate pilot action (S4 p.13†). Not shown as sufficient alone. | **No.** FHA "Major" made it "not required" (S5 p.206†). That is non-requirement, not exclusion, and Boeing had authority to adopt it. | No. Pre-accident cost, schedule and certification latency not documented. | Fails (c), (d). Also lies within $`\mathcal U_{\mathrm{adapt}}`$ (executed by the same organizations in 2019-2020), so it would bear on severity ≤ 2, not 3. **Severity 3 not identifiable.** |
| MCAS redesign for repeated activation (single activation per event) | 2016-06-22 | Partly ("easy fix / small work statement" for a related item, S2 pp.110-111) | Retrospective only (2020 fix) | No. Internal disposition "No need to redesign" (S2 p.111†), a policy choice, not an external restriction | No | **Not identifiable**; adapt-class |
| Synthetic airspeed | 2013-02 / 2014-03 | Recommended internally (S2 pp.170-171) | **Not documented** to address the MCAS failure condition | Yes, in part: "Program directive to maintain Level B" (S2 p.171†) | No | Fails (b), (d). **Not identifiable** |
| Simulator training / MCAS in FCOM | 2015-2016 | Yes, as procedures (later adopted, S2 p.161; S3 p.74573†) | **Not documented** as sufficient to preserve viability for LNI610 conditions | Program Level B directive (S2 pp.24, 98, 147†) | No | Policy class. **Not identifiable**; would bear on severity 1, which needs documented sufficiency and latency (absent) |
| Grounding after LNI610 (Nov 2018) | 2018-11 | Yes (executed 2019-03-13) | Trivially preserves controllability by removing exposure [M] | None documented; FAA held authority | Immediate | Within FAA authority: **severity 3 ruled out** for this decision point. Severity 1/2 not graded: whether the AD 2018-23-51 procedural path was insufficient for ET302 is not established from these sources |
| Remediation design (2019-2020) | fleet state at 2019-03-13 | Yes (executed) | FAA determination (S4 p.13†) | None; executed under FAA retention (S4 p.5†) | Latency ≈ 20 months grounding-to-AD | An adapt-class path existed and was executed: **severity 3 ruled out** for the post-grounding fleet state |
| Clean-sheet airplane | 2011 | Excluded by the case spec as a counterfactual | n/a | n/a | n/a | Not used |

**Formal severity.**
- **Not identifiable** for the pre-accident design states.
- **Ruled out** (as severity 3) for the inter-accident and post-grounding fleet states, where documented alternatives lay within the organizations' existing authority and were executed.
- No severity 1 or 2 classification is made, because the required documentation of sufficiency and latency for a specific earlier move is absent.

---

## 8. Competing explanations

| Rival (pre-registered) | Evidence | Explains outcome without the mechanism? |
|---|---|---|
| Specific safety-analysis or implementation defects | SSA not updated beyond Rev C (S1 p.34†); integrated SSA not performed (S1 p.33); FHA Major and single-AOA reliance (S5 pp.204, 206†); repeated activation judged no worse than single (S1 p.34†) | **Yes, for the accident outcome.** Absorbs the proximate design features fully. Compatible with an upstream concession but does not need one. |
| Certification and oversight failures | Delegation 79/91 (S2 p.101†); ODA ~1,500 vs BASOO 45 (S1 p.27); CPR "did not adequately address cumulative effects" (S1 p.IV†); JATR: FAA involvement "would likely have resulted in design changes that would have improved safety" (S1 p.27†) | **Yes.** |
| Communication failures | MCAS information "so fragmented" (S1 p.13); coordination sheets not shared, "because they were not required to do so" (S2 p.25†); FCOM removal (S2 p.86†); chief project engineer unaware of single-AOA and repeat activation (S2 p.21†) | **Yes**, jointly with the defects rival. |
| Financial/schedule constraints without a ratchet | Production and schedule pressure (S2 pp.12-13); "value of a day" (S2 p.17); Level B directive (S2 p.171†) | **Yes.** This rival overlaps H1A: it is the concession's motive without serial accumulation. It is compatible with H1A and directly competes with H1B. |
| Design deficiency without accumulating serial latency | Remediation was a bounded redesign; corrective actions unordered and parallelizable (S3 p.74592†); recovery alternatives, not a chain (S5 pp.193-194†) | **Yes.** It is the best-fitting account of the recovery-path evidence and is the main reason H1B is not supported. |
| (non-pre-registered, noted) Maintenance and crew factors | Mis-calibrated replacement AOA sensor; installation test; CRM (S5 p.215 factors 6-9†); FAA RTS scope excludes these (S4 p.14) | Contributes to the specific accident; not a rival to H1A/H1B at the design level. |

---

## 9. Negative controls

Documented from these sources: changes that added complexity or work but did not lengthen the recovery critical path.

1. **Remediation added complexity while reducing crew-step dependence [H].**
   - Added: FCC cross-monitoring, a 5.5-deg AOA split monitor, eight new or changed AFM procedures (S4 p.11†), and one-time special training.
   - Yet the FAA concluded "no STS failure modes rely on exceptional piloting skills or immediate pilot actions" (S4 p.13†), and the new MCAS authority limit preserves pitch control "without the need to make electric or manual stabilizer trim inputs" (S3 p.74561†).
   - So: more complexity, and a shorter in-flight recovery path.
2. **AD corrective actions (j) and (k) [H].** They add per-aircraft work (wiring up to 79 work-hours, S3 p.74584†), but they are unordered relative to (g), (h) and (l), and could be completed before the AD under June 2020 SBs (S3 p.74592† para (o)). That is added work without an added serial step.
3. **Concurrent foreign validation [H]:** parallel, not serial (S4 pp.6, 35†).
4. **"201 distinct significant changes" in the G-1 issue paper (S2 p.43†) [H].** Large design-change count, and none is documented as adding a recovery prerequisite. The JATR describes their certification as handled change by change ("bottom-up", S1 p.8). This is weaker as a control: it shows complexity without a documented recovery-path effect, not a documented absence of one.

---

## 10. Prediction-test feasibility (plan §7)

**What a contemporaneous snapshot (before 2018-10-29) could contain [H]:**
- the 2012 >10 s "catastrophic" simulator result and the six coordination sheets repeating it (S2 pp.25, 114-115†);
- the 2015-12-17 single-AOA question (S2 p.108);
- the 2016-06-22 repeated-activation disposition (S2 p.111†);
- the 2016 MCAS authority increase (S2 p.103†);
- the 2017 AOA DISAGREE deferral (S2 pp.22-23†);
- the Level B commitments (S2 pp.24, 139†);
- the 2016-01-26 cumulative-effects ruling (S1 p.43†);
- the delegation fraction (S2 p.101†).

**Caveat on availability [H].** Several of these existed but were not available to the FAA or to program leadership (S2 pp.20, 21, 25†). Contemporaneous existence is not decision-maker availability.

**Computable framework indicators from that snapshot:**
- M1/M2/M3 cannot be computed from contemporaneous data. No serial-latency series exists, and in-flight $`D`$ is undocumented.
- A qualitative concession indicator (M4-style: near-term benefit stated, capability foregone) could be coded.

**Comparison units:**
- None in these sources with comparable records: no other derivative program, no A320neo certification file, no 737 NG equivalent dossier.
- **Discrimination cannot be assessed** (plan §7). No frozen snapshot was produced, because nothing quantitative could be frozen.

---

## 11. Limitations and source conflicts

**Limitations**

1. **S5 provenance.** Read from a Wayback capture of a third-party mirror. The hash matches the extractor's copy, but no official KNKT copy was obtained:
   - knkt.go.id path returned 404;
   - legacy knkt.dephub.go.id host did not resolve;
   - the investigations page is JS-rendered.
   S5-dependent statements (the in-flight recovery structure, FHA classification, contributing factors) carry this caveat.
2. **S2 is a majority-staff report.** Most Boeing internal records appear only as S2 quotations. Boeing disputes some characterizations, e.g. the MCAS disclosure (S2 p.92).
3. **Hindsight.** All findings are RETRO. The CONTEMP/RETRO labels mark the record's date, not its availability to decision-makers.
4. **Not consulted:** ET302 final report, DOT OIG AV2020037, NTSB A-19-010..016 (the last two only as quoted in S2/S4), internal Boeing cost and schedule data.
5. **No stage durations for the remediation.** There is no document giving a dated Gantt-style sequence. M1 is therefore aggregate only.
6. **The date the MCAS reset/repeat logic was introduced is not documented** in any of the five sources (searched). This is the single missing fact most likely to bear on any future H1B argument. Even if found, it would be one modification, short of M2 ≥ 2.

**Source conflicts** (the extractor's, retained, with second-analyst notes)

| Conflict | Sources | Status |
|---|---|---|
| Certification date 2017-03-08 vs 2017-03-09; initial ATC proposal 2012-01-27 vs application 2012-06-30 | S1 p.I fn.1†, S2 p.5 vs S2 p.41 | Unresolved; S1 and S2 p.5 agree on March 8 |
| Crew response assumption 4 s vs 3 s | S1 p.14† vs S5 p.204† | Both verified. S1's 4 s is recognition plus reaction in its example; S5 attributes 3 s to FAA guidance (S5 p.191†) |
| Hazard classification "Major" vs "hazardous" vs "minor" | S5 p.204† vs S1 p.17 O3.2-A / O3.3-A | **Largely reconciled by the second analyst.** S5 p.196† states "major effect in the normal flight envelope and hazardous effect in the operational flight envelope"; S1's "minor" refers to loss of MCAS |
| Final FSB Rev 17 date Nov 16 vs Nov 18, 2020 | S3 p.74561† vs S4 p.11† | Unresolved (possibly document date vs publication date) |
| 0.6-deg original MCAS authority | Extractor: S2 only | S5 p.196† also gives 0.6 -> 2.5 deg |
| First coordination-sheet citation date (2015-07-08, S2 timeline p.100) vs 2012 simulator email | S2 pp.100, 113-115 | Not a conflict: different documents. Kept as flagged |
| Quote fidelity | S2 p.111 "[sic]" (extractor insertion); S2 p.25 quote truncated before "because they were not required to do so" | Corrected in this draft |
