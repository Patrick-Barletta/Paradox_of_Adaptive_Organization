# The Paradox of Adaptive Organization

Three linked arguments about how adaptive systems lose, and can sometimes regain, the ability to recover, with a Lean 4 formalization and Python reference implementations. The papers are working drafts (November 2026).

## The arguments

| | Paper | Claim in one line |
|---|---|---|
| I | [**The Paradox of Adaptive Organization**](papers/Argument_I_Paradox_of_Adaptive_Organization.md) ([PDF](papers/Argument_I_Paradox_of_Adaptive_Organization.pdf)) | A settlement with more food can lose its recovery option first. Two rules that maximize stored food over the next two ticks produce different outcomes when they resolve ties differently. |
| II | [**On the Necessity of Acceleration**](papers/Argument_II_Necessity_of_Acceleration.md) | Under a deadline, staying viable can require building capabilities faster. Once the required rate exceeds the incumbent rate, waiting along the incumbent path cannot lower it. |
| III | [**The Adaptive Escape Problem**](papers/Argument_III_Adaptive_Escape_Problem.md) ([PDF](papers/Argument_III_Adaptive_Escape_Problem.pdf)) | A Lean-checked reduction transfers the binary-horizon planning lower bound to escape. For specific models, feasible paths and proofs of infeasibility distinguish established outcomes from unresolved cases. |

[Climate_Experiment.md](papers/Climate_Experiment.md) applies Arguments I and II to a calibrated, stylized climate model. Its results are conditional on the model and are not a forecast.

[Prior art and positioning](papers/Prior_Art_and_Positioning.md) maps each argument to its closest published precedents, with theorem and figure locators and suggested wording for an introduction. The [BibTeX bibliography](papers/prior_art.bib) can be imported into a reference manager.

## What is machine-checked

| File | What it is | Trust level |
|---|---|---|
| `Paradox/Theory.lean` | General proofs. Argument I: simulation theorem; Proposition 1 (nesting, exact and dominance forms); Proposition 3 (monotone loss) and its contrapositive; Proposition 3′ (robust, strengthened); a formal counterexample showing Proposition 3 fails for robust kernels; Proposition 4 and the paradox fingerprint corollary. Argument II: `rate_upward`, `delay_never_lowers_required_rate` (Proposition II.1), `greedy_suffices` | Fully proved. No `sorry`, no `native_decide`. Axioms: none, or only `propext` and `Quot.sound` (from `omega`) |
| `Paradox/Escape.lean` | Argument III: STRIPS instances, the escape problem, `escape_wait`, `planning_iff_escape` and `planning_iff_escape_A0` (Theorem III.1) | Fully proved. No `sorry`, no `native_decide`. Axioms: `propext` and `Quot.sound` only |
| `Paradox/Model.lean` | Settlement transitions and a general proof that every successful step preserves the training-state invariant used by the kernel table | The proof covers every pair of training thresholds |
| `Paradox/Kernel.lean` | Exact kernels by backward recursion; severity; witnesses; independent verification; points of no return; nesting, Proposition 4 and fingerprint checks | — |
| `Paradox/Certified.lean` | Five severities, verified witnesses, 17,136 time-indexed states, nesting, the prescribed pair (recovery windows 12 vs 10), both decision rules at tick 11 and the horizon, and the simultaneous training/specialization regression | `native_decide` trusts the Lean compiler (`Lean.ofReduceBool`) |
| `Paradox/Climate.lean`, `ClimateMain.lean` | Climate recovery windows, rate bounds, and the comparison of a capacity builder with a carbon-price cutoff rule | Numerical results for all 612 configurations are cross-checked with Python. The climate-specific dominance argument is given in the paper. |
| `Report.lean` | Executable: demonstration states, the paradox pair, and the Proposition 4 and fingerprint checks | Output identical to `python/toy/report.py`, line for line |
| `Paradox/Decision.lean`, `ExperimentE.lean` | Two-tick stock-maximizing decisions under both tie-breaking rules, plus the prescribed-path comparison over 6,000 settings | Each result field is checked against `python/toy/experiment_e.py` |
| `ArgIIMain.lean` | Executable: Argument II experiments (the acceleration dilemma, AI as accelerator and margin consumer, monotonicity of the required rate, constraint ablation, carbon-price thresholds) | Output identical to `python/experiments_ii.py lean`, line for line |
| `ArgIIIMain.lean` | Executable: demonstrations III.A (restoration independence) and III.B (the bounds gap) | Output identical to `python/toy/argIII.py`, line for line |

`Theory.lean` and `Certified.lean` are not formally linked. The theory proves the propositions for any system satisfying the stated hypotheses. The certified file establishes the computed facts for this one model.

The Python reference is an independent implementation of the same models. All of the comparisons in the table are rerun by one command, `python python/crosscheck_all.py` (see below).

## Layout

```
Paradox/          Lean library: proofs, models, kernels
Paradox.lean      library root
*Main.lean, Report.lean, ExperimentE.lean
                  executables (targets: report, experimentE, climate, argII, argIII)
papers/           the three arguments and the climate experiment write-up
results/          saved output of every executable, plus the build and run log
python/           Python reference for the climate model and Argument II
python/toy/       Python reference for the settlement model (I.3.10) and Argument III
run_all.ps1       build and regenerate everything in results/ (Windows)
```

## Build and run

Requires Lean 4.15.0. With [elan](https://github.com/leanprover/elan) installed, the version is picked up from `lean-toolchain`. The project has no dependencies, so there is nothing to download beyond the toolchain.

```
lake build                         # proofs, certified facts and all executables (under a minute)
```

The executables write their CSV files to the current directory, so run them from `results/`:

```
cd results
../.lake/build/bin/report          # demonstration states and paradox pair (<1 s)
../.lake/build/bin/experimentE     # full sweep; writes experimentE_results.csv
../.lake/build/bin/experimentE 200 # first 200 settings only
../.lake/build/bin/climate         # climate sweeps (~10 s); writes climate_window.csv, climate_paradox.csv
../.lake/build/bin/climate --check # values for cross-checking against python/climate.py
../.lake/build/bin/argII           # Argument II experiments (a few seconds)
../.lake/build/bin/argIII          # Argument III demonstrations
```

On Windows, `.\run_all.ps1` builds everything and regenerates the files in `results/`.

### Python reference

Python 3, standard library only.

```
python python/crosscheck_all.py           # verify all three result CSVs and all five text reports
```

The checker validates grid coordinates and columns, recomputes all model results, and compares the saved reports line by line. The two sweep summaries are reconstructed from the verified rows. A mismatch, missing setting, or malformed file produces a nonzero exit status. A successful run reports these comparisons (the Experiment E line covers both its CSV and its 68-line summary).

```
window: 324 rows, 0 field mismatches
paradox: 288 rows, 0 field mismatches
climate: 81 lines, 0 differ from results/climate_output.txt
argII: 85 lines, 0 differ from results/argII_output.txt
report: 51 lines, 0 differ from results/report_output.txt
argIII: 14 lines, 0 differ from results/argIII_output.txt
experimentE: 6000 settings, 0 field mismatches
```

Pass a name (`window`, `paradox`, `climate`, `argII`, `report`, `argIII`, `experimentE`) to run one comparison. The individual scripts can also be run directly:

```
python python/experiments_ii.py           # Argument II experiments, readable form (add `lean` for the Lean format)
python python/checks.py                   # dominance and two-phase robustness checks
python python/toy/report.py               # settlement model: demonstration states, paradox pair, checks
python python/toy/argIII.py               # demonstrations III.A and III.B (pass A or B for one)
python python/toy/experiment_e.py         # Experiment E, all 6,000 settings (pass n for the first n)
```

## Experiment E grid

| Parameter | Values |
|---|---|
| Specialist retraining, worker-ticks | 1–10 (generalists fixed at 2) |
| Specialization bonus | 1, 2 |
| Storage capacity | 12, 16, 20, 24, 30 |
| Horizon | 12, 14, 16, 18, 20 |
| Ticks of full wild yield | 3–6 |
| Ticks of half wild yield | 0–2 |

Across the 6,000 settings, the two-tick stock rule that favors foraging enters lock-in in 4,940 (82.3%). The rule that favors training survives all 6,000. The prescribed specialist/generalist comparison shows storage dominance and an earlier closing window in 1,581 settings (26.4%). In the CSV, `paradox` records that prescribed-pair result, `forageFirstLock` and `trainFirstLock` record the first locked-in tick (−1 if absent), and the survival columns record arrival at the horizon. The two `StrongVsA` columns compare the corresponding decision rule with generalist A at the same tick. See `results/experimentE_output.txt` and `results/experimentE_results.csv`.
