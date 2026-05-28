# ======================================================================================================================
# Public sector production
# - Public sector demand for factors of production
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":  
  $GROUP G_production_public_variables
    # Prices
    pOffAfskr[i_,t] "Deflator for offentlige afskrivninger, Kilde: ADAM[pinvo1], ADAM[pinvmo1] eller ADAM[pinvbo1]"
    pOffNyInvx[t] "Deflator for offentlige nyinvesteringer ekskl. direkte investeringer, Kilde: ADAM[pifro1ny]"
    # Tabel-variable
    pOffNyInv[t] "Deflator for offentlige nyinvesteringer inkl. direkte investeringer, Kilde: ADAM[pifo1ny]"
    pYOffInput[t] "Deflator for offentlig produktion ved input-metoden, Kilde: ADAM[pxo1gl]"
    pLOffInput[t] "Deflator for offentlig lønsum ved input-metoden, Kilde: ADAM[pywo1gl]"
    ptNetYOff[t] "Deflator for offentlige produktionsskatter i faste priser, Kilde: ADAM[pspz_xo1]"
    pOffDirInv[t] "Pris på egenproduktion til investering i offentlig forvaltning og service, Kilde: ADAM[pxo1i]"
    pOffIndirInv[t] "Pris på den offentlige sektors nettokøb af bygninger o.a. eksisterende investeringsgoder"
    pGIndMarked[t] "Deflator for offentlig individuel konsumudgift (sociale ydelser i naturalier), markedsmæssig, Kilde: ADAM[pcoim)]"
    pOffSalg[t] "Deflator for offentlig sektors salg af varer og tjenester, Kilde: ADAM[pxo1_p)]"

    # Quantities
    qOffAfskr[i_,t] "Offentlige afskrivninger, Kilde: ADAM[fInvo1], ADAM[fInvmo1] eller ADAM[fInvbo1]"
    qOffNyInvx[t] "Offentlige nyinvesteringer ekskl. direkte investeringer, Kilde: ADAM[fIfro1ny]"
    qK[i_,s_,t] "Ultimokapital fordelt efter kapitaltype og branche, Kilde: ADAM[fKnm<i>] eller ADAM[fKnb<i>]"   
    # Tabel-variable
    qOffNyInv[t] "Offentlige nyinvesteringer inkl. direkte investeringer, Kilde: ADAM[fIfo1ny]"
    qOffIndirInv[t] "Den offentlige sektors nettokøb af bygninger o.a. eksisterende investeringsgoder"
    qOffDirInv[t] "Direkte offentlige investeringer i forskning og udvikling, mængde, Kilde: ADAM[fXo1i]"
    qYOffInput[t] "Offentlig produktion i faste priser ved input-metoden, Kilde: ADAM[fXo1gl]"
    qLOffInput[t] "Offentlig lønsum i faste priser ved input-metoden, Kilde: ADAM[fYwo1gl]"
    qtNetYOff[t] "Offentlige produktionsskatter i faste priser, Kilde: ADAM[fSpz_xo1]"
    qY[off,t] "Produktion fordelt for offentlig sektor, Kilde: ADAM[fX]"
    qGIndMarked[t] "Real offentlig individuel konsumudgift (sociale ydelser i naturalier), markedsmæssig, Kilde: ADAM[fcoim)]"
    qOffSalg[t] "Offentlig sektors salg af varer og tjenester, mængde, Kilde: ADAM[fxo1_p)]"

    # Values
    vOffAfskr[i_,t] "Offentlige afskrivninger, Kilde: ADAM[Invo1], ADAM[Invmo1] eller ADAM[Invbo1]"
    vI_s[i_,s_,t] "Investeringer fordelt på brancher, Kilde: ADAM[I<i>] eller ADAM[iM<i>] eller ADAM[iB<i>]"
    vOffDirInv[t] "Direkte offentlige investeringer i forskning og udvikling, værdi, Kilde: ADAM[Xo1i]"
    vOffIndirInv[t] "Den offentlige sektor nettokøb af bygninger o.a. eksisterende investeringsgoder, Kilde: ADAM[Io1a]"
    vOffNyInvx[t] "Faste nyinvesteringer i off. sektor, ekskl. investeringer i forskning og udvikling, Kilde: ADAM[Ifro1ny]"
    vfYOffInput[t] "Offentlig produktion i foregående års priser ved input-metoden, Kilde: ADAM[pXo1gl][-1]*ADAM[fXo1gl]"
    # Tabel-variable
    vOffNyInv[t] "Offentlige nyinvesteringer inkl. direkte investeringer, Kilde: ADAM[Ifo1ny]"
    vY[s_,t] "Produktionsværdi fordeltfor offentlig sektor, Kilde: ADAM[X] eller ADAM[X<i>]"
    vGIndMarked[t] "Nominel offentlig individuel konsumudgift (sociale ydelser i naturalier), markedsmæssig, Kilde: ADAM[coim)]"
    vOffSalg[t] "Offentlig sektors salg af varer og tjenester, værdi, Kilde: ADAM[xo1_p)]"
    rOffIB2NyInvx[t] "Andel af offentlige nyinvesteringer ekskl. direkte inv., som er bygninger."
    rpOffAfskr[t] "Relative laggede priser for offentlige afskrivninger vægtet med nutidige mængder."
    rpOffNyInvx[t] "Relative laggede priser for nyinvesteringer ekskl. direkte investeringer vægtet med nutidige mængder."
    rpOffNyInv[t] "Relative laggede priser for nyinvesteringer vægtet med nutidige mængder."
    rpY[s_,t] "Relative laggede output-priser vægtet med nutidige mængder."
  ;

  $GROUP G_production_public_exogenous_forecast
    rOffK2Y[k,t] "Offentlig kapital relativt til vægtet gennemsnit af offentlig og privat produktion."
  ;
  $GROUP+ G_exogenous_forecast G_production_public_exogenous_forecast$(tx1[t]);

  $GROUP G_production_public_forecast_as_zero
    jfpOffAfskr[k,t] "J-led, som afspejler forskel mellem deflatoren for offentlige afskrivninger og investeringer."
    jfqOffAfskr[k,t] "J-led, som afspejler forskel mellem deflatoren for offentlige afskrivninger og investeringer."
    jfpOffNyInvx[t] "J-led, som afspejler forskel mellem deflatoren for offentlige investeringer og nyinvesteringer."
    jfpOffNyInv[t] "J-led"
    jfpOffIndirInv[t] "J-led"
    jfqIO_g_off[t] "J-led"
  ;
  $GROUP+ G_forecast_as_zero G_production_public_forecast_as_zero$(tx1[t]);

  $GROUP G_production_public_ARIMA_forecast
    # Offentlig produktivitet fremskrives eksogent i FM-baseline
    uL[s_,t]$(off[s_])
    fqLOffInput[t] "Korrektionsfaktor - dækker over uddannelsessammensætning af offentligt ansatte"
  ;
  $GROUP+ G_ARIMA_forecast G_production_public_ARIMA_forecast;

  $GROUP G_production_public_fixed_forecast
    fqtNetYOff[t] "Korrektionsfaktor - dækker over sammensætningseffekter på produktionsskatter"
    fpOffDirInv[t] "Korrektionsfaktor"
    rOffDirInv[t] "Andel af offentlig produktion til maskininvesteringer, der går direkte til offentlige investeringer."
    rvOffIndirInv2vBVT[t] "Offentligt opkøb af eksisterende kapital relativt til BVT."
    rOffLoensum2R[t] "Offentlige lønsum som andel af offentlige materialekøb (i løbende priser)."
    rOffLoensum2E[t] "Offentlige lønsum som andel af offentlige Energikøb (i løbende priser)."
    vOffDirInv2vBNP[t] "Direkte offentlige investeringer relativt til BNP."
  ;

  $GROUP+ G_fixed_forecast G_production_public_fixed_forecast;

$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
	$BLOCK B_production_public_static G_production_public_core $(tx0[t])
    $(d1I_s[i,'off',t]).. vI_s[i,'off',t] =E= pI_s[i,'off',t] * qI_s[i,'off',t];

    # Capital accumulation
    $(d1K[k,'off',t])..
      qK[k,'off',t] =E= qI_s[k,'off',t] + (1 - rAfskr[k,'off',t]) * qK[k,'off',t-1]/fq;

    # Afskrivninger / Bruttorestindkomst
    $(d1K[k,'off',t])..
      pOffAfskr[k,t] =E= (1+jfpOffAfskr[k,t]) * pI_s[k,'off',t];

    $(d1K[k,'off',t])..
      qOffAfskr[k,t] =E= (1+jfqOffAfskr[k,t]) * rAfskr[k,'off',t] * qK[k,'off',t-1]/fq;

    $(d1K[k,'off',t])..
      vOffAfskr[k,t] =E= pOffAfskr[k,t] * qOffAfskr[k,t];

    .. vOffAfskr[kTot,t] =E= sum(k, vOffAfskr[k,t]);

    rpOffAfskr[t]..
      qOffAfskr[kTot,t] =E= rpOffAfskr[t] * sum(k, qOffAfskr[k,t]);

    .. qOffAfskr[kTot,t] * pOffAfskr[kTot,t-1]/fp =E= sum(k, pOffAfskr[k,t-1]/fp * qOffAfskr[k,t]);

    .. pOffAfskr[kTot,t] * qOffAfskr[kTot,t] =E= vOffAfskr[kTot,t];

    # Offentlige materialekøb er eksogene som udgangspunkt, kan endogeniseres ved at eksogenisere dette forhold
    .. rOffLoensum2R[t] =E= vLoensum['off',t] / vR['off',t];
    .. rOffLoensum2E[t] =E= vLoensum['off',t] / vE['off',t];

    # Offentligt forbrug opgøres ved input metoden, dvs. kædeindeks af input-mængder
    $(t.val > %cal_start% and t.val > 1993)..
      vfYOffInput[t] =E= qOffAfskr[kTot,t] * pOffAfskr[kTot,t-1]/fp 
                       + qR['off',t] * pR['off',t-1]/fp
                       + qE['off',t] * pE['off',t-1]/fp
                       + qLOffInput[t] * pLOffInput[t-1]/fp
                       + qtNetYOff[t] * ptNetYOff[t-1]/fp;
    $(t.val > %cal_start% and t.val > 1993)..
      pYOffInput[t] * vfYOffInput[t] =E= vY['off',t] * pYOffInput[t-1]/fp;
    $(t.val > %cal_start% and t.val > 1993)..
      qYOffInput[t] * pYOffInput[t] =E= vY['off',t];

    $(t.val > %cal_start%).. qLOffInput[t] =E= fqLOffInput[t] * hL['off',t] / fqt[t];
    $(t.val > %cal_start%).. pLOffInput[t] =E= vLoensum['off',t] / qLOffInput[t];

    $(t.val > %cal_start% and t.val >= 1993).. qtNetYOff[t] =E= fqtNetYOff[t] * qY['off',t];
    $(t.val > %cal_start% and t.val >= 1993).. ptNetYOff[t] =E= vtNetY['off',t] / qtNetYOff[t];

    $(t.val > %cal_start%)..
      qY['off',t] * (pY['off',t-1] - vtNetY['off',t-1] / qY['off',t-1])/fp
      =E= qOffAfskr[kTot,t] * pOffAfskr[kTot,t-1]/fp 
        + qR['off',t] * pR['off',t-1]/fp
        + qE['off',t] * pE['off',t-1]/fp
        + (uL['off',t] * qProd['off',t] * hL['off',t]) * (pW[t-1]/uL['off',t-1])/fp;

    rpY['Off',t]$(t.val > %cal_start%)..
      qY['off',t] =E= rpY['off',t] * (qOffAfskr[kTot,t] + qR['off',t] + qE['off',t] 
                                      + uL['off',t] * qProd['off',t] * hL['off',t]);

    # Beskæftigelse, materialekøbe og investeringer er alle eksogene i mængder ved stød.
    .. vY['off',t] =E= vOffAfskr[kTot,t] + vLoensum['off',t] + vR['off',t] + vE["off",t] + vtNetY['off',t];

    # Purchases of existing capital follow gross value added (BVT)
    $(t.val > 1995).. vOffIndirInv[t] =E= rvOffIndirInv2vBVT[t] * vBVT[sTot,t];

    # Direkte investeringer kommer fra IO-system, men er fast andel af output (qIO[i,'off',t] =E= rqIOy2qYoff[i,t] * qY['off',t])
    .. vOffDirInv[t] =E= rOffDirInv[t] * vIO['iM','off',t];

    # Samlede offentlige investeringer = ny + direkte + indirekte (vI_s['iM','off',t] + vI_s['iB','off',t] =E= vOffNyInv[t] + vOffDirInv[t] + vOffIndirInv[t])
    # Ny-investeringer fordeles mellem bygninger og maskiner. Direkte investeringer går til maskiner, indirekte til bygninger.
    # Både maskin- og bygningsinvesteringer er eksogene - vOffNyInv og rOffIB2NyInv tager tilpasning.
    vOffNyInvx[t]$(t.val > 1995)..
      vI_s['iM','off',t] =E= (1-rOffIB2NyInvx[t]) * vOffNyInvx[t] + vOffDirInv[t];

    rOffIB2NyInvx[t]$(t.val > 1995)..
      vI_s['iB','off',t] =E= rOffIB2NyInvx[t] * vOffNyInvx[t] + vOffIndirInv[t];

    # Public direct investments in R&D as share of GDP
    vOffDirInv2vBNP[t].. vOffDirInv2vBNP[t] =E= vOffDirInv[t] / vBNP[t]; 

        # Priser og mængder på direkte investeringer, indirekte investeringer og nyinvesteringer
    $(t.val > 1995).. pOffIndirInv[t] =E= (1+jfpOffIndirInv[t]) * pI['iB',t];
    .. pOffDirInv[t] =E= fpOffDirInv[t] * pIO['iM','off',t];

    $(t.val > 1995).. qOffIndirInv[t] * pOffIndirInv[t] =E= vOffIndirInv[t];
    .. qOffDirInv[t] * pOffDirInv[t] =E= vOffDirInv[t];

    rpOffNyInvx[t]$(t.val > 1995).. 
      qOffNyInvx[t] =E= rpOffNyInvx[t] * (qI_s['iM','off',t] + qI_s['iB','off',t] - qOffIndirInv[t] - qOffDirInv[t]);
    $(t.val > 1995).. 
      qOffNyInvx[t] * pOffNyInvx[t-1]/fp =E= qI_s['iM','off',t] * pI_s['iM','off',t-1]/fp 
                                           + qI_s['iB','off',t] * pI_s['iB','off',t-1]/fp
                                           - qOffIndirInv[t] * pOffIndirInv[t-1]/fp
                                           - qOffDirInv[t] * pOffDirInv[t-1]/fp;
    $(t.val > 1995).. pOffNyInvx[t] * qOffNyInvx[t] =E= vOffNyInvx[t];

    # Tabel-variable 
    # Offentlige nyinvesteringer inkl. direkte investeringer
    $(t.val > 1995).. vOffNyInv[t] =E= vOffNyInvx[t] + vOffDirInv[t];
    rpOffNyInv[t]$(t.val > 1995).. 
      qOffNyInv[t]=E= rpOffNyInv[t] * (qOffNyInvx[t] + qOffDirInv[t]);
    $(t.val > 1995).. 
      qOffNyInv[t] * pOffNyInv[t-1]/fv =E= qOffNyInvx[t] * pOffNyInvx[t-1]/fv 
                                         + qOffDirInv[t] * pOffDirInv[t-1]/fv;
    $(t.val > 1995).. pOffNyInv[t] * qOffNyInv[t] =E= vOffNyInv[t];

    # Offentlig markedsmæssig individuelt forbrug
    .. vGIndMarked[t] =E= vG[gTot,t] - vIO['g','Off',t];
    .. qGIndMarked[t] * pGIndMarked[t-1]/fp =E= qG[gTot,t] * pG[gTot,t-1]/fp 
                                                - (1 + jfqIO_g_off[t]) 
                                                  * qIO['g','Off',t] * pIO['g','Off',t-1]/fp;
    .. pGIndMarked[t] * qGIndMarked[t] =E= vGIndMarked[t];

    # Offentliges salg af varer og tjenester
    .. vOffSalg[t] =E= vY['off',t] - vG[gTot,t] + vGIndMarked[t]- vOffDirInv[t];
    $(t.val > 1995).. qOffSalg[t] * pOffSalg[t-1]/fp =E= qY['off',t] * pY['off',t-1]/fp 
                                                       - qG[gTot,t] * pG[gTot,t-1]/fp 
                                                       + qGIndMarked[t] * pGIndMarked[t-1]/fp
                                                       - qOffDirInv[t] * pOffDirInv[t-1]/fp;
    $(t.val > 1995).. pOffSalg[t] =E= vOffSalg[t] / qOffSalg[t];
  $ENDBLOCK

 $BLOCK B_production_public_forwardlooking G_production_public_forwardlooking_endo $(tx0[t])
    # Real public investments, qI_s, are fixed by default and the capital ratios are endogenous
    rOffK2Y[k,t]$(d1K[k,'off',t])..
      pI_s[k,'off',t] * qK[k,'off',t] =E= rOffK2Y[k,t] * (0.7 * vBVT['off',t] + 0.3 * vVirkBVT5aarSnit[t]);
  $ENDBLOCK

  $GROUP G_production_public_endo 
    G_production_public_core
    G_production_public_forwardlooking_endo
  ;


  Model M_production_public /
    B_production_public_static
    B_production_public_forwardlooking
  /;
  model M_base / M_production_public /;


  $GROUP G_production_public_static
    G_production_public_endo 
    -rOffK2Y # -E_rOffK2Y
  ; 

  $GROUP G_production_public_static G_production_public_static$(tx0[t]) ;
  model M_static / B_production_public_static /;
  $GROUP+ G_static G_production_public_static;
  $GROUP+ G_Endo G_production_public_endo;
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
    qOffSalg, pOffSalg, vOffSalg
    qGIndMarked, pGIndMarked, vGIndMarked
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
    jfpOffIndirInv[t], -pOffIndirInv[t]
    rAfskr[k,off,t], -qK[k,off,t]
    uL[off,t], -qY[off,t]
    fqLOffInput$(t.val > %cal_start%), -qLOffInput$(t.val > %cal_start%)
    fqtNetYOff$(t.val > %cal_start%), -qtNetYOff$(t.val > %cal_start%)
    fpOffDirInv, -pOffDirInv
    jfqIO_g_off, -qGIndMarked
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
  model M_static_calibration / M_production_public_static_calibration /;
  $GROUP+ G_static_calibration G_production_public_static_calibration;

  $GROUP G_production_public_static_calibration_newdata
    G_production_public_static_calibration
   ;
  $GROUP+ G_static_calibration_newdata G_production_public_static_calibration_newdata;
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
    rqIOy2qYoff['iM',t], -vOffDirInv2vBNP[t]

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
	model M_deep_dynamic_calibration / M_production_public_deep /;
	$GROUP+ G_deep_dynamic_calibration G_production_public_deep;
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
    rqIOy2qYoff['iM',t], -vOffDirInv2vBNP[t]

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
  model M_dynamic_calibration_newdata / M_production_public_dynamic_calibration /;
  $GROUP+ G_dynamic_calibration_newdata G_production_public_dynamic_calibration;
$ENDIF
