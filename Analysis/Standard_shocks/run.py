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

## Set working directory
os.chdir(fr"{root}/Analysis/Standard_shocks")

## Kopier baseline gdx til Gdx mappe
shutil.copy("../../Model/Gdx/baseline.gdx", "Gdx/baseline.gdx")

# Kør GMS filer for at generere savepoints
dt.gamY.variable_equation_prefix = "E_"
run("../../Model/settings.gms", s="Savepoints/settings")
run("../../Model/sets.gms", r="Savepoints/settings", s="Savepoints/sets")
run("../../Model/variables.gms", r="Savepoints/sets", s="Savepoints/variables")
run("../../Model/growth_inflation_adjustment.gms", r="Savepoints/variables", s="Savepoints/growth_inflation_adjustment")
run("../../Model/bounds.gms", r="Savepoints/growth_inflation_adjustment", s="Savepoints/bounds")
run("../../Model/equations.gms",  r="Savepoints/bounds", s="Savepoints/equations")

## Her køres stødene
run("standard_shocks.gms", r="../../Model/Savepoints/equations")

# ## Lav figurer og åben html-rapport med standard output
# subprocess.run(["python", "plot_standard_shocks.py"], check=True) 
# webbrowser.get().open(r"Output/standard_shocks.html")

