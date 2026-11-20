# Citation check: papers/ (2026-11-20)

Scope: the reference lists of Arguments I–III and the Climate Experiment, `Prior_Art_and_Positioning.md`, all 79 entries in `prior_art.bib`, and every pinpoint locator (theorem, section, figure, table, SPM paragraph) attached to a citation in those files.

Method: the reference lists and the bib were cross-checked against each other and against publisher, repository or index records. Every locator was checked against the source text wherever an open copy could be reached. Where a site blocked automated access or the article is paywalled, the item is listed under "not verified" rather than marked correct.

Result: no fabricated or mis-identified source. Every DOI, author list, venue, volume and page range that could be checked matches. Two attributions need rewording, one theorem number cannot be confirmed and should be dropped or checked by hand, and twelve locators remain to be checked by hand.

## 1. Fix before submission

| # | Where | Problem | Suggested fix |
|---|---|---|---|
| 1 | Prior_Art_and_Positioning.md, "What the synthesis adds" (Strnad et al. 2019, Fig. 5) | Overstates causality. The paper says the carbon tax cannot be used at once without violating the **social-foundation boundary**, so it is switched on later and switched off once renewables have passed most of their learning curve, while renewables are subsidised most of the time. It does not say that the early subsidies are what make the later tax safe. "Welfare floor" is also not the paper's term. | "In Figure 5 the agent subsidises renewables for most of the run; a carbon tax cannot be introduced immediately without breaching the social-foundation boundary and is switched on only later." |
| 2 | Argument III §III.4 and Prior_Art table (Abdulaziz & Kurz 2023, "Theorem 5") | Not confirmable. The arXiv version (2010.14648) does not number its theorems; its main results are a pair of completeness statements and a pair of soundness statements for the encode/decode functions. The AAAI page blocked automated access, so a "Theorem 5" in the published version could not be seen. | Drop the number ("Abdulaziz and Kurz (2023) machine-checked …"), or open the AAAI PDF and confirm it. |
| 3 | Argument III, Corollary III.1 (Bylander 1994, Theorem 4.1) | Theorem 4.1 is the right result (PLANMIN is PSPACE-complete, including the two-positive-precondition, two-postcondition restriction). But Bylander never states that the bound is written in binary. His hardness proof uses bounds of 2^n, which requires it. | "Bylander (1994, Theorem 4.1) proves bounded STRIPS plan existence PSPACE-complete, already with two positive preconditions and two postconditions per operator; the hardness proof uses bounds of size 2^n, so the bound must be written in binary." This also lets you cite the restricted case directly, instead of "(Section 3.1)". |

## 2. Minor wording (optional)

- **Aengenheyster et al. (2018).** The paper's control variable is the annual increase in the *mitigation share* (main cases 0.02 and 0.05 per year). The authors' press release calls this the renewable-energy share. "Renewable share" is acceptable; "mitigation (renewable) share" is exact.
- **IEA data-centre projection (Argument II, line ~235).** "~945 TWh in 2030" correctly cites *Energy and AI* (2025). The 2026 *Key Questions on Energy and AI* update gives about 950 TWh in 2030, up from 485 TWh in 2025. The 17% growth for 2025 is confirmed. Consider citing the 2026 figure too.

## 3. Confirmed locators and attributions

| Citation | Locator | Status |
|---|---|---|
| Feige & Kogan, arXiv 1909.03422 | Theorem 3.10 | Confirmed: in the directed case with threshold equal to in-degree, a set is a target set iff it is a feedback vertex set |
| Bylander 1994 | Theorem 4.1 (PLANMIN PSPACE-complete) | Confirmed |
| Bylander 1994 | Theorem 4.4 (no preconditions, ≤3 positive postconditions, NP-complete; credited to Erol et al.) | Confirmed |
| Bylander 1994 | delete-free + positive preconditions polynomial | Confirmed, but it is an unnumbered footnote, not a theorem; positive postconditions alone are NP-complete (Theorem 3.5) |
| Erol, Nau & Subrahmanian 1992 | Theorem 4 | Confirmed: propositional, positive, deletion-free, one precondition ("context-free"), *plan length* NP-complete |
| Giménez & Jonsson 2008 | Theorem 6.3 | Confirmed: binary polytrees NP-complete; the reduction uses unbounded indegree |
| Brafman & Domshlak 2003 | polytree with bounded indegree is polynomial | Result confirmed; "§3" not checked |
| Eriksson, Röger & Helmert 2017 | Definitions 1–2 | Confirmed: inductive set; certificate = contains the state, no goal states, inductive |
| De Lara, Gajardo & Vicencio 2020 | Theorem 7 | Confirmed: inclusion between viability kernels in infinite horizon |
| Petschel-Held et al. 1999 | §4, Fig. 4 | Confirmed: §4 "Necessary and Sufficient Emissions Corridors"; Fig. 4 maps waiting time × transition length × reduction rate |
| van Zalinge et al. 2017 | §2, §2.3, Fig. 1 | Confirmed: stochastic viability (§2.1), PNR definition with two separate delays (§2.3), Fig. 1 marks them |
| Aengenheyster et al. 2018 | §§2–3 | Confirmed: Methods / Results; last start at a given probability for fixed rates |
| Söntges, Koschi & Althoff 2018 | concept | Confirmed from the abstract: TTR = last time along the current trajectory at which an evasive trajectory exists |
| Hannan, Pólos & Carroll 2003 | claim | Confirmed: architecture → reorganization time and opportunity cost → mortality hazard |
| Löfberg 2012 | claim | Confirmed: analysis of recursive feasibility of a given MPC law |
| Pichancourt et al. 2025 | operational / collective-choice / constitutional levels; viability analysis | Confirmed from the abstract and published record |
| Mathias et al. 2017 | DICE, adaptive policy sets, delayed policies | Confirmed from the abstract |
| Botta et al. 2017 / 2018 / 2023 | topics | Confirmed (avoidability theory; uncertain emission policies; repeated start-or-delay green-transition decisions) |
| IPCC WGI 2021 SPM | D.1.1, Fig. SPM.10 | Confirmed: 0.45 °C per 1000 GtCO₂, likely 0.27–0.63 |
| IPCC WGIII 2022 SPM | Fig. SPM.7; "at least halve by 2030" | Confirmed; paragraph number C.12.1 from the standard text |
| IPCC SYR 2023 Annex I | pp. 119–130, DOI 10.59327/IPCC/AR6-9789291691647.002 | Confirmed |
| Global Carbon Budget 2026 | 43.3 GtCO₂ (2026), 0.3%/yr (2016–25), budgets 150/510/1,035 GtCO₂ from 2027 | Confirmed |
| IEA World Energy Investment 2026 | $2.2 trillion, scope as stated | Confirmed |
| IEA Net Zero Roadmap 2023 | ~$4.5 trillion/yr by early 2030s | Confirmed |
| Ember 2026 | 814 GW added in 2025, ~1,046 TWh/yr | Confirmed |
| IEA Energy and AI (2025) / Key Questions (2026) | 415 TWh (2024) → 945 TWh (2030); +17% in 2025 | Confirmed (see note in §2) |

## 4. Not verified (blocked or paywalled; check by hand)

1. Feige & Kogan, journal version, **Theorem 3.6** (the preprint's 3.10 is confirmed).
2. Abdulaziz & Kurz, **Theorem 5** (see Fix 2).
3. Söntges et al., **Proposition 1** (the concept is confirmed).
4. Stocker 2013, **Box 1 and Figs. 1–2** (the content is confirmed: required reduction rate rises with delay; finite-rate deadline vs immediate cessation).
5. Iyer et al. 2015, **Table 2**.
6. Vogt-Schilb & Hallegatte 2014, **§§4–5.1** (the content is confirmed from the abstract).
7. Mathias et al. 2017, **Methods and Fig. 2**, and the claim that the maximum rate of change in emissions control is varied.
8. Pichancourt et al. 2025, **Step 4.2, equations (3)–(4)**, and the "meta-level" action class.
9. Botta et al. **§§3–4 (2017), §1.1 (2018), §§3–4 (2023)**.
10. Dowling & Gallier 1984, **§4**.
11. Brafman & Domshlak 2003, **§3**.
12. Bylander 1994, **"Section 3.1"** for the positive-precondition construction (Fix 3 avoids needing it).

Bibliographic metadata for the classic references (Arthur, March, Holling, Karp, Papadimitriou & Tsitsiklis, Henzinger et al., Kelley & Walker, Wright, Wilson & Grubler, Coffrin & Van Hentenryck, Kittel et al., and others) matches the standard records; these were checked against existing records, not fetched one by one. The JSTOR book DOI for *Panarchy* (10.2307/jj.41003716) was not resolved.
