# ======================================================================================================================
# Variables
# ======================================================================================================================
# In this file we define the variables in comprise the model.
# The variables are organized in groups.
# We combine the module-specific groups into bigger groups. 

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
  G_aggregates_endo
  G_consumers_endo
  G_exports_endo
  G_finance_endo
  # G_government_endo
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

$GROUP G_forecast_as_zero
  G_aggregates_forecast_as_zero$(tx1[t])
  G_consumers_forecast_as_zero$(tx1[t])
  #  G_exports_forecast_as_zero$(tx1[t])
  G_finance_forecast_as_zero$(tx1[t])
  G_government_forecast_as_zero$(tx1[t])
  G_GovExpenses_forecast_as_zero$(tx1[t])
  G_GovRevenues_forecast_as_zero$(tx1[t])
  G_HHincome_forecast_as_zero$(tx1[t])    
  G_IO_forecast_as_zero$(tx1[t])
  G_labor_market_forecast_as_zero$(tx1[t])
  G_pricing_forecast_as_zero$(tx1[t])
  G_production_private_forecast_as_zero$(tx1[t])
  G_production_public_forecast_as_zero$(tx1[t])
  G_struk_forecast_as_zero$(tx1[t])
  G_taxes_forecast_as_zero$(tx1[t])
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
