# ======================================================================================================================
# Pricing
# - Price rigidities, markups, and foreign prices
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_pricing_prices_endo # Group that is growth and inflation adjusted
    pY[s_,t]$(s[s_]) "Deflator for indenlandsk produktion, Kilde: ADAM[pX] eller ADAM[pX<i>]"
    # pY[off] beregnes i production_public
    pXUdl[x_,t] "Eksportkonkurrerende udenlandsk pris, Kilde: ADAM[pee<i>]"
    pM[s_,t]$(s[s_] and d1IOm[dTot,s_,t]) "Importdeflator fordelt på importgrupper, Kilde: ADAM[pM] eller ADAM[pM<i>]"
    pOlie[t] "Oliepris i DKK, Kilde: ADAM[pee3r]."
    pY0[s_,t]$(s[s_]) "Marginalomkostning fra produktion + øvrige produktionsskatter"
  ;
  $GROUP G_pricing_quantities_endo # Group that is growth adjusted
    empty_group_dummy[t] ""
  ; 
  $GROUP G_pricing_values_endo # Group that is adjusted for inflation
    empty_group_dummy[t] ""
  ; 

  $GROUP G_pricing_endo
    G_pricing_prices_endo
    G_pricing_quantities_endo
    G_pricing_values_endo
    jrmarkup[s_,t]$(sp[s_]) "Pristillæg fra mermarkup fordelt på brancher. Beregnes endogent ud fra jpIOy og er 0 historisk."
    jfpM[s,t]$(d1IOm[dTot,s,t]) "Pristillæg fra mermarkup fordelt på brancher. Beregnes endogent ud fra jpIOm og er 0 historisk."
    rMarkup[s_,t]$(sp[s_] or spTot[s_]) "Markup."
    srMarkup[s_,t]$(udv[s_] or soe[s_]) "Strukturel mark-up."
    fpM[t] "Korrektionsfaktor i aggregeret import-pris indeks - fanger sammensætningseffekter fra buttom-up beregning."
    dpYTraeghed[sp,t] "Hjælpevariabel til beregning af effekt fra omstillingsomkostninger på markup."
  ;
  $GROUP G_pricing_endo G_pricing_endo$(tx0[t]); # Restrict endo group to tx0[t]

  $GROUP G_pricing_prices
    G_pricing_prices_endo

    pOlieBrent[t] "Prisnotering på råolie, Brent (dollar/tønde), Kilde: ADAM[boil]"
    pUdlxOlie[t] "Udenlandske priser eksklusiv effekt af oliepris og træghed."
  ;
  $GROUP G_pricing_quantities
    G_pricing_quantities_endo
  ;
  $GROUP G_pricing_values
    G_pricing_values_endo
  ;

  $GROUP G_pricing_exogenous_forecast
    empty_group_dummy[t] ""
  ;
  $GROUP G_pricing_forecast_as_zero
    jpY_bol[t] "j-led."
  ;
  $GROUP G_pricing_ARIMA_forecast
    pY$(bol[s_])
    srMarkup
    upYUdv[t] "Skalaparameter for eksogen pris på udvinding."
    upXUdl[x,t] "Skalaparameter for udenlandske eksportkonkurrerende priser."
    upM[s,t] "Skalaparameter for import-priser."
    pUdlxOlie
    pOlieBrent
  ;
  $GROUP G_pricing_constants
    upYTraeghed[sp] "Parameter for Rotemberg omkostning."
    epM2pOlie[s_] "Oliepris-elasticitet for importpriser."
    epXUdl2pOlie[x] "Oliepris-elasticitet for udenlandske eksportkonkurrerende priser."
    epMtraeghed[s_] "Træghed i import-priser."
    epXUdlTraeghed[x] "Træghed i udenlandske eksport-konkurrerende priser"
  ;
  $GROUP G_pricing_other
    eY[sp,t] "Substitutionselasticitet mellem intermediate goods og final goods i produktionen."
    rDollarKurs[t] "Dollarkursen, DKK/Dollar, Kilde: ADAM[ewus]"
  ;

  set sMarkup[s_] "Brancher som fremskrives med en eksogen strukturel markup forskellig fra 0" /tje, fre, byg/;
  set sZeroMarkup[s_] "Brancher som fremskrives med 0 strukturel markup" /lan, ene, soe/;

$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
# ----------------------------------------------------------------------------------------------------------------------
# Final goods pricing
# ----------------------------------------------------------------------------------------------------------------------
  $BLOCK B_pricing
    E_rMarkup[sp,t]$(tx0[t]).. pY[sp,t] =E= (1+rMarkup[sp,t]) * pY0[sp,t];

    # Each sector set prices as a structural markup over marginal costs in the long run
    # while smoothing the rate of change due to adjustment costs
    E_pY[sp,t]$(tx0E[t] and not udv[sp] and not bol[sp])..
      rMarkup[sp,t] =E= srMarkup[sp,t] - dpYTraeghed[sp,t]              
                 + 2 * dpYTraeghed[sp,t+1] / (1+rVirkDisk[sp,t+1]) * qY[sp,t+1]*fq/qY[sp,t]
                     * pY0[sp,t+1]*fp/pY0[sp,t] + jrmarkup[sp,t] ;

    E_dpYTraeghed[sp,t]$(tx0[t]).. 
      dpYTraeghed[sp,t] =E= upYTraeghed[sp] * ((pY[sp,t]/pY[sp,t-1]) / (pY[sp,t-1]/pY[sp,t-2]) - 1)
                                            * ((pY[sp,t]/pY[sp,t-1]) / (pY[sp,t-1]/pY[sp,t-2]));

    E_pY0[sp,t]$(tx0[t])..
      pY0[sp,t] =E= (pKLBR[sp,t] + vtNetYRest[sp,t] / qY[sp,t]) ;

    E_pY_tEnd[sp,t]$(tEnd[t] and not udv[sp] and not bol[sp])..
      rMarkup[sp,t] =E= srMarkup[sp,t] + jrmarkup[sp,t];

    # Only used if the user wishes to deviate from law of one price in the IO system.
    # IO system should ensure that demand equals supply. If you shock the demand prices through jpIOy or jpIOm
    # then these equations ensure that this is still the case.
    E_jrmarkup[s,t]$(tx0[t] and sp[s])..
      jrmarkup[s,t] * qY[s,t] =E= sum(d, jpIOy[d,t] * qIOy[d,s,t] / (1 + tIOy[d,s,tBase]));
    E_jfpM[s,t]$(tx0[t] and d1IOm[dTot,s,t])..
      jfpM[s,t] * qM[s,t] =E= sum(d, jpIOm[d,t] * qIOm[d,s,t] / (1 + tIOm[d,s,tBase])); 

    # Extraction sector prices (mostly oil and gas) follows import prices except for the small share that is gravel extraction
    E_srMarkup_udv[t]$(tx0[t])..
      pY['udv',t] =E= upYUdv[t] * (
                        (1 - qGrus[t] / qY['udv',t]) * pM['udv',t]
                        + qGrus[t] / qY['udv',t] * pY0['udv',t]
                      ) * (1 + jrmarkup['udv',t]);

    # Shipping industry chooses their markup to keep the relative export price constant
    E_srMarkup_soe[t]$(tx0[t])..
      pXy['xSoe',t] =E= rpXy2pXUdl['xSoe',t] * pXUdl['xSoe',t];

    # Synthetic housing sector rental price follows moving average of non-housing consumer price index
    E_pY_bol[t]$(tx0[t])..
      pY['bol',t] =E= (pY['bol',t-1]/fp * (1 + pCInflSnit[t]) + jpY_bol[t]) * (1 + jrmarkup['bol',t]);

    # Aggregate import price - composition effects from bottom-up price index are captured by fpM
    E_fpM[t]$(tx0[t])..
      pM[sTot,t] =E= (pOlie[t]**epM2pOlie[sTot] * pUdlxOlie[t]**(1-epM2pOlie[sTot]))**(1-epMtraeghed[sTot])
                   * (pM[sTot,t-1]/fp)**epMtraeghed[sTot] * fpM[t];

    # Import prices
    E_pM[s,t]$(tx0[t] and d1IOm[dTot,s,t])..
      pM[s,t] =E= (upM[s,t] * pOlie[t]**epM2pOlie[s] * pUdlxOlie[t]**(1-epM2pOlie[s]))**(1-epMtraeghed[s])
                * (pM[s,t-1]/fp)**epMtraeghed[s] * (1 + jfpM[s,t]) ;

    # Export-competing prices follow the oil price and other foreign prices,
    # with parameters set to match the first year and long run response of Danish export prices to an oil price shock
    E_pXUdl[x,t]$(tx0[t])..
      pXUdl[x,t] =E= (upXUdl[x,t] * pOlie[t]**epXUdl2pOlie[x] * pUdlxOlie[t]**(1-epXUdl2pOlie[x]))**(1-epXUdlTraeghed[x])
                   * (pXUdl[x,t-1]/fp)**epXUdlTraeghed[x];

    E_pXUdl_tot[t]$(tx0[t]).. pXUdl[xTot,t] * qX[xTot,t] =E= sum(x, pXUdl[x,t] * qX[x,t]);

    E_pOlie[t]$(tx0[t]).. pOlie[t] =E= pOlieBrent[t] * rDollarKurs[t] / (pOlieBrent[tBase] * rDollarKurs[tBase]);

    # Aggregate markup
    E_rMarkup_spTot[t]$(tx0[t]).. 1+rMarkup[spTot,t] =E= vY[spTot,t] / sum(sp, pY0[sp,t] * qY[sp,t]);
  $ENDBLOCK

  # Equations that do not need to be solved together with the full model and can instead be solved afterwards.   
  MODEL M_pricing_post /
    #  E_rMarkup 
    E_rMarkup_spTot
  /;

  # Endogenous variables that are solved for only after the main model.
  # Note that these may not appear anywhere in the main model (this results in a model not square error).
  $GROUP G_pricing_post
    rMarkup[s_,t]$(spTot[s_]) "Markup."
  ;
  $GROUP G_pricing_post G_pricing_post$(tx0[t]);
$ENDIF


$IF %stage% == "exogenous_values":
# =============================================================================================½=========================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_pricing_makrobk
    pY$(s[s_]), pXUdl$(x[x_]), pM, pOlie, pOlieBrent, rDollarKurs
  ;
  @load(G_pricing_makrobk, "..\Data\makrobk\makrobk.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_pricing_data  
    G_pricing_makrobk
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  # Sættes for at matche SVARer mv.
  upYTraeghed.l[sp]$(sMarkup[sp]) = 0.607572;
  upYTraeghed.l[sp]$(sZeroMarkup[sp]) = 0;

  # Estimerede
  epM2pOlie.l[sTot] = 0.22;
  epMtraeghed.l[sTot] = 0.33;
  epM2pOlie.l['fre'] = 0.12;
  epMtraeghed.l['fre'] = 0.40;
  epM2pOlie.l['tje'] = 0.17;
  epMtraeghed.l['tje'] = 0.45;
  epM2pOlie.l['ene'] = 0.82;
  epMtraeghed.l['ene'] = 0.35;
  epM2pOlie.l['udv'] = 0.89;
  epMtraeghed.l['udv'] = 0.20;

  # Elasticiteter for udenlandske priser er ikke estimeret, men sættes for matche danske eksportpriser
  epXUdl2pOlie.l['xEne'] = 0.310030;
  epXUdl2pOlie.l['xVar'] = 0.100567;
  epXUdl2pOlie.l['xSoe'] = 0.248139;
  epXUdl2pOlie.l['xTje'] = 0.093886;
  epXUdl2pOlie.l['xTur'] = 0.114428;

  epXUdlTraeghed.l['xEne'] = 0;
  epXUdlTraeghed.l['xVar'] = 0.731843;
  epXUdlTraeghed.l['xSoe'] = 0.449751;
  epXUdlTraeghed.l['xTje'] = 0.690770;
  epXUdlTraeghed.l['xTur'] = 0.614859;

  fpM.l[t] = 1; # pUdlxOlie bestemt ved identificerende antagelse om at fpM=1

# ======================================================================================================================
# Data assignment
# ======================================================================================================================  

$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_pricing_static_calibration
    G_pricing_endo

    -pY$(sZeroMarkup[s_]), srMarkup$(sZeroMarkup[s_])
    -pY$(sMarkup[s_]), srMarkup$(sMarkup[s_])
    -pY$(udv[s_]), upYUdv
    -pY$(bol[s_]), jpY_bol
    -pY$(soe[s_]), rpXy2pXUdl$(xSoe[x])
    -pY$(sOff[s_]), srMarkup$(sOff[s_])

    -pXUdl$(x[x_]), upXUdl
    -pM, upM$(d1IOm[dTot,s,t])
    -fpM, pUdlxOlie
    -jrmarkup # -E_jrmarkup
  ;
  $GROUP G_pricing_static_calibration
    G_pricing_static_calibration$(tx0[t])
  ;

  $BLOCK B_pricing_static_calibration
    # E_pY using static expectations in the forward looking rigidity 
    E_srMarkup[sp,t]$(tx0[t] and not (bol[sp] or udv[sp] or soe[sp]))..
      rMarkup[sp,t] =E= srMarkup[sp,t];
  $ENDBLOCK
  MODEL M_pricing_static_calibration /
    B_pricing
    B_pricing_static_calibration
    - E_pY - E_pY_tEnd # E_srMarkup 
    - E_jrmarkup
  /;
$ENDIF

# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_pricing_deep
    G_pricing_endo
    -pY$(t1[t] and sMarkup[s_]), srMarkup$(sMarkup[s_]) # E_srMarkup_forecast
    -pY$(t1[t] and sZeroMarkup[s_]), srMarkup$(sZeroMarkup[s_]), rpXy2pXUdl$(xSoe[x]) # E_srMarkup_forecast_sZeroMarkup
    -pY$(t1[t] and udv[s_]), upYUdv$(t1[t])
    -pY$(t1[t] and bol[s_]), jpY_bol$(t1[t])
  ;
  $GROUP G_pricing_deep G_pricing_deep$(tx0[t]);

  $BLOCK B_pricing_deep
    # Forward looking price rigidity causes means that the markup parameter has to be dynamically calibrated.
    # We use the dynamics of the ARIMA, but shift the level to match price levels in the data
    E_srMarkup_deep_forecast[sp,t]$(tx1[t] and sMarkup[sp])..
      srMarkup[sp,t] =E= srMarkup_ARIMA[sp,t] + srMarkup[sp,t1] - srMarkup_ARIMA[sp,t1];

    # Structural markups are truncated to be at least zero in the forecast
    E_srMarkup_deep_forecast_sZeroMarkup[sp,t]$(tx1[t] and sZeroMarkup[sp])..
      srMarkup[sp,t] =E= 0;
  $ENDBLOCK
  MODEL M_pricing_deep /
    B_pricing - M_pricing_post
    B_pricing_deep
  /;
$ENDIF

# ======================================================================================================================
# Simple dynamic calibration
# ======================================================================================================================
$IF %stage% == "simple_dynamic_calibration":
  $GROUP G_pricing_dynamic_calibration
    G_pricing_endo
    -pY$(t1[t] and sMarkup[s_]), srMarkup$(t1[t] and sMarkup[s_])
    -pY$(t1[t] and sZeroMarkup[s_]), srMarkup$(t1[t] and sZeroMarkup[s_]), rpXy2pXUdl$(t1[t] and xSoe[x])
    -pY$(t1[t] and udv[s_]), upYUdv$(t1[t])
    -pY$(t1[t] and bol[s_]), jpY_bol$(t1[t])

    srMarkup$(tx1[t] and sMarkup[s_]) # E_srMarkup_forecast
    rpXy2pXUdl$(tx1[t] and xSoe[x]) # E_rpXy2pXUdl_xSoe_forecast
  ;
  $BLOCK B_pricing_dynamic_calibration
    E_srMarkup_forecast[sp,t]$(tx1[t] and sMarkup[sp])..
      srMarkup[sp,t] =E= srMarkup_baseline[sp,t] + aftrapprofil[t] * (srMarkup[sp,t1] - srMarkup_baseline[sp,t1]);

    E_rpXy2pXUdl_xSoe_forecast[t]$(tx1[t])..
      rpXy2pXUdl['xSoe',t] =E= rpXy2pXUdl_baseline['xSoe',t] + aftrapprofil[t] * (rpXy2pXUdl['xSoe',t1] - rpXy2pXUdl_baseline['xSoe',t1]);
  $ENDBLOCK
  MODEL M_pricing_dynamic_calibration /
    B_pricing
    B_pricing_dynamic_calibration
  /;
$ENDIF