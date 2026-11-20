"""Demonstration states, witnesses, exclusions, and the paradox pair."""
import kernels as k

NAMES = {0: "viable as-is", 1: "operational mismatch", 2: "recoverable org. mismatch",
         3: "structural lock-in", 4: "physical nonviability"}

EXAMPLES = {            # all at t = 11
    0: (11, 16, 0, 0, 0, 0),
    1: (11, 9, 0, 1, 0, 0),
    2: (11, 9, 0, 0, 0, 0),
    3: (11, 9, 0, 0, 1, 0),
    4: (11, 2, 0, 0, 0, 0),
}


def verify(cls, path):
    """Independent forward re-simulation of a witness: every step admissible, no starvation."""
    s = path[0][0]
    for st, a in path[:-1]:
        assert st == s
        assert a in set(k.actions(cls, s)), ("inadmissible", cls, s, a)
        s = k.step(*s, *a, phys=(cls == "phys"))
        assert s is not None, "starvation"
    return s[0] == k.T


def fmt_action(a):
    f, m, r, sp = a
    parts = []
    if f: parts.append(f"{f} forage")
    if m: parts.append(f"{m} farm")
    if r: parts.append(f"{r} train")
    if sp: parts.append("specialize")
    return ", ".join(parts) or "idle"


def describe(s):
    t, F, P, farm, spec, prog = s
    return f"t={t}, F={F}, P={P}, farm={'yes' if farm else 'no'}, {'specialists' if spec else 'generalists'}"


if __name__ == "__main__":
    bad, counts = k.check_nesting()
    print(f"States enumerated: {sum(counts)}; nesting violations: {bad}; severity counts: {counts}\n")
    for sig, s in EXAMPLES.items():
        got = k.severity(s)
        assert got == sig, (s, got)
        print(f"sigma={sig} ({NAMES[sig]}): {describe(s)}")
        least = k.CLASSES[sig] if sig < 4 else None
        if least:
            w = k.witness(least, s)
            assert verify(least, w)
            print(f"  witness in K_{least} (verified):")
            for st, a in w[:-1]:
                print(f"    t={st[0]:2d} F={st[1]:2d} P={st[2]}  ->  {fmt_action(a)}")
        excluded = k.CLASSES[:sig]
        if excluded:
            print(f"  excluded by exhaustive enumeration: {', '.join('K_'+c for c in excluded)}")
        print()

    print("Paradox pair: common s0 = (t=0, F=0, P=0, no farm, generalists).")
    print("History B specializes at t=0 (takes effect from t=1); both then run the incumbent.")
    for name, spec_now in [("A generalist", False), ("B specialize at t=0", True)]:
        s, traj, gross, stored_in, discarded = (0, 0, 0, 0, 0, 0), [(0, 0, 0, 0, 0, 0)], 0, 0, 0
        while s[0] < k.T:
            t, F, P, farm, spec, prog = s
            y = k.WILD[t]
            out = k.N * (y + (k.SPEC_BONUS if (spec and y > 0) else 0))
            nxt = k.step(*s, k.N, 0, 0, spec_now and t == 0)
            if nxt is None:
                break
            gross += out
            raw = F + out + P - k.N
            discarded += raw - nxt[1]
            s = nxt
            traj.append(s)
        pnr = {}
        for c in ["policy", "adapt", "phys"]:
            tk = -1
            for st in traj:
                if k.viable(c, st):
                    tk = st[0]
                else:
                    break
            pnr[c] = tk
        tf = traj[-1][0] + 1 if traj[-1][0] < k.T else None
        print(f"  {name}: stock {[x[1] for x in traj]}")
        print(f"    severity {[k.severity(x) for x in traj]}")
        print(f"    gross harvest {gross}, discarded at cap {discarded}, useful {gross - discarded}; "
              f"t*_policy={pnr['policy']}, t*_adapt={pnr['adapt']}, t*_phys={pnr['phys']}, "
              f"t_fail={tf}, Delta_lock={pnr['phys'] - pnr['adapt']}")

    print()
    checked, viol = k.resource_monotone_check()
    print(f"Proposition 4 check (same (O,q), richer (F,P)): {checked} pairs, {viol} violations")
    pairs, same = k.fingerprint_check()
    print(f"Fingerprint check: {pairs} strong-paradox state pairs, {same} sharing (O,q)")
