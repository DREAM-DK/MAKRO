import os, shutil
import sys
from IPython.core.display import display
import pandas as pd
import numpy as np
import gams
import dreamtools as dt
from dreamtools import plot, prt
import plotly.io as pio
import plotly.express as px
from plotly.subplots import make_subplots
import plotly.graph_objects as go
from math import ceil
pio.renderers.default = "notebook"
from IPython.display import Image, SVG


# -------------------------------------------------------------------------------------------------------------------
# Define function
# -------------------------------------------------------------------------------------------------------------------
def filled_line(fig, y, upper, lower, x, color, name, row, col, **kwargs):
    fig.add_trace(go.Scatter(
        x=[*x, *x[::-1]],
        y=[*upper, *lower[::-1]],
        fill="toself",
        fillcolor=f"rgba{(*color, 0.15)}",
        line_color="rgba(255,255,255,0)",
        legendgroup=name,
        showlegend=False,
    ), row=row, col=col)

    fig.add_trace(go.Scatter(
        x=x,
        y=y,
        line_color=f"rgba{(*color, 0.25)}",
        line_dash="dash",
        name=name,
        mode="lines",
        legendgroup=name,
        **kwargs,
    ), row=row, col=col)

    return fig

def plot_irf_matches_single(databases, scenario, columns_n):
    ref_db = databases[-1]
    data = {
        "median": ref_db.median*100,
        "upper": ref_db.upper*100,
        "lower": ref_db.lower*100,
    }

    for name, db in zip(shock_folder_descriptions, databases):
        data[name] = db.MAKRO * 100
    data = pd.DataFrame(data).stack().reset_index()
    data.columns = ["IRF", "t", "scen", "variable", "value"]

    data = data[(dt.START_YEAR <= data.t) & (data.t <= dt.END_YEAR)]
    IRFs =  data.IRF.unique()
        
    data = data.set_index(["scen", "IRF", "variable", "t"]).unstack("variable")
    data.columns = data.columns.droplevel()
    IRFs = np.array([IRF for IRF in IRFs if any(data.loc[scenario, IRF]["median"] != 0)])    #Remove any empty IRFs with no empirical responses
            
    #Define Column and Rows sizes
    columns_n = min(columns_n, len(IRFs))
    rows_n = ceil(len(IRFs) / columns_n)
    fig = make_subplots(
        cols=columns_n, rows=rows_n,
        subplot_titles= [ref_db["IRF"].texts[i] for i in IRFs],
        vertical_spacing=vertical_spacing,
        horizontal_spacing=horizontal_spacing,
    )
    col, row = 1, 1
    for IRF in IRFs:
        df=data.loc[scenario, IRF]
        filled_line(fig, df["median"], df["upper"], df["lower"], df.index, (0, 0, 0), "Empirical response", row, col, showlegend=(row+col==2))
        fig.add_trace(go.Scatter(
            x=df.index,
            y=df["MAKRO"],
            line_color=dt.dream_template.layout.colorway[0],
            name="MAKRO",
            mode="lines",
            legendgroup="MAKRO",
            showlegend=(row+col==2),
            ), row=row, col=col)
        col += 1
        if col > columns_n:
            col = 1
            row += 1
    fig.update_layout(
            height=height, width=width,
            legend=dict(
                yanchor="bottom",
                xanchor="center",
                orientation="h",
                y=-0.1,
                x=0.5,
            )
    )
    fig.for_each_annotation(lambda a: a.update(text=a.text.split("=")[-1]))
    fig.update_yaxes(zerolinecolor="rgb(100,100,100)", zerolinewidth=1, title="")
    fig.update_xaxes(title="")
    fig.for_each_annotation(lambda a: a.update(font_size=14, font_family="Hind"))
    return fig


# -------------------------------------------------------------------------------------------------------------------
# Dashboard
# -------------------------------------------------------------------------------------------------------------------
# os.chdir(r"C:\...\Analysis")

dt.time(2025, 2040)
r = dt.REFERENCE_DATABASE = dt.Gdx("../model/Gdx/dynamic_calibration2.gdx")

columns_n,  height, width, scale = 4, 800, 1200, 4
vertical_spacing, horizontal_spacing = 0.12, 0.05

output_folder = r"..\Output"  # If None: output is shown in terminal, else: exported as images to the output_folder
output_extension = ".png"
shock_folders = [r"Gdx"]
shock_folder_descriptions = ["MAKRO"]

databases = [dt.Gdx(os.path.join(folder, "matching_shocks.gdx")) for folder in shock_folders]

# for scenario in databases[-1].scen:
    fig = plot_irf_matches_single(databases, scenario, columns_n)

    if output_folder:
        fig.write_image(os.path.join(output_folder, f"{scenario}{output_extension}"), scale=scale)
    else:
        print(f"{'='*80}\n{fname}\n{'='*80}")
        fig.show()
