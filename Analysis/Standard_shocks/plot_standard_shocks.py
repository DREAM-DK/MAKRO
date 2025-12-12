# coding: utf-8
"""
Script to plot responses to standard shocks, optionally comparing multiple model versions
"""
import os
import sys
import dreamtools as dt
import pandas as pd
from math import ceil
import dataframe_image as dfi
import plotly.figure_factory as ff
sys.path.insert(0, os.path.abspath("../Templates")) # Add the Templates folder to the path so we can import variables_to_plot

# variables_to_plot.py currently requires dt.REFERENCE_DATABASE to be set
dt.REFERENCE_DATABASE = dt.Gdx(fr"../../Model/Gdx/sets.gdx")

import variables_to_plot as vtp

t1 = 2030 # Shock year
T = 2050 # Last year to plot
dt.time(t1-1, T)

output_folder = r"Output"
table_folder = r"Output/tables"
fname = "standard_shocks"
output_extension = ".png"

# Create output folder and tables_html folder if it does not exist
if not os.path.exists(output_folder):
    os.makedirs(output_folder)
if not os.path.exists(table_folder):
    os.makedirs(table_folder)

DA = True # Should labels be in Danish or English? 

# List of tuples with (<path to a folder with gdx files>, <a label for this folder / version>)
gdx_folders_info = [
    (r"Gdx", ""),
    # (r"<path here>", "<Label for model version>"),
]
gdx_folders, gdx_labels = zip(*gdx_folders_info)

# For each shock, we look for a gdx file with the name of the shock and a suffix attached
# The suffix is used to distinguish between different versions of the same shock
# For each variation, we also supply a label
variations_info = [
    # ("_blip", "Blip", "Blip"),
    ("_midl", "Midlertidig", "Transitory"),
    # ("_perm", "Permanent", "Permanent"),
    # ("_ufin", "Permanent ufinansieret", "Permanent unfinanced"),
]
shock_variation_suffixes, shock_variation_labels_DA, shock_variation_labels_EN = zip(*variations_info)

# Import information on which shocks to plot and how to plot them
from shocks_to_plot import shock_names, shock_labels_DA, shock_labels_EN, shock_specific_plot_info

# Import information on which variables to plot and how to plot them

# Select which figures to plot
figure_info = [
    *vtp.page_1_figures,
    # *vtp.page_2_figures,
    # *vtp.public_production_figures,
    # *vtp.aggregates_figures,
    # *vtp.consumers_figures,
    # *vtp.exports_figures,
    # *vtp.government_figures,
    # *vtp.HHIncome_figures,
    # *vtp.IO_figures,
    # *vtp.LaborMarket_figures,
    # *vtp.Pricing_figures,
    # *vtp.Productionprivate_figures,
    # *vtp.finance_figures,
    # *vtp.ekstra_figures,
    # *vtp.sector_plot("tje"),
    # *vtp.sector_plot("fre"),
    # *vtp.sector_plot("byg"),
    # *vtp.sector_plot("bol"),
]

variable_labels_DK, variable_labels_EN, get_variable_functions, operators = [list(t) for t in zip(*figure_info)]
def append_spaces_to_make_unique(strings):
    """Hack to make sure labels are also unique identifiers by adding spaces"""
    unique_labels = []
    for string in strings:
        if string not in unique_labels:
            unique_labels.append(string)
        else:
            new_string = string + ' '
            while new_string in unique_labels:
                new_string += ' '
            unique_labels.append(new_string)
    return unique_labels

variable_labels_DK = append_spaces_to_make_unique(variable_labels_DK)
variable_labels_EN = append_spaces_to_make_unique(variable_labels_EN)
# Set labels depending on language
variable_labels = variable_labels_DK if DA else variable_labels_EN
shock_labels = shock_labels_DA if DA else shock_labels_EN
shock_variation_labels = shock_variation_labels_DA if DA else shock_variation_labels_EN

def shock_files_exist(shock):
    """Return True if GDX files exist for each variation of the shock"""
    return all(
        os.path.exists(fr"{folder}/{shock}{suffix}.gdx")
        for suffix in shock_variation_suffixes
        for folder, _ in gdx_folders_info
    )

# Labels for y-axes are based on the type of multiplier
# if more unique labels are needed, we can add them directly in the variables_info list instead
yaxis_title_from_operator = {
    "pq": "Pct.-ændring" if DA else "Pct. change",
    "pm": "Ændring i pct.-point" if DA else "Change in pct. points",
    "": "",
}

# Create dataframe with all combinations of shocks, variations, model versions, and variables
data = []
for folder, folder_label in gdx_folders_info:
    baseline = dt.Gdx(fr"{folder}/baseline.gdx")
    for shock_name, shock_label, shock_specific_plot in zip(shock_names, shock_labels, shock_specific_plot_info):
        if not shock_files_exist(shock_name):
            print(f"Skipping '{shock_name}' as one or more GDX files are missing")
            continue

        # Replace first plot with shock-specific plot info
        variable_label_DK, variable_label_EN, getter, operator = shock_specific_plot
        variable_labels[0] = variable_label_DK if DA else variable_label_EN
        get_variable_functions[0] = getter
        operators[0] = operator

        for suffix, variation_label in zip(shock_variation_suffixes, shock_variation_labels):
            database = dt.Gdx(fr"{folder}/{shock_name}{suffix}.gdx")
            for variable_index, (variable_label, getter, operator) in enumerate(zip(
                variable_labels,
                get_variable_functions,
                operators
            )):
                data.append({
                    "variable_index": variable_index,
                    "folder": folder,
                    "folder_label": folder_label,
                    "shock_name": shock_name,
                    "shock_label": shock_label,
                    "variation": suffix,
                    "variation_label": variation_label,
                    "database": (database,), # Wrap in tuple to force pandas to treat as object
                    "baseline": (baseline,), # Wrap in tuple to force pandas to treat as object
                    "getter": getter,
                    "variable_label": variable_label,
                    "operator": operator,
                })
data = pd.DataFrame(data)

def get_multiplier(row):
    """Get multiplier for a given row in the dataframe"""
    return dt.DataFrame(row.database, row.operator, row.getter, baselines=row.baseline).squeeze()

# Apply get_multiplier to each row in the dataframe to fetch shock responses from databases
# and merge with the original dataframe
df = (data
    .apply(get_multiplier, axis=1)
    .melt(ignore_index=False)
    .join(data)
)

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
indices_by_page = list(divide_chunks(list(df.variable_index.unique()), plots_pr_page))

def get_yaxis(fig, i, facet_col_wrap):
    """Get the yaxis for the ith facet in a facet plot"""
    yaxes = list(fig.select_yaxes())
    n = len(yaxes)
    n_cols = min(facet_col_wrap, n)
    n_rows = n // n_cols
    idx = [[n-((1+r)*n_cols-c) for c in range(n_cols)] for r in range(n_rows)]
    idx = [item for sublist in idx for item in sublist]
    return yaxes[idx[i]]

figures = {}

# Plot all shock responses
for shock_label in df.shock_label.unique():
    for page_number, variable_index in enumerate(indices_by_page, 1):
        data = df[(df.shock_label==shock_label) & df.variable_index.isin(variable_index)]
        fig = data.plot(
            x="t",
            y="value",
            facet_col="variable_label",
            color="variation_label",
            line_dash="folder_label" if len(gdx_folders_info) > 1 else None,
            title=f"<b>Stød til {shock_label.lower()}</b>" if DA else f"<b>Shock to {shock_label.lower()}</b>",
            facet_col_wrap=columns_pr_page,
            facet_row_spacing= 1.5 / height_in_cm,
            facet_col_spacing= 1.5 / width_in_cm,
            labels={
                "t": "År" if DA else "year",
                "value": "Multiplier",
                "variation_label": "Varighed" if DA else "Persistence",
                "variable_lable": "Variable",
                "folder_label": "Model version",
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
        operators = data.operator[~data.variable_index.duplicated()]
        yaxis_titles = [yaxis_title_from_operator[operator] for operator in operators]
        for i, yaxis_title in enumerate(yaxis_titles):
            get_yaxis(fig, i, columns_pr_page).update(title_text=yaxis_title)

        dt.vertical_legend(fig, len(variations_info))
        fig.for_each_annotation(lambda a: a.update(text=a.text.split("=")[-1]))

        figure_name = f"{shock_label} {page_number}"
        figures[figure_name] = fig
        dt.write_image(fig, f"{output_folder}/{figure_name}{output_extension}")

report_figures = list(figures.values())

# Export html report
dt.figures_to_html(report_figures, f"{output_folder}/{fname}.html")

# Export pdf report
from pdf_report import figures_to_pdf
figures_to_pdf(report_figures, f"{output_folder}/{fname}.pdf")


"""
Create tables with the values of the multipliers in different years
"""
styles = [
    # General styling of the table
    dict(
        selector="tr",
        props=[
            ("background", "#E6E6E8"),
            ("text-align", "left"),
            ("font-family", "Arial, sans-serif"),
        ],
    ),
    # Style the header
    dict(
        selector="th",
        props=[
            ("color", "White"),
            ("padding", "30px 15px"),
            ("background", "#0F837D"),
            ("font-size", "12px"),
            ("text-align", "left"),
            ("font-weight", "bold"),
        ],
    ),
    # Style the cells
    dict(selector="td", props=[("padding", "13px 15px"), ("font-size", "12px")]),
    # Style the caption
    dict(
        selector="caption",
        props=[
            ("caption-side", "Top"),
            ("font-family", "Arial, sans-serif"),
            ("font-size", "16px"),
        ],
    ),
]

# Create dictionaries to store styled tables
tables = {}

# Create tables with the values of the multipliers in different years
for shock_name in df.shock_name.unique():
    shock_data = df[df.shock_name == shock_name]
    
    # Create a dataframe for each variation
    for suffix, variation_label_DA, variation_label_EN in variations_info:
        variation_label = variation_label_DA if DA else variation_label_EN
        variation_data = shock_data[shock_data.variation == suffix]
        
        # Pivot the data to get the desired table structure
        table_data = variation_data.pivot_table(index="variable_label", columns="t", values="value", aggfunc="sum")
        
        # Select only the desired years
        years = [t1, t1+1, t1+2]
        if suffix in ["_perm", "_ufin"]:
            years += [T]
        table_data = table_data[[int(year) for year in years]]
        
        # Add the variable labels as the first column
        table_data.reset_index(inplace=True)
        
        # Round the values to 2 decimal places and convert to string
        table_data.iloc[:, 1:] = table_data.iloc[:, 1:].map(lambda x: str(round(x, 2)))

        
        # Add units to the values
        for i, col in enumerate(table_data.columns[1:]):
            for j, op in enumerate(operators):
                if op == "pq":
                    table_data.iloc[j, i+1] += " %"
                elif op == "pm":
                    table_data.iloc[j, i+1] += " %-point"
        
        # Apply the styles to the dataframe and style the first row (header)
        table = table_data.style.set_table_styles(styles).set_properties(subset=pd.IndexSlice[:, :],**{
                "background-color": "#E6E6E8",
                "color": "Black",},).hide(axis="index").set_caption(f"{shock_name} - {variation_label}")
        
        tables[f"{shock_name} {variation_label}"] = table

# Export the tables to html
for key, table in tables.items():
    table.to_html(f"{table_folder}/{key}.html")

# Combine html files to one
import glob
from pyhtml2pdf import converter # Chrome must be installed on the machine

html_files = glob.glob(f"{table_folder}/*.html")

with open(f"{output_folder}/TablesCombined.html", "w") as outfile:
    for file in html_files:
        with open(file, "r") as infile:
            outfile.write(infile.read())

# Convert each html files into a pdf
for file in html_files:
    path = os.path.abspath(file)
    converter.convert(f'{path}', f'{file[:-5]}.pdf')

# Merge the pdf files into one
from PyPDF2 import PdfMerger
pdfs = glob.glob(f"{table_folder}/*.pdf")
merger = PdfMerger()
for pdf in pdfs:
    merger.append(pdf)
merger.write(f"{output_folder}/TablesCombined.pdf")
