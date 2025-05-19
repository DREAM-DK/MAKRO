# %load_ext autoreload
# %autoreload 2

import os 
import sys
import dreamtools as dt
import zipfile
import dreamtools as dt

# ============= change here start ================================
# type = 1: static calibration
# type = 2: deep dynamic calibration
type = 2
if type == 1:
  zipname = "static_calibration.zip"
  savepoint = "Savepoints/static_calibration" # Nice if this could instead be savepoint "exogenous_values" (but that doesn't work)
  gams_time = "set_time_periods(%cal_start%-1, %cal_end%);"
  gams_model = "MODEL gekko_equations / M_static_calibration /; $FIX All; $UNFIX G_static_calibration;"  
elif type == 2:
  zipname = "deep_dynamic_calibration.zip"
  savepoint = "Savepoints/deep_dynamic_calibration" # Nice if this could instead be savepoint "exogenous_forecasts" (but that doesn't work)
  gams_time = "set_time_periods(%cal_deep%-1, %terminal_year%);"
  gams_model = "MODEL gekko_equations / M_base /; $FIX All; $UNFIX G_endo;"
else: 
  raise Exception(f"Type variable must be 1 or 2.")
keep_gms = False # Set True if you would like to keep gekko_equations1.gms and gekko_equations2.gms for inspection after the run
# ============= change here end ==================================

## Set local paths
root = dt.find_root()
sys.path.insert(0, root)
import paths # Calls paths.py

## Set working directory
os.chdir(f"{root}/Model")

gams1 = "gekko_equations1"
gams2 = "gekko_equations2"

gams1_text = f"""{gams_time}
{gams_model}
gekko_equations.holdfixed = 0; # Do not treat a fixed variable as a hard-coded number, but keep it as an exogenous variable.
option cns = convert; # Produce scalar model instead of normal solve.
maxExecError = 100; # Otherwise gekko_equations.py aborts because of GAMS error in the following line.
solve gekko_equations using cns; # Best that it is same solver type as is used for normal simulation.
execerror = 0; # Resetting the number of GAMS errors.
"""
              
gams2_text = f"""{gams_time}
{gams_model}
# Read via Python the file square_mismatch.txt, which contains the rows/cols mismatch that 
# arose when running gekko_equations1.gms.
# Python puts the mismatch number (may be negative) into the GAMS variable n_gekko_equations.
scalar n_gekko_equations;
embeddedCode Python:    
  import os 
  import ctypes
  filename = "square_mismatch.txt"
  extra = 0  
  if not os.path.exists(filename):
    message = f"The embedded Python inside /Model/gekko_equations2.gms could not find the file '{{filename}}'"
    if os.name == 'nt': ctypes.windll.user32.MessageBoxW(0, message, "Error", 0) # Easier to see the error as a popup box
    raise Exception(message)
  with open(filename, "r") as file:
    try:
      text = file.read().strip()
      extra = int(text)
    except:
      message = f"The embedded Python inside /Model/gekko_equations2.gms could not parse the contents of the file '{{filename}}' as an integer. The contents is: '{{text}}'."
      if os.name == 'nt': ctypes.windll.user32.MessageBoxW(0, message, "Error", 0) # Easier to see the error as a popup box
      raise Exception(message)
  gams.set("n_gekko_equations", [extra])  
endEmbeddedCode n_gekko_equations

# If n_gekko_equations is negative, there are too few equations.
# If n_gekko_equations is positive, there are too few variables.
# This is handled by either adding more (irrelevant) equations, or 
# adding an equation with a sum of (irrelevant) variables.
# This uses a phoney set super_temp, with 1 mio. elements, which is
# therefore also the limit of how big abs(n_gekko_equations) may be.
# But if this limit is a problem, just make super_temp bigger.
set super_temp / temp1*temp1000000 /;
set dyn_temp1(super_temp); 
set dyn_temp2(super_temp); 
dyn_temp1(super_temp) = ord(super_temp) <= max(0, 1 - round(n_gekko_equations));
dyn_temp2(super_temp) = ord(super_temp) <= max(0, round(n_gekko_equations) + 1);
variable x_temp1;
variable x_temp2[super_temp];
equation e_temp1[super_temp];
equation e_temp2; 
e_temp1[super_temp] $ dyn_temp1(super_temp) .. 1 =e= x_temp1;
e_temp2 .. sum(super_temp $ dyn_temp2(super_temp), x_temp2[super_temp]) =e= 0;

model gekko_equations_temp / gekko_equations, e_temp1, e_temp2 /; # Includes phoney equations or variables to make rows/cols square.
gekko_equations_temp.holdfixed = 0; # Do not treat a fixed variable as a hard-coded number, but keep it as an exogenous variable.
option cns = convert; # Produce scalar model instead of normal solve.
solve gekko_equations_temp using cns; # Best that it is same solver type as is used for normal simulation.
"""

temp1 = "gams.gms"
temp2 = "dict.txt"
temp3 = "square_mismatch.txt"
temp4 = f"{gams1}.gms"
temp5 = f"{gams2}.gms" 
temp = [temp1, temp2, temp3, temp4, temp5] # Temp files are deleted before and after GAMS is called
for s in temp:
  if os.path.exists(s): os.remove(s) # Any pre-existing temp files are wiped out

with open(temp4, "w") as file:
  file.write(gams1_text)
with open(temp5, "w") as file:
  file.write(gams2_text)

try:
  dt.gamY.run(f"{gams1}.gms", r=savepoint) # Finds out number of rows/columns (equations/variables) in the model.

  square_message = "**** ERROR: CNS models must be square"
  filename = f"{os.getcwd()}/LST/{gams1}.lst"
  extra = 0
  b = False
  with open(filename, "r") as s:
    for line in s:
      if (b):
        m = line.split(" ")      
        if not (len(m) >= 10 and m[0] == 'This' and m[1] == 'model' and m[2] == 'contains' and m[4] == 'equality' and m[5] == 'rows' and m[6] == 'and' and m[8] == 'unfixed' and m[9].startswith('columns')):
          raise Exception(f"Expected '{square_message}' to be followed by message like 'This model contains <integer> equality rows and <integer> unfixed columns'.")
        ok = True
        try:
          extra = int(m[3]) - int(m[7])
        except:
          raise Exception(f"Could not parse '{m[3]}' or '{m[7]}' as an integer")
        break
      if (line.strip() == square_message):
        b = True    
  if not b:
    raise Exception(f"Did not find message '{square_message}' in /LST/{gams1}.lst. This is usually because something went wrong, but it MAY be because the model is already square when setting .holdfixed = 0.")
  with open(temp3, "w") as text_file:
      text_file.write(str(extra))

  dt.gamY.run(f"{gams2}.gms", r=savepoint) # Corrects rows/columns and produces scalar model files dict.txt and gams.gms.

  with zipfile.ZipFile(zipname, 'w', compression = zipfile.ZIP_DEFLATED) as zipf:
    zipf.write(temp1)
    zipf.write(temp2)    
    zipf.write("Expanded/equations.gmy", "raw.gms")

finally:  
  if keep_gms: 
    temp.remove(temp4)
    temp.remove(temp5)
  for s in temp:
    if os.path.exists(s): os.remove(s) # Clean up temp files
