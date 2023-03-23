"""
Script to plot responses for a single shock at a time
"""

# coding: utf-8
import os
import dreamtools as dt
import numpy as np

t1 = 2030 # Shock year
T = 2080 # Last year to plot
dt.START_YEAR = t1-1
dt.END_YEAR = T

output_folder_base = r"Output"
output_extension = ".png"

"""
List of tuples each containing information about a figure to plot. Each tuple contains:
(
    <A name for the figure>,
    <Labels for each line to plot>,
    <A list of functions to plot for each line>,
    <multiplier type (operator)>,
    <y-axis label (optional)>,
)
"""
plot_info = [
    (),
    #START PÅ SIDE 1 GRAFER
    ("GDP decomposition", {
        "GDP (qBNP)": lambda s, b: (s.qBNP-b.qBNP) / b.qBNP,
        "Private consumption (qC)": lambda s, b: (s.qC["cTot"]-b.qC["cTot"]) / b.qBNP,
        "Government consumption (qG)": lambda s, b: (s.qG["gTot"]-b.qG["gTot"]) / b.qBNP,
        "Investments (qI)": lambda s, b: (s.qI["iTot"]-b.qI["iTot"]) / b.qBNP,
        "Exports (qX)": lambda s, b: (s.qX["xTot"]-b.qX["xTot"]) / b.qBNP,
        "Minus imports (-qM)": lambda s, b: -(s.qM["tot"]-b.qM["tot"]) / b.qBNP,
    }, "pm", "Change relative<br>to baseline GDP (in %-points)"),
    ("GDP deflator decomposition", {
        "GDP deflator (pBNP)": lambda s, b: s.pBNP,
        "Private consumption deflator (pC)": lambda s, b: s.pC["cTot"],
        "Government consumption deflator (pG)": lambda s, b: s.pG["gTot"],
        "Investment deflator (pI)": lambda s, b: s.pI["iTot"],
        "Exports deflator (pX)": lambda s, b: s.pX["xTot"],
        "Imports deflator (pM)": lambda s, b: s.pM["tot"],
    }, "pq", "Change relative<br>to baseline (in %)"),
    ("Employment", {
        "Total employment (nL)": lambda s, b: s.nL["tot"],
        "Effective labor supply (nSoegBaseHh)": lambda s, b: s.nSoegBaseHh["tot"],
        "Net unemployment (nNettoLedig)": lambda s, b: s.nNettoLedig,
        "Net labor force (nNettoArbSty)": lambda s, b: s.nNettoArbsty,
    }, "m", "Change relative<br>to baseline (1,000 persons)"),
    ("Wage", {
        "Marginal product of labor in services (pL)": lambda s, b: s.pL["tje"],
        "Hourly wage (vHw)": lambda s, b: s.vhW,
        "Output price of services (pY)": lambda s, b: s.pY["tje"],
        "Import price of services (pM)": lambda s, b: s.pM["tje"],
        "Consumer prices (pC)": lambda s, b: s.pC["cTot"],
    }, "pq", "Change relative<br>to baseline (in %)"),
    ("Budget surplus", {
        "Primary government budget (vPrimSaldo)": lambda s, b: (s.vPrimSaldo-b.vPrimSaldo)/b.vBNP,
        "Government budget surplus (vSaldo+vtLukning)": lambda s, b: (s.vSaldo+s.vtLukning-b.vSaldo-b.vtLukning)/b.vBNP,
        "Household budget surplus (vHhNFE)": lambda s, b: (s.vHhNFE-b.vHhNFE)/b.vBNP,
        "Firm budget surplus (vVirkNFE)": lambda s, b: (s.vVirkNFE-b.vVirkNFE)/b.vBNP,
        "Foreign budget surplus (vUdlNFE)": lambda s, b: (s.vUdlNFE-b.vUdlNFE)/b.vBNP,
    }, "pm", "Change relative<br>to baseline GDP (in %-points)"),
    #START PÅ SIDE 2 GRAFER
    ("GVA", {
        "Total (qBVT)": lambda s, b: (s.qBVT["tot"]-b.qBVT["tot"])/b.qBVT["tot"],
        "Manufacturing (qBVT)": lambda s, b: (s.qBVT["fre"]-b.qBVT["fre"])/b.qBVT["tot"],
        "Services (qBVT)": lambda s, b: (s.qBVT["tje"]-b.qBVT["tje"])/b.qBVT["tot"],
        "Housing (qBVT)": lambda s, b: (s.qBVT["bol"]-b.qBVT["bol"])/b.qBVT["tot"],
        "Government production (qBVT)": lambda s, b: (s.qBVT["off"]-b.qBVT["off"])/b.qBVT["tot"],
        "Construction (qBVT)": lambda s, b: (s.qBVT["byg"]-b.qBVT["byg"])/b.qBVT["tot"],
        "Other incl. government production": lambda s, b: ((s.qBVT["tot"]-s.qBVT["fre"]-s.qBVT["tje"]-s.qBVT["bol"]-s.qBVT["off"]-s.qBVT["byg"])-(b.qBVT["tot"]-b.qBVT["fre"]-b.qBVT["tje"]-b.qBVT["bol"]-b.qBVT["off"]-b.qBVT["byg"]))/b.qBVT["tot"], 
    }, "pm", "Change relative<br>to baseline GVA (in %-points)"),
    ("Investments", {
        "Business investments in machines (qI_s)": lambda s, b: (s.qI_s["iM","spTot"]-b.qI_s["iM","spTot"])/b.qBNP,
        "Business investments in buildings (qI_s)": lambda s, b: (s.qI_s["iB","spTot"]-b.qI_s["iB","spTot"])/b.qBNP,
        "Housing investment (qI_s)": lambda s, b: (s.qI_s["iB","bol"]-b.qI_s["iB","bol"])/b.qBNP,
        "Government investment (qI_s)": lambda s, b: (s.qI_s["iTot","off"]-b.qI_s["iTot","off"])/b.qBNP,
    }, "pm", "Change relative<br>to baseline GDP (in %-points)"),
    ("Production inputs to services", {
        "Production (qY)": lambda s, b: s.qY["tje"],
        "Intermediates (qR)": lambda s, b: s.qR["tje"],
        "Labor (qL)": lambda s, b: s.qL["tje"],
        "Machinery capital, primo (qK)": lambda s, b: s.qK["iM","tje"][:-1],
        "Building capital, primo (qK)": lambda s, b: s.qK["iB","tje"][:-1],
    }, "pq", "Change relative<br>to baseline (in %)"),
    ("Prices", {
        "Unit costs for services (pKLBR)": lambda s, b: s.pKLBR["tje"],
        "Output price for services (pY)": lambda s, b: s.pY["tje"],
        "Export price for services (pXy)": lambda s, b: s.pXy["xTje"],
        "Output price for manufacturing (pY)": lambda s, b: s.pY["fre"],
        "Unit costs for manufacturing (pKLBR)": lambda s, b: s.pKLBR["fre"],
        "Export price for goods (pXy)": lambda s, b: s.pXy["xVar"],
    }, "pq", "Change relative<br>to baseline (in %)"),
    ("Exports", {
        "Goods (excl. energy) (qXy)": lambda s, b: (s.qXy["xVar"]-b.qXy["xVar"])/b.qBNP,
        "Services (excl. sea transport) (qXy)": lambda s, b: (s.qXy["xTje"]-b.qXy["xTje"])/b.qBNP,
        "Energy (qXy)": lambda s, b: (s.qXy["xEne"]-b.qXy["xEne"])/b.qBNP,
        "Sea transport (qXy)": lambda s, b: (s.qXy["xSoe"]-b.qXy["xSoe"])/b.qBNP, 
        "Turism (qX)": lambda s, b: (s.qX["xTur"]-b.qX["xTur"])/b.qBNP,
        "Import to re-exports (qXm)": lambda s, b: (s.qXm[s.x].groupby(level=1).sum() - b.qXm[b.x].groupby(level=1).sum())/b.qBNP
    }, "pm", "Change relative<br>to baseline GDP (in %-points)"),
    ("Imports", {
        "Total imports (qM)": lambda s, b: (s.qM["tot"]-b.qM["tot"])/b.qBNP,
        "Service imports (qIOm)": lambda s, b: (s.qIOm[s.dux][:, "tje"].groupby(level=1).sum()-b.qIOm[b.dux][:, "tje"].groupby(level=1).sum())/b.qBNP,
        "Good imports excl. re-exports (qIOm)": lambda s, b: (s.qIOm[s.dux][:, "fre"].groupby(level=1).sum()-b.qIOm[b.dux][:, "fre"].groupby(level=1).sum())/b.qBNP,
        "Imports of energy and extraction excl. re-exports (qIOm)": lambda s, 
        b: (s.qIOm[s.dux][:, "ene"].groupby(level=1).sum()+s.qIOm[s.dux][:, "udv"].groupby(level=1).sum()
           -b.qIOm[b.dux][:, "ene"].groupby(level=1).sum()-b.qIOm[b.dux][:, "udv"].groupby(level=1).sum())/b.qBNP,
        "Imports to re-exports (qXm)": lambda s, b: (s.qXm[s.x].groupby(level=1).sum() - b.qXm[b.x].groupby(level=1).sum())/b.qBNP,
    }, "pm", "Change relative<br>to baseline GDP (in %-points)"),
    #START PÅ SIDE 3 GRAFER
    ("Labor force in services", {
        "GVA (qBVT)": lambda s, b: s.qBVT["tje"],
        "Employment to production (qL)": lambda s, b: s.qL["tje"],
        "Employment to production (nL)": lambda s, b: s.nL["tje"]*(1-s.rOpslagOmk["tje"]),
        "Employment (nL)": lambda s, b: s.nL["tje"],
        "Capacity utilization in labor (rLUdn)": lambda s, b: s.rLUdn["tje"], 
    }, "pq", "Change relative<br>to baseline (in %)"),
    ("Wealth and income", {
        "Income after taxes excl. capital income (vHhInd)": lambda s, b: s.vHhInd["tot"],
        "Wealth excl. housing, mortgage and pension (vHhx)": lambda s, b: s.vHhx["tot"],
        "Housing wealth (vBolig)": lambda s, b: s.vBolig["tot"],
        "Mortgage debt (vHh)": lambda s, b: s.vHh["RealKred","tot"],
        "Pension wealth (vHh)": lambda s, b: s.vHh["Pens","tot"],
        "Wealth incl. housing, mortgage and pension": lambda s, b: s.vHhFormue["tot"],
    }, "pq", "Change relative<br>to baseline (in %)"),
    ("Import shares", {
        "Aggregate import share (qM/(qY+qM))": lambda s, b: s.qM["tot"]/(s.qY["tot"]+s.qM["tot"]), 
        "Import share of services (qIOm / (qIOm+qIOy))": lambda s, b: s.qIOm[s.dux][:, "tje"].groupby(level=1).sum()/(s.qIOm[s.dux][:, "tje"].groupby(level=1).sum()+s.qIOy[s.dux][:, "tje"].groupby(level=1).sum()),
        "Import share of manufacturing excl. re-exports (qIOm / (qIOm+qIOy))": lambda s, b: s.qIOm[s.dux][:, "fre"].groupby(level=1).sum()/(s.qIOm[s.dux][:, "fre"].groupby(level=1).sum()+s.qIOy[s.dux][:, "fre"].groupby(level=1).sum()),
        "Import share of energy and extraction (qIOm / (qIOm+qIOy))": lambda s, b: (s.qIOm[s.dux][:, "ene"].groupby(level=1).sum()+s.qIOm[s.dux][:, "udv"].groupby(level=1).sum())/(s.qIOm[s.dux][:, "ene"].groupby(level=1).sum()+s.qIOy[s.dux][:, "ene"].groupby(level=1).sum()+s.qIOm[s.dux][:, "udv"].groupby(level=1).sum()+s.qIOy[s.dux][:, "udv"].groupby(level=1).sum()),
    }, "pq", "Change relative<br>to baseline (in %)"),
]


shock_folder = "Gdx"
baseline_path = f"{shock_folder}/baseline.gdx"

"""
List of shocks to plot. Each tuple contains: 
(
    <Name of the gdx file of the shock>,
    <A label for the shock>,
    <A tuple with infomation about a variable to plot specifically for this shock>,
)
"""
shock_info = [
  # Lump sum
    ("Overforsel_privat", "Household income", 
      ({"Income after taxes excl. capital income (vHhInd)": lambda s, b: (s.vHhInd["tot"] - b.vHhInd["tot"]) / b.vBNP,
        "Wage income before taxes (vWHh)": lambda s, b: (s.vWHh["tot"] - b.vWHh["tot"]) / b.vBNP,
        "Income transfers before taxes (vOvf)": lambda s, b: (s.vOvf["tot"] - b.vOvf["tot"]) / b.vBNP,
        "Minus taxes and other transfers (-vtHhx)": lambda s, b: -(s.vtHhx["tot"] - b.vtHhx["tot"]) / b.vBNP,
        "Net pension income (vHhPensUdb-vHhPensIndb)": lambda s, b: (s.vHhPensUdb["Pens","tot"] - s.vHhPensIndb["Pens","tot"] - (b.vHhPensUdb["Pens","tot"] - b.vHhPensIndb["Pens","tot"])) / b.vBNP,
        "Capital income excl. pension, housing and mortgages (vHhxAfk)": lambda s, b: (s.vHhxAfk["tot"] - b.vHhxAfk["tot"]) / b.vBNP,
       }, "pm", "Change relative<br>to baseline GDP (in %-points)")
    ),
  # Offentlig beskaeftigelse
    ("Offentlig_beskaeftigelse", "Government employment",
      ({"Government employment (hL)": lambda s, b: s.hL["off"],
        # "Government input of intermediates (qR)": lambda s, b: s.qR["off"],
        # "Government investments (qI_s)": lambda s, b: s.qI_s["iTot","off"],
        # "Government capital (qK)": lambda s, b: s.qK["iM","off"] + s.qK["iB","off"],
        "Government production (qY)": lambda s, b: s.qY["off"],
       }, "pq", "Change relative<br>to baseline (in %)")
    ),
  # Offentlig varekøb
    ("Offentlig_varekoeb", "Government purchases", 
      ({
        # "Government employment (hL)": lambda s, b: s.hL["off"],
        "Government input of intermediates (qR)": lambda s, b: s.qR["off"],
        # "Government investments (qI_s)": lambda s, b: s.qI_s["iTot","off"],
        # "Government capital (qK)": lambda s, b: s.qK["iM","off"] + s.qK["iB","off"],
        "Government production (qY)": lambda s, b: s.qY["off"],
       }, "pq", "Change relative<br>to baseline (in %)")
     ),
  # Offentlige investeringer
    ("Offentlige_investeringer", "Government investments", 
      ({
        # "Government employment (hL)": lambda s, b: s.hL["off"],
        # "Government input of intermediates (qR)": lambda s, b: s.qR["off"],
        "Government investments (qI_s)": lambda s, b: s.qI_s["iTot","off"],
        "Government capital (qK)": lambda s, b: s.qK["iM","off"] + s.qK["iB","off"],
        "Government production (qY)": lambda s, b: s.qY["off"],
       }, "pq", "Change relative<br>to baseline (in %)")
     ),
  # Eksportmarkedsvækst
    ("Eksportmarkedsvaekst", "Foreign demand", 
      ({"Export market size (qXMarked)": lambda s, b: s.qXMarked,
        # "Export competing price of manufacturing (pXUdl)": lambda s, b: s.pXUdl["xVar"],
        # "Export competing price of services (pXUdl)": lambda s, b: s.pXUdl["xTje"],
        # "Import price of manufacturing (pM)": lambda s, b: s.pM["fre"],
        # "Import price of services (pM)": lambda s, b: s.pM["tje"],
        "Oil price in DDK (pOlie)": lambda s, b: s.pOlie,
       }, "pq", "Change relative<br>to baseline (in %)")
     ),
  # Arbejdsudbud
    ("Arbejdsudbud", "Labor supply", 
      ({"Searchers plus employed (nSoegBaseHh)": lambda s, b: s.nSoegBaseHh["tot"],
        "Structural household employment (snLHh)": lambda s, b: s.snLHh["tot"],
        "Total household employment (nLHh)": lambda s, b: s.nLHh["tot"],
        # "Hours per worker (rhL2nL)": lambda s, b: s.rhL2nL["tot"],
        "GVA per worker (qBVT/nL)": lambda s, b: s.qBVT["tot"] / s.nL["tot"],
        "Supply effect (qXSkala)": lambda s, b: s.qXSkala,
       }, "pq", "Change relative<br>to baseline (in %)")
     ),
  # ArbejdsProd
    ("ArbejdsProd", "Labor productivity", 
      ({"Searchers plus employed (nSoegBaseHh)": lambda s, b: s.nSoegBaseHh["tot"],
        "Structural household employment (snLHh)": lambda s, b: s.snLHh["tot"],
        "Total household employment (nLHh)": lambda s, b: s.nLHh["tot"],
        # "Hours per worker (rhL2nL)": lambda s, b: s.rhL2nL["tot"],
        "GVA per worker (qBVT/nL)": lambda s, b: s.qBVT["tot"] / s.nL["tot"],
        "Supply effect (qXSkala)": lambda s, b: s.qXSkala,
       }, "pq", "Change relative<br>to baseline (in %)")
     ),
  # KapitalProd
    ("KapitalProd", "Capital productivity", 
      ({"Searchers plus employed (nSoegBaseHh)": lambda s, b: s.nSoegBaseHh["tot"],
        "Structural household employment (snLHh)": lambda s, b: s.snLHh["tot"],
        "Total household employment (nLHh)": lambda s, b: s.nLHh["tot"],
        # "Hours per worker (rhL2nL)": lambda s, b: s.rhL2nL["tot"],
        "GVA per worker (qBVT/nL)": lambda s, b: s.qBVT["tot"] / s.nL["tot"],
        "Supply effect (qXSkala)": lambda s, b: s.qXSkala,
       }, "pq", "Change relative<br>to baseline (in %)")
     ),
  # Importpris
    ("Importpris", "Import prices", 
      ({
        # "Export marked size (qXMarked)": lambda s, b: s.qXMarked,
        # "Export competing price of manufacturing (pXUdl)": lambda s, b: s.pXUdl["xVar"],
        # "Export competing price of services (pXUdl)": lambda s, b: s.pXUdl["xTje"],
        "Import price of manufacturing (pM)": lambda s, b: s.pM["fre"],
        "Import price of services (pM)": lambda s, b: s.pM["tje"],
        "Oil price in DDK (pOlie)": lambda s, b: s.pOlie,
       }, "pq", "Change relative<br>to baseline (in %)")
     ),
  # Oliepris
    ("Oliepris", "Foreign prices", 
      ({
        # "Export marked size (qXMarked)": lambda s, b: s.qXMarked,
        "Oil price in DDK (pOlie)": lambda s, b: s.pOlie,
        "Import price of energy (pM)": lambda s, b: s.pM["ene"],
        "Import price of manufacturing (pM)": lambda s, b: s.pM["fre"],
        "Import price of services (pM)": lambda s, b: s.pM["tje"],
        "Export competing price of manufacturing (pXUdl)": lambda s, b: s.pXUdl["xVar"],
        "Export competing price of services (pXUdl)": lambda s, b: s.pXUdl["xTje"],
       }, "pq", "Change relative<br>to baseline (in %)")
     ),
  # Udenlandske priser
    ("Udenlandske_priser", "Foreign prices", 
      ({
        # "Export marked size (qXMarked)": lambda s, b: s.qXMarked,
        "Oil price in DDK (pOlie)": lambda s, b: s.pOlie,
        "Import price of energy (pM)": lambda s, b: s.pM["ene"],
        "Import price of manufacturing (pM)": lambda s, b: s.pM["fre"],
        "Import price of services (pM)": lambda s, b: s.pM["tje"],
        "Export competing price of manufacturing (pXUdl)": lambda s, b: s.pXUdl["xVar"],
        "Export competing price of services (pXUdl)": lambda s, b: s.pXUdl["xTje"],
       }, "pq", "Change relative<br>to baseline (in %)")
     ),
  # Rente
    ("Rente", "Interest rate", 
      ({
        "ECB key interest rate (rRenteECB)": lambda s, b: s.rRenteECB,
        "Average bond interest rate (rRente)": lambda s, b: s.rRente["Obl"],
        "Marginal household return (mrHhAfk)": lambda s, b: s.mrHhAfk,
        "Usercost of housing (pBoligUC[40])": lambda s, b: s.pBoligUC.loc[40],
        "Usercost of machine capital (pK[IM,sByTot])": lambda s, b: s.pK["iM","sByTot"],
        "Revaluation of of domestic stocks (rOmv)": lambda s, b: s.rOmv["IndlAktier"],
       }, "pm", "Change relative<br>to baseline (%-points)")
     ),
  # Diskontering
    ("Diskontering", "Household discount factor", 
      ({"Household discount factor (fDisk in 1/10 %-points)": lambda s, b: 10*(s.fDisk[40] - b.fDisk[40]),
        "Private consumption (qC)": lambda s, b: (s.qC["cTot"] - b.qC["cTot"]) /  b.qC["cTot"],
        "Housing investments (qI_s)": lambda s, b: (s.qI_s["iB","bol"] - b.qI_s["iB","bol"]) / b.qI_s["iB","bol"],
        "Wealth excl. housing, mortgage and pension (vHhx)": lambda s, b: (s.vHhx["tot"] - b.vHhx["tot"]) / b.vHhx["tot"],
        "Housing wealth (vBolig)": lambda s, b: (s.vBolig["tot"] - b.vBolig["tot"]) / b.vBolig["tot"],
       }, "pm", "Change relative<br>to baseline (in %)")
    ),
  # Loen
    ("Loen", "Wages", 
      ({"Nash negotiation weight (rLoenNash in %-points)": lambda s, b: s.rLoenNash - b.rLoenNash,
        "Hourly wage (vHw)": lambda s, b: (s.vhW - b.vhW) / b.vhW,
        "Income after taxes excl. capital income (vHhInd)": lambda s, b: (s.vHhInd["tot"] - b.vHhInd["tot"]) / b.vHhInd["tot"],
        "Structural household employment (snLHh)": lambda s, b: (s.snLHh["tot"] - b.snLHh["tot"]) / b.snLHh["tot"],
        "Total household employment (nLHh)": lambda s, b: (s.nLHh["tot"] - b.nLHh["tot"]) / b.nLHh["tot"],
       }, "pm", "Change relative<br>to baseline (in %)")
    ),
]
suffix = "_ufin" # Suffix added to shock file names
shock_labels = [s[1] for s in shock_info]

# Default yaxis labels based on operator
yaxis_title_from_operator = {
    "pq": "Pct. change",
    "pm": "Change in pct. points",
    "": "",
}

dt.REFERENCE_DATABASE = dt.Gdx(baseline_path)
for shock_name, shock_label, shock_plot_info in shock_info:
    plot_info[0] = ("shock", *shock_plot_info) # Shock specific plot is inserted as first sub-plot
    shock_path = f"{shock_folder}/{shock_name}{suffix}.gdx"
    try:
      database = dt.Gdx(shock_path)
      output_folder = f"{output_folder_base}/{shock_name}"
      if not os.path.exists(output_folder):
          os.makedirs(output_folder)

      for figure_name, lines_info, operator, yaxis_label in plot_info:
          labels, functions = zip(*lines_info.items())
          if yaxis_label is None:
              yaxis_label = yaxis_title_from_operator[operator]
          df = dt.DataFrame(database, operator, functions=functions, names=labels)
          DPCM = 96 / 2.54
          plot_height = 6
          margin_b = 4
          fig = df.plot(layout=dict(
              title_text=f"<b>{figure_name}</b>",
              yaxis_title_text=yaxis_label,
              width = 12 * DPCM,
              height = (plot_height + margin_b) * DPCM,
              margin_l = 1.5 * DPCM,
              margin_r = 0.5 * DPCM,
              margin_t = 1 * DPCM,
              margin_b = margin_b * DPCM,
              legend_y = -0.25,
              xaxis_title_text = "Year",
          ))
          output_path = f"{output_folder}/{figure_name}{output_extension}"
          dt.write_image(fig, output_path)
    except:
      print(shock_path)