"""
List of shocks to plot. Each tuple contains: 
(
    <Name of of the gdx file of the shock>,
    <A label for the shock in Danish>,
    <A label for the shock in English>,
    <A tuple with infomation about a variable to plot specifically for this shock>,
)
"""
shock_info = [
  # Offentlige udgifter
    ("Offentligt_forbrug", "Offentligt forbrug", "Government consumption",
        ("Offentligt forbrug (qG)", "Government consumption (qG)", lambda s: s.qG, "pq")),
    ("Offentlig_varekoeb", "Offentlige varekøb", "Government purchases",
        ("Offentlige varekøb (qR[off])", "Government purchases (qR[off])", lambda s: s.qR["off"], "pq")),
    ("Offentlig_Beskaeftigelse", "Offentlig beskæftigelse", "Government employment",
        ("Offentlig beskæftigelse<br>(hL[off])", "Government employment<br>(hL[off])", lambda s: s.hL["off"], "pq")),
    ("Offentlig_loen", "Offentlig løn", "Government wages",
        ("Offentlig løn<br>(vLoensum[off] / hL[off])", "Government wages<br>(vLoensum[off] / hL[off])", lambda s: s.vLoensum["off"] / s.hL["off"], "pq")),
    ("Offentlige_investeringer", "Offentlige investeringer", "Public investments",
        ("Offentlige investeringer<br>(qI_s[iTot,off])", "Public investments (qI_s[iTot,off])", lambda s: s.qI_s["iTot","off"], "pq")),
    ("Skattepligtig_indkomstoverforsel", "Skattepligtige overførselsindkomster", "Taxable transfer incomes",
        (" "*4, lambda s: s.qBNP*0, "")),
        # ("Skattepligtige indkomsteroverførsler<br>(∑vOvf[!ubeskat])", "Taxable transfer incomes<br>(∑vOvf[!ubeskat])", lambda s: s.vOvf[s.ovf].groupby("t").sum() - s.vOvf[s.ubeskat].groupby("t").sum(), "pq")),
    ("Ikke_skattepligtig_indkomstoverforsel", "Ikke-skattepligtige overførselsindkomster", "Non-taxable transfer incomes",
        # ("Ikke-skattepligtige indkomsteroverførsler<br>(∑vOvf[ubeskat])", "Non-taxable transfer incomes<br>(∑vOvf[ubeskat])", lambda s: s.vOvf[s.ubeskat].groupby("t").sum(), "pq")),
        (" "*5, lambda s: s.qBNP*0, "")),
  # Subsidier
    ("Produktsubsidier", "Produktsubsidier", "Product subsidies",
        ("Produktsubsidier (vPunktSub)", "Product subsidies (vPunktSub)", lambda s: s.vPunktSub, "pq")),
    ("Lontilskud", "Løntilskud", "Wage subsidies",
        ("Løntilskud (vtLoenSub)", "Wage subsidies (vtLoenSub)", lambda s: s.vtLoenSub, "pq")),
    ("Produktionssubsidier", "Produktionssubsidier ekskl. løntilskud", "Production subsidies excl. wage subsidies",
        ("Produktionssubsidier<br>ekskl. løntilskud (vSubYRes)", "Production subsidies<br>excl. wage subsidies (vSubYRes)", lambda s: s.vSubYRes, "pq")),
    ("Overforsel_privat", "Øvrige overførsler til husholdninger", "Other transfers to households",
        ("Øvrige overførsler til husholdninger<br>(vOffTilHhRest)", "Other transfers to households<br>(vOffTilHhRest)", lambda s: s.vOffTilHhRest, "pq")),

  # Skatter
    ("Bundskat", "Bundskat", "Income taxes (bundskat)",
        ("Bundskat (tBund)", "Income tax rate (tBund)", lambda s: s.tBund, "pm")),
    ("AM_bidrag", "AM-bidrag", "Labor market contributions (AM-bidrag)",
        ("AM-bidrag (tAMbidrag)", "Labor market contributions<br>(tAMbidrag)", lambda s: s.tAMbidrag, "pm")),
    ("Grundskyld", "Grundskyld", "Land taxes (grundskyld)",
        ("Grundskyld (tK[iB])", "Land taxes (tK[iB])", lambda s: s.tK["iB"], "pm")),
    ("Ejendomsvaerdiskat", "Ejendomsværdiskat", "Property taxes (ejendomsværdiskat)",
        ("Ejendomsværdiskat (tEjd)", "Property taxes (tEjd)", lambda s: s.tEjd, "pm")),
    ("Vaegtafgift", "Vægtafgift", "Vehicle excise duty (vægtafgift)",
        ("Vægtafgifter (vtHhVaegtSats)", "Vehicle excise duties (vtHhVaegtSats)", lambda s: s.vtHhVaegtSats, "pq")),
    ("Selskabsskat", "Selskabsskat", "Corporate income tax (selskabsskat)",
        ("Selskabsskat (tSelskab)", "Corporate income tax (tSelskab)", lambda s: s.tSelskab, "pm")),
    ("Aktieskat", "Aktieskat", "Dividend and capital gains tax (aktieskat)",
        ("Aktieskat (tAktie)", "Dividend and capital gains tax<br>(tAktie)", lambda s: s.tAktie, "pm")),
    ("Moms", "Moms", "VAT",
        ("Moms-provenue (vtMoms)", "VAT revenue (vtMoms)", lambda s: s.vtMoms, "pq")),
    ("Registreringsafgift", "Registreringsafgift til privat forbrug", "Household vehicle registration tax",
        ("Registreringsafgift (tReg[cBil])", "Household vehicle registration tax<br>(tReg[cBil])", lambda s: s.tReg["cBil"], "pm")),
    ("Energiafgift", "Energiafgift til privat forbrug", "Household energy taxes",
        ("Energiafgifter til privat forbrug<br>(vtAfg[cEne])", "Household energy taxes<br>(vtAfg[cEne])", lambda s: s.vtAfg["cEne"], "pq")),
    ("Forbrugsafgift", "Øvrige forbrugsafgifter", "Other consumption taxes",
        ("Afgifter på privat vare-forbrug<br>(vtAfg[cVar])", "Duties on other consumption goods<br>(vtAfg[cVar])", lambda s: s.vtAfg["cVar"], "pq")),
    ("Afgift_erhverv", "Afgift på private erhvervs materialeinput", "Duties on intermediate goods",
        ("Afgift på private erhvervs<br>materialeinput (vtAfg[rTot,spTot])", "Duties on intermediate goods<br>(vtAfg[rTot,spTot])", lambda s: s.vtAfg["tot"]["spTot"], "pq")),

  # Udland
    ("Eksportmarkedsvaekst", "Eksportmarkedsvækst", "Export market growth",
        ("Eksportmarkedsindeks<br>(qXMarked)", "Export market index<br>(qXMarked)", lambda s: s.qXMarked, "pq")),
    ("Importpris", "Importpris", "Import prices",
        ("Importpriser (pM)", "Import prices", lambda s: s.pM, "pq")),
    ("Eksportkonkurrerende_priser", "Eksportkonkurrerende priser", "Export-competing prices",
        ("Eksportkonkurrerende priser<br>(pXUdl)", "Export-competing prices", lambda s: s.pXUdl, "pq")),
    ("Oliepris", "Oliepris", "Oil prices",
        ("Oliepris (pOlie)", "Oil price (pOlie)", lambda s: s.pOlie, "pq")),
    ("Udenlandske_priser", "Udenlandske priser (trægt gennemslag)", "Foreign prices (sluggish pass-through)",
        ("Importpriser (pM)", "Import prices (pM)", lambda s: s.pM, "pq")),
    ("Udenlandske_priser_exo", "Udenlandske priser (øjeblikkeligt gennemslag)", "Foreign prices (instant pass-through)",
        ("Importpriser (pM)", "Import prices (pM)", lambda s: s.pM, "pq")),
    ("Rente", "Rente", "Interest rate",
        ("Rente (rRenteECB)", "Interest rate (rRenteECB)", lambda s: s.rRenteECB, "pm")),

  # Øvrige udbudsstød
    ("Arbejdsudbud", "Arbejdsudbud", "Labor supply",
        ("Strukturel bruttoarbejdsstyrke<br>(snBruttoArbsty)", "Structural labor force<br>(snBruttoArbsty)", lambda s: s.snBruttoArbsty, "pq")),
    ("Befolkning", "Befolkning", "Population",
        ("Befolkning (nPop)", "Population (nPop)", lambda s: s.nPop, "pq")),
    ("Produktivitet", "Produktivitet", "Productivity",
        ("Arbejdskraftbesparende teknologi<br>(qProd)", "Labor saving technology<br>(qProd)", lambda s: s.qProd, "pq")),

  # Risikopræmier
  ("VirkDisk", "Virksomhedernes hurdle rates", "Firm hurdle rates",
    ("Virksomhedernes hurdle rate<br>(rVirkDisk)", "Firm hurdle rates<br>(rVirkDisk)", lambda s: s.rVirkDisk, "pm")),
  ("BoligRisiko", "Risiko-præmie i usercost på bolig", "Risk premium in usercost of housing",
    ("Risiko-præmie i usercost på bolig<br>(rBoligPrem)", "Risk premium in usercost of housing<br>(rBoligPrem)", lambda s: s.rBoligPrem, "pm")),
  ("AktieAfkast", "Virksomhedernes hurdle rates og aktieafkastrater", "Firm hurdle rates and equity risk premia",
    ("Risiko-præmie i aktieafkast<br>(rIndlAktiePrem)", "Risk premium in equity returns<br>(rIndlAktiePrem)", lambda s: s.rIndlAktiePrem, "pm")),
  ("RisikoPraemier", "Risikopræmier på aktier og bolig, og virksomhedens hurdle rates", "Risk premia on equities and housing, and firm hurdle rates",
    ("Risiko-præmie i aktieafkast<br>(rIndlAktiePrem)", "Risk premium in equity returns<br>(rIndlAktiePrem)", lambda s: s.rIndlAktiePrem, "pm")),
]

shock_names, shock_labels_DA, shock_labels_EN, shock_specific_plot_info = [list(t) for t in zip(*shock_info)]
