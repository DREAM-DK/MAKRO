import os 
import sys
import subprocess
import dreamtools as dt
from dreamtools.gamY import run
import shutil
import webbrowser

## Set local paths
root = dt.find_root()
sys.path.insert(0, root)
import paths

dt.gamY.variable_equation_prefix = "E_"

## Set working directory
os.chdir(fr"{root}/Analysis/Standard_shocks")

## Kopier baseline gdx til Gdx mappe
shutil.copy(r"../../Model/Gdx/previous_calibration_2025.gdx", r"Gdx/baseline.gdx")

dt.gamY.variable_equation_prefix = "E_"
run(r"../../Model/settings.gms", s=r"Savepoints/settings")
run(r"../../Model/sets.gms", r=r"Savepoints/settings", s=r"Savepoints/sets")
run(r"../../Model/variables.gms", r=r"Savepoints/sets", s=r"Savepoints/variables")
run(r"../../Model/growth_inflation_adjustment.gms", r=r"Savepoints/variables", s=r"Savepoints/growth_inflation_adjustment")
run(r"../../Model/bounds.gms", r=r"Savepoints/growth_inflation_adjustment", s=r"Savepoints/bounds")
run(r"../../Model/equations.gms",  r=r"Savepoints/bounds", s=r"Savepoints/equations")

## Her køres stødene
run("standard_shocks.gms", r="../../Model/Savepoints/equations")

# run("shock_template.gms", r="../../Model/Savepoints/equations")

# run("BFR_shock.gms", r="../../Model/Savepoints/equations")

# ## Lav figurer og åben html-rapport med standard output
# subprocess.run(["python", "plot_standard_shocks.py"], check=True) 
# webbrowser.get().open(r"Output/standard_shocks.html")

## SVAR-stød
# run("../../Matching/matching.gms", r="../../Model/Savepoints/deep_dynamic_calibration")
