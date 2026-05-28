# ======================================================================================================================
# Variables
# ======================================================================================================================
# In this file we define the variables in comprise the model.
# The variables are organized in groups.
# We combine the module-specific groups into bigger groups. 

# ----------------------------------------------------------------------------------------------------------------------
# Group definitions
# ----------------------------------------------------------------------------------------------------------------------
# We define various global groups
# Each module adds their variables to these groups

# All endogenous variables
$GROUP G_Endo
;

# Variables that are forecast as zero
$GROUP G_forecast_as_zero
;

# Variables
$GROUP G_exogenous_forecast
;

# All variables without a time index
$GROUP G_constants
;

# Variables that are kept constant from the deep calibration year
$GROUP G_fixed_forecast
;

# Variables that use the static calibration value after the deep calibration year
# and are kept constant from the last data year
$GROUP G_newdata_forecast
;

# Variables for which we use ARIMA forecasts in static calibration
$GROUP G_ARIMA_forecast
;

# ----------------------------------------------------------------------------------------------------------------------
# Variable definitions
# ----------------------------------------------------------------------------------------------------------------------
@import_from_modules("variables")
