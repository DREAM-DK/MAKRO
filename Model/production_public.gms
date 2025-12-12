# ======================================================================================================================
# Public sector production
# - Public sector demand for factors of production
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":  

	$GROUP G_production_public_endo
    
    # Prices
    pOffAfskr[i_,t]$(d1K[i_,'off',t]) "Deflator for offentlige afskrivninger, Kilde: ADAM[pinvo1], ADAM[pinvmo1] eller ADAM[pinvbo1]"
    pOffNyInvx[t]$(t.val > 1995) "Deflator for offentlige nyinvesteringer ekskl. direkte investeringer, Kilde: ADAM[pifro1ny]"
    # Tabel-variable
    pOffNyInv[t]$(t.val > 1995) "Deflator for offentlige nyinvesteringer inkl. direkte investeringer, Kilde: ADAM[pifo1ny]"
    pYOffInput[t]$(t.val > %cal_start% and t.val > 1993) "Deflator for offentlig produktion ved input-metoden, Kilde: ADAM[pxo1gl]"
    pLOffInput[t]$(t.val > %cal_start%) "Deflator for offentlig lønsum ved input-metoden, Kilde: ADAM[pywo1gl]"
    ptNetYOff[t]$(t.val > %cal_start% and t.val >= 1993) "Deflator for offentlige produktionsskatter i faste priser, Kilde: ADAM[pspz_xo1]"
    pOffDirInv[t] "Pris på egenproduktion til investering i offentlig forvaltning og service, Kilde: ADAM[pxo1i]"
    pOffIndirInv[t]$(t.val > 1995) "Pris på den offentlige sektors nettokøb af bygninger o.a. eksisterende investeringsgoder"

    # Quantities
    qOffAfskr[i_,t]$(d1K[i_,'off',t]) "Offentlige afskrivninger, Kilde: ADAM[fInvo1], ADAM[fInvmo1] eller ADAM[fInvbo1]"
    qOffNyInvx[t]$(t.val > 1995) "Offentlige nyinvesteringer ekskl. direkte investeringer, Kilde: ADAM[fIfro1ny]"
    qK[i_,s_,t]$(k[i_] and d1K[i_,s_,t] and off[s_]) "Ultimokapital fordelt efter kapitaltype og branche, Kilde: ADAM[fKnm<i>] eller ADAM[fKnb<i>]"
    
    # Tabel-variable
    qOffNyInv[t]$(t.val > 1995) "Offentlige nyinvesteringer inkl. direkte investeringer, Kilde: ADAM[fIfo1ny]"
    qOffIndirInv[t]$(t.val > 1995) "Den offentlige sektors nettokøb af bygninger o.a. eksisterende investeringsgoder"
    qOffDirInv[t] "Direkte offentlige investeringer i forskning og udvikling, Kilde: ADAM[fXo1i]"
    qYOffInput[t]$(t.val > %cal_start% and t.val > 1993) "Offentlig produktion i faste priser ved input-metoden, Kilde: ADAM[fXo1gl]"
    qLOffInput[t]$(t.val > %cal_start%) "Offentlig lønsum i faste priser ved input-metoden, Kilde: ADAM[fYwo1gl]"
    qtNetYOff[t]$(t.val > %cal_start% and t.val >= 1993) "Offentlige produktionsskatter i faste priser, Kilde: ADAM[fSpz_xo1]"
    qY[off,t]$(t.val > %cal_start%) "Produktion fordelt for offentlig sektor, Kilde: ADAM[fX]"

    # Values
    vOffAfskr[i_,t]$(d1K[i_,'off',t]) "Offentlige afskrivninger, Kilde: ADAM[Invo1], ADAM[Invmo1] eller ADAM[Invbo1]"
    vI_s[i_,s_,t]$(d1I_s[i_,s_,t] and i[i_] and off[s_]) "Investeringer fordelt på brancher, Kilde: ADAM[I<i>] eller ADAM[iM<i>] eller ADAM[iB<i>]"
    vOffDirInv[t] "Direkte offentlige investeringer i forskning og udvikling, Kilde: ADAM[Xo1i]"
    vOffIndirInv[t]$(t.val >= 1995) "Den offentlige sektor nettokøb af bygninger o.a. eksisterende investeringsgoder, Kilde: ADAM[Io1a]"
    vOffNyInvx[t]$(t.val > 1995) "Faste nyinvesteringer i off. sektor, ekskl. investeringer i forskning og udvikling, Kilde: ADAM[Ifro1ny]"
    vfYOffInput[t]$(t.val > %cal_start% and t.val > 1993) "Offentlig produktion i foregående års priser ved input-metoden, Kilde: ADAM[pXo1gl][-1]*ADAM[fXo1gl]"
    # Tabel-variable
    vOffNyInv[t]$(t.val > 1995) "Offentlige nyinvesteringer inkl. direkte investeringer, Kilde: ADAM[Ifo1ny]"
    vY[s_,t]$(off[s_]) "Produktionsværdi fordeltfor offentlig sektor, Kilde: ADAM[X] eller ADAM[X<i>]"

    rOffK2Y[k,t] "Offentlig kapital relativt til vægtet gennemsnit af offentlig og privat produktion."  
    rOffLoensum2R[t] "Offentlige lønsum som andel af offentlige materialekøb (i løbende priser)."  
    rOffLoensum2E[t] "Offentlige lønsum som andel af offentlige Energikøb (i løbende priser)."  
    vOffDirInv2vBNP[t] "Direkte offentlige investeringer relativt til BNP."
    rOffIB2NyInvx[t]$(t.val > 1995) "Andel af offentlige nyinvesteringer ekskl. direkte inv., som er bygninger."

    rpOffAfskr[t] "Relative laggede priser for offentlige afskrivninger vægtet med nutidige mængder."
    rpOffNyInvx[t] "Relative laggede priser for nyinvesteringer ekskl. direkte investeringer vægtet med nutidige mængder."
    rpOffNyInv[t] "Relative laggede priser for nyinvesteringer vægtet med nutidige mængder."
    rpY[s_,t]$(off[s_]) "Relative laggede output-priser vægtet med nutidige mængder."
	;

	$GROUP G_production_public_endo G_production_public_endo$(tx0[t]);

  $GROUP G_production_public_exogenous_forecast
    rOffK2Y
  ;
  $GROUP G_production_public_forecast_as_zero
    jfpOffAfskr[k,t] "J-led, som afspejler forskel mellem deflatoren for offentlige afskrivninger og investeringer."
    jfqOffAfskr[k,t] "J-led, som afspejler forskel mellem deflatoren for offentlige afskrivninger og investeringer."
    jfpOffNyInvx[t] "J-led, som afspejler forskel mellem deflatoren for offentlige investeringer og nyinvesteringer."
    jfpOffNyInv[t] "J-led"
  ;
  $GROUP G_production_public_ARIMA_forecast
    # Offentlig produktivitet fremskrives eksogent i FM-baseline
    uL[s_,t]$(off[s_])
    fqLOffInput[t] "Korrektionsfaktor - dækker over uddannelsessammensætning af offentligt ansatte"
  ;
  $GROUP G_production_public_fixed_forecast
    fqtNetYOff[t] "Korrektionsfaktor - dækker over sammensætningseffekter på produktionsskatter"
    fpOffDirInv[t] "Korrektionsfaktor"
    fpOffIndirInv[t] "Korrektionsfaktor"
    rOffDirInv[t] "Andel af offentlig produktion til maskininvesteringer, der går direkte til offentlige investeringer."
    rvOffIndirInv2vBVT[t] "Offentligt opkøb af eksisterende kapital relativt til BVT."
    rOffLoensum2R
    rOffLoensum2E
    vOffDirInv2vBNP
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
	$BLOCK B_production_public_static$(tx0[t])
    E_vI_s_off[i,t]$(d1I_s[i,'off',t]).. vI_s[i,'off',t] =E= pI_s[i,'off',t] * qI_s[i,'off',t];

    # Capital accumulation
    E_qK_off[k,t]$(d1K[k,'off',t])..
      qK[k,'off',t] =E= qI_s[k,'off',t] + (1 - rAfskr[k,'off',t]) * qK[k,'off',t-1]/fq;

    # Afskrivninger / Bruttorestindkomst
    E_pOffAfskr[k,t]$(d1K[k,'off',t])..
      pOffAfskr[k,t] =E= (1+jfpOffAfskr[k,t]) * pI_s[k,'off',t];

    E_qOffAfskr[k,t]$(d1K[k,'off',t])..
      qOffAfskr[k,t] =E= (1+jfqOffAfskr[k,t]) * rAfskr[k,'off',t] * qK[k,'off',t-1]/fq;

    E_vOffAfskr[k,t]$(d1K[k,'off',t])..
      vOffAfskr[k,t] =E= pOffAfskr[k,t] * qOffAfskr[k,t];

    E_vOffAfskr_tot[t]..
      vOffAfskr[kTot,t] =E= sum(k, vOffAfskr[k,t]);

    E_qOffAfskr_tot_via_rpOffAfskr[t]..
      qOffAfskr[kTot,t] =E= rpOffAfskr[t] * sum(k, qOffAfskr[k,t]);

    E_qOffAfskr_kTot[t]..
      qOffAfskr[kTot,t] * pOffAfskr[kTot,t-1]/fp =E= sum(k, pOffAfskr[k,t-1]/fp * qOffAfskr[k,t]);

    E_pOffAfskr_tot[t]..
      pOffAfskr[kTot,t] * qOffAfskr[kTot,t] =E= vOffAfskr[kTot,t];

    # Offentlige materialekøb er eksogene som udgangspunkt, kan endogeniseres ved at eksogenisere dette forhold
    E_rOffLoensum2R[t].. rOffLoensum2R[t] =E= vLoensum['off',t] / vR['off',t];
    E_rOffLoensum2E[t].. rOffLoensum2E[t] =E= vLoensum['off',t] / vE['off',t];

    # Offentligt forbrug opgøres ved input metoden, dvs. kædeindeks af input-mængder
    E_vfYOffInput[t]$(t.val > %cal_start% and t.val > 1993)..
      vfYOffInput[t] =E= qOffAfskr[kTot,t] * pOffAfskr[kTot,t-1]/fp 
                       + qR['off',t] * pR['off',t-1]/fp
                       + qE['off',t] * pE['off',t-1]/fp
                       + qLOffInput[t] * pLOffInput[t-1]/fp
                       + qtNetYOff[t] * ptNetYOff[t-1]/fp;
    E_pYOffInput[t]$(t.val > %cal_start% and t.val > 1993)..
      pYOffInput[t] * vfYOffInput[t] =E= vY['off',t] * pYOffInput[t-1]/fp;
    E_qYOffInput[t]$(t.val > %cal_start% and t.val > 1993)..
      qYOffInput[t] * pYOffInput[t] =E= vY['off',t];

    E_qLOffInput[t]$(t.val > %cal_start%).. qLOffInput[t] =E= fqLOffInput[t] * hL['off',t] / fqt[t];
    E_pLOffInput[t]$(t.val > %cal_start%).. pLOffInput[t] =E= vLoensum['off',t] / qLOffInput[t];

    E_qtNetYOff[t]$(t.val > %cal_start% and t.val >= 1993).. qtNetYOff[t] =E= fqtNetYOff[t] * qY['off',t];
    E_ptNetYOff[t]$(t.val > %cal_start% and t.val >= 1993).. ptNetYOff[t] =E= vtNetY['off',t] / qtNetYOff[t];

    E_qY_off[t]$(t.val > %cal_start%)..
      qY['off',t] * (pY['off',t-1] - vtNetY['off',t-1] / qY['off',t-1])/fp
      =E= qOffAfskr[kTot,t] * pOffAfskr[kTot,t-1]/fp 
        + qR['off',t] * pR['off',t-1]/fp
        + qE['off',t] * pE['off',t-1]/fp
        + (uL['off',t] * qProd['off',t] * hL['off',t]) * (pW[t-1]/uL['off',t-1])/fp;

    E_qY_off_via_rpY[t]$(t.val > %cal_start%)..
      qY['off',t] =E= rpY['off',t] * (qOffAfskr[kTot,t] + qR['off',t] + qE['off',t] 
                                      + uL['off',t] * qProd['off',t] * hL['off',t]);

    # Beskæftigelse, materialekøbe og investeringer er alle eksogene i mængder ved stød.
    E_vY_off[t].. vY['off',t] =E= vOffAfskr[kTot,t] + vLoensum['off',t] + vR['off',t] + vE["off",t] + vtNetY['off',t];

    # Purchases of existing capital follow gross value added (BVT)
    E_vOffIndirInv[t]$(t.val > 1995).. vOffIndirInv[t] =E= rvOffIndirInv2vBVT[t] * vBVT[sTot,t];

    # Direkte investeringer kommer fra IO-system, men er fast andel af output (qIO[i,'off',t] =E= rqIOy2qYoff[i,t] * qY['off',t])
    E_vOffDirInv[t].. vOffDirInv[t] =E= rOffDirInv[t] * vIO['iM','off',t];

    # Samlede offentlige investeringer = ny + direkte + indirekte (vI_s['iM','off',t] + vI_s['iB','off',t] =E= vOffNyInv[t] + vOffDirInv[t] + vOffIndirInv[t])
    # Ny-investeringer fordeles mellem bygninger og maskiner. Direkte investeringer går til maskiner, indirekte til bygninger.
    # Både maskin- og bygningsinvesteringer er eksogene - vOffNyInv og rOffIB2NyInv tager tilpasning.
    E_vOffNyInvx[t]$(t.val > 1995)..
      vI_s['iM','off',t] =E= (1-rOffIB2NyInvx[t]) * vOffNyInvx[t] + vOffDirInv[t];

    E_rOffIB2NyInvx[t]$(t.val > 1995)..
      vI_s['iB','off',t] =E= rOffIB2NyInvx[t] * vOffNyInvx[t] + vOffIndirInv[t];

    # Public direct investments in R&D as share of GDP
    E_vOffDirInv2vBNP[t].. vOffDirInv2vBNP[t] =E= vOffDirInv[t] / vBNP[t]; 

    # Priser og mængder på direkte investeringer, indirekte investeringer og nyinvesteringer
    E_pOffIndirInv[t]$(t.val > 1995).. pOffIndirInv[t] =E= fpOffIndirInv[t] * pI['iB',t];
    E_pOffDirInv[t].. pOffDirInv[t] =E= fpOffDirInv[t] * pIO['iM','off',t];

    E_qOffIndirInv[t]$(t.val > 1995).. qOffIndirInv[t] * pOffIndirInv[t] =E= vOffIndirInv[t];
    E_qOffDirInv[t].. qOffDirInv[t] * pOffDirInv[t] =E= vOffDirInv[t];

    E_qOffNyInvx_via_rpOffNyInvx[t]$(t.val > 1995).. 
      qOffNyInvx[t] =E= rpOffNyInvx[t] * (qI_s['iM','off',t] + qI_s['iB','off',t] - qOffIndirInv[t] - qOffDirInv[t]);
    E_qOffNyInvx[t]$(t.val > 1995).. 
      qOffNyInvx[t] * pOffNyInvx[t-1]/fp =E= qI_s['iM','off',t] * pI_s['iM','off',t-1]/fp 
                                           + qI_s['iB','off',t] * pI_s['iB','off',t-1]/fp
                                           - qOffIndirInv[t] * pOffIndirInv[t-1]/fp
                                           - qOffDirInv[t] * pOffDirInv[t-1]/fp;
    E_pOffNyInvx[t]$(t.val > 1995).. pOffNyInvx[t] * qOffNyInvx[t] =E= vOffNyInvx[t];

    # Tabel-variable 
    # Offentlige nyinvesteringer inkl. direkte investeringer
    E_vOffNyInv[t]$(t.val > 1995).. vOffNyInv[t] =E= vOffNyInvx[t] + vOffDirInv[t];
    E_qOffNyInv_via_rpOffNyInv[t]$(t.val > 1995).. 
      qOffNyInv[t]=E= rpOffNyInv[t] * (qOffNyInvx[t] + qOffDirInv[t]);
    E_qOffNyInv[t]$(t.val > 1995).. 
      qOffNyInv[t] * pOffNyInv[t-1]/fv =E= qOffNyInvx[t] * pOffNyInvx[t-1]/fv 
                                         + qOffDirInv[t] * pOffDirInv[t-1]/fv;
    E_pOffNyInv[t]$(t.val > 1995).. pOffNyInv[t] * qOffNyInv[t] =E= vOffNyInv[t];
  $ENDBLOCK

  $BLOCK B_production_public_forwardlooking$(tx0[t])
    # Real public investments, qI_s, are fixed by default and the capital ratios are endogenous
    E_rOffK2Y[k,t]$(d1K[k,'off',t])..
      pI_s[k,'off',t] * qK[k,'off',t] =E= rOffK2Y[k,t] * (0.7 * vBVT['off',t] + 0.3 * vVirkBVT5aarSnit[t]);
  $ENDBLOCK

  Model M_production_public /
    B_production_public_static
    B_production_public_forwardlooking
  /;
  $GROUP G_production_public_static
    G_production_public_endo
    -rOffK2Y # -E_rOffK2Y
  ; 
  $GROUP G_production_public_static G_production_public_static$(tx0[t]) ;
$ENDIF

$IF %stage% == "exogenous_values":
# ======================================================================================================================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_production_public_makrobk
    vOffDirInv, pOffDirInv, qOffDirInv
    qOffAfskr, pOffAfskr, vOffAfskr
    qOffNyInvx, pOffNyInvx, vOffNyInvx
    pOffNyInv, vOffNyInv, qOffNyInv
    qK$(off[s_])
    qOffIndirInv, pOffIndirInv, vOffIndirInv
    qLOffInput, qtNetYOff, qYOffInput, pLOffInput, ptNetYOff, pYOffInput
    vY[off,t], vtNetY[off,t]
  ;
  @load(G_production_public_makrobk, "../Data/Makrobk/makrobk.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_production_public_data  
    G_production_public_makrobk
  ;
  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_production_public_data_imprecise 
    pOffNyInvx, qOffNyInvx, vOffNyInvx
    pOffNyInv$(t.val >= 2021), qOffNyInv$(t.val >= 2021), vOffNyInv$(t.val >= 2021)
    vOffAfskr
    qOffAfskr$(iM[i_])
    pOffAfskr$(iM[i_] and t.val >= %cal_start%)
  ;

  # ======================================================================================================================
  # Exogenous variables
  # ======================================================================================================================
  uL.l[off,tBase] = 1;

  # ======================================================================================================================
  # Data assignment
  # ======================================================================================================================
$ENDIF



# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_production_public_static_calibration
    G_production_public_endo

    jfpOffAfskr[k,t], -pOffAfskr[k,t]
    jfqOffAfskr[k,t], -qOffAfskr[k,t]
    rvOffIndirInv2vBVT[t], -vOffIndirInv[t]
    rOffDirInv[t], -vOffDirInv[t]
    fpOffIndirInv[t], -pOffIndirInv[t]
    rAfskr[k,off,t], -qK[k,off,t]
    uL[off,t], -qY[off,t]
    fqLOffInput$(t.val > %cal_start%), -qLOffInput$(t.val > %cal_start%)
    fqtNetYOff$(t.val > %cal_start%), -qtNetYOff$(t.val > %cal_start%)
    fpOffDirInv, -pOffDirInv
  ;
  $GROUP G_production_public_static_calibration
    G_production_public_static_calibration$(tx0[t])
    uL[off,t0], -uL[off,tBase]
  ;
  # $BLOCK B_production_public_static_calibration
  # $ENDBLOCK

  MODEL M_production_public_static_calibration /
    M_production_public
    # B_production_public_static_calibration
  /;

  $GROUP G_production_public_static_calibration_newdata
    G_production_public_static_calibration
   ;
$ENDIF

# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
	$GROUP G_production_public_deep
		G_production_public_endo

    # Offentlige investeringer endogeniseres ud fra en fremskrivning af KY-forholdene
    qI_s[k,off,tx1] # E_qI_s_forecast 

    # Offentlige direkte investeringer i forskning og udvikling holdes konstant som andel af BNP
    # Andelen af nyinvesteringer som er bygninger endogeniseres
    rqIOy2qYoff[iM,t], -vOffDirInv2vBNP[t]

    qE[off,t], -rOffLoensum2E[t] # Beskæftigelse vælges ud fra fast forhold mellem lønsum og materialekøb
    qR[off,t], -rOffLoensum2R[t] # Beskæftigelse vælges ud fra fast forhold mellem lønsum og materialekøb
	;
  $GROUP G_production_public_deep G_production_public_deep$(tx0[t]);

	$BLOCK B_production_public_deep
    E_qI_s_forecast[k,t]$(tx1[t]).. # rOffK2Y changes from static to dynamic calibration due to terminal condition on moving average of private sector BVT
      rOffK2Y[k,t] =E= rOffK2Y[k,t1];
	$ENDBLOCK
	MODEL M_production_public_deep /
		M_production_public
		B_production_public_deep
	/;
$ENDIF

# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
  $GROUP G_production_public_dynamic_calibration
    G_production_public_endo

    uL[off,t1], -qY[off,t1]
    uL[off,tx1] # E_uL_off_forecast

    qI_s[k,off,tx1] # E_qI_s_forecast 
    # Offentlige direkte investeringer i forskning og udvikling holdes konstant som andel af BNP
    # Andelen af nyinvesteringer som er bygninger endogeniseres
    rqIOy2qYoff[iM,t], -vOffDirInv2vBNP[t]

    # Offentlige investeringer hopper direkte til baseline - fast K2Y giver dårlig fremskrivning på kort sigt 

    qE[off,t], -rOffLoensum2E[t] # Beskæftigelse vælges ud fra fast forhold mellem lønsum og materialekøb
    qR[off,t], -rOffLoensum2R[t] # Beskæftigelse vælges ud fra fast forhold mellem lønsum og materialekøb
  ;
  $GROUP G_production_public_dynamic_calibration G_production_public_dynamic_calibration$(tx0[t]);

	$BLOCK B_production_public_newdata
    E_uL_off_forecast[t]$(tx1[t]).. uL[off,t] =E= uL_baseline[off,t] * uL[off,t1] / uL_baseline[off,t1];
    E_qI_s_forecast[k,t]$(tx1[t]).. # rOffK2Y changes from static to dynamic calibration due to terminal condition on moving average of private sector BVT
      rOffK2Y[k,t] =E= rOffK2Y[k,t1];
	$ENDBLOCK  
  MODEL M_production_public_dynamic_calibration /
    M_production_public
    B_production_public_newdata
  /;
$ENDIF
