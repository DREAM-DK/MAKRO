# ======================================================================================================================
# Private sector production
# - Private sector demand for factors of production
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
	$GROUP G_production_private_prices
    pKL[sp,t] "CES pris af qKL-aggregat."
    pKLB[sp,t] "CES pris af qKLB-aggregat."
    pKLBR[s_,t]$(sp[s_]) "CES pris af qKLBR-aggregat."
    pK[k,sp,t]$(d1K[k,sp,t]) "User cost af kapital."
    pTobinsQ[k,sp,t] "Skyggepris af kapital eller Tobin's Q."
	;    
	$GROUP G_production_private_quantities
    qKInstOmk[i_,sp,t]$(d1K[i_,sp,t]) "Installationsomkostninger for kapital fordelt på private brancher."
    qKLBR[sp,t] "CES-aggregat mellem KLB-aggregat og materialer."
    qKLB[sp,t] "CES-aggregat mellem KL-aggregat and bygningskapital."
    qKL[sp,t] "CES-aggregat mellem maskinkapital og arbejdskraft."
    qR[r_,t]$(sp[r_]) "Materialeinput fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[fV] eller ADAM[fV<i>]"
    qK[k,s_,t]$(d1K[k,s_,t] and sp[s_]) "Ultimokapital fordelt efter kapitaltype og branche, Kilde: ADAM[fKnm<i>] eller ADAM[fKnb<i>]"
    qI_s[i_,s_,t]$(d1I_s[i_,s_,t] and not sOff[s_]) "Investeringer fordelt på brancher, Kilde: ADAM[fI<i>] eller ADAM[fIm<i>] eller ADAM[fIb<i>]"
    qProd[t] "Produktivitetsindeks for Harrod-neutral vækst på tværs af brancher."
  ;

	$GROUP G_production_private_values
    empty_group_dummy
  ;

	$GROUP G_production_private_endo
    rLUdn[s_,t]$(not sameas[s_,'off']) "Kapacitetsudnyttelse af arbejdskraft."
    rKUdn[k,s_,t]$(d1K[k,s_,t-1] and not (sameas[s_,'bol'] or sameas[s_,'udv'] or sameas[s_,'off'])) "Kapacitetsudnyttelse af sidste periodes qK."
    rKUdnSpBy[t] "Kapacitetsudnyttelse af sidste periodes qK, aggregat over bygnings- og maskinkapital for private byerhverv"
    ErSkatAfskr[k,sp,t] "Skyggepris for skatteværdien af bogført kapitalapparat."
    qL[s_,t]$(s[s_]) "Arbejdskraft i effektive enheder."
    nL[s_,t]$(sp[s_]) "Beskæftigelse fordelt på brancher, Kilde: ADAM[Q] eller ADAM[Q<i>]"

    dKInstOmk2dK[k,sp,t]$(d1K[k,sp,t]) "qKInstOmk differentieret ift. qK[t-1]"
    dKInstOmk2dI[k,sp,t]$(d1K[k,sp,t]) "qKInstOmk differentieret ift. qI_s."
    dKInstOmkLead2dI[k,sp,t]$(d1K[k,sp,t]) "qKInstOmk[t+1] differentieret ift. qI_s."

		G_production_private_prices
		G_production_private_quantities
		G_production_private_values
    -qProd

    # Housing-kapital er eksogent og CES-efterspørgsel efter K bestemmer i stedet housing produktionen
    -qK[k,s_,t]$(sameas[s_,'bol'])
    qY[s_,t]$(sameas[s_,'bol'])
	;
	$GROUP G_production_private_endo G_production_private_endo$(tx0[t]);

  $GROUP G_production_private_exogenous_forecast
    fProd[s_,t]$(sp[s_]) "Branchespecifik produktivitetsindeks for arbejdskraft."

    # Forecast as zero
    jrLUdn[sp,t] "J-led."
    jrKUdn[k,sp,t] "J-led."
    jfqI_s_iL[t] "J-led."
    jpK[k,sp,t] "J-led."
  ;
  $GROUP G_production_private_ARIMA_forecast
    rAfskr[k,s_,t] "Afskrivningsrate for kapital."
    rIL2y[s_,t] "Andel af samlet produktion som går til lagerinvesteringer."
    uR[sp,t] "Skalaparameter for qR i produktionsfunktionen."
    uKLB[sp,t] "Skalaparameter for qKLB i produktionsfunktionen."
    uKL[sp,t] "Skalaparameter for qKL i produktionsfunktionen."
    uL[sp,t] "Skalaparameter for qL i produktionsfunktionen."
    uK[k,sp,t] "Skalaparameter for qK i produktionsfunktionen."
  ;
  $GROUP G_production_private_other
    uKInstOmk[k,sp] "Parameter for installationsomkostninger."
    fKInstOmk[k,sp,t] "Vækstfaktor i investeringer som giver nul installationsomkostningerne."
    eKUdn[k] "Eksponent som styrer anvendelsen af kapacitetsudnyttelse af kapital."
    eKUdnPersistens[k] "Eksponent som styrer træghed i kapacitetsudnyttelse af kapital."
    eLUdn                 "Eksponent som styrer anvendelsen af kapacitetsudnyttelse af arbejdskraft."
    eLUdnPersistens       "Eksponent som styrer træghed i kapacitetsudnyttelse af arbejdskraft."
    eKLBR[sp] "Substitutionselasticitet mellem qKLB og qR."
    eKLB[sp] "Substitutionselasticitet mellem qKL[sp] og qK[iB,sp]"
    eKL[sp] "Substitutionselasticitet mellem qK[im,sp] og qL."
    rAfskr_static[k,sp,t] "Udglattet afskrivningsrate til statisk kalibrering."
    gpI_s_static[k,sp,t] "Udglattet prisstigningsrate for investeringer til statisk kalibrering."
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
	$BLOCK B_production_private
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
      qKLB[sp,t] =E= uKLB[sp,t] * qKLBR[sp,t] * (pKLBR[sp,t]/pKLB[sp,t])**eKLBR[sp];

    # CES Demand for material/intermediate inputs
    E_qR[sp,t]$(tx0[t]).. qR[sp,t] =E= uR[sp,t] * qKLBR[sp,t] * (pKLBR[sp,t]/pR[sp,t])**eKLBR[sp];

    # ------------------------------------------------------------------------------------------------------------------
    # 2) Next level of CES tree: KLB-aggregate(KL-aggregate and building capital)
    # ------------------------------------------------------------------------------------------------------------------
    E_pKLB[sp,t]$(tx0[t]).. pKLB[sp,t] * qKLB[sp,t] =E= pK['iB',sp,t] * qK['iB',sp,t-1]/fq + pKL[sp,t] * qKL[sp,t];

    # CES demand: KL-aggregate as function of the KLB aggregate
    E_qKL[sp,t]$(tx0[t])..
      qKL[sp,t] =E= uKL[sp,t] * qKLB[sp,t] * (pKLB[sp,t] / pKL[sp,t])**eKLB[sp];

    # CES demand: building capital aggregate as function of the KLB aggregate
    E_qK_ib[sp,t]$(tx0[t] and d1K['iB',sp,t])..
      qK['iB',sp,t-1]/fq =E= uK['iB',sp,t] * qKLB[sp,t] * (rKUdn['iB',sp,t] * pKLB[sp,t]/pK['iB',sp,t])**eKLB[sp] / rKUdn['iB',sp,t];

    # ------------------------------------------------------------------------------------------------------------------
    # 3) Lowest level of CES tree: KL-aggregate (machine capital and labor)
    # ------------------------------------------------------------------------------------------------------------------
    E_pKL[sp,t]$(tx0[t]).. pKL[sp,t] * qKL[sp,t] =E= pL[sp,t] * qL[sp,t] + pK['iM',sp,t] * qK['iM',sp,t-1]/fq;

    # CES demand, machine capital aggregate as function of the KLB aggregate
    E_qK_im[sp,t]$(tx0[t] and d1K['iM',sp,t])..
      qK['iM',sp,t-1]/fq =E= uK['iM',sp,t] * qKL[sp,t] * (rKUdn['iM',sp,t] * pKL[sp,t]/pK['iM',sp,t])**eKL[sp] / rKUdn['iM',sp,t];

    # CES demand: labor as function of the KL aggregate
    E_nL[sp,t]$(tx0[t] and d1K['iM',sp,t-1])..
      qL[sp,t] / (qK['iM',sp,t-1]/fq * rKUdn['iM',sp,t])
      =E=
      uL[sp,t] / uK['iM',sp,t] * (pK['iM',sp,t]/rKUdn['iM',sp,t] / pL[sp,t])**eKL[sp];

    E_nL_xiM[sp,t]$(tx0[t] and not d1K['iM',sp,t-1])..
      qL[sp,t] =E= uL[sp,t] * qKL[sp,t];

    # Effective labor input is a function of..
    E_qL[s,t]$(tx0[t])..
      qL[s,t] =E= fProd[s,t] * qProd[t] * fW[s,t] # Sector specific labor productivity
                * rLUdn[s,t] # Variable factor utilization
                * rL2nL[t] # Effective hours pr. worker
                * (1-rOpslagOmk[s,t]) # Matching friction
                * nL[s,t]; # Number of workers

    # ------------------------------------------------------------------------------------------------------------------
    # Installation costs
    # ------------------------------------------------------------------------------------------------------------------
    # Aggregate lost production from installation costs
    E_qKInstOmk_kTot[sp,t]$(tx0[t] and d1K[kTot,sp,t]).. qKInstOmk[kTot,sp,t] =E= sum(k, qKInstOmk[k,sp,t]);

    E_qKInstOmk[k,sp,t]$(tx0[t] and d1K[k,sp,t])..
      qKInstOmk[k,sp,t] =E= uKInstOmk[k,sp]/2 * sqr(qI_s[k,sp,t] - qI_s[k,sp,t-1]/fq * fKInstOmk[k,sp,t]) / (qK[k,sp,t-1]/fq);

    # Derivatives
    E_dqKInstOmk2dqK[k,sp,t]$(tx0[t] and d1K[k,sp,t])..
      dKInstOmk2dK[k,sp,t] =E= - uKInstOmk[k,sp]/2 * sqr((qI_s[k,sp,t+1]*fq - qI_s[k,sp,t] * fKInstOmk[k,sp,t+1]) / qK[k,sp,t]);

    E_dqKInstOmk2dqI_s[k,sp,t]$(tx0[t] and d1K[k,sp,t])..
      dKInstOmk2dI[k,sp,t] =E= uKInstOmk[k,sp] * (qI_s[k,sp,t] - qI_s[k,sp,t-1]/fq * fKInstOmk[k,sp,t]) / (qK[k,sp,t-1]/fq);

    E_dqKInstOmkLead2dqI_s[k,sp,t]$(tx0E[t] and d1K[k,sp,t])..
      dKInstOmkLead2dI[k,sp,t] =E= - fKInstOmk[k,sp,t+1] / qK[k,sp,t] * dKInstOmk2dI[k,sp,t+1];

    # ------------------------------------------------------------------------------------------------------------------
    # Kapacitets-udnyttelse på kapital
    # ------------------------------------------------------------------------------------------------------------------
    E_rKUdn[k,sp,t]$(tx0E[t] and d1K[k,sp,t-1] and not sameas[sp,'bol'] and not sameas[sp,'udv'])..
      rKUdn[k,sp,t] =E= (pK[k,sp,t]/rKUdn[k,sp,t] / pK[k,sp,t+1]*rKUdn[k,sp,t+1])**eKUdn[k]
                      / (pK[k,sp,t-1]/rKUdn[k,sp,t-1] / pK[k,sp,t]*rKUdn[k,sp,t])**eKUdn[k]
                      * rKUdn[k,sp,t-1]**eKUdnPersistens[k]
                      * (1+jrKUdn[k,sp,t]);

    E_rKUdn_tEnd[k,sp,t]$(tEnd[t] and d1K[k,sp,t-1] and not sameas[sp,'bol'] and not sameas[sp,'udv'])..
      rKUdn[k,sp,t] =E= rKUdn[k,sp,t-1]**eKUdnPersistens[k]
                      * (1+jrKUdn[k,sp,t]);

    E_rKUdn_sTot[k,t]$(tx0[t])..
      rKUdn[k,sTot,t] * sum(s, qK[k,s,t-1]/fq) =E= sum(s, rKUdn[k,s,t] * qK[k,s,t-1]/fq);

    E_rKUdnSpBy[t]$(tx0[t])..
      rKUdnSpBy[t] * sum([k,spBy], qK[k,spBy,t-1]/fq) =E= sum([k,spBy], rKUdn[k,spBy,t] * qK[k,spBy,t-1]/fq);
 
    # ------------------------------------------------------------------------------------------------------------------
    # Kapacitets-udnyttelse på arbejdskraft
    # ------------------------------------------------------------------------------------------------------------------
    E_rLUdn[sp,t]$(tx0E[t])..
      rLUdn[sp,t] =E= (pL[sp,t] / pL[sp,t+1])**eLUdn
                    / (pL[sp,t-1] / pL[sp,t])**eLUdn
                    * rLUdn[sp,t-1]**eLUdnPersistens
                    * (1+jrLUdn[sp,t]);

    E_rLUdn_tEnd[sp,t]$(tEnd[t])..
      rLUdn[sp,t] =E= rLUdn[sp,t-1]**eLUdnPersistens
                    * (1+jrLUdn[sp,t]);

    E_rLUdn_sTot[t]$(tx0[t])..
      rLUdn[sTot,t] * nL[sTot,t] =E= sum(s, rLUdn[s,t] * nL[s,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Cost of capital
    # ------------------------------------------------------------------------------------------------------------------
		# Definition of user cost
    E_pK[k,sp,t]$((tx0E[t] or (sameas[sp,'bol'] and t0[t])) and d1K[k,sp,t])..
      pK[k,sp,t+1]*fp / (1+rVirkDisk[sp,t+1]) =E=
      # Tobin's q today and tomorrow
        pTobinsQ[k,sp,t] / (1-mtVirk[sp,t+1])
      - (1 - rAfskr[k,sp,t+1]) * pTobinsQ[k,sp,t+1]*fp / (1+rVirkDisk[sp,t+1]) / (1-mtVirk[sp,t+1])
      # Production tax on capital
      + tK[k,sp,t+1] * pI_s[k,sp,t+1]*fp / (1+rVirkDisk[sp,t+1])
      # Tax shield and collateral value on capital
      - (rVirkDisk[sp,t+1] / (1-mtVirk[sp,t+1]) - rRente['Obl',t+1]) * rLaan2K[t] * pI_s[k,sp,t] / (1+rVirkDisk[sp,t+1])
      # Discounted value of change in future installation costs from change in investments today
      + pKLBR[sp,t+1]*fp * dKInstOmk2dK[k,sp,t] / (1+rVirkDisk[sp,t+1])

      + jpK[k,sp,t+1];

    # Terminal condition for capital stock
    E_qK_tEnd[k,sp,t]$(tEnd[t] and d1K[k,sp,t] and not sameas[sp,'bol'])..
      qI_s[k,sp,t] =E= fq * qI_s[k,sp,t-1]/fq;

		# First order condition with respect to investment
	  E_pTobinsQ[k,sp,t]$(tx0E[t] and d1K[k,sp,t])..
      pTobinsQ[k,sp,t] =E= pI_s[k,sp,t] * (1-ErSkatAfskr[k,sp,t])
                         + pKLBR[sp,t] * (1-mtVirk[sp,t]) * dKInstOmk2dI[k,sp,t]
                         + 1/(1+rVirkDisk[sp,t+1]) * pKLBR[sp,t+1]*fp * (1-mtVirk[sp,t+1]) * dKInstOmkLead2dI[k,sp,t] * qK[k,sp,t];

    E_pTobinsQ_tEnd[k,sp,t]$(tEnd[t] and d1K[k,sp,t])..
      pTobinsQ[k,sp,t] =E= pI_s[k,sp,t] - pI_s[k,sp,t] * ErSkatAfskr[k,sp,t]
                         + pKLBR[sp,t] * (1-mtVirk[sp,t]) * dKInstOmk2dI[k,sp,t];

		# First order condition with respect to tax deductible capital ('Shadows price')
    E_ErSkatAfskr[k,sp,t]$(tx0E[t] and d1K[k,sp,t])..
      ErSkatAfskr[k,sp,t] =E= ((1-rSkatAfskr[k,t+1]) * ErSkatAfskr[k,sp,t+1] + mtVirk[sp,t+1] * rSkatAfskr[k,t+1]) / (1+rVirkDisk[sp,t+1]);
    E_ErSkatAfskr_tEnd[k,sp,t]$(tEnd[t] and d1K[k,sp,t])..
      ErSkatAfskr[k,sp,t] =E= mtVirk[sp,t] * rSkatAfskr[k,t] / (rVirkDisk[sp,t] + rSkatAfskr[k,t]);
     
	 # Capital accumulation
    E_qI_sp[k,sp,t]$(tx0[t] and d1I_s[k,sp,t]).. qI_s[k,sp,t] =E= qK[k,sp,t] - (1 - rAfskr[k,sp,t]) * qK[k,sp,t-1]/fq;

    # Inventory investments
    # Inventories are forecast as fixed shares of production - corrected with lagged prices to balance future aggregated chain index
    E_qI_s_iL_private[sp,t]$(tx0[t] and d1I_s['iL',sp,t])..
      qI_s['iL',sp,t] * pI_s['iL',sp,t-1]/fp =E= (1+jfqI_s_iL[t]) * rIL2y[sp,t] * pY[sp,t-1]/fp * qY[sp,t];
  $ENDBLOCK

	$MODEL B_production
		B_production_private
	;
$ENDIF