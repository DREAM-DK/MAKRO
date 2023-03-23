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
figure_info = [
    # Page 1
    ("Offentligt forbrug (qG)", "Government consumption (qG)", lambda s: s.qG, "pq"),
    ("BVT (qBVT)", "Gross value added (qBVT)", lambda s: s.qBVT, "pq"),
    ("Beskæftigelse (nL)", "Employment (nL)", lambda s: s.nL, "pq"),

    ("Privat forbrug (qC)", "Private consumption (qC)", lambda s: s.qC, "pq"),
    ("Eksport (qXy)", "Exports (qXy)", lambda s: s.qXy, "pq"),
    ("Import (qM)", "Imports (qM)", lambda s: s.qM, "pq"),

    ("Private maskininvesteringer<br>(qI_s[IM,spTot])", "Private machine investments<br>(qI_s[IM,spTot])", lambda s: s.qI_s["iM","spTot"], "pq"),
    ("Erhvervs-bygningsinvesteringer<br>(qI_s[IB,spTot])", "Commercial building investments<br>(qI_s[IB,spTot])", lambda s: s.qI_s["iB","spTot"], "pq"),
    ("Boliginvesteringer (qI_s[IB,bol])", "Housing investments (qI_s[IB,bol])", lambda s: s.qI_s["iB","bol"], "pq"),

    ("BVT-deflator (pBVT)", "Prices index, GrossValueAdded<br>(pBVT)", lambda s: s.pBVT, "pq"),
    ("Nominelle lønninger (vhW)", "Nominal wages (vhW)", lambda s: s.vhW, "pq"),
    ("Boligpriser (pBolig)", "Housing prices (pBolig)", lambda s: s.pBolig, "pq"),

    ("Primær saldo, andel af BNP<br>(vPrimSaldo / vBNP)", "Primary budget surplus, share of GDP<br>(vPrimSaldo / vBNP)", lambda s: s.vPrimSaldo / s.vBNP, "pm"),
    ("Netto-fordrings-erhvervelse<br>for husholdninger (vHhNFE)", "Change in net worth<br>of households (vHhNFE)", lambda s: s.vHhNFE, "pq"),
    ("Netto-fordrings-erhvervelse<br>for virksomheder (vVirkNFE)", "Change in net worth<br>of firms (vVirkNFE)", lambda s: s.vVirkNFE, "pq"),

    ("Bruttoledighedsgrad<br>(nBruttoLedig/nBruttoArbsty)", "Unemployment rate<br>(nBruttoLedig/nBruttoArbsty)", lambda s: s.nBruttoLedig / s.nBruttoArbsty, "pq"),
    ("Outputgab (qBVT/sqBVT-1)", "Output gap (qBVT/sqBVT-1)", lambda s: s.qBVT/s.sqBVT-1, ""),
    ("Beskæftigelsesgab (nL/snL-1)", "Employment gap (nL/snL-1)", lambda s: s.nL/s.snL-1, ""),

    # Page 2
    ("Beskæftigelse (nL)", "Employment (nL)", lambda s: s.nL, "pq"),
    ("Offentlig beskæftigelse (nL[off])", "Public sector employment<br>(nL[off])", lambda s: s.nL["off"], "pq"),
    ("Privat beskæftigelse (nL[spTot])", "Private sector employment<br>(nL[spTot]", lambda s: s.nL["spTot"], "pq"),

    ("BVT-deflator (pBVT)", "Price indexindex, GrossValueAdded<br>(pBVT)", lambda s: s.pBVT, "pq"),
    ("Forbrugerpriser (pC)", "Consumer prices (pC)", lambda s: s.pC, "pq"),
    ("Eksportpriser (pXy)", "Export prices (pX)", lambda s: s.pXy, "pq"),

    ("Maskinkapital/Produktion<br>(qK[IM,sByTot]/qY[sByTot])", "Equipment / output<br>(qK[IM,sByTot]/qY[sByTot])",
        lambda s: s.qK["iM","sByTot"] / s.qY["sByTot"], "pm"),
    ("Bygningskapital/Produktion<br>(qK[IB,sByTot]/qY[sByTot])", "Structures / output<br>(qK[IB,sByTot]/qY[sByTot])",
        lambda s: s.qK["iB","sByTot"] / s.qY["sByTot"], "pm"),
    ("Arbejdskraft/Produktion<br>(qL[sByTot]/qY[sByTot])", "Labor / output<br>(qL[sByTot]/qY[sByTot])",
        lambda s: s.qL["sByTot"] / s.qY["sByTot"], "pm"),

    ("Relativ pris på maskinkapital<br>(pK[IM,sByTot]/pBVT[sByTot])", "Relative price of equipment<br>(pK[IM,sByTot]/pBVT[sByTot])",
        lambda s: s.pK["iM","sByTot"] / s.pBVT["sByTot"], "pm"),
    ("Relativ pris på bygningskapital<br>(pK[IB,sByTot]/pBVT[sByTot])", "Relative price of structures<br>(pK[IB,sByTot]/pBVT[sByTot])",
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