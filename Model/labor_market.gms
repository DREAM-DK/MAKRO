# ======================================================================================================================
# Labor market
# - labor force participation, job searching and matching, and wage bargaining
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_labor_market_prices
    pL[sp,t] "User cost for effektiv arbejdskraft i produktionsfunktion."
  ;

  $GROUP G_labor_market_quantities
    dqLdnL[s_,t] "qL differentieret ift. nL."
    dqLLeaddnL[sp,t] "qL[t+1] differentieret ift. nL[t]"
  ;

  $GROUP G_labor_market_values
    vWHh[a_,t]$((aTot[a_] or a15t100[a_]) and t.val > 2015) "Årsløn pr. beskæftiget."
    vhW[t] "Løn pr. produktiv enhed arbejdskraft (dvs. pr. time korrigeret for uddannelse og andre sammensætningseffekter), Kilde: ADAM[lna]"
    vhWNy[t] "Løn for opdaterede kontrakter (enten genforhandlet eller indekseret)."
    vWUdl[t]$(t.val > 1999) "Lønsum til grænsearbejdere."

    vhWForhandlet[t] "Løn for ny-forhandlede Calvo-kontrakter."

    vVirkLoenPos[t]$(t.val > 2015) "Hjælpevariabel til lønforhandling. Positiv del af virksomhedernes værdifunktion i lønforhandling."
    vVirkLoenPos0[t] "Hjælpevariabel til lønforhandling. Bidrag til vVirkLoenPos fra indeværende periode."
    vVirkLoenNeg[t]$(t.val > 2015) "Hjælpevariabel til lønforhandling. Negativ del af virksomhedernes værdifunktion i lønforhandling."
    vVirkLoenNeg0[t] "Hjælpevariabel til lønforhandling. Bidrag til vVirkLoenNeg fra indeværende periode."

    vFFLoenPos[t]$(t.val > 2015) "Hjælpevariabel til lønforhandling. Positiv del af fagforeningens værdifunktion i lønforhandling."
    vFFLoenPos0[t]$(t.val > 2015) "Hjælpevariabel til lønforhandling. Bidrag til vFFLoenPos fra indeværende periode."
    vFFLoenNeg[t]$(t.val > 2015) "Hjælpevariabel til lønforhandling. Negativ del af fagforeningens værdifunktion i lønforhandling."
    vFFLoenNeg0[t]$(t.val > 2015) "Hjælpevariabel til lønforhandling. Bidrag til vFFLoenNeg fra indeværende periode."

    vW[s_,t] "Branche-specifik løn inklusiv lønsumsafgift."
    vSelvstLoen[s_,t] "Lønudbetaling til selvstændige."
    vLoensum[s_,t] "Lønsum, Kilde: ADAM[Yw]"
  ;

  $GROUP G_labor_market_endo
    G_labor_market_quantities
    G_labor_market_values
    G_labor_market_prices

    rL2nL[t]$(t.val > 2015) "Effektive timer pr. beskæftiget."
    dOpslagOmk2dnL[sp,t] "rOpslagOmk * nL differentieret ift. nL."
    dOpslagOmk2dnLLag[sp,t] "rOpslagOmk * nL differentieret ift. nL[t-1]"

    nSoegBaseHh[a_,t]$((aTot[a_] or a15t100[a_]) and t.val > 2015) "Sum af jobsøgende og beskæftigede."
    nLHh[a_,t]$(aTot[a_] or (a15t100[a_] and t.val > 2015)) "Beskæftigelse."
    nSoegHh[a_,t]$(aTot[a_] or (a15t100[a_] and t.val > 2015)) "Jobsøgende."
    fDeltag[a,t]$(a15t100[a] and t.val > 2015) "Deltagelse."

    nLUdl[t] "Udenlandsk arbejdskraft - inkluderer pt. sort arbejde."
    nSoegUdl[t] "Udenlandske jobsøgende."

    hLHh[a_,t]$((aTot[a_] or a15t100[a_]) and t.val > 2015) "Aldersfordelt arbejdstid, Kilde: FMs Befolkningsregnskab."
    hL[t]$(t.val > 1999) "Erlagte arbejdstimer i alt, Kilde: ADAM[hq]"
    hLUdl[t]$(t.val > 1999) "Samlede erlagte arbejdstimer for grænsearbejdere."

    rJobFinding[t] "Andel af jobsøgende som får et job."
    rMatch[t] "Andel af jobopslag, som resulterer i et match."
    rOpslag2soeg[t] "Labor market tightness."
    nOpslag[s_,t] "Samlet antal jobopslag."
    rOpslagOmk[s_,t] "Andel af arbejdskraft som anvendes til hyrings-omkostninger."

    rSeparation[a_,t]$(aTot[a_] and t.val > 2015) "Job-separations-rate."
  
    fZh[a,t]$((tx0[t] and a15t100[a]) and t.val > 2015) "Z-led."
    cZh[a,t]$((a15t100[a]) and t.val > 2015) "Reallønsobjekt der benyttes i Z-led."

    nL[s_,t]$(sTot[s_] or spTot[s_]) "Beskæftigelse fordelt på brancher, Kilde: ADAM[Q] eller ADAM[Q<i>]"
    nPop[a_,t]$(not a[a_] and t.val > 1991) "Befolkningen."
    nSoc[soc_,t] "Socio-grupper og aggregater, antal 1.000 personer, Kilde: BFR."
    rLedig[t]$(t.val > 1999) "Ledighedsrate."
    rLedigGab[t]$(t.val > 1999) "Strukturelt ledighedsgab."

    fProdHh[a_,t]$(t.val > 2015) "Aldersfordelt produktivitet vedrørende uddannelse og sammensætningseffekter."
    fW[s_,t] "Branchespecifikt produktivitetsindeks for arbejdskraft. Vægtet gennemsnit er altid 1."

    mtInd[a_,t] "Marginal (ekstensiv margin) gennemsnitlig skattesats på lønindkomst."
  ;
  $GROUP G_labor_market_endo G_labor_market_endo$(tx0[t]); # Restrict endo group to tx0[t]

  $GROUP G_labor_market_exogenous_forecast
    nPop, nLUdl
    rSeparation$(a[a_])

    # Fremskriv som 0
    jnSoc[soc_,t] "J-led."
  ;
  $GROUP G_labor_market_ARIMA_forecast
    rLoenNash[t] "Nash-forhandlingsvægt."
    rSelvst[s_,t] "Andel af beskæftigede, som er selvstændige."
  ;

  $GROUP G_labor_market_other
    fProdHh_a[a,t] "Alders-specifikt led i fProdHh."
    fProdHh_t[t] "Tids-afhængigt led i fProdHh."

    fDiskpL[sp,t] "Eksogent diskonteringsfaktor i efterspørgsel efter arbejdskraft."
    fDiskDeltag[a,t] "Eksogent diskonteringsfaktor i deltagelsesbeslutning."
    mrKomp[a_,t] "Marginal netto-kompensationsgrad."

    eDeltag "Kort-sigts (invers) elasticitet på arbejdsstyrke-deltagelse."
    emrKomp "(invers) Elasticitet på arbejdsstyrke-deltagelse fra ændringer i kompensationsgrad."
    eMatching "Eksponent i matching funktion."

    nSoegBaseUdl[t] "Sum af udenlandske jobsøgende og beskæftigede."

    uDeltag[a,t] "Præferenceparameter for arbejdsstyrke-deltagelse."
    uh[a,t] "Præferenceparameter for timer."
    eh           "Invers arbejdsudbudselasticitet - intensiv margin."
    fhLUdl[t] "Faktor som korrigerer for forskel i gennemsnitlig arbejdstid/produktivitet mellem grænsearbejdere og danskboende beskæftigede."
    fProdUdl[t] "Faktor som korrigerer for forskel i gennemsnitlig løn mellem grænsearbejdere og danskboende beskæftigede."
    fW0[s_,t] "Branchespecifik produktivitetsindeks for arbejdskraft."

    uOpslagOmk    "Lineær omkostning pr. jobopslag."
    uMatchOmk     "Lineær omkostning pr. jobmatch."
    uMatchOmkSqr "Kvadratisk omkostning ved jobopslag."

    rLoenTraeghed "Parameter for træghed i Calvo-lønnen."
    rLoenIndeksering "Parameter for graden af løn indeksering."

    cmtInd[a,t] "Residual-led i marginal gennemsnitlig skattesats på lønindkomst."

    rfZhTraeghed "Træghed i indkomsteffekt på intensiv margin."

    rAMDisk[t] "Eksogen diskonterings-rate for parter i lønforhandling."
    rFFLoenAlternativ "Forhandlingsalternativ (outside option) for fagforening i lønforhandling."

    cMatchOmkSqr[s_,t] "Parameter som kalibreres for at fjerne kvadratiske matching-omkostnigner i grundforløb."

    jvhW[t] "J-led i løn."
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_labor_market
# ----------------------------------------------------------------------------------------------------------------------
# Aggregation
# ----------------------------------------------------------------------------------------------------------------------
    E_hL[t]$(tx0[t] and t.val > 1999).. hL[t] =E= hLHh[atot,t] + hLUdl[t];

    E_hLHh_aTot[t]$(tx0[t] and t.val > 2015).. hLHh[atot,t] =E= sum(a, hLHh[a,t] * nLHh[a,t]);
    E_hLUdl[t]$(tx0[t] and t.val > 1999).. hLUdl[t] =E= nLUdl[t] * fhLUdl[t] * hLHh[atot,t] / nLHh[aTot,t];

    E_rL2nL[t]$(tx0[t] and t.val > 2015)..
      rL2nL[t] * nL[sTot,t] =E= fProdHh[aTot,t] * hLHh[aTot,t] + fProdUdl[t] * hLUdl[t];

    E_nL_spTot[t]$(tx0[t]).. nL[spTot,t] =E= sum(sp, nL[sp,t]);

    # Equilibrium conditions
    E_nL_tot[t]$(tx0[t]).. nL[sTot,t] =E= nLHh[aTot,t] + nLUdl[t];

    #  E_nOpslag_sTot[t]$(tx0[t]).. nL[sTot,t] =E= sum(s, nL[s,t]);
    E_nOpslag_sTot[t]$(tx0[t]).. nOpslag[sTot,t] =E= sum(s, nOpslag[s,t]);

# ----------------------------------------------------------------------------------------------------------------------
# Various Aggregates and Income Terms 
# ----------------------------------------------------------------------------------------------------------------------
    # Wage payment pr. person by age
    E_vWHh[a,t]$(tx0[t] and a15t100[a] and t.val > 2015).. vWHh[a,t] =E= vhW[t] * fProdHh[a,t] * hLHh[a,t];

    # Wage total                   
    E_fProdHh_tot[t]$(tx0[t] and t.val > 2015).. vWHh[aTot,t] =E= sum(a, vWHh[a,t] * nLHh[a,t]);
    E_fProdHh[a,t]$(tx0[t] and t.val > 2015).. fProdHh[a,t] =E= fProdHh_t[t] * fProdHh_a[a,t];

    E_vWHh_tot[t]$(tx0[t] and t.val > 2015).. vWHh[aTot,t] =E= vhW[t] * fProdHh[aTot,t] * hLHh[aTot,t];

    E_vWUdl[t]$(tx0[t] and t.val > 1999).. vWUdl[t] =E= vhW[t] * fProdUdl[t] * hLUdl[t];

# ----------------------------------------------------------------------------------------------------------------------
# Marginale indkomstskatter og kompensationsgrader
# ----------------------------------------------------------------------------------------------------------------------
    E_mtInd[a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
      mtInd[a,t] =E= ftBund[a,t] * tBund[t]
                   + tTop[t] * rTopSkatInd[a,t]
                   + tKommune[t] * ftKommune[a,t] * (1+jfvSkatteplInd[t])
                   + (1 - ftBund[a,t] * tBund[t]
                        - tTop[t] * rTopSkatInd[a,t]
                        - tKommune[t] * ftKommune[a,t] * (1+jfvSkatteplInd[t])
                   ) * tAMbidrag[t] * ftAMBidrag[t] * (1 - vBidragTjmp[t] / vWHh[aTot,t]) 
                   + cmtInd[a,t];

# ----------------------------------------------------------------------------------------------------------------------
# Household First-order Conditions
# ---------------------------------------------------------------------------------------------------------------------- 
    E_fDeltag[a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
      fDeltag[a,t] =E= uDeltag[a,t] * (nSoegBaseHh[a,t] / nPop[a,t]) / (nSoegBaseHh[a,tDataEnd] / nPop[a,tDataEnd]);

    E_nSoegBaseHh_tot[t]$(tx0[t] and t.val > 2015).. nSoegBaseHh[aTot,t] =E= sum(a, nSoegBaseHh[a,t]);

    E_nSoegBaseHh[a,t]$(tx0E[t] and a15t100[a] and a.val < 100 and t.val > 2015)..
      (1 - mrKomp[a,t] - 1/(1+eh))**(eDeltag/emrKomp)
      =E= fDeltag[a,t]**eDeltag / rJobFinding[t]
        - (1-rSeparation[a+1,t+1]) / rJobFinding[t+1]
        * fDiskDeltag[a+1,t+1] * fDeltag[a+1,t+1]**eDeltag;

    #  #Terminal condition for last period 
    E_nSoegBaseHh_tEnd[a,t]$(tEnd[t] and a15t100[a] and a.val < 100)..
      (1 - mrKomp[a,t] - 1/(1+eh))**(eDeltag/emrKomp)
      =E= fDeltag[a,t]**eDeltag / rJobFinding[t]
        - (1-rSeparation[a+1,t]) / rJobFinding[t]
        * fDiskDeltag[a+1,t] * fDeltag[a+1,t]**eDeltag;

    #Terminal condition for last age group
    E_nSoegBaseHh_aEND[a,t]$(tx0[t] and a.val = 100 and t.val > 2015)..
      (1 - mrKomp[a,t] - 1/(1+eh))**(eDeltag/emrKomp)
      =E= fDeltag[a,t]**eDeltag / rJobFinding[t];

    #FOC for hLHh. Vi re-skalerer problemet så at værdien, der opløftes, er tæt på 1. Dette ændrer blot definitionen af uh.
    E_hLHh[a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
      (vhW[t] / pC[cTot,t] * (1-mtInd[a,t])) / fZh[a,t]
      =E= uh[a,t]**eh * (hLHh[a,t]/hLHh[a,tDataEnd])**eh / hLHh[a,tDataEnd];
      #  1 =E= uh[a,t]**eh * (hLHh[a,t]/hLHh[a,tDataEnd])**eh / hLHh[a,tDataEnd];

    # Z-terms used to model income and substitution effects  
    E_fZh[a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
      fZh[a,t] =E= rfZhTraeghed * fZh[a,t-1] + (1 - rfZhTraeghed) * cZh[a,t];
    E_cZh[a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
      cZh[a,t] =E= vhW[t] / pC[cTot,t] * (1-mtInd[a,t]);

# ----------------------------------------------------------------------------------------------------------------------
# Search and Matching        
# ----------------------------------------------------------------------------------------------------------------------
    E_rOpslag2soeg[t]$(tx0[t])..
     rOpslag2soeg[t] =E= nOpslag[sTot,t] / (nSoegHh[aTot,t] + nSoegUdl[t]);

    E_rJobFinding[t]$(tx0[t])..
      rJobFinding[t] =E= 1 - 1 / (1 + rOpslag2soeg[t]**eMatching);

    E_rMatch[t]$(tx0[t])..
      rMatch[t] * nOpslag[sTot,t] =E= rJobFinding[t] * (nSoegHh[aTot,t] + nSoegUdl[t]);
      #  rMatch[t] =E= rJobFinding[t] / rOpslag2soeg[t];

    E_nLHh_tot[t]$(tx0[t])..
      nLHh[aTot,t] =E= (1-rSeparation[aTot,t]) * nLHh[aTot,t-1] + rJobFinding[t] * nSoegHh[aTot,t];
    E_nSoegHh_Tot[t]$(tx0[t])..
      nSoegHh[aTot,t] =E= nSoegBaseHh[aTot,t] - (1-rSeparation[aTot,t]) * nLHh[aTot,t-1];

    E_nLUdl[t]$(tx0[t]).. nLUdl[t] =E= (1-rSeparation[aTot,t]) * nLUdl[t-1] + rJobFinding[t] * nSoegUdl[t]; 
    E_nSoegUdl[t]$(tx0[t]).. nSoegUdl[t] =E= nSoegBaseUdl[t] - (1-rSeparation[aTot,t]) * nLUdl[t-1];

    E_rSeparation_Tot[t]$(tx0[t] and t.val > 2015)..
      nLHh[aTot,t] =E= sum(a$a15t100[a], nLHh[a,t]);

    E_nLHh_a[a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
      nLHh[a,t] =E= (1-rSeparation[a,t]) * nLHh[a-1,t-1] * nPop[a,t]/nPop[a-1,t-1] + rJobFinding[t] * nSoegHh[a,t];
    E_nSoegHh_a[a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
      nSoegHh[a,t] =E= nSoegBaseHh[a,t] - (1-rSeparation[a,t]) * nLHh[a-1,t-1] * nPop[a,t]/nPop[a-1,t-1]; 

# ----------------------------------------------------------------------------------------------------------------------
# Firm FOC. and Vacancy Costs 
# ----------------------------------------------------------------------------------------------------------------------                                    
    E_pL[sp,t]$(tx0E[t])..
      vW[sp,t] =E= (dqLdnL[sp,t] + (1-mtVirk[sp,t+1])/(1-mtVirk[sp,t]) * fDiskpL[sp,t+1] * dqLLeaddnL[sp,t+1]*fq) * pL[sp,t];

    E_pL_tEnd[sp,t]$(tEnd[t])..
      dqLdnL[sp,t] =E= vW[sp,t] /  pL[sp,t] - fDiskpL[sp,t] * dqLLeaddnL[sp,t]*fq;

    E_dqLdnL[sp,t]$(tx0[t])..
      dqLdnL[sp,t] =E= fProd[sp,t] * qProd[t] * rLUdn[sp,t] * fW[sp,t] * rL2nL[t] * (1 - dOpslagOmk2dnL[sp,t]);

    E_dqLLeaddnL[sp,t]$(tx0[t])..
      dqLLeaddnL[sp,t] =E= - fProd[sp,t] * qProd[t] * rLUdn[sp,t] * fW[sp,t] * rL2nL[t] * dOpslagOmk2dnLLag[sp,t];

    E_rOpslagOmk[s,t]$(tx0[t])..
      rOpslagOmk[s,t] * nL[s,t] =E= uOpslagOmk * nOpslag[s,t]
                                  + uMatchOmk * rMatch[t] * nOpslag[s,t]
                                  + uMatchOmkSqr/2 * nL[s,t]
                                  * sqr(nL[s,t] / nL[s,t-1] / (nL[s,t-1] / nL[s,t-2]) - cMatchOmkSqr[s,t]);

    E_rOpslagOmk_sTot[t]$(tx0[t])..
      rOpslagOmk[sTot,t] * nL[sTot,t] =E= sum(s, rOpslagOmk[s,t] * nL[s,t]);

    E_dOpslagOmk2dnL[sp,t]$(tx0[t])..
      dOpslagOmk2dnL[sp,t] =E= uOpslagOmk / rMatch[t]
                             + uMatchOmk
                             + uMatchOmkSqr/2 * sqr(nL[sp,t] / nL[sp,t-1] / (nL[sp,t-1] / nL[sp,t-2]) - cMatchOmkSqr[sp,t])
                             + uMatchOmkSqr * nL[sp,t] / nL[sp,t-1] / (nL[sp,t-1] / nL[sp,t-2])
                             * (nL[sp,t] / nL[sp,t-1] / (nL[sp,t-1] / nL[sp,t-2]) - cMatchOmkSqr[sp,t]);

    E_dOpslagOmk2dnLLag[sp,t]$(tx0[t])..
      dOpslagOmk2dnLLag[sp,t] =E= - (1-rSeparation[aTot,t]) * (uOpslagOmk / rMatch[t] + uMatchOmk)
                                  - 2 * uMatchOmkSqr
                                  * nL[sp,t] / nL[sp,t-1]
                                  * nL[sp,t] / nL[sp,t-1] / (nL[sp,t-1] / nL[sp,t-2])
                                  * (nL[sp,t] / nL[sp,t-1] / (nL[sp,t-1] / nL[sp,t-2]) - cMatchOmkSqr[sp,t]);

    E_nOpslag[s,t]$(tx0[t])..
      nL[s,t] =E= (1-rSeparation[aTot,t]) * nL[s,t-1] + rMatch[t] * nOpslag[s,t];

# ----------------------------------------------------------------------------------------------------------------------
# Branche-fordelte lønninger
# ----------------------------------------------------------------------------------------------------------------------
    E_vW[s,t]$(tx0[t]).. vW[s,t] =E= vhW[t] * (1 + tL[s,t] * (1-rSelvst[s,t])) * fW[s,t] * rL2nL[t];

    # Lønudbetaling til selvstændige
    E_vSelvstLoen[s,t]$(tx0[t]).. vSelvstLoen[s,t] =E= rSelvst[s,t] * vhW[t] * fW[s,t] * rL2nL[t] * nL[s,t];
    E_vSelvstLoen_tot[t]$(tx0[t]).. vSelvstLoen[sTot,t] =E= sum(s, vSelvstLoen[s,t]);

    # Lønsum eksklusiv selvstændige
    E_vLoensum[s,t]$(tx0[t]).. vLoensum[s,t] =E= (1-rSelvst[s,t]) * vhW[t] * fW[s,t] * rL2nL[t] * nL[s,t];
    E_vLoensum_sTot[t]$(tx0[t]).. vLoensum[sTot,t] =E= sum(s, vLoensum[s,t]);
    E_vLoensum_spTot[t]$(tx0[t]).. vLoensum[spTot,t] =E= sum(sp, vLoensum[sp,t]);

    # Vi antager at forskellige i lønninger mellem brancher skyldes selektion og følger individerne ved brancheskift
    E_fW[s,t]$(tx0[t])..
      fW[s,t] =E= fW0[s,t] * sum(ss, nL[ss,t]) / sum(ss, fW0[ss,t] * nL[ss,t]);

# ----------------------------------------------------------------------------------------------------------------------
# Wage Bargaining and Calvo Rigidity
# ----------------------------------------------------------------------------------------------------------------------
    # Den laggede løn vhW[t-1] skal ikke vækstkorrigeres da det antages, at den er indekseret.
    E_vhW[t]$(tx0[t]).. vhW[t] =E= rLoenTraeghed * vhW[t-1]/fv * fv + (1-rLoenTraeghed) * vhWNy[t] + jvhW[t];

    E_vhWNy[t]$(tx0[t])..
      vhWNy[t] =E= (1 - rLoenIndeksering) * vhWForhandlet[t] + rLoenIndeksering * vhWNy[t-1]/fv * vhW[t-1]/(vhW[t-2]/fv);

    E_vFFLoenPos0[t]$(tx0[t] and t.val > 2015)..
      vFFLoenPos0[t] =E= sum(a, (1-mtInd[a,t]) * nLHh[a,t] * fProdHh[a,t] * hLHh[a,t]);
    E_vFFLoenPos[t]$(tx0E[t] and t.val > 2015)..
      vFFLoenPos[t] =E= vFFLoenPos0[t] + rLoenTraeghed / (1+rAMDisk[t+1]) * vFFLoenPos[t+1]*fv;  # Der skal ganges med fv såfremt at den laggede løn i E_vhW vokser med fv
    E_vFFLoenPos_tEnd[t]$(tEnd[t])..
      vFFLoenPos[t] =E= vFFLoenPos0[t] + rLoenTraeghed / (1+rAMDisk[t]) * vFFLoenPos[t]*fv;

    E_vFFLoenNeg0[t]$(tx0[t] and t.val > 2015)..
      vFFLoenNeg0[t] =E= sum(a, (1-mtInd[a,t]) * nLHh[a,t] * fProdHh[a,t] * hLHh[a,t]) * rFFLoenAlternativ * rJobFinding[t] * vhW[t];
    E_vFFLoenNeg[t]$(tx0E[t] and t.val > 2015)..
      vFFLoenNeg[t] =E= vFFLoenNeg0[t] + rLoenTraeghed / (1+rAMDisk[t+1]) * vFFLoenNeg[t+1]*fv;
    E_vFFLoenNeg_tEnd[t]$(tEnd[t])..
      vFFLoenNeg[t] =E= vFFLoenNeg0[t] + rLoenTraeghed / (1+rAMDisk[t]) * vFFLoenNeg[t]*fv;

    E_vVirkLoenPos0[t]$(tx0[t])..
      vVirkLoenPos0[t] =E= rL2nL[t] * sum(sp, (1-mtVirk[sp,t]) * pL[sp,t] * rLUdn[sp,t] * nL[sp,t] * fProd[sp,t] * qProd[t] * fW[sp,t]);
    E_vVirkLoenPos[t]$(tx0E[t] and t.val > 2015)..
      vVirkLoenPos[t] =E= vVirkLoenPos0[t] + rLoenTraeghed / (1+rAMDisk[t+1]) * vVirkLoenPos[t+1]*fv;
    E_vVirkLoenPos_tEnd[t]$(tEnd[t])..
      vVirkLoenPos[t] =E= vVirkLoenPos0[t] + rLoenTraeghed / (1+rAMDisk[t]) * vVirkLoenPos[t]*fv;

    E_vVirkLoenNeg0[t]$(tx0[t])..
      vVirkLoenNeg0[t] =E= rL2nL[t] * sum(sp, (1-mtVirk[sp,t]) * (1 + tL[sp,t] * (1-rSelvst[sp,t])) * nL[sp,t] * fW[sp,t] * (1-rOpslagOmk[sp,t]));
    E_vVirkLoenNeg[t]$(tx0E[t] and t.val > 2015)..
      vVirkLoenNeg[t] =E= vVirkLoenNeg0[t] + rLoenTraeghed / (1+rAMDisk[t+1]) * vVirkLoenNeg[t+1]*fv;  # Der skal ganges med fv såfremt at den laggede løn i E_vhW vokser med fv
    E_vVirkLoenNeg_tEnd[t]$(tEnd[t])..
      vVirkLoenNeg[t] =E= vVirkLoenNeg0[t] + rLoenTraeghed / (1+rAMDisk[t]) * vVirkLoenNeg[t]*fv;

    E_vhWForhandlet[t]$(tx0[t] and t.val > 2015)..
      vhWForhandlet[t] =E= (1-rLoenNash[t]) * vVirkLoenPos[t] / vVirkLoenNeg[t]
                         + rLoenNash[t] * vFFLoenNeg[t] / vFFLoenPos[t];

# ----------------------------------------------------------------------------------------------------------------------
# Socio-grupper og aggregater herfra
# ----------------------------------------------------------------------------------------------------------------------
    # Socio-grupper følger udvikling i beskæftigelsen (jf. data.gms) og en residual som følger befolkningen
    E_nSoc[soc,t]$(tx0[t])..
      nSoc[soc,t] =E= snSoc[soc,t] + dSoc2dBesk[soc,t] * (nLHh['tot',t] - snLHh['tot',t]) + jnSoc[soc,t];

    # Aggregater fra socio-grupper
    #  E_nSoc_tot[t]$(tx0[t]).. nSoc['tot',t]       =E= nPop[aTot,t];
    E_nSoc_bruttoled[t]$(tx0[t]).. nSoc['bruttoled',t] =E= sum(bruttoled, nSoc[bruttoled,t]);
    E_nSoc_arbsty[t]$(tx0[t]).. nSoc['arbsty',t]    =E= sum(arbsty, nSoc[arbsty,t]);

    E_nSoc_nettoled[t]$(tx0[t]).. nSoc['nettoled',t]    =E= sum(nettoled, nSoc[nettoled,t]);
    E_nSoc_nettoarbsty[t]$(tx0[t]).. nSoc['nettoarbsty',t] =E= sum(nettoarbsty, nSoc[nettoarbsty,t]);

    E_nPop_aTot[t]$(tx0[t] and t.val > 1991)..    nPop['tot',t]     =E= sum(a, nPop[a,t]);
    E_nPop_a15t100[t]$(tx0[t] and t.val > 1991).. nPop['a15t100',t] =E= sum(a$a15t100[a], nPop[a,t]);
    E_nPop_a0t17[t]$(tx0[t] and t.val > 1991)..   nPop['a0t17',t]   =E= sum(a$a0t17[a], nPop[a,t]);
    E_nPop_a18t100[t]$(tx0[t] and t.val > 1991).. nPop['a18t100',t] =E= sum(a$a18t100[a], nPop[a,t]);

    E_rLedig[t]$(tx0[t] and t.val > 1999)..  rLedig[t] =E= nSoc['bruttoled',t] / nSoc['arbsty',t];
    E_rLedigGab[t]$(tx0[t] and t.val > 1999).. rLedigGab[t] =E= rLedig[t] - srLedig[t];
  $ENDBLOCK
$ENDIF