# ======================================================================================================================
# Shock template
# ======================================================================================================================
# Select first endogenous year and whether to include a public tax reaction function
$SETLOCAL shock_year 2030;
$SETLOCAL tax_reaction 0;

$onDotL # Allow implicit .l suffix
set_time_periods(%shock_year%-1, %terminal_year%);

# Load baseline
$GROUP G_load All, -res_;
@load_as(G_load, "Gdx/baseline.gdx", .l)
@load_dummies(t, "Gdx/baseline.gdx")
@set(All, _baseline, .l)  # creates _baseline parameter for all variables

# ----------------------------------------------------------------------------------------------------------------------
# Tax reaction
# ----------------------------------------------------------------------------------------------------------------------
$BLOCK B_fiscal_reaction G_fiscal_reaction
  vtLukning[aTot,t]$(tx0E[t] and %tax_reaction%).. tLukning[t] =E= tLukning[tEnd];
  vtLukning&_tEnd[aTot,t]$(tEnd[t] and %tax_reaction%).. vOff13Net[t] / vBNP[t] =E= vOff13Net_baseline[t] / vBNP_baseline[t];
$ENDBLOCK
MODEL M_shock /
  M_base
  B_fiscal_reaction
/;
$GROUP G_shock_endo G_endo, G_fiscal_reaction;

# ----------------------------------------------------------------------------------------------------------------------
# Change the shock here - tx0[t] is the subset of time periods that are endogenous
# ----------------------------------------------------------------------------------------------------------------------
hL[off,t]$(tx0[t]) = hL[off,t] * 1.01;

# ----------------------------------------------------------------------------------------------------------------------
# Solve shock
# ----------------------------------------------------------------------------------------------------------------------
# Reduce shock size by a factor of 100 to make solving easier
@set_linear_combination(All, 0.01, .l, _baseline);
$FIX All; $UNFIX G_shock_endo;
@solve(M_shock);
# Set all variables to baseline plus 100 times the difference between the solution and the baseline
@set_linear_combination(All, 100, .l, _baseline);
$FIX All; $UNFIX G_shock_endo;
@solve(M_shock);

@unload(Gdx/shock);