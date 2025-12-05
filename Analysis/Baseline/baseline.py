# coding: utf-8
"""
Script to plot baseline forecasts, optionally comparing multiple model versions
"""
import os
import sys
import dreamtools as dt
import pandas as pd
from math import ceil
import variables_to_plot as vtp

def plot_baseline(
        database_dict,
        start_year=2000,
        end_year=2040,
        xlines=[],
        operator="",
        output_path=r"Output/baseline.html",
        DA=True,
):
    """
    Plot standard baseline forecasts for the given databases

    database_dict: dict
        A dictionary mapping labels to the paths of the databases to be plotted
    start_year: int
        The first year to be plotted
    end_year: int
        The last year to be plotted
    xlines: list of int
        Years at which to add vertical lines to the plots
    operator: str
        The operator to apply to the data. Set to "p" to see year on year percentage changes
    output_path: str
        The path to the output file. The file extension determines the output format (either .html or .pdf)
    DA: bool
        Whether to use Danish labels or English labels
    open_output: bool
        Whether to open the output file in the default browser after plotting
    """

    dt.time(start_year, end_year) # Set the time period to be plotted

    # If the output file already exists, delete it (to prevent accidentally viewing an old version in case of an error)
    if os.path.exists(output_path):
        os.remove(output_path)

    database_labels = list(database_dict.keys())

    databases = [dt.Gdx(path) for path in database_dict.values()]
    dt.REFERENCE_DATABASE = databases[0]

    # Create a dictionary mapping labels to databases
    database_dict = dict(zip(database_labels, databases))

    # Select which figure sets to plot
    figure_info = [
        *vtp.page_1_figures,
        *vtp.page_2_figures,
        *vtp.page_3_figures,
        *vtp.public_production_figures,
        *vtp.consumers_figures,
        *vtp.exports_figures,
        *vtp.government_Revenues,
        *vtp.government_Expenditures,
        *vtp.HHIncome_figures,
        *vtp.IO_figures,
        *vtp.LaborMarket_figures,
        *vtp.Pricing_figures,
        *vtp.Productionprivate_figures,
        *vtp.struk_figures,
        *vtp.finance_figures,
        *vtp.ekstra_figures,
        *vtp.sector_plot("tje"),
        *vtp.sector_plot("fre"),
        *vtp.sector_plot("byg"),
        *vtp.sector_plot("bol"),
    ]

    variable_labels_DK, variable_labels_EN, get_variable_functions, operators = [list(t) for t in zip(*figure_info)]

    variable_labels = vtp.append_spaces_to_make_unique(variable_labels_DK if DA else variable_labels_EN)

    # Collect all data to be plottet in a single dataframe
    dfs = {}
    for getter, variable_label in zip(get_variable_functions, variable_labels):
        # If we get an exception, try again with fewer databases
        for i in range(len(databases)):
            try:
                df = dt.DataFrame(databases[i:], operator, getter, names=database_labels[i:])
                df = df.reset_index().melt(value_vars=database_labels[i:], id_vars="t", var_name="database")
                dfs[variable_label] = df
                break
            except Exception as e:
                print(e)
            else:
                print(f"Exceptions in {variable_label}")
            
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
        for x in xlines:
            fig.add_vline(x=x, line_width=1, line_dash="dash", line_color="black")
        figures.append(fig)

    # sectoral movement figures
    # lump together smaller sectors
    smaller_sectors = ["udv", "ene", "lan", "soe", "byg"]
    figures += [
        vtp.plot_groups(database_dict=database_dict, operator="", variable="vBVT", set="s", title="GVA shares" ,denom_var = "vBVT", denom_index="tot", ref_base=dt.REFERENCE_DATABASE, lump_group = smaller_sectors),
        vtp.plot_groups(database_dict=database_dict, operator="", variable="nL", set="s", title="Employment shares", denom_var = "nL", denom_index="tot", ref_base=dt.REFERENCE_DATABASE, lump_group = smaller_sectors),
        # vtp.plot_groups(database_dict=database_dict, operator="", variable="vXy", set="x", denom_var = "vXy",title="Export shares", denom_index="xTot", ref_base=dt.REFERENCE_DATABASE),
        # vtp.plot_groups(database_dict=database_dict, operator="", variable="vC", set="c", denom_var = "vC", title = "Consumption shares", denom_index="cTot", ref_base=dt.REFERENCE_DATABASE),
    ]

    # Age plots
    figures += [
        vtp.age_profiles(database_dict, "vCx", [2019, 2030, 2060], "Consumption by age",),
        vtp.age_profiles(database_dict, "vHhx", [2019, 2030, 2060], "Wealth excluding pensions by age"),
        vtp.age_profiles(database_dict, "vBolig", [2019, 2030, 2060], "Housing by age"),
        vtp.age_profiles(database_dict, "vHhInd", [2019, 2030, 2060], "Income by age"),
    ]

    output_extension = os.path.splitext(output_path)[1]
    if output_extension == ".html":
        dt.figures_to_html(figures, output_path)
        import webbrowser
        webbrowser.get().open(output_path)
    elif output_extension == ".pdf":
        from pdf_report import figures_to_pdf
        figures_to_pdf(figures, output_path)
