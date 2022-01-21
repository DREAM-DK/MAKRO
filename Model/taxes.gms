# ======================================================================================================================
# Taxes
# - Tax rates and revenue
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_taxes_values
    vtMoms[d_,s_,t]$(t.val > 2015) "Generelle afgiftsprovenu (oms/moms) fordelt på efterspørgselskomponenter og brancher, Kilde: ADAM[Spg_<d>]"
    vtNetAfg[d_,s_,t]$(t.val > 2015) "Provenu af punktafgifter fordelt på efterspørgselskomponenter og brancher inkl. subsidier og registreringsafgift, Kilde: ADAM[Spp_<d>]"
    vtAfg[d_,s_,t]$(t.val > 2015) "Provenu af punktafgifter fordelt på efterspørgselskomponenter og brancher ekskl. registreringsafgift."
    vtReg[d_,t]$(t.val > 2015) "Registreringsafgiftsprovenu, Kilde: ADAM[Spr_<d_>]"
    vPunktSub[t]$(t.val > 2015) "Produktsubsidier, Kilde: ADAM[Sppu]"
    vtTold[d_,s_,t]$(t.val > 2015) "Toldprovenu fordelt på efterspørgselskomponenter og brancher, Kilde: ADAM[Spm_<i>]"
    vtGrund[s_,t]$(d1K['iB',s_,t]) "Ejendomsskatter fordelt på brancher, Kilde: ADAM[Spzej], ADAM[Spzejh] og ADAM[bspzej_x<i>]*ADAM[Spzejxh]"
    vtVirkVaegt[s_,t]$(d1K['iM',s_,t]) "Vægtafgifter fra erhvervene fordelt på brancher, Kilde: ADAM[Spzv] og ADAM[bspzv_x<i>]"
    vtVirkAM[s_,t] "Provenu af arbejdsmarkedsbidrag (AMBI) vedr. værditilvækst eller lønsum, Kilde: ADAM[Spzam] og ADAM[bspzam_x<i>]"
    vtAUB[s_,t] "Provenu fra AUB - arbejdsgivernes uddannelsesbidrag mv. fra erhvervene, Kilde: ADAM[Spzaud] og ADAM[bspzaud_x<i>]"
    vtSubLoen[s_,t] "Provenu fra løntilskud fordelt på brancher, Kilde: ADAM[Spzul] og ADAM[bspzul_x<i>]"
    vtNetLoenAfg[s_,t] "Ikke-varefordelte indirekte afgifter vedrørende lønsum, Kilde: ADAM[Spzl] og ADAM[Spzl_x<i>]"
    vtNetYAfg[s_,t] "Andre produktionsskatter (ikke-varefordelte indirekte skatter), netto, Kilde: ADAM[Spz]"
    vtNetYAfgRest[s_,t]$(t.val > 2015 or sTot[s_]) "Andre produktionsskatter, Restdel, Kilde: ADAM[SpzCo2]+ADAM[Spzr]"
  ;

  $GROUP G_taxes_endo
    G_taxes_values

    tNetAfg_y[d_,s,t]$(d1IOy[d_,s,t] and t.val > 2015) "Punktafgiftssats inkl. subsidier og registreringsafgift fordelt på efterspørgsels og input fra indenlandske brancher."
    tNetAfg_m[d_,s,t]$(d1IOm[d_,s,t] and t.val > 2015) "Punktafgiftssats inkl. subsidier og registreringsafgift fordelt på efterspørgsels og input fra import-grupper."

    tL[s_,t]$(t.val > 2015 or s[s_]) "Samlet afgiftssats på arbejdskraft (betalt af arbejdsgiver)"

    tIOy[d_,s,t]$(d1IOy[d_,s,t]) "Samlet afgiftssats for moms og punktafgifter inkl. subsidier og registreringsafgift fordelt på efterspørgselskomponenter og input fra indenlandske brancher."
    tIOm[d_,s,t]$(d1IOm[d_,s,t]) "Samlet afgiftssats for moms og punktafgifter inkl. subsidier og registreringsafgift fordelt på efterspørgselskomponenter og input fra import-grupper."
  ;
  $GROUP G_taxes_endo G_taxes_endo$(tx0[t]); # Restrict endo group to tx0[t]

  $GROUP G_taxes_ARIMA_forecast
    tAfg_y[d_,s,t] "Punktafgiftssats ekskl. subsidier og registreringsafgift fordelt på efterspørgsels og input fra indenlandske brancher."
    tAfg_m[d_,s,t] "Punktafgiftssats ekskl. subsidier og registreringsafgift fordelt på efterspørgsels og input fra import-grupper."
    tYsub_y[d_,s,t] "Sats for produktsubsidier fordelt på efterspørgselskomponenter og indenlandske brancher."
    tYsub_m[d_,s,t] "Sats for produktsubsidier fordelt på efterspørgselskomponenter og import-grupper."
  ;
  $GROUP G_taxes_other
    tYsub_y0[d_,s,t] "Hjælpevariabel til at opdele netto punktafgifter på hhv. afgifter og subsidier."
    tYsub_m0[d_,s,t] "Hjælpevariabel til at opdele netto punktafgifter på hhv. afgifter og subsidier."

    tTold[d_,s,t] "Toldsats fordelt på efterspørgselskomponenter og input fra import-grupper."

    tMoms_y[d_,s,t] "Momssats fordelt på efterspørgselskomponenter og input fra indenlandske brancher."
    tMoms_m[d_,s,t] "Momssats fordelt på efterspørgselskomponenter og input fra indenlandske brancher."

    tK[k,s_,t]$(d1K[k,s_,t]) "Kapitalafgiftssats (hhv. ejendomsskatter og vægtafgift)"
    tLoensum[s,t] "Afgiftssats for AM-bidrag betalt af virksomheder "
    tVirkAM[s,t] "Afgiftssats for AUB-bidrag betalt af virksomheder."
    tLoenSub[s,t] "Sats for løntilskud."

    tYsub0[t] "Hjælpevariabel til at kalibrere de samlede produktsubsidier."
    tReg[d_,t] "Registreringsafgiftssats for biler."
    tNetYRest[s,t] "Andre produktionsskatter ift. BVT";
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_taxes
    # Samlet sats for told, afgifter og moms
    E_tIOy[d,s,t]$(tx0[t] and d1IOy[d,s,t])..
      tIOy[d,s,t] =E= (1+tNetAfg_y[d,s,t]) * (1+tMoms_y[d,s,t]) - 1;
    E_tIOm[d,s,t]$(tx0[t] and d1IOm[d,s,t])..
      tIOm[d,s,t] =E= (1+tTold[d,s,t]) * (1+tNetAfg_m[d,s,t]) * (1+tMoms_m[d,s,t]) - 1;

    # Skattesatser
    E_tNetAfg_y[d,s,t]$(tx0[t] and d1IOy[d,s,t])..
      tNetAfg_y[d,s,t] =E= (1 + tAfg_y[d,s,t] - tYsub_y[d,s,t]) * (1 + tReg[d,t]) - 1;
    E_tNetAfg_m[d,s,t]$(tx0[t] and d1IOm[d,s,t])..
      tNetAfg_m[d,s,t] =E= (1 + tAfg_m[d,s,t] - tYsub_m[d,s,t]) * (1 + tReg[d,t]) - 1;

    # Provenu fra moms  
    E_vtMoms[d,s,t]$(tx0[t] and t.val > 2015)..
      vtMoms[d,s,t] =E= tMoms_y[d,s,t] * vIOy[d,s,t] / (1+tMoms_y[d,s,t])
                      + tMoms_m[d,s,t] * vIOm[d,s,t] / (1+tMoms_m[d,s,t]);

    # Nettoprovenu fra punktafgifter, produktsubsidier og registreringsafgifter   
    E_vtNetAfg[d,s,t]$(tx0[t] and t.val > 2015)..
      vtNetAfg[d,s,t] =E=                    tNetAfg_y[d,s,t] * vIOy[d,s,t] / (1+tIOy[d,s,t])
                        + (1+tTold[d,s,t]) * tNetAfg_m[d,s,t] * vIOm[d,s,t] / (1+tIOm[d,s,t]);

    # Provenu fra punktafgifter 
    E_vtAfg[d,s,t]$(tx0[t] and t.val > 2015)..
      vtAfg[d,s,t] =E=                    tAfg_y[d,s,t] * vIOy[d,s,t] / (1+tIOy[d,s,t])
                     + (1+tTold[d,s,t]) * tAfg_m[d,s,t] * vIOm[d,s,t] / (1+tIOm[d,s,t]);

    # Provenu fra registreringsafgifter
    E_vtReg_i[t]$(tx0[t] and t.val > 2015).. vtReg['iM',t] =E= tReg['iM',t] * vI['iM',t] / (1+tReg['iM',t]);
    E_vtReg_c[t]$(tx0[t] and t.val > 2015).. vtReg['cBil',t] =E= tReg['cBil',t] * vC['cBil',t] / (1+tReg['cBil',t]);
    E_vtReg_g[t]$(tx0[t] and t.val > 2015).. vtReg['g',t] =E= tReg['g',t] * vG['g',t] / (1+tReg['g',t]);

    # Udgiften til produktsubsidier
    E_vPunktSub[t]$(tx0[t] and t.val > 2015).. vPunktSub[t] =E= vtReg[dTot,t] + vtAfg[dTot,sTot,t] - vtNetAfg[dTot,sTot,t];

    # Provenu fra told
    E_vtTold[d,s,t]$(tx0[t] and t.val > 2015).. vtTold[d,s,t] =E= tTold[d,s,t] * vIOm[d,s,t] / (1+tIOm[d,s,t]);

    # PRODUCTION TAXES
    E_vtGrund[s,t]$(tx0[t] and d1K['iB',s,t])..
      vtGrund[s,t] =E= tK['iB',s,t] * pI_s['iB',s,t] * qK['iB',s,t-1]/fq;
    E_vtVirkVaegt[s,t]$(tx0[t] and d1K['iM',s,t])..
      vtVirkVaegt[s,t] =E= tK['iM',s,t] * pI_s['iM',s,t] * qK['iM',s,t-1]/fq;

    E_vtVirkAM[s,t]$(tx0[t]).. vtVirkAM[s,t] =E= tLoensum[s,t] * vLoensum[s,t];
    E_vtAUB[s,t]$(tx0[t]).. vtAUB[s,t] =E= tVirkAM[s,t] * vLoensum[s,t];
    E_vtSubLoen[s,t]$(tx0[t]).. vtSubLoen[s,t] =E= tLoenSub[s,t] * vLoensum[s,t];

    E_vtNetLoenAfg[s,t]$(tx0[t]).. vtNetLoenAfg[s,t] =E= vtVirkAM[s,t] + vtAUB[s,t] - vtSubLoen[s,t];
    E_tL[s,t]$(tx0[t]).. tL[s,t] * vLoensum[s,t] =E= vtNetLoenAfg[s,t];

    E_vtNetYAfgRest[s,t]$(tx0[t]).. vtNetYAfgRest[s,t] =E= tNetYRest[s,t] * vBVT[s,t] ;
    E_vtNetYAfg[s,t]$(tx0[t])..
      vtNetYAfg[s,t] =E= vtGrund[s,t] + vtVirkVaegt[s,t] + vtNetLoenAfg[s,t] + vtNetYAfgRest[s,t];

    # ----------------------------------------------------------------------------------------------------------------------
    # Branche-totaler
    # ----------------------------------------------------------------------------------------------------------------------
    E_vtMoms_sTot[d,t]$(tx0[t] and t.val > 2015)..   vtMoms[d,sTot,t]   =E= sum(s, vtMoms[d,s,t]);
    E_vtNetAfg_sTot[d,t]$(tx0[t] and t.val > 2015).. vtNetAfg[d,sTot,t] =E= sum(s, vtNetAfg[d,s,t]);
    E_vtAfg_sTot[d,t]$(tx0[t] and t.val > 2015)..    vtAfg[d,sTot,t]    =E= sum(s, vtAfg[d,s,t]);
    E_vtTold_sTot[d,t]$(tx0[t] and t.val > 2015)..   vtTold[d,sTot,t]   =E= sum(s, vtTold[d,s,t]);

    E_vtGrund_tot[t]$(tx0[t])..       vtGrund[sTot,t]       =E= sum(s, vtGrund[s,t]);
    E_vtVirkVaegt_tot[t]$(tx0[t])..   vtVirkVaegt[sTot,t]   =E= sum(s, vtVirkVaegt[s,t]);
    E_vtVirkAM_tot[t]$(tx0[t])..      vtVirkAM[sTot,t]      =E= sum(s, vtVirkAM[s,t]);
    E_vtAUB_tot[t]$(tx0[t])..         vtAUB[sTot,t]         =E= sum(s, vtAUB[s,t]);
    E_vtSubLoen_tot[t]$(tx0[t])..     vtSubLoen[sTot,t]     =E= sum(s, vtSubLoen[s,t]);
    E_vtNetLoenAfg_tot[t]$(tx0[t])..  vtNetLoenAfg[sTot,t]  =E= sum(s, vtNetLoenAfg[s,t]);
    E_vtNetYAfgRest_tot[t]$(tx0[t]).. vtNetYAfgRest[sTot,t] =E= sum(s, vtNetYAfgRest[s,t]);
    E_vtNetYAfg_tot[t]$(tx0[t])..     vtNetYAfg[sTot,t]     =E= sum(s, vtNetYAfg[s,t]);

    # ----------------------------------------------------------------------------------------------------------------------
    # Efterspørgsels-totaler
    # ----------------------------------------------------------------------------------------------------------------------
    E_vtMoms_cTot[t]$(tx0[t] and t.val > 2015).. vtMoms[cTot,sTot,t] =E= sum(c, vtMoms[c,sTot,t]);
    E_vtMoms_gTot[t]$(tx0[t] and t.val > 2015).. vtMoms[gTot,sTot,t] =E= sum(g, vtMoms[g,sTot,t]);
    E_vtMoms_xTot[t]$(tx0[t] and t.val > 2015).. vtMoms[xTot,sTot,t] =E= sum(x, vtMoms[x,sTot,t]);
    E_vtMoms_rTot[t]$(tx0[t] and t.val > 2015).. vtMoms[rTot,sTot,t] =E= sum(r, vtMoms[r,sTot,t]);
    E_vtMoms_iTot[t]$(tx0[t] and t.val > 2015).. vtMoms[iTot,sTot,t] =E= sum(i, vtMoms[i,sTot,t]);
    E_vtMoms_dTot[t]$(tx0[t] and t.val > 2015).. vtMoms[dTot,sTot,t] =E= vtMoms[cTot,sTot,t]
                                                                       + vtMoms[gTot,sTot,t]
                                                                       + vtMoms[xTot,sTot,t]
                                                                       + vtMoms[iTot,sTot,t]
                                                                       + vtMoms[rTot,sTot,t];

    E_vtNetAfg_cTot[t]$(tx0[t] and t.val > 2015).. vtNetAfg[cTot,sTot,t] =E= sum(c, vtNetAfg[c,sTot,t]);
    E_vtNetAfg_gTot[t]$(tx0[t] and t.val > 2015).. vtNetAfg[gTot,sTot,t] =E= sum(g, vtNetAfg[g,sTot,t]);
    E_vtNetAfg_xTot[t]$(tx0[t] and t.val > 2015).. vtNetAfg[xTot,sTot,t] =E= sum(x, vtNetAfg[x,sTot,t]);   
    E_vtNetAfg_rTot[t]$(tx0[t] and t.val > 2015).. vtNetAfg[rTot,sTot,t] =E= sum(r, vtNetAfg[r,sTot,t]);
    E_vtNetAfg_iTot[t]$(tx0[t] and t.val > 2015).. vtNetAfg[iTot,sTot,t] =E= sum(i, vtNetAfg[i,sTot,t]);
    E_vtNetAfg_dTot[t]$(tx0[t] and t.val > 2015).. vtNetAfg[dTot,sTot,t] =E= vtNetAfg[cTot,sTot,t]
                                                                           + vtNetAfg[gTot,sTot,t]
                                                                           + vtNetAfg[xTot,sTot,t]
                                                                           + vtNetAfg[iTot,sTot,t]
                                                                           + vtNetAfg[rTot,sTot,t];

    E_vtAfg_cTot[t]$(tx0[t] and t.val > 2015).. vtAfg[cTot,sTot,t] =E= sum(c, vtAfg[c,sTot,t]);
    E_vtAfg_gTot[t]$(tx0[t] and t.val > 2015).. vtAfg[gTot,sTot,t] =E= sum(g, vtAfg[g,sTot,t]);
    E_vtAfg_xTot[t]$(tx0[t] and t.val > 2015).. vtAfg[xTot,sTot,t] =E= sum(x, vtAfg[x,sTot,t]);
    E_vtAfg_rTot[t]$(tx0[t] and t.val > 2015).. vtAfg[rTot,sTot,t] =E= sum(r, vtAfg[r,sTot,t]);
    E_vtAfg_iTot[t]$(tx0[t] and t.val > 2015).. vtAfg[iTot,sTot,t] =E= sum(i, vtAfg[i,sTot,t]);
    E_vtAfg_dTot[t]$(tx0[t] and t.val > 2015).. vtAfg[dTot,sTot,t] =E= vtAfg[cTot,sTot,t]
                                                                     + vtAfg[gTot,sTot,t]
                                                                     + vtAfg[xTot,sTot,t]
                                                                     + vtAfg[iTot,sTot,t]
                                                                     + vtAfg[rTot,sTot,t];

    E_vtReg_dTot[t]$(tx0[t] and t.val > 2015).. vtReg[dTot,t] =E= vtReg['iM',t] + vtReg['cBil',t] + vtReg['g',t];

    E_vtTold_rTot[t]$(tx0[t] and t.val > 2015).. vtTold[rTot,sTot,t] =E= sum(r, vtTold[r,sTot,t]);
    E_vtTold_iTot[t]$(tx0[t] and t.val > 2015).. vtTold[iTot,sTot,t] =E= sum(i, vtTold[i,sTot,t]);
    E_vtTold_gTot[t]$(tx0[t] and t.val > 2015).. vtTold[gTot,sTot,t] =E= sum(g, vtTold[g,sTot,t]);
    E_vtTold_cTot[t]$(tx0[t] and t.val > 2015).. vtTold[cTot,sTot,t] =E= sum(c, vtTold[c,sTot,t]);
    E_vtTold_xtot[t]$(tx0[t] and t.val > 2015).. vtTold[xTot,sTot,t] =E= sum(x, vtTold[x,sTot,t]);
    E_vtTold_dTot[t]$(tx0[t] and t.val > 2015).. vtTold[dTot,sTot,t] =E= vtTold[cTot,sTot,t]
                                                                       + vtTold[gTot,sTot,t] 
                                                                       + vtTold[rTot,sTot,t] 
                                                                       + vtTold[iTot,sTot,t] 
                                                                       + vtTold[xTot,sTot,t];
  $ENDBLOCK
$ENDIF