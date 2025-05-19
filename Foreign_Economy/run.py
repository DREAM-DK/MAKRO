import os 
import sys
import subprocess
import dreamtools as dt
import pandas as pd
import numpy as np
import glob
import pickle as pkl

## Set local paths
root = dt.find_root()
sys.path.insert(0, root)
import paths # Calls paths.py

def run(file_path,
        calibration_steps=1, previous_terminal_year=2130, stepwise_new_dummies=0, blockwise_calibration=0,
        previous_solution="None", run_tests=1,
        **kwargs
    ):
    """Wrapper for dreamtools.gamY.run with default arguments added"""
    if "r" in kwargs and "savepoints" not in kwargs["r"].lower():
        kwargs["r"] = f"Savepoints/{kwargs["r"]}"
    if "s" not in kwargs:
        kwargs["s"] = f"{root}/Foreign_Economy/Savepoints/{os.path.splitext(file_path)[0]}"
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


## Set working directory
os.chdir(fr"{root}/Foreign_Economy")

## Foreign economy model
run("foreign_economy.gms")

dt.clean_gams_temp_files()

# Quarterly to yearly conversion
subprocess.run(["python", r"quarters_to_years.py"], check=True)


