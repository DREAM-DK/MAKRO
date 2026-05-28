# ======================================================================================================================
# Equations
# ======================================================================================================================
# ----------------------------------------------------------------------------------------------------------------------
# Main model
# ----------------------------------------------------------------------------------------------------------------------
# We define the model as the combination of equation blocks from each imported module
# Each module adds its own model to M_base
MODEL M_base;

# ----------------------------------------------------------------------------------------------------------------------
# Static model without age
# ----------------------------------------------------------------------------------------------------------------------
# Each module adds its own static model and endogenous group to M_static and G_static
MODEL M_static;
$GROUP G_static ;

# Equations are defined in each module and organized in "blocks". They are imported here.
@import_from_modules("equations")
