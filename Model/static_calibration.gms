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
  G_HHincome_ARIMA_forecast  
  G_IO_ARIMA_forecast
  G_labor_market_ARIMA_forecast
  G_pricing_ARIMA_forecast
  G_production_private_ARIMA_forecast
  G_production_public_ARIMA_forecast
  G_taxes_ARIMA_forecast
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
$FOR {new}, {old} in [
  #  ("New name",              "Old name"),
]:
  execute_load "Gdx/previous_static_calibration.gdx" {new}.l={old}.l;
$ENDFOR

# ----------------------------------------------------------------------------------------------------------------------
# Define group of endogenous residuals needed to test data
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_static_exo All, -G_static_calibration;
$GROUP G_unfixed_data 
  G_data
  -G_static_exo
  -G_constants
  # Undtagelser:

  # Variable hvor aggregat er endogent, men ikke databelagt, mens komponenter er databelagt men eksogene
  -srSeparation
  -tAUB, -tVirkAM

  # Variable som ikke korrekt matches til ligninger
  -fpI_s
  -snSoc['boern',t]

  # Skal tjekkes / rettes
  -pI_s, -qI_s, -vI_s # Planlægges omdøbt til pI, qI, og vI i senere modelversion

  # Giver fejl i nul-stød !!!
  -qY[tje,t]
;
$GROUP G_unfixed_precise_data G_unfixed_data, -G_imprecise_data;
$GROUP G_unfixed_imprecise_data G_unfixed_data, -G_precise_data;

$GROUP G_unfixed_precise_data_residuals
  $LOOP G_unfixed_precise_data:
    res_{name}{sets}${conditions}
  $ENDLOOP
;
$GROUP G_unfixed_imprecise_data_residuals
  $LOOP G_unfixed_imprecise_data:
    res_{name}{sets}${conditions}
  $ENDLOOP
;
$GROUP G_data_residuals G_unfixed_precise_data_residuals, G_unfixed_imprecise_data_residuals;

# Add residuals to static calibration group and remove previously unfixed data
$GROUP G_static_calibration G_static_calibration, -G_unfixed_data, G_data_residuals;

# ----------------------------------------------------------------------------------------------------------------------
# Calibrate parameters where we have many years of data to use in forecasting parameters
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_load G_static_calibration, -G_data, -G_do_not_load; 
@load(G_load, "Gdx/previous_static_calibration.gdx"); # load previous solution

# $IF %run_tests%:
#   # Small pertubation of all endogenous variables
#   # any variable not actually changed from this starting value after solving the model does not actually exist and should be removed from the database
#   $LOOP G_load:
#     {name}.l{sets}$({conditions}) = {name}.l{sets} * (1+1e-9);
#   $ENDLOOP
#   @set(G_load, _presolve, .l);
# $ENDIF

$IF %calibration_steps% > 1:
  $GROUP G_homotopy All, -G_static_calibration, -G_do_not_load;
  @set(G_homotopy, _new_data, .l) # Save all values prior to trouble-shooting
  @set(G_homotopy, _previous_combination, .l);
  @load_as(G_homotopy, "Gdx/previous_static_calibration.gdx", _previous_solution);
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
    @unload(Gdx/static_calibration_{share_of_previous}.gdx)
    @set(G_homotopy, _previous_combination, .l);
  $ENDFOR
  # Reset exogenous values
  @set(G_homotopy, .l, _new_data);
$ENDIF
# Sæt substitutionselasticiteter til 1 for at gøre løsning lettere
# eKELBR.l[sp] = 1;
# eKELB.l[sp] = 1;
# eKEL.l[sp] = 1;
# eKE.l[sp] = 1;

$FIX ALL; $UNFIX G_static_calibration;
# $GROUP G_set_initial_levels_to_nonzero G_IO_static_calibration, -G_data, -jfpIOm_s, -jfpIOy_s;
# @set_initial_levels_to_nonzero(G_set_initial_levels_to_nonzero);
# @set_bounds();
@unload_all(Gdx/static_calibration_presolve);
@solve(M_static_calibration);

# ----------------------------------------------------------------------------------------------------------------------
# Output
# ----------------------------------------------------------------------------------------------------------------------
# $IF %run_tests%:
#   # Remove "endogenous" variables not changed by solving the model
#   $LOOP G_load:
#     {name}.l{sets}$({conditions} and {name}.l{sets} = {name}_presolve{sets}) = 0;
#   $ENDLOOP
# $ENDIF

# Write GDX file
$UNFIX All; # Greatly reduces size of the GDX file
@unload_all(Gdx/static_calibration);

# ----------------------------------------------------------------------------------------------------------------------
# Print significant residuals
# ----------------------------------------------------------------------------------------------------------------------
@set(G_data_residuals, _saved, .l);
scalar residual_abs_threshold "Absolute threshold for residuals" /1e-6/;
scalar residual_rel_threshold "Relative threshold for residuals" /1e-6/;
$LOOP G_unfixed_precise_data:
  res_{name}.l{sets}$(
        {conditions}
    and abs(res_{name}.l{sets}) < residual_abs_threshold
    and (
          abs({name}.l{sets}) < residual_rel_threshold * residual_abs_threshold
      or (abs(res_{name}.l{sets} / {name}.l{sets}) < residual_rel_threshold)$({name}.l{sets} <> 0)
    )
  ) = 0;
$ENDLOOP
scalar residual_abs_threshold "Absolute threshold for residuals" /0.05/;
scalar residual_rel_threshold "Relative threshold for residuals" /0.05/;
$LOOP G_unfixed_imprecise_data:
  res_{name}.l{sets}$(
        {conditions}
    and abs(res_{name}.l{sets}) < residual_abs_threshold
    and (
          abs({name}.l{sets}) < residual_rel_threshold * residual_abs_threshold
      or (abs(res_{name}.l{sets} / {name}.l{sets}) < residual_rel_threshold)$({name}.l{sets} <> 0)
    )
  ) = 0;
$ENDLOOP
$display G_data_residuals;
@set(G_data_residuals, .l, _saved); # Reset residuals

# ----------------------------------------------------------------------------------------------------------------------
# Tests
# ----------------------------------------------------------------------------------------------------------------------
$IF %run_tests%:
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

  # ----------------------------------------------------------------------------------------------------------------------
  # Check if data residuals have changed
  # ----------------------------------------------------------------------------------------------------------------------
  $GROUP G_test_residuals G_data_residuals;
  @load_as(G_test_residuals, "Gdx/previous_static_calibration.gdx", _previous_solution);
  @assert_abs_smaller(G_test_residuals, 1e-6, .l, _previous_solution, "Data residuals have increased from previous_static_calibration.gdx.");
  
  # Tjekker om noget har ændret sig - kræver at tidligere static_calibration gemt som previous_...
  #  $GROUP G_all All;
  #  @load_nonzero(G_all, "Gdx/previous_static_calibration.gdx");
  #  @set(G_all, _saved, .l)  # Save snapshot of all data, to check that all data is intact after calibration.
  #  @load_nonzero(G_all, "Gdx/static_calibration.gdx");
  #  @assert_no_difference(G_all, 1e-6, .l, _saved, "Variable afviger fra previous_static_calibration");
$ENDIF
