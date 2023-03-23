# ======================================================================================================================
# Private sector production
# - Private sector demand for factors of production
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
	$GROUP G_production_private_prices_endo
    pKL[sp,t] "CES pris af qKL-aggregat."
    pKLB[s_,t]$(sp[s_]) "CES pris af qKLB-aggregat."
    pKLBR[s_,t]$(sp[s_]) "Marginalomkostning fra produktion før rest-produktionsskatter."
    pK[k,s_,t]$(d1K[k,s_,t] and sp[s_] or sByTot[s_]) "User cost af kapital."
    pKUdn[k,s_,t]$(d1K[k,s_,t] and sp[s_] or sByTot[s_]) "User cost af kapital efter kapacitetsudnyttelse."
    pTobinsQ[k,s_,t]$(sp[s_] or sByTot[s_]) "Skyggepris af kapital eller Tobin's Q."
    pLxUdn[sp,t] "User cost for effektiv arbejdskraft før kapacitetsudnyttelse i produktionsfunktion."
    pKI_sByTot[i_,t] "Investeringspris, pI_s, sammenvejet med kapitalapparat"
    pL[s_,t]$(sByTot[s_]) "User cost for effektiv arbejdskraft i produktionsfunktion."
	;    
	$GROUP G_production_private_quantities_endo
    qKInstOmk[i_,s_,t]$(d1K[i_,s_,t] and sp[s_] or sByTot[s_]) "Installationsomkostninger for kapital fordelt på private brancher."
    qKLBR[sp,t] "CES-aggregat mellem KLB-aggregat og materialer."
    qKLB[s_,t]$(sp[s_]) "CES-aggregat mellem KL-aggregat and bygningskapital."
    qKL[sp,t] "CES-aggregat mellem maskinkapital og arbejdskraft."
    qR[r_,t]$(sp[r_]) "Materialeinput fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[fV] eller ADAM[fV<i>]"
    qK[i_,s_,t]$(d1K[i_,s_,t] and sp[s_] or sByTot[s_]) "Ultimokapital fordelt efter kapitaltype og branche, Kilde: ADAM[fKnm<i>] eller ADAM[fKnb<i>]"
    qL[s_,t]$(s[s_] or sByTot[s_]) "Arbejdskraft i effektive enheder."
    qKUdn[i_,s_,t]$(d1K[i_,s_,t] and sp[s_] or sByTot[s_]) "Ultimokapital efter kapacitetsudnyttelse"
    qI_s[i_,s_,t]$(d1I_s[i_,s_,t] and sp[s_]) "Investeringer fordelt på brancher, Kilde: ADAM[fI<i>] eller ADAM[fIm<i>] eller ADAM[fIb<i>]"
    qLxUdn[s,t] "Arbejdskraft i effektive enheder før kapacitetsudnyttelse."
  ;
	$GROUP G_production_private_values_endo
    empty_group_dummy
  ;

	$GROUP G_production_private_endo
    G_production_private_prices_endo
    G_production_private_quantities_endo
    G_production_private_values_endo

    rLUdn[s_,t]$(not sOff[s_]) "Kapacitetsudnyttelse af arbejdskraft."
    rKUdn[i_,s_,t]$(d1K[i_,s_,t-1] and not (bol[s_] or udv[s_] or sOff[s_]) or sByTot[s_]) "Kapacitetsudnyttelse af sidste periodes qK."
    ErSkatAfskr[k,s_,t]$(sp[s_] or sByTot[s_]) "Skyggepris for skatteværdien af bogført kapitalapparat."
    hL[s_,t]$(sp[s_]) "Erlagte arbejdstimer fordelt på brancher, Kilde: ADAM[hq] eller ADAM[hq<i>]"
    fqBVT[t] "Residual Faktor i Cobb-Douglas produktionsfunktion"
    fqL[t] "Residual Faktor i Cobb-Douglas produktionsfunktion"
    dKInstOmk2dK[k,s_,t]$(d1K[k,s_,t] and sp[s_] or sByTot[s_]) "qKInstOmk differentieret ift. qK[t-1]"
    dKInstOmk2dI[k,s_,t]$(d1K[k,s_,t] and sp[s_] or sByTot[s_]) "qKInstOmk differentieret ift. qI_s."
    dKInstOmkLead2dI[k,s_,t]$(d1K[k,s_,t] and sp[s_] or sByTot[s_]) "qKInstOmk[t+1] differentieret ift. qI_s."
    rVirkDisk[s_,t]$(sByTot[s_]) "Selskabernes diskonteringsrate."
    fVirkDisk[s_,t]$(sByTot[s_]) "Selskabernes diskonteringsfaktor."
    mtVirk[s_,t]$(sByTot[s_]) "Branchefordelt marginal indkomstskat hos virksomheder."
    tK[k,s_,t]$(sByTot[s_]) "Kapitalafgiftssats (hhv. ejendomsskatter og vægtafgift)"
    uKInstOmk[k,s_,t]$(sByTot[s_]) "Parameter for installationsomkostninger."
    fKInstOmk[k,s_,t]$(sByTot[s_]) "Vækstfaktor i investeringer som giver nul installationsomkostningerne."
    uKtot[k, t] "Omkostningsandel for kapital i BVT-aggregat for private byerhverv."
    uLtot[t] "Omkostningsandel for arbejdskraft i BVT-aggregat for private byerhverv."
    pKrest[k,t] "Residual i beregning af aggregeret usercost af kapital."
    rAfskr[k,s_,t]$(sByTot[s_]) "Afskrivningsrate for kapital."
    frLUdn[t] "Korrektions-faktor for kapacitetsudnyttelse på arbejdskraft aggregeret for private byerhverv."
    uL[s_,t]$(sByTot[s_]) "Skalaparameter for qL i produktionsfunktionen."
    uK[k,s_,t]$(sByTot[s_]) "Skalaparameter for qK i produktionsfunktionen."
    frKUdn[k,t] "Korrektions-faktor for kapacitetsudnyttelse på kapital aggregeret for private byerhverv."

    # Housing-kapital er eksogent og CES-efterspørgsel efter K bestemmer i stedet housing produktionen
    qY[s_,t]$(bol[s_])
	;
	$GROUP G_production_private_endo G_production_private_endo$(tx0[t]);

  $GROUP G_production_private_prices
    G_production_private_prices_endo
  ;
  $GROUP G_production_private_quantities
    G_production_private_quantities_endo
  ;
  $GROUP G_production_private_values
    G_production_private_values_endo
  ;

  $GROUP G_production_private_exogenous_forecast
    empty_group_dummy[t] ""
  ;
  $GROUP G_production_private_forecast_as_zero
    jfrLUdn[sp,t] "J-led."
    jfrLUdn_t[t] "J-led."
    jfrKUdn[k,sp,t] "J-led."
    jfrKUdn_t[t] "J-led."
    jfqI_s_iL[t] "J-led."
    jpK_t[k,t] "J-led."
  ;
  $GROUP G_production_private_ARIMA_forecast
    rIL2y[s_,t] "Andel af samlet produktion som går til lagerinvesteringer."
    rAfskr
    uK    
    uL
    uKL[s_,t] "Skalaparameter for qKL i produktionsfunktionen."
    uKLB[s_,t] "Skalaparameter for qKLB i produktionsfunktionen."
    uR[s_,t] "Skalaparameter for qR i produktionsfunktionen."
  ;
  $GROUP G_production_private_constants
    eKUdn[k] "Eksponent som styrer anvendelsen af kapacitetsudnyttelse af kapital."
    eKUdnPersistens[k] "Eksponent som styrer træghed i kapacitetsudnyttelse af kapital."
    eLUdn "Eksponent som styrer anvendelsen af kapacitetsudnyttelse af arbejdskraft."
    eLUdnPersistens "Eksponent som styrer træghed i kapacitetsudnyttelse af arbejdskraft."
    eKLBR[sp] "Substitutionselasticitet mellem qKLB og qR."
    eKLB[sp] "Substitutionselasticitet mellem qKL[sp] og qK[iB,sp]"
    eKL[sp] "Substitutionselasticitet mellem qK[im,sp] og qL."
    
  ;
  $GROUP G_production_private_other
    rAfskr_static[k,sp,t] "Udglattet afskrivningsrate til statisk kalibrering."
    gpI_s_static[k,sp,t] "Udglattet prisstigningsrate for investeringer til statisk kalibrering."
    jpK_s[k,sp,t] "J-led."
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
	$BLOCK B_production_private
    # ------------------------------------------------------------------------------------------------------------------
    # Two versions of the private production model are written here: an aggregate and a disaggregate version.
    # The disaggregate version is the core model.
    # The aggregate version is a simplified version useful for analyzing overall responses.
    # The difference between the two are as far as possible collected in explicit composition effect terms.
    # ------------------------------------------------------------------------------------------------------------------

    # ------------------------------------------------------------------------------------------------------------------
    # Aggregate version
    # ------------------------------------------------------------------------------------------------------------------
    # BVT er output minus materialelkøb
    E_vBVT_sByTot[t]$(tx0[t]).. vBVT[sByTot,t] =E= vY[sByTot,t] - vR[sByTot,t];

    E_pBVT_sByTot[t]$(tx0[t]).. pBVT[sByTot,t] * qBVT[sByTot,t] =E= vBVT[sByTot,t];

    # BVT beregnet ved Cobb-Douglas produktionsfunktion med effektivt K, B og L som input
    E_qBVT_sByTot[t]$(tx0[t])..
      qBVT[sByTot,t] =E= (uK['iM',sByTot,t] * qKUdn['iM',sByTot,t])**uKtot['iM',t] # MaskinKapital
                       * (uK['iB',sByTot,t] * qKUdn['iB',sByTot,t])**uKtot['iB',t] # Bygningskapital
                       * (uL[sByTot,t] * qL[sByTot,t])**uLtot[t] # Arbejdskraft
                       * fqBVT[t] # Korrektionsfaktor,som fanger sammensætningseffekter mm.
                       - qKInstOmk[kTot,sByTot,t];

    # Effektiv kapital som budgetandel af BVT
    E_qKUdn_sByTot[k,t]$(tx0[t])..
      pKUdn[k,sByTot,t] * qKUdn[k,sByTot,t] =E= uKtot[k,t] * sum(sBy, pKLB[sBy, t] * qKLB[sBy,t]);

    # Effektiv arbejdskraft som budgetandel af BVT
    E_qL_sByTot[t]$(tx0[t])..
      pL[sByTot,t] * qL[sByTot,t] =E= uLtot[t] * sum(sBy, pKLB[sBy, t] * qKLB[sBy,t]); 

    # Kapacitetsudnyttelse på arbejdskraft
    E_rLUdn_sByTot[t]$(tx0E[t])..
      rLUdn[sByTot,t] =E= (pL[sByTot,t] / pL[sByTot,t+1])**eLUdn
                        / (pL[sByTot,t-1] / pL[sByTot,t])**eLUdn
                        * rLUdn[sByTot,t-1]**eLUdnPersistens
                        * (frLUdn[t] + jfrLUdn_t[t]);

    E_rLUdn_sByTot_tEnd[t]$(tEnd[t])..
      rLUdn[sByTot,t] =E= rLUdn[sByTot,t-1]**eLUdnPersistens * (frLUdn[t] + jfrLUdn_t[t]);

    # Kapacitetsudnyttelse på kapital
    E_rKUdn_sByTot[k,t]$(tx0E[t])..
      rKUdn[k,sByTot,t] =E= (pKUdn[k,sByTot,t] / pKUdn[k,sByTot,t+1])**eKUdn[k]
                          / (pKUdn[k,sByTot,t-1] / pKUdn[k,sByTot,t])**eKUdn[k]
                          * rKUdn[k,sByTot,t-1]**eKUdnPersistens[k]
                          * (frKUdn[k,t] + jfrKUdn_t[t]);

    E_rKUdn_sByTot_tEnd[k,t]$(tEnd[t])..
      rKUdn[k,sByTot,t] =E= rKUdn[k,sByTot,t-1]**eKUdnPersistens[k] * (frKUdn[k,t] + jfrKUdn_t[t]);

    # Effektiv kapital = kapacitetsudnyttelse * primo-kapital
    E_qK_sByTot[k,t]$(tx0[t]).. qKUdn[k,sByTot,t] =E= rKUdn[k,sByTot,t] * qK[k,sByTot,t-1]/fq;

    # Usercost af effektiv kapital
    E_pKUdn_sByTot[k,t]$(tx0[t])..
      pKUdn[k,sBytot,t] =E= pK[k,sByTot,t] / rKUdn[k,sByTot,t];

    # Aggregeret effektiv arbejdskraft input som funktion af hL mv. og sammensætningseffektled
    E_fqL_sByTot[t]$(tx0[t])..
      qL[sByTot,t] =E= fqL[t] * qProd[sByTot,t] # Sector specific labor productivity
                     * rLUdn[sByTot,t] # Variable factor utilization
                     * (1-rOpslagOmk[sByTot,t]) # Matching friction
                     * hL[sByTot,t]; # Number of hours worked

    # Usercost of capital
    E_pK_sByTot[k,t]$((tx0E[t]))..
      pK[k,sByTot,t+1]*fp =E=
      # Tobin's q today and tomorrow
        pTobinsQ[k,sByTot,t] / (1-tSelskab[t+1]) / fVirkDisk[sByTot,t+1] 
      - (1 - rAfskr[k,sByTot,t+1]) * pTobinsQ[k,sByTot,t+1]*fp / (1-tSelskab[t+1])
      # Production tax on capital
      + tK[k,sByTot,t+1] * pKI_sByTot[k,t+1]*fp
      # Tax shield and collateral value on capital
      - (rVirkDisk[sByTot,t+1] / (1-tSelskab[t+1]) - rRente['Obl',t+1]) * rLaan2K[t] * pKI_sByTot[k,t]
      # Discounted value of change in future installation costs from change in investments today
      + pBVT[sByTot,t+1]* fp * dKInstOmk2dK[k,sByTot,t]

      + jpK_t[k,t+1] + pKrest[k,t+1];

    # First order condition with respect to tax deductible capital ('Shadows price')
    E_ErSkatAfskr_sByTot[k,t]$(tx0E[t])..
      ErSkatAfskr[k,sByTot,t] =E= ((1-rSkatAfskr[k,t+1]) * ErSkatAfskr[k,sByTot,t+1] + tSelskab[t+1] * rSkatAfskr[k,t+1]) * fVirkDisk[sByTot,t+1];
    
    E_ErSkatAfskr_sByTot_tEnd[k,t]$(tEnd[t])..
      ErSkatAfskr[k,sByTot,t] =E= tSelskab[t] * rSkatAfskr[k,t] / (rVirkDisk[sByTot,t] + rSkatAfskr[k,t]);

    # First order condition with respect to investment
    E_pTobinsQ_sByTot[k,t]$(tx0E[t])..
      pTobinsQ[k,sByTot,t] =E= pKI_sByTot[k,t] * (1-ErSkatAfskr[k,sByTot,t])
                             + pBVT[sByTot,t] * (1-tSelskab[t]) * dKInstOmk2dI[k,sByTot,t]
                             + fVirkDisk[sByTot,t] * pBVT[sByTot,t+1]*fp * (1-tSelskab[t+1]) * dKInstOmkLead2dI[k,sByTot,t] * qK[k,sByTot,t];

    E_pTobinsQ_sByTot_tEnd[k,t]$(tEnd[t])..
      pTobinsQ[k,sByTot,t] =E= pKI_sByTot[k,t] - pKI_sByTot[k,t] * ErSkatAfskr[k,sByTot,t]
                             + pBVT[sByTot,t] * (1-tSelskab[t]) * dKInstOmk2dI[k,sByTot,t];

    # Kapital-akkumulation
    E_rAfskr_sByTot[k,t]$(tx0[t]).. qI_s[k,sByTot,t] =E= qK[k,sByTot,t] - (1 - rAfskr[k,sByTot,t]) * qK[k,sByTot,t-1]/fq;

    # Afledte af installationsomkostninger 
    E_dKInstOmk2dK_sByTot[k,t]$(tx0E[t])..
      dKInstOmk2dK[k,sByTot,t] =E= - uKInstOmk[k,sByTot,t]/2 * sqr((qI_s[k,sByTot,t+1]*fq - qI_s[k,sByTot,t] * fKInstOmk[k,sByTot,t+1]) / qK[k,sByTot,t]);

    E_dKInstOmk2dI_sByTot[k,t]$(tx0[t])..
      dKInstOmk2dI[k,sByTot,t] =E= uKInstOmk[k,sByTot,t] * (qI_s[k,sByTot,t] - qI_s[k,sByTot,t-1]/fq * fKInstOmk[k,sByTot,t]) / (qK[k,sByTot,t-1]/fq);

    E_dKInstOmkLead2dI_sByTot[k,t]$(tx0E[t])..
      dKInstOmkLead2dI[k,sByTot,t] =E= - fKInstOmk[k,sByTot,t+1] / qK[k,sByTot,t] * dKInstOmk2dI[k,sByTot,t+1];

    # ------------------------------------------------------------------------------------------------------------------
    # Composition effects are calculated by aggregating the disaggregate version
    # ------------------------------------------------------------------------------------------------------------------
    # BVT beregnet ved kædeindeks - diskrepans til Cobb-Douglas produktionsfunktion fanges i korrektionsfaktor
    E_fqBVT[t]$(tx0[t])..
      pBVT[sByTot,t-1]/fp * qBVT[sByTot,t] =E= pY[sByTot,t-1]/fp * qY[sByTot,t] - pR[sByTot,t-1]/fp * qR[sByTot,t];

    # Kapacitetsudnyttelse på arbejdskraft
    E_frLUdn[t]$(tx0[t]).. rLUdn[sByTot,t] * hL[sByTot,t] =E= sum(sBy, rLUdn[sBy,t] * hL[sBy,t]);

    # Kapacitetsudnyttelse på Kapital
    E_frKUdn[k,t]$(tx0[t]).. rKUdn[k,sByTot,t] * sum(sBy, qK[k,sBy,t-1]/fq) =E= sum(sBy, qKUdn[k,sBy,t]);

    # Aggeregerede skalaparametre
    E_uK_sByTot[k,t]$(tx0[t])..
      uK[k,sByTot,t] / uK[k,sByTot,t-1] =E= sum(sBy, uK[k,sBy,t] * qKUdn[k,sBy,t-1])
                                          / sum(sBy, uK[k,sBy,t-1] * qKUdn[k,sBy,t-1]);

    E_uL_sByTot[t]$(tx0[t])..
      uL[sByTot,t] / uL[sByTot,t-1] =E= sum(sBy, uL[sBy,t] * qL[sBy,t-1])
                                      / sum(sBy, uL[sBy,t-1] * qL[sBy,t-1]);

    # User cost af kapital
    E_pKrest[k,t]$(tx0[t]).. pK[k,sByTot,t] * qK[k,sByTot,t-1]/fq =E= sum(sBy, pK[k,sBy,t] * qK[k,sBy,t-1]/fq);

    # Arbejdskraftandel
    E_uLTot[t]$(tx0[t]).. qL[sByTot,t] =E= sum(sBy, qL[sBy,t]);

    # Kapitalandel
    E_uKtot[k,t]$(tx0[t]).. pKI_sByTot[k,t] * qK[k,sByTot,t] =E= sum(sBy, pI_s[k,sBy,t] * qK[k,sBy,t]);

    # Investeringspriser vægtet med kapital
    E_pKI_sByTot[k,t]$(tx0[t]).. pKI_sByTot[k,t-1]/fp * qK[k,sByTot,t] =E= sum(sBy, pI_s[k,sBy,t-1]/fp * qK[k,sBy,t]);

    E_pKI_sByTot_kTot[t]$(tx0[t]).. pKI_sByTot[kTot,t-1]/fp * qK[kTot,sByTot,t] =E= sum([k,sBy], pI_s[k,sBy,t-1]/fp * qK[k,sBy,t]);
    E_qK_kTot_sByTot[t]$(tx0[t]).. pKI_sByTot[kTot,t] * qK[kTot,sByTot,t] =E= sum([k,sBy], pI_s[k,sBy,t] * qK[k,sBy,t]);

    # Aggregated user cost of labor
    E_pL_sByTot[t]$(tx0[t]).. pL[sByTot,t] * qL[sByTot,t] =E= sum(sBy, pL[sBy,t] * qL[sBy,t]);

    # Compute parts of aggregate adjustment cost equations
    E_uKInstOmk_sByTot[k,t]$(tx0[t])..     
      uKInstOmk[k,sByTot,t] * pKI_sByTot[k,t] * qK[k,sByTot,t-1] =E= sum(sBy, uKInstOmk[k,sBy,t] * pI_s[k,sBy,t] * qK[k,sBy,t-1]);

    # Compute parts of aggregated adjustment cost equations
    E_fKInstOmk_sByTot[k,t]$(tx0[t])..     
      fKInstOmk[k,sByTot,t] * pKI_sByTot[k,t] * qK[k,sByTot,t-1] =E= sum(sBy, fKInstOmk[k,sBy,t] * pI_s[k,sBy,t] * qK[k,sBy,t-1]);

    # Compute parts of aggregated qL
    E_rOpslagOmk_sByTot[t]$(tx0[t]).. rOpslagOmk[sByTot,t] * nL[sByTot,t] =E= sum(sBy, rOpslagOmk[sBy,t] * nL[sBy,t]);

    # Constructing elements of aggregate usercost
    E_rVirkDisk_sByTot[t]$(tx0[t])..
      rVirkDisk[sByTot,t] * sum([k,sBy], pI_s[k,sBy,t] * qK[k,sBy,t-1]) =E= sum([k,sBy], rVirkDisk[sBy,t] * pI_s[k,sBy,t] * qK[k,sBy,t-1]);
    E_fVirkDisk_sByTot[t]$(tx0[t])..
      fVirkDisk[sByTot,t] =E= 1 / (1 + rVirkDisk[sByTot,t]);

    E_tK_sByTot[k,t]$(tx0[t])..
      tK[k,sByTot,t] * pKI_sByTot[k,t] * qK[k,sByTot,t-1] =E= sum(sBy, tK[k,sBy,t] * pI_s[k,sBy,t] * qK[k,sBy,t-1]);

    E_qKInstOmk_sByTot[t]$(tx0[t])..
      pBVT[sByTot,t] * qKInstOmk[kTot,sByTot,t] =E= sum(sBy, pBVT[sBy,t] * qKInstOmk[kTot,sBy,t]);

    E_rKUdn_sTot[k,t]$(tx0[t])..
      rKUdn[k,sTot,t] * sum(s, qKUdn[k,s,t] / rkUdn[k,s,t]) =E= sum(s, qKUdn[k,s,t]);

    E_rKUdn_kTot_sByTot[t]$(tx0[t])..
      rKUdn[kTot,sByTot,t] * sum([k,sBy], qKUdn[k,sBy,t] / rkUdn[k,sBy,t]) =E= sum([k,sBy], qKUdn[k,sBy,t]);
    E_qKUdn_kTot_sByTot[t]$(tx0[t])..
      qKUdn[kTot,sByTot,t] =E= rKUdn[kTot,sByTot,t] * qK[kTot,sByTot,t-1]/fq;

    E_rLUdn_sTot[t]$(tx0[t])..
      rLUdn[sTot,t] * hL[sTot,t] =E= sum(s,rLUdn[s,t] * hL[s,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Disaggregate version
    # ------------------------------------------------------------------------------------------------------------------
    # ------------------------------------------------------------------------------------------------------------------
    # Gross production from net production
    # ------------------------------------------------------------------------------------------------------------------
    E_qKLBR[sp,t]$(tx0[t]).. qKLBR[sp,t] =E= qY[sp,t] + qKInstOmk[kTot,sp,t];

		# ------------------------------------------------------------------------------------------------------------------
    # 1) Top of CES tree: gross production KLBR (KLB-aggregate and material/intermediate inputs)
		# ------------------------------------------------------------------------------------------------------------------
    E_pKLBR[sp,t]$(tx0[t]).. pKLBR[sp,t] * qKLBR[sp,t] =E= pR[sp,t] * qR[sp,t] + pKLB[sp,t] * qKLB[sp,t];

    # CES Demand for capital-labor aggregate
    E_qKLB[sp,t]$(tx0[t])..
      qKLB[sp,t] =E= uKLB[sp,t] * qKLBR[sp,t] * (pKLBR[sp,t] / pKLB[sp,t])**eKLBR[sp];

    # CES Demand for material/intermediate inputs
    E_qR[sp,t]$(tx0[t]).. qR[sp,t] =E= uR[sp,t] * qKLBR[sp,t] * (pKLBR[sp,t] / pR[sp,t])**eKLBR[sp];

    # ------------------------------------------------------------------------------------------------------------------
    # 2) Next level of CES tree: KLB-aggregate(KL-aggregate and building capital)
    # ------------------------------------------------------------------------------------------------------------------
    E_pKLB[sp,t]$(tx0[t]).. pKLB[sp,t] * qKLB[sp,t] =E= pKUdn['iB',sp,t] * qKUdn['iB',sp,t] + pKL[sp,t] * qKL[sp,t];

    # CES demand: KL-aggregate as function of the KLB aggregate
    E_qKL[sp,t]$(tx0[t])..
      qKL[sp,t] =E= uKL[sp,t] * qKLB[sp,t] * (pKLB[sp,t] / pKL[sp,t])**eKLB[sp];

    # CES demand: building capital aggregate as function of the KLB aggregate
    E_qKUdn_ib[sp,t]$(tx0[t] and d1K['iB',sp,t])..
      qKUdn['iB',sp,t] =E= uK['iB',sp,t] * qKLB[sp,t] * (pKLB[sp,t] / pKUdn['iB',sp,t])**eKLB[sp];

    # Boligkapital er en undtagelse og er givet ud fra husholdningernes forbrugsvalg
    E_qK_bol[t]$(tx0[t]).. qK['iB','bol',t] =E= qKBolig[t] + qKLejeBolig[t];

    # ------------------------------------------------------------------------------------------------------------------
    # 3) Lowest level of CES tree: KL-aggregate (machine capital and labor)
    # ------------------------------------------------------------------------------------------------------------------
    E_pKL[sp,t]$(tx0[t]).. pKL[sp,t] * qKL[sp,t] =E= pL[sp,t] * qL[sp,t] + pKUdn['iM',sp,t] * qKUdn['iM',sp,t];

    # CES demand, machine capital aggregate as function of the KLB aggregate
    E_qKUdn_im[sp,t]$(tx0[t] and d1K['iM',sp,t])..
      qKUdn['iM',sp,t] =E= uK['iM',sp,t] * qKL[sp,t] * (pKL[sp,t] / pKUdn['iM',sp,t])**eKL[sp];

    # CES demand: labor as function of the KL aggregate
    E_hL[sp,t]$(tx0[t] and d1K['iM',sp,t-1])..
      qL[sp,t] =E= uL[sp,t] * qKL[sp,t] * (pKL[sp,t] / pL[sp,t])**eKL[sp];

    E_hL_xiM[sp,t]$(tx0[t] and not d1K['iM',sp,t-1])..
      qL[sp,t] =E= uL[sp,t] * qKL[sp,t];

    # Effective labor input is a function of..
    E_qL[s,t]$(tx0[t])..
      qL[s,t] =E= qProd[s,t] # Sector specific labor productivity
                * rLUdn[s,t] # Variable factor utilization
                * (1-rOpslagOmk[s,t]) # Matching friction
                * hL[s,t]; # Number of hours worked

    # Effective capital
    E_qK[k,sp,t]$(tx0[t] and d1K[k,sp,t])..
      qKUdn[k,sp,t] =E= rKUdn[k,sp,t] * qK[k,sp,t-1]/fq;

    # Effective user cost of capital
    E_pKUdn[k,sp,t]$(tx0[t] and d1K[k,sp,t])..
      pKUdn[k,sp,t] =E= pK[k,sp,t] / rKUdn[k,sp,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Kapital-installationsomkostninger
    # ------------------------------------------------------------------------------------------------------------------
    # Samlet output tabt til installationsomkostninger
    E_qKInstOmk_kTot[sp,t]$(tx0[t] and d1K[kTot,sp,t]).. qKInstOmk[kTot,sp,t] =E= sum(k, qKInstOmk[k,sp,t]);

    E_qKInstOmk[k,sp,t]$(tx0[t] and d1K[k,sp,t])..
      qKInstOmk[k,sp,t] =E= uKInstOmk[k,sp,t]/2 * sqr(qI_s[k,sp,t] - qI_s[k,sp,t-1]/fq * fKInstOmk[k,sp,t]) / (qK[k,sp,t-1]/fq);

    # Derivatives
    E_dKInstOmk2dK[k,sp,t]$(tx0E[t] and d1K[k,sp,t])..
      dKInstOmk2dK[k,sp,t] =E= - ukinstomk[k,sp,t]/2 * sqr((qI_s[k,sp,t+1]*fq - qI_s[k,sp,t] * fKInstOmk[k,sp,t+1]) / qK[k,sp,t]);

    E_dKInstOmk2dI[k,sp,t]$(tx0[t] and d1K[k,sp,t])..
      dKInstOmk2dI[k,sp,t] =E= ukinstomk[k,sp,t] * (qI_s[k,sp,t] - qI_s[k,sp,t-1]/fq * fKInstOmk[k,sp,t]) / (qK[k,sp,t-1]/fq);

    E_dKInstOmkLead2dI[k,sp,t]$(tx0E[t] and d1K[k,sp,t])..
      dKInstOmkLead2dI[k,sp,t] =E= - fKInstOmk[k,sp,t+1] / qK[k,sp,t] * dKInstOmk2dI[k,sp,t+1];

    # ------------------------------------------------------------------------------------------------------------------
    # Kapacitets-udnyttelse på kapital
    # ------------------------------------------------------------------------------------------------------------------
    E_rKUdn[k,sp,t]$(tx0E[t] and d1K[k,sp,t-1] and not (bol[sp] or udv[sp]))..
      rKUdn[k,sp,t] =E= (pKUdn[k,sp,t] / pKUdn[k,sp,t+1])**eKUdn[k]
                      / (pKUdn[k,sp,t-1] / pKUdn[k,sp,t])**eKUdn[k]
                      * rKUdn[k,sp,t-1]**eKUdnPersistens[k]
                      * (1+jfrKUdn[k,sp,t]+jfrKUdn_t[t]);

    E_rKUdn_tEnd[k,sp,t]$(tEnd[t] and d1K[k,sp,t-1] and not (bol[sp] or udv[sp]))..
      rKUdn[k,sp,t] =E= rKUdn[k,sp,t-1]**eKUdnPersistens[k]
                      * (1+jfrKUdn[k,sp,t]+jfrKUdn_t[t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Kapacitets-udnyttelse på arbejdskraft
    # ------------------------------------------------------------------------------------------------------------------
    E_rLUdn[sp,t]$(tx0E[t])..
      rLUdn[sp,t] =E= (pL[sp,t] / pL[sp,t+1])**eLUdn
                    / (pL[sp,t-1] / pL[sp,t])**eLUdn
                    * rLUdn[sp,t-1]**eLUdnPersistens
                    * (1+jfrLUdn[sp,t]+jfrLUdn_t[t]);

    E_rLUdn_tEnd[sp,t]$(tEnd[t])..
      rLUdn[sp,t] =E= rLUdn[sp,t-1]**eLUdnPersistens
                    * (1+jfrLUdn[sp,t]+jfrLUdn_t[t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Cost of capital
    # ------------------------------------------------------------------------------------------------------------------
		# Definition of user cost
    E_pK[k,sp,t]$((tx0E[t] and not bol[sp]) and d1K[k,sp,t])..
      pK[k,sp,t+1]*fp =E=
      # Tobin's q today and tomorrow
        (1+rVirkDisk[sp,t+1]) / (1-mtVirk[sp,t+1]) * pTobinsQ[k,sp,t]
      - (1-rAfskr[k,sp,t+1]) / (1-mtVirk[sp,t+1]) * pTobinsQ[k,sp,t+1]*fp
      # Production tax on capital
      + tK[k,sp,t+1] * pI_s[k,sp,t+1]*fp
      # Tax shield and collateral value on capital
      - (rVirkDisk[sp,t+1] / (1-mtVirk[sp,t+1]) - rRente['Obl',t+1]) * rLaan2K[t] * pI_s[k,sp,t]
      # Discounted value of change in future installation costs from change in investments today
      + pKLBR[sp,t+1]*fp * dKInstOmk2dK[k,sp,t]

      + jpK_s[k,sp,t+1] + jpK_t[k,t+1];

    #User cost for the housing sector 
    E_pK_bol[sp,t]$(tx0[t] and bol[sp])..
      pY[sp,t] =E= pKLBR[sp,t] + vtNetYRest[sp,t] / qY[sp,t] ;

    # Terminal condition for capital stock
    E_qK_tEnd[k,sp,t]$(tEnd[t] and d1K[k,sp,t] and not bol[sp])..
      qI_s[k,sp,t] =E= fq * qI_s[k,sp,t-1]/fq;

		# First order condition with respect to investment
	  E_pTobinsQ[k,sp,t]$(tx0E[t] and d1K[k,sp,t])..
      pTobinsQ[k,sp,t] =E= pI_s[k,sp,t] * (1-ErSkatAfskr[k,sp,t])
                         + pKLBR[sp,t] * (1-mtVirk[sp,t]) * dKInstOmk2dI[k,sp,t]
                         + fVirkDisk[sp,t+1] * pKLBR[sp,t+1]*fp * (1-mtVirk[sp,t+1]) * dKInstOmkLead2dI[k,sp,t] * qK[k,sp,t];

    E_pTobinsQ_tEnd[k,sp,t]$(tEnd[t] and d1K[k,sp,t])..
      pTobinsQ[k,sp,t] =E= pI_s[k,sp,t] - pI_s[k,sp,t] * ErSkatAfskr[k,sp,t]
                         + pKLBR[sp,t] * (1-mtVirk[sp,t]) * dKInstOmk2dI[k,sp,t];

		# First order condition with respect to tax deductible capital ('Shadows price')
    E_ErSkatAfskr[k,sp,t]$(tx0E[t] and d1K[k,sp,t])..
      ErSkatAfskr[k,sp,t] =E= ((1-rSkatAfskr[k,t+1]) * ErSkatAfskr[k,sp,t+1] + mtVirk[sp,t+1] * rSkatAfskr[k,t+1]) * fVirkDisk[sp,t+1];
    E_ErSkatAfskr_tEnd[k,sp,t]$(tEnd[t] and d1K[k,sp,t])..
      ErSkatAfskr[k,sp,t] =E= mtVirk[sp,t] * rSkatAfskr[k,t] / (rVirkDisk[sp,t] + rSkatAfskr[k,t]);
     
  	 # Capital accumulation
    E_qI_sp[k,sp,t]$(tx0[t] and d1I_s[k,sp,t]).. qI_s[k,sp,t] =E= qK[k,sp,t] - (1 - rAfskr[k,sp,t]) * qK[k,sp,t-1]/fq;

    # Inventory investments
    # Inventories are forecast as fixed shares of production - corrected with lagged prices to balance future aggregated chain index
    E_qI_s_iL_private[sp,t]$(tx0[t] and d1I_s['iL',sp,t])..
      qI_s['iL',sp,t] * pI_s['iL',sp,t-1]/fp =E= (1+jfqI_s_iL[t]) * rIL2y[sp,t] * pY[sp,t-1]/fp * qY[sp,t];

    # Additional post model equations
    E_qLxUdn[s,t]$(tx0[t]).. qLxUdn[s,t] =E= qL[s,t] / rLUdn[s,t]; # =E= qProd[s,t] * (1-rOpslagOmk[s,t]) * hL[s,t];
    E_pLxUdn[sp,t]$(tx0[t]).. pLxUdn[sp,t] =E= pL[sp,t] * rLUdn[sp,t];
  $ENDBLOCK

  # Equations that do not need to be solved together with the full model and can instead be solved afterwards.
  MODEL M_production_private_post /
    E_uKInstOmk_sByTot
    E_fKInstOmk_sByTot
    E_qLxUdn
    E_pLxUdn
    E_rLUdn_sTot
    E_rKUdn_sTot
    E_rAfskr_sByTot
    E_pKrest
    E_uL_sByTot
    E_uK_sByTot
    E_dKInstOmk2dK_sByTot
    E_dKInstOmk2dI_sByTot
    E_dKInstOmkLead2dI_sByTot
    E_ErSkatAfskr_sByTot
    E_ErSkatAfskr_sByTot_tEnd
    E_rVirkDisk_sByTot
    E_fVirkDisk_sByTot
    E_pTobinsQ_sByTot
    E_pTobinsQ_sByTot_tEnd
    E_tK_sByTot
    E_uKtot
    E_pKUdn_sByTot
    E_rOpslagOmk_sByTot
    E_rLUdn_sByTot
    E_rLUdn_sByTot_tEnd
    E_fqL_sByTot
    E_qBVT_sByTot
    E_qKUdn_sByTot
    E_rKUdn_sByTot
    E_rKUdn_sByTot_tEnd
    E_qL_sByTot
    E_qK_sByTot
    E_pKI_sByTot
    E_pK_sByTot
    E_pL_sByTot
    E_frLUdn
    E_frKUdn
    E_qKInstOmk_sByTot
  /;

  # Endogenous variables that are solved for only after the main model.
  # Note that these may not appear anywhere in the main model (this results in a model not square error).
  $GROUP G_production_private_post
    qLxUdn
    pLxUdn
    uKInstOmk$(sByTot[s_])
    fKInstOmk$(sByTot[s_])
    rLUdn$(sTot[s_])
    rKUdn$(sTot[s_])
    pKrest
    tK$(sByTot[s_])
    dKInstOmk2dK$(sByTot[s_])
    dKInstOmk2dI$(sByTot[s_])
    dKInstOmkLead2dI$(sByTot[s_])
    ErSkatAfskr$(sByTot[s_])
    pTobinsQ$(sByTot[s_])
    rAfskr$(sByTot[s_])
    rVirkDisk$(sByTot[s_])
    fVirkDisk$(sByTot[s_])
    uL$(sByTot[s_])
    uK$(sByTot[s_])
    qKInstOmk$(sByTot[s_])
    uKtot
    uLtot
    pKUdn$(sByTot[s_])
    rOpslagOmk$(sByTot[s_])
    rLUdn$(sByTot[s_])
    fqL
    fqBVT
    qKUdn$(sByTot[s_] and k[i_])
    rKUdn$(sByTot[s_] and k[i_])
    qK$(sByTot[s_] and k[i_])
    pKI_sByTot$(k[i_])
    pK$(sByTot[s_])
    pL$(sByTot[s_])
    frLUdn
    frKUdn
  ;
  $GROUP G_production_private_post G_production_private_post$(tx0[t]);
$ENDIF


$IF %stage% == "exogenous_values":
# =============================================================================================½=========================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_production_private_makrobk
    qK$(sp[s_]), nL[s_,t]$(sp[s_] or sTot[s_]), qI_s$(k[i_] and sp[s_])
  ;
  @load(G_production_private_makrobk, "..\Data\makrobk\makrobk.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_production_private_data  
    G_production_private_makrobk
  ;
  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_production_private_data_imprecise 
    empty_group_dummy
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  # Kapacitetsudnyttelses-omkostninger
  eKUdn.l['iB'] = 0.655363; # Matching parameter
  eKUdn.l['iM'] = 0.90946; # Matching parameter
  eLUdn.l = 0.78762; # Matching parameter
  eKUdnPersistens.l[k] = 0.799636; # Matching parameter
  eLUdnPersistens.l = 0.799636; # Matching parameter

  # Installationsomkostninger
  uKInstOmk.l['iB',sp,t] = 13.366462; # Matching parameter
  uKInstOmk.l['iM',sp,t] = 5.66308; # Matching parameter

  # Produktionselasticiteter
  # Estimeret i Kronborg, A., & Poulsen, K. (2021). Estimater for elasticiteterne i MAKROs produktionsfunktion. Nyt user cost-begreb for kapital. Working paper, DREAM.
  # for udvinding i Kronborg, A., Poulsen, K., & Kastrup, C. (2021). Estimering af CES produktionsfunktioner i MAKRO. Working paper, DREAM.
  eKLBR.l[sp] = 0.25;
  eKLBR.l['fre'] = 0.83;
  eKLBR.l['tje'] = 0.80;
  eKLBR.l['byg'] = 0.37;

  eKLB.l[sp]  = 0.25;
  eKLB.l['udv'] = 0.55;
  eKLB.l['tje'] = 0.94; 

  eKL.l[sp]   = 0.25;
  eKL.l['fre'] = 0.45;
  eKL.l['lan'] = 0.71; 
  eKL.l['tje'] = 0.42;
  eKL.l['udv']   = 0.33;

  # Housing production is almost Leontief and does not have installations costs.
  eKLBR.l['bol'] = 0;
  eKLB.l['bol'] = 0;
  eKL.l['bol']   = 0;
  uKInstOmk.l[k,'bol',t] = 0;

# ======================================================================================================================
# Data assignment
# ======================================================================================================================

  #  We normalize pKL and pKLB to 1
  pKLB.l[sp,t] = 1/inf_factor[t];
  pKL.l[sp,t] = 1/inf_factor[t];
  pKI_sByTot.l[k,t]$(tBase[t]) = 1;
  pKI_sByTot.l[kTot,t]$(tBase[t]) = 1;

  uL.l[s_,t]$(sByTot[s_]) = 1;
  uK.l[k,s_,t]$(sByTot[s_]) = 1;
 
  # Kapacitetsudnyttelse
  rKUdn.l[k,s_,t] = 1;
  rLUdn.l[s_,t]   = 1;

  set_data_periods(1967, %cal_deep%);

  rAfskr_static.l[k,sp,t]$(tDataX1[t] and d1I_s[k,sp,t]) = max(0, (qI_s.l[k,sp,t] - (qK.l[k,sp,t] - qK.l[k,sp,t-1])) / qK.l[k,sp,t-1]);
  gpI_s_static.l[k,sp,t]$(tDataX1[t] and d1I_s[k,sp,t]) = pI.l[k,t] / pI.l[k,t-1] - 1;
  @HPfilter(rAfskr_static);
  @HPfilter(gpI_s_static);

  set_data_periods(%cal_start%, %cal_end%);
$ENDIF


# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_production_private_static_calibration
    G_production_private_endo

    uR[sp,t], -qR[r_,t]$(sp[r_])
    uL[s_,t]$(sp[s_]), -hL[s_,t]$(sp[s_])
    uK[k,s_,t]$(sp[s_] and d1K[k,s_,t-1]), -qK[i_,s_,t]$(sp[s_] and not bol[s_]), -qY[s_,t]$(bol[s_])

    uKL[sp,t] # E_uKL
    uKLB[sp,t] # E_uKLB
    -rLUdn$(s[s_]), jfrLUdn
    -rKUdn$(s[s_]), jfrKUdn

    fKInstOmk[k,s_,t] # E_fKInstOmk_static_calibration

    rIL2y[s_,t]$(sp[s_]), -qI_s[i_,s_,t]$(iL[i_] and sp[s_]) 
    rAfskr[k,s_,t]$(sp[s_]), -qI_s[i_,s_,t]$((iM[i_] or iB[i_]) and sp[s_])
  ;
  $GROUP G_production_private_static_calibration
    G_production_private_static_calibration$(tx0[t])
    pK[k,s_,t]$(t0[t] and (sp[s_] or sByTot[s_])) # E_pK_t0
    pKUdn[k,s_,t]$(t0[t] and (sByTot[s_] or sp[s_])) # E_pKUdn_t0, E_pKUdn_sByTot_t0
    pL[s_,t]$(t0[t] and ( sByTot[s_] or sp[s_])) # E_vpL_t0
    pKL[sp,t]$(t0[t]), -pKL[sp,t]$(tBase[t])
    pKLB[sp,t]$(t0[t]), -pKLB[sp,t]$(tBase[t])
    qK$(t0[t] and sByTot[s_]) # E_uKtot_t0, E_qK_kTot_sByTot_t0
    pKI_sByTot$(t0[t]), -pKI_sByTot$(tBase[t])
    uL$(t0[t] and (sp[s_] or sByTot[s_])) #E_uL_t0, E_uL_sByTot_t0
    uK$(t0[t] and (sp[s_] or sByTot[s_])) #E_uK_t0, E_uK_sByTot_t0
    qKUdn$(t0[t] and (sByTot[s_] or sp[s_])) #E_qK_sByTot_t0
    qL$((sp[s_] or sByTot[s_]) and t0[t]) #E_qL_t0

    rAfskr[k,s_,t]$(sTot[s_]) # E_rAfskr_sTot, E_rAfskr_sTot_t0
    uK[k,s_,t]$(spTot[s_]) # E_uK_spTot, E_uK_spTot_t0
    uL[s_,t]$(spTot[s_]) # E_uL_spTot, E_uL_spTot_t0
    uKL[s_,t]$(spTot[s_]) # E_uKL_spTot, E_uKL_spTot_t0
    uKLB[s_,t]$(spTot[s_]) # E_uKLB_spTot, E_uKLB_spTot_t0
    uR[s_,t]$(spTot[s_]) # E_uR_spTot, E_uR_spTot_t0
  ;

  $BLOCK B_production_private_static_calibration
    E_uKL[sp,t]$(tx0[t])..
      qKL[sp,t] * pKL[sp,t-1]/fp =E= pL[sp,t-1]/fp * qL[sp,t]
                                   + (pKUdn['iM',sp,t-1]/fp * qKUdn['iM',sp,t])$d1K['iM',sp,t-1];

    E_uKLB[sp,t]$(tx0[t])..
      qKLB[sp,t] * pKLB[sp,t-1]/fp =E= pKUdn['iB',sp,t-1]/fp * qKUdn['iB',sp,t]
                                     + pKL[sp,t-1]/fp * qKL[sp,t];

    E_fKInstOmk_static_calibration[sp,k,t]$(tx0[t] and d1K[k,sp,t])..
      0 =E= qI_s[k,sp,t] - qI_s[k,sp,t-1]/fq * fKInstOmk[k,sp,t];

    E_vpL_t0[s_,t]$(t0[t] and (sp[s_] or sByTot[s_])).. pL[s_,t]/pW[t] =E= pL[s_,t+1]/pW[t+1];    
    E_pK_t0[k,s_,t]$(t0[t] and d1K[k,s_,t] and sp[s_] or  t0[t] and sByTot[s_]).. pK[k,s_,t] =E= pK[k,s_,t+1];

    E_pKUdn_t0[k,sp,t]$(t0[t] and d1K[k,sp,t]).. pKUdn[k,sp,t] =E= pK[k,sp,t] / rKUdn[k,sp,t];

    E_pTobinsQ_static[k,sp,t]$(tx0[t] and d1K[k,sp,t])..
      pTobinsQ[k,sp,t] =E= pI_s[k,sp,t] * (1-ErSkatAfskr[k,sp,t]);

    E_ErSkatAfskr_static[k,sp,t]$(tx0[t] and d1K[k,sp,t])..
      ErSkatAfskr[k,sp,t] =E= mtVirk[sp,t] * rSkatAfskr[k,t] / (rVirkDisk[sp,t] + rSkatAfskr[k,t]);

    E_pK_static[k,sp,t]$(((t0[t] or tx0E[t]) and not bol[sp]) and d1K[k,sp,t]).. 
      pK[k,sp,t+1]*fp / (1+rVirkDisk[sp,t]) =E=
      # Tobin's q today and tomorrow
       pTobinsQ[k,sp,t] / (1-mtVirk[sp,t])
      - (1 - rAfskr_static[k,sp,t]) * pTobinsQ[k,sp,t]*(1+gpI_s_static[k,sp,t]) * fVirkDisk[sp,t] / (1-mtVirk[sp,t])
      # Production tax on capital
      + tK[k,sp,t] *(1+gpI_s_static[k,sp,t])*pI_s[k,sp,t] / (1+rVirkDisk[sp,t])
      # Tax shield and collateral value on capital
      - (rVirkDisk[sp,t] / (1-mtVirk[sp,t]) - rRente['Obl',t]) * rLaan2K[t] * pI_s[k,sp,t] * fVirkDisk[sp,t];

    E_uL_t0[sp,t]$(t0[t]).. uL[sp,t] =E= uL[sp,t+1];

    E_uK_t0[k,sp,t]$(t0[t] and d1K[k,sp,t]).. uK[k,sp,t] =E= uK[k,sp,t+1];

    E_qKUdn_t0[k,sp,t]$(t0[t]).. qKUdn[k,sp,t] =E= qKUdn[k,sp,t+1]*fq/fq;

    E_qKUdn_sByTot_t0[k,t]$(t0[t]).. qKUdn[k,sByTot,t] * pKUdn[k,sByTot,t] =E= sum(sBy, qKUdn[k,sBy,t] * pKUdn[k,sBy,t]) ;

    E_uK_sByTot_t0[k,t]$(tx0[t] and tBase[t])..
      uK[k,sByTot,t] * pKUdn[k,sByTot,t] * qKUdn[k,sByTot,t]=E= sum(sBy, uK[k,sBy,t] * pKUdn[k,sBy,t] * qKUdn[k,sBy,t]);

    E_uL_sByTot_t0[t]$(tx0[t] and tBase[t])..
      uL[sByTot,t] * pL[sByTot,t] * qL[sByTot,t] =E= sum(sBy, uL[sBy,t] * pL[sBy,t] *  qL[sBy,t]);

    E_qL_t0[sp, t]$(t0[t]).. qL[sp,t] =E= qL[sp,t+1]*fq/fq ;

    @copy_equation_to_period(E_uLTot, t0)
    @copy_equation_to_period(E_uKtot, t0)
    @copy_equation_to_period(E_pKUdn_sByTot, t0)

    @copy_equation_to_period(E_qK_kTot_sByTot, t0)

    E_rAfskr_sTot[k,t]$(tx1[t])..
      rAfskr[k,sTot,t] / rAfskr[k,sTot,t-1] =E= sum(s, rAfskr[k,s,t] * qK[k,s,t-1]) / sum(s, rAfskr[k,s,t-1] * qK[k,s,t-1]);
    E_rAfskr_sTot_t0[k,t]$(tx0[t] and tBase[t])..
      rAfskr[k,sTot,t] * sum(s, qK[k,s,t]) =E= sum(s, rAfskr[k,s,t] * qK[k,s,t]);

    E_uK_spTot[k,t]$(tx1[t])..
      uK[k,spTot,t] / uK[k,spTot,t-1] =E= sum(sp, uK[k,sp,t] * qKUdn[k,sp,t-1]) / sum(sp, uK[k,sp,t-1] * qKUdn[k,sp,t-1]);
    E_uL_spTot[t]$(tx1[t])..
      uL[spTot,t] / uL[spTot,t-1] =E= sum(sp, uL[sp,t] * qL[sp,t-1]) / sum(sp, uL[sp,t-1] * qL[sp,t-1]);
    E_uKL_spTot[t]$(tx1[t])..
      uKL[spTot,t] / uKL[spTot,t-1] =E= sum(sp, uKL[sp,t] * qKL[sp,t-1]) / sum(sp, uKL[sp,t-1] * qKL[sp,t-1]);
    E_uKLB_spTot[t]$(tx1[t])..
      uKLB[spTot,t] / uKLB[spTot,t-1] =E= sum(sp, uKLB[sp,t] * qKLB[sp,t-1]) / sum(sp, uKLB[sp,t-1] * qKLB[sp,t-1]);
    E_uR_spTot[t]$(tx1[t])..
      uR[spTot,t] / uR[spTot,t-1] =E= sum(sp, uR[sp,t] * qR[sp,t-1]) / sum(sp, uR[sp,t-1] * qR[sp,t-1]);

    E_uK_spTot_t0[k,t]$(tx0[t] and tBase[t])..
      uK[k,spTot,t] * sum(sp, pKUdn[k,sp,t] * qKUdn[k,sp,t]) =E= sum(sp, uK[k,sp,t] * pKUdn[k,sp,t] * qKUdn[k,sp,t]);
    E_uL_spTot_t0[t]$(tx0[t] and tBase[t])..
      uL[spTot,t] * sum(sp, pL[sp,t] * qL[sp,t])=E= sum(sp, uL[sp,t] * pL[sp,t] * qL[sp,t]);
    E_uKL_spTot_t0[t]$(tx0[t] and tBase[t])..
      uKL[spTot,t] * sum(sp, qKL[sp,t]) =E= sum(sp, uKL[sp,t] * qKL[sp,t]);
    E_uKLB_spTot_t0[t]$(tx0[t] and tBase[t])..
      uKLB[spTot,t] * sum(sp, qKLB[sp,t]) =E= sum(sp, uKLB[sp,t] * qKLB[sp,t]);
    E_uR_spTot_t0[t]$(tx0[t] and tBase[t])..
      uR[spTot,t] * sum(sp, qR[sp,t]) =E= sum(sp, uR[sp,t] * qR[sp,t]);
  $ENDBLOCK
  MODEL M_production_private_static_calibration /
    B_production_private
    B_production_private_static_calibration
    -E_pK - E_qK_tEnd  # E_pK_static
    -E_pTobinsq - E_pTobinsQ_tEnd  # E_pTobinsq_static 
    -E_ErSkatAfskr - E_ErSkatAfskr_tEnd  # E_ErSkatAfskr_static 
  /;
$ENDIF


# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_production_private_deep
    G_production_private_endo

    uR[s_,t], -qR[r_,t]$(t1[t] and sp[r_]) # E_uR_forecast
    jpK_s$(t.val = t1.val+1 and not bol[sp]), -qK[k,s_,t]$(t1[t] and sp[s_] and not bol[s_]),
    uK$(bol[s_]), -qY[s_,t]$(bol[s_] and t1[t]) # E_uK_forecast
    uL[s_,t]$(sp[s_]) , -hL[s_,t]$(t1[t] and sp[s_]) # E_uL_forecast

    uK[k,s_,t]$(not bol[s_] and sp[s_]), -pK$(t1[t] and not bol[s_] and not sByTot[s_]) # E_uK_forecast

    fKInstOmk$(tx1[t])  # E_fKInstOmk

    uKLB[s_,t] # E_uKLB_t1, E_uKLB_forecast

    uKL[s_,t]$(d1K['iM',s_,t-1])  # E_uKL_t1, E_uKL_forecast

    qProd, -rProdVaekst
  ;
  $GROUP G_production_private_deep G_production_private_deep$(tx0[t]);
	$BLOCK B_production_private_deep
    E_uR_forecast[sp,t]$(tx1[t])..
      uR[sp,t] =E= uR_ARIMA[sp,t] * uR[sp,t1] / uR_ARIMA[sp,t1];

    E_uK_forecast[k,s_,t]$(tx1[t] and d1K[k,s_,t-1] and sp[s_])..
      uK[k,s_,t] =E= uK_ARIMA[k,s_,t] * uK[k,s_,t1] / uK_ARIMA[k,s_,t1];

    E_uL_forecast[sp,t]$(tx1[t])..
      uL[sp,t] =E= uL_ARIMA[sp,t] * uL[sp,t1] / uL_ARIMA[sp,t1];

    E_fKInstOmk[k,sp,t]$(tx1[t] and d1K[k,sp,t]).. fKInstOmk[k,sp,t] =E= fq;

    E_uKLB_t1[sp,t]$(t1[t] and d1K['iB',sp,t-1])..
      qKLB[sp,t] * pKLB[sp,t-1]/fp =E= pKUdn['iB',sp,t-1]/fp * qKUdn['iB',sp,t]
                                     + pKL[sp,t-1]/fp * qKL[sp,t];

    E_uKLB_forecast[sp,t]$(tx1[t])..
      uKLB[sp,t] =E= uKLB_ARIMA[sp,t] * uKLB[sp,t1] / uKLB_ARIMA[sp,t1];

    E_uKL_t1[sp,t]$(t1[t] and d1K['iM',sp,t-1])..
      qKL[sp,t] * pKL[sp,t-1]/fp =E= pL[sp,t-1]/fp * qL[sp,t]
                                   + (pKUdn['iM',sp,t-1]/fp * qKUdn['iM',sp,t]);
    E_uKL_forecast[sp,t]$(tx1[t] and d1K['iM',sp,t-1])..
      uKL[sp,t] =E= uKL_ARIMA[sp,t] * uKL[sp,t1] / uKL_ARIMA[sp,t1];
  $ENDBLOCK
  MODEL M_production_private_deep /
    B_production_private - M_production_private_post
    B_production_private_deep
  /;
$ENDIF


# ======================================================================================================================
# Simple dynamic calibration
# ======================================================================================================================
$IF %stage% == "simple_dynamic_calibration":
  $GROUP G_production_private_dynamic_calibration
    G_production_private_endo
    uR[sp,t]$(t1[t]), -qR[r_,t]$(t1[t] and sp[r_])
    jpK_s[k,sp,t]$(t.val = t1.val+1 and not bol[sp]), -qK[k,s_,t]$(t1[t] and sp[s_] and not bol[s_])
    uK[k,s_,t]$(t1[t] and d1K[k,s_,t-1] and bol[s_]), -qY[s_,t]$(t1[t] and bol[s_])
    jfrLUdn[s_,t]$(t1[t]), -hL[s_,t]$(t1[t] and sp[s_])

    jfrLUdn_t$(tx1[t]) # E_jfrLUdn_t
    jfrKUdn_t$(tx1[t]) # E_jfrKUdn_t
  ;
  $BLOCK B_production_private_dynamic_calibration
    # Vi lukker indtil videre gab i kapacitetsudnyttelse håndholdt
    E_jfrLUdn_t[t]$(tx1[t])..
      rLUdn[sByTot,t] =E= rLUdn_baseline[sByTot,t] + aftrapprofil[t] * (rLUdn[sByTot,t1] - rLUdn_baseline[sByTot,t1]);

    E_jfrKUdn_t[t]$(tx1[t])..
      rKUdn[kTot,sByTot,t] =E= rKUdn_baseline[kTot,sByTot,t] + aftrapprofil[t] * (rKUdn[kTot,sByTot,t1] - rKUdn_baseline[kTot,sByTot,t1]);
  $ENDBLOCK
  MODEL M_production_private_dynamic_calibration /
    B_production_private - M_production_private_post
    B_production_private_dynamic_calibration
    E_rLUdn_sByTot, E_rLUdn_sByTot_tEnd, E_pL_sByTot, E_qL_sByTot, E_frLUdn # Eftermodel-ligninger, som bruges til håndholdt lukning af output-gab. 
  /;

$ENDIF