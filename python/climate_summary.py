"""Reconstruct the Lean climate report from the two independently checked result grids."""


def climate_summary(window_rows, paradox_rows):
    exact = sum(r["tAdaptCertificate"] == r["tAdapt"] for r in window_rows)
    lines = [
        f"Sweep 1 (rate window / points of no return): {len(window_rows)} configurations -> climate_window.csv",
        "Capacity-building point of no return exact over all schedules (certificate = constant-rate) "
        f"in {exact} of {len(window_rows)}",
        "",
        "Headline (capacity latency 2 yr, max scale-up 30%/yr): last start year that still works",
        "  cost psi  spend phi  target  TCRE     sigma(2027)  policy-only  build capacity  "
        "capacity-unconstrained  lock-in yrs  r_min(2027)",
    ]
    headline = [r for r in window_rows if int(r["L"]) == 2 and float(r["gmax"]) == 0.3]
    for r in sorted(headline, key=lambda r: (float(r["psi"]), float(r["phi"]), r["target"], r["tcre"])):
        lock = "-" if r["lockYears"] == "na" else r["lockYears"]
        lines.append(
            f"  {float(r['psi']):.6f}       {float(r['phi']):.6f}        {r['target']}    {r['tcre']}"
            f"  {r['sigma2027']}            {r['tPolicy']}        {r['tAdapt']}"
            f"            {r['tCapacityUnconstrained']}      {lock}            {r['rmin2027']}"
        )

    lines.extend([
        "", f"Sweep 2 (paradox): {len(paradox_rows)} configurations -> climate_paradox.csv", "",
        "Paradox at 2.0C, spend phi = 2. J = consumption proxy ($T) from 2027 up to the myopic point of no return",
        "  cost psi  TCRE     carbon $/t  builder window  myopic window  J builder  J myopic  "
        "myopic ahead until its window closes",
    ])
    viable = [r for r in paradox_rows if r["builder_viable"] == "1"]
    cases = [r for r in viable if r["target"] == "2.0C" and float(r["phi"]) == 2.0]
    for r in sorted(cases, key=lambda r: (float(r["psi"]), r["tcre"], float(r["carbon_price"]))):
        builder, cutoff, ahead = "-", "-", "window never lost"
        if r["myopic_loses_window"] == "1":
            builder = f"{float(r['J_builder_to_myopic_pnr']):.6f}"
            cutoff = f"{float(r['J_myopic_to_myopic_pnr']):.6f}"
            ahead = r["myopic_ahead_until_pnr"]
        lines.append(
            f"  {float(r['psi']):.6f}  {r['tcre']}  {float(r['carbon_price']):.6f}"
            f"     {r['tAdapt_builder']}            {r['tAdapt_myopic']}           {builder}      {cutoff}     {ahead}"
        )

    lost = [r for r in viable if r["myopic_loses_window"] == "1"]
    ahead_count = sum(r["myopic_ahead_until_pnr"] == "1" for r in lost)
    lines.extend([
        "",
        f"Builder path viable in {len(viable)} of {len(paradox_rows)} configurations; "
        f"myopic path loses the window in {len(lost)} of them;",
        f"in {ahead_count} of those {len(lost)}, the price-cutoff rule's cumulative consumption score "
        "equals or exceeds the builder's at every annual prefix through its last viable start",
    ])
    return lines
