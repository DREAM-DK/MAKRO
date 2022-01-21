import os
import pandas as pd
import xlwings as xw
from gams import *

# import sys
#  Read any execution paremeters
# args = sys.argv

# assert len(args) > 2, "GAMS path and input path must be specified"
# ws = GamsWorkspace(system_directory=sys.argv[1])
# input_path = os.path.abspath(args[2])
# assert input_path[-4:] == ".gdx", "%s is not a .gdx file" % input_path

ws = GamsWorkspace()
input_path = os.path.abspath("..\\Model\\Output\\dynamic_calibration.gdx")

db = ws.add_database_from_gdx(input_path)

# fp = os.path.join(file_dir, file_name+'_variables.xlsx')
fp = "../Analysis/Templates/skabelon.xlsx"

# data = pd.read_excel(fp, sheetname=None, na_filter=False)
variables = [symbol for symbol in db if isinstance(symbol, GamsVariable)]
df = pd.DataFrame(
    [(v.name, str(v.domains_as_strings), v.text) for v in variables],
    columns=("Name", "Domains", "Description")
)

wb = xw.Book(fp)
wb.sheets["variables"].range('A1').options(index=False).value = df
wb.save()

