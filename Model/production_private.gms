# ======================================================================================================================
# Private sector production
# - Private sector demand for factors of production
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
	$GROUP G_production_private_variables
    # Quantities
    qKInstOmk[i_,s_,t] "Installationsomkostninger for kapital fordelt på private brancher."
    qKELBR[s_,t] "CES-aggregat mellem KELB-aggregat og materialer."
    qKELB[s_,t] "CES-aggregat mellem KEL-aggregat and bygningskapital."
    qKEL[sp,t] "CES-aggregat mellem KE-aggregat og arbejdskraft."
    qKE[sp,t] "CES-aggregat mellem maskinkapital og Energi."
    qR[r_,t] "Materialeinput fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[fVm] eller ADAM[fVm<i>]"
    qE[r_,t] "Energiinput fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[fVe] eller ADAM[fVe<i>]"
    qK[i_,s_,t] "Ultimokapital fordelt efter kapitaltype og branche, Kilde: ADAM[fKnm<i>] eller ADAM[fKnb<i>]"
    qK[i_,s_,t] "Ultimokapital fordelt efter kapitaltype og branche, NB:Vægtet med investeringspriser - ikke lig den fra NR!"
    qK[i_,s_,t] "Ultimokapital fordelt efter kapitaltype og branche, NB:Vægtet med investeringspriser - ikke lig den fra NR!"
    qLUdn[s_,t] "Arbejdskraft i effektive enheder."
    qKUdn[i_,s_,t] "Ultimokapital efter kapacitetsudnyttelse, med pris normaliseret til 1 i basisår."
    qI_s[i_,s_,t] "Investeringer fordelt på brancher, Kilde: ADAM[fI<i>] eller ADAM[fIm<i>] eller ADAM[fIb<i>]"
    qL[s_,t] "Arbejdskraft i effektive enheder før kapacitetsudnyttelse."

    # Prices
    pKE[sp,t] "CES pris af qKE-aggregat."
    pKEL[sp,t] "CES pris af qKEL-aggregat."
    pKELB[s_,t] "CES pris af qKELB-aggregat."
    pKELBR[s_,t] "Marginalomkostning fra produktion før rest-produktionsskatter."
    pK[k,s_,t] "User cost af kapital (skyggepris i første periode hvor K er eksogen)."
    pK_gns[k,s_,t] "User cost af kapital uden marginal justeringsomkostning, og med rAktieDrift som diskonteringsrate"
    pKUdn[k,s_,t] "User cost af kapital efter kapacitetsudnyttelse. Normaliseret til 1 i basisår."
    pKI[i_,s_,t] "Investeringspris, pI_s, sammenvejet med kapitalapparat"
    pKI[i_,s_,t] "Investeringspris, pI_s, sammenvejet med kapitalapparat"
    pLUdn[s_,t] "User cost for effektiv arbejdskraft i produktionsfunktion."
    pY0[s_,t] "Marginalomkostning fra produktion + øvrige produktionsskatter"
    rLUdn[s_,t] "Kapacitetsudnyttelse af arbejdskraft."
    rKUdn[i_,s_,t] "Kapacitetsudnyttelse af sidste periodes qK."
    hL[s_,t] "Erlagte arbejdstimer fordelt på brancher, Kilde: ADAM[hq] eller ADAM[hq<i>]"
    dKInstOmk2dK[k,s_,t] "qKInstOmk[t] differentieret ift. qK[t]"
    dKInstOmk2dKLag[k,s_,t] "qKInstOmk[t] differentieret ift. qK[t-1]"
    mtVirk[t] "Marginal indkomstskat hos virksomheder."
    fuY_spTot[t] "Korrektionsfaktor for sammensætningseffekt i bestemmelse af qKELBR[spTot,t]"
    fR[s_,t] "Korrektionsfaktor for sammensætningseffekt i bestemmelse af qR[s_,t] - skal være 1 for sp"
    fB[s_,t] "Korrektionsfaktor for sammensætningseffekt i bestemmelse af qKUdn['iB',s_,t] - skal være 1 for sp"
    fL[s_,t] "Korrektionsfaktor for sammensætningseffekt i bestemmelse af qLUdn[s_,t] - skal være 1 for sp"
    fE[s_,t] "Korrektionsfaktor for sammensætningseffekt i bestemmelse af qE[s_,t] - skal være 1 for sp"
    fK[s_,t] "Korrektionsfaktor for sammensætningseffekt i bestemmelse af qKUdn['iM',s_,t] - skal være 1 for sp"
    rR2KELBR[s_,t] "R-andel i KELBR-nest."
    rB2KELBR[s_,t] "B-andel i KELBR-nest."
    rL2KELBR[s_,t] "L-andel i KELBR-nest."
    rE2KELBR[s_,t] "E-andel i KELBR-nest."
    rK2KELBR[s_,t] "K-andel i KELBR-nest."
    rPrisEffekt_R[s_,t] "Substitutionseffekt ift. baseline for priser til R"
    rPrisEffekt_B[s_,t] "Substitutionseffekt ift. baseline for priser til B"
    rPrisEffekt_L[s_,t] "Substitutionseffekt ift. baseline for priser til L"
    rPrisEffekt_E[s_,t] "Substitutionseffekt ift. baseline for priser til E"
    rPrisEffekt_K[s_,t] "Substitutionseffekt ift. baseline for priser til K"
    fpK_spTot[k,t] "Korrektionsfaktor for sammensætningseffekt i bestemmelse af pK[spTot,t]"

    # Housing-kapital er eksogent og CES-efterspørgsel efter K bestemmer i stedet housing produktionen
    qY[s_,t]
    rAfskr[k,s_,t] "Afskrivningsrate for kapital."
    uKELBR[sp,t] "Parameter i produktionsnest for KELBR - konstantled i Cobb-Douglas limit af CES-produktions-nest."
    uKELB[sp,t] "Parameter i produktionsnest for KELB - konstantled i Cobb-Douglas limit af CES-produktions-nest."
    uKEL[sp,t] "Parameter i produktionsnest for KEL - konstantled i Cobb-Douglas limit af CES-produktions-nest."
    uKE[sp,t] "Parameter i produktionsnest for KE - konstantled i Cobb-Douglas limit af CES-produktions-nest."
    rKInstOmk[k,s_,t] "Hjælpevariabel til installationsomkostninger."
	;

  $GROUP G_production_private_constants
    eKUdn[i_,s_] "Eksponent som styrer anvendelsen af kapacitetsudnyttelse af kapital."
    eKUdnPersistens[k] "Eksponent som styrer træghed i kapacitetsudnyttelse af kapital."
    eLUdn "Eksponent som styrer anvendelsen af kapacitetsudnyttelse af arbejdskraft."
    eLUdnPersistens "Eksponent som styrer træghed i kapacitetsudnyttelse af arbejdskraft."
    eKELBR[s_] "Substitutionselasticitet mellem qKELB og qR."
    eKELB[s_] "Substitutionselasticitet mellem qKEL[sp] og qKUdn[iB,sp]"
    eKEL[sp] "Substitutionselasticitet mellem qK[iM,sp] og qLUdn."
    eKE[s_] "Substitutionselasticitet mellem qK[iM,sp] og qE."
    fuY[s_] "Forhold mellem Y og KELBR i basisår hvor pY og pKELBR sættes til 1"
  ;

  $GROUP+ G_constants G_production_private_constants;
  
  $GROUP G_production_private_exogenous_forecast
    rIL2Y[s_,t]$(sp[s_] and d1I_s['iL',sp,t]) "Lagerinvesteringer ift. samlet produktion."
  ;
  $GROUP+ G_exogenous_forecast G_production_private_exogenous_forecast$(tx1[t]);

  $GROUP G_production_private_forecast_as_zero
    jfrLUdn[sp,t] "J-led."
    jfrLUdn_t[t] "J-led."
    jfrKUdn[k,sp,t] "J-led."
    jfrKUdn_k[k,t] "J-led."
    jpK_t[k,t] "J-led."
    jrKInstOmk[k,sp,t] "J-led."
    jpK_s[k,sp,t] "J-led."
  ;
  $GROUP+ G_forecast_as_zero G_production_private_forecast_as_zero$(tx1[t]);

  $GROUP G_production_private_ARIMA_forecast
    rAfskr[k,s_,t]$(s[s_]) "Afskrivningsrate for kapital."
    rE2KE[sp,t] "Energi-andel i KE-nest."
    rL2KEL[sp,t] "L-andel i KEL-nest."
    rB2KELB[sp,t] "B-andel i KELB-nest."
    rR2KELBR[s_,t]$(sp[s_]) "R-andel i KELBR-nest."
    uL[s_,t]$(sp[s_]) "Arbejdskraft-besparende produktivitet."
  ;
  $GROUP+ G_ARIMA_forecast G_production_private_ARIMA_forecast;

  $GROUP G_production_private_fixed_forecast
    rAfskr_static[k,sp,t] "Udglattet afskrivningsrate til statisk kalibrering."
    gpI_s_static[k,sp,t] "Udglattet prisstigningsrate for investeringer til statisk kalibrering."

    uKInstOmk[k,s_,t] "Parameter for installationsomkostninger."
    rVirkDisk[s_,t] "Selskabernes diskonteringsrate."
    uK[k,s_,t]$(sp[s_]) "Kapital-besparende produktivitet."
    rKUdn[i_,s_,t]$(eKUdn.l[i_,s_] = 0) 
    rLUdn[off,t] 
  ;
  $GROUP+ G_fixed_forecast G_production_private_fixed_forecast;

$ENDIF

# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
	$BLOCK B_production_private_static G_production_private_static $(tx0[t])
    # Investeringspriser vægtet med kapital
    # Boligkapital er en undtagelse og er givet ud fra husholdningernes forbrugsvalg
    .. qK['iB','bol',t] =E= qKBolig[t] + qKLejebolig[aTot,t];

    # Capital accumulation
    $(d1I_s[k,sp,t]).. qI_s[k,sp,t] =E= qK[k,sp,t] - (1 - rAfskr[k,sp,t]) * qK[k,sp,t-1]/fq;

    # Inventory investments
    $(d1I_s['iL',sp,t]).. qI_s['iL',sp,t] =E= rIL2Y[sp,t] * qY[sp,t];
  $ENDBLOCK


  $BLOCK B_production_private_forwardlooking G_production_private_forwardlooking $(tx0[t])
    # ------------------------------------------------------------------------------------------------------------------
    # Two versions of the private production model are written here: an aggregate and a disaggregate version.
    # The disaggregate version is the core model.
    # The aggregate version is a simplified version useful for analyzing overall responses.
    # The difference between the two are as far as possible collected in explicit composition effect terms.
    # ------------------------------------------------------------------------------------------------------------------

    # ------------------------------------------------------------------------------------------------------------------
    # Disaggregate version
    # ------------------------------------------------------------------------------------------------------------------

    # ------------------------------------------------------------------------------------------------------------------
    # CES-prices and cost of production
    # ------------------------------------------------------------------------------------------------------------------  
    .. pY0[sp,t] * qY[sp,t] =E= pKELBR[sp,t] * (qKELBR[sp,t] - 
          qKInstOmk[kTot,sp,t]) + vtNetYRest[sp,t] + (tE[sp,t] * vY[sp,t])$(lan[sp]);

    .. pKELBR[sp,t] * qKELBR[sp,t] =E= pR[sp,t] * qR[sp,t] + pKELB[sp,t] * qKELB[sp,t];

    .. pKELB[sp,t] * qKELB[sp,t] =E= pKUdn['iB',sp,t] * qKUdn['iB',sp,t] + pKEL[sp,t] * qKEL[sp,t];

    .. pKEL[sp,t] * qKEL[sp,t] =E= pLUdn[sp,t] * qLUdn[sp,t] + pKE[sp,t] * qKE[sp,t];

    .. pKE[sp,t] * qKE[sp,t] =E= pE[sp,t] * (1+tE[sp,t]) * qE[sp,t] + pKUdn['iM',sp,t] * qKUdn['iM',sp,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Gross production from net production
    # ------------------------------------------------------------------------------------------------------------------
    qKELBR[sp,t].. qY[sp,t] =E= fuY[sp] * (qKELBR[sp,t] - qKInstOmk[kTot,sp,t]);

		# ------------------------------------------------------------------------------------------------------------------
    # 1) Top of CES tree: gross production KELBR (KELB-aggregate and material/intermediate inputs)
		# ------------------------------------------------------------------------------------------------------------------
    # CES Demand for capital-labor aggregate
    $(eKELBR.l[sp] <> 1)..
      qKELB[sp,t] =E= (1-rR2KELBR[sp,t]) * qKELBR[sp,t] * (pKELBR[sp,t] / pKELB[sp,t])**eKELBR[sp];
    qKELB&_e1[sp,t]$(eKELBR.l[sp] = 1)..
      qKELBR[sp,t] =E= uKELBR[sp,t] * qKELB[sp,t]**(1-rR2KELBR[sp,t]) * qR[sp,t]**rR2KELBR[sp,t];
    uKELBR[sp,t].. # konstanten gør at Cobb-Douglas-tilfældet er konsistent med CES-funktionen i grænsen, når elasticiteten nærmer sig 1. Udtrykket udledes ved at tage log, tage grænseværdien ved e->1, bruge L'Hôpitals regel og omskrive.
      1 =E= uKELBR[sp,t] * (1-rR2KELBR[sp,t])**(1-rR2KELBR[sp,t]) * rR2KELBR[sp,t]**rR2KELBR[sp,t];

    # CES Demand for material/intermediate inputs
    .. qR[sp,t] =E= rR2KELBR[sp,t] * qKELBR[sp,t] * (pKELBR[sp,t] / pR[sp,t])**eKELBR[sp];

    # ------------------------------------------------------------------------------------------------------------------
    # 2) Next level of CES tree: KELB-aggregate(KEL-aggregate and structures capital)
    # ------------------------------------------------------------------------------------------------------------------
    # CES demand: KEL-aggregate as function of the KELB aggregate
    $(eKELB.l[sp] <> 1)..
      qKEL[sp,t] =E= (1-rB2KELB[sp,t]) * qKELB[sp,t] * (pKELB[sp,t] / pKEL[sp,t])**eKELB[sp];
    qKEL&_e1[sp,t]$(eKELB.l[sp] = 1)..
      qKELB[sp,t] =E= uKELB[sp,t] * qKEL[sp,t]**(1-rB2KELB[sp,t]) * qKUdn['iB',sp,t]**rB2KELB[sp,t];
    uKELB[sp,t].. # konstanten gør at Cobb-Douglas-tilfældet er konsistent med CES-funktionen i grænsen, når elasticiteten nærmer sig 1. Udtrykket udledes ved at tage log, tage grænseværdien ved e->1, bruge L'Hôpitals regel og omskrive.
      1 =E= uKELB[sp,t] * (1-rB2KELB[sp,t])**(1-rB2KELB[sp,t]) * rB2KELB[sp,t]**rB2KELB[sp,t];

    # CES demand: structures capital aggregate as function of the KELB aggregate
    # For bolig-branchen bestemmer denne pK
    $(d1K['iB',sp,t])..
      qKUdn['iB',sp,t] =E= rB2KELB[sp,t] * qKELB[sp,t] * (pKELB[sp,t] / pKUdn['iB',sp,t])**eKELB[sp];

    # ------------------------------------------------------------------------------------------------------------------
    # 3) Next level of CES tree: KEL-aggregate (labor and KE-aggregate)
    # ------------------------------------------------------------------------------------------------------------------
    # CES demand: KE aggregate as a function of the KEL aggregate
    E_qKE[sp,t]$(eKEL.l[sp] <> 1) ..
      qKE[sp,t] =E= (1-rL2KEL[sp,t]) *  qKEL[sp,t] * (pKEL[sp,t] / pKE[sp,t])**eKEL[sp];

    E_qKE_e1[sp,t]$(eKEL.l[sp] = 1)..
      qKEL[sp,t] =E= uKEL[sp,t] * qKE[sp,t]**(1-rL2KEL[sp,t]) * qLUdn[sp,t]**rL2KEL[sp,t];
    uKEL[sp,t].. # konstanten gør at Cobb-Douglas-tilfældet er konsistent med CES-funktionen i grænsen, når elasticiteten nærmer sig 1. Udtrykket udledes ved at tage log, tage grænseværdien ved e->1, bruge L'Hôpitals regel og omskrive.
      1 =E= uKEL[sp,t] * (1-rL2KEL[sp,t])**(1-rL2KEL[sp,t]) * rL2KEL[sp,t]**rL2KEL[sp,t];

    # CES demand: labor as function of the KEL aggregate
    .. qLUdn[sp,t] =E= rL2KEL[sp,t] * qKEL[sp,t] * (pKEL[sp,t] / pLUdn[sp,t])**eKEL[sp];

    # Labor input in productivity units net of hiring costs, before factor utilization 
    # E_qL[sp,t].. qLUdn[sp,t] =E= qL[sp,t] * (uL[sp,t] * rLUdn[sp,t] * pL[sp,tBase] / rLUdn[sp,tBase]);
    qL[sp,t].. qLUdn[sp,t] =E= qL[sp,t] * (uL[sp,t] * rLUdn[sp,t]);

    # Effective user cost of labor
    # E_pLUdn[sp,t].. pLUdn[sp,t] =E= pL[sp,t] / (uL[sp,t] * rLUdn[sp,t] * pL[sp,tBase] / rLUdn[sp,tBase]);
    .. pLUdn[sp,t] =E= pL[sp,t] / (uL[sp,t] * rLUdn[sp,t]);

    # Total hours worked
    hL[sp,t]..
      qL[sp,t] =E= qProd[sp,t] # Sector specific labor productivity
                 * (1-rOpslagOmk[sp,t]) # Matching friction
                 * hL[sp,t]; # Number of hours worked

    # Public sector has exogenous hL
    .. qL['off',t] =E= qProd['off',t] # Sector specific labor productivity
                     * (1-rOpslagOmk['off',t]) # Matching friction
                     * hL['off',t]; # Number of hours worked

    .. qLUdn['off',t] =E= uL['off',t] * qL['off',t];

    # ------------------------------------------------------------------------------------------------------------------
    # 4) bottom level of CES tree: KE-aggregate (equipment capital and Energy)
    # ------------------------------------------------------------------------------------------------------------------  
    # CES demand for energy as a function of the KE-aggregate
    $(d1K['iM',sp,t] and eKE.l[sp] <> 1) ..
      qE[sp,t] =E= rE2KE[sp,t] * qKE[sp,t] * (pKE[sp,t] / ((1+tE[sp,t]) * pE[sp,t]))**eKE[sp];

    qE&_xim[sp,t]$(not d1K['iM',sp,t]) ..
      qE[sp,t] =E= rE2KE[sp,t] * qKE[sp,t];

    qE&_e1[sp,t]$(eKE.l[sp] = 1 and d1K['iM',sp,t])..
      qKE[sp,t] =E= uKE[sp,t] * qKUdn['iM',sp,t]**(1-rE2KE[sp,t]) * qE[sp,t]**rE2KE[sp,t];
    uKE[sp,t]$(d1K['iM',sp,t]).. # konstanten gør at Cobb-Douglas-tilfældet er konsistent med CES-funktionen i grænsen, når elasticiteten nærmer sig 1. Udtrykket udledes ved at tage log, tage grænseværdien ved e->1, bruge L'Hôpitals regel og omskrive.
      1 =E= uKE[sp,t] * (1-rE2KE[sp,t])**(1-rE2KE[sp,t]) * rE2KE[sp,t]**rE2KE[sp,t];

    # CES demand for equipment capital aggregate as function of the KE aggregate
    $(d1K['iM',sp,t])..
      qKUdn['iM',sp,t] =E= (1-rE2KE[sp,t]) * qKE[sp,t] * (pKE[sp,t] / pKUdn['iM',sp,t])**eKE[sp];

    # Effective capital
    qK[k,sp,t]$(d1K[k,sp,t])..
      qKUdn[k,sp,t] =E= qK[k,sp,t-1]/fq * (uK[k,sp,t] * rKUdn[k,sp,t] * pK[k,sp,tBase]);

    # Effective user cost of capital
    $(d1K[k,sp,t])..
      pKUdn[k,sp,t] =E= pK[k,sp,t] / (uK[k,sp,t] * rKUdn[k,sp,t] * pK[k,sp,tBase]);

    # ------------------------------------------------------------------------------------------------------------------
    # Kapital-installationsomkostninger
    # ------------------------------------------------------------------------------------------------------------------
    $(d1K[k,sp,t])..
      rKInstOmk[k,sp,t] =E= qK[k,sp,t]/qK[k,sp,t-1] / (qK[k,sp,t-1]/qK[k,sp,t-2]) + jrKInstOmk[k,sp,t];
      
    $(d1K[k,sp,t])..
      qKInstOmk[k,sp,t] =E= uKInstOmk[k,sp,t]/2 * sqr(rKInstOmk[k,sp,t] - 1) * qK[k,sp,t-1]/fq;

    # Samlet output tabt til installationsomkostninger
    $(d1K[kTot,sp,t]).. qKInstOmk[kTot,sp,t] =E= sum(k, qKInstOmk[k,sp,t]);

    # Derivatives
    $(tx0E[t] and d1K[k,sp,t])..
      dKInstOmk2dKLag[k,sp,t] =E= - 2 * uKInstOmk[k,sp,t] * (rKInstOmk[k,sp,t] - 1) * rKInstOmk[k,sp,t]
                                + qKInstOmk[k,sp,t] / (qK[k,sp,t-1]/fq);

    $(tx0E[t] and d1K[k,sp,t])..
      dKInstOmk2dK[k,sp,t] =E= uKInstOmk[k,sp,t] * (rKInstOmk[k,sp,t] - 1) * rKInstOmk[k,sp,t]
                                                 * qK[k,sp,t-1]/fq / qK[k,sp,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Kapacitets-udnyttelse på kapital
    # ------------------------------------------------------------------------------------------------------------------
    $(tx0E[t] and d1K[k,sp,t-1] and eKUdn.l[k,sp] <> 0)..
      rKUdn[k,sp,t] =E= (pK[k,sp,t] / rKUdn[k,sp,t] / (pK[k,sp,t+1] / rKUdn[k,sp,t+1]))**eKUdn[k,sp]
                      / (pK[k,sp,t-1] / rKUdn[k,sp,t-1] / (pK[k,sp,t] / rKUdn[k,sp,t]))**eKUdn[k,sp]
                      * rKUdn[k,sp,t-1]**eKUdnPersistens[k]
                      * (1 + jfrKUdn[k,sp,t] + jfrKUdn_k[k,t]);

    rKUdn&_tEnd[k,sp,t]$(tEnd[t] and d1K[k,sp,t-1] and eKUdn.l[k,sp] <> 0)..
      rKUdn[k,sp,t] =E= rKUdn[k,sp,t-1]**eKUdnPersistens[k]
                      * (1 + jfrKUdn[k,sp,t] + jfrKUdn_k[k,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Kapacitets-udnyttelse på arbejdskraft
    # ------------------------------------------------------------------------------------------------------------------
    rLUdn[sp,t]$(tx0E[t])..
      rLUdn[sp,t] =E= (pL[sp,t] / rLUdn[sp,t] / (pL[sp,t+1] / rLUdn[sp,t+1]))**eLUdn
                    / (pL[sp,t-1] / rLUdn[sp,t-1] / (pL[sp,t] / rLUdn[sp,t]))**eLUdn
                    * rLUdn[sp,t-1]**eLUdnPersistens
                    * (1 + jfrLUdn[sp,t] + jfrLUdn_t[t]);

    rLUdn&_tEnd[sp,t]$(tEnd[t])..
      rLUdn[sp,t] =E= rLUdn[sp,t-1]**eLUdnPersistens * (1 + jfrLUdn[sp,t] + jfrLUdn_t[t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Cost of capital
    # ------------------------------------------------------------------------------------------------------------------
		# Definition of user cost
    pK[k,sp,t]$((tx0E[t] and not bol[sp]) and d1K[k,sp,t])..
      pK[k,sp,t+1]*fp =E=
      # Tobin's q today and tomorrow
        (1+rVirkDisk[sp,t+1]) / (1-mtVirk[t+1]) * (1-dnvAfskrFradrag2dvI_s[k,sp,t]) * pI_s[k,sp,t]
      - (1-rAfskr[k,sp,t+1]) / (1-mtVirk[t+1]) * (1-dnvAfskrFradrag2dvI_s[k,sp,t+1]) * pI_s[k,sp,t+1]*fp
      # Production tax on capital
      + tK[k,sp,t+1] * pI_s[k,sp,t+1]*fp
      # Tax shield and collateral value on capital
      - (rVirkDisk[sp,t+1] / (1-mtVirk[t+1]) - (mrVirkDriftPasRente[k,sp,t+1] + mrVirkDriftPasOmv[k,sp,t+1])) * mrLaan2K[k,sp,t] * pI_s[k,sp,t]
      # Change in installation costs today
      + (1+rVirkDisk[sp,t+1]) / (1-mtVirk[t+1]) * pKELBR[sp,t] * (1-mtVirk[t]) * dKInstOmk2dK[k,sp,t]
      # Discounted value of change in future installation costs from change in investments today
      + pKELBR[sp,t+1]*fp * dKInstOmk2dKLag[k,sp,t+1]
      # Derivative of profits two periods ahead wrt. capital, which we normally consider exogenous to the firm
      #  + ((1-mtVirk[t+2]) / (1+rVirkDisk[sp,t+2]) * pKELBR[sp,t+2]*fp * uKInstOmk[k,sp,t+2] * (qK[k,sp,t+2]/qK[k,sp,t+1] / (qK[k,sp,t+1]/qK[k,sp,t]) - 1) * qK[k,sp,t+2]/qK[k,sp,t+1])$(not tEnd[t+1])
      + jpK_s[k,sp,t+1] + jpK_t[k,t+1];

    # Shadow price of capital in housing sector is set residually to match price of housing services assuming zero markup
    qY[sp,t]$(bol[sp]).. pY[sp,t] =E= pY0[sp,t];

    # Terminal condition for capital stock
    pK&_tEnd[k,sp,t]$(tEnd[t] and d1K[k,sp,t] and not bol[sp]).. qI_s[k,sp,t]/qK[k,sp,t] =E= qI_s[k,sp,t-1]/qK[k,sp,t-1];

    # Gennemsnitlig user cost med cost of capital, fremfor hurdle rate, og uden installationsomkostninger
    pK_gns[k,sp,t]$((tx0[t] and not bol[sp]) and d1K[k,sp,t])..
      pK_gns[k,sp,t]*fp =E=
      # Tobin's q today and tomorrow
        (1+rAktieDrift[t]) / (1-mtVirk[t]) * (1-dnvAfskrFradrag2dvI_s[k,sp,t]) * pI_s[k,sp,t]
      - (1-rAfskr[k,sp,t]) / (1-mtVirk[t]) * (1-dnvAfskrFradrag2dvI_s[k,sp,t]) * pI_s[k,sp,t] * fp
      # Production tax on capital
      + tK[k,sp,t] * pI_s[k,sp,t]*fp
      # Tax shield and collateral value on capital
      - (rAktieDrift[t] / (1-mtVirk[t]) - (mrVirkDriftPasRente[k,sp,t] + mrVirkDriftPasOmv[k,sp,t])) * mrLaan2K[k,sp,t] * pI_s[k,sp,t];


    # ------------------------------------------------------------------------------------------------------------------
    # Hjælpe-ligninger til faktor-efterspørgsel
    # ------------------------------------------------------------------------------------------------------------------

    # ------------------------------------------------------------------------------------------------------------------
    # Demand for material/intermediate inputs - R
    # ------------------------------------------------------------------------------------------------------------------
    # fR[sp,t] skal være 1
    fR[sp,t]..  qR[sp,t]  =E= fR[sp,t] * rR2KELBR[sp,t] * qKELBR[sp,t] * rPrisEffekt_R[sp,t];

    .. rPrisEffekt_R[sp,t] =E= (pKELBR[sp,t] / pR[sp,t])**eKELBR[sp];

    # ------------------------------------------------------------------------------------------------------------------
    # Demand: structures capital aggregate in effective units - qKUdn_iB
    # ------------------------------------------------------------------------------------------------------------------
    # fB[sp,t] skal være 1
    fB[sp,t].. qKUdn['iB',sp,t] =E= fB[sp,t] * rB2KELBR[sp,t] * qKELBR[sp,t] * rPrisEffekt_B[sp,t];

    .. rB2KELBR[sp,t] =E= rB2KELB[sp,t] * (1-rR2KELBR[sp,t]);

    .. rPrisEffekt_B[sp,t] =E= (pKELBR[sp,t] / pKELB[sp,t])**eKELBR[sp] 
         * (pKELB[sp,t] / pKUdn['iB',sp,t])**eKELB[sp];

    # ------------------------------------------------------------------------------------------------------------------
    # Labor input in productivity units net of hiring costs, before factor utilization - qLUdn
    # ------------------------------------------------------------------------------------------------------------------
    # fL[sp,t] skal være 1
    fL[sp,t].. qLUdn[sp,t] =E= fL[sp,t] * rL2KELBR[sp,t] * qKELBR[sp,t] * rPrisEffekt_L[sp,t];

    rL2KELBR[sp,t].. rL2KELBR[sp,t] =E= rL2KEL[sp,t] * (1-rB2KELB[sp,t]) * (1-rR2KELBR[sp,t]);

    ..  rPrisEffekt_L[sp,t] =E= (pKELBR[sp,t] / pKELB[sp,t])**eKELBR[sp] * (pKELB[sp,t] / pKEL[sp,t])**eKELB[sp]
                                                                       * (pKEL[sp,t] / pLUdn[sp,t])**eKEL[sp] ;
    # ------------------------------------------------------------------------------------------------------------------
    # Demand for energy - E
    # ------------------------------------------------------------------------------------------------------------------
    # fE[sp,t] skal være 1
    fE[sp,t].. 
      qE[sp,t] =E= fE[sp,t] * rE2KELBR[sp,t] * qKELBR[sp,t] * rPrisEffekt_E[sp,t];

    .. rE2KELBR[sp,t] =E= rE2KE[sp,t] * (1-rL2KEL[sp,t]) * (1-rB2KELB[sp,t]) * (1-rR2KELBR[sp,t]);

    .. rPrisEffekt_E[sp,t] =E= (pKELBR[sp,t] / pKELB[sp,t])**eKELBR[sp] * (pKELB[sp,t] / pKEL[sp,t])**eKELB[sp]
                              * (pKEL[sp,t] / pKE[sp,t])**eKEL[sp]     * (pKE[sp,t] / ((1+tE[sp,t]) * pE[sp,t]))**eKE[sp];

    # ------------------------------------------------------------------------------------------------------------------
    # Demand for equipment capital aggregate in effective uinits - qKUdn_iM
    # ------------------------------------------------------------------------------------------------------------------  
    # fK[sp,t] skal være 1
    fK[sp,t]$(d1K['iM',sp,t])..  qKUdn['iM',sp,t] =E= fK[sp,t] * rK2KELBR[sp,t] * qKELBR[sp,t] * rPrisEffekt_K[sp,t];

    .. rK2KELBR[sp,t] =E= (1-rE2KE[sp,t]) * (1-rL2KEL[sp,t]) * (1-rB2KELB[sp,t]) * (1-rR2KELBR[sp,t]);

    $(d1K['iM',sp,t])..
      rPrisEffekt_K[sp,t] =E= (pKELBR[sp,t] / pKELB[sp,t])**eKELBR[sp] * (pKELB[sp,t] / pKEL[sp,t])**eKELB[sp]
                              * (pKEL[sp,t] / pKE[sp,t])**eKEL[sp]     * (pKE[sp,t] / pKUdn['iM',sp,t])**eKE[sp];


    # ------------------------------------------------------------------------------------------------------------------
    # Aggregate version
    # ------------------------------------------------------------------------------------------------------------------

    # ------------------------------------------------------------------------------------------------------------------
    # Cost of production
    # ------------------------------------------------------------------------------------------------------------------  
    $(t.val > %cal_start%)..
      pY0[spTot,t] * qY[spTot,t] =E= pKELBR[spTot,t] * (qKELBR[spTot,t] - qKInstOmk[kTot,spTot,t]) + vtNetYRest[spTot,t];

    $(t.val > %cal_start%).. 
      pKELBR[spTot,t] * qKELBR[spTot,t] =E= pKUdn['iM',spTot,t] * qKUdn['iM',spTot,t] 
                                          + (1+tE[spTot,t]) * pE[spTot,t] * qE[spTot,t]
                                          + pLUdn[spTot,t] * qLUdn[spTot,t] 
                                          + pKUdn['iB',spTot,t] * qKUdn['iB',spTot,t]
                                          + pR[spTot,t] * qR[spTot,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Gross production from net production
    # ------------------------------------------------------------------------------------------------------------------
    qKELBR[spTot,t]$(t.val > %cal_start%)..
     pKELBR[spTot,t-1]/fp * qKELBR[spTot,t] =E= sum(sp, pKELBR[sp,t-1]/fp * qKELBR[sp,t]);

    # OBS: Benyt denne ligning til at analysere på aggregeret niveau
    # fuY_spTot fanger sammensætningseffekter 
    fuY_spTot[t]$(t.val > %cal_start%)..
      qY[spTot,t] =E= fuY_spTot[t] * (qKELBR[spTot,t] - qKInstOmk[kTot,spTot,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Demand for material/intermediate inputs - R
    # ------------------------------------------------------------------------------------------------------------------
    # fR[spTot,t] fanger sammensætningseffekter 
    # OBS: Benyt denne ligning til at analysere på aggregeret niveau
    fR&_spTot[sptot,t]$(t.val > %cal_start%).. 
      qR[spTot,t]  =E= fR[spTot,t] * rR2KELBR[spTot,t] * qKELBR[spTot,t] * rPrisEffekt_R[spTot,t];

    # Hvad er effekten fra andelsparametrene givet qKELBR og i fravær af sammensætnings- og priseffekter?
    # Vi udnytter pR[s_,tBase] = 1, fR[spTot,tBase] = 1 og rPrisEffekt_R[spTot,tBase] = 1
    $(t.val > %cal_start%)..
      rR2KELBR[spTot,t] * qKELBR[spTot,tBase] =E= sum(sp, rR2KELBR[sp,t] * qKELBR[sp,tBase]);

    # Hvad er priseffekterne i fravær af sammensætningseffekter?
    # Vi udnytter pR[s_,tBase] = 1, fR[spTot,tBase] = 1 og rPrisEffekt_R[spTot,tBase] = 1
    rPrisEffekt_R[spTot,t]$(t.val > %cal_start%)..
      rR2KELBR[spTot,tBase] * qKELBR[spTot,tBase] * rPrisEffekt_R[spTot,t] 
      =E= 
      sum(sp, rR2KELBR[sp,tBase] * qKELBR[sp,tBase] * rPrisEffekt_R[sp,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Demand: structures capital aggregate in effective units - qKUdn_iB
    # ------------------------------------------------------------------------------------------------------------------
    qKUdn['iB',spTot,t]$(t.val > %cal_start%).. 
      pKUdn['iB',spTot,t-1]/fp * qKUdn['iB',spTot,t] =E= sum(sp, pKUdn['iB',sp,t-1]/fp * qKUdn['iB',sp,t]);

    # fB[spTot,t] fanger sammensætningseffekter 
    # OBS: Benyt denne ligning til at analysere på aggregeret niveau
    fB&_spTot[spTot,t]$(t.val > %cal_start%)..
      qKUdn['iB',spTot,t] =E= fB[spTot,t] * rB2KELBR[spTot,t] * qKELBR[spTot,t] * rPrisEffekt_B[spTot,t];

    # # Hvad er effekten fra andelsparametrene givet qKELBR og i fravær af sammensætnings- og priseffekter?
    # # Vi udnytter pKUdn[k,s_,tBase] = 1, fB[spTot,tBase] = 1 og rPrisEffekt_B[spTot,tBase] = 1
    $(t.val > %cal_start%)..
      rB2KELBR[spTot,t] * qKELBR[spTot,tBase] =E= sum(sp, rB2KELBR[sp,t] * qKELBR[sp,tBase]);

    # Hvad er priseffekterne i fravær af sammensætningseffekter?
    # Vi udnytter pKUdn[k,s_,tBase] = 1, fB[spTot,tBase] = 1 og rPrisEffekt_B[spTot,tBase] = 1
    rPrisEffekt_B[spTot,t]$(t.val > %cal_start%)..
      rB2KELBR[spTot,tBase] * qKELBR[spTot,tBase] * rPrisEffekt_B[spTot,t]
      =E= 
      sum(sp, rB2KELBR[sp,tBase] * qKELBR[sp,tBase] * rPrisEffekt_B[sp,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Labor input in productivity units net of hiring costs, before factor utilization - qLUdn
    # ------------------------------------------------------------------------------------------------------------------
    qLUdn[spTot,t]$(t.val > %cal_start%).. 
      pLUdn[spTot,t-1]/fp * qLUdn[spTot,t] =E= sum(sp, pLUdn[sp,t-1]/fp * qLUdn[sp,t]);

    # fL[spTot,t] fanger sammensætningseffekter 
    # OBS: Benyt denne ligning til at analysere qLUdn på aggregeret niveau
    fL[spTot,t]$(t.val > %cal_start%).. 
      qLUdn[spTot,t] =E= fL[spTot,t] * rL2KELBR[spTot,t] * qKELBR[spTot,t] * rPrisEffekt_L[spTot,t];

    # Hvad er effekten fra andelsparametrene givet qKELBR og i fravær af sammensætnings- og priseffekter?
    # Vi udnytter pLUdn[s_,tBase] = 1, fL[spTot,tBase] = 1 og rPrisEffekt_L[spTot,tBase] = 1
    rL2KELBR[spTot,t]$(t.val > %cal_start%)..
      rL2KELBR[spTot,t] * qKELBR[spTot,tBase] =E= sum(sp, rL2KELBR[sp,t] * qKELBR[sp,tBase]);

    # Hvad er priseffekterne i fravær af sammensætningseffekter?
    # Vi udnytter pLUdn[s_,tBase] = 1, fL[spTot,tBase] = 1 og rPrisEffekt_L[spTot,tBase] = 1
    rPrisEffekt_L[spTot,t]$(t.val > %cal_start%)..
      rL2KELBR[spTot,tBase] * qKELBR[spTot,tBase] * rPrisEffekt_L[spTot,t]
      =E= 
      sum(sp, rL2KELBR[sp,tBase] * qKELBR[sp,tBase] * rPrisEffekt_L[sp,t]);

    # Labor input in productivity units net of hiring costs, before factor utilization 
    .. qL[spTot,t] =E= qProd[spTot,t] * (1-rOpslagOmk[spTot,t]) * hL[spTot,t];

    # Effective user cost of labor
    pLUdn[spTot,t]$(t.val > %cal_start%).. pLUdn[spTot,t] * qLUdn[spTot,t] =E= sum(sp, pLUdn[sp,t] * qLUdn[sp,t]);
 
    # Total hours worked - i labor_market.gms
    #    E_hL[sp,t].. qL[sp,t] =E= qProd[sp,t] * (1-rOpslagOmk[sp,t]) # Matching friction * hL[sp,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Demand for energy - E
    # ------------------------------------------------------------------------------------------------------------------
    # fE[spTot,t] fanger sammensætningseffekter 
    # OBS: Benyt denne ligning til at analysere på aggregeret niveau
    fE&_spTot[spTot,t]$(t.val > %cal_start%).. 
      qE[spTot,t] =E= fE[spTot,t] * rE2KELBR[spTot,t] * qKELBR[spTot,t] * rPrisEffekt_E[spTot,t];

    # Hvad er effekten fra andelsparametrene givet qKELBR og i fravær af sammensætnings- og priseffekter?
    # Vi udnytter pE[s_,tBase] = 1, fE[spTot,tBase] = 1 og rPrisEffekt_E[spTot,tBase] = 1
    $(t.val > %cal_start%)..
      rE2KELBR[spTot,t] * qKELBR[spTot,tBase] =E= sum(sp, rE2KELBR[sp,t] * qKELBR[sp,tBase]);

    # Hvad er priseffekterne i fravær af sammensætningseffekter?
    # Vi udnytter pE[s_,tBase] = 1, fE[spTot,tBase] = 1 og rPrisEffekt_E[spTot,tBase] = 1
    rPrisEffekt_E&_spTot[spTot,t]$(t.val > %cal_start%)..
      rE2KELBR[spTot,tBase] * qKELBR[spTot,tBase] * rPrisEffekt_E[spTot,t]
      =E= 
      sum(sp, rE2KELBR[sp,tBase] * qKELBR[sp,tBase] * rPrisEffekt_E[sp,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Demand for equipment capital aggregate in effective uinits - qKUdn_iM
    # ------------------------------------------------------------------------------------------------------------------  
    qKUdn['iM',spTot,t]$(t.val > %cal_start%).. 
      pKUdn['iM',spTot,t-1]/fp * qKUdn['iM',spTot,t] =E= sum(sp, pKUdn['iM',sp,t-1]/fp * qKUdn['iM',sp,t]);

    # fK[spTot,t] fanger sammensætningseffekter 
    # OBS: Benyt denne ligning til at analysere på aggregeret niveau
    fK[spTot,t].. 
      qKUdn['iM',spTot,t] =E= fK[spTot,t] * rK2KELBR[spTot,t] * qKELBR[spTot,t] * rPrisEffekt_K[spTot,t];

    # Hvad er effekten fra andelsparametrene givet qKELBR og i fravær af sammensætnings- og priseffekter?
    # Vi udnytter pKUdn[k,s_,tBase] = 1, fK[spTot,tBase] = 1 og rPrisEffekt_E[spTot,tBase] = 1
    rK2KELBR[spTot,t]$(t.val > %cal_start%)..
      rK2KELBR[spTot,t] * qKELBR[spTot,tBase] =E= sum(sp, rK2KELBR[sp,t] * qKELBR[sp,tBase]);

    # Hvad er priseffekterne i fravær af sammensætningseffekter?
    # Vi udnytter pKUdn[k,s_,tBase] = 1, fK[spTot,tBase] = 1 og rPrisEffekt_K[spTot,tBase] = 1
    rPrisEffekt_K[spTot,t]$(t.val > %cal_start%)..
      rK2KELBR[spTot,tBase] * qKELBR[spTot,tBase] * rPrisEffekt_K[spTot,t]
      =E= 
      sum(sp, rK2KELBR[sp,tBase] * qKELBR[sp,tBase] * rPrisEffekt_K[sp,t]);

    # Aggregate investment price of capital (NB: Dette er investeringsprisen og ikke lig kapitalprisen i NR!)
    .. pKI[k,spTot,t] * qK[k,spTot,t]   =E= sum(sp, pI_s[k,sp,t] * qK[k,sp,t]);
    .. pKI[kTot,spTot,t] * qK[kTot,spTot,t] =E= sum(k, pKI[k,spTot,t] * qK[k,spTot,t]);

    .. pKI[k,sTot,t] * qK[k,sTot,t] =E= sum(s, pI_s[k,s,t] * qK[k,s,t]);
    .. pKI[kTot,sTot,t] * qK[kTot,sTot,t] =E= sum(k, pKI[k,sTot,t] * qK[k,sTot,t]);

    # Aggregate capital
    # E_qK[k,sp,t]$(d1K[k,sp,t]).. qKUdn[k,sp,t] =E= rKUdn[k,sp,t] * qK[k,sp,t-1]/fq * (pK[k,sp,tBase] / rKUdn[k,sp,tBase]);
    qK[k,spTot,t].. pKI[k,spTot,t-1]/fp * qK[k,spTot,t] =E= sum(sp, pI_s[k,sp,t-1]/fp * qK[k,sp,t]);
    qK[kTot,spTot,t].. pKI[kTot,spTot,t-1]/fp * qK[kTot,spTot,t] =E= sum(k, pKI[k,spTot,t-1]/fp * qK[k,spTot,t]);

    qK[k,sTot,t].. pKI[k,sTot,t-1]/fp * qK[k,sTot,t] =E= sum(s, pI_s[k,s,t-1]/fp * qK[k,s,t]);
    qK[kTot,sTot,t]..  pKI[kTot,sTot,t-1]/fp * qK[kTot,sTot,t] =E= sum(k, pKI[k,sTot,t-1]/fp * qK[k,sTot,t]);

    # Effective user cost of capital
    # E_pKUdn[k,sp,t]$(d1K[k,sp,t]).. pKUdn[k,sp,t] =E= pK[k,sp,t] / rKUdn[k,sp,t] / (pK[k,sp,tBase] / rKUdn[k,sp,tBase]);
    pKUdn[k,spTot,t]$(t.val > %cal_start%).. 
      pKUdn[k,spTot,t] * qKUdn[k,spTot,t] =E= sum(sp, pKUdn[k,sp,t] * qKUdn[k,sp,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Kapital-installationsomkostninger
    # ------------------------------------------------------------------------------------------------------------------
    qKInstOmk[k,spTot,t]$(t.val > %cal_start%)..
      pKELBR[spTot,t-1]/fp * qKInstOmk[k,spTot,t] =E= sum(sp, pKELBR[sp,t-1]/fp * qKInstOmk[k,sp,t]);

    $(t.val > %cal_start%).. 
      qKInstOmk[kTot,spTot,t] =E= sum(k, qKInstOmk[k,spTot,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Kapacitets-udnyttelse på kapital
    # ------------------------------------------------------------------------------------------------------------------
    .. rKUdn[k,spTot,t] * sum(sp, qKUdn[k,sp,t]/rKUdn[k,sp,t]) =E= sum(sp, qKUdn[k,sp,t]);
    .. rKUdn[kTot,spTot,t] * sum([k,sp], qKUdn[k,sp,t]/rKUdn[k,sp,t]) =E= sum([k,sp], qKUdn[k,sp,t]);      

    # ------------------------------------------------------------------------------------------------------------------
    # Kapacitets-udnyttelse på arbejdskraft
    # ------------------------------------------------------------------------------------------------------------------
    # Beregnes lidt ad hoc for at få, at rLUdn[spTot,t] bliver 1, når alle rLUdn[sp,t] er 1
    .. rLUdn[spTot,t] * sum(sp, qLUdn[sp,t] / rLUdn[sp,t]) =E= sum(sp, qLUdn[sp,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Cost of capital
    # ------------------------------------------------------------------------------------------------------------------
    .. pK[k,spTot,t] * qK[k,spTot,t-1]/fq =E= sum(sp, pK[k,sp,t] * qK[k,sp,t-1]/fq);

    # Definition of user cost
    # User cost på spTot er defineret uden boliger, da usercost på boliger er defineret ved pBoligUC
    fpK_spTot[k,t]$(tx0E[t] and t.val > %NettoFin_t1%)..
      pK[k,spTot,t+1]*fp * qK[k,spTot,t] =E= fpK_spTot[k,t] *(
      # Tobin's q today and tomorrow
      sum(sp$(not bol[sp]), (1+rVirkDisk[sp,t+1]) / (1-mtVirk[t+1]) * (1-dnvAfskrFradrag2dvI_s[k,sp,t]) * pI_s[k,sp,t] * qK[k,sp,t])
      - sum(sp$(not bol[sp]), (1-rAfskr[k,sp,t+1]) / (1-mtVirk[t+1]) * (1-dnvAfskrFradrag2dvI_s[k,sp,t+1]) * pI_s[k,sp,t+1]*fp * qK[k,sp,t])
      # Production tax on capital
      + sum(sp$(not bol[sp]), tK[k,sp,t+1] * pI_s[k,sp,t+1]*fp * qK[k,sp,t])
      # Tax shield and collateral value on capital
      - sum(sp$(not bol[sp]), (rVirkDisk[sp,t+1] / (1-mtVirk[t+1]) - (mrVirkDriftPasRente[k,sp,t+1] + mrVirkDriftPasOmv[k,sp,t+1])) 
                              * mrLaan2K[k,sp,t] * pI_s[k,sp,t] * qK[k,sp,t])
      # Change in installation costs today
      + sum(sp$(not bol[sp]), (1+rVirkDisk[sp,t+1]) / (1-mtVirk[t+1]) * pKELBR[sp,t] * (1-mtVirk[t]) * dKInstOmk2dK[k,sp,t] * qK[k,sp,t])
      # Discounted value of change in future installation costs from change in investments today
      + sum(sp$(not bol[sp]), pKELBR[sp,t+1]*fp * dKInstOmk2dKLag[k,sp,t+1] * qK[k,sp,t])
      + sum(sp$(not bol[sp]), (jpK_s[k,sp,t+1] + jpK_t[k,t+1]) * qK[k,sp,t])
      )
      + pK[k,'bol',t+1]*fp * qK[k,'bol',t]
      ;

    #  # Constructing elements of aggregate usercost
    #  E_rVirkDisk_spTot[t]..
    #    rVirkDisk[spTot,t] * sum([k,sp], pI_s[k,sp,t] * qK[k,sp,t-1]) =E= sum([k,sp], rVirkDisk[sp,t] * pI_s[k,sp,t] * qK[k,sp,t-1]);
    #  E_fVirkDisk_spTot[t]..
    #    fVirkDisk[spTot,t] =E= 1 / (1 + rVirkDisk[spTot,t]);

    # Kapital-akkumulation
    rAfskr[k,spTot,t].. qI_s[k,spTot,t] =E= qK[k,spTot,t] - (1 - rAfskr[k,spTot,t]) * qK[k,spTot,t-1]/fq;
    # ------------------------------------------------------------------------------------------------------------------
    # sTot aggregates
    # ------------------------------------------------------------------------------------------------------------------
    .. qL[sTot,t] =E= sum(s, qL[s,t]);

    .. rKUdn[k,sTot,t] * sum(s, qKUdn[k,s,t] / rKUdn[k,s,t]) =E= sum(s, qKUdn[k,s,t]);

    .. rLUdn[sTot,t] * sum(s, qLUdn[s,t] / rLUdn[s,t]) =E= sum(s, qLUdn[s,t]);
  $ENDBLOCK

  $GROUP G_production_private_endo 
     G_production_private_static
     G_production_private_forwardlooking
     pK[iB,bol,tx0] # Boligkapital er givet i _static (bestemt i consumers.gms), CES-efterspørgsel giver skyggepris pK
  ;
  $GROUP+ G_Endo G_production_private_endo;

  MODEL M_production_private /
    B_production_private_static 
    B_production_private_forwardlooking 
  /;
  model M_base / M_production_private /;

  model M_static / B_production_private_static /;
  $GROUP+ G_static G_production_private_static;
$ENDIF


$IF %stage% == "exogenous_values":
# ======================================================================================================================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_production_private_makrobk
    qK$(sp[s_]), nL[s_,t]$(sp[s_] or sTot[s_]), qI_s$(k[i_] and sp[s_])
  ;
  @load(G_production_private_makrobk, "../Data/Makrobk/makrobk.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_production_private_data  
    G_production_private_makrobk
  ;
  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_production_private_data_imprecise 
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  # Kapacitetsudnyttelses-omkostninger
  #  eKUdn.l['iB',sp]$(not bol[sp]) = 1.485615; # Matching parameter
  #  eKUdn.l['iM',sp] = 1.922826; # Matching parameter
  eKUdnPersistens.l[k] = 0; # Bruges ikke (men må ikke være NA)
  eLUdn.l = 1.989658; # Matching parameter
  eLUdnPersistens.l = 0.492526 ; # Matching parameter

  # Installationsomkostninger
  uKInstOmk.l['iB',sp,t] = 15.0; # Matching parameter
  uKInstOmk.l['iM',sp,t] = 2.55389; # Matching parameter

  # Produktionselasticiteter
  eKELBR.l['byg'] = 0.88;
  eKELBR.l['ene'] = 0.9; # Afrundet fra 0.94, da elasticitet tæt på, men ikke eksakt 1, er svært at løse.
  eKELBR.l['fre'] = 1; # Afrundet fra 0.95, da elasticitet tæt på, men ikke eksakt 1, er svært at løse.
  eKELBR.l['lan'] = 0.90;
  eKELBR.l['soe'] = 1; # Denne er ekstremt usikkert estimeret, og ikke signifikant forskellig fra 1. Vi antager elasticitet på 1.
  eKELBR.l['tje'] = 0.9; # Afrundet fra 0.94, da elasticitet tæt på, men ikke eksakt 1, er svært at løse.
  eKELBR.l['udv'] = 0.86;

  eKELB.l['byg'] = 0.9; # Afrundet fra 0.92, da elasticitet tæt på, men ikke eksakt 1, er svært at løse.
  eKELB.l['ene'] = 0.57;
  eKELB.l['fre'] = 0.86;
  eKELB.l['lan'] = 0.9; # Afrundet fra 0.93, da elasticitet tæt på, men ikke eksakt 1, er svært at løse.
  eKELB.l['soe'] = 1; # Afrundet fra 0.97, da elasticitet tæt på, men ikke eksakt 1, er svært at løse.
  eKELB.l['tje'] = 0.55;
  eKELB.l['udv'] = 1; # Afrundet fra 0.97, da elasticitet tæt på, men ikke eksakt 1, er svært at løse.

  eKEL.l['byg'] = 0.82;
  eKEL.l['ene'] = 0.90;
  eKEL.l['fre'] = 0.9; # Afrundet fra 0.94, da elasticitet tæt på, men ikke eksakt 1, er svært at løse.
  eKEL.l['lan'] = 0.87;
  eKEL.l['soe'] = 1; # Afrundet fra 0.97, da elasticitet tæt på, men ikke eksakt 1, er svært at løse.
  eKEL.l['tje'] = 0.81;
  eKEL.l['udv'] = 0.84;

  eKE.l['byg'] = 0.73;
  eKE.l['ene'] = 0.88;
  eKE.l['fre'] = 0.9; # Afrundet fra 0.94, da elasticitet tæt på, men ikke eksakt 1, er svært at løse.
  eKE.l['lan'] = 1; # Afrundet fra 0.95, da elasticitet tæt på, men ikke eksakt 1, er svært at løse.
  eKE.l['soe'] = 1; # Denne er ekstremt usikkert estimeret, og ikke signifikant forskellig fra 1. Vi antager elasticitet på 1.
  eKE.l['tje'] = 0.9; # Afrundet fra 0.94, da elasticitet tæt på, men ikke eksakt 1, er svært at løse.
  eKE.l['udv'] = 1.72;

  # Housing production is almost Leontief and does not have installations costs.
  eKELBR.l['bol'] = 0;
  eKELB.l['bol'] = 0;
  eKEL.l['bol'] = 0;
  eKE.l['bol'] = 0;
  uKInstOmk.l[k,'bol',t] = 0;

  # Kapital-besparende produktivitetsindeks sættes til 1 i brancher, hvor teknologiske fremskridt antages udelukkende at være arbejdskraft-besparende
  uK.l[k,sp,t] = 1;
  # Produktivitetsindeks normeres til 1 i basisåret
  uL.l[sp,tBase] = 1;

# ======================================================================================================================
# Data assignment
# ======================================================================================================================
  # Vi normaliserer priser til 1 i basisåret
  pKELBR.l[spTot,tBase] = 1;
  pKELBR.l[sp,tBase] = 1;
  pKELB.l[sp,tBase] = 1;
  pKEL.l[sp,tBase] = 1;
  pKE.l[sp,tBase] = 1;
  pKI.l[k,spTot,tBase] = 1;
  pKI.l[kTot,spTot,tBase] = 1;
  pKI.l[k,sTot,tBase] = 1;
  pKI.l[kTot,sTot,tBase] = 1;
  fuY_spTot.l[tBase] = 1;
  pKUdn.l[k,spTot,tBase] = 1;
  pLUdn.l[spTot,tBase] = 1;

  # Kapacitetsudnyttelse
  rKUdn.l[k,s_,t] = 1;
  rLUdn.l[s_,t] = 1;

  set_data_periods(1971, %cal_end%);

  rAfskr_static.l[k,sp,t]$(tDataX1[t] and d1I_s[k,sp,t]) = max(0, (qI_s.l[k,sp,t] - (qK.l[k,sp,t] - qK.l[k,sp,t-1])) / qK.l[k,sp,t-1]);
  @HPfilter(rAfskr_static, 100, %cal_start%, %cal_end%);

  gpI_s_static.l[k,sp,t]$(tDataX1[t] and d1I_s[k,sp,t]) = pI.l[k,t] / pI.l[k,t-1] - 1;
  gpI_s_static.l[k,sp,t] = @mean(tt$[t.val-5 < tt.val and tt.val <= t.val], gpI_s_static.l[k,sp,tt]);  # MA5

  set_data_periods(%cal_start%, %cal_end%);
$ENDIF


# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_production_private_static_calibration_base
    G_production_private_endo
    uL[sp,t], -qE[sp,t]
    uK[k,sp,t]$(d1K[k,sp,t] and not harrod_neutral[sp]) # E_uK
    rR2KELBR[sp,t], -qR[sp,t]
    rB2KELB[sp,t]$(not bol[sp]), -qK[iB,sp,tx0E]$(not bol[sp]) # E_rB2KELB_t1
    rB2KELB[bol,t], -qY[bol,t] # Boligkapital efterspørges direkte af husholdninger - produktionsfunktion giver output for syntetisk boligbranche
    rL2KEL[sp,t], -hL[sp,t]
    rE2KE[sp,t]$(not bol[sp]), -qK[iM,sp,tx0E]$(not bol[sp]) # E_rE2KE_t1
    rE2KE[bol,t] # E_rE2KE_xK
    rAfskr[k,sp,t], -qI_s[k,sp,t]
    -qK[k,sp,tEnd]$(not bol[sp]) # -E_qK_tEnd
    jfrLUdn_t[t], -rLUdn[spTot,t]
    -qI_s['iL',sp,t], rIL2Y[sp,t]
  ;

  $GROUP G_production_private_static_calibration
    G_production_private_static_calibration_base$(tx0[t])
    pK[k,sp,t0] # E_pK_t0
    pLUdn[sp,t0] # E_pLUdn_t0
    qK[k,spTot,t0] # E_pKI_spTot    
    qK[kTot,spTot,t0] # E_pKI_kTot_spTot
    pKI[k,spTot,t0], -pKI[k,spTot,tBase], pKI[kTot,spTot,t0], -pKI[kTot,spTot,tBase]

    qK[k,sTot,t0] # E_pKI_sTot    
    qK[kTot,sTot,t0] # E_pKI_kTot_sTot
    pKI[k,sTot,t0], -pKI[k,sTot,tBase], pKI[kTot,sTot,t0], -pKI[kTot,sTot,tBase]
    pKELBR[sptot,'%cal_start%'], -pKELBR[spTot,tBase]
    pKUdn[k,spTot,'%cal_start%'], -pKUdn[k,spTot,tBase]
    pLUdn[spTot,'%cal_start%'], -pLUdn[spTot,tBase]
    fuY, -uL[sp,tBase]
  ;

  $BLOCK B_production_private_static_calibration_base$(tx0[t])
    E_uK[k,sp,t]$(d1K[k,sp,t] and not harrod_neutral[sp])..
      uK[k,sp,t] =E= uL[sp,t];

    E_rB2KELB_t1[sp,t]$(t1[t] and not bol[sp])..
      rB2KELB[sp,t] =E= rB2KELB[sp,t+1];

    E_rE2KE_t1[sp,t]$(t1[t] and not bol[sp])..
      rE2KE[sp,t] =E= rE2KE[sp,t+1];

    E_rE2KE_xK[sp,t]$(not d1K['iM',sp,t]).. rE2KE[sp,t] =E= 1;

    E_pK_static[k,sp,t]$(tx0E[t] and not bol[sp] and d1K[k,sp,t])..
      pK[k,sp,t+1]*fp =E=
      # Tobin's q today and tomorrow
        (1+rVirkDisk[sp,t]) / (1-mtVirk[t]) * (1-dnvAfskrFradrag2dvI_s[k,sp,t]) * pI_s[k,sp,t]
      - (1-rAfskr_static[k,sp,t]) / (1-mtVirk[t]) * (1-dnvAfskrFradrag2dvI_s[k,sp,t]) * pI_s[k,sp,t] * (1+gpI_s_static[k,sp,t])
      # Production tax on capital
      + tK[k,sp,t] * pI_s[k,sp,t]*(1+gpI_s_static[k,sp,t])
      # Tax shield and collateral value on capital
      - (rVirkDisk[sp,t] / (1-mtVirk[t]) - (mrVirkDriftPasRente[k,sp,t] + mrVirkDriftPasOmv[k,sp,t])) * mrLaan2K[k,sp,t] * pI_s[k,sp,t];

    E_rLUdn_static[sp,t]..
      rLUdn[sp,t] =E= rLUdn[sp,t-1]**eLUdnPersistens * (1 + jfrLUdn[sp,t] + jfrLUdn_t[t]);

    E_rKUdn_static[k,sp,t]$(d1K[k,sp,t-1] and eKUdn.l[k,sp] <> 0)..
      rKUdn[k,sp,t] =E= rKUdn[k,sp,t-1]**eKUdnPersistens[k] * (1 + jfrKUdn[k,sp,t] + jfrKUdn_k[k,t]);
  $ENDBLOCK

  $BLOCK B_production_private_static_calibration
    E_pK_t0[k,s_,t]$(t0[t] and d1K[k,s_,t] and sp[s_]).. pK[k,s_,t] =E= pK[k,s_,t+1];

    E_pLUdn_t0[s_,t]$(t0[t] and sp[s_]).. pLUdn[s_,t]/vhW[t] =E= pLUdn[s_,t+1]/vhW[t+1];    

    E_pKI_sptot_t0[k,t]$(t0[t]).. pKI[k,spTot,t] * qK[k,spTot,t]   =E= sum(sp, pI_s[k,sp,t] * qK[k,sp,t]);
    E_pKI_kTot_spTot_t0[t]$(t0[t]).. pKI[kTot,spTot,t] * qK[kTot,spTot,t] =E= sum(k, pKI[k,spTot,t] * qK[k,spTot,t]);

    E_pKI_sTot_t0[k,t]$(t0[t]).. pKI[k,sTot,t] * qK[k,sTot,t] =E= sum(s, pI_s[k,s,t] * qK[k,s,t]);
    E_pKI_kTot_sTot_t0[t]$(t0[t]).. pKI[kTot,sTot,t] * qK[kTot,sTot,t] =E= sum(k, pKI[k,sTot,t] * qK[k,sTot,t]);
  $ENDBLOCK

  MODEL M_production_private_static_calibration /
    M_production_private
    B_production_private_static_calibration_base
    -E_pK_k_sp - E_pK_tEnd  # E_pK_static
    -E_rLUdn_sp -E_rLUdn_tEnd # E_rLUdn_static
    -E_rKUdn_k_sp -E_rKUdn_tEnd # E_rKUdn_static

    B_production_private_static_calibration
  /;
  model M_static_calibration / M_production_private_static_calibration /;
  $GROUP+ G_static_calibration G_production_private_static_calibration;

  $GROUP G_production_private_static_calibration_newdata
    G_production_private_static_calibration_base$(tx0[t])
  ;
  $GROUP+ G_static_calibration_newdata G_production_private_static_calibration_newdata;
$ENDIF


# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_production_private_deep
    G_production_private_endo

    # Usercost of labor and utilization rates are affected by forward-looking expectations.
    # productivity parameters and share parameters are therefore re-calibrated to keep factor inputs equal to the data,
    # and ARIMA forecasts are adjusted proportionally to the re-calibration.
    uL[sp,t1], -qE[sp,t1]
    uL[sp,tx1] # E_uL_forecast
    
    -uL[sp,t1]$(%DREAM_baseline%), jfrLUdn[sp,t1]$(%DREAM_baseline%)

    uK[k,sp,t]$(d1K[k,sp,t] and not harrod_neutral[sp]) # E_uK

    rR2KELBR[sp,t1], -qR[sp,t1]
    rR2KELBR[sp,tx1] # E_rR2KELBR_forecast

    # Note that end-of-period capital in the last data year enters production the following period.
    # We assume no jumps in the share-parameters used in within period production and choice of end-of-period capital.
    jpK_s[iB,sp,t2]$(not bol[sp]), -qK[iB,sp,t1]$(not bol[sp])
    rB2KELB[sp,t1]$(not bol[sp]), -pK[iB,sp,t1]$(not bol[sp])
    rB2KELB[sp,tx1]$(not bol[sp]) # E_rB2KELB_forecast

    # Boligkapital efterspørges direkte af husholdninger - produktionsfunktion giver output for syntetisk boligbranche.
    rB2KELB[bol,t1], -qY[bol,t1] 
    rB2KELB[bol,tx1] # E_rB2KELB_bol_forecast

    rL2KEL[sp,t1], -hL[sp,t1]
    rL2KEL[sp,tx1] # E_rL2KEL_forecast
    
    # Note that end-of-period capital in the last data year enters production the following period.
    # We assume no jumps in the share-parameters used in within period production and choice of end-of-period capital.
    jpK_s[iM,sp,t2]$(not bol[sp]), -qK[iM,sp,t1]$(not bol[sp])
    rE2KE[sp,t1]$(not bol[sp]), -pK[iM,sp,t1]$(not bol[s_])
    rE2KE[sp,tx1]$(not bol[sp]) # E_rE2KE_forecast
  ;
  $GROUP G_production_private_deep G_production_private_deep$(tx0[t]);
	$BLOCK B_production_private_deep
    E_uL_forecast[sp,t]$(tx1[t] and not soe[sp])..
      uL[sp,t] =E= uL_ARIMA[sp,t] * uL[sp,t1] / uL_ARIMA[sp,t1];

    E_uL_soe_forecast[sp,t]$(tx1[t] and soe[sp]).. uL[sp,t] =E= uL[sp,t0];

    E_rR2KELBR_forecast[sp,t]$(tx1[t])..
      rR2KELBR[sp,t] =E= rR2KELBR_ARIMA[sp,t] * rR2KELBR[sp,t1] / rR2KELBR_ARIMA[sp,t1];    

    E_rB2KELB_forecast[sp,t]$(tx1[t] and not bol[sp])..
      rB2KELB[sp,t] =E= rB2KELB_ARIMA[sp,t] * rB2KELB[sp,t1] / rB2KELB_ARIMA[sp,t1];

    E_rB2KELB_bol_forecast[sp,t]$(tx1[t] and bol[sp])..
      rB2KELB[sp,t] =E= rB2KELB_ARIMA[sp,t] * rB2KELB[sp,t1] / rB2KELB_ARIMA[sp,t1];

    E_rE2KE_forecast[sp,t]$(tx1[t] and not bol[sp])..
      rE2KE[sp,t] =E= rE2KE_ARIMA[sp,t] * rE2KE[sp,t1] / rE2KE_ARIMA[sp,t1];

    E_rL2KEL_forecast[sp,t]$(tx1[t])..
      rL2KEL[sp,t] =E= rL2KEL_ARIMA[sp,t] * rL2KEL[sp,t1] / rL2KEL_ARIMA[sp,t1];
  $ENDBLOCK
  MODEL M_production_private_deep /
    M_production_private
    B_production_private_deep
    E_uK
  /;
  model M_deep_dynamic_calibration / M_production_private_deep /;
  $GROUP+ G_deep_dynamic_calibration G_production_private_deep;
$ENDIF


# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
  $GROUP G_production_private_dynamic_calibration
    G_production_private_endo

    uL[sp,t1], -qE[sp,t1]
    uL[sp,tx1] # E_uL_forecast

    -uL[sp,t1]$(%DREAM_baseline%), jfrLUdn[sp,t1]$(%DREAM_baseline%)

    rR2KELBR[sp,t1], -qR[sp,t1]
    rR2KELBR[sp,tx1] # E_rR2KELBR_forecast

    rB2KELB[sp,t1]$(not bol[sp]), -qK[iB,sp,t1]$(not bol[sp])
    rB2KELB[sp,tx1]$(not bol[sp]) # E_rB2KELB_forecast$(not bol)

    rB2KELB[bol,t1], -qY[bol,t1] 
    rB2KELB[bol,tx1] # E_rB2KELB_forecast[bol]

    rL2KEL[sp,t1], -hL[sp,t1]
    rL2KEL[sp,tx1] # E_rL2KEL_forecast
    
    rE2KE[sp,t1]$(not bol[sp]), -qK[iM,sp,t1]$(not bol[s_])
    rE2KE[sp,tx1]$(not bol[sp]) # E_rE2KE_forecast

    jpK_s[k,sp,t2]$(not bol[sp]), -pK[k,sp,t2]$(not bol[sp])

    # Afskrivningsraterne i foreløb data virker utroværdige.
    # Vi sætter uK således at ændringen i effektivt kapitalapparat baseres på afskrivningsrater fra endelig data.
    uK[k,sp,tx0]$(d1K[k,sp,t] and harrod_neutral[sp]) # E_uK_harrod_neutral
    uK[k,sp,tx0]$(d1K[k,sp,t] and not harrod_neutral[sp]) # E_uK_not_harrod_neutral
  ;
  $BLOCK B_production_private_dynamic_calibration$(tx0[t] )
    # Produktivetsændring antages at være permanent (arbejdskraft-besparende teknologisk fremskridt)
    # E_uL_permanent[sp,t]$(tx1[t]).. uL[sp,t] =E= uL_baseline[sp,t] * uL[sp,t1] / uL_baseline[sp,t1];
    E_uL_forecast[s_,t]$(sp[s_] and tx1[t]).. @gradual_return_to_baseline(uL);
    E_rR2KELBR_forecast[s_,t]$(sp[s_] and tx1[t]).. @gradual_return_to_baseline(rR2KELBR);
    E_rB2KELB_forecast[sp,t]$(tx1[t]).. @gradual_return_to_baseline(rB2KELB);
    E_rL2KEL_forecast[sp,t]$(tx1[t]).. @gradual_return_to_baseline(rL2KEL);
    E_rE2KE_forecast[sp,t]$(tx1[t] and not bol[sp]).. @gradual_return_to_baseline(rE2KE);

    E_uK_harrod_neutral[k,sp,t]$(d1K[k,sp,t] and harrod_neutral[sp])..
      uK[k,sp,t] * qK[k,sp,t-1]/fq =E= uK[k,sp,t-1] * ((1-rAfskr_baseline[k,sp,t]) * qK[k,sp,t-2]/fq/fq + qI_s[k,sp,t-1]/fq);

    E_uK_not_harrod_neutral[k,sp,t]$(d1K[k,sp,t] and not harrod_neutral[sp])..
      uK[k,sp,t] * qK[k,sp,t-1]/fq =E= uK[k,sp,t-1] * ((1-rAfskr_baseline[k,sp,t]) * qK[k,sp,t-2]/fq/fq + qI_s[k,sp,t-1]/fq)
                                     * uL[sp,t] / uL[sp,t-1]; # uK antages at følge uL, på nær korrektion for afskrivningsrate
  $ENDBLOCK

  MODEL M_production_private_dynamic_calibration /
    M_production_private
    B_production_private_dynamic_calibration
  /;
  model M_dynamic_calibration_newdata / M_production_private_dynamic_calibration /;
  $GROUP+ G_dynamic_calibration_newdata G_production_private_dynamic_calibration;
$ENDIF
