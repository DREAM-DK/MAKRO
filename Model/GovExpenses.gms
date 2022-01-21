# ======================================================================================================================
# Government expenses
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_GovExpenses_prices
    pGxAfskr[t]$(tx0[t]) "Deflator for offentligt forbrug fratrukket offentlige afskrivninger, Kilde: ADAM[pCov]"
  ;
  $GROUP G_GovExpenses_quantities
    qGxAfskr[t] "Offentligt forbrug fratrukket offentlige afskrivninger, Kilde: ADAM[fCov]"
    qG[g_,t]$(g[g_]) "Offentligt forbrug, Kilde: ADAM[fCo]"
  ;

  $GROUP G_GovExpenses_values_endo
    # Primære udgifter
    vGxAfskr[t] "Offentligt forbrug fratrukket offentlige afskrivninger, Kilde: ADAM[Cov]"
    vOffPrimUd[t] "Primære offentlige udgifter, Kilde: ADAM[Tf_o_z]-ADAM[Ti_o_z]"
    vOffInv[t] "Offentlige investeringer, Kilde: ADAM[Io1]"
    vOffSub[t] "Dansk finansieret subsidier ialt, Kilde: ADAM[Spu_o]"
    vSubY[t]$(t.val > 2015) "Produktionssubsidier, Kilde: ADAM[Spzu]"
    vSubYRes[t]$(tx0[t]) "Produktionssubsidier ekskl. løntilskud, Kilde: ADAM[Spzu]-ADAM[Spzul]"
    vOffUdRest[t] "Øvrige offentlige udgifter."
    vOffTilHh[t] "Residuale overførsler fra offentlig sektor til husholdningerne, Kilde: ADAM[tK_o_h]+ADAM[Tr_o_h])"
    vOvf[ovf_,t]$(t.val > 2015) "Sociale overførsler fra offentlig forvaltning og service til husholdninger, Kilde: ADAM[Ty_o] for underkomponenter jf. o-set."
    vHhOvf[a,t]$(a15t100[a] and t.val > 2015) "Indkomstoverførsler til indl. hush. pr. person (i befolkningen) fordelt på alder."
    vOvfSkatPl[a_,t]$(t.val > 2015) "Skattepligtige indkomstoverførsler pr. person (i befolkningen) fordelt på alder."
    vOvfSats[ovf,t]$(t.val > 2015) "Sociale overførsler fra offentlig forvaltning og service til husholdninger pr. person i basen (mio. kr.)"
    vOvfUbeskat[a_,t]$((a0t100[a_] and t.val > 2015) or (sameas['tot',a_] and t.val > 2000)) "Ubeskattede indkomstoverførsler pr. person (i befolkningen) fordelt på alder."
    vGLukning[t] "Udgift til beregningsteknisk stigning i offentligt forbrug til lukning af offentlig budgetrestriktion."
  ;

  $GROUP G_GovExpenses_endo
    G_GovExpenses_prices
    G_GovExpenses_quantities
    G_GovExpenses_values_endo

    uvGxAfskr[t] "Skala-parameter som bestemmer niveau for offentligt service før korrektion for demografisk træk og løn-niveau."

    nOvf[ovf,t] "Basen til sociale overførsler i antal 1000 personer fordelt på ordninger."
    fHhOvf[t]$(t.val > 2015) "Korrektionsfaktor som sikre afbalancering af overførsler-indkomster fordelt på henholdsvis alder og overførselstype."

    dnOvf2dBesk[ovf,t] "Beskæftigelsesnøgle fordelt på modtagere af overførsels-indkomster."
    dnOvf2dPop[ovf,t]$(t.val > 1990) "Befolkningssnøgle fordelt på modtagere af overførsels-indkomster."
    dvOvf2dBesk[ovf_,t]$(ovf[ovf_] or sameas['hh',ovf_]) "Beskæftigelsesnøgle fordelt på overførsels-indkomster."
    dvOvf2dPop[ovf_,t]$(ovf[ovf_] or sameas['hh',ovf_]) "Befolkningssnøgle fordelt på overførsels-indkomster."
    rOffLandKoeb2BNP[t] "Nettoopkob af jord og rettigheder relativt til BNP."
    rOffTilUdl2BNP[t] "Offentlige overførsler til udlandet relativt til BNP."
    rOffTilVirk2BNP[t] "Offentlige overførsler til selskaber relativt til BNP."
    rOffTilHhKap2BNP[t] "Offentlige kapitaloverførsler til husholdninger relativt til BNP."
    rOffTilHhOev2BNP[t] "Offentlige øvrige overførsler til husholdninger relativt til BNP."
    rSubEU2BNP[t] "Subsidier finansieret af EU relativt til BNP."
  ;
  $GROUP G_GovExpenses_endo G_GovExpenses_endo$(tx0[t]); # Restrict endo group to tx0[t]

  $GROUP G_GovExpenses_values_exo 
    vHhOvfRest[a,t] "Residual som sikrer at samlede overførselsindkomster til en aldersgruppe passer til aldersprofil."
    vOffLandKoeb[t] "Den offentlige sektors nettoopkøb af jord og rettigheder, Kilde: ADAM[Izn_o]"
    vOffTilUdl[t] "Residuale overførsler fra offentlig sektor til udlandet, Kilde: ADAM[Tr_o_e]+ADAM[tK_o_e]"
    vOffTilVirk[t] "Residuale overførsler fra offentlig sektor til indenlandske selskaber, Kilde: ADAM[tK_o_c]"
    vOffTilHhKap[t] "Residuale kapitaloverførsler fra offentlig sektor til husholdningerne, Kilde: ADAM[tK_o_h])"
    vOffTilHhOev[t] "Residuale øvrige overførsler fra offentlig sektor til husholdningerne, Kilde: ADAM[Tr_o_h])"
    vSubEU[t] "Subsider finansieret af EU, Kilde: ADAM[Spueu]"
  ;
  $GROUP G_GovExpenses_values
    G_GovExpenses_values_endo
    G_GovExpenses_values_exo
  ;
  $GROUP G_GovExpenses_ARIMA_forecast
    uG[g_,t] "Skalaparameter i det offentlige forbrugsnest."
    rvYsubRest2BVT[t] "Produktionssubsidier ekskl. løntilskud relativt til BVT."

    # Endogene i stødforløb:
    rOffLandKoeb2BNP
    rOffTilUdl2BNP
    rOffTilVirk2BNP
    rOffTilHhKap2BNP
    rOffTilHhOev2BNP
    rSubEU2BNP
  ;
  $GROUP G_GovExpenses_other
    eG[g_] "Substitutionselasticitet mellem forskellige grupper af offentligt forbrug."
    rGLukning[t] "Beregningsteknisk stigning i offentligt forbrug til lukning af offentlig budgetrestriktion."
  ;
  $GROUP G_GovExpenses_exogenous_forecast
    fDemoTraek[t] "Demografisk træk."
    uHhOvfPop[a,t] "Aldersmæssig fordelingsnøgle knyttet til dvOvf2dPop."
    uOvfUbeskat[a,t] "Aldersmæssig fordelingsnøgle knyttet til vOvfUbeskat."
    jvOvf[ovf,t] "J-led som fanger at nogle grupper har en overførsel, men ingen modtagere. Fordeles til husholdningerne gennem fHhOvf."
    uvOvfSats[ovf,t]$(sameas['groen',ovf]) "Skalaparameter for overførselssatser."
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_GovExpenses
# ----------------------------------------------------------------------------------------------------------------------
# Offentligt forbrug
# ----------------------------------------------------------------------------------------------------------------------
  # Aggregate public consumption excluding depreciations follows demographic needs and wage growth
  E_vGxAfskr[t]$(tx0[t]).. vGxAfskr[t] =E= uvGxAfskr[t] * (1+rGLukning[t]) * fDemoTraek[t] * vhW[t];
  E_qGxAfskr[t]$(tx0[t])..
    qGxAfskr[t] * pGxAfskr[t-1]/fp =E= pG[gTot,t-1]/fp * qG[gTot,t] - pOffAfskr[kTot,t-1]/fp * qOffAfskr[kTot,t];
  E_pGxAfskr[t]$(tx0[t]).. pGxAfskr[t] * qGxAfskr[t] =E= vGxAfskr[t];

  E_qG_tot[t]$(tx0[t]).. qG[gTot,t] * pG[gTot,t] =E= vGxAfskr[t] + vOffAfskr[kTot,t];

  # CES demand
  # there is currently only one type of government consumption, i.e. qG['gTot'] = qG['g'] 
  E_qG[g_,gNest,t]$(tx0[t] and gNest2g_(gNest,g_))..
    qG[g_,t] =E= uG[g_,t] * qG[gNest,t] * (pG[gNest,t] / pG[g_,t])**eG(gNest);

  # A technical adjustment to government spending can be used to close the government intertemporal budget constraint
  E_vGLukning[t]$(tx0[t]).. vGLukning[t] =E= rGLukning[t] / (1+rGLukning[t]) * vG[gTot,t];

# ----------------------------------------------------------------------------------------------------------------------
# Primære offentlige udgifter
# ----------------------------------------------------------------------------------------------------------------------
  E_vOffPrimUd[t]$(tx0[t]).. vOffPrimUd[t] =E= vG[gTot,t]
                                           + vOvf['tot',t]
                                           + vOffInv[t]
                                           + vOffSub[t]
                                           + vOffUdRest[t];

  # Indkomstoverførsler - satser
  E_vOvfSats_satsreg[satsreg,t]$(tx0[t])..
    vOvfSats[satsreg,t] =E= vSatsIndeks[t] * uvOvfSats[satsreg,t];

  E_vOvfSats_groen[t]$(tx0[t])..
    vOvfSats['groen',t] =E= vOvfSats['groen',t-1]/fp + uvOvfSats['groen',t];

  # Antal modtagere af overførsler knyttet til sociogrupper
  E_nOvf[ovf,t]$(tx0[t] and not (ovf_a0t17[ovf] or ovf_a18t100[ovf]))..
    nOvf[ovf,t] =E= sum(soc, nOvf2Soc[ovf,soc] * nSoc[soc,t]);

  # Overførsler som fordeles på alle under 18
  E_nOvf_a0t17[ovf,t]$(tx0[t] and ovf_a0t17[ovf])..
    nOvf[ovf,t] =E= nPop['a0t17',t];

  # Overførsler som fordeles på alle over 18
  E_nOvf_a18t100[ovf,t]$(tx0[t] and ovf_a18t100[ovf])..
    nOvf[ovf,t] =E= nPop['a18t100',t];

  # Indkomstoverførsler - samlet udgift fordelt på overførselstype
  E_vOvf[ovf,t]$(tx0[t]).. vOvf[ovf,t] =E= vOvfSats[ovf,t] * nOvf[ovf,t] + jvOvf[ovf,t];

  E_vOvf_tot[t]$(tx0[t] and t.val > 2015).. vOvf['tot',t] =E= sum(ovf, vOvf[ovf,t]);
  E_vOvf_hh[t]$(tx0[t] and t.val > 2015)..  vOvf['hh',t]  =E= sum(ovfhh, vOvf[ovfhh,t]);

  E_vOvf_a18t100[t]$(tx0[t] and t.val > 2015)..
    vOvf['a18t100',t] =E= sum(ovf$(ovf_a18t100[ovf]), vOvf[ovf,t]) / nPop['a18t100',t];

  # Aldersfordelte indkomstoverførsler
  E_vHhOvf[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
    vHhOvf[a,t] =E= (  dvOvf2dBesk['hh',t] * nLHh[a,t] / nPop[a,t]
                     + dvOvf2dPop['hh',t] * uHhOvfPop[a,t]
                     + sum(ovf$(ovf_a0t17[ovf]), vOvf[ovf,t]) * rBoern[a,t]
                     + vOvf['a18t100',t]$(a18t100[a])
                     + sum(ovf, jvOvf[ovf,t]) / nPop['a15t100',t]
                     + vHhOvfRest[a,t]
                   ) * fHhOvf[t];

  # Antallet af overførselsmodtager følger befolkningsstørrelsen samt beskæftigelsen
  # dnOvf2dBesk og dnOvf2dPop kan gøres eksogene for at spare beregning
  E_dnOvf2dBesk[ovf,t]$(tx0[t])..
    dnOvf2dBesk[ovf,t] =E= sum(soc, dSoc2dBesk[soc,t] * nOvf2Soc[ovf,soc]);
  E_dnOvf2dPop[ovf,t]$(tx0[t] and t.val > 1990)..
    dnOvf2dPop[ovf,t] =E= sum(soc, (dSoc2dPop[soc,t] + jnSoc[soc,t] / nPop['a15t100',t]) * nOvf2Soc[ovf,soc]);

  # Indkomstoverførsler følger antallet af modtagere
  E_dvOvf2dBesk[ovf,t]$(tx0[t]).. dvOvf2dBesk[ovf,t] =E= vOvfSats[ovf,t] * dnOvf2dBesk[ovf,t];
  E_dvOvf2dBesk_hh[t]$(tx0[t]).. dvOvf2dBesk['hh',t] =E= sum(ovfhh, dvOvf2dBesk[ovfhh,t]);

  E_dvOvf2dPop[ovf,t]$(tx0[t]).. dvOvf2dPop[ovf,t] =E= vOvfSats[ovf,t] * dnOvf2dPop[ovf,t];
  E_dvOvf2dPop_hh[t]$(tx0[t]).. dvOvf2dPop['hh',t] =E= sum(ovfhh, dvOvf2dPop[ovfhh,t]);

  # Korrektionsfaktor som sikre afbalancering af overførsler-indkomster fordelt på henholdsvis alder og overførselstype.
  E_fHhOvf[t]$(tx0[t] and t.val > 2015).. vOvf['hh',t] =E= sum(a, vHhOvf[a,t] * nPop[a,t]);

  # Opdeling af ubeskattede og skattepligtige overførsler
  E_vOvfUbeskat_tot[t]$(tx0[t] and t.val > 2000).. vOvfUbeskat['tot',t] =E= sum(ovfhh$(ubeskat[ovfhh]), vOvf[ovfhh,t]);
  E_vOvfUbeskat[a,t]$(a.val <= 100 and tx0[t] and t.val > 2015)..
    #  vOvfUbeskat[a,t] =E= rOvfUbeskat[a,t] * (vOvfUbeskat['tot',t] / nPop[a,t]);
    vOvfUbeskat[a,t] =E= uOvfUbeskat[a,t] * vOvfUbeskat['tot',t] / sum(aa, uOvfUbeskat[aa,t] * nPop[aa,t]);

  E_vOvfSkatPl_tot[t]$(tx0[t] and t.val > 2015).. vOvfSkatPl[aTot,t] =E= sum(a, vOvfSkatPl[a,t] * nPop[a,t]);
  E_vOvfSkatPl[a,t]$(tx0[t] and t.val > 2015).. vOvfSkatPl[a,t] =E= vHhOvf[a,t] - vOvfUbeskat[a,t];

  # Offentlige investeringer
  E_vOffInv[t]$(tx0[t]).. vOffInv[t] =E= vI_s[iTot,'off',t];

  # Subsidier
  E_vOffSub[t]$(tx0[t])..  vOffSub[t]  =E= vPunktSub[t] + vSubY[t] - vSubEU[t];
  E_vSubYRes[t]$(tx0[t]).. vSubYRes[t] =E= rvYsubRest2BVT[t] * vBVT['tot',t];
  E_vSubY[t]$(tx0[t])..    vSubY[t]    =E= vtSubLoen['tot',t] + vSubYRes[t];
  E_vSubEU[t]$(tx0[t])..   vSubEU[t]   =E= vBNP[t] * rSubEU2BNP[t];

  # Øvrige offentlige udgifter
  E_vOffUdRest[t]$(tx0[t]).. 
    vOffUdRest[t] =E= vOffLandKoeb[t] + vOffTilUdl[t] + vOffTilHh[t] + vOffTilVirk[t];

  E_vOffTilHh[t]$(tx0[t])..    vOffTilHh[t]    =E= vOffTilHhKap[t] + vOffTilHhOev[t];

  E_vOffLandKoeb[t]$(tx0[t]).. vOffLandKoeb[t] =E= vBNP[t] * rOffLandKoeb2BNP[t];
  E_vOffTilUdl[t]$(tx0[t])..   vOffTilUdl[t]   =E= vBNP[t] * rOffTilUdl2BNP[t];
  E_vOffTilHhKap[t]$(tx0[t]).. vOffTilHhKap[t] =E= vBNP[t] * rOffTilHhKap2BNP[t];
  E_vOffTilHhOev[t]$(tx0[t]).. vOffTilHhOev[t] =E= vBNP[t] * rOffTilHhOev2BNP[t];
  E_vOffTilVirk[t]$(tx0[t])..  vOffTilVirk[t]  =E= vBNP[t] * rOffTilVirk2BNP[t];
  $ENDBLOCK
$ENDIF