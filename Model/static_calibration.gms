# ======================================================================================================================
# Static calibration
# ======================================================================================================================
# Parameters are calibrated using historical data.

set_time_periods(%cal_start%-1, %cal_end%);

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
  -empty_group_dummy
;

$GROUP G_static_calibration_newdata
  G_aggregates_static_calibration_newdata
  G_exports_static_calibration_newdata
  G_finance_static_calibration_newdata
  G_government_static_calibration_newdata
  G_IO_static_calibration_newdata
  G_pricing_static_calibration_newdata
  G_production_private_static_calibration_newdata
  G_production_public_static_calibration_newdata
  G_taxes_static_calibration_newdata

  G_consumers_static_calibration_newdata
  G_GovExpenses_static_calibration_newdata
  G_GovRevenues_static_calibration_newdata
  G_HhIncome_static_calibration_newdata 
  G_labor_market_static_calibration_newdata
  G_struk_static_calibration_newdata
;

# ----------------------------------------------------------------------------------------------------------------------
# Add any new variables that do not exist in the previous solution GDX file
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_do_not_load
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
@load(G_load, "Gdx\previous_static_calibration.gdx"); # load previous solution

$IF %run_tests%:
  # Small pertubation of all endogenous variables
  # any variable not actually changed from this starting value after solving the model does not actually exist and should be removed from the database
  $LOOP G_static_calibration:
    {name}.l{sets}$({conditions} and {name}.l{sets} <> 0) = {name}.l{sets} + 1e-6;
  $ENDLOOP
  @set(G_static_calibration, _presolve, .l);
$ENDIF

$IF %calibration_steps% > 1:
  $GROUP G_homotopy All, -G_static_calibration, -G_do_not_load;
  @set(G_homotopy, _new_data, .l) # Save all values prior to trouble-shooting
  @set(G_homotopy, _previous_combination, .l);
  @load_as(G_homotopy, "Gdx\previous_static_calibration.gdx", _previous_solution);
  $FOR {share_of_previous} in [
    round(1 - i/%calibration_steps%, 2) for i in range(1, %calibration_steps%)
  ]:
    @set_linear_combination(G_homotopy, {share_of_previous}, _previous_solution, _new_data)
    # Any exogenous variable that gets close to zero from the linear combiation is set to the latest combination that worked
    $LOOP G_homotopy:
      {name}.l{sets}$({conditions} and abs({name}.l{sets}) < 1e-6) = {name}_previous_combination{sets};  
    $ENDLOOP
    $FIX All; $UNFIX G_static_calibration;
    @print("---------------------------------------- Share = {share_of_previous} ----------------------------------------")
    @set_bounds();
    @solve(M_static_calibration); 
    @unload(Gdx\static_calibration_{share_of_previous}.gdx)
    @set(G_homotopy, _previous_combination, .l);
  $ENDFOR
  # Reset exogenous values
  @set(G_homotopy, .l, _new_data);
$ENDIF

$FIX ALL; $UNFIX G_static_calibration;
#  @set_initial_levels_to_nonzero(All)
@set_bounds();
@unload_all(Gdx\static_calibration_presolve);
@solve(M_static_calibration);

$FIX All; $UNFIX G_post;
@solve(M_post);

# ----------------------------------------------------------------------------------------------------------------------
# Output
# ----------------------------------------------------------------------------------------------------------------------
$IF %run_tests%:
  # Remove "endogenous" variables not changed by solving the model
  $LOOP G_static_calibration:
    {name}.l{sets}$({conditions} and {name}.l{sets} = {name}_presolve{sets}) = 0;
  $ENDLOOP
$ENDIF

# Write GDX file
@unload_all(Gdx\static_calibration);

# ----------------------------------------------------------------------------------------------------------------------
# Tests
# ----------------------------------------------------------------------------------------------------------------------
$IF %run_tests%:
  $GROUP G_data_test
    G_data
    # Tests slået fra efter forlængelse af bank ultimo november 2014
    -vUdlAktRenter$(t.val = 2005 or t.val = 2007) # Inkonsistens i data fra modelgruppen i DST - mail sendt 20/11-24
  ;  
  # Abort if any data covered variables have been changed by the calibration
  @assert_no_difference(G_data_test, 0.05, .l, _data, "G_imprecise_data was changed by static calibration.");
  $GROUP G_precise_data_test G_data_test, -G_imprecise_data;
  @assert_no_difference(G_precise_data_test, 1e-6, .l, _data, "G_precise_data was changed by static calibration.");

  # Display variables that have become 0 in current data eg static calibration, but was not 0 in previous data eg static calibration
  #          and variables that is not 0 in current data eg static calibration, but was 0 in previous data eg static calibration
  $GROUP G_zeros G_data, -G_do_not_load; 
  @display_zeros(G_zeros, "Gdx\previous_static_calibration.gdx")

  # Aggregation tests
  set_time_periods(2001, %cal_end%); # !!! Betingelse skal fjernes når fejl i data er rettet !!!
  $IMPORT Tests/test_other_aggregation.gms;
  $IMPORT Tests/test_other.gms;
  set_time_periods(%AgeData_t1%, %cal_end%);
  $IMPORT Tests/test_age_aggregation.gms;
  set_time_periods(%cal_start%-1, %cal_end%);

 # ----------------------------------------------------------------------------------------------------------------------
 # Zero shock  -  Abort if a zero shock changes any variables significantly
 # ----------------------------------------------------------------------------------------------------------------------
 @set(All, _saved, .l)
 set_time_periods(%cal_start%-1, %cal_end%);
 $FIX All; $UNFIX G_static;
 @solve(M_static);
 @assert_no_difference(G_Static, 1e-6, .l, _saved, "Zero shock changed variables significantly.");

  # Tjekker om noget har ændret sig - kræver at tidligere static_calibration gemt som previous_...
  #  $GROUP G_all All;
  #  @load_nonzero(G_all, "Gdx\previous_static_calibration.gdx");
  #  @set(G_all, _saved, .l)  # Save snapshot of all data, to check that all data is intact after calibration.
  #  @load_nonzero(G_all, "Gdx\static_calibration.gdx");
  #  @assert_no_difference(G_all, 1e-6, .l, _saved, "Variable afviger fra previous_static_calibration");
$ENDIF

# ----------------------------------------------------------------------------------------------------------------------
# !!! Der er fejl i data gør 2008 som skal rettes!!!
# Indtil da nulstilles data før 2008, så at de ikke ændres af kalibrering
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_reset_data G_data$(t.val < 2001);
@set(G_reset_data, .l, _data);
