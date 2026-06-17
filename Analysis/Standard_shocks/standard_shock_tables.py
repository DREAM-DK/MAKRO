import os
from pathlib import Path

import pandas as pd
from xhtml2pdf import pisa


TABLE_STYLES = [
    dict(
        selector="tr",
        props=[
            ("background", "#E6E6E8"),
            ("text-align", "left"),
            ("font-family", "Arial, sans-serif"),
        ],
    ),
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
    dict(selector="td", props=[("padding", "13px 15px"), ("font-size", "12px")]),
    dict(
        selector="caption",
        props=[
            ("caption-side", "Top"),
            ("font-family", "Arial, sans-serif"),
            ("font-size", "16px"),
        ],
    ),
]


def add_units(value, operator):
    value = str(round(value, 2))
    if operator == "pq":
        return f"{value} %"
    if operator == "pm":
        return f"{value} %-point"
    return value


def html_to_pdf(html_file, pdf_file):
    html = Path(html_file).read_text(encoding="utf-8")
    with open(pdf_file, "w+b") as f:
        if pisa.CreatePDF(html, dest=f).err:
            raise RuntimeError(f"Failed to convert {html_file} to PDF")


def create_table_data(variation_data, years):
    table_data = variation_data.pivot_table(
        index=["variable_label", "operator"],
        columns="t",
        values="value",
        aggfunc="sum",
    )[[int(year) for year in years]]

    table_data = table_data.reset_index()
    operators = table_data.pop("operator")

    for col in table_data.columns[1:]:
        table_data[col] = [
            add_units(value, operator)
            for value, operator in zip(table_data[col], operators)
        ]

    return table_data


def create_multiplier_tables(df, variations_info, da, t1, T):
    tables = {}
    for shock_name in df.shock_name.unique():
        shock_data = df[df.shock_name == shock_name]

        for suffix, variation_label_DA, variation_label_EN in variations_info:
            variation_label = variation_label_DA if da else variation_label_EN
            variation_data = shock_data[shock_data.variation == suffix]
            years = [t1, t1 + 1, t1 + 2]
            if suffix in ["_perm", "_ufin"]:
                years += [T]

            table_data = create_table_data(variation_data, years)
            table = (
                table_data.style
                .set_table_styles(TABLE_STYLES)
                .set_properties(
                    subset=pd.IndexSlice[:, :],
                    **{"background-color": "#E6E6E8", "color": "Black"},
                )
                .hide(axis="index")
                .set_caption(f"{shock_name} - {variation_label}")
            )

            tables[f"{shock_name} {variation_label}"] = table

    return tables


def write_multiplier_tables(df, variations_info, da, t1, T, output_folder, table_folder):
    os.makedirs(output_folder, exist_ok=True)
    os.makedirs(table_folder, exist_ok=True)

    combined_html = []
    for key, table in create_multiplier_tables(df, variations_info, da, t1, T).items():
        html = table.to_html()
        with open(f"{table_folder}/{key}.html", "w") as outfile:
            outfile.write(html)
        combined_html.append(html)

    combined_file = f"{output_folder}/TablesCombined.html"
    with open(combined_file, "w") as outfile:
        outfile.write("\n".join(combined_html))

    html_to_pdf(combined_file, f"{output_folder}/TablesCombined.pdf")
