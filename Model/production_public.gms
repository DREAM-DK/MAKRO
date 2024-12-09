# ======================================================================================================================
# Public sector production
# - Public sector demand for factors of production
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
	$GROUP G_production_public_prices_endo
    pOffAfskr[i_,t]$(d1K[i_,'off',t]) "Deflator for offentlige afskrivninger, Kilde: ADAM[pinvo1], ADAM[pinvmo1] eller ADAM[pinvbo1]"
    pOffNyInvx[t]$(t.val > 1990) "Deflator for offentlige nyinvesteringer ekskl. direkte investeringer, Kilde: ADAM[pifro1ny]"
    # Tabel-variable
    pOffNyInv[t]$(t.val > 1995) "Deflator for offentlige nyinvesteringer inkl. direkte investeringer, Kilde: ADAM[pifo1ny]"
    pLOff_input[t]$(t.val > %cal_start%) "Deflator for offentlig lønsum ved input-metoden, Kilde: ADAM[pywo1gl]"
    pOffDirInv[t] "Pris på egenproduktion til investering i offentlig forvaltning og service, Kilde: ADAM[pxo1i]"
	;    
	$GROUP G_production_public_quantities_endo
    qOffAfskr[i_,t]$(d1K[i_,'off',t]) "Offentlige afskrivninger, Kilde: ADAM[fInvo1], ADAM[fInvmo1] eller ADAM[fInvbo1]"
    qOffNyInvx[t]$(t.val > 1990) "Offentlige nyinvesteringer ekskl. direkte investeringer, Kilde: ADAM[fIfro1ny]"
    qK[i_,s_,t]$(d1K[i_,s_,t] and off[s_]) "Ultimokapital fordelt efter kapitaltype og branche, Kilde: ADAM[fKnm<i>] eller ADAM[fKnb<i>]"
    # Tabel-variable
    qOffNyInv[t]$(t.val > 1995) "Offentlige nyinvesteringer inkl. direkte investeringer, Kilde: ADAM[fIfo1ny]"
    qLOff_input[t]$(t.val > %cal_start%) "Offentlig lønsum i faste priser ved input-metoden, Kilde: ADAM[fYwo1gl]"
    qY[off,t]$(t.val > %cal_start%) "Produktion fordelt for offentlig sektor, Kilde: ADAM[fX]"
  ;
	$GROUP G_production_public_values_endo
    vOffAfskr[i_,t]$(d1K[i_,'off',t]) "Offentlige afskrivninger, Kilde: ADAM[Invo1], ADAM[Invmo1] eller ADAM[Invbo1]"
    vI_s[i_,s_,t]$(d1I_s[i_,s_,t] and i[i_] and off[s_]) "Investeringer fordelt på brancher, Kilde: ADAM[I<i>] eller ADAM[iM<i>] eller ADAM[iB<i>]"
    vOffDirInv[t]$(t.val > 1990) "Direkte offentlige investeringer i forskning og udvikling, Kilde: ADAM[Xo1i]"
    vOffIndirInv[t] "Den offentlige sektor nettokøb af bygninger o.a. eksisterende investeringsgoder, Kilde: ADAM[Io1a]"
    vOffNyInvx[t]$(t.val > 1990) "Faste nyinvesteringer i off. sektor, ekskl. investeringer i forskning og udvikling, Kilde: ADAM[Ifro1ny]"
    # Tabel-variable
    vOffNyInv[t]$(t.val > 1990) "Offentlige nyinvesteringer inkl. direkte investeringer, Kilde: ADAM[Ifo1ny]"
    vY[s_,t]$(off[s_]) "Produktionsværdi fordeltfor offentlig sektor, Kilde: ADAM[X] eller ADAM[X<i>]"
  ;

	$GROUP G_production_public_endo
    G_production_public_prices_endo
    G_production_public_quantities_endo
    G_production_public_values_endo

    rOffK2Y[k,t] "Offentlig kapital relativt til vægtet gennemsnit af offentlig og privat produktion."  
    rOffLoensum2R[t] "Offentlige lønsum som andel af offentlige materialekøb (i løbende priser)."  
    rOffLoensum2E[t] "Offentlige lønsum som andel af offentlige Energikøb (i løbende priser)."  
    rvOffDirInv2BNP[t] "Direkte offentlige investeringer relativt til BNP."
    rOffIB2NyInvx[t]$(t.val > 1990) "Andel af offentlige nyinvesteringer ekskl. direkte inv., som er bygninger."
	;
	$GROUP G_production_public_endo G_production_public_endo$(tx0[t]);

  $GROUP G_production_public_prices
    G_production_public_prices_endo
  ;
  $GROUP G_production_public_quantities
    G_production_public_quantities_endo
  ;
  $GROUP G_production_public_values
    G_production_public_values_endo
  ;

  $GROUP G_production_public_exogenous_forecast
    fpYOff[t] "Sammensætningseffekter i offentlig ansattes uddannelsesbaggrund mv. I data fanges også forskelle mellem input-metode og nationalregnskabets outputmål"
  ;
  $GROUP G_production_public_forecast_as_zero
    jfpOffAfskr[k,t] "J-led, som afspejler forskel mellem deflatoren for offentlige afskrivninger og investeringer."
    jfqOffAfskr[k,t] "J-led, som afspejler forskel mellem deflatoren for offentlige afskrivninger og investeringer."
    jfpOffNyInvx[t] "J-led, som afspejler forskel mellem deflatoren for offentlige investeringer og nyinvesteringer."
    jfpOffNyInv[t] "J-led"
  ;
  $GROUP G_production_public_ARIMA_forecast
    rAfskr[k,s_,t]$(off[s_]) "Afskrivningsrate for kapital."
    rvOffIndirInv2vBVT[t] "Offentligt opkøb af eksisterende kapital relativt til BVT."

    rOffK2Y
    rOffLoensum2R
    rOffLoensum2E
    rvOffDirInv2BNP
  ;
  $GROUP G_production_public_fixed_forecast
    fqLOff_input[t] "Korrektionsfaktor for input-baseret offentlig lønsum i faste priser"
    fpOffDirInv[t] "Korrektionsfaktor"
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
	$BLOCK B_production_public_static$(tx0[t])
    E_vI_off[i,t]$(d1I_s[i,'off',t]).. vI_s[i,'off',t] =E= pI_s[i,'off',t] * qI_s[i,'off',t];

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

    E_qOffAfskr_tot[t]..
      qOffAfskr[kTot,t] * pOffAfskr[kTot,t-1]/fp =E= sum(k, pOffAfskr[k,t-1]/fp * qOffAfskr[k,t]);

    E_pOffAfskr_tot[t]..
      pOffAfskr[kTot,t] * qOffAfskr[kTot,t] =E= vOffAfskr[kTot,t];
  
    # Offentlige materialekøb er eksogene som udgangspunkt, kan endogeniseres ved at eksogenisere dette forhold
    E_rOffLoensum2R[t].. rOffLoensum2R[t] =E= vLoensum['off',t] / vR['off',t];
    E_rOffLoensum2E[t].. rOffLoensum2E[t] =E= vLoensum['off',t] / vE['off',t];

    # Offentligt forbrug opgøres ved input metoden, dvs. kædeindeks af input-mængder
    # fpYoff fanger sammensætningseffekter i offentlig ansattes uddannelsesbaggrund mv. I data fanger fpYoff også forskelle mellem input-metode og nationalregnskabets outputmål.
    E_qY_off[t]$(t.val > %cal_start%)..
      pY['off',t-1]/fp * qY['off',t] =E= pOffAfskr[kTot,t-1]/fp * qOffAfskr[kTot,t]
                                       + pR['off',t-1]/fp * qR['off',t] + pE['off',t-1]/fp * qE['off',t]
                                       + pW[t-1]/fp * qProd['off',t-1]/fq * fpYOff[t] * hL['off',t]
                                       + (vtNetY['off',t-1] / qY['off',t-1])/fp * qY['off',t];

    # Beskæftigelse, materialekøbe og investeringer er alle eksogene i mængder ved stød.
    E_vY_off[t].. vY['off',t] =E= vOffAfskr[kTot,t] + vLoensum['off',t] + vR['off',t] + vE["off",t] + vtNetY['off',t];

    # Purchases of existing capital follow gross value added (BVT)
    E_vOffIndirInv[t].. vOffIndirInv[t] =E= rvOffIndirInv2vBVT[t] * vBVT[sTot,t];

    # Direkte investeringer kommer fra IO-system, men er fast andel af output (qIO[i,'off',t] =E= rqIO2qYoff[i,t] * qY['off',t])
    E_vOffDirInv[t]$(t.val > 1990).. vOffDirInv[t] =E= sum(i, vIO[i,'off',t]);

    # Samlede offentlige investeringer = ny + direkte + indirekte (vI_s['iM','off',t] + vI_s['iB','off',t] =E= vOffNyInv[t] + vOffDirInv[t] + vOffIndirInv[t])
    # Ny-investeringer fordeles mellem bygninger og maskiner. Direkte investeringer går til maskiner, indirekte til bygninger.
    # Både maskin- og bygningsinvesteringer er eksogene - vOffNyInv og rOffIB2NyInv tager tilpasning.
    E_vOffNyInvx[t]$(t.val > 1990)..
      vI_s['iM','off',t] =E= (1-rOffIB2NyInvx[t]) * vOffNyInvx[t] + vOffDirInv[t];

    E_rOffIB2NyInvx[t]$(t.val > 1990)..
      vI_s['iB','off',t] =E= rOffIB2NyInvx[t] * vOffNyInvx[t] + vOffIndirInv[t];

    # Public direct investments in R&D as share of GDP
    E_rvOffDirInv2BNP[t].. rvOffDirInv2BNP[t] =E= vOffDirInv[t] / vBNP[t]; 

    # Fra nyinvesteringer i mængde til nyinvesteringer i værdi
    E_pOffNyInvx[t]$(t.val > 1990)..
      pOffNyInvx[t] =E= (1+jfpOffNyInvx[t]) * (pI_s['iB','off',t] * rOffIB2NyInvx[t] + pI_s['iM','off',t] * (1-rOffIB2NyInvx[t]));

    E_qOffNyInvx[t]$(t.val > 1990).. vOffNyInvx[t] =E= pOffNyInvx[t] * qOffNyInvx[t];

    # Tabel-variable 
    # Offentlige nyinvesteringer inkl. direkte investeringer
    E_pOffNyInv[t]$(t.val > 1995).. 
      pOffNyInv[t] =E= (1+jfpOffNyInv[t]) * (  vOffNyInvx[t]/vOffNyInv[t] * pOffNyInvx[t] 
                                             + vOffDirInv[t]/vOffNyInv[t] * pI_s['iM','off',t]);
    E_vOffNyInv[t]$(t.val > 1990).. vOffNyInv[t] =E= vOffNyInvx[t] + vOffDirInv[t];
    E_qOffNyInv[t]$(t.val > 1995).. vOffNyInv[t] =E= pOffNyInv[t] * qOffNyInv[t];

    E_qLOff_input[t]$(t.val > %cal_start%).. qLOff_input[t] =E= fqLOff_input[t] * fpYOff[t] * hL['off',t];

    E_pLOff_input[t]$(t.val > %cal_start%).. pLOff_input[t] =E= vLoensum['off',t] / qLOff_input[t];

    E_pOffDirInv[t].. pOffDirInv[t] =E= fpOffDirInv[t] * pIO['iM','off',t];

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
# =============================================================================================½=========================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_production_public_makrobk
    vOffDirInv, vOffIndirInv, 
    qOffAfskr, pOffAfskr, vOffAfskr
    qOffNyInvx, pOffNyInvx, vOffNyInvx
    qK$(off[s_])
    pOffNyInv, vOffNyInv, qOffNyInv, qLOff_input, pOffDirInv
  ;
  @load(G_production_public_makrobk, "..\Data\makrobk\makrobk.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_production_public_data  
    G_production_public_makrobk
  ;
  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_production_public_data_imprecise 
    vOffNyInvx
    qOffNyInvx
    vOffAfskr
    qOffAfskr$(iM[i_])
    pOffAfskr$(iM[i_] and t.val >= %cal_start%)
    qOffNyInv
    vOffNyInv
    
  ;

  # ======================================================================================================================
  # Exogenous variables
  # ======================================================================================================================

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

    jfpOffAfskr[k,t], -pOffAfskr[iTot,t], -pOffAfskr[iB,t]
    jfqOffAfskr[k,t], -qOffAfskr[iTot,t], -qOffAfskr[iB,t]
    rvOffIndirInv2vBVT[t], -vOffIndirInv[t]
    jfpOffNyInvx[t], -pOffNyInvx[t]
    rAfskr[k,off,t], -qK[k,off,t]
    fpYOff, -qY[off,t]
    jfpOffNyInv$(t.val > 1995), -pOffNyInv$(t.val > 1995)
    vtNetY[off,t], -vY[off,t]

    fqLOff_input$(t.val > %cal_start%), -qLOff_input$(t.val > %cal_start%)
    fpOffDirInv, -pOffDirInv
  ;
  $GROUP G_production_public_static_calibration
    G_production_public_static_calibration$(tx0[t])
  ;
  #  $BLOCK B_production_public_static_calibration
  #  $ENDBLOCK

  MODEL M_production_public_static_calibration /
    M_production_public
    #  B_production_public_static_calibration
  /;

  $GROUP G_production_public_static_calibration_newdata
    G_production_public_static_calibration
   ;
  MODEL M_production_public_static_calibration_newdata /
    M_production_public_static_calibration
  /;
$ENDIF


# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
	$GROUP G_production_public_deep
		G_production_public_endo

    # Offentlige investeringer endogeniseres ud fra en fremskrivning af KY-forholdene
    qI_s[k,off,tx1]$(d1I_s[i_,s_,t]) # E_qI_s_forecast 

    # Offentlige direkte investeringer i forskning og udvikling holdes konstant som andel af BNP
    # Andelen af nyinvesteringer som er bygninger endogeniseres
    rqIO2qYoff[iM,t], -rvOffDirInv2BNP[t]

    qE[off,t], -rOffLoensum2E[t] # Beskæftigelse vælges ud fra fast forhold mellem lønsum og materialekøb
    qR[off,t], -rOffLoensum2R[t] # Beskæftigelse vælges ud fra fast forhold mellem lønsum og materialekøb
	;
  $GROUP G_production_public_deep G_production_public_deep$(tx0[t]);

	$BLOCK B_production_public_deep
    E_qI_s_forecast[k,t]$(tx1[t]).. # rOffK2Y changes from static to dynamic calibration due to temrinal condition on moving average of private sector BVT
      rOffK2Y[k,t] =E= rOffK2Y_ARIMA[k,t] * rOffK2Y[k,t1] / rOffK2Y_ARIMA[k,t1];
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

    # Offentlige direkte investeringer i forskning og udvikling holdes konstant som andel af BNP
    # Andelen af nyinvesteringer som er bygninger endogeniseres
    rqIO2qYoff[iM,t], -rvOffDirInv2BNP[t]

    # Offentlige investeringer hopper direkte til baseline - fast K2Y giver dårlig fremskrivning på kort sigt 

    qE[off,t], -rOffLoensum2E[t] # Beskæftigelse vælges ud fra fast forhold mellem lønsum og materialekøb
    qR[off,t], -rOffLoensum2R[t] # Beskæftigelse vælges ud fra fast forhold mellem lønsum og materialekøb
  ;
  MODEL M_production_public_dynamic_calibration /
    M_production_public
  /;
$ENDIF