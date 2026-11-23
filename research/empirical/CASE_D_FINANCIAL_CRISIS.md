# Case D: 2007–2009 financial crisis (Argument V, Theorem V.3)

> **Review.** Drafted by a second analyst independent of the evidence extraction, and checked by the lead analyst on 2026-11-22 against the frozen pre-registration (`EMPIRICAL_TEST_PLAN.md`). Severity labels follow Amendment 1 ("ruled out" when a necessary condition is contradicted by evidence, "not identifiable" when evidence is missing). The verification log is `verification/caseD_verification.md`; the evidence extraction is `evidence/caseD_finance_evidence.md`.

**Status:** case report by the second, independent analyst, 2026-11-22. It is written under the frozen pre-registration (`research/empirical/EMPIRICAL_TEST_PLAN.md`, §5 Case D, with §§1–3 and §8). The evidence base is the extractor's audit (`scratchpad/empirical/caseD_finance_evidence.md`, `caseD_ledger.csv`), re-checked against re-downloaded sources in `verification/caseD_verification.md` (22 checks: 20 verified, 1 partly verified, 1 non-load-bearing claim unverified).

**Result in one line:** the stopping rule applies. No primary source provides a dated pre-crisis series of any protective margin, so the quantitative erosion test was **not run**. H4 is **not identifiable** in every segment and overall. Formal severity is **not identifiable**, including the severity 1 that the framework assigns to calm erosion.

Source keys: S1 = FRBNY Staff Report 477 (Copeland, Martin, Walker, Nov 2010); S2 = FRBNY Staff Report 506 (Copeland, Martin, Walker, Jul 2011, rev. Aug 2014); S3 = SR506 data-file metadata; S4 = FRBNY Primary Dealer Statistics (Markets API); S5 = FRBNY Tri-Party Repo Infrastructure Reform White Paper (17 May 2010); S6 = Task Force on Tri-Party Repo Infrastructure Report (17 May 2010, appended to S5, paginated "x of 43"); S7 = BIS CGFS Papers No 36 (Mar 2010); S8 = IMF GFSR April 2008, Ch.1; S9 = Senior Supervisors Group, *Observations on Risk Management Practices during the Recent Market Turbulence* (6 Mar 2008); S10 = ECB Financial Stability Review, June 2007; S11 = Bank of England Financial Stability Report, April 2007; S12 = Gorton & Metrick, Yale ICF WP 09-14 (Nov 2009; **academic, not primary**).

Page cites give the printed page, with the PDF page in parentheses where they differ. **[C]** marks material that was public before August 2007 (contemporaneous). **[R]** marks retrospective material.

---

## 1. Scope and the four evidentiary levels

**Hypothesis (H4, per the study owner):** a safety controller that reduces protective reserves or risk limits during long periods without observed disturbances can leave a system less able to withstand a later comparable disturbance. The test concerns an **actual reduction in protective capacity**. Rising leverage and later losses do not count. Internal target margins, lender-imposed requirements and realized usable reserves are kept apart.

**Theory being applied:** Theorem V.3 (Argument V, §V.4). Its controller has four necessary components:
- **C1**, a protective floor;
- **C2**, a reset to the maximum after a shock;
- **C3**, a relaxation after every *k* consecutive calm ticks;
- **C4**, survival of a *comparable* shock if and only if the floor still covers it.

Its conclusion is that the same shock is survived after short calm and fatal after long calm. The sweep threshold L\* = 3k is a property of the stylized model and is **not** an empirical prediction (pre-registration §5 Case D). No k or L\* is estimated here (§3 "No invented parameters").

**Viability (pre-registered):** the ability to meet funding obligations without forced failure or emergency support.

| Level | Question | Answer for Case D |
|---|---|---|
| 1. Formal possibility | Does the framework admit the mechanism? | **Yes, already established.** Theorem V.3 is machine-checked (`calm_erosion_fatal`, `shield_fatal`, `ref_calm`). This case adds nothing at this level and takes nothing away. |
| 2. Historical mechanism | Do primary records document C1–C4 in a segment? | **Not established.** C1 exists trivially (haircuts and initial margins are protective floors). C2, C3 and C4 are not documented with dates in any segment. The pre-2007 reductions are documented only qualitatively and undated ([C] S10 p.112–113, S11 p.37; [R] S7 p.vii, p.10). Their stated driver is competition, not calm length. For one important class (portfolio-margin models for liquid assets) the documented calibration is to *stressed* periods, which runs against C3 (S7 p.4). |
| 3. Causal identification | Does the mechanism survive the pre-specified rivals (exposure/leverage growth with stable margins, asset-quality deterioration, sudden funding withdrawal, regulatory change)? | **Not attempted, and not attemptable.** No margin series exists to separate calm-conditioned relaxation from the rivals (M8 cannot be computed). The documented failure mechanisms in the best-measured segment (tri-party) are funding withdrawal and counterparty concern, not margin insufficiency (S2 p.29, p.31). |
| 4. Predictive validity | Do indicators built only from contemporaneous data discriminate failures better than baselines? | **Not testable.** There is no contemporaneous margin series and no comparison-unit panel of margins (M9; §7 of the plan). |

---

## 2. Data-availability assessment

"Type" records whose protection the series measures:
- **internal**: an organization's own target margin, buffer or limit;
- **lender-imposed**: a requirement a lender sets on a borrower, which is the lender's own protective margin but an external constraint for the borrower;
- **realized**: margin or reserves actually in place, measured from positions;
- **exposure**: a size measure, not a protective margin.

| # | Series | Segment | Type | Coverage | Frequency | Access | Usable for the pre-registered test? Why |
|---|---|---|---|---|---|---|---|
| 1 | FRBNY tri-party margins by dealer × collateral class (S1 p.16–17; S2 p.10–11) | Tri-party (segment 2 in S2's map) | Lender-imposed (cash investor on dealer), measured as realized overcollateralization, "collateral/cash − 1" (S2 p.1 fn.1) | 1 Jul 2008 – 27 Jan 2010 (S1 p.17; S2 p.11) | Daily | Confidential microdata. Public chart points only, "Market aggregates" (S3) | **No.** It starts after Bear Stearns (S2 p.12) and has no data for Sep 2007–Jul 2008 (S1 p.16 fn.14) or any pre-2007 calm. |
| 2 | FRBNY bilateral margin survey (S2 p.20–21; S1 p.67 "survey of hedge funds") | Bilateral, dealer → clients (segment 5) | Lender-imposed (dealer on hedge funds, REITs, banks) | Figures start Jul 2008. Start and end not stated in the text | Daily (S2) | Confidential | **No.** No pre-2008 data is shown or described. |
| 3 | FRBNY Primary Dealer Statistics (S4) | All primary-dealer financing combined. Tri-party labels only from 5 Jan 2022 | **Exposure** (repo/reverse-repo financing, securities in/out) | 28 Jan 1998 onward, six series breaks | Weekly | Public (API/CSV) | **No for margins.** A scan of every period menu finds 0 occurrences of "margin" or "haircut" (verification V11). It is usable only as an exposure/leverage control. |
| 4 | Task Force / FRBNY monthly tri-party statistics incl. haircut percentiles (S6, 6 of 43) | Tri-party | Lender-imposed, realized distribution | Pilot "with actual data as of April 2010" | Monthly | Public | **No.** Post-crisis. |
| 5 | IMF GFSR Apr 2008 Table 1.2 "Typical 'Haircut' or Initial Margin" (S8 p.23) | Not named. The text places it in hedge-fund financing (S8 p.22) | Lender-imposed, "typical" quoted terms ("Sources: Citigroup; and IMF staff estimates") | Two columns: "January–May 2007", "April 2008" | Two snapshots | Public | **No.** One early-2007 point, so there is no series over a calm interval and no pre-calm baseline. It is published after the event [R]. |
| 6 | CGFS 36 Table 1 "Typical haircut on term securities financing transactions" (S7 p.2) | Term SFTs by counterparty (prime / non-prime / "Hedge funds and other unrated") | Lender-imposed, survey ("Source: Study Group survey") | "June 2007", "June 2009" | Two snapshots | Public | **No.** One mid-2007 point, gathered retrospectively [R]. |
| 7 | Gorton–Metrick repo-haircut index (S12; **academic**) | Bilateral interdealer (segment 4 per S2 p.7–8) | Lender-imposed | Weekly, 4 Jan 2007 – 29 Jan 2009 (S12 p.19) | Weekly | Not public. Source "dealer banks" (S12 p.14). S2 p.1 calls it "a high-quality dealer" | **No.** It starts in 2007 and is not a primary official source. |
| 8 | Fed SCOOS (S13) | Dealer financing terms | Lender-imposed, qualitative changes | From June 2010 | Quarterly | Public | **No.** Post-crisis. |
| 9 | FSA six-monthly survey of prime-broker exposures to hedge funds (mentioned in S11 p.37) | Prime brokerage | Exposure. Margin content unknown | Running by Apr 2007. Start unknown | Six-monthly | Not public as a series. Not obtained | **Unknown.** It is a lead only. |
| 10 | CGFS 36 Graph 2: summed trading-book VaR of 14 banks and VIX, 2002–2009 (S7 p.9) | Bank trading books | Internal **risk measure**, not a buffer | 2002–2009 | Not stated | Built from public accounts | **No for margins.** VaR is a measurement of risk, not protective capacity. It "rose in this period despite a fall in market volatility" (S7 p.9), which is a sign of exposure growth. |
| 11 | SSG VaR re-estimation (S9 p.14) | Internal VaR at 11 firms | Internal risk measure | One cross-section (Q3–Q4 2007) | One-off | Public text | **No.** It is not a series. |
| 12 | Regulatory capital, broker-dealer net capital, Fed Z.1 broker-dealer balance sheets | Capital buffers / exposures | Realized buffers / exposure | **Not verified** | — | Public | **Not assessed.** These are leads listed by the extractor and not examined. |

**Summary.** No internal target-margin series exists in any segment. No lender-imposed or realized margin series covers any part of a pre-2007 calm interval. The only pre-crisis margin numbers are two retrospective point snapshots for early or mid-2007 (rows 5 and 6). Official bodies acknowledged the gap: "There was insufficient transparency with respect to many aspects of the tri-party market, including… typical levels of margin" (S6, 4 of 43). The CGFS recommended starting a survey of credit terms "including haircuts" (S7 p.21, §4.6). SR506 says "the most glaring need is data on the bilateral market" (S2 p.40).

**Disturbance measure.** The pre-registration requires "a pre-specified disturbance measure" (M7) but does not name one. A candidate exists (VIX, shown in S7 Graph 2), but choosing one now, after seeing the outcomes, would be post hoc. It is moot in any case without a margin series. A future test would need the measure fixed by dated amendment before any data is inspected. Any measure would also have to decide whether events such as the Amaranth margin calls of September 2006 (S11 p.48) break the "calm".

---

## 3. Application of the stopping rule

Pre-registration §5 Case D: *"If no pre-crisis margin series is available from primary sources, the quantitative erosion claim stops; a qualitative assessment and a data-availability report are delivered instead."*

**Determination: the condition is met, and the quantitative erosion test cannot be run.** No primary or official source provides a dated pre-crisis series of tri-party margins, bilateral margins, prime-brokerage initial margins or internal protective limits (Section 2). The FRBNY margin data begin on 1 July 2008 (S1 p.17; S2 p.11–12). The primary dealer statistics run back to 1998 but contain no margin series (V11). The IMF and CGFS tables are single early-2007 or mid-2007 points (S8 p.23; S7 p.2).

Therefore:
- M7 (protective margin series) is **not available**, M8 (calm-conditioned relaxation) is **not computed**, and M9 (predictive discrimination) is **not computed**.
- No margin series was reconstructed, interpolated or fitted. The IMF and CGFS snapshots are not joined into a trend: each describes an early-2007 level against a crisis level, not a decline over calm.
- No numerical k, L\* or calm length is estimated.
- What follows is the qualitative assessment and data-availability report that the rule requires instead.

---

## 4. Segment-by-segment findings

### 4.1 Tri-party repo (segment 2)

**Pre-registered adversarial check (done first): confirmed, within its window.**
- Haircuts and funding "were surprisingly stable" (S1 abstract; S2 abstract, "for most borrowers").
- Treasury and agency-debenture margins "did not change throughout the crisis". Nongovernment margins rose "only two percentage points, from 5% to 7%" (S2 p.2, p.20).
- Mean margin over all collateral was 2.8% in the "Crisis" period (Jul 2008–Jul 2009) and 2.7% in the "Stable" period (Jul 2009–Jan 2010) (S2 Table II, p.19). **The "Stable" period is post-crisis, not a pre-2007 baseline.**
- At Sep–Dec 2008 haircuts a hypothetical portfolio would have raised "about $1.1 billion less" than at Jul–Aug 2008 haircuts, "less than half a percent" (S1 p.67).
- All of this is [R] and covers 1 Jul 2008 – 27 Jan 2010 only.

**What is documented:**
- **Institutional setting.** Margins sit in custodial-agreement appendices, and "Changing margins is possible… but might well require 24 or 48 hours" (S2 p.34). Such changes "are only made occasionally" (S1 p.8). Some investors set haircuts "to a uniform level across asset classes" because they lend only to dealers perceived as riskless (S1 p.22). Investors "look to the counterparty… first and the collateral second" (S1 p.2; Valukas quoted at S1 p.25). [R]
- **Response to disturbance.** Margin changes were essentially unrelated to dealer CDS: an elasticity of 0.003 is "a negligible amount" (S2 p.30). Investors "do not react to adverse information by changing margins… The exception… is… Lehman Brothers" (S2 p.31). For Lehman, the margin spread over peers rose from −0.05 (July average) to 4.11 (15 Sep). Investors fell from 70 to 16 (S2 Table VI, p.26), and the tri-party book fell from $150bn to $95bn between 8 and 12 Sep 2008 (S1 p.56). The authors conclude that "cash investors are more likely to simply pull their funding" (S2 p.29). [R]
- **Pre-crisis composition (no margins).** The share of less-liquid collateral "was growing before the crisis" and "approached 30 percent… at the peak" (S1 p.1–2). No dated series is given. [R]
- **Gap.** There are no data for Sep 2007 – Jul 2008, "Some of the most dramatic events in the tri-party repo market" (S1 p.16 fn.14), and none for any year before 2008.

**Bearing on H4.** H4's rejection criterion for a segment ("margins did not decline during calm") cannot be evaluated, because no calm-period margin data exist. However, the crisis-window evidence bears on whether tri-party margins behave like the V.3 controller at all:
- **C2 is not observed.** V.3's floor resets to its maximum after a shock. Tri-party margins did not materially reset after Lehman (S2 p.2, Table II).
- **The documented protective response was quantity rationing,** by counterparty, rather than margin adjustment (S2 p.29, p.31, p.35).
- **The contractual, occasionally revised setting** (S1 p.8; S2 p.34) is hard to square with continuous recalibration to recent experience (C3). It does not exclude occasional downward renegotiation during calm, which is undocumented either way.

This weakens the mapping of tri-party margins onto the V.3 floor. It does not contradict H4 under the pre-registered rejection rule. A confounder applies throughout: the whole S1/S2 sample lies inside the PDCF period, and S1 calls "the exceptional policy actions… including the creation of the PDCF" "Perhaps the biggest reason for the apparent stability" (S1 p.68). Observed stability is therefore stability *with* emergency support, which the pre-registered viability definition excludes.

### 4.2 Bilateral repo (segments 4 and 5)

**What is documented:**
- **Crisis increases, segment 5 (dealer → clients), FRBNY survey.** "The median margin is higher in the bilateral repo market for all collateral classes except Treasuries. After the Lehman Brothers' bankruptcy, these margin spreads increased, reaching more than 40 percentage points for subprime collateral" (S2 p.21–22). Spreads over tri-party were "over 10 percentage points in 2009" for corporates and "over 30 percentage points" for private-label CMOs/ABS (S2 p.2). Coverage begins Jul 2008 (S2 Fig. 2; S1 Fig. 26). [R]
- **Segment 4 (interdealer), academic only.** The S12 index "rises from zero in early 2007 to nearly 50 percent at the peak of the crisis in late 2008" (S12 p.4). For BBB+/A corporates "in the first half of 2007… the haircut was zero" (S12 p.16). S12 fn.18 cautions that terms "could be different for non-dealer bank counterparties, such as hedge funds". [R, academic]
- **Size.** S2 estimates bilateral at ~60% of ~$6.1tn repo in Jul–Aug 2008 (S2 p.7, App. A). S1 says bilateral DvP repos "are believed to represent a small share of dealer funding" (S1 p.4). The two FRBNY reports disagree.

**Bearing on H4.** The large post-shock increases are consistent with a C2-like reset in this segment. Near-zero early-2007 haircuts on some collateral (S12, academic) describe a *level* at one time, not a decline during calm. No series shows whether bilateral haircuts fell over 2003–2007, so H4 cannot be evaluated. The segment-5 and segment-4 data must not be merged with each other or with tri-party (S2 p.7–8 keeps them separate, and S2 "is not aware of any data source that covers segment 3").

### 4.3 Prime brokerage and OTC initial margins

**What is documented:**
- **[C] BoE, April 2007:** "Market contacts suggest that competition for prime brokerage accounts has encouraged some brokers to take on greater market risk… there is evidence of an erosion of lending terms, particularly of initial margins" (S11 p.37). The underlying evidence is not shown. On the *same page*: "most estimates of the direct exposures of prime brokers to hedge funds remain small relative to capital" and "estimates also suggest that the leverage of hedge funds has fallen since 2000". Elsewhere: "Margining and collateral practices, in particular, have been strengthened over this period [since LTCM 1998]" (S11 p.48).
- **[C] ECB, June 2007:** "competition among prime broker banks… remains intense… The reduced downside protection is not confined to the less frequent use of initial margins at the inception of various OTC trades, but also refers to more aggressive VaR-based cross-product (portfolio) margining practices and looser collateral policies… VaR measures may prove particularly inadequate should correlations… increase, and if volatility rises from unusually subdued levels" (S10 p.112–113).
- **[R] CGFS, March 2010:** "Portfolio margining models, often used in prime brokerage… the majority of such models appear to have used volatility assumptions backed out from historical stressed periods rather than the most recent data so that, for more liquid asset classes such as G7 government bonds and equities, haircuts changed only modestly" (S7 p.4). Competitive pressure "had been particularly strong… in business lines (such as prime brokerage) that used lower haircuts to attract business" (S7 p.4).
- **[R] IMF, April 2008, snapshot:** "January–May 2007" vs "April 2008" typical haircuts or initial margins. Examples: U.S. treasuries 0.25 → 3; investment-grade bonds 0–3 → 8–12; high-yield 10–15 → 25–40; equities 15 → 20; AAA RMBS 2–4 → 10–20; Alt-A MBS 3–5 → 20–50 (S8 p.23). Hedge funds "had negotiated 'margin locks' that prevented their prime brokers from increasing the margins… for a fixed period of time" (S8 p.19 fn.34).
- **[R] CGFS Table 1,** June 2007 vs June 2009, hedge funds/unrated column. Examples: structured products (AAA) 20 → 100; ABS 20 → 100; G7 short-term government 0.5 → 2 (S7 p.2).

**Bearing on H4.** This is the segment with the strongest **contemporaneous** evidence of an actual reduction in protective terms: the ECB names less frequent initial margins, more aggressive VaR-based portfolio margining and looser collateral. But the components that distinguish H4 from rivals are missing or contradicted:
- **No dates and no magnitudes.** Neither statement dates the reduction or quantifies it. The BoE statement rests on "market contacts".
- **The stated driver is competition** (S10, S11, S7 p.4), not the length of calm. The ECB's reference to "unusually subdued" volatility names the conditions under which VaR-based margins would prove inadequate. It is not a finding that margins were lowered because calm lengthened.
- **For liquid-asset portfolio margining, the documented calibration is to stressed history** (S7 p.4), which contradicts C3 for that class.
- **The snapshots show crisis increases** from an early-2007 level. A large crisis increase is evidence of a post-shock tightening (C2-like), not of pre-crisis erosion.
- **There is contemporaneous counter-evidence:** strengthened margining since LTCM, falling hedge-fund leverage, small direct exposures (S11 p.37, p.48).

One reading is qualitatively compatible with reset-then-relax: strengthening after LTCM 1998 followed by erosion by 2007 (S11 p.48, p.37). It is undated, has no intermediate observations, and its stated driver is competition, so it cannot be scored as C2 + C3.

**Controller identity.** The initial margin is the *prime broker's* protective margin against client default. For the hedge-fund borrower it is a lender-imposed constraint whose erosion shows up as higher borrower leverage, which the case specification excludes as the test variable. The pre-registered viability (funding without forced failure or emergency support) is a borrower-side or dealer-funding property. The prime broker's own loss exposure was described as "small relative to capital" (S11 p.37).

### 4.4 Internal risk limits (VaR) and capital/liquidity buffers

**What is documented:**
- **[R] SSG:** "some firms' initial assessment of the true potential losses they faced were likely skewed downward by their VaR measures' underlying assumptions and a dependence on historical data from more benign periods". VaR on new data was "anywhere from about 10 percent to at least 200 percent higher", with most firms 30–80% higher, and "between two and sixteen back-testing exceptions during the third quarter of 2007 alone" (S9 p.14). The basis is meetings in November 2007 with eleven firms (S9 p.1).
- **[R] CGFS:** VaR-based haircuts use a look-back that "is usually one year, but longer time periods (up to five years) were also reported" (S7 p.3).
- **[R] CGFS Graph 2:** "banks' trading book VaR rose in this period [2002–07] despite a fall in market volatility" (S7 p.9).
- **Capital and liquidity buffers:** no evidence was collected. Regulatory capital, net capital and Z.1 series are unverified leads (Section 2, row 12).

**Bearing on H4.** The SSG and CGFS statements document an **experience-based calibration** of an internal risk measure, the closest analogue in the record to V.3's memory. A one-year look-back is a description of memory length. It is not a value of k: a rolling VaR window is not V.3's step rule, and no margin series exists to calibrate against (§3 "No invented parameters"). The record does not show that this calibration *reduced protective capacity*: limits, capital held against VaR and liquidity buffers are not observed. Aggregate VaR *rose* over 2002–07 (S7 p.9), which points to exposure growth outweighing any calm-driven fall in measured volatility. H4 is not identifiable for this segment. Capital and liquidity buffers were not assessed.

---

## 5. Qualitative mechanism evidence

### 5.1 Supporting calm-based margin setting or relaxation

| Statement | Source | C/R | What it supports | Limits |
|---|---|---|---|---|
| VaR-based haircut look-back "usually one year… up to five years" | S7 p.3 | R | C3-type memory exists in haircut setting | Survey description. Same paragraph lists "competitive pressures and client relations" |
| "gradual erosion of risk management standards… Haircuts fell to low levels" before mid-2007 | S7 p.10 | R | A reduction occurred in good times | "in response to competitive pressures". No series |
| "low financial market volatility… comfort of lenders with… modest and declining haircuts" | S7 p.vii | R | Reduction co-occurred with low volatility | Co-occurrence, not conditioning. No dates |
| Lower credit spreads → "haircut levels… likely to be reduced"; risk measures "distorted" | S7 p.10 | R | Proposed mechanism | Stated as mechanism, not observed |
| VaR "dependence on historical data from more benign periods"; VaR up 30–80% on new data | S9 p.14 | R | Experience-based internal risk measures understated risk | Risk measure, not a buffer level |
| Products "created during the prior period of more benign market conditions" had not been observed in a downturn | S9 p.1 | R | Calibration came from calm data | Points equally to *novelty* (no memory at all), see §6 |
| "evidence of an erosion of lending terms, particularly of initial margins" | S11 p.37 | **C** | Actual reduction in prime-brokerage protection | Driver given as competition. Evidence not shown |
| "less frequent use of initial margins… more aggressive VaR-based… margining… looser collateral" | S10 p.112–113 | **C** | Actual reduction in protection | Driver given as competition |
| "In cases of stable markets where… historical volatility assumptions have decayed, an overlay of market stress testing… is critical" | S6, 22 of 43 | R | Implies prior reliance on decaying historical volatility | Normative. It does not document past practice |
| "Margin pro-cyclicality… margin levels are reduced in good times and increased in bad times" | S6, 5 of 43 | R | Names the pattern | Definition, not a measurement |
| "During normal times, competitive dynamics and an abundance of market liquidity led… to liberal policies on… haircuts" | S5 p.14 | R | Reduction in good times (tri-party context) | Driver given as competition and liquidity |

### 5.2 Against or complicating

| Statement | Source | C/R | What it cuts against |
|---|---|---|---|
| Portfolio-margin models used "volatility assumptions backed out from historical stressed periods rather than the most recent data" | S7 p.4 | R | C3 for liquid-asset prime-brokerage margins |
| "competitive pressures influenced the level of haircuts"; prime brokerage "used lower haircuts to attract business" | S7 p.4; also S7 p.vii, S10, S11 | R/C | Calm as *the* driver: competition is named every time |
| Crisis increases driven by "Reassessment of the market liquidity of collateral assets and counterparty credit quality, as well as higher volatility"; volatility "did not contribute materially" in some markets | S7 p.vii, p.4 | R | Volatility-memory as the main channel in the reversal |
| Tri-party margins set in legal appendices, changed "only occasionally"; some set uniformly; counterparty first | S2 p.34; S1 p.8, p.22, p.2 | R | Continuous recalibration to recent experience in tri-party |
| Tri-party margins did not respond to CDS (0.003) and did not behave procyclically | S2 p.30, p.37 | R | C2 (reset after shock) in tri-party |
| Hedge-fund leverage "has fallen since 2000"; prime-broker exposures "small relative to capital"; margining "strengthened" since LTCM | S11 p.37, p.48 | **C** | A general loss of protection before 2007 |
| "In bad times, tightening is often implemented first through revisions to counterparty credit limits, while increases in haircuts tend to follow later" | S7 p.vii | R | The haircut as the primary protective variable |
| Funding withdrawal: "cash investors are more likely to simply pull their funding"; Lehman book fell from $150bn to $95bn in four days | S2 p.29; S1 p.56 | R | Margin insufficiency as the failure mechanism (tri-party) |
| Post-crisis fix: VaR made "more sensitive to volatility spikes" via "shorter horizon price histories or… greater weight to more recent observations" | S9 p.14 | R | Firms did not diagnose the problem as calm-driven memory loss. The remedy is more reactive, not a structural (non-decaying) floor |

---

## 6. Competing explanations

| Rival (pre-registered) | Evidence | Assessment |
|---|---|---|
| **Exposure/leverage growth with stable margins** | Primary-dealer repo financing (overnight/continuing) rose from $892.9bn (4 Jul 2001) to $2,304.7bn (27 Jun 2007) and $2,971.9bn (5 Mar 2008) (S4, PDFMRPOC; verified V11). Bank VaR rose 2002–07 while VIX fell (S7 p.9). Dealers moved "toward secured financing, notably tri-party repos" (S1 p.6). "Some Dealers became excessively reliant on short-term repo financing" (S6, 4 of 43). | **Exposure growth is documented with a primary contemporaneous series. Whether margins were stable alongside it is unknown** (no margin series). The rival therefore cannot be distinguished from H4. Exposure growth alone is outside H4 as specified ("not rising leverage"). S4 has panel changes and no tri-party/bilateral split before 2022. |
| **Asset-quality deterioration** | Less-liquid tri-party collateral "approached 30 percent" at peak (S1 p.1–2; undated). Crisis drivers were "market illiquidity, valuation uncertainty and counterparty credit concerns" (S7 p.4). "Margin levels in certain asset classes were insufficient to cover the close-out/liquidation risk" (S6, 21 of 43). Aaa-corporate volatility was applied to super-senior CDO tranches (S9 p.5). | **Strongly documented for the crisis reversal [R].** It complicates H4's "comparable disturbance" requirement (C4): for structured products the shock was not comparable to anything in the calibration window, because the products had no downturn history at all (S9 p.1). Mis-mapping a novel asset to a calm proxy is a different failure from eroded memory of a known shock. |
| **Sudden funding withdrawal (runs)** | Tri-party: run on specific institutions (Lehman), "something more similar to traditional bank runs" (S2 p.35). "little evidence of a market-wide run in the tri-party repo market" (S1 p.45). Bear Stearns lenders "declined to roll over… even when… supported by high-quality collateral" (Friedman via S1 p.37; outside the data window). Real-money withdrawal from securities lending "led to a severe contraction in the supply of secured financing" (S7 p.vii). The Task Force cites both "pull back in funding" and "meaningful increases in margin requirements" (S6, 21 of 43). | **The best-documented failure mechanism in tri-party.** It is a rival to margin insufficiency as the proximate cause of loss of viability. In the bilateral segment, margin spirals and withdrawal are both documented (S2 p.35). |
| **Regulatory change** | No evidence was collected on pre-2007 regulatory changes to margin or capital requirements. Post-shock policy (PDCF, authorized 16 Mar 2008) confounds all crisis-window observations (S1 p.68; S2 p.38–39). | **Not assessed for the pre-crisis period. Confirmed as a confounder for the 2008–10 data.** |
| **Competition (not pre-registered, raised by the sources)** | Named as the driver of pre-crisis haircut reduction by [C] S10, S11 and [R] S7 p.4, p.10, S5 p.14. | A rival *relaxation* mechanism that is not calm-conditioned. Competition and calm may interact: the CGFS ties both to "low financial market volatility" and "comfort" (S7 p.vii). No source separates them, and without a series they cannot be separated. |

---

## 7. H4 grades and severity

### 7.1 H4 grades (pre-registration §2)

| Segment | Grade | Reasons |
|---|---|---|
| **Tri-party repo** | **Not identifiable** | No margin data before 1 Jul 2008 (S1 p.17, fn.14; S2 p.12), so the rejection criterion ("did not decline during calm") cannot be evaluated. The crisis-window evidence weakens the V.3 mapping without contradicting H4: no shock reset, quantity rationing instead of margin response, contractual and rarely changed margins (S2 p.2, p.29–31, p.34; S1 p.8). All observations sit under the PDCF (S1 p.68). |
| **Bilateral repo (segments 4, 5)** | **Not identifiable** | FRBNY survey data from Jul 2008 only. The only 2007 index is academic and starts Jan 2007 (S12). Crisis increases are documented, but pre-crisis evolution is not. |
| **Prime brokerage / OTC initial margins** | **Not identifiable** | An actual reduction in protective terms is reported **contemporaneously** (S10 p.112–113; S11 p.37). It is undated, unquantified and attributed to competition. Calm-conditioning cannot be distinguished from competition. For liquid-asset portfolio margins, calibration to stressed periods (S7 p.4) contradicts the recent-experience component. Contemporaneous counter-signals exist (S11 p.37, p.48). |
| **Internal risk limits (VaR)** | **Not identifiable** | Experience-based calibration from "more benign periods" is documented [R] (S9 p.14; S7 p.3). A resulting *reduction of protective capacity* (limits, capital, buffers) is not documented. Aggregate VaR rose 2002–07 (S7 p.9). |
| **Capital / liquidity buffers** | **Not identifiable (not assessed)** | No evidence collected. Leads unverified. |
| **Overall H4** | **Not identifiable** | Stopping rule triggered (Section 3). Qualitative evidence establishes that protective credit terms in some segments were eased before mid-2007 and that some internal risk measures were calibrated on calm data. It cannot establish that the easing was calm-conditioned rather than competitive, exposure-driven or asset-mix-driven, or that it was the cause of loss of viability rather than funding withdrawal. **Not contradicted:** no segment has the calm-period data that the rejection rule requires. |

No result here is reported above level 2, and level 2 itself is not reached (Section 1).

### 7.2 Formal severity

Argument V classifies calm-period erosion as **severity 1** (operational mismatch: "a different floor would save the organization") until a point of no return, and severity 4 after it (§V.4, Severities). Under pre-registration §3, severity 1 requires "documentation that a policy revision… available to the organization would have preserved viability, with its latency."

**Severity: not identifiable, in every segment.**
- No record documents, for any firm, that a different margin or buffer policy available to it would have preserved funding viability. None gives a latency.
- For the one documented tri-party failure, the record points to counterparty-driven withdrawal that margins did not stop: "a haircut may not be sufficient for an investor if it has serious concerns about the viability of its counterparty" (Valukas via S1 p.25; S2 p.29). That is evidence against margin policy being the binding variable for that firm. It is a single case and does not establish a counterfactual either way.
- The PDCF provided emergency support throughout the measured window (S1 p.68). Under the pre-registered viability definition, survival under that support does not count as viability.
- Points of no return and margin μ cannot be located without a dated state series.

Severity 1 is therefore **not established**, and not ruled out either. Severities 2–4 do not arise from this evidence.

---

## 8. Prediction-test feasibility and data needed

**Feasibility: not feasible on available data.** The protocol (§7 of the plan) needs a frozen snapshot of contemporaneous indicators and comparison units. No contemporaneous margin series exists. The only contemporaneous evidence is qualitative (S10, S11). No panel of margins across surviving and failing firms exists for any pre-crisis date. M9 cannot be computed.

**Data that would be needed for the pre-registered test, by segment:**
1. **Tri-party:** clearing-bank custodial-agreement margin schedules by dealer × investor × collateral class, dated, covering at least 2000 – Jun 2008 and including Aug 2007 – Jun 2008. These are held by the two clearing banks and FRBNY and are confidential. S1 states FRBNY lacks the 2007–08 window (fn.14).
2. **Bilateral (segments 4 and 5):** dealer haircut schedules to clients and interdealer, dated, pre-2007, from more than one dealer. Today only one academic index from Jan 2007 exists (S12).
3. **Prime brokerage:** prime-broker initial-margin and portfolio-margin model parameters (look-back, stress overlays) with change dates. Also the contents of the FSA six-monthly prime-broker survey (S11 p.37), if its records include margin terms.
4. **Internal limits and buffers:** firm-level VaR limits, capital allocated to trading, and liquidity-buffer targets over time (supervisory data), so that a *reduction in protective capacity* can be separated from a *rise in measured exposure*.
5. **Disturbance measure:** fixed by dated amendment before inspecting any margin data (e.g., realized volatility of each collateral class, or a named market-stress index), with a stated calm threshold.
6. **Controls:** collateral mix by segment (dated), counterparty identity and rating, exposure (S4 is available for primary dealers), dated regulatory changes, and funding-market structure (tri-party/bilateral split, which S4 provides only from 2022).
7. **Comparison units:** firms that failed or needed emergency support vs firms that did not, with each one's pre-crisis margins, to test whether pre-crisis margins predicted resilience.

A forward-looking possibility, unverified for coverage: the Fed's SCOOS (from June 2010, qualitative) and the FRBNY monthly tri-party haircut statistics (from 2010) could support a properly pre-registered test on a *later* episode. That would be a different case and is not part of this study.

---

## 9. Limitations and unresolved conflicts

1. **Industry Task Force vs SR477/SR506 (unresolved).**
   - The Task Force (May 2010, private-sector, FRBNY-sponsored) reports "pro-cyclical increases in those margins when conditions did worsen during the crisis" (S6, 4 of 43). It also refers to "Cash Investors exiting the repo market or drastically changing their collateral requirements… and the meaningful increases in margin requirements in a deteriorating market" (S6, 21 of 43).
   - The FRBNY staff reports find tri-party margins "barely moved" (S1 p.2) and "did not behave procyclically" (S2 p.37).
   - Candidate reconciliations, none verifiable from these documents: (a) the Task Force refers to Aug 2007 – Jun 2008, a window S1/S2 lack (S1 fn.14); (b) it refers to non-Fed-eligible collateral or the tails, where S1 does report a dramatic expansion in haircut spreads after Lehman (S1 p.49); (c) "drastically changing their collateral requirements" refers to eligibility and withdrawal rather than margin levels; (d) the Task Force's wording reflects bilateral experience of member firms.
   - The FRBNY White Paper itself uses conditional language: stress "can lead to sudden withdrawals of credit or sharp increases in margins and haircuts" (S5 p.14).
   - **This conflict concerns the crisis response, not pre-crisis erosion,** so it does not change the H4 grade. It matters for any claim about C2 in tri-party.
2. **Two FRBNY reports disagree on bilateral size** (S2 p.7 ≈60% of repo; S1 p.4 "a small share"). SR477 also gives the April 2008 peak as $2.7tn (p.45) and as $2.8tn (p.17).
3. **Hindsight.** Nearly all mechanism statements are retrospective (S5–S9, 2008–2010). Only S10 (June 2007) and S11 (April 2007) are contemporaneous, and both are qualitative, rest on market contacts or unstated evidence, and attribute the change to competition.
4. **Snapshots are not a series.** The IMF (Citigroup-sourced) and CGFS (survey-based) tables give one early or mid-2007 level each, with different segments, tenors and counterparty definitions. They were not combined or extrapolated.
5. **Access.** The live IMF URL was blocked. The archived copy is byte-identical to the extractor's (verification V12). SR477/SR506 microdata are confidential, and only the figure points are public (S3).
6. **Segments not covered:** segment 3 (no known source, S2 p.8); securities lending; exchange-traded futures margins; regulatory capital and liquidity buffers (unverified leads).
7. **Scope of the theory test.** This case cannot falsify Theorem V.3, which is a proof. It tests whether the theorem's controller is an identifiable description of 2003–2008 protective-margin behaviour. The answer here is "not identifiable on available records". In addition, the best-measured segment (tri-party) does not show the shock-reset behaviour the controller assumes, and its documented failure mode is funding withdrawal.
8. **Earlier informal notes** in the workspace were not used (pre-registration §6).
