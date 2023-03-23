# ======================================================================================================================
# Simple dynamic calibration
# ======================================================================================================================
# Calibrate full model for cal_simple and forward
set_time_periods(%cal_simple%-1, %terminal_year%);

# ----------------------------------------------------------------------------------------------------------------------
# Set all levels to previous solution 
# EXCEPT data and parameters from the static calibration
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_load
  All
  -G_constants

  -G_simple_static_calibration$(t1[t])
  -G_data$(t1[t])

  # Ved ændringer i dummies kan disse være eksogene i static calibration,
  # men have en værdi i previous dynamic calibration som vi ikke ønsker at indlæse
  -uIOXm0$(t1[t])
  -uIOXy0$(t1[t])
  -uIO0$(t1[t])
  -uIOm0$(t1[t])

  # Parametre som beregnes ud fra data og er eksogene i static_calibration
  -uOvfUbeskat$(t1[t])

  # Balanceringsfaktor skal være 1 i dataår
  -fpI_s
;
# For tx1 dummies are set to match dummies from previous calibration
# NB: It is important that this step is performed prior to reading starting values
@load_dummies(tx1, "Gdx\%last_calibration%.gdx")

$GROUP G_load G_load$(tx0[t]), G_constants, -G_do_not_load;
@load(G_load, "Gdx\%last_calibration%.gdx")

# Load all previous variables as parameters with same name and suffix "_baseline"
@load_as(All, "Gdx\smooth_calibration.gdx", _baseline)

parameter aftrapprofil[t] "Profil for aftrapning af visse dynamisk kalibrerede parametre til strukturelt niveau.";
aftrapprofil[t]$(tx0[t]) = 0.8**(dt[t]**1.5);

# Stød til importandele aftrappes gradvist
uIOm0.l[dux,s,t]$(tx1[t] and not iL[dux]) = uIOm0_baseline[dux,s,t] + aftrapprofil[t] * (uIOm0.l[dux,s,t1] - uIOm0_baseline[dux,s,t1]);

# ----------------------------------------------------------------------------------------------------------------------
# Import the simple dynamic calibration models from the modules and combine them
# If M_simple_dynamic_calibration does not solve:
# Solve a model with endogenous variables closer to G_endo and save solution as previous_simple_dynamic_calibration.gdx 
# before trying to solve with more endo/exo included
# ----------------------------------------------------------------------------------------------------------------------
# Read equations
@import_from_modules("simple_dynamic_calibration");

$GROUP G_simple_dynamic_calibration
  G_production_public_dynamic_calibration
  G_struk_dynamic_calibration
  G_IO_dynamic_calibration
  G_exports_dynamic_calibration
  G_labor_market_dynamic_calibration
  G_pricing_dynamic_calibration
  G_production_private_dynamic_calibration
  G_finance_dynamic_calibration
  G_HHincome_dynamic_calibration
  G_consumers_dynamic_calibration
  G_GovRevenues_dynamic_calibration
  G_government_dynamic_calibration
  G_GovExpenses_dynamic_calibration

  G_taxes_endo
  G_aggregates_endo
;

MODEL M_simple_dynamic_calibration /
  M_production_public_dynamic_calibration
  M_struk_dynamic_calibration
  M_IO_dynamic_calibration
  M_exports_dynamic_calibration
  M_labor_market_dynamic_calibration
  M_pricing_dynamic_calibration
  M_production_private_dynamic_calibration
  M_finance_dynamic_calibration
  M_HHincome_dynamic_calibration
  M_consumers_dynamic_calibration
  M_GovRevenues_dynamic_calibration
  M_government_dynamic_calibration
  M_GovExpenses_dynamic_calibration

  B_taxes
  B_aggregates
/;

# ======================================================================================================================
# Load better start values for endogenous variables
# ======================================================================================================================
$GROUP G_load G_simple_dynamic_calibration, -G_do_not_load;
@load_nonzero(G_load, "Gdx\%last_calibration%.gdx")

@unload_all(Gdx\simple_dynamic_calibration_presolve);

# ======================================================================================================================
# Solve the model with partially new exogenous variables - stepwise towards new exogenous
# ======================================================================================================================
$IF %simple_dynamic_calibration_stepwise%:
  $GROUP G_reset_load All, -G_simple_dynamic_calibration;
  @save(G_reset_load)
  $FOR {share_of_previous} in [
    0.8, 0.6, 0.4, 0.2
  ]:
    @load_linear_combination(G_reset_load, {share_of_previous}, "Gdx\%last_calibration%.gdx")
    $FIX All; $UNFIX G_simple_dynamic_calibration;
    @print("---------------------------------------- Share = {share_of_previous} ----------------------------------------")
    @robust_solve(M_simple_dynamic_calibration); 
    @unload(Gdx\dynamic_calibration_{share_of_previous}.gdx)
    @reset(G_reset_load);
  $ENDFOR
$ENDIF

# ======================================================================================================================
# Solve the model
# ======================================================================================================================
$FIX All; $UNFIX G_simple_dynamic_calibration;
@set_bounds();
@solve(M_simple_dynamic_calibration);

# ======================================================================================================================
# Solve post model containing ouput only variables
# ======================================================================================================================
$FIX All; $UNFIX G_post;
@solve(M_post);

# Output
@unload(Gdx\simple_dynamic_calibration)
# ======================================================================================================================
# Tests
# ======================================================================================================================
$IF %run_tests%:
  # Data check  -  Abort if any data covered variables have been changed by the calibration
  $GROUP G_data_test G_data$(t.val >= 2001 and t.val <= %cal_simple%);
  @assert_no_difference_from(G_data_test, 0.05, _data, "G_imprecise_data was changed by simple dynamic calibration.");
  $GROUP G_precise_data G_data_test, -G_imprecise_data;
  @assert_no_difference_from(G_precise_data, 1e-6, _data, "G_precise_data was changed by simple dynamic calibration.");

  # Tests
  $IMPORT tests\test_age_aggregation.gms;
  $IMPORT tests\test_other_aggregation.gms;
  $IMPORT tests\test_other.gms;

  # ----------------------------------------------------------------------------------------------------------------------
  # Zero shock  -  Abort if a zero shock changes any variables significantly
  # ----------------------------------------------------------------------------------------------------------------------
  set_time_periods(%cal_simple%, %terminal_year%);
  $GROUP G_ZeroShockTest All, -dArv;
  @save(G_ZeroShockTest)
  $FIX All; $UNFIX G_endo;
  @solve(M_base);
  $FIX All; $UNFIX G_post;
  @solve(M_post);
  @assert_no_difference(G_ZeroShockTest, 1e-5, "Zero shock changed variables significantly.");
$ENDIF