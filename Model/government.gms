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

    vOffNet[t]$(t.val >= %NettoFin_t1% and tx0[t]) "Den offentlige sektors finansielle portefølje."
    vOffAkt[portf_,t]$(t.val >= %NettoFin_t1% and portfTot[portf_]) " Den offentlige sektors aktiver"
    vOffPas[portf_,t]$(t.val >= %NettoFin_t1% and (Obl[portf_] or portfTot[portf_])) "Den offentlige sektors finansielle passiver."
    vOffAktRenter[portf_,t]$(t.val > %NettoFin_t1% and d1vOffAkt[portf_,t] and portf[portf_]) "Samlet formueindkomst fra aktiver for den offentlige sektor"
    vOffPasRenter[portf_,t]$(t.val > %NettoFin_t1% and d1vOffPas[portf_,t] and portf[portf_]) "Samlet rente- og dividendeudskrivninger for den offentlige sektor"
    vOffOmv[t]$(t.val > %NettoFin_t1%) "Samlede omvurderinger af den offentlige sektors nettoformue, Kilde: ADAM[Own_o]"
    vOffAktOmv[portf_,t]$(t.val > %NettoFin_t1% and d1vOffAkt[portf_,t] and portf[portf_]) "Omvurderinger af den offentlige sektors aktiver"
    vOffPasOmv[portf_,t]$(t.val > %NettoFin_t1% and d1vOffPas[portf_,t] and portf[portf_]) "Omvurderinger af den offentlige sektors passiver"
    jvOffOmv[t]$(t.val > %NettoFin_t1%) "Aggregeret J-led"

    vOffNetRenterx[t] "Den offentlige sektors nettoformueindkomst ekskl. jordrente og overskud af off. virksomhed, Kilde: ADAM[Tion2]"
    vOffNetRenter[t] "Den offentlige sektors nettoformueindkomst inkl. jordrente og overskud af off. virksomhed, ADAM[Tin_o]"
    vOffRenteInd[t]$(t.val > %NettoFin_t1%) "Den offentlige sektors indtægter af formueindkomst på aktivsiden, Kilde: ADAM[Tioii]"
    vOffRenteUd[t]$(t.val > %NettoFin_t1%) "Den offentlige sektors udgifter til formueindkomst på passivsiden, Kilde: ADAM[Ti_o_z]"
    vOffUdbytte[t]$(t.val > %NettoFin_t1%) "Statens udbytter af aktier og ejerandelsbeviser, Kilde: ADAM[Tiu_z_os]"
    vOffUdbytteNordsoe[t]$(t.val > %NettoFin_t1%) "Statens udbytter fra Nordsøfonden, Kilde: ADAM[Tiue_z_os]"
    vOffUdbytteRest[t]$(t.val > %NettoFin_t1%) "Statens udbytter af aktier og ejerandelsbeviser ekskl. fra Nordsøfonden, Kilde: ADAM[Tiur_z_os]"
    vOffNetFin_FM[t]$(t.val > %NettoFin_t1%) "Den offentlige sektors nettoformue baseret på FM, Kilde: ADAM[Wosk]"
    vOffPas_FM[t]$(t.val > %NettoFin_t1% ) "Den offentlige sektors passiver baseret på FM, Kilde: ADAM[Wosku]"
    vOffAkt_FM[t]$(t.val > %NettoFin_t1% ) "Den offentlige sektors aktiver baseret på FM, Kilde: ADAM[Woski]"
    vOEMUgaeld[t] "ØMU-gæld (eksklusive ATP og eksklusive genudlån), Kilde: ADAM[Wzzomuxa]"
    vStatsgaeld[t] "Statsgæld, Kilde: ADAM[SG]"
    vOffInd[t] "Offentlige indtægter (renter + primære)"
    vOffUd[t]  "Offentlige udgifter (renter + primære)"

    vSatsIndeks[t] "Satsregulering. Indeks til regulering af overførselsindkomster, Kilde: ADAM[pttyl]"
    vPrisIndeks[t] "Indeks til pristalsregulering af overførselsindkomster, Kilde: ADAM[pttyp]"
    vSatsIndeksx[t] "Indeks til regulering af overførselsindkomster ekskl. bidrag til obligatorisk opsparing for modtagere af indkomstoverførsler (fra 2020), Kilde: ADAM[pttyo]"
    vProgIndeks[t] "Indeks til regulering af progressionsgrænser, Kilde: ADAM[pcrs]" 
    # Strukturelle værdier"
    svSaldo[t] "Den offentlige sektors strukturelle saldo."
    #  vKonjGab[t] "Konjunkturbidrag til konjunkturgab."
    #  vOevrGab[t] "Øvrige bidrag til konjunkturgab."
  ;

  $GROUP G_government_endo
    G_government_prices_endo
    G_government_quantities_endo
    G_government_values_endo

    mrOffRente[t] "Offentlig marginalrente"
    rOffAkt2BNP[portf_,t]$(t.val >= %NettoFin_t1% and (IndlAktier[portf_] or UdlAktier[portf_] or Obl[portf_] or Bank[portf_])) "Offentlig sektors aktiver ift. BNP."
    rOffPas2BNP[portf_,t]$(t.val >= %NettoFin_t1% and (Obl[portf_] or RealKred[portf_] or Bank[portf_])) "Offentlig sektors aktiver ift. BNP."
    rOffPasRestFM2BNP[t] "Forskel på offentlig passiver fra FM og NR aktiver ift. BNP."
    rOffPasRest2BNP[t] "Forskel på offentlig finansielle passiver fra FM og OEMUgaeld ift. BNP."
    rOEMUgaeldRest2BNP[t] "Forskel på ØMU-gæld og statsgæld ift. BNP"
  ;
  $GROUP G_government_endo 
    G_government_endo$(tx0[t])  # Restrict endo group to tx0[t]

    # Endogenous variables outside tx0 - we can calculate fiscal sustainability prior to first endogenous year
    nvBNP[t]$(tHBI.val <= t.val and t.val <= tEnd.val) "Nutidsværdi af BNP."
    nvOffOmv[t]$(tHBI.val <= t.val and t.val <= tEnd.val) "Nutidsværdien af offentlige omvurderinger"
    nvRenteMarginal[t]$(tHBI.val <= t.val and t.val <= tEnd.val) "Nutidsværdi af rentemarginal"
    nvPrimSaldo[t]$(tHBI.val <= t.val and t.val <= tEnd.val) "Nutidsværdi af offentlige finanser."
    rHBI[t]$(tHBI.val <= t.val and t.val <= tEnd.val) "Holdbarhedsindikator før korrektion ved beregningsmæssig skat til lukning, korrigeret HBI."
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

    vOffNetFinRest[t] "Forskel på offentlig finansiel nettoformue fra FM og NR"
    vOffPasRest_FM[t] "Forskel på offentlig passiver fra FM og NR"
    vOffPasRest[t] "Forskel på offentlig finansielle passiver fra FM og OEMUgaeld"
    vOEMUgaeldRest[t] "Forskel på ØMU-gæld og statsgæld"
    #  vtPALGab[t] "Korrektion for PAL-skat til konjunkturgab."
    #  vtSelskabNordGab[t] "Korrektion for Nordsø-provenu til konjunkturgab."
    #  vtSelskabRestGab[t] "Korrektion for anden selskabsskat til konjunkturgab."
    #  vtRegGab[t] "Korrektion for registreringsafgift  til konjunkturgab."
    #  vOffNetRenterGab[t] "Korrektion for offentlige rentebetalinger til konjunkturgab."
    #  vtRestGab[t] "Korrektion for øvrige specielle budgetposter til konjunkturgab."
    #  vEngangsForholdGab[t] "Korrektion for engangsforhold til konjunkturgab."
  ;

  $GROUP G_government_ARIMA_forecast
    rOffAkt2BNP$(Not Bank[portf_]) # Endogen i stødforløb
    rOffPas2BNP$(Not Bank[portf_]) # Endogen for obligationer i stødforløb
    uOffUdbytteNordsoe[t] "Andel af statslige udbytter, der kommer fra Nordsøfonden"
  ;
  $GROUP G_government_exogenous_forecast
    empty_group_dummy[t] ""
  ;
  $GROUP G_government_forecast_as_zero
    jfSatsIndeks[t] "J-led."
    jfPrisIndeks[t] "J-led."
    jfSatsIndeksx[t] "J-led."
    jfProgIndeks[t] "J-led."

    jrOffAktRenter[portf_,t] "J-led som dækker forskel mellem det offentliges og den gennemsnitlige rente på aktivet/passivet."
    jrOffPasRenter[portf_,t] "J-led som dækker forskel mellem det offentliges og den gennemsnitlige rente på aktivet/passivet."
    jrOffAktOmv[portf_,t] "J-led som dækker forskel mellem den offentlige sektors og den gennemsnitlige omvurdering på aktivet/passivet."
    jrOffPasOmv[portf_,t] "J-led som dækker forskel mellem den offentlige sektors og den gennemsnitlige omvurdering på aktivet/passivet."

    vOffNetFinRest
  ;
  $GROUP G_government_fixed_forecast
    rOffAkt2BNP[portf_,t]$(Bank[portf_])
    rOffPas2BNP[portf_,t]$(Bank[portf_])
    rOffPasRestFM2BNP # Endogen i stødforløb
    rOffPasRest2BNP # Endogen i stødforløb
    rOEMUgaeldRest2BNP # Endogen i stødforløb
    fvOffUdbytte[t] "Andel af statslige udbytter, der går til staten" # Skal rykkes til ARIMA-forecast
    #  esSaldo[t] "Budgetelasticitet for samlet konjunkturfølsomhed."
    rOblOpsp2Ovf[t] "Bidragssats, obligatorisk opsparing for modtagere af indkostoverførsler, 0 før 2020, Kilde: ADAM[btpatpo]"
  ;
$ENDIF

# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_government_static$(tx0[t])
# ----------------------------------------------------------------------------------------------------------------------
# Satsregulering og andre reguleringer
# ----------------------------------------------------------------------------------------------------------------------
    E_vSatsIndeks[t]..
      vSatsIndeks[t] =E= vSatsIndeks[t-1]/fv 
                       * (vWHh[aTot,t-2]/nLHh[aTot,t-2]) / (vWHh[aTot,t-3]/nLHh[aTot,t-3]) * fv * (1 + jfSatsIndeks[t]);

    E_vPrisIndeks[t]..
      vPrisIndeks[t] =E= vPrisIndeks[t-1]/fv 
                       * pCPI[cTot,t-2] / pCPI[cTot,t-3] * fp * (1 + jfPrisIndeks[t]);

    E_vSatsIndeksx[t]..
      vSatsIndeksx[t] =E= vSatsIndeksx[t-1]/fv 
                       * (vSatsIndeks[t] / vSatsIndeks[t-1] - (rOblOpsp2Ovf[t] - rOblOpsp2Ovf[t])) * fv * (1 + jfSatsIndeksx[t]);

    E_vProgIndeks[t]..
      vProgIndeks[t] =E= vProgIndeks[t-1]/fv 
                       * (vWHh[aTot,t-2]/nLHh[aTot,t-2]) / (vWHh[aTot,t-3]/nLHh[aTot,t-3]) * fv * (1 + jfProgIndeks[t]);

# ----------------------------------------------------------------------------------------------------------------------
# Renter, formuer og saldo
# ----------------------------------------------------------------------------------------------------------------------
    E_vPrimSaldo[t].. vPrimSaldo[t] =E= vOffPrimInd[t] - vOffPrimUd[t];
    E_vSaldo[t].. vSaldo[t] =E= vPrimSaldo[t] + vOffNetRenterx[t];

    E_vOffNet[t]..
      vOffNet[t] =E= vOffNet[t-1]/fv + vSaldo[t] + vOffOmv[t] + vtLukning[aTot,t] - vGLukning[t];

    E_vOffAktRenter[portf,t]$(d1vOffAkt[portf,t] and t.val > %NettoFin_t1%)..
      vOffAktRenter[portf,t] =E= (rRente[portf,t] + jrOffAktRenter[portf,t]) * vOffAkt[portf,t-1]/fv;

    E_vOffPasRenter[portf,t]$(d1vOffPas[portf,t] and t.val > %NettoFin_t1%)..
      vOffPasRenter[portf,t] =E= (rRente[portf,t] + jrOffPasRenter[portf,t]) * vOffPas[portf,t-1]/fv;

    E_vOffNetRenterx[t].. vOffNetRenterx[t] =E= vOffRenteInd[t] - vOffRenteUd[t];
    E_vOffRenteInd[t]$(t.val > %NettoFin_t1%).. vOffRenteInd[t] =E= sum(portf, vOffAktRenter[portf,t]) - vOffVirk[t];
    E_vOffRenteUd[t]$(t.val > %NettoFin_t1%).. vOffRenteUd[t] =E= sum(portf, vOffPasRenter[portf,t]);

    E_vOffUdbytteNordsoe[t]$(t.val > %NettoFin_t1%).. vOffUdbytteNordsoe[t] =E= uOffUdbytteNordsoe[t] * vOffUdbytte[t];
    E_vOffUdbytteRest[t]$(t.val > %NettoFin_t1%).. vOffUdbytteRest[t] =E= (1-uOffUdbytteNordsoe[t]) * vOffUdbytte[t];
    E_vOffUdbytte[t]$(t.val > %NettoFin_t1%).. 
      vOffUdbytte[t] =E= fvOffUdbytte[t] * (vOffAktRenter['IndlAktier',t] + vOffAktRenter['UdlAktier',t]);
  
    E_vOffInd[t].. vOffInd[t] =E= vOffPrimInd[t] + vOffRenteInd[t]; 
    E_vOffUd[t].. vOffUd[t] =E= vOffPrimUd[t] + vOffRenteUd[t];

    # Nationalregnskabet inkluderer jordrente og afkast fra off. virk. i deres nettorenter, men ikke i primær indkomst
    E_vOffNetRenter[t]..
      vOffNetRenter[t] =E= sum(portf, vOffAktRenter[portf,t] - vOffPasRenter[portf,t]) + vJordrente[t];

    # Omvurderinger
    E_vOffAktOmv[portf,t]$(d1vOffAkt[portf,t] and t.val > %NettoFin_t1%)..
      vOffAktOmv[portf,t] =E= (rOmv[portf,t] + jrOffAktOmv[portf,t]) * vOffAkt[portf,t-1]/fv;

    E_vOffPasOmv[portf,t]$(d1vOffPas[portf,t] and t.val > %NettoFin_t1%)..
      vOffPasOmv[portf,t] =E= (rOmv[portf,t] + jrOffPasOmv[portf,t]) * vOffPas[portf,t-1]/fv;

    E_jvOffOmv[t]$(t.val > %NettoFin_t1%)..
      jvOffOmv[t] =E= sum(portf, jrOffAktOmv[portf,t] * vOffAkt[portf,t-1]/fv)
                     - sum(portf, jrOffPasOmv[portf,t] * vOffPas[portf,t-1]/fv);

    E_vOffOmv[t]$(t.val > %NettoFin_t1%)..
      vOffOmv[t] =E= sum(portf, vOffAktOmv[portf,t]) - sum(portf, vOffPasOmv[portf,t]);

    E_rOffAkt2BNP[portf,t]$((IndlAktier[portf] or UdlAktier[portf] or Bank[portf] or Obl[portf]) and t.val >= %NettoFin_t1%)..
      vOffAkt[portf,t] =E= rOffAkt2BNP[portf,t] * vBNP[t];

    # For obligationer er raten endogen - da værdien er endogen jf. ligning nedenfor
    E_rOffPas2BNP[portf,t]$((RealKred[portf] or Bank[portf] or Obl[portf]) and t.val >= %NettoFin_t1%)..
      vOffPas[portf,t] =E= rOffPas2BNP[portf,t] * vBNP[t];

    E_vOffAkt_tot[t]$(t.val >= %NettoFin_t1%)..
      vOffAkt['tot',t] =E= sum(portf, vOffAkt[portf,t]);

    # Statsgæld i obligationer er det der giver sig ved over- og underskud på saldoen
    E_vOffPas_tot[t]$(t.val >= %NettoFin_t1%)..
      vOffNet[t] =E= vOffAkt['tot',t] - vOffPas['tot',t];
    E_vOffPas_obl[t]$(t.val >= %NettoFin_t1%)..
      vOffPas['tot',t] =E= sum(portf, vOffPas[portf,t]);

# ----------------------------------------------------------------------------------------------------------------------
# Renter og formue til HBI
# ---------------------------------------------------------------------------------------------------------------------
    E_vOffNetFin_FM[t]$(t.val > %NettoFin_t1%).. vOffNetFin_FM[t] =E= vOffNet[t] - vOffNetFinRest[t];
    E_vOffPas_FM[t]$(t.val > %NettoFin_t1%).. vOffPas_FM[t] =E= sum(portf, vOffPas[portf, t]) - vOffPasRest_FM[t];
    E_vOffAkt_FM[t]$(t.val > %NettoFin_t1%).. vOffAkt_FM[t] =E= vOffNetFin_FM[t] + vOffPas_FM[t];

    E_rOffPasRestFM2BNP[t].. vOffPasRest_FM[t] =E= rOffPasRestFM2BNP[t] * vBNP[t];

    # Den marginale rente er statens udlånsrente på obligationer pt. rRente['Obl',t] - skal ved senere modellering konsistent erstattes med statsobligationsrenten
    E_mrOffRente[t]..
      mrOffRente[t] =E= rRente['Obl',t];  

# ----------------------------------------------------------------------------------------------------------------------
# Statsgæld, ØMU-gæld og offentlige passiver
# ---------------------------------------------------------------------------------------------------------------------
    E_vOEMUgaeld[t].. vOffPas_FM[t] =E= vOEMUgaeld[t] + vOffPasRest[t];

    E_vStatsGaeld[t].. vOEMUgaeld[t] =E= vStatsGaeld[t] + vOEMUgaeldRest[t];

    E_rOEMUgaeldRest2BNP[t].. vOEMUgaeldRest[t] =E= rOEMUgaeldRest2BNP[t] * vBNP[t];

    E_rOffPasRest2BNP[t].. vOffPasRest[t] =E= rOffPasRest2BNP[t] * vBNP[t];

# ----------------------------------------------------------------------------------------------------------------------
# Strukturel saldo
# ----------------------------------------------------------------------------------------------------------------------
    #  E_svSaldo[t].. svSaldo[t] =E= vSaldo[t] - vKonjGab[t] - vOevrGab[t];

    #  E_vKonjGab[t]..
    #    vKonjGab[t] =E= esSaldo[t] * (0.6 * rBeskGab[t] + 0.4 * rBVTGab[t]) * vBVT[sTot,t];

    #  E_vOevrGab[t]..
    #    vOevrGab[t] =E= vtPALGab[t]
    #                  + vtSelskabNordGab[t]
    #                  + vtSelskabRestGab[t]
    #                  + vtRegGab[t]
    #                  + vOffNetRenterGab[t]
    #                  + vtRestGab[t]
    #                  + vEngangsForholdGab[t];
  $ENDBLOCK

  $BLOCK B_government_forwardlooking
  # ----------------------------------------------------------------------------------------------------------------------
  # Holdbarheds-indikator
  # ---------------------------------------------------------------------------------------------------------------------  
    E_rHBI[t]$((tHBI.val <= t.val)  and (t.val <= tEnd.val))..
      rHBI[t] =E= (nvPrimSaldo[t] + nvOffOmv[t] - nvRenteMarginal[t] + vOffNetFin_FM[t-1]/fv * (1+mrOffRente[t])) / nvBNP[t];

    E_nvPrimSaldo[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvPrimSaldo[t] =E= vPrimSaldo[t] + nvPrimSaldo[t+1]*fv / (1+mrOffRente[t]);
    E_nvPrimSaldo_tEnd[t]$(tEnd[t])..
      nvPrimSaldo[t] =E= vPrimSaldo[t] / ((1+mrOffRente[t]) / fv - 1);

    E_nvBNP[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvBNP[t] =E= vBNP[t] + nvBNP[t+1]*fv / (1+mrOffRente[t]);
    E_nvBNP_tEnd[t]$(tEnd[t])..
      nvBNP[t] =E= vBNP[t] / ((1+mrOffRente[t]) / fv - 1); 

    E_nvOffOmv[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOffOmv[t] =E= vOffOmv[t] + nvOffOmv[t+1]*fv / (1+mrOffRente[t]);
    E_nvOffOmv_tEnd[t]$(tEnd[t])..
      nvOffOmv[t] =E= vOffOmv[t] / ((1+mrOffRente[t]) / fv - 1);

    E_nvSaldo[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvSaldo[t] =E= vSaldo[t] + nvSaldo[t+1]*fv / (1+mrOffRente[t]);
    E_nvSaldo_tEnd[t]$(tEnd[t])..
      nvSaldo[t] =E= vSaldo[t] / ((1+mrOffRente[t]) / fv - 1);

    # Nutidsværdien af rentemarginalen er givet ud fra forskellen til den marginale rente  
    E_nvRenteMarginal[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvRenteMarginal[t] =E= (mrOffRente[t] * vOffAkt_FM[t-1]/fv - vOffRenteInd[t]
                             - (mrOffRente[t] * vOffPas_FM[t-1]/fv - vOffRenteUd[t])) + nvRenteMarginal[t+1]*fv / (1+mrOffRente[t]);
    E_nvRenteMarginal_tEnd[t]$(tEnd[t])..
      nvRenteMarginal[t] =E= (mrOffRente[t] * vOffAkt_FM[t-1]/fv - vOffRenteInd[t]
                             - (mrOffRente[t] * vOffPas_FM[t-1]/fv - vOffRenteUd[t]) ) / ((1+mrOffRente[t]) / fv - 1);
  $ENDBLOCK

  Model M_government /
    B_government_static
    B_government_forwardlooking
    /;  
  $GROUP G_government_static
    G_government_endo
    -nvRenteMarginal, -nvPrimSaldo, -nvBNP, -nvOffOmv, -nvSaldo, -rHBI
  ;

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
# ======================================================================================================================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_government_makrobk
    vOffNetRenterx, vOffNetRenter, vOffAktRenter, vOffPasRenter, vOffAktOmv, vOffPasOmv
    vOffRenteInd, vOffRenteUd, vOffNet, vOffAkt, vOffPas, vOffUdbytte, vOffUdbytteNordsoe
    vOffAkt_FM, vOffPas_FM, vOffNetFin_FM, vStatsGaeld
    vOffNetFinRest$(t.val > %NettoFin_t1%),  vSatsIndeks, vPrisIndeks, rOblOpsp2Ovf,  vSatsIndeksx, vProgIndeks
    # Øvrige variable
    vOffDirInv
    vOEMUgaeld
    vSaldo, vPrimSaldo, vOffOmv
  ;
  @load(G_government_makrobk, "..\Data\makrobk\makrobk.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_government_data 
    G_government_makrobk
  ;
  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_government_data_imprecise  # Variables covered by data
    vSaldo, vPrimSaldo, vOffOmv, vOffNetFinRest$(t.val > %NettoFin_t1%)
    vOffRenteUd, vOffRenteInd, vOffNetRenter, vOffNetRenterx # Der er en lille residual i identiteten for Ti_z_o i ADAM
    vOffPas, vOffNet # Små unøjagtigheder i Own_o og underkomponenter i ADAM
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  #  esSaldo.l[t] = 0;
  parameter HBI_lukning_profil[t];
  HBI_lukning_profil[t]$(%HBI_lukning_start% < t.val and t.val < %HBI_lukning_slut%)
    = 1-1/(1+((%HBI_lukning_slut%-%HBI_lukning_start%)/(t.val - %HBI_lukning_start%) - 1)**(-2));
  HBI_lukning_profil[t]$(t.val >= %HBI_lukning_slut%) = 1;

# ======================================================================================================================
# Data assignment
# ======================================================================================================================
  #Set Dummy for government portfolio
  d1vOffAkt[portf,t] = yes$(vOffAkt.l[portf,t] <> 0);
  d1vOffPas[portf,t] = yes$(vOffPas.l[portf,t] <> 0);

  d1vOffAkt['tot',t] = d1vOffAkt['Obl',t];
  d1vOffPas['tot',t] = d1vOffPas['Obl',t];
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_government_static_calibration 
    G_government_endo$(tx0[t])

    -vOffAktRenter[portf_,t], jrOffAktRenter[portf,t]$(t.val > %NettoFin_t1% and  d1vOffAkt[portf,t])
    -vOffPasRenter[portf_,t], jrOffPasRenter[portf,t]$(t.val > %NettoFin_t1% and  d1vOffPas[portf,t]) 
    -vOffAktOmv[portf_,t], jrOffAktOmv[portf,t]$(t.val > %NettoFin_t1% and  d1vOffAkt[portf,t])
    -vOffPasOmv[portf_,t], jrOffPasOmv[portf,t]$(t.val > %NettoFin_t1% and  d1vOffPas[portf,t])

    -vOffUdbytte, fvOffUdbytte

    -vSatsIndeks, jfSatsIndeks
    -vPrisIndeks, jfPrisIndeks
    -vSatsIndeksx, jfSatsIndeksx
    -vProgIndeks, jfProgIndeks
    -vOffNetFin_FM$(t.val > %NettoFin_t1%), vOffNetFinRest$(t.val > %NettoFin_t1%)

    -vOffPas_FM$(t.val > %NettoFin_t1%), vOffPasRest_FM$(t.val > %NettoFin_t1%)

    -vOEMUgaeld, vOffPasRest
    -vStatsGaeld, vOEMUgaeldRest

    -vOffUdbytteNordsoe, uOffUdbytteNordsoe

    rOffPas2BNP[RealKred,t]$(t.val >= %NettoFin_t1%), -vOffPas[RealKred,t]$(t.val >= %NettoFin_t1%)
    rOffPas2BNP[Bank,t]$(t.val >= %NettoFin_t1%), -vOffPas[Bank,t]$(t.val >= %NettoFin_t1%)
  ;
  $GROUP G_government_static_calibration G_government_static_calibration$(tx0[t]);
  MODEL M_government_static_calibration /
     M_government - M_Government_post
    #  M_government_static_calibration
  /;

  $GROUP G_government_static_calibration_newdata
    G_government_static_calibration
   ;
  MODEL M_government_static_calibration_newdata /
    M_government_static_calibration
  /;
$ENDIF

# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_government_deep
    G_government_endo
    vOffAkt[IndlAktier,tx1], -rOffAkt2BNP[portf_,tx1]
    vOffAkt[UdlAktier,tx1], -rOffAkt2BNP[UdlAktier,tx1]
    vOffAkt[Bank,tx1], -rOffAkt2BNP[Bank,tx1]
    vOffAkt[Obl,tx1], -rOffAkt2BNP[Obl,tx1]
    vOffPas[RealKred,tx1], -rOffPas2BNP[RealKred,tx1]
    vOffPas[Bank,tx1], -rOffPas2BNP[Bank,tx1]
    vOffPasRest[tx1], -rOffPasRest2BNP[tx1]
    vOffPasRest_FM[tx1], -rOffPasRestFM2BNP[tx1]
#    vOEMUgaeldRest[tx1], -rOEMUgaeldRest2BNP[tx1]

    #  vtLukning[a_,t]$(aTot[a_] and t.val >= %HBI_lukning_start%) # E_vtLukning_aTot_deep, E_vtLukning_aTot_tEnd_deep
    #  rGLukning[t]$(t.val >= %HBI_lukning_start%) # E_rGLukning, E_vtLukning_aTot_tEnd
  ;
  $GROUP G_government_deep G_government_deep$(tx0[t]);
  #  $BLOCK B_government_deep
  #    E_vtLukning_aTot_tEnd_deep[t]$(tEnd[t]).. vOffNetFin_FM[t] / vBNP[t] =E= vOffNetFin_FM[t-1] / vBNP[t-1];
  #    E_vtLukning_aTot_deep[t]$(tx0E[t] and t.val >= %HBI_lukning_start%).. tLukning[t] =E= HBI_lukning_profil[t] * tLukning[tEnd];
  #    #  E_rGLukning[t]$(tx0E[t] and t.val >= 2050).. rGLukning[t] =E= HBI_lukning_profil[t] * rGLukning[tEnd];
  #  $ENDBLOCK
  MODEL M_government_deep /
    M_government - M_Government_post
    #  B_government_deep
  /;
$ENDIF

# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
  $GROUP G_government_dynamic_calibration
    G_government_endo
    #  vtLukning[a_,t]$(aTot[a_] and t.val >= %HBI_lukning_start%) # E_vtLukning_aTot, E_vtLukning_aTot_tEnd
  ;

  #  $BLOCK B_government_dynamic_calibration
  #    E_vtLukning_aTot_tEnd[t]$(tEnd[t]).. vOffNetFin_FM[t] / vBNP[t] =E= vOffNetFin_FM[t-1] / vBNP[t-1];
  #    E_vtLukning_aTot[t]$(tx0E[t] and t.val >= %HBI_lukning_start%).. tLukning[t] =E= HBI_lukning_profil[t] * tLukning[tEnd];
  #  $ENDBLOCK

  MODEL M_government_dynamic_calibration /
    M_government - M_government_post
    #  B_government_dynamic_calibration
  /;
$ENDIF