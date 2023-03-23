# ======================================================================================================================
# Deep dynamic calibration
# ======================================================================================================================
# This file controls the deep dynamic calibration of the model.
# We calibrate parameters whose value depends on expectations about the future. I.e. parameters calibrated from an equation that includes a lead.

# ----------------------------------------------------------------------------------------------------------------------
# Set time periods
# ----------------------------------------------------------------------------------------------------------------------
set_time_periods(%cal_deep%-1, %terminal_year%);
set_data_periods(%cal_start%, %cal_deep%);

# ----------------------------------------------------------------------------------------------------------------------
# Import the dynamic calibration models from the modules and combine them
# ----------------------------------------------------------------------------------------------------------------------
@import_from_modules("deep_dynamic_calibration");

MODEL M_deep_dynamic_calibration /
  B_taxes

  M_aggregates_deep
  M_exports_deep
  M_IO_deep
  M_finance_deep
  M_labor_market_deep
  M_government_deep
  M_GovRevenues_deep
  M_GovExpenses_deep
  M_consumers_deep
  M_pricing_deep
  M_production_private_deep
  M_production_public_deep
  M_HHincome_deep  
  M_struk_deep
/;

$GROUP G_deep_dynamic_calibration
  G_taxes_endo

  G_aggregates_deep
  G_exports_deep
  G_IO_deep
  G_finance_deep
  G_labor_market_deep
  G_government_deep
  G_GovRevenues_deep
  G_GovExpenses_deep
  G_consumers_deep
  G_pricing_deep
  G_production_private_deep
  G_production_public_deep
  G_HHincome_deep  
  G_struk_deep
;

# ======================================================================================================================
# Load previous solution as starting level
# ======================================================================================================================
$GROUP G_load G_deep_dynamic_calibration, -G_do_not_load;
@load(G_load, "Gdx\previous_deep_calibration.gdx"); # load previous solution


# ======================================================================================================================
# Various solver strategies in case we have trouble solving the calibration model 
# ======================================================================================================================
#  # ======================================================================================================================
#  # Using simple dynamic calibration as basis
#  # ======================================================================================================================
#  # ----------------------------------------------------------------------------------------------------------------------
#  # Save value of all exogenous inputs before setting them to value from previous solution
#  # ----------------------------------------------------------------------------------------------------------------------
#  @save(All)

#  $GROUP G_load All, -G_constants, -vArvPrArving, -qY_udv_Forecast;
#  @load(G_load, "Gdx\previous_simple_dynamic_calibration.gdx")
#  @load_dummies(tx0, "Gdx\previous_simple_dynamic_calibration.gdx")

#  # ----------------------------------------------------------------------------------------------------------------------
#  # Test that everything solves before making changes - should solve immediately
#  # ----------------------------------------------------------------------------------------------------------------------
#  $FIX All; $UNFIX G_simple_dynamic_calibration;
#  @solve(M_simple_dynamic_calibration);

#  # ----------------------------------------------------------------------------------------------------------------------
#  # Replace simple dynamic calibration with deep dynamic calibration, one module at a time, if needed to solve
#  # ----------------------------------------------------------------------------------------------------------------------
#  MODEL M_labor_market_x / M_labor_market - M_labor_market_post /;
#  MODEL M_production_private_x / B_production_private - M_production_private_post /;
#  MODEL M_exports_x / B_exports - M_exports_post /;
#  MODEL M_consumers_x / M_consumers - M_consumers_post /;
#  MODEL M_GovRevenues_x / M_GovRevenues - M_GovRevenues_post /;
#  MODEL M_HHincome_x / M_HHincome - M_HHincome_post /;

#  MODEL M_cal / M_simple_dynamic_calibration /;
#  $GROUP G_cal G_simple_dynamic_calibration;
#  $SETLOCAL prev_model M_cal
#  $FOR {id}   , {old_block}                        , {new_block}                  , {old_group}                         , {new_group}                  , {solve} in [
#    #  ("ss"     , "M_struk_dynamic_calibration"             , "M_struk_deep"              , "G_struk_dynamic_calibration"              , "G_struk_deep"              , 1),
#    #  ("pro"    , "M_production_private_x"             , "M_production_private_deep" , "G_production_private_dynamic_calibration" , "G_production_private_deep" , 1),
#    #  ("lab"    , "M_labor_market_x"                   , "M_labor_market_deep"       , "G_labor_market_dynamic_calibration"       , "G_labor_market_deep"       , 1),
#    ("con"    , "M_consumers_x"                      , "M_consumers_deep"          , "G_consumers_dynamic_calibration"          , "G_consumers_deep"          , 1),
#    #  ("hh"     , "M_HHincome_x"                       , "M_HHincome_deep"           , "G_HHincome_dynamic_calibration"           , "G_HHincome_deep"           , 1),
#    #  ("x"      , "M_exports_x"                        , "M_exports_deep"            , "G_exports_dynamic_calibration"            , "G_exports_deep"            , 1),
#    #  ("pri"    , "B_pricing"                        , "M_pricing_deep"            , "G_pricing_dynamic_calibration"            , "G_pricing_deep"            , 1),
#    #  ("off"    , "M_production_public_dynamic_calibration" , "M_production_public_deep"  , "G_production_public_dynamic_calibration"  , "G_production_public_deep"  , 1),
#    #  ("g_r"    , "M_GovRevenues_x"                    , "M_GovRevenues_deep"        , "G_GovRevenues_dynamic_calibration"        , "G_GovRevenues_deep"        , 1),
#    #  ("fin"    , "B_finance"                        , "M_finance_deep"            , "G_finance_dynamic_calibration"            , "G_finance_deep"            , 1),
#  ]:
#    $SETLOCAL new_model %prev_model%_{id} # Generate new model name
#    # Replace simple dynamic calibration module with full dynamic calibration module
#    MODEL %new_model% / %prev_model% - {old_block} + {new_block} /;
#    $GROUP G_cal G_cal, -{old_group}, {new_group};

#    $IF {solve}:
#      $FIX All; $UNFIX G_cal;
#      @robust_solve(%new_model%);
#    $ENDIF

#    $SETLOCAL prev_model %new_model%
#  $ENDFOR

#  # ----------------------------------------------------------------------------------------------------------------------
#  # Reset dummies and set exogenous levels gradually to new values 
#  # ----------------------------------------------------------------------------------------------------------------------
#  @load_dummies(tx0, "Gdx\exogenous_forecast.gdx")
#  $GROUP G_reset_load G_load, -G_deep_dynamic_calibration;
#  $FOR {share} in [0.1, 0.15, 0.2, 0.3, 0.5]:  # Note that the shares are cumulative
#    @print("---------------------------------------- {share} ----------------------------------------")
#    $LOOP G_reset_load:
#      {name}.l{sets}$({conditions}) = {name}.l{sets} * (1-{share}) + {share} * {name}_saved{sets};
#    $ENDLOOP
#    $FIX All; $UNFIX G_deep_dynamic_calibration;
#    @robust_solve(M_deep_dynamic_calibration);
#  $ENDFOR

#  # ----------------------------------------------------------------------------------------------------------------------
#  # Reset all exogenous inputs
#  # ----------------------------------------------------------------------------------------------------------------------
#  @load_dummies(tx0, "Gdx\exogenous_forecast.gdx")
#  $GROUP G_load All, -G_deep_dynamic_calibration, -G_constants;
#  @reset(G_load)


# ======================================================================================================================
# Homotopy continuation
# Solve model by gradually adjusting exogenous variables from previous solution
# ======================================================================================================================
$IF %deep_homotopy% == 1:
  $GROUP G_load All, -G_deep_dynamic_calibration, -G_do_not_load;
  @save(G_load)
  $FOR {share_of_previous} in [
      1, 0.8, 0.6, 0.4, 0.2
  ]:
    @load_linear_combination(G_load, {share_of_previous}, "Gdx\previous_deep_calibration.gdx")
    $FIX All; $UNFIX G_deep_dynamic_calibration;
    @print("---------------------------------------- Share = {share_of_previous} ----------------------------------------")
    @robust_solve(M_deep_dynamic_calibration); 
    @unload(Gdx\deep_calibration_{share_of_previous}.gdx)
    @reset(G_load);
  $ENDFOR
$ENDIF

#  #  ======================================================================================================================
#  #  Solve calibration model a few years at a time
#  #  ======================================================================================================================
#  $GROUP G_deep_dynamic_calibration_x G_deep_dynamic_calibration, -G_constants;
#  $FOR {end_year} in range(2060, %terminal_year%, 15):
#    set_time_periods(%cal_deep%-1, {end_year});
#    $FIX All; $UNFIX G_deep_dynamic_calibration;
#    @print("------------------------------------------ Solve dynamic calibration until {end_year} ------------------------------------------")
#    @unload_all(Gdx\M_deep_dynamic_calibration_presolve); # Output gdx file with the state before solving to help with debugging
#    @solve(M_deep_dynamic_calibration)
#    set_time_periods(%cal_deep%-1, %terminal_year%);
#    @unload(Gdx\deep_calibration_{end_year}.gdx)
#    $EVAL penultimate {end_year}-1;
#    $LOOP G_deep_dynamic_calibration_x:
#       {name}.l{sets}$(t.val >= {end_year} and {conditions}) = {name}.l{sets}{$}[<t>'%penultimate%'];
#    $ENDLOOP
#  $ENDFOR


# ======================================================================================================================
# Solve the dynamic calibration model
# ======================================================================================================================
$FIX All; $UNFIX G_deep_dynamic_calibration;
#  @robust_solve(M_deep_dynamic_calibration);
@solve(M_deep_dynamic_calibration);


# ======================================================================================================================
# Solve post model containing ouput only variables
# ======================================================================================================================
$FIX All; $UNFIX G_post;
@solve(M_post);


# ======================================================================================================================
# Output
# ======================================================================================================================
# Write GDX file
@unload(Gdx\deep_calibration)

# ======================================================================================================================
# Tests
# ======================================================================================================================
$IF %run_tests%:
  # Aggregation tests
  $IMPORT Tests/test_other_aggregation.gms;
  $IMPORT Tests/test_other.gms;
  $IMPORT Tests/test_age_aggregation.gms;


  # ----------------------------------------------------------------------------------------------------------------------
  # Data check  -  Abort if any data covered variables have been changed by the calibration
  # ----------------------------------------------------------------------------------------------------------------------
  set_data_periods(2001, %cal_deep%);

  @assert_no_difference_from(G_data, 0.05, _data, "G_imprecise_data was changed by dynamic calibration.");
  $GROUP G_precise_data G_data, -G_imprecise_data;
  @assert_no_difference_from(G_precise_data, 1e-6, _data, "G_precise_data was changed by dynamic calibration.");
  @assert_no_difference_from(G_exogenous_forecast, 1e-6, _data, "G_exogenous_forecast was changed by dynamic calibration.");
  @assert_no_difference_from(G_forecast_as_zero, 1e-6, _data, "G_forecast_as_zero was changed by dynamic calibration.");

  # ----------------------------------------------------------------------------------------------------------------------
  # Zero shock  -  Abort if a zero shock changes any variables significantly
  # ----------------------------------------------------------------------------------------------------------------------
  $GROUP G_ZeroShockTest All, -dArv;

  @save(G_ZeroShockTest)
  set_time_periods(%cal_deep%-1, %terminal_year%);
  $FIX All; $UNFIX G_endo;
  @solve(M_base);
  $FIX All; $UNFIX G_post;
  @solve(M_post);
  @assert_no_difference(G_ZeroShockTest, 1e-6, "Zero shock changed variables significantly.");
$ENDIF