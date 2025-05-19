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
os.chdir(fr"{root}\Analysis\Standard_shocks")

## Kopier baseline gdx til Gdx mappe
shutil.copy(r"..\..\Model\Gdx\baseline.gdx", r"Gdx\baseline.gdx")

## Her køres stødene
run("standard_shocks.gms", r="../../Model/Savepoints/equations")

# ## Lav figurer og åben html-rapport med standard output
# subprocess.run(["python", "plot_standard_shocks.py"], check=True) 
# webbrowser.get().open(r"Output\standard_shocks.html")

