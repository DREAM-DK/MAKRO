# ======================================================================================================================
# Dynamic calibration for including new data years
# ======================================================================================================================
@print("---------------------------------------- Dynamic calibration %data_year%  ----------------------------------------")

# Set data period to include %data_year%
set_data_periods(%cal_start%, %data_year%);

# Calibrate full model for data_year and forward
set_time_periods(%data_year%-1, %terminal_year%);

# ----------------------------------------------------------------------------------------------------------------------
# Load values from dynamic calibrated model, including age specific parameters and stocks
# ----------------------------------------------------------------------------------------------------------------------
@load_dummies(t, "Gdx\%last_calibration%.gdx")
@load_dummies(tData, "gdx\data.gdx")

$GROUP G_load All, -G_static_calibration_newdata$(tData[t]), -G_data$(tData[t]), -G_constants, G_constants;
@load(G_load, "Gdx\%last_calibration%.gdx");

# Indbetalinger til kapitalpension er 0 i FMs fremskrivning, men har en værdi i data - derfor denne korrektion
rPensIndb_a.l['kap',a,t1] = rPensIndb_a.l['kap',a,t0];

# ----------------------------------------------------------------------------------------------------------------------
# Load all previous variables from smooth calibration as parameters with same name and suffix "_baseline"
# ----------------------------------------------------------------------------------------------------------------------
@load_as(All, "Gdx\deep_calibration.gdx", _baseline)
@load_as(All, "Gdx\%last_calibration%.gdx", _last_calibration)

# ----------------------------------------------------------------------------------------------------------------------
# Parametre fremskrives konstant
# Vi tjekker at serier faktisk er konstante
# i tilfælde af at variable ligger i G_fixed_forecast istedet for G_exogenous_forecast ved en fejl
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_fixed_forecast
  G_exports_fixed_forecast
  G_labor_market_fixed_forecast
  G_aggregates_fixed_forecast
  G_consumers_fixed_forecast
  G_finance_fixed_forecast, -rPensionAkt # Andel af udenlanske aktier og realkredit kan rykkes til ARIMA-gruppe
  G_GovExpenses_fixed_forecast
  G_GovRevenues_fixed_forecast
  G_government_fixed_forecast
  G_HHincome_fixed_forecast
  G_IO_fixed_forecast
  G_pricing_fixed_forecast
  G_production_private_fixed_forecast
  G_production_public_fixed_forecast
;
$LOOP G_fixed_forecast:
  {name}.l{sets}$(tx1[t] and {conditions} and {name}_baseline{sets}{$}[<t>t1] = {name}_baseline{sets}{$}[<t>tEnd])
    = {name}.l{sets}{$}[<t>t1];
$ENDLOOP

$LOOP G_IO_taxes:
  {name}.l['iL',s,tx1] = {name}.l[s,s,tx1];
$ENDLOOP

# ----------------------------------------------------------------------------------------------------------------------
# Aftrapning af stød til parametre
# ----------------------------------------------------------------------------------------------------------------------
# Parameters forecast with ARIMAs are gradually returned to baseline values
$GROUP G_gradual_return
  G_ARIMA_forecast
  -rAfskr # Afskrivningsraterne i foreløbig data virker utroværdige og ses bort fra i fremskrivningen
  -rILy2Y, -rILm2Y # Lagerinvesteringer aftrappes med det samme, for at undgå at de bliver nul ved fortegnsskifte
;

# Baseline forskydes med permanent andel af stød fra sidste foreløbige data-år
# Stød som skifter fortegn på parameter aftrappes fuldt (herunder stød væk fra 0)
$LOOP G_gradual_return:
  {name}_baseline{sets}$(
    tx0[t]
    and {name}_baseline{sets}{$}[<t>tEnd] <> 0
    and sign({name}_baseline{sets}{$}[<t>tEnd]) = sign({name}_last_calibration{sets}{$}[<t>tEnd])
    and abs({name}_last_calibration{sets}{$}[<t>tEnd] / {name}_baseline{sets}{$}[<t>tEnd] - 1)
        <
        abs({name}.l{sets}{$}[<t>t1] / {name}_baseline{sets}{$}[<t>t1] - 1)
  )
    = {name}_baseline{sets}
    * ({name}_last_calibration{sets}{$}[<t>tEnd] / {name}_baseline{sets}{$}[<t>tEnd]);
$ENDLOOP

scalar permanens "Andel af stød fra foreløbig data, der fastholdes i strukturelt niveau" /0.15/;
scalar persistens "Persistens i aftrapning af stød til parametre" /0.85/;
parameter aftrapprofil[t] "Profil for aftrapning af parametre til strukturelt niveau.";
parameter stoed_profil[t] "Profil med overgang til nyt strukturelt niveau.";
aftrapprofil[t]$(tx0[t]) = persistens**(dt[t]**1.5);
stoed_profil[t]$(tx0[t]) = permanens + (1-permanens) * aftrapprofil[t];
$LOOP G_gradual_return:
  # Additive
  {name}.l{sets}$(
    sign({name}.l{sets}{$}[<t>t1]) <> sign({name}_baseline{sets}{$}[<t>t1])
    and {conditions}
    and tx1[t]
  ) = {name}_baseline{sets}
    + stoed_profil[t] * ({name}.l{sets}{$}[<t>t1] - {name}_baseline{sets}{$}[<t>t1]);

  # Multiplicative
  {name}.l{sets}$(
    sign({name}.l{sets}{$}[<t>t1]) = sign({name}_baseline{sets}{$}[<t>t1])
    and {name}_baseline{sets}{$}[<t>t1] <> 0
    and {conditions}
    and tx1[t]
  ) = {name}_baseline{sets}
    * (1 + stoed_profil[t] * ({name}.l{sets}{$}[<t>t1] / {name}_baseline{sets}{$}[<t>t1] - 1));
$ENDLOOP
@set(G_gradual_return, _ARIMA, .l)

$FUNCTION gradual_return_to_baseline({var}):
  $LOOP {var}:
    {name}{sets} =E=
    # Additive
    (
      {name}_baseline{sets}
      + stoed_profil[t] * ({name}{sets}{$}[<t>t1] - {name}_baseline{sets}{$}[<t>t1])
    )$({name}_baseline{sets}{$}[<t>t1] = 0)
    +
    # Multiplicative
    (
      {name}_baseline{sets}
      * (1 + stoed_profil[t] * ({name}{sets}{$}[<t>t1] / {name}_baseline{sets}{$}[<t>t1] - 1))
    )$({name}_baseline{sets}{$}[<t>t1] <> 0)
    ;
  $ENDLOOP
$ENDFUNCTION

# ----------------------------------------------------------------------------------------------------------------------
# Import the dynamic calibration models from the modules and combine them
# ----------------------------------------------------------------------------------------------------------------------
# Read equations
@import_from_modules("dynamic_calibration_newdata");

$GROUP G_dynamic_calibration_newdata
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
  G_aggregates_dynamic_calibration

  G_taxes_endo
;

MODEL M_dynamic_calibration_newdata /
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
  M_aggregates_dynamic_calibration

  B_taxes
/;

# ======================================================================================================================
# Trouble-shooting
# ======================================================================================================================
# Default is skipping this step - only include it if model does not solve without
# This section provides better starting values for endogenoues variables

# Save and export all values prior to trouble-shooting
@unload_all(Gdx\dynamic_calibration_newdata_presolve);
@set(All, _presolve, .l)

# All exogenous variables
$GROUP G_exogenous @fixed(all);

# ----------------------------------------------------------------------------------------------------------------------
# Update dummies and variables that change sign
# ----------------------------------------------------------------------------------------------------------------------
$IF %stepwise_new_dummies%:
  @print("---------------------------------------- Solve with old dummies and small share of new data  ----------------------------------------")
  # We start with the old dummies and most of the old solution and gradually increase to new values before changing dummies
  @load_dummies(t1, "Gdx\%previous_solution%.gdx")
  # We calibrate with combined old and new data - as we need initial non-zero values (new data without dummies will be exogenous)
  @load_as(All, "Gdx\%previous_solution%.gdx", _previous_solution);
  @set_linear_combination(All, 0.99, _previous_solution, .l)
  $FIX All; $UNFIX G_dynamic_calibration_newdata;
  @set_bounds();
  @solve(M_dynamic_calibration_newdata); 

  @print("---------------------------------------- Update dummies  ----------------------------------------")
  # We solve model with new dummies and with a combination of new and old data (old data without dummies will be exogenous)
  @load_dummies(t1, "Gdx\data.gdx")
  $FIX All; $UNFIX G_dynamic_calibration_newdata;
  $GROUP G_t1 G_dynamic_calibration_newdata$(t1[t]); @set_initial_levels_to_nonzero(G_t1)
  @set_bounds();
  @solve(M_dynamic_calibration_newdata);
  @set(All, _newdummies, .l)

  @print("---------------------------------------- Update exogenous values that are zero in either new or old data ----------------------------------------")
  $GROUP G_zeros
    $LOOP G_exogenous:
      {name}$({conditions} and {name}_presolve{sets} * {name}.l{sets} = 0)
    $ENDLOOP
  ;
  @set(G_zeros, .l, _presolve);
  $FIX All; $UNFIX G_dynamic_calibration_newdata;
  @set_bounds();
  @solve(M_dynamic_calibration_newdata); 

  @print("---------------------------------------- Update exogenous values that change sign ----------------------------------------")
  $GROUP G_changes_sign
    $LOOP G_exogenous:
      {name}$({conditions} and sign({name}_presolve{sets}) <> sign({name}.l{sets}))
    $ENDLOOP
  ;
  @set(G_changes_sign, .l, _presolve);
  $FIX All; $UNFIX G_dynamic_calibration_newdata;
  @set_bounds();
  @solve(M_dynamic_calibration_newdata); 

  @unload(Gdx\stepwise_new_dummies.gdx)

  # We reset - so the new data-set is fully included, but with new endogenous starting values
  @set(G_exogenous, .l, _presolve);
$ENDIF

# Solve the model with partially new exogenous variables - stepwise towards new exogenous (based on calibration with new dummies)
$IF %calibration_steps% > 1:
  @print("---------------------------------------- Update data gradually through linear combinations ----------------------------------------")
  @set(All, _saved, .l) # Save all values prior to trouble-shooting
  @load_dummies(t1, "Gdx\%previous_solution%.gdx")
  $GROUP G_homotopy All$(tx0[t]), -G_dynamic_calibration_newdata, -G_constants, -rPensIndb_a;
  @load_as(All, "Gdx\%previous_solution%.gdx", _previous_solution);
  @set(G_homotopy, _previous_combination, _previous_solution);
  @set_linear_combination(G_dynamic_calibration_newdata, 0.99, _previous_solution, .l) # Set starting values for first iteration
  $FOR {share_of_previous} in [
    round(1 - i/%calibration_steps%, 2) for i in range(1, %calibration_steps%)
  ]:
    @set_linear_combination(G_homotopy, {share_of_previous}, _previous_solution, _saved)
    # Any exogenous variable that gets close to zero from the linear combiation is set to the latest combination that worked
    $LOOP G_homotopy:
      {name}.l{sets}$({conditions} and abs({name}.l{sets}) < 1e-6) = {name}_previous_combination{sets};  
    $ENDLOOP
    $FIX All; $UNFIX G_dynamic_calibration_newdata;
    @print("---------------------------------------- Share = {share_of_previous} ----------------------------------------")
    @set_bounds();
    @solve(M_dynamic_calibration_newdata); 
    @unload(Gdx\dynamic_calibration_{share_of_previous}.gdx)
    @set(G_homotopy, _previous_combination, .l);
  $ENDFOR
  @set(G_homotopy, .l, _saved);

  @print("---------------------------------------- Update dummies ----------------------------------------")
  @load_dummies(t1, "Gdx\data.gdx")
  $FIX All; $UNFIX G_dynamic_calibration_newdata;
  $GROUP G_t1 G_dynamic_calibration_newdata$(t1[t]); @set_initial_levels_to_nonzero(G_t1)
  @set_bounds();
  @solve(M_dynamic_calibration_newdata); 
$ENDIF

# Solve the model with partially new exogenous variables - one module at a time (based on calibration with new dummies)
$IF %blockwise_calibration%:
  # We start from the values used to update dummies - as we need initial non-zero values for cells not captured by the dummies e.g. vHhPensInd['kap','54',t]
  @load_as(All, "Gdx\stepwise_new_dummies.gdx", _newdummies);
  @set(All, .l, _newdummies)

  $GROUP G_load ; # Initialize load-group from new data starting of with none

  # Module for module we load new data and calibrate the model with partially new and partially old data
  # The order of modules matters. If for example labor_market is included to early it does not run. This could be looked into in order to find an explanation.
  # It has so far worked to put a module last if it does not solve
  $FOR {datagroup} in [
    "production_public", "struk", "exports", "production_private", "finance", "HHincome", "consumers", 
    "GovRevenues", "government", "GovExpenses", "taxes", "aggregates", "pricing", "labor_market", "IO"
  ]:  
    $GROUP G_load G_load, G_{datagroup}_data, G_{datagroup}_static_calibration_newdata;
    @load(G_load, "Gdx\dynamic_calibration_newdata_presolve.gdx")

    $FIX All; $UNFIX G_dynamic_calibration_newdata;
    @print("---------------------- Groups with new data included = {datagroup} ----------------------------------------")
    @set_bounds();
    @solve(M_dynamic_calibration_newdata); 
    @unload(Gdx\dynamic_calibration_{datagroup}.gdx)
  $ENDFOR

  # We reset - so the new data-set is fully included, but with new endogenous starting values
  @set(G_exogenous, .l, _presolve);
$ENDIF;

# ----------------------------------------------------------------------------------------------------------------------
# Load previous solution
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_t1 G_dynamic_calibration_newdata$(t1[t]); @set_initial_levels_to_nonzero(G_t1)
$IF "%previous_solution%" != "%last_calibration%" and %calibration_steps% == 1:
  @load(G_dynamic_calibration_newdata, "Gdx\%previous_solution%.gdx")
$ENDIF

# ======================================================================================================================
# Solve the model
# ======================================================================================================================
$FIX All; $UNFIX G_dynamic_calibration_newdata;
@set_bounds();
@solve(M_dynamic_calibration_newdata);

# ======================================================================================================================
# Solve post model containing ouput only variables
# ======================================================================================================================
$FIX All; $UNFIX G_post;
@solve(M_post);

# Output
@unload(Gdx\calibration_%data_year%)

# ======================================================================================================================
# Tests
# ======================================================================================================================
$IF %run_tests%:
  $GROUP G_data_test
    G_data
    # Tests slået fra efter forlængelse af bank ultimo november 2014
    -vUdlAktRenter$(t.val = 2005 or t.val = 2007) # Inkonsistens i data fra modelgruppen i DST - mail sendt 20/11-24
  ;  
  # Abort if any data covered variables have been changed by the calibration
  @assert_no_difference(G_data_test, 0.05, .l, _data, "G_imprecise_data was changed by dynamic calibration.");
  $GROUP G_precise_data_test G_data_test, -G_imprecise_data;
  @assert_no_difference(G_precise_data_test, 1e-6, .l, _data, "G_precise_data was changed by dynamic calibration.");

  # Tests
  $IMPORT tests\test_age_aggregation.gms;
  $IMPORT tests\test_other_aggregation.gms;
  $IMPORT tests\test_other.gms;

  # ----------------------------------------------------------------------------------------------------------------------
  # Zero shock  -  Abort if a zero shock changes any variables significantly
  # ----------------------------------------------------------------------------------------------------------------------
  set_time_periods(%data_year%, %terminal_year%);
  $GROUP G_ZeroShockTest All, -dArv;
  @set(G_ZeroShockTest, _saved, .l)
  $FIX All; $UNFIX G_endo;
  @solve(M_base);
  $FIX All; $UNFIX G_post;
  @solve(M_post);
  @assert_no_difference(G_ZeroShockTest, 1e-5, .l, _saved, "Zero shock changed variables significantly.");
$ENDIF