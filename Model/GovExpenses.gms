# ======================================================================================================================
# Government expenses
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_GovExpenses_prices_endo
    pGxAfskr[t]$(tx0[t]) "Deflator for offentligt forbrug fratrukket offentlige afskrivninger, Kilde: ADAM[pCov]"
  ;
  $GROUP G_GovExpenses_quantities_endo
    qGxAfskr[t] "Offentligt forbrug fratrukket offentlige afskrivninger, Kilde: ADAM[fCov]"
    qG[g_,t]$(not gTot[g_]) "Offentligt forbrug, Kilde: ADAM[fCo]"
  ;

  $GROUP G_GovExpenses_values_a_endo
    vOvfUbeskat[a_,t]$(a0t100[a_] and t.val > 2015) "Ubeskattede indkomstoverførsler pr. person (i befolkningen) fordelt på alder."
    vHhOvf[a,t]$(a15t100[a] and t.val > 2015) "Indkomstoverførsler til indl. hush. pr. person (i befolkningen) fordelt på alder."
    vOvfSkatPl[a_,t]$(t.val > 2015 and not aTot[a_]) "Skattepligtige indkomstoverførsler pr. person (i befolkningen) fordelt på alder."
  ;
  $GROUP G_GovExpenses_values_endo
    G_GovExpenses_values_a_endo

    vGxAfskr[t] "Offentligt forbrug fratrukket offentlige afskrivninger, Kilde: ADAM[Cov]"
    vOffPrimUd[t] "Primære offentlige udgifter, Kilde: ADAM[Tf_o_z]-ADAM[Ti_o_z]"
    vOffInv[t] "Offentlige investeringer, Kilde: ADAM[Io1]"
    vOffSub[t] "Dansk finansieret subsidier ialt, Kilde: ADAM[Spu_o]"
    vSubY[t] "Produktionssubsidier, Kilde: ADAM[Spzu]"
    vSubYRest[s_,t]$(sTot[s_] or s[s_]) "Produktionssubsidier ekskl. løntilskud, Kilde: ADAM[Spzu]-ADAM[Spzul] og imputeret branchefordeling"
    vOffUdRest[t] "Øvrige offentlige udgifter."
    vOffTilHh[t] "Residuale overførsler fra offentlig sektor til husholdningerne, Kilde: ADAM[tK_o_h]+ADAM[Tr_o_h])"
    vOvf[ovf_,t]$(t.val > 2015) "Sociale overførsler fra offentlig forvaltning og service til husholdninger, Kilde: ADAM[Ty_o] for underkomponenter jf. o-set."
    vOvfSkatPl[a_,t]$(t.val > 2015 and aTot[a_]) "Skattepligtige indkomstoverførsler pr. person (i befolkningen) fordelt på alder."
    vOvfUbeskat[a_,t]$(aTot[a_] and tBFR[t]) "Ubeskattede indkomstoverførsler pr. person (i befolkningen) fordelt på alder."
    vOvfSats[ovf,t]$(t.val > 2015) "Sociale overførsler fra offentlig forvaltning og service til husholdninger pr. person i basen (mio. kr.)"
    vGLukning[t] "Udgift til beregningsteknisk stigning i offentligt forbrug til lukning af offentlig budgetrestriktion. Indgår IKKE i offentlig saldo."
    vOffTilUdl[t] "Samlede overførsler fra offentlig sektor til udlandet"

    jvOvf[ovf_,t]$(ovftot[ovf_]) "J-led som fanger at nogle grupper har en overførsel, men ingen modtagere. Fordeles til husholdningerne gennem fHhOvf."
  ;

  $GROUP G_GovExpenses_endo_a
    fHhOvf[t]$(t.val > 2015) "Korrektionsfaktor som sikre afbalancering af overførsler-indkomster fordelt på henholdsvis alder og overførselstype."
    G_GovExpenses_values_a_endo
  ;
  $GROUP G_GovExpenses_endo
    G_GovExpenses_endo_a

    G_GovExpenses_prices_endo
    G_GovExpenses_quantities_endo
    G_GovExpenses_values_endo

    uvGxAfskr[t] "Skala-parameter som bestemmer niveau for offentligt service før korrektion for demografisk træk og løn-niveau."

    nOvf[ovf,t] "Basen til sociale overførsler i antal 1000 personer fordelt på ordninger."

    dnOvf2dBesk[ovf,t] "Marginal ændring i antal modtagere af overførsel ovf ved ændring i den samlede beskæftigelse."
    dnOvf2dPop[ovf,t]$(t.val >= 1992) "Marginal ændring i antal modtagere af overførsel ovf ved ændring i den samlede befolkningsstørrelse."
    dvOvf2dBesk[ovf_,t]$(ovf[ovf_] or hh[ovf_]) "Marginal ændring i udgifter til overførsel ovf ved ændring i den samlede beskæftigelse."
    dvOvf2dPop[ovf_,t]$(ovf[ovf_] or hh[ovf_]) "Marginal ændring i udgifter til overførsel ovf ved ændring i den samlede befolkningsstørrelse."
    rOffLandKoeb2BNP[t] "Nettoopkob af jord og rettigheder relativt til BNP."
    rOffTilUdlKap2BNP[t] "Kapitaloverførsler fra offentlige sektor til udlandet relativt til BNP."
    rOffTilUdlMoms2BNP[t] "Moms bidrag fra offentlig sektor til EU relativt til BNP."
    rOffTilUdlBNI2BNP[t] "BNI-bidrag fra offentlig sektor til EU relativt til BNP."
    rOffTilUdlEU2BNP[t] "Øvrige overførsler fra offentlig sektor til EU relativt til BNP."
    rOffTilUdlFO2BNP[t] "Residuale overførsler fra offentlig sektor til Færøerne relativt til BNP."
    rOffTilUdlGL2BNP[t] "Residuale overførsler fra offentlig sektor til Grønland relativt til BNP."
    rOffTilUdlBistand2BNP[t] "Offentlige overførsler til udlandet relativt til BNP."
    rOffTilVirk2BNP[t] "Offentlige overførsler til selskaber relativt til BNP."
    rOffTilHhKap2BNP[t] "Offentlige kapitaloverførsler til husholdninger relativt til BNP."
    rOffTilHhNPISH2BNP[t] "Residuale øvrige offentlige overførsler til NPISH relativt til BNP."
    rOffTilHhTillaeg2BNP[t] "Residuale øvrige offentlige overførsler til husholdninger relativt til BNP."
    rOffTilHhRest2BNP[t] "Residuale øvrige offentlige overførsler til husholdninger relativt til BNP."
    rSubEU2BNP[t] "Subsidier finansieret af EU relativt til BNP."
    rvSubYRest2BVT[s_,t]$(sTot[s_]) "Produktionssubsidier ekskl. løntilskud relativt til BVT."
  ;
  $GROUP G_GovExpenses_endo
    G_GovExpenses_endo$(tx0[t]) # Restrict endo group to tx0[t]

    # Nutidsværdi af offentlige udgifter - Beregnes i post modellen
    nvOffPrimUd[t]$(tHBI.val <= t.val) "Nutidsværdi af offentlige udgifter."
    nvG[t]$(tHBI.val <= t.val) "Nutidsværdi af samlet offentligt forbrug"
    nvOvf[t]$(tHBI.val <= t.val) "Nutidsværdi af samlede overførsler"
    nvOvfHh[t]$(tHBI.val <= t.val) "Nutidsværdi af samlede overførsler"
    nvOvfPens[t]$(tHBI.val <= t.val) "Nutidsværdi af samlede overførsler"
    
    nvOvftjmand[t]$(tHBI.val <= t.val) "Nutidsværdi af samlede overførsler"
    nvOvffortid[t]$(tHBI.val <= t.val) "Nutidsværdi af samlede overførsler"
    nvOvfuddsu[t]$(tHBI.val <= t.val) "Nutidsværdi af samlede overførsler"
    nvOvfsyge[t]$(tHBI.val <= t.val) "Nutidsværdi af samlede overførsler"
    nvOvfboernyd[t]$(tHBI.val <= t.val) "Nutidsværdi af samlede overførsler"
    nvOvfbarsel[t]$(tHBI.val <= t.val) "Nutidsværdi af samlede overførsler"
    nvOvfleddag[t]$(tHBI.val <= t.val) "Nutidsværdi af samlede overførsler"
    
    nvOffInv[t]$(tHBI.val <= t.val) "Nutidsværdi af offentlige investeringer"
    nvOffSub[t]$(tHBI.val <= t.val) "Nutidsværdi af dansk finansieret subsidier ialt"
    nvOffUdRest[t]$(tHBI.val <= t.val) "Nutidsværdi af øvrige offentlige udgifter"
    nvPunktSub[t]$(tHBI.val <= t.val) "Nutidsværdi af øvrige offentlige udgifter"
    nvSubY[t]$(tHBI.val <= t.val) "Nutidsværdi af produktionssubsidier"
    nvOffLandkoeb[t]$(tHBI.val <= t.val) "Nutidsværdi af offentlig landkøb"
    nvofftiludl[t]$(tHBI.val <= t.val) "Nutidsværdi af overførsler til udlandet"
    nvOffTilHh[t]$(tHBI.val <= t.val) "Nutidsværdi af residuale overførsler til husholdninger"
    nvOffTilVirk[t]$(tHBI.val <= t.val) "Nutidsværdi af residuale overførsler til virksomheder"
  ;

  $GROUP G_GovExpenses_prices
    G_GovExpenses_prices_endo
  ;
  $GROUP G_GovExpenses_quantities
    G_GovExpenses_quantities_endo
  ;
  $GROUP G_GovExpenses_values
    G_GovExpenses_values_endo

    vOffLandKoeb[t] "Den offentlige sektors nettoopkøb af jord og rettigheder, Kilde: ADAM[Izn_o]"
    vOffTilUdlKap[t] "Kapitaloverførsler fra offentlig sektor til udlandet, Kilde: ADAM[tK_o_e]"
    vOffTilUdlMoms[t] "Momsbidrag fra offentlig sektor til EU, Kilde: ADAM[Trg_o_eu] "
    vOffTilUdlBNI[t] "BNI-bidrag fra offentlig sektor til EU, Kilde: ADAM[Try_o_eu] "
    vOffTilUdlEU[t] "Øvrige overførsler fra offentlig sektor til EU, Kilde: ADAM[Trr_o_eu] "
    vOffTilUdlFO[t] "Residuale overførsler fra offentlig sektor til Færøerne, Kilde: ADAM[Tr_o_ef] "
    vOffTilUdlGL[t] "Residuale overførsler fra offentlig sektor til Grønland, Kilde: ADAM[Tr_o_eg] "
    vOffTilUdlBistand[t] "Udlandsbistand mv., Kilde: ADAM[Trr_o_e] "
    vOffTilVirk[t] "Residuale overførsler fra offentlig sektor til indenlandske selskaber, Kilde: ADAM[tK_o_c]"
    vOffTilHhKap[t] "Residuale kapitaloverførsler fra offentlig sektor til husholdningerne, Kilde: ADAM[tK_o_h])"
    vOffTilHhNPISH[t] "Residuale øvrige overførsler fra offentlig sektor til NPISH, Kilde: ADAM[Tr_o_hnpis])"
    vOffTilHhTillaeg[t] "Residuale øvrige overførsler fra offentlig sektor til husholdningerne, Kilde: ADAM[Typi])"
    vOffTilHhRest[t] "Residuale øvrige overførsler fra offentlig sektor til husholdningerne, Kilde: ADAM[Trr_o_h])"
    vSubEU[t] "Subsider finansieret af EU, Kilde: ADAM[Spueu]"
    vNulvaekstIndeks[t] "Nulvækstindeks er 1 i en ikke-vækst- og inflationskorrigeret bank - og modsvarer ellers korrektion"
  ;

  $GROUP G_GovExpenses_ARIMA_forecast
    uG[g_,t] "Skalaparameter i det offentlige forbrugsnest."
    rvSubYRest2BVT[s_,t] "Produktionssubsidier ekskl. løntilskud relativt til BVT."

    # Endogene i stødforløb:
    rOffLandKoeb2BNP
    rOffTilUdlKap2BNP
    rOffTilUdlMoms2BNP
    rOffTilUdlBNI2BNP
    rOffTilUdlEU2BNP
    rOffTilUdlFO2BNP
    rOffTilUdlGL2BNP
    rOffTilUdlBistand2BNP
    rOffTilVirk2BNP
    rOffTilHhKap2BNP
    rOffTilHhNPISH2BNP
    rOffTilHhTillaeg2BNP
    rOffTilHhRest2BNP
    rSubEU2BNP
  ;
  $GROUP G_GovExpenses_constants
      eG[g_] "Substitutionselasticitet mellem forskellige grupper af offentligt forbrug."
  ;
  $GROUP G_GovExpenses_other
    rGLukning[t] "Beregningsteknisk stigning i offentligt forbrug til lukning af offentlig budgetrestriktion."
    uHhOvfRest[a,t] "Residual som sikrer at samlede overførselsindkomster til en aldersgruppe passer til aldersprofil."
  ;
  $GROUP G_GovExpenses_exogenous_forecast
    fDemoTraek[t] "Demografisk træk."
    uHhOvfPop[a,t] "Aldersmæssig fordelingsnøgle knyttet til dvOvf2dPop."
    uOvfUbeskat[a,t] "Aldersmæssig fordelingsnøgle knyttet til vOvfUbeskat."

    rPensAlder[a,t] "Andel i folkepensionsalderen (0, 0.5, eller 1)."
    rEfterlAlder[a,t] "Andel i efterlønsalderen (0, 0.5, eller 1)."
  ;
  $GROUP G_GovExpenses_forecast_as_zero
    jvOvf
    uvOvfSats[ovf,t]$(sameas['groen',ovf]) "Skalaparameter for overførselssatser."
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_GovExpenses_aTot
    # ----------------------------------------------------------------------------------------------------------------------
    # Offentligt forbrug
    # ----------------------------------------------------------------------------------------------------------------------
    E_vGxAfskr[t]$(tx0[t]).. vGxAfskr[t] =E= vG[gTot,t] - vOffAfskr[kTot,t];
    E_pGxAfskr[t]$(tx0[t]).. pGxAfskr[t] * qGxAfskr[t] =E= vGxAfskr[t];
    E_qGxAfskr[t]$(tx0[t])..
      qGxAfskr[t] * pGxAfskr[t-1]/fp =E= pG[gTot,t-1]/fp * qG[gTot,t] - pOffAfskr[kTot,t-1]/fp * qOffAfskr[kTot,t];

    # Long run policy rule: Aggregate public consumption excluding depreciations follow demographic needs and wage growth
    E_uvGxAfskr[t]$(tx0[t]).. vGxAfskr[t] =E= uvGxAfskr[t] * (1+rGLukning[t]) * fDemoTraek[t] * vhW[t];

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
                                               + vOffUdRest[t]
                                               - vGLukning[t];

    # Indkomstoverførsler - satser
    E_vOvfSats_satsreg[satsreg,t]$(tx0[t])..
      vOvfSats[satsreg,t] =E= vSatsIndeks[t] * uvOvfSats[satsreg,t];

    E_vOvfSats_groen[t]$(tx0[t])..
      vOvfSats['groen',t] =E= vNulvaekstIndeks[t] * uvOvfSats['groen',t];

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

    E_jvOvf_tot[t]$(tx0[t]).. jvOvf['tot',t] =E= sum(ovf, jvOvf[ovf,t]);

    E_vOvf_tot[t]$(tx0[t] and t.val > 2015).. vOvf['tot',t] =E= sum(ovf, vOvf[ovf,t]);
    E_vOvf_hh[t]$(tx0[t] and t.val > 2015)..  vOvf['hh',t]  =E= sum(ovfhh, vOvf[ovfhh,t]);

    E_vOvf_a18t100[t]$(tx0[t] and t.val > 2015)..
      vOvf['a18t100',t] =E= sum(ovf_a18t100, vOvf[ovf_a18t100,t]) / nPop['a18t100',t];

    E_vOvf_a0t17[t]$(tx0[t] and t.val > 2015)..
      vOvf['a0t17',t] =E= sum(ovf_a0t17, vOvf[ovf_a0t17,t]) / nPop['a0t17',t];


    # Antallet af overførselsmodtager følger befolkningsstørrelsen samt beskæftigelsen
    # dnOvf2dBesk og dnOvf2dPop kan gøres eksogene for at spare beregning
    E_dnOvf2dBesk[ovf,t]$(tx0[t])..
      dnOvf2dBesk[ovf,t] =E= sum(soc, dSoc2dBesk[soc,t] * nOvf2Soc[ovf,soc]);
    E_dnOvf2dPop[ovf,t]$(tx0[t] and t.val >= 1992)..
      dnOvf2dPop[ovf,t] =E= sum(soc, (dSoc2dPop[soc,t] + jnSoc[soc,t] / nPop['a15t100',t]) * nOvf2Soc[ovf,soc]);

    # Indkomstoverførsler følger antallet af modtagere
    E_dvOvf2dBesk[ovf,t]$(tx0[t]).. dvOvf2dBesk[ovf,t] =E= vOvfSats[ovf,t] * dnOvf2dBesk[ovf,t];
    E_dvOvf2dBesk_hh[t]$(tx0[t]).. dvOvf2dBesk['hh',t] =E= sum(ovfhh, dvOvf2dBesk[ovfhh,t]);

    E_dvOvf2dPop[ovf,t]$(tx0[t]).. dvOvf2dPop[ovf,t] =E= vOvfSats[ovf,t] * dnOvf2dPop[ovf,t];
    E_dvOvf2dPop_hh[t]$(tx0[t]).. dvOvf2dPop['hh',t] =E= sum(ovfhh, dvOvf2dPop[ovfhh,t]);

    # Opdeling af ubeskattede og skattepligtige overførsler
    E_vOvfUbeskat_tot[t]$(tx0[t] and tBFR[t]).. vOvfUbeskat[aTot,t] =E= sum(ovfhh$(ubeskat[ovfhh]), vOvf[ovfhh,t]);

    E_vOvfSkatPl_tot[t]$(tx0[t] and t.val > 2015).. vOvfSkatPl[aTot,t] =E= vOvf['hh',t] - vOvfUbeskat[aTot,t];

    # Offentlige investeringer
    E_vOffInv[t]$(tx0[t]).. vOffInv[t] =E= vI_s[iTot,'off',t];

    # Subsidier
    E_vOffSub[t]$(tx0[t]).. vOffSub[t] =E= vPunktSub[t] + vSubY[t] - vSubEU[t];
    E_vSubYRest[s,t]$(tx0[t]).. vSubYRest[s,t] =E= rvSubYRest2BVT[s,t] * vBVT[s,t];
    E_vSubYRest_Tot[t]$(tx0[t]).. vSubYRest[sTot,t] =E= rvSubYRest2BVT[sTot,t] * vBVT[sTot,t];
    E_rvSubYRest2BVT_sTot[t]$(tx0[t]).. vSubYRest[sTot,t] =E= sum(s, vSubYRest[s,t]);
    E_vSubY[t]$(tx0[t]).. vSubY[t] =E= vSubLoen[sTot,t] + vSubYRest[sTot,t];
    E_vSubEU[t]$(tx0[t]).. vSubEU[t] =E= vBNP[t] * rSubEU2BNP[t];

    # Øvrige offentlige udgifter
    E_vOffUdRest[t]$(tx0[t]).. 
      vOffUdRest[t] =E= vOffLandKoeb[t] + vOffTilUdl[t] + vOffTilHh[t] + vOffTilVirk[t];

    E_vOffLandKoeb[t]$(tx0[t]).. vOffLandKoeb[t] =E= vBNP[t] * rOffLandKoeb2BNP[t];

    E_vOffTilUdl[t]$(tx0[t])..
      vOffTilUdl[t] =E= vOffTilUdlKap[t] + vOffTilUdlMoms[t] + vOffTilUdlBNI[t] + vOffTilUdlEU[t]
                      + vOffTilUdlFO[t] + vOffTilUdlGL[t] + vOffTilUdlBistand[t];
    E_vOffTilUdlKap[t]$(tx0[t]).. vOffTilUdlKap[t] =E= vBNP[t] * rOffTilUdlKap2BNP[t];
    E_vOffTilUdlMoms[t]$(tx0[t]).. vOffTilUdlMoms[t] =E= vBNP[t] * rOffTilUdlMoms2BNP[t];
    E_vOffTilUdlBNI[t]$(tx0[t]).. vOffTilUdlBNI[t] =E= vBNP[t] * rOffTilUdlBNI2BNP[t];
    E_vOffTilUdlEU[t]$(tx0[t]).. vOffTilUdlEU[t] =E= vBNP[t] * rOffTilUdlEU2BNP[t];
    E_vOffTilUdlFO[t]$(tx0[t]).. vOffTilUdlFO[t] =E= vBNP[t] * rOffTilUdlFO2BNP[t];
    E_vOffTilUdlGL[t]$(tx0[t]).. vOffTilUdlGL[t] =E= vBNP[t] * rOffTilUdlGL2BNP[t];
    E_vOffTilUdlBistand[t]$(tx0[t]).. vOffTilUdlBistand[t] =E= vBNP[t] * rOffTilUdlBistand2BNP[t];

    E_vOffTilHh[t]$(tx0[t]).. vOffTilHh[t] =E= vOffTilHhKap[t] + vOffTilHhNPISH[t] + vOffTilHhTillaeg[t] + vOffTilHhRest[t];
    E_vOffTilHhKap[t]$(tx0[t]).. vOffTilHhKap[t] =E= vBNP[t] * rOffTilHhKap2BNP[t];
    E_vOffTilHhNPISH[t]$(tx0[t]).. vOffTilHhNPISH[t] =E= vBNP[t] * rOffTilHhNPISH2BNP[t];
    E_vOffTilHhTillaeg[t]$(tx0[t]).. vOffTilHhTillaeg[t] =E= vBNP[t] * rOffTilHhTillaeg2BNP[t];
    E_vOffTilHhRest[t]$(tx0[t]).. vOffTilHhRest[t] =E= vBNP[t] * rOffTilHhRest2BNP[t];

    E_vOffTilVirk[t]$(tx0[t]).. vOffTilVirk[t] =E= vBNP[t] * rOffTilVirk2BNP[t];

    # ----------------------------------------------------------------------------------------------------------------------
    #   Ligninger til beregning af nutidsværdien af offentlige udgifter 
    # ----------------------------------------------------------------------------------------------------------------------  
    E_nvOffPrimUd[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOffPrimUd[t] =E= vOffPrimUd[t] * fHBIDisk[t] + nvOffPrimUd[t+1];
    E_nvOffPrimUd_tEnd[t]$(tEnd[t])..
      nvOffPrimUd[t] =E= vOffPrimUd[t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvG[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvG[t] =E= vG[gTot,t] * fHBIDisk[t] + nvG[t+1];
    E_nvG_tEnd[t]$(tEnd[t])..
      nvG[t] =E= vG[gTot,t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvOvf[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOvf[t] =E= vOvf['tot',t] * fHBIDisk[t] + nvOvf[t+1];
    E_nvOvf_tEnd[t]$(tEnd[t])..
      nvOvf[t] =E= vOvf['tot',t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvOvfpens[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOvfpens[t] =E= vOvf['pension',t] * fHBIDisk[t] + nvOvfpens[t+1];
    E_nvOvfpens_tEnd[t]$(tEnd[t])..
      nvOvfpens[t] =E= vOvf['pension',t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvOvfhh[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOvfhh[t] =E= vOvf['hh',t] * fHBIDisk[t] + nvOvfhh[t+1];
    E_nvOvfhh_tEnd[t]$(tEnd[t])..
      nvOvfhh[t] =E= vOvf['hh',t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);


    E_nvOvftjmand[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOvftjmand[t] =E= vOvf['tjmand',t] * fHBIDisk[t] + nvOvftjmand[t+1];
    E_nvOvftjmand_tEnd[t]$(tEnd[t])..
      nvOvftjmand[t] =E= vOvf['tjmand',t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvOvffortid[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOvffortid[t] =E= vOvf['fortid',t] * fHBIDisk[t] + nvOvffortid[t+1];
    E_nvOvffortid_tEnd[t]$(tEnd[t])..
      nvOvffortid[t] =E= vOvf['fortid',t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvOvfuddsu[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOvfuddsu[t] =E= vOvf['uddsu',t] * fHBIDisk[t] + nvOvfuddsu[t+1];
    E_nvOvfuddsu_tEnd[t]$(tEnd[t])..
      nvOvfuddsu[t] =E= vOvf['uddsu',t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);


    E_nvOvfsyge[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOvfsyge[t] =E= vOvf['syge',t] * fHBIDisk[t] + nvOvfsyge[t+1];
    E_nvOvfsyge_tEnd[t]$(tEnd[t])..
      nvOvfsyge[t] =E= vOvf['syge',t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvOvfboernyd[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOvfboernyd[t] =E= vOvf['boernyd',t] * fHBIDisk[t] + nvOvfboernyd[t+1];
    E_nvOvfboernyd_tEnd[t]$(tEnd[t])..
      nvOvfboernyd[t] =E= vOvf['boernyd',t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvOvfbarsel[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOvfbarsel[t] =E= vOvf['barsel',t] * fHBIDisk[t] + nvOvfbarsel[t+1];
    E_nvOvfbarsel_tEnd[t]$(tEnd[t])..
      nvOvfbarsel[t] =E= vOvf['barsel',t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvOvfleddag[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOvfleddag[t] =E= vOvf['leddag',t] * fHBIDisk[t] + nvOvfleddag[t+1];
    E_nvOvfleddag_tEnd[t]$(tEnd[t])..
      nvOvfleddag[t] =E= vOvf['leddag',t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvOffInv[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOffInv[t] =E= vOffInv[t] * fHBIDisk[t] + nvOffInv[t+1];
    E_nvOffInv_tEnd[t]$(tEnd[t])..
      nvOffInv[t] =E= vOffInv[t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvOffSub[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOffSub[t] =E= vOffSub[t] * fHBIDisk[t] + nvOffSub[t+1];
    E_nvOffSub_tEnd[t]$(tEnd[t])..
      nvOffSub[t] =E= vOffSub[t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvOffUdRest[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOffUdRest[t] =E= vOffUdRest[t] * fHBIDisk[t] + nvOffUdRest[t+1];
    E_nvOffUdRest_tEnd[t]$(tEnd[t])..
      nvOffUdRest[t] =E= vOffUdRest[t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvPunktSub[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvPunktSub[t] =E= vPunktSub[t] * fHBIDisk[t] + nvPunktSub[t+1];
    E_nvPunktSub_tEnd[t]$(tEnd[t])..
      nvPunktSub[t] =E= vPunktSub[t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvSubY[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvSubY[t] =E= vSubY[t] * fHBIDisk[t] + nvSubY[t+1];
    E_nvSubY_tEnd[t]$(tEnd[t])..
      nvSubY[t] =E= vSubY[t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvOffLandkoeb[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOffLandkoeb[t] =E= vOffLandkoeb[t] * fHBIDisk[t] + nvOffLandkoeb[t+1];
    E_nvOffLandkoeb_tEnd[t]$(tEnd[t])..
      nvOffLandkoeb[t] =E= vOffLandkoeb[t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvOffTilUdl[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOffTilUdl[t] =E= vOffTilUdl[t] * fHBIDisk[t] + nvOffTilUdl[t+1];
    E_nvOffTilUdl_tEnd[t]$(tEnd[t])..
      nvOffTilUdl[t] =E= vOffTilUdl[t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvOffTilHh[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOffTilHh[t] =E= vOffTilHh[t] * fHBIDisk[t] + nvOffTilHh[t+1];
    E_nvOffTilHh_tEnd[t]$(tEnd[t])..
      nvOffTilHh[t] =E= vOffTilHh[t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvOffTilVirk[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOffTilVirk[t] =E= vOffTilVirk[t] * fHBIDisk[t] + nvOffTilVirk[t+1];
    E_nvOffTilVirk_tEnd[t]$(tEnd[t])..
      nvOffTilVirk[t] =E= vOffTilVirk[t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

  $ENDBLOCK

  $BLOCK B_GovExpenses_a
    # Korrektionsfaktor som sikre afbalancering af overførsler-indkomster fordelt på henholdsvis alder og overførselstype.
    E_fHhOvf[t]$(tx0[t] and t.val > 2015).. vOvf['hh',t] =E= sum(a, vHhOvf[a,t] * nPop[a,t]);

    # Aldersfordelte indkomstoverførsler
    E_vHhOvf[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vHhOvf[a,t] =E= (  dvOvf2dBesk['hh',t] * nLHh[a,t] / nPop[a,t]
                       + dvOvf2dPop['hh',t] * uHhOvfPop[a,t]
                       + vOvf['a0t17',t] * rBoern[a,t]
                       + vOvf['a18t100',t]$(a18t100[a])
                       + jvOvf['tot',t] / nPop['a15t100',t]
                       + uHhOvfRest[a,t] * vSatsIndeks[t]
                     ) * fHhOvf[t];

    E_vOvfUbeskat[a,t]$(a.val <= 100 and tx0[t] and t.val > 2015)..
      vOvfUbeskat[a,t] =E= uOvfUbeskat[a,t] / sum(aa, uOvfUbeskat[aa,t] * nPop[aa,t]) * vOvfUbeskat[aTot,t];

    E_vOvfSkatPl[a,t]$(tx0[t] and t.val > 2015).. vOvfSkatPl[a,t] =E= vHhOvf[a,t] - vOvfUbeskat[a,t];
  $ENDBLOCK

  MODEL M_GovExpenses /
    B_GovExpenses_a
    B_GovExpenses_aTot
  /;

  # Equations that do not need to be solved together with the full model and can instead be solved afterwards.
  MODEL M_GovExpenses_post /
    E_nvOffPrimUd, E_nvOffPrimUd_tEnd
    E_nvG, E_nvG_tEnd
    E_nvOvf, E_nvOvf_tEnd
    E_nvOvfpens, E_nvOvfpens_tEnd
    E_nvOvfhh, E_nvOvfhh_tEnd
    E_nvOffInv, E_nvOffInv_tEnd
    E_nvOffSub, E_nvOffSub_tEnd
    E_nvOffUdRest, E_nvOffUdRest_tEnd
    E_nvPunktSub, E_nvPunktSub_tEnd
    E_nvSuby, E_nvSuby_tEnd
    E_nvOffLandkoeb, E_nvOffLandkoeb_tEnd
    E_nvOffTilUdl, E_nvOffTilUdl_tEnd
    E_nvOffTilHh, E_nvOffTilHh_tEnd
    E_nvOffTilVirk, E_nvOffTilVirk_tEnd
    E_nvOvftjmand, E_nvOvftjmand_tEnd
    E_nvOvffortid, E_nvOvffortid_tEnd
    E_nvOvfuddsu, E_nvOvfuddsu_tEnd
    E_nvOvfsyge, E_nvOvfsyge_tEnd
    E_nvOvfboernyd, E_nvOvfboernyd_tEnd
    E_nvOvfbarsel, E_nvOvfbarsel_tEnd
    E_nvOvfleddag, E_nvOvfleddag_tEnd
  /;

  # Endogenous variables that are solved for only after the main model.
  # Note that these may not appear anywhere in the main model (this results in a model not square error).
  $GROUP G_GovExpenses_post
    nvOffPrimUd
    nvG
    nvOvf
    nvOvfpens
    nvOvftjmand
    nvovffortid
    nvovfuddsu
    nvovfsyge
    nvovfboernyd
    nvovfbarsel
    nvovfleddag
    nvOvfhh
    nvOffInv
    nvOffSub
    nvOffUdRest
    nvSubY
    nvPunktSub
    nvOffLandkoeb
    nvOffTilUdl
    nvOffTilHh
    nvOffTilVirk
  ;
  $GROUP G_GovExpenses_post G_GovExpenses_post$(tHBI.val <= t.val and t.val <= tEnd.val);
$ENDIF

$IF %stage% == "exogenous_values":
# =============================================================================================½=========================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_GovExpenses_makrobk
    # Offentlige udgifter
    vG$(gTot[g_]), vOffSub, vSubY, vSubEU, vSubYRest
    vOffLandKoeb, vOffTilUdlKap, vOffTilUdlMoms, vOffTilUdlBNI, vOffTilUdlEU, vOffTilUdlFO, vOffTilUdlGL 
    vOffTilUdlBistand, vOffTilVirk, vOffTilHhKap, vOffTilHhNPISH, vOffTilHhTillaeg, vOffTilHhRest
    vOvf$(ovf[ovf_]  or hh[ovf_] or ovftot[ovf_])
    vOvfUbeskat$(t.val >= 1992 and aTot[a_])
    vOffPrimUd$(t.val > 2006)
    vOffInv$(t.val > 2006)
    # Øvrige variable
    qG, fDemoTraek
  ;
  @load(G_GovExpenses_makrobk, "..\Data\makrobk\makrobk.gdx" )

  # Aldersfordelt data fra aldersprofiler indlæses
  $GROUP G_GovExpenses_aldersprofiler
    vHhOvf$(tAgeData[t])
  ;
  @load(G_GovExpenses_aldersprofiler, "..\Data\Aldersprofiler\aldersprofiler.gdx" )

  # Aldersfordelte parametre fra BFR indlæses
  parameters 
    nOvf_a[ovf_,a_,t]             "Modtager-grupper fordelt på alder, antal 1.000 personer"
    nOvfFraSocResidual[ovf_,a_,t] "Residualeffekt fra befolkning på modtager-gruppe fordelt på alder, antal 1.000 personer"
  ;
  $GDXIN ..\Data\Befolkningsregnskab\BFR.gdx
    $LOAD nOvf_a, nOvfFraSocResidual
  $GDXIN
  $GROUP G_GovExpenses_BFR
    nPop, rPensAlder, rEfterlAlder
  ;
  @load(G_GovExpenses_BFR, "..\Data\Befolkningsregnskab\BFR.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_GovExpenses_data
    G_GovExpenses_makrobk
    G_GovExpenses_BFR
    jvOvf$(t.val > 1999 and not ovftot[ovf_])
    vOvfSats$(tBFR[t] and tADAMdata[t])
    uHhOvfPop$(a15t100[a] and tBFR[t] and tADAMdata[t])
    vOvfUbeskat$(a15t100[a_] and tBFR[t] and tADAMdata[t])
    uOvfUbeskat$(a15t100[a] and tBFR[t] and tADAMdata[t])
  ;
  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_GovExpenses_data_imprecise
    vOffPrimUd$(t.val > 2006)
    vOffSub
    vSubYRest, vSubY
    vOffInv$(t.val > 2006)
    vOvf$(ovftot[ovf_] or sameas['pension',ovf_])
    jvOvf$(t.val = 2021 and sameas[ovf_,'pension'])
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================

  vNulvaekstIndeks.l[t] = 1;
  pGxAfskr.l[t]$(tBase[t]) = 1; 

# ======================================================================================================================
# Data management
# ======================================================================================================================
  # Antager ens satser fordelt på alder - modtagergrupper tages fra BFR beregnet under data.gms
  vOvfSats.l[ovf,t]$(nOvf_a[ovf,aTot,t]) = vOvf.l[ovf,t] / nOvf_a[ovf,aTot,t];
  vOvfSats.l[ovf,t]$(nOvf_a[ovf,aTot,t] = 0) = vOvfSats.l[ovf,t-1];

  # Nogle grupper har en overførsel, men ingen modtagere - ryger i j-led
  jvOvf.l[ovf,t] = vOvf.l[ovf,t] - vOvfSats.l[ovf,t] * nOvf_a[ovf,aTot,t];

  uHhOvfPop.l[a,t]$(a15t100[a] and tBFR[t] and tADAMdata[t]) =          
    sum(ovfhh, vOvfSats.l[ovfhh,t] * nOvfFraSocResidual[ovfhh,a,t]) / nPop.l[a,t]  # Samlede overførsler pr. person i alder a, som ikke afhænger af beskæftigelsesfrekvens
  / sum(ovfhh, vOvfSats.l[ovfhh,t] * nOvfFraSocResidual[ovfhh,aTot,t]) * nPop.l['a15t100',t];  # Samlede overførsler i alt, som ikke afhænger af beskæftigelsesfrekvens

  # Aldersfordelte overførsler
  fHhOvf.l[t] = 1; # Balancerings mekanisk sættes til 1 i år hvor uHhOvfRest kalibreres

  # Ubeskattede overførsler pr. person følger ordningerne
  vOvfUbeskat.l[a,t]$(a15t100[a] and nPop.l[a,t]) = sum(ovf$(ubeskat[ovf]), vOvfSats.l[ovf,t] * nOvf_a[ovf,a,t]) / nPop.l[a,t];
  vOvfUbeskat.l[aTot,t] = sum(a, vOvfUbeskat.l[a,t] * nPop.l[a,t]);
  uOvfUbeskat.l[a,t]$(vOvfUbeskat.l[a,t] <> 0) = vOvfUbeskat.l[a,t] / (vOvfUbeskat.l[aTot,t] / nPop.l[aTot,t]); # Ubeskattede overførsler for a årig relativt til gennemsnitlig person
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_GovExpenses_static_calibration_base
    G_GovExpenses_endo
    -qG$(g[g_]), uG
    -vOvfSats[ovf,t], uvOvfSats[ovf,t]
    -vOvf[ovf_,t]$(ovf[ovf_]), jvOvf[ovf,t]
    -vOvf$(hh[ovf_]), vOvf$(sameas['pension',ovf_] and t.val > 2015)
    rvSubYRest2BVT$(s[s_]), -vSubYRest$(s[s_])
  ;

  $GROUP G_GovExpenses_simple_static_calibration
    G_GovExpenses_static_calibration_base
    - G_GovExpenses_endo_a
  ;
  $GROUP G_GovExpenses_simple_static_calibration G_GovExpenses_simple_static_calibration$(tx0[t]);

  MODEL M_GovExpenses_simple_static_calibration /
    M_GovExpenses 
    - B_GovExpenses_a
  /;

  $GROUP G_GovExpenses_static_calibration
    G_GovExpenses_static_calibration_base
    -vHhOvf, uHhOvfRest$(t.val > 2015)
    -fHhOvf # -E_fHhOvf
  ;
  $GROUP G_GovExpenses_static_calibration 
    G_GovExpenses_static_calibration$(tx0[t])
    pGxAfskr$(t0[t]), -pGxAfskr$(tBase[t])
  ;

  MODEL M_GovExpenses_static_calibration /
    M_GovExpenses
    - E_fHhOvf
  /;
$ENDIF

# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_GovExpenses_deep
    G_GovExpenses_endo
    -rOffLandKoeb2BNP$(tx1[t]), vOffLandKoeb$(tx1[t])
    -rOffTilUdlKap2BNP$(tx1[t]), vOffTilUdlKap$(tx1[t])
    -rOffTilUdlMoms2BNP$(tx1[t]), vOffTilUdlMoms$(tx1[t])
    -rOffTilUdlBNI2BNP$(tx1[t]), vOffTilUdlBNI$(tx1[t])
    -rOffTilUdlEU2BNP$(tx1[t]), vOffTilUdlEU$(tx1[t])
    -rOffTilUdlFO2BNP$(tx1[t]), vOffTilUdlFO$(tx1[t])
    -rOffTilUdlGL2BNP$(tx1[t]), vOffTilUdlGL$(tx1[t])
    -rOffTilUdlBistand2BNP$(tx1[t]), vOffTilUdlBistand$(tx1[t])
    -rOffTilVirk2BNP$(tx1[t]), vOffTilVirk$(tx1[t])
    -rOffTilHhKap2BNP$(tx1[t]), vOffTilHhKap$(tx1[t])
    -rOffTilHhNPISH2BNP$(tx1[t]), vOffTilHhNPISH$(tx1[t])
    -rOffTilHhTillaeg2BNP$(tx1[t]), vOffTilHhTillaeg$(tx1[t])
    -rOffTilHhRest2BNP$(tx1[t]), vOffTilHhRest$(tx1[t])
    -rSubEU2BNP$(tx1[t]), vSubEU$(tx1[t])
    hL$(sOff[s_]), -uvGxAfskr
  ;
  $GROUP G_GovExpenses_deep G_GovExpenses_deep$(tx0[t]);

#  $BLOCK B_Govexpenses_deep
#  $ENDBLOCK

MODEL M_GovExpenses_deep /
  M_GovExpenses - M_GovExpenses_post
  #  B_Govexpenses_deep
/;

$ENDIF

# ======================================================================================================================
# Simple dynamic calibration
# ======================================================================================================================
$IF %stage% == "simple_dynamic_calibration":
$GROUP G_GovExpenses_dynamic_calibration
  G_GovExpenses_endo
;
MODEL M_GovExpenses_dynamic_calibration /
  M_GovExpenses - M_GovExpenses_post 
/;
$ENDIF
