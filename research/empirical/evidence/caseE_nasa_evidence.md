# Case E: NASA Challenger (STS 51-L, 28 Jan 1986) and Columbia (STS-107, 1 Feb 2003): evidence extraction

This file collects evidence only. It does not grade the hypothesis. Hypothesis under test, which is not assumed: *repeated successful flights despite known anomalies changed acceptance thresholds or decision rules, reducing protective behavior without removing the hazard.*

## Sources actually read

| ID | Document | Publication date | URL fetched | Archive check |
|---|---|---|---|---|
| CAIB | Columbia Accident Investigation Board, *Report Volume I* | August 2003 (per page footers "Report Volume I August 2003"; NTRS metadata publicationDate 2003-08-01) | https://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/20030066167.pdf (an HTML landing page). The PDF itself came from https://ntrs.nasa.gov/api/citations/20030066167/downloads/20030066167.pdf (180 MB, 248 pp.) | Wayback availability API reports a status-200 snapshot: http://web.archive.org/web/20240504135944/https://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/20030066167.pdf. The snapshot's content was not compared. |
| ROG-5/6/7/8 | Report of the Presidential Commission on the Space Shuttle Challenger Accident (Rogers Commission), Vol. 1, Chapters V, VI, VII and VIII | June 6, 1986 (date on NASA index page genindex.htm) | https://history.nasa.gov/rogersrep/v1ch5.htm, v1ch6.htm, v1ch7.htm, v1ch8.htm | Wayback availability API reports status-200 snapshots, e.g. http://web.archive.org/web/20231004024547/https://history.nasa.gov/rogersrep/v1ch6.htm (v1ch5 20230506174838; v1ch7 20230815173152; v1ch8 20230405211316). Content was not compared. |

**Page numbers.**
- CAIB: the printed page number. In this PDF, the PDF page index equals the printed page number (checked across the whole document).
- Rogers: the bracketed page markers ([120] and so on) that NASA's HTML transcription embeds for the printed Volume 1. Rogers Figure 2 (the O-ring anomaly table, pp. 129–131) is rendered in HTML as flattened text.

**Text handling.**
- CAIB text was extracted with pdftotext. The extraction turned apostrophes into a modifier-letter character, which I normalized back to "'". Line-break hyphens were dropped by the extractor in a few words (e.g., "safetyof-flight", "sleightof-hand"). I reproduced those exactly as extracted, so a few quoted words may differ from the printed hyphenation.
- Rogers text is quoted as it appears in the NASA HTML, typos included (e.g., "duly 29" for "July 29").

**Tags.**
- **CONTEMPORANEOUS**: the fact, document or statement existed and was available to at least some NASA or contractor decision-makers before the relevant accident. Many such documents are known only as the investigation reproduced them, and this is noted.
- **RETROSPECTIVE**: a finding, interpretation or discovery made by the investigating body after the accident.

**Confidence** is about the accuracy of the extraction and attribution: High means a verbatim quote with a verified page. It is not a judgment of whether the report's conclusion is correct.

---

## Q1. Anomaly chronologies

### Q1(a) O-ring erosion and blow-by before Challenger (Rogers Ch. VI unless noted)

| # | Event date | Fact (verbatim) | Source / page | Tag | Conf. |
|---|---|---|---|---|---|
| 1a-1 | 1977–1979 | Pre-flight test evidence. 1977 hydroburst test: "contrary to design expectations, the joint tang and inside clevis bent away from each other instead of toward each other ... This phenomenon was called 'joint rotation.'" Marshall memo of Jan 19, 1979: "We find the Thiokol position regarding design adequacy of the clevis joint to be completely unacceptable...." | ROG-6 pp. 122–123 | CONTEMPORANEOUS (internal memos) | High |
| 1a-2 | 24 Nov 1980 | "on November 24, 1980, the Solid Rocket Booster joint was classified on the Solid Rocket Booster Critical Items List as criticality category 1 R." The same 1980 CIL says: "It is not known if the secondary O-ring would successfully reseal if the primary O-ring should fail after motor case pressure reaches or exceeds 40 percent of maximum expected operating pressure." | ROG-6 p. 125 | CONTEMPORANEOUS | High |
| 1a-3 | Nov 1981 (STS-2) | "After the second flight, STS-2, in November 1981, inspection revealed the first in-flight erosion of the primary O-ring ... erosion depth of .053 inches ... nonetheless, the anomaly was not reported in the Level I Flight Readiness Review for STS-3 held on March 9, 1982. Furthermore, in 1982 the STS-2 O-ring erosion was not reported on the Marshall problem assessment system and given a tracking number as were other flight anomalies." | ROG-6 p. 125 | CONTEMPORANEOUS (event); RETROSPECTIVE (non-reporting finding) | High |
| 1a-4 | 17 Dec 1982 | Reclassification from 1R to Criticality 1: "the Criticality 1R had to be changed to Criticality 1. This was done at Marshall on December 17, 1982." Revised CIL text: "Leakage of the primary O-ring seal is classified as a single-failure point due to possibility of loss of sealing at the secondary O-ring because of joint rotation after motor pressurization." | ROG-6 p. 126 | CONTEMPORANEOUS | High |
| 1a-5 | 1981–1983 | "prior to STS 41-B, the O-ring erosion/blow-by problem was infrequent, occurring on a field joint of STS-2 (November, 1981), nozzles of STS-6 (April, 1983) and a nozzle of QM-4 (March, 1983)" | ROG-6 p. 128 | CONTEMPORANEOUS | High |
| 1a-6 | 3 Feb 1984 (STS 41-B) | "when STS 41-B flew on February 3, 1984, the left Solid Rocket Booster forward field joint and the right nozzle joint primary O-rings both suffered erosion damage." Marshall Problem Assessment entry: "Remedial action-none required; problem occurred during flight." March 8, 1984 entry: "Possibility exists for some O-ring erosion on future flights ... Therefore, this is not a constraint to future launches." | ROG-6 p. 128 | CONTEMPORANEOUS | High |
| 1a-7 | 30 Mar 1984 (41-C FRR) | "When the 41-B erosion was taken to the Level I Flight Readiness Review for 41-C on March 30, 1984, it was briefed as a 'technical issue'. A recommendation to fly 41-C was approved by Level I 'accepting the possibility of some O-ring erosion due to the hot gas impingement.'" Rationale: "Conservative analysis indicates max erosion possible: .090 in. ... capability to sustain joint sealing integrity at 3,000 psi pressure using an O-ring with a simulated .095 in. erosion depth. ... Recommendation: Fly STS 41-C accepting possibility of some O-ring gas impingement." | ROG-6 p. 132; p. 147 | CONTEMPORANEOUS | High |
| 1a-8 | 24 Jan 1985 (STS 51-C) | "The temperature of the O-rings at launch was 53 degrees, the coldest to that date. O-ring erosion occurred in both solid boosters ... This was also the first flight where a secondary O-ring showed the effect of heat." | ROG-6 pp. 134–135 | CONTEMPORANEOUS | High |
| 1a-9 | 8–21 Feb 1985 (51-E FRR) | Thiokol: "low temperature enhanced probability of blow-by-[flight] 51 -C experienced worst case temperature change in Florida history ... 'the condition is not desirable but is acceptable.'" At Level I (Feb 21, 1985) the analysis "had been reduced to a one page chart with the resolution: 'acceptable risk because of limited exposure and redundancy (Ref. STS 41-C FRR)'. No mention of temperature was found in the Level I report." | ROG-6 p. 136; p. 147 | CONTEMPORANEOUS | High |
| 1a-10 | 29 Apr 1985 flight (51-B); found 25 Jun 1985 | "The primary O-ring seal had been compromised because it eroded .171 inches and it did not seal. The secondary O-ring did seal, but it had eroded .032 inches." | ROG-6 p. 137 | CONTEMPORANEOUS | High |
| 1a-11 | Jul 1985 | "Upon receiving the report of the 51-B primary ring failure, Solid Rocket Booster Project Manager Mulloy and the Marshall Problem Assessment Committee placed a 'launch constraint' on the Shuttle system ... The constraint applied to STS 51-F and all flights subsequent, including STS 51-L." | ROG-6 p. 137 | CONTEMPORANEOUS | High |
| 1a-12 | Apr 1985 – Jan 1986 | "Joint seal problems occurred in each of the next four Shuttle flights" (51-D, 51-B, 51-G, 51-F). 61-A (Oct 30, 1985) "experienced nozzle O-ring erosion and field joint O-ring blow-by. These anomalies were not mentioned at the Level I Flight Readiness Review for flight 61-B." | ROG-6 p. 136; p. 141 | CONTEMPORANEOUS (events); RETROSPECTIVE (FRR omission finding) | High |
| 1a-13 | Jan 1984 onward | Leak-check change and frequency: "when the leak check stabilization pressure was officially boosted to 200 psi for STS 41-B, over half the Shuttle missions experienced field joint O-ring blow-by or erosion of some kind ... Following the implementation of the 200 psi check on the nozzle, 88 percent of all flights experienced erosion or blow-by." | ROG-6 pp. 133–134 | RETROSPECTIVE (Commission staff analysis of contemporaneous data) | High |
| 1a-14 | to Jan 1986 | Temperature: "only three incidents of O-ring thermal distress occurred out of twenty flights with O-ring temperatures at 66 degrees Fahrenheit or above, whereas, all four flights with O-ring temperatures at 63 degrees Fahrenheit or below experienced O-ring thermal distress." | ROG-6 p. 145 | RETROSPECTIVE (analysis); the data were contemporaneous | High |

The flattened Figure 2 table (ROG-6 pp. 129–131) lists flights with field or nozzle erosion or blow-by: STS-2, STS-6, 41-B, 41-C, 41-D, 51-C, 51-D, 51-B, 51-G, 51-F, 51-I, 61-A, 61-B, 61-C. Exact cell values are hard to read reliably in the HTML flattening, so I report flight membership only.

### Q1(b) Foam shedding and debris strikes (CAIB Ch. 6.1 unless noted)

| # | Event date | Fact (verbatim) | Source / page | Tag | Conf. |
|---|---|---|---|---|---|
| 1b-1 | design baseline | Requirement 3.2.1.1.17: "No debris shall emanate from the critical zone of the External Tank on the launch pad or during ascent except for such material which may result from normal thermal protection system recession due to ascent heating." The TPS was to "withstand impacts with a kinetic energy less than 0.006 foot-pounds." | CAIB p. 122 | CONTEMPORANEOUS (requirement) | High |
| 1b-2 | 12 Apr 1981 (STS-1) | "Columbia sustained damage from debris strikes on its inaugural 1981 flight. More than 300 tiles had to be replaced." | CAIB p. 122 | CONTEMPORANEOUS | High |
| 1b-3 | 18 Jun 1983 (STS-7) | First known bipod ramp loss. "the Program Requirements Control Board cited the foam loss as an In-Flight Anomaly ... At the Flight Readiness Review for the next mission ... the bipod ramp foam loss In-Flight Anomaly was resolved, or 'closed.' However ... neither the Certificate of Flight Readiness documentation nor the Flight Readiness Review documentation referenced correcting the cause of the damage – the shedding of foam." | CAIB p. 123 | CONTEMPORANEOUS (classification); RETROSPECTIVE (critique) | High |
| 1b-4 | 2 Dec 1988 (STS-27R) | "the largest debris event up to that time ... 707 dings, 298 of which were greater than an inch ... the debris had knocked off a tile." The crew was "immediately directed to inspect the vehicle." "the Program Requirements Control Board assigned In-Flight Anomalies to the Orbiter and Solid Rocket Booster Projects ... the issue was considered 'closed' by the time of the next mission's Flight Readiness Review." | CAIB p. 127 | CONTEMPORANEOUS | High |
| 1b-5 | 9 Jan 1990 (STS-32R) | Second bipod loss. "An In-Flight Anomaly assigned to the External Tank Project was closed out at the Flight Readiness Review for the next mission, STS-36, on the basis that there may have been local voids in the foam." | CAIB p. 124 | CONTEMPORANEOUS | High |
| 1b-6 | Dec 1990 (STS-35) | "An In-Flight Anomaly was assigned ... which closed it by stating that there was no increase in Orbiter Thermal Protection System damage and that it was 'not a safety-of-flight concern.' The Board notes that it was in a discussion at the STS-36 Flight Readiness Review that NASA first identified this problem as a turnaround issue." | CAIB p. 128 | CONTEMPORANEOUS | High |
| 1b-7 | 22 Jan 1992 (STS-42) | IFA assigned; "at later Flight Readiness Reviews, the Marshall Space Flight Center briefed this as being 'not a safety-of-flight' concern. The next flight, STS-45, would be the first mission launched before the foam-loss In-Flight Anomaly was closed." | CAIB p. 129 | CONTEMPORANEOUS | High |
| 1b-8 | 25 Jun 1992 (STS-50) | Third bipod loss; "the largest area of tile damage in Shuttle history." "The Integration Office closed out its In-Flight Anomaly two days before the next flight, STS-46, by deeming damage to the Thermal Protection System an 'accepted flight risk.' ... The External Tank Project closed out its In-Flight Anomaly with the rationale that foam loss during ascent was 'not considered a flight or safety issue.'" | CAIB p. 124 | CONTEMPORANEOUS | High |
| 1b-9 | 22 Oct 1992 (STS-52); 4 Mar 1994 (STS-62) | Fourth and fifth bipod losses: "Because these incidents of missing bipod foam were not detected until after the STS-107 accident, no In-Flight Anomalies had been written." | CAIB p. 124 | RETROSPECTIVE (discovered by the Board) | High |
| 1b-10 | 1993 (STS-56, STS-58) | "the rationale for closing the In-Flight Anomalies included notations that the External Tank foam debris was 'in-family,' or within the experience base." These missions "demonstrate the increasingly casual ways in which debris impacts were dispositioned." | CAIB p. 129; note 29, p. 176 | CONTEMPORANEOUS (closure rationale); RETROSPECTIVE (characterization) | High |
| 1b-11 | 19 Nov 1997 (STS-87) | 308 hits; "considered 'out-of-family.'" An IFA stayed open over nine missions of fixes. "Following STS-101 ... the Program Requirements Control Board concluded that foam-shedding from the thrust panel had been reduced to an 'acceptable level' by sanding and venting, and the In-Flight Anomaly was closed." The Board notes "these interventions merely reduced foam-shedding to previously experienced levels." The Fig. 6.1-7 summary says: "In-Flight Anomaly eventually closed after STS-101 as 'accepted risk.'" | CAIB p. 129; Fig. 6.1-7 p. 128 | CONTEMPORANEOUS; RETROSPECTIVE (Board note) | High |
| 1b-12 | 7 Oct 2002 (STS-112) | Sixth bipod loss; debris hit the SRB External Tank Attach ring (dent about 4 in. wide, 3 in. deep). "the Intercenter Photo Working Group recommended that the loss of bipod foam be classified as an In-Flight Anomaly ... the Program Requirements Control Board ultimately decided against such classification ... assigned an 'action' to the External Tank Project ... This was inconsistent with previous practice." Fig. 6.1-7: "First time major debris event not assigned an In-Flight Anomaly." | CAIB pp. 124–125, 128 | CONTEMPORANEOUS (decision); RETROSPECTIVE (characterization) | High |
| 1b-13 | 16 Jan 2003 (STS-107) | Seventh bipod loss; strike on the left wing about 81.9 s after launch (CAIB p. 195). Initially "classified as 'out-of-family' and therefore of greater concern than previous debris strikes." After the accident, "the Program Requirements Control Board deemed the foam loss an In-Flight Anomaly." | CAIB p. 143; p. 126; p. 195 | CONTEMPORANEOUS (out-of-family classification); RETROSPECTIVE (post-accident IFA) | High |
| 1b-14 | aggregate | "Photographic evidence of foam shedding exists for 65 of the 79 missions for which imagery is available." Left bipod loss on "approximately 10 percent of flights (seven events out of 72 imaged flights)." | CAIB pp. 122–123 | RETROSPECTIVE (compiled by the Board) | High |

CAIB definitions box (p. 122):
- "In Family: A reportable problem that was previously experienced, analyzed, and understood. Out of limits performance or discrepancies that have been previously experienced may be considered as in-family when specifically approved by the Space Shuttle Program or design project."
- "Accepted Risk: The threat ... is known and understood, cannot be completely eliminated, and the circumstance(s) producing that threat is considered unlikely to reoccur."
- "No Safety-of-Flight-Issue: The threat ... is known and understood and does not pose a threat to the crew and/or vehicle."

---

## Q2. Changes in formal criteria or decision rules (dated)

### Challenger (Rogers)

**Q2-1. Criticality 1R to 1, 17 Dec 1982.** This change made the classification more conservative, not less: "the Criticality 1R had to be changed to Criticality 1. This was done at Marshall on December 17, 1982." (ROG-6 p. 126; CONTEMPORANEOUS; High.)
- Justification given: test evidence of joint rotation ("Because of May 1982 high pressure O-ring tests and tests of the new lightweight motor case, Marshall management finally accepted the conclusion that the secondary O-ring was no longer functional ...", p. 125–126).
- Prior flight success was **not** cited for the reclassification itself.
- The "Rationale for Retention" (Dec 1, 1982, Thiokol's McIntosh) cites "the Titan history, the leak and hydroburst tests, and static motor firings as justification" (p. 126).

**Q2-2. Waiver of the Criticality 1 status, 28 Mar 1983.** "This waiver was approved to avoid the obligations imposed on the Shuttle Program by Paragraph 2.8 of the Space Shuttle Program Requirements Document, Level I, dated June 30, 1977" (fail-safe redundancy requirement) (p. 127). "approved by Associate Administrator for Space Flight (Technical), L. Michael Weeks on March 28, 1983. Weeks told the Commission he signed the waiver because of the Certification/Verification Review of the Propulsion Committee in 1980" (p. 128). CONTEMPORANEOUS (waiver); High.
- Justification: Weeks: "We felt at the time-all of the people in the program I think felt that this Solid Rocket Motor in particular or the Solid Rocket Booster was probably one of the least worrisome things we had in the program."
- Disputed schedule link: "According to interviews of Arnold Aldrich and of Richard Kohrs ... the waiver was approved so that STS-6 could fly. However, Weeks denied any connection" (p. 128).
- The process ran outside the formal board: "The criticality waiver was processed outside the formal NASA Program Requirements Control Board, however, representatives of that group 'signed off'" (p. 128).
- Partial persistence of the old view: "several documents tracking the O-ring erosion at Thiokol and Marshall refer to the Solid Rocket Motor field joint seal as Criticality 1-R, long after the status was changed to Criticality 1" (p. 128). RETROSPECTIVE.

**Q2-3. Acceptance threshold set by an erosion-margin model, Mar 1984.** After 41-B, the "safety margin" (max predicted .090 in. vs. sealing demonstrated at .095 in.) "was the basis for approving Shuttle flights while accepting the possibility of O-ring erosion" (ROG-6 p. 133). Level I approved 41-C on Mar 30, 1984 "accepting the possibility of some O-ring erosion" (p. 132). CONTEMPORANEOUS; High. This is an explicit decision rule: fly if observed or predicted erosion is within the modelled margin.

**Q2-4. Threshold moved after experience exceeded the model (Commission questioning, May 2, 1986 hearing).** RETROSPECTIVE testimony about contemporaneous practice; High.
- Hotz: "So then you decided to introduce a standard based on the measurement or the possibility of the limits of O-ring erosion. And as those limits, as the experience went up, your criteria for, say, flight went up too. In other words, when you experienced more than maximum anticipated O-ring erosion, you waived the flight and said 'Well, it's possible to tolerate that. We still have a margin left.'" Mulloy (asked whether he meant the case with no primary seal): "Yes, sir. That is correct." (ROG-6 pp. 144–145)
- Keel noted the FRR margin was "roughly, five and a half" percent (90 vs 95 thousandths) (p. 145).
- At the 51-F Level I FRR (July 2, 1985), "There was no mention of the fact that .171 inches of erosion on the primary O-ring far exceeded a more recent analysis model prediction of .070 inches maximum possible erosion. This was a revision of the former prediction of .090 inches." (p. 147)

**Q2-5. Leak-check pressure raised.** Nozzle: 50 to 100 psi before STS-9 (Nov 1983); to 200 psi for 51-D (Apr 1985) and 51-G (Jun 1985) onward. Field: 200 psi for 41-B (Jan/Feb 1984). This raised the incidence of anomalies: "Thiokol recommended and NASA accepted the increased pressure to ensure that the joint actually passed the integrity tests." (ROG-6 pp. 133–134; CONTEMPORANEOUS procedure change, RETROSPECTIVE linkage; High.) This is a procedural change. It does not change an acceptance threshold.

**Q2-6. Launch constraint imposed (Jul 1985), then waived for every flight.** "After the launch constraint was imposed, Project Manager Mulloy waived it for each Shuttle flight after July 10, 1985." (ROG-6 p. 137.) CONTEMPORANEOUS; High.
- Rule definition (1980 Marshall letter): "All open problems coded Criticality 1, 1R, 2, or 2R will be considered launch constraints until resolved ... or sufficient rationale ... exists to conclude that this problem will not occur" (p. 137).
- Mulloy's operational meaning: "present the data as to whether or not what we have seen in our most recent observation ... is within our experience base and whether or not the previous analysis and tests that previously concluded that was an acceptable situation is still valid" (pp. 137–138).
- In this rule, prior experience (the "experience base") is the explicit criterion.
- The Commission found: "The Commission has also not found any mention of the duly [sic, July] 1985 constraint, or its waiver for subsequent Shuttle flights, in any Flight Readiness Review briefing documents." (p. 147)

**Q2-7. Problem closure, Dec 1985 – Jan 1986.** Thiokol requested closure on Dec 10, 1985. Marshall's Problem Assessment reports were annotated "contractor closure received" on Dec 18, 1985 and "problem is considered closed" on Jan 23, 1986 (ROG-6 pp. 143–144).
- Russell, asked why he would close it out: "Because I was asked to do it." (p. 143)
- Mulloy and Wear testified the closure entries were "in error". Mulloy: "this did not come up in the Flight Readiness Review as an open launch constraint ... because the PAS system showed the problem was closed, and that was an error." (p. 144)
- CONTEMPORANEOUS (entries); High.
- Commissioner Rummel (hearing): "you're closing it out because you don't want to be bothered." (p. 143; RETROSPECTIVE commentary.)

**Q2-8. No launch commit criterion for joint temperature (Jan 27, 1986).** Mulloy: "there are currently no Launch Commit Criteria [LCC] for joint temperature. What you are proposing to do is to generate a new Launch Commit Criteria on the eve of launch, after we have successfully flown with the existing Launch Commit Criteria 24 previous times. With this LCC ... we may not be able to launch until next April." (ROG-5 p. 96.) Mulloy also said: "There was no violation of Launch Commit Criteria. There was no waiver required in my judgment at that time and still today." (ROG-5 p. 98.) CONTEMPORANEOUS reasoning reported in RETROSPECTIVE testimony; High. This item explicitly cites prior successful flights as a reason not to adopt a new, stricter rule.

**Q2-9. Commission summary of trends in FRRs.** ROG-6 p. 148; RETROSPECTIVE; High. "Third, because of a belief that in-flight O-ring erosion was 'within the data base' of prior experience, later Flight Readiness Reviews gave a cursory review and often dismissed the recurring erosion as within 'acceptable' or 'allowable' limits. Fourth, both Thiokol and Marshall continued to rely on the redundancy of the secondary O-ring long after NASA had officially declared that the seal was a non-redundant single point failure."

### Columbia (CAIB)

**Q2-10. Foam reclassified over time.** RETROSPECTIVE synthesis of contemporaneous documents; High.
- STS-35/STS-36 FRR (Dec 1990 – early 1990): "first identified this problem as a turnaround issue" (CAIB p. 128).
- STS-42 to STS-45 (1992): first launch before foam IFA closure (p. 129).
- STS-50 (1992): "accepted flight risk" vs "not considered a flight or safety issue" (p. 124).
- STS-56/58 (1993): "in-family" closure rationale (p. 129).
- STS-87 to STS-101: closed at an "acceptable level" (p. 129).
- STS-112 (Oct 2002): "action" instead of IFA (p. 125).

**Q2-11. "In-family" category introduced post-Challenger (date not given).** "Although 'in-family' was a designation introduced post-Challenger to separate problems by seriousness so that 'out-of-family' problems got more attention, by definition the problems that were shifted into the lesser 'in-family' category got less attention." (CAIB p. 196.) RETROSPECTIVE; High. The report gives no exact date for this change.

**Q2-12. STS-113 Flight Readiness Review, 31 Oct 2002: prior success cited explicitly.** CONTEMPORANEOUS document; High. This is the clearest instance in either report of prior flights being cited as the stated justification for continuing.
- External Tank Project "Rationale for Flight" slide (presenter Jerry Smelser, dated October 31, 2002), as reproduced in CAIB Fig. 6.1-5, p. 125:
  - "Current bipod ramp closeout has not been changed since STS-54 (ET-51)"
  - "The Orbiter has not yet experienced 'Safety of Flight' damage from loss of foam in 112 flights (including 3 known flights with bipod ramp foam loss)"
  - "There have been no design / process / equipment changes over the last 60 ETs (flights)"
  - "Probability of loss of ramp TPS is no higher/no lower than previous flights"
  - "The ET is safe to fly with no new concerns (and no added risk)"
- Background slide: "ET TPS Foam loss over the life of the Shuttle Program has never been a 'Safety of Flight' issue"
- Outcome: "STS-113 Flight Readiness Review participants ultimately agreed that foam shedding should be characterized as an 'accepted risk' rather than a 'not a safety-of-flight' issue. Space Shuttle Program management accepted this rationale, and STS-113's Certificate of Flight Readiness was signed." (CAIB p. 126)
- Board assessment (RETROSPECTIVE): "This rationale is seriously flawed. The first and third statements ... are incorrect ... the bipod ramp design had changed, as of External Tank-76 ... With no engineering analysis, Shuttle managers used past success as a justification for future flights, and made no change to the External Tank configurations planned for STS-113, and, subsequently, for STS-107." (p. 126)
- The NASA HQ Safety Office "presented a report that estimated a 99 percent probability of foam not being shed from the same area ... a calculation of the actual rate of bipod loss over 61 flights." The Board called this "a sleightof-hand effort" (p. 126; CONTEMPORANEOUS report, RETROSPECTIVE critique).

**Q2-13. Corrective-action deadline slipped past two flights.** "The Program Requirements Control Board initially set December 5, 2002, as the date to report back on this action, even though STS-113 was scheduled to launch on November 10. The due date subsequently slipped until after the planned launch and return of STS-107." (CAIB p. 125.) CONTEMPORANEOUS; High.

**Q2-14. Program rules did not require STS-112 foam discussion at the STS-107 FRR.** "the STS-107 Flight Readiness Review documents include no discussion of the still-unresolved STS-112 foam loss. According to Program rules, this discussion was not a requirement because the STS-112 incident was only identified as an 'action,' not an In-Flight Anomaly." (CAIB p. 126.) CONTEMPORANEOUS rule; RETROSPECTIVE finding; High. This is how the reclassification (Q2-12/13) changed what later reviews had to consider.

**Q2-15. No rule to update hazard analyses after anomalies.** "although there is a process for conducting hazard analyses when the system is designed and a process for re-evaluating them when a design is changed or the component is replaced, no process addresses the need to update a hazard analysis when anomalies occur." (CAIB p. 126; RETROSPECTIVE; High.) Hazard Report 37 was not updated (p. 126).

**Q2-16. CAIB on downgraded classifications in both programs.** RETROSPECTIVE; High.
- "NASA documents show how official classifications of risk were downgraded over time. Program managers designated both the foam problems and O-ring erosion as 'acceptable risks' in Flight Readiness Reviews ... when major bipod foam-shedding occurred on STS-112 in October 2002, Program management did not assign an In-Flight Anomaly. Instead, it downgraded the problem to the lower status of an 'action' item." (CAIB p. 196)
- "The joint was later demoted to a Criticality 1-R (redundant), and then in the month before Challenger's launch was 'closed out' of the problem-reporting system." (CAIB p. 196)
- **Discrepancy flag:** the CAIB summary on p. 196 says the joint "had been elevated to a Criticality 1 item ... The joint was later demoted to a Criticality 1-R." Rogers (ROG-6 pp. 125–126) gives the dated sequence the other way round: 1R from Nov 24, 1980, then changed to Criticality 1 on Dec 17, 1982, then waived Mar 28, 1983. Rogers also reports documents that kept calling it "1-R" after the change (p. 128). The primary dated record (Rogers) does not support a formal 1 to 1R demotion. I record the conflict rather than resolve it.

**Q2-17. CAIB's mechanism statement.** "after the first incident the engineering analysis concluded that the design could tolerate the damage ... that first decision was a turning point. It established a precedent for accepting, rather than eliminating, these technical deviations. As a result of this new classification, subsequent incidents ... were not defined as signals of danger, but as evidence that the design was now acting as predicted. Engineers and managers incorporated worsening anomalies into the engineering experience base, which functioned as an elastic waistband ... Anomalies that did not lead to catastrophic failure were treated as a source of valid engineering data that justified further flights." (CAIB p. 196; RETROSPECTIVE interpretation, citing Vaughan; High.)

---

## Q3. Reliance on prior success (report findings)

1. **CAIB Executive Summary.** "Cultural traits and organizational practices detrimental to safety were allowed to develop, including: reliance on past success as a substitute for sound engineering practices (such as testing to understand why systems were not performing in accordance with requirements); organizational barriers that prevented effective communication of critical safety information ..." (CAIB p. 9; near-identical text in Ch. 7 intro, p. 177.) RETROSPECTIVE; High.
2. **CAIB Sec. 6.1.** "With each successful landing, it appears that NASA engineers and managers increasingly regarded the foam-shedding as inevitable, and as either unlikely to jeopardize safety or simply an acceptable risk." (CAIB p. 122.) RETROSPECTIVE; High.
3. **CAIB Sec. 6.1 conclusion on normalization of deviance.** "The acceptance of events that are not supposed to happen has been described by sociologist Diane Vaughan as the 'normalization of deviance.' The history of foam-problem decisions shows how NASA first began and then continued flying with foam losses, so that flying with these deviations from design specifications was viewed as normal and acceptable." (CAIB p. 130.) RETROSPECTIVE; High.
4. **Feynman, as quoted by CAIB.** "The acceptance and success of these flights is taken as evidence of safety. But erosions and blow-by are not what the design expected ... In these situations, subtly, and often with apparently logical arguments, the criteria are altered so that flights may still be certified in time." (CAIB p. 130, quoting Feynman's appendix to Rogers; Rogers Vol. 2 Appendix F itself was not fetched.) RETROSPECTIVE (1986); High for the CAIB quotation.
5. **CAIB Sec. 6.1 Findings list.** "Foam-shedding, which had initially raised serious safety concerns, evolved into 'in-family' or 'no safety-of-flight' events or were deemed an 'accepted risk.'" (CAIB p. 130.)
6. **CAIB Sec. 6.1 Findings list.** "No External Tank configuration changes were made after the bipod foam loss on STS-112." (p. 131.)
7. **CAIB Sec. 7.3, "Conditioned by Success".** "learned attitudes about foam strikes diminished management's wariness of their danger. The Shuttle Program turned 'the experience of failure into the memory of success.' Managers also failed to develop simple contingency plans for a re-entry emergency. They were convinced, without study, that nothing could be done about such an emergency." (CAIB p. 181.)
8. **CAIB Sec. 7.3.** "Over the course of 22 years, foam strikes were normalized to the point where they were simply a 'maintenance' issue." (p. 181.)
9. **1999 Shuttle Independent Assessment Team, as summarized by CAIB.** "the Shuttle Program was inappropriately using previous success as a justification for accepting increased risk" (CAIB p. 179). The finding dates from 1999, so it is CONTEMPORANEOUS to the Columbia period (available pre-accident). It reaches us via CAIB's summary; the SIAT report was not fetched. Confidence: Medium-High.
10. **CAIB Sec. 8.4.** "if success is measured by launches and landings, the machine appeared to be working successfully prior to both accidents. Challenger was the 25th launch. Seventeen years and 87 missions passed without major incident ... Prior to Challenger, the can-do culture was a result not just of years of apparently successful launches, but of the cultural belief that the Shuttle Program's many structures, rigorous procedures, and detailed system of rules were responsible for those successes." (CAIB p. 199.)
11. **CAIB Sec. 8.5.** "Cultural beliefs about the low risk O-rings and foam debris posed, backed by years of Flight Readiness Review decisions and successful missions, provided a frame of reference against which the engineering analyses were judged." (CAIB p. 200.)
12. **CAIB Sec. 5 (citing Rogers).** NASA managers "may have forgotten–partly because of past success, partly because of their own well-nurtured image of the program–that the Shuttle was still in a research and development phase." (CAIB p. 100, quoting Rogers.)
13. **Rogers Ch. VI Finding 3.** "NASA and Thiokol accepted escalating risk apparently because they 'got away with it last time.' As Commissioner Feynman observed, the decision making was: 'a kind of Russian roulette. ... [The Shuttle] flies [with O-ring erosion] and nothing happens. Then it is suggested, therefore, that the risk is no longer so high for the next flights. We can lower our standards a little bit because we got away with it last time....'" (ROG-6 p. 148.) RETROSPECTIVE; High.
14. **Rogers Ch. VI Finding 4.** "Tracking and continuing only anomalies that are 'outside the data base' of prior flight allowed major problems to be removed from, and lost by, the reporting system." (ROG-6 p. 148.)
15. **Rogers Ch. VI opening.** "as tests and then flights confirmed damage to the sealing rings, the reaction by both NASA and Thiokol was to increase the amount of damage considered 'acceptable.' At no time did management either recommend a redesign of the joint or call for the Shuttle's grounding until the problem was solved." (ROG-6 p. 120.)
16. **Rogers Ch. VI Finding 2 intro.** "Instead, Thiokol and NASA management came to accept erosion and blow-by as unavoidable and an acceptable flight risk." (ROG-6 p. 148.)
17. **Contemporaneous engineer statement (Boisjoly memo, Jul 31, 1985).** "The mistakenly accepted position on the joint problem was to fly without fear of failure and to run a series of design evaluations which would ultimately lead to a solution ... This position is now changed as a result of the [51-B] nozzle joint erosion" (ROG-6 p. 139.) CONTEMPORANEOUS; High.

---

## Q4. Protective actions available, and restrictions on authority or capability

### Columbia

- **Q4-1. In-flight inspection was done in 1988 but not in 2003.** STS-27R (Dec 1988): "On Flight Day Two, Mission Control asked the flight crew to inspect Atlantis with a camera mounted on the remote manipulator arm, a robotic device that was not installed on Columbia for STS-107." For STS-107: "Shuttle Program management declined to have the crew inspect the Orbiter for damage, declined to request onorbit imaging, and ultimately discounted the possibility of a burn-through." (CAIB p. 127.)
  - A capability limit also applies: there was no arm on STS-107.
  - CONTEMPORANEOUS (decisions); RETROSPECTIVE (comparison); High.
- **Q4-2. Three imagery requests (Jan 17 and 21, 2003).** CAIB p. 166; CONTEMPORANEOUS; High.
  1. "Flight Day 2. Bob Page, Chair, Intercenter Photo Working Group to Wayne Hale ... (in person)."
  2. "Flight Day 6. Bob White, United Space Alliance manager, to Lambert Austin ... (by phone)."
  3. "Flight Day 6. Rodney Rocha, Co-Chair of Debris Assessment Team to Paul Shack ... (by e-mail)."
- **Q4-3. Early low concern, Jan 17, 2003 (MER log 4:28 p.m.).** "it is confirmed that USA/Boeing will not work the debris issue over the weekend ... The LCC constraints on ice, the energy/speed of impact at +81 seconds, and the toughness of the RCC are two main factors for the low concern." CAIB: "It was at this point, before any analysis had started, that Shuttle Program managers officially shared their belief that the strike posed no safety issues." (CAIB p. 142.) CONTEMPORANEOUS; High.
- **Q4-4. Jan 21, 2003 MMT, Ham.** "I don't think there is much we can do so it's not really a factor during the flight because there is not much we can do about it. But what I'm really interested in is making sure our flight rationale to go was good" (CAIB p. 147). Ham e-mail, same day: "the ET rationale for flight for the STS-112 loss of foam was lousy. Rationale states we haven't changed anything, we haven't experienced any 'safety of flight' damage in 112 flights ... Rationale was lousy then and still is...." (CAIB p. 148.) CONTEMPORANEOUS; High.
- **Q4-5. Cancellation of the DoD imagery request (Jan 22, 2003, Flight Day 7).** CAIB pp. 152–154; CONTEMPORANEOUS events reconstructed by the Board; High.
  - "At 8:30 a.m., the NASA Department of Defense liaison officer called USSTRATCOM and cancelled the request for imagery. The reason given for the cancellation was that NASA had identified its own in-house resources and no longer needed the military's help. The NASA request ... was both made and rescinded within 90 minutes." (p. 153)
  - "Hale's earlier call ... was placed without authorization from Mission Management Team Chair Linda Ham ... the call was made to a Department of Defense Representative who was not the designated liaison" (p. 152).
  - Ham asked MMT members "to determine the origin of the request and to confirm that there was a 'requirement' for a request ... Linda Ham later told several individuals that nobody had a requirement for imagery." (p. 153)
  - "When Ham officially terminated the actions that the Department of Defense had begun, she effectively terminated both the Intercenter Photo Working Group request and the Debris Assessment Team request." (p. 153)
  - Personal notes: "Linda Ham said it was no longer being pursued since even if we saw something, we couldn't do anything about it. The Program didn't want to spend the resources." (p. 154)
  - Flight Director handover log: "SOI at USSPACECOM was officially turned off. This went all the way up to 4 star General. Post flight we will write a memo to USSPACECOM telling them whom they should take SOI requests from." (p. 154)
- **Q4-6. Capability and knowledge restriction.** "no individuals in the STS-107 operational chain of command had the security clearance necessary to know about National imaging capabilities ... members of the Mission Management Team were making critical decisions about imagery capabilities based on little or no knowledge." (CAIB p. 154; also Sec. 6.3 Findings, p. 172.) RETROSPECTIVE finding about a contemporaneous condition; High.
- **Q4-7. "Mandatory need" burden and the chain of command.** CAIB p. 157; RETROSPECTIVE / CONTEMPORANEOUS; High.
  - The DAT was asked whether it had a "mandatory need": "team members concluded that although their need was important, they could not cite a 'mandatory' requirement for the request." (p. 157)
  - Rocha's unsent e-mail (Jan 22): "In my humble technical opinion, this is the wrong (and bordering on irresponsible) answer from the SSP and Orbiter not to request additional imaging help from any outside source ... Remember the NASA safety posters everywhere around stating, 'If it's not safe, say so'? Yes, it's that serious." He did not send it: "he did not want to jump the chain of command." (p. 157)
- **Q4-8. Other missed opportunities (CAIB p. 167).** CONTEMPORANEOUS; High.
  - "Flight Day 8. Barbara Conte ... calls LeRoy Cain ... Cain checks with Phil Engelauf, and then delivers a 'no' answer."
  - "Flight Day 14 ... Readdy directs that imagery should only be gathered on a 'not-to-interfere' basis. None was forthcoming." Readdy's Jan 29 conversation reasoned that "because the Mission Management Team had concluded that this was not a safety-of-flight issue, the imagery should be gathered only on a low priority 'not-to-interfere' basis" (p. 166).
  - Safety officials: "O'Connor stated he would defer to Shuttle management in handling such a request ... safety personnel took no actions to obtain imagery." (p. 153)
- **Q4-9. Jan 24, 2003 MMT.** Ham: "And no safety of flight, no issue for this mission, nothing that we're going to do different, there may be a turnaround." Ham: "it's more of a turnaround issue similar to what we've had on other flights." The official minutes made "no mention of the debris strike." (CAIB pp. 161–162.) CONTEMPORANEOUS; High.
- **Q4-10. Burden of proof inverted.** "Program managers required engineers to prove that the debris strike created a safetyof-flight issue: that is, engineers had to produce evidence that the system was unsafe rather than prove that it was safe." (Sec. 6.3 Findings, CAIB p. 172; also p. 190: "NASA inverted this burden of proof.") RETROSPECTIVE; High.
- **Q4-11. Rescue or repair was available in principle.** "If Program managers were able to unequivocally determine before Flight Day Seven that there was potentially catastrophic damage to the left wing, accelerated processing of Atlantis might have provided a window in which Atlantis could rendezvous with Columbia before Columbia's limited consumables ran out." The repair option was rated "high risk." (F6.4-1/F6.4-2, CAIB p. 174.) RETROSPECTIVE (NASA study for the Board); High.
- **Q4-12. Organizational authority structure.** "NASA's current organization, which combines in the Shuttle Program all authority and responsibility for schedule, cost, manifest, safety, technical requirements, and waivers to technical requirements, is not an effective check and balance" (CAIB p. 192). Also: "If there was in fact a strong safety culture at NASA, safety experts would have had the authority to test the actual resilience of the leading edge Reinforced Carbon-Carbon panels" (p. 190). RETROSPECTIVE; High.
- **Q4-13. Pre-launch protective actions not taken after STS-112.** "Shuttle Program engineers made no External Tank configuration changes, no moves to reduce the risk of bipod ramp shedding or potential damage to the Orbiter on either of the next two flights, STS-113 and STS-107, and did not update Integrated Hazard Report 37." (CAIB p. 126.) "NASA took no steps to improve imagery ... NASA performed no tests on what would happen if a wing leading edge were struck by bipod foam" (p. 197). RETROSPECTIVE; High.

### Challenger

- **Q4-14. Delaying launch was recommended by contractor engineers (Jan 27, 1986).** Boisjoly: "The conclusion was we should not fly outside of our data base, which was 53 degrees." (ROG-5 p. 90, testimony.) The Commission: decision-makers "were unaware of the initial written recommendation of the contractor advising against the launch at temperatures below 53 degrees Fahrenheit and the continuing opposition of the engineers at Thiokol after the management reversed its position." (ROG-5 p. 82.) CONTEMPORANEOUS recommendation; RETROSPECTIVE finding; High.
- **Q4-15. Management caucus and role reversal.** "Mason said we have to make a management decision. He turned to Bob Lund and asked him to take off his engineering hat and put on his management hat." (Boisjoly, ROG-5 p. 93.) Lund: "We had to prove to them that we weren't ready ... We couldn't prove absolutely that that motor wouldn't work." (ROG-5 p. 94.) Finding 4: "Thiokol Management reversed its position and recommended the launch of 51-L, at the urging of Marshall and contrary to the views of its engineers in order to accommodate a major customer." (ROG-5 p. 104.) High.
- **Q4-16. Escalation withheld by launch decision structure.** "Neither the launch constraint, the reason for it, or the six consecutive waivers prior to 51-L were known to Moore (Level I) or Aldrich (Level II) or Thomas at the time of the Flight Readiness Review process for 51-L." (ROG-5 p. 84.) Reinartz: "Mr. Reinartz, are you telling us that you in fact are the person who made the decision not to escalate this to a Level II item? Mr. Reinartz: That is correct, sir." (ROG-5 p. 88, testimony.) Mulloy: "that was a Level III issue ... There was no violation of Launch Commit Criteria." (ROG-5 p. 98.) Findings 2–3: "The waiving of launch constraints appears to have been at the expense of flight safety. There was no system which made it imperative that launch constraints and waivers of launch constraints be considered by all levels of management." "a propensity of management at Marshall to contain potentially serious problems and to attempt to resolve them internally rather than communicate them forward." (ROG-5 p. 104.) High.
- **Q4-17. Redesign and grounding were available but not pursued.** "At no time did management either recommend a redesign of the joint or call for the Shuttle's grounding until the problem was solved." (ROG-6 p. 120.) Ebeling (Thiokol) "believed Thiokol should not ship any more motors until the problem was fixed" but voiced it "Unfortunately, not to the right people." (ROG-6 pp. 141–142.) Thompson (Aug 22, 1985): "The simple short-term measures should be taken to reduce flight risks." (ROG-6 p. 140.) Finding 5: "The O-ring erosion history presented to Level I at NASA Headquarters in August 1985 was sufficiently detailed to require corrective action prior to the next flight." (ROG-6 p. 148.) High.
- **Q4-18. Weakened safety function.** Rogers Ch. VII Finding 2: "Organizational structures at Kennedy and Marshall have placed safety, reliability and quality assurance offices under the supervision of the very organizations and activities whose efforts they are to check." Finding 4: "Little or no trend analysis was performed on O-ring erosion and blow-by problems." (ROG-7 p. 161.) RETROSPECTIVE; High.

---

## Q5. Evidence against or complicating a threshold-change account

These items are reported as found. Some also fit the hypothesis; the tension is noted.

1. **Formal classification became more conservative for O-rings.** Criticality 1R was changed to Criticality 1 on Dec 17, 1982 (ROG-6 p. 126), and a launch constraint was added in Jul 1985 (p. 137). The formal criticality record did not loosen. What loosened (per Rogers) was the waiver (Mar 1983), the per-flight waiving of the constraint, and engineers' and managers' continued belief in redundancy. Rogers attributes the waiver variously to the 1980 certification review (Weeks) and to letting STS-6 fly (Aldrich/Kohrs). Neither attribution cites prior flight success (p. 128).
2. **Persistent hazard from design and test, not from flight experience.** "The genesis of the Challenger accident-the failure of the joint of the right Solid Rocket Motor-began with decisions made in the design of the joint and in the failure by both Thiokol and NASA's Solid Rocket Booster project office to understand and respond to facts obtained during testing." "Prior to the accident, neither NASA nor Thiokol fully understood the mechanism by which the joint sealing action took place." (ROG-6 p. 148.) Marshall engineers called the design unacceptable in 1977–79, before any flight (pp. 123–124). This supports a persistent-hazard and engineering-error account under which flawed design acceptance pre-dated flight experience.
3. **Engineering-judgment and analysis errors.** Rogers Finding 6 says a temperature correlation was not analysed (ROG-6 p. 148). Managers compared only flights with distress, not all flights (p. 145). CAIB found Crater misuse and inexperienced analysts (Sec. 6.3 Findings, p. 171), and that "RCC damage conclusions were based primarily on judgment and experience rather than analysis." Foam-loss mechanisms were misunderstood: "mechanisms previously considered a prime source of foam loss, cryopumping and cryoingestion, are not feasible" (p. 130).
4. **Communication failures as a proximate cause.** Rogers: "failures in communication that resulted in a decision to launch 51-L based on incomplete and sometimes misleading information, a conflict between engineering data and management judgments, and a NASA management structure that permitted internal flight safety problems to bypass key Shuttle managers." (ROG-5 p. 82.) Decision-makers "If ... had known all of the facts, it is highly unlikely that they would have decided to launch" (p. 82). CAIB Sec. 6.3 Findings, "Communication" (p. 172): "Communication did not flow effectively up to or down from Program managers ... Communication was stifled by the Shuttle Program attempts to find out who had a 'mandatory requirement' for imagery." In these accounts the people holding launch authority (Level I/II) were not informed. That is an information-flow failure rather than a changed threshold held by those decision-makers.
5. **Schedule pressure.**
   - CAIB: "The agency's commitment to hold firm to a February 19, 2004, launch date for Node 2 influenced many of decisions in the months leading up to the launch of STS-107, and may well have subtly influenced the way managers handled the STS-112 foam strike and Columbia's as well." (p. 139.)
   - CAIB: "Little by little, NASA was accepting more and more risk in order to stay on schedule." (p. 139.)
   - CAIB on STS-112: "the need to adhere to the Node 2 launch schedule also appears to have influenced their decision" (p. 125).
   - CAIB Sec. 6.2 Findings (last item): "During STS-107, Shuttle Program managers were concerned with the foam strike's possible effect on the launch schedule." (p. 139.)
   - Rogers Ch. VIII Finding 1: "The capabilities of the system were stretched to the limit to support the flight rate in winter 1985/1986." (ROG-8 p. 176.)
   - Counterpoint within Rogers: "The Commission concluded that the decision to launch the Challenger was made solely by the appropriate NASA officials without any outside intervention or pressure." (ROG-8 p. 176.)
   - CAIB weighs schedule pressure as *co-equal*: "For foam debris and O-ring erosion, the definition of risk established during the Flight Readiness process determined actions taken and not taken, but the schedule and shoestring budget were equally influential." (p. 198.)
6. **Rules existed but were not followed (rule violation rather than rule change).**
   - CAIB Sec. 6.1 Findings (first item): "NASA has not followed its own rules and requirements on foam-shedding." (p. 130.)
   - CAIB Sec. 6.3 Findings: "Mission Management Team meetings occurred infrequently (five times during a 16 day mission), not every day, as specified in Shuttle Program management rules." (p. 171.)
   - Rogers: the Problem Reporting system required launch constraints to go to Level II, and "This communication failure was contrary to the requirement" (ROG-6 p. 139).
   - The debris requirement (3.2.1.1.17) was never formally relaxed. CAIB documents no formal change to the requirement itself; it says "the debris impact requirements have not been met on any mission" (Sec. 6.1 Findings, p. 130).
7. **Some protective rules worked as designed.** The STS-107 strike was formally classified "out-of-family" by USA, and "clearly defined written guidance led United Space Alliance technical managers to liaise with their NASA counterparts" (CAIB p. 142). Engineers "showed initiative and jumped on the problem without direction from above" (p. 200). Before STS-112, NASA "properly designated key debris events as InFlight Anomalies in the past" (p. 130). Strong-signal anomalies did ground the fleet: "On those occasions, NASA stood down from launch, sometimes for months, while the problems were corrected." (p. 197.)
8. **CAIB's caution about hindsight.** "Feynman famously compared launching Shuttles with known problems to playing Russian roulette. But that characterization is only possible in hindsight. It is not how NASA personnel perceived the risks as they were being assessed, one launch at a time ... Taken one at a time, each decision seemed correct." (p. 197.) CAIB also says the five Columbia bipod events are likely a camera-coverage sampling bias, not a Columbia-specific trend (p. 124).
9. **Detection gaps rather than threshold change.** Two bipod events (STS-52, STS-62) were never detected at the time (p. 124). Ascent-imaging capability "has atrophied" through "budget and camera-team staff cuts" (p. 140). "Post-Challenger NASA still had no systematic procedure for identifying and monitoring trends." (p. 199.) These are failures of capability and monitoring, separate from acceptance thresholds.
10. **Mixed-signal framing.** "An incident of O-ring erosion or foam bipod debris would be followed by several launches where the machine behaved properly, so that signals of danger were followed by all-clear signals – in other words, NASA managers and engineers were receiving mixed signals." (CAIB pp. 196–197.) This is consistent with the hypothesis but frames the cause as signal ambiguity.
11. **Discrepancy noted in Q2-16.** CAIB's "demoted to Criticality 1-R" summary conflicts with Rogers' dated sequence (1R, then 1, then waiver). A claim that the formal criticality was downgraded rests on the CAIB summary sentence and is not supported by the Rogers chronology.

---

## Q6. Contemporaneous vs retrospective availability

### Available to some decision-makers before Challenger (CONTEMPORANEOUS)

- 1977–79 Marshall memos calling the joint design "unacceptable" (ROG-6 pp. 123–124). These were sent to Eudy and copied to Hardy; "Thiokol apparently did not receive copies."
- 1980 CIL text that secondary reseal capability was unknown (p. 125).
- 1982 Criticality 1 designation and 1983 waiver (pp. 126–128).
- O-ring erosion and blow-by on STS-2 and the flights from 41-B onward. Each was known at Level III; STS-2 erosion was not reported at the STS-3 Level I FRR (p. 125).
- The 41-C (Mar 1984) and 51-E (Feb 1985) FRR acceptance rationales. Level I saw the 51-E rationale only as a one-page chart, without temperature (p. 147).
- The Jul 1985 launch constraint and its waivers. These were known to Marshall, not to Level I/II (ROG-5 p. 84).
- The Aug 19, 1985 HQ briefing, which said the seal was critical but "safe to continue flying" (ROG-6 p. 140).
- Boisjoly's Jul 1985 memos; Ebeling's Oct 1985 "HELP!" memo (pp. 139–141).
- Thiokol's Jan 27, 1986 no-launch-below-53°F recommendation (ROG-5). Final launch decision-makers were unaware of it (ROG-5 p. 82).
- Temperature-resiliency bench data (June 3, 1985 tests; Aug 9, 1985 letter) (ROG-6 pp. 136–137, 140).

### Found or established only by the Rogers investigation (RETROSPECTIVE)

- The full-flight-history temperature correlation (Figs. 6–7; "almost a certainty ... less than 65", p. 145).
- The leak-check-pressure vs anomaly-frequency linkage as a quantified trend (pp. 133–134). Participants acknowledged it in testimony ("We realized that"), so awareness was partial.
- The absence of the constraint and waivers in any FRR documentation (p. 147).
- The erroneous "closed" PAS entries (p. 144).
- Characterizations such as "got away with it last time" (p. 148).

### Available to some decision-makers before Columbia (CONTEMPORANEOUS)

- The debris requirement and its violation on every flight (CAIB p. 122).
- STS-7, STS-32R, STS-50 bipod losses and their IFA closures. STS-27R damage and its 1988 investigation recommendation: "It is recommended that the program actively solicit design improvements directed toward eliminating debris sources or minimizing damage potential" (p. 128).
- The 1990 Paté-Cornell/Fishback risk study (about 1 in 1,000 per-mission TPS loss probability, debris about 40%; p. 129).
- The 1999 SIAT conclusion that the program "was inappropriately using previous success as a justification for accepting increased risk" (p. 179).
- The STS-112 bipod loss and the Oct 31, 2002 STS-113 FRR rationale (pp. 125–126).
- The Oct 2002 risk assessment that the Boeing Huntington Beach to Houston move "would increase risk" (p. 190).
- During STS-107: the IPWG imagery and size/speed estimates ("remarkably accurate", p. 171), the out-of-family classification (p. 143), Crater results predicting penetration (p. 167), the three imagery requests (p. 166), and Ham's own Jan 21 judgment that the STS-113 rationale "was lousy then and still is" (p. 148).

### Found only by the CAIB investigation (RETROSPECTIVE)

- The STS-52 and STS-62 bipod losses (p. 124).
- That the STS-113 FRR slide's "not changed" claims were factually incorrect (design changed at ET-76) (p. 126).
- The roughly 10% bipod loss rate when extended to all missions (p. 126).
- The rescue/repair feasibility analysis (p. 173–174).
- The RCC impact tests by the Board (p. 190).
- That foam-loss mechanisms assumed by NASA (cryopumping/cryoingestion) were infeasible (p. 130).
- "several NASA managers identified their acceptance of this flight rationale as a serious error" (p. 126). This is a retrospective self-assessment.

---

## What I could not find or verify

- **Rogers Vol. 2 Appendix F (Feynman) and the Rogers Appendix summarizing all O-ring FRR presentations** were not fetched. The Feynman text above is quoted via CAIB p. 130 and Rogers p. 148 only.
- **The Rogers Figure 2 table cell values** (pp. 129–131) are reported only as flight membership, because the HTML flattening makes cell alignment unreliable. (The table's STS-3 date also reads "03/22/81", apparently a transcription typo.)
- **No exact date** is given in CAIB for when the "in-family"/"out-of-family" classification scheme was introduced ("post-Challenger" only).
- **A formal NASA document changing the foam debris requirement (3.2.1.1.17) or the 0.006 ft-lb TPS impact requirement** was not found in CAIB. CAIB describes non-compliance and reclassification of events, not a formal requirement change.
- **CAIB finding numbers.** The PDF two-column layout separated finding numbers from finding text (e.g., 11 numbers vs 13 sentences in Sec. 6.1). Individual F6.1-x and F6.3-x numbers therefore could not be reliably assigned, and findings are cited by section and page instead. The quoted text is verbatim. F6.4-1/F6.4-2 are only two items and are unambiguous.
- **Wayback snapshots** were confirmed to exist only via the availability API (status 200). Their content was not compared to the live copies.
- The SIAT 1999 report, the 1986 House Committee report, and Vaughan's book are cited only as CAIB summarizes them; I did not consult them directly.
