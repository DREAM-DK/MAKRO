# ======================================================================================================================
# Government aggregation module
# - revenues and expenses are in GovRevenues and GovExpenses respectively
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_government_prices
    empty_group_dummy[t] ""
  ;
  $GROUP G_government_quantities
    empty_group_dummy[t] ""
  ;

  $GROUP G_government_values_endo
    # Renter, formuer og saldo
    vPrimSaldo[t] "Den offentlige sektors primære saldo, Kilde: ADAM[Tfn_o]-ADAM[Tion2]"
    vSaldo[t] "Den offentlige sektors faktiske saldo, Kilde: ADAM[Tfn_o]"

    vOff[portf_,t]$(t.val > 1994 or (sameas['netfin', portf_] and tx0[t])) "Det offentlige sektors finansielle portefølje."
    vOffOmv[t] "Omvurderinger af offentlige aktiver og passiver, Kilde: ADAM[Wn_o]-ADAM[Wn_o][-1]-ADAM[Tfn_o]"

    vOffNetRenter[t] "Den offentlige sektors nettoformueindkomst ekskl. jordrente og overskud af off. virksomhed, Kilde: ADAM[Tion2]"
    vNROffNetRenter[t] "Den offentlige sektors nettoformueindkomst inkl. jordrente og overskud af off. virksomhed, ADAM[Tin_o]"
    vOffRenteInd[t]$(t.val > 1995) "Den offentlige sektors indtægter af formueindkomst på aktivsiden, Kilde: ADAM[Tioii]"
    vOffRenteUd[t]$(t.val > 1995) "Den offentlige sektors udgifter til formueindkomst på passivsiden, Kilde: ADAM[Ti_o_z]"
    vOffNetFormue[t] "Den offentlige sektors nettoformue ekskl. offenlige fonde, Kilde: ADAM[Wosk]"
    vOffPas[t] "Den offentlige sektors passiver ekskl. offentlige fonde, Kilde: ADAM[Wosku]"
    vOffAkt[t] "Den offentlige sektors aktiver ekskl. offentlige fonde, Kilde: ADAM[Woski]"

    vOffY2C[t] "Offentlig sektors salg af varer og tjenester, Kilde: ADAM[Xo1_p]"
    vSatsIndeks[t] "Satsregulering."

    # Strukturelle værdier
    #  svSaldo[t] "Den offentlige sektors strukturelle saldo."
    #  vKonjGab[t] "Konjunkturbidrag til konjunkturgab."
    #  vOevrGab[t] "Øvrige bidrag til konjunkturgab."
  ;

  $GROUP G_government_endo
    G_government_quantities
    G_government_values_endo
    -vOff$(sameas['Guld',portf_] or sameas['BankGaeld',portf_] or sameas['Pens',portf_])
    -vOffAkt[t]

    rOffRenteUd[t]$(t.val > 1995) "Gennemsnitlig rente på offentlig sektors passiver."

    nvBNP[t] "Tilbagediskonteret nutidsværdi af BNP."
    nvPrimSaldo[t] "Tilbagediskonteret nutidsværdi af offentlige finanser."
    nvtLukning[t] "Tilbagediskonteret nutidsværdi af beregningsteknisk skat til lukning af offentlig budgetrestriktion."
    nvGLukning[t] "Tilbagediskonteret nutidsværdi af beregningsteknisk stigning i offentligt forbrug til lukning af offentlig budgetrestriktion."
    rHBI[t] "Holdbarhedsindikator før korrektion ved beregningsmæssig skat til lukning, korrigeret HBI."
    fHBIDisk[t] "Diskonteringsfaktor i rHBI-beregning."

    rOffRenteInd[t]$(t.val > 1995) "Gennemsnitlig rente på offentlig sektors aktiver."
    rOffAkt2BNP[t] "Offentlig sektors aktiver ift. BNP."
  ;
 
  $GROUP G_government_endo 
    G_government_endo$(tx0[t])  # Restrict endo group to tx0[t]
  ;

  $GROUP G_government_values_exo
    vOffFonde[t] "Offentlige fondes finansielle nettoformue."
    vtPALGab[t] "Korrektion for PAL-skat til konjunkturgab."
    vtSelskabNordGab[t] "Korrektion for Nordsø-provenu til konjunkturgab."
    vtSelskabRestGab[t] "Korrektion for anden selskabsskat til konjunkturgab."
    vtRegGab[t] "Korrektion for registreringsafgift  til konjunkturgab."
    vOffNetRenterGab[t] "Korrektion for offentlige rentebetalinger til konjunkturgab."
    vtRestGab[t] "Korrektion for øvrige specielle budgetposter til konjunkturgab."
    vEngangsForholdGab[t] "Korrektion for engangsforhold til konjunkturgab."
  ;
  $GROUP G_government_ARIMA_forecast
    rOffY2C[t] "Offentlig sektors salg af varer og tjenester ift. offentlige forbrug."
    rOffAkt2BNP # Endogen i stødforløb
  ;
  $GROUP G_government_values
    G_government_values_endo
    G_government_values_exo
  ;
  $GROUP G_government_exogenous_forecast
    vOffFonde
  # Forecast_as_zero
    jvOffOmv[t] "J-led."
    jrOffRenteInd[t] "J-led."
    jrOffRenteUd[t] "J-led."
    jfSatsIndeks[t] "J-led."
  ;
  $GROUP G_government_other
    rOffRealKred2Pas[t] "Andel af offentlig gæld som er realkreditlån."
    rOffAkt[akt,t] "Andel af offentlige aktiver fordelt på aktiv type."
    #  esSaldo[t] "Budgetelasticitet for samlet konjunkturfølsomhed."
  ;
$ENDIF

# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_government
# ----------------------------------------------------------------------------------------------------------------------
# Satsregulering
# ----------------------------------------------------------------------------------------------------------------------
    E_vSatsIndeks[t]$(tx0[t])..
      vSatsIndeks[t] =E= vSatsIndeks[t-1]/fv 
                      * (vWHh[aTot,t-2]/nLHh[aTot,t-2]) / (vWHh[aTot,t-3]/nLHh[aTot,t-3]) * fv * (1 + jfSatsIndeks[t]);

# ----------------------------------------------------------------------------------------------------------------------
# Renter, formuer og saldo
# ----------------------------------------------------------------------------------------------------------------------
    E_vPrimSaldo[t]$(tx0[t]).. vPrimSaldo[t] =E= vOffPrimInd[t] - vOffPrimUd[t];
    E_vSaldo[t]$(tx0[t]).. vSaldo[t] =E= vPrimSaldo[t] + vOffNetRenter[t];

    E_vOff_NetFin[t]$(tx0[t]).. vOff['NetFin',t] =E= vOff['NetFin',t-1]/fv + vSaldo[t] + vOffOmv[t];
    E_vOffNetFormue[t]$(tx0[t]).. vOffNetFormue[t] =E= vOff['NetFin',t] - vOffFonde[t];

    E_vOffAkt[t]$(tx0[t]).. vOffAkt[t] =E= rOffAkt2BNP[t] * vBNP[t];
    E_vOffPas[t]$(tx0[t]).. vOffNetFormue[t] =E= vOffAkt[t] - vOffPas[t];

    # Renteindtægter og udgifter inkluderer dem fra offentlige fonde
    E_vOffNetRenter[t]$(tx0[t]).. vOffNetRenter[t] =E= vOffRenteInd[t] - vOffRenteUd[t];
    E_vOffRenteInd[t]$(tx0[t] and t.val > 1995).. vOffRenteInd[t] =E= rOffRenteInd[t] * vOffAkt[t-1]/fv;
    E_vOffRenteUd[t]$(tx0[t] and t.val > 1995).. vOffRenteUd[t] =E= rOffRenteUd[t] * vOffPas[t-1]/fv;

    E_vNROffNetRenter[t]$(tx0[t])..
      vNROffNetRenter[t] =E= vOffNetRenter[t] + vJordrente[t] + vOffVirk[t];

    # Rentesatser (eksklusiv kapitalgevinster)
    E_rOffRenteInd[t]$(tx0[t] and t.val > 1995)..
      rOffRenteInd[t] =E= sum(akt, rOffAkt[akt,t-1] * rRente[akt,t]) + jrOffRenteInd[t];
    E_rOffRenteUd[t]$(tx0[t] and t.val > 1995)..
      rOffRenteUd[t] =E= rOffRealKred2Pas[t-1] * rRente['RealKred',t] 
                       + (1-rOffRealKred2Pas[t-1]) * rRente['Obl',t] + jrOffRenteUd[t];

    # Omvurderinger
    E_vOffOmv[t]$(tx0[t])..
      vOffOmv[t] =E= sum(akt, vOff[akt,t-1]/fv * rOmv[akt,t]) 
                   - sum(pas, vOff[pas,t-1]/fv * rOmv[pas,t]) + jvOffOmv[t];

    # Financial assets are split into portfolio: vOffAkt = vOff[IndlAktier] + vOff[UdlAktier] + vOff[Bank] + vOff[Obl_akt]
    E_vOff_akt[akt,t]$(tx0[t] and (sameas['IndlAktier',akt] or sameas['UdlAktier',akt] or sameas['Bank',akt]) and t.val > 1994)..
      vOff[akt,t] =E= rOffAkt[akt,t] * (vOffAkt[t] + vOffFonde[t]);

    # Fonde har ingen realkreditlån, så her behøver ikke korrigeres
    E_vOff_RealKred[t]$(tx0[t] and t.val > 1994)..
      vOff['RealKred',t] =E= rOffRealKred2Pas[t] * vOffPas[t];

    E_vOff_Obl[t]$(tx0[t] and t.val > 1994)..
      vOff['Obl',t] =E= rOffAkt['Obl',t] * (vOffAkt[t] + vOffFonde[t]) - (1-rOffRealKred2Pas[t]) * vOffPas[t];

# ----------------------------------------------------------------------------------------------------------------------
# Strukturel saldo
# ----------------------------------------------------------------------------------------------------------------------
    #  E_svSaldo[t]$(tx0[t]).. svSaldo[t] =E= vSaldo[t] - vKonjGab[t] - vOevrGab[t];

    #  E_vKonjGab[t]$(tx0[t])..
    #    vKonjGab[t] =E= esSaldo[t] * (0.6 * rBeskGab[t] + 0.4 * rBVTGab[t]) * vBVT[sTot,t];

    #  E_vOevrGab[t]$(tx0[t])..
    #    vOevrGab[t] =E= vtPALGab[t]
    #                  + vtSelskabNordGab[t]
    #                  + vtSelskabRestGab[t]
    #                  + vtRegGab[t]
    #                  + vOffNetRenterGab[t]
    #                  + vtRestGab[t]
    #                  + vEngangsForholdGab[t];

# ----------------------------------------------------------------------------------------------------------------------
# Holdbarheds-indikator
# ---------------------------------------------------------------------------------------------------------------------           
    E_rHBI[t]$(tx0[t])..
      rHBI[t] =E= (nvPrimSaldo[t] + nvGLukning[t] - nvtLukning[t] + vOffNetFormue[t-1]/fv * fHBIDisk[t]) / nvBNP[t];

    E_fHBIDisk[t]$(tx0[t])..
      fHBIDisk[t] =E= fHBIDisk[t-1] * fv / (1+rOffRenteUd[t]);

    E_nvPrimSaldo[t]$(tx0E[t])..
      nvPrimSaldo[t] =E= vPrimSaldo[t] * fHBIDisk[t] + nvPrimSaldo[t+1];
    E_nvPrimSaldo_tEnd[t]$(tEnd[t])..
      nvPrimSaldo[t] =E= vPrimSaldo[t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvtLukning[t]$(tx0E[t])..
      nvtLukning[t] =E= vtLukning[aTot,t] * fHBIDisk[t] + nvtLukning[t+1];
    E_nvtLukning_tEnd[t]$(tEnd[t])..
      nvtLukning[t] =E= vtLukning[aTot,t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvGLukning[t]$(tx0E[t])..
      nvGLukning[t] =E= vGLukning[t] * fHBIDisk[t] + nvGLukning[t+1];
    E_nvGLukning_tEnd[t]$(tEnd[t])..
      nvGLukning[t] =E= vGLukning[t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvBNP[t]$(tx0E[t])..
      nvBNP[t] =E= vBNP[t] * fHBIDisk[t] + nvBNP[t+1];
    E_nvBNP_tEnd[t]$(tEnd[t])..
      nvBNP[t] =E= vBNP[t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);
 
# ----------------------------------------------------------------------------------------------------------------------
# Public inputs in private investments and consumption
# ----------------------------------------------------------------------------------------------------------------------
    # Public sales to private consumption follow government consumption
    E_vOffY2C[t]$(tx0[t]).. vOffY2C[t] =E= rOffY2C[t] * vG[gTot,t];
  
  $ENDBLOCK
$ENDIF