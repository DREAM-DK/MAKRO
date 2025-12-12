# ======================================================================================================================
# Aggregerings tests . ikke-alders-aggregering
# ======================================================================================================================
# ------------------------------------------------------------------------------------------------------------------
# Aggregates
# ------------------------------------------------------------------------------------------------------------------
parameter vHhNet_test[t]; vHhNet_test[t]$(tx1[t] and t.val >= 1996) = 
  vHhNet.l[t] 
  - (
  vHhNet.l[t-1]/fv 
   + vHhNetRenter.l[t] + vHhOmv.l['tot',t]
    + vWHh.l[aTot,t]
    + vOvf.l['HhTot',t]
    + vHhNFErest.l[aTot,t]
    - vtHh.l[aTot,t]
    - (vC.l[cTot,t] - vLejeAfEjerBolig.l[t]) # = -(pC['Cx',t] * qCx[aTot,t] + vCLejeBolig[aTot,t] + rBoligOmkRest[t] * vBolig_h[aTot,t-1]/fv)
    - vIBolig.l[t] # Boliginvesteringer
    );
abort$(smax(t, abs(vHhNet_test[t])) > 0.02) "vHhNet does not match DST-equation", vHhNet_test;
# t2 kan ikke testes med eksakt, da vhhx afstemmes i t2.
abort$(smax(t$(tForecast[t] and not t2[t]), abs(vHhNet_test[t])) > 1e-7) "vHhNet does not match DST-equation in forecast", vHhNet_test;

parameter vUdlNetRenter_sumtest[t]; vUdlNetRenter_sumtest[t]$(tx1[t] and t.val >= 1996) = 
  vUdlNetRenter.l[t] + vVirkNetRenter.l[t] + vHhNetRenter.l[t] + vOffNetRenter.l[t];
abort$(smax(t, abs(vUdlNetRenter_sumtest[t])) > 0.15) "vUdlNetRenter does not match sum of components", vUdlNetRenter_sumtest;
abort$(smax(t$(tForecast[t]), abs(vUdlNetRenter_sumtest[t])) > 1e-6) "vUdlNetRenter does not match sum of components in forecast", vUdlNetRenter_sumtest;
# Dette test er midlertidigt hævet - hvis fortsat fejl > 0.01 på nyeste databank kontakt ADAM-gruppen

parameter vUdlNet_sumtest[t]; vUdlNet_sumtest[t]$(tx0[t] and t.val >= 1995) = vUdlNet.l[t] + vVirkNet.l[t] + vHhNet.l[t] + vOffNet.l[t] - vVirkAkt.l['Guld',t];
abort$(smax(t, abs(vUdlNet_sumtest[t])) > 0.05) "vUdlNet does not match sum of components", vUdlNet_sumtest;
abort$(smax(t$(tForecast[t]), abs(vUdlNet_sumtest[t])) > 1e-6) "vUdlNet does not match sum of components in forecast", vUdlNet_sumtest;

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
parameter dSoc2dBesk_besktest[t]; dSoc2dBesk_besktest[t]$(tx0[t] and t.val >= %BFR_t1%) = abs(1 - sum(soc$besktot[soc], dSoc2dBesk.l[soc,t]));
abort$(smax(t, dSoc2dBesk_besktest[t]) > 1e-7) "dSoc2dBesk[besktot] does sum to 1", dSoc2dBesk_besktest;

parameter dSoc2dBesk_sumtest[t]; dSoc2dBesk_sumtest[t]$(tx0[t] and t.val >= %BFR_t1%) = abs(sum(soc, dSoc2dBesk.l[soc,t]));
abort$(smax(t, dSoc2dBesk_sumtest[t]) > 1e-7) "dSoc2dBesk[tot] does sum to 0", dSoc2dBesk_sumtest;

# ------------------------------------------------------------------------------------------------------------------
# Finance
# ------------------------------------------------------------------------------------------------------------------
parameter vEBITDA_sumtest[t]; vEBITDA_sumtest[t]$tx0[t] = sum(s, vEBITDA.l[s,t]) - vEBITDA.l[sTot,t];
abort$(smax(t, abs(vEBITDA_sumtest[t])) > 1e-6) "vEBITDA summerer ikke til total.", vEBITDA_sumtest;

parameter vEBT_sumtest[t]; vEBT_sumtest[t]$tx0[t] = sum(s, vEBT.l[s,t]) - vEBT.l[sTot,t];
abort$(smax(t, abs(vEBT_sumtest[t])) > 1e-6) "vEBT summerer ikke til total.", vEBT_sumtest;

parameter vFCFE_sumtest[t]; vFCFE_sumtest[t]$(tx0[t] and t.val >= 1984) = sum(s, vFCFE.l[s,t]) - vFCFE.l[sTot,t];
abort$(smax(t, abs(vFCFE_sumtest[t])) > 1e-6) "vFCFE summerer ikke til total.", vFCFE_sumtest;

# ------------------------------------------------------------------------------------------------------------------
# Government
# ------------------------------------------------------------------------------------------------------------------
parameter vtY_sumtest[t]; vtY_sumtest[t]$tx0[t] = sum(s, vtY.l[s,t]) - vtY.l[sTot,t];
abort$(smax(t, abs(vtY_sumtest[t])) > 1e-6) "vtY summerer ikke til total.", vtY_sumtest;

parameter vtNetYRest_sumtest[t]; vtNetYRest_sumtest[t]$tx0[t] = sum(s, vtNetYRest.l[s,t]) - vtNetYRest.l[sTot,t];
abort$(smax(t, abs(vtNetYRest_sumtest[t])) > 1e-6) "vtNetYRest summerer ikke til total.", vtNetYRest_sumtest;

parameter vtNetY_sumtest[t]; vtNetY_sumtest[t]$tx0[t] = sum(s, vtNetY.l[s,t]) - vtNetY.l[sTot,t];
abort$(smax(t, abs(vtNetY_sumtest[t])) > 1e-6) "vtNetY summerer ikke til total.", vtNetY_sumtest;

# ------------------------------------------------------------------------------------------------------------------
# Input-outpit
# ------------------------------------------------------------------------------------------------------------------
abort$(smax([s,t], abs(jfpIOy_s.l[s,t])) > 1e-6) "jfpIOy_s er ikke 0", jfpIOy_s.l;
abort$(smax([s,t], abs(jfpIOm_s.l[s,t])) > 1e-6) "jfpIOm_s er ikke 0", jfpIOm_s.l;