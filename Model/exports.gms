# ======================================================================================================================
# Exports
# - Armington demand for exports of both domestically produced and imported goods
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_exports_prices_endo
    empty_group_dummy[t]
  ;
  $GROUP G_exports_quantities_endo
    qX[x_,t] "Eksport, Kilde: ADAM[fE] og ADAM[fE<i>]"
    qXy[x_,t]$(not xEne[x_]) "Direkte eksport."
    qXm[x_,t]$(d1Xm[x_,t]) "Import til reeksport."
    qCTurist[c,t]$(d1CTurist[c,t]) "Turisters forbrug i Danmark (imputeret)"
    qXSkala[t] "Endogen udbudseffekt på eksport."
    qXTraek[t] "Eksporttræk fra eksportmarkederne."
  ;
  $GROUP G_exports_values_endo
    empty_group_dummy
  ;

  $GROUP G_exports_endo
    G_exports_prices_endo
    G_exports_quantities_endo
    G_exports_values_endo

    uXy[x_,t]$(xEne[x_] or xTot[x_]) "Skalaparameter for direkte eksport."
    uXm[x_,t]$(xTot[x_]) "Skalaparameter for import til re-eksport."
    rpXUdl2pXy[x,t] "Relative eksportpriser - dvs. eksportkonkurrerende priser over eksportpriser."
    rpXy2pXUdl[x,t]$(not xSoe[x]) "Relative eksportpriser - dvs. eksportpriser over eksportkonkurrerende priser."
    dpXyTraeghed[x,t]$(not xSoe[x]) "Hjælpevariabel til beregning af effekt fra pristræghed."
    uCturisme[c,t] "Skalaparameter til fordeling af udenlandske turisters forbrug i Danmark på forbrugsgrupper."
    rpXm2pM[x,t] "Relativ pris på import vs. export fordelt på eksportgrupper."
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

    qXMarked[t] "Eksportmarkedsstørrelse, Kilde: ADAM[fEe<i>]"
  ;
  $GROUP G_exports_values
    G_exports_values_endo
  ;

  $GROUP G_exports_exogenous_forecast
    qXy$(xEne[x_])
  ;
  $GROUP G_exports_constants
    rXTraeghed        "Træghed i på gennemslag fra eksportmarkedsvækst."
    upXyTraeghed      "Træghed i pris-effekt på eksportefterspørgsel."
    rXSkalaTraeghed   "Træghed i skalaeffekt på eksportefterspørgsel."
    eXUdl[x] "Eksportpriselasticitet."
  ;
  $GROUP G_exports_other
    cpXyTraeghed[x,t] "Parameter som kalibreres for at fjerne træghed i pris-effekt på eksportefterspørgsel i grundforløb."
  ;
  $GROUP G_exports_ARIMA_forecast
    qXMarked
    uXy
    uXm
    fuCturisme[t] "Korrektionsfaktor for skalaparametrene til fordeling af udenlandske turisters forbrug i Danmark på forbrugsgrupper."
    uCturisme0[c,t] "Skalaparameter til fordeling af udenlandske turisters forbrug i Danmark på forbrugsgrupper før endelig skalering."
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_exports
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
    E_qX_xTot[t]$(tx0[t])..
      qX[xTot,t] * pX[xTot,t-1] =E= qXy[xTot,t] * pXy[xTot,t-1] + qXm[xTot,t] * pXm[xTot,t-1];

    E_qXy_xTot[t]$(tx0[t])..
      qXy[xTot,t] =E= uXy[xTot,t] * qXTraek[t] * qXSkala[t] * fXyPriser[t] * fXy[t];

    E_qXm_xTot[t]$(tx0[t])..
      qXm[xTot,t] =E= uXm[xTot,t] * qXMarked[t] * fXmPriser[t] * fXm[t];

    E_fXyPriser[t]$(tx0[t])..
      fXyPriser[t] / fXyPriser[t-1] =E= sum(x, rpXy2pXUdl[x,t]**(-eXUdl[x]) * qXy[x,t-1])
                                      / sum(x, rpXy2pXUdl[x,t-1]**(-eXUdl[x]) * qXy[x,t-1]);

    E_fXmPriser[t]$(tx0[t])..
      fXmPriser[t] / fXmPriser[t-1] =E= sum(x$(d1Xm[x,t]), rpXm2pM[x,t]**(-eXUdl[x]) * qXm[x,t-1])
                                      / sum(x$(d1Xm[x,t-1]), rpXm2pM[x,t-1]**(-eXUdl[x]) * qXm[x,t-1]);

    E_uXy_xTot[t]$(tx0[t])..
      uXy[xTot,t] / uXy[xTot,t-1] =E= sum(x, uXy[x,t] * qXy[x,t-1]) / sum(x, uXy[x,t-1] * qXy[x,t-1]);

    E_uXm_xTot[t]$(tx0[t])..
      uXm[xTot,t] / uXm[xTot,t-1] =E= sum(x$(d1Xm[x,t]), uXm[x,t] * qXm[x,t-1]) / sum(x$(d1Xm[x,t-1]), uXm[x,t-1] * qXm[x,t-1]);

    # Rigidity in spill over from increased foreign activity (qXMarked) to increased demand for domestically produced exports
    E_qXTraek[t]$(tx0[t])..
      qXTraek[t] =E= qXMarked[t]**(1-rXTraeghed) * (fq * qXTraek[t-1]/fq)**rXTraeghed;

    # Scale effect: increased supply in the long run increases demand for exports.
    # We use a gradual adjustment to the 5 year mean of structural private sector net output (except in ends of sample where sqBVT.l[spTot,t]=0)
    E_qXSkala[t]$(tx0[t])..
      qXSkala[t] =E= @mean(tt$[t.val-5 < tt.val and tt.val <= t.val and sqBVT.l[spTot,tt] > 0], sqBVT[spTot,tt]) * (1-rXSkalaTraeghed)
                   + qXSkala[t-1] * rXSkalaTraeghed;

    # ------------------------------------------------------------------------------------------------------------------
    # Composition effects are calculated by aggregating the disaggregate version with chain indices
    # ------------------------------------------------------------------------------------------------------------------
    E_fXy[t]$(tx0[t])..
      pXy[xTot,t-1] * qXy[xTot,t] =E= sum(x, pXy[x,t-1] * qXy[x,t]);

    E_fXm[t]$(tx0[t])..
      pXm[xTot,t-1] * qXm[xTot,t] =E= sum(x$(d1Xm[x,t]), pXm[x,t-1] * qXm[x,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Disaggregate version
    # ------------------------------------------------------------------------------------------------------------------
    # We model domestically produced exports and imports-to-exports separately.
    # There is no substitution between the two.
    E_qXy[x,t]$(tx0[t])..
      qXy[x,t] =E= uXy[x,t] * qXTraek[t] * qXSkala[t] * rpXy2pXUdl[x,t]**(-eXUdl[x]);

    E_qXm[x,t]$(tx0[t] and d1Xm[x,t])..
      qXm[x,t] =E= uXm[x,t] * qXTraek[t] * qXSkala[t] * rpXm2pM[x,t]**(-eXUdl[x]);

    # Domestic production and imports to exports are aggregated in a Laspeyres index 
    E_qX[x,t]$(tx0[t])..
      qX[x,t] * pX[x,t-1]/fp =E= qXy[x,t] * pXy[x,t-1]/fp + qXm[x,t] * pXm[x,t-1]/fp;

    # Rigidity in relative price effect on foreign demand
    E_rpXy2pXUdl[x,t]$(tx0E[t] and not xSoe[x])..
      rpXy2pXUdl[x,t] =E= pXy[x,t] / pXUdl[x,t]
                        - dpXyTraeghed[x,t]
                        + dpXyTraeghed[x,t+1] * qXy[x,t+1]*fq / qXy[x,t] * pXUdl[x,t+1]*fp / pXUdl[x,t]
                        / (1 + rOmv['UdlAktier',t+1] + rRente['UdlAktier',t+1]);

    E_dpXyTraeghed[x,t]$(tx0[t] and not xSoe[x])..
      dpXyTraeghed[x,t] =E= upXyTraeghed * rpXy2pXUdl[x,t] * (rpXy2pXUdl[x,t] / rpXy2pXUdl[x,t-1] - cpXyTraeghed[x,t])
                                                           * (rpXy2pXUdl[x,t] / rpXy2pXUdl[x,t-1]);

    E_rpXy2pXUdl_tEnd[x,t]$(tEnd[t] and not xSoe[x])..
      rpXy2pXUdl[x,t] =E= pXy[x,t] / pXUdl[x,t];

    # The price ratio for imports-to-exports only varies due to tariffs
    E_rpXm2pM[x,t]$(tx0[t] and d1Xm[x,t])..
      rpXm2pM[x,t] =E= pXm[x,t] / sum(s$(d1IOm[x,s,t]), uIOXm[x,s,t] * pM[s,t]);

    # Tourist consumption in Denmark is split into different consumption groups. We currently do not model any substitution.
    E_qCTurist[c,t]$(tx0[t] and d1CTurist[c,t])..
      qCTurist[c,t] =E= uCturisme[c,t] * qXy['xTur',t];

    E_uCturisme[c,t]$(tx0[t] and d1CTurist[c,t])..
      uCturisme[c,t] =E= fuCturisme[t] * uCturisme0[c,t] / sum(cc, uCturisme0[cc,t]);
  $ENDBLOCK

  # Equations that do not need to be solved together with the full model and can instead be solved afterwards.
  MODEL M_exports_post /
    E_qXy_xTot
    E_qXm_xTot
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
    qX, qXy$(x[x_]), qXm$(x[x_]), qCTurist, qXMarked
  ;
  @load(G_exports_makrobk, "..\Data\makrobk\makrobk.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_exports_data
    G_exports_makrobk
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  rXTraeghed.l = 0.353809; # Matching parameter
  
  # Trunkeret til 5, baseret på Kronborg, A., Poulsen, K., & Kastrup, C. (2020). Estimering af udenrigshandelselasticiteter i MAKRO
  eXUdl.l[x] = 5;
  #  eXUdl.l['xEne'] = 5.6; # Eksport af energi er eksogent
  rXSkalaTraeghed.l = 0.5;
  upXyTraeghed.l = 15.0; # Matching parameter

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

    uXy, -qXy$(x[x_])
    uXm, -qXm$(x[x_])
    uCturisme0$(d1CTurist[c,t]), -qCTurist
    fuCturisme # E_fuCturisme

    cpXyTraeghed # E_cpXyTraeghed
  ;
  $GROUP G_exports_static_calibration G_exports_static_calibration$(tx0[t])
    qXSkala$(t0[t]) # E_qXSkala_t0
    qXTraek$(t0[t]) # E_qXTraek_t0
    rpXy2pXUdl$(t0[t]) # E_rpXy2pXUdl_t0
    rpXm2pM$(t0[t] and d1Xm[x,t]) # E_rpXm2pM_t0
    fXyPriser$(t0[t]) # E_fXyPriser_t0
    fXmPriser$(t0[t]) # E_fXmPriser_t0
    uXy$(t0[t] and xTot[x_]) # E_uXy_xTot_t0
    uXm$(t0[t] and xTot[x_]) # E_uXm_xTot_t0
    uXy$(t0[t]) # E_qXy_t0
    uXm$(t0[t] and d1Xm[x_,t]) # E_qXm_t0
  ;

  $BLOCK B_exports_static_calibration
    E_fuCturisme[t]$(tx0[t]).. sum(c, uCturisme0[c,t]) =E= 1;
    E_cpXyTraeghed[x,t]$(tx0[t])..
      cpXyTraeghed[x,t] =E= rpXy2pXUdl[x,t] / rpXy2pXUdl[x,t-1];

    E_qXSkala_t0[t]$(t0[t]).. qXSkala[t] =E= qXSkala[t+1]*fq / fq;
    E_qXTraek_t0[t]$(t0[t]).. qXTraek[t] =E= qXTraek[t+1]*fq / fq;

    E_rpXy2pXUdl_t0[x,t]$(t0[t]).. rpXy2pXUdl[x,t] =E= pXy[x,t] / pXUdl[x,t];

    E_rpXm2pM_t0[x,t]$(t0[t] and d1Xm[x,t+1])..
      rpXm2pM[x,t] =E= pXm[x,t] / sum(s$(d1IOm[x,s,t+1]), uIOXm[x,s,t+1] * pM[s,t]);

    E_uXy_xTot_t0[t]$(tx0[t] and tBase[t]).. uXy[xTot,t] * qXy[xTot,t] =E= sum(x, uXy[x,t] * qXy[x,t]);
    E_uXm_xTot_t0[t]$(tx0[t] and tBase[t]).. uXm[xTot,t] * qXm[xTot,t] =E= sum(x$(d1Xm[x,t]), uXm[x,t] * qXm[x,t]);
    E_fXyPriser_t0[t]$(tx0[t] and tBase[t])..
      fXyPriser[t] * qXy[xTot,t] =E= sum(x, rpXy2pXUdl[x,t]**(-eXUdl[x]) * qXy[x,t]);
    E_fXmPriser_t0[t]$(tx0[t] and tBase[t])..
      fXmPriser[t] * qXm[xTot,t] =E= sum(x$(d1Xm[x,t]), rpXm2pM[x,t]**(-eXUdl[x]) * qXm[x,t]); 
    @copy_equation_to_period(E_qXy, t0)
    @copy_equation_to_period(E_qXm, t0)
  $ENDBLOCK
  MODEL M_exports_static_calibration /
    B_exports - M_exports_post
    B_exports_static_calibration
  /;
$ENDIF

# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_exports_deep
    G_exports_endo
    uXm$(t1[t]), -qXm$(t1[t] and x[x_])
    uXy$(t1[t]), -qXy$(t1[t] and x[x_])
    uXy$(tx1[t]) # E_uXy_forecast
    cpXyTraeghed # E_cpXyTraeghed
  ;
  $GROUP G_exports_deep G_exports_deep$(tx0[t]);

  $BLOCK B_exports_deep
    E_uXy_deep_forecast[x,t]$(tx1[t] and not xEne[x]).. uXy[x,t] =E= uXy_ARIMA[x,t] * uXy[x,t1] / uXy_ARIMA[x,t1];
  $ENDBLOCK

  MODEL M_exports_deep /
    B_exports - M_exports_post
    B_exports_deep
    E_cpXyTraeghed
  /;
$ENDIF

# ======================================================================================================================
# Simple dynamic calibration
# ======================================================================================================================
$IF %stage% == "simple_dynamic_calibration":
  $GROUP G_exports_dynamic_calibration
    G_exports_endo
    uXy$(t1[t]), -qXy$(x[x_] and t1[t])
    uXm$(t1[t]), -qXm$(x[x_] and t1[t])
    uXy$(tx1[t] and d1Xy[x_,t] and not xEne[x_]) # E_uXy_forecast1, E_uXy_forecast2, E_uXy_xSoe_forecast
  ;
  $BLOCK B_exports_dynamic_calibration
    # Vi styrer eksporten direkte de første år
    E_uXy_forecast1[x,t]$(tx1[t] and not xEne[x] and not xSoe[x] and dt[t] <= 5)..
      qXy[x,t] =E= qXy_baseline[x,t] + aftrapprofil[t] * (qXy[x,t1] - qXy_baseline[x,t1]);
    E_uXy_forecast2[x,t]$(tx1[t] and not xEne[x] and not xSoe[x] and dt[t] > 5)..
      uXy[x,t] =E= uXy_baseline[x,t] + aftrapprofil[t-5] * (uXy[x,t-1]-uXy_baseline[x,t-1]);

    E_uXy_xSoe_forecast[x,t]$(tx1[t] and xSoe[x])..
      qXy[x,t] =E= qXy_baseline[x,t] + aftrapprofil[t] * (qXy[x,t1] - qXy_baseline[x,t1]);
  $ENDBLOCK
  MODEL M_exports_dynamic_calibration /
    B_exports - M_exports_post
    B_exports_dynamic_calibration
  /;
$ENDIF