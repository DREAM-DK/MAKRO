# ======================================================================================================================
# Consumers
# - Consumption decisions and budget constraint
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_consumers_prices_endo_a
    pBoligUC[a,t]$(t.val > 2015) "User cost for ejerbolig."
    pLand[t] "Imputeret gennemsnitlig pris på grundværdien af land til boligbenyttelse."
    EpC[t]$(t.val > 2015) "Forventet prisindeks for næste periodes forbrug ekskl. bolig."
    pCPI[c_,t] "Forbrugerprisindeks (CPI), Kilde: FMBANK[pfp] og FMBANK[pfp<i>]."
    pHICP[t] "Harmoniseret forbrugerprisindeks (HICP), Kilde: FMBANK[pfphicp]."
    pnCPI[c_,t] "Nettoforbrugerprisindeks (nCPI), Kilde: FMBANK[pnp] og FMBANK[pnp<i>]."
  ;
  $GROUP G_consumers_prices_endo
    G_consumers_prices_endo_a

    pBolig[t] "Kontantprisen på enfamiliehuse, Kilde: ADAM[phk]"
    mpLand[t] "Imputeret marginal pris på grundværdien af land til boligbenyttelse."
    pIBoligUC[t] "Usercost for kapitalinvesteringer i nybyggeri af ejerboliger (investeringspris plus installationsomkostninger)."

    pC[c_,t]$(cNest[c_] and not cTot[c_]) "Imputeret prisindeks for forbrugskomponenter for husholdninger - dvs. ekskl. turisters forbrug."
  ;

  $GROUP G_consumers_quantities_endo_a
    qC_a[a,t]$(a18t100[a] and t.val > 2015) "Individuelt forbrug ekskl. bolig."
    qCR[a_,t]$((aTot[a_] or a18t100[a_]) and t.val > 2015) "Individuel forbrug ekskl. bolig for fremadskuende agenter."
    qCHtM[a_,t]$((a18t100[a_] or aTot[a_]) and t.val > 2015) "Individuel forbrug ekskl. bolig for hand-to-mouth agenter."
    qCRxRef[a_,t]$((a18t100[a_] or aTot[a_]) and t.val > 2015) "Forbrug ekskl. bolig og referenceforbrug for fremadskuende agenter."
    qCHtMxRef[a_,t]$(a18t100[a_] and t.val > 2015) "Individuel forbrug ekskl. bolig og referenceforbrug for hand-to-mouth agenter ."
    qBoligHtM[a_,t]$((a18t100[a_] or aTot[a_]) and t.val > 2015) "Ejerboliger ejet af hand-to-mouth husholdningerne."
    qBoligHtMxRef[a_,t]$(a18t100[a_] and t.val > 2015) "Ejerboliger ejet af hand-to-mouth husholdningerne eksl. referenceforbrug."
    qBoligR[a_,t]$((a18t100[a_] or aTot[a_]) and t.val > 2015) "Ejerboliger ejet af fremadskuende husholdningerne."
    qBolig[a_,t]$((a18t100[a_] or aTot[a_]) and t.val > 2015) "Ejerboliger ejet af husholdningerne (aggregat af kapital og land)"
    qBoligRxRef[a_,t]$((a18t100[a_] or aTot[a_]) and t.val > 2015) "Ejerboliger ejet af husholdningerne ekskl. referenceforbrug."
    qNytte[a,t]$(t.val > 2015) "CES nest af bolig og andet privat forbrug."
    qArvBase[a,t]$(a18t100[a] and t.val > 2015) "Hjælpevariabel til førsteordensbetingelse for arve-nytte."
    qFormueBase[a,t]$(a18t100[a] and t.val > 2015) "Hjælpevariabel til førsteordensbetingelse for nytte af formue."
    qCR_NR[a_,t]$(a0t100[a_]) "Fremadskuende husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
    qCHtM_NR[a_,t]$(a0t100[a_]) "HtM-husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
    qC_NR[a_,t]$(a0t100[a_]) "Gns. husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
    qC[c_,t]$(cIkkeBol[c_]) "Husholdningernes samlede forbrug fordelt på forbrugsgrupper og aggregater inkl. lejebolig og imputeret ejerbolig."
  ;
  $GROUP G_consumers_quantities_endo
    G_consumers_quantities_endo_a

    qC[c_,t]$(not cTot[c_] and not cIkkeBol[c_] and not cBol[c_]) "Husholdningernes samlede forbrug fordelt på forbrugsgrupper og aggregater inkl. lejebolig og imputeret ejerbolig."
    qBiler[t] "Kapitalmængde for køretøjer i husholdningerne, Kilde: ADAM[fKncb]"
    qYBolig[t] "Bruttoproduktion af ejerboliger inkl. installationsomkostninger (aggregat af kapital og land)"
    qIBoligInstOmk[t] "Installationsomkostninger for boliginvesteringer i nybyggeri."
    qLandSalg[t] "Land solgt fra husholdningerne til at bygge grunde til ejerboliger på."
    qKBolig[t] "Kapitalmængde af ejerboliger, Kilde: ADAM[fKnbhe]"
    qIBolig[t] "Investeringer i ejerboligkapital."
    qCR_NR[a_,t]$(aTot[a_]) "Fremadskuende husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
    qCHtM_NR[a_,t]$(aTot[a_]) "HtM-husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
    qC_NR[a_,t]$(aTot[a_]) "Gns. husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
  ;

  $GROUP G_consumers_values_endo_a
    vC_a[a,t]$(a18t100[a] and t.val > 2015) "Individuelt forbrug ekskl. bolig."
    vHhx[a_,t]$(a0t100[a_] and t.val > 2015) "Husholdningernes formue ekskl. pension, bolig og realkreditgæld (vægtet gns. af Hand-to-Mouth og fremadskuende forbrugere)"
    vHhxR[a_,t]$(a0t100[a_] and t.val > 2015) "Fremadskuende husholdningernes formue ekskl. pension, bolig og realkreditgæld."
    vHhxHtM[a_,t]$(a0t100[a_] and t.val > 2015) "HtM-husholdningernes formue ekskl. pension, bolig og realkreditgæld."
    vHhxRAfk[a_,t]$(a18t100[a_] and t.val > 2015) "Imputeret afkast på fremadskuende husholdningernes formue ekskl. bolig og pension."
    vHhxHtMAfk[a_,t]$(a18t100[a_] and t.val > 2015) "Imputeret afkast på HtM husholdningernes formue ekskl. bolig og pension."
    vHhIndHtM[a_,t]$(a0t100[a_] and t.val > 2015) "HtM-husholdningernes løbende indkomst efter skat (ekslusiv kapitalindkomst)."
    vHhIndR[a_,t]$(a0t100[a_] and t.val > 2015) "Fremadskuende husholdningernes løbende indkomst efter skat (ekslusiv kapitalindkomst)."
    vCLejeBolig[a_,t]$(a18t100[a_]) "Forbrug af lejeboliger."
    vArvGivet[a,t]$(t.val > 2015) "Arv givet af hele kohorten med alder a."
    vArv[a_,t]$(t.val > 2015) "Arv modtaget af en person med alderen a."
    vBoligUdgift[a_,t]$(t.val > 2015 and a[a_]) "Cash-flow-udgift til ejerbolig - dvs. inkl. afbetaling på gæld og inkl. øvrige omkostninger fx renter og bidragssats på realkreditlån."
    vBoligUdgiftHtM[a_,t]$(t.val > 2015) "Netto udgifter til køb/salg/forbrug af bolig for hand-to-mouth husholdninger."
    vBoligUdgiftR[a_,t]$(t.val > 2015) "Netto udgifter til køb/salg/forbrug af bolig for fremadskuende husholdninger."
    vBoernFraHh[a,t]$(a0t17[a] and t.val > 2015) "Finansielle nettooverførsler fra forældre modtaget af børn i alder a."
    vHhTilBoern[a_,t]$((a18t100[a_] or aTot[a_]) and t.val > 2015) "Finansielle nettooverførsler til børn givet af forældre i alder a."
    vBolig[a_,t]$(a18t100[a_] and t.val > 2015) "Husholdningernes boligformue."
    vBoligHtM[a_,t]$(a18t100[a_] or atot[a_]) "Hånd-til-mund husholdningernes boligformue."
    vArvKorrektion[a_,t]$((tx0[t] and t.val > 2015) and (a0t100[a_] or aTot[a_])) "Arv som tildeles afdødes kohorte for at korregerer for selektionseffekt (formue og døds-sandsynlighed er mod-korreleret)."
    vCR_NR[a_,t]$(a0t100[a_]) "Fremadskuende husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
    vCHtM_NR[a_,t]$(a0t100[a_]) "HtM-husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
    vC_NR[a_,t]$(a0t100[a_]) "Gns. husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
    vBoligUdgiftArv[t]$(t.val > 2015) "Netto udgifter til køb/salg/forbrug af bolig gående til arv."
  ;
  $GROUP G_consumers_values_endo
    G_consumers_values_endo_a

    vC[c_,t]$(cNest[c_] and not cTot[c_]) "Det private forbrug fordelt på forbrugsgrupper, Kilde: ADAM[Cp] eller ADAM[C<i>]"
    vHhx[a_,t]$(aTot[a_] and t.val > 2015) "Husholdningernes formue ekskl. pension, bolig og realkreditgæld (vægtet gns. af Hand-to-Mouth og fremadskuende forbrugere)"
    vHhxR[a_,t]$(aTot[a_] and t.val > 2015) "Fremadskuende husholdningernes formue ekskl. pension, bolig og realkreditgæld."
    vHhxHtM[a_,t]$(aTot[a_] and t.val > 2015) "HtM-husholdningernes formue ekskl. pension, bolig og realkreditgæld."
    vHhxRAfk[a_,t]$(aTot[a_] and t.val > 2015) "Imputeret afkast på fremadskuende husholdningernes formue ekskl. bolig og pension."
    vHhxHtMAfk[a_,t]$(aTot[a_] and t.val > 2015) "Imputeret afkast på HtM husholdningernes formue ekskl. bolig og pension."
    vHhIndHtM[a_,t]$(aTot[a_] and t.val > 2015) "HtM-husholdningernes løbende indkomst efter skat (ekslusiv kapitalindkomst)."
    vHhIndR[a_,t]$(aTot[a_] and t.val > 2015) "Fremadskuende husholdningernes løbende indkomst efter skat (ekslusiv kapitalindkomst)."
    vCLejeBolig[a_,t]$(aTot[a_]) "Forbrug af lejeboliger."
    vBoligUdgift[a_,t]$(t.val > 2015 and aTot[a_]) "Cash-flow-udgift til ejerbolig - dvs. inkl. afbetaling på gæld og inkl. øvrige omkostninger fx renter og bidragssats på realkreditlån."
    vBolig[a_,t]$((atot[a_]) and t.val > 2015) "Husholdningernes boligformue."
    vKBolig[t] "Værdi af kapitalmængde af ejerboliger."
    vIBolig[t] "Værdi af ejerbolig-investeringer."
    vHhInvestx[a_,t]$(atot[a_]) "Husholdningernes direkte investeringer ekskl. bolig - imputeret."
    vSelvstKapInd[a_,t]$(atot[a_]) "Selvstændiges kapitalindkomst - imputeret."
    vCR_NR[a_,t]$(aTot[a_]) "Fremadskuende husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
    vCHtM_NR[a_,t]$(aTot[a_]) "HtM-husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
    vC_NR[a_,t]$(aTot[a_]) "Gns. husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
  ;

  $GROUP G_consumers_endo_a
    G_consumers_prices_endo_a
    G_consumers_quantities_endo_a
    G_consumers_values_endo_a

    fHh[a,t]$(t.val > 2015) "Husholdningens størrelse (1 + antal børn pr. voksen med alderen a) som forbrug korrigeres med."
    uBoligR[a,t]$(t.val > 2015) "Nytteparameter som styrer de fremadskuende forbrugernes bolig-efterspørgsel."
    uBoligHtM[a,t]$(t.val > 2015) "Nytteparameter som styrer hand-to-mouth forbrugernes bolig-efterspørgsel."
    dBoligUdgift[a_,t]$((aVal[a_] >= 18) and t.val > 2015) "Hjælpevariabel til beregning af udgifter til ejerbolig."
    mUBolig[a,t]$(a18t100[a] and t.val > 2015) "Marginalnytte af bolig."
    dULead2dBolig[a,t]$(t.val > 2015) "Nytte næste periode differentieret ift. erjerbolig mængde denne periode."
    mUC[a,t]$(t.val > 2015) "Marginalnytte af forbrug udover end bolig."
    EmUC[a,t]$(t.val > 2015) "Forventet marginalnytte af forbrug udover end bolig."
    fMigration[a_,t]$(a[a_] and t.val > 2015) "Korrektion for migrationer (= 1/(1+migrationsrate) eftersom formue deles med ind- og udvandrere)."
    uBoernFraHh[a,t]$(a0t17[a] and t.val > 2015) "Parameter for børns formue relativ til en gennemsnitsperson. Bestemmer vBoernFraHh." 
    dArv[a_,t]$(t.val > 2015 and d1Arv[a_,t]) "Arvefunktion differentieret med hensyn til bolig."
    dFormue[a_,t]$(t.val > 2015 and a[a_]) "Formue-nytte differentieret med hensyn til bolig."
    rvCLejeBolig[a_,t]$(aTot[a_] and t.val > 2015) "Andel af samlet lejeboligmasse i basisåret."
    fDisk[a,t] "Husholdningens diskonteringsfaktor"
  ;

  $GROUP G_consumers_endo
    G_consumers_endo_a
    G_consumers_prices_endo
    G_consumers_quantities_endo
    G_consumers_values_endo   

    rKLeje2Bolig[t] "Forholdet mellem qKbolig og qKlejebolig."

    dBoligUdgift[a_,t]$((atot[a_]) and t.val > 2015) "Hjælpevariabel til beregning af udgifter til ejerbolig."

    uC[c_,t] "CES skalaparametre i det private forbrugs-nest."

    fMigration[a_,t]$((atot[a_] and t.val > 1991)) "Korrektion for migrationer (= 1/(1+migrationsrate) eftersom formue deles med ind- og udvandrere)."
    dArv[a_,t]$(t.val > 2015 and aTot[a_]) "Arvefunktion differentieret med hensyn til bolig."
    dFormue[a_,t]$(t.val > 2015 and aTot[a_]) "Formue-nytte differentieret med hensyn til bolig."

    dpBoligTraeghed[t]$(tx0[t] and t.val > 2015) "Disnytte-effekt fra omstillingsomkostninger på boligpriser."
  ;
  $GROUP G_consumers_endo G_consumers_endo$(tx0[t]); # Restrict endo group to tx0[t]

  $GROUP G_consumers_prices
    G_consumers_prices_endo
  ;
  $GROUP G_consumers_quantities
    G_consumers_quantities_endo

    qC[c_,t]$(cBol[c_])
    qLand[t] "Mål for land anvendt til ejerboliger."
    qKLejeBolig[t] "Kapitalapparat i lejeboliger."
  ;
  $GROUP G_consumers_values
    G_consumers_values_endo   
  ;

  $GROUP G_consumers_exogenous_forecast
    nArvinger[a,t] "Sum af antal arvinger sammenvejet efter rArv."
    rBoern[a,t] "Andel af det samlede antal under 18-årige som en voksen med alderen a har ansvar for."

    rOverlev[a_,t] "Overlevelsesrate."
    ErOverlev[a,t] "Forventet overlevelsesrate - afviger fra den faktiske overlevelsesrate for 100 årige."

    rBoligPrem[t] "Risikopræmie for boliger."
  ;
  $GROUP G_consumers_forecast_as_zero
    jfEpC[t] "J-led."
    jqC[t] "J-led"
    jqBolig[t] "J-led"
    jqCR[a,t] "J-led"
    jfDisk[a,t] "J-led"
    jfDisk_t[t] "J-led"
  ;
  $GROUP G_consumers_ARIMA_forecast
    uC0[c_,t] "Justeringsled til CES-skalaparameter i private forbrugs-nests."
    fuCnest[cNest,t] "Total faktor CES-skalaparametre i privat forbrugs-nests."
    rKLeje2Bolig # Endogen i stødforløb
    rBilAfskr[t] "Afskrivningsrate for køretøjer i husholdningerne."
    rHhInvestx[t] "Husholdningernes direkte investeringer ekskl. bolig ift. direkte og indirekte beholdning af indl. aktier - imputeret."
  ;
  $GROUP G_consumers_constants
    uBoligHtM_match   "led i uBoligHtM."

    # Non-durable consumption
    eHh       "Invers af intertemporal substitutionselasticitet."
    rRef      "Reference-andel for ikke-bolig forbrug."
    rHtM      "Andel af Hand-to-Mouth forbrugere."
    rHtMTraeghed "Træghed i HtM-forbrug."

    # Housing
    eBolig          "Substitutionselasticitet mellem boligkapital og land."
    uIBoligInstOmk  "Parameter for installationsomkostninger for boligkapital i nybyggeri."
    upBoligTraeghed "Parameter for Rotemberg omkostning i bolig-prisdannelse."

    # CES demand
    eC[c_] "Substitutionselasticitet i privat forbrugs-nests."

    eNytte "Substitutionselasticitet mellem bolig- og andet forbrug."

    rArvKorrektion[a] "Gennemsnitlig formue personer, som dør, relativt til en gennemsnitsperson i samme alder."

    rArv_a[a,aa] "Andel af arven fra aldersgruppe a der tilfalder hver arving med alderen aa i basisåret."

    rDisk "De fremadskuende forbrugeres aldersafhængige diskonterings-rate."
    eDisk2LM "Labor-market conditions elasticity of household discount factor."
  ;
  $GROUP G_consumers_other
    uFormue[t] "Nytte af formue parameter 0."
    uArv[t] "Arve-nytteparameter 0."

    # Opdeling af adlersfordelte parametre i tids- og aldersfordelte elementer
    uBoligR_a[a,t] "Alders-specifikt led i uBoligR."
    fuBolig[t] "Tids-afhængigt led i uBoligR og uBoligHtM."
    uBoligHtM_a[a,t] "Alders-specifikt led i uBoligHtM."
    uBoernFraHh_t[t] "Tids-afhængigt led i uBoernFraHh."
    uBoernFraHh_a[a,t] "Alders-specifikt led i uBoernFraHh."

    fHtMTraeghed[a,t] "Korrektionsfaktor i HtM-forbrug. Kalibreres til at vHhxHtM=0 i grundforløb."

    # Non-durable consumption
    rRefBolig[a,t] "Vane-andel for forbrug for boliger."

    # Housing
    fIBoligInstOmk[t] "Vækstfaktor i boliginvesteringer, som giver nul installationsomkostninger."
    uLand[t] "Skalaparameter i CES efterspørgsel efter land."
    uIBolig[t] "Skalaparameter i CES efterspørgsel efter boligkapital."

    # Bequests
    rArv[a,t] "Andel af den samlede arv som tilfalder hver arving med alderen a."

    rMaxRealkred[t] "Andel af bolig som anses for likvid ift. nytte af likvid formue."

    rSelvstKapInd[t] "Selvstændiges kapitalindkomst ift. direkte og indirekte beholdning af indl. aktier - imputeret."
    fpCPI[c_,t] "Korrektionsfaktor mellem forbrugerpriser i NR og CPI"
    rCPI[c,t] "Vægte i forbrugerprisindeks (CPI), Kilde: FMBANK[pf<i>vgt]."
    rHICP[c,t] "Vægte i harmoniseret forbrugerprisindeks (HICP), Kilde: FMBANK[v<i>hicp]."
    fpHICP[t] "Korrektionsfaktor vedrørende HICP"
    rnCPI[c,t] "Vægte i nettoforbrugerprisindeks (nCPI), Kilde: FMBANK[pn<i>vgt]."
    fpnCPI[c_,t] "Korrektionsfaktor for nettoforbrugerprisindeks (nCPI)."
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_consumers_aTot
    # ------------------------------------------------------------------------------------------------------------------
    # Aggregeret budgetrestriktion (vægtet gennemsnit af fremadskuende og hånd-til-mund husholdninger)
    # ------------------------------------------------------------------------------------------------------------------
    # vHhx[aTot,t] kan opskrives på samme måde som E_vHhx[a,t] - to ting er værd at bemærke
    # 1) summen af overførsler til og fra børn er 0
    # 2) Arv og arvekorrektion er en del af husholdningernes indkomst og bortset fra arv- og dødsboskat kommer det fra husholdningerne
    E_vHhx_aTot[t]$(tx0[t] and t.val > 2015)..
      vHhx[aTot,t] =E= vHhx[aTot,t-1]/fv + vHhxAfk[aTot,t]
                     + vHhInd[aTot,t]
                     - vC['cIkkeBol',t]
                     - vCLejebolig[aTot,t] 
                     - vBoligUdgift[aTot,t] 
                     - (vArv[aTot,t] + vArvKorrektion[aTot,t] + vtDoedsbo[aTot,t] - vPensArv['Pens',aTot,t] + vtKapPensArv[aTot,t]);

    E_vHhxR_aTot[t]$(tx0[t] and t.val > 2015).. vHhx[aTot,t] =E= vHhxR[aTot,t] + vHhxHtM[aTot,t];
    E_vHhxHtM_aTot[t]$(tx0[t] and t.val > 2015).. vHhxHtM[aTot,t] =E= sum(a, vHhxHtM[a,t] * rHtM * nPop[a,t]);
    E_vHhxRAfk_aTot[t]$(tx0[t] and t.val > 2015).. vHhxRAfk[aTot,t] =E= vHhxAfk[aTot,t] - vHhxHtMAfk[aTot,t];
    E_vHhxHtMAfk_aTot[t]$(tx0[t] and t.val > 2015).. vHhxHtMAfk[aTot,t] =E= mrHhxAfk[t] * vHhxHtM[aTot,t-1]/fv;

    E_dBoligUdgift_tot[t]$(tx0[t] and t.val > 2015)..
      dBoligUdgift[aTot,t] =E= (1+rHhAfk['RealKred',t]) * rRealKred2Bolig[aTot,t-1] # Realkredit fra sidste periode + renter
                               + tEjd[t] # Ejendomsværdiskat
                               + rBoligOmkRest[t] # Resterende udgifter
                               + vIBolig[t] / (vBolig[aTot,t-1]/fv) # Kapitalinvesteringer
                               - vBolig[aTot,t] / (vBolig[aTot,t-1]/fv); # Kapitalgevinster (plus evt. profit fra entreprenør-agenten, som opstår pga. installationsomkostninger i sammensætning af land og bygningskapital)

    E_vBoligUdgift_tot[t]$(tx0[t] and t.val > 2015)..
      vBoligUdgift[aTot,t] =E= (1-rRealKred2Bolig[aTot,t]) * vBolig[aTot,t] + dBoligUdgift[aTot,t] * vBolig[aTot,t-1]/fv;

    E_vHhInvestx_tot[t]$(tx0[t])..
      vHhInvestx[aTot,t] =E= rHhInvestx[t] * vI_s[iTot,spTot,t];  

    E_vSelvstKapInd_tot[t]$(tx0[t])..
      vSelvstKapInd[aTot,t] =E= rSelvstKapInd[t] * vEBITDA[sTot,t];    

    E_vBolig_tot[t]$(tx0[t] and t.val > 2015).. vBolig[aTot,t] =E= pBolig[t] * qBolig[aTot,t];

    # Lejebolig ud fra eksogent kapitalapparat
    E_vCLejeBolig_tot[t]$(tx0[t])..
      vCLejebolig[aTot,t] =E= pC['cBol',t] * qC['cBol',t] * qKLejeBolig[t-1] / (qKBolig[t-1] + qKLejeBolig[t-1]);

    # ------------------------------------------------------------------------------------------------------------------
    # CES-efterspørgsel efter (ikke-bolig) forbrug
    # ------------------------------------------------------------------------------------------------------------------
    # Budget constraint
    E_vC_nests[cNest,t]$(tx0[t])..
      vC[cNest,t] =E= sum(c$c_2c[cNest,c], vC[c,t]);

    E_pC_nests[cNest,t]$(tx0[t])..
      pC[cNest,t] * qC[cNest,t] =E= vC[cNest,t];

    # FOC
    E_qC[c_,cNest,t]$(tx0[t] and cNest2c_[cNest,c_])..
      qC[c_,t] =E= uC[c_,t] * qC[cNest,t] * (pC[cNest,t] / pC[c_,t])**eC(cNest);

    # Balancing mechanism for CES parameters
    E_uC[c_,cNest,t]$(tx0[t] and cNest2c_[cNest,c_])..
      uC[c_,t] =E= fuCnest[cNest,t] * uC0[c_,t] / sum(cc_$cNest2c_[cNest,cc_], uC0[cc_,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Bolig-efterspørgsel for fremadskuende husholdninger
    # ------------------------------------------------------------------------------------------------------------------
    E_qLandSalg[t]$(tx0[t])..
      qLandSalg[t] =E= qLand[t] - (1 - rAfskr['iB','bol',t]) * qLand[t-1]/fq;

    # ------------------------------------------------------------------------------------------------------------------
    # CES-efterspørgsel efter bolig-kapital og land
    # ------------------------------------------------------------------------------------------------------------------
    # Produktion af ejerboliger er sammensætning af land og boligkapital-investeringer
    E_qYBolig[t]$(tx0[t])..
      qYBolig[t] =E= qBolig[aTot,t] - (1 - rAfskr['iB','bol',t]) * qBolig[aTot,t-1]/fq + qIBoligInstOmk[t];

    E_qIBoligInstOmk[t]$(tx0[t])..
      qIBoligInstOmk[t] =E= uIBoligInstOmk/2 * sqr(qIBolig[t] / qIBolig[t-1] - fIBoligInstOmk[t]) * qIBolig[t];

    E_pIBoligUC[t]$(tx0E[t])..
      pIBoligUC[t] =E= pI_s['iB','bol',t]
                     + uIBoligInstOmk * (qIBolig[t] / qIBolig[t-1]*fq - fIBoligInstOmk[t]) * qIBolig[t] / qIBolig[t-1]*fq * pBolig[t]
                     + uIBoligInstOmk/2 * sqr(qIBolig[t] / qIBolig[t-1] - fIBoligInstOmk[t]) * pBolig[t]
                     - uIBoligInstOmk * (qIBolig[t+1]*fq / qIBolig[t] - fIBoligInstOmk[t+1]) * sqr(qIBolig[t+1]*fq / qIBolig[t]) * pBolig[t+1]*fp * fVirkDisk['bol',t+1];

    E_pIBoligUC_tEnd[t]$(tEnd[t])..
      pIBoligUC[t] =E= pI_s['iB','bol',t]
                     + uIBoligInstOmk * (qIBolig[t] / qIBolig[t-1]*fq - fIBoligInstOmk[t]) * qIBolig[t] / qIBolig[t-1]*fq * pBolig[t]
                     + uIBoligInstOmk/2 * sqr(qIBolig[t] / qIBolig[t-1] - fIBoligInstOmk[t]) * pBolig[t];

    E_qIBolig[t]$(tx0[t])..
      qIBolig[t] =E= uIBolig[t] * qYBolig[t] * (pBolig[t] / pIBoligUC[t])**eBolig;

    E_mpLand[t]$(tx0[t])..
      qLandSalg[t] =E= uLand[t] * qYBolig[t] * (pBolig[t] / mpLand[t])**eBolig;

    # Bolig-produktionspris er CES pris af usercost på land og investeringer
    E_pBolig[t]$(tx0[t])..
      pBolig[t] * qYBolig[t] =E= mpLand[t] * qLandSalg[t] + pIBoligUC[t] * qIBolig[t];


    E_vIBolig[t]$(tx0[t]).. vIBolig[t] =E= pI_s['iB','bol',t] * qIBolig[t];

    E_qKBolig[t]$(tx0[t])..
      qKBolig[t] =E= (1-rAfskr['iB','bol',t]) * qKBolig[t-1]/fq + qIBolig[t];

    E_vKBolig[t]$(tx0[t]).. vKBolig[t] =E= pI_s['iB','bol',t] * qKBolig[t];

    E_rKLeje2Bolig[t]$(tx0[t]).. rKLeje2Bolig[t] =E= qKLejeBolig[t] / qKBolig[t]; 

    # ------------------------------------------------------------------------------------------------------------------
    # Biler - kapitalapparat til beregning vægtafgift 
    # ------------------------------------------------------------------------------------------------------------------
    E_qBiler[t]$(tx0[t]).. qBiler[t] =E= (1-rBilAfskr[t]) * qBiler[t-1]/fq + qC['cBil',t];

    # ------------------------------------------------------------------------------------------------------------------
    # Term to adjust for migration
    # ------------------------------------------------------------------------------------------------------------------
    E_fMigration_tot[t]$(tx0[t] and t.val > 1991)..
      fMigration[aTot,t] =E= rOverlev[aTot,t-1] * nPop[aTot,t-1] / nPop[aTot,t];

    E_vCR_NR_tot[t]$(tx0[t]).. 
      vCR_NR[aTot,t] =E= pC['cikkebol',t] * qCR[aTot,t] 
                       + pC['cbol',t] * qC['cbol',t] 
                         * ( (1-rHtM) * qKLejebolig[t-1]/qKBolig[t-1] 
                            + (qBoligR[aTot,t] / qBolig[aTot,t]) * (qKBolig[t-1]-qKLejebolig[t-1])/qKBolig[t-1] ) ;
    E_qCR_NR_tot[t]$(tx0[t]).. qCR_NR[aTot,t] =E= vCR_NR[aTot,t] / pC['ctot',t];

    E_vCHtM_NR_tot[t]$(tx0[t])..
      vCHtM_NR[aTot,t] =E= pC['cikkebol',t] * qCHtM[aTot,t] 
                         + pC['cbol',t] * qC['cbol',t]
                           * ( rHtM * qKLejebolig[t-1]/qKBolig[t-1]
                              + (qBoligHtM[aTot,t] / qBolig[aTot,t]) * (qKBolig[t-1]-qKLejebolig[t-1])/qKBolig[t-1] );

    E_qCHtM_NR_tot[t]$(tx0[t]).. qCHtM_NR[aTot,t] =E= vCHtM_NR[aTot,t] / pC['ctot',t];

    E_vC_NR_tot[t]$(tx0[t]).. vC_NR[aTot,t] =E= vC[cTot,t];
    E_qC_NR_tot[t]$(tx0[t]).. qC_NR[aTot,t] =E= vC_NR[aTot,t] / pC['cTot',t];

    # ------------------------------------------------------------------------------------------------------------------
    # Forbrugerprisindex
    # ------------------------------------------------------------------------------------------------------------------
    E_pCPI[c,t]$(tx0[t]).. pCPI[c,t] =E= fpCPI[c,t] * pC[c,t];

    E_pCPI_cTot[t]$(tx0[t]).. pCPI[cTot,t] =E= fpCPI[cTot,t] * sum(c, rCPI[c,t] * pCPI[c,t]);

    E_pHICP[t]$(tx0[t] and t.val > 1995).. pHICP[t] =E= fpHICP[t] * sum(c, rHICP[c,t] * pCPI[c,t]);

    E_pnCPI[c,t]$(tx0[t] and t.val > 2015).. pnCPI[c,t] =E= fpnCPI[c,t] * (vC[c,t] - vtTold[c,sTot,t] - vtNetAfg[c,sTot,t] - vtMoms[c,sTot,t] ) / qC[c,t];

    E_pnCPI_cTot[t]$(tx0[t] and t.val > 2015).. pnCPI[cTot,t] =E= fpnCPI[cTot,t] * sum(c, rnCPI[c,t] * pnCPI[c,t]);
  $ENDBLOCK

  $BLOCK B_consumers_a
    # ------------------------------------------------------------------------------------------------------------------
    # Aggregeret budgetrestriktion (vægtet gennemsnit af fremadskuende og hånd-til-mund husholdninger)
    # ------------------------------------------------------------------------------------------------------------------
    E_vHhx[a,t]$(tx0[t] and a0t100[a] and t.val > 2015)..
      vHhx[a,t] =E= (vHhx[a-1,t-1]/fv + vHhxAfk[a,t]) * fMigration[a,t]
                  + vHhInd[a,t]
                  - vC_a[a,t]            # Ikke-bolig-forbrugsudgift 
                  - vCLejeBolig[a,t]     # Lejebolig-forbrugsudgift
                  - vBoligUdgift[a,t]    # Cashflow til ejerbolig inkl. realkreditafbetaling
                  + vBoernFraHh[a,t] - vHhTilBoern[a,t];  # Overførsler mellem voksne og børn

    E_vHhxRAfk[a,t]$(tx0[t] and a18t100[a] and t.val > 2015).. vHhxAfk[a,t] =E= (1-rHtM) * vHhxRAfk[a,t] + rHtM * vHhxHtMAfk[a,t];
    E_vHhxHtMAfk[a,t]$(tx0[t] and a18t100[a] and t.val > 2015).. vHhxHtMAfk[a,t] =E= mrHhxAfk[t] * vHhxHtM[a-1,t-1]/fv;

    E_vHhxR_0t17[a,t]$(tx0[t] and a0t17[a] and t.val > 2015).. vHhx[a,t] =E= rHtM * vHhxHtM[a,t] + (1-rHtM) * vHhxR[a,t];

    E_vHhxR[a,t]$(tx0[t] and a18t100[a] and t.val > 2015)..
      vHhxR[a,t] =E= (vHhxR[a-1,t-1]/fv + vHhxRAfk[a,t]) * fMigration[a,t]
                   + vHhIndR[a,t]

                   # Samlet forbrug
                   - pC['cIkkeBol',t] * qCR[a,t] # Ikke-bolig-forbrugsudgift 
                   - vCLejeBolig[a,t] # Lejebolig-forbrugsudgift
                   - vBoligUdgiftR[a,t] # Cashflow til ejerbolig inkl. realkreditafbetaling

                   # Transfereringer
                   - vHhTilBoern[a,t] / (1-rHtM);  # Overførsler til børn betales kun af fremadskuende husholdninger

    # Fremadskuende husholdningernes indkomst beregnes residualt - de små forskelle i indkomst kan ses i E_vHhIndHtM
    E_vHhIndR[a,t]$(tx0[t] and a0t100[a] and t.val > 2015)..
      vHhInd[a,t] =E= (1-rHtM) * vHhIndR[a,t] + rHtM * vHhIndHtM[a,t];
    E_vHhIndR_tot[t]$(tx0[t] and t.val > 2015)..
      vHhInd[aTot,t] =E= vHhIndR[aTot,t] + vHhIndHtM[aTot,t];

    # Samlet post for ejerbolig som fratrækkes i budgetrestriktion. Bemærk at rentefradrag fra realkredit indgår i vHhInd, ikke i vBoligUdgift.
    E_vBoligUdgift[a,t]$(tx0[t] and t.val > 2015)..
      vBoligUdgift[a,t] =E= (1-rRealKred2Bolig[a,t]) * vBolig[a,t] + dBoligUdgift[a,t] * vBolig[a-1,t-1]/fv * fMigration[a,t];

    E_vBoligUdgiftR[a,t]$(tx0[t] and t.val > 2015).. vBoligUdgift[a,t] =E= rHtM * vBoligUdgiftHtM[a,t] + (1-rHtM) * vBoligUdgiftR[a,t];

    E_dBoligUdgift[a,t]$(18 <= a.val and tx0[t] and t.val > 2015)..
      dBoligUdgift[a,t] =E= (1+rHhAfk['RealKred',t]) * rRealKred2Bolig[a-1,t-1] # Realkredit fra sidste periode + renter
                            + tEjd[t] # Ejendomsværdiskat
                            + rBoligOmkRest[t] # Resterende udgifter
                            + vIBolig[t] / (vBolig[aTot,t-1]/fv) # Kapitalinvesteringer
                            - vBolig[aTot,t] / (vBolig[aTot,t-1]/fv); # Kapitalgevinster (plus evt. profit fra entreprenør-agenten, som opstår pga. installationsomkostninger i sammensætning af land og bygningskapital)

    E_vBoligUdgiftArv[t]$(tx0[t] and t.val > 2015).. vBoligUdgiftArv[t] =E= sum(a, (1-rOverlev[a-1,t-1]) * nPop[a-1,t-1] * dBoligUdgift[a,t] * vBolig[a-1,t-1]/fv);

    E_vCLejeBolig[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      vCLejeBolig[a,t] / vCLejeBolig[aTot,t] =E= rvCLejeBolig[a,t] / rvCLejeBolig[aTot,t];

    E_rvCLejeBolig_tot[t]$(tx0[t] and t.val > 2015).. rvCLejeBolig[aTot,t] =E= sum(aa, rvCLejeBolig[aa,t] * nPop[aa,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Individual non-housing consumption decision by age
    # ------------------------------------------------------------------------------------------------------------------  
    E_fDisk[a,t]$(tx0E[t] and t.val > 2015 and a.val < 100)..
      fDisk[a,t] =E= (1+jfDisk[a,t]+jfDisk_t[t]) / (1+rDisk)
                   * (1 - eDisk2LM * nSoegHh[a+1,t+1]/nPop[a+1,t+1] * (rJobFinding[a+1,t+1] / srJobFinding[t+1] - 1));

    E_fDisk_End[a,t]$(tEnd[t] or (tx0[t] and t.val > 2015 and a.val = 100))..
      fDisk[a,t] =E= (1+jfDisk[a,t]+jfDisk_t[t]) / (1+rDisk);

    # Rational forward-looking consumers
    E_qCR[a,t]$(a18t100[a] and tx0E[t] and t.val > 2015)..
      mUC[a,t] =E= (ErOverlev[a,t] * (1 + mrHhxAfk[t+1]) / EpC[t] * EmUC[a,t]
                 + ErOverlev[a,t] * dFormue[a,t]
                 + (1-ErOverlev[a,t]) * dArv[a,t]) * pC['cIkkeBol',t] * fDisk[a,t];

    E_qCR_tEnd[a,t]$(a18t100[a] and tEnd[t])..
      mUC[a,t] =E= (ErOverlev[a,t] * (1 + mrHhxAfk[t]) / EpC[t] * EmUC[a,t]
                 + ErOverlev[a,t] * dFormue[a,t]
                 + (1-ErOverlev[a,t]) * dArv[a,t]) * pC['cIkkeBol',t] * fDisk[a,t];

    E_qCR_tot[t]$(tx0[t] and t.val > 2015)..
      qCR[aTot,t] =E= sum(a, (1-rHtM) * qCR[a,t] * nPop[a,t]);  

    E_qCRxRef[a,t]$(tx0[t] and a18t100[a] and a.val <> 18 and t.val > 2015)..
      qCRxRef[a,t] =E= qCR[a,t] / fHh[a,t] - rRef * qCR[a-1,t-1]/fq / fHh[a-1,t-1] 
                     - jqC[t] * qCR[a-1,t-1]
                     - jqCR[a,t];

    E_qCRxRef_a18[a,t]$(tx0[t] and a.val = 18 and t.val > 2015)..
      qCRxRef[a,t] =E= qCR[a,t] / fHh[a,t] - rRef * qCR[a,t]/fq / fHh[a,t] - jqCR[a,t];

    E_qCRxRef_tot[t]$(tx0[t] and t.val > 2015).. qCRxRef[aTot,t] =E= sum(a, (1-rHtM) * qCRxRef[a,t] * nPop[a,t]);

    E_mUC[a,t]$(tx0[t] and a18t100[a] and t.val > 2015)..
      mUC[a,t] =E= qNytte[a,t]**(-eHh) * (qNytte[a,t] * (1-uBoligR[a,t]) / qCRxRef[a,t])**(1/eNytte);

    E_qNytte[a,t]$(tx0[t] and a18t100[a] and t.val > 2015)..
      qNytte[a,t] =E= (
        (1-uBoligR[a,t])**(1/eNytte) * qCRxRef[a,t]**((eNytte-1)/eNytte)
        + uBoligR[a,t]**(1/eNytte) * qBoligRxRef[a,t]**((eNytte-1)/eNytte)
      )**(eNytte/(eNytte-1));

    # Forventet marginal nytte af forbrug
    E_EmUC[a,t]$(18 <= a.val and a.val < 100 and tx0E[t] and t.val > 2015).. EmUC[a,t] =E= mUC[a+1,t+1] * fq**(-eHh);
    E_EmUC_tEnd[a,t]$(18 <= a.val and a.val < 100 and tEnd[t]).. EmUC[a,t] =E= mUC[a+1,t] * fq**(-eHh);
    E_EmUC_aEnd[a,t]$(a.val = 100 and tx0E[t] and t.val > 2015).. EmUC[a,t] =E= mUC[a,t+1] * fq**(-eHh);
    E_EmUC_aEnd_tEnd[a,t]$(a.val = 100 and tEnd[t]).. EmUC[a,t] =E= mUC[a,t] * fq**(-eHh);

    # 15-17 er aktive på arbejdsmarkedet, men har ikke forbrug.
    # Marginalnytte af forbrug kan dog påvirke arbejdsmarkedsbeslutning og antages lig 18-åriges.
    E_mUC_unge[a,t]$(tx0[t] and 15 <= a.val and a.val < 18  and t.val > 2015)..
      mUC[a,t] =E= mUC['18',t];

    # Not age dependent but only used with age-dependent variables
    E_EpC[t]$(tx0E[t] and t.val > 2015)..
      EpC[t] =E= pC['cIkkeBol',t+1]*fp * (1 + jfEpC[t]);
    E_EpC_tEnd[t]$(tEnd[t])..
      EpC[t] =E= pC['cIkkeBol',t] * pC['cIkkeBol',t]/(pC['cIkkeBol',t-1]/fp) * (1 + jfEpC[t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Hand-to-mouth consumers
    # ------------------------------------------------------------------------------------------------------------------
    # Budgetbegrænsning
    E_vHhxHtM[a,t]$(tx0[t] and a18t100[a] and t.val > 2015)..
      vHhxHtM[a,t] =E= (vHhxHtM[a-1,t-1]/fv + vHhxHtMAfk[a,t]) * fMigration[a,t]
                     + vHhIndHtM[a,t]

                     # Samlet forbrug
                     - pC['cIkkeBol',t] * qCHtM[a,t]
                     - vCLejeBolig[a,t]
                     - vBoligUdgiftHtM[a,t];

    E_vHhIndHtM[a,t]$(tx0[t] and a0t100[a] and t.val > 2015)..
      vHhIndHtM[a,t] =E= vHhInd[a,t]
                       - (vHhPensUdb['Kap',a,t] - vHhPensIndb['Kap',a,t] - vtKapPens[a,t]) # HtM-husholdninger har ikke kapital-pension (og betaler ikke afgift)
                       - (vHhPensUdb['Alder',a,t] - vHhPensIndb['Alder',a,t]) # HtM-husholdninger har ikke alders-pension
                       + vtAktie[a,t] # Aktieafkast betales alene af fremadskuende husholdninger
                       - vArvKorrektion[a,t]; # Øget formue fra selektionseffekt antages ikke at gå til hånd-til-mund forbrugere 
    E_vHhIndHtM_tot[t]$(tx0[t] and t.val > 2015).. vHhIndHtM[aTot,t] =E= sum(a, rHtM * vHhIndHtM[a,t] * nPop[a,t]);

    E_vHhxHtM_0t17[a,t]$(tx0[t] and a0t17[a] and t.val > 2015).. vHhxHtM[a,t] =E= 0;

    E_qCHtM[a,t]$(tx0[t] and 18 < a.val and a.val <=100 and t.val > 2015)..
      pC['cIkkeBol',t] * qCHtM[a,t] + vCLejeBolig[a,t] + vBoligUdgiftHtM[a,t] =E=
        + (1-rHtMTraeghed) * ((vHhxHtM[a-1,t-1]/fv + vHhxHtMAfk[a,t]) * fMigration[a,t] + vHhIndHtM[a,t])
        + rHtMTraeghed * (pC['cIkkeBol',t-1] * qCHtM[a-1,t-1] + vCLejeBolig[a-1,t-1] + vBoligUdgiftHtM[a-1,t-1]) * fHtMTraeghed[a,t];

    E_qCHtM_18[a,t]$(tx0[t] and a.val = 18 and t.val > 2015)..
      pC['cIkkeBol',t] * qCHtM[a,t] + vCLejeBolig[a,t] + vBoligUdgiftHtM[a,t] =E=
      ((vHhxHtM[a-1,t-1]/fv + vHhxHtMAfk[a,t]) * fMigration[a,t] + vHhIndHtM[a,t]) * fHtMTraeghed[a,t];

    E_qCHtM_tot[t]$(tx0[t] and t.val > 2015)..
      qCHtM[atot,t] =E= sum(a, rHtM * qCHtM[a,t] * nPop[a,t]);

    E_qCHtMxRef[a,t]$(tx0[t] and a18t100[a] and a.val <> 18 and t.val > 2015)..
      qCHtMxRef[a,t] =E= qCHtM[a,t] / fHh[a,t] - rRef * qCHtM[a-1,t-1]/fq / fHh[a-1,t-1];

    E_qCHtMxRef_a18[a,t]$(tx0[t] and a.val = 18 and t.val > 2015)..
      qCHtMxRef[a,t] =E= qCHtM[a,t] / fHh[a,t] - rRef * qCHtM[a,t]/fq / fHh[a,t];

    E_qBoligHtMxRef[a,t]$(a18t100[a] and a.val <> 18 and tx0[t] and t.val > 2015)..
      qBoligHtMxRef[a,t] =E= qBoligHtM[a,t] / fHh[a,t] - rRefBolig[a,t] * qBoligHtM[a-1,t-1]/fq / fHh[a-1,t-1]
                           - jqBolig[t] * qBoligHtM[a-1,t-1];

    E_qBoligHtMxRef_a18[a,t]$(a.val = 18 and tx0[t] and t.val > 2015)..
      qBoligHtMxRef[a,t] =E= qBoligHtM[a,t] / fHh[a,t] - rRefBolig[a,t] * qBoligHtM[a,t]/fq / fHh[a,t];

    E_qBoligHtM[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      qBoligHtMxRef[a,t] =E= uBoligHtM[a,t] * qCHtMxRef[a,t] * (pBolig[t] / pC['cIkkeBol',t])**(-eNytte);
 
    E_vBoligUdgiftHtM[a,t]$(tx0[t] and t.val > 2015)..
      vBoligUdgiftHtM[a,t] =E= (1-rRealKred2Bolig[a,t]) * vBoligHtM[a,t]
                             + dBoligUdgift[a,t] * vBoligHtM[a-1,t-1]/fv * fMigration[a,t];
    E_vBoligUdgiftHtM_tot[t]$(tx0[t] and t.val > 2015)..
      vBoligUdgiftHtM[aTot,t] =E= rHtM * sum(a, vBoligUdgiftHtM[a,t] * nPop[a,t]);

    E_vBoligHtM[a,t]$(a18t100[a] and tx0[t]).. vBoligHtM[a,t] =E= pBolig[t] * qBoligHtM[a,t];

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

    E_vBoligHtM_tot[t]$(tx0[t]).. vBoligHtM[aTot,t] =E= pBolig[t] * qBoligHtM[aTot,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Coupling of consumption by household type and CES tree
    # ------------------------------------------------------------------------------------------------------------------
    E_qC_cIkkeBol[t]$(tx0[t] and t.val > 2015).. qC['cIkkeBol',t] =E= qCR[aTot,t] + qCHtM[aTot,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Bolig-efterspørgsel for fremadskuende husholdninger
    # ------------------------------------------------------------------------------------------------------------------
    E_qBoligRxRef[a,t]$(a18t100[a] and a.val <> 18 and tx0[t] and t.val > 2015)..
      qBoligRxRef[a,t] =E= qBoligR[a,t] / fHh[a,t] - rRefBolig[a,t] * qBoligR[a-1,t-1]/fq / fHh[a-1,t-1]
                         - jqBolig[t] * qBoligR[a-1,t-1];

    E_qBoligRxRef_a18[a,t]$(a.val = 18 and tx0[t] and t.val > 2015)..
      qBoligRxRef[a,t] =E= qBoligR[a,t] / fHh[a,t] - rRefBolig[a,t] * qBoligR[a,t]/fq / fHh[a,t];

    E_qBoligRxRef_tot[t]$(tx0[t] and t.val > 2015).. qBoligRxRef[aTot,t] =E= sum(a, (1-rHtM) * qBoligRxRef[a,t] * nPop[a,t]);

    # Usercost
    E_pBoligUC[a,t]$(a18t100[a] and tx0E[t] and t.val>2015) ..
      (1+mrHhxAfk[t+1]) * pBoligUC[a,t] =E= pBolig[t]
                                          - (1-rAfskr['iB','bol',t+1]) * pBolig[t+1]*fp # Værdi næste periode
                                          - pLand[t+1]*fp * qLandSalg[t+1]*fq / qBolig[atot,t] # Forventet udbytte af landsalg i næste periode
                                          + ( rRealKred2Bolig[a,t] * mrHhAfk['RealKred',t+1] # Marginal rente på realkredit efter skat
                                              + (1-rRealKred2Bolig[a,t]) * mrHhxAfk[t+1] # Offerrente på andelen som ikke finansieres med realkredit
                                              + tEjd[t+1] # Ejendomsværdiskat
                                              + rBoligOmkRest[t+1] # Resterende udgifter
                                              + rBoligPrem[t+1] # Risikopræmie
                                          ) * pBolig[t]
                                          - dvHhxAfk2dqBolig[t+1]; # Ændring i afkast på husholdningens frie formue (vHhx) pga. at portefølje afhænger af boligmænge (sker via højere bankgæld, da en del finansieres via dette)

    # Merging of FOC for housing with FOC for net assets
    E_qBoligR[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      mUBolig[a,t] + fDisk[a,t] * ErOverlev[a,t] * dULead2dBolig[a,t]
      =E= fDisk[a,t] * ErOverlev[a,t] * pBoligUC[a,t] * (1+mrHhxAfk[t+1]) / EpC[t] * EmUC[a,t];

    E_qBoligR_tEnd[a,t]$(a18t100[a] and tEnd[t])..
      mUBolig[a,t] + fDisk[a,t] * ErOverlev[a,t] * dULead2dBolig[a,t]
      =E= fDisk[a,t] * ErOverlev[a,t] * pBoligUC[a,t-1] * (1+mrHhxAfk[t]) / EpC[t] * EmUC[a,t];

    # Nyttefunktion for fremadskuende husholdninger
    E_muBolig[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      mUBolig[a,t] =E= qNytte[a,t]**(1/eNytte-eHh) * (uBoligR[a,t] / qBoligRxRef[a,t])**(1/eNytte) / fHh[a,t]
                     - dpBoligTraeghed[t];

    # Boligpris-træghed fra disnytte ved boligprisændringer 
    E_dpBoligTraeghed[t]$(tx0E[t] and t.val > 2015)..
      dpBoligTraeghed[t] =E= upBoligTraeghed * ((pBolig[t]/pBolig[t-1]) / (pBolig[t-1]/pBolig[t-2]) - 1)
                                             *  (pBolig[t]/pBolig[t-1]) / (pBolig[t-1]/pBolig[t-2])
           - 2 / (1+rDisk) * upBoligTraeghed * ((pBolig[t+1]/pBolig[t]) / (pBolig[t]/pBolig[t-1]) - 1)
                                             *  (pBolig[t+1]/pBolig[t]) / (pBolig[t]/pBolig[t-1]);
   
    E_dpBoligTraeghed_tEnd[t]$(tEnd[t] and t.val > 2015).. dpBoligTraeghed[t] =E= 0;

    E_dULead2dBolig[a,t]$(18 <= a.val and a.val < 100 and tx0E[t] and t.val > 2015)..
      dULead2dBolig[a,t] =E= - rRefBolig[a+1,t+1] / fHh[a,t] * (qNytte[a+1,t+1]*fq)**(1/eNytte-eHh)
                           * (uBoligR[a+1,t+1] / (qBoligRxRef[a+1,t+1]*fq))**(1/eNytte);
    E_dULead2dBolig_tEnd[a,t]$(18 <= a.val and a.val < 100 and tEnd[t])..
      dULead2dBolig[a,t] =E= - rRefBolig[a+1,t] / fHh[a,t] * (qNytte[a+1,t]*fq)**(1/eNytte-eHh)
                           * (uBoligR[a+1,t] / (qBoligRxRef[a+1,t]*fq))**(1/eNytte);
    E_dULead2dBolig_aEnd[a,t]$(a.val = 100 and tx0E[t] and t.val > 2015)..
      dULead2dBolig[a,t] =E= - rRefBolig[a+1,t+1] / fHh[a,t] * (qNytte[a,t+1]*fq)**(1/eNytte-eHh)
                           * (uBoligR[a,t+1] / (qBoligRxRef[a,t+1]*fq))**(1/eNytte);
    E_dULead2dBolig_aEnd_tEnd[a,t]$(a.val = 100 and tEnd[t])..
      dULead2dBolig[a,t] =E= - rRefBolig[a+1,t] / fHh[a,t] * (qNytte[a,t]*fq)**(1/eNytte-eHh)
                           * (uBoligR[a,t] / (qBoligRxRef[a,t]*fq))**(1/eNytte);

    # Post model variable
    E_vBoligUdgiftR_tot[t]$(tx0[t] and t.val > 2015)..
      vBoligUdgift[aTot,t] =E= vBoligUdgiftHtM[aTot,t] + vBoligUdgiftR[aTot,t] + vBoligUdgiftArv[t];

    # ------------------------------------------------------------------------------------------------------------------
    # CES-efterspørgsel efter bolig-kapital og land
    # ------------------------------------------------------------------------------------------------------------------
    # En gennemsnitlig landpris bestemmes under antagelse af nul profit ved boligbyggeri
    E_pLand[t]$(tx0[t])..
      pBolig[t] * (qYBolig[t] - qIBoligInstOmk[t]) =E= pLand[t] * qLandSalg[t] + pI_s['iB','bol',t] * qIBolig[t];

    # ------------------------------------------------------------------------------------------------------------------
    # Nytte af arv
    # ------------------------------------------------------------------------------------------------------------------
    # Arv videregivet pr kohorte
    E_vArvGivet[a,t]$(tx0[t] and t.val > 2015)..
      vArvGivet[a,t] =E= (vHhx[a-1,t-1]/fv + vHhxAfk[a,t] - dBoligUdgift[a,t] * vBolig[a-1,t-1]/fv) * rArvKorrektion[a]
                       - vtDoedsbo[a,t] + vPensArv['pens',a,t] - vtKapPensArv[a,t];

    E_vArvKorrektion[a,t]$(tx0[t] and a0t100[a] and t.val > 2015)..
      vArvKorrektion[a,t] =E= (vHhx[a-1,t-1]/fv + vHhxAfk[a,t] - dBoligUdgift[a,t] * vBolig[a-1,t-1]/fv)
                            * (1-rArvKorrektion[a]) * (1-rOverlev[a-1,t-1]) * nPop[a-1,t-1] / nPop[a,t];

    E_vArvKorrektion_aTot[t]$(tx0[t] and t.val > 2015)..
      vArvKorrektion[aTot,t] =E= sum(a, vArvKorrektion[a,t] * nPop[a,t]);

    E_vArv_aTot[t]$(tx0[t] and t.val > 2015).. vArv[aTot,t] =E= sum(a, vArvGivet[a,t] * (1-rOverlev[a-1,t-1]) * nPop[a-1,t-1]);

    # Arv modtaget
    E_vArv[a,t]$(tx0[t] and t.val > 2015).. vArv[a,t] =E= rArv[a,t] * vArv[aTot,t] / nPop[aTot,t];

    # Hjælpevariabel som skal være strengt positiv
    E_qArvBase[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      qArvBase[a,t] =E= (1-tArv[t+1]) * (vHhxR[a,t]
                                       + pBolig[t] * qBoligR[a,t] * (1 - rRealKred2Bolig[a,t])
                                       + (vPensArv['Pens',a,t] - rHtM * vPensArv['PensX',a,t]) / (1-rHtM)  # Samlet pension for fremadskuende agenter, som gives videre i tilfælde af død
                                       ) / EpC[t];
 
    # Derivative of bequest utility with respect to net assets 
    E_dArv[a,t]$(a18t100[a] and d1Arv[a,t] and tx0E[t] and t.val > 2015)..
      dArv[a,t] =E= uArv[t] * (1-tArv[t+1]) / EpC[t] * qArvBase[a,t]**(-eHh);
    E_dArv_tEnd[a,t]$(a18t100[a] and d1Arv[a,t] and tEnd[t])..
      dArv[a,t] =E= uArv[t] * (1-tArv[t]) / EpC[t] * qArvBase[a,t]**(-eHh);

    # ------------------------------------------------------------------------------------------------------------------
    # Nytte af formue
    # ------------------------------------------------------------------------------------------------------------------
    E_qFormueBase[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      qFormueBase[a,t] =E= (vHhxR[a,t]
                            + pBolig[t] * qBoligR[a,t] * (rMaxRealkred[t] - rRealKred2Bolig[a,t])
                            + ((1-tKapPens[t]) * vHh['Kap',a,t] + vHh['Alder',a,t]) / (1-rHtM)
                           ) / EpC[t];

    # Derivative of wealth utility with respect to net assets
    E_dFormue[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      dFormue[a,t] =E= uFormue[t] / EpC[t] * qFormueBase[a,t]**(-eHh);

    # ------------------------------------------------------------------------------------------------------------------
    # Overførsler mellem børn og forældre som redegør for ændringer i børns opsparing. 
    # ------------------------------------------------------------------------------------------------------------------
    E_vBoernFraHh[a,t]$(tx0[t] and a0t17[a] and t.val > 2015)..
      vHhx[a,t] =E= uBoernFraHh[a,t] * vHhx[aTot,t] / nPop[a,t];

    E_vHhTilBorn_aTot[t]$(tx0[t] and t.val > 2015).. vHhTilBoern[aTot,t] =E= sum(aa, vBoernFraHh[aa,t] * nPop[aa,t]);

    E_vHhTilBoern[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      vHhTilBoern[a,t] =E= rBoern[a,t] * vHhTilBoern[aTot,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Opdeling af aldersfordelte parametre i tids- og aldersfordelte elementer
    # ------------------------------------------------------------------------------------------------------------------
    E_uBoligR[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      uBoligR[a,t] =E= fuBolig[t] * uBoligR_a[a,t];

    E_fHh[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      fHh[a,t] =E= 1 + 0.5 * rBoern[a,t] * nPop['a0t17',t];

    E_uBoligHtM[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      uBoligHtM[a,t] =E= fuBolig[t] * uBoligHtM_a[a,t] * uBoligHtM_match;

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

    # Post model equations
    E_vCR_NR[a,t]$(a0t100[a] and tx0[t])..
      vCR_NR[a,t] =E= pC['cikkebol',t] * qCR[a,t] 
                    + pC['cbol',t] * qC['cbol',t] 
                      * ( qKLejebolig[t-1]/qKBolig[t-1] * (vCLejebolig[a,t] / vCLejebolig[aTot,t])
                         + (qKBolig[t-1]-qKLejebolig[t-1])/qKBolig[t-1] * (qBoligR[a,t] / qBolig[aTot,t]) );

    E_qCR_NR[a,t]$(a0t100[a] and tx0[t]).. qCR_NR[a,t] =E= vCR_NR[a,t] / pC['ctot',t];

    E_vCHtM_NR[a,t]$(a0t100[a] and tx0[t])..
      vCHtM_NR[a,t] =E= pC['cikkebol',t] * qCHtM[a,t] 
                      + pC['cbol',t] * qC['cbol',t] 
                        * ( qKLejebolig[t-1]/qKBolig[t-1] * (vCLejebolig[a,t] / vCLejebolig[aTot,t])
                           + (qKBolig[t-1]-qKLejebolig[t-1])/qKBolig[t-1] * (qBoligHtM[a,t] / qBolig[aTot,t]) );

    E_qCHtM_NR[a,t]$(a0t100[a] and tx0[t]).. qCHtM_NR[a,t] =E= vCHtM_NR[a,t] / pC['ctot',t];

    E_vC_NR[a,t]$(a0t100[a] and tx0[t]).. vC_NR[a,t] =E= (1-rHtM) * vCR_NR[a,t] + rHtM * vCHtM_NR[a,t];

    E_qC_NR[a,t]$(a0t100[a] and tx0[t]).. qC_NR[a,t] =E= vC_NR[a,t] / pC['cTot',t];
  $ENDBLOCK

  MODEL M_consumers / 
      B_consumers_a
      B_consumers_aTot
  /;

  # Equations that do not need to be solved together with the full model and can instead be solved afterwards.
  MODEL M_consumers_post /
    E_vCR_NR, E_vCR_NR_tot
    E_qCR_NR, E_qCR_NR_tot
    E_vCHtM_NR, E_vCHtM_NR_tot
    E_qCHtM_NR, E_qCHtM_NR_tot
    E_vC_NR, E_vC_NR_tot
    E_qC_NR, E_qC_NR_tot
    E_vHhxR_aTot, E_vHhxHtM_aTot
    E_vHhIndR_tot, E_vHhIndHtM_tot
    E_vHhxRAfk_aTot, E_vHhxHtMAfk_aTot
    E_vBoligUdgiftHtM_tot
    E_vBoligUdgiftR_tot
    E_pCPI
    E_pCPI_cTot
    E_pHICP
    E_pnCPI
    E_pnCPI_cTot
  /;

  # Endogenous variables that are solved for only after the main model.
  # Note that these may not appear anywhere in the main model (this results in a model not square error).
  $GROUP G_consumers_post
    vCR_NR
    qCR_NR
    vCHtM_NR
    qCHtM_NR
    vC_NR
    qC_NR
    vHhxR$(aTot[a_] and t.val > 2015), vHhxHtM$(aTot[a_] and t.val > 2015)
    vHhxRAfk$(aTot[a_] and t.val > 2015), vHhxHtMAfk$(aTot[a_] and t.val > 2015)
    vHhIndHtM[a_,t]$(aTot[a_] and t.val > 2015), vHhIndR[a_,t]$(aTot[a_] and t.val > 2015)
    vBoligUdgiftHtM$(aTot[a_])
    vBoligUdgiftR[a_,t]$(aTot[a_] and t.val > 2015)
    pCPI$(c[c_] or cTot[c_])
    pHICP
    pnCPI$(c[c_] or cTot[c_])
  ;
  $GROUP G_consumers_post G_consumers_post$(tx0[t]);
  $ENDIF


$IF %stage% == "exogenous_values":  
# =============================================================================================½=========================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_consumers_makrobk
    vHhx$(aTot[a_]), vBolig$(aTot[a_]), qBolig$(aTot[a_]), vHhInvestx$(aTot[a_]), vSelvstKapInd$(aTot[a_])
    qKBolig, vKBolig, qBiler, qIBolig, pBolig, qLand, qKLejeBolig, qC, rRente, pCPI[c_,t]$(c[c_] or cTot[c_]), rCPI[c,t]
    pnCPI[c_,t]$(c[c_] or cTot[c_]), rnCPI, rHICP, pHICP
  ;
  @load(G_consumers_makrobk, "..\Data\makrobk\makrobk.gdx" )

  # Aldersfordelt data fra aldersprofiler indlæses
  $GROUP G_consumers_aldersprofiler
    vHhx$(a[a_])
    vCLejeBolig$(a[a_])
    vC_a
  ;
  $GROUP G_consumers_aldersprofiler
    G_consumers_aldersprofiler$(tAgeData[t])
    rArvKorrektion, rArv_a # Ikke-tidsfordelte variable lægges til
  ;
  @load(G_consumers_aldersprofiler, "..\Data\Aldersprofiler\aldersprofiler.gdx" )

  # Aldersfordelt data fra BFR indlæses
  $GROUP G_consumers_BFR
    rBoern, rOverlev, ErOverlev, nPop
  ;
  @load(G_consumers_BFR, "..\Data\Befolkningsregnskab\BFR.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_consumers_data  
    G_consumers_makrobk
    G_consumers_BFR
  ;
  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_consumers_data_imprecise 
    empty_group_dummy
  ;

# =============================================================================================½=========================
# Exogenous variables
# ======================================================================================================================
  eHh.l = 1/0.8;
  eNytte.l = 0.3;
  
  rDisk.l = (1+terminal_rente) / fp - 1;
  eDisk2LM.l = 1;
  d1Arv[a,t]$(a18t100[a]) = (ErOverlev.l[a,t] < 0.995); # Kun aldersgrupper med forventet dødssansynlighed over 0.5% har arvemotiv

  # Elasticities of substitution in the private consumption nests
  eC.l['cTurTje'] = 1.25;
  eC.l['cTurTjeVar'] = 0.94;
  eC.l['cTurTjeVarEne'] = 0.26;
  eC.l['cIkkeBol'] = 1.04;

  # Fraction of hand-to-mouth consumers
  rHtM.l = 0.5; # Matching parameter
  uBoligHtM_match.l = 1.393659;  # Matching parameter
  rHtMTraeghed.l = 0.199394; # Matching parameter

  rRef.l = 0.1; # Matching parameter
  # Andele for vanedannelse i forbrug er som udgangspunkt konstant,
  # men reduceres for de ældste kohorter (som har en væsentlig dødssandsynlighed) og dermed tyndere data og større variation
  rRefBolig.l[a,t] = 0.485956 * ErOverlev.l[a-1,t-1];
  rMaxRealkred.l[t] = 1;

  # Housing
  eBolig.l = 1.16; # Epple et al (2010)
  uIBoligInstOmk.l = 1.204003; # Matching parameter
  upBoligTraeghed.l = 1.665193;
  
  fuBolig.l[t] = 1;

  rBoligPrem.l[t] = max(0.03, 0.07 - rRente.l["Obl",t]);


# ======================================================================================================================
# Data assignment
# ======================================================================================================================
  # Bequest distribution weighted by population size
  nArvinger.l[a,t] = sum(aa, rArv_a.l[a-1,aa-1] * nPop.l[aa,t]);

  EpC.l[t]$(tBase[t]) = 1;

  # Initiale formue for HtM-husholdingerne er 0, dvs. dermed tilfalder vHhx i data de fremadskuende huseholdninger
  vHhxR.l[a,t] = vHhx.l[a,t] / (1-rHtM.l);
  vHhxR.l[aTot,t] = vHhx.l[aTot,t];
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_consumers_static_calibration_base
    G_consumers_endo
    -pBolig, uLand
    -qBiler, rBilAfskr
    -vHhInvestx$(aTot[a_]), rHhInvestx
    -vSelvstKapInd$(aTot[a_]), rSelvstKapInd
    -qKBolig, uIBolig
    -qC$(not sameas[c_, "cIkkeBol"]), uC0$(not sameas[c_, "cIkkeBol"]), fuCnest # E_fuCnest
    fIBoligInstOmk[t] # E_fIBoligInstOmk
    -pCPI[c_, t]$(c[c_] or cTot[c_]), fpCPI[c_, t]$(c[c_] or cTot[c_]) 
    -pHICP[t], fpHICP[t]
    -pnCPI[c_, t]$(c[c_] or cTot[c_]), fpnCPI[c_, t]$(c[c_] or cTot[c_]) 
  ;    
  $BLOCK B_consumers_static_calibration_base
    E_fuCnest[cNest,t]$(tx0[t]).. sum(c_$cNest2c_[cNest,c_], uC0[c_,t]) =E= sum(c_$cNest2c_[cNest,c_], uC[c_,t]);

    E_fIBoligInstOmk[t]$(tx0[t]).. qIBolig[t] / qIBolig[t-1]*fq - fIBoligInstOmk[t] =E= 0;
  $ENDBLOCK

  $GROUP G_consumers_simple_static_calibration
    G_consumers_static_calibration_base
    -G_consumers_endo_a
    -vHhx$(aTot[a_] and t.val > 2015), jvHhxAfk$(aTot[a_] and t.val > 2015)
  ;    
  $GROUP G_consumers_simple_static_calibration G_consumers_simple_static_calibration$(tx0[t]);

  MODEL M_consumers_simple_static_calibration /
      M_consumers
      - B_consumers_a
      B_consumers_static_calibration_base
  /;

  $GROUP G_consumers_static_calibration
    G_consumers_static_calibration_base
    -qC$(sameas[c_, "cIkkeBol"]), uC0$(sameas[c_, "cIkkeBol"])
    fHh$(t.val = 2015) # E_qCR_2015
    qCR$(a18t100[a_] and t.val = 2015) #E_qCR_2015
    qCHtM$(a18t100[a_] and t.val = 2015) #E_qCHtM_2015
    qBoligR$(a18t100[a_] and t.val = 2015) #E_qBoligR_2015
    qBoligHtM$(a18t100[a_] and t.val = 2015) #E_qBoligHtM_2015

    # Vi ønsker ikke at have fremadskuende hjælpeligninger med i statisk kalibrering
    # Opslitning af boliger bestemmes ved E_uBoligHTM_a og qBoligR bestemmes derfor ud fra vBolig
    -uBoligR # -E_uBoligR
      -EmUC # -E_EmUC, -E_EmUC_tEnd, -E_EmUC_aEnd, -E_EmUC_aEnd_tEnd
        -dULead2dBolig # -E_dULead2dBolig, -E_dULead2dBolig_tEnd, -E_dULead2dBolig_aEnd, -E_dULead2dBolig_aEnd_tEnd
        -mUBolig # -E_qBoligR, -E_qBoligR_tEnd
      -qNytte # -E_qNytte
        -mUC # -E_mUC, -E_mUC_unge
      -vBolig[a_,t]$(a18t100[a_]) # -E_muBolig

    -vHhx$(a0t17[a_]), uBoernFraHh_a$(a0t17[a] and t.val > 2015) 
    -vHhx$(a18t100[a_]), jvHhxAfk$(a18t100[a_] and t.val > 2015)
    jfEpC$(t.val = 2016) # E_jfEpC
    uBoligHtM_a$(t.val > 2015) # E_uBoligHtM_a
    -vCLejeBolig$(a18t100[a_]), rvCLejeBolig$(a18t100[a_] and t.val > 2015)
    rArv$(t.val > 2015) # E_rArv_static
    -vC_a$(a.val > 18) # -E_qCR, -E_qCR_tEnd

    fHtMTraeghed$(a18t100[a]), -vHhxHtM$(a18t100[a_])

    -dpBoligTraeghed # -E_dpBoligTraeghed
  ;    
  $GROUP G_consumers_static_calibration G_consumers_static_calibration$(tx0[t]);

  $BLOCK B_consumers_static_calibration
    E_qCR_2015[a,t]$(t.val = 2015 and a18t100[a])..
      (pC['cIkkeBol',t] * qCR[a,t]) / (pC['cIkkeBol',t+1]*fp * qCR[a,t+1]*fq) =E= vC_a[a,t] / (vC_a[a,t+1]*fv);
    E_qCHtM_2015[a,t]$(t.val = 2015 and a18t100[a])..
      (pC['cIkkeBol',t] * qCHtM[a,t]) / (pC['cIkkeBol',t+1]*fp * qCHtM[a,t+1]*fq) =E= vC_a[a,t] / vC_a[a,t+1]*fv;

    E_qBoligR_2015[a,t]$(t.val = 2015 and a18t100[a])..
      qBoligR[a,t] / qBolig[a,t] =E= qBoligR[a,t+1] / qBolig[a,t+1];
    E_qBoligHtM_2015[a,t]$(t.val = 2015 and a18t100[a])..
      qBolig[a,t] =E= (1-rHtM) * qBoligR[a,t] + rHtM * qBoligHtM[a,t];

    E_fHh_2015[a,t]$(a18t100[a] and t.val = 2015).. fHh[a,t] =E= 1 + 0.5 * rBoern[a,t] * nPop['a0t17',t];

    E_jfEpC[t]$(t.val = 2016).. EpC[t] =E= pC['cIkkeBol',t] * fp;

    E_rArv_static[a,t]$(tx0[t] and t.val > 2015)..
      vArv[a,t] =E= sum(aa$(aa.val > 0), vArvGivet[aa,t] * (1-rOverlev[aa-1,t-1]) * nPop[aa-1,t-1] / nArvinger[aa,t] * rArv_a[aa-1,a-1]);

    E_rvCLejeBolig[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      rvCLejeBolig[a,t] =E= vCLejeBolig[a,t] / vCLejeBolig[aTot,t];

    E_uBoligHtM_a[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      qBoligHtMxRef[a,t] / qCHtMxRef[a,t] =E= uBoligHtM_match * qBoligRxRef[a,t] / qCRxRef[a,t];
  $ENDBLOCK
  MODEL M_consumers_static_calibration /
      M_consumers
      B_consumers_static_calibration_base
      B_consumers_static_calibration
    - E_uBoligR - E_EmUC - E_EmUC_tEnd - E_EmUC_aEnd - E_EmUC_aEnd_tEnd
    - E_qBoligR - E_qBoligR_tEnd - E_qNytte - E_mUC - E_mUC_unge - E_muBolig
    - E_dULead2dBolig - E_dULead2dBolig_tEnd - E_dULead2dBolig_aEnd - E_dULead2dBolig_aEnd_tEnd
    - E_vCLejeBolig
    - E_qCR - E_qCR_tEnd
    - E_dpBoligTraeghed
  /;
$ENDIF

# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_consumers_deep    
    G_consumers_endo

    -vC_a[a,t]$(t1[t] and a18t100[a]), jqCR[a,t]$(t1[t] and a18t100[a])

    -qBolig[a_,t]$(a18t100[a_] and t1[t]), uBoligR_a[a,t] # E_uBoligR_a_forecast
    -pBolig$(t1[t]), uLand # E_uLand_forecast
    -qKBolig$(t1[t]), uIBolig # E_uIBolig_forecast

    vArvPrArving[a,t] "Hjælpevariabel til beregning af arvens fordelingsnøgle, rArv." # E_vArvPrArving
    rArv # E_rArv
    qKLejeBolig, -rKLeje2Bolig

    fIBoligInstOmk[t]$(tx1[t]) # E_fIBoligInstOmk_forecast

    fHtMTraeghed$(a18t100[a]), -vHhxHtM$(a18t100[a_])

    uArv$(t1[t]) # E_uArv
    uArv$(tx1[t]) # E_uArv_forecast
    uFormue$(t1[t]) # E_uFormue
    uFormue$(tx1[t]) # E_uFormue_forecast
  ;

  $GROUP G_consumers_deep
    G_consumers_deep$(tx0[t])
  ;

  $BLOCK B_consumers_deep
    E_vArvPrArving[a,t]$(tx0[t] and a.val > 0)..
      vArvPrArving[a,t] =E= vArvGivet[a,t] * (1-rOverlev[a-1,t-1]) * nPop[a-1,t-1] / nArvinger[a,t];
    E_rArv[a,t]$(tx0[t]).. vArv[a,t] =E= sum(aa$(aa.val > 0), vArvPrArving[aa,t] * rArv_a[aa-1,a-1]);

    # Identificerende antagelse for arvemotiv:
    #  jqCR er i gennemsnit 0 for døende husholdninger
    E_uArv[t]$(t1[t]).. sum(a$(a18t100[a] and d1Arv[a,t]), (1-ErOverlev[a,t]) * nPop[a,t] * jqCR[a,t]) =E= 0;
    E_uArv_forecast[t]$(tx1[t]).. uArv[t] =E= uArv[t1];

    # Identificerende antagelse for formuemotiv:
    # Forbrug rammes i gennemsnit uden fejl-led. Dvs. jqCR er i gennemsnit 0
    E_uFormue[t]$(t1[t]).. sum(a$a18t100[a], nPop[a,t] * jqCR[a,t]) =E= 0;
    E_uFormue_forecast[t]$(tx1[t]).. uFormue[t] =E= uFormue[t1];

    E_uBoligR_a_forecast[a,t]$(a18t100[a] and tx1[t]).. uBoligR_a[a,t] =E= uBoligR_a[a,t1];

    E_uLand_forecast[t]$(tx1[t]).. uLand[t] =E= uLand[t1];

    E_uIBolig_forecast[t]$(tx1[t]).. uIBolig[t] =E= uIBolig[t1];

    E_fIBoligInstOmk_forecast[t]$(tx1[t]).. fIBoligInstOmk[t] =E= fq;
  $ENDBLOCK
  MODEL M_consumers_deep /
    M_consumers - M_consumers_post
    B_consumers_deep
  /;
$ENDIF

# ======================================================================================================================
# Simple dynamic calibration
# ======================================================================================================================
$IF %stage% == "simple_dynamic_calibration":
  $GROUP G_consumers_dynamic_calibration    
    G_consumers_endo
    -qC$(cIkkeBol[c_] and t1[t]), jqC$(t1[t])
    jqC$(tx1[t]) # E_jqC

    -qBolig$(aTot[a_] and t1[t]), jqBolig$(t1[t])
    jqBolig$(tx1[t]) # E_jqBolig
    -pBolig$(t1[t]), uLand$(t1[t])
    -qKBolig$(t1[t]), uIBolig$(t1[t])
  ;
  $BLOCK B_consumers_dynamic_calibration
    # Fejlled i samlet forbrug og boligforbrug gives persistens for at undgå store hop
    E_jqC[t]$(tx1[t]).. jqC[t] =E= aftrapprofil[t] * jqC[t1];
    E_jqBolig[t]$(tx1[t]).. jqBolig[t] =E= aftrapprofil[t] * jqBolig[t1];
  $ENDBLOCK
  MODEL M_consumers_dynamic_calibration / 
    M_consumers - M_consumers_post
    B_consumers_dynamic_calibration
  /;
$ENDIF