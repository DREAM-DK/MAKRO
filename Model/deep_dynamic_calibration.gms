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
$GROUP G_load G_deep_dynamic_calibration, -G_data, -G_do_not_load;
@load(G_load, "Gdx\previous_deep_calibration.gdx"); # load previous solution
$GROUP G_exo All, - G_deep_dynamic_calibration;
$GROUP G_new_endogenous G_do_not_load, - G_exo;
@set_initial_levels_to_nonzero(G_new_endogenous)

# $IF %run_tests%:
#   # Small pertubation of all endogenous variables
#   # any variable not actually changed from this starting value after solving the model does not actually exist and should be removed from the database
#   $LOOP G_load:
#     {name}.l{sets}$({conditions}) = {name}.l{sets} * (1+1e-9);
#   $ENDLOOP
#   @set(G_load, _presolve, .l);
# $ENDIF

#  # ======================================================================================================================
#  # Various solver strategies in case we have trouble solving the calibration model 
#  # ======================================================================================================================
#  # ======================================================================================================================
#  # Using dynamic calibration for new data as basis
#  # ======================================================================================================================
#  # ----------------------------------------------------------------------------------------------------------------------
#  # Save value of all exogenous inputs before setting them to value from previous solution
#  # ----------------------------------------------------------------------------------------------------------------------
#  @set(All, _saved, .l)

#  # ----------------------------------------------------------------------------------------------------------------------
#  # Import calibration models for new data and test that everything solves before making changes - should solve in one step
#  # ----------------------------------------------------------------------------------------------------------------------
#  $SETLOCAL data_year %cal_deep%;
#  $SETLOCAL last_calibration previous_deep_calibration;
#  $SETGLOBAL calibration_steps 1;
#  $IMPORT static_calibration_newdata.gms;
#  $IMPORT dynamic_calibration_newdata.gms;

#  # ----------------------------------------------------------------------------------------------------------------------
#  # Replace dynamic calibration for new data with deep dynamic calibration, one module at a time, if needed to solve
#  # ----------------------------------------------------------------------------------------------------------------------
#  MODEL M_cal / M_dynamic_calibration_newdata /;
#  $GROUP G_cal G_dynamic_calibration_newdata;
#  $SETLOCAL prev_model M_cal
#  $FOR {id}   , {old_block}                                 , {new_block}                 , {old_group}                                , {new_group}                 , {solve} in [
#    ("IO"     , "M_IO_dynamic_calibration"                  , "M_IO_deep"                 , "G_IO_dynamic_calibration"                 , "G_IO_deep"                 , 1),
#    ("pri"    , "M_pricing_dynamic_calibration"             , "M_pricing_deep"            , "G_pricing_dynamic_calibration"            , "G_pricing_deep"            , 1),
#    ("con"    , "M_consumers_dynamic_calibration"           , "M_consumers_deep"          , "G_consumers_dynamic_calibration"          , "G_consumers_deep"          , 1),
#    ("ss"     , "M_struk_dynamic_calibration"               , "M_struk_deep"              , "G_struk_dynamic_calibration"              , "G_struk_deep"              , 1),
#    ("lab"    , "M_labor_market_dynamic_calibration"        , "M_labor_market_deep"       , "G_labor_market_dynamic_calibration"       , "G_labor_market_deep"       , 1),
#    ("hh"     , "M_HHincome_dynamic_calibration"            , "M_HHincome_deep"           , "G_HHincome_dynamic_calibration"           , "G_HHincome_deep"           , 1),
#    ("x"      , "M_exports_dynamic_calibration"             , "M_exports_deep"            , "G_exports_dynamic_calibration"            , "G_exports_deep"            , 1),
#    ("off"    , "M_production_public_dynamic_calibration"   , "M_production_public_deep"  , "G_production_public_dynamic_calibration"  , "G_production_public_deep"  , 1),
#    ("g_r"    , "M_GovRevenues_dynamic_calibration"         , "M_GovRevenues_deep"        , "G_GovRevenues_dynamic_calibration"        , "G_GovRevenues_deep"        , 1),
#    ("fin"    , "M_finance_dynamic_calibration"             , "M_finance_deep"            , "G_finance_dynamic_calibration"            , "G_finance_deep"            , 1),
#    ("gov"    , "M_Government_dynamic_calibration"          , "M_Government_deep"         , "G_Government_dynamic_calibration"         , "G_Government_deep"         , 1),
#    ("g_e"    , "M_GovExpenses_dynamic_calibration"         , "M_GovExpenses_deep"        , "G_GovExpenses_dynamic_calibration"        , "G_GovExpenses_deep"        , 1),
#    ("pro"    , "M_production_private_dynamic_calibration"  , "M_production_private_deep" , "G_production_private_dynamic_calibration" , "G_production_private_deep" , 1),
#  ]:
#    $SETLOCAL new_model %prev_model%_{id} # Generate new model name
#    # Replace dynamic calibration module for newdata with full dynamic calibration module
#    MODEL %new_model% / %prev_model% - {old_block} + {new_block} /;
#    $GROUP G_cal G_cal, -{old_group}, {new_group};

#    $IF {solve}:
#      $FIX All; $UNFIX G_cal;
#      @print("---------------------------------------- Solve %new_model% ----------------------------------------")
#      @set_bounds();
#      @solve(%new_model%);
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
  #  @set_initial_levels_to_nonzero(All)
  #  @unload_all(Gdx\deep_calibration_presolve); # Output gdx file with the state before solving to help with debugging
  #  @solve(M_deep_dynamic_calibration);
#  $ENDFOR

#  # ----------------------------------------------------------------------------------------------------------------------
#  # Reset all exogenous inputs
#  # ----------------------------------------------------------------------------------------------------------------------
#  @load_dummies(tx0, "Gdx\exogenous_forecast.gdx")
#  $GROUP G_load All, -G_deep_dynamic_calibration, -G_constants;
#  @set(G_load, .l, _saved)

# ======================================================================================================================
# Homotopy continuation
# Solve model by gradually adjusting exogenous variables from previous solution
# ======================================================================================================================
$IF %calibration_steps% > 1:
  @load_dummies(tx0, "Gdx\previous_deep_calibration.gdx")

  $GROUP G_homotopy All, -G_deep_dynamic_calibration, -G_do_not_load, G_ARIMA_forecast;
  @set(G_homotopy, _new_data, .l) # Save all values prior to trouble-shooting
  @set(G_ARIMA_forecast, .l, _ARIMA) # Reset ARIMA variables in case start values were loaded from previous solution
  @set(G_homotopy, _previous_combination, .l);
  @load_as(G_homotopy, "Gdx\previous_deep_calibration.gdx", _previous_solution);
  @set_initial_levels_to_nonzero(G_deep_dynamic_calibration)
  $FOR {share_of_previous} in [0.99]+[
    round(1 - i/%calibration_steps%, 2) for i in range(1, %calibration_steps%)
  ]:
    @set_linear_combination(G_homotopy, {share_of_previous}, _previous_solution, _new_data)
    # Any exogenous variable that gets close to zero from the linear combiation is set to the latest combination that worked
    $LOOP G_homotopy:
      {name}.l{sets}$({conditions} and abs({name}.l{sets}) < 1e-6) = {name}_previous_combination{sets};  
    $ENDLOOP
    @set(G_ARIMA_forecast, _ARIMA, .l)
    $FIX All; $UNFIX G_deep_dynamic_calibration;
    @print("---------------------------------------- Share = {share_of_previous} ----------------------------------------")
    @set_bounds();
    @unload_all(Gdx\deep_calibration_presolve); # Output gdx file with the state before solving to help with debugging
    @solve(M_deep_dynamic_calibration); 
    @unload(Gdx\deep_calibration_{share_of_previous}.gdx)
    @set(G_homotopy, _previous_combination, .l);
  $ENDFOR

  # Reset exogenous values
  @set(G_homotopy, .l, _new_data);
  @set(G_ARIMA_forecast, _ARIMA, .l)

  @load_dummies(tx0, "Gdx\exogenous_forecast.gdx")
  $FIX All; $UNFIX G_deep_dynamic_calibration;
  @set_initial_levels_to_nonzero(G_deep_dynamic_calibration)
  @unload_all(Gdx\deep_calibration_presolve); # Output gdx file with the state before solving to help with debugging
  @solve(M_deep_dynamic_calibration);
$ENDIF

#  ======================================================================================================================
#  Solve calibration model a few years at a time
#  ======================================================================================================================
$IF %previous_terminal_year% < %terminal_year%:
  $FOR {end_year} in range(%previous_terminal_year%, %terminal_year%, 10):
    set_time_periods(%cal_deep%-1, {end_year});
    $FIX All; $UNFIX G_deep_dynamic_calibration;
    @print("------------------------------------------ Solve dynamic calibration until {end_year} ------------------------------------------")
    @unload_all(Gdx\deep_calibration_presolve); # Output gdx file with the state before solving to help with debugging
    @set_bounds();
    @solve(M_deep_dynamic_calibration)
    set_time_periods(%cal_deep%-1, %terminal_year%);
    @unload(Gdx\deep_calibration_{end_year}.gdx)
    $GROUP G_starting_values_from_previous_years G_deep_dynamic_calibration$(t.val >= {end_year}), -G_constants;
    $EVAL penultimate {end_year}-1;
    $LOOP G_starting_values_from_previous_years:
      {name}.l{sets}$({conditions}) = {name}.l{sets}{$}[<t>'%penultimate%'];
    $ENDLOOP
    $GROUP G_exo All, -G_deep_dynamic_calibration;
    $GROUP G_LM_nonzero # For at undgå divider med 0, fx ved stigning i tilbagetrækningsalder
      uH[a,t]$(aVal[a] > 60), uDeltag[a,t]$(aVal[a] > 60), rSoegBaseHh[a,t]$(aVal[a] > 60), srSoegBaseHh[a,t]$(aVal[a] > 60)
      -G_exo
    ;
    @set_initial_levels_to_nonzero(G_LM_nonzero)
  $ENDFOR
$ENDIF

# ======================================================================================================================
# Solve the dynamic calibration model
# ======================================================================================================================
$IF %run_tests%:
  @unload_all(Gdx\deep_calibration_presolve); # Output gdx file with the state before solving to help with debugging
$ENDIF
$FIX All; $UNFIX G_deep_dynamic_calibration;
# @set_initial_levels_to_nonzero(G_deep_dynamic_calibration)
@set_bounds();
@solve(M_deep_dynamic_calibration);

# ======================================================================================================================
# Output
# ======================================================================================================================
# $IF %run_tests%:
#   # Remove "endogenous" variables not changed by solving the model
#   $LOOP G_load:
#     {name}.l{sets}$({conditions} and {name}.l{sets} = {name}_presolve{sets}) = 0;
#   $ENDLOOP
# $ENDIF

# Write GDX file
$UNFIX All; # Greatly reduces size of the GDX file
@unload(Gdx\deep_calibration)

# ----------------------------------------------------------------------------------------------------------------------
# Output til Gekko
# ----------------------------------------------------------------------------------------------------------------------
# M_post kan ikke køre med, da det så ikke bliver square
#  MODEL M_TilGekko /
#    M_base
#  /;
#  $FIX All; $UNFIX G_endo;
#  option mcp=convert;
#  solve M_base using mcp;

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
  $GROUP G_data_test
    G_data
    # 2014 er slået midlertidigt fra pga. inkonsistens mellem pensionsdata og finansielle konti
    # 2015 og 2016 slået fra pga. databrud i finansielle konti
    # Begge ting burde blive korrigeret ved udgivelse af nyt NR 28/6-2024
    -vUdlNet$(t.val = 2014 or t.val = 2015)
    -vUdlAkt$(Bank[portf_] and (t.val = 2014 or t.val = 2015))
    -vUdlOmv$(t.val = 2016)
    # Tests slået fra efter forlængelse af bank ultimo november 2014
    -vUdlAktRenter$(t.val = 2005 or t.val = 2007) # Inkonsistens i data fra modelgruppen i DST - mail sendt 20/11-24
    ;
  # Abort if any data covered variables have been changed by the calibration
  @assert_no_difference(G_data_test, 0.05, .l, _data, "G_imprecise_data was changed by dynamic calibration.");
  $GROUP G_precise_data_test G_data_test, -G_imprecise_data;
  @assert_no_difference(G_precise_data_test, 3e-6, .l, _data, "G_precise_data was changed by dynamic calibration.");

  # ----------------------------------------------------------------------------------------------------------------------
  # Zero shock  -  Abort if a zero shock changes any variables significantly
  # ----------------------------------------------------------------------------------------------------------------------
  $GROUP G_ZeroShockTest All, -dArv;

  @set(G_ZeroShockTest, _saved, .l)
  set_time_periods(%cal_deep%-1, %terminal_year%);
  $FIX All; $UNFIX G_endo;
  @solve(M_base);
  @assert_no_difference(G_ZeroShockTest, 1e-6, .l, _saved, "Zero shock changed variables significantly.");

  # ----------------------------------------------------------------------------------------------------------------------
  # Static zero shock  -  Abort if a zero shock changes any variables significantly
  # ----------------------------------------------------------------------------------------------------------------------
  # !!! Statisk model er ikke square for fuld tids-periode. Nok pga. kapitalpension. Skal rettes!
  # @set(All, _saved, .l)
  # $FIX All; $UNFIX G_static;
  # @solve(M_static);
  # @assert_no_difference(G_Static, 1e-6, .l, _saved, "Static zero shock changed variables significantly.");

$ENDIF
