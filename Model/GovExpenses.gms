# ======================================================================================================================
# Government expenses
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_GovExpenses_prices_endo
    pGxAfskr[t]$(tx0[t]) "Deflator for offentligt forbrug fratrukket offentlige afskrivninger, Kilde: ADAM[pCoz]"
    # Tabel-variable
    pG_input[t] "Offentligt forbrugsdeflator beregnet med inputmetode, Kilde: ADAM[pCogl]"
    pGxAfskr_input[t] "Deflator for offentligt forbrug fratrukket offentlige afskrivninger beregnet med inputmetode, Kilde: ADAM[pCozgl]"
  ;
  $GROUP G_GovExpenses_quantities_endo
    qGxAfskr[t] "Offentligt forbrug fratrukket offentlige afskrivninger, Kilde: ADAM[fCoz]"
    qG[g_,t]$(not gTot[g_]) "Offentligt forbrug, Kilde: ADAM[fCo]"
    # Tabel-variable
    qG_input[t] "Offentligt forbrug beregnet med inputmetode, Kilde: ADAM[fCogl]"
    qGxAfskr_input[t] "Offentligt forbrug fratrukket offentlige afskrivninger beregnet med inputmetode, Kilde: ADAM[fCozgl]"
  ;
  $GROUP G_GovExpenses_values_a_endo
    vOvfUbeskat[a_,t]$(a0t100[a_] and t.val > %AgeData_t1%) "Ubeskattede indkomstoverførsler pr. person (i befolkningen) fordelt på alder."
    vHhOvf[a,t]$(a15t100[a] and t.val > %AgeData_t1%) "Indkomstoverførsler til indl. hush. pr. person (i befolkningen) fordelt på alder."
    vOvfSkatPl[a_,t]$(t.val > %AgeData_t1% and not aTot[a_]) "Skattepligtige indkomstoverførsler pr. person (i befolkningen) fordelt på alder."
  ;
  $GROUP G_GovExpenses_values_endo
    G_GovExpenses_values_a_endo

    vGxAfskr[t] "Offentligt forbrug fratrukket offentlige afskrivninger, Kilde: ADAM[Coz]"
    vG_ind[t] "Individuelt offentligt forbrug. Kilde: ADAM[coi]"
    vG_kol[t]$(t.val >= %BFR_t1%) "Kollektivt offentligt forbrug. Kilde: ADAM[co]-ADAM[coi]"
    vOffPrimUd[t] "Primære offentlige udgifter, Kilde: ADAM[Tf_o_z]-ADAM[Ti_o_z]"
    vOffInv[t] "Offentlige investeringer, Kilde: ADAM[Io1]"
    vOffSub[t] "Dansk finansieret subsidier ialt, Kilde: ADAM[Spu_o]"
    vSubY[t] "Produktionssubsidier, Kilde: ADAM[Spzu]"
    vSubYRest[s_,t]$(sTot[s_] or s[s_]) "Produktionssubsidier ekskl. løntilskud, Kilde: ADAM[Spzu]-ADAM[Spzul] og imputeret branchefordeling"
    vOffUdRest[t] "Øvrige offentlige udgifter."
    vOffTilHh[t] "Residuale overførsler fra offentlig sektor til husholdningerne, Kilde: ADAM[tK_o_h]+ADAM[Tr_o_h])"
    vOvf[ovf_,t]$(t.val >= %BFR_t1%) "Sociale overførsler fra offentlig forvaltning og service til husholdninger, Kilde: ADAM[Ty_o] for underkomponenter jf. o-set."
    vOvfSkatPl[a_,t]$(aTot[a_] and t.val >= %BFR_t1%) "Skattepligtige indkomstoverførsler pr. person (i befolkningen) fordelt på alder."
    vOvfUbeskat[a_,t]$(aTot[a_] and t.val >= %BFR_t1%) "Ubeskattede indkomstoverførsler pr. person (i befolkningen) fordelt på alder."
    vOvfSats[ovf,t]$(t.val >= %BFR_t1%) "Sociale overførsler fra offentlig forvaltning og service til husholdninger pr. person i basen (mio. kr.)"
    vGLukning[t] "Udgift til beregningsteknisk stigning i offentligt forbrug til lukning af offentlig budgetrestriktion. Indgår IKKE i offentlig saldo."
    vOffTilUdl[t] "Samlede overførsler fra offentlig sektor til udlandet, Kilde: ADAM[Tr_o_e]+ADAM[tK_o_e]"
    vOffTilVirkRest[t] "Kapitaloverførsler til selskaber (øvrige) (Tk_o_cr)"
    vOffTilHhKapRest[t] "Kapitaloverførsler til husholdningerne ekskl. skattefri efterlønspræmie (Tk_o_hr)"

    jvOvf[ovf_,t]$(ovftot[ovf_] and t.val >= %BFR_t1%) "J-led som fanger at nogle grupper har en overførsel, men ingen modtagere. Fordeles til husholdningerne gennem fHhOvf."
    dvOvf2dnBesk[ovf_,t]$(ovf[ovf_] or HhTot[ovf_]) "Marginal ændring i udgifter til overførsel ovf ved ændring i den samlede beskæftigelse."
    dvOvf2dnPop[ovf_,t]$(ovf[ovf_] or HhTot[ovf_]) "Marginal ændring i udgifter til overførsel ovf ved ændring i den samlede befolkningsstørrelse."
  ;

  $GROUP G_GovExpenses_endo_a
    fHhOvf[t]$(t.val > %AgeData_t1%) "Korrektionsfaktor som sikre afbalancering af overførsler-indkomster fordelt på henholdsvis alder og overførselstype."
    G_GovExpenses_values_a_endo
  ;
  $GROUP G_GovExpenses_endo
    G_GovExpenses_endo_a

    G_GovExpenses_prices_endo
    G_GovExpenses_quantities_endo
    G_GovExpenses_values_endo

    uvG_ind[t]$(t.val >= %BFR_t1%) "Skala-parameter som bestemmer niveau for individuelt offentligt service før korrektion for demografisk træk og løn-niveau."

    fDemoTraek[a_,t]$(aTot[a_] and t.val >= %BFR_t1%) "Demografisk træk."
    nOvf[ovf,t]$(t.val >= %BFR_t1%) "Basen til sociale overførsler i antal 1000 personer fordelt på ordninger."

    dnOvf2dnBesk[ovf,t] "Marginal ændring i antal modtagere af overførsel ovf ved ændring i den samlede beskæftigelse."
    dnOvf2dnPop[ovf,t]$(t.val >= 1992) "Marginal ændring i antal modtagere af overførsel ovf ved ændring i den samlede befolkningsstørrelse."
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
    rOffTilHhNPISH2vG[t] "Offentlige overførsler til NPISH relativt til BNP."
    rOffTilHhTillaeg2BNP[t] "Indekstillæg relativt til BNP."
    uOffTilHhRest[t] "Skalaparameter for øvrige offentlige overførsler til husholdninger."
    rSubEU2BNP[t] "Subsidier finansieret af EU relativt til BNP."
    rSubYRest[s_,t]$(sTot[s_]) "Sats for produktionssubsidier ekskl. løntilskud."
    uvGxAfskr[t] "Niveauparameter for vGxAfskr"
    rpGxAfskr[t] "Relative laggede priser i offentligt forbrug ekskl. afskrivninger vægtet med nutidige mængder."
  ;
  
  $GROUP G_GovExpenses_endo
    G_GovExpenses_endo$(tx0[t]) # Restrict endo group to tx0[t]
  ;

  $GROUP G_GovExpenses_prices
    G_GovExpenses_prices_endo
  ;
  $GROUP G_GovExpenses_quantities
    G_GovExpenses_quantities_endo
  ;
  $GROUP G_GovExpenses_values
    G_GovExpenses_values_endo

    vSubYPSO[t] "Produktionssubsidie vedrørende PSO (indgår i vSubYRest), Kilde: ADAM[Spzupso]"
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
    vNulvaekstIndeks[t] "Nulvækstindeks er 1 i en ikke-vækst- og inflationskorrigeret bank - og modsvarer ellers korrektion"
  ;

  $GROUP G_GovExpenses_ARIMA_forecast
    uG[g_,t] "Skalaparameter i det offentlige forbrugsnest."

    # Endogene i stødforløb:
    rOffTilUdlKap2BNP
    rOffTilUdlMoms2Moms
    rOffTilUdlEU2BNP
    rOffTilUdlFO2BNP
    rOffTilUdlGL2BNP
    rOffTilUdlBistand2BNI
    rOffTilHhTillaeg2BNP
    rSubEU2BNP
  ;
  $GROUP G_GovExpenses_constants
      eG[g_] "Substitutionselasticitet mellem forskellige grupper af offentligt forbrug."
  ;
  $GROUP G_GovExpenses_fixed_forecast
    rGLukning[t] "Beregningsteknisk stigning i offentligt forbrug til lukning af offentlig budgetrestriktion."
    uvG_kol[t] "Skalaparameter for kollektivt offentligt forbrug."
    uvG_ind[t]

    fqG_input[t] "Korrektionsfaktor. Fremskrives uændret til tabelvariabel qG_input"
    rOffTilUdlBNI2BNI
    rOffTilVirk2BNP
    rOffTilVirkInvesttilskud2BNP
    rOffTilHhKap2BNP
    rOffTilHhKapPraemie2BNP
    rOffTilHhNPISH2vG
    rOffLandKoeb2BNP
  ;
  $GROUP G_GovExpenses_newdata_forecast
    uvOvfSats[ovf,t]$(satsreg[ovf] or prisreg[ovf] or intro[ovf]) "Skalaparameter for overførselssatser."
    uOffTilHhRest
    uHhOvfPop[a,t] "Aldersmæssig fordelingsnøgle knyttet til dvOvf2dnPop."
    uOvfUbeskat[a,t] "Aldersmæssig fordelingsnøgle knyttet til vOvfUbeskat."
    vOvfSats[ovf,t]
    vOvfUbeskat[a_,t]
    rSubYRest[s_,t]
  ;
  $GROUP G_GovExpenses_exogenous_forecast
    fDemoTraek[a_,t]$(not aTot[a_]) "Demografisk træk."
    fDemoTraek_Over100[t] "Demografisk træk for personer over 100år"

    rPensAlder[a,t] "Andel i folkepensionsalderen (0, 0.5, eller 1)."
    rEfterlAlder[a,t] "Andel i efterlønsalderen (0, 0.5, eller 1)."
    nOvf2nSoc[ovf_,soc,t] "Mapping mellem modtagere af overførsler og BFR-grupper."
  ;
  $GROUP G_GovExpenses_forecast_as_zero
    jvOvf
    uvOvfSats[ovf,t]$(sameas['groen',ovf])
    uHhOvfRest[a,t] "Residual som sikrer at samlede overførselsindkomster til en aldersgruppe passer til aldersprofil."
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_GovExpenses_static$(tx0[t])
    # ----------------------------------------------------------------------------------------------------------------------
    # Offentligt forbrug
    # ----------------------------------------------------------------------------------------------------------------------
    E_vGxAfskr[t].. vGxAfskr[t] =E= vG[gTot,t] - vOffAfskr[kTot,t];
    E_qGxAfskr_via_rpGxAfskr[t].. qGxAfskr[t] =E=  rpGxAfskr[t] * (qG[gTot,t] - qOffAfskr[kTot,t]);
    E_qGxAfskr[t]..
      qGxAfskr[t] * pGxAfskr[t-1]/fp =E= pG[gTot,t-1]/fp * qG[gTot,t] - pOffAfskr[kTot,t-1]/fp * qOffAfskr[kTot,t];
    E_pGxAfskr[t].. pGxAfskr[t] * qGxAfskr[t] =E= vGxAfskr[t];
    
    E_fDemoTraek_tot[t]$(t.val >= %BFR_t1%)..
      fDemoTraek[aTot,t] =E= sum(a, nPop[a,t] * fDemoTraek[a,t]) + nPop_Over100[t] * fDemoTraek_Over100[t];

    # Kollektivt offentligt forbrug følger løn og befolkningstal. Det individuelle følger demografi og løn
    E_uvGxAfskr[t].. vGxAfskr[t] =E= uvGxAfskr[t] * vhW_DA[t];
    E_uvG_ind[t]$(t.val >= %BFR_t1%)..
      uvGxAfskr[t] =E= (uvG_kol[t] * nPop_inklOver100[t] + uvG_ind[t] * fDemoTraek[aTot,t]) * (1+rGLukning[t]);

    E_vG_ind[t].. vG[gTot,t] =E= vG_kol[t] + vG_ind[t];
    E_vG_kol[t]$(t.val >= %BFR_t1%)..
      vG_kol[t] / vG_ind[t] =E= uvG_kol[t] * nPop_inklOver100[t] / (uvG_ind[t] * fDemoTraek[aTot,t]);

    # CES demand
    # there is currently only one type of government consumption, i.e. qG['gTot'] = qG['g'] 
    E_qG[g_,gNest,t]$(gNest2g_(gNest,g_))..
      qG[g_,t] =E= uG[g_,t] * qG[gNest,t] * (pG[gNest,t] / pG[g_,t])**eG(gNest);

    # Input-baseret offentligt forbrug (tabel-variabel)
    E_qG_input[t].. qG_input[t] =E= fqG_input[t] * qG[gTot,t];
    E_pG_input[t].. pG_input[t] * qG_input[t] =E= vG[gTot,t];
    E_qGxAfskr_input[t]..
      qGxAfskr_input[t] * pGxAfskr_input[t-1]/fp =E= pG_input[t-1]/fp * qG_input[t] 
                                                     - pOffAfskr[kTot,t-1]/fp * qOffAfskr[kTot,t];
    E_pGxAfskr_input[t].. pGxAfskr_input[t] * qGxAfskr_input[t] =E= vGxAfskr[t];

    # A technical adjustment to government spending can be used to close the government intertemporal budget constraint
    E_vGLukning[t].. vGLukning[t] =E= rGLukning[t] / (1+rGLukning[t]) * vGxAfskr[t];

    # ----------------------------------------------------------------------------------------------------------------------
    # Primære offentlige udgifter
    # ----------------------------------------------------------------------------------------------------------------------
    E_vOffPrimUd[t].. vOffPrimUd[t] =E= vG[gTot,t]
                                      + vOvf['tot',t]
                                      + vOffInv[t]
                                      + vOffSub[t]
                                      + vOffUdRest[t]
                                      - vGLukning[t];

    # Indkomstoverførsler - satser
    E_vOvfSats_satsreg[satsreg,t]$(t.val >= %BFR_t1%)..
      vOvfSats[satsreg,t] =E= vSatsIndeks[t] * uvOvfSats[satsreg,t];

    E_vOvfSats_prisreg[prisreg,t]$(t.val >= %BFR_t1%)..
      vOvfSats[prisreg,t] =E= vPrisIndeks[t] * uvOvfSats[prisreg,t];

    E_vOvfSats_ureguleret[ureguleret,t]$(t.val >= %BFR_t1%)..
      vOvfSats[ureguleret,t] =E= vNulvaekstIndeks[t] * uvOvfSats[ureguleret,t];

    E_vOvfSats_intro[intro,t]$(t.val >= %BFR_t1%)..
      vOvfSats[intro,t] =E= vSatsIndeksIntro[t]  * uvOvfSats[intro,t];

    # Antal modtagere af overførsler knyttet til sociogrupper
    E_nOvf[ovf,t]$(not (ovf_a0t17[ovf] or ovf_a18t100[ovf]) and t.val >= %BFR_t1%)..
      nOvf[ovf,t] =E= sum(soc, nOvf2nSoc[ovf,soc,t] * nSoc[soc,t]);

    # Overførsler som fordeles på alle under 18
    E_nOvf_a0t17[ovf,t]$(ovf_a0t17[ovf] and t.val >= %BFR_t1%)..
      nOvf[ovf,t] =E= nPop['a0t17',t];

    # Overførsler som fordeles på alle over 18
    E_nOvf_a18t100[ovf,t]$(ovf_a18t100[ovf] and t.val >= %BFR_t1%)..
      nOvf[ovf,t] =E= nPop['a18t100',t];

    # Indkomstoverførsler - samlet udgift fordelt på overførselstype
    E_vOvf[ovf,t]$(t.val >= %BFR_t1%).. vOvf[ovf,t] =E= vOvfSats[ovf,t] * nOvf[ovf,t] + jvOvf[ovf,t];

    E_jvOvf_tot[t]$(t.val >= %BFR_t1%).. jvOvf['tot',t] =E= sum(ovf, jvOvf[ovf,t]);

    E_vOvf_tot[t]$(t.val >= %BFR_t1%).. vOvf['tot',t] =E= sum(ovf, vOvf[ovf,t]);
    E_vOvf_hh[t]$(t.val >= %BFR_t1%)..  vOvf['HhTot',t]  =E= sum(ovfHh, vOvf[ovfHh,t]);

    E_vOvf_a18t100[t]$(t.val >= %BFR_t1%)..
      vOvf['a18t100',t] =E= sum(ovf_a18t100, vOvf[ovf_a18t100,t]) / nPop['a18t100',t];

    E_vOvf_a0t17[t]$(t.val >= %BFR_t1%)..
      vOvf['a0t17',t] =E= sum(ovf_a0t17, vOvf[ovf_a0t17,t]) / nPop['a0t17',t];

    # Antallet af overførselsmodtager følger befolkningsstørrelsen samt beskæftigelsen
    # dnOvf2dnBesk og dnOvf2dnPop kan gøres eksogene for at spare beregning
    E_dnOvf2dnBesk[ovf,t]..
      dnOvf2dnBesk[ovf,t] =E= sum(soc, dSoc2dBesk[soc,t] * nOvf2nSoc[ovf,soc,t]);
    E_dnOvf2dnPop[ovf,t]$(t.val >= 1992)..
      dnOvf2dnPop[ovf,t] =E= sum(soc, (dSoc2dPop[soc,t] + jnSoc[soc,t] / nPop['a15t100',t]) * nOvf2nSoc[ovf,soc,t]);

    # Indkomstoverførsler følger antallet af modtagere
    E_dvOvf2dnBesk[ovf,t].. dvOvf2dnBesk[ovf,t] =E= vOvfSats[ovf,t] * dnOvf2dnBesk[ovf,t];
    E_dvOvf2dnBesk_hh[t].. dvOvf2dnBesk['HhTot',t] =E= sum(ovfHh, dvOvf2dnBesk[ovfHh,t]);

    E_dvOvf2dnPop[ovf,t].. dvOvf2dnPop[ovf,t] =E= vOvfSats[ovf,t] * dnOvf2dnPop[ovf,t];
    E_dvOvf2dnPop_hh[t].. dvOvf2dnPop['HhTot',t] =E= sum(ovfHh, dvOvf2dnPop[ovfHh,t]);

    # Opdeling af ubeskattede og skattepligtige overførsler
    E_vOvfUbeskat_tot[t]$(t.val >= %BFR_t1%).. vOvfUbeskat[aTot,t] =E= sum(ovfHh$(ubeskat[ovfHh]), vOvf[ovfHh,t]);

    E_vOvfSkatPl_tot[t]$(t.val >= %BFR_t1%).. vOvfSkatPl[aTot,t] =E= vOvf['HhTot',t] - vOvfUbeskat[aTot,t];

    # Offentlige investeringer
    E_vOffInv[t].. vOffInv[t] =E= vI_s[iTot,'off',t];

    # Subsidier
    E_vOffSub[t].. vOffSub[t] =E= vSub[dTot,sTot,t] + vSubY[t] - vSubEU[t];
    E_vSubYRest[s,t].. vSubYRest[s,t] =E= rSubYRest[s,t] * vY[s,t];
    E_vSubYRest_Tot[t].. vSubYRest[sTot,t] =E= rSubYRest[sTot,t] * vY[sTot,t];
    E_rSubYRest_sTot[t].. vSubYRest[sTot,t] =E= sum(s, vSubYRest[s,t]);
    E_vSubY[t].. vSubY[t] =E= vSubLoen[sTot,t] + vSubYRest[sTot,t];
    E_vSubEU[t].. vSubEU[t] =E= vBNP[t] * rSubEU2BNP[t];

    # Øvrige offentlige udgifter
    E_vOffUdRest[t].. 
      vOffUdRest[t] =E= vOffLandKoeb[t] + vOffTilUdl[t] + vOffTilHh[t] + vOffTilVirk[t];

    E_rOffLandKoeb2BNP[t].. vOffLandKoeb[t] =E= vBNP[t] * rOffLandKoeb2BNP[t];

    E_vOffTilUdl[t]..
      vOffTilUdl[t] =E= vOffTilUdlKap[t] + vOffTilUdlMoms[t] + vOffTilUdlBNI[t] + vOffTilUdlEU[t]
                      + vOffTilUdlFO[t] + vOffTilUdlGL[t] + vOffTilUdlBistand[t];
    E_rOffTilUdlKap2BNP[t].. vOffTilUdlKap[t] =E= vBNP[t] * rOffTilUdlKap2BNP[t];
    E_rOffTilUdlMoms2Moms[t].. vOffTilUdlMoms[t] =E= vtMoms[dTot,sTot,t] * rOffTilUdlMoms2Moms[t];
    E_rOffTilUdlBNI2BNI[t].. vOffTilUdlBNI[t] =E= vBNI[t] * rOffTilUdlBNI2BNI[t];
    E_rOffTilUdlEU2BNP[t].. vOffTilUdlEU[t] =E= vBNP[t] * rOffTilUdlEU2BNP[t];
    E_rOffTilUdlFO2BNP[t].. vOffTilUdlFO[t] =E= vBNP[t] * rOffTilUdlFO2BNP[t];
    E_rOffTilUdlGL2BNP[t].. vOffTilUdlGL[t] =E= vBNP[t] * rOffTilUdlGL2BNP[t];
    E_rOffTilUdlBistand2BNI[t].. vOffTilUdlBistand[t] =E= vBNI[t] * rOffTilUdlBistand2BNI[t];

    E_vOffTilHh[t].. vOffTilHh[t] =E= vOffTilHhKap[t] + vOffTilHhNPISH[t] + vOffTilHhTillaeg[t] + vOffTilHhRest[t];
    E_rOffTilHhNPISH2vG[t].. vOffTilHhNPISH[t] =E= vG[gTot,t] * rOffTilHhNPISH2vG[t];
    E_rOffTilHhTillaeg2BNP[t].. vOffTilHhTillaeg[t] =E= vBNP[t] * rOffTilHhTillaeg2BNP[t];
    E_uOffTilHhRest[t].. vOffTilHhRest[t] =E= uOffTilHhRest[t] * vSatsindeks[t] * nPop_inklOver100[t];

    E_vOffTilHhKapRest[t].. vOffTilHhKap[t] =E= vOffTilHhKapPraemie[t] + vOffTilHhKapRest[t];
    E_rOffTilHhKap2BNP[t].. vOffTilHhKap[t] =E= vBNP[t] * rOffTilHhKap2BNP[t];
    E_rOffTilHhKapPraemie2BNP[t].. vOffTilHhKapPraemie[t] =E= rOffTilHhKapPraemie2BNP[t] * vBNP[t];

    E_vOffTilVirkRest[t].. vOffTilVirk[t] =E= vOffTilVirkInvesttilskud[t] + vOffTilVirkRest[t];
    E_rOffTilVirk[t].. vOffTilVirk[t] =E= rOffTilVirk2BNP[t] * vBNP[t];
    E_rOfftilVirkInvesttilskud2BNP[t].. vOffTilVirkInvesttilskud[t] =E= rOfftilVirkInvesttilskud2BNP[t] * vBNP[t];
  $ENDBLOCK

  # $BLOCK B_GovExpenses_forwardlooking
  # $ENDBLOCK

  $BLOCK B_GovExpenses_a$(tx0[t])
    # Korrektionsfaktor som sikre afbalancering af overførsler-indkomster fordelt på henholdsvis alder og overførselstype.
    E_fHhOvf[t]$(t.val > %AgeData_t1%).. vOvf['HhTot',t] =E= sum(a, vHhOvf[a,t] * nPop[a,t]);

    # Aldersfordelte indkomstoverførsler
    E_vHhOvf[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vHhOvf[a,t] =E= (  dvOvf2dnBesk['HhTot',t] * nLHh[a,t] / nPop[a,t]
                       + dvOvf2dnPop['HhTot',t] * uHhOvfPop[a,t]
                       + vOvf['a0t17',t] * rBoern[a,t]
                       + vOvf['a18t100',t]$(a18t100[a])
                       + jvOvf['tot',t] / nPop['a15t100',t]
                       + uHhOvfRest[a,t] * vSatsIndeks[t]
                     ) * fHhOvf[t];

    E_vOvfUbeskat[a,t]$(a.val <= 100 and t.val > %AgeData_t1%)..
      vOvfUbeskat[a,t] =E= uOvfUbeskat[a,t] / sum(aa, uOvfUbeskat[aa,t] * nPop[aa,t]) * vOvfUbeskat[aTot,t];

    E_vOvfSkatPl[a,t]$(t.val > %AgeData_t1%).. vOvfSkatPl[a,t] =E= vHhOvf[a,t] - vOvfUbeskat[a,t];
  $ENDBLOCK

  MODEL M_GovExpenses /
    B_GovExpenses_static
    # B_GovExpenses_forwardlooking
    B_GovExpenses_a
  /;

  $GROUP G_GovExpenses_static
    G_GovExpenses_endo
    -G_GovExpenses_endo_a
  ;

$ENDIF

$IF %stage% == "exogenous_values":
# ======================================================================================================================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_GovExpenses_makrobk
    # Offentlige udgifter
    vG$(gTot[g_]),vG_ind, vG_kol, vOffSub, vSubY, vSubEU, vSubYRest, vSubYPSO
    vOffLandKoeb, vOffTilUdlKap, vOffTilUdlMoms, vOffTilUdlBNI, vOffTilUdlEU, vOffTilUdlFO, vOffTilUdlGL, vOffTilUdl 
    vOffTilUdlBistand, vOffTilVirk, vOffTilHhKap, vOffTilHhNPISH, vOffTilHhTillaeg, vOffTilHhRest
    vOvf$(ovf[ovf_] or HhTot[ovf_] or ovftot[ovf_])
    vOvfUbeskat$(t.val >= 1992 and aTot[a_])
    vOffPrimUd$(t.val > 2006)
    vOffInv$(t.val > 2006)
    # Øvrige variable
    qG, qG_input, qGxAfskr, qGxAfskr_input
    pG_input, pGxAfskr, pGxAfskr_input
  ;
  @load(G_GovExpenses_makrobk, "..\Data\makrobk\makrobk.gdx" )

  execute_load "..\Data\FM_exogenous_forecast.gdx" vOffTilVirkInvesttilskud.l=vOffTilVirk_investeringstilskud.l
  execute_load "..\Data\FM_exogenous_forecast.gdx" vOffTilHhKapPraemie.l=vOffTilHhKap_praemie.l
  $GROUP G_GovExpenses_FM vOffTilVirkInvesttilskud, vOffTilHhKapPraemie;

  # Demografisk træk
  $GROUP G_GovExpenses_DemoTraek
    fDemoTraek
    fDemoTraek_Over100
  ;
  @load(G_GovExpenses_DemoTraek, "..\Data\Befolkningsregnskab\DemoTraek.gdx" )

  # Aldersfordelt data fra aldersprofiler indlæses
  $GROUP G_GovExpenses_aldersprofiler
    vHhOvf$(t.val >= %AgeData_t1%)
  ;
  @load(G_GovExpenses_aldersprofiler, "..\Data\Aldersprofiler\aldersprofiler.gdx" )

  # Aldersfordelte parametre fra BFR indlæses
  parameters 
    nOvf_a[ovf_,a_,t] "Modtager-grupper fordelt på alder, antal 1.000 personer"
    nOvfFraSocResidual[ovf_,a_,t] "Residualeffekt fra befolkning på modtager-gruppe fordelt på alder, antal 1.000 personer"
  ;
  $GDXIN ..\Data\Befolkningsregnskab\BFR.gdx
    $LOAD nOvf_a, nOvfFraSocResidual
  $GDXIN
  $GROUP G_GovExpenses_BFR
    nPop, rPensAlder, rEfterlAlder, nOvf2nSoc
  ;
  @load(G_GovExpenses_BFR, "..\Data\Befolkningsregnskab\BFR.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_GovExpenses_data
    G_GovExpenses_makrobk
    G_GovExpenses_BFR
    G_GovExpenses_FM
    jvOvf$(t.val >= %BFR_t1% and not ovftot[ovf_])
    vOvfSats$(t.val >= %BFR_t1% and tADAMdata[t])
    uHhOvfPop$(a15t100[a] and t.val >= %BFR_t1% and tADAMdata[t])
    vOvfUbeskat$(a15t100[a_] and t.val >= %BFR_t1% and tADAMdata[t])
    uOvfUbeskat$(a15t100[a] and t.val >= %BFR_t1% and tADAMdata[t])
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
    qGxAfskr, qGxAfskr_input, pGxAfskr_input
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  vNulvaekstIndeks.l[t] = 1;

# ======================================================================================================================
# Data management
# ======================================================================================================================
  # Antager ens satser fordelt på alder - modtagergrupper tages fra BFR beregnet under data.gms
  vOvfSats.l[ovf,t]$(nOvf_a[ovf,aTot,t] <> 0) = vOvf.l[ovf,t] / nOvf_a[ovf,aTot,t];
  vOvfSats.l[ovf,t]$(nOvf_a[ovf,aTot,t] = 0) = vOvfSats.l[ovf,t-1];

  # Nogle grupper har en overførsel, men ingen modtagere - ryger i j-led
  jvOvf.l[ovf,t] = vOvf.l[ovf,t] - vOvfSats.l[ovf,t] * nOvf_a[ovf,aTot,t];

  uHhOvfPop.l[a,t]$(a15t100[a] and t.val >= %BFR_t1% and tADAMdata[t]) =          
    sum(ovfHh, vOvfSats.l[ovfHh,t] * nOvfFraSocResidual[ovfHh,a,t]) / nPop.l[a,t]  # Samlede overførsler pr. person i alder a, som ikke afhænger af beskæftigelsesfrekvens
  / sum(ovfHh, vOvfSats.l[ovfHh,t] * nOvfFraSocResidual[ovfHh,aTot,t]) * nPop.l['a15t100',t];  # Samlede overførsler i alt, som ikke afhænger af beskæftigelsesfrekvens

  # Aldersfordelte overførsler
  fHhOvf.l[t] = 1; # Balancerings mekanisk sættes til 1 i år hvor uHhOvfRest kalibreres

  # Ubeskattede overførsler pr. person følger ordningerne
  vOvfUbeskat.l[a,t]$(nPop.l[a,t]) = sum(ovf$(ubeskat[ovf]), vOvfSats.l[ovf,t] * nOvf_a[ovf,a,t]) / nPop.l[a,t];
  vOvfUbeskat.l[aTot,t] = sum(a, vOvfUbeskat.l[a,t] * nPop.l[a,t]);
  uOvfUbeskat.l[a,t]$(vOvfUbeskat.l[a,t] <> 0) = vOvfUbeskat.l[a,t] / (vOvfUbeskat.l[aTot,t] / nPop.l[aTot,t]); # Ubeskattede overførsler for a årig relativt til gennemsnitlig person
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_GovExpenses_static_calibration_base
    G_GovExpenses_endo
    -qG[g,t], uG
    -vOvfSats[ovf,t]$(t.val >= %BFR_t1%), uvOvfSats[ovf,t]$(t.val >= %BFR_t1%)
    -vOvf[ovf,t]$(t.val >= %BFR_t1%), jvOvf[ovf,t]$(t.val >= %BFR_t1%)
    -vOvf[HhTot,t]$(t.val >= %BFR_t1%), vOvf['pension',t]$(t.val >= %BFR_t1%)
    rSubYRest[s,t], -vSubYRest[s,t]
    -vG_kol, uvG_kol
    -qG_input, fqG_input
  ;

  $GROUP G_GovExpenses_static_calibration_newdata
    G_GovExpenses_static_calibration_base$(tx0[t]),
    G_GovExpenses_endo$(not tx0[t]) # Nutidsværdier til HBI beregnes før t1
    - G_GovExpenses_endo_a
  ;

  MODEL M_GovExpenses_static_calibration_newdata /
    M_GovExpenses 
    # B_GovExpenses_static_calibration
    - B_GovExpenses_a
  /;

  $GROUP G_GovExpenses_static_calibration
    G_GovExpenses_static_calibration_base
    -vHhOvf, uHhOvfRest$(t.val > %AgeData_t1%)
    -fHhOvf # -E_fHhOvf
  ;
  $GROUP G_GovExpenses_static_calibration 
    G_GovExpenses_static_calibration$(tx0[t])
  ;

  MODEL M_GovExpenses_static_calibration /
    M_GovExpenses
    # B_GovExpenses_static_calibration
    - E_fHhOvf
  /;
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
    -rOffTilHhNPISH2vG, vOffTilHhNPISH
    -rOffTilHhTillaeg2BNP, vOffTilHhTillaeg
    -uOffTilHhRest, vOffTilHhRest
    -rSubEU2BNP, vSubEU
    hL[off,t], -uvGxAfskr
  ;
  $GROUP G_GovExpenses_deep G_GovExpenses_deep$(tx0[t]);

#  $BLOCK B_Govexpenses_deep
#  $ENDBLOCK

MODEL M_GovExpenses_deep /
  M_GovExpenses
  #  B_Govexpenses_deep
/;

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
  -rOffTilHhNPISH2vG, vOffTilHhNPISH
  -rOffTilHhTillaeg2BNP, vOffTilHhTillaeg
  -uOffTilHhRest, vOffTilHhRest
  -rSubEU2BNP, vSubEU
  hL[off,t], -uvGxAfskr
;
$GROUP G_GovExpenses_dynamic_calibration G_GovExpenses_dynamic_calibration$(tx0[t]);
MODEL M_GovExpenses_dynamic_calibration /
  M_GovExpenses
/;
$ENDIF
