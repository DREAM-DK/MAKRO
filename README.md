# MAKRO 2023-March
MAKRO is an economic model built to provide a good description of the Danish economy in both the short and the long run.
In addition, the model is used to analyze how economic policy initiatives affect the economy, including the gradual transition to a long-run path.

The model is developed by the MAKRO model group at [DREAM (Danish Research Institute for Economic Analysis and Modelling )](https://dreamgruppen.dk/) for use by the Danish Ministry of Finance and others.

The model parameters, equations, and data as a whole have been selected such that the short and long-run properties are as empirically and theoretically well-founded as possible. Any changes to parameters, equations, or data are solely the user's responsibility, and we request that any changes be explicitly presented in any publication using MAKRO.

## 2023-March version
This is the first publicly available non-beta release of MAKRO.

It comes with batteries in the form of a stylized baseline starting in 2029, so users can simulate marginal policy experiments without requiring a data subscription or calibrating the model.
Note that the stylized baseline is not a serious forecast of the Danish economy but is based on several simplified projection assumptions. As such, the baseline should only be used for marginal experiments rather than as a forecast on its own.

## Documentation
The model documentation in English is included in this repository under [Documentation/Documentation.pdf](Documentation/Documentation.pdf).

The documentation has been thoroughly improved and pruned for this release, and we highly recommend reading it!

Variable names and documentation in the code are in Danish; however, comments regarding the structure of the code are in English for anyone looking for a template on how to structure a large model.

## Model source code
The source code defining all the model equations can be found in the [model subdirectory](Model/).
The run.cmd shows the order in which the files are usually run.

### Modules
The model is split into several modules, each defining a group of endogenous variables and exactly as many constraints. The separation is purely for user convenience rather than technical, as, in the end, all the modules are solved simultaneously.

- [aggregates](Model/aggregates.gms) - Calculates objects with ties to many other modules
- [consumers](Model/consumers.gms) - Consumption decisions and budget constraint
- [exports](Model/exports.gms) - Armington demand for exports of both domestically produced and imported goods
- [finance](Model/finance.gms) - Firm financing and valuation
- [government](Model/government.gms) - Government aggregation module
- [GovRevenues](Model/GovRevenues.gms) - Government revenues (see also taxes module)
- [GovExpenses](Model/GovExpenses.gms) - Government expenses
- [HHincome](Model/HHincome.gms) - Household income and portfolio accounting
- [IO](Model/IO.gms) - Details of the IO system. The different demand components are satisfied with domestic production competing with imports
- [labor_market](Model/labor_market.gms) - Labor force participation, job searching and matching, and wage bargaining
- [pricing](Model/pricing.gms) - Price rigidities, markups, and foreign prices
- [production_private](Model/production_private.gms) Private sector production and demand for factors of production
- [production_public](Model/production_public.gms) Public sector production and demand for factors of production
- [struk](Model/struk.gms) - Structural levels, i.e. potential output (Gross Value Added) and structural employment
- [taxes](Model/taxes.gms) - Tax rates and revenues from taxes and duties closely related to the IO system 

## GAMS and gamY
MAKRO is written in GAMS but uses a pre-processor, *gamY*, that implements additional features convenient for working with large models.

An installation of [GAMS](https://www.gams.com/) is needed to run MAKRO (we recommend using the latest version) as well as a license for both GAMS and the included Conopt4 solver. Note that students and academics may have access to a license through their university.
The [paths.cmd](paths.cmd) file should be adjusted with the path to your local GAMS installation. We generally assume that users use Windows, but both GAMS and MAKRO should be compatible with other operating systems - python files are typically included as alternatives to .cmd files.

gamY can be run as a stand-alone executable or as a python script - both are included in the [*gamY* subdirectory](gamY/). The [documentation for gamY](gamY/gamY.pdf) is also included.

## Text editor
The recommended text editor for working with gamY is [Sublime Text 3](https://www.sublimetext.com/3), where the [gamY sublime package](https://packagecontrol.io/packages/gamY) provides syntax highlighting. In addition, Sublime can be opened using the [MAKRO.sublime-project](MAKRO.sublime-project) project file, which is set up for better search in sub-directories etc.

## Running shocks
The [Analysis/Standard_shocks](Analysis/Standard_shocks) subdirectory contains files for running a large number of pre-defined shocks, and it is straightforward to disable existing shocks and add new custom shocks instead. This is done by editing [standard_shocks.gms](Analysis/Standard_shocks/standard_shocks.gms). The run file, [Analysis/Standard_shocks/run.cmd](Analysis/Standard_shocks/run.cmd), is set up to run this file, followed by two python reporting files.

For reporting on responses to shocks, we include a python script, [plot_standard_shocks.py](Analysis/Standard_shocks/plot_standard_shocks.py), for making a combined report with many plots of responses to one or more shocks, comparing shock responses from one or more model versions, and/or multiple variations of the same shock. Shocks to be plottet can be added inside (shocks_to_plot.py)[shocks_to_plot.py] and [variables_to_plot.py](variables_to_plot.py) controls which variables are plotted.

[plot_shocks.py](Analysis/Standard_shocks/plot_shocks.py) is set up for making many detailed figures that illustrate the effects of a particular shock (without comparison between model versions or shock variations).

## Python packages
For reporting, and other purposes, we make use of several python packages that can be installed using pip:
```
pip install dream-tools plotly numpy pandas scipy==1.8.1 statsmodels xlwings kaleido==0.1.0.post1 xhtml2pdf IPython
```

We also require the GAMS API package, which cannot be installed with pip. Installation instructions are found here: https://www.gams.com/latest/docs/API_PY_GETTING_STARTED.html .

