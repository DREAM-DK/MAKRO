# ======================================================================================================================
# Exports
# - Armington demand for exports of both domestically produced and imported goods
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_exports_prices_endo ;
  $GROUP G_exports_quantities_endo
    qX[x_,t] "Eksport, Kilde: ADAM[fE] og ADAM[fE<i>]"
    qXy[x_,t] "Direkte eksport."
    qXm[x_,t]$(d1Xm[x_,t]) "Import til reeksport."
    qCTurist[c,t]$(d1CTurist[c,t]) "Turisters forbrug i Danmark (imputeret)"
    qXSkala[t]$(t.val > 1969) "Endogen udbudseffekt på eksport."
    sqXSkala[t]$(t.val > 1969) "Hjælpevariabel - skaleeffekt i fravær af træghed."
    qXTraek[t] "Eksporttræk fra eksportmarkederne."
    qXMarked[t] "Eksportmarkedsstørrelse, Kilde: ADAM[fEe<i>]"
  ;
  $GROUP G_exports_values_endo ;

  $GROUP G_exports_endo
    G_exports_prices_endo
    G_exports_quantities_endo
    G_exports_values_endo

    uXy[x_,t]$(xTot[x_]) "Skalaparameter for direkte eksport."
    uXm[x_,t]$(xTot[x_]) "Skalaparameter for import til re-eksport."
    rpXy2pXUdl[x,t]$(not xSoe[x]) "Relative eksportpriser - dvs. eksportpriser over eksportkonkurrerende priser."
    dpXyTraeghed[x,t]$(not xSoe[x]) "Hjælpevariabel til beregning af effekt fra pristræghed."
    uCturisme[c,t]$(d1CTurist[c,t]) "Skalaparameter til fordeling af udenlandske turisters forbrug i Danmark på forbrugsgrupper."
    tXm[x,t]$(d1Xm[x,t]) "Aggregeret afgift på import til reeksport fordelt på eksportgrupper."
    fXyPriser[t] "Aggregeret effekt af relative priser på direkte eksport."
    fXmPriser[t] "Aggregeret effekt af relative priser på import til re-eksport."
    fXy[t] "Sammensætnings-effekter i direkte eksport."
    fXm[t] "Sammensætnings-effekter i import til re-eksport."
  ;
  $GROUP G_exports_endo G_exports_endo$(tx0[t]); # Restrict endo group to tx0[t]

  $GROUP G_exports_prices
    G_exports_prices_endo
  ;
  $GROUP G_exports_quantities
    G_exports_quantities_endo
    qBVTUdl[t] "BVT i verden, Kilde: World Bank, jf. makrobk"
    qBNPUdl_vaegt[t] "Handelsvægtede gennemsnit af BNP-væksten i 36 af Danmarks vigtigste samhandelslande, Kilde: ADAM[fYe]"
  ;
  $GROUP G_exports_values
    G_exports_values_endo
  ;

  $GROUP G_exports_exogenous_forecast
    qBVTUdl[t]
    uXMarked[t] "Parameter som knytter udenlandsk BVT og import"
  ;
  $GROUP G_exports_constants
    rXTraeghed        "Træghed i på gennemslag fra eksportmarkedsvækst."
    upXyTraeghed      "Træghed i pris-effekt på eksportefterspørgsel."
    rXSkalaTraeghed   "Træghed i skalaeffekt på eksportefterspørgsel."
    eXUdl[x] "Eksportpriselasticitet."
  ;
  #  $GROUP G_exports_other
  #  ;
  $GROUP G_exports_ARIMA_forecast
    uXy
    uXm
    fuCturisme[t] "Korrektionsfaktor for skalaparametrene til fordeling af udenlandske turisters forbrug i Danmark på forbrugsgrupper."
    uCturisme0[c,t] "Skalaparameter til fordeling af udenlandske turisters forbrug i Danmark på forbrugsgrupper før endelig skalering."
  ;

  $GROUP G_exports_fixed_forecast
    qBNPUdl_vaegt[t]
    rpXy2pXUdl[x,t]$(xSoe[x])
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_exports_static $(tx0[t])
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
    E_qX_xTot[t]..
      qX[xTot,t] * pX[xTot,t-1] =E= qXy[xTot,t] * pXy[xTot,t-1] + qXm[xTot,t] * pXm[xTot,t-1];

    E_uXy_xTot[t].. uXy[xTot,t] =E= sum(x, uXy[x,t]);

    E_qXm_xTot_via_fXm[t]..
      qXm[xTot,t] =E= uXm[xTot,t] * qXMarked[t] * fXmPriser[t] * fXm[t];

    E_uXm_xTot[t].. uXm[xTot,t] =E= sum(x, uXm[x,t]);

    E_fXmPriser[t]..
      uXm[xTot,t] * fXmPriser[t] =E= sum(x, uXm[x,t] * (1 + tXm[x,t])**(-eXUdl[x]));

    # Rigidity in spill over from increased foreign activity (qXMarked) to increased demand for domestically produced exports
    E_qXTraek[t]..
      qXTraek[t] =E= qXMarked[t]**(1-rXTraeghed) * (fq * qXTraek[t-1]/fq)**rXTraeghed;

    # Scale effect: increased supply in the long run increases demand for exports.
    # We use a gradual adjustment to the 5 year mean of structural private sector net output (except in ends of sample where sqBVT.l[spTot,t]=0)
    E_sqXSkala[t]..
      sqXSkala[t] =E= @mean(tt$[t.val-5 < tt.val and tt.val <= t.val and sqBVT.l[spTot,tt] > 0], sqBVT[spTot,tt] / qBVTUdl[t]) * 1e3; # Constant is to avoid numerical issues (uXy and uXm are scaled inversely in calibration)

    E_qXSkala[t]..
      qXSkala[t] =E= sqXSkala[t] * (1-rXSkalaTraeghed) + qXSkala[t-1]/fq * fq * rXSkalaTraeghed;

    E_qXMarked[t]..
      # qXMarked[t] =E= uXMarked[t] * qBVTUdl[t] / qBVTUdl[tBase];
      # Vi anvender 2019 i stedet for tBase, da tBase ligger efter det dybe kalibreringsår
      qXMarked[t] =E= uXMarked[t] * qBVTUdl[t] / qBVTUdl['%cal_deep%'];

    # ------------------------------------------------------------------------------------------------------------------
    # Composition effects are calculated by aggregating the disaggregate version with chain indices
    # ------------------------------------------------------------------------------------------------------------------
    E_qXy_xTot[t]..
      pXy[xTot,t-1] * qXy[xTot,t] =E= sum(x, pXy[x,t-1] * qXy[x,t]);

    E_qXm_xTot[t]..
      pXm[xTot,t-1] * qXm[xTot,t] =E= sum(x$(d1Xm[x,t]), pXm[x,t-1] * qXm[x,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Disaggregate version
    # ------------------------------------------------------------------------------------------------------------------
    # We model domestically produced exports and imports-to-exports separately.
    # There is no substitution between the two.

    # The price ratio for imports-to-exports only varies due to tariffs
    E_qXm[x,t]$(d1Xm[x,t])..
      qXm[x,t] =E= uXm[x,t] * qXTraek[t] * qXSkala[t] * (1 + tXm[x,t])**(-eXUdl[x]);

    E_tXm[x,t]$(d1Xm[x,t])..
      tXm[x,t] =E= sum(s, (1 + tIOm[x,s,t]) * vIOm[x,s,t]) / sum(s, vIOm[x,s,t]) - 1;

    # Domestic production and imports to exports are aggregated in a Laspeyres index 
    E_qX[x,t]..
      qX[x,t] * pX[x,t-1]/fp =E= qXy[x,t] * pXy[x,t-1]/fp + qXm[x,t] * pXm[x,t-1]/fp;

    # Tourist consumption in Denmark is split into different consumption groups. We currently do not model any substitution.
    E_qCTurist[c,t]$(d1CTurist[c,t])..
      qCTurist[c,t] =E= uCturisme[c,t] * qXy['xTur',t];

    E_uCturisme[c,t]$(d1CTurist[c,t])..
      uCturisme[c,t] =E= fuCturisme[t] * uCturisme0[c,t] / sum(cc, uCturisme0[cc,t]);
  $ENDBLOCK

  $BLOCK B_exports_forwardlooking $(tx0[t])
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
    E_qXy_xTot_via_fXy[t]..
      qXy[xTot,t] =E= uXy[xTot,t] * qXTraek[t] * qXSkala[t] * fXyPriser[t] * fXy[t];

    E_fXyPriser[t]..
      uXy[xTot,t] * fXyPriser[t] =E= sum(x, uXy[x,t] * rpXy2pXUdl[x,t]**(-eXUdl[x]));

    # ------------------------------------------------------------------------------------------------------------------
    # Disaggregate version
    # ------------------------------------------------------------------------------------------------------------------
    # We model domestically produced exports and imports-to-exports separately.
    # There is no substitution between the two.
    E_qXy[x,t]..
      qXy[x,t] =E= uXy[x,t] * qXTraek[t] * qXSkala[t] * rpXy2pXUdl[x,t]**(-eXUdl[x]);

    # Rigidity in relative price effect on foreign demand
    E_rpXy2pXUdl[x,t]$(tx0E[t] and not xSoe[x])..
      rpXy2pXUdl[x,t] =E= pXy[x,t] / pXUdl[x,t]
                        - dpXyTraeghed[x,t]
                        + dpXyTraeghed[x,t+1] * qXy[x,t+1]*fq / qXy[x,t] * pXUdl[x,t+1]*fp / pXUdl[x,t] / 2;

    E_rpXy2pXUdl_tEnd[x,t]$(tEnd[t] and not xSoe[x])..
      rpXy2pXUdl[x,t] =E= pXy[x,t] / pXUdl[x,t]
                        - dpXyTraeghed[x,t]
                        + dpXyTraeghed[x,t]*fv / 2;

    E_dpXyTraeghed[x,t]$(not xSoe[x])..
      dpXyTraeghed[x,t] =E= upXyTraeghed * rpXy2pXUdl[x,t] * (rpXy2pXUdl[x,t] / rpXy2pXUdl[x,t-1] - 1)
                                                           * (rpXy2pXUdl[x,t] / rpXy2pXUdl[x,t-1]);
  $ENDBLOCK

  MODEL M_exports /
    B_exports_static
    B_exports_forwardlooking
  /;

  $GROUP G_exports_static
    G_exports_endo
    -fXy, -fXyPriser
    -qXy$(x[x_])
    -rpXy2pXUdl$(not xSoe[x]), -dpXyTraeghed
  ;

  # Equations that do not need to be solved together with the full model and can instead be solved afterwards.
  MODEL M_exports_post /
    E_qXy_xTot_via_fXy
    E_qXm_xTot_via_fXm
    E_uXy_xTot
    E_uXm_xTot
    E_fXyPriser
    E_fXmPriser
  /;
  # Endogenous variables that are solved for only after the main model.
  # Note that these may not appear anywhere in the main model (this results in a model not square error).
  $GROUP G_exports_post
    fXy
    fXm
    uXy$(xTot[x_])
    uXm$(xTot[x_])
    fXyPriser
    fXmPriser
  ;
  $Group G_exports_post G_exports_post$(tx0[t]);

$ENDIF


$IF %stage% == "exogenous_values":
# =============================================================================================½=========================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_exports_makrobk
    qX, qXy$(x[x_]), qXm$(x[x_]), qCTurist, qXMarked, pXy$(x[x_])
    qBNPUdl_vaegt
  ;
  @load(G_exports_makrobk, "..\Data\makrobk\makrobk.gdx" )

  @load(qBVTUdl, "..\Data\FM_exogenous_forecast.gdx")

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

    uXy, -qXy[x,t]
    uXm$(d1Xm[x_,t]), -qXm[x,t]
    uCturisme0$(d1CTurist[c,t]), -qCTurist
    uXMarked, -qXMarked
    fuCturisme # E_fuCturisme
  ;
  $GROUP G_exports_static_calibration G_exports_static_calibration$(tx0[t])
    qXSkala[t0] # E_qXSkala_t0
    qXTraek[t0] # E_qXTraek_t0
  ;

  $BLOCK B_exports_static_calibration
    E_fuCturisme[t]$(tx0[t]).. sum(c, uCturisme0[c,t]) =E= 1;

    E_qXSkala_t0[t]$(t0[t]).. qXSkala[t] =E= qXSkala[t+1]*fq / fq;
    E_qXTraek_t0[t]$(t0[t]).. qXTraek[t] =E= qXTraek[t+1]*fq / fq;

    E_rpXy2pXUdl_static[x,t]$(tx0[t] and not xSoe[x])..
      rpXy2pXUdl[x,t] =E= pXy[x,t] / pXUdl[x,t]
                        - dpXyTraeghed[x,t]
                        + dpXyTraeghed[x,t]*fv / 2;
  $ENDBLOCK
  MODEL M_exports_static_calibration /
    M_exports - M_exports_post
    B_exports_static_calibration
    -E_rpXy2pXUdl -E_rpXy2pXUdl_tEnd # E_rpXy2pXUdl_static
  /;

  $GROUP G_exports_static_calibration_newdata
    G_exports_static_calibration
   ;
  MODEL M_exports_static_calibration_newdata /
    M_exports_static_calibration
  /;
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
    M_exports - M_exports_post
    B_exports_deep
  /;
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
  ;
$BLOCK B_exports_dynamic_calibration
    E_uXy_xSoe_dynamic[x_,t]$(xSoe[x_] and tx1[t]).. @gradual_return_to_baseline(uXy)

    E_uXy_dynamic[x_,t]$(tx1[t] and x[x_] and not xSoe[x_]).. @gradual_return_to_baseline(uXy);
$ENDBLOCK
  MODEL M_exports_dynamic_calibration /
    M_exports - M_exports_post
    B_exports_dynamic_calibration
  /;
$ENDIF