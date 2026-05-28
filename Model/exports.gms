# ======================================================================================================================
# Exports
# - Armington demand for exports of both domestically produced and imported goods
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_export_variables
    qX[x_,t] "Eksport, Kilde: ADAM[fE] og ADAM[fE<i>]"
    qXy[x_,t] "Direkte eksport."
    qXm[x_,t] "Import til reeksport."
    qCTurist[c,t] "Turisters forbrug i Danmark (imputeret)"
    qXSkala[t] "Endogen udbudseffekt på eksport."
    sqXSkala[t] "Hjælpevariabel - skaleeffekt i fravær af træghed."
    qXTraek[t] "Eksporttræk fra eksportmarkederne."
    qXMarked[t] "Eksportmarkedsstørrelse, Kilde: ADAM[fEe<i>]"
    rpXy2pXUdl[x,t] "Relative eksportpriser - dvs. eksportpriser over eksportkonkurrerende priser."
    dpXyTraeghed[x,t] "Hjælpevariabel til beregning af effekt fra pristræghed."
    uCturisme[c,t] "Skalaparameter til fordeling af udenlandske turisters forbrug i Danmark på forbrugsgrupper."
    tXm[x,t] "Aggregeret afgift på import til reeksport fordelt på eksportgrupper."
    fXyPriser[t] "Aggregeret effekt af relative priser på direkte eksport."
    fXmPriser[t] "Aggregeret effekt af relative priser på import til re-eksport."
    fXy[t] "Sammensætnings-effekter i direkte eksport."
    fXm[t] "Sammensætnings-effekter i import til re-eksport."
    rpX[t] "Relative laggede priser i eksport vægtet med nutidige mængder."
    rpXy[t] "Relative laggede priser i direkte eksport vægtet med nutidige mængder."
    rpXm[t] "Relative laggede priser i import til reeksport vægtet med nutidige mængder."
  ;

  $GROUP G_exports_exogenous_forecast
    qBVTUdl[t] "BVT i verden, Kilde: World Bank, jf. makrobk"
    uXMarked[t] "Parameter som knytter udenlandsk BVT og import"
    vX_Processing[t] "Eksport af processing i løbende priser"
    vX_Merchanting[t] "Eksport af merchanting i løbende priser"
    qX_Processing[t] "Eksport af processing i kædede priser"
    qX_Merchanting[t] "Eksport af merchanting i kædede priser"
  ;
  $GROUP+ G_exogenous_forecast G_exports_exogenous_forecast$(tx1[t]);

  $GROUP G_exports_constants
    rXTraeghed        "Træghed i på gennemslag fra eksportmarkedsvækst."
    upXyTraeghed      "Træghed i pris-effekt på eksportefterspørgsel."
    rXSkalaTraeghed   "Træghed i skalaeffekt på eksportefterspørgsel."
    eXUdl[x] "Eksportpriselasticitet."
  ;
  $GROUP+ G_constants G_exports_constants;

  $GROUP G_exports_ARIMA_forecast
    uXy[x_,t] "Skalaparameter for direkte eksport."
    uXm[x_,t] "Skalaparameter for import til re-eksport."
    fuCturisme[t] "Korrektionsfaktor for skalaparametrene til fordeling af udenlandske turisters forbrug i Danmark på forbrugsgrupper."
    uCturisme0[c,t] "Skalaparameter til fordeling af udenlandske turisters forbrug i Danmark på forbrugsgrupper før endelig skalering."
  ;
  $GROUP+ G_ARIMA_forecast G_exports_ARIMA_forecast;

  $GROUP G_exports_fixed_forecast
    rpXy2pXUdl[x,t]$(xSoe[x]) "Relative eksportpriser - dvs. eksportpriser over eksportkonkurrerende priser."
  ;
  $GROUP+ G_fixed_forecast G_exports_fixed_forecast;

  $GROUP G_exports_data_only
    qBNPUdl_vaegt[t] "Handelsvægtede gennemsnit af BNP-væksten i 36 af Danmarks vigtigste samhandelslande, Kilde: ADAM[fYe]"
  ;

$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_exports_static G_exports_core $(tx0[t])
    # # ------------------------------------------------------------------------------------------------------------------
    # Two versions of the export model are written here: an aggregate and a disaggregate version.
    # The disaggregate version is the core model.
    # The aggregate version is a simplified version useful for analyzing overall responses.
    # The difference between the two are as far as possible collected in explicit composition effect terms.
    # ------------------------------------------------------------------------------------------------------------------

    # ------------------------------------------------------------------------------------------------------------------
    # Aggregate version
    # ------------------------------------------------------------------------------------------------------------------
    # Total exports
    rpX[t].. qX[xTot,t] =E= rpX[t] * (qXy[xTot,t] + qXm[xTot,t]);

    .. qX[xTot,t] * pX[xTot,t-1] =E= qXy[xTot,t] * pXy[xTot,t-1] + qXm[xTot,t] * pXm[xTot,t-1];

    $(t.val >= %EksportData_t1%).. uXy[xTot,t] =E= sum(x, uXy[x,t]);

    fXm[t]$(t.val >= %EksportData_t1%)..
      qXm[xTot,t] =E= uXm[xTot,t] * qXMarked[t] * fXmPriser[t] * fXm[t];

    $(t.val >= %EksportData_t1%).. uXm[xTot,t] =E= sum(x$(d1Xm[x,t]), uXm[x,t]);

    fXmPriser[t]$(t.val >= %EksportData_t1%)..
      uXm[xTot,t] * fXmPriser[t] =E= sum(x$(d1Xm[x,t]), uXm[x,t] * (1 + tXm[x,t])**(-eXUdl[x]));

    # Rigidity in spill over from increased foreign activity (qXMarked) to increased demand for domestically produced exports
    $(t.val >= %EksportData_t1%)..
      qXTraek[t] =E= qXMarked[t]**(1-rXTraeghed) * (fq * qXTraek[t-1]/fq)**rXTraeghed;

    # Scale effect: increased supply in the long run increases demand for exports.
    # We use a gradual adjustment to the 5 year mean of structural private sector net output (except in ends of sample where sqBVT.l[spTot,t]=0)
    .. sqXSkala[t] =E= @mean(tt$[t.val-5 < tt.val and tt.val <= t.val and sqBVT.l[spTot,tt] > 0],
                             sqBVT[spTot,tt] / qBVTUdl[tt])
                     * 1e3; # Constant is to avoid numerical issues (uXy and uXm are scaled inversely in calibration)

    .. qXSkala[t] =E= sqXSkala[t] * (1-rXSkalaTraeghed) + qXSkala[t-1]/fq * fq * rXSkalaTraeghed;

    $(t.val >= %EksportData_t1%)..
      qXMarked[t] =E= uXMarked[t] * qBVTUdl[t] / qBVTUdl[tBase];

    # ------------------------------------------------------------------------------------------------------------------
    # Composition effects are calculated by aggregating the disaggregate version with chain indices
    # ------------------------------------------------------------------------------------------------------------------
    rpXy[t].. qXy[xTot,t] =E= rpXy[t] * sum(x, qXy[x,t]);
    rpXm[t].. qXm[xTot,t] =E= rpXm[t] * sum(x$(d1Xm[x,t]), qXm[x,t]);

    qXy[xTot,t].. pXy[xTot,t-1] * qXy[xTot,t] =E= sum(x, pXy[x,t-1] * qXy[x,t]);
    qXm[xTot,t].. pXm[xTot,t-1] * qXm[xTot,t] =E= sum(x$(d1Xm[x,t]), pXm[x,t-1] * qXm[x,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Disaggregate version
    # ------------------------------------------------------------------------------------------------------------------
    # We model domestically produced exports and imports-to-exports separately.
    # There is no substitution between the two.

    # The price ratio for imports-to-exports only varies due to tariffs
    $(d1Xm[x,t] and t.val >= %EksportData_t1%)..
      qXm[x,t] =E= uXm[x,t] * qXTraek[t] * qXSkala[t] * (1 + tXm[x,t])**(-eXUdl[x]);

    $(d1Xm[x,t])..
      tXm[x,t] =E= sum(s$(d1IOm[x,s,t]), (1 + tIOm[x,s,t]) * vIOm[x,s,t])
                 / sum(s$(d1IOm[x,s,t]), vIOm[x,s,t]) - 1;

    # Domestic production and imports to exports are aggregated in a Laspeyres index 
    .. qX[x,t] * pX[x,t-1]/fp =E= qXy[x,t] * pXy[x,t-1]/fp + qXm[x,t] * pXm[x,t-1]/fp;

    # Tourist consumption in Denmark is split into different consumption groups. We currently do not model any substitution.
    $(d1CTurist[c,t]).. qCTurist[c,t] =E= uCturisme[c,t] * qXy['xTur',t];

    $(d1CTurist[c,t])..
      uCturisme[c,t] =E= fuCturisme[t] * uCturisme0[c,t] / sum(cc$(d1CTurist[cc,t]), uCturisme0[cc,t]);
  $ENDBLOCK

  $BLOCK B_exports_forwardlooking G_exports_forwardlooking_endo $(tx0[t])
    # ------------------------------------------------------------------------------------------------------------------
    # Two versions of the export model are written here: an aggregate and a disaggregate version.
    # The disaggregate version is the core model.
    # The aggregate version is a simplified version useful for analyzing overall responses.
    # The difference between the two are as far as possible collected in explicit composition effect terms.
    # ------------------------------------------------------------------------------------------------------------------

    # ------------------------------------------------------------------------------------------------------------------
    # Aggregate version
    # ------------------------------------------------------------------------------------------------------------------
    # Total exports
    fXy[t]$(t.val >= %EksportData_t1%)..
      qXy[xTot,t] =E= uXy[xTot,t] * qXTraek[t] * qXSkala[t] * fXyPriser[t] * fXy[t];

    fXyPriser[t]$(t.val >= %EksportData_t1%)..
      uXy[xTot,t] * fXyPriser[t] =E= sum(x, uXy[x,t] * rpXy2pXUdl[x,t]**(-eXUdl[x]));

    # ------------------------------------------------------------------------------------------------------------------
    # Disaggregate version
    # ------------------------------------------------------------------------------------------------------------------
    # We model domestically produced exports and imports-to-exports separately.
    # There is no substitution between the two.
    $(t.val >= %EksportData_t1%)..
      qXy[x,t] =E= uXy[x,t] * qXTraek[t] * qXSkala[t] * rpXy2pXUdl[x,t]**(-eXUdl[x]);

    # Rigidity in relative price effect on foreign demand
    # Diskoneteringsraten er hard-codet til 15% ift. dokumentationen, hvilket giver en ren blanding af en
    # fremadskuende og tilbageskuende relationen
    $(tx0E[t] and not xSoe[x] and t.val > %EksportData_t1%)..
      rpXy2pXUdl[x,t] =E= pXy[x,t] / pXUdl[x,t]
                        - dpXyTraeghed[x,t]
                        + dpXyTraeghed[x,t+1] * qXy[x,t+1]*fq / qXy[x,t] * pXUdl[x,t+1]*fp / pXUdl[x,t] / (1+rVirkDisk[spTot,t+1]);

    rpXy2pXUdl&_tEnd[x,t]$(tEnd[t] and not xSoe[x])..
      rpXy2pXUdl[x,t] =E= pXy[x,t] / pXUdl[x,t]
                        - dpXyTraeghed[x,t]
                        + dpXyTraeghed[x,t]*fv / (1+rVirkDisk[spTot,t]);

    $(not xSoe[x] and t.val > %EksportData_t1%)..
      dpXyTraeghed[x,t] =E= upXyTraeghed * rpXy2pXUdl[x,t] * (rpXy2pXUdl[x,t] / rpXy2pXUdl[x,t-1] - 1)
                                                           * (rpXy2pXUdl[x,t] / rpXy2pXUdl[x,t-1]);

  $ENDBLOCK

  $GROUP G_exports_endo 
    G_exports_core
    G_exports_forwardlooking_endo
  ;

  MODEL M_exports /
    B_exports_static
    B_exports_forwardlooking
  /;
  model M_base / M_exports /;

  $GROUP G_exports_static
    G_exports_endo
    -fXy, -fXyPriser
    -qXy$(x[x_])
    -rpXy2pXUdl$(not xSoe[x]), -dpXyTraeghed
  ;
  model M_static / B_exports_static /;
  $GROUP+ G_static G_exports_static;
  $GROUP+ G_Endo G_exports_endo;
$ENDIF


$IF %stage% == "exogenous_values":
# =============================================================================================½=========================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_exports_makrobk
    qX, qXy, qXm$(x[x_]), qCTurist, qXMarked
    qBNPUdl_vaegt
  ;
  @load(G_exports_makrobk, "../Data/Makrobk/makrobk.gdx" )

  @load(qBVTUdl, "../Data/FM_exogenous_forecast.gdx")

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_exports_data
    G_exports_makrobk
    qBVTUdl
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  rXTraeghed.l = 0.250219; # Matching parameter
  
  # Trunkeret til 5, baseret på Kronborg, A., Poulsen, K., & Kastrup, C. (2020). Estimering af udenrigshandelselasticiteter i MAKRO
  eXUdl.l[x] = 5;
  #  eXUdl.l['xEne'] = 5.6; # Eksport af energi er eksogent
  rXSkalaTraeghed.l = 0.5;
  upXyTraeghed.l = 20.009598; # Matching parameter

# ======================================================================================================================
# Data assignment
# ======================================================================================================================
  # Dummy'er for eksport og turistforbrug laves her
  d1X[x,t] = qX.l[x,t] > 0;
  d1CTurist[c,t] = qCTurist.l[c,t] > 0;
$ENDIF


# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_exports_static_calibration
    G_exports_endo

    uXy$(t.val >= %EksportData_t1%), -qXy[x,t]$(t.val >= %EksportData_t1%)
    uXm$(d1Xm[x_,t] and t.val >= %EksportData_t1%), -qXm[x,t]$(t.val >= %EksportData_t1%)
    uCturisme0$(d1CTurist[c,t]), -qCTurist
    uXMarked$(t.val >= %EksportData_t1%), -qXMarked$(t.val >= %EksportData_t1%)
    fuCturisme # E_fuCturisme
  ;
  $GROUP G_exports_static_calibration G_exports_static_calibration$(tx0[t])
    qXSkala[t0] # E_qXSkala_t0
    qXTraek$(t.val = %EksportData_t1%-1)
  ;

  $BLOCK B_exports_static_calibration
    E_fuCturisme[t]$(tx0[t]).. sum(c$(d1CTurist[c,t]), uCturisme0[c,t]) =E= 1;

    E_qXSkala_t0[t]$(t0[t]).. qXSkala[t] =E= qXSkala[t+1]*fq / fq;
    E_qXTraek_ini[t]$(t.val = %EksportData_t1%-1).. qXTraek[t] =E= qXTraek[t+1]*fq / fq;

    E_rpXy2pXUdl_static[x,t]$(tx0[t] and not xSoe[x] and t.val > %EksportData_t1%)..
      rpXy2pXUdl[x,t] =E= pXy[x,t] / pXUdl[x,t]
                        - dpXyTraeghed[x,t]
                        + dpXyTraeghed[x,t]*fv / (1+rVirkDisk[spTot,t]);
  $ENDBLOCK
  MODEL M_exports_static_calibration /
    M_exports
    B_exports_static_calibration
    -E_rpXy2pXUdl_x -E_rpXy2pXUdl_tEnd # E_rpXy2pXUdl_static
  /;
  model M_static_calibration / M_exports_static_calibration /;
  $GROUP+ G_static_calibration G_exports_static_calibration;

  $GROUP G_exports_static_calibration_newdata
    G_exports_static_calibration
  ;
  $GROUP+ G_static_calibration_newdata G_exports_static_calibration_newdata;
$ENDIF

# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_exports_deep
    G_exports_endo
    uXm[x_,t1]$(d1Xm[x_,t]), -qXm[x,t1]
    uXy[x_,t1], -qXy[x,t1]
    uXy[x_,tx1]
  ;
  $GROUP G_exports_deep G_exports_deep$(tx0[t]);

  $BLOCK B_exports_deep
    E_uXy_deep[x,t]$(tx1[t]).. 
      uXy[x,t] =E= uXy_ARIMA[x,t] / uXy_ARIMA[x,t1] * uXy[x,t1];
  $ENDBLOCK

  MODEL M_exports_deep /
    M_exports
    B_exports_deep
  /;
  model M_deep_dynamic_calibration / M_exports_deep /;
  $GROUP+ G_deep_dynamic_calibration G_exports_deep;
$ENDIF

# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
  $GROUP G_exports_dynamic_calibration
    G_exports_endo
    uXy[x,t1], -qXy[x,t1]
    uXm[x_,t1]$(d1Xm[x_,t]), -qXm[x,t1]
    uXy[xSoe,tx1] # E_uXy_xSoe_dynamic
    uXy[x_,tx1]$(not xSoe[x_]) # E_uXy_dynamic
    uXMarked[tx1]
  ;
$BLOCK B_exports_dynamic_calibration
  E_uXy_dynamic[x_,t]$(tx1[t] and x[x_]).. uXy[x_,t] =E= uXy_baseline[x_,t] / uXy_baseline[x_,t1] * uXy[x_,t1];

  E_uXMarked[t]$(tx1[t]).. uXMarked[t] / uXMarked[t1] =E= uXMarked_baseline[t] / uXMarked_baseline[t1];
$ENDBLOCK
  MODEL M_exports_dynamic_calibration /
    M_exports
    B_exports_dynamic_calibration
  /;
  model M_dynamic_calibration_newdata / M_exports_dynamic_calibration /;
  $GROUP+ G_dynamic_calibration_newdata G_exports_dynamic_calibration;
$ENDIF