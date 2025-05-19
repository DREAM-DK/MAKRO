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
    ("Off_vare_FM", "Offentlige varekøb", "Government purchases",
        ("Offentlige varekøb (qR[off])", "Government purchases (qR[off])", lambda s: s.qR["off"], "pq")),
    ("Off_besk_FM", "Offentlig beskæftigelse", "Government employment",
        ("Offentlig beskæftigelse<br>(hL[off])", "Government employment<br>(hL[off])", lambda s: s.hL["off"], "pq")),
    ("Off_lon_FM", "Offentlig løn", "Government wages",
        ("Offentlig løn<br>(vLoensum[off] / hL[off])", "Government wages<br>(vLoensum[off] / hL[off])", lambda s: s.vLoensum["off"] / s.hL["off"], "pq")),
    ("Off_inv_FM", "Offentlige investeringer", "Public investments",
        ("Offentlige investeringer<br>(qI_s[iTot,off])", "Public investments (qI_s[iTot,off])", lambda s: s.qI_s["iTot","off"], "pq")),
    ("Skattepligtig_indkomstoverforsel_FM", "Skattepligtige overførselsindkomster", "Taxable transfer incomes",
        ("Skattepligtige indkomsteroverførsler<br>(vOvf)", "Taxable transfer incomes<br>(vOvf)", lambda s: s.vOvf["HhTot"], "pq")),
    ("Ikke_skattepligtig_indkomstoverforsel_FM", "Ikke-skattepligtige overførselsindkomster", "Non-taxable transfer incomes",
        ("Ikke-skattepligtige indkomsteroverførsler<br>(vOvf)", "Non-taxable transfer incomes<br>(vOvf)", lambda s: s.vOvf["HhTot"], "pq")),
  # Subsidier
    ("Varefordelt_subsidie_FM", "Produktsubsidier", "Product subsidies",
        ("Produktsubsidier (vSub[dTot,tot])", "Product subsidies (vSub[dTot,tot])", lambda s: s.vSub["dTot","tot"], "pq")),
    ("Lontilskud_FM", "Løntilskud", "Wage subsidies",
        ("Løntilskud (vSubLoen)", "Wage subsidies (vSubLoen)", lambda s: s.vSubLoen, "pq")),
    ("Produktionssubsidie_FM", "Produktionssubsidier ekskl. løntilskud", "Production subsidies excl. wage subsidies",
        ("Produktionssubsidier<br>ekskl. løntilskud (vSubYRest)", "Production subsidies<br>excl. wage subsidies (vSubYRest)", lambda s: s.vSubYRest, "pq")),

  # Skatter
    ("Bundskat_FM", "Bundskat", "Income taxes (bundskat)",
        ("Bundskat (tBund)", "Income tax rate (tBund)", lambda s: s.tBund, "pm")),
    ("AM_bidrag_FM", "AM-bidrag", "Labor market contributions (AM-bidrag)",
        ("AM-bidrag (tAMbidrag)", "Labor market contributions<br>(tAMbidrag)", lambda s: s.tAMbidrag, "pm")),
    ("Ejendomsskat_FM", "Ejendomsskat", "Property taxes (ejendomsskat)",
        ("Ejendomsskat (tK[iB])", "Property taxes (tK[iB])", lambda s: s.tK["iB"], "pm")),
    ("Vaegtafgift_FM", "Vægtafgift", "Vehicle excise duty (vægtafgift)",
        ("Vægtafgifter (utHhVaegt)", "Vehicle excise duties (utHhVaegt)", lambda s: s.utHhVaegt, "pq")),
    ("Selskabsskat_FM", "Selskabsskat", "Corporate income tax (selskabsskat)",
        ("Selskabsskat (tSelskab)", "Corporate income tax (tSelskab)", lambda s: s.tSelskab, "pm")),
    ("Aktieskat_FM", "Aktieskat", "Dividend and capital gains tax (aktieskat)",
        ("Aktieskat (tAktie)", "Dividend and capital gains tax<br>(tAktie)", lambda s: s.tAktie, "pm")),
    ("Moms_FM", "Moms", "VAT",
        ("Moms-provenue (vtMoms)", "VAT revenue (vtMoms)", lambda s: s.vtMoms, "pq")),
    ("Registreringsafgift_FM", "Registreringsafgift til privat forbrug", "Household vehicle registration tax",
        ("Registreringsafgift (tReg_y & tReg_m)", "Household vehicle registration tax<br>(tReg_y & tReg_m)", lambda s: s.tReg_y["cBil"]["fre"], "pm")),
    ("Energiafgift_FM", "Energiafgift til privat forbrug", "Household energy taxes",
        ("Energiafgifter til privat forbrug<br>(tAfg_y[cEne] & tAfg_m[cEne])", "Household energy taxes<br>(tAfg_y[cEne] & tAfg_m[cEne])", lambda s: s.tAfg_y["cEne"]["ene"], "pm")),
    ("Forbrugsafgift_FM", "Øvrige forbrugsafgifter", "Other consumption taxes",
        ("Afgifter på privat vare-forbrug<br>(tAfg_y[cVar] & tAfg_m[cVar])", "Duties on other consumption goods<br>(tAfg_y[cVar] & tAfg_m[cVar])", lambda s: s.tAfg_y["cVar"]["fre"], "pm")),
    ("Afgift_erhverv_FM", "Afgift på private erhvervs materialeinput", "Duties on intermediate goods",
        ("Afgift på private erhvervs<br>materialeinput (tAfg_y[r,s] & tAfg_m[r,s])", "Duties on intermediate goods<br>(tAfg_y[r,s] & tAfg_m[r,s])", lambda s: s.tAfg_y["fre"]["fre"], "pm")),
    ("Overforsel_privat_FM", "Øvrige overførsler til husholdninger", "Other transfers to households",
        ("Øvrige overførsler til husholdninger<br>(vOffTilHhRest)", "Other transfers to households<br>(vOffTilHhRest)", lambda s: s.vOffTilHhRest, "pq")),
]

shock_names, shock_labels_DA, shock_labels_EN, shock_specific_plot_info = [list(t) for t in zip(*shock_info)]