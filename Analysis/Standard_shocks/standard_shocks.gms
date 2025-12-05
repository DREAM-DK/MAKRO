# ======================================================================================================================
# Standard shocks
# ======================================================================================================================
$SETLOCAL shock_year 2030;
tHBI[t] = t.val = 2030; 
set_time_periods(%shock_year%-1, %terminal_year%);
@load_as(All, "Gdx/baseline.gdx", _baseline)
$GROUP All_ All; # to avoid foreign variables 
@unload(Gdx/shock_year.gdx); # to load in shock year for foreign model
@load_dummies(t, "Gdx/baseline.gdx")

OPTION SOLVELINK=0, NLP=CONOPT4;

# ======================================================================================================================
# Transformation of foreign economy inputs for shocks with endogenous foreign economy
# ======================================================================================================================
$IMPORT foreign_variables.gms
# --------------------------------------------------------------------------------------------------------------------
# Public finance reaction function which can be enabled
# Specifically, a sigmoid (s-shaped) tax reaction function
# --------------------------------------------------------------------------------------------------------------------
parameter
  tax_reaction_start "Year that tax reaction starts" /%shock_year%/
  tax_reaction_end "Year that tax reaction is fully implemented by" /%shock_year%/
  steepness "Steepness of tax reaction implentation: k=1 → linear; k=(end-start) → slope=1 in the middle of the s curve" /2/
  tax_reaction_share[t] "Share of tax reaction implemented at time t"
;
tax_reaction_share[t]$(tax_reaction_start < t.val and t.val < tax_reaction_end)
  = 1 - 1 / (((tax_reaction_end-tax_reaction_start) / (t.val - tax_reaction_start) - 1)**(-steepness) + 1);
tax_reaction_share[t]$(t.val >= tax_reaction_end) = 1;

$BLOCK B_tax_reaction
  E_tax_reaction[t]$tx0E[t].. tLukning[t] =E= tLukning_baseline[t] + tax_reaction_share[t] * (tLukning[tEnd] - tLukning_baseline[tEnd]);
  E_tax_reaction_tEnd[t]$(tEnd[t]).. vOff13Net[t] / vBNP[t] =E= vOff13Net_baseline[t] / vBNP_baseline[t];
$ENDBLOCK

# --------------------------------------------------------------------------------------------------------------------
# Shock profiles that we can easily switch between
# --------------------------------------------------------------------------------------------------------------------
$PGROUP PG_shock_profiles
  permanent_profile[t] "Stød profil for permanente stød."
  linear_profile[t] "Stød profil for midlertidige stød aftrappet lineært over 4 år."
  AR_profile[t] "Stød profil for midlertidige stød aftrappet eksponentielt."
  blip_profile[t] "Stød profil for 1-periode stød."
  s_profile[t] "Stød profil for midlertidige stød aftrappet med sigmoid funktion."
;
permanent_profile[t]$(tx0[t]) = 1;
linear_profile[t]$(tx0[t]) = max(1 - 0.25 * dt[t], 0);
AR_profile[t]$(tx0[t]) = 0.9**dt[t]; # standard for FM multiplikatorer, se Økonomisk Redegørelse Marts 2023 kapitel 8, Boks 8.3 for detaljer
blip_profile[t]$(t1[t]) = 1;
s_profile[t]$(tx0[t] and t.val < 5) = 1 / ((5 / dt[t] - 1)**(-1.5) + 1); # Where n=5 is number of periods and k=1.5 controls steepness

# --------------------------------------------------------------------------------------------------------------------
# List of pre-defined shocks. Comment out or delete those that you do not wish to run.
# --------------------------------------------------------------------------------------------------------------------
$FOR1 {shock} in [
  "Nulstoed",

  # # Offentligt forbrug
  "Offentligt_forbrug",
  "Offentlig_varekoeb",
  # "Offentlig_Beskaeftigelse",
  # "Offentlig_loen",
  # "Offentlige_investeringer",

  # # Offentlige overførsler
  # "Skattepligtig_indkomstoverforsel",
  # "Ikke_skattepligtig_indkomstoverforsel",

  # # Subsidier
  # "Produktsubsidier",
  # "Lontilskud",
  # "Produktionssubsidier",

  # Skatter
  "Bundskat",
  # "AM_bidrag",
  # "Grundskyld",
  # "Ejendomsvaerdiskat",
  # "Vaegtafgift",
  # "Selskabsskat",
  # "Aktieskat",
  # "Moms",
  # "Registreringsafgift",
  # "Energiafgift",
  # "Forbrugsafgift",
  # "Afgift_erhverv",
  # "Overforsel_privat", # Lump sum skat

  # Udland
  "Eksportmarkedsvaekst",
  # "Importpris",
  # "Eksportkonkurrerende_priser",
  # "Oliepris",
  # "Udenlandske_priser",
  "Rente",

  # Øvrige udbudsstød
  "Arbejdsudbud_beskaeftigelse",
  # "Arbejdsudbud_timer",
  # "Arbejdsudbud_timer_kohort_30",
  # "Arbejdsudbud_timer_alder_30",
  # "Befolkning",
  # "KapitalProd",
  # "ArbejdsProd",

  # # Risiko-præmier
  # "VirkDisk",
  # "BoligRisiko",
  # "AktieAfkast",
  # "RisikoPraemier",

  # # Præference
  # "Diskontering",
  # "Loen",

  # Homogenitet
  # "Prisneutralitet",
  # "Befolkningshomogenitet",

  # FM et-årige multiplikatorer
  # "Off_vare_FM",
  # "Off_besk_FM",
  # "Off_lon_FM",
  # "Off_inv_FM",
  # "Skattepligtig_indkomstoverforsel_FM",
  # "Ikke_skattepligtig_indkomstoverforsel_FM",
  # "Varefordelt_subsidie_FM",
  # "Lontilskud_FM",
  # "Produktionssubsidie_FM",
  # "Overforsel_privat_FM",
  # "Bundskat_FM",
  # "AM_bidrag_FM",
  # "Ejendomsskat_FM",
  # "Vaegtafgift_FM",
  # "Selskabsskat_FM",
  # "Aktieskat_FM",
  # "Moms_FM",
  # "Registreringsafgift_FM",
  # "Energiafgift_FM",
  # "Forbrugsafgift_FM",
  # "Afgift_erhverv_FM"

  # # Endogen udenlandsk økonomi
  # "rRente_foreign",
]:
  # --------------------------------------------------------------------------------------------------------------------
  # List of shock variations.
  # Comment out or delete those that you do not wish to run.
  # For each variation, we include a label for the variation, a profile for the shock (defined above),
  # and a dummy indicating whether or not to include a public tax reaction function.
  # --------------------------------------------------------------------------------------------------------------------
  $FOR2 {variation_label}, {shock_profile}, {tax_reaction} in [
    # ("midl", "AR_profile", 1), # Midlertidige stød aftrappet lineært over 4 år
    ("perm", "permanent_profile", 1), # Permanente skatte-finansierede stød
    ("ufin", "permanent_profile", 0), # Permanente ufinansierede stød
    # ("blip", "blip_profile", 1), # 1-periode stød
  ]:
  # --------------------------------------------------------------------------------------------------------------------
    # Preamble shared by all shocks
    # --------------------------------------------------------------------------------------------------------------------
    Model M_shock /M_base/; # Definer basis stødmodel som kan overskrives af enkelte stød
    @set(All_, .l, _baseline);
    $FIX All; $UNFIX G_endo;
    $UNFIX vtLukning$({tax_reaction} and aTot[a_] and tx0[t]);

  # ====================================================================================================================
  # Define shocks below
  # Each shock is wrapped in an IF-statement based on the label of the shock
  # ====================================================================================================================

  # ====================================================================================================================
  # Offentligt forbrug
  # ====================================================================================================================
  # --------------------------------------------------------------------------------------------------------------------
  # Offentligt forbrug - faste K/Y og L/R forhold
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Offentligt_forbrug":
    qG.fx[gTot,t]$(tx0[t]) = qG.l[gTot,t] + 0.01 * {shock_profile}[t] * vBNP.l[t]/pG.l[gTot,t];
    $UNFIX hL$(off[s_] and tx0[t]);
    $FIX rOffK2Y; $UNFIX qI_s[k,off,tx0];
    $FIX rOffLoensum2R; $UNFIX qR$(off[r_] and tx0[t]);
    $FIX rOffLoensum2E; $UNFIX qE$(off[r_] and tx0[t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Offentligt varekøb - 1 pct. af vBNP med baseline deflatorer
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Offentlig_varekoeb":
    qR.fx['off',t]$(tx0[t]) = qR.l['off',t] + 0.01 * {shock_profile}[t] * vBNP.l[t] / pR.l['off',t];
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Offentlig beskæftigelse - 1 pct. af vBNP med baseline deflatorer
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Offentlig_Beskaeftigelse":
    hL.fx['off',t]$(tx0[t]) = hL.l['off',t] * (1 + {shock_profile}[t] * 0.01 * vBNP.l[t] / vLoensum.l['off',t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Offentlige investeringer - 1 pct. af vBNP med baseline deflatorer
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Offentlige_investeringer":
    qI_s.fx[i,'off',t]$(tx0[t] and d1I_s[i,'off',t])
      = qI_s.l[i,'off',t]
      + 0.01 * {shock_profile}[t] * vBNP.l[t]/pI_s.l[i,'off',t] * (vI_s.l[i,'off',t] / vI_s.l['itot','off',t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Offentlig løn - 1 pct. af vBNP med baseline deflatorer
  #
  # Grundantagelsen er at løn-forskelle mellem brancher skyldes sammensætningseffekter i ansattes produktivitet.
  # Offentlig produktion opgøres, som udgangspunkt, ved inputmetoden og påvirkes derfor ikke af produktivitet.
  # Vi øger den lønbestemmende "produktivitet" for offentlig ansatte,
  # og ændrer dermed offentlig løn uden at påvirke privat-sektor produktivitet.
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Offentlig_loen":
    qProdHh_t.fx[t]$(tx0[t]) = qProdHh_t.l[t] * (1 + {shock_profile}[t] * 0.01 * vBNP.l[t] / vLoensum.l['off',t]
                             * qProd.l['off',t] * hL.l['off',t]  / (qProd.l[sTot,t] * hL.l[sTot,t]));
    qProdxDK.fx[t]$(tx0[t]) = qProdxDK.l[t] * (1 + {shock_profile}[t] * 0.01 * vBNP.l[t] / vLoensum.l['off',t]
                            * qProd.l['off',t] * hL.l['off',t]  / (qProd.l[sTot,t] * hL.l[sTot,t]));

    qProd.fx['off',t]$(tx0[t]) = qProd.l['off',t] * (1 + {shock_profile}[t] * 0.01 * vBNP.l[t] / vLoensum.l['off',t]);
    $UNFIX uProd$(off[s_]);
  $ENDIF

  # ====================================================================================================================
  # Offentlige overførsler
  # ====================================================================================================================
  # --------------------------------------------------------------------------------------------------------------------
  # Skattepligtige indkomstoverførsler 
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Skattepligtig_indkomstoverforsel":
    vOvfSats.fx[ovf,t]$(tx0[t] and not ubeskat[ovf])
      = vOvfSats.l[ovf,t] * (1 + {shock_profile}[t] * 0.01 * vBNP.l[t] / sum(ubeskat, vOvf.l[ubeskat,t]));
    $UNFIX uvOvfSats[ovf,t]$(tx0[t] and not ubeskat[ovf]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Ikke-skattepligtige indkomstoverførsler
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Ikke_skattepligtig_indkomstoverforsel":
    vOvfSats.fx[ubeskat,t]$(tx0[t])
      = vOvfSats.l[ubeskat,t] * (1 + {shock_profile}[t] * 0.01 * vBNP.l[t] / sum(ovf$ubeskat[ovf], vOvf.l[ovf,t]));
    $UNFIX uvOvfSats[ovf,t]$(tx0[t] and ubeskat[ovf]);
  $ENDIF

  # ====================================================================================================================
  # Subsidier
  # ====================================================================================================================
  # --------------------------------------------------------------------------------------------------------------------
  # Produktsubsidier
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Produktsubsidier":
    rSub_m.fx[d,s,t]$(tx0[t]) = rSub_m.l[d,s,t] * (1 + {shock_profile}[t] * 0.01 * vBNP.l[t] / vSub.l[dTot,sTot,t]);
    rSub_y.fx[d,s,t]$(tx0[t]) = rSub_y.l[d,s,t] * (1 + {shock_profile}[t] * 0.01 * vBNP.l[t] / vSub.l[dTot,sTot,t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Løntilskud
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Lontilskud":
    rSubLoen.fx[s,t]$(tx0[t]) = rSubLoen.l[s,t] * (1 + {shock_profile}[t] * 0.01 * vBNP.l[t] / vSubLoen.l['tot',t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Produktionssubsidier ekskl. løntilskud
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Produktionssubsidier":
    vSubYRest.fx[s,t]$(tx0[t]) = vSubYRest.l[s,t] * ( 1 + {shock_profile}[t] * 0.01 * vBNP.l[t] / vSubYRest.l[sTot,t]);
    $UNFIX rSubYRest[s,t]$(tx0[t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Øvrige overførsler til husholdninger
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Overforsel_privat":
    vOffTilHhRest.fx[ t]$(tx0[t]) = vOffTilHhRest.l[t] + {shock_profile}[t] * 0.01 * vBNP.l[t];
  $ENDIF

  # ====================================================================================================================
  # Skatter
  # ====================================================================================================================
  # --------------------------------------------------------------------------------------------------------------------
  # Bundskat - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Bundskat":
    tBund.fx[t]$(tx0[t]) = tBund.l[t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtBund.l['tot',t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # AM-bidrag - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "AM_bidrag":
    tAMbidrag.fx[t]$(tx0[t])  = tAMbidrag.l[t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtHhAM.l['Tot',t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Grundskyld - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Grundskyld":
    tGrund.fx[s,t]$(tx0[t] and d1K['iB',s,t])
      = tGrund.l[s,t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtGrund.l['Tot',t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Ejendomsværdiskat - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Ejendomsvaerdiskat":
    tEjd.fx[t]$(tx0[t]) = tEjd.l[t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtEjd.l[aTot,t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Vægtafgift - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Vaegtafgift":
    utHhVaegt.fx[t]$(tx0[t])
      = utHhVaegt.l[t] * (1 - 0.01 * {shock_profile}[t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Selskabsskat - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Selskabsskat":
    tSelskab.fx[t]$(tx0[t]) = tSelskab.l[t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtSelskabx.l['Tot',t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Aktieskat - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Aktieskat":
    tAktieTop.fx[t]$(tx0[t]) = tAktieTop.l[t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtAktie.l[t]);
    tAktieLav.fx[t]$(tx0[t]) = tAktieLav.l[t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtAktie.l[t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Moms - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Moms":
    tMoms_y.fx[d,s,t]$(tx0[t]) = tMoms_y.l[d,s,t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtMoms.l[dtot,sTot,t]);
    tMoms_m.fx[d,s,t]$(tx0[t]) = tMoms_m.l[d,s,t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtMoms.l[dtot,sTot,t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Registreringsafgift til privat forbrug - 0,5 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Registreringsafgift":
    tReg_m.fx[d,s,t]$(tx0[t]) = tReg_m.l[d,s,t] * (1 - 0.005 * {shock_profile}[t] * vBNP.l[t] / vtReg.l['cBil','tot',t]);
    tReg_y.fx[d,s,t]$(tx0[t]) = tReg_y.l[d,s,t] * (1 - 0.005 * {shock_profile}[t] * vBNP.l[t] / vtReg.l['cBil','tot',t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Energiafgift til privat forbrug - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Energiafgift":
    tAfg_y.fx['cEne',s,t]$(tx0[t])
      = tAfg_y.l['cEne',s,t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtAfg.l['cEne','tot',t]);
    tAfg_m.fx['cEne',s,t]$(tx0[t])
      = tAfg_m.l['cEne',s,t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtAfg.l['cEne','tot',t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Øvrige forbrugsafgifter - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Forbrugsafgift":
    tAfg_y.fx['cVar',s,t]$(tx0[t])
      = tAfg_y.l['cVar',s,t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtAfg.l['cVar','tot',t]);
    tAfg_m.fx['cVar',s,t]$(tx0[t])
      = tAfg_m.l['cVar',s,t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtAfg.l['cVar','tot',t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Afgift på private erhvervs materialeinput - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Afgift_erhverv":
    tAfg_y.fx[r,s,t]$(tx0[t] and sp[s])
      = tAfg_y.l[r,s,t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / (vtAfg.l[rTot,sTot,t] - vtAfg.l['off',sTot,t])); 
    tAfg_m.fx[r,s,t]$(tx0[t] and sp[s])
      = tAfg_m.l[r,s,t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / (vtAfg.l[rTot,sTot,t] - vtAfg.l['off',sTot,t]));
  $ENDIF

  # ======================================================================================================================
  # Udland
  # ======================================================================================================================
  # --------------------------------------------------------------------------------------------------------------------
  # Eksportmarkedsvækst - 1 pct.
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Eksportmarkedsvaekst":
    uXMarked.fx[t]$(tx0[t]) = uXMarked.l[t] * (1 + 0.01 * {shock_profile}[t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Importpris - 1 pct.
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Importpris":
    pM.fx[s,t]$(tx0[t]) = pM.l[s,t] * (1 + 0.01 * {shock_profile}[t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Eksportkonkurrerende priser - 1 pct.
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Eksportkonkurrerende_priser":
    pXUdl.fx[x,t]$(tx0[t]) = pXUdl.l[x,t] * (1 + 0.01 * {shock_profile}[t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Oliepris - 10 pct.
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Oliepris":
    pOlieBrent.fx[t]$(tx0[t]) = pOlieBrent.l[t] * (1 + 0.10 * {shock_profile}[t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Direkte stød til alle importpriser og eksportkonkurrerende priser - 1 pct.
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Udenlandske_priser":
    pM.fx[s,t]$(tx0[t]) = pM.l[s,t] * (1 + 0.01 * {shock_profile}[t]);
    pXUdl.fx[x,t]$(tx0[t]) = pXUdl.l[x,t] * (1 + 0.01 * {shock_profile}[t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Rente - 1 pct.-point i 2 perioder før aftrapning
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Rente":
    rRenteECB.fx[t]$(t1[t]) = rRenteECB.l[t] + 0.01;
    rRenteECB.fx[t]$(tx1[t]) = rRenteECB.l[t] + 0.01 * {shock_profile}[t-1];
  $ENDIF

  # ====================================================================================================================
  # Øvrige udbudsstød
  # ====================================================================================================================
  # --------------------------------------------------------------------------------------------------------------------
  # Arbejdsudbud, strukturel beskæftigelse - 1 pct.
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Arbejdsudbud_beskaeftigelse":
    snLHh.fx[a,t]$(tx0[t] and a15t100[a]) = snLHh.l[a,t] * (1 + 0.01 * {shock_profile}[t]);
    $UNFIX uDeltag[a,t]$(tx0[t] and a15t100[a]); 
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Arbejdsudbud,timer - 1 pct.
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Arbejdsudbud_timer":
    shLHh.fx[a,t]$(tx0[t] and a15t100[a]) = shLHh.l[a,t] * (1 + 0.01 * {shock_profile}[t]);
    $UNFIX uh[a,t]$(tx0[t] and a15t100[a]); 
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Arbejdsudbud,timer - kohort for 30-årige - 1 pct.
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Arbejdsudbud_timer_kohort_30":
      parameter target_birth_year;
      target_birth_year = %shock_year% - 30;
      shLHh.fx[a,t]$(tx0[t] and a15t100[a] and (t.val - a.val) = target_birth_year and a.val < 70) 
          = shLHh.l[a,t] * (1 + 0.01 * {shock_profile}[t]);
      $UNFIX uh[a,t]$(tx0[t] and a15t100[a] and (t.val - a.val) = target_birth_year and a.val < 70);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Arbejdsudbud,timer - alder 30 - 1 pct.
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Arbejdsudbud_timer_alder_30":
      shLHh.fx[a,t]$(tx0[t] and a.val = 30) 
          = shLHh.l[a,t] * (1 + 0.01 * {shock_profile}[t]);
      $UNFIX uh[a,t]$(tx0[t] and a.val = 30);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Befolkning - 1 pct.
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Befolkning":
    nPop.fx[a,t]$(tx0[t]) = nPop.l[a,t] * (1 + 0.01 * {shock_profile}[t]);
    nSoegBasexDK.fx[t]$(tx0[t]) = nSoegBasexDK.l[t] * (1 + 0.01 * {shock_profile}[t]);
    qG.fx[gTot,t]$(tx0[t]) = qG.l[gTot,t] * (1 + 0.01 * {shock_profile}[t]);
    $UNFIX hL$(off[s_] and tx0[t]);
    $FIX rOffK2Y; $UNFIX qI_s$(off[s_] and tx0[t]);
    $FIX rOffLoensum2R; $UNFIX qR$(off[r_] and tx0[t]);
    $FIX rOffLoensum2E; $UNFIX qE$(off[r_] and tx0[t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Arbejdskraftsproduktivitet - 1 pct. arbejdskraftbesparende teknologiske fremskridt
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "ArbejdsProd":
    qProdHh_t.fx[t]$(tx0[t]) = qProdHh_t.l[t] * (1 + 0.01 * {shock_profile}[t]);
    qProdxDK.fx[t]$(tx0[t]) = qProdxDK.l[t] * (1 + 0.01 * {shock_profile}[t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Kapitalproduktivitet - 1 pct. arbejdskraftbesparende teknologiske fremskridt
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "KapitalProd":
    uK.fx['iM',sp,t]$(tx0[t]) = uK.l['iM',sp,t] * (1 + 0.01 * {shock_profile}[t])**(eKEL.l[sp]-1);
    uK.fx['iB',sp,t]$(tx0[t]) = uK.l['iB',sp,t] * (1 + 0.01 * {shock_profile}[t])**(eKELB.l[sp]-1);
  $ENDIF

  # ====================================================================================================================
  # Risiko-præmier
  # ====================================================================================================================
  # --------------------------------------------------------------------------------------------------------------------
  # Virksomhedernes hurdle rate
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "VirkDisk":
    rVirkDiskPrem.fx[sp,t]$(tx0[t]) = rVirkDiskPrem.l[sp,t] + 0.001 * {shock_profile}[t];
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Husholdningernes opfattede risiko-præmie i usercost på bolig
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "BoligRisiko":
    rBoligPrem.fx[t]$(tx0[t]) = rBoligPrem.l[t] + 0.001 * {shock_profile}[t];
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Virksomhedernes hurdle rate og aktieafkastrater
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "AktieAfkast":
    rVirkDiskPrem.fx[sp,t]$(tx0[t]) = rVirkDiskPrem.l[sp,t] + 0.001 * {shock_profile}[t];
    rAktieDriftPrem.fx[t]$(tx0[t]) = rAktieDriftPrem.l[t] + 0.001 * {shock_profile}[t];
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Risikopræmier på aktier, bolig, og virksomhedens hurdle rate
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "RisikoPraemier":
    rVirkDiskPrem.fx[sp,t]$(tx0[t]) = rVirkDiskPrem.l[sp,t] + 0.001 * {shock_profile}[t];
    rAktieDriftPrem.fx[t]$(tx0[t]) = rAktieDriftPrem.l[t] + 0.001 * {shock_profile}[t];
    rBoligPrem.fx[t]$(tx0[t]) = rBoligPrem.l[t] + 0.001 * {shock_profile}[t];
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Husholdningernes diskonteringsfaktor
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Diskontering":
    jfDisk_t.fx[t]$(tx0[t]) = jfDisk_t.l[t] - 0.001 * {shock_profile}[t];
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Lønmodtagernes forhandlingsstyrke
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Loen":
    rLoenNash.fx[t]$(tx0[t]) = rLoenNash.l[t] - 0.01 * {shock_profile}[t];
  $ENDIF

  # ====================================================================================================================
  # Homogenitet
  # ====================================================================================================================
  # --------------------------------------------------------------------------------------------------------------------
  # Prisneutralitet
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Prisneutralitet":
    # Udenlandske priser øges
    pM.fx[s,t]$(tx0[t]) = pM.l[s,t] * (1 + 0.01 * {shock_profile}[t]);
    pXUdl.fx[x,t]$(tx0[t]) = pXUdl.l[x,t] * (1 + 0.01 * {shock_profile}[t]);

    # Omvurderinger antages at følge priser
    rOmv.fx['Guld',t]$tx0[t] = rOmv.l['Guld',t] + 0.01 * ({shock_profile}[t] - {shock_profile}[t-1]); 
    rOmv.fx['UdlAktier',t]$tx0[t] = rOmv.l['UdlAktier',t] + 0.01 * ({shock_profile}[t] - {shock_profile}[t-1]); 

    # Den nominalle rente skal også stige i de periode, hvor inflationen er høj
    rRenteECB.fx[t]$tx0[t] = rRenteECB.l[t] + 0.01 * ({shock_profile}[t] - {shock_profile}[t-1]); 

    # Eksogene størelser i GovRevenues, som følger BNP i grundforløb
    $UNFIX vOffFraUdlKap; $FIX rOffFraUdlKap2BNP;
    $UNFIX vOffFraUdlEU; $FIX rOffFraUdlEU2BNP;
    $UNFIX vOffFraUdlRest; $FIX rOffFraUdlRest2BNP;
    $UNFIX vOffFraHh; $FIX rOffFraHh2BNP;
    $UNFIX vOffFraVirk; $FIX rOffFraVirk2BNP;
    $UNFIX vOffVirk; $FIX rOffVirk2BNP;
    $UNFIX vRestFradragSats; $FIX uRestFradrag;

    # Eksogene størelser i GovExpenses, som følger BNP i grundforløb
    $UNFIX vOffLandKoeb; $FIX rOffLandKoeb2BNP;
    $UNFIX vOffTilUdlKap; $FIX rOffTilUdlKap2BNP;
    $UNFIX vOffTilUdlMoms; $FIX rOffTilUdlMoms2BNP;
    $UNFIX vOffTilUdlBNI; $FIX rOffTilUdlBNI2BNP;
    $UNFIX vOffTilUdlEU; $FIX rOffTilUdlEU2BNP;
    $UNFIX vOffTilUdlFO; $FIX rOffTilUdlFO2BNP;
    $UNFIX vOffTilUdlGL; $FIX rOffTilUdlGL2BNP;
    $UNFIX vOffTilUdlBistand; $FIX rOffTilUdlBistand2BNP;
    $UNFIX vOffTilVirk; $FIX rOffTilVirk2BNP;
    $UNFIX vOffTilHhKap; $FIX rOffTilHhKap2BNP;
    $UNFIX vOffTilHhNPISH; $FIX rOffTilHhNPISH2BNP;
    $UNFIX vOffTilHhTillaeg; $FIX rOffTilHhTillaeg2BNP;
    $UNFIX vOffTilHhRest; $FIX rOffTilHhRest2BNP;
    $UNFIX vSubEU; $FIX rSubEU2BNP;

    # Eksogene størelser i Government
    $UNFIX vOffAkt$((IndlAktier[portf_] or UdlAktier[portf_] or Bank[portf_] or Obl[portf_]) and tx0[t]); $FIX rOffAkt2BNP;
    vOffPasRest_FM.fx[t] = vOffPasRest_FM.l[t] * (1 + 0.01 * {shock_profile}[t]);  
    $UNFIX vOffPasRest; $FIX rOffPasRest2BNP;

    # Øvrige eksogene størelser
    vKolPensKorRest.fx[t] = vKolPensKorRest.l[t] * (1 + 0.01 * {shock_profile}[t]); 
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Befolkningshomogenitet
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Befolkningshomogenitet":
    # fMigration eksogeniseres - svarer til at støde til alle stocks således at indvandrene antages at ankomme med samme stocks som eksisterende husholdninger
    # Vigtigt for at tilpasning i forbrug og opsparing ikke går ekstremt langsomt
    Model M_shock / M_base - E_fMigration /;
    $FIX fMigration$(a[a_]);

    # Stød til befolkning
    nPop.fx[a,t] = nPop.l[a,t] * (1 + 0.001 * {shock_profile}[t]);
    nSoegBasexDK.fx[t] = nSoegBasexDK.l[t] * (1 + 0.001 * {shock_profile}[t]);
    nPop_Over100.fx[t] = nPop_Over100.l[t] * (1 + 0.001 * {shock_profile}[t]);

    # Offentligt forbrug
    hL.fx['off',t] = hL.l['off',t] * (1 + 0.001 * {shock_profile}[t]); 
    qI_s.fx[i,'off',t] = qI_s.l[i,'off',t] * (1 + 0.001 * {shock_profile}[t]); 
    qR.fx['off',t] = qR.l['off',t] * (1 + 0.001 * {shock_profile}[t]); 
    qE.fx['off',t] = qE.l['off',t] * (1 + 0.001 * {shock_profile}[t]); 

    # Land og lejeboliger øges
    qLand.fx[t] = qLand.l[t] * (1 + 0.001 * {shock_profile}[t]); 
    qKLejeBolig.fx[t]$(t0[t]) = qKLejeBolig.l[t] * (1 + 0.001 * {shock_profile}[t]); 
    qILejeBolig.fx[t] = qILejeBolig.l[t] * (1 + 0.001 * {shock_profile}[t]); 

    # Produktionen i udvindingsbranchen og eksport af energi er eksogene og øges
    qXy.fx['xEne',t] = qXy.l['xEne',t] * (1 + 0.001 * {shock_profile}[t]); 
    qY.fx['udv',t] = qY.l['udv',t] * (1 + 0.001 * {shock_profile}[t]); 
    qGrus.fx[t] = qGrus.l[t] * (1 + 0.001 * {shock_profile}[t]); 

    # Eksogene størelser i GovRevenues, som følger BNP i grundforløb
    $UNFIX vOffFraUdlKap; $FIX rOffFraUdlKap2BNP;
    $UNFIX vOffFraUdlEU; $FIX rOffFraUdlEU2BNP;
    $UNFIX vOffFraUdlRest; $FIX rOffFraUdlRest2BNP;
    $UNFIX vOffFraHh; $FIX rOffFraHh2BNP;
    $UNFIX vOffFraVirk; $FIX rOffFraVirk2BNP;
    $UNFIX vOffVirk; $FIX rOffVirk2BNP;
    $UNFIX vRestFradragSats; $FIX uRestFradrag;

    # Eksogene størelser i GovExpenses, som følger BNP i grundforløb
    $UNFIX vOffLandKoeb; $FIX rOffLandKoeb2BNP;
    $UNFIX vOffTilUdlKap; $FIX rOffTilUdlKap2BNP;
    $UNFIX vOffTilUdlMoms; $FIX rOffTilUdlMoms2BNP;
    $UNFIX vOffTilUdlBNI; $FIX rOffTilUdlBNI2BNP;
    $UNFIX vOffTilUdlEU; $FIX rOffTilUdlEU2BNP;
    $UNFIX vOffTilUdlFO; $FIX rOffTilUdlFO2BNP;
    $UNFIX vOffTilUdlGL; $FIX rOffTilUdlGL2BNP;
    $UNFIX vOffTilUdlBistand; $FIX rOffTilUdlBistand2BNP;
    $UNFIX vOffTilVirk; $FIX rOffTilVirk2BNP;
    $UNFIX vOffTilHhKap; $FIX rOffTilHhKap2BNP;
    $UNFIX vOffTilHhNPISH; $FIX rOffTilHhNPISH2BNP;
    $UNFIX vOffTilHhTillaeg; $FIX rOffTilHhTillaeg2BNP;
    $UNFIX vOffTilHhRest; $FIX rOffTilHhRest2BNP;
    $UNFIX vSubEU; $FIX rSubEU2BNP;

    # Eksogene størelser i Government
    $UNFIX vOffAkt$((IndlAktier[portf_] or UdlAktier[portf_] or Bank[portf_] or Obl[portf_]) and tx0[t]); $FIX rOffAkt2BNP;
    vOffPasRest_FM.fx[t] = vOffPasRest_FM.l[t] * (1 + 0.001 * {shock_profile}[t]);  
    $UNFIX vOffPasRest; $FIX rOffPasRest2BNP;

    # Øvrige eksogene størelser
    vKolPensKorRest.fx[t] = vKolPensKorRest.l[t] * (1 + 0.001 * {shock_profile}[t]); 
  $ENDIF

  # ====================================================================================================================
  # FM multiplikatorer 
  # ====================================================================================================================
  # Offentligt varekøb
  $IF '{shock}' == 'Off_vare_FM':
    qR.fx['off',t]$(tx0[t]) = qR.l['off',t] + 0.01 * {shock_profile}[t] * vBNP.l[t] / pRE.l['off',t] * vR.l['off',t] / vRE.l['off',t];
    qE.fx['off',t]$(tx0[t]) = qE.l['off',t] + 0.01 * {shock_profile}[t] * vBNP.l[t] / pRE.l['off',t] * vE.l['off',t] / vRE.l['off',t];
  $ENDIF

  # Offentlig beskæftigelse
  $IF '{shock}' == 'Off_besk_FM':
    hL.fx['off',t]$(tx0[t]) = hL.l['off',t] + 0.01 * {shock_profile}[t] * vBNP.l[t] / (vLoensum.l['off',t] / hL.l['off',t]);
    hL.fx['off',t]$(tx0[t]) = hL.l['off',t];
    $UNFIX qG[g_,t]$(tx0[t] and gTot[g_]);
    $FIX qR$(off[r_] and tx0[t]);
  $ENDIF

  # Offentlig løn
  $IF '{shock}' == 'Off_lon_FM': 
    qProd.fx['off',t]$(tx0[t]) = qProd.l['off',t] * (1 + 0.01 * {shock_profile}[t] * vBNP.l[t] / vLoensum.l['off',t]);
    qProdHh_t.fx[t]$(tx0[t]) = qProdHh_t.l[t] * (1 + 0.01 * {shock_profile}[t] * vBNP.l[t] / vLoensum.l['off',t] * qProd.l['off',t] * hL.l['off',t] / (qProd.l[sTot,t] * hL.l[sTot,t]));
    qProdxDK.fx[t]$(tx0[t]) = qProdxDK.l[t] * (1 + 0.01 * {shock_profile}[t] * vBNP.l[t] / vLoensum.l['off',t] * qProd.l['off',t] * hL.l['off',t] / (qProd.l[sTot,t] * hL.l[sTot,t]));
    $UNFIX uProd$(off[s_]);
  $ENDIF

  # Offentlige investeringer
  $IF '{shock}' == 'Off_inv_FM':
    qI_s.fx['iM', 'off',t]$(tx0[t]) = qI_s.l['iM', 'off',t] + 0.01 * {shock_profile}[t] * vBNP.l[t] / pI_s.l['iM', 'off',t] * (vI_s.l['iM', 'off',t] / vI_s.l['itot', 'off',t]);
    qI_s.fx['iB', 'off',t]$(tx0[t]) = qI_s.l['iB', 'off',t] + 0.01 * {shock_profile}[t] * vBNP.l[t] / pI_s.l['iB', 'off',t] * (vI_s.l['iB', 'off',t] / vI_s.l['itot', 'off',t]);
  $ENDIF

  # Skattepligtige indkomstoverførsler (DREAM)
  $IF '{shock}' == 'Skattepligtig_indkomstoverforsel_FM':
      vOvfSats.fx[ovf,t]$(tx0[t] and not ubeskat[ovf]) = vOvfSats.l[ovf,t] * (1 + 0.01 * {shock_profile}[t] * vBNP.l[t] / (vOvf.l['tot',t] - sum(ubeskat, vOvf.l[ubeskat,t])));
      $UNFIX uvOvfSats[ovf,t]$(tx0[t] and not ubeskat[ovf]);
  $ENDIF

  # Ikke-skattepligtige indkomstoverførsler (DREAM)
  $IF '{shock}' == 'Ikke_skattepligtig_indkomstoverforsel_FM':
      vOvfSats.fx[ubeskat,t]$(tx0[t]) = vOvfSats.l[ubeskat,t] * (1 + 0.01 * {shock_profile}[t] * vBNP.l[t] / sum(ovf$ubeskat[ovf], vOvf.l[ovf,t]));
      $UNFIX uvOvfSats[ovf,t]$(tx0[t] and ubeskat[ovf]);
  $ENDIF

  # Subsidier: Produktsubsidier
  $IF '{shock}' == 'Varefordelt_subsidie_FM':
    rSub_m.fx[d,s,t]$(tx0[t] and vSub_m.l[d,s,t]<>0) = rSub_m.l[d,s,t] * (1 + 0.01 * {shock_profile}[t] * vBNP.l[t] / vSub.l[dTot,sTot,t]);
    rSub_y.fx[d,s,t]$(tx0[t] and vSub_y.l[d,s,t]<>0) = rSub_y.l[d,s,t] * (1 + 0.01 * {shock_profile}[t] * vBNP.l[t] / vSub.l[dTot,sTot,t]);
  $ENDIF

  # Subsidier: Løntilskud
  $IF '{shock}' == 'Lontilskud_FM':
    rSubLoen.fx[s,t]$(tx0[t]) = rSubLoen.l[s,t] * (1 + 0.01 * {shock_profile}[t] * vBNP.l[t] / vSubLoen.l['tot',t]);
  $ENDIF

  # Subsidier: Produktionssubsidier ekskl. løntilskud
  $IF '{shock}' == 'Produktionssubsidie_FM':
    vSubYRest.fx[s,t]$(tx0[t]) = vSubYRest.l[s,t] + 0.01 * {shock_profile}[t] * vBNP.l[t] * vSubYRest.l[s,t] / vSubYRest.l['tot',t];
    vSubYRest.fx[s,t]$(tx0[t]) = vSubYRest.l[s,t];
    $UNFIX rSubYRest[s,t]$(tx0[t]);
  $ENDIF

  # Overførsel til privat sektor
  $IF '{shock}' == 'Overforsel_privat_FM':
    vOffTilHhRest.fx[t]$(tx0[t]) = vOffTilHhRest.l[t] + 0.01 * {shock_profile}[t] * vBNP.l[t];
    vOffTilHhRest.fx[t]$(tx0[t]) = vOffTilHhRest.l[t];
  $ENDIF

  # Bundskat
  $IF '{shock}' == 'Bundskat_FM':
    tBund.fx[t]$(tx0[t]) = tBund.l[t] - 0.01 * {shock_profile}[t] * vBNP.l[t] / (vtBund.l['Tot',t] / tBund.l[t]);
  $ENDIF

  # AM-bidrag
  $IF '{shock}' == 'AM_bidrag_FM':
    tAMbidrag.fx[t]$(tx0[t]) = tAMbidrag.l[t] - 0.01 * {shock_profile}[t] * vBNP.l[t] / (vtHhAM.l['Tot',t] / tAMbidrag.l[t]);
  $ENDIF

  # Ejendomsskat = Grundskyld
  $IF '{shock}' == 'Ejendomsskat_FM':
    tK.fx[k,s,t]$(tx0[t] and iB[k]) = tK.l[k,s,t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtGrund.l['Tot',t]);
  $ENDIF

  # Vægtafgift
  $IF '{shock}' == 'Vaegtafgift_FM':
    utHhVaegt.fx[t]$(tx0[t]) = utHhVaegt.l[t] - 0.01 * {shock_profile}[t] * vBNP.l[t] / (vtHhVaegt.l['Tot',t] / utHhVaegt.l[t]);
  $ENDIF

  # Selskabsskat
  $IF '{shock}' == 'Selskabsskat_FM':
    tSelskab.fx[t]$(tx0[t]) = tSelskab.l[t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtSelskabx.l['Tot',t]);
  $ENDIF

  # Aktieskat
  $IF '{shock}' == 'Aktieskat_FM':
    tAktieTop.fx[t]$(tx0[t]) = tAktieTop.l[t] - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtAktie.l[t];
    tAktieLav.fx[t]$(tx0[t]) = tAktieLav.l[a] - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtAktie.l[t];
  $ENDIF

  # Moms
  $IF '{shock}' == 'Moms_FM':
    tMoms_y.fx[d,s,t]$(tx0[t]) = tMoms_y.l[d,s,t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtMoms.l[dtot,sTot,t]);
    tMoms_m.fx[d,s,t]$(tx0[t]) = tMoms_m.l[d,s,t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtMoms.l[dtot,sTot,t]);
  $ENDIF

  # Registreringsafgift
  $IF '{shock}' == 'Registreringsafgift_FM':
    tReg_y.fx['cBil',s,t]$(tx0[t] and tReg_y.l['cBil',s,t] <> 0) = tReg_y.l['cBil',s,t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtReg.l['cBil',sTot,t]) ;
    tReg_m.fx['cBil',s,t]$(tx0[t] and tReg_m.l['cBil',s,t] <> 0) = tReg_m.l['cBil',s,t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtReg.l['cBil',sTot,t]) ;
  $ENDIF

  # Energiafgift (cEne = cg + ce = benzin og olietil biler + brændsel og el)
  $IF '{shock}' == 'Energiafgift_FM':
    tAfg_y.fx['cEne',s,t]$(tx0[t]) = tAfg_y.l['cEne',s,t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtAfg.l['cEne','tot',t]);
    tAfg_m.fx['cEne',s,t]$(tx0[t]) = tAfg_m.l['cEne',s,t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtAfg.l['cEne','tot',t]);
  $ENDIF

  # Øvrige forbrugsafgifter (cVar = cf + cv = fødevarer, drikkevarer og tobak + øvrige varer)
  $IF '{shock}' == 'Forbrugsafgift_FM':
    tAfg_y.fx['cVar',s,t]$(tx0[t]) = tAfg_y.l['cVar',s,t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtAfg.l['cVar','tot',t]);
    tAfg_m.fx['cVar',s,t]$(tx0[t]) = tAfg_m.l['cVar',s,t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / vtAfg.l['cVar','tot',t]);
  $ENDIF

  # Afgift på private erhvervs materialeinput
  $IF '{shock}' == 'Afgift_erhverv_FM':
    tAfg_y.fx[r, s,t]$(tx0[t] and not off[r]) = tAfg_y.l[r,s,t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / (vtAfg.l[rTot,'tot',t] - vtAfg.l['off','tot',t])); 
    tAfg_m.fx[r, s,t]$(tx0[t] and not off[r]) = tAfg_m.l[r,s,t] * (1 - 0.01 * {shock_profile}[t] * vBNP.l[t] / (vtAfg.l[rTot,'tot',t] - vtAfg.l['off','tot',t]));
  $ENDIF
  
  # ====================================================================================================================
  # For stød, som ikke påvirker inputs i offentlig produktion, rykker qG sig kun pga. fejl i kædeindeks.
  # Vi eksogeniser derfor offentligt forbrug (og slår kædeligning fra med uL['off',t]).
  # ====================================================================================================================
  parameter public_inputs_fixed "Dummy, som er 1 hvis offentlige investeringer, beskæftigelse, og materialekøb er eksogene og unændrede i alle år.";
  public_inputs_fixed = prod(t$(tx0[t]),
    qI_s.up['iM','off',t] = qI_s_baseline['iM','off',t] # Eksogenitet tjekkes ved at teste om upper bound er sat lig værdi
    and
    hL.up['off',t] = hL_baseline['off',t]
    and
    qI_s.up['iB','off',t] = qI_s_baseline['iB','off',t]
    and
    qR.up['off',t] = qR_baseline['off',t]
    and
    qE.up['off',t] = qE_baseline['off',t]
  );
  $FIX qG$(gTot[g_] and tx0[t] and public_inputs_fixed);
  $UNFIX uL$(off[s_] and tx0[t] and public_inputs_fixed);

  # --------------------------------------------------------------------------------------------------------------------
  # Endogen udenlandsk økonomi shocks
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "rRente_foreign":
    $GROUP G_OilPrice_shock
      pM_correction[t] "Correction factor for total import price index"
    ;
    # load udenlandske stød-variable
    $GROUP G_IRF_FOREIGN
      dYF[t] "Real GDP deviations foreign economy"
      dRF[t] "Real interest rate deviations foreign economy"
      dPF[t] "Price level deviations foreign economy"
      qUSImports[t] "Imports foreign (US) economy"
    ;

    $PGROUP pG_IRF_FOREIGN
      dYF_[t] "Real GDP deviations foreign economy"
      dRF_[t] "Real interest rate deviations foreign economy"
      dPF_[t] "Price level deviations foreign economy"
      qUSImports_[t] "Imports foreign (US) economy"  
    ;
    execute_load "../../Foreign_Economy/Gdx/rstar_deviations.gdx"
      dYF_=dYF
      dRF_=dRF
      dPF_=dPF
    ;
    execute_load "../../Foreign_Economy/Gdx/VARrstar_yearly.gdx"
      qUSImports_=qUSImports
    ;
    # $IMPORT ../../Foreign_Economy/VAR_model/CPI_to_foreign_prices.gms
    # Stød til undenlandske variable
    rRenteECB.fx[t]$(tx0[t]) = rRenteECB.l[t] + dRF_[t];
    uXMarked.fx[t]$(tx0[t]) = uXMarked.l[t]*(1 + qUSImports_[t]);
    pXUdl.fx[x,t]$(tx0[t]) = pXUdl.l[x,t] + dPF_[t]; # inflation i udlandet
    pM.fx[s,t]$(tx0[t]) = pM.l[s,t] + dPF_[t]; # inflation i udlandet             
  $ENDIF
  # ====================================================================================================================
  # Solve shock (with or without tax reaction function)
  # ====================================================================================================================
  @set_bounds();

  MODEL M_{shock}_{variation_label} /
    M_shock
    $IF {tax_reaction}: B_tax_reaction $ENDIF
  /;

  @solve(M_{shock}_{variation_label})

  @unload(Gdx/{shock}_{variation_label});

  # ====================================================================================================================
  # Nulstød
  # ====================================================================================================================
  $IF "{shock}" == "Nulstoed":
    $GROUP G_ZeroShockTest All, -dArv;
    $FIX All; $UNFIX G_endo;
    @solve(M_base);
    @assert_no_difference(G_ZeroShockTest, 1e-5, .l, _baseline, "Zero shock changed variables significantly.");
  $ENDIF

  $ENDFOR2
$ENDFOR1