# ======================================================================================================================
# Structural levels
# - Potential output (Gross Value Added) and employment
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_struk_prices
    pKspBy[t] "(Investerings)Pris på aggregeret kapital-apparat i brancher med konjunkturgab."
  ;
  $GROUP G_struk_quantities
    sqBVT[t] "Strukturel BVT."
    sdqLdnL[s_,t] "sqL differentieret ift. snL."
    sdOpslagOmk2dnLLag[t] "sqL[t+1] differentieret ift. snL[t]"
    sqL[s_,t]$(spBy[s_] or spTot[s_]) "Strukturel arbejdskraft i effektive enheder."

    qKspBy[t] "Kapital i én-sektor Cobb-Douglas produktionsfunktion."
    qLspBy[t] "L i én-sektor Cobb-Douglas produktionsfunktion."
    sqLspBy[t] "Strukturelt L i én-sektor Cobb-Douglas produktionsfunktion."
  ;
  $GROUP G_struk_values
    empty_group_dummy
  ;
  $GROUP G_struk_endo
    G_struk_prices
    G_struk_quantities
    G_struk_values

    uY[t] "Produktivitetsparameter i én-sektor Cobb-Douglas produktionsfunktion (ikke TFP pga. kapacitetsudnyttelse mv.)."

    shL[t] "Strukturelle arbejdstimer i alt, Kilde: ADAM[hq]"
    srL2nL[t]$(t.val > 2015) "Strukturelle effektive timer pr. beskæftiget."
    sfW[s_,t] "Strukturelt branchespecifikt produktivitetsindeks for arbejdskraft. Vægtet gennemsnit er altid 1."
    sdOpslagOmk2dnL[t] "srOpslagOmk * snL differentieret ift. snL."
    sfProdHh[t] "Strukturelt gennemsnit af aldersgruppers produktivitet."

    snSoegBaseHh[a_,t]$((aTot[a_] or a15t100[a_]) and t.val > 2015) "Strukturel arbejdsstyrke."
    snLHh[a_,t]$(aTot[a_] or (a15t100[a_] and t.val > 2015)) "Strukturel beskæftigelse."
    snSoegHh[a_,t]$(aTot[a_] or (a15t100[a_] and t.val > 2015)) "Strukturel jobsøgende."
    sfDeltag[a,t]$(a15t100[a] and t.val > 2015) "Strukturel deltagelse."
    srJobFinding[t] "Strukturel andel af jobsøgende som får et job."
    srMatch[t] "Strukturel andel af jobopslag, som resulterer i et match."
    srOpslag2soeg[t] "Strukturel labor market tightness."
    shLHh[a_,t]$((aTot[a_] or a15t100[a_]) and t.val > 2015) "Strukturel aldersfordelt arbejdstid."
    srOpslagOmk[t] "Andel af arbejdskraft som går til hyrings-omkostninger strukturelt."
    snOpslag[t] "Strukturelt antal jobopslag."
    srSeparation[t]$(t.val > 2015) "Strukturel aggregeret separationsrate."

    snLUdl[t] "Strukturel udenlandsk arbejdskraft i antal hoveder - inkluderer pt. sort arbejde."
    shLUdl[t] "Strukturelle arbejdstimer for grænsearbejdere."
    snL[s_,t] "Strukturel beskæftigede inklusiv udenlandsk arbejdskraft."
    snSoegUdl[t] "Strukturel beskæftigede inklusiv udenlandsk arbejdskraft."

    snSoc[soc_,t]$(t.val > 2015) "Strukturelle værdier for socio-grupper og aggregater, antal 1.000 personer, Kilde: BFR."
    dSoc2dPop[soc_,t]$(sameas['boern',soc_] and t.val > 2015) "Befolkningssnøgle fordelt på socio-grupper" 
    srLedig[t]$(t.val > 2015) "Strukturel ledighedsrate."
  ; 

  $GROUP G_struk_exogenous_forecast
    snLHh[a_,t]
    shLHh[a,t]

    # Fordeling af socio-grupper  
    dSoc2dBesk[soc_,t] "Beskæftigelsesnøgle fordelt på socio-grupper."
    dSoc2dPop[soc_,t]

    #  snSoegBaseHh[a_,t]$(aTot[a_])
  ;
  $GROUP G_struk_other
    srLUdn[s_,t] "Strukturel kapacitetsudnyttelse på arbejdskraft."

    jshLHh[a,t] "J-led i strukturel timebeslutning."
    jsfDeltag[a,t] "J-led i strukturel deltagelsesbeslutning."

    juY[t] "J-led til residual i BVT-gab."
  ;
  $GROUP G_struk_endo G_struk_endo$(tx0[t]);
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_struk
    # ----------------------------------------------------------------------------------------------------------------------
    # Strukturel BVT
    # ----------------------------------------------------------------------------------------------------------------------
    E_sqBVT[t]$(tx0[t]).. sqBVT[t] =E= uY[t] * sqLspBy[t]**0.65 * qKspBy[t]**0.35 + sum(s$(not spBy[s]), qBVT[s,t]);
    # Vi finder strukturelt TFP på baggrund af arbejdskraft inkl. kapacitetsudnyttelse og kapital inkl. kapacitetsudnyttelse
    E_uY[t]$(tx0[t]).. qBVT[sTot,t] =E= (uY[t] + juY[t]) * qLspBy[t]**0.65 * (rKUdnSpBy[t] * qKspBy[t])**0.35 + sum(s$(not spBy[s]), qBVT[s,t]);
    E_qKspBy[t]$(tx0[t]).. pKspBy[t-1] * qKspBy[t] =E= sum([k,spBy], pI_s[k,spBy,t-1] * qK[k,spBy,t-1]);
    E_pKspBy[t]$(tx0[t]).. pKspBy[t] * qKspBy[t] =E= sum([k,spBy], pI_s[k,spBy,t] * qK[k,spBy,t-1]);

    E_qLspBy[t]$(tx0[t]).. qLspBy[t] =E= sum(spBy, qL[spBy,t]);
    E_sqLspBy[t]$(tx0[t]).. sqLspBy[t] =E= sum(spBy, sqL[spBy,t]);

    # Beskæftigelsesgab fordeles proportionalt på udvalgte brancher
    E_snL[sp,t]$(tx0[t] and spBy[sp] and not sameas[sp,'tje'])..
      snL[sp,t] =E= nL[sp,t] / sum(spBy, nL[spBy,t]) * sum(spBy, snL[spBy,t]);
    E_snL_tje[t]$(tx0[t]).. snL[sTot,t] =E= sum(s, snL[s,t]);
    E_snL_xspBy[s,t]$(tx0[t] and not spBy[s]).. snL[s,t] =E= nL[s,t];

    E_snL_spTot[t]$(tx0[t]).. snL[spTot,t] =E= sum(sp, snL[sp,t]);

    E_sqL[s,t]$(tx0[t] and spBy[s])..
      sqL[s,t] =E= fProd[s,t] * qProd[t] * sfW[s,t] * srL2nL[t] * (1-srOpslagOmk[t]) * snL[s,t] * srLUdn[s,t];
    E_sqL_spTot[t]$(tx0[t]).. sqL[spTot,t] =E= sum(sp, sqL[sp,t]);

    E_sfW[s,t]$(tx0[t])..
      sfW[s,t] =E= fW0[s,t] * sum(ss, snL[ss,t]) / sum(ss, fW0[ss,t] * snL[ss,t]);

    # ======================================================================================================================
    # Strukturelt arbejdsmarked
    # ======================================================================================================================
    E_snOpslag[t]$(tx0E[t] and t.val > 2000)..
      sdOpslagOmk2dnL[t] =E= 1
        - sum(sp, fDiskpL[sp,t+1] * srLUdn[sp,t] * snL[sp,t] * fProd[sp,t+1] * qProd[t+1]*fq * sfW[sp,t+1])
        / sum(sp, srLUdn[sp,t+1] * snL[sp,t] * fProd[sp,t] * qProd[t] * sfW[sp,t])
        * srL2nL[t+1] / srL2nL[t]
        * sdOpslagOmk2dnLLag[t+1]
        - (1 - rLoenNash[t]) / (1-srOpslagOmk[t]) / (1 - rLoenNash[t] * rFFLoenAlternativ * srJobFinding[t]);

    E_snOpslag_tEnd[t]$(tEnd[t])..
      sdOpslagOmk2dnL[t] =E= 1 - sum(sp, fDiskpL[sp,t] * srLUdn[sp,t] * snL[sp,t] * fProd[sp,t] * qProd[t]*fq * sfW[sp,t])
                               / sum(sp, srLUdn[sp,t] * snL[sp,t] * fProd[sp,t] * qProd[t] * sfW[sp,t]) * fv * sdOpslagOmk2dnLLag[t]
                           - (1-rLoenNash[t]) / (1-srOpslagOmk[t]) / (1 - rLoenNash[t] * rFFLoenAlternativ * srJobFinding[t]);

    E_srOpslagOmk[t]$(tx0[t])..
      srOpslagOmk[t] * snL[sTot,t] =E= uOpslagOmk * snOpslag[t]
                                     + uMatchOmk * srMatch[t] * snOpslag[t];                                  

    E_sdOpslagOmk2dnL[t]$(tx0[t])..
      sdOpslagOmk2dnL[t] =E= uOpslagOmk / srMatch[t]
                           + uMatchOmk;

    E_sdOpslagOmk2dnLLag[t]$(tx0E[t] and t.val > 2000)..
      sdOpslagOmk2dnLLag[t+1] =E= - (1-srSeparation[t+1]) * (uOpslagOmk / srMatch[t] + uMatchOmk);

    # Job-opslag og matching
    E_srJobFinding[t]$(tx0[t]).. srJobFinding[t] =E= 1 - 1 / (1 + srOpslag2soeg[t]**eMatching);

    E_srMatch[t]$(tx0[t]).. srMatch[t] * snOpslag[t] =E= srJobFinding[t] * (snSoegHh[aTot,t] + snSoegUdl[t]);
    E_srOpslag2soeg[t]$(tx0[t]).. srOpslag2soeg[t] =E= snOpslag[t] / (snSoegHh[aTot,t] + snSoegUdl[t]);

    # ----------------------------------------------------------------------------------------------------------------------
    # Samlet arbejdsudbud fra danske husholdninger og grænsearbejdere
    # ----------------------------------------------------------------------------------------------------------------------
    E_shL[t]$(tx0[t]).. shL[t] =E= shLHh[atot,t] + shLUdl[t];
    E_snL_tot[t]$(tx0[t])..
      snL[sTot,t] =E= (1-srSeparation[t]) * (snLHh[aTot,t] + snLUdl[t]) + srJobFinding[t] * (snSoegHh[aTot,t] + snSoegUdl[t]);
    E_srL2nL[t]$(tx0[t] and t.val > 2015)..
      srL2nL[t] * snL[sTot,t] =E= sfProdHh[t] * shLHh[aTot,t] + fProdUdl[t] * shLUdl[t];

    # ----------------------------------------------------------------------------------------------------------------------
    # Arbejdsudbud for grænsearbejdere
    # ----------------------------------------------------------------------------------------------------------------------
    E_shLUdl[t]$(tx0[t]).. shLUdl[t] =E= snLUdl[t] * fhLUdl[t] * shLHh[atot,t] / snLHh[aTot,t];
    E_snLUdl[t]$(tx0[t]).. snLUdl[t] =E= (1-srSeparation[t]) * snLUdl[t] + srJobFinding[t] * snSoegUdl[t];
    E_snSoegUdl[t]$(tx0[t]).. snSoegUdl[t] =E= nSoegBaseUdl[t] - (1-srSeparation[t]) * snLUdl[t];

    # ----------------------------------------------------------------------------------------------------------------------
    # Husholdningernes samlede arbejdsudbud
    # ----------------------------------------------------------------------------------------------------------------------
    E_shLHh_aTot[t]$(tx0[t] and t.val > 2015)..
      shLHh[atot,t] =E= sum(a, shLHh[a,t] * snLHh[a,t]);

    E_snLHh_tot[t]$(tx0[t])..
      snLHh[aTot,t] =E= (1-srSeparation[t]) * snLHh[aTot,t] + srJobFinding[t] * snSoegHh[aTot,t];

    E_srSeparation[t]$(tx0[t] and t.val > 2015).. snLHh[aTot,t] =E= sum(a, snLHh[a,t]);

    E_snSoegHh_aTot[t]$(tx0[t])..
      snSoegHh[aTot,t] =E= snSoegBaseHh[aTot,t] - (1-srSeparation[t]) * snLHh[aTot,t]; 

    E_snSoegBaseHh_tot[t]$(tx0[t] and t.val > 2015)..
      snSoegBaseHh[aTot,t] =E= sum(a, snSoegBaseHh[a,t]);

    E_sfProdHh[t]$(tx0[t] and t.val > 2015)..
      sfProdHh[t] =E= sum(a, fProdHh[a,t] * shLHh[a,t] * snLHh[a,t]) / shLHh[aTot,t];

    # ----------------------------------------------------------------------------------------------------------------------
    # Husholdningernes arbejdsudbud fordelt på alder
    # ----------------------------------------------------------------------------------------------------------------------
    E_shLHh[a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
      1 =E= uh[a,t]**eh * (shLHh[a,t]/hLHh[a,tDataEnd])**eh / hLHh[a,tDataEnd] + jshLHh[a,t];

    E_snLHh[a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
      snLHh[a,t] =E= (1-rSeparation[a,t]) * snLHh[a-1,t] / nPop[a-1,t] * nPop[a,t] + srJobFinding[t] * snSoegHh[a,t];
    E_snSoegHh[a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
      snSoegHh[a,t] =E= snSoegBaseHh[a,t] - (1-rSeparation[a,t]) * snLHh[a-1,t] / nPop[a-1,t] * nPop[a,t] ;

    E_snSoegBaseHh[a,t]$(tx0E[t] and a15t100[a] and a.val < 100 and t.val > 2015)..
      (1 - mrKomp[a,t] - 1/(1+eh))**(eDeltag/emrKomp)
      =E= sfDeltag[a,t]**eDeltag / srJobFinding[t]
        - (1-rSeparation[a+1,t+1]) * (1 / srJobFinding[t+1]) * fDiskDeltag[a+1,t+1] * sfDeltag[a+1,t+1]**eDeltag;
    E_snSoegBaseHh_tEnd[a,t]$(tEnd[t] and a15t100[a] and a.val < 100)..
      (1 - mrKomp[a,t] - 1/(1+eh))**(eDeltag/emrKomp)
      =E= sfDeltag[a,t]**eDeltag / srJobFinding[t]
        - (1-rSeparation[a+1,t]) * (1 / srJobFinding[t]) * fDiskDeltag[a+1,t] * sfDeltag[a+1,t]**eDeltag;
    E_snSoegBaseHh_aEnd[a,t]$(tx0[t] and a.val = 100 and t.val > 2015)..
      (1 - mrKomp[a,t] - 1/(1+eh))**(eDeltag/emrKomp)
      =E= sfDeltag[a,t]**eDeltag / srJobFinding[t];

    E_sfDeltag[a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
      sfDeltag[a,t] =E= uDeltag[a,t] * (snSoegBaseHh[a,t] / nPop[a,t]) / (nSoegBaseHh[a,tDataEnd] / nPop[a,tDataEnd]) * (1+jsfDeltag[a,t]);

    # ----------------------------------------------------------------------------------------------------------------------
    # Strukturelle socio-grupper og aggregater herfra
    # ----------------------------------------------------------------------------------------------------------------------
    E_snSoc[soc,t]$(tx0[t] and t.val > 2015)..
      snSoc[soc,t] =E= dSoc2dBesk[soc,t] * snLHh['tot',t] + dSoc2dPop[soc,t] * nPop['a15t100',t];

    E_dSoc2dPop_boern[t]$(tx0[t] and t.val > 2015)..
      snSoc['boern',t] =E= nPop['tot',t] - nPop['a15t100',t];

    # Aggregater fra socio-grupper
    E_snSoc_bruttoled[t]$(tx0[t] and t.val > 2015).. snSoc['bruttoled',t] =E= sum(bruttoled, snSoc[bruttoled,t]);
    E_snSoc_arbsty[t]$(tx0[t] and t.val > 2015).. snSoc['arbsty',t]    =E= sum(arbsty, snSoc[arbsty,t]);

    E_snSoc_nettoled[t]$(tx0[t] and t.val > 2015).. snSoc['nettoled',t]    =E= sum(nettoled, snSoc[nettoled,t]);
    E_snSoc_nettoarbsty[t]$(tx0[t] and t.val > 2015).. snSoc['nettoarbsty',t] =E= sum(nettoarbsty, snSoc[nettoarbsty,t]);

    E_srLedig[t]$(tx0[t] and t.val > 2015).. srLedig[t] =E= snSoc['bruttoled',t] / snSoc['arbsty',t];
  $ENDBLOCK
$ENDIF