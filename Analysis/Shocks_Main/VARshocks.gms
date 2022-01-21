# ======================================================================================================================
# Shocks based on empirical impulse responses that we want to match
# ======================================================================================================================
$import ..\..\Model\matching.gms;

# ----------------------------------------------------------------------------------------------------------------------
# Re-calibrate with fewer years
# ----------------------------------------------------------------------------------------------------------------------
#  #  @load(G_dynamic_calibration, "Gdx\Baseline.gdx")
#  set_time_periods(%cal_end%-1, %terminal_year%);
#  $FIX All; $UNFIX G_dynamic_calibration;
#  @solve(M_dynamic_calibration);
#  $FIX All; $UNFIX G_post_endo;
#  @solve(B_post);

#  @unload_all(Gdx\Baseline);

# ----------------------------------------------------------------------------------------------------------------------
# Link MAKRO scenarios to empirical IRFS
# ----------------------------------------------------------------------------------------------------------------------
set active[scen] "Active scenario";
active[scen] = No;
$GROUP G_active
  loss[IRF,scen]                   "Loss function contribution by IRF and shock"
  loss_total                       "Loss function to be minimized"
  MAKRO[IRF,t,scen]$(active[scen]) "MAKRO impulse responses"
;

$BLOCK B_MAKRO_response
  E_MAKRO_G[t,scen]$(active[scen] and tx0[t]).. 
    MAKRO['log(G)',t,scen] =E= log(qG[gTot,t]) - log(qG.l[gTot,t]);

  E_MAKRO_IntRate[t,scen]$(active[scen] and tx0[t])..
    MAKRO['RF',t,scen] =E= rRente['Obl',t] - rRente.l['Obl',t];

  E_MAKRO_YF[t,scen]$(active[scen] and tx0[t])..
    qXMarked['xTje',t] =E= qXMarked.l['xTje',t] * (1 + MAKRO['YF',t,scen]);

  E_MAKRO_PF[t,scen]$(active[scen] and tx0[t])..
    MAKRO['PF',t,scen] =E= log(pXUdl['xVar',t]) - log(pXUdl.l['xVar',t]);

  E_MAKRO_POIL[t,scen]$(active[scen] and tx0[t])..
    MAKRO['POIL',t,scen] =E= log(pOlie[t]) - log(pOlie.l[t]);

  E_MAKRO_GDP[t,scen]$(active[scen] and tx0[t]).. 
    MAKRO['log(GDP)',t,scen] =E= log(qBNP[t]) - log(qBNP.l[t]);

  E_MAKRO_C[t,scen]$(active[scen] and tx0[t])..
    MAKRO['log(C)',t,scen] =E= log(qC[cTot,t]) - log(qC.l[cTot,t]);

  E_MAKRO_pC[t,scen]$(active[scen] and tx0[t]).. 
    MAKRO['log(PC)',t,scen] =E= log(pC[cTot,t]) - log(pC.l[cTot,t]);

  E_MAKRO_pY[t,scen]$(active[scen] and tx0[t]).. 
    #  MAKRO['log(PY)',t,scen] =E= log(pY[sTot,t]) - log(pY.l[sTot,t]);
    MAKRO['log(PY)',t,scen] =E= log(pBNP[t]) - log(pBNP.l[t]);

  E_MAKRO_W[t,scen]$(active[scen] and tx0[t]).. 
    MAKRO['log(W)',t,scen] =E= log(vWHh[aTot,t]/nLHh[aTot,t]) - log(vWHh.l[aTot,t]/nLHh.l[aTot,t]);

  E_MAKRO_log_EX[t,scen]$(active[scen] and tx0[t]).. 
    MAKRO['log(EX)',t,scen] =E= log(qX['xTje',t] + qX['xVar',t] + qX['xSoe',t])
                              - log(qX.l['xTje',t] + qX.l['xVar',t] + qX.l['xSoe',t]);

  E_MAKRO_log_PEX[t,scen]$(active[scen] and tx0[t]).. 
    MAKRO['log(PEX)',t,scen] =E= log((vX['xTje',t] + vX['xVar',t] + vX['xSoe',t]) / (qX['xTje',t] + qX['xVar',t] + qX['xSoe',t]))
                               - log((vX.l['xTje',t] + vX.l['xVar',t] + vX.l['xSoe',t]) / (qX.l['xTje',t] + qX.l['xVar',t] + qX.l['xSoe',t]));

  E_MAKRO_iM[t,scen]$(active[scen] and tx0[t]).. 
    MAKRO['log(IM)',t,scen] =E= log(qI['iM',t] - qI_s['iM','off',t]) - log(qI.l['iM',t] - qI_s.l['iM','off',t]);

  E_MAKRO_iBx[t,scen]$(active[scen] and tx0[t]).. 
    MAKRO['log(IBx)',t,scen] =E= log(qI['iB',t] - qIBolig[t] - qI_s['iB','off',t])
                             - log(qI.l['iB',t] - qIBolig.l[t] - qI_s.l['iB','off',t]);

  E_MAKRO_iBol[t,scen]$(active[scen] and tx0[t]).. 
    MAKRO['log(IBol)',t,scen] =E= log(qIBolig[t]) - log(qIBolig.l[t]);

  E_MAKRO_PBol[t,scen]$(active[scen] and tx0[t]).. 
    MAKRO['log(PBol)',t,scen] =E= log(pBolig[t]) - log(pBolig.l[t]);

  E_MAKRO_MarkovUGap[t,scen]$(active[scen] and tx0[t]).. 
    MAKRO['MarkovUGap',t,scen] =E= (rLedig[t] - srLedig.l[t]) - (rLedig.l[t] - srLedig.l[t]);

  E_MAKRO_MarkovLSupply[t,scen]$(active[scen] and tx0[t]).. 
    MAKRO['MarkovLSupply',t,scen] =E= (nSoc['bruttoled',t] - nSoc.l['bruttoled',t]) * 10
                                    - (snSoc['bruttoled',t] - snSoc.l['bruttoled',t]) * 10;
$ENDBLOCK

parameter dt[t], tBund_reaction[t], g_reaction[t];
dt[t] = t.val - %shock_year%;
tBund_reaction[t]$(dt[t] = 0) = 0;
tBund_reaction[t]$(dt[t] = 1) = 0.25;
tBund_reaction[t]$(dt[t] = 2) = 0.5;
tBund_reaction[t]$(dt[t] = 3) = 0.75;
tBund_reaction[t]$(dt[t] > 3) = 1;
g_reaction[t] = 0;

$BLOCK B_tax_reaction
  E_tBund_reaction[t]$tx0E[t].. tBund[t] =E= tBund.l[t] + tBund_reaction[t] * (tBund[tEnd] - tBund.l[tEnd]);
  E_tBund_reaction_tEnd[t]$(tEnd[t]).. vOffNetFormue[t] / vBNP[t] =E= vOffNetFormue[t-1] / vBNP[t-1];
$ENDBLOCK
$BLOCK B_G_reaction
  E_qG_reaction[t]$tx0E[t].. qG[gTot,t] =E= qG.l[gTot,t] + g_reaction[t] * (qG[gTot,tEnd] - qG.l[gTot,tEnd]);
  E_qG_reaction_tEnd[t]$(tEnd[t]).. vG[gTot,t] / vBNP[t] =E= vG.l[gTot,t] / vBNP.l[t];
$ENDBLOCK

$GROUP G_GovSpending_shock rOffL2Gshock[t] "Af FM estimeret ændring i offentlig beskæftigelse som andel af stød til offentligt forbrug.";
rOffL2Gshock.l[t]$(t.val = %shock_year%) = 0.073;
rOffL2Gshock.l[t]$(t.val = %shock_year%+1) = 0.575;
rOffL2Gshock.l[t]$(t.val = %shock_year%+2) = 0.953;
rOffL2Gshock.l[t]$(t.val = %shock_year%+3) = 1.081;
rOffL2Gshock.l[t]$(t.val > %shock_year%+3) = 1;

$BLOCK B_GovSpending_shock
  E_qG_GovSpendingShock[t]$(tx0[t]).. 
    qG[gTot,t] =E= qG.l[gTot,t] * (1 + Median['log(G)',t,'GovSpending']);

  E_qI_pub_GovSpendingShock[i,t]$(tx0[t] and (sameas['iM',i] or sameas['iB',i])).. 
    #  qI_s[i,'off',t] / qI_s.l[i,'off',t] =E= nL['off',t] / nL.l['off',t];
    qI_s[i,'off',t] =E= qI_s.l[i,'off',t] * (1 + Median['log(G)',t,'GovSpending']);

  E_nL_GovSpendingShock[t]$(tx0[t])..
    nL['off',t] =E= nL.l['off',t] * (1 + rOffL2Gshock[t] * Median['log(G)',t,'GovSpending']);

  E_vtLukning_GovSpendingShock[t]$(tx0[t])..  # Parametrene er estimeret på vækst- og inflations-korrigeret data, og vi skal derfor ikke korrigere de laggede variable.
    vtLukning[aTot,t] - vtLukning.l[aTot,t] =E=
        0.46 * (vtLukning[aTot,t-1] - vtLukning.l[aTot,t-1])
      - 0.43 * ((vG[gTot,t] + vI_s['iM','off',t] + vI_s['iB','off',t]) - (vG.l[gTot,t] + vI_s.l['iM','off',t] + vI_s.l['iB','off',t]))
      + 0.36 * ((vG[gTot,t-3] + vI_s['iM','off',t-3] + vI_s['iB','off',t-3]) - (vG.l[gTot,t-3] + vI_s.l['iM','off',t-3] + vI_s.l['iB','off',t-3]));
$ENDBLOCK

$BLOCK B_ForeignDemand_shock
  # Foreign demand shock
  E_pUdl_ForeignDemandShock[t]$(tx0[t]).. 
    MAKRO['PF',t,'ForeignDemand'] =E= Median['PF',t,'ForeignDemand'];

  E_qXMarked_ForeignDemandShock[x,t]$(tx0[t]).. 
    qXMarked[x,t] =E= qXMarked.l[x,t] * (1 + Median['YF',t,'ForeignDemand']);

  E_IntRate_ForeignDemandShock[t]$(tx0[t]).. 
    rRente['Obl',t] =E= rRente.l['Obl',t] + Median['RF',t,'ForeignDemand'];

  #  E_rIndlAktiePrem_ForeignDemandShock[sp,t]$(tx0[t])..
  #    rIndlAktiePrem[sp,t] =E= rIndlAktiePrem.l[sp,t] - Median['RF',t,'ForeignDemand'];

  E_rDisk_ForeignDemandShock_t1[t,scen]$(active[scen] and t1[t])..
    MAKRO['log(C)',t,scen] =E= Median['log(C)',t,scen];

  E_rDisk_ForeignDemandShock_tx1[t,scen]$(active[scen] and tx1[t])..
    (rDisk_t[t-1] - rDisk_t.l[t-1]) * 0.4 =E= rDisk_t[t] - rDisk_t.l[t];
$ENDBLOCK

$BLOCK B_IntRate_shock
  # Foreign interest rate shock
  E_pUdl_IntRateShock[t]$(tx0[t]).. 
    MAKRO['PF',t,'IntRate'] =E= Median['PF',t,'IntRate'];

  E_qXMarked_IntRateShock[x,t]$(tx0[t]).. 
    qXMarked[x,t] =E= qXMarked.l[x,t] * (1 + Median['YF',t,'IntRate']);

  E_IntRate_IntRateShock[t]$(tx0[t]).. 
    rRente['Obl',t] =E= rRente.l['Obl',t] + Median['RF',t,'IntRate'];

  #  E_rIndlAktiePrem_IntRateShock[sp,t]$(tx0[t])..
  #    rIndlAktiePrem[sp,t] =E= rIndlAktiePrem.l[sp,t] - Median['RF',t,'IntRate'];
$ENDBLOCK

$BLOCK B_OilPrice_shock
  # Oil prices shock
  E_pOil_OilPriceShock[t]$(tx0[t]).. 
    MAKRO['pOil',t,'OilPrice'] =E= Median['pOil',t,'OilPrice'];

  E_pUdl_OilPriceShock[t]$(tx0[t]).. 
    MAKRO['PF',t,'OilPrice'] =E= Median['PF',t,'OilPrice'];

  E_qXMarked_OilPriceShock[x,t]$(tx0[t]).. 
    qXMarked[x,t] =E= qXMarked.l[x,t] * (1 + Median['YF',t,'OilPrice']);

  E_IntRate_OilPriceShock[t]$(tx0[t]).. 
    rRente['Obl',t] =E= rRente.l['Obl',t] + Median['RF',t,'OilPrice'];

  #  E_rIndlAktiePrem_OilPriceShock[sp,t]$(tx0[t])..
  #    rIndlAktiePrem[sp,t] =E= rIndlAktiePrem.l[sp,t] - Median['RF',t,'OilPrice'];
$ENDBLOCK

$MODEL M_ForeignDemand_shock
  M_base
  B_MAKRO_response, B_loss_function
  B_tax_reaction
  #  B_G_reaction
  B_ForeignDemand_shock
;
$MODEL M_GovSpending_shock
  M_base
  B_MAKRO_response, B_loss_function
  B_tax_reaction
  B_GovSpending_shock
;
$MODEL M_IntRate_shock
  M_base
  B_MAKRO_response, B_loss_function
  B_tax_reaction
  B_IntRate_shock
;
$MODEL M_OilPrice_shock
  M_base
  B_MAKRO_response, B_loss_function
  B_tax_reaction
  B_OilPrice_shock
;
$MODEL M_LaborSupply_shock
  M_base
  B_MAKRO_response, B_loss_function
  B_tax_reaction
  #  B_G_reaction
;

# ======================================================================================================================
# Shock model with SVAR impulses and solve square collection of scenario models with fixed parameters
# ======================================================================================================================
set_time_periods(%shock_year%-1, %terminal_year%);
$GROUP G_reset All, -G_matching;  # We reset everything after each shock, except the responses stored in 'MAKRO'
@save(G_reset);

# ----------------------------------------------------------------------------------------------------------------------
# Gov shock
# ----------------------------------------------------------------------------------------------------------------------
# Government consumption and capital investments follow SVAR median
@reset(G_reset);
active[scen] = yes$(sameas[scen,"GovSpending"]);

$FIX All; $UNFIX G_endo, G_active;
$UNFIX tBund$(tx0[t]);
$UNFIX qI_s$((sameas['iM',i_] or sameas['iB',i_]) and sOff[s_] and tx0[t]);
$UNFIX qG[g_,t]$(tx0[t] and sameas['gTot',g_]);
$UNFIX nL$(tx0[t] and sameas['off',s_]);
$UNFIX vtLukning$(tx0[t] and aTot[a_]);

@solve(M_GovSpending_shock)

$FIX All; $UNFIX G_post_endo;
@solve(B_post);

@unload_all(Gdx\GovSpending_VARshock);

# ----------------------------------------------------------------------------------------------------------------------
# rRente rate shock
# ----------------------------------------------------------------------------------------------------------------------
@reset(G_reset);
active[scen] = yes$(sameas[scen,"IntRate"]);

$FIX All; $UNFIX G_endo, G_active;

$UNFIX tBund$(tx0[t]);

$UNFIX qXMarked$(tx0[t]);
$UNFIX pUdl$(tx0[t]);
$UNFIX rRente$(tx0[t] and sameas[portf,'Obl']);
#  $UNFIX rIndlAktiePrem$(tx0[t]);

@solve(M_IntRate_shock)

$FIX All; $UNFIX G_post_endo;
@solve(B_post);

@unload_all(Gdx\IntRate_VARshock);

# ----------------------------------------------------------------------------------------------------------------------
# Foreign demand shock
# ----------------------------------------------------------------------------------------------------------------------
@reset(G_reset);
active[scen] = yes$(sameas[scen,"ForeignDemand"]);
$FIX All; $UNFIX G_endo, G_active;

$UNFIX tBund$(tx0[t]);

$UNFIX qXMarked$(tx0[t]);
$UNFIX pUdl$(tx0[t]);
$UNFIX rRente$(tx0[t] and sameas[portf,'Obl']);
#  $UNFIX rIndlAktiePrem$(tx0[t]);

$UNFIX rDisk_t$(tx0[t]);

@solve(M_ForeignDemand_shock)
$FIX All; $UNFIX G_post_endo;
@solve(B_post);

@unload_all(Gdx\ForeignDemand_VARshock);

# ----------------------------------------------------------------------------------------------------------------------
# Oil price shock
# ----------------------------------------------------------------------------------------------------------------------
@reset(G_reset);
active[scen] = yes$(sameas[scen,"OilPrice"]);
$FIX All; $UNFIX G_endo, G_active;

$UNFIX tBund$(tx0[t]);

$UNFIX qXMarked$(tx0[t]);
$UNFIX pUdl$(tx0[t]);
$UNFIX pOlie$(tx0[t]);
$UNFIX rRente$(tx0[t] and sameas[portf,'Obl']);
#  $UNFIX rIndlAktiePrem$(tx0[t]);

@solve(M_OilPrice_shock)
$FIX All; $UNFIX G_post_endo;
@solve(B_post);

@unload_all(Gdx\OilPrice_VARshock);

# ----------------------------------------------------------------------------------------------------------------------
# Labor supply shock
# ----------------------------------------------------------------------------------------------------------------------
@reset(G_reset);
active[scen] = yes$(sameas[scen,"LaborSupply"]);

nPop.l[a,t] = nPop.l[a,t] * nPop_shock[a,t];

snSocFraBesk[soc_,aTot,t]$tx0[t] = sum(a, snSocFraBesk[soc_,a,t] * nPop_shock[a,t]);
snSocResidual[soc_,aTot,t]$tx0[t] = sum(a, snSocResidual[soc_,a,t] * nPop_shock[a,t]);
dSoc2dBesk.l[soc,t]$tx0[t] = snSocFraBesk[soc,aTot,t] / sum(a, snLHh.l[a,t] * nPop_shock[a,t]);
dSoc2dPop.l[soc,t]$tx0[t] = snSocResidual[soc,aTot,t] / sum(a$a15t100[a], nPop.l[a,t]);

$FIX All; $UNFIX G_endo, G_active;

$UNFIX tBund$(tx0[t]);

@solve(M_LaborSupply_shock)
$FIX All; $UNFIX G_post_endo;
@solve(B_post);

@unload_all(Gdx\LaborSupply_VARshock);


$GROUP G_output G_active, G_matching_parameters, G_IRF, MAKRO;
@unload_group(G_output, Gdx\matching_shocks);