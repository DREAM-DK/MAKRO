# Settings
OPTION
  SYSOUT=OFF
  SOLPRINT=OFF
  LIMROW=0
  LIMCOL=0
  DECIMALS=6
  PROFILE = 1
  PROFILETOL = 0.05
;

# Lav funktion til at sætte lower bounds for variable 
$FUNCTION zero_bound({group}):
  $LOOP {group}:
    {name}.lo{sets}$({conditions} and {name}.up{sets} <> {name}.lo{sets}) = 0;
  $ENDLOOP
$ENDFUNCTION

$IMPORT ../Model/functions.gms

# ======================================================================================================================
# FOREIGN ECONOMY MODEL
# ======================================================================================================================
$SETGLOBAL start_foreign 0 # start period
$SETGLOBAL end_foreign 1000 # end period
$SETGLOBAL shock_period_foreign 5 # shock period, makes enough space for the var lags
$SETGLOBAL matching 0 # 1 if running matching algorithm
# Definer sets 
Sets
  t "Comprehensive time set that includes all periods used anywhere" /%start_foreign%*%end_foreign%/ # make smarter using global
  tx0[t] "All except t0"
  tx1[t] "All except t0 and t1"
  tx2[t] "All except t0, t1 and t2"
;

singleton sets
  tEnd[t] /%end_foreign%/ # last period
  t0[t] /0/ # initial period, variables that exist only for t+1 need to be conditioned on this 
  t1[t] /1/ #  
;

$MACRO set_time_periods(start, end) \
  tx0[t]  = yes$(t.val>&start and t.val<=&end);\
  tx1[t]  = yes$(t.val>(&start+1) and t.val<=&end);\
  tx2[t]  = yes$(t.val>(&start+2) and t.val<=&end);\

# Initialize time subsets
set_time_periods(%start_foreign%, %end_foreign%);

$GROUP G_parameters  # Model parameters
  # i. household preferences
  beta        "discount factor"
  sigma       "CRRA parameter"
  varphi      "inv. Frisch elasticity"
  h           "habit persistence" 
  gamma_c     "splurge factor consumption"
  xi_b        "scaling of utility of wealth"
  gamma_he    "splurge income term that drives demand from house equity increases (assuming prices increase with house prices proportionally)"

  # ii. production
  delta       "depreciation rate"
  alpha       "capital share"
  chi1        "capacity utilization cost"
  chi2        "capacity utilization cost coefficient"
  u_target    "target utilization"
  Z[t]        "TFP level"
  phi_inv     "investment adjustment cost scaling"
  jOutput[t]  "exogenous output shock"
  jMC[t]      "exogenous marginal cost shock (cost push) - sæt f.eks. for at ramme effekt på CPI fra VAR olieprisstød"

  # iii. price rigidity
  theta       "price rigidity"
  vareps      "demand elasticity"
  kappa       "phillips curve slope"
  omega       "backward indexation of prices"
  gamma_b     "discounted backward parameter"
  gamma_f     "discounted forward parameter"
  phi_NKPC    "NKPC parameter amalgamation"

  # iv. wage rigidity
  vareps_w    "wage elasticity"
  theta_w     "wage rigidity"
  kappa_w     "wage phillips curve slope"
  psi_L       "disutility of labor supply scaling constant"
  omega_w     "backward indexation of prices"
  gammaw_b    "discounted backward parameter"
  gammaw_f    "discounted forward parameter"
  phi_WPC     "NKPC parameter amalgamation"

  # v. policy
  phi_pi      "Taylor parameter, inflation"
  phi_y       "Taylor parameter, output"
  Bg_Y        "debt-to-GDP ratio"
  rho_taylor  "Taylor rule smoothing"
  phi_t       "fiscal adjustment parameter"
  rstar[t]    "natural rate of interest"
;

$onDotL  # Allow implicit .l suffix for variable initialization

# i. household preferences
  beta = 0.99; 
  sigma = 1;
  varphi = 1;
  h = 0.94;
  gamma_c = 0.019;
  gamma_he = 1;

# ii. production
  delta = 0.025;
  alpha = 0.3;
  chi1 = 1;
  chi2 = 0.95;
  u_target = 0.98;
  Z[t] = 1;
  phi_inv = 55;
  jOutput[t] = 0;
  jMC[t] = 0;

# iii. price rigidity
  theta = 0.3;
  vareps = 6;
  omega = 0.4;
  phi_NKPC = theta + omega*(1-theta*(1-beta));
  kappa = (1-omega)*(1-theta)*(1-beta*theta)*(1-alpha)/(phi_NKPC*(1+alpha*(vareps-1)));
  gamma_f = beta*theta/phi_NKPC;
  gamma_b = omega/phi_NKPC;

# iv. wage rigidity
  vareps_w = 6;
  theta_w = 0.53;
  omega_w = 0.0;
  phi_WPC = theta_w + omega_w*(1-theta_w*(1-beta));
  kappa_w = (1-omega_w)*(1 - theta_w) * (1 - beta * theta_w) / (theta_w * (1 + varphi * vareps_w));
  gammaw_f = beta*theta_w/phi_WPC;
  gammaw_b = omega_w/phi_WPC;

# v. policy
  phi_pi = 1.5;
  phi_y = 0.0;
  Bg_Y = 0.26;
  rho_taylor = 0.4;
  phi_t = 0.1;

  
$GROUP G_Exo_ss # Exogenous variables in s.s. 
  bg[t]         "statsgæld"  
  k[t]          "kapital"
  l[t]          "arbejdstid"
  tau[t]        "skat"
  pi[t]         "inflationsrate"
  i[t]          "nominal interest rate"
  rk_tEnd_plus  "real kapitalrente i tEnd+1"
  pi_w[t]       "wage inflation"
  dYFq[t]        "deviation in foreign output from baseline"
  dPFq[t]        "deviation in foreign price from baseline"
  dRFq[t]        "deviation in foreign real rate from baseline"
;

$GROUP G_Endo_ss # Endogenous variables in s.s.
  c[t]         "samlet forbrug"
  b[t]         "opsparing"
  y_liquid[t]  "likvid indkomst"
  cxref[t]     "forbrug minus reference"
  y[t]         "produktion"
  inv[t]       "investering"
  rk[t]        "real kapitalrente"
  q[t]         "tobins q"
  MC[t]        "marginal costs"
  u[t]         "kapacitetsudnyttelse"
  tau[t]       "skat"
  rb[t]        "realrente på statsobligationer"
  w[t]         "realløn"
  d[t]         "profit"
  bg[t]        "statsgæld"
;

# ======================================================================================================================
# MODEL EQUATIONS 
# ======================================================================================================================
$BLOCK B_foreign_economy
    # Euler Equation Bonds
    E_c[t]$(tx1[t] and not tEnd[t])..
        cxref[t]**(-sigma) =E= (1 + rb[t+1]) * beta * cxref[t+1]**(-sigma)
                                + beta * xi_b * b[t]**(-sigma);

    # Terminal condition at tEnd (steady-state)
    E_c_tEnd[t]$(tEnd[t])..
        cxref[t]**(-sigma) =E= (1 + rb[t]) * beta * cxref[t]**(-sigma)
                                + beta * xi_b * b[t]**(-sigma);

    # Capital Euler Equation
    E_euler_k[t]$(tx1[t] and not tEnd[t])..
      cxref[t]**(-sigma) =E=
      beta * cxref[t+1]**(-sigma) * (1 + rk[t+1] - delta*q[t+1]);

    # Terminal condition at tEnd (steady-state)
    E_euler_k_tEnd[t]$(tEnd[t])..
      cxref[t]**(-sigma) =E=
      beta * cxref[t]**(-sigma) * (1 + rk_tEnd_plus - delta*q[t]);

    # Liquid income
    E_y_liquid[t]$(tx1[t])..
        y_liquid[t] =E= (1 + rb[t]) * b[t-1] + w[t] * l[t] - tau[t] + gamma_he*pi[t];

    # Consumption Reference
    E_cxref[t]$(tx1[t])..
        cxref[t] =E= c[t] - h * c[t-1] - gamma_c * y_liquid[t];

    # Bond market clearing
    E_bond[t]$(tx1[t])..
        b[t] =E= bg[t];

    # Production Function
    E_Y[t]$(tx1[t])..
        y[t] =E= Z[t] * u[t] * k[t]**alpha * l[t]**(1 - alpha) + jOutput[t];
    
    # Firm profits
    E_d[t]$(tx1[t]).. 
      d[t] =E= y[t] - w[t]*l[t] - rk[t]*k[t];

    # factor pricing
    E_factor_pricing[t]$(tx1[t]).. 
        w[t] =E=  rk[t]*(1 - alpha) / alpha * (k[t] / l[t]);

    # Marginal Costs
    E_marginal_cost[t]$(tx1[t])..
      MC[t] =E= (rk[t] / alpha)**alpha * (w[t] / (1 - alpha))**(1 - alpha) / (Z[t]*u[t]) + jMC[t];

    # Capital Accumulation
    E_k[t]$(tx1[t])..
        inv[t] =E= k[t] - (1 - delta) * k[t-1];

    # Capacity Utilization
    E_capacity_util[t]$(tx1[t])..
      u[t] =E= (Z[t]*k[t]**alpha * l[t]**(1 - alpha) - chi1 + chi2 * u_target) / chi2;

    # Resource Constraint
    E_res_constraint[t]$(tx1[t])..
      y[t] =E= c[t] + inv[t];

    # Fisher equation (linear)
    E_fisher[t]$(tx1[t] and not tEnd[t])..
      rb[t] =E= i[t] - pi[t+1];

    # Terminal condition at tEnd (steady-state)    
    E_fisher_tEnd[t]$(tEnd[t])..
      rb[t] =E= i[t] - pi[t];

    # wage inflation rate
    E_pi_w[t]$(tx1[t])..
      pi_w[t] =E= (w[t]/w[t-1])*(1+pi[t]) - 1;

    # Wage Phillips Curve
    E_WPC[t]$(tx1[t] and not tEnd[t])..
      pi_w[t] =E=  gammaw_f * pi_w[t+1]  + gammaw_b*pi_w[t-1] - kappa_w*(log(w[t])-log(psi_L*l[t]**varphi*c[t]**sigma));
    
    # Terminal condition at tEnd (steady-state)  
    E_WPC_tEnd[t]$(tEnd[t])..
      0 =E= log(w[t])-log(psi_L*l[t]**varphi*c[t]**sigma);

$ENDBLOCK

@set(All, _ss, .l);
$BLOCK B_ss_dependent
    # Tobins Q
    E_tobins_q[t]$(tx1[t] and not tEnd[t])..
      q[t] - 1 =E= phi_inv*(1+beta)*((inv[t] - inv_ss(t1))/
                          inv_ss(t1)) - phi_inv*((inv[t-1] - inv_ss(t1))/
                          inv_ss(t1)) - beta*phi_inv*((inv[t+1] - inv_ss(t1))/
                          inv_ss(t1));
    E_tobins_q_tEnd[t]$(tEnd[t])..
      q[t] =E= 1;
    # Fiscal policy
    E_tau[t]$(tx1[t])..
      tau[t] =E= tau_ss(t0) + phi_t*(bg[t-1] - bg_ss(t0));
    E_bg[t]$(tx1[t])..
      bg[t] =E= (1 + rb[t]) * bg[t-1] - tau[t];
    # NKPC  
    E_NKPC[t]$(tx1[t] and not tEnd[t])..
      pi[t] =E= kappa * (log(MC[t]) - log(MC_ss(t0))) + gamma_f * pi[t+1]  + gamma_b*pi[t-1];
    E_NKPC_tEnd[t]$(tEnd[t])..
      pi[t] =E= kappa * (log(MC[t]) - log(MC_ss(t0))) + gamma_f * pi[t]  + gamma_b*pi[t-1];
    # Taylor Rule with smoothing
    E_taylor[t]$(tx1[t])..
      i[t] =E= (1 - rho_taylor) * (rstar[t] + phi_pi * pi[t] + phi_y * (log(y[t]) - log(y_ss(t1)))) + rho_taylor * i[t-1];
$ENDBLOCK

$BLOCK B_foreign_economy_to_MAKRO_deviations
    # Output
    E_dYFq[t]$(tx1[t])..
      dYFq[t] =E= log(y[t])-log(y_ss[t]);
    # Prices
    E_dPFq[t]$(tx1[t])..
      dPFq[t] =E= pi[t];
    # Foreign interest rate (nominal)
    E_dRFq[t]$(tx1[t])..
      dRFq[t] =E= i[t] - i_ss[t];
$ENDBLOCK

$IMPORT VAR_model/var_model.gms

# ======================================================================================================================
# STEADY-STATE CALIBRATION EQUATIONS
# ======================================================================================================================
$BLOCK B_steady_state
    # Euler Equation Bonds steady-state
    E_c_t_ss[t]$(tEnd[t])..
        cxref[t]**(-sigma) =E=
                (1 + rb[t]) * beta * cxref[t]**(-sigma)
                + beta * xi_b * b[t]**(-sigma);
    
    # Euler capital stedy-state
    E_euler_k_ss[t]..
      1 =E= beta * (1 + rk[t] - delta*q[t]);

    # Tobins q steady-state
    E_tobins_q_ss[t]..
      q[t] =E= 1;
    
    # tau steady-state
    E_tau_ss[t]..
      tau[t] =E= rb[t]*bg[t];

    # Fisher steady-state
    E_fisher_ss[t]..
      rb[t] =E= i[t] - pi[t]; 

    # Wage Phillips Curve steady-state 
    E_WPC_ss[t]$(tEnd[t])..
       0 =E= log(w[t])-log(psi_L*l[t]**varphi*c[t]**sigma);

    # Liqiuid cash-on-hand steady-state
    E_y_liquid_ss[t]..
      y_liquid[t] =E= (1 + rb[t]) * b[t] + w[t] * l[t] - tau[t] + gamma_he*pi[t];

    # Consumption Reference steady-state
    E_cxref_ss[t]..
        cxref[t] =E= c[t] - h * c[t] - gamma_c * y_liquid[t];

    # Bond market clearing steady-state
    E_bond_ss[t]..
        b[t] =E= bg[t];
    
    # Production Function steady-state
    E_Y_ss[t]..
        y[t] =E= Z[t] * u[t] * k[t]**alpha * l[t]**(1 - alpha);
    
    # Firm profits steady-state
    E_d_ss[t].. 
      d[t] =E= y[t] - w[t]*l[t] - rk[t]*k[t];

    # factor pricing steady-state
    E_factor_pricing_ss[t].. 
        w[t] =E=  rk[t]*(1 - alpha) / alpha * (k[t] / l[t]);

    # Marginal Costs  steady-state
    E_marginal_cost_ss[t]..
      MC[t] =E= (rk[t] / alpha)**alpha * (w[t] / (1 - alpha))**(1 - alpha) / (Z[t]*u[t]);

    # Capital Accumulation steady-state
    E_k_ss[t]..
        inv[t] =E= k[t] - (1 - delta) * k[t];

    # Capacity Utilization steady-state
    E_capacity_util_ss[t]..
      u[t] =E= (Z[t]*k[t]**alpha * l[t]**(1 - alpha) - chi1 + chi2 * u_target) / chi2;

    # Resource Constraint   
    E_res_constraint_ss[t]..
      y[t] =E= c[t] + inv[t];

    # Government bond supply (calibration target)
    E_bg_ss[t]..
      bg[t] =E= Bg_Y * y[t];
$ENDBLOCK 

# ======================================================================================================================
# INITIAL VALUES STEADY-STATE GUESS
# ======================================================================================================================
$onDotL # Tillad implicitte .l suffix
  # exogenous values
  l[t]     = 1/4;    # labor supply s.s.
  i[t]     = 0.03/4; # quarterly interest rate (bonds)
  rb[t]    = i[t];   # real interest rate bonds in s.s.
  rstar[t] = i[t];   # natural rate of interest s.s.
  k[t]     = 1;      # k0 
  pi[t]    = 0;      # zero inflation s.s.
  pi_w[t]  = 0;      # zero inflation s.s.
  # initial steady-state guess
  tau[t] = 1;
  w[t] = 1;
  b[t] = 1;
  c[t] = 1;
  y_liquid[t] = 1;
  cxref[t] = 1;
  b[t] = 1;
  xi_b = 0.01;
  psi_L = 1;
  u[t] = 1;
  inv[t] = 1;
  q[t] = 1;
  rk[t] = 1;
  MC[t] = 1;
  y[t] = 1;

$offDotL

# ======================================================================================================================  
# FULL DYNAMIC MODEL SOLUTION
# ======================================================================================================================

$GROUP G_Endo_shock
  c[t]         "samlet forbrug"
  b[t]         "opsparing"
  y_liquid[t]  "likvid indkomst"
  cxref[t]     "forbrug minus reference"
  k[t]         "kapital"
  y[t]         "produktion"
  inv[t]       "investering"  # bliver givet af resource constraint
  rk[t]$(tx2[t]) "real kapitalrente"  # indtræder med t+1 i EUler for
  q[t]         "tobins q"
  MC[t]        "marginal costs"
  u[t]         "kapacitetsudnyttelse"
  tau[t]       "skat"
  bg[t]        "statsgæld"
  rb[t]        "realrente på statsobligationer"
  w[t]         "realløn"
  i[t]         "nominal interest rate"
  d[t]         "profit"
  l[t]         "arbejdstid"
  pi[t]        "inflationsrate"
  pi_w[t]      "wage inflation"
  dYFq[t]       "deviation in foreign output from baseline"
  dPFq[t]       "deviation in foreign price from baseline"
  dRFq[t]       "deviation in foreign nominal rate from baseline"
  ;

$GROUP G_Endo_shock # condition on tx1
  G_Endo_shock$(tx1[t])
;

Model M_shock /
B_foreign_economy
B_ss_dependent
B_foreign_economy_to_MAKRO_deviations
/;

Model M_taylor_rule/ # for obtaining the FFR in the oil supply shock 
B_ss_dependent
- E_tobins_q
- E_tobins_q_tEnd 
- E_tau
- E_bg
- E_NKPC
- E_NKPC_tEnd
B_foreign_economy_to_MAKRO_deviations
- E_dYFq
- E_dPFq
/;

# ======================================================================================================================
# CALIBRATE STEADY-STATE
# ======================================================================================================================

$IF %matching%:
  # Load matching parameters
  @load(All, "Gdx/new_parameter_values.gdx");
$ENDIF

$GROUP G_steady_state
  G_endo_ss 
  xi_b  # løs for xi_b så bonds euler holder
  psi_L # løs for psi_L så WPC holder i steady-state
;

Model M_ss_calibration "steady-state kalibrering" /
B_steady_state
/;

$FIX All; $UNFIX G_steady_state "";
solve M_ss_calibration using CNS;
$display All;

$onDotL # Tillad implicitte .l suffix
rk_tEnd_plus = rk['%end_foreign%']; # set rk_tEnd_plus to steady-state real interest rate
$offDotL

## output gdx file
execute_unloaddi 'Gdx/steady_state_calibration.gdx';
@set(All, _ss, .l);

# ======================================================================================================================
# FULL DYNAMIC MODEL SOLUTION
# ======================================================================================================================

# ======================================================================================================================
# ZERO SHOCK CHECK
# ======================================================================================================================
$FIX All; $UNFIX G_Endo_shock, rk_tEnd_plus;
solve M_shock using CNS;
@assert_no_difference(G_Endo_shock, 1e-5, .l, _ss, "Zero shock changed variables significantly.");

# ======================================================================================================================
# ACTUAL SHOCKS
# ======================================================================================================================
set_time_periods(%shock_period_foreign%-1, %end_foreign%);
parameter dt[t];
dt[t] = t.val - %shock_period_foreign%-1; 

$SETGLOBAL shockname jMC # set shockname

$IF "%shockname%" == "rstar":
  rstar.fx[t]$(t.val > %shock_period_foreign%) =  rstar.l[t] + 0.01*0.76**dt[t];
  $FIX All; $UNFIX G_Endo_shock, rk_tEnd_plus;
  solve M_shock using CNS;
  execute_unloaddi 'Gdx/%shockname%shock.gdx';
  $IMPORT VAR_model/shock_var_and_smooth.gms
$ENDIF

$IF "%shockname%" == "jMC": 
  jMC.fx[t]$(t.val > %shock_period_foreign%) =  0.01*0.85**dt[t]; # approximative typical persistence of oil price shock cf Känzig
  $FIX All; $UNFIX G_Endo_shock, rk_tEnd_plus;
  solve M_shock using CNS;
  execute_unloaddi 'Gdx/%shockname%shock.gdx';
  $IMPORT VAR_model/shock_var_and_smooth.gms
$ENDIF

$IF "%shockname%" == "jOutput":
  jOutput.fx[t]$(t.val > %shock_period_foreign%) =  0.01*0.5**dt[t];
  $FIX All; $UNFIX G_Endo_shock, rk_tEnd_plus;
  solve M_shock using CNS;
  execute_unloaddi 'Gdx/%shockname%shock.gdx';
  $IMPORT VAR_model/shock_var_and_smooth.gms
$ENDIF

$IF "%shockname%" == "Z":
  Z.fx[t]$(t.val > %shock_period_foreign%) =  Z.l[t] + 0.01*0.5**dt[t]; # Z = 1 in s.s.
  $FIX All; $UNFIX G_Endo_shock, rk_tEnd_plus;
  solve M_shock using CNS;
  execute_unloaddi 'Gdx/%shockname%shock.gdx';
  $IMPORT VAR_model/shock_var_and_smooth.gms
$ENDIF

$IF "%shockname%" == "oilsupply": # shocks originating in the energy sector are kept solely in the VAR system as it was designed for this
  jqOilWorld.fx[t]$(t.val > %shock_period_foreign%) =  jqOilWorld.l[t]+0.01*0.5**dt[t]/std_qOilWorld;
  $FIX All; $UNFIX G_VAR;
  solve M_VAR using CNS;
  @set(All, _shock, .l);
  $FIX All; $UNFIX G_VAR;
  solve B_VAR_STANDARDIZE using CNS;
  execute_unloaddi 'Gdx/VAR%shockname%.gdx';
  $IMPORT VAR_model/smooth_var.gms
  # get the nominal rate from the Taylor rule 
  @load(All, "Gdx/VAR%shockname%.gdx");
  y.fx[t]$(t.val > %shock_period_foreign%) =  y.l[t]*(1 + qUSInd.l[t]);
  pi.fx[t]$(t.val > %shock_period_foreign%) =  pUSCPI.l[t]; # s.s. inflation is zero
  $FIX All; $UNFIX i[t]$(tx1[t]), dRFq[t]$(tx1[t]);
  solve M_taylor_rule using CNS;
  execute_unloaddi 'Gdx/%shockname%shock.gdx';
$ENDIF
