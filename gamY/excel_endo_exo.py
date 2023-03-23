"""
Transform Excel work sheet into GAMS code to perform endo exo operations and change variable levels.
"""
import os
import sys
import numpy as np
import pandas as pd
import xlwings as xw
import re

# workbook_path = "C://Users//B031441//Desktop//Konjunktur//Konjunktur//konjunktur.xlsm"
# output_path = "C://Users//B031441//Desktop//Konjunktur//Konjunktur//endo_exo.gms"

def main():
    #  Read execution paremeters
    workbook_path = os.path.abspath(sys.argv[1])
    output_path = os.path.abspath(sys.argv[2])
    convert_workbook(workbook_path, output_path)


def convert_workbook(workbook_path, output_path):
    assert os.path.splitext(workbook_path)[1].lower() in [".xls", ".xlsx", ".xlsm"], \
        f"{workbook_path} is not an Excel workbook"

    # Read Excel file
    print(f"Getting endo exo operations from \"{workbook_path}\"")
    code = ""
    with xw.App(visible=False) as app:
        book = xw.Book(workbook_path)
        endo_exo_range = book.sheets["settings"].range("endo_exo_range").value
        start_year = book.sheets["settings"].range("start_year").value
        for sheet_name in book.sheets["settings"].range("endo_exo_sheets").value:
            if sheet_name is not None:
                print(sheet_name)
                code += convert_sheet(book.sheets[sheet_name], endo_exo_range, start_year)

    with open(output_path, "w") as file:
        print(f"Write endo exo code to {output_path}")
        file.write(code)


def convert_sheet(sheet, endo_exo_range, start_year):
    df = sheet.range(endo_exo_range).options(pd.DataFrame, index=False).value

    # Remove trailing empty rows
    df = df.loc[:df.last_valid_index()]

    # Convert comment column to bool.
    # Row is also counted as column if it contains only 1 non-empty cell
    df["#"] = (df.notna().sum(axis=1) <= 1) | (df["#"].notna())

    # Remove empty columns
    df.dropna(how="all", axis=1, inplace=True)

    header = list(df)

    # First column with values to be used
    year_columns_index = header.index(start_year)

    # Cast years in column header to ints
    header[year_columns_index:] = [int(i) for i in header[year_columns_index:]]
    df.columns = header

    endo_exo_strings = df.apply(
        row_to_gams,
        axis=1,
        result_type="reduce",
        year_columns_index=year_columns_index
    )

    return "\n".join(endo_exo_strings)

def replace_t(text, year):
    """Replace t⨦n] with '{year⨦n}']"""
    def eval_t(m):
        if m[1] is not None:
            return f"'{year + eval(m[1])}']"
        else:
            return f"'{year}']"
    return re.sub(r"t([+-][0-9]+)?\]", eval_t, text)

def row_to_gams(row, year_columns_index):
    """Return GAMS code from row"""
    if row['#']:  # Transfer comments
        return f"# {' | '.join(x for x in row if isinstance(x, str))}"

    code = []
    for year in row.index[year_columns_index:]:
        val = row.loc[year]
        if pd.isnull(val):
            continue

        line = ""
        if row.endo:
            lower = row.endo.replace("[", ".lo[")
            line += replace_t(lower, year) + " = -inf; "
            upper = row.endo.replace("[", ".up[")
            line += replace_t(upper, year) + " = inf; "

        if row.exo:
            assert row.printcode in ["dummy", "p", "n", "m"], f"{row.printcode} is not an implemented print code in row: {row}"
            if row.printcode == "dummy":
                lhs = replace_t(row.exo.replace("[", ".fx["), year)
                rhs = replace_t(row.exo.replace("[", ".l[")), year
                line += f"{lhs} = {rhs};"
            elif row.printcode == "p":
                lhs = replace_t(row.exo.replace("[", ".fx["), year)
                lagged = replace_t(row.exo.replace("[", ".l["), year-1)
                line += f"{lhs} = {lagged} * (1 + ({val}*0.01));"
            elif row.printcode == "m":
                lhs = replace_t(row.exo.replace("[", ".fx["), year)
                lagged = replace_t(row.exo.replace("[", ".l["), year-1)
                line += f"{lhs} = {lagged} + ({val});"
            elif row.printcode == "n":
                lhs = replace_t(row.exo.replace("[", ".fx["), year)
                line += f"{lhs} = {val};"

        code += [line]

    return "\n".join(code)

if __name__ == "__main__":
    main()
