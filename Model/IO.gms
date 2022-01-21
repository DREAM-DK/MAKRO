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
  $GROUP G_IO_prices
    pY[s_,t]$(sTot[s_] or spTot[s_]) "Produktionsdeflator fordelt på brancher, Kilde: ADAM[pX] eller ADAM[pX<i>]"
    pM[s_,t]$(sTot[s_]) "Importdeflator fordelt på importgrupper, Kilde: ADAM[pM] eller ADAM[pM<i>]"
    pBNP[t] "BNP-deflator, Kilde: ADAM[pY]"
    pBVT[s_,t] "BVT-deflator, Kilde: ADAM[pyf] eller ADAM[pyf<i>]"

    pIO[d_,s,t]$(d1IO[d_,s,t] and dux_[d_]) "Imputeret deflator for branchefordelte leverancer fra både import og indenlandsk produktion fordelt på efterspørgselskomponenter."
    pIOy[d_,s,t]$(d1IOy[d_,s,t]) "Imputeret deflator for branchefordelte leverancer fra indenlandsk produktion fordelt på efterspørgselskomponenter."
    pIOm[d_,s,t]$(d1IOm[d_,s,t]) "Imputeret deflator for branchefordelte leverancer fra import fordelt på efterspørgselskomponenter."

    pX[x_,t] "Eksportdeflator fordelt på eksportgrupper, Kilde: ADAM[pe] eller ADAM[pe<i>]"
    pXm[x,t]$(d1Xm[x,t]) "Deflator på import til reeksport."
    pXy[x,t] "Deflator på direkte eksport."
    pR[r_,t] "Deflator på materialeinput fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[pV] eller ADAM[pv<i>]"
    pCDK[c_,t] "Forbrugsdeflator fordelt på forbrugsgrupper, Kilde: ADAM[pcp] eller ADAM[pC<i>]"
    pCTurist[c,t]$(d1CTurist[c,t]) "Price index of tourists consumption by consumption group."
    pG[g_,t] "Deflator for offentligt forbrug, Kilde: ADAM[pco]"
    pI[i_,t] "Investeringsdeflator fordelt på investeringstyper, Kilde: ADAM[pI] eller ADAM[pim] eller ADAM[pib]"
    pI_s[i_,s_,t]$(d1I_s[i_,s_,t]) "Investeringsdeflator fordelt på brancher, Kilde: ADAM[pI<i>] eller ADAM[pim<i>] eller ADAM[pib<i>]"

    pC[c_,t]$(c[c_] or cTot[c_]) "Imputeret prisindeks for forbrugskomponenter for husholdninger - dvs. ekskl. turisters forbrug."
  ;
  $GROUP G_IO_quantities
    qY[s_,t] "Produktion fordelt på brancher, Kilde: ADAM[fX]"
    qM[s_,t] "Import fordelt på importgrupper, Kilde: ADAM[fM] eller ADAM[fM<i>]"
    qBNP[t] "BNP, Kilde: ADAM[fY]"
    qBVT[s_,t] "BVT, Kilde: ADAM[fYf] eller ADAM[fYf<i>]"

    qGrus[t] "Eksogen mængde af produktion fra udvindingsbranche som ikke udfases, men heller ikke indgår i Nordsøbeskatning."

    qIO[d_,s_,t]$(d1IO[d_,s_,t] and dux_[d_]) "Imputeret branchefordelte leverancer fra både import og indenlandsk produktion fordelt på efterspørgselskomponenter."
    qIOy[d_,s_,t]$(d1IOy[d_,s_,t]) "Imputeret branchefordelte leverancer fra indenlandsk produktion fordelt på efterspørgselskomponenter."
    qIOm[d_,s_,t]$(d1IOm[d_,s_,t]) "Imputeret branchefordelte leverancer fra import fordelt på efterspørgselskomponenter."

    qX[x_,t]$(xTot[x_]) "Eksport fordelt på eksportgrupper, Kilde: ADAM[fE] eller ADAM[fE<i>]"
    qR[r_,t]$(rTot[r_] or spTot[r_]) "Materialeinput fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[fV] eller ADAM[fV<i>]"
    qCDK[c,t] "Det private forbrug fordelt på forbrugsgrupper, Kilde: ADAM[fCp] eller ADAM[fC<i>]"
    qC[c_,t]$(cTot[c_]) "Husholdningernes samlede forbrug fordelt på forbrugsgrupper og aggregater inkl. lejebolig og imputeret ejerbolig."
    qI[i_,t] "Investeringer fordelt på investeringstype, Kilde: ADAM[fI] eller ADAM[fIm] eller ADAM[fIb]"  
    qI_s[i_,s_,t]$(d1I_s[i_,s_,t] and iTot[i_]) "Investeringer fordelt på brancher, Kilde: ADAM[fI<i>] eller ADAM[fIm<i>] eller ADAM[fIb<i>]"
  ;
  $GROUP G_IO_values
    vY[s_,t] "Produktionsværdi fordelt på brancher, Kilde: ADAM[X] eller ADAM[X<i>]"
    vM[s_,t] "Import fordelt på importgrupper, Kilde: ADAM[M] eller ADAM[M<i>]"
    vBNP[t] "BNP, Kilde: ADAM[Y]"
    vBVT[s_,t] "BVT, Kilde: ADAM[Yf] eller ADAM[Yf<i>]"

    vIO[d_,s_,t]$(d1IO[d_,s_,t]) "Imputeret branchefordelte leverancer fra både import og indenlandsk produktion fordelt på efterspørgselskomponenter."
    vIOy[d_,s_,t]$(d1IOy[d_,s_,t]) "Imputeret branchefordelte leverancer fra indenlandsk produktion fordelt på efterspørgselskomponenter."
    vIOm[d_,s_,t]$(d1IOm[d_,s_,t]) "Imputeret branchefordelte leverancer fra import fordelt på efterspørgselskomponenter."

    vX[x_,t] "Eksport fordelt på eksportgrupper, Kilde: ADAM[E] eller ADAM[E<i>]"
    vXy[x,t] "Direkte export fordelt på eksportgrupper."
    vR[r_,t] "Materialeinput fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[V] eller ADAM[V<i>]"
    vC[c_,t]$(cTot[c_] or c[c_]) "Det private forbrug fordelt på forbrugsgrupper, Kilde: ADAM[Cp] eller ADAM[C<i>]"
    vCTurist[c,t]$(d1CTurist[c,t]) "Turisters forbrug i Danmark fordelt på forbrugsgrupper."
    vG[g_,t] "Offentligt forbrug, Kilde: ADAM[Co]"
    vI[i_,t] "Investeringer fordelt på investeringstype, Kilde: ADAM[I] eller ADAM[Im] eller ADAM[iB]"
    vI_s[i_,s_,t]$(d1I_s[i_,s_,t] and not (k[i_] and sOff[s_])) "Investeringer fordelt på brancher, Kilde: ADAM[I<i>] eller ADAM[Im<i>] eller ADAM[iB<i>]"
  ;

  $GROUP G_IO_exogenous_forecast
    qY[s_,t]$(sameas[s_,'udv'])
    qGrus[t]
  ;
  $GROUP G_IO_ARIMA_forecast
    uIO0[dux,s_,t] "Skalaparameter for efterspørgselskomponents vægt på diverse input før endelig skalering."
    uIOm0[dux,s,t] "Importandel i efterspørgselskomponent."
    uIOXy0[x,s,t] "Skalaparameter for eksportkomponents vægt på diverse indenlandske input før endelig skalering."
    uIOXm0[x,s,t] "Skalaparameter for eksportkomponents vægt på diverse importerede input før endelig skalering."
    fuIO[dux,t] "Korrektionsfaktor for skalaparametrene for efterspørgselskomponents vægt på diverse input."
    fuIOym[dux,s,t] "Korrektionsfaktor for skalaparametrene for efterspørgselskomponents vægt på diverse hhv. indenlandske og importerede input."
    fuXm[x,t] "Korrektionsfaktor for skalaparametrene for efterspørgselskomponents vægt på diverse input."
    fuXy[x,t] "Korrektionsfaktor for skalaparametrene for efterspørgselskomponents vægt på diverse input."
    upI_s[i,s,t] "Skalaparameter som fanger forskelle i branchernes investerings-deflatorer for samme investeringstype."
    fpCTurist[c,t] "Korrektion som fanger at turisters forbrug har anden deflator end indenlandske husholdninger."
  ;
  $GROUP G_IO_other
    eIO[d_,s] "Substitutionselasticitet mellem import og indenlandsk produktion for diverse input for efterspørgselskomponenterne."
    rMerPris[d_,t] "Pristillæg fra mermarkup på leverancer til eksport - eD 0 historisk."
    rvIO2vOffNyInv[i,t] "Andel af offentlige direkte investeringer, der går til investeringsgruppe i."
    eG[g_] "Substitutionselasticitet mellem diverse input for efterspørgselskomponenterne."
    rvIO2vPublicSales[c,t] "Andel af offentligt salg fordelt på efterspørgselskomponenter der modtager leverancer."
    rpMTraeghed[d_,s] "Parameter til at styre kortsigtet priselasticitet."
    rMKortsigt[d_,s] "Parameter til at styre kortsigtet importgennemslag."
  ;

  $GROUP G_IO_endo
    G_IO_prices
    G_IO_values
    G_IO_quantities, -qGrus

    juIOm[s,t]$(sameas[s,'udv']) "J-led."
    -qY$(sameas[s_,'udv']) # E_jIOm sætter juIOm['udv'] = -juIOXy['udv',t] for at ramme qY[udv]
    juIOXy[s,t]$(sameas[s,'udv']) "J-led."

    # Skalaparameter (endogene pga. balancerings-mekanismer)
    uIO[d_,s,t] "Skalaparameter for efterspørgselskomponents vægt på diverse input."
    uIOy[dux,s,t] "Skalaparameter for efterspørgselskomponents vægt på diverse indenlandske input."
    uIOm[dux,s,t] "Skalaparameter for efterspørgselskomponents vægt på diverse importerede input."
    uIOXy[x,s,t] "Skalaparameter for eksportkomponents vægt på diverse indenlandske input."
    uIOXm[x,s,t] "Skalaparameter for eksportkomponents vægt på diverse importerede input."

    fpI_s[i,t]$(tForecast[t]) "Korrektionsfaktor som sørger for at vI_s summerer til vI."

    # vI fastholder en eksogen fordeling af offentlige nyinvesteringer på investeringstyper.
    # De tilhørende skalaparametre er endogene.
    uIO0[dux,s_,t]$(i_[dux] and sOff[s_] and d1IO[dux,s_,t])

    # Alt offentligt salg til privat forbrug antages at gå til forbrug af øvrige tjenester.
    # Den tilhørende skalaparameter er endogen.
    uIO0[dux,s_,t]$(c_[dux] and sOff[s_] and d1IO[dux,s_,t])

    qC[c_,t]$(sameas[c_,'cBol'])
    -qY[s_,t]$(sameas[s_,'bol'])

    rpIOm2pIOy[d_,s,t] "Relativ pris mellem import og egenproduktion."
    pXUdl[x_,t]$(xTot[x_]) "Eksportkonkurrende udenlandsk pris, Kilde: ADAM[pee<i>]"
    fqMKortsigt[dux,s,t] "Konjunkturbidrag til importandel."
  ;
  $GROUP G_IO_endo G_IO_endo$(tx0[t]); # Restrict endo group to tx0[t]
$ENDIF


# ======================================================================================================================
# Equations  
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_IO
    # --------------------------------------------------------------------------------------------------------------------
    # Markedsligevægt
    # --------------------------------------------------------------------------------------------------------------------
    E_qY[s,t]$(tx0[t]).. qY[s,t] =E= sum(d$d1IOy[d,s,t], qIOy[d,s,t]);
    E_qM[s,t]$(tx0[t]).. qM[s,t] =E= sum(d$d1IOm[d,s,t], qIOm[d,s,t]);

    E_vY[s,t]$(tx0[t]).. vY[s,t] =E= pY[s,t] * qY[s,t];
    E_vM[s,t]$(tx0[t]).. vM[s,t] =E= pM[s,t] * qM[s,t];

    # --------------------------------------------------------------------------------------------------------------------
    # Aggregater
    # --------------------------------------------------------------------------------------------------------------------   
    E_pBNP[t]$(tx0[t]).. pBNP[t] * qBNP[t] =E= vBNP[t];
    E_qBNP[t]$(tx0[t])..
      qBNP[t] * pBNP[t-1]/fp =E= ( pC[cTot,t-1]/fp * qC[cTot,t]
                                 + pG[gTot,t-1]/fp * qG[gTot,t] 
                                 + pI[iTot,t-1]/fp * qI[iTot,t]
                                 + pX[xTot,t-1]/fp * qX[xTot,t] 
                                 - pM[sTot,t-1]/fp * qM[sTot,t] );
    E_vBNP[t]$(tx0[t]).. vBNP[t] =E= vC[cTot,t] + vI[iTot,t] + vG[gTot,t] + vX[xTot,t] - vM[sTot,t];

    # Kæde-indeks for branche-fordelt BVT
    E_qBVT[s,t]$(tx0[t]).. qBVT[s,t] * pBVT[s,t-1]/fp =E= (pY[s,t-1]/fp * qY[s,t] - pR[s,t-1]/fp * qR[s,t]);
    E_pBVT[s,t]$(tx0[t]).. pBVT[s,t] * qBVT[s,t] =E= vBVT[s,t];
    E_vBVT[s,t]$(tx0[t]).. vBVT[s,t] =E= vY[s,t] - vR[s,t];

    # Kæde-indeks for samlet BVT
    E_qBVT_tot[t]$(tx0[t]).. qBVT[sTot,t] * pBVT[sTot,t-1]/fp =E= (pY[sTot,t-1]/fp * qY[sTot,t] - pR[rTot,t-1]/fp * qR[rTot,t]);
    E_pBVT_tot[t]$(tx0[t]).. pBVT[sTot,t] * qBVT[sTot,t] =E= vBVT[sTot,t];
    E_vBVT_tot[t]$(tx0[t]).. vBVT[sTot,t] =E= vY[sTot,t] - vR[rTot,t];

    E_qBVT_spTot[t]$(tx0[t]).. qBVT[spTot,t] * pBVT[spTot,t-1]/fp =E= (pY[spTot,t-1]/fp * qY[spTot,t] - pR[spTot,t-1]/fp * qR[spTot,t]);
    E_pBVT_spTot[t]$(tx0[t]).. pBVT[spTot,t] * qBVT[spTot,t] =E= vBVT[spTot,t];
    E_vBVT_spTot[t]$(tx0[t]).. vBVT[spTot,t] =E= vY[spTot,t] - vR[spTot,t];

    # Consumption is chain-aggregate of household and tourist consumption
    E_qCDK[c,t]$(tx0[t])..
      qCDK[c,t] * pCDK[c,t-1]/fp =E= pC[c,t-1]/fp * qC[c,t] + pCTurist[c,t-1]/fp * qCTurist[c,t];
    E_pCDK[c,t]$(tx0[t]).. vC[c,t] + vCTurist[c,t] =E= pCDK[c,t] * qCDK[c,t];
    E_uIO0_c_pub[c,t]$(tx0[t] and d1IO[c,'off',t])..
      vIO[c,'off',t] =E= rvIO2vPublicSales[c,t] * vOffY2C[t];

    # Opgørelse af investeringer aggregeret over brancher
    E_pI[i,t]$(tx0[t] and t.val).. pI[i,t] * qI[i,t] =E= vI[i,t];
    E_qI[i,t]$(tx0[t] and t.val).. pI[i,t-1]/fp * qI[i,t] =E= sum(s, pI_s[i,s,t-1]/fp * qI_s[i,s,t]);

    # Branchevise samlede investeringer
    E_vI_iTot_s[s,t]$(tx0[t]).. vI_s[iTot,s,t] =E= sum(i, vI_s[i,s,t]);

    E_vI_s_iTot_spTot[t]$(tx0[t]).. vI_s[iTot,spTot,t] =E= sum(sp, vI_s[iTot,sp,t]) - vIBolig[t];

    # --------------------------------------------------------------------------------------------------------------------
    # Beregn manglende priser og værdier
    # --------------------------------------------------------------------------------------------------------------------   
    E_pR[r,t]$(tx0[t]).. pR[r,t] * qR[r,t] =E= vR[r,t];
 
    E_pCTurist[c,t]$(tx0[t] and d1CTurist[c,t]).. pCTurist[c,t] =E= fpCTurist[c,t] * pC[c,t];
    E_vCTurist[c,t]$(tx0[t] and d1CTurist[c,t]).. vCTurist[c,t] =E= pCTurist[c,t] * qCTurist[c,t];
    E_pC[c,t]$(tx0[t]).. pC[c,t] * qC[c,t] =E= vC[c,t];

    E_vI_sp[i,sp,t]$(tx0[t] and d1I_s[i,sp,t]).. pI_s[i,sp,t] * qI_s[i,sp,t] =E= vI_s[i,sp,t];

    E_pI_s[i,s,t]$(tx0[t] and d1I_s[i,s,t] and not sameas[i,'iL']).. pI_s[i,s,t] =E= fpI_s[i,t] * upI_s[i,s,t] * pI[i,t];
    E_fpI[k,t]$(tx0[t] and tForecast[t]).. vI[k,t] =E= sum(s, vI_s[k,s,t]);

    E_pI_s_inventory[s,t]$(tx0[t] and d1I_s['iL',s,t]).. pI_s['iL',s,t] =E= pIO['iL',s,t];

    # --------------------------------------------------------------------------------------------------------------------
    # Efterspørgselskomponenter fordeles på brancher (CES-efterspørgsel med elasticitet=0)
    # --------------------------------------------------------------------------------------------------------------------
    # Budgetbegrænsning
    E_vR[r,t]$(tx0[t]).. vR[r,t] =E= sum(s, vIO[r,s,t]);
    E_vI[i,t]$(tx0[t]).. vI[i,t] =E= sum(s, vIO[i,s,t]);
    E_vC[c,t]$(tx0[t]).. vC[c,t] + vCTurist[c,t] =E= sum(s, vIO[c,s,t]);
    E_vG[g,t]$(tx0[t]).. vG[g,t] =E= sum(s, vIO[g,s,t]);
    E_vX[x,t]$(tx0[t] and not sameas[x,'xTur']).. vX[x,t] =E= sum(s, vIO[x,s,t]);
    E_vX_xTur[t]$(tx0[t]).. vX['xTur',t] =E= sum(c, vCTurist[c,t]);

    # Efterspørgsel
    E_qIO_r[r,s,t]$(tx0[t] and d1IO[r,s,t]).. qIO[r,s,t] =E= uIO[r,s,t] * qR[r,t];  
    E_qIO_c[c,s,t]$(tx0[t] and d1IO[c,s,t]).. qIO[c,s,t] =E= uIO[c,s,t] * qCDK[c,t];
    E_qIO_i[k,s,t]$(tx0[t] and d1IO[k,s,t]).. qIO[k,s,t] =E= uIO[k,s,t] * qI[k,t];
    E_qIO_iL[s,t]$(tx0[t] and d1IO['iL',s,t]).. qIO['iL',s,t] =E= qI_s['iL',s,t];
    E_qIO_g[g,s,t]$(tx0[t] and d1IO[g,s,t])..
      qIO[g,s,t] =E= uIO[g,s,t] * (pG[g,t] / pIO[g,s,t])**eG[g] * qG[g,t];
    E_uIO0_i_pub[i,t]$(tx0[t] and d1IO[i,'off',t])..
      vIO[i,'off',t] =E= rvIO2vOffNyInv[i,t] * vOffDirInv[t];

    E_pIO[d,s,t]$(tx0[t] and d1IO[d,s,t] and dux[d]).. pIO[d,s,t] * qIO[d,s,t] =E= vIO[d,s,t];

    # --------------------------------------------------------------------------------------------------------------------
    # Eksport særbehandles da vi her vælger mellem egenproduktion og import (til reeksport) før vi uddeler på brancher
    # --------------------------------------------------------------------------------------------------------------------
    E_qIOy_x[x,s,t]$(tx0[t] and d1IOy[x,s,t])..
      qIOy[x,s,t] =E= uIOXy[x,s,t] * qXy[x,t];
    E_qIOm_x[x,s,t]$(tx0[t] and d1IOm[x,s,t])..
      qIOm[x,s,t] =E= uIOXm[x,s,t] * qXm[x,t];

    # --------------------------------------------------------------------------------------------------------------------
    # Priser på egenproduktion og import bestemmes af input
    # --------------------------------------------------------------------------------------------------------------------    
    E_pIOy[d,s,t]$(tx0[t] and d1IOy[d,s,t])..
      pIOy[d,s,t] =E= (1 + tIOy[d,s,t]) * (1 + rMerPris[d,t]) * pY[s,t];
    E_pIOm[d,s,t]$(tx0[t] and d1IOm[d,s,t])..
      pIOm[d,s,t] =E= (1 + tIOm[d,s,t]) * pM[s,t];

    # CES-efterspørgsel
    E_rpIOm2pIOy[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and d1IOy[dux,s,t-1] and d1IOm[dux,s,t-1] and eIO.l[dux,s] > 0)..
      rpIOm2pIOy[dux,s,t] =E= rpIOm2pIOy[dux,s,t-1]**rpMTraeghed[dux,s] * (pIOm[dux,s,t]/pIOy[dux,s,t])**(1-rpMTraeghed[dux,s]);

    E_rpIOm2pIOy_ingen_historik[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and not (d1IOy[dux,s,t-1] and d1IOm[dux,s,t-1]) and eIO.l[dux,s] > 0)..
      rpIOm2pIOy[dux,s,t] =E= pIOm[dux,s,t]/pIOy[dux,s,t];

    E_fqMKortsigt[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and d1IOy[dux,s,t-1] and d1IOm[dux,s,t-1] and eIO.l[dux,s] > 0)..
      fqMKortsigt[dux,s,t] =E= (qIO[dux,s,t] / (fv * qIO[dux,s,t-1]/fv))**rMKortsigt[dux,s]
                             * fqMKortsigt[dux,s,t-1]**(1-rMKortsigt[dux,s]);

    # --------------------------------------------------------------------------------------------------------------------
    # Den samlede leverance fra branche s til efterspørgsel d deles i import og egenproduktion
    # --------------------------------------------------------------------------------------------------------------------
    # Budgetbegrænsning
    E_vIO[d,s,t]$(tx0[t] and d1IO[d,s,t]).. vIO[d,s,t] =E= vIOy[d,s,t] + vIOm[d,s,t];
    E_vIOy[d,s,t]$(tx0[t] and d1IOy[d,s,t]).. vIOy[d,s,t] =E= pIOy[d,s,t] * qIOy[d,s,t];
    E_vIOm[d,s,t]$(tx0[t] and d1IOm[d,s,t]).. vIOm[d,s,t] =E= pIOm[d,s,t] * qIOm[d,s,t];

    E_qIOm[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and (d1IOy[dux,s,t-1] and d1IOm[dux,s,t-1]) and eIO.l[dux,s] > 0)..
      qIOm[dux,s,t] * uIOy[dux,s,t] * (rpIOm2pIOy[dux,s,t])**(eIO[dux,s]) =E= uIOm[dux,s,t] * qIOy[dux,s,t] * fqMKortsigt[dux,s,t];

    E_qIOm_NoLag[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t]  and (not d1IOy[dux,s,t-1] or not d1IOm[dux,s,t-1]) and eIO.l[dux,s] > 0)..
      qIOm[dux,s,t] * uIOy[dux,s,t] * (rpIOm2pIOy[dux,s,t])**(eIO[dux,s]) =E= uIOm[dux,s,t] * qIOy[dux,s,t];

    E_qIOy[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0)..
       qIO[dux,s,t] =E= (
          (uIOy[dux,s,t])**(1/eIO[dux,s]) * (qIOy[dux,s,t])**((eIO[dux,s]-1)/eIO[dux,s])
        + (uIOm[dux,s,t])**(1/eIO[dux,s]) * (qIOm[dux,s,t])**((eIO[dux,s]-1)/eIO[dux,s])
      )**(eIO[dux,s]/(eIO[dux,s]-1));

    E_qIOy_il[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] = 0)..
      qIOy[dux,s,t] =E= uIOy[dux,s,t] * qIO[dux,s,t]
    ;

    E_qIOy_NoM[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and not d1IOm[dux,s,t] and eIO.l[dux,s] > 0)..
      qIOy[dux,s,t] =E= uIOy[dux,s,t] * qIO[dux,s,t] * (pIOy[dux,s,t] / pIO[dux,s,t])**(-eIO[dux,s]);

    E_qIOy_e0[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and not d1IOm[dux,s,t] and eIO.l[dux,s] = 0)..
      qIOy[dux,s,t] =E= uIOy[dux,s,t] * qIO[dux,s,t];


    E_qIOm_NoY[dux,s,t]$(tx0[t] and d1IOm[dux,s,t] and not d1IOy[dux,s,t] and eIO.l[dux,s] > 0)..
      qIOm[dux,s,t] =E= uIOm[dux,s,t] * qIO[dux,s,t] * (pIOm[dux,s,t] / pIO[dux,s,t])**(-eIO[dux,s]);

    E_qIOm_e0[dux,s,t]$(tx0[t] and d1IOm[dux,s,t] and eIO.l[dux,s] = 0)..
      qIOm[dux,s,t] =E= uIOm[dux,s,t] * qIO[dux,s,t];

    # --------------------------------------------------------------------------------------------------------------------
    # Endogen balancering af skala-parametre
    # --------------------------------------------------------------------------------------------------------------------
    E_uIO[dux,s,t]$(tx0[t] and d1IO[dux,s,t] and not sameas[dux,'iL'])..
      uIO[dux,s,t] =E= fuIO[dux,t] * uIO0[dux,s,t] / sum(ss, uIO0[dux,ss,t]);

    E_uIOy[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t])..
      uIOy[dux,s,t] =E= fuIOym[dux,s,t] * (1-uIOm0[dux,s,t] * (1+juIOm[s,t]));
    E_uIOm[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t])..
      uIOm[dux,s,t] =E= fuIOym[dux,s,t] * uIOm0[dux,s,t] * (1+juIOm[s,t]);
    E_uIOy_NoM[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and not d1IOm[dux,s,t])..
      uIOy[dux,s,t] =E= fuIOym[dux,s,t];
    E_uIOm_NoY[dux,s,t]$(tx0[t] and d1IOm[dux,s,t] and not d1IOy[dux,s,t])..
      uIOm[dux,s,t] =E= fuIOym[dux,s,t];

    E_uIOXy[x,s,t]$(tx0[t] and d1IOy[x,s,t])..
      uIOXy[x,s,t] =E= fuXy[x,t] * (1+juIOXy[s,t]) * uIOXy0[x,s,t] / sum(ss, (1+juIOXy[ss,t]) * uIOXy0[x,ss,t]);
    E_uIOXm[x,s,t]$(tx0[t] and d1IOm[x,s,t])..
      uIOXm[x,s,t] =E= fuXm[x,t] * uIOXm0[x,s,t] / sum(ss, uIOXm0[x,ss,t]);

    E_juIOm_udv[t]$(tx0[t]).. juIOm['udv',t] =E= - juIOXy['udv',t];

    # --------------------------------------------------------------------------------------------------------------------
    # Rand-totaler beregnes og opdeles i priser/mænger vha. kædeindeks
    # --------------------------------------------------------------------------------------------------------------------
    E_pY_tot[t]$(tx0[t]).. pY[sTot,t] * qY[sTot,t] =E= vY[sTot,t];
    E_qY_tot[t]$(tx0[t]).. qY[sTot,t] * pY[sTot,t-1]/fp =E= sum(s, pY[s,t-1]/fp * qY[s,t]);
    E_vY_tot[t]$(tx0[t]).. vY[sTot,t] =E= sum(s, vY[s,t]);

    E_pY_spTot[t]$(tx0[t]).. pY[spTot,t] * qY[spTot,t] =E= vY[spTot,t];
    E_qY_spTot[t]$(tx0[t]).. qY[spTot,t] * pY[spTot,t-1]/fp =E= sum(sp, pY[sp,t-1]/fp * qY[sp,t]);
    E_vY_spTot[t]$(tx0[t]).. vY[spTot,t] =E= sum(sp, vY[sp,t]);

    E_vM_tot[t]$(tx0[t]).. vM[sTot,t] =E= sum(s, vM[s,t]);
    E_pM_tot[t]$(tx0[t]).. pM[sTot,t] * qM[sTot,t] =E= vM[sTot,t];
    E_qM_tot[t]$(tx0[t]).. qM[sTot,t] * pM[sTot,t-1]/fp =E= sum(s, pM[s,t-1]/fp * qM[s,t]);

    E_pXUdl_tot[t]$(tx0[t]).. pXUdl[xTot,t] =E= sum(x, pXUdl[x,t] * qX[x,t]) / qX[xTot,t];

    E_pXy[x,t]$(tx0[t] and d1Xy[x,t]).. pXy[x,t] =E= sum(s$(d1IOy[x,s,t]), uIOXy[x,s,t] * pIOy[x,s,t]); 
    E_pXm[x,t]$(tx0[t] and d1Xm[x,t]).. pXm[x,t] =E= sum(s$(d1IOm[x,s,t]), uIOXm[x,s,t] * pIOm[x,s,t]);  
    E_pX[x,t]$(tx0[t]).. pX[x,t] * qX[x,t] =E= vX[x,t];
    E_vXy[x,t]$(tx0[t] and d1Xy[x,t]).. vXy[x,t] =E= sum(s$(d1IOy[x,s,t]), vIOy[x,s,t]); 


    E_pX_tot[t]$(tx0[t]).. pX[xTot,t] * qX[xTot,t] =E= vX[xTot,t];
    E_vX_tot[t]$(tx0[t]).. vX[xTot,t] =E= sum(x, vX[x,t]) ; 
    E_qX_tot[t]$(tx0[t]).. qX[xTot,t] * pX[xTot,t-1]/fp =E= sum(x, pX[x,t-1]/fp * qX[x,t]);

    E_qI_iTot_sTot[t]$(tx0[t]).. qI[iTot,t] * pI[iTot,t-1]/fp =E= sum(i, pI[i,t-1]/fp * qI[i,t]);
    E_vI_iTot_sTot[t]$(tx0[t]).. vI[iTot,t] =E= sum(i, vI[i,t]);
    E_pI_iTot_sTot[t]$(tx0[t]).. pI[iTot,t] * qI[iTot,t] =E= vI[iTot,t];

    E_pR_tot[t]$(tx0[t]).. pR[rTot,t] * qR[rTot,t] =E= vR[rTot,t];
    E_qR_tot[t]$(tx0[t]).. qR[rTot,t] * pR[rTot,t-1]/fp =E= sum(r, pR[r,t-1]/fp * qR[r,t]);
    E_vR_tot[t]$(tx0[t]).. vR[rTot,t] =E= sum(r, vR[r,t]);

    E_pR_spTot[t]$(tx0[t]).. pR[spTot,t] * qR[spTot,t] =E= vR[spTot,t];
    E_qR_spTot[t]$(tx0[t]).. qR[spTot,t] * pR[spTot,t-1]/fp =E= sum(sp, pR[sp,t-1]/fp * qR[sp,t]);
    E_vR_spTot[t]$(tx0[t]).. vR[spTot,t] =E= sum(sp, vR[sp,t]);

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

    #  E_vIOy_dTot[dTots,s,t]$(tx0[t] and d1IOy[dTots,s,t])..
    #    vIOy[dTots,s,t] =E= sum(d$dTots2d[dtots,d], vIOy[d,s,t]);
    #  E_vIOm_dTot[dTots,s,t]$(tx0[t] and d1IOm[dTots,s,t])..
    #    vIOy[dTots,s,t] =E= sum(d$dTots2d[dtots,d], vIOm[d,s,t]); 
  $ENDBLOCK
$ENDIF