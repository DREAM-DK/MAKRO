# ======================================================================================================================
# BFR shock (template for shocking sattelite population and socioeconomic projection models - BFR)
# ======================================================================================================================
$onDotL # Allow implicit .l suffix

# Select first endogenous year
$SETLOCAL shock_year 2027;
set_time_periods(%shock_year%-1, %terminal_year%);

# Load baseline
@load_as(All, "Gdx/baseline.gdx", .l)
@load_dummies(t, "Gdx/baseline.gdx")
@set(All, _baseline, .l)  # creates _baseline parameter for all variables

# Variables to be read from BFR data files
$GROUP G_BFR_shock
  rOverlev, ErOverlev,
  nPop, nPop_Over100, 
  snLHh, shLHh,
  snSoc
  snLxDK, shLxDK,
  nOvf2nSoc
;
$GROUP G_BFR_shock G_BFR_shock$(tx0[t]);
# Load variables from BFR baseline GDX file
@load_as(G_BFR_shock, "Gdx/BFR_baseline.gdx", _BFR_baseline);
# Load variables from BFR shock GDX file
@load_as(G_BFR_shock, "Gdx/BFR_shock.gdx", _shock);

# Differences between baseline and shock BFR is added as shocks to the MAKRO baseline.
# This is equivalent to just setting variable the BFR shock levels directly,
# if the BFR baseline is the same as was used to calibrate the MAKRO baseline.
# Taking differences is useful, if for example FM BFR is used in the MAKRO baseline,
# but the shock is computed using DREAM's BFR. Or if a slighly older or newer version of BFR is used.
$LOOP G_BFR_shock:
  {name}{sets}$(tx0[t])
    = {name}{sets} + ({name}_shock{sets} - {name}_BFR_baseline{sets});
$ENDLOOP

# Changes in productivity are read from GDX files (due to gender and origin composition)
parameter qProdHh_a_DREAM_baseline[a,t], qProdHh_a_DREAM_shock[a,t];
execute_load "Gdx/qProdHh_a_DREAM_baseline.gdx" qProdHh_a_DREAM_baseline=qProdHh_a_DREAM;
execute_load "Gdx/qProdHh_a_DREAM_shock.gdx" qProdHh_a_DREAM_shock=qProdHh_a_DREAM;
qProdHh_a[a,t]$(tx0[t] and qProdHh_a_DREAM_baseline[a,t] <> 0)
  = qProdHh_a[a,t] * qProdHh_a_DREAM_shock[a,t] / qProdHh_a_DREAM_baseline[a,t];

# Changes in demographic pull on government consumption are read from GDX files
@load_as(fDemoTraek, "Gdx/DemoTraek_baseline.gdx", _BFR_baseline);
@load_as(fDemoTraek, "Gdx/DemoTraek_shock.gdx", _shock);
fDemoTraek[a,t]$(tx0[t] and fDemoTraek_BFR_baseline[a,t] <> 0)
  = fDemoTraek[a,t] * fDemoTraek_shock[a,t] / fDemoTraek_BFR_baseline[a,t];

# Recalculate number of heirs (calculation with a*a matrix is heavy and therefore outside model)
nArvinger[a,t]$(tx0[t]) = sum(aa, rArv_a[a-1,aa-1] * nPop[aa,t]);

$GROUP G_shock_endo
  G_endo

# Structural employment is exogenized, labor market preference parameters are endogenized
  -snLHh[a15t100,tx0], uDeltag[a15t100,tx0]
  -shLHh[a15t100,tx0], uh[a15t100,tx0]
  -snLxDK[tx0], nSoegBasexDK[tx0]

# Government production inputs are endogenized based on fixed budget shares and demographic pull
  -uvGInd[tx0], hL['off',tx0]
  -rOffK2Y[k,tx0], qI_s[k,'off',tx0]
  -rOffLoensum2R[tx0], qR['off',tx0]
  -rOffLoensum2E[tx0], qE['off',tx0]
;

# ----------------------------------------------------------------------------------------------------------------------
# Solve unfinanced shock
# ----------------------------------------------------------------------------------------------------------------------
$FIX All; $UNFIX G_shock_endo;
@solve(M_base);
$UNFIX All; # Greatly reduces size of the GDX file
@unload(Gdx/BFR_shock_unfinanced);

# ----------------------------------------------------------------------------------------------------------------------
# Solve shock financed with lump-sum transfer
# ----------------------------------------------------------------------------------------------------------------------
$BLOCK B_fiscal_reaction G_fiscal_reaction
  vtLukning[aTot,t]$(tx0E[t]).. tLukning[t] =E= tLukning[tEnd];
  vtLukning&_tEnd[aTot,t]$(tEnd[t]).. vOff13Net[t] / vBNP[t] =E= vOff13Net_baseline[t] / vBNP_baseline[t];
$ENDBLOCK
MODEL M_tax_financed /
  M_base
  B_fiscal_reaction
/;
# Better starting values for lump-sum transfer
tLukning[t]$(tx0[t]) = rHBI_baseline[t1] - rHBI[t1];
vtLukning[a,t]$(tx0[t]) = tLukning[t] * vtHhx[a,t];
vtLukning[aTot,t]$(tx0[t]) = tLukning[t] * vtHhx[aTot,t];

$FIX All; $UNFIX G_shock_endo, G_fiscal_reaction;
@solve(M_tax_financed);
$UNFIX All; # Greatly reduces size of the GDX file
@unload(Gdx/BFR_shock_tax_financed);