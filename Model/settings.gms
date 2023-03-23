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
# Modules
# ======================================================================================================================
# Function to import part from each module
$FUNCTION import_from_modules(stage_key):
  $SETGLOBAL stage stage_key;
  $IMPORT aggregates.gms;
  $IMPORT consumers.gms;
  $IMPORT exports.gms;
  $IMPORT finance.gms;
  $IMPORT government.gms;
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
  $IMPORT DataOnlyVariables.gms;
$ENDFUNCTION

# ======================================================================================================================
# Growth and inflation adjustment
# ======================================================================================================================
parameters
  gq "Long run rate of productivity growth (labor-augmenting technological progress rate)" /0.01/
  gp "Long run rate of foreign inflation" /0.0178/
  terminal_rente "Obligationsrente på lang sigt" /0.04/
;

# ======================================================================================================================
# Sets
# ======================================================================================================================
# ----------------------------------------------------------------------------------------------------------------------
# Time periods
# ----------------------------------------------------------------------------------------------------------------------
$SETGLOBAL base_year 2010 # Basis year for growth and inflation adjustments
$SETGLOBAL cal_start 1983 # Calibration start year
$SETGLOBAL cal_deep 2017 # Last calibration year with full age distribution
$SETGLOBAL cal_end 2021 # Last calibration year
$SETGLOBAL terminal_year 2099 # The terminal year
$SETGLOBAL rHBI_eval 2030 # Year in which rHBI is evaluated

# Beregningsteknisk skat til lukning af offentlig budgetrestriktion på lang sigt (HBI=0)
$SETGLOBAL HBI_lukning_start 2030 # Start på indfasning af reaktion
$SETGLOBAL HBI_lukning_slut 2098 # Slutning på indfasning af reaktion

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
  reslim = 172000

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
# Homotopy continuation flags (solve model gradually from last solution)
# ======================================================================================================================
$SETGLOBAL static_homotopy 0 # homotopy continuation in static calibration flag, 1.0 = True
$SETGLOBAL deep_homotopy 0 # homotopy continuation in deep dynamic calibration flag, 1.0 = True

# ======================================================================================================================
# Should aggregation and other tests be run after calibration? Is set to 0 when running matching algorithm
# ======================================================================================================================
$SETGLOBAL run_tests 1