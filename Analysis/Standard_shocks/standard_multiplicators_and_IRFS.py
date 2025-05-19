import os
import sys
import dreamtools as dt
import pandas as pd
import joblib
from plotly.subplots import make_subplots
import plotly.graph_objects as go
import glob
from pyhtml2pdf import converter
from PyPDF2 import PdfMerger

# Set reference database
dt.REFERENCE_DATABASE = dt.Gdx(fr"../../Model/Gdx/sets.gdx")

# Import variables to plot
sys.path.insert(0, os.path.abspath("../Templates"))
import variables_to_plot as vtp 

# Define constants
t1 = 2030  # Shock year
T = 2050  # Last year to plot
dt.time(t1-1, T)

output_folder = r"Output"
table_folder = r"Output\tables"
fname = "standard_shocks"
output_extension = ".png"

# Create output and table folders if they do not exist
os.makedirs(output_folder, exist_ok=True)
os.makedirs(table_folder, exist_ok=True)

DA = True  # Should labels be in Danish or English?
FM_multipliers = True  # Should the multipliers be in full model or standard model?
FM_tab_previous = False  # Tab previous version of FM multipliers alongside new version

# Define GDX folders and labels
gdx_folders_info = [
    (r"Gdx", ""),
    # (r"<path here>", "<Label for model version>"),
]
gdx_folders, gdx_labels = zip(*gdx_folders_info)

# Define variations info
variations_info = [
    ("_midl", "Midlertidig", "Transitory"),
]
shock_variation_suffixes, shock_variation_labels_DA, shock_variation_labels_EN = zip(*variations_info)

# Import information on which shocks to plot and how to plot them
from shocks_multiplicator_table import shock_names as table_shock_names, shock_labels_DA as table_shock_labels_DA, shock_labels_EN as table_shock_labels_EN, shock_specific_plot_info as table_shock_specific_plot_info
from shocks_to_plot import shock_names as plot_shock_names, shock_labels_DA as plot_shock_labels_DA, shock_labels_EN as plot_shock_labels_EN, shock_specific_plot_info as plot_shock_specific_plot_info

# Select which figures to plot
figure_info = vtp.standard_IRF_check_figures

# Add custom CSS for the table to make it more visually appealing
html_style = """
<style>
    body {
        font-family: Arial, sans-serif;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin: 20px 0;
    }
    th {
        padding: 10px;
        text-align: center;
        border: 1px solid #ddd;
        background-color: #0F837D;
        color: white;
    }
    td {
        padding: 10px;
        text-align: center;
        border: 1px solid #ddd;
    }
    tr:hover {
        background-color: #f9f9f9;
    }
    .table-striped tr:nth-child(odd) {
        background-color: #f9f9f9;
    }
    .table-hover tr:hover {
        background-color: #f1f1f1;
    }
</style>
"""

# Define variable labels and functions
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
table_shock_labels = table_shock_labels_DA if DA else table_shock_labels_EN
plot_shock_labels = plot_shock_labels_DA if DA else plot_shock_labels_EN
shock_variation_labels = shock_variation_labels_DA if DA else shock_variation_labels_EN

def shock_files_exist(shock):
    """Return True if GDX files exist for each variation of the shock"""
    return all(
        os.path.exists(fr"{folder}\{shock}{suffix}.gdx")
        for suffix in shock_variation_suffixes
        for folder, _ in gdx_folders_info
    )

# Labels for y-axes based on the type of multiplier
yaxis_title_from_operator = {
    "pq": "Pct.-ændring" if DA else "Pct. change",
    "pm": "Ændring i pct.-point" if DA else "Change in pct. points",
    "": "",
}

def create_dataframe(shock_names, shock_labels, shock_specific_plot_info):
    """Create dataframe with all combinations of shocks, variations, model versions, and variables"""
    data = []
    for folder, folder_label in gdx_folders_info:
        baseline = dt.Gdx(fr"{folder}\baseline.gdx")
        for shock_name, shock_label, shock_specific_plot in zip(shock_names, shock_labels, shock_specific_plot_info):
            if not shock_files_exist(shock_name):
                print(f"Skipping '{shock_name}' as one or more GDX files are missing")
                continue

            for suffix, variation_label in zip(shock_variation_suffixes, shock_variation_labels):
                database = dt.Gdx(fr"{folder}\{shock_name}{suffix}.gdx")
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
                        "database": (database,),  # Wrap in tuple to force pandas to treat as object
                        "baseline": (baseline,),  # Wrap in tuple to force pandas to treat as object
                        "getter": getter,
                        "variable_label": variable_label,
                        "operator": operator,
                    })
    return pd.DataFrame(data)

# Create dataframes for tables and plots
if FM_multipliers:
    table_data = create_dataframe(table_shock_names, table_shock_labels, table_shock_specific_plot_info)
plot_data = create_dataframe(plot_shock_names, plot_shock_labels, plot_shock_specific_plot_info)

def get_multiplier(row):
    """Get multiplier for a given row in the dataframe"""
    return dt.DataFrame(row.database, row.operator, row.getter, baselines=row.baseline).squeeze()

# Apply get_multiplier to each row in the dataframes to fetch shock responses from databases
if FM_multipliers:
    df_FM = (table_data
        .apply(get_multiplier, axis=1)
        .melt(ignore_index=False)
        .join(table_data)
    )
    fname = "previous_shocks_FM"
    Gdx_folder = "Gdx"

    # Load previous shock data from a file
    df_FM_previous = joblib.load(f"{Gdx_folder}/{fname}.pkl")
    # Remove lambda functions and complex objects before saving
    df_FM_no_complex = df_FM.drop(columns=['getter', 'database', 'baseline'])
    # Save plot_data_no_complex to a file
    joblib.dump(df_FM_no_complex, f"{Gdx_folder}/{fname}.pkl")
    
    models_FM = [(df_FM_previous, fname), (df_FM, "current_shocks_FM")]  # for comparison between previous and current shocks

df_plot = (plot_data
    .apply(get_multiplier, axis=1)
    .melt(ignore_index=False)
    .join(plot_data)
)

fname = "previous_shocks"
Gdx_folder = "Gdx"

# Load previous shock data from a file
df_previous = joblib.load(f"{Gdx_folder}/{fname}.pkl")
models = [(df_previous, fname), (df_plot, "current_shocks")]  # for comparison between previous and current shocks

# Remove lambda functions and complex objects before saving
df_plot_no_complex = df_plot.drop(columns=['getter', 'database', 'baseline'])
# Save plot_data_no_complex to a file
joblib.dump(df_plot_no_complex, f"{Gdx_folder}/{fname}.pkl")

# Create tables with the values of the multipliers in different years
if FM_multipliers:
    # Initialize a list to store the results for the table
    table_data = []

    # Loop over model, variable, and shock
    for model, color in zip(models_FM, dt.dream_colors_rgb.values()):
        for row, variable_label in enumerate(variable_labels, 1):
            for col, shock_name in enumerate(table_shock_names, 1):
                df_current = model[0]
                data = df_current[(df_current.shock_name == shock_name) & (df_current.variable_label == variable_label)]
                # Extract the first year effect (first value in the data)
                first_year_effect = data.value.iloc[1] if not data.empty else None
                # Append the result to the table data (model, shock, variable, and the first year effect)
                shock_label = data.shock_label.unique()[0]
                table_data.append([model[1], variable_label, shock_label, first_year_effect])

    # Make table comparing old and new if so chosen
    # Create a DataFrame from the table data
    table_df = pd.DataFrame(table_data, columns=['Model', 'Variable', 'Shock', 'First Year Effect'])

    # Handle different table structures based on FM_tab_previous
    if not FM_tab_previous:
        # Pivot with shocks as columns and variables as rows
        pivot_table = table_df.pivot_table(
            index='Variable', 
            columns='Shock', 
            values='First Year Effect',
            aggfunc='mean'  # Handles duplicates, if any
        )
        # Flatten the MultiIndex columns for better readability (if needed)
        pivot_table.columns = [col for col in pivot_table.columns]
        header = True
    else:
        # Pivot with shocks and variables as index, models as columns
        pivot_table = table_df.pivot_table(
            index=['Variable', 'Shock'], 
            columns='Model', 
            values='First Year Effect'
        ).reorder_levels(['Shock', 'Variable']).sort_index()
        header = True

    # General formatting for the pivot table
    pivot_table = (
        pivot_table
        .fillna(0)  # Replace NaN with 0
        .round(4)   # Round values to 2 decimal places
    )

    # Generate the HTML table with custom styling
    html_table = pivot_table.to_html(
        escape=False,  # Allow HTML tags like <br> to render in the table
        border=0,      # No borders around cells
        classes="table table-striped table-hover",  # Bootstrap classes for styling
        justify="center",  # Center-align the table
        header=header,     # Display column headers
        index=True         # Display index
    )
    # Combine CSS and HTML table
    full_html = html_style + html_table

    # Save the nicely formatted table as an HTML file
    with open(f"{table_folder}/standard_multipliers_FM.html", "w") as f:
        f.write(full_html)

# Plot all shock responses
shock_names_IRF = ["Eksportmarkedsvækst", "Udenlandske priser", "Rente", "Arbejdsudbud, beskæftigelse", "Offentlige varekøb", "Bundskat"]
variable_labels = [entry[0] for entry in figure_info]

fig = make_subplots(
    cols=len(shock_names_IRF), rows=len(variable_labels),
    subplot_titles=shock_names_IRF,
    row_titles=variable_labels,
    vertical_spacing=0.05,
    horizontal_spacing=0.05,
)

fig.update_layout(
    height=2000, width=1200,
    template="plotly_white",
    legend=dict(
        xanchor="center",
        orientation="h",
        y=-0.05,
        x=0.5,
    )
)

fig.for_each_annotation(lambda a: a.update(font_size=14, font_family="Hind"))

# Initialize a list to store the results for the table
table_data = []

# Loop over model, variable, and shock
for model, color in zip(models, dt.dream_colors_rgb.values()):
    for row, variable_label in enumerate(variable_labels, 1):
        for col, shock_label in enumerate(shock_names_IRF, 1):
            df_current = model[0]
            data = df_current[(df_current.shock_label == shock_label) & (df_current.variable_label == variable_label)]
            # Extract the first year effect (first value in the data)
            first_year_effect = data.value.iloc[1] if not data.empty else None
            # Append the result to the table data (model, shock, variable, and the first year effect)
            table_data.append([model[1], variable_label, shock_label, first_year_effect])
            fig.add_trace(go.Scatter(
                y=data.value,
                x=data.t,
                line_color=color,
                name=model[1],
                mode="lines",
                legendgroup=model[1],
                showlegend=(row+col==2),
            ), row=row, col=col)

for row in range(2, len(variable_labels) + 1):
    fig.update_xaxes(showticklabels=False, row=row)

fname = "standard_IRFs"
fig.write_html(f"{output_folder}/{fname}.html")

# Make table comparing old and new
# Create a DataFrame from the table data
table_df = pd.DataFrame(table_data, columns=['Model', 'Variable', 'Shock', 'Multiplier'])
# Pivot the DataFrame to compare shocks across models for each variable
pivot_table = table_df.pivot_table(index=['Variable', 'Shock'], columns='Model', values='Multiplier')

# Reorder the index levels to have 'Shock' before 'Variable'
pivot_table = pivot_table.reorder_levels(['Shock', 'Variable'])

# Sort the index to ensure proper ordering
pivot_table = pivot_table.sort_index()

# Optionally, format the table (e.g., rounding, filling missing values)
pivot_table = pivot_table.fillna(0)  # Replace NaN with 0 if there's no data
pivot_table = pivot_table.round(4)  # Round values to 2 decimal places

# Generate HTML table with custom styling
html_table = pivot_table.to_html(
    escape=False,  # Allow HTML tags like <br> to render in the table
    border=0,  # No borders around cells
    classes="table table-striped table-hover",  # Bootstrap classes for better styling
    justify="center",  # Center-align the table
    header=True,  # Display column headers
    index=True,  # Display index
)

# Combine CSS and HTML table
full_html = html_style + html_table

# Save the nicely formatted table as an HTML file
with open(f"{table_folder}/standard_multipliers.html", "w") as f:
    f.write(full_html)