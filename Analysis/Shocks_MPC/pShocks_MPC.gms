# ======================================================================================================================
# MPC and shocks
# ======================================================================================================================
$IMPORT partiel_hh_model.gms

$SETLOCAL shock_year 2026;
OPTION SOLVELINK=0, NLP=CONOPT4;
set_time_periods(%shock_year%-1, %terminal_year%)
@save(All);


# ----------------------------------------------------------------------------------------------------------------------
#  MPC-model - partiel model med endogene skatter og endogent referenceforbrug
# ----------------------------------------------------------------------------------------------------------------------
$MODEL M_MPC
  M_partiel
#  M_incl_tax
  -E_vHhInd
#    B_ref_eksogen
#    -B_ref_endogen
;
$GROUP G_mpc
  G_Partiel
#  G_incl_taxes
  -vHhInd$(a[a_])
;

# Midlertidigt stød
@reset(All);
vHhInd.l[a,t]$(a.val >= 18 and t.val = %shock_year%) = vHhInd.l[a,t] + 0.001;
vHhInd.l[a,t]$(a.val >= 18 and t.val = %shock_year%+1) = vHhInd.l[a,t] + 0.0005;
$FIX ALL; $UNFIX G_mpc$(tx0[t]);
@solve(M_MPC);

$FIX All; $UNFIX G_post_partiel$(tx0[t]);
@solve(B_post_partiel);
@unload(Gdx\mpc);

# Permanent stød
@reset(All);
vHhInd.l[a,t]$(a.val >= 18) = vHhInd.l[a,t] + 0.001;
$FIX ALL; $UNFIX G_mpc$(tx0[t]);
@solve(M_MPC);

$FIX All; $UNFIX G_post_partiel$(tx0[t]);
@solve(B_post_partiel);
@unload(Gdx\mpc_permanent);

#   ----------------------------------------------------------------------------------------------------------------------
#  MPC-model men med eksogent referenceforbrug
#   ----------------------------------------------------------------------------------------------------------------------
$MODEL M_MPC_ref_ekso
  M_MPC, -B_ref_endogen, B_ref_eksogen
;

# Midlertidigt stød
@reset(All);
vHhInd.l[a,t]$(a.val >= 18 and t.val = %shock_year%) = vHhInd.l[a,t]*(1+0.001);
vHhInd.l[a,t]$(a.val >= 18 and t.val = %shock_year%+1) = vHhInd.l[a,t]*(1+0.0005);
$FIX ALL; $UNFIX G_mpc$(tx0[t]);
@solve(M_MPC_ref_ekso);
@unload(Gdx\mpc_ref_ekso);

# Permanent stød
@reset(All);
vHhInd.l[a,t]$(a.val >= 18) = vHhInd.l[a,t]*(1+0.001);
$FIX ALL; $UNFIX G_mpc$(tx0[t]);
@solve(M_MPC_ref_ekso);

$FIX All; $UNFIX G_post_partiel$(tx0[t]);
@solve(B_post_partiel);
@unload(Gdx\mpc_permanent_ref_ekso);


# ----------------------------------------------------------------------------------------------------------------------
#  MPC-model men med eksogen boligmængde i første periode
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_mpc_eksogen_bolig
  G_mpc
  -qBoligR$(a[a_] and t1[t]), uBolig$(t1[t])
  -qBoligHtM$(a[a_] and t1[t]), uBoligHtM$(t1[t])
;

# Midlertidigt stød
@reset(All);
vHhInd.l[a,t]$(a.val >= 18 and t.val = %shock_year%) = vHhInd.l[a,t]*(1+0.001);
vHhInd.l[a,t]$(a.val >= 18 and t.val = %shock_year%+1) = vHhInd.l[a,t]*(1+0.0005);
$FIX ALL; $UNFIX G_mpc_eksogen_bolig$(tx0[t]);
@solve(M_MPC);

$FIX All; $UNFIX G_post_partiel$(tx0[t]);
@solve(B_post_partiel);
@unload(Gdx\mpc_eksogen_bolig);

# Permanent stød
@reset(All);
vHhInd.l[a,t]$(a.val >= 18) = vHhInd.l[a,t]*(1+0.001);
$FIX ALL; $UNFIX G_mpc_eksogen_bolig$(tx0[t]);
@solve(M_MPC);

$FIX All; $UNFIX G_post_partiel$(tx0[t]);
@solve(B_post_partiel);
@unload(Gdx\mpc_permanent_eksogen_bolig);

# Negativt midlertidigt stød
@reset(All);
vHhInd.l[a,t]$(a.val >= 18 and t.val = %shock_year%) = vHhInd.l[a,t]- 0.001;
vHhInd.l[a,t]$(a.val >= 18 and t.val = %shock_year%+1) = vHhInd.l[a,t]- 0.0005;
$FIX ALL; $UNFIX G_mpc$(tx0[t]);
@solve(M_MPC);

$FIX All; $UNFIX G_post_partiel$(tx0[t]);
@solve(B_post_partiel);
@unload(Gdx\mpc_ned_eksogen_bolig);

# Boligpris-stød
@reset(All);
pBolig.l[t] = pBolig.l[t] * 1.01;
$FIX ALL; $UNFIX G_mpc$(tx0[t]);
@solve(M_MPC);

$FIX All; $UNFIX G_post_partiel$(tx0[t]);
@solve(B_post_partiel);
@unload(Gdx\mpc_pBolig_eksogen_bolig);

@reset(All);
pBolig.l[t] = pBolig.l[t] / 1.01;
$FIX ALL; $UNFIX G_mpc$(tx0[t]);
@solve(M_MPC);

$FIX All; $UNFIX G_post_partiel$(tx0[t]);
@solve(B_post_partiel);
@unload(Gdx\mpc_pBolig_ned_eksogen_bolig);

# ======================================================================================================================
# Indkomst-stød på fuld model
# ======================================================================================================================
jvHhNFErest.l[a,t]$(a.val >= 18) = jvHhNFErest.l[a,t] + 0.001;
$FIX All; $UNFIX G_endo;
@solve(M_base);
$FIX All; $UNFIX G_post_endo;
@solve(B_post);
@unload(Gdx\MPC_full_permanent);

@reset(All);
jvHhNFErest.l[a,t]$(a.val >= 18 and t.val = %shock_year%) = jvHhNFErest.l[a,t] + 0.001;
jvHhNFErest.l[a,t]$(a.val >= 18 and t.val = %shock_year%+1) = jvHhNFErest.l[a,t] + 0.0005;
$FIX All; $UNFIX G_endo;
@solve(M_base);
$FIX All; $UNFIX G_post_endo;
@solve(B_post);
@unload(Gdx\MPC_full);

