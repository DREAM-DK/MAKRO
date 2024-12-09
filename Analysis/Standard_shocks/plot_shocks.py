"""
Script to plot responses for a single shock at a time
"""

# coding: utf-8
import os
import dreamtools as dt
import numpy as np

t1 = 2026 # Shock year
T = 2080 # Last year to plot
dt.START_YEAR = t1-1
dt.END_YEAR = T

output_folder_base = r"Output"
output_extension = ".png"

shock_folder = "Gdx"
baseline_path = f"{shock_folder}/deep_calibration.gdx"

DA = True # Should labels be in Danish or English? 

"""
List of tuples each containing information about a figure to plot. Each tuple contains:
(
    <Danish name for the figure>,
    <English name for the figure>,
    <A dictionary with English information about the lines to plot for the baseline>,
    <A dictionary with Danish information about the lines to plot for the baseline>,
    <multiplier type (operator)>,
    <English y-axis label (optional)>,
    <Danish y-axis label (optional)>,
)
"""
plot_info = [
   (),
   #START PÅ SIDE 1 GRAFER
   (
   "GDP decomposition",
   "BNP-opdeling",
   {
   "GDP (qBNP)": lambda s, b: (s.qBNP - b.qBNP) / b.qBNP,
   "Private consumption (qC)": lambda s, b: (s.qC["cTot"] - b.qC["cTot"]) / b.qBNP,
   "Government consumption (qG)": lambda s, b: (s.qG["gTot"] - b.qG["gTot"]) / b.qBNP,
   "Investments (qI)": lambda s, b: (s.qI["iTot"] - b.qI["iTot"]) / b.qBNP,
   "Exports (qX)": lambda s, b: (s.qX["xTot"] - b.qX["xTot"]) / b.qBNP,
   "Minus imports (-qM)": lambda s, b: -(s.qM["tot"] - b.qM["tot"]) / b.qBNP,
   },
   {
   "BNP (qBNP)": lambda s, b: (s.qBNP - b.qBNP) / b.qBNP,
   "Privatforbrug (qC)": lambda s, b: (s.qC["cTot"] - b.qC["cTot"]) / b.qBNP,
   "Offentligt forbrug (qG)": lambda s, b: (s.qG["gTot"] - b.qG["gTot"]) / b.qBNP,
   "Investeringer (qI)": lambda s, b: (s.qI["iTot"] - b.qI["iTot"]) / b.qBNP,
   "Eksport (qX)": lambda s, b: (s.qX["xTot"] - b.qX["xTot"]) / b.qBNP,
   "Minus import (-qM)": lambda s, b: -(s.qM["tot"] - b.qM["tot"]) / b.qBNP,
   },
   "pm",
   "Change relative<br>to baseline GDP (in %-points)",
   "Ændring i forhold<br>til baseline BNP (i procentpoint)"
   ),

   ("GDP deflator decomposition",
   "BNP-deflator opdeling", 
   {
   "GDP deflator (pBNP)": lambda s, b: s.pBNP,
   "Private consumption deflator (pC)": lambda s, b: s.pC["cTot"],
   "Government consumption deflator (pG)": lambda s, b: s.pG["gTot"],
   "Investment deflator (pI)": lambda s, b: s.pI["iTot"],
   "Exports deflator (pX)": lambda s, b: s.pX["xTot"],
   "Imports deflator (pM)": lambda s, b: s.pM["tot"],
   }, 
   {
   "BNP-deflator (pBNP)": lambda s, b: s.pBNP,
   "Privatforbrugsdeflator (pC)": lambda s, b: s.pC["cTot"],
   "Offentlig forbrugsdeflator (pG)": lambda s, b: s.pG["gTot"],
   "Investeringsdeflator (pI)": lambda s, b: s.pI["iTot"],
   "Eksportdeflator (pX)": lambda s, b: s.pX["xTot"],
   "Importdeflator (pM)": lambda s, b: s.pM["tot"],
   },
   "pq",
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)"),
   ("Employment",
   "Beskæftigelse", 
   {
   "Total employment (nL)": lambda s, b: s.nL["tot"],
   "Effective labor supply (nSoegBaseHh)": lambda s, b: s.nSoegBaseHh["tot"],
   "Net unemployment (nNettoLedig)": lambda s, b: s.nNettoLedig,
   "Net labor force (nNettoArbsty)": lambda s, b: s.nNettoArbsty,
   }, 
   {
   "Total beskæftigelse (nL)": lambda s, b: s.nL["tot"],
   "Effektiv arbejdsstyrke (nSoegBaseHh)": lambda s, b: s.nSoegBaseHh["tot"],
   "Nettoledighed (nNettoLedig)": lambda s, b: s.nNettoLedig,
   "Nettoarbejdsstyrke (nNettoArbsty)": lambda s, b: s.nNettoArbsty,
   },
   "m",
   "Change relative<br>to baseline (1,000 persons)",
   "Ændring i forhold<br>til baseline (1.000 personer)"),
   ("Wage",
   "Løn",
   {
   "Marginal product of labor in services (pL)": lambda s, b: s.pL["tje"],
   "Hourly wage (vHw)": lambda s, b: s.vhW,
   "Output price of services (pY)": lambda s, b: s.pY["tje"],
   "Import price of services (pM)": lambda s, b: s.pM["tje"],
   "Consumer prices (pC)": lambda s, b: s.pC["cTot"],
   },
   {
   "Marginale produkt af arbejdskraft i servicesektoren (pL)": lambda s, b: s.pL["tje"],
   "Timeløn (vHw)": lambda s, b: s.vhW,
   "Outputpris for services (pY)": lambda s, b: s.pY["tje"],
   "Importpris for services (pM)": lambda s, b: s.pM["tje"],
   "Forbrugerpriser (pC)": lambda s, b: s.pC["cTot"],
   },
   "pq",
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)"),
   ("Budget surplus", 
   "Budgetsaldo",
   {
   "Primary government budget (vPrimSaldo)": lambda s, b: (s.vPrimSaldo-b.vPrimSaldo)/b.vBNP,
   "Government budget surplus (vSaldo+vtLukning)": lambda s, b: (s.vSaldo+s.vtLukning-b.vSaldo-b.vtLukning)/b.vBNP,
   "Household budget surplus (vHhNFE)": lambda s, b: (s.vHhNFE-b.vHhNFE)/b.vBNP,
   "Firm budget surplus (vVirkNFE)": lambda s, b: (s.vVirkNFE-b.vVirkNFE)/b.vBNP,
   "Foreign budget surplus (vUdlNFE)": lambda s, b: (s.vUdlNFE-b.vUdlNFE)/b.vBNP,
   }, 
   {
   "Primær offentlig saldo (vPrimSaldo)": lambda s, b: (s.vPrimSaldo-b.vPrimSaldo)/b.vBNP,
   "Offentlig saldo (vSaldo+vtLukning)": lambda s, b: (s.vSaldo+s.vtLukning-b.vSaldo-b.vtLukning)/b.vBNP,
   "Husholdningers saldo (vHhNFE)": lambda s, b: (s.vHhNFE-b.vHhNFE)/b.vBNP,
   "Virksomheders saldo (vVirkNFE)": lambda s, b: (s.vVirkNFE-b.vVirkNFE)/b.vBNP,
   "Udenlands saldo (vUdlNFE)": lambda s, b: (s.vUdlNFE-b.vUdlNFE)/b.vBNP,
   },
   "pm", 
   "Change relative<br>to baseline GDP (in %-points)",
   "Ændring i forhold<br>til baseline BNP (i procentpoint)"),
   # #START PÅ SIDE 2 GRAFER
   ("GVA", 
   "BVT",
   {
   "Total (qBVT)": lambda s, b: (s.qBVT["tot"]-b.qBVT["tot"])/b.qBVT["tot"],
   "Manufacturing (qBVT)": lambda s, b: (s.qBVT["fre"]-b.qBVT["fre"])/b.qBVT["tot"],
   "Services (qBVT)": lambda s, b: (s.qBVT["tje"]-b.qBVT["tje"])/b.qBVT["tot"],
   "Housing (qBVT)": lambda s, b: (s.qBVT["bol"]-b.qBVT["bol"])/b.qBVT["tot"],
   "Government production (qBVT)": lambda s, b: (s.qBVT["off"]-b.qBVT["off"])/b.qBVT["tot"],
   "Construction (qBVT)": lambda s, b: (s.qBVT["byg"]-b.qBVT["byg"])/b.qBVT["tot"],
   "Other incl. government production": lambda s, b: ((s.qBVT["tot"]-s.qBVT["fre"]-s.qBVT["tje"]-s.qBVT["bol"]-s.qBVT["off"]-s.qBVT["byg"])-(b.qBVT["tot"]-b.qBVT["fre"]-b.qBVT["tje"]-b.qBVT["bol"]-b.qBVT["off"]-b.qBVT["byg"]))/b.qBVT["tot"], 
   }, {
   "Total (qBVT)": lambda s, b: (s.qBVT["tot"]-b.qBVT["tot"])/b.qBVT["tot"],
   "Fremstilling (qBVT)": lambda s, b: (s.qBVT["fre"]-b.qBVT["fre"])/b.qBVT["tot"],
   "Tjenster (qBVT)": lambda s, b: (s.qBVT["tje"]-b.qBVT["tje"])/b.qBVT["tot"],
   "Boliger (qBVT)": lambda s, b: (s.qBVT["bol"]-b.qBVT["bol"])/b.qBVT["tot"],
   "Offentlig produktion (qBVT)": lambda s, b: (s.qBVT["off"]-b.qBVT["off"])/b.qBVT["tot"],
   "Byggeri (qBVT)": lambda s, b: (s.qBVT["byg"]-b.qBVT["byg"])/b.qBVT["tot"],
   "Andrer inkl. offentlig produktion": lambda s, b: ((s.qBVT["tot"]-s.qBVT["fre"]-s.qBVT["tje"]-s.qBVT["bol"]-s.qBVT["off"]-s.qBVT["byg"])-(b.qBVT["tot"]-b.qBVT["fre"]-b.qBVT["tje"]-b.qBVT["bol"]-b.qBVT["off"]-b.qBVT["byg"]))/b.qBVT["tot"],
   },
   "pm", 
   "Change relative<br>to baseline GVA (in %-points)",
   "Ændring i forhold<br>til baseline BVT (i procentpoint)"),
   ("Investments",
   "Investeringer", 
   {
   "Business investments in machines (qI_s)": lambda s, b: (s.qI_s["iM","spTot"]-b.qI_s["iM","spTot"])/b.qBNP,
   "Business investments in buildings (qI_s)": lambda s, b: (s.qI_s["iB","spTot"]-b.qI_s["iB","spTot"])/b.qBNP,
   "Housing investment (qI_s)": lambda s, b: (s.qI_s["iB","bol"]-b.qI_s["iB","bol"])/b.qBNP,
   "Government investment (qI_s)": lambda s, b: (s.qI_s["iTot","off"]-b.qI_s["iTot","off"])/b.qBNP,
   }, {
   "Virksomhedsinvesteringer i maskiner (qI_s)": lambda s, b: (s.qI_s["iM","spTot"]-b.qI_s["iM","spTot"])/b.qBNP,
   "Virksomhedsinvesteringer i bygninger (qI_s)": lambda s, b: (s.qI_s["iB","spTot"]-b.qI_s["iB","spTot"])/b.qBNP,
   "Boliginvesteringer (qI_s)": lambda s, b: (s.qI_s["iB","bol"]-b.qI_s["iB","bol"])/b.qBNP,
   "Offentlige investeringer (qI_s)": lambda s, b: (s.qI_s["iTot","off"]-b.qI_s["iTot","off"])/b.qBNP,
   },
   "pm", 
   "Change relative<br>to baseline GDP (in %-points)",
   "Ændring i forhold<br>til baseline BNP (i procentpoint)"),
   ("Production inputs to services", 
   "Produktionsinput til services",
   {
   "Production (qY)": lambda s, b: s.qY["tje"],
   "Intermediates (qR)": lambda s, b: s.qR["tje"],
   "Labor (qL)": lambda s, b: s.qL["tje"],
   "Machinery capital, primo (qK)": lambda s, b: s.qK["iM","tje"][:-1],
   "Building capital, primo (qK)": lambda s, b: s.qK["iB","tje"][:-1],
   }, {
   "Produktion (qY)": lambda s, b: s.qY["tje"],
   "Materialeinput (qR)": lambda s, b: s.qR["tje"],
   "Arbejdskraft (qL)": lambda s, b: s.qL["tje"],
   "Maskinkapital, primo (qK)": lambda s, b: s.qK["iM","tje"][:-1],
   "Bygningskapital, primo (qK)": lambda s, b: s.qK["iB","tje"][:-1],
   },
   "pq", 
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)"),
   ("Prices", 
   "Priser",
   {
   "Unit costs for services (pKELBR)": lambda s, b: s.pKELBR["tje"],
   "Output price for services (pY)": lambda s, b: s.pY["tje"],
   "Export price for services (pXy)": lambda s, b: s.pXy["xTje"],
   "Output price for manufacturing (pY)": lambda s, b: s.pY["fre"],
   "Unit costs for manufacturing (pKELBR)": lambda s, b: s.pKELBR["fre"],
   "Export price for goods (pXy)": lambda s, b: s.pXy["xVar"],
   }, {
   "Enhedsomkostninger for services (pKELBR)": lambda s, b: s.pKELBR["tje"],
   "Outputpris for services (pY)": lambda s, b: s.pY["tje"],
   "Eksportpris for services (pXy)": lambda s, b: s.pXy["xTje"],
   "Outputpris for fremstilling (pY)": lambda s, b: s.pY["fre"],
   "Enhedsomkostninger for fremstilling (pKELBR)": lambda s, b: s.pKELBR["fre"],
   "Eksportpris for varer (pXy)": lambda s, b: s.pXy["xVar"],
   },
   "pq", 
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)"),
   ("Exports", 
   "Eksport",
   {
   "Goods (excl. energy) (qXy)": lambda s, b: (s.qXy["xVar"]-b.qXy["xVar"])/b.qBNP,
   "Services (excl. sea transport) (qXy)": lambda s, b: (s.qXy["xTje"]-b.qXy["xTje"])/b.qBNP,
   "Energy (qXy)": lambda s, b: (s.qXy["xEne"]-b.qXy["xEne"])/b.qBNP,
   "Sea transport (qXy)": lambda s, b: (s.qXy["xSoe"]-b.qXy["xSoe"])/b.qBNP, 
   "Turism (qX)": lambda s, b: (s.qX["xTur"]-b.qX["xTur"])/b.qBNP,
   "Import to re-exports (qXm)": lambda s, b: (s.qXm[s.x].groupby(level=1).sum() - b.qXm[b.x].groupby(level=1).sum())/b.qBNP
   }, {
   "Varer (ekskl. energi) (qXy)": lambda s, b: (s.qXy["xVar"]-b.qXy["xVar"])/b.qBNP,
   "Services (ekskl. søtransport) (qXy)": lambda s, b: (s.qXy["xTje"]-b.qXy["xTje"])/b.qBNP,
   "Energi (qXy)": lambda s, b: (s.qXy["xEne"]-b.qXy["xEne"])/b.qBNP,
   "Søtransport (qXy)": lambda s, b: (s.qXy["xSoe"]-b.qXy["xSoe"])/b.qBNP,
   "Turisme (qX)": lambda s, b: (s.qX["xTur"]-b.qX["xTur"])/b.qBNP,
   "Import til reeksport (qXm)": lambda s, b: (s.qXm[s.x].groupby(level=1).sum() - b.qXm[b.x].groupby(level=1).sum())/b.qBNP
   },
   "pm", 
   "Change relative<br>to baseline GDP (in %-points)",
   "Ændring i forhold<br>til baseline BNP (i procentpoint)"),
   ("Imports", 
   "Import",
   {
   "Total imports (qM)": lambda s, b: (s.qM["tot"]-b.qM["tot"])/b.qBNP,
   "Service imports (qIOm)": lambda s, b: (s.qIOm[s.dux][:, "tje"].groupby(level=1).sum()-b.qIOm[b.dux][:, "tje"].groupby(level=1).sum())/b.qBNP,
   "Good imports excl. re-exports (qIOm)": lambda s, b: (s.qIOm[s.dux][:, "fre"].groupby(level=1).sum()-b.qIOm[b.dux][:, "fre"].groupby(level=1).sum())/b.qBNP,
   "Imports of energy and extraction excl. re-exports (qIOm)": lambda s, 
   b: (s.qIOm[s.dux][:, "ene"].groupby(level=1).sum()+s.qIOm[s.dux][:, "udv"].groupby(level=1).sum()
   -b.qIOm[b.dux][:, "ene"].groupby(level=1).sum()-b.qIOm[b.dux][:, "udv"].groupby(level=1).sum())/b.qBNP,
   "Imports to re-exports (qXm)": lambda s, b: (s.qXm[s.x].groupby(level=1).sum() - b.qXm[b.x].groupby(level=1).sum())/b.qBNP,
   }, {
   "Total import (qM)": lambda s, b: (s.qM["tot"]-b.qM["tot"])/b.qBNP,
   "Serviceimport (qIOm)": lambda s, b: (s.qIOm[s.dux][:, "tje"].groupby(level=1).sum()-b.qIOm[b.dux][:, "tje"].groupby(level=1).sum())/b.qBNP,
   "Vareimport ekskl. reeksport (qIOm)": lambda s, b: (s.qIOm[s.dux][:, "fre"].groupby(level=1).sum()-b.qIOm[b.dux][:, "fre"].groupby(level=1).sum())/b.qBNP,
   "Import af energi og udvinding ekskl. reeksport (qIOm)": lambda s,
   b: (s.qIOm[s.dux][:, "ene"].groupby(level=1).sum()+s.qIOm[s.dux][:, "udv"].groupby(level=1).sum()
   -b.qIOm[b.dux][:, "ene"].groupby(level=1).sum()-b.qIOm[b.dux][:, "udv"].groupby(level=1).sum())/b.qBNP,
   "Import til reeksport (qXm)": lambda s, b: (s.qXm[s.x].groupby(level=1).sum() - b.qXm[b.x].groupby(level=1).sum())/b.qBNP,
   },
   "pm", 
   "Change relative<br>to baseline GDP (in %-points)",
   "Ændring i forhold<br>til baseline BNP (i procentpoint)"),
   #START PÅ SIDE 3 GRAFER
   ("Labor force in services", 
   "Arbejdsstyrke i services",
   {
   "GVA (qBVT)": lambda s, b: s.qBVT["tje"],
   "Effective employment (qL)": lambda s, b: s.qL["tje"],
   "Employment to production (hL)": lambda s, b: s.nL["tje"]*(1-s.rOpslagOmk["tje"]),
   "Employment (hL)": lambda s, b: s.nL["tje"],
   "Capacity utilization in labor (rLUdn)": lambda s, b: s.rLUdn["tje"], 
   }, {
   "BVT (qBVT)": lambda s, b: s.qBVT["tje"],
   "Effektiv beskæftigelse (qL)": lambda s, b: s.qL["tje"],
   "Beskæftigelse til produktion (hL)": lambda s, b: s.nL["tje"]*(1-s.rOpslagOmk["tje"]),
   "Beskæftigelse (hL)": lambda s, b: s.nL["tje"],
   "Kapacitetsudnyttelse i arbejdskraft (rLUdn)": lambda s, b: s.rLUdn["tje"],
   },
   "pq", 
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)"),
   ("Wealth and income", 
   "Formue og indkomst",
   {
   "Income after taxes excl. capital income (vHhInd)": lambda s, b: s.vHhInd["tot"],
   "Wealth excl. housing, mortgage and pension (vHhx)": lambda s, b: s.vHhx["tot"],
   "Housing wealth (vBolig)": lambda s, b: s.vBolig["tot"],
   "Pension wealth after taxes (vHhPens)": lambda s, b: s.vHhPens["tot"],
   "Wealth incl. housing, mortgage and pension": lambda s, b: s.vHhFormue["tot"],
   }, {
   "Indkomst efter skat ekskl. kapitalindkomst (vHhInd)": lambda s, b: s.vHhInd["tot"],
   "Formue ekskl. bolig, realkredit og pension (vHhx)": lambda s, b: s.vHhx["tot"],
   "Formue i bolig (vBolig)": lambda s, b: s.vBolig["tot"],
   "Pensionsformue efter skat (vHhPens)": lambda s, b: s.vHhPens["tot"],
   "Formue inkl. bolig, realkredit og pension": lambda s, b: s.vHhFormue["tot"],
   },
   "pq", 
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)"),
   ("Import shares", 
   "Importandele",
   {
   "Aggregate import share (qM/(qY+qM))": lambda s, b: s.qM["tot"]/(s.qY["tot"]+s.qM["tot"]), 
   "Import share of services (qIOm / (qIOm+qIOy))": lambda s, b: s.qIOm[s.dux][:, "tje"].groupby(level=1).sum()/(s.qIOm[s.dux][:, "tje"].groupby(level=1).sum()+s.qIOy[s.dux][:, "tje"].groupby(level=1).sum()),
   "Import share of manufacturing excl. re-exports (qIOm / (qIOm+qIOy))": lambda s, b: s.qIOm[s.dux][:, "fre"].groupby(level=1).sum()/(s.qIOm[s.dux][:, "fre"].groupby(level=1).sum()+s.qIOy[s.dux][:, "fre"].groupby(level=1).sum()),
   "Import share of energy and extraction (qIOm / (qIOm+qIOy))": lambda s, b: (s.qIOm[s.dux][:, "ene"].groupby(level=1).sum()+s.qIOm[s.dux][:, "udv"].groupby(level=1).sum())/(s.qIOm[s.dux][:, "ene"].groupby(level=1).sum()+s.qIOy[s.dux][:, "ene"].groupby(level=1).sum()+s.qIOm[s.dux][:, "udv"].groupby(level=1).sum()+s.qIOy[s.dux][:, "udv"].groupby(level=1).sum()),
   }, {
   "Samlet importandel (qM/(qY+qM))": lambda s, b: s.qM["tot"]/(s.qY["tot"]+s.qM["tot"]),
   "Importandel af services (qIOm / (qIOm+qIOy))": lambda s, b: s.qIOm[s.dux][:, "tje"].groupby(level=1).sum()/(s.qIOm[s.dux][:, "tje"].groupby(level=1).sum()+s.qIOy[s.dux][:, "tje"].groupby(level=1).sum()),
   "Importandel af fremstilling ekskl. reeksport (qIOm / (qIOm+qIOy))": lambda s, b: s.qIOm[s.dux][:, "fre"].groupby(level=1).sum()/(s.qIOm[s.dux][:, "fre"].groupby(level=1).sum()+s.qIOy[s.dux][:, "fre"].groupby(level=1).sum()),
   "Importandel af energi og udvinding (qIOm / (qIOm+qIOy))": lambda s, b: (s.qIOm[s.dux][:, "ene"].groupby(level=1).sum()+s.qIOm[s.dux][:, "udv"].groupby(level=1).sum())/(s.qIOm[s.dux][:, "ene"].groupby(level=1).sum()+s.qIOy[s.dux][:, "ene"].groupby(level=1).sum()+s.qIOm[s.dux][:, "udv"].groupby(level=1).sum()+s.qIOy[s.dux][:, "udv"].groupby(level=1).sum()),
   },
   "pq", 
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)"),
]

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
   ({
   "Residual other transfers from public sector to households (vOffTilHhRest)": lambda s, b: (s.vOffTilHhRest - b.vOffTilHhRest) / b.vBNP,
   "Income after taxes excl. capital income (vHhInd)": lambda s, b: (s.vHhInd["tot"] - b.vHhInd["tot"]) / b.vBNP,
   "Wage income before taxes (vWHh)": lambda s, b: (s.vWHh["tot"] - b.vWHh["tot"]) / b.vBNP,
   "Income transfers before taxes (vOvf)": lambda s, b: (s.vOvf["tot"] - b.vOvf["tot"]) / b.vBNP,
   "Minus taxes and other transfers (-vtHhx)": lambda s, b: -(s.vtHhx["tot"] - b.vtHhx["tot"]) / b.vBNP,
   "Net pension income (vHhPensUdb-vHhPensIndb)": lambda s, b: (s.vHhPensUdb["Pens","tot"] - s.vHhPensIndb["Pens","tot"] - (b.vHhPensUdb["Pens","tot"] - b.vHhPensIndb["Pens","tot"])) / b.vBNP,
   "Capital income excl. pension, housing and mortgages (vHhxAfk)": lambda s, b: (s.vHhxAfk["tot"] - b.vHhxAfk["tot"]) / b.vBNP,
   }, 
   {
   "Residuale øvrige overførsler fra offentlig sektor til husholdningerne (vOffTilHhRest)": lambda s, b: (s.vOffTilHhRest - b.vOffTilHhRest) / b.vBNP,
   "Indkomst efter skat ekskl. kapitalindkomst (vHhInd)": lambda s, b: (s.vHhInd["tot"] - b.vHhInd["tot"]) / b.vBNP,
   "Lønindkomst før skat (vWHh)": lambda s, b: (s.vWHh["tot"] - b.vWHh["tot"]) / b.vBNP,
   "Indkomstoverførsler før skat (vOvf)": lambda s, b: (s.vOvf["tot"] - b.vOvf["tot"]) / b.vBNP,
   "Minus skatter og andre overførsler (-vtHhx)": lambda s, b: -(s.vtHhx["tot"] - b.vtHhx["tot"]) / b.vBNP,
   "Nettopensionsindkomst (vHhPensUdb-vHhPensIndb)": lambda s, b: (s.vHhPensUdb["Pens","tot"] - s.vHhPensIndb["Pens","tot"] - (b.vHhPensUdb["Pens","tot"] - b.vHhPensIndb["Pens","tot"])) / b.vBNP,
   "Kapitalindkomst ekskl. pension, bolig og realkredit (vHhxAfk)": lambda s, b: (s.vHhxAfk["tot"] - b.vHhxAfk["tot"]) / b.vBNP,
   },
   "pm", 
   "Change relative<br>to baseline GDP (in %-points)",
   "Ændring i forhold<br>til baseline BNP (i %-point)")
   ),
   # Offentlig forbrug
   ("Offentligt_forbrug", "Government consumption",
   ({
   # "Government employment (hL)": lambda s, b: s.hL["off"],
   "Government consumption (qG)": lambda s, b: s.qG["gTot"],
   # "Government input of intermediates (qR)": lambda s, b: s.qR["off"],
   # "Government investments (qI_s)": lambda s, b: s.qI_s["iTot","off"],
   # "Government capital (qK)": lambda s, b: s.qK["iM","off"] + s.qK["iB","off"],
   "Government production (qY)": lambda s, b: s.qY["off"],
   }, {
   # "Offentlig beskæftigelse (hL)": lambda s, b: s.hL["off"],
   "Offentligt forbrug (qG)": lambda s, b: s.qG["gTot"],
   # "Offentlig input af mellemliggende varer (qR)": lambda s, b: s.qR["off"],
   # "Offentlige investeringer (qI_s)": lambda s, b: s.qI_s["iTot","off"],
   # "Offentlig kapital (qK)": lambda s, b: s.qK["iM","off"] + s.qK["iB","off"],
   "Offentlig produktion (qY)": lambda s, b: s.qY["off"],
   },
   "pq", 
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
   # Offentlig beskaeftigelse
   ("Offentlig_beskaeftigelse", "Government employment",
   ({"Government employment (hL)": lambda s, b: s.hL["off"],
   # "Government input of intermediates (qR)": lambda s, b: s.qR["off"],
   # "Government investments (qI_s)": lambda s, b: s.qI_s["iTot","off"],
   # "Government capital (qK)": lambda s, b: s.qK["iM","off"] + s.qK["iB","off"],
   "Government production (qY)": lambda s, b: s.qY["off"],
   }, 
   {
   "Offentlig beskæftigelse (hL)": lambda s, b: s.hL["off"],
   # "Offentlig input af mellemliggende varer (qR)": lambda s, b: s.qR["off"],
   # "Offentlige investeringer (qI_s)": lambda s, b: s.qI_s["iTot","off"],
   # "Offentlig kapital (qK)": lambda s, b: s.qK["iM","off"] + s.qK["iB","off"],
   "Offentlig produktion (qY)": lambda s, b: s.qY["off"],
   },
   "pq", 
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
   # Offentlig løn
   ("Offentlig_loen", "Government wages", 
   ({
   # "Government employment (hL)": lambda s, b: s.hL["off"],
   "Government wages (vLoensum[off])": lambda s, b: (s.vLoensum["off"] - b.vLoensum["off"]) / b.vLoensum["off"],
   # "Government input of intermediates (qR)": lambda s, b: s.qR["off"],
   # "Government investments (qI_s)": lambda s, b: s.qI_s["iTot","off"],
   # "Government capital (qK)": lambda s, b: s.qK["iM","off"] + s.qK["iB","off"],
   # "Government production (qY)": lambda s, b: s.qY["off"],
   },
   {
   # "Offentlig beskæftigelse (hL)": lambda s, b: s.hL["off"],
   "Offentlig lønsum (vLoensum[off])": lambda s, b: (s.vLoensum["off"] - b.vLoensum["off"]) / b.vLoensum["off"],
   # "Offentlig input af mellemliggende varer (qR)": lambda s, b: s.qR["off"],
   # "Offentlige investeringer (qI_s)": lambda s, b: s.qI_s["iTot","off"],
   # "Offentlig kapital (qK)": lambda s, b: s.qK["iM","off"] + s.qK["iB","off"],
   # "Offentlig produktion (qY)": lambda s, b: s.qY["off"],
   }, 
   "pm", 
   "Change relative<br>to baseline (in %-points)" , 
   "Ændring i forhold<br>til baseline (i %-point)")
   ),
   # Offentlig varekøb
   ("Offentlig_varekoeb", "Government purchases", 
   ({
   # "Government employment (hL)": lambda s, b: s.hL["off"],
   "Government input of intermediates (qR)": lambda s, b: s.qR["off"],
   # "Government investments (qI_s)": lambda s, b: s.qI_s["iTot","off"],
   # "Government capital (qK)": lambda s, b: s.qK["iM","off"] + s.qK["iB","off"],
   "Government production (qY)": lambda s, b: s.qY["off"],
   },
   {
   # "Offentlig beskæftigelse (hL)": lambda s, b: s.hL["off"],
   "Offentlig input af mellemliggende varer (qR)": lambda s, b: s.qR["off"],
   # "Offentlige investeringer (qI_s)": lambda s, b: s.qI_s["iTot","off"],
   # "Offentlig kapital (qK)": lambda s, b: s.qK["iM","off"] + s.qK["iB","off"],
   "Offentlig produktion (qY)": lambda s, b: s.qY["off"],
   }, 
   "pq", 
   "Change relative<br>to baseline (in %)" , 
   "Ændring i forhold<br>til baseline (i %)")
   ),
   # Offentlige investeringer
   ("Offentlige_investeringer", "Government investments", 
   ({
   # "Government employment (hL)": lambda s, b: s.hL["off"],
   # "Government input of intermediates (qR)": lambda s, b: s.qR["off"],
   "Government investments (qI_s)": lambda s, b: s.qI_s["iTot","off"],
   "Government capital (qK)": lambda s, b: s.qK["iM","off"] + s.qK["iB","off"],
   "Government production (qY)": lambda s, b: s.qY["off"],
   }, 
   {
   # "Offentlig beskæftigelse (hL)": lambda s, b: s.hL["off"],
   # "Offentlig Materialeinput (qR)": lambda s, b: s.qR["off"],
   "Offentlige investeringer (qI_s)": lambda s, b: s.qI_s["iTot","off"],
   "Offentlig kapital (qK)": lambda s, b: s.qK["iM","off"] + s.qK["iB","off"],
   "Offentlig produktion (qY)": lambda s, b: s.qY["off"],
   },
   "pq", 
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
   # Eksportmarkedsvækst
   ("Eksportmarkedsvaekst", "Foreign demand", 
   ({"Export market size (qXMarked)": lambda s, b: s.qXMarked,
   # "Export competing price of manufacturing (pXUdl)": lambda s, b: s.pXUdl["xVar"],
   # "Export competing price of services (pXUdl)": lambda s, b: s.pXUdl["xTje"],
   # "Import price of manufacturing (pM)": lambda s, b: s.pM["fre"],
   # "Import price of services (pM)": lambda s, b: s.pM["tje"],
   #   "Oil price in DDK (pOlie)": lambda s, b: s.pOlie,
   }, 
   {
   "Eksportmarkedets størrelse (qXMarked)": lambda s, b: s.qXMarked,
   # "Eksportkonkurrerende pris på fremstilling (pXUdl)": lambda s, b: s.pXUdl["xVar"],
   # "Eksportkonkurrerende pris på services (pXUdl)": lambda s, b: s.pXUdl["xTje"],
   # "Importpris på fremstilling (pM)": lambda s, b: s.pM["fre"],
   # "Importpris på tjenester (pM)": lambda s, b: s.pM["tje"],
   #   "Oliepris i DKK (pOlie)": lambda s, b: s.pOlie,
   },
   "pq", 
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
   # Arbejdsudbud
   ("Arbejdsudbud", "Labor supply", 
   ({
   "Structural household employment (snLHh)": lambda s, b: s.snLHh["tot"], 
   "Searchers plus employed (nSoegBaseHh)": lambda s, b: s.nSoegBaseHh["tot"],
   "Total household employment (nLHh)": lambda s, b: s.nLHh["tot"],
   # "Hours per worker (hL2nL)": lambda s, b: s.hL2nL["tot"],
   "GVA per worker (qBVT/nL)": lambda s, b: s.qBVT["tot"] / s.nL["tot"],
   "Supply effect (qXSkala)": lambda s, b: s.qXSkala,
   }, 
   {
   "Strukturel beskæftigelse (snLHh)": lambda s, b: s.snLHh["tot"],
   "Jobsøgende og beskæftigede (nSoegBaseHh)": lambda s, b: s.nSoegBaseHh["tot"],
   "Samlet beskæftigelse (nLHh)": lambda s, b: s.nLHh["tot"],
   # "Arbejdstid pr. beskæftiget (hL2nL)": lambda s, b: s.hL2nL["tot"],
   "BVT pr. beskæftiget (qBVT/nL)": lambda s, b: s.qBVT["tot"] / s.nL["tot"],
   "Udbudseffekt (qXSkala)": lambda s, b: s.qXSkala,
   },
   "pq", 
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
   ("ArbejdsProd", "Labor productivity", 
   ({
   "Time dependent productivity (qProdHh_t)": lambda s, b: s.qProdHh_t,
   "Productivity of cross-border workers (qProdxDK)": lambda s, b: s.qProdxDK,
   "Searchers plus employed (nSoegBaseHh)": lambda s, b: s.nSoegBaseHh["tot"],
   "Structural household employment (snLHh)": lambda s, b: s.snLHh["tot"],
   "Total household employment (nLHh)": lambda s, b: s.nLHh["tot"],
   # "Hours per worker (hL2nL)": lambda s, b: s.hL2nL["tot"],
   "GVA per worker (qBVT/nL)": lambda s, b: s.qBVT["tot"] / s.nL["tot"],
   "Supply effect (qXSkala)": lambda s, b: s.qXSkala,
   }, {
   "Tids-afhængigt produktivetet (qProdHh_t)": lambda s, b: s.qProdHh_t,
   "Grænsearbejderes produktivitet (qProdxDK)": lambda s, b: s.qProdxDK,
   "Jobsøgende og beskæftigede (nSoegBaseHh)": lambda s, b: s.nSoegBaseHh["tot"],
   "Strukturel beskæftigelse (snLHh)": lambda s, b: s.snLHh["tot"],
   "Samlet beskæftigelse (nLHh)": lambda s, b: s.nLHh["tot"],
   # "Arbejdstid pr. beskæftiget (hL2nL)": lambda s, b: s.hL2nL["tot"],
   "BVT pr. beskæftiget (qBVT/nL)": lambda s, b: s.qBVT["tot"] / s.nL["tot"],
   "Udbudseffekt (qXSkala)": lambda s, b: s.qXSkala,
   },
   "pq", 
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
   #   # KapitalProd - stød virker ikke i standard_shocks.gms
   #     ("KapitalProd", "Capital productivity", 
   #       ({"Searchers plus employed (nSoegBaseHh)": lambda s, b: s.nSoegBaseHh["tot"],
   #         "Structural household employment (snLHh)": lambda s, b: s.snLHh["tot"],
   #         "Total household employment (nLHh)": lambda s, b: s.nLHh["tot"],
   #         # "Hours per worker (hL2nL)": lambda s, b: s.hL2nL["tot"],
   #         "GVA per worker (qBVT/nL)": lambda s, b: s.qBVT["tot"] / s.nL["tot"],
   #         "Supply effect (qXSkala)": lambda s, b: s.qXSkala,
   #        }, 
   #        {
   #         "Jobsøgende og beskæftigede (nSoegBaseHh)": lambda s, b: s.nSoegBaseHh["tot"],
   #         "Strukturel beskæftigelse (snLHh)": lambda s, b: s.snLHh["tot"],
   #         "Samlet beskæftigelse (nLHh)": lambda s, b: s.nLHh["tot"],
   #         # "Arbejdstid pr. beskæftiget (hL2nL)": lambda s, b: s.hL2nL["tot"],
   #         "BVT pr. beskæftiget (qBVT/nL)": lambda s, b: s.qBVT["tot"] / s.nL["tot"],
   #         "Udbudseffekt (qXSkala)": lambda s, b: s.qXSkala,
   #        },
   #         "pq", 
   #         "Change relative<br>to baseline (in %)",
   #         "Ændring i forhold<br>til baseline (i %)")
   #      ),
   # Importpris
   ("Importpris", "Import prices", 
   ({
   # "Export marked size (qXMarked)": lambda s, b: s.qXMarked,
   # "Export competing price of manufacturing (pXUdl)": lambda s, b: s.pXUdl["xVar"],
   # "Export competing price of services (pXUdl)": lambda s, b: s.pXUdl["xTje"],
   "Import price of manufacturing (pM)": lambda s, b: s.pM["fre"],
   "Import price of services (pM)": lambda s, b: s.pM["tje"],
   # "Oil price in DDK (pOlie)": lambda s, b: s.pOlie,
   }, 
   {
   # "Eksportmarkedets størrelse (qXMarked)": lambda s, b: s.qXMarked,
   # "Eksportkonkurrerende pris på fremstilling (pXUdl)": lambda s, b: s.pXUdl["xVar"],
   # "Eksportkonkurrerende pris på services (pXUdl)": lambda s, b: s.pXUdl["xTje"],
   "Importpris på fremstilling (pM)": lambda s, b: s.pM["fre"],
   "Importpris på tjenester (pM)": lambda s, b: s.pM["tje"],
   # "Oliepris i DKK (pOlie)": lambda s, b: s.pOlie,
   },
   "pq", 
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
   # Oliepris
   ("Oliepris", "Foreign prices", 
   ({
   # "Export marked size (qXMarked)": lambda s, b: s.qXMarked,
   "Crude oil price quote, Brent [dollars/barrel] (pOlieBrent)": lambda s, b: s.pOlieBrent,
   "Oil price in DDK (pOlie)": lambda s, b: s.pOlie,
   "Import price of energy (pM)": lambda s, b: s.pM["ene"],
   "Import price of manufacturing (pM)": lambda s, b: s.pM["fre"],
   "Import price of services (pM)": lambda s, b: s.pM["tje"],
   "Export competing price of manufacturing (pXUdl)": lambda s, b: s.pXUdl["xVar"],
   "Export competing price of services (pXUdl)": lambda s, b: s.pXUdl["xTje"],
   }, {
   # "Eksportmarkedets størrelse (qXMarked)": lambda s, b: s.qXMarked,
   "Prisnotering på råolie, Brent [dollar/tønde] (pOlieBrent)": lambda s, b: s.pOlieBrent,
   "Oliepris i DKK (pOlie)": lambda s, b: s.pOlie,
   "Importpris på energi (pM)": lambda s, b: s.pM["ene"],
   "Importpris på fremstilling (pM)": lambda s, b: s.pM["fre"],
   "Importpris på tjenester (pM)": lambda s, b: s.pM["tje"],
   "Eksportkonkurrerende pris på fremstilling (pXUdl)": lambda s, b: s.pXUdl["xVar"],
   "Eksportkonkurrerende pris på services (pXUdl)": lambda s, b: s.pXUdl["xTje"],
   },
   "pq", 
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
   # Udenlandske priser
   ("Udenlandske_priser", "Foreign prices", 
   ({
   # "Export marked size (qXMarked)": lambda s, b: s.qXMarked,
   "Crude oil price quote, Brent [dollars/barrel] (pOlieBrent)": lambda s, b: s.pOlieBrent,
   "Foreign prices excl. oil and inertia (spUdlxOlie)": lambda s, b: s.spUdlxOlie,
   "Oil price in DDK (pOlie)": lambda s, b: s.pOlie,
   "Import price of energy (pM)": lambda s, b: s.pM["ene"],
   "Import price of manufacturing (pM)": lambda s, b: s.pM["fre"],
   "Import price of services (pM)": lambda s, b: s.pM["tje"],
   "Export competing price of manufacturing (pXUdl)": lambda s, b: s.pXUdl["xVar"],
   "Export competing price of services (pXUdl)": lambda s, b: s.pXUdl["xTje"],
   }, {
   # "Eksportmarkedets størrelse (qXMarked)": lambda s, b: s.qXMarked,
   "Prisnotering på råolie, Brent [dollar/tønde] (pOlieBrent)": lambda s, b: s.pOlieBrent,
   "Udenlandske priser eksklusiv effekt af oliepris og træghed (spUdlxOlie)": lambda s, b: s.spUdlxOlie,
   "Oliepris i DKK (pOlie)": lambda s, b: s.pOlie,
   "Importpris på energi (pM)": lambda s, b: s.pM["ene"],
   "Importpris på fremstilling (pM)": lambda s, b: s.pM["fre"],
   "Importpris på tjenester (pM)": lambda s, b: s.pM["tje"],
   "Eksportkonkurrerende pris på fremstilling (pXUdl)": lambda s, b: s.pXUdl["xVar"],
   "Eksportkonkurrerende pris på services (pXUdl)": lambda s, b: s.pXUdl["xTje"],
   },
   "pq", 
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
   # Rente
   ("Rente", "Interest rate", 
   ({
   "ECB key interest rate (rRenteECB)": lambda s, b: s.rRenteECB,
   "Average bond interest rate (rRente)": lambda s, b: s.rRente["Obl"],
   "Usercost of housing (pBoligUC)": lambda s, b: (s.pBoligUC - b.pBoligUC) / b.pBoligUC,
   "Usercost of machine capital (pK[iM,sByTot])": lambda s, b: (s.pK["iM","sByTot"] - b.pK["iM","sByTot"])/b.pK["iM","sByTot"],
   "Revaluation of of domestic stocks (rOmv)": lambda s, b: s.rOmv["IndlAktier"],
   }, 
   {
   "ECB's rente (rRenteECB)": lambda s, b: s.rRenteECB,
   "Gennemsnitlig obligationsrente (rRente)": lambda s, b: s.rRente["Obl"],
   "Usercost på ejerbolig (pBoligUC)": lambda s, b: (s.pBoligUC - b.pBoligUC) / b.pBoligUC,
   "Usercost på maskinkapital (pK[iM,sByTot])": lambda s, b: (s.pK["iM","sByTot"] - b.pK["iM","sByTot"])/b.pK["iM","sByTot"],
   "Omvurdering af indenlandske aktier (rOmv)": lambda s, b: s.rOmv["IndlAktier"],
   },
   "pm", 
   "Change relative<br>to baseline (%-points)",
   "Ændring i forhold<br>til baseline (i procentpoint)")
   ),
   # Diskontering
   ("Diskontering", "Household discount factor", 
   ({"Household discount factor (fDisk in 1/10 %-points)": lambda s, b: 10*(s.fDisk[40] - b.fDisk[40]),
   "Private consumption (qC)": lambda s, b: (s.qC["cTot"] - b.qC["cTot"]) /  b.qC["cTot"],
   "Housing investments (qI_s)": lambda s, b: (s.qI_s["iB","bol"] - b.qI_s["iB","bol"]) / b.qI_s["iB","bol"],
   "Wealth excl. housing, mortgage and pension (vHhx)": lambda s, b: (s.vHhx["tot"] - b.vHhx["tot"]) / b.vHhx["tot"],
   "Housing wealth (vBolig)": lambda s, b: (s.vBolig["tot"] - b.vBolig["tot"]) / b.vBolig["tot"],
   }, 
   {
   "Husholdningens diskonteringsfaktor (fDisk in 1/10 %-points)": lambda s, b: 10*(s.fDisk[40] - b.fDisk[40]),
   "Privatforbrug (qC)": lambda s, b: (s.qC["cTot"] - b.qC["cTot"]) /  b.qC["cTot"],
   "Boliginvesteringer (qI_s)": lambda s, b: (s.qI_s["iB","bol"] - b.qI_s["iB","bol"]) / b.qI_s["iB","bol"],
   "Formue ekskl. bolig, realkredit og pension (vHhx)": lambda s, b: (s.vHhx["tot"] - b.vHhx["tot"]) / b.vHhx["tot"],
   "Formue i bolig (vBolig)": lambda s, b: (s.vBolig["tot"] - b.vBolig["tot"]) / b.vBolig["tot"],
   },
   "pm", 
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
   # Loen
   ("Loen", "Wages", 
   ({
   "Nash negotiation weight (rLoenNash in %-points)": lambda s, b: s.rLoenNash - b.rLoenNash,
   "Hourly wage (vHw)": lambda s, b: (s.vhW - b.vhW) / b.vhW,
   "Income after taxes excl. capital income (vHhInd)": lambda s, b: (s.vHhInd["tot"] - b.vHhInd["tot"]) / b.vHhInd["tot"],
   "Structural household employment (snLHh)": lambda s, b: (s.snLHh["tot"] - b.snLHh["tot"]) / b.snLHh["tot"],
   "Total household employment (nLHh)": lambda s, b: (s.nLHh["tot"] - b.nLHh["tot"]) / b.nLHh["tot"],
   }, 
   {
   "Nash forhandlingsvægt (rLoenNash in %-points)": lambda s, b: s.rLoenNash - b.rLoenNash,
   "Timeløn (vHw)": lambda s, b: (s.vhW - b.vhW) / b.vhW,
   "Indkomst efter skat ekskl. kapitalindkomst (vHhInd)": lambda s, b: (s.vHhInd["tot"] - b.vHhInd["tot"]) / b.vHhInd["tot"],
   "Strukturel beskæftigelse (snLHh)": lambda s, b: (s.snLHh["tot"] - b.snLHh["tot"]) / b.snLHh["tot"],
   "Samlet beskæftigelse (nLHh)": lambda s, b: (s.nLHh["tot"] - b.nLHh["tot"]) / b.nLHh["tot"],
   },
   "pm", 
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
   # vOvfSats["pension"] er valgt da stød er ens for alle overførselsgrupper
   ("Skattepligtig_indkomstoverforsel", "Taxable income transfers",
   ({
   "Social transfers from public administration and services to households (vOvfSats)": lambda s, b: s.vOvfSats["pension"],
   },
   {
   "Sociale overførsler fra offentlig forvaltning og service til husholdninger (vOvfSats)": lambda s, b: s.vOvfSats["pension"],
   },
   "pq",
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
   # vOvfSats["pension"] er valgt da stød er ens for alle overførselsgrupper
   ("Ikke_skattepligtig_indkomstoverforsel", "Non-taxable income transfers",
   ({
   "Social transfers from public administration and services to households (vOvfSats)": lambda s, b: s.vOvfSats["pension"],
   },
   {
   "Sociale overførsler fra offentlig forvaltning og service til husholdninger (vOvfSats)": lambda s, b: s.vOvfSats["pension"],
   },
   "pq",
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
   # rSub_x['fre','fre'] er valgt da stød er ens for alle efterspørgselskomponenter og brancher
   ("Produktsubsidier", "Product subsidies",
   ({
   "Rate for product subsidies distributed on demand components and domestic industries (rSub_y)": lambda s, b: s.rSub_y["fre", "fre"],
   "Rate for product subsidies distributed on demand components and import groups (rSub_m)": lambda s, b: s.rSub_m["fre", "fre"],
   },
   {
   "Sats for produktsubsidier fordelt på efterspørgselskomponenter og indenlandske brancher (rSub_y)": lambda s, b: s.rSub_y["fre", "fre"],
   "Sats for produktsubsidier fordelt på efterspørgselskomponenter og import-grupper (rSub_m)": lambda s, b: s.rSub_m["fre", "fre"],
   },
   "pm",
   "Change relative<br>to baseline (in %-points)",
   "Ændring i forhold<br>til baseline (i %-point)")
   ),
   ("Lontilskud", "Wage subsidies",
   ({
   "Rate for wage subsidies (rsSubLoen)": lambda s, b: s.rSubLoen["tot"],
   },
   {
   "Sats for løntilskud (rSubLoen)": lambda s, b: s.rSubLoen["tot"],
   },
   "pm",
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
   ("Produktionssubsidier", "Production subsidies",
   ({
   "Production subsidies excl. wage subsidies (vSubYRest)": lambda s, b: s.vSubYRest["tot"],
   },
   {
   "Produktionssubsidier ekskl. løntilskud (vSubYRest)": lambda s, b: s.vSubYRest["tot"],
   },
   "pq",
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
   ("Bundskat", "Bottom tax",
   ({
   "Bottom tax (vtBund)": lambda s, b: (s.vtBund["tot"] - b.vtBund["tot"]) / b.vBNP,
   },
   {
   "Bundskat (vtBund)": lambda s, b: (s.vtBund["tot"] - b.vtBund["tot"]) / b.vBNP,
   },
   "pm",
   "Change relative<br>to baseline GDP  (in %-points)",
   "Ændring i forhold<br>til baseline BNP (i %-point)")
   ),
   ("AM_bidrag", "Labor market contribution",
   ({
   "Percentage for labor market contribution (tAMbidrag)": lambda s, b: s.tAMbidrag,
   },
   {
   "Procentsats for arbejdsmarkedsbidrag (tAMbidrag)": lambda s, b: s.tAMbidrag,
   },
   "pm",
   "Change relative<br>to baseline (in %-points)",
   "Ændring i forhold<br>til baseline (i %-point)")
   ),
   ("Grundskyld", "Property tax",
   ({
   "Property tax (tK['iB'])": lambda s, b: s.tK['iB','tot'],
   },
   {
   "Grundskyld (tK['iB'])": lambda s, b: s.tK['iB','tot'],
   },
   "pm",
   "Change relative<br>to baseline (in %-points)",
   "Ændring i forhold<br>til baseline (i %-point)")
   ),
   ("Ejendomsvaerdiskat", "Property value tax",
   ({
   "Property value tax (tEjd)": lambda s, b: s.tEjd,
   },
   {
   "Ejendomsværdiskat (tEjd)": lambda s, b: s.tEjd,
   },
   "pm",
   "Change relative<br>to baseline (in %-points)",
   "Ændring i forhold<br>til baseline (i %-point)")
   ),
   ("Vaegtafgift", "Weight tax",
   ({
   "Weight tax rate per car (utHhVaegt)": lambda s, b: s.utHhVaegt,
   },
   {
   "Sats-parameter for vægtafgift pr. bil (utHhVaegt)": lambda s, b: s.utHhVaegt,
   },
   "pm",
   "Change relative<br>to baseline (in %-points)",
   "Ændring i forhold<br>til baseline (i %-point)")
   ),
   ("Selskabsskat", "Corporate tax",
   ({
   "Corporate tax rate (tSelskab)": lambda s, b: s.tSelskab,
   },
   {
   "Selskabsskattesats (tSelskab)": lambda s, b: s.tSelskab,
   },
   "pm",
   "Change relative<br>to baseline (in %-points)",
   "Ændring i forhold<br>til baseline (i %-point)")
   ),
   ("Aktieskat", "Taxes on shares",
   ({
   "Implicit average tax on capital gains (tAktie)": lambda s, b: s.tAktie,
   },
   {
   "Implicit gennemsnitlig skat på aktieafkast (tAktie)": lambda s, b: s.tAktie,
   },
   "pm",
   "Change relative<br>to baseline (in %-points)",
   "Ændring i forhold<br>til baseline (i %-point)")
   ),
   # tMoms_y["tje","tje"] og tMoms_m["tje","tje"] er valgt da stød er ens for alle efterspørgselskomponenter og brancher
   ("Moms", "VAT",
   ({
   "VAT rate distributed on demand components and domestic industries (tMoms_y)": lambda s, b: s.tMoms_y["tje","tje"],
   "VAT rate distributed on demand components and import groups (tMoms_m)": lambda s, b: s.tMoms_m["tje","tje"],
   },
   {
   "Momssats fordelt på efterspørgselskomponenter og input fra indenlandske brancher (tMoms_y)": lambda s, b: s.tMoms_y["tje","tje"],
   "Momssats fordelt på efterspørgselskomponenter og import-grupper (tMoms_m)": lambda s, b: s.tMoms_m["tje","tje"],
   },
   "pm",
   "Change relative<br>to baseline (in %-points)",
   "Ændring i forhold<br>til baseline (i %-point)")
   ),
   # tReg_m["cBil","fre"] er valgt da stød er ens for alle efterspørgselskomponenter og brancher
   ("Registreringsafgift", "Registration tax",
   ({
   "Registration tax rate (tReg_m)": lambda s, b: s.tReg_m["cBil","fre"],
   },
   {
   "Registreringsafgiftssats for biler (tReg_m)": lambda s, b: s.tReg_m["cBil","fre"],
   },
   "pm",
   "Change relative<br>to baseline (in %-points)",
   "Ændring i forhold<br>til baseline (i %-point)")
   ),
   # tAfg_y["cEne","fre"] og tAfg_m["cEne","fre"] er valgt da stød er ens for alle brancher
   ("Energiafgift", "Energy tax",
   ({
   "Energi tax (tAfg_y[cEne])": lambda s, b: s.tAfg_y["cEne","fre"],
   "Energi tax (tAfg_m[cEne])": lambda s, b: s.tAfg_m["cEne","fre"],
   },
   {
   "Energiafgift (tAfg_y[cEne])": lambda s, b: s.tAfg_y["cEne","fre"],
   "Energiafgift (tAfg_m[cEne])": lambda s, b: s.tAfg_m["cEne","fre"],
   },
   "pm",
   "Change relative<br>to baseline (in %-points)",
   "Ændring i forhold<br>til baseline (i %-point)") 
   ),
   # tAfg_y["cVar","fre"] og tAfg_m["cVar","fre"] er valgt da stød er ens for alle brancher
   ("Forbrugsafgift", "Consumption tax",
   ({"Consumption tax (tAfg_y[cVar])": lambda s, b: s.tAfg_y["cVar","fre"],
   "Consumption tax (tAfg_m[cVar])": lambda s, b: s.tAfg_m["cVar","fre"],
   },
   {"Forbrugsafgift (tAfg_y[cVar])": lambda s, b: s.tAfg_y["cVar","fre"],
   "Forbrugsafgift (tAfg_m[cVar])": lambda s, b: s.tAfg_m["cVar","fre"],
   },
   "pm",
   "Change relative<br>to baseline (in %-points)",
   "Ændring i forhold<br>til baseline (i %-point)")
   ),
   # tAfg_y["fre","fre"] og tAfg_m["fre","fre"] er valgt da stød er ens for alle private brancher
   ("Afgift_erhverv", "Business taxes",
   ({
   "Business taxes (tAfg_y[r,sp[s]])": lambda s, b: s.tAfg_y["fre","fre"],
   "Business taxes (tAfg_m[r,sp[s]])": lambda s, b: s.tAfg_m["fre","fre"],
   },
   {
   "Erhvervsafgifter (tAfg_y[r,sp[s]])": lambda s, b: s.tAfg_y["fre","fre"],
   "Erhvervsafgifter (tAfg_m[r,sp[s]])": lambda s, b: s.tAfg_m["fre","fre"],
   },
   "pm",
   "Change relative<br>to baseline (in %-points)",
   "Ændring i forhold<br>til baseline (i %-point)")
   ),
   ("Eksportkonkurrerende_priser", "Export competing prices",
   ({
   "Export competing price of manufacturing (pXUdl[xTot])": lambda s, b: s.pXUdl["xTot"],
   },
   {
   "Eksportkonkurrerende pris på fremstilling (pXUdl[xTot])": lambda s, b: s.pXUdl["xTot"],
   },
   "pq",
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
   ("Udenlandske_priser_exo", "Foreign prices",
   ({
   "Import price of manufacturing (pM)": lambda s, b: s.pM["tot"],
   "Export competing price of manufacturing (pXUdl[xTot])": lambda s, b: s.pXUdl["xTot"],
   },
   {
   "Importdeflator fordelt på importgrupper (pM)": lambda s, b: s.pM["tot"],
   "Eksportkonkurrerende udenlandsk pris (pXUdl[xTot])": lambda s, b: s.pXUdl["xTot"],
   },
   "pq",
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
   ("Arbejdsudbud - beskæftigelse", "Labor supply - employment",
   ({
   "Structural household employment (snLHh)": lambda s, b: s.snLHh["tot"],
   },
   {
   "Strukturel beskæftigelse (snLHh)": lambda s, b: s.snLHh["tot"],
   },
   "pq",
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
   ("Arbejdsudbud - timer", "Labor supply - hours",
   ({
   "Structural household hours (shLHh)": lambda s, b: s.shLHh["tot"],
   },
   {
   "Strukturel arbejdstid (shLHh)": lambda s, b: s.shLHh["tot"],
   },
   "pq",
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
   ("Befolkning", "Population",
   ({
   "Total population (nPop)": lambda s, b: s.nPop["tot"],
   "Sum of border workers and job seeking potential border workers (nSoegBasexDK)": lambda s, b: s.nSoegBasexDK,
   "Public consumption (qG)": lambda s, b: s.qG["gTot"],
   },
   {
   "Total befolkning (nPop)": lambda s, b: s.nPop["tot"],
   "Sum af grænsearbejdere og jobsøgende potentielle grænsearbejdere (nSoegBasexDK)": lambda s, b: s.nSoegBasexDK,
   "Offentligt forbrug (qG)": lambda s, b: s.qG["gTot"],
   },
   "pq",
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
   # rVirkDiskPrem["tje"] er valgt da stød er ens for alle brancher
   ("VirkDisk", "Firm discount factor",
   ({
   "Risk premium in discount factor for the decision makers in the firm (rVirkDiskPrem)": lambda s, b: s.rVirkDiskPrem["tje"],           },
   {
   "Risikopræmie i diskonteringsraten for virksomhedens beslutningstagere (rVirkDiskPrem)": lambda s, b: s.rVirkDiskPrem["tje"],
   },
   "pm",
   "Change relative<br>to baseline (in %-points)",
   "Ændring i forhold<br>til baseline (i %-point)")
   ),
   ("BoligRisiko", "Housing risk premium",
   ({
   "Risk premium for housing (rBoligPrem)": lambda s, b: s.rBoligPrem,
   },
   {
   "Risikopræmie for boliger (rBoligPrem)": lambda s, b: s.rBoligPrem,
   },
   "pm",
   "Change relative<br>to baseline (in %-points)",
   "Ændring i forhold<br>til baseline (i %-point)")
   ),
   # rVirkDiskPrem["tje"] er valgt da stød er ens for alle brancher
   ("AktieAfkast", "Stock return",
   ({
   "Risk premium in discount factor for the decision makers in the firm (rVirkDiskPrem)": lambda s, b: s.rVirkDiskPrem["tje"],
   "Risk premium on domestic stocks (rIndlAktiePrem)": lambda s, b: s.rIndlAktiePrem["tje"],
   },{
   "Risikopræmie i diskonteringsraten for virksomhedens beslutningstagere (rVirkDiskPrem)": lambda s, b: s.rVirkDiskPrem["tje"],
   "Risikopræmie på indenlandske aktier (rIndlAktiePrem)": lambda s, b: s.rIndlAktiePrem["tje"],
   },
   "pm",
   "Change relative<br>to baseline (in %-points)",
   "Ændring i forhold<br>til baseline (i %-point)")
   ),
   # rVirkDiskPrem["tje"] og rIndlAktiePrem["tje"] er valgt da stød er ens for alle brancher
   ("RisikoPraemier", "Risk premiums",
   ({
   "Risk premium in discount factor for the decision makers in the firm (rVirkDiskPrem)": lambda s, b: s.rVirkDiskPrem["tje"],
   "Risk premium on domestic stocks (rIndlAktiePrem)": lambda s, b: s.rIndlAktiePrem["tje"],
   "Risk premium for housing (rBoligPrem)": lambda s, b: s.rBoligPrem,
   },{
   "Risikopræmie i diskonteringsraten for virksomhedens beslutningstagere (rVirkDiskPrem)": lambda s, b: s.rVirkDiskPrem["tje"],
   "Risikopræmie på indenlandske aktier (rIndlAktiePrem)": lambda s, b: s.rIndlAktiePrem["tje"],
   "Risikopræmie for boliger (rBoligPrem)": lambda s, b: s.rBoligPrem,
   },
   "pm",
   "Change relative<br>to baseline (in %-points)",
   "Ændring i forhold<br>til baseline (i %-point)")
   ),
   ("Prisneutralitet", "Price neutrality",
   ({
   "Foreign prices excl. oil and inertia (spUdlxOlie)": lambda s, b: s.spUdlxOlie,
   },
   {
   "Udenlandske priser eksklusiv effekt af oliepris og træghed (spUdlxOlie)": lambda s, b: s.spUdlxOlie,
   },
   "pq",
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
   ("Befolkningshomogenitet", "Population homogeneity",
   ({
   "Total population (nPop)": lambda s, b: s.nPop["tot"],
   },
   {
   "Total befolkning (nPop)": lambda s, b: s.nPop["tot"],
   },
   "pq",
   "Change relative<br>to baseline (in %)",
   "Ændring i forhold<br>til baseline (i %)")
   ),
]
suffix = "_ufin" # Suffix added to shock file names
shock_labels = [s[1] for s in shock_info]

# Default yaxis labels based on operator
yaxis_title_from_operator = {
    "pq": "Pct. ændring",
    "pm": "Ændring i procentpoint",
    "": "",
} if DA else {
    "pq": "Pct. change",
    "pm": "Change in %-points",
    "": "",
}

dt.REFERENCE_DATABASE = dt.Gdx(baseline_path)
for shock_name, shock_label, shock_plot_info in shock_info:
    plot_info[0] = ("Shock", "Stød", *shock_plot_info) # Shock specific plot is inserted as first sub-plot
    shock_path = f"{shock_folder}/{shock_name}{suffix}.gdx"
    # Unpack plot_info and select language
    figure_name_EN, figure_name_DK, lines_info_EN, lines_info_DK, operator, yaxis_label_EN, yaxis_label_DK = [list(t) for t in zip(*plot_info)]
    figure_name = figure_name_DK if DA else figure_name_EN
    lines_info = lines_info_DK if DA else lines_info_EN
    yaxis_label = yaxis_label_DK if DA else yaxis_label_EN
    try:
      database = dt.Gdx(shock_path)
      output_folder = f"{output_folder_base}/{shock_name}"
      if not os.path.exists(output_folder):
          os.makedirs(output_folder)
      for figure_name, lines_info, operator, yaxis_label in zip(
                figure_name,
                lines_info,
                operator,
                yaxis_label
            ):
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
              xaxis_title_text = "År" if DA else "Year",
          ), horizontal_yaxis_title=False)
          output_path = f"{output_folder}/{figure_name}{output_extension}"
          dt.write_image(fig, output_path)
    except:
      print(shock_path)