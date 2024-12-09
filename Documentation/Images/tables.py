from dreamtools import prt, plot
import dreamtools as dt
import os
import pandas as pd
import plotly.graph_objects as go
import xlwings as xw

t = 2022
b = dt.REFERENCE_DATABASE = dt.Gdx(f"../../Model/Gdx/calibration_{t}.gdx")
# swap index elements
s_index = b.s[0:-3]
final_list = ["off", "ene", "udv"]
s_index = s_index.append(pd.Index(final_list))
b.s = s_index

s_labels = {
    "tje": "Services, other (tje)",
    "fre": "Manufacturing (fre)",
    "byg": "Construction (byg)",
    "lan": "Agriculture (lan)",
    "soe": "Shipping (soe)",
    "bol": "Housing (bol)",
    "off": "Public (off)",
    "ene": "Energy provision (ene)",
    "udv": "Extraction (udv)",
}

y = b.vIOy * b.fvt
m = b.vIOm * b.fvt

y = y.loc[b.d,b.s][:,:,t].reset_index()
y["s_"] = [s_labels[x] for x in y["s_"]]
y = y.pivot(columns="d_", values=0, index="s_")
y.index.name = ""
y.columns.name = ""

m = m.loc[b.d,b.s][:,:,t].reset_index()
m["s_"] = [s_labels[x] for x in m["s_"]]
m = m.pivot(columns="d_", values=0, index="s_")
m.index.name = ""
m.columns.name = ""

m = m[m.sum(axis=1) > 0]

# Export to Excel so that we can finely control formatting including borders
wb = xw.Book('tables.xlsx')  

sheet = wb.sheets["IO"]

sheet["A1"].value = t

columns = [*b.s, *b.i]
sheet["B3"].value = y[columns]
sheet["B13"].options(header=False).value = m[columns]



columns = [*b.c, *b.g, *b.x]
sheet["Q3"].value = y[columns]
sheet["Q13"].options(header=False).value = m[columns]

# Add demand totals
y["xTot"] = y[b.x].sum(axis=1)
y["private"] = y[b.sp].sum(axis=1)
y["public"] = y["off"]
m["xTot"] = m[b.x].sum(axis=1)
m["private"] = m[b.sp].sum(axis=1)
m["public"] = m["off"]
y["iTot"] = y[b.i].sum(axis=1)
m["iTot"] = m[b.i].sum(axis=1)
y["rTot"] = y[b.s].sum(axis=1)
m["rTot"] = m[b.s].sum(axis=1)

sheet = wb.sheets["public_production"]
columns = ["private", "public", *b.c, *b.g, *b.i, "xTot"]
sheet["C3"].value = y[columns]
sheet["C13"].options(header=False).value = m[columns]

sheet = wb.sheets["exports"]
columns = ["rTot", *b.c, *b.g, "iTot", *b.x]
sheet["C3"].value = y[columns]
sheet["C13"].options(header=False).value = m[columns]

sheet["Q18"].value = b.vXy["xTur"][t]
sheet["E18"].value = b.vCTurist.loc[b.c,t].values

