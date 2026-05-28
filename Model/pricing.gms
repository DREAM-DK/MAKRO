# ======================================================================================================================
# Pricing
# - Price rigidities, markups, and foreign prices
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":

  $GROUP G_pricing_variables
    pY[s_,t] "Deflator for indenlandsk produktion, Kilde: ADAM[pX] eller ADAM[pX<i>]"
    # pY[off] beregnes i production_public
    pXUdl[x_,t] "Eksportkonkurrerende udenlandsk pris, Kilde: ADAM[pee<i>]"
    pOlie[t] "Oliepris i DKK, Kilde: ADAM[pee3r]."
    rMarkup[s_,t] "Gennemsnitlig markup."
    mrMarkup[s_,t] "Marginal markup."
    dpYTraeghed[sp,t] "Hjælpevariabel til beregning af effekt fra omstillingsomkostninger på markup."
    rpYTraeghed[sp,t] "Hjælpevariabel til beregning af effekt fra omstillingsomkostninger på markup."
    rYfixed[sp,t] "Andelsparameter for fast del af pY."
  ;

  $GROUP G_pricing_exogenous_forecast
    rEffValKurs[t] "Effektiv valutakurs"
    pYfixed[sp,t] "Faste omkostninger, som ikke indgår i prisdannelse."
    rYfixed[sp,t] "Andelsparameter for fast del af pY."
    pOlieBrent[t] "Prisnotering på råolie, Brent (dollar/tønde), Kilde: ADAM[boil]"
  ;
  $GROUP+ G_exogenous_forecast G_pricing_exogenous_forecast$(tx1[t]);

  $GROUP G_pricing_forecast_as_zero
    jpY_bol[t] "j-led."
    jmrMarkup[s_,t] "J-led."
    jrpYTraeghed[sp,t] "J-led."
  ;
  $GROUP+ G_forecast_as_zero G_pricing_forecast_as_zero$(tx1[t]);

  $GROUP G_pricing_ARIMA_forecast
    smrMarkup[s_,t] "Strukturel, marginal markup."
    pY[bol,t] 
    upYUdv[t] "Skalaparameter for eksogen pris på udvinding."
    pXUdl[xVar,t]
    pM[s_,t]$(tje[s_] or fre[s_]) "Importdeflator fordelt på importgrupper, Kilde: ADAM[pM] eller ADAM[pM<i>]"
    rYfixed[sp,t]
  ;
  $GROUP+ G_ARIMA_forecast G_pricing_ARIMA_forecast;
  
  $GROUP G_pricing_constants
    upYTraeghed[sp] "Parameter for Rotemberg omkostning."
  ;
  $GROUP+ G_constants G_pricing_constants;

  $GROUP G_pricing_fixed_forecast
    eY[sp,t] "Substitutionselasticitet mellem intermediate goods og final goods i produktionen."
    rDollarKurs[t] "Dollarkursen, DKK/Dollar, Kilde: ADAM[ewus]"
    rEuroKurs[t] "Eurokursen, DKK/Euro, Kilde: ADAM[eweu]."
    pM[s_,t]$(soe[s_] or udv[s_] or ene[s_]) "Importdeflator fordelt på importgrupper, Kilde: ADAM[pM] eller ADAM[pM<i>]"
  ;
  $GROUP+ G_fixed_forecast G_pricing_fixed_forecast;

  set sMarkup[s_] "Brancher som fremskrives med en eksogen strukturel markup forskellig fra 0" /fre, byg/;
  set sZeroMarkup[s_] "Brancher som fremskrives med 0 strukturel markup" /tje, lan, ene, soe/;

$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
# ----------------------------------------------------------------------------------------------------------------------
# Final goods pricing
# ----------------------------------------------------------------------------------------------------------------------
  $BLOCK B_pricing_static G_pricing_static $(tx0[t])
    pY[sp,t].. pY[sp,t] =E= (1+mrMarkup[sp,t]) * (pY0[sp,t] - pYfixed[sp,t]);

    # Fixed ratio of pY0 with no markup
    rYfixed[sp,t].. pYfixed[sp,t] =E= rYfixed[sp,t] * pY0[sp,t];

    # Extraction sector prices (mostly oil and gas) follows import prices except for the small share that is gravel extraction
    # Marginal costs in gravel extraction are assumed to follow those of manufacturing
    mrMarkup['udv',t].. pY['udv',t] =E= upYUdv[t] * (
                        (1 - qGrus[t] / qY['udv',t]) * pM['udv',t]
                        + qGrus[t] / qY['udv',t] * pY0['fre',t] / pY0['fre',tEnd] * pY0['udv',tEnd]
                      );

    # Shipping industry chooses their markup to keep the relative export price constant
    mrMarkup['soe',t].. pXy['xSoe',t] =E= rpXy2pXUdl['xSoe',t] * pXUdl['xSoe',t];

    # Synthetic housing sector rental price follows moving average of consumer price index
    mrMarkup['bol',t].. pY['bol',t] =E= (pY['bol',t-1]/fp * (1 + rpCInflSnit[t]) + jpY_bol[t]) * (1 + jmrMarkup['bol',t]);

    $(t.val >= %EksportData_t1%).. pXUdl[xTot,t] * qX[xTot,t] =E= sum(x, pXUdl[x,t] * qX[x,t]);

    .. pOlie[t] =E= pOlieBrent[t] * rDollarKurs[t] / (pOlieBrent[tBase] * rDollarKurs[tBase]);

    # Aggregate markup
    .. 1+mrMarkup[spTot,t] =E= vY[spTot,t] / sum(sp, pY0[sp,t] * qY[sp,t]);

    .. rpYTraeghed[sp,t] =E= pY[sp,t]/pY[sp,t-1] / (pY[sp,t-1]/pY[sp,t-2]) + jrpYTraeghed[sp,t];

    .. dpYTraeghed[sp,t] =E= upYTraeghed[sp] * (rpYTraeghed[sp,t] - 1) * rpYTraeghed[sp,t];
 
    # Average markup 
    $(not bol[sp]).. rMarkup[sp,t] =E= vY[sp,t] / (
        vLoensum[sp,t] + vSelvstLoen[sp,t]
        + sum(k, pK_gns[k,sp,t] * qK[k,sp,t-1]/fq)
        + vR[sp,t] + vE[sp,t]
        + (vtNetYRest[sp,t] + (tE[sp,t] * vY[sp,t])$(lan[sp]))
      ) - 1;

  $ENDBLOCK

  $BLOCK B_pricing_forwardlooking G_pricing_forwardlooking $(tx0[t])
    # Each sector set prices as a structural markup over marginal costs in the long run
    # while smoothing the rate of change due to adjustment costs
    mrMarkup[sp,t]$(tx0E[t] and not udv[sp] and not bol[sp])..
      mrMarkup[sp,t] =E= smrMarkup[sp,t] - dpYTraeghed[sp,t]              
                      + fVirkDisk[sp,t+1] * 2 * dpYTraeghed[sp,t+1] * qY[sp,t+1]*fq/qY[sp,t] * pY0[sp,t+1]*fp/pY0[sp,t]
                      + jmrMarkup[sp,t];

    mrMarkup&_tEnd[sp,t]$(tEnd[t] and not udv[sp] and not bol[sp])..  mrMarkup[sp,t] =E= smrMarkup[sp,t] + jmrMarkup[sp,t];
  $ENDBLOCK
  $GROUP+ G_pricing_forwardlooking
    smrMarkup['soe',t], -mrMarkup['soe',t]
  ;

   $GROUP G_pricing_endo 
     G_pricing_static
     G_pricing_forwardlooking
   ;

  MODEL M_pricing /
    B_pricing_static
    B_pricing_forwardlooking
  /;
  model M_base / M_pricing /;

  $GROUP+ G_Endo G_pricing_endo;

  model M_static / B_pricing_static /;
  $GROUP+ G_static G_pricing_static;
$ENDIF

$IF %stage% == "exogenous_values":
# =============================================================================================½=========================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_pricing_makrobk
    pY$(s[s_]), pM, pOlieBrent, rDollarKurs, rEuroKurs, rEffValKurs
    pXy, pXUdl$(x[x_])
  ;
  @load(G_pricing_makrobk, "../Data/Makrobk/makrobk.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_pricing_data  
    G_pricing_makrobk
  ;

  # Eksportkonkurrerende priser
  # Initial værdi af relative udenlandske priser inkl. træghed
  rpXy2pXUdl.l[x,t]$(t.val = %EksportData_t1% and pXUdl.l[x,t] <> 0) = pXy.l[x,t] / pXUdl.l[x,t];

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  # Sættes for at matche SVARer mv.
  upYTraeghed.l[sp] = 4.301253;
  upYTraeghed.l['udv'] = 0;
  upYTraeghed.l['bol'] = 0;
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_pricing_static_calibration
    G_pricing_static

    -pY[sZeroMarkup,t], pYfixed[sZeroMarkup,t]$(not soe[sZeroMarkup]), rpXy2pXUdl[xSoe,t]
    -pY[sMarkup,t], mrMarkup[sMarkup,t]
    -pY[udv,t], upYUdv
    -pY[bol,t], jpY_bol

    smrMarkup[sMarkup,t]
    jrpYTraeghed[sp,t] # E_jrpYTraeghed_static
  ;
  $GROUP G_pricing_static_calibration
    G_pricing_static_calibration$(tx0[t])
  ;

  $BLOCK B_pricing_static_calibration$(tx0[t])
    # E_rMarkup using static expectations in the forward looking rigidity 
    E_smrMarkup[sp,t]$(sMarkup[sp]).. mrMarkup[sp,t] =E= smrMarkup[sp,t];

    # No price rigidity in data years for easier calibration
    E_jrpYTraeghed_static[sp,t]..
      rpYTraeghed[sp,t] =E= 1;

  $ENDBLOCK
  MODEL M_pricing_static_calibration /
    B_pricing_static
    B_pricing_static_calibration
  /;
  model M_static_calibration / M_pricing_static_calibration /;
  $GROUP+ G_static_calibration G_pricing_static_calibration;

  $GROUP G_pricing_static_calibration_newdata
    G_pricing_static_calibration
   ;
  $GROUP+ G_static_calibration_newdata G_pricing_static_calibration_newdata;
$ENDIF

# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_pricing_deep
    G_pricing_endo
    -pY[sMarkup,t1], smrMarkup[sMarkup,t1]
    -pY[sZeroMarkup,t1]$(not soe[sZeroMarkup]), pYfixed[sZeroMarkup,t1]$(not soe[sZeroMarkup])
    -rYfixed[sZeroMarkup,tx1], pYfixed[sZeroMarkup,tx1]
    -pY[udv,t1], upYUdv[t1]
    -pY[bol,t1], jpY_bol[t1]

    pOlieBrent[tx1]

    pXUdl[xTje,tx1] # E_pXUdl_xTje, E_pXUdl_xTur, E_pXUdl_xEne, E_pXUdl_xSoe_via_smrMarkup
    pXUdl[xTur,tx1] # E_pXUdl_xTur
    pXUdl[xEne,tx1] # E_pXUdl_xEne
    pXUdl[xSoe,tx1] # E_pXUdl_xSoe_via_smrMarkup

    pM['soe',tx1]
  ;
  $GROUP G_pricing_deep G_pricing_deep$(tx0[t]);

  $BLOCK B_pricing_deep
    # Forventet pris-stigning på begrænsede resourcer bør svarer til renten (arbitrage-betingelse)
    # Obligations-rente bruges foreløbigt (sammen med fast dollar-kurs).
    E_pOlieBrent_forecast[t]$(tx0E[t])..
      pOlieBrent[t] =E= pOlieBrent[t+1]*fp / (1 + rRente['obl',t+1]);

    # Vækstrate for udenlandske eksportkonkurrerende tjeneste-priser sættes lig raten for inflationskorrektion (gp=fp-1)
    E_pXUdl_xTje[t]$(tx1[t]).. pXUdl["xTje",t] =E= pXUdl["xTje",t1];

    # Relative forskydninger i pXUdl antages af følge forskydningerne i pXy
    E_pXUdl_xTur[t]$(tx1[t])..
      pXUdl["xTur",t] / pXUdl["xTje",t] =E= pXy["xTur",t] / pXy["xTje",t];

    E_pXUdl_xEne[t]$(tx1[t])..
      pXUdl["xEne",t] / pXUdl["xTje",t] =E= pXy["xEne",t] / pXy["xTje",t];

    # Ved stød er markuppen i søtransport endogen og prisen givet af udlandet.
    # Her sætter vi en fast markup og antager at udlandet har samme omkostningsstruktur.
    # Strukturel markup i søtransport antages lig øvrige tjenester i fremskrivningen.
    E_pXUdl_xSoe_via_smrMarkup[t]$(tx1[t]).. smrMarkup[soe,t] =E= smrMarkup[tje,tEnd];

    E_pM_soe[s,t]$(tx1[t] and soe[s]).. pM[s,t] =E= pY[s,t];
  $ENDBLOCK

  MODEL M_pricing_deep /
    M_pricing
    B_pricing_deep
  /;
  model M_deep_dynamic_calibration / M_pricing_deep /;
  $GROUP+ G_deep_dynamic_calibration G_pricing_deep;
$ENDIF

# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
  $GROUP G_pricing_dynamic_calibration
    G_pricing_endo
    -pY[sMarkup,t1], smrMarkup[sMarkup,t1]
    -pY[sZeroMarkup,t1]$(not soe[sZeroMarkup]), pYfixed[sZeroMarkup,t1]$(not soe[sZeroMarkup])
    pYfixed[sZeroMarkup,tx1] # E_pYfixed
    -pY[udv,t1], upYUdv[t1]
    -pY[bol,t1], jpY_bol[t1]

    pOlieBrent[tx1] # E_pOlieBrent_forecast
    rDollarKurs[tx1] # E_rDollarKurs

    pXUdl[xVar,tx1] # E_pXUdl_xVar
    pXUdl[xTje,tx1] # E_pXUdl_xTje
    pXUdl[xTur,tx1] # E_pXUdl_xTur
    pXUdl[xEne,tx1] # E_pXUdl_xEne
    pXUdl[xSoe,tx1], -smrMarkup[soe,tx1]

    pM[m,tx1] # E_pM, E_pM_soe

    # Vi ser bort fra pristræghed i foreløbige dataår
    jrpYTraeghed[sp,t1] # E_jrpYTraeghed_t1
  ;
  $BLOCK B_pricing_dynamic_calibration
    E_pYfixed[sp,t]$(tx1[t] and sZeroMarkup[sp]).. @gradual_return_to_baseline(rYfixed);

    E_rDollarKurs[t]$(tx1[t]).. rDollarKurs[t] =E= rDollarKurs[t1];

    E_pOlieBrent_forecast[t]$(tx0E[t])..
      pOlieBrent[t] =E= pOlieBrent[t+1]*fp / (1 + rRente['obl',t+1]);

    # Ændringer i eksportkonkurrende priser antages at være permanente niveauændringer
    E_pXUdl_xVar[t]$(tx1[t])..
      pXUdl["xVar",t] / pXUdl["xVar",t1] =E= pXUdl_baseline["xVar",t] / pXUdl_baseline["xVar",t1];

    E_pXUdl_xTje[t]$(tx1[t])..
      pXUdl["xTje",t] =E= pXUdl["xTje",t1]; # Vækrate for udenlandske eksportkonkurrerende priser sættes lig raten for inflationskorrektion (gp=fp-1)

    # Relative forskydninger i pXUdl antages af følge forskydningerne i pXy
    E_pXUdl_xTur[t]$(tx1[t])..
      pXUdl["xTur",t] / pXUdl["xTje",t] =E= pXy["xTur",t] / pXy["xTje",t];

    E_pXUdl_xEne[t]$(tx1[t])..
      pXUdl["xEne",t] / pXUdl["xTje",t] =E= pXy["xEne",t] / pXy["xTje",t];

    # Ændringer i importpriser antages at være permanente niveauændringer
    E_pM[s,t]$(tx1[t] and m[s] and not soe[s])..
      pM[s,t] / pM[s,t1] =E= pM_baseline[s,t] / pM_baseline[s,t1];

    E_pM_soe[s,t]$(tx1[t] and soe[s]).. pM[s,t] =E= pY[s,t];

    E_jrpYTraeghed_t1[sp,t]$(t1[t]).. rpYTraeghed[sp,t] =E= 1;
  $ENDBLOCK
  MODEL M_pricing_dynamic_calibration /
    M_pricing
    B_pricing_dynamic_calibration
  /;
  model M_dynamic_calibration_newdata / M_pricing_dynamic_calibration /;
  $GROUP+ G_dynamic_calibration_newdata G_pricing_dynamic_calibration;
$ENDIF
