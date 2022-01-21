# ======================================================================================================================
# Public sector production
# - Public sector demand for factors of production
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
	$GROUP G_production_public_prices
    pKLBR[s_,t]$(sOff[s_]) "CES pris af qKLBR-aggregat = marginal enhedsomkostning."
    pOffAfskr[i_,t] "Deflator for offentlige afskrivninger, Kilde: ADAM[pinvo1], ADAM[pinvmo1] eller ADAM[pinvbo1]"
    pOffNyInv[t] "Deflator for offentlige nyinvesteringer, Kilde: ADAM[pifro1ny]"
	;    
	$GROUP G_production_public_quantities
    qOffAfskr[i_,t] "Offentlige afskrivninger, Kilde: ADAM[fInvo1], ADAM[fInvmo1] eller ADAM[fInvbo1]"
    qR[r_,t]$(sameas[r_, 'off']) "Materialeinput fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[fV] eller ADAM[fV<i>]"
    qOffNyInv[t] "Offentlige nyinvesteringer, Kilde: ADAM[fIfro1ny]"
    qI_s[i_,s_,t] "Investeringer fordelt på brancher, Kilde: ADAM[fI<i>] eller ADAM[fIm<i>] eller ADAM[fIb<i>]"
    qK[k,s_,t]$(d1K[k,s_,t] and sOff[s_]) "Ultimokapital fordelt efter kapitaltype og branche, Kilde: ADAM[fKnm<i>] eller ADAM[fKnb<i>]"
  ;
	$GROUP G_production_public_values
    vOffAfskr[i_,t] "Offentlige afskrivninger, Kilde: ADAM[Invo1], ADAM[Invmo1] eller ADAM[Invbo1]"
    vOffLR[t] "Samlede udgifter til materialer og arbejdskraft i den offentlige produktion, Kilde: ADAM[Ywo1]+ADAM[Vo1]"
    vI_s[i_,s_,t]$(d1I_s[i_,s_,t] and sOff[s_]) "Investeringer fordelt på brancher, Kilde: ADAM[I<i>] eller ADAM[Im<i>] eller ADAM[iB<i>]"
    vOffDirInv[t]$(t.val > 1990) "Direkte offentlige investeringer i forskning og udvikling, Kilde: ADAM[Xo1i]"
    vOffIndirInv[t] "Den offentlige sektor nettokøb af bygninger o.a. eksisterende investeringsgoder, Kilde: ADAM[Io1a]"
    vOffNyInv[t]$(t.val > 1990) "Faste nyinvesteringer i off. sektor, ekskl. investeringer i forskning og udvikling, Kilde: ADAM[Ifro1ny]"
  ;

	$GROUP G_production_public_endo
    G_production_public_prices
    G_production_public_quantities, -qI_s
    G_production_public_values

    srvOffL2LR[t] "Arbejdskrafts strukturelle andel af udgifterne til materialer og arbejdskraft i offentlig produktion."

    rOffK2Y[k,t] "Offentlig kapital relativt til vægtet gennemsnit af offentlig og privat produktion."  
    rvOffDirInv2BNP[t] "Direkte offentlige investeringer relativt til BNP."
	;
	$GROUP G_production_public_endo G_production_public_endo$(tx0[t]);

  $GROUP G_production_public_exogenous_forecast
    fProd[s_,t]$(sOff[s_]) "Branchespecifik produktivitetsindeks for arbejdskraft."
    jrpOffAfskr[k,t] "J-led, som afspejler forskel mellem deflatoren for offentlige afskrivninger og investeringer."
    jrqOffAfskr[k,t] "J-led, som afspejler forskel mellem deflatoren for offentlige afskrivninger og investeringer."
    jrpOffNyInv[t] "J-led, som afspejler forskel mellem deflatoren for offentlige investeringer og nyinvesteringer."
    nL[s_,t]$(sOff[s_]) "Beskæftigelse fordelt på brancher, Kilde: ADAM[Q] eller ADAM[Q<i>]"
  ;
  $GROUP G_production_public_ARIMA_forecast
    rIL2y[s_,t]$(sOff[s_]) "Andel af samlet produktion som går til lagerinvesteringer."
    rAfskr[k,s_,t]$(sOff[s_]) "Afskrivningsrate for kapital."
    rvOffIndirInv2vBVT[t] "Offentligt opkøb af eksisterende kapital relativt til BVT."

    # Endogene i stødforløb
    rOffK2Y # ARIMA bruges kun for bygninger p.t.
  ;
  $GROUP G_production_public_other
    rOffIB2NyInv[t] "Andel af offentlige nyinvesteringer, som er bygninger."
    rOffLTraeghed "Træghed i offentlig beskæftigelse."
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
	$BLOCK B_production_public
    # Real public investments, qI_s, are fixed by default and the capital ratios are endogenous
    E_rOffK2Y[k,t]$(tx0[t] and d1K[k,'off',t])..
      pI_s[k,'off',t] * qK[k,'off',t-1]/fq =E= rOffK2Y[k,t] * (0.7 * vBVT['off',t] + 0.3 * vVirkBVT5aarSnit[t]);

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

    E_vOffLR[t]$(tx0[t])..
      vOffLR[t] =E= qY['off',t] * pKLBR['off',t] - vOffAfskr[kTot,t];
  
    # Materialer og arbejdskraft antages at udgøre faste andele af produktionsværdien eksklusiv kapital-afskrivninger.
    # Udgiftsandelen måles i lønudgifter eksklusiv lønsumsafgifter fremfor lønsum.
    E_qR_off[t]$(tx0[t])..
      vOffLR[t] =E= qR['off',t] * pR['off',t] + fW['off',t] * rL2nL[t] * nL['off',t] * vhW[t];

    # Offentlig beskæftigelse antages at være mere træg på kort sigt end materialer
    E_nL_off[t]$(tx0[t])..
      nL['off',t] * fW['off',t] * rL2nL[t] =E= (1-rOffLTraeghed) * srvOffL2LR[t] * vOffLR[t] / vhW[t]
                                             + rOffLTraeghed * nL['off',t-1] * fW['off',t-1] * rL2nL[t-1]
                                             + 0.5 * rOffLTraeghed * (nL['off',t-1] * fW['off',t-1] * rL2nL[t-1] - nL['off',t-2] * fW['off',t-2] * rL2nL[t-2]);

    # The cost minimizng price is given by inputs and input prices (wages and not pL used as tL added in prices)
    E_pKLBR_off[t]$(tx0[t])..
      pKLBR['off',t] =E= pKLBR['off',t-1]/fp
                       * (pOffAfskr[kTot,t] * qOffAfskr[kTot,t] + pR['off',t] * qR['off',t] + vLoensum['off',t])
                       / (pOffAfskr[kTot,t-1]/fp * qOffAfskr[kTot,t] + pR['off',t-1]/fp * qR['off',t]
                          + vhW[t-1]/fv / fProd['off',t-1] * fProd['off',t] * fW['off',t] * rL2nL[t] * nL['off',t]);

    # Purchases of existing capital follow gross value added (BVT)
    E_vOffIndirInv[t]$(tx0[t]).. vOffIndirInv[t] =E= rvOffIndirInv2vBVT[t] * vBVT[sTot,t];

    # Public investments excluding R&D and purchases of existing capital
    E_vOffNyInv[t]$(tx0[t] and t.val > 1990).. rOffIB2NyInv[t] * vOffNyInv[t] =E= (vI_s['iB','off',t] - vOffIndirInv[t]);

    E_vOffDirInv[t]$(tx0[t] and t.val > 1990).. vOffDirInv[t] =E= vI_s['iM','off',t] + vI_s['iB','off',t] - vOffNyInv[t] - vOffIndirInv[t];

    # Public direct investments in R&D as share of GDP
    E_rvOffDirInv2BNP[t]$(tx0[t]).. rvOffDirInv2BNP[t] =E= vOffDirInv[t] / vBNP[t]; 

    # Fra nyinvesteringer i mængde til nyinvesteringer i værdi
    E_pOffNyInv[t]$(tx0[t])..
      pOffNyInv[t] =E= (1+jrpOffNyInv[t]) * (pI_s['iB','off',t] * rOffIB2NyInv[t] + pI_s['iM','off',t] * (1-rOffIB2NyInv[t]));

    E_qOffNyInv[t]$(tx0[t]).. vOffNyInv[t] =E= pOffNyInv[t] * qOffNyInv[t];
	$ENDBLOCK
$ENDIF