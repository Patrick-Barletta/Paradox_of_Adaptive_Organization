# Build and verification log

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
