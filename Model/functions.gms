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
variable INF_GROWTH_ADJUSTED "Dummy indicating if variables are growth and inflation adjusted";
INF_GROWTH_ADJUSTED.l = 0;

$FUNCTION inf_growth_adjust():
  # Shift variables to adjust for inflation and growth
  abort$(INF_GROWTH_ADJUSTED.l) "Trying to adjust for inflation and growth, but model is already adjusted.";
  $offlisting
    $LOOP G_prices:
      {name}.l{sets} = {name}.l{sets} / fpt[t];
      {name}.lo{sets} = {name}.lo{sets} / fpt[t];
      {name}.up{sets} = {name}.up{sets} / fpt[t];
    $ENDLOOP
    $LOOP G_quantities:
      {name}.l{sets} = {name}.l{sets} / fqt[t];
      {name}.lo{sets} = {name}.lo{sets} / fqt[t];
      {name}.up{sets} = {name}.up{sets} / fqt[t];
    $ENDLOOP
    $LOOP G_values:
      {name}.l{sets} = {name}.l{sets} / fvt[t];
      {name}.lo{sets} = {name}.lo{sets} / fvt[t];
      {name}.up{sets} = {name}.up{sets} / fvt[t];
    $ENDLOOP
  $onlisting
  INF_GROWTH_ADJUSTED.l = 1;
$ENDFUNCTION

$FUNCTION remove_inf_growth_adjustment():
  # Remove inflation and growth adjustment
  abort$(not INF_GROWTH_ADJUSTED.l) "Trying to remove inflation and growth adjustment, but model is already nominal.";
  $offlisting
    $LOOP G_prices:
      {name}.l{sets} = {name}.l{sets} * fpt[t];
      {name}.lo{sets} = {name}.lo{sets} * fpt[t];
      {name}.up{sets} = {name}.up{sets} * fpt[t];
    $ENDLOOP
    $LOOP G_quantities:
      {name}.l{sets} = {name}.l{sets} * fqt[t];
      {name}.lo{sets} = {name}.lo{sets} * fqt[t];
      {name}.up{sets} = {name}.up{sets} * fqt[t];
    $ENDLOOP
    $LOOP G_values:
      {name}.l{sets} = {name}.l{sets} * fvt[t];
      {name}.lo{sets} = {name}.lo{sets} * fvt[t];
      {name}.up{sets} = {name}.up{sets} * fvt[t];
    $ENDLOOP
  $onlisting
  INF_GROWTH_ADJUSTED.l = 0;
$ENDFUNCTION

$FUNCTION growth_adjust_group({group}):
  # Growth adjust a single group of variables (note that dollar-conditions are used here, but not above)
  $offlisting
  $LOOP {group}:
      {name}.l{sets}$({conditions}) = {name}.l{sets} / fqt[t];
  $ENDLOOP
  $onlisting
$ENDFUNCTION

$FUNCTION inf_adjust_group({group}):
  # Inflation adjust a single group of variables
  $offlisting
  $LOOP {group}:
      {name}.l{sets}$({conditions}) = {name}.l{sets} / fpt[t];
  $ENDLOOP
  $onlisting
$ENDFUNCTION

$FUNCTION inf_growth_adjust_group({group}):
  # Growth and inflation adjust a single group of variables. 
  $offlisting
  $LOOP {group}:
      {name}.l{sets}$({conditions}) = {name}.l{sets} / fvt[t];
  $ENDLOOP
  $onlisting
$ENDFUNCTION


# ----------------------------------------------------------------------------------------------------------------------
# Save and load states
# ----------------------------------------------------------------------------------------------------------------------
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
  parameters
    $LOOP {group}:
      {name}__load__{sets}
    $ENDLOOP
  ;
  execute_load {gdx} $LOOP {group}: {name}__load__={name}.l
  $ENDLOOP;
  @set({group}, {suffix}, __load__);
  $onlisting
$ENDFUNCTION

$FUNCTION load({group}, {gdx}):
  $offlisting
  parameters
    $LOOP {group}:
      {name}__load__{sets}
    $ENDLOOP
  ;
  execute_load {gdx} $LOOP {group}: {name}__load__={name}.l
  $ENDLOOP;
  @set({group}, .l, __load__)
  $onlisting
$ENDFUNCTION

$FUNCTION set_linear_combination({group}, {share}, {suffix1}, {suffix2}):
  # Set {group} to a linear combination of current values and parameters with same name except a suffix
  $offlisting
  $LOOP {group}:
    {name}.l{sets}$({conditions}) = {name}{suffix1}{sets} * {share} + (1-{share}) * {name}{suffix2}{sets};
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
    load_d1vHhAkt[portf_,t]
    load_d1vHhPas[portf_,t]
    load_d1vHhPens[pens_,t]
    load_d1vVirkAkt[portf_,t]
    load_d1vVirkPas[portf_,t]
    load_d1vOffAkt[portf_,t]
    load_d1vOffPas[portf_,t]
    load_d1vUdlAkt[portf_,t]
    load_d1vUdlPas[portf_,t]
    load_d1vPensionAkt[portf_,t]
    load_d1Arv[a_,t]
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
    load_d1vHhAkt=d1vHhAkt
    load_d1vHhPas=d1vHhPas
    load_d1vHhPens=d1vHhPens
    load_d1vVirkAkt=d1vVirkAkt
    load_d1vVirkPas=d1vVirkPas
    load_d1vOffAkt=d1vOffAkt
    load_d1vOffPas=d1vOffPas
    load_d1vUdlAkt=d1vUdlAkt
    load_d1vUdlPas=d1vUdlPas
    load_d1vPensionAkt=d1vPensionAkt
    load_d1Arv=d1Arv
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
  d1vHhAkt[portf_,t]$({time_subset}[t]) = load_d1vHhAkt[portf_,t];      
  d1vHhPas[portf_,t]$({time_subset}[t]) = load_d1vHhPas[portf_,t];
  d1vHhPens[pens_,t]$({time_subset}[t]) = load_d1vHhPens[pens_,t];
  d1vVirkAkt[portf_,t]$({time_subset}[t]) = load_d1vVirkAkt[portf_,t];
  d1vVirkPas[portf_,t]$({time_subset}[t]) = load_d1vVirkPas[portf_,t];
  d1vOffAkt[portf_,t]$({time_subset}[t]) = load_d1vOffAkt[portf_,t];
  d1vOffPas[portf_,t]$({time_subset}[t]) = load_d1vOffPas[portf_,t];
  d1vUdlAkt[portf_,t]$({time_subset}[t]) = load_d1vUdlAkt[portf_,t];
  d1vUdlPas[portf_,t]$({time_subset}[t]) = load_d1vUdlPas[portf_,t];
  d1vPensionAkt[portf_,t]$({time_subset}[t]) = load_d1vPensionAkt[portf_,t];
  d1Arv[a_,t]$({time_subset}[t]) = load_d1Arv[a_,t];
$ENDFUNCTION

# Export all variables to GDX files (with and without adjusment for inflation and growth).
$FUNCTION unload({fname}):
  execute_unloaddi '{fname}'
    $LOOP All:, {name} $ENDLOOP
    fpt, fqt, fvt, fp, fq, fv, INF_GROWTH_ADJUSTED, nOvf2nSoc
    a_, a, a0t100, a15t100, a18t100, aTot
    ovf_, ovf, soc
    portf_, portf
    d_, d, s_, s, sBy, x_, x, g_, g, c_, c, i_, i, k_, k
    sTot, kTot
    d1IO, d1IOy, d1IOm, d1Xm, d1Xy, d1CTurist, d1X, d1I_s, d1K, d1R, d1C, d1G, d1Arv
    d1vHhAkt, d1vHhPas, d1vHhPens, d1vVirkAkt, d1vVirkPas
    d1vOffAkt, d1vOffPas, d1vUdlAkt, d1vUdlPas, d1vPensionAkt
    
  ;
$ENDFUNCTION

$FUNCTION unload_all({fname}):
  execute_unloaddi '{fname}';
$ENDFUNCTION

$FUNCTION unload_nominal({fname}):
  @remove_inf_growth_adjustment()
  @unload({fname})
  @inf_growth_adjust()
$ENDFUNCTION

$FUNCTION unload_all_nominal({fname}):
  @remove_inf_growth_adjustment()
  @unload_all({fname})
  @inf_growth_adjust()
$ENDFUNCTION

$FUNCTION unload_group({group}, {fname}):
  execute_unloaddi '{fname}' $LOOP {group}:, {name} $ENDLOOP;
$ENDFUNCTION

$FUNCTION set({group}, {suffix1},  {suffix2}):
  # For each variable in a {group}, assign level from {suffix2} to {suffix1}. I.e. {name}{suffix1}{sets}${conditions} = {name}{suffix2}{sets}
  $offlisting
  $IF "{suffix1}" not in [".l", "", ".fx", ".up", ".lo"]:
    parameters
      $LOOP {group}:
        {name}{suffix1}{sets}
      $ENDLOOP
    ;
  $ENDIF
    $LOOP {group}:
      {name}{suffix1}{sets}${conditions} = {name}{suffix2}{sets};
    $ENDLOOP
  $onlisting
$ENDFUNCTION

$FUNCTION display_difference({group}, {suffix1}, {suffix2}):
# Display differences above 1e-9 for a group of variables (suffixes can be .l for current levels) 

  $offlisting
    $LOOP {group}:
      parameter {name}_difference{sets};
      {name}_difference{sets}${conditions} = {name}{suffix1}{sets} - {name}{suffix2}{sets};
    $ENDLOOP

    $LOOP {group}:
      display$(sum({sets}{$}[+t], abs(round({name}_difference{sets}, 9)))) {name}_difference;
    $ENDLOOP
  $onlisting
$ENDFUNCTION

$FUNCTION assert_no_difference({group}, {threshold}, {suffix1}, {suffix2}, {msg}):
  # Abort if differences exceed the threshold.
  $offlisting
    $LOOP {group}:
      parameter {name}_difference{sets};
      {name}_difference{sets}${conditions} = {name}{suffix1}{sets} - {name}{suffix2}{sets};
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
  $onlisting
$ENDFUNCTION

$FUNCTION assert_abs_smaller({group}, {threshold}, {suffix1}, {suffix2}, {msg}):
  # Abort if absolute value of variables has increased by more than {threshold}.
  $offlisting
    $LOOP {group}:
      parameter {name}_absolute_increase{sets};
      {name}_absolute_increase{sets}${conditions} = abs({name}{suffix1}{sets}) - abs({name}{suffix2}{sets});
      {name}_absolute_increase{sets}$(abs({name}_absolute_increase{sets}) < {threshold}) = 0;
      if (sum({sets}{$}[+t]${conditions}, abs({name}_absolute_increase{sets})),
        display {name}_absolute_increase;
      );
    $ENDLOOP
    $LOOP {group}:
      loop({sets}{$}[+t]${conditions},
        abort$({name}_absolute_increase{sets} <> 0) 'The absolute value of {name} has increased by more than {threshold}! {msg}';
      )
    $ENDLOOP
  $onlisting
$ENDFUNCTION

$FUNCTION display_zeros({group}, {gdx}):
  # Display variables that have become 0 in current data eg static calibration, but was not 0 in previous data eg static calibration
  #          and variables that is not 0 in current data eg static calibration, but was 0 in previous data eg static calibration
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

# Load a group of parameters from a GDX file
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
      {name}{sets}$({conditions} and {name}.lo{sets} = {name}.up{sets})
    $ENDLOOP
$ENDFUNCTION

$FUNCTION unfixed({group}):
    $LOOP {group}:
      {name}{sets}$({conditions} and {name}.lo{sets} <> {name}.up{sets})
    $ENDLOOP
$ENDFUNCTION

# Example: is_fixed(a[t]) -> a.lo[t] = a.up[t]
$FUNCTION is_fixed({var_and_sets})
  $REPLACE('[', '.up['){var_and_sets}$ENDREPLACE = $REPLACE('[', '.lo['){var_and_sets}$ENDREPLACE
$ENDFUNCTION

# Example: is_unfixed(a[t]) -> a.lo[t] <> a.up[t]
$FUNCTION is_unfixed({var_and_sets})
  $REPLACE('[', '.up['){var_and_sets}$ENDREPLACE <> $REPLACE('[', '.lo['){var_and_sets}$ENDREPLACE
$ENDFUNCTION

# Procedure for comparing the values of a group of variables in two different GDX files
$FUNCTION compare({group}, {gdx1}, {gdx2}):
  @load_as({group}, {gdx1}, _gdx1);
  @load_as({group}, {gdx2}, _gdx2);

  $offlisting
  $onDotL

  # Set NAs and other special values to zero
  $LOOP {group}:
    {name}_gdx1{sets}$(mapVal({name}_gdx1{sets}) > 0) = 0;
    {name}_gdx2{sets}$(mapVal({name}_gdx2{sets}) > 0) = 0;
  $ENDLOOP

  $LOOP {group}:
    parameter {name}_is_zero_now{sets};
    {name}_is_zero_now{sets}${conditions} = (abs({name}_gdx1{sets}) < 1e-9) and not (abs({name}_gdx2{sets}) < 1e-9);
  $ENDLOOP

  $LOOP {group}:
    display$(sum({sets}{$}[+t], {name}_is_zero_now{sets})) {name}_is_zero_now;
  $ENDLOOP

  $LOOP {group}:
    parameter {name}_is_not_zero_now{sets};
    {name}_is_not_zero_now{sets}${conditions} = (abs({name}_gdx1{sets}) >= 1e-9) and (abs({name}_gdx2{sets}) < 1e-9);
  $ENDLOOP

  $LOOP {group}:
    display$(sum({sets}{$}[+t], {name}_is_not_zero_now{sets})) {name}_is_not_zero_now;
  $ENDLOOP


  $LOOP {group}:
    parameter {name}_difference{sets};
    {name}_difference{sets}${conditions} = {name}_gdx1{sets} - {name}_gdx2{sets};
    {name}_difference{sets}$(abs({name}_difference{sets}) < 0.5) = 0; # Remove differences below cutoff
    display$(sum({sets}{$}[+t], {name}_difference{sets})) {name}_difference;

    parameter {name}_pctgrowth{sets};
    {name}_pctgrowth{sets}$({conditions} and abs({name}_gdx2{sets}) > 1e9) = ({name}_gdx1{sets} / {name}_gdx2{sets} - 1) * 100;
    {name}_pctgrowth{sets}$(abs({name}_pctgrowth{sets}) < 10) = 0; # Remove differences below cutoff
    display$(sum({sets}{$}[+t], {name}_pctgrowth{sets})) {name}_pctgrowth;
  $ENDLOOP


  $offDotL
  $onlisting
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
  # {model}.workfactor = 2;
  #  {model}.workspace = 8000;
  #  {model}.tolinfeas = 1e-12;
  @print("---------------------------------------- Solve start ----------------------------------------")
  solve {model} using CNS;
  abort$({model}.solveStat > 1) "Solver did not complete normally";
  @print("---------------------------------------- Solve finished ----------------------------------------")
$ENDFUNCTION

$FUNCTION bound({group}, {lo}, {up}):
  # Set bounds on {group} to {lo}, {up}, for variables that are not fixed
  $offlisting
  $LOOP {group}:
      {name}.lo{sets}$({conditions} and {name}.up{sets} <> {name}.lo{sets}) = {lo}; # .lo == .up means that a variable is fixed
      {name}.up{sets}$({conditions} and {name}.up{sets} <> {name}.lo{sets}) = {up};
  $ENDLOOP
  $onlisting
$ENDFUNCTION

$FUNCTION set_initial_levels_to_nonzero({group}):
  # Set better initial levels for that are zero
  $offlisting

  $GROUP G_set_initial_levels_to_nonzero
    {group}
    -jfpIOy_s, -jfpIOm_s
  ;

  $LOOP G_set_initial_levels_to_nonzero:
    # Set NAs and other special values to zero
    {name}.l{sets}$({conditions} and mapVal({name}.l{sets}) > 0) = 0;

    # If the variable 1) has a starting level of 0 and 2) has a non-zero level in t1 => set starting level to t1
    {name}.l{sets}$(
            {conditions}
       and ({name}.l{sets} = 0)
       and ({name}.l{sets}{$}[<t>t1] <> 0)) = {name}.l{sets}{$}[<t>t1];
    # If the variable 1) has a starting level of 0 and 2) has a non-zero level in t0 => set starting level to t0
    {name}.l{sets}$(
            {conditions}
       and ({name}.l{sets} = 0)
       and ({name}.l{sets}{$}[<t>t0] <> 0)) = {name}.l{sets}{$}[<t>t0];
    # If variable still has a staring level of 0, set the starting level to the maximum absolute value of all periods
    {name}.l{sets}$({conditions} and ({name}.l{sets} = 0)) = max(smax(tt, abs({name}.l{sets}{$}[<t>tt])), 0.01);
  $ENDLOOP

  $onlisting
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


# ----------------------------------------------------------------------------------------------------------------------
# HP-filter
# ----------------------------------------------------------------------------------------------------------------------
# Apply an HP-filter to the input variable
$FUNCTION HPfilter({name}, {lamb}, start_year, end_year)
embeddedCode Python:
  import dreamtools as dt
  import pandas as pd
  from statsmodels.tsa.filters.hp_filter import hpfilter

  name = "{name}"
  db = dt.GamsPandasDatabase(gams.db)

  assert isinstance(start_year, int), "Start year must be an integer"
  assert isinstance(end_year, int), "End year must be an integer"

  mask = (db[name].index.get_level_values("t") >= start_year) & \
        (db[name].index.get_level_values("t") <= end_year)
  data_to_filter = db[name][mask]
  levels = data_to_filter.index.names

  if len(levels) == 1:
      filtered_values = hpfilter(data_to_filter, {lamb})[1]
  else:
      filtered_values = data_to_filter.groupby(levels[:-1]).transform(lambda x: hpfilter(x.values, {lamb})[1])

  db[name][mask] = filtered_values
  db.save_series_to_database()
  gams.set(name, db.symbols[name])
endEmbeddedCode {name}
$ENDFUNCTION