# ======================================================================================================================
# Aggregerings tests
# ======================================================================================================================
# ------------------------------------------------------------------------------------------------------------------
# Pension
# ------------------------------------------------------------------------------------------------------------------
parameter vPensIndb_sumtest[portf_,t]; vPensIndb_sumtest[pens,t]$tx0[t] = vPensIndb.l[pens,aTot,t] - sum(a, vPensIndb.l[pens,a,t] * nPop.l[a,t]);
abort$(smax(pens, smax(t, abs(vPensIndb_sumtest[pens,t]))) > 1e-7) "vPensIndb[#pens,tot] does not match sum of components", vPensIndb_sumtest;

parameter vHhPensAfk_sumtest[pens,t]; vHhPensAfk_sumtest[pens,t]$tx0[t] = vHhPensAfk.l[pens,aTot,t] - sum(a, vHhPensAfk.l[pens,a,t] * nPop.l[a-1,t-1]);
abort$(smax([pens,t], abs(vHhPensAfk_sumtest[pens,t])) > 1e-4) "Aldersfordelt vHhPensAfk summerer ikke til total.", vHhPensAfk_sumtest;


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

parameter vUdlRenter_sumtest[t]; vUdlRenter_sumtest[t]$tx1[t] = vUdlRenter.l[t] + vVirkRenter.l[t] + vHhRenter.l['NetFin',t] + vNROffNetRenter.l[t];
abort$(smax(t, abs(vUdlRenter_sumtest[t])) > 0.01) "vUdlRenter does not match sum of components", vUdlRenter_sumtest;

parameter vUdlOmv_sumtest[t]; vUdlOmv_sumtest[t]$tx0[t] = vUdlOmv.l[t] + vHhOmv.l['NetFin',t] + vVirkOmv.l[t] + vOffOmv.l[t] - vVirk.l['Guld',t] + vVirk.l['Guld',t-1]/fv;
abort$(smax(t, abs(vUdlOmv_sumtest[t])) > 0.01) "vUdlOmv does not match sum of components", vUdlOmv_sumtest;

parameter vHhInd_sumtest[t]; vHhInd_sumtest[t]$tx0[t] = vHhInd.l[aTot,t] - sum(a, vHhInd.l[a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vHhInd_sumtest[t])) > 1e-6) "vHhInd[tot] does not match sum of components", vHhInd_sumtest;

parameter vHhFinAkt_sumtest[t]; vHhFinAkt_sumtest[t]$tx0[t] = sum(a, nPop.l[a,t] * vHhFinAkt.l[a,t])-vHh.l['Bank',atot,t]-vHh.l['IndlAktier',atot,t]-vHh.l['UdlAktier',atot,t]-vHh.l['obl',atot,t];
abort$(smax(t, abs(vHhFinAkt_sumtest[t])) > 1e-6) "vHhFinAkt does not match sum of components", vHhFinAkt_sumtest;

abort$(smax(t, abs(jvHhNFErest.l[aTot,t])) > 0.005) "jvHhNFErest does not sum to 0", jvHhNFErest.l;

parameter vHhx_sumtest[t]; vHhx_sumtest[t]$tx0[t] = vHhx.l[aTot,t] - sum(a, vHhx.l[a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vHhx_sumtest[t])) > 1e-4) "vHhx[tot] does not match sum of components", vHhx_sumtest;

parameter jvHhx_sumtest[t]; jvHhx_sumtest[t]$tx0[t] = jvHhx.l[aTot,t] - sum(a, jvHhx.l[a,t] * nPop.l[a,t]);
abort$(smax(t, abs(jvHhx_sumtest[t])) > 1e-4) "jvHhx[tot] does not match sum of components - i.e. E_jvHhx_aTot not consistent with E_vHhx_aTot", jvHhx_sumtest;

abort$(smax(t, abs(jvHh.l[t])) > 1e-3) "Top-down og buttom-up bestemmelse af vHh[NetFin,tot] stemmer ikke.", jvHh.l;

parameter vRealiseretAktieOmv_sumtest[t]; vRealiseretAktieOmv_sumtest[t]$tx0[t] = vRealiseretAktieOmv.l[aTot,t] - sum(a, vRealiseretAktieOmv.l[a,t] * nPop.l[a,t]);
abort$(smax(t, abs(vRealiseretAktieOmv_sumtest[t])) > 1e-4) "vRealiseretAktieOmv[tot] does not match sum of components", vRealiseretAktieOmv_sumtest;

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

parameter nL_sumtest[t]; nL_sumtest[t]$tx0[t] = sum(s, nL.l[s,t]) - nL.l[sTot,t];
abort$(smax(t, abs(nL_sumtest[t])) > 1e-6) "nL summerer ikke til total.", nL_sumtest;

parameter nSoeg_sumtest[t]; nSoeg_sumtest[t]$tx0[t] = sum(a, nSoegHh.l[a,t]) - nSoegHh.l[aTot,t];
abort$(smax(t, abs(nSoeg_sumtest[t])) > 1e-6) "nSoegHh summerer ikke til total.", nSoeg_sumtest;

parameter nSoegBase_sumtest[t]; nSoegBase_sumtest[t]$tx0[t] = sum(a, nSoegBaseHh.l[a,t]) - nSoegBaseHh.l[aTot,t];
abort$(smax(t, abs(nSoegBase_sumtest[t])) > 1e-6) "nSoegBaseHh summerer ikke til total.", nSoegBase_sumtest;

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
abort$(smax(t$tx0[t], 
        abs(1 - sum(soc_$besktot[soc_], dSoc2dBesk.l[soc_,t]))
      ) > 1e-7) "dSoc2dBesk[besktot] does sum to 1";

abort$(smax(t$tx0[t], 
        abs(sum(soc, dSoc2dBesk.l[soc,t]))
      ) > 1e-7) "dSoc2dBesk[tot] does not sum to 0";

abort$(smax(t$tx1[t], 
        abs(vHhFinAkt.l[aTot,t] - sum(a, vHhFinAkt.l[a,t] * nPop.l[a,t]))
      ) > 1e-7) "vHhFinAkt[tot] does not match sum of components";


# ------------------------------------------------------------------------------------------------------------------
# Betalingsbalance
# ------------------------------------------------------------------------------------------------------------------
parameter betalingsbalance[t]; betalingsbalance[t]$tx1[t] =
  # Nettofordringserhvervelse (Tfn_e)                           
    vUdlNFE.l[t]
  # Net exports = Exports - Imports -(M-E)
  + vX.l[xTot,t] - vM.l[sTot,t] 
  # Wages going to foreign cross-border workers and undeclared work -(Ywn_e)
  - vWUdl.l[t]
  # Customs going to EU and subsidies from EU -(Spteu - Spueu)
  - vtEU.l[t] + vSubEU.l[t]
  # Net foreign return excl. capital gains -(Tin_e)
  - vUdlRenter.l[t]
  # Net foreign transfer to government -(Tro_e-Tre_o+tK_o_e-tK_e_o)   
  + vOffFraUdl.l[t] - vOffTilUdl.l[t]
  # Overførsler til pensionister i udlandet
  - vOvf.l['UdlFortid',t] - vOvf.l['UdlPens',t]
  # Residual foreign transfer to households
  # Rest: Syn_e + Tpc_h_e - Tpc_e_z + (Ty_o_e + Typc_cf_e-Typc_e_h) + (Tr_hc_e - Tr_e_hc) + (Tknr_e) - Ikn_e - Izn_e  
  - vhhTilUdl.l[t]
  + jvHhNFErest.l[aTot,t]
  + vVirkIndRest.l[t]
;
abort$(smax(t, abs(betalingsbalance[t])) > 0.015) "Fejl i betalingsbalancen", betalingsbalance;


# ------------------------------------------------------------------------------------------------------------------
# Produktionsfunktion
# ------------------------------------------------------------------------------------------------------------------
parameter test_qKL[sp,t], test_qKLB[sp,t], test_qKLBR[sp,t];

test_qKLBR[sp,t]$(tx0[t] and eKLBR.l[sp]>0) = ( (uR.l[sp,t])**(1/eKLBR.l[sp]) * qR.l[sp,t]**(1-1/eKLBR.l[sp])
                 + (uKLB.l[sp,t])**(1/eKLBR.l[sp]) * qKLB.l[sp,t]**(1-1/eKLBR.l[sp]) )**(1/(1-1/eKLBR.l[sp]))
                 - qKLBR.l[sp,t];

test_qKLB[sp,t]$(tx0[t] and eKLB.l[sp]>0) = ( (uK.l['iB',sp,t])**(1/eKLB.l[sp]) * (rKUdn.l['iB',sp,t] * qK.l['iB',sp,t-1]/fq)**(1-1/eKLB.l[sp])
                + (uKL.l[sp,t])**(1/eKLB.l[sp]) * qKL.l[sp,t]**(1-1/eKLB.l[sp]) )**(1/(1-1/eKLB.l[sp]))
                - qKLB.l[sp,t];

test_qKL[sp,t]$(tx0[t] and eKL.l[sp]>0) = ( (uK.l['iM',sp,t])**(1/eKL.l[sp]) * (rKUdn.l['iM',sp,t] * qK.l['iM',sp,t-1]/fq)**(1-1/eKL.l[sp])
               + (uL.l[sp,t])**(1/eKL.l[sp]) * (qL.l[sp,t])**(1-1/eKL.l[sp]) )**(1/(1-1/eKL.l[sp]))
               - qKL.l[sp,t];

test_qKLBR[sp,t]$(tx0[t] and eKLBR.l[sp]=0)
  = qR.l[sp,t] / uR.l[sp,t] + qKLB.l[sp,t] / uKLB.l[sp,t] - 2 * qKLBR.l[sp,t];
test_qKLB[sp,t]$(tx0[t] and eKLB.l[sp]=0)
  = qK.l['iB',sp,t-1]/fq * rKUdn.l['iB',sp,t] / uK.l['iB',sp,t] + qKL.l[sp,t] / uKL.l[sp,t] - 2 * qKLB.l[sp,t];
test_qKL[sp,t]$(tx0[t] and eKL.l[sp]=0 and d1K['iM',sp,t])
  = qK.l['iM',sp,t-1]/fq * rKUdn.l['iM',sp,t] / uK.l['iM',sp,t]
  + qL.l[sp,t] / uL.l[sp,t]
  - 2 * qKL.l[sp,t];
test_qKL[sp,t]$(tx0[t] and not d1K['iM',sp,t]) =
  qL.l[sp,t] / uL.l[sp,t] - qKL.l[sp,t];

abort$(smax([sp,t], abs(test_qKLBR[sp,t])) > 1e-6) "KLBR stemmer ikke med produktionsfunktion", test_qKLBR;
abort$(smax([sp,t], abs(test_qKLB[sp,t])) > 1e-6) "KLB stemmer ikke med produktionsfunktion", test_qKLB;
abort$(smax([sp,t], abs(test_qKL[sp,t])) > 1e-6) "KL stemmer ikke med produktionsfunktion", test_qKL;

# ------------------------------------------------------------------------------------------------------------------
# Finance
# ------------------------------------------------------------------------------------------------------------------
parameter vEBITDA_sumtest[t]; vEBITDA_sumtest[t]$tx0[t] = sum(s, vEBITDA.l[s,t]) - vEBITDA.l[sTot,t];
abort$(smax(t, abs(vEBITDA_sumtest[t])) > 1e-6) "vEBITDA summerer ikke til total.", vEBITDA_sumtest;

parameter vFCF_sumtest[t]; vFCF_sumtest[t]$tx0[t] = sum(s, vFCF.l[s,t]) - vFCF.l[sTot,t];
abort$(smax(t, abs(vFCF_sumtest[t])) > 1e-6) "vFCF summerer ikke til total.", vFCF_sumtest;

# ------------------------------------------------------------------------------------------------------------------
# Negative tal
# ------------------------------------------------------------------------------------------------------------------
#  $GROUP G_negative_allowed
#    vVirkNFE
#  ;
#  $GROUP G_no_negatives G_prices, G_quantities, G_values, -G_negative_allowed;
#  $GROUP G_no_negatives G_no_negatives$(tx0[t]);
#  $LOOP G_no_negatives:
#    abort$sum({sets}${conditions}, {name}.l{sets} < 0) "{name} er negativ", {name}.l;
#  $ENDLOOP