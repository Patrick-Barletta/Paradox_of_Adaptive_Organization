"""Argument V: structural concessions and calm-period erosion (Python reference).

Sweep A (structural concessions). At tick 0 the organization pays for one of two fixes:
  clean fix   cost C_FIX = 5; output 4 per productive tick; a forced policy switch costs 1 dead tick
  concession  cost C_CONC = 1; output capped at 3; a forced switch costs 2 dead ticks (the scar)
Upkeep is 2 per tick, a dead tick produces nothing, and reserves are capped at RMAX = 8 after the
cost is paid. Forced switches start at ticks P, 2P, 3P, ... A run is viable for horizon T if the
cost is affordable and reserves stay >= 0 through ticks 0..T-1. The post-choice dynamics are
deterministic, so each kernel is decided by one simulation.

Sweep B (calm-period erosion). Shocks of size M_REQ = 4 recur, each after L calm ticks, for
N_SHOCKS = 4 shocks. A calm tick earns 1; reserves are kept up to the controller's floor and the rest
is spent (output). A shock needs reserves >= M_REQ and removes M_REQ. Controllers: myopic (floor 0),
static (floor M_MAX = 6), adaptive (floor resets to M_MAX after a shock and drops by 1 after every
k consecutive calm ticks). Reserves start at M_MAX.

Prints the same text as the Lean executable `argV` (results/argV_output.txt).
"""

# ---------------- Sweep A ----------------
U, RMAX = 2, 8
C_FIX, C_CONC = 5, 1
OUT_FIX, OUT_CONC = 4, 3
DEAD_FIX, DEAD_CONC = 1, 2
R0S, PS, TS = range(1, 11), range(3, 9), range(4, 25)


def dead_ticks(P, d, horizon, extra=None):
    """Ticks with no output: d ticks from each forced switch at P, 2P, ..., plus an optional
    unscheduled switch starting at `extra`."""
    starts = list(range(P, horizon, P)) + ([extra] if extra is not None else [])
    return {s + i for s in starts for i in range(d)}


def viable(r0, P, T, concession, extra=None):
    cost, out, d = (C_CONC, OUT_CONC, DEAD_CONC) if concession else (C_FIX, OUT_FIX, DEAD_FIX)
    if r0 < cost:
        return False
    r = min(RMAX, r0 - cost)
    dead = dead_ticks(P, d, T, extra)
    for t in range(T):
        raw = r + (0 if t in dead else out) - U
        if raw < 0:
            return False
        r = min(RMAX, raw)
    return True


def crossover(r0, P):
    """Largest horizon in TS at which the concession is viable ('all' / 'none' at the ends)."""
    ok = [T for T in TS if viable(r0, P, T, True)]
    if not ok:
        return "none"
    return "all" if ok[-1] == TS[-1] else str(ok[-1])


def scar_window(r0, P, H=24):
    """Ticks at which one unscheduled forced switch kills the concession but not the clean fix,
    in cells where both survive the scheduled switches to horizon H."""
    if not (viable(r0, P, H, True) and viable(r0, P, H, False)):
        return None
    return [t for t in range(H) if not viable(r0, P, H, True, t) and viable(r0, P, H, False, t)]


def sweep_a():
    yield "Sweep A: structural concessions"
    yield (f"  clean fix: cost {C_FIX}, output {OUT_FIX}, {DEAD_FIX} dead tick per forced switch; concession: cost {C_CONC}, "
           f"output {OUT_CONC}, {DEAD_CONC} dead ticks; upkeep {U}; reserves capped at {RMAX}")
    yield f"  forced switches at ticks P, 2P, ...; starting reserves r0 = {R0S[0]}..{R0S[-1]}, horizons T = {TS[0]}..{TS[-1]}"
    yield "  crossover T*: largest horizon at which the concession is viable (all = through 24, none = not even 4)"
    yield "CROSSOVER r0 \\ P " + " ".join(f"{P:>4}" for P in PS)
    for r0 in R0S:
        yield f"CROSSOVER r0={r0:<2}   " + " ".join(f"{crossover(r0, P):>4}" for P in PS)
    counts = {"concession only": 0, "both": 0, "clean only": 0, "neither": 0}
    for r0 in R0S:
        for P in PS:
            for T in TS:
                c, f = viable(r0, P, T, True), viable(r0, P, T, False)
                counts["both" if c and f else "concession only" if c else "clean only" if f else "neither"] += 1
    yield "REGIMES " + ", ".join(f"{k} {v}" for k, v in counts.items()) + f" (of {sum(counts.values())} cells)"
    for r0 in R0S:
        for P in PS:
            w = scar_window(r0, P)
            if w:
                yield f"SCAR r0={r0} P={P}: {len(w)} ticks {w}"
    both_cells = sum(1 for r0 in R0S for P in PS if scar_window(r0, P) is not None)
    scar_cells = sum(1 for r0 in R0S for P in PS if scar_window(r0, P))
    yield f"SCAR summary: {scar_cells} of {both_cells} (r0, P) cells where both survive to 24 have a nonempty scar window"


# ---------------- Sweep B ----------------
M_MAX, M_REQ, INCOME, N_SHOCKS = 6, 4, 1, 4
KS, LS = range(1, 9), range(1, 26)


def run_b(controller, k, L):
    """Returns (survives all shocks, cumulative output, shocks survived)."""
    r, floor, calm, out = M_MAX, (0 if controller == "myopic" else M_MAX), 0, 0
    if controller == "myopic":
        out += r
        r = 0
    for shock in range(N_SHOCKS):
        for _ in range(L):
            r += INCOME
            if controller == "adaptive":
                calm += 1
                if calm == k:
                    floor, calm = max(0, floor - 1), 0
            keep = min(r, floor)
            out += r - keep
            r = keep
        if r < M_REQ:
            return False, out, shock
        r -= M_REQ
        if controller == "adaptive":
            floor, calm = M_MAX, 0
    return True, out, N_SHOCKS


def sweep_b():
    yield "Sweep B: calm-period erosion"
    yield (f"  shocks need reserves >= {M_REQ} and remove {M_REQ}; {N_SHOCKS} shocks, each after L calm ticks; a calm tick earns {INCOME}; "
           f"reserves start at {M_MAX}")
    yield f"  myopic floor 0; static floor {M_MAX}; adaptive floor resets to {M_MAX} after a shock, drops by 1 every k calm ticks"
    yield "  survival by calm interval L = 1..25 (S = survives all shocks, x = fails):"
    yield "SURVIVAL myopic       " + "".join("S" if run_b("myopic", 1, L)[0] else "x" for L in LS)
    yield "SURVIVAL static       " + "".join("S" if run_b("static", 1, L)[0] else "x" for L in LS)
    for k in KS:
        yield f"SURVIVAL adaptive k={k} " + "".join("S" if run_b("adaptive", k, L)[0] else "x" for L in LS)
    for k in KS:
        surv = [L for L in LS if run_b("adaptive", k, L)[0]]
        fail_after = [L for L in LS if not run_b("adaptive", k, L)[0] and run_b("static", k, L)[0]]
        lstar = fail_after[0] if fail_after else None
        bound = k * (M_MAX - M_REQ + 1)
        yield (f"THRESHOLD k={k}: adaptive survives L in {surv[0] if surv else '-'}..{surv[-1] if surv else '-'}; "
               f"L*={lstar if lstar else 'none'}; theorem bound k*(mMax-mReq+1)={bound}")
    for k in (2, 4):
        yield f"OUTPUT k={k} (myopic/static/adaptive cumulative output; * = adaptive fails):"
        for L in (2, 4, 6, 8, 10, 12, 16, 24):
            m, s, a = (run_b(c, k, L) for c in ("myopic", "static", "adaptive"))
            yield f"OUTPUT k={k} L={L}: {m[1]}/{s[1]}/{a[1]}{'*' if not a[0] else ''}"


def lines():
    yield "Argument V: structural concessions and calm-period erosion"
    yield from sweep_a()
    yield from sweep_b()


if __name__ == "__main__":
    for line in lines():
        print(line, flush=True)
