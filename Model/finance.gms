# ======================================================================================================================
# Finance
# - Firm financing and valuation
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_finance_prices_endo     empty_group_dummy[t];
  $GROUP G_finance_quantities_endo empty_group_dummy[t];
  $GROUP G_finance_values_endo
    vAktie[t]$(t.val > 1994) "Aktier og andre ejerandelsbeviser, kursværdi, Kilde: ADAM[Ws_cr_z]+ADAM[Ws_cf_z]"
    vAktiex[s_,t] "Værdien af virksomheden ekskl. dens finansielle aktiver (vAktie-vVirkx)"
    vAktieRes[t]$(t.val > 1994) "Diskrepans mellem observeret og beregnet værdi for virksomheden."

    vEBT[s_,t] "Earnings before taxes - fortjeneste før beskatning."
    vEBTx[s_,t] "Earnings before taxes - fortjeneste før beskatning - alene den del der hører til driften uden afkast."
    vEBITDA[s_,t] "Earnings before interests, taxes, depreciation, and amortization - fortjeneste før renter, skatter og afskrivninger."
    vFCF[s_,t] "Frie pengestrømme (Free cash flow) ekskl. fra finansiel portefølje."

    vVirkRenter[t] "Samlede nettoformueindkomst for finansielle og ikke-finansielle selskaber, Kilde: ADAM[Tin_cr]+ADAM[Tin_cf]"
    vVirkOmv[t] "Samlede omvurderinger af finansielle og ikke-finansielle selskabers nettoformue, Kilde: ADAM[Wn_cr]+ADAM[Wn_cf]-ADAM[Wn_cr][-1]-ADAM[Wn_cf][-1]-ADAM[Tfn_cr]-ADAM[Tfn_cf]"
    vVirkNFE[t] "Samlet nettofordringserhvervelse for finansielle og ikke-finansielle selskaber, Kilde: ADAM[Tfn_cr]+ADAM[Tfn-Cf]"

    vKskat[i_,s_,t]$(t.val > 1994 and d1k[i_,s_,t]) "Bogført værdi af samlet kapitalapparat fordelt på brancher."
    vAfskrFradrag[s_,t] "Skatte-fradrag for kapitalafskrivninger."
    vDividender[t]$(t.val > 1994) "Samlede udbytter af aktier og ejerandelsbeviser udbetalt af indenlandske selskaber, Kilde: ADAM[Tiu_cr_z]+ADAM[Tiu_cf_z]"
    vUdstedelser[t]$(t.val > 1994) "Nettoudstedelser af aktier fra indenlandske selskaber, Kilde: ADAM[Tfs_cr_z]+ADAM[Tfs_cf_z]"

    vVirkK[i_,s_,t]$(sTot[s_] or sp[s_]) "Værdi af kapitalbeholdningen til investeringspris ekskl. husholdningernes boligkapital."

    vVirk[portf_,t]$(not (t.val < 1994 and NetFin[portf_]) and not BankGaeld[portf_]) "Virksomhedernes (indenlandske selskabers) finansielle portefølje."
    vVirkLaan[s_,t] "Lån til gældsfinansierede investeringer."
    vVirkx[t] "Samlet værdi af virksomhedernes finansielle aktiver - del af finansiel portefølje som opgøres til face-value."
    vPension[akt,t]$(t.val >= 1994 and not (Guld[akt] or Bank[akt])) "Porteføljen af pensionsformuen."

    vtSelskabx[s_,t] "Den del af selskabsskatten der hører til driften."

    vVirkFinInd[t] "Samlet afkast (omvurderinger + renter) på virksomhedens portefølje."

    vVirkUrealiseretAktieOmv[t] "Skøn over virksomheders realiserede gevinst ved salg af aktier."
    vVirkRealiseretAktieOmv[t] "Skøn over virksomhedernes endnu ikke realiserede kapitalgevinster på aktier."
  ;

  $GROUP G_finance_endo
    G_finance_prices_endo
    G_finance_quantities_endo
    G_finance_values_endo

    rVirkDisk[s_,t]$(sp[s_]) "Selskabernes diskonteringsrate."
    fVirkDisk[s_,t]$(sp[s_]) "Selskabernes diskonteringsrate."

    rAfkastKrav[s_,t] "Investorernes forventede afkast på vAktiex. I fravær af stød er den lig afkastet på vAktiex."
    rVirkxAfk[t] "Afkastrate på virksomhedernes finansielle aktiver."
    rRente[akt,t]$(pensTot[akt] or (Bank[akt] and t.val >= 1985) or (Obl[akt] and t.val >= 1985)) "Renter og dividender på finansiel portefølje."
    rOmv[portf_,t]$((IndlAktier[portf_] and t.val > 1994) or pensTot[portf_]) "Omvurderinger på finansiel portefølje."
    rLaan2K[t] "Andel af investeringer som er gældsfinansierede."
    rIndlAktiePrem[s_,t]$(sTot[s_] and tx1[t]) "Risikopræmie på indenlandske aktier."
    rFinAccelPrem[sp,t] "Ændring i risikopræmie fra finansiel friktion."
    vFCFxRef[sp,t] "vFCF eksklusiv reference-pengestrøm."
    rRenteOblEU[t] "EU effektive rente af langfristede obligationer. Kilde: ADAM[iwbeu]"
    rRenteBankIndskud[t] "Pengeinstitutternes effektive indskudsrente. Kilde: ADAM[iwde]"
    rRenteBankGaeld[t] "Pengeinstitutternes effektive udlånsrente. Kilde: ADAM[iwlo]"
    rRenteRealKred[t] "Realkreditrente: Gns. af 30-årig og 1-årig realkreditobligationsrente. Kilde: ADAM[bobl30] * ADAM[iwb30] + (1-ADAM[bobl30]) * ADAM[iwbflx]"
    rRenteOblDK[t]$(t.val >= 1985) "Effektiv rente på 10-årig statsobligation (stående lån), årsgennemsnit. Kilde: ADAM[iwbos]"
  ;
  $GROUP G_finance_endo G_finance_endo$(tx0[t]);  # Restrict endo group to tx0[t]

  $GROUP G_finance_prices
    G_finance_prices_endo
  ;
  $GROUP G_finance_quantities
    G_finance_quantities_endo
  ;
  $GROUP G_finance_values
    G_finance_values_endo

    vVirkIndRest[t] "Rest-led i virksomheden indtjening."
    vPension[akt,t]$(Guld[akt] or Bank[akt])
    vFCFxRefRest[sp,t] "Restled i vFCFxRef - kalibreres til at slå finansiel friktion fra i grundforløb."
  ;

  $GROUP G_finance_exogenous_forecast
    rRenteECB[t] "ECB-renten. Kilde: ADAM[iweu]"

    rIndlAktiePrem[s_,t]$(s[s_])
    rVirkDiskPrem[sp,t] "Risikopræmie i diskonteringsraten for virksomhedens beslutningstagere."
  ;
  $GROUP G_finance_forecast_as_zero
    jvVirkRenter[t] "J-led."
    jvVirkOmv[t] "J-led."
    jrRente_pension[t] "J-led."
    jrOmv_pension[t] "J-led."
    jrOmv_IndlAktier[t] "J-led - alene nødvendigt pga. databrud i 2016"

    rOmv$(not (IndlAktier[portf_] or UdlAktier[portf_] or pensTot[portf_]))

    vVirkIndRest[t]
  ;
  $GROUP G_finance_ARIMA_forecast
    rvRealKred2K[t] "Værdien af realkreditgæld i forhold til værdien af kapitalapparatet."
    rRente$(IndlAktier[akt] or UdlAktier[akt])
    rOblPrem[t] "Risikopræmie på obligationer ift. pengemarkedsrente."
    rBidragsSats[t] "Gennemsnitlig bidragssats på realkreditlån, ultimo året. Kilde: ADAM[iwbid]"
    rRenteSpaend[t] "Forskel på renten på danske statsobligationer og obligationer ustedt af ECB" 
    crRenteObl[t] "Forskel på gennemsnitlig obligationsrente og statsobligationsrente"
    crRenteBank[t] "Forskel på ECBs og Danmarks pengemarkedsrente."
    crRenteRealKred[t] "Forskel på renten på realkreditobligationer og danske statsobligationer"
    crRenteBankGaeld[t] "Forskel på pengemarkedsrente og udlånsrente for bankerne."
    crRenteBankIndskud[t] "Forskel på pengemarkedsrente og indskudsrente for bankerne."
  ;
  $GROUP G_finance_constants
    rFinAccelTraeghed "Træghed i opdatering af reference-profit for finansiel friktion. Styrer persistens i finansiel friktion."
    rFinAccel[sp] "Straf-rente fra finansielle friktioner på overskydende (manglende) fri pengestrømme."
  ;
  $GROUP G_finance_other
    rSkatAfskr[k,t] "Skattemæssig afskrivningsrate."
    rvOblLaan2K[t] "Andel af investeringer som er gældsfinansierede via virksomhedsobligationer."
    rvVirkx[akt,t] "Virksomhedens finansielle aktiver, som andel af virksomhedens værdi ekskl. finansielle aktiver og residual."
    rPensAkt[akt,t] "Andel af aktiver ud af samlede aktiver."
    uFinAccel[sp,t] "Hældning af den approksimerede afledte af omkostnings-funktionen fra finansielle friktioner i steady state."
    rAktieRes2Aktiex[t] "vAktieRes ift. vAktiex"
    rVirkRealiseringAktieOmv[t] "Andel af omvurderinger på virksomheders aktier som realiseres hvert år."
    rVirkAktieFradrag[t] "Virksomheders aktie fradrag"
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_finance
    # Virksomhedens diskonteringsrate
    E_rVirkDisk[sp,t]$(tx0[t]).. rVirkDisk[sp,t] =E= rRente['Obl',t] + rVirkDiskPrem[sp,t] + rFinAccelPrem[sp,t];

    # Virksomhedernes diskonteringsfaktor
    E_fVirkDisk[sp,t]$(tx0[t]).. fVirkDisk[sp,t] =E= 1 / (1 + rVirkDisk[sp,t]);

    # Finansiel friktion
    E_rFinAccelPrem[sp,t]$(tx0E[t])..
      rFinAccelPrem[sp,t] =E= (1 + rRente['Obl',t] + rIndlAktiePrem[sp,t]) * (
                              (1 - rFinAccel[sp] * tanh(uFinAccel[sp,t] * vFCFxRef[sp,t-1]))
                            / (1 - rFinAccel[sp] * tanh(uFinAccel[sp,t] * vFCFxRef[sp,t]))
                            - 1);

    E_rFinAccelPrem_tEnd[sp,t]$(tEnd[t])..
      rFinAccelPrem[sp,t] =E= 0;

    E_vFCFxRef[sp,t]$(tx0[t])..
      vFCFxRef[sp,t] =E= rFinAccelTraeghed * (vFCF[sp,t] - vFCF[sp,t-1] + vFCFxRef[sp,t-1]) + vFCFxRefRest[sp,t];

    # Samlet værdi af ejenkapital i danske virksomheder - alle virksomheder antages at være aktieselskaber
    E_vAktie[t]$(tx0[t] and t.val > 1994)..
      vAktie[t] =E= vAktiex[sTot,t] + vVirkx[t] + vAktieRes[t];

    # Værdi af aktier eksklusiv finansielle aktiver, i.e. værdi af drift (og et residual som fjernes i en kommende version af MAKRO)
    E_vAktiex[sp,t]$(tx0E[t]).. vAktiex[sp,t] =E= (vFCF[sp,t+1] + vAktiex[sp,t+1])*fv / (1+rAfkastKrav[sp,t+1]);
    E_vAktiex_tEnd[sp,t]$(tEnd[t]).. vAktiex[sp,t] =E= (vFCF[sp,t] + vAktiex[sp,t])*fv / (1+rAfkastKrav[sp,t]);

    E_vAktiex_sTot[t]$(tx0E[t]).. vAktiex[sTot,t] =E= (vFCF[sTot,t+1] + vAktiex[sTot,t+1])*fv / (1+rAfkastKrav[sTot,t+1]);
    E_vAktiex_sTot_tEnd[t]$(tEnd[t]).. vAktiex[sTot,t] =E= sum(sp, vAktiex[sp,t]);
    E_rIndlAktiePrem_sTot[t]$(tx0E[t]).. vAktiex[sTot,t] =E= sum(sp, vAktiex[sp,t]);

    E_rAfkastKrav[sp,t]$(tx0[t]).. rAfkastKrav[sp,t] =E= rRente['Obl',t] + rIndlAktiePrem[sp,t];
    E_rAfkastKrav_sTot[t]$(tx1[t]).. rAfkastKrav[sTot,t] =E= rRente['Obl',t] + rIndlAktiePrem[sTot,t];

    # Finansielle aktiver og passiver følger den resterende aktieværdi
    E_vVirk[akt,t]$(tx0[t] and not obl[akt])..
      vVirk[akt,t] =E= rvVirkx[akt,t] * vAktiex[sTot,t];

    # Gæld som følger kapital-apparat er en del af virksomhedens drift. Kun resterende gæld indgår i vVirkx.
    E_vVirk_obl[t]$(tx0[t])..
      vVirk['Obl',t] =E= rvVirkx['obl',t] * vAktiex[sTot,t] - rvOblLaan2K[t] * vVirkK[kTot,sTot,t];

    E_vVirk_RealKred[t]$(tx0[t])..
      vVirk['RealKred',t] =E= rvRealKred2K[t] * vVirkK[kTot,sTot,t];

    E_vVirk_NetFin[t]$(tx0[t] and t.val >= 1994)..
      vVirk['NetFin',t] =E= sum(akt, vVirk[akt,t]) - sum(pas,vVirk[pas,t]);

    E_vVirkx[t]$(tx0[t])..
      vVirkx[t] =E= vVirk['NetFin',t] + vVirkLaan[sTot,t];

    # Resdidual for at ramme aktieværdi i data - på sigt bør risikopræmie kaliberes istedet
    E_vAktieRes[t]$(tx0[t] and t.val > 1994)..
      vAktieRes[t] =E= rAktieRes2Aktiex[t] * vAktiex[sTot,t];

    # Omvurderinger på aktier - bemærk at udstedelser øger vAktie 1-til-1 og derfor ikke påvirker omvurderinger
    E_rOmv_IndlAktier[t]$(tx0[t] and t.val > 1994)..
      rOmv['IndlAktier',t] =E= (vAktie[t] - vUdstedelser[t]) / (vAktie[t-1]/fv) - 1 + jrOmv_IndlAktier[t];

    # Dividender på indenlandske aktier
    E_vDividender[t]$(tx0[t] and t.val > 1994).. vDividender[t] =E= rRente['IndlAktier',t] * vAktie[t-1]/fv;

    # Budget-begrænsning
    # Udstedelser bestemmes residualt for at ramme en eksogen dividende-rate
    E_vUdstedelser[t]$(tx0[t] and t.val > 1994)..
      vVirkx[t] =E= (1+rVirkxAfk[t]) * vVirkx[t-1]/fv - (vtSelskab[sTot,t] - vtSelskabx[sTot,t])
                  + vFCF[sTot,t]
                  - vDividender[t]
                  + vUdstedelser[t];

    # Frie pengestrømme (Free Cash Flow) ekskl. fra finansiel fra portefølje
    E_vFCF_sTot[t]$(tx0[t])..
      vFCF[sTot,t] =E= vEBITDA[sTot,t]                        
                     - rRente['Obl',t] * vVirkLaan[sTot,t-1]/fv
                     + vVirkLaan[sTot,t] - vVirkLaan[sTot,t-1]/fv
                     - vI_s[iTot,spTot,t] + vHhInvestx[aTot,t]
                     - vtSelskabx[sTot,t]                           
                     # Nettooverførsler til virksomhederne
                     + vOffLandKoeb[t]
                     - vSelvstKapInd[aTot,t]
                     + vOffTilVirk[t] - vOffFraVirk[t]        
                     - vHhFraVirk[t]
                     + vVirkIndRest[t];                       

    E_vFCF[sp,t]$(tx0[t])..
      vFCF[sp,t] =E= vEBITDA[sp,t]                        
                   - rRente['Obl',t] * vVirkLaan[sp,t-1]/fv                  
                   + vVirkLaan[sp,t] - vVirkLaan[sp,t-1]/fv
                   - vI_s[iTot,sp,t] + vHhInvestx[aTot,t] * vI_s[iTot,sp,t] / sum(s$(sp[s]), vI_s[iTot,s,t]) + vIBolig[t]$(bol[sp])
                   - vtSelskabx[sp,t]
                   # Nettooverførsler til virksomhederne
                   + (vOffLandKoeb[t]
                   - vSelvstKapInd[aTot,t]
                   + vOffTilVirk[t] - vOffFraVirk[t]        
                   - vHhFraVirk[t]
                   + vVirkIndRest[t]) * vVirkK[kTot,sp,t] / vVirkK[kTot,sTot,t];                       

    # Earnings before interests, corporate taxes, and depreciation. Payroll taxes are included in both vtNetY and vL, and are added back.
    E_vEBITDA[sp,t]$(tx0[t])..
      vEBITDA[sp,t] =E= vY[sp,t] - vLoensum[sp,t] - vSelvstLoen[sp,t] - vR[sp,t] - vtNetY[sp,t] 
                      - vLejeAfEjerBolig[t]$(bol[sp]); # Lejeværdi af egen bolig trækkes fra, da det går til husejerne
    E_vEBITDA_tot[t]$(tx0[t]).. vEBITDA[sTot,t] =E= sum(sp, vEBITDA[sp,t]);

    # Earnings before taxes
    E_vEBT_sTot[t]$(tx0[t]).. vEBT[sTot,t] =E= vEBITDA[sTot,t] - vAfskrFradrag[sTot,t]
                                             + rRente['Obl',t] * vVirk['Obl',t-1]/fv 
                                             + rRente['Bank',t] * vVirk['Bank',t-1]/fv 
                                             - rRente['Obl',t] * vVirk['RealKred',t-1]/fv
                                             + rRente['IndlAktier',t] * vVirk['IndlAktier',t-1]/fv * (1-rVirkAktieFradrag[t])
                                             + rRente['UdlAktier',t] * vVirk['UdlAktier',t-1]/fv * (1-rVirkAktieFradrag[t])
                                             + vVirkRealiseretAktieOmv[t] * (1-rVirkAktieFradrag[t]); 

    E_vEBT[sp,t]$(tx0[t]).. vEBT[sp,t] =E= vEBITDA[sp,t] - vAfskrFradrag[sp,t]
                                         + (rRente['Obl',t] * vVirk['Obl',t-1]/fv 
                                         + rRente['Bank',t] * vVirk['Bank',t-1]/fv 
                                         - rRente['Obl',t] * vVirk['RealKred',t-1]/fv
                                         + rRente['UdlAktier',t] * vVirk['UdlAktier',t-1]/fv * (1-rVirkAktieFradrag[t])
                                         + rRente['IndlAktier',t] * vVirk['IndlAktier',t-1]/fv * (1-rVirkAktieFradrag[t])
                                         + vVirkRealiseretAktieOmv[t] * (1-rVirkAktieFradrag[t])) * vVirkK[kTot,sp,t] / vVirkK[kTot,sTot,t]; 

    # Earnings before taxes ekskl. afkast på portefølje
    E_vEBTx_sTot[t]$(tx0[t])..
      vEBTx[sTot,t] =E= vEBITDA[sTot,t] - vAfskrFradrag[sTot,t] - rRente['Obl',t] * vVirkLaan[sTot,t-1]/fv;

    E_vEBTx[sp,t]$(tx0[t])..
      vEBTx[sp,t] =E= vEBITDA[sp,t] - vAfskrFradrag[sp,t] - rRente['Obl',t] * vVirkLaan[sp,t-1]/fv;

    # Den del af selskabsskat der hører til driften
    E_vtSelskabx_sTot[t]$(tx0[t])..
      vtSelskabx[sTot,t] =E= tSelskab[t] * ftSelskab[t] * vEBTx[sTot,t] + vtSelskabNord[t];
    E_vtSelskabx[sp,t]$(tx0[t])..
      vtSelskabx[sp,t] =E= tSelskab[t] * ftSelskab[t] * vEBTx[sp,t] + udv[sp] * vtSelskabNord[t];

    # Tax book value of firm shares
    E_vKskat[k,sp,t]$(tx0[t] and t.val > 1994 and d1k[k,sp,t])..
      vKskat[k,sp,t] =E= (1-rSkatAfskr[k,t]) * vKskat[k,sp,t-1]/fv + vI_s[k,sp,t] - bol[sp] * vIBolig[t];
    E_vKskat_kTot[t]$(tx0[t]).. vKskat[kTot,sTot,t] =E= sum([k,sp], vKskat[k,sp,t]);

    E_vAfskrFradrag[sp,t]$(tx0[t]).. vAfskrFradrag[sp,t] =E= sum(k, rSkatAfskr[k,t] * vKskat[k,sp,t-1]/fv);
    E_vAfskrFradrag_sTot[t]$(tx0[t]).. vAfskrFradrag[sTot,t] =E= sum(sp, vAfskrFradrag[sp,t]);

    E_rLaan2K[t]$(tx0[t]).. rLaan2K[t] =E= rvRealKred2K[t] + rvOblLaan2K[t];

    # Værdi af virksomhedens kapital til genanskaffelsespris
    E_vVirkK[k,sp,t]$(tx0[t] and not (bol[sp] and iB[k])).. vVirkK[k,sp,t] =E= pI_s[k,sp,t] * qK[k,sp,t];

    E_vVirkK_bol[t]$(tx0[t])..
      vVirkK['iB','bol',t] =E= pI_s['iB','bol',t] * qK['iB','bol',t] -  pI_s['iB','bol',t] * qKBolig[t];

    E_vVirkK_kTot[sp,t]$(tx0[t]).. vVirkK[kTot,sp,t] =E= sum(k, vVirkK[k,sp,t]);

    E_vVirkK_sTot[t]$(tx0[t])..
      vVirkK[kTot,sTot,t] =E= sum(sp, vVirkK[kTot,sp,t]);

    # Gæld knyttet til kapitalapparat
    E_vVirkLaan_sTot[t]$(tx0[t]).. vVirkLaan[sTot,t] =E= rLaan2K[t] * vVirkK[kTot, sTot,t];                 
    E_vVirkLaan[sp,t]$(tx0[t]).. vVirkLaan[sp,t] =E= rLaan2K[t] * vVirkK[kTot, sp,t];

    # Netto renteudgifter (afkast) på virksomhedens portefølje
    E_vVirkFinInd[t]$(tx0[t]).. vVirkFinInd[t] =E= vVirkRenter[t] + vVirkOmv[t] 
                                                 + vDividender[t] + rOmv['IndlAktier',t] * vAktie[t-1]/fv;

    E_rVirkxAfk[t]$(tx0[t])..
      rVirkxAfk[t] =E= (vVirkFinInd[t] + rRente['Obl',t] * vVirkLaan[sTot,t-1]/fv) / (vVirkx[t-1]/fv);

    # Nettofordringserhvervelsen er tæt knyttet til FCFE
    E_vVirkNFE[t]$(tx0[t]).. vVirkNFE[t] =E= (vVirk['NetFin',t] - vAktie[t])
                                           - (vVirk['NetFin',t-1]/fv - vAktie[t-1]/fv)
                                           - vVirkOmv[t];
    # Virksomhedernes dividendeudbetalinger skal trækkes fra deres nettorenter
    E_vVirkRenter[t]$(tx0[t])..
      vVirkRenter[t] =E= sum(akt, rRente[akt,t] * vVirk[akt,t-1]/fv)
                       - rRente['Obl',t] * vVirk['RealKred',t-1]/fv
                       - vDividender[t]
                       - vJordrente[t]
                       + jvVirkRenter[t];

    # Virksomhedernes omvurderinger af udstedte aktier skal trækkes fra deres nettoomvurderinger
    E_vVirkOmv[t]$(tx0[t])..
      vVirkOmv[t] =E= sum(akt, rOmv[akt,t] * vVirk[akt,t-1]/fv)
                    - rOmv['RealKred',t] * vVirk['RealKred',t-1]/fv 
                    - rOmv['IndlAktier',t] * vAktie[t-1]/fv
                    + jvVirkOmv[t];

    # Vi antager en fast realiseringsgrad ift. beskatning af omvurderinger på aktier
    # Da urealiserede gevinster akkumuleres flytter realiseringsgraden blot gevinster over tid, men ændrer ikke den samlede nominelle beskatning 
    E_vVirkRealiseretAktieOmv[t]$(tx0[t])..
      vVirkRealiseretAktieOmv[t] =E= rVirkRealiseringAktieOmv[t] * vVirkUrealiseretAktieOmv[t];

    E_vVirkUrealiseretAktieOmv[t]$(tx0[t])..
      vVirkUrealiseretAktieOmv[t] =E= vVirkUrealiseretAktieOmv[t-1]/fv
                                - vVirkRealiseretAktieOmv[t]
                                + rOmv['IndlAktier',t] * vVirk['IndlAktier',t-1]/fv
                                + rOmv['UdlAktier',t] * vVirk['UdlAktier',t-1]/fv;

    # Renter og omvurderinger for pensionsselskaberne
    E_rRente_Pension[t]$(tx0[t] and t.val > 1994)..
      rRente['Pens',t] =E= ( rRente['Obl',t] * vPension['Obl',t-1]/fv + rRente['IndlAktier',t] * vPension['IndlAktier',t-1]/fv 
                           + rRente['UdlAktier',t] * vPension['UdlAktier',t-1]/fv ) 
                           / (vPension['Obl',t-1]/fv + vPension['IndlAktier',t-1]/fv + vPension['UdlAktier',t-1]/fv) + jrRente_pension[t];

    E_rOmv_Pension[t]$(tx0[t] and t.val > 1994)..
      rOmv['Pens',t] =E= (  rOmv['Obl',t] * vPension['Obl',t-1]/fv
                          + rOmv['IndlAktier',t] * vPension['IndlAktier',t-1]/fv 
                          + rOmv['UdlAktier',t] * vPension['UdlAktier',t-1]/fv
                         ) / (vPension['Obl',t-1]/fv + vPension['IndlAktier',t-1]/fv + vPension['UdlAktier',t-1]/fv) + jrOmv_pension[t];

    E_vPension_pension[t]$(tx0[t] and t.val >= 1994)..
      vPension['Pens',t] =E= - vHh['Pens',aTot,t] - vUdl['Pens',t];

    E_vPension_akt[akt,t]$(tx0[t] and (Obl[akt] or IndlAktier[akt] or UdlAktier[akt]) and t.val > 1993)..
      vPension[akt,t] =E= rPensAkt[akt,t] * (-vPension['Pens',t]);

    # Der er en sammenhæng mellem ECB-renten og gns. obligationsrente i EU - obligationsrenten er den styrende og den eksogene
    E_rRenteOblEU[t]$(tx0[t])..
      rRenteOblEU[t] =E= rRenteECB[t] + rOblPrem[t]; 

    # Den danske pengemarkedsrente følger ECB-renten plus et rentespænd
    E_rRenteOblDK[t]$(tx0[t] and t.val >= 1985)..
      rRenteOblDK[t] =E= rRenteOblEU[t] + rRenteSpaend[t]; 

    E_rRente_Obl[t]$(tx0[t] and t.val >= 1985)..
      rRente['Obl',t] =E= rRenteOblDK[t] + crRenteObl[t]; 

    E_rRente_Bank[t]$(tx0[t] and t.val >= 1985)..
      rRente['Bank',t] =E= rRenteECB[t] + rRenteSpaend[t] + crRenteBank[t];

    # Udlånsrenten og pengemarkedsrenten er korreleret
    E_rRenteBankGaeld[t]$(tx0[t])..
      rRenteBankGaeld[t] =E= rRente['Bank',t] + crRenteBankGaeld[t];

    E_rRenteBankIndskud[t]$(tx0[t])..
      rRenteBankIndskud[t] =E= rRente['Bank',t] + crRenteBankIndskud[t]; 

    # Realkreditrenten skal følge obligationsrenten, da passivsiden er inkluderet i virksomhedernes obligationsbeholdning - bidragssats er i FISIM
    E_rRenteRealKred[t]$(tx0[t])..
      rRenteRealKred[t] =E= rRente['Obl',t] + crRenteRealKred[t]; 
  $ENDBLOCK
$ENDIF

$IF %stage% == "exogenous_values":
# =============================================================================================½=========================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_finance_makrobk
    rRente, rOmv, vVirk, vVirkOmv, vVirkRenter, 
    vAktie, vUdstedelser, vPension
    rPensAkt, vVirkK$((sTot[s_] or sp[s_]) and kTot[i_]), vVirkNFE, vDividender
    rRenteECB, rRenteOblDK, rRenteOblEU, rRenteBankIndskud, rRenteBankGaeld, rRenteRealKred
    rBidragsSats
  ;
  @load(G_finance_makrobk, "..\Data\makrobk\makrobk.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_finance_data
    G_finance_makrobk
    rIndlAktiePrem$(sp[s_])
    rVirkDiskPrem
  ;
  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_finance_data_imprecise
    vVirk$(NetFin[portf_]), vVirkNFE, vDividender
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  # --------------------------------------------------------------------------------------------------------------------
  # Required rate of return on equity
  # --------------------------------------------------------------------------------------------------------------------
    # Lånefinansieringsrate
  rLaan2K.l[t] = 0.4; # Vækstplan DK 2013 FM
  
  rIndlAktiePrem.l[sp,t] = max(0.03, 0.07 - rRente.l['obl',t]);  # Om risikopræmie, se https://www.pwc.dk/da/publikationer/2020/vaerdiansaettelse-af-virk-pub.pdf og https://www.nationalbanken.dk/da/publikationer/Documents/2020/02/Eonomic%20Memo%20No.1_Do%20equity%20prices.pdf
  rVirkDiskPrem.l[sp,t] = rIndlAktiePrem.l[sp,t];

  # --------------------------------------------------------------------------------------------------------------------
  # Finansiel accelerator
  # --------------------------------------------------------------------------------------------------------------------  
  rFinAccel.l[sp] = 0.039992; # Matching parameter
  rFinAccel.l['bol'] = 0;
  rFinAccel.l['udv'] = 0;
  rFinAccelTraeghed.l = 0.9;

  # --------------------------------------------------------------------------------------------------------------------
  # Tax depreciation
  # --------------------------------------------------------------------------------------------------------------------
  rSkatAfskr.l['iM',t] = 0.15;
  rSkatAfskr.l['iB',t] = 0.04;

  # --------------------------------------------------------------------------------------------------------------------
  # Realiseringsrate på aktier
  # --------------------------------------------------------------------------------------------------------------------
  rVirkRealiseringAktieOmv.l[t] = 0.2; 
  rVirkAktieFradrag.l[t] = 0;

# ======================================================================================================================
# Data assignment
# ======================================================================================================================
  # Initialisering
  vVirkx.l[t] = vVirk.l['NetFin',t] + rLaan2K.l[t] * vVirkK.l[kTot,sTot,t];

  #Set Dummy for firm portfolio
  d1vVirk[portf_,t] = yes$(vVirk.l[portf_,t] <> 0);
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_finance_static_calibration
    G_finance_endo

    jrOmv_IndlAktier$(t.val = 2016), -rOmv$(IndlAktier[portf_] and t.val = 2016)
    -vAktie, rAktieRes2Aktiex
    -vUdstedelser$(t.val > 1994), vVirkIndRest$(t.val > 1994)
    -vVirk$(not NetFin[portf_]), rvVirkx, rvRealKred2K
    -rLaan2K, rvOblLaan2K
    -vVirkRenter, jvVirkRenter
    -vVirkOmv, jvVirkOmv
    -rRente$(pensTot[akt]), jrRente_pension$(t.val > 1994)
    -rRente$(Bank[akt]), crRenteBank$(t.val >= 1985)
    -rRenteBankIndskud, crRenteBankIndskud
    -rRenteBankGaeld, crRenteBankGaeld
    -rRenteRealKred, crRenteRealKred
    -rRenteOblEU, rOblPrem
    -rRenteOblDK, rRenteSpaend$(t.val >= 1985)
    -rRente$(Obl[akt]), crRenteObl$(t.val >= 1985)
    -rOmv$(pensTot[portf_]), jrOmv_pension$(t.val > 1994)
    vFCFxRefRest, -vFCFxRef
    uFinAccel # E_uFinAccel
  ;   
  $GROUP G_finance_static_calibration
    G_finance_static_calibration$(tx0[t])
    vKskat$(t.val = 1994 and d1K[i_,s_,t])
    vVirkLaan$(t0[t])
  ;

  $BLOCK B_finance_static_calibration 
    E_vKskat_t0[k,sp,t]$(t.val = 1994 and d1k[k,sp,t])..
      vKskat[k,sp,t] =E= vI_s[k,sp,t] / rSkatAfskr[k,t] - bol[sp] * (vIBolig[t] / rSkatAfskr[k,t]);  

    E_uFinAccel[sp,t]$(tx0[t]).. uFinAccel[sp,t] =E= 500 / vVirkK[kTot,sp,t];

    @copy_equation_to_period(E_vVirkLaan, t0)
    @copy_equation_to_period(E_vVirkLaan_sTot, t0)
  $ENDBLOCK
  MODEL M_finance_static_calibration /
    B_finance
    B_finance_static_calibration
  /;
$ENDIF

# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_finance_deep
    G_finance_endo
    rvOblLaan2K, -rLaan2K
    -vAktie$(t1[t]), rAktieRes2Aktiex
    vFCFxRefRest, -vFCFxRef
    uFinAccel
    -vVirk$(t1[t] and akt[portf_]), rvVirkx # E_rvVirkx
    rOmv$(UdlAktier[portf_] and tx1[t])
  ;
  $GROUP G_finance_deep G_finance_deep$(tx0[t]);

  $BLOCK B_finance_deep
    E_rvVirkx[akt,t]$(tx1[t]).. rvVirkx[akt,t] =E= rvVirkx[akt,t1];

    E_rAktieRes2Aktiex_deep[t]$(tx1[t]).. rAktieRes2Aktiex[t] =E= rAktieRes2Aktiex[t1];

    E_rOmv_UdlAktier[t]$(tx1[t]).. rOmv['UdlAktier',t] + rRente['UdlAktier',t] =E= rAfkastKrav[sTot,t];
  $ENDBLOCK
  MODEL M_finance_deep /
    B_finance
    B_finance_deep
    E_uFinAccel
  /;
$ENDIF

# ======================================================================================================================
# Simple dynamic calibration
# ======================================================================================================================
$IF %stage% == "simple_dynamic_calibration":
  $GROUP G_finance_dynamic_calibration
    G_finance_endo
    rvOblLaan2K$(t1[t]), -rLaan2K$(t1[t])
    -vAktie$(t1[t]), rAktieRes2Aktiex$(t1[t])
    vFCFxRefRest, -vFCFxRef
    rAktieRes2Aktiex$(tx1[t]) # E_rAktieRes2Aktiex
    -vVirk$(t1[t] and akt[portf_]), rvVirkx$(t1[t])
  ;
  $BLOCK B_finance_dynamic_calibration
    E_rAktieRes2Aktiex[t]$(tx1[t]).. rAktieRes2Aktiex[t] =E= rAktieRes2Aktiex[t1];
  $ENDBLOCK
  MODEL M_finance_dynamic_calibration /
    B_finance
    B_finance_dynamic_calibration
  /;
$ENDIF