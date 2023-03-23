# ======================================================================================================================
# Functions
# ======================================================================================================================
# In this file we define functions and macros to be used elsewhere in the model
# Macros are a vanilla GAMS feature
# The FUNCTION command is is a gamY feature. It should be used when the user defined function includes other gamY commands.


# ----------------------------------------------------------------------------------------------------------------------
# Macros related to sets
# ----------------------------------------------------------------------------------------------------------------------
# See the sets files


# ----------------------------------------------------------------------------------------------------------------------
# Adjusting for growth and inflation
# ----------------------------------------------------------------------------------------------------------------------
# Shift variables to adjust for inflation and growth
variable INF_GROWTH_ADJUSTED "Dummy indicating if variables are growth and inflation adjusted";
INF_GROWTH_ADJUSTED.l = 0;

$FUNCTION inf_growth_adjust():
  abort$(INF_GROWTH_ADJUSTED.l) "Trying to adjust for inflation and growth, but model is already adjusted.";
  $offlisting
    $LOOP G_prices:
      {name}.l{sets} = {name}.l{sets} * inf_factor[t];
      {name}.lo{sets} = {name}.lo{sets} * inf_factor[t];
      {name}.up{sets} = {name}.up{sets} * inf_factor[t];
    $ENDLOOP
    $LOOP G_quantities:
      {name}.l{sets} = {name}.l{sets} * growth_factor[t];
      {name}.lo{sets} = {name}.lo{sets} * growth_factor[t];
      {name}.up{sets} = {name}.up{sets} * growth_factor[t];
    $ENDLOOP
    $LOOP G_values:
      {name}.l{sets} = {name}.l{sets} * inf_growth_factor[t];
      {name}.lo{sets} = {name}.lo{sets} * inf_growth_factor[t];
      {name}.up{sets} = {name}.up{sets} * inf_growth_factor[t];
    $ENDLOOP
  $onlisting
  INF_GROWTH_ADJUSTED.l = 1;
$ENDFUNCTION

# Remove inflation and growth adjustment
$FUNCTION remove_inf_growth_adjustment():
  abort$(not INF_GROWTH_ADJUSTED.l) "Trying to remove inflation and growth adjustment, but model is already nominal.";
  $offlisting
    $LOOP G_prices:
      {name}.l{sets} = {name}.l{sets} / inf_factor[t];
      {name}.lo{sets} = {name}.lo{sets} / inf_factor[t];
      {name}.up{sets} = {name}.up{sets} / inf_factor[t];
    $ENDLOOP
    $LOOP G_quantities:
      {name}.l{sets} = {name}.l{sets} / growth_factor[t];
      {name}.lo{sets} = {name}.lo{sets} / growth_factor[t];
      {name}.up{sets} = {name}.up{sets} / growth_factor[t];
    $ENDLOOP
    $LOOP G_values:
      {name}.l{sets} = {name}.l{sets} / inf_growth_factor[t];
      {name}.lo{sets} = {name}.lo{sets} / inf_growth_factor[t];
      {name}.up{sets} = {name}.up{sets} / inf_growth_factor[t];
    $ENDLOOP
  $onlisting
  INF_GROWTH_ADJUSTED.l = 0;
$ENDFUNCTION

# Growth adjust a single group of variables (note that dollar-conditions are used here, but not above)
$FUNCTION growth_adjust_group({group}):
  $offlisting
  $LOOP {group}:
      {name}.l{sets}$({conditions}) = {name}.l{sets} * growth_factor[t];
  $ENDLOOP
  $onlisting
$ENDFUNCTION

# Inflation adjust a single group of variables
$FUNCTION inf_adjust_group({group}):
  $offlisting
  $LOOP {group}:
      {name}.l{sets}$({conditions}) = {name}.l{sets} * inf_factor[t];
  $ENDLOOP
  $onlisting
$ENDFUNCTION

# Growth and inflation adjust a single group of variables. 
$FUNCTION inf_growth_adjust_group({group}):
  $offlisting
  $LOOP {group}:
      {name}.l{sets}$({conditions}) = {name}.l{sets} * inf_growth_factor[t];
  $ENDLOOP
  $onlisting
$ENDFUNCTION


# ----------------------------------------------------------------------------------------------------------------------
# Save and load states
# ----------------------------------------------------------------------------------------------------------------------
# Load levels of group from GDX file 
$FUNCTION load({group}, {gdx}):
  $offlisting
  $GROUP __load_group {group};  # Redefining a group to get around $LOOP not working with direct dollar-conditions 
  $LOOP __load_group:
    parameter load_{name}{sets} "";
    load_{name}{sets}$({conditions}) = 0;
  $ENDLOOP
  execute_load {gdx} $LOOP __load_group: load_{name}={name}.l $ENDLOOP;
  $LOOP __load_group:
    {name}.l{sets}$({conditions}) = load_{name}{sets};
  $ENDLOOP
  $onlisting
$ENDFUNCTION

$FUNCTION load_nonzero({group}, {gdx}):
  $offlisting
  $GROUP __load_group {group};
  $LOOP __load_group:
    parameter load_{name}{sets} "";
    load_{name}{sets}$({conditions}) = 0;
  $ENDLOOP
  execute_load {gdx} $LOOP __load_group: load_{name}={name}.l $ENDLOOP;
  $LOOP __load_group:
    {name}.l{sets}$({conditions} and load_{name}{sets} <> 0) = load_{name}{sets};
  $ENDLOOP
  $onlisting
$ENDFUNCTION

$FUNCTION load_as({group}, {gdx}, {suffix}):
  $offlisting
  $GROUP __load_group {group};
  $LOOP __load_group:
    parameter {name}{suffix}{sets} "";
    parameter {name}_load{sets} "";
    {name}_load{sets}$({conditions}) = 0;
  $ENDLOOP
  execute_load {gdx} $LOOP __load_group: {name}_load={name}.l $ENDLOOP;
  $LOOP __load_group:
    {name}{suffix}{sets}$({conditions}) = {name}_load{sets};
  $ENDLOOP
  $onlisting
$ENDFUNCTION

# Set group to a linear combination of current values and values from a GDX file
$FUNCTION load_linear_combination({group}, {share}, {gdx}):
  $offlisting
  $GROUP __load_group {group};
  $LOOP __load_group:
    parameter load_{name}{sets} "";
    load_{name}{sets}$({conditions}) = 0;
  $ENDLOOP
  execute_load {gdx} $LOOP __load_group: load_{name}={name}.l $ENDLOOP;
  $LOOP __load_group:
    {name}.l{sets}$({conditions}) = load_{name}{sets} * {share} + (1-{share}) * {name}.l{sets};
  $ENDLOOP
  $onlisting
$ENDFUNCTION

$FUNCTION load_dummies({time_subset}, {gdx}):
  SETS 
    load_d1IO[d_,s_,t]
    load_d1IOy[d_,s_,t]
    load_d1IOm[d_,s_,t]
    load_d1Xm[x_,t]
    load_d1Xy[x_,t]
    load_d1CTurist[c,t]
    load_d1X[x_,t]
    load_d1I_s[i_,ds_,t]
    load_d1K[i_,s_,t]
    load_d1R[r_,t]
    load_d1C[c_,t]
    load_d1G[g_,t]
    load_d1vHh[portf_,t]
  ;
  execute_load {gdx}
    load_d1IO=d1IO
    load_d1IOy=d1IOy
    load_d1IOm=d1IOm
    load_d1Xm=d1Xm
    load_d1Xy=d1Xy
    load_d1CTurist=d1CTurist
    load_d1X=d1X
    load_d1I_s=d1I_s
    load_d1K=d1K
    load_d1R=d1R
    load_d1C=d1C
    load_d1G=d1G
    load_d1vHh=d1vHh
  ;
  d1IO[d_,s_,t]$({time_subset}[t]) = load_d1IO[d_,s_,t];
  d1IOy[d_,s_,t]$({time_subset}[t]) = load_d1IOy[d_,s_,t];
  d1IOm[d_,s_,t]$({time_subset}[t]) = load_d1IOm[d_,s_,t];
  d1Xm[x_,t]$({time_subset}[t]) = load_d1Xm[x_,t];
  d1Xy[x_,t]$({time_subset}[t]) = load_d1Xy[x_,t];
  d1CTurist[c,t]$({time_subset}[t]) = load_d1CTurist[c,t];
  d1X[x_,t]$({time_subset}[t]) = load_d1X[x_,t];      
  d1I_s[i_,ds_,t]$({time_subset}[t]) = load_d1I_s[i_,ds_,t];
  d1K[i_,s_,t]$({time_subset}[t]) = load_d1K[i_,s_,t];
  d1R[r_,t]$({time_subset}[t]) = load_d1R[r_,t];      
  d1C[c_,t]$({time_subset}[t]) = load_d1C[c_,t];      
  d1G[g_,t]$({time_subset}[t]) = load_d1G[g_,t];      
  d1vHh[portf_,t]$({time_subset}[t]) = load_d1vHh[portf_,t];      
$ENDFUNCTION

# Export all variables to GDX files (with and without adjusment for inflation and growth).
$FUNCTION unload({fname}):
  execute_unloaddi '{fname}'
    $LOOP All:, {name} $ENDLOOP
    inf_factor, growth_factor, inf_growth_factor, fp, fq, fv, INF_GROWTH_ADJUSTED, nOvf2Soc
    a_, a, a0t100, a15t100, a18t100, aTot
    ovf_, ovf, soc
    portf_, akt, pas
    d_, d, s_, s, x_, x, g_, g, c_, c, i_, i, k_, k 
    sTot, kTot
    d1IO, d1IOy, d1IOm, d1Xm, d1Xy, d1CTurist, d1X, d1I_s, d1K, d1R, d1C, d1G
    d1vHh
  ;
$ENDFUNCTION

$FUNCTION unload_all_nominal({fname}):
  @remove_inf_growth_adjustment()
  execute_unloaddi '{fname}';
  @inf_growth_adjust()
$ENDFUNCTION

$FUNCTION unload_all({fname}):
  execute_unloaddi '{fname}';
$ENDFUNCTION

$FUNCTION unload_group({group}, {fname}):
  execute_unloaddi '{fname}' $LOOP {group}:, {name} $ENDLOOP;
$ENDFUNCTION

# Save the values of a group of variables, by creating parameters with the same names and a suffix added.
$FUNCTION save_as({group}, {suffix}):
  $onDotL
  $offlisting
    $LOOP {group}:
      parameter {name}{suffix}{sets};
      {name}{suffix}{sets}${conditions} = {name}{sets};
    $ENDLOOP
  $onlisting
  $offDotL
$ENDFUNCTION

# Save the values of a group of variables so that they can later be recalled.
$FUNCTION save({group}):
  @save_as({group}, _saved)
$ENDFUNCTION

# Reset the values of a group of variables to the levels saved previously. 
$FUNCTION reset_to({group}, {suffix}):
  $offlisting
  $onDotL
    $LOOP {group}:
      {name}{sets}${conditions} = {name}{suffix}{sets};
    $ENDLOOP
  $offDotL
  $onlisting
$ENDFUNCTION

$FUNCTION reset({group}):
  @reset_to({group}, _saved)
$ENDFUNCTION

# Display the difference between the current values of a group of variables and the previously saved values.
$FUNCTION display_difference({group}):
  $offlisting
  $onDotL
    $LOOP {group}:
      parameter {name}_difference{sets};
      {name}_difference{sets}${conditions} = {name}{sets} - {name}_saved{sets};
    $ENDLOOP

  # Differences above E-9:
    $LOOP {group}:
      display$(sum({sets}{$}[+t], abs(round({name}_difference{sets}, 9)))) {name}_difference;
    $ENDLOOP
  $offDotL
  $onlisting
$ENDFUNCTION

# Abort if differences exceed the threshold. Differences are between the current values of a group of variables and the previously saved values.
$FUNCTION assert_no_difference_from({group}, {threshold}, {suffix}, {msg}):
  $offlisting
  $onDotL
    $LOOP {group}:
      parameter {name}_difference{sets};
      {name}_difference{sets}${conditions} = {name}{sets} - {name}{suffix}{sets};
      {name}_difference{sets}$(abs({name}_difference{sets}) < {threshold}) = 0;
      if (sum({sets}{$}[+t]${conditions}, abs({name}_difference{sets})),
        display {name}_difference;
      );
    $ENDLOOP
    $LOOP {group}:
      loop({sets}{$}[+t]${conditions},
        abort$({name}_difference{sets} <> 0) '{name}_difference exceeds allowed threshold! {msg}';
      )
    $ENDLOOP
  $offDotL
  $onlisting
$ENDFUNCTION

$FUNCTION assert_no_difference({group}, {threshold}, {msg}):
  @assert_no_difference_from({group}, {threshold}, _saved, {msg})
$ENDFUNCTION

# Display variables that have become 0 in current data eg static calibration, but was not 0 in previous data eg static calibration
#          and variables that is not 0 in current data eg static calibration, but was 0 in previous data eg static calibration
$FUNCTION display_zeros({group}, {gdx}):
  @load_as({group}, {gdx}, _previous);

  $offlisting
  $onDotL
    $LOOP {group}:
      parameter {name}_is_zero_now{sets};
      {name}_is_zero_now{sets}${conditions} = (abs({name}{sets}) < 1e-9) and not (abs({name}_previous{sets}) < 1e-9);
    $ENDLOOP
  
    $LOOP {group}:
      display$(sum({sets}{$}[+t], {name}_is_zero_now{sets})) {name}_is_zero_now;
    $ENDLOOP

    $LOOP {group}:
      parameter {name}_is_not_zero_now{sets};
      {name}_is_not_zero_now{sets}${conditions} = (abs({name}{sets}) >= 1e-9) and (abs({name}_previous{sets}) < 1e-9);
    $ENDLOOP
  
    $LOOP {group}:
      display$(sum({sets}{$}[+t], {name}_is_not_zero_now{sets})) {name}_is_not_zero_now;
    $ENDLOOP
  $offDotL
  $onlisting 
$ENDFUNCTION

$FUNCTION load_pgroup({pgroup}, {gdx}):
  $offlisting
  $PGROUP __load_pgroup {pgroup};
  $LOOP __load_pgroup:
    parameter load_{name}{sets} "";
    load_{name}{sets}$({conditions}) = 0;
  $ENDLOOP
  execute_load {gdx} $LOOP __load_pgroup: load_{name}={name} $ENDLOOP;
  $LOOP __load_pgroup:
    {name}{sets}$({conditions}) = load_{name}{sets};
  $ENDLOOP
  $onlisting
$ENDFUNCTION

# Functions used to define new groups etc. based on endogeneity of variables
$FUNCTION fixed({group}):
    $LOOP {group}:
      {name}{sets}$({conditions} and {name}.lo{sets} = {name}.l{sets} and {name}.up{sets} = {name}.l{sets})
    $ENDLOOP
$ENDFUNCTION

$FUNCTION unfixed({group}):
    $LOOP {group}:
      {name}{sets}$({conditions} and {name}.lo{sets} <> {name}.l{sets} and {name}.up{sets} <> {name}.l{sets})
    $ENDLOOP
$ENDFUNCTION


# ----------------------------------------------------------------------------------------------------------------------
# Math
# ----------------------------------------------------------------------------------------------------------------------
# Example: mean(t, a[t]) -> sum(t, a[t]) / sum(t, 1)
$FUNCTION mean({dim}, {expression}): sum({dim}, {expression}) / sum({dim}, 1) $ENDFUNCTION

$FUNCTION geo_mean({dim}, {expression}): prod({dim}, {expression})**(1/sum({dim}, 1))$ENDFUNCTION

# Smooth approximation of ABS function. The error is zero when {x} is zero and goes to -smooth_abs_delta as abs({x}) increases.
scalar smooth_abs_delta /0.01/;
$FUNCTION abs({x}): (sqrt(sqr({x}) + sqr(smooth_abs_delta)) - smooth_abs_delta)$ENDFUNCTION

# Smooth approximation of MAX function. The error is smooth_max_delta/2 when {x}=={y} and goes to zero as {x} and {y} diverge.
scalar smooth_max_delta /0.001/;
$FUNCTION max({x}, {y}): (({x} + {y} + Sqrt(Sqr({x} - {y}) + Sqr(smooth_max_delta))) / 2)$ENDFUNCTION

# Smooth approximation of MIN function. The error is -smooth_min_delta/2 when {x}=={y} and goes to zero as {x} and {y} diverge.
scalar smooth_min_delta /0.001/;
$FUNCTION min({x}, {y}): (({x} + {y} - Sqrt(Sqr({x} - {y}) + Sqr(smooth_min_delta))) / 2)$ENDFUNCTION


# ----------------------------------------------------------------------------------------------------------------------
# Solving
# ----------------------------------------------------------------------------------------------------------------------
# Solve {model} as CNS with a number of solver options set
$FUNCTION solve({model}):
  {model}.optfile = 1;
  {model}.holdFixed = 1;
  {model}.workfactor = 2;
  #  {model}.workspace = 8000;
  #  {model}.tolinfeas = 1e-12;
  @print("---------------------------------------- Solve start ----------------------------------------")
  @set_bounds();
  solve {model} using CNS;
  abort$({model}.solveStat > 1) "Solver did not complete normally";
  @print("---------------------------------------- Solve finished ----------------------------------------")
$ENDFUNCTION

$FUNCTION robust_solve({model}):
  {model}.optfile = 1;
  {model}.holdFixed = 1;
  {model}.workfactor = 2;
  #  {model}.workspace = 8000;
  #  {model}.tolinfeas = 1e-12;
  @set_initial_levels_to_nonzero()
  @set_bounds();
  @unload_all(Gdx\{model}_presolve); # Output gdx file with the state before solving to help with debugging
  @print("---------------------------------------- Solve start ----------------------------------------")
  solve {model} using CNS;
  @print("---------------------------------------- Solve finished ----------------------------------------")
  @reset_initial_levels()
$ENDFUNCTION

# Set bounds on three groups, G_lower_bound, G_zero_bound, and G_lower_upper_bound
$FUNCTION set_bounds():
  @bound(G_lower_bound, 0.001, inf);
  @bound(G_zero_bound, 1e-6, inf);
  @bound(G_lower_upper_bound, 0.01, 20);
  @bound(G_unit_interval_bound, 1e-6, 1-1e-6);
$ENDFUNCTION

# Set bounds on {group} to {lo}, {up}
$FUNCTION bound({group}, {lo}, {up}):
  $LOOP {group}:
      {name}.lo{sets}$({conditions} and {name}.up{sets} <> {name}.l{sets}) = {lo};
      {name}.up{sets}$({conditions} and {name}.up{sets} <> {name}.l{sets}) = {up};
  $ENDLOOP
$ENDFUNCTION

# Set better initial levels for endogenous variables that are zero
$FUNCTION set_initial_levels_to_nonzero():
  $offlisting

  # Variables that should start at 1 (if endogenous and no starting level exists)
  $GROUP G_unity_starting_level
    fuIOym, G_prices, -empty_group_dummy
  ;
  $LOOP G_unity_starting_level:
    {name}.l{sets}$(({name}.up{sets} <> {name}.lo{sets}) and {name}.l{sets} = 0) = 1;
  $ENDLOOP

  # Variables that should start at the previous years level or a small number (if endogenous and no starting level exists)
  $GROUP G_other
     All, -G_unity_starting_level  # Add all variables here requires more consistent dummies or defining variables over smaller sets (turning off domain checking)
  ;
  $LOOP G_other:
    # If the variable is 1) endogenous 2) has a starting level of 0 and 3) has a non-zero level in t1 => set starting level to t1
    {name}.l{sets}$(
           ({name}.up{sets} <> {name}.lo{sets})
       and ({name}.l{sets} = 0)
       and ({name}.l{sets}{$}[<t>t1] <> 0)) = {name}.l{sets}{$}[<t>t1];
    # If the variable is 1) endogenous 2) has a starting level of 0 and 3) has a non-zero level in t0 => set starting level to t0
    {name}.l{sets}$(
           ({name}.up{sets} <> {name}.lo{sets})
       and ({name}.l{sets} = 0)
       and ({name}.l{sets}{$}[<t>t0] <> 0)) = {name}.l{sets}{$}[<t>t0];
    # If an endogenous variable still has a staring level of 0, set the starting level to a small non-zero number
    {name}.l{sets}$(
           ({name}.up{sets} <> {name}.lo{sets})
       and ({name}.l{sets} = 0)) = 0.000987654321;
  $ENDLOOP
  $onlisting
$ENDFUNCTION

# Reset levels of endogenous variables that are still the exact value set in set_initial_levels_to_nonzero
$FUNCTION reset_initial_levels():
  $LOOP All:
    {name}.l{sets}$(({name}.up{sets} <> {name}.lo{sets}) and {name}.l{sets} = 0.000987654321) = 0;
  $ENDLOOP
$ENDFUNCTION


# ----------------------------------------------------------------------------------------------------------------------
# Other
# ----------------------------------------------------------------------------------------------------------------------
FILE logfile /''/;
$FUNCTION print({msg}):
  PUT logfile;
  PUT_UTILITY "log" / {msg};
$ENDFUNCTION

# Create a copy of an equation replacing the time set with different time set, e.g. used to create a t0 initial condition copy of an equation
$FUNCTION copy_equation_to_period_as({equation},{time},{suffix}):
  $LOOP00 {equation}:
    $REGEX("tx[01]?E?\[t\]","{time}[t]") {name}{suffix}{sets}${conditions}.. {LHS} =E= {RHS}; $ENDREGEX
  $ENDLOOP00
$ENDFUNCTION

$FUNCTION copy_equation_to_period({equation},{time}):
  $LOOP00 {equation}:
    $REGEX("tx[01]?E?\[t\]","{time}[t]") {name}_{time}{sets}${conditions}.. {LHS} =E= {RHS}; $ENDREGEX
  $ENDLOOP00
$ENDFUNCTION


# Define equations setting each variable in the group equal to their t1 value 
$FUNCTION forecast_constant_equation({group}):
  $LOOP00 {group}:
    E_{name}_forecast_constant{sets}${conditions}.. {name}{sets} =E= {name}{sets}{$}[<t>t1];
  $ENDLOOP00
$ENDFUNCTION


# ----------------------------------------------------------------------------------------------------------------------
# HP-filter
# ----------------------------------------------------------------------------------------------------------------------
# Apply an HP-filter to the input variable
$FUNCTION HPfilter({name})
embeddedCode Python:
  import dreamtools as dt
  from statsmodels.tsa.filters.hp_filter import hpfilter

  db = dt.GamsPandasDatabase(gams.db)

  levels = db['{name}'].index.names[:-1]  # Alle sets undtagen det sidste, som er tidsdimensionen
  db['{name}'] = db['{name}'].groupby(levels).transform(lambda x: hpfilter(x.values, lamb=6.25)[1])

  db.save_series_to_database()
  gams.set('{name}', db.symbols['{name}'])
endEmbeddedCode {name}
$ENDFUNCTION
