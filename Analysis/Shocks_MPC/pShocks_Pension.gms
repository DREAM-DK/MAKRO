# ======================================================================================================================
# Permanent shocks
# ======================================================================================================================
$IMPORT partiel_hh_model.gms

$SETLOCAL shock_year 2026;
OPTION SOLVELINK=0, NLP=CONOPT4;
set_time_periods(%shock_year%-1, %terminal_year%);

parameter dt[t], tBund_reaction[t];
dt[t] = t.val - %shock_year%;
#  tBund_reaction[t]$(dt[t] >= 0) = 0.00001 * dt[t]**7 / (1 + 0.00001 * dt[t]**7);
tBund_reaction[t]$(dt[t] = 0) = 0;
tBund_reaction[t]$(dt[t] = 1) = 0.25;
tBund_reaction[t]$(dt[t] = 2) = 0.5;
tBund_reaction[t]$(dt[t] = 3) = 0.75;
tBund_reaction[t]$(dt[t] > 3) = 1;

$BLOCK B_tax_reaction
  E_tBund_reaction[t]$tx0E[t].. tBund[t] =E= tBund.l[t] + tBund_reaction[t] * (tBund[tEnd] - tBund.l[tEnd]);
  E_tBund_reaction_tEnd[t]$(tEnd[t]).. vOffNetFormue[t] / vBNP[t] =E= vOffNetFormue[t-1] / vBNP[t-1];
$ENDBLOCK

$MODEL M_base_fin
  M_base
  B_tax_reaction
;

@save(All);

# ----------------------------------------------------------------------------------------------------------------------
#  Pensionsmodel - partiel model
# ----------------------------------------------------------------------------------------------------------------------
@reset(All);
rPensIndb.l['PensX',a,t] = rPensIndb.l['PensX',a,t] + 0.01;
$FIX ALL; $UNFIX G_Partiel$(tx0[t]);
@solve(M_partiel);

$FIX All; $UNFIX G_post_partiel$(tx0[t]);
@solve(B_post_partiel);
@unload(Gdx\rPensIndb);

# ----------------------------------------------------------------------------------------------------------------------
#  Pensionsmodel - partiel model med endogen realkredit
# ----------------------------------------------------------------------------------------------------------------------
$MODEL M_partiel_endogen_realkred
  M_partiel
  B_realkred_endogen
;
$GROUP G_partiel_endogen_realkred
  G_Partiel
  cHh_a$(fin_akt[akt] and a0t100[a])
 ;

@reset(All);
rPensIndb.l['PensX',a,t] = rPensIndb.l['PensX',a,t] + 0.01;

$FIX ALL; $UNFIX G_partiel_endogen_realkred$(tx0[t]);
@solve(M_partiel_endogen_realkred);

$FIX All; $UNFIX G_post_partiel$(tx0[t]);
@solve(B_post_partiel);
@unload(Gdx\rPensIndb_endo_realkred);

# ----------------------------------------------------------------------------------------------------------------------
# Pensionsmodel - partiel model med eksogeniseret marginalnytte af formue 
# ----------------------------------------------------------------------------------------------------------------------
$MODEL M_pension_eksogen_qFormueBase
  M_partiel
  -E_qFormueBase
;
$GROUP G_pension_eksogen_qFormueBase
  G_Partiel
  -qFormueBase[a,t]
;

@reset(All);
rPensIndb.l['PensX',a,t] = rPensIndb.l['PensX',a,t] + 0.01;
$FIX ALL; $UNFIX G_pension_eksogen_qFormueBase$(tx0[t]);
@solve(M_pension_eksogen_qFormueBase);

$FIX All; $UNFIX G_post_partiel$(tx0[t]);
@solve(B_post_partiel);
@unload(Gdx\rPensIndb_ekso_qFormueBase);
@unload(Gdx\rPensIndb_f);

# ----------------------------------------------------------------------------------------------------------------------
# Pensionsmodel - partiel model med eksogeniseret marginalnytte af formue og eksogen qBoligHtM
# ----------------------------------------------------------------------------------------------------------------------
$MODEL M_pension_eksogen_qBoligHtM
  M_partiel
  -E_qFormueBase
;
$GROUP G_pension_eksogen_qBoligHtM
  G_Partiel
  -qFormueBase[a,t]
  -qBoligHtM$(a18t100[a_]), uBoligHtM$(a18t100[a])
;

@reset(All);
rPensIndb.l['PensX',a,t] = rPensIndb.l['PensX',a,t] + 0.01;
$FIX ALL; $UNFIX G_pension_eksogen_qBoligHtM$(tx0[t]);
@solve(M_pension_eksogen_qBoligHtM);

$FIX All; $UNFIX G_post_partiel$(tx0[t]);
@solve(B_post_partiel);
@unload(Gdx\rPensIndb_ekso_qBoligHtM);
@unload(Gdx\rPensIndb_b);

# ----------------------------------------------------------------------------------------------------------------------
# Pensionsindbetalinger i fuld model
# ----------------------------------------------------------------------------------------------------------------------
@reset(All);
$FIX All; $UNFIX G_endo;

$UNFIX tBund$(tx0[t]);

rPensIndb.up['PensX',a,t] = rPensIndb.l['PensX',a,t] + 0.01;
rPensIndb.lo['PensX',a,t] = rPensIndb.l['PensX',a,t] + 0.01;

@solve(M_base_fin)
$FIX All; $UNFIX G_post_endo;
@solve(B_post);

@unload(Gdx\Pension_fin_pshock);

# ----------------------------------------------------------------------------------------------------------------------
# Pensionsindbetalinger - ufinansieret
# ----------------------------------------------------------------------------------------------------------------------
@reset(All);
$FIX All; $UNFIX G_endo;

rPensIndb.up['PensX',a,t] = rPensIndb.l['PensX',a,t] + 0.01;
rPensIndb.lo['PensX',a,t] = rPensIndb.l['PensX',a,t] + 0.01;

@solve(M_base)
$FIX All; $UNFIX G_post_endo;
@solve(B_post);

@unload(Gdx\Pension_pshock);

# ----------------------------------------------------------------------------------------------------------------------
# Pensionsindbetalinger - ufinansieret - lille stød
# ----------------------------------------------------------------------------------------------------------------------
@reset(All);
$FIX All; $UNFIX G_endo;

rPensIndb.up['PensX',a,t] = rPensIndb.l['PensX',a,t] + 0.001;
rPensIndb.lo['PensX',a,t] = rPensIndb.l['PensX',a,t] + 0.001;

#  @solve(M_base)
#  $FIX All; $UNFIX G_post_endo;
#  @solve(B_post);

#  @unload(Gdx\Pension_lille_pshock);

# ----------------------------------------------------------------------------------------------------------------------
# Pensionsindbetalinger - ufinansieret - stort stød
# ----------------------------------------------------------------------------------------------------------------------
@reset(All);
$FIX All; $UNFIX G_endo;

rPensIndb.up['PensX',a,t] = rPensIndb.l['PensX',a,t] + 0.1;
rPensIndb.lo['PensX',a,t] = rPensIndb.l['PensX',a,t] + 0.1;

#  @solve(M_base)
#  $FIX All; $UNFIX G_post_endo;
#  @solve(B_post);

#  @unload(Gdx\Pension_stor_pshock);

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
