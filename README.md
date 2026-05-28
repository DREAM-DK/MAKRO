# MAKRO 2026-May
MAKRO is an economic model built to provide a good description of the Danish economy in both the short and the long run.
In addition, the model is used to analyze how economic policy initiatives affect the economy, including the gradual transition to a long-run path.

The model is developed by the MAKRO model group at [DREAM (Danish Research Institute for Economic Analysis and Modelling )](https://dreamgruppen.dk/) for use by the Danish Ministry of Finance and others.

The model parameters, equations, and data as a whole have been selected such that the short and long-run properties are as empirically and theoretically well-founded as possible. Any changes to parameters, equations, or data are solely the user's responsibility, and we request that any changes be explicitly presented in any publication using MAKRO.

## 2026-May version
The model comes with batteries included in the form of a stylized baseline, so users can simulate marginal policy experiments without requiring a data subscription or calibrating the model. Note that the stylized baseline is based on several simplified projection assumptions. As such, the baseline should only be used for marginal experiments rather than as a forecast on its own.

Model projection ends in 2100. The exact end-year of the projection affects HBI, but other variables are almost unchanged prior to 2060 for all standard shocks.
## Sets changes since December 2025:
'ATP' is now a part of pens and pens_ - i.e. pens = kap, liv, ATP, pensX. So pensX is now excl. ATP.

## Redefinition of variables since December 2025:
The set element pensX is redefined, so all variables containing this element have been redefined for this element.

## Variable name changes since December 2025:
  ("New name",                  "Old name"),
  
  ("vAktieOevrig",              "vAktieFin"),
  ("vAktieOevrigRenter",        "vAktieFinRenter"),
  ("vAktieOevrigOmv",           "vAktieFinOmv"),
  ("rAktieOevrigAfk",           "rAktieFinAfk"),
  ("vVirkOevrigPas",            "vVirkPasFin"),
  ("vVirkOevrigPasRenter",      "vVirkPasFinRenter"),
  ("vVirkOevrigPasOmv",         "vVirkPasFinOmv"),
  ("rVirkOevrigPas",            "rVirkPasFin"),
  ("vVirkDriftPas",             "vVirkLaan"),
  ("mrVirkDriftPasRente",       "mrRenteVirkLaan"),
  ("vVirkOevrigUrealiseretOmv", "vVirkUrealiseretAktieOmv"),
  ("vVirkOevrigRealiseretOmv",  "vVirkRealiseretAktieOmv"),
  ("rVirkOevrigRealiseringOmv", "rVirkRealiseringOmv"),
  ("mrMarkUp",                  "rMarkUp"),
  ("smrMarkUp",                 "srMarkUp"),
  ("qKLejeBolig",               "qKLejeBolig_a"),

# Major changes since December 2025 version
## Data updates
* Updated deep calibration year from 2019 to 2022.
* Updated the model to a newer data foundation, including new age profiles from microdata, and national accounting data for 2025.
* The age profiles of household assets now include unlisted equity (unoterede aktier), which significantly changes the age profiles of household assets and imputed consumption.
* Merchanting and processing data variables added to model (but not yet modeled endogenously)
* Margin totals for demand components loaded directly rather than being overwritten by IO totals.

## Calibration and baseline forecast
* Newest calibrated year is now 2025.
* Added support for a DREAM baseline calibration where the employment gap is determined endogenously.
* Improved ARIMA and exogenous forecast handling, including configurable estimation/sample periods, FM-specific forecast settings, better treatment of non-monotone series, and more robust forecasts for foreign prices, export markets, and selected IO variables.
* Removed calibration of the age-distributed splurge parameter. The model's endogenous consumption age profile matches register data about as well as the previous ad-hoc smoothing.
* rSplurge is now used to match consumption in the preliminary data calibration instead of large changes in the discount rate.
* The age profile for splurge is now calibrated so that rSplurge + rSplurgeBolig is constant across age.
* fHh (direct effect of the number of children on households' consumption weight) has been removed from the model.
* jpW is gradually phased out in preliminary data calibration.
* rVirkDisk is set to 16% based on results for Danish firms from Gormsen and Huber.

## Modeling
* ATP added as a separate pension group.
* Revised markup and price concepts: renamed the previous markup variables (see below), introduced a new cost-of-capital based average markup concept (called rMarkup), added a static/average capital price concept (pK_gns), and adjusted treatment of negative or volatile markups in forecasts.
* Splurge-income (vSplurgeInd) now has interests and revaluations on debt deducted.
* Revaluations on households' bank debt and deposits contain large reconciliation items ("other volume changes") and are therefore not included in marginal behavior.
* VAT, duties and subsidies on investments now also split by the industry making the investment (not only investment type and supplying industry). Calibration based on ADAM data.
* Other minor changes to tax modeling, including income tax brackets, capital income, marginal corporate tax, and property-related tax variables.
* More robust handling of inventory investment prices changes in aggregate price indices.
* Fixed how the risk premium enters user cost on housing.
* Reduced ad-hoc discount rate in inertia in export and import.

## Technicalities, refactoring and cleanup
* Removed unused household `h` index.
* Modules use new gamY syntax with direct mapping of equations to endogenous variables, replacing old group and block syntax.
* Small IO cells removed from the model — deviations captured in residuals in the data year. IO dummies now projected identically in deep calibration and preliminary data calibration.
* `fpOffIndirInv` replaced by `jfpOffIndirInv` (projected as 0) due to negative prices in 2022–2023.
* Import substitution elasticity `eIO` set to 0 when either domestic or imported input is more than 100 times the other.

## Documentation
The model documentation in English is included in this repository under [Documentation/Documentation.pdf](Documentation/Documentation.pdf).

The documentation was thoroughly improved and pruned for the March-2023 release, and we highly recommend reading it!
It has been continuously updated since then, but there may be details that have yet to be updated.

Variable names and documentation in the code are in Danish; however, comments regarding the structure of the code are in English for anyone looking for a template on how to structure a large model.

## Model source code
The source code defining all the model equations can be found in the [model subdirectory](Model/).

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
- [production_private](Model/production_private.gms) - Private sector production and demand for factors of production
- [production_public](Model/production_public.gms) - Public sector production and demand for factors of production
- [struk](Model/struk.gms) - Structural levels, i.e. potential output (Gross Value Added) and structural employment
- [taxes](Model/taxes.gms) - Tax rates and revenues from taxes and duties closely related to the IO system 

### Variable names - in code and in documentation
For naming variables, we try to strike a balance between short-hand notation that makes dense equations easier to read, and longer names that are explicit and self-explaining (as is usually good practice in code). Longer names are in Danish. For short hand notation, we defer to standard economic literature notation, e.g. Y is output, C is consumption, and so forth.
In addition, to the roots of names, we use the following system of prefixes:

Prefix naming system:
- j - additive residual term
- f - factor, unspecified multiplicative parameter.
- jf - multiplicative residual term (or equivalently, the combination of two prefixes, j and f = a residual added to a muliplicative factor)
- E - Expectations operator, rarely used, as leaded variables are used implicitly as model consistent expectations
- d - derivative, e.g. dY2dX = ∂Y/∂X
- s - structural version of variable
- m - marginal - used when marginal and average rates differ, e.g. mt = marginal tax rate
- u - scale parameters (μ in documentation) 
- t - tax rate
- r - unspecified rate or ratio
- e - exponent, typically an elasticity
- p - (price) adjusted by steady state rate of inflation
- q - (quantity) adjusted by steady state rate of productivity growth 
- v - (value = p*q) adjusted by product of steady state rate of inflation and productivity growth
- nv - present value (adjusted by product of steady state rate of inflation and productivity growth)
- n - number of persons
- h - hours

As an example pC[c,t] is the price index for consumption goods, specifically consumption type $c$ in year $t$. In the documentation, this appears as $p^C_{c,t}$. qC[c,t] is the equivalent real quantity of consumption in the source code. In the documentation we omit the $q$ prefix and simply write $C_{c,t}$. The price index of aggregate consumption in the source code is pC[cTot,t]. In the documentation, we simply omit a subscript to refer to the aggregate, e.g. $p^C_t$.

Multi-word identifiers are written without spaces or punctuation, with each word's initial letter capitalized except for prefixes. E.g. nOrlovRest.

## GAMS and gamY
MAKRO is written in GAMS but uses a pre-processor, *gamY*, that implements additional features convenient for working with large models.

An installation of [GAMS](https://www.gams.com/) is needed to run MAKRO (GAMS 46 or higher) as well as a license for both GAMS and the included Conopt4 solver. Note that students and academics may have access to a license through their university.
The [paths.py](paths.py) file should be adjusted with the path to your local GAMS installation. We generally assume that users use Windows, but both GAMS and MAKRO should be compatible with unix operating systems.

gamY is included in the dream-tools python package - see notes on installation below.

## Python packages
The packages needed to run MAKRO can be installed in python using pip.

On Windows, we recommend running the script [install.cmd](install.cmd) and using the python installation that comes with your GAMS installation.

## Text editor
The recommended text editor for working with gamY is Cursor, used with the GAMS installation of Python to run run.py files. You need to install the Python and Jupyter extensions to be able to run the run.py files. To activate the GAMS Python environment in VSCode, use ```ctrl+shift+p``` and select ```Python: Select interpreter```. If the GAMS Python environment is not found, enter the path manually (can be found in your GAMS installation, typically ```C:\GAMS\51\GMSPython```) and select python.exe as interpreter.

Note that in the MAKRO installation, there is a Cursor workspace, [MAKRO.code-workspace](MAKRO.code-workspace), from which it is recommended to open Cursor.
The workspace includes package recommendations, such as "gamY-syntax-highlighting" package for syntax compatibility.

## Running shocks
The [Analysis/Standard_shocks](Analysis/Standard_shocks) subdirectory contains files for running a large number of pre-defined shocks, and it is straightforward to disable existing shocks and add new custom shocks instead. This is done by editing [standard_shocks.gms](Analysis/Standard_shocks/standard_shocks.gms). The run file, [Analysis/Standard_shocks/run.py](Analysis/Standard_shocks/run.py), is set up to run this file, followed by two python reporting files.

For reporting on responses to shocks, we include a python script, [plot_standard_shocks.py](Analysis/Standard_shocks/plot_standard_shocks.py), for making a combined report with many plots of responses to one or more shocks, comparing shock responses from one or more model versions, and/or multiple variations of the same shock. Shocks to be plotted can be added inside [shocks_to_plot.py](shocks_to_plot.py) and [variables_to_plot.py](variables_to_plot.py) controls which variables are plotted.

[plot_shocks.py](Analysis/Standard_shocks/plot_shocks.py) is set up for making many detailed figures that illustrate the effects of a particular shock (without comparison between model versions or shock variations).

### Foreign economy
In the sub-directory "Foreign_Economy" is a "rest of world" model that can be used for e.g. monetary policy and oil (price/supply) shocks, see [Foreign_Economy](foreign_economy.gms). Inside this code is the definition of the model, and at the bottom are pre-defined shocks for the user to play with that can easily be edited. To run the shocks, one runs the run.py file in the "Foreign_Economy" folder. 

Note that the model is estimated on U.S. quarterly data, and that aggregation for input into MAKRO happens automatically (by averaging to years). Inside [Analysis/Standard_shocks](Analysis/Standard_shocks) there is currently an example of how the foreign economy model maps to MAKRO for an interest rate shock. Documentation for the foreign model is also found in the foreign economy folder, [Foreign_Economy](foreign_economy.pdf).
  
