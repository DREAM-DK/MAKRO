# MAKRO 2025-May
MAKRO is an economic model built to provide a good description of the Danish economy in both the short and the long run.
In addition, the model is used to analyze how economic policy initiatives affect the economy, including the gradual transition to a long-run path.

The model is developed by the MAKRO model group at [DREAM (Danish Research Institute for Economic Analysis and Modelling )](https://dreamgruppen.dk/) for use by the Danish Ministry of Finance and others.

The model parameters, equations, and data as a whole have been selected such that the short and long-run properties are as empirically and theoretically well-founded as possible. Any changes to parameters, equations, or data are solely the user's responsibility, and we request that any changes be explicitly presented in any publication using MAKRO.

## 2025-May version
This is the second publicly available non-beta release of MAKRO.

It comes with batteries in the form of a stylized baseline starting in 2029, so users can simulate marginal policy experiments without requiring a data subscription or calibrating the model. Note that the stylized baseline is based on several simplified projection assumptions. As such, the baseline should only be used for marginal experiments rather than as a forecast on its own.

## Documentation
The model documentation in English is included in this repository under [Documentation/Documentation.pdf](Documentation/Documentation.pdf).

The documentation was thoroughly improved and pruned for the March-2023 release, and we highly recommend reading it!
It has been continously updated since then, but there may be details that have yet to be updated.

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
The packages needed to run MAKRO can be installed in python using pip and the command
```
pip install gamsapi[transfer]==46.5.0 dream-tools==2.5.0 numpy pandas scipy statsmodels
```

We recommend using the python installation that comes with your GAMS installation.
For reporting, and other purposes, we make use of several python packages in addition to the ones listed above.
To install pip and all the packages that we use, simply run the code in install.py

## Text editor
The recommended text editor for working with gamY is [Visual Studio Code](https://code.visualstudio.com/) (VSCode), used with the GAMS installation of Python to run run.py files. You need to install the Python and Jupyter extensions to be able to run the run.py files. To activate the GAMS Python environment in VSCode, use ```ctrl+shift+p``` and select ```Python: Select interpreter```. If the GAMS Python environment is not found, enter the path manually (can be found in your GAMS installation, typically ```C:\GAMS\49\GMSPython```) and select python.exe as interpreter.

In addition, we use the "gamY-syntax-highlighting" package for syntax compatability and the "Ayu" package for color theme. Note that in the MAKRO installation, there is a VSCode workspace, [MAKRO.code-workspace](MAKRO.code-workspace), from which it is recommended to open VSCode. 

## Running shocks
The [Analysis/Standard_shocks](Analysis/Standard_shocks) subdirectory contains files for running a large number of pre-defined shocks, and it is straightforward to disable existing shocks and add new custom shocks instead. This is done by editing [standard_shocks.gms](Analysis/Standard_shocks/standard_shocks.gms). The run file, [Analysis/Standard_shocks/run.py](Analysis/Standard_shocks/run.py), is set up to run this file, followed by two python reporting files.

For reporting on responses to shocks, we include a python script, [plot_standard_shocks.py](Analysis/Standard_shocks/plot_standard_shocks.py), for making a combined report with many plots of responses to one or more shocks, comparing shock responses from one or more model versions, and/or multiple variations of the same shock. Shocks to be plotted can be added inside [shocks_to_plot.py](shocks_to_plot.py) and [variables_to_plot.py](variables_to_plot.py) controls which variables are plotted.

[plot_shocks.py](Analysis/Standard_shocks/plot_shocks.py) is set up for making many detailed figures that illustrate the effects of a particular shock (without comparison between model versions or shock variations).

### Foreign economy
In the sub-directory "Foreign_Economy" is a "rest of world" model that can be used for e.g. monetary policy and oil (price/supply) shocks, see [Foreign_Economy](foreign_economy.gms). Inside this code is the definition of the model, and at the bottom are pre-defined shocks for the user to play with that can easily be edited. To run the shocks, one runs the run.py file in the "Foreign_Economy" folder. 

Note that the model is estimated on U.S. quarterly data, and that aggregation for input into MAKRO happens automatically (by averaging to years). Inside [Analysis/Standard_shocks](Analysis/Standard_shocks) there is currently an example of how the foreign economy model maps to MAKRO for an interest rate shock. Documentation for the foreign model is also found in the foreign economy folder, [Foreign_Economy](foreign_economy.pdf).
  