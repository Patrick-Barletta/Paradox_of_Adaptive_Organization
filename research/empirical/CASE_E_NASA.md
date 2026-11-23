# Case E: NASA Challenger (STS 51-L, 28 Jan 1986) and Columbia (STS-107, 1 Feb 2003)

> **Review.** Drafted by a second analyst independent of the evidence extraction, and checked by the lead analyst on 2026-11-22 against the frozen pre-registration (`EMPIRICAL_TEST_PLAN.md`). Severity labels follow Amendment 1 ("ruled out" when a necessary condition is contradicted by evidence, "not identifiable" when evidence is missing). The verification log is `verification/caseE_verification.md`; the evidence extraction is `evidence/caseE_nasa_evidence.md`.

**Status.**
- Written by the second, independent analyst under the frozen pre-registration (`research/empirical/EMPIRICAL_TEST_PLAN.md`, amendments 1–3 applied at review).
- Retrospective. The outcomes are known, and the analyst has general prior knowledge of both accidents, so nothing here is a prospective or out-of-sample test.

**Evidence base.**
- The extractor's files `caseE_nasa_evidence.md` and `caseE_ledger.csv`.
- My own re-verification against freshly downloaded primary sources: `verification/caseE_verification.md`, rows V1–V20.
  - 20 load-bearing facts were checked. 18 match verbatim. Two needed qualification: the Mulloy "24 previous times" wording is a retrospective reconstruction (V10), and CAIB's criticality summary contradicts Rogers' dated record (V19).
  - One page error was found (p.139, not p.140), plus an omission that is load-bearing for Section 3 (V17).

**Citation form.**
- "R" is the Rogers Commission Report, Vol. 1 (1986). Page numbers are the bracketed printed-page markers in NASA's HTML transcription. Ch. IV, V, VI and VII were read.
- "C" is the CAIB Report, Vol. I (Aug 2003). Printed page numbers equal the PDF index.
- Tags:
  - **CONTEMP** means the record existed before the relevant accident.
  - **RETRO** means a finding, interpretation or testimony made after the accident.
- CAIB's interpretive statements (normalization of deviance, "conditioned by success") are RETRO and are *not* used as independent evidence for H5. They are the Board's own reading of the mechanism under test. Where possible, I rest each component on contemporaneous records.

**Case spec (study owner).** H5: repeated successful operations despite known anomalies can change acceptance thresholds, reducing protective behavior without removing the hazard. The rival to test is whether the records show altered safety policy, or merely persistent hazards and failures of engineering judgment.

---

## 1. Scope and the four evidentiary levels

**Theory being applied.** Argument V, Theorem V.3, in its institutional analogue. The theorem's ingredients are:
1. a protective rule whose level is set from experience;
2. the rule resets upward after a shock;
3. the rule relaxes as a function of the length of the calm;
4. a later shock comparable to earlier ones is failed after a long calm, although it would have been survived after a short one.

In the four-class model, V.3's failure is a policy-level mismatch (severity 1) up to a point of no return, and severity 4 after it.

**Mapping (pre-registration, Case E).**
- $`\pi`$: the anomaly acceptance criteria and flight-readiness rules, both as written and as executed.
- $`O`$: the authority structures for raising and acting on safety concerns.
- $`w`$: anomaly occurrences.
- Viability: vehicle integrity through flight.

**Four levels, answered separately.**

| Level | Answer for Case E | Basis |
|---|---|---|
| 1. Formal possibility | **Established** (already, by Theorem V.3) | The model admits an experience-based floor that relaxes during calm and fails a later shock. Nothing in this case changes that. |
| 2. Historical mechanism | **Partially documented, in a practice-level form, for both programs.** The formal-criteria form is **not documented**. | Dated, contemporaneous records show acceptance practice moving toward less protective dispositions, with prior experience or success explicitly invoked (§2, §3). In neither program is a formal acceptance criterion documented as relaxed *on the ground of prior success*. The one formal relaxation (the Mar 1983 criticality waiver) has other documented rationales (R p.128). V.3's distinctive ingredient (3), relaxation as a function of calm length, is **not identifiable** (§7). Ingredient (4), a comparable shock, **fails for Challenger** (36°F, 15°F below any prior launch; R p.70) and holds only partly for Columbia (C p.146). |
| 3. Causal identification | **Not reached.** | Schedule pressure is documented as co-equal for Columbia (C p.198). Communication and containment failures are documented as decisive for the final Challenger launch decision (R pp.82, 84, 104). Experience-based engineering judgment cannot be separated from H5 with these records (§6). No documented counterfactual removes prior success while holding the rest fixed. |
| 4. Predictive validity | **Not feasible.** | There is no numeric protective-margin series (M7), no calm measure independent of success (M8), and n = 2 accidents with no comparison units (M9). See §7. |

---

## 2. Dated risk-decision timelines

"Prior success cited?" records only what the decision record itself says. "Criterion used" is the stated basis of the decision.

### 2a. Challenger (SRB field-joint O-rings)

| Date | Decision / classification | Criterion used | Prior success cited? (quote) | Source | Tag |
|---|---|---|---|---|---|
| 24 Nov 1980 | Joint classified Criticality 1R on the CIL | redundancy assumption; CIL text says secondary reseal "is not known" | No | R p.125 | CONTEMP |
| 9 Mar 1982 | STS-2 primary erosion (.053 in.) not reported at the STS-3 Level I FRR and not entered in PAS | none recorded | No | R p.125 | CONTEMP event; RETRO finding |
| 17 Dec 1982 | **Criticality 1R → 1** (tightening) | 1982 high-pressure tests: secondary seal "no longer functional after the joints rotated" | No. The basis is test data. | R pp.125–126 (V1) | CONTEMP |
| 28 Mar 1983 | **Waiver of the Criticality 1 status**, granted by Levels I and II, "to avoid the obligations imposed … by Paragraph 2.8"; processed outside the PRCB | Weeks: the 1980 Certification/Verification Review; the SRB "one of the least worrisome things we had" | No explicit citation of flights. The schedule link ("so that STS-6 could fly") is disputed. | R pp.127–128 (V2) | CONTEMP waiver; RETRO testimony |
| Feb–Mar 1984 | 41-B erosion. PAS: "Remedial action-none required" and "this is not a constraint to future launches" | analytic max .090 in. vs sealing demonstrated at .095 in. | No. The basis is analysis plus a lab test. | R p.128 | CONTEMP |
| 30 Mar 1984 | **41-C Level I FRR approves flight "accepting the possibility of some O-ring erosion"**. The "safety margin" becomes "the basis for approving Shuttle flights" | same erosion-margin model | No | R pp.132, 133, 147 (V3) | CONTEMP |
| 5 Apr 1984 | HQ directive (Mark, signed by Weeks) for a "formal review" of joint sealing. The final response is not completed until 19 Aug 1985 | — | — | R p.132 | CONTEMP |
| 21 Feb 1985 | **51-E Level I FRR**: the 18-page analysis is reduced to a one-page chart, "acceptable risk because of limited exposure and redundancy (Ref. STS 41-C FRR)"; "No mention of temperature" | precedent (the earlier FRR) plus redundancy, although the joint had been Criticality 1 since 1982 | **Precedent cited**: "(Ref. STS 41-C FRR)" | R p.147 | CONTEMP |
| 2 Jul 1985 | 51-F Level I FRR: the .171 in. 51-B erosion is presented without noting that it "far exceeded" the revised model maximum of .070 in. | leak-check fix proposed as the cure | No | R p.147 (V4) | CONTEMP; RETRO finding |
| Jul 1985 | **Launch constraint imposed** after 51-B (tightening) | 1980 Marshall definition of a launch constraint | — | R p.137 (V5) | CONTEMP |
| after 10 Jul 1985 to Jan 1986 | **Constraint waived for every flight** (six waivers before 51-L). Not escalated to Level II, which was formally required. Absent from all FRR documents | Mulloy: whether the observation "is within our experience base" and previous analysis "is still valid" | **Yes, experience is the criterion**: "within our experience base"; "staying within our test experience base" | R pp.137–138 (V6); p.139 (V7); p.147 (V8); R p.84 (V11) | practice CONTEMP; wording RETRO testimony |
| 19 Aug 1985 | HQ briefing: "Analysis of existing data indicates that it is safe to continue flying existing design" under leak-check, cleanliness and squeeze conditions | analysis plus conditions | No | R p.139 (Fig. 5) | CONTEMP |
| 18 Dec 1985 / 23 Jan 1986 | PAS entries "contractor closure received" and then "problem is considered closed". Testified to be "in error" | none; Russell: "Because I was asked to do it" | No | R pp.143–144 | CONTEMP entries; RETRO testimony |
| 27 Jan 1986 | Thiokol engineers recommend not flying below 53°F. Thiokol management reverses "at the urging of Marshall … to accommodate a major customer". Level III (Reinartz) decides not to escalate | Thiokol engineers: "we should not fly outside of our data base, which was 53 degrees". Mulloy: no LCC for joint temperature | **Yes (reconstructed)**: "after we have successfully flown with the existing Launch Commit Criteria 24 previous times". Mulloy gives this as the "context in which those words may have been used". | R pp.88, 90, 96 (V10), 104 (V12) | CONTEMP recommendation; RETRO testimony |
| 28 Jan 1986 | Launch at an ambient 36°F, "15 degrees lower than the next coldest previous launch" | — | — | R p.70 (V18) | CONTEMP fact |

### 2b. Columbia (External Tank foam / debris)

| Date | Decision / classification | Criterion used | Prior success cited? (quote) | Source | Tag |
|---|---|---|---|---|---|
| design baseline | Requirement 3.2.1.1.17: "No debris shall emanate from the critical zone…". TPS to withstand KE < 0.006 ft-lb | requirement | — | C p.122 | CONTEMP |
| Jun–Jul 1983 (STS-7) | First bipod loss: IFA, then "closed". CoFR and FRR documents do not reference "correcting the cause of the damage – the shedding of foam" | IFA closure | No | C p.123 (V13) | CONTEMP; RETRO critique |
| Dec 1988 (STS-27R) | Largest debris event to date. **Crew directed to inspect on FD2** with the RMS camera. IFAs assigned and then "closed" when the SRB nose-cap ablator was changed | out-of-norm damage | No | C p.127 | CONTEMP |
| Jan–Feb 1990 (STS-32R → STS-36) | IFA closed "on the basis that there may have been local voids" | engineering explanation | No | C p.124 | CONTEMP |
| 1990 (STS-36 FRR) | Foam first identified "as a turnaround issue" | maintenance framing | No | C p.128 | CONTEMP |
| 1992 (STS-42 → STS-45) | STS-45 is "the first mission launched before the foam-loss In-Flight Anomaly was closed" | "not a safety-of-flight" concern | No | C p.129 | CONTEMP |
| 1992 (STS-50 → STS-46) | IFAs closed: "accepted flight risk" (Integration; Hazard Report 37) and "not considered a flight or safety issue" (ET Project) | risk acceptance | No | C p.124 | CONTEMP |
| 1993 (STS-56, STS-58) | IFA closure rationale: foam debris "'in-family,' or within the experience base" | **experience-based category** | **Implicitly**: "within the experience base" | C p.129; definition C pp.122–123 | CONTEMP rationale |
| 1997–2000 (STS-87 → STS-101) | STS-87 damage "out-of-family". IFA kept open over nine missions of fixes, then closed at an "acceptable level". Board: the fixes "merely reduced foam-shedding to previously experienced levels" | out-of-family → acceptable level | No | C pp.128–129 | CONTEMP; RETRO note |
| 1999 | SIAT: the Program "was inappropriately using previous success as a justification for accepting increased risk" | external review | n/a (a warning) | C p.179 | CONTEMP (via CAIB summary) |
| Oct 2002 (STS-112) | IPWG recommends an IFA. **PRCB assigns an "action" instead**, "inconsistent with previous practice". The report-back date slips past STS-113 and STS-107 | — | Not on the record of this decision. CAIB attributes it partly to the Node 2 schedule (C p.125). | C p.125 (V14) | CONTEMP; RETRO characterization |
| 31 Oct 2002 (STS-113 FRR) | ET "Rationale for Flight". Disposition "accepted risk" rather than "not a safety-of-flight" issue. CoFR signed. Hazard Report 37 not updated; no ET configuration change | flight history plus "no changes" claims (the latter factually wrong: the design had changed at ET-76) | **Yes, explicit**: "The Orbiter has not yet experienced 'Safety of Flight' damage from loss of foam in 112 flights (including 3 known flights with bipod ramp foam loss)" | C pp.125–126 (V15) | CONTEMP |
| pre-launch, Jan 2003 | STS-107 FRR does not discuss STS-112: "According to Program rules, this discussion was not a requirement because the STS-112 incident was only identified as an 'action'" | Program rules, applied to the downgraded classification | No | C p.126 (V14) | CONTEMP rule; RETRO finding |
| 17 Jan 2003 (FD2) | USA classifies the strike "out-of-family" and a contingency plan is initiated (C pp.142–143, 166). The same day, "before any analysis had started", Program managers "officially shared their belief that the strike posed no safety issues". IPWG Chair asks Hale for imagery | MER log: "The LCC constraints on ice, the energy/speed of impact … and the toughness of the RCC" | No | C pp.142–143, 166 | CONTEMP |
| 21 Jan 2003 (FD6) | MMT. Ham: "there is not much we can do about it … what I'm really interested in is making sure our flight rationale to go was good". Two more imagery requests. Ham e-mail: the STS-113 rationale "was lousy then and still is" | focus on the precedent rationale | Reviewed, and criticized by Ham herself | C pp.147–148, 166 | CONTEMP |
| 22 Jan 2003 (FD7) | **DoD imagery request cancelled at 8:30 a.m.** "Nobody had a requirement for imagery." "Even if we saw something, we couldn't do anything about it. The Program didn't want to spend the resources." Austin: the SSP "has concluded that it is not possible to PRECLUDE a potential catastrophic event". Schomburg: hits "as large as the one this flight" produced only a gouge, so "That is what I expect this time" | "requirement" or "mandatory need" test; experience of prior hits | **Yes (experience)**: Schomburg, by e-mail, on "the two or three times we have been hit with a piece as large as the one this flight" | C pp.152–155, 157 (V16, V20) | CONTEMP |
| 24 Jan 2003 (FD9) | MMT. Ham: "no safety of flight … it's more of a turnaround issue similar to what we've had on other flights". The minutes omit the strike | precedent ("similar to … other flights") | **Yes**: "similar to what we've had on other flights" | C pp.161–162 | CONTEMP |
| 1 Feb 2003 | Loss of Columbia | — | — | — | — |

---

## 3. Formal criteria versus practice under unchanged formal criteria

**Challenger.**

*Formal criteria moved toward more protection, not less:*
- The criticality was tightened from 1R to 1 on 17 Dec 1982 (R p.126).
- A launch constraint was added in Jul 1985 (R p.137).
- The formal reporting system *required* launch constraints to go to Level II (R p.139).

*The one formal relaxation:*
- The Mar 1983 waiver of Criticality 1 obligations (R pp.127–128). Its documented rationales are the 1980 certification review (Weeks) and, disputed, letting STS-6 fly (Aldrich, Kohrs). At that date there was one in-flight erosion event, STS-2. The record does not attribute the waiver to accumulated success.

*Practice changed under these criteria:*
- A new, explicit decision rule appeared in Mar 1984: fly if erosion is within the modelled margin (R pp.132–133). It is grounded in analysis, not success.
- When observed erosion (.171 in.) exceeded the model (.070 in.), flights continued. The working criterion became "within our experience base" (R pp.137–138, 147).
- Hotz summarized this practice as "as the experience went up, your criteria for, say, flight went up too", and Mulloy assented for the 51-B case (R pp.144–145; V9).
- The 51-E Level I resolution cited a precedent FRR and "redundancy", two years after the formal redundancy status had been withdrawn (R p.147).
- Rogers' Findings describe exactly this pattern (R p.148, RETRO).

This is a change in the *executed* threshold, dated (Mar 1984; Feb 1985; Jul 1985 onward) and partly attributed to experience. It happened under formal criteria that were stricter than practice and that were violated: escalation was required (R p.139) and was withheld (R pp.84, 88).

**Columbia.**

*Formal requirement:* the debris requirement 3.2.1.1.17 and the 0.006 ft-lb TPS requirement were never formally relaxed in anything CAIB reports. CAIB says the debris requirements "have not been met on any mission" (C p.130) and that "NASA has not followed its own rules and requirements on foam-shedding" (F6.1-1, C p.130).

*What changed was the classification of individual events:*
- an IFA closed with a corrective rationale (1983);
- then a turnaround issue (1990);
- then launch before closure (1992);
- then accepted risk / not a safety issue (1992);
- then in-family (1993);
- then an "action" instead of an IFA (Oct 2002).

That last step had a *formal consequence under unchanged rules*. Program rules then did not require STS-112 to be discussed at the STS-107 FRR (C p.126).

*The only scheme change:* the "in-family" category, introduced post-Challenger. It is undated. It was introduced to *focus* attention on out-of-family problems (C p.196), not as a relaxation prompted by success.

*The sequence is not monotone:*
- STS-27R (1988) drew an in-flight inspection and IFAs (C p.127).
- STS-87 (1997) was handled as out-of-family, with an IFA open over nine missions (C p.129).
- At STS-113 the label moved to "accepted risk", which CAIB says "seemingly acknowledged that the foam posed a threat" (C p.126).

**Answer to the rival ("altered safety policy, or persistent hazard plus engineering-judgment failure").**

The records show neither in pure form.

*Formal safety policy was not altered toward less protection on success grounds in either program.* A strong formal reading of H5 is therefore **not supported**.

*Executed acceptance thresholds did change.* The changes are dated, and at several points prior experience or success is the stated basis:
- R p.147 (precedent);
- R pp.137–138 (experience base);
- C p.129 (in-family);
- C p.125 ("112 flights");
- C pp.155, 161–162 (prior hits; "similar to … other flights").

*The hazard persisted throughout and was acknowledged contemporaneously:*
- R p.139 ("lack of a good secondary seal in the field joint is most critical");
- C p.155 (Austin: not possible to "PRECLUDE a potential catastrophic event").

The engineering-judgment rival overlaps with H5 rather than competing with it, because the judgments documented at the decision points are themselves experience-based (§6).

---

## 4. Control-hierarchy classification of key decisions

**Classes, as in Argument V:**
- **fixed**: incumbent rules as executed.
- **policy**: revisions within existing authority and capability.
- **adapt**: capability-changing moves.
- **phys**: physically implementable with the same causal laws and costs.

**How the classification is assigned.** For each decision I give:
- the protective alternative documented in the record;
- the least class that contains it;
- whether an organizational restriction removing corrective authority or capability is documented;
- the severity finding under Section 3.

No numeric $`k`$, $`L^*`$, latency or kernel membership is inferred. Latencies appear only where the record states them.

| # | Decision (date) | Documented protective alternative | Least class needed | Organizational restriction documented? | Severity finding |
|---|---|---|---|---|---|
| C1 | Crit 1R → 1 (17 Dec 1982) | (it is the protective act) | fixed: the CIL process as written | — | n/a (protective) |
| C2 | Criticality waiver (28 Mar 1983) | Withhold the waiver. Complying with Paragraph 2.8 would require a redundant seal (redesign) or not flying. | **adapt** to keep flying; policy to stand down | **No.** Levels I and II held the authority and exercised it (R pp.127–128). | Sev. 3 ruled out for this decision (the decision-makers held authority). Sev. 1 or 2 not identifiable: no documented latency or viability for a redesign at that date. |
| C3 | Erosion-margin acceptance, 41-C FRR (30 Mar 1984) | Do not accept erosion pending root-cause work. HQ could and did direct a "formal review" (R p.132). | **policy** | No | Not identifiable. It is not documented that a policy change alone would have preserved viability. |
| C4 | Per-flight waivers of the Jul 1985 constraint; non-escalation (Jul 1985 to Jan 1986) | Honor the constraint (hold flights until resolved). Escalate to Level II as required (R p.139). Short-term measures (Thompson, Aug 1985: "simple short-term measures should be taken", R p.140). Finding 5: the Aug 1985 history "was sufficiently detailed to require corrective action prior to the next flight" (R p.148). | **policy** (hold, escalate). **adapt** for hardware measures (Thompson: long-term fixes need "several years", R p.140). | **Partly.** Rogers documents "a propensity of management at Marshall to contain potentially serious problems" and "no system which made it imperative that launch constraints and waivers … be considered by all levels" (R p.104). Rogers also documents that safety offices sat "under the supervision of the very organizations … they are to check" (R Ch. VII p.161). This is a *missing forcing rule and a weak independent check*. It is not a removal of authority: Mulloy imposed and waived the constraint himself, and Level II had authority but no information. | Sev. 3 ruled out (authority to hold flights existed in the line that decided). Sev. 1 vs 2 not identifiable (no documented latency or viability for the short-term measures). |
| C5 | 51-L launch decision (27 Jan 1986) | Accept Thiokol's original recommendation not to fly below 53°F (R p.90); delay | **policy** (Level III, and above, could scrub) | No restriction on the action. The restriction was on *information* to Levels I and II (R pp.84, 88). | Sev. 3 ruled out. **Sev. 1 consistent but not established.** R p.82 documents the *decision* counterfactual ("highly unlikely that they would have decided to launch"). It does not document a *viability* counterfactual for a warmer launch, and R p.72 names temperature as one of six factors. The length of the delay is not documented. Mulloy's "until next April" is his own contested claim (R p.96). |
| K1 | STS-112 "action" instead of an IFA (Oct 2002) | Assign an IFA (prior practice), update HR 37, require FRR discussion | **policy** (within PRCB authority, C p.125) | No | Not identifiable. CAIB's counterfactual is hedged: managers "may have been more sensitive … may have taken more aggressive steps" (C p.126). |
| K2 | STS-113 FRR acceptance (31 Oct 2002) and flying STS-107 | Do not fly until root cause and corrective action (the action due 5 Dec 2002 slipped, C p.125); change the ET configuration | **policy** (stand-down); **adapt** (foam fix; latency not documented in the sources read) | The Program combined "all authority and responsibility for schedule, cost, manifest, safety, technical requirements, and waivers" and S&MA lacked "independence and authority" (C p.192). This is concentration, not exclusion: the authority to act sat with the deciders. | Sev. 3 ruled out. Sev. 1 vs 2 not identifiable. |
| K3 | Not pursuing imagery or inspection, FD2–FD6 (17–21 Jan 2003) | DoD imaging (requests made, C p.166); crew EVA inspection ("could be easily accomplished", C p.173) | **policy** | See the Section 3 test below | See below |
| K4 | Cancelling DoD imagery, FD7 (22 Jan 2003, 8:30 a.m.) | Let the request proceed | **policy** | Exercise of authority by the MMT chair (C p.153) | See below. It falls at or after CAIB's "before Flight Day Seven" condition. |
| K5 | Rescue or repair (counterfactual) | Accelerated Atlantis processing plus a rescue plan; on-orbit repair | **adapt.** The rescue and repair plans did not exist and "would most likely have been developed" (C p.174). Managers "failed to develop simple contingency plans for a re-entry emergency" (C p.181). | — | See below |

### 4a. Section 3 test: Columbia imagery/inspection → rescue path

| Item | Requirement | Evidence | Met? |
|---|---|---|---|
| (a) | A physically viable alternative documented as implementable with the technology, resources and time at the decision point | **Rescue.** "This rescue was considered challenging but feasible. To succeed, it required problem-free processing of Atlantis and a flawless launch countdown." A rescue "would have been conceivable", and Atlantis "might have provided a window" (C p.174, F6.4-2). **Resources.** Atlantis was at KSC with SRBs mated (C p.173), and "seven commanders, seven pilots, and nine spacewalk-trained astronauts were available" (C p.174). **Repair.** Rated "high risk" (C pp.173–174). **DoD imaging.** Its capability to resolve the damage is **not documented in Vol. I**. The clearance finding says managers decided "based on little or no knowledge" (C p.154). NASA's rescue study itself assumed the imagery was **"inconclusive"** and that a **crew spacewalk on FD5** found the damage (C p.173). | **Partly**, and only for decisions before FD7. Viability is documented as *conditional* ("challenging", "conceivable", "might"), not as established. |
| (b) | Viability under the same disturbance and causal laws | The NASA study used Columbia's actual consumables (CO₂ scrubbing to FD30, 15 Feb; oxygen to FD31; C p.173) and the hypothesized wing damage. The repair analysis assumed a 6-inch RCC hole (C p.173). | **Yes**, as far as the study goes. The damage size in the repair case is an assumption. |
| (c) | A documented organizational restriction (authority, procedure, certification, contract, governance) that excluded it | **Documented restrictions on sub-actors and information:** the "mandatory" requirement burden on the DAT (C p.157); chain-of-command reluctance (Rocha's unsent e-mail, C p.157); the designated-liaison channel (Hale's call "without authorization … not the designated liaison", C p.152); no security clearances in the operational chain (C pp.154, 172); concentration of authority and weak S&MA (C p.192); the inverted burden of proof (C pp.172, 190). **The excluding acts themselves** were decisions by holders of authority: Ham's termination of the request (C p.153); "nobody had a requirement" (C p.153); "even if we saw something, we couldn't do anything about it" (C p.154); Readdy's "not-to-interfere" (C pp.166–167). CAIB calls the belief that nothing could be done one held "without study" (C p.181). No record shows that the MMT or Program lacked authority to order an EVA inspection, request DoD imaging, or begin Atlantis processing. The clearance restriction did not touch the EVA-inspection route that the rescue study used. | **No.** The record affirmatively documents that the alternative lay within the deciders' authority. |
| (d) | Time, resource, activation and authorization requirements checked | Atlantis "could be readied for launch, with no necessary testing skipped, by February 10" with "three around-the-clock shifts seven days a week". The window was "from February 10 to February 15", with weather permitting (C p.173). The damage had to be determined "unequivocally … before Flight Day Seven" (C p.174). The study timeline: imagery requested FD3, decision FD4, EVA FD5, processing from FD6 (C p.173). Authorization would have come within the Program; no external authorization is documented as needed. | **Documented**, conditional on (a). The FD7 cancellation (K4) falls at or after the stated boundary. The decisive window is the FD2–FD6 decisions (K3). |

**Conclusion.**
- **Severity 3 is ruled out for the documented imagery/rescue path.**
  - Labeling convention, set by the study coordinator for all cases: "ruled out" applies when evidence positively contradicts a necessary condition; "not identifiable" applies when the evidence is missing.
  - Item (c), a documented organizational restriction that excluded the alternative, is not merely undocumented but positively contradicted. The excluding acts were exercises of authority by those who held it (C pp.153–154, 166–167). The documented path runs through actions inside $`\mathcal U_{\mathrm{policy}}`$ (inspection, imaging) and $`\mathcal U_{\mathrm{adapt}}`$ (developing a rescue plan, accelerated processing). If viable, that bounds severity at ≤ 2.
- **Severity 1 or 2 is not identifiable**, because viability is documented only conditionally.
- If the rescue is classed as a capability-changing move, as above, the in-flight state at FD2–FD6 would be a severity-2 candidate, not severity 1.
- CAIB's FD7 condition is the only documented bound on a point of no return for the rescue path. It is CAIB's stated condition, not a parameter estimated here. After it, only the "high-risk" repair remained.

**Relation to V.3.** V.3's model has no post-shock recovery moves. Its severity-1 classification therefore maps onto the *pre-shock* decisions (C3–C5, K1–K2), where the protective alternatives are policy-class. The in-flight rescue question (K3–K5) lies outside what V.3 models. A severity-2 reading there would not contradict V.3, but it is also not evidence for it.

**Challenger, the same test in brief.**
- No documented alternative after the 27 Jan decision could have preserved the vehicle once it had launched.
- Before launch, every documented protective alternative (C2–C5) was within the authority of the actors who declined it. Item (c) fails for each.
- Severity 3 is ruled out for every Challenger decision examined. Severity 1 or 2 is not identifiable (no documented viability or latency for the counterfactual).

---

## 5. H5 grade

**Challenger: Partially supported.**

*Documented components:*
1. Repeated anomalies on successful flights (R pp.125, 128, 134–136, 141).
2. Executed acceptance thresholds moved: the acceptable damage increased (R p.120), and the criterion shifted from an analytic margin to the "experience base" (R pp.137–138, 144–145, 147).
3. Experience or precedent was the stated basis at dated decision points: R p.147 (51-E, "Ref. STS 41-C FRR"); R pp.137–138 (the waiver criterion); R p.96 (reconstructed "24 previous times").
4. Protective behavior fell: the constraint was waived six times and not escalated (R pp.84, 137, 139); the problem was closed in PAS (R p.144); there was no redesign or grounding (R p.120).
5. The hazard persisted (R pp.139, 148; R p.72).

*Against or limiting:*
1. Formal criticality tightened in 1982, and a constraint was added in 1985. The only formal relaxation (1983) has documented non-success rationales (R pp.126–128).
2. The fatal disturbance was **outside** the experience base (R p.70), not a comparable shock.
3. For the final decision, communication and containment (R pp.82, 84, 88, 104) and customer accommodation (R p.104) are documented as decisive.

*Grading rules applied:*
- **Not contradicted.** Decisions did not follow the unchanged criteria (R p.139).
- **Not "not identifiable".** The changes are dated and partly attributed.
- **Causal identification incomplete.**

**Columbia: Partially supported. This is the stronger of the two on the "prior success cited" component.**

*Documented components:*
1. Foam loss on most imaged flights, and seven bipod losses (C pp.122–124).
2. A dated, contemporaneous downgrading of the disposition, ending in the STS-112 "action" (C p.125). This had a rule-mediated consequence: no FRR discussion was required at STS-107 (C p.126).
3. **Explicit, contemporaneous reliance on prior success**: the "112 flights" slide (C p.125), accepted by Program management (C p.126); during STS-107, "similar to what we've had on other flights" (C p.162) and Schomburg's prior-hits argument (C p.155).
4. Protective behavior fell: no IFA, no HR 37 update, no configuration change (C p.126), imagery declined (C pp.153–154).
5. The hazard persisted and was acknowledged (C pp.130, 155).

*Against or limiting:*
1. Formal requirements unchanged (C pp.122, 130).
2. Schedule pressure: CAIB weighs it as "equally influential" (C p.198) and links it to the STS-112 decision (C p.125).
3. Engineering errors and communication failures (C pp.142, 157, 172).
4. The relabel to "accepted risk" at STS-113 was arguably *more* cautious in wording (C p.126).
5. STS-107's strike was similar in size and source to STS-112 but hit a different site (C p.146), so the shock is only partly comparable.
6. Ham's own contemporaneous judgment that the success-based rationale was "lousy" (C p.148) shows that the threshold was not held uncritically by the decision-maker. This complicates a simple threshold-drift account.

**Overall: Partially supported (Level 2, practice-level form only).**

| Component of H5 / V.3 | Challenger | Columbia |
|---|---|---|
| Repeated success despite known anomalies | documented | documented |
| Formal acceptance criteria relaxed on success grounds | **not documented** (formal criteria tightened; the 1983 waiver has other rationales) | **not documented** (requirement unchanged) |
| Executed thresholds / decision rules changed, dated | documented (1984, 1985, 1985–86) | documented (1990–2002 sequence; Oct 2002) |
| Prior success or experience cited as justification | documented (precedent; experience base; reconstructed "24 times") | documented, contemporaneous ("112 flights"; "similar to … other flights") |
| Protective behavior reduced, hazard not removed | documented | documented |
| Reset after a large event (V.3 ingredient 2) | consistent: constraint imposed after 51-B (R p.137) | consistent: STS-27R inspection (C p.127); STS-87 out-of-family (C p.129) |
| Relaxation as a function of calm length (V.3 ingredient 3) | **not identifiable**; relaxation after 51-B was immediate, with no calm interval | **not identifiable**; ordinal and qualitative only |
| Later comparable shock (V.3 ingredient 4) | **fails**: 36°F was outside the envelope (R p.70) | partly (C p.146) |
| Survives the rivals | no (communication, containment, customer pressure) | no (schedule co-equal) |

---

## 6. Competing explanations and negative controls

**Persistent hazard with unchanged criteria.**
- *Holds for:* the hazard. Both hazards pre-dated the flight experience:
  - Marshall called the joint design "completely unacceptable" in 1979 (R pp.122–123, per the extractor; the R p.148 summary was verified by me);
  - the debris requirement was never met (C p.130).
- *Does not hold for:* "unchanged criteria". Executed thresholds did change, and the decisions departed from formal criteria. This rival is therefore a necessary background condition, not a full alternative.

**Engineering-judgment failure.**
- *Documented:* no temperature trend analysis (R p.148, Finding 6); comparison of distress flights only (R p.145, per the extractor); misread foam mechanisms (C p.130).
- *Not separable from H5.* The judgments recorded at the decision points are themselves experience-based:
  - Schomburg's "That is what I expect this time" from prior hits (C p.155);
  - the "in-family" rationale (C p.129);
  - "within our experience base" (R p.137).

  With these records, "bad judgment" and "judgment anchored on prior success" cannot be distinguished. This is the main reason Level 3 is not reached.

**Schedule pressure.**
- *Columbia:* documented and weighted co-equal (C pp.125, 139, 198).
- *Challenger:* the Ch. VIII finding that the system was "stretched to the limit" is per the extractor and was not re-verified by me (Ch. VIII not re-fetched). "Accommodate a major customer" is verified (R p.104). The disputed STS-6 link to the waiver is at R p.128.
- *Effect on H5:* schedule pressure can produce the same downgrades without any success-conditioning. It is not excluded.

**Communication failure.**
- *Challenger:* decisive for the final launch decision. Levels I and II were unaware of the constraint and waivers (R p.84), and informed decision-makers would "highly unlikely" have launched (R p.82).
  - This rival explains *who knew*. H5 explains *why Level III thought it acceptable*. The two operate at different levels and are compatible.
  - For the final decision, however, the record attributes the outcome to information flow and customer accommodation more than to a changed threshold held by the launch authority.
- *Columbia:* documented (C p.172), and it co-occurs with the success-based framing.

**Negative controls: anomalies that did trigger protective action.**
- **STS-27R (Dec 1988).** On FD2 the crew was directed to inspect with the RMS camera, and IFAs were assigned (C p.127). Paired with STS-107, this is the closest documented analogue to V.3's "same shock after short vs long calm":
  - 1988 came two years after Challenger, and an inspection was ordered;
  - 2003 came after 87 missions without a major incident (C p.199), and inspection was declined (C p.127).

  It is **confounded**:
  - Columbia carried no RMS arm on STS-107 (C p.127);
  - management, schedule and mission type differed;
  - the 1988 IFAs were still closed quickly (C p.127).

  It is suggestive, not identifying.
- **STS-87 (1997).** Out-of-family; an IFA held open across nine missions with a fix programme (C p.129).
- **51-B (1985).** Prompted a launch constraint (R p.137) and the Boisjoly memo of 31 Jul 1985 (R p.139). A tightening after a severe event.
- **1982 reclassification to Criticality 1** on test evidence (R p.126). Formal protective tightening.
- **STS-107.** USA's out-of-family classification and contingency plan worked as designed (C pp.142, 166).
- **Strong-signal anomalies grounded the fleet** "sometimes for months" (C p.197).

These controls show that protective rules did fire, mostly early or after severe events. That is consistent with V.3's reset-after-shock ingredient. It is equally consistent with the rival that the protective rules functioned and the failure lay in specific management decisions.

---

## 7. Prediction-test feasibility

No numeric parameter is derived.

- **M7 (protective margin series).**
  - *Challenger:* a few analytic values exist: a predicted maximum of .090 in., demonstrated sealing at .095 in. (R pp.133, 147), a revised maximum of .070 in. (R p.147), and one observation of .171 in. (R p.137). These are not a dated series of an acceptance margin against a disturbance measure. The revision .090 → .070 lowered the *predicted* erosion; it is not a relaxed threshold. The cell values of Rogers Fig. 2 are unreliable in the HTML transcription (extractor).
  - *Columbia:* disposition categories are ordinal. Ranking them into a "margin" would be our construction, which the protocol does not allow as a measured margin.
  - **M7 is not available.**
- **M8 (calm-conditioned relaxation).**
  - "Calm" cannot be defined independently of "success": anomalies recurred on most flights (88% after the 200 psi nozzle check, R p.134; foam on 65 of 79 imaged missions, C p.122).
  - The 1985 relaxation was immediate after the triggering event.
  - **Not testable.**
- **M9 (predictive discrimination).**
  - There are two accidents and no comparison units in these sources.
  - The pre-specified "recent success" baseline coincides with H5's own driver, so discrimination is not identifiable.
  - **Not feasible.**
- **What is feasible.** A qualitative contemporaneous snapshot (e.g., at 31 Oct 2002 or Jul 1985) shows that warnings existed before each accident:
  - SIAT 1999 (C p.179);
  - the Boisjoly memo (R p.139);
  - Austin's "PRECLUDE" e-mail (C p.155).

  Without the base rate of such warnings on flights that did not fail, the snapshot has no discriminating value.

---

## 8. Limitations and source conflicts

1. **CAIB p.196 vs Rogers on criticality direction.**
   - CAIB says the joint was "elevated to a Criticality 1 item … later demoted to a Criticality 1-R".
   - Rogers' dated record is the reverse: 1R (24 Nov 1980) → 1 (17 Dec 1982) → waiver (28 Mar 1983) (R pp.125–128).
   - Rogers also notes that documents kept calling the joint "1-R" long after the change (R p.128). CAIB's sentence matches that informal usage, not a formal reclassification.
   - This report uses Rogers. **Any claim that formal criticality was downgraded rests only on CAIB p.196 and is not used.**
2. **Feynman is cited only indirectly**, via CAIB p.130 and Rogers p.148 (Finding 3). Rogers Vol. 2 App. F was not read by either analyst.
3. **Mulloy's "24 previous times" (R p.96)** is a retrospective reconstruction ("may have been expressed by me using some of those words"). It is used as weak evidence of a contemporaneous argument.
4. **Board interpretation versus record.** CAIB's normalization-of-deviance framing (C pp.130, 181, 196–197, citing Vaughan) and Rogers' "got away with it" finding (R p.148) are RETRO interpretations of the very mechanism under test. They are reported but not counted as independent support.
5. **Hindsight.** CAIB itself cautions: "Taken one at a time, each decision seemed correct" (C p.197). The analyst's prior knowledge of both outcomes cannot be blinded.
6. **Missing sources.**
   - Not read: CAIB Appendix D.13 (rescue and repair detail), the SIAT 1999 report, Vaughan, the 1986 House report, and Rogers Vols. 2–5.
   - National imaging capabilities are not documented in Vol. I, so whether DoD imagery could have resolved the damage is unknown.
7. **Items not re-verified by me** (relied on the extractor, marked where used):
   - R pp.122–123 (1979 memo);
   - R p.145 (comparison of distress flights only);
   - Rogers Ch. VIII (schedule finding);
   - CAIB p.171 (Crater; "judgment and experience").
8. **Page conventions.** Rogers pages are the HTML transcription's printed-page markers. I confirmed that a marker precedes its page's content.

---

## Escalations to the study owner

- **E1. Section 3 label: resolved by the coordinator.** "Ruled out" when a necessary condition is positively contradicted by evidence; "not identifiable" when evidence is missing; the same convention applies across all cases. Applied here, severity 3 is **ruled out** for every Challenger decision examined and for the documented Columbia imagery/rescue path, because item (c) is positively contradicted. Severity 1 or 2 remains **not identifiable**, because the evidence on viability is missing or only conditional.
- **E2. Mapping "success despite anomaly" to V.3's "calm".** The pre-registration calls Case E an institutional analogue. If the owner requires V.3's calm-length dependence (ingredient 3) for "support", Case E is **not identifiable** for V.3 specifically, while H5 as worded remains partially supported.
- **E3. Rescue class.** Classifying the Columbia rescue as **adapt** (plans not yet existing) rather than policy makes the in-flight state a severity-2 candidate, outside V.3's model. Either way it is not established.
- **E4. The Challenger shock was not comparable.** The 51-L temperature was outside all prior experience (R p.70). V.3's "identical later shock" premise fails for Challenger. The case supports threshold drift at most, not V.3's calm-failure mechanism.
- **E5. Ledger corrections** (see `caseE_verification.md`):
  - the Aug 1985 HQ briefing is R p.139, not p.140;
  - the 1983 waiver was granted by Levels I **and II**;
  - re-tag R p.96 as RETRO testimony;
  - add CAIB p.173 (the rescue study assumed inconclusive imagery and an EVA inspection), R Ch. IV pp.70/72, and CAIB p.155 (Austin "PRECLUDE"; Schomburg prior-hits) as new ledger rows.
