# ------------------------------------------------------------------------------------------------------------------
# Betalingsbalance
# ------------------------------------------------------------------------------------------------------------------
parameter betalingsbalance[t]; betalingsbalance[t]$(tx0[t] and t.val >= 1996) =
  # Nettofordringserhvervelse (Tfn_e)                           
    vUdlNFE.l[t]
  # Net exports = Exports - Imports -(M-E)
  + vX.l[xTot,t] - vM.l[sTot,t] 
  # Wages going to foreign cross-border workers and undeclared work -(Ywn_e)
  - vWxDK.l[t]
  # Customs going to EU and subsidies from EU -(Spteu - Spueu)
  - vtEU.l[t] + vSubEU.l[t]
  # Net foreign return excl. capital gains -(Tin_e)
  - vUdlRenter.l[t]
  # Net foreign transfer to government -(Tr_o_e-Tr_e_o+tK_o_e-tK_e_o)   
  + vOffFraUdlKap.l[t] +vOffFraUdlEU.l[t] + vOffFraUdlRest.l[t] - vOffTilUdl.l[t]
  # Overførsler til pensionister i udlandet
  - vOvf.l['UdlFortid',t] - vOvf.l['UdlPens',t]
  # Residual foreign transfer to households
  # Rest: Syn_e + Tpc_h_e - Tpc_e_z + (Ty_o_e + Typc_cf_e-Typc_e_h) + (Tr_hc_e - Tr_e_hc) + (Tknr_e) - Ikn_e - Izn_e  
  - vhhTilUdl.l[t]
  + vVirkIndRest.l[t]
  # Fejl i 2016 betyder, at der er en kæmpe overførsel fra et ukendt sted - det er ikke i betalingsbalancen
  + jrOmv_IndlAktier.l[t]*(vAktie.l[t-1]/fv)
;
abort$(smax(t$(tData[t]), abs(betalingsbalance[t])) > 0.15) "Fejl i betalingsbalancen", betalingsbalance;
# Dette test er midlertidigt hævet - hvis fortsat fejl > 0.025 på nyeste databank kontakt ADAM-gruppen
abort$(smax(t$(tForecast[t]), abs(betalingsbalance[t])) > 0.001) "Fejl i betalingsbalancen", betalingsbalance;

# ------------------------------------------------------------------------------------------------------------------
# Produktionsfunktion
# ------------------------------------------------------------------------------------------------------------------
parameter test_qKL[sp,t], test_qKLB[sp,t], test_qKLBR[sp,t];

test_qKLBR[sp,t]$(tx0[t] and eKLBR.l[sp]>0) = ( (uR.l[sp,t])**(1/eKLBR.l[sp]) * qR.l[sp,t]**(1-1/eKLBR.l[sp])
                 + (uKLB.l[sp,t])**(1/eKLBR.l[sp]) * qKLB.l[sp,t]**(1-1/eKLBR.l[sp]) )**(1/(1-1/eKLBR.l[sp]))
                 - qKLBR.l[sp,t];
                 
test_qKLB[sp,t]$(tx0[t] and eKLB.l[sp]>0) = ( (uK.l['iB',sp,t])**(1/eKLB.l[sp]) * (qKUdn.l['iB',sp,t])**(1-1/eKLB.l[sp])
                + (uKL.l[sp,t])**(1/eKLB.l[sp]) * qKL.l[sp,t]**(1-1/eKLB.l[sp]) )**(1/(1-1/eKLB.l[sp]))
                - qKLB.l[sp,t];

test_qKL[sp,t]$(tx0[t] and eKL.l[sp]>0) = ( (uK.l['iM',sp,t])**(1/eKL.l[sp]) * (qKUdn.l['iM',sp,t])**(1-1/eKL.l[sp])
               + (uL.l[sp,t])**(1/eKL.l[sp]) * (qL.l[sp,t])**(1-1/eKL.l[sp]) )**(1/(1-1/eKL.l[sp]))
               - qKL.l[sp,t];

test_qKLBR[sp,t]$(tx0[t] and eKLBR.l[sp]=0)
  = qR.l[sp,t] / uR.l[sp,t] + qKLB.l[sp,t] / uKLB.l[sp,t] - 2 * qKLBR.l[sp,t];
test_qKLB[sp,t]$(tx0[t] and eKLB.l[sp]=0)
  = qKUdn.l['iB',sp,t] / uK.l['iB',sp,t] + qKL.l[sp,t] / uKL.l[sp,t] - 2 * qKLB.l[sp,t];
test_qKL[sp,t]$(tx0[t] and eKL.l[sp]=0 and d1K['iM',sp,t])
  = qKUdn.l['iM',sp,t] / uK.l['iM',sp,t]
  + qL.l[sp,t] / uL.l[sp,t]
  - 2 * qKL.l[sp,t];
test_qKL[sp,t]$(tx0[t] and not d1K['iM',sp,t]) =
  qL.l[sp,t] / uL.l[sp,t] - qKL.l[sp,t];

abort$(smax([sp,t], abs(test_qKLBR[sp,t])) > 1e-6) "KLBR stemmer ikke med produktionsfunktion", test_qKLBR;
abort$(smax([sp,t], abs(test_qKLB[sp,t])) > 1e-6) "KLB stemmer ikke med produktionsfunktion", test_qKLB;
abort$(smax([sp,t], abs(test_qKL[sp,t])) > 1e-6) "KL stemmer ikke med produktionsfunktion", test_qKL;

parameter test_qYBolig[t];
test_qYBolig[t]$(tx0[t]) = (   (uLand.l[t])**(1/eBolig.l) * qLandSalg.l[t]**(1-1/eBolig.l)
                             + (uIBolig.l[t])**(1/eBolig.l) * (qIBolig.l[t])**(1-1/eBolig.l)
                           )**(1/(1-1/eBolig.l)) - qYBolig.l[t];
abort$(smax([t], abs(test_qYBolig[t])) > 1e-6) "qYBolig stemmer ikke med produktionsfunktion", test_qYBolig;

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