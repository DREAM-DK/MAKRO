set_time_periods(%cal_deep%-1, %terminal_year%);

# ======================================================================================================================
# Filtrering af aldersafhængige parametre
# ======================================================================================================================
$GROUP G_smooth_profiles
  qProdHh_a
  uBoligR_a
  uBoligHtM_a
  ftBund_a
  ftKommune_a
  rTopSkatInd_a
  vPersIndRest_a$(a[a_])
  cHh_a
  rRealKred2Bolig_a
  rvCLejeBolig
  uBoernFraHh_a$(a0t17[a])
  uHhOvfRest
  mtIndRest
  mrKomp
;

$GROUP G_smooth_profiles G_smooth_profiles$(tx0[t]);
@unload_group(G_smooth_profiles, Gdx/smooth_profiles_input.gdx)
execute_unloaddi "Gdx/smooth_profiles_input.gdx" $LOOP G_smooth_profiles:, {name} $ENDLOOP, BruttoArbsty;

embeddedCode Python:
  import dreamtools as dt
  import numpy as np
  from scipy.ndimage import gaussian_filter1d
  import statsmodels.formula.api as sm
 
  db = dt.Gdx("Gdx/smooth_profiles_input.gdx")
  BFR = dt.Gdx("../data/Befolkningsregnskab/BFR.gdx").BFR

  # ----------------------------------------------------------------------------------------------------------------------
  # Fremskrivning af alderspecifik produktivitet - bør rykkes til BFR på sigt
  # ----------------------------------------------------------------------------------------------------------------------
  # Bemærk at samlet produktivitetsniveua kalibreres direkte og at aldersprofilen derfor ikke påvirker samlet demografi

  # Vi samler først alt data til estimation i dataframe
  data = BFR.reset_index().pivot(index=["a_","t"], columns="*", values="BFR").fillna(0).reset_index()
  data["BruttoArbsty"] = data[[soc for soc in db.BruttoArbsty if soc in data.columns]].sum(1)

  data = data[data.a_.isin(db.a)]
  data["a"] = data["a_"].astype(int)

  data = data.merge(db.qProdHh_a.reset_index(), on=["a","t"])

  # Omdanner sociogruppe-variable til frekenser
  for c in ["pension", "efterl", "BruttoArbsty"]:
      data[c] /= data["nPop"] 

  # Tidsdummy - uvæsentlig for 2016-2017
  data["t_fixed_effect"] = data.t.astype(str)

  # Vi vægter efter kohorternes beskæftigelse i timer
  data["weights"] = data["hLHh"] * data["nLHh"]

  # Vi estimerer kun for 21+ årige i år med alders-fordelt data
  sample = data.t.isin([2016, 2017]) & (data.a > 20) & (data.a < 101)

  # Vægtet OLS
  results = sm.wls(
      weights=data[sample]["weights"],
      formula="qProdHh_a ~ pension + efterl + BruttoArbsty + mort_freq + a + t_fixed_effect",
      data=data[sample]
  ).fit()

  data["Intercept"] = 1
  data["fit"] = (results.params * data).sum(1)

  # Overwrite database values with fitted values
  db["qProdHh_a"].loc[range(21,101), 2017:] = data.set_index(["a", "t"])["fit"]

  # ----------------------------------------------------------------------------------------------------------------------
  # Smoothing
  # ----------------------------------------------------------------------------------------------------------------------
  for var_name, a_start, smoothness in [
    ("uBoligR_a", 20, 4),
    ("uBoligHtM_a", 20, 4),
    ("ftBund_a", 15, 3),
    ("ftKommune_a", 15, 3),
    ("rTopSkatInd_a", 15, 3),
    ("vPersIndRest_a", 15, 2),
    ("cHh_a", 0, 4),
    ("rRealKred2Bolig_a", 18, 2),
    ("rvCLejeBolig", 18, 3),
    ("uBoernFraHh_a", 0, 3),
    ("uHhOvfRest", 15, 3),
    ("mtIndRest", 15, 3),
    ("mrKomp", 15, 2),
  ]:
    df = db[var_name].reset_index()
    a = "a" if ("a" in df) else "a_"

    # Limit DataFrame to the years and age groups that we want to smooth (and remove any totals etc.)
    t_range = range(%cal_start%, %cal_deep% + 1)
    a_range = range(a_start, 100 + 1)
    df = df[df["t"].isin(t_range) & df[a].isin(a_range)]

    # Reset set columns as index and groupby all sets except the age set
    var = df.set_index(list(df.columns[:-1]))[df.columns[-1]]
    levels = [i for i in var.index.names if i != a]
    grouped = var.sort_index().groupby(levels, group_keys=False)
    grouped = grouped.apply(np.trim_zeros).groupby(levels)  # Trim zeros at beginning and end of each timeseries

    # Apply smoothing function to each group
    smooth = grouped.transform(lambda x: gaussian_filter1d(x, smoothness, mode="nearest"))

    # Overwrite database values with new smoothed profiles
    db[var_name][smooth.index] = smooth

  db.export("smooth_profiles.gdx")
endEmbeddedCode

@load(G_smooth_profiles, "Gdx\smooth_profiles.gdx");

# Sæt parametre i fremskrivning til udglattet værdi fra sidste kalibreringsår
$LOOP G_smooth_profiles: {name}.l{sets}$({conditions} and tx1[t]) = {name}.l{sets}{$}[<t>"%cal_deep%"];$ENDLOOP

# uBoernFraHh niveau-forskydes vha. uBoernFraHh_t således at den gennemsnitlige overførsel til/fra børn er uændret
uBoernFraHh_t.l[t]$tx0[t] = (sum(a, uBoernFraHh.l[a,t] * nPop.l[a,t]) - sum(a, uBoernFraHh_a.l[a,t] * nPop.l[a,t]))
                          / sum(a$(a.val<18), nPop.l[a,t]);

# Fejl-led i forbrug fjernes
jqCR.l[a,t] = 0;

# ======================================================================================================================
# Dynamisk kalibrering
# ======================================================================================================================
$GROUP G_smoothed_parameters_calibration
  G_deep_dynamic_calibration

  # Consumers
  -uArv # -E_uArv, E_uArv_forecast
  vC_a$(a18t100[a] and t1[t]), -jqCR$(t1[t])
  -qC$(cIkkeBol[c_] and t1[t]) # -E_uFormue
  qBolig[a_,t]$(a18t100[a_]), -uBoligR_a
  -qBolig$(aTot[a_] and t1[t]), fuBolig$(t1[t])
  fuBolig$(tx1[t]) # E_fuBolig_forecast

  # GovRevenues
  -vtBund$(aTot[a_] and t1[t]), ftBund_t$(t1[t])
  -vtKommune$(aTot[a_] and t1[t]), ftKommune_t$(t1[t])
  -vtTop$(aTot[a_] and t1[t]), rTopSkatInd_t$(t1[t])
  -vPersInd$(aTot[a_] and t1[t]), vPersIndRest_t #E_vPersIndRest_t
  rtKilde2Loensum$(t1[t]), -vRestFradragSats$(t1[t]) # vRestFradragSats and vPersIndRest_t are almost singular resulting in pivot errors

  # HHincome
  cHh_t[akt,t]$(fin_akt[akt]), -vHh[portf_,a_,t]$(t1[t] and aTot[a_] and fin_akt[portf_]) #E_cHh_t_forecast
  -vHhPensIndb$(aTot[a_] and pens[portf_] and t1[t]), jlrPensIndb$(t1[t])
  -vHhPensUdb$(aTot[a_] and pens[portf_] and t1[t]), jlrPensUdb$(t1[t])
  -vHh[portf_,a_,t]$(t1[t] and RealKred[portf_] and aTot[a_]), rRealKred2Bolig_t[t] #E_rRealKred2Bolig_t_forecast
;

$GROUP G_smoothed_parameters_calibration G_smoothed_parameters_calibration$(tx0[t]), uFormue;
$BLOCK B_smoothed_parameters_calibration
  # Consumers
  E_fuBolig_forecast[t]$(tx1[t]).. fuBolig[t] =E= fuBolig[t1];

  # GovRevenues
  E_vPersIndRest_t[t]$(tx1[t])..
    vPersIndRest_t[t] / vPersInd[aTot,t] =E= vPersIndRest_t[t1] / vPersInd[aTot,t1];

  # HHincome
  E_cHh_t_forecast[akt,t]$(tx1[t] and fin_akt[akt]).. cHh_t[akt,t] =E= cHh_t[akt,t1];
  E_rRealKred2Bolig_t_forecast[t]$(tx1[t]).. rRealKred2Bolig_t[t] =E= rRealKred2Bolig_t[t1];
$ENDBLOCK

MODEL M_smoothed_parameters_calibration /
  M_deep_dynamic_calibration
  B_smoothed_parameters_calibration
  -E_uFormue
  -E_uArv -E_uArv_forecast
/;

$GROUP G_load G_smoothed_parameters_calibration, -G_do_not_load;
@load(G_load, "Gdx\previous_smooth_calibration.gdx");

# ----------------------------------------------------------------------------------------------------------------------
# Homotopy continuation
# Solve model by gradually adjusting exogenous variables from previous solution
# ----------------------------------------------------------------------------------------------------------------------
#  @load(G_smoothed_parameters_calibration, "Gdx\deep_calibration.gdx");
#  $GROUP G_load All, -G_smoothed_parameters_calibration;
#  @save(G_load)
#  $FOR {share} in [0.8, 0.6, 0.4, 0.2]:
#    @load_linear_combination(G_load, {share}, "Gdx\deep_calibration.gdx")
#    $FIX All; $UNFIX G_smoothed_parameters_calibration;
#    @print("---------------------------------------- Share = {share} ----------------------------------------")
#    @solve(M_smoothed_parameters_calibration); 
#    @reset(G_load);
#  $ENDFOR

# ----------------------------------------------------------------------------------------------------------------------
# Solve
# ----------------------------------------------------------------------------------------------------------------------
$FIX All; $UNFIX G_smoothed_parameters_calibration;
#  @robust_solve(M_smoothed_parameters_calibration);
@solve(M_smoothed_parameters_calibration);

# ----------------------------------------------------------------------------------------------------------------------
# Solve post model containing ouput only variables
# ----------------------------------------------------------------------------------------------------------------------
$FIX All; $UNFIX G_post;
@solve(M_post);

# ----------------------------------------------------------------------------------------------------------------------
# Output
# ----------------------------------------------------------------------------------------------------------------------
@unload(Gdx\smooth_calibration)
@unload_all_nominal(Gdx\smooth_calibration_nominal)

# ----------------------------------------------------------------------------------------------------------------------
# Output til Gekko
# ----------------------------------------------------------------------------------------------------------------------
# M_post kan ikke køre med, da det så ikke bliver square
#  MODEL M_TilGekko /
#    M_base
#    M_post
#  /;

$FIX All; $UNFIX G_endo; # $UNFIX G_post;
option mcp=convert;
solve M_base using mcp;

# ======================================================================================================================
# Tests
# ======================================================================================================================
$IF %run_tests%:
  $IMPORT Tests/test_other_aggregation.gms;
  $IMPORT Tests/test_other.gms;
  $IMPORT Tests/test_age_aggregation.gms;

  # ----------------------------------------------------------------------------------------------------------------------
  # Data check  -  Abort if any data covered variables have been changed by the calibration
  # ----------------------------------------------------------------------------------------------------------------------
  @assert_no_difference_from(G_data, 0.05, _data, "G_imprecise_data was changed by smoothed_parameters_calibration.");
  $GROUP G_precise_data G_data, -G_imprecise_data;
  @assert_no_difference_from(G_precise_data, 1e-6, _data, "G_precise_data was changed by smoothed_parameters_calibration.");
  @assert_no_difference_from(G_exogenous_forecast, 1e-6, _data, "G_exogenous_forecast was changed by smoothed_parameters_calibration.");
  @assert_no_difference_from(G_forecast_as_zero, 1e-6, _data, "G_forecast_as_zero was changed by smoothed_parameters_calibration.");

  # ----------------------------------------------------------------------------------------------------------------------
  # Zero shock  -  Abort if a zero shock changes any variables significantly
  # ----------------------------------------------------------------------------------------------------------------------
  $GROUP G_ZeroShockTest All, -dArv;

  @save(G_ZeroShockTest)
  set_time_periods(%cal_deep%-1, %terminal_year%);
  $FIX All; $UNFIX G_endo;
  @solve(M_base);
  @assert_no_difference(G_ZeroShockTest, 1e-6, "Zero shock changed variables significantly.");
$ENDIF