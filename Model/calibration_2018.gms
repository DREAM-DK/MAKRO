# ======================================================================================================================
# Simple calibration
# ======================================================================================================================
# This file controls the simple static and dynamic calibration of the model.
# We calibrate all parameters for the new data years not covered by age data.

# Set latest calibration year
$SETLOCAL cal_simple 2018;
set_data_periods(%cal_start%, %cal_simple%);

# Set latest full calibrated model
$SETLOCAL last_calibration smooth_calibration;

# Simple static calibration
$SETGLOBAL simple_static_calibration_stepwise 0;
$IMPORT simple_static_calibration.gms;

# Simple dynamic calibration
$SETGLOBAL simple_dynamic_calibration_stepwise 0;
$IMPORT simple_dynamic_calibration.gms;

# Output
@unload(Gdx\calibration_%cal_simple%)

