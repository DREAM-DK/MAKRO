# ======================================================================================================================
# Standard shocks
# ======================================================================================================================
$onDotL # Allow implicit .l suffix
$SETLOCAL shock_year 2030;

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
scalar shock_size "Shock size for shocks calibrated as a share of GDP (e.g. 1 pct. of GDP)" /0.01/;

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
    $GROUP G_shock_endo G_endo, vtLukning$({tax_reaction} and aTot[a_] and tx0[t]);

  # ====================================================================================================================
  # Define shocks below
  # Each shock is wrapped in an IF-statement based on the label of the shock
  # ====================================================================================================================

  # ====================================================================================================================
  # Offentligt forbrug
  # ====================================================================================================================
  # --------------------------------------------------------------------------------------------------------------------
  # Offentligt forbrug
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Offentligt_forbrug":
    qR['off',t]$(tx0[t]) = qR['off',t] * (1 + shock_size * {shock_profile}[t] * vBNP[t]/vG[gTot,t]);
    qE['off',t]$(tx0[t]) = qE['off',t] * (1 + shock_size * {shock_profile}[t] * vBNP[t]/vG[gTot,t]);
    hL['off',t]$(tx0[t]) = hL['off',t] * (1 + shock_size * {shock_profile}[t] * vBNP[t]/vG[gTot,t]);
    qI_s[i,'off',t]$(tx0[t]) = qI_s[i,'off',t] * (1 + shock_size * {shock_profile}[t] * vBNP[t]/vG[gTot,t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Offentligt varekøb - 1 pct. af vBNP med baseline deflatorer
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Offentlig_varekoeb":
    qR['off',t]$(tx0[t]) = qR['off',t] + shock_size * {shock_profile}[t] * vBNP[t] / pR['off',t];
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Offentlig beskæftigelse - 1 pct. af vBNP med baseline deflatorer
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Offentlig_Beskaeftigelse":
    hL['off',t]$(tx0[t]) = hL['off',t] * (1 + shock_size * {shock_profile}[t] * vBNP[t] / vLoensum['off',t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Offentlige investeringer - 1 pct. af vBNP med baseline deflatorer
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Offentlige_investeringer":
    qI_s[i,'off',t]$(tx0[t] and d1I_s[i,'off',t])
      = qI_s[i,'off',t]
      + shock_size * {shock_profile}[t] * vBNP[t]/pI_s[i,'off',t] * (vI_s[i,'off',t] / vI_s['itot','off',t]);
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
    qProdHh_t[t]$(tx0[t]) = qProdHh_t[t] * (1 + shock_size * {shock_profile}[t] * vBNP[t] / vLoensum['off',t]
                             * qProd['off',t] * hL['off',t]  / (qProd[sTot,t] * hL[sTot,t]));
    qProdxDK[t]$(tx0[t]) = qProdxDK[t] * (1 + shock_size * {shock_profile}[t] * vBNP[t] / vLoensum['off',t]
                            * qProd['off',t] * hL['off',t]  / (qProd[sTot,t] * hL[sTot,t]));

    qProd['off',t]$(tx0[t]) = qProd['off',t] * (1 + shock_size * {shock_profile}[t] * vBNP[t] / vLoensum['off',t]);
  $ENDIF

  # ====================================================================================================================
  # Offentlige overførsler
  # ====================================================================================================================
  # --------------------------------------------------------------------------------------------------------------------
  # Skattepligtige indkomstoverførsler 
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Skattepligtig_indkomstoverforsel":
    vOvfSats[ovf,t]$(tx0[t] and not ubeskat[ovf])
      = vOvfSats[ovf,t] * (1 + shock_size * {shock_profile}[t] * vBNP[t] / sum(ubeskat, vOvf[ubeskat,t]));
    $GROUP+ G_shock_endo
      -vOvfSats[ovf,t]$(tx0[t] and not ubeskat[ovf]), uvOvfSats[ovf,t]$(tx0[t] and not ubeskat[ovf]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Ikke-skattepligtige indkomstoverførsler
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Ikke_skattepligtig_indkomstoverforsel":
    vOvfSats[ubeskat,t]$(tx0[t])
      = vOvfSats[ubeskat,t] * (1 + shock_size * {shock_profile}[t] * vBNP[t] / sum(ovf$ubeskat[ovf], vOvf[ovf,t]));
    $GROUP+ G_shock_endo
      -vOvfSats[ubeskat,t]$(tx0[t]), uvOvfSats[ovf,t]$(tx0[t] and ubeskat[ovf]);
  $ENDIF

  # ====================================================================================================================
  # Subsidier
  # ====================================================================================================================
  # --------------------------------------------------------------------------------------------------------------------
  # Produktsubsidier
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Produktsubsidier":
    rSub_m[d,s,t]$(tx0[t]) = rSub_m[d,s,t] * (1 + shock_size * {shock_profile}[t] * vBNP[t] / vSub[dTot,sTot,t]);
    rSub_y[d,s,t]$(tx0[t]) = rSub_y[d,s,t] * (1 + shock_size * {shock_profile}[t] * vBNP[t] / vSub[dTot,sTot,t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Løntilskud
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Lontilskud":
    rSubLoen[s,t]$(tx0[t]) = rSubLoen[s,t] * (1 + shock_size * {shock_profile}[t] * vBNP[t] / vSubLoen['tot',t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Produktionssubsidier ekskl. løntilskud
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Produktionssubsidier":
    vSubYRest[s,t]$(tx0[t]) = vSubYRest[s,t] * ( 1 + shock_size * {shock_profile}[t] * vBNP[t] / vSubYRest[sTot,t]);
    $GROUP+ G_shock_endo
      -vSubYRest[s,t]$(tx0[t]), rSubYRest[s,t]$(tx0[t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Øvrige overførsler til husholdninger
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Overforsel_privat":
    vOffTilHhRest[ t]$(tx0[t]) = vOffTilHhRest[t] + shock_size * {shock_profile}[t] * vBNP[t];
  $ENDIF

  # ====================================================================================================================
  # Skatter
  # ====================================================================================================================
  # --------------------------------------------------------------------------------------------------------------------
  # Bundskat - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Bundskat":
    tBund[t]$(tx0[t]) = tBund[t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtBund['tot',t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # AM-bidrag - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "AM_bidrag":
    tAMbidrag[t]$(tx0[t])  = tAMbidrag[t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtHhAM['Tot',t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Grundskyld - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Grundskyld":
    tGrund[s,t]$(tx0[t] and d1K['iB',s,t])
      = tGrund[s,t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtGrund['Tot',t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Ejendomsværdiskat - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Ejendomsvaerdiskat":
    tEjd[t]$(tx0[t]) = tEjd[t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtEjd[aTot,t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Vægtafgift - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Vaegtafgift":
    utHhVaegt[t]$(tx0[t])
      = utHhVaegt[t] * (1 - shock_size * {shock_profile}[t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Selskabsskat - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Selskabsskat":
    tSelskab[t]$(tx0[t]) = tSelskab[t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtSelskabx['Tot',t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Aktieskat - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Aktieskat":
    tAktieTop[t]$(tx0[t]) = tAktieTop[t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtAktie[t]);
    tAktieLav[t]$(tx0[t]) = tAktieLav[t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtAktie[t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Moms - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Moms":
    tMoms_y[d,s,t]$(tx0[t]) = tMoms_y[d,s,t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtMoms[dtot,sTot,t]);
    tMoms_m[d,s,t]$(tx0[t]) = tMoms_m[d,s,t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtMoms[dtot,sTot,t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Registreringsafgift til privat forbrug - 0,5 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Registreringsafgift":
    tReg_m[d,s,t]$(tx0[t]) = tReg_m[d,s,t] * (1 - shock_size/2 * {shock_profile}[t] * vBNP[t] / vtReg['cBil','tot',t]);
    tReg_y[d,s,t]$(tx0[t]) = tReg_y[d,s,t] * (1 - shock_size/2 * {shock_profile}[t] * vBNP[t] / vtReg['cBil','tot',t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Energiafgift til privat forbrug - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Energiafgift":
    tAfg_y['cEne',s,t]$(tx0[t])
      = tAfg_y['cEne',s,t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtAfg['cEne','tot',t]);
    tAfg_m['cEne',s,t]$(tx0[t])
      = tAfg_m['cEne',s,t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtAfg['cEne','tot',t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Øvrige forbrugsafgifter - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Forbrugsafgift":
    tAfg_y['cVar',s,t]$(tx0[t])
      = tAfg_y['cVar',s,t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtAfg['cVar','tot',t]);
    tAfg_m['cVar',s,t]$(tx0[t])
      = tAfg_m['cVar',s,t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtAfg['cVar','tot',t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Afgift på private erhvervs materialeinput - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Afgift_erhverv":
    tAfg_y[r,s,t]$(tx0[t] and sp[s])
      = tAfg_y[r,s,t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / (vtAfg[rTot,sTot,t] - vtAfg['off',sTot,t])); 
    tAfg_m[r,s,t]$(tx0[t] and sp[s])
      = tAfg_m[r,s,t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / (vtAfg[rTot,sTot,t] - vtAfg['off',sTot,t]));
  $ENDIF

  # ======================================================================================================================
  # Udland
  # ======================================================================================================================
  # --------------------------------------------------------------------------------------------------------------------
  # Eksportmarkedsvækst - 1 pct. af BNP
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Eksportmarkedsvaekst":
    uXMarked[t]$(tx0[t]) = uXMarked[t] * (1 + shock_size * {shock_profile}[t] * vBNP[t] / vX[xTot,t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Importpris - 1 pct.
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Importpris":
    pM[s,t]$(tx0[t]) = pM[s,t] * (1 + 0.01 * {shock_profile}[t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Eksportkonkurrerende priser - 1 pct.
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Eksportkonkurrerende_priser":
    pXUdl[x,t]$(tx0[t]) = pXUdl[x,t] * (1 + 0.01 * {shock_profile}[t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Oliepris - 10 pct.
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Oliepris":
    pOlieBrent[t]$(tx0[t]) = pOlieBrent[t] * (1 + 0.10 * {shock_profile}[t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Direkte stød til alle importpriser og eksportkonkurrerende priser - 1 pct.
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Udenlandske_priser":
    pM[s,t]$(tx0[t]) = pM[s,t] * (1 + 0.01 * {shock_profile}[t]);
    pXUdl[x,t]$(tx0[t]) = pXUdl[x,t] * (1 + 0.01 * {shock_profile}[t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Rente - 1 pct.-point i 2 perioder før aftrapning
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Rente":
    rRenteECB[t]$(t1[t]) = rRenteECB[t] + 0.01;
    rRenteECB[t]$(tx1[t]) = rRenteECB[t] + 0.01 * {shock_profile}[t-1];
  $ENDIF

  # ====================================================================================================================
  # Øvrige udbudsstød
  # ====================================================================================================================
  # --------------------------------------------------------------------------------------------------------------------
  # Arbejdsudbud, strukturel beskæftigelse - 1 pct.
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Arbejdsudbud_beskaeftigelse":
    snLHh[a,t]$(tx0[t] and a15t100[a]) = snLHh[a,t] * (1 + 0.01 * {shock_profile}[t]);
    $GROUP+ G_shock_endo
      -snLHh[a,t]$(tx0[t] and a15t100[a]), uDeltag[a,t]$(tx0[t] and a15t100[a]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Arbejdsudbud,timer - 1 pct.
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Arbejdsudbud_timer":
    shLHh[a,t]$(tx0[t] and a15t100[a]) = shLHh[a,t] * (1 + 0.01 * {shock_profile}[t]);
    $GROUP+ G_shock_endo
      -shLHh[a,t]$(tx0[t] and a15t100[a]), uh[a,t]$(tx0[t] and a15t100[a]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Arbejdsudbud,timer - kohort for 30-årige - 1 pct.
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Arbejdsudbud_timer_kohort_30":
      parameter target_birth_year;
      target_birth_year = %shock_year% - 30;
      shLHh[a,t]$(tx0[t] and a15t100[a] and (t.val - a.val) = target_birth_year and a.val < 70) 
          = shLHh[a,t] * (1 + 0.01 * {shock_profile}[t]);
      $GROUP+ G_shock_endo
        -shLHh[a,t]$(tx0[t] and a15t100[a] and (t.val - a.val) = target_birth_year and a.val < 70), uh[a,t]$(tx0[t] and a15t100[a] and (t.val - a.val) = target_birth_year and a.val < 70);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Arbejdsudbud,timer - alder 30 - 1 pct.
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Arbejdsudbud_timer_alder_30":
      shLHh[a,t]$(tx0[t] and a.val = 30) 
          = shLHh[a,t] * (1 + 0.01 * {shock_profile}[t]);
      $GROUP+ G_shock_endo
        -shLHh[a,t]$(tx0[t] and a.val = 30), uh[a,t]$(tx0[t] and a.val = 30);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Befolkning - 1 pct.
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Befolkning":
    nPop[a,t]$(tx0[t]) = nPop[a,t] * (1 + 0.01 * {shock_profile}[t]);
    nSoegBasexDK[t]$(tx0[t]) = nSoegBasexDK[t] * (1 + 0.01 * {shock_profile}[t]);
    qG[gTot,t]$(tx0[t]) = qG[gTot,t] * (1 + 0.01 * {shock_profile}[t]);
    $GROUP+ G_shock_endo
      -uvGInd$(tx0[t]), hL$(off[s_] and tx0[t])
      -rOffK2Y, qI_s$(off[s_] and tx0[t])
      -rOffLoensum2R, qR$(off[r_] and tx0[t])
      -rOffLoensum2E, qE$(off[r_] and tx0[t])
    ;
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Arbejdskraftsproduktivitet - 1 pct. arbejdskraftbesparende teknologiske fremskridt
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "ArbejdsProd":
    qProdHh_t[t]$(tx0[t]) = qProdHh_t[t] * (1 + 0.01 * {shock_profile}[t]);
    qProdxDK[t]$(tx0[t]) = qProdxDK[t] * (1 + 0.01 * {shock_profile}[t]);
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Kapitalproduktivitet - 1 pct. arbejdskraftbesparende teknologiske fremskridt
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "KapitalProd":
    uK['iM',sp,t]$(tx0[t]) = uK['iM',sp,t] * (1 + 0.01 * {shock_profile}[t])**(eKEL[sp]-1);
    uK['iB',sp,t]$(tx0[t]) = uK['iB',sp,t] * (1 + 0.01 * {shock_profile}[t])**(eKELB[sp]-1);
  $ENDIF

  # ====================================================================================================================
  # Risiko-præmier
  # ====================================================================================================================
  # --------------------------------------------------------------------------------------------------------------------
  # Virksomhedernes hurdle rate
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "VirkDisk":
    rVirkDiskPrem[sp,t]$(tx0[t]) = rVirkDiskPrem[sp,t] + 0.001 * {shock_profile}[t];
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Husholdningernes opfattede risiko-præmie i usercost på bolig
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "BoligRisiko":
    rBoligPrem[t]$(tx0[t]) = rBoligPrem[t] + 0.001 * {shock_profile}[t];
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Virksomhedernes hurdle rate og aktieafkastrater
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "AktieAfkast":
    rVirkDiskPrem[sp,t]$(tx0[t]) = rVirkDiskPrem[sp,t] + 0.001 * {shock_profile}[t];
    rAktieDriftPrem[t]$(tx0[t]) = rAktieDriftPrem[t] + 0.001 * {shock_profile}[t];
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Risikopræmier på aktier, bolig, og virksomhedens hurdle rate
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "RisikoPraemier":
    rVirkDiskPrem[sp,t]$(tx0[t]) = rVirkDiskPrem[sp,t] + 0.001 * {shock_profile}[t];
    rAktieDriftPrem[t]$(tx0[t]) = rAktieDriftPrem[t] + 0.001 * {shock_profile}[t];
    rBoligPrem[t]$(tx0[t]) = rBoligPrem[t] + 0.001 * {shock_profile}[t];
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Husholdningernes diskonteringsfaktor
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Diskontering":
    jfDisk_t[t]$(tx0[t]) = jfDisk_t[t] - 0.001 * {shock_profile}[t];
  $ENDIF

  # --------------------------------------------------------------------------------------------------------------------
  # Lønmodtagernes forhandlingsstyrke
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Loen":
    rLoenNash[t]$(tx0[t]) = rLoenNash[t] - 0.01 * {shock_profile}[t];
  $ENDIF

  # ====================================================================================================================
  # Homogenitet
  # ====================================================================================================================
  # --------------------------------------------------------------------------------------------------------------------
  # Prisneutralitet
  # --------------------------------------------------------------------------------------------------------------------
  $IF "{shock}" == "Prisneutralitet":
    # Udenlandske priser øges
    pM[s,t]$(tx0[t]) = pM[s,t] * (1 + 0.01 * {shock_profile}[t]);
    pXUdl[x,t]$(tx0[t]) = pXUdl[x,t] * (1 + 0.01 * {shock_profile}[t]);

    # Omvurderinger antages at følge priser
    rOmv['Guld',t]$tx0[t] = rOmv['Guld',t] + 0.01 * ({shock_profile}[t] - {shock_profile}[t-1]); 
    rOmv['UdlAktier',t]$tx0[t] = rOmv['UdlAktier',t] + 0.01 * ({shock_profile}[t] - {shock_profile}[t-1]); 

    # Den nominalle rente skal også stige i de periode, hvor inflationen er høj
    rRenteECB[t]$tx0[t] = rRenteECB[t] + 0.01 * ({shock_profile}[t] - {shock_profile}[t-1]); 

    # Eksogene størelser i GovRevenues, som følger BNP i grundforløb
    # Eksogene størelser i GovExpenses, som følger BNP i grundforløb
    $GROUP+ G_shock_endo
      -rOffFraUdlKap2BNP, vOffFraUdlKap
      -rOffFraUdlEU2BNP, vOffFraUdlEU
      -rOffFraUdlRest2BNP, vOffFraUdlRest
      -rOffFraHh2BNP, vOffFraHh
      -rOffFraVirk2BNP, vOffFraVirk
      -rOffVirk2BNP, vOffVirk
      -uRestFradrag, vRestFradragSats
      -rOffLandKoeb2BNP, vOffLandKoeb
      -rOffTilUdlKap2BNP, vOffTilUdlKap
      -rOffTilUdlMoms2BNP, vOffTilUdlMoms
      -rOffTilUdlBNI2BNP, vOffTilUdlBNI
      -rOffTilUdlEU2BNP, vOffTilUdlEU
      -rOffTilUdlFO2BNP, vOffTilUdlFO
      -rOffTilUdlGL2BNP, vOffTilUdlGL
      -rOffTilUdlBistand2BNP, vOffTilUdlBistand
      -rOffTilVirk2BNP, vOffTilVirk
      -rOffTilHhKap2BNP, vOffTilHhKap
      -rOffTilHhNPISH2BNP, vOffTilHhNPISH
      -rOffTilHhTillaeg2BNP, vOffTilHhTillaeg
      -rOffTilHhRest2BNP, vOffTilHhRest
      -rSubEU2BNP, vSubEU
    ;

    # Eksogene størelser i Government
    vOffPasRest_FM[t] = vOffPasRest_FM[t] * (1 + 0.01 * {shock_profile}[t]);
    $GROUP+ G_shock_endo
      -rOffAkt2BNP, vOffAkt$((IndlAktier[portf_] or UdlAktier[portf_] or Bank[portf_] or Obl[portf_]) and tx0[t])
      -rOffPasRest2BNP, vOffPasRest
    ;

    # Øvrige eksogene størelser
    vKolPensKorRest[t] = vKolPensKorRest[t] * (1 + 0.01 * {shock_profile}[t]); 
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
    nPop[a,t] = nPop[a,t] * (1 + 0.001 * {shock_profile}[t]);
    nSoegBasexDK[t] = nSoegBasexDK[t] * (1 + 0.001 * {shock_profile}[t]);
    nPop_Over100[t] = nPop_Over100[t] * (1 + 0.001 * {shock_profile}[t]);

    # Offentligt forbrug
    hL['off',t] = hL['off',t] * (1 + 0.001 * {shock_profile}[t]); 
    qI_s[i,'off',t] = qI_s[i,'off',t] * (1 + 0.001 * {shock_profile}[t]); 
    qR['off',t] = qR['off',t] * (1 + 0.001 * {shock_profile}[t]); 
    qE['off',t] = qE['off',t] * (1 + 0.001 * {shock_profile}[t]); 

    # Land og lejeboliger øges
    qLand[t] = qLand[t] * (1 + 0.001 * {shock_profile}[t]); 
    qKLejeBolig[t]$(t0[t]) = qKLejeBolig[t] * (1 + 0.001 * {shock_profile}[t]); 
    qILejeBolig[t] = qILejeBolig[t] * (1 + 0.001 * {shock_profile}[t]); 

    # Produktionen i udvindingsbranchen og eksport af energi er eksogene og øges
    qXy['xEne',t] = qXy['xEne',t] * (1 + 0.001 * {shock_profile}[t]); 
    qY['udv',t] = qY['udv',t] * (1 + 0.001 * {shock_profile}[t]); 
    qGrus[t] = qGrus[t] * (1 + 0.001 * {shock_profile}[t]); 

    # Eksogene størelser i GovRevenues, som følger BNP i grundforløb
    # Eksogene størelser i GovExpenses, som følger BNP i grundforløb
    $GROUP+ G_shock_endo
      -rOffFraUdlKap2BNP, vOffFraUdlKap
      -rOffFraUdlEU2BNP, vOffFraUdlEU
      -rOffFraUdlRest2BNP, vOffFraUdlRest
      -rOffFraHh2BNP, vOffFraHh
      -rOffFraVirk2BNP, vOffFraVirk
      -rOffVirk2BNP, vOffVirk
      -uRestFradrag, vRestFradragSats
      -rOffLandKoeb2BNP, vOffLandKoeb
      -rOffTilUdlKap2BNP, vOffTilUdlKap
      -rOffTilUdlMoms2BNP, vOffTilUdlMoms
      -rOffTilUdlBNI2BNP, vOffTilUdlBNI
      -rOffTilUdlEU2BNP, vOffTilUdlEU
      -rOffTilUdlFO2BNP, vOffTilUdlFO
      -rOffTilUdlGL2BNP, vOffTilUdlGL
      -rOffTilUdlBistand2BNP, vOffTilUdlBistand
      -rOffTilVirk2BNP, vOffTilVirk
      -rOffTilHhKap2BNP, vOffTilHhKap
      -rOffTilHhNPISH2BNP, vOffTilHhNPISH
      -rOffTilHhTillaeg2BNP, vOffTilHhTillaeg
      -rOffTilHhRest2BNP, vOffTilHhRest
      -rSubEU2BNP, vSubEU
    ;

    # Eksogene størelser i Government
    vOffPasRest_FM[t] = vOffPasRest_FM[t] * (1 + 0.001 * {shock_profile}[t]);  
    $GROUP+ G_shock_endo
      -rOffAkt2BNP, vOffAkt$((IndlAktier[portf_] or UdlAktier[portf_] or Bank[portf_] or Obl[portf_]) and tx0[t])
      -rOffPasRest2BNP, vOffPasRest
    ;

    # Øvrige eksogene størelser
    vKolPensKorRest[t] = vKolPensKorRest[t] * (1 + 0.001 * {shock_profile}[t]); 
  $ENDIF

  # ====================================================================================================================
  # FM multiplikatorer 
  # ====================================================================================================================
  # Offentligt varekøb
  $IF '{shock}' == 'Off_vare_FM':
    qR['off',t]$(tx0[t]) = qR['off',t] + shock_size * {shock_profile}[t] * vBNP[t] / pRE['off',t] * vR['off',t] / vRE['off',t];
    qE['off',t]$(tx0[t]) = qE['off',t] + shock_size * {shock_profile}[t] * vBNP[t] / pRE['off',t] * vE['off',t] / vRE['off',t];
  $ENDIF

  # Offentlig beskæftigelse
  $IF '{shock}' == 'Off_besk_FM':
    hL['off',t]$(tx0[t]) = hL['off',t] + shock_size * {shock_profile}[t] * vBNP[t] / (vLoensum['off',t] / hL['off',t]);
    hL['off',t]$(tx0[t]) = hL['off',t];
    $GROUP+ G_shock_endo
      qG[g_,t]$(tx0[t] and gTot[g_]);
  $ENDIF

  # Offentlig løn
  $IF '{shock}' == 'Off_lon_FM': 
    qProd['off',t]$(tx0[t]) = qProd['off',t] * (1 + shock_size * {shock_profile}[t] * vBNP[t] / vLoensum['off',t]);
    qProdHh_t[t]$(tx0[t]) = qProdHh_t[t] * (1 + shock_size * {shock_profile}[t] * vBNP[t] / vLoensum['off',t] * qProd['off',t] * hL['off',t] / (qProd[sTot,t] * hL[sTot,t]));
    qProdxDK[t]$(tx0[t]) = qProdxDK[t] * (1 + shock_size * {shock_profile}[t] * vBNP[t] / vLoensum['off',t] * qProd['off',t] * hL['off',t] / (qProd[sTot,t] * hL[sTot,t]));
  $ENDIF

  # Offentlige investeringer
  $IF '{shock}' == 'Off_inv_FM':
    qI_s['iM', 'off',t]$(tx0[t]) = qI_s['iM', 'off',t] + shock_size * {shock_profile}[t] * vBNP[t] / pI_s['iM', 'off',t] * (vI_s['iM', 'off',t] / vI_s['itot', 'off',t]);
    qI_s['iB', 'off',t]$(tx0[t]) = qI_s['iB', 'off',t] + shock_size * {shock_profile}[t] * vBNP[t] / pI_s['iB', 'off',t] * (vI_s['iB', 'off',t] / vI_s['itot', 'off',t]);
  $ENDIF

  # Skattepligtige indkomstoverførsler (DREAM)
  $IF '{shock}' == 'Skattepligtig_indkomstoverforsel_FM':
      vOvfSats[ovf,t]$(tx0[t] and not ubeskat[ovf]) = vOvfSats[ovf,t] * (1 + shock_size * {shock_profile}[t] * vBNP[t] / (vOvf['tot',t] - sum(ubeskat, vOvf[ubeskat,t])));
      $GROUP+ G_shock_endo
        -vOvfSats[ovf,t]$(tx0[t] and not ubeskat[ovf]), uvOvfSats[ovf,t]$(tx0[t] and not ubeskat[ovf]);
  $ENDIF

  # Ikke-skattepligtige indkomstoverførsler (DREAM)
  $IF '{shock}' == 'Ikke_skattepligtig_indkomstoverforsel_FM':
      vOvfSats[ubeskat,t]$(tx0[t]) = vOvfSats[ubeskat,t] * (1 + shock_size * {shock_profile}[t] * vBNP[t] / sum(ovf$ubeskat[ovf], vOvf[ovf,t]));
      $GROUP+ G_shock_endo
        -vOvfSats[ubeskat,t]$(tx0[t]), uvOvfSats[ovf,t]$(tx0[t] and ubeskat[ovf]);
  $ENDIF

  # Subsidier: Produktsubsidier
  $IF '{shock}' == 'Varefordelt_subsidie_FM':
    rSub_m[d,s,t]$(tx0[t] and vSub_m[d,s,t]<>0) = rSub_m[d,s,t] * (1 + shock_size * {shock_profile}[t] * vBNP[t] / vSub[dTot,sTot,t]);
    rSub_y[d,s,t]$(tx0[t] and vSub_y[d,s,t]<>0) = rSub_y[d,s,t] * (1 + shock_size * {shock_profile}[t] * vBNP[t] / vSub[dTot,sTot,t]);
  $ENDIF

  # Subsidier: Løntilskud
  $IF '{shock}' == 'Lontilskud_FM':
    rSubLoen[s,t]$(tx0[t]) = rSubLoen[s,t] * (1 + shock_size * {shock_profile}[t] * vBNP[t] / vSubLoen['tot',t]);
  $ENDIF

  # Subsidier: Produktionssubsidier ekskl. løntilskud
  $IF '{shock}' == 'Produktionssubsidie_FM':
    vSubYRest[s,t]$(tx0[t]) = vSubYRest[s,t] + shock_size * {shock_profile}[t] * vBNP[t] * vSubYRest[s,t] / vSubYRest['tot',t];
    vSubYRest[s,t]$(tx0[t]) = vSubYRest[s,t];
    $GROUP+ G_shock_endo
      -vSubYRest[s,t]$(tx0[t]), rSubYRest[s,t]$(tx0[t]);
  $ENDIF

  # Overførsel til privat sektor
  $IF '{shock}' == 'Overforsel_privat_FM':
    vOffTilHhRest[t]$(tx0[t]) = vOffTilHhRest[t] + shock_size * {shock_profile}[t] * vBNP[t];
    vOffTilHhRest[t]$(tx0[t]) = vOffTilHhRest[t];
  $ENDIF

  # Bundskat
  $IF '{shock}' == 'Bundskat_FM':
    tBund[t]$(tx0[t]) = tBund[t] - shock_size * {shock_profile}[t] * vBNP[t] / (vtBund['Tot',t] / tBund[t]);
  $ENDIF

  # AM-bidrag
  $IF '{shock}' == 'AM_bidrag_FM':
    tAMbidrag[t]$(tx0[t]) = tAMbidrag[t] - shock_size * {shock_profile}[t] * vBNP[t] / (vtHhAM['Tot',t] / tAMbidrag[t]);
  $ENDIF

  # Ejendomsskat = Grundskyld
  $IF '{shock}' == 'Ejendomsskat_FM':
    tK[k,s,t]$(tx0[t] and iB[k]) = tK[k,s,t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtGrund['Tot',t]);
  $ENDIF

  # Vægtafgift
  $IF '{shock}' == 'Vaegtafgift_FM':
    utHhVaegt[t]$(tx0[t]) = utHhVaegt[t] - shock_size * {shock_profile}[t] * vBNP[t] / (vtHhVaegt['Tot',t] / utHhVaegt[t]);
  $ENDIF

  # Selskabsskat
  $IF '{shock}' == 'Selskabsskat_FM':
    tSelskab[t]$(tx0[t]) = tSelskab[t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtSelskabx['Tot',t]);
  $ENDIF

  # Aktieskat
  $IF '{shock}' == 'Aktieskat_FM':
    tAktieTop[t]$(tx0[t]) = tAktieTop[t] - shock_size * {shock_profile}[t] * vBNP[t] / vtAktie[t];
    tAktieLav[t]$(tx0[t]) = tAktieLav[a] - shock_size * {shock_profile}[t] * vBNP[t] / vtAktie[t];
  $ENDIF

  # Moms
  $IF '{shock}' == 'Moms_FM':
    tMoms_y[d,s,t]$(tx0[t]) = tMoms_y[d,s,t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtMoms[dtot,sTot,t]);
    tMoms_m[d,s,t]$(tx0[t]) = tMoms_m[d,s,t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtMoms[dtot,sTot,t]);
  $ENDIF

  # Registreringsafgift
  $IF '{shock}' == 'Registreringsafgift_FM':
    tReg_y['cBil',s,t]$(tx0[t] and tReg_y['cBil',s,t] <> 0) = tReg_y['cBil',s,t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtReg['cBil',sTot,t]) ;
    tReg_m['cBil',s,t]$(tx0[t] and tReg_m.xl['cBil',s,t] <> 0) = tReg_m['cBil',s,t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtReg['cBil',sTot,t]) ;
  $ENDIF

  # Energiafgift (cEne = cg + ce = benzin og olietil biler + brændsel og el)
  $IF '{shock}' == 'Energiafgift_FM':
    tAfg_y['cEne',s,t]$(tx0[t]) = tAfg_y['cEne',s,t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtAfg['cEne','tot',t]);
    tAfg_m['cEne',s,t]$(tx0[t]) = tAfg_m['cEne',s,t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtAfg['cEne','tot',t]);
  $ENDIF

  # Øvrige forbrugsafgifter (cVar = cf + cv = fødevarer, drikkevarer og tobak + øvrige varer)
  $IF '{shock}' == 'Forbrugsafgift_FM':
    tAfg_y['cVar',s,t]$(tx0[t]) = tAfg_y['cVar',s,t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtAfg['cVar','tot',t]);
    tAfg_m['cVar',s,t]$(tx0[t]) = tAfg_m['cVar',s,t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / vtAfg['cVar','tot',t]);
  $ENDIF

  # Afgift på private erhvervs materialeinput
  $IF '{shock}' == 'Afgift_erhverv_FM':
    tAfg_y[r, s,t]$(tx0[t] and not off[r]) = tAfg_y[r,s,t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / (vtAfg[rTot,'tot',t] - vtAfg['off','tot',t])); 
    tAfg_m[r, s,t]$(tx0[t] and not off[r]) = tAfg_m[r,s,t] * (1 - shock_size * {shock_profile}[t] * vBNP[t] / (vtAfg[rTot,'tot',t] - vtAfg['off','tot',t]));
  $ENDIF

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
    rRenteECB[t]$(tx0[t]) = rRenteECB[t] + dRF_[t];
    uXMarked[t]$(tx0[t]) = uXMarked[t]*(1 + qUSImports_[t]);
    pXUdl[x,t]$(tx0[t]) = pXUdl[x,t] + dPF_[t]; # inflation i udlandet
    pM[s,t]$(tx0[t]) = pM[s,t] + dPF_[t]; # inflation i udlandet             
  $ENDIF
  # ====================================================================================================================
  # Solve shock (with or without tax reaction function)
  # ====================================================================================================================
  MODEL M_{shock}_{variation_label} /
    M_shock
    $IF {tax_reaction}: B_tax_reaction $ENDIF
  /;

  # Reduce shock size by a factor of 100 to make solving easier
  @set_linear_combination(All, 0.01, .l, _baseline);
  $FIX All; $UNFIX G_shock_endo;
  @solve(M_{shock}_{variation_label})
  # Set all variables to baseline plus 100 times the difference between the solution and the baseline
  @set_linear_combination(All, 100, .l, _baseline);
  $FIX All; $UNFIX G_shock_endo;
  @solve(M_{shock}_{variation_label})

  $UNFIX All; # Greatly reduces size of the GDX file
  @unload(Gdx/{shock}_{variation_label});

  # ====================================================================================================================
  # Nulstød
  # ====================================================================================================================
  $IF "{shock}" == "Nulstoed":
    @assert_no_difference(All, 1e-5, .l, _baseline, "Zero shock changed variables significantly.");
  $ENDIF

  $ENDFOR2
$ENDFOR1