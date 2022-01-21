#  $SETGLOBAL terminal_year 2060;
$SETLOCAL shock_year 2026;
$SETLOCAL match_periods 25;
$SETLOCAL truncate_variance 5;
$SETLOCAL weight_decay 0.2;

OPTION SOLVELINK=0, NLP=CONOPT4;

# ----------------------------------------------------------------------------------------------------------------------
# Define sets
# ----------------------------------------------------------------------------------------------------------------------
SET scen_ "Scenarios for each impulse that we MIGHT want to match" /
  'GovSpending'
  'IntRate'
  'OilPrice'
  'ForeignDemand'
  'LaborSupply'
/;

SET IRF "All impulse response variable names" /
  'log(GDP)'       "GDP (qGDP)"
  'log(C)'         "Private consumption (qC)"
  'log(IM)'        "Private machine investments (qI[iM])"
  'log(IBx)'       "Firm building investments (qI[iB])"
  'log(Ibol)'      "Housing investments (qIBolig)"
  'log(EX)'        "Exports (qX)"
  'log(G)'         "Government consumption and investments"
  'MarkovUGap'     "Unemployment gap (rLedig-srLedig)"
  'MarkovLSupply'  "Unemployment (No. of people)"
  'log(PC)'        "Consumption deflator (pC)"
  'log(PY)'        "Output deflator (pY)"
  'log(W)'         "Wages (vWHh/nLHh)"
  #  'log(WP)'        "Industry wages"
  'log(PBol)'      "Housing prices (pBolig)"
  'log(PEX)'       "Export price (pX)"
  #  'Sentiment'      "Sentiment survey index"
  'RF'             "Interest rate (rRente[Obl])"
  'PF'             "Foreign prices (pUdl)"
  'YF'             "Foreign demand (qXMarked)"
  'POIL'           "Oil price (pOlie)"
/;

SETS
  tau     "Impulse period" /1*100/
  tFit[t] "Years where we match the impulse"
;
tFit[t] = yes$(%shock_year% <= t.val and t.val < %shock_year% + %match_periods%);
SINGLETON SET tFitEnd[t];
tFitEnd[t]$(t.val = %shock_year% + %match_periods% - 1) = yes;

SETS
  tShock0[t]
  tShockX0[t]
  tShockX1[t]
  tShockX0E[t]
;
tShock0[t]   = yes$(t.val=%shock_year%-1);
tShockX0[t]  = yes$(t.val>%shock_year%-1 and t.val<=%terminal_year%);
tShockX1[t]  = yes$(t.val>%shock_year% and t.val<=%terminal_year%);
tShockX0E[t] = yes$(t.val>%shock_year%-1 and t.val<%terminal_year%);

# Number of segments used to approximate the area between IRFs (integral of absolute differences)
$SETLOCAL obj_steps 5;
set obj_step /1*5/;

set aShock[a] "Age groups affected by labor supply shock" /18*50/;


# ----------------------------------------------------------------------------------------------------------------------
# Choose shocks here
# ----------------------------------------------------------------------------------------------------------------------
SET scen[scen_]  "Scenarios for each impulse that we want to match"/
  'ForeignDemand' "Foreign demand"
  'GovSpending'   "Government spending"
  'IntRate'       "Interest rate"
  'LaborSupply'   "Labor supply"
  'OilPrice'      "Oil price"
/;

# ----------------------------------------------------------------------------------------------------------------------
# Choose weights here
# ----------------------------------------------------------------------------------------------------------------------
TABLE weights_table[IRF,scen_] "Weight in loss function of each IRF by shock scenario"
                  'ForeignDemand' 'GovSpending' 'IntRate' 'LaborSupply' 'OilPrice'
  'log(GDP)'                    1             1         1             0          1
  'log(C)'                      0             1         1             0          1
  'log(IM)'                     1             1         1             0          1
  'log(IBx)'                    1             1         1             0          1
  'log(Ibol)'                   1             1         1             0          1
  'log(EX)'                     1             0         1             0          1
  'log(G)'                      0             0         0             0          0
  'MarkovUGap'                  1             1         1             0          1
  'MarkovLSupply'               0             0         0             1          0
  'log(PC)'                     1             0         0             0          0
  'log(PY)'                     1             1         1             0          1
  'log(W)'                      1             1         1             0          1
  #  'log(WP)'                     0             0         0             0          0
  'log(PBol)'                   1             1         1             0          1
  'log(PEX)'                    1             0         1             0          1
  #  'Sentiment'                   0             0         0             0          0
  'RF'                          0             0         0             0          0
  'PF'                          0             0         0             0          0
  'YF'                          0             0         0             0          0
  'POIL'                        0             0         0             0          0
;

# ----------------------------------------------------------------------------------------------------------------------
# Read empirical impulses and IRFs 
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_IRF
  median[IRF,t,scen]   "Median of empirical impulse"
  variance[IRF,t,scen] "Variance of empirical impulse"
  upper[IRF,t,scen]    "Upper bound of confidence band of empirical impulse"
  lower[IRF,t,scen]    "Lower bound of confidence of empirical impulse"

  weights[IRF,scen,t] "Weight in loss function of each IRF by shock scenario and time"
;

weights.l[IRF,scen,t]$(tFit[t]) = weights_table[IRF,scen] * (1-%weight_decay%)**(t.val - %shock_year%);

$PGROUP pG_IRF_load
  median_load[IRF,tau,scen]
  variance_load[IRF,tau,scen]
  upper_load[IRF,tau,scen]
  lower_load[IRF,tau,scen]
;

execute_load "%IRF_path%"
  median_load=median
  variance_load=variance
  upper_load=upper
  lower_load=lower
;
variance_load[IRF,tau,scen]$(tau.val > %truncate_variance%) = variance_load[IRF,'%truncate_variance%',scen];

median.l[IRF,t,scen]$(median_load[IRF,'1',scen] <> 0)   = sum(tau$(t.val = %shock_year% + tau.val - 1), median_load[IRF,tau,scen])/100;
variance.l[IRF,t,scen]$(variance_load[IRF,'1',scen] <> 0) = sum(tau$(t.val = %shock_year% + tau.val - 1), variance_load[IRF,tau,scen])/100;
upper.l[IRF,t,scen]$(upper_load[IRF,'1',scen] <> 0)    = sum(tau$(t.val = %shock_year% + tau.val - 1), upper_load[IRF,tau,scen])/100;
lower.l[IRF,t,scen]$(lower_load[IRF,'1',scen] <> 0)    = sum(tau$(t.val = %shock_year% + tau.val - 1), lower_load[IRF,tau,scen])/100;

median.l[IRF,t,'OilPrice']$(median_load[IRF,'1','OilPrice'] <> 0)   = sum(tau$(t.val = %shock_year% + tau.val - 1), median_load[IRF,tau,'OilPrice'])/10;
variance.l[IRF,t,'OilPrice']$(variance_load[IRF,'1','OilPrice'] <> 0) = sum(tau$(t.val = %shock_year% + tau.val - 1), variance_load[IRF,tau,'OilPrice'])/10;
upper.l[IRF,t,'OilPrice']$(upper_load[IRF,'1','OilPrice'] <> 0)    = sum(tau$(t.val = %shock_year% + tau.val - 1), upper_load[IRF,tau,'OilPrice'])/10;
lower.l[IRF,t,'OilPrice']$(lower_load[IRF,'1','OilPrice'] <> 0)    = sum(tau$(t.val = %shock_year% + tau.val - 1), lower_load[IRF,tau,'OilPrice'])/10;

# Number of segments used to approximate the area between IRFs (integral of absolute differences)
$SETLOCAL obj_steps 5;
set obj_step /1*5/;

# LaborSupply shock defineres
set aShock[a] /18*50/;
parameter nPop_shock[a,t];
nPop_shock[a,t] = 1 + (0.1/sum(aShock, 1) / nPop.l[a,t])$(t.val >= %shock_year% and aShock[a]); # 100 personer fordelt uniformt på aShock aldersgrupperne

# ----------------------------------------------------------------------------------------------------------------------
# Parameters to be matched
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_matching_parameters
  uKInstOmk[k,sp]$(not sameas[sp, 'bol']) "Sector specific parameter for installation costs of capital."
  uKInstOmk_iB                            "Parameter for installation costs of capital across sectors."
  uKInstOmk_iM                            "Parameter for installation costs of capital across sectors."
  #  eKUdn[k]                                "Eksponent som styrer anvendelsen af kapacitetsudnyttelse."
  eLUdn                                   "Eksponent som styrer anvendelsen af kapacitetsudnyttelse."

  upYTraeghed[sp]$(upYTraeghed.l[sp] <> 0) "Calvo parameter: Probability that a firm can't change prices in a given period"
  upYTraeghed_match                        "Parameter for prices rigidity across sectors."

  rLoenTraeghed    "Parameter determining the rigidity in the Calvo wage"
  rLoenIndeksering "Parameter for graden af løn indeksering"
  eMatching        "Eksponent i matching-funktion"
  rfZhTraeghed     "Træghed i indkomsteffekter på intensiv margin."
  uMatchOmkSqr    "Kvadratisk omkostning ved jobopslag"
  uOpslagOmk       "Lineær omkostning pr. jobopslag"

  rRef            "Degree of consumption externality"
  rRefBolig    "Grad af reference forbrug for boliger"
  fBoligGevinst   "Faktor som boliggevinster skaleres med"
  rHtM            "Fraction of hand-to-mouth consumers"
  uBoligHtM_match "uBoligHtM_t værdi"
  uIBoligInstOmk  "Parameter for installationsomkostninger for boligkapital i nybyggeri"

  rpMTraeghed   "Træghed i relative priser mellem import og egenproduktion"
  upXyTraeghed "Træghed i pris-effekt på eksportefterspørgsel"
  rXTraeghed   "Rigidity of export demand"

  rRealKredTraeg "Træghed i pBoligRigid"

  rOffLTraeghed "Træghed i offentlig beskæftigelse."

  Baseline            "Dummy parameter used to in grid testing"
;

# ----------------------------------------------------------------------------------------------------------------------
## Endogenous variables shared accross scenarios
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_matching
  loss[IRF,scen]                      "Loss function contribution by IRF and shock"
  loss_total                          "Loss function to be minimized"
  MAKRO[IRF,t,scen]                        "MAKRO impulse responses"
  uKInstOmk[k,sp]$(not sameas[sp, 'bol'])  "Sector specific parameter for installation costs of capital."
  upYTraeghed[sp]$(upYTraeghed.l[sp] <> 0) "Calvo parameter: Probability that a firm can't change prices in a given period"
;
uKInstOmk_iM.l = uKInstOmk.l['iM','tje'];
uKInstOmk_iB.l = uKInstOmk.l['iB','tje'];
upYTraeghed_match.l = upYTraeghed.l['tje'];

# ----------------------------------------------------------------------------------------------------------------------
# Loss function definition
# ----------------------------------------------------------------------------------------------------------------------
$BLOCK B_loss_function
  E_loss[IRF,scen].. loss[IRF,scen] =E= 
    sum([obj_step,t]$(t.val > %shock_year% and weights.l[IRF,scen,t] > 0 and variance.l[IRF,t,scen] > 0), 
        (  (1 - obj_step.val/%obj_steps%)  * weights[IRF,scen,t] / sqrt(variance[IRF,t,scen])
         + (obj_step.val/%obj_steps%) * weights[IRF,scen,t-1] / sqrt(variance[IRF,t-1,scen])
        ) * sqrt(sqr(
            (1 - obj_step.val/%obj_steps%)  * (MAKRO[IRF,t,scen]   - median[IRF,t,scen])
          + (obj_step.val/%obj_steps%) * (MAKRO[IRF,t-1,scen] - median[IRF,t-1,scen])
        ) + 0.000001)
    );

  E_loss_total.. loss_total =E= sum([IRF,scen], loss[IRF,scen]);
$ENDBLOCK
