import pandas as pd
import numpy as np
import dreamtools as dt
from dreamtools import plot, prt  # plotly and kaleido packages are required to use dreamtools to export plots (pip install plotly, kaleido)   
import os
from IPython.display import display

dt.AGE_AXIS_TITLE = "Age"
gdx_folder = r"gdx"
output_folder = r"Shocks\MPC\Graphics"
output_extension = ".svg"
shock_year = 2026

r = dt.REFERENCE_DATABASE = dt.Gdx("../../model/Gdx/stiliseret_grundforloeb.gdx")

# We add all figures to this dict - we can later display or export them
figures = {}

# Baseline figurer
n = nominal = dt.Gdx("../../model/Gdx/stiliseret_grundforloeb_nominal.gdx")

dt.time(2025)
figures["baseline_wealth_2025"] = dt.large_figure(dt.age_figure_2d(
    [
        nominal.vHhFormueR,
        nominal.vHhFormueR - nominal.vHhPensR,
        (n.qFormueBase - n.cFormue / n.growth_factor) * n.EpC,
        (n.qArvBase - n.cArv / n.growth_factor) * n.EpC,
    ],
    names = ["Net wealth", "Net wealth excl. pensions", r"X<sub>t</sub> (wealth in utility)", r"X<sub>t</sub><sup>beq</sup> (bequeathable wealth)"],
    start_age = 18, yaxis_title="DKK mil."
))

figures["baseline_consumption_2025"] = dt.small_figure(dt.age_figure_2d(
    [nominal.vHhInd + nominal.vHhxAfk, nominal.vC_a],
    names = ["Income (excluding housing)", "Non-housing consumption"],
    start_age = 18, yaxis_title="DKK mil."
))

figures["baseline_housing_2025"] = dt.small_figure(dt.age_figure_2d(
    [nominal.vBolig[r.a], nominal.vHh["RealKred"][r.a]],
    names = ["Housing assets", "Mortgage debt (realkredit)"],
    start_age = 18, yaxis_title="DKK mil."
))

# MPC hovedresultater
dt.time(shock_year)
mpc = dt.Gdx(f"{gdx_folder}/mpc_eksogen_bolig.gdx")
mpc_permanent = dt.Gdx(f"{gdx_folder}/mpc_permanent_eksogen_bolig.gdx")

figures["MPC"] = dt.large_figure(dt.age_figure_2d(
    [
        (mpc.vC_a[r.a] - r.vC_a[r.a]) / (mpc.vHhInd[r.a] - r.vHhInd[r.a]),
        (mpc_permanent.vC_a[r.a] - r.vC_a[r.a]) / (mpc_permanent.vHhInd[r.a] - r.vHhInd[r.a]),
    ],
    names=["Temporary shock", "Permanent shock"],
    start_age=18,
    yaxis_title="MPC",
))

figures["MPC_H2MvsR"] = dt.small_figure(dt.age_figure_2d(
    [
        r.pC["cIkkeBol"] * (mpc.qCHtM[r.a] - r.qCHtM[r.a]) / (mpc.vHhInd[r.a] - r.vHhInd[r.a]),
        r.pC["cIkkeBol"] * (mpc.qCR[r.a] - r.qCR[r.a]) / (mpc.vHhInd[r.a] - r.vHhInd[r.a]),
        (mpc.vC_a[r.a] - r.vC_a[r.a]) / (mpc.vHhInd[r.a] - r.vHhInd[r.a]),
    ],
    names=["Hand-to-mouth households", "Forward-looking households", "Weighted average"],
    start_age=18,
    yaxis_title="MPC",
))

figures["MPC_H2MvsR_permanent"] = dt.small_figure(dt.age_figure_2d(
    [
        r.pC["cIkkeBol"] * (mpc_permanent.qCHtM[r.a] - r.qCHtM[r.a]) / (mpc_permanent.vHhInd[r.a] - r.vHhInd[r.a]),
        r.pC["cIkkeBol"] * (mpc_permanent.qCR[r.a] - r.qCR[r.a]) / (mpc_permanent.vHhInd[r.a] - r.vHhInd[r.a]),
        (mpc_permanent.vC_a[r.a] - r.vC_a[r.a]) / (mpc_permanent.vHhInd[r.a] - r.vHhInd[r.a]),
    ],
        names=["Hand-to-mouth households", "Forward-looking households", "Weighted average"],
    start_age=18,
    yaxis_title="MPC",
))

def permanent_income(r):
    permanent_income = r.vHhInd[r.a]
    permanent_income.name = "NPV of income"
    pd.Series({a: 0 for a in range(100)}, name="NPV of income")
    discount_factor = pd.Series(1, index=r.t)
    for t in range(shock_year+1, 2100):
        discount_factor.loc[t] = discount_factor[t-1] / (1+r.mrHhxAfk[40][t])
    for a in range(100):
        for t in range (shock_year, 2100):
            age = a + t - shock_year
            if age <= 100:               
                permanent_income.loc[a,shock_year] += discount_factor.loc[t] * r.vHhInd.loc[age][t]
    return permanent_income


print("Aggregate MPCs for income shocks in partial model")
display(pd.DataFrame({
    "Temporary, weighed by income":
        ((mpc.vC_a[r.a] - r.vC_a[r.a]) * r.nPop[r.a])[:,shock_year].sum() / ((mpc.vHhInd["tot"] - r.vHhInd["tot"]))[shock_year],
    "Permanent, weighed by income":
        ((mpc_permanent.vC_a[r.a] - r.vC_a[r.a]) * r.nPop[r.a])[:,shock_year].sum() / ((mpc_permanent.vHhInd["tot"] - r.vHhInd["tot"]))[shock_year],
    "Temporary, equal weight pr. household":
        ((mpc.vC_a[r.a] - r.vC_a[r.a]) / (mpc.vHhInd[r.a] - r.vHhInd[r.a]) * r.nPop[r.a])[:,shock_year].sum() / r.nPop["a18t100",shock_year],
    "Permanent, equal weight pr. household":
        ((mpc_permanent.vC_a[r.a] - r.vC_a[r.a]) / (mpc_permanent.vHhInd[r.a] - r.vHhInd[r.a]) * r.nPop[r.a])[:,shock_year].sum() / r.nPop["a18t100",shock_year],
}, index=["Aggregate first-year MPCs for proportional income shocks in partial model"]).round(2))

# # Fuld model
# full = dt.Gdx(f"{gdx_folder}/mpc_full.gdx") 
# figures["MPC_H2MvsR_full"] = dt.small_figure(dt.age_figure_2d(
#     [
#         r.pC["cTot"] * (full.qCHtM_NR[r.a] - r.qCHtM_NR[r.a]) / (full.jvHhNFErest[r.a] - r.jvHhNFErest[r.a]),
#         r.pC["cTot"] * (full.qCR_NR[r.a] - r.qCR_NR[r.a]) / (full.jvHhNFErest[r.a] - r.jvHhNFErest[r.a]),
#         r.pC["cTot"] * (full.qC_NR[r.a] - r.qC_NR[r.a]) / (full.jvHhNFErest[r.a] - r.jvHhNFErest[r.a]),
#     ],
#     names=["Hand-to-mouth households", "Forward-looking households", "Weighted average"],
#     start_age=18,
#     yaxis_title="MPC",
# ))

# full_permanent = dt.Gdx(f"{gdx_folder}/mpc_full_permanent.gdx")
# figures["MPC_H2MvsR_permanent_full"] = dt.small_figure(dt.age_figure_2d(
#     [
#         r.pC["cTot"] * (full_permanent.qCHtM_NR[r.a] - r.qCHtM_NR[r.a]) / (full_permanent.jvHhNFErest[r.a] - r.jvHhNFErest[r.a]),
#         r.pC["cTot"] * (full_permanent.qCR_NR[r.a] - r.qCR_NR[r.a]) / (full_permanent.jvHhNFErest[r.a] - r.jvHhNFErest[r.a]),
#         r.pC["cTot"] * (full_permanent.qC_NR[r.a] - r.qC_NR[r.a]) / (full_permanent.jvHhNFErest[r.a] - r.jvHhNFErest[r.a]),
#     ],
#     names=["Hand-to-mouth households", "Forward-looking households", "Weighted average"],
#     start_age=18,
#     yaxis_title="MPC",
# ))

# [
#    (r.pC["cTot"] * (full.qCHtM_NR["tot"] - r.qCHtM_NR["tot"]) / (full.jvHhNFErest["tot"] - r.jvHhNFErest["tot"]))[shock_year],
#    (r.pC["cTot"] * (full.qCR_NR["tot"] - r.qCR_NR["tot"]) / (full.jvHhNFErest["tot"] - r.jvHhNFErest["tot"]))[shock_year],
#    (r.pC["cTot"] * (full.qC_NR["tot"] - r.qC_NR["tot"]) / (full.jvHhNFErest["tot"] - r.jvHhNFErest["tot"]))[shock_year],
#    (r.pC["cTot"] * (full_permanent.qCHtM_NR["tot"] - r.qCHtM_NR["tot"]) / (full_permanent.jvHhNFErest["tot"] - r.jvHhNFErest["tot"]))[shock_year],
#    (r.pC["cTot"] * (full_permanent.qCR_NR["tot"] - r.qCR_NR["tot"]) / (full_permanent.jvHhNFErest["tot"] - r.jvHhNFErest["tot"]))[shock_year],
#    (r.pC["cTot"] * (full_permanent.qC_NR["tot"] - r.qC_NR["tot"]) / (full_permanent.jvHhNFErest["tot"] - r.jvHhNFErest["tot"]))[shock_year],
# ]

# # Endogent eller eksogent reference forbrug?
# mpc_ref_ekso = dt.Gdx(f"{gdx_folder}/mpc_ref_ekso.gdx")
# mpc_permanent_ref_ekso = dt.Gdx(f"{gdx_folder}/mpc_permanent_ref_ekso.gdx")
# dt.large_figure(dt.age_figure_2d(
#     [mpc.vC_a, mpc_ref_ekso.vC_a, mpc_permanent.vC_a, mpc_permanent_ref_ekso.vC_a],
#     "m", yaxis_title="ΔvC_a/ΔvHhInd", function=lambda x: x/0.001, start_age=18,
#     names=["Endogent referenceforbrug, midlertidig stød", "Eksogent referenceforbrug, midlertidig stød", "Endogent referenceforbrug, permanent stød", "Eksogent referenceforbrug, permanent stød"],
# ))

# # Endogent eller eksogent reference forbrug?
# mpc = dt.Gdx(f"{gdx_folder}/mpc.gdx")
# mpc_permanent = dt.Gdx(f"{gdx_folder}/mpc_permanent.gdx")
# mpc_eksogen_bolig = dt.Gdx(f"{gdx_folder}/mpc_eksogen_bolig.gdx")
# mpc_permanent_eksogen_bolig = dt.Gdx(f"{gdx_folder}/mpc_permanent_eksogen_bolig.gdx")
# dt.large_figure(dt.age_figure_2d(
#     [mpc.vC_a, mpc_eksogen_bolig.vC_a, mpc_permanent.vC_a, mpc_permanent_eksogen_bolig.vC_a],
#     "m", yaxis_title="ΔvC_a/ΔvHhInd", function=lambda x: x/0.001, start_age=18,
#     names=["Endogen bolig, midlertidig stød", "Eksogen bolig, midlertidig stød", "Endogen bolig, permanent stød", "Eksogen bolig, permanent stød"],
# ))

for fname, fig in figures.items():
    if output_folder:
        fig.write_image(os.path.join(output_folder, f"{fname}{output_extension}"), scale=4)  # The file extension can be changed to change the image format
    else:
        fig.show()
