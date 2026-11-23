# Case B: verification log (second analyst)

Date: 2026-11-22. Independent re-fetch of both primary sources; text extracted with `pdftotext` (raw mode, plus `-layout` for spot checks); page numbers below are **printed footer page numbers**, mapped from PDF page indices (TF2004: printed = PDF index − 8 in the body; NERC2004: printed = PDF index − 5).

## Sources re-fetched

| ID | Fetched from | Result |
|---|---|---|
| TF2004 | https://www.energy.gov/oe/articles/blackout-2003-final-report-august-14-2003-blackout-united-states-and-canada-causes-and (linked from https://www.energy.gov/oe/august-2003-blackout) | HTTP 200, application/pdf, 7,012,212 bytes (identical size to the extractor's copy), 226 pages |
| NERC2004 | http://web.archive.org/web/20220525063254id_/https://www.nerc.com/docs/docs/blackout/NERC_Final_Blackout_Report_07_13_04.pdf | HTTP 200; the response had a 45-byte HTML prefix (`<html><head><title>NERC</title></head></html>`) before `%PDF-1.4`. I stripped the prefix. The PDF parses to 124 pages, the same as the extractor reported |

Local copies: `scratchpad/verifyB_dl/tf2004.pdf`, `scratchpad/verifyB_dl/nerc.pdf` (and `.txt` extractions).

## Load-bearing facts

| # | Fact (as claimed in evidence file) | Source | Claimed page | Verified | Actual wording / page if different | Notes |
|---|---|---|---|---|---|---|
| V1 | MISO lacked authority as FE's RC because FE was not a TO-Agreement signatory / not under tariff | TF2004 | p.20 | **Yes** | Verbatim: "...so MISO did not have the necessary authority as FE's Reliability Coordinator as required by NERC Policy 9, Section B, Requirement 2." p.20 | |
| V2 | "MISO ... nevertheless should have issued directives to FE ... before the cascading outages occurred" | TF2004 | p.20 | **Yes** | Verbatim, p.20 | The report holds both: contractual authority lacking, directive still required by NERC policy |
| V3 | FE "did not exercise the authority to alleviate the operating security limit violation" (Policy 5 C.2); "did not exercise a load reduction program" (Policy 2 A 1.2) | TF2004 | p.21 | **Yes** | Verbatim, p.21 | Listed as NERC "other problems", not numbered violations (extractor's note correct) |
| V4 | "System operators and reliability coordinators, by NERC policy, have the responsibility and the authority ... up to and including emergency generation redispatch and shedding firm load"; FE, MISO, PJM, AEP "did not call for emergency actions" "because they either did not know or understand enough" | TF2004 | p.62 | **Yes** | Verbatim, p.62 box "Handling Emergencies by Shedding Load and Arranging TLRs" | Also verified on p.62: "The dispatchers at FE, MISO and other control areas or reliability coordinators have authority--and under NERC operating policies, responsibility--to take such action, but the occasion to do so is relatively rare." |
| V5 | FE had written procedures incl. tripping firm loads; did not follow them "because FE did not know for most of that time that its system might need such treatment" | TF2004 | p.67 | **Yes** | Verbatim, p.67 | Same page, not extracted before: "Neither group of operators had significant training, documentation, or actual experience for how to handle an emergency of this type and magnitude." and FE "never officially declared that it was an emergency condition" |
| V6 | "MISO was hindered because it lacked clear visibility, responsibility, authority, and ability to take the actions needed in this circumstance" | TF2004 | p.67 | **Yes** | Verbatim, p.67 | |
| V7 | ~15:46: "only way ... would have been to drop at least 1,500 MW ... by 15:46 EDT it may already have been too late" | TF2004 | p.45 | **Yes** | Verbatim, p.45 | Hedged ("may") |
| V8 | 500 MW shed before 15:41: Star voltage 91.7%→95.6%, loading 91→87% of emergency; +500 MW → 96.6%, 81%; uncertain for Star-South Canton; "would have prevented the subsequent tripping of the Sammis-Star line" | TF2004 | p.64 | **Yes** | Verbatim, p.64. Exact phrase for the second block: "an additional 500 MW of load would have had to be dropped to improve Star voltage to 96.6% and the line loading to 81%" | The "prevented ... Sammis-Star" sentence cross-refers to p.70 |
| V9 | 1,500 MW before 16:05:57: Star voltage 90.8% (120% rating) → 95.9% (101%); "the blackout could have been averted" | TF2004 | p.70 | **Yes** | Verbatim, p.70 ("if manual or automatic load-shedding of 1,500 MW had occurred within the Cleveland-Akron area before that outage, the blackout could have been averted") | p.70 also: "95% is the minimum operating voltage appropriate for 345-kV buses in the Cleveland-Akron area" |
| V10 | Redispatch alone insufficient; required shed "grew rapidly"; FE "had no automatic load-shedding schemes ... did not attempt to begin manual load-shedding"; "once Sammis-Star tripped, the possibility of averting ... ended" | TF2004 | p.70 | **Yes** | Verbatim, p.70 | |
| V11 | NERC: 2,000 MW after Star-South Canton loss, or 2,500 MW after West Akron bus failure "could have halted the cascade in the northeastern Ohio area" | NERC2004 | p.100 | **Yes** | Verbatim, p.100 (deficiency 11 continuation) | Preceding sentence: "A system operator is required to have adequate resources to restore the system to a secure condition within 30 minutes or less of a contingency." |
| V12 | FE had no ability to transfer control to an alternate center or authority | NERC2004 | p.100 | **Partly** | Verbatim (deficiency 13), p.100, but the next sentence gives the context: "A typical criterion would include the need to evacuate the control center due to fire or natural disaster." | The deficiency concerns backup control facilities (evacuation), not transfer of authority to MISO or a neighbor. Should not be read as an authority restriction on others. Same page, deficiency 12: operators "did not formally declare a system emergency and inform MISO and neighboring systems." |
| V13 | FE load-shed means: plan updated yearly; "can trip loads quickly where there is SCADA control of load breakers (although FE has few of these)"; rotation "requires calling personnel out" | TF2004 | p.66 | **Yes** | Verbatim, p.66 | No execution time is given |
| V14 | NERC: FE "did not have resources available for redispatch to effectively reduce the contingency overload within 30 minutes"; no "adequate load reduction capability, whether automatic or manual" | NERC2004 | pp.99-100 | **Yes** | Verbatim, p.99 (deficiency 10) and pp.99-100 (deficiency 11) | |
| V15 | Post-event requirement: FE capability to reduce Cleveland-Akron load by 1500 MW within ten minutes of a MISO or FE directive | TF2004 | p.151 | **Yes** | Verbatim, p.151 | Retrospective remedy, not an Aug 14 capability. Related, not previously extracted: NPCC adopted after 1965 "manual loadshedding within ten minutes" (TF2004 p.93) |
| V16 | MISO became FE's RC Feb 1, 2003; FE full MISO member Oct 1, 2003 | NERC2004 | p.8 | **Yes** | Verbatim, p.8 | NERC p.8 says MISO coordinates "35 control areas" |
| V17 | ~15:50 AEP/PJM "found no practical way to mitigate these overloads across utility and reliability coordinator boundaries" | TF2004 | p.66 | **Yes** | Verbatim, p.66 | p.66 also says "AEP identified potential contingency overloads at 15:36 EDT"; p.55 gives "about 15:33" (minor internal inconsistency) |
| V18 | TLRs "take effect as a schedule change 30 to 60 minutes after they are issued"; 350-MW TLR "would have had little impact" (IDC) | TF2004 | pp.62-63 | **Yes** | Verbatim, p.62 and p.63 | |
| V19 | 30-min readjustment after 15:05 (TF); NERC: "not even a 30-minute response time was adequate"; Hanna-Juniper 27 min later | TF2004 / NERC2004 | p.65 / p.46 | **Yes** | Verbatim, TF p.65; NERC p.46 | |
| V20 | System N-1 secure at 15:05 (800+ contingencies); NERC: "not within single contingency limits from 15:06 to 16:06" | TF2004 / NERC2004 | p.41 / p.100 | **Yes** | Verbatim, TF p.41; NERC p.100 (deficiency 15) | |
| V21 | Timeline: 14:14 alarm failure (p.52); 15:05:41 Harding-Chamberlin 44% (p.59); 15:32:03 Hanna-Juniper (p.60); 15:41:35 Star-South Canton lock-out at 93% emergency (p.63); 16:05:57 Sammis-Star (p.69); 16:05:57 "last point at which a cascade ... could have been averted" (p.73) | TF2004 | as stated | **Yes** | All verbatim at the stated pages | p.73 also: "A cascade is a dynamic phenomenon that cannot be stopped by human intervention once started." |
| V22 | MISO SE/RTCA "back under full automatic operation and solving effectively by 16:04"; "effectively out of service between 12:15 EDT and 16:04 EDT" | TF2004 | p.49 | **Yes** | Verbatim, p.49 | |
| V23 | NERC: MISO RTCA "did not operate properly in automatic mode again until after the blackout" | NERC2004 | p.97 | **Yes** | Verbatim, p.97; the same sentence also appears on NERC p.43 | Confirms the inter-source conflict with V22 |
| V24 | MISO SE trigger: ~12:15 high mismatch (TF p.48) vs 12:40 deliberate disablement, "All times are approximate" (TF p.136); 12:12:47 Cinergy line (NERC p.36); discovery ~14:40 (TF p.49) | TF2004 / NERC2004 | pp.48, 136, 49 / p.36 | **Yes** | Verbatim at stated pages | Conflict confirmed |
| V25 | FMT with correct topology would have flagged Star-Juniper contingency "as early as 15:10" | NERC2004 | p.97 | **Yes** | Verbatim, p.97; also on p.37 | Next sentence: "would have allowed corrective actions by FE and MISO" |
| V26 | RTCA "showed several hundred violations around 15:00 EDT" | TF2004 | p.55 | **Yes** | Verbatim, p.55 | Conflict with V22 confirmed |
| V27 | Load 61,800 MW; restoration "not restored for 4 days in some parts"; Ontario rolling blackouts "more than a week" | TF2004 | p.1 | **Yes** | Verbatim, p.1 | |
| V28 | NERC: "more than 70,000 megawatts"; "restored to most customers within hours, some areas ... two days ... Ontario ... up to two weeks" | NERC2004 | p.1 | **Yes** | Verbatim, p.1 (executive summary; repeated in the introduction) | Conflict with V27 confirmed |
| V29 | Voltage criteria: TF "modified the criteria around 1998"; NERC "In 1999, FE reduced its operating voltage lower limits" | TF2004 / NERC2004 | p.39 / p.99 | **Yes** | Verbatim, TF p.39; NERC p.99 (deficiency 8) | Date conflict confirmed |
| V30 | EMS: in service 1995; "minor software fixes or patches"; last major update 1998; not current release | TF2004 | p.55 | **Yes** | Verbatim, p.55 | No count or dates of patches |
| V31 | Automatic CA problems "since the system was installed in 1995"; run manually | TF2004 | p.71 n.7 | **Yes** | Verbatim, p.71 (endnote 7) | |
| V32 | Cold reboot discussed after 15:42 and declined: conditions "precarious", "concerned about the length of time that the reboot might take", "even less EMS functionality until it was completed" | TF2004 | p.56 | **Yes** | Verbatim, p.56 | No reboot duration given |
| V33 | No PJM-MISO seam procedure (Violation 6) | TF2004 | p.20 (also p.22) | **Yes** | Verbatim, p.20 and p.22 | |
| V34 | No shared understanding of emergency status or authorities | TF2004 | p.158 | **Yes** | Verbatim, p.158 | |
| V35 | 5,700 MW western NY island basis for restoration (p.100); restoration "aided by the ability to energize transmission from neighboring systems" (p.163) | TF2004 | p.100, p.163 | **Yes** | Verbatim | |
| V36 | FE EMS kept sending accurate data to MISO/AEP (p.53); MISO alarms registered FE breaker trips but were missed (p.55); MISO found Harding-Chamberlin outage only "that evening" (p.60) | TF2004 | pp.53, 55, 60 | **Yes** | Verbatim | |

### Spot-checks of extractor facts cited in the case report

| # | Fact | Source, page | Verified |
|---|---|---|---|
| V37 | "a minimum of 40 minutes, from 14:14 to 14:54, during which the support staff was unaware" | NERC p.95 (also p.32) | Yes |
| V38 | "non-random, common mode failures due to unchecked tree growth" | NERC p.96 | Yes |
| V39 | "FE does not have an adequate automatic under-voltage load-shedding program in the Cleveland-Akron area" | TF p.19 | Yes (extracted as "undervoltage") |
| V40 | "no prior sustained outages known to be caused by trees for these lines in 2001, 2002, and 2003" | TF p.58 | Yes |
| V41 | Star-South Canton "remained at the 120% level for 10 minutes before tripping out" | TF p.64 | Yes |
| V42 | "NERC does not have the authority to enforce compliance with the standards" | TF p.17 | Yes |

## Additional facts found during verification (not in the evidence file)

| # | Fact | Source, page | Tag |
|---|---|---|---|
| A1 | "Use of UVLS is not mandatory, but is done at the option of the control area and/or reliability council." UVLS triggers "with a several second delay". "there is no UVLS system in place within Cleveland and Akron; had such a scheme been implemented before August, 2003, shedding 1,500 MW ... might have prevented the cascade and blackout." | TF2004 p.92 | Optionality and absence: CONTEMPORANEOUS. Counterfactual: RETROSPECTIVE |
| A2 | Special protection schemes to separate the grid "would have been ineffective on August 14." | TF2004 p.92 | RETROSPECTIVE |
| A3 | Negative control: PJM, New York and ISO-New England "had already set up the system to maintain higher voltage levels and therefore had more reactive reserves on-line"; long lines (Homer City-Watercure, Homer City-Stolle Road) "tripped quickly and split the grid between the sections that blacked out and those that recovered" | TF2004 pp.91-92 | Settings: CONTEMPORANEOUS; effect: RETROSPECTIVE |
| A4 | The New York/New England separation "occurred due to natural breaks in the system and automatic relay operations ... No human intervention occurred" | TF2004 p.90 | RETROSPECTIVE |
| A5 | NPCC after 1965 adopted "manual loadshedding within ten minutes" | TF2004 p.93 | CONTEMPORANEOUS (standing criterion in another region) |
| A6 | "All lines were loaded within normal limits after the Harding-Chamberlin lock-out, but after the Hanna-Juniper trip at 15:32 EDT, the Star-South Canton 345-kV line and three 138-kV lines jumped above normal loadings." | TF2004 p.70 | RETROSPECTIVE (modelling) |
| A7 | NERC deficiency 12: operators "did not formally declare a system emergency and inform MISO and neighboring systems." | NERC2004 p.100 | RETROSPECTIVE finding about a contemporaneous omission |

## Outcome

42 facts checked (36 load-bearing plus 6 spot-checks): 41 verified verbatim at the claimed printed page and 1 partly verified (V12, where the context narrows the meaning). None were contradicted. Every source conflict the extractor flagged is confirmed in the primary text. One correction: V12 concerns backup control facilities for evacuation, not transfer of authority. It should not support an authority-restriction claim.
