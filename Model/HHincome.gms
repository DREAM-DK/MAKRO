# ======================================================================================================================
# Household income and portfolio accounting
# - See consumers.gms for consumption decisions and budget constraint
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_HHincome_quantities empty_group_dummy[t];
  $GROUP G_HHincome_prices 
    pBoligRigid[a,t]$(t.val > 2015) "Rigid boligpris til brug i rRealKred2Bolig."
  ;

  $GROUP G_HHincome_values
    vtHh[a_,t]$(atot[a_]) "Skatter knyttet til husholdningerne i MAKRO."
    vDispInd[t]$(t.val > 1994) "Disponibel bruttoindkomst i husholdninger og organisationer, Kilde: ADAM[Yd_h]"
    vHhInd[a_,t]$((a0t100[a_] and t.val > 2015) or atot[a_]) "Husholdningernes indkomst."

    vHhxAfk[a_,t]$((aVal[a_] > 0 and t.val > 2015) or (atot[a_] and t.val > 1994)) "Imputeret afkast på husholdningernes formue ekskl. bolig og pension."

    vHhFinAkt[a_,t]$(t.val > 2015 or atot[a_]) "Finansielle aktiver ejer af husholdningerne ekskl. pension."
    vHh[portf_,a_,t]$(0) "Husholdningernes finansielle portefølje, Kilde: jf. se for portefølje."
    vHh$(sameas[portf_, "NetFin"] and t.val > 2015) ""
    vHh$(sameas[portf_, "RealKred"] and (a18t100[a_] or aTot[a_]) and t.val > 2015) ""
    vHh$(pens[portf_] and (a15t100[a_] or aTot[a_]) and t.val > 2015) ""
    vHh$(sameas[portf_, "pens"] and (a15t100[a_] or aTot[a_]) and t.val > 2015) ""
    vHh$(sameas[portf_, "BankGaeld"] and t.val > 2015 or (sameas[portf_,'BankGaeld'] and atot[a_]) ) ""
    vHh$(fin_akt[portf_] and t.val > 2015) ""

    vHhRenter[portf_,t]$(t.val > 2015) "Husholdningernes formueindkomst, Kilde: ADAM[Tin_h]"
    vHhOmv[portf_,t]$(t.val > 2015) "Omvurderinger på husholdningernes finansielle nettoformue, Kilde: ADAM[Wn_h]-ADAM[Wn_h][-1]-ADAM[Tfn_h]"
    vHhPensAfk[portf_,a_,t]$((pens[portf_] or sameas['Pens',portf_]) and (aVal[a_] >= 15 or atot[a_]) and t.val > 2015) "Afkast fra pensionsformue EFTER SKAT."

    vHhNFE[t] "Nettofordringserhvervelse for husholdningerne, Kilde: ADAM[Tfn_h]"

    vPensIndb[portf_,a_,t]$(pens_[portf_] and (a15t100[a_] or atot[a_]) and t.val > 2015) "Pensionsindbetalinger."
    vPensUdb[portf_,a_,t]$(pens_[portf_] and (a15t100[a_] or atot[a_]) and t.val > 2015) "Pensionsudbetalinger."
    vPensArv[portf_,a_,t]$(pens_[portf_] and (aVal[a_] >= 15 or aTot[a_]) and t.val > 2015) "Pension udbetalt til arvinger i tilfælde af død."

    vNetIndPensUdb[t] "Nettopensionsudbetalinger til individuelle pensionsordninger."
    vNetKolPensUdb[t] "Nettopensionsudbetalinger til kollektive pensionsordninger."
    vKolPensRenter[t] "Afkast ekskl. omvurderinger fra kollektive pensionsordninger."
    vLejeAfEjerBolig[t] "Imputeret værdi af lejeværdi af egen bolig, Kilde: ADAM[byrhh] * ADAM[Yrh]"
    vHhFraVirkKap[t] "Nettokapitaloverførsler fra virksomhederne til husholdningerne, Kilde: ADAM[Tknr_h]"
    vHhFraVirkOev[t] "Øvrige nettooverførsler fra virksomhederne til husholdningerne, Kilde: ADAM[Trn_h] - ADAM[Tr_o_h] + ADAM[Trks] + ADAM[Trr_hc_o]"
    vHhFraVirk[t] "Andre nettooverførsler fra virksomhederne til husholdningerne, Kilde: ADAM[Tknr_h] + ADAM[Trn_h] - ADAM[Tr_o_h] + ADAM[Trks] + ADAM[Trr_hc_o]"
    vHhTilUdl[t] "Skat til udlandet og nettopensionsbetalinger til udlandet, Kilde: ADAM[Syn_e] + (ADAM[Typc_cf_e] - ADAM[Tpc_e_z]) - ADAM[Typc_e_h] - ADAM[Tpc_h_e]"
  ;
  $GROUP G_HHincome_endo
    G_HHincome_quantities
    G_HHincome_prices
    G_HHincome_values
    mrHhxAfk[t]$(t.val > 2015) "Marginalt afkast efter skat på vHhx (husholdningernes formue ekskl. pension, bolig og realkreditgæld)."
    mrRealKredAfk[t]$(t.val > 2015) "Husholdningernes effektive marginalrente efter skat på realkredit."
    rRealKred2Bolig[a_,t]$((atot[a_] or a18t100[a_]) and t.val > 2015) "Husholdningernes realkreditgæld relativt til deres boligformue."
    rPensIndb[pens,a_,t]$(atot[a_] and t.val > 2015) "Pensionsindbetalingsrate."
    rPensUdb[pens,a_,t]$(atot[a_] and not (sameas['Alder',pens] and t.val < 2014) and t.val > 2015) "Pensionsudbetalingsrate" # Alderspensionen eksisterer først fra 2013 og frem
    rBoligOmkRest[t] "Øvrige ejerboligomkostninger ift. boligens værdi."
    rHhAfk[portf,t] "Husholdningens samlede afkast for aktive/passiv typen."
    jvHhxAfk[a_,t]$(aTot[a_] and t.val > 2015) "J-led."
    jvHhPensAfk[portf_,a_,t]$(((pens[portf_] and atot[a_]) or sameas['Pens',portf_]) and t.val > 2015) "j-led."
    jvHh[t]$(t.val > 2015) "Fejl-led som bør være nul fra inkonsistens mellem top-down og buttom-up formue."
    mtAktie[t]$(t.val > 2015) "Marginal skat på aktieafkast."
  ;
  $GROUP G_HHincome_endo G_HHincome_endo$(tx0[t]); # Restrict endo group to tx0[t]

  $GROUP G_HHincome_exogenous_forecast
    ErAktieAfk_static[t] "Husholdningernes forventede aktieafkast i historisk periode."
    rPensIndb[pens,a_,t]$(a[a_]) "Pensionsindbetalingsrate."
    rPensUdb[pens,a_,t]$(a[a_]) "Pensionsudbetalingsrate."
    rPensArv[pens,a_,t] "Andel af pensionsformue, som udbetales i tilfælde af død."

    # Forecast as zero:
    jvHhxAfk[a_,t]$(a[a_]) "J-led."
    jvHhOmv[t] "J-led."
    jvHhRenter[t] "J-led."
    jvhhpensafk[portf_,a_,t] "J-led."
    jvNetKolPensUdb[t] "J-led."
    jvKolPensRenter[t] "J-led."
    jmrHhAfk[t] "J-led."

    jrHhRente[portf,t] "J-led som dækker forskel mellem husholdningens rente og den gennemsnitlige rente på aktivet/passivet."
    jrHhOmv[portf,t] "J-led som dækker forskel mellem husholdningens rente og den gennemsnitlige omvurdering på aktivet/passivet."
  ;

  $GROUP G_HHincome_other
    # Portfolio
    rtTopRenter[t] "Andel af renteindtægter, der betales topskat af."
    mrNet2KapIndPos[t] "Marginal stigning i positiv nettokapitalindkomst ved stigning i kapitalindkomst"
    rKolPens[pens,t] "Andel af pensionsformue i kollektive ordninger."
    rHhFraVirkKap[t] "Nettokapitaloverførsler fra virksomhederne til husholdningerne ift. BNP."
    rHhFraVirkOev[t] "Andre nettooverførsler fra virksomhederne til husholdningerne ift. BNP."
    rHhTilUdl[t] "Andre nettooverførsler fra virksomhederne til udlandet ift. BNP."
    cHh_a[akt,a,t] "Aldersafhængigt additivt led i husholdningens aktiv-beholdninger, vHh[akt]."
    cHh_t[akt,t] "Tidsvariant additivt led i husholdningens aktiv-beholdninger, vHh[akt]."
    dvHh2dvHhx[portf_,t] "Ændring i husholdningens aktiv-beholdninger, vHh[akt], for en ændring i formuen vHhx (eksklusiv pension og bolig)."
    dvHh2dvBolig[portf_,t] "Ændring i husholdningens aktiv-beholdninger, vHh[akt], for en ændring i bolig-formuen vBolig."
    dvHh2dvPensIndb[portf_,t] "Ændring i husholdningens aktiv-beholdninger, vHh[akt], for en ændring i pensions-formuen vHh['Pens']."
    rBoligOmkRestRes[t] "Øvrige ejerboligomkostninger ift. boligens værdi - residual efter materialer, løn og ejendomsskat."
    rRealKredTraeg            "Træghed i pBoligRigid."
    rRealKred2Bolig_a[a,t] "Aldersspecifikt led i husholdningernes langsigtede realkreditgæld relativt til deres boligformue."
    rRealKred2Bolig_t[t] "Tidsvariant led i husholdningernes langsigtede realkreditgæld relativt til deres boligformue."
    cmtAktie[t] "Forskel mellem gennemsnitlig og marginal skat på aktieafkast."
  ;
$ENDIF

# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_HHincome
    # Disposable income (gælder fra 1994 - manglende data fra før dette år)
    E_vDispInd[t]$(tx0[t] and t.val > 1994).. vDispInd[t] =E= vWHh[aTot,t] 
                                                            + vSelvstKapInd[aTot,t]
                                                            + vOvf['hh',t]
                                                            - vtHh[aTot,t] + vtArv[aTot,t]
                                                            + vHhRenter['NetFin',t] - vKolPensRenter[t]
                                                            + vNetKolPensUdb[t]
                                                            + vLejeAfEjerBolig[t]
                                                            + vOffTilHhOev[t] - vOffFraHh[t]
                                                            + vHhFraVirkOev[t] - vHhTilUdl[t];

    E_vLejeAfEjerBolig[t]$(tx0[t])..
      vLejeAfEjerBolig[t] =E= pC['cBol',t] * qC['cBol',t]
                            - vCLejeBolig[aTot,t]
                            - rBoligOmkRest[t] * vBolig[aTot,t-1]/fv;

    # Nettopensionsudbetalinger opdeles i kollektive og individuelle ordninger for at beregne disponibel indkomst
    E_vNetKolPensUdb[t]$(tx0[t])..
      vNetKolPensUdb[t] =E= sum(pens, rKolPens[pens,t] * (vPensUdb[pens,aTot,t] - vPensIndb[pens,aTot,t]))
                          + jvNetKolPensUdb[t]; 

    E_vNetIndPensUdb[t]$(tx0[t])..
      vNetIndPensUdb[t] =E= vPensUdb['Pens',aTot,t] - vPensIndb['Pens',aTot,t] - vNetKolPensUdb[t];

    E_vKolPensRenter[t]$(tx0[t])..
      vKolPensRenter[t] =E= sum(pens, rKolPens[pens,t] * vHh[pens,aTot,t-1]/fv)
                          * (1 - tPAL[t] * ftPAL[t]) * rRente['Pens',t] + jvKolPensRenter[t]; 

    # Household income net of taxes and capital income
    E_vHhInd_aTot[t]$(tx0[t])..
      vHhInd[aTot,t] =E= vWHh[aTot,t]
                       + vOvf['hh',t]
                       + (vPensUdb['Pens',aTot,t]  - vPensArv['Pens',aTot,t]) - vPensIndb['Pens',aTot,t]
                       - vtHhx[aTot,t]
                       + vArv[aTot,t] + vArvKorrektion[aTot,t]
                       + vHhNFErest[aTot,t];

    E_vHhInd[a,t]$(tx0[t] and a0t100[a] and t.val > 2015)..
      vHhInd[a,t] =E= vWHh[a,t] * nLHh[a,t] / nPop[a,t]
                    + vHhOvf[a,t]
                    + vPensUdb['Pens',a,t] - vPensIndb['Pens',a,t]
                    - vtHhx[a,t]
                    + vArv[a,t] + vArvKorrektion[a,t]
                    + vHhNFErest[a,t];

    E_vtHh_aTot[t]$(tx0[t]).. vtHh[aTot,t] =E= vtKilde[t] 
                                             + vtHhAM[aTot,t]
                                             + vtPersRest[aTot,t]
                                             + vtHhVaegt[aTot,t]                
                                             + vtPAL[t]
                                             + vtMedie[t]
                                             + vtArv[aTot,t]
                                             + vBidrag[aTot,t]
                                             + vtKirke[aTot,t]
                                             + vtDirekteRest[t] + vtLukning[aTot,t];

    E_rBoligOmkRest[t]$(tx0[t])..
      rBoligOmkRest[t] =E= (vR['bol',t] + vLoensum['bol',t] + vSelvstLoen['bol',t] + vtGrund['bol',t])
                           * qKBolig[t-1] / qK['iB','bol',t-1] / (vBolig[aTot,t-1]/fv) 
                           + rBoligOmkRestRes[t];

    # Other transfers
    E_vHhFraVirkKap[t]$(tx0[t])..
      vHhFraVirkKap[t] =E= rHhFraVirkKap[t] * vBNP[t]; 

    E_vHhFraVirkOev[t]$(tx0[t])..
      vHhFraVirkOev[t] =E= rHhFraVirkOev[t] * vBNP[t]; 

    E_vHhFraVirk[t]$(tx0[t])..
      vHhFraVirk[t] =E= vHhFraVirkKap[t] + vHhFraVirkOev[t]; 

    E_vHhTilUdl[t]$(tx0[t])..
      vHhTilUdl[t] =E= rHhTilUdl[t] * vBNP[t]; 

    # ------------------------------------------------------------------------------------------------------------------
    # Portfolio and capital income
    # ------------------------------------------------------------------------------------------------------------------
    # Marginalt afkast efter skat på vHhx (husholdningernes formue ekskl. pension, bolig og realkreditgæld) 
    E_mrHhAfk[t]$(tx0[t] and t.val > 2015)..
      mrHhxAfk[t] =E= 
      ( dvHh2dvHhx['IndlAktier',t-1] * rHhAfk['IndlAktier',t]
        + dvHh2dvHhx['UdlAktier',t-1] * rHhAfk['UdlAktier',t]
      ) * (1-tAktie[t])  
      + ( dvHh2dvHhx['Obl',t-1] * rHhAfk['obl',t]
        + dvHh2dvHhx['Bank',t-1] * rHhAfk['Bank',t]
        - dvHh2dvHhx['BankGaeld',t-1] * rHhAfk['BankGaeld',t]
      ) * (1 - tKommune[t] - mrNet2KapIndPos[t] * (tBund[t] + tTop[t] * rtTopRenter[t]))
      + jmrHhAfk[t];

    E_mrRealKredAfk[t]$(tx0[t] and t.val > 2015)..
      mrRealKredAfk[t] =E= rHhAfk['RealKred',t]
                           * (1 - tKommune[t] - mrNet2KapIndPos[t] * (tBund[t] + tTop[t] * rtTopRenter[t]));

    E_mtAktie[t]$(tx0[t] and t.val > 2015).. mtAktie[t] =E= tAktie[t] + cmtAktie[t];

    E_rHhAfk[portf,t]$(tx0[t] and t.val > 1994)..
      rHhAfk[portf,t] =E= rRente[portf,t] + jrHhRente[portf,t] + rOmv[portf,t] + jrHhOmv[portf,t];

    # Net capital income
    E_vHhxAfk[a,t]$(a.val > 0 and tx0[t] and t.val > 2015)..
      vHhxAfk[a,t] =E= sum(akt$(not sameas[akt,'Pens']), rHhAfk[akt,t] * vHh[akt,a-1,t-1]/fv)
                     - rHhAfk['BankGaeld',t] * vHh['BankGaeld',a-1,t-1]/fv 
                     + jvHhxAfk[a,t];
    E_vHhxAfk_aTot[t]$(tx0[t] and t.val > 1994)..
      vHhxAfk[aTot,t] =E= sum(akt$(not sameas[akt,'Pens']), rHhAfk[akt,t] * vHh[akt,aTot,t-1]/fv)
                        - rHhAfk['BankGaeld',t] * vHh['BankGaeld',aTot,t-1]/fv 
                        + jvHhxAfk[aTot,t];
    E_jvHhxAfk_aTot[t]$(tx0[t] and t.val > 2015)..
      jvHhxAfk[aTot,t] =E= sum(a$(a.val > 0), jvHhxAfk[a,t] * nPop[a-1,t-1]);

    E_vHhRenter_akt[akt,t]$(tx0[t] and t.val > 1994)..
      vHhRenter[akt,t] =E= (rRente[akt,t] + jrHhRente[akt,t]) * vHh[akt,atot,t-1]/fv;
    E_vHhRenter_pas[pas,t]$(tx0[t] and t.val > 1994)..
      vHhRenter[pas,t] =E= (rRente[pas,t] + jrHhRente[pas,t]) * vHh[pas,atot,t-1]/fv;
    E_vHhRenter_NetFin[t]$(tx0[t] and t.val > 1994)..
      vHhRenter['NetFin',t] =E= sum(akt, vHhRenter[akt,t]) - sum(pas, vHhRenter[pas,t]) + jvHhRenter[t];

    E_vHhOmv_akt[akt,t]$(tx0[t] and t.val > 1994)..
      vHhOmv[akt,t] =E= (rOmv[akt,t] + jrHhOmv[akt,t]) * vHh[akt,atot,t-1]/fv;
    E_vHhOmv_pas[pas,t]$(tx0[t] and t.val > 1994)..
      vHhOmv[pas,t] =E= (rOmv[pas,t] + jrHhOmv[pas,t]) * vHh[pas,atot,t-1]/fv;
    E_vHhOmv_NetFin[t]$(tx0[t] and t.val > 1994)..
      vHhOmv['NetFin',t] =E= sum(akt, vHhOmv[akt,t]) - sum(pas, vHhOmv[pas,t]) + jvHhOmv[t];

    E_vHh_NetFin[a,t]$(tx0[t] and t.val > 2015)..
      vHh['NetFin',a,t] =E= vHhx[a,t] + vHh['Pens',a,t] - vHh['RealKred',a,t];

    E_vHh_NetFin_aTot[t]$(tx0[t] and t.val > 2015)..
      vHh['NetFin',aTot,t] =E= vHh['NetFin',aTot,t-1]/fv 
                             + vHhRenter['NetFin',t] + vHhOmv['NetFin',t]
                             + vWHh[aTot,t]
                             + vOvf['hh',t]
                             + vHhNFErest[aTot,t]
                             - vtHh[aTot,t]
                             - (vC[cTot,t] - vLejeAfEjerBolig[t]) # = -(pC['cIkkeBol',t] * qC_a[aTot,t] + vCLejeBolig[aTot,t] + rBoligOmkRest[t] * vBolig[aTot,t-1]/fv)
                             - vIBolig[t]    # Boliginvesteringer
                             + jvHh[t]; # Fejl-led                  

    E_jvHh[t]$(tx0[t] and t.val > 2015)..
      vHh['NetFin',aTot,t] =E= sum(a, vHh['NetFin',a,t] * nPop[a,t]); 

    E_pBoligRigid_a18[a,t]$(a.val = 18 and tx0[t] and t.val > 2015)..
      pBoligRigid[a,t] =E= (1-rRealKredTraeg) * pBolig[t] + rRealKredTraeg * pBoligRigid[a,t-1]/fp;

    E_pBoligRigid[a,t]$(18 < a.val and a.val <= 100 and tx0[t] and t.val > 2015)..
      pBoligRigid[a,t] =E= (1 - qBolig[a-1,t-1]/fq / qBolig[a,t]) * pBolig[t]
                         + qBolig[a-1,t-1]/fq / qBolig[a,t]
                         * ((1-rRealKredTraeg) * pBolig[t] + rRealKredTraeg * pBoligRigid[a-1,t-1]/fp);

    E_vHh_RealKred[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      vHh['RealKred',a,t] =E= rRealKred2Bolig[a,t] * vBolig[a,t];
    E_vHh_RealKred_aTot[t]$(tx0[t] and t.val > 2015)..
      vHh['RealKred',aTot,t] =E= rRealKred2Bolig[aTot,t] * vBolig[aTot,t];

    E_rRealKred2Bolig[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      rRealKred2Bolig[a,t] =E= (rRealKred2Bolig_a[a,t] + rRealKred2Bolig_t[t]) * pBoligRigid[a,t] / pBolig[t];

    E_rRealKred2Bolig_aTot[t]$(tx0[t] and t.val > 2015)..
      rRealKred2Bolig[aTot,t] =E= sum(a, vHh['RealKred',a,t] * nPop[a,t]) / vBolig[aTot,t];

    # Pensionsbeholdning samt afkast og ind- og udbetalinger
    E_vHhPensAfk[pens,a,t]$(a.val >= 15 and tx0[t] and t.val > 2015)..
      vHhPensAfk[pens,a,t] =E= (1 - tPAL[t] * ftPAL[t]) * rHhAfk['Pens',t] * vHh[pens,a-1,t-1]/fv 
                             + jvHhPensAfk[pens,a,t];
    E_vHhPensAfk_aTot[pens,t]$(tx0[t] and t.val > 2015)..
      vHhPensAfk[pens,aTot,t] =E= (1 - tPAL[t] * ftPAL[t]) * rHhAfk['Pens',t] * vHh[pens,aTot,t-1]/fv
                                + jvHhPensAfk[pens,aTot,t];
    E_jvHhPensAfk_aTot[pens,t]$(tx0[t] and t.val > 2015)..
      jvHhPensAfk[pens,aTot,t] =E= sum(a, jvHhPensAfk[pens,a,t] * nPop[a-1,t-1]);
    E_jvHhPensAfk_pens[a,t]$(tx0[t] and t.val > 2015)..
      jvHhPensAfk['Pens',a,t] =E= sum(pens, jvHhPensAfk[pens,a,t]);
    E_jvHhPensAfk_pens_atot[t]$(tx0[t] and t.val > 2015)..
      jvHhPensAfk['Pens',aTot,t] =E= sum(pens, jvHhPensAfk[pens,aTot,t]);

    E_vHh_pens[pens,a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vHh[pens,a,t] =E= (vHh[pens,a-1,t-1]/fv + vHhPensAfk[pens,a,t] - vPensArv[pens,a,t] * (1-rOverlev[a-1,t-1]))
                      * nPop[a-1,t-1] / nPop[a,t]
                      + vPensIndb[pens,a,t] - vPensUdb[pens,a,t];
    # Formue og afkast ganges med nPop[a-1,t-1]/nPop[a,t], da der udbetales bonus alt efter, hvor mange der overlever
    E_vHh_pens_aTot[pens,t]$(tx0[t] and t.val > 2015)..
      vHh[pens,aTot,t] =E= vHh[pens,aTot,t-1]/fv 
                         + vHhPensAfk[pens,aTot,t]
                         + vPensIndb[pens,aTot,t]
                         - vPensUdb[pens,aTot,t];

    # Pensionsindbetalinger
    E_vPensIndb[pens,a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vPensIndb[pens,a,t] =E= rPensIndb[pens,a,t] * vWHh[a,t] * nLHh[a,t] / nPop[a,t];
    E_vPensIndb_aTot[pens,t]$(tx0[t] and t.val > 2015)..
      vPensIndb[pens,aTot,t] =E= rPensIndb[pens,aTot,t] * vWHh[aTot,t];
    E_rPensIndb_aTot[pens,t]$(tx0[t] and t.val > 2015)..
      rPensIndb[pens,aTot,t] * vWHh[aTot,t] =E= sum(a, vPensIndb[pens,a,t] * nPop[a,t]);

    # Pensionsudbetalinger til levende og døde
    E_vPensUdb[pens,a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vPensUdb[pens,a,t] * (1-rPensUdb[pens,a,t]) =E= rPensUdb[pens,a,t] * vHh[pens,a,t];

    E_vPensArv[pens,a,t]$(a.val >= 15 and tx0[t] and t.val > 2015)..
      vPensArv[pens,a,t] =E= rPensArv[pens,a,t] * (vHh[pens,a-1,t-1]/fv + vHhPensAfk[pens,a,t]);
    E_vPensArv_aTot[pens,t]$(tx0[t] and t.val > 2015)..
      vPensArv[pens,aTot,t] =E= sum(a, vPensArv[pens,a,t] * nPop[a-1,t-1] * (1-rOverlev[a-1,t-1]));

    E_vPensUdb_aTot[pens,t]$(tx0[t] and t.val > 2015)..
      vPensUdb[pens,aTot,t] * (1-rPensUdb[pens,aTot,t]) =E= rPensUdb[pens,aTot,t] * vHh[pens,aTot,t];
    E_rPensUdb_aTot[pens,t]$(tx0[t] and not (sameas['Alder',pens] and t.val < 2014) and t.val > 2015)..  # Alderspensionen eksisterer først fra 2013 og frem
      vPensUdb[pens,aTot,t] =E= sum(a, vPensUdb[pens,a,t] * nPop[a,t]) + vPensArv[pens,aTot,t];

    E_vHh_pension[a,t]$(a15t100[a] and tx0[t] and t.val > 2015).. vHh['Pens',a,t] =E= sum(pens, vHh[pens,a,t]);
    E_vHh_pension_aTot[t]$(tx0[t] and t.val > 2015).. vHh['Pens',aTot,t] =E= sum(pens, vHh[pens,aTot,t]);

    E_vPensIndb_pension[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vPensIndb['Pens',a,t] =E= sum(pens, vPensIndb[pens,a,t]);
    E_vPensIndb_pension_aTot[t]$(tx0[t] and t.val > 2015)..
      vPensIndb['Pens',aTot,t] =E= sum(pens, vPensIndb[pens,aTot,t]);

    E_vPensUdb_pension[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vPensUdb['Pens',a,t] =E= sum(pens, vPensUdb[pens,a,t]);
    E_vPensUdb_pension_aTot[t]$(tx0[t] and t.val > 2015)..
      vPensUdb['Pens',aTot,t]   =E= sum(pens, vPensUdb[pens,aTot,t]);

    E_vPensArv_pension[a,t]$(a.val >= 15 and tx0[t] and t.val > 2015)..
      vPensArv['Pens',a,t] =E= sum(pens, vPensArv[pens,a,t]);
    E_vPensArv_pension_aTot[t]$(tx0[t] and t.val > 2015)..
      vPensArv['Pens',aTot,t]   =E= sum(pens, vPensArv[pens,aTot,t]);

    E_vHhPensAfk_pension[a,t]$(a.val >= 15 and tx0[t] and t.val > 2015)..
      vHhPensAfk['Pens',a,t] =E= sum(pens, vHhPensAfk[pens,a,t]);
    E_vHhPensAfk_pension_aTot[t]$(tx0[t] and t.val > 2015)..
      vHhPensAfk['Pens',aTot,t] =E= sum(pens, vHhPensAfk[pens,aTot,t]);

    # vHhx opdeles i aktiver og bankgæld
    E_vHh_BankGaeld[a,t]$(tx0[t] and t.val > 2015)..
      vHh['BankGaeld',a,t] =E= vHhFinAkt[a,t] - vHhx[a,t];
    E_vHh_BankGaeld_aTot[t]$(tx0[t])..
      vHh['BankGaeld',aTot,t] =E= vHhFinAkt[aTot,t] - vHhx[aTot,t];

    # Financial assets are split into portfolio: vHhFinAkt = vHhIndlAktier + vHhUdlAktier + vHhObl + vHhbanks
    E_vHhFinAkt[a,t]$(tx0[t] and t.val > 2015)..
      vHhFinAkt[a,t] =E= vHh['Bank',a,t] + vHh['IndlAktier',a,t] + vHh['UdlAktier',a,t] + vHh['obl',a,t];

    E_vHhFinAkt_aTot[t]$(tx0[t])..
      vHhFinAkt[aTot,t] =E= vHh['Bank',aTot,t] + vHh['IndlAktier',aTot,t] + vHh['UdlAktier',aTot,t] + vHh['obl',aTot,t];

    E_vHh_akt[akt,a,t]$(tx0[t] and fin_akt[akt] and t.val > 2015)..
      vHh[akt,a,t] =E= (cHh_a[akt,a,t] + cHh_t[akt,t]) * vBVT2hLsnit[t]
                     + dvHh2dvHhx[akt,t] * vHhx[a,t]
                     + dvHh2dvBolig[akt,t]  * (vHhx[aTot,t]/vBolig[aTot,t]) * pBoligRigid[a,t] * qBoligR[a,t]
                     + dvHh2dvPensIndb[akt,t] * vHhx[aTot,t]/vPensIndb['Pens',aTot,t] * vPensIndb['Pens',a,t];

    E_vHh_aTot[akt,t]$(tx0[t] and fin_akt[akt] and t.val > 2015)..
      vHh[akt,aTot,t] =E= sum(a, vHh[akt,a,t] * nPop[a,t]);

    E_vHhNFE[t]$(tx0[t])..
      vHhNFE[t] =E= vHh['NetFin',aTot,t] - vHh['NetFin',aTot,t-1]/fv - vHhOmv['NetFin',t];
  $ENDBLOCK
$ENDIF