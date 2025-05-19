# ======================================================================================================================
# Household income and portfolio accounting
# - See consumers.gms for consumption decisions and budget constraint
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":

  $GROUP G_HHIncome_endo_a
    # VALUES
    vHhAkt[portf_,a_,t]$(0) "Husholdningernes finansielle aktiver, Kilde: jf. se for portefølje."
    vHhPas[portf_,a_,t]$(0) "Husholdningernes finansielle passiver, Kilde: jf. se for portefølje."
    vHhAktOmk[portf_,t]$(0) "Administrations- og investeringsomkostninger knyttet til finansielle aktiver"
    vHhPasOmk[portf_,t]$(0) "Administrations- og investeringsomkostninger knyttet til finansielle passiver"
    vHhPas[portf_,a_,t]$(RealKred[portf_] and (a18t100[a_]) and t.val > %AgeData_t1%) ""
    vHhPas[portf_,a_,t]$(Bank[portf_] and t.val > %AgeData_t1% and a[a_]) ""
    vHhPas[portf_,a_,t]$(portfTot[portf_] and t.val > %AgeData_t1% and a[a_]) ""
    vHhAkt[portf_,a_,t]$(fin_akt[portf_] and d1vHhAkt[portf_,t] and t.val > %AgeData_t1% and a[a_]) ""
    vHhAkt[portf_,a_,t]$(pensTot[portf_] and a15t100[a_] and t.val > %AgeData_t1%) ""
    vHhAkt[portf_,a_,t]$(portfTot[portf_] and t.val > %AgeData_t1% and a[a_]) ""
    vHhPens[pens_,a_,t]$(pens[pens_] and a15t100[a_] and t.val > %AgeData_t1%) "Husholdningernes pensionsformue."
    vHhPensAfk[pens_,a_,t]$(aVal[a_] >= 15 and t.val > %AgeData_t1%) "Afkast fra pensionsformue EFTER SKAT."
    vHhPensIndb[pens_,a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Pensionsindbetalinger fra husholdningerne."
    vHhPensUdb[pens_,a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Pensionsudbetalinger til husholdningerne."
    vPensArv[pens_,a_,t]$(aVal[a_] >= 15 and t.val > %AgeData_t1%) "Pension udbetalt til arvinger i tilfælde af død."
    vHhInd[a_,t]$((a0t100[a_] and t.val > %AgeData_t1%)) "Husholdningernes løbende indkomst efter skat (ekslusiv kapitalindkomst)."
    vtHhx[a_,t]$(a0t100[a_] and t.val > %AgeData_t1%) "Skatter knyttet til husholdningerne ekskl. pensionsafkastskat, ejendomsværdiskat, dødsboskat og øvrig skat på kapitalindkomst."
    vHhNFErest[a_,t]$(a0t100[a_] and t.val > %AgeData_t1%) "Kapitaloverførsler, direkte investeringer mv.."
    vtHhxAfk[a_,t]$(aVal[a_] > 0 and t.val > %AgeData_t1%) "Imputeret kapitalbeskatning ekskl. pension, bolig og realkreditgæld."
    vRealkreditFradrag[a_,t]$(aVal[a_] > 0 and t.val > %AgeData_t1%) "Imputeret fradrag fra realkreditgæld. Ikke databelagt!"
    vHhFormue[a_,t]$((a0t100[a_] and t.val > %AgeData_t1%)) "Samlet formue inklusiv bolig."
    vHhPensEfterSkat[a_,t]$(a0t100[a_]) "Pensionsformue EFTER SKAT"  
    vHhFormue_h[h_,a_,t]$(a0t100[a_]) "Samlet formue inklusiv bolig for husholdninger."
    vHhIndMv_h[h_,a_,t]$(a0t100[a_]) "Fremadskuende husholdningers indkomst og lån i friværdi."
    vFrivaerdi_h[h_,a_,t]$(a0t100[a_]) "Friværdi (boligværdi fratrukket realkreditgæld) for husholdninger."
    vHhIndMv[a_,t]$(a0t100[a_]) "Husholdningers indkomst og lån i friværdi."
    vHhPensEfterSkat_h[h_,a_,t]$(a0t100[a_]) "Pensionsformue for husholdninger EFTER SKAT."
    vHhFraMigration[a_,t]$(a[a_] and aVal[a_] > 0) "Nettoformue medbragt af netto-indvandrere."

    # MISC.
    rPensIndb[pens,a_,t]$((a15t100[a_]) and t.val > %AgeData_t1%) "Pensionsindbetalingsrate."
    rPensUdb[pens,a_,t]$((a15t100[a_]) and t.val > %AgeData_t1% and (d1vHhPens[pens,t] or d1vHhPens[pens,t-1])) "Pensionsudbetalingsrate" # Alderspensionen eksisterer først fra 2013 og frem
    rRealKred2Bolig[a_,t]$((a18t100[a_]) and t.val > %AgeData_t1%) "Husholdningernes realkreditgæld relativt til deres boligformue."
    rHhAktOmk[portf_,t]$(0) "Administrations- og investeringsomkostningsrate knyttet til finansielle aktiver"
    rHhPasOmk[portf_,t]$(0) "Administrations- og investeringsomkostningsrate knyttet til finansielle passiver"
    vBolig_h[h,a_,t]$(a18t100[a_] and t.val > %AgeData_t1%) "Husholdningernes boligformue." # vBoligR ikke brugt, men jTot = vBolig 
  ;

  $GROUP G_HHIncome_endo_a_tot
    
    # VALUES
    jvHhPensAfk[pens_,a_,t]$(aTot[a_] and pens[pens_] and t.val > %AgeData_t1%) "Aldersfordelt additivt j-led"
    vHhFormue_h[h_,aTot,t]
    vHhIndMv_h[h_,aTot,t]
    vFrivaerdi_h[h_,aTot,t]
    vHhIndMv[aTot,t]
    vHhPensEfterSkat_h[h_,a_,t]$(a0t100[a_] or aTot[a_]) "Pensionsformue for husholdninger EFTER SKAT."
    vBolig_h[h,aTot,t]$(t.val > %AgeData_t1%)

    # MISC.
    cHh_a[portf_,a_,t]$(aTot[a_] and portf[portf_]) "Aldersafhængigt additivt led i husholdningens aktiv-beholdninger, vHhAkt."
    rPensIndb[pens,aTot,t]
    rPensUdb[pens,aTot,t]$(t.val > %AgeData_t1% and (d1vHhPens[pens,t] or d1vHhPens[pens,t-1])) "Pensionsudbetalingsrate" # Alderspensionen eksisterer først fra 2013 og frem
    rPensArv[pens,a_,t]$(aTot[a_] and t.val > %AgeData_t1% and (d1vHhPens[pens,t] or d1vHhPens[pens,t-1])) "Andel af pensionsformue, som udbetales i tilfælde af død."
    rRealKred2Bolig[aTot,t]$(t.val > %AgeData_t1%)
  ;

  $GROUP G_HHincome_endo 
    G_HHIncome_endo_a
    G_HHIncome_endo_a_tot

    # PRICES
    pBoligRigid[t] "Rigid boligpris til brug i rRealKred2Bolig."
    
    # VALUES
    vtHh[a_,t]$(aTot[a_]) "Skatter knyttet til husholdningerne."
    vDispInd[t]$(t.val > %NettoFin_t1%) "Disponibel bruttoindkomst i husholdninger og organisationer, Kilde: ADAM[Yd_h]"
    vHhInd[a_,t]$(aTot[a_]) "Husholdningernes løbende indkomst efter skat (ekslusiv kapitalindkomst)."
    vtHhxAfk[a_,t]$(aTot[a_] and t.val > %NettoFin_t1%)
    vRealkreditFradrag[a_,t]$(aTot[a_] and t.val > %NettoFin_t1%)
    vtHhx[a_,t]$(aTot[a_])
    vHhNet[t]$(t.val > %AgeData_t1%) "Husholdningernes finansielle portefølje, Kilde: jf. se for portefølje."
    vHhAkt[portfTot,aTot,t]$(t.val > %AgeData_t1%)
    vHhPas[portfTot,aTot,t]$(t.val > %AgeData_t1%)
    vHhPas[RealKred,aTot,t]
    vHhAkt[pensTot,aTot,t]$(t.val > %NettoFin_t1%)
    vHhPas[Bank,aTot,t]
    vHhAkt[portf_,aTot,t]$(fin_akt[portf_] and d1vHhAkt[portf_,t] and t.val > %AgeData_t1%)
    vHhNetRenter[t]$(t.val > %NettoFin_t1%) "Husholdningernes nettoformueindkomst, Kilde: ADAM[Tin_h]"
    vHhAktRenter[portf_,t]$(t.val > %NettoFin_t1% and d1vHhAkt[portf_,t] and portf[portf_]) "Husholdningernes formueindkomst fra aktiver"
    vHhPasRenter[portf_,t]$(t.val > %NettoFin_t1% and d1vHhPas[portf_,t] and portf[portf_]) "Husholdningernes renteudgifter"
    vHhOmv[portf_,t]$(t.val > %NettoFin_t1% and portfTot[portf_]) "Omvurderinger på husholdningernes finansielle nettoformue, Kilde: ADAM[Wn_h]-ADAM[Wn_h][-1]-ADAM[Tfn_h]"
    vHhAktOmv[portf_,t]$(t.val > %NettoFin_t1% and d1vHhAkt[portf_,t] and portf[portf_]) "Omvurderinger på husholdningernes finansielle aktiver"
    vHhPasOmv[portf_,t]$(t.val > %NettoFin_t1% and d1vHhPas[portf_,t] and portf[portf_]) "Omvurderinger på husholdningernes finansielle passiver"
    jvHhOmv[t]$(t.val > %NettoFin_t1%) "Aggregeret J-led."
    vHhPensEfterSkat[a_,t]$(aTot[a_]) "Pensionsformue EFTER SKAT"  
    rHhAktOmk[Bank,t]$(t.val > %NettoFin_t1%)
    rHhPasOmk[RealKred,t]$(t.val > %NettoFin_t1%)
    rHhPasOmk[Bank,t]$(t.val > %NettoFin_t1%)
    vHhAktOmk[pensTot,t]$(t.val > %NettoFin_t1%)
    vHhAktOmk[Bank,t]$(t.val > %NettoFin_t1%)
    vHhAktOmk[portfTot,t]$(t.val > %NettoFin_t1%)
    vHhPasOmk[RealKred,t]$(t.val > %NettoFin_t1%)
    vHhPasOmk[Bank,t]$(t.val > %NettoFin_t1%)
    vHhPasOmk[portfTot,t]$(t.val > %NettoFin_t1%)
    vHhPens[pens,aTot,t]$(t.val > %NettoFin_t1%)
    vHhPensAfk[pens_,a_,t]$(aTot[a_] and t.val > %NettoFin_t1%) "Afkast fra pensionsformue EFTER SKAT."
    vHhPensIndb[pens_,a_,t]$(aTot[a_] and t.val > %NettoFin_t1%) "Pensionsindbetalinger fra husholdningerne."
    vHhPensUdb[pens_,a_,t]$(aTot[a_] and t.val > %NettoFin_t1%) "Pensionsudbetalinger til husholdningerne."
    vPensArv[pens_,a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "Pension udbetalt til arvinger i tilfælde af død."
    vHhNFE[t]$(t.val > %NettoFin_t1%) "Nettofordringserhvervelse for husholdningerne, Kilde: ADAM[Tfn_h]"
    vHhNFErest[a_,t]$(aTot[a_] and t.val > %NettoFin_t1%) "Kapitaloverførsler, direkte investeringer mv."
    vKolPensKor[t] "Korrektion til disponibel indkomst, da nettoudbetalinger til kolletiv pension og ikke afkast fra denne indgår"
    vLejeAfEjerBolig[t] "Imputeret værdi af lejeværdi af egen bolig, Kilde: ADAM[byrhh] * ADAM[Yrh]"
    vHhFraVirkKap[t] "Nettokapitaloverførsler fra virksomhederne til husholdningerne, Kilde: ADAM[Tknr_h]"
    vHhFraVirkOev[t] "Øvrige nettooverførsler fra virksomhederne til husholdningerne, Kilde: ADAM[Trn_h] - ADAM[Tr_o_h] + ADAM[Trks] + ADAM[Trr_hc_o]"
    vHhFraVirk[t] "Andre nettooverførsler fra virksomhederne til husholdningerne, Kilde: ADAM[Tknr_h] + ADAM[Trn_h] - ADAM[Tr_o_h] + ADAM[Trks] + ADAM[Trr_hc_o]"
    vHhTilUdl[t] "Skat til udlandet og nettopensionsbetalinger til udlandet, Kilde: ADAM[Syn_e] + (ADAM[Typc_cf_e] - ADAM[Tpc_e_z]) - ADAM[Typc_e_h] - ADAM[Tpc_h_e] + vtPALudl"
    vHhFraMigration[aTot,t]
    vHhFormue[a_,t]$(aTot[a_]) "Samlet formue inklusiv bolig."
    
    # MISC.
    mrHhAktAfk[portf_,t]$(portf[portf_]) "Husholdningens marginale afkast efter skat for aktive/passiv typen."
    mrHhPasAfk[portf_,t]$(portf[portf_]) "Husholdningens marginale afkast efter skat for aktive/passiv typen."
    mrHhxAfk[t] "Marginalt afkast efter skat på vHhx (husholdningernes formue ekskl. pension, bolig og realkreditgæld)."
    dvHhxAfk2dvBolig[t]$(t.val > %NettoFin_t1%) "Marginal ændring i afkastet på vHhx efter skat, når boligværdien ændrer sig (lagget effekt via pBoligRigid)"
    rHhAktAfk[portf_,t]$(portf[portf_]) "Husholdningens samlede afkastrate for aktiv/passiv typen."
    rHhPasAfk[portf_,t]$(portf[portf_]) "Husholdningens samlede afkastrate for aktiv/passiv typen."
    rBoligOmkRest[t] "Øvrige ejerboligomkostninger ift. boligens værdi."
    jrHhAktOmv[portf_,t]$(PensTot[portf_]) "J-led som dækker forskel mellem husholdningens rente og den gennemsnitlige omvurdering på aktivet/passivet."
  ; 

  $GROUP G_HHincome_endo G_HHincome_endo$(tx0[t]); # Restrict endo group to tx0[t]

  $GROUP G_HHincome_exogenous_forecast
    ErAktieAfk_static[t] "Husholdningernes forventede aktieafkast i historisk periode."
    rPensArv[pens,a_,t]$(a[a_])
    rPensUdb_a[pens,a,t] "Aldersspecifikt led i pensionsudbetalingsrate."
    rPensIndb2loensum[pens_,a_,t] "Pensionsindbetalinger ift. lønsum i pensionsmodel"
    rPensAfk2Pens[pens_,a_,t] "Pensionsafkast ift. pensionsformue i pensionsmodel"
    rHhAktOmk[portf_,t]$(pensTot[portf_]) "Administrations- og investeringsomkostningsrate knyttet til finansielle aktiver"
    vKolPensKorRest[t] "Rest-led i kollektiv pensionskorrektion - afspejler forskelle i forhold mellem hhv. ind- og udbetalinger og formue på individuelle og kollektive pensioner"
    rPensIndb_a[pens,a,t] "Aldersspecifikt led i pensionsindbetalingsrate."
  ;

  $GROUP G_HHincome_forecast_as_zero
    jvHhPensAfk
    jrHhPensAfk[pens_,t] "Ikke-aldersfordelt multiplikativt j-led"
    jfrPensIndb[pens,t] "J-led på rPensIndb"
    jfrPensUdb[pens,t] "J-led på rPensUdb"
    jmrHhxAfk[t] "J-led."
    jrHhAktRenter[portf_,t] "J-led som dækker forskel mellem husholdningens rente og den gennemsnitlige rente på aktivet/passivet."
    jrHhPasRenter[portf_,t] "J-led som dækker forskel mellem husholdningens rente og den gennemsnitlige rente på aktivet/passivet."
    jrHhAktOmv[portf_,t]$(not PensTot[portf_]) "J-led som dækker forskel mellem husholdningens rente og den gennemsnitlige omvurdering på aktivet/passivet."
    jrHhPasOmv[portf_,t] "J-led som dækker forskel mellem husholdningens rente og den gennemsnitlige omvurdering på aktivet/passivet."
  ;

  $GROUP G_HHincome_constants
    rRealKredTraeg "Træghed i pBoligRigid."
  ;

  $GROUP G_HHincome_fixed_forecast
    rPensUdb[pens,a_,t]$((aTot[a_] or a15t100[a_]) and sameas('Kap',pens))
    vKolPensKorRest[t]

    # Portfolio
    rKolPens[t] "Andel af pensionsformue i kollektive ordninger."
    rHhFraVirkKap[t] "Nettokapitaloverførsler fra virksomhederne til husholdningerne ift. BNP."
    rHhFraVirkOev[t] "Andre nettooverførsler fra virksomhederne til husholdningerne ift. BNP."
    rHhTilUdlRest[t] "Andre nettooverførsler fra virksomhederne til udlandet ift. BNP."
    cHh_t[portf_,t] "Tidsvariant additivt led i husholdningens aktiv-beholdninger, vHhAkt."
    dvHhAkt2dvHhx[portf_,t] "Ændring i husholdningens finansielle aktiver, vHhAkt, for en ændring i formuen vHhx (eksklusiv pension og bolig)."
    dvHhPas2dvHhx[portf_,t] "Ændring i husholdningens passiver, vHhPas, for en ændring i formuen vHhx (eksklusiv pension og bolig)."    
    dvHhAkt2dvBolig[portf_,t] "Ændring i husholdningers finansielle aktiver, vHhAkt, for en ændring i bolig-formuen vBolig."
    dvHhPas2dvBolig[portf_,t] "Ændring i husholdningers passiver, vHhPas, for en ændring i bolig-formuen vBolig."
    rBoligOmkRestRes[t] "Øvrige ejerboligomkostninger ift. boligens værdi - residual efter materialer, løn og ejendomsværdiskat."
    rRealKred2Bolig_a[a,t] "Aldersspecifikt led i husholdningernes langsigtede realkreditgæld relativt til deres boligformue."
    rRealKred2Bolig_t[t] "Tidsvariant led i husholdningernes langsigtede realkreditgæld relativt til deres boligformue."
    tPensKor[t] "Ca. skattesats på ubeskattet pensionsformue til beregning af vHhFormue."
  ;
$ENDIF

# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_HHincome_static$(tx0[t])
    # ==================================================================================================================
    # Household accounting aggregated over age
    # ==================================================================================================================
    # ------------------------------------------------------------------------------------------------------------------
    # Disposable income (gælder fra 2000 - residualer i ADAM fra før dette år)
    # ------------------------------------------------------------------------------------------------------------------
    E_vDispInd[t]$(t.val >= 2000)..
      vDispInd[t] =E= vWHh[aTot,t] 
                    + vSelvstKapInd[aTot,t]
                    + vOvf['HhTot',t]
                    - vtHh[aTot,t] + vtArv[aTot,t]
                    + vHhNetRenter[t]
                    + vKolPensKor[t]
                    + vLejeAfEjerBolig[t]
                    + vOffTilHhNPISH[t] + vOffTilHhTillaeg[t] + vOffTilHhRest[t] - vOffFraHh[t]
                    + vHhFraVirkOev[t] - vHhTilUdl[t];

    # Disponibel indkomst beregnes, hvor kollektive pensionsformue ikke medtages - dvs. nettoudbetalinger medtages i stedet for afkast (afkast kun renter og dividender i NR)
    # Det antages, at indbetalinger, udbetalinger og afkast følger gns. - det er kun en approksimation historisk - derfor vKolPensKorRest-led
    # NB: Øgede omvurderinger påvirker vDispInd negativt via PAL-skat på individuel pension, da skat men ikke indkomst er med
    # vKolPensKorRest afspejler primært, at individuelle pensioner bliver mere populære og har større indbetalingsrater og lavere udbetalingsrater end kollektiv pension
    E_vKolPensKor[t]..
      vKolPensKor[t] =E= rKolPens[t] * (vHhPensUdb['pensTot',aTot,t] - vHhPensIndb['pensTot',aTot,t] 
                                        - vHhAkt['pensTot',aTot,t-1]/fv * rRente['pensTot',t] + (vtPAL[t] - vtPALudl[t])) + vKolPensKorRest[t]; 

    # ------------------------------------------------------------------------------------------------------------------
    # Housing
    # ------------------------------------------------------------------------------------------------------------------
    E_vLejeAfEjerBolig[t]..
      vLejeAfEjerBolig[t] =E= vC['cBol',t]
                            - vCLejeBolig[aTot,t]
                            - rBoligOmkRest[t] * vBolig[aTot,t-1]/fv;

    E_rBoligOmkRest[t]..
      rBoligOmkRest[t] =E= (vR['bol',t] + vLoensum['bol',t] + vSelvstLoen['bol',t] + vtGrund['bol',t])
                           * qKBolig[t-1] / qK['iB','bol',t-1] / (vBolig[aTot,t-1]/fv) 
                           + rBoligOmkRestRes[t];

    E_vHhPas_RealKred_aTot[t]..
      vHhPas['RealKred',aTot,t] =E= rRealKred2Bolig[aTot,t] * vBolig[aTot,t];

    E_pBoligRigid[t]..
      pBoligRigid[t] =E= (1-rRealKredTraeg) * pBolig[t] + rRealKredTraeg * pBoligRigid[t-1]/fp;

    # ------------------------------------------------------------------------------------------------------------------
    # Net financial assets budget constraint
    # ------------------------------------------------------------------------------------------------------------------
    E_vHhAkt_tot_aTot[t]$(t.val > %AgeData_t1%)..
      vHhAkt['tot',aTot,t] =E= sum(portf, vHhAkt[portf,aTot,t]);

    E_vHhPas_tot_aTot[t]$(t.val > %AgeData_t1%)..
      vHhPas['tot',aTot,t] =E= sum(portf, vHhPas[portf,aTot,t]);

    E_vHhNet[t]$(t.val > %AgeData_t1%)..
      vHhNet[t] =E= vHhAkt['tot',aTot,t] - vHhPas['tot',aTot,t];

    # Household income net of taxes and capital income
    E_vHhInd_aTot[t]..
      vHhInd[aTot,t] =E= vWHh[aTot,t]
                       + vOvf['HhTot',t]
                       + vHhPensUdb['pensTot',aTot,t] - vHhPensIndb['pensTot',aTot,t]
                       - vtHhx[aTot,t]
                       + vArv[aTot,t] + vArvKorrektion[aTot,t]
                       - vPensArv['pensTot',aTot,t] # Pension udbetalt til afdødes arvinge indgår både i vHhPensUdb[pens,tot] og vArv[tot]
                       + vHhNFErest[aTot,t];

    E_vtHh_aTot[t].. vtHh[aTot,t] =E= vtKilde[t] - vtAktieUdl[t]
                                    + vtHhAM[aTot,t]
                                    + vtPersRest[aTot,t]
                                    + vtHhVaegt[aTot,t]                
                                    + (vtPAL[t] - vtPALudl[t])
                                    + vtMedie[t]
                                    + vtArv[aTot,t]
                                    + vBidrag[aTot,t]
                                    + vtKirke[aTot,t]
                                    + jvtDirekte[t] + vtLukning[aTot,t];

    E_vtHhx_tot[t]..
      vtHhx[aTot,t] =E= vtBund[aTot,t] 
                      + vtMellem[aTot,t] 
                      + vtTop[aTot,t] 
                      + vtTopTop[aTot,t] 
                      + vtKommune[aTot,t] 
                      + vtAktieHh[aTot,t] 
                      + vtVirksomhed[aTot,t] 
                      + vtHhAM[aTot,t]
                      + (vtPersRest[aTot,t] - vtPersRestPensArv[aTot,t])
                      + vtHhVaegt[aTot,t]                
                      + vtMedie[t]
                      + vtArv[aTot,t]
                      + vBidrag[aTot,t]
                      + vtKirke[aTot,t]
                      + vtLukning[aTot,t]
                      - vtHhxAfk[aTot,t]
                      + vRealkreditFradrag[aTot,t] # Realkredit fradrag indgår i vBoligUdgift
                      + jvtKilde[t] + jvtDirekte[t];

    E_vHhNFErest_tot[t]$(t.val > %NettoFin_t1%)..
      vHhNFErest[aTot,t] =E= vOffTilHh[t] - vOffFraHh[t]
                           - vHhInvestx[aTot,t] + vSelvstKapInd[aTot,t]
                           + vHhFraVirk[t]
                           - vHhTilUdl[t];

    # Other transfers
    E_vHhFraVirk[t].. vHhFraVirk[t] =E= vHhFraVirkKap[t] + vHhFraVirkOev[t]; 
    E_vHhFraVirkKap[t].. vHhFraVirkKap[t] =E= rHhFraVirkKap[t] * vBNP[t]; 
    E_vHhFraVirkOev[t].. vHhFraVirkOev[t] =E= rHhFraVirkOev[t] * vBNP[t]; 

    E_vHhTilUdl[t].. vHhTilUdl[t] =E= - vHhFraMigration[aTot,t] + rHhTilUdlRest[t] * vBNP[t]; 

    E_vHhFraMigration_aTot[t].. vHhFraMigration[aTot,t] =E= sum(a, vHhFraMigration[a,t] * nPop[a,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Marginal rates of return
    # ------------------------------------------------------------------------------------------------------------------
    E_mrHhPasAfk[portf,t]$(t.val > %NettoFin_t1%)..
      mrHhPasAfk[portf,t] =E= (1 - mtHhPasAfk[portf,t]) * rHhPasAfk[portf,t];
    E_mrHhAktAfk[portf,t]$(t.val > %NettoFin_t1%)..
      mrHhAktAfk[portf,t] =E= (1 - mtHhAktAfk[portf,t]) * rHhAktAfk[portf,t];

    # Marginalt afkast efter skat på vHhx (husholdningernes formue ekskl. pension, bolig og realkreditgæld) 
    E_mrHhxAfk[t]$(t.val > %NettoFin_t1%)..
      mrHhxAfk[t] =E= sum(portf, dvHhAkt2dvHhx[portf,t-1] * mrHhAktAfk[portf,t]) 
                    - dvHhPas2dvHhx['Bank',t-1] * mrHhPasAfk['Bank',t]
                    + jmrHhxAfk[t];

    E_dvHhxAfk2dvBolig[t]$(t.val > %NettoFin_t1%)..
      dvHhxAfk2dvBolig[t] =E= sum(portf, dvHhAkt2dvBolig[portf,t-1] * mrHhAktAfk[portf,t])
                            - dvHhPas2dvBolig['Bank',t-1] * mrHhPasAfk['Bank',t];

    # ------------------------------------------------------------------------------------------------------------------
    # Portfolio and capital income
    # ------------------------------------------------------------------------------------------------------------------
    # vHhx opdeles i aktiver og bankgæld
    E_vHhPas_Bank_aTot[t]$(t.val >= %NettoFin_t1%)..
      vHhPas['Bank',aTot,t] =E= sum(fin_akt, vHhAkt[fin_akt,aTot,t]) - vHhx[aTot,t];

    E_vHhAkt_aTot[portf,t]$(fin_akt[portf] and d1vHhAkt[portf,t] and t.val > %AgeData_t1%)..
      vHhAkt[portf,aTot,t] =E= (cHh_a[portf,aTot,t] + cHh_t[portf,t] * nPop[aTot,t]) * vBVT2hLsnit[t]
                             + dvHhAkt2dvHhx[portf,t] * vHhx[aTot,t]
                             + dvHhAkt2dvBolig[portf,t] * pBoligRigid[t] * qBolig[aTot,t];

    # Bemærk at afkastet til beskatning ikke er lig rHhAktAfk * vHhAkt[aTot,t-1] pga. død
    E_vtHhxAfk_aTot[t]$(t.val > %NettoFin_t1%)..
      vtHhxAfk[aTot,t] =E= sum(a, vtHhxAfk[a,t] * nPop[a,t]);
    E_vRealkreditFradrag_aTot[t]$(t.val > %NettoFin_t1%)..
      vRealkreditFradrag[aTot,t] =E= sum(a, vRealkreditFradrag[a,t] * nPop[a,t]);

    E_rHhAktAfk[portf,t]$(t.val > %NettoFin_t1%)..
      rHhAktAfk[portf,t] =E= rRente[portf,t] + rOmv[portf,t] - rHhAktOmk[portf,t]
                             + jrHhAktRenter[portf,t] + jrHhAktOmv[portf,t];

    # Vi bestemmer j-led på pensionsafkast nedefra - dvs. fordelt på alder og pensionstype
    # J-leddet på omvurderingerne på pension fastsættes så pensionsafkastet ekskl. PAL-skat samt administrations- og investeringsomkostninger
    # er ens uanset om det bestemmes nedefra eller som her 
    E_jrHhAktOmv_PensTot[t]$(t.val > %NettoFin_t1%)..
      vHhPensAfk['PensTot',aTot,t] =E= rHhAktAfk['PensTot',t] * vHhAkt['PensTot',aTot,t-1]/fv 
                                     - (vtPAL[t] - vtPALudl[t]);
    # Vi har ikke indsat j-led i ovenstående relation for rHhAktAfk['PensTot',t], da denne ikke er fordelt på pens og a
#      (jrHhAktRenter['pensTot',t] + jrHhAktOmv['pensTot',t]) * vHhAkt['pensTot',aTot,t-1]/fv =E= 
#      sum(pens, jvHhPensAfk[pens,aTot,t] + jrHhPensAfk[pens,t] * vHhPens[pens,aTot,t-1]/fv);

    E_rHhPasAfk[portf,t]$( t.val > %NettoFin_t1%)..
      rHhPasAfk[portf,t] =E= rRente[portf,t] + rOmv[portf,t] + rHhPasOmk[portf,t] + jrHhPasRenter[portf,t] + jrHhPasOmv[portf,t];

    E_vHhAktRenter[portf,t]$(d1vHhAkt[portf,t] and t.val > %NettoFin_t1%)..
      vHhAktRenter[portf,t] =E= (rRente[portf,t] + jrHhAktRenter[portf,t]) * vHhAkt[portf,aTot,t-1]/fv;

    E_vHhPasRenter[portf,t]$(d1vHhPas[portf,t] and t.val > %NettoFin_t1%)..
      vHhPasRenter[portf,t] =E= (rRente[portf,t] + jrHhPasRenter[portf,t]) * vHhPas[portf,aTot,t-1]/fv;

    E_vHhNetRenter[t]$(t.val > %NettoFin_t1%)..
      vHhNetRenter[t] =E= sum(portf, vHhAktRenter[portf,t]) - sum(portf, vHhPasRenter[portf,t]);

    E_vHhAktOmv[portf,t]$(d1vHhAkt[portf,t] and t.val > %NettoFin_t1%)..
      vHhAktOmv[portf,t] =E= (rOmv[portf,t] + jrHhAktOmv[portf,t]) * vHhAkt[portf,aTot,t-1]/fv;

    E_vHhPasOmv[portf,t]$(d1vHhPas[portf,t] and t.val > %NettoFin_t1%)..
      vHhPasOmv[portf,t] =E= (rOmv[portf,t] + jrHhPasOmv[portf,t]) * vHhPas[portf,aTot,t-1]/fv;

    E_jvHhOmv[t]$(t.val > %NettoFin_t1%)..
      jvHhOmv[t] =E= sum(portf, jrHhAktOmv[portf,t] * vHhAkt[portf,aTot,t-1]/fv)
                     - sum(portf, jrHhPasOmv[portf,t] * vHhPas[portf,aTot,t-1]/fv);

    E_vHhOmv_tot[t]$(t.val > %NettoFin_t1%)..
      vHhOmv['Tot',t] =E= sum(portf, vHhAktOmv[portf,t]) - sum(portf, vHhPasOmv[portf,t]);

    # Administrations- og investeringsomkostninger
    E_rHhAktOmk_Bank[t]$(t.val > %NettoFin_t1%)..
      rHhAktOmk['Bank',t] =E= rRente['Bank',t] - rRenteBankIndskud[t];

    E_vHhAktOmk[portf,t]$(t.val > %NettoFin_t1% and (bank[portf] or pensTot[portf]))..
      vHhAktOmk[portf,t] =E= rHhAktOmk[portf,t] * vHhAkt[portf,aTot,t-1]/fv;

    E_vHhAktOmk_portfTot[t]$(t.val > %NettoFin_t1%)..
      vHhAktOmk['Tot',t] =E= sum(portf, vHhAktOmk[portf,t]);

    E_vHhPasOmk[portf,t]$(t.val > %NettoFin_t1% and (bank[portf] or RealKred[portf]))..
      vHhPasOmk[portf,t] =E= rHhPasOmk[portf,t] * vHhPas[portf,aTot,t-1]/fv;

    E_vHhPasOmk_portfTot[t]$(t.val > %NettoFin_t1%)..
      vHhPasOmk['Tot',t] =E= sum(portf, vHhPasOmk[portf,t]);

    E_rHhPasOmk_Bank[t]$(t.val > %NettoFin_t1%)..
      rHhPasOmk['Bank',t] =E= rRenteBankGaeld[t] - rRente['Bank',t];

    E_rHhPasOmk_RealKredit[t]$(t.val > %NettoFin_t1%)..
      rHhPasOmk['RealKred',t] =E= rBidragsSats[t];

    # ------------------------------------------------------------------------------------------------------------------
    # Pensions
    # ------------------------------------------------------------------------------------------------------------------
    # Pensionsakkumulation
    E_vHhPens_aTot[pens,t]$(t.val > %NettoFin_t1%)..
      vHhPens[pens,aTot,t] =E= vHhPens[pens,aTot,t-1]/fv 
                             + vHhPensAfk[pens,aTot,t]
                             + vHhPensIndb[pens,aTot,t]
                             - vHhPensUdb[pens,aTot,t];

    # Pensionsafkast
    E_vHhPensAfk_aTot[pens,t]$(t.val > %NettoFin_t1%)..
      vHhPensAfk[pens,aTot,t] =E= (rRente['PensTot',t] + rOmv['PensTot',t] - rHhAktOmk['PensTot',t]) * vHhPens[pens,aTot,t-1]/fv
                                  - (vtPAL[t] - vtPALudl[t]) * vHhPens[pens,aTot,t-1]/vHhAkt['PensTot',aTot,t-1]
                                  + jvHhPensAfk[pens,aTot,t] + jrHhPensAfk[pens,t] * vHhPens[pens,aTot,t-1]/fv;

    # Pensionsindbetalinger
    E_vHhPensIndb_aTot[pens,t]$(t.val > %NettoFin_t1%)..
      vHhPensIndb[pens,aTot,t] =E= rPensIndb[pens,aTot,t] * vWHh[aTot,t];

    # Samlede pensionsudbetalinger pr. pensionstype
    E_vHhPensUdb_aTot[pens,t]$(t.val > %NettoFin_t1%)..
      vHhPensUdb[pens,aTot,t] =E= rPensUdb[pens,aTot,t] * (vHhPens[pens,aTot,t-1]/fv + vHhPensAfk[pens,aTot,t]
                                                           + vHhPensIndb[pens,aTot,t]);

    # Pensionsudbetalinger som går til arvinge
    E_vPensArv_aTot[pens,t]$(t.val > %AgeData_t1%)..
      vPensArv[pens,aTot,t] =E= rPensArv[pens,aTot,t] * (vHhPens[pens,aTot,t-1]/fv + vHhPensAfk[pens,aTot,t]);

    # Samlet pensions- formue, indbetalinger, udbetalinger og afkast er sum af pensionstyper
    E_vHhAkt_pens_aTot[t]$(t.val > %NettoFin_t1%)..
      vHhAkt['pensTot',aTot,t] =E= sum(pens, vHhPens[pens,aTot,t]);
    E_vHhPensIndb_pension_aTot[t]$(t.val > %NettoFin_t1%)..
      vHhPensIndb['pensTot',aTot,t] =E= sum(pens, vHhPensIndb[pens,aTot,t]);
    E_vHhPensUdb_pension_aTot[t]$(t.val > %NettoFin_t1%)..
      vHhPensUdb['pensTot',aTot,t] =E= sum(pens, vHhPensUdb[pens,aTot,t]);
    E_vPensArv_pension_aTot[t]$(t.val > %AgeData_t1%)..
      vPensArv['pensTot',aTot,t]   =E= sum(pens, vPensArv[pens,aTot,t]);
    E_vHhPensAfk_pension_aTot[t]$(t.val > %NettoFin_t1%)..
      vHhPensAfk['pensTot',aTot,t] =E= sum(pens, vHhPensAfk[pens,aTot,t]);

    # Pensionsformue efter skat-approksimation
    E_vHhPensEfterSkat_tot[t].. 
      vHhPensEfterSkat[aTot,t] =E= vHhAkt['pensTot',aTot,t] - tPensKor[t] * (vHhPens['PensX',aTot,t] + vHhPens['kap',aTot,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Nettofordringserhvervelse for husholdningerne
    # ------------------------------------------------------------------------------------------------------------------
    E_vHhNFE[t]$(t.val > %NettoFin_t1%)..
      vHhNFE[t] =E= vHhNet[t] - vHhNet[t-1]/fv - vHhOmv['tot',t];

    # Other post model equations
    E_vHhFormue_tot[t]..
      vHhFormue[aTot,t] =E= vHhNet[t] + vBolig[aTot,t] - tPensKor[t] * (vHhPens['PensX',aTot,t] + vHhPens['kap',aTot,t]);
  $ENDBLOCK

  #  $BLOCK B_HHincome_forwardlooking
  #  $ENDBLOCK

  $BLOCK B_HHincome_a$(tx0[t])
    # ==================================================================================================================
    # Household accounting disaggregated by age
    # ==================================================================================================================

    # ==================================================================================================================
    # Composition effects and aggregate parameters tie together aggregate and disaggregate systems
    # ==================================================================================================================
    E_rPensIndb[pens,a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      rPensIndb[pens,a,t] =E= rPensIndb_a[pens,a,t] * (1 + jfrPensIndb[pens,t])
                           / (rPensIndb_a[pens,a,t] * (1 + jfrPensIndb[pens,t])
                              + (1 - rPensIndb_a[pens,a,t]) * (1 - jfrPensIndb[pens,t]));

    E_rPensUdb[pens,a,t]$(a15t100[a] and t.val > %AgeData_t1% and (d1vHhPens[pens,t] or d1vHhPens[pens,t-1]))..
      rPensUdb[pens,a,t] =E= rPensUdb_a[pens,a,t] * (1 + jfrPensUdb[pens,t])
                           / (rPensUdb_a[pens,a,t] * (1 + jfrPensUdb[pens,t])
                              + (1 - rPensUdb_a[pens,a,t]) * (1 - jfrPensUdb[pens,t]));

    # ==================================================================================================================
    # Household accounting disaggregated by age
    # ==================================================================================================================
    # ------------------------------------------------------------------------------------------------------------------
    # Housing
    # ------------------------------------------------------------------------------------------------------------------
    E_rRealKred2Bolig[a,t]$(a18t100[a] and t.val > %AgeData_t1%)..
      rRealKred2Bolig[a,t] =E= (rRealKred2Bolig_a[a,t] + rRealKred2Bolig_t[t]) * pBoligRigid[t] / pBolig[t];

    E_vHhPas_RealKred[a,t]$(a18t100[a] and t.val > %AgeData_t1%)..
      vHhPas['RealKred',a,t] =E= rRealKred2Bolig[a,t] * vBolig[a,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Net financial assets budget constraint
    # ------------------------------------------------------------------------------------------------------------------
    E_vHhInd[a,t]$(a0t100[a] and t.val > %AgeData_t1%)..
      vHhInd[a,t] =E= vWHh[a,t]
                    + vHhOvf[a,t]
                    + vHhPensUdb['pensTot',a,t] - vHhPensIndb['pensTot',a,t]
                    - vtHhx[a,t]
                    + vArv[a,t] + vArvKorrektion[a,t]
                    + vHhNFErest[a,t];

    # Aldersfordelt vtHh, dog er vtEjd, vtDoedsbo, vtPensArv og vtPAL fjernet, da de fratrækkes i vBoligUdgift, vArv og vHhPensUdb. Endelig fjernes skat på kapitalindkomst vtHhxAfk.
    E_vtHhx[a,t]$(a0t100[a] and t.val > %AgeData_t1%)..
      vtHhx[a,t] =E= vtBund[a,t] 
                   + vtMellem[a,t] 
                   + vtTop[a,t] 
                   + vtTopTop[a,t] 
                   + vtKommune[a,t] 
                   + vtAktieHh[a,t] 
                   + vtVirksomhed[a,t] 
                   + vtHhAM[a,t]
                   + vtPersRest[a,t]
                   + vtHhVaegt[a,t]                
                   + utMedie[t] * vSatsIndeks[t] * a18t100[a]
                   + vtArv[a,t]
                   + vBidrag[a,t]
                   + vtKirke[a,t]
                   + vtLukning[a,t]
                   - vtHhxAfk[a,t]
                   + vRealkreditFradrag[a,t] # Realkredit fradrag indgår i vBoligUdgift
                   + (jvtKilde[t] + jvtDirekte[t]) / nPop[aTot,t];

    E_vHhNFErest[a,t]$(a0t100[a] and t.val > %AgeData_t1%)..
      vHhNFErest[a,t] =E= vHhFraMigration[a,t]
                        + (vHhNFErest[aTot,t] - vHhFraMigration[aTot,t]) * (vWHh[a,t] + vHhOvf[a,t]) / (vWHh[aTot,t] + vOvf['HhTot',t]);

    # Vi antager at ind/ud-vandrere kommer og går med samme formue, som de øvrige i samme aldersgruppe
    E_vHhFraMigration[a,t]$(a.val > 0)..
      vHhFraMigration[a,t] =E= (1-fMigration[a,t]) # (nPop[a,t] - rOverlev[a-1,t-1] * nPop[a-1,t-1]) / nPop[a,t]
                             * ((1+mrHhxAfk[t]) * vHhx[a-1,t-1]/fv + vArvBolig[a,t] + vHhPensEfterSkat[a,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Portfolio and capital income
    # ------------------------------------------------------------------------------------------------------------------
    # vHhx opdeles i aktiver og bankgæld
    E_vHhPas_Bank[a,t]$(t.val > %AgeData_t1%)..
      vHhPas['Bank',a,t] =E= sum(fin_akt, vHhAkt[fin_akt,a,t]) - vHhx[a,t];

    E_vHhAkt[portf,a,t]$(fin_akt[portf] and d1vHhAkt[portf,t] and t.val > %AgeData_t1%)..
      vHhAkt[portf,a,t] =E= (cHh_a[portf,a,t] + cHh_t[portf,t]) * vBVT2hLsnit[t]
                            + dvHhAkt2dvHhx[portf,t] * vHhx[a,t]
                            + dvHhAkt2dvBolig[portf,t] * pBoligRigid[t] * qBolig[a,t];

    E_vtHhxAfk[a,t]$(a.val > 0 and t.val > %AgeData_t1%)..
      vtHhxAfk[a,t] =E= sum(portf$(obl[portf] or bank[portf]), mtHhAktAfk[portf,t] * rHhAktAfk[portf,t] * vHhAkt[portf,a-1,t-1]/fv * fMigration[a,t])
                      + vtAktieHh[a,t]
                      - mtHhPasAfk['Bank',t] * rHhPasAfk['Bank',t] * vHhPas['Bank',a-1,t-1]/fv * fMigration[a,t];

    E_vRealkreditFradrag[a,t]$(a.val > 0 and t.val > %AgeData_t1%)..
      vRealkreditFradrag[a,t] =E= mtHhPasAfk['RealKred',t] * rHhPasAfk['RealKred',t] * vHhPas['RealKred',a-1,t-1]/fv * fMigration[a,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Pensions
    # ------------------------------------------------------------------------------------------------------------------
    # Pensionsakkumulation
    # Formue og afkast ganges med nPop[a-1,t-1]/nPop[a,t], da der udbetales bonus alt efter, hvor mange der overlever
    E_vHhPens[pens,a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vHhPens[pens,a,t] =E= (vHhPens[pens,a-1,t-1]/fv + vHhPensAfk[pens,a,t] - vPensArv[pens,a,t] * (1-rOverlev[a-1,t-1]))
                          * nPop[a-1,t-1] / nPop[a,t]
                          + vHhPensIndb[pens,a,t] - vHhPensUdb[pens,a,t];

    # Pensionsafkast
    E_vHhPensAfk[pens,a,t]$(a.val >= 15 and t.val > %AgeData_t1%)..
      vHhPensAfk[pens,a,t] =E= (rRente['PensTot',t] + rOmv['PensTot',t] - rHhAktOmk['PensTot',t]) * vHhPens[pens,a-1,t-1]/fv
                             - (vtPAL[t] - vtPALudl[t]) * vHhPens[pens,a-1,t-1]/vHhAkt['PensTot',aTot,t-1]
                             + jvHhPensAfk[pens,a,t] + jrHhPensAfk[pens,t] * vHhPens[pens,a-1,t-1]/fv;

    # Pensionsindbetalinger
    E_vHhPensIndb[pens,a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vHhPensIndb[pens,a,t] =E= rPensIndb[pens,a,t] * vWHh[a,t];

    # Pensionsudbetalinger til levende og døde
    E_vHhPensUdb[pens,a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vHhPensUdb[pens,a,t] =E= rPensUdb[pens,a,t] 
                              * ((vHhPens[pens,a-1,t-1]/fv + vHhPensAfk[pens,a,t] 
                                  - vPensArv[pens,a,t] * (1-rOverlev[a-1,t-1])) * nPop[a-1,t-1] / nPop[a,t]
                                 + vHhPensIndb[pens,a,t]);

    E_vPensArv[pens,a,t]$(a.val >= 15 and t.val > %AgeData_t1%)..
      vPensArv[pens,a,t] =E= rPensArv[pens,a,t] * (vHhPens[pens,a-1,t-1]/fv + vHhPensAfk[pens,a,t]);

    # Samlet pensions- formue, indbetalinger, udbetalinger og afkast er sum af pensionstyper
    E_vHhAkt_pens[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vHhAkt['pensTot',a,t] =E= sum(pens, vHhPens[pens,a,t]);
    E_vHhPensIndb_pension[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vHhPensIndb['pensTot',a,t] =E= sum(pens, vHhPensIndb[pens,a,t]);
    E_vHhPensUdb_pension[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vHhPensUdb['pensTot',a,t] =E= sum(pens, vHhPensUdb[pens,a,t]);
    E_vPensArv_pension[a,t]$(a.val >= 15 and t.val > %AgeData_t1%)..
      vPensArv['pensTot',a,t] =E= sum(pens, vPensArv[pens,a,t]);
    E_vHhPensAfk_pension[a,t]$(a.val >= 15 and t.val > %AgeData_t1%)..
      vHhPensAfk['pensTot',a,t] =E= sum(pens, vHhPensAfk[pens,a,t]);

    # Other post model equations
    # Formuebegreb
    E_vHhAkt_tot[a,t]$(t.val > %AgeData_t1%)..
      vHhAkt['tot',a,t] =E= sum(portf, vHhAkt[portf,a,t]);

    E_vHhPas_tot[a,t]$(t.val > %AgeData_t1%)..
      vHhPas['tot',a,t] =E= sum(portf, vHhPas[portf,a,t]);

    E_vHhFormue[a,t]$(a0t100[a] and t.val > %AgeData_t1%)..
      vHhFormue[a,t] =E= sum(portf, vHhAkt[portf,a,t] - vHhPas[portf,a,t]) + vBolig[a,t] - tPensKor[t] * (vHhPens['PensX',a,t] + vHhPens['kap',a,t]);
  
    E_vHhPensEfterSkat[a,t]$(a0t100[a])..
      vHhPensEfterSkat[a,t] =E= vHhAkt['pensTot',a,t] - tPensKor[t] * (vHhPens['PensX',a,t] + vHhPens['kap',a,t]);
 
    E_vHhFormue_h[h,a,t]$(a0t100[a])..
      vHhFormue_h[h,a,t] =E= vHhFormue[a,t];

    E_vFrivaerdi_h[h,a,t]$(a0t100[a])..
      vFrivaerdi_h[h,a,t] =E= (pBolig[t] * (1-rRealKred2Bolig[a,t]) * qBolig_h[h,a,t]); 
    
    E_vHhPensEfterSkat_h[h,a,t]$(a0t100[a])..
      vHhPensEfterSkat_h[h,a,t] =E= (1 - tPensKor[t]) * (vHhPens['kap',a,t] + vHhPens['PensX',a,t]) + vHhPens['alder',a,t];

    E_vHhIndMv_h[h,a,t]$(a0t100[a])..
      vHhIndMv_h[h,a,t] =E= vHhInd_h[h,a,t] + (rRealKred2Bolig[a,t] * pBolig[t] - rRealKred2Bolig[a-1,t-1] * pBolig[t-1]) 
                                        * qBolig_h[h,a-1,t-1]/fv * fMigration[a,t];

    E_vBolig_h[h,a,t]$(a18t100[a] and t.val > %AgeData_t1%).. vBolig_h[h,a,t] =E= pBolig[t] * qBolig_h[h,a,t];

    E_vHhIndMv[a,t]$(a0t100[a])..
      vHhIndMv[a,t] =E= vHhInd[a,t] + (rRealKred2Bolig[a,t] * pBolig[t] - rRealKred2Bolig[a-1,t-1] * pBolig[t-1]) 
                                      * qBolig[a-1,t-1]/fv * fMigration[a,t];
  $ENDBLOCK

  $BLOCK B_HHincome_a_tot$(tx0[t])
     # Portfolio
    E_cHh_a_aTot[portf,t]$(fin_akt[portf] and d1vHhAkt[portf,t] and t.val > %AgeData_t1%)..
      vHhAkt[portf,aTot,t] =E= sum(a, vHhAkt[portf,a,t] * nPop[a,t]);

    # Pensionsindbetalinger
    E_rPensIndb_aTot[pens,t]$(t.val > %AgeData_t1%)..
      vHhPensIndb[pens,aTot,t] =E= sum(a, vHhPensIndb[pens,a,t] * nPop[a,t]);

    # Vi beregner kun med log j-ledet, hvis j-ledet er forskelligt fra 0 eller endogeniseret, da det er problematisk at løse
    E_rPensUdb_aTot[pens,t]$(t.val > %AgeData_t1% and (d1vHhPens[pens,t-1] or d1vHhPens[pens,t-1]))..  # Alderspensionen eksisterer først fra 2013 og frem
      vHhPensUdb[pens,aTot,t] =E= sum(a, vHhPensUdb[pens,a,t] * nPop[a,t]) + vPensArv[pens,aTot,t];

    # Pensionsudbetalinger som går til arvinge
    E_rPensArv_aTot[pens,t]$(t.val > %AgeData_t1% and (d1vHhPens[pens,t-1] or d1vHhPens[pens,t-1]))..
      vPensArv[pens,aTot,t] =E= sum(a, vPensArv[pens,a,t] * nPop[a-1,t-1] * (1-rOverlev[a-1,t-1]));

    E_jvHhPensAfk_aTot[pens,t]$(t.val > %AgeData_t1%)..
      vHhPensAfk[pens,aTot,t] =E= sum(a, vHhPensAfk[pens,a,t] * nPop[a-1,t-1]);

    E_rRealKred2Bolig_aTot[t]$(t.val > %AgeData_t1%)..
      vHhPas['RealKred',aTot,t] =E= sum(a, vHhPas['RealKred',a,t] * nPop[a,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Pensions
    # ------------------------------------------------------------------------------------------------------------------
    # Other post model equations
    # Formuebegreb
    E_vHhFormue_h_tot[h,t].. 
      vHhFormue_h[h,aTot,t] =E= sum(a, rHhAndel[h] * vHhFormue_h[h,a,t] * nPop[a,t]);

    E_vFrivaerdi_h_tot[h,t].. vFrivaerdi_h[h,aTot,t] =E= sum(a, rHhAndel[h] * vFrivaerdi_h[h,a,t] * nPop[a,t]);
    
    E_vHhPensEfterSkat_h_tot[h,t].. vHhPensEfterSkat_h[h,aTot,t] =E= sum(a, rHhAndel[h] * vHhPensEfterSkat_h[h,a,t] * nPop[a,t]);
    
    E_vHhIndMv_h_tot[h,t].. vHhIndMv_h[h,aTot,t] =E= sum(a, rHhAndel[h] * vHhIndMv_h[h,a,t] * nPop[a,t]);
    
    E_vBolig_h_tot[h,t]$(t.val > %AgeData_t1%).. vBolig_h[h,aTot,t] =E= pBolig[t] * qBolig_h[h,aTot,t];

    E_vHhIndMv_tot[t].. vHhIndMv[aTot,t] =E= sum(a, vHhIndMv[a,t] * nPop[a,t]);

  $ENDBLOCK

  MODEL M_HhIncome /
    B_HHincome_static
    #  B_HHincome_forwardlooking
    B_Hhincome_a
    B_HHincome_a_tot
  /; 

  $GROUP G_HhIncome_static
    G_HhIncome_endo
   -G_HhIncome_endo_a # Påvirker alene aldersfordelte størrelser
   -G_HhIncome_endo_a_tot
  ;
$ENDIF

$IF %stage% == "exogenous_values":  
# ======================================================================================================================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_HhIncome_makrobk
    vHhAkt$(aTot[a_] and t.val >= %NettoFin_t1%), vHhPas$(aTot[a_] and t.val >= %NettoFin_t1%), vHhNet
    vHhAktOmk, rHhAktOmk, vHhPasOmk, rHhPasOmk
    vBolig$(aTot[a_]), vHhNFErest$(aTot[a_]), rRealKred2Bolig$(aTot[a_])
    vHhNetRenter, vHhAktRenter, vHhPasRenter, vHhOmv, vHhAktOmv, vHhPasOmv, vHhNFE
    vKolPensKor, rKolPens, vLejeAfEjerBolig
    vHhFraVirkOev, vHhFraVirkKap, vHhTilUdl, vHhPens$(aTot[a_])
    vHhPensIndb$(aTot[a_] and t.val >= %NettoFin_t1%), vHhPensUdb$(aTot[a_] and t.val >= %NettoFin_t1%), vHhPensAfk$(aTot[a_] and t.val >= %NettoFin_t1%)
    vDispInd$(t.val >= 2000)
  ;
  @load(G_HHincome_makrobk, "..\Data\makrobk\makrobk.gdx")

  # Aldersfordelt data fra aldersprofiler indlæses
  $GROUP G_HHincome_aldersprofiler     
    vHhAkt$(a[a_] and not PensTot[portf_]), vHhPas$(a[a_])
    vBolig$(a[a_]), vHhNFErest$(a[a_]), rRealKred2Bolig$(a[a_])
    dvHhAkt2dvHhx, dvHhPas2dvHhx, dvHhAkt2dvBolig, dvHhPas2dvBolig
  ; 
  $GROUP G_HHincome_aldersprofiler
    G_HHincome_aldersprofiler$(t.val >= %AgeData_t1%)
  ;
  @load(G_HHincome_aldersprofiler, "..\Data\aldersprofiler\aldersprofiler.gdx")

  $GROUP G_HHincome_pension
    # Pensionsvariable dækker alle datadækkede år
    vHhAkt$(a[a_] and PensTot[portf_]), vHhPens$(a[a_])
    rPensArv, rPensUdb_a, vHhPensAfk$(a[a_]), vHhPensIndb$(a[a_]), vHhPensUdb$(a[a_]), vPensArv    
  ;
  @load(G_HHincome_pension, "..\Data\pension\pension.gdx")


  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_HHincome_data 
    G_HhIncome_makrobk
    rPensUdb_a
  ; 
  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_HHincome_data_imprecise
    vHhNFErest$(aTot[a_])
    vHhNFE
#    vHhx$(aTot[a_])
#    vHhPas$(Bank[portf_] and aTot[a_])
#    vHhNet
    vHhPensIndb$((t.val >= %NettoFin_t1% and aTot[a_]) or (a[a_] and tAgeData[t]))
    vHhPensUdb$((t.val >= %NettoFin_t1% and aTot[a_]) or (a[a_] and tAgeData[t]))
    vDispInd$(t.val >= 2000)
    vHhNetRenter$(t.val = 2001 or t.val = 2002 or t.val = 2006 or t.val = 2013 or t.val = 2017 or t.val = 2018)
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================

  # Ca. skattesats på ubeskattet pensionsformue til beregning af formue-variable
  tPensKor.l[t] = 0.4;

  rRealKredTraeg.l = 0.8;

# ======================================================================================================================
# Data assignment
# ======================================================================================================================

  #Set Dummy for household portfolio
  d1vHhAkt[portf_,t] = yes$(vHhAkt.l[portf_,aTot,t] <> 0);
  d1vHhPas[portf_,t] = yes$(vHhPas.l[portf_,aTot,t] <> 0);
  d1vHhPens[pens,t] = yes$(vHhPens.l[pens,aTot,t] <> 0);
  d1vHhPens['pensTot',t] = yes$(vHhAkt.l['pensTot',aTot,t] <> 0);
  #Initialt sættes pBoligRigid til boligprisen. 
  pBoligRigid.l[t] = pBolig.l[t] ; 

  qBolig.l[a,t]$(tData[t]) = vBolig.l[a,t] / pBolig.l[t];
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_HhIncome_static_calibration_base 
    G_HHincome_endo
    -vKolPensKor[t], vKolPensKorRest[t]
    -vLejeAfEjerBolig[t], rBoligOmkRestRes[t]
    -vHhAktRenter[portf,t], jrHhAktRenter[portf,t]$(t.val > %NettoFin_t1% and d1vHhAkt[portf,t]) 
    -vHhPasRenter[portf,t], jrHhPasRenter[portf,t]$(t.val > %NettoFin_t1% and d1vHhPas[portf,t]) 
    -vHhAktOmv[portf,t]$(not PensTot[portf]), jrHhAktOmv[portf,t]$(t.val > %NettoFin_t1% and d1vHhAkt[portf,t] and not PensTot[portf])
    -vHhPasOmv[portf,t], jrHhPasOmv[portf,t]$(t.val > %NettoFin_t1% and d1vHhPas[portf,t])

    ErAktieAfk_static$(t.val > %NettoFin_t1%) # E_ErAktieAfk_static
    -vHhFraVirkKap, rHhFraVirkKap
    -vHhFraVirkOev, rHhFraVirkOev
    -vHhTilUdl$(t.val >= 1995), rHhTilUdlRest$(t.val >= 1995)
  ;
  $BLOCK B_HHincome_static_calibration_base$(tx0[t])
    # Forventet marginalafkast beregnes ud fra forventede afkast ikke realiserede
    E_ErAktieAfk_static[t]$(t.val > %NettoFin_t1%)..
      ErAktieAfk_static[t] =E= rAktieDrift[t] * vAktieDrift[t-1]/vAktie[t-1] 
                             + rRente['Obl',t] * vVirkAkt['Obl',t-1]/vAktie[t-1] 
                             + rRente['Bank',t] * vVirkAkt['Bank',t-1]/vAktie[t-1] 
                             + ErAktieAfk_static[t] * (vVirkAkt['IndlAktier',t-1] + vVirkAkt['UdlAktier',t-1]) / vAktie[t-1]
                             - rRente['Realkred',t] * vVirkPas['RealKred',t-1] / vAktie[t-1];
  $ENDBLOCK

  $GROUP G_HhIncome_static_calibration_newdata 
    G_HhIncome_static_calibration_base
    -G_HHincome_endo_a
  # Beregninger af led som er endogene i aldersdel (skal være uændret, når de beregnes endogent)
    -vHhPas[RealKred,aTot,t], rRealKred2Bolig[aTot,t]
    -vHhPensAfk[pens,aTot,t], jrHhPensAfk[pens,t]
    -vHhPensIndb[pens,aTot,t], rPensIndb[pens,aTot,t]
    -vHhPensUdb[pens,aTot,t]$(d1vHhPens[pens,t] or d1vHhPens[pens,t-1])
      rPensUdb[pens,aTot,t]$(d1vHhPens[pens,t] or d1vHhPens[pens,t-1])
    -vHhAkt[fin_akt,aTot,t]$(d1vHhAkt[fin_akt,t]), cHh_a[fin_akt,aTot,t]$(d1vHhAkt[fin_akt,t])
  ;
  $GROUP G_HhIncome_static_calibration_newdata
    G_HhIncome_static_calibration_newdata$(tx0[t])
  ;
  MODEL M_HhIncome_static_calibration_newdata /
    M_HHincome 
    -B_HHincome_a
    #-B_HHincome_a_tot
    B_HHincome_static_calibration_base
  /;

  $GROUP G_HhIncome_static_calibration
    G_HhIncome_static_calibration_base
    jmrHhxAfk[t]$(t.val > %NettoFin_t1%) # E_jmrHhxAfk
    -vHhPas[RealKred,a18t100,t]$(t.val > %AgeData_t1%), 
    rRealKred2Bolig_a[a18t100,t]$(t.val > %AgeData_t1%)
    -vHhPensAfk[pens,a,t], jvHhPensAfk[pens,a_,t]$(aVal[a_] >= 15 and t.val > %AgeData_t1%)
    jrHhPensAfk[pens,t]$(t.val > %AgeData_t1%) # E_jvHhPensAfk_aTot_static
    # Alderspension har afkast i 2013, men eksisterer ikke i 2012! - så vi bruger additivt j-led før AgeData_t1
    -vHhPensAfk[pens,aTot,t]$(t.val <= %AgeData_t1%), jvHhPensAfk[pens,aTot,t]$(t.val <= %AgeData_t1%)
    -vHhPensIndb[pens,a15t100,t]$(t.val > %AgeData_t1%), rPensIndb_a[pens,a15t100,t]$(t.val > %AgeData_t1%)
    -vHhPensIndb[pens,aTot,t]$(t.val <= %AgeData_t1%), rPensIndb[pens,aTot,t]$(t.val <= %AgeData_t1%)
    -vHhPensUdb[pens,aTot,t]$(t.val <= %AgeData_t1% and (d1vHhPens[pens,t] or d1vHhPens[pens,t-1]))
      rPensUdb[pens,aTot,t]$(t.val <= %AgeData_t1% and (d1vHhPens[pens,t] or d1vHhPens[pens,t-1]))
    -vHhAkt[fin_akt,a_,t]$(d1vHhAkt[fin_akt,t] and aVal[a_] <> 70), cHh_a[fin_akt,a,t]$(d1vHhAkt[portf_,t] and t.val > %AgeData_t1%)  # Vi udlader én aldersgruppe, men eksogeniserer totalen       
  ;
  $GROUP G_HhIncome_static_calibration
    G_HhIncome_static_calibration$(tx0[t])
  ;
  $BLOCK B_HHIncome_Static_calibration$(tx0[t])
    E_jmrHhxAfk[t]$(t.val > %NettoFin_t1%)..
      mrHhxAfk[t] =E= sum(portf$(IndlAktier[portf] or UdlAktier[portf]), dvHhAkt2dvHhx[portf,t-1] * (1-mtHhAktAfk[portf,t]) * ErAktieAfk_static[t])
                    + sum(portf$(Obl[portf] or Bank[portf]), dvHhAkt2dvHhx[portf,t-1] * (1-mtHhAktAfk[portf,t]) * rRente[portf,t]) 
                    - dvHhPas2dvHhx['Bank',t-1] * (1-mtHhPasAfk['Bank',t]) * rRente['Bank',t];

    E_jvHhPensAfk_aTot_static[pens,t]$(t.val > %AgeData_t1%)..
      jvHhPensAfk[pens,aTot,t] =E= 0;
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
    rPensIndb_a[pens,a15t100,tx1] # E_rPensIndb_a_forecast
  ;
  $GROUP G_HHincome_deep G_HHincome_deep$(tx0[t]);

  $BLOCK B_HHIncome_deep
    E_rPensIndb_a_forecast[pens,a,t]$(a15t100[a] and tx1[t])..
      rPensIndb[pens,a,t] =E= rPensIndb2loensum[pens,a,t] * vLoensum[sTot,t] / vWHh[aTot,t];

      #  vHhPensAfk[pens,a,t] =E= rHhAfk['pensTot',t] * vHhNet[pens,a-1,t-1]/fv
      #                           - vtPAL[t] * vHh[pens,a-1,t-1]/vHh['pensTot',aTot,t-1]
      #                           + jvHhPensAfk[pens,a,t];

      #  vHhPensAfk[pens,a,t] =E= rPensAfk2Pens[pens,a,t] * vHh[pens,aa-1,t-1]/fv / sum(aa, rPensAfk2Pens[pens,aa,t] * vHh[pens,aa-1,t-1]/fv);
  $ENDBLOCK
  MODEL M_HHincome_deep /
    M_HHincome
    B_HHIncome_deep
  /;
$ENDIF

# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
  $GROUP G_HHincome_dynamic_calibration
    G_HHincome_endo

    -vHhTilUdl[t1], rHhTilUdlRest[t1]
    -vHhAkt[fin_akt,aTot,t1]$(d1vHhAkt[fin_akt,t1]), cHh_t[fin_akt,t1]$(d1vHhAkt[fin_akt,t1])
    cHh_t[fin_akt,tx1]$(d1vHhAkt[fin_akt,tx1])
    -vHhPas[RealKred,aTot,t1], rRealKred2Bolig_t[t1]
    rRealKred2Bolig_t[tx1] # E_rRealKred2Bolig_t

    # Vi matcher til data i foreløbige år
    -vHhPensAfk[pens,aTot,t1], jrHhPensAfk[pens,t1]
    -vHhPensIndb[pens,aTot,t1]$(vHhPensIndb.l[pens,aTot,t1] <> 0), jfrPensIndb[pens,t1]$(vHhPensIndb.l[pens,aTot,t1] <> 0) # Ved nul samlede indbetalinger er j-led ikke velbestemt, da indbetalingsrater for alle aldre også er 0
    -vHhPensUdb[pens,aTot,t1], jfrPensUdb[pens,t1]
  ;
   $BLOCK B_HHincome_dynamic_calibration
    E_rRealKred2Bolig_t[t]$(tx1[t])..
      rRealKred2Bolig_t[t] =E= rRealKred2Bolig_t_baseline[t]
                            + (permanens + (1-permanens) * 0.9**(dt[t]**1.5))
                            * (rRealKred2Bolig_t[t1] - rRealKred2Bolig_t_baseline[t1]);

    E_cHh_t_forecast[portf_,t]$(tx1[t] and fin_akt[portf_] and d1vHhAkt[portf_,t] and not sameas['bank',portf_])..
      @gradual_return_to_baseline(cHh_t);

    E_cHh_t_bank_forecast[fin_akt,t]$(sameas['bank',fin_akt] and tx1[t])..
      cHh_t[fin_akt,t] =E= cHh_t_baseline[fin_akt,t]
                         + (permanens + (1-permanens) * 0.9**(dt[t]**1.5))
                         * (cHh_t[fin_akt,t1] - cHh_t_baseline[fin_akt,t1]);
   $ENDBLOCK
  MODEL M_HHincome_dynamic_calibration /
    M_HHincome
     B_HHincome_dynamic_calibration
  /;
$ENDIF
