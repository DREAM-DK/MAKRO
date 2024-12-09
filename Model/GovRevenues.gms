# ======================================================================================================================
# Government revenues
# - See also taxes module
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_GovRevenues_prices_endo ;
  $GROUP G_GovRevenues_quantities_endo ;

  $GROUP G_GovRevenues_values_endo_a
    vtBund[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Bundskatter, Kilde: ADAM[Ssysp1]"
    vtTop[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Topskatter, Kilde: ADAM[Ssysp2]+ADAM[Ssysp3]"
    vtMellem[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Mellemskatter, Kilde: ADAM[Ssyt1]"
    vtTopTop[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Toptopskatter, Kilde: ADAM[Ssyt3]"
    vtKommune[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Kommunal indkomstskatter, Kilde: ADAM[Ssys1]+ADAM[Ssys2]"
    vtEjd[a_,t]$((aVal[a_] >= 18) and t.val > %AgeData_t1%) "Ejendomsværdibeskatning, Kilde: ADAM[Spzej]"
    vtAktie[a_,t]$(a0t100[a_] and t.val > %AgeData_t1%) "Aktieskat, Kilde: ADAM[Ssya]"
    vtVirksomhed[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Virksomhedsskat, Kilde: ADAM[Ssyv]"
    vtDoedsbo[a_,t]$(a[a_] and t.val > %AgeData_t1%) "Dødsboskat, Kilde: ADAM[Ssyd]"
    vtHhAM[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Arbejdsmarkedsbidrag betalt af husholdningerne, Kilde: ADAM[Sya]"
    vtPersRest[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Andre personlige indkomstskatter, Kilde: ADAM[Syp]"
    vtKapPens[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Andre personlige indkomstskatter fratrukket andre personlige indkomstskatter resterende, ADAM[Syp]-ADAM[Sypr]"
    vtKapPensArv[a_,t]$(aVal[a_] >= 15 and t.val > %AgeData_t1%) "Kapitalskatter betalt i forbindelse med dødsfald og arv - ikke-datadækket hjælpevariabel."
    vtHhVaegt[a_,t]$((a18t100[a_]) and t.val > %AgeData_t1%) "Vægtafgifter fra husholdningerne, Kilde: ADAM[Syv]"
    vtLukning[a_,t]$(a0t100[a_] and t.val > %AgeData_t1%) "Beregningsteknisk skat til lukning af offentlig budgetrestriktion på lang sigt (HBI=0). Indgår IKKE i offentlig saldo."
    vtArv[a_,t]$(t.val > %AgeData_t1%) "Kapitalskatter (Arveafgift), Kilde: ADAM[sK_h_o] for total."
    vBidrag[a_,t]$((a15t100[a_] and t.val > %AgeData_t1%)) "Bidrag til sociale ordninger, Kilde: ADAM[Tp_h_o]"
    vtKirke[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Kirkeskat, Kilde: ADAM[Trks]"
    # Indkomstbegreber og fradrag 
    vPersInd[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Personlig indkomst, Kilde: ADAM[Ysp]"
    vPersIndx[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Personlig indkomst, Kilde: ADAM[Yt]"
    vPersIndRest[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > %AgeData_t1%) "Aggregeret restled til personindkomst."
    vSkatteplInd[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Skattepligtig indkomst, Kilde: ADAM[Ys]"
    vNetKapIndPos[a_,t]$((a15t100[a_] and t.val > %AgeData_t1% )) "Positiv nettokapitalindkomst."
    vNetKapInd[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Nettokapitalindkomst, Kilde: Aggregat fra kapitalindkomst fra PSKAT2"
    vKapIndPos[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Imputeret positiv kapitalindkomst."
    vKapIndNeg[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Imputeret negativ kapitalinkomst, Kilde: Aggregat fra renteudgifter fra PSKAT2."
    vPersFradrag[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Imputeret personfradrag."
    vAKFradrag[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Imputeret fradrag for A-kassebidrag."
    vELFradrag[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Imputeret fradrag for efterlønsbidrag."
    vRestFradrag[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Imputerede øvrige ligningsmæssige fradrag (befordringsfradrag m.m.)"
    vBeskFradrag[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Imputeret beskæftigelsesfradrag."
    vRealiseretAktieOmv[a_,t]$(a[a_] and t.val > %AgeData_t1%) "Skøn over realiserede gevinst ved salg af aktier."
  ;

  $GROUP G_GovRevenues_values_endo
    G_GovRevenues_values_endo_a
  
    # Primære indtægter
    vOffPrimInd[t] "Primære offentlige indtægter, Kilde: ADAM[Tf_z_o]-ADAM[Tioii]"

    # Direkte skatter
    vtDirekte[t] "Direkte skatter, Kilde: ADAM[Sy_o]"
    vtKilde[t] "Kildeskatter, Kilde: ADAM[Syk]"
    vtPersonlige[t] "Personlige skatter."
    vtBund[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "Bundskatter, Kilde: ADAM[Ssysp1]"
    vtTop[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "Topskatter, Kilde: ADAM[Ssysp2]+ADAM[Ssysp3]"
    vtMellem[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "Mellemskatter, Kilde: ADAM[Ssyt1]"
    vtTopTop[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "Toptopskatter, Kilde: ADAM[Ssyt3]"
    vtKommune[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "Kommunal indkomstskatter, Kilde: ADAM[Ssys1]+ADAM[Ssys2]"
    vtEjd[a_,t]$(aTot[a_]) "Ejendomsværdibeskatning, Kilde: ADAM[Spzej]"
    vtAktie[a_,t]$(aTot[a_] and t.val > %NettoFin_t1%) "Aktieskat, Kilde: ADAM[Ssya]"
    vtVirksomhed[a_,t]$(aTot[a_] and t.val > 1986) "Virksomhedsskat, Kilde: ADAM[Ssyv]"
    vtDoedsbo[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "Dødsboskat, Kilde: ADAM[Ssyd]"
    vtHhAM[a_,t]$(aTot[a_] and t.val >= %NettoFin_t1%) "Arbejdsmarkedsbidrag betalt af husholdningerne, Kilde: ADAM[Sya]"
    vtPersRest[a_,t]$(aTot[a_] and t.val >= %NettoFin_t1%) "Andre personlige indkomstskatter, Kilde: ADAM[Syp]"
    vtKapPens[a_,t]$(aTot[a_] and t.val >= %NettoFin_t1%) "Andre personlige indkomstskatter fratrukket andre personlige indkomstskatter resterende, ADAM[Syp]-ADAM[Sypr]"
    vtKapPensArv[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "Kapitalskatter betalt i forbindelse med dødsfald og arv - ikke-datadækket hjælpevariabel."
    vtSelskab[s_,t] "Selskabsskat, Kilde: ADAM[Syc]"
    vtSelskabx[s_,t] "Selskabsskat ekskl. tillægskat for kulbrinteselskabe, Kilde: ADAM[Syc]-ADAM[Syct_e]"
    vtSelskabTotxUdv[t]  "Selskabsskat ekskl. kulbrinteselskaber, Kilde: ADAM[Syc]-ADAM[Syc_e]"
    vtSelskabTillaeg[t]$(t.val > 1990) "Tillægsselskabsskat, kulbrinteselskaber, Kilde: ADAM[Syct_e]"
    vtPAL[t]$(t.val > %cal_start%) "PAL skat, Kilde: ADAM[Sywp]"
    vtMedie[t]$(t.val > 1990) "Medielicens, Kilde: ADAM[Sym]"
    vtHhVaegt[a_,t]$(aTot[a_]) "Vægtafgifter fra husholdningerne, Kilde: ADAM[Syv]"
    vtAfgEU[t] "Produktafgifter til EU, Kilde: ADAM[Sppteu]"

      # Indrekte skatter
    vtIndirekte[t] "Indirekte skatter, Kilde: ADAM[Spt_o]"
    vtEU[t] "Indirekte skatter til EU, Kilde: ADAM[Spteu]"

    # Øvrige offentlige indtægter
    vBidrag[a_,t]$(aTot[a_]) "Bidrag til sociale ordninger, Kilde: ADAM[Tp_h_o]"
    vBidragAK[t]$(t.val >= %BFR_t1%) "A-kassebidrag, Kilde: ADAM[Tpaf]"
    vBidragEL[t]$(t.val >= %BFR_t1%) "Efterlønsbidrag, Kilde: ADAM[Tpef]"
    vBidragFri[t]$(t.val >= %BFR_t1%) "Øvrige frivillige bidrag, Kilde: ADAM[Tpr]"
    vBidragObl[t]$(t.val >= %BFR_t1%) "Obligatoriske bidrag, Kilde: ADAM[Stp_o]"
    vBidragOblTjm[t]$(t.val >= %BFR_t1%) "Obligatoriske sociale bidrag vedr. tjenestemænd, Kilde: ADAM[Stpt]"
    vBidragATP[t]$(t.val >= %BFR_t1%) "Sociale bidrag til ATP, særlig ATP ordning og lønmodtagernes garantifond, Kilde: ADAM[Saqw]"
    vBidragOblRest[t]$(t.val >= %BFR_t1%) "Øvrige obligatoriske bidrag til sociale ordninger, Kilde: ADAM[Sasr]"
    vBidragTjmp[t]$(t.val >= %BFR_t1%) "Bidrag til Tjenestemandspension, Kilde: ADAM[Tpt_o]"

    vOffIndRest[t] "Andre offentlige indtægter."
    vtKirke[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "Kirkeskat, Kilde: ADAM[Trks]"
    vJordrente[t] "Off. indtægter af jord og rettigheder, Kilde: ADAM[Tirn_o]"
    vtKulbrinte[t] "Kulbrinteskat, Kilde: ADAM[Tirk]"
    vJordrenteRest[t] "Off. indtægter af jord og rettigheder ekskl. kulbrinteskat"

    # Indkomstbegreber og fradrag 
    vPersInd[a_,t]$(aTot[a_] and t.val >= %BFR_t1%) "Personlig indkomst, Kilde: ADAM[Ysp]"
    vPersIndx[a_,t]$(aTot[a_] and t.val >= %BFR_t1%) "Personlig indkomst, Kilde: ADAM[Yt]"
    vSkatteplInd[a_,t]$(aTot[a_]) "Skattepligtig indkomst, Kilde: ADAM[Ys]"
    vNetKapIndPos[a_,t]$(aTot[a_]) "Positiv nettokapitalindkomst."
    vNetKapInd[a_,t]$(aTot[a_]) "Nettokapitalindkomst, Kilde: ADAM[Tippps]"
    vKapIndPos[a_,t]$(aTot[a_] and t.val > %NettoFin_t1%) "Imputeret positiv kapitalindkomst."
    vKapIndNeg[a_,t]$(aTot[a_] and t.val > %NettoFin_t1%) "Imputeret negativ kapitalinkomst."
    vPersFradrag[a_,t]$(aTot[a_] and t.val >= %AgeData_t1%) "Imputeret personfradrag."
    vAKFradrag[a_,t]$(aTot[a_] and t.val >= %NettoFin_t1%) "Imputeret fradrag for A-kassebidrag."
    vELFradrag[a_,t]$(aTot[a_] and t.val > 1998) "Imputeret fradrag for efterlønsbidrag."
    vRestFradrag[a_,t]$(aTot[a_]) "Imputerede øvrige ligningsmæssige fradrag (befordringsfradrag m.m.)"
    vBeskFradrag[a_,t]$(aTot[a_] and t.val > 2003) "Imputeret beskæftigelsesfradrag."
    vRealiseretAktieOmv[a_,t]$(aTot[a_]) "Skøn over realiserede gevinst ved salg af aktier."
    vUrealiseretAktieOmv[t]$(tx0[t]) "Skøn over endnu ikke realiserede kapitalgevinster på aktier."
  ;

  $GROUP G_GovRevenues_endo_a
    G_GovRevenues_values_endo_a

    ftBund[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > %AgeData_t1%) "Korrektionsfaktor fra faktisk til implicit skattesats."
    ftKommune[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > %AgeData_t1%) "Korrektionsfaktor fra faktisk til implicit skattesats."
    rTopSkatInd[a_,t]$(t.val > %AgeData_t1%) "Imputeret gennemsnitlig del af indkomsten over topskattegrænsen."
    rMellemSkatInd[a_,t]$(t.val >= %AgeData_t1% and t.val >= 2026) "Imputeret gennemsnitlig del af indkomsten over mellemskattegrænsen."
    rTopTopSkatInd[a_,t]$(t.val >= %AgeData_t1% and t.val >= 2026) "Imputeret gennemsnitlig del af indkomsten over toptopskattegrænsen."
    ftAktie[t]$(t.val > %AgeData_t1%) "parameter til at fange sammensætningseffekt."
    fvtDoedsbo[t]$(t.val > %AgeData_t1%) "parameter til at fange sammensætningseffekt."
    uvPersFradrag_a[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "Aldersfordelt imputeret personfradrag ekskl. regulering"
    mtInd[a_,t]$(t.val > %AgeData_t1% and a[a_]) "Marginal skattesats på lønindkomst."
    jrvKapIndPos_a[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "Alders-specifikt j-led i vKapIndPos."
    jrvKapIndNeg_a[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "Alders-specifikt j-led i vKapIndNeg."
  ;
  $GROUP G_GovRevenues_endo
    G_GovRevenues_endo_a
    G_GovRevenues_prices_endo
    G_GovRevenues_quantities_endo
    G_GovRevenues_values_endo

    rOffFraUdlKap2BNP[t] "Kapitaloverførsler fra udlandet til den offentlige sektor relativt til BNP."
    rOffFraUdlEU2BNP[t] "Residuale overførsler fra EU til den offentlige sektor relativt til BNP."
    rOffFraUdlRest2BNP[t] "Residuale overførsler fra udlandet eksl. EU til den offentlige sektor relativt til BNP."
    rOffFraHh2BNP[t] "Overførsler fra husholdningerne til den offentlige sektor relativt til BNP."
    rOffFraVirk2BNP[t] "Overførsler fra virksomhederne til den offentlige sektor relativt til BNP."
    rOffVirk2BNP[t] "Overskud fra offentlige virksomheder relativt til BNP."
    uRestFradrag[t] "Restfradragssats relativ til sats-reguleringen."
    mtVirk[s_,t]$(sp[s_]) "Branchefordelt marginal indkomstskat hos virksomheder."
    tLukning[t] "Beregningsteknisk skatteskat til lukning af offentlig budgetrestriktion på lang sigt (HBI=0)."
  ;

  $GROUP G_GovRevenues_endo 
    G_GovRevenues_endo$(tx0[t]) # Restrict endo group to tx0[t]

    #  Nutidsværdi af offentlige indtægter - Beregnes i post modellen
    nvOffPrimInd[t]$(tHBI.val <= t.val and t.val <= tEnd.val) "Nutidsværdi af samlede offentlige indtægter."
    nvtDirekte[t]$(tHBI.val <= t.val and t.val <= tEnd.val) "Nutidsværdi af direkte skatter"
    nvtIndirekte[t]$(tHBI.val <= t.val and t.val <= tEnd.val) "Nutidsværdi af inddirekte skatter"
    nvOffIndRest[t]$(tHBI.val <= t.val and t.val <= tEnd.val) "Nutidsværdi af andre offentlige indtægter"

    mtHhAktAfk[portf,t]$(fin_akt[portf] and d1vHhAkt[portf,t]) "Marginalskat på husholdningers kapitalindkomster."
    mtHhPasAfk[portf,t]$(d1vHhPas[portf,t]) "Marginalskat på husholdningers renteudgifter."
  ;

  $GROUP G_GovRevenues_prices
    G_GovRevenues_prices_endo
  ; 
  $GROUP G_GovRevenues_quantities
    G_GovRevenues_quantities_endo
  ; 
  $GROUP G_GovRevenues_values
    G_GovRevenues_values_endo

    jvOffPrimInd[t] "J-led."
    jvtKilde[t] "J-led afspejler datamæssige uoverensstemmelser - skal være 0 i fremskrivning."
    jvtDirekte[t] "J-led afspejler datamæssige uoverensstemmelser - skal være 0 i fremskrivning."
    jvtSelskabx[s_,t] "J-led til at ramme branchefordelt selskabsskat (kun relevant for udv)"
    vOffFraUdlKap[t] "Kapitaloverførsler fra udlandet, Kilde: ADAM[tK_e_o]"
    vOffFraUdlEU[t] "Residuale overførsler fra EU, Kilde: ADAM[Tr_eu_o]"
    vOffFraUdlRest[t] "Residuale overførsler fra udlandet ekskl. EU, Kilde: ADAM[Tr_er_o]"
    vOffFraHh[t] "Residuale overførsler fra den private sektor, Kilde: ADAM[Trr_hc_o]"
    vOffFraVirk[t] "Kapitaloverførsler fra den private sektor, Kilde: ADAM[tK_hc_o]"
    vOffVirk[t] "Overskud af offentlig virksomhed, Kilde: ADAM[Tiuo_z_o]"
    vRestFradragSats[t] "Eksogen del af andre fradrag kalibreret til at ramme makrodata."
    vtJordrenteNordsoe[t] "Off. indtægter af jord og rettigheder, jordrente fra Nordsøen (produktionsafgift), Afgiften blev ophævet i 2014, (indgår i vtJordrenteRest) Kilde: ADAM[Tire_o]"
    vtJordrenteRoer[t] "Olierørledningsafgift, (indgår i vtJordrenteRest) Kilde: ADAM[Tiro]"
  ;

  $GROUP G_GovRevenues_exogenous_forecast
    rvtAktie2BVT[t] "Provenue fra aktieskat som andel af BNP"
    ftSelskab[t] "Korrektionsfaktor fra faktisk til implicit skattesats."
  ;
  $GROUP G_GovRevenues_forecast_as_zero
    jvOffPrimInd
    jvtKilde
    jvtDirekte

    jfvSkatteplInd[t] "Multiplikativt J-led."
    jvtPal[t] "J-led"
  ;
  $GROUP G_GovRevenues_ARIMA_forecast
    # Endogene i stødforløb:
    rOffFraUdlKap2BNP
    rOffFraUdlEU2BNP
    rOffFraUdlRest2BNP
    rOffFraHh2BNP
    rOffFraVirk2BNP
    rOffVirk2BNP
    rvtAfgEU2vtAfg[t] "Andel af produktskatter som går til EU."
    rtKirke[t] "Andel af skatteydere som betaler kirkeskat, ADAM[bks]"
  ;
  $GROUP G_GovRevenues_newdata_forecast
    uRestFradrag[t]
    uvPersFradrag_a[a_,t]$(a15t100[a_])

    tBund[t] "Bundskattesats, Kilde: ADAM[tsysp1]"
    tTop[t] "Topskattesats, Kilde: ADAM[tsysp2]+ADAM[tsysp3]"
    tMellem[t] "Mellemskattesats, Kilde: ADAM[tsyt1]"
    tTopTop[t] "Toptopskattesats, Kilde: ADAM[tsyt3]"
    tKommune[t] "Gennemsnitlig kommunal skattesats, Kilde: ADAM[tsys1]+ADAM[tsys2]"
    tAMbidrag[t] "Procentsats for arbejdsmarkedsbidrag."
    tKapPens[t] "Skatterate hvormed kapitalpensioner bliver beskattet ved udbetaling, Kilde: ADAM[tsyp]"
    tSelskab[t] "Selskabsskattesats, Kilde: ADAM[tsyc]"
    tPAL[t] "PAL-skattesats, Kilde: ADAM[tsywp]"
    tKirke[t] "Kirkeskattesats, Kilde: ADAM[tks]"
    tEjd[t] "Implicit skattesats."
    tPersRestxKapPens[t] "Implicit skattesats."
    tSelskabTillaeg[t] "Implicit skattesats."
    tVirksomhed[t] "Implicit skattesats."
    tDoedsbo[t] "Implicit skattesats."
    tAktie[t] "Implicit gennemsnitlig skat på aktieafkast."
    tKulbrinte[t] "Implicit skattesats."
    tJordrenteRest[t] "Implicit skattesats."
    tBeskFradrag[t] "Imputeret gennemsnitlig beskæftigelsesfradrag ift. lønindkomst."
    tArv[t] "Arveafgift (implicit, gennemsnit)"

    uPersIndRest_a[a_,t] "Aldersfordelt restled til personindkomst."
    uPersIndRest_t[t] "Restled til personindkomst, uafhængigt af alder."

    rNet2KapIndPos[a_,t] "Positiv nettokapitalindkomst ift. positiv kapitalindkomst."

    rAKFradrag2Bidrag[t] "Fradrag for A-kassebidrag som andel af A-kassebidrag."
    rELFradrag2Bidrag[t] "Fradrag for efterlønsbidrag som andel af efterlønsbidrag."

    uBidragOblTjm[t] "Sats-parameter for obligatoriske sociale bidrag til tjenestemandspension pr. person i arbejdsstyrken."
    uBidragATP[t] "Sats-parameter for sociale bidrag til ATP, særlig ATP ordning og lønmodtagernes garantifond pr. person i arbejdsstyrken."
    uBidragOblRest[t] "Sats-parameter for øvrige bidrag til sociale ordninger pr. person i arbejdsstyrken."
    uBidragEL[t] "Sats-parameter for efterlønsbidrag pr. person i arbejdsstyrken."
    uBidragFri[t] "Sats-parameter for øvrige frivillige bidrag pr. person i arbejdsstyrken."
    uBidragAK[t] "Sats-parameter for A-kassebidrag."
    uBidragTjmp[t] "Sats-parameter for bidrag til Tjenestemandspension."
    utMedie[t] "Sats-parameter for medielicens pr. person."
    utHhVaegt[t] "Sats-parameter for vægtafgift pr. bil."

    uvPersFradrag_t[t] "Ikke-aldersfordelt imputeret personfradrag ekskl. regulering"
    rTopSkatInd_t[t] "Tids-afhængigt led i rTopSkatInd."
    rMellemSkatInd_t[t] "Tids-afhængigt led i rTopSkatInd."
    rTopTopSkatInd_t[t] "Tids-afhængigt led i rTopSkatInd."
    rTopSkatInd_a[a,t] "Alders-specifikt led i rTopSkatInd."
    rMellemSkatInd_a[a,t] "Alders-specifikt led i rMellemSkatInd."
    rTopTopSkatInd_a[a,t] "Alders-specifikt led i rTopTopSkatInd."

    rRealiseringAktieOmv[t] "Andel af omvurderinger på aktier som realiseres hvert år."

    mtIndRest[a,t] "Residual-led i marginal skattesats på lønindkomst."
    mtHhAktAfkRest[portf,t] "Forskel mellem gennemsnitlig og marginal kapital beskatningskat."
    rtTopRenter[t] "Andel af renteindtægter, der betales topskat af."
    rtTopTopRenter[t] "Andel af renteindtægter, der betales topskat af."
    rtMellemRenter[t] "Andel af renteindtægter, der betales topskat af."
    mrNet2KapIndPos[t] "Marginal stigning i positiv nettokapitalindkomst ved stigning i kapitalindkomst."
  ;
  $GROUP G_GovRevenues_fixed_forecast
    ftAMBidrag[t] "Korrektionsfaktor fra faktisk til implicit skattesats."
    ftKapPens[t] "Korrektionsfaktor fra faktisk til implicit skattesats."
    ftKirke[t] "Korrektionsfaktor fra faktisk til implicit skattesats."
 
    ftBund_t[t] "Tids-afhængigt led i ftBund."
    ftBund_a[a,t] "Alders-specifikt led i ftBund."
    ftKommune_t[t] "Tids-afhængigt led i ftKommune."
    ftKommune_a[a,t] "Alders-specifikt led i ftKommune."
    jrvKapIndPos_a[a_,t]$(a[a_])
    jrvKapIndPos_t[t] "Tids-afhængigt j-led i vKapIndPos."
    jrvKapIndNeg_a[a,t]$(a[a_])
    jrvKapIndNeg_t[t] "Tids-afhængigt j-led i fvKapIndNeg."
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_GovRevenues_static$(tx0[t])

# ======================================================================================================================
# Primære offentlige indtægter
# ======================================================================================================================
    E_vOffPrimInd[t].. vOffPrimInd[t] =E= vtDirekte[t] + vtIndirekte[t] + vOffIndRest[t];

    # Direkte skatter
    # Kilde: Generelt om skattesystemet
    # http://www.skm.dk/skattetal/beregning/skatteberegning/skatteberegning-hovedtraekkene-i-personbeskatningen-2017
    E_vtDirekte[t]..
      vtDirekte[t] =E= vtKilde[t] + vtHhAM[aTot,t] + vtSelskab[sTot,t] + vtPAL[t]
                     + vtHhVaegt[aTot,t] + vtMedie[t] + vtPersRest[aTot,t] + jvtDirekte[t];

# ----------------------------------------------------------------------------------------------------------------------
#   Kildeskatter
# ----------------------------------------------------------------------------------------------------------------------
    E_vtKilde[t]..
      vtKilde[t] =E= vtKommune[aTot,t] + vtBund[aTot,t] + vtAktie[aTot,t] + vtTop[aTot,t] + vtMellem[aTot,t]
                   + vtTopTop[aTot,t] + vtEjd[aTot,t] + vtVirksomhed[aTot,t] + vtDoedsbo[aTot,t] + jvtKilde[t];

    E_vtPersonlige[t]..
      vtPersonlige[t] =E= vtKommune[aTot,t] + vtBund[aTot,t] + vtTop[aTot,t] + vtMellem[aTot,t] + vtTopTop[aTot,t];

    E_vtKommune_aTot[t]$(t.val > %AgeData_t1%)..
      vtKommune[aTot,t] =E= tKommune[t] * ftKommune[aTot,t] * (vSkatteplInd[aTot,t] - vPersFradrag[aTot,t]);

    E_vtBund_aTot[t]$(t.val > %AgeData_t1%)..
      vtBund[aTot,t] =E= tBund[t] * ftBund[aTot,t] * (vPersInd[aTot,t] + vNetKapIndPos[aTot,t] - vPersFradrag[aTot,t]);

    # Sammensætningseffekt skyldes forskellige dødssandsynligheder og formuer, da kun overlevende betaler aktieskat
    E_vtAktie_aTot[t]$(t.val > %NettoFin_t1%)..
      vtAktie[aTot,t] =E= tAktie[t] * (vRealiseretAktieOmv[aTot,t]
                                     + rRente['IndlAktier',t] * vHhAkt['IndlAktier',aTot,t-1]/fv
                                     + rRente['UdlAktier',t] * vHhAkt['UdlAktier',aTot,t-1]/fv
                                     ) * rOverlev[aTot,t-1] * ftAktie[t];
    E_vRealiseretAktieOmv_aTot[t]..
      vRealiseretAktieOmv[aTot,t] =E= rRealiseringAktieOmv[t] * vUrealiseretAktieOmv[t];
    E_vUrealiseretAktieOmv[t]..
      vUrealiseretAktieOmv[t] =E= vUrealiseretAktieOmv[t-1]/fv
                                - vRealiseretAktieOmv[aTot,t]
                                + rOmv['IndlAktier',t] * vHhAkt['IndlAktier',aTot,t-1]/fv
                                + rOmv['UdlAktier',t] * vHhAkt['UdlAktier',aTot,t-1]/fv;

    E_vtTop_aTot[t]$(t.val > %AgeData_t1%)..
      vtTop[aTot,t] =E= tTop[t] * rTopSkatInd[aTot,t] * (vPersInd[aTot,t] + vNetKapIndPos[aTot,t]);

    #  Når der er 2026-data og top-top-skatten er indført skal ovenstående ligning skiftes ud med nedenstående
#    E_vtTop_aTot[t]$(t.val > %AgeData_t1%)..
#      vtTop[aTot,t] =E= tTop[t] * rTopSkatInd[aTot,t] * (vPersIndx[aTot,t] + vNetKapIndPos[aTot,t]);

    E_vtMellem_aTot[t]$(t.val > %AgeData_t1%)..
      vtMellem[aTot,t] =E= tMellem[t] * rMellemSkatInd[aTot,t] * (vPersIndx[aTot,t] + vNetKapIndPos[aTot,t]);

    E_vtTopTop_aTot[t]$(t.val > %AgeData_t1%)..
      vtTopTop[aTot,t] =E= tTopTop[t] * rTopTopSkatInd[aTot,t] * (vPersIndx[aTot,t] + vNetKapIndPos[aTot,t]);

    E_vtEjd_aTot[t].. vtEjd[aTot,t] =E= tEjd[t] * vBolig[aTot,t-1]/fv;    

    E_vtVirksomhed_tot[t]$(t.val > 1986).. vtVirksomhed[aTot,t] =E= tVirksomhed[t] * vEBT[sTot,t];

    # Sammensætningseffekten er væsentlig, da den aggregerede overlevelses-sandsynlighed er langt fra den gennemsnitlige overlevelses-sandsynlighed vægtet efter formue
    # Udover dette fanger fvtDoedsbo også korrelation mellem overlevelse og formue indenfor en kohorte (rArvKorrektion)
    E_vtDoedsbo_tot[t]$(t.val > %AgeData_t1%)..
      vtDoedsbo[aTot,t] =E= tDoedsbo[t] * fvtDoedsbo[t] * (1-rOverlev[aTot,t-1])
                          * (vRealiseretAktieOmv[aTot,t] 
                              + rRente['IndlAktier',t] * vHhAkt['IndlAktier',aTot,t-1]/fv 
                              + rRente['UdlAktier',t]  * vHhAkt['UdlAktier',aTot,t-1]/fv  
                              + rNet2KapIndPos[aTot,t] * rRente['Obl',t]  * vHhAkt['Obl',aTot,t-1]/fv
                              + rNet2KapIndPos[aTot,t] * rRente['Bank',t] * vHhAkt['Bank',aTot,t-1]/fv
                            );

# ----------------------------------------------------------------------------------------------------------------------
#   Andre direkte skatter
# ----------------------------------------------------------------------------------------------------------------------
    E_vtHhAM_tot[t]$(t.val >= %NettoFin_t1%)..
      vtHhAM[aTot,t] =E= tAMbidrag[t] * ftAMBidrag[t] * (vWHh[aTot,t] - vBidragTjmp[t]);

    E_vtSelskab_sTot[t].. vtSelskab[sTot,t] =E= vtSelskabx[sTot,t] + vtSelskabTillaeg[t];
    E_vtSelskabx_sTot[t].. vtSelskabx[sTot,t] =E= tSelskab[t] * ftSelskab[t] * vEBT[sTot,t];
    E_vtSelskabTillaeg[t]$(t.val > 1990)..
      vtSelskabTillaeg[t] =E= (qY['udv',t] - qGrus[t]) / qY['udv',t] * vEBT['udv',t] * tSelskabTillaeg[t];
    E_vtSelskab[sp,t]..
      vtSelskab[sp,t] =E= vtSelskabx[sp,t] + udv[sp] * vtSelskabTillaeg[t];
    E_vtSelskabx[sp,t]..
      vtSelskabx[sp,t] =E= tSelskab[t] * ftSelskab[t] * vEBT[sp,t] + jvtSelskabx[sp,t];
    E_vtSelskabTotxUdv[t].. vtSelskabTotxUdv[t] =E= vtSelskab[sTot,t] - vtSelskab['udv',t];
    
    # Udlændinge betaler også PAL-skat, MEN vtPAl trækkes fra danske husholdninger - hermed betaler de i 1. omgang udlændinges PAL-skat
    # Udlændinges bidrag til PAL-skat kommer via vHhTilUdl
    E_vtPAL[t]$(t.val > %cal_start%)..
      vtPAL[t] =E= tPAL[t] * (rRente['pensTot',t] + rOmv['pensTot',t] - rHhAktOmk['pensTot',t]) * vPensionAkt['Tot',t-1]/fv + jvtPal[t];

    E_vtHhVaegt_tot[t].. vtHhVaegt[aTot,t] =E= utHhVaegt[t] * vSatsIndeks[t] * qBiler[t-1]/fq;

    E_vtMedie_tot[t]$(t.val > 1990).. vtMedie[t] =E= utMedie[t] * vSatsIndeks[t] * nPop['a18t100',t];  

    E_vtPersRest_tot[t]$(t.val >= %NettoFin_t1%)..
      vtPersRest[aTot,t] =E= vtKapPens[aTot,t] + tPersRestxKapPens[t] * vPersInd[aTot,t];
    E_vtKapPens_tot[t]$(t.val >= %NettoFin_t1%)..
      vtKapPens[aTot,t] =E= tKapPens[t] * ftKapPens[t] * vHhPensUdb['Kap',aTot,t];

    E_vtKapPensArv_tot[t]$(t.val > %AgeData_t1%)..
      vtKapPensArv[aTot,t] =E= tKapPens[t] * ftKapPens[t] * vPensArv['Kap',aTot,t];

# ----------------------------------------------------------------------------------------------------------------------
#   Indirekte skatter - jf. taxes.gms
# ----------------------------------------------------------------------------------------------------------------------
    E_vtIndirekte[t].. vtIndirekte[t] =E= vtMoms[dTot,sTot,t]
                                                 + vtAfg[dTot,sTot,t]
                                                 + vtReg[dTot,sTot,t]
                                                 + vtY[sTot,t] 
                                                 + vtTold[dTot,sTot,t] - vtEU[t];

    E_vtEU[t].. vtEU[t] =E= vtTold[dTot,sTot,t] + vtAfgEU[t];
    E_vtAfgEU[t].. vtAfgEU[t] =E= rvtAfgEU2vtAfg[t] * vtAfg[dTot,sTot,t];

# ----------------------------------------------------------------------------------------------------------------------
#   Øvrige offentlige indtægter
# ----------------------------------------------------------------------------------------------------------------------
    E_vOffIndRest[t]..
      vOffIndRest[t] =E= vtArv[aTot,t] + vOffAfskr[kTot,t] + vBidrag[aTot,t]
                       + vOffFraUdlKap[t] + vOffFraUdlEU[t] + vOffFraUdlRest[t] + vOffFraHh[t] + vOffFraVirk[t]
                       + vtKirke[aTot,t] + vJordrente[t] + vOffVirk[t] + jvOffPrimInd[t];

    # Sociale bidrag
    E_vBidrag_tot[t]..
      vBidrag[aTot,t] =E= vBidragAK[t] + vBidragTjmp[t] + vBidragEL[t] + vBidragFri[t] + vBidragObl[t];

    E_vBidragAK[t]$(t.val >= %BFR_t1%)..      vBidragAK[t]      =E= uBidragAK[t]      * vSatsIndeks[t] * nBruttoArbsty[t];
    E_vBidragTjmp[t]$(t.val >= %BFR_t1%)..    vBidragTjmp[t]    =E= uBidragTjmp[t]    * vSatsIndeks[t] * nBruttoArbsty[t];
    E_vBidragEL[t]$(t.val >= %BFR_t1%)..      vBidragEL[t]      =E= uBidragEL[t]      * vSatsIndeks[t] * nBruttoArbsty[t];
    E_vBidragFri[t]$(t.val >= %BFR_t1%)..     vBidragFri[t]     =E= uBidragFri[t]     * vSatsIndeks[t] * nBruttoArbsty[t];
    E_vBidragOblTjm[t]$(t.val >= %BFR_t1%)..  vBidragOblTjm[t]  =E= uBidragOblTjm[t]  * vSatsIndeks[t] * nBruttoArbsty[t];
    E_vBidragATP[t]$(t.val >= %BFR_t1%)..     vBidragATP[t]     =E= uBidragATP[t]     * vSatsIndeks[t] * nBruttoArbsty[t];
    E_vBidragOblRest[t]$(t.val >= %BFR_t1%).. vBidragOblRest[t] =E= uBidragOblRest[t] * vSatsIndeks[t] * nBruttoArbsty[t];

    E_vBidragObl[t]$(t.val >= %BFR_t1%).. vBidragObl[t] =E= vBidragOblTjm[t] + vBidragATP[t] + vBidragOblRest[t];

    # Overførsler
    E_rOffFraUdlKap2BNP[t].. vOffFraUdlKap[t] =E= rOffFraUdlKap2BNP[t] * vBNP[t];
    E_rOffFraUdlEU2BNP[t].. vOffFraUdlEU[t] =E= rOffFraUdlEU2BNP[t] * vBNP[t];
    E_rOffFraUdlRest2BNP[t].. vOffFraUdlRest[t] =E= rOffFraUdlRest2BNP[t] * vBNP[t];
    E_rOffFraHh2BNP[t].. vOffFraHh[t] =E= rOffFraHh2BNP[t] * vBNP[t];
    E_rOffFraVirk2BNP[t].. vOffFraVirk[t] =E= rOffFraVirk2BNP[t] * vBNP[t];

    E_vtKirke_aTot[t]$(t.val > %AgeData_t1%)..
      vtKirke[aTot,t] =E= tKirke[t] * ftKirke[t] * rtKirke[t] * (vSkatteplInd[aTot,t] - vPersFradrag[aTot,t]);

    # Jordrente
    E_vJordrente[t].. vJordrente[t] =E= vtKulbrinte[t] + vJordrenteRest[t];

    E_vtKulbrinte[t].. vtKulbrinte[t] =E= tKulbrinte[t] * ((qY['udv',t] - qGrus[t]) / qY['udv',t]) * vBVT['udv',t];
    E_vJordrenteRest[t].. vJordrenteRest[t] =E= tJordrenteRest[t] * vBNP[t];

    # Overskud af offentlig virksomhed
    E_rOffVirk2BNP[t].. vOffVirk[t] =E= rOffVirk2BNP[t] * vBNP[t];

# ----------------------------------------------------------------------------------------------------------------------
#   Indkomstbegreber og fradrag
# ----------------------------------------------------------------------------------------------------------------------
    E_vPersIndx_tot[t]$(t.val >= %BFR_t1%)..
      vPersIndx[aTot,t] =E= vWHh[aTot,t]
                         + vOvfSkatPl[aTot,t]
                         + vHhPensUdb['PensX',aTot,t]
                         - vHhPensIndb['PensX',aTot,t]
                         - vHhPensIndb['Kap',aTot,t]
                         + vPersIndRest[aTot,t];

    E_vPersInd_tot[t]$(t.val >= %BFR_t1%)..
      vPersInd[aTot,t] =E= vPersIndx[aTot,t] - vtHhAM[aTot,t];

    E_vSkatteplInd_tot[t]..
      vSkatteplInd[aTot,t] =E= ( vPersInd[aTot,t]
                               + vNetKapInd[aTot,t] 
                               - vBeskFradrag[aTot,t] 
                               - vAKFradrag[aTot,t] 
                               - vELFradrag[aTot,t] 
                               - vRestFradrag[aTot,t]
                             ) * (1+jfvSkatteplInd[t]);

    E_vKapIndPos_tot[t]$(t.val > %NettoFin_t1%)..
      vKapIndPos[aTot,t] =E= vHhAkt['Obl',aTot,t-1]/fv * rOverlev[aTot,t] 
                             * (rRente['Obl',t] + jrHhAktRenter['Obl',t] + jrvKapIndPos_a[aTot,t] + jrvKapIndPos_t[t])
                           + vHhAkt['Bank',aTot,t-1]/fv * rOverlev[aTot,t]
                              * (rRente['Bank',t] + jrHhAktRenter['Bank',t] + jrvKapIndPos_a[aTot,t] + jrvKapIndPos_t[t]);

    E_vKapIndNeg_tot[t]$(t.val > %NettoFin_t1%)..
      vKapIndNeg[aTot,t] =E= sum(portf, vHhPas[portf,aTot,t-1]/fv * rOverlev[aTot,t] 
                                        * (rRente[portf,t] + jrHhPasRenter[portf,t]
                                           + jrvKapIndNeg_a[aTot,t] + jrvKapIndNeg_t[t]));

    E_vNetKapIndPos_tot[t]..
      vNetKapIndPos[aTot,t] =E= rNet2KapIndPos[aTot,t] * vNetKapInd[aTot,t];

    E_vNetKapInd_tot[t].. vNetKapInd[aTot,t] =E= vKapIndPos[aTot,t] - vKapIndNeg[aTot,t];

    # Fradrag
    E_vPersFradrag_tot[t]$(t.val > %AgeData_t1%).. vPersFradrag[aTot,t] =E= vSatsIndeks[t] * (uvPersFradrag_a[aTot,t] + uvPersFradrag_t[t]);

    E_vAKFradrag_tot[t]$(t.val >= %NettoFin_t1%).. vAKFradrag[aTot,t]   =E= rAKFradrag2Bidrag[t] * vBidragAK[t];
    E_vELFradrag_tot[t]$(t.val > 1998).. vELFradrag[aTot,t]   =E= rELFradrag2Bidrag[t] * vBidragEL[t];
    E_vRestFradrag_tot[t].. vRestFradrag[aTot,t] =E= vRestFradragSats[t] * nLHh[aTot,t];
    E_vBeskFradrag_tot[t]$(t.val > 2003).. vBeskFradrag[aTot,t] =E= tBeskFradrag[t] * vWHh[aTot,t];

    E_uRestFradrag[t].. vRestFradragSats[t] =E= uRestFradrag[t] * vSatsIndeks[t];

# ----------------------------------------------------------------------------------------------------------------------
#   Marginalskatter
# ----------------------------------------------------------------------------------------------------------------------    
    E_mtVirk[sp,t].. mtVirk[sp,t] =E= tSelskab[t] + udv[sp] * tSelskabTillaeg[t];

    E_mtHhAktAfk[portf,t]$((Bank[portf] or Obl[portf]) and t.val > %NettoFin_t1%).. 
      mtHhAktAfk[portf,t] =E= tKommune[t] + rtKirke[t] * tKirke[t]
                            + mrNet2KapIndPos[t] * tBund[t]
                            + rtMellemRenter[t] * tMellem[t]
                            + rtTopRenter[t] * tTop[t]
                            + rtTopTopRenter[t] * tTopTop[t]
                            + mtHhAktAfkRest[portf,t];

    E_mtHhAktAfk_aktier[portf,t]$((IndlAktier[portf] or UdlAktier[portf]) and t.val > %NettoFin_t1%)..
      mtHhAktAfk[portf,t] =E= tAktie[t] + mtHhAktAfkRest[portf,t];

    E_mtHhPasAfk[portf,t]$((Bank[portf] or RealKred[portf]) and t.val > %NettoFin_t1%).. 
      mtHhPasAfk[portf,t] =E= tKommune[t] + rtKirke[t] * tKirke[t];

# ----------------------------------------------------------------------------------------------------------------------
#   Beregningsteknisk skat til lukning af offentlig budgetrestriktion
# ----------------------------------------------------------------------------------------------------------------------    
    E_tLukning[t]$(t.val > %AgeData_t1%)..
      vtLukning[aTot,t] =E= tLukning[t] * (vtHhx[aTot,t] - vtLukning[aTot,t]);
  $ENDBLOCK

  $BLOCK B_GovRevenues_forwardlooking
# ----------------------------------------------------------------------------------------------------------------------
#   Ligninger til beregning af nutidsværdien af offentlige indtægter 
# ----------------------------------------------------------------------------------------------------------------------    
    E_nvOffPrimInd[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOffPrimInd[t] =E= vOffPrimInd[t] + nvOffPrimInd[t+1]*fv / (1+mrOffRente[t]);
    E_nvOffPrimInd_tEnd[t]$(tEnd[t])..
      nvOffPrimInd[t] =E= vOffPrimInd[t] / ((1+mrOffRente[t]) / fv - 1);

    E_nvtDirekte[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvtDirekte[t] =E= vtDirekte[t] + nvtDirekte[t+1]*fv / (1+mrOffRente[t]);
    E_nvtDirekte_tEnd[t]$(tEnd[t])..
      nvtDirekte[t] =E= vtDirekte[t] / ((1+mrOffRente[t]) / fv - 1);

    E_nvtIndirekte[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvtIndirekte[t] =E= vtIndirekte[t] + nvtIndirekte[t+1]*fv / (1+mrOffRente[t]);
    E_nvtIndirekte_tEnd[t]$(tEnd[t])..
      nvtIndirekte[t] =E= vtIndirekte[t] / ((1+mrOffRente[t]) / fv - 1);
    
    E_nvOffIndRest[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOffIndRest[t] =E= vOffIndRest[t] + nvOffIndRest[t+1]*fv / (1+mrOffRente[t]);
    E_nvOffIndRest_tEnd[t]$(tEnd[t])..
      nvOffIndRest[t] =E= vOffIndRest[t] / ((1+mrOffRente[t]) / fv - 1);
  $ENDBLOCK

  $BLOCK B_GovRevenues_a$(tx0[t])
# ----------------------------------------------------------------------------------------------------------------------
#   Kildeskatter
# ----------------------------------------------------------------------------------------------------------------------
    E_vtKommune[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vtKommune[a,t] =E= tKommune[t] * ftKommune[a,t] * (vSkatteplInd[a,t] - vPersFradrag[a,t]);
    E_ftKommune[a,t]$(a15t100[a] and t.val > %AgeData_t1%).. ftKommune[a,t] =E= ftKommune_a[a,t] + ftKommune_t[t];
    E_ftKommune_tot[t]$(t.val > %AgeData_t1%).. vtKommune[aTot,t] =E= sum(a, vtKommune[a,t] * nPop[a,t]);

    E_vtBund[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vtBund[a,t] =E= tBund[t] * ftBund[a,t] * (vPersInd[a,t] + vNetKapIndPos[a,t] - vPersFradrag[a,t]);
    E_ftBund[a,t]$(a15t100[a] and t.val > %AgeData_t1%).. ftBund[a,t] =E= ftBund_a[a,t] + ftBund_t[t];
    E_ftBund_aTot[t]$(t.val > %AgeData_t1%).. vtBund[aTot,t] =E= sum(a, vtBund[a,t] * nPop[a,t]);

    E_vtAktie[a,t]$(a0t100[a] and t.val > %AgeData_t1%)..
      vtAktie[a,t] =E= tAktie[t] * (  vRealiseretAktieOmv[a,t]
                                    + rRente['IndlAktier',t] * vHhAkt['IndlAktier',a-1,t-1]/fv
                                    + rRente['UdlAktier',t] * vHhAkt['UdlAktier',a-1,t-1]/fv) * fMigration[a,t];
    E_ftAktie[t]$(t.val > %AgeData_t1%).. vtAktie[aTot,t] =E= sum(a, vtAktie[a,t] * nPop[a,t]); # Bemærk at afdøde ikke betaler aktieskat

    # Pr. person i perioden før
    E_vRealiseretAktieOmv[a,t]$(t.val > %AgeData_t1%)..
      vRealiseretAktieOmv[a,t] =E= vRealiseretAktieOmv[atot,t]
                                 * (vHhAkt['IndlAktier',a-1,t-1] + vHhAkt['UdlAktier',a-1,t-1])
                                 / (vHhAkt['IndlAktier',aTot,t-1] + vHhAkt['UdlAktier',aTot,t-1]);
  
    E_vtTop[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vtTop[a,t] =E= tTop[t] * (vPersInd[a,t] + vNetKapIndPos[a,t]) * rTopSkatInd[a,t];
    #  Når der er 2026-data og top-top-skatten er indført skal ovenstående ligning skiftes ud med nedenstående
    #  E_vtTop[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
    #    vtTop[a,t] =E= tTop[t] * (vPersIndx[a,t] + vNetKapIndPos[a,t]) * rTopSkatInd[a,t];
    E_rTopSkatInd_aTot[t]$(t.val > %AgeData_t1%).. vtTop[aTot,t] =E= sum(a, vtTop[a,t] * nPop[a,t]);
    E_rTopSkatInd[a,t]$(t.val > %AgeData_t1% and a15t100[a])..
      rTopSkatInd[a,t] =E= rTopSkatInd_a[a,t] + rTopSkatInd_t[t];

    E_vtMellem[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vtMellem[a,t] =E= tMellem[t] * (vPersInd[a,t] + vNetKapIndPos[a,t]) * rMellemSkatInd[a,t];
    E_rMellemSkatInd_aTot[t]$(t.val > %AgeData_t1% and t.val >= 2026).. vtMellem[aTot,t] =E= sum(a, vtMellem[a,t] * nPop[a,t]);
    E_rMellemSkatInd[a,t]$(t.val > %AgeData_t1% and a15t100[a] and t.val >= 2026)..
      rMellemSkatInd[a,t] =E= rMellemSkatInd_a[a,t] # Vi benytter aldersfordelingen for top-skatten indtil vi har data for aldersfordelt mellemskat
                            + rMellemSkatInd_t[t];

    E_vtTopTop[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vtTopTop[a,t] =E= tTopTop[t] * (vPersInd[a,t] + vNetKapIndPos[a,t]) * rTopTopSkatInd[a,t];
    E_rTopTopSkatInd_aTot[t]$(t.val > %AgeData_t1% and t.val >= 2026).. vtTopTop[aTot,t] =E= sum(a, vtTopTop[a,t] * nPop[a,t]);
    E_rTopTopSkatInd[a,t]$(t.val > %AgeData_t1% and a15t100[a])..
      rTopTopSkatInd[a,t] =E= rTopTopSkatInd_a[a,t] # Vi benytter aldersfordelingen for top-skatten indtil vi har data for aldersfordelt toptopskat
                            + rTopTopSkatInd_t[t];

    E_vtEjd[a,t]$(a.val >= 18 and t.val > %AgeData_t1%)..
      vtEjd[a,t] =E= tEjd[t] * vBolig[a-1,t-1]/fv * fMigration[a,t];

    E_vtVirksomhed[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vtVirksomhed[a,t] =E= tVirksomhed[t] * vEBT[sTot,t] * vWHh[a,t] / vWHh[aTot,t];

    # Dødsboskat er aktieafkastskat og skat på positiv nettokapitalindkomst
    E_vtDoedsbo[a,t]$(t.val > %AgeData_t1%)..
      vtDoedsbo[a,t] =E= tDoedsbo[t] 
                         * (vRealiseretAktieOmv[a,t] 
                            + rRente['IndlAktier',t] * vHhAkt['IndlAktier',a-1,t-1]/fv 
                            + rRente['UdlAktier',t]  * vHhAkt['UdlAktier',a-1,t-1]/fv 
                            + rNet2KapIndPos[a,t] * rRente['Obl',t]  * vHhAkt['Obl',a-1,t-1]/fv
                            + rNet2KapIndPos[a,t] * rRente['Bank',t] * vHhAkt['Bank',a-1,t-1]/fv) * rArvKorrektion[a];
    E_fvtDoedsbo[t]$(t.val > %AgeData_t1%)..
      vtDoedsbo[aTot,t] =E= sum(a, vtDoedsbo[a,t] * (1-rOverlev[a-1,t-1]) * nPop[a-1,t-1]);

# ----------------------------------------------------------------------------------------------------------------------
#   Andre direkte skatter
# ----------------------------------------------------------------------------------------------------------------------
    # Andre direkte skatter   
    E_vtHhAM[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vtHhAM[a,t] =E= tAMbidrag[t] * ftAMBidrag[t] * vWHh[a,t] * (vWHh[aTot,t] - vBidragTjmp[t]) / vWHh[aTot,t];

    E_vtHhVaegt[a,t]$(a18t100[a] and t.val > %AgeData_t1%)..
      vtHhVaegt[a,t] =E= utHhVaegt[t] * vSatsIndeks[t] * qBiler[t-1]/fq * qCx[a,t] / qC['Cx',t];

    E_vtPersRest[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vtPersRest[a,t] =E= vtKapPens[a,t] + tPersRestxKapPens[t] * vPersInd[a,t];

    E_vtKapPens[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vtKapPens[a,t] =E= tKapPens[t] * ftKapPens[t] * vHhPensUdb['Kap',a,t];

    E_vtKapPensArv[a,t]$(a.val >= 15 and t.val > %AgeData_t1%)..
      vtKapPensArv[a,t] =E= tKapPens[t] * ftKapPens[t] * vPensArv['Kap',a,t];

# ----------------------------------------------------------------------------------------------------------------------
#   Øvrige offentlige indtægter
# ----------------------------------------------------------------------------------------------------------------------
    E_vBidrag[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vBidrag[a,t] =E= vWHh[a,t] / vWHh[aTot,t] * vBidrag[aTot,t]; 

    # Kirkeskat
    E_vtKirke[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vtKirke[a,t] =E= tKirke[t] * ftKirke[t] * rtKirke[t] * (vSkatteplInd[a,t] - vPersFradrag[a,t]);

    E_vtArv_aTot[t]$(t.val > %AgeData_t1%).. vtArv[aTot,t] =E= tArv[t] * vArv[aTot,t];
    E_vtArv[a,t]$(t.val > %AgeData_t1%).. vtArv[a,t] =E= tArv[t] * vArv[a,t];

# ----------------------------------------------------------------------------------------------------------------------
#   Indkomstbegreber og fradrag
# ----------------------------------------------------------------------------------------------------------------------
    E_vPersIndx[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vPersIndx[a,t] =E=   vWHh[a,t]
                        + vOvfSkatPl[a,t]
                        + vHhPensUdb['PensX',a,t]
                        # Nedenstående led er en forsimpling - her betales skat af livsforsikring - i virkeligheden er forsikringselementet af pension ikke fradragsberettiget - vi bør ændre modelleringen og have data særskilt data for forsikring
                        + rArv[a,t] * vPensArv['PensX',aTot,t] / nPop[aTot,t] 
                        - vHhPensIndb['PensX',a,t]
                        - vHhPensIndb['Kap',a,t]
                        + vPersIndRest[a,t];

    E_vPersInd[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vPersInd[a,t] =E= vPersIndx[a,t] - vtHhAM[a,t];

    E_vSkatteplInd[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vSkatteplInd[a,t] =E= (   vPersInd[a,t]
                              + vNetKapInd[a,t] 
                              - vBeskFradrag[a,t] 
                              - vAKFradrag[a,t] 
                              - vELFradrag[a,t] 
                              - vRestFradrag[a,t]
                            ) * (1+jfvSkatteplInd[t]);

    E_vPersIndRest[a,t]$(a15t100[a] and t.val > %AgeData_t1%).. vPersIndRest[a,t] =E= (uPersIndRest_a[a,t] + uPersIndRest_t[t]) * vSatsIndeks[t];

    # vPersIndRest[aTot,t] vil ikke være lig sum(a, vPersIndRest[a,t] * nPop[a,t]), da de 0-14-åriges personindkomst ikke beregnes og vi ikke ønsker at korrigere for dette i totalen
    E_vPersIndRest_tot[t]$(t.val > %AgeData_t1%).. vPersInd[aTot,t] =E= sum(a, vPersInd[a,t] * nPop[a,t]);

    # Rentefradrag
    E_vKapIndPos[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vKapIndPos[a,t] =E= vHhAkt['Obl',a-1,t-1]/fv * fMigration[a,t]
                          * (rRente['Obl',t] + jrHhAktRenter['Obl',t] 
                             + jrvKapIndPos_a[a,t] + jrvKapIndPos_t[t])
                        + (vHhAkt['Bank',a-1,t-1]/fv * fMigration[a,t] 
                           * (rRente['Bank',t] + jrHhAktRenter['Bank',t] 
                              + jrvKapIndPos_a[a,t] + jrvKapIndPos_t[t]));
    E_jrvKapIndPos_atot[t]$(t.val > %AgeData_t1%)..
      vKapIndPos[aTot,t] =E= sum(a, vKapIndPos[a,t] * nPop[a,t]);

    E_vKapIndNeg[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vKapIndNeg[a,t] =E= sum(portf, vHhPas[portf,a-1,t-1]/fv * fMigration[a,t] 
                                     * (rRente[portf,t] + jrHhPasRenter[portf,t]
                                        + jrvKapIndNeg_a[a,t] + jrvKapIndNeg_t[t]));
    E_jrvKapIndNeg_atot[t]$(t.val > %AgeData_t1%)..
      vKapIndNeg[aTot,t] =E= sum(a, vKapIndNeg[a,t] * nPop[a,t]);

    E_vNetKapInd[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vNetKapInd[a,t] =E= vKapIndPos[a,t] - vKapIndNeg[a,t];
    E_vNetKapIndPos[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vNetKapIndPos[a,t] =E= rNet2KapIndPos[a,t] * vKapIndPos[a,t];

    # Fradrag
    E_vPersFradrag[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vPersFradrag[a,t] =E= vSatsIndeks[t] * (uvPersFradrag_a[a,t] + uvPersFradrag_t[t]);
    E_uvPersFradrag_a_tot[t]$(t.val > %AgeData_t1%).. vPersFradrag[aTot,t] =E= sum(a, vPersFradrag[a,t] * nPop[a,t]);

    E_vAKFradrag[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vAKFradrag[a,t] =E= vBidrag[a,t] / vBidrag[aTot,t] * vAKFradrag[aTot,t];
    E_vELFradrag[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vELFradrag[a,t] =E= vBidrag[a,t] / vBidrag[aTot,t] * vELFradrag[aTot,t];
    E_vRestFradrag[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vRestFradrag[a,t] =E=  vRestFradragSats[t] * nLHh[a,t] / nPop[a,t];
    E_vBeskFradrag[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vBeskFradrag[a,t] =E= tBeskFradrag[t] * vWHh[a,t];

# ----------------------------------------------------------------------------------------------------------------------
#   Marginal indkomstskat
# ----------------------------------------------------------------------------------------------------------------------
    E_mtInd[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      mtInd[a,t] =E= tBund[t] * ftBund[a,t]
                   + rTopSkatInd[a,t] * tTop[t]
                   + rMellemSkatInd[a,t] * tMellem[t]
                   + rTopTopSkatInd[a,t] * tTopTop[t]
                   + tKommune[t] + rtKirke[t] * tKirke[t]
                   + (1 - tBund[t] * ftBund[a,t]
                        - tTop[t] * rTopSkatInd[a,t]
                        - tMellem[t] * rMellemSkatInd[a,t]
                        - tTopTop[t] * rTopTopSkatInd[a,t]
                        - tKommune[t] - rtKirke[t] * tKirke[t]
                    ) * tAMbidrag[t] * ftAMBidrag[t] * (1 - vBidragTjmp[t] / vWHh[aTot,t]) 
                   + mtIndRest[a,t];

# ----------------------------------------------------------------------------------------------------------------------
#   Beregningsteknisk skat til lukning af offentlig budgetrestriktion
# ----------------------------------------------------------------------------------------------------------------------    
    E_vtLukning[a,t]$(a0t100[a] and t.val > %AgeData_t1%)..
      vtLukning[a,t] =E= tLukning[t] * (vtHhx[a,t] - vtLukning[a,t]);
  $ENDBLOCK

  MODEL M_GovRevenues /
    B_GovRevenues_static
    B_GovRevenues_forwardlooking
    B_GovRevenues_a
  /;

  # Definerer gruppe med nutidsværdi, da den benyttes i både static og post
  MODEL M_GovRevenues_nv /
    E_nvOffPrimInd, E_nvOffPrimInd_tEnd
    E_nvtDirekte, E_nvtDirekte_tEnd
    E_nvtIndirekte, E_nvtIndirekte_tEnd
    E_nvOffIndRest, E_nvOffIndRest_tEnd  /;

  $GROUP G_GovRevenues_nv
    nvOffPrimInd
    nvtDirekte
    nvtIndirekte
    nvOffIndRest
  ;

  $GROUP G_GovRevenues_static
    G_GovRevenues_endo
    -G_GovRevenues_endo_a
    -G_GovRevenues_nv
  ;

  # Equations that do not need to be solved together with the full model and can instead be solved afterwards.
  MODEL M_GovRevenues_post /
    M_GovRevenues_nv
  /;

  # Endogenous variables that are solved for only after the main model.
  # Note that these may not appear anywhere in the main model (this results in a model not square error).
  $GROUP G_GovRevenues_post
  G_GovRevenues_nv
  ;
  $GROUP G_GovRevenues_post G_GovRevenues_post$(tHBI.val <= t.val and t.val <= tEnd.val);
$ENDIF

$IF %stage% == "exogenous_values":
# ======================================================================================================================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_GovRevenues_makrobk
    # Direkte skatter
    vtDirekte, vtBund$(aTot[a_]), vtTop$(aTot[a_]), vtMellem$(aTot[a_]), vtTopTop$(aTot[a_]), 
    vtKommune$(aTot[a_]), vtEjd$(aTot[a_]), vtAktie$(aTot[a_]), 
    vtVirksomhed$(aTot[a_]), vtDoedsbo$(aTot[a_]), vtHhAM$(aTot[a_]), vtSelskab$(sTot[s_] or udv[s_]), vtPAL, vtMedie, 
    vtPersRest$(aTot[a_]), vtKapPens$(aTot[a_]), vtHhVaegt$(aTot[a_])
    # Indirekte skatter
    vtIndirekte
    vBidragOblRest
    # Øvrige indtægter
    vtArv$(aTot[a_])
    vBidrag$(aTot[a_])
    vBidragAK, vBidragEL, vBidragFri, vBidragObl, vBidragOblTjm, vBidragATP, vBidragTjmp, 
    vOffFraUdlKap, vOffFraUdlEU, vOffFraUdlRest, vOffFraHh, vOffFraVirk, vtKirke$(aTot[a_]), vJordrente, vtKulbrinte, vOffVirk, 
    vtJordrenteNordsoe, vtJordrenteRoer
    # Indkomster og fradrag
    vPersInd$(aTot[a_]), vSkatteplInd$(aTot[a_]), 
    vKapIndNeg$(aTot[a_]), vNetKapInd$(aTot[a_]), 
    vKapIndPos$(aTot[a_]), vBeskFradrag$(aTot[a_]), vAKFradrag$(aTot[a_]), vELFradrag$(aTot[a_]), vRestFradrag$(aTot[a_]), 
    # Øvrige variable
    tSelskab, vOffPrimInd, vtKilde
    #Øvrige
    tKapPens, tPAL, tAMbidrag, tBund, tTop, tMellem, tTopTop, tKirke, tKommune, tSelskab, rtKirke
    vtSelskabTillaeg, vtAfgEU
    vtEU, jvOffPrimInd
  ;
  @load(G_GovRevenues_makrobk, "..\Data\makrobk\makrobk.gdx" )

  # Aldersfordelt data fra aldersprofiler indlæses
  $GROUP G_GovRevenues_aldersprofiler
    vtBund$(a[a_]), vtKommune$(a[a_]), vtTop$(a[a_]) # Når vi har data for vtMellem og vtTopTop skal de indlæses her!
    vPersInd$(a[a_]), vKapIndNeg$(a[a_]), vKapIndPos$(a[a_]), vNetKapInd$(a[a_])
    vNetKapIndPos$(a[a_] or aTot[a_]), vPersFradrag$(a[a_] or aTot[a_]), rNet2KapIndPos$(a[a_] or aTot[a_])
  ;
  $GROUP G_GovRevenues_aldersprofiler
    G_GovRevenues_aldersprofiler$(t.val >= %AgeData_t1%)
  ;
  @load(G_GovRevenues_aldersprofiler, "..\Data\Aldersprofiler\aldersprofiler.gdx" )

  # Aldersfordelt data fra BFR indlæses
  $GROUP G_GovRevenues_BFR
    mtInd
  ;
  @load(G_GovRevenues_BFR, "..\Data\Befolkningsregnskab\BFR.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_GovRevenues_data
    G_GovRevenues_makrobk
    vNetKapIndPos$(a[a_] and tAgeData[t])
  ; 
  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_GovRevenues_data_imprecise  # Variables covered by data
    vtIndirekte
    vtEU # Små afrundinger i ADAM
    jvOffPrimInd
    tBund$(t.val = 2017)
    tTop$(t.val = 2017)
    tKommune$(t.val = 2017)
    vBidragOblRest
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  # Skattesatser fra skm, arbitrær vægt på 0.2 til den høje skattesats
  mtHhAktAfk.l['IndlAktier',t]$(t.val>=2012) = 0.8 * 0.27 + 0.2 * 0.42; 
  mtHhAktAfk.l['IndlAktier',t]$(t.val>=2010 and t.val<2012) = 0.8 * 0.27 + 0.2 * 0.43; 
  mtHhAktAfk.l['IndlAktier',t]$(t.val>=2001 and t.val<2010) = 0.8 * 0.28 + 0.2 * 0.43; 
  mtHhAktAfk.l['IndlAktier',t]$(t.val>=2000 and t.val<2001) = 0.8 * 0.25 + 0.2 * 0.40; 
  mtHhAktAfk.l['UdlAktier',t] = mtHhAktAfk.l['IndlAktier',t];

  # Initial skøn - skal datadækkes
  mrNet2KapIndPos.l[t] = 0.5;
  rtMellemRenter.l[t] = 0;
  rtTopRenter.l[t] = 0.5;
  rtTopTopRenter.l[t] = 0;

  rRealiseringAktieOmv.l[t] = 0.2;

  ftAktie.l[t] = 1;
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $BLOCK B_GovRevenues_static_calibration_base$(tx0[t])
    E_rvtAktie2BVT[t].. rvtAktie2BVT[t] * vBVT[spTot,t] =E= vtAktie[aTot,t];
  $ENDBLOCK

  $GROUP G_GovRevenues_static_calibration_base
    G_GovRevenues_endo
  # Primære indtægter
    jvOffPrimInd, -vOffPrimInd
    utHhVaegt, -vtHhVaegt[aTot,t]
    tEjd, -vtEjd[aTot,t]
    tVirksomhed$(t.val > 1986), -vtVirksomhed[aTot,t]
    tDoedsbo$(t.val > %AgeData_t1%), -vtDoedsbo[aTot,t]
    tPersRestxKapPens, -vtPersRest[aTot,t]
    ftKapPens, -vtKapPens[aTot,t]
    ftSelskab, -vtSelskab[sTot,t]
    jvtSelskabx[udv,t], -vtSelskab[udv,t]
    tSelskabTillaeg$(t.val > 1990), -vtSelskabTillaeg
    jvtKilde, -vtKilde
    jvtDirekte, -vtDirekte
  # Indkomster og fradrag
    tBeskFradrag$(t.val > 2003), -vBeskFradrag[aTot,t]
    jfvSkatteplInd, -vSkatteplInd[aTot,t]
  # Primære indtægter
    tAktie$(t.val > %NettoFin_t1%), -vtAktie[aTot,t]
    jvtPAL$(t.val > %cal_start%), -vtPAL
    utMedie$(t.val > 1990), -vtMedie
    rvtAfgEU2vtAfg, -vtAfgEU  
    tJordrenteRest, -vJordrente  
    tKulbrinte, -vtKulbrinte  
    uBidragOblTjm$(t.val >= %BFR_t1%), -vBidragOblTjm
    uBidragATP$(t.val >= %BFR_t1%), -vBidragATP
    uBidragOblRest$(t.val >= %BFR_t1%), -vBidragObl
    uBidragEL$(t.val >= %BFR_t1%), -vBidragEL
    uBidragFri$(t.val >= %BFR_t1%), -vBidragFri
    uBidragTjmp$(t.val >= %BFR_t1%), -vBidragTjmp
    uBidragAK$(t.val >= %BFR_t1%), -vBidragAK
  # Indkomster og fradrag   
    rAKFradrag2Bidrag$(t.val > 1993), -vAKFradrag[aTot,t]
    rELFradrag2Bidrag$(t.val > 1998), -vELFradrag[aTot,t]
    vRestFradragSats, -vRestFradrag[aTot,t]
    ftAMBidrag$(t.val > 1993), -vtHhAM[aTot,t]
    ftKirke$(t.val > 1986), -vtKirke[aTot,t]
    rvtAktie2BVT # E_rvtAktie2BVT
  ;
  $GROUP G_GovRevenues_static_calibration_newdata
    G_GovRevenues_static_calibration_base
    - G_GovRevenues_endo_a
    # Beregninger af led som er endogene i aldersdel (skal være uændret, når de beregnes endogent)
    -vPersFradrag[aTot,t], uvPersFradrag_t
    -vtBund[aTot,t], ftBund[aTot,t]
    -vtKommune[aTot,t], ftKommune[aTot,t]
    -vPersInd[aTot,t], vPersIndRest[aTot,t]
    -vtTop[aTot,t], rTopSkatInd[aTot,t]
    # Når der kommer data for 2026 skal mellem- og toptop-skatteprovenu også kalibreres
    #  -vtMellem[aTot,t], rMellemSkatInd[aTot,t]
    #  -vtTopTop[aTot,t], rTopTopSkatInd[aTot,t]
    -vKapIndNeg[aTot,t], jrvKapIndNeg_t[t]
    -vKapIndPos[aTot,t], jrvKapIndPos_t[t]
  ;
  $GROUP G_GovRevenues_static_calibration_newdata
    G_GovRevenues_static_calibration_newdata$(tx0[t])
    G_GovRevenues_endo$(not tx0[t]) # Nutidsværdier til HBI beregnes før t1
  ;

  MODEL M_GovRevenues_static_calibration_newdata /
    M_GovRevenues
    - B_GovRevenues_a
    B_GovRevenues_static_calibration_base
  /;

  $GROUP G_GovRevenues_static_calibration
    G_GovRevenues_static_calibration_base
  # Indkomster og fradrag
    uvPersFradrag_a$(t.val > %AgeData_t1%), -vPersFradrag[a,t]
    ftBund_a$(t.val > %AgeData_t1%),  -vtBund[a,t]
    ftKommune_a$(t.val > %AgeData_t1%),  -vtKommune[a,t]
    uPersIndRest_a$(t.val > %AgeData_t1%), -vPersInd[a,t]
    vPersIndRest[aTot,t]$(t.val <= %AgeData_t1%), -vPersInd[aTot,t]$(t.val <= %AgeData_t1%)
    rTopSkatInd_a$(t.val > %AgeData_t1%), -vtTop[a,t]$(t.val > %AgeData_t1%)
    # Når vi har data for mellem- og toptopskat, skal de kalibreres her!
    -vtArv[atot,t], tArv$(t.val > %AgeData_t1%)
    #  rTopSkatInd[aTot,t]$(t.val <= %AgeData_t1%), -vtTop[aTot,t]$(t.val <= %AgeData_t1%)
    jrvKapIndNeg_a$(aVal[a_] > 18 and t.val > %AgeData_t1%), -vKapIndNeg[a,t]$(aVal[a_] > 18 and t.val > %AgeData_t1%)
    jrvKapIndNeg_t[t]$(t.val <= %AgeData_t1%), -vKapIndNeg[aTot,t]$(t.val <= %AgeData_t1%)
    jrvKapIndNeg_t[t]$(t.val > %AgeData_t1%) # E_jrvKapIndNeg_t_AgeData
    jrvKapIndPos_a$(a15t100[a_] and t.val > %AgeData_t1%), -vKapIndPos[a,t]$(t.val > %AgeData_t1%)
    jrvKapIndPos_t[t]$(t.val <= %AgeData_t1%), -vKapIndPos[aTot,t]$(t.val <= %AgeData_t1%)
    jrvKapIndPos_t[t]$(t.val > %AgeData_t1%) # E_jrvKapIndPos_t_AgeData

    mtIndRest, -mtInd
    mtHhAktAfkRest[IndlAktier,t], -mtHhAktAfk[IndlAktier,t]
    mtHhAktAfkRest[UdlAktier,t], -mtHhAktAfk[UdlAktier,t]
  ;
  $GROUP G_GovRevenues_static_calibration
    G_GovRevenues_static_calibration$(tx0[t])
  ;

  $BLOCK B_GovRevenues_static_calibration$(tx0[t])
    E_jrvKapIndNeg_t_AgeData[t]$(t.val > %AgeData_t1%)..
      jrvKapIndNeg_a[aTot,t] =E= 0;
    E_jrvKapIndPos_t_AgeData[t]$(t.val > %AgeData_t1%)..
      jrvKapIndPos_a[aTot,t] =E= 0;
  $ENDBLOCK
  MODEL M_GovRevenues_static_calibration /
    M_GovRevenues
    B_GovRevenues_static_calibration_base
    B_GovRevenues_static_calibration
  /;
$ENDIF


# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_GovRevenues_deep
    G_GovRevenues_endo
    -rOffFraUdlKap2BNP, vOffFraUdlKap 
    -rOffFraUdlEU2BNP, vOffFraUdlEU 
    -rOffFraUdlRest2BNP, vOffFraUdlRest 
    -rOffFraHh2BNP, vOffFraHh
    -rOffFraVirk2BNP, vOffFraVirk
    -rOffVirk2BNP, vOffVirk
    tAktie # E_rvtAktie2BVT
    -uRestFradrag, vRestFradragSats
  ;
  $GROUP G_GovRevenues_deep G_GovRevenues_deep$(tx0[t]);
  # $BLOCK B_GovRevenues_deep
  # $ENDBLOCK
  MODEL M_GovRevenues_deep /
    M_GovRevenues - M_GovRevenues_post
    # B_GovRevenues_deep
    E_rvtAktie2BVT
  /;
$ENDIF

# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
$GROUP G_GovRevenues_dynamic_calibration
  G_GovRevenues_endo

  -rOffFraUdlKap2BNP, vOffFraUdlKap 
  -rOffFraUdlEU2BNP, vOffFraUdlEU 
  -rOffFraUdlRest2BNP, vOffFraUdlRest 
  -rOffFraHh2BNP, vOffFraHh
  -rOffFraVirk2BNP, vOffFraVirk
  -rOffVirk2BNP, vOffVirk

  -vPersFradrag[aTot,t1], uvPersFradrag_t[t1]
  -vtBund[aTot,t1], ftBund_t[t1]
  -vtKommune[aTot,t1], ftKommune_t[t1]
  -vPersInd[aTot,t1], uPersIndRest_t[t1]
  -vtTop[aTot,t1], rTopSkatInd_t[t1]
    # Når der kommer data for 2026 skal mellem- og toptop-skatteprovenu også kalibreres
  #  -vtMellem[aTot,t1], rMellemSkatInd_t[t1]
  #  -vtTopTop[aTot,t1], rTopTopSkatInd_t[t1]
  -vKapIndNeg[aTot,t1], jrvKapIndNeg_t[t1]
  -vKapIndPos[aTot,t1], jrvKapIndPos_t[t1]
  -vtSelskab[sTot,t1], ftSelskab[t1]

  # Disse 3 er kalibreret i static, men der kommer små uoverensstemmelser, hvis de ikke re-kalibreres
  ftKirke[t1], -vtKirke[aTot,t1]
  tPersRestxKapPens[t1], -vtPersRest[aTot,t1]
  tAktie[t1], -vtAktie[aTot,t1]

  # vtArv skal kalibreres dynamisk
  -vtArv[aTot,t1], tArv[t1]
  tDoedsbo[t1], -vtDoedsbo[aTot,t1] # Skal genkalibreres med arv
;
MODEL M_GovRevenues_dynamic_calibration /
  M_GovRevenues - M_GovRevenues_post
/;
$ENDIF
