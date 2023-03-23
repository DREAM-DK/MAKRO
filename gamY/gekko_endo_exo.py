import os
import sys
from timeit import default_timer as timer
from gams import GamsWorkspace
from gams.database import GamsDatabase
from gams import GamsVariable

# Read execution parameters
args = sys.argv
assert len(args) > 2, "GAMS path and input path must be specified."
ws = GamsWorkspace(system_directory=args[1])
input_path: str = os.path.abspath(args[2])
assert input_path[-4:] == ".gdx", f"{input_path} is not a .gdx file."
dir_path: str = os.path.split(input_path)[0]

db: GamsDatabase = ws.add_database_from_gdx(input_path)
output: GamsDatabase = ws.add_database()

# Find the dummy variables by searching for symbols starting with 'exo_' or 'endo_'
exo_dummies = [symbol for symbol in db if symbol.name[:4] == "exo_"]
endo_dummies = [symbol for symbol in db if symbol.name[:5] == "endo_"]

endo_exo_strings = []

for dummy in exo_dummies:
	var_name = dummy.name[4:]
	if len(db.get_symbol(var_name)) > 1:
		endo_exo_strings += [f"{var_name}.fx{rec.keys} = {var_name}.l{rec.keys};" for rec in dummy]
	else:
		endo_exo_strings += f"{var_name}.fx = {var_name}.l;"

for dummy in endo_dummies:
	var_name = dummy.name[5:]
	endo_exo_strings += [f"{var_name}.lo{rec.keys} = -inf; {var_name}.up{rec.keys} = inf;" for rec in dummy]

gms_path = os.path.join(dir_path, 'include_endo_exo.gms')
with open(gms_path, "w") as file:
	file.write("\n".join(endo_exo_strings))


# def test_endo_exo():
# 	args = ["", "C:\\GAMS\\win64\\28.1", "C:\\Users\\B031441\\Desktop\\HEAD\\Model\\Saved\\sim_input.gdx"]
