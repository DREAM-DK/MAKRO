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
    rTot "Samlet materiale-input."
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
    spByTot "Total af private byerhverv"
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
    rTot . set.brancher
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
    rTot
    spTot
    spxTot
    spByTot
    set.private_brancher
    set.offentlige_brancher
  /
  s[s_] "Production sectors" / set.private_brancher, set.offentlige_brancher /
  sp[s_] "Private production sectors" / set.private_brancher /
  spx[s_] "Private brancher ekskl. boligbranchen" / lan, byg, ene, udv, fre, soe, tje /
  sOff[s_] "Public sector" / set.offentlige_brancher /
  spBy[s_] "Private byerhverv" / tje, fre, byg, ene /
;

# ----------------------------------------------------------------------------------------------------------------------
# Materialer
# ----------------------------------------------------------------------------------------------------------------------
#  r_[d_] "Materiale input inklusiv total" / rTot, set.brancher /
#  r[r_] "Materiale input" / set.brancher /
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

# ----------------------------------------------------------------------------------------------------------------------
# Kapital
# ----------------------------------------------------------------------------------------------------------------------
SETS
  k_[i_] "Investment types, excluding inventory, including total" / iTot, iB, iM /
  k[i_] "Investment types, excluding inventory" / iB, iM /

  ks_[k_,s_] "Investment types by sector excluding inventory, including totals" / set.k_ . set.s_ /
  ks[k,s] "Investment types by sector excluding inventory" / set.k . set.s /
;


#  # ----------------------------------------------------------------------------------------------------------------------
#  # Mapping mellem ADAM og Makro
#  # ----------------------------------------------------------------------------------------------------------------------
#  SETS
#    branche2s[s_,branche] "Mapping fra ADAM brancher til Makro brancher" /
#      lan . (a) 
#      byg . (b)                                                 
#      ene . (ne,ng)                                                 
#      udv . (e)                                                 
#      bol . (h)                                           
#      fre . (nf,nz)
#      off . (o)             
#      soe . (qs)
#      tje . (qf,qz)
    
#      tot . (set.branche)

#      rTot . (set.branche)
#    /

#    mapax2s[s_,as]   "Map fra ADAM produktion til Makro brancher" /
#      lan . (xa) 
#      byg . (xb)                                                 
#      ene . (xne,xng)                                                 
#      udv . (xe)                                                 
#      bol . (xh)                                           
#      fre . (xnf,xnz)
#      off . (xo)             
#      soe . (xqs)
#      tje . (xqf,xqz)
#      tot . (set.as)
#      rTot . (set.as)
#      spTot . (set.axp)
#    /

#    mapam2s[s_,as]   "Mapping fra sitc grupper til Makro brancher" /
#      #lan . () 
#      #byg . ()                                                 
#      ene . (m3q)                                                 
#      udv . (m3k, m3r)                                                 
#      #bol . ()                                           
#      fre . (m01, m2, m59, m7b, m7y)
#      #off . ()             
#      #soe . ()
#      tje . (ms,mt)
#      tot . (set.as)
#      rTot . (set.as)
#    /

#    mapaxm2s[s_,as]   "Mapping fra ADAM produktion og sitc grupper til Makro brancher" / 
#      lan . (xa) 
#      byg . (xb)                                                 
#      ene . (xne, xng)                                                 
#      udv . (xe)                                                 
#      bol . (xh)                                           
#      fre . (xnf, xnz)
#      off . (xo)             
#      soe . (xqs)
#      tje . (xqf, xqz)

#      #lan . () 
#      #byg . ()                                                 
#      ene . (m3q)                                                 
#      udv . (m3k, m3r)                                                 
#      #bol . ()                                           
#      fre . (m01, m2, m59, m7b, m7y)
#      #off . ()             
#      #soe . ()
#      tje . (ms,mt)

#      tot . (set.as)
#      rTot . (set.as)
#    /

#    mapai2i[i_,ai] "Mapping af investeringstyper fra ADAM til Makro" /
#      im   . (im)
#      iB   . (iB)
#      iL . (ikn, il, it)
#      iTot . (im, it, iB, ikn, il)
#    /

#    mapak2k[k_,ak] "Mapping af investeringstyper fra ADAM til Makro" /
#      im   . (knm)
#      iB   . (knb)
#      iTot . (knm, knb)
#    /

#    mapacp2c[c_,acp]   "Mapping over forbrugsgrupper" /
#      cBil . (cb)
#      cEne . (cg,ce)
#      cVar . (cf,cv)
#      cBol . (ch)
#      cTje . (cs)
#      cTur . (ct)
#      cIkkeBol . (cb, cg, ce, cf, cv, cs, ct)
#      cTot . (set.acp)
#    /

#    mapae2x[x_,ae]   "Mapping over eksportgrupper" /
#      xVar . (e01, e2, e59, e7y)
#      xEne . (e3)
#      xSoe . (ess)
#      xTje . (esq)
#      xTur . (et)
#      xTot . (set.ae)
#    /
#  ;

# ----------------------------------------------------------------------------------------------------------------------
# Alias
# --------------------------------------------------------- ------------------------------------------------------------
alias(s,ds);
alias(s_,ds_);
alias(s,dss);
alias(s,ss);
alias(sp,dsp);
alias(sp,dssp);
alias(sp,ssp);

alias(d,dd);

alias(c,cDK);
alias(c_,cDK_);

alias(c,cc);
alias(g,gg);
alias(x,xx);
alias(r,rr);
alias(i,ii);

alias(c_,cc_);
alias(g_,gg_);
alias(x_,xx_);
alias(r_,rr_);
alias(i_,ii_);

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
    spByTot[s_]  /spByTot/
    rTot[r_]     /rTot/
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
$PGROUP pG_dummies
  d1IO[d_,s_,t]  "IO cell dummy"
  d1IOy[d_,s_,t] "IO cell dummy"
  d1IOm[d_,s_,t] "IO cell dummy"

  d1Xm[x,t]  "IO cell dummy"
  d1xy[x,t]  "IO cell dummy"

  d1CTurist[c,t] "Private consumption for tourists in Denmark"
  d1X[x_,t]       "Export"
  d1I_s[i_,ds_,t] "Investment goods to sector ds"
  d1K[i_,s_,t]    "Capital in sector s"

  d1R[r_,t]       "Material goods"
  d1C[c_,t]       "Private consumption"
  d1G[g_,t]       "Public consumption"
;
d1I_s[i_,spTot,t] = yes; 
d1I_s[i_,sTot,t] = yes; 
d1K[k_,sTot,t] = yes;
d1X[xTot,t] = yes;       

d1R[r_,t] = yes;
d1C[c_,t] = yes;
d1G[g_,t] = yes;

$FUNCTION set_dummies(&year,&subset):
# Set dummy values to those of a specific year. 
# THIS SHOULD ONLY BE USED ON A SUBSET WHERE NO DATA EXISTS. 
    $LOOP pG_dummies:
        {name}{sets}{$}[<t>&subset] = {name}{sets}{$}[<t>&year];
    $ENDLOOP
$ENDFUNCTION
