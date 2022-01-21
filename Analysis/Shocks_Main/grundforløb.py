# coding: utf-8

import os
import dreamtools as dt
from dreamtools import plot, prt
import numpy as np
import pandas as pd
import plotly.io as pio
pio.renderers.default = "notebook"
# os.chdir("...")

dt.time(2016, 2098)
r = dt.REFERENCE_DATABASE = dt.Gdx("../Model/Gdx/previous_dynamic_calibration2_q.gdx")
s = dt.Gdx("../Model/Gdx/dynamic_calibration2.gdx")

def vADAM(name):
    return dt.REFERENCE_DATABASE.ADAM[name] * dt.REFERENCE_DATABASE.inf_growth_factor * 1e-3;
def qADAM(name):
    return dt.REFERENCE_DATABASE.ADAM[name] * dt.REFERENCE_DATABASE.growth_factor * 1e-3;
def pADAM(name):
    return dt.REFERENCE_DATABASE.ADAM[name] * dt.REFERENCE_DATABASE.inf_factor;

data = [
    [s.pY['tot'], r.pY['tot'], pADAM("PX"), "Priser (pY; px)"],
    [s.vhW, r.vhW, vADAM("LNA")/vADAM("LNA")[2010], "Løn (vhW; lna)"],
    [s.pBolig, r.pBolig, pADAM("PHK"), "Boligpriser (pBolig; phk)"],
    [s.qBNP, r.qBNP, qADAM("FY"), "BNP (qBNP; fY)"],
    [s.qC["cTot"], r.qC["cTot"], qADAM("FCP"), "Privat forbrug (qC; fCp)"],
    [s.qI["iTot"], r.qI["iTot"], qADAM("FI"), "Investeringer (qI; fI)"],
    [s.qX["xTot"], r.qX["xTot"], qADAM("FE"), "Eksport (qX; fE)"],
    [s.qG["gTot"], r.qG["gTot"], qADAM("FCO"), "Offentligt forbrug (qG; fCo)"],
    [s.vHh.loc["NetFin","tot"], r.vHh.loc["NetFin","tot"], vADAM("WN_H"), "Husholdningernes financielle formue<br>(vHh[NetFin]; wn_h)"],
    [s.qKBolig, r.qKBolig, qADAM("FKNBHE"), "Boligkapital (qKBolig; fKnbhe)"],
]
df = pd.concat(
    pd.DataFrame({
        "Ny": ny.loc[range(2017, dt.END_YEAR)],
        "Ref": ref.loc[range(2017, dt.END_YEAR)],
        "ADAM": adam.loc[range(1983, dt.END_YEAR)],
        "title": title,
    }) for ny, ref, adam, title in data
)
fig = df.plot(
    facet_col="title",
    facet_col_wrap=2,
    facet_col_spacing=0.1,
    facet_row_spacing=0.03,
    height=2000,
    width=800,
    labels={"value": ""},
)
fig.for_each_annotation(lambda a: a.update(text=a.text.split("=")[-1]))
fig.update_yaxes(matches=None, showticklabels=True)
fig.layout.template = "plotly_white"
fig.show()

