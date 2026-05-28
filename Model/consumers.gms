# ======================================================================================================================
# Consumers
# - Consumption decisions and budget constraint
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_consumers_variables
    # _a 
    # PRICES
    EpC[t] "Forventet prisindeks for næste periodes forbrug ekskl. bolig."

    # QUANTITIES
    qCx[a_,t] "Individuelt forbrug ekskl. bolig og finansielle omkostninger." 
    qCxRef[a_,t] "Forbrug ekskl. bolig, finansielle omkostninger og referenceforbrug."
    qBoligxRef[a_,t] "Ejerboliger ejet af husholdningerne ekskl. referenceforbrug." 
    qNytte[a,t] "CES nest af bolig og andet privat forbrug." 
    qArvBase[a,t] "Hjælpevariabel til førsteordensbetingelse for arve-nytte." 
    qFormueBase[a,t] "Hjælpevariabel til førsteordensbetingelse for nytte af formue." 
    qC_NR[a_,t] "Gns. husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
    # Vigtige størrelser, hvor aggregatet er sum af aldersfordelte
    # qC[c_,t]$(Cx[c_]) "Husholdningernes samlede forbrug fordelt på forbrugsgrupper og aggregater inkl. lejebolig og imputeret ejerbolig."
    qBolig[a_,t] "Ejerboliger ejet af husholdningerne (aggregat af kapital og land)" 
    qKLejeBolig[a_,t] "Kapitalapparat i lejeboliger fordelt på alder."

    # VALUES
    vCx[a_,t]$(a18t100[a_] and t.val > %AgeData_t1%) "Individuelt forbrug ekskl. bolig og finansielle omkostninger."
    vHhx[a_,t]$(a0t100[a_] and t.val > %AgeData_t1%) "Husholdningernes formue ekskl. pension, bolig og realkreditgæld"
    vHhxAfk[a_,t]$(aVal[a_] > 0 and t.val > %AgeData_t1%) "Imputeret afkast på husholdningernes formue ekskl. bolig og pension." 
    vCLejeBolig[a_,t]$(a18t100[a_] and t.val > %AgeData_t1%) "Forbrug af lejeboliger."
    vArvGivet[a,t]$(t.val > %AgeData_t1%) "Arv givet af hele kohorten med alder a."
    vArv[a_,t]$(a[a_] and t.val > %AgeData_t1%) "Arv modtaget af en person med alderen a."
    vBoligUdgift[a_,t]$(t.val > %AgeData_t1% and a[a_]) "Cash-flow-udgift til ejerbolig - dvs. inkl. afbetaling på gæld og inkl. øvrige omkostninger fx renter og bidragssats på realkreditlån."
    vArvBolig[a_,t]$(t.val > %AgeData_t1% and a[a_]) "Værdi af ejerbolig til arv efter udgifter - dvs. inkl. afbetaling på gæld og inkl. øvrige omkostninger fx renter og bidragssats på realkreditlån."
    vBoernFraHh[a,t]$(a0t17[a] and t.val > %AgeData_t1%) "Finansielle nettooverførsler fra forældre modtaget af børn i alder a."
    vHhTilBoern[a_,t]$((a18t100[a_]) and t.val > %AgeData_t1%) "Finansielle nettooverførsler til børn givet af forældre i alder a."
    vBolig[a_,t]$(a18t100[a_] and t.val > %AgeData_t1%) "Husholdningernes boligformue."
    vArvKorrektion[a_,t]$((tx0[t] and t.val > %AgeData_t1%) and a18t100[a_]) "Arv som tildeles afdødes kohorte for at korregerer for selektionseffekt (formue og døds-sandsynlighed er mod-korreleret)."
    vC_NR[a_,t]$(a0t100[a_] and t.val > %AgeData_t1%) "Gns. husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
    vSplurgeInd[a_,t]$(a18t100[a_] and t.val > %AgeData_t1%) "Splurge indkomstbegreb."
    vSplurge[a_,t]$(a18t100[a_] and t.val > %AgeData_t1%) "Splurge forbrug."   
    vSplurgeBolig[a_,t]$(a18t100[a_] and t.val > %AgeData_t1%) "Splurge bolig-forbrug."   

    # MISC.
    uBolig[a,t]$(a18t100[a] and t.val > %AgeData_t1%) "Nytteparameter som styrer forbrugernes bolig-efterspørgsel."   
    uCx[a,t]$(a18t100[a] and t.val > %AgeData_t1%) "Nytteparameter som styrer forbrugernes efterspørgsel efter ikke-bolig og ikke-finansielle omkostninger (ydelser)."   
    muBolig[a,t]$(a18t100[a] and t.val > %AgeData_t1%) "Marginalnytte af bolig."   
    dULead2dBolig[a,t]$(t.val > %AgeData_t1%) "Nytte næste periode differentieret ift. erjerbolig mængde denne periode."   
    mUC[a,t] "Marginalnytte af forbrug udover end bolig."  
    EmUC[a,t] "Forventet marginalnytte af forbrug udover end bolig."  
    fMigration[a_,t]$(a[a_] and t.val > %AgeData_t1%) "Korrektion for migrationer (= 1/(1+migrationsrate) eftersom formue deles med ind- og udvandrere)."
    uBoernFraHh[a,t]$(a0t17[a] and t.val > %AgeData_t1%) "Parameter for børns formue relativ til en gennemsnitsperson. Bestemmer vBoernFraHh." 
    dArv[a_,t]$(t.val > %AgeData_t1% and d1Arv[a_,t]) "Arvefunktion differentieret med hensyn til bolig."   
    dFormue[a_,t]$(t.val > %AgeData_t1% and a[a_]) "Formue-nytte differentieret med hensyn til bolig."   
    fDisk[a,t] "Husholdningens diskonteringsfaktor"

    # _a_tot
    qCx[aTot,t]$(t.val > %AgeData_t1%) 
    qCxRef[aTot,t]$(t.val > %AgeData_t1%)  
    qBoligxRef[aTot,t]$(t.val > %AgeData_t1%)  
    qBolig[aTot,t]$(t.val > %AgeData_t1%) 

    vArv[aTot,t]$(t.val > %AgeData_t1%)
    vArvBolig[aTot,t]
    vHhTilBoern[aTot,t]
    vArvKorrektion[aTot,t]$(t.val > %AgeData_t1%)
    vSplurgeInd[aTot,t]
    vSplurge[aTot,t]  
    vSplurgeBolig[aTot,t]  

    rSplurge[a_,t] "splurge factor"   
    rSplurgeBolig[a_,t] "splurge factor"   

    # _endo
    pBolig[t] "Kontantprisen på enfamiliehuse, Kilde: ADAM[phk]"
    mpLand[t] "Imputeret marginal pris på grundværdien af land til boligbenyttelse."
    pLand[t] "Imputeret gennemsnitlig pris på grundværdien af land til boligbenyttelse."
    pIBoligUC[t] "Usercost for kapitalinvesteringer i nybyggeri af ejerboliger (investeringspris plus installationsomkostninger)."
    pBoligUC[t]$(t.val > %AgeData_t1%) "User cost for ejerbolig."
    pC[c_,t]$(cNest[c_]) "Imputeret prisindeks for forbrugskomponenter for husholdninger - dvs. ekskl. turisters forbrug."
    pCPI[c_,t]$(t.val >= 2000 and not cTur[c_]) "Forbrugerprisindeks (CPI), Kilde: FMBANK[pfp] og FMBANK[pfp<i>]."
    pHICP[t] "Harmoniseret forbrugerprisindeks (HICP), Kilde: FMBANK[pfphicp]."
    pnCPI[c_,t]$(t.val >= 1996 and not cTur[c_]) "Nettoforbrugerprisindeks (nCPI), Kilde: FMBANK[pnp] og FMBANK[pnp<i>]."
    qC[c_,t] "Husholdningernes samlede forbrug fordelt på forbrugsgrupper og aggregater inkl. lejebolig og imputeret ejerbolig."
    qBiler[t] "Kapitalmængde for køretøjer i husholdningerne, Kilde: ADAM[fKncb]"
    qYBolig[t] "Bruttoproduktion af ejerboliger inkl. installationsomkostninger (aggregat af kapital og land)"
    qIBoligInstOmk[t] "Installationsomkostninger for boliginvesteringer i nybyggeri."
    qLandSalg[t] "Land solgt fra husholdningerne til at bygge grunde til ejerboliger på."
    qKBolig[t] "Kapitalmængde af ejerboliger, Kilde: ADAM[fKnbhe]"
    qIBolig[t] "Investeringer i ejerboligkapital."
    qC_NR[a_,t]$(aTot[a_]) "Gns. husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"

    vCx[a_,t]$(aTot[a_]) "Forbrug ekskl. bolig og finansielle omkostninger."
    vHhx[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "Husholdningernes formue ekskl. pension, bolig og realkreditgæld"
    vHhxAfk[a_,t]$(aTot[a_] and t.val > %NettoFin_t1%) "Imputeret afkast på husholdningernes formue ekskl. bolig og pension."
    vCLejeBolig[a_,t]$(aTot[a_]) "Forbrug af lejeboliger."
    vBoligUdgift[a_,t]$(t.val > %NettoFin_t1% and aTot[a_]) "Cash-flow-udgift til ejerbolig - dvs. inkl. afbetaling på gæld og inkl. øvrige omkostninger fx renter og bidragssats på realkreditlån."
    vBolig[a_,t]$(atot[a_]) "Husholdningernes boligformue."
    vKBolig[t] "Værdi af kapitalmængde af ejerboliger."
    vLand[t] "Værdi af land til ejerboligbenyttelse"
    vIBolig[t] "Værdi af ejerbolig-investeringer."
    vHhInvestx[a_,t]$(atot[a_]) "Husholdningernes direkte investeringer ekskl. bolig - imputeret."
    vSelvstKapInd[a_,t]$(atot[a_]) "Selvstændiges kapitalindkomst - imputeret."
    vC_NR[a_,t]$(aTot[a_]) "Gns. husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"

    rKLeje2Bolig[a_,t] "Forholdet mellem qKbolig og qKlejebolig."
    rKLeje2Bolig_a[a,t] "Aldersfordelt led i rKLeje2Bolig"
    frKLeje2Bolig_t[t] "Korrektionsfaktor til aldersfordelt led i rKLeje2Bolig."
    fMigration[a_,t]$((atot[a_] and t.val > 1992)) "Korrektion for migrationer (= 1/(1+migrationsrate) eftersom formue deles med ind- og udvandrere)."
    dpBoligTraeghed[t]$(tx0[t] and t.val > %AgeData_t1%) "Disnytte-effekt fra omstillingsomkostninger på boligpriser."
    rBoligTraeghed[t] "Hjælpevariabel til omstillingsomkostninger på boligpriser."
    dIBoligInstOmk2dI[t] "Afledt af qIBoligInstOmk[t] ift. qIBolig[t]."
    dIBoligInstOmkLead2dI[t] "Afledt af qIBoligInstOmk[t+1] ift. qIBolig[t]." 
    qC[c_,t]$(Cx[c_])
 ;

    $GROUP G_consumers_exogenous_forecast
    nArvinger[a,t] "Sum af antal arvinger sammenvejet efter rArv."
    rBoern[a,t] "Andel af det samlede antal under 18-årige som en voksen med alderen a har ansvar for."
    rOverlev[a_,t] "Overlevelsesrate."
    ErOverlev[a,t] "Forventet overlevelsesrate - afviger fra den faktiske overlevelsesrate for 100 årige."
    rBoligPrem[t] "Risikopræmie for boliger."
    qLand[t] "Mål for land anvendt til ejerboliger."
    qILejeBolig[t] "Investeringer i lejeboligkapital."
    jvFormueBase[a,t] "J-led"
    uFormue[t] "Nytte af formue parameter 0."
    uArv[t] "Arve-nytteparameter 0."
    uBolig_a[a,t] "Alders-specifikt led i uBolig."
    fIBoligInstOmk[t] "Vækstfaktor i boliginvesteringer, som giver nul installationsomkostninger."
    rArv[a,t] "Andel af den samlede arv som tilfalder hver arving med alderen a."
  ;
  $GROUP+ G_exogenous_forecast G_consumers_exogenous_forecast$(tx1[t]);

  $GROUP G_consumers_forecast_as_zero
    jvHhxAfk[a_,t] "J-led."
    jfEpC[t] "J-led."
    jfuBolig[t] "J-led"
    jfDisk_t[t] "J-led"
    jpBoligUC[t] "J-led"
    jrBoligTraeghed[t] "J-led"
    jrRefBolig[t] "J-led"
  ;
  $GROUP+ G_forecast_as_zero G_consumers_forecast_as_zero$(tx1[t]);

  $GROUP G_consumers_ARIMA_forecast
    uC[c_,t] "Justeringsled til CES-skalaparameter i private forbrugs-nests."
    rKLeje2Bolig[aTot,t] # Endogen i stødforløb
    rBilAfskr[t] "Afskrivningsrate for køretøjer i husholdningerne."
    rHhInvestx[t] "Husholdningernes direkte investeringer ekskl. bolig ift. direkte og indirekte beholdning af indl. aktier - imputeret."
    rLand2YBolig[t] "Skalaparameter i CES efterspørgsel efter land."
    uYBolig[t] "Skalaparameter i CES efterspørgsel efter boligkapital."
  ;
  $GROUP+ G_ARIMA_forecast G_consumers_ARIMA_forecast;

  $GROUP G_consumers_constants
    # Non-durable consumption
    eHh       "Invers af intertemporal substitutionselasticitet."

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

    frSplurgeBolig[t] "Variabel til niveau-skifte, for at ramme gennemsnitlig splurge på bolig, som er givet af IRF-matching"
    rSplurge_a[a,t] "Alders-specifikt led i rSplurge"
    rSplurge_t[t] "Tids-specifikt led i rSplurge"
  ;

  $GROUP+ G_constants G_consumers_constants;

  $GROUP G_consumers_fixed_forecast
    uBoernFraHh_t[t] "Tids-afhængigt led i uBoernFraHh."
    uBoernFraHh_a[a,t] "Alders-specifikt led i uBoernFraHh."

    # Non-durable consumption
    rRef[a,t]      "Reference-andel for ikke-bolig forbrug."
    # Durable consumption
    rRefBolig[a,t] "Vane-andel for forbrug for boliger."

    # Housing
    mrRealKred2Bolig[t] "Marginal realkredit-belåningsgrad."

    # Bequests
    rSelvstKapInd[t] "Selvstændiges kapitalindkomst ift. direkte og indirekte beholdning af indl. aktier - imputeret."
    fpCPI[c_,t]$(not cTur[c_]) "Korrektionsfaktor mellem forbrugerpriser i NR og CPI"
    rCPI[c,t]$(not cTur[c]) "Vægte i forbrugerprisindeks (CPI), Kilde: FMBANK[pf<i>vgt]."
    rHICP[c,t]$(not cTur[c]) "Vægte i harmoniseret forbrugerprisindeks (HICP), Kilde: FMBANK[v<i>hicp]."
    fpHICP[t] "Korrektionsfaktor vedrørende HICP"
    rnCPI[c,t]$(not cTur[c]) "Vægte i nettoforbrugerprisindeks (nCPI), Kilde: FMBANK[pn<i>vgt]."
    fpnCPI[c_,t]$(not cTur[c_]) "Korrektionsfaktor for nettoforbrugerprisindeks (nCPI)."
  ;
  $GROUP+ G_fixed_forecast G_consumers_fixed_forecast;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_consumers_static G_consumers_static$(tx0[t])
    # ------------------------------------------------------------------------------------------------------------------
    # Aggregeret budgetrestriktion
    # ------------------------------------------------------------------------------------------------------------------
    # vHhx[aTot,t] kan opskrives på samme måde som E_vHhx[a,t] - to ting er værd at bemærke
    # 1) summen af overførsler til og fra børn er 0
    # 2) Arv og arvekorrektion er en del af husholdningernes indkomst og bortset fra arv- og dødsboskat kommer det fra husholdningerne
    $(tx0[t] and t.val > %AgeData_t1%)..
      vHhx[aTot,t] =E= vHhx[aTot,t-1]/fv + vHhxAfk[aTot,t] - vtHhxAfk[aTot,t]
                     + vHhInd[aTot,t]
                     - vCx[aTot,t]
                     - vCLejebolig[aTot,t] 
                     - vBoligUdgift[aTot,t] 
                     - (vArv[aTot,t] + vArvKorrektion[aTot,t] + vtDoedsbo[aTot,t] - vPensArv['pensTot',aTot,t] + vtPersRestPensArv[aTot,t]);

    # Net capital income
    $(tx0[t] and t.val > %AgeData_t1%)..
      vHhxAfk[aTot,t] =E= sum(portf$(not pensPortf[portf]), rHhAktAfk[portf,t] * vHhAkt[portf,aTot,t-1]/fv)
                        - rHhPasAfk['Bank',t] * vHhPas['Bank',aTot,t-1]/fv;

    $(tx0[t] and t.val > %AgeData_t1%)..
      vBoligUdgift[aTot,t] =E= vIBolig[t]
                             + rHhPasAfk['RealKred',t] * vHhPas['RealKred',aTot,t-1]/fv - vRealkreditFradrag[aTot,t] # Rentefradrag er ikke er lig mtHhPasAfk * rHhPasAfk * vHhPas pga. død
                             + vHhPas['RealKred',aTot,t-1]/fv - vHhPas['RealKred',aTot,t]
                             + vtEjd[aTot,t]
                             + rBoligOmkRest[t] * vBolig[aTot,t-1]/fv;

    .. vHhInvestx[aTot,t] =E= rHhInvestx[t] * vI_s[iTot,spTot,t];  

    .. vSelvstKapInd[aTot,t] =E= rSelvstKapInd[t] * vEBITDA[sTot,t];    

    .. vBolig[aTot,t] =E= pBolig[t] * qBolig[aTot,t];

    # Lejebolig ud fra eksogent kapitalapparat
    .. vCLejebolig[aTot,t] =E= pC['cBol',t] * qC['cBol',t] * qKLejeBolig[aTot,t-1] / (qKBolig[t-1] + qKLejeBolig[aTot,t-1]);

    # ------------------------------------------------------------------------------------------------------------------
    # CES-efterspørgsel efter (ikke-bolig) forbrug
    # ------------------------------------------------------------------------------------------------------------------
    # Budget constraint
    .. pC['cTurTjex',t] * qC['cTurTjex',t] =E= 
            pC['cTur',t] * qC['cTur',t] + pC['cTje',t] * qC['cTje',t] - vHhAktOmk['Tot',t] - vHhPasOmk['Tot',t];

    .. pC['cTurTjexVar',t] * qC['cTurTjexVar',t] =E= 
            pC['cTurTjex',t] * qC['cTurTjex',t] + pC['cVar',t] * qC['cVar',t];

    .. pC['cTurTjexVarEne',t] * qC['cTurTjexVarEne',t] =E= 
            pC['cTurTjexVar',t] * qC['cTurTjexVar',t] + pC['cEne',t] * qC['cEne',t];

    .. pC['Cx',t] * qC['Cx',t] =E= pC['cTurTjexVarEne',t] * qC['cTurTjexVarEne',t] + pC['cBil',t] * qC['cBil',t];

    .. vCx[aTot,t] =E= pC['Cx',t] * qC['Cx',t];

    # FOC
    .. qC['cTurTjexVarEne',t] =E= (1 - uC['cBil',t]) * qC['Cx',t] * (pC['Cx',t] / pC['cTurTjexVarEne',t])**eC('Cx');

    .. qC['cTurTjexVar',t] =E= (1 - uC['cEne',t]) * 
            qC['cTurTjexVarEne',t] * (pC['cTurTjexVarEne',t] / pC['cTurTjexVar',t])**eC('cTurTjexVarEne');

    .. qC['cTurTjex',t] =E= (1 - uC['cVar',t]) * 
            qC['cTurTjexVar',t] * (pC['cTurTjexVar',t] / pC['cTurTjex',t])**eC('cTurTjexVar');

    .. qC['cBil',t] =E= uC['cBil',t] * qC['Cx',t] * (pC['Cx',t] / pC['cBil',t])**eC('Cx');

    .. qC['cEne',t] =E= uC['cEne',t] * qC['cTurTjexVarEne',t] * 
           (pC['cTurTjexVarEne',t] / pC['cEne',t])**eC('cTurTjexVarEne');

    .. qC['cVar',t] =E= uC['cVar',t] * qC['cTurTjexVar',t] * (pC['cTurTjexVar',t] / pC['cVar',t])**eC('cTurTjexVar');

    .. qC['cTje',t] =E= uC['cTje',t] * qC['cTurTjex',t] * (pC['cTurTjex',t] / pC['cTje',t])**eC('cTurTjex')
                       + (vHhAktOmk['Tot',t] + vHhPasOmk['Tot',t]) / pC['cTje',t]; # Finansieringsomkostninger er forbrug af tjenester, som kommer ud over de tjenester, der giver nytte

    .. qC['cTur',t] =E= (1 - uC['cTje',t]) * qC['cTurTjex',t] * (pC['cTurTjex',t] / pC['cTur',t])**eC('cTurTjex');

    # ------------------------------------------------------------------------------------------------------------------
    # Bolig-efterspørgsel for fremadskuende husholdninger
    # ------------------------------------------------------------------------------------------------------------------
    .. qLandSalg[t] =E= qLand[t] - (1 - rAfskr['iB','bol',t]) * qLand[t-1]/fq;

    # ------------------------------------------------------------------------------------------------------------------
    # CES-efterspørgsel efter bolig-kapital og land
    # ------------------------------------------------------------------------------------------------------------------
    # Produktion af ejerboliger er sammensætning af land og boligkapital-investeringer
    .. qYBolig[t] =E= qBolig[aTot,t] - (1 - rAfskr['iB','bol',t]) * qBolig[aTot,t-1]/fq + qIBoligInstOmk[t];

    .. qIBoligInstOmk[t] =E= uIBoligInstOmk/2 * sqr(qIBolig[t] / qIBolig[t-1]*fq - fIBoligInstOmk[t]) * qIBolig[t];

    .. dIBoligInstOmk2dI[t] =E= uIBoligInstOmk * (qIBolig[t] / qIBolig[t-1]*fq - fIBoligInstOmk[t]) * 
            qIBolig[t] / qIBolig[t-1]*fq + uIBoligInstOmk/2 * sqr(qIBolig[t] / qIBolig[t-1]*fq - fIBoligInstOmk[t]);

    mpLand[t].. qLandSalg[t] =E= uYBolig[t] * rLand2YBolig[t] * qYBolig[t] * (pBolig[t] / mpLand[t])**eBolig;

    .. vIBolig[t] =E= pI_s['iB','bol',t] * qIBolig[t];

    .. qKBolig[t] =E= (1-rAfskr['iB','bol',t]) * qKBolig[t-1]/fq + qIBolig[t];

    .. vKBolig[t] =E= pI_s['iB','bol',t] * qKBolig[t];

    .. rKLeje2Bolig[aTot,t] =E= qKLejeBolig[aTot,t] / qKBolig[t];

    qILejeBolig[t].. qKLejeBolig[aTot,t] =E= (1-rAfskr['iB','bol',t]) * qKLejeBolig[aTot,t-1]/fq + qILejeBolig[t];

    # En gennemsnitlig landpris bestemmes under antagelse af nul profit ved boligbyggeri
    pLand[t].. pBolig[t] * (qYBolig[t] - qIBoligInstOmk[t]) =E= 
            pLand[t] * qLandSalg[t] + pI_s['iB','bol',t] * qIBolig[t];

    .. vLand[t] =E= pLand[t] * qLand[t];

    # ------------------------------------------------------------------------------------------------------------------
    # Biler - kapitalapparat til beregning vægtafgift 
    # ------------------------------------------------------------------------------------------------------------------
    .. qBiler[t] =E= (1-rBilAfskr[t]) * qBiler[t-1]/fq + qC['cBil',t];

    # ------------------------------------------------------------------------------------------------------------------
    # Term to adjust for migration
    # ------------------------------------------------------------------------------------------------------------------
    $(tx0[t] and t.val > 1992).. fMigration[aTot,t] =E= rOverlev[aTot,t-1] * nPop[aTot,t-1] / nPop[aTot,t];

    .. vC_NR[aTot,t] =E= vC[cTot,t];
    .. qC_NR[aTot,t] =E= vC_NR[aTot,t] / pC['cTot',t];

    # ------------------------------------------------------------------------------------------------------------------
    # Forbrugerprisindex
    # ------------------------------------------------------------------------------------------------------------------
    $(tx0[t] and t.val >= 2000 and not cTur[c]).. pCPI[c,t] =E= fpCPI[c,t] * pCDK[c,t];

    $(tx0[t] and t.val >= 2000).. pCPI[cTot,t] =E= fpCPI[cTot,t] * sum(c$(not cTur[c]), rCPI[c,t] * pCPI[c,t]);

    $(tx0[t] and t.val >= 2000).. pHICP[t] =E= fpHICP[t] * sum(c$(not cTur[c]), rHICP[c,t] * pCPI[c,t]);

    $(t.val >= 1996 and not cTur[c]).. pnCPI[c,t] =E= fpnCPI[c,t] * (vCDK[c,t] - vtTold[c,sTot,t] 
            - vtNetAfg[c,sTot,t] - vtMoms[c,sTot,t] - vtReg[c,sTot,t]) / qCDK[c,t];

    $(t.val >= 1996).. pnCPI[cTot,t] =E= fpnCPI[cTot,t] * sum(c$(not cTur[c]), rnCPI[c,t] * pnCPI[c,t]);
  $ENDBLOCK


  $BLOCK B_consumers_forwardlooking G_consumers_forwardlooking$(tx0[t])
    $(tx0E[t]).. dIBoligInstOmkLead2dI[t] =E= - uIBoligInstOmk * 
            (qIBolig[t+1]*fq / qIBolig[t] - fIBoligInstOmk[t+1]) * sqr(qIBolig[t+1]*fq / qIBolig[t]);

    $(tx0E[t]).. pIBoligUC[t] =E= pI_s['iB','bol',t] + pBolig[t] * 
            dIBoligInstOmk2dI[t] + fVirkDisk['bol',t+1] * pBolig[t+1]*fp * dIBoligInstOmkLead2dI[t];

    pIBoligUC&_tEnd[t]$(tEnd[t]).. pIBoligUC[t] =E= pI_s['iB','bol',t] + pBolig[t] * dIBoligInstOmk2dI[t];

    .. qIBolig[t] =E= uYBolig[t] * (1-rLand2YBolig[t]) * qYBolig[t] * (pBolig[t] / pIBoligUC[t])**eBolig;

    # Bolig-produktionspris er CES pris af usercost på land og investeringer
    .. pBolig[t] * qYBolig[t] =E= mpLand[t] * qLandSalg[t] + pIBoligUC[t] * qIBolig[t]; # Mangler qYBolig

    # Usercost
    pBoligUC[t]$(tx0E[t] and t.val > %AgeData_t1%)..
      pBoligUC[t] =E= (1-mrRealKred2Bolig[t]) * pBolig[t] # Contemporaneous down-payment cost
                    + ( mrRealKred2Bolig[t] * (1 + mrHhPasAfk['RealKred',t+1]) # Realkredit: tilbagebetaling af hovedstol og renter
                        + tEjd[t+1] # Ejendomsværdiskat
                        + rBoligOmkRest[t+1] # Resterende udgifter
                       - dvHhxAfk2dvBolig[t+1]
                    ) * pBolig[t] / (1+mrHhxAfk[t+1])
                    - (1-rAfskr['iB','bol',t+1]) * pBolig[t+1]*fp / (1+mrHhxAfk[t+1]+rBoligPrem[t+1]) # Værdi næste periode
                    - pLand[t+1]*fp * qLandSalg[t+1]*fq / qBolig[atot,t] / (1+mrHhxAfk[t+1]+rBoligPrem[t+1]) # Forventet udbytte af landsalg i næste periode
                    + jpBoligUC[t];

    pBoligUC&_tEnd[t]$(tEnd[t])..
      pBoligUC[t] =E= (1-mrRealKred2Bolig[t]) * pBolig[t] # Contemporaneous down-payment cost
                    + ( mrRealKred2Bolig[t] * (1 + mrHhPasAfk['RealKred',t]) # Realkredit: tilbagebetaling af hovedstol og renter
                        + tEjd[t] # Ejendomsværdiskat
                        + rBoligOmkRest[t] # Resterende udgifter
                       - dvHhxAfk2dvBolig[t]
                    ) * pBolig[t] / (1+mrHhxAfk[t])
                    - (1-rAfskr['iB','bol',t]) * pBolig[t]*fp * (pBolig[t-1] / pBolig[t-2]) / (1+mrHhxAfk[t]+rBoligPrem[t]) # Værdi næste periode - vi antager terminalt en forventet prisstigning lig stigningen året før
                    - (pLand[t]*fp * qLandSalg[t]*fq) * ((pLand[t-1] * qLandSalg[t-1]) / (pLand[t-2] * qLandSalg[t-2])) / qBolig[atot,t] / (1+mrHhxAfk[t]+rBoligPrem[t]) # Forventet udbytte af landsalg i næste periode
                    + jpBoligUC[t];

    # Boligpris-træghed fra disnytte ved boligprisændringer 
    $(tx0E[t] and t.val > %AgeData_t1%)..
      dpBoligTraeghed[t] =E= upBoligTraeghed * (rBoligTraeghed[t] - 1) *  rBoligTraeghed[t]
           - 2 / (1+rDisk) * upBoligTraeghed * (rBoligTraeghed[t+1] - 1) *  rBoligTraeghed[t+1];
   
    dpBoligTraeghed&_tEnd[t]$(tEnd[t] and t.val > %AgeData_t1%).. dpBoligTraeghed[t] =E= 0;

    .. rBoligTraeghed[t] =E= pBolig[t]/pBolig[t-1] / (pBolig[t-1]/pBolig[t-2]) + jrBoligTraeghed[t];

  $ENDBLOCK


  $BLOCK B_consumers_a_tot G_consumers_a_tot$(tx0[t])
    # ------------------------------------------------------------------------------------------------------------------
    # Individual non-housing consumption decision by age
    # ------------------------------------------------------------------------------------------------------------------  
    # Budgetbegrænsning
    # # Ikke-bolig forbrug
    $(tx0[t] and t.val > %AgeData_t1%).. qCx[aTot,t] =E= sum(a, qCx[a,t] * nPop[a,t]);     
    $(tx0[t] and t.val > %AgeData_t1%).. qCxRef[aTot,t] =E= sum(a, qCxRef[a,t] * nPop[a,t]);   

    # ------------------------------------------------------------------------------------------------------------------
    # Bolig-efterspørgsel
    # ------------------------------------------------------------------------------------------------------------------
    $(tx0[t] and t.val > %AgeData_t1%).. qBoligxRef[aTot,t] =E= sum(a, qBoligxRef[a,t] * nPop[a,t]);   

    $(tx0[t] and t.val > %AgeData_t1%).. qKLejeBolig[aTot,t] =E= sum(a, qKLejeBolig[a,t] * nPop[a,t]);   

    # ------------------------------------------------------------------------------------------------------------------
    # Nytte af arv
    # ------------------------------------------------------------------------------------------------------------------
    # Arv videregivet pr kohorte
    $(tx0[t] and t.val > %AgeData_t1%).. vArvKorrektion[aTot,t] =E= 
           sum(a$(a18t100[a]), vArvKorrektion[a,t] * nPop[a,t]);

    $(tx0[t] and t.val > %AgeData_t1%).. vArv[aTot,t] =E= sum(a$(a.val > 0), vArvGivet[a,t] * (1-rOverlev[a-1,t-1]) * nPop[a-1,t-1]);

    $(tx0[t] and t.val > %AgeData_t1%).. vArvBolig[aTot,t] =E= sum(a, (1-rOverlev[a-1,t-1]) * nPop[a-1,t-1] * vArvBolig[a,t]);

    # -------------------------------------------------------------------
    # Coupling of consumption by household type and CES tree
    # ------------------------------------------------------------------------------------------------------------------
    # Aggregater
    $(tx0[t] and t.val > %AgeData_t1%).. qC['Cx',t] =E= qCx[aTot,t]; 
    $(tx0[t] and t.val > %AgeData_t1%).. qBolig[aTot,t] =E= sum(a, qBolig[a,t] * nPop[a,t]);

    $(tx0[t] and t.val > %AgeData_t1%).. vSplurgeInd[aTot,t] =E= sum(a$(a18t100[a]), vSplurgeInd[a,t] * nPop[a,t]);
    $(tx0[t] and t.val > %AgeData_t1%).. vSplurge[aTot,t] =E= sum(a$(a18t100[a]), vSplurge[a,t] * nPop[a,t]);   
    $(tx0[t] and t.val > %AgeData_t1%).. vSplurgeBolig[aTot,t] =E= sum(a$(a18t100[a]), vSplurgeBolig[a,t] * nPop[a,t]);   

    $(tx0[t] and t.val > %AgeData_t1%).. rSplurge[aTot,t] * vSplurgeInd[aTot,t] =E= vSplurge[aTot,t];  
    $(tx0[t] and t.val > %AgeData_t1%).. rSplurgeBolig[aTot,t] * vSplurgeInd[aTot,t] =E= vSplurgeBolig[aTot,t];  

    # ------------------------------------------------------------------------------------------------------------------
    # Overførsler mellem børn og forældre som redegør for ændringer i børns opsparing. 
    # ------------------------------------------------------------------------------------------------------------------
    $(tx0[t] and t.val > %AgeData_t1%).. vHhTilBoern[aTot,t] =E= sum(aa$(a0t17[aa]), vBoernFraHh[aa,t] * nPop[aa,t]);

  $ENDBLOCK


  $BLOCK B_consumers_a G_consumers_a$(tx0[t])
    # -------------------------------------------------------------------
    # Not age dependent but only used with age-dependent variables
    # -------------------------------------------------------------------
    $(tx0E[t]).. EpC[t] =E= pC['Cx',t+1]*fp * (1 + jfEpC[t]);
    EpC&_tEnd[t]$(tEnd[t]).. EpC[t] =E= pC['Cx',t] * pC['Cx',t]/(pC['Cx',t-1]/fp) * (1 + jfEpC[t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Budgetrestriktion
    # ------------------------------------------------------------------------------------------------------------------
    $(tx0[t] and a0t100[a] and t.val > %AgeData_t1%)..
      vHhx[a,t] =E= (vHhx[a-1,t-1]/fv * fMigration[a,t] + vHhxAfk[a,t] - vtHhxAfk[a,t])$(a1t100[a])
                  + vHhInd[a,t]
                  - vCx[a,t]            # Ikke-bolig-forbrugsudgift 
                  - vCLejeBolig[a,t]     # Lejebolig-forbrugsudgift
                  - vBoligUdgift[a,t]    # Cashflow til ejerbolig inkl. realkreditafbetaling
                  + vBoernFraHh[a,t]$(a0t17(a)) - vHhTilBoern[a,t]$(a18t100(a));  # Overførsler mellem voksne og børn

    # Net capital income
    $(tx0[t] and aVal[a] > 0 and t.val > %AgeData_t1%)..
      vHhxAfk[a,t] =E= sum(portf$(not pensPortf[portf]), rHhAktAfk[portf,t] * vHhAkt[portf,a-1,t-1]/fv) * fMigration[a,t]
          - rHhPasAfk['Bank',t] * vHhPas['Bank',a-1,t-1]/fv * fMigration[a,t] + jvHhxAfk[a,t];

    # Samlet post for ejerbolig som fratrækkes i budgetrestriktion.
    $(tx0[t] and t.val > %AgeData_t1%)..
      vBoligUdgift[a,t] =E= pBolig[t] * qBolig[a,t] - pBolig[t] * qBolig[a-1,t-1]/fq * fMigration[a,t] # Netto-køb
                          - vHhPas['RealKred',a,t] + vHhPas['RealKred',a-1,t-1]/fv * fMigration[a,t] # Netto optagelse (indfrielse) af realkredit
                          + mrHhPasAfk['RealKred',t] * vHhPas['RealKred',a-1,t-1]/fv * fMigration[a,t] # Renter
                          + (rBoligOmkRest[t] + tEjd[t]) * vBolig[a-1,t-1]/fv * fMigration[a,t] # Øvrige udgifter og ejendomsværdiskat
                          + (vIBolig[t] + pBolig[t] * qBolig[aTot,t-1]/fq - vBolig[aTot,t]) # Netto investeringer (fratrukket afskrivninger og evt. profit pga. installationsomkostninger i sammensætning af land og bygningskapital)
                          * vBolig[a-1,t-1]/vBolig[aTot,t-1] * fMigration[a,t];             # Fordeles proportionalt til alle boliger
                          
    $(tx0[t] and t.val > %AgeData_t1%)..
      vArvBolig[a,t] =E= pBolig[t] * qBolig[a-1,t-1]/fq # Værdi af bolig ved død
                       - (1+rHhPasAfk['RealKred',t]) * vHhPas['RealKred',a-1,t-1]/fv # Indfrielse af realkredit + renter. rHhPasAfk bruges istedet for mrHhPasAfk, da vi ikke antager rentefradrag i dødsbo
                       - (rBoligOmkRest[t] + tEjd[t]) * vBolig[a-1,t-1]/fv # Øvrige udgifter og ejendomsværdiskat
                       - (vIBolig[t] + pBolig[t] * qBolig[aTot,t-1]/fq - vBolig[aTot,t]) # Netto investeringer (fratrukket afskrivninger og evt. profit pga. installationsomkostninger i sammensætning af land og bygningskapital)
                       * vBolig[a-1,t-1]/vBolig[aTot,t-1];                               # Fordeles proportionalt til alle boliger

    $(a18t100[a] and tx0[t] and t.val > %AgeData_t1%)..
      vCLejebolig[a,t] / vCLejebolig[aTot,t] =E= qKLejeBolig[a,t] / qKLejeBolig[aTot,t];

    $(a18t100[a] and tx0[t] and t.val > %AgeData_t1%)..
      rKLeje2Bolig[a,t] =E= qKLejeBolig[a,t] / qBolig[a,t];

    rKLeje2Bolig_a&_a[a,t]$(a18t100[a] and tx0[t] and t.val > %AgeData_t1%)..
      rKLeje2Bolig[a,t] =E= rKLeje2Bolig_a[a,t] * frKLeje2Bolig_t[t];   

    # ------------------------------------------------------------------------------------------------------------------
    # Individual non-housing consumption decision by age
    # ------------------------------------------------------------------------------------------------------------------  
    # Diskontering
    $(tx0E[t] and t.val > %AgeData_t1% and a.val < 100).. fDisk[a,t] =E= (1+jfDisk_t[t]) / (1+rDisk);
    fDisk&_End[a,t]$(tEnd[t] or (tx0[t] and t.val > %AgeData_t1% and a.val = 100))..
      fDisk[a,t] =E= (1+jfDisk_t[t]) / (1+rDisk);

    # Ikke-bolig forbrug
    qCx[a,t]$(a18t100[a] and tx0E[t] and t.val > %AgeData_t1%)..
      mUC[a,t] =E= (ErOverlev[a,t] * (1 + mrHhxAfk[t+1]) / EpC[t] * EmUC[a,t]
                   + ErOverlev[a,t] * dFormue[a,t]  
                   + (1-ErOverlev[a,t]) * dArv[a,t]) * pC['Cx',t] * fDisk[a,t];
    
    qCx&_tEnd[a,t]$(a18t100[a] and tEnd[t])..
      mUC[a,t] =E= (ErOverlev[a,t] * (1 + mrHhxAfk[t]) / EpC[t] * EmUC[a,t]
                   + ErOverlev[a,t] * dFormue[a,t]  
                   + (1-ErOverlev[a,t]) * dArv[a,t]) * pC['Cx',t] * fDisk[a,t]; 

    $(tx0[t] and a18t100[a] and t.val > %AgeData_t1%)..
      vSplurgeInd[a,t] =E= vHhInd[a,t]
                         - (vHhPensUdb['Kap',a,t] - vHhPensIndb['Kap',a,t] - vtPersRestPens[a,t])
                         - (vHhPensUdb['Alder',a,t] - vHhPensIndb['Alder',a,t])
                         - vArvKorrektion[a,t] - vHhFraMigration[a,t]
                         - vCLejeBolig[a,t] - vHhTilBoern[a,t]
                         + (rRealKred2Bolig[a,t] * pBolig[t] - rRealKred2Bolig[a-1,t-1] * pBolig[t-1]/fp) * qBolig[a-1,t-1]/fq
                         - mrHhPasAfk['RealKred',t] * vHhPas['RealKred',a-1,t-1]/fv
                         - mrHhPasAfk['Bank',t] * vHhPas['Bank',a-1,t-1]/fv;

    $(tx0[t] and a18t100[a] and t.val > %AgeData_t1%)..  
      rSplurge[a,t] =E= rSplurge_t[t] + rSplurge_a[a,t];

    $(tx0[t] and a18t100[a] and t.val > %AgeData_t1%)..  
      vSplurge[a,t] =E= rSplurge[a,t] * vSplurgeInd[a,t];    

    $(tx0[t] and a18t100[a] and t.val > %AgeData_t1%)..  
      vSplurgeBolig[a,t] =E= rSplurgeBolig[a,t] * vSplurgeInd[a,t];   

    # Konstant har ingen betydning udover at gøre at problemet lettere at løse numerisk pga. bedre skalering
    $(tx0[t] and a18t100[a] and aVal[a] <> 18 and t.val > %AgeData_t1%)..
      qCxRef[a,t]/100 =E= qCx[a,t]
                          - rRef[a-1,t-1] * qCx[a-1,t-1]/fq
					                - vSplurge[a,t] / pC['Cx',t];   
   
    qCxRef&_a18[a,t]$(tx0[t] and aVal[a] = 18 and t.val > %AgeData_t1%)..   
      qCxRef[a,t]/100 =E= qCx[a,t]
                          - vSplurge[a,t] / pC['Cx',t];

    $(tx0[t] and a18t100[a])..   
      mUC[a,t] =E= qNytte[a,t]**(-eHh) * (qNytte[a,t] * uCx[a,t] / qCxRef[a,t])**(1/eNytte); 

    # Cobb-Douglas for eNytte = 1
    $(tx0[t] and a18t100[a] and t.val > %AgeData_t1%)..   
      qNytte[a,t] =E= qCxRef[a,t]**uCx[a,t] * qBoligxRef[a,t]**uBolig[a,t];  

    # Forventet marginal nytte af forbrug
    $(18 <= aVal[a] and aVal[a] < 100 and tx0E[t])..   
      EmUC[a,t] =E= mUC[a+1,t+1] * fq**(-eHh);
    # Terminal-betingelse - forventing om samme marginalnytte som i terminalåret, korrigeret for effekt af at være et år ældre (lig ændringen som den ét år ældre kohorte oplevede fra anden sidste år til terminalåret)
    EmUC&_tEnd[a,t]$(18 <= aVal[a] and aVal[a] < 100 and tEnd[t])..   
      EmUC[a,t] =E= mUC[a,t] * mUC[a+1,t]/mUC[a,t-1] * fq**(-eHh);
    # Terminal-betingelse for 100-årige - forventing om samme marginalnytte som i dag plus forventet trend (lead er bedre end lag, da den faktiske udvikling kan indeholde stød)
    EmUC&_aEnd[a,t]$(aVal[a] = 100 and tx0E[t])..   
      EmUC[a,t] =E= (mUC[a,t] * mUC[a,t+1] / mUC[a-1,t]) * fq**(-eHh);     
    EmUC&_aEnd_tEnd[a,t]$(aVal[a] = 100 and tEnd[t])..   
      EmUC[a,t] =E= (mUC[a,t] * mUC[a,t] / mUC[a-1,t-1]) * fq**(-eHh);

    # 15-17 er aktive på arbejdsmarkedet, men har ikke forbrug.
    # Marginalnytte af forbrug kan dog påvirke arbejdsmarkedsbeslutning og antages lig 18-åriges.
    mUC&_unge[a,t]$(tx0[t] and 15 <= aVal[a] and aVal[a] < 18).. mUC[a,t] =E= mUC['18',t];

    # ------------------------------------------------------------------------------------------------------------------
    # Bolig-efterspørgsel
    # ------------------------------------------------------------------------------------------------------------------
    # Konstant har ingen betydning udover at gøre at problemet lettere at løse numerisk pga. bedre skalering
    $(a18t100[a] and aVal[a] <> 18 and tx0[t] and t.val > %AgeData_t1%)..
      qBoligxRef[a,t]/100 =E= (qBolig[a,t] + qKLejeBolig[a,t])
                              - (rRefBolig[a-1,t-1] + jrRefBolig[t]) * (qBolig[a-1,t-1] + qKLejeBolig[a-1,t-1])/fq
                              - vSplurgeBolig[a,t] / (pBolig[t]*(1-mrRealKred2Bolig[t]));  

    qBoligxRef&_a18[a,t]$(aVal[a] = 18 and tx0[t] and t.val > %AgeData_t1%)..
      qBoligxRef[a,t]/100 =E= (qBolig[a,t] + qKLejeBolig[a,t])
                              - (rRefBolig[a-1,t-1] + jrRefBolig[t]) * (qBolig[a,t] + qKLejeBolig[a,t])/fq
                              - vSplurgeBolig[a,t] / (pBolig[t]*(1-mrRealKred2Bolig[t]));  

    # Merging of FOC for housing with FOC for net assets
    qBolig[a,t]$(a18t100[a] and tx0E[t] and t.val > %AgeData_t1%)..
      muBolig[a,t] + fDisk[a,t] * ErOverlev[a,t] * dULead2dBolig[a,t]
      =E= fDisk[a,t] * ErOverlev[a,t] * pBoligUC[t] * (1+mrHhxAfk[t+1]) / EpC[t] * EmUC[a,t];

    qBolig&_tEnd[a,t]$(a18t100[a] and tEnd[t])..
      muBolig[a,t] + fDisk[a,t] * ErOverlev[a,t] * dULead2dBolig[a,t]
      =E= fDisk[a,t] * ErOverlev[a,t] * pBoligUC[t] * (1+mrHhxAfk[t]) / EpC[t] * EmUC[a,t];

    # Nyttefunktion
    $(a18t100[a] and tx0[t] and t.val > %AgeData_t1%)..   
      muBolig[a,t] =E= (uBolig[a,t] / qBoligxRef[a,t])**(1/eNytte) * qNytte[a,t]**(1/eNytte - eHh);  

    $(18 <= aVal[a] and aVal[a] < 100 and tx0E[t] and t.val > %AgeData_t1%)..   
      dULead2dBolig[a,t] =E= - rRefBolig[a,t]
                             * (uBolig[a+1,t+1] / (qBoligxRef[a+1,t+1]*fq))**(1/eNytte) * (qNytte[a+1,t+1]*fq)**(1/eNytte - eHh);  
    dULead2dBolig&_tEnd[a,t]$(18 <= aVal[a] and aVal[a] < 100 and tEnd[t])..   
      dULead2dBolig[a,t] =E= - rRefBolig[a,t]
                             * (uBolig[a+1,t] / (qBoligxRef[a+1,t]*fq))**(1/eNytte) * (qNytte[a+1,t]*fq)**(1/eNytte - eHh);  
    dULead2dBolig&_aEnd[a,t]$(aVal[a] = 100 and tx0E[t] and t.val > %AgeData_t1%)..   
      dULead2dBolig[a,t] =E= - rRefBolig[a,t]
                             * (uBolig[a,t] / (qBoligxRef[a,t]*fq))**(1/eNytte) * (qNytte[a,t]*fq)**(1/eNytte - eHh);  
    dULead2dBolig&_aEnd_tEnd[a,t]$(aVal[a] = 100 and tEnd[t])..   
      dULead2dBolig[a,t] =E= - rRefBolig[a,t]
                             * (uBolig[a,t] / (qBoligxRef[a,t]*fq))**(1/eNytte) * (qNytte[a,t]*fq)**(1/eNytte - eHh);  

    # ------------------------------------------------------------------------------------------------------------------
    # Nytte af arv
    # ------------------------------------------------------------------------------------------------------------------
    # Arv videregivet pr kohorte
    $(tx0[t] and t.val > %AgeData_t1%)..
      vArvGivet[a,t] =E= (vHhx[a-1,t-1]/fv + vHhxAfk[a,t]/fMigration[a,t] + vArvBolig[a,t])$(a.val > 0) * rArvKorrektion[a]
                       - vtDoedsbo[a,t] + vPensArv['pensTot',a,t] - vtPersRestPensArv[a,t];

    $(tx0[t] and a18t100[a] and t.val > %AgeData_t1%)..
      vArvKorrektion[a,t] =E= (vHhx[a-1,t-1]/fv + vHhxAfk[a,t]/fMigration[a,t] + vArvBolig[a,t])
                            * (1-rArvKorrektion[a]) * (1-rOverlev[a-1,t-1]) * nPop[a-1,t-1] / nPop[a,t];

    # Arv modtaget
    $(tx0[t] and t.val > %AgeData_t1%).. vArv[a,t] =E= rArv[a,t] * vArv[aTot,t] / nPop[aTot,t];

    # Hjælpevariabel som skal være strengt positiv
    $(a18t100[a] and tx0E[t] and t.val > %AgeData_t1%).. 
      qArvBase[a,t] =E= (1-tArv[t+1]) * (vHhx[a,t]
                                            + pBolig[t] * qBolig[a,t] * (1 - rRealKred2Bolig[a,t])
                                            + vPensArv['pensTot',a,t]  # Samlet pension, som gives videre i tilfælde af død
                                            + jvFormueBase[a,t]
                                          ) / EpC[t];
    qArvBase&_tEnd[a,t]$(a18t100[a] and tEnd[t])..
      qArvBase[a,t] =E= (1-tArv[t]) * (vHhx[a,t]
                                          + pBolig[t] * qBolig[a,t] * (1 - rRealKred2Bolig[a,t])
                                          + vPensArv['pensTot',a,t]  # Samlet pension, som gives videre i tilfælde af død
                                          + jvFormueBase[a,t]
                                        ) / EpC[t];

    # Derivative of bequest utility with respect to net assets 
     
    $(a18t100[a] and d1Arv[a,t] and tx0E[t] and t.val > %AgeData_t1%)..   
      dArv[a,t] =E= uArv[t] * (1-tArv[t+1]) / EpC[t] * qArvBase[a,t]**(-eHh);
    dArv&_tEnd[a,t]$(a18t100[a] and d1Arv[a,t] and tEnd[t])..   
      dArv[a,t] =E= uArv[t] * (1-tArv[t]) / EpC[t] * qArvBase[a,t]**(-eHh);

    # ------------------------------------------------------------------------------------------------------------------
    # Nytte af formue
    # ------------------------------------------------------------------------------------------------------------------
    $(a18t100[a] and tx0[t] and t.val > %AgeData_t1%)..
      qFormueBase[a,t] =E= (vHhx[a,t]
                            + pBolig[t] * qBolig[a,t] * (1 - rRealKred2Bolig[a,t])
                            + (1-tKapPens[t]) * vHhPens['Kap',a,t] + vHhPens['Alder',a,t]
                            + jvFormueBase[a,t]
                           ) / EpC[t];

    # Derivative of wealth utility with respect to net assets
    $(a18t100[a] and tx0[t] and t.val > %AgeData_t1%)..   
      dFormue[a,t] =E= uFormue[t] / EpC[t] * qFormueBase[a,t]**(-eHh);

    # -------------------------------------------------------------------
    # Coupling of consumption by household type and CES tree
    # ------------------------------------------------------------------------------------------------------------------
    # Ikke-bolig-forbrug fordelt på alder som disaggregeres i CES-nest
    $(a18t100[a] and tx0[t] and t.val > %AgeData_t1%).. vCx[a,t] =E= pC['Cx',t] * qCx[a,t]; 

    # qBolig er et CES-aggregat af land og bygningskapital
    $(a18t100[a] and tx0[t] and t.val > %AgeData_t1%).. vBolig[a,t] =E= pBolig[t] * qBolig[a,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Overførsler mellem børn og forældre som redegør for ændringer i børns opsparing. 
    # ------------------------------------------------------------------------------------------------------------------
    vBoernFraHh[a,t]$(tx0[t] and a0t17[a] and t.val > %AgeData_t1%)..
      vHhx[a,t] =E= uBoernFraHh[a,t] * vHhx[aTot,t] / nPop[aTot,t];

    $(a18t100[a] and tx0[t] and t.val > %AgeData_t1%)..
      vHhTilBoern[a,t] =E= rBoern[a,t] * vHhTilBoern[aTot,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Opdeling af aldersfordelte parametre i tids- og aldersfordelte elementer
    # ------------------------------------------------------------------------------------------------------------------
    $(a18t100[a] and tx0[t] and t.val > %AgeData_t1%)..   
      uBolig[a,t] =E= uBolig_a[a,t] * (1 - dpBoligTraeghed[t]) * (1 + jfuBolig[t]);  

    $(a18t100[a] and tx0[t] and t.val > %AgeData_t1%)..   
      uCx[a,t] =E= (1 - uBolig_a[a,t]);  

    $(a0t17[a] and tx0[t] and t.val > %AgeData_t1%)..
      uBoernFraHh[a,t] =E= uBoernFraHh_t[t]$(a.val > 0) + uBoernFraHh_a[a,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Term to adjust for migration
    # ------------------------------------------------------------------------------------------------------------------
    # The key assumption is sharing within the cohort and that migrants arrive and leave with zero net assets
    $(tx0[t] and 0 < aVal[a] and aVal[a] <= 100 and t.val > %AgeData_t1%)..
      fMigration[a,t] =E= rOverlev[a-1,t-1] * nPop[a-1,t-1] / nPop[a,t];

    fMigration&_a0_aEnd[a,t]$(tx0[t] and (aVal[a] = 0 or aVal[a] > 100) and t.val > %AgeData_t1%)..
      fMigration[a,t] =E= 1;

    # ------------------------------------------------------------------------------------------------------------------
    # Post model equations
    # ------------------------------------------------------------------------------------------------------------------
 
    $(a0t100[a] and tx0[t] and t.val > %AgeData_t1%)..   
      vC_NR[a,t] =E= pC['Cx',t] * qCx[a,t]
                      + (vHhAktOmk['Tot',t] + vHhPasOmk['Tot',t]) * (vHhAkt['pensTot',a,t] / sum(aa$(a0t100[aa]), vHhAkt['pensTot',aa,t] * nPop[aa,t]))
                      + pC['cBol',t] * qC['cBol',t] 
                        * ( qKLejebolig[aTot,t-1]/qKBolig[t-1] * (vCLejebolig[a,t] / vCLejebolig[aTot,t])
                           + (qKBolig[t-1]-qKLejebolig[aTot,t-1])/qKBolig[t-1] * (qBolig[a,t] / qBolig[aTot,t]) );  

    $(a0t100[a] and tx0[t] and t.val > %AgeData_t1%).. qC_NR[a,t] =E= vC_NR[a,t] / pC['cTot',t];

  $ENDBLOCK

  $GROUP  G_consumers_endo 
    G_consumers_static
    G_consumers_a
    G_consumers_a_tot
    G_consumers_forwardlooking
  ;
  MODEL M_consumers / 
    B_consumers_static
    B_consumers_forwardlooking
    B_consumers_a
    B_consumers_a_tot
  /;
  model M_base / M_consumers /;
  $GROUP+ G_Endo G_consumers_endo;

  model M_static / B_consumers_static /;
  $GROUP+ G_static G_consumers_static;
$ENDIF


$IF %stage% == "exogenous_values":  
# ======================================================================================================================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_consumers_makrobk
    vHhx$(aTot[a_]), vHhxAfk$(aTot[a_]), vBolig$(aTot[a_]), qBolig$(aTot[a_]), vHhInvestx$(aTot[a_]), vSelvstKapInd$(aTot[a_])
    qKBolig, vKBolig, qBiler, qIBolig, pBolig, qLand, qKLejeBolig[aTot,t], qC$(c[c_]), rRente, pCPI[c_,t]$(c[c_] or cTot[c_]), rCPI[c,t]
    pnCPI[c_,t]$(c[c_] or cTot[c_]), rnCPI, rHICP, pHICP
  ;
  @load(G_consumers_makrobk, "../Data/Makrobk/makrobk.gdx" )

  # Aldersfordelt data fra aldersprofiler indlæses
  $GROUP G_consumers_aldersprofiler
    vHhx$(a[a_]), vCLejeBolig$(a[a_]), vCx$(a[a_])
  ;
  $GROUP G_consumers_aldersprofiler
    G_consumers_aldersprofiler$(t.val >= %AgeData_t1%)
    rArvKorrektion, rArv_a # Ikke-tidsfordelte variable lægges til
  ;
  @load(G_consumers_aldersprofiler, "../Data/Aldersprofiler/aldersprofiler.gdx" )

  # Aldersfordelt data fra BFR indlæses
  $GROUP G_consumers_BFR
    rBoern, rOverlev, ErOverlev, nPop
  ;
  @load(G_consumers_BFR, "../Data/Befolkningsregnskab/BFR.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_consumers_data  
    G_consumers_makrobk
    G_consumers_BFR
  ;
  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_consumers_data_imprecise
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  eHh.l = 1/0.8;
  eNytte.l = 1; # Estimering på vej
 
  rDisk.l = (1+terminal_rente) / fp - 1;
  d1Arv[a,t]$(a18t100[a]) = (ErOverlev.l[a,t] < 0.995); # Kun aldersgrupper med forventet dødssansynlighed over 0.5% har arvemotiv

  # Elasticities of substitution in the private consumption nests
  eC.l['cTurTjex'] = 1.25;
  eC.l['cTurTjexVar'] = 0.94;
  eC.l['cTurTjexVarEne'] = 0.26;
  eC.l['Cx'] = 1.04;

  # Andele for vanedannelse i forbrug er som udgangspunkt konstant,
  # men reduceres for de ældste kohorter (som har en væsentlig dødssandsynlighed) og dermed tyndere data og større variation
  rRef.l[a,t] = 0.368524; # Matching parameter
  rRefBolig.l[a,t] = 0.855057; # Matching parameter

  # Housing
  eBolig.l = 1.16; # Epple et al (2010)
  uIBoligInstOmk.l = 0.026018; # Matching parameter
  upBoligTraeghed.l = 0.18278; # Matching parameter
  
  rBoligPrem.l[t] = max(0.03, 0.07 - rRente.l["Obl",t]);

  mrRealKred2Bolig.l[t] = 0.8;

  frKLeje2Bolig_t.l[t] = 1;

  rSplurge_t.l[t] = 0.4; # matching parameter  
  rSplurgeBolig.l[a_,t] = 0.11; # matching parameter  

# ======================================================================================================================
# Data assignment
# ======================================================================================================================
  # Bequest distribution weighted by population size
  rArv_a.l[a,aa]$(mapVal(rArv_a.l[a,aa]) = 5) = eps;
  nArvinger.l[a,t] = sum(aa, rArv_a.l[a-1,aa] * nPop.l[aa,t]);
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_consumers_static_calibration_base
    G_consumers_endo
    fIBoligInstOmk[t] # E_fIBoligInstOmk
    jrBoligTraeghed[t] # E_jrBoligTraeghed

    -pBolig, rLand2YBolig
    -qBiler, rBilAfskr
    -vHhInvestx[aTot,t], rHhInvestx
    -vSelvstKapInd[aTot,t], rSelvstKapInd
    -qIBolig, uYBolig
    -qC[c,t]$(not (cBol[c] or cTur[c])), uC[c,t]$(not cBol[c]) # I endelige år bestemmes vCx konsistent med data for qC - og qC[cTur] bestemmes residualt (vCx bestemmer qCx og qCx som bestemmer qC[Cx] givet pC[Cx] som er en endogen CES-pris)
    -qC[c,t]$(cTur[c]), qC[c_,t]$(Cx[c_]) # Exogeniserer qC['cTur'] og bruger den til at bestemme qC[cX]. 
    -pCPI[c,t]$(not cTur[c]), fpCPI[c,t]$(not cTur[c]) 
    -pCPI[cTot,t], fpCPI[cTot,t] 
    -pnCPI[c,t]$(not cTur[c]), fpnCPI[c,t]$(t.val >= 1996 and not cTur[c]) 
    -pnCPI[cTot,t], fpnCPI[cTot,t]$(t.val >= 1996) 
    -pHICP[t], fpHICP[t]
    -qArvBase
    -dArv
    -qFormueBase, -dFormue
    -uBolig
    -uCx
  ;    
  $BLOCK B_consumers_static_calibration_base$(tx0[t])
    E_fIBoligInstOmk[t].. qIBolig[t] / qIBolig[t-1]*fq - fIBoligInstOmk[t] =E= 0;

    E_pIBoligUC_static[t]$(tx0E[t])..
      pIBoligUC[t] =E= pI_s['iB','bol',t] + pBolig[t] * dIBoligInstOmk2dI[t];

    E_jrBoligTraeghed[t].. rBoligTraeghed[t] =E= 1;
  $ENDBLOCK

  $GROUP G_consumers_static_calibration_newdata
    G_consumers_static_calibration_base
    -G_consumers_a_tot
    qC[Cx,t] # (qC['Cx',t] bestemmes residualt ud fra qC['cTur',t]) - Der ser ud til at være en fejl her, qC[cTur] er allerede eksogen
  ;    
  $GROUP G_consumers_static_calibration_newdata G_consumers_static_calibration_newdata$(tx0[t]);
  $GROUP+ G_static_calibration_newdata G_consumers_static_calibration_newdata;

  $GROUP G_consumers_static_calibration
    G_consumers_static_calibration_base
    qCx[a18t100,t]$(t.val = %AgeData_t1%) # E_qCx_AgeData_t1
    rArv[a,t]$(t.val > %AgeData_t1%) # E_rArv_static

    -vHhx[a0t17,t]$(t.val > %AgeData_t1%), uBoernFraHh_a[a0t17,t]$(t.val > %AgeData_t1%) 
    -vHhx[a18t100,t]$(t.val > %AgeData_t1%), jvHhxAfk[a18t100,t]$(t.val > %AgeData_t1%)
    -vCLejeBolig[a18t100,t]$(t.val > %AgeData_t1%), qKLejeBolig[a18t100,t]$(t.val > %AgeData_t1%)

    # Vi ønsker ikke at have fremadskuende hjælpeligninger med i statisk kalibrering
    # qBoligR bestemmes ud fra vBolig
    -qCxRef # - E_qCxRef - E_qCxRef_a18 - E_qCxRef_tot
    -qBoligxRef # - E_qBoligxRef - E_qBoligxRef_a18 - E_qBoligxRef_tot
    -EmUC # -E_EmUC, -E_EmUC_tEnd, -E_EmUC_aEnd, -E_EmUC_aEnd_tEnd
      -dULead2dBolig # -E_dULead2dBolig, -E_dULead2dBolig_tEnd, -E_dULead2dBolig_aEnd, -E_dULead2dBolig_aEnd_tEnd
      -muBolig # -E_qBolig, -E_qBolig_tEnd
    -qNytte # -E_qNytte
      -mUC # -E_mUC, -E_mUC_unge
    -vBolig[a18t100,t] # -E_muBolig 
    -dpBoligTraeghed # -E_dpBoligTraeghed -E_dpBoligTraeghed_tEnd
    -vCx[a18t100,t]$(aVal[a_] > 18) # -E_qCx_h, -E_qCx_h_tEnd  - Der ser ud til at være en fejl her, a.val > 18 ikke burde være nødvendigt
  ;    
  $GROUP G_consumers_static_calibration G_consumers_static_calibration$(tx0[t]);

  $BLOCK B_consumers_static_calibration
    E_qCx_AgeData_t1[a,t]$(t.val = %AgeData_t1% and a18t100[a])..
      (pC['Cx',t] * qCx[a,t]) * vCx[a,t+1]*fv =E= vCx[a,t] * (pC['Cx',t+1]*fp * qCx[a,t+1]*fq);

    E_rArv_static[a,t]$(tx0[t] and t.val > %AgeData_t1%)..
      rArv[a,t] * vArv[aTot,t] / nPop[aTot,t] =E= sum(aa$(aa.val > 0),
        vArvGivet[aa,t] * (1-rOverlev[aa-1,t-1]) * nPop[aa-1,t-1] / nArvinger[aa,t] * rArv_a[aa-1,a]);
  $ENDBLOCK

  MODEL M_consumers_static_calibration /
    M_consumers

    B_consumers_static_calibration_base
    - E_pIBoligUC # E_pIBoligUC_static

    B_consumers_static_calibration

    - E_qCxRef_a - E_qCxRef_a18 - E_qCxRef_atot
    - E_qBoligxRef_a - E_qBoligxRef_a18 - E_qBoligxRef_atot
    - E_EmUC_a - E_EmUC_tEnd - E_EmUC_aEnd - E_EmUC_aEnd_tEnd
    - E_dULead2dBolig_a - E_dULead2dBolig_tEnd - E_dULead2dBolig_aEnd - E_dULead2dBolig_aEnd_tEnd
    - E_qBolig_a - E_qBolig_tEnd
    - E_qNytte_a 
    - E_mUC_a - E_mUC_unge
    - E_muBolig_a
    - E_dpBoligTraeghed - E_dpBoligTraeghed_tEnd
    - E_qCx_a - E_qCx_tEnd
    - E_qArvBase_a -E_qArvBase_tEnd
    - E_dArv_a -E_dArv_tEnd
    - E_qFormueBase_a -E_dFormue_a
    - E_uBolig_a
    - E_uCx_a
  /;
  model M_static_calibration / M_consumers_static_calibration /;
  $GROUP+ G_static_calibration G_consumers_static_calibration;
$ENDIF


# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_consumers_deep    
    G_consumers_endo

    uFormue[t1], -vCx[aTot,t1]
    uFormue[tx1] # E_uFormue_forecast

    uArv[t] # E_uArv, E_uArv_forecast

    -rSplurgeBolig[aTot,t1], frSplurgeBolig[t1] "Kalibrerings-variabel."  
    rSplurgeBolig[a18t100,t] # E_rSplurgeBolig   

    rSplurge_a[a18t100,t] # E_rSplurge_a   

    jvFormueBase[a18t100,tx1] # E_jvFormueBase_forecast

    -qBolig[a18t100,t1], uBolig_a[a18t100,t1]
    uBolig_a[a18t100,tx1] # E_uBolig_a_forecast

    -pBolig[t1], rLand2YBolig[t1]
    rLand2YBolig[tx1]# E_rLand2YBolig_forecast
    -qKBolig[t1], uYBolig[t1]
    uYBolig[tx1] # E_uYBolig_forecast

    vArvPrArving[a,t] "Hjælpevariabel til beregning af arvens fordelingsnøgle, rArv." # E_vArvPrArving
    rArv # E_rArv
    -rKLeje2Bolig[aTot,t], frKLeje2Bolig_t[t]
    -rKLeje2Bolig_a[a18t100,t], qKLejeBolig[a18t100,t]

    fIBoligInstOmk[tx1] # E_fIBoligInstOmk_forecast
  ;

  $GROUP G_consumers_deep
    G_consumers_deep$(tx0[t])
  ;

  $BLOCK B_consumers_deep$(tx0[t])
    # Vi antager samme aldersfordeling af splurge på bolig og ikke-bolig, korrigeret for preferencen for bolig- vs ikke-bolig-forbrug
    # frSplurgeBolig giver niveau-skifte, for at ramme gennemsnitlig splurge på bolig, som er givet af IRF-matching
    E_rSplurgeBolig[a,t]$(a18t100[a] and tx0[t])..   
      rSplurgeBolig[a,t] =E= rSplurgeBolig[aTot,t1] * (uBolig[a,t] / uCx[a,t]) * frSplurgeBolig[t1];  

    E_rSplurge_a_deep[a,t]$(a18t100[a] and tx0[t])..   
       rSplurgeBolig[a,t] + rSplurge[a,t] =E=  rSplurgeBolig[aTot,t] + rSplurge_t[t];

    E_uFormue[t]$(tx1[t]).. uFormue[t] =E= uFormue[t1];

    # Arvemotiv identificeres ud fra antagelse om at splurge-motiv forklarer konstant andel af forbrug mod slutningen af livet.
    E_uArv[t]$(t1[t])..
      sum(a$(90 <= a.val and a.val <= 100), vSplurge[a,t] / vCx[a,t])
      =E=
      sum(a$(80 <= a.val and a.val < 90), vSplurge[a,t] / vCx[a,t]);

    E_uArv_forecast[t]$(tx1[t]).. uArv[t] =E= uArv[t1];

    # Residual i opsparingsadfærd følger kohorter. For negativ jvFormueBase svarer dette til at en del af kohortens formue er lagt til side og ikke indgår i forbrugsbeslutninger før formuen går i arv.
    E_jvFormueBase_forecast[a,t]$(tx1[t] and a18t100[a])..
      jvFormueBase[a,t] / vHhAkt['tot',a,t] =E= jvFormueBase[a-1,t-1] / vHhAkt['tot',a-1,t-1]
                                              * (rOverlev[a-1,t-1] + (1-rOverlev[a-1,t-1]) * rArvKorrektion[a]);

    # Vi tager gennemsnit over 5 aldersgrupper for at udglatte støj.
    E_uBolig_a_forecast[a,t]$(a18t100[a] and tx1[t] and a.val >= 22)..
      uBolig_a[a,t] =E= sum(aa$(a.val-2 <= aa.val and aa.val <= a.val+2 and a18t100[aa]), uBolig_a[aa,t1])
                      / sum(aa$(a.val-2 <= aa.val and aa.val <= a.val+2 and a18t100[aa]), 1);
    E_uBolig_a_forecast_u22[a,t]$(a18t100[a] and tx1[t] and a.val < 22)..
      uBolig_a[a,t] =E= uBolig_a[a,t1];

    E_vArvPrArving[a,t]$(tx0[t] and a.val > 0)..
      vArvPrArving[a,t] =E= vArvGivet[a,t] * (1-rOverlev[a-1,t-1]) * nPop[a-1,t-1] / nArvinger[a,t];
    E_rArv[a,t].. vArv[a,t] =E= sum(aa$(aa.val > 0), vArvPrArving[aa,t] * rArv_a[aa-1,a]);

    E_rLand2YBolig_forecast[t]$(tx1[t]).. rLand2YBolig[t] =E= rLand2YBolig_ARIMA[t] * rLand2YBolig[t1] / rLand2YBolig_ARIMA[t1] ;

    E_uYBolig_forecast[t]$(tx1[t]).. uYBolig[t] =E= uYBolig_ARIMA[t] * uYBolig[t1] / uYBolig_ARIMA[t1] ;

    E_fIBoligInstOmk_forecast[t]$(tx1[t]).. fIBoligInstOmk[t] =E= fq;
  $ENDBLOCK
  MODEL M_consumers_deep /
    M_consumers
    B_consumers_deep
  /;
  model M_deep_dynamic_calibration / M_consumers_deep /;
  $GROUP+ G_deep_dynamic_calibration G_consumers_deep;
$ENDIF

# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
  $GROUP G_consumers_dynamic_calibration    
    G_consumers_endo

    -vCx[aTot,t1], rSplurge_t[t1]
    rSplurge_t[tx1] # E_rSplurge_t

     -qBolig[aTot,t1], jrRefBolig[t1]
     jrRefBolig$(tx1[t]) # E_jrRefBolig
    -pBolig[t1], rLand2YBolig[t1]
    rLand2YBolig[tx1] # E_rLand2YBolig_forecast
    -qKBolig[t1], uYBolig[t1]
    uYBolig[tx1] # E_uYBolig_forecast
    -qLandSalg, qLand[tx0] # Afskrivningsrater for bolig er ekstremt lave i 2022 og 2023 foreløbig data - vi justerer land-mængde så at den frigivne mængde holdes konstant
    -rKLeje2Bolig[aTot,tx0], frKLeje2Bolig_t[tx0]
    -rKLeje2Bolig_a[a18t100,tx0], qKLejeBolig[a18t100,tx0]

    Res_vHhx[aTot,t]$(t2[t]) # E_Res_vHhx - denne er underforstået og ikke direkte modelleret i t1[t] - jf. kommentar nedenfor
  ;
  $BLOCK B_consumers_dynamic_calibration
    # Fejlled i samlet forbrug og boligforbrug gives persistens for at undgå store hop
    E_rSplurge_t[t]$(tx1[t]).. rSplurge_t[t] =E= 0.85**(dt[t]**1.5) * (rSplurge_t[t1] - rSplurge_t_baseline[t1]) + rSplurge_t_baseline[t];
    E_jrRefBolig[t]$(tx1[t]).. jrRefBolig[t] =E= 0.85**(dt[t]**1.5) * jrRefBolig[t1];

    E_rLand2YBolig_forecast[t]$(tx1[t]).. @gradual_return_to_baseline(rLand2YBolig);
    E_uYBolig_forecast[t]$(tx1[t]).. @gradual_return_to_baseline(uYBolig);

    # Residual i vHhx[aTot,t1] betyder, at denne ikke er lig sum(a, vHhx[a,t1] * nPop[a,t1])
    # Dette vil fortsætte i vHhx[aTot,t2] ift. sum(a, vHhx[a,t2] * nPop[a,t2]), hvis vi ikke korrigerer i vHhx[aTot,t2]  
    E_Res_vHhx_aTot[t]$(t2[t]).. vHhx[aTot,t] =E= sum(a, vHhx[a,t] * nPop[a,t]);
  $ENDBLOCK
  MODEL M_consumers_dynamic_calibration / 
    M_consumers
    B_consumers_dynamic_calibration
  /;
  model M_dynamic_calibration_newdata / M_consumers_dynamic_calibration /;
  $GROUP+ G_dynamic_calibration_newdata G_consumers_dynamic_calibration;
$ENDIF
