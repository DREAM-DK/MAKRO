# coding: utf-8
import os
import dreamtools as dt
import pandas as pd
from math import ceil
os.chdir(os.path.dirname(__file__))

t1 = 2021
dt.time(1983, 2060)

operator = "" # Set to "p" to see year on year percentage changes

output_folder = r"Output"
fname = "baseline"
output_extension = ".html"

DA = True # Should labels be in Danish or English?

output_path = f"{output_folder}/{fname}{output_extension}"

# If the output file already exists, delete it (to prevent accidentally viewing an old version in case of an error)
if os.path.exists(output_path):
    os.remove(output_path)

database_paths = [
    r"..\..\Model\Gdx\previous_smooth_calibration.gdx",
    r"..\..\Model\Gdx\smooth_calibration.gdx",
    # r"..\..\Model\Gdx\calibration_2018.gdx",
    # r"..\..\Model\Gdx\calibration_2019.gdx",
    # r"..\..\Model\Gdx\calibration_2020.gdx",
    # r"..\..\Model\Gdx\calibration_2021.gdx",
]

database_labels = [
    "previous_smooth_calibration",
    "smooth_calibration",
    # "calibration_2018",
    # "calibration_2019",
    # "calibration_2020",
    # "calibration_2021",
]
databases = [dt.Gdx(path) for path in database_paths]
dt.REFERENCE_DATABASE = databases[0]

from variables_to_plot import variable_labels_DK, variable_labels_EN, get_variable_functions
variable_labels = variable_labels_DK if DA else variable_labels_EN

# Collect all data to be plottet in a single dataframe
dfs = {}
for getter, variable_label in zip(get_variable_functions, variable_labels):
    try:
        df = dt.DataFrame(databases, operator, getter, names=database_labels)
        df = df.reset_index().melt(value_vars=database_labels, id_vars="t", var_name="database")
        dfs[variable_label] = df
    except Exception as e:
        print(f"Exception: {e} - {variable_label}")
    
df = pd.concat(dfs, names=["figure_label"]).reset_index(level=0)
df = pd.DataFrame(df) # Convert from dt.DataFrame to pd.DataFrame

# Plot layout settings
height_in_cm = 26
width_in_cm = 18
pixels_pr_cm = 96 / 2.54
columns_pr_page = 3
rows_pr_page = 6

# Split the variables into chunks that fit on a page
plots_pr_page = columns_pr_page * rows_pr_page
n_plots = len(variable_labels)
n_pages = ceil(n_plots / plots_pr_page)

def divide_chunks(l, n):
    """Divide a list into chunks of size n"""
    for i in range(0, len(l), n):
        yield l[i:i + n]

variable_labels_by_page = list(divide_chunks(variable_labels, plots_pr_page))

# Create the plots
figures = []
for variable_labels in variable_labels_by_page:
    fig = df[df.figure_label.isin(variable_labels)].plot(
        x="t",
        y="value",
        facet_col="figure_label",
        color="database",
        facet_col_wrap=columns_pr_page,
        facet_row_spacing= 1.5 / height_in_cm,
        facet_col_spacing= 1.5 / width_in_cm,
        labels={
            "t": "År",
            "value": ""
        }
    )

    fig.update_layout(
        legend_title_text="",
        height=height_in_cm * pixels_pr_cm,
        width=width_in_cm * pixels_pr_cm,
        legend_y = - 1.5/26,
        margin_t = 2.0 * pixels_pr_cm,
        plot_bgcolor="white",
    )

    fig.update_traces(line_width=2)
    fig.update_xaxes(ticklen=4, gridcolor=dt.dream_colors_rgb["Light gray"])
    fig.update_yaxes(ticklen=4, matches=None, showticklabels=True, gridcolor=dt.dream_colors_rgb["Light gray"])
    fig.for_each_annotation(lambda a: a.update(text=a.text.split("=")[-1]))
    fig.add_vline(x=t1, line_width=1, line_dash="dash", line_color="black")
    figures.append(fig)

# Export html report
dt.figures_to_html(figures, f"{output_folder}/{fname}.html")
