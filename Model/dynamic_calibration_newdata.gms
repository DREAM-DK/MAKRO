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
@load_dummies(t, "Gdx/%last_calibration%.gdx")
@load_dummies(tData, "Gdx/data.gdx")

$GROUP G_load
  All
  -G_static_calibration_newdata$(tData[t])
  -G_data$(tData[t]), -G_data_residuals$(tData[t])
  -G_constants, G_constants
;
@load(G_load, "Gdx/%last_calibration%.gdx");

# Indbetalinger til kapitalpension er 0 i FMs fremskrivning, men har en værdi i data - derfor denne korrektion
rPensIndb_a.l['kap',a,t1] = rPensIndb_a.l['kap',a,t0];

# ----------------------------------------------------------------------------------------------------------------------
# Load all previous variables from smooth calibration as parameters with same name and suffix "_baseline"
# ----------------------------------------------------------------------------------------------------------------------
@load_as(All, "Gdx/deep_calibration.gdx", _baseline)
@load_as(All, "Gdx/%last_calibration%.gdx", _last_calibration)

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

# ----------------------------------------------------------------------------------------------------------------------
# Aftrapning af stød til parametre
# ----------------------------------------------------------------------------------------------------------------------
# Parameters forecast with ARIMAs are gradually returned to baseline values
$GROUP G_gradual_return
  G_ARIMA_forecast
  -pM # Særbehandles i pricing.gms
  -rPensionAkt # Skal summere til 1, hvilket ikke sikres ved afbøjning
  jmtVirk # jmtVirk og ftSelskab bør behandles ens. jmtVirk udglatter effekt af jftSelskab på mtVirk
;

# Baseline forskydes med permanent andel af stød fra sidste foreløbige data-år
# Stød som skifter fortegn på parameter aftrappes fuldt (herunder stød væk fra 0)
scalar permanens "Andel af stød fra foreløbig data, der fastholdes i strukturelt niveau" /0.15/;
scalar persistens "Persistens i aftrapning af stød til parametre" /0.85/;
parameter aftrapprofil[t] "Profil for aftrapning af parametre til strukturelt niveau.";
parameter stoed_profil[t] "Profil med overgang til nyt strukturelt niveau.";
aftrapprofil[t]$(tx0[t]) = persistens**(dt[t]**1.5);
stoed_profil[t]$(tx0[t]) = permanens + (1-permanens) * aftrapprofil[t];

# Hvis seneste dataår er længere fra dyb kalibrering, end _last_calibration er på lang sigt,
# forskydes dyb kalibrering med langsigtet ændring fra _last_calibration.
# Den andel af stød, som antages at være permanent, akkumulerer således hvis stødet er i samme retning i flere foreløbige år.
# Mens at vi ser bort fra stød i tidligere foreløbige år, hvis seneste foreløbige år ligger tættere på dyb kalibrering.
singleton set tLangSigt[t]; tLangSigt[t] = t.val = min(%terminal_year%, %previous_terminal_year%);
$LOOP G_gradual_return:
  {name}_baseline{sets}$(
    tx0[t] and {conditions}
    and sign({name}_baseline{sets}{$}[<t>tLangSigt]) = sign({name}_last_calibration{sets}{$}[<t>tLangSigt])
    and (abs({name}_last_calibration{sets}{$}[<t>tLangSigt] / {name}_baseline{sets}{$}[<t>tLangSigt] - 1)
        <
        abs({name}.l{sets}{$}[<t>t1] / {name}_baseline{sets}{$}[<t>t1] - 1))$({name}_baseline{sets}{$}[<t>tLangSigt] <> 0 and {name}_baseline{sets}{$}[<t>t1] <> 0)
  )
    = {name}_baseline{sets}
    * ({name}_last_calibration{sets}{$}[<t>tLangSigt] / {name}_baseline{sets}{$}[<t>tLangSigt]);
$ENDLOOP

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
# Define empty models and groups that will be populated by modules
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_dynamic_calibration_newdata ;
MODEL M_dynamic_calibration_newdata;

# ----------------------------------------------------------------------------------------------------------------------
# Import the dynamic calibration models from the modules and combine them
# ----------------------------------------------------------------------------------------------------------------------
@import_from_modules("dynamic_calibration_newdata");

# ----------------------------------------------------------------------------------------------------------------------
# Load previous solution
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_load G_dynamic_calibration_newdata, -G_do_not_load;
@load(G_load, "Gdx/%previous_solution%.gdx")

$IF %calibration_steps% == 1:
  $GROUP G_load G_taxes_endo, G_IO_dynamic_calibration; $GROUP G_load G_load$(t1[t]);
  @load(G_load, "Gdx/static_calibration.gdx")
$ENDIF

@set_initial_levels_to_nonzero(G_dynamic_calibration_newdata)

# ======================================================================================================================
# Trouble-shooting
# ======================================================================================================================
# Default is skipping this step - only include it if model does not solve without
# This section provides better starting values for endogenoues variables

# Save and export all values prior to trouble-shooting
@unload_all(Gdx/dynamic_calibration_presolve);
@set(All, _presolve, .l)

# All exogenous variables
$GROUP G_exogenous @fixed(all);

# ----------------------------------------------------------------------------------------------------------------------
# Update dummies and variables that change sign
# ----------------------------------------------------------------------------------------------------------------------
$IF %stepwise_new_dummies%:
  @print("---------------------------------------- Solve with old dummies and small share of new data  ----------------------------------------")
  # We start with the old dummies and most of the old solution and gradually increase to new values before changing dummies
  @load_dummies(t1, "Gdx/%previous_solution%.gdx")
  # We calibrate with combined old and new data - as we need initial non-zero values (new data without dummies will be exogenous)
  # Residuals defined in calibration_newdata are not included in deep_calibration.gdx, therefore we only include data-residuals.
  $GROUP G_load All, -res_, -G_do_not_load;
  @load(G_load, "Gdx/%previous_solution%.gdx");
  @Set(All, _previous_solution, .l);
  @set_linear_combination(All, 0.99, _previous_solution, _presolve)
  $FIX All; $UNFIX G_dynamic_calibration_newdata;
  @set_bounds();
  @solve(M_dynamic_calibration_newdata); 

  @print("---------------------------------------- Update exogenous values that are zero in either new or old data ----------------------------------------")
  $GROUP G_zeros
    $LOOP G_exogenous:
      {name}$({conditions} and {name}_presolve{sets} * {name}_previous_solution{sets} = 0)
    $ENDLOOP
  ;
  @set(G_zeros, .l, _presolve);
  $FIX All; $UNFIX G_dynamic_calibration_newdata;
  @set_bounds();
  @solve(M_dynamic_calibration_newdata); 

  @print("---------------------------------------- Update exogenous values that change sign ----------------------------------------")
  $GROUP G_changes_sign
    $LOOP G_exogenous:
      {name}$({conditions} and sign({name}_presolve{sets}) <> sign({name}_previous_solution{sets}))
    $ENDLOOP
  ;
  @set(G_changes_sign, .l, _presolve);
  $FIX All; $UNFIX G_dynamic_calibration_newdata;
  @set_bounds();
  @solve(M_dynamic_calibration_newdata); 

  @print("---------------------------------------- Update dummies  ----------------------------------------")
  # We solve model with new dummies and with a combination of new and old data (old data without dummies will be exogenous)
  @load_dummies(t1, "Gdx/data.gdx")
  $FIX All; $UNFIX G_dynamic_calibration_newdata;
  $GROUP G_t1 G_dynamic_calibration_newdata$(t1[t]); @set_initial_levels_to_nonzero(G_t1)
  @set_bounds();
  @solve(M_dynamic_calibration_newdata);
  @set(All, _newdummies, .l)

  @unload(Gdx/stepwise_new_dummies.gdx)

  # We reset - so the new data-set is fully included, but with new endogenous starting values
  @set(G_exogenous, .l, _presolve);
$ENDIF

# Solve the model with partially new exogenous variables - stepwise towards new exogenous (based on calibration with new dummies)
$IF %calibration_steps% > 1:
  @print("---------------------------------------- Update data gradually through linear combinations ----------------------------------------")
  @set(All, _saved, .l) # Save all values prior to trouble-shooting
  $GROUP G_homotopy All$(tx0[t]), -G_dynamic_calibration_newdata, -G_constants, -rPensIndb_a, -res_, -G_do_not_load;
  @load_as(G_homotopy, "Gdx/%previous_solution%.gdx", _previous_solution);
  @set(G_homotopy, _previous_combination, _previous_solution);
  $FOR {share_of_previous} in [0.99]+[
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
    @unload(Gdx/dynamic_calibration_{share_of_previous}.gdx)
    @set(G_homotopy, _previous_combination, .l);
  $ENDFOR

  # Reset data
  @set(G_homotopy, .l, _saved);
$ENDIF

# Solve the model with partially new exogenous variables - one module at a time (based on calibration with new dummies)
$IF %blockwise_calibration%:
  # We start from the values used to update dummies - as we need initial non-zero values for cells not captured by the dummies e.g. vHhPensInd['kap','54',t]
  @load_as(All, "Gdx/stepwise_new_dummies.gdx", _newdummies);
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
    @load(G_load, "Gdx/dynamic_calibration_newdata_presolve.gdx")

    $FIX All; $UNFIX G_dynamic_calibration_newdata;
    @print("---------------------- Groups with new data included = {datagroup} ----------------------------------------")
    @set_bounds();
    @solve(M_dynamic_calibration_newdata); 
    @unload(Gdx/dynamic_calibration_{datagroup}.gdx)
  $ENDFOR

  # We reset - so the new data-set is fully included, but with new endogenous starting values
  @set(G_exogenous, .l, _presolve);
$ENDIF;

# ======================================================================================================================
# Solve calibration model a few years at a time
# ======================================================================================================================
$IF %previous_terminal_year% < %terminal_year%:
  $FOR {end_year} in range(%previous_terminal_year%, %terminal_year%, 30):
    set_time_periods(%data_year%-1, {end_year});
    $FIX All; $UNFIX G_dynamic_calibration_newdata;
    @print("------------------------------------------ Solve dynamic calibration until {end_year} ------------------------------------------")
    @set_bounds();
    @solve(M_dynamic_calibration_newdata)
    set_time_periods(%data_year%-1, %terminal_year%);
    @unload(Gdx/dynamic_calibration_newdata_{end_year}.gdx)
    $GROUP G_starting_values_from_previous_years G_dynamic_calibration_newdata$(t.val >= {end_year}), -G_constants;
    $LOOP G_starting_values_from_previous_years:
      {name}.l{sets}$({conditions}) = {name}.l{sets}{$}[<t>'{end_year}'];
    $ENDLOOP
    $GROUP G_exo All, -G_dynamic_calibration_newdata;
    $GROUP G_LM_nonzero # For at undgå divider med 0, fx ved stigning i tilbagetrækningsalder
      uH[a,t]$(aVal[a] > 65), uDeltag[a,t]$(aVal[a] > 65), rSoegBaseHh[a,t]$(aVal[a] > 65), srSoegBaseHh[a,t]$(aVal[a] > 65);
    $GROUP G_LM_nonzero G_LM_nonzero$(t.val >= {end_year}), -G_exo;
    @load(G_LM_nonzero, "Gdx/deep_calibration.gdx"); # Brug en bank her som er kørt med den fulde tidsperiode
  $ENDFOR
$ENDIF

# ======================================================================================================================
# Solve the model
# ======================================================================================================================
$FIX All; $UNFIX G_dynamic_calibration_newdata;
@set_bounds();
@solve(M_dynamic_calibration_newdata);

# Output
$UNFIX All; # Greatly reduces size of the GDX file
@unload(Gdx/calibration_%data_year%)

# ======================================================================================================================
# Tests
# ======================================================================================================================
$IF %run_tests%:
  $GROUP G_data_test
    G_data
  ;  
  # Abort if any data covered variables have been changed by the calibration
  @assert_no_difference(G_data_test, 0.05, .l, _data, "G_imprecise_data was changed by dynamic calibration.");
  $GROUP G_precise_data_test G_data_test, -G_imprecise_data;
  @assert_no_difference(G_precise_data_test, 3e-6, .l, _data, "G_precise_data was changed by dynamic calibration.");

  # Tests
  $IMPORT Tests/test_age_aggregation.gms;
  $IMPORT Tests/test_other_aggregation.gms;
  $IMPORT Tests/test_other.gms;

  # ----------------------------------------------------------------------------------------------------------------------
  # Zero shock  -  Abort if a zero shock changes any variables significantly
  # ----------------------------------------------------------------------------------------------------------------------
  set_time_periods(%data_year%, %terminal_year%);
  $GROUP G_ZeroShockTest All, -dArv;
  @set(G_ZeroShockTest, _saved, .l)
  $FIX All; $UNFIX G_endo;
  @solve(M_base);
  @assert_no_difference(G_ZeroShockTest, 1e-5, .l, _saved, "Zero shock changed variables significantly.");
$ENDIF
