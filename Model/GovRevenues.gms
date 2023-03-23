# ======================================================================================================================
# Government revenues
# - See also taxes module
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_GovRevenues_prices_endo empty_group_dummy[t];
  $GROUP G_GovRevenues_quantities_endo empty_group_dummy[t];

  $GROUP G_GovRevenues_values_endo_a
    vtBund[a_,t]$(a15t100[a_] and t.val > 2015) "Bundskatter, Kilde: ADAM[Ssysp1]"
    vtTop[a_,t]$(a15t100[a_] and t.val > 2015) "Topskatter, Kilde: ADAM[Ssysp2]+ADAM[Ssysp3]"
    vtKommune[a_,t]$(a15t100[a_] and t.val > 2015) "Kommunal indkomstskatter, Kilde: ADAM[Ssys1]+ADAM[Ssys2]"
    vtEjd[a_,t]$((aVal[a_] >= 18) and t.val > 2015) "Ejendomsværdibeskatning, Kilde: ADAM[Spzej]"
    vtAktie[a_,t]$(a0t100[a_] and t.val > 2015) "Aktieskat, Kilde: ADAM[Ssya]"
    vtVirksomhed[a_,t]$(a15t100[a_] and t.val > 2015) "Virksomhedsskat, Kilde: ADAM[Ssyv]"
    vtDoedsbo[a_,t]$(a[a_] and t.val > 2015) "Dødsboskat, Kilde: ADAM[Ssyd]"
    vtHhAM[a_,t]$(a15t100[a_] and t.val > 2015) "Arbejdsmarkedsbidrag betalt af husholdningerne, Kilde: ADAM[Sya]"
    vtPersRest[a_,t]$(a15t100[a_] and t.val > 2015) "Andre personlige indkomstskatter, Kilde: ADAM[Syp]"
    vtKapPens[a_,t]$(a15t100[a_] and t.val > 2015) "Andre personlige indkomstskatter fratrukket andre personlige indkomstskatter resterende, ADAM[Syp]-ADAM[Sypr]"
    vtKapPensArv[a_,t]$(aVal[a_] >= 15 and t.val > 2015) "Kapitalskatter betalt i forbindelse med dødsfald og arv - ikke-datadækket hjælpevariabel."
    vtHhVaegt[a_,t]$((a18t100[a_]) and t.val > 2015) "Vægtafgifter fra husholdningerne, Kilde: ADAM[Syv]"
    vtLukning[a_,t]$(a0t100[a_] and t.val > 2015) "Beregningsteknisk skat til lukning af offentlig budgetrestriktion på lang sigt (HBI=0). Indgår IKKE i offentlig saldo."
    vtArv[a_,t]$(t.val > 2015) "Kapitalskatter (Arveafgift), Kilde: ADAM[sK_h_o] for total."
    vBidrag[a_,t]$((a15t100[a_] and t.val > 2015)) "Bidrag til sociale ordninger, Kilde: ADAM[Tp_h_o]"
    vtKirke[a_,t]$(a15t100[a_] and t.val > 2015) "Kirkeskat, Kilde: ADAM[Trks]"
    # Indkomstbegreber og fradrag 
    vPersInd[a_,t]$(a15t100[a_] and t.val > 2015) "Personlig indkomst, Kilde: ADAM[Ysp]"
    vPersIndRest[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Aggregeret restled til personindkomst."
    vSkatteplInd[a_,t]$(a15t100[a_] and t.val > 2015) "Skattepligtig indkomst, Kilde: ADAM[Ys]"
    vNetKapIndPos[a_,t]$((a15t100[a_] and t.val > 2015 )) "Positiv nettokapitalindkomst."
    vNetKapInd[a_,t]$((a15t100[a_] and t.val > 2015 )) "Nettokapitalindkomst, Kilde: ADAM[Tippps]"
    vKapIndPos[a_,t]$(a15t100[a_] and t.val > 2015) "Imputeret positiv kapitalindkomst."
    vKapIndNeg[a_,t]$(a15t100[a_] and t.val > 2015) "Imputeret negativ kapitalinkomst."
    vPersFradrag[a_,t]$(a15t100[a_] and t.val > 2015) "Imputeret personfradrag."
    vAKFradrag[a_,t]$(a15t100[a_] and t.val > 2015) "Imputeret fradrag for A-kassebidrag."
    vELFradrag[a_,t]$(a15t100[a_] and t.val > 2015) "Imputeret fradrag for efterlønsbidrag."
    vRestFradrag[a_,t]$(a15t100[a_] and t.val > 2015) "Imputerede øvrige ligningsmæssige fradrag (befordringsfradrag m.m.)"
    vBeskFradrag[a_,t]$(a15t100[a_] and t.val > 2015) "Imputeret beskæftigelsesfradrag."
    vRealiseretAktieOmv[a_,t]$(a[a_] and t.val > 2015) "Skøn over realiserede gevinst ved salg af aktier."
  ;

  $GROUP G_GovRevenues_values_endo
    G_GovRevenues_values_endo_a
  
    # Primære indtægter
    vOffPrimInd[t] "Primære offentlige indtægter, Kilde: ADAM[Tf_z_o]-ADAM[Tioii]"
    vtY[s_,t]$(sTot[s_] or s[s_]) "Produktionsskatter, brutto, Kilde: ADAM[Spz]-ADAM[Spzu] og imputeret branchefordeling"
    vtYRest[s_,t]$(sTot[s_] or s[s_]) "Øvrige produktionsskatter."

    # Direkte skatter
    vtDirekte[t] "Direkte skatter, Kilde: ADAM[Sy_o]"
    vtKilde[t] "Kildeskatter, Kilde: ADAM[Syk]"
    vtBund[a_,t]$(aTot[a_] and t.val > 2015) "Bundskatter, Kilde: ADAM[Ssysp1]"
    vtTop[a_,t]$(aTot[a_] and t.val > 2015) "Topskatter, Kilde: ADAM[Ssysp2]+ADAM[Ssysp3]"
    vtKommune[a_,t]$(aTot[a_] and t.val > 2015) "Kommunal indkomstskatter, Kilde: ADAM[Ssys1]+ADAM[Ssys2]"
    vtEjd[a_,t]$(aTot[a_] and t.val > 2015) "Ejendomsværdibeskatning, Kilde: ADAM[Spzej]"
    vtAktie[a_,t]$(aTot[a_] and t.val > 1994) "Aktieskat, Kilde: ADAM[Ssya]"
    vtVirksomhed[a_,t]$(aTot[a_] and t.val > 1986) "Virksomhedsskat, Kilde: ADAM[Ssyv]"
    vtDoedsbo[a_,t]$(aTot[a_] and t.val > 2015) "Dødsboskat, Kilde: ADAM[Ssyd]"
    vtHhAM[a_,t]$(aTot[a_] and t.val >= 1994) "Arbejdsmarkedsbidrag betalt af husholdningerne, Kilde: ADAM[Sya]"
    vtPersRest[a_,t]$(aTot[a_] and t.val >= 1994) "Andre personlige indkomstskatter, Kilde: ADAM[Syp]"
    vtKapPens[a_,t]$(aTot[a_] and t.val >= 1994) "Andre personlige indkomstskatter fratrukket andre personlige indkomstskatter resterende, ADAM[Syp]-ADAM[Sypr]"
    vtKapPensArv[a_,t]$(aTot[a_] and t.val > 2015) "Kapitalskatter betalt i forbindelse med dødsfald og arv - ikke-datadækket hjælpevariabel."
    vtSelskab[s_,t] "Selskabsskat, Kilde: ADAM[Syc]"
    vtSelskabxNord[s_,t] "Selskabsskat eksklusiv selskabsskat fra Nordsøen, Kilde: ADAM[Syc]-ADAM[Syc_e]"
    vtSelskabNord[t]$(t.val > 1990) "Selskabsskat fra Nordsøen, Kilde: ADAM[Syc_e]"
    vtPAL[t] "PAL skat, Kilde: ADAM[Sywp]"
    vtMedie[t]$(t.val > 1990) "Medielicens, Kilde: ADAM[Sym]"
    vtHhVaegt[a_,t]$(aTot[a_]) "Vægtafgifter fra husholdningerne, Kilde: ADAM[Syv]"
    vtAfgEU[t] "Produktafgifter til EU, Kilde: ADAM[Sppteu]"

      # Indrekte skatter
    vtIndirekte[t] "Indirekte skatter, Kilde: ADAM[Spt_o]"
    vtEU[t] "Indirekte skatter til EU, Kilde: ADAM[Spteu]"

    # Øvrige offentlige indtægter
    vBidrag[a_,t]$(aTot[a_]) "Bidrag til sociale ordninger, Kilde: ADAM[Tp_h_o]"
    vBidragAK[t]$(tBFR[t]) "A-kassebidrag, Kilde: ADAM[Tpaf]"
    vBidragEL[t]$(tBFR[t]) "Efterlønsbidrag, Kilde: ADAM[Tpef]"
    vBidragFri[t]$(tBFR[t]) "Øvrige frivillige bidrag, Kilde: ADAM[Tpr]"
    vBidragObl[t]$(tBFR[t]) "Obligatoriske bidrag, Kilde: ADAM[Stp_o]"
    vBidragOblTjm[t]$(tBFR[t]) "Obligatoriske sociale bidrag vedr. tjenestemænd, Kilde: ADAM[Stpt]"
    vBidragATP[t]$(tBFR[t]) "Sociale bidrag til ATP, særlig ATP ordning og lønmodtagernes garantifond, Kilde: ADAM[Saqw]"
    vBidragOblRest[t]$(tBFR[t]) "Øvrige obligatoriske bidrag til sociale ordninger, Kilde: ADAM[Sasr]"
    vBidragTjmp[t]$(tBFR[t]) "Bidrag til Tjenestemandspension, Kilde: ADAM[Tpt_o]"

    vOffIndRest[t] "Andre offentlige indtægter."
    vtKirke[a_,t]$(aTot[a_] and t.val > 2015) "Kirkeskat, Kilde: ADAM[Trks]"
    vJordrente[t] "Off. indtægter af jord og rettigheder, Kilde: ADAM[Tirn_o]"

    # Indkomstbegreber og fradrag 
    vPersInd[a_,t]$(aTot[a_] and t.val > 2015) "Personlig indkomst, Kilde: ADAM[Ysp]"
    vSkatteplInd[a_,t]$(aTot[a_]) "Skattepligtig indkomst, Kilde: ADAM[Ys]"
    vNetKapIndPos[a_,t]$(aTot[a_]) "Positiv nettokapitalindkomst."
    vNetKapInd[a_,t]$(aTot[a_]) "Nettokapitalindkomst, Kilde: ADAM[Tippps]"
    vKapIndPos[a_,t]$(aTot[a_] and t.val > 2015) "Imputeret positiv kapitalindkomst."
    vKapIndNeg[a_,t]$(aTot[a_] and t.val > 2015) "Imputeret negativ kapitalinkomst."
    vPersFradrag[a_,t]$(aTot[a_] and t.val >= 2015) "Imputeret personfradrag."
    vAKFradrag[a_,t]$(aTot[a_] and t.val >= 1994) "Imputeret fradrag for A-kassebidrag."
    vELFradrag[a_,t]$(aTot[a_] and t.val > 1998) "Imputeret fradrag for efterlønsbidrag."
    vRestFradrag[a_,t]$(aTot[a_]) "Imputerede øvrige ligningsmæssige fradrag (befordringsfradrag m.m.)"
    vBeskFradrag[a_,t]$(aTot[a_] and t.val > 2003) "Imputeret beskæftigelsesfradrag."
    vRealiseretAktieOmv[a_,t]$(aTot[a_]) "Skøn over realiserede gevinst ved salg af aktier."
    vUrealiseretAktieOmv[t]$(tx0[t]) "Skøn over endnu ikke realiserede kapitalgevinster på aktier."
  ;

  $GROUP G_GovRevenues_endo_a
    G_GovRevenues_values_endo_a

    ftBund[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Korrektionsfaktor fra faktisk til implicit skattesats."
    ftKommune[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Korrektionsfaktor fra faktisk til implicit skattesats."
    rTopSkatInd[a_,t]$(t.val > 2015) "Imputeret gennemsnitlig del af indkomsten over topskattegrænsen."
    ftAktie[t]$(t.val > 2015) "parameter til at fange sammensætningseffekt."
    fvtDoedsbo[t]$(t.val > 2015) "parameter til at fange sammensætningseffekt."
    uvPersFradrag_a[a_,t]$(aTot[a_] and t.val > 2015) "Aldersfordelt imputeret personfradrag ekskl. regulering"
    mtInd[a_,t]$(t.val > 2015 and a[a_]) "Marginal (ekstensiv margin) gennemsnitlig skattesats på lønindkomst."
    fvKapIndPos[a_,t]$(t.val > 2015) "Aggregeret aldersfordelt additivt j-led fra formuefordeling og dødssandsynlighed"
    fvKapIndNeg[a_,t]$(t.val > 2015) "Aggregeret aldersfordelt additivt j-led fra formuefordeling og dødssandsynlighed"
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
    tYRest[s_,t]$(sTot[s_]) "Øvrige produktionsskatter."
    rtKilde2Loensum[t] "Samlede kildeskatter som andel af lønsum."
  ;
  $GROUP G_GovRevenues_endo 
    G_GovRevenues_endo$(tx0[t]) # Restrict endo group to tx0[t]

    #  Nutidsværdi af offentlige indtægter - Beregnes i post modellen
    nvOffPrimInd[t]$(tHBI.val <= t.val and t.val <= tEnd.val) "Nutidsværdi af samlede offentlige indtægter."
    nvtDirekte[t]$(tHBI.val <= t.val and t.val <= tEnd.val) "Nutidsværdi af direkte skatter"
    nvtIndirekte[t]$(tHBI.val <= t.val and t.val <= tEnd.val) "Nutidsværdi af inddirekte skatter"
    nvOffIndRest[t]$(tHBI.val <= t.val and t.val <= tEnd.val) "Nutidsværdi af andre offentlige indtægter"
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
    vtKildeRest[t] "Restled."
    vtDirekteRest[t] "Restled."
    vtHhVaegtSats[t] "Implicit vægtafgift-sats."
    vOffFraUdlKap[t] "Kapitaloverførsler fra udlandet, Kilde: ADAM[tK_e_o]"
    vOffFraUdlEU[t] "Residuale overførsler fra EU, Kilde: ADAM[Tr_eu_o]"
    vOffFraUdlRest[t] "Residuale overførsler fra udlandet ekskl. EU, Kilde: ADAM[Tr_er_o]"
    vOffFraHh[t] "Residuale overførsler fra den private sektor, Kilde: ADAM[Trr_hc_o]"
    vOffFraVirk[t] "Kapitaloverførsler fra den private sektor, Kilde: ADAM[tK_hc_o]"
    vOffVirk[t] "Overskud af offentlig virksomhed, Kilde: ADAM[Tiuo_z_o]"
    vPersIndRest_a[a_,t] "Aldersfordelt restled til personindkomst."
    vPersIndRest_t[t] "Restled til personindkomst, uafhængigt af alder."
    vRestFradragSats[t] "Eksogen del af andre fradrag kalibreret til at ramme makrodata."
  ;

  $GROUP G_GovRevenues_exogenous_forecast
    rvtAktie2BVT[t] "Provenue fra aktieskat som andel af BNP"
    ftSelskab[t] "Korrektionsfaktor fra faktisk til implicit skattesats."
    rtKilde2Loensum[t] "Samlede kildeskatter som andel af lønsum."
  ;
  $GROUP G_GovRevenues_forecast_as_zero
    jvOffPrimInd
    vtKildeRest
    vtDirekteRest
    jfvKapIndPos_a[a,t] "Alders-specifikt j-led i fvKapIndPos."
    jfvKapIndPos_t[t] "Tids-afhængigt j-led i fvKapIndPos."
    jfvKapIndNeg_a[a,t] "Alders-specifikt j-led i fvKapIndNeg."
    jfvKapIndNeg_t[t] "Tids-afhængigt j-led i fvKapIndNeg."

    jfvSkatteplInd[t] "Multiplikativt J-led."
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
  $GROUP G_GovRevenues_other
    tBund[t] "Bundskattesats, Kilde: ADAM[tsysp1]"
    tTop[t] "Topskattesats, Kilde: ADAM[tsysp2]+ADAM[tsysp3]"
    tKommune[t] "Gennemsnitlig kommunal skattesats, Kilde: ADAM[tsys1]+ADAM[tsys2]"
    tAMbidrag[t] "Procentsats for arbejdsmarkedsbidrag."
    tKapPens[t] "Skatterate hvormed kapitalpensioner bliver beskattet ved udbetaling, Kilde: ADAM[tsyp]"
    tSelskab[t] "Selskabsskattesats, Kilde: ADAM[tsyc]"
    tPAL[t] "PAL-skattesats, Kilde: ADAM[tsywp]"
    tKirke[t] "Kirkeskattesats, Kilde: ADAM[tks]"

    tEjd[t] "Implicit skattesats."
    tPersRestxKapPens[t] "Implicit skattesats."
    tSelskabNord[t] "Implicit skattesats."
    tVirksomhed[t] "Implicit skattesats."
    tDoedsbo[t] "Implicit skattesats."
    tAktie[t] "Implicit gennemsnitlig skat på aktieafkast."
    tJordRente[t] "Implicit skattesats."
    tBeskFradrag[t] "Imputeret gennemsnitlig beskæftigelsesfradrag ift. lønindkomst."
    
    ftBund_t[t] "Tids-afhængigt led i ftBund."
    ftBund_a[a,t] "Alders-specifikt led i ftBund."
    ftKommune_t[t] "Tids-afhængigt led i ftKommune."
    ftKommune_a[a,t] "Alders-specifikt led i ftKommune."

    tArv[t] "Arveafgift (implicit, gennemsnit)"
    ftAMBidrag[t] "Korrektionsfaktor fra faktisk til implicit skattesats."
    ftKapPens[t] "Korrektionsfaktor fra faktisk til implicit skattesats."
    ftPAL[t] "Korrektionsfaktor fra faktisk til implicit skattesats."
    ftKirke[t] "Korrektionsfaktor fra faktisk til implicit skattesats."

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

    uvPersFradrag_t[t] "Ikke-aldersfordelt imputeret personfradrag ekskl. regulering"
    rTopSkatInd_t[t] "Tids-afhængigt led i rTopSkatInd."
    rTopSkatInd_a[a,t] "Alders-specifikt led i rTopSkatInd."

    rRealiseringAktieOmv[t] "Andel af omvurderinger på aktier som realiseres hvert år."

    mtIndRest[a,t] "Residual-led i marginal gennemsnitlig skattesats på lønindkomst."
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_GovRevenues_aTot

# ======================================================================================================================
# Primære offentlige indtægter
# ======================================================================================================================
    E_vOffPrimInd[t]$(tx0[t]).. vOffPrimInd[t] =E= vtDirekte[t] + vtIndirekte[t] + vOffIndRest[t];

    # Direkte skatter
    # Kilde: Generelt om skattesystemet
    # http://www.skm.dk/skattetal/beregning/skatteberegning/skatteberegning-hovedtraekkene-i-personbeskatningen-2017
    E_vtDirekte[t]$(tx0[t])..
      vtDirekte[t] =E= vtKilde[t] + vtHhAM[aTot,t] + vtSelskab[sTot,t] + vtPAL[t]
                     + vtHhVaegt[aTot,t] + vtMedie[t] + vtPersRest[aTot,t] + vtDirekteRest[t];

# ----------------------------------------------------------------------------------------------------------------------
#   Kildeskatter
# ----------------------------------------------------------------------------------------------------------------------
    E_vtKilde[t]$(tx0[t])..
      vtKilde[t] =E= vtKommune[aTot,t] + vtBund[aTot,t] + vtAktie[aTot,t] + vtTop[aTot,t] + vtEjd[aTot,t] 
                   + vtVirksomhed[aTot,t] + vtDoedsbo[aTot,t] + vtKildeRest[t];

    E_vtKommune_aTot[t]$(tx0[t] and t.val > 2015)..
      vtKommune[aTot,t] =E= tKommune[t] * ftKommune[aTot,t] * (vSkatteplInd[aTot,t] - vPersFradrag[aTot,t]);

    E_vtBund_aTot[t]$(tx0[t] and t.val > 2015)..
      vtBund[aTot,t] =E= tBund[t] * ftBund[aTot,t] * (vPersInd[aTot,t] + vNetKapIndPos[aTot,t] - vPersFradrag[aTot,t]);

    # Sammensætningseffekt skyldes forskellige dødssandsynligheder og formuer, da kun overlevende betaler aktieskat
    E_vtAktie_aTot[t]$(tx0[t] and t.val > 1994)..
      vtAktie[aTot,t] =E= tAktie[t] * (vRealiseretAktieOmv[aTot,t]
                                     + rRente['IndlAktier',t] * vHh['IndlAktier',aTot,t-1]/fv
                                     + rRente['UdlAktier',t] * vHh['UdlAktier',aTot,t-1]/fv
                                     ) * rOverlev[aTot,t-1] * ftAktie[t];
    E_vRealiseretAktieOmv_aTot[t]$(tx0[ t])..
      vRealiseretAktieOmv[aTot,t] =E= rRealiseringAktieOmv[t] * vUrealiseretAktieOmv[t];
    E_vUrealiseretAktieOmv[t]$(tx0[t])..
      vUrealiseretAktieOmv[t] =E= vUrealiseretAktieOmv[t-1]/fv
                                - vRealiseretAktieOmv[aTot,t]
                                + rOmv['IndlAktier',t] * vHh['IndlAktier',aTot,t-1]/fv
                                + rOmv['UdlAktier',t] * vHh['UdlAktier',aTot,t-1]/fv;

    E_vtTop_aTot[t]$(tx0[t] and t.val > 2015)..
      vtTop[aTot,t] =E= tTop[t] * rTopSkatInd[aTot,t] * (vPersInd[aTot,t] + vNetKapIndPos[aTot,t]);

    E_vtEjd_aTot[t]$(tx0[t] and t.val > 2015).. vtEjd[aTot,t] =E= tEjd[t] * vBolig[aTot,t-1]/fv;    

    E_vtVirksomhed_tot[t]$(tx0[t] and t.val > 1986).. vtVirksomhed[aTot,t] =E= tVirksomhed[t] * vEBT[sTot,t];

    # Sammensætningseffekten er væsentlig, da den aggregerede overlevelses-sandsynlighed er langt fra den gennemsnitlige overlevelses-sandsynlighed vægtet efter formue
    # Udover dette fanger fvtDoedsbo også korrelation mellem overlevelse og formue indenfor en kohorte (rArvKorrektion)
    E_vtDoedsbo_tot[t]$(tx0[t] and t.val > 2015)..
      vtDoedsbo[aTot,t] =E= tDoedsbo[t] * fvtDoedsbo[t] * (1-rOverlev[aTot,t-1])
                          * (vRealiseretAktieOmv[aTot,t] 
                              + rRente['IndlAktier',t] * vHh['IndlAktier',aTot,t-1]/fv 
                              + rRente['UdlAktier',t]  * vHh['UdlAktier',aTot,t-1]/fv  
                              + rNet2KapIndPos[aTot,t] * rRente['Obl',t]  * vHh['Obl',aTot,t-1]/fv
                              + rNet2KapIndPos[aTot,t] * rRente['Bank',t] * vHh['Bank',aTot,t-1]/fv
                            );

# ----------------------------------------------------------------------------------------------------------------------
#   Andre direkte skatter
# ----------------------------------------------------------------------------------------------------------------------
    E_vtHhAM_tot[t]$(tx0[t] and t.val >= 1994)..
      vtHhAM[aTot,t] =E= tAMbidrag[t] * ftAMBidrag[t] * (vWHh[aTot,t] - vBidragTjmp[t]);

    E_vtSelskab_sTot[t]$(tx0[t]).. vtSelskab[sTot,t] =E= vtSelskabxNord[sTot,t] + vtSelskabNord[t];
    E_vtSelskabxNord_sTot[t]$(tx0[t]).. vtSelskabxNord[sTot,t] =E= tSelskab[t] * ftSelskab[t] * vEBT[sTot,t];
    E_vtSelskabNord[t]$(tx0[t] and t.val > 1990)..
      vtSelskabNord[t] =E= (qY['udv',t] - qGrus[t]) / qY['udv',t] * vEBT['udv',t] * tSelskabNord[t];
    E_vtSelskab[sp,t]$(tx0[t])..
      vtSelskab[sp,t] =E= vtSelskabxNord[sp,t] + udv[sp] * vtSelskabNord[t];
    E_vtSelskabxNord[sp,t]$(tx0[t])..
      vtSelskabxNord[sp,t] =E= tSelskab[t] * ftSelskab[t] * vEBT[sp,t];
    
    # Udlændinge betaler også PAL-skat, MEN vtPAl trækkes fra danske husholdninger - hermed betaler de i 1. omgang udlændinges PAL-skat
    # Udlændinges bidrag til PAL-skat kommer via vHhTilUdl
    E_vtPAL[t]$(tx0[t] and t.val > 1983)..
      vtPAL[t] =E= tPAL[t] * ftPAL[t] * (rRente['Pens',t] + rOmv['Pens',t]) * (-vPension['Pens',t-1]/fv);

    E_vtHhVaegt_tot[t]$(tx0[t]).. vtHhVaegt[aTot,t] =E= vtHhVaegtSats[t] * qBiler[t-1]/fq;

    E_vtMedie_tot[t]$(tx0[t] and t.val > 1990).. vtMedie[t] =E= utMedie[t] * vSatsIndeks[t] * nPop['a18t100',t];  

    E_vtPersRest_tot[t]$(tx0[t] and t.val >= 1994)..
      vtPersRest[aTot,t] =E= vtKapPens[aTot,t] 
                           + tPersRestxKapPens[t] * (vHhPensUdb['PensX',aTot,t] - vPensArv['PensX',aTot,t]);
    E_vtKapPens_tot[t]$(tx0[t] and t.val >= 1994)..
      vtKapPens[aTot,t] =E= tKapPens[t] * ftKapPens[t] * vHhPensUdb['Kap',aTot,t];

    E_vtKapPensArv_tot[t]$(tx0[t] and t.val > 2015)..
      vtKapPensArv[aTot,t] =E= tKapPens[t] * ftKapPens[t] * vPensArv['Kap',aTot,t];

# ----------------------------------------------------------------------------------------------------------------------
#   Indirekte skatter
# ----------------------------------------------------------------------------------------------------------------------
    E_vtIndirekte[t]$(tx0[t]).. vtIndirekte[t] =E= vtMoms[dTot,sTot,t]
                                                 + vtAfg[dTot,sTot,t]
                                                 + vtReg[dTot,t]
                                                 + vtY[sTot,t] 
                                                 + vtTold[dTot,sTot,t] - vtEU[t];
    E_vtY[s,t]$(tx0[t])..
        vtY[s,t] =E= vtGrund[s,t] + vtVirkVaegt[s,t] + vtVirkAM[s,t] + vtAUB[s,t] + vtYRest[s,t];
    E_vtY_sTot[t]$(tx0[t])..
        vtY[sTot,t] =E= vtGrund[sTot,t] + vtVirkVaegt[sTot,t] + vtVirkAM[sTot,t] + vtAUB[sTot,t] + vtYRest[sTot,t];

    E_vtYRest[s,t]$(tx0[t]).. vtYRest[s,t] =E= tYRest[s,t] * vBVT[s,t];
    E_vtYRest_sTot[t]$(tx0[t]).. vtYRest[sTot,t] =E= tYRest[sTot,t] * vBVT[sTot,t];
    E_tYRest_sTot[t]$(tx0[t]).. vtYRest[sTot,t] =E= sum(s, vtYRest[s,t]);

    E_vtEU[t]$(tx0[t]).. vtEU[t] =E= vtTold[dTot,sTot,t] + vtAfgEU[t];
    E_vtAfgEU[t]$(tx0[t]).. vtAfgEU[t] =E= rvtAfgEU2vtAfg[t] * vtAfg[dTot,sTot,t];

# ----------------------------------------------------------------------------------------------------------------------
#   Øvrige offentlige indtægter
# ----------------------------------------------------------------------------------------------------------------------
    E_vOffIndRest[t]$(tx0[t])..
      vOffIndRest[t] =E= vtArv[aTot,t] + vOffAfskr[kTot,t] + vBidrag[aTot,t]
                       + vOffFraUdlKap[t] + vOffFraUdlEU[t] + vOffFraUdlRest[t] + vOffFraHh[t] + vOffFraVirk[t]
                       + vtKirke[aTot,t] + vJordrente[t] + vOffVirk[t] + jvOffPrimInd[t];

    # Sociale bidrag
    E_vBidrag_tot[t]$(tx0[t])..
      vBidrag[aTot,t] =E= vBidragAK[t] + vBidragTjmp[t] + vBidragEL[t] + vBidragFri[t] + vBidragObl[t];

    E_vBidragAK[t]$(tx0[t] and tBFR[t])..      vBidragAK[t]      =E= uBidragAK[t]      * vSatsIndeks[t] * nBruttoArbsty[t];
    E_vBidragTjmp[t]$(tx0[t] and tBFR[t])..    vBidragTjmp[t]    =E= uBidragTjmp[t]    * vSatsIndeks[t] * nBruttoArbsty[t];
    E_vBidragEL[t]$(tx0[t] and tBFR[t])..      vBidragEL[t]      =E= uBidragEL[t]      * vSatsIndeks[t] * nBruttoArbsty[t];
    E_vBidragFri[t]$(tx0[t] and tBFR[t])..     vBidragFri[t]     =E= uBidragFri[t]     * vSatsIndeks[t] * nBruttoArbsty[t];
    E_vBidragOblTjm[t]$(tx0[t] and tBFR[t])..  vBidragOblTjm[t]  =E= uBidragOblTjm[t]  * vSatsIndeks[t] * nBruttoArbsty[t];
    E_vBidragATP[t]$(tx0[t] and tBFR[t])..     vBidragATP[t]     =E= uBidragATP[t]     * vSatsIndeks[t] * nBruttoArbsty[t];
    E_vBidragOblRest[t]$(tx0[t] and tBFR[t]).. vBidragOblRest[t] =E= uBidragOblRest[t] * vSatsIndeks[t] * nBruttoArbsty[t];

    E_vBidragObl[t]$(tx0[t] and tBFR[t]).. vBidragObl[t] =E= vBidragOblTjm[t] + vBidragATP[t] + vBidragOblRest[t];

    # Overførsler
    E_vOffFraUdlKap[t]$(tx0[t]).. vOffFraUdlKap[t] =E= rOffFraUdlKap2BNP[t] * vBNP[t];
    E_vOffFraUdlEU[t]$(tx0[t]).. vOffFraUdlEU[t] =E= rOffFraUdlEU2BNP[t] * vBNP[t];
    E_vOffFraUdlRest[t]$(tx0[t]).. vOffFraUdlRest[t] =E= rOffFraUdlRest2BNP[t] * vBNP[t];
    E_vOffFraHh[t]$(tx0[t]).. vOffFraHh[t] =E= rOffFraHh2BNP[t] * vBNP[t];
    E_vOffFraVirk[t]$(tx0[t]).. vOffFraVirk[t] =E= rOffFraVirk2BNP[t] * vBNP[t];

    E_vtKirke_aTot[t]$(tx0[t] and t.val > 2015)..
      vtKirke[aTot,t] =E= tKirke[t] * ftKirke[t] * rtKirke[t] * (vSkatteplInd[aTot,t] - vPersFradrag[aTot,t]);

    # Jordrente
    E_vJordrente[t]$(tx0[t]).. vJordrente[t] =E= tJordRente[t] * vBVT['udv',t];

    # Overskud af offentlig virksomhed
    E_vOffVirk[t]$(tx0[t]).. vOffVirk[t] =E= rOffVirk2BNP[t] * vBNP[t];

# ----------------------------------------------------------------------------------------------------------------------
#   Indkomstbegreber og fradrag
# ----------------------------------------------------------------------------------------------------------------------
    E_vPersInd_tot[t]$(tx0[t] and t.val > 2015)..
      vPersInd[aTot,t] =E= vWHh[aTot,t]
                         - vtHhAM[aTot,t] 
                         + vOvfSkatPl[aTot,t]
                         + vHhPensUdb['PensX',aTot,t]
                         - vHhPensIndb['PensX',aTot,t]
                         - vHhPensIndb['Kap',aTot,t]
                         + vPersIndRest[aTot,t];

    E_vSkatteplInd_tot[t]$(tx0[t])..
      vSkatteplInd[aTot,t] =E= ( vPersInd[aTot,t]
                               + vNetKapInd[aTot,t] 
                               - vBeskFradrag[aTot,t] 
                               - vAKFradrag[aTot,t] 
                               - vELFradrag[aTot,t] 
                               - vRestFradrag[aTot,t]
                             ) * (1+jfvSkatteplInd[t]);

    E_vKapIndPos_tot[t]$(tx0[t] and t.val > 2015)..
      vKapIndPos[aTot,t] =E= (vHh['Obl',aTot,t-1]/fv * rOverlev[aTot,t] * rRente['Obl',t]
                           + vHh['Bank',aTot,t-1]/fv * rOverlev[aTot,t] * rRente['Bank',t]) * fvKapIndPos[aTot,t];

    E_vKapIndNeg_tot[t]$(tx0[t] and t.val > 2015)..
      vKapIndNeg[aTot,t] =E= rOverlev[aTot,t] * (vHhRenter['RealKred',t] + vHhRenter['BankGaeld',t]) * fvKapIndNeg[aTot,t];

    E_vNetKapIndPos_tot[t]$(tx0[t])..
      vNetKapIndPos[aTot,t] =E= rNet2KapIndPos[aTot,t] * vKapIndPos[aTot,t];

    E_vNetKapInd_tot[t]$(tx0[t]).. vNetKapInd[aTot,t] =E= vKapIndPos[aTot,t] - vKapIndNeg[aTot,t];

    # Fradrag
    E_vPersFradrag_tot[t]$(tx0[t] and t.val > 2015).. vPersFradrag[aTot,t] =E= vSatsIndeks[t] * (uvPersFradrag_a[aTot,t] + uvPersFradrag_t[t]);

    E_vAKFradrag_tot[t]$(tx0[t] and t.val >= 1994).. vAKFradrag[aTot,t]   =E= rAKFradrag2Bidrag[t] * vBidragAK[t];
    E_vELFradrag_tot[t]$(tx0[t] and t.val > 1998).. vELFradrag[aTot,t]   =E= rELFradrag2Bidrag[t] * vBidragEL[t];
    E_vRestFradrag_tot[t]$(tx0[t]).. vRestFradrag[aTot,t] =E= vRestFradragSats[t] * nLHh[aTot,t];
    E_vBeskFradrag_tot[t]$(tx0[t] and t.val > 2003).. vBeskFradrag[aTot,t] =E= tBeskFradrag[t] * vWHh[aTot,t];

    E_uRestFradrag[t]$(tx0[t]).. vRestFradragSats[t] =E= uRestFradrag[t] * vSatsIndeks[t];

    E_rtKilde2Loensum[t]$(tx0[t]).. rtKilde2Loensum[t] =E= vtKilde[t] / vLoensum[sTot,t];

# ----------------------------------------------------------------------------------------------------------------------
#   Marginal selskabskat
# ----------------------------------------------------------------------------------------------------------------------    
    E_mtVirk[sp,t]$(tx0[t]).. mtVirk[sp,t] =E= tSelskab[t] + udv[sp] * tSelskabNord[t];

# ----------------------------------------------------------------------------------------------------------------------
#   Beregningsteknisk skat til lukning af offentlig budgetrestriktion
# ----------------------------------------------------------------------------------------------------------------------    
    E_tLukning[t]$(tx0[t] and t.val > 2015)..
      vtLukning[aTot,t] =E= tLukning[t] * (vtHhx[aTot,t] - vtLukning[aTot,t]);

# ----------------------------------------------------------------------------------------------------------------------
#   Ligninger til beregning af nutidsværdien af offentlige indtægter 
# ----------------------------------------------------------------------------------------------------------------------    
    E_nvOffPrimInd[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOffPrimInd[t] =E= vOffPrimInd[t] * fHBIDisk[t] + nvOffPrimInd[t+1];
    E_nvOffPrimInd_tEnd[t]$(tEnd[t])..
      nvOffPrimInd[t] =E= vOffPrimInd[t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvtDirekte[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvtDirekte[t] =E= vtDirekte[t] * fHBIDisk[t] + nvtDirekte[t+1];
    E_nvtDirekte_tEnd[t]$(tEnd[t])..
      nvtDirekte[t] =E= vtDirekte[t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);

    E_nvtIndirekte[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvtIndirekte[t] =E= vtIndirekte[t] * fHBIDisk[t] + nvtIndirekte[t+1];
    E_nvtIndirekte_tEnd[t]$(tEnd[t])..
      nvtIndirekte[t] =E= vtIndirekte[t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);
    
    E_nvOffIndRest[t]$((tHBI.val <= t.val)  and (t.val < tEnd.val))..
      nvOffIndRest[t] =E= vOffIndRest[t] * fHBIDisk[t] + nvOffIndRest[t+1];
    E_vOffIndRest_tEnd[t]$(tEnd[t])..
      nvOffIndRest[t] =E= vOffIndRest[t] * fHBIDisk[t] / ((1+rOffRenteUd[t]) / fv - 1);
  $ENDBLOCK

  $BLOCK B_GovRevenues_a
# ----------------------------------------------------------------------------------------------------------------------
#   Kildeskatter
# ----------------------------------------------------------------------------------------------------------------------
    E_vtKommune[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vtKommune[a,t] =E= ftKommune[a,t] * tKommune[t] * (vSkatteplInd[a,t] - vPersFradrag[a,t]);
    E_ftKommune[a,t]$(a15t100[a] and tx0[t] and t.val > 2015).. ftKommune[a,t] =E= ftKommune_a[a,t] + ftKommune_t[t];
    E_ftKommune_tot[t]$(tx0[t] and t.val > 2015).. vtKommune[aTot,t] =E= sum(a, vtKommune[a,t] * nPop[a,t]);

    E_vtBund[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vtBund[a,t] =E= tBund[t] * ftBund[a,t] * (vPersInd[a,t] + vNetKapIndPos[a,t] - vPersFradrag[a,t]);
    E_ftBund[a,t]$(a15t100[a] and tx0[t] and t.val > 2015).. ftBund[a,t] =E= ftBund_a[a,t] + ftBund_t[t];
    E_ftBund_aTot[t]$(tx0[t] and t.val > 2015).. vtBund[aTot,t] =E= sum(a, vtBund[a,t] * nPop[a,t]);

    E_vtAktie[a,t]$(a0t100[a] and tx0[t] and t.val > 2015)..
      vtAktie[a,t] =E= tAktie[t] * (  vRealiseretAktieOmv[a,t]
                                    + rRente['IndlAktier',t] * vHh['IndlAktier',a-1,t-1]/fv
                                    + rRente['UdlAktier',t] * vHh['UdlAktier',a-1,t-1]/fv) * fMigration[a,t];
    E_ftAktie[t]$(tx0[t] and t.val > 2015).. vtAktie[aTot,t] =E= sum(a, vtAktie[a,t] * nPop[a,t]); # Bemærk at afdøde ikke betaler aktieskat

    # Pr. person i perioden før
    E_vRealiseretAktieOmv[a,t]$(tx0[t] and t.val > 2015)..
      vRealiseretAktieOmv[a,t] =E= vRealiseretAktieOmv[atot,t]
                                 * (vHh['IndlAktier',a-1,t-1] + vHh['UdlAktier',a-1,t-1])
                                 / (vHh['IndlAktier',aTot,t-1] + vHh['UdlAktier',aTot,t-1]);
  
    E_vtTop[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vtTop[a,t] =E= tTop[t] * (vPersInd[a,t] + vNetKapIndPos[a,t]) * rTopSkatInd[a,t];
    E_rTopSkatInd_aTot[t]$(tx0[t] and t.val > 2015).. vtTop[aTot,t] =E= sum(a, vtTop[a,t] * nPop[a,t]);
    E_rTopSkatInd[a,t]$(tx0[t] and t.val > 2015 and a15t100[a])..
      rTopSkatInd[a,t] =E= rTopSkatInd_a[a,t] + rTopSkatInd_t[t];

    E_vtEjd[a,t]$(tx0[t] and a.val >= 18 and t.val > 2015)..
      vtEjd[a,t] =E= tEjd[t] * vBolig[a-1,t-1]/fv * fMigration[a,t];

    E_vtVirksomhed[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vtVirksomhed[a,t] =E= tVirksomhed[t] * vEBT[sTot,t] * (vWHh[a,t] * nLHh[a,t]) / vWHh[aTot,t] / nPop[a,t];

    # Dødsboskat er aktieafkastskat og skat på positiv nettokapitalindkomst
    E_vtDoedsbo[a,t]$(tx0[t] and t.val > 2015)..
      vtDoedsbo[a,t] =E= tDoedsbo[t] 
                         * (vRealiseretAktieOmv[a,t] 
                            + rRente['IndlAktier',t] * vHh['IndlAktier',a-1,t-1]/fv 
                            + rRente['UdlAktier',t]  * vHh['UdlAktier',a-1,t-1]/fv 
                            + rNet2KapIndPos[a,t] * rRente['Obl',t]  * vHh['Obl',a-1,t-1]/fv
                            + rNet2KapIndPos[a,t] * rRente['Bank',t] * vHh['Bank',a-1,t-1]/fv) * rArvKorrektion[a];
    E_fvtDoedsbo[t]$(tx0[t] and t.val > 2015)..
      vtDoedsbo[aTot,t] =E= sum(a, vtDoedsbo[a,t] * (1-rOverlev[a-1,t-1]) * nPop[a-1,t-1]);

# ----------------------------------------------------------------------------------------------------------------------
#   Andre direkte skatter
# ----------------------------------------------------------------------------------------------------------------------
    # Andre direkte skatter   
    E_vtHhAM[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vtHhAM[a,t] =E= tAMbidrag[t] * ftAMBidrag[t] * (vWHh[a,t] * nLHh[a,t]) / nPop[a,t] * (vWHh[aTot,t] - vBidragTjmp[t]) / vWHh[aTot,t];

    E_vtHhVaegt[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      vtHhVaegt[a,t] =E= vtHhVaegtSats[t] * qBiler[t-1]/fq * qC_a[a,t] / qC['cIkkeBol',t];

    E_vtPersRest[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vtPersRest[a,t] =E= vtKapPens[a,t] + tPersRestxKapPens[t] * vHhPensUdb['PensX',a,t];

    E_vtKapPens[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vtKapPens[a,t] =E= tKapPens[t] * ftKapPens[t] * vHhPensUdb['Kap',a,t];

    E_vtKapPensArv[a,t]$(a.val >= 15 and tx0[t] and t.val > 2015)..
      vtKapPensArv[a,t] =E= tKapPens[t] * ftKapPens[t] * vPensArv['Kap',a,t];

# ----------------------------------------------------------------------------------------------------------------------
#   Øvrige offentlige indtægter
# ----------------------------------------------------------------------------------------------------------------------
    E_vBidrag[a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
      vBidrag[a,t] =E= (vWHh[a,t] * nLHh[a,t]) / vWHh[aTot,t] * vBidrag[aTot,t] / nPop[a,t]; 

    # Kirkeskat
    E_vtKirke[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vtKirke[a,t] =E= tKirke[t] * ftKirke[t] * rtKirke[t] * (vSkatteplInd[a,t] - vPersFradrag[a,t]);

    E_vtArv_aTot[t]$(tx0[t] and t.val > 2015).. vtArv[aTot,t] =E= tArv[t] * vArv[aTot,t];
    E_vtArv[a,t]$(tx0[t] and t.val > 2015).. vtArv[a,t] =E= tArv[t] * vArv[a,t];

# ----------------------------------------------------------------------------------------------------------------------
#   Indkomstbegreber og fradrag
# ----------------------------------------------------------------------------------------------------------------------
    E_vPersInd[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vPersInd[a,t] =E=   vWHh[a,t] * nLHh[a,t] / nPop[a,t]
                        - vtHhAM[a,t] 
                        + vOvfSkatPl[a,t]
                        + vHhPensUdb['PensX',a,t]
                        # Nedenstående led er en forsimpling - her betales skat af livsforsikring - i virkeligheden er forsikringselementet af pension ikke fradragsberettiget - vi bør ændre modelleringen og have data særskilt data for forsikring
                        + rArv[a,t] * vPensArv['PensX',aTot,t] / nPop[aTot,t] 
                        - vHhPensIndb['PensX',a,t]
                        - vHhPensIndb['Kap',a,t]
                        + vPersIndRest[a,t];

    E_vSkatteplInd[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vSkatteplInd[a,t] =E= (   vPersInd[a,t]
                              + vNetKapInd[a,t] 
                              - vBeskFradrag[a,t] 
                              - vAKFradrag[a,t] 
                              - vELFradrag[a,t] 
                              - vRestFradrag[a,t]
                            ) * (1+jfvSkatteplInd[t]);

    E_vPersIndRest[a,t]$(a15t100[a] and tx0[t] and t.val > 2015).. vPersIndRest[a,t] =E= vPersIndRest_a[a,t] + vPersIndRest_t[t];

    # vPersIndRest[aTot,t] vil ikke være lig sum(a, vPersIndRest[a,t] * nPop[a,t]), da de 0-14-åriges personindkomst ikke beregnes og vi ikke ønsker at korrigere for dette i totalen
    E_vPersIndRest_tot[t]$(tx0[t] and t.val > 2015).. vPersInd[aTot,t] =E= sum(a, vPersInd[a,t] * nPop[a,t]);

    # Rentefradrag
    E_vKapIndPos[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vKapIndPos[a,t] =E= (vHh['Obl',a-1,t-1]/fv * fMigration[a,t] * rRente['Obl',t]
                        + (vHh['Bank',a-1,t-1]/fv * fMigration[a,t] * rRente['Bank',t])$(a.val > 15)
                        ) * fvKapIndPos[a,t];
    E_fvKapIndPos[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      fvKapIndPos[a,t] =E= 1 + jfvKapIndPos_a[a,t] + jfvKapIndPos_t[t];
    E_jfvKapIndPos_atot[t]$(tx0[t] and t.val > 2015)..
      vKapIndPos[aTot,t] =E= sum(a, vKapIndPos[a,t] * nPop[a,t]);

    E_vKapIndNeg[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vKapIndNeg[a,t] =E= (vHh['RealKred',a-1,t-1]/fv * fMigration[a,t] * (rRente['Obl',t] + jrHhRente['RealKred',t])
                          + vHh['BankGaeld',a-1,t-1]/fv * fMigration[a,t] * (rRente['Bank',t] + jrHhRente['BankGaeld',t])     
                          ) * fvKapIndNeg[a,t];
    E_fvKapIndNeg[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      fvKapIndNeg[a,t] =E= 1 + jfvKapIndNeg_a[a,t] + jfvKapIndNeg_t[t];
    E_jfvKapIndNeg_atot[t]$(tx0[t] and t.val > 2015)..
      vKapIndNeg[aTot,t] =E= sum(a, vKapIndNeg[a,t] * nPop[a,t]);

    E_vNetKapInd[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vNetKapInd[a,t]    =E= vKapIndPos[a,t] - vKapIndNeg[a,t];
    E_vNetKapIndPos[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vNetKapIndPos[a,t] =E= rNet2KapIndPos[a,t] * vKapIndPos[a,t];

    # Fradrag
    E_vPersFradrag[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vPersFradrag[a,t] =E= vSatsIndeks[t] * (uvPersFradrag_a[a,t] + uvPersFradrag_t[t]);
    E_uvPersFradrag_a_tot[t]$(tx0[t] and t.val > 2015).. vPersFradrag[aTot,t] =E= sum(a, vPersFradrag[a,t] * nPop[a,t]);

    E_vAKFradrag[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vAKFradrag[a,t] =E= vBidrag[a,t] / vBidrag[aTot,t] * vAKFradrag[aTot,t];
    E_vELFradrag[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vELFradrag[a,t] =E= vBidrag[a,t] / vBidrag[aTot,t] * vELFradrag[aTot,t];
    E_vRestFradrag[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vRestFradrag[a,t] =E= (hLHh[a,t] * nLHh[a,t]) / hLHh[aTot,t] * vRestFradrag[aTot,t] / nPop[a,t];
    E_vBeskFradrag[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vBeskFradrag[a,t] =E= (vWHh[a,t] * nLHh[a,t]) / vWHh[aTot,t] * vBeskfradrag[aTot,t] / nPop[a,t];

# ----------------------------------------------------------------------------------------------------------------------
#   Marginal indkomstskat
# ----------------------------------------------------------------------------------------------------------------------
    E_mtInd[a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
      mtInd[a,t] =E= tBund[t] * ftBund[a,t]
                   + rTopSkatInd[a,t] * tTop[t]
                   + tKommune[t] * ftKommune[a,t] * (1+jfvSkatteplInd[t])
                   + (1 - tBund[t] * ftBund[a,t]
                        - tTop[t] * rTopSkatInd[a,t]
                        - tKommune[t] * ftKommune[a,t] * (1+jfvSkatteplInd[t])
                    ) * tAMbidrag[t] * ftAMBidrag[t] * (1 - vBidragTjmp[t] / vWHh[aTot,t]) 
                   + mtIndRest[a,t];

# ----------------------------------------------------------------------------------------------------------------------
#   Beregningsteknisk skat til lukning af offentlig budgetrestriktion
# ----------------------------------------------------------------------------------------------------------------------    
    E_vtLukning[a,t]$(tx0[t] and a0t100[a] and t.val > 2015)..
      vtLukning[a,t] =E= tLukning[t] * (vtHhx[a,t] - vtLukning[a,t]);
  $ENDBLOCK


  MODEL M_GovRevenues /
    B_GovRevenues_aTot
    B_GovRevenues_a
  /;


  # Equations that do not need to be solved together with the full model and can instead be solved afterwards.
  MODEL M_GovRevenues_post /
    E_nvOffPrimInd, E_nvOffPrimInd_tEnd
    E_nvtDirekte, E_nvtDirekte_tEnd
    E_nvtIndirekte, E_nvtIndirekte_tEnd
    E_nvOffIndRest, E_vOffIndRest_tEnd
  /;

  # Endogenous variables that are solved for only after the main model.
  # Note that these may not appear anywhere in the main model (this results in a model not square error).
  $GROUP G_GovRevenues_post
    nvOffPrimInd
    nvtDirekte
    nvtIndirekte
    nvOffIndRest
  ;
  $GROUP G_GovRevenues_post G_GovRevenues_post$(tHBI.val <= t.val and t.val <= tEnd.val);
$ENDIF

$IF %stage% == "exogenous_values":
# =============================================================================================½=========================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_GovRevenues_makrobk
    # Direkte skatter
    vtDirekte, vtBund$(aTot[a_]), vtTop$(aTot[a_]), vtKommune$(aTot[a_]), vtEjd$(aTot[a_]), vtAktie$(aTot[a_]), 
    vtVirksomhed$(aTot[a_]), vtDoedsbo$(aTot[a_]), vtHhAM$(aTot[a_]), vtSelskab$(sTot[s_]), vtPAL, vtMedie, 
    vtPersRest$(aTot[a_]), vtKapPens$(aTot[a_]), vtHhVaegt$(aTot[a_])
    # Indirekte skatter
    vtIndirekte, vtY$(sTot[s_])
    vBidragOblRest$(t.val < 2001)
    # Øvrige indtægter
    vtArv$(aTot[a_])
    vBidrag$(aTot[a_])
    vBidragAK, vBidragEL, vBidragFri, vBidragObl, vBidragOblTjm, vBidragATP, vBidragTjmp, 
    vOffFraUdlKap, vOffFraUdlEU, vOffFraUdlRest, vOffFraHh, vOffFraVirk, vtKirke$(aTot[a_]), vJordrente, vOffVirk, 
    # Indkomster og fradrag
    vPersInd$(aTot[a_]), vSkatteplInd$(aTot[a_]), 
    vKapIndNeg$(aTot[a_]), vNetKapInd$(aTot[a_]), 
    vKapIndPos$(aTot[a_]), vBeskFradrag$(aTot[a_]), vAKFradrag$(aTot[a_]), vELFradrag$(aTot[a_]), vRestFradrag$(aTot[a_]), 
    # Øvrige variable
    tSelskab, vOffPrimInd, vtKilde
    #Øvrige
    tKapPens, tPAL, tAMbidrag, tBund, tTop, tKirke, tKommune, tSelskab, rtKirke
    vtSelskabNord, vtMoms$(t.val<2016), vtAfg$(t.val<2016), vtReg, vtTold$(t.val<2016), vtAfgEU
    vtMoms$(t.val > 2015 and dTot[d_] and stot[s_])
    vtAfg$(t.val > 2015 and dTot[d_] and stot[s_])
    vtTold$(t.val > 2015 and dTot[d_] and stot[s_])                      
    vtEU, jvOffPrimInd
    vtYRest
  ;
  @load(G_GovRevenues_makrobk, "..\Data\makrobk\makrobk.gdx" )

  # Aldersfordelt data fra aldersprofiler indlæses
  $GROUP G_GovRevenues_aldersprofiler
    vtBund$(a[a_]), vtKommune$(a[a_]), vtTop$(a[a_]), vPersInd$(a[a_]), vKapIndNeg$(a[a_]), vKapIndPos$(a[a_])
    vNetKapInd$(a[a_])
    vNetKapIndPos$(a[a_] or aTot[a_]), vPersFradrag$(a[a_] or aTot[a_]), rNet2KapIndPos$(a[a_] or aTot[a_])
  ;
  $GROUP G_GovRevenues_aldersprofiler
    G_GovRevenues_aldersprofiler$(tAgeData[t])
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
    vtIndirekte, vtY$(sTot[s_])
    vtEU # Små afrundinger i ADAM
    jvOffPrimInd
    vBidragOblRest$(tBFR[t])
    tBund$(t.val = 2017)
    tTop$(t.val = 2017)
    tKommune$(t.val = 2017)
    vtYRest
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  rRealiseringAktieOmv.l[t] = 0.2;

  ftAktie.l[t] = 1;
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $BLOCK B_GovRevenues_static
    E_rvtAktie2BVT[t]$(tx0[t]).. rvtAktie2BVT[t] * vBVT[spTot,t] =E= vtAktie[aTot,t];
  $ENDBLOCK

  $GROUP G_GovRevenues_static_calibration_base
    G_GovRevenues_endo
  # Primære indtægter
    jvOffPrimInd, -vOffPrimInd
    vtHhVaegtSats, -vtHhVaegt$(aTot[a_])
    tEjd$(t.val > 2015), -vtEjd$(aTot[a_])
    tVirksomhed$(t.val > 1986), -vtVirksomhed$(aTot[a_])
    tDoedsbo$(t.val > 2015), -vtDoedsbo$(aTot[a_])
    tPersRestxKapPens, -vtPersRest$(aTot[a_])
    ftKapPens, -vtKapPens$(aTot[a_])
    ftSelskab, -vtSelskab$(sTot[s_])
    tSelskabNord$(t.val > 1990), -vtSelskabNord
    vtKildeRest, -vtKilde
    vtDirekteRest, -vtDirekte
  # Indkomster og fradrag
    tBeskFradrag$(t.val > 2003), -vBeskFradrag$(aTot[a_])
    jfvSkatteplInd, -vSkatteplInd$(aTot[a_])
  # Primære indtægter
    tAktie$(t.val > 1994), -vtAktie$(aTot[a_])
    ftPAL$(t.val > 1983), -vtPAL
    utMedie$(t.val > 1990), -vtMedie
    rvtAfgEU2vtAfg, -vtAfgEU  
    tJordRente, -vJordrente  
    uBidragOblTjm$(tBFR[t]), -vBidragOblTjm
    uBidragATP$(tBFR[t]), -vBidragATP
    uBidragOblRest$(tBFR[t]), -vBidragObl
    uBidragEL$(tBFR[t]), -vBidragEL
    uBidragFri$(tBFR[t]), -vBidragFri
    uBidragTjmp$(tBFR[t]), -vBidragTjmp
    uBidragAK$(tBFR[t]), -vBidragAK
  # Indkomster og fradrag   
    rAKFradrag2Bidrag$(t.val > 1993), -vAKFradrag$(aTot[a_])
    rELFradrag2Bidrag$(t.val > 1998), -vELFradrag$(aTot[a_])
    vRestFradragSats, -vRestFradrag$(aTot[a_])
    ftAMBidrag$(t.val > 1993), -vtHhAM$(aTot[a_])
    ftKirke$(t.val > 1986), -vtKirke$(aTot[a_])
    rvtAktie2BVT # E_rvtAktie2BVT
    tYRest$(s[s_]), -vtYRest$(s[s_])
  ;
  $GROUP G_GovRevenues_simple_static_calibration
    G_GovRevenues_static_calibration_base
    - G_GovRevenues_endo_a
    # Beregninger af led som er endogene i aldersdel (skal være uændret, når de beregnes endogent)
    -vPersFradrag$(aTot[a_]), uvPersFradrag_t
    -vtBund$(aTot[a_]), ftBund$(aTot[a_])
    -vtKommune$(aTot[a_]), ftKommune$(aTot[a_])
    -vPersInd$(aTot[a_]), vPersIndRest$(aTot[a_])
    -vtTop$(aTot[a_]), rTopSkatInd$(aTot[a_])
    -vKapIndNeg$(aTot[a_]), fvKapIndNeg$(aTot[a_])
    -vKapIndPos$(aTot[a_]), fvKapIndPos$(aTot[a_])
  ;
  $GROUP G_GovRevenues_simple_static_calibration 
    G_GovRevenues_simple_static_calibration$(tx0[t])
  ;
  MODEL M_GovRevenues_simple_static_calibration /
    M_GovRevenues
    - B_GovRevenues_a
    B_GovRevenues_static
  /;

  $GROUP G_GovRevenues_static_calibration
    G_GovRevenues_static_calibration_base
  # Indkomster og fradrag
    uvPersFradrag_a$(t.val > 2015), -vPersFradrag$(a[a_])
    ftBund_a$(t.val > 2015),  -vtBund$(a[a_])
    ftKommune_a$(t.val > 2015),  -vtKommune$(a[a_])
    vPersIndRest_a$(t.val > 2015), -vPersInd$(a[a_])
    rTopSkatInd_a$(t.val > 2015), -vtTop$(a[a_] and t.val > 2015)
    -vtArv$(atot[a_]), tArv$(t.val > 2015)
    #  rTopSkatInd$(aTot[a_] and t.val <= 2015), -vtTop$(aTot[a_] and t.val <= 2015)
    jfvKapIndNeg_a, -vKapIndNeg$(a[a_]) 
    jfvKapIndPos_a, -vKapIndPos$(a[a_])

    -mtInd, mtIndRest
  ;
  $GROUP G_GovRevenues_static_calibration
    G_GovRevenues_static_calibration$(tx0[t])
  ;

  MODEL M_GovRevenues_static_calibration /
    M_GovRevenues
    B_GovRevenues_static
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
    ftAMBidrag[t]$(tx1[t])
    ftKapPens[t]$(tx1[t])
    ftPAL[t]$(tx1[t])
    ftKirke[t]$(tx1[t])
    vPersIndRest_a[a_,t]$(a15t100[a_] and tx1[t])
    tAktie # E_rvtAktie2BVT
    -rtKilde2Loensum, vRestFradragSats
  ;
  $GROUP G_GovRevenues_deep G_GovRevenues_deep$(tx0[t]);
  $BLOCK B_GovRevenues_deep
    E_ftAMBidrag_forecast[t]$(tx1[t]).. ftAMBidrag[t] =E= 1;
    E_ftKapPens_forecast[t]$(tx1[t]).. ftKapPens[t] =E= 1;
    E_ftPAL_forecast[t]$(tx1[t]).. ftPAL[t] =E= 1;
    E_ftKirke_forecast[t]$(tx1[t]).. ftKirke[t] =E= 1;
    E_vPersIndRest_a_forecast[a,t]$(a15t100[a] and tx1[t])..
      vPersIndRest_a[a,t] / vPersInd[a,t] =E= vPersIndRest_a[a,t1] / vPersInd[a,t1];
  $ENDBLOCK
  MODEL M_GovRevenues_deep /
    M_GovRevenues - M_GovRevenues_post
    B_GovRevenues_deep
    E_rvtAktie2BVT
  /;
$ENDIF

# ======================================================================================================================
# Simple dynamic calibration
# ======================================================================================================================
$IF %stage% == "simple_dynamic_calibration":
$GROUP G_GovRevenues_dynamic_calibration
  G_GovRevenues_endo
  -vPersFradrag$(aTot[a_] and t1[t]), uvPersFradrag_t$(t1[t])
  -vtBund$(aTot[a_] and t1[t]), ftBund_t$(t1[t])
  -vtKommune$(aTot[a_] and t1[t]), ftKommune_t$(t1[t])
  -vPersInd$(aTot[a_] and t1[t]), vPersIndRest_t$(t1[t])
  -vtTop$(aTot[a_] and t1[t]), rTopSkatInd_t$(t1[t])
  -vKapIndNeg$(aTot[a_] and t1[t]), jfvKapIndNeg_t$(t1[t])
  -vKapIndPos$(aTot[a_] and t1[t]), jfvKapIndPos_t$(t1[t])

  ftKirke$(t1[t]), -vtKirke$(aTot[a_] and t1[t])
  tDoedsbo$(t1[t]), -vtDoedsbo$(aTot[a_] and t1[t])
  tPersRestxKapPens$(t1[t]), -vtPersRest$(aTot[a_] and t1[t])
  tAktie$(t1[t]), -vtAktie$(aTot[a_] and t1[t])
  -vtArv$(aTot[a_] and t1[t]), tArv$(t1[t])
;
MODEL M_GovRevenues_dynamic_calibration /
  M_GovRevenues - M_GovRevenues_post
/;
$ENDIF
