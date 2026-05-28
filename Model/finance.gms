# ======================================================================================================================
# Finance
# - Firm financing and valuation
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_finance_variables
    vAktie[t] "Aktier og andre ejerandelsbeviser, kursværdi, Kilde: ADAM[Ws_cr_z]+ADAM[Ws_cf_z]"
    vAktieDrift[t] "Nutidsværdi af frie pengestrømme til egenkapital ekskl. finansielle aktiver og passiver, diskonteret med rAktieDrift."
    nvFCFF[s_,t] "Nutidsværdi af frie pengestrømme til virksomheden ekskl. finansielle aktiver og passiver, diskonteret med rWACC."

    vEBT[s_,t] "Earnings before taxes - fortjeneste før beskatning."
    vEBTDrift[s_,t] "Earnings before taxes - fortjeneste før beskatning - alene den del der hører til driften uden afkast."
    vEBITDA[s_,t] "Earnings before interests, taxes, depreciation, and amortization - fortjeneste før renter, skatter og afskrivninger."
    vFCFF[s_,t] "Frie pengestrømme til virksomhed (Free cash flow to Firm) ekskl. fra finansiel portefølje."
    vFCFE[s_,t] "Frie pengestrømme til egenkapital (Free cash flow to equity) ekskl. fra finansiel portefølje."

    vVirkNetRenter[t] "Samlet nettoformueindkomst for finansielle og ikke-finansielle selskaber, Kilde: ADAM[Tin_cr]+ADAM[Tin_cf]"
    vVirkAktRenter[portf_,t] "Samlet formueindkomst fra aktiver for finansielle og ikke-finansielle selskaber"
    vVirkPasRenter[portf_,t] "Samlet rente- og dividendeudskrivninger for finansielle og ikke-finansielle selskaber"
    vVirkOevrigPasRenter[portf_,t] "Virksomhedernes renteudskrivninger for gæld hverken knyttet til egenkapital eller drift"

    vVirkOmv[t] "Samlede omvurderinger af finansielle og ikke-finansielle selskabers nettoformue, Kilde: ADAM[Wn_cr]+ADAM[Wn_cf]-ADAM[Wn_cr][-1]-ADAM[Wn_cf][-1]-ADAM[Tfn_cr]-ADAM[Tfn_cf]"
    vVirkAktOmv[portf_,t] "Omvurderinger på selskabernes finansielle aktiver"
    vVirkPasOmv[portf_,t] "Omvurderinger på selskabernes finansielle passiver"
    vVirkOevrigPasOmv[portf_,t] "Omvurderinger på selskabernes gæld hverken knyttet til egenkapital eller drift"
    jvVirkOmv[t] "Aggregeret J-led"

    vVirkNFE[t] "Samlet nettofordringserhvervelse for finansielle og ikke-finansielle selskaber, Kilde: ADAM[Tfn_cr]+ADAM[Tfn-Cf]"

    vKskat[i_,s_,t] "Bogført værdi af kapitalapparat fordelt på brancher."
    vAfskrFradrag[i_,s_,t] "Skatte-fradrag for kapitalafskrivninger."
    dnvAfskrFradrag2dvI_s[k,s_,t] "Den afledte af nutidsværdien af afskrivningsfradraget knyttet til investeringer."
    dnvKskat2dvI_s[k,s_,t] "Den afledte af nutidsværdien af skattemæssigt kapital knyttet til investeringer."
    vDividender[t] "Samlede udbytter af aktier og ejerandelsbeviser udbetalt af indenlandske selskaber, Kilde: ADAM[Tiu_cr_z]+ADAM[Tiu_cf_z]"
    vUdstedelser[t] "Nettoudstedelser af aktier fra indenlandske selskaber, Kilde: ADAM[Tfs_cr_z]+ADAM[Tfs_cf_z]"

    vVirkK[i_,s_,t] "Værdi af kapitalbeholdningen til investeringspris ekskl. husholdningernes boligkapital."

    vVirkAkt[portf_,t] "Virksomhedernes finansielle aktiver, Kilde: jf. portfolio set."
    vVirkPas[portf_,t] "Virksomhedernes finansielle passiver, Kilde: jf. portfolio set."
    vVirkOevrigPas[portf_,t] "Virksomhedernes gæld hverken knyttet til egenkapital eller drift."
    vVirkNet[t] "Virksomhedernes finansielle nettoportefølje, Kilde: jf. portfolio set."
    vVirkDriftPas[i_,s_,t] "Lån til gældsfinansierede investeringer."
    vAktieOevrig[t] "Samlet værdi af virksomhedernes finansielle nettoaktiver ikke knyttet til investeringer og virksomhedsdrift"
    vAktieOevrigRenter[t] "Formueindkomst fra virksomhedernes finansielle nettoaktiver ikke knyttet til investeringer og virksomhedsdrift"
    vAktieOevrigOmv[t] "Omvurderinger af virksomhedernes finansielle nettoaktiver ikke knyttet til investeringer og virksomhedsdrift"

    vPensionAkt[portf_,t] "Porteføljen af pensionsformuen."
    vPensionAktRenter[portf_,t] "Formueindkomst fra pensionsaktiver"
    vPensionRenter[t] "Formueindkomst fra pensionsaktiver"
    jvPensionRenter[t] "Aggregeret J-led"
    vPensionAktOmv[portf_,t] "Omvurderinger på pensionsformuen"
    vPensionOmv[t] "Omvurderinger på pensionsformuen"
    jvPensionOmv[t] "Aggregeret J-led"

    vtSelskabDrift[s_,t] "Den del af selskabsskatten der hører til driften."

    vVirkOevrigUrealiseretOmv[t] "Skøn over virksomheders realiserede gevinst ved salg af finansielle aktiver ekskl. driftsgæld."
    vVirkOevrigRealiseretOmv[t] "Skøn over virksomhedernes endnu ikke realiserede kapitalgevinster på finansielle aktiver ekskl. driftsgæld."

    fVirkDisk[s_,t] "Selskabernes diskonteringsrate."
    rWACC[s_,t] "Weighed average cost of capital."
    rRealKredLaan2Laan[i_,s_,t] "Realkreditfinansieringsandel af gældsfinansiering."
    mrLaan2K[i_,s_,t] "Marginal gældsfinansieringsandel for investeringer."
    rAktieDrift[t] "Investorernes forventede afkast på vAktieDrift. I fravær af stød er den lig afkastet på vAktieDrift."
    rAktieOevrigAfk[t] "Afkastrate på virksomhedernes finansielle aktiver efter selskabsskat."
    rRente[portf_,t] "Renter og dividender på finansiel portefølje."
    rAfk[portf,t] "Sum af omvurderinger og renter på finansielt aktiv eller passiv."
    rFinAccelPrem[s_,t] "Ændring i risikopræmie fra finansiel friktion."
    dFinFriktion[sp,t] "Afledt af finansiel friktion ift. fri pengestrøm."
    rRenteOblEU[t] "EU effektive rente af langfristede obligationer. Kilde: ADAM[iwbeu]"
    rRenteOblDK[t] "Effektiv rente på 10-årig statsobligation (stående lån), årsgennemsnit. Kilde: ADAM[iwbos]"
    rRenteFlex[t] "Flexlånerente. Kilde: ADAM[iwbflx]"
    rRenteFast[t] "30-årig byggeobligation. Kilde: ADAM[iwb30]"
    mrVirkDriftPasRente[i_,s_,t] "Gennemsnitlig marginalrente til virksomhedsinvesteringer ekskl. omvurderinger (imputeret)"
    mrVirkDriftPasOmv[i_,s_,t] "Gennemsnitlig marginal omvurdering på gæld til virksomhedsinvesteringer (imputeret)"
  ;

  $GROUP G_finance_exogenous_forecast
    rRenteECB[t] "ECB-renten. Kilde: ADAM[iweu]"
    rOblPrem[t] "Risikopræmie på obligationer ift. pengemarkedsrente."
    rAktieDriftPrem[t] "Risikopræmie på indenlandske aktier."
    vFCFExRefRest[sp,t] "Restled i vFCFExRef - kalibreres til at slå finansiel friktion fra i grundforløb."
    rVirkDiskPrem[s_,t] "Risikopræmie i diskonteringsraten for virksomhedens beslutningstagere."
    uFinAccel[sp,t] "Hældning af den approksimerede afledte af omkostnings-funktionen fra finansielle friktioner i steady state."
    vVirkIndRest[t] "Rest-led i virksomheden indtjening."

    # Eksogene tabel-variable uden endogene effekter i MAKRO
    rRenteUSA[t] "USAs effektive rente af langfristede obligationer. Kilde: ADAM[iwbus]"
    rRente3mdr[t] "3 måneders pengemarkedsrente (CIBOR) årsgennemsnit. Kilde: ADAM[iw3m]"
    rRenteOblDKUltimo[t] "Effektiv rente på 10-årig statsobligation (stående lån), ultimo. Kilde: ADAM[iwbosu]"
    rDiskontoen[t] "Diskontoen. Kilde: ADAM[iwdi]"
    ADAM_pension[ADAM_pension_LIST,t] "ADAM-variable overført direkte i samme enhed som i ADAM ikke vækst- og inflationskorrigeret"
  ;
  $GROUP+ G_exogenous_forecast G_finance_exogenous_forecast$(tx1[t]);

  $GROUP G_finance_forecast_as_zero
    jrPensionAktRenter[portf_,t] "J-led."
    jrPensionAktOmv[portf_,t] "J-led."
    jrOmv_IndlAktier[t] "J-led - alene nødvendigt pga. databrud i 2016"

    jrVirkAktRenter[portf_,t] "J-led som dækker forskel mellem selskabernes og den gennemsnitlige rente på aktivet/passivet."
    jrVirkPasRenter[portf_,t] "J-led som dækker forskel mellem selskabernes og den gennemsnitlige rente på aktivet/passivet."
    jrVirkAktOmv[portf_,t] "J-led som dækker forskel mellem selskabernes og den gennemsnitlige omvurdering på aktivet/passivet."
    jrVirkPasOmv[portf_,t] "J-led som dækker forskel mellem selskabernes og den gennemsnitlige omvurdering på aktivet/passivet."

    jvKskat[i_,s_,t] "J-led."

    rOmv[portf_,t]$(Obl[portf_] or Bank[portf_] or RealKred[portf_]) "Omvurderinger på finansiel portefølje."

    rRenteSpaend[t] "Forskel på renten på danske statsobligationer og obligationer ustedt af ECB" 
  ;
  $GROUP+ G_forecast_as_zero G_finance_forecast_as_zero$(tx1[t]);

  $GROUP G_finance_ARIMA_forecast
    rRente$(IndlAktier[portf_] or UdlAktier[portf_])
    crRenteObl[t] "Forskel på gennemsnitlig obligationsrente og statsobligationsrente"
    crRenteBank[t] "Forskel på ECBs og Danmarks pengemarkedsrente."
    crRenteFlex[t] "Forskel på renten på flexlån og gns. obligationer"
    crRenteFast[t] "Forskel på renten på 30-årige realkreditlån og gns. obligationer"
    crRenteRealKred[t] "Forskel på gns. rente på realkreditlån og vægtet gns. af flex og fast forrentet"
    rVirkIndRest[t] "Parameter for rest-led i virksomheden indtjening."
    rPensionAkt[portf_,t] "Andel af aktiver ud af samlede aktiver."
  ;
  $GROUP+ G_ARIMA_forecast G_finance_ARIMA_forecast;

  $GROUP G_finance_constants
    rFinAccelTraeghed "Træghed i opdatering af reference-profit for finansiel friktion. Styrer persistens i finansiel friktion."
    rFinAccel[sp] "Straf-rente fra finansielle friktioner på overskydende (manglende) fri pengestrømme."
  ;
  $GROUP+ G_constants G_finance_constants;

  $GROUP G_finance_fixed_forecast
    mrRealKredLaan2K[i_,s_,t] "Realkreditfinansieringsandel for investeringer."
    mrBankLaan2K[i_,s_,t] "Bankfinansieringsandel for investeringer."
    vFCFExRef[sp,t]$(byg[sp] or lan[sp] or bol[sp] or ene[sp] or udv[sp]) "vFCFE eksklusiv reference-pengestrøm."
    rKskat[k,t] "Andel af investering er fradragsberettiget."
    rSkatAfskr[k,t] "Skattemæssig afskrivningsrate."
    rSkatAfskr0[k,t] "Skattemæssig straksafskrivningsrate."
    rVirkOevrigRealiseringOmv[t] "Andel af omvurderinger på virksomheders aktier som realiseres hvert år."
    rVirkAktieFradrag[t] "Virksomheders aktie fradrag"
    rVirkOevrigPas[portf_,t] "Fast del af obligationsgæld ikke direkte knyttet til investeringer, som andel af virksomhedens værdi ekskl. finansielle aktiver og residual."
    rVirkAkt[portf,t]$(not Guld[portf]) "Virksomhedens finansielle aktiver, som andel af virksomhedens værdi ekskl. finansielle aktiver og residual."
    rOmv[Guld,t]
    rVirkDisk[s_,t] "Selskabernes diskonteringsrate."
  ;
  $GROUP+ G_fixed_forecast G_finance_fixed_forecast;
$ENDIF

# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_finance_static G_finance_static $(tx0[t])
    ######################################################
    ### Diskonteringsfaktorer og finansiel accelerator ###
    ######################################################
    ## Virksomhedens diskonteringsrate for egenkapital
    $(tx1[t] and sp[sp]).. rVirkDisk[sp,t] =E= rRenteECB[t] + rVirkDiskPrem[sp,t] + rFinAccelPrem[sp,t];

    $(tx1[t]).. rVirkDisk[spTot,t] =E= rRenteECB[t] + rVirkDiskPrem[spTot,t] + rFinAccelPrem[spTot,t];

    $(tx1[t]).. rVirkDiskPrem[spTot,t] * vVirkK[kTot,sTot,t] =E= sum(sp, rVirkDiskPrem[sp,t] * vVirkK[kTot,sp,t]);

    ## Virksomhedernes diskonteringsfaktor for egenkapital
    $(tx1[t]).. fVirkDisk[sp,t] =E= 1 / (1 + rVirkDisk[sp,t]);
    
    ## Finansiel friktion
    $(tx1[t] and t.val > %AgeData_t1% + 1)..
      rFinAccelPrem[sp,t] =E= (1 + rRenteECB[t] + rVirkDiskPrem[sp,t]) * ((1 - dFinFriktion[sp,t-1]) / (1 - dFinFriktion[sp,t]) - 1);

    $(tx1[t] and t.val > %AgeData_t1%)..
      dFinFriktion[sp,t] =E= rFinAccel[sp] * tanh(uFinAccel[sp,t] * vFCFExRef[sp,t]);

    $(tx1[t] and t.val > %AgeData_t1% + 1)..
      rFinAccelPrem[spTot,t] * vVirkK[kTot,sTot,t] =E= sum(sp, rFinAccelPrem[sp,t] * vVirkK[kTot,sp,t]);

    $(t.val > %AgeData_t1%)..
      vFCFExRef[sp,t] =E= rFinAccelTraeghed * (vFCFE[sp,t] - vFCFE[sp,t-1] + vFCFExRef[sp,t-1]) + vFCFExRefRest[sp,t]; # /fv udeladt

    ############################################################################################################
    ### Samlet værdi af ejenkapital i danske virksomheder - alle virksomheder antages at være aktieselskaber ###
    ############################################################################################################
    # Denne er opdelt i en driftsdel (Drift), som er den tilbagediskonterede værdi af driften
    # og en øvrig del, som er deres nettoformue ekskl. den del af gælden som er knyttet til driften.
    $(t.val >= %NettoFin_t1%).. vAktie[t] =E= vAktieDrift[t] + vAktieOevrig[t];

    #################################################################
    ### Virksomhedernes nettoformue ekskl. gæld knyttet til drift ###
    #################################################################
    # Samlet værdi er opgjort til bogført værdi af værdipapirer
    $(t.val >= %NettoFin_t1%).. vAktieOevrig[t] =E= vVirkAkt['tot',t] - vVirkOevrigPas['tot',t];

    # Finansielle aktiver og passiver ekskl. gæld knyttet til drift følger virksomhedens tilbagediskonterede driftsværdi
    $(d1vVirkAkt[portf,t]).. vVirkAkt[portf,t] =E= rVirkAkt[portf,t] * vAktieDrift[t];
    $(t.val >= %NettoFin_t1%).. vVirkAkt[portfTot,t] =E= sum(portf, vVirkAkt[portf,t]);
    $(d1vVirkPas[portf,t] and not IndlAktier[portf]).. vVirkOevrigPas[portf,t] =E= rVirkOevrigPas[portf,t] * vAktieDrift[t];
    $(t.val >= %NettoFin_t1%).. vVirkOevrigPas[portfTot,t] =E= sum(portf, vVirkOevrigPas[portf,t]);

    # Vi antager nul handel af monetært guld i fremskrivningen
    rVirkAkt[Guld,t]$(tForecast[t]).. vVirkAkt[Guld,t] =E= (1+rOmv[Guld,t]) * vVirkAkt[Guld,t-1]/fv;

    #######################################
    ### Driftsværdien af virksomhederne ###
    #######################################
    # Grundlæggende ligning er givet i B_finance_forwardlooking
    # Er den tilbagediskoneterede værdi af alle fremtidige Free Cash Flows to Equity ekskl. 

    # FCFE diskonteres med afkastkravet til indenlandske aktier givet ved
    $(tx1[t]).. rAktieDrift[t] =E= rRenteECB[t] + rAktieDriftPrem[t];

    # Frie pengestrømme til egenkapital (Free Cash Flow to Equity) ekskl. fra finansiel fra portefølje
    # Denne består af Free Cash Flow to Firm fratrukket nettostrøm af renter, nettoafbetaling mv. til gæld knyttet til driften
    $(t.val > %NettoFin_t1%)..
      vFCFE[sp,t] =E= vFCFF[sp,t]                        
                   - sum(k, (mrVirkDriftPasRente[k,sp,t] + mrVirkDriftPasOmv[k,sp,t]) * vVirkDriftPas[k,sp,t-1]/fv)
                   + vVirkDriftPas[kTot,sp,t] - vVirkDriftPas[kTot,sp,t-1]/fv;
    $(t.val > %NettoFin_t1%)..
      vFCFE[sTot,t] =E= vFCFF[sTot,t]                        
                      - sum(k, (mrVirkDriftPasRente[k,sTot,t] + mrVirkDriftPasOmv[k,sTot,t]) * vVirkDriftPas[k,sTot,t-1]/fv)
                      + vVirkDriftPas[kTot,sTot,t] - vVirkDriftPas[kTot,sTot,t-1]/fv;

    #####################################################################################
    ### Pengestrøm knyttet til renter nettoafbetaling mv. til gæld knyttet til drften ###
    #####################################################################################
    # Marginal rentesats og omvurderingsrate knyttet lån knyttet til driften
    $(sp[s_] or sTot[s_]).. 
      mrVirkDriftPasRente[k,s_,t] =E= (1 - rRealKredLaan2Laan[k,s_,t-1]) 
                                          * (rRente['Bank',t] + jrVirkPasRenter['Bank',t])
                                        + rRealKredLaan2Laan[k,s_,t-1] 
                                          * (rRente['RealKred',t] + jrVirkPasRenter['RealKred',t]);
    $(sp[s_] or sTot[s_]).. 
      mrVirkDriftPasOmv[k,s_,t] =E= (1 - rRealKredLaan2Laan[k,s_,t-1]) 
                                       * (rOmv['Bank',t] + jrVirkPasOmv['Bank',t])
                                     + rRealKredLaan2Laan[k,s_,t-1] 
                                       * (rOmv['RealKred',t] + jrVirkPasOmv['RealKred',t]);
    
    # Realkreditlåns andel af samlede lån til drift
    $(sp[s_] or sTot[s_]).. rRealKredLaan2Laan[k,s_,t] * mrLaan2K[k,s_,t] =E= mrRealKredLaan2K[k,s_,t];

    # Gæld knyttet til kapitalapparat
    .. vVirkDriftPas[k,sp,t] =E= mrLaan2K[k,sp,t] * vVirkK[k,sp,t];
    .. vVirkDriftPas[k,sTot,t] =E= mrLaan2K[k,sTot,t] * vVirkK[k,sTot,t];
    $((sp[s_] or sTot[s_])).. vVirkDriftPas[kTot,s_,t] =E= sum(k, vVirkDriftPas[k,s_,t]);

    # Værdi af virksomhedens kapital til genanskaffelsespris
    $(not (bol[sp] and iB[k])).. vVirkK[k,sp,t] =E= pI_s[k,sp,t] * qK[k,sp,t];
    .. vVirkK[iB,bol,t] =E= pI_s[iB,bol,t] * qK[iB,bol,t] - pI_s[iB,bol,t] * qKBolig[t];
    .. vVirkK[k,sTot,t] =E= sum(sp, vVirkK[k,sp,t]);
    .. vVirkK[kTot,sp,t] =E= sum(k, vVirkK[k,sp,t]);
    .. vVirkK[kTot,sTot,t] =E= sum(sp, vVirkK[kTot,sp,t]);

    # Belåningandele af kapital
    .. mrLaan2K[k,sp,t] =E= mrRealKredLaan2K[k,sp,t] + mrBankLaan2K[k,sp,t];
    .. mrLaan2K[kTot,sp,t] * vVirkK[kTot,sp,t] =E= sum(k, mrLaan2K[k,sp,t] * vVirkK[k,sp,t]);
    .. mrLaan2K[k_,sTot,t] * vVirkK[k_,sTot,t] =E= sum(sp, mrLaan2K[k_,sp,t] * vVirkK[k_,sp,t]);

    .. mrRealKredLaan2K[k,sTot,t] * vVirkK[k,sTot,t] =E= sum(sp, mrRealKredLaan2K[k,sp,t] * vVirkK[k,sp,t]);
    .. mrBankLaan2K[k,sTot,t] * vVirkK[k,sTot,t] =E= sum(sp, mrBankLaan2K[k,sp,t] * vVirkK[k,sp,t]);

    ###########################################################################################################################
    ### Frie pengestrømme til virksomhederne (Free Cash Flow to Firm) ekskl. fra finansiel opsparing ikke tilknyttet drifts ###
    ###########################################################################################################################
    # Er givet ved indtjening fra produktion fratrukket investeringer, selskabsskat og indkomstoverførsler
    $(t.val > %NettoFin_t1%)..
      vFCFF[sp,t] =E= vEBITDA[sp,t]                        
                    - vI_s[iTot,sp,t] + vHhInvestx[aTot,t] * vI_s[iTot,sp,t] / vI_s[iTot,spTot,t] + bol[sp] * vIBolig[t]
                    - vtSelskabDrift[sp,t]
                    # Nettooverførsler til virksomhederne
                    + (vOffLandKoeb[t]
                    - vSelvstKapInd[aTot,t]
                    + vOffTilVirk[t] - vOffFraVirk[t]        
                    - vHhFraVirk[t]
                    + vVirkIndRest[t]) * vVirkK[kTot,sp,t] / vVirkK[kTot,sTot,t];                       
    $(t.val > %NettoFin_t1%)..
      vFCFF[sTot,t] =E= vEBITDA[sTot,t]                        
                      - vI_s[iTot,spTot,t] + vHhInvestx[aTot,t] + vIBolig[t]
                      - vtSelskabDrift[sTot,t]                           
                      # Nettooverførsler til virksomhederne
                      + vOffLandKoeb[t]
                      - vSelvstKapInd[aTot,t]
                      + vOffTilVirk[t] - vOffFraVirk[t]        
                      - vHhFraVirk[t]
                      + vVirkIndRest[t];                       

    # Earnings before interests, corporate taxes, and depreciation. Payroll taxes are included in both vtNetY and vL, and are added back.
    .. vEBITDA[sp,t] =E= vY[sp,t] - vLoensum[sp,t] - vSelvstLoen[sp,t] - vR[sp,t] - vE[sp,t] - vtNetY[sp,t] 
                       - vLejeAfEjerBolig[t]$(bol[sp]); # Lejeværdi af egen bolig trækkes fra, da det går til husejerne
    .. vEBITDA[sTot,t] =E= vY[spTot,t] - vLoensum[spTot,t] - vSelvstLoen[spTot,t] - vR[spTot,t] - vE[spTot,t] - vtNetY[spTot,t] 
                         - vLejeAfEjerBolig[t]; # Lejeværdi af egen bolig trækkes fra, da det går til husejerne

    # Den del af selskabsskat der hører til driften
    $(t.val > %NettoFin_t1%)..
      vtSelskabDrift[sp,t] =E= tSelskab[t] * ftSelskab[t] * vEBTDrift[sp,t] + vtSelskabRest[sp,t];
    $(t.val > %NettoFin_t1%)..
      vtSelskabDrift[sTot,t] =E= tSelskab[t] * ftSelskab[t] * vEBTDrift[sTot,t] + vtSelskabRest[sTot,t];

    # Earnings before taxes ekskl. afkast på portefølje
    # Det antages implicit, at kursændringer på realkredit og gældseftergivelse beskattes umiddelbart og fuldt - da de er del af mrVirkDriftPasRente
    .. vEBTDrift[sp,t] =E= vEBITDA[sp,t] - vAfskrFradrag[kTot,sp,t] 
                         - sum(k, (mrVirkDriftPasRente[k,sp,t] + mrVirkDriftPasOmv[k,sp,t]) * vVirkDriftPas[k,sp,t-1]/fv);
    .. vEBTDrift[sTot,t] =E= vEBITDA[sTot,t] - vAfskrFradrag[kTot,sTot,t] 
                           - sum(k, (mrVirkDriftPasRente[k,sTot,t] + mrVirkDriftPasOmv[k,sTot,t]) * vVirkDriftPas[k,sTot,t-1]/fv);

    # Skattemæssige fradrag
    $(d1k[k,sp,t]).. 
      vAfskrFradrag[k,sp,t] =E= rSkatAfskr0[k,t] * (vI_s[k,sp,t] - bol[sp] * vIBolig[t]) 
                              + rSkatAfskr[k,t] * vKskat[k,sp,t-1]/fv;
    .. vAfskrFradrag[k,sTot,t] =E= sum(sp, vAfskrFradrag[k,sp,t]);
    .. vAfskrFradrag[kTot,sp,t] =E= sum(k, vAfskrFradrag[k,sp,t]);
    .. vAfskrFradrag[kTot,sTot,t] =E= sum(sp, vAfskrFradrag[kTot,sp,t]);

    $(tx0[t] and d1K[k,sp,t] and t.val > %NettoFin_t1%)..
      dnvAfskrFradrag2dvI_s[k,sp,t] =E= rSkatAfskr0[k,t] * mtVirk[sp,t] # periode 1
                                      + (rKskat[k,t] - rSkatAfskr0[k,t]) * dnvKskat2dvI_s[k,sp,t]; # periode 2+

    # Tax book value of firm shares
    $(d1k[k,sp,t]).. vKskat[k,sp,t] =E= vKskat[k,sp,t-1]/fv - vAfskrFradrag[k,sp,t]
                                      + rKskat[k,t] * (vI_s[k,sp,t] - bol[sp] * vIBolig[t]) + jvKskat[k,sp,t];
    .. vKskat[k,sTot,t] =E= sum(sp, vKskat[k,sp,t]);
#    E_vKskat_sTot[k,t]$(d1k[k,spTot,t])..
#      vKskat[k,spTot,t] =E= vKskat[k,sTot,t-1]/fv - vAfskrFradrag[k,sTot,t] + vI_s[k,spTot,t] - vIBolig[t]
#                     + ((vKskat[k,sTot,t-1]/fv - vAfskrFradrag[k,sTot,t]) * (rSkatAfskr[k,t] / rSkatAfskr[k,t-1] - 1))$(t.val = 2023); # Jf. kommentar ovenfor!
    .. vKskat[kTot,sp,t] =E= sum(k, vKskat[k,sp,t]);
    .. vKskat[kTot,sTot,t] =E= sum(sp, vKskat[kTot,sp,t]);

    # Rest-indkomst til virksomhederne
    rVirkIndRest[t]$(t.val > %NettoFin_t1%).. vVirkIndRest[t] =E= rVirkIndRest[t] * vI_s[iM,spTot,t];

    #####################################
    ### Afkast på indenlandske aktier ###
    #####################################
    # Dividender på indenlandske aktier
    $(t.val > %NettoFin_t1%).. vDividender[t] =E= rRente[IndlAktier,t] * vAktie[t-1]/fv;

    # Omvurderinger på aktier
    # Bemærk, at udstedelser øger vAktie 1-til-1 (via vAktieOevrig) og påvirker derfor ikke omvurderingerne
    # Indsættes for vUdstedelser fås, at rOmv+rRente følger rAktieDrift vægtet med driftsdel og rAktieOevrigAfk vægtet med øvrig del
    $(t.val > %NettoFin_t1%).. rOmv[IndlAktier,t] =E= (vAktie[t] - vUdstedelser[t]) / (vAktie[t-1]/fv) - 1;

    # Budget-begrænsning
    # Udstedelser bestemmes residualt for at ramme en eksogen dividende-rate
    # Hvis forøgelse af finansielle nettoaktiver plus udbetaling af dividender overstiger afkastet, skal der udstedes flere aktier
    $(t.val > %NettoFin_t1%)..
      vUdstedelser[t] =E= (vAktieOevrig[t] - vAktieOevrig[t-1]/fv) + vDividender[t] 
                          - (vFCFE[sTot,t] + rAktieOevrigAfk[t] * vAktieOevrig[t-1]/fv);

    # Afkast på virksomhedernes finansielle portefølje ekskl. gæld til drift efter skat
    $(t.val > %NettoFin_t1%)..
      rAktieOevrigAfk[t] * vAktieOevrig[t-1]/fv =E= vAktieOevrigRenter[t] + vAktieOevrigOmv[t]
                                                    - (vtSelskab[sTot,t] - vtSelskabDrift[sTot,t]);

    # Selskabsskat beregnes i GovRevenues og EBT beregnes her
    # Earnings before taxes
    # Branche-fordelingen er pt. ikke datadækket
    .. vEBT[sp,t] =E= vEBTDrift[sp,t]
                    + (  sum(portf$(not IndlAktier[portf] and not UdlAktier[portf]), vVirkAktRenter[portf,t]) 
                       - sum(portf$(not IndlAktier[portf] and not UdlAktier[portf]), vVirkOevrigPasRenter[portf,t]) 
                        + (1-rVirkAktieFradrag[t]) 
                          * (vVirkAktRenter['IndlAktier',t] + vVirkAktRenter['UdlAktier',t] + vVirkOevrigRealiseretOmv[t])
                        ) * vVirkK[kTot,sp,t] / vVirkK[kTot,sTot,t]; 
    .. vEBT[sTot,t] =E= vEBTDrift[sTot,t]
                      + sum(portf$(not IndlAktier[portf] and not UdlAktier[portf]), vVirkAktRenter[portf,t]) 
                      - sum(portf$(not IndlAktier[portf] and not UdlAktier[portf]), vVirkOevrigPasRenter[portf,t]) 
                      + (1-rVirkAktieFradrag[t]) 
                        * (vVirkAktRenter['IndlAktier',t] + vVirkAktRenter['UdlAktier',t] + vVirkOevrigRealiseretOmv[t]); 

    # Vi antager en fast realiseringsgrad ift. beskatning af omvurderinger på aktier
    # Da urealiserede gevinster akkumuleres flytter realiseringsgraden blot gevinster over tid, men ændrer ikke den samlede nominelle beskatning 
    $(t.val > %NettoFin_t1%).. vVirkOevrigRealiseretOmv[t] =E= rVirkOevrigRealiseringOmv[t] * vVirkOevrigUrealiseretOmv[t];
    # Omvurderinger på banklån og realkredit knyttet til drift er ikke en del af dette
    $(t.val > %NettoFin_t1%)..
      vVirkOevrigUrealiseretOmv[t] =E= vVirkOevrigUrealiseretOmv[t-1]/fv - vVirkOevrigRealiseretOmv[t] + sum(portf, vVirkAktOmv[portf,t])
                                 - sum(portf$(not IndlAktier[portf]), vVirkOevrigPasOmv[portf,t]) ;

    #################################################################################################
    ### Renter og omvurderinger for virksomhedernes finansielle portefølje ikke knyttet til drift ###
    #################################################################################################
    # Samlede rentestrømme og omvurderinger
    $(t.val > %NettoFin_t1%)..
      vAktieOevrigRenter[t] =E= sum(portf, vVirkAktRenter[portf,t]) - sum(portf, vVirkOevrigPasRenter[portf,t]) - vJordrente[t];
    $(t.val > %NettoFin_t1%)..
      vAktieOevrigOmv[t] =E= sum(portf, vVirkAktOmv[portf,t]) - sum(portf, vVirkOevrigPasOmv[portf,t]);

    # Rentestrømme
    $(d1vVirkAkt[portf,t] and t.val > %NettoFin_t1%)..
      vVirkAktRenter[portf,t] =E= (rRente[portf,t] + jrVirkAktRenter[portf,t]) * vVirkAkt[portf,t-1]/fv;
    $(d1vVirkPas[portf,t] and not IndlAktier[portf] and t.val > %NettoFin_t1%)..
      vVirkOevrigPasRenter[portf,t] =E= (rRente[portf,t] + jrVirkPasRenter[portf,t]) * vVirkOevrigPas[portf,t-1]/fv;  

    # Omvurderinger
    $(d1vVirkAkt[portf,t] and t.val > %NettoFin_t1%)..
      vVirkAktOmv[portf,t] =E= (rOmv[portf,t] + jrVirkAktOmv[portf,t]) * vVirkAkt[portf,t-1]/fv;
    $(d1vVirkPas[portf,t] and not IndlAktier[portf] and t.val > %NettoFin_t1%)..
      vVirkOevrigPasOmv[portf,t] =E= (rOmv[portf,t] + jrVirkPasOmv[portf,t]) * vVirkOevrigPas[portf,t-1]/fv;

    ##########################################################################################
    ### Finansielle passiver og nettostørrelser for drift og ikke-drift for virksomhederne ###
    ##########################################################################################
    # Beholdninger
    $(d1vVirkPas[portf,t] and not IndlAktier[portf])..
      vVirkPas[portf,t] =E= vVirkOevrigPas[portf,t]
                          + sum(k, mrBankLaan2K[k,sTot,t] * vVirkK[k,sTot,t])$(Bank[portf])
                          + sum(k, mrRealKredLaan2K[k,sTot,t] * vVirkK[k,sTot,t])$(RealKred[portf]);

    $(d1vVirkPas[IndlAktier,t]).. vVirkPas[IndlAktier,t] =E= vAktie[t];

    $(t.val >= %NettoFin_t1%).. vVirkPas[portfTot,t] =E= sum(portf, vVirkPas[portf,t]);

    .. vVirkNet[t] =E= vVirkAkt['tot',t] - vVirkPas['tot',t];

    # Rentestrømme
    $(d1vVirkPas[portf,t] and t.val > %NettoFin_t1%)..
      vVirkPasRenter[portf,t] =E= (rRente[portf,t] + jrVirkPasRenter[portf,t]) * vVirkPas[portf,t-1]/fv;
    $(t.val > %NettoFin_t1%)..
      vVirkNetRenter[t] =E= sum(portf, vVirkAktRenter[portf,t]) - sum(portf, vVirkPasRenter[portf,t]) - vJordrente[t];

    # Omvurderinger
    $(d1vVirkPas[portf,t] and t.val > %NettoFin_t1%)..
      vVirkPasOmv[portf,t] =E= (rOmv[portf,t] + jrVirkPasOmv[portf,t]) * vVirkPas[portf,t-1]/fv;
    $(t.val > %NettoFin_t1%)..
      vVirkOmv[t] =E= sum(portf, vVirkAktOmv[portf,t]) - sum(portf, vVirkPasOmv[portf,t]);
    $(t.val > %NettoFin_t1%)..
      jvVirkOmv[t] =E= sum(portf, jrVirkAktOmv[portf,t] * vVirkAkt[portf,t-1]/fv)
                     - sum(portf, jrVirkPasOmv[portf,t] * vVirkPas[portf,t-1]/fv);

    # Nettofordringserhvervelsen er tæt knyttet til FCFE
    $(t.val > %NettoFin_t1%).. vVirkNFE[t] =E= vVirkNet[t] - vVirkNet[t-1]/fv - vVirkOmv[t];

    #############################
    ### Rentesatser og afkast ###
    #############################
    # Der er en sammenhæng mellem ECB-renten og de øvrige renter i modellen
    .. rRenteOblEU[t] =E= rRenteECB[t] + rOblPrem[t]; 
    $(t.val >= 1985).. rRenteOblDK[t] =E= rRenteECB[t] + rRenteSpaend[t] + rOblPrem[t]; 

    $(t.val >= 1985).. rRente[Bank,t] =E= rRenteECB[t] + rRenteSpaend[t] + crRenteBank[t];
    $(t.val >= 1985).. rRente[Obl,t] =E= rRenteECB[t] + rRenteSpaend[t] + rOblPrem[t] + crRenteObl[t]; 
    # Groft skøn for fremskrivning - gennemsnitsrenten er gennemsnit over alle typer af flex og fastforrentede fra 
    # de seneste 29 år - nedenstående er en grov approksimation til fremskrivning
    $(t.val >= 2001)..
      rRente[RealKred,t] =E= 0.4 * rRenteFlex[t] + 0.3 * rRenteFast[t] + 0.2 * rRenteFast[t-1] + 0.1 * rRenteFast[t-2]
                           + crRenteRealKred[t];
    $(t.val >= 2000)..
      rRenteFlex[t] =E= rRenteECB[t] + rRenteSpaend[t] + rOblPrem[t] + crRenteObl[t] + crRenteFlex[t];

    .. rRenteFast[t] =E= rRenteECB[t] + rRenteSpaend[t] + rOblPrem[t] + crRenteObl[t] + crRenteFast[t];

    # Afkast
    $(t.val > %NettoFin_t1%).. rAfk[portf,t] =E= rRente[portf,t] + rOmv[portf,t];

	  # Gennemsnitlige kapitalomkostninger vægtet ud fra bogført gældskvote-målsætning
    $(t.val > %NettoFin_t1%)..
      rWACC[sp,t] =E= sum(k, (mrVirkDriftPasRente[k,sp,t] + mrVirkDriftPasOmv[k,sp,t]) * mrLaan2K[k,sp,t-1] 
                              * vVirkK[k,sp,t-1] / vVirkK[kTot,sp,t-1]) 
                      * (1 - tSelskab[t] * ftSelskab[t])
                      + (1 - sum(k, mrLaan2K[k,sp,t-1] * vVirkK[k,sp,t-1] / vVirkK[kTot,sp,t-1])) * rVirkDisk[sp,t];

    ####################################
    ### Pensionsportefølje og afkast ###
    ####################################
    # Renter og omvurderinger for pensionsselskaberne
    $(t.val > %NettoFin_t1%).. rRente[pensPortf,t] =E= vPensionRenter[t] / (vPensionAkt['Tot',t-1]/fv);
    $(t.val > %NettoFin_t1%).. rOmv[pensPortf,t] =E= vPensionOmv[t] / (vPensionAkt['Tot',t-1]/fv);

    # Aktiver
    $(d1vPensionAkt[portf,t] and t.val >= %NettoFin_t1%)..
      vPensionAkt[portf,t] =E= rPensionAkt[portf,t] * vPensionAkt[portfTot,t];
    $(t.val >= %NettoFin_t1%)..
      vPensionAkt[portfTot,t] =E= vHhAkt[pensPortf,aTot,t] + vUdlAkt[pensPortf,t];

    # Rentestrømme
    $(d1vPensionAkt[portf,t] and t.val > %NettoFin_t1%)..
      vPensionAktRenter[portf,t] =E= (rRente[portf,t] + jrPensionAktRenter[portf,t]) * vPensionAkt[portf,t-1]/fv;
    $(t.val > %NettoFin_t1%).. vPensionRenter[t] =E= sum(portf, vPensionAktRenter[portf,t]);
    $(t.val > %NettoFin_t1%).. jvPensionRenter[t] =E= sum(portf, jrPensionAktRenter[portf,t] * vPensionAkt[portf,t-1]/fv);

    # Omvurderinger
    $(d1vPensionAkt[portf,t] and t.val > %NettoFin_t1%)..
      vPensionAktOmv[portf,t] =E= (rOmv[portf,t] + jrPensionAktOmv[portf,t]) * vPensionAkt[portf,t-1]/fv;
    $(t.val > %NettoFin_t1%).. vPensionOmv[t] =E= sum(portf, vPensionAktOmv[portf,t]);
    $(t.val > %NettoFin_t1%)..
      jvPensionOmv[t] =E= sum(portf, jrPensionAktOmv[portf,t] * vPensionAkt[portf,t-1]/fv);
  $ENDBLOCK

  model M_static / B_finance_static /;
  $GROUP+ G_static G_finance_static;

  $BLOCK B_finance_forwardlooking G_finance_forwardlooking_endo $(tx0[t])
    # Værdi af aktier eksklusiv finansielle aktiver, i.e. værdi af drift (og et residual som fjernes i en kommende version af MAKRO)
    $(tx0E[t]).. vAktieDrift[t] =E= (vFCFE[sTot,t+1] + vAktieDrift[t+1])*fv / (1+rAktieDrift[t+1]);
    &_tEnd[t]$(tEnd[t]).. vAktieDrift[t] =E= (vFCFE[sTot,t] + vAktieDrift[t])*fv / (1+rAktieDrift[t]);

    $(tx0E[t]).. nvFCFF[sp,t] =E= (vFCFF[sp,t+1] + nvFCFF[sp,t+1])*fv / (1+rWACC[sp,t+1]);
    &_tEnd$(tEnd[t]).. nvFCFF[sp,t] =E= (vFCFF[sp,t] + nvFCFF[sp,t])*fv / (1+rWACC[sp,t]);
    .. nvFCFF[sTot,t] =E= sum(sp, nvFCFF[sp,t]);

    $(tx0E[t] and d1K[k,sp,t] and t.val > %NettoFin_t1%)..
      dnvKskat2dvI_s[k,sp,t] =E= fVirkDisk[sp,t+1] 
                                 * (rSkatAfskr[k,t+1] * mtVirk[sp,t+1]
                                    + (1 - rSkatAfskr[k,t+1]) * dnvKskat2dvI_s[k,sp,t+1]
                                    );
    &_tEnd$(tEnd[t] and d1K[k,sp,t])..
      dnvKskat2dvI_s[k,sp,t] =E= mtVirk[sp,t] * rSkatAfskr[k,t] / (rVirkDisk[sp,t] + rSkatAfskr[k,t]);
  $ENDBLOCK

  Model M_finance / B_finance_static, B_finance_forwardlooking /;  
  $GROUP G_finance_endo G_finance_static, G_finance_forwardlooking_endo;

  model M_base / M_finance /;
  $GROUP+ G_Endo G_finance_endo;

$ENDIF

$IF %stage% == "exogenous_values":
# ======================================================================================================================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_finance_makrobk
    rRente, rOmv, vVirkNet, vVirkAkt, vVirkPas, vVirkOmv, vVirkNetRenter, 
    vVirkAktRenter, vVirkPasRenter, vVirkAktOmv, vVirkPasOmv, vPensionAktRenter, vPensionAktOmv
    vAktie, vUdstedelser, vPensionAkt
    rPensionAkt, vVirkK$((sTot[s_] or sp[s_]) and kTot[i_]), vVirkNFE, vDividender
    rRenteECB, rRenteOblDK, rRenteOblEU
    rRenteUSA, rRenteFlex, rRenteFast, rRente3mdr, rRenteOblDKUltimo, rDiskontoen
    vAfskrFradrag$(k[i_] and t.val < 2023), rSkatAfskr, rSkatAfskr0, rKskat, vKskat$(k[i_] and t.val < 2023)
    jvKskat$(k[i_] and sp[s_] and t.val <= 1991)
    ADAM_pension
  ;
  @load(G_finance_makrobk, "../Data/makrobk/makrobk.gdx" )

  # Lånefinanseringsrate for landbruget
  # https://www.statistikbanken.dk/jord2 22.1. Gæld (passiver), ultimo 1000 KR./22. PASSIVER (BALANCE ULTIMO), 1000 kr.
  parameter mrLaan2K_lan_data[t] "Data for lanbrugets gældsfinansieringsandel" 
    /2008 0.49, 2009 0.47, 2010 0.49, 2011 0.53, 2012 0.53, 2013 0.53, 2014 0.53, 2015 0.54, 2016 0.54, 2017 0.53, 2018 0.52, 2019 0.51, 2020 0.49, 2021 0.48, 2022 0.44/;
  mrLaan2K.l[k,'lan',t]$(t.val < 2008) = mrLaan2K_lan_data['2008'];
  mrLaan2K.l[k,'lan',t]$(mrLaan2K_lan_data[t]) = mrLaan2K_lan_data[t];
  mrLaan2K.l[k,'lan',t]$(t.val > 2022) = mrLaan2K_lan_data['2022'];

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_finance_data
    G_finance_makrobk
    mrLaan2K$(k[i_] and lan[s_])
  ;
  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_finance_data_imprecise
    vVirkNet, vVirkNFE, vDividender, vVirkAkt$(Realkred[portf_] and t.val < 2013), 
    vPensionAkt$(portfTot[portf_] and (t.val = 2002 or t.val = 2015 or t.val = 2020)) # Små uoverensstemmelser mellem pensionsformue fra aktivsiden og ift. udland plus hush.
    rSkatAfskr$(iB[k] and t.val >= 2023)
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  # Lånefinansieringsrate
  mrLaan2K.l[k,sp,t]$(not lan[sp]) = 0.4; # Vækstplan DK 2013 FM

  # --------------------------------------------------------------------------------------------------------------------
  # Required rate of return on equity
  # --------------------------------------------------------------------------------------------------------------------
  # We set the firm discount rate on equity to 16% to match a discont rate of around 10.6% based on the supplemantary data from Gormsen and Huber AER 2025 found on https://costofcapital.org/ 
  rVirkDisk.l[sp,t] = 0.16;
  rAktieDrift.l[t] = max(rRenteECB.l[t] - terminal_ECB_rente, 0) + 0.08;

  # --------------------------------------------------------------------------------------------------------------------
  # Finansiel accelerator
  # --------------------------------------------------------------------------------------------------------------------  
  rFinAccel.l[sp] = 0.0; # Matching parameter
  rFinAccel.l['bol'] = 0;
  rFinAccel.l['udv'] = 0;
  rFinAccelTraeghed.l = 0.9;

  # --------------------------------------------------------------------------------------------------------------------
  # Tax depreciation
  # --------------------------------------------------------------------------------------------------------------------
  rSkatAfskr.l['iB',t]$(t.val >= 2023) = 0.03 / 0.04 * rSkatAfskr.l['iB',t-1];

  # --------------------------------------------------------------------------------------------------------------------
  # Realiseringsrate på aktier
  # --------------------------------------------------------------------------------------------------------------------
  rVirkOevrigRealiseringOmv.l[t] = 0.05; # Bør kalibreres, hvis vVirkOevrigRealiseretOmv kan datadækkes
  rVirkAktieFradrag.l[t] = 0.75; # I ADAM er den 0 for dividender og 1 for kursgevinster!
  # Initialværdi for vVirkOevrigUrealiseretOmv i første dataår - steady antagelse går godt da omvurderinger i 1995 har rimeligt niveau
  vVirkOevrigUrealiseretOmv.l[t]$(t.val = %NettoFin_t1%)
    = (vVirkAktOmv.l['IndlAktier',t+1] + vVirkAktOmv.l['UdlAktier',t+1]) / ((1+rVirkOevrigRealiseringOmv.l[t+1]) * fv - 1);

# ======================================================================================================================
# Data assignment
# ======================================================================================================================
  # Initialisering
  vAktieOevrig.l[t] = vVirkNet.l[t] + vAktie.l[t] + sum(k, mrLaan2K.l[k,sTot,t] * vVirkK.l[k,sTot,t]);

  #Set Dummy for firm portfolio
  d1vVirkAkt[portf,t] = yes$(vVirkAkt.l[portf,t] <> 0);
  d1vVirkPas[portf,t] = yes$(vVirkPas.l[portf,t] <> 0);
  d1vPensionAkt[portf,t] = yes$(vPensionAkt.l[portf,t] <> 0);

  d1vVirkAkt['tot',t] = yes$(sum(portf,vVirkAkt.l[portf,t]) <> 0);
  d1vVirkPas['tot',t] = yes$(sum(portf,vVirkPas.l[portf,t]) <> 0);
  d1vPensionAkt['tot',t] = yes$(sum(portf,vPensionAkt.l[portf,t]) <> 0);

  d1vVirkAkt[portf_,t]$(t.val < %NettoFin_t1%) = no;
  d1vVirkPas[portf_,t]$(t.val < %NettoFin_t1%) = no;
  d1vPensionAkt[portf_,t]$(t.val < %NettoFin_t1%) = no;
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_finance_static_calibration
    G_finance_static

    -vAktie[t], vAktieDrift[t]$(t.val >= %NettoFin_t1%)

    -vUdstedelser$(t.val > %NettoFin_t1%), vVirkIndRest$(t.val > %NettoFin_t1%)
    # Aktiver bestemmes af en andelsparameter
    -vVirkAkt[portf,t]$(d1vVirkAkt[portf_,t]), rVirkAkt[portf,t]$(d1vVirkAkt[portf,t])
    # Realkreditlån bestemmes af den marginale realkreditbelåningsgrad for bygningskapital
    -vVirkPas[Realkred,t]$(t.val >= %NettoFin_t1%), mrRealKredLaan2K['iB','tje',t]$(t.val >= %NettoFin_t1%)
    mrRealKredLaan2K['iB',sp,t]$(t.val >= %NettoFin_t1% and not Tje[sp]) # E_mrRealKredLaan2K
    mrRealKredLaan2K[k,sp,t]$(t.val < %NettoFin_t1%) # E_mrRealKredLaan2K_preData
    # Øvrige lån bestemmes af den resterende låneresidual ikke knyttet til investeringer
    -vVirkPas[portf,t]$(not RealKred[portf_] and d1vVirkPas[portf_,t] and not IndlAktier[portf_]), rVirkOevrigPas[portf,t]$(not RealKred[portf_] and d1vVirkPas[portf_,t] and not IndlAktier[portf_])
    # Den marginale bankbelåning tilpasser sig, så den samlede belåning rammer målet (Ændret fra obligationsbelåning, da ikke finansielle virksomheder stort set ikke udsteder obligationer, men har store banklån)
    mrBankLaan2K[k,sp,t], -mrLaan2K[k,sp,t]

    -vVirkAktRenter[portf_,t], jrVirkAktRenter[portf,t]$(t.val > %NettoFin_t1% and  d1vVirkAkt[portf,t])
    -vVirkPasRenter[portf_,t], jrVirkPasRenter[portf,t]$(t.val > %NettoFin_t1% and  d1vVirkPas[portf,t]) 
    -vVirkAktOmv[portf_,t], jrVirkAktOmv[portf,t]$(t.val > %NettoFin_t1% and d1vVirkAkt[portf,t])
    -vVirkPasOmv[portf_,t], jrVirkPasOmv[portf,t]$(t.val > %NettoFin_t1% and d1vVirkPas[portf,t])
    -vPensionAktRenter[portf,t]$(t.val > %NettoFin_t1% and d1vPensionAkt[portf,t]), jrPensionAktRenter[portf,t]$(t.val > %NettoFin_t1% and d1vPensionAkt[portf,t])
    -vPensionAktOmv[portf,t]$(t.val > %NettoFin_t1% and d1vPensionAkt[portf,t]), jrPensionAktOmv[portf,t]$(t.val > %NettoFin_t1% and d1vPensionAkt[portf,t])

    -rRente[Bank,t], crRenteBank$(t.val >= 1985)
    -rRenteFlex, crRenteFlex
    -rRenteFast, crRenteFast
    -rRenteOblEU, rOblPrem
    -rRenteOblDK, rRenteSpaend$(t.val >= 1985)
    -rRente[Obl,t], crRenteObl$(t.val >= 1985)
    -rRente[RealKred,t], crRenteRealKred$(t.val >= 2001)
    vFCFExRefRest, -vFCFExRef
    uFinAccel # E_uFinAccel
    rAktieDriftPrem[t], -rAktieDrift[t] # E_rAktieDrift_t1
    rVirkDiskPrem[sp,t], -rVirkDisk[sp,t] # E_rVirkDisk_sp_t1
    jvKskat[k,sp,t]$(t.val = 2023) # E_jvKskat
    dnvKskat2dvI_s[k,sp,t]$(d1K[k,sp,t] and t.val > %NettoFin_t1%) # dnvKskat2dvI_s_static
  ;
  $GROUP G_finance_static_calibration
    G_finance_static_calibration$(tx0[t])
    vVirkDriftPas[kTot,s_,t0]
    vVirkDriftPas[k,s_,t0]
  ;
  $BLOCK B_finance_static_calibration 
    E_uFinAccel[sp,t]$(tx0[t]).. uFinAccel[sp,t] =E= 500 / vVirkK[kTot,sp,t];

    E_mrRealKredLaan2K_iB[sp,t]$(tx0[t] and t.val >= %NettoFin_t1% and not Tje[sp])..
      rRealKredLaan2Laan['iB',sp,t] =E= rRealKredLaan2Laan['iB','Tje',t];

    E_mrRealKredLaan2K_preData[k,sp,t]$(tx0[t] and t.val < %NettoFin_t1%).. 
      rRealKredLaan2Laan[k,sp,t] =E= rRealKredLaan2Laan[k,sp,'%NettoFin_t1%'];

    # Kapital efter 2023 beskattes med den nye sats, mens kapitalapparat før 2023 beskattes med den gamle sats
    # Vi korrigerer kapitalapparatet fra før 2023, så det effektivt beskattes med den gamle sats
    E_jvKskat[k,sp,t]$(t.val = 2023 and tx0[t]).. 
      jvKskat[k,sp,t] =E= (vKskat[k,sp,t-1]/fv - vAfskrFradrag[k,sp,t]) * (rSkatAfskr[k,t] / rSkatAfskr[k,t-1] - 1); 

    E_dnvKskat2dvI_s_static[k,sp,t]$(d1K[k,sp,t] and t.val > %NettoFin_t1%)..
      dnvKskat2dvI_s[k,sp,t] =E= mtVirk[sp,t] * rSkatAfskr[k,t] / (rVirkDisk[sp,t] + rSkatAfskr[k,t]);

    @copy_equation_to_period(E_vVirkDriftPas_k_sp, t0)
    @copy_equation_to_period(E_vVirkDriftPas_k_sTot, t0)
    @copy_equation_to_period(E_vVirkDriftPas_kTot_s_, t0)
    @copy_equation_to_period(E_rVirkDisk_sp, t1);
    @copy_equation_to_period(E_rAktieDrift, t1);
  $ENDBLOCK
  MODEL M_finance_static_calibration /
    B_finance_static
    B_finance_static_calibration
  /;
  model M_static_calibration / M_finance_static_calibration /;
  $GROUP+ G_static_calibration G_finance_static_calibration;

  $GROUP G_finance_static_calibration_newdata
    G_finance_static_calibration
   ;
  $GROUP+ G_static_calibration_newdata G_finance_static_calibration_newdata;
$ENDIF

# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_finance_deep
    G_finance_endo
   
    vFCFExRefRest, -vFCFExRef
    uFinAccel # E_uFinAccel
    rOmv['UdlAktier',tx1], -rAfk['UdlAktier',tx1]

    -rRente['Obl',tx1], rOblPrem[tx1]

    -vAktie[t1], rAktieDriftPrem[t2]
    rAktieDriftPrem[t]$(t.val > t2.val), -rAfk['IndlAktier',tEnd] # E_rAktieDriftPrem

    -rVirkDisk[sp,tx1], rVirkDiskPrem[sp,tx1]

    -rVirkIndRest[t], vVirkIndRest[t]
  ;
  $GROUP G_finance_deep G_finance_deep$(tx0[t]);

  $BLOCK B_finance_deep  
    E_rAktieDriftPrem[t]$(t2.val < t.val and t.val < tEnd.val)..
      rAfk['IndlAktier',t] =E= 0.7 * rAfk['IndlAktier',t-1] + 0.3 * rAfk['IndlAktier',tEnd];
  $ENDBLOCK
  MODEL M_finance_deep /
    M_finance
    B_finance_deep
    E_uFinAccel
  /;
  model M_deep_dynamic_calibration / M_finance_deep /;
  $GROUP+ G_deep_dynamic_calibration G_finance_deep;
$ENDIF

# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
  $GROUP G_finance_dynamic_calibration
    G_finance_endo
    vFCFExRefRest, -vFCFExRef
    rOblPrem[tx1]
    rRenteECB[tx1]
    -vAktie[t1], rAktieDriftPrem[t2]
    rAktieDriftPrem[t]$(t.val > t2.val), -rAfk['IndlAktier',tEnd] # E_rAktieDriftPrem
    rVirkDiskPrem[sp,t], -rVirkDisk[sp,t]
    rOmv['UdlAktier',tx1], -rAfk['UdlAktier',tx1]
    mrLaan2K[k,sp,tx1]
  ;
  $BLOCK B_finance_dynamic_calibration
    # Obligations-rente og ECB-rente kører gradvist fra sidste data-år til eksogen terminal-rente
    E_rOblPrem[t]$(tx1[t] and t.val <= 2050).. 
      rRente['Obl',t] =E= terminal_rente + (1 - dt[t]/dt['2050'])**2 * (rRente['Obl',t1] - terminal_rente);
    E_rOblPrem_terminal[t]$(tx1[t] and t.val > 2050)..  rRente['Obl',t] =E= terminal_rente;
    E_rRenteECB[t]$(tx1[t] and t.val <= 2050).. 
      rRenteECB[t] =E= terminal_ECB_rente + (1 - dt[t]/dt['2050'])**2 * (rRenteECB[t1] - terminal_ECB_rente);
    E_rRenteECB_terminal[t]$(tx1[t] and t.val > 2050)..  rRenteECB[t] =E= terminal_ECB_rente;

    E_rAktieDriftPrem[t]$(t2.val < t.val and t.val < tEnd.val)..
      rAfk['IndlAktier',t] =E= 0.7 * rAfk['IndlAktier',t-1] + 0.3 * rAfk['IndlAktier',tEnd];
  $ENDBLOCK
  MODEL M_finance_dynamic_calibration /
    M_finance
    B_finance_dynamic_calibration
  /;
  model M_dynamic_calibration_newdata / M_finance_dynamic_calibration /;
  $GROUP+ G_dynamic_calibration_newdata G_finance_dynamic_calibration;
$ENDIF

