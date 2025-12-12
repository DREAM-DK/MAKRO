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
    # Values
    svFFOutsideOption2w[t]$(t.val > %AgeData_t1%) "Fagforenings forhandlingsalterntiv i lønforhandling."
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
    fhLHh[a,t]$(a15t100[a] and t.val > %AgeData_t1%) "Korrektionsfaktor til at slå effekter af marginal skat på arbejdsudbud til og fra på intensiv margin."
    sdFF2dLoen[t]$(t.val > %AgeData_t1%) "Fagforeningens værdifunktion differentieret ift. løn, strukturelt."
  ;
  $GROUP G_struk_endo
    G_struk_endo_a

    spBVT[s_,t] "Deflator for strukturel BVT."

    sqBVT[s_,t] "Strukturel BVT."
    sdqL2dnL[s_,t] "sqL differentieret ift. snL."
    sdqL2dnLlag[sp,t] "sqL[t] differentieret ift. snL[t-1]"
    sqL[s_,t] "Strukturel arbejdskraft i effektive enheder."
    sqProd[s_,t]$(s[s_] or spTot[s_] or sTot[s_]) "Strukturelt branchespecifikt produktivitetsindeks for arbejdskraft."
    sdvVirk2dpW[t] "Hjælpevariabel til lønforhandling. Negativ del af virksomhedernes værdifunktion i lønforhandling."
   
    spL2pW[sp,t] "Strukturelt forhold mellem user cost på arbejdskraft og lønnen."

    uBVT[s_,t]$(spTot[s_]) "Totalfaktor-produktivitet på BVT udover Harrod-neutral vækst, kapacitetsudnyttelse, og omstillingsomkostninger."

    shL[s_,t] "Strukturel arbejdstid fordelt på brancher."
    sdOpslagOmk2dnL[t] "srOpslagOmk * snL differentieret ift. snL."
    sdOpslagOmk2dnLlag[t] "sqL[t+1] differentieret ift. snL[t]"

    snLHh[a_,t]$(aTot[a_]) "Strukturel beskæftigelse."
    snSoegHh[a_,t]$(aTot[a_]) "Strukturel jobsøgende."
    srJobFinding[a_,t]$(aTot[a_]) "J-led"
    srMatch[t] "Strukturel andel af jobopslag, som resulterer i et match."
    srOpslagOmk[t] "Andel af arbejdskraft som går til hyrings-omkostninger strukturelt."
    snOpslag[t] "Strukturelt antal jobopslag."
    srSoeg2Opslag[t] "Strukturel labor market tightness (snSoeg / snOpslag)."

    snLxDK[t] "Strukturelle grænsearbejdere i antal hoveder - inkluderer pt. sort arbejde."
    shLxDK[t] "Strukturel arbejdstid for grænsearbejdere."
    snL[s_,t] "Strukturel beskæftigede inklusiv grænsearbejdere."
    snSoegxDK[t] "Strukturel jobsøgende potentielle grænsearbejdere."

    snSoc[soc,t]$(t.val >= %BFR_t1%) "Strukturelle værdier for socio-grupper og aggregater, antal 1.000 personer, Kilde: BFR."
    snBruttoLedig[t]$(t.val >= %BFR_t1%) "Strukturelt bruttoledige. Antal 1.000 personer. Kilde: BFR"
    snBruttoArbsty[t]$(t.val >= %BFR_t1%) "Strukturel brutto-arbejdsstyrke. Antal 1.000 personer. Kilde: BFR"
    snNettoLedig[t]$(t.val >= %BFR_t1%) "Strukturelt nettoledige. Antal 1.000 personer. Kilde: BFR"
    snNettoArbsty[t]$(t.val >= %BFR_t1%) "Strukturel netto-arbejdsstyrke. Antal 1.000 personer. Kilde: BFR"
    dSoc2dPop[soc,t]$(boern[soc] and t.val >= %BFR_t1%) "Marginal ændring i antallet i sociogruppe soc ved ændring i den samlede befolkningsstørrelse."
    srBruttoLedig[t]$(t.val >= %BFR_t1%) "Strukturel bruttoledighedsrate."
    srNettoLedig[t]$(t.val >= %BFR_t1%) "Strukturel nettoledighedsrate."
    shL2nLxDK[t] "Strukturel arbejdstid pr. grænsearbejder"
    shL2nL[s_,t] "Strukturel arbejdstid pr. beskæftiget"

    rBVTGab[t] "Outputgab."
    rBeskGab[t] "Beskæftigelsesgab."
    rNettoArbstyGab[t] "Arbejdsstyrkegab."

    rspBVT[t] "Relative laggede priser for strukturelt BVT vægtet med nutidige mængder."
  ;
  $GROUP G_struk_endo G_struk_endo$(tx0[t]);

  $GROUP G_struk_exogenous_forecast
    snLHh[a_,t]
    shLHh[a,t]

    # Fordeling af socio-grupper  
    dSoc2dBesk[soc,t] "Marginal ændring i antallet i sociogruppe soc ved ændring i den samlede beskæftigelse."
    snSoc[soc,t]

    fSoegBaseHh[a,t] "Asymptotisk maksimum for arbejdsmarkedsdeltagelse."   
    rLoenNash[t] "Nash-forhandlingsvægt (arbejdsgiveres forhandlingsstyrke)."
  ;
  $GROUP G_struk_forecast_as_zero
    jsnSoegxDK[t] "J-led"
    jsqBVT[s_,t] "J-led"
  ;
  #  $GROUP G_struk_fixed_forecast
  #  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_struk_static$(tx0[t])
    # Key gaps between structural and actual levels
    E_rBVTGab[t]..
      rBVTGab[t] =E= (qBVT[sTot,t] - qBVT['udv',t]) / (sqBVT[sTot,t] - qBVT['udv',t]) - 1; # Skal skiftes til Laspeyres

    E_rBeskGab[t].. rBeskGab[t] =E= nL[sTot,t] / snL[sTot,t] - 1;

    E_rNettoArbstyGab[t].. rNettoArbstyGab[t] =E= nNettoArbsty[t] / snNettoArbsty[t] - 1;

    # ------------------------------------------------------------------------------------------------------------------
    # Strukturel BVT
    # ------------------------------------------------------------------------------------------------------------------
    # Vi beregner strukturel BVT i private erhverv ud fra en Cobb-Douglas produktionsfunktion, i overensstemmelse med FMs estimering af konjunkturgab.
    # Faktisk kapital indgår med strukturel kapacitetsudnyttelse (=1)
    # Strukturel arbejdskraft indgår med strukturel kapacitetsudnyttelse på arbejdskraft
    # Strukturel arbejdskraft beregnes ud fra strukturelt arbejdsmarked nedenfor
    # NB: Vi bør altid tjekke, at den håndindtastede parameter er i nogenlunde overensstemmelse med de faktiske omkostningsandele
    E_sqBVT_spTot[t].. sqBVT[spTot,t] =E= uBVT[spTot,t] * sqL[spTot,t]**0.65 * (qK[kTot,spTot,t-1]/fq)**0.35 + jsqBVT[spTot,t];

    # Strukturel BVT i private erhverv og øvrige brancher aggregeres med kædeindeks ud fra faktiske BVT-deflatorer.
    # Vi antager, at der ikke er konjunkturgab i den offentlige branche.
    E_spBVT_sTot[t]..
      spBVT[sTot,t] * sqBVT[sTot,t] =E= pBVT[spTot,t] * sqBVT[spTot,t] + vBVT['off',t];
    E_sqBVT_via_rspBVT[t]..
      sqBVT[sTot,t] =E= rspBVT[t] * (sqBVT[spTot,t] + qBVT['off',t]);
    E_sqBVT_sTot[t]..
      spBVT[sTot,t-1]/fp * sqBVT[sTot,t] =E= pBVT[spTot,t-1]/fp * sqBVT[spTot,t] + pBVT['off',t-1]/fp * qBVT['off',t];
   
    # ======================================================================================================================
    # Strukturel beskæftigelse i hoveder og timer
    # ======================================================================================================================
    # Aggregater kommer fra aldersfordelte størrelser og fra udlandet
    E_shL_sTot[t].. shL[sTot,t] =E= shLHh[aTot,t] + shLxDK[t];
    E_snL_sTot[t].. snL[sTot,t] =E= snLHh[aTot,t] + snLxDK[t];

    # Der antages nul gab i offentlig beskæftigelse og udvinding
    E_snL_nul_gab[s,t]$((off[s] or udv[s])).. snL[s,t] =E= nL[s,t];
    E_shL_nul_gab[s,t]$((off[s] or udv[s])).. shL[s,t] =E= hL[s,t];

    # Strukturel beskæftigelse (i hoveder og timer) i private erhverv beregnes ud fra samlet strukturel beskæftigelse
    E_snL_spTot[t].. snL[spTot,t] =E= snL[sTot,t] - snL['off',t];
    E_shL_spTot[t].. shL[spTot,t] =E= shL[sTot,t] - shL['off',t];

    # Beskæftigelsesgab fordeles proportionalt på private erhverv undtagen udvinding
    E_snL[sp,t]$(not (tje[sp] or udv[sp]))..
      nL[sp,t] / snL[sp,t] =E= nL['tje',t] / snL[tje,t];
    E_shL[sp,t]$(not (tje[sp] or udv[sp]))..
      hL[sp,t] / shL[sp,t] =E= hL['tje',t] / shL['tje',t];

    # Tjenestebranchen beregnes residualt ud fra sum-identitet
    E_snL_tje[t].. snL[sTot,t] =E= sum(s, snL[s,t]);
    E_shL_tje[t].. shL[sTot,t] =E= sum(s, shL[s,t]);

    # Strukturel produktivitet på brancher beregnes ud fra faktisk produktivitet vægtet med strukturel beskæftigelse
    E_sqProd_sTot[t]..
      sqProd[sTot,t] * shL[sTot,t] =E= qProdHh[aTot,t] * shLHh[aTot,t] + qProdxDK[t] * shLxDK[t];
    E_sqProd_off[t].. sqProd['off',t] =E= uProd['off',t] * sqProd[sTot,t];
    E_sqProd_spTot[t].. sqProd[sTot,t] * shL[sTot,t] =E= sqProd[spTot,t] * shL[spTot,t] + sqProd['off',t] * shL['off',t];
    E_sqProd_sp[sp,t].. sqProd[sp,t] =E= uProd[sp,t] * sqProd[spTot,t] * shL[spTot,t] / sum(ssp, uProd[ssp,t] * shL[ssp,t]);

    # Strukturel effektiv arbejdskraft
    E_sqL_sp[sp,t].. sqL[sp,t] =E= sqProd[sp,t] * (1-srOpslagOmk[t]) * shL[sp,t];
    E_sqL_off[t].. sqL['off',t] =E= qL['off',t];
    E_sqL_spTot[t].. sqL[spTot,t] =E= sum(sp, sqL[sp,t]);
    E_sqL_sTot[t].. sqL[sTot,t] =E= sum(s, sqL[s,t]);

    # Strukturel arbejdstid
    E_shL2nL_sTot[t].. shL[sTot,t] =E= shL2nL[sTot,t] * snL[sTot,t];
    E_shL2nL_spTot[t].. shL[spTot,t] =E= shL2nL[spTot,t] * snL[spTot,t];
    E_shL2nL[s,t].. shL[s,t] =E= shL2nL[s,t] * snL[s,t];

    # ======================================================================================================================
    # Strukturelt arbejdsmarked
    # ======================================================================================================================
    # Job-opslag og matching
    E_srSoeg2Opslag[t].. srSoeg2Opslag[t] * snOpslag[t] =E= snSoegHh[aTot,t] + snSoegxDK[t];

    E_snOpslag[t].. srMatch[t] =E= srJobFinding[aTot,t] * srSoeg2Opslag[t];

    E_srMatch[t].. srJobFinding[aTot,t] =E= (1 + srSoeg2Opslag[t]**(1/eMatching))**(-eMatching) + jsrJobFinding[aTot,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Arbejdsudbud for grænsearbejdere
    # ------------------------------------------------------------------------------------------------------------------
    E_shLxDK[t].. shLxDK[t] =E= shL2nLxDK[t] * snLxDK[t];
    E_shL2nLxDK[t].. shL2nLxDK[t] =E= uhLxDK[t] * shLHh[atot,t] / snLHh[aTot,t];
    E_snLxDK[t].. snLxDK[t] =E= (1-srSeparation[aTot,t]) * snLxDK[t] + srJobFinding[aTot,t] * snSoegxDK[t];
    E_snSoegxDK[t].. snSoegxDK[t] =E= nSoegBasexDK[t] - (1-srSeparation[aTot,t]) * snLxDK[t] + jsnSoegxDK[t];

    # ------------------------------------------------------------------------------------------------------------------
    # Husholdningernes samlede arbejdsudbud
    # ------------------------------------------------------------------------------------------------------------------
    E_snLHh_aTot_via_srSeparation[t]..
      snLHh[aTot,t] =E= (1-srSeparation[aTot,t]) * snLHh[aTot,t] + srJobFinding[aTot,t] * snSoegHh[aTot,t];

    E_snSoegHh_tot[t]..
      snSoegHh[aTot,t] =E= (snSoegBaseHh[aTot,t] - snLHh[aTot,t]) / (1-srJobFinding[aTot,t]) + jsnSoegHh[aTot,t]; 

    # ------------------------------------------------------------------------------------------------------------------
    # Strukturelle socio-grupper og aggregater herfra
    # ------------------------------------------------------------------------------------------------------------------
    E_snSoc[soc,t]$(t.val >= %BFR_t1%)..
      snSoc[soc,t] =E= dSoc2dBesk[soc,t] * snLHh[aTot,t] + dSoc2dPop[soc,t] * nPop['a15t100',t]
                     + nPop_Over100[t]$(sameas[soc,'pension']);

    E_dSoc2dPop_boern[t]$(t.val >= %BFR_t1%)..
      snSoc['boern',t] =E= nPop[aTot,t] - nPop['a15t100',t];

    # Aggregater fra socio-grupper
    E_snBruttoLedig[t]$(t.val >= %BFR_t1%).. snBruttoLedig[t] =E= sum(BruttoLedig, snSoc[BruttoLedig,t]);
    E_snNettoLedig[t]$(t.val >= %BFR_t1%).. snNettoLedig[t] =E= sum(NettoLedig, snSoc[NettoLedig,t]);
    E_snBruttoArbsty[t]$(t.val >= %BFR_t1%).. snBruttoArbsty[t] =E= sum(BruttoArbsty, snSoc[BruttoArbsty,t]) + snLxDK[t];
    E_snNettoArbsty[t]$(t.val >= %BFR_t1%).. snNettoArbsty[t] =E= sum(NettoArbsty, snSoc[NettoArbsty,t]) + snLxDK[t];

    E_srBruttoLedig[t]$(t.val >= %BFR_t1%).. srBruttoLedig[t] =E= snBruttoLedig[t] / snBruttoArbsty[t];
    E_srNettoLedig[t]$(t.val >= %BFR_t1%).. srNettoLedig[t] =E= snNettoLedig[t] / snNettoArbsty[t];
  $ENDBLOCK

  $BLOCK B_struk_forwardlooking$(tx0[t])
    # ------------------------------------------------------------------------------------------------------------------
    # Strukturel BVT
    # ------------------------------------------------------------------------------------------------------------------
    # Vi finder strukturelt TFP i private erhverv ud fra Cobb-Douglas for faktisk BVT
    # med arbejdskraft inklusiv kapacitetsudnyttelse og kapital inklusiv kapacitetsudnyttelse
    E_uBVT_spTot[t]..
      qBVT[spTot,t] =E= uBVT[spTot,t] * (rLUdn[spTot,t] * qL[spTot,t])**0.65
                                      * (rKUdn[kTot,spTot,t] * qK[kTot,spTot,t-1]/fq)**0.35;
    # ======================================================================================================================
    # Strukturelt arbejdsmarked
    # ======================================================================================================================
    # Vi opskriver lønforhandling under antagelse af nul træghed
    # Løn-niveauet er ikke vel-bestemt uden efterspørgselssiden
    # Vi finder i stedet et strukturelt forhold mellem løn og usercost på arbejdskraft
    E_svVirkLoenPos2w[t]..
      svVirkLoenPos2w[t] =E= sum(sp, (1-mtVirk[sp,t]) * spL2pW[sp,t] * shL[sp,t] * sqProd[sp,t]);

    E_sdvVirk2dpW[t]..
      sdvVirk2dpW[t] =E= - sum(sp, (1-mtVirk[sp,t]) * (1 + tL[sp,t]) * shL[sp,t] * sqProd[sp,t] * (1-srOpslagOmk[t]));

    E_snLHh_aTot_via_srJobFinding[t]..
      1 =E= (1-rLoenNash[t]) * svVirkLoenPos2w[t] / (-sdvVirk2dpW[t]) + rLoenNash[t] * rFFLoenAlternativ * srJobFinding[aTot,t];
      #  1 =E= (1-rLoenNash[t]) * svVirkLoenPos2w[t] / (-sdvVirk2dpW[t]) + rLoenNash[t] * svFFOutsideOption2w[t] / sdFF2dLoen[t];

    # Strukturel FOC for stillingsopslag
    E_spL2pW[sp,t]$(tx0E[t])..
      spL2pW[sp,t] =E= (1 + tL[sp,t]) * sqProd[sp,t] * (shL[sp,t]/snL[sp,t])
                     / (sdqL2dnL[sp,t] + (1-mtVirk[sp,t])/(1-mtVirk[sp,t]) * fDiskpL[sp,t+1] * sdqL2dnLlag[sp,t+1]*fq);

    E_spL2pW_tEnd[sp,t]$(tEnd[t])..
      spL2pW[sp,t]/spL2pW[sp,t-1] =E= spL2pW[sp,t-1]/spL2pW[sp,t-2];

    E_sdqL2dnL[sp,t]..
      sdqL2dnL[sp,t] =E= sqProd[sp,t] * shL[sp,t] / snL[sp,t] * (1 - sdOpslagOmk2dnL[t]);
    E_sdOpslagOmk2dnL[t]..
      sdOpslagOmk2dnL[t] =E= uOpslagOmk[t] / srMatch[t] + uMatchOmk;

    E_sdqL2dnLlag[sp,t]$(tx1[t])..
      sdqL2dnLlag[sp,t] =E= - sqProd[sp,t] * shL[sp,t] / snL[sp,t-1] * sdOpslagOmk2dnLlag[t]; # snL lagget imodsætning til dOpslagOmk2dnLLag
    E_sdOpslagOmk2dnLlag[t]$(tx1[t])..
      sdOpslagOmk2dnLlag[t] =E= - (1-srSeparation[aTot,t]) * (uOpslagOmk[t] / srMatch[t-1] + uMatchOmk); # srMatch lagget imodsætning til dOpslagOmk2dnLLag

    E_srOpslagOmk[t]..
      srOpslagOmk[t] * snL[sTot,t] =E= uOpslagOmk[t] * snOpslag[t] + uMatchOmk * srMatch[t] * snOpslag[t];                                  
  $ENDBLOCK

  $BLOCK B_struk_a$(tx0[t])
    # ======================================================================================================================
    # Strukturelt arbejdsmarked
    # ======================================================================================================================
    # Vi opskriver lønforhandling under antagelse af nul træghed.
    # Løn-niveauet er ikke vel-bestemt uden efterspørgselssiden.
    # Vi finder i stedet et strukturelt forhold mellem løn og usercost på arbejdskraft.

    E_sdFF2dLoen[t]$(t.val > %AgeData_t1%)..
      sdFF2dLoen[t] =E= sum(a, (1-mtInd[a,t]) * snLHh[a,t] * qProdHh[a,t] * shLHh[a,t]);

    E_svFFOutsideOption2w[t]$(t.val > %AgeData_t1%)..
      svFFOutsideOption2w[t] =E= rFFLoenAlternativ * sdFF2dLoen[t] * srJobFinding[aTot,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Husholdningernes samlede arbejdsudbud
    # ------------------------------------------------------------------------------------------------------------------
    E_shLHh_tot[t]$(t.val > %AgeData_t1%)..
      shLHh[atot,t] =E= sum(a, shLHh[a,t] * snLHh[a,t]);

    E_snLHh_aTot[t]$(t.val > %AgeData_t1%).. snLHh[aTot,t] =E= sum(a, snLHh[a,t]);

    E_snSoegBaseHh_aTot[t]$(t.val > %AgeData_t1%).. 
      snSoegBaseHh[aTot,t] =E= sum(a, snSoegBaseHh[a,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Husholdningernes arbejdsudbud fordelt på alder
    # ------------------------------------------------------------------------------------------------------------------
    # FOC for shLHh
    E_shLHh[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      shLHh[a,t] =E= 1/uh[a,t] * ((1-mtInd[a,t]) / fhLHh[a,t])**(1/eh);

    # Adjustment term to turn off marginal tax effects on labor supply intensive margin
    E_fhLHh[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      fhLHh[a,t] =E= (1-mtInd[a,t]); 

    E_srJobFinding[a,t]$(a15t100[a])..
      srJobFinding[a,t] =E= srJobFinding[aTot,t] - jsrJobFinding[aTot,t] + jsrJobFinding[a,t];

    E_jsrJobFinding_aTot[t]$(t.val > %AgeData_t1%)..
      srJobFinding[aTot,t] * snSoegHh[aTot,t] =E= sum(a$(a15t100[a]), srJobFinding[a,t] * snSoegHh[a,t]);

    E_snLHh[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      snLHh[a,t] =E= (1-srSeparation[a,t]) * snLHh[a-1,t] / nPop[a-1,t] * nPop[a,t] + srJobFinding[a,t] * snSoegHh[a,t];

    E_snSoegHh[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      snSoegHh[a,t] =E= (snSoegBaseHh[a,t] - snLHh[a,t]) / (1-srJobFinding[a,t]) + jsnSoegHh[a,t];

    E_jsnSoegHh_aTot[t]$(t.val > %AgeData_t1%)..
      snSoegHh[aTot,t] =E= sum(a$(a15t100[a]), snSoegHh[a,t]);

    E_snSoegBaseHh[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      snSoegBaseHh[a,t] =E= fSoegBaseHh[a,t] * srSoegBaseHh[a,t] * nPop[a,t];

    E_srSoegBaseHh[a,t]$(tx0E[t] and a15t100[a] and a.val < 100 and t.val > %AgeData_t1%)..
      (uDeltag[a,t] / (1 - srSoegBaseHh[a,t]))**eDeltag =E= srJobFinding[a,t] * (
          (1 - mrKomp[a,t])**(eDeltag/emrKomp)
        + rOverlev[a,t] * (1-srSeparation[a+1,t+1]) * fDiskDeltag[a+1,t+1]
        * (1-srJobFinding[a+1,t+1]) / srJobFinding[a+1,t+1] * (uDeltag[a+1,t+1] / (1 - rSoegBaseHh[a+1,t+1]))**eDeltag
      );
    
    # Terminal condition for last period 
    E_srSoegBaseHh_tEnd[a,t]$(tEnd[t] and a15t100[a] and a.val < 100 and t.val > %AgeData_t1%)..
      (uDeltag[a,t] / (1 - srSoegBaseHh[a,t]))**eDeltag =E= srJobFinding[a,t] * (
          (1 - mrKomp[a,t])**(eDeltag/emrKomp)
        + rOverlev[a,t] * (1-srSeparation[a+1,t]) * fDiskDeltag[a+1,t]
        * (1-srJobFinding[a+1,t]) / srJobFinding[a+1,t] * (uDeltag[a+1,t] / (1 - rSoegBaseHh[a+1,t]))**eDeltag
      );

    # Terminal condition for last age group
    E_srSoegBaseHh_aEnd[a,t]$(a.val = 100 and t.val > %AgeData_t1%)..
      (uDeltag[a,t] / (1 - srSoegBaseHh[a,t]))**eDeltag =E= srJobFinding[a,t] * (
          (1 - mrKomp[a,t])**(eDeltag/emrKomp)
          # Ingen sandsynlighed for at beholde job til næste periode
      );
  $ENDBLOCK 

  MODEL M_struk /
    B_struk_static
    B_struk_forwardlooking
    B_struk_a
  /;

  $GROUP G_struk_static
    G_struk_endo
    -G_struk_endo_a
    -uBVT
    -spL2pW # -E_spL2pW -E_spL2pW_tEnd: Har eksplicitte leads
    -svVirkLoenPos2w # -E_svVirkLoenPos2w: Påvirkes af spL2pW
    -snLHh$(aTot[a_]) # snLHh[tot] fastsættes eksogent til en rimelig størrelse - fx uændret # -E_snLHh_tot: Påvirkes af svVirkLoenPos2w
    -sdvVirk2dpW, -sdqL2dnL, -sdOpslagOmk2dnL, -sdqL2dnLlag, -sdOpslagOmk2dnLlag, -srOpslagOmk # påvirker alene snLHh direkte eller indirekte
    ; 
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
    G_struk_BFR
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
    -snSoc[soc,t]$(not boern[soc]), dSoc2dPop[soc,t]$(not boern[soc] and t.val >= %BFR_t1%)
  ;
  $GROUP G_struk_static_calibration_newdata G_struk_static_calibration$(tx0[t]);

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
    -E_snLHh_aTot_via_srJobFinding
    -E_spL2pW -E_spL2pW_tEnd # E_spL2pW_static
    - E_srSoegBaseHh - E_srSoegBaseHh_tEnd - E_srSoegBaseHh_aEnd
    - E_snLHh_aTot
  /;
$ENDIF


# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_struk_deep
    G_struk_endo

    # Strukturel beskæftigelse i timer giver time-disnytte
    -shLHh[a15t100,t], uH[a15t100,t]

    # I sidste data-år kalibreres uDeltag fra faktisk beskæftigelse.
    # Estimeret strukturel beskæftigelse rammes med j-led i t1 og mellemfristet-perioden.
    -snLHh[a15t100,t]$(t.val < %cal_end%+1), jsnSoegHh[a15t100,t]$(t.val < %cal_end%+1)
    # På længere sigt bruges eksogen fremskrivning af strukturel beskæftigelse, inklusiv ændringer i pensionsalder mv.
    -snLHh[a15t100,t]$(t.val >= %cal_end%+1), uDeltag[a15t100,t]$(t.val >= %cal_end%+1)
    # Vi interpolerer uDeltag lineært fra værdien kalibreret til faktisk beskæftigselse, til en værdi kalibreret pba. fremskrivning af strukturel beskæftigelse.
    uDeltag[a15t100,tx1]$(t.val < %cal_end%+1) # E_uDeltag_mf

    -snSoegBaseHh[aTot,t1], rLoenNash[t1]
    rLoenNash[tx1], # E_rLoenNash, E_rLoenNash_mf

    # På længere sigt bruges eksogen fremskrivning af strukturel grænsearbejde
    -snLxDK[t]$(t.val >= %cal_end%+1), nSoegBasexDK[t]$(t.val >= %cal_end%+1)
    # Vi interpolerer nSoegBasexDK lineært fra værdien kalibreret til faktisk grænsearbejde, til en værdi kalibreret pba. fremskrivning af strukturelt grænsearbejde.
    nSoegBasexDK[tx1]$(t.val < %cal_end%+1) # E_nSoegBasexDK_mf
    # Antagelse om nul gab rammes med j-led i sidste data år og perioden hvor nSoegBasexDK interpoleres.
    -snLxDK[t]$(t.val < %cal_end%+1), jsnSoegxDK[t]$(t.val < %cal_end%+1)

    -shLxDK[t1], uhLxDK[t1]

    # Residualt BVT-gab rammes via kapacitetsudnyttelse
    -rBVTGab[t1]$(%FM_baseline%), jfrLUdn_t[t1]$(%FM_baseline%)

    -snSoc[soc,t]$(not boern[soc]), dSoc2dPop[soc,t]$(not boern[soc])
  ;
  $GROUP G_struk_deep G_struk_deep$(tx0[t]);

  $BLOCK B_struk_deep$(tx0[t])
    E_uDeltag_mf[a,t]$(tx1[t] and t.val < %cal_end%+1 and a15t100[a])..
      uDeltag[a,t] =E= uDeltag[a,t-1] * 0.5 + 0.5 * uDeltag[a,t+1];

    E_nSoegBasexDK_mf[t]$(tx1[t] and t.val < %cal_end%+1)..
      nSoegBasexDK[t] =E= nSoegBasexDK[t-1] * 0.5 + 0.5 * nSoegBasexDK[t+1];

    E_rLoenNash[t]$(t.val >= %cal_end%+1).. snSoegBaseHh[aTot,t] =E= snNettoArbsty[t];
    E_rLoenNash_mf[t]$(tx1[t] and t.val < %cal_end%+1)..
      snSoegBaseHh[aTot,t] =E= snSoegBaseHh[aTot,t-1] * 0.5 + 0.5 * snSoegBaseHh[aTot,t+1];
  $ENDBLOCK
  MODEL M_struk_deep /
    M_struk    
    B_struk_deep
  /;
$ENDIF
 
# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
  $GROUP G_struk_dynamic_calibration
    G_struk_endo

    -snLHh[a15t100,t]$(t.val < %cal_end%+1), jsnSoegHh[a15t100,t]$(t.val < %cal_end%+1)
    -snLHh[a15t100,t]$(t.val >= %cal_end%+1), uDeltag[a15t100,t]$(t.val >= %cal_end%+1)

    $IF2 %FM_baseline%:
      -snSoegBaseHh[aTot,t]$(t.val <> 2020), rLoenNash[t]$(t.val <> 2020) # I 2020 er arbejdsstyrke ikke et godt mål for det reelle arbejdsudbud (pga. corona-nedlukning)
      -rBVTGab[t1], jfrLUdn_t[t1]$(t1.val<>2020), jsqBVT[spTot,t1]$(t1.val=2020)
    $ENDIF2

    -snLxDK[t]$(t.val < %cal_end%+1), jsnSoegxDK[t]$(t.val < %cal_end%+1)
    -snLxDK[t]$(t.val >= %cal_end%+1), nSoegBasexDK[t]$(t.val >= %cal_end%+1)

    -snSoc[soc,t]$(not boern[soc]), dSoc2dPop[soc,t]$(not boern[soc])
  ;

  # $BLOCK B_struk_dynamic_calibration
  # $ENDBLOCK

  MODEL M_struk_dynamic_calibration /
    M_struk
    # B_struk_dynamic_calibration
  /;
$ENDIF
