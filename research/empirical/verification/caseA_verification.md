# Case A (Boeing 737 MAX): verification log (second analyst)

Date: 2026-11-22. Verifier: second, independent analyst. Scope: the load-bearing facts in `caseA_boeing_evidence.md` / `caseA_ledger.csv`, meaning facts that would change a grade for H1A, H1B or severity.

## Method

- I re-fetched all five sources myself into `scratchpad/empirical/verifyA_dl/`. I did not reuse any extractor download.
- SHA-256 of the copies I fetched:
  - S1 JATR: `75fe6ed7abc8148eb6fd785024f62cb431f0d653990359bfad6600318ad4ab1d`
  - S2 House T&I: `c980c27662743cb27f8023c3396a7dd1a2ca6b377af046137eb5d28e64481f61`
  - S3 AD 2020-24-02 (govinfo): `af95f15d4d706c355c24aa344463330174a57b1d912d93268986ec48c074f9a1`
  - S4 FAA RTS Summary: `d991d1372567e768d7a884fb65cdbe3233ab40bac66682da6b8d6d6ab239ab0e`
  - S5 KNKT: `551890bf7fb7d057ef9a8b716decee4b57890928b95109aeeaeca33d0044fab4`
  - All five match the hash prefixes and suffixes the extractor recorded, so the extractor and I read byte-identical files.
- I extracted text with `pdftotext` (layout mode). For the three-column Federal Register text I used reading-order mode as well. Then I searched it with a page-aware script.
- Page offsets, confirmed by reading the printed page footers:
  - S1 arabic page = PDF page - 20; roman pages I-XII = PDF pp.7-18.
  - S2 printed page = PDF page - 7.
  - S3 FR page = 74559 + PDF page.
  - S4 printed page = PDF page - 1.
  - S5 printed page = PDF page - 2.
- **KNKT official copy: not obtained.**
  - `https://knkt.go.id/Repo/Files/Laporan/Penerbangan/2018/2018%20-%20035%20-%20PK-LQP%20Final%20Report.pdf` returned HTTP 404.
  - The legacy host `knkt.dephub.go.id` (the address the ATSB record gives for the report) did not resolve.
  - The `knkt.go.id/investigasi` page loads its report list with JavaScript, and I could not find a direct report link in it.
  - The live mirror (`aviation-is.better-than.tv`) reset the connection. I fetched the Wayback capture of that mirror instead (`web.archive.org/web/20260804062805id_/...`). It is a 322-page PDF whose hash matches the extractor's copy.
  - S5 therefore remains **unverified against an official KNKT copy**. Its content and pagination agree with how S2 and S4 cite it, and press reports give the report as 322 pages, but that is corroboration, not authentication.

## Log

| # | Fact (load-bearing for) | Source | Claimed page | Verified | Actual page / wording if different | Notes |
|---|---|---|---|---|---|---|
| 1 | Boeing "decided to remodel its existing 737 NG aircraft so the company would not have to start from scratch, saving time, resources, and costs in the process" (H1A near-term benefit) | S2 | p.39 | yes | p.39 (PDF 46), verbatim | Committee staff characterization, not a Boeing document. The American Airlines call is attributed to the New York Times (p.38). |
| 2 | New airplane "~$10 billion" vs re-engine "only about $3 billion" (H1A, M4) | S2 | p.37 | yes | p.37 (PDF 44), verbatim | An analyst estimate (Teal Group) quoted by S2, not a Boeing cost record. |
| 3 | Albaugh, 2011-01-14: "I don't think we will re-engine the 737 ... new small airplane ..." (alternative considered) | S2 | p.38 | partly | p.38 (PDF 45) | The words are present, but the body text is interleaved with a sidebar in the PDF, so the sentence order is reconstructed. Content agrees with the extractor's reconstruction. |
| 4 | Engines further forward and higher; changes made aircraft "more likely to pitch upward" (H1A persistent cost) | S2 | pp.42-43 | yes | "pitch upward" on p.43 (PDF 50); 17-inch clearance on p.87 (PDF 94) | |
| 5 | "Without MCAS, the 737 MAX would not meet FAA's regulatory requirements." (H1A persistent dependency) | S4 | p.10 | yes | p.10 (PDF 11), verbatim | RETROSPECTIVE (2020). |
| 6 | O3.4-A original MCAS driven by high-speed compliance; O3.4-B extension to low-speed "due to unacceptable stall characteristics with STS only" | S1 | p.18 | yes | p.18 (PDF 38), verbatim | |
| 7 | March 2016 redesign: activation at lower speeds; authority 2.5 deg vs 0.6 deg; Leadership Review 2016-03-30; email 2016-04-01 "approved as the mitigation for basic stall characteristics" (dated modification, candidate H1B increment) | S2 | pp.103-104 | yes | p.103 (PDF 110); p.104 (PDF 111) | Independent corroboration: S5 p.196 (PDF 198), "The early design of MCAS allowed a maximum stabilizer movement of 0.6 deg, but it was later revised and extended to 2.5 deg." The extractor said S1 does not give the 0.6-degree MCAS figure; S5 does. |
| 8 | O6.9-C..G: S&MF analysis on Rev C (high speed only); Rev D added low speed; certified with Rev E; "SSA was not updated beyond Revision C"; O6.9-H multiple activations judged no worse than one (rival: safety-analysis defect) | S1 | p.34 | yes | p.34 (PDF 54), verbatim | |
| 9 | Delivered design: electric trim resets MCAS; another nose-down command after 5 s if high AOA persists; recovery requires one of three crew responses each cycle (H1B: serial vs alternative structure) | S5 | p.49; pp.193-194 | yes | p.49 (PDF 51); pp.193-194 (PDF 195-196), verbatim. The same text is repeated at PDF p.250 (appendix). | The three responses are stated as **alternatives** ("or"), not as a sequence. None of the sources states when the reset logic was introduced (confirmed: no match in any of the five texts). |
| 10 | FHA: unintended MCAS stabilizer movement = Major in normal flight envelope; no FMEA/FTA required (Finding 2); crew response "within 3 seconds" (Finding 5); redundant AOA "could have been considered but was not required based on the FHA classification of Major" (Finding 19) | S5 | p.204; p.206 | yes | Findings 2 and 5 on p.204 (PDF 206); Finding 19 on p.206 (PDF 208) | **New clarification.** S5 p.196 (PDF 198) says unintended MCAS activation "was considered to have a major effect in the normal flight envelope and hazardous effect in the operational flight envelope." That reconciles S1 O3.2-A ("hazardous", operational flight envelope) with S5's "Major" (normal envelope). S1 O3.3-A ("minor") concerns *loss* of MCAS, a different failure condition. Verified at S1 p.17 (PDF 37). |
| 11 | Cumulative mis-trim "could not be countered by using elevator alone which is contrary to the Boeing assumption during FHA" (Finding 9); column forces >100 lb vs 75-lb limit (Finding 21) (viability boundary) | S5 | p.205; p.206 | yes | p.205 (PDF 207); p.206 (PDF 208) | KNKT simulator: "After two full applications of MCAS and no restoring electric manual trim up, one participant characterized the control column force as 'too heavy'" at p.93 (PDF 95). |
| 12 | JATR assumed 4 s response at 0.27 deg/s; "No studies were found that substantiate the FAA guidance" | S1 | p.14 | yes | p.14 (PDF 34) | S1 says 4 s; S5 says 3 s. Both readings are verified as written. S5 p.191 (PDF 193) explains its figure as FAA guidance that the crew "would respond within 3 seconds". |
| 13 | 2012-11-01 simulator: >10 s reaction "catastrophic"; "step up to catastrophic?"; repeated in coordination sheets 2015-2018; "no record showing it shared any of these MCAS Coordination Sheets with the FAA" | S2 | pp.113-115; p.25 | yes | p.114 (PDF 121); coordination-sheet text p.87 (PDF 94) and p.115 (PDF 122); p.25 (PDF 32) | p.25 continues "...because they were not required to do so." That is Boeing's stated reason, and the extractor's quote omits it. |
| 14 | 2016-06-22 MCAS Review: "No need to redesign to address this"; "All changes are minimal / low collateral damage, therefore no additional flight testing" | S2 | p.111 | yes | p.111 (PDF 118) | **Minor transcription issue.** The extractor wrote "March [sic] trim". S2 prints "March trim" with no "[sic]", so the "[sic]" is the extractor's insertion. |
| 15 | Southwest clause Dec 2011: $1M per aircraft; $200M to nearly $400M exposure if Level B not obtained (H1A near-term benefit of training commonality) | S2 | p.139; p.24 | yes | p.139 (PDF 146); p.24 (PDF 31) | S2's reading of a contract I have not seen. |
| 16 | EICAS risk review (June 2012): "Considerable program cost and schedule risk"; "This would have cascading effects on flight deck design and other systems." | S2 | pp.46-47 | yes | pp.46-47 (PDF 53-54) | A design-dependency statement, not a recovery-latency statement. |
| 17 | AEG: no preliminary training determination until after T-3 tests (late 2016); Forkner: >Level B "unrecoverable" for early customers | S2 | p.147 | yes | p.147 (PDF 154) | A certification ordering, not a safety-recovery step. |
| 18 | Remediation "taken more than 22 months", >40 full-time staff, >60,000 FAA hours (M1 aggregate) | S4 | p.5; p.35 | yes | p.5 (PDF 6); p.35 (PDF 36). The p.35 wording is "This unprecedented level of review has taken more than 22 months" | Aggregate only; no stage durations. |
| 19 | Early estimates: "maybe six weeks-ish" (2018-11-27); FAA TARAM fix "by July 2019"; "grounded for 18 months" | S2 | p.205; pp.210-211; p.12 | yes | p.205 (PDF 212); July 2019 on p.211 (PDF 218); p.12 (PDF 19) | |
| 20 | Scope growth during remediation: "took a broader approach"; wire-separation non-compliance; FCC CPU/memory issue from eCAB testing; integrated SSA dated 2020-08-25; Jan 2020 FCC power-up failure; "additional barriers" | S4; S2 | S4 pp.9, 11, 54; S2 pp.223-224 | yes | S4 p.9 (PDF 10) and p.19 (PDF 20); p.11 (PDF 12); p.54 (PDF 55); S2 p.223 (PDF 230) | S4 p.54 also cites a close-out coordination sheet dated **June 19, 2019** for the CPU issue's root cause. So that issue was identified by mid-2019, and the 2020-08-25 date is when the integrated SSA closed the item. |
| 21 | RTS gating: EOP rescinded "based on completion of" FAA design approval and AD issuance; operators must incorporate all changes; pilots must complete FSB special training (serial ordering, fleet level) | S4 | pp.13-14 | yes | p.13 (PDF 14) and p.14 (PDF 15) | |
| 22 | AD (g)-(l) each "Before further flight", no order among them; (m)(1) ORF "After accomplishment of all applicable required actions in paragraphs (g) through (l)" and "before any other flight"; (m)(2) irregularities; (o) credit for (j), (k) done before the effective date under June 2020 SBs | S3 | 85 FR 74584-74585, 74592; 74579 | yes | (g) at 74584; (m) and (o) at 74592; ORF rationale at 74579 | (o)(1) cites SB 737-31-1860 dated June 12, 2020; (o)(2) cites SB 737-27-1318 dated June 10, 2020 or Rev 1 dated June 24, 2020. |
| 23 | Per-airplane work-hours: FCC 1, AFM 1, MDS 1, wiring up to 79, AOA test 10 (revised from 40); ORF no definitive data | S3 | 74584; 74579 | partly | The "Up to 79 work-hours" wiring row is verified at 74584 | I did not re-read every cost row. Treat the other figures as extractor-reported. |
| 24 | New control laws: both AOA inputs; >5.5 deg split disables STS; one activation per event; "without the need to make electric or manual stabilizer trim inputs"; FAA: "no STS failure modes rely on exceptional piloting skills or immediate pilot actions" | S3; S4 | 74561; S4 p.13 | yes | 74561 (PDF 2); S4 p.13 (PDF 14) | |
| 25 | Final FSB Rev 17 date: Nov 16, 2020 (S3) vs Nov 18, 2020 (S4) | S3; S4 | 74561; p.11 | yes (discrepancy confirmed) | S3 74561 "November 16, 2020"; S4 p.11 (PDF 12) "published the final version ... on November 18, 2020" | Possibly a document date vs a publication date. Kept as a source conflict. |
| 26 | Certification dates: applied 2012-06-30, certified 2017-03-08 | S1 | p.I fn.1 | yes | p.I (PDF 7) | I did not re-check S2's internal inconsistency (p.41 vs p.5). Kept as the extractor flagged it. |
| 27 | Changed Product Rule "did not adequately address cumulative effects, system integration, and human factors issues"; federated architecture "rooted in the original 1967 certification" | S1 | p.IV; p.7 | yes | p.IV (PDF 10); p.7 (PDF 27) | |
| 28 | KC-46 MCAS: once per activation, limited power, at least two AOA sensors (documented precedent for an alternative architecture) | S2 | p.103 | yes | p.103 (PDF 110) | |
| 29 | FAA Nov 2018: "an average crew with no prior awareness could sort out the failure scenario and could correctly mitigate the failure using existing procedures" | S4 | p.18 | yes | p.18 (PDF 19) | |

## Outcome

- **Checked:** 29 facts, covering the 15 load-bearing groups.
- **Fully verified:** 27 facts, with wording and page confirmed.
- **Partly verified:** 2 facts.
  - #3: the Albaugh quote's order is reconstructed because the PDF interleaves body text with a sidebar.
  - #23: only the wiring row of the cost table was re-read.
- **No page-number errors found.** The extractor's page conventions are correct for all five documents.
- **Corrections and additions:**
  - (i) "[sic]" in the 2016-06-22 minutes quote is the extractor's insertion, not S2's.
  - (ii) The S2 p.25 quote omits "because they were not required to do so", which is Boeing's stated reason.
  - (iii) S5 p.196 states the hazard classification by envelope: Major in the normal flight envelope, Hazardous in the operational flight envelope. This largely resolves the S1/S5 "discrepancy" the extractor flagged.
  - (iv) S5 p.196 independently gives the 0.6 -> 2.5 deg MCAS authority change.
  - (v) S4 p.54 dates the CPU-issue root-cause coordination sheet June 19, 2019.
- **Unresolved:** S5 is still read from an archived third-party mirror. I could not obtain an official KNKT copy.
