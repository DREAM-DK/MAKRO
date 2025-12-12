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
# 7) deep_dynamic_calibration.gms - calibration of parameters that depend on expectations
# CURRENTLY NOT USED 8) gaps_calibration - structural model definition and calibration of gaps 
# 9) matching_optimize.gms - Set key parameters to match MAKRO responses to empirical impulse responses

# ======================================================================================================================
# Dummy til antagelser, som afviger mellem DØRS, FM, og DREAM
# ======================================================================================================================
$SETGLOBAL FM_baseline 1
$SETGLOBAL DORS_baseline 0
$SETGLOBAL DREAM_baseline 0

# ======================================================================================================================
# Modules
# ======================================================================================================================
# Function to import part from each module
$FUNCTION import_from_modules(stage_key):
  $SETGLOBAL stage stage_key;
  $IMPORT aggregates.gms;
  $IMPORT consumers.gms;
  $IMPORT exports.gms;
  $IMPORT finance.gms;
  $IMPORT GovRevenues.gms;
  $IMPORT GovExpenses.gms;
  $IMPORT HHincome.gms;  
  $IMPORT IO.gms;
  $IMPORT labor_market.gms;
  $IMPORT pricing.gms;
  $IMPORT production_private.gms;
  $IMPORT production_public.gms;
  $IMPORT struk.gms;
  $IMPORT taxes.gms;
  $IMPORT government.gms;
$ENDFUNCTION

# ======================================================================================================================
# Growth and inflation adjustment
# ======================================================================================================================
parameters
  gq "Long run rate of productivity growth (labor-augmenting technological progress rate)" /0.011/
  gp "Long run rate of foreign inflation" /0.018/
  terminal_rente "Obligationsrente på lang sigt" /0.04/
  terminal_ECB_rente "ECB-rente på lang sigt" /0.035/
;

# ======================================================================================================================
# Sets
# ======================================================================================================================
# ----------------------------------------------------------------------------------------------------------------------
# Time periods
# ----------------------------------------------------------------------------------------------------------------------
$SETGLOBAL base_year 2020 # Basis year for growth and inflation adjustments
$SETGLOBAL cal_start 1985 # Calibration start year
$SETGLOBAL cal_deep 2019 # Last calibration year used for structural parameters
$SETGLOBAL cal_end 2024 # Last calibration year with full national accounting data, but no data on age profiles
$SETGLOBAL terminal_year 2129 # The terminal year
$SETGLOBAL rHBI_eval %cal_deep% # Year in which rHBI is evaluated

$SETGLOBAL NettoFin_t1 1994 # First year with net financial data
$SETGLOBAL BruttoFin_t1 2016 # First year with gross financial data
$SETGLOBAL BFR_t1 2001 # First year with BFR data
$SETGLOBAL AgeData_t1 2015 # First year with age data on cohort behavior
$SETGLOBAL AgeData_tEnd 2019 # Last year with age data on cohort behavior

# Beregningsteknisk skat til lukning af offentlig budgetrestriktion på lang sigt (HBI=0)
$SETGLOBAL HBI_lukning_start 2030 # Start på indfasning af reaktion
$SETGLOBAL HBI_lukning_slut 2098 # Slutning på indfasning af reaktion

# ======================================================================================================================
# GAMS options
# ======================================================================================================================
$OFFDIGIT
option zeroToEps=on; # Execule_load indlæser nuller som eps

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
  SOLVELINK=5  # Keep model in memory instead of using temporary files (quicker for solving many smaller models)
  CNS=CONOPT4  # Choose solver
  NLP=CONOPT4  # Choose solver
;

# ======================================================================================================================
# Solver options
# ======================================================================================================================
$ONECHO > conopt4.opt
  # See https://www.gams.com/latest/docs/S_CONOPT4.html
  # for available solver options

  #  Keep searching for a solution even if a bound is hit (due to non linearities)
  lmmxsf = 1

  # Time limit in seconds
  reslim = 3600

  #Limit on number of error messages related to infeasible pre-triangle
  #25 is default but often not enough. 
  Lim_Pre_Msg = 400


  # Multithreading
  Threads=7
  THREADF=7
  #  THREAD2D=4
  #  THREADC=4

  #  # Relative accuracy of the objective function.
  #  Tol_Obj_Acc=3.0e-9
$OFFECHO

# ======================================================================================================================
# Functions
# ======================================================================================================================
$IMPORT functions.gms

# ======================================================================================================================
# Should aggregation and other tests be run after calibration? Is set to 0 when running matching algorithm
# ======================================================================================================================
$SETGLOBAL run_tests 1

$SETGLOBAL smooth_age_profiles 1 # Should age profiles be smoothed in deep_dynamic_calibration? 1 = yes, 0 = no
