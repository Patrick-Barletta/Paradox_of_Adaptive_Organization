"""Argument V in the four control classes of I.3 (Python reference).

Sweep A (structural concessions). State s = (x, O, pi, q): x = reserves r (A0: viable iff r >= 0 after
upkeep); O = scarred (a concession's scar: output capped at 3 and a policy realignment needs a
latency-1 implementation move); pi = aligned (a forced switch misaligns the operating policy);
q = (obligation pending, implementation move in flight). Step 0 is the decision step: the acute
obligation must be cleared by a capability-changing move, the clean fix (cost 5) or the concession
(cost 1, scar); left uncleared, reserves are seized. Operating ticks 1..T: upkeep 2; output 4 (3 if
scarred) on an aligned tick without a forced switch; forced switches at operating ticks P, 2P, ...
(operating tick = step - 1) misalign the policy for that tick and after, and cancel a realignment in
flight; reserves capped at 8.
Classes: fixed = incumbent policy, never revised and no moves; policy = free realignment (an
implementation move when scarred), no capability-changing moves; adapt = adds the clean fix and the
concession, at the decision step or later (clean fix later: cost 5, effective next tick); phys = also
clears the obligation at no cost, output 4 and realignment without the implementation move.

Sweep B (calm-period erosion). State: x = reserves r; pi = the reserve floor; q = calm-streak counter.
N_SHOCKS rounds of L calm ticks then a shock (needs r >= M_REQ, removes M_REQ). A calm tick earns 1 and
the organization keeps some of its reserves, spending the rest. Classes: fixed = the adaptive
empirical shield (floor resets to M_MAX after a shock, drops by 1 after every k calm ticks, keeps
min(r, floor)); policy = any amount kept (free revision of the floor); adapt and phys have no further
actions in this model, so their kernels equal the policy kernel.

Kernels are computed by exact backward recursion. Prints the same text as the Lean executable `argV`
(results/argV_output.txt).
"""
from functools import lru_cache

# ---------------- Sweep A ----------------
U, RMAX = 2, 8
C_FIX, C_CONC = 5, 1
OUT_FIX, OUT_CONC = 4, 3
R0S, PS, TS = range(1, 11), range(3, 9), range(4, 25)
CLASSES = ("fixed", "policy", "adapt", "phys")


def switch_at(P, extra, t):
    """Forced switch at step t (operating tick t - 1)?"""
    tau = t - 1
    return t >= 1 and ((tau >= P and tau % P == 0) or tau == extra)


def actions_a(k, s, t):
    """Admissible actions at state s = (r, scar, aligned, impl, oblig) and step t.
    An action is (decide, realign, cleanlater, free): decide in {None, 'clean', 'conc', 'free'} at the
    decision step; realign: revise the policy; cleanlater: clean fix after the decision step; free:
    the physical class's unrestricted output and realignment."""
    r, scar, aligned, impl, oblig = s
    out = []
    if oblig:
        decs = [None]
        if k in ("adapt", "phys"):
            if r >= C_FIX:
                decs.append("clean")
            if r >= C_CONC:
                decs.append("conc")
        if k == "phys":
            decs.append("free")
        return [(d, False, False, False) for d in decs]
    for realign in ((False,) if k == "fixed" else (False, True)):
        for later in ((False, True) if k in ("adapt", "phys") and scar and r >= C_FIX else (False,)):
            for free in ((False, True) if k == "phys" else (False,)):
                out.append((None, realign, later, free))
    return out


def step_a(s, a, t, P, extra):
    """Next state, or None if down."""
    r, scar, aligned, impl, oblig = s
    dec, realign, later, free = a
    if oblig:
        if dec is None:
            return None                                   # obligation uncleared: reserves seized
        if dec == "clean":
            return (min(RMAX, r - C_FIX), False, True, False, False)
        if dec == "conc":
            return (min(RMAX, r - C_CONC), True, True, False, False)
        return (min(RMAX, r), False, True, False, False)  # physical class: no obligation
    if impl:
        aligned, impl = True, False                       # implementation move completes
    if realign and not aligned and not impl:
        if scar and not free:
            impl = True                                   # needs a latency-1 implementation move
        else:
            aligned = True                                # immediate revision
    sw = switch_at(P, extra, t)
    produce = aligned and not sw
    out = (OUT_FIX if (not scar or free) else OUT_CONC) if produce else 0
    if sw:
        aligned, impl = False, False                      # a switch cancels a realignment in flight
    cost = C_FIX if later else 0
    raw = r + out - U - cost
    if raw < 0:
        return None
    return (min(RMAX, raw), scar and not later, aligned, impl, False)


def kernel_a(k, s, T, P, extra=None):
    """s at step 0 viable for T operating ticks (steps 1..T after the decision step)?"""
    @lru_cache(maxsize=None)
    def win(s, t):
        if t == T + 1:
            return True
        return any((y := step_a(s, a, t, P, extra)) is not None and win(y, t + 1) for a in actions_a(k, s, t))
    return win(s, 0)


def kernel_a_post(k, s, T, P, extra=None):
    """A state just after the decision step (step 1), viable through operating ticks 1..T."""
    @lru_cache(maxsize=None)
    def win(s, t):
        if t == T + 1:
            return True
        return any((y := step_a(s, a, t, P, extra)) is not None and win(y, t + 1) for a in actions_a(k, s, t))
    return win(s, 1)


def pre(r0): return (r0, False, True, False, True)
def post_conc(r0): return (min(RMAX, r0 - C_CONC), True, True, False, False)
def post_clean(r0): return (min(RMAX, r0 - C_FIX), False, True, False, False)


def sev(ks):
    for i, k in enumerate(ks):
        if k:
            return i
    return 4


def conc_ok(r0, P, T, extra=None):
    return r0 >= C_CONC and kernel_a_post("policy", post_conc(r0), T, P, extra)


def clean_ok(r0, P, T, extra=None):
    return r0 >= C_FIX and kernel_a_post("policy", post_clean(r0), T, P, extra)


def crossover(r0, P):
    ok = [T for T in TS if conc_ok(r0, P, T)]
    if not ok:
        return "none"
    return "all" if ok[-1] == TS[-1] else str(ok[-1])


def scar_window(r0, P, H=24):
    if not (conc_ok(r0, P, H) and clean_ok(r0, P, H)):
        return None
    return [t for t in range(H) if not conc_ok(r0, P, H, t) and clean_ok(r0, P, H, t)]


def sweep_a():
    yield "Sweep A: structural concessions"
    yield (f"  state (x, O, pi, q): reserves; scarred; policy aligned; obligation pending, implementation move in flight; "
           f"clean fix cost {C_FIX}, output {OUT_FIX}; concession cost {C_CONC}, output {OUT_CONC} and a latency-1 "
           f"implementation move per realignment; upkeep {U}; reserves capped at {RMAX}")
    yield f"  forced switches at operating ticks P, 2P, ...; starting reserves r0 = {R0S[0]}..{R0S[-1]}, horizons T = {TS[0]}..{TS[-1]}"
    yield "  crossover T*: largest horizon at which the post-concession state is in the policy kernel (all = through 24, none = not even 4)"
    yield "CROSSOVER r0 \\ P " + " ".join(f"{P:>4}" for P in PS)
    for r0 in R0S:
        yield f"CROSSOVER r0={r0:<2}   " + " ".join(f"{crossover(r0, P):>4}" for P in PS)
    counts = {"concession only": 0, "both": 0, "clean only": 0, "neither": 0}
    for r0 in R0S:
        for P in PS:
            for T in TS:
                c, f = conc_ok(r0, P, T), clean_ok(r0, P, T)
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
    # four-class severities
    nest = viol = 0
    sev_pre = [0] * 5
    sev_post = [0] * 5
    rows = []
    for r0 in R0S:
        for P in PS:
            digits = ""
            for T in TS:
                kp = [kernel_a(k, pre(r0), T, P) for k in CLASSES]
                kc = [kernel_a_post(k, post_conc(r0), T, P) for k in CLASSES]
                for ks in (kp, kc):
                    for i in range(3):
                        nest += 1
                        viol += ks[i] and not ks[i + 1]
                sev_pre[sev(kp)] += 1
                sev_post[sev(kc)] += 1
                digits += str(sev(kc))
            rows.append((r0, P, digits))
    yield (f"NESTING fixed <= policy <= adapt <= phys at the decision state and the post-concession state, every (r0, P, T): "
           f"{nest} checks, {viol} violations")
    yield "SEVERITY decision state (obligation pending): " + ", ".join(f"sigma {i}: {sev_pre[i]}" for i in range(5)) + f" (of {sum(sev_pre)})"
    yield "SEVERITY post-concession state: " + ", ".join(f"sigma {i}: {sev_post[i]}" for i in range(5)) + f" (of {sum(sev_post)})"
    yield f"SHIFT post-concession severity by horizon T = {TS[0]}..{TS[-1]} (one digit per T):"
    for r0, P, digits in rows:
        yield f"SHIFT r0={r0:<2} P={P}: {digits}"


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


def shield(k, floor, calm):
    """The shield's floor update on a calm tick."""
    calm += 1
    if calm == k:
        return max(0, floor - 1), 0
    return floor, calm


def kernel_b(cls, k, L, s, t):
    """State s = (r, floor, calm) at tick t (round length L + 1; shock when t % (L+1) == L), viable
    through the last shock?"""
    horizon = N_SHOCKS * (L + 1)

    @lru_cache(maxsize=None)
    def win(s, t):
        if t == horizon:
            return True
        r, floor, calm = s
        if t % (L + 1) == L:                     # shock tick
            if r < M_REQ:
                return False
            return win((r - M_REQ, M_MAX, 0), t + 1)
        r2 = r + INCOME
        f2, c2 = shield(k, floor, calm)
        keeps = [min(r2, f2)] if cls == "fixed" else range(r2 + 1)
        return any(win((kp, f2, c2), t + 1) for kp in keeps)
    return win(s, t)


def path_b(k, L):
    """The shield's states (r, floor, calm) at ticks 0, 1, ...; None once down."""
    s, out = (M_MAX, M_MAX, 0), []
    for t in range(N_SHOCKS * (L + 1) + 1):
        out.append(s)
        if t == N_SHOCKS * (L + 1):
            break
        r, floor, calm = s
        if t % (L + 1) == L:
            if r < M_REQ:
                out.append(None)
                break
            s = (r - M_REQ, M_MAX, 0)
        else:
            f2, c2 = shield(k, floor, calm)
            s = (min(r + INCOME, f2), f2, c2)
    return out


def sweep_b():
    yield "Sweep B: calm-period erosion"
    yield (f"  shocks need reserves >= {M_REQ} and remove {M_REQ}; {N_SHOCKS} shocks, each after L calm ticks; a calm tick earns {INCOME}; "
           f"reserves start at {M_MAX}")
    yield (f"  fixed class: the adaptive shield (floor resets to {M_MAX} after a shock, drops by 1 every k calm ticks); policy class: any "
           f"amount kept; myopic (floor 0) and static (floor {M_MAX}) are policy-class rules")
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
    # four-class severities at the start
    nest = viol = 0
    for k in KS:
        digits = ""
        for L in LS:
            ks = [kernel_b(c, k, L, (M_MAX, M_MAX, 0), 0) for c in CLASSES]
            for i in range(3):
                nest += 1
                viol += ks[i] and not ks[i + 1]
            digits += str(sev(ks))
        yield f"SEVERITY k={k} at the start, by L = 1..25: {digits}"
    yield f"NESTING fixed <= policy <= adapt <= phys at the start, every (k, L): {nest} checks, {viol} violations"
    for k, L in ((4, 12), (2, 6)):
        path = path_b(k, L)
        sevs, mus = [], []
        tstar = -1
        for t, s in enumerate(path):
            if s is None:
                sevs.append(4)
                continue
            ks = [kernel_b(c, k, L, s, t) for c in CLASSES]
            sevs.append(sev(ks))
            if ks[2]:
                tstar = t
        for t, s in enumerate(path):
            mus.append(tstar - t if 0 <= t <= tstar else -1)
        groups = ["".join(str(x) for x in sevs[i:i + L + 1]) for i in range(0, len(sevs), L + 1)]
        yield f"MIGRATION k={k} L={L}, the shield's severity by tick (one group per round of L calm ticks and a shock): {'|'.join(groups)}"
        yield f"MIGRATION k={k} L={L}: t*_adapt = {tstar}; margin mu by tick: {' '.join(str(m) for m in mus)}"


def lines():
    yield "Argument V: structural concessions and calm-period erosion, in the four control classes of I.3"
    yield from sweep_a()
    yield from sweep_b()


if __name__ == "__main__":
    for line in lines():
        print(line, flush=True)
