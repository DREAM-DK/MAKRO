# ======================================================================================================================
# Read baseline and parameters from baseline GDX file
# ======================================================================================================================
set_time_periods(2030-1, %terminal_year%);

execute_load "Gdx\baseline.gdx"
  $LOOP All:, {name} $ENDLOOP
  inf_factor, growth_factor, inf_growth_factor, fp, fq, fv, INF_GROWTH_ADJUSTED, nOvf2Soc
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
@save(G_ZeroShockTest)

$FIX All; $UNFIX G_endo;
@solve(M_base);
$FIX All; $UNFIX G_post;
@solve(M_post);

@assert_no_difference(G_ZeroShockTest, 1e-6, "Zero shock changed variables significantly.");

# Overwrite baseline to bypass GAMS bug which changes case of set element
@unload(gdx\baseline);
