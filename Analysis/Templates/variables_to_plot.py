import dreamtools as dt
import pandas as pd
import numpy as np
import plotly.graph_objects as go

import os

r = dt.REFERENCE_DATABASE

def create_getter_func(index, variable_name):
    """ Returns a function that extracts the variable with the given index from a gdx file
        Useful when looping through indices to create local bounds in functions
    """
    return lambda s: s[variable_name][index]

def create_getter_func_ratio(index1, index2, variable_name1, variable_name2):
    """ Returns a function that extracts the variable with the given index from a gdx file
        Useful when looping through indices to create local bounds in functions
        Used for ratios of two variables
    """
    func = lambda s: s[variable_name1][index1] / s[variable_name2][index2]
    return func

def create_getter_func_sum(variable_name, set):
    """ Returns a function that takes a sum over a given set of a variable from a bank s"""
    func = lambda s: s[variable_name][set].groupby(level="t").sum()
    return func

def create_getter_func_sum_ratio(variable_name, set, denom_var, denom_index):
    """ Returns a function that takes a sum over a given set of a variable from a bank s"""
    func = lambda s: s[variable_name][set].groupby(level="t").sum() / s[denom_var][denom_index]
    return func

def append_spaces_to_make_unique(strings):
    """Hack to make sure labels are also unique identifiers by adding spaces"""
    unique_labels = []
    for string in strings:
        if string not in unique_labels:
            unique_labels.append(string)
        else:
            new_string = string + ' '
            while new_string in unique_labels:
                new_string += ' '
            unique_labels.append(new_string)
    return unique_labels

"""
Lists of tuples each containing information about a variable to plot
(
    <label for variable in Danish>,
    <label for variable in English>,
    <function to extract variable from a gdx file>,
    <multiplier type (operator) if plotting a shock>,
)
"""
page_1_figures = [
    ("Offentligt forbrug (qG)", "Government consumption (qG)", lambda s: s.qG, "pq"),
    ("BVT (qBVT)", "Gross value added (qBVT)", lambda s: s.qBVT, "pq"),
    ("Beskæftigelse (nL)", "Employment (nL)", lambda s: s.nL, "pq"),

    ("Privat forbrug (qC)", "Private consumption (qC)", lambda s: s.qC, "pq"),
    ("Eksport (qXy)", "Exports (qXy)", lambda s: s.qXy, "pq"),
    ("Import (qM)", "Imports (qM)", lambda s: s.qM, "pq"),

    ("Private maskininvesteringer<br>(qI_s[iM,spTot])", "Private machine investments<br>(qI_s[iM,spTot])", lambda s: s.qI_s["iM","spTot"], "pq"),
    ("Erhvervs-bygningsinvesteringer<br>(qIbErhverv)", "Commercial building investments<br>(qIbErhverv)", lambda s: s.qIbErhverv, "pq"),
    ("Boliginvesteringer (qI_s[iB,bol])", "Housing investments (qI_s[iB,bol])", lambda s: s.qI_s["iB","bol"], "pq"),

    ("BVT-deflator (pBVT)", "Prices index, GrossValueAdded<br>(pBVT)", lambda s: s.pBVT, "pq"),
    ("Nominelle lønninger (vhW_DA)", "Nominal wages (vhW_DA)", lambda s: s.vhW_DA, "pq"),
    ("Boligpriser (pBolig)", "Housing prices (pBolig)", lambda s: s.pBolig, "pq"),

    ("Primær saldo, andel af BNP<br>(vPrimSaldo / vBNP)", "Primary budget surplus, share of GDP<br<br>(vPrimSaldo / vBNP)", lambda s: s.vPrimSaldo / s.vBNP, "pm"),
    ("Holdbarhedsindikator (rHBI)", "", lambda s: s.rHBI, "pm"),
    ("Skatte-reaktion (tLukning)", "Tax reaction (tLukning)", lambda s: s.tLukning, ""),

    ("Bruttoledighedsgrad<br>(nBruttoLedig/nBruttoArbsty)", "Unemployment rate<br>(nBruttoLedig/nBruttoArbsty)", lambda s: s.nBruttoLedig / s.nBruttoArbsty, "pm"),
    ("Outputgab (qBVT / sqBVT - 1)", "Output gap (qBVT / sqBVT - 1)", lambda s: s.qBVT / s.sqBVT - 1, "pm"),
    ("Beskæftigelsesgab (nL / snL - 1)", "Employment gap (nL / snL - 1)", lambda s: s.nL / s.snL - 1, "pm"),
]

page_2_figures = [
    ("Beskæftigelse (nL)", "Employment (nL)", lambda s: s.nL, "pq"),
    ("Offentlig beskæftigelse (nL[off])", "Public sector employment<br>(nL[off])", lambda s: s.nL["off"], "pq"),
    ("Privat beskæftigelse (nL[spTot])", "Private sector employment<br>(nL[spTot]", lambda s: s.nL["spTot"], "pq"),

    ("BVT-deflator (pBVT)", "Price indexindex, GrossValueAdded<br>(pBVT)", lambda s: s.pBVT, "pq"),
    ("Forbrugerpriser (pC)", "Consumer prices (pC)", lambda s: s.pC, "pq"),
    ("Eksportpriser (pXy)", "Export prices (pX)", lambda s: s.pXy, "pq"),

    ("Maskinkapital/Produktion<br>(qK[iM,spTot]/qY[spTot])", "Equipment / output<br>(qK[iM,spTot]/qY[spTot])",
        lambda s: s.qK["iM","spTot"] / s.qY["spTot"], "pm"),
    ("Bygningskapital/Produktion<br>(qK[iB,spTot]/qY[spTot])", "Structures / output<br>(qK[iB,spTot]/qY[spTot])",
        lambda s: s.qK["iB","spTot"] / s.qY["spTot"], "pm"),
    ("Arbejdskraft/Produktion<br>(qL[spTot]/qY[spTot])", "Labor / output<br>(qL[spTot]/qY[spTot])",
        lambda s: s.qL["spTot"] / s.qY["spTot"], "pm"),

    ("Relativ pris på maskinkapital<br>(pK[iM,spTot]/pBVT[spTot])", "Relative price of equipment<br>(pK[iM,spTot]/pBVT[spTot])",
        lambda s: s.pK["iM","spTot"] / s.pBVT["spTot"], "pm"),
    ("Relativ pris på bygningskapital<br>(pK[iB,spTot]/pBVT[spTot])", "Relative price of structures<br>(pK[iB,spTot]/pBVT[spTot])",
        lambda s: s.pK["iB","spTot"] / s.pBVT["spTot"], "pm"),
    ("Relativ pris på arbejdskraft<br>(pL[spTot]/pBVT[spTot])", "Relative price of labor<br>(pL[spTot]/pBVT[spTot])",
        lambda s: s.pL["spTot"] / s.pBVT["spTot"], "pm"),

    ("Rente (rRente[Obl])", "Interest rate (rRente[Obl])", lambda s: s.rRente["Obl"], "pm"),
    ("Oliepris-stigning (pOlie)", "Oil price increase (pOlie)", lambda s: s.pOlie / dt.lag(s.pOlie) * s.fp - 1, "pm"),
    ("Udenlandsk inflation (pM)", "Foreign inflation (pM)", lambda s: s.pM / dt.lag(s.pM) * s.fp - 1, "pm"),

    ("Inflation (pBVT)", "Inflation<br>(pBVT)", lambda s: s.pBVT / dt.lag(s.pBVT) * s.fp - 1, "pm"),
    ("Løn-inflation (vhW_DA)", "Wage inflation<br>(vhW_DA)", lambda s: s.vhW_DA / dt.lag(s.vhW_DA) * s.fv - 1, "pm"),
    ("Lønkvote (vLoensum / vBVT)", "Labor-share", lambda s: s.vLoensum / s.vBVT, "pm"),
]

page_3_figures = [
    ("Netto-fordrings-erhvervelse<br>for husholdninger (vHhNFE / s.vBNP)", "Change in net worth<br>of households (vHhNFE / s.vBNP)", lambda s: s.vHhNFE / s.vBNP, "pm"),
    ("Netto-fordrings-erhvervelse<br>for virksomheder (vVirkNFE / s.vBNP)", "Change in net worth<br>of firms (vVirkNFE / s.vBNP)", lambda s: s.vVirkNFE / s.vBNP, "pm"),
    ("Netto-fordrings-erhvervelse<br>for udlandet (vUdlNFE / s.vBNP)", "Change in net worth<br>of foreign sector (vUdlNFE / s.vBNP)", lambda s: s.vUdlNFE / s.vBNP, "pm"),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
]

public_production_figures = [
    ("Offentlig produktion (qY[off])", "Public production (qY[off])", lambda s: s.qY["off"], "pq"),
    ("Offentlig BVT (qBVT[off])", "Public gross value added (qBVT[off])", lambda s: s.qBVT["off"], "pq"),
    ("Offentligt forbrug (qG)", "Government consumption (qG)", lambda s: s.qG, "pq"),

    ("Deflator for offentlig produktion (pY[off])", "Public production price index (pY[off])", lambda s: s.pY["off"], "pq"),
    ("Deflator for offentlig BVT (pBVT[off])", "Public gross value added price index (pBVT[off])", lambda s: s.pBVT["off"], "pq"),
    ("Deflator for offentligt forbrug (pG)", "Government consumption price index (pG)", lambda s: s.pG, "pq"),

    ("Offentlig beskæftigelse i hoveder (nL[off])", "Public employment, headcount (nL[off])", lambda s: s.nL["off"], "pq"),
    ("Offentlig beskæftigelse i timer (hL[off])", "Public employment, hours (hL[off])", lambda s: s.hL["off"], "pq"),
    ("Offentlig beskæftigelse i produktivitetsenheder<br> (qProd[off] * hL[off])", "Public employment, produvtivity units (qProd[off] * hL[off])", lambda s: s.qProd["off"] * s.hL["off"], "pq"),

    ("Offentlig maskinkapital (qK[iM,off])", "Public equipment capital (qK[iM,off])", lambda s: s.qK["iM","off"], "pq"),
    ("Offentlig bygningskapital (qK[iB,off])", "Public structures capital (qK[iB,off])", lambda s: s.qK["iB","off"], "pq"),
    ("Offentlige materialekøb (qR[off])", "Public intermediate goods purchases (qR[off])", lambda s: s.qR["off"], "pq"),

    ("Offentlige maskininvesteringer (qI_s[iM,off])", "Public equipment investment (qI_s[iM,off])", lambda s: s.qI_s["iM","off"], "pq"),
    ("Offentlige bygningsinvesteringer (qI_s[iB,off])", "Public structures investment (qI_s[iB,off])", lambda s: s.qI_s["iB","off"], "pq"),
    ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
]

consumers_figures = [
    *[(f"Privat forbrug af {c} (qC[{c})]", f"Private consumption of type {c} (qC[{c})", create_getter_func(c, "qC"), "pq")
        for c in r.c],
    # ("", "", lambda s: s.qBNP*0, ""),
    # ("", "", lambda s: s.qBNP*0, ""),

    # ("", "", lambda s: s.qBNP*0, ""),
    # ("", "", lambda s: s.qBNP*0, ""),
    # ("", "", lambda s: s.qBNP*0, ""),

    ("Husholdningers Aggregerede formue ekls. bolig,<br> realkreditgæld og pension (vHhx[aTot]) ", "Aggregate household wealth excl. housing, <br> mortgages and pension (vHhx[aTot])", lambda s: s.vHhx["tot"], "pq"),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
]

exports_figures = [
    *[(f"Eksport af {x} (qXy[{x})]", f"Exports of type {x} (qXy[{x})", create_getter_func(x, "qXy"), "pq")
        for x in r.x],
    # ("", "", lambda s: s.qBNP*0, ""),
    # ("", "", lambda s: s.qBNP*0, ""),

    # ("", "", lambda s: s.qBNP*0, ""),
    # ("", "", lambda s: s.qBNP*0, ""),
    ("Skala-effekt i eksport (qXSkala)", "Scale-effect in Exports (qXSkala)", lambda s: s.qXSkala, "pq"),

    ("Udenlandsk efterspørgsel for givne priser(qXTraek)", "Foreign demand for given prices(qXTraek)", lambda s: s.qXTraek, "pq"),
    *[(f"Relative eksportpriser for {x} <br> (rpXy2pXUdl[{x}])", f"Relative export prices for type <br> {x} (rpXy2pXUdl[{x}])", create_getter_func(x, "rpXy2pXUdl"), "pq")
        for x in r.x],
    # ("", "", lambda s: s.qBNP*0, ""),

    # ("", "", lambda s: s.qBNP*0, ""),
    # ("", "", lambda s: s.qBNP*0, ""),
    # ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),    
]

def GDP_share(var_name):
  # return lambda s: s[var_name] / s.baseline["vBNP"]
  return lambda s: s[var_name] / s["vBNP"]

government_Revenues = [
    ("Offentlig sektors saldo<br>(vSaldo / vBNP)", "Offentlig sektors saldo<br>(vSaldo / vBNP)", GDP_share("vSaldo"), "pm"),
    ("Offentliges primære indtægter<br>(vOffPrimInd / vBNP)", "Public sector primary revenue<br>(vOffPrimInd / vBNP)", GDP_share("vOffPrimInd"), "pm"),
    ("Offentliges primære udgifter<br>(vOffPrimUd / vBNP)", "Public sector primary expenditures<br>(vOffPrimUd / vBNP)", GDP_share("vOffPrimUd"), "pm"),
    
    ("Direkte skatter", "Direct taxes", GDP_share("vtDirekte"), "pm"),
    ("Indirekte skatter<br>(vtIndirekte / vBNP)", "Indirect taxes", GDP_share("vtIndirekte"), "pm"),
    ("Andre offentlige indtægter<br>(vOffIndRest / vBNP)", "Other government revenues", GDP_share("vOffIndRest"), "pm"),
    
    ("Kildeskatter<br>(vtKilde / vBNP)", "Withholding taxes", GDP_share("vtKilde"), "pm"),
    ("Arbejdsmarkedsbidrag betalt af husholdningerne<br>(vtHhAM / vBNP)", "Labor market contribution<br>(vtHhAM / vBNP)", lambda s: s.vtHhAM['tot']/s.vBNP, "pq"),
    ("Selskabsskat<br>(vtSelskab / vBNP)", "Corporation tax<br>(vtSelskab / vBNP)", lambda s: s.vtSelskab['tot']/s.vBNP, "pq"),
    
    ("PAL skat<br>(vtPAL / vBNP)", "PAL tax<br>(vtPAL / vBNP)", GDP_share("vtPAL"), "pm"),
    ("Vægtafgifter fra husholdningerne<br>(vtHhVaegt / vBNP)", "Car taxes from households<br>(vtHhVaegt / vBNP)", lambda s: s.vtHhVaegt['tot']/s.vBNP, "pq"),
    ("Dødsboskat<br>(vtDoedsbo / vBNP)", "Estate tax<br>(vtDoedsbo / vBNP)", lambda s: s.vtDoedsbo['tot']/s.vBNP, "pq"),

    ("Kommunal indkomstskatter<br>(vtKommune / vBNP)", "Municipal income taxes<br>(vtKommune / vBNP)", lambda s: s.vtKommune['tot']/s.vBNP, "pq"),
    ("Bundskatter<br>(vtBund / vBNP)", "Federal taxes<br>(vtBund / vBNP)", lambda s: s.vtBund['tot']/s.vBNP, "pq"),
    ("Aktieskat<br>(vtAktie / vBNP)", "Tax on shares<br>(vtAktie / vBNP)", lambda s: s.vtAktie['tot']/s.vBNP, "pq"),

    ("Topskatter<br>(vtTop / vBNP)", "Top taxes<br>(vtTop / vBNP)", lambda s: s.vtTop['tot']/s.vBNP, "pq"),
    ("Ejendomsværdibeskatning<br>(vtEjd / vBNP)", "Property tax<br>(vtEjd / vBNP)", lambda s: s.vtEjd['tot']/s.vBNP, "pq"),
    ("Samlet rest skat<br> (Medielicens, virksomhedsskat og restskat)", " Media license, company tax and residual tax", lambda s: (s.vtMedie + s.vtVirksomhed['tot'] + s.vtPersRest['tot'] )/s.vBNP, "pq"),
]

government_Expenditures = [
    ("Offentlig sektors saldo<br>(vSaldo / vBNP)", "Offentlig sektors saldo<br>(vSaldo / vBNP)", GDP_share("vSaldo"), "pm"),
    ("Offentliges primære indtægter<br>(vOffPrimInd / vBNP)", "Public sector primary revenue<br>(vOffPrimInd / vBNP)", GDP_share("vOffPrimInd"), "pm"),
    ("Offentliges primære udgifter<br>(vOffPrimUd / vBNP)", "Public sector primary expenditures<br>(vOffPrimUd / vBNP)", GDP_share("vOffPrimUd"), "pm"),

    ("Offentligt forbrug<br>(vG / vBNP)", "Government expenditures<br>(vG / vBNP)", GDP_share("vG"), "pm"),
    ("Sociale overførsler fra offentlig forvaltning<br> og service til husholdninger<br>(vOvf / vBNP)", "Social transfers from public administration<br> and services to households<br>(vOvf / vBNP)", lambda s: s.vOvf['tot']/s.vBNP, "pq"),
    ("Offentlige investeringer<br>(vOffInv / vBNP)", "Government investments<br>(vOffInv / vBNP)", GDP_share("vOffInv"), "pm"),

    ("Dansk finansieret subsidier ialt<br>(vOffSub / vBNP)", "Danish finances subsidies i total<br>(vOffSub / vBNP)", GDP_share("vOffSub"), "pm"),
    ("Øvrige offentlige udgifter<br>(vOffUdRest / vBNP)", "Other government expenses<br>(vOffUdRest / vBNP)", GDP_share("vOffUdRest"), "pm"),
    ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),   

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),   

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),   
]

HHIncome_figures = [
    ("Husholdningers aggrerede indkomst (vHhInd[aTot])", "Household aggregate income (vHhInd[aTot])", lambda s: s.vHhInd["tot"], "pq"),
    ("Afkast på husholdningernes <br> aggrerede formue (vHhxAfk[aTot])", "Return on households <br> aggregate wealth (vHhxAfk[aTot])", lambda s: s.vHhxAfk["tot"], "pq"),
    ("Aggregerede pensions indbetalinger<br> (vHhPensIndb[pensTot,aTot])", "Aggregate pension deposits (vHhPensIndb[pensTot,aTot])", lambda s: s.vHhPensIndb["pensTot","tot"], "pq"),

    ("Aggregerede pensions <br> udbetalinger (vHhPensUdb[pensTot,aTot])", "Aggregate pension payments <br> (vHhPensUdb[pensTot,aTot])", lambda s: s.vHhPensUdb["pensTot","tot"], "pq"),
    ("Husholdningers samlede <br> formue (vHhFormue[aTot])", "Household total wealth <br> (vHhFormue[aTot])", lambda s: s.vHhFormue["tot"], "pq"),
    ("Marginalt afkast på <br> husholdningernes formue (mrHhxAfk)", "Marginal return on household <br> wealth (mrHhxAfk)", lambda s: s.mrHhxAfk, "pm"),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
]

IO_figures = [
    *[(f"Import af {m} (qM[{m}])", f"Import of type {m} (qM[{m}])", create_getter_func(m, "qM"), "pq")
        for m in r.s],

    *[(f"BVT i branche {s} (qBVT[{s}])", f"GVA in sector {s} (qBVT[{s}])", create_getter_func(s, "qBVT"), "pq")
        for s in r.s],
]

LaborMarket_figures = [
    *[(f"Usercost af arbejdskraft i sektor {s} (pL[{s}])", f"Usercost of labor in sector {s} (pL[{s}])", create_getter_func(s, "pL"), "pq")
        for s in r.s],

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
]

Pricing_figures = [
    *[(f"Produktionsdeflator i branche {s} (pY[{s}])", f"Production deflator in sector {s} (pY[{s}])", create_getter_func(s, "pY"), "pq")
        for s in r.s],

    *[(f"Beskæftigelse i branche {s} (nL[{s}])", f"Employment in sector {s} (nL[{s}])", create_getter_func(s, "nL"), "pq")
        for s in r.s],
]

Productionprivate_figures = [
    *[(f"Usercost af maskinkapital <br> i branche {s} (pK[iM,{s}])", f"Usercost of equipment capital <br> in sector {s} (pK[iM,{s}])", create_getter_func(("iM",s), "pK"), "pq")
        for s in r.s],
    *[(f"Usercost af bygningskapital <br> i branche {s} (pK[iB,{s}])", f"Usercost of structures capital <br> in sector {s} (pK[iB,{s}])", create_getter_func(("iB",s), "pK"), "pq")
        for s in r.s],

    *[(f"Maskinkapital <br> i branche {s} (qK[iM,{s}])", f"Equipment capital <br> in sector {s} (qK[iM,{s}])", create_getter_func(("iM",s), "qK"), "pq")
        for s in r.s],
    *[(f"Bygningskapital <br> i branche {s} (qK[iB,{s}])", f"Structures capital <br> in sector {s} (qK[iB,{s}])", create_getter_func(("iB",s), "qK"), "pq")
        for s in r.s],
]

struk_figures = [
    # *[(f"Strukturel BVT i branche {s_el} (sqBVT[{s_el}])", f"Structural GVA in sector {s_el} (sqBVT[{s_el}])", create_getter_func(s_el, "sqBVT"), "pq") for s_el in r.s],
    # # ("", "", lambda s: s.qBNP*0, ""),
    # # ("", "", lambda s: s.qBNP*0, ""),

    # # ("", "", lambda s: s.qBNP*0, ""),
    # # ("", "", lambda s: s.qBNP*0, ""),
    # # ("", "", lambda s: s.qBNP*0, ""),

    # # ("", "", lambda s: s.qBNP*0, ""),
    # # ("", "", lambda s: s.qBNP*0, ""),
    # # ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),

    ("Strukturel beskæftigelse (snLHh[aTot])", "Structural employment (snLHh[aTot])", lambda s: s.snLHh["tot"], "pm"),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
]

finance_figures = [
    ("Aktieværdi (vAktie / vBNP)", "Share value (vAktie / vBNP)", GDP_share("vAktie"), "pq"),
    ("Værdi af virksomhed ekskl. <br> finansielle aktiver (vAktieDrift / vBNP)", "Value of firms excl. <br> financial assets (vAktieDrift / vBNP)", GDP_share("vAktieDrift"), "pq"),
    ("Værdi af virksomhedernes finansielle  <br> aktiver (vAktieFin / vBNP)", "Value of firms' financial <br> assets (vAktieFin / vBNP)", GDP_share("vAktieFin"), "pq"),

    ("Aktieafkast (rAfk[IndlAktier])", "Rate of return on domestic equities (rAfk[IndlAktier])", lambda s: s.rAfk["IndlAktier"], "pm"),
    ("Afkast på virksomhedernes <br> finansielle aktiver (rAktieFinAfk)", "Return on firms' financial <br> assets (rAktieFinAfk)", lambda s: s.rAktieFinAfk, "pm"),    
    ("Husholdningernes formueindkomst af<br>netto beholdning af<br> obligationer (vHhAktRenter[Obl])", "Households net income from<br> bonds (vHhAktRenter[Obl])", lambda s: s.vHhAktRenter["Obl"]/s.vBNP, "pq"),

    ("Husholdningernes formueindkomst <br> af brutto beholdning af<br> danske aktier (vHhAktRenter[IndlAktier])", "Households gross income<br> from domestic stocks (vHhAktRenter[IndlAktier])", lambda s: s.vHhAktRenter["IndlAktier"]/s.vBNP, "pq"),
    ("Husholdningernes formueindkomst <br> af brutto beholdning af<br> udenlandske aktier (vHhAktRenter[UdlAktier])", "Households gross income<br> from foreign stocks (vHhAktRenter[UdlAktier])", lambda s: s.vHhAktRenter["UdlAktier"]/s.vBNP, "pq"),
    ("Husholdningernes formueindkomst <br> af netto pensionsformue<br> (vHhAktRenter[Pens])", "Households net income<br> from pensions (vHhAktRenter[Pens])" , lambda s: s.vHhAktRenter["Pens"]/s.vBNP, "pq"),

    ("Husholdningernes formueindkomst<br> af Netto beholdning af<br> øvrige fordringer (vHhAktRenter[Bank])", "Households net income from inventory<br> of other receivables (vHhAktRenter[Bank])", lambda s: s.vHhAktRenter["Bank"]/s.vBNP, "pq"),
    ("Omvurderinger på husholdningernes<br> finansielle nettoformue af<br> obligationer (vHhAktOmv[Obl])", "Reassessment of households gross assets <br> of foreign stocks (vHhAktOmv[Obl])", lambda s: s.vHhAktOmv["Obl"]/s.vBNP, "pq"),
    ("Omvurderinger på husholdningernes<br> finansielle nettoformue af brutto beholdning<br> af danske aktier (vHhAktOmv[IndlAktier])", "Reassessment of households gross assets <br> of domestic stocks (vHhAktOmv[IndlAktier])", lambda s: s.vHhAktOmv["IndlAktier"]/s.vBNP, "pq"),


    ("Omvurderinger på husholdningernes<br> finansielle nettoformue af brutto beholdning<br> af udenlandske aktier (vHhAktOmv[UdlAktier])", "Reassessment of households gross stock<br> of foreign assets (vHhAktOmv[UdlAktier])", lambda s: s.vHhAktOmv["UdlAktier"]/s.vBNP, "pq"),
    ("Omvurderinger på husholdningernes<br> finansielle nettoformue af netto pensionsformue<br> (vHhAktOmV[Pens])", "Reassessment of households net stock<br> of pensions (vHhAktOmV[Pens])", lambda s: s.vHhAktOmv["Pens"]/s.vBNP, "pq"),
    ("Omvurderinger på husholdningernes<br> finansielle nettoformue af Netto beholdning<br> af øvrige fordringer (vHhAktOmv[Bank])", "Reassessment of households net stock of <br> of other receivables (vHhAktOmv[Bank])", lambda s: s.vHhAktOmv["Bank"]/s.vBNP, "pq"),
]

ekstra_figures = [
    ("ikkebolig-forbrugs andel af indkomst<br> (vC/(vHhind + vHhxAfk))", "non-housing consumption share <br>  of income (vC/(vHhind + vHhxAfk))", lambda s: s.vC["Cx"] /(s.vHhInd["tot"] + s.vHhxAfk["tot"] ) , "pm"),
    ("Bolig-forbrugs / indkomst ratio <br> (vBolig/(vHhind + vHhxAfk))", "housing consumption - income ratio <br> (vC/(vHhind + vHhxAfk))", lambda s: s.vBolig["tot"] /(s.vHhInd["tot"] + s.vHhxAfk["tot"] ) , "pm"),
    ("Formue (eksl.bolig m.m) / indkomst ratio<br> (vHhx/(vHhind + vHhxAfk))", "Wealth(excl. housing etc.)-income ratio (vHhx/(vHhind + vHhxAfk))", lambda s: s.vHhx["tot"] /(s.vHhInd["tot"] + s.vHhxAfk["tot"] ) , "pm"),

    ("Formue - indkomst ratio", "Wealth - income ratio", lambda s: (s.vHhFormue["tot"] + s.vHhAkt["Pens", "tot"])/(s.vHhInd["tot"] + s.vHhxAfk["tot"]), "pm"),
    *[(f"Time-produktivitet i branche {s_el} (BVT/hL)", f"Hourly Productivity in sector {s_el} (BVT/hL)", create_getter_func_ratio(s_el, s_el, "qBVT", "hL"), "pq") for s_el in r.s],
    # ("", "", lambda s: s.qBNP*0, ""),

    # ("", "", lambda s: s.qBNP*0, ""),
    # ("", "", lambda s: s.qBNP*0, ""),
    # ("", "", lambda s: s.qBNP*0, ""),

    # ("", "", lambda s: s.qBNP*0, ""),
    # ("", "", lambda s: s.qBNP*0, ""),
    # ("", "", lambda s: s.qBNP*0, ""),

    # ("", "", lambda s: s.qBNP*0, ""),
    *[(f"Kapital-output ratio af type {k_el} <br> i branche {s_el} (qK/qBVT)", f"Capital-output ratio of type {k_el} <br> in sector {s_el} (qK/qBVT)", create_getter_func_ratio((k_el, s_el), s_el, "qK", "qBVT"), "pm") for k_el in r.k for s_el in r.s],
    # ("", "", lambda s: s.qBNP*0, ""),

    # ("", "", lambda s: s.qBNP*0, ""),
    # ("", "", lambda s: s.qBNP*0, ""),
    # ("", "", lambda s: s.qBNP*0, ""),

    # ("", "", lambda s: s.qBNP*0, ""),
    # ("", "", lambda s: s.qBNP*0, ""),
    # ("", "", lambda s: s.qBNP*0, ""),

    # ("", "", lambda s: s.qBNP*0, ""),
    # ("", "", lambda s: s.qBNP*0, ""),
    # ("", "", lambda s: s.qBNP*0, ""),

    # ("", "", lambda s: s.qBNP*0, ""),
    # ("", "", lambda s: s.qBNP*0, ""),
    # ("", "", lambda s: s.qBNP*0, ""),

    # ("", "", lambda s: s.qBNP*0, ""),
    # ("", "", lambda s: s.qBNP*0, ""),
    # ("", "", lambda s: s.qBNP*0, ""),

    # ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),

    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),
]

def sector_plot(sector):
    """ Create a list of plots for a given sector"""
    return [
        (f"BVT i branche {sector}", "", lambda s: s.qBVT[sector], "pq"),
        (f"Beskæftigelse i branche {sector}", "", lambda s: s.nL[sector], "pq"),
        (f"Maskinkapital-output ratio i branche {sector}", "", lambda s: s.qK["iM",sector]/s.qBVT[sector], "pm"),
        
        (f"Bygningskapital-output ratio i branche {sector}", "", lambda s: s.qK["iB",sector]/s.qBVT[sector], "pm"),
        (f"Maskinkapital i branche {sector}", "", lambda s: s.qK["iM",sector], "pq"),
        (f"Bygningskapital i branche {sector}", "", lambda s: s.qK["iB",sector], "pq"),

        (f"Usercost af arbejdskraft i branche {sector}", "", lambda s: s.pL[sector], "pq"),
        (f"Usercost af maskinkapital i branche {sector}", "", lambda s: s.pK["iM", sector], "pq"),
        (f"Usercost af bygningskapital i branche {sector}", "", lambda s: s.pK["iB", sector], "pq"),

        (f"Produktionsdeflator i branche {sector}", "", lambda s: s.pY[sector], "pq"),
        (f"Strukturel beskæftigelse i branche {sector}", "", lambda s: s.snL[sector], "pq"),
        (f"Time-produktivitet i branche {sector} (BVT/hL)", "", lambda s: s.qBVT[sector]/s.hL[sector], "pq"),

        ("", "", lambda s: s.qBNP*0, ""),
        ("", "", lambda s: s.qBNP*0, ""),
        ("", "", lambda s: s.qBNP*0, ""),

        ("", "", lambda s: s.qBNP*0, ""),
        ("", "", lambda s: s.qBNP*0, ""),
        ("", "", lambda s: s.qBNP*0, ""),
    ]

def create_plot_frame(database_dict, variable,element_set, operator, ref_base, denom_var, denom_index, lump_group):
    """ Create a plot frame for a given variable and element set"""
    # Get list of set elements from reference database
    columns = list(ref_base[element_set]) # Not very elegant solution
    # Get database names
    database_names = list(database_dict.keys())
    # get time as list
    time = range(dt.START_YEAR, dt.END_YEAR + 1)
    # Create multiindex with time and database
    multiindex = pd.MultiIndex.from_product([database_names, time], names = ["database", "t"])

    # Create empty dataframe with columns for time, database and value for given variable
    if lump_group is None:
        df = pd.DataFrame(columns = columns, index = multiindex)
    else:
        for element in lump_group:
            columns.remove(element)
        df = pd.DataFrame(columns = columns + ["Others"], index = multiindex)
    # Loop over databases
    for data_name in database_names:
        # Get database
        database = database_dict[data_name]
        # Create list of getter functions for each element in element set

        if denom_var is None:
            getter_funcs = [create_getter_func(element, variable)  for element in columns]
        else:
            getter_funcs = [create_getter_func_ratio(element, denom_index, variable, denom_var)  for element in columns]

        if lump_group is not None:
            # add getter function for lump group
            if denom_var is None:
                getter_func = create_getter_func_sum(variable, lump_group)
            else:
                getter_func = create_getter_func_sum_ratio(variable, lump_group, denom_var, denom_index)
            getter_funcs.append(getter_func)
            columns_final = columns + ["Others"]
        else:
            columns_final = columns

        # Loop over getter functions and names
        for getter, name in zip(getter_funcs, columns_final):
            # Get series of values and flatten to 1d array
            series = np.array(dt.DataFrame(database, operator, getter)).flatten()
            # Set values in dataframe
            df.loc[(data_name, slice(None)), name] = series

    return df

def plot_groups(database_dict, operator, variable, set, ref_base, title, denom_var = None, denom_index = None, lump_group = None):
    """ Function for plotting select groups across databases in the same figure"""
    # Create plot frame
    df = create_plot_frame(database_dict, variable,set, operator, ref_base, denom_var=denom_var, denom_index=denom_index, lump_group = lump_group)
    # Get groups
    groups = list(ref_base[set])
    # remove lump group from groups
    if lump_group is not None:
        for element in lump_group:
            groups.remove(element)
        groups = groups + ["Others"]

    # Get database names
    database_names = list(database_dict.keys())

    # dash options
    dash_options = ['solid', 'dot', 'dash', 'longdash', 'dashdot', 'longdashdot']
    # color options
    colors = ['#636EFA', '#EF553B', '#00CC96', '#AB63FA', '#FFA15A', '#19D3F3', '#FF6692', '#B6E880', '#FF97FF', '#FECB52']
    # Create figure
    fig = go.Figure()
    fig.update_layout(title_text=title)
    # color_counter
    i = 0
    for group in groups:
        # style counter
        j = 0
        for name in database_names:
            # Get line type
            line_type = dash_options[j]
            color = colors[i]
            fig.add_trace(go.Scatter(x=df.index.droplevel(0), y=df[group].loc[name,:], mode='lines', name=name + " " + group, ))
            fig.update_traces(line=dict(dash=line_type, color=color), selector=dict(name=name + " " + group))
            j+=1 
        i+=1
    return fig


def age_profiles(database_dict, variable, years, title):
    fig = dt.age_figure_2d([bank[variable] for name, bank in database_dict.items()],
                        names = [name for name in database_dict.keys()], 
                           years = years,
                        start_age=18,
                        yaxis_title = "DKK mil.",
                           )
    fig.update_layout(title_text=title)
    return fig




