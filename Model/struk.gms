# ======================================================================================================================
# Structural levels
# - Potential output (Gross Value Added) and employment
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_struk_endo_a
    svFFOutsideOption2w[t] "Fagforenings forhandlingsalterntiv i lønforhandling."
    svVirkLoenPos2w[t] "Hjælpevariabel til lønforhandling. Vi."
    shLHh[a_,t]$((aTot[a_] or a15t100[a_]) and t.val > %AgeData_t1%) "Strukturel aldersfordelt arbejdstid."
    srJobFinding[a_,t]$(a15t100[a_]) "Strukturel andel af jobsøgende som får et job."
    jsrJobFinding[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "J-led"
    jsnSoegHh[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "J-led"
    srSeparation[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "Strukturel aggregeret separationsrate."
    snSoegBaseHh[a_,t]$((aTot[a_] or a15t100[a_]) and t.val > %AgeData_t1%) "Strukturel arbejdsstyrke."
    srSoegBaseHh[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Strukturel arbejdsstyrke som andel af befolkning."
    snLHh[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Strukturel beskæftigelse."
    snSoegHh[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Strukturel jobsøgende."
    fhLHh[a,t] "Korrektionsfaktor til at slå effekter af marginal skat på arbejdsudbud til og fra på intensiv margin."
    sdFF2dLoen[t] "Fagforeningens værdifunktion differentieret ift. løn, strukturelt."
  ;

  $GROUP G_struk_variables
    spBVT[s_,t] "Deflator for strukturel BVT."
    sqBVT[s_,t] "Strukturel BVT."
    sdqL2dnL[s_,t] "sqL differentieret ift. snL."
    sdqL2dnLlag[sp,t] "sqL[t] differentieret ift. snL[t-1]"
    sqL[s_,t] "Strukturel arbejdskraft i effektive enheder."
    sqProd[s_,t] "Strukturelt branchespecifikt produktivitetsindeks for arbejdskraft."
    sdvVirk2dpW[t] "Hjælpevariabel til lønforhandling. Negativ del af virksomhedernes værdifunktion i lønforhandling."
    spL2pW[sp,t] "Strukturelt forhold mellem user cost på arbejdskraft og lønnen."
    uBVT[s_,t] "Totalfaktor-produktivitet på BVT udover Harrod-neutral vækst, kapacitetsudnyttelse, og omstillingsomkostninger."
    shL[s_,t] "Strukturel arbejdstid fordelt på brancher."
    sdOpslagOmk2dnL[t] "srOpslagOmk * snL differentieret ift. snL."
    sdOpslagOmk2dnLlag[t] "sqL[t+1] differentieret ift. snL[t]"
    snLHh[a_,t] "Strukturel beskæftigelse."
    snSoegHh[a_,t] "Strukturel jobsøgende."
    srJobFinding[a_,t] "J-led"
    srMatch[t] "Strukturel andel af jobopslag, som resulterer i et match."
    srOpslagOmk[t] "Andel af arbejdskraft som går til hyrings-omkostninger strukturelt."
    snOpslag[t] "Strukturelt antal jobopslag."
    srSoeg2Opslag[t] "Strukturel labor market tightness (snSoeg / snOpslag)."
    snLxDK[t] "Strukturelle grænsearbejdere i antal hoveder - inkluderer pt. sort arbejde."
    shLxDK[t] "Strukturel arbejdstid for grænsearbejdere."
    snL[s_,t] "Strukturel beskæftigede inklusiv grænsearbejdere."
    snSoegxDK[t] "Strukturel jobsøgende potentielle grænsearbejdere."
    snSoc[soc,t] "Strukturelle værdier for socio-grupper og aggregater, antal 1.000 personer, Kilde: BFR."
    snBruttoLedig[t] "Strukturelt bruttoledige. Antal 1.000 personer. Kilde: BFR"
    snBruttoArbsty[t] "Strukturel brutto-arbejdsstyrke. Antal 1.000 personer. Kilde: BFR"
    snNettoLedig[t] "Strukturelt nettoledige. Antal 1.000 personer. Kilde: BFR"
    snNettoArbsty[t] "Strukturel netto-arbejdsstyrke. Antal 1.000 personer. Kilde: BFR"
    dSoc2dPop[soc,t] "Marginal ændring i antallet i sociogruppe soc ved ændring i den samlede befolkningsstørrelse."
    srBruttoLedig[t] "Strukturel bruttoledighedsrate."
    srNettoLedig[t] "Strukturel nettoledighedsrate."
    shL2nLxDK[t] "Strukturel arbejdstid pr. grænsearbejder"
    shL2nL[s_,t] "Strukturel arbejdstid pr. beskæftiget"
    rBVTGab[t] "Outputgab."
    rBeskGab[t] "Beskæftigelsesgab."
    rNettoArbstyGab[t] "Arbejdsstyrkegab."
    snLHh_vaekst[a_,t] "Vækstfaktor for strukturel beskæftigelse. Kilde:socioøkonomisk fremskrivning (befolkningsregnskab)."
    snSoc_vaekst[soc,t] "Vækstfaktor for strukturelle socio-grupper. Kilde:socioøkonomisk fremskrivning (befolkningsregnskab)."
  ;

  $GROUP G_struk_exogenous_forecast
    snLHh[a_,t] 
    shLHh[a,t] 

    # Fordeling af socio-grupper  
    dSoc2dBesk[soc,t]$(t.val >= %BFR_t1%) "Marginal ændring i antallet i sociogruppe soc ved ændring i den samlede beskæftigelse."
    snSoc[soc,t] 

    fSoegBaseHh[a,t] "Asymptotisk maksimum for arbejdsmarkedsdeltagelse."   
  ;
  $GROUP+ G_exogenous_forecast G_struk_exogenous_forecast$(tx1[t]);

  $GROUP G_struk_forecast_as_zero
    jsnSoegxDK[t] "J-led"
    jsqBVT[s_,t] "J-led"
    jsnSoegBaseHh[a_,t] "J-led"
  ;
  $GROUP+ G_forecast_as_zero G_struk_forecast_as_zero$(tx1[t]);

  #  $GROUP G_struk_fixed_forecast
  #  ;

$ENDIF

# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_struk_static G_struk_static_core$(tx0[t])
      # Key gaps between structural and actual levels
    .. rBVTGab[t] =E= (qBVT[sTot,t] - qBVT['udv',t]) / (sqBVT[sTot,t] - qBVT['udv',t]) - 1; # Skal skiftes til Laspeyres

    .. rBeskGab[t] =E= nL[sTot,t] / snL[sTot,t] - 1;

    .. rNettoArbstyGab[t] =E= nNettoArbsty[t] / snNettoArbsty[t] - 1;

    # ------------------------------------------------------------------------------------------------------------------
    # Strukturel BVT
    # ------------------------------------------------------------------------------------------------------------------
    # Vi beregner strukturel BVT i private erhverv ud fra en Cobb-Douglas produktionsfunktion, i overensstemmelse med FMs estimering af konjunkturgab.
    # Faktisk kapital indgår med strukturel kapacitetsudnyttelse (=1)
    # Strukturel arbejdskraft indgår med strukturel kapacitetsudnyttelse på arbejdskraft
    # Strukturel arbejdskraft beregnes ud fra strukturelt arbejdsmarked nedenfor
    # NB: Vi bør altid tjekke, at den håndindtastede parameter er i nogenlunde overensstemmelse med de faktiske omkostningsandele
    .. sqBVT[spTot,t] =E= uBVT[spTot,t] * sqL[spTot,t]**0.65 * (qK[kTot,spTot,t-1]/fq)**0.35 + jsqBVT[spTot,t];

    # Strukturel BVT i private erhverv og øvrige brancher aggregeres med kædeindeks ud fra faktiske BVT-deflatorer.
    # Vi antager, at der ikke er konjunkturgab i den offentlige branche.
    .. spBVT[sTot,t] * sqBVT[sTot,t] =E= pBVT[spTot,t] * sqBVT[spTot,t] + vBVT['off',t];
    sqBVT[sTot,t]..
      spBVT[sTot,t-1]/fp * sqBVT[sTot,t] =E= pBVT[spTot,t-1]/fp * sqBVT[spTot,t] + pBVT['off',t-1]/fp * qBVT['off',t];
 
    # ======================================================================================================================
    # Strukturel beskæftigelse i hoveder og timer
    # ======================================================================================================================
    # Aggregater kommer fra aldersfordelte størrelser og fra udlandet
    .. shL[sTot,t] =E= shLHh[aTot,t] + shLxDK[t];
    .. snL[sTot,t] =E= snLHh[aTot,t] + snLxDK[t];

    # Der antages nul gab i offentlig beskæftigelse og udvinding
    $(off[s] or udv[s]).. snL[s,t] =E= nL[s,t];
    $(off[s] or udv[s]).. shL[s,t] =E= hL[s,t];

    # Strukturel beskæftigelse (i hoveder og timer) i private erhverv beregnes ud fra samlet strukturel beskæftigelse
    .. snL[spTot,t] =E= snL[sTot,t] - snL['off',t];
    .. shL[spTot,t] =E= shL[sTot,t] - shL['off',t];

    # Beskæftigelsesgab fordeles proportionalt på private erhverv undtagen udvinding
    snL[sp,t]$(not (tje[sp] or udv[sp]))..
      nL[sp,t] / snL[sp,t] =E= nL['tje',t] / snL['tje',t];
    shL[sp,t]$(not (tje[sp] or udv[sp]))..
      hL[sp,t] / shL[sp,t] =E= hL['tje',t] / shL['tje',t];

    # Tjenestebranchen beregnes residualt ud fra sum-identitet
    .. snL['tje',t] =E= snL[spTot,t] - sum(sp$(not tje[sp]), snL[sp,t]);
    .. shL['tje',t] =E= shL[spTot,t] - sum(sp$(not tje[sp]), shL[sp,t]);

    # Strukturel produktivitet på brancher beregnes ud fra faktisk produktivitet vægtet med strukturel beskæftigelse
    .. sqProd[sTot,t] * shL[sTot,t] =E= qProdHh[aTot,t] * shLHh[aTot,t] + qProdxDK[t] * shLxDK[t];
    .. sqProd['off',t] =E= uProd['off',t] * sqProd[sTot,t];
    sqProd[spTot,t].. sqProd[sTot,t] * shL[sTot,t] =E= sqProd[spTot,t] * shL[spTot,t] + sqProd['off',t] * shL['off',t];
    .. sqProd[sp,t] =E= uProd[sp,t] * sqProd[spTot,t] * shL[spTot,t] / sum(ssp, uProd[ssp,t] * shL[ssp,t]);

    # Strukturel effektiv arbejdskraft
    .. sqL[sp,t] =E= sqProd[sp,t] * (1-srOpslagOmk[t]) * shL[sp,t];
    .. sqL['off',t] =E= qL['off',t];
    .. sqL[spTot,t] =E= sum(sp, sqL[sp,t]);
    .. sqL[sTot,t] =E= sum(s, sqL[s,t]);

    # Strukturel arbejdstid
    shL2nL[sTot,t].. shL[sTot,t] =E= shL2nL[sTot,t] * snL[sTot,t];
    shL2nL[spTot,t].. shL[spTot,t] =E= shL2nL[spTot,t] * snL[spTot,t];
    shL2nL[s,t].. shL[s,t] =E= shL2nL[s,t] * snL[s,t];

    # ======================================================================================================================
    # Strukturelt arbejdsmarked
    # ======================================================================================================================
    # Job-opslag og matching
    ..  snOpslag[t] *srSoeg2Opslag[t] =E= snSoegHh[aTot,t] + snSoegxDK[t];

    .. srMatch[t] =E= srJobFinding[aTot,t] * srSoeg2Opslag[t];

    srSoeg2Opslag[t].. srJobFinding[aTot,t] =E= (1 + srSoeg2Opslag[t]**(1/eMatching))**(-eMatching) + jsrJobFinding[aTot,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Arbejdsudbud for grænsearbejdere
    # ------------------------------------------------------------------------------------------------------------------
    .. shLxDK[t] =E= shL2nLxDK[t] * snLxDK[t];
    .. shL2nLxDK[t] =E= uhLxDK[t] * shLHh[atot,t] / snLHh[aTot,t];
    .. snLxDK[t] =E= (1-srSeparation[aTot,t]) * snLxDK[t] + srJobFinding[aTot,t] * snSoegxDK[t];
    .. snSoegxDK[t] =E= nSoegBasexDK[t] - (1-srSeparation[aTot,t]) * snLxDK[t] + jsnSoegxDK[t];

    # ------------------------------------------------------------------------------------------------------------------
    # Husholdningernes samlede arbejdsudbud
    # ------------------------------------------------------------------------------------------------------------------
    snLHh&_via_srSeparation[aTot,t]..
      snLHh[aTot,t] =E= (1-srSeparation[aTot,t]) * snLHh[aTot,t] + srJobFinding[aTot,t] * snSoegHh[aTot,t];

    .. (snSoegHh[aTot,t] - jsnSoegHh[aTot,t]) * (1-srJobFinding[aTot,t]) + snLHh[aTot,t] =E= snSoegBaseHh[aTot,t]; 

    # ------------------------------------------------------------------------------------------------------------------
    # Strukturelle socio-grupper og aggregater herfra
    # ------------------------------------------------------------------------------------------------------------------
    dSoc2dPop[soc,t]$(t.val >= %BFR_t1%)..
      snSoc[soc,t] =E= dSoc2dBesk[soc,t] * snLHh[aTot,t] + dSoc2dPop[soc,t] * nPop['a15t100',t]
                     + nPop_Over100[t]$(sameas[soc,'pension']);

    $(t.val >= %BFR_t1%)..
      snSoc['boern',t] =E= nPop[aTot,t] - nPop['a15t100',t];

    $(t.val >= %cal_deep% and dSoc2dBesk.l[soc,t] <> 0).. snSoc_vaekst[soc,t] =E= snSoc[soc,t] / snSoc[soc,t-1];

    # Aggregater fra socio-grupper
    $(t.val >= %BFR_t1%).. snBruttoLedig[t] =E= sum(BruttoLedig, snSoc[BruttoLedig,t]);
    $(t.val >= %BFR_t1%).. snNettoLedig[t] =E= sum(NettoLedig, snSoc[NettoLedig,t]);
    $(t.val >= %BFR_t1%).. snBruttoArbsty[t] =E= sum(BruttoArbsty, snSoc[BruttoArbsty,t]) + snLxDK[t];
    $(t.val >= %BFR_t1%).. snNettoArbsty[t] =E= sum(NettoArbsty, snSoc[NettoArbsty,t]) + snLxDK[t];

    $(t.val >= %BFR_t1%).. srBruttoLedig[t] =E= snBruttoLedig[t] / snBruttoArbsty[t];
    $(t.val >= %BFR_t1%).. srNettoLedig[t] =E= snNettoLedig[t] / snNettoArbsty[t];
  $ENDBLOCK


  $BLOCK B_struk_forwardlooking G_struk_forwardlooking_core$(tx0[t])
    # ------------------------------------------------------------------------------------------------------------------
    # Strukturel BVT
    # ------------------------------------------------------------------------------------------------------------------
    # Vi finder strukturelt TFP i private erhverv ud fra Cobb-Douglas for faktisk BVT
    # med arbejdskraft inklusiv kapacitetsudnyttelse og kapital inklusiv kapacitetsudnyttelse
    uBVT[spTot,t]..
      qBVT[spTot,t] =E= uBVT[spTot,t] * (rLUdn[spTot,t] * qL[spTot,t])**0.65
                                      * (rKUdn[kTot,spTot,t] * qK[kTot,spTot,t-1]/fq)**0.35;
    # ======================================================================================================================
    # Strukturelt arbejdsmarked
    # ======================================================================================================================
    # Vi opskriver lønforhandling under antagelse af nul træghed
    # Løn-niveauet er ikke vel-bestemt uden efterspørgselssiden
    # Vi finder i stedet et strukturelt forhold mellem løn og usercost på arbejdskraft
    .. svVirkLoenPos2w[t] =E= sum(sp, (1-mtVirk[sp,t]) * spL2pW[sp,t] * shL[sp,t] * sqProd[sp,t]);

    .. sdvVirk2dpW[t] =E= - sum(sp, (1-mtVirk[sp,t]) * (1 + tL[sp,t]) * shL[sp,t] * sqProd[sp,t] * (1-srOpslagOmk[t]));

    srJobFinding[aTot,t]..
      1 =E= (1-rLoenNash[t]) * svVirkLoenPos2w[t] / (-sdvVirk2dpW[t]) + rLoenNash[t] * rFFLoenAlternativ * srJobFinding[aTot,t];
      #  1 =E= (1-rLoenNash[t]) * svVirkLoenPos2w[t] / (-sdvVirk2dpW[t]) + rLoenNash[t] * svFFOutsideOption2w[t] / sdFF2dLoen[t];

    # Strukturel FOC for stillingsopslag
    $(tx0E[t])..
      spL2pW[sp,t] =E= (1 + tL[sp,t]) * sqProd[sp,t] * (shL[sp,t]/snL[sp,t])
                     / (sdqL2dnL[sp,t] + (1-mtVirk[sp,t])/(1-mtVirk[sp,t]) * fDiskpL[sp,t+1] * sdqL2dnLlag[sp,t+1]*fq);

    spL2pW&_tEnd[sp,t]$(tEnd[t])..
      spL2pW[sp,t]/spL2pW[sp,t-1] =E= spL2pW[sp,t-1]/spL2pW[sp,t-2];

    .. sdqL2dnL[sp,t] =E= sqProd[sp,t] * shL[sp,t] / snL[sp,t] * (1 - sdOpslagOmk2dnL[t]);
    .. sdOpslagOmk2dnL[t] =E= uOpslagOmk[t] / srMatch[t] + uMatchOmk;

    $(tx1[t]).. sdqL2dnLlag[sp,t] =E= - sqProd[sp,t] * shL[sp,t] / snL[sp,t-1] * sdOpslagOmk2dnLlag[t]; # snL lagget imodsætning til dOpslagOmk2dnLLag
    $(tx1[t]).. sdOpslagOmk2dnLlag[t] =E= - (1-srSeparation[aTot,t]) * (uOpslagOmk[t] / srMatch[t-1] + uMatchOmk); # srMatch lagget imodsætning til dOpslagOmk2dnLLag

    .. srOpslagOmk[t] * snL[sTot,t] =E= uOpslagOmk[t] * snOpslag[t] + uMatchOmk * srMatch[t] * snOpslag[t];      
  $ENDBLOCK


  $BLOCK B_struk_a G_struk_a_core$(tx0[t])
    # ======================================================================================================================
    # Strukturelt arbejdsmarked
    # ======================================================================================================================
    # Vi opskriver lønforhandling under antagelse af nul træghed.
    # Løn-niveauet er ikke vel-bestemt uden efterspørgselssiden.
    # Vi finder i stedet et strukturelt forhold mellem løn og usercost på arbejdskraft.

    $(t.val > %AgeData_t1%)..
      sdFF2dLoen[t] =E= sum(a$(a15t100[a]), (1-mtInd[a,t]) * snLHh[a,t] * qProdHh[a,t] * shLHh[a,t]);

    $(t.val > %AgeData_t1%)..
      svFFOutsideOption2w[t] =E= rFFLoenAlternativ * sdFF2dLoen[t] * srJobFinding[aTot,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Husholdningernes samlede arbejdsudbud
    # ------------------------------------------------------------------------------------------------------------------
    $(t.val > %AgeData_t1%)..
      shLHh[atot,t] =E= sum(a$(a15t100[a]), shLHh[a,t] * snLHh[a,t]);

    $(t.val > %AgeData_t1%).. snLHh[aTot,t] =E= sum(a, snLHh[a,t]);

    $(t.val > %AgeData_t1%).. 
      snSoegBaseHh[aTot,t] =E= sum(a, snSoegBaseHh[a,t]);
    # ------------------------------------------------------------------------------------------------------------------
    # Husholdningernes arbejdsudbud fordelt på alder
    # ------------------------------------------------------------------------------------------------------------------
    # FOC for shLHh
    $(a15t100[a] and t.val > %AgeData_t1%)..
      shLHh[a,t] =E= 1/uh[a,t] * ((1-mtInd[a,t]) / fhLHh[a,t])**(1/eh);

    # Adjustment term to turn off marginal tax effects on labor supply intensive margin
    $(a15t100[a] and t.val > %AgeData_t1%)..
      fhLHh[a,t] =E= (1-mtInd[a,t]); 

    srJobFinding[a,t]$(a15t100[a])..
      srJobFinding[a,t] =E= srJobFinding[aTot,t] - jsrJobFinding[aTot,t] + jsrJobFinding[a,t];

    jsrJobFinding[aTot,t]$(t.val > %AgeData_t1%)..
      srJobFinding[aTot,t] * snSoegHh[aTot,t] =E= sum(a$(a15t100[a]), srJobFinding[a,t] * snSoegHh[a,t]);

    $(a15t100[a] and t.val > %AgeData_t1%)..
      snLHh[a,t] =E= (1-srSeparation[a,t]) * snLHh[a-1,t] / nPop[a-1,t] * nPop[a,t] + srJobFinding[a,t] * snSoegHh[a,t];
    
    $(t.val > %AgeData_t1% and aVal[a] > 15)..
      snLHh_vaekst[a,t] =E= snLHh[a,t] / snLHh[a-1,t-1];
    &_a15$(t.val > %AgeData_t1% and aVal[a] = 15)..
      snLHh_vaekst[a,t] =E= snLHh[a,t]/nPop[a,t] / (snLHh[a,t-1]/nPop[a,t-1]);

    $(a15t100[a] and t.val > %AgeData_t1%)..
      (snSoegHh[a,t] - jsnSoegHh[a,t]) * (1-srJobFinding[a,t]) + snLHh[a,t] =E= snSoegBaseHh[a,t];

    $(t.val > %AgeData_t1%).. jsnSoegHh[aTot,t] =E= sum(a$(a15t100[a]), jsnSoegHh[a,t]);

    $(a15t100[a] and t.val > %AgeData_t1%)..
      snSoegBaseHh[a,t] =E= fSoegBaseHh[a,t] * srSoegBaseHh[a,t] * nPop[a,t] + jsnSoegBaseHh[a,t];

    $(t.val > %AgeData_t1%).. jsnSoegBaseHh[aTot,t] =E= sum(a, jsnSoegBaseHh[a,t]);

    srSoegBaseHh[a,t]$(tx0E[t] and a15t100[a] and aVal[a] < 100 and t.val > %AgeData_t1%)..
      (uDeltag[a,t] / (1 - srSoegBaseHh[a,t]))**eDeltag =E= srJobFinding[a,t] * (
          (1 - mrKomp[a,t])**(eDeltag/emrKomp)
        + rOverlev[a,t] * (1-srSeparation[a+1,t+1]) * fDiskDeltag[a+1,t+1]
        * (1-srJobFinding[a+1,t+1]) / srJobFinding[a+1,t+1] * (uDeltag[a+1,t+1] / (1 - rSoegBaseHh[a+1,t+1]))**eDeltag
      );

    # Terminal condition for last period 
    srSoegBaseHh&_tEnd[a,t]$(tEnd[t] and a15t100[a] and aVal[a] < 100 and t.val > %AgeData_t1%)..
      (uDeltag[a,t] / (1 - srSoegBaseHh[a,t]))**eDeltag =E= srJobFinding[a,t] * (
          (1 - mrKomp[a,t])**(eDeltag/emrKomp)
        + rOverlev[a,t] * (1-srSeparation[a+1,t]) * fDiskDeltag[a+1,t]
        * (1-srJobFinding[a+1,t]) / srJobFinding[a+1,t] * (uDeltag[a+1,t] / (1 - rSoegBaseHh[a+1,t]))**eDeltag
      );

    # Terminal condition for last age group
    srSoegBaseHh&_aEnd[a,t]$(aVal[a] = 100 and t.val > %AgeData_t1%)..
      (uDeltag[a,t] / (1 - srSoegBaseHh[a,t]))**eDeltag =E= srJobFinding[a,t] * (
          (1 - mrKomp[a,t])**(eDeltag/emrKomp)
          # Ingen sandsynlighed for at beholde job til næste periode
      );
  $ENDBLOCK

  $GROUP G_struk_endo 
     G_struk_a_core
     G_struk_forwardlooking_core
     G_struk_static_core
     G_struk_endo_a$(tx0[t]) # Gruppen bør erstattes af en korrekt specificeret G_struk_static_core (som så kan omdøbes)
  ;

  MODEL M_struk /
    B_struk_static
    B_struk_forwardlooking
    B_struk_a
  /;
  model M_base / M_struk /;

  $GROUP G_struk_static
    G_struk_endo
    -G_struk_endo_a
    -uBVT
    -spL2pW # -E_spL2pW -E_spL2pW_tEnd: Har eksplicitte leads
    -svVirkLoenPos2w # -E_svVirkLoenPos2w: Påvirkes af spL2pW
    -snLHh$(aTot[a_]) # snLHh[tot] fastsættes eksogent til en rimelig størrelse - fx uændret # -E_snLHh_tot: Påvirkes af svVirkLoenPos2w
    -sdvVirk2dpW, -sdqL2dnL, -sdOpslagOmk2dnL, -sdqL2dnLlag, -sdOpslagOmk2dnLlag, -srOpslagOmk # påvirker alene snLHh direkte eller indirekte
  ; 
  model M_static / B_struk_static /;
  $GROUP+ G_static G_struk_static;
  $GROUP+ G_Endo G_struk_endo;
$ENDIF


$IF %stage% == "exogenous_values":
# ======================================================================================================================
# Load data
# ======================================================================================================================
  # Estimerede konjugaturgab fra FM indlæses
  $GROUP G_struk_FM rNettoArbstyGab, rBeskGab, rBVTGab;
  $IF2 %FM_baseline%:
    @load(G_struk_FM, "../Data/FM_exogenous_forecast.gdx")
  $ENDIF2

  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_struk_makrobk
    nNettoArbsty, nL[sTot], nLHh[aTot], qBVT[sTot]
  ;
  @load(G_labor_market_makrobk, "../Data/Makrobk/makrobk.gdx" )

  # Aldersfordelt data fra BFR indlæses
  $GROUP G_struk_BFR
    snLHh, shLHh,
    snLxDK, shLxDK
    srSeparation,
    snSoc, dSoc2dBesk
    nPop$(a[a_]) # Bruges til fSoegBaseHh nedenfor
    snNettoArbsty
  ;
  @load(G_struk_BFR, "../Data/Befolkningsregnskab/BFR.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_struk_data
    G_struk_makrobk
    G_struk_BFR$(%FM_baseline%)
    G_struk_FM$(%FM_baseline%)
  ;

  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_struk_data_imprecise      
    srSeparation$(aTot[a_])
    G_struk_FM$(%FM_baseline%)
  ;

# ======================================================================================================================
# Data assignment
# ======================================================================================================================
  # Outside BFR years, use employment gap from FM to calculate structural employment
  shL.l[sTot,t] = shLHh.l[aTot,t] + shLxDK.l[t];
  snL.l[sTot,t] = snLHh.l[aTot,t] + snLxDK.l[t];
  snL.l[sTot,t]$(t.val < %BFR_t1%) = (1 - rBeskGab.l[t]) * nL.l[sTot,t];
  shL.l[sTot,t]$(t.val < %BFR_t1%) = hL.l[sTot,t];
  snNettoArbsty.l[t]$(t.val < %BFR_t1%) = (1 - rNettoArbstyGab.l[t]) * nNettoArbsty.l[t];

  snLHh.l[aTot,t]$(t.val < %BFR_t1%) = snL.l[sTot,t] / snL.l[sTot,'%BFR_t1%'] * snLHh.l[aTot,'%BFR_t1%'];
  shLHh.l[aTot,t]$(t.val < %BFR_t1%) = shL.l[sTot,t] / shL.l[sTot,'%BFR_t1%'] * shLHh.l[aTot,'%BFR_t1%'];

  snLHh_vaekst.l[a,t]$(snLHh.l[a-1,t-1] > 0) = snLHh.l[a,t] / snLHh.l[a-1,t-1];
  snLHh_vaekst.l[a,t]$(aVal[a] = 15 and snLHh.l[a,t-1] > 0 and nPop.l[a,t] > 0 and nPop.l[a,t-1] > 0)
    = snLHh.l[a,t]/nPop.l[a,t] / (snLHh.l[a,t-1]/nPop.l[a,t-1]);

  snSoc_vaekst.l[soc,t]$(snSoc.l[soc,t-1] > 0) = snSoc.l[soc,t] / snSoc.l[soc,t-1];

  #Nedgangen i arbejdstid i 2020 bør ikke anses som strukturel ift. kalibrering af MAKRO
  #Lignende justering fortages på shLHh i BFR2GDX
  shL.l[sTot,'2020'] = (shL.l[sTot,'2019'] + shL.l[sTot,'2021']) /2;

  snLxDK.l[t] = snL.l[sTot,t] - snLHh.l[aTot,t];
  shLxDK.l[t] = shL.l[sTot,t] - shLHh.l[aTot,t];
  spBVT.l[s_,t]$(tBase[t]) = 1;

  # Asymptotisk maksimum for arbejdsmarkedsdeltagelse sættes til 3 gange strukturel beskæftigelse
  # Sættes for at undgå ekstreme konjunktur-gab i beskæftigelse for meget gamle husholdninger
  fSoegBaseHh.l[a,t]$(nPop.l[a,t] <> 0) = min(nPop.l[a,t], 3 * snLHh.l[a,t]) / nPop.l[a,t];
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_struk_static_calibration
    G_struk_endo
    -rBVTGab[t]$(%FM_baseline%), rLUdn[spTot,t]$(%FM_baseline%)
    -snLxDK, jsnSoegxDK # Number of foreign job searchers calibrated to match total employment
    -shLxDK, uhLxDK # Hours of foreign workers calibrated to match total hours worked
    -snLHh[aTot,t] # -E_snLHh_aTot_via_srJobFinding
    -shLHh[a15t100,t], uh[a15t100,t]
    -snLHh[a,t]$(t.val > %AgeData_t1%) # -E_srSoegBaseHh -E_srSoegBaseHh_tEnd -E_srSoegBaseHh_aEnd
    -snLHh[aTot,t] # -E_snLHh_aTot
    snSoegBaseHh[aTot,t] # E_snSoegBaseHh_aTot_static
  ;
  $GROUP G_struk_static_calibration_newdata G_struk_static_calibration$(tx0[t]);
  $GROUP+ G_static_calibration_newdata G_struk_static_calibration_newdata;

  $GROUP G_struk_static_calibration
    G_struk_static_calibration$(tx0[t])
    spBVT[s_,t0], -spBVT[s_,tBase]
  ;

  $BLOCK B_struk_static_calibration$(tx0[t])
    E_spL2pW_static[sp,t]..
      spL2pW[sp,t] =E= (1 + tL[sp,t]) * sqProd[sp,t] * (shL[sp,t]/snL[sp,t])
                     / (sdqL2dnL[sp,t] + (1-mtVirk[sp,t])/(1-mtVirk[sp,t]) * fVirkDisk[sp,t]*fp * sdqL2dnLlag[sp,t]*fq);

    E_snSoegBaseHh_aTot_static[t].. snSoegBaseHh[aTot,t] =E= snNettoArbsty[t];
  $ENDBLOCK
  MODEL M_struk_static_calibration /
    M_struk
    B_struk_static_calibration
    - E_srJobFinding_atot
    - E_spL2pW_sp -E_spL2pW_tEnd # E_spL2pW_static
    - E_srSoegBaseHh_a - E_srSoegBaseHh_tEnd - E_srSoegBaseHh_aEnd
    - E_snLHh_aTot
  /;
  model M_static_calibration / M_struk_static_calibration /;
  $GROUP+ G_static_calibration G_struk_static_calibration;
$ENDIF


# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_struk_deep
    G_struk_endo

    # Strukturel beskæftigelse i timer giver time-disnytte
    -shLHh[a15t100,t], uH[a15t100,t]
   
    $IF2 %FM_baseline%:
      -snLHh[a15t100,t1], jnSoegBaseHh[a15t100,t1]
      -snLHh[a15t100,tx1], uDeltag[a15t100,tx1]

      # Residualt BVT-gab rammes via kapacitetsudnyttelse
      -rBVTGab[t1], jfrLUdn_t[t1]

      jpW[t1] # E_rLoenNash_FM[t1]
    $ENDIF2

    # Gab bestemmes endogent i t1
    # BFR bruges til at fremskrive udvikling i strukturel beskæftigelse
    $IF2 %DREAM_baseline%:
      -snLHh_vaekst[a15t100,tx1], uDeltag[a15t100,tx1]
      -snSoc_vaekst[soc,t]$(tx1[t] and dSoc2dBesk.l[soc,t] <> 0), snSoc[soc,t]$(tx1[t] and dSoc2dBesk.l[soc,t] <> 0)
    $ENDIF2

    rLoenNash[tx1] # E_rLoenNash

    -snLxDK[t1], jsnSoegxDK[t1]
    -snLxDK[tx1], nSoegBasexDK[tx1]

    -shLxDK[t1], uhLxDK[t1]

  ;
  $GROUP G_struk_deep G_struk_deep$(tx0[t]);

  $BLOCK B_struk_deep$(tx0[t])
    E_rLoenNash_FM[t]$(%FM_baseline%).. snSoegBaseHh[aTot,t] =E= snNettoArbsty[t];

    E_rLoenNash_DREAM[t]$(%DREAM_baseline% and tx1[t])..
      rLoenNash[t] =E= rLoenNash_ARIMA[t] - rLoenNash_ARIMA[t1] + rLoenNash[t1];
  $ENDBLOCK
  MODEL M_struk_deep /
    M_struk    
    B_struk_deep
  /;
  model M_deep_dynamic_calibration / M_struk_deep /;
  $GROUP+ G_deep_dynamic_calibration G_struk_deep;
$ENDIF
 
# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
  $GROUP G_struk_dynamic_calibration
    G_struk_endo

    $IF2 %FM_baseline%:
      -snLHh[a15t100,t1], jnSoegBaseHh[a15t100,t1]
      -snSoegBaseHh[aTot,t], rLoenNash[t]
      -rBVTGab[t1], jfrLUdn_t[t1]
      -snLHh[a15t100,tx1], uDeltag[a15t100,tx1]
    $ENDIF2

    # Gab bestemmes endogent i t1
    # BFR bruges til at fremskrive udvikling i strukturel beskæftigelse
    $IF2 %DREAM_baseline%:
      -snLHh_vaekst[a15t100,tx1], uDeltag[a15t100,tx1]
      -snSoc_vaekst[soc,t]$(tx1[t] and dSoc2dBesk.l[soc,t] <> 0), snSoc[soc,t]$(tx1[t] and dSoc2dBesk.l[soc,t] <> 0)
    $ENDIF2

    -snLxDK[t]$(t.val < %cal_end%+1), jsnSoegxDK[t]$(t.val < %cal_end%+1)
    -snLxDK[t]$(t.val >= %cal_end%+1), nSoegBasexDK[t]$(t.val >= %cal_end%+1)
  ;

  # $BLOCK B_struk_dynamic_calibration
  # $ENDBLOCK

  MODEL M_struk_dynamic_calibration /
    M_struk
    # B_struk_dynamic_calibration
  /;
  model M_dynamic_calibration_newdata / M_struk_dynamic_calibration /;
  $GROUP+ G_dynamic_calibration_newdata G_struk_dynamic_calibration;
$ENDIF
