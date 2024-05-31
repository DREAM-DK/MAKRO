## imports
import os 
import sys
import glob
import shutil
import subprocess
import webbrowser
## set paths to programs
root = os.getcwd()
while root != os.path.dirname(root):
    paths_file = os.path.join(root, "paths.py")
    if os.path.isfile(paths_file):
        break
    root = os.path.dirname(root)
sys.path.insert(0, root)
exec(open(root+r"\paths.py").read()) # get local paths
from dreamtools import gamY
os.environ["R_HOME"] = R_path
os.environ["GAMSDIR"] = GAMS_path
os.environ["GAMS"] = GAMS_path_y
os.environ["R_GAMS_SYSDIR"] = GAMS_path
os.chdir(fr"{root}\Analysis\Standard_shocks")

## Kopier baseline gdx til Gdx mappe
shutil.copy(r"..\..\Model\Gdx\baseline.gdx", r"Gdx\baseline.gdx")
## Her køres stødene
gamY.run("standard_shocks.gms", r="../../Model/Savepoints/baseline")

# Lav figurer og åben html-rapport med standard output
subprocess.run(["python", "plot_standard_shocks.py"]) 
webbrowser.open(r"Output\standard_shocks.html")

## Clean up temp files and folders
## Del "tmp_gmx_*"
dirs = glob.glob("225*/")
for dir in dirs:
    shutil.rmtree(dir)


