# ======================================================================================================================
# Labor market
# - labor force participation, job searching and matching, and wage bargaining
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_labor_market_variables
    pL[s_,t] "User cost for effektiv arbejdskraft i produktionsfunktion."
    pW[t] "Løn pr. produktiv enhed arbejdskraft."

    vhWIndustri[t] "Gennemsnitlig timeløn i industrien. Kilde: ADAM[lna]"
    vhW_DA[t] "Gennemsnitlig timeløn for lønmodtagere ekskl. genetillæg, DA-området. Kilde: ADAM[lnda]"
    vhW[t] "Gennemsnitlig timeløn."
    vWxDK[t] "Lønsum til grænsearbejdere."

    vSelvstLoen[s_,t] "Lønudbetaling til selvstændige."
    vLoensum[s_,t] "Lønsum, Kilde: ADAM[Yw]"

    vFFOutsideOption[t] "Fagforenings forhandlingsalterntiv i lønforhandling."

    hL2nL[s_,t] "Arbejdstid pr. beskæftiget"
    fhL[t] "Balancerings-faktor, som sikrer at arbejdstid matcher fra branche-side og arbejdsudbudsside (aldersfordelt + grænsearbejdere)"
    dOpslagOmk2dnL[sp,t] "rOpslagOmk * nL differentieret ift. nL."
    dOpslagOmk2dnLLag[sp,t] "rOpslagOmk * nL differentieret ift. nL[t-1]"

    nLHh[a_,t] "Beskæftigelse."
    nSoegHh[a_,t] "Jobsøgende."

    nLxDK[t] "Grænsearbejdere i antal hoveder - inkluderer pt. sort arbejde."
    nSoegxDK[t] "Jobsøgende potentielle grænsearbejdere."

    nLFuldtid[s_,t] "Fuldtidsbeskæftigelse"

    hLHh[a_,t] "Aldersfordelt arbejdstid, Kilde: FMs Befolkningsregnskab."
    hL[s_,t] "Erlagte arbejdstimer fordelt på brancher, Kilde: ADAM[hq] eller ADAM[hq<i>]"
    hLSelvst[s_,t] "Erlagte arbejdstimer for selvstændige fordelt på brancher, Kilde: Residualt fra hL og hLLoenmodtager"
    hLLoenmodtager[s_,t] "Erlagte arbejdstimer for lønmodtagere fordelt på brancher, Kilde: ADAM[Hqw] eller ADAM[Qw<i>]*ADAM[Hgw<i>]"
    hLxDK[t] "Samlede erlagte arbejdstimer for grænsearbejdere."

    rJobFinding[a_,t] "Andel af jobsøgende som får et job."
    rMatch[t] "Andel af jobopslag, som resulterer i et match."
    nOpslag[s_,t] "Samlet antal jobopslag."
    rOpslagOmk[s_,t] "Andel af arbejdskraft som anvendes til hyrings-omkostninger."
    rSoeg2Opslag[t] "Labor market tightness (nSoeg / nOpslag)."

    nL[s_,t] "Beskæftigelse fordelt på brancher, Kilde: ADAM[Q] eller ADAM[Q<i>]"
    nLSelvst[s_,t] "Beskæftigede selvstændige fordelt på brancher, Kilde: ADAM[Qs] eller ADAM[Qs<i>]"
    nLLoenmodtager[s_,t] "Beskæftigede lønmodtagere fordelt på brancher, Kilde: ADAM[Qw] eller ADAM[Qw<i>]"
    nPop[a_,t] "Befolningstotaler"
    nPopInklOver100[t] "Befolkningen inkl. personer over 100 år. Kilde: BFR eller ADAM[U]."
    nSoc[soc,t] "Befolkning fordelt på socio-grupper, antal 1.000 personer, Kilde: BFR."
    nBruttoLedig[t] "Bruttoledige. Antal 1.000 personer. Kilde: ADAM[Ulb]"
    nBruttoArbsty[t] "Brutto-arbejdsstyrke inkl. grænsearbejdere. Antal 1.000 personer."
    nNettoLedig[t] "Nettoledige. Antal 1.000 personer. Kilede: ADAM[Ul]"
    nNettoArbsty[t] "Netto-arbejdsstyrke inkl. grænsearbejdere. Antal 1.000 personer. Kilde: ADAM[Ua]"
    rBruttoLedig[t] "Bruttoledighedsrate."
    rBruttoLedigGab[t] "Gab i bruttoledighedsrate."
    rNettoLedig[t] "Nettoledighedsrate."
    rNettoLedigGab[t] "Gab i nettoledighedsrate."
    rLoenkvote[s_,t] "Sektorfordelt lønkvote"
    hLSelvst2hL[s_,t] "Selvstændiges andel af erlagte timer."
    nLSelvst2nL[s_,t] "Selvstændiges andel af beskæftigelse."

    nL_inklOrlov[s_,t] "Beskæftigede i alt inkl. orlov fordelt på brancher, Kilde: ADAM[Qb1] eller ADAM[Qb<i>]."
    nOrlov[s_,t] "Personer som er midlertidigt fraværende fra beskæftigelse, Kilde: ADAM[Qm] eller ADAM[Qm<i>]."

    tL[s_,t] "Nettosats for afgifter og subsidier på arbejdskraft inklusiv selvstændige (betalt af arbejdsgiver)"

    rProdVaekst[t] "Vækstrate for i qProd (Produktivitetsindeks for Harrod-neutral vækst på tværs af brancher)"
    dWTraeghed[t] "Hjælpevariabel til beregning af effekt fra løntræghed."
    rWTraeghed[t] "Hjælpevariabel til beregning af løntræghed."
    rOpslagOmkSqr[s_,t] "Hjælpevariabel til beregning af kvadratiske omkostninger ved jobopslag."

    qProdHh[a_,t] "Aldersfordelt produktivitet."

    vWHh[a_,t] "Årsløn pr. person."
    vWHh[aTot,t] "Årsløn pr. person."

    nSoegBaseHh[a_,t] "Sum af jobsøgende og beskæftigede."
    rSoegBaseHh[a_,t] "Sum af jobsøgende og beskæftigede som andel af befolkning."
    rSeparation[a_,t] "Job-separations-rate."
    jhLHh[t] "J-led i timebeslutning."
    dFF2dLoen[t] "Fagforeningens værdifunktion i lønforhandling differentieret ift. løn."
  ;

  $GROUP G_labor_market_exogenous_forecast
    nPop[a_,t]
    rSeparation$(a[a_])
    qProdHh_a[a,t]$(t.val > %AgeData_t1% and a15t100[a]) "Alders-specifikt led i qProdHh."
    qProdHh_t[t] "Tids-afhængigt led i qProdHh."
    qProdxDK[t] "Grænsearbejderes produktivitet."
    rAKULedig[t] "AKU-ledighedsrate. Sæsonkorrigeret arbejdsmarkedstilknytning. Kilde: ADAM[bulaku]."
    nPop_Over100[t] "Befolkningen over 100 år."
    nSoegBasexDK[t] "Sum af grænsearbejdere og jobsøgende potentielle grænsearbejdere."
    uDeltag[a,t] "Præferenceparameter for arbejdsstyrke-deltagelse."
    uh[a,t] "Præferenceparameter for timer."
  ;
  $GROUP+ G_exogenous_forecast G_labor_market_exogenous_forecast$(tx1[t]);

  $GROUP G_labor_market_forecast_as_zero
    jrJobFinding[a_,t] "J-led"
    jnSoc[soc,t] "J-led."
    jhLHh_a[a,t] "J-led i timebeslutning."
    jhLHh_t[t] "J-led i timebeslutning."
    jrJobFinding_t[t] "J-led"
    jpW[t] "J-led"
    juhLxDK[t] "J-led"
    jrWTraeghed[t] "J-led"
    jrOpslagOmkSqr[s_,t] "J-led"
    juDeltag_t[t] "J-led"
    jnSoegBaseHh[a_,t] "J-led"
  ;
  $GROUP+ G_forecast_as_zero G_labor_market_forecast_as_zero$(tx1[t]);

  $GROUP G_labor_market_ARIMA_forecast
    hLSelvst2hL[s_,t]$(s[s_])
    rLoenNash[t] "Nash-forhandlingsvægt (arbejdsgiveres forhandlingsstyrke)."
  ;
  $GROUP+ G_ARIMA_forecast G_labor_market_ARIMA_forecast;

  $GROUP G_labor_market_constants
    eDeltag "Parameter, som styrer elasticiteten på arbejdsstyrke-deltagelse, fra ændringer i matching-raten."
    emrKomp "Parameter, som styrer elasticiteten på arbejdsstyrke-deltagelse, fra ændringer i kompensationsgrad."
    eMatching "Eksponent i matching funktion."
    eh "Invers arbejdsudbudselasticitet - intensiv margin."

    uMatchOmk "Lineær omkostning pr. jobmatch."
    uMatchOmkSqr "Kvadratisk omkostning ved jobopslag."

    uWTraeghed "Parameter for Rotemberg-træghed i lønforhandling."
    rFFLoenAlternativ "Forhandlingsalternativ (outside option) for fagforening i lønforhandling."
  ;
  $GROUP+ G_constants G_labor_market_constants;

  $GROUP G_labor_market_fixed_forecast
    hL2nL0[s,t] "Parameter som styrer branchespecifik arbejdstid."
    jfnOrlov[s_,t]$(sp[s_]) "J-led"
    nOrlov[s_,t]$(off[s_])

    fDiskDeltag[a,t] "Eksogent diskonteringsfaktor i deltagelsesbeslutning."
    mrKomp[a_,t] "Marginal netto-kompensationsgrad."

    uhLxDK[t] "Faktor som korrigerer for forskel i gennemsnitlig arbejdstid mellem grænsearbejdere og danskboende beskæftigede."

    nOrlovRest[t] "Personer i større arbejdsmarkedskonflikter mv."

    uhWIndustri[t] "Skalaparameter som styrer forhold mellem industriløn og løn i fremstillingsbranchen."
    uhW_DA[t] "Skalaparameter som styrer forhold mellem DA-løn og gennemsnitlig løn."
    uOpslagOmk[t] "Lineær omkostning pr. jobopslag."
    rhL2nFuldtid[t] "Aftalt arbejdstid pr. fuldtidsperson."

    fqProd[s_,t] "Parameter til at styre branchespecifik produktivitet for arbejdskraft."
    qProd[s_,t] "Branchespecifikt produktivitetsindeks for arbejdskraft."
  ;
  $GROUP+ G_fixed_forecast G_labor_market_fixed_forecast;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================

$IF %stage% == "equations":
  $BLOCK B_labor_market_static G_labor_market_static $(tx0[t])
    # ----------------------------------------------------------------------------------------------------------------------
    # Aggregation
    # ----------------------------------------------------------------------------------------------------------------------
    .. hL[sTot,t] =E= hLHh[atot,t] + hLxDK[t];

    # Den faktiske arbejdstid følger det strukturelle
    jhLHh[t]$(t.val >= %BFR_t1%).. hLHh[aTot,t] =E= shLHh[aTot,t] + jhLHh[t];

    .. hLxDK[t] / nLxDK[t] =E= (uhLxDK[t] + juhLxDK[t]) * hLHh[aTot,t] / nLHh[aTot,t];

    hL2nL[sTot,t].. hL[sTot,t] =E= hL2nL[sTot,t] * nL[sTot,t];
    nL[s,t].. hL[s,t] =E= hL2nL[s,t] * nL[s,t];
    # Vi antager at forskelle i arbejdstid mellem brancher skyldes selektion og følger individerne ved brancheskift
    .. hL2nL[s,t] =E= fhL[t] * hL2nL0[s,t];
    fhL[t]$(tForecast[t]).. hL[sTot,t] =E= sum(s, hL[s,t]);

    .. nLFuldtid[s,t] * rhL2nFuldtid[t] =E= hL[s,t];
    .. nLFuldtid[sTot,t] * rhL2nFuldtid[t] =E= hL[sTot,t];
    .. nLFuldtid[spTot,t] * rhL2nFuldtid[t] =E= hL[spTot,t];
    .. nLFuldtid[sByTot,t] * rhL2nFuldtid[t] =E= hL[sByTot,t];
    
    .. qProd[sTot,t] * hL[sTot,t] =E= qProdHh[aTot,t] * hLHh[aTot,t] + qProdxDK[t] * hLxDK[t];
    qProd[spTot,t].. qProd[sTot,t] * hL[sTot,t] =E= qProd[spTot,t] * hL[spTot,t] + qProd["off",t] * hL["off",t];
    .. qProd[sByTot,t] * hL[sByTot,t] =E= sum(sBy, qProd[sBy,t] * hL[sBy,t]);

    .. rProdVaekst[t] =E= qProd[sTot,t] / (qProd[sTot,t-1]/fq) - 1;

    .. nL[sTot,t] =E= nLHh[aTot,t] + nLxDK[t];

    # Privat-sektor aggregater
    .. nL[spTot,t] =E= sum(sp, nL[sp,t]);
    .. nL[sByTot,t] =E= sum(sBy, nL[sBy,t]);
    .. hL[spTot,t] =E= sum(sp, hL[sp,t]);
    .. hL[sByTot,t] =E= sum(sBy, hL[sBy,t]);
    .. hL2nL[spTot,t] =E= hL[spTot,t] / nL[spTot,t];

    # Lønsum til husholdninger og udenlandsk arbejdskraft
    qProdHh[aTot,t].. vWHh[aTot,t] =E= pW[t] * qProdHh[aTot,t] * hLHh[aTot,t];
    .. vWxDK[t] =E= pW[t] * qProdxDK[t] * hLxDK[t];

    # ----------------------------------------------------------------------------------------------------------------------
    # Search and Matching        
    # ----------------------------------------------------------------------------------------------------------------------
    .. rMatch[t] =E= rJobFinding[aTot,t] * rSoeg2Opslag[t];

    .. rJobFinding[aTot,t] =E= (1 + rSoeg2Opslag[t]**(1/eMatching))**(-eMatching) + jrJobFinding[aTot,t];

    .. rSoeg2Opslag[t] * nOpslag[sTot,t] =E= nSoegHh[aTot,t] + nSoegxDK[t];

    .. nLHh[aTot,t] =E= (1-rSeparation[aTot,t]) * nLHh[aTot,t-1] + rJobFinding[aTot,t] * nSoegHh[aTot,t];
    nSoegHh[aTot,t].. nSoegBaseHh[aTot,t] =E= nLHh[aTot,t] + (1 - rJobFinding[aTot,t]) * nSoegHh[aTot,t];

    .. nLxDK[t] =E= (1-rSeparation[aTot,t]) * nLxDK[t-1] + rJobFinding[aTot,t] * nSoegxDK[t]; 
    nSoegxDK[t].. nSoegBasexDK[t] =E= nLxDK[t] + (1 - rJobFinding[aTot,t]) * nSoegxDK[t];

    nOpslag[sTot,t].. nOpslag[sTot,t] =E= sum(s, nOpslag[s,t]);
    nOpslag[s,t].. nL[s,t] =E= (1-rSeparation[aTot,t]) * nL[s,t-1] + rMatch[t] * nOpslag[s,t];

    # ----------------------------------------------------------------------------------------------------------------------
    # Branche-fordelte lønninger
    # ----------------------------------------------------------------------------------------------------------------------
    # Vi antager at forskellige i timeløn mellem brancher skyldes selektion og følger individerne ved brancheskift
    .. qProd[sp,t] =E= fqProd[spTot,t] * fqProd[sp,t] * qProd[spTot,t];
    fqProd[spTot,t]$(tForecast[t]).. qProd[spTot,t] * hL[spTot,t] =E= sum(sp, qProd[sp,t] * hL[sp,t]);

    # Erlagte timer og lønudbetaling til selvstændige
    .. hLSelvst[s,t] =E= hLSelvst2hL[s,t] * hL[s,t];
    hLSelvst2hL[sTot,t].. hLSelvst[sTot,t] =E= hLSelvst2hL[sTot,t] * hL[sTot,t];
    .. hLSelvst[sTot,t] =E= sum(s, hLSelvst[s,t]);

    .. vSelvstLoen[s,t] =E= pW[t] * qProd[s,t] * hLSelvst[s,t];
    .. vSelvstLoen[sTot,t] =E= sum(s, vSelvstLoen[s,t]);
    .. vSelvstLoen[spTot,t] =E= sum(sp, vSelvstLoen[sp,t]);

    # Lønsum eksklusiv selvstændige
    .. hLLoenmodtager[s,t] =E= (1 - hLSelvst2hL[s,t]) * hL[s,t];
    .. hLLoenmodtager[sTot,t] =E= (1 - hLSelvst2hL[sTot,t]) * hL[sTot,t];

    .. vLoensum[s,t] =E= pW[t] * qProd[s,t] * hLLoenmodtager[s,t];
    .. vLoensum[sTot,t] =E= sum(s, vLoensum[s,t]);
    .. vLoensum[spTot,t] =E= sum(sp, vLoensum[sp,t]);
    .. vLoensum[sByTot,t] =E= sum(sBy, vLoensum[sBy,t]);

    .. rLoenkvote[s,t] =E= vLoensum[s,t] / vBVT[s,t];
    .. rLoenkvote[sTot,t] =E= vLoensum[sTot,t] / vBVT[sTot,t];
    .. rLoenkvote[spTot,t] =E= vLoensum[spTot,t] / vBVT[spTot,t];
    .. rLoenkvote[sByTot,t] =E= vLoensum[sByTot,t] / vBVT[sByTot,t];

    # Nettosats for afgifter og subsidier på arbejdskraft inklusiv selvstændige (betalt af arbejdsgiver)
    .. tL[s,t] =E= vtNetLoenAfg[s,t] / (vLoensum[s,t] + vSelvstLoen[s,t]);

    .. tL[spTot,t] =E= vtNetLoenAfg[spTot,t] / (vLoensum[spTot,t] + vSelvstLoen[spTot,t]);
  
    # ----------------------------------------------------------------------------------------------------------------------
    # Wages
    # ----------------------------------------------------------------------------------------------------------------------
    .. vhWIndustri[t] =E= uhWIndustri[t] * pW[t] * qProd['fre',t];
    .. vhW[t] =E= pW[t] * qProd[sTot,t];
    .. vhW_DA[t] =E= uhW_DA[t] * pW[t] * qProd[spTot,t];

    # ----------------------------------------------------------------------------------------------------------------------
    # Socio-grupper og aggregater herfra
    # ----------------------------------------------------------------------------------------------------------------------
    # Socio-grupper følger udvikling i beskæftigelsen (jf. BFR2GDX.gms) og en residual som følger befolkningen
    $(t.val >= %BFR_t1%)..
      nSoc[soc,t] =E= snSoc[soc,t] + dSoc2dBesk[soc,t] * (nLHh[aTot,t] - snLHh[aTot,t]) + jnSoc[soc,t];

    # Aggregater fra socio-grupper
    $(t.val >= %BFR_t1%).. nBruttoLedig[t] =E= sum(BruttoLedig, nSoc[BruttoLedig,t]);
    $(t.val >= %BFR_t1%).. nNettoLedig[t] =E= sum(NettoLedig, nSoc[NettoLedig,t]);
    $(t.val >= %BFR_t1%).. nBruttoArbsty[t] =E= sum(BruttoArbsty, nSoc[BruttoArbsty,t]) + nLxDK[t];
    $(t.val >= %BFR_t1%).. nNettoArbsty[t] =E= sum(NettoArbsty, nSoc[NettoArbsty,t]) + nLxDK[t];

    $(t.val > 1991).. nPop[aTot,t] =E= sum(a, nPop[a,t]);

    nPop['a15t100',t]$(t.val > 1991).. nPop['a15t100',t] =E= sum(a$a15t100[a], nPop[a,t]);
    nPop['a0t17',t]$(t.val > 1991)..   nPop['a0t17',t]   =E= sum(a$a0t17[a], nPop[a,t]);
    nPop['a18t100',t]$(t.val > 1991).. nPop['a18t100',t] =E= sum(a$a18t100[a], nPop[a,t]);

    $(t.val >= %BFR_t1%)..  rBruttoLedig[t] =E= nBruttoLedig[t] / nBruttoArbsty[t];
    $(t.val >= %BFR_t1%).. rBruttoLedigGab[t] =E= rBruttoLedig[t] - srBruttoLedig[t];
    $(t.val >= %BFR_t1%)..  rNettoLedig[t] =E= nNettoledig[t] / nNettoArbsty[t];
    $(t.val >= %BFR_t1%).. rNettoLedigGab[t] =E= rNettoLedig[t] - srNettoLedig[t];
    
    # ----------------------------------------------------------------------------------------------------------------------
    # Beskæftigelse inkl. orlov
    # ----------------------------------------------------------------------------------------------------------------------     
    .. nOrlov[sTot,t] =E= nSoc['orlov',t] + nSoc['beskbarsel',t] + nSoc['besksyge',t] + nOrlovRest[t];
    .. nOrlov[spTot,t] =E= nOrlov[sTot,t] - nOrlov['off',t];
    .. nOrlov[sByTot,t] =E= sum(sBy, nOrlov[sBy,t]);

    .. nOrlov[sp,t] =E= nL[sp,t] / nL[spTot,t] * nOrlov[spTot,t] * (1+jfnOrlov[spTot,t]+jfnOrlov[sp,t]);
   jfnOrlov[spTot,t]$(tForecast[t]).. nOrlov[spTot,t] =E= sum(sp, nOrlov[sp,t]);

    $((s[s_] or sTot[s_] or spTot[s_] or sByTot[s_])).. nL_inklOrlov[s_,t] =E= nL[s_,t] + nOrlov[s_,t];

    # ----------------------------------------------------------------------------------------------------------------------
    # Befolkningen inkl. personer over 100 år (disse er ikke en del af modellen, men indgår for at kunne sammenligne med eksterne totaler.)
    # ----------------------------------------------------------------------------------------------------------------------     
    $(t.val >= %BFR_t1%).. nPopInklOver100[t] =E= nPop[aTot,t] + nPop_Over100[t];

    # ----------------------------------------------------------------------------------------------------------------------
    # Lønmodtagere og selvstændige - tabelvariable
    # ----------------------------------------------------------------------------------------------------------------------     
    # Man kan rykke i andelen af selvstændige, men man rykker ikke i egenskaberne, da den gennemsnitlige arbejdstid er upåvirket
    .. nLSelvst[s,t] =E= nLSelvst2nL[s,t] * nL[s,t];
    nLSelvst2nL[sTot,t].. nLSelvst[sTot,t] =E= nLSelvst2nL[sTot,t] * nL[sTot,t];
    .. nLSelvst[sTot,t] =E= sum(s, nLSelvst[s,t]);

    .. nLLoenmodtager[s,t] =E= (1 - nLSelvst2nL[s,t]) * nL[s,t];
    .. nLLoenmodtager[sTot,t] =E= (1 - nLSelvst2nL[sTot,t]) * nL[sTot,t];

$ENDBLOCK


$BLOCK B_labor_market_forwardlooking G_labor_market_forwardlooking_endo $(tx0[t])

    # # ----------------------------------------------------------------------------------------------------------------------
    # # Firm FOC. and Vacancy Costs - hele denne del har alene til formål at bestemme pL
    # # ----------------------------------------------------------------------------------------------------------------------                                    
    # Dynamiske ligninger for pL
    $(tx0E[t])..
      pL[sp,t] =E= pW[t] * (1 + tL[sp,t])
                 / ((1 - dOpslagOmk2dnL[sp,t])
                    - (1-mtVirk[t+1])/(1-mtVirk[t]) * fVirkDisk[sp,t+1] * pL[sp,t+1]*fp/pL[sp,t] * qProd[sp,t+1]*fq/qProd[sp,t] * hL2nL[sp,t+1]/hL2nL[sp,t]
                    * dOpslagOmk2dnLLag[sp,t+1]);

    &_tEnd[sp,t]$(tEnd[t])..
      pL[sp,t] =E= pW[t] * (1 + tL[sp,t]) / ((1 - dOpslagOmk2dnL[sp,t]) - fVirkDisk[sp,t] * fp * fq * dOpslagOmk2dnLLag[sp,t]);

    .. pL[spTot,t] * qL[spTot,t] =E= sum(sp, pL[sp,t] * qL[sp,t]);

    .. dOpslagOmk2dnL[sp,t] =E= uOpslagOmk[t] / rMatch[t]
                             + uMatchOmkSqr/2 * sqr(rOpslagOmkSqr[sp,t] - 1)
                             + uMatchOmkSqr * rOpslagOmkSqr[sp,t] * (rOpslagOmkSqr[sp,t] - 1)
                             + uMatchOmk;

    .. rOpslagOmkSqr[s,t] =E= nL[s,t] / nL[s,t-1] / (nL[s,t-1] / nL[s,t-2]) + jrOpslagOmkSqr[s,t];

    .. dOpslagOmk2dnLLag[sp,t] =E= - (1-rSeparation[aTot,t]) * (uOpslagOmk[t] / rMatch[t] + uMatchOmk)
                                  - 2 * uMatchOmkSqr * nL[sp,t] / nL[sp,t-1] * rOpslagOmkSqr[sp,t] * (rOpslagOmkSqr[sp,t] - 1);

    # ----------------------------------------------------------------------------------------------------------------------
    # Wage Bargaining - hele denne del har alene til formål at bestemme pW
    # ----------------------------------------------------------------------------------------------------------------------
    # Dynamisk ligning for pW
    $(tx0E[t])..
      pW[t] =E= (1-rLoenNash[t]) * pL[spTot,t] / (1-rOpslagOmk[spTot,t]) / (1 + tL[spTot,t])
              + rLoenNash[t] * vFFOutsideOption[t] / dFF2dLoen[t]
              - dWTraeghed[t] + 2 * dWTraeghed[t+1] / fVirkDisk[spTot,t+1]
              + jpW[t];

    &_tEnd[t]$(tEnd[t])..
      pW[t] =E= (1-rLoenNash[t]) * pL[spTot,t] / (1-rOpslagOmk[spTot,t]) / (1 + tL[spTot,t])
              + rLoenNash[t] * vFFOutsideOption[t] / dFF2dLoen[t]
              + jpW[t];

    # Hjælpevariable til pW
    .. dWTraeghed[t] =E= uWTraeghed * (rWTraeghed[t] - 1) * rWTraeghed[t];

    .. rWTraeghed[t] =E= pW[t]/pW[t-1] / (pW[t-1]/pW[t-2]) + jrWTraeghed[t];

    $(t.val > %AgeData_t1%)..
      vFFOutsideOption[t] =E= rFFLoenAlternativ * dFF2dLoen[t] * rJobFinding[aTot,t] * pW[t];

    .. rOpslagOmk[s,t] * nL[s,t] =E= uOpslagOmk[t] * nOpslag[s,t]
                                  + uMatchOmk * rMatch[t] * nOpslag[s,t]
                                  + uMatchOmkSqr/2 * nL[s,t] * sqr(rOpslagOmkSqr[s,t] - 1);

    .. rOpslagOmk[sTot,t] * nL[sTot,t] =E= sum(s, rOpslagOmk[s,t] * nL[s,t]);
    .. rOpslagOmk[spTot,t] * nL[spTot,t] =E= sum(sp, rOpslagOmk[sp,t] * nL[sp,t]);
    .. rOpslagOmk[sByTot,t] * nL[sByTot,t] =E= sum(sBy, rOpslagOmk[sBy,t] * nL[sBy,t]);
  $ENDBLOCK

  $BLOCK B_labor_market_a G_labor_market_endo_a $(tx0[t])
    # ----------------------------------------------------------------------------------------------------------------------
    # Various Aggregates and Income Terms 
    # ----------------------------------------------------------------------------------------------------------------------
    # Wage payment pr. person by age
    $(a15t100[a] and t.val > %AgeData_t1%).. 
      vWHh[a,t] =E= pW[t] * qProdHh[a,t] * hLHh[a,t] * nLHh[a,t] / nPop[a,t];

    # Wage total                   
    $(t.val > %AgeData_t1%).. vWHh[aTot,t] =E= sum(a, vWHh[a,t] * nPop[a,t]);
    $(t.val > %AgeData_t1% and a15t100[a]).. qProdHh[a,t] =E= qProdHh_t[t] * qProdHh_a[a,t];

    # ----------------------------------------------------------------------------------------------------------------------
    # Household First-order Conditions
    # ----------------------------------------------------------------------------------------------------------------------
    $(t.val > %AgeData_t1%).. nSoegBaseHh[aTot,t] =E= sum(a, nSoegBaseHh[a,t]);

    $(a15t100[a] and t.val > %AgeData_t1%)..
      nSoegBaseHh[a,t] =E= rSoegBaseHh[a,t] * nPop[a,t] * fSoegBaseHh[a,t] + jnSoegBaseHh[a,t];

    $(t.val > %AgeData_t1%).. jnSoegBaseHh[aTot,t] =E= sum(a, jnSoegBaseHh[a,t]);

    rSoegBaseHh[a,t]$(tx0E[t] and a15t100[a] and aVal[a] < 100 and t.val > %AgeData_t1%)..
      ((uDeltag[a,t]+juDeltag_t[t]) / (1 - rSoegBaseHh[a,t]))**eDeltag =E= rJobFinding[a,t] * (
          (1 - mrKomp[a,t])**(eDeltag/emrKomp)
        + rOverlev[a,t] * (1-rSeparation[a+1,t+1]) * fDiskDeltag[a+1,t+1]
        * (1/rJobFinding[a+1,t+1] - 1)
        * ((uDeltag[a+1,t+1]+juDeltag_t[t+1]) / (1 - rSoegBaseHh[a+1,t+1]))**eDeltag
      );

    # Terminal condition for last period 
    rSoegBaseHh&_tEnd[a,t]$(tEnd[t] and a15t100[a] and aVal[a] < 100 and t.val > %AgeData_t1%)..
      ((uDeltag[a,t]+juDeltag_t[t]) / (1 - rSoegBaseHh[a,t]))**eDeltag =E= rJobFinding[a,t] * (
          (1 - mrKomp[a,t])**(eDeltag/emrKomp)
        + rOverlev[a,t] * (1-rSeparation[a+1,t]) * fDiskDeltag[a+1,t]
        * (1/rJobFinding[a+1,t] - 1)
        * (uDeltag[a+1,t] / (1 - rSoegBaseHh[a+1,t]))**eDeltag
      );

    # Terminal condition for last age group
    rSoegBaseHh&_aEnd[a,t]$(aVal[a] = 100 and t.val > %AgeData_t1%)..
      ((uDeltag[a,t]+juDeltag_t[t]) / (1 - rSoegBaseHh[a,t]))**eDeltag =E= rJobFinding[a,t] * (
          (1 - mrKomp[a,t])**(eDeltag/emrKomp)
          # Ingen sandsynlighed for at beholde job til næste periode
      );

    # Den faktiske arbejdstid følger det strukturelle
    $(a15t100[a] and t.val > %AgeData_t1%).. hLHh[a,t] =E= shLHh[a,t] + jhLHh_a[a,t] + jhLHh_t[t];

    $(t.val >= %BFR_t1%).. hLHh[atot,t] =E= sum(a$(a15t100[a]), hLHh[a,t] * nLHh[a,t]);

    # ----------------------------------------------------------------------------------------------------------------------
    # Search and Matching        
    # ----------------------------------------------------------------------------------------------------------------------
    $(a15t100[a])..
      rJobFinding[a,t] =E= rJobFinding[aTot,t] - jrJobFinding[aTot,t] + jrJobFinding[a,t] + jrJobFinding_t[t];

    jrJobFinding[aTot,t]$(t.val > %AgeData_t1%)..
      rJobFinding[aTot,t] * nSoegHh[aTot,t] =E= sum(a$(a15t100[a]), rJobFinding[a,t] * nSoegHh[a,t]);

    rSeparation[aTot,t]$(t.val > %AgeData_t1%).. nSoegHh[aTot,t] =E= sum(a$(a15t100[a]), nSoegHh[a,t]);

    $(a15t100[a] and t.val > %AgeData_t1%)..
      nLHh[a,t] =E= (1-rSeparation[a,t]) * nLHh[a-1,t-1] * nPop[a,t]/nPop[a-1,t-1] + rJobFinding[a,t] * nSoegHh[a,t];

    nSoegHh[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      nSoegBaseHh[a,t] =E= nLHh[a,t] + (1-rJobFinding[a,t]) * nSoegHh[a,t];

    # ----------------------------------------------------------------------------------------------------------------------
    # Wage Bargaining and Calvo Rigidity
    # ----------------------------------------------------------------------------------------------------------------------
    $(t.val > %AgeData_t1%)..
      dFF2dLoen[t] =E= sum(a$(a15t100[a]), (1-mtInd[a,t]) * nLHh[a,t] * qProdHh[a,t] * hLHh[a,t]);

  $ENDBLOCK


  MODEL M_labor_market / 
    B_labor_market_static 
    B_labor_market_forwardlooking
    B_labor_market_a  
  /;
  model M_base / M_labor_market /;

  $GROUP G_labor_market_endo G_labor_market_endo_a, G_labor_market_static, G_labor_market_forwardlooking_endo;

  $GROUP G_labor_market_static G_labor_market_static$(tx0[t]);
  model M_static / B_labor_market_static  /;
  $GROUP+ G_static G_labor_market_static  ;
  $GROUP+ G_Endo G_labor_market_endo;
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
    rhL2nFuldtid
  ;
  @load(G_labor_market_makrobk, "../Data/Makrobk/makrobk.gdx" )

  # Aldersfordelt data fra aldersprofiler indlæses
  $GROUP G_labor_market_aldersprofiler
    vWHh$(a[a_] and t.val >= %AgeData_t1%)
    rSeparation, mrKomp
  ;
  @load(G_labor_market_aldersprofiler, "../Data/Aldersprofiler/aldersprofiler.gdx" )

  # Aldersfordelt data fra BFR indlæses
  $GROUP G_labor_market_BFR
    nPop, nSoc$(not socFraMAKROBK[soc]), nPop_Over100
    nLHh, hLHh, nLxDK, hLxDK,
  ;
  @load(G_labor_market_BFR, "../Data/Befolkningsregnskab/BFR.gdx" )
  
  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_labor_market_data
    G_labor_market_makrobk
    G_labor_market_BFR
    -mrKomp # Ændres ved smoothing
    nSoegBaseHh[aTot,t]
    -rSeparation[aTot,t] # vi skal ved lejlighed tjekke hvorfor denne ikke går godt!
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

# ======================================================================================================================
# Data assignment
# ======================================================================================================================
  nSoegBaseHh.l[aTot,t] = nNettoArbsty.l[t] - nLxDK.l[t]; # Vi kalibrere nSoegBaseHh til at matche nNettoArbsty i dataår

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

  fqProd.l[spTot,t] = 1;
  fhL.l[t] = 1;

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

    # # Branchespecifik løn, arbejdstid, og ansættelsesomkostninger
    -vLoensum[sp,t], fqProd[sp,t]
    -vLoensum['off',t], qProd['off',t]
    -nL[s,t], hL2nL0[s,t]
    jrOpslagOmkSqr # E_rOpslagOmkSqr_via_jrOpslagOmkSqr

    # Grænsearbejdere
    -vWxDK, qProdxDK
    # Residuale gab til strukturel niveau rammes med j-led
    -nLxDK, nSoegBasexDK
    -hLxDK, juhLxDK

    # Sociogrupper
    -nSoc[soc,t], jnSoc[soc,t]$(t.val >= %BFR_t1%)
    -nOrlov[sTot,t], nOrlovRest
    -nOrlov[sp,t], jfnOrlov[sp,t]

    # Øvrige detaljer
    -vhWIndustri, uhWIndustri
    -vhW_DA, uhW_DA

    # Selvstændige og lønmodtagere
    -hLSelvst[s,t], hLSelvst2hL[s,t]
    -nLSelvst[s,t], nLSelvst2nL[s,t]

    -vWHh[a15t100,t], qProdHh_a[a,t]$(a15t100[a] and t.val > %AgeData_t1%)
    -nLHh[a,t] # -E_rSoegBaseHh, E_rSoegBaseHh_tEnd, E_rSoegBaseHh_aEnd
    -hLHh[a,t], jhLHh_a[a,t]
  ;

  $GROUP G_labor_market_static_calibration
    G_labor_market_static_calibration$(tx0[t])
  ;

  $BLOCK B_labor_market_static_calibration$(tx0[t])
    E_rOpslagOmkSqr_via_jrOpslagOmkSqr[s,t].. rOpslagOmkSqr[s,t] =E= 1;

    # Identisk med E_pL_tEnd
    E_pL_static[sp,t]..
      pL[sp,t] =E= pW[t] * (1 + tL[sp,t]) / ((1 - dOpslagOmk2dnL[sp,t]) - fVirkDisk[sp,t] * fp * fq * dOpslagOmk2dnLLag[sp,t]);

    # Lønforhandling
    E_pW_static[t]..
      pW[t] =E= (1-rLoenNash[t]) * pL[spTot,t] / (1-rOpslagOmk[spTot,t]) / (1 + tL[spTot,t])
              + rLoenNash[t] * rFFLoenAlternativ * rJobFinding[aTot,t] * pW[t]
              + jpW[t];
  $ENDBLOCK
  MODEL M_labor_market_static_calibration /
    M_labor_market
    B_labor_market_static_calibration
    -E_pL_sp -E_pL_tEnd # E_pL_static
    -E_pW -E_pW_tEnd # E_pW_static
    -E_rSoegBaseHh_a - E_rSoegBaseHh_aEnd - E_rSoegBaseHh_tEnd
  /;
  model M_static_calibration / M_labor_market_static_calibration /;
  $GROUP+ G_static_calibration G_labor_market_static_calibration;

  $GROUP G_labor_market_static_calibration_newdata
    G_labor_market_static_calibration
    -qProdHh_a[a,t]$(a15t100[a] and t.val > %AgeData_t1%)
    fqProd[spTot,t]
    jfnOrlov
    fhL
  ;
  $GROUP+ G_static_calibration_newdata G_labor_market_static_calibration_newdata;
$ENDIF


# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_labor_market_deep
    G_labor_market_endo

    -nLHh[a15t100,t1], uDeltag[a15t100,t1] # uDeltag fremskrives i struk.gms

    $IF2 %DREAM_baseline%:# Endogent beskæftigelsesgab gør at en række størrelser skal rekalibreres 
      -nSoc[soc,t1]$(not boern[soc]), snSoc[soc,t1]$(not boern[soc])
      -nSoegBaseHh[aTot,t1], jrJobFinding_t[t1]
    $ENDIF2

    -pW[t1], rLoenNash[t1] # rLoenNash fremskrives i struk.gms

    fDiskDeltag[a,t] # E_fDiskDeltag_deep

    -rProdVaekst, qProdHh_t # Vi sætter samlet produktivitetsvækst direkte og ser dermed bort fra sammensætningseffekter fra demografi
    qProdxDK[tx1] # E_qProdxDK

    nLSelvst2nL[s,tx1]$(nLSelvst2nL.l[s,t1] > 0) # E_nLSelvst2nL_forecast
  ;
  $GROUP G_labor_market_deep G_labor_market_deep$(tx0[t]);

  $BLOCK B_labor_market_deep
    E_fDiskDeltag_deep[a,t]$(tx0E[t] and a15t100[a] and a.val < 100 and t.val > %AgeData_t1%)..
      fDiskDeltag[a+1,t+1] =E= fDisk[a,t]
                             * (mUC[a+1,t+1] * pW[t+1] * qProdHh[a+1,t+1] * hLHh[a+1,t+1] / pC['Cx',t+1] * fhLHh[a+1,t+1] * fq)
                             / (mUC[a,t] * pW[t] * qProdHh[a,t] * hLHh[a,t] / pC[cTot,t] * (1-fhLHh[a+1,t+1]));

    # Grænsearbejderes produktivitet antages at følge danske husholdningers
    E_qProdxDK[t]$(tx1[t]).. qProdxDK[t] / qProdxDK[t-1] =E= qProd[sTot,t] / qProd[sTot,t-1];

    # Vi antager at andelen af selvstændige i beskæftigelsen følger andelen af erlagte timer
    E_nLSelvst2nL_forecast[s,t]$(tx1[t] and nLSelvst2nL.l[s,t1] > 0)..
      nLSelvst2nL[s,t] / nLSelvst2nL[s,t1] =E= hLSelvst2hL[s,t] / hLSelvst2hL[s,t1];
  $ENDBLOCK
  MODEL M_labor_market_deep /
    M_labor_market
    B_labor_market_deep
  /;
  model M_deep_dynamic_calibration / M_labor_market_deep /;
  $GROUP+ G_deep_dynamic_calibration G_labor_market_deep;
$ENDIF
 
# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
  $GROUP G_labor_market_dynamic_calibration
    G_labor_market_endo

    # Vi har BFR som (eneste aldersfordelte) kilde i foreløbige år - derfor kan beskæftigelse eksogeniseres
    -nLHh[a15t100,t1], uDeltag[a15t100,t1]

    $IF2 %FM_baseline%:
      -vhW[t1], jpW[t1]
    $ENDIF2

    $IF2 %DREAM_baseline%:# Endogent beskæftigelsesgab gør at en række størrelser skal rekalibreres 
      -nSoc[soc,t1]$(not boern[soc]), snSoc[soc,t1]$(not boern[soc])
      -vhW[t1], rLoenNash[t1]
      rLoenNash[tx1] # E_rLoenNash_forecast
    $ENDIF2

    jpW[tx1] # E_jpW_forecast

    -rProdVaekst, qProdHh_t # Vi sætter samlet produktivitetsvækst direkte og ser dermed bort fra sammensætningseffekter fra demografi

    qProdxDK[tx1] # E_qProdxDK
  ;
  $BLOCK B_labor_market_dynamic_calibration
    E_qProdxDK[t]$(tx1[t]).. qProdxDK[t] / qProdxDK[t-1] =E= qProd[sTot,t] / qProd[sTot,t-1];

    E_jpW_forecast[t]$(tx1[t]).. jpW[t] =E= 0.85**(dt[t]**1.5) * jpW[t1];

    E_rLoenNash_forecast[t]$(tx1[t] and %DREAM_baseline%).. @gradual_return_to_baseline(rLoenNash);
  $ENDBLOCK
  MODEL M_labor_market_dynamic_calibration /
    M_labor_market
    B_labor_market_dynamic_calibration
  /;
  model M_dynamic_calibration_newdata / M_labor_market_dynamic_calibration /;
  $GROUP+ G_dynamic_calibration_newdata G_labor_market_dynamic_calibration;
$ENDIF
