# ======================================================================================================================
# Government revenues
# - See also taxes module
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_GovRevenues_endo_a
    vtBund[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Bundskatter, Kilde: ADAM[Ssysp1]"
    vtTop[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Topskatter, Kilde: ADAM[Ssysp2]+ADAM[Ssysp3]"
    vtMellem[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Mellemskatter, Kilde: ADAM[Ssyt1]"
    vtTopTop[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Toptopskatter, Kilde: ADAM[Ssyt3]"
    vtKommune[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Kommunal indkomstskatter, Kilde: ADAM[Ssys1]+ADAM[Ssys2]"
    vtEjd[a_,t]$((aVal[a_] >= 18) and t.val > %AgeData_t1%) "Ejendomsværdibeskatning, Kilde: ADAM[Spzej]"
    vtAktieHh[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Aktieskat betalt af danske husholdninger."
    vtVirksomhed[a_,t]$(a15t100[a_] and t.val > %NettoFin_t1%) "Virksomhedsskat, Kilde: ADAM[Ssyv]"
    vtDoedsbo[a_,t]$(a0t100[a_] and t.val > %AgeData_t1%) "Dødsboskat, Kilde: ADAM[Ssyd]"
    vtHhAM[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Arbejdsmarkedsbidrag betalt af husholdningerne, Kilde: ADAM[Sya]"
    vtPersRest[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Andre personlige indkomstskatter, Kilde: ADAM[Syp]"
    vtPersRestPens[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Andre personlige indkomstskatter fratrukket andre personlige indkomstskatter resterende, ADAM[Syp]-ADAM[Sypr]"
    vtPersRestPensArv[a_,t]$(aVal[a_] >= 15 and t.val > %AgeData_t1%) "Kapitalskatter betalt i forbindelse med dødsfald og arv - ikke-datadækket hjælpevariabel."
    vtHhVaegt[a_,t]$((a18t100[a_]) and t.val > %AgeData_t1%) "Vægtafgifter fra husholdningerne, Kilde: ADAM[Syv]"
    vtLukning[a_,t]$(a18t100[a_] and t.val > %AgeData_t1%) "Beregningsteknisk skat til lukning af offentlig budgetrestriktion på lang sigt (HBI=0). Indgår IKKE i offentlig saldo."
    vtArv[a_,t]$(t.val > %AgeData_t1%) "Kapitalskatter (Arveafgift), Kilde: ADAM[sK_h_o] for total."
    vBidrag[a_,t]$((a15t100[a_] and t.val > %AgeData_t1%)) "Bidrag til sociale ordninger, Kilde: ADAM[Tp_h_o]"
    vtKirke[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Kirkeskat, Kilde: ADAM[Trks]"
    # Indkomstbegreber og fradrag 
    vPersInd[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Personlig indkomst, Kilde: ADAM[Ysp]"
    vPersIndx[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Personlig indkomst, Kilde: ADAM[Yt]"
    vPersIndRest[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > %AgeData_t1%) "Aggregeret restled til personindkomst."
    vSkatteplInd[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Skattepligtig indkomst, Kilde: ADAM[Ys]"
    vNetKapIndPos[a_,t]$((a15t100[a_] and t.val > %AgeData_t1% )) "Positiv nettokapitalindkomst."
    vNetKapIndNeg[a_,t]$((a15t100[a_] and t.val > %AgeData_t1% )) "Negativ nettokapitalindkomst."
    vNetKapInd[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Nettokapitalindkomst, Kilde: Aggregat fra kapitalindkomst fra PSKAT2"
    vKapIndPos[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Imputeret positiv kapitalindkomst."
    vKapIndNeg[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Imputeret negativ kapitalinkomst, Kilde: Aggregat fra renteudgifter fra PSKAT2."
    vPersFradrag[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Imputeret personfradrag."
    vAKFradrag[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Imputeret fradrag for A-kassebidrag."
    vELFradrag[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Imputeret fradrag for efterlønsbidrag."
    vRestFradrag[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Imputerede øvrige ligningsmæssige fradrag (befordringsfradrag m.m.)"
    vBeskFradrag[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Imputeret beskæftigelsesfradrag."
    vHhAktieInd[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > %AgeData_t1%) "Aktieindkomst: dividender plus realiserede omvurderinger. Aggregat fra PSKAT2."
    vUrealiseretAktieOmv[a_,t]$((aVal[a_] > 0 and t.val > %AgeData_t1%+1) or (aTot[a_] and t.val > %AgeData_t1%)) "Skøn over endnu ikke realiserede kapitalgevinster på aktier."
    ftBund[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > %AgeData_t1%) "Korrektionsfaktor fra faktisk til implicit skattesats."
    ftKommune[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > %AgeData_t1%) "Korrektionsfaktor fra faktisk til implicit skattesats."
    rTopSkatInd[a_,t]$(t.val > %AgeData_t1%) "Imputeret gennemsnitlig del af indkomsten over topskattegrænsen."
    rMellemSkatInd[a_,t]$(t.val >= %AgeData_t1% and t.val >= 2026) "Imputeret gennemsnitlig del af indkomsten over mellemskattegrænsen."
    rTopTopSkatInd[a_,t]$(t.val >= %AgeData_t1% and t.val >= 2026) "Imputeret gennemsnitlig del af indkomsten over toptopskattegrænsen."
    ftAktieHh[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > %AgeData_t1%) "Korrektionsfaktor fra faktisk til implicit skattesats."
    fvtDoedsbo[t]$(t.val > %AgeData_t1%) "parameter til at fange sammensætningseffekt."
    uvPersFradrag_a[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "Aldersfordelt imputeret personfradrag ekskl. regulering"
    mtInd[a_,t]$(t.val > %AgeData_t1% and a[a_]) "Marginal skattesats på lønindkomst."
    rNet2KapIndPos[a_,t]$((aTot[a_] or a15t100[a_]) and t.val > %AgeData_t1%) "Positiv nettokapitalindkomst ift. positiv kapitalindkomst."
    jrvKapIndPos_a[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "Alders-specifikt j-led i vKapIndPos."
    jrvKapIndNeg_a[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "Alders-specifikt j-led i vKapIndNeg."
    rRealiseringAktieOmv[a_,t]$(a15t100[a_] and t.val > %AgeData_t1%) "Andel af akkumulerede omvurderinger på aktier som realiseres hvert år."
  ;
  $GROUP G_GovRevenues_endo
    G_GovRevenues_endo_a

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
    vtAktie[t]$(t.val > %NettoFin_t1%) "Aktieskat, Kilde: ADAM[Ssya]"
    vtAktieHh[aTot,t]$(t.val > %AgeData_t1%)
    vtAktieUdl[t]$(t.val >= 2005) "Skat på udbytter til udenlandske aktionærer. Kilde: MANGLER"
    vtVirksomhed[a_,t]$(aTot[a_] and t.val > %NettoFin_t1%) "Virksomhedsskat, Kilde: ADAM[Ssyv]"
    vtDoedsbo[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "Dødsboskat, Kilde: ADAM[Ssyd]"
    vtHhAM[a_,t]$(aTot[a_] and t.val >= %NettoFin_t1%) "Arbejdsmarkedsbidrag betalt af husholdningerne, Kilde: ADAM[Sya]"
    vtPersRest[a_,t]$(aTot[a_] and t.val >= %NettoFin_t1%) "Andre personlige indkomstskatter, Kilde: ADAM[Syp]"
    vtPersRestPens[a_,t]$(aTot[a_] and t.val > %NettoFin_t1%) "Andre personlige indkomstskatter fratrukket andre personlige indkomstskatter resterende, ADAM[Syp]-ADAM[Sypr]"
    vtPersRestPensArv[a_,t]$(aTot[a_] and t.val > %AgeData_t1%) "Kapitalskatter betalt i forbindelse med dødsfald og arv - ikke-datadækket hjælpevariabel."
    vtSelskab[s_,t]$(t.val > %NettoFin_t1%) "Selskabsskat, Kilde: ADAM[Syc]"
    vtSelskabRest[s_,t]$(sTot[s_] and t.val > %NettoFin_t1%) "J-led til at ramme branchefordelt selskabsskat - inkluderer tillægsskat for kulbrinteselskaber (kun relevant for udv)"
    vtPAL[t]$(t.val > %NettoFin_t1%) "PAL skat, Kilde: ADAM[Sywp]"
    vtMedie[t]$(t.val >= %BFR_t1%) "Medielicens, Kilde: ADAM[Sym]"
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
    vNetKapIndNeg[a_,t]$(aTot[a_]) "Positiv nettokapitalindkomst."
    vNetKapInd[a_,t]$(aTot[a_]) "Nettokapitalindkomst, Kilde: Aggregat fra kapitalindkomst fra PSKAT2"
    vKapIndPos[a_,t]$(aTot[a_] and t.val > %NettoFin_t1%) "Imputeret positiv kapitalindkomst."
    vKapIndNeg[a_,t]$(aTot[a_] and t.val > %NettoFin_t1%) "Imputeret negativ kapitalinkomst, Kilde: Aggregat fra renteudgifter fra PSKAT2."
    vPersFradrag[a_,t]$(aTot[a_] and t.val >= %AgeData_t1%) "Imputeret personfradrag."
    vAKFradrag[a_,t]$(aTot[a_] and t.val >= %NettoFin_t1%) "Imputeret fradrag for A-kassebidrag."
    vELFradrag[a_,t]$(aTot[a_] and t.val > 1998) "Imputeret fradrag for efterlønsbidrag."
    vRestFradrag[a_,t]$(aTot[a_]) "Imputerede øvrige ligningsmæssige fradrag (befordringsfradrag m.m.)"
    vBeskFradrag[a_,t]$(aTot[a_] and t.val > 2003) "Imputeret beskæftigelsesfradrag."
    vUdlUdbytteDirekte[t]$(t.val >= 2005) "Udbytter til udenlandske direkte investeringer."
    vUdlUdbyttePortf[t]$(t.val >= 2005) "Udbytter til udenlandske porteføljeaktier."

    ftAktieHh[aTot,t]$(%NettoFin_t1% < t.val and t.val <= %AgeData_t1%)
    rOffFraUdlKap2BNP[t] "Kapitaloverførsler fra udlandet til den offentlige sektor relativt til BNP."
    rOffFraUdlEU2BNP[t] "Residuale overførsler fra EU til den offentlige sektor relativt til BNP."
    rOffFraUdlRest2BNP[t] "Residuale overførsler fra udlandet eksl. EU til den offentlige sektor relativt til BNP."
    rOffFraHh2BNP[t] "Overførsler fra husholdningerne til den offentlige sektor relativt til BNP."
    rOffFraVirk2BNP[t] "Overførsler fra virksomhederne til den offentlige sektor relativt til BNP."
    rOffVirk2BNP[t] "Overskud fra offentlige virksomheder relativt til BNP."
    uRestFradrag[t] "Restfradragssats relativ til sats-reguleringen."
    mtVirk[s_,t]$(sp[s_]) "Branchefordelt marginal indkomstskat hos virksomheder."
    tLukning[t] "Beregningsteknisk skatteskat til lukning af offentlig budgetrestriktion på lang sigt (HBI=0)."
    rRealiseringAktieOmv[a_,t]$(aTot[a_] and t.val > %AgeData_t1%+1) "Andel af akkumulerede omvurderinger på aktier som realiseres hvert år."
    fvHhAktieInd[t]$(t.val > %AgeData_t1%+1) "Korrektionsfaktor fra faktisk til implicit skattesats."
  ;

  $GROUP G_GovRevenues_endo 
    G_GovRevenues_endo$(tx0[t]) # Restrict endo group to tx0[t]

    mtHhAktAfk[portf,t]$(fin_akt[portf] and not (IndlAktier[portf] or UdlAktier[portf]) and d1vHhAkt[portf,t] or (d1vHhAkt[portf,t] and (IndlAktier[portf] or UdlAktier[portf]) and t.val >= 2000)) "Marginalskat på husholdningers kapitalindkomster."
    mtHhPasAfk[portf,t]$(d1vHhPas[portf,t]) "Marginalskat på husholdningers renteudgifter."
  ;

  $GROUP G_GovRevenues_exogenous_forecast
    vOffFraUdlKap[t] "Kapitaloverførsler fra udlandet, Kilde: ADAM[tK_e_o]"
    vOffFraUdlEU[t] "Residuale overførsler fra EU, Kilde: ADAM[Tr_eu_o]"
    vOffFraUdlRest[t] "Residuale overførsler fra udlandet ekskl. EU, Kilde: ADAM[Tr_er_o]"
    vOffFraHh[t] "Residuale overførsler fra den private sektor, Kilde: ADAM[Trr_hc_o]"
    vOffFraVirk[t] "Kapitaloverførsler fra den private sektor, Kilde: ADAM[tK_hc_o]"
    vOffVirk[t] "Overskud af offentlig virksomhed, Kilde: ADAM[Tiuo_z_o]"
    vRestFradragSats[t] "Eksogen del af andre fradrag kalibreret til at ramme makrodata."
  ;
  $GROUP G_GovRevenues_forecast_as_zero
    jfvSkatteplInd[t] "Multiplikativt J-led."
    jvtPal[t] "J-led"

    jvOffPrimInd[t] "J-led."
    jvtKilde[t] "J-led afspejler datamæssige uoverensstemmelser - skal være 0 i fremskrivning."
    jvtDirekte[t] "J-led afspejler datamæssige uoverensstemmelser - skal være 0 i fremskrivning."
    vtSelskabRest[s_,t]$(s[s_]) "J-led til at ramme branchefordelt selskabsskat - inkluderer tillægsskat for kulbrinteselskaber (kun relevant for udv)"

    vtJordrenteNordsoe[t] "Off. indtægter af jord og rettigheder, jordrente fra Nordsøen (produktionsafgift), Afgiften blev ophævet i 2014, (indgår i vtJordrenteRest) Kilde: ADAM[Tire_o]"
    vtJordrenteRoer[t] "Olierørledningsafgift, (indgår i vtJordrenteRest) Kilde: ADAM[Tiro]"
  ;
  $GROUP G_GovRevenues_ARIMA_forecast
    # Endogene i stødforløb:
    rvtAfgEU2vtAfg[t] "Andel af produktskatter som går til EU."
    rtKirke[t] "Andel af skatteydere som betaler kirkeskat, ADAM[bks]"
    ftVirksomhed[t] "Korrektionsfaktor fra faktisk til implicit skattesats"
    rUdlUdbytteDirekte[t] "Udbytter af udlandets direkte investeringer, som andel af samlet udbytte til udland."
  ;
  $GROUP G_GovRevenues_newdata_forecast
    uRestFradrag[t]

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
    tPersRestx[t] "Implicit skattesats."
    tDoedsbo[t] "Implicit skattesats."
    tAktieTop[t] "Højeste skattesats på aktieafkast."
    tAktieLav[t] "Laveste skattesats på aktieafkast."
    tKulbrinte[t] "Implicit skattesats."
    tJordrenteRest[t] "Implicit skattesats."
    tBeskFradrag[t] "Imputeret gennemsnitlig beskæftigelsesfradrag ift. lønindkomst."
    tArv[t] "Arveafgift (implicit, gennemsnit)"

    uPersIndRest_t[t] "Restled til personindkomst, uafhængigt af alder."

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
    rtTopRenter[t] "Andel af renteindtægter, der betales topskat af."
    rtTopTopRenter[t] "Andel af renteindtægter, der betales topskat af."
    rtMellemRenter[t] "Andel af renteindtægter, der betales topskat af."
    mrNet2KapIndPos[t] "Marginal stigning i positiv nettokapitalindkomst ved stigning i kapitalindkomst."

    tTidligPensUdb[t] "Skattesats på tidligt hævet ATP, livrente og ratepension"
  ;
  $GROUP G_GovRevenues_fixed_forecast
    ftAMBidrag[t] "Korrektionsfaktor fra faktisk til implicit skattesats."
    ftKirke[t] "Korrektionsfaktor fra faktisk til implicit skattesats."
    ftSelskab[t] "Korrektionsfaktor fra faktisk til implicit skattesats."

    ftBund_t[t] "Tids-afhængigt led i ftBund."
    ftBund_a[a,t] "Alders-specifikt led i ftBund."
    ftAktieHh_t[t] "Tids-afhængigt led i ftAktieHh."
    ftAktieHh_a[a,t] "Alders-specifikt led i ftAktieHh."
    ftAktieUdl[t] "Belastningsgrad for udbytter til udenlandske aktionærer."
    ftKommune_t[t] "Tids-afhængigt led i ftKommune."
    ftKommune_a[a,t] "Alders-specifikt led i ftKommune."
    jrvKapIndPos_a[a_,t]$(a[a_])
    jrvKapIndPos_t[t] "Tids-afhængigt j-led i vKapIndPos."
    jrvKapIndNeg_a[a,t]$(a[a_])
    jrvKapIndNeg_t[t] "Tids-afhængigt j-led i fvKapIndNeg."
    rTidligPensUdb[t] "Andel af ATP, livrente og ratepension, der bliver hævet tidligt"
    rRealiseringAktieOmv_a[a,t] "Alders-specifikt led i realiseringsraten for aktieomvurderinger."
    rRealiseringAktieOmv_t[t] "Tids-afhængigt led i realiseringsraten for aktieomvurderinger."

    uvPersFradrag_a[a_,t]$(a15t100[a_])
    uPersIndRest_a[a_,t] "Aldersfordelt restled til personindkomst."

    rTopSkatInd_a[a,t] "Alders-specifikt led i rTopSkatInd."
    rMellemSkatInd_a[a,t] "Alders-specifikt led i rMellemSkatInd."
    rTopTopSkatInd_a[a,t] "Alders-specifikt led i rTopTopSkatInd."
    rNet2KapIndPos_a[a,t] "Alders-specifikt led i rNet2KapIndPos."

    mtIndRest[a,t] "Residual-led i marginal skattesats på lønindkomst."
    mtHhAktAfkRest[portf,t] "Forskel mellem gennemsnitlig og marginal kapital beskatningskat."
    rOffFraVirk2BNP
    rOffFraHh2BNP
    rOffFraUdlRest2BNP
    rOffFraUdlKap2BNP
    rOffFraUdlEU2BNP
    rOffVirk2BNP

    frNet2KapIndPos_t[t] "Tids-afhængigt led i rNet2KapIndPos."
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
      vtKilde[t] =E= vtKommune[aTot,t] + vtBund[aTot,t] + vtAktie[t] + vtTop[aTot,t] + vtMellem[aTot,t]
                   + vtTopTop[aTot,t] + vtEjd[aTot,t] + vtVirksomhed[aTot,t] + vtDoedsbo[aTot,t] + jvtKilde[t];

    E_vtPersonlige[t]..
      vtPersonlige[t] =E= vtKommune[aTot,t] + vtBund[aTot,t] + vtTop[aTot,t] + vtMellem[aTot,t] + vtTopTop[aTot,t];

    E_vtKommune_via_ftKommune[t]$(t.val > %AgeData_t1%)..
      vtKommune[aTot,t] =E= tKommune[t] * ftKommune[aTot,t] * (vSkatteplInd[aTot,t] - vPersFradrag[aTot,t]);

    E_vtBund_via_ftBund[t]$(t.val > %AgeData_t1%)..
      vtBund[aTot,t] =E= tBund[t] * ftBund[aTot,t] * (vPersInd[aTot,t] + vNetKapIndPos[aTot,t] - vPersFradrag[aTot,t]);

    E_vtAktie[t]$(t.val > %NettoFin_t1%)..
      vtAktie[t] =E= vtAktieHh[aTot,t] + vtAktieUdl[t];

    E_vtAktieUdl[t]$(t.val >= 2005)..
      vtAktieUdl[t] =E= ftAktieUdl[t] * tAktieTop[t] * vUdlUdbyttePortf[t];

    E_vUdlUdbytteDirekte[t]$(t.val >= 2005)..
      vUdlUdbytteDirekte[t] =E= rUdlUdbytteDirekte[t] * vUdlAktRenter['IndlAktier',t];
    E_vUdlUdbyttePortf[t]$(t.val >= 2005)..
      vUdlUdbytteDirekte[t] + vUdlUdbyttePortf[t] =E= vUdlAktRenter['IndlAktier',t];

    # Sammensætningseffekt skyldes forskellige dødssandsynligheder og formuer, da kun overlevende betaler aktieskat
    E_vtAktieHh_via_ftAktieHh[t]$(t.val > %NettoFin_t1%)..
      vtAktieHh[aTot,t] =E= ftAktieHh[aTot,t] * tAktieTop[t] * vHhAktieInd[aTot,t];
# En del af de samlede dividender og kursgevinster går til de døde og er ikke med her - sammensætningseffekter fanges i fvHhAktieInd
    E_vHhAktieInd_via_fvHhAktieInd[t]$(t.val > %AgeData_t1%+1)..
      vHhAktieInd[aTot,t] =E= fvHhAktieInd[t] * rOverlev[aTot,t] * (rRealiseringAktieOmv[aTot,t] * vUrealiseretAktieOmv[aTot,t] / (1 - rRealiseringAktieOmv[aTot,t])
                              + vHhAktRenter['IndlAktier',t] + vHhAktRenter['UdlAktier',t]);

    # De dødes aktier realiseres 100 pct. og er ikke med her, men indgår i dødsboskat
    E_vUrealiseretAktieOmv_via_rRealiseringAktieOmv[t]$(t.val > %AgeData_t1%+1)..
      vUrealiseretAktieOmv[aTot,t] =E= rOverlev[aTot,t] * (1 - rRealiseringAktieOmv[aTot,t])
                                         * (vUrealiseretAktieOmv[aTot,t-1]/fv
                                            + vHhAktOmv['IndlAktier',t] + vHhAktOmv['UdlAktier',t]);

    E_vtTop_via_rTopskatInd[t]$(t.val > %AgeData_t1%)..
      vtTop[aTot,t] =E= tTop[t] * rTopSkatInd[aTot,t] * (vPersInd[aTot,t] + vNetKapIndPos[aTot,t]);

    #  Når der er 2026-data og top-top-skatten er indført skal ovenstående ligning skiftes ud med nedenstående
#    E_vtTop_aTot[t]$(t.val > %AgeData_t1%)..
#      vtTop[aTot,t] =E= tTop[t] * rTopSkatInd[aTot,t] * (vPersIndx[aTot,t] + vNetKapIndPos[aTot,t]);

    E_vtMellem_via_rMellemSkatInd[t]$(t.val > %AgeData_t1%)..
      vtMellem[aTot,t] =E= tMellem[t] * rMellemSkatInd[aTot,t] * (vPersInd[aTot,t] + vNetKapIndPos[aTot,t]);

    E_vtTopTop_via_rTopTopSkatInd[t]$(t.val > %AgeData_t1%)..
      vtTopTop[aTot,t] =E= tTopTop[t] * rTopTopSkatInd[aTot,t] * (vPersInd[aTot,t] + vNetKapIndPos[aTot,t]);

    E_vtEjd_aTot[t].. vtEjd[aTot,t] =E= tEjd[t] * vBolig[aTot,t-1]/fv;    

    E_vtVirksomhed_tot[t]$(t.val > %NettoFin_t1%).. vtVirksomhed[aTot,t] =E= tSelskab[t] * ftVirksomhed[t] * vEBT[sTot,t];

    # Sammensætningseffekten er væsentlig, da den aggregerede overlevelses-sandsynlighed er langt fra den gennemsnitlige overlevelses-sandsynlighed vægtet efter formue
    # Udover dette fanger fvtDoedsbo også korrelation mellem overlevelse og formue indenfor en kohorte (rArvKorrektion)
    # NB: Alle urealiserede aktier beskattes ved død
    E_vtDoedsbo_via_fvtDoedsbo[t]$(t.val > %AgeData_t1%)..
      vtDoedsbo[aTot,t] =E= tDoedsbo[t] * fvtDoedsbo[t] * (1-rOverlev[aTot,t-1])
                          * (vUrealiseretAktieOmv[aTot,t]
                              + vHhAktRenter['IndlAktier',t] + vHhAktRenter['UdlAktier',t]
                              + vNetKapIndPos[aTot,t] / rOverlev[aTot,t-1]
                              );

# ----------------------------------------------------------------------------------------------------------------------
#   Andre direkte skatter
# ----------------------------------------------------------------------------------------------------------------------
    E_vtHhAM_tot[t]$(t.val >= %NettoFin_t1%)..
      vtHhAM[aTot,t] =E= tAMbidrag[t] * ftAMBidrag[t] * (vWHh[aTot,t] - vBidragTjmp[t]);

    E_vtSelskab[sp,t]$(t.val > %NettoFin_t1%).. vtSelskab[sp,t] =E= tSelskab[t] * ftSelskab[t] * vEBT[sp,t] + vtSelskabRest[sp,t];
    E_vtSelskab_sTot[t]$(t.val > %NettoFin_t1%).. vtSelskab[sTot,t] =E= sum(sp, vtSelskab[sp,t]);
    E_vtSelskab_sTot_via_vSelskabRest[t]$(t.val > %NettoFin_t1%).. vtSelskab[sTot,t] =E= tSelskab[t] * ftSelskab[t] * vEBT[sTot,t] + vtSelskabRest[sTot,t];

    # Udlændinge betaler også PAL-skat, MEN vtPAl trækkes fra danske husholdninger - hermed betaler de i 1. omgang udlændinges PAL-skat
    # Udlændinges bidrag til PAL-skat kommer via vHhTilUdl
    E_vtPAL[t]$(t.val > %NettoFin_t1%)..
      vtPAL[t] =E= tPAL[t] * (rRente['pensTot',t] + rOmv['pensTot',t] - rHhAktOmk['pensTot',t]) * vPensionAkt['Tot',t-1]/fv + jvtPal[t];

    E_vtHhVaegt_tot[t].. vtHhVaegt[aTot,t] =E= utHhVaegt[t] * pnCPI[cTot,t-1]/fp * qBiler[t-1]/fq;

    E_vtMedie_tot[t]$(t.val >= %BFR_t1%).. vtMedie[t] =E= utMedie[t] * vSatsIndeks[t] * nPop['a18t100',t];

    E_vtPersRest_tot[t]$(t.val >= %NettoFin_t1%)..
      vtPersRest[aTot,t] =E= vtPersRestPens[aTot,t] + tPersRestx[t] * vPersInd[aTot,t];
    
    E_vtPersRestPens_tot[t]$(t.val > %NettoFin_t1%)..
      vtPersRestPens[aTot,t] =E= tKapPens[t] * vHhPensUdb['Kap',aTot,t]
                               + tTidligPensUdb[t] * vHhPensUdb['PensX',aTot,t] * rTidligPensUdb[t];

    E_vtPersRestPensArv_tot[t]$(t.val > %AgeData_t1%)..
      vtPersRestPensArv[aTot,t] =E= tKapPens[t] * vPensArv['Kap',aTot,t]
                                  + tTidligPensUdb[t] * vPensArv['PensX',aTot,t] * rTidligPensUdb[t];

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
                       + vtKirke[aTot,t] + vJordrente[t] + vOffVirk[t];

    # Sociale bidrag
    E_vBidrag_tot[t]..
      vBidrag[aTot,t] =E= vBidragAK[t] + vBidragTjmp[t] + vBidragEL[t] + vBidragFri[t] + vBidragObl[t];

    E_vBidragAK[t]$(t.val >= %BFR_t1%)..      vBidragAK[t]      =E= uBidragAK[t]      * vLoenIndeks[t] * nBruttoArbsty[t];
    E_vBidragTjmp[t]$(t.val >= %BFR_t1%)..    vBidragTjmp[t]    =E= uBidragTjmp[t]    * vLoensum['off',t];
    E_vBidragEL[t]$(t.val >= %BFR_t1%)..      vBidragEL[t]      =E= uBidragEL[t]      * vLoenIndeks[t] * nBruttoArbsty[t];
    E_vBidragFri[t]$(t.val >= %BFR_t1%)..     vBidragFri[t]     =E= uBidragFri[t]     * vLoenIndeks[t] * nBruttoArbsty[t];
    E_vBidragOblTjm[t]$(t.val >= %BFR_t1%)..  vBidragOblTjm[t]  =E= uBidragOblTjm[t]  * vLoensum['off',t];
    E_vBidragATP[t]$(t.val >= %BFR_t1%)..     vBidragATP[t]     =E= uBidragATP[t]     * vLoenIndeks[t] * nBruttoArbsty[t];
    E_vBidragOblRest[t]$(t.val >= %BFR_t1%).. vBidragOblRest[t] =E= uBidragOblRest[t] * vLoenIndeks[t] * nBruttoArbsty[t];

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
    E_vPersIndx_tot_via_vPersIndRest[t]$(t.val >= %BFR_t1%)..
      vPersIndx[aTot,t] =E= vWHh[aTot,t]
                          + vOvfSkatPl[aTot,t]
                          + vHhPensUdb['PensX',aTot,t]
                          - (vHhPensIndb['PensX',aTot,t] - vPensIndbOP[aTot,t])
                          - vHhPensIndb['Kap',aTot,t]
                          + vPersIndRest[aTot,t];

    E_vPersInd_tot_via_vPersIndx[t]$(t.val >= %BFR_t1%)..
      vPersInd[aTot,t] =E= vPersIndx[aTot,t] - vtHhAM[aTot,t];

    E_vSkatteplInd_tot[t]..
      vSkatteplInd[aTot,t] =E= ( vPersInd[aTot,t]
                               + vNetKapInd[aTot,t] 
                               - vBeskFradrag[aTot,t] 
                               - vAKFradrag[aTot,t] 
                               - vELFradrag[aTot,t] 
                               - vRestFradrag[aTot,t]
                             ) * (1+jfvSkatteplInd[t]);

    E_vKapIndPos_via_jrvKapIndPos[t]$(t.val > %NettoFin_t1%)..
      vKapIndPos[aTot,t] =E= vHhAkt['Obl',aTot,t-1]/fv * rOverlev[aTot,t-1] 
                             * (rRente['Obl',t] + jrvKapIndPos_a[aTot,t] + jrvKapIndPos_t[t])
                           + vHhAkt['Bank',aTot,t-1]/fv * rOverlev[aTot,t-1]
                              * (rRente['Bank',t] - rHhAktOmk['Bank',t] + jrvKapIndPos_a[aTot,t] + jrvKapIndPos_t[t]);

    E_vKapIndNeg_via_jrvKapIndNeg[t]$(t.val > %NettoFin_t1%)..
      vKapIndNeg[aTot,t] =E= sum(portf, vHhPas[portf,aTot,t-1]/fv * rOverlev[aTot,t-1] 
                                        * (rRente[portf,t] + rHhPasOmk[portf,t] + jrvKapIndNeg_a[aTot,t] + jrvKapIndNeg_t[t]));

    E_vNetKapIndPos_via_rNet2KapIndPos[t]..
      vNetKapIndPos[aTot,t] =E= rNet2KapIndPos[aTot,t] * vKapIndPos[aTot,t];

    E_vNetKapInd_tot[t].. vNetKapInd[aTot,t] =E= vKapIndPos[aTot,t] - vKapIndNeg[aTot,t];

    E_vNetKapIndNeg_tot[t].. vNetKapIndNeg[aTot,t] =E= vNetKapIndPos[aTot,t] - vNetKapInd[aTot,t];

    # Fradrag
    E_vPersFradrag_via_uvPersFradrag[t]$(t.val > %AgeData_t1%).. 
      vPersFradrag[aTot,t] =E= vLoenIndeks[t] * (uvPersFradrag_a[aTot,t] + uvPersFradrag_t[t]);

    E_vAKFradrag_tot[t]$(t.val >= %NettoFin_t1%).. vAKFradrag[aTot,t] =E= rAKFradrag2Bidrag[t] * vBidragAK[t];
    E_vELFradrag_tot[t]$(t.val > 1998).. vELFradrag[aTot,t] =E= rELFradrag2Bidrag[t] * vBidragEL[t];
    E_vRestFradrag_tot[t].. vRestFradrag[aTot,t] =E= vRestFradragSats[t] * nLHh[aTot,t];
    E_vBeskFradrag_tot[t]$(t.val > 2003).. vBeskFradrag[aTot,t] =E= tBeskFradrag[t] * vWHh[aTot,t];

    E_uRestFradrag[t].. vRestFradragSats[t] =E= uRestFradrag[t] * vLoenIndeks[t];

# ----------------------------------------------------------------------------------------------------------------------
#   Marginalskatter
# ----------------------------------------------------------------------------------------------------------------------    
    E_mtVirk[sp,t].. mtVirk[sp,t] =E= tSelskab[t];

    E_mtHhAktAfk[portf,t]$((Bank[portf] or Obl[portf]) and t.val > %NettoFin_t1%).. 
      mtHhAktAfk[portf,t] =E= tKommune[t] + rtKirke[t] * tKirke[t]
                            + mrNet2KapIndPos[t] * tBund[t]
                            + rtMellemRenter[t] * tMellem[t]
                            + rtTopRenter[t] * tTop[t]
                            + rtTopTopRenter[t] * tTopTop[t];

    E_mtHhAktAfk_aktier[portf,t]$((IndlAktier[portf] or UdlAktier[portf]) and t.val >= 2000)..
      mtHhAktAfk[portf,t] =E= ftAktieHh[aTot,t] * tAktieTop[t] + mtHhAktAfkRest[portf,t];

    E_mtHhPasAfk[portf,t]$((Bank[portf] or RealKred[portf]) and t.val > %NettoFin_t1%).. 
      mtHhPasAfk[portf,t] =E= tKommune[t] + rtKirke[t] * tKirke[t];

# ----------------------------------------------------------------------------------------------------------------------
#   Beregningsteknisk skat til lukning af offentlig budgetrestriktion
# ----------------------------------------------------------------------------------------------------------------------    
    E_tLukning[t]$(t.val > %AgeData_t1%)..
      vtLukning[aTot,t] =E= tLukning[t] * (vtHhx[aTot,t] - vtLukning[aTot,t]);
  $ENDBLOCK

  # $BLOCK B_GovRevenues_forwardlooking
  # $ENDBLOCK

  $BLOCK B_GovRevenues_a$(tx0[t])
# ----------------------------------------------------------------------------------------------------------------------
#   Kildeskatter
# ----------------------------------------------------------------------------------------------------------------------
    E_vtKommune[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vtKommune[a,t] =E= tKommune[t] * ftKommune[a,t] * (vSkatteplInd[a,t] - vPersFradrag[a,t]);
    E_ftKommune[a,t]$(a15t100[a] and t.val > %AgeData_t1%).. ftKommune[a,t] =E= ftKommune_a[a,t] + ftKommune_t[t];
    E_vtKommune_aTot[t]$(t.val > %AgeData_t1%).. vtKommune[aTot,t] =E= sum(a, vtKommune[a,t] * nPop[a,t]);

    E_vtBund[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vtBund[a,t] =E= tBund[t] * ftBund[a,t] * (vPersInd[a,t] + vNetKapIndPos[a,t] - vPersFradrag[a,t]);
    E_ftBund[a,t]$(a15t100[a] and t.val > %AgeData_t1%).. ftBund[a,t] =E= ftBund_a[a,t] + ftBund_t[t];
    E_vtBund_aTot[t]$(t.val > %AgeData_t1%).. vtBund[aTot,t] =E= sum(a, vtBund[a,t] * nPop[a,t]);

    E_vtAktieHh[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vtAktieHh[a,t] =E= ftAktieHh[a,t] * tAktieTop[t] * vHhAktieInd[a,t];
    E_ftAktieHh[a,t]$(a15t100[a] and t.val > %AgeData_t1%).. ftAktieHh[a,t] =E= ftAktieHh_a[a,t] + ftAktieHh_t[t];
    E_rRealiseringAktieOmv[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      rRealiseringAktieOmv[a,t] =E= rRealiseringAktieOmv_a[a,t] * (1+rRealiseringAktieOmv_t[t]);
    E_vtAktieHh_aTot[t]$(t.val > %AgeData_t1%).. vtAktieHh[aTot,t] =E= sum(a, vtAktieHh[a,t] * nPop[a,t]); # Bemærk at afdøde ikke betaler aktieskat
    E_vHhAktieInd[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vHhAktieInd[a,t] =E= rRealiseringAktieOmv[a,t] * vUrealiseretAktieOmv[a,t] / (1 - rRealiseringAktieOmv[a,t])
                         + (rRente['IndlAktier',t] + jrHhAktRenter['IndlAktier',t]) 
                            * vHhAkt['IndlAktier',a-1,t-1]/fv * fMigration[a,t]
                         + (rRente['UdlAktier',t] + jrHhAktRenter['UdlAktier',t]) 
                           * vHhAkt['UdlAktier',a-1,t-1]/fv * fMigration[a,t];
    # De dødes aktieindkomst indgår ikke her, men går til arv og bliver dødsbosbeskattet
    E_vHhAktieInd_aTot[t]$(t.val > %AgeData_t1%)..
      vHhAktieInd[aTot,t] =E= sum(a, vHhAktieInd[a,t] * nPop[a,t]);

    # De dødes aktier realiseres 100 pct. og er ikke med her, men indgår i dødsboskat
    E_vUrealiseretAktieOmv[a,t]$(a.val > 0 and t.val > %AgeData_t1%+1)..
      vUrealiseretAktieOmv[a,t] =E= (1 - rRealiseringAktieOmv[a,t])
                                      * (vUrealiseretAktieOmv[a-1,t-1]/fv * fMigration[a,t]
                                         + (rOmv['IndlAktier',t] + jrHhAktOmv['IndlAktier',t]) 
                                           * vHhAkt['IndlAktier',a-1,t-1]/fv * fMigration[a,t]
                                         + (rOmv['UdlAktier',t] + jrHhAktOmv['UdlAktier',t]) 
                                           * vHhAkt['UdlAktier',a-1,t-1]/fv * fMigration[a,t]);
    E_vUrealiseretAktieOmvTot[t]$(t.val > %AgeData_t1%)..
      vUrealiseretAktieOmv[aTot,t] =E= sum(a, vUrealiseretAktieOmv[a,t] * nPop[a,t]);

    E_vtTop[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vtTop[a,t] =E= tTop[t] * (vPersInd[a,t] + vNetKapIndPos[a,t]) * rTopSkatInd[a,t];
    #  Når der er 2026-data og top-top-skatten er indført skal ovenstående ligning skiftes ud med nedenstående
    #  E_vtTop[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
    #    vtTop[a,t] =E= tTop[t] * (vPersIndx[a,t] + vNetKapIndPos[a,t]) * rTopSkatInd[a,t];
    E_vtTop_aTot[t]$(t.val > %AgeData_t1%).. vtTop[aTot,t] =E= sum(a, vtTop[a,t] * nPop[a,t]);
    E_rTopSkatInd[a,t]$(t.val > %AgeData_t1% and a15t100[a])..
      rTopSkatInd[a,t] =E= rTopSkatInd_a[a,t] + rTopSkatInd_t[t];

    E_vtMellem[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vtMellem[a,t] =E= tMellem[t] * (vPersInd[a,t] + vNetKapIndPos[a,t]) * rMellemSkatInd[a,t];
    E_vtMellem_aTot[t]$(t.val > %AgeData_t1% and t.val >= 2026).. vtMellem[aTot,t] =E= sum(a, vtMellem[a,t] * nPop[a,t]);
    E_rMellemSkatInd[a,t]$(t.val > %AgeData_t1% and a15t100[a] and t.val >= 2026)..
      rMellemSkatInd[a,t] =E= rMellemSkatInd_a[a,t] # Vi benytter aldersfordelingen for top-skatten indtil vi har data for aldersfordelt mellemskat
                            + rMellemSkatInd_t[t];

    E_vtTopTop[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vtTopTop[a,t] =E= tTopTop[t] * (vPersInd[a,t] + vNetKapIndPos[a,t]) * rTopTopSkatInd[a,t];
    E_vtTopTop_aTot[t]$(t.val > %AgeData_t1% and t.val >= 2026).. vtTopTop[aTot,t] =E= sum(a, vtTopTop[a,t] * nPop[a,t]);
    E_rTopTopSkatInd[a,t]$(t.val > %AgeData_t1% and a15t100[a])..
      rTopTopSkatInd[a,t] =E= rTopTopSkatInd_a[a,t] # Vi benytter aldersfordelingen for top-skatten indtil vi har data for aldersfordelt toptopskat
                            + rTopTopSkatInd_t[t];

    E_vtEjd[a,t]$(a.val >= 18 and t.val > %AgeData_t1%)..
      vtEjd[a,t] =E= tEjd[t] * vBolig[a-1,t-1]/fv * fMigration[a,t];

    E_vtVirksomhed[a,t]$(a15t100[a] and t.val > %NettoFin_t1%)..
      vtVirksomhed[a,t] =E= tSelskab[t] * ftVirksomhed[t] * vEBT[sTot,t] * vWHh[a,t] / vWHh[aTot,t];

    # Dødsboskat er aktieafkastskat og skat på positiv nettokapitalindkomst (100 pct. af deres urealiserede aktier beskattes)
    E_vtDoedsbo[a,t]$(a0t100[a] and t.val > %AgeData_t1%)..
      vtDoedsbo[a,t] =E= tDoedsbo[t]
                         * (vUrealiseretAktieOmv[a,t]
                            + (rRente['IndlAktier',t] + jrHhAktRenter['IndlAktier',t]) * vHhAkt['IndlAktier',a-1,t-1]/fv 
                            + (rRente['UdlAktier',t] + jrHhAktRenter['UdlAktier',t]) * vHhAkt['UdlAktier',a-1,t-1]/fv 
                            + vNetKapIndPos[a,t] / fMigration[a,t]
                            );
    E_vtDoedsbo_tot[t]$(t.val > %AgeData_t1%)..
      vtDoedsbo[aTot,t] =E= sum(a$(a0t100[a]), vtDoedsbo[a,t] * (1-rOverlev[a-1,t-1]) * nPop[a-1,t-1]);

# ----------------------------------------------------------------------------------------------------------------------
#   Andre direkte skatter
# ----------------------------------------------------------------------------------------------------------------------
    # Andre direkte skatter   
    E_vtHhAM[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vtHhAM[a,t] =E= tAMbidrag[t] * ftAMBidrag[t] * vWHh[a,t] * (vWHh[aTot,t] - vBidragTjmp[t]) / vWHh[aTot,t];

    E_vtHhVaegt[a,t]$(a18t100[a] and t.val > %AgeData_t1%)..
      vtHhVaegt[a,t] =E= utHhVaegt[t] * pnCPI[cTot,t-1]/fp * qBiler[t-1]/fq * qCx[a,t] / qC['Cx',t];

    E_vtPersRest[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vtPersRest[a,t] =E= vtPersRestPens[a,t] + tPersRestx[t] * vPersInd[a,t];

    E_vtPersRestPens[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vtPersRestPens[a,t] =E= tKapPens[t] * vHhPensUdb['Kap',a,t]
                            + tTidligPensUdb[t] * vHhPensUdb['PensX',a,t] * rTidligPensUdb[t];

    E_vtPersRestPensArv[a,t]$(a.val >= 15 and t.val > %AgeData_t1%)..
      vtPersRestPensArv[a,t] =E= tKapPens[t] * vPensArv['Kap',a,t]
                               + tTidligPensUdb[t] * vPensArv['PensX',a,t] * rTidligPensUdb[t];

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
      vPersIndx[a,t] =E= vWHh[a,t]
                       + vOvfSkatPl[a,t]
                       + vHhPensUdb['PensX',a,t]
                       # Nedenstående led er en forsimpling - her betales skat af livsforsikring - i virkeligheden er forsikringselementet af pension ikke fradragsberettiget - vi bør ændre modelleringen og have data særskilt data for forsikring
                       + rArv[a,t] * vPensArv['PensX',aTot,t] / nPop[aTot,t] 
                       - (vHhPensIndb['PensX',a,t] - vPensIndbOP[a,t]) #Indbetalinger til obligatorisk opsparing trækkes ud for at undgå at tælle fradrag dobbelt, da den obligatoriske opsparing bliver lagt på en ikke-skattepligtig overførsel (i stedet for de overførsler de vedrører fx arbejdsløshedsdagpenge)
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

    E_vPersIndRest[a,t]$(a15t100[a] and t.val > %AgeData_t1%).. vPersIndRest[a,t] =E= (uPersIndRest_a[a,t] + uPersIndRest_t[t]) * vLoenIndeks[t];

    # vPersIndRest[aTot,t] vil ikke være lig sum(a, vPersIndRest[a,t] * nPop[a,t]), da de 0-14-åriges personindkomst ikke beregnes og vi ikke ønsker at korrigere for dette i totalen
    E_vPersInd_tot[t]$(t.val > %AgeData_t1%).. vPersInd[aTot,t] =E= sum(a, vPersInd[a,t] * nPop[a,t]);

    # Rentefradrag
    E_vKapIndPos[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vKapIndPos[a,t] =E= vHhAkt['Obl',a-1,t-1]/fv * fMigration[a,t]
                          * (rRente['Obl',t] + jrvKapIndPos_a[a,t] + jrvKapIndPos_t[t])
                        + (vHhAkt['Bank',a-1,t-1]/fv * fMigration[a,t] 
                           * (rRente['Bank',t] - rHhAktOmk['Bank',t] + jrvKapIndPos_a[a,t] + jrvKapIndPos_t[t]));
    E_vKapIndPos_aTot[t]$(t.val > %AgeData_t1%)..
      vKapIndPos[aTot,t] =E= sum(a, vKapIndPos[a,t] * nPop[a,t]);

    E_vKapIndNeg[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vKapIndNeg[a,t] =E= sum(portf, vHhPas[portf,a-1,t-1]/fv * fMigration[a,t] 
                                     * (rRente[portf,t] + rHhPasOmk[portf,t] + jrvKapIndNeg_a[a,t] + jrvKapIndNeg_t[t]));
    E_vKapIndNeg_aTot[t]$(t.val > %AgeData_t1%)..
      vKapIndNeg[aTot,t] =E= sum(a, vKapIndNeg[a,t] * nPop[a,t]);

    E_vNetKapInd[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vNetKapInd[a,t] =E= vKapIndPos[a,t] - vKapIndNeg[a,t];
    E_rNet2KapIndPos[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      rNet2KapIndPos[a,t] =E= rNet2KapIndPos_a[a,t] * frNet2KapIndPos_t[t];

    E_vNetKapIndPos[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vNetKapIndPos[a,t] =E= rNet2KapIndPos[a,t] * vKapIndPos[a,t];
    E_vNetKapIndPos_aTot[t]$(t.val > %AgeData_t1%)..
      vNetKapIndPos[aTot,t] =E= sum(a, vNetKapIndPos[a,t] * nPop[a,t]);
    E_vNetKapIndNeg[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vNetKapIndNeg[a,t] =E= vNetKapIndPos[a,t] - vNetKapInd[a,t];

    # Fradrag
    E_vPersFradrag[a,t]$(a15t100[a] and t.val > %AgeData_t1%)..
      vPersFradrag[a,t] =E= vLoenIndeks[t] * (uvPersFradrag_a[a,t] + uvPersFradrag_t[t]);
    E_vPersFradrag_aTot[t]$(t.val > %AgeData_t1%).. vPersFradrag[aTot,t] =E= sum(a, vPersFradrag[a,t] * nPop[a,t]);

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
    E_vtLukning[a,t]$(a18t100[a] and t.val > %AgeData_t1%)..
      vtLukning[a,t] =E= tLukning[t] * (vtHhx[a,t] - vtLukning[a,t]);
  $ENDBLOCK

  MODEL M_GovRevenues /
    B_GovRevenues_static
    # B_GovRevenues_forwardlooking
    B_GovRevenues_a
  /;


  $GROUP G_GovRevenues_static
    G_GovRevenues_endo
    -G_GovRevenues_endo_a
  ;

$ENDIF

$IF %stage% == "exogenous_values":
# ======================================================================================================================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_GovRevenues_makrobk
    # Direkte skatter
    vtDirekte, vtBund$(aTot[a_]), vtTop$(aTot[a_]), vtMellem$(aTot[a_]), vtTopTop$(aTot[a_]), 
    vtKommune$(aTot[a_]), vtEjd$(aTot[a_]), vtAktie, vtAktieHh$(aTot[a_]),
    vtAktieUdl, vUdlUdbytteDirekte, #vUdlUdbyttePortf # Tal stemmer ikke eksakt
    vtVirksomhed$(aTot[a_]), vtDoedsbo$(aTot[a_]), vtHhAM$(aTot[a_]), vtSelskab$(sTot[s_] or udv[s_]), vtPAL, vtMedie, 
    vtPersRest$(aTot[a_]), vtPersRestPens$(aTot[a_]), vtHhVaegt$(aTot[a_])
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
    vtAfgEU
    vtEU
    vHhAktieInd$(aTot[a_])
  ;
  @load(G_GovRevenues_makrobk, "../Data/Makrobk/makrobk.gdx" )

  # Aldersfordelt data fra aldersprofiler indlæses
  $GROUP G_GovRevenues_aldersprofiler
    vtBund$(a[a_]), vtKommune$(a[a_]), vtTop$(a[a_]) # Når vi har data for vtMellem og vtTopTop skal de indlæses her!
    vPersInd$(a[a_]), vKapIndNeg$(a[a_]), vKapIndPos$(a[a_]), vNetKapInd$(a[a_])
    vNetKapIndPos$(a[a_]), vPersFradrag$(a[a_] or aTot[a_])
    vtAktieHh$(a[a_])
    vHhAktieInd
  ;
  $GROUP G_GovRevenues_aldersprofiler
    G_GovRevenues_aldersprofiler$(t.val >= %AgeData_t1%)
    vNetKapIndPos$(aTot[a_]) # Læses midlertdigt ind herfra
  ;
  @load(G_GovRevenues_aldersprofiler, "../Data/Aldersprofiler/aldersprofiler.gdx" )

  # Aldersfordelt data fra BFR indlæses
  $GROUP G_GovRevenues_BFR
    mtInd
  ;
  @load(G_GovRevenues_BFR, "../Data/Befolkningsregnskab/BFR.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_GovRevenues_data
    G_GovRevenues_makrobk
    vNetKapIndPos$(a[a_] and tAgeData[t]), vNetKapIndPos$(aTot[a_])
  ; 
  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_GovRevenues_data_imprecise  # Variables covered by data
    vtIndirekte
    vtEU # Små afrundinger i ADAM
    tBund$(t.val = 2017)
    tTop$(t.val = 2017)
    tKommune$(t.val = 2017)
    vBidragOblRest
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  # Skattesatser fra skm, vægt på 0.75 til den høje skattesats (baseret på tal for gns. skattesats fra SKM)
  mtHhAktAfk.l['IndlAktier',t]$(t.val>=2012) = 0.25 * 0.27 + 0.75 * 0.42; 
  mtHhAktAfk.l['IndlAktier',t]$(t.val>=2010 and t.val<2012) = 0.25 * 0.27 + 0.75 * 0.43; 
  mtHhAktAfk.l['IndlAktier',t]$(t.val>=2001 and t.val<2010) = 0.25 * 0.28 + 0.75 * 0.43; 
  mtHhAktAfk.l['IndlAktier',t]$(t.val>=2000 and t.val<2001) = 0.25 * 0.25 + 0.75 * 0.40; 
  mtHhAktAfk.l['UdlAktier',t] = mtHhAktAfk.l['IndlAktier',t];

  # Initial skøn - skal datadækkes
  mrNet2KapIndPos.l[t] = 0.5;
  rtMellemRenter.l[t] = 0;
  rtTopRenter.l[t] = 0.5;
  rtTopTopRenter.l[t] = 0;

  # Skattesatser for aktier sættes direkte her. Bør rykkes til databank på sigt.
  # Bemærk at der i 2008 og 2009 var en yderligere "mellemste sats"
  # Kilde: https://skm.dk/tal-og-metode/satser/tidsserier/centrale-skattesatser-i-skattelovgivningen-2025
  tAktieTop.l[t]$(t.val >= 1988) = 0.45; # Der er provenuer i 1988-1990, selvom skatten ikke blev indført før 1991!
  tAktieTop.l[t]$(t.val >= 1991) = 0.45;
  tAktieTop.l[t]$(t.val >= 1993) = 0.40;
  tAktieTop.l[t]$(t.val = 2000) = 0.45; # Sum af "Aktieafkastsats" og Aktieindkomstskat over progressionsgrænse
  tAktieTop.l[t]$(t.val >= 2001) = 0.43;
  tAktieTop.l[t]$(t.val >= 2008) = 0.45;
  tAktieTop.l[t]$(t.val >= 2010) = 0.42;

  tAktieLav.l[t]$(t.val >= 1991) = 0.30;
  tAktieLav.l[t]$(t.val >= 1996) = 0.25;
  tAktieLav.l[t]$(t.val >= 2001) = 0.28;
  tAktieLav.l[t]$(t.val >= 2012) = 0.27;

  tTidligPensUdb.l[t] = 0.6;  # Skal datadækkes historisk

  frNet2KapIndPos_t.l[t] = 1;
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":

  $GROUP G_GovRevenues_static_calibration_base
    G_GovRevenues_endo
  # Primære indtægter
    utHhVaegt, -vtHhVaegt[aTot,t]
    tEjd, -vtEjd[aTot,t]
    ftVirksomhed$(t.val > 1986), -vtVirksomhed[aTot,t]
    tDoedsbo$(t.val > %AgeData_t1%), -vtDoedsbo[aTot,t]
    tPersRestx, -vtPersRest[aTot,t]
    rTidligPensUdb, -vtPersRestPens[aTot,t]
    ftSelskab, -vtSelskab[sTot,t]
    vtSelskabRest[udv,t], -vtSelskab[udv,t]
    jvtKilde, -vtKilde
    jvtDirekte, -vtDirekte
  # Indkomster og fradrag
    tBeskFradrag$(t.val > 2003), -vBeskFradrag[aTot,t]
    jfvSkatteplInd, -vSkatteplInd[aTot,t]
  # Primære indtægter
    ftAktieUdl$(t.val >= 2005), -vtAktieUdl[t]
    rUdlUdbytteDirekte, -vUdlUdbytteDirekte[t]
    jvtPAL$(t.val > %cal_start%), -vtPAL
    utMedie$(t.val > 1990), -vtMedie
    rvtAfgEU2vtAfg, -vtAfgEU  
    tJordrenteRest, -vJordrente  
    tKulbrinte, -vtKulbrinte  
    uBidragOblTjm$(t.val >= %BFR_t1%), -vBidragOblTjm
    uBidragATP$(t.val >= %BFR_t1%), -vBidragATP
    uBidragOblRest$(t.val >= %BFR_t1%), -vBidragOblRest
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
  ;
  $GROUP G_GovRevenues_static_calibration_newdata
    G_GovRevenues_static_calibration_base
    - G_GovRevenues_endo_a
    # Beregninger af led som er endogene i aldersdel (skal være uændret, når de beregnes endogent)
    -vPersFradrag[aTot,t], uvPersFradrag_t
    -vtBund[aTot,t], ftBund[aTot,t]
    -vtAktieHh[aTot,t], ftAktieHh[aTot,t]
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
    rNet2KapIndPos_a[a,t]$(a15t100[a] and t.val > %AgeData_t1%), -vNetKapIndPos[a,t]$(a15t100[a] and t.val > %AgeData_t1%)
    rNet2KapIndPos[aTot,t]$(t.val <= %AgeData_t1%), -vNetKapIndPos[aTot,t]$(t.val <= %AgeData_t1%)

    mtIndRest, -mtInd
    mtHhAktAfkRest[IndlAktier,t], -mtHhAktAfk[IndlAktier,t]
    mtHhAktAfkRest[UdlAktier,t], -mtHhAktAfk[UdlAktier,t]
    rRealiseringAktieOmv_a[a,t]$(a15t100[a] and t.val > %AgeData_t1%), -vHhAktieInd[a,t]$(a15t100[a] and t.val > %AgeData_t1%)
    ftAktieHh_a$(t.val > %AgeData_t1% and a15t100[a]), -vtAktieHh$(t.val > %AgeData_t1% and a15t100[a_])
    vUrealiseretAktieOmv[a,t]$(t.val = %AgeData_t1%+1 and aVal[a] > 1) # E_vUrealiseretAktieOmv_t2
  ;
  $GROUP G_GovRevenues_static_calibration
    G_GovRevenues_static_calibration$(tx0[t])
  ;

  $BLOCK B_GovRevenues_static_calibration$(tx0[t])
    E_jrvKapIndNeg_t_AgeData[t]$(t.val > %AgeData_t1%)..
      jrvKapIndNeg_a[aTot,t] =E= 0;
    E_jrvKapIndPos_t_AgeData[t]$(t.val > %AgeData_t1%)..
      jrvKapIndPos_a[aTot,t] =E= 0;

    # Vi antager initialt et forhold mellem urealiserede omvurderinger og aktieformue, omtrent svarende til det langsigtede niveau
    E_vUrealiseretAktieOmv_t2[a,t]$(t.val = %AgeData_t1%+1 and a.val > 1)..
      vUrealiseretAktieOmv[a,t] =E= 0.45 * (vHhAkt['IndlAktier',a-1,t-1] + vHhAkt['UdlAktier',a-1,t-1]);
  $ENDBLOCK

  MODEL M_GovRevenues_static_calibration /
    M_GovRevenues
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
    -uRestFradrag, vRestFradragSats
  ;
  $GROUP G_GovRevenues_deep G_GovRevenues_deep$(tx0[t]);
  # $BLOCK B_GovRevenues_deep
  # $ENDBLOCK
  MODEL M_GovRevenues_deep /
    M_GovRevenues 
    # B_GovRevenues_deep
  /;
$ENDIF

# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
$GROUP G_GovRevenues_dynamic_calibration
  G_GovRevenues_endo

  -rOffFraUdlKap2BNP, vOffFraUdlKap[tx0]
  -rOffFraUdlEU2BNP, vOffFraUdlEU[tx0] 
  -rOffFraUdlRest2BNP, vOffFraUdlRest[tx0]
  -rOffFraHh2BNP, vOffFraHh[tx0]
  -rOffFraVirk2BNP, vOffFraVirk[tx0]
  -rOffVirk2BNP, vOffVirk[tx0]

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
  -vNetKapIndPos[aTot,t1], frNet2KapIndPos_t[t1]
  -vtSelskab[sTot,t1], ftSelskab[t1]

  # Disse er kalibreret i static, men skal re-kalibreres pga. ændringer i aldersfordeling
  ftKirke[t1], -vtKirke[aTot,t1]
  tPersRestx[t1], -vtPersRest[aTot,t1]
  ftAktieHh_t[t1], -vtAktieHh[aTot,t1]
  rRealiseringAktieOmv_t[t1], -vHhAktieInd[aTot,t1]

  # vtArv skal kalibreres dynamisk
  -vtArv[aTot,t1], tArv[t1]
  tDoedsbo[t1], -vtDoedsbo[aTot,t1] # Skal genkalibreres med arv
;
MODEL M_GovRevenues_dynamic_calibration /
  M_GovRevenues
/;
$ENDIF
