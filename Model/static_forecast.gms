# ----------------------------------------------------------------------------------------------------------------------
# Error-handling
# ----------------------------------------------------------------------------------------------------------------------
# Ignore this section if not error-handling
# When error-handling you can solve the model till 2060 only in order to speed up process
# $SETGLOBAL terminal_year 2060 # The terminal year

# ======================================================================================================================
# Static forecast
# ======================================================================================================================
# This file controls a static forecast.

# Set latest calibration year ()
$SETLOCAL cal_forecast 2030; # Den burde kunne køre længere, men går ned efterfølgende

# Reads forecast-values from this bank
$SETLOCAL previous_baseline gdx\previous_deep_calibration;

# Load data values for calibrated years
set_time_periods(%cal_start%, %cal_end%);
$GROUP G_load All, -G_constants;
$GROUP G_load G_load$(tx0[t]);
@load(G_load, "gdx\static_calibration_all.gdx")

# Load data values for forecasted years (exogenous and starting values)
set_time_periods(%cal_end%, %cal_forecast%);
#  @load_dummies(tx0, "%previous_baseline%.gdx")
$GROUP G_load All, -G_constants, -G_do_not_load;
$GROUP G_load G_load$(tx0[t]);
@load(G_load, "%previous_baseline%.gdx")

d1IO[d_,s_,t]$(t.val > %cal_end%) = d1IO[d_,s_,t0];
d1IOy[d_,s_,t]$(t.val > %cal_end%) = d1IOy[d_,s_,t0];
d1IOm[d_,s_,t]$(t.val > %cal_end%) = d1IOm[d_,s_,t0];
d1Xm[x_,t]$(t.val > %cal_end%) = d1Xm[x_,t0];
d1Xy[x_,t]$(t.val > %cal_end%) = d1Xy[x_,t0];
d1CTurist[c,t]$(t.val > %cal_end%) = d1CTurist[c,t0];
d1X[x_,t]$(t.val > %cal_end%) = d1X[x_,t0];      
d1I_s[i_,ds_,t]$(t.val > %cal_end%) = d1I_s[i_,ds_,t0];
d1K[i_,s_,t]$(t.val > %cal_end%) = d1K[i_,s_,t0];
d1R[r_,t]$(t.val > %cal_end%) = d1R[r_,t0];      
d1C[c_,t]$(t.val > %cal_end%) = d1C[c_,t0];      
d1G[g_,t]$(t.val > %cal_end%) = d1G[g_,t0];      
d1vHhAkt[portf_,t]$(t.val > %cal_end%) = d1vHhAkt[portf_,t0];      
d1vHhPas[portf_,t]$(t.val > %cal_end%) = d1vHhPas[portf_,t0];
d1vVirkAkt[portf_,t]$(t.val > %cal_end%) = d1vVirkAkt[portf_,t0];
d1vVirkPas[portf_,t]$(t.val > %cal_end%) = d1vVirkPas[portf_,t0];
d1vOffAkt[portf_,t]$(t.val > %cal_end%) = d1vOffAkt[portf_,t0];
d1vOffPas[portf_,t]$(t.val > %cal_end%) = d1vOffPas[portf_,t0];
d1vUdlAkt[portf_,t]$(t.val > %cal_end%) = d1vUdlAkt[portf_,t0];
d1vUdlPas[portf_,t]$(t.val > %cal_end%) = d1vUdlPas[portf_,t0];

# Keep endogenous and calibrated parameters unchanged
$GROUP G_static_calibration_newdata_t
  G_static_calibration_newdata
  -uKELBR, -uKELB, -uKEL, -uKE
  ;
$LOOP G_static_calibration_newdata_t:
  {name}.l{sets}$(t.val > %cal_end%) = {name}.l{sets}{$}[<t>t0];
$ENDLOOP
$LOOP G_static:
  {name}.l{sets}$(t.val > %cal_end%) = {name}.l{sets}{$}[<t>t0];
$ENDLOOP

# Forecast using values from previous_baseline
$FIX All; $UNFIX G_static;
@solve(M_static);

# Output
@unload(Gdx\static_forecast)
