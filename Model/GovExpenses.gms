# ======================================================================================================================
# Government expenses
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_GovExpenses_variables
    # _a variables
    fHhOvf[t] "Korrektionsfaktor for overførslerindkomster, som sikrer afbalancering af aldersfordeling."
    fuOvfUbeskat[t] "Korrektionsfaktor for ubeskattede indkomstoverførsler, som sikrer afbalancering af aldersfordeling."
    fuPensIndbOP[t] "Korrektionsfaktor for obligatorisk opsparing, som sikrer afbalancering af aldersfordeling."

    vOvfUbeskat[a_,t] "Ubeskattede indkomstoverførsler pr. person (i befolkningen) fordelt på alder."
    vHhOvf[a,t] "Indkomstoverførsler til indl. hush. pr. person (i befolkningen) fordelt på alder."
    vPensIndbOP[a_,t] "Obligatorisk pensionsopsparing af overførselsindkomster."
    vOvfSkatPl[a_,t] "Skattepligtige indkomstoverførsler pr. person (i befolkningen) fordelt på alder."

    # Prices 
    pGxAfskr[t] "Deflator for offentligt forbrug fratrukket offentlige afskrivninger, Kilde: ADAM[pCoz]"
    # Tabel-variable
    pGInput[t] "Offentligt forbrugsdeflator beregnet med inputmetode, Kilde: ADAM[pCogl]"
    pGxAfskrInput[t] "Deflator for offentligt forbrug fratrukket offentlige afskrivninger beregnet med inputmetode, Kilde: ADAM[pCozgl]"
  
    # Quantities 
    qGxAfskr[t] "Offentligt forbrug fratrukket offentlige afskrivninger, Kilde: ADAM[fCoz]"
    qG[g_,t] "Offentligt forbrug, Kilde: ADAM[fCo]"
    # Tabel-variable
    qGInput[t] "Offentligt forbrug beregnet med inputmetode, Kilde: ADAM[fCogl]"
    qGxAfskrInput[t] "Offentligt forbrug fratrukket offentlige afskrivninger beregnet med inputmetode, Kilde: ADAM[fCozgl]"

    # Values 
    vGxAfskr[t] "Offentligt forbrug fratrukket offentlige afskrivninger, Kilde: ADAM[Coz]"
    vGInd[t] "Individuelt offentligt forbrug. Kilde: ADAM[coi]"
    vGKol[t] "Kollektivt offentligt forbrug. Kilde: ADAM[co]-ADAM[coi]"
    vOffPrimUd[t] "Primære offentlige udgifter, Kilde: ADAM[Tf_o_z]-ADAM[Ti_o_z]"
    vOffInv[t] "Offentlige investeringer, Kilde: ADAM[Io1]"
    vOffSub[t] "Dansk finansieret subsidier ialt, Kilde: ADAM[Spu_o]"
    vSubY[t] "Produktionssubsidier, Kilde: ADAM[Spzu]"
    vSubYRest[s_,t] "Produktionssubsidier ekskl. løntilskud, Kilde: ADAM[Spzu]-ADAM[Spzul] og imputeret branchefordeling"
    vOffUdRest[t] "Øvrige offentlige udgifter."
    vOffTilHh[t] "Residuale overførsler fra offentlig sektor til husholdningerne, Kilde: ADAM[tK_o_h]+ADAM[Tr_o_h])"
    vOvf[ovf_,t] "Sociale overførsler fra offentlig forvaltning og service til husholdninger, Kilde: ADAM[Ty_o] for underkomponenter jf. o-set."
    vOvfSkatPl[a_,t] "Skattepligtige indkomstoverførsler pr. person (i befolkningen) fordelt på alder."
    vPensIndbOP[aTot,t]
    vOvfUbeskat[a_,t] "Ubeskattede indkomstoverførsler pr. person (i befolkningen) fordelt på alder."
    vOvfSats[ovf,t] "Sociale overførsler fra offentlig forvaltning og service til husholdninger pr. person i basen (mio. kr.)"
    vGLukning[t] "Udgift til beregningsteknisk stigning i offentligt forbrug til lukning af offentlig budgetrestriktion. Indgår IKKE i offentlig saldo."
    vOffTilUdl[t] "Samlede overførsler fra offentlig sektor til udlandet, Kilde: ADAM[Tr_o_e]+ADAM[tK_o_e]"
    vOffTilVirkRest[t] "Kapitaloverførsler til selskaber (øvrige) (Tk_o_cr)"
    vOffTilHhKapRest[t] "Kapitaloverførsler til husholdningerne ekskl. skattefri efterlønspræmie (Tk_o_hr)"

    jvOvf[ovf_,t] "J-led som fanger at nogle grupper har en overførsel, men ingen modtagere. Fordeles til husholdningerne gennem fHhOvf."
    dvOvf2dnBesk[ovf_,t] "Marginal ændring i udgifter til overførsel ovf ved ændring i den samlede beskæftigelse."
    dvOvf2dnPop[ovf_,t] "Marginal ændring i udgifter til overførsel ovf ved ændring i den samlede befolkningsstørrelse."

    uvGInd[t] "Skala-parameter som bestemmer niveau for individuelt offentligt service før korrektion for demografisk træk og løn-niveau."
    uvGxAfskr[t] "Niveauparameter for vGxAfskr"

    fDemoTraek[a_,t] "Demografisk træk."
    nOvf[ovf,t] "Basen til sociale overførsler i antal 1000 personer fordelt på ordninger."

    dnOvf2dnBesk[ovf,t] "Marginal ændring i antal modtagere af overførsel ovf ved ændring i den samlede beskæftigelse."
    dnOvf2dnPop[ovf,t] "Marginal ændring i antal modtagere af overførsel ovf ved ændring i den samlede befolkningsstørrelse."
    rOffLandKoeb2BNP[t] "Nettoopkob af jord og rettigheder relativt til BNP."
    rOffTilUdlKap2BNP[t] "Kapitaloverførsler fra offentlige sektor til udlandet relativt til BNP."
    rOffTilUdlMoms2Moms[t] "Moms bidrag fra offentlig sektor til EU relativt til moms."
    rOffTilUdlBNI2BNI[t] "BNI-bidrag fra offentlig sektor til EU relativt til BNI."
    rOffTilUdlEU2BNP[t] "Øvrige overførsler fra offentlig sektor til EU relativt til BNP."
    rOffTilUdlFO2BNP[t] "Residuale overførsler fra offentlig sektor til Færøerne relativt til BNP."
    rOffTilUdlGL2BNP[t] "Residuale overførsler fra offentlig sektor til Grønland relativt til BNP."
    rOffTilUdlBistand2BNI[t] "Offentlige overførsler til udlandet relativt til BNI."
    rOffTilVirk2BNP[t] "Offentlige overførsler til selskaber relativt til BNP."
    rOffTilVirkInvesttilskud2BNP[t] "Kapitaloverførsler til selskaber (investeringstilskud) relativt til BNP."
    rOffTilHhKap2BNP[t] "Offentlige kapitaloverførsler til husholdninger relativt til BNP."
    rOffTilHhKapPraemie2BNP[t] "Skattefriefterlønspræmie relativt til BNP"
    rOffTilHhNPISH2BNP[t] "Offentlige overførsler til NPISH relativt til BNP."
    rOffTilHhTillaeg2BNP[t] "Indekstillæg relativt til BNP."
    uOffTilHhRest[t] "Skalaparameter for øvrige offentlige overførsler til husholdninger."
    rSubEU2BNP[t] "Subsidier finansieret af EU relativt til BNP."
    rSubYRest[s_,t] "Sats for produktionssubsidier ekskl. løntilskud."
    rpGxAfskr[t] "Relative laggede priser i offentligt forbrug ekskl. afskrivninger vægtet med nutidige mængder." 
  ;

  $GROUP G_GovExpenses_data_only
    vSubYPSO[t] "Produktionssubsidie vedrørende PSO (indgår i vSubYRest), Kilde: ADAM[Spzupso]"
  ;

  $GROUP G_GovExpenses_ARIMA_forecast
    uG[g_,t] "Skalaparameter i det offentlige forbrugsnest."
    fvPensIndbOP[t] "Korrektionsfaktor for obligatorisk opsparing."
  ;
  $GROUP+ G_ARIMA_forecast G_GovExpenses_ARIMA_forecast;
  
  $GROUP G_GovExpenses_constants
      eG[g_] "Substitutionselasticitet mellem forskellige grupper af offentligt forbrug."
  ;
  $GROUP+ G_constants G_GovExpenses_constants;

  $GROUP G_GovExpenses_fixed_forecast
    rGLukning[t] "Beregningsteknisk stigning i offentligt forbrug til lukning af offentlig budgetrestriktion."
    uvGKol[t] "Skalaparameter for kollektivt offentligt forbrug."
    uvGInd[t]

    fpGInput[t] "Korrektionsfaktor. Fremskrives uændret til tabelvariabel pGInput"
    rOffTilUdlBNI2BNI
    rOffTilVirk2BNP
    rOffTilVirkInvesttilskud2BNP
    rOffTilHhKap2BNP
    rOffTilHhKapPraemie2BNP
    rOffTilHhNPISH2BNP
    rOffLandKoeb2BNP
    rSubEU2BNP
    rOffTilHhTillaeg2BNP
    rOffTilUdlBistand2BNI
    rOffTilUdlGL2BNP
    rOffTilUdlFO2BNP
    rOffTilUdlKap2BNP
    rOffTilUdlEU2BNP
    rOffTilUdlMoms2Moms
  ;
  $GROUP+ G_fixed_forecast G_GovExpenses_fixed_forecast;

  $GROUP G_GovExpenses_newdata_forecast
    uvOvfSats[ovf,t]$(satsreg[ovf] or prisreg[ovf] or intro[ovf] or oblpens[ovf] or loenreg[ovf]) "Skalaparameter for overførselssatser."
    uOffTilHhRest
    uHhOvfPop[a,t] "Aldersmæssig fordelingsnøgle knyttet til dvOvf2dnPop."
    uOvfUbeskat[a,t] "Aldersmæssig fordelingsnøgle knyttet til vOvfUbeskat."
    vOvfSats[ovf,t]
    vOvfUbeskat[a_,t]
    rSubYRest[s_,t]
  ;
  $GROUP+ G_newdata_forecast G_GovExpenses_newdata_forecast;

  $GROUP G_GovExpenses_calibrated_forecast
    vOffLandKoeb[t] "Den offentlige sektors nettoopkøb af jord og rettigheder, Kilde: ADAM[Izn_o]"  
    vOffTilUdlKap[t] "Kapitaloverførsler fra offentlig sektor til udlandet, Kilde: ADAM[tK_o_e]"  
    vOffTilUdlMoms[t] "Momsbidrag fra offentlig sektor til EU, Kilde: ADAM[Trg_o_eu] "  
    vOffTilUdlBNI[t] "BNI-bidrag fra offentlig sektor til EU, Kilde: ADAM[Try_o_eu] "  
    vOffTilUdlEU[t] "Øvrige overførsler fra offentlig sektor til EU, Kilde: ADAM[Trr_o_eu] "  
    vOffTilUdlFO[t] "Residuale overførsler fra offentlig sektor til Færøerne, Kilde: ADAM[Tr_o_ef] "  
    vOffTilUdlGL[t] "Residuale overførsler fra offentlig sektor til Grønland, Kilde: ADAM[Tr_o_eg] "  
    vOffTilUdlBistand[t] "Udlandsbistand mv., Kilde: ADAM[Trr_o_e] "  
    vOffTilVirk[t] "Residuale overførsler fra offentlig sektor til indenlandske selskaber, Kilde: ADAM[tK_o_c]"  
    vOffTilVirkInvesttilskud[t] "Kapitaloverførsler til selskaber (investeringstilskud) (Tk_o_ci)"  
    vOffTilHhKap[t] "Residuale kapitaloverførsler fra offentlig sektor til husholdningerne, Kilde: ADAM[tK_o_h])"  
    vOffTilHhKapPraemie[t] "Skattefri efterlønspræmie til husholdningerne (Tk_o_hsp))"  
    vOffTilHhNPISH[t] "Residuale øvrige overførsler fra offentlig sektor til NPISH, Kilde: ADAM[Tr_o_hnpis])"  
    vOffTilHhTillaeg[t] "Indekstillæg, Kilde: ADAM[Typi])"  
    vOffTilHhRest[t] "Residuale øvrige overførsler fra offentlig sektor til husholdningerne, Kilde: ADAM[Trr_o_h])"  
    vSubEU[t] "Subsider finansieret af EU, Kilde: ADAM[Spueu]"  
  ;

  $GROUP G_GovExpenses_exogenous_forecast
    fDemoTraek[a_,t]$(not aTot[a_]) "Demografisk træk."
    fDemoTraek_Over100[t] "Demografisk træk for personer over 100år"

    rPensAlder[a,t] "Andel i folkepensionsalderen (0, 0.5, eller 1)."
    rEfterlAlder[a,t] "Andel i efterlønsalderen (0, 0.5, eller 1)."
    nOvf2nSoc[ovf_,soc,t] "Mapping mellem modtagere af overførsler og BFR-grupper."
    vNulvaekstIndeks[t] "Nulvækstindeks er 1 i en ikke-vækst- og inflationskorrigeret bank - og modsvarer ellers korrektion"
    uPensIndbOP[a,t] "Skalaparameter for obligatorisk opsparing."
  ;
  $GROUP+ G_exogenous_forecast G_GovExpenses_exogenous_forecast$(tx1[t]);

  $GROUP G_GovExpenses_forecast_as_zero
    jvOvf
    uvOvfSats[ovf,t]$(sameas['groen',ovf])
    uHhOvfRest[a,t] "Residual som sikrer at samlede overførselsindkomster til en aldersgruppe passer til aldersprofil."
  ;
  $GROUP+ G_forecast_as_zero G_GovExpenses_forecast_as_zero$(tx1[t]);
$ENDIF

# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_GovExpenses_static G_GovExpenses_static$(tx0[t])
    # ----------------------------------------------------------------------------------------------------------------------
    # Offentligt forbrug
    # ----------------------------------------------------------------------------------------------------------------------
    .. vGxAfskr[t] =E= vG[gTot,t] - vOffAfskr[kTot,t];

    $(t.val >= %BFR_t1%)..  fDemoTraek[aTot,t] =E= sum(a, nPop[a,t] * fDemoTraek[a,t]) + nPop_Over100[t] * fDemoTraek_Over100[t];

    # Kollektivt offentligt forbrug følger løn og befolkningstal. Det individuelle følger demografi og løn
    uvGxAfskr[t].. vGxAfskr[t] =E= uvGxAfskr[t] * vhW_DA[t];
    uvGInd[t]$(t.val >= %BFR_t1%)..
      uvGxAfskr[t] =E= (uvGKol[t] * nPopInklOver100[t] + uvGInd[t] * fDemoTraek[aTot,t]) * (1+rGLukning[t]);

    vGInd[t].. vG[gTot,t] =E= vGKol[t] + vGInd[t];
    vGKol[t]$(t.val >= %BFR_t1%)..
      vGKol[t] / vGInd[t] =E= uvGKol[t] * nPopInklOver100[t] / (uvGInd[t] * fDemoTraek[aTot,t]);

    # CES demand
    # there is currently only one type of government consumption, i.e. qG['gTot'] = qG['g'] 
    $(not gTot[g_])..  qG[g_,t] =E= uG[g_,t] * qG[gTot,t] * (pG[gTot,t] / pG[g_,t])**eG(gTot);

    # A technical adjustment to government spending can be used to close the government intertemporal budget constraint
    .. vGLukning[t] =E= rGLukning[t] / (1+rGLukning[t]) * vGxAfskr[t];

    # Tabel-variable -kan rykkes til konjunktur.gms
    rpGxAfskr[t].. qGxAfskr[t] =E=  rpGxAfskr[t] * (qG[gTot,t] - qOffAfskr[kTot,t]);
    ..
      qGxAfskr[t] * pGxAfskr[t-1]/fp =E= pG[gTot,t-1]/fp * qG[gTot,t] - pOffAfskr[kTot,t-1]/fp * qOffAfskr[kTot,t];
    .. pGxAfskr[t] * qGxAfskr[t] =E= vGxAfskr[t];

    # Input-baseret offentligt forbrug (tabel-variabel)
    .. pGInput[t] =E= fpGInput[t] * pG[gTot,t] / pY['off',t] * pYOffInput[t];
    .. qGInput[t] * pGInput[t] =E= vG[gTot,t];
    ..
      qGxAfskrInput[t] * pGxAfskrInput[t-1]/fp =E= pGInput[t-1]/fp * qGInput[t] 
                                                     - pOffAfskr[kTot,t-1]/fp * qOffAfskr[kTot,t];
    .. pGxAfskrInput[t] * qGxAfskrInput[t] =E= vGxAfskr[t];

    # ----------------------------------------------------------------------------------------------------------------------
    # Primære offentlige udgifter
    # ----------------------------------------------------------------------------------------------------------------------
    .. vOffPrimUd[t] =E= vG[gTot,t]
                       + vOvf['tot',t]
                       + vOffInv[t]
                       + vOffSub[t]
                       + vOffUdRest[t]
                       - vGLukning[t];

    # Indkomstoverførsler - satser
    $(t.val >= %BFR_t1%).. vOvfSats[loenreg,t] =E= vLoenIndeks[t] * uvOvfSats[loenreg,t];

    $(t.val >= %BFR_t1%).. vOvfSats[oblpens,t] =E= vSatsIndeksx[t] * uvOvfSats[oblpens,t];

    $(t.val >= %BFR_t1%).. vOvfSats[satsreg,t] =E= vSatsIndeks[t] * uvOvfSats[satsreg,t];

    $(t.val >= %BFR_t1%).. vOvfSats[prisreg,t] =E= vPrisIndeks[t] * uvOvfSats[prisreg,t];

    $(t.val >= %BFR_t1%).. vOvfSats[ureguleret,t] =E= vNulvaekstIndeks[t] * uvOvfSats[ureguleret,t];

    # Det er ikke klart om introduktionsydelse skal følge vSatsIndeks eller vSatsIndeksx efter 2030
    $(t.val >= %BFR_t1%).. vOvfSats[intro,t] =E= vSatsIndeks[t] * uvOvfSats[intro,t];

    # Antal modtagere af overførsler knyttet til sociogrupper
    $((not (ovf_a0t17[ovf] or ovf_a18t100[ovf]) and t.val >= %BFR_t1%))..
      nOvf[ovf,t] =E= sum(soc, nOvf2nSoc[ovf,soc,t] * nSoc[soc,t]);

    # Overførsler som fordeles på alle under 18
    nOvf&_a0t17[ovf,t]$(ovf_a0t17[ovf] and t.val >= %BFR_t1%).. nOvf[ovf,t] =E= nPop['a0t17',t];

    # Overførsler som fordeles på alle over 18
    nOvf&_a18t100[ovf,t]$(ovf_a18t100[ovf] and t.val >= %BFR_t1%).. nOvf[ovf,t] =E= nPop['a18t100',t];

    # Indkomstoverførsler - samlet udgift fordelt på overførselstype
    $(t.val >= %BFR_t1% and not sameas['iskatpl',ovf])..
      vOvf[ovf,t] =E= vOvfSats[ovf,t] * nOvf[ovf,t] + jvOvf[ovf,t];
    # Overførslerne ovenfor er opgjort ekslusiv bidrag til obligatorisk opsparing.
    # De samlede bidrag til obligatorisk opsparing indgår istedet i residual-posten øvrige ikke-skattepligtige overførsler.
    $(t.val >= %BFR_t1%)..
      vOvf['iskatpl',t] =E= vOvfSats['iskatpl',t] * nOvf['iskatpl',t] + vPensIndbOP[aTot,t] + jvOvf['iskatpl',t];

    # Obligatorisk opsparing følger overførsler i oblpens
    $(t.val >= 2020).. vPensIndbOP[aTot,t] =E= fvPensIndbOP[t] * rOblOpsp2Ovf[t] * sum(oblpens, vOvf[oblpens,t]);

    $(t.val >= %BFR_t1%).. jvOvf['tot',t] =E= sum(ovf, jvOvf[ovf,t]);

    $(t.val >= %BFR_t1%).. vOvf['tot',t] =E= sum(ovf, vOvf[ovf,t]);
    $(t.val >= %BFR_t1%).. vOvf['HhTot',t]  =E= sum(ovfHh, vOvf[ovfHh,t]);

    $(t.val >= %BFR_t1%).. vOvf['a18t100',t] =E= sum(ovf_a18t100, vOvf[ovf_a18t100,t]) / nPop['a18t100',t];

    $(t.val >= %BFR_t1%).. vOvf['a0t17',t] =E= sum(ovf_a0t17, vOvf[ovf_a0t17,t]) / nPop['a0t17',t];

    # Antallet af overførselsmodtager følger befolkningsstørrelsen samt beskæftigelsen
    # dnOvf2dnBesk og dnOvf2dnPop kan gøres eksogene for at spare beregning
    $(t.val >= %BFR_t1%).. dnOvf2dnBesk[ovf,t] =E= sum(soc, dSoc2dBesk[soc,t] * nOvf2nSoc[ovf,soc,t]);
    $(t.val >= %BFR_t1%)..
      dnOvf2dnPop[ovf,t] =E= sum(soc, (dSoc2dPop[soc,t] + jnSoc[soc,t] / nPop['a15t100',t]) * nOvf2nSoc[ovf,soc,t]);

    # Indkomstoverførsler følger antallet af modtagere
    .. dvOvf2dnBesk[ovf,t] =E= vOvfSats[ovf,t] * dnOvf2dnBesk[ovf,t];
    .. dvOvf2dnBesk['HhTot',t] =E= sum(ovfHh, dvOvf2dnBesk[ovfHh,t]);

    $(t.val >= %BFR_t1%).. dvOvf2dnPop[ovf,t] =E= vOvfSats[ovf,t] * dnOvf2dnPop[ovf,t];
    $(t.val >= %BFR_t1%).. dvOvf2dnPop['HhTot',t] =E= sum(ovfHh, dvOvf2dnPop[ovfHh,t]);

    # Opdeling af ubeskattede og skattepligtige overførsler
    $(t.val >= %BFR_t1%).. vOvfUbeskat[aTot,t] =E= sum(ubeskat, vOvf[ubeskat,t]);

    $(t.val >= %BFR_t1%).. vOvfSkatPl[aTot,t] =E= vOvf['HhTot',t] - vOvfUbeskat[aTot,t];

    # Offentlige investeringer
    .. vOffInv[t] =E= vI_s[iTot,'off',t];

    # Subsidier
    .. vOffSub[t] =E= vSub[dTot,sTot,t] + vSubY[t] - vSubEU[t];
    .. vSubYRest[s,t] =E= rSubYRest[s,t] * vY[s,t];
    rSubYRest[sTot,t].. vSubYRest[sTot,t] =E= rSubYRest[sTot,t] * vY[sTot,t];
    .. vSubYRest[sTot,t] =E= sum(s, vSubYRest[s,t]);
    .. vSubY[t] =E= vSubLoen[sTot,t] + vSubYRest[sTot,t];
    rSubEU2BNP[t].. vSubEU[t] =E= vBNP[t] * rSubEU2BNP[t];

    # Øvrige offentlige udgifter
    .. vOffUdRest[t] =E= vOffLandKoeb[t] + vOffTilUdl[t] + vOffTilHh[t] + vOffTilVirk[t];

    rOffLandKoeb2BNP[t].. vOffLandKoeb[t] =E= vBNP[t] * rOffLandKoeb2BNP[t];

    .. vOffTilUdl[t] =E= vOffTilUdlKap[t] + vOffTilUdlMoms[t] + vOffTilUdlBNI[t] + vOffTilUdlEU[t]
                      + vOffTilUdlFO[t] + vOffTilUdlGL[t] + vOffTilUdlBistand[t];
    rOffTilUdlKap2BNP[t].. vOffTilUdlKap[t] =E= vBNP[t] * rOffTilUdlKap2BNP[t];
    rOffTilUdlMoms2Moms[t].. vOffTilUdlMoms[t] =E= vtMoms[dTot,sTot,t] * rOffTilUdlMoms2Moms[t];
    rOffTilUdlBNI2BNI[t].. vOffTilUdlBNI[t] =E= vBNI[t] * rOffTilUdlBNI2BNI[t];
    rOffTilUdlEU2BNP[t].. vOffTilUdlEU[t] =E= vBNP[t] * rOffTilUdlEU2BNP[t];
    rOffTilUdlFO2BNP[t].. vOffTilUdlFO[t] =E= vBNP[t] * rOffTilUdlFO2BNP[t];
    rOffTilUdlGL2BNP[t].. vOffTilUdlGL[t] =E= vBNP[t] * rOffTilUdlGL2BNP[t];
    rOffTilUdlBistand2BNI[t].. vOffTilUdlBistand[t] =E= vBNI[t] * rOffTilUdlBistand2BNI[t];

    vOffTilHh[t].. vOffTilHh[t] =E= vOffTilHhKap[t] + vOffTilHhNPISH[t] + vOffTilHhTillaeg[t] + vOffTilHhRest[t];
    rOffTilHhNPISH2BNP[t].. vOffTilHhNPISH[t] =E=  vBNP[t] * rOffTilHhNPISH2BNP[t];
    rOffTilHhTillaeg2BNP[t].. vOffTilHhTillaeg[t] =E= vBNP[t] * rOffTilHhTillaeg2BNP[t];
    uOffTilHhRest[t].. vOffTilHhRest[t] =E= uOffTilHhRest[t] * vSatsindeks[t] * nPopInklOver100[t];

    vOffTilHhKapRest[t].. vOffTilHhKap[t] =E= vOffTilHhKapPraemie[t] + vOffTilHhKapRest[t];
    rOffTilHhKap2BNP[t].. vOffTilHhKap[t] =E= vBNP[t] * rOffTilHhKap2BNP[t];
    rOffTilHhKapPraemie2BNP[t].. vOffTilHhKapPraemie[t] =E= rOffTilHhKapPraemie2BNP[t] * vBNP[t];

    vOffTilVirkRest[t].. vOffTilVirk[t] =E= vOffTilVirkInvesttilskud[t] + vOffTilVirkRest[t];
    rOffTilVirk2BNP[t].. vOffTilVirk[t] =E= rOffTilVirk2BNP[t] * vBNP[t];
    rOfftilVirkInvesttilskud2BNP[t].. vOffTilVirkInvesttilskud[t] =E= rOfftilVirkInvesttilskud2BNP[t] * vBNP[t];
  $ENDBLOCK

  # $BLOCK B_GovExpenses_forwardlooking
  # $ENDBLOCK

  $BLOCK B_GovExpenses_a G_GovExpenses_a$(tx0[t])
    # Korrektionsfaktor som sikre afbalancering af overførsler-indkomster fordelt på henholdsvis alder og overførselstype.
    fHhOvf[t]$(t.val > %AgeData_t1%).. vOvf['HhTot',t] =E= sum(a, vHhOvf[a,t] * nPop[a,t]);

    # Aldersfordelte indkomstoverførsler
    $(a15t100[a] and t.val > %AgeData_t1%)..
      vHhOvf[a,t] =E= (  dvOvf2dnBesk['HhTot',t] * nLHh[a,t] / nPop[a,t]
                       + dvOvf2dnPop['HhTot',t] * uHhOvfPop[a,t]
                       + vOvf['a0t17',t] * rBoern[a,t]
                       + vOvf['a18t100',t]$(a18t100[a])
                       + jvOvf['tot',t] / nPop['a15t100',t]
                       + uHhOvfRest[a,t] * vSatsIndeks[t]
                     ) * fHhOvf[t];

    $(a0t100[a] and t.val > %AgeData_t1%).. vOvfUbeskat[a,t] =E= fuOvfUbeskat[t] * uOvfUbeskat[a,t] * vOvfUbeskat[aTot,t];

    fuOvfUbeskat[t]$(t.val > %AgeData_t1%).. vOvfUbeskat[aTot,t] =E= sum(a, vOvfUbeskat[a,t] * nPop[a,t]);

    $(t.val > %AgeData_t1% and a0t100[a]).. vOvfSkatPl[a,t] =E= vHhOvf[a,t] - vOvfUbeskat[a,t];

    # Aldersfordeling af obligatoriske pensionsindbetalinger holdes konstant ved stød - kan klart modelleres bedre
    $(a15t100[a] and t.val >= 2020).. vPensIndbOP[a,t] =E= fuPensIndbOP[t] * uPensIndbOP[a,t] * vPensIndbOP[aTot,t];
    
    fuPensIndbOP[t]$(t.val >= 2020).. vPensIndbOP[aTot,t] =E= sum(a, vPensIndbOP[a,t] * nPop[a,t]);
  $ENDBLOCK

   $GROUP  G_GovExpenses_endo 
    G_GovExpenses_static
    G_GovExpenses_a   
   ;

  MODEL M_GovExpenses /
    B_GovExpenses_static
    B_GovExpenses_a
  /;
  model M_base / M_GovExpenses /;


  model M_static / B_GovExpenses_static /;
  $GROUP+ G_static G_GovExpenses_static;
  $GROUP+ G_Endo G_GovExpenses_endo;

$ENDIF

$IF %stage% == "exogenous_values":
# ======================================================================================================================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_GovExpenses_makrobk
    # Offentlige udgifter
    vG$(gTot[g_]),vGInd, vGKol, vOffSub, vSubY, vSubEU, vSubYRest, vSubYPSO
    vOffLandKoeb, vOffTilUdlKap, vOffTilUdlMoms, vOffTilUdlBNI, vOffTilUdlEU, vOffTilUdlFO, vOffTilUdlGL, vOffTilUdl 
    vOffTilUdlBistand, vOffTilVirk, vOffTilHhKap, vOffTilHhNPISH, vOffTilHhTillaeg, vOffTilHhRest
    vOvf$(ovf[ovf_] or HhTot[ovf_] or ovftot[ovf_])
    vOffPrimUd$(t.val > 2006)
    vOffInv$(t.val > 2006)
    # Øvrige variable
    qG, qGInput, qGxAfskr, qGxAfskrInput
    pGInput, pGxAfskr, pGxAfskrInput
    nOvf[ovfFraMAKROBK]
    vPensIndbOP[aTot,t]
  ;
  @load(G_GovExpenses_makrobk, "../Data/Makrobk/makrobk.gdx" )

  execute_load "../Data/FM_exogenous_forecast.gdx" vOffTilVirkInvesttilskud.l=vOffTilVirk_investeringstilskud.l
  execute_load "../Data/FM_exogenous_forecast.gdx" vOffTilHhKapPraemie.l=vOffTilHhKap_praemie.l
  $GROUP G_GovExpenses_FM vOffTilVirkInvesttilskud, vOffTilHhKapPraemie;

  # Demografisk træk
  $GROUP G_GovExpenses_DemoTraek
    fDemoTraek
    fDemoTraek_Over100
  ;
  $IF2 %DREAM_baseline% or %DORS_baseline%:
    @load(G_GovExpenses_DemoTraek, "../Data/DREAM_BFR/DemoTraek.gdx" )
  $ENDIF2
  $IF2 %FM_baseline%:
    @load(G_GovExpenses_DemoTraek, "../Data/Befolkningsregnskab/DemoTraek.gdx" )
  $ENDIF2

  # Aldersfordelt data fra aldersprofiler indlæses
  $GROUP G_GovExpenses_aldersprofiler
    vHhOvf$(t.val >= %AgeData_t1%)
  ;
  @load(G_GovExpenses_aldersprofiler, "../Data/Aldersprofiler/aldersprofiler.gdx" )

  # Aldersfordelte parametre fra BFR indlæses
  parameters 
    nOvf_a[ovf_,a_,t] "Modtager-grupper fordelt på alder, antal 1.000 personer"
    nOvfFraSocResidual[ovf_,a_,t] "Residualeffekt fra befolkning på modtager-gruppe fordelt på alder, antal 1.000 personer"
  ;
  $GDXIN ../Data/Befolkningsregnskab/BFR.gdx
    $LOAD nOvf_a, nOvfFraSocResidual
  $GDXIN
  $GROUP G_GovExpenses_BFR
    nPop, rPensAlder, rEfterlAlder, nOvf2nSoc
  ;
  @load(G_GovExpenses_BFR, "../Data/Befolkningsregnskab/BFR.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_GovExpenses_data
    G_GovExpenses_makrobk
    G_GovExpenses_BFR
    G_GovExpenses_FM
    jvOvf$(t.val >= %BFR_t1% and not ovftot[ovf_])
  ;

  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_GovExpenses_data_imprecise
    vOffPrimUd$(t.val > 2006)
    vOffSub
    vSubYRest, vSubY
    vOffInv$(t.val > 2006)
    vOvf$(ovftot[ovf_] or sameas['pension',ovf_])
    jvOvf$(sameas[ovf_,'pension'])
    vOffTilUdl$(t.val = 1994)
    vOffTilUdl$(t.val = 1993)
    vOffTilUdl$(t.val = 1992)
    vOffTilUdl$(t.val = 1991)
    qGxAfskr, qGxAfskrInput, pGxAfskrInput
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  vNulvaekstIndeks.l[t] = 1;
  eG.l[g_] = 0; # Elasticitet mellem grupper af offentlig forbrug sættes til 0 som standard. 
  rGLukning.l[t] = 0;

  # Balanceringsmekanismer sættes til 1 i år hvor aldersfordeling kalibreres
  fHhOvf.l[t] = 1;
  fuOvfUbeskat.l[t] = 1;
  fuPensIndbOP.l[t] = 1;

# ======================================================================================================================
# Data management
# ======================================================================================================================
  # Nogle grupper har en overførsel, men ingen modtagere - ryger i j-led, som ellers sættes til 0
  jvOvf.l[ovf,t] = vOvf.l[ovf,t]$(nOvf_a[ovf,aTot,t] = 0);

  # Antager ens satser fordelt på alder - modtagergrupper tages fra BFR beregnet under data.gms
  vOvfSats.l[ovf,t]$(nOvf_a[ovf,aTot,t] <> 0) = (vOvf.l[ovf,t] - vPensIndbOP.l[aTot,t]$sameas[ovf,'iskatpl']) / nOvf_a[ovf,aTot,t];
  uHhOvfPop.l[a,t]$(a15t100[a] and t.val >= %BFR_t1% and t.val <= %cal_end%) =          
    sum(ovfHh, vOvfSats.l[ovfHh,t] * nOvfFraSocResidual[ovfHh,a,t]) / nPop.l[a,t]  # Samlede overførsler pr. person i alder a, som ikke afhænger af beskæftigelsesfrekvens
  / sum(ovfHh, vOvfSats.l[ovfHh,t] * nOvfFraSocResidual[ovfHh,aTot,t]) * nPop.l['a15t100',t];  # Samlede overførsler i alt, som ikke afhænger af beskæftigelsesfrekvens

  # Obligatorisk pensionsopsparing antages at være fordelt proportionalt med overførslerne med obligatorisk pensionsopsparing.
  vPensIndbOP.l[a,t]$(nPop.l[a,t] <> 0 and vPensIndbOP.l[aTot,t] <> 0)
    = sum(oblpens, vOvfSats.l[oblpens,t] * nOvf_a[oblpens,a,t]) / nPop.l[a,t]
    / sum(oblpens, vOvfSats.l[oblpens,t] * nOvf_a[oblpens,aTot,t]) * vPensIndbOP.l[aTot,t];

  # Ubeskattede overførsler pr. person følger ordningerne
  vOvfUbeskat.l[a,t]$(nPop.l[a,t] and a0t100[a])
    = sum(ubeskat, vOvfSats.l[ubeskat,t] * nOvf_a[ubeskat,a,t]) / nPop.l[a,t] + vPensIndbOP.l[a,t];

  # nOvf = eps giver square-fejl, som ikke opstår ved 0 - skal undersøges og rettes!
  nOvf.l[ovf,t]$(nOvf.l[ovf,t] = eps) = 0;
  vOffTilHhRest.l[t]$(t.val <= 1988) = 0; # Vi har ikke data fra 1985-1988 for denne variable er igang med at tale med Grane ift. pinne det ned. 

  # Hvis en celle er tom, så svarer det til koefficienten er 0 - udnyttes her, da vi ellers får problemer med celler, der opstår efter det dybe kalibreringsår 
  nOvf2nSoc.l[ovf,soc,t]$(mapVal(nOvf2nSoc.l[ovf,soc,t]) = 5) = eps;
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_GovExpenses_static_calibration_base
    G_GovExpenses_endo
    -qG[g,t], uG
    -vOvf[ovf,t], uvOvfSats[ovf,t]$(nOvf_a[ovf,aTot,t] > 0), jvOvf[ovf,t]$(nOvf_a[ovf,aTot,t] = 0)
    -vOvfUbeskat[a,t], uOvfUbeskat[a,t]
    rSubYRest[s,t], -vSubYRest[s,t]
    -vGKol, uvGKol
    -pGInput, fpGInput
    -vPensIndbOP[aTot,t], fvPensIndbOP[t]
    -vPensIndbOP[a,t], uPensIndbOP[a,t]
  ;

  $GROUP G_GovExpenses_static_calibration_newdata
    G_GovExpenses_static_calibration_base$(tx0[t]),
    G_GovExpenses_endo$(not tx0[t]) # Nutidsværdier til HBI beregnes før t1
    - G_GovExpenses_a
  ;
  $GROUP+ G_static_calibration_newdata G_GovExpenses_static_calibration_newdata;

  $GROUP G_GovExpenses_static_calibration
    G_GovExpenses_static_calibration_base
    -vHhOvf, uHhOvfRest$(t.val > %AgeData_t1%)
    -fHhOvf # -E_fHhOvf
    -fuPensIndbOP # - E_fuPensIndbOP
    -fuOvfUbeskat # - E_fuOvfUbeskat
  ;
  $GROUP G_GovExpenses_static_calibration 
    G_GovExpenses_static_calibration$(tx0[t])
  ;

  MODEL M_GovExpenses_static_calibration /
    M_GovExpenses
    # B_GovExpenses_static_calibration
    - E_fHhOvf
    - E_fuPensIndbOP
    - E_fuOvfUbeskat
  /;
  model M_static_calibration / M_GovExpenses_static_calibration /;
  $GROUP+ G_static_calibration G_GovExpenses_static_calibration;
$ENDIF

# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_GovExpenses_deep
    G_GovExpenses_endo
    -rOffLandKoeb2BNP, vOffLandKoeb
    -rOffTilUdlKap2BNP, vOffTilUdlKap
    -rOffTilUdlMoms2Moms, vOffTilUdlMoms
    -rOffTilUdlBNI2BNI, vOffTilUdlBNI
    -rOffTilUdlEU2BNP, vOffTilUdlEU
    -rOffTilUdlFO2BNP, vOffTilUdlFO
    -rOffTilUdlGL2BNP, vOffTilUdlGL
    -rOffTilUdlBistand2BNI, vOffTilUdlBistand
    -rOffTilVirk2BNP, vOffTilVirk
    -rOffTilVirkInvesttilskud2BNP, vOffTilVirkInvesttilskud
    -rOffTilHhKap2BNP, vOffTilHhKap
    -rOffTilHhKapPraemie2BNP, vOffTilHhKapPraemie
    -rOffTilHhNPISH2BNP, vOffTilHhNPISH
    -rOffTilHhTillaeg2BNP, vOffTilHhTillaeg
    -uOffTilHhRest, vOffTilHhRest
    -rSubEU2BNP, vSubEU
    hL[off,tx1], -uvGxAfskr[tx1]$(%FM_baseline%), -uvGInd[tx1]$(%DREAM_baseline% or %DORS_baseline%)
  ;
  $GROUP G_GovExpenses_deep G_GovExpenses_deep$(tx0[t]);

#  $BLOCK B_Govexpenses_deep
#  $ENDBLOCK

  MODEL M_GovExpenses_deep /
    M_GovExpenses
    #  B_Govexpenses_deep
  /;
  model M_deep_dynamic_calibration / M_GovExpenses_deep /;
  $GROUP+ G_deep_dynamic_calibration G_GovExpenses_deep;

$ENDIF

# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
$GROUP G_GovExpenses_dynamic_calibration
  G_GovExpenses_endo
  -rOffLandKoeb2BNP, vOffLandKoeb
  -rOffTilUdlKap2BNP, vOffTilUdlKap
  -rOffTilUdlMoms2Moms, vOffTilUdlMoms
  -rOffTilUdlBNI2BNI, vOffTilUdlBNI
  -rOffTilUdlEU2BNP, vOffTilUdlEU
  -rOffTilUdlFO2BNP, vOffTilUdlFO
  -rOffTilUdlGL2BNP, vOffTilUdlGL
  -rOffTilUdlBistand2BNI, vOffTilUdlBistand
  -rOffTilVirk2BNP, vOffTilVirk
  -rOffTilHhKap2BNP, vOffTilHhKap
  -rOffTilHhNPISH2BNP, vOffTilHhNPISH
  -rOffTilHhTillaeg2BNP, vOffTilHhTillaeg
  -uOffTilHhRest, vOffTilHhRest
  -rSubEU2BNP, vSubEU
  hL[off,tx1], -uvGxAfskr[tx1]$(%FM_baseline%), -uvGInd[tx1]$(%DREAM_baseline% or %DORS_baseline%)
  nOvf2nSoc[ovf,soc,t]$(tx1[t] and (nOvf2nSoc.l[ovf,soc,'%cal_deep%'] = eps)) # E_nOvf2nSoc
;
$GROUP G_GovExpenses_dynamic_calibration G_GovExpenses_dynamic_calibration$(tx0[t]);
$BLOCK B_Govexpenses_dynamic_calibration
  E_nOvf2nSoc[ovf,soc,t]$(tx1[t] and (nOvf2nSoc.l[ovf,soc,'%cal_deep%'] = eps)).. 
    nOvf2nSoc[ovf,soc,t] =E= nOvf2nSoc[ovf,soc,t1];
$ENDBLOCK
MODEL M_GovExpenses_dynamic_calibration /
  M_GovExpenses
  B_Govexpenses_dynamic_calibration
/;
  model M_dynamic_calibration_newdata / M_GovExpenses_dynamic_calibration /;
$GROUP+ G_dynamic_calibration_newdata G_GovExpenses_dynamic_calibration;
$ENDIF
