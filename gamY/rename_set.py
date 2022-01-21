import os
from gams import *

input_path = os.path.abspath("..\\Model\\Saved\\previous_dynamic_calibration.gdx")
output_path = os.path.abspath("..\\Model\\Saved\\nye_navne.gdx")
replace_dict = {
  "agr": "lan",
  # "ene": "ene",
  "con": "byg",
  "ext": "udv",
  "hou": "bol",
  "man": "fre",
  "sea": "soe",
  "ser": "tje",
  "pub": "off",
}

ws = GamsWorkspace()
db = ws.add_database_from_gdx(input_path)
sets = [symbol for symbol in db if isinstance(symbol, GamsSet)]
variables = [symbol for symbol in db if isinstance(symbol, GamsVariable)]

for symbol in db:
  print(symbol.name)
  for r in symbol:
    new_keys = r.keys
    for i, k in enumerate(r.keys):
      for old_name, new_name in replace_dict.items():
        if k == old_name:
          new_keys[i] = new_name
    if new_keys != r.keys:
      if isinstance(symbol, GamsVariable):
        symbol.add_record(new_keys).level = r.level
      elif isinstance(symbol, GamsParameter):
        symbol.add_record(new_keys).value = r.value
      elif isinstance(symbol, GamsSet):
        symbol.add_record(tuple(new_keys))

db.export(output_path)