# ======================================================================================================================
# Model definition
# ======================================================================================================================
# In this file we define the sets, variables, and equations that comprise the model.
# The variables and equations are organized in groups of variable and blocks of equation.
# We combine the module-specific groups into bigger groups. 
# Finally, we combine the blocks of equations to get the basic model.


# ======================================================================================================================
# Functions
# ======================================================================================================================
$IMPORT functions.gms


# ======================================================================================================================
# Variables
# ======================================================================================================================
# ----------------------------------------------------------------------------------------------------------------------
# Variable definitions
# ----------------------------------------------------------------------------------------------------------------------
@import_from_modules("variables")

# ----------------------------------------------------------------------------------------------------------------------
# Group compilation
# ----------------------------------------------------------------------------------------------------------------------
# Endogenous variables
# We combine the endo groups from each module into a group of all endogenous variables.
$GROUP G_Endo
	G_exports_endo
	G_labor_market_endo
	G_pricing_endo
	G_production_private_endo
  G_production_public_endo
	G_finance_endo
	G_consumers_endo
	G_government_endo
	G_GovRevenues_endo
	G_GovExpenses_endo
	G_taxes_endo
	G_aggregates_endo
	G_IO_endo
	G_HHincome_endo	
  G_struk_endo
;

# To make growth and inflation adjustment easier, we create groups for all prices, quantities, and values respectively.
$GROUP G_prices  # Variables that should be adjusted for inflation
	G_exports_prices
	G_labor_market_prices
	G_pricing_prices
	G_production_private_prices
  G_production_public_prices
	G_finance_prices  
	G_consumers_prices
	G_government_prices
	G_GovRevenues_prices
	G_GovExpenses_prices
	#  G_taxes_prices
	G_aggregates_prices
	G_IO_prices
	G_HHincome_prices
  G_struk_prices
  G_post_prices
;

$GROUP G_quantities  # Variables that should be adjusted for general productivity growth
	G_exports_quantities
  G_labor_market_quantities
  G_pricing_quantities
	G_production_private_quantities
  G_production_public_quantities
	G_consumers_quantities
	G_finance_quantities
	G_government_quantities
	G_GovRevenues_quantities
	G_GovExpenses_quantities
  #  G_taxes_quantities
	G_aggregates_quantities
	G_IO_quantities
	G_HHincome_quantities
  G_struk_quantities
  G_post_quantities
;
$GROUP G_values  # Variables that should both be adjusted for inflation and general productivity growth
  G_exports_values
	G_labor_market_values
  G_pricing_values
	G_production_private_values
  G_production_public_values
	G_consumers_values
	G_finance_values
	G_government_values
	G_GovRevenues_values
	G_GovExpenses_values
	G_taxes_values
	G_aggregates_values
	G_IO_values
	G_HHincome_values
  G_struk_values
  G_post_values
;

# Group of variables that we force the solver to keep strictly positive.
$GROUP G_lower_bound # Variables with only a lower bound close to zero
  qKLB, qY, qR, qX, qBNP, qBVT,
  srMatch, fDeltag, sfDeltag, rOpslag2soeg, srOpslag2soeg
  uh, hLHh
;
$GROUP G_zero_bound  # Variables with a lower bound very close to zero
  nSoegBaseHh, srJobFinding, snSoegBaseHh, qCRxRef, qNytte, qFormueBase, qArvBase
  pK, pBVT, qCR, mUC, EmUC, qBolig, qBoligRxRef, qBoligR, mUBolig, uR, uKLB, uL, uK, uKL, pKLB, pKL
;
$GROUP G_lower_upper_bound  # Variables bounded closer to 1 (to avoid negative prices and chain indices going to infinity)
  G_prices, rKUdn, rpIOm2pIOy, rpM2pXm, -G_lower_bound, -G_zero_bound
  -pI$(sameas[i_,'iL']), -pI_s$(sameas[i_,'iL']), -pIO$(sameas[d_,'iL']), -pIOy$(sameas[d_,'iL']) # Negative in 'data' before 1999
;
$GROUP G_unit_interval_bound  # Variables bounded between 0 and 1
  uBolig,
;


# ======================================================================================================================
# Equations
# ======================================================================================================================
# Equations are defined in each module and organized in "blocks". They are imported here.
@import_from_modules("equations")

# ----------------------------------------------------------------------------------------------------------------------
# Main model
# ----------------------------------------------------------------------------------------------------------------------
# We define the model as the combination of equation blocks from each imported module
$GROUP G_Endo
  G_exports_endo
  G_labor_market_endo
  G_pricing_endo
  G_production_private_endo
  G_production_public_endo
  G_finance_endo
  G_consumers_endo
  G_government_endo
  G_GovRevenues_endo
  G_GovExpenses_endo
  G_taxes_endo
  G_aggregates_endo
  G_IO_endo
  G_HHincome_endo 
  G_struk_endo
;

$MODEL M_base
	B_taxes
	B_exports
	B_production_private
  B_production_public
	B_finance
	B_pricing
	B_labor_market
	B_consumers
	B_government
	B_GovRevenues
	B_GovExpenses
	B_IO
	B_aggregates
	B_HHincome	
  B_struk
;

# ======================================================================================================================
# Read baseline and parameters from GDX file
# ======================================================================================================================
execute_load "Gdx\stiliseret_grundforloeb.gdx"
  $LOOP All:, {name} $ENDLOOP
  $LOOP pG_dummies:, {name} $ENDLOOP
  , snSocFraBesk, snSocResidual
;

# ======================================================================================================================
# Tests
# ======================================================================================================================
set_time_periods(2025, %terminal_year%);

# Aggregation tests
$IMPORT tests.gms;

# ----------------------------------------------------------------------------------------------------------------------
# Zero shock  -  Abort if a zero shock changes any variables significantly
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_ZeroShockTest All, -dArv;

@save(G_ZeroShockTest)
$FIX All; $UNFIX G_endo;
@solve(M_base);
$FIX All; $UNFIX G_post_endo;
@solve(B_post);

@assert_no_difference(G_ZeroShockTest, 1e-6, "Zero shock changed variables significantly.");
