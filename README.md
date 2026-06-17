# MAKRO 2026-June
MAKRO is an economic model built to provide a good description of the Danish economy in both the short and the long run.
In addition, the model is used to analyze how economic policy initiatives affect the economy, including the gradual transition to a long-run path.

The model is developed by the MAKRO model group at [DREAM (Danish Research Institute for Economic Analysis and Modelling)](https://dreamgruppen.dk/) for use by the Danish Ministry of Finance and others.

The model parameters, equations, and data have been selected so that the short- and long-run properties are  empirically and theoretically well-founded. Any changes to parameters, equations, or data are solely the user's responsibility, and we request that any changes be explicitly presented in any publication using MAKRO.

The model comes with batteries included in the form of a stylized baseline, so users can simulate marginal policy experiments without calibrating the model. Note that the stylized baseline is based on several simplified projection assumptions. As such, the baseline should only be used for marginal experiments rather than as a forecast in its own right. In particular, the baseline generally does not account for the effects of policy changes that have been passed but are not in effect in the last data year, such as planned tax changes or planned government expenditure. The baseline also does not account for overhang from higher-frequency data from last year or indicators within the current year.

## 2026-June version

# Major changes since May 2026 version

## Modeling
- Simplified industry aggregation in wage bargaining, labor demand, and structural employment/productivity (private sector modeled at aggregate level in `struk.gms`; branch-specific `qProd` held exogenous in `labor_market.gms`)

## Data updates
Revised Input Output Matrix: A fully specified Input Output Matrix with the public sector as a production sector is now calculated based on data from the National Accounts, rather than being imputed for the years 2014 to the last final data year, which will be 2023 in the June revision. The IO matrix for the preliminary years and the years before 2014 is imputed based on the data-covered years and on ADAM's Input Output matrices for these years. The main difference in the Input Output structure is that the private construction sector is smaller, as some of it is now included in the public sector. On the other hand, the private service sector is a bit larger, as less of this sector is included in the public sector. The public sector has relatively large inputs to production from and to itself, and the matrix of inputs to production is revised accordingly.

## Technicalities, Refactoring, and Cleanup
- Extracted fiscal sustainability indicator (HBI) calculations into dedicated module [`HBI.gms`](Model/HBI.gms)
- Renamed multiple files named "run.py" to more descriptive names such as "run_shocks.py"
- Added simple [shock template file](Analysis/Standard_shocks/shock_template.gms)
- The [standard shocks file](Analysis/Standard_shocks/standard_shocks.gms) is more robust. Previously, the solver had trouble converging on some shocks with the full 2129 time horizon.

## New, Removed, or Redefined Variables Since May 2026
**New variables**
- `fqProd[s_,t]` — Sector-specific wage/productivity scaling parameter; replaces `uProd[s_,t]`. A separate aggregate balancing equation applies to `fqProd[spTot,t]`.

- `fhL[t]` — Balancing factor ensuring hours (`hL`) match from the sector side and the age-distributed labor-supply side (including cross-border workers).
- `juhLxDK[t]` — Multiplicative adjustment to cross-border hours scale parameter `uhLxDK` (replaces `jhL2nLxDK`, which was an additive adjustment on hours per cross-border worker).
- `jfnOrlov[s_,t]` — Multiplicative adjustment for parental leave distribution across private sectors (replaces additive `jnOrlov`).

**Removed variables**
- `hL2nLxDK[t]` — Hours per cross-border worker.
- `shL2nL[s_,t]` — Structural hours per employed person.
- `shL2nLxDK[t]` — Structural hours per cross-border worker.
- `vVirkLoenPos[t]` — Auxiliary variable in wage bargaining: positive part of firms' value function in wage negotiation.
- `dvVirk2dpW[t]` — Auxiliary variable in wage bargaining: derivative of firms' value function with respect to wages.
- `svVirkLoenPos2w[t]` — Structural counterpart to `vVirkLoenPos[t]`.
- `sdvVirk2dpW[t]` — Structural counterpart to `dvVirk2dpW[t]`.
- `dqL2dnL[s_,t]` — Auxiliary variable: derivative of effective labor (`qL`) with respect to employment (`nL`); used in the user-cost FOC for labor demand.
- `dqL2dnLlag[sp,t]` — Auxiliary variable: derivative of `qL[t]` with respect to `nL[t-1]`.
- `fpL_spTot[t]` — Correction factor capturing composition effects and hiring-cost effects in the aggregate user cost of labor.
- `fDiskpL[sp,t]` — Exogenous discount factor in forward-looking labor demand (user-cost FOC).
- `uProd[s_,t]` — Parameter controlling branch-specific labor productivity (replaced by `fqProd[s_,t]`).
- `svFFOutsideOption2w[t]` — Structural counterpart to the union outside option in wage bargaining.
- `sdFF2dLoen[t]` — Structural derivative of the union value function with respect to wages.
- `sdqL2dnL[s_,t]` — Auxiliary variable: derivative of structural effective labor (`sqL`) with respect to structural employment (`snL`).
- `sdqL2dnLlag[sp,t]` — Auxiliary variable: derivative of `sqL[t]` with respect to `snL[t-1]`.
- `fsqProd[t]` — Balancing factor for structural sector productivity (`sqProd`); removed with the structural sector-aggregation simplification.
- `nSoegBase[t]` — Aggregate pool of domestic and cross-border searchers plus employed; dropped in favor of `nSoegBaseHh` and `nSoegBasexDK`.
- `rAMDisk[t]` — Exogenous discount rate in wage bargaining; the forward wage-stickiness term in `pW` now uses `fVirkDisk[spTot,t]`.

**Changed definitions**
- `mtVirk[t]` — Marginal corporate income tax rate (no longer sector-distributed; was `mtVirk[s_,t]`).
- `spL2pW[t]` — Structural user-cost-to-wage ratio; aggregated to total private sector (was `spL2pW[sp,t]`).

## Variable Name Changes Since May 2026
  ("New name",                  "Old name"),
  ("fqProd[s_,t]",              "uProd[s_,t]"),
  ("spL2pW[t]",                 "spL2pW[sp,t]"),

## Documentation
The model documentation in English is included in this repository under [Documentation/Documentation.pdf](Documentation/Documentation.pdf).

The documentation was thoroughly improved and pruned for the March-2023 release, and we highly recommend reading it!
It has been continuously updated since then, but there may be details that have yet to be updated.

Variable names and documentation in the code are in Danish; however, comments regarding the structure of the code are in English for anyone looking for a template on how to structure a large model.

## Model source code
The source code defining all the model equations can be found in the [model subdirectory](Model/).

### Modules
The model is split into several modules, each defining a group of endogenous variables and exactly as many constraints. The separation is for user convenience rather than technical reasons, as all modules are solved simultaneously.

- [aggregates](Model/aggregates.gms) - Calculates objects with ties to many other modules
- [consumers](Model/consumers.gms) - Consumption decisions and budget constraint
- [exports](Model/exports.gms) - Armington demand for exports of both domestically produced and imported goods
- [finance](Model/finance.gms) - Firm financing and valuation
- [government](Model/government.gms) - Government aggregation module
- [GovRevenues](Model/GovRevenues.gms) - Government revenues (see also taxes module)
- [GovExpenses](Model/GovExpenses.gms) - Government expenses
- [HBI](Model/HBI.gms) - Fiscal sustainability: net present values of government flows and the fiscal sustainability indicator (HBI)
- [HHincome](Model/HHincome.gms) - Household income and portfolio accounting
- [IO](Model/IO.gms) - Details of the IO system. The different demand components are satisfied with domestic production competing with imports
- [labor_market](Model/labor_market.gms) - Labor force participation, job searching and matching, and wage bargaining
- [pricing](Model/pricing.gms) - Price rigidities, markups, and foreign prices
- [production_private](Model/production_private.gms) - Private sector production and demand for factors of production
- [production_public](Model/production_public.gms) - Public sector production and demand for factors of production
- [struk](Model/struk.gms) - Structural levels, i.e. potential output (Gross Value Added) and structural employment
- [taxes](Model/taxes.gms) - Tax rates and revenues from taxes and duties closely related to the IO system 

### Variable Names - in Code and in Documentation
For variable names, we try to strike a balance between shorthand notation that makes dense equations easier to read and longer names that are explicit and self-explanatory, as is usually good practice in code. Longer names are in Danish. For shorthand notation, we defer to standard economic literature notation, e.g. Y is output, C is consumption, and so forth.
In addition to the roots of names, we use the following system of prefixes:

Prefix naming system:
- j - additive residual term
- f - factor, unspecified multiplicative parameter
- jf - multiplicative residual term (or equivalently, the combination of two prefixes, j and f = a residual added to a multiplicative factor)
- E - Expectations operator, rarely used, as lead variables are used implicitly as model-consistent expectations
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

As an example, pC[c,t] is the price index for consumption goods, specifically consumption type $c$ in year $t$. In the documentation, this appears as $p^C_{c,t}$. qC[c,t] is the equivalent real quantity of consumption in the source code. In the documentation, we omit the $q$ prefix and simply write $C_{c,t}$. The price index of aggregate consumption in the source code is pC[cTot,t]. In the documentation, we omit a subscript to refer to the aggregate, e.g. $p^C_t$.

Multi-word identifiers are written without spaces or punctuation, with each word's initial letter capitalized except for prefixes, e.g. nOrlovRest.

## GAMS and gamY
MAKRO is written in GAMS but uses a preprocessor, *gamY*, that implements additional features convenient for working with large models.

An installation of [GAMS](https://www.gams.com/) is needed to run MAKRO (GAMS 46 or higher) as well as a license for both GAMS and the included Conopt4 solver. Note that students and academics may have access to a license through their university.
The [paths.py](paths.py) file should be adjusted with the path to your local GAMS installation. We generally assume that users use Windows, but both GAMS and MAKRO should be compatible with Unix operating systems.

gamY is included in the dream-tools Python package - see notes on installation below.

## Python packages
The packages needed to run MAKRO can be installed in Python using pip.

On Windows, we recommend running the script [install.cmd](install.cmd) and using the Python installation that comes with your GAMS installation.

## Text editor
The recommended text editor for working with gamY is Cursor, used with the GAMS installation of Python to run the python runner scripts (run_*.py). You need to install the Python and Jupyter extensions to be able to run the python scripts. To activate the GAMS Python environment in Cursor, use ```ctrl+shift+p``` and select ```Python: Select interpreter```. If the GAMS Python environment is not found, enter the path manually (can be found in your GAMS installation, typically ```C:\GAMS\53\GMSPython```) and select python.exe as interpreter.

Note that in the MAKRO installation, there is a Cursor workspace, [MAKRO.code-workspace](MAKRO.code-workspace), from which it is recommended to open Cursor.
The workspace includes package recommendations, such as the "gamY-syntax-highlighting" package for syntax compatibility.

## Running shocks
The [shock template file](Analysis/Standard_shocks/shock_template.gms) provides a compact starting point for custom shocks. It loads the baseline, sets the shock year and optional tax reaction, applies the user-defined shock, solves the model, and unloads the result.

The [Analysis/Standard_shocks](Analysis/Standard_shocks) subdirectory contains files for running a large number of predefined shocks. Users can select and deselect shocks and variations, such as shock persistence and fiscal response, by editing [standard_shocks.gms](Analysis/Standard_shocks/standard_shocks.gms).

The run file, [Analysis/Standard_shocks/run_shocks.py](Analysis/Standard_shocks/run_shocks.py), is set up to run either [standard_shocks.gms](Analysis/Standard_shocks/standard_shocks.gms) or [shock_template.gms](Analysis/Standard_shocks/shock_template.gms), followed by the Python reporting files.

For reporting on responses to shocks, we include a Python script, [plot_standard_shocks.py](Analysis/Standard_shocks/plot_standard_shocks.py), for making a combined report with many plots of responses to one or more shocks, comparing shock responses from one or more model versions, and/or multiple variations of the same shock. Shocks to be plotted can be added inside [shocks_to_plot.py](shocks_to_plot.py), and [variables_to_plot.py](variables_to_plot.py) controls which variables are plotted.

[plot_shocks.py](Analysis/Standard_shocks/plot_shocks.py) is set up for making many detailed figures that illustrate the effects of a particular shock (without comparison between model versions or shock variations).

### Foreign economy
The sub-directory "Foreign_Economy" contains a "rest of world" model that can be used for e.g. monetary policy and oil (price/supply) shocks, see [Foreign_Economy](foreign_economy.gms). Inside this code is the definition of the model, and at the bottom are pre-defined shocks for the user to play with that can easily be edited. To run the shocks, run the script [run_foreign_economy.py](Foreign_Economy/run_foreign_economy.py). 

Note that the model is estimated on U.S. quarterly data, and that aggregation for input into MAKRO happens automatically by averaging to years. Inside [Analysis/Standard_shocks](Analysis/Standard_shocks), there is currently an example of how the foreign economy model maps to MAKRO for an interest rate shock. Documentation for the foreign model is also found in the foreign economy folder, [Foreign_Economy](foreign_economy.pdf).
  
