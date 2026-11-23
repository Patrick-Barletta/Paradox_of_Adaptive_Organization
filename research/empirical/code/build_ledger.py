"""Merge and validate the per-case source ledgers, and write the reproducibility manifest.

Usage (from the repository root):
    python research/empirical/code/build_ledger.py

Inputs:  research/empirical/evidence/case*_ledger.csv (one per case: the 13 pre-registered columns
         plus `question`, the extraction question each row answers)
Outputs: research/empirical/SOURCE_LEDGER.csv   (all rows, with a leading `case` column)
         research/empirical/ledger_summary.txt   (row counts by case, evidence group, confidence)
         research/empirical/MANIFEST.txt         (SHA-256 of every file under research/empirical/)

Validation: every row must have exactly the 13 pre-registered columns plus `question`, a non-empty
source_id, fact and evidence_group, and an evidence_group that is CONTEMPORANEOUS or RETROSPECTIVE.
The script stops with an error otherwise. No row is altered.
"""
import csv
import hashlib
import io
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]          # research/empirical
COLUMNS = ["source_id", "institution", "document", "publication_date", "event_date", "original_url",
           "archive_path", "page_or_section", "fact_or_measurement", "observation_date", "confidence",
           "limitations", "evidence_group", "question"]
CASES = {"caseA": "A Boeing 737 MAX", "caseB": "B 2003 blackout", "caseC": "C CrowdStrike 2024",
         "caseD": "D Financial crisis", "caseE": "E NASA"}


def load(path):
    with io.open(path, encoding="utf-8", newline="") as fh:
        rows = list(csv.reader(fh))
    header, body = rows[0], rows[1:]
    if header != COLUMNS:
        sys.exit(f"{path.name}: header {header} does not match the schema")
    for i, r in enumerate(body, start=2):
        if len(r) != len(COLUMNS):
            sys.exit(f"{path.name} line {i}: {len(r)} columns")
        rec = dict(zip(COLUMNS, r))
        if not rec["source_id"] or not rec["fact_or_measurement"]:
            sys.exit(f"{path.name} line {i}: empty source_id or fact")
        group = rec["evidence_group"].strip().upper()
        if not (group.startswith("CONTEMPORANEOUS") or group.startswith("RETROSPECTIVE")):
            sys.exit(f"{path.name} line {i}: evidence_group {rec['evidence_group']!r}")
    return body


def main():
    evid = ROOT / "evidence"
    merged, summary = [], []
    for key, name in CASES.items():
        path = evid / f"{key}_ledger.csv"
        body = load(path)
        merged += [[key] + r for r in body]
        groups = Counter(r[12].strip().upper().split()[0].rstrip(";,") for r in body)
        norm = {"h": "high", "m": "medium", "l": "low"}          # abbreviations used in one ledger
        conf = Counter(norm.get(c, c) for c in (r[10].strip().lower() or "unstated" for r in body))
        summary.append(f"{name}: {len(body)} rows; evidence groups {dict(sorted(groups.items()))}; "
                       f"confidence {dict(sorted(conf.items()))}")
    with io.open(ROOT / "SOURCE_LEDGER.csv", "w", encoding="utf-8", newline="") as fh:
        w = csv.writer(fh, lineterminator="\n")   # LF, matching .gitattributes, so hashes survive checkout
        w.writerow(["case"] + COLUMNS)
        w.writerows(merged)
    summary.append(f"total: {len(merged)} rows")
    with io.open(ROOT / "ledger_summary.txt", "w", encoding="utf-8", newline="\n") as fh:
        fh.write("\n".join(summary) + "\n")
    print("\n".join(summary))

    lines = []
    for p in sorted(ROOT.rglob("*")):
        if p.is_file() and p.name != "MANIFEST.txt" and "__pycache__" not in p.parts:
            lines.append(f"{hashlib.sha256(p.read_bytes()).hexdigest()}  {p.relative_to(ROOT).as_posix()}")
    with io.open(ROOT / "MANIFEST.txt", "w", encoding="utf-8", newline="\n") as fh:
        fh.write("\n".join(lines) + "\n")
    print(f"manifest: {len(lines)} files")


if __name__ == "__main__":
    main()
