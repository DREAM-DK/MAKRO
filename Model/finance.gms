# ======================================================================================================================
# Finance
# - Firm financing and valuation
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_finance_prices     empty_group_dummy[t];
  $GROUP G_finance_quantities empty_group_dummy[t];

  $GROUP G_finance_values
    vAktie[t] "Aktier og andre ejerandelsbeviser, kursværdi, Kilde: ADAM[Ws_cr_z]+ADAM[Ws_cf_z]"
    vAktiex[s_,t] "Værdien af virksomheden ekskl. dens finansielle aktiver (vAktie-vVirkx)"
    vAktieRes[t] "Diskrepans mellem observeret og beregnet værdi for virksomheden."

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
    vUdstedelser[t] "Nettoudstedelser af aktier fra indenlandske selskaber, Kilde: ADAM[Tfs_cr_z]+ADAM[Tfs_cf_z]"

    vVirkK[s_,t] "Værdi af kapitalbeholdningen til investeringspris ekskl. husholdningernes boligkapital."

    vVirk[portf_,t]$(not (t.val < 1994 and sameas['NetFin',portf_])) "Virksomhedernes (indenlandske selskabers) finansielle portefølje."
    vVirkLaan[s_,t] "Lån til gældsfinansierede investeringer."
    vVirkx[t] "Samlet værdi af virksomhedernes finansielle aktiver - del af finansiel portefølje som opgøres til face-value."
    vPension[akt,t]$(t.val > 2015) "Porteføljen af pensionsformuen."

    vtSelskabx[s_,t] "Den del af selskabsskatten der hører til driften."

    vVirkFinInd[t] "Samlet afkast (omvurderinger + renter) på virksomhedens portefølje."
    vVirkIndRest[t] "Rest-led i virksomheden indtjening."
  ;

  $GROUP G_finance_endo
    G_finance_quantities
    G_finance_values
    rVirkDisk[sp,t] "Selskabernes diskonteringsrate."
    rAfkastKrav[s_,t] "Investorernes forventede afkast på vAktiex. I fravær af stød er den lig afkastet på vAktiex."
    rVirkxAfk[t]$(t.val > 2015) "Afkastrate på virksomhedernes finansielle aktiver."
    rRente[portf,t]$(sameas[portf,'Pens'] or sameas[portf,'RealKred'] or sameas[portf,'Bank'] or sameas[portf,'BankGaeld']) "Renter og dividender på finansiel portefølje."
    rOmv[portf,t]$((sameas[portf,'IndlAktier'] and t.val > 1995) or sameas[portf,'UdlAktier'] or sameas[portf,'Pens']) "Omvurderinger på finansiel portefølje."
    rLaan2K[t] "Andel af investeringer som er gældsfinansierede."
    -vVirkIndRest[t]
    -vPension[akt,t]$(sameas['Guld',akt] or sameas['Bank',akt])
    rIndlAktiePrem[s_,t]$(sTot[s_]) "Risikopræmie på indenlandske aktier."
    rFinAccelPrem[sp,t] ""
    vFCFxRef[sp,t] ""
  ;
  $GROUP G_finance_endo G_finance_endo$(tx0[t]);  # Restrict endo group to tx0[t]

  $GROUP G_finance_exogenous_forecast
    rRente$(sameas[portf,'Obl'])
    rOmv$(not (sameas[portf,'IndlAktier'] or sameas[portf,'UdlAktier'] or sameas[portf,'Pens']))

    rIndlAktiePrem[s_,t]$(s[s_])
    rUdlAktiePrem[t] "Risikopræmie på udenlandske aktier."
    rVirkDiskPrem[sp,t] "Risikopræmie i diskonteringsraten for virksomhedens beslutningstagere."

    # Forecast as zero
    jvVirkRenter[t] "J-led."
    jvVirkOmv[t] "J-led."
    jrRente_pension[t] "J-led."
    jrOmv_pension[t] "J-led."
    jrOmv_UdlAktier[t] "J-led."
    jvVirkx[t] "J-led."

    vVirkIndRest[t]
  ;
  $GROUP G_finance_ARIMA_forecast
    rvRealKred2K[t] "Værdien af realkreditgæld i forhold til værdien af kapitalapparatet."
    crRenteBank[t] "Forskel på gns. obligationsrente indlånsrente for bankerne."
    rRente$(sameas[portf,'IndlAktier'] or sameas[portf,'UdlAktier'])
  ;
  $GROUP G_finance_other
    rSkatAfskr[k,t] "Skattemæssig afskrivningsrate."
    rAktieRes2BVT[t] "Uforklaret del af virksomhedens værdi ift. glidende gennemsnit af BVT."
    rvOblLaan2K[t] "Andel af investeringer som er gældsfinansierede via virksomhedsobligationer."
    rvVirkx[akt,t] "Andel af virksomhedens finansielle aktiver, som står i denne aktivtype."
    rPensAkt[akt,t] "Andel af aktiver ud af samlede aktiver."
    rFinAccel[sp] "Straf-rente fra finansielle friktioner på overskydende (manglende) fri pengestrømme."
    cFinAccel[sp,t] ""
    uFinAccel[sp,t] "Hældning af den approksimerede afledte af omkostnings-funktionen fra finansielle friktioner i steady state."
    rFinAccelTraeghed "Træghed i opdatering af reference-profit for finansiel friktion. Styrer persistens i finansiel friktion."
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_finance
    E_rAfkastKrav[sp,t]$(tx0[t])..
      rAfkastKrav[sp,t] =E= rRente['Obl',t] + rIndlAktiePrem[sp,t];

    E_rAfkastKrav_sTot[t]$(tx1[t])..
      rAfkastKrav[sTot,t] =E= rRente['Obl',t] + rIndlAktiePrem[sTot,t];

    E_rVirkDisk[sp,t]$(tx0[t])..
      rVirkDisk[sp,t] =E= rRente['Obl',t] + rVirkDiskPrem[sp,t] + rFinAccelPrem[sp,t];

    E_rFinAccelPrem[sp,t]$(tx0E[t])..
      rFinAccelPrem[sp,t] =E= (1 + rRente['Obl',t] + rIndlAktiePrem[sp,t]) * (
                              (1 - rFinAccel[sp] * tanh(uFinAccel[sp,t] * vFCFxRef[sp,t-1]))
                            / (1 - rFinAccel[sp] * tanh(uFinAccel[sp,t] * vFCFxRef[sp,t]))
                            - 1);

    E_rFinAccelPrem_tEnd[sp,t]$(tEnd[t])..
      rFinAccelPrem[sp,t] =E= 0;

    E_vFCFxRef[sp,t]$(tx0[t])..
      vFCFxRef[sp,t] =E= rFinAccelTraeghed * (vFCF[sp,t] - vFCF[sp,t-1] + vFCFxRef[sp,t-1]) + cFinAccel[sp,t];

    # Rate of return on domestic shares (dividends + capital gains)
    E_rOmv_IndlAktier[t]$(tx0[t] and t.val > 1995)..
      rOmv['IndlAktier',t] =E= (vAktie[t] - vUdstedelser[t]) / (vAktie[t-1]/fv) - 1;

    # Value of domestic shares
    E_vAktie[t]$(tx0[t])..
      vAktie[t] =E= vAktiex[sTot,t] + vVirkx[t] + vAktieRes[t];

    E_vAktieRes[t]$(tx0[t])..
      vAktieRes[t] =E= rAktieRes2BVT[t] * vVirkBVT5aarSnit[t];

    E_vVirkx[t]$(tx0[t])..
      vVirkx[t] =E= fv * (1 + rOmv['IndlAktier',t]) * vVirkx[t-1]/fv + jvVirkx[t];

    E_vAktiex[sp,t]$(tx0E[t])..
      vAktiex[sp,t] =E= (vFCF[sp,t+1] + vAktiex[sp,t+1])*fv / (1+rAfkastKrav[sp,t+1]);
    E_vAktiex_tEnd[sp,t]$(tEnd[t])..
      vAktiex[sp,t] =E= (vFCF[sp,t] + vAktiex[sp,t])*fv / (1+rAfkastKrav[sp,t]);

    E_vAktiex_sTot[t]$(tx0E[t])..
      vAktiex[sTot,t] =E= (vFCF[sTot,t+1] + vAktiex[sTot,t+1])*fv / (1+rAfkastKrav[sTot,t+1]);
    E_vAktiex_sTot_tEnd[t]$(tEnd[t])..
      vAktiex[sTot,t] =E= sum(sp, vAktiex[sp,t]);

    E_rIndlAktiePrem_sTot[t]$(tx0E[t])..
      vAktiex[sTot,t] =E= sum(sp, vAktiex[sp,t]);

    # Omvurderinger af udenlandske aktier
    E_rOmv_UdlAktier[t]$(tx0[t])..
      rOmv['UdlAktier',t] + rRente['UdlAktier',t] =E= rRente['Obl',t] + rUdlAktiePrem[t] + jrOmv_UdlAktier[t];

    # Frie pengestrømme (Free Cash Flow) ekskl. fra finansiel fra portefølje
    E_vFCF_sTot[t]$(tx0[t])..
      vFCF[sTot,t] =E= vEBITDA[sTot,t]                        
                     - rRente['Obl',t] * vVirkLaan[sTot,t-1]/fv
                     - vI_s[iTot,spTot,t] + vHhInvestx[aTot,t]
                     + vVirkLaan[sTot,t] - vVirkLaan[sTot,t-1]/fv
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
                   - vI_s[iTot,sp,t] + vHhInvestx[aTot,t] * vI_s[iTot,sp,t] / sum(s$(sp[s]), vI_s[iTot,s,t]) + sameas[sp,'bol'] * vIBolig[t]
                   + vVirkLaan[sp,t] - vVirkLaan[sp,t-1]/fv
                   - vtSelskabx[sp,t]
                   # Nettooverførsler til virksomhederne
                   + (vOffLandKoeb[t]
                   - vSelvstKapInd[aTot,t]
                   + vOffTilVirk[t] - vOffFraVirk[t]        
                   - vHhFraVirk[t]
                   + vVirkIndRest[t]) * vVirkK[sp,t] / vVirkK[sTot,t];                       

    # Earnings before interests, corporate taxes, and depreciation. Payroll taxes are included in both vtNetYAfg and vL, and are added back.
    E_vEBITDA[sp,t]$(tx0[t])..
      vEBITDA[sp,t] =E= vY[sp,t] - vLoensum[sp,t] - vSelvstLoen[sp,t] - vR[sp,t] - vtNetYAfg[sp,t] 
                      - sameas[sp,'bol'] * (vLejeAfEjerBolig[t]); # Lejeværdi af egen bolig trækkes fra, da det går til husejerne

    E_vEBITDA_tot[t]$(tx0[t]).. vEBITDA[sTot,t] =E= sum(sp, vEBITDA[sp,t]);

    # Earnings before taxes
    E_vEBT_sTot[t]$(tx0[t]).. vEBT[sTot,t] =E= vEBITDA[sTot,t] - vAfskrFradrag[sTot,t]
                                             + rRente['Obl',t] * vVirk['Obl',t-1]/fv 
                                             + rRente['Bank',t] * vVirk['Bank',t-1]/fv 
                                             - rRente['RealKred',t] * vVirk['RealKred',t-1]/fv; 

    E_vEBT[sp,t]$(tx0[t]).. vEBT[sp,t] =E= vEBITDA[sp,t] - vAfskrFradrag[sp,t]
                                         + (rRente['Obl',t] * vVirk['Obl',t-1]/fv 
                                         + rRente['Bank',t] * vVirk['Bank',t-1]/fv 
                                         - rRente['RealKred',t] * vVirk['RealKred',t-1]/fv) * vVirkK[sp,t] / vVirkK[sTot,t]; 

    # Earnings before taxes ekskl. afkast på portefølje
    E_vEBTx_sTot[t]$(tx0[t])..
      vEBTx[sTot,t] =E= vEBITDA[sTot,t] - vAfskrFradrag[sTot,t] - rRente['Obl',t] * vVirkLaan[sTot,t-1]/fv;

    E_vEBTx[sp,t]$(tx0[t])..
      vEBTx[sp,t] =E= vEBITDA[sp,t] - vAfskrFradrag[sp,t]- rRente['Obl',t] * vVirkLaan[sp,t-1]/fv;

    # Den del af selskabsskat der hører til driften
    E_vtSelskabx_sTot[t]$(tx0[t])..
      vtSelskabx[sTot,t] =E= tSelskab[t] * ftSelskab[t] * vEBTx[sTot,t] + vtSelskabNord[t];
    E_vtSelskabx[sp,t]$(tx0[t])..
      vtSelskabx[sp,t] =E= tSelskab[t] * ftSelskab[t] * vEBTx[sp,t] + sameas[sp,'udv'] * vtSelskabNord[t];

    # Dividender på indenlandske aktier
    E_vDividender[t]$(tx0[t] and t.val > 1994).. vDividender[t] =E= rRente['IndlAktier',t] * vAktie[t-1]/fv;

    # Udstedelser bestemmes residualt for at ramme en eksogen dividende-rate
    E_vUdstedelser[t]$(tx0[t])..
      - vUdstedelser[t] =E= vFCF[sTot,t]
                          - (vVirkx[t] - vVirkx[t-1]/fv)
                          + rVirkxAfk[t] * vVirkx[t-1]/fv
                          - (vtSelskab[sTot,t] - vtSelskabx[sTot,t])
                          - vDividender[t];

    # Tax book value of firm shares
    E_vKskat[k,sp,t]$(tx0[t] and t.val > 1994 and d1k[k,sp,t])..
      vKskat[k,sp,t] =E= (1-rSkatAfskr[k,t]) * vKskat[k,sp,t-1]/fv + vI_s[k,sp,t] - sameas[sp,'bol'] * vIBolig[t];
    E_vKskat_kTot[t]$(tx0[t]).. vKskat[kTot,sTot,t] =E= sum([k,sp], vKskat[k,sp,t]);

    E_vAfskrFradrag[sp,t]$(tx0[t]).. vAfskrFradrag[sp,t] =E= sum(k, rSkatAfskr[k,t] * vKskat[k,sp,t-1]/fv);

    E_vAfskrFradrag_sTot[t]$(tx0[t]).. vAfskrFradrag[sTot,t] =E= sum(sp, vAfskrFradrag[sp,t]);

    # Value of financial assets and mortgages
    E_vVirk[akt,t]$(tx0[t] and not sameas['obl',akt])..
      vVirk[akt,t] =E= rvVirkx[akt,t] * vVirkx[t];

    E_vVirk_obl[t]$(tx0[t])..
      vVirk['Obl',t] =E= rvVirkx['obl',t] * vVirkx[t] - rvOblLaan2K[t] * vVirkK[sTot,t];

    E_vVirk_RealKred[t]$(tx0[t])..
      vVirk['RealKred',t] =E= rvRealKred2K[t] * vVirkK[sTot,t];

    E_rLaan2K[t]$(tx0[t]).. rLaan2K[t] =E= rvRealKred2K[t] + rvOblLaan2K[t];

    E_vVirkK[sp,t]$(tx0[t])..
      vVirkK[sp,t] =E= sum(k, pI_s[k,sp,t] * qK[k,sp,t]) - sameas[sp,'bol'] * (pI_s['iB','bol',t] * qKBolig[t]);

    E_vVirkK_sTot[t]$(tx0[t])..
      vVirkK[sTot,t] =E= sum(sp, vVirkK[sp,t]);

    E_vVirk_NetFin[t]$(tx0[t] and t.val > 1993).. vVirk['NetFin',t] =E= vVirkx[t] - vVirkLaan[sTot,t];

    E_vVirkLaan_sTot[t]$(tx0[t])..
      vVirkLaan[sTot,t] =E= rLaan2K[t] * vVirkK[sTot,t];                 

    E_vVirkLaan[sp,t]$(tx0[t])..
      vVirkLaan[sp,t] =E= rLaan2K[t] * vVirkK[sp,t];

    # Netto renteudgifter (afkast) på virksomhedens portefølje
    E_vVirkFinInd[t]$(tx0[t]).. vVirkFinInd[t] =E= sum(akt, (rRente[akt,t] + rOmv[akt,t]) * vVirk[akt,t-1]/fv)
                                                 - (rRente['RealKred',t] + rOmv['RealKred',t]) * vVirk['RealKred',t-1]/fv
                                                 - vJordrente[t]
                                                 + jvVirkOmv[t] + jvVirkRenter[t];

    E_rVirkxAfk[t]$(tx0[t] and t.val > 2015)..
      rVirkxAfk[t] =E= (vVirkFinInd[t] + rRente['Obl',t] * vVirkLaan[sTot,t-1]/fv) / (vVirkx[t-1]/fv);

    # Nettofordringserhvervelsen er tæt knyttet til FCFE
    E_vVirkNFE[t]$(tx0[t]).. vVirkNFE[t] =E= (vVirk['NetFin',t] - vAktie[t])
                                           - (vVirk['NetFin',t-1]/fv - vAktie[t-1]/fv)
                                           - vVirkOmv[t];

    E_vVirkRenter[t]$(tx0[t])..
      vVirkRenter[t] =E= sum(akt, rRente[akt,t] * vVirk[akt,t-1]/fv)
                       - rRente['RealKred',t] * vVirk['RealKred',t-1]/fv
                       - vDividender[t]
                       - vJordrente[t]
                       + jvVirkRenter[t];

    E_vVirkOmv[t]$(tx0[t])..
      vVirkOmv[t] =E= sum(akt, rOmv[akt,t] * vVirk[akt,t-1]/fv)
                    - rOmv['RealKred',t] * vVirk['RealKred',t-1]/fv 
                    - rOmv['IndlAktier',t] * vAktie[t-1]/fv
                    + jvVirkOmv[t];

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

    E_vPension_pension[t]$(tx0[t] and t.val > 1993)..
      vPension['Pens',t] =E= -vHh['Pens',aTot,t];

    E_vPension_akt[akt,t]$(tx0[t] and (sameas['Obl',akt] or sameas['IndlAktier',akt] or sameas['UdlAktier',akt]) and t.val > 1993)..
      vPension[akt,t] =E= rPensAkt[akt,t] * (-vPension['Pens',t]);

    # Realkreditrenten skal følge obligationsrenten, da passivsiden er inkluderet i virksomhedernes obligationsbeholdning - bidragssats er i FISIM
    E_rRente_RealKred[t]$(tx0[t])..
      rRente['RealKred',t] =E= rRente['Obl',t]; 

    # Indlånsrenten og obligationsrenten er korreleret
    E_rRente_Bank[t]$(tx0[t])..
      rRente['Bank',t] =E= rRente['Obl',t] + crRenteBank[t]; 

    # Indlåns- og udlånsrenten er ens, da rentemarignal er fanget i FISIM dvs. input af (finansielle) tjenester
    E_rRente_BankGaeld[t]$(tx0[t])..
      rRente['BankGaeld',t] =E= rRente['Bank',t]; 

  $ENDBLOCK
$ENDIF