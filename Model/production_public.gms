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
    pY[s_,t]$(sOff[s_] and t.val > 1983) "Deflator for indenlandsk produktion, Kilde: ADAM[pX] eller ADAM[pX<i>]"
    pOffAfskr[i_,t]$(d1K[i_,'off',t]) "Deflator for offentlige afskrivninger, Kilde: ADAM[pinvo1], ADAM[pinvmo1] eller ADAM[pinvbo1]"
    pOffNyInv[t]$(t.val > 1990) "Deflator for offentlige nyinvesteringer, Kilde: ADAM[pifro1ny]"
	;    
	$GROUP G_production_public_quantities_endo
    qOffAfskr[i_,t] "Offentlige afskrivninger, Kilde: ADAM[fInvo1], ADAM[fInvmo1] eller ADAM[fInvbo1]"
    qOffNyInv[t]$(t.val > 1990) "Offentlige nyinvesteringer, Kilde: ADAM[fIfro1ny]"
    qK[i_,s_,t]$(d1K[i_,s_,t] and sOff[s_]) "Ultimokapital fordelt efter kapitaltype og branche, Kilde: ADAM[fKnm<i>] eller ADAM[fKnb<i>]"
    qG[g_,t]$(gTot[g_]) "Offentligt forbrug, Kilde: ADAM[fCo]"
  ;
	$GROUP G_production_public_values_endo
    vOffAfskr[i_,t] "Offentlige afskrivninger, Kilde: ADAM[Invo1], ADAM[Invmo1] eller ADAM[Invbo1]"
    vI_s[i_,s_,t]$(d1I_s[i_,s_,t] and sOff[s_]) "Investeringer fordelt på brancher, Kilde: ADAM[I<i>] eller ADAM[Im<i>] eller ADAM[iB<i>]"
    vOffDirInv[t]$(t.val > 1990) "Direkte offentlige investeringer i forskning og udvikling, Kilde: ADAM[Xo1i]"
    vOffIndirInv[t] "Den offentlige sektor nettokøb af bygninger o.a. eksisterende investeringsgoder, Kilde: ADAM[Io1a]"
    vOffNyInv[t]$(t.val > 1990) "Faste nyinvesteringer i off. sektor, ekskl. investeringer i forskning og udvikling, Kilde: ADAM[Ifro1ny]"
  ;

	$GROUP G_production_public_endo
    G_production_public_prices_endo
    G_production_public_quantities_endo
    G_production_public_values_endo

    rOffK2Y[k,t] "Offentlig kapital relativt til vægtet gennemsnit af offentlig og privat produktion."  
    rOffLoensum2R[t] "Offentlige lønsum som andel af offentlige materialekøb (i løbende priser)."  
    rvOffDirInv2BNP[t] "Direkte offentlige investeringer relativt til BNP."
    rOffIB2NyInv[t]$(t.val > 1990) "Andel af offentlige nyinvesteringer, som er bygninger."
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
    jrpOffAfskr[k,t] "J-led, som afspejler forskel mellem deflatoren for offentlige afskrivninger og investeringer."
    jrqOffAfskr[k,t] "J-led, som afspejler forskel mellem deflatoren for offentlige afskrivninger og investeringer."
    jrpOffNyInv[t] "J-led, som afspejler forskel mellem deflatoren for offentlige investeringer og nyinvesteringer."
  ;
  $GROUP G_production_public_ARIMA_forecast
    rIL2y[s_,t]$(sOff[s_]) "Andel af samlet produktion som går til lagerinvesteringer."
    rAfskr[k,s_,t]$(sOff[s_]) "Afskrivningsrate for kapital."
    rvOffIndirInv2vBVT[t] "Offentligt opkøb af eksisterende kapital relativt til BVT."
  ;
  $GROUP G_production_public_other
    empty_group_dummy[t]
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
	$BLOCK B_production_public
    # Real public investments, qI_s, are fixed by default and the capital ratios are endogenous
    E_rOffK2Y[k,t]$(tx0[t] and d1K[k,'off',t])..
      pI_s[k,'off',t] * qK[k,'off',t] =E= rOffK2Y[k,t] * (0.7 * vBVT['off',t] + 0.3 * vVirkBVT5aarSnit[t]);

    E_vI_off[i,t]$(tx0[t] and d1I_s[i,'off',t]).. vI_s[i,'off',t] =E= pI_s[i,'off',t] * qI_s[i,'off',t];

    # Capital accumulation
    E_qK_off[k,t]$(tx0[t] and d1K[k,'off',t])..
      qK[k,'off',t] =E= qI_s[k,'off',t] + (1 - rAfskr[k,'off',t]) * qK[k,'off',t-1]/fq;

    # Afskrivninger / Bruttorestindkomst
    E_pOffAfskr[k,t]$(tx0[t] and d1K[k,'off',t])..
      pOffAfskr[k,t] =E= (1+jrpOffAfskr[k,t]) * pI_s[k,'off',t];

    E_qOffAfskr[k,t]$(tx0[t] and d1K[k,'off',t])..
      qOffAfskr[k,t] =E= (1+jrqOffAfskr[k,t]) * rAfskr[k,'off',t] * qK[k,'off',t-1]/fq;

    E_vOffAfskr[k,t]$(tx0[t] and d1K[k,'off',t])..
      vOffAfskr[k,t] =E= pOffAfskr[k,t] * qOffAfskr[k,t];

    E_vOffAfskr_tot[t]$(tx0[t])..
      vOffAfskr[kTot,t] =E= sum(k, vOffAfskr[k,t]);

    E_qOffAfskr_tot[t]$(tx0[t])..
      qOffAfskr[kTot,t] * pOffAfskr[kTot,t-1]/fp =E= sum(k, pOffAfskr[k,t-1]/fp * qOffAfskr[k,t]);

    E_pOffAfskr_tot[t]$(tx0[t])..
      pOffAfskr[kTot,t] * qOffAfskr[kTot,t] =E= vOffAfskr[kTot,t];
  
    # Offentlige materialekøb er eksogene som udgangspunkt, kan endogeniseres ved at eksogenisere dette forhold
    E_rOffLoensum2R[t]$(tx0[t]).. rOffLoensum2R[t] =E= vLoensum['off',t] / vR['off',t];

    # Offentligt forbrug opgøres ved input metoden, dvs. kædeindeks af input-mængder
    # fpYoff fanger sammensætningseffekter i offentlig ansattes uddannelsesbaggrund mv. I data fanger fpYoff også forskelle mellem input-metode og nationalregnskabets outputmål.
    E_pY_off[t]$(tx0[t] and t.val > 1983)..
      pY['off',t-1]/fp * qY['off',t] =E= pOffAfskr[kTot,t-1]/fp * qOffAfskr[kTot,t]
                                       + pR['off',t-1]/fp * qR['off',t]
                                       + pW[t-1]/fp * qProd['off',t-1]/fq * fpYOff[t] * hL['off',t]
                                       + (vtNetY['off',t-1] / qY['off',t-1])/fp * qY['off',t];

    # Beskæftigelse, materialekøbe og investeringer er alle eksogene i mængder ved stød.
    E_qG_gTot[t]$(tx0[t]).. vY['off',t] =E= vOffAfskr[kTot,t] + vLoensum['off',t] + vR['off',t] + vtNetY['off',t];

    # Purchases of existing capital follow gross value added (BVT)
    E_vOffIndirInv[t]$(tx0[t]).. vOffIndirInv[t] =E= rvOffIndirInv2vBVT[t] * vBVT[sTot,t];

    # Direkte investeringer kommer fra IO-system, men er fast andel af output (qIO[i,'off',t] =E= rqIO2qYoff[i,t] * qY['off',t])
    E_vOffDirInv[t]$(tx0[t] and t.val > 1990).. vOffDirInv[t] =E= sum(i, vIO[i,'off',t]);

    # Samlede offentlige investeringer = ny + direkte + indirekte (vI_s['IM','off',t] + vI_s['IB','off',t] =E= vOffNyInv[t] + vOffDirInv[t] + vOffIndirInv[t])
    # Ny-investeringer fordeles mellem bygninger og maskiner. Direkte investeringer går til maskiner, indirekte til bygninger.
    # Både maskin- og bygningsinvesteringer er eksogene - vOffNyInv og rOffIB2NyInv tager tilpasning.
    E_vOffNyInv[t]$(tx0[t] and t.val > 1990)..
      vI_s['IM','off',t] =E= (1-rOffIB2NyInv[t]) * vOffNyInv[t] + vOffDirInv[t];

    E_rOffIB2NyInv[t]$(tx0[t] and t.val > 1990)..
      vI_s['IB','off',t] =E= rOffIB2NyInv[t] * vOffNyInv[t] + vOffIndirInv[t];

    # Public direct investments in R&D as share of GDP
    E_rvOffDirInv2BNP[t]$(tx0[t]).. rvOffDirInv2BNP[t] =E= vOffDirInv[t] / vBNP[t]; 

    # Fra nyinvesteringer i mængde til nyinvesteringer i værdi
    E_pOffNyInv[t]$(tx0[t] and t.val > 1990)..
      pOffNyInv[t] =E= (1+jrpOffNyInv[t]) * (pI_s['IB','off',t] * rOffIB2NyInv[t] + pI_s['IM','off',t] * (1-rOffIB2NyInv[t]));

    E_qOffNyInv[t]$(tx0[t] and t.val > 1990).. vOffNyInv[t] =E= pOffNyInv[t] * qOffNyInv[t];
	$ENDBLOCK
$ENDIF


$IF %stage% == "exogenous_values":
# =============================================================================================½=========================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_production_public_makrobk
    vOffDirInv, vOffIndirInv, 
    qOffAfskr, pOffAfskr, vOffAfskr
    qOffNyInv, pOffNyInv, vOffNyInv
    qK$(sOff[s_])
  ;
  @load(G_production_public_makrobk, "..\Data\makrobk\makrobk.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_production_public_data  
    G_production_public_makrobk
  ;
  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_production_public_data_imprecise 
    vOffNyInv
    qOffNyInv
    vOffAfskr
    qOffAfskr$(iM[i_])
    pOffAfskr$(iM[i_] and t.val >= 1983)
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

    jrpOffAfskr[k,t], -pOffAfskr[i_,t]$(iTot[i_] or iB[i_])
    jrqOffAfskr[k,t], -qOffAfskr[i_,t]$(iTot[i_] or iB[i_])
    rvOffIndirInv2vBVT[t], -vOffIndirInv[t]
    jrpOffNyInv[t], -pOffNyInv[t]
    rAfskr[k,s_,t]$(sOff[s_]), -qK[k,s_,t]$(sOff[s_])

    vSubYRest$(sOff[s_]), -qG$(gTot[g_]) # Manglende præcision i data fanges i vtNetYRest
    fpYOff, -pY$(sOff[s_])
  ;
  $GROUP G_production_public_static_calibration
    G_production_public_static_calibration$(tx0[t])
  ;
  #  $BLOCK B_production_public_static_calibration
  #  $ENDBLOCK

  MODEL M_production_public_static_calibration /
    B_production_public
    #  B_production_public_static_calibration
  /;
$ENDIF


# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
	$GROUP G_production_public_deep
		G_production_public_endo

    # Offentlige investeringer endogeniseres ud fra en fremskrivning af KY-forholdene
    qI_s[i_,s_,t]$(d1I_s[i_,s_,t] and sOff[s_] and tx1[t]) # E_qI_s_forecast 

    # Offentlige direkte investeringer i forskning og udvikling holdes konstant som andel af BNP
    # Andelen af nyinvesteringer som er bygninger endogeniseres
    rqIO2qYoff[i,t]$(iM[i]), -rvOffDirInv2BNP[t]

    qR$(sOff[r_]), -rOffLoensum2R[t] # Beskæftigelse vælges ud fra fast forhold mellem lønsum og materialekøb
	;
  $GROUP G_production_public_deep G_production_public_deep$(tx0[t]);

	$BLOCK B_production_public_deep
    E_qI_s_forecast[k,t]$(tx1[t]).. rOffK2Y[k,t] =E= rOffK2Y[k,t1]; # rOffK2Y changes from static to dynamic calibration due to temrinal condition on moving average of private sector BVT
	$ENDBLOCK
	MODEL M_production_public_deep /
		B_production_public
		B_production_public_deep
	/;
$ENDIF

# ======================================================================================================================
# Simple dynamic calibration
# ======================================================================================================================
$IF %stage% == "simple_dynamic_calibration":
  $GROUP G_production_public_dynamic_calibration
    G_production_public_endo
  ;
  MODEL M_production_public_dynamic_calibration /
    B_production_public
  /;
$ENDIF