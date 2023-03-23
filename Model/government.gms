# ======================================================================================================================
# Government aggregation module
# - revenues and expenses are in GovRevenues and GovExpenses respectively
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_government_prices_endo
    empty_group_dummy[t] ""
  ;
  $GROUP G_government_quantities_endo
    empty_group_dummy[t] ""
  ;
  $GROUP G_government_values_endo
    # Renter, formuer og saldo
    vPrimSaldo[t] "Den offentlige sektors primære saldo, Kilde: ADAM[Tfn_o]-ADAM[Tion2]"
    vSaldo[t] "Den offentlige sektors faktiske saldo, Kilde: ADAM[Tfn_o]"

    vOff[portf_,t]$((t.val > 1994 or (netfin[portf_] and tx0[t])) and not (Guld[portf_] or BankGaeld[portf_] or pensTot[portf_])) "Det offentlige sektors finansielle portefølje."
    vOffOmv[t] "Omvurderinger af offentlige aktiver og passiver, Kilde: ADAM[Wn_o]-ADAM[Wn_o][-1]-ADAM[Tfn_o]"

    vOffNetRenter[t] "Den offentlige sektors nettoformueindkomst ekskl. jordrente og overskud af off. virksomhed, Kilde: ADAM[Tion2]"
    vNROffNetRenter[t] "Den offentlige sektors nettoformueindkomst inkl. jordrente og overskud af off. virksomhed, ADAM[Tin_o]"
    vOffRenteInd[t]$(t.val > 1995) "Den offentlige sektors indtægter af formueindkomst på aktivsiden, Kilde: ADAM[Tioii]"
    vOffRenteUd[t]$(t.val > 1995) "Den offentlige sektors udgifter til formueindkomst på passivsiden, Kilde: ADAM[Ti_o_z]"
    vOffNetFormue[t] "Den offentlige sektors nettoformue ekskl. offenlige fonde, Kilde: ADAM[Wosk]"
    vOffPas[t] "Den offentlige sektors passiver ekskl. offentlige fonde, Kilde: ADAM[Wosku]"
    vOEMUgaeld[t] "ØMU-gæld (eksklusive ATP og eksklusive genudlån), Kilde: ADAM[Wzzomuxa]"
    vOffInd[t] "Offentlige indtægter (renter + primære)"
    vOffUd[t]  "Offentlige udgifter (renter + primære)"

    vSatsIndeks[t] "Satsregulering."

    # Strukturelle værdier
    #  svSaldo[t] "Den offentlige sektors strukturelle saldo."
    #  vKonjGab[t] "Konjunkturbidrag til konjunkturgab."
    #  vOevrGab[t] "Øvrige bidrag til konjunkturgab."
  ;

  $GROUP G_government_endo
    G_government_prices_endo
    G_government_quantities_endo
    G_government_values_endo

    rOffRenteUd[t]$(t.val > 1995) "Gennemsnitlig rente på offentlig sektors passiver."
    rOffRenteInd[t]$(t.val > 1995) "Gennemsnitlig rente på offentlig sektors aktiver."
    rOffAkt2BNP[t] "Offentlig sektors aktiver ift. BNP."
    rOffPasRest2BNP[t] "Offentlig sektors aktiver ift. BNP."
  ;
  $GROUP G_government_endo 
    G_government_endo$(tx0[t])  # Restrict endo group to tx0[t]

    # Endogenous variables outside tx0 - we can calculate fiscal sustainability prior to first endogenous year
    nvBNP[t]$(tHBI.val <= t.val and t.val <= tEnd.val) "Nutidsværdi af BNP."
    nvOffOmv[t]$(tHBI.val <= t.val and t.val <= tEnd.val) "Nutidsværdien af offentlige omvurderinger"
    nvRenteMarginal[t]$(tHBI.val <= t.val and t.val <= tEnd.val) "Nutidsværdi af rentemarginal"
    nvPrimSaldo[t]$(tHBI.val <= t.val and t.val <= tEnd.val) "Nutidsværdi af offentlige finanser."
    rHBI[t]$(tHBI.val <= t.val and t.val <= tEnd.val) "Holdbarhedsindikator før korrektion ved beregningsmæssig skat til lukning, korrigeret HBI."
    fHBIDisk[t]$(tHBI.val < t.val and t.val <= tEnd.val) "Produktet af diskonteringsfaktorer i rHBI-beregning (fra periode tHBI til periode t)."
    nvSaldo[t]$(tHBI.val <= t.val and t.val <= tEnd.val) "Nutidsværdi af den offentlige sektors faktiske saldo."
  ;

  $GROUP G_government_prices
    G_government_prices_endo
  ;
  $GROUP G_government_quantities
    G_government_quantities_endo
  ;
  $GROUP G_government_values
    G_government_values_endo

    vOffFonde[t] "Offentlige fondes finansielle nettoformue."
    vtPALGab[t] "Korrektion for PAL-skat til konjunkturgab."
    vtSelskabNordGab[t] "Korrektion for Nordsø-provenu til konjunkturgab."
    vtSelskabRestGab[t] "Korrektion for anden selskabsskat til konjunkturgab."
    vtRegGab[t] "Korrektion for registreringsafgift  til konjunkturgab."
    vOffNetRenterGab[t] "Korrektion for offentlige rentebetalinger til konjunkturgab."
    vtRestGab[t] "Korrektion for øvrige specielle budgetposter til konjunkturgab."
    vEngangsForholdGab[t] "Korrektion for engangsforhold til konjunkturgab."
    vOffAkt[t] "Den offentlige sektors aktiver ekskl. offentlige fonde, Kilde: ADAM[Woski]"
    vOffPasRest[t] "Konsolidering og passiv-poster ikke medtaget i ØMU-gæld"
    vOff$(Guld[portf_] or BankGaeld[portf_] or pensTot[portf_])
  ;

  $GROUP G_government_ARIMA_forecast
    rOffAkt2BNP # Endogen i stødforløb
    rOffpasRest2BNP # Endogen i stødforløb
  ;
  $GROUP G_government_exogenous_forecast
    empty_group_dummy[t] ""
  ;
  $GROUP G_government_forecast_as_zero
    jvOffOmv[t] "J-led."
    jrOffRenteInd[t] "J-led."
    jrOffRenteUd[t] "J-led."
    jfSatsIndeks[t] "J-led."

    vOffFonde
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

    E_vOff_NetFin[t]$(tx0[t])..
      vOff['NetFin',t] =E= vOff['NetFin',t-1]/fv + vSaldo[t] + vOffOmv[t] + vtLukning[aTot,t] - vGLukning[t];
    E_vOffNetFormue[t]$(tx0[t]).. vOffNetFormue[t] =E= vOff['NetFin',t] - vOffFonde[t];

    E_vOffPas[t]$(tx0[t]).. vOffNetFormue[t] =E= vOffAkt[t] - vOffPas[t];

    E_vOEMUgaeld[t]$(tx0[t]).. vOffPas[t] =E= vOEMUgaeld[t] + vOffPasRest[t];

    E_rOffAkt2BNP[t]$(tx0[t]).. vOffAkt[t] =E= rOffAkt2BNP[t] * vBNP[t];
    E_rOffPasRest2BNP[t]$(tx0[t]).. vOffPasRest[t] =E= rOffPasRest2BNP[t] * vBNP[t];
    
    # Renteindtægter og udgifter inkluderer dem fra offentlige fonde
    E_vOffNetRenter[t]$(tx0[t]).. vOffNetRenter[t] =E= vOffRenteInd[t] - vOffRenteUd[t];
    E_vOffRenteInd[t]$(tx0[t] and t.val > 1995).. vOffRenteInd[t] =E= rOffRenteInd[t] * vOffAkt[t-1]/fv;
    E_vOffRenteUd[t]$(tx0[t] and t.val > 1995).. vOffRenteUd[t] =E= rOffRenteUd[t] * vOffPas[t-1]/fv;

    E_vOffInd[t]$(tx0[t]).. vOffInd[t] =E= vOffPrimInd[t] + vOffRenteInd[t]; 
    E_vOffUd[t]$(tx0[t]).. vOffUd[t] =E= vOffPrimUd[t] + vOffRenteUd[t];

    E_vNROffNetRenter[t]$(tx0[t])..
      vNROffNetRenter[t] =E= vOffNetRenter[t] + vJordrente[t] + vOffVirk[t];

    # Rentesatser (eksklusiv kapitalgevinster)
    E_rOffRenteInd[t]$(tx0[t] and t.val > 1995)..
      rOffRenteInd[t] =E= sum(akt, rOffAkt[akt,t-1] * rRente[akt,t]) + jrOffRenteInd[t];
    E_rOffRenteUd[t]$(tx0[t] and t.val > 1995)..
      rOffRenteUd[t] =E= rOffRealKred2Pas[t-1] * rRente['Obl',t] 
                       + (1-rOffRealKred2Pas[t-1]) * rRente['Obl',t] + jrOffRenteUd[t];

    # Omvurderinger
    E_vOffOmv[t]$(tx0[t])..
      vOffOmv[t] =E= sum(akt, vOff[akt,t-1]/fv * rOmv[akt,t]) 
                   - sum(pas, vOff[pas,t-1]/fv * rOmv[pas,t]) + jvOffOmv[t];

    # Financial assets are split into portfolio: vOffAkt = vOff[IndlAktier] + vOff[UdlAktier] + vOff[Bank] + vOff[Obl_akt]
    E_vOff_akt[akt,t]$(tx0[t] and (IndlAktier[akt] or UdlAktier[akt] or Bank[akt]) and t.val > 1994)..
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
    E_nvBNP[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvBNP[t] =E= vBNP[t] * fHBIDisk[t] + nvBNP[t+1];
    E_nvBNP_tEnd[t]$(tEnd[t])..
      nvBNP[t] =E= vBNP[t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1); 

    E_nvOffOmv[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOffOmv[t] =E= vOffOmv[t] * fHBIDisk[t] + nvOffOmv[t+1];
    E_nvOffOmv_tEnd[t]$(tEnd[t])..
      nvOffOmv[t] =E= vOffOmv[t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvRenteMarginal[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvRenteMarginal[t] =E= ((rOffRenteUd[t]-rOffRenteInd[t])*(vOffAkt[t-1]/fv)) * fHBIDisk[t] + nvRenteMarginal[t+1];
    E_nvRenteMarginal_tEnd[t]$(tEnd[t])..
      nvRenteMarginal[t] =E= ((rOffRenteUd[t]-rOffRenteInd[t])*(vOffAkt[t-1]/fv)) * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1); 

    E_nvPrimSaldo[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvPrimSaldo[t] =E= vPrimSaldo[t] * fHBIDisk[t] + nvPrimSaldo[t+1];
    E_nvPrimSaldo_tEnd[t]$(tEnd[t])..
      nvPrimSaldo[t] =E= vPrimSaldo[t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_fHBIDisk[t]$((tHBI.val < t.val)  and (t.val <= tEnd.val))..
      fHBIDisk[t] =E= fHBIDisk[t-1] * fv / (1+rOffRenteUd[t]);

    E_rHBI[t]$((tHBI.val <= t.val)  and (t.val <= tEnd.val))..
      rHBI[t] =E= (nvPrimSaldo[t] + nvOffOmv[t] - nvRenteMarginal[t] + vOffNetFormue[t-1]/fv * fHBIDisk[t]) / nvBNP[t];

    E_nvSaldo[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvSaldo[t] =E= vSaldo[t] * fHBIDisk[t] + nvSaldo[t+1];
    E_nvSaldo_tEnd[t]$(tEnd[t])..
      nvSaldo[t] =E= vSaldo[t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

  $ENDBLOCK

# Equations that do not need to be solved together with the full model and can instead be solved afterwards.
  MODEL M_Government_post /
    E_nvBNP, E_nvBNP_tEnd
    E_nvOffOmv, E_nvOffOmv_tEnd
    E_nvRenteMarginal, E_nvRenteMarginal_tEnd
    E_nvPrimSaldo, E_nvPrimSaldo_tEnd
    E_rHBI
    E_nvSaldo, E_nvSaldo_tEnd
    E_vOffInd
    E_vOffUd
  /;

# Endogenous variables that are solved for only after the main model.
# Note that these may not appear anywhere in the main model (this results in a model not square error).
  $GROUP G_Government_post
    nvBNP$(tHBI.val <= t.val)
    nvOffOmv$(tHBI.val <= t.val)
    nvRenteMarginal$(tHBI.val <= t.val)
    nvPrimSaldo$(tHBI.val <= t.val)
    rHBI$(tHBI.val <= t.val)
    nvSaldo$(tHBI.val <= t.val)
    vOffInd
    vOffUd
  ;
$ENDIF

$IF %stage% == "exogenous_values":
# =============================================================================================½=========================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_government_makrobk
    vOffNetRenter$(t.val > 2000), 
    vOffAkt, vOffPas, vOffNetFormue, vOffRenteInd, vOffRenteUd, vOff
    vOffFonde,  vSatsIndeks                            
    # Øvrige variable
    vOffDirInv
    vOEMUgaeld
    vSaldo$(t.val > 2006), vPrimSaldo$(t.val > 2006), vOffOmv$(t.val > 2006)
  ;
  @load(G_government_makrobk, "..\Data\makrobk\makrobk.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_government_data 
    G_government_makrobk
  ;
  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_government_data_imprecise  # Variables covered by data
    vSaldo$(t.val > 2006), vPrimSaldo$(t.val > 2006), vOffOmv$(t.val > 2006)
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  #  esSaldo.l[t] = 0;

  fHBIDisk.l[tHBI] = 1;

  parameter HBI_lukning_profil[t];
  HBI_lukning_profil[t]$(%HBI_lukning_start% < t.val and t.val < %HBI_lukning_slut%)
    = 1-1/(1+((%HBI_lukning_slut%-%HBI_lukning_start%)/(t.val - %HBI_lukning_start%) - 1)**(-2));
  HBI_lukning_profil[t]$(t.val >= %HBI_lukning_slut%) = 1;
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_government_static_calibration 
    G_government_endo$(tx0[t])

    -vSatsIndeks, jfSatsIndeks
    -vOffNetFormue, jvOffOmv
    -vOEMUgaeld, vOffPasRest

    rOffAkt$(t.val > 1994 and UdlAktier[akt]), -vOff$(UdlAktier[portf_])
    rOffAkt$(t.val > 1994 and IndlAktier[akt]), -vOff$(IndlAktier[portf_])
    rOffAkt$(t.val > 1994 and Bank[akt]), -vOff$(Bank[portf_])
    rOffAkt$(t.val > 1994 and Obl[akt]), -vOff$(Obl[portf_])
    rOffRealKred2Pas$(t.val > 1994), -vOff$(RealKred[portf_])

    # - via renter.
    jrOffRenteUd$(t.val > 1995), -vOffRenteUd
    jrOffRenteInd$(t.val > 1995), -vOffRenteInd
  ;
  $GROUP G_government_static_calibration G_government_static_calibration$(tx0[t])
  ;

  MODEL M_government_static_calibration /
     B_government - M_Government_post
  /;
$ENDIF

# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_government_deep
    G_government_endo
    vOffAkt$(tx1[t]), -rOffAkt2BNP$(tx1[t])
    vOffPasRest$(tx1[t]), -rOffPasRest2BNP$(tx1[t])

    vtLukning[a_,t]$(aTot[a_] and t.val >= %HBI_lukning_start%) # E_vtLukning_aTot_deep, E_vtLukning_aTot_tEnd_deep
    #  rGLukning[t]$(t.val >= %HBI_lukning_start%) # E_rGLukning, E_vtLukning_aTot_tEnd
  ;
  $GROUP G_government_deep G_government_deep$(tx0[t]);
  $BLOCK B_government_deep
    E_vtLukning_aTot_tEnd_deep[t]$(tEnd[t]).. vOffNetFormue[t] / vBNP[t] =E= vOffNetFormue[t-1] / vBNP[t-1];
    E_vtLukning_aTot_deep[t]$(tx0E[t] and t.val >= %HBI_lukning_start%).. tLukning[t] =E= HBI_lukning_profil[t] * tLukning[tEnd];
    #  E_rGLukning[t]$(tx0E[t] and t.val >= 2050).. rGLukning[t] =E= HBI_lukning_profil[t] * rGLukning[tEnd];
  $ENDBLOCK
  MODEL M_government_deep /
    B_government - M_Government_post
    B_government_deep
  /;
$ENDIF

# ======================================================================================================================
# Simple dynamic calibration
# ======================================================================================================================
$IF %stage% == "simple_dynamic_calibration":
  $GROUP G_government_dynamic_calibration
    G_government_endo
    vtLukning[a_,t]$(aTot[a_] and t.val >= %HBI_lukning_start%) # E_vtLukning_aTot, E_vtLukning_aTot_tEnd
  ;

  $BLOCK B_government_dynamic_calibration
    E_vtLukning_aTot_tEnd[t]$(tEnd[t]).. vOffNetFormue[t] / vBNP[t] =E= vOffNetFormue[t-1] / vBNP[t-1];
    E_vtLukning_aTot[t]$(tx0E[t] and t.val >= %HBI_lukning_start%).. tLukning[t] =E= HBI_lukning_profil[t] * tLukning[tEnd];
  $ENDBLOCK

  MODEL M_government_dynamic_calibration /
    B_government - M_government_post
    B_government_dynamic_calibration
  /;
$ENDIF