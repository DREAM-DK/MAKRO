# ======================================================================================================================
# Labor market
# - labor force participation, job searching and matching, and wage bargaining
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_labor_market_prices_endo
    pL[s_,t]$(sp[s_] or spTot[s_]) "User cost for effektiv arbejdskraft i produktionsfunktion."
    pW[t] "Løn pr. produktiv enhed arbejdskraft."
  ;

  $GROUP G_labor_market_quantities_endo_a
    qProdHh[a_,t]$(t.val > %AgeData_t1%) "Aldersfordelt produktivitet."
  ;

  $GROUP G_labor_market_quantities_endo
    G_labor_market_quantities_endo_a
    dqL2dnL[s_,t] "qL differentieret ift. nL."
    dqL2dnLlag[sp,t] "qL[t] differentieret ift. nL[t-1]"
    qProd[s_,t] "Branchespecifikt produktivitetsindeks for arbejdskraft."
    dvVirk2dpW[t] "Virksomhedernes værdifunktion i lønforhandling differentieret ift. løn."
  ;

  $GROUP G_labor_market_values_endo_a
    vWHh[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Årsløn pr. person."
  ;

  $GROUP G_labor_market_values_endo
    G_labor_market_values_endo_a

    vWHh[a_,t]$(aTot[a_]) "Årsløn pr. beskæftiget."
    vhWIndustri[t] "Gennemsnitlig timeløn i industrien. Kilde: ADAM[lna]"
    vhW_DA[t] "Gennemsnitlig timeløn for lønmodtagere ekskl. genetillæg, DA-området. Kilde: ADAM[lnda]"
    vhW[t] "Gennemsnitlig timeløn."
    vWxDK[t] "Lønsum til grænsearbejdere."

    vSelvstLoen[s_,t] "Lønudbetaling til selvstændige."
    vLoensum[s_,t] "Lønsum, Kilde: ADAM[Yw]"

    vVirkLoenPos[t] "Hjælpevariabel til lønforhandling. Positiv del af virksomhedernes værdifunktion i lønforhandling."
    vFFOutsideOption[t] "Fagforenings forhandlingsalterntiv i lønforhandling."
  ;

  $GROUP G_labor_market_endo_a
    G_labor_market_quantities_endo_a
    G_labor_market_values_endo_a

    nSoegBaseHh[a_,t]$((aTot[a_] or a15t100[a_]) and t.val > %AgeData_t1%) "Sum af jobsøgende og beskæftigede."
    rSoegBaseHh[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Sum af jobsøgende og beskæftigede som andel af befolkning."
    nLHh[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Beskæftigelse."
    nSoegHh[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Jobsøgende."
    hLHh[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Aldersfordelt arbejdstid, Kilde: FMs Befolkningsregnskab."
    rSeparation[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "Job-separations-rate."
    jhLHh[t]$(t.val >= %BFR_t1%) "J-led i timebeslutning."
    dFF2dLoen[t]$(t.val > %AgeData_t1%) "Fagforeningens værdifunktion i lønforhandling differentieret ift. løn."
    rJobFinding[a_,t]$(a15t100[a_]) "Andel af jobsøgende som får et job."
    jrJobFinding[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "J-led"
  ;

  $GROUP G_labor_market_endo 
    G_labor_market_endo_a
    G_labor_market_prices_endo
    G_labor_market_quantities_endo
    G_labor_market_values_endo

    hL2nL[s_,t] "Arbejdstid pr. beskæftiget"
    hL2nLxDK[t] "Arbejdstid pr. grænsearbejder"
    dOpslagOmk2dnL[sp,t] "rOpslagOmk * nL differentieret ift. nL."
    dOpslagOmk2dnLLag[sp,t] "rOpslagOmk * nL differentieret ift. nL[t-1]"

    nLHh[a_,t]$(aTot[a_]) "Beskæftigelse."
    nSoegHh[a_,t]$(aTot[a_]) "Jobsøgende."

    nLxDK[t] "Grænsearbejdere i antal hoveder - inkluderer pt. sort arbejde."
    nSoegxDK[t] "Jobsøgende potentielle grænsearbejdere."

    nLFuldtid[s_,t] "Fuldtidsbeskæftigelse"

    nSoegBase[t] "Sum af jobsøgende og beskæftigede fra udenlandske og danske husholdninger."

    hLHh[a_,t]$(aTot[a_] and t.val >= %BFR_t1%) "Aldersfordelt arbejdstid, Kilde: FMs Befolkningsregnskab."
    hL[s_,t]$(sTot[s_] or spTot[s_] or sByTot[s_]) "Erlagte arbejdstimer fordelt på brancher, Kilde: ADAM[hq] eller ADAM[hq<i>]"
    hLSelvst[s_,t]$(s[s_] or sTot[s_]) "Erlagte arbejdstimer for selvstændige fordelt på brancher, Kilde: Residualt fra hL og hLLoenmodtager"
    hLLoenmodtager[s_,t]$(s[s_] or sTot[s_]) "Erlagte arbejdstimer for lønmodtagere fordelt på brancher, Kilde: ADAM[Hqw] eller ADAM[Qw<i>]*ADAM[Hgw<i>]"
    hLxDK[t] "Samlede erlagte arbejdstimer for grænsearbejdere."

    rJobFinding[a_,t]$(aTot[a_]) "Andel af jobsøgende som får et job."
    rMatch[t] "Andel af jobopslag, som resulterer i et match."
    nOpslag[s_,t] "Samlet antal jobopslag."
    rOpslagOmk[s_,t] "Andel af arbejdskraft som anvendes til hyrings-omkostninger."
    rSoeg2Opslag[t] "Labor market tightness (nSoeg / nOpslag)."

    nL[s_,t] "Beskæftigelse fordelt på brancher, Kilde: ADAM[Q] eller ADAM[Q<i>]"
    nLSelvst[s_,t]$(s[s_] or sTot[s_]) "Beskæftigede selvstændige fordelt på brancher, Kilde: ADAM[Qs] eller ADAM[Qs<i>]"
    nLLoenmodtager[s_,t]$(s[s_] or sTot[s_]) "Beskæftigede lønmodtagere fordelt på brancher, Kilde: ADAM[Qw] eller ADAM[Qw<i>]"
    nPop[a_,t]$(not a[a_] and t.val > 1991) "Befolkningen op til 100 år."
    nPopInklOver100[t]$(t.val >= %BFR_t1%) "Befolkningen inkl. personer over 100 år. Kilde: BFR eller ADAM[U]."
    nSoc[soc,t]$(t.val >= %BFR_t1%) "Befolkning fordelt på socio-grupper, antal 1.000 personer, Kilde: BFR."
    nBruttoLedig[t]$(t.val >= %BFR_t1%) "Bruttoledige. Antal 1.000 personer. Kilde: ADAM[Ulb]"
    nBruttoArbsty[t]$(t.val >= %BFR_t1%) "Brutto-arbejdsstyrke inkl. grænsearbejdere. Antal 1.000 personer."
    nNettoLedig[t]$(t.val >= %BFR_t1%) "Nettoledige. Antal 1.000 personer. Kilede: ADAM[Ul]"
    nNettoArbsty[t]$(t.val >= %BFR_t1%) "Netto-arbejdsstyrke inkl. grænsearbejdere. Antal 1.000 personer. Kilde: ADAM[Ua]"
    rBruttoLedig[t]$(t.val >= %BFR_t1%) "Bruttoledighedsrate."
    rBruttoLedigGab[t]$(t.val >= %BFR_t1%) "Gab i bruttoledighedsrate."
    rNettoLedig[t]$(t.val >= %BFR_t1%) "Nettoledighedsrate."
    rNettoLedigGab[t]$(t.val >= %BFR_t1%) "Gab i nettoledighedsrate."
    rLoenkvote[s_,t] "Sektorfordelt lønkvote"
    hLSelvst2hL[s_,t]$(sTot[s_]) "Selvstændiges andel af erlagte timer."
    nLSelvst2nL[s_,t]$(sTot[s_]) "Selvstændiges andel af beskæftigelse."

    nL_inklOrlov[s_,t]$(s[s_] or sTot[s_] or spTot[s_] or sByTot[s_]) "Beskæftigede i alt inkl. orlov fordelt på brancher, Kilde: ADAM[Qb1] eller ADAM[Qb<i>]."
    nOrlov[s_,t]$(sp[s_] or sTot[s_] or spTot[s_] or sByTot[s_]) "Personer som er midlertidigt fraværende fra beskæftigelse, Kilde: ADAM[Qm] eller ADAM[Qm<i>]."
    jnOrlov[s_,t]$(spTot[s_]) "j-led"

    tL[s_,t]$(s[s_] or spTot[s_]) "Nettosats for afgifter og subsidier på arbejdskraft inklusiv selvstændige (betalt af arbejdsgiver)"

    rProdVaekst[t] "Vækstrate for i qProd (Produktivitetsindeks for Harrod-neutral vækst på tværs af brancher)"
    dWTraeghed[t] "Hjælpevariabel til beregning af effekt fra løntræghed."
    rWTraeghed[t] "Hjælpevariabel til beregning af løntræghed."
    rOpslagOmkSqr[s_,t]$(s[s_]) "Hjælpevariabel til beregning af kvadratiske omkostninger ved jobopslag."

    fpL_spTot[t] "Korrektionsfaktor, der fanger både sammensætningseffekter og effekter fra ansættelsesomkostninger"
  ;
  $GROUP G_labor_market_endo G_labor_market_endo$(tx0[t]) ; # Restrict endo group to tx0[t]

  $GROUP G_labor_market_prices
    G_labor_market_prices_endo
  ;

  $GROUP G_labor_market_quantities
    G_labor_market_quantities_endo

    qProdHh_a[a,t] "Alders-specifikt led i qProdHh."
    qProdHh_t[t] "Tids-afhængigt led i qProdHh."
    qProdxDK[t] "Grænsearbejderes produktivitet."
  ;

  $GROUP G_labor_market_values
    G_labor_market_values_endo
  ;
  $GROUP G_labor_market_exogenous_forecast
    nPop
    rSeparation$(a[a_])
    qProdHh_a
    rAKULedig[t] "AKU-ledighedsrate. Sæsonkorrigeret arbejdsmarkedstilknytning. Kilde: ADAM[bulaku]."
    nPop_Over100[t] "Befolkningen over 100 år."
    nSoegBasexDK[t] "Sum af grænsearbejdere og jobsøgende potentielle grænsearbejdere."
    uDeltag[a,t] "Præferenceparameter for arbejdsstyrke-deltagelse."
    uh[a,t] "Præferenceparameter for timer."
    ADAM_BFR[ADAM_BFR_LIST,t] "ADAM-variable overført direkte i samme enhed som i ADAM ikke vækst- og inflationskorrigeret"
  ;

  $GROUP G_labor_market_forecast_as_zero
    jrJobFinding[a,t]

    jnSoc[soc,t] "J-led."
    jhLHh_a[a,t] "J-led i timebeslutning."
    jhLHh_t[t] "J-led i timebeslutning."
    jrJobFinding_t[t] "J-led"
    jpW[t] "J-led"
    jnSoegxDK[t] "J-led"
    jhL2nLxDK[t] "J-led"
    juProd[s_,t] "J-led"
    jrWTraeghed[t] "J-led"
    jrOpslagOmkSqr[s_,t] "J-led"
    juDeltag_t[t] "J-led"
  ;
  $GROUP G_labor_market_ARIMA_forecast
    hLSelvst2hL[s_,t]$(s[s_])
    uProd[s_,t] "Parameter til at styre branchespecifik produktivitet for arbejdskraft."
  ;
  $GROUP G_labor_market_constants
    eDeltag "Parameter, som styrer elasticiteten på arbejdsstyrke-deltagelse, fra ændringer i matching-raten."
    emrKomp "Parameter, som styrer elasticiteten på arbejdsstyrke-deltagelse, fra ændringer i kompensationsgrad."
    eMatching "Eksponent i matching funktion."
    eh           "Invers arbejdsudbudselasticitet - intensiv margin."

    uMatchOmk     "Lineær omkostning pr. jobmatch."
    uMatchOmkSqr "Kvadratisk omkostning ved jobopslag."

    uWTraeghed "Parameter for Rotemberg-træghed i lønforhandling."
    rFFLoenAlternativ "Forhandlingsalternativ (outside option) for fagforening i lønforhandling."

    rhL2nFuldtid[t] "Arbejdstid pr. fuldtidsperson."
  ;
  $GROUP G_labor_market_fixed_forecast
    hL2nL0[s,t] "Parameter som styrer branchespecifik arbejdstid."
    jnOrlov[s_,t]$(sp[s_])
    nOrlov[s_,t]$(off[s_])

    fDiskpL[sp,t] "Eksogent diskonteringsfaktor i efterspørgsel efter arbejdskraft."
    fDiskDeltag[a,t] "Eksogent diskonteringsfaktor i deltagelsesbeslutning."
    mrKomp[a_,t] "Marginal netto-kompensationsgrad."

    uhLxDK[t] "Faktor som korrigerer for forskel i gennemsnitlig arbejdstid mellem grænsearbejdere og danskboende beskæftigede."

    rAMDisk[t] "Eksogen diskonterings-rate for parter i lønforhandling."

    nOrlovRest[t] "Personer i større arbejdsmarkedskonflikter mv."

    uhWIndustri[t] "Skalaparameter som styrer forhold mellem industriløn og løn i fremstillingsbranchen."
    uhW_DA[t] "Skalaparameter som styrer forhold mellem DA-løn og gennemsnitlig løn."
    uOpslagOmk[t]    "Lineær omkostning pr. jobopslag."
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================

$IF %stage% == "equations":
  $BLOCK B_labor_market_static$(tx0[t])
    # ----------------------------------------------------------------------------------------------------------------------
    # Aggregation
    # ----------------------------------------------------------------------------------------------------------------------
    E_hL_tot[t].. hL[sTot,t] =E= hLHh[atot,t] + hLxDK[t];

    # Den faktiske arbejdstid følger det strukturelle
    E_hLHh_tot_via_jhLHh[t]$(t.val >= %BFR_t1%).. hLHh[aTot,t] =E= shLHh[aTot,t] + jhLHh[t];

    E_hLxDK[t].. hLxDK[t] =E= nLxDK[t] * hL2nLxDK[t];

    E_hL2nLxDK[t].. hL2nLxDK[t] =E= uhLxDK[t] * hLHh[aTot,t] / nLHh[aTot,t] + jhL2nLxDK[t];

    E_hL2nL_sTot[t].. hL[sTot,t] =E= hL2nL[sTot,t] * nL[sTot,t];
    E_nL[s,t].. hL[s,t] =E= hL2nL[s,t] * nL[s,t];

    E_nLFuldtid[s,t].. nLFuldtid[s,t] * rhL2nFuldtid[t] =E= hL[s,t];
    E_nLFuldtid_sTot[t].. nLFuldtid[sTot,t] * rhL2nFuldtid[t] =E= hL[sTot,t];
    E_nLFuldtid_spTot[t].. nLFuldtid[spTot,t] * rhL2nFuldtid[t] =E= hL[spTot,t];
    E_nLFuldtid_sByTot[t].. nLFuldtid[sByTot,t] * rhL2nFuldtid[t] =E= hL[sByTot,t];

    # Vi antager at forskelle i arbejdstid mellem brancher skyldes selektion og følger individerne ved brancheskift
    E_hL2nL[s,t].. hL2nL[s,t] * sum(ss, hL2nL0[ss,t] * nL[ss,t]) =E= hL2nL0[s,t] * hL[sTot,t];

    E_qProd_sTot[t].. qProd[sTot,t] * hL[sTot,t] =E= qProdHh[aTot,t] * hLHh[aTot,t] + qProdxDK[t] * hLxDK[t];
    E_qProd_spTot[t].. qProd[sTot,t] * hL[sTot,t] =E= qProd[spTot,t] * hL[spTot,t] + qProd["off",t] * hL["off",t];
    E_qProd_sByTot[t]..  qProd[sByTot,t] * hL[sByTot,t] =E= sum(sBy, qProd[sBy,t] * hL[sBy,t]);

    E_rProdVaekst[t].. rProdVaekst[t] =E= qProd[sTot,t] / (qProd[sTot,t-1]/fq) - 1;

    E_nL_tot[t].. nL[sTot,t] =E= nLHh[aTot,t] + nLxDK[t];

    E_nOpslag_tot[t].. nOpslag[sTot,t] =E= sum(s, nOpslag[s,t]);

    # Privat-sektor aggregater
    E_nL_spTot[t].. nL[spTot,t] =E= sum(sp, nL[sp,t]);
    E_nL_sByTot[t].. nL[sByTot,t] =E= sum(sBy, nL[sBy,t]);
    E_hL_spTot[t].. hL[spTot,t] =E= sum(sp, hL[sp,t]);
    E_hL_sByTot[t].. hL[sByTot,t] =E= sum(sBy, hL[sBy,t]);
    E_hL2nL_spTot[t].. hL[spTot,t] =E= hL2nL[spTot,t] * nL[spTot,t];

    # Lønsum til husholdninger og udlandskarbejdskraft
    E_vWHh_tot_via_qProdHh[t].. vWHh[aTot,t] =E= pW[t] * qProdHh[aTot,t] * hLHh[aTot,t];
    E_vWxDK[t].. vWxDK[t] =E= pW[t] * qProdxDK[t] * hLxDK[t];

    # ----------------------------------------------------------------------------------------------------------------------
    # Search and Matching        
    # ----------------------------------------------------------------------------------------------------------------------
    E_rMatch[t]..
      rMatch[t] =E= rJobFinding[aTot,t] * rSoeg2Opslag[t];

    E_rJobFinding_aTot[t]..
      rJobFinding[aTot,t] =E= (1 + rSoeg2Opslag[t]**(1/eMatching))**(-eMatching) + jrJobFinding[aTot,t];

    E_rSoeg2Opslag[t].. rSoeg2Opslag[t] * nOpslag[sTot,t] =E= nSoegHh[aTot,t] + nSoegxDK[t];

    E_nLHh_tot[t]..
      nLHh[aTot,t] =E= (1-rSeparation[aTot,t]) * nLHh[aTot,t-1] + rJobFinding[aTot,t] * nSoegHh[aTot,t];
    E_nSoegHh_tot[t]..
      nSoegBaseHh[aTot,t] =E= nLHh[aTot,t] + (1 - rJobFinding[aTot,t]) * nSoegHh[aTot,t];

    E_nLxDK[t].. nLxDK[t] =E= (1-rSeparation[aTot,t]) * nLxDK[t-1] + rJobFinding[aTot,t] * nSoegxDK[t]; 
    E_nSoegxDK[t].. nSoegxDK[t] =E= nSoegBasexDK[t] - (1-rSeparation[aTot,t]) * nLxDK[t-1] + jnSoegxDK[t];

    E_nOpslag[s,t]..
      nL[s,t] =E= (1-rSeparation[aTot,t]) * nL[s,t-1] + rMatch[t] * nOpslag[s,t];

    # ----------------------------------------------------------------------------------------------------------------------
    # Branche-fordelte lønninger
    # ----------------------------------------------------------------------------------------------------------------------
    # Vi antager at forskellige i timeløn mellem brancher skyldes selektion og følger individerne ved brancheskift
    E_qProd_sp[sp,t].. qProd[sp,t] =E= (uProd[sp,t] + juProd[sp,t]) * qProd[spTot,t] * hL[spTot,t]
                                     / sum(ssp, (uProd[ssp,t] + juProd[ssp,t]) * hL[ssp,t]);
    E_qProd_off[t].. qProd['off',t] =E= (uProd['off',t] + juProd['off',t]) * sqProd[sTot,t];

    # Erlagte timer og lønudbetaling til selvstændige
    E_hLSelvst[s,t].. hLSelvst[s,t] =E= hLSelvst2hL[s,t] * hL[s,t];
    E_hLSelvst_via_hLSelvst2hL_sTot[t].. hLSelvst[sTot,t] =E= hLSelvst2hL[sTot,t] * hL[sTot,t];
    E_hLSelvst_sTot[t].. hLSelvst[sTot,t] =E= sum(s, hLSelvst[s,t]);

    E_vSelvstLoen[s,t].. vSelvstLoen[s,t] =E= pW[t] * qProd[s,t] * hLSelvst[s,t];
    E_vSelvstLoen_sTot[t].. vSelvstLoen[sTot,t] =E= sum(s, vSelvstLoen[s,t]);
    E_vSelvstLoen_spTot[t].. vSelvstLoen[spTot,t] =E= sum(sp, vSelvstLoen[sp,t]);

    # Lønsum eksklusiv selvstændige
    E_hLLoenmodtager[s,t].. hLLoenmodtager[s,t] =E= (1 - hLSelvst2hL[s,t]) * hL[s,t];
    E_hLLoenmodtager_sTot[t].. hLLoenmodtager[sTot,t] =E= (1 - hLSelvst2hL[sTot,t]) * hL[sTot,t];

    E_vLoensum[s,t].. vLoensum[s,t] =E= pW[t] * qProd[s,t] * hLLoenmodtager[s,t];
    E_vLoensum_sTot[t].. vLoensum[sTot,t] =E= sum(s, vLoensum[s,t]);
    E_vLoensum_spTot[t].. vLoensum[spTot,t] =E= sum(sp, vLoensum[sp,t]);
    E_vLoensum_sByTot[t].. vLoensum[sByTot,t] =E= sum(sBy, vLoensum[sBy,t]);

    E_rLoenkvote[s,t].. rLoenkvote[s,t] =E= vLoensum[s,t] / vBVT[s,t];
    E_rLoenkvote_sTot[t].. rLoenkvote[sTot,t] =E= vLoensum[sTot,t] / vBVT[sTot,t];
    E_rLoenkvote_spTot[t].. rLoenkvote[spTot,t] =E= vLoensum[spTot,t] / vBVT[spTot,t];
    E_rLoenkvote_sByTot[t].. rLoenkvote[sByTot,t] =E= vLoensum[sByTot,t] / vBVT[sByTot,t];

    # Nettosats for afgifter og subsidier på arbejdskraft inklusiv selvstændige (betalt af arbejdsgiver)
    E_tL[s,t].. tL[s,t] =E= vtNetLoenAfg[s,t] / (vLoensum[s,t] + vSelvstLoen[s,t]);

    E_tL_spTot[t].. tL[spTot,t] =E= vtNetLoenAfg[spTot,t] / (vLoensum[spTot,t] + vSelvstLoen[spTot,t]);

    # ----------------------------------------------------------------------------------------------------------------------
    # Wages
    # ----------------------------------------------------------------------------------------------------------------------
    E_vhWIndustri[t].. vhWIndustri[t] =E= uhWIndustri[t] * pW[t] * qProd['fre',t];
    E_vhW[t].. vhW[t] =E= pW[t] * qProd[sTot,t];
    E_vhW_DA[t].. vhW_DA[t] =E= uhW_DA[t] * pW[t] * qProd[spTot,t];

    # ----------------------------------------------------------------------------------------------------------------------
    # Socio-grupper og aggregater herfra
    # ----------------------------------------------------------------------------------------------------------------------
    # Socio-grupper følger udvikling i beskæftigelsen (jf. BFR2GDX.gms) og en residual som følger befolkningen
    E_nSoc[soc,t]$(t.val >= %BFR_t1%)..
      nSoc[soc,t] =E= snSoc[soc,t] + dSoc2dBesk[soc,t] * (nLHh[aTot,t] - snLHh[aTot,t]) + jnSoc[soc,t];

    # Aggregater fra socio-grupper
    E_nBruttoLedig[t]$(t.val >= %BFR_t1%).. nBruttoLedig[t] =E= sum(BruttoLedig, nSoc[BruttoLedig,t]);
    E_nNettoLedig[t]$(t.val >= %BFR_t1%).. nNettoLedig[t] =E= sum(NettoLedig, nSoc[NettoLedig,t]);
    E_nBruttoArbsty[t]$(t.val >= %BFR_t1%).. nBruttoArbsty[t] =E= sum(BruttoArbsty, nSoc[BruttoArbsty,t]) + nLxDK[t];
    E_nNettoArbsty[t]$(t.val >= %BFR_t1%).. nNettoArbsty[t] =E= sum(NettoArbsty, nSoc[NettoArbsty,t]) + nLxDK[t];

    E_nPop_tot[t]$(t.val > 1991)..    nPop[aTot,t]     =E= sum(a, nPop[a,t]);
    E_nPop_a15t100[t]$(t.val > 1991).. nPop['a15t100',t] =E= sum(a$a15t100[a], nPop[a,t]);
    E_nPop_a0t17[t]$(t.val > 1991)..   nPop['a0t17',t]   =E= sum(a$a0t17[a], nPop[a,t]);
    E_nPop_a18t100[t]$(t.val > 1991).. nPop['a18t100',t] =E= sum(a$a18t100[a], nPop[a,t]);

    E_rBruttoLedig[t]$(t.val >= %BFR_t1%)..  rBruttoLedig[t] =E= nBruttoLedig[t] / nBruttoArbsty[t];
    E_rBruttoLedigGab[t]$(t.val >= %BFR_t1%).. rBruttoLedigGab[t] =E= rBruttoLedig[t] - srBruttoLedig[t];
    E_rNettoLedig[t]$(t.val >= %BFR_t1%)..  rNettoLedig[t] =E= nNettoledig[t] / nNettoArbsty[t];
    E_rNettoLedigGab[t]$(t.val >= %BFR_t1%).. rNettoLedigGab[t] =E= rNettoLedig[t] - srNettoLedig[t];

    E_nSoegBase[t].. nSoegBase[t] =E= nSoegBaseHh[aTot,t] + nSoegBasexDK[t];
    
    # ----------------------------------------------------------------------------------------------------------------------
    # Beskæftigelse inkl. orlov
    # ----------------------------------------------------------------------------------------------------------------------     
    E_nOrlov_sTot[t].. nOrlov[sTot,t] =E= nSoc['orlov',t] + nSoc['beskbarsel',t] + nSoc['besksyge',t] + nOrlovRest[t];
    E_nOrlov_spTot[t].. nOrlov[spTot,t] =E= nOrlov[sTot,t] - nOrlov['off',t];
    E_nOrlov_sByTot[t].. nOrlov[sByTot,t] =E= sum(sBy, nOrlov[sBy,t]);

    E_nOrlov[sp,t].. nOrlov[sp,t] =E= nL[sp,t] / nL[spTot,t] * (nOrlov[spTot,t] - jnOrlov[spTot,t]) + jnOrlov[sp,t];

    # snOrlov[spTot,t] er normalt 0 ellers korrigerer det for indlagte j-led som ikke summerer
    E_jnOrlov_spTot[t].. jnOrlov[spTot,t] =E= sum(sp, jnOrlov[sp,t]);

    E_nL_inklOrlov[s_,t]$((s[s_] or sTot[s_] or spTot[s_] or sByTot[s_])).. nL_inklOrlov[s_,t] =E= nL[s_,t] + nOrlov[s_,t];

    # ----------------------------------------------------------------------------------------------------------------------
    # Befolkningen inkl. personer over 100 år (disse er ikke en del af modellen, men indgår for at kunne sammenligne med eksterne totaler.)
    # ----------------------------------------------------------------------------------------------------------------------     
    E_nPopInklOver100[t]$(t.val >= %BFR_t1%).. nPopInklOver100[t] =E= nPop[aTot,t] + nPop_Over100[t];

    # ----------------------------------------------------------------------------------------------------------------------
    # Lønmodtagere og selvstændige - tabelvariable
    # ----------------------------------------------------------------------------------------------------------------------     
    # Man kan rykke i andelen af selvstændige, men man rykker ikke i egenskaberne, da den gennemsnitlige arbejdstid er upåvirket
    E_nLSelvst[s,t].. nLSelvst[s,t] =E= nLSelvst2nL[s,t] * nL[s,t];
    E_nLSelvst_via_nLSelvst2nL_sTot[t].. nLSelvst[sTot,t] =E= nLSelvst2nL[sTot,t] * nL[sTot,t];
    E_nLSelvst_sTot[t].. nLSelvst[sTot,t] =E= sum(s, nLSelvst[s,t]);

    E_nLLoenmodtager[s,t].. nLLoenmodtager[s,t] =E= (1 - nLSelvst2nL[s,t]) * nL[s,t];
    E_nLLoenmodtager_sTot[t].. nLLoenmodtager[sTot,t] =E= (1 - nLSelvst2nL[sTot,t]) * nL[sTot,t];
$ENDBLOCK

$BLOCK B_labor_market_forwardlooking$(tx0[t])
    # ----------------------------------------------------------------------------------------------------------------------
    # Firm FOC. and Vacancy Costs - hele denne del har alene til formål at bestemme pL
    # ----------------------------------------------------------------------------------------------------------------------                                    
    # Dynamiske ligninger for pL
    E_pL[sp,t]$(tx0E[t])..
      pL[sp,t] =E= pW[t] * (1 + tL[sp,t]) * qProd[sp,t] * hL2nL[sp,t]
                 / (dqL2dnL[sp,t] + (1-mtVirk[sp,t+1])/(1-mtVirk[sp,t]) * fDiskpL[sp,t+1] * dqL2dnLlag[sp,t+1]*fq);

    E_pL_spTot[t]..
      pL[spTot,t] =E= fpL_spTot[t] * pW[t] * (1 + tL[spTot,t]);

    E_fpL_spTot[t].. pL[spTot,t] * qL[spTot,t] =E= sum(sp, pL[sp,t] * qL[sp,t]);

    E_pL_tEnd[sp,t]$(tEnd[t])..
      pL[sp,t] =E= pW[t] * (1 + tL[sp,t]) * qProd[sp,t] * hL2nL[sp,t]
                 / (dqL2dnL[sp,t] + (1-mtVirk[sp,t])/(1-mtVirk[sp,t]) * fDiskpL[sp,t] * dqL2dnLlag[sp,t]*fq);

    # Hjælpevariable til pL
    E_dqL2dnL[sp,t]..
      dqL2dnL[sp,t] =E= qProd[sp,t] * hL2nL[sp,t] * (1 - dOpslagOmk2dnL[sp,t]);

    E_dqL2dnLlag[sp,t]..
      dqL2dnLlag[sp,t] =E= - qProd[sp,t] * hL2nL[sp,t] * dOpslagOmk2dnLLag[sp,t];

    E_dOpslagOmk2dnL[sp,t]..
      dOpslagOmk2dnL[sp,t] =E= uOpslagOmk[t] / rMatch[t]
                             + uMatchOmkSqr/2 * sqr(rOpslagOmkSqr[sp,t] - 1)
                             + uMatchOmkSqr * rOpslagOmkSqr[sp,t] * (rOpslagOmkSqr[sp,t] - 1)
                             + uMatchOmk;

    E_rOpslagOmkSqr[s,t]..
      rOpslagOmkSqr[s,t] =E= nL[s,t] / nL[s,t-1] / (nL[s,t-1] / nL[s,t-2]) + jrOpslagOmkSqr[s,t];

    E_dOpslagOmk2dnLLag[sp,t]..
      dOpslagOmk2dnLLag[sp,t] =E= - (1-rSeparation[aTot,t]) * (uOpslagOmk[t] / rMatch[t] + uMatchOmk)
                                  - 2 * uMatchOmkSqr * nL[sp,t] / nL[sp,t-1] * rOpslagOmkSqr[sp,t] * (rOpslagOmkSqr[sp,t] - 1);

    # ----------------------------------------------------------------------------------------------------------------------
    # Wage Bargaining - hele denne del har alene til formål at bestemme pW
    # ----------------------------------------------------------------------------------------------------------------------
    # Dynamisk ligning for pW
    E_pW[t]$(tx0E[t])..
      pW[t] =E= (1-rLoenNash[t]) * vVirkLoenPos[t] / (-dvVirk2dpW[t])
              + rLoenNash[t] * vFFOutsideOption[t] / dFF2dLoen[t]
              - dWTraeghed[t] + 2 * dWTraeghed[t+1] / (1+rAMDisk[t+1])
              + jpW[t];

    E_pW_tEnd[t]$(tEnd[t])..
      pW[t] =E= (1-rLoenNash[t]) * vVirkLoenPos[t] / (-dvVirk2dpW[t])
              + rLoenNash[t] * vFFOutsideOption[t] / dFF2dLoen[t]
              + jpW[t];

    # Hjælpevariable til pW
    E_vVirkLoenPos[t]..
      vVirkLoenPos[t] =E= sum(sp, (1-mtVirk[sp,t]) * pL[sp,t] * hL[sp,t] * qProd[sp,t]);

    E_dvVirk2dpW[t]..
      dvVirk2dpW[t] =E= - sum(sp, (1-mtVirk[sp,t]) * (1 + tL[sp,t]) * hL[sp,t] * qProd[sp,t] * (1-rOpslagOmk[sp,t]));

    E_dWTraeghed[t].. 
      dWTraeghed[t] =E= uWTraeghed * (rWTraeghed[t] - 1) * rWTraeghed[t];

    E_rWTraeghed[t].. rWTraeghed[t] =E= pW[t]/pW[t-1] / (pW[t-1]/pW[t-2]) + jrWTraeghed[t];

    E_vFFOutsideOption[t]$(t.val > %AgeData_t1%)..
      vFFOutsideOption[t] =E= rFFLoenAlternativ * dFF2dLoen[t] * rJobFinding[aTot,t] * pW[t];

    E_rOpslagOmk[s,t]..
      rOpslagOmk[s,t] * nL[s,t] =E= uOpslagOmk[t] * nOpslag[s,t]
                                  + uMatchOmk * rMatch[t] * nOpslag[s,t]
                                  + uMatchOmkSqr/2 * nL[s,t] * sqr(rOpslagOmkSqr[s,t] - 1);

    E_rOpslagOmk_tot[t]..
      rOpslagOmk[sTot,t] * nL[sTot,t] =E= sum(s, rOpslagOmk[s,t] * nL[s,t]);

    E_rOpslagOmk_spTot[t]..
      rOpslagOmk[spTot,t] * nL[spTot,t] =E= sum(sp, rOpslagOmk[sp,t] * nL[sp,t]);

    E_rOpslagOmk_sByTot[t].. rOpslagOmk[sByTot,t] * nL[sByTot,t] =E= sum(sBy, rOpslagOmk[sBy,t] * nL[sBy,t]);
  $ENDBLOCK

  $BLOCK B_labor_market_a$(tx0[t])
    # ----------------------------------------------------------------------------------------------------------------------
    # Various Aggregates and Income Terms 
    # ----------------------------------------------------------------------------------------------------------------------
    # Wage payment pr. person by age
    E_vWHh[a,t]$(a15t100[a] and t.val > %AgeData_t1%).. 
      vWHh[a,t] =E= pW[t] * qProdHh[a,t] * hLHh[a,t] * nLHh[a,t] / nPop[a,t];

    # Wage total                   
    E_vWHh_tot[t]$(t.val > %AgeData_t1%).. vWHh[aTot,t] =E= sum(a, vWHh[a,t] * nPop[a,t]);
    E_qProdHh[a,t]$(t.val > %AgeData_t1% and a15t100[a]).. qProdHh[a,t] =E= qProdHh_t[t] * qProdHh_a[a,t];

    # ----------------------------------------------------------------------------------------------------------------------
    # Household First-order Conditions
    # ----------------------------------------------------------------------------------------------------------------------
    E_nSoegBaseHh_aTot[t]$(t.val > %AgeData_t1%).. nSoegBaseHh[aTot,t] =E= sum(a, nSoegBaseHh[a,t]);

    E_nSoegBaseHh[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      nSoegBaseHh[a,t] =E= rSoegBaseHh[a,t] * nPop[a,t] * fSoegBaseHh[a,t];

    E_rSoegBaseHh[a,t]$(tx0E[t] and a15t100[a] and a.val < 100 and t.val > %AgeData_t1%)..
      ((uDeltag[a,t]+juDeltag_t[t]) / (1 - rSoegBaseHh[a,t]))**eDeltag =E= rJobFinding[a,t] * (
          (1 - mrKomp[a,t])**(eDeltag/emrKomp)
        + rOverlev[a,t] * (1-rSeparation[a+1,t+1]) * fDiskDeltag[a+1,t+1]
        * (1/rJobFinding[a+1,t+1] - 1)
        * ((uDeltag[a+1,t+1]+juDeltag_t[t+1]) / (1 - rSoegBaseHh[a+1,t+1]))**eDeltag
      );

    # Terminal condition for last period 
    E_rSoegBaseHh_tEnd[a,t]$(tEnd[t] and a15t100[a] and a.val < 100 and t.val > %AgeData_t1%)..
      ((uDeltag[a,t]+juDeltag_t[t]) / (1 - rSoegBaseHh[a,t]))**eDeltag =E= rJobFinding[a,t] * (
          (1 - mrKomp[a,t])**(eDeltag/emrKomp)
        + rOverlev[a,t] * (1-rSeparation[a+1,t]) * fDiskDeltag[a+1,t]
        * (1/rJobFinding[a+1,t] - 1)
        * (uDeltag[a+1,t] / (1 - rSoegBaseHh[a+1,t]))**eDeltag
      );

    # Terminal condition for last age group
    E_rSoegBaseHh_aEnd[a,t]$(a.val = 100 and t.val > %AgeData_t1%)..
      ((uDeltag[a,t]+juDeltag_t[t]) / (1 - rSoegBaseHh[a,t]))**eDeltag =E= rJobFinding[a,t] * (
          (1 - mrKomp[a,t])**(eDeltag/emrKomp)
          # Ingen sandsynlighed for at beholde job til næste periode
      );

    # Den faktiske arbejdstid følger det strukturelle
    E_hLHh[a,t]$(a15t100[a] and t.val > %AgeData_t1%).. hLHh[a,t] =E= shLHh[a,t] + jhLHh_a[a,t] + jhLHh_t[t];

    E_hLHh_tot[t]$(t.val >= %BFR_t1%).. hLHh[atot,t] =E= sum(a, hLHh[a,t] * nLHh[a,t]);

    # ----------------------------------------------------------------------------------------------------------------------
    # Search and Matching        
    # ----------------------------------------------------------------------------------------------------------------------
    E_rJobFinding[a,t]$(a15t100[a])..
      rJobFinding[a,t] =E= rJobFinding[aTot,t] - jrJobFinding[aTot,t] + jrJobFinding[a,t] + jrJobFinding_t[t];

    E_jrJobFinding_aTot[t]$(t.val > %AgeData_t1%)..
      rJobFinding[aTot,t] * nSoegHh[aTot,t] =E= sum(a$(a15t100[a]), rJobFinding[a,t] * nSoegHh[a,t]);

    E_rSeparation_tot[t]$(t.val > %AgeData_t1%)..
      nSoegHh[aTot,t] =E= sum(a$(a15t100[a]), nSoegHh[a,t]);

    E_nLHh[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      nLHh[a,t] =E= (1-rSeparation[a,t]) * nLHh[a-1,t-1] * nPop[a,t]/nPop[a-1,t-1] + rJobFinding[a,t] * nSoegHh[a,t];

    E_nSoegHh[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      nSoegBaseHh[a,t] =E= nLHh[a,t] + (1-rJobFinding[a,t]) * nSoegHh[a,t];

    # ----------------------------------------------------------------------------------------------------------------------
    # Wage Bargaining and Calvo Rigidity
    # ----------------------------------------------------------------------------------------------------------------------
    E_dFF2dLoen[t]$(t.val > %AgeData_t1%)..
      dFF2dLoen[t] =E= sum(a, (1-mtInd[a,t]) * nLHh[a,t] * qProdHh[a,t] * hLHh[a,t]);
  $ENDBLOCK

  MODEL M_labor_market / 
    B_labor_market_static
    B_labor_market_forwardlooking
    B_labor_market_a
  /;

  $GROUP G_labor_market_static
    G_labor_market_endo
    -G_Labor_market_endo_a # Påvirker alene aldersfordelte størrelser
    -vWHh$(aTot[a_]) # vWHh[aTot,t] fastsættes til en rimelig størrelse og E_vWHh_tot bestemmer pW

    -vVirkLoenPos, -dWTraeghed, -vFFOutsideOption, -dvVirk2dpW # Bliver bestemt i hjælpe-ligninger til E_pW
    -rOpslagOmk # Hjælpeligning til E_pW og ligninger som er slået fra i i production_private
    -pL$(sp[s_]) # Kan ikke fastsættes statisk alle relevante ligninger inkl. i production_private slået fra
    -dqL2dnL, -dqL2dnLlag, -dOpslagOmk2dnL, -dOpslagOmk2dnLLag # Bliver bestemt i hjælpeligninger til E_pL
  ;
  $GROUP G_labor_market_static G_labor_market_static$(tx0[t]);
$ENDIF

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
$IF %stage% == "exogenous_values":
# ======================================================================================================================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_labor_market_makrobk
    nL[s], nL[sTot], hL[s], hL[sTot], vWxDK
    hLSelvst[s], hLSelvst[sTot], nLSelvst[s], nLSelvst[sTot]
    vWHh[aTot]
    vhW_DA, vhWIndustri, vhW, vSelvstLoen[s], vSelvstLoen[sTot], vLoensum[s], vLoensum[sTot]
    nOrlov, rAKULedig
    nNettoLedig, nBruttoLedig, nNettoArbsty, nSoc[socFraMAKROBK]
    nPopInklOver100$(t.val < %BFR_t1%) # Hentes først ind før BFR_t1, da BFR ikke rammer befolkning fra MAKROBK
    ADAM_BFR
  ;
  @load(G_labor_market_makrobk, "..\Data\makrobk\makrobk.gdx" )

  # Aldersfordelt data fra aldersprofiler indlæses
  $GROUP G_labor_market_aldersprofiler
    vWHh$(a[a_] and t.val >= %AgeData_t1%)
  ;
  @load(G_labor_market_aldersprofiler, "..\Data\Aldersprofiler\aldersprofiler.gdx" )

  # Aldersfordelt data fra BFR indlæses
  $GROUP G_labor_market_BFR
    nPop, nSoc$(not socFraMAKROBK[soc]), nPop_Over100
    nLHh, hLHh, nLxDK, hLxDK,
    rSeparation,
    mrKomp,
  ;
  @load(G_labor_market_BFR, "..\Data\Befolkningsregnskab\BFR.gdx" )
  
  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_labor_market_data
    G_labor_market_makrobk
    G_labor_market_BFR
    -mrKomp # Ændres ved smoothing
    nSoegBaseHh[aTot]
    -rSeparation # vi skal ved lejlighed tjekke hvorfor denne ikke går godt!
  ; 
  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_labor_market_data_imprecise
    nNettoLedig
    nBruttoLedig
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  eMatching.l = 1.152468; # Matching parameter
  rFFLoenAlternativ.l = 0.076305; # Matching parameter

  eDeltag.l = 2;
  eh.l = 10;
  emrKomp.l = 10;
  uWTraeghed.l = 2.677472; # Matching parameter

  uOpslagOmk.l[t] = 0.02;
  uMatchOmk.l = 0.0;
  uMatchOmkSqr.l = 0.70113; # Matching parameter

  rhL2nFuldtid.l[t] = 222 * 7.4 / 1000; # 222 dage * 7.4 timer pr. dag, enhed=1000 timer

# ======================================================================================================================
# Data assignment
# ======================================================================================================================
  nSoegBaseHh.l[aTot,t] = nNettoArbsty.l[t]; # Vi kalibrere nSoegBaseHh til at matche nNettoArbsty i dataår

  # --------------------------------------------------------------------------------------------------------------------
  # Wages and productivity
  # --------------------------------------------------------------------------------------------------------------------
  rProdVaekst.l[t] = gq;
  qProdHh_t.l[t] = 1; # Beregningere kan rykkes til kalibrering, men kræver særbehandling af pW[t1-2] mv.
  loop(t$(qProdHh_t.l[t-1] <> 0),
    qProdHh_t.l[t] = qProdHh_t.l[t-1] * (1 + rProdVaekst.l[t]);
  );
  qProdHh_t.l[t] = qProdHh_t.l[t] / qProdHh_t.l[tBase] * vhW.l[tBase];
  qProd.l[sTot,t] = qProdHh_t.l[t];
  pW.l[t]$(qProdHh_t.l[t] > 0) = vhW.l[t] / qProdHh_t.l[t];
 
  # --------------------------------------------------------------------------------------------------------------------
  # LABOR MARKET DEMOGRAPHICS
  # --------------------------------------------------------------------------------------------------------------------
  nLHh.l[aTot,t]$(t.val < %BFR_t1%) = nL.l[sTot,t] / nL.l[sTot,'%BFR_t1%'] * nLHh.l[aTot,'%BFR_t1%'];  # Outside BFR years, we set use ADAM data for the number of employed persons, but level shifted to match BFR in year 2001.
  hLHh.l[aTot,t]$(t.val < %BFR_t1%) = hL.l[sTot,t] / hL.l[sTot,'%BFR_t1%'] * hLHh.l[aTot,'%BFR_t1%'];  # Outside BFR years, we set use ADAM data for the number hours worked, but level shifted to match BFR in year 2001.
  nLxdk.l[t]$(t.val < %BFR_t1%) = nL.l[sTot,t] / nL.l[sTot,'%BFR_t1%'] * nLxdk.l['%BFR_t1%'];  # Outside BFR years, we set use ADAM data for the number of employed persons, but level shifted to match BFR in year 2001.
  hLxdk.l[t]$(t.val < %BFR_t1%) = hL.l[sTot,t] / hL.l[sTot,'%BFR_t1%'] * hLxdk.l['%BFR_t1%'];  # Outside BFR years, we set use ADAM data for the number hours worked, but level shifted to match BFR in year 2001.
$ENDIF


# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_labor_market_static_calibration
    G_labor_market_endo

    # Lønindkomst til husholdinger og produktivitet
    -vWHh[aTot,t]$(t.val <= %AgeData_t1%), qProdHh[aTot,t]$(t.val <= %AgeData_t1%)
    -pW, rLoenNash

    # Branchespecifik løn, arbejdstid, og ansættelsesomkostninger
    -vLoensum[s,t], uProd[s,t] # E_uProd, -E_qProd_sp
    -nL[s,t], hL2nL0 # E_hL2nL0, -E_hL2nL
    jrOpslagOmkSqr # E_rOpslagOmkSqr_via_jrOpslagOmkSqr

    # Diskonteringsfaktorer mv., som vi holder eksogent ved stød
    fDiskpL[sp,t] # E_fDiskpL
    rAMDisk[t] # E_rAMDISK

    # Grænsearbejdere
    -vWxDK, qProdxDK
    # Residuale gab til strukturel niveau rammes med j-led
    -nLxDK, nSoegBasexDK
    -hLxDK, jhL2nLxDK

    # Sociogrupper
    -nSoc[soc,t], jnSoc[soc,t]$(t.val >= %BFR_t1%)
    -nOrlov[sTot,t], nOrlovRest
    -nOrlov[sp,t]$(not tje[s_]), jnOrlov[sp,t]$(not tje[s_])

    # Øvrige detaljer
    -vhWIndustri, uhWIndustri
    -vhW_DA, uhW_DA

    # Selvstændige og lønmodtagere
    -hLSelvst[s,t], hLSelvst2hL[s,t]
    -nLSelvst[s,t], nLSelvst2nL[s,t]

    -vWHh[a15t100,t], qProdHh_a[a15t100,t]
    -nLHh[a,t] # -E_rSoegBaseHh, E_rSoegBaseHh_tEnd, E_rSoegBaseHh_aEnd
    -hLHh[a,t], jhLHh_a[a,t]
  ;

  $GROUP G_labor_market_static_calibration
    G_labor_market_static_calibration$(tx0[t])
  ;

  $BLOCK B_labor_market_static_calibration$(tx0[t])
    # Branchespecifik løn, arbejdstid, og ansættelsesomkostninger
    E_uProd[sp,t].. uProd[sp,t] =E= qProd[sp,t] / qProd[sTot,t];
    E_hL2nL0[s,t].. hL2nL0[s,t] =E= hL2nL[s,t];

    E_rOpslagOmkSqr_via_jrOpslagOmkSqr[s,t].. rOpslagOmkSqr[s,t] =E= 1;

    # Diskonteringsfaktorer mv., som vi holder eksogent ved stød
    E_fDiskpL[sp,t]$(tx1[t]).. fDiskpL[sp,t] =E= fVirkDisk[sp,t] * pL[sp,t] / (pL[sp,t-1]/fp);
    E_rAMDISK[t]..
      rAMDisk[t] * sum(sp, hL[sp,t] * qProd[sp,t]) =E= sum(sp, hL[sp,t] * qProd[sp,t] * rVirkDisk[sp,t]);

    # Identisk med E_pL_tEnd
    # på nær at vi erstatter fDiskpL[sp,t] med fVirkDisk[sp,t]*fp
    # og forventet kvadratisk omstillings-omkostning fjernes i dOpslagOmk2dnLLag
    E_pL_static[sp,t]..
      pL[sp,t] =E= pW[t] * (1 + tL[sp,t]) * qProd[sp,t] * hL2nL[sp,t]
                 / (dqL2dnL[sp,t] + (1-mtVirk[sp,t])/(1-mtVirk[sp,t]) * fVirkDisk[sp,t]*fp * dqL2dnLlag[sp,t]*fq);

    # Lønforhandling
    E_pW_static[t]..
      pW[t] =E= (1-rLoenNash[t]) * vVirkLoenPos[t] / (-dvVirk2dpW[t])
              + rLoenNash[t] * rFFLoenAlternativ * rJobFinding[aTot,t] * pW[t]
              + jpW[t];
  $ENDBLOCK
  MODEL M_labor_market_static_calibration /
    M_labor_market 
    B_labor_market_static_calibration
    -E_hL2nL # E_hL2nL0
    -E_qProd_sp # E_uProd
    -E_pL -E_pL_tEnd # E_pL_static
    -E_pW -E_pW_tEnd # E_pW_static
    -E_rSoegBaseHh - E_rSoegBaseHh_aEnd - E_rSoegBaseHh_tEnd
  /;

  $GROUP G_labor_market_static_calibration_newdata
    G_labor_market_static_calibration
    -qProdHh_a
  ;

$ENDIF


# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_labor_market_deep
    G_labor_market_endo

    # I dataår rammes aldersfordelt beskæftigelse via disnytte ved deltagelse. Se struk.gms for fremskivning
    -nLHh[a15t100,t1], uDeltag[a15t100,t1]

    -pW[t1], jpW[t1]

    fDiskDeltag[a,t] # E_fDiskDeltag_deep
    rAMDisk[t] # E_rAMDISK
    fDiskpL[sp,t] # E_fDiskpL

    -rProdVaekst, qProdHh_t # Vi sætter samlet produktivitetsvækst direkte og ser dermed bort fra sammensætningseffekter fra demografi
    qProdxDK[tx1] # E_qProdxDK

    nLSelvst2nL[s,tx1]$(nLSelvst2nL.l[s,t1] > 0) # E_nLSelvst2nL_forecast
  ;
  $GROUP G_labor_market_deep G_labor_market_deep$(tx0[t]);

  $BLOCK B_labor_market_deep
    E_fDiskDeltag_deep[a,t]$(tx0E[t] and a15t100[a] and a.val < 100 and t.val > %AgeData_t1%)..
      fDiskDeltag[a+1,t+1] =E= fDisk[a,t]
                             * (mUC['R',a+1,t+1] * pW[t+1] * qProdHh[a+1,t+1] * hLHh[a+1,t+1] / pC['Cx',t+1] * fhLHh[a+1,t+1] * fq)
                             / (mUC['R',a,t] * pW[t] * qProdHh[a,t] * hLHh[a,t] / pC[cTot,t] * (1-fhLHh[a+1,t+1]));

    # Grænsearbejderes produktivitet antages at følge danske husholdningers
    E_qProdxDK[t]$(tx1[t]).. qProdxDK[t] / qProdxDK[t-1] =E= qProd[sTot,t] / qProd[sTot,t-1];

    @copy_equation_to_period(E_fDiskpL, tx0)

    # Vi antager at andelen af selvstændige i beskæftigelsen følger andelen af erlagte timer
    E_nLSelvst2nL_forecast[s,t]$(tx1[t] and nLSelvst2nL.l[s,t1] > 0)..
      nLSelvst2nL[s,t] / nLSelvst2nL[s,t1] =E= hLSelvst2hL[s,t] / hLSelvst2hL[s,t1];
  $ENDBLOCK
  MODEL M_labor_market_deep /
    M_labor_market
    B_labor_market_deep
    E_rAMDISK
  /;
$ENDIF
 
# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
  $GROUP G_labor_market_dynamic_calibration
    G_labor_market_endo

    # Vi har BFR som (eneste aldersfordelte) kilde i foreløbige år - derfor kan beskæftigelse eksogeniseres
    -nLHh[a15t100,t1], uDeltag[a15t100,t1]

    -vhW[t1], jpW[t1]

    -rProdVaekst, qProdHh_t # Vi sætter samlet produktivitetsvækst direkte og ser dermed bort fra sammensætningseffekter fra demografi

    qProdxDK[tx1] # E_qProdxDK
    uhWIndustri[tx1] # E_uhWIndustri
    uhW_DA[tx1] # E_uhW_DA

    # Vi ser bort fra løntræghed i foreløbige dataår
    # Derved fortolkes fx høje lønstigninger i sidste data-år ikke således at lønnen ville være steget endnu mere i fravær af træghed,
    # og derved skal stige yderligere fremadrettet
    jrWTraeghed[t1] # E_jrWTraeghed_t1
  ;
  $BLOCK B_labor_market_dynamic_calibration
    E_uhWIndustri[t]$(tx1[t]).. uhWIndustri[t] =E= uhWIndustri[t1];
    E_uhW_DA[t]$(tx1[t]).. uhW_DA[t] =E= uhW_DA[t1];
    E_qProdxDK[t]$(tx1[t]).. qProdxDK[t] / qProdxDK[t-1] =E= qProd[sTot,t] / qProd[sTot,t-1];
    E_jrWTraeghed_t1[t]$(t1[t]).. rWTraeghed[t] =E= 1;
  $ENDBLOCK
  MODEL M_labor_market_dynamic_calibration /
    M_labor_market
    B_labor_market_dynamic_calibration
  /;
$ENDIF