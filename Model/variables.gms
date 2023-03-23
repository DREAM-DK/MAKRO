# ======================================================================================================================
# Variables
# ======================================================================================================================
# In this file we define the variables in comprise the model.
# The variables are organized in groups.
# We combine the module-specific groups into bigger groups. 

# We need to set tBFR
tBFR[t] = yes$(2000 < t.val and t.val <= 2099);

# ----------------------------------------------------------------------------------------------------------------------
# Variable definitions
# ----------------------------------------------------------------------------------------------------------------------
@import_from_modules("variables")

# ----------------------------------------------------------------------------------------------------------------------
# Parameter definitions
# ----------------------------------------------------------------------------------------------------------------------
# Adjustment for inflation and growth
parameters
  fq "1 year adjustment factor for growth in quantities"
  fp "1 year adjustment factor for price inflation"
  fv "1 year composite growth and inflation factor to adjust for growth in values"
  growth_factor[t] "Geometric series of fq, set to 1 in base_year"
  inf_factor[t] "Geometric series of fp, set to 1 in base_year"
  inf_growth_factor[t] "Geometric series of fv, set to 1 in base_year"
;

# ----------------------------------------------------------------------------------------------------------------------
# Group compilation
# ----------------------------------------------------------------------------------------------------------------------
# Endogenous variables
# We combine the endo groups from each module into a group of all endogenous variables.
$GROUP G_Endo
  G_aggregates_endo
  G_consumers_endo
  G_exports_endo
  G_finance_endo
  G_government_endo
  G_GovExpenses_endo
  G_GovRevenues_endo
  G_HHincome_endo 
  G_IO_endo
  G_labor_market_endo
  G_pricing_endo
  G_production_private_endo
  G_production_public_endo
  G_struk_endo
  G_taxes_endo
;

# To make growth and inflation adjustment easier, we create groups for all prices, quantities, and values respectively.
$GROUP G_prices  # Variables that should be adjusted for inflation
  G_aggregates_prices
  G_consumers_prices
  G_exports_prices
  G_finance_prices  
  G_government_prices
  G_GovExpenses_prices
  G_GovRevenues_prices
  G_HHincome_prices
  G_IO_prices
  G_labor_market_prices
  G_pricing_prices
  G_production_private_prices
  G_production_public_prices
  G_struk_prices
  #  G_taxes_prices
;

$GROUP G_quantities  # Variables that should be adjusted for general productivity growth
  G_aggregates_quantities
  G_consumers_quantities
  G_exports_quantities
  G_finance_quantities
  G_government_quantities
  G_GovExpenses_quantities
  G_GovRevenues_quantities
  G_HHincome_quantities
  G_IO_quantities
  G_labor_market_quantities
  G_pricing_quantities
  G_production_private_quantities
  G_production_public_quantities
  G_struk_quantities
  #  G_taxes_quantities
;
$GROUP G_values  # Variables that should both be adjusted for inflation and general productivity growth
  G_aggregates_values
  G_consumers_values
  G_exports_values
  G_finance_values
  G_government_values
  G_GovExpenses_values
  G_GovRevenues_values
  G_HHincome_values
  G_IO_values
  G_labor_market_values
  G_pricing_values
  G_production_private_values
  G_production_public_values
  G_struk_values
  G_taxes_values
;

$GROUP G_forecast_as_zero
  G_aggregates_forecast_as_zero$(tx1[t])
  G_consumers_forecast_as_zero$(tx1[t])
  #  G_exports_forecast_as_zero$(tx1[t])
  G_finance_forecast_as_zero$(tx1[t])
  G_government_forecast_as_zero$(tx1[t])
  G_GovExpenses_forecast_as_zero$(tx1[t])
  G_GovRevenues_forecast_as_zero$(tx1[t])
  G_HHincome_forecast_as_zero$(tx1[t])    
  #  G_IO_forecast_as_zero$(tx1[t])
  G_labor_market_forecast_as_zero$(tx1[t])
  G_pricing_forecast_as_zero$(tx1[t])
  G_production_private_forecast_as_zero$(tx1[t])
  G_production_public_forecast_as_zero$(tx1[t])
  #  G_struk_forecast_as_zero$(tx1[t])
;

$GROUP G_exogenous_forecast
  #  G_aggregates_exogenous_forecast$(tx1[t])
  G_consumers_exogenous_forecast$(tx1[t])
  G_exports_exogenous_forecast$(tx1[t])
  G_finance_exogenous_forecast$(tx1[t])
  G_government_exogenous_forecast$(tx1[t])
  G_GovExpenses_exogenous_forecast$(tx1[t])
  G_GovRevenues_exogenous_forecast$(tx1[t])
  G_HHincome_exogenous_forecast$(tx1[t])    
  G_IO_exogenous_forecast$(tx1[t])
  G_labor_market_exogenous_forecast$(tx1[t])
  G_pricing_exogenous_forecast$(tx1[t])
  G_production_private_exogenous_forecast$(tx1[t])
  G_production_public_exogenous_forecast$(tx1[t])
  G_struk_exogenous_forecast$(tx1[t])
  G_taxes_exogenous_forecast$(tx1[t])
;

$GROUP G_constants
  #  G_aggregates_constants
  G_consumers_constants
  G_exports_constants
  G_finance_constants
  #  G_government_constants
  G_GovExpenses_constants
  #  G_GovRevenues_constants
  G_HHincome_constants
  G_IO_constants
  G_labor_market_constants
  G_pricing_constants
  G_production_private_constants
  #  G_production_public_constants
  #  G_struk_constants
;

# Group of variables that we force the solver to keep strictly positive.
$GROUP G_lower_bound # Variables with only a lower bound close to zero
  qKLB, qY, qR, qX, qBNP, qBVT,
  srMatch, rpXy2pXUdl
  uh, hLHh
  nOpslag$(sTot[s_]), snOpslag
;
$GROUP G_zero_bound  # Variables with a lower bound very close to zero
  srJobFinding
  pBoligUC, qCR, mUC, EmUC, qBoligRxRef, qBoligR, qBoligHtM, mUBolig, qCRxRef, qNytte, qFormueBase, qArvBase
  pK, pKUdn, uR, uKLB, uL, uK, uKL, pKLB, pKL
;
$GROUP G_lower_upper_bound  # Variables bounded closer to 1 (to avoid negative prices and chain indices going to infinity)
  G_prices, rKUdn, rpIOm2pIOy, rpXm2pM, -G_lower_bound, -G_zero_bound
  -pI$(iL[i_]), -pI_s$(iL[i_]), -pIO$(iL[d_]), -pIOy$(iL[d_]) # Negative in 'data' before 1999 
  -pCPI, -pnCPI # Disse bør fjernes med dummies i modulet istedet
;
$GROUP G_unit_interval_bound  # Variables bounded between 0 and 1
  uBoligR
;