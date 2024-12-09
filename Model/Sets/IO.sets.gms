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
    tot "Total af alle brancher"
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
    cTurTjex       "Consumption nest - tourism and services excl. financial costs"
    cTurTjexVar    "Consumption nest - tourism, services, and goods"
    cTurTjexVarEne "Consumption nest - tourism, services, goods, and energy"
    Cx             "Total Consumption excl. housing and financial costs"
  /

  offentligt_forbrug /
    g "All public consumption (to be split up later)"
  /

  investeringstyper /
    iB "Bygningsinvesteringer inkl. anlæg"
    iM "Maskininvesteringer inkl. transportmidler og immaterielle rettigheder"
    iL "Lagerinvesteringer inkl. værdigenstande og stambesætninger"
  /
;

# ----------------------------------------------------------------------------------------------------------------------
# Efterspørgselskomponenter
# ----------------------------------------------------------------------------------------------------------------------
SETS
  d_ "Efterspørgselskomponenter inklusiv total og deltotaler" /
    spTot "Total af private brancher"
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

  cgi[d_] "Efterspørgselskomponenter" /
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
;

# ----------------------------------------------------------------------------------------------------------------------
# Productionsbrancher
# ----------------------------------------------------------------------------------------------------------------------
SETS
  s_[d_] "Production sectors, including total" /
    tot
    spTot
    sByTot
    set.private_brancher
    set.offentlige_brancher
  /
  s[s_] "Production sectors" / set.private_brancher, set.offentlige_brancher /
  sp[s_] "Private production sectors" / set.private_brancher /
  spx[s_] "Private brancher ekskl. boligbranchen" / lan, byg, ene, udv, fre, soe, tje /
  #  sOff[s_] "Public sector" / set.offentlige_brancher /
  sBy[s_] "Private byerhverv" / tje, fre, byg, ene /
  sTold[s_] "Toldbelagte import-brancher" / lan, byg, ene, udv, fre /

  sMat[s_] "Subset bestående af sektorer der producerer materialer" / tje, fre, byg, lan , soe, bol /
  sEne[s_] "Subset bestående af sektorer der producerer energi" / ene, udv /

  m[s_] "Brancher med import." / tje, fre, soe, udv, ene /
;

set harrod_neutral[s_] "Brancher hvor teknologiske fremskridt antages udelukkende at være arbejdskraft-besparende" /
  tje, fre, byg, lan
/; # sp eksklusiv ene, bol, soe, udv

SINGLETON SETS
  tje[s_] "Private tjenester ekskl. søtransport" / tje /
  fre[s_] "Fremstilling ekskl. energi" / fre /
  byg[s_] "Byggeri og anlæg" / byg /
  lan[s_] "Landbrug og fiskeri" / lan /
  soe[s_] "Søtransport" / soe /
  bol[s_] "Bolig" / bol /
  ene[s_] "Energi" / ene /
  udv[s_] "Udvinding" / udv /
  off[s_] "Offentlig" / off /
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
;

SINGLETON SETS
  xEne[d_] "Eksport af energivarer - SITC 3."  / xEne /
  xVar[d_] "Eksport af varer ekskl. energi."  / xVar /
  xSoe[d_] "Eksport af søtransport."  / xSoe /
  xTje[d_] "Eksport af tjenester ekskl. søtransport og turistindtægter."  / xTje /
  xTur[d_] "Turistindtægter (eksport)." / xTur /
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
    cTurTjex
    cTurTjexVar
    cTurTjexVarEne
    Cx
  /
  c_2c[c_,c] "Mapping from private consumption nests to constituent consumption groups." /
    cTurTjex . (cTur, cTje)
    cTurTjexVar . (cTur, cTje, cVar)
    cTurTjexVarEne . (cTur, cTje, cVar, cEne)
    Cx . (cTur, cTje, cVar, cEne, cBil)
    cTot . (cTur, cTje, cVar, cEne, cBil, cBol)
  /
;

SINGLETON SETS
  Cx[d_] "Subset bestående af Cx" / Cx /
  cBol[d_] "Bolig" / cBol /
  cBil[d_] "Biler" / cBil /
  cEne[d_] "Energi" / cEne /
  cVar[d_] "Varer" / cVar /
  cTje[d_] "Tjenester" / cTje /
  cTur[d_] "Turisme" / cTur /
;

# ----------------------------------------------------------------------------------------------------------------------
# Investeringer
# ----------------------------------------------------------------------------------------------------------------------
SETS
  i_[d_] "Investment types, including total" / iTot, set.investeringstyper /
  i[i_] "Investment types" / set.investeringstyper /

  is_[i_,s_] "Investment types by sector including totals" / set.i_ . set.s_ /
  is[i,s] "Investment types by sector" / set.i . set.s /
;

SINGLETON SETS
  iB[d_] "Bygningsinvesteringer" / iB /
  iM[d_] "Maskininvesteringer" / iM /
  iL[d_] "Lagerinvesteringer" / iL /
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
alias(k, kk);

alias(c_, cc_);
alias(g_, gg_);
alias(x_, xx_);
alias(r_, rr_);
alias(i_, ii_);

# ----------------------------------------------------------------------------------------------------------------------
# Totaler
# ----------------------------------------------------------------------------------------------------------------------
SINGLETON SETS
  dTot[d_]     /dTot/
  gTot[g_]     /gTot/
  cTot[c_]     /cTot/
  cDKtot[c_]   /cTot/   
  sTot[s_]     /tot/
  spTot[s_]    /spTot/
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