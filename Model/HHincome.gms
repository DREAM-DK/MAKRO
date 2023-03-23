# ======================================================================================================================
# Household income and portfolio accounting
# - See consumers.gms for consumption decisions and budget constraint
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_HHincome_prices_endo 
    pBoligRigid[t]$(t.val > 2015) "Rigid boligpris til brug i rRealKred2Bolig."
  ;

  $GROUP G_HHincome_quantities_endo 
    empty_group_dummy[t]
  ;

  $GROUP G_HHincome_values_endo_a
    vHh[portf_,a_,t]$(0) "Husholdningernes finansielle portefølje, Kilde: jf. se for portefølje."
    vHh[portf_,a_,t]$(NetFin[portf_] and t.val > 2015 and a[a_]) ""
    vHh[portf_,a_,t]$(RealKred[portf_] and (a18t100[a_]) and t.val > 2015) ""
    vHh[portf_,a_,t]$(BankGaeld[portf_] and t.val > 2015 and a[a_]) ""
    vHh[portf_,a_,t]$(fin_akt[portf_] and t.val > 2015 and a[a_]) ""
    vHh[portf_,a_,t]$(pens[portf_] and (a15t100[a_]) and t.val > 2015) ""
    vHh[portf_,a_,t]$(pensTot[portf_] and (a15t100[a_]) and t.val > 2015) ""

    vHhInd[a_,t]$((a0t100[a_] and t.val > 2015)) "Husholdningernes løbende indkomst efter skat (ekslusiv kapitalindkomst)."
    vtHhx[a_,t]$(a0t100[a_] and t.val > 2015) "Skatter knyttet til husholdningerne ekskl. pensionsafkastskat, ejendomsværdiskat og dødsboskat."
    vHhNFErest[a_,t]$(a0t100[a_] and t.val > 2015) "Kapitaloverførsler, direkte investeringer mv., som bliver residualt aldersfordelt."
    vHhFinAkt[a_,t]$(t.val > 2015 and a[a_]) "Finansielle aktiver ejer af husholdningerne ekskl. pension."
    vHhxAfk[a_,t]$((aVal[a_] > 0 and t.val > 2015)) "Imputeret afkast på husholdningernes formue ekskl. bolig og pension."
    vHhPensAfk[portf_,a_,t]$((pens[portf_] or pensTot[portf_]) and (aVal[a_] >= 15) and t.val > 2015) "Afkast fra pensionsformue EFTER SKAT."
    vHhPensIndb[portf_,a_,t]$(pens_[portf_] and (a15t100[a_]) and t.val > 2015) "Pensionsindbetalinger fra husholdningerne."
    vHhPensUdb[portf_,a_,t]$(pens_[portf_] and (a15t100[a_]) and t.val > 2015) "Pensionsudbetalinger til husholdningerne."
    vPensArv[portf_,a_,t]$(pens_[portf_] and (aVal[a_] >= 15) and t.val > 2015) "Pension udbetalt til arvinger i tilfælde af død."
    vHhFormue[a_,t]$((a0t100[a_] and t.val > 2015)) "Samlet formue inklusiv bolig."
    vHhPens[a_,t]$(a0t100[a_] or aTot[a_]) "Pensionsformue EFTER SKAT"  
    vHhFormueR[a_,t]$(a0t100[a_] or aTot[a_]) "Samlet formue inklusiv bolig for fremadskuende husholdninger."
    vHhPensR[a_,t]$(a0t100[a_] or aTot[a_]) "Pensionsformue for fremadskuende husholdninger EFTER SKAT."
    vFrivaerdiR[a_,t]$(a0t100[a_] or aTot[a_]) "Friværdi (boligværdi fratrukket realkreditgæld) for fremadskuende husholdninger."
    vHhIndMvR[a_,t]$(a0t100[a_] or aTot[a_]) "Fremadskuende husholdningers indkomst og lån i friværdi."
    vHhNetFinR[a_,t]$(a0t100[a_] or aTot[a_]) "Finansiel nettoformue for fremadskuende husholdninger."
    vBoligR[a_,t]$((a18t100[a_] or aTot[a_]) and t.val > 2015) "Fremadskuende husholdningernes boligformue."
    vHhFormueHtM[a_,t]$(a0t100[a_] or aTot[a_]) "Samlet formue inklusiv bolig for HtM-husholdninger."
    vHhPensHtM[a_,t]$(a0t100[a_] or aTot[a_]) "Pensionsformue for HtM-husholdninger EFTER SKAT."
    vFrivaerdiHtM[a_,t]$(a0t100[a_] or aTot[a_]) "Friværdi (boligværdi fratrukket realkreditgæld) for HtM-husholdninger."
    vHhIndMvHtM[a_,t]$(a0t100[a_] or aTot[a_]) "HtM-husholdningers indkomst og lån i friværdi."
    vHhNetFinHtM[a_,t]$(a0t100[a_] or aTot[a_]) "Finansiel nettoformue for HtM-husholdninger."
    vHhIndMv[a_,t]$(a0t100[a_] or aTot[a_]) "Husholdningers indkomst og lån i friværdi."

    jvHhxAfk[a_,t]$(aTot[a_] and t.val > 2015) "J-led."
    jvHhPensAfk[portf_,a_,t]$(pens[portf_] and aTot[a_] and t.val > 2015) "Aldersfordelt additivt j-led"
  ;

  $GROUP G_HHIncome_values_endo 
    G_HHincome_values_endo_a

    vtHh[a_,t]$(aTot[a_]) "Skatter knyttet til husholdningerne."
    vDispInd[t]$(t.val > 1994) "Disponibel bruttoindkomst i husholdninger og organisationer, Kilde: ADAM[Yd_h]"
    vHhInd[a_,t]$(aTot[a_]) "Husholdningernes løbende indkomst efter skat (ekslusiv kapitalindkomst)."

    vHhxAfk[a_,t]$((aTot[a_] and t.val > 1994)) "Imputeret afkast på husholdningernes formue ekskl. bolig og pension."
    vtHhx[a_,t]$(aTot[a_]) "Skatter knyttet til husholdningerne ekskl. pensionsafkastskat, ejendomsværdiskat og dødsboskat."

    vHhFinAkt[a_,t]$(aTot[a_]) "Finansielle aktiver ejer af husholdningerne ekskl. pension."

    vHh[portf_,a_,t]$(NetFin[portf_] and t.val > 2015 and aTot[a_]) ""
    vHh[portf_,a_,t]$(RealKred[portf_] and aTot[a_]) ""
    vHh[portf_,a_,t]$(pens[portf_] and (aTot[a_]) and t.val > 2015) ""
    vHh[portf_,a_,t]$(pensTot[portf_] and (aTot[a_]) and t.val > 2015) ""
    vHh[portf_,a_,t]$((BankGaeld[portf_] and aTot[a_])) ""
    vHh[portf_,a_,t]$(fin_akt[portf_] and t.val > 2015 and aTot[a_]) ""

    vHhRenter[portf_,t]$(t.val > 1994) "Husholdningernes formueindkomst, Kilde: ADAM[Tin_h]"
    vHhOmv[portf_,t]$(t.val > 1994) "Omvurderinger på husholdningernes finansielle nettoformue, Kilde: ADAM[Wn_h]-ADAM[Wn_h][-1]-ADAM[Tfn_h]"
    vHhPensAfk[portf_,a_,t]$((pens[portf_] or pensTot[portf_]) and (aTot[a_]) and t.val > 2015) "Afkast fra pensionsformue EFTER SKAT."

    vHhNFE[t]$(t.val > 1994) "Nettofordringserhvervelse for husholdningerne, Kilde: ADAM[Tfn_h]"
    vHhNFErest[a_,t]$((aTot[a_] and t.val > 2015)) "Kapitaloverførsler, direkte investeringer mv., som bliver residualt aldersfordelt."

    vHhPensIndb[portf_,a_,t]$(pens_[portf_] and (aTot[a_]) and t.val > 2015) "Pensionsindbetalinger fra husholdningerne."
    vHhPensUdb[portf_,a_,t]$(pens_[portf_] and (aTot[a_]) and t.val > 2015) "Pensionsudbetalinger til husholdningerne."
    vPensArv[portf_,a_,t]$(pens_[portf_] and (aTot[a_]) and t.val > 2015) "Pension udbetalt til arvinger i tilfælde af død."

    vKolPensKor[t] "Korrektion til disponibel indkomst, da nettoudbetalinger til kolletiv pension og ikke afkast fra denne indgår"
    vLejeAfEjerBolig[t] "Imputeret værdi af lejeværdi af egen bolig, Kilde: ADAM[byrhh] * ADAM[Yrh]"
    vHhFraVirkKap[t] "Nettokapitaloverførsler fra virksomhederne til husholdningerne, Kilde: ADAM[Tknr_h]"
    vHhFraVirkOev[t] "Øvrige nettooverførsler fra virksomhederne til husholdningerne, Kilde: ADAM[Trn_h] - ADAM[Tr_o_h] + ADAM[Trks] + ADAM[Trr_hc_o]"
    vHhFraVirk[t] "Andre nettooverførsler fra virksomhederne til husholdningerne, Kilde: ADAM[Tknr_h] + ADAM[Trn_h] - ADAM[Tr_o_h] + ADAM[Trks] + ADAM[Trr_hc_o]"
    vHhTilUdl[t] "Skat til udlandet og nettopensionsbetalinger til udlandet, Kilde: ADAM[Syn_e] + (ADAM[Typc_cf_e] - ADAM[Tpc_e_z]) - ADAM[Typc_e_h] - ADAM[Tpc_h_e]"

    vHhFormue[a_,t]$(aTot[a_]) "Samlet formue inklusiv bolig."
  ;

  $GROUP G_HHIncome_endo_a
    G_HHincome_values_endo_a

    cHh_a[akt,a_,t]$(aTot[a_]) "Aldersafhængigt additivt led i husholdningens aktiv-beholdninger, vHh[akt]."
    rPensIndb[pens,a_,t]$((aTot[a_] or a15t100[a_]) and t.val > 2015) "Pensionsindbetalingsrate."
    rPensUdb[pens,a_,t]$((aTot[a_] or a15t100[a_]) and t.val > 2015) "Pensionsudbetalingsrate" # Alderspensionen eksisterer først fra 2013 og frem
    rPensArv[pens,a_,t]$(aTot[a_] and t.val > 2015) "Andel af pensionsformue, som udbetales i tilfælde af død."
    rRealKred2Bolig[a_,t]$((aTot[a_] or a18t100[a_]) and t.val > 2015) "Husholdningernes realkreditgæld relativt til deres boligformue."
    mrHhxAfk[t]$(t.val > 2015) "Marginalt afkast efter skat på vHhx (husholdningernes formue ekskl. pension, bolig og realkreditgæld)."
    dvHhxAfk2dqBolig[t]$(t.val > 2015) "Marginal ændring i afkastet på vHhx efter skat, når boligværdien ændrer sig (lagget effekt via pBoligRigid)"
  ;

  $GROUP G_HHincome_endo 
    G_HHIncome_endo_a
    G_HHincome_prices_endo
    G_HHincome_quantities_endo
    G_HHIncome_values_endo

    rBoligOmkRest[t] "Øvrige ejerboligomkostninger ift. boligens værdi."
    rHhAfk[portf_,t]$((not akt[portf_]) or (akt[portf_] and d1vHh[portf_, t])) "Husholdningens samlede afkast for aktive/passiv typen."
    mrHhAfk[portf_,t] "Husholdningens marginale afkast efter skat for aktive/passiv typen."
    mtAktie[t]$(t.val > 2015) "Marginal skat på aktieafkast."
  ; 
  $GROUP G_HHincome_endo G_HHincome_endo$(tx0[t]); # Restrict endo group to tx0[t]

  $GROUP G_HHincome_prices
    G_HHincome_prices_endo
  ;

  $GROUP G_HHincome_quantities
    G_HHincome_quantities_endo
  ;

  $GROUP G_HHincome_values
    G_HHincome_values_endo
    jvHhOmv[t] "J-led."
    jvHhRenter[t] "J-led."
    jvKolPensKor[t] "J-led."
    jrHhPensAfk[portf_,t] "Ikke-aldersfordelt multiplikativt j-led"
  ;

  $GROUP G_HHincome_exogenous_forecast
    ErAktieAfk_static[t] "Husholdningernes forventede aktieafkast i historisk periode."
    rPensArv[pens,a_,t]$(a[a_])
    rPensUdb_a[pens,a,t] "Aldersspecifikt led i pensionsudbetalingsrate."
    rPensIndb2loensum[portf_,a_,t] "Pensionsindbetalinger ift. lønsum i pensionsmodel"
    rPensAfk2Pens[portf_,a_,t] "Pensionsafkast ift. pensionsformue i pensionsmodel"
  ;

  $GROUP G_HHincome_forecast_as_zero
    jvHhxAfk
    jrHhxAfk[t] "Ikke-aldersfordelt multiplikativt j-led"
    jvHhPensAfk
    jrHhPensAfk
    jvHhOmv
    jvHhRenter
    jvKolPensKor
    jlrPensIndb[pens,t] "J-led på log[rPensIndb]"
    jlrPensUdb[pens,t] "J-led på log[rPensUdb]"

    jmrHhAfk[t] "J-led."
    jrHhRente[portf_,t] "J-led som dækker forskel mellem husholdningens rente og den gennemsnitlige rente på aktivet/passivet."
    jrHhOmv[portf_,t] "J-led som dækker forskel mellem husholdningens rente og den gennemsnitlige omvurdering på aktivet/passivet."
  ;

  $GROUP G_HHincome_constants
    rRealKredTraeg            "Træghed i pBoligRigid."
  ;

  $GROUP G_HHincome_other
    # Portfolio
    rtTopRenter[t] "Andel af renteindtægter, der betales topskat af."
    mrNet2KapIndPos[t] "Marginal stigning i positiv nettokapitalindkomst ved stigning i kapitalindkomst"
    rKolPens[t] "Andel af pensionsformue i kollektive ordninger."
    rHhFraVirkKap[t] "Nettokapitaloverførsler fra virksomhederne til husholdningerne ift. BNP."
    rHhFraVirkOev[t] "Andre nettooverførsler fra virksomhederne til husholdningerne ift. BNP."
    rHhTilUdl[t] "Andre nettooverførsler fra virksomhederne til udlandet ift. BNP."
    cHh_t[akt,t] "Tidsvariant additivt led i husholdningens aktiv-beholdninger, vHh[akt]."
    dvHh2dvHhx[portf_,t] "Ændring i husholdningens aktiv-beholdninger, vHh[akt], for en ændring i formuen vHhx (eksklusiv pension og bolig)."
    dvHh2dvBoligR[portf_,t] "Ændring i fremadskuende husholdningers aktiv-beholdninger, vHh[akt], for en ændring i bolig-formuen vBolig."
    rBoligOmkRestRes[t] "Øvrige ejerboligomkostninger ift. boligens værdi - residual efter materialer, løn og ejendomsværdiskat."
    rRealKred2Bolig_a[a,t] "Aldersspecifikt led i husholdningernes langsigtede realkreditgæld relativt til deres boligformue."
    rRealKred2Bolig_t[t] "Tidsvariant led i husholdningernes langsigtede realkreditgæld relativt til deres boligformue."
    mtAktieRest[t] "Forskel mellem gennemsnitlig og marginal skat på aktieafkast."
    tPensKor[t] "Ca. skattesats på ubeskattet pensionsformue til beregning af vHhFormue."
    rPensIndb_a[pens,a,t] "Aldersspecifikt led i pensionsindbetalingsrate."
  ;
$ENDIF

# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_HHincome_aTot
    # ==================================================================================================================
    # Household accounting aggregated over age
    # ==================================================================================================================
    # ------------------------------------------------------------------------------------------------------------------
    # Disposable income (gælder fra 2000 - residualer i ADAM fra før dette år)
    # ------------------------------------------------------------------------------------------------------------------
    E_vDispInd[t]$(tx0[t] and t.val >= 2000)..
      vDispInd[t] =E= vWHh[aTot,t] 
                    + vSelvstKapInd[aTot,t]
                    + vOvf['hh',t]
                    - vtHh[aTot,t] + vtArv[aTot,t]
                    + vHhRenter['NetFin',t]
                    + vKolPensKor[t]
                    + vLejeAfEjerBolig[t]
                    + vOffTilHhNPISH[t] + vOffTilHhTillaeg[t] + vOffTilHhRest[t] - vOffFraHh[t]
                    + vHhFraVirkOev[t] - vHhTilUdl[t];

    # Disponibel indkomst beregnes, hvor kollektive pensionsformue ikke medtages - dvs. nettoudbetalinger medtages i stedet for afkast
    # Det antages, at indbetalinger, udbetalinger og afkast følger gns. - det er kun en approksimation historisk - derfor j-led
    E_vKolPensKor[t]$(tx0[t])..
      vKolPensKor[t] =E= rKolPens[t] * (vHhPensUdb['Pens',aTot,t] - vHhPensIndb['Pens',aTot,t] 
                                        - vHh['Pens',aTot,t-1]/fv * (1 - tPAL[t] * ftPAL[t]) * rRente['Pens',t]) + jvKolPensKor[t]; 

    # ------------------------------------------------------------------------------------------------------------------
    # Housing
    # ------------------------------------------------------------------------------------------------------------------
    E_vLejeAfEjerBolig[t]$(tx0[t])..
      vLejeAfEjerBolig[t] =E= pC['cBol',t] * qC['cBol',t]
                            - vCLejeBolig[aTot,t]
                            - rBoligOmkRest[t] * vBolig[aTot,t-1]/fv;

    E_rBoligOmkRest[t]$(tx0[t])..
      rBoligOmkRest[t] =E= (vR['bol',t] + vLoensum['bol',t] + vSelvstLoen['bol',t] + vtGrund['bol',t])
                           * qKBolig[t-1] / qK['iB','bol',t-1] / (vBolig[aTot,t-1]/fv) 
                           + rBoligOmkRestRes[t];

    E_vHh_RealKred_aTot[t]$(tx0[t])..
      vHh['RealKred',aTot,t] =E= rRealKred2Bolig[aTot,t] * vBolig[aTot,t];

    E_pBoligRigid[t]$(tx0[t] and t.val > 2015)..
      pBoligRigid[t] =E= (1-rRealKredTraeg) * pBolig[t] + rRealKredTraeg * pBoligRigid[t-1]/fp;

    # ------------------------------------------------------------------------------------------------------------------
    # Net financial assets budget constraint
    # ------------------------------------------------------------------------------------------------------------------
    E_vHh_NetFin_aTot[t]$(tx0[t] and t.val > 2015)..
      vHh['NetFin',aTot,t] =E= vHh['NetFin',aTot,t-1]/fv 
                             + vHhRenter['NetFin',t] + vHhOmv['NetFin',t]
                             + jvHhxAfk[aTot,t] + jrHhxAfk[t] * vHh['IndlAktier',aTot,t-1]/fv
                             + vWHh[aTot,t]
                             + vOvf['hh',t]
                             + vHhNFErest[aTot,t]
                             - vtHh[aTot,t]
                             - (vC[cTot,t] - vLejeAfEjerBolig[t]) # = -(pC['cIkkeBol',t] * qC_a[aTot,t] + vCLejeBolig[aTot,t] + rBoligOmkRest[t] * vBolig[aTot,t-1]/fv)
                             - vIBolig[t];    # Boliginvesteringer

    # Household income net of taxes and capital income
    E_vHhInd_aTot[t]$(tx0[t])..
      vHhInd[aTot,t] =E= vWHh[aTot,t]
                       + vOvf['hh',t]
                       + vHhPensUdb['Pens',aTot,t] - vHhPensIndb['Pens',aTot,t]
                       - vtHhx[aTot,t]
                       + vArv[aTot,t] + vArvKorrektion[aTot,t]
                       - vPensArv['Pens',aTot,t] # Pension udbetalt til afdødes arvinge indgår både i vHhPensUdb[pens,tot] og vArv[tot]
                       + vHhNFErest[aTot,t];

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

    E_vHhNFErest_tot[t]$(tx0[t] and t.val > 2015)..
      vHhNFErest[aTot,t] =E= vOffTilHh[t] - vOffFraHh[t]
                           - vHhInvestx[aTot,t] + vSelvstKapInd[aTot,t]
                           + vHhFraVirk[t]
                           - vhhTilUdl[t];

    # Other transfers
    E_vHhFraVirk[t]$(tx0[t]).. vHhFraVirk[t] =E= vHhFraVirkKap[t] + vHhFraVirkOev[t]; 
    E_vHhFraVirkKap[t]$(tx0[t]).. vHhFraVirkKap[t] =E= rHhFraVirkKap[t] * vBNP[t]; 
    E_vHhFraVirkOev[t]$(tx0[t]).. vHhFraVirkOev[t] =E= rHhFraVirkOev[t] * vBNP[t]; 

    E_vHhTilUdl[t]$(tx0[t]).. vHhTilUdl[t] =E= rHhTilUdl[t] * vBNP[t]; 

    # ------------------------------------------------------------------------------------------------------------------
    # Marginal rates of return
    # ------------------------------------------------------------------------------------------------------------------
    E_mrHhAfk_aktieafkast[akt,t]$(tx0[t] and (IndlAktier[akt] or UdlAktier[akt]) and t.val > 1994)..
      mrHhAfk[akt,t] =E= (1-mtAktie[t]) * rHhAfk[akt,t];

    E_mrHhAfk_renter[portf,t]$(tx0[t] and not (IndlAktier[portf] or UdlAktier[portf]) and t.val > 1994)..
      mrHhAfk[portf,t] =E= (1 - tKommune[t] - mrNet2KapIndPos[t] * (tBund[t] + tTop[t] * rtTopRenter[t])) * rHhAfk[portf,t];

    E_mtAktie[t]$(tx0[t] and t.val > 2015)..
      mtAktie[t] =E= tAktie[t] + mtAktieRest[t];

    # ------------------------------------------------------------------------------------------------------------------
    # Portfolio and capital income
    # ------------------------------------------------------------------------------------------------------------------
    # vHhx opdeles i aktiver og bankgæld
    E_vHh_BankGaeld_aTot[t]$(tx0[t] and t.val >= 1994)..
      vHh['BankGaeld',aTot,t] =E= vHhFinAkt[aTot,t] - vHhx[aTot,t];

    # Samlede finansielle aktiver fordeles på portefølje-komponenter
    E_vHhFinAkt_aTot[t]$(tx0[t])..
      vHhFinAkt[aTot,t] =E= vHh['Bank',aTot,t] + vHh['IndlAktier',aTot,t] + vHh['UdlAktier',aTot,t] + vHh['obl',aTot,t];

    E_vHh_aTot[akt,t]$(tx0[t] and fin_akt[akt] and t.val > 2015)..
      vHh[akt,aTot,t] =E= (cHh_a[akt,aTot,t] + cHh_t[akt,t]) * vBVT2hLsnit[t]
                        + dvHh2dvHhx[akt,t] * vHhx[aTot,t]
                        + dvHh2dvBoligR[akt,t] * pBoligRigid[t] * qBoligR[aTot,t];

    # Net capital income
    E_vHhxAfk_aTot[t]$(tx0[t] and t.val > 1994)..
      vHhxAfk[aTot,t] =E= sum(akt$(not pensTot[akt]), rHhAfk[akt,t] * vHh[akt,aTot,t-1]/fv)
                        - rHhAfk['BankGaeld',t] * vHh['BankGaeld',aTot,t-1]/fv 
                        + jvHhxAfk[aTot,t] + jrHhxAfk[t] * vHh['IndlAktier',aTot,t-1]/fv;

    E_rHhAfk_akt[akt,t]$(tx0[t] and t.val > 1994 and  d1vHh[akt,t])..
      rHhAfk[akt,t] =E= (vHhRenter[akt,t] + vHhOmv[akt,t]) / (vHh[akt,aTot,t-1]/fv);

    E_rHhAfk_BankGaeld[t]$(tx0[t] and t.val > 1994)..
      rHhAfk['BankGaeld',t] =E= rRente['Bank',t] + jrHhRente['BankGaeld',t] + rOmv['BankGaeld',t] + jrHhOmv['BankGaeld',t];

    E_rHhAfk_RealKred[t]$(tx0[t] and t.val > 1994)..
      rHhAfk['RealKred',t] =E= rRente['Obl',t] + jrHhRente['RealKred',t] + rOmv['RealKred',t] + jrHhOmv['RealKred',t];

    E_vHhRenter_NetFin[t]$(tx0[t] and t.val > 1994)..
      vHhRenter['NetFin',t] =E= sum(akt, vHhRenter[akt,t]) - sum(pas, vHhRenter[pas,t]) + jvHhRenter[t];

    E_vHhOmv_NetFin[t]$(tx0[t] and t.val > 1994)..
      vHhOmv['NetFin',t] =E= sum(akt, vHhOmv[akt,t]) - sum(pas, vHhOmv[pas,t]) + jvHhOmv[t];

    E_vHhRenter_akt[akt,t]$(tx0[t] and t.val > 1994)..
      vHhRenter[akt,t] =E= (rRente[akt,t] + jrHhRente[akt,t]) * vHh[akt,aTot,t-1]/fv;

    E_vHhRenter_BankGaeld[t]$(tx0[t] and t.val > 1994)..
      vHhRenter['BankGaeld',t] =E= (rRente['Bank',t] + jrHhRente['BankGaeld',t]) * vHh['BankGaeld',aTot,t-1]/fv;

    E_vHhRenter_RealKred[t]$(tx0[t] and t.val > 1994)..
      vHhRenter['RealKred',t] =E= (rRente['Obl',t] + jrHhRente['RealKred',t]) * vHh['RealKred',aTot,t-1]/fv;

    E_vHhOmv[portf,t]$(tx0[t] and t.val > 1994)..
      vHhOmv[portf,t] =E= (rOmv[portf,t] + jrHhOmv[portf,t]) * vHh[portf,aTot,t-1]/fv;

    # ------------------------------------------------------------------------------------------------------------------
    # Pensions
    # ------------------------------------------------------------------------------------------------------------------
    # Pensionsakkumulation
    E_vHh_pens_aTot[pens,t]$(tx0[t] and t.val > 2015)..
      vHh[pens,aTot,t] =E= vHh[pens,aTot,t-1]/fv 
                         + vHhPensAfk[pens,aTot,t]
                         + vHhPensIndb[pens,aTot,t]
                         - vHhPensUdb[pens,aTot,t];

    # Pensionsafkast
    E_vHhPensAfk_aTot[pens,t]$(tx0[t] and t.val > 2015)..
      vHhPensAfk[pens,aTot,t] =E= rHhAfk['Pens',t] * vHh[pens,aTot,t-1]/fv
                                  - vtPAL[t] * vHh[pens,aTot,t-1]/vHh['Pens',aTot,t-1]
                                  + jvHhPensAfk[pens,aTot,t] + jrHhPensAfk[pens,t] * vHh[pens,aTot,t-1]/fv;

    # Pensionsindbetalinger
    E_vHhPensIndb_aTot[pens,t]$(tx0[t] and t.val > 2015)..
      vHhPensIndb[pens,aTot,t] =E= rPensIndb[pens,aTot,t] * vWHh[aTot,t];

    # Samlede pensionsudbetalinger pr. pensionstype
    E_vHhPensUdb_aTot[pens,t]$(tx0[t] and t.val > 2015 and d1vHh[pens,t])..
      vHhPensUdb[pens,aTot,t] =E= rPensUdb[pens,aTot,t] * (vHh[pens,aTot,t-1]/fv + vHhPensAfk[pens,aTot,t]
                                                           + vHhPensIndb[pens,aTot,t]);
    E_vHhPensUdb_aTot_xvHh[pens,t]$(tx0[t] and t.val > 2015 and not d1vHh[pens,t])..
      rPensUdb[pens,aTot,t] =E= 1;

    # Pensionsudbetalinger som går til arvinge
    E_vPensArv_aTot[pens,t]$(tx0[t] and t.val > 2015 and d1vHh[pens,t])..
      vPensArv[pens,aTot,t] =E= rPensArv[pens,aTot,t] * (vHh[pens,aTot,t-1]/fv + vHhPensAfk[pens,aTot,t]);

    E_vPensArv_aTot_xvHh[pens,t]$(tx0[t] and t.val > 2015 and not d1vHh[pens,t])..
      rPensArv[pens,aTot,t] =E= 0;

    # Samlet pensions- formue, indbetalinger, udbetalinger og afkast er sum af pensionstyper
    E_vHh_pension_aTot[t]$(tx0[t] and t.val > 2015)..
      vHh['Pens',aTot,t] =E= sum(pens, vHh[pens,aTot,t]);
    E_vHhPensIndb_pension_aTot[t]$(tx0[t] and t.val > 2015)..
      vHhPensIndb['Pens',aTot,t] =E= sum(pens, vHhPensIndb[pens,aTot,t]);
    E_vHhPensUdb_pension_aTot[t]$(tx0[t] and t.val > 2015)..
      vHhPensUdb['Pens',aTot,t] =E= sum(pens, vHhPensUdb[pens,aTot,t]);
    E_vPensArv_pension_aTot[t]$(tx0[t] and t.val > 2015)..
      vPensArv['Pens',aTot,t]   =E= sum(pens, vPensArv[pens,aTot,t]);
    E_vHhPensAfk_pension_aTot[t]$(tx0[t] and t.val > 2015)..
      vHhPensAfk['Pens',aTot,t] =E= sum(pens, vHhPensAfk[pens,aTot,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Nettofordringserhvervelse for husholdningerne
    # ------------------------------------------------------------------------------------------------------------------
    E_vHhNFE[t]$(tx0[t] and t.val > 1994)..
      vHhNFE[t] =E= vHh['NetFin',aTot,t] - vHh['NetFin',aTot,t-1]/fv - vHhOmv['NetFin',t];

    # Other post model equations
    E_vHhFormue_tot[t]$(tx0[t])..
      vHhFormue[aTot,t] =E= vHh['NetFin',aTot,t] + vBolig[aTot,t] - tPensKor[t] * (vHh['pensx',aTot,t] + vHh['kap',aTot,t]);
  $ENDBLOCK


  $BLOCK B_HHincome_a
    # ==================================================================================================================
    # Household accounting disaggregated by age
    # ==================================================================================================================

    # ==================================================================================================================
    # Composition effects and aggregate parameters tie together aggregate and disaggregate systems
    # ==================================================================================================================
    # Portfolio
    E_cHh_a_aTot[akt,t]$(tx0[t] and fin_akt[akt] and t.val > 2015)..
      vHh[akt,aTot,t] =E= sum(a, vHh[akt,a,t] * nPop[a,t]);

    # Net capital income
    E_jvHhxAfk_Tot[t]$(tx0[t] and t.val > 2015)..
      vHhxAfk[aTot,t] =E= sum(a, vHhxAfk[a,t] * nPop[a-1,t-1]);

    # Pensionsindbetalinger
    E_rPensIndb[pens,a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
      rPensIndb[pens,a,t] =E= rPensIndb_a[pens,a,t]**(1 - jlrPensIndb[pens,t]);

    E_rPensIndb_aTot[pens,t]$(tx0[t] and t.val > 2015)..
      vHhPensIndb[pens,aTot,t] =E= sum(a, vHhPensIndb[pens,a,t] * nPop[a,t]);

    # Samlede pensionsudbetalinger
    E_rPensUdb[pens,a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
      rPensUdb[pens,a,t] =E= rPensUdb_a[pens,a,t]**(1 - jlrPensUdb[pens,t]);

    E_rPensUdb_aTot[pens,t]$(tx0[t] and t.val > 2015)..  # Alderspensionen eksisterer først fra 2013 og frem
      vHhPensUdb[pens,aTot,t] =E= sum(a, vHhPensUdb[pens,a,t] * nPop[a,t]) + vPensArv[pens,aTot,t];

    # Pensionsudbetalinger som går til arvinge
    E_rPensArv_aTot[pens,t]$(tx0[t] and t.val > 2015)..
      vPensArv[pens,aTot,t] =E= sum(a, vPensArv[pens,a,t] * nPop[a-1,t-1] * (1-rOverlev[a-1,t-1]));

    E_jvHhPensAfk_aTot[pens,t]$(tx0[t] and t.val > 2015)..
      vHhPensAfk[pens,aTot,t] =E= sum(a, vHhPensAfk[pens,a,t] * nPop[a-1,t-1]);

    E_rRealKred2Bolig_aTot[t]$(tx0[t] and t.val > 2015)..
      vHh['RealKred',aTot,t] =E= sum(a, vHh['RealKred',a,t] * nPop[a,t]);

    # ==================================================================================================================
    # Household accounting disaggregated by age
    # ==================================================================================================================
    # ------------------------------------------------------------------------------------------------------------------
    # Housing
    # ------------------------------------------------------------------------------------------------------------------
    E_rRealKred2Bolig[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      rRealKred2Bolig[a,t] =E= (rRealKred2Bolig_a[a,t] + rRealKred2Bolig_t[t]) * pBoligRigid[t] / pBolig[t];

    E_vHh_RealKred[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      vHh['RealKred',a,t] =E= rRealKred2Bolig[a,t] * vBolig[a,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Net financial assets budget constraint
    # ------------------------------------------------------------------------------------------------------------------
    E_vHh_NetFin[a,t]$(tx0[t] and t.val > 2015)..
      vHh['NetFin',a,t] =E= vHhx[a,t] + vHh['Pens',a,t] - vHh['RealKred',a,t];

    E_vHhInd[a,t]$(tx0[t] and a0t100[a] and t.val > 2015)..
      vHhInd[a,t] =E= vWHh[a,t] * nLHh[a,t] / nPop[a,t]
                    + vHhOvf[a,t]
                    + vHhPensUdb['Pens',a,t] - vHhPensIndb['Pens',a,t]
                    - vtHhx[a,t]
                    + vArv[a,t] + vArvKorrektion[a,t]
                    + vHhNFErest[a,t];

    # Aldersfordelt vtHh, dog er vtEjd, vtDoedsbo, vtPensArv og vtPAL fjernet, da de fratrækkes i vBoligUdgift, vArv og vHhPensUdb
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

    E_vHhNFErest[a,t]$(tx0[t] and a0t100[a] and t.val > 2015)..
      vHhNFErest[a,t] =E= ( vOffTilHh[t] - vOffFraHh[t]
                           - vHhInvestx[aTot,t] + vSelvstKapInd[aTot,t] + vHhFraVirk[t] - vhhTilUdl[t])
                         * (vWHh[a,t] * nLHh[a,t] / nPop[a,t] + vHhOvf[a,t]) / (vWHh[aTot,t] + vOvf['hh',t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Marginal rates of return - The two following variables are not age dependent but are only used with age dependent
    # variable
    # ------------------------------------------------------------------------------------------------------------------
    # Marginalt afkast efter skat på vHhx (husholdningernes formue ekskl. pension, bolig og realkreditgæld) 
    E_mrHhxAfk[t]$(tx0[t] and t.val > 2015)..
      mrHhxAfk[t] =E= sum(akt, dvHh2dvHhx[akt,t-1] * mrHhAfk[akt,t]) 
                      - dvHh2dvHhx['BankGaeld',t-1] * mrHhAfk['BankGaeld',t]
                      + jmrHhAfk[t];

    E_dvHhxAfk2dqBolig[t]$(tx0[t] and t.val > 2015)..
      dvHhxAfk2dqBolig[t] =E= (sum(akt, dvHh2dvBoligR[akt,t-1] * mrHhAfk[akt,t])
                               - dvHh2dvBoligR['BankGaeld',t-1] * mrHhAfk['BankGaeld',t])
                               * pBoligRigid[t];

    # ------------------------------------------------------------------------------------------------------------------
    # Portfolio and capital income
    # ------------------------------------------------------------------------------------------------------------------
    # vHhx opdeles i aktiver og bankgæld
    E_vHh_BankGaeld[a,t]$(tx0[t] and t.val > 2015)..
      vHh['BankGaeld',a,t] =E= vHhFinAkt[a,t] - vHhx[a,t];

    # Financial assets are split into portfolio
    E_vHhFinAkt[a,t]$(tx0[t] and t.val > 2015)..
      vHhFinAkt[a,t] =E= vHh['Bank',a,t] + vHh['IndlAktier',a,t] + vHh['UdlAktier',a,t] + vHh['obl',a,t];

    E_vHh_akt[akt,a,t]$(tx0[t] and fin_akt[akt] and t.val > 2015)..
      vHh[akt,a,t] =E= (cHh_a[akt,a,t] + cHh_t[akt,t]) * vBVT2hLsnit[t]
                     + dvHh2dvHhx[akt,t] * vHhx[a,t]
                     + dvHh2dvBoligR[akt,t] * pBoligRigid[t] * qBoligR[a,t];

    # Net capital income
    E_vHhxAfk[a,t]$(tx0[t] and a.val > 0 and t.val > 2015)..
      vHhxAfk[a,t] =E= sum(akt$(not pensTot[akt]), rHhAfk[akt,t] * vHh[akt,a-1,t-1]/fv)
                       - rHhAfk['BankGaeld',t] * vHh['BankGaeld',a-1,t-1]/fv 
                       + jvHhxAfk[a,t] + jrHhxAfk[t] * vHh['IndlAktier',a-1,t-1]/fv ;

    # ------------------------------------------------------------------------------------------------------------------
    # Pensions
    # ------------------------------------------------------------------------------------------------------------------
    # Pensionsakkumulation
    # Formue og afkast ganges med nPop[a-1,t-1]/nPop[a,t], da der udbetales bonus alt efter, hvor mange der overlever
    E_vHh_pens[pens,a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vHh[pens,a,t] =E= (vHh[pens,a-1,t-1]/fv + vHhPensAfk[pens,a,t] - vPensArv[pens,a,t] * (1-rOverlev[a-1,t-1]))
                      * nPop[a-1,t-1] / nPop[a,t]
                      + vHhPensIndb[pens,a,t] - vHhPensUdb[pens,a,t];

    # Pensionsafkast
    E_vHhPensAfk[pens,a,t]$(a.val >= 15 and tx0[t] and t.val > 2015)..
      vHhPensAfk[pens,a,t] =E= rHhAfk['Pens',t] * vHh[pens,a-1,t-1]/fv
                               - vtPAL[t] * vHh[pens,a-1,t-1]/vHh['Pens',aTot,t-1]
                               + jvHhPensAfk[pens,a,t] + jrHhPensAfk[pens,t] * vHh[pens,a-1,t-1]/fv;

    # Pensionsindbetalinger
    E_vHhPensIndb[pens,a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vHhPensIndb[pens,a,t] =E= rPensIndb[pens,a,t] * vWHh[a,t] * nLHh[a,t] / nPop[a,t];

    # Pensionsudbetalinger til levende og døde
    E_vHhPensUdb[pens,a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vHhPensUdb[pens,a,t] =E= rPensUdb[pens,a,t] 
                              * ((vHh[pens,a-1,t-1]/fv + vHhPensAfk[pens,a,t] 
                                  - vPensArv[pens,a,t] * (1-rOverlev[a-1,t-1])) * nPop[a-1,t-1] / nPop[a,t]
                                 + vHhPensIndb[pens,a,t]);

    E_vPensArv[pens,a,t]$(a.val >= 15 and tx0[t] and t.val > 2015)..
      vPensArv[pens,a,t] =E= rPensArv[pens,a,t] * (vHh[pens,a-1,t-1]/fv + vHhPensAfk[pens,a,t]);

    # Samlet pensions- formue, indbetalinger, udbetalinger og afkast er sum af pensionstyper
    E_vHh_pension[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vHh['Pens',a,t] =E= sum(pens, vHh[pens,a,t]);
    E_vHhPensIndb_pension[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vHhPensIndb['Pens',a,t] =E= sum(pens, vHhPensIndb[pens,a,t]);
    E_vHhPensUdb_pension[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vHhPensUdb['Pens',a,t] =E= sum(pens, vHhPensUdb[pens,a,t]);
    E_vPensArv_pension[a,t]$(a.val >= 15 and tx0[t] and t.val > 2015)..
      vPensArv['Pens',a,t] =E= sum(pens, vPensArv[pens,a,t]);
    E_vHhPensAfk_pension[a,t]$(a.val >= 15 and tx0[t] and t.val > 2015)..
      vHhPensAfk['Pens',a,t] =E= sum(pens, vHhPensAfk[pens,a,t]);

    # Other post model equations
    # Formuebegreb
    E_vHhFormue[a,t]$(a0t100[a] and tx0[t] and t.val > 2015)..
      vHhFormue[a,t] =E= vHh['NetFin',a,t] + vBolig[a,t] - tPensKor[t] * (vHh['pensx',a,t] + vHh['kap',a,t]);

    E_vHhPens[a,t]$(a0t100[a] and tx0[t])..
      vHhPens[a,t] =E= vHh['pens',a,t] - tPensKor[t] * (vHh['pensx',a,t] + vHh['kap',a,t]);
    E_vHhPens_tot[t]$(tx0[t]).. vHhPens[aTot,t] =E= sum(a, vHhPens[a,t] * nPop[a,t]);

    # Fremadskuende husholdninger
    E_vHhFormueR[a,t]$(a0t100[a] and tx0[t])..
      vHhFormueR[a,t] =E= (vHhFormue[a,t]
                           - rHtM * (1- tPensKor[t]) * vHh['pensx',a,t]
                           - rHtM * (1-rRealKred2Bolig[a,t]) * pBolig[t] * qBoligHtM[a,t]) / (1-rHtM);

    E_vHhFormueR_tot[t]$(tx0[t]).. vHhFormueR[aTot,t] =E= sum(a, (1-rHtM) * vHhFormueR[a,t] * nPop[a,t]);

    E_vHhPensR[a,t]$(a0t100[a] and tx0[t])..
      vHhPensR[a,t] =E= ((1 - tPensKor[t]) * (vHh['kap',a,t] + ( 1 - rHtM) * vHh['pensx',a,t]) + vHh['alder',a,t]) / (1-rHtM);


    E_vHhPensR_tot[t]$(tx0[t]).. vHhPensR[aTot,t] =E= sum(a, (1-rHtM) * vHhPensR[a,t] * nPop[a,t]);
    E_vFrivaerdiR[a,t]$(a0t100[a] and tx0[t])..
      vFrivaerdiR[a,t] =E= (pBolig[t] * (1-rRealKred2Bolig[a,t]) * qBoligR[a,t]);

    E_vFrivaerdiR_tot[t]$(tx0[t]).. vFrivaerdiR[aTot,t] =E= sum(a, (1-rHtM) * vFrivaerdiR[a,t] * nPop[a,t]);

    E_vHhIndMvR[a,t]$(a0t100[a] and tx0[t])..
      vHhIndMvR[a,t] =E= vHhIndR[a,t] + (rRealKred2Bolig[a,t] * pBolig[t] - rRealKred2Bolig[a-1,t-1] * pBolig[t-1]) 
                                        * qBoligR[a-1,t-1]/fv * fMigration[a,t];

    E_vHhIndMvR_tot[t]$(tx0[t]).. vHhIndMvR[aTot,t] =E= sum(a, (1-rHtM) * vHhIndMvR[a,t] * nPop[a,t]);
    E_vHhNetFinR[a,t]$(a0t100[a] and tx0[t])..
      vHhNetFinR[a,t] =E= vHh['NetFin',a,t] - vHhNetFinHtM[a,t] * rHtM / (1-rHtM);


    E_vHhNetFinR_tot[t]$(tx0[t]).. vHhNetFinR[aTot,t] =E= sum(a,  rHtM * vHhNetFinR[a,t] * nPop[a,t]);

    E_vBoligR[a,t]$(a18t100[a] and tx0[t] and t.val > 2015).. vBoligR[a,t] =E= pBolig[t] * qBoligR[a,t];

    E_vBoligR_tot[t]$(tx0[t] and t.val > 2015).. vBoligR[aTot,t] =E= pBolig[t] * qBoligR[aTot,t];

    # HtM-husholdninger
    E_vHhFormueHtM[a,t]$(a0t100[a] and tx0[t])..
      vHhFormueHtM[a,t] =E=  (1 - tPensKor[t]) * vHh['pensx',a,t] + pBolig[t] * (1-rRealKred2Bolig[a,t]) * qBoligHtM[a,t];
    E_vHhFormueHtM_tot[t]$(tx0[t]).. vHhFormueHtM[aTot,t] =E= sum(a, rHtM * vHhFormueHtM[a,t] * nPop[a,t]);


    E_vHhPensHtM[a,t]$(a0t100[a] and tx0[t])..
      vHhPensHtM[a,t] =E= (1 - tPensKor[t]) * vHh['pensx',a,t];
    E_vHhPensHtM_tot[t]$(tx0[t]).. vHhPensHtM[aTot,t] =E= sum(a, rHtM * vHhPensHtM[a,t] * nPop[a,t]);
    E_vFrivaerdiHtM[a,t]$(a0t100[a] and tx0[t])..
      vFrivaerdiHtM[a,t] =E= (pBolig[t] * (1-rRealKred2Bolig[a,t]) * qBoligHtM[a,t]);
    E_vFrivaerdiHtM_tot[t]$(tx0[t]).. vFrivaerdiHtM[aTot,t] =E= sum(a, rHtM * vFrivaerdiHtM[a,t] * nPop[a,t]);
    E_vHhIndMvHtM[a,t]$(a0t100[a] and tx0[t])..
      vHhIndMvHtM[a,t] =E= vHhIndR[a,t] + (rRealKred2Bolig[a,t] * pBolig[t] - rRealKred2Bolig[a-1,t-1] * pBolig[t-1]) 
                                        * qBoligHtM[a-1,t-1]/fv * fMigration[a,t];
    E_vHhIndMvHtM_tot[t]$(tx0[t]).. vHhIndMvHtM[aTot,t] =E= sum(a, rHtM * vHhIndMvHtM[a,t] * nPop[a,t]);
    E_vHhNetFinHtM[a,t]$(a0t100[a] and tx0[t])..
      vHhNetFinHtM[a,t] =E= vHh['PensX',a,t] - pBolig[t] * rRealKred2Bolig[a,t] * qBoligHtM[a,t];
    E_vHhNetFinHtM_tot[t]$(tx0[t]).. vHhNetFinHtM[aTot,t] =E= sum(a,  rHtM * vHhNetFinHtM[a,t] * nPop[a,t]);

    E_vHhIndMv[a,t]$(a0t100[a] and tx0[t])..
      vHhIndMv[a,t] =E= vHhInd[a,t] + (rRealKred2Bolig[a,t] * pBolig[t] - rRealKred2Bolig[a-1,t-1] * pBolig[t-1]) 
                                      * qBolig[a-1,t-1]/fv * fMigration[a,t];
    E_vHhIndMv_tot[t]$(tx0[t]).. vHhIndMv[aTot,t] =E= sum(a, vHhIndMv[a,t] * nPop[a,t]);

  $ENDBLOCK



  MODEL M_HhIncome /
    B_Hhincome_a
    B_HHincome_aTot
  /; 

  # Equations that do not need to be solved together with the full model and can instead be solved afterwards.
  MODEL M_HHincome_post /
    E_vDispInd
    E_vKolPensKor
    E_vHh_aTot
    E_vHhFormue, E_vHhFormue_tot
    E_vHhFormueR, E_vHhFormueR_tot
    E_vHhFormueHtM, E_vHhFormueHtM_tot
    E_vHhPensR, E_vHhPensR_tot
    E_vHhPensHtM, E_vHhPensHtM_tot
    E_vFrivaerdiR, E_vFrivaerdiR_tot
    E_vFrivaerdiHtM, E_vFrivaerdiHtM_tot
    E_vHhIndMv, E_vHhIndMv_tot
    E_vHhIndMvR, E_vHhIndMvR_tot
    E_vHhIndMvHtM, E_vHhIndMvHtM_tot
    E_vHhNetFinR, E_vHhNetFinR_tot
    E_vHhNetFinHtM, E_vHhNetFinHtM_tot
    E_vBoligR, E_vBoligR_tot
  /;

  # Endogenous variables that are solved for only after the main model.
  # Note that these may not appear anywhere in the main model (this results in a model not square error).
  $GROUP G_HHincome_post
    vDispInd[t]$(t.val >= 2000)
    vKolPensKor[t]
    cHh_a$(aTot[a_])
    vHhFormue[a_,t]$((a0t100[a_] and t.val > 2015) or aTot[a_]) 
    vHhFormueR[a_,t]$(a0t100[a_] or aTot[a_])                   
    vHhFormueHtM[a_,t]$(a0t100[a_] or aTot[a_])                 
    vHhPensR[a_,t]$(a0t100[a_] or aTot[a_])                     
    vHhPensHtM[a_,t]$(a0t100[a_] or aTot[a_])                   
    vFrivaerdiR[a_,t]$(a0t100[a_] or aTot[a_])                  
    vFrivaerdiHtM[a_,t]$(a0t100[a_] or aTot[a_])                
    vHhIndMv[a_,t]$(a0t100[a_] or aTot[a_])                     
    vHhIndMvR[a_,t]$(a0t100[a_] or aTot[a_])                    
    vHhIndMvHtM[a_,t]$(a0t100[a_] or aTot[a_])                  
    vHhNetFinR[a_,t]$(a0t100[a_] or aTot[a_])                   
    vHhNetFinHtM[a_,t]$(a0t100[a_] or aTot[a_])                 
    vBoligR[a_,t]$((a18t100[a_] or aTot[a_]) and t.val > 2015)  
  ;

  $GROUP G_HHincome_post G_HHincome_post$(tx0[t]);

$ENDIF

$IF %stage% == "exogenous_values":  
# =============================================================================================½=========================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_HhIncome_makrobk
    vHh$(aTot[a_]), vHhxAfk$(aTot[a_])
    vBolig$(aTot[a_]), vHhNFErest$(aTot[a_]), vHhFinAkt$(aTot[a_]), rRealKred2Bolig$(aTot[a_])
    vHhRenter, vHhOmv, vHhNFE
    vKolPensKor, rKolPens, vLejeAfEjerBolig
    rHhFraVirkOev, rHhFraVirkKap, rHhTilUdl
    vHhPensIndb$(aTot[a_] and t.val >= 1994), vHhPensUdb$(aTot[a_] and t.val >= 1994), vHhPensAfk$(aTot[a_] and t.val >= 1994)
    vDispInd$(t.val >= 2000)
  ;
  @load(G_HHincome_makrobk, "..\Data\makrobk\makrobk.gdx")

  # Aldersfordelt data fra aldersprofiler indlæses
  $GROUP G_HHincome_aldersprofiler     
    vHh$(a[a_]), vHhxAfk$(a[a_]), 
    vBolig$(a[a_]), vHhNFErest$(a[a_]), vHhFinAkt$(a[a_]), rRealKred2Bolig$(a[a_])
    dvHh2dvHhx
  ; 
  $GROUP G_HHincome_aldersprofiler
    G_HHincome_aldersprofiler$(tAgeData[t])
    # Pensionsvariable dækker alle datadækkede år
    rPensArv, rPensUdb_a, vHhPensAfk$(a[a_]), vHhPensIndb$(a[a_]), vHhPensUdb$(a[a_]), vPensArv
  ;
  @load(G_HHincome_aldersprofiler, "..\Data\aldersprofiler\aldersprofiler.gdx")
  # Parametre fra aldersprofiler skal indlæses særskilt med execute_load
  parameter dvHh2dvBolig[portf_,t];
  execute_load "..\Data\Aldersprofiler\aldersprofiler.gdx"
    dvHh2dvBolig
  ;

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_HHincome_data 
    G_HhIncome_makrobk
    rPensUdb_a
  ; 
  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_HHincome_data_imprecise
    vHh$(BankGaeld[portf_] and t.val = 1993)
    vHhNFErest$(aTot[a_])
    vHhNFE
    vHhPensIndb$((t.val >= 1994 and aTot[a_]) or (a[a_] and tAgeData[t]))
    vHhPensUdb$((t.val >= 1994 and aTot[a_]) or (a[a_] and tAgeData[t]))
    vHhxAfk$(aTot[a_])
    vDispInd$(t.val >= 2000)
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  # Skattesatser fra skm, arbitrær vægt på 0.2 til den høje skattesats
  mtAktie.l[t]$(t.val>=2012) = 0.8 * 0.27 + 0.2 * 0.42; 
  mtAktie.l[t]$(t.val>=2010 and t.val<2012) = 0.8 * 0.27 + 0.2 * 0.43; 
  mtAktie.l[t]$(t.val>=2001 and t.val<2010) = 0.8 * 0.28 + 0.2 * 0.43; 
  mtAktie.l[t]$(t.val>=2000 and t.val<2001) = 0.8 * 0.25 + 0.2 * 0.40; 

  # Ca. skattesats på ubeskattet pensionsformue til beregning af formue-variable
  tPensKor.l[t] = 0.4;

  rRealKredTraeg.l = 0.8;

  # Initial skøn - skal datadækkes
  mrNet2KapIndPos.l[t] = 0.5;
  rtTopRenter.l[t] = 0.5;

# ======================================================================================================================
# Data assignment
# ======================================================================================================================
  #Set Dummy for household portfolio
  d1vHh[portf_,t] = yes$(vHh.l[portf_,aTot,t] <> 0);

  #I 2015 sættes pBoligRigid til boligprisen. 
  pBoligRigid.l[t]$(t.val = 2015) = pBolig.l[t] ; 

  qBolig.l[a,t]$(tData[t]) = vBolig.l[a,t] / pBolig.l[t];
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_HhIncome_static_calibration_base 
    G_HHincome_endo
    -vKolPensKor[t], jvKolPensKor[t]
    -vLejeAfEjerBolig[t], rBoligOmkRestRes[t]
    -vHhRenter[portf_,t], jrHhRente[portf_,t]$(t.val > 1994 and  d1vHh[portf_,t]), jvHhRenter[t]$(t.val > 1994)
    -vHhOmv[portf_,t], jrHhOmv[portf_,t]$(t.val > 1994 and  d1vHh[portf_,t]), jvHhOmv[t]$(t.val > 1994)
    mtAktieRest, -mtAktie
    ErAktieAfk_static$(t.val > 1994) # E_ErAktieAfk_static
    dvHh2dvBoligR[portf_,t]$((fin_akt[portf_] or BankGaeld[portf_]) and t.val > 2015) # E_dvHh2dvBoligR og E_dvHh2dvBoligR_BankGaeld
  ;
  $BLOCK B_HHincome_static_calibration_base
    # Forventet marginalafkast beregnes ud fra forventede afkast ikke realiserede
    E_ErAktieAfk_static[t]$(tx0[t] and t.val > 1994)..
      ErAktieAfk_static[t] =E= rAfkastKrav[sTot,t] * vAktiex[sTot,t-1]/vAktie[t-1] 
                               + rRente['Obl',t] * vVirk['Obl',t-1]/vAktie[t-1] 
                               + rRente['Bank',t] * vVirk['Bank',t-1]/vAktie[t-1] 
                               + ErAktieAfk_static[t] * (vVirk['IndlAktier',t-1]/fv+vVirk['UdlAktier',t-1]/vAktie[t-1])
                               - rRente['Obl',t] * vVirk['RealKred',t-1]/vAktie[t-1];

    E_dvHh2dvBoligR[portf_,t]$(tx0[t] and (t.val > 2015) and (fin_akt[portf_] or BankGaeld[portf_]))..
      dvHh2dvBoligR[portf_,t] =E= pBolig[t] / pBoligRigid[t] * (1-rHtM) * qBoligR[aTot,t] / qBolig[aTot,t] * dvHh2dvBolig[portf_,t];
  $ENDBLOCK

  $GROUP G_HhIncome_simple_static_calibration 
    G_HhIncome_static_calibration_base
    -G_HHincome_endo_a
  # Beregninger af led som er endogene i aldersdel (skal være uændret, når de beregnes endogent)
    -vHh[portf_,a_,t]$(RealKred[portf_] and aTot[a_]), rRealKred2Bolig[a_,t]$(aTot[a_])
    -vHhPensAfk[portf_,a_,t]$(aTot[a_] and pens[portf_]), jvHhPensAfk[portf_,t]$(aTot[a_] and pens[portf_])
    -vHhPensIndb[portf_,a_,t]$(aTot[a_] and pens[portf_]), rPensIndb[pens,a_,t]$(aTot[a_])
    -vHhPensUdb[portf_,a_,t]$(aTot[a_] and pens[portf_]), rPensUdb[pens,a_,t]$(aTot[a_])
    -vHh[portf_,a_,t]$(fin_akt[portf_] and aTot[a_]), cHh_a[akt,a_,t]$(fin_akt[akt] and aTot[a_])
  ;
  $GROUP G_HhIncome_simple_static_calibration
    G_HhIncome_simple_static_calibration$(tx0[t])
  ;
  MODEL M_HhIncome_simple_static_calibration /
    M_HHincome 
    -B_HHincome_a
    B_HHincome_static_calibration_base
  /;

  $GROUP G_HhIncome_static_calibration
    G_HhIncome_static_calibration_base
    jmrHhAfk[t]$(t.val > 1994) # E_jmrHhAfk
    -vHh[portf_,a_,t]$(RealKred[portf_] and a18t100[a_] and t.val > 2015), 
    rRealKred2Bolig_a[a,t]$(a18t100[a] and t.val > 2015)
    -vHhPensAfk[portf_,a_,t]$(a[a_] and pens[portf_]), jvHhPensAfk[portf_,a_,t]$(aVal[a_] >= 15 and t.val > 2015)
    -vHhPensIndb$(a15t100[a_] and pens[portf_]), rPensIndb_a$(a15t100[a] and t.val > 2015)
    -vHh[portf_,a_,t]$(fin_akt[portf_] and aVal[a_] <> 70), cHh_a[akt,a,t]$(fin_akt[akt] and t.val > 2015)  # Vi udlader én aldersgruppe, men eksogeniserer totalen       
  ;
  $GROUP G_HhIncome_static_calibration
    G_HhIncome_static_calibration$(tx0[t])
  ;
  $BLOCK B_HHIncome_Static_calibration
    E_jmrHhAfk[t]$(tx0[t] and t.val > 2015)..
      mrHhxAfk[t] =E= 
      ( dvHh2dvHhx['IndlAktier',t-1] * ErAktieAfk_static[t]
        + dvHh2dvHhx['UdlAktier',t-1] * ErAktieAfk_static[t]
      ) * (1-tAktie[t])
      + ( dvHh2dvHhx['Obl',t-1] * rRente['obl',t]
        + dvHh2dvHhx['Bank',t-1] * rRente['Bank',t]
        - dvHh2dvHhx['BankGaeld',t-1] * rRente['Bank',t]
      ) * (1 - tKommune[t] - mrNet2KapIndPos[t] * (tBund[t] + tTop[t] * rtTopRenter[t]));
  $ENDBLOCK
  MODEL M_HhIncome_static_calibration /
    M_HHincome
    B_HHincome_static_calibration_base
    B_HHIncome_Static_calibration
  /;
$ENDIF

# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_HHincome_deep
    G_HHincome_endo
    rPensIndb_a$(a15t100[a] and tx1[t]) # E_rPensIndb_a_forecast
  ;
  $GROUP G_HHincome_deep G_HHincome_deep$(tx0[t]);

  $BLOCK B_HHIncome_deep
    E_rPensIndb_a_forecast[pens,a,t]$(a15t100[a] and tx1[t])..
      rPensIndb[pens,a,t] =E= rPensIndb2loensum[pens,a,t] * vLoensum[sTot,t] / vWHh[aTot,t];

      #  vHhPensAfk[pens,a,t] =E= rHhAfk['Pens',t] * vHh[pens,a-1,t-1]/fv
      #                           - vtPAL[t] * vHh[pens,a-1,t-1]/vHh['Pens',aTot,t-1]
      #                           + jvHhPensAfk[pens,a,t];

      #  vHhPensAfk[pens,a,t] =E= rPensAfk2Pens[pens,a,t] * vHh[pens,aa-1,t-1]/fv / sum(aa, rPensAfk2Pens[pens,aa,t] * vHh[pens,aa-1,t-1]/fv);
  $ENDBLOCK
  MODEL M_HHincome_deep /
    M_HHincome
    B_HHIncome_deep
  /;
$ENDIF

# ======================================================================================================================
# Simple dynamic calibration
# ======================================================================================================================
$IF %stage% == "simple_dynamic_calibration":
  $GROUP G_HHincome_dynamic_calibration
    G_HHincome_endo
    cHh_t[akt,t]$(fin_akt[akt] and t1[t]), -vHh[portf_,a_,t]$(t1[t] and aTot[a_] and fin_akt[portf_])
    -vHhPensAfk[portf_,a_,t]$(aTot[a_] and pens[portf_] and t1[t]), jrHhPensAfk[portf_,t]$(pens[portf_] and t1[t])
    -vHhPensIndb$(aTot[a_] and pens[portf_] and t1[t]), jlrPensIndb$(t1[t])
    rPensIndb_a$(a15t100[a] and t1[t] and sameas['kap',pens]) # E_rPensIndb_a_simple
    -vHhPensUdb$(aTot[a_] and pens[portf_] and t1[t]), jlrPensUdb$(t1[t])
    -vHh[portf_,a_,t]$(t1[t] and RealKred[portf_] and aTot[a_]), rRealKred2Bolig_t[t]$(t1[t])
    -vHh$(aTot[a_] and NetFin[portf_] and t1[t]), jrHhxAfk$(t1[t])
  ;
  # Indbetalinger til kapitalpension er 0 i FMs fremskrivning, men har en værdi i data - derfor denne korrektion
  $BLOCK B_HHincome_dynamic_calibration
    E_rPensIndb_a_dynamic_calibration[a,t]$(a15t100[a] and t1[t])..
      rPensIndb_a['kap',a,t] =E= rPensIndb_a['kap',a,t0];
  $ENDBLOCK
  MODEL M_HHincome_dynamic_calibration /
    M_HHincome - M_HHincome_post
    B_HHincome_dynamic_calibration
  /;
$ENDIF