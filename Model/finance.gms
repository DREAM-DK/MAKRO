# ======================================================================================================================
# Finance
# - Firm financing and valuation
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_finance_endo
    vAktie[t]$(t.val >= %NettoFin_t1%) "Aktier og andre ejerandelsbeviser, kursværdi, Kilde: ADAM[Ws_cr_z]+ADAM[Ws_cf_z]"
    vAktieDrift[t] "Nutidsværdi af frie pengestrømme til egenkapital ekskl. finansielle aktiver og passiver, diskonteret med rAktieDrift."
    nvFCFF[s_,t] "Nutidsværdi af frie pengestrømme til virksomheden ekskl. finansielle aktiver og passiver, diskonteret med rWACC."

    vEBT[s_,t] "Earnings before taxes - fortjeneste før beskatning."
    vEBTDrift[s_,t] "Earnings before taxes - fortjeneste før beskatning - alene den del der hører til driften uden afkast."
    vEBITDA[s_,t] "Earnings before interests, taxes, depreciation, and amortization - fortjeneste før renter, skatter og afskrivninger."
    vFCFF[s_,t]$(t.val > %NettoFin_t1%) "Frie pengestrømme til virksomhed (Free cash flow to Firm) ekskl. fra finansiel portefølje."
    vFCFE[s_,t] "Frie pengestrømme til egenkapital (Free cash flow to equity) ekskl. fra finansiel portefølje."

    vVirkNetRenter[t]$(t.val > %NettoFin_t1%) "Samlet nettoformueindkomst for finansielle og ikke-finansielle selskaber, Kilde: ADAM[Tin_cr]+ADAM[Tin_cf]"
    vVirkAktRenter[portf_,t]$(t.val > %NettoFin_t1% and d1vVirkAkt[portf_,t] and portf[portf_]) "Samlet formueindkomst fra aktiver for finansielle og ikke-finansielle selskaber"
    vVirkPasRenter[portf_,t]$(t.val > %NettoFin_t1% and d1vVirkPas[portf_,t] and portf[portf_]) "Samlet rente- og dividendeudskrivninger for finansielle og ikke-finansielle selskaber"

    vVirkOmv[t]$(t.val > %NettoFin_t1%) "Samlede omvurderinger af finansielle og ikke-finansielle selskabers nettoformue, Kilde: ADAM[Wn_cr]+ADAM[Wn_cf]-ADAM[Wn_cr][-1]-ADAM[Wn_cf][-1]-ADAM[Tfn_cr]-ADAM[Tfn_cf]"
    vVirkAktOmv[portf_,t]$(t.val > %NettoFin_t1% and d1vVirkAkt[portf_,t] and portf[portf_]) "Omvurderinger på selskabernes finansielle aktiver"
    vVirkPasOmv[portf_,t]$(t.val > %NettoFin_t1% and d1vVirkPas[portf_,t] and portf[portf_]) "Omvurderinger på selskabernes finansielle passiver"
    jvVirkOmv[t]$(t.val > %NettoFin_t1%) "Aggregeret J-led"

    vVirkNFE[t]$(t.val > %NettoFin_t1%) "Samlet nettofordringserhvervelse for finansielle og ikke-finansielle selskaber, Kilde: ADAM[Tfn_cr]+ADAM[Tfn-Cf]"

    vKskat[i_,s_,t]$((k[i_] or kTot[i_]) and (sp[s_] or sTot[s_]) and d1k[i_,s_,t]) "Bogført værdi af kapitalapparat fordelt på brancher."
    vAfskrFradrag[i_,s_,t]$((k[i_] or kTot[i_]) and (sp[s_] or sTot[s_]) and d1k[i_,s_,t]) "Skatte-fradrag for kapitalafskrivninger."
    dnvAfskrFradrag2dvI_s[k,s_,t]$(sp[s_] and t.val > %NettoFin_t1%) "Den afledte af nutidsværdien af afskrivningsfradraget knyttet til investeringer."
    dnvKskat2dvI_s[k,s_,t]$(sp[s_] and t.val > %NettoFin_t1%) "Den afledte af nutidsværdien af skattemæssigt kapital knyttet til investeringer."
    vDividender[t]$(t.val > %NettoFin_t1%) "Samlede udbytter af aktier og ejerandelsbeviser udbetalt af indenlandske selskaber, Kilde: ADAM[Tiu_cr_z]+ADAM[Tiu_cf_z]"
    vUdstedelser[t]$(t.val > %NettoFin_t1%) "Nettoudstedelser af aktier fra indenlandske selskaber, Kilde: ADAM[Tfs_cr_z]+ADAM[Tfs_cf_z]"
    rVirkIndRest[t] "Parameter for rest-led i virksomheden indtjening."

    vVirkK[i_,s_,t]$(sTot[s_] or sp[s_]) "Værdi af kapitalbeholdningen til investeringspris ekskl. husholdningernes boligkapital."

    vVirkAkt[portf_,t]$((portf[portf_] or portfTot[portf_]) and d1vVirkAkt[portf_,t]) "Virksomhedernes finansielle aktiver, Kilde: jf. portfolio set."
    vVirkPas[portf_,t]$((portf[portf_] or portfTot[portf_]) and d1vVirkPas[portf_,t]) "Virksomhedernes finansielle passiver, Kilde: jf. portfolio set."
    vVirkNet[t] "Virksomhedernes finansielle nettoportefølje, Kilde: jf. portfolio set."
    vVirkLaan[i_,s_,t]$(k[i_] or kTot[i_]) "Lån til gældsfinansierede investeringer."
    vAktieFin[t]$(t.val >= %NettoFin_t1%) "Samlet værdi af virksomhedernes finansielle nettoaktiver ikke knyttet til investeringer og virksomhedsdriftd"

    rVirkAkt[portf,t]$(Guld[portf] and tForecast[t]) "Virksomhedens finansielle aktiver, som andel af virksomhedens værdi ekskl. finansielle aktiver og residual."

    vPensionAkt[portf_,t]$(t.val >= %NettoFin_t1% and d1vPensionAkt[portf_,t]) "Porteføljen af pensionsformuen."
    vPensionAktRenter[portf_,t]$(t.val > %NettoFin_t1% and d1vPensionAkt[portf_,t] and portf[portf_]) "Formueindkomst fra pensionsaktiver"
    vPensionRenter[t]$(t.val > %NettoFin_t1%) "Formueindkomst fra pensionsaktiver"
    jvPensionRenter[t]$(t.val > %NettoFin_t1%) "Aggregeret J-led"
    vPensionAktOmv[portf_,t]$(t.val > %NettoFin_t1% and d1vPensionAkt[portf_,t] and portf[portf_]) "Omvurderinger på pensionsformuen"
    vPensionOmv[t]$(t.val > %NettoFin_t1%) "Omvurderinger på pensionsformuen"
    jvPensionOmv[t]$(t.val > %NettoFin_t1%) "Aggregeret J-led"

    vtSelskabDrift[s_,t] "Den del af selskabsskatten der hører til driften."

    vVirkFinInd[t] "Samlet afkast (omvurderinger + renter) på virksomhedens portefølje."

    vVirkUrealiseretAktieOmv[t]$(t.val > %NettoFin_t1%) "Skøn over virksomheders realiserede gevinst ved salg af aktier."
    vVirkRealiseretAktieOmv[t]$(t.val > %NettoFin_t1%) "Skøn over virksomhedernes endnu ikke realiserede kapitalgevinster på aktier."
    vFCFExRef[sp,t]$(t.val > %AgeData_t1%) "vFCFE eksklusiv reference-pengestrøm."

    rVirkDisk[s_,t]$((sp[s_] or spTot[s_]) and tx1[t]) "Selskabernes diskonteringsrate."
    rVirkDiskPrem[s_,t]$(spTot[s_] and tx1[t]) "Risikopræmie i diskonteringsraten for virksomhedens beslutningstagere."
    fVirkDisk[s_,t]$(sp[s_] and tx1[t]) "Selskabernes diskonteringsrate."
    rWACC[s_,t]$(sp[s_]) "Weighed average cost of capital."
    mrLaan2K[i_,s_,t]$(kTot[i_] and sp[s_]) "Marginal gældsfinansieringsandel for investeringer."
    mrLaan2K[i_,s_,t]$((k[i_] or kTot[i_]) and sTot[s_]) "Marginal gældsfinansieringsandel for investeringer."
    rAktieDrift[t]$(tx1[t]) "Investorernes forventede afkast på vAktieDrift. I fravær af stød er den lig afkastet på vAktieDrift."
    rAktieFinAfk[t]$(t.val > %NettoFin_t1%) "Afkastrate på virksomhedernes finansielle aktiver."
    rRente[portf_,t]$((pensTot[portf_] and t.val > %NettoFin_t1%) or (Bank[portf_] and t.val >= 1985) or (Obl[portf_] and t.val >= 1985) or (RealKred[portf_] and t.val >= 2001)) "Renter og dividender på finansiel portefølje."
    rOmv[portf_,t]$((IndlAktier[portf_] or pensTot[portf_]) and t.val > %NettoFin_t1%) "Omvurderinger på finansiel portefølje."
    rAfk[portf,t]$(t.val > %NettoFin_t1%) "Sum af omvurderinger og renter på finansielt aktiv eller passiv."
    rFinAccelPrem[s_,t]$((sp[s_] or spTot[s_]) and tx1[t] and t.val > %AgeData_t1% + 1) "Ændring i risikopræmie fra finansiel friktion."
    dFinFriktion[sp,t]$(tx1[t]) "Afledt af finansiel friktion ift. fri pengestrøm."
    rRenteOblEU[t] "EU effektive rente af langfristede obligationer. Kilde: ADAM[iwbeu]"
    rRenteOblDK[t]$(t.val >= 1985) "Effektiv rente på 10-årig statsobligation (stående lån), årsgennemsnit. Kilde: ADAM[iwbos]"
    rRenteFlex[t] "Flexlånerente. Kilde: ADAM[iwbflx]"
    rRenteFast[t] "30-årig byggeobligation. Kilde: ADAM[iwb30]"
    mrRenteVirkLaan[i_,t]$(k[i_]) "Gennemsnitlig marginalrente til virksomhedsinvesteringer (imputeret)"
  ;
  $GROUP G_finance_endo G_finance_endo$(tx0[t]);  # Restrict endo group to tx0[t]

  $GROUP G_finance_exogenous_forecast
    rRenteECB[t] "ECB-renten. Kilde: ADAM[iweu]"
    rOblPrem[t] "Risikopræmie på obligationer ift. pengemarkedsrente."
    rVirkDisk[s_,t]$(s[s_])
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
  $GROUP G_finance_forecast_as_zero
    jrPensionAktRenter[portf_,t] "J-led."
    jrPensionAktOmv[portf_,t] "J-led."
    jrOmv_IndlAktier[t] "J-led - alene nødvendigt pga. databrud i 2016"

    jrVirkAktRenter[portf_,t] "J-led som dækker forskel mellem selskabernes og den gennemsnitlige rente på aktivet/passivet."
    jrVirkPasRenter[portf_,t] "J-led som dækker forskel mellem selskabernes og den gennemsnitlige rente på aktivet/passivet."
    jrVirkAktOmv[portf_,t] "J-led som dækker forskel mellem selskabernes og den gennemsnitlige omvurdering på aktivet/passivet."
    jrVirkPasOmv[portf_,t] "J-led som dækker forskel mellem selskabernes og den gennemsnitlige omvurdering på aktivet/passivet."

    jvKskat[i_,s_,t] "J-led."

    rOmv[portf,t]$(Obl[portf] or Bank[portf] or RealKred[portf])

    rRenteSpaend[t] "Forskel på renten på danske statsobligationer og obligationer ustedt af ECB" 
  ;
  $GROUP G_finance_ARIMA_forecast
    mrLaan2K_portf[i_,portf,t] "Marginal gældsfinansieringsandel for investeringer fordelt på porteføljeelementer."
    rRente$(IndlAktier[portf_] or UdlAktier[portf_])
    crRenteObl[t] "Forskel på gennemsnitlig obligationsrente og statsobligationsrente"
    crRenteBank[t] "Forskel på ECBs og Danmarks pengemarkedsrente."
    crRenteFlex[t] "Forskel på renten på flexlån og gns. obligationer"
    crRenteFast[t] "Forskel på renten på 30-årige realkreditlån og gns. obligationer"
    crRenteRealKred[t] "Forskel på gns. rente på realkreditlån og vægtet gns. af flex og fast forrentet"
    rVirkIndRest[t] "Parameter for rest-led i virksomheden indtjening."
  ;
  $GROUP G_finance_constants
    rFinAccelTraeghed "Træghed i opdatering af reference-profit for finansiel friktion. Styrer persistens i finansiel friktion."
    rFinAccel[sp] "Straf-rente fra finansielle friktioner på overskydende (manglende) fri pengestrømme."
  ;
  $GROUP G_finance_fixed_forecast
    mrLaan2K[k,s,t]
    vFCFExRef[sp,t]$(byg[sp] or lan[sp] or bol[sp] or ene[sp] or udv[sp])
    rKskat[k,t] "Andel af investering er fradragsberettiget."
    rSkatAfskr[k,t] "Skattemæssig afskrivningsrate."
    rSkatAfskr0[k,t] "Skattemæssig straksafskrivningsrate."
    rPensionAkt[portf_,t]$(UdlAktier[portf_] or RealKred[portf_]) "Andel af aktiver ud af samlede aktiver."
    rVirkRealiseringAktieOmv[t] "Andel af omvurderinger på virksomheders aktier som realiseres hvert år."
    rVirkAktieFradrag[t] "Virksomheders aktie fradrag"
    rVirkPasRest[portf_,t] "Fast del af obligationsgæld ikke direkte knyttet til investeringer, som andel af virksomhedens værdi ekskl. finansielle aktiver og residual."
    rVirkAkt[portf,t]$(not Guld[portf]) "Virksomhedens finansielle aktiver, som andel af virksomhedens værdi ekskl. finansielle aktiver og residual."
    rOmv[Guld,t]
  ;
$ENDIF

# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_finance_static$(tx0[t])
    # Virksomhedens diskonteringsrate for egenkapital
    E_rVirkDisk[sp,t]$(tx1[t]).. rVirkDisk[sp,t] =E= rRenteECB[t] + rVirkDiskPrem[sp,t] + rFinAccelPrem[sp,t];

    E_rVirkDisk_spTot[t]$(tx1[t]).. rVirkDisk[spTot,t] =E= rRenteECB[t] + rVirkDiskPrem[spTot,t] + rFinAccelPrem[spTot,t];

    E_rVirkDiskPrem_spTot[t]$(tx1[t]).. 
      rVirkDiskPrem[spTot,t] * vVirkK[kTot,sTot,t] =E= sum(sp, rVirkDiskPrem[sp,t] * vVirkK[kTot,sp,t]);

    # Virksomhedernes diskonteringsfaktor for egenkapital
    E_fVirkDisk[sp,t]$(tx1[t]).. fVirkDisk[sp,t] =E= 1 / (1 + rVirkDisk[sp,t]);

    # Finansiel friktion
    E_rFinAccelPrem[sp,t]$(tx1[t] and t.val > %AgeData_t1% + 1)..
      rFinAccelPrem[sp,t] =E= (1 + rRenteECB[t] + rVirkDiskPrem[sp,t]) * ((1 - dFinFriktion[sp,t-1]) / (1 - dFinFriktion[sp,t]) - 1);

    E_dFinFriktion[sp,t]$(tx1[t] and t.val > %AgeData_t1%)..
      dFinFriktion[sp,t] =E= rFinAccel[sp] * tanh(uFinAccel[sp,t] * vFCFExRef[sp,t]);

    E_rFinAccelPrem_spTot[t]$(tx1[t] and t.val > %AgeData_t1% + 1)..
      rFinAccelPrem[spTot,t] * vVirkK[kTot,sTot,t] =E= sum(sp, rFinAccelPrem[sp,t] * vVirkK[kTot,sp,t]);

    E_vFCFExRef[sp,t]$(t.val > %AgeData_t1%)..
      vFCFExRef[sp,t] =E= rFinAccelTraeghed * (vFCFE[sp,t] - vFCFE[sp,t-1] + vFCFExRef[sp,t-1]) + vFCFExRefRest[sp,t]; # /fv udeladt

    # Samlet værdi af ejenkapital i danske virksomheder - alle virksomheder antages at være aktieselskaber
    E_vAktie[t]$(t.val >= %NettoFin_t1%)..
      vAktie[t] =E= vAktieDrift[t] + vAktieFin[t];

    E_rAktieDrift[t]$(tx1[t]).. rAktieDrift[t] =E= rRenteECB[t] + rAktieDriftPrem[t];

	  # Gennemsnitlige kapitalomkostninger vægtet ud fra bogført gældskvote-målsætning
    E_rWACC[sp,t]$(t.val > %NettoFin_t1%)..
      rWACC[sp,t] =E= sum(k, mrRenteVirkLaan[k,t] * mrLaan2K[k,sp,t] * vVirkK[k,sp,t] / vVirkK[kTot,sp,t]) * (1 - tSelskab[t] * ftSelskab[t])
                    + (1 - sum(k, mrLaan2K[k,sp,t] * vVirkK[k,sp,t] / vVirkK[kTot,sp,t])) * rVirkDisk[sp,t];

    # Finansielle aktiver og passiver følger virksomhedens værdi eksklusiv finansielle aktier og passiver
    E_vVirkAkt[portf,t]$(d1vVirkAkt[portf,t])..
      vVirkAkt[portf,t] =E= rVirkAkt[portf,t] * vAktieDrift[t];

    E_vVirkPas[portf,t]$(d1vVirkPas[portf,t] and not IndlAktier[portf])..
      vVirkPas[portf,t] =E= sum(k, mrLaan2K_portf[k,portf,t] * vVirkK[k,sTot,t]) 
                          + rVirkPasRest[portf,t]$(not Realkred[portf]) * vAktieDrift[t];
  
    E_vVirkPas_IndlAktier[t]$(d1vVirkPas['IndlAktier',t])..
      vVirkPas['IndlAktier',t] =E= vAktie[t];

    E_vVirkAkt_tot[t]$(d1vVirkAkt['tot',t])..
      vVirkAkt['tot',t] =E= sum(portf, vVirkAkt[portf,t]);

    E_vVirkPas_tot[t]$(d1vVirkPas['tot',t])..
      vVirkPas['tot',t] =E= sum(portf, vVirkPas[portf,t]);

    E_vVirkNet[t]..
      vVirkNet[t] =E= vVirkAkt['tot',t] - vVirkPas['tot',t];

    E_vAktieFin[t]$(t.val >= %NettoFin_t1%)..
      vAktieFin[t] =E= vVirkNet[t] + vVirkLaan[kTot,sTot,t] + vAktie[t];

    # Vi antager nul handel af monetært guld i fremskrivningen
    E_rVirkAkt_Guld[t]$(tForecast[t])..
      vVirkAkt['Guld',t] =E= (1+rOmv['Guld',t]) * vVirkAkt['Guld',t-1]/fv;

    # Omvurderinger på aktier - bemærk at udstedelser øger vAktie 1-til-1 og derfor ikke påvirker omvurderinger
    E_rOmv_IndlAktier[t]$(t.val > %NettoFin_t1%)..
      rOmv['IndlAktier',t] =E= (vAktie[t] - vUdstedelser[t]) / (vAktie[t-1]/fv) - 1;

    # Dividender på indenlandske aktier
    E_vDividender[t]$(t.val > %NettoFin_t1%).. vDividender[t] =E= rRente['IndlAktier',t] * vAktie[t-1]/fv;

    # Budget-begrænsning
    # Udstedelser bestemmes residualt for at ramme en eksogen dividende-rate
    E_vUdstedelser[t]$(t.val > %NettoFin_t1%)..
      vAktieFin[t] =E= (1+rAktieFinAfk[t]) * vAktieFin[t-1]/fv - (vtSelskab[sTot,t] - vtSelskabDrift[sTot,t])
                     + vFCFE[sTot,t]
                     - vDividender[t]
                     + vUdstedelser[t];
    
    E_rVirkIndRest[t]$(t.val > %NettoFin_t1%)..
      vVirkIndRest[t] =E= rVirkIndRest[t] * vI_s['iM',spTot,t];

    # Frie pengestrømme til virksomhed (Free Cash Flow to Firm) ekskl. fra finansiel fra portefølje
    E_vFCFF_sTot[t]$(t.val > %NettoFin_t1%)..
      vFCFF[sTot,t] =E= vEBITDA[sTot,t]                        
                      - vI_s[iTot,spTot,t] + vHhInvestx[aTot,t] + vIBolig[t]
                      - vtSelskabDrift[sTot,t]                           
                      # Nettooverførsler til virksomhederne
                      + vOffLandKoeb[t]
                      - vSelvstKapInd[aTot,t]
                      + vOffTilVirk[t] - vOffFraVirk[t]        
                      - vHhFraVirk[t]
                      + vVirkIndRest[t];                       

    E_vFCFF[sp,t]$(t.val > %NettoFin_t1%)..
      vFCFF[sp,t] =E= vEBITDA[sp,t]                        
                    - vI_s[iTot,sp,t] + vHhInvestx[aTot,t] * vI_s[iTot,sp,t] / vI_s[iTot,spTot,t] + bol[sp] * vIBolig[t]
                    - vtSelskabDrift[sp,t]
                    # Nettooverførsler til virksomhederne
                    + (vOffLandKoeb[t]
                    - vSelvstKapInd[aTot,t]
                    + vOffTilVirk[t] - vOffFraVirk[t]        
                    - vHhFraVirk[t]
                    + vVirkIndRest[t]) * vVirkK[kTot,sp,t] / vVirkK[kTot,sTot,t];                       

    # Frie pengestrømme til egenkapital (Free Cash Flow to Equity) ekskl. fra finansiel fra portefølje
    E_vFCFE_sTot[t]$(t.val > %NettoFin_t1%)..
      vFCFE[sTot,t] =E= vFCFF[sTot,t]                        
                      - sum(k, mrRenteVirkLaan[k,t] * vVirkLaan[k,sTot,t-1]/fv)
                      + vVirkLaan[kTot,sTot,t] - vVirkLaan[kTot,sTot,t-1]/fv;

    E_vFCFE[sp,t]$(t.val > %NettoFin_t1%)..
      vFCFE[sp,t] =E= vFCFF[sp,t]                        
                   - sum(k, mrRenteVirkLaan[k,t] * vVirkLaan[k,sp,t-1]/fv)
                   + vVirkLaan[kTot,sp,t] - vVirkLaan[kTot,sp,t-1]/fv;

    # Earnings before interests, corporate taxes, and depreciation. Payroll taxes are included in both vtNetY and vL, and are added back.
    E_vEBITDA[sp,t]..
      vEBITDA[sp,t] =E= vY[sp,t] - vLoensum[sp,t] - vSelvstLoen[sp,t] - vR[sp,t] - vE[sp,t] - vtNetY[sp,t] 
                      - vLejeAfEjerBolig[t]$(bol[sp]); # Lejeværdi af egen bolig trækkes fra, da det går til husejerne
    E_vEBITDA_tot[t].. vEBITDA[sTot,t] =E= sum(sp, vEBITDA[sp,t]);

    # Earnings before taxes
    E_vEBT_sTot[t].. vEBT[sTot,t] =E= vEBITDA[sTot,t] - vAfskrFradrag[kTot,sTot,t]
                                      + sum(portf$(not IndlAktier[portf] and not UdlAktier[portf]), vVirkAktRenter[portf,t]) 
                                      - sum(portf$(not IndlAktier[portf] and not UdlAktier[portf]), vVirkPasRenter[portf,t]) 
                                      + (1-rVirkAktieFradrag[t]) 
                                        * (vVirkAktRenter['IndlAktier',t] + vVirkAktRenter['UdlAktier',t] + vVirkRealiseretAktieOmv[t]); 

    E_vEBT[sp,t].. vEBT[sp,t] =E= vEBITDA[sp,t] - vAfskrFradrag[kTot,sp,t]
                                  + (  sum(portf$(not IndlAktier[portf] and not UdlAktier[portf]), vVirkAktRenter[portf,t]) 
                                     - sum(portf$(not IndlAktier[portf] and not UdlAktier[portf]), vVirkPasRenter[portf,t]) 
                                      + (1-rVirkAktieFradrag[t]) 
                                        * (vVirkAktRenter['IndlAktier',t] + vVirkAktRenter['UdlAktier',t] + vVirkRealiseretAktieOmv[t])
                                      ) * vVirkK[kTot,sp,t] / vVirkK[kTot,sTot,t]; 

    # Earnings before taxes ekskl. afkast på portefølje
    E_vEBTDrift_sTot[t]..
      vEBTDrift[sTot,t] =E= vEBITDA[sTot,t] - vAfskrFradrag[kTot,sTot,t] -  sum(k, mrRenteVirkLaan[k,t] * vVirkLaan[k,sTot,t-1]/fv);

    E_vEBTDrift[sp,t]..
      vEBTDrift[sp,t] =E= vEBITDA[sp,t] - vAfskrFradrag[kTot,sp,t] - sum(k, mrRenteVirkLaan[k,t] * vVirkLaan[k,sp,t-1]/fv);

    # Den del af selskabsskat der hører til driften
    E_vtSelskabDrift_sTot[t]$(t.val > %NettoFin_t1%)..
      vtSelskabDrift[sTot,t] =E= tSelskab[t] * ftSelskab[t] * vEBTDrift[sTot,t] + vtSelskabRest[sTot,t];
    E_vtSelskabDrift[sp,t]$(t.val > %NettoFin_t1%)..
      vtSelskabDrift[sp,t] =E= tSelskab[t] * ftSelskab[t] * vEBTDrift[sp,t] + vtSelskabRest[sp,t];

    # Tax book value of firm shares
    E_vKskat[k,sp,t]$(d1k[k,sp,t])..
      vKskat[k,sp,t] =E= vKskat[k,sp,t-1]/fv - vAfskrFradrag[k,sp,t] + rKskat[k,t] * (vI_s[k,sp,t] - bol[sp] * vIBolig[t]) + jvKskat[k,sp,t];

    E_vKskat_sTot[k,t].. vKskat[k,sTot,t] =E= sum(sp, vKskat[k,sp,t]);
#    E_vKskat_sTot[k,t]$(d1k[k,spTot,t])..
#      vKskat[k,spTot,t] =E= vKskat[k,sTot,t-1]/fv - vAfskrFradrag[k,sTot,t] + vI_s[k,spTot,t] - vIBolig[t]
#                     + ((vKskat[k,sTot,t-1]/fv - vAfskrFradrag[k,sTot,t]) * (rSkatAfskr[k,t] / rSkatAfskr[k,t-1] - 1))$(t.val = 2023); # Jf. kommentar ovenfor!
    E_vKskat_kTot[sp,t].. vKskat[kTot,sp,t] =E= sum(k, vKskat[k,sp,t]);
    E_vKskat_kTot_sTot[t].. vKskat[kTot,sTot,t] =E= sum(sp, vKskat[kTot,sp,t]);

    E_vAfskrFradrag[k,sp,t]$(d1k[k,sp,t]).. 
      vAfskrFradrag[k,sp,t] =E= rSkatAfskr0[k,t] * (vI_s[k,sp,t] - bol[sp] * vIBolig[t]) 
                              + rSkatAfskr[k,t] * vKskat[k,sp,t-1]/fv;
    E_vAfskrFradrag_sTot[k,t].. vAfskrFradrag[k,sTot,t] =E= sum(sp, vAfskrFradrag[k,sp,t]);
    E_vAfskrFradrag_kTot[sp,t].. vAfskrFradrag[kTot,sp,t] =E= sum(k, vAfskrFradrag[k,sp,t]);
    E_vAfskrFradrag_kTot_sTot[t].. vAfskrFradrag[kTot,sTot,t] =E= sum(sp, vAfskrFradrag[kTot,sp,t]);

    E_mrRenteVirkLaan[k,t].. 
      mrRenteVirkLaan[k,t] =E= (mrLaan2K_portf[k,'Bank',t] / mrLaan2K[k,sTot,t]
                                * (rRente['Bank',t] + jrVirkPasRenter['Bank',t])) +
                               (mrLaan2K_portf[k,'RealKred',t]$(not iM[k] and t.val >= %NettoFin_t1%) / mrLaan2K[k,sTot,t] 
                                * (rRente['RealKred',t] + jrVirkPasRenter['RealKred',t]));

    E_mrLaan2K_kTot[sp,t].. 
      mrLaan2K[kTot,sp,t] * vVirkK[kTot,sp,t] =E= sum(k, mrLaan2K[k,sp,t] * vVirkK[k,sp,t]);
    
    E_mrLaan2K_sTot[k_,t]..
      mrLaan2K[k_,sTot,t] * vVirkK[k_,sTot,t] =E= sum(sp, mrLaan2K[k_,sp,t] * vVirkK[k_,sp,t]);

    # Værdi af virksomhedens kapital til genanskaffelsespris
    E_vVirkK[k,sp,t]$(not (bol[sp] and iB[k])).. vVirkK[k,sp,t] =E= pI_s[k,sp,t] * qK[k,sp,t];

    E_vVirkK_bol[t]..
      vVirkK['iB','bol',t] =E= pI_s['iB','bol',t] * qK['iB','bol',t] - pI_s['iB','bol',t] * qKBolig[t];

    E_vVirkK_k_sTot[k,t]..
      vVirkK[k,sTot,t] =E= sum(sp, vVirkK[k,sp,t]);

    E_vVirkK_kTot[sp,t].. vVirkK[kTot,sp,t] =E= sum(k, vVirkK[k,sp,t]);

    E_vVirkK_kTot_sTot[t]..
      vVirkK[kTot,sTot,t] =E= sum(sp, vVirkK[kTot,sp,t]);

    # Gæld knyttet til kapitalapparat
    E_vVirkLaan_sTot[k,t]..
      vVirkLaan[k,sTot,t] =E= mrLaan2K[k,sTot,t] * vVirkK[k,sTot,t];

    E_vVirkLaan[k,sp,t]..
      vVirkLaan[k,sp,t] =E= mrLaan2K[k,sp,t] * vVirkK[k,sp,t];

    E_vVirkLaan_kTot[s_,t]$((sp[s_] or sTot[s_]))..
      vVirkLaan[kTot,s_,t] =E= sum(k, vVirkLaan[k,s_,t]);

    # Netto renteudgifter (afkast) på virksomhedens portefølje
    E_vVirkFinInd[t].. 
      vVirkFinInd[t] =E= vVirkNetRenter[t] + vDividender[t] # Virksomhedens dividendeudbetalinger indgår negativt vVirkNetRenter og lægges til igen her
                       + vVirkOmv[t] + rOmv['IndlAktier',t] * vAktie[t-1]/fv; # Omvurderinger på virksomhens aktie-passiv indgår negativt i vVirkOmv og lægges til igen her

    E_rAktieFinAfk[t]$(t.val > %NettoFin_t1%)..
      rAktieFinAfk[t] * vAktieFin[t-1]/fv =E= vVirkFinInd[t] + sum(k, mrRenteVirkLaan[k,t] * vVirkLaan[k,sTot,t-1]/fv);

    # Nettofordringserhvervelsen er tæt knyttet til FCFE
    E_vVirkNFE[t]$(t.val > %NettoFin_t1%).. vVirkNFE[t] =E= vVirkNet[t] - vVirkNet[t-1]/fv - vVirkOmv[t];
  
    # Renter og omvurderinger for virksomhederne
    E_vVirkAktRenter[portf,t]$(d1vVirkAkt[portf,t] and t.val > %NettoFin_t1%)..
      vVirkAktRenter[portf,t] =E= (rRente[portf,t] + jrVirkAktRenter[portf,t]) * vVirkAkt[portf,t-1]/fv;

    E_vVirkPasRenter[portf,t]$(d1vVirkPas[portf,t] and t.val > %NettoFin_t1%)..
      vVirkPasRenter[portf,t] =E= (rRente[portf,t] + jrVirkPasRenter[portf,t]) * vVirkPas[portf,t-1]/fv;

    E_vVirkNetRenter[t]$(t.val > %NettoFin_t1%)..
      vVirkNetRenter[t] =E= sum(portf, vVirkAktRenter[portf,t]) - sum(portf, vVirkPasRenter[portf,t]) - vJordrente[t];

    E_vVirkAktOmv[portf,t]$(d1vVirkAkt[portf,t] and t.val > %NettoFin_t1%)..
      vVirkAktOmv[portf,t] =E= (rOmv[portf,t] + jrVirkAktOmv[portf,t]) * vVirkAkt[portf,t-1]/fv;

    E_vVirkPasOmv[portf,t]$(d1vVirkPas[portf,t] and t.val > %NettoFin_t1%)..
      vVirkPasOmv[portf,t] =E= (rOmv[portf,t] + jrVirkPasOmv[portf,t]) * vVirkPas[portf,t-1]/fv;

    E_jvVirkOmv[t]$(t.val > %NettoFin_t1%)..
      jvVirkOmv[t] =E= sum(portf, jrVirkAktOmv[portf,t] * vVirkAkt[portf,t-1]/fv)
                     - sum(portf, jrVirkPasOmv[portf,t] * vVirkPas[portf,t-1]/fv);

    E_vVirkOmv[t]$(t.val > %NettoFin_t1%)..
      vVirkOmv[t] =E= sum(portf, vVirkAktOmv[portf,t]) - sum(portf, vVirkPasOmv[portf,t]);

    # Vi antager en fast realiseringsgrad ift. beskatning af omvurderinger på aktier
    # Da urealiserede gevinster akkumuleres flytter realiseringsgraden blot gevinster over tid, men ændrer ikke den samlede nominelle beskatning 
    E_vVirkRealiseretAktieOmv[t]$(t.val > %NettoFin_t1%)..
      vVirkRealiseretAktieOmv[t] =E= rVirkRealiseringAktieOmv[t] * vVirkUrealiseretAktieOmv[t];

    E_vVirkUrealiseretAktieOmv[t]$(t.val > %NettoFin_t1%)..
      vVirkUrealiseretAktieOmv[t] =E= vVirkUrealiseretAktieOmv[t-1]/fv
                                    - vVirkRealiseretAktieOmv[t]
                                    + vVirkAktOmv['IndlAktier',t]
                                    + vVirkAktOmv['UdlAktier',t];

    # Renter og omvurderinger for pensionsselskaberne
    E_rRente_Pens[t]$(t.val > %NettoFin_t1%)..
      rRente['pensTot',t] =E= vPensionRenter[t] / (vPensionAkt['Tot',t-1]/fv);

    E_rOmv_Pens[t]$(t.val > %NettoFin_t1%)..
      rOmv['pensTot',t] =E= vPensionOmv[t] / (vPensionAkt['Tot',t-1]/fv);

    E_vPensionAkt_tot[t]$(t.val >= %NettoFin_t1%)..
      vPensionAkt['Tot',t] =E= vHhAkt['pensTot',aTot,t] + vUdlAkt['pensTot',t];

    E_vPensionAkt[portf,t]$(d1vPensionAkt[portf,t] and t.val >= %NettoFin_t1%)..
      vPensionAkt[portf,t] =E= rPensionAkt[portf,t] * vPensionAkt['Tot',t];

    E_vPensionAktRenter[portf,t]$(d1vPensionAkt[portf,t] and t.val > %NettoFin_t1%)..
      vPensionAktRenter[portf,t] =E= (rRente[portf,t] + jrPensionAktRenter[portf,t]) * vPensionAkt[portf,t-1]/fv;

    E_jvPensionRenter[t]$(t.val > %NettoFin_t1%)..
      jvPensionRenter[t] =E= sum(portf, jrPensionAktRenter[portf,t] * vPensionAkt[portf,t-1]/fv);

    E_vPensionRenter[t]$(t.val > %NettoFin_t1%)..
      vPensionRenter[t] =E= sum(portf, vPensionAktRenter[portf,t]);

    E_vPensionAktOmv[portf,t]$(d1vPensionAkt[portf,t] and t.val > %NettoFin_t1%)..
      vPensionAktOmv[portf,t] =E= (rOmv[portf,t] + jrPensionAktOmv[portf,t]) * vPensionAkt[portf,t-1]/fv;

    E_jvPensionOmv[t]$(t.val > %NettoFin_t1%)..
      jvPensionOmv[t] =E= sum(portf, jrPensionAktOmv[portf,t] * vPensionAkt[portf,t-1]/fv);

    E_vPensionOmv[t]$(t.val > %NettoFin_t1%)..
      vPensionOmv[t] =E= sum(portf, vPensionAktOmv[portf,t]);

    # Der er en sammenhæng mellem ECB-renten og gns. obligationsrente i EU - obligationsrenten er den styrende og den eksogene
    E_rRenteOblEU[t]..
      rRenteOblEU[t] =E= rRenteECB[t] + rOblPrem[t]; 

    # Den danske pengemarkedsrente følger ECB-renten plus et rentespænd
    E_rRenteOblDK[t]$(t.val >= 1985)..
      rRenteOblDK[t] =E= rRenteECB[t] + rOblPrem[t] + rRenteSpaend[t]; 

    E_rRente_Obl[t]$(t.val >= 1985)..
      rRente['Obl',t] =E= rRenteECB[t] + rOblPrem[t] + rRenteSpaend[t] + crRenteObl[t]; 

    E_rRente_Bank[t]$(t.val >= 1985)..
      rRente['Bank',t] =E= rRenteECB[t] + rRenteSpaend[t] + crRenteBank[t];

    # Groft skøn for fremskrivning - gennemsnitsrenten er gennemsnit over alle typer af flex og fastforrentede fra 
    # de seneste 29 år - nedenstående er en grov approksimation til fremskrivning
    E_rRente_RealKred[t]$(t.val >= 2001)..
      rRente['RealKred',t] =E= 0.4 * rRenteFlex[t] + 0.3 * rRenteFast[t] + 0.2 * rRenteFast[t-1] + 0.1 * rRenteFast[t-2]
                               + crRenteRealKred[t];

    E_rRenteFlex[t]$(t.val >= 2000)..
      rRenteFlex[t] =E= rRente['Obl',t] + crRenteFlex[t];

    E_rRenteFast[t]..
      rRenteFast[t] =E= rRente['Obl',t] + crRenteFast[t];

    E_rAfk[portf,t]$(t.val > %NettoFin_t1%).. rAfk[portf,t] =E= rRente[portf,t] + rOmv[portf,t];
  $ENDBLOCK

  $BLOCK B_finance_forwardlooking$(tx0[t])
    # Værdi af aktier eksklusiv finansielle aktiver, i.e. værdi af drift (og et residual som fjernes i en kommende version af MAKRO)
    E_vAktieDrift[t]$(tx0E[t]).. vAktieDrift[t] =E= (vFCFE[sTot,t+1] + vAktieDrift[t+1])*fv / (1+rAktieDrift[t+1]);
    E_vAktieDrift_tEnd[t]$(tEnd[t]).. vAktieDrift[t] =E= (vFCFE[sTot,t] + vAktieDrift[t])*fv / (1+rAktieDrift[t]);

    E_nvFCFF[sp,t]$(tx0E[t]).. nvFCFF[sp,t] =E= (vFCFF[sp,t+1] + nvFCFF[sp,t+1])*fv / (1+rWACC[sp,t+1]);
    E_nvFCFF_tEnd[sp,t]$(tEnd[t]).. nvFCFF[sp,t] =E= (vFCFF[sp,t] + nvFCFF[sp,t])*fv / (1+rWACC[sp,t]);
    E_nvFCFF_sTot[t].. nvFCFF[sTot,t] =E= sum(sp, nvFCFF[sp,t]);

    E_dnvAfskrFradrag2dvI_s[k,sp,t]$(tx0[t] and d1K[k,sp,t] and t.val > %NettoFin_t1%)..
      dnvAfskrFradrag2dvI_s[k,sp,t] =E= rSkatAfskr0[k,t] * mtVirk[sp,t] # periode 1
                                        + (rKskat[k,t] - rSkatAfskr0[k,t]) * dnvKskat2dvI_s[k,sp,t]; # periode 2+
    E_dnvKskat2dvI_s[k,sp,t]$(tx0E[t] and d1K[k,sp,t] and t.val > %NettoFin_t1%)..
      dnvKskat2dvI_s[k,sp,t] =E= fVirkDisk[sp,t+1] 
                                 * (rSkatAfskr[k,t+1] * mtVirk[sp,t+1]
                                    + (1 - rSkatAfskr[k,t+1]) * dnvKskat2dvI_s[k,sp,t+1]
                                    );
    E_dnvKskat2dvI_s_tEnd[k,sp,t]$(tEnd[t] and d1K[k,sp,t])..
      dnvKskat2dvI_s[k,sp,t] =E= mtVirk[sp,t] * rSkatAfskr[k,t] / (rVirkDisk[sp,t] + rSkatAfskr[k,t]);
  $ENDBLOCK

  Model M_finance /
    B_finance_static
    B_finance_forwardlooking
  /;  

  $GROUP G_finance_static
    G_finance_endo
    -vAktieDrift # -E_vAktieDrift, E_vAktieDrift_tEnd
    -nvFCFF # -E_nvFCFF, -E_nvFCFF_tEnd, -E_nvFCFF_sTot
    -dnvAfskrFradrag2dvI_s # E_dnvAfskrFradrag2dvI_s
    -dnvKskat2dvI_s # E_dnvKskat2dvI_s, E_dnvKskat2dvI_s_tEnd
  ;
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
  @load(G_finance_makrobk, "..\Data\makrobk\makrobk.gdx" )

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
  rVirkDisk.l[sp,t] = max(rRenteECB.l[t] - terminal_ECB_rente, 0) + 0.08;
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
  rVirkRealiseringAktieOmv.l[t] = 0.05; # Bør kalibreres, hvis vVirkRealiseretAktieOmv kan datadækkes
  rVirkAktieFradrag.l[t] = 0.75; # I ADAM er den 0 for dividender og 1 for kursgevinster!
  # Initialværdi for vVirkUrealiseretAktieOmv i første dataår - steady antagelse går godt da omvurderinger i 1995 har rimeligt niveau
  vVirkUrealiseretAktieOmv.l[t]$(t.val = %NettoFin_t1%)
    = (vVirkAktOmv.l['IndlAktier',t+1] + vVirkAktOmv.l['UdlAktier',t+1]) / ((1+rVirkRealiseringAktieOmv.l[t+1]) * fv - 1);

# ======================================================================================================================
# Data assignment
# ======================================================================================================================
  # Initialisering
  vAktieFin.l[t] = vVirkNet.l[t] + vAktie.l[t] + sum(k, mrLaan2K.l[k,sTot,t] * vVirkK.l[k,sTot,t]);

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
    -vVirkPas[Realkred,t]$(d1vVirkPas[Realkred,t]), mrLaan2K_portf[iB,RealKred,t]$(d1vVirkPas[RealKred,t])
    # Øvrige lån bestemmes af den resterende låneresidual ikke knyttet til investeringer
    -vVirkPas[portf,t]$(not RealKred[portf_] and d1vVirkPas[portf_,t] and not IndlAktier[portf_]), rVirkPasRest[portf,t]$(not RealKred[portf_] and d1vVirkPas[portf_,t] and not IndlAktier[portf_])
    # Den marginale bankbelåning tilpasser sig, så den samlede belåning rammer målet (Ændret fra obligationsbelåning, da ikke finansielle virksomheder stort set ikke udsteder obligationer, men har store banklån)
    mrLaan2K_portf[k,Bank,t] # E_mrLaan2K_portf_bank

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
    rVirkDiskPrem[sp,t], -rVirkDisk[sp,t] # E_rVirkDisk_t1
    jvKskat[k,sp,t]$(t.val = 2023) # E_jvKskat
    dnvKskat2dvI_s[k,sp,t]$(d1K[k,sp,t] and t.val > %NettoFin_t1%) # dnvKskat2dvI_s_static
    dnvAfskrFradrag2dvI_s[k,sp,t]$(tx0[t] and d1K[k,sp,t] and t.val > %NettoFin_t1%) # E_dnvAfskrFradrag2dvI_s
  ;
  $GROUP G_finance_static_calibration
    G_finance_static_calibration$(tx0[t])
    vVirkLaan[kTot,s_,t0]
    vVirkLaan[k,s_,t0]
  ;
  $BLOCK B_finance_static_calibration 
    E_uFinAccel[sp,t]$(tx0[t]).. uFinAccel[sp,t] =E= 500 / vVirkK[kTot,sp,t];

    E_mrLaan2K_portf_bank[k,t]$(tx0[t]).. 
      mrLaan2K[k,sTot,t] =E= mrLaan2K_portf[k,'Bank',t] + mrLaan2K_portf[k,'RealKred',t]$(not iM[k] and t.val >= %NettoFin_t1%);

    # Kapital efter 2023 beskattes med den nye sats, mens kapitalapparat før 2023 beskattes med den gamle sats
    # Vi korrigerer kapitalapparatet fra før 2023, så det effektivt beskattes med den gamle sats
    E_jvKskat[k,sp,t]$(t.val = 2023 and tx0[t]).. 
      jvKskat[k,sp,t] =E= (vKskat[k,sp,t-1]/fv - vAfskrFradrag[k,sp,t]) * (rSkatAfskr[k,t] / rSkatAfskr[k,t-1] - 1); 

    E_dnvKskat2dvI_s_static[k,sp,t]$(d1K[k,sp,t] and t.val > %NettoFin_t1%)..
      dnvKskat2dvI_s[k,sp,t] =E= mtVirk[sp,t] * rSkatAfskr[k,t] / (rVirkDisk[sp,t] + rSkatAfskr[k,t]);
    @copy_equation_to_period(E_vVirkLaan, t0)
    @copy_equation_to_period(E_vVirkLaan_sTot, t0)
    @copy_equation_to_period(E_vVirkLaan_kTot, t0)
    @copy_equation_to_period(E_rVirkDisk, t1);
    @copy_equation_to_period(E_rAktieDrift, t1);
  $ENDBLOCK
  MODEL M_finance_static_calibration /
    B_finance_static
    B_finance_static_calibration
    E_dnvAfskrFradrag2dvI_s
  /;

  $GROUP G_finance_static_calibration_newdata
    G_finance_static_calibration
   ;
$ENDIF

# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_finance_deep
    G_finance_endo
    mrLaan2K_portf[k,Bank,t]
   
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
    E_mrLaan2K_portf_bank
  /;
$ENDIF

# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
  $GROUP G_finance_dynamic_calibration
    G_finance_endo
    mrLaan2K_portf[k,Bank,t1]
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

    # Brug seneste data for landbruget.
    # Der er en aftagende tendes og data er endelige, så vi vil ikke vende tilbage til 2019 niveau.
    E_mrLaan2K[k,sp,t]$(tx1[t]).. mrLaan2K[k,sp,t] =E= mrLaan2K[k,sp,t1];
    @copy_equation_to_period(E_mrLaan2K_portf_bank, t1);
  $ENDBLOCK
  MODEL M_finance_dynamic_calibration /
    M_finance
    B_finance_dynamic_calibration
  /;
$ENDIF
