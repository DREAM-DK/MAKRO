# ------------------------------------------------------------------------------------------------------------------
# Betalingsbalance
# ------------------------------------------------------------------------------------------------------------------
abort$(smax(t$(t.val > %NettoFin_t1%), abs(jvUdlNFE.l[t])) > 0.05) "jvUdlNFE er ikke 0", jvUdlNFE.l;
abort$(smax(t$(t.val > %cal_end%+1), abs(jvUdlNFE.l[t])) > 1e-7) "jvUdlNFE er ikke 0 i fremskrivning", jvUdlNFE.l;

parameter fordringsbalance[t]; fordringsbalance[t]$(tx0[t] and t.val >= 1996) =
  # Nettofordringserhvervelse (Tfn_e)                           
    vUdlNFE.l[t]
  # Net exports = Exports - Imports -(M-E)
  + vX.l[xTot,t] - vM.l[sTot,t] 
  # Wages going to foreign cross-border workers and undeclared work -(Ywn_e)
  - vWxDK.l[t]
  # Customs going to EU and subsidies from EU -(Spteu - Spueu)
  - vtEU.l[t] + vSubEU.l[t]
  # Net foreign return excl. capital gains -(Tin_e)
  - vUdlNetRenter.l[t]
  # Net foreign transfer to government -(Tr_o_e+tK_o_e - Tr_e_o - tK_e_o)   
  - vOffTilUdl.l[t] + vOffFraUdlKap.l[t] + vOffFraUdlEU.l[t] + vOffFraUdlRest.l[t]
  # Overførsler til pensionister i udlandet
  - sum(ovfUdl, vOvf.l[ovfUdl,t])
  # Residual foreign transfer to households
  # Rest: Syn_e + Tpc_h_e - Tpc_e_z + (Typc_cf_e-Typc_e_h) + (Tr_hc_e - Tr_e_hc) + (Tknr_e) - Ikn_e - Izn_e  
  - vHhTilUdl.l[t] + vtPALudl.l[t] + vtAktieUdl.l[t]
  # Residual foreign transfer to firms
  + vVirkIndRest.l[t]
;
abort$(smax(t$(tData[t]), abs(fordringsbalance[t])) > 0.05) "Fejl i fordringsbalancen", fordringsbalance;
# Første forecast-år stemmer fordringsbalancen ikke - hænger nok sammen med korrektion i vHhx og at vHhxAfk ikke stemmer i t2
abort$(smax(t$(tForecast[t] and not t2[t]), abs(fordringsbalance[t])) > 1e-7) "Fejl i fordringsbalancen", fordringsbalance;

# ------------------------------------------------------------------------------------------------------------------
# Produktionsfunktion
# ------------------------------------------------------------------------------------------------------------------
parameter test_qKE[sp,t], test_qKEL[sp,t], test_qKELB[sp,t], test_qKELBR[sp,t];

test_qKELBR[sp,t]$(tx0[t] and eKELBR.l[sp] > 0 and eKELBR.l[sp] <> 1) = ( rR2KELBR.l[sp,t]**(1/eKELBR.l[sp]) * qR.l[sp,t]**(1-1/eKELBR.l[sp])
                 + (1-rR2KELBR.l[sp,t])**(1/eKELBR.l[sp]) * qKELB.l[sp,t]**(1-1/eKELBR.l[sp]) )**(1/(1-1/eKELBR.l[sp]))
                 - qKELBR.l[sp,t];
                 
test_qKELB[sp,t]$(tx0[t] and eKELB.l[sp] > 0 and eKELB.l[sp] <> 1) = ( rB2KELB.l[sp,t]**(1/eKELB.l[sp]) * (qKUdn.l['iB',sp,t])**(1-1/eKELB.l[sp])
                + (1-rB2KELB.l[sp,t])**(1/eKELB.l[sp]) * qKEL.l[sp,t]**(1-1/eKELB.l[sp]) )**(1/(1-1/eKELB.l[sp]))
                - qKELB.l[sp,t];

test_qKEL[sp,t]$(tx0[t] and eKEL.l[sp] > 0 and eKEL.l[sp] <> 1) = ( (1-rL2KEL.l[sp,t])**(1/eKEL.l[sp]) * (qKE.l[sp,t])**(1-1/eKEL.l[sp])
               + rL2KEL.l[sp,t]**(1/eKEL.l[sp]) * (qLUdn.l[sp,t])**(1-1/eKEL.l[sp]) )**(1/(1-1/eKEL.l[sp]))
               - qKEL.l[sp,t];
test_qKE[sp,t]$(tx0[t] and eKE.l[sp] > 0 and eKE.l[sp] <> 1 and d1K['iM',sp,t]) = ( (1-rE2KE.l[sp,t])**(1/eKE.l[sp]) * (qKUdn.l['iM',sp,t])**(1-1/eKE.l[sp])
               + rE2KE.l[sp,t]**(1/eKE.l[sp]) * (qE.l[sp,t])**(1-1/eKE.l[sp]) )**(1/(1-1/eKE.l[sp]))
               - qKE.l[sp,t];

test_qKELBR[sp,t]$(tx0[t] and eKELBR.l[sp] = 0)
  = qR.l[sp,t] / rR2KELBR.l[sp,t] + qKELB.l[sp,t] / (1-rR2KELBR.l[sp,t]) - 2 * qKELBR.l[sp,t];
test_qKELB[sp,t]$(tx0[t] and eKELB.l[sp] = 0)
  = qKUdn.l['iB',sp,t] / rB2KELB.l[sp,t] + qKEL.l[sp,t] / (1-rB2KELB.l[sp,t]) - 2 * qKELB.l[sp,t];
test_qKEL[sp,t]$(tx0[t] and eKEL.l[sp] = 0)
  = qKE.l[sp,t] / (1-rL2KEL.l[sp,t]) + qLUdn.l[sp,t] / rL2KEL.l[sp,t] - 2 * qKEL.l[sp,t];
test_qKE[sp,t]$(tx0[t] and eKE.l[sp] = 0 and d1K['iM',sp,t])
  = qKUdn.l['iM',sp,t] / (1-rE2KE.l[sp,t]) + qE.l[sp,t] / rE2KE.l[sp,t] - 2 * qKE.l[sp,t];
test_qKE[sp,t]$(tx0[t] and not d1K['iM',sp,t]) =
  qE.l[sp,t] / rE2KE.l[sp,t] - qKE.l[sp,t];

abort$(smax([sp,t], abs(test_qKELBR[sp,t])) > 1e-6) "KELBR stemmer ikke med produktionsfunktion", test_qKELBR;
abort$(smax([sp,t], abs(test_qKELB[sp,t])) > 1e-6) "KELB stemmer ikke med produktionsfunktion", test_qKELB;
abort$(smax([sp,t], abs(test_qKEL[sp,t])) > 1e-6) "KEL stemmer ikke med produktionsfunktion", test_qKEL;
abort$(smax([sp,t], abs(test_qKE[sp,t])) > 1e-6) "KE stemmer ikke med produktionsfunktion", test_qKE;

parameter test_qYBolig[t];
test_qYBolig[t]$(tx0[t]) = uYBolig.l[t]**(1/(eBolig.l-1))
                         * (     (rLand2YBolig.l[t])**(1/eBolig.l) * qLandSalg.l[t]**(1-1/eBolig.l)
                             + (1-rLand2YBolig.l[t])**(1/eBolig.l) * qIBolig.l[t]**(1-1/eBolig.l)
                           )**(1/(1-1/eBolig.l)) - qYBolig.l[t];
abort$(smax([t], abs(test_qYBolig[t])) > 1e-6) "qYBolig stemmer ikke med produktionsfunktion", test_qYBolig;

# ------------------------------------------------------------------------------------------------------------------
# Negative tal
# ------------------------------------------------------------------------------------------------------------------
$GROUP G_no_negatives
  G_prices, G_quantities, -G_negative_allowed
;
$GROUP G_no_negatives G_no_negatives$(tx0[t]);
@set(G_no_negatives, _test, .l)
$LOOP G_no_negatives:
  {name}_test{sets}${conditions} = min({name}_test{sets}, 0)$(mapVal({name}.l{sets}) <> 5);
  abort$sum({sets}, {name}_test{sets} < -1e-15) "{name} er negativ (hvis historisk data slå fra i test og kontakt modelgruppen i DST)", {name}_test;
$ENDLOOP

# ------------------------------------------------------------------------------------------------------------------
# Variable begrænset mellem 0 og 1
# ------------------------------------------------------------------------------------------------------------------
$GROUP G_zero_to_one
  rPensUdb
;
$GROUP G_zero_to_one G_zero_to_one$(tx0[t]);
$LOOP G_zero_to_one:
  parameter {name}_test{sets};
  {name}_test{sets} = {name}.l{sets}$({name}.l{sets} > 1+1e-9 or {name}.l{sets} < -1e-9);
  abort$(sum({sets}, {name}_test{sets} > 1)) "{name} er over 1 og bør være mellem 0 og 1", {name}_test;
  abort$(sum({sets}, {name}_test{sets} < 0)) "{name} er negativ og bør være mellem 0 og 1", {name}_test;
$ENDLOOP
