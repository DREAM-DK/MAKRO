# ======================================================================================================================
# Equations
# ======================================================================================================================
# Equations are defined in each module and organized in "blocks". They are imported here.
@import_from_modules("equations")

# ----------------------------------------------------------------------------------------------------------------------
# Main model
# ----------------------------------------------------------------------------------------------------------------------
# We define the model as the combination of equation blocks from each imported module
MODEL M_base /
  M_aggregates
  M_consumers - M_consumers_post
  M_exports - M_exports_post
  M_finance - M_finance_post
  M_government - M_Government_post
  M_GovExpenses - M_GovExpenses_post
  M_GovRevenues - M_GovRevenues_post
  M_HHincome - M_HHincome_post
  M_IO - M_IO_post
  M_labor_market - M_labor_market_post
  M_pricing - M_pricing_post
  M_production_private - M_production_private_post
  M_production_public
  M_struk
  B_taxes - M_taxes_post
/;

# ----------------------------------------------------------------------------------------------------------------------
# Post model
# ----------------------------------------------------------------------------------------------------------------------
MODEL M_post /
  M_consumers_post
  M_exports_post
  M_finance_post
  M_Government_post
  M_GovExpenses_post
  M_GovRevenues_post
  M_HHincome_post
  M_IO_post
  M_labor_market_post
  M_production_private_post
  M_pricing_post
  M_taxes_post
/;
$GROUP G_post
  G_consumers_post
  G_exports_post
  G_finance_post
  G_Government_post
  G_GovExpenses_post
  G_GovRevenues_post
  G_HHincome_post
  G_IO_post
  G_labor_market_post
  G_production_private_post
  G_pricing_post
  G_taxes_post
;

# ----------------------------------------------------------------------------------------------------------------------
# Model without age
# ----------------------------------------------------------------------------------------------------------------------
MODEL M_aTot /
  M_base
  -B_consumers_a
  -B_GovExpenses_a
  -B_GovRevenues_a
  -B_HHincome_a
  -B_labor_market_a
  -B_struk_a
/;
$GROUP G_Endo_aTot
  G_Endo
  -G_consumers_endo_a
  -G_GovExpenses_endo_a
  -G_GovRevenues_endo_a
  -G_HhIncome_endo_a
  -G_labor_market_endo_a
  -G_struk_endo_a
;

# ----------------------------------------------------------------------------------------------------------------------
# Static model without age
# ----------------------------------------------------------------------------------------------------------------------
MODEL M_static /
  B_aggregates_static
  B_consumers_static
  B_exports_static
  B_finance_static
  B_government_static
  B_GovExpenses_static
  B_GovRevenues_static
  B_HHincome_static
  M_IO_static
  B_labor_market_static
  B_pricing_static
  B_production_private_static
  B_production_public_static # Er ikke square selvstændigt - qG[gTot] og pY[off,tEnd] indgår ikke i nogle ligninger, men er endogen
  B_struk_static
  B_taxes
/;
$GROUP G_static
  G_aggregates_static
  G_consumers_static
  G_exports_static
  G_finance_static
  G_government_static
  G_GovExpenses_static
  G_GovRevenues_static
  G_HHincome_static
  G_IO_static
  G_labor_market_static
  G_pricing_static
  G_production_private_static
  G_production_public_static
  G_struk_static
  G_taxes_endo
;
