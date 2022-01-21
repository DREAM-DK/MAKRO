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
import imgkit
from IPython.display import Image, SVG

# os.chdir(r"")
dt.time(2025, 2040)
r = dt.REFERENCE_DATABASE = dt.Gdx("../model/Gdx/dynamic_calibration2.gdx")

n_columns, height, width, scale = 3, 2000, 1200, 1
vertical_spacing, horizontal_spacing = 0.05, 0.05

# Defaults
output_folder = r"..\Output"  # If None: output is shown in terminal, else: exported as images to the output_folder
output_extension = ".svg"
shock_folders = [r"Gdx"]
shock_folder_descriptions = ["MAKRO"]

# Compare multiple versions
# output_folder = r"..\Output"
# shock_folders = [
#     r"..\Output\Baseline",
#     r"Gdx",
# ]
# shock_folder_descriptions = [
#     "Baseline",
#     "New",
# ]

if output_folder:
    # Create output folder if it does not exist
    if not os.path.exists(output_folder):
        os.mkdir(output_folder)
    # Save copy of matching_shocks.gdx in output folder
    shutil.copyfile(os.path.join(shock_folders[-1], "matching_shocks.gdx"), os.path.join(output_folder, "matching_shocks.gdx"))

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

def wrap_to_2_lines(text):
    """Split string into two lines of simliar widths separated by a html line break."""
    lines = [[], []]
    words = text.split()
    while words:
        if len(" ".join(lines[0])) <= len(" ".join(lines[1])):
            lines[0].append(words.pop(0))
        else:
            lines[1].insert(0, words.pop())
    return " ".join(lines[0]) + "<br>" + " ".join(lines[1]) + "<br> "

def plot_irf_matches(databases, loss_function_only=True):
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

    if loss_function_only:  # Remove any IRF that has no effect on loss function
        data = data[data.IRF.isin(ref_db.loss[ref_db.loss>0].index.unique("IRF"))]
    data = data[(dt.START_YEAR <= data.t) & (data.t <= dt.END_YEAR)]
    scenarios, IRFs = data.scen.unique(), data.IRF.unique()

    data = data.set_index(["scen", "IRF", "variable", "t"]).unstack("variable")
    data.columns = data.columns.droplevel()

    fig = make_subplots(
        cols=len(scenarios), rows=len(IRFs),
        subplot_titles= [ref_db.scen.texts[i] for i in scenarios],
        row_titles=[wrap_to_2_lines(ref_db.IRF.texts[i]) for i in IRFs],
        vertical_spacing=vertical_spacing,
        horizontal_spacing=horizontal_spacing,
    )

    for row, IRF in enumerate(IRFs, 1):
        for col, scen in enumerate(scenarios, 1):
            df = data.loc[scen,IRF]
            # Add Median line with confidence band based on Lower and Upper
            filled_line(fig, df["median"], df["upper"], df["lower"], df.index, (0, 0, 0), "Empirical response", row, col, showlegend=(row+col==2))

            # Add line for each model
            for model, color in zip(shock_folder_descriptions, dt.dream_template.layout.colorway):
                fig.add_trace(go.Scatter(
                    x=df.index,
                    y=df[model],
                    line_color=color,
                    name=model,
                    mode="lines",
                    legendgroup=model,
                    showlegend=(row+col==2),
                ), row=row, col=col)

    fig.update_layout(
            height=height, width=width,
            template = "plotly_white",
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

databases = [dt.Gdx(os.path.join(folder, "matching_shocks.gdx")) for folder in shock_folders]
fig = plot_irf_matches(databases)
fname = "matching"
if output_folder:
    fig.write_image(os.path.join(output_folder, f"{fname}{output_extension}"), scale=scale)
else:
    print(f"{'='*80}\n{fname}\n{'='*80}")
    fig.show()

def image_from_html(html, name):
    imgkit.from_string(html, name, options={"quiet": ""})
    if os.path.splitext(name)[-1] == ".svg":
        return SVG(name)
    else:
        return Image(name)

def add_totals_to_dataframe(df, row_name="Row total", col_name="Column total"):
    """Add row and column totals to dataframe"""
    df.loc[row_name]= df.sum(numeric_only=True, axis=0)
    df.loc[:,col_name] = df.sum(numeric_only=True, axis=1)
    return df

def loss_table(database, reference=None):
    """
    Returns a formated table of loss function values as {output_extension} image.
    If a reference database is given, the difference is shown in parenthesis.
    """
    dataframes = []
    for db in [reference, database]:
        if db is not None:
            df = db.loss.reset_index("scen").pivot(columns=["scen"])
            df.index = db.IRF.texts[df.index]
            df.columns = db.scen.texts.loc[df.columns.droplevel()]
            df = add_totals_to_dataframe(df, "Shock total", "IRF total")
            dataframes.append(df)
    if reference:
        change = (" (" + (dataframes[1] - dataframes[0]).replace(0, np.NaN).round(2).astype(str) + ")").replace(" (nan)", "")
        df = dataframes[1].round(2).replace(0, "").astype(str) + change
    else:
        df = dataframes[0]
    return df

# def parameter_table(databases):
#     def getter(self, name):
#         if name in self:
#             return self[name]
#         else:
#             for db in databases:
#                 if name in db:
#                     return db[name] * np.NaN
#                 else:
#                     return None
#     r.__class__.__getattr__ = getter
#     matching_parameter = [
#         ("uKInstOmk[iB]", "Bygnings-installations-omkostning", *[db.uKInstOmk.loc["IB","tje"] for db in databases]),
#         ("uKInstOmk[iM]", "Maskin-installations-omkostning", *[db.uKInstOmk.loc["IM","tje"] for db in databases]),
#         ("eKUdn[iB]", "Kapacitetsudnyttelse, bygninger", *[db.eKUdn["IB"] for db in databases]),
#         ("eKUdnPersistens[iB]", "Persistens i kapacitetsudnyttelse, bygninger", *[db.eKUdnPersistens["IB"] for db in databases]),
#         ("eKUdn[iM]", "Kapacitetsudnyttelse, maskiner", *[db.eKUdn["IM"] for db in databases]),
#         ("eKUdnPersistens[iM]", "Persistens i kapacitetsudnyttelse, maskiner", *[db.eKUdnPersistens["IM"] for db in databases]),
#         ("eLUdn", "Kapacitetsudnyttelse, arbejdskraft", *[db.eLUdn for db in databases]),
#         ("eLUdnPersistens", "Persistens i kapacitetsudnyttelse, arbejdskraft", *[db.eLUdnPersistens for db in databases]),
#         ("upYTraeghed", "Pristræghed (Rotemberg-omkostning)", *[db.upYTraeghed["tje"] for db in databases]),
#         ("rLoenTraeghed", "Løntræghed (Calvo-andel) ", *[db.rLoenTraeghed for db in databases]),
#         ("rLoenIndeksering", "Lønindeksering", *[db.rLoenIndeksering for db in databases]),
#         ("rFFLoenAlternativ", "Fagforenings forhandlingsalternativ som andel af løn", *[db.rFFLoenAlternativ for db in databases]),
#         ("eMatching", "Eksponent i matching-funktion", *[db.eMatching for db in databases]),
#         ("uMatchOmk", "Lineær oplærings-omkostning", *[db.uMatchOmk for db in databases]),
#         ("uMatchOmkSqr", "Kvadratisk omstillings-omkostning på arbejdskraft", *[db.uMatchOmkSqr for db in databases]),
#         ("rfZhTraeghed", "Træghed i aftrapning af indkomsteffekter på intensiv margin.", *[db.rfZhTraeghed for db in databases]),
#         ("rRef", "Andel referenceforbrug", *[db.rRef for db in databases]),
#         ("rRefBolig", "Andel referenceforbrug for bolig", *[db.rRefBolig for db in databases]),
#         ("fBoligGevinst", "Skalering af forventede boliggevinster", *[db.fBoligGevinst for db in databases]),
#         ("rHtM", "Andel hånd-til-mund-forbrugere", *[db.rHtM for db in databases]),
#         ("uBoligHtM_match", "uBoligHtM_match", *[db.uBoligHtM_match for db in databases]),
#         ("uIBoligInstOmk", "Installationsomkostninger for boligkapital i nybyggeri", *[db.uIBoligInstOmk for db in databases]),
#         ("rXTraeghed", "Eksporttræghed", *[db.rXTraeghed for db in databases]),
#         ("upXyTraeghed", "Træghed i priseffekt på eksport", *[db.upXyTraeghed for db in databases]),
#         ("rpMTraeghed", "Træghed i priseffekt på import", *[db.rpMTraeghed.loc["tje","tje"] for db in databases]),
#         ("rRealKredTraeg", "Træghed i pBoligRigid", *[db.rRealKredTraeg for db in databases]),
#         ("rOffLTraeghed", "Træghed i offentlig beskæftigelse.", *[db.rOffLTraeghed for db in databases]),
#     ]
#     df = pd.DataFrame(matching_parameter, columns=["Variabel-navn", "Beskrivelse", *shock_folder_descriptions]).set_index("Variabel-navn")
#     html = dt.html_table(df, header=True)
#     return html

# image_from_html(parameter_table(databases), os.path.join(output_folder, f"parameters{output_extension}"))

loss_dataframe = loss_table(
    databases[-1],
    reference=databases[0] if len(databases) > 1 else None,
)
file_path = os.path.join(output_folder if output_folder else "", "loss")
_ = image_from_html(dt.html_table(loss_dataframe), f"{file_path}{output_extension}")


