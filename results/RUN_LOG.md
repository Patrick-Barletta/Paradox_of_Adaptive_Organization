# Build and verification log

## Arguments V and VI in the four control classes, with modeling variants; Argument VI Part II, 22 November 2026

Windows, Lean 4.15.0. Argument V's sweeps and Argument VI's model were rebuilt as control systems on explicit $`(x,O,\pi,q)`$ states, with the four classes of I.3.3 as lists of admissible actions (`Paradox/ConcessionModel.lean`, `Paradox/RatchetModel.lean`). Argument VI Part II (three agents on a shared chain) was added on the same machinery, with adversaries as I.3.8 disturbances (`Paradox/SharedRatchet.lean`, `Paradox/SharedRatchetModel.lean`, `argVI multi`). `Theory.lean`, `Concession.lean` and `Ratchet.lean` are unchanged.

Modeling choices that A0–A3 do not settle are reported as variants, and every result is either computed in all of them or stated with the choice it depends on:

- **Argument V, Sweep A:** whether a forced switch cancels a realignment in flight; seizure vs suspended operations for an uncleared obligation.
- **Argument VI:** authorization at a crisis's first tick vs any tick; whether work in flight can be abandoned.
- **Part II:** whether neutral routines vote yes or no; covert vs overt adversaries.

Agreement with the earlier stylized models is not used as validation.

| Verification | Result |
|---|---|
| Axioms | Every theorem in `ConcessionModel.lean` (14), `RatchetModel.lean` (25) and `SharedRatchet.lean` (54) uses at most `propext`, `Classical.choice` and `Quot.sound`. No `sorry`, no `native_decide`; concrete reference facts use `decide +kernel`. The reference theorems of Arguments V and VI (`ref_shift`, `ref_patch_only`, `ref_lockin`, `ref_no_seed`, `ref_prune_sustainable`) hold in every variant; `variant_mono` proves that Argument VI's variant flags only add actions. |
| No regression | `.\run_all.ps1` rebuilt everything. The 11 other committed outputs are byte-identical (SHA-256); `argV_output.txt` and `argVI_output.txt` changed by design, and `argVI_multi_output.txt` is new. |
| Argument V | `argV_output.txt` (443 lines; Sweep A under all four variants). Nesting: 7,560 checks per variant + 600, no violation. Crossover table, regimes, post-concession severities (0/1/2/3: 368/630/138/124) and the 18-of-24 scar-window count hold in every variant. The scar windows' extent depends on the cancel choice, and decision-state severity 0 (18 cells) appears only with suspended operations. Sweep B severities are 0, 1 or 4 only. |
| Argument VI | `argVI_output.txt` (70 lines, Lean only, all four variants). Nesting: 58,904,490 checks without abandonment and 98,522,037 with it, no violation. In every variant: severity at the start 0/1/2/3/4 = 18/0/1,537/129/260; the bound is exact (1,926 of 1,926); the patch routine passes its adaptive point of no return while its patches still succeed in 1,537; rule survival 18, 1,040 (1,424 patching when unaffordable), 1,152, 789; the adaptive kernel contains the start in 1,555. Depending on the choices: an earlier crisis than the failing one in 927 (first-tick authorization) vs 410 (any tick); exit severity 3/4 in 529/1,008 (no abandonment) vs 834/703 (abandonment). |
| Argument VI Part II | `argVI_multi_output.txt` (29 lines). Nesting: 20,891,364 checks, no violation. With neutral routines voting no, unanimity gives CNN exactly its no-seed survival in all 324 configurations. |
| Python comparisons | `python python/crosscheck_all.py`: exit 0 in 685 s, zero mismatches in all 12 comparisons, including `argV` (443 lines) and `argVImulti` (29 lines). Argument VI's single-organization sweep has no Python mirror. |

## Argument VI (the escape ratchet), 22 November 2026

Windows, Lean 4.15.0. Added `Paradox/Ratchet.lean` (theory), `Paradox/RatchetModel.lean` (reference proofs and the exact model), `ArgVIMain.lean` (target `argVI`) and `python/toy/argVI.py`. `Theory.lean` is unchanged.

| Verification | Result |
|---|---|
| Axioms | All 27 theorems in `Ratchet.lean` and `RatchetModel.lean` use at most `propext`, `Classical.choice` and `Quot.sound`; `chain_grows`, `esc_done_viable` and `invariant_viable` use none. No `sorry`, no `native_decide`. |
| No regression | `.\run_all.ps1` rebuilt everything. All 12 committed outputs are byte-identical (SHA-256). |
| New output | `argVI_output.txt` (30 lines). Reference: bootstrap times 2, 4, 6, 8; first infeasible patch cycle 3, equal to the bound; regime 3 has severity 3 with the seed present and 4 without. Sweep of 1,944 configurations: the bound is exact in all; the patch-only path leaves the adaptive kernel in 1,316 (severity 3 in 658, severity 4 in 658), before the patch failure in 694; survival over 12 cycles is 18 for patch-only and 1,555 for the full-lookahead planner. |
| Python comparisons | `python python/crosscheck_all.py`: exit 0 in 489 s, zero mismatches in all 12 comparisons, including the new `argVI` check. |

## Argument V (concessions and erosion), 22 November 2026

Windows, Lean 4.15.0. Added `Paradox/Concession.lean` (theory), `Paradox/ConcessionModel.lean` and `ArgVMain.lean` (target `argV`) and `python/toy/argV.py`.

| Verification | Result |
|---|---|
| Axioms | `viab_V` and `clean_viab`: none. `viab_shorten`, `horizon_antitone`, `clean_fail`, `conc_viab`, `conc_fail`, `concession_crossover`, `calm_floor`, `calm_erosion_fatal`: `propext`, `Quot.sound`. No `sorry`, no `native_decide`. `Paradox/ConcessionModel.lean` is computational and contains no theorems. |
| No regression | `.\run_all.ps1` rebuilt everything. All 11 committed outputs are byte-identical (SHA-256). |
| New output | `argV_output.txt` (76 lines). Sweep A: crossover horizons from 4 to beyond 24 ticks; 369 concession-only, 629 both, 127 clean-only and 135 neither cells of 1,260; scar windows in 18 of the 24 cells where both choices survive to 24. Sweep B: the adaptive shield survives calm intervals 4 to 3k − 1 and fails from L* = 3k, equal to Theorem V.3's bound, for k = 2..8. |
| Python comparisons | `python python/crosscheck_all.py`: exit 0 in 497 s, zero mismatches in all 11 comparisons, including the new `argV` check. |

## Seed undervaluation (W3) and acceleration costs (E-II.6), 22 November 2026

Windows, Lean 4.15.0. Added the W3 lemmas to `Paradox/Theory.lean`, optional acceleration costs to `Paradox/Climate.lean` and `python/climate.py` (off by default), and the `argII ramp` option.

| Verification | Result |
|---|---|
| Axioms | `robust_seed_value`, `robust_never_picks_seed`, `robust_seed_nonpos`: `propext`, `Quot.sound`. `seed_example`: none. No `sorry`, no `native_decide`. |
| No regression | `.\run_all.ps1` rebuilt everything. All ten previously saved outputs (TXT and CSV, including `argIII_timed_output.txt`) are byte-identical (SHA-256) to the committed versions. E-II.6 is printed only by `argII ramp`, so `argII_output.txt` is unchanged. |
| New output | `argII_ramp_output.txt` (43 lines). The stopping-rule program acquires an upper rate limit under a convex ramp premium (at capacity cost 1: 44% with exponent 2, 25% with exponent 3). The window stays nonempty, and the closing year moves by at most two years. Embodied emissions barely affect the stopping-rule program but close the grow-forever window early. |
| Python comparisons | `python python/crosscheck_all.py`: exit 0 in 493 s, with zero mismatches in all ten comparisons, including the new `ramp` check against `experiments_ii.py ramp`. |

## Timed bootstrap (Demonstration III.C), 22 November 2026

Windows, Lean 4.15.0. Added `Paradox/Timed.lean` and the `argIII C` option.

| Verification | Result |
|---|---|
| Build | `.\run_all.ps1`: `lake build` succeeded and every executable ran. |
| Axioms | `timed_bootstrap_static_reachable`: none. `timed_bootstrap_reachable_long_seed`: `propext`. `timed_bootstrap_timed_unreachable` and `timed_unreachable_of_short_seed`: `propext`, `Classical.choice`, `Quot.sound`. No `sorry`, no `native_decide`. |
| No regression | All nine previously published outputs (TXT and CSV) were regenerated and are byte-identical (SHA-256) to the committed versions. III.C is printed only by `argIII C`, so `argIII_output.txt` is unchanged. |
| New output | `argIII_timed_output.txt` (15 lines): E is in the static closure of {B}; E is never online within 20 ticks for seed endurance L = 0–9, and is online at tick 10 for L = 10–12. |
| Python comparisons | `python python/crosscheck_all.py`: exit 0 in 515 s, with zero mismatches in all nine comparisons, including the new `timed` check against `python/toy/argIII.py C`. |

## Friction extension, 22 November 2026

`Paradox/Model.lean` and `python/toy/kernels.py` gained two optional frictions, skill decay and a training cost. Both are off by default. With them off, `.\run_all.ps1` regenerated all eight earlier outputs byte for byte (no change in `git diff`), and `Params.step_valid` was reproved for every decay setting and training cost. The new `friction` executable writes `friction_output.txt` (ten friction settings × 6,000 Experiment E settings, about 7 minutes). Its first row reproduces the Experiment E counts. `python python/crosscheck_all.py friction` compares it line by line with the independent Python reference, which maximizes the second lookahead tick over all actions where Lean uses all-forage.

## Corrected models, 20 November 2026

The Windows Lean 4.15.0 toolchain built the library, certified facts and all five executables from a clean copy of the source. All eight published TXT and CSV outputs were regenerated. The full Python reference checks and an independent regeneration are recorded below.

| Verification | Result |
|---|---|
| Independent regeneration | Two clean builds, including the Windows `run_all.ps1` entry point, produced identical SHA-256 hashes for each of the eight published outputs. |
| Python comparisons | The full command exited successfully with zero mismatches across 324 climate-window rows, 288 climate-comparison rows and 6,000 settlement settings. All five text reports matched, covering 81 climate lines, 85 Argument II lines, 51 settlement-report lines, 14 Argument III lines and 68 Experiment E lines. |
| Settlement base case | Both two-tick stock policies specialize. With the foraging tie rule, the settlement holds 11 food at tick 11 and is locked in. With the training tie rule it holds 17, remains viable under the incumbent, and finishes at tick 16 with 20. |
| Settlement state validity | Lean checked the general `Params.step_valid` theorem. In all 600 settings with one worker-tick of specialist training, the simultaneous training-and-specialization action from the initial state produced a valid successor. The table classified it as viable and its survival plan passed forward verification. |
| Experiment E | The prescribed paths form a strong pair in 1,581 of 6,000 settings. The foraging tie rule enters lock-in in 4,940 settings and survives in 1,060. The training tie rule survives in all 6,000. |
| Climate windows | The witness and exclusion years agree in all 324 configurations and on both paths for all 288 pairs. At the central 2°C headline settings, the last start years are 2040 with capacity building and 2045 with unlimited capacity. |
| Climate robustness | The one-, two- and three-year order-arrival checks and the terminal budget check passed. None of 12,000 tested submaximal schedules beat maximal deployment in the comparison. None of 106 states excluded by the constant-rate scan were rescued by the tested two-phase programs. |
| Corrupted inputs | On disposable copies the command returned exit code 1 for incorrect headers, incomplete or duplicate grids, malformed rows, a changed climate value, a changed settlement policy outcome and edits to the Argument III, climate and Experiment E text reports. |

Run `.\run_all.ps1` from the project root on Windows to rebuild and regenerate the eight outputs. Then run `python python/crosscheck_all.py` for the saved-output comparisons and `python python/checks.py` for the climate robustness checks.

## Earlier build history

### 20 November 2026, 02:16 UTC

Built and run on this computer, in the Linux workspace VM, with Lean 4.15.0 (x86_64-unknown-linux-gnu).

| Step | Time | Result |
|---|---|---|
| lake build (all proofs, certified facts, 5 executables) | 16 s | success |
| report | 0.07 s | identical to reference output |
| climate | 5.5 s | identical CSVs and output |
| argII | 2.4 s | matches the Python reference on every line |
| experimentE | 57 s | identical output and CSV |

Fix applied: removed `deriving Repr` from the climate parameter structure (`Paradox/Climate.lean`).
Deriving Repr for that many fields made elaboration take many minutes.

To run with your Windows Lean instead: open PowerShell in this folder and run `.\run_all.ps1`.

### Argument III, 20 November 2026, 03:23 UTC

- Added `planning_iff_escape_A0` to `Paradox/Escape.lean`: Theorem III.1 with the terminal set on a physical goal bit (Assumption A0), equivalence at n + 1 steps.
- `lake build`: success. `#print axioms` for both escape theorems: `propext`, `Quot.sound` only (no `sorry`, no `native_decide`).
- `argIII`: output identical to `argIII_output.txt`.
