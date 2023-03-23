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
  B_aggregates
  M_consumers - M_consumers_post
  B_exports - M_exports_post
  B_finance
  B_government - M_Government_post
  M_GovExpenses - M_GovExpenses_post
  M_GovRevenues - M_GovRevenues_post
  M_HHincome - M_HHincome_post
  M_IO - M_IO_post
  M_labor_market - M_labor_market_post
  B_pricing - M_pricing_post
  B_production_private - M_production_private_post
  B_production_public
  M_struk
  B_taxes
/;

# ----------------------------------------------------------------------------------------------------------------------
# Post model
# ----------------------------------------------------------------------------------------------------------------------
MODEL M_post /
  M_consumers_post
  M_exports_post
  M_Government_post
  M_GovExpenses_post
  M_GovRevenues_post
  M_HHincome_post
  M_IO_post
  M_labor_market_post
  M_production_private_post
  M_pricing_post
/;
$GROUP G_post
  G_consumers_post
  G_exports_post
  G_Government_post
  G_GovExpenses_post
  G_GovRevenues_post
  G_HHincome_post
  G_IO_post
  G_labor_market_post
  G_production_private_post
  G_pricing_post
;

# ----------------------------------------------------------------------------------------------------------------------
# Model without age
# ----------------------------------------------------------------------------------------------------------------------
MODEL M_aTot /
  M_base
  M_post
  -B_consumers_a
  -B_GovExpenses_a
  -B_GovRevenues_a
  -B_HHincome_a
  -B_labor_market_a
  -B_struk_a
/;
$GROUP G_Endo_aTot
  G_Endo
  G_post
  -G_consumers_endo_a
  -G_GovExpenses_endo_a
  -G_GovRevenues_endo_a
  -G_HhIncome_endo_a
  -G_labor_market_endo_a
  -G_struk_endo_a
;
