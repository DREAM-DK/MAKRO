# Shock VAR model through DGE output and prices 
qUSInd.fx[t]$(t.val > %shock_period_foreign%) =  dYFq.l[t]/std_pUSCPI; # shock-scaled already
pUSCPI.fx[t]$(t.val > %shock_period_foreign%) =  dPFq.l[t]/std_qUSInd; # shock-scaled already

$FIX All; $UNFIX G_VAR, - qUSInd, - pUSCPI;
solve M_DGE2VAR using CNS;
@set(All, _shock, .l);
$FIX All; $UNFIX G_VAR; # transformation
solve B_VAR_STANDARDIZE  using CNS;
execute_unloaddi 'Gdx/VAR%shockname%.gdx';

# SMOOTHING OF VAR OUTPUTS
$IMPORT VAR_model/smooth_var.gms