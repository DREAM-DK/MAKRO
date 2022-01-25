# MAKRO (beta version)
MAKRO is an economic model built to provide a good description of the Danish economy in both the short and the long run.
In addition, the model is used to analyze how economic policy initiatives affect the economy including the gradual transition to a long run path.

The model is developed by the MAKRO model group at [DREAM (Danish Research Institute for Economic Analysis and Modelling)](https://dreamgruppen.dk/) for use by the [Danish Ministry of Finance](https://en.fm.dk/).

The model parameters, equations, and data as a whole have been selected such that the short and long run properties are as empirically and theoretically well-founded as possible. Any changes to parameters, equations, or data are solely the user's responsibility and we request that any changes are explicitly presented in any publication making use of MAKRO.

## January 2022 version
This is the first publicly available beta version of MAKRO.

It comes with batteries included in the form of a stylized baseline starting in 2025, such that users can simulate marginal policy experiments without requiring a data subscription or calibrating the model.
Note that the stylized baseline is NOT a serious forecast of the Danish economy, but rather is based on a number of simplified projection assumptions. As such, the baseline should only be used for marginal experiments rather than as a forecast on its own.

## Documentation
The model documentation in English is included in this repository under [Documentation/Documentation.pdf](Documentation/Documentation.pdf).
Variable names and documentation in the code are in Danish, however, comments regarding the structure of the code are in English for anyone looking for a template on how to structure a large model.

## GAMS and gamY
MAKRO is written in GAMS, but uses a pre-processor, *gamY*, that implements additional features that are convenient for working with large models.

An installation of [GAMS](https://www.gams.com/) is needed to run MAKRO (we recommend using the latest version) as well as a license for both GAMS and the included Conopt4 solver. Note that students and academics may have access to a license through their university.
The *paths.cmd* file should be adjusted with the path to your local GAMS installation.

gamY can be run as a stand-alone executable or as a python script - both are included in the [*gamY* subdirectory](gamY/). The [documentation for gamY](gamY/gamY.pdf) is also included.

The recommended text editor for working with gamY is [Sublime Text 3](https://www.sublimetext.com/3), where the [gamY sublime package](https://packagecontrol.io/packages/gamY) provides syntax highlighting.

## Running shocks and replicating working papers
The manuscripts for three working papers  are included in the [Analysis subdirectory](Analysis/) along with the code necessary to simulate the experiments and reproduce the figures in these papers. The working papers are
1) "Grundlæggende stødanalyser i MAKRO"
2) "Analyse af stød til pensionsindbetalinger"
3) "Marginal Propensity to Consume - The MPC of temporary and permanent income shocks by age"

The figures for the first two papers are produced using [Gekko Timeseries And Modeling Software](https://github.com/thomsen67/GekkoTimeseries) to run the provided .gcm files.

The figures for the third paper are produced using an attached [python script](Analysis/Shocks_MPC/mpc_grafer.py) using the packages *dream-tools*, *plotly*, and *kaleido* (pip install dream-tools, plotly, kaleido).

## Model source code
The source code defining all the model equations can be found in the [model subdirectory](Model/).
The run.cmd shows the order in which the files are usually run.

### Modules
The model is split into several modules, each of which define a group of endogenous variables and exactly as many constraints. The separation is purely for user convenience, rather than technical, as in the end all the modules are solved simultaneously.

- [aggregates](Model/aggregates.gms) - Calculates objects with ties to many other modules
- [consumers](Model/consumers.gms) - Consumption decisions and budget constraint
- [exports](Model/exports.gms) - Armington demand for exports of both domestically produced and imported goods
- [finance](Model/finance.gms) - Firm financing and valuation
- [government](Model/government.gms) - Government aggregation module
- [GovRevenues](Model/GovRevenues.gms) - Government revenues (see also taxes module)
- [GovExpenses](Model/GovExpenses.gms) - Government expenses
- [HHincome](Model/HHincome.gms) - Household income and portfolio accounting
- [IO](Model/IO.gms) - Details of the IO system. The different demand components are satisfied with domestic production competing with imports.
- [labor_market](Model/labor_market.gms) - Labor force participation, job searching and matching, and wage bargaining
- [post_model](Model/post_model.gms) - Module for calculating pure output variables not present in the model that only runs after the main model.
- [pricing](Model/pricing.gms) - Price rigidities, markups, and foreign prices
- [production_private](Model/production_private.gms) Private sector production and demand for factors of production
- [production_public](Model/production_public.gms) Public sector production and demand for factors of production
- [struk](Model/struk.gms) - Structural levels, i.e. potential output (Gross Value Added) and structural employment
- [taxes](Model/taxes.gms) - Tax rates and revenues from taxes and duties closely related to the IO system 
