# ======================================================================================================================
# Read baseline and parameters from baseline GDX file
# ======================================================================================================================
set_time_periods(2030-1, %terminal_year%);

execute_load "Gdx\baseline.gdx"
  $LOOP All:, {name} $ENDLOOP
  fpt, fqt, fvt, fp, fq, fv, INF_GROWTH_ADJUSTED, nOvf2nSoc
  d1IO, d1IOy, d1IOm, d1Xm, d1Xy, d1CTurist, d1X, d1I_s, d1K, d1R, d1C, d1G
  d1vHh
;

# ======================================================================================================================
# Tests
# ======================================================================================================================
# Aggregation tests
$IMPORT Tests/test_other_aggregation.gms;
$IMPORT Tests/test_other.gms;
$IMPORT Tests/test_age_aggregation.gms;

# ----------------------------------------------------------------------------------------------------------------------
# Zero shock  -  Abort if a zero shock changes any variables significantly
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_ZeroShockTest All, -dArv;
@set(G_ZeroShockTest, _saved, .l)

$FIX All; $UNFIX G_endo;
@solve(M_base);

@assert_no_difference(G_ZeroShockTest, 1e-6, .l, _saved, "Zero shock changed variables significantly.");
