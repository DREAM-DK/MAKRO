# ======================================================================================================================
# Unload information needed for ARIMA forecasts
# ======================================================================================================================
# Generate default settings by looping through arima forecast variables
$SETGLOBAL default_horizon 5;
$SETGLOBAL horizon_long 35;
$SETGLOBAL horizon_very_long 50;

scalars ARIMA_start, ARIMA_end, ARIMA_estimation_end, terminal_year;
ARIMA_start = 1999;
ARIMA_end = %cal_deep%;
ARIMA_estimation_end = %cal_deep%;
ARIMA_estimation_end$%FM_baseline% = 2019;
terminal_year = %terminal_year%; 

## Define settings variables for ARIMA forecasts
$LOOP G_ARIMA_forecast:
    $REPLACE('[t]', '')
    $REPLACE(',t]', ']')
      parameter {name}_horizon{sets};
      {name}_horizon{sets} = %default_horizon%;
      parameter {name}_zero_to_one{sets};
      {name}_zero_to_one{sets} = eps;
      parameter {name}_ARIMA_start{sets};
      {name}_ARIMA_start{sets} = ARIMA_start;
      parameter {name}_ARIMA_estimation_end{sets};
      {name}_ARIMA_estimation_end{sets} = ARIMA_estimation_end;
    $ENDREPLACE
    $ENDREPLACE
$ENDLOOP

# ----------------------------------------------------------------------------------------------------------------------
# Transfomations prior to fitting ARIMAs
# ----------------------------------------------------------------------------------------------------------------------
set_time_periods(%cal_deep%-1, %terminal_year%);
rE2KE.l[sp,t]$(eKE.l[sp] > 0 and rE2KE.l[sp,t] > 0) = (rE2KE.l[sp,t]/rE2KE.l[sp,t1])**(1/eKE.l[sp]) * rE2KE.l[sp,t1];
rL2KEL.l[sp,t]$(eKEL.l[sp] > 0 and rL2KEL.l[sp,t] > 0) = (rL2KEL.l[sp,t]/rL2KEL.l[sp,t1])**(1/eKEL.l[sp]) * rL2KEL.l[sp,t1];
rB2KELB.l[sp,t]$(eKELB.l[sp] > 0 and rB2KELB.l[sp,t] > 0) = (rB2KELB.l[sp,t]/rB2KELB.l[sp,t1])**(1/eKELB.l[sp]) * rB2KELB.l[sp,t1];
rR2KELBR.l[sp,t]$(eKELBR.l[sp] > 0 and rR2KELBR.l[sp,t] > 0) = (rR2KELBR.l[sp,t]/rR2KELBR.l[sp,t1])**(1/eKELBR.l[sp]) * rR2KELBR.l[sp,t1];
uIOm0.l[dux,s,t]$(eIO.l[dux,s] > 0 and uIOm0.l[dux,s,t] > 0) = (uIOm0.l[dux,s,t]/uIOm0.l[dux,s,t1])**(1/eIO.l[dux,s]) * uIOm0.l[dux,s,t1];
uXy.l[x,t]$(eXUdl.l[x] > 0 and uXy.l[x,t] > 0) = (uXy.l[x,t]/uXy.l[x,t1])**(1/eXUdl.l[x]) * uXy.l[x,t1];
uXm.l[x,t]$(eXUdl.l[x] > 0 and uXm.l[x,t] > 0) = (uXm.l[x,t]/uXm.l[x,t1])**(1/eXUdl.l[x]) * uXm.l[x,t1];

# ----------------------------------------------------------------------------------------------------------------------
# SET DRIFT HORIZON 
# ----------------------------------------------------------------------------------------------------------------------
# Horizon = 0 = eps means no drift. 

# No drift allowed
$REPLACE(',t]', ']')
$REPLACE('[t]', '')
$LOOP G_GovExpenses_ARIMA_forecast:
    {name}_horizon{sets}$({conditions}) = eps;
$ENDLOOP
$LOOP G_GovRevenues_ARIMA_forecast:
    {name}_horizon{sets}$({conditions}) = eps;
$ENDLOOP
$LOOP G_taxes_ARIMA_forecast:
  {name}_horizon{sets}$({conditions}) = eps;
$ENDLOOP
$LOOP G_production_public_ARIMA_forecast:
  {name}_horizon{sets}$({conditions}) = eps;
$ENDLOOP
$ENDREPLACE
$ENDREPLACE

#G_exports_ARIMA_forecast
uXy_horizon[x_]$(xVar[x_]) = %horizon_long%;

#G_IO_ARIMA_forecasts
uIO0_horizon[d_,s_] = %horizon_long%; # Skalaparameter for efterspørgselskomponents vægt på diverse input før endelig skalering.
uIOXy0_horizon[x,s] = %horizon_long%; # Skalaparameter for eksportkomponents vægt på diverse indenlandske input før endelig skalering.
uIOXy0_horizon['xTje','ene'] = eps; # Stiger meget kraftigt med trend
uIOm0_horizon[dux,s] = %horizon_long%; # Importandel i efterspørgselskomponent.

#G_production_private_ARIMA_forecast
rAfskr_horizon[k,s_] = %default_horizon%; # Afskrivningsrate for kapital.
uL_horizon[s_] = %horizon_very_long%; # Arbejdskraft-besparende produktivitet.
rE2KE_horizon[sp] = %horizon_very_long%; # Energi-andel i KE-nest.
rL2KEL_horizon[sp] = %horizon_very_long%; # L-andel i KEL-nest.
rB2KELB_horizon[sp] = %horizon_very_long%; # B-andel i KELB-nest.
rR2KELBR_horizon[s] = %horizon_very_long%; # R-andel i KELBR-nest.

#G_labor_market_ARIMA_forecast
hLSelvst2hL_horizon[s_] = %horizon_long%; # Selvstændiges andel af erlagte timer.
pM_horizon[s_]$(m[s_]) = 15;

#G_consumers_ARIMA_forecast
uC_horizon[c_] = %horizon_long%; # Justeringsled til CES-skalaparameter i private forbrugs-nests.
rKLeje2Bolig_horizon[aTot] = %horizon_long%; # Endogen i stødforløb
rBilAfskr_horizon = %horizon_long%; # Afskrivningsrate for køretøjer i husholdningerne.
rHhInvestx_horizon = %horizon_long%; # Husholdningernes direkte investeringer ekskl. bolig ift. direkte og indirekte beholdning af indl. aktier - imputeret.
rLand2YBolig_horizon = %horizon_long%; # Skalaparameter i CES efterspørgsel efter land.
uYBolig_horizon = %horizon_long%; # Skalaparameter i CES efterspørgsel efter boligkapital.

#G_production_public_ARIMA_forecast
rAfskr_horizon[k,s_]$(off[s_]) = %default_horizon%; # Afskrivningsrate for kapital.

#G_GovRevenues_ARIMA_forecast
rtKirke_horizon = %horizon_long%; # Andel af skatteydere som betaler kirkeskat
rUdlUdbytteDirekte_horizon = %default_horizon%; # Udbytter af udlandets direkte investeringer, som andel af samlet udbytte til udland.


#G_finance_ARIMA_forecast
rPensionAkt_horizon[portf_] = eps;

# ----------------------------------------------------------------------------------------------------------------------
# SET VARIABLES BOUND BETWEEN ZERO AND ONE
# ----------------------------------------------------------------------------------------------------------------------
rE2KE_zero_to_one[sp] = 1;
rL2KEL_zero_to_one[sp] = 1;
rB2KELB_zero_to_one[sp] = 1;
rR2KELBR_zero_to_one[s] = 1;
uIOm0_zero_to_one[dux,s] = 1;

# ----------------------------------------------------------------------------------------------------------------------
# SET ARIMA START YEAR IF NON-DEFAULT
# ----------------------------------------------------------------------------------------------------------------------
 # rE2KE_ARIMA_start[sp] = 2000; example

# ----------------------------------------------------------------------------------------------------------------------
# SET ARIMA ESTIMATION END YEAR IF NON-DEFAULT
# ----------------------------------------------------------------------------------------------------------------------
# pM_ARIMA_estimation_end[s] = 2019;
# uIOm0_ARIMA_estimation_end[dux,s] = 2019;
# uIO0_ARIMA_estimation_end['cEne',s] = 2019;
# uIO0_ARIMA_estimation_end[d,'ene'] = 2019;

# ----------------------------------------------------------------------------------------------------------------------

set q0 "Variables restricted to non-MA processes" /
  empty_set_dummy
/;
set d0 "Variables restricted to ARMA-processes" /
  empty_set_dummy
/;

$FIX All; # Make the unloaded GDX file dense - this should be removed after fixing the R program

execute_unloaddi "Gdx/ARIMA_forecast_input"
 $LOOP G_ARIMA_forecast: ,{name}, {name}_horizon, {name}_zero_to_one, {name}_ARIMA_start, {name}_ARIMA_estimation_end $ENDLOOP
  ARIMA_start, 
  ARIMA_end, 
  terminal_year
 #  q0, d0
;
