# ======================================================================================================================
# Sets of demand components and sectors
# ======================================================================================================================

# ----------------------------------------------------------------------------------------------------------------------
# Basis sets - disse sets bruges ikke direkte, men anvendes til definition af andre sets
# ----------------------------------------------------------------------------------------------------------------------
SETS
  private_brancher /
    tje "Private tjenester ekskl. søtransport"
    fre "Fremstilling ekskl. energi"
    byg "Byggeri og anlæg"
    lan "Landbrug og fiskeri"
    soe "Søtransport"
    bol "Bolig"
    ene "Energi"
    udv "Udvinding"
  /

  offentlige_brancher /
    off "Offentlig"
  /

  brancher / set.private_brancher, set.offentlige_brancher /

  efterspoergsel_totaler /
    dTot "Total af alt efterspørgsel."
    xTot "Samlet eksport"
    cTot "Samlet privat forbrug."
    gTot "Samlet offentligt forbrug"
    iTot "Samlede investeringer."
  /

  eksportgrupper /
    xEne "Eksport af energivarer - SITC 3." 
    xVar "Eksport af varer ekskl. energi." 
    xSoe "Eksport af søtransport." 
    xTje "Eksport af tjenester ekskl. søtransport og turistindtægter." 
    xTur "Turistindtægter (eksport)."
  /

  privat_forbrug /
    cBol "Bolig"
    cBil "Biler"
    cEne "Energi"
    cVar "Varer"
    cTje "Tjenester"
    cTur "Turisme"
  /
  privat_forbrug_nests /
    cTurTje       "Consumption nest - tourism and services"
    cTurTjeVar    "Consumption nest - tourism, services, and goods"
    cTurTjeVarEne "Consumption nest - tourism, services, goods, and energy"
    cIkkeBol      "Consumption nest - Non-housing"
  /

  offentligt_forbrug /
    g "All public consumption (to be split up later)"
  /

  investeringstyper /
    iB "Bygningsinvesteringer"
    iM "Maskininvesteringer"
    iL "Lagerinvesteringer"
  /
;

# ----------------------------------------------------------------------------------------------------------------------
# Efterspørgselskomponenter
# ----------------------------------------------------------------------------------------------------------------------
SETS
  d_ "Efterspørgselskomponenter inklusiv total og deltotaler" /
    tot "Total af alle brancher"
    spTot "Total af private brancher"
    spxTot "Total af private brancher ekskl. boligbranchen"
    sByTot "Total af private byerhverv"
    set.efterspoergsel_totaler
    set.brancher
    set.eksportgrupper
    set.privat_forbrug
    set.offentligt_forbrug
    set.investeringstyper
    set.privat_forbrug_nests
  /

  d[d_] "Efterspørgselskomponenter" /
    set.brancher
    set.eksportgrupper
    set.privat_forbrug
    set.offentligt_forbrug
    set.investeringstyper
  /
  dux_[d_] "Efterspørgselskomponenter" /
    tot "Total af alle brancher"
    set.efterspoergsel_totaler    
    set.brancher
    set.privat_forbrug
    set.offentligt_forbrug
    set.investeringstyper
  /
  dux[d_] "Efterspørgselskomponenter" /
    set.brancher
    set.privat_forbrug
    set.offentligt_forbrug
    set.investeringstyper
  /

  dTots[d_] "Efterspørgselsaggregater" /
    set.efterspoergsel_totaler
  /

  dTots2d[d_,d] "Mapping mellem efterspørgselsaggregater og efterspørgselskomponenter" /
    dTot . set.d
    tot . set.brancher
    xTot . set.eksportgrupper
    cTot . set.privat_forbrug
    gTot . set.offentligt_forbrug
    iTot . set.investeringstyper
  /

  cBil[d_] "Subset bestående af cBil" /cBil/
  
;

# ----------------------------------------------------------------------------------------------------------------------
# Productionsbrancher
# ----------------------------------------------------------------------------------------------------------------------
SETS
  s_[d_] "Production sectors, including total" /
    tot
    spTot
    spxTot
    sByTot
    set.private_brancher
    set.offentlige_brancher
  /
  s[s_] "Production sectors" / set.private_brancher, set.offentlige_brancher /
  sp[s_] "Private production sectors" / set.private_brancher /
  spx[s_] "Private brancher ekskl. boligbranchen" / lan, byg, ene, udv, fre, soe, tje /
  sOff[s_] "Public sector" / set.offentlige_brancher /
  sBy[s_] "Private byerhverv" / tje, fre, byg, ene /
  bol[s_] "Subset bestående af bol" / bol /
  udv[s_] "Subset bestående af udv" / udv /
  tje[s_] "Subset bestående af tje" / tje /
  soe[s_] "Subset bestående af soe" / soe /
;

# ----------------------------------------------------------------------------------------------------------------------
# Materialer
# ----------------------------------------------------------------------------------------------------------------------
alias(s_, r_);
alias(s, r);

# ----------------------------------------------------------------------------------------------------------------------
# Eksport
# ----------------------------------------------------------------------------------------------------------------------
SETS
  x_[d_] "Eksportgrupper, inklusiv total" / xTot, set.eksportgrupper /
  x[x_] "Eksportgrupper" / set.eksportgrupper /    

  xxTur[x] "Export groups, excluding tourism" / xEne, xVar, xSoe, xTje /
  xEne[x_] "Subset af x_ bestående af xEne" / xEne /
  xSoe[d_] "Subset af x bestående af xSoe" / xSoe /
  xTur[x] "Subset af x bestående af xTur" / xTur /
;

# ----------------------------------------------------------------------------------------------------------------------
# Offentligt forbrug
# ----------------------------------------------------------------------------------------------------------------------
SETS
  g_[d_] "Offentligt forbrug - forbrugsgrupper inklusiv total og alle nests" / gTot, set.offentligt_forbrug /
  g[g_] "Offentligt forbrug - forbrugsgrupper" / set.offentligt_forbrug /

  gNest[g_] "Offentligt forbrug - nests" / gTot /

  gNest2g_[gNest,g_] "Mapping over the government consumption tree" / gTot . g /
;

# ----------------------------------------------------------------------------------------------------------------------
# Privat forbrug
# ----------------------------------------------------------------------------------------------------------------------
SETS
  c_[d_] "Demand for private consumption - all groups and nests." / cTot, set.privat_forbrug, set.privat_forbrug_nests /
  c[c_] "Demand for private consumption - micro-level" / set.privat_forbrug /

  cNest[c_] "Private consumption nests. The order should be from bottom of the CES tree and up!" /
    cTurTje
    cTurTjeVar
    cTurTjeVarEne
    cIkkeBol
  /
  cNest2c_[cNest,c_] "Mapping of the private consumption CES nest structure" /
    cTurTje . (cTur, cTje)
    cTurTjeVar . (cTurTje, cVar)
    cTurTjeVarEne . (cTurTjeVar, cEne)
    cIkkeBol . (cTurTjeVarEne, cBil)
  /
  c_2c[c_,c] "Mapping from private consumption nests to constituent consumption groups." /
    cTurTje . (cTur, cTje)
    cTurTjeVar . (cTur, cTje, cVar)
    cTurTjeVarEne . (cTur, cTje, cVar, cEne)
    cIkkeBol . (cTur, cTje, cVar, cEne, cBil)
    cTot . (cTur, cTje, cVar, cEne, cBil, cBol)
  /

  cIkkeBol[c_] "Subset bestående af cIkkeBol" / cIkkeBol /
  cBol[c_] "Subset bestående af cBol" / cBol /
  cTur[c_] "Subset bestående af cTur" / cTur /
;

# ----------------------------------------------------------------------------------------------------------------------
# Investeringer
# ----------------------------------------------------------------------------------------------------------------------
SETS
  i_[d_] "Investment types, including total" / iTot, set.investeringstyper /
  i[i_] "Investment types" / set.investeringstyper /

  is_[i_,s_] "Investment types by sector including totals" / set.i_ . set.s_ /
  is[i,s] "Investment types by sector" / set.i . set.s /
  iL[d_] "subset bestående af iL" / iL /
  iB[i_] "subset bestående af iB" / iB /
  iM[d_] "subset bestående af iM" / iM / 
;

# ----------------------------------------------------------------------------------------------------------------------
# Kapital
# ----------------------------------------------------------------------------------------------------------------------
SETS
  k_[i_] "Investment types, excluding inventory, including total" / iTot, iB, iM /
  k[i_] "Investment types, excluding inventory" / iB, iM /

  ks_[k_,s_] "Investment types by sector excluding inventory, including totals" / set.k_ . set.s_ /
  ks[k,s] "Investment types by sector excluding inventory" / set.k . set.s /
;


# ----------------------------------------------------------------------------------------------------------------------
# Alias
# --------------------------------------------------------- ------------------------------------------------------------
alias(s, ds);
alias(s_, ds_);
alias(s, dss);
alias(s, ss);
alias(sp, dsp);
alias(sp, dssp);
alias(sp, ssp);

alias(d, dd);

alias(c, cDK);
alias(c_, cDK_);

alias(c, cc);
alias(g, gg);
alias(x, xx);
alias(r, rr);
alias(i, ii);

alias(c_, cc_);
alias(g_, gg_);
alias(x_, xx_);
alias(r_, rr_);
alias(i_, ii_);

# ----------------------------------------------------------------------------------------------------------------------
# Singletons
# ----------------------------------------------------------------------------------------------------------------------
# The can be used interchangeably with 'tot'
singleton sets
    dTot[d_]     /dTot/
    gTot[g_]     /gTot/
    cTot[c_]     /cTot/
    cDKtot[c_]   /cTot/   
    sTot[s_]     /tot/
    spTot[s_]    /spTot/
    spxTot[s_]   /spxTot/
    sByTot[s_]  /sByTot/
    rTot[r_]     /tot/
    xTot[x_]     /xTot/
    iTot[i_]     /iTot/
    kTot[i_]     /iTot/
    isTot[i_,s_] /iTot . tot/
    ksTot[k_,s_] /iTot . tot/
;

# ----------------------------------------------------------------------------------------------------------------------
# Data dummies
# ----------------------------------------------------------------------------------------------------------------------
# Dummy parameters indicating whether a delivery (data point) exists.
SETS
  d1IO[d_,s_,t]  "IO cell dummy" //
  d1IOy[d_,s_,t] "IO cell dummy" //
  d1IOm[d_,s_,t] "IO cell dummy" //

  d1Xm[x_,t]  "IO cell dummy" //
  d1Xy[x_,t]  "IO cell dummy" //

  d1CTurist[c,t] "Private consumption for tourists in Denmark" //
  d1X[x_,t]       "Export" //
  d1I_s[i_,ds_,t] "Investment goods to sector ds" //
  d1K[i_,s_,t]    "Capital in sector s" //

  d1R[r_,t]       "Material goods" //
  d1C[c_,t]       "Private consumption" //
  d1G[g_,t]       "Public consumption" //
;
d1I_s[i_,spTot,t] = yes; 
d1I_s[i_,sTot,t] = yes; 
d1K[k_,sTot,t] = yes;
d1X[xTot,t] = yes;      

d1R[r_,t] = yes;
d1C[c_,t] = yes;
d1G[g_,t] = yes;