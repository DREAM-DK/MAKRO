# ======================================================================================================================
# Aggregerings tests . ikke-alders-aggregering
# ======================================================================================================================
# ------------------------------------------------------------------------------------------------------------------
# HH indkomst
# ------------------------------------------------------------------------------------------------------------------
parameter vUdlRenter_sumtest[t]; vUdlRenter_sumtest[t]$(tx1[t] and t.val >= 1996) = vUdlRenter.l[t] + vVirkRenter.l[t] + vHhRenter.l['NetFin',t] + vNROffNetRenter.l[t];
abort$(smax(t, abs(vUdlRenter_sumtest[t])) > 0.15) "vUdlRenter does not match sum of components", vUdlRenter_sumtest;
# Dette test er midlertidigt hævet - hvis fortsat fejl > 0.01 på nyeste databank kontakt ADAM-gruppen

parameter vUdlOmv_sumtest[t]; vUdlOmv_sumtest[t]$(tx0[t] and t.val >= 1995) = vUdlOmv.l[t] + vHhOmv.l['NetFin',t] + vVirkOmv.l[t] + vOffOmv.l[t] - vVirk.l['Guld',t] + vVirk.l['Guld',t-1]/fv;
abort$(smax(t, abs(vUdlOmv_sumtest[t])) > 0.01) "vUdlOmv does not match sum of components", vUdlOmv_sumtest;

# ------------------------------------------------------------------------------------------------------------------
# Aggregering af fremadskuende og hand-to-mouth-husholdninger
# ------------------------------------------------------------------------------------------------------------------
parameter vHhx_HtM_R_test[a,t]; vHhx_HtM_R_test[a,t]$(tx0[t]) = (1-rHtM.l) * vHhxR.l[a,t] + rHtM.l * vHhxHtM.l[a,t] - vHhx.l[a,t];
abort$(smax([a,t], abs(vHhx_HtM_R_test[a,t])) > 1e-9) "vHhxR and vHhxHtm do not sum to vHhx", vHhx_HtM_R_test;

parameter vHhx_tot_HtM_R_test[t]; vHhx_tot_HtM_R_test[t]$(tx0[t]) = vHhxR.l[aTot,t] + vHhxHtM.l[aTot,t] - vHhx.l[aTot,t];
abort$(smax(t, abs(vHhx_tot_HtM_R_test[t])) > 1e-9) "vHhxR and vHhxHtm do not sum to vHhx", vHhx_tot_HtM_R_test;

parameter vHhx_tot_test[t]; vHhx_tot_test[t]$(tx0[t]) = vHhx.l[aTot,t] - (vHh.l['NetFin',aTot,t] - vHh.l['Pens',aTot,t] + vHh.l['RealKred',aTot,t]);
abort$(smax(t, abs(vHhx_tot_test[t])) > 1e-8) "vHhx does not match NetFin-Pens+RealKred", vHhx_tot_test;

# ------------------------------------------------------------------------------------------------------------------
# Forbrug
# ------------------------------------------------------------------------------------------------------------------
parameter vC_NR_test[t]; vC_NR_test[t]$tx0[t] = vC_NR.l[aTot,t] - vC.l[cTot,t];
abort$(smax(t, abs(vC_NR_test[t])) > 1e-7) "vC_NR[aTot] does not match vC[cTot]", vC_NR_test;

# ------------------------------------------------------------------------------------------------------------------
# Labor_market
# ------------------------------------------------------------------------------------------------------------------
parameter sumtest[t];
sumtest[t]$tx0[t] = sum(s, nL.l[s,t]) - nL.l[sTot,t];
abort$(smax(t, abs(sumtest[t])) > 1e-6) "nL[s] summerer ikke til nL[sTot.", sumtest;
sumtest[t]$tx0[t] = sum(sp, nL.l[sp,t]) - nL.l[spTot,t];
abort$(smax(t, abs(sumtest[t])) > 1e-6) "nL[sp] summerer ikke til nL[spTot].", sumtest;

sumtest[t]$tx0[t] = sum(sp, hL.l[sp,t]) - hL.l[spTot,t];
abort$(smax(t, abs(sumtest[t])) > 1e-6) "hL[sp] summerer ikke til hL[spTot].", sumtest;

# ------------------------------------------------------------------------------------------------------------------
# Sociogrupper 
# ------------------------------------------------------------------------------------------------------------------
parameter dSoc2dBesk_besktest[t]; dSoc2dBesk_besktest[t]$(tx0[t] and tBFR[t]) = abs(1 - sum(soc$besktot[soc], dSoc2dBesk.l[soc,t]));
abort$(smax(t, dSoc2dBesk_besktest[t]) > 1e-7) "dSoc2dBesk[besktot] does sum to 1", dSoc2dBesk_besktest;

parameter dSoc2dBesk_sumtest[t]; dSoc2dBesk_sumtest[t]$(tx0[t] and tBFR[t]) = abs(sum(soc, dSoc2dBesk.l[soc,t]));
abort$(smax(t, dSoc2dBesk_sumtest[t]) > 1e-7) "dSoc2dBesk[tot] does sum to 0", dSoc2dBesk_sumtest;

# ------------------------------------------------------------------------------------------------------------------
# Finance
# ------------------------------------------------------------------------------------------------------------------
parameter vEBITDA_sumtest[t]; vEBITDA_sumtest[t]$tx0[t] = sum(s, vEBITDA.l[s,t]) - vEBITDA.l[sTot,t];
abort$(smax(t, abs(vEBITDA_sumtest[t])) > 1e-6) "vEBITDA summerer ikke til total.", vEBITDA_sumtest;

parameter vEBT_sumtest[t]; vEBT_sumtest[t]$tx0[t] = sum(s, vEBT.l[s,t]) - vEBT.l[sTot,t];
abort$(smax(t, abs(vEBT_sumtest[t])) > 1e-6) "vEBT summerer ikke til total.", vEBT_sumtest;

parameter vFCF_sumtest[t]; vFCF_sumtest[t]$(tx0[t] and t.val >= 1984) = sum(s, vFCF.l[s,t]) - vFCF.l[sTot,t];
abort$(smax(t, abs(vFCF_sumtest[t])) > 1e-6) "vFCF summerer ikke til total.", vFCF_sumtest;

# ------------------------------------------------------------------------------------------------------------------
# Government
# ------------------------------------------------------------------------------------------------------------------
parameter vtY_sumtest[t]; vtY_sumtest[t]$tx0[t] = sum(s, vtY.l[s,t]) - vtY.l[sTot,t];
abort$(smax(t, abs(vtY_sumtest[t])) > 1e-6) "vtY summerer ikke til total.", vtY_sumtest;

parameter vtNetYRest_sumtest[t]; vtNetYRest_sumtest[t]$tx0[t] = sum(s, vtNetYRest.l[s,t]) - vtNetYRest.l[sTot,t];
abort$(smax(t, abs(vtNetYRest_sumtest[t])) > 1e-6) "vtNetYRest summerer ikke til total.", vtNetYRest_sumtest;
