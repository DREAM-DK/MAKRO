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
  ;
  $GROUP G_government_quantities_endo
  ;
  $GROUP G_government_values_endo
    # Renter, formuer og saldo
    vPrimSaldo[t] "Den offentlige sektors primære saldo, Kilde: ADAM[Tfn_o]-ADAM[Tion2]"
    vSaldo[t] "Den offentlige sektors faktiske saldo, Kilde: ADAM[Tfn_o]"

    vOffNet[t]$(t.val > %NettoFin_t1% and tx0[t]) "Nettoværdien af den offentlige sektors finansielle portefølje."
    vOffAkt[portf_,t]$(t.val >= %NettoFin_t1% and (portfTot[portf_] or IndlAktier[portf_] or UdlAktier[portf_])) " Den offentlige sektors finansielle aktiver"
    vOffPas[portf_,t]$(t.val >= %NettoFin_t1% and (portf[portf_] or portfTot[portf_])) "Den offentlige sektors finansielle passiver."
    vOffAktRenter[portf_,t]$(t.val > %NettoFin_t1% and d1vOffAkt[portf_,t] and portf[portf_]) "Samlet formueindkomst fra aktiver for den offentlige sektor"
    vOffPasRenter[portf_,t]$(t.val > %NettoFin_t1% and d1vOffPas[portf_,t] and portf[portf_]) "Samlet rente- og dividendeudskrivninger for den offentlige sektor"
    vOffOmv[t]$(t.val > %NettoFin_t1%) "Samlede omvurderinger af den offentlige sektors nettoformue, Kilde: ADAM[Own_o]"
    vOffAktOmv[portf_,t]$(t.val > %NettoFin_t1% and d1vOffAkt[portf_,t] and portf[portf_]) "Omvurderinger af den offentlige sektors aktiver"
    vOffPasOmv[portf_,t]$(t.val > %NettoFin_t1% and d1vOffPas[portf_,t] and portf[portf_]) "Omvurderinger af den offentlige sektors passiver"
    jvOffOmv[t]$(t.val > %NettoFin_t1%) "Aggregeret J-led"

    vOffNetRenterx[t] "Den offentlige sektors nettoformueindkomst ekskl. jordrente og overskud af off. virksomhed, Kilde: ADAM[Tion2]"
    vOffNetRenter[t]$(t.val > %NettoFin_t1%) "Den offentlige sektors nettoformueindkomst inkl. jordrente og overskud af off. virksomhed, ADAM[Tin_o]"
    vOffRenteInd[t]$(t.val > %NettoFin_t1%) "Den offentlige sektors indtægter af formueindkomst på aktivsiden, Kilde: ADAM[Tioii]"
    vOffRenterxInd[t]$(t.val > %NettoFin_t1%) "Den offentlige sektors renteindtægter ekskl. dividender"
    vOffDividender[t]$(t.val > %NettoFin_t1%) "Den offentlige sektors dividendeindtægter"
    vOffRenteUd[t]$(t.val > %NettoFin_t1%) "Den offentlige sektors udgifter til formueindkomst på passivsiden, Kilde: ADAM[Ti_o_z]"
    vOffUdbytte[t]$(t.val > %NettoFin_t1%) "Statens udbytter af aktier og ejerandelsbeviser, Kilde: ADAM[Tiu_z_os]"
    vOffUdbytteNordsoe[t]$(t.val > %NettoFin_t1%) "Statens udbytter fra Nordsøfonden, Kilde: ADAM[Tiue_z_os]"
    vOffUdbytteRest[t]$(t.val > %NettoFin_t1%) "Statens udbytter af aktier og ejerandelsbeviser ekskl. fra Nordsøfonden, Kilde: ADAM[Tiur_z_os]"
    vOff13Net[t]$(t.val > %NettoFin_t1%) "Nettoværdien af den offentlige sektors finansielle portefølje baseret på OFF13."
    vOff13Aktx[t]$(t.val > %NettoFin_t1%) "Den offentlige sektors finansielle rentebærende aktiver (dvs. ekskl. aktier) baseret på OFF13."
    vOff13Aktier[t]$(t.val > %NettoFin_t1%) "Den offentlige sektors aktiebeholdning baseret på OFF13."
    vOff13Pas[t]$(t.val > %NettoFin_t1%) "Den offentlige sektors finansielle passiver baseret på OFF13."
    vOEMUgaeld[t] "ØMU-gæld (eksklusive ATP og eksklusive genudlån), Kilde: ADAM[Wzzomuxa]"
    vStatsgaeld[t] "Statsgæld, Kilde: ADAM[SG]"
    vOffInd[t] "Offentlige indtægter (renter + primære)"
    vOffUd[t]  "Offentlige udgifter (renter + primære)"

    vSatsIndeks[t] "Satsregulering. Indeks til regulering af overførselsindkomster, Kilde: ADAM[pttyl]"
    vPrisIndeks[t] "Indeks til pristalsregulering af overførselsindkomster, Kilde: ADAM[pttyp]"
    vSatsIndeksx[t] "Indeks til regulering af overførselsindkomster ekskl. bidrag til obligatorisk opsparing for modtagere af indkomstoverførsler (fra 2020), Kilde: ADAM[pttyo]"
    vProgIndeks[t]$(t.val >= 1998) "Indeks til regulering af progressionsgrænser, Kilde: ADAM[pcrs]" 
    vSatsIndeksIntro[t] "Indeks til regulering af integrationsydelse." 
  ;

  $GROUP G_government_endo
    G_government_prices_endo
    G_government_quantities_endo
    G_government_values_endo

    mrOffRente[t]$(t.val > %NettoFin_t1%) "Offentlig marginalrente"
    rOffAkt2BNP[portf_,t]$(t.val >= %NettoFin_t1% and (Obl[portf_] or Bank[portf_])) "Offentlig sektors aktiver ift. BNP."
    rOffPasRest2BNP[t] "Forskel på offentlig finansielle passiver fra FM og OEMUgaeld ift. BNP."
    rOEMUgaeldRest2BNP[t] "Forskel på ØMU-gæld og statsgæld ift. BNP"
    rOffRenterxInd[t]$(t.val > %NettoFin_t1%) "Implicit rente på offentlige rentebærende aktiver (dvs. ekskl. aktier) baseret på OFF13"
    rOffDividender[t]$(t.val > %NettoFin_t1%) "Implicit dividendesats på offentligt ejede aktier baseret på OFF13"
    rOffRenteUd[t]$(t.val > %NettoFin_t1%) "Implicit rente på offentlige passiver baseret på OFF13"
    rvSaldo_konjunkturrenset_alm_poster[t] "Offentlig saldo korrigeret for konjunkturpåvirkning på almindelige poster"
  ;

  # Variable der skal udregnes nutidsværdi af
  $GROUP G_government_nv_variables
    vPrimSaldo
    vOffPrimInd
    vtDirekte
    vtKilde
    vtPersonlige
    vtDoedsbo['tot']
    vtKommune['tot']
    vtBund['tot']
    vtEjd['tot']
    vtAktie
    vtVirksomhed['tot']
    jvtKilde
    vtHhVaegt['tot']
    vtHhAM['tot']
    vtPersRest['tot']
    vtSelskab['tot']
    vtPAL
    vtIndirekte
    vtAfg['dTot','tot']
    vtMoms['dTot','tot']
    vtReg['dTot','tot']
    vtY['tot']
    vtGrund['tot']
    vtVirkVaegt['tot']
    vtAUB['tot']
    vtVirkAM['tot']
    vtYRest['tot']
    vOffIndRest
    vBidrag['tot']
    vBidragObl
    vBidragAK
    vBidragEL
    vBidragFri
    vBidragTjmp
    vtArv['tot']
    vOffAfskr['iTot']
    vJordrente
    vtKulbrinte
    vJordrenteRest
    vOffVirk
    vtKirke['tot']
    vOffFraUdlKap
    vOffFraUdlEU
    vOffFraUdlRest
    vOffFraVirk
    vOffFraHh
    vOffPrimUd
    vG['gTot']
    vGInd
    vGKol
    vOffInv
    vOvf['tot']
    vOvf['pension']
    vOvf['fortid']
    vOvf['efterl']
    vOvf['tjmand']
    vOvf['barsel']
    vOvf['syge']
    vOvf['uddsu']
    vOvf['boernyd']
    vOvf['boligst']
    vOvf['boligyd']
    vOffSub
    vSub['dTot','tot']
    vSubY
    vOffUdRest
    vOffOmv
    vSaldo
    vBNP
    vOffUdbytte
    vOffInd
    vOffUd
    vRenteMarginal[t] "Værdien af rentemarginal"
  ;

  $GROUP G_government_nv
    $LOOP G_government_nv_variables:
      n{name}{sets} "Present value of {name}"
    $ENDLOOP
  ;
  
  $GROUP G_government_forwardlooking 
    # Endogenous variables outside tx0 - we can calculate fiscal sustainability prior to first endogenous year
    G_government_nv$(tHBI.val <= t.val and t.val <= tEnd.val) "Nutidsværdi af offentlige finanser."
    vRenteMarginal$(tHBI.val <= t.val and t.val <= tEnd.val)
    rHBI[t]$(tHBI.val <= t.val and t.val <= tEnd.val) "Holdbarhedsindikator før korrektion ved beregningsmæssig skat til lukning, korrigeret HBI."
    rHBIxMerafkast[t]$(tHBI.val <= t.val and (t.val < tEnd.val)) "Holdbarhedsindikator eksklusiv merafkast."
  ;

  $GROUP G_government_endo 
    G_government_endo$(tx0[t])  # Restrict endo group to tx0[t]

    G_government_forwardlooking
  ;

  $GROUP G_government_prices
    G_government_prices_endo
  ;
  $GROUP G_government_quantities
    G_government_quantities_endo
  ;
  $GROUP G_government_values
    G_government_values_endo

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
    rOffAkt2BNP # Endogen i stødforløb
    uOffUdbytteNordsoe[t] "Andel af statslige udbytter, der kommer fra Nordsøfonden"
  ;
  $GROUP G_government_exogenous_forecast
  ;
  $GROUP G_government_forecast_as_zero
    jfPrisIndeks[t] "J-led."
    jfSatsIndeksx[t] "J-led."
    jfProgIndeks[t] "J-led."

    jrOffAktRenter[portf_,t] "J-led som dækker forskel mellem det offentliges og den gennemsnitlige rente på aktivet/passivet."
    jrOffPasRenter[portf_,t] "J-led som dækker forskel mellem det offentliges og den gennemsnitlige rente på aktivet/passivet."
    jrOffAktOmv[portf_,t] "J-led som dækker forskel mellem den offentlige sektors og den gennemsnitlige omvurdering på aktivet/passivet."
    jrOffPasOmv[portf_,t] "J-led som dækker forskel mellem den offentlige sektors og den gennemsnitlige omvurdering på aktivet/passivet."

    jvOffAkt[portf_,t] "J-led"
  ;
  $GROUP G_government_fixed_forecast
    rOffPas2Tot[portf_,t] "Offentlig sektors fordeling af passiver."
    rOffPasRest2BNP # Endogen i stødforløb
    rOEMUgaeldRest2BNP # Endogen i stødforløb
    fvOffUdbytte[t] "Andel af statslige udbytter, der går til staten" # Skal rykkes til ARIMA-forecast
    budgetfaktor[t] "Almindelige offentlige posters konjunkturfølsomhed"
    rOblOpsp2Ovf[t] "Bidragssats, obligatorisk opsparing for modtagere af indkostoverførsler, 0 før 2020, Kilde: ADAM[btpatpo]"
    vOff13AktxRest[t] "Forskel mellem offentlig rentebærende nettoformue (dvs. ekskl. aktier) baseret på OFF13 og NASFK"
    vOff13AktierRest[t] "Forskel mellem offentlig aktieformue baseret på OFF13 og NASFK"

    uvSatsIndeks[t] "Niveauparameter for satsindekset"
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
    E_SatsIndeks[t]..
      vSatsIndeks[t] =E= uvSatsIndeks[t] * vhW_DA[t-2] / (fv * fv);
    # Satsreguleringen tager højde for AM-bidrag og standardarbejdstid. Hvis man gerne vil have disse med i modellen kan det skrives som:
    # E_SatsIndeks[t]..
    #   vSatsIndeks[t] =E= uvSatsIndeks[t] * (1-tAMbidrag[t]) * rhL2nFuldtid[t-2] * vhW_DA[t-2] / (fv * fv);
    
    E_SatsIndeksIntro_start[t]$(t.val <= 2019).. vSatsIndeksIntro[t]  =E= vSatsIndeks[t];
    E_SatsIndeksIntro_mindre[t]$(t.val > 2019).. vSatsIndeksIntro[t] =E= vSatsIndeks[t] * (1-0.3/100)**(t.val-2019);

    E_vPrisIndeks[t]..
      vPrisIndeks[t] =E= vPrisIndeks[t-1]/fv 
                       * pCPI[cTot,t-2] / pCPI[cTot,t-3] * fp * (1 + jfPrisIndeks[t]);

    E_vSatsIndeksx[t]..
      vSatsIndeksx[t] =E= vSatsIndeksx[t-1]/fv 
                       * (vSatsIndeks[t] / vSatsIndeks[t-1] - (rOblOpsp2Ovf[t] - rOblOpsp2Ovf[t])) * fv * (1 + jfSatsIndeksx[t]);

    E_vProgIndeks[t]$(t.val >= 1998).. # Vi har kun vWHh fra 1995
      vProgIndeks[t] =E= vProgIndeks[t-1]/fv 
                       * (vWHh[aTot,t-2]/nLHh[aTot,t-2]) / (vWHh[aTot,t-3]/nLHh[aTot,t-3]) * fv * (1 + jfProgIndeks[t]);

# ----------------------------------------------------------------------------------------------------------------------
# Renter, formuer og saldo
# ----------------------------------------------------------------------------------------------------------------------
    E_vPrimSaldo[t].. vPrimSaldo[t] =E= vOffPrimInd[t] - vOffPrimUd[t];
    E_vSaldo[t].. vSaldo[t] =E= vPrimSaldo[t] + vOffNetRenterx[t] + vtLukning[aTot,t];

    E_vOffNet[t]$(t.val > %NettoFin_t1%)..
      vOffNet[t] =E= vOffNet[t-1]/fv + vSaldo[t] + vOffOmv[t] - vGLukning[t];

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
    E_vOffNetRenter[t]$(t.val > %NettoFin_t1%)..
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

    E_rOffAkt2BNP[portf,t]$((Bank[portf] or Obl[portf]) and t.val >= %NettoFin_t1%)..
      vOffAkt[portf,t] =E= rOffAkt2BNP[portf,t] * vBNP[t];

    # Offentlige aktiebeholdning følger blot omvurderinger
    E_vOffAkt[portf,t]$((IndlAktier[portf] or UdlAktier[portf]) and t.val >= %NettoFin_t1%)..
      vOffAkt[portf,t] =E= vOffAkt[portf,t-1]/fv + vOffAktOmv[portf,t] + jvOffAkt[portf,t];

    E_vOffAkt_tot[t]$(t.val >= %NettoFin_t1%)..
      vOffAkt['tot',t] =E= sum(portf, vOffAkt[portf,t]);

    # De samlede passiver er det der giver sig ved over- og underskud på saldoen
    E_vOffPas_tot[t]$(t.val >= %NettoFin_t1%)..
      vOffNet[t] =E= vOffAkt['tot',t] - vOffPas['tot',t];

    # Det deles proportionalt ud på passiver
    E_vOffPas[portf,t]$(t.val >= %NettoFin_t1%)..
      vOffPas[portf,t] =E= rOffPas2Tot[portf,t] * vOffPas['tot',t];

# ----------------------------------------------------------------------------------------------------------------------
# Renter og formue til HBI
# ---------------------------------------------------------------------------------------------------------------------
    E_vOff13Aktx[t]$(t.val > %NettoFin_t1%)..
      vOff13Aktx[t] =E= vOffAkt['Obl',t] + vOffAkt['Bank',t] + vOff13AktxRest[t];
    E_vOff13Aktier[t]$(t.val > %NettoFin_t1%).. 
      vOff13Aktier[t] =E= vOffAkt['IndlAktier',t] + vOffAkt['UdlAktier',t] + vOff13AktierRest[t];
    # Der er ikke forskel på passiverne, da vi også definerer vOffPas ud fra OFF13 i data og fanger forskellen på nettostørrelserne i aktiverne
    E_vOff13Pas[t]$(t.val > %NettoFin_t1%).. vOff13Pas[t] =E= sum(portf, vOffPas[portf,t]);
    E_vOff13Net[t]$(t.val > %NettoFin_t1%).. vOff13Net[t] =E= vOff13Aktx[t] + vOff13Aktier[t] - vOff13Pas[t];    

    # Den marginale rente er et vægtet gns. af de marginale passiv-renter
    E_mrOffRente[t]$(t.val > %NettoFin_t1%).. mrOffRente[t] =E= sum(portf, vOffPasRenter[portf,t]) / (vOffPas['tot',t-1]/fv);

    # Opdeling af offentlige renteindtægter på dividender og andet
    E_vOffRenterxInd[t]$(t.val > %NettoFin_t1%).. 
      vOffRenterxInd[t] =E= vOffAktRenter['Obl',t] + vOffAktRenter['Bank',t];
    E_vOffDividender[t]$(t.val > %NettoFin_t1%).. 
      vOffDividender[t] =E= vOffAktRenter['IndlAktier',t] + vOffAktRenter['UdlAktier',t] - vOffVirk[t];

    # Implicitte renter for offentlige aktiver og passiver baseret på OFF13
    E_rOffRenterxInd[t]$(t.val > %NettoFin_t1%).. vOffRenterxInd[t] =E= rOffRenterxInd[t] * vOff13Aktx[t-1]/fv;
    E_rOffDividender[t]$(t.val > %NettoFin_t1%).. vOffDividender[t] =E= rOffDividender[t] * vOff13Aktier[t-1]/fv;
    E_rOffRenteUd[t]$(t.val > %NettoFin_t1%).. vOffRenteUd[t] =E= rOffRenteUd[t] * vOff13Pas[t-1]/fv;

# ----------------------------------------------------------------------------------------------------------------------
# Statsgæld, ØMU-gæld og offentlige passiver
# ---------------------------------------------------------------------------------------------------------------------
    E_vOEMUgaeld[t].. vOffPas['tot',t] =E= vOEMUgaeld[t] + vOffPasRest[t];

    E_vStatsGaeld[t].. vOEMUgaeld[t] =E= vStatsGaeld[t] + vOEMUgaeldRest[t];

    E_rOEMUgaeldRest2BNP[t].. vOEMUgaeldRest[t] =E= rOEMUgaeldRest2BNP[t] * vBNP[t];

    E_rOffPasRest2BNP[t].. vOffPasRest[t] =E= rOffPasRest2BNP[t] * vBNP[t];

# ----------------------------------------------------------------------------------------------------------------------
# Strukturel saldo
# ----------------------------------------------------------------------------------------------------------------------
  E_rvSaldo_konjunkturrenset_alm_poster[t]..
    rvSaldo_konjunkturrenset_alm_poster[t] =E= vSaldo[t] / vBNP[t]
                                             - budgetfaktor[t] * (0.6 * rBeskGab[t] + 0.4 * rBVTGab[t]);
  $ENDBLOCK

  $BLOCK B_government_forwardlooking$(tHBI.val <= t.val)
  # ----------------------------------------------------------------------------------------------------------------------
  # Holdbarheds-indikator
  # ---------------------------------------------------------------------------------------------------------------------  
    E_rHBI[t]$(t.val <= tEnd.val)..
      rHBI[t] =E= (nvPrimSaldo[t] + nvOffOmv[t] - nvRenteMarginal[t] + vOff13Net[t-1]/fv * (1+mrOffRente[t+1])) / nvBNP[t];

    E_rHBIxMerafkast[t]$(t.val < tEnd.val)..
      rHBIxMerafkast[t] =E= (nvPrimSaldo[t+1]*fv / (1+mrOffRente[t+1]) + vOff13Net[t]) / nvBNP[t];

    # Nutidsværdier til beregning og dekomponering af HBI.
    # Som terminalbetingelse anvendes gennemsnit af de 5 sidste år.
    $LOOP G_government_nv_variables:
      E_n{name}{sets}$({conditions} and t.val < tEnd.val)..
        n{name}{sets} =E= {name}{sets} + n{name}{sets}{$}[<t>t+1] * fv / (1+mrOffRente[t+1]);
      E_n{name}_tEnd{sets}$({conditions} and tEnd[t])..
        n{name}{sets} =E= @mean(tt$[tt.val > t.val-5], {name}{sets}{$}[<t>tt]) / (1 - fv / (1+mrOffRente[t]));
    $ENDLOOP

    E_vRenteMarginal[t]$(t.val <= tEnd.val)..
      vRenteMarginal[t] =E= mrOffRente[t] * (vOff13Aktx[t-1]/fv + vOff13Aktier[t-1]/fv) - vOffRenteInd[t]
                             - (mrOffRente[t] * vOff13pas[t-1]/fv - vOffRenteUd[t]);
  $ENDBLOCK

  Model M_government /
    B_government_static
    B_government_forwardlooking
    /;  
  $GROUP G_government_static
    G_government_endo
    -G_government_forwardlooking
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
    vOff13Aktx, vOff13Aktier, vOff13Pas, vOff13Net, vStatsGaeld
    vSatsIndeks, vPrisIndeks, rOblOpsp2Ovf,  vSatsIndeksx, vProgIndeks
    # Øvrige variable
    vOffDirInv
    vOEMUgaeld
    # Der er kun data for vPrimUd fra 1989
    vSaldo$(t.val >= 1989), vPrimSaldo$(t.val >= 1989), vOffOmv
  ;
  @load(G_government_makrobk, "..\Data\makrobk\makrobk.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_government_data 
    G_government_makrobk
  ;
  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_government_data_imprecise  # Variables covered by data
    vSaldo$(t.val >= 1989), vPrimSaldo$(t.val >= 1989), vOffOmv
    vOffRenteUd, vOffRenteInd, vOffNetRenter, vOffNetRenterx # Der er en lille residual i identiteten for Ti_z_o i ADAM
    vOffPas, vOff13Pas, vOffNet, vOff13Net # Små unøjagtigheder i Own_o og underkomponenter i ADAM
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  budgetfaktor.l[t] = 0.71; # Pt. sat konstant svarende til 2030-niveau selvom den varierer lidt historisk i Finansministeriets beregning af strukturel saldo. 
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
    -G_government_forwardlooking
  
    -vOffAktRenter[portf_,t], jrOffAktRenter[portf,t]$(t.val > %NettoFin_t1% and  d1vOffAkt[portf,t])
    -vOffPasRenter[portf_,t], jrOffPasRenter[portf,t]$(t.val > %NettoFin_t1% and  d1vOffPas[portf,t]) 
    -vOffAktOmv[portf_,t], jrOffAktOmv[portf,t]$(t.val > %NettoFin_t1% and  d1vOffAkt[portf,t])
    -vOffPasOmv[portf_,t], jrOffPasOmv[portf,t]$(t.val > %NettoFin_t1% and  d1vOffPas[portf,t])

    -vOffAkt[IndlAktier,t], jvOffAkt[IndlAktier,t]
    -vOffAkt[UdlAktier,t], jvOffAkt[UdlAktier,t]

    -vOffUdbytte, fvOffUdbytte

    # -vSatsIndeks, jfSatsIndeks
    -vSatsIndeks, uvSatsIndeks
    -vPrisIndeks, jfPrisIndeks
    -vSatsIndeksx, jfSatsIndeksx
    -vProgIndeks, jfProgIndeks

    -vOff13Aktx$(t.val > %NettoFin_t1%), vOff13AktxRest[t]$(t.val > %NettoFin_t1%)
    -vOff13Aktier$(t.val > %NettoFin_t1%), vOff13AktierRest[t]$(t.val > %NettoFin_t1%)

    -vOEMUgaeld, vOffPasRest
    -vStatsGaeld, vOEMUgaeldRest

    -vOffUdbytteNordsoe, uOffUdbytteNordsoe

    rOffPas2Tot[portf,t]$(t.val >= %NettoFin_t1%), -vOffPas[portf,t]$(t.val >= %NettoFin_t1%)
    vOffPas['Bank',t]$(t.val >= %NettoFin_t1%) # E_vOffPas_Bank_calib
  ;
  $GROUP G_government_static_calibration G_government_static_calibration$(tx0[t]);

  $BLOCK B_government_static_calibration
    E_vOffPas_Bank_calib[t]$(t.val >= %NettoFin_t1% and tx0[t]).. sum(portf, rOffPas2Tot[portf,t]) =E= 1;
  $ENDBLOCK

  MODEL M_government_static_calibration /
     M_government
     B_government_static_calibration
     - B_government_forwardlooking
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
    vOffAkt[Bank,tx1], -rOffAkt2BNP[Bank,tx1]
    vOffAkt[Obl,tx1], -rOffAkt2BNP[Obl,tx1]
    vOffPasRest[tx1], -rOffPasRest2BNP[tx1]
#    vOEMUgaeldRest[tx1], -rOEMUgaeldRest2BNP[tx1]

    jrOffPasRenter[portf,tx1]$(Obl[portf] or RealKred[portf] or Bank[portf]) # E_jrOffPasRenter
    jrOffAktRenter[portf,tx1]$(Obl[portf] or Bank[portf]) # E_jrOffAktRenter

    vOff13AktxRest[tx1] # E_vOff13AktxRest
    vOff13AktierRest[tx1] # E_vOff13AktierRest

    #  vtLukning[a_,t]$(aTot[a_] and t.val >= %HBI_lukning_start%) # E_vtLukning_aTot_deep, E_vtLukning_aTot_tEnd_deep
    #  rGLukning[t]$(t.val >= %HBI_lukning_start%) # E_rGLukning, E_vtLukning_aTot_tEnd
  ;
  $GROUP G_government_deep G_government_deep$(tx0[t]);
  $BLOCK B_government_deep
    E_jrOffPasRenter[portf,t]$(tx1[t] and (Obl[portf] or RealKred[portf] or Bank[portf])).. 
      rRente[portf,t] + jrOffPasRenter[portf,t] =E= rRente['Obl',t];
    E_jrOffAktRenter[portf,t]$(tx1[t] and (Obl[portf] or Bank[portf])).. 
      rRente[portf,t] + jrOffAktRenter[portf,t] =E= rRente['Obl',t];
    E_vOff13AktxRest[t]$(tx1[t]).. vOff13AktxRest[t] =E= vOff13AktxRest[t-1]/fv;
    E_vOff13AktierRest[t]$(tx1[t]).. vOff13AktierRest[t] =E= vOff13AktierRest[t-1]/fv;

  #    E_vtLukning_aTot_tEnd_deep[t]$(tEnd[t]).. vOffNet[t] / vBNP[t] =E= vOffNet[t-1] / vBNP[t-1];
  #    E_vtLukning_aTot_deep[t]$(tx0E[t] and t.val >= %HBI_lukning_start%).. tLukning[t] =E= HBI_lukning_profil[t] * tLukning[tEnd];
  #    #  E_rGLukning[t]$(tx0E[t] and t.val >= 2050).. rGLukning[t] =E= HBI_lukning_profil[t] * rGLukning[tEnd];
  $ENDBLOCK
  MODEL M_government_deep /
    M_government
    B_government_deep
  /;
$ENDIF

# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
  $GROUP G_government_dynamic_calibration
    G_government_endo
    -vOffAkt[IndlAktier,t1], jvOffAkt[IndlAktier,t1]
    -vOffAkt[UdlAktier,t1], jvOffAkt[UdlAktier,t1]
    -vOffPas[portf,t1], rOffPas2Tot[portf,t1]

    vOffAkt[Bank,tx1], -rOffAkt2BNP[Bank,tx1]
    vOffAkt[Obl,tx1], -rOffAkt2BNP[Obl,tx1]
    vOffPasRest[tx1], -rOffPasRest2BNP[tx1]
    vOff13AktxRest[tx1] # E_vOff13AktxRest
    vOff13AktierRest[tx1] # E_vOff13AktierRest

    #  vtLukning[a_,t]$(aTot[a_] and t.val >= %HBI_lukning_start%) # E_vtLukning_aTot, E_vtLukning_aTot_tEnd
  ;

  $BLOCK B_government_dynamic_calibration
    E_vOff13AktxRest[t]$(tx1[t]).. vOff13AktxRest[t] =E= vOff13AktxRest[t-1]/fv;
    E_vOff13AktierRest[t]$(tx1[t]).. vOff13AktierRest[t] =E= vOff13AktierRest[t-1]/fv;
  #    E_vtLukning_aTot_tEnd[t]$(tEnd[t]).. vOffNet[t] / vBNP[t] =E= vOffNet[t-1] / vBNP[t-1];
  #    E_vtLukning_aTot[t]$(tx0E[t] and t.val >= %HBI_lukning_start%).. tLukning[t] =E= HBI_lukning_profil[t] * tLukning[tEnd];
  $ENDBLOCK

  MODEL M_government_dynamic_calibration /
    M_government 
    B_government_dynamic_calibration
  /;
$ENDIF
