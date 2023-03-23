# ======================================================================================================================
# File to export all variables with values only after a specific year
# ======================================================================================================================

# Variables that enter with more than one lag in the model are exported further back
$GROUP G_2lags
  vBVT
  nL
  pY
  pW
  pBolig
;
$GROUP G_3lags
  vWHh
  nLHh
;

$GROUP G_tBase_needed
  tIOy
  tIOm
  qY$(udv[s_])
  pOlieBrent
  rDollarKurs
;
$GROUP G_other
  All, -G_2lags, -G_3lags, -G_constants, -G_tBase_needed$(tBase[t]), -sqBVT$(spTot[s_])
;

$LOOP G_other:
  {name}.l{sets}$({conditions} and t.val < 2030-1) = 0;
$ENDLOOP

$LOOP G_2lags:
  {name}.l{sets}$(t.val < 2030-2) = 0;
$ENDLOOP

$LOOP G_3lags:
  {name}.l{sets}$(t.val < 2030-3) = 0;
$ENDLOOP

sqBVT.l[spTot,t]$(t.val < 2030-4) = 0;

set_time_periods(2030-1, %terminal_year%);
$UNFIX All; $FIX All; $UNFIX G_endo;

# Export all variables to GDX files (with and without adjusment for inflation and growth).
execute_unloaddi "Gdx/baseline"
  $LOOP All:, {name} $ENDLOOP
  inf_factor, growth_factor, inf_growth_factor, fp, fq, fv, INF_GROWTH_ADJUSTED, nOvf2Soc
  a_, a, a0t100, a15t100, a18t100, aTot
  ovf_, ovf, soc
  portf_, akt, pas
  d_, d, s_, s, x_, x, g_, g, c_, c, i_, i, k_, k 
  sTot, kTot
  d1IO, d1IOy, d1IOm, d1Xm, d1Xy, d1CTurist, d1X, d1I_s, d1K, d1R, d1C, d1G
  d1vHh
;

@remove_inf_growth_adjustment()
execute_unloaddi "Gdx/nominal_baseline"
  $LOOP All:, {name} $ENDLOOP
  inf_factor, growth_factor, inf_growth_factor, fp, fq, fv, INF_GROWTH_ADJUSTED, nOvf2Soc
  a_, a, a0t100, a15t100, a18t100, aTot
  ovf_, ovf, soc
  portf_, akt, pas
  d_, d, s_, s, x_, x, g_, g, c_, c, i_, i, k_, k 
  sTot, kTot
  d1IO, d1IOy, d1IOm, d1Xm, d1Xy, d1CTurist, d1X, d1I_s, d1K, d1R, d1C, d1G
  d1vHh
;
@inf_growth_adjust()
