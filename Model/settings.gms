# ======================================================================================================================
# 1) Settings
# ======================================================================================================================
# In this file we control major settings:
# - Module files to include
# - Data sources
# - Growth and inflation adjustment
# - Years where model should be calibrated
# - Age group that should be included

# The remaining model runs in the following order:
# 2) sets.gms
# 3) Data.gms - import and arrange data
# 4) Model.gms
#   4.1) Define variables
#   4.2) Define equations
#   4.3) Set exogenous values assigning data to variables
# 5) static_calibration.gms - Calibrate most model parameters to fit data
# 6) Auto_ARIMA.R - forecast statically calibrated parameters by fitting ARIMAs
# 7) dynamic_calibration.gms - calibration of parameters that depend on expectations
# CURRENTLY NOT USED 8) gaps_calibration - structural model definition and calibration of gaps 
# 9) matching_optimize.gms - Set key parameters to match MAKRO responses to empirical impulse responses

# ======================================================================================================================
# Modules
# ======================================================================================================================
# Function to import part from each module
$FUNCTION import_from_modules(stage_key):
  $SETGLOBAL stage stage_key;
  $IMPORT IO.gms;
  $IMPORT taxes.gms;
  $IMPORT exports.gms;
  $IMPORT production_public.gms;
  $IMPORT production_private.gms;
  $IMPORT finance.gms;
  $IMPORT pricing.gms;
  $IMPORT labor_market.gms;
  $IMPORT struk.gms;
  $IMPORT consumers.gms;
  $IMPORT government.gms;
  $IMPORT GovRevenues.gms;
  $IMPORT GovExpenses.gms;
  $IMPORT aggregates.gms;
  $IMPORT HHincome.gms;  
  $IMPORT post_model.gms;  
$ENDFUNCTION

# ======================================================================================================================
# Growth and inflation adjustment
# ======================================================================================================================
parameters
  gq "Rate of growth (labor-augmenting technological progress rate)" /0.01/
  gp "Rate of foreign inflation" /0.0178/
;

# ======================================================================================================================
# Sets
# ======================================================================================================================
# ----------------------------------------------------------------------------------------------------------------------
# Time periods
# ----------------------------------------------------------------------------------------------------------------------
$SETGLOBAL base_year 2010 # Basis year for growth and inflation adjustments
$SETGLOBAL cal_start 1983 # Calibration start year
$SETGLOBAL cal_end 2017 # Last calibration year
$SETGLOBAL terminal_year 2099 # The terminal year
$SETGLOBAL rHBI_eval %cal_end% # Year in which rHBI is evaluated


# ======================================================================================================================
# GAMS options
# ======================================================================================================================
$OFFDIGIT

# LST output options
OPTION
  SYSOUT=OFF
  SOLPRINT=OFF
  LIMROW=0
  LIMCOL=0
  DECIMALS=6
  PROFILE = 1
  PROFILETOL = 0.01
;

# Solve options
OPTION
  DOMLIM=0  # Number of domain error ignored
  SOLVELINK=5  # Keep model in memory instead of using temporary files (quicker for solving many smaller models)
  CNS=CONOPT4  # Choose solver
  NLP=CONOPT4  # Choose solver
;

# ======================================================================================================================
# Solver options
# ======================================================================================================================
$ONECHO > conopt4.opt
  #  Keep searching for a solution even if a bound is hit (due to non linearities)
  lmmxsf = 1

  # Time limit in seconds
  reslim = 172000

  # Optimality tolerance for reduced gradient
  RTREDG = 1.e-9

  #  # Bound filter tolerance for solution values close to a bound. 
  #  Tol_Bound=1.e-5

  #  # Tolerance for defining variables as fixed based on derived bounds.
  #  Tol_DFixed=1.e-8

  # Multithreading
  Threads=4
  THREADF=4
  #  THREAD2D=4
  #  THREADC=4

  #  # Relative accuracy of the objective function.
  #  Tol_Obj_Acc=3.0e-9

  # Absolute pivot tolerance.
  #  Tol_Piv_Abs=1.e-7

  # Zero filter for Jacobian elements and inversion results.
  #  Tol_Zero=1.e-14

  #  Absolute pivot tolerance, Range: [2.2e-16, 1.e-7], Default: 1.e-10
  #  RTPIVA = 1.e-15

  #  Relative pivot tolerance during basis factorizations, Range: [1.e-3, 0.9], Default: 0.05
  #  RTPIVR = 1.e-3
$OFFECHO

