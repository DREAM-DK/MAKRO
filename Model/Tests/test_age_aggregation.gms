# ======================================================================================================================
# Alders-aggregerings tests
# ======================================================================================================================
# ------------------------------------------------------------------------------------------------------------------
# Pension
# ------------------------------------------------------------------------------------------------------------------
parameter vHhPensIndb_sumtest[portf_,t]; vHhPensIndb_sumtest[pens,t]$(tx0[t] and t.val >= 1994) = vHhPensIndb.l[pens,aTot,t] - sum(a, vHhPensIndb.l[pens,a,t] * nPop.l[a,t]);
abort$(smax(pens, smax(t, abs(vHhPensIndb_sumtest[pens,t]))) > 1e-7) "vHhPensIndb[#pens,tot] does not match sum of components", vHhPensIndb_sumtest;

parameter vHhPensAfk_sumtest[pens,t]; vHhPensAfk_sumtest[pens,t]$tx0[t] = vHhPensAfk.l[pens,aTot,t] - sum(a, vHhPensAfk.l[pens,a,t] * nPop.l[a-1,t-1]);
abort$(smax([pens,t], abs(vHhPensAfk_sumtest[pens,t])) > 1e-4) "Aldersfordelt vHhPensAfk summerer ikke til total.", vHhPensAfk_sumtest;

parameter jvHhPensAfk_sumtest[pens,t]; jvHhPensAfk_sumtest[pens,t]$tx0[t] = jvHhPensAfk.l[pens,aTot,t] - sum(a, jvHhPensAfk.l[pens,a,t] * nPop.l[a-1,t-1]);
abort$(smax([pens,t], abs(jvHhPensAfk_sumtest[pens,t])) > 1e-7) "jvHhPensAfk_tot does not match sum of jvHhPensAfk[#a]", jvHhPensAfk_sumtest;

# ------------------------------------------------------------------------------------------------------------------
# HH indkomst
# ------------------------------------------------------------------------------------------------------------------
parameter vHhxAfk_sumtest[t]; vHhxAfk_sumtest[t]$tx0[t] = vHhxAfk.l[aTot,t] - sum(a, vHhxAfk.l[a,t] * nPop.l[a-1,t-1]);
abort$(smax(t, abs(vHhxAfk_sumtest[t])) > 1e-5) "vHhxAfk[tot] does not match sum of components", vHhxAfk_sumtest;

parameter vOvf_sumtest[t]; vOvf_sumtest[t]$tx0[t] = vOvf.l['hh',t] - sum(a, vHhOvf.l[a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vOvf_sumtest[t])) > 1e-7) "vOvf[hh] does not match sum of vHhOvf[#a]", vOvf_sumtest;

parameter vHhNFErest_sumtest[t]; vHhNFErest_sumtest[t]$tx0[t] = vHhNFErest.l[aTot,t] - sum(a, vHhNFErest.l[a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vHhNFErest_sumtest[t])) > 1e-6) "vHhNFErest[tot] does not match sum of components", vHhNFErest_sumtest;

parameter vtHhx_sumtest[t]; vtHhx_sumtest[t]$tx0[t] = vtHhx.l[aTot,t] - sum(a, vtHhx.l[a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vtHhx_sumtest[t])) > 1e-4) "vtHhx[tot] does not match sum of components", vtHhx_sumtest;

parameter vHhInd_sumtest[t]; vHhInd_sumtest[t]$tx0[t] = vHhInd.l[aTot,t] - sum(a, vHhInd.l[a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vHhInd_sumtest[t])) > 1e-6) "vHhInd[tot] does not match sum of components", vHhInd_sumtest;

parameter vHhFinAkt_sumtest[t]; vHhFinAkt_sumtest[t]$tx0[t] = sum(a, nPop.l[a,t] * vHhFinAkt.l[a,t])-vHh.l['Bank',atot,t]-vHh.l['IndlAktier',atot,t]-vHh.l['UdlAktier',atot,t]-vHh.l['obl',atot,t];
abort$(smax(t, abs(vHhFinAkt_sumtest[t])) > 1e-6) "vHhFinAkt does not match sum of components", vHhFinAkt_sumtest;

parameter vHhx_sumtest[t]; vHhx_sumtest[t]$tx0[t] = vHhx.l[aTot,t] - sum(a, vHhx.l[a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vHhx_sumtest[t])) > 1e-7) "vHhx[tot] does not match sum of components", vHhx_sumtest;

parameter vHhxR_sumtest[t]; vHhxR_sumtest[t]$tx0[t] = vHhxR.l[aTot,t] - sum(a, vHhxR.l[a,t] * (1-rHtM.l) * nPop.l[a,t]);
abort$(smax(t, abs(vHhxR_sumtest[t])) > 1e-4) "vHhxR[tot] does not match sum of components", vHhxR_sumtest;

parameter vHhxHtM_sumtest[t]; vHhxHtM_sumtest[t]$tx0[t] = vHhxHtM.l[aTot,t] - sum(a, vHhxHtM.l[a,t] * rHtM.l * nPop.l[a,t]);
abort$(smax(t, abs(vHhxHtM_sumtest[t])) > 1e-4) "vHhxHtM[tot] does not match sum of components", vHhxHtM_sumtest;

parameter vRealiseretAktieOmv_sumtest[t]; vRealiseretAktieOmv_sumtest[t]$tx0[t] = vRealiseretAktieOmv.l[aTot,t] - sum(a, vRealiseretAktieOmv.l[a,t] * nPop.l[a-1,t-1]);
abort$(smax(t, abs(vRealiseretAktieOmv_sumtest[t])) > 1e-4) "vRealiseretAktieOmv[tot] does not match sum of components", vRealiseretAktieOmv_sumtest;

parameter jvHhxAfk_sumtest[t]; jvHhxAfk_sumtest[t]$tx0[t] = jvHhxAfk.l[aTot,t] - sum(a, jvHhxAfk.l[a,t] * nPop.l[a-1,t-1]);
abort$(smax(t, abs(jvHhxAfk_sumtest[t])) > 1e-7) "jvHhxAfk_tot does not match sum of jvHhxAfk[#a]", jvHhxAfk_sumtest;

parameter vHhNFErest_sumtest[t]; vHhNFErest_sumtest[t]$tx0[t] = vHhNFErest.l[aTot,t] - sum(a, vHhNFErest.l[a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vHhNFErest_sumtest[t])) > 1e-7) "vHhNFErest_tot does not match sum of vHhNFErest[#a]", vHhNFErest_sumtest;

# ------------------------------------------------------------------------------------------------------------------
# Forbrug
# ------------------------------------------------------------------------------------------------------------------
parameter vCR_NR_sumtest[t]; vCR_NR_sumtest[t]$tx0[t] = vCR_NR.l[aTot,t] - sum(a, (1-rHtM.l) * vCR_NR.l[a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vCR_NR_sumtest[t])) > 1e-7) "vCR_NR[aTot] does not match sum of components", vCR_NR_sumtest;

parameter vCHtM_NR_sumtest[t]; vCHtM_NR_sumtest[t]$tx0[t] = vCHtM_NR.l[aTot,t] - sum(a, rHtM.l * vCHtM_NR.l[a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vCHtM_NR_sumtest[t])) > 1e-7) "vCHtM_NR[aTot] does not match sum of components", vCHtM_NR_sumtest;

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
parameter vHh_sumtest[portf_,t];
vHh_sumtest['NetFin',t]$tx0[t] = vHh.l['NetFin',aTot,t] - sum(a, vHh.l['NetFin',a,t] * nPop.l[a,t]);
vHh_sumtest['RealKred',t]$tx0[t] = vHh.l['RealKred',aTot,t] - sum(a, vHh.l['RealKred',a,t] * nPop.l[a,t]);
vHh_sumtest['BankGaeld',t]$tx0[t] = vHh.l['BankGaeld',aTot,t] - sum(a, vHh.l['BankGaeld',a,t] * nPop.l[a,t]);
vHh_sumtest['Pens',t]$tx0[t] = vHh.l['Pens',aTot,t] - sum(a, vHh.l['Pens',a,t] * nPop.l[a,t]);
vHh_sumtest[akt,t]$tx0[t] = vHh.l[akt,aTot,t] - sum(a, vHh.l[akt,a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vHh_sumtest['NetFin',t])) > 1e-4) "vHh[NetFin,tot] does not match sum of components", vHh_sumtest;
abort$(smax(t, abs(vHh_sumtest['RealKred',t])) > 1e-7) "vHh[RealKred,tot] does not match sum of components", vHh_sumtest;
abort$(smax(t, abs(vHh_sumtest['BankGaeld',t])) > 1e-4) "vHh[BankGaeld,tot] does not match sum of components", vHh_sumtest;
abort$(smax(pens, smax(t, abs(vHh_sumtest[pens,t]))) > 1e-7) "vHh[#pens,tot] does not match sum of components", vHh_sumtest;
abort$(smax(akt, smax(t, abs(vHh_sumtest[akt,t]))) > 1e-6) "vHh[#akt,tot] does not match sum of components", vHh_sumtest;

parameter vHhFinAkt_sumtest[t]; vHhFinAkt_sumtest[t]$tx1[t] = vHhFinAkt.l[aTot,t] - sum(a, vHhFinAkt.l[a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vHhFinAkt_sumtest[t])) > 1e-7) "vHhFinAkt[tot] does not match sum of components", vHhFinAkt_sumtest;

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
abort$(smax(t$tx1[t], 
        abs(vHhFinAkt.l[aTot,t] - sum(a, vHhFinAkt.l[a,t] * nPop.l[a,t]))
      ) > 1e-7) "vHhFinAkt[tot] does not match sum of components";
