# ======================================================================================================================
# Government revenues
# - See also taxes module
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_GovRevenues_prices empty_group_dummy[t] "";
  $GROUP G_GovRevenues_quantities empty_group_dummy[t] "";

  $GROUP G_GovRevenues_values_endo
    # Primære indtægter
    vOffPrimInd[t] "Primære offentlige indtægter, Kilde: ADAM[Tf_z_o]-ADAM[Tioii]"
    vtY[t] "Produktionsskatter, brutto, Kilde: ADAM[Spz]-ADAM[Spzu]"
    vtYRest[t] "Øvrige produktionsskatter."

    # Direkte skatter
    vtDirekte[t]$(t.val > 2015) "Direkte skatter, Kilde: ADAM[Sy_o]"
    vtKilde[t]$(t.val > 2015) "Kildeskatter, Kilde: ADAM[Syk]"
    vtBund[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Bundskatter, Kilde: ADAM[Ssysp1]"
    vtTop[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Topskatter, Kilde: ADAM[Ssysp2]+ADAM[Ssysp3]"
    vtKommune[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Kommunal indkomstskatter, Kilde: ADAM[Ssys1]+ADAM[Ssys2]"
    vtEjd[a_,t]$((aVal[a_] >= 18 or aTot[a_]) and t.val > 2015) "Ejendomsværdibeskatning, Kilde: ADAM[Spzej]"
    vtAktie[a_,t]$((a0t100[a_] or aTot[a_]) and t.val > 2015) "Aktieskat, Kilde: ADAM[Ssya]"
    vtVirksomhed[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Virksomhedsskat, Kilde: ADAM[Ssyv]"
    vtDoedsbo[a_,t]$(t.val > 2015) "Dødsboskat, Kilde: ADAM[Ssyd]"
    vtHhAM[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Arbejdsmarkedsbidrag betalt af husholdningerne, Kilde: ADAM[Sya]"
    vtPersRest[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Andre personlige indkomstskatter, Kilde: ADAM[Syp]"
    vtKapPens[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Andre personlige indkomstskatter fratrukket andre personlige indkomstskatter resterende, ADAM[Syp]-ADAM[Sypr]"
    vtKapPensArv[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Kapitalskatter betalt i forbindelse med dødsfald og arv - ikke-datadækket hjælpevariabel."
    vtSelskab[s_,t] "Selskabsskat, Kilde: ADAM[Syc]"
    vtSelskabRest[s_,t] "Selskabsskat øvrige selskaber, Kilde: ADAM[Syc]-ADAM[Syc_e]"
    vtSelskabNord[t] "Selskabsskat fra Nordsøen, Kilde: ADAM[Syc_e]"
    vtPAL[t] "PAL skat, Kilde: ADAM[Sywp]"
    vtMedie[t]$(t.val > 2015) "Medielicens, Kilde: ADAM[Sym]"
    vtHhVaegt[a_,t]$((a18t100[a_] or aTot[a_]) and t.val > 2015) "Vægtafgifter fra husholdningerne, Kilde: ADAM[Syv]"
    vtAfgEU[t] "Produktafgifter til EU, Kilde: ADAM[Sppteu]"
    vtLukning[a_,t]$(a0t100[a_] and t.val > 2015) "Beregningsteknisk skat til lukning af offentlig budgetrestriktion på lang sigt (HBI=0)."

    # Indrekte skatter
    vtIndirekte[t] "Indirekte skatter, Kilde: ADAM[Spt_o]"
    vtEU[t] "Indirekte skatter til EU, Kilde: ADAM[Spteu]"

    # Øvrige offentlige indtægter
    vBidrag[a_,t]$((a15t100[a_] and t.val > 2015) or aTot[a_]) "Bidrag til sociale ordninger, Kilde: ADAM[Tp_h_o]"
    vBidragAK[t]$(t.val > 2015) "A-kassebidrag, Kilde: ADAM[Tpaf]"
    vBidragEL[t]$(t.val > 2015) "Efterlønsbidrag, Kilde: ADAM[Tpef]"
    vBidragFri[t]$(t.val > 2015) "Øvrige frivillige bidrag, Kilde: ADAM[Tpr]"
    vBidragObl[t]$(t.val > 2015) "Obligatoriske bidrag, Kilde: ADAM[Stp_o]"
    vBidragOblTjm[t]$(t.val > 2015) "Obligatoriske sociale bidrag vedr. tjenestemænd, Kilde: ADAM[Stpt]"
    vBidragATP[t]$(t.val > 2015) "Sociale bidrag til ATP, særlig ATP ordning og lønmodtagernes garantifond, Kilde: ADAM[Saqw]"
    vBidragOblRest[t]$(t.val > 2000) "Øvrige obligatoriske bidrag til sociale ordninger, Kilde: ADAM[Sasr]"
    vBidragTjmp[t]$(t.val > 2015) "Bidrag til Tjenestemandspension, Kilde: ADAM[Tpt_o]"

    vOffIndRest[t] "Andre offentlige indtægter."
    vtKirke[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Kirkeskat, Kilde: ADAM[Trks]"
    vJordrente[t] "Off. indtægter af jord og rettigheder, Kilde: ADAM[Tirn_o]"

    # Indkomstbegreber og fradrag 
    vPersInd[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Personlig indkomst, Kilde: ADAM[Ysp]"
    vPersIndRest[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Aggregeret restled til personindkomst."
    vSkatteplInd[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Skattepligtig indkomst, Kilde: ADAM[Ys]"
    vNetKapIndPos[a_,t]$((a15t100[a_] and t.val > 2015 ) or aTot[a_]) "Positiv nettokapitalindkomst."
    vNetKapInd[a_,t]$((a15t100[a_] and t.val > 2015 ) or aTot[a_]) "Nettokapitalindkomst, Kilde: ADAM[Tippps]"
    vKapIndPos[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Imputeret positiv kapitalindkomst."
    vKapIndNeg[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Imputeret negativ kapitalinkomst."
    vPersFradrag[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Imputeret personfradrag."
    vAKFradrag[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Imputeret fradrag for A-kassebidrag."
    vELFradrag[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Imputeret fradrag for efterlønsbidrag."
    vRestFradrag[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Imputerede øvrige ligningsmæssige fradrag (befordringsfradrag m.m.)"
    vBeskFradrag[a_,t]$((a15t100[a_] or aTot[a_]) and t.val > 2015) "Imputeret beskæftigelsesfradrag."
    vRealiseretAktieOmv[a_,t]$((a0t100[a_] and t.val > 2015) or atot[a_]) "Skøn over realiserede gevinst ved salg af aktier."
    vUrealiseretAktieOmv[t] "Skøn over endnu ikke realiserede kapitalgevinster på aktier."
  ;

  $GROUP G_GovRevenues_values_exo
    jvOffPrimInd[t] "J-led."
    jvKapIndPos[a_,t]$(a[a_]) "J-led."
    jvKapIndneg[a_,t]$(a[a_]) "J-led."
    vtKildeRest[t] "Restled."
    vtDirekteRest[t] "Restled."
    vOffFraUdl[t] "Residuale overførsler fra udlandet, Kilde: ADAM[Tr_e_o]+ADAM[tK_e_o]"
    vOffFraHh[t] "Residuale overførsler fra den private sektor, Kilde: ADAM[Trr_hc_o]"
    vOffFraVirk[t] "Kapitaloverførsler fra den private sektor, Kilde: ADAM[tK_hc_o]"
    vOffVirk[t] "Overskud af offentlig virksomhed, Kilde: ADAM[Tiuo_z_o]"
    vPersIndRest_a[a_,t] "Aldersfordelt restled til personindkomst."
    vPersIndRest_t[t] "Restled til personindkomst, uafhængigt af alder."
  ;

  $GROUP G_GovRevenues_values
    G_GovRevenues_values_endo
    G_GovRevenues_values_exo
  ;

  $GROUP G_GovRevenues_endo
    G_GovRevenues_values_endo
    ftBund[a_,t]$(aTot[a_] and t.val > 2015) "Korrektionsfaktor fra faktisk til implicit skattesats."
    rTopSkatInd[a_,t]$(aTot[a_] and t.val > 2015) "Imputeret gennemsnitlig del af indkomsten over topskattegrænsen."
    ftKommune[a_,t]$(aTot[a_] and t.val > 2015) "Korrektionsfaktor fra faktisk til implicit skattesats."
    fvtEjd[t]$(t.val > 2015) "parameter til at fange sammensætningseffekt."
    fvtAktie[t]$(t.val > 2015) "parameter til at fange sammensætningseffekt."
    fvtDoedsbo[t]$(t.val > 2015) "parameter til at fange sammensætningseffekt."
    jvKapIndPos[a_,t]$(aTot[a_] and t.val > 2015) "J-led."
    jvKapIndneg[a_,t]$(aTot[a_] and t.val > 2015) "J-led."
    uvPersFradrag[a_,t]$(aTot[a_]) "J-led."
    rOffFraUdl2BNP[t] "Overførsler fra udlandet til den offentlige sektor relativt til BNP."
    rOffFraHh2BNP[t] "Overførsler fra husholdningerne til den offentlige sektor relativt til BNP."
    rOffFraVirk2BNP[t] "Overførsler fra virksomhederne til den offentlige sektor relativt til BNP."
    rOffVirk2BNP[t] "Overskud fra offentlige virksomheder relativt til BNP."
    rPersIndRest_a2PersInd[a,t] "Aldersfordelt restled i personlig indkomst ift. samlet personlig indkomst."
    rPersIndRest_t2PersInd[t] "Ikke-aldersfordelt restled i personlig indkomst ift. samlet personlig indkomst."
    rRestFradragSats2SatsIndeks[t] "Restfradragssats relativ til sats-reguleringen."
    mtVirk[s_,t]$(sp[s_]) "Branchefordelt marginal indkomstskat hos virksomheder."
    tLukning[t] "Beregningsteknisk skatteskat til lukning af offentlig budgetrestriktion på lang sigt (HBI=0)."
  ;
  $GROUP G_GovRevenues_endo G_GovRevenues_endo$(tx0[t]);  # Restrict endo group to tx0[t]

  $GROUP G_GovRevenues_taxrates
    # Skattesatser som fremskrives eksplicit af FM
    tBund[t] "Bundskattesats, Kilde: ADAM[tsysp1]"
    tTop[t] "Topskattesats, Kilde: ADAM[tsysp2]+ADAM[tsysp3]"
    tKommune[t] "Gennemsnitlig kommunal skattesats, Kilde: ADAM[tsys1]+ADAM[tsys2]"
    tAMbidrag[t] "Procentsats for arbejdsmarkedsbidrag."
    tKapPens[t] "Skatterate hvormed kapitalpensioner bliver beskattet ved udbetaling, Kilde: ADAM[tsyp]"
    tSelskab[t] "Selskabsskattesats, Kilde: ADAM[tsyc]"
    tPAL[t] "PAL-skattesats, Kilde: ADAM[tsywp]"
    tKirke[t] "Kirkeskattesats, Kilde: ADAM[tks]"
  ;

  $GROUP G_GovRevenues_exogenous_forecast
    G_GovRevenues_taxrates

    # forecast_as_zero
    jvOffPrimInd[t] "J-led."
    jvKapIndPos[a_,t]$(a[a_]) "J-led."
    jvKapIndneg[a_,t]$(a[a_]) "J-led."
    vtKildeRest[t] "Restled."
    vtDirekteRest[t] "Restled."
  ;
  $GROUP G_GovRevenues_ARIMA_forecast
    # Endogene i stødforløb:
    rOffFraUdl2BNP
    rOffFraHh2BNP
    rOffFraVirk2BNP
    rOffVirk2BNP
    rvtAfgEU2vtAfg[t] "Andel af produktskatter som går til EU."
  ;

  $GROUP G_GovRevenues_other
    # Adjustment terms to fit data
    tEjd[t] "Implicit skattesats."
    tPersRestxKapPens[t] "Implicit skattesats."
    tSelskabNord[t] "Implicit skattesats."
    tVirksomhed[t] "Implicit skattesats."
    tDoedsbo[t] "Implicit skattesats."
    tAktie[t] "Implicit gennemsnitlig skat på aktieafkast."
    tJordRente[t] "Implicit skattesats."
    tHhVaegt[t] "Implicit skattesats."
    tbeskfradrag[t] "Imputeret gennemsnitlig beskæftigelsesfradrag ift. lønindkomst."
    
    ftAMBidrag[t] "Korrektionsfaktor fra faktisk til implicit skattesats."
    ftKapPens[t] "Korrektionsfaktor fra faktisk til implicit skattesats."
    ftSelskab[t] "Korrektionsfaktor fra faktisk til implicit skattesats."
    ftPAL[t] "Korrektionsfaktor fra faktisk til implicit skattesats."
    ftKirke[t] "Korrektionsfaktor fra faktisk til implicit skattesats."

    jfvSkatteplInd[t] "J-led."

    rNet2KapIndPos[a_,t] "Positiv nettokapitalindkomst ift. positiv kapitalindkomst."

    rtKirke[t] "Andel af skatteydere som betaler kirkeskat, ADAM[bks]"

    vRestFradragSats[t] "Eksogen del af andre fradrag kalibreret til at ramme makrodata."
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

    rRealiseringAktieOmv[t] "Andel af omvurderinger på aktier som realiseres hvert år."
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_GovRevenues

# ----------------------------------------------------------------------------------------------------------------------
# Primære offentlige indtægter
# ----------------------------------------------------------------------------------------------------------------------
    E_vOffPrimInd[t]$(tx0[t]).. vOffPrimInd[t] =E= vtDirekte[t] + vtIndirekte[t] + vOffIndRest[t];

  # Direkte skatter
    # Kilde: Generelt om skattesystemet
    # http://www.skm.dk/skattetal/beregning/skatteberegning/skatteberegning-hovedtraekkene-i-personbeskatningen-2017
    E_vtDirekte[t]$(tx0[t])..
      vtDirekte[t] =E= vtKilde[t] + vtHhAM[aTot,t] + vtPersRest[aTot,t]
                     + vtHhVaegt[aTot,t] + vtSelskab[sTot,t] + vtPAL[t] + vtMedie[t] + vtDirekteRest[t] + vtLukning[aTot,t];

    # Kildeskatter
    E_vtKilde[t]$(tx0[t])..
      vtKilde[t] =E= vtBund[aTot,t] + vtTop[aTot,t] + vtKommune[aTot,t] + vtEjd[aTot,t] + vtAktie[aTot,t] 
                   + vtVirksomhed[aTot,t] + vtDoedsbo[aTot,t] + vtKildeRest[t];

    E_vtBund[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vtBund[a,t] =E= ftBund[a,t] * tBund[t] * (vPersInd[a,t] + vNetKapIndPos[a,t] - vPersFradrag[a,t]);

    E_ftBund_tot[t]$(tx0[t] and t.val > 2015)..
      vtBund[aTot,t] =E= sum(a, vtBund[a,t] * nPop[a,t]);

    E_vtBund_tot[t]$(tx0[t] and t.val > 2015)..
      vtBund[aTot,t] =E= ftBund[aTot,t] * tBund[t] * (vPersInd[aTot,t] + vNetKapIndPos[aTot,t] - vPersFradrag[aTot,t]);

    E_vtTop[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vtTop[a,t] =E= tTop[t] * (vPersInd[a,t] + vNetKapIndPos[a,t]) * rTopSkatInd[a,t];

    E_rTopSkatInd_tot[t]$(tx0[t] and t.val > 2015).. vtTop[aTot,t] =E= sum(a, vtTop[a,t] * nPop[a,t]);

    E_vtTop_tot[t]$(tx0[t] and t.val > 2015)..
      vtTop[aTot,t] =E= tTop[t] * (vPersInd[aTot,t] + vNetKapIndPos[aTot,t]) * rTopSkatInd[aTot,t];

    E_vtKommune[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vtKommune[a,t] =E= tKommune[t] * ftKommune[a,t] * (vSkatteplInd[a,t] - vPersFradrag[a,t]);

    E_ftKommune_tot[t]$(tx0[t] and t.val > 2015).. vtKommune[aTot,t] =E= sum(a, vtKommune[a,t] * nPop[a,t]);

    E_vtKommune_tot[t]$(tx0[t] and t.val > 2015)..
      vtKommune[aTot,t] =E= tKommune[t] * ftKommune[aTot,t] * (vSkatteplInd[aTot,t] - vPersFradrag[aTot,t]);

    E_vtEjd[a,t]$(tx0[t] and a0t100[a] and t.val > 2015)..
      vtEjd[a,t] =E= tEjd[t] * vBolig[a-1,t-1]/fv * fMigration[a,t];
                                                  
    E_fvtEjd_tot[t]$(tx0[t] and t.val > 2015)..
      vtEjd[aTot,t] =E= tEjd[t] * sum(a, vBolig[a-1,t-1]/fv * fMigration[a,t] * nPop[a,t]
                                       + vBolig[a-1,t-1]/fv * (1-rOverlev[a-1,t-1]) * nPop[a-1,t-1]);

    E_vtEjd_tot[t]$(tx0[t] and t.val > 2015).. vtEjd[aTot,t] =E= tEjd[t] * fvtEjd[t] * vBolig[aTot,t-1]/fv;
    
    E_vtAktie[a,t]$(a0t100[a] and tx0[t] and t.val > 2015)..
      vtAktie[a,t] =E= tAktie[t] * (  vRealiseretAktieOmv[a,t]
                                    + rRente['IndlAktier',t] * vHh['IndlAktier',a-1,t-1]/fv
                                    + rRente['UdlAktier',t] * vHh['UdlAktier',a-1,t-1]/fv) * fMigration[a,t];

    E_fvtAktie_tot[t]$(tx0[t] and t.val > 2015).. vtAktie[aTot,t] =E= sum(a, vtAktie[a,t] * nPop[a,t]);

    E_vRealiseretAktieOmv[a,t]$(a0t100[a] and tx0[t] and t.val > 2015)..
      vRealiseretAktieOmv[a,t] =E= rRealiseringAktieOmv[t] * vUrealiseretAktieOmv[t]
                                 * (vHh['IndlAktier',a-1,t-1] + vHh['UdlAktier',a-1,t-1])
                                 / (vHh['IndlAktier',aTot,t-1] + vHh['UdlAktier',aTot,t-1])
                                 + (1-rRealiseringAktieOmv[t]) * vRealiseretAktieOmv[a-1,t-1]/fv;
 
    E_vRealiseretAktieOmv_aTot[t]$(tx0[t] and t.val > 2015)..
      vRealiseretAktieOmv[aTot,t] =E= sum(a, nPop[a,t] * vRealiseretAktieOmv[a,t]);
    E_vRealiseretAktieOmv_aTot_x2015[t]$(tx0[t] and t.val <= 2015)..
      vRealiseretAktieOmv[aTot,t] =E= rRealiseringAktieOmv[t] * vUrealiseretAktieOmv[t]
                                    + (1-rRealiseringAktieOmv[t]) * vRealiseretAktieOmv[aTot,t-1]/fv;

    E_vUrealiseretAktieOmv[t]$(tx0[t])..
      vUrealiseretAktieOmv[t] =E= vUrealiseretAktieOmv[t-1]/fv
                                - vRealiseretAktieOmv[aTot,t]
                                + rOmv['IndlAktier',t] * vHh['IndlAktier',aTot,t-1]/fv
                                + rOmv['UdlAktier',t] * vHh['UdlAktier',aTot,t-1]/fv;

    # Sammensætningseffekt skyldes forskellige dødssandsynligheder og formuer, da kun overlevende betaler aktieskat
    E_vtAktie_tot[t]$(tx0[t] and t.val > 2015)..
      vtAktie[aTot,t] =E= tAktie[t] * (vRealiseretAktieOmv[aTot,t]
                                     + rRente['IndlAktier',t] * vHh['IndlAktier',aTot,t-1]/fv
                                     + rRente['UdlAktier',t] * vHh['UdlAktier',aTot,t-1]/fv
                                     ) * rOverlev[aTot,t-1] * fvtAktie[t];

    E_vtVirksomhed[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vtVirksomhed[a,t] =E= tVirksomhed[t] * vEBT[sTot,t] * (vWHh[a,t] * nLHh[a,t]) / vWHh[aTot,t] / nPop[a,t];

    E_vtVirksomhed_tot[t]$(tx0[t] and t.val > 1986).. vtVirksomhed[aTot,t] =E= tVirksomhed[t] * vEBT[sTot,t];

    # Dødsboskat er aktieafkastskat og skat på positiv nettokapitalindkomst
    E_vtDoedsbo[a,t]$(tx0[t] and t.val > 2015)..
      vtDoedsbo[a,t] =E= tDoedsbo[t] 
                         * (vRealiseretAktieOmv[a,t] 
                            + rRente['IndlAktier',t] * vHh['IndlAktier',a-1,t-1]/fv 
                            + rRente['UdlAktier',t]  * vHh['UdlAktier',a-1,t-1]/fv 
                            + rNet2KapIndPos[a,t] * rRente['Obl',t]  * vHh['Obl',a-1,t-1]/fv
                            + rNet2KapIndPos[a,t] * rRente['Bank',t] * vHh['Bank',a-1,t-1]/fv) * rArvKorrektion[a];

    # Sammensætningseffekten er væsentlig, da den aggregerede overlevelses-sandsynlighed er langt fra den gennemsnitlige overlevelses-sandsynlighed vægtet efter formue
    # Udover dette fanger fvtDoedsbo også korrelation mellem overlevelse og formue indenfor en kohorte (rArvKorrektion)
    E_vtDoedsbo_tot[t]$(tx0[t] and t.val > 2015)..
      vtDoedsbo[aTot,t] =E= tDoedsbo[t] * (1-rOverlev[aTot,t-1])
                           * (vRealiseretAktieOmv[aTot,t] 
                              + rRente['IndlAktier',t] * vHh['IndlAktier',aTot,t-1]/fv 
                              + rRente['UdlAktier',t]  * vHh['UdlAktier',aTot,t-1]/fv  
                              + rNet2KapIndPos[aTot,t] * rRente['Obl',t]  * vHh['Obl',aTot,t-1]/fv
                              + rNet2KapIndPos[aTot,t] * rRente['Bank',t] * vHh['Bank',aTot,t-1]/fv)
                              * fvtDoedsbo[t];

    E_fvtDoedsbo_tot[t]$(tx0[t] and t.val > 2015)..
      vtDoedsbo[aTot,t] =E= sum(a, vtDoedsbo[a,t] * (1-rOverlev[a-1,t-1]) * nPop[a-1,t-1]);

    # Andre direkte skatter   
    E_vtHhAM[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vtHhAM[a,t] =E= tAMbidrag[t] * ftAMBidrag[t] * (vWHh[a,t] * nLHh[a,t]) / nPop[a,t] * (vWHh[aTot,t] - vBidragTjmp[t]) / vWHh[aTot,t];

    E_vtHhAM_tot[t]$(tx0[t] and t.val > 1993)..
      vtHhAM[aTot,t] =E= tAMbidrag[t] * ftAMBidrag[t] * (vWHh[aTot,t] - vBidragTjmp[t]);

    E_vtPersRest[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vtPersRest[a,t] =E= vtKapPens[a,t] + tPersRestxKapPens[t] * vPensUdb['PensX',a,t];
 
    E_vtPersRest_tot[t]$(tx0[t])..
      vtPersRest[aTot,t] =E= vtKapPens[aTot,t] 
                           + tPersRestxKapPens[t] * (vPensUdb['PensX',aTot,t] - vPensArv['PensX',aTot,t]);

    E_vtKapPens[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vtKapPens[a,t] =E= tKapPens[t] * ftKapPens[t] * vPensUdb['Kap',a,t];

    E_vtKapPens_tot[t]$(tx0[t])..
      vtKapPens[aTot,t] =E= tKapPens[t] * ftKapPens[t] * vPensUdb['Kap',aTot,t];

    E_vtKapPensArv[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vtKapPensArv[a,t] =E= tKapPens[t] * ftKapPens[t] * vPensArv['Kap',a,t];

    E_vtKapPensArv_tot[t]$(tx0[t] and t.val > 2015)..
      vtKapPensArv[aTot,t] =E= tKapPens[t] * ftKapPens[t] * vPensArv['Kap',aTot,t];

    E_vtHhVaegt[a,t]$(a18t100[a] and tx0[t] and t.val > 2015)..
      vtHhVaegt[a,t] =E= tHhVaegt[t] * qBiler[t-1]/fq * qC_a[a,t] / qC['cIkkeBol',t];

    E_vtHhVaegt_tot[t]$(tx0[t]).. vtHhVaegt[aTot,t] =E= tHhVaegt[t] * qBiler[t-1]/fq;


    E_vtSelskab_sTot[t]$(tx0[t]).. vtSelskab[sTot,t]     =E= vtSelskabRest[sTot,t] + vtSelskabNord[t];
    E_vtSelskabRest_sTot[t]$(tx0[t])..  vtSelskabRest[sTot,t] =E= tSelskab[t] * ftSelskab[t] * vEBT[sTot,t];
    E_vtSelskabNord[t]$(tx0[t] and t.val > 2015)..
      vtSelskabNord[t] =E=  (qY['udv',t] - qGrus[t]) / qY['udv',t] * vEBT['udv',t] * tSelskabNord[t];

    E_vtSelskab[sp,t]$(tx0[t])..
      vtSelskab[sp,t] =E= vtSelskabRest[sp,t] + sameas[sp,'udv'] * vtSelskabNord[t];
    E_vtSelskabRest[sp,t]$(tx0[t])..
      vtSelskabRest[sp,t] =E= tSelskab[t] * ftSelskab[t] * vEBT[sp,t];

    E_mtVirk[sp,t]$(tx0[t]).. mtVirk[sp,t] =E= tSelskab[t] + sameas[sp,'udv'] * tSelskabNord[t];

    E_vtPAL[t]$(tx0[t] and t.val > 1983)..
      vtPAL[t] =E= tPAL[t] * ftPAL[t] * (rRente['Pens',t] + rOmv['Pens',t]) * vHh['Pens',aTot,t-1]/fv;

    E_vtMedie_tot[t]$(tx0[t] and t.val > 1990).. vtMedie[t] =E= utMedie[t] * vSatsIndeks[t] * nPop['a18t100',t];

    E_vtLukning[a,t]$(tx0[t] and a0t100[a] and t.val > 2015)..
      vtLukning[a,t] =E= tLukning[t] * (vtHhx[a,t]-vtLukning[a,t]);
    E_tLukning[t]$(tx0[t] and t.val > 2015)..
      vtLukning[aTot,t] =E= tLukning[t] * (vtHhx[aTot,t] - vtLukning[aTot,t]);

    # Indirekte skatter
    E_vtIndirekte[t]$(tx0[t]).. vtIndirekte[t] =E= vtMoms[dTot,sTot,t]
                                                 + vtAfg[dTot,sTot,t]
                                                 + vtReg[dTot,t]
                                                 + vtY[t] 
                                                 + vtTold[dTot,sTot,t] - vtEU[t];

   E_vtEU[t]$(tx0[t]).. vtEU[t] =E= vtTold[dTot,sTot,t] + vtAfgEU[t];

   E_vtAfgEU[t]$(tx0[t]).. vtAfgEU[t] =E= rvtAfgEU2vtAfg[t] * vtAfg[dTot,sTot,t];


    E_vtYRest[t]$(tx0[t]).. vtYRest[t] =E= vtNetYAfgRest[sTot,t] + vSubYRes[t];
    E_vtY[t]$(tx0[t])..
      vtY[t] =E= vtGrund[sTot,t] + vtVirkVaegt[sTot,t] + vtVirkAM[sTot,t] + vtAUB[sTot,t] + vtYRest[t];

    # Øvrige offentlige indtægter
    E_vOffIndRest[t]$(tx0[t])..
      vOffIndRest[t] =E= vtArv[aTot,t] + vOffAfskr[kTot,t] + vBidrag[aTot,t]
                       + vOffFraUdl[t] + vOffFraHh[t] + vOffFraVirk[t]
                       + vtKirke[aTot,t] + vJordrente[t] + vOffVirk[t] + jvOffPrimInd[t];

    # Sociale bidrag
    E_vBidrag_tot[t]$(tx0[t])..
      vBidrag[aTot,t] =E= vBidragAK[t] + vBidragTjmp[t] + vBidragEL[t] + vBidragFri[t] + vBidragObl[t];

    E_vBidrag[a,t]$(tx0[t] and a15t100[a] and t.val > 2015)..
      vBidrag[a,t] =E= (vWHh[a,t] * nLHh[a,t]) / vWHh[aTot,t] * vBidrag[aTot,t] / nPop[a,t]; 

    E_vBidragAK[t]$(tx0[t] and t.val > 2000)..      vBidragAK[t]      =E= uBidragAK[t]      * vSatsIndeks[t] * nSoc['arbsty',t];
    E_vBidragTjmp[t]$(tx0[t] and t.val > 2000)..    vBidragTjmp[t]    =E= uBidragTjmp[t]    * vSatsIndeks[t] * nSoc['arbsty',t];
    E_vBidragEL[t]$(tx0[t] and t.val > 2000)..      vBidragEL[t]      =E= uBidragEL[t]      * vSatsIndeks[t] * nSoc['arbsty',t];
    E_vBidragFri[t]$(tx0[t] and t.val > 2000)..     vBidragFri[t]     =E= uBidragFri[t]     * vSatsIndeks[t] * nSoc['arbsty',t];
    E_vBidragOblTjm[t]$(tx0[t] and t.val > 2000)..  vBidragOblTjm[t]  =E= uBidragOblTjm[t]  * vSatsIndeks[t] * nSoc['arbsty',t];
    E_vBidragATP[t]$(tx0[t] and t.val > 2000)..     vBidragATP[t]     =E= uBidragATP[t]     * vSatsIndeks[t] * nSoc['arbsty',t];
    E_vBidragOblRest[t]$(tx0[t] and t.val > 2000).. vBidragOblRest[t] =E= uBidragOblRest[t] * vSatsIndeks[t] * nSoc['arbsty',t];

    E_vBidragObl[t]$(tx0[t] and t.val > 2000).. vBidragObl[t] =E= vBidragOblTjm[t] + vBidragATP[t] + vBidragOblRest[t];

    # Overførsler
    E_vOffFraUdl[t]$(tx0[t]).. vOffFraUdl[t] =E= rOffFraUdl2BNP[t] * vBNP[t];
    E_vOffFraHh[t]$(tx0[t])..  vOffFraHh[t]  =E= rOffFraHh2BNP[t] * vBNP[t];
    E_vOffFraVirk[t]$(tx0[t]).. vOffFraVirk[t] =E= rOffFraVirk2BNP[t] * vBNP[t];

    # Kirkeskat
    E_vtKirke[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vtKirke[a,t] =E= tKirke[t] * ftKirke[t] * rtKirke[t] * (vSkatteplInd[a,t] - vPersFradrag[a,t]);

    E_vtKirke_tot[t]$(tx0[t] and t.val > 1986)..
      vtKirke[aTot,t] =E= tKirke[t] * ftKirke[t] * rtKirke[t] * (vSkatteplInd[aTot,t] - vPersFradrag[aTot,t]);

    # Jordrente
    E_vJordrente[t]$(tx0[t]).. vJordrente[t] =E= tJordRente[t] * vBVT['udv',t];

    # Overskud af offentlig virksomhed
    E_vOffVirk[t]$(tx0[t]).. vOffVirk[t] =E= rOffVirk2BNP[t] * vBNP[t];


# ----------------------------------------------------------------------------------------------------------------------
#   Indkomstbegreber og fradrag
# ----------------------------------------------------------------------------------------------------------------------
    E_vPersInd[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vPersInd[a,t] =E=   vWHh[a,t] * nLHh[a,t] / nPop[a,t]
                        - vtHhAM[a,t] 
                        + vOvfSkatPl[a,t]
                        + vPensUdb['PensX',a,t]
                        # Nedenstående led er en forsimpling - her betales skat af livsforsikring - i virkeligheden er forsikringselementet af pension ikke fradragsberettiget - vi bør ændre modelleringen og have data særskilt data for forsikring
                        + rArv[a,t] * vPensArv['PensX',aTot,t] / nPop[aTot,t] 
                        - vPensIndb['PensX',a,t]
                        - vPensIndb['Kap',a,t]
                        + vPersIndRest[a,t];

    E_vSkatteplInd[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vSkatteplInd[a,t] =E= ( vPersInd[a,t]
                           + vNetKapInd[a,t] 
                           - vBeskFradrag[a,t] 
                           - vAKFradrag[a,t] 
                           - vELFradrag[a,t] 
                           - vRestFradrag[a,t]
                            ) * (1+jfvSkatteplInd[t]);

    E_vPersInd_tot[t]$(tx0[t] and t.val > 2015)..
      vPersInd[aTot,t] =E=   vWHh[aTot,t]
                           - vtHhAM[aTot,t] 
                           + vOvfSkatPl[aTot,t]
                           + vPensUdb['PensX',aTot,t]
                           - vPensIndb['PensX',aTot,t]
                           - vPensIndb['Kap',aTot,t]
                           + vPersIndRest[aTot,t];

    E_vPersIndRest[a,t]$(a15t100[a] and tx0[t] and t.val > 2015).. vPersIndRest[a,t] =E= vPersIndRest_a[a,t] + vPersIndRest_t[t];

    E_rPersIndRest_a2PersInd[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vPersIndRest_a[a,t] =E= rPersIndRest_a2PersInd[a,t] * vPersInd[a,t];

    E_rPersIndRest_t2PersInd[t]$(tx0[t] and t.val > 2015)..
      vPersIndRest_t[t] =E= rPersIndRest_t2PersInd[t] * vPersInd[aTot,t] / sum(a$a15t100[a], nPop.l[a,t]);

    # vPersIndRest[aTot,t] vil ikke være lig sum(a, vPersIndRest[a,t] * nPop[a,t]), da de 0-14-åriges personindkomst ikke beregnes og vi ikke ønsker at korrigere for dette i totalen
    E_vPersIndRest_tot[t]$(tx0[t] and t.val > 2015).. vPersInd[aTot,t] =E= sum(a, vPersInd[a,t] * nPop[a,t]);

    E_vSkatteplInd_tot[t]$(tx0[t])..
      vSkatteplInd[aTot,t] =E= ( vPersInd[aTot,t]
                               + vNetKapInd[aTot,t] 
                               - vBeskFradrag[aTot,t] 
                               - vAKFradrag[aTot,t] 
                               - vELFradrag[aTot,t] 
                               - vRestFradrag[aTot,t]
                             ) * (1+jfvSkatteplInd[t]);

    # Rentefradrag
    E_vKapIndPos[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vKapIndPos[a,t] =E= vHh['Obl',a-1,t-1]/fv * fMigration[a,t] * rRente['Obl',t]
                          + (vHh['Bank',a-1,t-1]/fv * fMigration[a,t] * rRente['Bank',t])$(a.val > 15)
                          + jvKapIndPos[a,t];

    E_vKapIndNeg[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vKapIndNeg[a,t] =E= vHh['RealKred',a-1,t-1]/fv * fMigration[a,t] * (rRente['RealKred',t] + jrHhRente['RealKred',t])
                             + vHh['BankGaeld',a-1,t-1]/fv * fMigration[a,t] * (rRente['Bank',t] + jrHhRente['Bank',t])
                             + jvKapIndNeg[a,t];

    E_vNetKapInd[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vNetKapInd[a,t]    =E= vKapIndPos[a,t] - vKapIndNeg[a,t];
    E_vNetKapIndPos[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vNetKapIndPos[a,t] =E= rNet2KapIndPos[a,t] * vKapIndPos[a,t];

    E_jvKapIndPos_tot[t]$(tx0[t] and t.val > 2015)..
      vKapIndPos[aTot,t] =E= sum(a, vKapIndPos[a,t] * nPop[a,t]);

    E_vKapIndPos_tot[t]$(tx0[t] and t.val > 2015)..
      vKapIndPos[aTot,t] =E= vHh['Obl',aTot,t-1]/fv * fMigration[aTot,t] * rRente['Obl',t]
                          + (vHh['Bank',aTot,t-1]/fv * fMigration[aTot,t] * rRente['Bank',t])
                          + jvKapIndPos[aTot,t];

    E_jvKapIndNeg_tot[t]$(tx0[t] and t.val > 2015)..
      vKapIndNeg[aTot,t] =E= sum(a, vKapIndNeg[a,t] * nPop[a,t]);

    E_vKapIndNeg_tot[t]$(tx0[t] and t.val > 2015)..
      vKapIndNeg[aTot,t] =E= vHh['RealKred',aTot,t-1]/fv * fMigration[aTot,t] * (rRente['RealKred',t] + jrHhRente['RealKred',t])
                           + vHh['BankGaeld',aTot,t-1]/fv * fMigration[aTot,t] * (rRente['Bank',t] + jrHhRente['Bank',t])
                           + jvKapIndNeg[aTot,t];

    E_vNetKapIndPos_tot[t]$(tx0[t])..
      vNetKapIndPos[aTot,t] =E= rNet2KapIndPos[aTot,t] * vKapIndPos[aTot,t];

    E_vNetKapInd_tot[t]$(tx0[t]).. vNetKapInd[aTot,t] =E= vKapIndPos[aTot,t] - vKapIndNeg[aTot,t];

    # Fradrag
    E_vPersFradrag[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vPersFradrag[a,t] =E= vSatsIndeks[t] * uvPersFradrag[a,t];
    E_uvPersFradrag_tot[t]$(tx0[t] and t.val > 2015).. vPersFradrag[aTot,t] =E= sum(a, vPersFradrag[a,t] * nPop[a,t]);

    E_vPersFradrag_tot[t]$(tx0[t])..
      vPersFradrag[aTot,t] =E= vSatsIndeks[t] * uvPersFradrag[aTot,t];


    E_vAKFradrag_tot[t]$(tx0[t] and t.val > 1993).. vAKFradrag[aTot,t]   =E= rAKFradrag2Bidrag[t] * vBidragAK[t];
    E_vELFradrag_tot[t]$(tx0[t] and t.val > 1998).. vELFradrag[aTot,t]   =E= rELFradrag2Bidrag[t] * vBidragEL[t];
    E_vRestFradrag_tot[t]$(tx0[t]).. vRestFradrag[aTot,t] =E= vRestFradragSats[t] * nLHh[aTot,t];
    E_vBeskFradrag_tot[t]$(tx0[t] and t.val > 2003).. vBeskFradrag[aTot,t] =E= tbeskfradrag[t]      * vWHh[aTot,t];
    E_vAKFradrag[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vAKFradrag[a,t] =E= vBidrag[a,t] / vBidrag[aTot,t] * vAKFradrag[aTot,t];
    E_vELFradrag[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vELFradrag[a,t] =E= vBidrag[a,t] / vBidrag[aTot,t] * vELFradrag[aTot,t];
    E_vRestFradrag[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vRestFradrag[a,t] =E= (hLHh[a,t] * nLHh[a,t]) / hLHh[aTot,t] * vRestFradrag[aTot,t] / nPop[a,t];
    E_vBeskFradrag[a,t]$(a15t100[a] and tx0[t] and t.val > 2015)..
      vBeskFradrag[a,t] =E= (vWHh[a,t] * nLHh[a,t]) / vWHh[aTot,t] * vBeskfradrag[aTot,t] / nPop[a,t];

    E_rRestFradragSats2SatsIndeks[t]$(tx0[t]).. vRestFradragSats[t] =E= rRestFradragSats2SatsIndeks[t] * vSatsIndeks[t];
  $ENDBLOCK
$ENDIF