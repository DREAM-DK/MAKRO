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
    $ENDLOOP
    $LOOP G_quantities:
      {name}.l{sets} = {name}.l{sets} * growth_factor[t];
    $ENDLOOP
    $LOOP G_values:
      {name}.l{sets} = {name}.l{sets} * inf_growth_factor[t];
    $ENDLOOP
  $onlisting
  INF_GROWTH_ADJUSTED.l = 1;
$ENDFUNCTION

#  $FUNCTION inf_growth_adjust():
#    abort$(INF_GROWTH_ADJUSTED.l) "Trying to adjust for inflation and growth, but model is already adjusted.";
#    $LOOP All:
#      $IF "{name}".startswith("p"):
#        {name}.l{sets} = {name}.l{sets} * inf_factor[t];
#      $ENDIF
#      $IF "{name}".startswith("q"):
#        {name}.l{sets} = {name}.l{sets} * growth_factor[t];
#      $ENDIF
#      $IF "{name}".startswith("v"):
#        {name}.l{sets} = {name}.l{sets} * inf_growth_factor[t];
#      $ENDIF
#    $ENDLOOP
#    INF_GROWTH_ADJUSTED.l = 1;
#  $ENDFUNCTION

# Remove inflation and growth adjustment
$FUNCTION remove_inf_growth_adjustment():
  abort$(not INF_GROWTH_ADJUSTED.l) "Trying to remove inflation and growth adjustment, but model is already nominal.";
  $offlisting
    $LOOP G_prices:
      {name}.l{sets} = {name}.l{sets} / inf_factor[t];
    $ENDLOOP
    $LOOP G_quantities:
      {name}.l{sets} = {name}.l{sets} / growth_factor[t];
    $ENDLOOP
    $LOOP G_values:
      {name}.l{sets} = {name}.l{sets} / inf_growth_factor[t];
    $ENDLOOP
  $onlisting
  INF_GROWTH_ADJUSTED.l = 0;
$ENDFUNCTION

#  $FUNCTION remove_inf_growth_adjustment():
#    abort$(not INF_GROWTH_ADJUSTED.l) "Trying to remove inflation and growth adjustment, but model is already nominal.";
#    $LOOP All:
#      $IF "{name}".startswith("p"):
#        {name}.l{sets} = {name}.l{sets} / inf_factor[t];
#      $ENDIF
#      $IF "{name}".startswith("q"):
#        {name}.l{sets} = {name}.l{sets} / growth_factor[t];
#      $ENDIF
#      $IF "{name}".startswith("v"):
#        {name}.l{sets} = {name}.l{sets} / inf_growth_factor[t];
#      $ENDIF
#    $ENDLOOP
#    INF_GROWTH_ADJUSTED.l = 0;
#  $ENDFUNCTION


# ----------------------------------------------------------------------------------------------------------------------
# Save and load states
# ----------------------------------------------------------------------------------------------------------------------
# Load levels of group from GDX file 
$FUNCTION load({group}, {gdx}):
  $offlisting
  $GROUP __load_group {group};
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

# Export all variables to GDX files (with and without adjusment for inflation and growth).
$FUNCTION unload({fname}):
  execute_unloaddi '{fname}'
    $LOOP All:, {name} $ENDLOOP
    $LOOP pG_dummies:, {name} $ENDLOOP
    inf_factor, growth_factor, inf_growth_factor, fp, fq, fv, INF_GROWTH_ADJUSTED.l, soc, nOvf2Soc
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
  $offlisting
    $LOOP {group}:
      parameter {name}{suffix}{sets};
      {name}{suffix}{sets}${conditions} = {name}.l{sets};
    $ENDLOOP
  $onlisting
$ENDFUNCTION

# Save the values of a group of variables so that they can later be recalled.
$FUNCTION save({group}):
  @save_as({group}, _saved)
$ENDFUNCTION

# Reset the values of a group of variables to the levels saved previously. 
$FUNCTION reset_to({group}, {suffix}):
  $offlisting
    $LOOP {group}:
      {name}.l{sets}${conditions} = {name}{suffix}{sets};
    $ENDLOOP
  $onlisting
$ENDFUNCTION

$FUNCTION reset({group}):
  @reset_to({group}, _saved)
$ENDFUNCTION

# Display the difference between the current values of a group of variables and the previously saved values.
$FUNCTION display_difference({group}):
  $offlisting;
    $LOOP {group}:
      parameter {name}_difference{sets};
      {name}_difference{sets}${conditions} = {name}.l{sets} - {name}_saved{sets};
    $ENDLOOP

  # Differences above E-9:
    $LOOP {group}:
      display$(sum({sets}{$}[+t], abs(round({name}_difference{sets}, 9)))) {name}_difference;
    $ENDLOOP
  $onlisting;
$ENDFUNCTION

# Abort if differences exceed the threshold. Differences are between the current values of a group of variables and the previously saved values.
$FUNCTION assert_no_difference_from({group}, {threshold}, {suffix}, {msg}):
  $offlisting;
    $LOOP {group}:
      parameter {name}_difference{sets};
      {name}_difference{sets}${conditions} = {name}.l{sets} - {name}{suffix}{sets};
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
  $onlisting;
$ENDFUNCTION

$FUNCTION assert_no_difference({group}, {threshold}, {msg}):
  @assert_no_difference_from({group}, {threshold}, _saved, {msg})
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
  solve {model} using CNS;
  @print("---------------------------------------- Solve finished ----------------------------------------")
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

$FUNCTION NLP_solve({model}, {group}, {GDX}):
  @save({group})
  @load({group}, {GDX});
  @save_as({group}, _target)
  @reset({group})
  $GROUP G_endo G_endo, objective "dummy objective";
  $BLOCK B_{model}_{group}
    E_objective_{model}_{group}..
      objective =E= 0 
      $LOOP {group}:
        + sum({sets}${conditions}, sqr({name}{sets} - {name}_target{sets}))
      $ENDLOOP
    ;
  $ENDBLOCK
  $MODEL {model}_{group} {model}, E_objective_{model}_{group};
  $UNFIX {group};
  {model}_{group}.optfile = 1;
  {model}_{group}.holdFixed = 1;
  {model}_{group}.workfactor = 3;
  {model}_{group}.scaleopt = 1;
  solve {model}_{group} using NLP minimizing objective;
$ENDFUNCTION

# ----------------------------------------------------------------------------------------------------------------------
# Other
# ----------------------------------------------------------------------------------------------------------------------
FILE logfile /''/;
$FUNCTION print({msg}):
  PUT logfile;
  PUT_UTILITY "log" / {msg};
$ENDFUNCTION

$FUNCTION copy_equation_to_period({equation},{time}):
  $LOOP00 {equation}:
    $REGEX("tx[01]?E?\[t\]","{time}[t]") {name}_{time}{sets}${conditions}.. {LHS} =E= {RHS}; $ENDREGEX
  $ENDLOOP00
$ENDFUNCTION


# ----------------------------------------------------------------------------------------------------------------------
# Local linear Regression functions
# ----------------------------------------------------------------------------------------------------------------------
# Smooth {var} using local linear regression with bandwidth {h}
$FUNCTION LLreg({var}, {h}, {dim}):
  parameters
    LLregBandwith "Bandwidth for Local linear smoothing"
    LLregStore_{var}[*,t] "Container for Local linear smoothing"
    start_year
    end_year
  ;
  LLregBandwith = {h};
  start_year = %cal_start%;
  end_year = %cal_end%;

  execute_unloaddi 'Gdx\LLreg_pre.gdx' {var}=y, LLregBandwith=h, {dim}=dim, start_year, end_year;
  execute "%R% --slave --vanilla --file=LLreg.R";  
  execute_load 'Gdx\LLreg_post.gdx', LLregStore_{var}=gdx_variable;
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