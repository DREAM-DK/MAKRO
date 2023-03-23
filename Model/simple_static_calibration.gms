# ======================================================================================================================
# Simple static calibration
# ======================================================================================================================
# Set time periode to include %cal_simple%
set_time_periods(%cal_start%-1, %cal_simple%);

# ----------------------------------------------------------------------------------------------------------------------
# Import the static calibration models from the modules and combine them
# ----------------------------------------------------------------------------------------------------------------------
MODEL M_simple_static_calibration /
  M_aggregates_static_calibration
  M_exports_static_calibration
  M_finance_static_calibration
  M_government_static_calibration
  M_IO_static_calibration
  M_pricing_static_calibration
  M_production_private_static_calibration
  M_production_public_static_calibration
  M_taxes_static_calibration

  M_consumers_simple_static_calibration
  M_GovExpenses_simple_static_calibration
  M_GovRevenues_simple_static_calibration
  M_HhIncome_simple_static_calibration
  M_labor_market_simple_static_calibration
  M_struk_simple_static_calibration
/;
$GROUP G_simple_static_calibration
  G_aggregates_static_calibration
  G_exports_static_calibration
  G_finance_static_calibration
  G_government_static_calibration
  G_IO_static_calibration
  G_pricing_static_calibration
  G_production_private_static_calibration
  G_production_public_static_calibration
  G_taxes_static_calibration

  G_consumers_simple_static_calibration
  G_GovExpenses_simple_static_calibration
  G_GovRevenues_simple_static_calibration
  G_HhIncome_simple_static_calibration 
  G_labor_market_simple_static_calibration
  G_struk_simple_static_calibration
;

# Load data values for data covered years - necessary if run after a dynamic calibration
@load_dummies(tx0, "Gdx\data.gdx")
$GROUP G_load G_data;
@load(G_load, "Gdx\data.gdx")

# Load better start values for endogenous variables
$GROUP G_load
  G_simple_static_calibration
  # Nogle størrelser bestemmes af endogent af aldersdata - kan ikke identificeres og indlæses her uændret fra sidst
  fvtDoedsbo
  ftAktie
;
$GROUP G_load G_load$(tx0[t]);
@load(G_load, "Gdx\%last_calibration%.gdx")

@unload_all(Gdx\simple_static_calibration_presolve);

# ======================================================================================================================
# Solve the model with partially new exogenous variables - stepwise towards new exogenous
# ======================================================================================================================
$GROUP G_reset_load All, -G_constants, -G_load;
@save(G_reset_load)
$IF %simple_static_calibration_stepwise%:
  $FOR {share_of_previous} in [
    0.8, 0.6, 0.4, 0.2
  ]:
    @load_linear_combination(G_reset_load, {share_of_previous}, "Gdx\%last_calibration%.gdx")
    $FIX All; $UNFIX G_simple_static_calibration;
    @print("---------------------------------------- Share = {share_of_previous} ----------------------------------------")
    @robust_solve(M_simple_static_calibration); 
    @reset(G_reset_load);
  $ENDFOR
$ENDIF

# ======================================================================================================================
# Solve the model
# ======================================================================================================================
$FIX All; $UNFIX G_simple_static_calibration;
@robust_solve(M_simple_static_calibration);

# ======================================================================================================================
# Solve post model containing ouput only variables
# ======================================================================================================================
$FIX All; $UNFIX G_post;
@solve(M_post);

# ======================================================================================================================
# Output
# ======================================================================================================================
@unload(Gdx\simple_static_calibration)

# ======================================================================================================================
# Tests
# ======================================================================================================================
$IF %run_tests%:
  $GROUP G_data_test G_data$(t.val >= 2001);

  # Data check  -  Abort if any data covered variables have been changed by the calibration
  @assert_no_difference_from(G_data_test, 0.05, _data, "G_imprecise_data was changed by simple static calibration.");
  $GROUP G_precise_data_test G_data_test, -G_imprecise_data;
  @assert_no_difference_from(G_precise_data_test, 1e-6, _data, "G_precise_data was changed by simple static calibration.");

  # Tests
  $IMPORT tests\test_other_aggregation.gms;
  $IMPORT tests\test_other.gms;
$ENDIF