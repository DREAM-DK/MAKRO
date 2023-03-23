# ======================================================================================================================
# Structural levels
# - Potential output (Gross Value Added) and employment
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_struk_prices_endo
    spBVT[s_,t] "Deflator for strukturel BVT."
  ;
  $GROUP G_struk_quantities_endo
    sqBVT[s_,t] "Strukturel BVT."
    sdqL2dnL[s_,t] "sqL differentieret ift. snL."
    sdOpslagOmk2dnLlag[t] "sqL[t+1] differentieret ift. snL[t]"
    sqL[s_,t] "Strukturel arbejdskraft i effektive enheder."

    sdqL2dnLlag[sp,t] "sqL[t] differentieret ift. snL[t-1]"
  ;
  
  $GROUp G_struk_values_endo_a
    svFFOutsideOption2w[t]$(t.val > 2015) "Fagforenings forhandlingsalterntiv i lønforhandling."
  ;
  $GROUP G_struk_values_endo
    G_struk_values_endo_a
  
    svVirkLoenPos2w[t]$(t.val > 2015) "Hjælpevariabel til lønforhandling. Vi."
    sdVirk2dLoen[t]$(t.val > 2015) "Hjælpevariabel til lønforhandling. Negativ del af virksomhedernes værdifunktion i lønforhandling."
  ;

  $GROUP G_struk_endo_a
    G_struk_values_endo_a

    shLHh[a_,t]$((aTot[a_] or a15t100[a_]) and t.val > 2015) "Strukturel aldersfordelt arbejdstid."
    srSeparation[a_,t]$(aTot[a_] and t.val > 2015) "Strukturel aggregeret separationsrate."
    snSoegBaseHh[a_,t]$((aTot[a_] or a15t100[a_]) and t.val > 2015) "Strukturel arbejdsstyrke."
    snLHh[a_,t]$((a15t100[a_] and t.val > 2015)) "Strukturel beskæftigelse."
    snSoegHh[a_,t]$(a15t100[a_] and t.val > 2015) "Strukturel jobsøgende."
    fhLHh[a,t]$(a15t100[a] and t.val > 2015) "Korrektionsfaktor til at slå effekter af marginal skat på arbejdsudbud til og fra på intensiv margin."
    sdFF2dLoen[t]$(t.val > 2015) "Fagforeningens værdifunktion differentieret ift. løn, strukturelt."
  ;
  $GROUP G_struk_endo
    G_struk_endo_a
    G_struk_prices_endo
    G_struk_quantities_endo
    G_struk_values_endo

    spL2w[s_,t] "Strukturelt forhold mellem user cost på arbejdskraft og lønnen."

    uY[t] "Produktivitetsparameter i én-sektor Cobb-Douglas produktionsfunktion (ikke TFP pga. kapacitetsudnyttelse mv.)."

    shL[s_,t] "Strukturel arbejdstid fordelt på brancher."
    sqProd[s_,t]$(s[s_] or spTot[s_] or (sTot[s_] and t.val > 2015)) "Strukturelt branchespecifikt produktivitetsindeks for arbejdskraft."
    sdOpslagOmk2dnL[t] "srOpslagOmk * snL differentieret ift. snL."

    snLHh[a_,t]$(aTot[a_] and t.val > 2015) "Strukturel beskæftigelse."
    snSoegHh[a_,t]$(aTot[a_]) "Strukturel jobsøgende."
    srJobFinding[t] "Strukturel andel af jobsøgende som får et job."
    srMatch[t] "Strukturel andel af jobopslag, som resulterer i et match."
    srOpslagOmk[t] "Andel af arbejdskraft som går til hyrings-omkostninger strukturelt."
    snOpslag[t] "Strukturelt antal jobopslag."

    snLxDK[t] "Strukturelle grænsearbejdere i antal hoveder - inkluderer pt. sort arbejde."
    shLxDK[t] "Strukturel arbejdstid for grænsearbejdere."
    snL[s_,t] "Strukturel beskæftigede inklusiv grænsearbejdere."
    snSoegxDK[t] "Strukturel jobsøgende potentielle grænsearbejdere."

    snSoc[soc,t]$(tBFR[t]) "Strukturelle værdier for socio-grupper og aggregater, antal 1.000 personer, Kilde: BFR."
    snBruttoLedig[t]$(tBFR[t]) "Strukturelt bruttoledige. Antal 1.000 personer. Kilede: BFR"
    snBruttoArbsty[t]$(tBFR[t]) "Strukturel brutto-arbejdsstyrke. Antal 1.000 personer. Kilede: BFR"
    snNettoLedig[t]$(tBFR[t]) "Strukturelt nettoledige. Antal 1.000 personer. Kilede: BFR"
    snNettoArbsty[t]$(tBFR[t]) "Strukturel netto-arbejdsstyrke. Antal 1.000 personer. Kilede: BFR"
    dSoc2dPop[soc,t]$(boern[soc] and tBFR[t]) "Befolkningssnøgle fordelt på socio-grupper" 
    srBruttoLedig[t]$(tBFR[t]) "Strukturel bruttoledighedsrate."
    srNettoLedig[t]$(tBFR[t]) "Strukturel nettoledighedsrate."
    srhL2nLxDK[t] "Strukturel arbejdstid pr. grænsearbejder"
  ; 
  $GROUP G_struk_endo G_struk_endo$(tx0[t]);

  $GROUP G_struk_prices
    G_struk_prices_endo
  ;
  $GROUP G_struk_quantities
    G_struk_quantities_endo
  ;
  $GROUP G_struk_values
    G_struk_values_endo
  ;

  $GROUP G_struk_exogenous_forecast
    snLHh[a_,t]
    shLHh[a,t]

    # Fordeling af socio-grupper  
    dSoc2dBesk[soc,t] "Marginal ændring i antallet i sociogruppe soc ved ændring i den samlede beskæftigelse."
    dSoc2dPop[soc,t] "Marginal ændring i antallet i sociogruppe soc ved ændring i den samlede befolkningsstørrelse."
  ;
  $GROUP G_struk_other
    juY[t] "J-led til residual i BVT-gab."
    jsnLxDK[t] "J-led."
    jsrhL2nLxDK[t] "J-led."
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_struk_aTot
    # ------------------------------------------------------------------------------------------------------------------
    # Strukturel BVT
    # ------------------------------------------------------------------------------------------------------------------
    # Vi beregner strukturel BVT i private by-erhverv ud fra en Cobb-Douglas produktionsfunktion, i overensstemmelse
    # med FMs estimering af konjunkturgab.
    E_sqBVT_sByTot[t]$(tx0[t]).. sqBVT[sByTot,t] =E= uY[t] * sqL[sByTot,t]**0.65 * (qK[kTot,sByTot,t-1]/fq)**0.35;

    # Faktisk kapital indgår med strukturel kapacitetsudnyttelse (=1)
    # Strukturel arbejdskraft indgår med strukturel kapacitetsudnyttelse på arbejdskraft
    # Strukturel arbejdskraft beregnes ud fra strukturelt arbejdsmarked nedenfor
    E_sqL_sByTot[t]$(tx0[t]).. sqL[sByTot,t] =E= sum(sBy, sqL[sBy,t]);

    # Strukturel BVT i private by-erhverv og øvrige brancher aggregeres med kædeindeks ud fra faktiske BVT-deflatorer.
    # Vi antager at der ikke er konjunkturgab i øvrige brancher.
    E_spBVT_sTot[t]$(tx0[t])..
      spBVT[sTot,t] * sqBVT[sTot,t] =E= pBVT[sByTot,t] * sqBVT[sByTot,t] + sum(s$(not sBy[s]), vBVT[s,t]);
    E_sqBVT_sTot[t]$(tx0[t])..
      spBVT[sTot,t-1]/fp * sqBVT[sTot,t] =E= pBVT[sByTot,t-1]/fp * sqBVT[sByTot,t] + sum(s$(not sBy[s]), pBVT[s,t-1]/fp * qBVT[s,t]);

    # Vi finder strukturelt TFP i private by-erhverv ud fra Cobb-Douglas for faktisk BVT
    # med arbejdskraft inklusiv kapacitetsudnyttelse og kapital inklusiv kapacitetsudnyttelse
    E_uY[t]$(tx0[t]).. qBVT[sByTot,t] =E= (uY[t] + juY[t]) * qL[sByTot,t]**0.65 * qKUdn[kTot,sByTot,t]**0.35;
 
    # Beskæftigelsesgab fordeles proportionalt på udvalgte brancher
    E_snL[sp,t]$(tx0[t] and sBy[sp] and not tje[sp]).. snL[sp,t] =E= nL[sp,t] / nL[sByTot,t] * snL[sByTot,t];
    E_snL_tje[t]$(tx0[t]).. snL[sTot,t] =E= sum(s, snL[s,t]);
    E_snL_xsBy[s,t]$(tx0[t] and not sBy[s]).. snL[s,t] =E= nL[s,t];

    E_snL_spTot[t]$(tx0[t]).. snL[spTot,t] =E= sum(sp, snL[sp,t]);
    E_snL_sByTot[t]$(tx0[t]).. snL[sByTot,t] =E= sum(sBy, snL[sBy,t]);

    E_shL_spTot[t]$(tx0[t]).. shL[spTot,t] =E= sum(sp, shL[sp,t]);
    E_shL_sByTot[t]$(tx0[t]).. shL[sByTot,t] =E= sum(sBy, shL[sBy,t]);

    E_shL[sp,t]$(tx0[t] and sBy[sp] and not tje[sp])..
      shL[sp,t] =E= hL[sp,t] / hL[sByTot,t] * shL[sByTot,t];
    E_shL_tje[t]$(tx0[t]).. shL[sTot,t] =E= sum(s, shL[s,t]);
    E_shL_xsBy[s,t]$(tx0[t] and not sBy[s]).. shL[s,t] =E= hL[s,t];

    E_sqL_sBy[s,t]$(tx0[t] and sBy[s]).. sqL[s,t] =E= sqProd[s,t] * (1-srOpslagOmk[t]) * shL[s,t];
    E_sqL_sxBy[s,t]$(tx0[t] and not sBy[s]).. sqL[s,t] =E= qL[s,t];
    E_sqL_spTot[t]$(tx0[t]).. sqL[spTot,t] =E= sum(sp, sqL[sp,t]);
    E_sqL_sTot[t]$(tx0[t]).. sqL[sTot,t] =E= sum(s, sqL[s,t]);

    E_spBVT_spTot[t]$(tx0[t])..
      spBVT[spTot,t] * sqBVT[spTot,t] =E= pBVT[sByTot,t] * sqBVT[sByTot,t] + sum(sp$(not sBy[sp]), vBVT[sp,t]);
    E_sqBVT_spTot[t]$(tx0[t])..
      spBVT[spTot,t-1]/fp * sqBVT[spTot,t] =E= pBVT[sByTot,t-1]/fp * sqBVT[sByTot,t] + sum(sp$(not sBy[sp]), pBVT[sp,t-1]/fp * qBVT[sp,t]);

    E_sqProd_off[t]$(tx0[t]).. sqProd['off',t] =E= uProd['off',t] * sqProd[sTot,t];
    E_sqProd_spTot[t]$(tx0[t]).. sqProd[sTot,t] * shL[sTot,t] =E= sqProd[spTot,t] * shL[spTot,t] + sqProd["off",t] * shL["off",t];
    E_sqProd_sp[sp,t]$(tx0[t]).. sqProd[sp,t] =E= uProd[sp,t] * sqProd[spTot,t] * shL[spTot,t] / sum(ssp, uProd[ssp,t] * shL[ssp,t]);

    # ======================================================================================================================
    # Strukturelt arbejdsmarked
    # ======================================================================================================================
    # Vi opskriver lønforhandling under antagelse af nul træghed
    # Løn-niveauet er ikke vel-bestemt uden efterspørgselssiden
    # Vi finder i stedet et strukturelt forhold mellem løn og usercost på arbejdskraft
    E_svVirkLoenPos2w[t]$(tx0[t] and t.val > 2015)..
      svVirkLoenPos2w[t] =E= sum(sp, (1-mtVirk[sp,t]) * spL2w[sp,t] * shL[sp,t] * sqProd[sp,t]);

    E_sdVirk2dLoen[t]$(tx0[t] and t.val > 2015)..
      sdVirk2dLoen[t] =E= - sum(sp, (1-mtVirk[sp,t]) * (1 + tL[sp,t]) * shL[sp,t] * sqProd[sp,t] * (1-srOpslagOmk[t]));

    E_snLHh_tot[t]$(tx0[t] and t.val > 2015)..
      1 =E= (1-rLoenNash[t]) * svVirkLoenPos2w[t] / (-sdVirk2dLoen[t]) + rLoenNash[t] * rFFLoenAlternativ * srJobFinding[t];
      #  1 =E= (1-rLoenNash[t]) * svVirkLoenPos2w[t] / (-sdVirk2dLoen[t]) + rLoenNash[t] * svFFOutsideOption2w[t] / sdFF2dLoen[t];

    # Strukturel FOC for stillingsopslag
    E_spL2w[sp,t]$(tx0E[t])..
      spL2w[sp,t] =E= (1 + tL[sp,t]) * sqProd[sp,t] * (shL[sp,t]/snL[sp,t]) / (sdqL2dnL[sp,t] + (1-mtVirk[sp,t])/(1-mtVirk[sp,t]) * fDiskpL[sp,t+1] * sdqL2dnLlag[sp,t+1]*fq);

    E_spL2w_tEnd[sp,t]$(tEnd[t])..
      spL2w[sp,t]/spL2w[sp,t-1] =E= spL2w[sp,t-1]/spL2w[sp,t-2];

    E_sdqL2dnL[sp,t]$(tx0[t])..
      sdqL2dnL[sp,t] =E= sqProd[sp,t] * shL[sp,t] / snL[sp,t] * (1 - sdOpslagOmk2dnL[t]);
    E_sdOpslagOmk2dnL[t]$(tx0[t])..
      sdOpslagOmk2dnL[t] =E= uOpslagOmk / srMatch[t] + uMatchOmk;

    E_sdqL2dnLlag[sp,t]$(tx1[t])..
      sdqL2dnLlag[sp,t] =E= - sqProd[sp,t] * shL[sp,t] / snL[sp,t-1] * sdOpslagOmk2dnLlag[t]; # snL lagget imodsætning til dOpslagOmk2dnLLag
    E_sdOpslagOmk2dnLlag[t]$(tx1[t])..
      sdOpslagOmk2dnLlag[t] =E= - (1-srSeparation[aTot,t]) * (uOpslagOmk / srMatch[t-1] + uMatchOmk); # srMatch lagget imodsætning til dOpslagOmk2dnLLag

    E_srOpslagOmk[t]$(tx0[t])..
      srOpslagOmk[t] * snL[sTot,t] =E= uOpslagOmk * snOpslag[t] + uMatchOmk * srMatch[t] * snOpslag[t];                                  

    # Job-opslag og matching
    E_snOpslag[t]$(tx0[t])..
      srJobFinding[t] * (snSoegHh[aTot,t] + snSoegxDK[t]) =E= srMatch[t] * snOpslag[t];

    E_srMatch[t]$(tx0[t])..
      srMatch[t] =E= (snSoegHh[aTot,t] + snSoegxDK[t])
                   / (snOpslag[t]**(1/eMatching) + (snSoegHh[aTot,t] + snSoegxDK[t])**(1/eMatching))**eMatching;

    # ------------------------------------------------------------------------------------------------------------------
    # Samlet arbejdsudbud fra danske husholdninger og grænsearbejdere
    # ------------------------------------------------------------------------------------------------------------------
    E_shL_sTot[t]$(tx0[t]).. shL[sTot,t] =E= shLHh[atot,t] + shLxDK[t];
    E_snL_sTot[t]$(tx0[t]).. snL[sTot,t] =E= snLHh[aTot,t] + snLxDK[t];

    E_sqProd_sTot[t]$(tx0[t] and t.val > 2015)..
      sqProd[sTot,t] * shL[sTot,t] =E= qProdHh[aTot,t] * shLHh[aTot,t] + qProdxDK[t] * shLxDK[t];

    # ------------------------------------------------------------------------------------------------------------------
    # Arbejdsudbud for grænsearbejdere
    # ------------------------------------------------------------------------------------------------------------------
    E_shLxDK[t]$(tx0[t]).. shLxDK[t] =E= srhL2nLxDK[t] * snLxDK[t];
    E_srhL2nLxDK[t]$(tx0[t]).. srhL2nLxDK[t] =E= uhLxDK[t] * shLHh[atot,t] / snLHh[aTot,t] + jsrhL2nLxDK[t];
    E_snLxDK[t]$(tx0[t]).. snLxDK[t] =E= (1-srSeparation[aTot,t]) * snLxDK[t] + srJobFinding[t] * snSoegxDK[t] + jsnLxDK[t];
    E_snSoegxDK[t]$(tx0[t]).. snSoegxDK[t] =E= nSoegBasexDK[t] - (1-srSeparation[aTot,t]) * snLxDK[t];

    # ------------------------------------------------------------------------------------------------------------------
    # Husholdningernes samlede arbejdsudbud
    # ------------------------------------------------------------------------------------------------------------------
    E_srJobFinding[t]$(tx0[t])..
      snLHh[aTot,t] =E= (1-srSeparation[aTot,t]) * snLHh[aTot,t] + srJobFinding[t] * snSoegHh[aTot,t];

    E_snSoegHh_tot[t]$(tx0[t])..
      snSoegBaseHh[aTot,t] =E= snLHh[aTot,t] + (1-srJobFinding[t]) * snSoegHh[aTot,t]; 

    # ------------------------------------------------------------------------------------------------------------------
    # Strukturelle socio-grupper og aggregater herfra
    # ------------------------------------------------------------------------------------------------------------------
    E_snSoc[soc,t]$(tx0[t] and tBFR[t])..
      snSoc[soc,t] =E= dSoc2dBesk[soc,t] * snLHh[aTot,t] + dSoc2dPop[soc,t] * nPop['a15t100',t];

    E_dSoc2dPop_boern[t]$(tx0[t] and tBFR[t])..
      snSoc['boern',t] =E= nPop[aTot,t] - nPop['a15t100',t];

    # Aggregater fra socio-grupper
    E_snBruttoLedig[t]$(tx0[t] and tBFR[t]).. snBruttoLedig[t] =E= sum(BruttoLedig, snSoc[BruttoLedig,t]);
    E_snNettoLedig[t]$(tx0[t] and tBFR[t]).. snNettoLedig[t] =E= sum(NettoLedig, snSoc[NettoLedig,t]);
    E_snBruttoArbsty[t]$(tx0[t] and tBFR[t]).. snBruttoArbsty[t] =E= sum(BruttoArbsty, snSoc[BruttoArbsty,t]) + snLxDK[t];
    E_snNettoArbsty[t]$(tx0[t] and tBFR[t]).. snNettoArbsty[t] =E= sum(NettoArbsty, snSoc[NettoArbsty,t]) + snLxDK[t];

    E_srBruttoLedig[t]$(tx0[t] and tBFR[t]).. srBruttoLedig[t] =E= snBruttoLedig[t] / snBruttoArbsty[t];
    E_srNettoLedig[t]$(tx0[t] and tBFR[t]).. srNettoLedig[t] =E= snNettoLedig[t] / snNettoArbsty[t];
  $ENDBLOCK


  $BLOCK B_struk_a
    # ======================================================================================================================
    # Strukturelt arbejdsmarked
    # ======================================================================================================================
    # Vi opskriver lønforhandling under antagelse a nul træghed
    # Løn-niveauet er ikke vel-bestemt uden efterspørgselssiden
    # Vi finder i stedet et strukturelt forhold mellem løn og usercost på arbejdskraft

    E_sdFF2dLoen[t]$(tx0[t] and t.val > 2015)..
      sdFF2dLoen[t] =E= sum(a, (1-mtInd[a,t]) * snLHh[a,t] * qProdHh[a,t] * shLHh[a,t]);

    E_svFFOutsideOption2w[t]$(tx0[t] and t.val > 2015)..
      svFFOutsideOption2w[t] =E= rFFLoenAlternativ * sdFF2dLoen[t] * srJobFinding[t];

    # ------------------------------------------------------------------------------------------------------------------
    # Husholdningernes samlede arbejdsudbud
    # ------------------------------------------------------------------------------------------------------------------
    E_shLHh_tot[t]$(tx0[t] and t.val > 2015)..
      shLHh[atot,t] =E= sum(a, shLHh[a,t] * snLHh[a,t]);

    E_srSeparation_aTot[t]$(tx0[t] and t.val > 2015).. snLHh[aTot,t] =E= sum(a, snLHh[a,t]);

    E_snSoegBaseHh_aTot[t]$(tx0[t] and t.val > 2015).. snSoegBaseHh[aTot,t] =E= sum(a, snSoegBaseHh[a,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Husholdningernes arbejdsudbud fordelt på alder
    # ------------------------------------------------------------------------------------------------------------------
    # FOC for shLHh
    E_shLHh[a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
      shLHh[a,t] =E= 1/uh[a,t] * ((1-mtInd[a,t]) / fhLHh[a,t])**(1/eh);

    # Adjustment term to turn off marginal tax effects on labor supply intensive margin
    E_fhLHh[a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
      fhLHh[a,t] =E= (1-mtInd[a,t]); 

    E_snLHh[a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
      snLHh[a,t] =E= (1-srSeparation[a,t]) * snLHh[a-1,t] / nPop[a-1,t] * nPop[a,t] + srJobFinding[t] * snSoegHh[a,t];
    E_snSoegHh[a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
      snSoegBaseHh[a,t] =E= snLHh[a,t] + (1-srJobFinding[t]) * snSoegHh[a,t];

    # For computational reasons, we write the parameter as uDeltag[a,t]**eDeltag, such that uDeltag is well-behaved even for large values of eDeltag, e.g. 10
    E_snSoegBaseHh[a,t]$(tx0E[t] and a15t100[a] and a.val < 100 and t.val > 2015)..
      (uDeltag[a,t] / (1 - snSoegBaseHh[a,t]/nPop[a,t]))**eDeltag =E= srJobFinding[t] * (
          (1 - mrKomp[a,t] - (uh[a,t] * shLHh[a,t])**eh / (1+eh))**(eDeltag/emrKomp)
        + rOverlev[a,t] * (1-srSeparation[a+1,t+1]) * fDiskDeltag[a+1,t+1]
        * (1-srJobFinding[t+1]) / srJobFinding[t+1] * (uDeltag[a+1,t+1] / (1 - nSoegBaseHh[a+1,t+1]/nPop[a+1,t+1]))**eDeltag
      );
    
    # Terminal condition for last period 
    E_snSoegBaseHh_tEnd[a,t]$(tEnd[t] and a15t100[a] and a.val < 100 and t.val > 2015)..
      (uDeltag[a,t] / (1 - snSoegBaseHh[a,t]/nPop[a,t]))**eDeltag =E= srJobFinding[t] * (
          (1 - mrKomp[a,t] - (uh[a,t] * shLHh[a,t])**eh / (1+eh))**(eDeltag/emrKomp)
        + rOverlev[a,t] * (1-srSeparation[a+1,t]) * fDiskDeltag[a+1,t]
        * (1-srJobFinding[t]) / srJobFinding[t] * (uDeltag[a+1,t] / (1 - nSoegBaseHh[a+1,t]/nPop[a+1,t]))**eDeltag
      );

    # Terminal condition for last age group
    E_snSoegBaseHh_aEnd[a,t]$(tx0[t] and a.val = 100 and t.val > 2015)..
      (uDeltag[a,t] / (1 - snSoegBaseHh[a,t]/nPop[a,t]))**eDeltag =E= srJobFinding[t] * (
          (1 - mrKomp[a,t] - (uh[a,t] * shLHh[a,t])**eh / (1+eh))**(eDeltag/emrKomp)
          # Ingen sandsynlighed for at beholde job til næste periode
      );
  $ENDBLOCK 

  MODEL M_struk /
    B_struk_a
    B_struk_aTot
  /;

$ENDIF


$IF %stage% == "exogenous_values":
# ======================================================================================================================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_struk_makrobk
    sqBVT[s_,t]$(sTot[s_])
    snSoegBaseHh$(aTot[a_])
    sqProd$(sTot[s_])
    snL$(sTot[s_]), shL$(sTot[s_])
  ;
  @load(G_struk_makrobk, "..\Data\makrobk\makrobk.gdx" )

  # Aldersfordelt data fra BFR indlæses
  $GROUP G_struk_BFR
    snSoc, snLHh, shLHh, srSeparation, dSoc2dBesk, dSoc2dPop
  ;
  @load(G_struk_BFR, "..\Data\Befolkningsregnskab\BFR.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_struk_data
    G_struk_makrobk
    G_struk_BFR
    -snSoegBaseHh$(aTot[a_] and t.val >= %cal_deep%)
    -srSeparation$(aTot[a_] and t.val >= %cal_deep%)
    snLxDK, shLxDK
  ;

  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_struk_data_imprecise      
    sqProd$(sTot[s_] and t.val > 2015)
    srSeparation$(aTot[a_] and t.val < %cal_deep%)
  ; 

# ======================================================================================================================
# Data assignment
# ======================================================================================================================
  set_data_periods_from_subset(tBFR)
  snLHh.l[aTot,t]$(t.val < tData1.val) = snL.l[sTot,t] / snL.l[sTot,tData1] * snLHh.l[aTot,tData1];  # Outside BFR years, we set use ADAM data for the number of employed persons, but level shifted to match BFR in year 2001.
  shLHh.l[aTot,t]$(t.val < tData1.val) = shL.l[sTot,t] / shL.l[sTot,tData1] * shLHh.l[aTot,tData1];  # Outside BFR years, we set use ADAM data for the number hours worked, but level shifted to match BFR in year 2001.
  set_data_periods_from_subset(tADAMdata)

  snLxDK.l[t] = snL.l[sTot,t] - snLHh.l[aTot,t];
  shLxDK.l[t] = shL.l[sTot,t] - shLHh.l[aTot,t];

  spBVT.l[s_,t]$(tBase[t]) = 1;
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_struk_static_calibration_base
    G_struk_endo
    -sqBVT[s_,t]$(sTot[s_]), juY[t]
    -snLxDK, jsnLxDK
    -shLxDK, jsrhL2nLxDK
    -snLHh$(aTot[a_] and t.val > 2015) # -E_snLHh_tot
  ;

  MODEL M_struk_static_calibration_base /
    M_struk
    - E_snLHh_tot
  /;

  $GROUP G_struk_simple_static_calibration
    G_struk_static_calibration_base
    -G_struk_endo_a
  ;
  $GROUP G_struk_simple_static_calibration
    G_struk_simple_static_calibration$(tx0[t])
  ;

  MODEL M_struk_simple_static_calibration /
    M_struk_static_calibration_base
    -B_struk_a
  /;

  $GROUP G_struk_static_calibration
    G_struk_static_calibration_base
    -shLHh[a_,t]$(a15t100[a_]), uh[a,t]$(a15t100[a])
    -snLHh[a_,t]$(a[a_] and t.val > 2015) # -E_snSoegBaseHh, E_snSoegBaseHh_tEnd, E_snSoegBaseHh_aEnd
    -snSoegBaseHh$(aTot[a_] and t.val > 2015) # -E_snLHh_tot
  ;
  $GROUP G_struk_static_calibration
    G_struk_static_calibration$(tx0[t])
    spBVT$(t0[t]), -spBVT$(tBase[t])
  ;

  MODEL M_struk_static_calibration /
    M_struk_static_calibration_base
    - E_snSoegBaseHh - E_snSoegBaseHh_tEnd - E_snSoegBaseHh_aEnd
  /;
$ENDIF


# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_struk_deep
    G_struk_endo

    -shLHh[a,t]$(a15t100[a_]), uH[a,t]$(15 <= a.val and a.val <= 100)
    -snLHh[a_,t]$(a15t100[a_] and tx1[t]), uDeltag[a,t]$(tx1[t])
    -snLHh[a_,t]$(a15t100[a_] and t1[t]), jrJobFinding[a_,t]$(a15t100[a_] and t1[t])
    -sqBVT[s_,t]$(sTot[s_] and t1[t]), juY[t]
    -snLxDK$(t1[t]), jsnLxDK # E_jsnLxDK_forecast
    -shLxDK$(t1[t]), jsrhL2nLxDK # E_jsrhL2nLxDK_forecast
  ;
  $GROUP G_struk_deep G_struk_deep$(tx0[t]);

  $BLOCK B_struk_deep
    E_juY_deep[t]$(tx1[t]).. juY[t] =E= 0.7 * juY[t-1];

    E_jsnLxDK_forecast[t]$(tx1[t]).. jsnLxDK[t] =E= 0;
    E_jsrhL2nLxDK_forecast[t]$(tx1[t]).. jsrhL2nLxDK[t] =E= 0;
  $ENDBLOCK
  MODEL M_struk_deep /
    M_struk    
    B_struk_deep
  /;
$ENDIF
 
# ======================================================================================================================
# Simple dynamic calibration
# ======================================================================================================================
$IF %stage% == "simple_dynamic_calibration":
  $GROUP G_struk_dynamic_calibration
    G_struk_endo
    -shLHh[a_,t]$(a15t100[a_] and t1[t]), uH[a,t]$((15 <= a.val and a.val <= 100) and t1[t])
    -snLHh[a_,t]$(a15t100[a_] and t1[t]), jrJobFinding[a_,t]$(a15t100[a_] and t1[t])
    -sqBVT[s_,t]$(sTot[s_] and t1[t]), juY[t]$(t1[t])
    -snLxDK$(t1[t]), jsnLxDK$(t1[t])
    -shLxDK$(t1[t]), jsrhL2nLxDK$(t1[t])

    juY[t]$(tx1[t]) # E_juY
  ;

  $BLOCK B_struk_dynamic_calibration
    # Gradvis aftrapning af j-led
    E_juY[t]$(tx1[t]).. juY[t] =E= aftrapprofil[t] * juY[t1];
  $ENDBLOCK

  MODEL M_struk_dynamic_calibration /
    M_struk    
    B_struk_dynamic_calibration
  /;
$ENDIF