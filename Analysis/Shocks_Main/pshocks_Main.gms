# ======================================================================================================================
# Permanent shocks
# ======================================================================================================================
#  $SETGLOBAL terminal_year 2060;
$SETLOCAL shock_year 2026;

OPTION SOLVELINK=0, NLP=CONOPT4;

parameter dt[t], Indfasning_4y[t];
dt[t] = t.val - %shock_year%;
Indfasning_4y[t]$(dt[t] = 0) = 0;
Indfasning_4y[t]$(dt[t] = 1) = 0.25;
Indfasning_4y[t]$(dt[t] = 2) = 0.5;
Indfasning_4y[t]$(dt[t] = 3) = 0.75;
Indfasning_4y[t]$(dt[t] > 3) = 1;

parameter tBund_reaction[t];
tBund_reaction[t] = Indfasning_4y[t];

$BLOCK B_tax_reaction
  E_tBund_reaction[t]$tx0E[t].. tBund[t] =E= tBund.l[t] + tBund_reaction[t] * (tBund[tEnd] - tBund.l[tEnd]);
  E_tBund_reaction_tEnd[t]$(tEnd[t]).. vOffNetFormue[t] / vBNP[t] =E= vOffNetFormue[t-1] / vBNP[t-1];
$ENDBLOCK

$BLOCK B_Renten
  E_rRente_obl_Renten[t]$(tx0[t]).. 
    rRente['Obl',t] =E= rRente.l['Obl',t] - 0.001;
$ENDBLOCK

$BLOCK B_Arbejdsudbud
  E_snLHh_Arbejdsudbud[a,t]$(tx0[t] and a15t100[a]).. 
    snLHh[a,t] =E= 1.01 * snLHh.l[a,t];
$ENDBLOCK

$MODEL M_Renten
  M_base
  B_Renten
;
$MODEL M_Arbejdsudbud
  M_base
  B_tax_reaction
  B_Arbejdsudbud
;

# ======================================================================================================================
# Shock model with SVAR impulses and solve square collection of scenario models with fixed parameters
# ======================================================================================================================
set_time_periods(%shock_year%-1, %terminal_year%);
@save(All);

# ----------------------------------------------------------------------------------------------------------------------
# Bundskat
# ----------------------------------------------------------------------------------------------------------------------
@reset(All);
$FIX All; $UNFIX G_endo;

# Stød
tBund.up[t]  = tBund.l[t] - 0.0025;
tBund.lo[t]  = tBund.l[t] - 0.0025;

# Løsning
@solve(M_base)
$FIX All; $UNFIX G_post_endo;
@solve(B_post);

@unload_all(Gdx\Bundskat_pshock);

# ----------------------------------------------------------------------------------------------------------------------
# Renten
# ----------------------------------------------------------------------------------------------------------------------
@reset(All);
$FIX All; $UNFIX G_endo;

# Stød
$UNFIX rRente$(sameas[portf,'obl'] and tx0[t]); # B_Renten

# Løsning
@solve(M_Renten)
$FIX All; $UNFIX G_post_endo;
@solve(B_post);

@unload_all(Gdx\Renten_pshock);

# ----------------------------------------------------------------------------------------------------------------------
# Labor supply - search
# ----------------------------------------------------------------------------------------------------------------------
@reset(All);
$FIX All; $UNFIX G_endo;

# Stød
$UNFIX uDeltag[a,t]$(tx0[t] and a15t100[a]) ; # B_Arbejdsudbud 
$UNFIX tBund$(tx0[t]); # B_tax_reaction og M_pshock_lukning

@solve(M_Arbejdsudbud)
$FIX All; $UNFIX G_post_endo;
@solve(B_post);

@unload_all(Gdx\Arbejdsudbud_pshock);

# ----------------------------------------------------------------------------------------------------------------------
# Udenlandske priser - ufinansieret
# ----------------------------------------------------------------------------------------------------------------------
@reset(All);
$FIX All; $UNFIX G_endo;

# Stød
# Udenlandske priser øges med 1 pct.
pUdl.fx[t]$(tx0[t]) = pUdl.l[t] * 1.01;
pOlie.fx[t]$(tx0[t]) = pOlie.l[t] * 1.01;

# Når udenlandsk pris siger 1 pct., så stiger indtjening i udland og aktier 1 pct.
jrOmv_UdlAktier.fx[t]$(t1[t]) = jrOmv_UdlAktier.l[t] + 0.01;

# Når priser siger 1 pct., så stiger guld som realt aktiv 1 pct.
rOmv.fx['Guld',t]$(t1[t]) = rOmv.l['Guld',t] + 0.01;

# Eksogene overførsler endogeniseres (følger BNP)
$FIX rOffFraUdl2BNP$(tx0[t]);
$FIX rOffFraHh2BNP$(tx0[t]);
$FIX rOffFraVirk2BNP$(tx0[t]);
$FIX rOffTilUdl2BNP$(tx0[t]);
$FIX rOffTilVirk2BNP$(tx0[t]);
$FIX rOffTilHhKap2BNP$(tx0[t]);
$FIX rOffTilHhOev2BNP$(tx0[t]);
$FIX rOffLandKoeb2BNP$(tx0[t]);
$FIX rSubEU2BNP$(tx0[t]);
$FIX rOffVirk2BNP$(tx0[t]);
$FIX rPersIndRest_a2PersInd$(tx0[t]);
$FIX rPersIndRest_t2PersInd$(tx0[t]);

$UNFIX vOffFraUdl$(tx0[t]);
$UNFIX vOffFraHh$(tx0[t]);
$UNFIX vOffFraVirk$(tx0[t]);
$UNFIX vOffTilUdl$(tx0[t]);
$UNFIX vOffTilVirk$(tx0[t]);
$UNFIX vOffTilHhKap$(tx0[t]);
$UNFIX vOffTilHhOev$(tx0[t]);
$UNFIX vOffLandKoeb$(tx0[t]);
$UNFIX vSubEU$(tx0[t]);
$UNFIX vOffVirk$(tx0[t]);
$UNFIX vPersIndRest_a$(tx0[t]);
$UNFIX vPersIndRest_t$(tx0[t]);

vtLukning.fx['tot',t]$(tx0[t]) = vtLukning.l['tot',t] * 1.01;

# Skatter og afgifter
tHhVaegt.fx[t]$(tx0[t]) = tHhVaegt.l[t] * 1.01;
vRestFradragSats.fx[t]$(tx0[t]) = vRestFradragSats.l[t] * 1.01;

# Løsning
@solve(M_Base);
$FIX All; $UNFIX G_post_endo;
@solve(B_post);

@unload(Gdx\Prisneutralitet_homo);

#  # ----------------------------------------------------------------------------------------------------------------------
#  # Befolkningsstød - ufinansieret
#  # ----------------------------------------------------------------------------------------------------------------------
@reset(All);
$FIX All; $UNFIX G_endo;

# Stød
# Befolkningen stiger med 1 pct. 
nPop.fx[a,t]$(tx0[t]) = 1.01 * nPop.l[a,t];
nSoegBaseUdl.fx[t]$(tx0[t]) = 1.01 * nSoegBaseUdl.l[t];

# Land og lejeboliger stiger med 1 pct.
qLand.fx[t]$(tx0[t]) = qLand.l[t] + 0.01 * Indfasning_4y[t] * qLand.l[t];
qKLejeBolig.fx[t]$(tx0[t]) = qKLejeBolig.l[t] + 0.01 * Indfasning_4y[t] * qKLejeBolig.l[t];

# Offentligt forbrug, kapitalapparat og beskæftigelse stiger med 1 pct. (Kapital i stedet for investeringer, da bygninger er meget lang tid om at konvergere)
$FIX qK$(sOff[s_] and tx0[t]);
$UNFIX qI_s$((sameas['iM',i_] or sameas['iB',i_]) and sOff[s_] and tx0[t]);

qK.fx[k,'off',t]$(tx0[t]) = qK.l[k,'off',t] + 0.01 * Indfasning_4y[t] * qK.l[k,'off',t];
qG.fx['gTot',t]$(tx0[t]) = 1.01 * qG.l['gTot',t];
nL.fx['off',t]$(tx0[t]) = 1.01 * nL.l['off',t];

# Import til reeksport og energieksport øges med 1 pct. (Endogen direkte eksport øges via skalaparameter)
uxm.fx[x,t]$(tx0[t]) = 1.01 * uxm.l[x,t];
qXy.fx['xene',t]$(tx0[t]) = 1.01 * qXy.l['xene',t];

# Produktionen i udvindingsbranchen er eksogen og øges med 1 pct.
qY.fx['udv',t]$(tx0[t]) = 1.01 * qY.l['udv',t];
qGrus.fx[t]$(tx0[t]) = 1.01 * qGrus.l[t];

# Eksogene overførsler endogeniseres (følger BNP)
$FIX rOffFraUdl2BNP$(tx0[t]);
$FIX rOffFraHh2BNP$(tx0[t]);
$FIX rOffFraVirk2BNP$(tx0[t]);
$FIX rOffTilUdl2BNP$(tx0[t]);
$FIX rOffTilVirk2BNP$(tx0[t]);
$FIX rOffTilHhKap2BNP$(tx0[t]);
$FIX rOffTilHhOev2BNP$(tx0[t]);
$FIX rOffLandKoeb2BNP$(tx0[t]);
$FIX rSubEU2BNP$(tx0[t]);
$FIX rOffVirk2BNP$(tx0[t]);
$FIX rPersIndRest_a2PersInd$(tx0[t]);
$FIX rPersIndRest_t2PersInd$(tx0[t]);

$UNFIX vOffFraUdl$(tx0[t]);
$UNFIX vOffFraHh$(tx0[t]);
$UNFIX vOffFraVirk$(tx0[t]);
$UNFIX vOffTilUdl$(tx0[t]);
$UNFIX vOffTilVirk$(tx0[t]);
$UNFIX vOffTilHhKap$(tx0[t]);
$UNFIX vOffTilHhOev$(tx0[t]);
$UNFIX vOffLandKoeb$(tx0[t]);
$UNFIX vSubEU$(tx0[t]);
$UNFIX vOffVirk$(tx0[t]);
$UNFIX vPersIndRest_a$(tx0[t]);
$UNFIX vPersIndRest_t$(tx0[t]);

vtLukning.fx['tot',t]$(tx0[t]) = vtLukning.l['tot',t] * 1.01;

# Referenceforbruget på bolig falder pr. person, når befolkningen stiger
$FIX qBoligR$(t1[t] and a18t100[a_]);
$UNFIX uBolig_a$(t1[t] and a18t100[a]);
qBoligR.fx[a,t]$(t1[t] and a18t100[a]) = qBoligR.l[a,t] / 1.01;
$FIX qBoligHtM$(t1[t] and a18t100[a_]);
$UNFIX uBoligHtM_a$(t1[t] and a18t100[a]);
qBoligHtM.fx[a,t]$(t1[t] and a18t100[a]) = qBoligHtM.l[a,t] / 1.01;

# Løsning
@solve(M_Base)
$FIX All; $UNFIX G_post_endo;
@solve(B_post);

@unload(Gdx\Befolkning_homo);