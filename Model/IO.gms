# ======================================================================================================================
# Input Output system
# - This module handles the details of the IO system.
#   The different demand components are satisfied with domestic production competing with imports.
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_IO_prices_endo
    pY[s_,t]$(not s[s_]) "Produktionsdeflator fordelt på brancher, Kilde: ADAM[pX] eller ADAM[pX<i>]"
    pM[s_,t]$(sTot[s_]) "Importdeflator fordelt på importgrupper, Kilde: ADAM[pM] eller ADAM[pM<i>]"
    pBNP[t] "BNP-deflator, Kilde: ADAM[pY]"
    pBVT[s_,t] "BVT-deflator, Kilde: ADAM[pyf] eller ADAM[pyf<i>]"

    pIO[d_,s_,t]$(dux_[d_] and d1IO[d_,s_,t] and s[s_]) "Imputeret deflator for branchefordelte leverancer fra både import og indenlandsk produktion fordelt på efterspørgselskomponenter."
    pIOy[d_,s_,t]$(d1IOy[d_,s_,t] and s[s_]) "Imputeret deflator for branchefordelte leverancer fra indenlandsk produktion fordelt på efterspørgselskomponenter."
    pIOm[d_,s_,t]$(d1IOm[d_,s_,t] and s[s_]) "Imputeret deflator for branchefordelte leverancer fra import fordelt på efterspørgselskomponenter."

    pX[x_,t] "Eksportdeflator fordelt på eksportgrupper, Kilde: ADAM[pe] eller ADAM[pe<i>]"
    pXm[x_,t]$(d1Xm[x_,t]) "Deflator på import til reeksport."
    pXy[x_,t] "Deflator på direkte eksport."
    pR[r_,t] "Deflator på materialeinput fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[pV] eller ADAM[pv<i>]"
    pCDK[c_,t] "Forbrugsdeflator fordelt på forbrugsgrupper, Kilde: ADAM[pcp] eller ADAM[pC<i>]"
    pCTurist[c,t] "Price index of tourists consumption by consumption group."
    pG[g_,t] "Deflator for offentligt forbrug, Kilde: ADAM[pco]"
    pI[i_,t] "Investeringsdeflator fordelt på investeringstyper, Kilde: ADAM[pI] eller ADAM[pim] eller ADAM[pib]"
    pI_s[i_,s_,t]$(d1I_s[i_,s_,t] and s[s_] or (k[i_] and (spTot[s_] or sByTot[s_]))) "Investeringsdeflator fordelt på brancher, Kilde: ADAM[pI<i>] eller ADAM[pim<i>] eller ADAM[pib<i>]"
    pC[c_,t]$(c[c_] or cTot[c_]) "Imputeret prisindeks for forbrugskomponenter for husholdninger - dvs. ekskl. turisters forbrug."
    pBruttoHandel[t] "Kædeprisindeks for eksport + import"
  ;
  $GROUP G_IO_quantities_endo
    qY[s_,t]$(not (udv[s_] or bol[s_])) "Produktion fordelt på brancher, Kilde: ADAM[fX]"
    qM[s_,t] "Import fordelt på importgrupper, Kilde: ADAM[fM] eller ADAM[fM<i>]"
    qBNP[t] "BNP, Kilde: ADAM[fY]"
    qBVT[s_,t] "BVT, Kilde: ADAM[fYf] eller ADAM[fYf<i>]"

    qIO[d_,s_,t]$(dux_[d_] and d1IO[d_,s_,t]) "Imputeret branchefordelte leverancer fra både import og indenlandsk produktion fordelt på efterspørgselskomponenter."
    qIOy[d_,s_,t]$(d1IOy[d_,s_,t]) "Imputeret branchefordelte leverancer fra indenlandsk produktion fordelt på efterspørgselskomponenter."
    qIOm[d_,s_,t]$(d1IOm[d_,s_,t]) "Imputeret branchefordelte leverancer fra import fordelt på efterspørgselskomponenter."

    qR[r_,t]$(not r[r_]) "Materialeinput fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[fV] eller ADAM[fV<i>]"
    qCDK[c,t] "Det private forbrug fordelt på forbrugsgrupper, Kilde: ADAM[fCp] eller ADAM[fC<i>]"
    qC[c_,t]$(cTot[c_]) "Husholdningernes samlede forbrug fordelt på forbrugsgrupper og aggregater inkl. lejebolig og imputeret ejerbolig."
    qI[i_,t] "Investeringer fordelt på investeringstype, Kilde: ADAM[fI] eller ADAM[fIm] eller ADAM[fIb]"  
    qI_s[i_,s_,t]$(iTot[i_] or (k[i_] and (spTot[s_] or sByTot[s_]))) "Investeringer fordelt på brancher, Kilde: ADAM[fI<i>] eller ADAM[fIm<i>] eller ADAM[fIb<i>]"
    qHandelsbalance[t] "Real handelsbalance"
    qBruttoHandel[t] "Eksport + import i kædepriser"
  ;
  $GROUP G_IO_values_endo
    vY[s_,t] "Produktionsværdi fordelt på brancher, Kilde: ADAM[X] eller ADAM[X<i>]"
    vM[s_,t] "Import fordelt på importgrupper, Kilde: ADAM[M] eller ADAM[M<i>]"
    vBNP[t] "BNP, Kilde: ADAM[Y]"
    vBVT[s_,t] "BVT, Kilde: ADAM[Yf] eller ADAM[Yf<i>]"

    vIO[d_,s_,t]$(d1IO[d_,s_,t]) "Imputeret branchefordelte leverancer fra både import og indenlandsk produktion fordelt på efterspørgselskomponenter."
    vIOy[d_,s_,t]$(d1IOy[d_,s_,t]) "Imputeret branchefordelte leverancer fra indenlandsk produktion fordelt på efterspørgselskomponenter."
    vIOm[d_,s_,t]$(d1IOm[d_,s_,t]) "Imputeret branchefordelte leverancer fra import fordelt på efterspørgselskomponenter."

    vX[x_,t] "Eksport fordelt på eksportgrupper, Kilde: ADAM[E] eller ADAM[E<i>]"
    vXy[x_,t] "Direkte eksport fordelt på eksportgrupper."
    vXm[x_,t] "Import til reeksport fordelt på eksportgrupper."
    vR[r_,t] "Materialeinput fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[V] eller ADAM[V<i>]"
    vC[c_,t]$(cTot[c_] or c[c_]) "Det private forbrug fordelt på forbrugsgrupper, Kilde: ADAM[Cp] eller ADAM[C<i>]"
    vCTurist[c,t] "Turisters forbrug i Danmark fordelt på forbrugsgrupper."
    vG[g_,t] "Offentligt forbrug, Kilde: ADAM[Co]"
    vI[i_,t] "Investeringer fordelt på investeringstype, Kilde: ADAM[I] eller ADAM[Im] eller ADAM[iB]"
    vI_s[i_,s_,t]$(not (k[i_] and sOff[s_])) "Investeringer fordelt på brancher, Kilde: ADAM[I<i>] eller ADAM[Im<i>] eller ADAM[iB<i>]"
    vHandelsbalance[t] "Nominel handelsbalance (nettoeksport)"
  ;

  $GROUP G_IO_endo
    G_IO_prices_endo
    G_IO_quantities_endo
    G_IO_values_endo

    # qY[udv] er eksogen. 
    # juIOm skalerer import-andel fra udvindingsbranche for at efterspørgsel rammer eksogen produktion.
    juIOm[s,t]$(udv[s]) "J-led."

    # Eksport-træk på udvindingsbranche følger eksogen produktion - se E_uIOXy0
    uIOXy0[x,s,t]$(udv[s] and d1IOy[x,s,t]) "Skalaparameter for eksportkomponents vægt på diverse indenlandske input før endelig skalering."


    # Skalaparameter (endogene pga. balancerings-mekanismer)
    uIO[d_,s,t] "Skalaparameter for efterspørgselskomponents vægt på diverse input."
    uIOy[dux,s,t] "Skalaparameter for efterspørgselskomponents vægt på diverse indenlandske input."
    uIOm[dux,s,t] "Skalaparameter for efterspørgselskomponents vægt på diverse importerede input."
    uIOXy[x,s,t] "Skalaparameter for eksportkomponents vægt på diverse indenlandske input."
    uIOXm[x,s,t] "Skalaparameter for eksportkomponents vægt på diverse importerede input."

    fpI_s[i,t]$(tForecast[t]) "Korrektionsfaktor som sørger for at vI_s summerer til vI."

    # vI fastholder en eksogen fordeling af offentlige nyinvesteringer på investeringstyper.
    # De tilhørende skalaparametre er endogene.
    uIO0[dux,s_,t]$(i_[dux] and sOff[s_] and d1IO[dux,s_,t]) "Skalaparameter for efterspørgselskomponents vægt på diverse input før endelig skalering."

    # Alt offentligt salg til privat forbrug antages at gå til forbrug af øvrige tjenester.
    # Den tilhørende skalaparameter er endogen.
    uIO0[dux,s_,t]$(c_[dux] and sOff[s_] and d1IO[dux,s_,t]) "Skalaparameter for efterspørgselskomponents vægt på diverse input før endelig skalering."

    qC[c_,t]$(cbol[c_])

    rpIOm2pIOy[d_,s,t] "Relativ pris mellem import og egenproduktion."
  ;
  $GROUP G_IO_endo G_IO_endo$(tx0[t]); # Restrict endo group to tx0[t]

  $GROUP G_IO_prices
    G_IO_prices_endo
  ;
  $GROUP G_IO_quantities
    G_IO_quantities_endo

    qGrus[t] "Eksogen mængde af produktion fra udvindingsbranche som ikke udfases, men heller ikke indgår i Nordsøbeskatning."
  ;
  $GROUP G_IO_values
    G_IO_values_endo
  ;

  $GROUP G_IO_exogenous_forecast
    qY[s_,t]$(udv[s_])
  ;
  $GROUP G_IO_ARIMA_forecast
    uIO0[dux,s_,t] "Skalaparameter for efterspørgselskomponents vægt på diverse input før endelig skalering."
    uIOm0[dux,s,t] "Importandel i efterspørgselskomponent."
    uIOXy0[x,s,t] "Skalaparameter for eksportkomponents vægt på diverse indenlandske input før endelig skalering."
    uIOXm0[x,s,t] "Skalaparameter for eksportkomponents vægt på diverse importerede input før endelig skalering."
    fuIO[dux,t] "Korrektionsfaktor for skalaparametrene for efterspørgselskomponents vægt på diverse input."
    fuIOym[dux,s,t] "Korrektionsfaktor for skalaparametrene for efterspørgselskomponents vægt på diverse hhv. indenlandske og importerede input."
    fuIOXm[x,t] "Korrektionsfaktor for skalaparametrene for efterspørgselskomponents vægt på diverse input."
    fuIOXy[x,t] "Korrektionsfaktor for skalaparametrene for efterspørgselskomponents vægt på diverse input."
    fpCTurist[c,t] "Korrektion som fanger at turisters forbrug har anden deflator end indenlandske husholdninger."
    upI_s[i,s,t] "Skalaparameter som fanger forskelle i branchernes investerings-deflatorer for samme investeringstype."
    uIOXyUdv0[x,t] "Skalaparameter for eksportkomponents vægt på indenlandsk udvinding før skalering til samlet indenlandsk udvinding."
  ;
  $GROUP G_IO_constants
    rpMTraeghed[d_,s] "Parameter til at styre kortsigtet priselasticitet."
    eIO[d_,s] "Substitutionselasticitet mellem import og indenlandsk produktion for diverse input for efterspørgselskomponenterne."
  ;
  $GROUP G_IO_other
    jpIOy[d_,t] "Pristillæg fra mermarkup fordelt på efterspørgseler - er 0 historisk."
    jpIOm[d_,t] "Pristillæg fra mermarkup fordelt på efterspørgseler - er 0 historisk."

    rqIO2qG[c,t] "Offentlige leverancer til privat forbrug som andel af samlet offentligt forbrug."
    rqIO2qYoff[i,t] "Offentlige leverancer til investeringer (F&U) som andel af samlet offentlig produktion."
  ;
$ENDIF


# ======================================================================================================================
# Equations  
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_IO
    # --------------------------------------------------------------------------------------------------------------------
    # Markedsligevægt
    # --------------------------------------------------------------------------------------------------------------------
    E_qY[s,t]$(tx0[t]).. qY[s,t] =E= sum(d, qIOy[d,s,t] / (1 + tIOy[d,s,tBase]));
    E_vY[s,t]$(tx0[t]).. vY[s,t] =E= pY[s,t] * qY[s,t];

    E_qM[s,t]$(tx0[t]).. qM[s,t] =E= sum(d, qIOm[d,s,t] / (1 + tIOm[d,s,tBase]));
    E_vM[s,t]$(tx0[t]).. vM[s,t] =E= pM[s,t] * qM[s,t];

    # --------------------------------------------------------------------------------------------------------------------
    # Aggregater
    # --------------------------------------------------------------------------------------------------------------------   
    E_pBNP[t]$(tx0[t]).. pBNP[t] * qBNP[t] =E= vBNP[t];

    E_qBNP[t]$(tx0[t])..
      qBNP[t] * pBNP[t-1]/fp =E= (pC[cTot,t-1]/fp * qC[cTot,t]
                                 + pG[gTot,t-1]/fp * qG[gTot,t] 
                                 + pI[iTot,t-1]/fp * qI[iTot,t]
                                 + pX[xTot,t-1]/fp * qX[xTot,t] 
                                 - pM[sTot,t-1]/fp * qM[sTot,t]);

    E_vBNP[t]$(tx0[t]).. vBNP[t] =E= vC[cTot,t] + vI[iTot,t] + vG[gTot,t] + vX[xTot,t] - vM[sTot,t];

    # Kæde-indeks for branche-fordelt BVT
    E_qBVT[s,t]$(tx0[t]).. qBVT[s,t] * pBVT[s,t-1]/fp =E= pY[s,t-1]/fp * qY[s,t] - pR[s,t-1]/fp * qR[s,t];
    E_pBVT[s,t]$(tx0[t]).. pBVT[s,t] * qBVT[s,t] =E= vBVT[s,t];
    E_vBVT[s,t]$(tx0[t]).. vBVT[s,t] =E= vY[s,t] - vR[s,t];

    # Kæde-indeks for samlet BVT
    E_qBVT_tot[t]$(tx0[t]).. qBVT[sTot,t] * pBVT[sTot,t-1]/fp =E= pY[sTot,t-1]/fp * qY[sTot,t] - pR[rTot,t-1]/fp * qR[rTot,t];
    E_pBVT_tot[t]$(tx0[t]).. pBVT[sTot,t] * qBVT[sTot,t] =E= vBVT[sTot,t];
    E_vBVT_tot[t]$(tx0[t]).. vBVT[sTot,t] =E= vY[sTot,t] - vR[rTot,t];

    E_qBVT_spTot[t]$(tx0[t]).. qBVT[spTot,t] * pBVT[spTot,t-1]/fp =E= pY[spTot,t-1]/fp * qY[spTot,t] - pR[spTot,t-1]/fp * qR[spTot,t];
    E_pBVT_spTot[t]$(tx0[t]).. pBVT[spTot,t] * qBVT[spTot,t] =E= vBVT[spTot,t];
    E_vBVT_spTot[t]$(tx0[t]).. vBVT[spTot,t] =E= vY[spTot,t] - vR[spTot,t];

    # Consumption is chain-aggregate of household and tourist consumption
    E_qCDK[c,t]$(tx0[t])..
      qCDK[c,t] * pCDK[c,t-1]/fp =E= pC[c,t-1]/fp * qC[c,t] + pCTurist[c,t-1]/fp * qCTurist[c,t];
    E_pCDK[c,t]$(tx0[t]).. vC[c,t] + vCTurist[c,t] =E= pCDK[c,t] * qCDK[c,t];
    E_uIO0_c_pub[c,t]$(tx0[t] and d1IO[c,'off',t]).. qIO[c,'off',t] =E= rqIO2qG[c,t] * qG[gTot,t];

    # Opgørelse af investeringer aggregeret over brancher
    E_pI[i,t]$(tx0[t]).. pI[i,t] * qI[i,t] =E= vI[i,t];
    E_qI[i,t]$(tx0[t]).. pI[i,t-1]/fp * qI[i,t] =E= sum(s, pI_s[i,s,t-1]/fp * qI_s[i,s,t]);

    # --------------------------------------------------------------------------------------------------------------------
    # Beregn manglende priser og værdier
    # --------------------------------------------------------------------------------------------------------------------   
    E_pR[r,t]$(tx0[t]).. pR[r,t] * qR[r,t] =E= vR[r,t];
 
    E_pCTurist[c,t]$(tx0[t] and d1CTurist[c,t]).. pCTurist[c,t] =E= fpCTurist[c,t] * pC[c,t];
    E_vCTurist[c,t]$(tx0[t] and d1CTurist[c,t]).. vCTurist[c,t] =E= pCTurist[c,t] * qCTurist[c,t];
    E_pC[c,t]$(tx0[t]).. pC[c,t] * qC[c,t] =E= vC[c,t];

    E_vI_sp[i,sp,t]$(tx0[t] and d1I_s[i,sp,t]).. pI_s[i,sp,t] * qI_s[i,sp,t] =E= vI_s[i,sp,t];

    E_pI_s[i,s,t]$(tx0[t] and d1I_s[i,s,t] and not iL[i]).. pI_s[i,s,t] =E= fpI_s[i,t] * upI_s[i,s,t] * pI[i,t];
    E_fpI_s[k,t]$(tx0[t] and tForecast[t]).. vI[k,t] =E= sum(s, vI_s[k,s,t]);
    E_pI_s_inventory[s,t]$(tx0[t] and d1I_s['iL',s,t]).. pI_s['iL',s,t] =E= pIO['iL',s,t];

    # --------------------------------------------------------------------------------------------------------------------
    # Efterspørgselskomponenter fordeles på brancher (CES-efterspørgsel med elasticitet=0)
    # --------------------------------------------------------------------------------------------------------------------
    # Budgetbegrænsning
    E_vR[r,t]$(tx0[t]).. vR[r,t] =E= sum(s, vIO[r,s,t]);
    E_vI[i,t]$(tx0[t]).. vI[i,t] =E= sum(s, vIO[i,s,t]);
    E_vC[c,t]$(tx0[t]).. vC[c,t] + vCTurist[c,t] =E= sum(s, vIO[c,s,t]);
    E_vG[g,t]$(tx0[t]).. vG[g,t] =E= sum(s, vIO[g,s,t]);
    E_vXy[x,t]$(tx0[t] and not xTur[x]).. vXy[x,t] =E= sum(s, vIOy[x,s,t]); 
    E_vXy_xTur[t]$(tx0[t]).. vXy['xTur',t] =E= sum(c, vCTurist[c,t]);
    E_vXm[x,t]$(tx0[t]).. vXm[x,t] =E= sum(s, vIOm[x,s,t]); 

    # Efterspørgselkomponenter fordeles på brancher
    E_qIO_r[r,s,t]$(tx0[t] and d1IO[r,s,t]).. qIO[r,s,t] =E= uIO[r,s,t] * qR[r,t];
    E_qIO_c[c,s,t]$(tx0[t] and d1IO[c,s,t]).. qIO[c,s,t] =E= uIO[c,s,t] * qCDK[c,t];
    E_qIO_i[k,s,t]$(tx0[t] and d1IO[k,s,t]).. qIO[k,s,t] =E= uIO[k,s,t] * qI[k,t];
    E_qIO_iL[s,t]$(tx0[t] and d1IO['iL',s,t]).. qIO['iL',s,t] =E= qI_s['iL',s,t];
    E_qIO_g[g,s,t]$(tx0[t] and d1IO[g,s,t]).. qIO[g,s,t] =E= uIO[g,s,t] * qG[g,t];
    E_uIO0_i_pub[i,t]$(tx0[t] and d1IO[i,'off',t]).. qIO[i,'off',t] =E= rqIO2qYoff[i,t] * qY['off',t];

    E_pIO[d,s,t]$(tx0[t] and d1IO[d,s,t] and dux[d]).. pIO[d,s,t] * qIO[d,s,t] =E= vIO[d,s,t];

    # --------------------------------------------------------------------------------------------------------------------
    # Eksport særbehandles da vi her vælger mellem egenproduktion og import (til reeksport) før vi uddeler på brancher
    # --------------------------------------------------------------------------------------------------------------------
    E_qIOy_x[x,s,t]$(tx0[t] and d1IOy[x,s,t] and not xTur[x])..
      qIOy[x,s,t] =E= uIOXy[x,s,t] * qXy[x,t];
    E_qIOm_x[x,s,t]$(tx0[t] and d1IOm[x,s,t])..
      qIOm[x,s,t] =E= uIOXm[x,s,t] * qXm[x,t];

    # --------------------------------------------------------------------------------------------------------------------
    # Den samlede leverance fra branche s til efterspørgsel d deles i import og egenproduktion
    # --------------------------------------------------------------------------------------------------------------------
    # Budgetbegrænsning
    E_vIO[d,s,t]$(tx0[t] and d1IO[d,s,t]).. vIO[d,s,t] =E= vIOy[d,s,t] + vIOm[d,s,t];
    E_vIOy[d,s,t]$(tx0[t] and d1IOy[d,s,t]).. vIOy[d,s,t] =E= pIOy[d,s,t] * qIOy[d,s,t];
    E_vIOm[d,s,t]$(tx0[t] and d1IOm[d,s,t]).. vIOm[d,s,t] =E= pIOm[d,s,t] * qIOm[d,s,t];

    # Priser på egenproduktion og import bestemmes af input
    E_pIOy[d,s,t]$(tx0[t] and d1IOy[d,s,t])..
      pIOy[d,s,t] =E= (1 + tIOy[d,s,t]) * (1 + jpIOy[d,t] - jrmarkup[s,t]) / (1 + tIOy[d,s,tBase]) * pY[s,t];
    E_pIOm[d,s,t]$(tx0[t] and d1IOm[d,s,t])..
      pIOm[d,s,t] =E= (1 + tIOm[d,s,t]) * (1 + jpIOm[d,t] - jfpM[s,t]) / (1 + tIOm[d,s,tBase]) * pM[s,t];

    # Kortsigts-træghed
    E_rpIOm2pIOy[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and d1IOy[dux,s,t-1] and d1IOm[dux,s,t-1] and eIO.l[dux,s] > 0)..
      rpIOm2pIOy[dux,s,t] =E= rpIOm2pIOy[dux,s,t-1]**rpMTraeghed[dux,s] * (pIOm[dux,s,t]/pIOy[dux,s,t])**(1-rpMTraeghed[dux,s]);

    E_rpIOm2pIOy_ingen_historik[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and not (d1IOy[dux,s,t-1] and d1IOm[dux,s,t-1]) and eIO.l[dux,s] > 0)..
      rpIOm2pIOy[dux,s,t] =E= pIOm[dux,s,t]/pIOy[dux,s,t];

    # CES-efterspørgsel
    # Import
    E_qIOm[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and (d1IOy[dux,s,t-1] and d1IOm[dux,s,t-1]) and eIO.l[dux,s] > 0)..
      qIOm[dux,s,t] * uIOy[dux,s,t] * rpIOm2pIOy[dux,s,t]**eIO[dux,s] =E= uIOm[dux,s,t] * qIOy[dux,s,t];

    E_qIOm_NoLag[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t]  and (not d1IOy[dux,s,t-1] or not d1IOm[dux,s,t-1]) and eIO.l[dux,s] > 0)..
      qIOm[dux,s,t] * uIOy[dux,s,t] * rpIOm2pIOy[dux,s,t]**eIO[dux,s] =E= uIOm[dux,s,t] * qIOy[dux,s,t];

    E_qIOm_NoY[dux,s,t]$(tx0[t] and d1IOm[dux,s,t] and not d1IOy[dux,s,t] and eIO.l[dux,s] > 0)..
      qIOm[dux,s,t] =E= uIOm[dux,s,t] * qIO[dux,s,t] * (pIOm[dux,s,t] / pIO[dux,s,t])**(-eIO[dux,s]);

    E_qIOm_e0[dux,s,t]$(tx0[t] and d1IOm[dux,s,t] and eIO.l[dux,s] = 0)..
      qIOm[dux,s,t] =E= uIOm[dux,s,t] * qIO[dux,s,t];

    # Egenproduktion
    E_qIOy[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0)..
       qIO[dux,s,t] =E= (
          uIOy[dux,s,t]**(1/eIO[dux,s]) * qIOy[dux,s,t]**((eIO[dux,s]-1)/eIO[dux,s])
        + uIOm[dux,s,t]**(1/eIO[dux,s]) * qIOm[dux,s,t]**((eIO[dux,s]-1)/eIO[dux,s])
      )**(eIO[dux,s]/(eIO[dux,s]-1));

    E_qIOy_il[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] = 0)..
      qIOy[dux,s,t] =E= uIOy[dux,s,t] * qIO[dux,s,t];

    E_qIOy_NoM[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and not d1IOm[dux,s,t] and eIO.l[dux,s] > 0)..
      qIOy[dux,s,t] =E= uIOy[dux,s,t] * qIO[dux,s,t] * (pIOy[dux,s,t] / pIO[dux,s,t])**(-eIO[dux,s]);

    E_qIOy_e0[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and not d1IOm[dux,s,t] and eIO.l[dux,s] = 0)..
      qIOy[dux,s,t] =E= uIOy[dux,s,t] * qIO[dux,s,t];

    # --------------------------------------------------------------------------------------------------------------------
    # Endogen balancering af skala-parametre
    # --------------------------------------------------------------------------------------------------------------------
    E_uIO[dux,s,t]$(tx0[t] and d1IO[dux,s,t] and not iL[dux])..
      uIO[dux,s,t] =E= fuIO[dux,t] * uIO0[dux,s,t] / sum(ss, uIO0[dux,ss,t]);

    E_uIOy[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t])..
      uIOy[dux,s,t] =E= fuIOym[dux,s,t] * (1 - uIOm0[dux,s,t]**(1-juIOm[s,t]));
    E_uIOm[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t])..
      uIOm[dux,s,t] =E= fuIOym[dux,s,t] * uIOm0[dux,s,t]**(1-juIOm[s,t]);
    E_uIOy_NoM[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and not d1IOm[dux,s,t])..
      uIOy[dux,s,t] =E= fuIOym[dux,s,t];
    E_uIOm_NoY[dux,s,t]$(tx0[t] and d1IOm[dux,s,t] and not d1IOy[dux,s,t])..
      uIOm[dux,s,t] =E= fuIOym[dux,s,t];

    E_uIOXy[x,s,t]$(tx0[t] and d1IOy[x,s,t])..
      uIOXy[x,s,t] =E= fuIOXy[x,t] * uIOXy0[x,s,t] / sum(ss, uIOXy0[x,ss,t]);
    E_uIOXm[x,s,t]$(tx0[t] and d1IOm[x,s,t])..
      uIOXm[x,s,t] =E= fuIOXm[x,t] * uIOXm0[x,s,t] / sum(ss, uIOXm0[x,ss,t]);

    # Leverencer fra udvinding til eksport skaleres med indelandsk produktion af udvinding.
    # Øvrige leverencer tager tilpasning via. skalering i E_uIOXy.
    E_uIOXy0_udv[x,t]$(tx0[t] and d1IOy[x,'udv',t])..
      uIOXy0[x,'udv',t] =E= uIOXyUdv0[x,t] * qY['udv',t] / qY['udv',tBase];

    # --------------------------------------------------------------------------------------------------------------------
    # Rand-totaler beregnes og opdeles i priser/mænger vha. kædeindeks
    # --------------------------------------------------------------------------------------------------------------------
    E_pY_tot[t]$(tx0[t]).. pY[sTot,t] * qY[sTot,t] =E= vY[sTot,t];
    E_qY_tot[t]$(tx0[t]).. qY[sTot,t] * pY[sTot,t-1]/fp =E= sum(s, pY[s,t-1]/fp * qY[s,t]);
    E_vY_tot[t]$(tx0[t]).. vY[sTot,t] =E= sum(s, vY[s,t]);

    E_pY_spTot[t]$(tx0[t]).. pY[spTot,t] * qY[spTot,t] =E= vY[spTot,t];
    E_qY_spTot[t]$(tx0[t]).. qY[spTot,t] * pY[spTot,t-1]/fp =E= sum(sp, pY[sp,t-1]/fp * qY[sp,t]);
    E_vY_spTot[t]$(tx0[t]).. vY[spTot,t] =E= sum(sp, vY[sp,t]);

    E_pY_sByTot[t]$(tx0[t]).. pY[sByTot,t] * qY[sByTot,t] =E= vY[sByTot,t];
    E_qY_sByTot[t]$(tx0[t]).. qY[sByTot,t] * pY[sByTot,t-1]/fp =E= sum(sBy, pY[sBy,t-1]/fp * qY[sBy,t]);
    E_vY_sByTot[t]$(tx0[t]).. vY[sByTot,t] =E= sum(sBy, vY[sBy,t]);

    E_vM_tot[t]$(tx0[t]).. vM[sTot,t] =E= sum(s, vM[s,t]);
    E_pM_tot[t]$(tx0[t]).. pM[sTot,t] * qM[sTot,t] =E= vM[sTot,t];
    E_qM_tot[t]$(tx0[t]).. qM[sTot,t] * pM[sTot,t-1]/fp =E= sum(s, pM[s,t-1]/fp * qM[s,t]);

    E_pX[x,t]$(tx0[t]).. pX[x,t] * qX[x,t] =E= vX[x,t];
    E_vX[x,t]$(tx0[t]).. vX[x,t] =E= vXy[x,t] + vXm[x,t];
    E_pX_xTot[t]$(tx0[t]).. pX[xTot,t] * qX[xTot,t] =E= vX[xTot,t];
    E_vX_xTot[t]$(tx0[t]).. vX[xTot,t] =E= sum(x, vX[x,t]);

    E_pBruttoHandel[t]$(tx0[t]).. pBruttoHandel[t] * qBruttoHandel[t] =E= vX[xTot,t] + vM[sTot,t]; 
    E_qBruttoHandel[t]$(tx0[t])..
      pBruttoHandel[t-1]/fp * qBruttoHandel[t] =E= pX[xTot,t-1]/fp * qX[xTot,t] + pM[sTot,t-1]/fp * qM[sTot,t]; 
    E_qHandelsbalance[t]$(tx0[t]).. qHandelsbalance[t] =E= vHandelsbalance[t] / pBruttoHandel[t];
    E_vHandelsbalance[t]$(tx0[t]).. vHandelsbalance[t] =E= vX[xTot,t] - vM[sTot,t];

    E_pXy[x,t]$(tx0[t]).. pXy[x,t] * qXy[x,t] =E= vXy[x,t];
    E_pXy_xTot[t]$(tx0[t]).. pXy[xTot,t] * qXy[xTot,t] =E= vXy[xTot,t];
    E_vXy_xTot[t]$(tx0[t]).. vXy[xTot,t] =E= sum(x, vXy[x,t]);

    E_pXm[x,t]$(tx0[t] and d1Xm[x,t]).. pXm[x,t] * qXm[x,t] =E= vXm[x,t];
    E_pXm_xTot[t]$(tx0[t]).. pXm[xTot,t] * qXm[xTot,t] =E= vXm[xTot,t];
    E_vXm_xTot[t]$(tx0[t]).. vXm[xTot,t] =E= sum(x, vXm[x,t]);

    E_qI_iTot_sTot[t]$(tx0[t]).. qI[iTot,t] * pI[iTot,t-1]/fp =E= sum(i, pI[i,t-1]/fp * qI[i,t]);
    E_vI_iTot_sTot[t]$(tx0[t]).. vI[iTot,t] =E= sum(i, vI[i,t]);
    E_pI_iTot_sTot[t]$(tx0[t]).. pI[iTot,t] * qI[iTot,t] =E= vI[iTot,t];

    E_pR_tot[t]$(tx0[t]).. pR[rTot,t] * qR[rTot,t] =E= vR[rTot,t];
    E_qR_tot[t]$(tx0[t]).. qR[rTot,t] * pR[rTot,t-1]/fp =E= sum(r, pR[r,t-1]/fp * qR[r,t]);
    E_vR_tot[t]$(tx0[t]).. vR[rTot,t] =E= sum(r, vR[r,t]);

    E_pR_spTot[t]$(tx0[t]).. pR[spTot,t] * qR[spTot,t] =E= vR[spTot,t];
    E_qR_spTot[t]$(tx0[t]).. qR[spTot,t] * pR[spTot,t-1]/fp =E= sum(sp, pR[sp,t-1]/fp * qR[sp,t]);
    E_vR_spTot[t]$(tx0[t]).. vR[spTot,t] =E= sum(sp, vR[sp,t]);

    E_pR_sByTot[t]$(tx0[t]).. pR[sByTot,t] * qR[sByTot,t] =E= vR[sByTot,t];
    E_qR_sByTot[t]$(tx0[t]).. qR[sByTot,t] * pR[sByTot,t-1]/fp =E= sum(sBy, pR[sBy,t-1]/fp * qR[sBy,t]);
    E_vR_sByTot[t]$(tx0[t]).. vR[sByTot,t] =E= sum(sBy, vR[sBy,t]);

    E_pC_tot[t]$(tx0[t]).. pC[cTot,t] * qC[cTot,t] =E= vC[cTot,t];
    E_qC_tot[t]$(tx0[t]).. qC[cTot,t] * pC[cTot,t-1]/fp =E= sum(c, pC[c,t-1]/fp * qC[c,t]);
    E_vC_tot[t]$(tx0[t]).. vC[cTot,t] =E= sum(c, vC[c,t]);

    E_pG[g_,t]$(tx0[t]).. pG[g_,t] =E= vG[g_,t] / qG[g_,t];
    E_vG_dgu[gNest,t]$(tx0[t])..
      vG[gNest,t] =E= sum(g_$(gNest2g_(gNest,g_)), vG[g_,t]);

    E_vIOy_sTot[d,t]$(tx0[t] and d1IOy[d,sTot,t])..
      vIOy[d,sTot,t] =E= sum(s, vIOy[d,s,t]);
    E_vIOm_sTot[d,t]$(tx0[t] and d1IOm[d,sTot,t])..
      vIOm[d,sTot,t] =E= sum(s, vIOm[d,s,t]);

    E_vIOy_dTots[dTots,s,t]$(tx0[t] and d1IOy[dTots,s,t])..
      vIOy[dTots,s,t] =E= sum(d$dTots2d[dtots,d], vIOy[d,s,t]);
    E_vIOm_dTots[dTots,s,t]$(tx0[t] and d1IOm[dTots,s,t])..
      vIOm[dTots,s,t] =E= sum(d$dTots2d[dtots,d], vIOm[d,s,t]); 

    # Branchevise samlede investeringer
    E_qI_iTot_s[s,t]$(tx0[t]).. qI_s[iTot,s,t] * pI_s[iTot,s,t-1]/fp =E= sum(i, pI_s[i,s,t-1]/fp * qI_s[i,s,t]);
    E_pI_iTot_s[s,t]$(tx0[t]).. pI_s[iTot,s,t] * qI_s[iTot,s,t] =E= vI_s[iTot,s,t];
    E_vI_iTot_s[s,t]$(tx0[t]).. vI_s[iTot,s,t] =E= sum(i, vI_s[i,s,t]);

    # Boliger og lagerinvesteringer er ikke en del af private erhvervsinvesteringer
    E_pI_s_spTot[i,t]$(tx0[t] and not iL[i])..
      pI_s[i,spTot,t] * qI_s[i,spTot,t] =E= vI_s[i,spTot,t];
    E_qI_s_spTot[i,t]$(tx0[t] and not iL[i])..
      qI_s[i,spTot,t] * pI_s[i,spTot,t-1]/fp =E= sum(sp, pI_s[i,sp,t-1]/fp * qI_s[i,sp,t])
                                               - iB[i] * (pI_s[i,'bol',t-1]/fp * qIBolig[t]);
    E_vI_s_spTot[i,t]$(tx0[t] and not iL[i])..
      vI_s[i,spTot,t] =E= sum(sp, vI_s[i,sp,t]) - iB[i] * vIBolig[t];
    E_vI_s_iTot_spTot[t]$(tx0[t])..
      vI_s[iTot,spTot,t] =E= sum(sp, vI_s[iTot,sp,t]) - vIBolig[t];

    E_pI_s_sByTot[k,t]$(tx0[t])..
      pI_s[k,sByTot,t] * qI_s[k,sByTot,t] =E= vI_s[k,sByTot,t];
    E_qI_s_sByTot[k,t]$(tx0[t])..
      qI_s[k,sByTot,t] * pI_s[k,sByTot,t-1]/fp =E= sum(sBy, pI_s[k,sBy,t-1]/fp * qI_s[k,sBy,t]);
    E_vI_s_sByTot[k,t]$(tx0[t])..
      vI_s[k,sByTot,t] =E= sum(sBy, vI_s[k,sBy,t]);
  $ENDBLOCK

  MODEL M_IO /
    B_IO
    pIO(d1IO), pIOy(d1IOy), pIOm(d1IOm)
    pCTurist(d1CTurist)
    pI_s(d1I_s)
    qIO(d1IO)
    qIOy(d1IOy)
    qIOm(d1IOm)
    qI_s(d1I_s)
    vI_s(d1I_s)
    vIO(d1IO)
    vIOy(d1IOy)
    vIOm(d1IOm)
    vCTurist(d1CTurist)
  /;

  # Equations that do not need to be solved together with the full model and can instead be solved afterwards.
  MODEL M_IO_post /
    E_pI_s_spTot, E_pI_iTot_s, E_pI_s_sByTot
    E_qI_s_spTot, E_qI_iTot_s, E_qI_s_sByTot
    E_vI_s_spTot, E_vI_s_sByTot
    E_vIOy_sTot, E_vIOy_dTots
    E_vIOm_sTot, E_vIOm_dTots
    E_qHandelsbalance,  E_vHandelsbalance, E_pBruttoHandel, E_qBruttoHandel
  /;

  # Endogenous variables that are solved for only after the main model.
  # Note that these may not appear anywhere in the main model (this results in a model not square error).
  $GROUP G_IO_post
    pI_s[i_,s_,t]$(spTot[s_] or sByTot[s_] or iTot[i_])
    qI_s[i_,s_,t]$(spTot[s_] or sByTot[s_] or iTot[i_])
    vI_s[i_,s_,t]$(spTot[s_] or sByTot[s_])
    vIOy$(sTot[s_] or dTots[d_])
    vIOm$(sTot[s_] or dTots[d_])
    vHandelsbalance, qHandelsbalance, pBruttoHandel, qBruttoHandel
  ;
  $GROUP G_IO_post G_IO_post$(tx0[t]);
$ENDIF


$IF %stage% == "exogenous_values":
# =============================================================================================½=========================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_IO_makrobk
    # Prices 
    pIOy$(d[d_])
    pIOm$(d[d_])
    pX, pIO$(d[d_]), pM, pCTurist$(d1CTurist[c,t]), pG, pC
    pY$(s[s_] or sTot[s_] or spTot[s_])
    pXy$(x[x_] or xTot[x_]), pXm$(x[x_] or xTot[x_]), 
    pCDK$(t.val < 2016 and c[c_]),     
    pI_s$(s[s_] or (k[i_] and (sByTot[s_] or spTot[s_])))
    pI
    pBNP
    pBVT$(s[s_] or sTot[s_])
    pR$(r[r_] or rTot[r_])
    # Values 
    vIO$(s[s_] and d[d_]), vIOy$(s[s_] and not dTots[d_]), vIOm$(s[s_] and not dTots[d_])
    vY$(s[s_] or sTot[s_])
    vC
    vCTurist, vG, vI_s$(i[i_] and s[s_])
    VX, vI, vM 
    vR$(r[r_])
    vBVT$(sTot[s_] or s[s_])
    vBNP
    # Quantities
    qIO$(s[s_] and d[d_]), qIOy$(s[s_]), qIOm$(s[s_]), qM, 
    qY$(s[s_] or sTot[s_])
    qX, qR$(r[r_] or rtot[r_])
    qI_s$(s[s_] and i[i_] or (k[i_] and sByTot[s_])), qC$(not cTot[c_]), 
    qCDK, 
    qC$(cTot[c_])
    qBVT$(s[s_] or sTot[s_])
    qBNP
    qI
    qK$(not sByTot[s_])
  ;
  @load(G_IO_makrobk, "..\Data\makrobk\makrobk.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_IO_data
    G_IO_makrobk
  ;
  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_IO_data_imprecise
    pY$(spTot[s_])
    qR$(rtot[r_])
    pBNP, qBNP, vBNP
    pBVT$(tje[s_])
    qC$(cTot[c_]), vC$(cTot[c_]) 
    vR$(tje[r_] or soff[r_])
    qBVT$(sTot[s_] or tje[s_] or soff[s_]),  
    vBVT$( sTot[s_] or tje[s_] or soff[s_])
    vY$(sTot[s_] or tje[s_])
    qI
    qY$(sTot[s_] or tje[s_])
    pI
    pI_s$(spTot[s_] and iB[i_]), 
  # Disse er rykket over ved Aug21Data - da der er uoverensstemmelser her
    pR$(r[r_] or rTot[r_])
    pBVT$(s[s_] or sTot[s_])  
    vR$(r[r_]), 
    vBVT$(s[s_]),
    qBVT$(s[s_]), 
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  eIO.l[d,s] = 2; # Estimering udestår

  # Import til reeksport skal ikke reagere på relative priser
  eIO.l[x,s] = 0;
  # Lagerinvesteringer skal ikke reagere på relative priser
  eIO.l['iL',s] = 0;

  # Udvinding er i store træk eksogent - produktionen er eksogen og importandel er modelleret anderledes
  eIO.l[d,'udv'] = 0;
  eIO.l['udv',s] = 0;

  # Energiimport afhænger i meget højere grad af andre faktorer end priserne og elasticiteten er sat til 0
  eIO.l[d,'ene'] = 0;

  # Elasticitet for importandele sættes til 0, hvor der kun er meget små leverancer, jf. nedenfor (under data assignment)

  # Fastsættelse af kortsigtstrægheder
  rpMTraeghed.l[dux,s] = 0.7;

  # Elasticitet mellem import og indenlandske input sat tæt på 1 for at få en ren overgang beskrevet ovenfor (kan ikke være 1 med CES formulering)
  eIO.l[g,s] = 1.01;

# ======================================================================================================================
# Data assignment
# ======================================================================================================================  
  # Skøn for output fra udvindingsbranchen, som ikke er underlagt nordsøbeskatning etc.
  qGrus.l[t] = 2.5 / growth_factor[t];

  fpI_s.l[i,t] = 1;

  pBVT.l[s_,t]$(tBase[t] and not s[s_]) = 1;
  pY.l[s_,t]$(tBase[t] and not s[s_]) = 1;
  pR.l[r_,t]$(tBase[t] and not r[r_]) = 1;
  pI_s.l[i_,s_,t]$(tBase[t] and iTot[i_]) = 1;
  pBruttoHandel.l[t]$(tBase[t]) = 1;

  # Create dummies base on IO data
  # IO cells are exogenized if their value is very close to zero
  parameter min_cell_size[t]; min_cell_size[t] = 1e-9;
  d1IOy[d,s,t] = abs(qIOy.l[d,s,t]) > min_cell_size[t];
  d1IOm[d,s,t] = abs(qIOm.l[d,s,t]) > min_cell_size[t];

  d1I_s[i_,s,t] = abs(vI_s.l[i_,s,t]) > min_cell_size[t];
  d1K[k,s,t]    = (qK.l[k,s,t] > 0);

  d1IOy[dTots,s,t] = sum(d$dTots2d[dTots,d], d1IOy[d,s,t]);
  d1IOm[dTots,s,t] = sum(d$dTots2d[dTots,d], d1IOm[d,s,t]);
  d1IOy[d_,sTot,t] = sum(s, d1IOy[d_,s,t]);
  d1IOm[d_,sTot,t] = sum(s, d1IOm[d_,s,t]);
  d1IO[d_,s_,t] = d1IOy[d_,s_,t] or d1IOm[d_,s_,t];
  d1I_s[iTot,s,t] = sum(i, d1I_s[i,s,t]);
  d1I_s[i,sByTot,t] = sum(sBy, d1I_s[i,sBy,t]);

  d1K[k,sTot,t]  = sum(s, d1K[k,s,t]);
  d1K[k,sByTot,t]  = sum(sBy, d1K[k,sBy,t]);
  d1K[k,spTot,t]  = sum(sp, d1K[k,sp,t]);
  d1K[kTot,s_,t] = sum(k, d1K[k,s_,t]);
  d1Xy[x_,t] = d1IOy[x_,sTot,t];
  d1Xy['xTur',t] = yes;
  d1Xm[x_,t] = d1IOm[x_,sTot,t];

  # Celler med leverancer mindre end 0.1 mia. kr. i enten qIOy eller qIOm sidste historiske år får en elasticitet på 0 (sikrer robusthed for solver)
  eIO.l[d,s] = eIO.l[d,s] * (qIOy.l[d,s,'%cal_deep%'] > 0.1 and qIOm.l[d,s,'%cal_deep%'] > 0.1);

  # Start-værdier for initialt laggede værdier
  rpIOm2pIOy.l[dux,s,t]$(d1IOy[dux,s,t] and d1IOm[dux,s,t]) = pIOm.l[dux,s,t]/pIOy.l[dux,s,t];
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_IO_static_calibration
    G_IO_endo

    -pIO$(not iL[d_] and dux_[d_]), uIO0[dux,s_,t]$(d1IO[dux,s_,t]), rqIO2qYoff, rqIO2qG
    fuIO[dux,t] # E_fuIO

    -qIOy, fuIOym[dux,s,t]$(d1IO[dux,s,t]), uIOXy0[x,s,t]$(d1IOy[x,s,t] and not udv[s]), uIOXyUdv0[x,t]$(d1IOy[x,'udv',t])
    fuIOXy[x_,t] # E_fuIOXy

    -qIOm, uIOm0[dux,s,t]$(d1IOm[dux,s,t]), uIOXm0[x,s,t]$(d1IOm[x,s,t])
    fuIOXm[x_,t] # E_fuIOXm

    -pCTurist, fpCTurist

    -pI_s$(k[i_] and s[s_]), upI_s$(k[i])

    -qC[c_,t]$(cBol[c_]), qY[s_,t]$(bol[s_])
    -juIOm$(udv[s]), qY$(udv[s_])
  ;
  $GROUP G_IO_static_calibration
    G_IO_static_calibration$(tx0[t])
    pI_s$(t0[t] and iTot[i_]), -pI_s$(tBase[t] and iTot[i_])
    pR$(t0[t] and (spTot[r_] or sByTot[r_])), -pR$(tBase[t] and(spTot[r_] or sByTot[r_]))
    pY$(t0[t] and (sByTot[s_])), -pY$(tBase[t] and(sByTot[s_]))
    pBVT$(t0[t] and (sByTot[s_] or spxtot[s_] or spTot[s_])), -pBVT$(tBase[t] and(sByTot[s_] or spxtot[s_] or spTot[s_]))
    pBruttoHandel$(t0[t]), -pBruttoHandel$(tBase[t])
  ;

  $BLOCK B_IO_static_calibration   
    E_fuIO[dux,t]$(tx0[t] and sum(s, d1IO[dux,s,t]) and not iL[dux]).. sum(s, uIO0[dux,s,t]) =E= 1;
    E_fuIOXy[x,t]$(tx0[t] and not xTur[x])..  sum(s, uIOXy0[x,s,t]) =E= 1;
    E_fuIOXm[x,t]$(tx0[t] and d1Xm[x,t])..  sum(s, uIOXm0[x,s,t]) =E= 1;

    # We replace E_uIOy and E_uIOm with variants without the adjustment term in data years
    # as there are negative coefficients in data for which exponents are not allowed
    E_uIOy_tData[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and tData[t])..
      uIOy[dux,s,t] =E= fuIOym[dux,s,t] * (1 - uIOm0[dux,s,t]);
    E_uIOm_tData[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and tData[t])..
      uIOm[dux,s,t] =E= fuIOym[dux,s,t] * uIOm0[dux,s,t];
  $ENDBLOCK
  MODEL M_IO_static_calibration /
    M_IO
    B_IO_static_calibration
    -E_uIOy -E_uIOm
  /;
$ENDIF


# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_IO_deep
    G_IO_endo
    -juIOm$(udv[s] and tData[t]), qY$(udv[s_] and tData[t])
  ;
  $GROUP G_IO_deep G_IO_deep$(tx0[t]);

  $BLOCK B_IO_deep
    @copy_equation_to_period_as(E_uIOy, tx1, _deep)
    @copy_equation_to_period_as(E_uIOm, tx1, _deep)
  $ENDBLOCK

  MODEL M_IO_deep /
    M_IO - M_IO_post
    B_IO_deep
    E_uIOy_tData, E_uIOm_tData -E_uIOy -E_uIOm # E_uIOy_deep, E_uIOm_deep
  /;
$ENDIF

# ======================================================================================================================
# Simple dynamic calibration
# ======================================================================================================================
$IF %stage% == "simple_dynamic_calibration":
  $GROUP G_IO_dynamic_calibration
    G_IO_endo
    -juIOm$(udv[s] and tData[t]), qY$(udv[s_] and tData[t])
  ;
  $GROUP G_IO_dynamic_calibration G_IO_dynamic_calibration$(tx0[t]);
  $BLOCK B_IO_dynamic_calibration
    @copy_equation_to_period_as(E_uIOy, tx1, _simple_dynamic)
    @copy_equation_to_period_as(E_uIOm, tx1, _simple_dynamic)
  $ENDBLOCK
  MODEL M_IO_dynamic_calibration /
    M_IO - M_IO_post
    B_IO_dynamic_calibration
    E_uIOy_tData, E_uIOm_tData -E_uIOy -E_uIOm # E_uIOy_simple_dynamic, E_uIOm_simple_dynamic
  /;
$ENDIF
