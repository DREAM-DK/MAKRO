import dreamtools as dt

"""
List of tuples each containing information about a variable to plot
(
    <label for variable in Danish>,
    <label for variable in English>,
    <function to extract variable from a gdx file>,
    <multiplier type (operator) if plotting a shock>,
)
"""
page_1_figures = [
    (None, None, None, None), # The first tuple is left empty, to be replaced with a shock specific subplot
    ("BVT (qBVT)", "Gross value added (qBVT)", lambda s: s.qBVT, "pq"),
    ("Beskæftigelse (nL)", "Employment (nL)", lambda s: s.nL, "pq"),

    ("Privat forbrug (qC)", "Private consumption (qC)", lambda s: s.qC, "pq"),
    ("Eksport (qXy)", "Exports (qXy)", lambda s: s.qXy, "pq"),
    ("Import (qM)", "Imports (qM)", lambda s: s.qM, "pq"),

    ("Private maskininvesteringer<br>(qI_s[iM,spTot])", "Private machine investments<br>(qI_s[iM,spTot])", lambda s: s.qI_s["iM","spTot"], "pq"),
    ("Erhvervs-bygningsinvesteringer<br>(qI_s[iB,spTot])", "Commercial building investments<br>(qI_s[iB,spTot])", lambda s: s.qI_s["iB","spTot"], "pq"),
    ("Boliginvesteringer (qI_s[iB,bol])", "Housing investments (qI_s[iB,bol])", lambda s: s.qI_s["iB","bol"], "pq"),

    ("BVT-deflator (pBVT)", "Prices index, GrossValueAdded<br>(pBVT)", lambda s: s.pBVT, "pq"),
    ("Nominelle lønninger (vhW)", "Nominal wages (vhW)", lambda s: s.vhW, "pq"),
    ("Boligpriser (pBolig)", "Housing prices (pBolig)", lambda s: s.pBolig, "pq"),

    ("Primær saldo, andel af BNP<br>(vPrimSaldo / vBNP)", "Primary budget surplus, share of GDP<br>(vPrimSaldo / vBNP)", lambda s: s.vPrimSaldo / s.vBNP, "pm"),
    ("Netto-fordrings-erhvervelse<br>for husholdninger (vHhNFE)", "Change in net worth<br>of households (vHhNFE)", lambda s: s.vHhNFE, "pq"),
    ("Netto-fordrings-erhvervelse<br>for virksomheder (vVirkNFE)", "Change in net worth<br>of firms (vVirkNFE)", lambda s: s.vVirkNFE, "pq"),

    ("Bruttoledighedsgrad<br>(nBruttoLedig/nBruttoArbsty)", "Unemployment rate<br>(nBruttoLedig/nBruttoArbsty)", lambda s: s.nBruttoLedig / s.nBruttoArbsty, "pq"),
    ("Outputgab (qBVT / sqBVT)", "Output gap (qBVT / sqBVT)", lambda s: s.qBVT / s.sqBVT, "pm"),
    ("Beskæftigelsesgab (nL / snL)", "Employment gap (nL / snL)", lambda s: s.nL / s.snL, "pq"),
]

page_2_figures = [
    ("Beskæftigelse (nL)", "Employment (nL)", lambda s: s.nL, "pq"),
    ("Offentlig beskæftigelse (nL[off])", "Public sector employment<br>(nL[off])", lambda s: s.nL["off"], "pq"),
    ("Privat beskæftigelse (nL[spTot])", "Private sector employment<br>(nL[spTot]", lambda s: s.nL["spTot"], "pq"),

    ("BVT-deflator (pBVT)", "Price indexindex, GrossValueAdded<br>(pBVT)", lambda s: s.pBVT, "pq"),
    ("Forbrugerpriser (pC)", "Consumer prices (pC)", lambda s: s.pC, "pq"),
    ("Eksportpriser (pXy)", "Export prices (pX)", lambda s: s.pXy, "pq"),

    ("Maskinkapital/Produktion<br>(qK[iM,sByTot]/qY[sByTot])", "Equipment / output<br>(qK[iM,sByTot]/qY[sByTot])",
        lambda s: s.qK["iM","sByTot"] / s.qY["sByTot"], "pm"),
    ("Bygningskapital/Produktion<br>(qK[iB,sByTot]/qY[sByTot])", "Structures / output<br>(qK[iB,sByTot]/qY[sByTot])",
        lambda s: s.qK["iB","sByTot"] / s.qY["sByTot"], "pm"),
    ("Arbejdskraft/Produktion<br>(qL[sByTot]/qY[sByTot])", "Labor / output<br>(qL[sByTot]/qY[sByTot])",
        lambda s: s.qL["sByTot"] / s.qY["sByTot"], "pm"),

    ("Relativ pris på maskinkapital<br>(pK[iM,sByTot]/pBVT[sByTot])", "Relative price of equipment<br>(pK[iM,sByTot]/pBVT[sByTot])",
        lambda s: s.pK["iM","sByTot"] / s.pBVT["sByTot"], "pm"),
    ("Relativ pris på bygningskapital<br>(pK[iB,sByTot]/pBVT[sByTot])", "Relative price of structures<br>(pK[iB,sByTot]/pBVT[sByTot])",
        lambda s: s.pK["iB","sByTot"] / s.pBVT["sByTot"], "pm"),
    ("Relativ pris på arbejdskraft<br>(pL[sByTot]/pBVT[sByTot])", "Relative price of labor<br>(pL[sByTot]/pBVT[sByTot])",
        lambda s: s.pL["sByTot"] / s.pBVT["sByTot"], "pm"),

    ("Skatte-reaktion (tLukning)", "Tax reaction (tLukning)", lambda s: s.tLukning, "pm"),
    ("", "", lambda s: s.qBNP*0, ""),
    ("", "", lambda s: s.qBNP*0, ""),

    ("Inflation (pBVT)", "Inflation<br>(pBVT)", lambda s: s.pBVT / dt.lag(s.pBVT) * s.fp - 1, "pm"),
    ("Løn-inflation (vhW)", "Wage inflation<br>(vhW)", lambda s: s.vhW / dt.lag(s.vhW) * s.fp - 1, "pm"),
    ("", "", lambda s: s.qBNP*0, ""),
]

public_production_figures = [
    ("Offentlig produktion (qY[off])", "Public production (qY[off])", lambda s: s.qY["off"], "pq"),
    ("Offentlig BVT (qBVT[off])", "Public gross value added (qBVT[off])", lambda s: s.qBVT["off"], "pq"),
    ("Offentligt forbrug (qG)", "Government consumption (qG)", lambda s: s.qC, "pq"),

    ("Deflator for offentlig produktion (pY[off])", "Public production price index (pY[off])", lambda s: s.pY["off"], "pq"),
    ("Deflator for offentlig BVT (pBVT[off])", "Public gross value added price index (pBVT[off])", lambda s: s.pBVT["off"], "pq"),
    ("Deflator for offentligt forbrug (pG)", "Government consumption price index (pG)", lambda s: s.pC, "pq"),

    ("Offentlig beskæftigelse i hoveder (nL[off])", "Public employment, headcount (nL[off])", lambda s: s.nL["off"], "pq"),
    ("Offentlig beskæftigelse i timer (hL[off])", "Public employment, hours (hL[off])", lambda s: s.hL["off"], "pq"),
    ("Offentlig beskæftigelse i produktivitetsenheder (qProd[off] * hL[off])", "Public employment, produvtivity units (qProd[off] * hL[off])", lambda s: s.qProd["off"] * s.hL["off"], "pq"),

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

figure_info = [
    *page_1_figures,
    # *page_2_figures,
    # *public_production_figures,
]

variable_labels_DK, variable_labels_EN, get_variable_functions, operators = [list(t) for t in zip(*figure_info)]

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

variable_labels_DK = append_spaces_to_make_unique(variable_labels_DK)
variable_labels_EN = append_spaces_to_make_unique(variable_labels_EN)