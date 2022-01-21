import os
import sys
import csv
import gamY
import re
import textwrap


def main():
  """
  Read model from gamY pickle
  Translate Equations to Gekko format
  Export equations to csv file
  """
  file_path = "../model/saved/model"  # sys.argv[1]
  file_dir, file_name = os.path.split(file_path)
  file_dir = os.path.abspath(file_dir)

  model_name = "M_base"  # sys.argv[2]

  db = gamY.Precompiler(file_path)
  db.read(file_name)

  with open(os.path.join(file_dir, file_name+'_equations.csv'), 'w', newline='') as file:
    writer = csv.writer(file, quoting=csv.QUOTE_ALL)
    writer.writerow(["Name", "Sets", "Conditionals", "Left hand side", "Right hand side", ""])
    for eq in db.blocks[model_name].values():
      LHS = textwrap.dedent(eq.LHS).replace("\n","")
      RHS = textwrap.dedent(eq.RHS).replace("\n","")
      while "  " in LHS:
        LHS = LHS.replace("  ", " ")
      while "  " in RHS:
        RHS = RHS.replace("  ", " ")
      writer.writerow([
        eq.name,
        eq.sets,
        eq.conditions,
        LHS,
        RHS,
      ])


t_only_pattern = re.compile(r"[(\[]t([+-]1)?[)\]]", re.IGNORECASE | re.MULTILINE | re.DOTALL)
t_end_pattern = re.compile(r",t([+-]1)?([)\]])", re.IGNORECASE | re.MULTILINE | re.DOTALL)
def remove_t(text):
  """Remove time dimension, t, as it is explicit in Gekko
  >>> remove_t("foo[a,t] =E= bar[t];")
  'foo[a] =E= bar;'
  """
  for m in t_only_pattern.finditer(text):
    if m.group(1):
      text = text.replace(m.group(0), f"[{m.group(1)}]")
    else:
      text = text.replace(m.group(0), "")
  for m in t_end_pattern.finditer(text):
    if m.group(1):
      text = text.replace(m.group(0), f")[{m.group(1)}]")
    else:
      text = text.replace(m.group(0), m.group(2))
  return text


sets_pattern = re.compile(r"[(\[](?:['\"a-z_,]|(?:\+1)|(?:-1))+[)\]]", re.IGNORECASE | re.MULTILINE | re.DOTALL)
def gekkofy_sets(text):
  """
  >>> gekkofy_sets("foo[a,t] =E= bar[t] + foobar[t+1];")
  'foo[#a] =E= bar + foobar[+1];'
  """
  text = remove_t(text)
  for match_text in sets_pattern.findall(text):
    sets = []
    for i in match_text[1:-1].split(","):
      if i[0] in "'\"":
        sets.append(i[1:-1])
      elif i[0] in "+-":
        sets.append(i)
      else:
        sets.append(f"#{i}")
    text = text.replace(match_text, "[{}]".format(','.join(sets)))
  return text


if __name__ == "__main__":
  import doctest
  main()
