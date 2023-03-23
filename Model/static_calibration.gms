# ======================================================================================================================
# Static calibration
# ======================================================================================================================
# Parameters are calibrated using historical data.
# We forecast these by fitting ARIMAs to the calibrated parameters. 

# Save snapshot of all data, to check that all data is intact after calibration.
set_time_periods(%cal_start%-1, %cal_deep%);

# ----------------------------------------------------------------------------------------------------------------------
# Import the static calibration models from the modules and combine them
# ----------------------------------------------------------------------------------------------------------------------
@import_from_modules("static_calibration")

MODEL M_static_calibration /
  M_aggregates_static_calibration
  M_consumers_static_calibration
  M_exports_static_calibration
  M_finance_static_calibration
  M_government_static_calibration
  M_GovExpenses_static_calibration
  M_GovRevenues_static_calibration
  M_HhIncome_static_calibration
  M_IO_static_calibration
  M_labor_market_static_calibration
  M_pricing_static_calibration
  M_production_private_static_calibration
  M_production_public_static_calibration
  M_struk_static_calibration
  M_taxes_static_calibration
/;
$GROUP G_static_calibration
  G_aggregates_static_calibration
  G_consumers_static_calibration
  G_exports_static_calibration
  G_finance_static_calibration
  G_government_static_calibration
  G_GovExpenses_static_calibration
  G_GovRevenues_static_calibration
  G_HhIncome_static_calibration  
  G_IO_static_calibration
  G_labor_market_static_calibration
  G_pricing_static_calibration
  G_production_private_static_calibration
  G_production_public_static_calibration
  G_struk_static_calibration
  G_taxes_static_calibration
;
$GROUP G_ARIMA_forecast
  G_consumers_ARIMA_forecast
  G_exports_ARIMA_forecast
  G_finance_ARIMA_forecast
  G_government_ARIMA_forecast
  G_GovExpenses_ARIMA_forecast
  G_GovRevenues_ARIMA_forecast
  #  G_HHincome_ARIMA_forecast  
  G_IO_ARIMA_forecast
  G_labor_market_ARIMA_forecast
  G_pricing_ARIMA_forecast
  G_production_private_ARIMA_forecast
  G_production_public_ARIMA_forecast
  G_taxes_ARIMA_forecast
;

# ----------------------------------------------------------------------------------------------------------------------
# Add any new variables that do not exist in the previous solution GDX file
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_do_not_load
  empty_group_dummy
;
# Use obsolete variables to give good starting values for newly defined variables
$FOR {old}, {new} in [
  #  ("Old name",              "New name"),
]:
  execute_load "Gdx\previous_static_calibration.gdx" {new}.l={old}.l;
$ENDFOR

# ----------------------------------------------------------------------------------------------------------------------
# Calibrate parameters where we have many years of data to use in forecasting parameters
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_load G_static_calibration, -G_do_not_load; 
@load_nonzero(G_load, "Gdx\previous_static_calibration.gdx"); # load previous solution

# ======================================================================================================================
# Homotopy continuation
# Solve model by gradually adjusting exogenous variables from previous solution
# ======================================================================================================================
$IF %static_homotopy% == 1:
  $GROUP G_load All, -G_static_calibration, -G_do_not_load; # if statement
  @save(G_load)
  $FOR {share_of_previous} in [
      1, 0.8, 0.6, 0.4, 0.2
  ]:
    @load_linear_combination(G_load, {share_of_previous}, "Gdx\previous_static_calibration.gdx")
    $FIX All; $UNFIX G_static_calibration;
    @print("---------------------------------------- Share = {share_of_previous} ----------------------------------------")
    @robust_solve(M_static_calibration); 
    @unload(Gdx\static_calibration_{share_of_previous}.gdx)
    @reset(G_load);
  $ENDFOR
$ENDIF

$FIX ALL; $UNFIX G_static_calibration;
#  @robust_solve(M_static_calibration);
@unload_all(Gdx\static_calibration_presolve);
@solve(M_static_calibration);

$FIX All; $UNFIX G_post;
@solve(M_post);

# ----------------------------------------------------------------------------------------------------------------------
# Output
# ----------------------------------------------------------------------------------------------------------------------
# Write GDX file
@unload_all(Gdx\static_calibration);

# ----------------------------------------------------------------------------------------------------------------------
# Tests
# ----------------------------------------------------------------------------------------------------------------------
$IF %run_tests%:
  # Abort if any data covered variables have been changed by the calibration
  @assert_no_difference_from(G_data, 0.05, _data, "G_imprecise_data was changed by static calibration.");
  $GROUP G_precise_data G_data, -G_imprecise_data;
  @assert_no_difference_from(G_precise_data, 1e-6, _data, "G_precise_data was changed by static calibration.");

  # Display variables that have become 0 in current data eg static calibration, but was not 0 in previous data eg static calibration
  #          and variables that is not 0 in current data eg static calibration, but was 0 in previous data eg static calibration
  $GROUP G_zeros G_data, -G_do_not_load; 
  @display_zeros(G_zeros, "Gdx\previous_static_calibration.gdx")

  # Aggregation tests
  $IMPORT Tests/test_other_aggregation.gms;
  $IMPORT Tests/test_other.gms;
  set_time_periods(2015, %cal_deep%);
  $IMPORT Tests/test_age_aggregation.gms;
  set_time_periods(%cal_start%-1, %cal_deep%);

  # Tjekker om noget har ændret sig - kræver at tidligere static_calibration gemt som previous_...
  #  $GROUP G_all All;
  #  @load_nonzero(G_all, "Gdx\previous_static_calibration.gdx");
  #  @save(G_all)  # Save snapshot of all data, to check that all data is intact after calibration.
  #  @load_nonzero(G_all, "Gdx\static_calibration.gdx");
  #  @assert_no_difference(G_all, 1e-6);
$ENDIF

# ======================================================================================================================
# Unload information needed for ARIMA forecasts
# ======================================================================================================================
set no_drift_allowed /
  $LOOP G_taxes_ARIMA_forecast:
    {name}
  $ENDLOOP
  rOffFraHh2BNP
  rSubEU2BNP
  rAfskr
  rvRealKred2K
  rKLeje2Bolig
  rOffTilHhOev2BNP
  rRenteSpaend
  rOffTilHhTillaeg2BNP
  rOffTilUdlBNI2BNP
  rBidragsSats
  rBilAfskr
/;

set zero_to_one "Variables bound between zero and one" /
  empty_group_dummy
/;
set q0 "Variables restricted to non-MA processes" /
  srMarkup
/;
set d0 "Variables restricted to ARMA-processes" /set.q0/;

# ----------------------------------------------------------------------------------------------------------------------
# Remove aggregate trend from variables prior fitting ARIMAs - added back in exogenous_forecasts.gms
# ----------------------------------------------------------------------------------------------------------------------
uXy.l[x,t]$(tx0[t]) = uXy.l[x,t] / uXy.l[xTot,t];
uXm.l[x,t]$(tx0[t]) = uXm.l[x,t] / uXm.l[xTot,t];

rAfskr.l[k,s,t]$(tx0[t]) = rAfskr.l[k,s,t] / rAfskr.l[k,sTot,t];
uK.l[k,sp,t]$(tx0[t]) = uK.l[k,sp,t] / uK.l[k,spTot,t];
uL.l[sp,t]$(tx0[t]) = uL.l[sp,t] / uL.l[spTot,t];
uKL.l[sp,t]$(tx0[t]) = uKL.l[sp,t] / uKL.l[spTot,t];
uKLB.l[sp,t]$(tx0[t]) = uKLB.l[sp,t] / uKLB.l[spTot,t];
uR.l[sp,t]$(tx0[t]) = uR.l[sp,t] / uR.l[spTot,t];
# ----------------------------------------------------------------------------------------------------------------------

scalars ARIMA_start, ARIMA_end, terminal_year;
ARIMA_start = %cal_start%;
ARIMA_end = %cal_deep%;
terminal_year = %terminal_year%;

$GROUP G_not_ARIMA_forecast All, -G_ARIMA_forecast$(tx0[t]);
@save(G_not_ARIMA_forecast)
$FIX(0) G_not_ARIMA_forecast;
execute_unloaddi "Gdx\ARIMA_forecast_input"
 $LOOP G_ARIMA_forecast: ,{name} $ENDLOOP
 ARIMA_start,
 ARIMA_end,
 terminal_year,
 no_drift_allowed
 zero_to_one,
 q0, d0
;
@reset(G_not_ARIMA_forecast)
