import os 
import sys
import glob
import shutil
import subprocess
cwd = os.getcwd() # make sure you open this file in the right directory (...\MAKRO-dev\Model)
paths_directory = os.path.dirname(cwd)
sys.path.insert(0, paths_directory)
exec(open(paths_directory+'\paths.py').read()) # get local paths
sys.path.insert(0, gamY_path)
import gamY
os.environ["R_HOME"] = R_path
os.environ["GAMSDIR"] = GAMS_path
os.environ["GAMS"] = GAMS_path_y
os.environ["R_GAMS_SYSDIR"] = GAMS_path

## SETTINGS
args = [gamY_path,'settings.gms','s=Savepoints\\settings']
gamY.py_call(args)
gamY.gams_error('settings.gms',check_error=True)

## IMPORT SETS
args = [gamY_path,'sets.gms','r=Savepoints\\settings',
        's=Savepoints\\sets']
gamY.py_call(args)
gamY.gams_error('sets.gms',check_error=True)

## MODEL CALIBRATION
args = [gamY_path,'variables.gms','r=Savepoints\\sets',
        's=Savepoints\\variables']
gamY.py_call(args)
gamY.gams_error('variables.gms',check_error=True)

args = [gamY_path,'equations.gms','r=Savepoints\\variables',
        's=Savepoints\\equations']
gamY.py_call(args)
gamY.gams_error('equations.gms',check_error=True)

args = [gamY_path,'exogenous_values.gms','r=Savepoints\\equations',
        's=Savepoints\\exogenous_values']
gamY.py_call(args)
gamY.gams_error('exogenous_values.gms',check_error=True)

args = [gamY_path,'static_calibration.gms','r=Savepoints\\exogenous_values',
        's=Savepoints\\static_calibration']
gamY.py_call(args)
gamY.gams_error('static_calibration.gms',check_error=True)

# args = [gamY_path,'simple_calibration_2018.gms','r=Savepoints\\static_calibration',
#         's=Savepoints\\simple_calibration_2018']
# gamY.py_call(args)
# gamY.gams_error('simple_calibration_2018.gms',check_error=True)

# args = [gamY_path,'simple_calibration_2019.gms','r=Savepoints\\simple_calibration_2018',
#         's=Savepoints\\simple_calibration_2019']
# gamY.py_call(args)
# gamY.gams_error('simple_calibration_2019.gms',check_error=True)

# args = [gamY_path,'simple_calibration_2020.gms','r=Savepoints\\simple_calibration_2019',
#         's=Savepoints\\simple_calibration_2020']
# gamY.py_call(args)
# gamY.gams_error('simple_calibration_2020.gms',check_error=True)

# Skip the R program to not fit new arimas
# subprocess.run([RSCRIPT_path, R_arg, 'auto_arima.R'], shell=True, capture_output=False)

args = [gamY_path,'exogenous_forecasts.gms','r=Savepoints\\static_calibration',
        's=Savepoints\\exogenous_forecasts']
gamY.py_call(args)
gamY.gams_error('exogenous_forecasts.gms',check_error=True)

args = [gamY_path,'deep_dynamic_calibration.gms','r=Savepoints\\exogenous_forecasts',
        's=Savepoints\\deep_dynamic_calibration']
gamY.py_call(args)
gamY.gams_error('deep_dynamic_calibration.gms',check_error=True)

args = [gamY_path,'smoothed_parameters_calibration.gms','r=Savepoints\\deep_dynamic_calibration',
        's=Savepoints\\smoothed_parameters_calibration']
gamY.py_call(args)
gamY.gams_error('smoothed_parameters_calibration.gms',check_error=True)

## Clean up temp files and folders
## Del "tmp_gmx_*"
dirs = glob.glob("225*/")
for dir in dirs:
    shutil.rmtree(dir)