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
    pL[s_,t]$(sp[s_]) "User cost for effektiv arbejdskraft i produktionsfunktion."
    pW[t] "Løn pr. produktiv enhed arbejdskraft."
  ;
  $GROUP G_labor_market_quantities_endo
    dqL2dnL[s_,t] "qL differentieret ift. nL."
    dqL2dnLlag[sp,t] "qL[t] differentieret ift. nL[t-1]"
    dWTraeghed[t] "Hjælpevariabel til beregning af effekt fra løntræghed."
    qProdHh[a_,t]$(t.val > 2015) "Aldersfordelt produktivitet."
    qProd[s_,t] "Branchespecifikt produktivitetsindeks for arbejdskraft."
  ;

  $GROUP G_labor_market_values_endo_a
    vWHh[a_,t]$(a15t100[a_] and t.val > 2015) "Årsløn pr. beskæftiget."
    vFFOutsideOption[t]$(t.val > 2015) "Fagforenings forhandlingsalterntiv i lønforhandling."
  ;

  $GROUP G_labor_market_values_endo
    G_labor_market_values_endo_a

    vWHh[a_,t]$((aTot[a_] and t.val > 2015)) "Årsløn pr. beskæftiget."
    vhWIndustri[t] "Gennemsnitlig timeløn i industrien. Kilde: ADAM[lna]"
    vhW[t] "Gennemsnitlig timeløn."
    vWxDK[t] "Lønsum til grænsearbejdere."

    vSelvstLoen[s_,t] "Lønudbetaling til selvstændige."
    vLoensum[s_,t] "Lønsum, Kilde: ADAM[Yw]"

    vVirkLoenPos[t] "Hjælpevariabel til lønforhandling. Positiv del af virksomhedernes værdifunktion i lønforhandling."
  ;

  $GROUP G_labor_market_endo_a
    G_labor_market_values_endo_a

    nSoegBaseHh[a_,t]$((aTot[a_] or a15t100[a_]) and t.val > 2015) "Sum af jobsøgende og beskæftigede."
    nLHh[a_,t]$((a15t100[a_] and t.val > 2015)) "Beskæftigelse."
    nSoegHh[a_,t]$((a15t100[a_] and t.val > 2015)) "Jobsøgende."
    hLHh[a_,t]$((a15t100[a_] and t.val > 2015)) "Aldersfordelt arbejdstid, Kilde: FMs Befolkningsregnskab."
    rSeparation[a_,t]$(aTot[a_] and t.val > 2015) "Job-separations-rate."
    jhLHh[t]$(tBFR[t]) "J-led i timebeslutning."
    dFF2dLoen[t]$(t.val > 2015) "Fagforeningens værdifunktion i lønforhandling differentieret ift. løn."
    rJobFinding[a_,t]$(a15t100[a_]) "Andel af jobsøgende som får et job."
    jrJobFinding[a_,t]$(aTot[a_] and t.val > 2015) "J-led"
  ;

  $GROUP G_labor_market_endo 
    G_labor_market_endo_a
    G_labor_market_prices_endo
    G_labor_market_quantities_endo
    G_labor_market_values_endo

    rhL2nL[s_,t] "Arbejdstid pr. beskæftiget"
    rhL2nLxDK[t] "Arbejdstid pr. grænsearbejder"
    dOpslagOmk2dnL[sp,t] "rOpslagOmk * nL differentieret ift. nL."
    dOpslagOmk2dnLLag[sp,t] "rOpslagOmk * nL differentieret ift. nL[t-1]"

    nLHh[a_,t]$(aTot[a_]) "Beskæftigelse."
    nSoegHh[a_,t]$(aTot[a_]) "Jobsøgende."

    nLxDK[t] "Grænsearbejdere i antal hoveder - inkluderer pt. sort arbejde."
    nSoegxDK[t] "Jobsøgende potentielle grænsearbejdere."

    nLFuldtid[s_,t] "Fuldtidsbeskæftigelse"

    nSoegBase[t]$(t.val > 2015) "Sum af jobsøgende og beskæftigede fra udenlandske og danske husholdninger."

    hLHh[a_,t]$(aTot[a_] and tBFR[t]) "Aldersfordelt arbejdstid, Kilde: FMs Befolkningsregnskab."
    hL[s_,t]$(sTot[s_] or spTot[s_] or sByTot[s_]) "Erlagte arbejdstimer fordelt på brancher, Kilde: ADAM[hq] eller ADAM[hq<i>]"
    hLxDK[t] "Samlede erlagte arbejdstimer for grænsearbejdere."

    rJobFinding[a_,t]$(aTot[a_]) "Andel af jobsøgende som får et job."
    rMatch[t] "Andel af jobopslag, som resulterer i et match."
    nOpslag[s_,t] "Samlet antal jobopslag."
    rOpslagOmk[s_,t] "Andel af arbejdskraft som anvendes til hyrings-omkostninger."

    nL[s_,t] "Beskæftigelse fordelt på brancher, Kilde: ADAM[Q] eller ADAM[Q<i>]"
    nPop[a_,t]$(not a[a_] and t.val > 1991) "Befolkningen."
    nSoc[soc,t]$(tBFR[t]) "Befolkning fordelt på socio-grupper, antal 1.000 personer, Kilde: BFR."
    nBruttoLedig[t]$(tBFR[t]) "Bruttoledige. Antal 1.000 personer. Kilede: BFR"
    nBruttoArbsty[t]$(tBFR[t]) "Brutto-arbejdsstyrke. Antal 1.000 personer. Kilede: BFR"
    nNettoLedig[t]$(tBFR[t]) "Nettoledige. Antal 1.000 personer. Kilede: BFR"
    nNettoArbsty[t]$(tBFR[t]) "Netto-arbejdsstyrke. Antal 1.000 personer. Kilede: BFR"
    rBruttoLedig[t]$(tBFR[t]) "Bruttoledighedsrate."
    rBruttoLedigGab[t]$(tBFR[t]) "Gab i bruttoledighedsrate."
    rNettoLedig[t]$(tBFR[t]) "Nettoledighedsrate."
    rNettoLedigGab[t]$(tBFR[t]) "Gab i nettoledighedsrate."
    rLoenkvote[s_,t] "Sektorfordelt lønkvote"

    nL_InklOrlov[t] "Beskæftigede i alt inkl. orlov, Kilde: ADAM[Qb1]."
    nOrlov[t] "Personer som er midlertidigt fraværende fra beskæftigelse, Kilde: ADAM[Qm]."

    tL[s_,t]$(t.val > 2015 or s[s_]) "Nettosats for afgifter og subsidier på arbejdskraft inklusiv selvstændige (betalt af arbejdsgiver)"

    rProdVaekst[t] "Vækstrate for i qProd (Produktivitetsindeks for Harrod-neutral vækst på tværs af brancher)"
    dVirk2dLoen[t] "Virksomhedernes værdifunktion i lønforhandling differentieret ift. løn."
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
    nPop, nLxDK
    rSeparation$(a[a_])
  ;

  $GROUP G_labor_market_forecast_as_zero
    jnSoc[soc,t] "J-led."
    jhLHh_a[a,t] "J-led i timebeslutning."
    jhLHh_t[t] "J-led i timebeslutning."
    jpL_s[s_,t] "J-led"
    jpL_t[t] "J-led"
    jrJobFinding[a_,t]$(a[a_]) "J-led"
    jrJobFinding_t[t] "J-led"
  ;
  $GROUP G_labor_market_ARIMA_forecast
    rLoenNash[t] "Nash-forhandlingsvægt."
    rSelvst[s_,t] "Andel af beskæftigede, som er selvstændige."
  ;
  $GROUP G_labor_market_constants
    eDeltag "Parameter, som styrer elasticiteten på arbejdsstyrke-deltagelse, fra ændringer i matching-raten."
    emrKomp "Parameter, som styrer elasticiteten på arbejdsstyrke-deltagelse, fra ændringer i kompensationsgrad."
    eMatching "Eksponent i matching funktion."
    eh           "Invers arbejdsudbudselasticitet - intensiv margin."

    uOpslagOmk    "Lineær omkostning pr. jobopslag."
    uMatchOmk     "Lineær omkostning pr. jobmatch."
    uMatchOmkSqr "Kvadratisk omkostning ved jobopslag."

    uWTraeghed "Parameter for Rotemberg-træghed i lønforhandling."
    rFFLoenAlternativ "Forhandlingsalternativ (outside option) for fagforening i lønforhandling."

    rhL2nFuldtid[t] "Arbejdstid pr. fuldtidspersion."
  ;
  $GROUP G_labor_market_other
    rhL2nL0[s,t] "Parameter som styrer branchespecifik arbejdstid."

    fDiskpL[sp,t] "Eksogent diskonteringsfaktor i efterspørgsel efter arbejdskraft."
    fDiskDeltag[a,t] "Eksogent diskonteringsfaktor i deltagelsesbeslutning."
    mrKomp[a_,t] "Marginal netto-kompensationsgrad."

    nSoegBasexDK[t] "Sum af grænsearbejdere og jobsøgende potentielle grænsearbejdere."

    uDeltag[a,t] "Præferenceparameter for arbejdsstyrke-deltagelse."
    uh[a,t] "Præferenceparameter for timer."
    uhLxDK[t] "Faktor som korrigerer for forskel i gennemsnitlig arbejdstid mellem grænsearbejdere og danskboende beskæftigede."

    rAMDisk[t] "Eksogen diskonterings-rate for parter i lønforhandling."

    nOrlovRest[t] "Personer i større arbejdsmarkedskonflikter mv."

    uhWIndustri[t] "Skalaparameter som styrer forhold mellem industriløn og løn i fremstillingsbranchen."
    uProd[s_,t] "Parameter til at styre branchespecifik produktivitet for arbejdskraft."
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================

$IF %stage% == "equations":

$BLOCK B_labor_market_aTot
  # ----------------------------------------------------------------------------------------------------------------------
  # Aggregation
  # ----------------------------------------------------------------------------------------------------------------------
      E_hL_tot[t]$(tx0[t]).. hL[sTot,t] =E= hLHh[atot,t] + hLxDK[t];

      # Den faktiske arbejdstid følger det strukturelle
      E_hLHh_tot[t]$(tx0[t] and tBFR[t]).. hLHh[aTot,t] =E= shLHh[aTot,t] + jhLHh[t];

      E_hLxDK[t]$(tx0[t]).. hLxDK[t] =E= nLxDK[t] * rhL2nLxDK[t];

      E_rhL2nLxDK[t]$(tx0[t]).. rhL2nLxDK[t] =E= uhLxDK[t] * hLHh[aTot,t] / nLHh[aTot,t];

      E_rhL2nL_sTot[t]$(tx0[t]).. hL[sTot,t] =E= rhL2nL[sTot,t] * nL[sTot,t];
      E_nL[s,t]$(tx0[t]).. hL[s,t] =E= rhL2nL[s,t] * nL[s,t];

      E_nLFuldtid[s,t]$(tx0[t]).. nLFuldtid[s,t] * rhL2nFuldtid[t] =E= hL[s,t];
      E_nLFuldtid_sTot[t]$(tx0[t]).. nLFuldtid[sTot,t] * rhL2nFuldtid[t] =E= hL[sTot,t];
      E_nLFuldtid_spTot[t]$(tx0[t]).. nLFuldtid[spTot,t] * rhL2nFuldtid[t] =E= hL[spTot,t];
      E_nLFuldtid_sByTot[t]$(tx0[t]).. nLFuldtid[sByTot,t] * rhL2nFuldtid[t] =E= hL[sByTot,t];

      # Vi antager at forskellige i arbejdstid mellem brancher skyldes selektion og følger individerne ved brancheskift
      E_rhL2nL[s,t]$(tx0[t]).. rhL2nL[s,t] =E= rhL2nL0[s,t] * hL[sTot,t] / sum(ss, rhL2nL0[ss,t] * nL[ss,t]);

      E_qProd_sTot[t]$(tx0[t]).. qProd[sTot,t] * hL[sTot,t] =E= qProdHh[aTot,t] * hLHh[aTot,t] + qProdxDK[t] * hLxDK[t];
      E_qProd_spTot[t]$(tx0[t]).. qProd[sTot,t] * hL[sTot,t] =E= qProd[spTot,t] * hL[spTot,t] + qProd["off",t] * hL["off",t];
      E_qProd_sByTot[t]$(tx0[t])..  qProd[sByTot,t] * hL[sByTot,t] =E= sum(sBy, qProd[sBy,t] * hL[sBy,t]);

      E_rProdVaekst[t]$(tx0[t]).. rProdVaekst[t] =E= qProd[sTot,t] / (qProd[sTot,t-1]/fq) - 1;

      E_nL_tot[t]$(tx0[t]).. nL[sTot,t] =E= nLHh[aTot,t] + nLxDK[t];

      E_nOpslag_tot[t]$(tx0[t]).. nOpslag[sTot,t] =E= sum(s, nOpslag[s,t]);

      # Privat-sektor aggregater
      E_nL_spTot[t]$(tx0[t]).. nL[spTot,t] =E= sum(sp, nL[sp,t]);
      E_nL_sByTot[t]$(tx0[t]).. nL[sByTot,t] =E= sum(sBy, nL[sBy,t]);
      E_hL_spTot[t]$(tx0[t]).. hL[spTot,t] =E= sum(sp, hL[sp,t]);
      E_hL_sByTot[t]$(tx0[t]).. hL[sByTot,t] =E= sum(sBy, hL[sBy,t]);
      E_rhL2nL_spTot[t]$(tx0[t]).. hL[spTot,t] =E= rhL2nL[spTot,t] * nL[spTot,t];

      # Lønsum til husholdninger og udlandskarbejdskraft
      E_vWHh_tot[t]$(tx0[t]).. vWHh[aTot,t] =E= pW[t] * qProdHh[aTot,t] * hLHh[aTot,t];
      E_vWxDK[t]$(tx0[t]).. vWxDK[t] =E= pW[t] * qProdxDK[t] * hLxDK[t];

  # ----------------------------------------------------------------------------------------------------------------------
  # Search and Matching        
  # ----------------------------------------------------------------------------------------------------------------------
      E_rMatch[t]$(tx0[t])..
        rMatch[t] * nOpslag[sTot,t] =E= rJobFinding[aTot,t] * (nSoegHh[aTot,t] + nSoegxDK[t]);

      E_rJobFinding_aTot[t]$(tx0[t])..
        rJobFinding[aTot,t] =E= nOpslag[sTot,t]
                              / (nOpslag[sTot,t]**(1/eMatching) + (nSoegHh[aTot,t] + nSoegxDK[t])**(1/eMatching))**eMatching
                              + jrJobFinding[aTot,t];

      E_nLHh_tot[t]$(tx0[t])..
        nLHh[aTot,t] =E= (1-rSeparation[aTot,t]) * nLHh[aTot,t-1] + rJobFinding[aTot,t] * nSoegHh[aTot,t];
      E_nSoegHh_tot[t]$(tx0[t])..
        nSoegBaseHh[aTot,t] =E= nLHh[aTot,t] + (1 - rJobFinding[aTot,t]) * nSoegHh[aTot,t];

      E_nLxDK[t]$(tx0[t]).. nLxDK[t] =E= (1-rSeparation[aTot,t]) * nLxDK[t-1] + rJobFinding[aTot,t] * nSoegxDK[t]; 
      E_nSoegxDK[t]$(tx0[t]).. nSoegxDK[t] =E= nSoegBasexDK[t] - (1-rSeparation[aTot,t]) * nLxDK[t-1];

  # ----------------------------------------------------------------------------------------------------------------------
  # Firm FOC. and Vacancy Costs 
  # ----------------------------------------------------------------------------------------------------------------------                                    
      E_pL[sp,t]$(tx0E[t])..
        pL[sp,t] =E= pW[t] * (1 + tL[sp,t]) * qProd[sp,t] * rhL2nL[sp,t] / (dqL2dnL[sp,t] + (1-mtVirk[sp,t+1])/(1-mtVirk[sp,t]) * fDiskpL[sp,t+1] * dqL2dnLlag[sp,t+1]*fq)
                   + jpL_s[sp,t] + jpL_t[t];

      E_pL_tEnd[sp,t]$(tEnd[t])..
        pL[sp,t] =E= pW[t] * (1 + tL[sp,t]) * qProd[sp,t] * rhL2nL[sp,t] / (dqL2dnL[sp,t] + (1-mtVirk[sp,t])/(1-mtVirk[sp,t]) * fDiskpL[sp,t] * dqL2dnLlag[sp,t]*fq)
                   + jpL_s[sp,t] + jpL_t[t];

      E_dqL2dnL[sp,t]$(tx0[t])..
        dqL2dnL[sp,t] =E= rLUdn[sp,t] * qProd[sp,t] * rhL2nL[sp,t] * (1 - dOpslagOmk2dnL[sp,t]);

      E_dqL2dnLlag[sp,t]$(tx0[t])..
        dqL2dnLlag[sp,t] =E= - rLUdn[sp,t] * qProd[sp,t] * rhL2nL[sp,t] * dOpslagOmk2dnLLag[sp,t];

      E_rOpslagOmk[s,t]$(tx0[t])..
        rOpslagOmk[s,t] * nL[s,t] =E= uOpslagOmk * nOpslag[s,t]
                                    + uMatchOmk * rMatch[t] * nOpslag[s,t]
                                    + uMatchOmkSqr/2 * nL[s,t]
                                    * sqr(nL[s,t] / nL[s,t-1] / (nL[s,t-1] / nL[s,t-2]) - 1);

      E_rOpslagOmk_tot[t]$(tx0[t])..
        rOpslagOmk[sTot,t] * nL[sTot,t] =E= sum(s, rOpslagOmk[s,t] * nL[s,t]);

      E_dOpslagOmk2dnL[sp,t]$(tx0[t])..
        dOpslagOmk2dnL[sp,t] =E= uOpslagOmk / rMatch[t]
                               + uMatchOmkSqr/2 * sqr(nL[sp,t] / nL[sp,t-1] / (nL[sp,t-1] / nL[sp,t-2]) - 1)
                               + uMatchOmkSqr * nL[sp,t] / nL[sp,t-1] / (nL[sp,t-1] / nL[sp,t-2])
                               * (nL[sp,t] / nL[sp,t-1] / (nL[sp,t-1] / nL[sp,t-2]) - 1)
                               + uMatchOmk;

      E_dOpslagOmk2dnLLag[sp,t]$(tx0[t])..
        dOpslagOmk2dnLLag[sp,t] =E= - (1-rSeparation[aTot,t]) * (uOpslagOmk / rMatch[t] + uMatchOmk)
                                    - 2 * uMatchOmkSqr
                                    * nL[sp,t] / nL[sp,t-1]
                                    * nL[sp,t] / nL[sp,t-1] / (nL[sp,t-1] / nL[sp,t-2])
                                    * (nL[sp,t] / nL[sp,t-1] / (nL[sp,t-1] / nL[sp,t-2]) - 1);

      E_nOpslag[s,t]$(tx0[t])..
        nL[s,t] =E= (1-rSeparation[aTot,t]) * nL[s,t-1] + rMatch[t] * nOpslag[s,t];

  # ----------------------------------------------------------------------------------------------------------------------
  # Branche-fordelte lønninger
  # ----------------------------------------------------------------------------------------------------------------------
      # Vi antager at forskellige i timeløn mellem brancher skyldes selektion og følger individerne ved brancheskift
      E_qProd_sp[sp,t]$(tx0[t]).. qProd[sp,t] =E= uProd[sp,t] * qProd[spTot,t] * hL[spTot,t] / sum(ssp, uProd[ssp,t] * hL[ssp,t]);
      E_qProd_off[t]$(tx0[t]).. qProd['off',t] =E= sqProd['off',t];

      # Lønudbetaling til selvstændige
      E_vSelvstLoen[s,t]$(tx0[t]).. vSelvstLoen[s,t] =E= rSelvst[s,t] * pW[t] * qProd[s,t] * hL[s,t];
      E_vSelvstLoen_tot[t]$(tx0[t]).. vSelvstLoen[sTot,t] =E= sum(s, vSelvstLoen[s,t]);

      # Lønsum eksklusiv selvstændige
      E_vLoensum[s,t]$(tx0[t]).. vLoensum[s,t] =E= (1-rSelvst[s,t]) * pW[t] * qProd[s,t] * hL[s,t];
      E_vLoensum_sTot[t]$(tx0[t]).. vLoensum[sTot,t] =E= sum(s, vLoensum[s,t]);
      E_vLoensum_spTot[t]$(tx0[t]).. vLoensum[spTot,t] =E= sum(sp, vLoensum[sp,t]);
      E_vLoensum_sByTot[t]$(tx0[t]).. vLoensum[sByTot,t] =E= sum(sBy, vLoensum[sBy,t]);

      E_rLoenkvote[s,t]$(tx0[t]).. rLoenkvote[s,t] =E= vLoensum[s,t] / vBVT[s,t];
      E_rLoenkvote_sTot[t]$(tx0[t]).. rLoenkvote[sTot,t] =E= vLoensum[sTot,t] / vBVT[sTot,t];
      E_rLoenkvote_spTot[t]$(tx0[t]).. rLoenkvote[spTot,t] =E= vLoensum[spTot,t] / vBVT[spTot,t];
      E_rLoenkvote_sByTot[t]$(tx0[t]).. rLoenkvote[sByTot,t] =E= vLoensum[sByTot,t] / vBVT[sByTot,t];

      # Nettosats for afgifter og subsidier på arbejdskraft inklusiv selvstændige (betalt af arbejdsgiver)
      E_tL[s,t]$(tx0[t]).. tL[s,t] =E= vtNetLoenAfg[s,t] / (vLoensum[s,t] + vSelvstLoen[s,t]);

  # ----------------------------------------------------------------------------------------------------------------------
  # Wage Bargaining
  # ----------------------------------------------------------------------------------------------------------------------
      E_vhWIndustri[t]$(tx0[t]).. vhWIndustri[t] =E= uhWIndustri[t] * pW[t] * qProd['fre',t];
      E_vhW[t]$(tx0[t]).. vhW[t] =E= pW[t] * qProd[sTot,t];

      E_vVirkLoenPos[t]$(tx0[t])..
        vVirkLoenPos[t] =E= sum(sp, (1-mtVirk[sp,t]) * pL[sp,t] * rLUdn[sp,t] * hL[sp,t] * qProd[sp,t]);

      E_dVirk2dLoen[t]$(tx0[t])..
        dVirk2dLoen[t] =E= - sum(sp, (1-mtVirk[sp,t]) * (1 + tL[sp,t]) * hL[sp,t] * qProd[sp,t] * (1-rOpslagOmk[sp,t]));

      E_pW[t]$(tx0E[t] and t.val > 2015)..
        pW[t] =E= (1-rLoenNash[t]) * vVirkLoenPos[t] / (-dVirk2dLoen[t]) + rLoenNash[t] * vFFOutsideOption[t] / dFF2dLoen[t]
                 - dWTraeghed[t] + 2 * dWTraeghed[t+1] / (1+rAMDisk[t+1]);

      E_pW_tEnd[t]$(tEnd[t] and t.val > 2015)..
        pW[t] =E= (1-rLoenNash[t]) * vVirkLoenPos[t] / (-dVirk2dLoen[t]) + rLoenNash[t] * vFFOutsideOption[t] / dFF2dLoen[t];

      E_dWTraeghed[t]$(tx0[t] and t.val > 2015).. 
        dWTraeghed[t] =E= uWTraeghed * ((pW[t]/pW[t-1]) / (pW[t-1]/pW[t-2]) - 1)
                                     * ((pW[t]/pW[t-1]) / (pW[t-1]/pW[t-2]));

  # ----------------------------------------------------------------------------------------------------------------------
  # Socio-grupper og aggregater herfra
  # ----------------------------------------------------------------------------------------------------------------------
      # Socio-grupper følger udvikling i beskæftigelsen (jf. BFR2GDX.gms) og en residual som følger befolkningen
      E_nSoc[soc,t]$(tx0[t] and tBFR[t])..
        nSoc[soc,t] =E= snSoc[soc,t] + dSoc2dBesk[soc,t] * (nLHh[aTot,t] - snLHh[aTot,t]) + jnSoc[soc,t];

      # Aggregater fra socio-grupper
      E_nBruttoLedig[t]$(tx0[t] and tBFR[t]).. nBruttoLedig[t] =E= sum(BruttoLedig, nSoc[BruttoLedig,t]);
      E_nNettoLedig[t]$(tx0[t] and tBFR[t]).. nNettoLedig[t] =E= sum(NettoLedig, nSoc[NettoLedig,t]);
      E_nBruttoArbsty[t]$(tx0[t] and tBFR[t]).. nBruttoArbsty[t] =E= sum(BruttoArbsty, nSoc[BruttoArbsty,t]) + nLxDK[t];
      E_nNettoArbsty[t]$(tx0[t] and tBFR[t]).. nNettoArbsty[t] =E= sum(NettoArbsty, nSoc[NettoArbsty,t]) + nLxDK[t];

      E_nPop_tot[t]$(tx0[t] and t.val > 1991)..    nPop[aTot,t]     =E= sum(a, nPop[a,t]);
      E_nPop_a15t100[t]$(tx0[t] and t.val > 1991).. nPop['a15t100',t] =E= sum(a$a15t100[a], nPop[a,t]);
      E_nPop_a0t17[t]$(tx0[t] and t.val > 1991)..   nPop['a0t17',t]   =E= sum(a$a0t17[a], nPop[a,t]);
      E_nPop_a18t100[t]$(tx0[t] and t.val > 1991).. nPop['a18t100',t] =E= sum(a$a18t100[a], nPop[a,t]);

      E_rBruttoLedig[t]$(tx0[t] and tBFR[t])..  rBruttoLedig[t] =E= nBruttoLedig[t] / nBruttoArbsty[t];
      E_rBruttoLedigGab[t]$(tx0[t] and tBFR[t]).. rBruttoLedigGab[t] =E= rBruttoLedig[t] - srBruttoLedig[t];
      E_rNettoLedig[t]$(tx0[t] and tBFR[t])..  rNettoLedig[t] =E= nNettoledig[t] / nNettoArbsty[t];
      E_rNettoLedigGab[t]$(tx0[t] and tBFR[t]).. rNettoLedigGab[t] =E= rNettoLedig[t] - srNettoLedig[t];

      E_nSoegBase[t]$(tx0[t] and t.val > 2015).. nSoegBase[t] =E= nSoegBaseHh[aTot,t] + nSoegBasexDK[t];
      
      E_nL_InklOrlov[t]$(tx0[t]).. nL_InklOrlov[t] =E= nL[sTot,t] + nOrlov[t];

      E_nOrlov[t]$(tx0[t]).. nOrlov[t] =E= nSoc['orlov',t] + nSoc['beskbarsel',t] + nSoc['besksyge',t] + nOrlovRest[t];

$ENDBLOCK



$BLOCK B_labor_market_a
  # ----------------------------------------------------------------------------------------------------------------------
  # Various Aggregates and Income Terms 
  # ----------------------------------------------------------------------------------------------------------------------
      # Wage payment pr. person by age
      E_vWHh[a,t]$(tx0[t] and a15t100[a] and t.val > 2015).. vWHh[a,t] =E= pW[t] * qProdHh[a,t] * hLHh[a,t];

      # Wage total                   
      E_qProdHh_tot[t]$(tx0[t] and t.val > 2015).. vWHh[aTot,t] =E= sum(a, vWHh[a,t] * nLHh[a,t]);
      E_qProdHh[a,t]$(tx0[t] and t.val > 2015).. qProdHh[a,t] =E= qProdHh_t[t] * qProdHh_a[a,t];

  # ----------------------------------------------------------------------------------------------------------------------
  # Household First-order Conditions
  # ----------------------------------------------------------------------------------------------------------------------
      E_nSoegBaseHh_aTot[t]$(tx0[t] and t.val > 2015).. nSoegBaseHh[aTot,t] =E= sum(a, nSoegBaseHh[a,t]);

      E_nSoegBaseHh[a,t]$(tx0E[t] and a15t100[a] and a.val < 100 and t.val > 2015)..
        (uDeltag[a,t] / (1 - nSoegBaseHh[a,t]/nPop[a,t]))**eDeltag =E= rJobFinding[a,t] * (
            (1 - mrKomp[a,t] - (uh[a,t] * hLHh[a,t])**eh / (1+eh))**(eDeltag/emrKomp)
          + rOverlev[a,t] * (1-rSeparation[a+1,t+1]) * fDiskDeltag[a+1,t+1]
          * (1/rJobFinding[a+1,t+1] - 1)
          * (uDeltag[a+1,t+1] / (1 - nSoegBaseHh[a+1,t+1]/nPop[a+1,t+1]))**eDeltag
        );

      # Terminal condition for last period 
      E_nSoegBaseHh_tEnd[a,t]$(tEnd[t] and a15t100[a] and a.val < 100 and t.val > 2015)..
        (uDeltag[a,t] / (1 - nSoegBaseHh[a,t]/nPop[a,t]))**eDeltag =E= rJobFinding[a,t] * (
            (1 - mrKomp[a,t] - (uh[a,t] * hLHh[a,t])**eh / (1+eh))**(eDeltag/emrKomp)
          + rOverlev[a,t] * (1-rSeparation[a+1,t]) * fDiskDeltag[a+1,t]
          * (1/rJobFinding[a+1,t] - 1)
          * (uDeltag[a+1,t] / (1 - nSoegBaseHh[a+1,t]/nPop[a+1,t]))**eDeltag
        );

      # Terminal condition for last age group
      E_nSoegBaseHh_aEnd[a,t]$(tx0[t] and a.val = 100 and t.val > 2015)..
        (uDeltag[a,t] / (1 - nSoegBaseHh[a,t]/nPop[a,t]))**eDeltag =E= rJobFinding[a,t] * (
            (1 - mrKomp[a,t] - (uh[a,t] * hLHh[a,t])**eh / (1+eh))**(eDeltag/emrKomp)
            # Ingen sandsynlighed for at beholde job til næste periode
        );

      # Den faktiske arbejdstid følger det strukturelle
      E_hLHh[a,t]$(tx0[t] and a15t100[a] and t.val > 2015).. hLHh[a,t] =E= shLHh[a,t] + jhLHh_a[a,t] + jhLHh_t[t];

      E_jhLHh[t]$(tx0[t] and tBFR[t]).. hLHh[atot,t] =E= sum(a, hLHh[a,t] * nLHh[a,t]);

  # ----------------------------------------------------------------------------------------------------------------------
  # Search and Matching        
  # ----------------------------------------------------------------------------------------------------------------------
      E_rJobFinding[a,t]$(tx0[t] and a15t100[a])..
        rJobFinding[a,t] =E= rJobFinding[aTot,t] - jrJobFinding[aTot,t] + jrJobFinding[a,t] + jrJobFinding_t[t];

      E_jrJobFinding_aTot[t]$(tx0[t] and t.val > 2015)..
        rJobFinding[aTot,t] * nSoegHh[aTot,t] =E= sum(a, rJobFinding[a,t] * nSoegHh[a,t]);

      E_rSeparation_tot[t]$(tx0[t] and t.val > 2015)..
        nSoegHh[aTot,t] =E= sum(a, nSoegHh[a,t]);

      E_nLHh[a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
        nLHh[a,t] =E= (1-rSeparation[a,t]) * nLHh[a-1,t-1] * nPop[a,t]/nPop[a-1,t-1] + rJobFinding[a,t] * nSoegHh[a,t];

      E_nSoegHh[a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
        nSoegBaseHh[a,t] =E= nLHh[a,t] + (1-rJobFinding[a,t]) * nSoegHh[a,t];

  # ----------------------------------------------------------------------------------------------------------------------
  # Wage Bargaining and Calvo Rigidity
  # ----------------------------------------------------------------------------------------------------------------------
      E_dFF2dLoen[t]$(tx0[t] and t.val > 2015)..
        dFF2dLoen[t] =E= sum(a, (1-mtInd[a,t]) * nLHh[a,t] * qProdHh[a,t] * hLHh[a,t]);

      E_vFFOutsideOption[t]$(tx0[t] and t.val > 2015)..
        vFFOutsideOption[t] =E= rFFLoenAlternativ * dFF2dLoen[t] * rJobFinding[aTot,t] * pW[t];
  $ENDBLOCK


  MODEL M_labor_market / 
    B_labor_market_aTot
    B_labor_market_a
  /;

  # Equations that do not need to be solved together with the full model and can instead be solved afterwards.
  MODEL M_labor_market_post /
    E_nSoegBase
    E_vSelvstLoen_tot
    E_vLoensum_spTot, E_vLoensum_sByTot
    E_nL_InklOrlov
    E_nOrlov
    E_nLFuldtid, E_nLFuldtid_sTot, E_nLFuldtid_spTot, E_nLFuldtid_sByTot
    E_rLoenkvote, E_rLoenkvote_sTot, E_rLoenkvote_spTot, E_rLoenkvote_sByTot
    E_qProd_sByTot
  /;

  # Endogenous variables that are solved for only after the main model.
  # Note that these may not appear anywhere in the main model (this results in a model not square error).
  $GROUP G_labor_market_post
    nSoegBase[t]$(t.val > 2015)
    vSelvstLoen[s_,t]$(sTot[s_])
    vLoensum[s_,t]$(spTot[s_] or sByTot[s_])
    nL_InklOrlov
    nOrlov
    nLFuldtid
    rLoenkvote
    qProd$(sByTot[s_])
  ;
  $GROUP G_labor_market_post G_labor_market_post$(tx0[t]);

$ENDIF


# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
$IF %stage% == "exogenous_values":
# =============================================================================================½=========================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_labor_market_makrobk
    nPop, nSoegBaseHh$(aTot[a_]), nL$(s[s_] or sTot[s_]), hL$(s[s_] or sTot[s_]), vWxDK
    rBruttoLedigGab, qProd$(sTot[s_]), vWHh$(aTot[a_])
    vhWIndustri, pW, vSelvstLoen[s_,t]$(s[s_] or sTot[s_]), vLoensum[s_,t]$(s[s_] or sTot[s_])
    rBruttoLedigGab, nOrlov, nL_InklOrlov
  ;
  @load(G_labor_market_makrobk, "..\Data\makrobk\makrobk.gdx" )

  # Aldersfordelt data fra aldersprofiler indlæses
  $GROUP G_labor_market_aldersprofiler
    vWHh$(a[a_] and tAgeData[t])
  ;
  @load(G_labor_market_aldersprofiler, "..\Data\Aldersprofiler\aldersprofiler.gdx" )

  # Aldersfordelt data fra BFR indlæses
  $GROUP G_labor_market_BFR
    nPop, nSoc, nLHh, hLHh, rSeparation, mrKomp    
  ;
  @load(G_labor_market_BFR, "..\Data\Befolkningsregnskab\BFR.gdx" )
  
  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_labor_market_data
    G_labor_market_makrobk
    G_labor_market_BFR
    -rSeparation # Ændres i struk i kalibreringsår for at ramme snLHh
    -mrKomp # Ændres ved smoothing
    nLxDK, hLxDK
    -qProd
  ; 
  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_labor_market_data_imprecise
    rBruttoLedigGab, nL_InklOrlov
  ;

# =============================================================================================½=========================
# Exogenous variables
# ======================================================================================================================
  eMatching.l = 1.215177; # Matching parameter
  rFFLoenAlternativ.l = 0.063172; # Matching parameter

  eDeltag.l = 2;
  eh.l = 10;
  emrKomp.l = 10;
  uWTraeghed.l = 6.076509; # Matching parameter

  uOpslagOmk.l = 0.02;
  uMatchOmk.l = 0.0;
  uMatchOmkSqr.l = 0.581762; # Matching parameter

  rhL2nFuldtid.l[t] = 222 * 7.4 / 1000; # 222 dage * 7.4 timer pr. dag, enhed=1000 timer

# ======================================================================================================================
# Data assignment
# ======================================================================================================================
  # --------------------------------------------------------------------------------------------------------------------
  # Wages and productivity
  # --------------------------------------------------------------------------------------------------------------------
  qProdHh_t.l[t] = 1;

  # --------------------------------------------------------------------------------------------------------------------
  # LABOR MARKET DEMOGRAPHICS
  # --------------------------------------------------------------------------------------------------------------------
  set_data_periods_from_subset(tBFR);
  nLHh.l[aTot,t]$(t.val < tData1.val) = nL.l[sTot,t] / nL.l[sTot,tData1] * nLHh.l[aTot,tData1];  # Outside BFR years, we set use ADAM data for the number of employed persons, but level shifted to match BFR in year 2001.
  hLHh.l[aTot,t]$(t.val < tData1.val) = hL.l[sTot,t] / hL.l[sTot,tData1] * hLHh.l[aTot,tData1];  # Outside BFR years, we set use ADAM data for the number hours worked, but level shifted to match BFR in year 2001.
  set_data_periods(%cal_start%, %cal_end%);
  nLxDK.l[t] = nL.l[sTot,t] - nLHh.l[aTot,t];
  hLxDK.l[t] = hL.l[sTot,t] - hLHh.l[aTot,t];
$ENDIF


# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_labor_market_static_calibration_base
    G_labor_market_endo
    -vWHh$(aTot[a_] and t.val <= 2015), qProdHh$(aTot[a_] and t.val <= 2015)
    -nLxDK, nSoegBasexDK # Number of foreign job searchers calibrated to match total employment
    -hLxDK, uhLxDK # Hours of foreign workers calibrated to match total hours worked
    -nL$(s[s_]), rhL2nL0 # E_rhL2nL0, -E_rhL2nL
    -vWxDK, qProdxDK
    -pW, rLoenNash
    -nOrlov, nOrlovRest
    -nSoc[soc,t], jnSoc[soc,t]$(tBFR[t])
    fDiskpL[sp,t] # E_fDiskpL
    rAMDisk[t] # E_rAMDISK
    rSelvst$(s[s_]), -vSelvstLoen$(s[s_])
    uProd[s_,t]$(s[s_]), -vLoensum[s_,t]$(s[s_]) # E_uProd, -E_qProd_sp
    -nSoegBaseHh$(aTot[a_]) # -E_nSoegBaseHh_aTot (We allow some imprecision here to prevent a pivot too small error)
    dWTraeghed # -E_dWTraeghed
    -vhWIndustri, uhWIndustri
  ;

  $BLOCK B_labor_market_static_calibration_base
    E_rhL2nL0[s,t]$(tx0[t]).. rhL2nL0[s,t] =E= rhL2nL[s,t];

    E_fDiskpL[sp,t]$(tx1[t]).. fDiskpL[sp,t] =E= fVirkDisk[sp,t] * pL[sp,t]*fp / pL[sp,t-1];

    E_rAMDISK[t]$(tx1[t]).. rAMDisk[t] * sum(sp, hL[sp,t] * qProd[sp,t]) =E= sum(sp, hL[sp,t] * qProd[sp,t] * rVirkDisk[sp,t]);

    E_uProd[sp,t]$(tx0[t]).. uProd[sp,t] =E= qProd[sp,t] / qProd[sTot,t];

   E_pL_static[sp,t]$(tx0[t])..
      (1 - dOpslagOmk2dnL[sp,t])
      =E= pW[t] * (1 + tL[sp,t]) / rLUdn[sp,t] / pL[sp,t]
        - fp * fVirkDisk[sp,t] * (1-rSeparation[aTot,t]) * (uOpslagOmk / rMatch[t] + uMatchOmk) * fq;

    E_pW_static[t]$(tx0[t])..
      pW[t] =E= (1-rLoenNash[t]) * vVirkLoenPos[t] / (-dVirk2dLoen[t])
              + rLoenNash[t] * rFFLoenAlternativ * rJobFinding[aTot,t] * pW[t];
  $ENDBLOCK
  MODEL M_labor_market_static_calibration_base /
    M_labor_market 
    B_labor_market_static_calibration_base
    -E_rhL2nL
    -E_qProd_sp
    -E_nSoegBaseHh_aTot
    -E_pL -E_pL_tEnd # E_pL_static
    -E_pW -E_pW_tEnd # E_pW_static
    -E_dWTraeghed
  /;

  $GROUP G_labor_market_simple_static_calibration
    G_labor_market_static_calibration_base
    -G_labor_market_endo_a
  # Beregninger af led som er endogene i aldersdel (skal være uændret, når de beregnes endogent)
    -vWHh$(aTot[a_]), qProdHh$(aTot[a_])
    -hLHh[a_,t]$(aTot[a_]), jhLHh[t]
  ;
  $GROUP G_labor_market_simple_static_calibration
    G_labor_market_simple_static_calibration$(tx0[t])
  ;

  MODEL M_labor_market_simple_static_calibration /
    M_labor_market_static_calibration_base
    -B_labor_market_a
  /;

  $GROUP G_labor_market_static_calibration
    G_labor_market_static_calibration_base
    -vWHh$(a15t100[a_]), qProdHh_a$(a15t100[a])
    -nLHh[a_,t]$(a[a_]) # -E_nSoegBaseHh, E_nSoegBaseHh_tEnd, E_nSoegBaseHh_aEnd
    -hLHh[a_,t]$(a[a_]), jhLHh_a[a,t]
  ;
  $GROUP G_labor_market_static_calibration
    G_labor_market_static_calibration$(tx0[t])
  ;

  MODEL M_labor_market_static_calibration /
    M_labor_market_static_calibration_base
    -E_nSoegBaseHh - E_nSoegBaseHh_aEnd - E_nSoegBaseHh_tEnd
  /;
$ENDIF


# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_labor_market_deep
    G_labor_market_endo

    -nLHh[a_,t]$(t1[t] and a[a_]), uDeltag[a,t]$(t1[t])
    -hLHh[a_,t]$(t1[t] and a[a_]), jhLHh_a[a,t]$(t1[t])

    # hL[tot] er givet fra efterspørgselssiden og sum(hLHh[a]) er eksogeniseret.
    # Arbejdsstyrke eksogeniseres og nLxDK tager tilpasning fra manglende numerisk præcision.
    -nSoegBaseHh$(aTot[a_] and t1[t]), nSoegBasexDK[t]$(t1[t])
    -nLxDK[t]$(tx1[t]), nSoegBasexDK[t]$(tx1[t])

    -pW[t]$(t1[t]), rLoenNash[t]$(t1[t])
    rLoenNash[t]$(tx1[t]) # E_rLoenNash_forecast

    fDiskDeltag[a,t] # E_fDiskDeltag_deep
    rAMDisk[t] # E_rAMDISK
    fDiskpL[sp,t] # E_fDiskpL

    -rProdVaekst, qProdHh_t # Vi sætter samlet produktivitetsvækst direkte og ser dermed bort fra sammensætningseffekter fra demografi
    qProdxDK$(tx1[t]) # E_qProdxDK
  ;
  $GROUP G_labor_market_deep G_labor_market_deep$(tx0[t]);

  $BLOCK B_labor_market_deep
    E_rLoenNash_forecast[t]$(tx1[t])..
      rLoenNash[t] =E= rLoenNash[t1] / rLoenNash_ARIMA[t1] * rLoenNash_ARIMA[t];

    E_fDiskDeltag_deep[a,t]$(tx0E[t] and a15t100[a] and a.val < 100 and t.val > 2015)..
      fDiskDeltag[a+1,t+1] =E= fDisk[a,t]
                             * (mUC[a+1,t+1] * vWHh[a+1,t+1] * fq / pC['cIkkeBol',t+1] * fhLHh[a+1,t+1])
                             / (mUC[a,t] * vWHh[a,t] / pC[cTot,t] * (1-fhLHh[a+1,t+1]));

    # Grænsearbejderes produktivitet antages at følge danske husholdningers
    E_qProdxDK[t]$(tx1[t]).. qProdxDK[t] =E= (1 + rProdVaekst[t]) * qProdxDK[t-1]/fq;
  $ENDBLOCK
  MODEL M_labor_market_deep /
    M_labor_market - M_labor_market_post    
    B_labor_market_deep
    E_rAMDISK
    E_fDiskpL
  /;
$ENDIF
 
# ======================================================================================================================
# Simple dynamic calibration
# ======================================================================================================================
$IF %stage% == "simple_dynamic_calibration":
  $GROUP G_labor_market_dynamic_calibration
    G_labor_market_endo

    # Vi har BFR som (eneste aldersfordelte) kilde i foreløbige år - derfor kan beskæftigelse eksogeniseres
    -nLHh[a_,t]$(t1[t] and a[a_]), uDeltag[a,t]$(t1[t])
    -hLHh[a_,t]$(t1[t] and a[a_]), jhLHh_a[a,t]$(t1[t])

    -nSoegBaseHh$(aTot[a_] and t1[t]), nSoegBasexDK[t]$(t1[t])

    -pW[t]$(t1[t]), rLoenNash[t]$(t1[t])
 
   # Lønsummerne stemmer ikke eftersom qProdHh_a ikke hentes fra static_calibration, 
   # hvilket gør, at qProd[tot] ikke stemmer - kan afstemmes via qProdHh_t
   -vLoensum$(tje[s_] and t1[t]), qProdHh_t$(t1[t])
   #  -qProdHh$(aTot[a_] and t1[t]), qProdHh_t$(t1[t])
  ;
  #  $BLOCK B_labor_market_dynamic_calibration
  #  $ENDBLOCK
  MODEL M_labor_market_dynamic_calibration /
    M_labor_market - M_labor_market_post
  /
  ;
$ENDIF