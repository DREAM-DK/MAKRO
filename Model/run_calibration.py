import os 
import sys
import subprocess
import dreamtools as dt
import webbrowser
import shutil
    
## Set local paths
root = dt.find_root()
sys.path.insert(0, root)
import paths # Calls paths.py

# Add a additive residual to all equations, used to test data for consistency
dt.gamY.automatic_additive_residuals_prefix = "res_"
dt.gamY.variable_equation_prefix = "E_"

## Set working directory
os.chdir(fr"{root}/Model")

## Add default arguments to run
def run(file_path,
        calibration_steps=1, previous_terminal_year=2129, stepwise_new_dummies=0, blockwise_calibration=0,
        previous_solution="None", run_tests=1,
        **kwargs
    ):
    """Wrapper for dreamtools.gamY.run with default arguments added"""
    if "r" in kwargs and "savepoints" not in kwargs["r"].lower():
        kwargs["r"] = f"Savepoints/{kwargs["r"]}"
    if "s" not in kwargs:
        kwargs["s"] = f"{root}/Model/Savepoints/{os.path.splitext(file_path)[0]}"
    print(kwargs)
    dt.gamY.run(
        file_path,
        calibration_steps=str(calibration_steps),
        previous_terminal_year=str(previous_terminal_year),
        stepwise_new_dummies=str(stepwise_new_dummies),
        blockwise_calibration=str(blockwise_calibration),
        previous_solution=previous_solution,
        run_tests=str(run_tests),
        **kwargs,
    )

def run_r(file_path):
    result = subprocess.run(
        [os.environ["RSCRIPT"], "--vanilla", file_path],
        shell=True, capture_output=True, text=True,
    )
    print(result.stderr, end="", file=sys.stderr); result.check_returncode()

## SETTINGS and SETS
run("settings.gms")
run("sets.gms", r="settings")

## MODEL CALIBRATION
run("variables.gms", r="sets")
run("growth_inflation_adjustment.gms", r="variables")
run("bounds.gms", r="growth_inflation_adjustment")
run("equations.gms", r="bounds")
run("exogenous_values.gms", r="equations") 
run("static_calibration.gms", r="exogenous_values", calibration_steps=1)

## Skip the R program to not fit n      ew arimas
run("ARIMA_options.gms", r="static_calibration")
run_r("auto_arima.R")

run("exogenous_forecasts.gms", r="static_calibration")
run(
    "deep_dynamic_calibration.gms", r="exogenous_forecasts",
    # calibration_steps=1,                         
	# previous_terminal_year=2060,
    previous_solution="previous_deep_calibration",
	# terminal_year="2060",
)

# Import baseline plot function - currently requires dt.REFERENCE_DATABASE to be set, as variables_to_plot.py references a number of sets
sys.path.insert(0, fr"{root}/Analysis/Baseline")
sys.path.insert(0, fr"{root}/Analysis/Templates")
dt.REFERENCE_DATABASE = dt.Gdx(fr"{root}/Model/Gdx/sets.gdx")
from baseline import plot_baseline

plot_baseline(
    database_dict=dict(
        previous_dynamic_calibration=r"Gdx/previous_deep_calibration.gdx",
        deep_dynamic_calibration=r"Gdx/deep_calibration.gdx",      
    ),
    start_year=1983,
    end_year=2129,
    xlines=[2022],
    output_path=fr"{root}/Analysis/Baseline/Output/deep_calibration.html",
    DA=True,
)

## Calibration to new national data and no data for age profiles
run("dynamic_calibration_newdata.gms", r="static_calibration", data_year="2023", last_calibration="deep_calibration",
    previous_solution="previous_calibration_2023", calibration_steps=1, stepwise_new_dummies=0)
run("dynamic_calibration_newdata.gms", r="static_calibration", data_year="2024", last_calibration="calibration_2023",
    previous_solution="previous_calibration_2024", calibration_steps=1, stepwise_new_dummies=0)
run("dynamic_calibration_newdata.gms", r="static_calibration", data_year="2025", last_calibration="calibration_2024",
    previous_solution="previous_calibration_2025", calibration_steps=1, stepwise_new_dummies=0)

plot_baseline(
    database_dict=dict(
        previous_calibration_2025=r"Gdx/previous_calibration_2025.gdx",
        calibration_2025=r"Gdx/calibration_2025.gdx",
        deep_dynamic_calibration=r"Gdx/deep_calibration.gdx",
    ),
    start_year=2000,
    end_year=2040,
    xlines=[2019, 2025],
    output_path=fr"{root}/Analysis/Baseline/Output/newdata_calibration.html",
    DA=True,
)

dt.clean_gams_temp_files()

## STANDARD SHOCKS
os.chdir(r"../Analysis/Standard_shocks")
## Kopier baseline gdx til Gdx mappe
shutil.copy(r"../../Model/Gdx/calibration_2025.gdx", r"Gdx/baseline.gdx")
## Her k�res st�dene
run("standard_shocks.gms", r="../../Model/Savepoints/exogenous_values")
subprocess.run(["python", "standard_multiplicators_and_IRFS.py"], check=True) 
# open standard shock html reports
webbrowser.get().open(r"Output/standard_IRFs.html")
webbrowser.get().open(r"Output/tables/standard_multipliers.html")
os.chdir(fr"{root}/Model") # reset directory
