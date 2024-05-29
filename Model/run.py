## imports
%load_ext autoreload
%autoreload 2

import os 
import sys
import glob
import shutil
import subprocess
import dreamtools as dt
from dreamtools import gamY
import zipfile

## set paths to programs
root = os.getcwd()
while root != os.path.dirname(root):
    paths_file = os.path.join(root, "paths.py")
    if os.path.isfile(paths_file):
        break
    root = os.path.dirname(root)

sys.path.append(root)
exec(open(paths_file).read()) # get local paths

sys.path.append(fr"{root}\Analysis\Baseline")
sys.path.append(fr"{root}\Analysis\Templates") # Add the Templates folder to the path so we can import variables_to_plot


os.environ["R_HOME"] = R_path
os.environ["GAMSDIR"] = GAMS_path
os.environ["GAMS"] = GAMS_path_y
os.environ["R_GAMS_SYSDIR"] = GAMS_path

## Set working directory
os.chdir(fr"{root}\Model")

## Install python modules in python installation that comes with GAMS
# subprocess.check_call(["curl", "https://bootstrap.pypa.io/get-pip.py", "-o", "get-pip.py"])
# subprocess.check_call([sys.executable, "get-pip.py"])
# subprocess.check_call([sys.executable, "-m", "pip", "install", 
#                        "numpy", "scipy", "statsmodels", "xlwings", "dream-tools", 
#                        "plotly", "kaleido==0.1.0.post1", "xhtml2pdf"])

## SETTINGS and SETS
gamY.run("settings.gms", s="Savepoints/settings")
gamY.run("sets.gms", r="Savepoints/settings",  s="Savepoints/sets")

## LOAD MODEL
gamY.run("variables.gms", r="Savepoints/sets",  s="Savepoints/variables")
gamY.run("equations.gms", r="Savepoints/variables",  s="Savepoints/equations")

## BASELINE
gamY.run("baseline.gms", r="Savepoints/equations",  s="Savepoints/baseline")

## Clean up temp files and folders
for dir in glob.glob("225*/"):
    shutil.rmtree(dir)

