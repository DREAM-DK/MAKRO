# ======================================================================================================================
# Alders-aggregerings tests
# ======================================================================================================================
# ------------------------------------------------------------------------------------------------------------------
# Pension
# ------------------------------------------------------------------------------------------------------------------
parameter vHhPensIndb_sumtest[pens_,t]; vHhPensIndb_sumtest[pens,t]$tx0[t] = vHhPensIndb.l[pens,aTot,t] - sum(a, vHhPensIndb.l[pens,a,t] * nPop.l[a,t]);
abort$(smax(pens, smax(t, abs(vHhPensIndb_sumtest[pens,t]))) > 1e-7) "vHhPensIndb[#pens,tot] does not match sum over ages", vHhPensIndb_sumtest;

parameter vHhPensAfk_sumtest[pens,t]; vHhPensAfk_sumtest[pens,t]$tx0[t] = vHhPensAfk.l[pens,aTot,t] - sum(a, vHhPensAfk.l[pens,a,t] * nPop.l[a-1,t-1]);
abort$(smax([pens,t], abs(vHhPensAfk_sumtest[pens,t])) > 1e-4) "Aldersfordelt vHhPensAfk summerer ikke til total.", vHhPensAfk_sumtest;

parameter jvHhPensAfk_sumtest[pens,t]; jvHhPensAfk_sumtest[pens,t]$tx0[t] = jvHhPensAfk.l[pens,aTot,t] - sum(a, jvHhPensAfk.l[pens,a,t] * nPop.l[a-1,t-1]);
abort$(smax([pens,t], abs(jvHhPensAfk_sumtest[pens,t])) > 1e-7) "jvHhPensAfk_tot does not match sum of jvHhPensAfk[#a]", jvHhPensAfk_sumtest;

# ------------------------------------------------------------------------------------------------------------------
# Hh indkomst
# ------------------------------------------------------------------------------------------------------------------
parameter vOvf_sumtest[t]; vOvf_sumtest[t]$tx0[t] = vOvf.l['HhTot',t] - sum(a, vHhOvf.l[a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vOvf_sumtest[t])) > 1e-9) "vOvf[HhTot] does not match sum of vHhOvf[#a]", vOvf_sumtest;

parameter vHhNFErest_sumtest[t]; vHhNFErest_sumtest[t]$tx0[t] = vHhNFErest.l[aTot,t] - sum(a, vHhNFErest.l[a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vHhNFErest_sumtest[t])) > 1e-9) "vHhNFErest[tot] does not match sum of components", vHhNFErest_sumtest;

parameter vtLukning_sumtest[t]; vtLukning_sumtest[t]$tx0[t] = vtLukning.l[aTot,t] - sum(a, vtLukning.l[a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vtLukning_sumtest[t])) > 1e-9) "vtLukning[tot] does not match sum of components", vtLukning_sumtest;

parameter vtHhx_sumtest[t]; vtHhx_sumtest[t]$tx0[t] = vtHhx.l[aTot,t] - sum(a, vtHhx.l[a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vtHhx_sumtest[t])) > 1e-9) "vtHhx[tot] does not match sum of components", vtHhx_sumtest;

parameter vHhInd_sumtest[t]; vHhInd_sumtest[t]$(tx0[t]) = vHhInd.l[aTot,t] - sum(a, vHhInd.l[a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vHhInd_sumtest[t])) > 1e-9) "vHhInd[tot] does not match sum of components", vHhInd_sumtest;

parameter vHhx_sumtest[t]; vHhx_sumtest[t]$tx0[t] = vHhx.l[aTot,t] - sum(a, vHhx.l[a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vHhx_sumtest[t])) > 0.02) "vHhx[tot] does not match sum of components", vHhx_sumtest;
abort$(smax(t$(tForecast[t]), abs(vHhx_sumtest[t])) > 1e-9) "vHhx[tot] does not match sum of components in forecast", vHhx_sumtest;

parameter vHhx_h_sumtest[t]; vHhx_h_sumtest[t]$tx0[t] = sum(h, vHhx_h.l[h,aTot,t]) - sum((a,h), vHhx_h.l[h,a,t] * rHhAndel.l[h] * nPop.l[a,t]);
abort$(smax(t, abs(vHhx_h_sumtest[t])) > 0.02) "vHhx_h[jTot,tot] does not match sum of components", vHhx_h_sumtest;
abort$(smax(t$(tForecast[t]), abs(vHhx_h_sumtest[t])) > 1e-9) "vHhx_h[jTot,tot] does not match sum of components in forecast", vHhx_h_sumtest;

parameter vHhNFErest_sumtest[t]; vHhNFErest_sumtest[t]$tx0[t] = vHhNFErest.l[aTot,t] - sum(a, vHhNFErest.l[a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vHhNFErest_sumtest[t])) > 1e-7) "vHhNFErest_tot does not match sum of vHhNFErest[#a]", vHhNFErest_sumtest;

# Normalt skal sum-aggregeringer stemme eksakt - men ikke her, da jvHhxAfk fordelt på alder sættes for at ramme vHhx,
# så fanges residualen i vHhx i vHhxAfk[a,t], men ikke i vHhxAfk[aTot,t] som er givet af data.
# t2 stemmer heller ikke eksakt, da vi her rykker vHhx på plads via vHhx[aTot,t] =E= sum(a, vHhx[a,t] * nPop[a,t])
parameter vHhxAfk_sumtest[t]; vHhxAfk_sumtest[t]$tx0[t] = vHhxAfk.l[aTot,t] - sum(a, vHhxAfk.l[a,t]/fMigration.l[a,t] * nPop.l[a-1,t-1]);
abort$(smax(t, abs(vHhxAfk_sumtest[t])) > 0.02) "vHhxAfk[tot] does not match sum of components", vHhxAfk_sumtest;
abort$(smax(t$(tForecast[t] and not t2[t]), abs(vHhxAfk_sumtest[t])) > 1e-9) "vHhxAfk[tot] does not match sum of components in forecast", vHhxAfk_sumtest;

# ------------------------------------------------------------------------------------------------------------------
# Forbrug
# ------------------------------------------------------------------------------------------------------------------

parameter vC_NR_h_sumtest[t]; vC_NR_h_sumtest[t]$tx0[t] = sum(h, vC_NR_h.l[h,aTot,t]) - sum((a,h), rHhAndel.l[h] * vC_NR_h.l[h,a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vC_NR_h_sumtest[t])) > 1e-7) "vC_NR_h[jTot,aTot] does not match sum of components", vC_NR_h_sumtest;

# ------------------------------------------------------------------------------------------------------------------
# Overførsler mellem kohorter
# ------------------------------------------------------------------------------------------------------------------
parameter vArv_test[t]; vArv_test[t]$tx0[t] = sum(a, vArv.l[a,t] * nPop.l[a,t]) - vArv.l[aTot,t];
abort$(smax(t, abs(vArv_test[t])) > 1e-7) "Arv pr aldersgruppe summerer ikke til total.", vArv_test;

parameter vBoernFraHh_test[t]; vBoernFraHh_test[t]$tx0[t] = sum(a, vBoernFraHh.l[a,t] * nPop.l[a,t]) - sum(aa, vHhTilBoern.l[aa,t] * nPop.l[aa,t]);
abort$(smax(t, abs(vBoernFraHh_test[t])) > 1e-7) "Transfers received by children do not match transfers paid by parents.", vBoernFraHh_test;

abort$(smax(t$tx0[t],
        abs(sum(a$(a.val < 18), vBoernFraHh.l[a,t] * nPop.l[a,t]) - sum(aa, vHhTilBoern.l[aa,t] * nPop.l[aa,t]))
      ) > 1e-9) "Transfers received by children do not match transfers paid by parents.";

# ------------------------------------------------------------------------------------------------------------------
# vHh
# ------------------------------------------------------------------------------------------------------------------
parameter vHhAkt_sumtest[portf_,t];
parameter vHhPas_sumtest[portf_,t];
vHhPas_sumtest['RealKred',t]$tx0[t] = vHhPas.l['RealKred',aTot,t] - sum(a, vHhPas.l['RealKred',a,t] * nPop.l[a,t]);
vHhPas_sumtest['Bank',t]$tx0[t] = vHhPas.l['Bank',aTot,t] - sum(a, vHhPas.l['Bank',a,t] * nPop.l[a,t]);
vHhAkt_sumtest['pensTot',t]$tx0[t] = vHhAkt.l['pensTot',aTot,t] - sum(a, vHhAkt.l['pensTot',a,t] * nPop.l[a,t]);
vHhAkt_sumtest[portf,t]$tx0[t] = vHhAkt.l[portf,aTot,t] - sum(a, vHhAkt.l[portf,a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vHhPas_sumtest['RealKred',t])) > 1e-7) "vHhPas[RealKred,tot] does not match sum of components", vHhPas_sumtest;
abort$(smax(t, abs(vHhAkt_sumtest['Bank',t])) > 1e-4) "vHhPas[Bank,tot] does not match sum of components", vHhPas_sumtest;
abort$(smax(portf, smax(t, abs(vHhAkt_sumtest[portf,t]))) > 1e-6) "vHhAkt[#akt,tot] does not match sum of components", vHhAkt_sumtest;

# ------------------------------------------------------------------------------------------------------------------
# Labor_market
# ------------------------------------------------------------------------------------------------------------------
parameter nLHh_sumtest[t]; nLHh_sumtest[t]$tx0[t] = sum(a, nLHh.l[a,t]) - nLHh.l[aTot,t];
abort$(smax(t, abs(nLHh_sumtest[t])) > 1e-6) "nLHh summerer ikke til total.", nLHh_sumtest;

parameter nSoeg_sumtest[t]; nSoeg_sumtest[t]$tx0[t] = sum(a, nSoegHh.l[a,t]) - nSoegHh.l[aTot,t];
abort$(smax(t, abs(nSoeg_sumtest[t])) > 1e-6) "nSoegHh summerer ikke til total.", nSoeg_sumtest;

parameter nSoegBase_sumtest[t]; nSoegBase_sumtest[t]$tx0[t] = sum(a, nSoegBaseHh.l[a,t]) - nSoegBaseHh.l[aTot,t];
abort$(smax(t, abs(nSoegBase_sumtest[t])) > 1e-6) "nSoegBaseHh summerer ikke til total.", nSoegBase_sumtest;

# ------------------------------------------------------------------------------------------------------------------
# Government Expenses
# ------------------------------------------------------------------------------------------------------------------
parameter vPensIndbOP_sumtest[t]; vPensIndbOP_sumtest[t]$tx0[t] = vPensIndbOP.l[aTot,t] - sum(a, vPensIndbOP.l[a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vPensIndbOP_sumtest[t])) > 1e-9) "vPensIndbOP[aTot] does not match sum of age groups", vPensIndbOP_sumtest;

# ------------------------------------------------------------------------------------------------------------------
# Government Revenues
# ------------------------------------------------------------------------------------------------------------------
parameter vtEjd_test[t]; vtEjd_test[t]$tx0[t] = sum(a, vBolig.l[a-1,t-1]/fv * fMigration.l[a,t] * nPop.l[a,t] 
                                                     + vBolig.l[a-1,t-1]/fv * (1-rOverlev.l[a-1,t-1]) * nPop.l[a-1,t-1]) 
                                                * tEjd.l[t] - vtEjd.l[aTot,t];
abort$(smax(t, abs(vtEjd_test[t])) > 1e-7) "Ejendomsskatter pr aldersgruppe summerer ikke til total.", vtEjd_test;



# ------------------------------------------------------------------------------------------------------------------
# Struk
# ------------------------------------------------------------------------------------------------------------------
parameter snLHh_sumtest[t]; snLHh_sumtest[t]$tx0[t] = sum(a, snLHh.l[a,t]) - snLHh.l[aTot,t];
abort$(smax(t, abs(snLHh_sumtest[t])) > 1e-6) "Strukturel beskæftigelse summerer ikke til total.", snLHh_sumtest;

parameter snSoegHh_sumtest[t]; snSoegHh_sumtest[t]$tx0[t] = sum(a, snSoegHh.l[a,t]) - snSoegHh.l[aTot,t];
abort$(smax(t, abs(snSoegHh_sumtest[t])) > 1e-6) "Strukturel nSoegHh summerer ikke til total.", snSoegHh_sumtest;

parameter snSoegBaseHh_sumtest[t]; snSoegBaseHh_sumtest[t]$tx0[t] = sum(a, snSoegBaseHh.l[a,t]) - snSoegBaseHh.l[aTot,t];
abort$(smax(t, abs(snSoegBaseHh_sumtest[t])) > 1e-6) "Strukturel nSoegBaseHh summerer ikke til total.", snSoegBaseHh_sumtest;


# ------------------------------------------------------------------------------------------------------------------
# Sociogrupper 
# ------------------------------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------------------------------
# Aggregering af fremadskuende og hand-to-mouth-husholdninger
# ------------------------------------------------------------------------------------------------------------------
parameter vHhx_h_test[a,t]; vHhx_h_test[a,t]$(tx0[t]) = sum(h, rHhAndel.l[h] * vHhx_h.l[h,a,t]) - vHhx.l[a,t];
abort$(smax([a,t], abs(vHhx_h_test[a,t])) > 1e-9) "vHhx_h do not sum to vHhx", vHhx_h_test;

parameter vHhx_tot_h_test[t]; vHhx_tot_h_test[t]$(tx0[t]) = sum(h, vHhx_h.l[h,aTot,t]) - vHhx.l[aTot,t];
abort$(smax(t, abs(vHhx_tot_h_test[t])) > 1e-9) "vHhx_h_aTot do not sum to vHhx", vHhx_tot_h_test;

parameter vHhx_tot_test[t]; vHhx_tot_test[t]$(tx0[t]) = vHhx.l[aTot,t] - (vHhNet.l[t] - vHhAkt.l['pensTot',aTot,t] + vHhPas.l['RealKred',aTot,t]);
abort$(smax(t, abs(vHhx_tot_test[t])) > 1e-7) "vHhx does not match tot-Pens+RealKred", vHhx_tot_test;
