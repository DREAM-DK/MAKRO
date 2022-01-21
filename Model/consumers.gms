# ======================================================================================================================
# Consumers
# - Consumption decisions and budget constraint
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_consumers_prices
    EpC[t]$(t.val > 2015) "Forventet prisindeks for næste periodes forbrug ekskl. bolig."

    pBolig[t] "Kontantprisen på enfamiliehuse, Kilde: ADAM[phk]"
    pLand[t] "Imputeret pris på grundværdien af land til boligbenyttelse."

    pC[c_,t]$(cNest[c_] and not cTot[c_]) "Imputeret prisindeks for forbrugskomponenter for husholdninger - dvs. ekskl. turisters forbrug."
    EpBolig[t]$(t.val > 2015) "Forventning til boligpris i næste periode."
    EpLand[t]$(t.val>2015) "Forventning til pris på grundværdien af land til boligbenyttelse i næste periode."
    pBoligUC[a,t]$(t.val > 2015) "User cost for ejerbolig."
  ;
  $GROUP G_consumers_quantities
    qC[c_,t]$(not cTot[c_]) "Husholdningernes samlede forbrug fordelt på forbrugsgrupper og aggregater inkl. lejebolig og imputeret ejerbolig."
    qC_a[a,t]$(a18t100[a] and t.val > 2015) "Individuelt forbrug ekskl. bolig."
    qCR[a_,t]$((a18t100[a_] or aTot[a_]) and t.val > 2015) "Individuel forbrug ekskl. bolig for fremadskuende agenter."
    qCHtM[a_,t]$((a18t100[a_] or aTot[a_]) and t.val > 2015) "Individuel forbrug ekskl. bolig for hand-to-mouth agenter."
    qCRxRef[a,t]$(a18t100[a] and t.val > 2015) "Forbrug ekskl. bolig og referenceforbrug for fremadskuende agenter."
    qCHtMxRef[a_,t]$(a18t100[a_] and t.val > 2015) "Individuel forbrug ekskl. bolig og referenceforbrug for hand-to-mouth agenter ."

    qBiler[t] "Kapitalmængde for køretøjer i husholdningerne, Kilde: ADAM[fKncb]"

    qBoligHtM[a_,t]$((a18t100[a_] or aTot[a_]) and t.val > 2015) "Ejerboliger ejet af hand-to-mouth husholdningerne."
    qBoligHtMxRef[a_,t]$(a18t100[a_] and t.val > 2015) "Ejerboliger ejet af hand-to-mouth husholdningerne eksl. referenceforbrug."
    qBoligR[a_,t]$((a18t100[a_] or aTot[a_]) and t.val > 2015) "Ejerboliger ejet af rationelle fremadskuende husholdningerne."
    qBolig[a_,t]$((a18t100[a_] or aTot[a_]) and t.val > 2015) "Ejerboliger ejet af husholdningerne (aggregat af kapital og land)"
    qBoligRxRef[a_,t]$(a18t100[a_] and t.val > 2015) "Ejerboliger ejet af husholdningerne ekskl. referenceforbrug."
    qYBolig[t] "Bruttoproduktion af ejerboliger inkl. installationsomkostninger (aggregat af kapital og land)"
    qIBoligInstOmk[t] "Installationsomkostninger for boliginvesteringer i nybyggeri."
    qLand[t] "Land benyttet som grunde til ejerboliger."
    qLandSalg[t] "Land solgt fra husholdningerne til at bygge grunde til ejerboliger på."
    qKBolig[t] "Kapitalmængde af ejerboliger, Kilde: ADAM[fKnbhe]"
    qIBolig[t] "Investeringer i ejerboligkapital."
    qKLejeBolig[t] "Kapitalmængde af lejeboliger, Kilde: ADAM[fKnbhl]"
    qNytte[a,t]$(t.val > 2015) "CES nest af bolig og andet privat forbrug."
    qArvBase[a,t]$(a18t100[a] and t.val > 2015) "Hjælpevariabel til førsteordensbetingelse for arve-nytte."
    qFormueBase[a,t]$(a18t100[a] and t.val > 2015) "Hjælpevariabel til førsteordensbetingelse for nytte af formue."
  ;
  $GROUP G_consumers_values
    vC_a[a,t]$(a18t100[a] and t.val > 2015) "Individuelt forbrug ekskl. bolig."
    vHhx[a_,t]$(a0t100[a_] or aTot[a_]) "Husholdningernes formue ekskl. pension, bolig og realkreditgæld (vægtet gns. af Hand-to-Mouth og rationelle forbrugere)"
    vCLejeBolig[a_,t]$(a18t100[a_] or aTot[a_]) "Forbrug af lejeboliger."

    vArvGivet[a,t]$(t.val > 2015) "Arv givet af hele kohorten med alder a."
    vArv[a_,t]$(t.val > 2015) "Arv modtaget af en person med alderen a."
    vtArv[a_,t]$(t.val > 2015) "Kapitalskatter (Arveafgift), Kilde: ADAM[sK_h_o] for total."

    vtHhx[a_,t]$((a0t100[a_] and t.val > 2015) or aTot[a_]) "Skatter knyttet til husholdningerne i MAKRO ekskl. pensionsafkastskat, ejendomsværdiskat og dødsboskat."
    vBoligUdgift[a_,t]$(t.val > 2015) "Cash-flow-udgift til bolig - dvs. inkl. afbetaling på gæld og inkl. øvrige omkostninger fx renter og bidragssats på realkreditlån."
    vBoligUdgiftHtM[a_,t]$(t.val > 2015) "Netto udgifter til køb/salg/forbrug af bolig for hand-to-mouth husholdninger."
    vBoligUdgiftArv[t]$(t.val > 2015) "Netto udgifter til køb/salg/forbrug af bolig gående til arv."

    vHhNFErest[a_,t]$(a0t100[a_] or (aTot[a_] and t.val > 2015)) "Kapitaloverførsler, direkte investeringer mv., som bliver residualt aldersfordelt."
    jvHhNFErest[a_,t]$(aTot[a_] and t.val > 2015) "Justeringsled til at få kalibreret til aldersfordelte formueændringer historisk."

    vBoernFraHh[a,t]$(a0t17[a] and t.val > 2015) "Finansielle nettooverførsler fra forældre modtaget af børn i alder a."
    vHhTilBoern[a_,t]$((aTot[a_] or a18t100[a_]) and t.val > 2015) "Finansielle nettooverførsler til børn givet af forældre i alder a."

    vBolig[a_,t]$((a18t100[a_] or atot[a_]) and t.val > 2015) "Husholdningernes boligformue."
    vBoligHtM[a_,t]$(a18t100[a_] or atot[a_]) "Hånd-til-mund husholdningernes boligformue."
    vKBolig[t] "Værdi af kapitalmængde af ejerboliger."
    vIBolig[t] "Værdi af ejerbolig-investeringer."
    vHhInvestx[a_,t]$(atot[a_]) "Husholdningernes direkte investeringer ekskl. bolig - imputeret."
    vSelvstKapInd[a_,t]$(atot[a_]) "Selvstændiges kapitalindkomst - imputeret."
    vArvKorrektion[a_,t]$((tx0[t] and t.val > 2015) and (a0t100[a_] or aTot[a_])) "Arv som tildeles afdødes kohorte for at korregerer for selektionseffekt (formue og døds-sandsynlighed er mod-korreleret)."
  ;

  $GROUP G_consumers_endo
    G_consumers_prices
    G_consumers_quantities
    G_consumers_values

    rDisk[a,t]$(t.val > 2015) "De rationelle forbrugeres aldersafhængige diskonterings-rate."

    rKLeje2Bolig[t] "Forholdet mellem qKbolig og qKlejebolig."
    rvCLejeBolig[a_,t]$(aTot[a_] and t.val > 2015) "Andel af samlet lejeboligmasse i basisåret."
    fHh[a,t]$(t.val > 2015) "Husholdningens størrelse (1 + antal børn pr. voksen med alderen a) som forbrug korrigeres med."
    uBolig[a,t]$(t.val > 2015) "Nytteparameter som styrer de fremadskuende forbrugernes bolig-efterspørgsel."
    uBoligHtM[a,t]$(t.val > 2015) "Nytteparameter som styrer hand-to-mouth forbrugernes bolig-efterspørgsel."

    fBoligUdgift[a,t]$(a.val >= 18 and t.val > 2015) "Hjælpevariabel til beregning af udgifter til ejerbolig."
    mUBolig[a,t]$(a18t100[a] and t.val > 2015) "Marginal nytte af boligkapital."
    qK[k,s_,t]$(d1K[k,s_,t] and sameas[s_,'bol'])
    dqIBoligInstOmk[t] "Installationsomkostninger for boligkapital i nybyggeri differentieret mht. investeringer."

    mUC[a,t]$(t.val > 2015) "Marginal utility of consumption."
    EmUC[a,t]$(t.val > 2015) "Expected marginal utility of consumption."
    uC[c_,t] "CES skalaparametre i det private forbrugs-nest."

    fMigration[a_,t]$(t.val > 2015 or (atot[a_] and t.val > 1991)) "Korrektion for migrationer (= 1/(1+migrationsrate) eftersom formue deles med ind- og udvandrere)."
    uBoernFraHh[a,t]$(a0t17[a] and t.val > 2015) "Parameter for børns formue relativ til en gennemsnitsperson. Bestemmer vBoernFraHh." 
    dArv[a_,t]$(t.val > 2015) "Arvefunktion differentieret med hensyn til bolig."
    dFormue[a_,t]$(t.val > 2015) "Formue-nytte differentieret med hensyn til bolig."

    jvHhx[a_,t]$(aTot[a_] and t.val > 2015) "Fejl-led."

    -qC[c_,t]$(sameas[c_,'cBol'])
    -qLand[t]
    -qKLejeBolig[t]
  ;
  $GROUP G_consumers_endo G_consumers_endo$(tx0[t]); # Restrict endo group to tx0[t]

  $GROUP G_consumers_exogenous_forecast
    nArvinger[a,t] "Sum af antal arvinger sammenvejet efter rArv."
    rBoern[a,t] "Andel af det samlede antal under 18-årige som en voksen med alderen a har ansvar for."
    qLand[t]

    rOverlev[a_,t] "Overlevelsesrate."
    ErOverlev[a,t] "Forventet overlevelsesrate - afviger fra den faktiske overlevelsesrate for 100 årige."

    rBoligPrem[t] "Risikopræmie for boliger."

    # Forecast as zero
    jfEpC[t] "J-led."
    jvHhx[a_,t]$(a[a_])       
    jvHhNFErest$(aTot[a_])
  ;
  $GROUP G_consumers_ARIMA_forecast
    uC0[c_,t] "Justeringsled til CES-skalaparameter i private forbrugs-nests."
    fuCnest[cNest,t] "Total faktor CES-skalaparametre i privat forbrugs-nests."
    rKLeje2Bolig # Endogen i stødforløb
    rBilAfskr[t] "Afskrivningsrate for køretøjer i husholdningerne."
    rHhInvestx[t] "Husholdningernes direkte investeringer ekskl. bolig ift. direkte og indirekte beholdning af indl. aktier - imputeret."
  ;
  $GROUP G_consumers_other
    # Opdeling af adlersfordelte parametre i tids- og aldersfordelte elementer
    rDisk_t[t] "Tids-afhængigt led i rDisk."
    rDisk_a[a,t] "Alders-specifikt led i rDisk."
    uBolig_a[a,t] "Alders-specifikt led i uBolig."
    uBolig_t[t] "Tids-afhængigt led i uBolig."
    uBoligHtM_a[a,t] "Alders-specifikt led i uBoligHtM."
    uBoligHtM_t[t] "Tids-afhængigt led i uBoligHtM."
    uBoligHtM_match   "led i uBoligHtM."
    uBoernFraHh_t[t] "Tids-afhængigt led i uBoernFraHh."
    uBoernFraHh_a[a,t] "Alders-specifikt led i uBoernFraHh."

    # Non-durable consumption
    eHh       "Invers af intertemporal substitutionselasticitet."
    rRef      "Grad af reference forbrug."
    rRef_2016 "Grad af reference forbrug i 2016 (midlertidig løsning)"
    rRefHtM   "Grad af reference forbrug hos HtM forbrugere."
    rRefBolig "Grad af reference forbrug for boliger."
    rHtM      "Andel af Hand-to-Mouth forbrugere."

    # Housing
    eBolig            "Substitutionselasticitet mellem boligkapital og land."
    uIBoligInstOmk    "Parameter for installationsomkostninger for boligkapital i nybyggeri."
    fIBoligInstOmk[t] "Vækstfaktor i boliginvesteringer som giver nul installationsomkostningerne."
    fBoligGevinst     "Faktor som boliggevinster skaleres med."
    EpLandInfl[t] "Forventning til landprisinflation i baseline - bibeholdes af ikke fremadskuende agenter."
    EpBoligInfl[t] "Forventning til boligprisinflation i baseline - bibeholdes af ikke fremadskuende agenter."
    # CES demand
    eC[c_] "Substitutionselasticitet i privat forbrugs-nests."

    uLand[t] "Skalaparameter i CES efterspørgsel efter land."
    uIBolig[t] "Skalaparameter i CES efterspørgsel efter boligkapital."

    # Bequests
    rArv[a,t] "Andel af den samlede arv som tilfalder hver arving med alderen a."
    rArv_a[a,aa] "Andel af arven fra aldersgruppe a der tilfalder hver arving med alderen aa i basisåret."

    uFormue[a,t] "Nytte af formue parameter 0."
    cFormue[a,t] "Nytte af formue parameter 1."
    rMaxRealkred[t] "Andel af bolig som anses for likvid ift. nytte af likvid formue."
    uArv[a,t] "Arve-nytteparameter 0."
    cArv[a,t] "Arve-nytteparameter 1."
    tArv[t] "Arveafgift (implicit, gennemsnit)"

    rSelvstKapInd[t] "Selvstændiges kapitalindkomst ift. direkte og indirekte beholdning af indl. aktier - imputeret."

    eNytte "Substitutionselasticitet mellem bolig- og andet forbrug."

    rArvKorrektion[a] "Gennemsnitlig formue personer, som dør, relativt til en gennemsnitsperson i samme alder."
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_consumers
    # ------------------------------------------------------------------------------------------------------------------
    # Aggregeret budgetrestriktion (vægtet gennemsnit af fremadskuende og hånd-til-mund husholdninger)
    # ------------------------------------------------------------------------------------------------------------------
    E_vHhx[a,t]$(tx0[t] and a0t100[a] and t.val > 2015)..
      vHhx[a,t] =E= (vHhx[a-1,t-1]/fv + vHhxAfk[a,t]) * fMigration[a,t]
                  + vHhInd[a,t]
                  - vC_a[a,t]            # Ikke-bolig-forbrugsudgift 
                  - vCLejeBolig[a,t]     # Lejebolig-forbrugsudgift
                  - vBoligUdgift[a,t]    # Cashflow til ejerbolig inkl. realkreditafbetaling
                  + vBoernFraHh[a,t] - vHhTilBoern[a,t]  # Overførsler mellem voksne og børn - findes ikke for HtM-agenter
                  + jvHhx[a,t];

    # vHhx[aTot,t] kan opskrives på samme måde som E_vHhx[a,t] - tre ting er værd at bemærke
    # 1) summen af overførsler til og fra børn er 0
    # 2) Arv og arvekorrektion er en del af husholdningernes indkomst og bortset fra arv og dødsboskat kommer det fra husholdningerne
    # 3) jvHhx[aTot,t] = sum(a, jvHhx[a,t] * nPop[a,t]) - ellers fås en fejlmeddelelse efter kalibrering
    E_jvHhx_aTot[t]$(tx0[t] and t.val > 2015)..
      vHhx[aTot,t] =E= vHhx[aTot,t-1]/fv + vHhxAfk[aTot,t] 
                     + vHhInd[aTot,t]
                     - qC['cIkkeBol',t] * pC['cIkkeBol',t] 
                     - vCLejebolig[aTot,t] 
                     - vBoligUdgift[aTot,t] 
                     - (vArv[aTot,t] + vArvKorrektion[aTot,t] + vtDoedsbo[aTot,t] - vPensArv['Pens',aTot,t] + vtKapPensArv[aTot,t])
                     + jvHhx[aTot,t];

    # Aggregat dannet ud fra vhh['NetFin',aTot,t] som er dannet ud fra vHhx[a,t]
    E_vHhx_aTot[t]$(tx0[t]).. vHhx[aTot,t] =E= vHh['NetFin',aTot,t] - vHh['Pens',aTot,t] + vHh['RealKred',aTot,t];

    # Aldersfordelt vtHh, dog er vtEjd, vtDoedsbo, vtPensArv og vtPAL fjernet, da de fratrækkes i vBoligUdgift, vArv og vPensUdb
    E_vtHhx[a,t]$(tx0[t] and a0t100[a] and t.val > 2015)..
      vtHhx[a,t] =E= vtBund[a,t] 
                   + vtTop[a,t] 
                   + vtKommune[a,t] 
                   + vtAktie[a,t] 
                   + vtVirksomhed[a,t] 
                   + vtHhAM[a,t]
                   + vtPersRest[a,t]
                   + vtHhVaegt[a,t]                
                   + utMedie[t] * vSatsIndeks[t] * a18t100[a]
                   + vtArv[a,t]
                   + vBidrag[a,t]
                   + vtKirke[a,t]
                   + vtLukning[a,t]
                   + (vtKildeRest[t] + vtDirekteRest[t]) / nPop[aTot,t];

    E_vtHhx_tot[t]$(tx0[t])..
      vtHhx[aTot,t] =E= vtBund[aTot,t] 
                      + vtTop[aTot,t] 
                      + vtKommune[aTot,t] 
                      + vtAktie[aTot,t] 
                      + vtVirksomhed[aTot,t] 
                      + vtHhAM[aTot,t]
                      + (vtPersRest[aTot,t] - vtKapPensArv[aTot,t])
                      + vtHhVaegt[aTot,t]                
                      + vtMedie[t]
                      + vtArv[aTot,t]
                      + vBidrag[aTot,t]
                      + vtKirke[aTot,t]
                      + vtLukning[aTot,t]
                      + vtKildeRest[t] + vtDirekteRest[t];

    # Samlet post for ejerbolig som fratrækkes i budgetrestriktion. Bemærk at rentefradrag fra realkredit indgår i vtHhx, ikke i vBoligUdgift.
    E_vBoligUdgift[a,t]$(tx0[t] and t.val > 2015)..
      vBoligUdgift[a,t] =E= (1-rRealKred2Bolig[a,t]) * vBolig[a,t] + fBoligUdgift[a,t] * vBolig[a-1,t-1]/fv * fMigration[a,t];

    E_fBoligUdgift[a,t]$(18 <= a.val and tx0[t] and t.val > 2015)..
      fBoligUdgift[a,t] =E= (1+rHhAfk['RealKred',t]) * rRealKred2Bolig[a-1,t-1] # Realkredit fra sidste periode + renter
                            + tEjd[t] # Ejendomsskat
                            + rBoligOmkRest[t] # Resterende udgifter
                            + vIBolig[t] / (vBolig[aTot,t-1]/fv) # Kapitalinvesteringer
                            - vBolig[aTot,t] / (vBolig[aTot,t-1]/fv); # Kapitalgevinster (plus evt. profit fra entreprenør-agenten, som opstår pga. installationsomkostninger i sammensætning af land og bygningskapital)

    E_vBoligUdgift_tot[t]$(tx0[t] and t.val > 2015)..
      vBoligUdgift[aTot,t] =E= sum(a, vBoligUdgift[a,t] * nPop[a,t]) + vBoligUdgiftArv[t];

    E_vBoligUdgiftArv[t]$(tx0[t]).. vBoligUdgiftArv[t] =E= sum(a, (1-rOverlev[a-1,t-1]) * nPop[a-1,t-1] * fBoligUdgift[a,t] * vBolig[a-1,t-1]/fv);

    E_vHhNFErest[a,t]$(tx0[t] and a0t100[a] and t.val > 2015)..
      vHhNFErest[a,t] =E= ( vOffTilHh[t] - vOffFraHh[t]
                        - vHhInvestx[aTot,t] + vSelvstKapInd[aTot,t] + vHhFraVirk[t] - vhhTilUdl[t])
                        * (vWHh[a,t] * nLHh[a,t] / nPop[a,t] + vHhOvf[a,t]) / (vWHh[aTot,t] + vOvf['hh',t])
                        + jvHhNFErest[a,t];

    E_vHhNFErest_tot[t]$(tx0[t] and t.val > 2015)..
      vHhNFErest[aTot,t] =E= vOffTilHh[t] - vOffFraHh[t]
                           - vHhInvestx[aTot,t] + vSelvstKapInd[aTot,t]
                           + vHhFraVirk[t]
                           - vhhTilUdl[t]
                           + jvHhNFErest[aTot,t] ; 

    # Total residual foreign transfer to households
    E_jvHhNFErest_tot[t]$(tx0[t] and t.val > 2015).. jvHhNFErest[aTot,t] =E= sum(a, jvHhNFErest[a,t] * nPop[a,t]);

    E_vHhInvestx_tot[t]$(tx0[t])..
      vHhInvestx[aTot,t] =E= rHhInvestx[t] * vI_s[iTot,spTot,t];  

    E_vSelvstKapInd_tot[t]$(tx0[t])..
      vSelvstKapInd[aTot,t] =E= rSelvstKapInd[t] * vEBITDA[sTot,t];    

    # Lejebolig ud fra eksogent kapitalapparat
    E_vCLejeBolig_tot[t]$(tx0[t]).. vCLejebolig[aTot,t] =E= pC['cBol',t] * qKLejeBolig[t-1] / qK['iB','bol',t-1] * qC['cBol',t];
    E_vCLejeBolig[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      vCLejeBolig[a,t] / vCLejeBolig[aTot,t] =E= rvCLejeBolig[a,t] / rvCLejeBolig[aTot,t];
    E_rvCLejeBolig_tot[t]$(tx0[t] and t.val > 2015).. rvCLejeBolig[aTot,t] =E= sum(aa, rvCLejeBolig[aa,t] * nPop[aa,t]);
                      
    # ------------------------------------------------------------------------------------------------------------------
    # Individual non-housing consumption decision by age
    # ------------------------------------------------------------------------------------------------------------------  
    # Rational forward-looking consumers
    E_qCR[a,t]$(a18t100[a] and tx0E[t] and t.val > 2015)..
      mUC[a,t] =E= (ErOverlev[a,t] * (1 + mrHhxAfk[t+1]) / EpC[t] * EmUC[a,t]
                 + ErOverlev[a,t] * dFormue[a,t]
                 + (1-ErOverlev[a,t]) * dArv[a,t]) * pC['cIkkeBol',t] / (1+rDisk[a,t]);

    E_qCR_tEnd[a,t]$(a18t100[a] and tEnd[t])..
      mUC[a,t] =E= (ErOverlev[a,t] * (1 + mrHhxAfk[t]) / EpC[t] * EmUC[a,t]
                 + ErOverlev[a,t] * dFormue[a,t]
                 + (1-ErOverlev[a,t]) * dArv[a,t]) * pC['cIkkeBol',t] / (1+rDisk[a,t]);

    E_qCR_tot[t]$(tx0[t] and t.val > 2015)..
      qCR[aTot,t] =E= sum(a, (1-rHtM) * qCR[a,t] * nPop[a,t]) ;                             

    E_qCRxRef[a,t]$(tx0[t] and a18t100[a] and a.val <> 18 and t.val > 2016)..
      qCRxRef[a,t] =E= qCR[a,t] / fHh[a,t] - rRef * qCR[a-1,t-1]/fq / fHh[a-1,t-1];

    E_qCRxRef_a18[a,t]$(tx0[t] and a.val = 18 and t.val > 2016)..
      qCRxRef[a,t] =E= qCR[a,t] - rRef * qCR[a,t]/fq;

    E_qCRxRef_2016[a,t]$(tx0[t] and a18t100[a] and a.val <> 18 and t.val = 2016)..
      qCRxRef[a,t] =E= qCR[a,t] / fHh[a,t] - rRef_2016 * qCR[a-1,t-1]/fq / fHh[a-1,t-1];

    E_qCRxRef_a18_2016[a,t]$(tx0[t] and a.val = 18 and t.val = 2016)..
      qCRxRef[a,t] =E= qCR[a,t] - rRef_2016 * qCR[a,t]/fq;

    E_mUC[a,t]$(tx0[t] and a18t100[a] and t.val > 2015)..
      mUC[a,t] =E= qNytte[a,t]**(-eHh) * (qNytte[a,t] * (1-uBolig[a,t]) / qCRxRef[a,t])**(1/eNytte);

    E_qNytte[a,t]$(tx0[t] and a18t100[a] and t.val > 2015)..
      qNytte[a,t] =E= (
        (1-uBolig[a,t])**(1/eNytte) * qCRxRef[a,t]**((eNytte-1)/eNytte)
        + uBolig[a,t]**(1/eNytte) * qBoligRxRef[a,t]**((eNytte-1)/eNytte)
      )**(eNytte/(eNytte-1));

    # Forventet marginal nytte af forbrug
    E_EmUC[a,t]$(18 <= a.val and a.val < 100 and tx0E[t] and t.val > 2015)..
      EmUC[a,t] =E= (qNytte[a+1,t+1]*fq)**(-eHh) * ((1-uBolig[a+1,t+1]) * qNytte[a+1,t+1] / qCRxRef[a+1,t+1])**(1/eNytte);
    E_EmUC_tEnd[a,t]$(18 <= a.val and a.val < 100 and tEnd[t])..
      EmUC[a,t] =E= (qNytte[a+1,t]*fq)**(-eHh) * ((1-uBolig[a+1,t]) * qNytte[a+1,t] / qCRxRef[a+1,t])**(1/eNytte);
    E_EmUC_aEnd[a,t]$(a.val = 100 and tx0E[t] and t.val > 2015)..
      EmUC[a,t] =E= (qNytte[a,t+1]*fq)**(-eHh) * ((1-uBolig[a,t+1]) * qNytte[a,t+1] / qCRxRef[a,t+1])**(1/eNytte);
    E_EmUC_aEnd_tEnd[a,t]$(a.val = 100 and tEnd[t])..
      EmUC[a,t] =E= (qNytte[a,t]*fq)**(-eHh) * ((1-uBolig[a,t]) * qNytte[a,t] / qCRxRef[a,t])**(1/eNytte);

    # 15-17 er aktive på arbejdsmarkedet, men har ikke forbrug.
    # Marginalnytte af forbrug kan dog påvirke arbejdsmarkedsbeslutning og antages lig 18-åriges.
    E_mUC_unge[a,t]$(tx0[t] and 15 <= a.val and a.val < 18  and t.val > 2015)..
      mUC[a,t] =E= mUC['18',t];

    E_EpC[t]$(tx0E[t] and t.val > 2015)..
      EpC[t] =E= pC['cIkkeBol',t+1]*fp * (1 + jfEpC[t]);
    E_EpC_tEnd[t]$(tEnd[t])..
      EpC[t] =E= pC['cIkkeBol',t] * pC['cIkkeBol',t]/(pC['cIkkeBol',t-1]/fp) * (1 + jfEpC[t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Hand-to-mouth consumers
    # ------------------------------------------------------------------------------------------------------------------
    # Budgetbegrænsning
    E_qCHtM[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      pC['cIkkeBol',t] * qCHtM[a,t] + vCLejeBolig[a,t] + vBoligUdgiftHtM[a,t] # Samlet forbrug
      =E=
      vHhInd[a,t]
      - (vPensUdb['Pens',a,t] - vPensIndb['Pens',a,t]) + vPensUdb['PensX',a,t] - vPensIndb['PensX',a,t] # Hånd-til-mund forbrugere har ikke kapital og alders-pension
      + vtAktie[a,t]  # Aktieafkast betales alene af rationelle husholdninger
      + vtKapPens[a,t] # HtM har ikke kapitalpension og betaler ikke afgift
      - vArvKorrektion[a,t]  # Øget formue fra selektionseffekt antages ikke at gå til hånd-til-mund forbrugere 
    ;

    E_qCHtM_tot[t]$(tx0[t] and t.val > 2015)..
      qCHtM[atot,t] =E= sum(a, rHtM * qCHtM[a,t] * nPop[a,t]);

    E_qCHtMxRef[a,t]$(tx0[t] and a18t100[a] and a.val <> 18 and t.val > 2015)..
      qCHtMxRef[a,t] =E= qCHtM[a,t] / fHh[a,t] - rRefHtM * qCHtM[a-1,t-1]/fq / fHh[a-1,t-1];

    E_qCHtMxRef_a18[a,t]$(tx0[t] and a.val = 18 and t.val > 2015)..
      qCHtMxRef[a,t] =E= qCHtM[a,t] - rRefHtM * qCHtM[a,t]/fq;

    E_qBoligHtMxRef[a,t]$(a18t100[a] and a.val <> 18 and tx0[t] and t.val > 2015)..
      qBoligHtMxRef[a,t] =E= qBoligHtM[a,t] / fHh[a,t] - rRefBolig * rOverlev[a-1,t-1] * qBoligHtM[a-1,t-1]/fq / fHh[a-1,t-1];

    E_qBoligHtMxRef_a18[a,t]$(a.val = 18 and tx0[t] and t.val > 2015)..
      qBoligHtMxRef[a,t] =E= qBoligHtM[a,t] - rRefBolig * rOverlev[a-1,t-1] * qBoligHtM[a,t]/fq;

    E_qBoligHtM[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      qBoligHtMxRef[a,t] =E= uBoligHtM[a,t] * qCHtMxRef[a,t] * (pBolig[t] / pC['cIkkeBol',t])**(-eNytte);
 
    E_vBoligUdgiftHtM[a,t]$(tx0[t] and t.val > 2015)..
      vBoligUdgiftHtM[a,t] =E= (1-rRealKred2Bolig[a,t]) * vBoligHtM[a,t]
                             + fBoligUdgift[a,t] * vBoligHtM[a-1,t-1]/fv * fMigration[a,t];

    E_vBoligUdgiftHtM_tot[t]$(tx0[t] and t.val > 2015)..
      vBoligUdgiftHtM[aTot,t] =E= rHtM * sum(a, vBoligUdgiftHtM[a,t] * nPop[a,t]);

    E_vBoligHtM[a,t]$(a18t100[a] and tx0[t]).. vBoligHtM[a,t] =E= pBolig[t] * qBoligHtM[a,t];
    E_vBoligHtM_tot[t]$(tx0[t]).. vBoligHtM[aTot,t] =E= pBolig[t] * qBoligHtM[aTot,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Coupling of hand-to-mouth and forward looking consumers
    # ------------------------------------------------------------------------------------------------------------------
    # Ikke-bolig-forbrug fordelt på alder som disaggregeres i CES-nest
    E_qC_a[a,t]$(a18t100[a] and tx0[t] and t.val > 2015).. qC_a[a,t] =E= (1-rHtM) * qCR[a,t] + rHtM * qCHtM[a,t];
    E_vC_a[a,t]$(a18t100[a] and tx0[t] and t.val > 2015).. vC_a[a,t] =E= pC['cIkkeBol',t] * qC_a[a,t];

    # qBolig er et CES-aggregat af land og bygningskapital
    E_qBolig[a,t]$(a18t100[a] and tx0[t] and t.val > 2015).. qBolig[a,t] =E= (1-rHtM) * qBoligR[a,t] + rHtM * qBoligHtM[a,t];

    E_vBolig[a,t]$(a18t100[a] and tx0[t] and t.val > 2015).. vBolig[a,t] =E= pBolig[t] * qBolig[a,t];

    # Aggregater
    E_qBoligR_tot[t]$(tx0[t] and t.val > 2015).. qBoligR[aTot,t] =E= sum(a, (1-rHtM) * qBoligR[a,t] * nPop[a,t]);
    E_qBoligHtM_tot[t]$(tx0[t] and t.val > 2015).. qBoligHtM[aTot,t] =E= sum(a, rHtM * qBoligHtM[a,t] * nPop[a,t]);
    E_qBolig_tot[t]$(tx0[t] and t.val > 2015).. qBolig[aTot,t] =E= qBoligR[aTot,t] + qBoligHtM[aTot,t];
    E_vBolig_tot[t]$(tx0[t] and t.val > 2015).. vBolig[aTot,t] =E= sum(a, vBolig[a,t] * nPop[a,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Coupling of consumption by age and CES tree
    # ------------------------------------------------------------------------------------------------------------------
    E_qC_cIkkeBol[t]$(tx0[t] and t.val > 2015).. qC['cIkkeBol',t] =E= sum(a, qC_a[a,t] * nPop[a,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # CES-efterspørgsel efter (ikke-bolig) forbrug
    # ------------------------------------------------------------------------------------------------------------------
    # Budget constraint
    E_pC_nests[cNest,t]$(tx0[t]).. pC[cNest,t] * qC[cNest,t] =E= sum(c$c_2c[cNest,c], pC[c,t] * qC[c,t]);

    # FOC
    E_qC[c_,cNest,t]$(tx0[t] and cNest2c_[cNest,c_])..
      qC[c_,t] =E= uC[c_,t] * qC[cNest,t] * (pC[cNest,t] / pC[c_,t])**eC(cNest);

    # Balancing mechanism for CES parameters
    E_uC[c_,cNest,t]$(tx0[t] and cNest2c_[cNest,c_])..
      uC[c_,t] =E= fuCnest[cNest,t] * uC0[c_,t] / sum(cc_$cNest2c_[cNest,cc_], uC0[cc_,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Bolig-efterspørgsel for fremadskuende husholdninger
    # ------------------------------------------------------------------------------------------------------------------
    # Nyttefunktion for fremadskuende husholdninger
    E_qBoligR[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      mUBolig[a,t]**eNytte * qBoligRxRef[a,t] =E= qNytte[a,t]**(-eHh*eNytte) * qNytte[a,t] * uBolig[a,t] ;

    E_qBoligRxRef[a,t]$(a18t100[a] and a.val <> 18 and tx0[t] and t.val > 2015)..
      qBoligRxRef[a,t] =E= qBoligR[a,t] / fHh[a,t] - rRefBolig * rOverlev[a-1,t-1] * qBoligR[a-1,t-1]/fq / fHh[a-1,t-1];

    E_qBoligRxRef_a18[a,t]$(a.val = 18 and tx0[t] and t.val > 2015)..
      qBoligRxRef[a,t] =E= qBoligR[a,t] - rRefBolig * rOverlev[a-1,t-1] * qBoligR[a,t]/fq;

    # Usercost
    E_pBoligUC[a,t]$(a18t100[a] and tx0E[t] and t.val>2015) ..
      pBoligUC[a,t] =E= ( (1-rRealKred2Bolig[a,t]) * mrHhxAfk[t+1] # Offerrente
                         + rRealKred2Bolig[a,t] * mrRealKredAfk[t+1] # Marginal rente efter skat
                         + tEjd[t+1] # Ejendomsskat
                         + rAfskr['iB','bol',t+1] # Afskrivninger
                         + rBoligOmkRest[t+1] # Resterende udgifter
                         - EpLand[t] * qLandSalg[t+1]*fq / vBolig[atot,t] # Forventet værdi af landsalg i næste periode
                         - (1-rAfskr['iB','bol',t+1]) * (EpBolig[t] - pBolig[t]) / pBolig[t] # Forventet kapital-gevinst
                         + rBoligPrem[t+1] # Risikopræmie
                        ) * pBolig[t] / (1+mrHhxAfk[t+1]);

    E_EpLand[t]$(tx0E[t] and t.val>2015) ..
      EpLand[t] =E= (1-fBoligGevinst) * pLand[t] * (1 + EpLandInfl[t]) + fBoligGevinst * pLand[t+1]*fp;
    
    E_EpBolig[t]$(tx0E[t] and t.val>2015)..
      EpBolig[t] =E= (1-fBoligGevinst) * pBolig[t] * (1 + EpBoligInfl[t]) + fBoligGevinst * pBolig[t+1]*fp;

    E_qLandSalg[t]$(tx0[t])..
      qLandSalg[t] =E= qLand[t] - (1 - rAfskr['iB','bol',t]) * qLand[t-1]/fq;

    # Merging of FOC for housing with FOC for net assets
    E_mUBolig[a,t]$(a18t100[a] and tx0E[t] and t.val > 2015)..
      mUBolig[a,t] =E= EmUC[a,t] * ErOverlev[a,t] / (1+rDisk[a,t]) * pBoligUC[a,t] * (1+mrHhxAfk[t+1]) / EpC[t];

    E_mUBolig_tEnd[a,t]$(a18t100[a] and tEnd[t])..
      mUBolig[a,t] / mUC[a,t] =E= mUBolig[a,t-1] / mUC[a,t-1];

    # ------------------------------------------------------------------------------------------------------------------
    # CES-efterspørgsel efter bolig-kapital og land
    # ------------------------------------------------------------------------------------------------------------------
    # Produktion af ejerboliger er sammensætning af land og boligkapital-investeringer
    E_qYBolig[t]$(tx0[t])..
      qYBolig[t] =E= qBolig[aTot,t] - (1 - rAfskr['iB','bol',t]) * qBolig[aTot,t-1]/fq + qIBoligInstOmk[t];

    E_qIBoligInstOmk[t]$(tx0[t])..
      qIBoligInstOmk[t] =E= uIBoligInstOmk/2 * sqr(qIBolig[t] / (qIBolig[t-1]/fq) - fIBoligInstOmk[t]) * qIBolig[t-1]/fq;

    E_dqIBoligInstOmk[t]$(tx0E[t])..
      dqIBoligInstOmk[t] =E= 
        uIBoligInstOmk * (
          qIBolig[t] / (qIBolig[t-1]/fq) - fIBoligInstOmk[t]
        + 1/(1+rVirkDisk['bol',t+1])/2 * sqr(qIBolig[t+1]*fq / qIBolig[t] - fIBoligInstOmk[t+1])
        - 1/(1+rVirkDisk['bol',t+1]) * (qIBolig[t+1]*fq / qIBolig[t] - fIBoligInstOmk[t+1]) * qIBolig[t+1]*fq / qIBolig[t]
      );

    E_dqIBoligInstOmk_tEnd[t]$(tEnd[t])..
      dqIBoligInstOmk[t] =E= uIBoligInstOmk * (qIBolig[t] / (qIBolig[t-1]/fq) - fIBoligInstOmk[t]);

    E_qIBolig[t]$(tx0[t])..
      qIBolig[t] =E= uIBolig[t] * qYBolig[t] * (pBolig[t] / (pI_s['iB','bol',t] + dqIBoligInstOmk[t] * pBolig[t]))**eBolig;

    E_pLand[t]$(tx0[t])..
      qLandSalg[t] =E= uLand[t] * qYBolig[t] * (pBolig[t] / pLand[t])**eBolig;

    E_pBolig[t]$(tx0[t])..
      pBolig[t] * qYBolig[t] =E= pLand[t] * qLandSalg[t] 
                               + (pI_s['iB','bol',t] + dqIBoligInstOmk[t] * pBolig[t]) 
                               * (qKBolig[t] - (1 - rAfskr['iB','bol',t]) * qKBolig[t-1]/fq);

    E_vIBolig[t]$(tx0[t]).. vIBolig[t] =E= pI_s['iB','bol',t] * qIBolig[t];

    E_qKBolig[t]$(tx0[t])..
      qKBolig[t] =E= (1-rAfskr['iB','bol',t]) * qKBolig[t-1]/fq + qIBolig[t];

    E_vKBolig[t]$(tx0[t]).. vKBolig[t] =E= pI_s['iB','bol',t] * qKBolig[t];

    E_qK_bol[t]$(tx0[t]).. qK['iB','bol',t] =E= qKBolig[t] + qKLejeBolig[t];

    E_rKLeje2Bolig[t]$(tx0[t]).. rKLeje2Bolig[t] =E= qKLejeBolig[t] / qKBolig[t]; 

    # ------------------------------------------------------------------------------------------------------------------
    # Nytte af arv
    # ------------------------------------------------------------------------------------------------------------------
    # Arv videregivet pr kohorte
    E_vArvGivet[a,t]$(tx0[t] and t.val > 2015)..
      vArvGivet[a,t] =E= (vHhx[a-1,t-1]/fv + vHhxAfk[a,t] - fBoligUdgift[a,t] * vBolig[a-1,t-1]/fv) * rArvKorrektion[a]
                       - vtDoedsbo[a,t] + vPensArv['pens',a,t] - vtKapPensArv[a,t];

    E_vArvKorrektion[a,t]$(tx0[t] and a0t100[a] and t.val > 2015)..
      vArvKorrektion[a,t] =E= (vHhx[a-1,t-1]/fv + vHhxAfk[a,t] - fBoligUdgift[a,t] * vBolig[a-1,t-1]/fv)
                            * (1-rArvKorrektion[a]) * (1-rOverlev[a-1,t-1]) * nPop[a-1,t-1] / nPop[a,t];

    E_vArv_aTot[t]$(tx0[t] and t.val > 2015).. vArv[aTot,t] =E= sum(a, vArvGivet[a,t] * (1-rOverlev[a-1,t-1]) * nPop[a-1,t-1]);

    E_vArvKorrektion_aTot[t]$(tx0[t] and t.val > 2015)..
      vArvKorrektion[aTot,t] =E= sum(a, vArvKorrektion[a,t] * nPop[a,t]);

    # Arv modtaget
    E_vArv[a,t]$(tx0[t] and t.val > 2015).. vArv[a,t] =E= rArv[a,t] * vArv[aTot,t] / nPop[aTot,t];

    # Hjælpevariabel som skal være strengt positiv
    E_qArvBase[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      qArvBase[a,t] =E= (1-tArv[t+1]) * (vHhx[a,t]/(1-rHtM)
                                       + pBolig[t] * qBoligR[a,t] * (1 - rRealKred2Bolig[a,t])
                                       + (vPensArv['Pens',a,t] - rHtM * vPensArv['PensX',a,t]) / (1-rHtM)  # Samlet pension for fremadskuende agenter, som gives videre i tilfælde af død
                                       ) / EpC[t] + cArv[a,t] * qBVT2hLsnit[t]/qBVT2hLsnit[tBase];

    # ------------------------------------------------------------------------------------------------------------------
    # Nytte af formue
    # ------------------------------------------------------------------------------------------------------------------
    E_qFormueBase[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      qFormueBase[a,t] =E= (vHhx[a,t]/(1-rHtM)
                            + pBolig[t] * qBoligR[a,t] * (rMaxRealkred[t] - rRealKred2Bolig[a,t])
                            + ((1-tKapPens[t]) * vHh['Kap',a,t] + vHh['Alder',a,t]) / (1-rHtM)
                           ) / EpC[t] + cFormue[a,t] * qBVT2hLsnit[t]/qBVT2hLsnit[tBase];

    # Derivative of wealth utility with respect to net assets
    E_dFormue[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      dFormue[a,t] =E= uFormue[a,t] / EpC[t] * qFormueBase[a,t]**(-eHh);
 
    # Derivative of bequest utility with respect to net assets 
    E_dArv[a,t]$(a18t100[a] and tx0E[t] and t.val > 2015)..
      dArv[a,t] =E= uArv[a,t] * (1-tArv[t+1]) / EpC[t] * qArvBase[a,t]**(-eHh);
    E_dArv_tEnd[a,t]$(a18t100[a] and tEnd[t])..
      dArv[a,t] =E= uArv[a,t] * (1-tArv[t]) / EpC[t] * qArvBase[a,t]**(-eHh);

    # Bequest taxes
    E_vtArv[a,t]$(tx0[t] and t.val > 2015)..
      vtArv[a,t] =E= tArv[t] * vArv[a,t];
    E_vtArv_tot[t]$(tx0[t] and t.val > 2015)..  vtArv[aTot,t] =E= tArv[t] * vArv[aTot,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Overførsler mellem børn og forældre som redegør for ændringer i børns opsparing. 
    # ------------------------------------------------------------------------------------------------------------------
    E_vBoernFraHh[a,t]$(tx0[t] and a0t17[a] and t.val > 2015)..
      vHhx[a,t] =E= (uBoernFraHh[a,t]) * vHhx[aTot,t] / nPop[a,t];

    E_vHhTilBorn_aTot[t]$(tx0[t] and t.val > 2015).. vHhTilBoern[aTot,t] =E= sum(aa, vBoernFraHh[aa,t] * nPop[aa,t]);

    E_vHhTilBoern[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      vHhTilBoern[a,t] =E= rBoern[a,t] * vHhTilBoern[aTot,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Biler - kapitalapparat til beregning vægtafgift 
    # ------------------------------------------------------------------------------------------------------------------
    E_qBiler[t]$(tx0[t]).. qBiler[t] =E= (1-rBilAfskr[t]) * qBiler[t-1]/fq + qC['cBil',t];

    # ------------------------------------------------------------------------------------------------------------------
    # Opdeling af aldersfordelte parametre i tids- og aldersfordelte elementer
    # ------------------------------------------------------------------------------------------------------------------
    E_rDisk[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      rDisk[a,t] =E= rDisk_t[t] + rDisk_a[a,t];

    E_uBolig[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      uBolig[a,t] =E= uBolig_t[t] + uBolig_a[a,t];

    E_fHh[a,t]$(a18t100[a] and tx0[t] and t.val > 2015).. fHh[a,t] =E= 1 + 0.5 * rBoern[a,t] * nPop['a0t17',t];

    E_uBoligHtM[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      uBoligHtM[a,t] =E= uBoligHtM_t[t] * uBoligHtM_a[a,t] * uBoligHtM_match;

    E_uBoernFraHh[a,t]$(a0t17[a] and tx0[t] and t.val > 2015)..
      uBoernFraHh[a,t] =E= uBoernFraHh_t[t] + uBoernFraHh_a[a,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Term to adjust for migration
    # ------------------------------------------------------------------------------------------------------------------
    # The key assumption is sharing within the cohort and that migrants arrive and leave with zero net assets
    E_fMigration[a,t]$(tx0[t] and a.val <= 100 and t.val > 2015)..
      fMigration[a,t] =E= rOverlev[a-1,t-1] * nPop[a-1,t-1] / nPop[a,t];

    E_fMigration_aEnd[a,t]$(tx0[t] and a.val > 100 and t.val > 2015)..
      fMigration[a,t] =E= 1;

    E_fMigration_tot[t]$(tx0[t] and t.val > 1991)..
      fMigration[aTot,t] =E= rOverlev[aTot,t-1] * nPop[aTot,t-1] / nPop[aTot,t];
  $ENDBLOCK
$ENDIF