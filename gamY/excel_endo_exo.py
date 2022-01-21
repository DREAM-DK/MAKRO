"""
Transform Excel work sheet into GAMS code to perform endo exo operations and change variable levels.
"""
import os
import sys
import pandas as pd
import xlwings as xw


def main():
    #  Read execution paremeters
    workbook_path = os.path.abspath(sys.argv[1])
    assert os.path.splitext(workbook_path)[1].lower() in [".xls", ".xlsx", ".xlsm"], \
        f"{workbook_path} is not an Excel workbook"

    output_path = os.path.abspath(sys.argv[2])

    # Read Excel file
    print(f"Read endo_exo sheet from {workbook_path}")
    app = xw.App(visible=False)
    workbook = xw.Book(workbook_path)
    endo_exo = workbook.sheets["endo_exo"].range("B4:CK5000").options(pd.DataFrame, index=False).value
    app.quit()

    # Cast years in column header to ints
    header = list(endo_exo)
    year_columns_index = 4
    header[year_columns_index:] = [int(i) for i in header[year_columns_index:]]
    endo_exo.columns = header

    endo_exo_strings = endo_exo.apply(row_to_gekko, axis=1, result_type="reduce", year_columns_index=year_columns_index)

    with open(output_path, "w") as file:
        print(f"Write to {output_path}")
        file.write("\n".join(endo_exo_strings))


def row_to_gekko(row, year_columns_index):
    """Return Gekko code from row"""
    endo_exo_strings = []
    for interval in split_intervals(row[year_columns_index:]):
        if row['#']:  # Transfer comments
            endo_exo_strings += [f"// {i}" for i in row.dropna()]
        elif interval:
            interval_string = f"{interval[0]} {interval[-1]}"
            if row.endo:
                endo_exo_strings += [f"ENDO <{interval_string}> {row.endo};"]
            if row.exo:
                endo_exo_strings += [f"EXO <{interval_string}> {row.exo};"]
                values = "(" + ", ".join(row.loc[interval].astype(str)) + ")"
                if row.printcode == "dummy":
                    pass
                elif row.printcode:
                    endo_exo_strings += [f"<{interval_string} {row.printcode}> {row.exo} = {values};"]
                else:
                    endo_exo_strings += [f"<{interval_string}> {row.exo} = {values};"]

    return "\n".join(endo_exo_strings)


def split_name(input):
    """
    Split Gekko syntax name
    Return symbol name and a list of elements
    Example:
        >>> split_name("qI[#i,CON]")
        "qI", ["#i", "'CON'"]
    """
    if "[" in input:
        name, elements = input.split("[", 1)
        elements = elements[:-1].split(",")
        elements = [e[1:] if (e[0] == "#") else f"'{e}'" for e in elements]
    else:
        name = input
        elements = []
    return name, elements


def split_intervals(series):
    interval = []
    for year in series.dropna().index:
        if (year - 1) not in interval:
            if interval:
                yield interval
                interval = []
        interval += [year]
    yield interval


def error(msg):
    exit(f"ERROR! {msg}")


if __name__ == "__main__":
    main()
