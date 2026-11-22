"""Figures for the preprint (standard library + matplotlib only).

Run from anywhere:   python preprint/figures/make_figures.py

Writes three PDF files next to this script:
  fig_settlement.pdf   the settlement paradox (prescribed pair; two-tick decision rules)
  fig_climate.pdf      climate rate window by start year; closing years by class
  fig_corridor.pdf     viable constant growth rates under linear and convex ramp costs (E-II.6)

Data sources:
  * Settlement trajectories are recomputed with the repository's Python reference
    (python/toy/kernels.py, python/toy/friction.py) and checked against the numbers saved
    in results/report_output.txt and stated in Argument I, Section I.3.10.
  * The climate rate window is read from results/argII_output.txt (RATE lines) and the
    closing years from results/climate_window.csv.
  * The corridor recomputes the viable-rate sets with python/experiments_ii.py and checks
    rmin, rmax and count against results/argII_ramp_output.txt.
The script asserts every check and stops if any saved number is not reproduced.
"""
import csv
import os
import re
import sys

sys.dont_write_bytecode = True          # do not write __pycache__ into the repository

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
RESULTS = os.path.join(ROOT, "results")
sys.path.insert(0, os.path.join(ROOT, "python", "toy"))
sys.path.insert(0, os.path.join(ROOT, "python"))

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

plt.rcParams.update({
    "font.family": "serif",
    "font.size": 9,
    "axes.titlesize": 9,
    "axes.labelsize": 9,
    "legend.fontsize": 8,
    "xtick.labelsize": 8,
    "ytick.labelsize": 8,
    "axes.spines.top": False,
    "axes.spines.right": False,
    "pdf.fonttype": 42,
})

DARK, MID, LIGHT = "0.10", "0.45", "0.72"


def out(name):
    return os.path.join(HERE, name)


# ---------------------------------------------------------------------------
# Figure 1: the settlement paradox
# ---------------------------------------------------------------------------
def fig_settlement():
    import kernels as k
    import friction as fr

    k.configure()                                   # base model of I.3.10
    s0 = (0, 0, 0, 0, 0, 0)

    def prescribed(specialize_first):
        s, traj = s0, [s0]
        while s[0] < k.T:
            s = k.step(*s, k.N, 0, 0, specialize_first and s[0] == 0)
            if s is None:
                break
            traj.append(s)
        return traj

    A, B = prescribed(False), prescribed(True)
    stockA = [s[1] for s in A]
    stockB = [s[1] for s in B]
    sevA = [k.severity(s) for s in A]
    sevB = [k.severity(s) for s in B]
    # Checks against results/report_output.txt
    assert stockA == [0, 3, 6, 9, 12, 15, 18, 18, 18, 15, 12, 9, 6, 3, 0], stockA
    assert stockB == [0, 3, 9, 15, 20, 20, 20, 20, 20, 17, 14, 11, 8, 5, 2], stockB
    assert sevA == [2] * 13 + [3, 4], sevA
    assert sevB == [2] * 11 + [3, 3, 3, 4], sevB

    rules = {r: fr.run(r)[0] for r in ("forage", "train", "shield")}
    fo, tr, sh = rules["forage"], rules["train"], rules["shield"]
    # Checks against Argument I, I.3.10 (and Certified.stock_decisions)
    assert fo[1][4] == 1 and tr[1][4] == 1 and sh[1][4] == 1      # all specialize at tick 0
    assert fo[11][1] == 11 and k.severity(fo[11]) == 3 and fo[-1][0] == 14
    assert tr[11][1] == 17 and tr[-1][0] == 16 and tr[-1][1] == 20
    assert sh[-1][0] == 16 and sh[-1][1] == 8
    assert [s[1] for s in fo] == stockB[:len(fo)]
    lock_fo = next(s[0] for s in fo if k.severity(s) == 3)
    assert lock_fo == 11

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(6.6, 3.4), sharey=True)

    # (a) prescribed pair
    tA = list(range(len(A)))
    tB = list(range(len(B)))
    ax1.plot(tA, stockA, color=MID, ls="--", marker="o", ms=3, lw=1.2,
             label="A: stay generalist")
    ax1.plot(tB, stockB, color=DARK, ls="-", marker="s", ms=3, lw=1.2,
             label="B: specialize at $t=0$")
    for t, sv in enumerate(sevB):
        if sv == 3:
            ax1.plot(t, stockB[t], marker="s", ms=7, mfc="none", mec=DARK, mew=1.0)
    for t, sv in enumerate(sevA):
        if sv == 3:
            ax1.plot(t, stockA[t], marker="o", ms=7, mfc="none", mec=MID, mew=1.0)
    ax1.axvline(10.5, color=DARK, lw=0.7, ls=":")
    ax1.axvline(12.5, color=MID, lw=0.7, ls=":")
    ax1.text(10.4, 21.3, "B locked in", ha="right", va="bottom", fontsize=7)
    ax1.text(12.6, 21.3, "A locked in", ha="left", va="bottom", fontsize=7)
    ax1.set_xlabel("tick $t$")
    ax1.set_ylabel("food stock $F$")
    ax1.set_title("(a) Prescribed pair (incumbent policy)")
    ax1.set_xlim(-0.5, 16.5)
    ax1.set_ylim(-1, 24)
    ax1.set_xticks(range(0, 17, 2))
    ax1.legend(loc="upper center", bbox_to_anchor=(0.5, -0.2), ncol=1, frameon=False)

    # (b) two-tick decision rules
    ax2.plot([s[0] for s in sh], [s[1] for s in sh], color=LIGHT, ls="-", marker="o", ms=6,
             mfc="white", mec=MID, lw=2.6, label="foraging rule + viability shield")
    ax2.plot([s[0] for s in fo], [s[1] for s in fo], color=DARK, ls="-", marker="s", ms=3,
             lw=1.2, label="favor foraging on ties")
    ax2.plot([s[0] for s in tr], [s[1] for s in tr], color=MID, ls="--", marker="^", ms=3,
             lw=1.2, label="favor training on ties")
    ax2.axvline(lock_fo - 0.5, color=DARK, lw=0.7, ls=":")
    ax2.text(lock_fo - 0.6, 21.3, "forage rule locked in", ha="right", va="bottom", fontsize=7)
    ax2.plot(fo[-1][0], fo[-1][1], marker="x", ms=7, color=DARK, mew=1.4)
    ax2.annotate("starves in tick 14", xy=(fo[-1][0], fo[-1][1]), xytext=(9.2, 0.2),
                 fontsize=7, arrowprops=dict(arrowstyle="-", lw=0.6, color=DARK))
    ax2.set_xlabel("tick $t$")
    ax2.set_title("(b) Two-tick stock-maximizing rules")
    ax2.set_xlim(-0.5, 16.5)
    ax2.set_xticks(range(0, 17, 2))
    ax2.legend(loc="upper center", bbox_to_anchor=(0.5, -0.2), ncol=1, frameon=False)

    fig.tight_layout()
    fig.savefig(out("fig_settlement.pdf"))
    plt.close(fig)
    k.configure()


# ---------------------------------------------------------------------------
# Figure 2: climate rate window and closing years
# ---------------------------------------------------------------------------
def fig_climate():
    years, excl, wit = [], [], []
    pat = re.compile(r"RATE year=(\d+) maxExcluded=(\d+)% minWitness=(\d+%|none)")
    with open(os.path.join(RESULTS, "argII_output.txt"), encoding="utf-8") as fh:
        for line in fh:
            m = pat.match(line.strip())
            if m:
                years.append(int(m.group(1)))
                excl.append(int(m.group(2)))
                wit.append(None if m.group(3) == "none" else int(m.group(3)[:-1]))
    assert years[0] == 2027 and excl[0] == 4 and wit[0] == 5
    assert years[-1] == 2043 and wit[-1] is None

    rows = list(csv.DictReader(open(os.path.join(RESULTS, "climate_window.csv"), encoding="utf-8")))

    def pick(tcre):
        sel = []
        for psi in ("0.500000", "0.750000", "1.000000"):
            for phi in ("1.500000", "2.000000", "3.000000"):
                r = [x for x in rows if x["psi"] == psi and x["phi"] == phi and x["gmax"] == "0.300000"
                     and x["L"] == "2" and x["target"] == "2.0C" and x["tcre"] == tcre]
                assert len(r) == 1
                sel.append(r[0])
        return sel

    central, robust = pick("central"), pick("robust")
    head = [x for x in central if x["psi"] == "0.500000" and x["phi"] == "2.000000"][0]
    assert head["tAdapt"] == "2040" and head["tCapacityUnconstrained"] == "2045"
    assert all(x["tAdapt"] == x["tAdaptCertificate"] for x in central + robust)

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(6.6, 3.5), gridspec_kw={"width_ratios": [1, 1.25]})

    # (a) rate bracket vs start year
    ys = [y for y, w in zip(years, wit) if w is not None]
    ws = [w for w in wit if w is not None]
    ax1.fill_between(years, 0, excl, step=None, color="0.85", lw=0,
                     label="excluded for all schedules")
    ax1.plot(years, excl, color=MID, lw=1.0, marker="v", ms=3)
    ax1.plot(ys, ws, color=DARK, lw=1.2, marker="o", ms=3, label="lowest rate with a viable program")
    ax1.axhline(30, color=DARK, lw=0.8, ls="--")
    ax1.text(2027.3, 27.0, "attainable ceiling $g_{\\max}=30\\%$", fontsize=7, va="top")
    ax1.axhline(2, color=MID, lw=0.8, ls=":")
    ax1.text(2031.0, 2.2, "incumbent 2%", fontsize=7, va="bottom", color="0.25")
    ax1.set_yscale("symlog", linthresh=10)
    ax1.set_yticks([0, 2, 5, 10, 30, 100])
    ax1.set_yticklabels(["0", "2", "5", "10", "30", "100"])
    ax1.set_ylim(0, 110)
    ax1.set_xlabel("start year")
    ax1.set_ylabel("annual capacity growth (%/yr)")
    ax1.set_title("(a) Required growth ceiling vs. start year")
    ax1.legend(loc="upper center", bbox_to_anchor=(0.5, -0.2), ncol=1, frameon=False, fontsize=7)

    # (b) closing years by class
    labels = []
    for x in central:
        labels.append("$\\psi$=%s, $\\varphi$=%s" % (float(x["psi"]), float(x["phi"])))

    def yr(v):
        return None if v in ("never", "na", "") else int(v)

    for j, (sel, off, mk, col) in enumerate(((central, -0.18, "o", DARK), (robust, 0.18, "s", MID))):
        for i, x in enumerate(sel):
            y = i + off
            a, u = yr(x["tAdapt"]), yr(x["tCapacityUnconstrained"])
            if a is not None and u is not None:
                ax2.plot([a, u], [y, y], color=col, lw=2.0, solid_capstyle="butt")
            if a is not None:
                ax2.plot(a, y, marker=mk, ms=4, color=col)
            if u is not None:
                ax2.plot(u, y, marker=mk, ms=4, mfc="white", mec=col)
            if a is None and u is None:
                ax2.text(2027.2, y, "never", fontsize=6, va="center", color=col)
    ax2.set_yticks(range(len(labels)))
    ax2.set_yticklabels(labels)
    ax2.invert_yaxis()
    ax2.set_xlim(2026, 2050)
    ax2.set_xlabel("last viable start year")
    ax2.set_title("(b) Closing years, 2°C ($g_{\\max}$=30%, $L$=2)")
    h1, = ax2.plot([], [], marker="o", color=DARK, ls="none", ms=4, label="central: capacity building")
    h2, = ax2.plot([], [], marker="o", mfc="white", mec=DARK, ls="none", ms=4,
                   label="central: capacity-unconstrained")
    h3, = ax2.plot([], [], marker="s", color=MID, ls="none", ms=4, label="robust: capacity building")
    h4, = ax2.plot([], [], marker="s", mfc="white", mec=MID, ls="none", ms=4,
                   label="robust: capacity-unconstrained")
    ax2.legend(handles=[h1, h2, h3, h4], loc="upper center", bbox_to_anchor=(0.4, -0.2), ncol=2,
               frameon=False, fontsize=7)

    fig.tight_layout()
    fig.savefig(out("fig_climate.pdf"))
    plt.close(fig)


# ---------------------------------------------------------------------------
# Figure 3: the bounded corridor (E-II.6)
# ---------------------------------------------------------------------------
def fig_corridor():
    import climate as cl
    import experiments_ii as ex

    saved = {}
    pat = re.compile(r"RAMP ccap=([\d.]+) alpha=([\d.]+) emb=([\d.]+) program=(.+?) "
                     r"rmin=(\S+) rmax=(\S+) count=(\d+) close=(\S+)")
    with open(os.path.join(RESULTS, "argII_ramp_output.txt"), encoding="utf-8") as fh:
        for line in fh:
            m = pat.match(line.strip())
            if m:
                key = (float(m.group(1)), float(m.group(2)), float(m.group(3)), m.group(4))
                saved[key] = (m.group(5), m.group(6), int(m.group(7)), m.group(8))

    ccaps = (0.3, 1.0, 3.0)
    alphas = (1.0, 2.0, 3.0)
    programs = (("stop when not binding", "stop when not binding"), ("never stop", "grow forever"))
    data = {}
    for ccap in ccaps:
        for alpha in alphas:
            p = cl.P(psi=0.5, phi=2.0, budget=1035.0, ccap=ccap, alpha=alpha, emb_i=0.0)
            b = cl.baseline(p)
            for name, _ in programs:
                mk = (lambda r, p=p: cl.grow(p, r)) if name == "stop when not binding" else ex.unthrottled
                w = [round(r * 100) for r in ex.window_rates(p, b[0], mk)]
                rmin, rmax, count, close = saved[(ccap, alpha, 0.0, name)]
                assert rmin == ("%d%%" % min(w)) and rmax == ("%d%%" % max(w)) and count == len(w), \
                    (ccap, alpha, name, rmin, rmax, count, w)
                data[(ccap, alpha, name)] = (w, close)

    def runs(w):
        w = sorted(w)
        out_, start, prev = [], w[0], w[0]
        for v in w[1:]:
            if v != prev + 1:
                out_.append((start, prev))
                start = v
            prev = v
        out_.append((start, prev))
        return out_

    fig, axes = plt.subplots(1, 3, figsize=(6.6, 2.7), sharey=True)
    ylabels = []
    for name, lab in programs:
        for alpha in alphas:
            ylabels.append("%s, %s" % (lab, "linear" if alpha == 1.0 else "$\\alpha$=%d" % alpha))
    for ax, ccap in zip(axes, ccaps):
        y = 0
        for name, lab in programs:
            col = DARK if name == "stop when not binding" else MID
            for alpha in alphas:
                w, close = data[(ccap, alpha, name)]
                for a, b_ in runs(w):
                    ax.plot([a - 0.5, b_ + 0.5], [y, y], color=col, lw=4.0, solid_capstyle="butt")
                ax.text(104, y, close, fontsize=6, va="center", ha="left")
                y += 1
        ax.set_title("$c_{\\mathrm{cap}}$ = %g" % ccap)
        ax.set_xlim(0, 120)
        ax.set_xticks([0, 25, 50, 75, 100])
        ax.axvline(30, color="0.6", lw=0.6, ls=":")
    axes[0].set_yticks(range(len(ylabels)))
    axes[0].set_yticklabels(ylabels)
    axes[0].invert_yaxis()
    fig.supxlabel("viable constant growth rate from 2027 (%/yr); right-hand labels: closing year",
                  fontsize=8)
    fig.tight_layout()
    fig.savefig(out("fig_corridor.pdf"))
    plt.close(fig)


if __name__ == "__main__":
    fig_settlement()
    print("wrote", out("fig_settlement.pdf"))
    fig_climate()
    print("wrote", out("fig_climate.pdf"))
    fig_corridor()
    print("wrote", out("fig_corridor.pdf"))
