# ======================================================================================================================
# Taxes
# - Tax rates and revenue
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_taxes_endo
    vtIOy[d_,s,t]$(d1IOy[d_,s,t]) "Samlet afgiftsprovenue for moms og punktafgifter inkl. subsidier og registreringsafgift fordelt på efterspørgselskomponenter og indenlandske brancher."
    vtIOm[d_,s,t]$(d1IOm[d_,s,t]) "Samlet afgiftsprovenue for told, moms og punktafgifter inkl. subsidier og registreringsafgift fordelt på efterspørgselskomponenter og import-grupper."
    vtMoms[d_,s_,t] "Generelle afgiftsprovenu (oms/moms) fordelt på efterspørgselskomponenter og brancher, Kilde: ADAM[Spg_<d>]"
    vtMoms_y[d_,s,t]$(d1IOy[d_,s,t]) "Generelle afgiftsprovenu (oms/moms) fordelt på efterspørgselskomponenter og indenlandske brancher."
    vtMoms_m[d_,s,t]$(d1IOm[d_,s,t]) "Generelle afgiftsprovenu (oms/moms) fordelt på efterspørgselskomponenter og import-grupper."
    vtNetAfg[d_,s_,t] "Provenu af punktafgifter fordelt på efterspørgselskomponenter og brancher inkl. subsidier og registreringsafgift, Kilde: ADAM[Spp_<d>]"
    vtNetAfg_y[d_,s,t]$(d1IOy[d_,s,t]) "Provenu af punktafgifter (inkl. subsidier og registreringsafgift) fordelt på efterspørgselskomponenter og indenlandske brancher."
    vtNetAfg_m[d_,s,t]$(d1IOm[d_,s,t]) "Provenu af punktafgifter (inkl. subsidier og registreringsafgift) fordelt på efterspørgselskomponenter og import-grupper."
    vtAfg[d_,s_,t] "Provenu af punktafgifter fordelt på efterspørgselskomponenter og brancher ekskl. registreringsafgift."
    vtAfg_y[d_,s,t]$(d1IOy[d_,s,t]) "Provenu af punktafgifter fordelt på efterspørgselskomponenter og indenlandske brancher ekskl. registreringsafgift."
    vtAfg_m[d_,s,t]$(d1IOm[d_,s,t]) "Provenu af punktafgifter fordelt på efterspørgselskomponenter og import-grupper ekskl. registreringsafgift."
    vSub_y[d_,s,t]$(d1IOy[d_,s,t]) "Udgift til produktsubsidier fordelt på efterspørgselskomponenter og indenlandske brancher."
    vSub_m[d_,s,t]$(d1IOm[d_,s,t]) "Udgift til produktsubsidier fordelt på efterspørgselskomponenter og import-grupper."
    vSub[d_,s_,t] "Udgift til produktsubsidier fordelt på efterspørgselskomponenter og brancher."
    vtReg[d_,s_,t] "Registreringsafgiftsprovenu, Kilde: ADAM[Spr_<d_>]"
    vtReg_y[d_,s,t]$(d1IOy[d_,s,t]) "Registreringsafgiftsprovenu fordelt på efterspørgselskomponenter og indenlandske brancher."
    vtReg_m[d_,s,t]$(d1IOm[d_,s,t]) "Registreringsafgiftsprovenu fordelt på efterspørgselskomponenter og import-grupper."
    vtTold[d_,s_,t] "Toldprovenu fordelt på efterspørgselskomponenter og brancher, Kilde: ADAM[Spm_<i>]"

    vtGrund[s_,t]$(d1K['iB',s_,t]) "Ejendomsskatter fordelt på brancher, Kilde: ADAM[Spzej], ADAM[Spzejh] og ADAM[bspzej_x<i>]*ADAM[Spzejxh]"
    vtVirkVaegt[s_,t]$(d1K['iM',s_,t]) "Vægtafgifter fra erhvervene fordelt på brancher, Kilde: ADAM[Spzv] og ADAM[bspzv_x<i>]"
    vtVirkAM[s_,t] "Provenu af arbejdsmarkedsbidrag (AMBI) vedr. værditilvækst eller lønsum, Kilde: ADAM[Spzam] og ADAM[bspzam_x<i>]"
    vtAUB[s_,t] "Provenu fra AUB - arbejdsgivernes uddannelsesbidrag mv. fra erhvervene, Kilde: ADAM[Spzaud] og ADAM[bspzaud_x<i>]"
    vtCO2[s_,t] "Grøn afgift, bortauktionering af CO2 kvoter fra 2013, Kilde: ADAM[Spzco2] og ADAM[bspzco2_x<i>]"
    vSubLoen[s_,t] "Provenu fra løntilskud fordelt på brancher, Kilde: ADAM[Spzul] og ADAM[bspzul_x<i>]"
    vtNetLoenAfg[s_,t] "Ikke-varefordelte indirekte afgifter vedrørende lønsum, Kilde: ADAM[Spzl] og ADAM[Spzl_x<i>]"
    vtNetY[s_,t] "Andre produktionsskatter (ikke-varefordelte indirekte skatter), netto, Kilde: ADAM[Spz]"
    vtNetYRest[s_,t]$(s[s_] or sTot[s_] or spTot[s_]) "Andre produktionsskatter, Restdel, Kilde: ADAM[Spzr]-(ADAM[Spzu]-ADAM[Spzul])"

    vtY[s_,t]$(sTot[s_] or s[s_]) "Produktionsskatter, brutto, Kilde: ADAM[Spz]-ADAM[Spzu] og imputeret branchefordeling"
    vtYRest[s_,t]$(sTot[s_] or s[s_]) "Øvrige produktionsskatter, Kilde: ADAM[Spzr]"

    tNetAfg_y[d_,s,t]$(d1IOy[d_,s,t]) "Punktafgiftssats inkl. subsidier og registreringsafgift fordelt på efterspørgsels og indenlandske brancher."
    tNetAfg_m[d_,s,t]$(d1IOm[d_,s,t]) "Punktafgiftssats inkl. subsidier og registreringsafgift fordelt på efterspørgsels og import-grupper."

    tIOy[d_,s,t]$(d1IOy[d_,s,t]) "Samlet afgiftssats for moms og punktafgifter inkl. subsidier og registreringsafgift fordelt på efterspørgselskomponenter og indenlandske brancher."
    tIOm[d_,s,t]$(d1IOm[d_,s,t]) "Samlet afgiftssats for moms og punktafgifter inkl. subsidier og registreringsafgift fordelt på efterspørgselskomponenter og import-grupper."

    tK[k,s_,t]$(sTot[s_] or spTot[s_]) "Kapitalafgiftssats (hhv. ejendomsskatter og vægtafgift)"
    tVirkAM[s_,t]$(sTot[s_]) "Afgiftssats for AM-bidrag betalt af virksomheder "
    tAUB[s_,t]$(sTot[s_]) "Afgiftssats for AUB-bidrag betalt af virksomheder."
    rSubLoen[s_,t]$(sTot[s_]) "Sats for løntilskud."

    tYRest[s_,t]$(sTot[s_]) "Øvrige produktionsskatter."
    tE[s_,t]$(spTot[s_]) "Energiafgiftssats - grøn afgift og bortauktionering af CO2 kvoter"

    tMoms[d_,t]$(d[d_]) "Implicit aggregeret momssats fordelt på efterspørgselskomponenter."
  ;
  $GROUP G_taxes_endo G_taxes_endo$(tx0[t]); # Restrict endo group to tx0[t]
  
  $GROUP G_taxes_exogenous_forecast ;
  $GROUP G_taxes_forecast_as_zero ;
  $GROUP G_taxes_ARIMA_forecast 
    tMoms_y[d_,s,t]$(d[d_]) "Momssats fordelt på efterspørgselskomponenter og input fra indenlandske brancher."
    tMoms_m[d_,s,t]$(d[d_]) "Momssats fordelt på efterspørgselskomponenter og input fra indenlandske brancher."
  ;
  $GROUP G_taxes_newdata_fixed_forecast
    rSubLoen[s_,t]$(s[s_])
    tK[k,s_,t]$(s[s_])
    tVirkAM[s_,t]$(s[s_])
    tAUB[s_,t]$(s[s_])
    tE[s,t]
    vtVirkVaegt[s_,t]$(bol[s_])

    tAfg_y[d_,s,t] "Punktafgiftssats ekskl. subsidier og registreringsafgift fra indenlandske brancher"
    tAfg_m[d_,s,t] "Punktafgiftssats ekskl. subsidier og registreringsafgift fra import-grupper"
    rSub_y[d_,s,t] "Sats for produktsubsidier fra indenlandske brancher."
    rSub_m[d_,s,t] "Sats for produktsubsidier fra import-grupper."
    tTold[d_,s_,t]$(d[d_]) "Toldsats fordelt på efterspørgselskomponenter og input fra import-grupper."
    tReg_y[d_,s,t]$(d[d_]) "Registreringsafgiftssats for biler."
    tReg_m[d_,s,t]$(d[d_]) "Registreringsafgiftssats for biler."

    tYRest[s_,t]$(s[s_]) "Øvrige produktionsskatter."

    rSub0_t[t] "Hjælpevariabel til at kalibrere de samlede produktsubsidier."
    rSub0_s[s,t] "Hjælpevariabel til at kalibrere de samlede produktsubsidier."
  ;
  $GROUP G_IO_taxes # Bruges til at fremsrkive skatter på lagerinvesteringer
    tMoms_y, tMoms_m
    tAfg_y, tAfg_m
    rSub_y, rSub_m
    tTold
    tReg_y, tReg_m
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_taxes$(tx0[t])
    # Samlet provenue for told, netto-afgifter og moms
    E_vtIOy[d,s,t]$(d1IOy[d,s,t])..
      vtIOy[d,s,t] =E= vtNetAfg_y[d,s,t] + vtMoms_y[d,s,t] + vtReg_y[d,s,t];

    E_vtIOm[d,s,t]$(d1IOm[d,s,t])..
      vtIOm[d,s,t] =E= vtNetAfg_m[d,s,t] + vtMoms_m[d,s,t] + vtReg_m[d,s,t] + vtTold[d,s,t];

    # Samlet sats for told, netto-afgifter og moms
    E_tIOy[d,s,t]$(d1IOy[d,s,t])..
      tIOy[d,s,t] * (vIOy[d,s,t] - vtIOy[d,s,t]) =E= vtIOy[d,s,t];

    E_tIOm[d,s,t]$(d1IOm[d,s,t])..
      tIOm[d,s,t] * (vIOm[d,s,t] - vtIOm[d,s,t]) =E= vtIOm[d,s,t];

    # Nettoprovenu fra punktafgifter, produktsubsidier og registreringsafgifter   
    E_vtNetAfg[d,s,t].. vtNetAfg[d,s,t] =E= vtNetAfg_y[d,s,t] + vtNetAfg_m[d,s,t];

    E_vtNetAfg_y[d,s,t]$(d1IOy[d,s,t])..
      vtNetAfg_y[d,s,t] =E= vtAfg_y[d,s,t] - vSub_y[d,s,t];

    E_vtNetAfg_m[d,s,t]$(d1IOm[d,s,t])..
      vtNetAfg_m[d,s,t] =E= vtAfg_m[d,s,t] - vSub_m[d,s,t];

    # Provenu fra told
    E_vtTold[d,s,t].. vtTold[d,s,t] =E= tTold[d,s,t] * (vIOm[d,s,t] - vtIOm[d,s,t]);

    # Provenu fra punktafgifter 
    E_vtAfg[d,s,t].. vtAfg[d,s,t] =E= vtAfg_y[d,s,t] + vtAfg_m[d,s,t];

    E_vtAfg_y[d,s,t]$(d1IOy[d,s,t])..
      vtAfg_y[d,s,t] =E= tAfg_y[d,s,t] * pnCPI[cTot,t-1]/fp * qIOy[d,s,t];

    E_vtAfg_m[d,s,t]$(d1IOm[d,s,t])..
      vtAfg_m[d,s,t] =E= tAfg_m[d,s,t] * (1 + tTold[d,s,t]) * pnCPI[cTot,t-1]/fp * qIOm[d,s,t];

    # Udgifter til produktsubsidier
    E_vSub[d,s,t].. vSub[d,s,t] =E= vSub_y[d,s,t] + vSub_m[d,s,t];

    E_vSub_y[d,s,t]$(d1IOy[d,s,t])..
      vSub_y[d,s,t] =E= rSub_y[d,s,t] * pnCPI[cTot,t-1]/fp * qIOy[d,s,t];

    E_vSub_m[d,s,t]$(d1IOm[d,s,t])..
      vSub_m[d,s,t] =E= rSub_m[d,s,t] * (1 + tTold[d,s,t]) * pnCPI[cTot,t-1]/fp * qIOm[d,s,t];

    # Provenu fra moms  
    E_vtMoms[d,s,t].. vtMoms[d,s,t] =E= vtMoms_y[d,s,t] + vtMoms_m[d,s,t];

    E_vtMoms_y[d,s,t]$(d1IOy[d,s,t])..
      vtMoms_y[d,s,t] =E= tMoms_y[d,s,t] * (vIOy[d,s,t] - vtIOy[d,s,t] + vtNetAfg_y[d,s,t]);

    E_vtMoms_m[d,s,t]$(d1IOm[d,s,t])..
      vtMoms_m[d,s,t] =E= tMoms_m[d,s,t] * (vIOm[d,s,t] - vtIOm[d,s,t] + vtNetAfg_m[d,s,t] + vtTold[d,s,t]);

    # Provenu fra registreringsafgifter
    E_vtReg[d,s,t].. vtReg[d,s,t] =E= vtReg_y[d,s,t] + vtReg_m[d,s,t];

    E_vtReg_y[d,s,t]$(d1IOy[d,s,t])..
      vtReg_y[d,s,t] =E= tReg_y[d,s,t] * (vIOy[d,s,t] - vtIOy[d,s,t] + vtNetAfg_y[d,s,t] + vtMoms_y[d,s,t]);

    E_vtReg_m[d,s,t]$(d1IOm[d,s,t])..
      vtReg_m[d,s,t] =E= tReg_m[d,s,t] * (vIOm[d,s,t] - vtIOm[d,s,t] + vtNetAfg_m[d,s,t] + vtMoms_m[d,s,t] + vtTold[d,s,t]);

    # Nettoskattesatser - bruges p.t. til at kalibrere
    # De kan fjernes ved at vtNetAfg_y og vtNetAfg_m indlæses fra data istedet (kræver ændring i makrobk)
    E_tNetAfg_y[d,s,t]$(d1IOy[d,s,t])..
      tNetAfg_y[d,s,t] =E= (tAfg_y[d,s,t] - rSub_y[d,s,t]) * pnCPI[cTot,t-1]/fp / pIOy[d,s,t] * (1 + tIOy[d,s,t]);
    E_tNetAfg_m[d,s,t]$(d1IOm[d,s,t])..
      tNetAfg_m[d,s,t] =E= (tAfg_m[d,s,t] - rSub_m[d,s,t]) * pnCPI[cTot,t-1]/fp / pIOm[d,s,t] * (1 + tIOm[d,s,t]);

    # PRODUCTION TAXES - brancheniveau
    E_vtGrund[s,t]$(d1K['iB',s,t])..
      vtGrund[s,t] =E= tK['iB',s,t] * pI_s['iB',s,t] * qK['iB',s,t-1]/fq;
    E_vtVirkVaegt[s,t]$(d1K['iM',s,t])..
      vtVirkVaegt[s,t] =E= tK['iM',s,t] * pI_s['iM',s,t] * qK['iM',s,t-1]/fq;

    E_vtVirkAM[s,t].. vtVirkAM[s,t] =E= tVirkAM[s,t] * vLoensum[s,t];

    E_vtAUB[s,t].. vtAUB[s,t] =E= tAUB[s,t] * vLoensum[s,t];

    E_vSubLoen[s,t].. vSubLoen[s,t] =E= rSubLoen[s,t] * vLoensum[s,t];

    E_vtNetLoenAfg[s,t].. vtNetLoenAfg[s,t] =E= vtVirkAM[s,t] + vtAUB[s,t] - vSubLoen[s,t];

    # Grønne afgifter på landbrug forventes primært knyttet til udledninger, som ikke afhænger af energiforbrug. Landbruget særbehandles derfor.
    E_vtCO2[s,t].. vtCO2[s,t] =E= tE[s,t] * (vE[s,t] + vY[s,t]$(lan[s]));

    E_vtNetYRest[s,t].. vtNetYRest[s,t] =E= vtYRest[s,t] - vSubYRest[s,t]; 

    E_vtNetY[s,t]..
      vtNetY[s,t] =E= vtGrund[s,t] + vtVirkVaegt[s,t] + vtCO2[s,t] + vtNetLoenAfg[s,t] + vtNetYRest[s,t];

    E_vtYRest[s,t].. vtYRest[s,t] =E= tYRest[s,t] * vY[s,t];

    E_vtY[s,t]..
      vtY[s,t] =E= vtGrund[s,t] + vtVirkVaegt[s,t] + vtCO2[s,t] + vtVirkAM[s,t] + vtAUB[s,t] + vtYRest[s,t];

    # PRODUCTION TAXES - aggregater
    E_vtGrund_sTot[t]..       
      vtGrund[sTot,t] =E= tK['iB',sTot,t] * pKI['iB',sTot,t] * qK['iB',sTot,t-1]/fq;
    E_vtVirkVaegt_sTot[t]..
      vtVirkVaegt[sTot,t] =E= tK['iM',sTot,t] * pKI['iM',sTot,t] * qK['iM',sTot,t-1]/fq;

    E_vtVirkAM_sTot[t].. vtVirkAM[sTot,t] =E= tVirkAM[sTot,t] * vLoensum[sTot,t];

    E_vtAUB_sTot[t].. vtAUB[sTot,t] =E= tAUB[sTot,t] * vLoensum[sTot,t];

    E_vSubLoen_sTot[t].. vSubLoen[sTot,t] =E= rSubLoen[sTot,t] * vLoensum[sTot,t];

    E_vtNetLoenAfg_sTot[t].. vtNetLoenAfg[sTot,t] =E= vtVirkAM[sTot,t] + vtAUB[sTot,t] - vSubLoen[sTot,t];

    E_vtCO2_sTot[t].. vtCO2[sTot,t] =E= sum(s, vtCO2[s,t]);
    
    E_vtNetYRest_sTot[t].. vtNetYRest[sTot,t] =E= vtYRest[sTot,t] - vSubYRest[sTot,t]; 

    E_vtYRest_sTot[t].. vtYRest[sTot,t] =E= tYRest[sTot,t] * vY[sTot,t];

    E_vtNetY_sTot[t]..
      vtNetY[sTot,t] =E= vtGrund[sTot,t] + vtVirkVaegt[sTot,t] + vtCO2[sTot,t] + vtNetLoenAfg[sTot,t] + vtNetYRest[sTot,t];

    E_vtY_sTot[t]..
      vtY[sTot,t] =E= vtGrund[sTot,t] + vtVirkVaegt[sTot,t] + vtCO2[sTot,t] + vtVirkAM[sTot,t] + vtAUB[sTot,t] + vtYRest[sTot,t];

    # PRODUCTION TAXES - aggregerede implicitte skattesatser
    E_tK_iB_sTot[t].. vtGrund[sTot,t] =E= sum(s, vtGrund[s,t]);
    E_tK_iM_sTot[t].. vtVirkVaegt[sTot,t] =E= sum(s, vtVirkVaegt[s,t]);
    E_tVirkAM_sTot[t].. vtVirkAM[sTot,t] =E= sum(s, vtVirkAM[s,t]);
    E_tAUB_sTot[t].. vtAUB[sTot,t] =E= sum(s, vtAUB[s,t]);
    E_tSubLoen_sTot[t].. vSubLoen[sTot,t] =E= sum(s, vSubLoen[s,t]);
    E_tYRest_sTot[t].. vtYRest[sTot,t] =E= sum(s, vtYRest[s,t]);

    E_tK_spTot[k,t]..
      tK[k,spTot,t] * pKI[k,spTot,t] * qK[k,spTot,t-1]/fq =E= sum(sp, tK[k,sp,t] * pI_s[k,sp,t] * qK[k,sp,t-1]/fq);

    E_tE_spTot[t]..
      tE[spTot,t] * vE[spTot,t] =E= vtCO2[spTot,t] - tE[lan,t] * vY[lan,t];

    # Samlet provenue fra efterspørgselssiden for given branche på udbudssiden
    E_vtAfg_dTot_s[s,t].. vtAfg[dTot,s,t] =E= sum(d, vtAfg[d,s,t]);

    # Samlet udgift fra efterspørgselssiden for given branche på udbudssiden
    E_vSub_dTot_s[s,t].. vSub[dTot,s,t] =E= sum(d, vSub[d,s,t]);

    # ----------------------------------------------------------------------------------------------------------------------
    # Branche-totaler
    # ----------------------------------------------------------------------------------------------------------------------
    E_vtTold_sTot[d,t]..   vtTold[d,sTot,t]   =E= sum(s, vtTold[d,s,t]);
    E_vtAfg_sTot[d,t]..    vtAfg[d,sTot,t]    =E= sum(s, vtAfg[d,s,t]);
    E_vSub_sTot[d,t]..     vSub[d,sTot,t]     =E= sum(s, vSub[d,s,t]);
    E_vtNetAfg_sTot[d,t].. vtNetAfg[d,sTot,t] =E= sum(s, vtNetAfg[d,s,t]);
    E_vtMoms_sTot[d,t]..   vtMoms[d,sTot,t]   =E= sum(s, vtMoms[d,s,t]);
    E_vtReg_sTot[d,t]..    vtReg[d,sTot,t]    =E= sum(s, vtReg[d,s,t]);

    E_vtNetYRest_spTot[t].. vtNetYRest[spTot,t] =E= vtNetYRest[sTot,t] - vtNetYRest['off',t]; 

    E_vtGrund_spTot[t]..       vtGrund[spTot,t]      =E= sum(sp, vtGrund[sp,t]);
    E_vtVirkVaegt_spTot[t]..   vtVirkVaegt[spTot,t]  =E= sum(sp, vtVirkVaegt[sp,t]);
    E_vtVirkAM_spTot[t]..      vtVirkAM[spTot,t]     =E= sum(sp, vtVirkAM[sp,t]);
    E_vtAUB_spTot[t]..         vtAUB[spTot,t]        =E= sum(sp, vtAUB[sp,t]);
    E_vtCO2_spTot[t]..         vtCO2[spTot,t]        =E= sum(sp, vtCO2[sp,t]);
    E_vSubLoen_spTot[t]..      vSubLoen[spTot,t]     =E= sum(sp, vSubLoen[sp,t]);
    E_vtNetLoenAfg_spTot[t]..  vtNetLoenAfg[spTot,t] =E= sum(sp, vtNetLoenAfg[sp,t]);
    E_vtNetY_spTot[t]..        vtNetY[spTot,t]       =E= sum(sp, vtNetY[sp,t]);

    # ----------------------------------------------------------------------------------------------------------------------
    # Efterspørgsels-totaler
    # ----------------------------------------------------------------------------------------------------------------------
    E_vtMoms_cTot[t].. vtMoms[cTot,sTot,t] =E= sum(c, vtMoms[c,sTot,t]);
    E_vtMoms_gTot[t].. vtMoms[gTot,sTot,t] =E= sum(g, vtMoms[g,sTot,t]);
    E_vtMoms_xTot[t].. vtMoms[xTot,sTot,t] =E= sum(x, vtMoms[x,sTot,t]);
    E_vtMoms_rTot[t].. vtMoms[rTot,sTot,t] =E= sum(r, vtMoms[r,sTot,t]);
    E_vtMoms_iTot[t].. vtMoms[iTot,sTot,t] =E= sum(i, vtMoms[i,sTot,t]);
    E_vtMoms_dTot[t].. vtMoms[dTot,sTot,t] =E= vtMoms[cTot,sTot,t]
                                                      + vtMoms[gTot,sTot,t]
                                                      + vtMoms[xTot,sTot,t]
                                                      + vtMoms[iTot,sTot,t]
                                                      + vtMoms[rTot,sTot,t];

    E_vtNetAfg_cTot[t].. vtNetAfg[cTot,sTot,t] =E= sum(c, vtNetAfg[c,sTot,t]);
    E_vtNetAfg_gTot[t].. vtNetAfg[gTot,sTot,t] =E= sum(g, vtNetAfg[g,sTot,t]);
    E_vtNetAfg_xTot[t].. vtNetAfg[xTot,sTot,t] =E= sum(x, vtNetAfg[x,sTot,t]);   
    E_vtNetAfg_rTot[t].. vtNetAfg[rTot,sTot,t] =E= sum(r, vtNetAfg[r,sTot,t]);
    E_vtNetAfg_iTot[t].. vtNetAfg[iTot,sTot,t] =E= sum(i, vtNetAfg[i,sTot,t]);
    E_vtNetAfg_dTot[t].. vtNetAfg[dTot,sTot,t] =E= vtNetAfg[cTot,sTot,t]
                                                          + vtNetAfg[gTot,sTot,t]
                                                          + vtNetAfg[xTot,sTot,t]
                                                          + vtNetAfg[iTot,sTot,t]
                                                          + vtNetAfg[rTot,sTot,t];

    E_vtAfg_cTot[t].. vtAfg[cTot,sTot,t] =E= sum(c, vtAfg[c,sTot,t]);
    E_vtAfg_gTot[t].. vtAfg[gTot,sTot,t] =E= sum(g, vtAfg[g,sTot,t]);
    E_vtAfg_xTot[t].. vtAfg[xTot,sTot,t] =E= sum(x, vtAfg[x,sTot,t]);
    E_vtAfg_rTot[t].. vtAfg[rTot,sTot,t] =E= sum(r, vtAfg[r,sTot,t]);
    E_vtAfg_iTot[t].. vtAfg[iTot,sTot,t] =E= sum(i, vtAfg[i,sTot,t]);
    E_vtAfg_dTot[t].. vtAfg[dTot,sTot,t] =E= vtAfg[cTot,sTot,t]
                                                    + vtAfg[gTot,sTot,t]
                                                    + vtAfg[xTot,sTot,t]
                                                    + vtAfg[iTot,sTot,t]
                                                    + vtAfg[rTot,sTot,t];
    E_vSub_cTot[t].. vSub[cTot,sTot,t] =E= sum(c, vSub[c,sTot,t]);
    E_vSub_gTot[t].. vSub[gTot,sTot,t] =E= sum(g, vSub[g,sTot,t]);
    E_vSub_xTot[t].. vSub[xTot,sTot,t] =E= sum(x, vSub[x,sTot,t]);
    E_vSub_rTot[t].. vSub[rTot,sTot,t] =E= sum(r, vSub[r,sTot,t]);
    E_vSub_iTot[t].. vSub[iTot,sTot,t] =E= sum(i, vSub[i,sTot,t]);
    E_vSub_dTot[t].. vSub[dTot,sTot,t] =E= vSub[cTot,sTot,t]
                                                  + vSub[gTot,sTot,t]
                                                  + vSub[xTot,sTot,t]
                                                  + vSub[iTot,sTot,t]
                                                  + vSub[rTot,sTot,t];

    E_vtReg_cTot[t].. vtReg[cTot,sTot,t] =E= sum(c, vtReg[c,sTot,t]);
    E_vtReg_gTot[t].. vtReg[gTot,sTot,t] =E= sum(g, vtReg[g,sTot,t]);
    E_vtReg_xTot[t].. vtReg[xTot,sTot,t] =E= sum(x, vtReg[x,sTot,t]);
    E_vtReg_rTot[t].. vtReg[rTot,sTot,t] =E= sum(r, vtReg[r,sTot,t]);
    E_vtReg_iTot[t].. vtReg[iTot,sTot,t] =E= sum(i, vtReg[i,sTot,t]);
    E_vtReg_dTot[t].. vtReg[dTot,sTot,t] =E= vtReg[cTot,sTot,t]
                                                   + vtReg[gTot,sTot,t]
                                                   + vtReg[xTot,sTot,t]
                                                   + vtReg[iTot,sTot,t]
                                                   + vtReg[rTot,sTot,t];

    E_vtTold_rTot[t].. vtTold[rTot,sTot,t] =E= sum(r, vtTold[r,sTot,t]);
    E_vtTold_iTot[t].. vtTold[iTot,sTot,t] =E= sum(i, vtTold[i,sTot,t]);
    E_vtTold_gTot[t].. vtTold[gTot,sTot,t] =E= sum(g, vtTold[g,sTot,t]);
    E_vtTold_cTot[t].. vtTold[cTot,sTot,t] =E= sum(c, vtTold[c,sTot,t]);
    E_vtTold_xtot[t].. vtTold[xTot,sTot,t] =E= sum(x, vtTold[x,sTot,t]);
    E_vtTold_dTot[t].. vtTold[dTot,sTot,t] =E= vtTold[cTot,sTot,t]
                                                      + vtTold[gTot,sTot,t] 
                                                      + vtTold[rTot,sTot,t] 
                                                      + vtTold[iTot,sTot,t] 
                                                      + vtTold[xTot,sTot,t];
    # ----------------------------------------------------------------------------------------------------------------------
    # Implicitte skattesatser for aggregater
    # ----------------------------------------------------------------------------------------------------------------------
    # Ingen moms på eksport - så ingen implicitte momssatser for disse - derfor benyttes dux
    E_tMoms[dux,t].. 
      tMoms[dux,t] =E= vtMoms[dux,sTot,t] / sum(s, vIO[dux,s,t] - (vtIOy[dux,s,t] + vtIOm[dux,s,t])
                                                   + vtNetAfg_y[dux,s,t] + vtNetAfg_m[dux,s,t] + vtTold[dux,s,t]);
  $ENDBLOCK

  # Equations that do not need to be solved together with the full model and can instead be solved afterwards.
  MODEL M_taxes_post /
    #  E_tK_spTot
    E_vtGrund_spTot
    E_vtVirkVaegt_spTot
    E_vtVirkAM_spTot
    E_vtAUB_spTot
    E_vSubLoen_spTot
    E_vtNetLoenAfg_spTot
    E_vtNetY_spTot
  /;

  # Endogenous variables that are solved for only after the main model.
  # Note that these may not appear anywhere in the main model (this results in a model not square error).
  $GROUP G_taxes_post
    #  tK[k,s_,t]$(spTot[s_])
    vtGrund$(spTot[s_])
    vtVirkVaegt$(spTot[s_])
    vtVirkAM$(spTot[s_])
    vtAUB$(spTot[s_])
    vSubLoen$(spTot[s_])
    vtNetLoenAfg$(spTot[s_])
    vtNetY$(spTot[s_])
  ;
  $GROUP G_taxes_post G_taxes_post$(tx0[t]);

$ENDIF

$IF %stage% == "exogenous_values":
# ======================================================================================================================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_taxes_makrobk
    vtReg, vSub[dTot,sTot,t], vSub[dTot,ene,t]
    tNetAfg_y$(d1IOy[d_,s,t]), tNetAfg_m$(d1IOm[d_,s,t]), 
    tReg_y, tReg_m
    tTold, tMoms_y, tMoms_m, 
    tK$(s[s_]), tVirkAM$(s[s_]), tAUB$(s[s_]), rSubLoen$(s[s_]), vtNetY$(s[s_] or sTot[s_]), vtNetYRest$(s[s_] or sTot[s_]),
    vtY$(sTot[s_]), vtYRest
    vtTold, vtGrund$(s[s_] or sTot[s_]), vtVirkVaegt$(s[s_] or sTot[s_]), vtAUB$(s[s_] or sTot[s_]), vtCO2$(s[s_] or sTot[s_]), 
    vtVirkAM$(s[s_] or sTot[s_]), vSubLoen$(s[s_] or sTot[s_]), vtNetLoenAfg$(s[s_] or sTot[s_])
    vtMoms$(not sameas[d_,'tot']), vtNetAfg$(not sameas[d_,'tot']) # Der beregnes ikke en samlet total for energi og ikke-energi i data
  ;
  @load(G_taxes_makrobk, "..\Data\makrobk\makrobk.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_taxes_data  
    G_taxes_makrobk
  ;

  $GROUP G_taxes_data_imprecise
    vtNetYRest$(s[s_] or sTot[s_])
    vtY$(sTot[s_]), vtYRest, vtNetY$(s[s_] or sTot[s_])
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================

# ======================================================================================================================
# Data assignment
# ======================================================================================================================
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_taxes_static_calibration 
    G_taxes_endo

    tAfg_y[d_,s,t]$(d1IOy[d_,s,t]), -tNetAfg_y[d_,s,t]$(d1IOy[d_,s,t])
    tAfg_m[d_,s,t]$(d1IOm[d_,s,t]), -tNetAfg_m[d_,s,t]$(d1IOm[d_,s,t])

    rSub_y[d_,s,t]$(d1IOy[d_,s,t]) # E_rSub_y
    rSub_m[d_,s,t]$(d1IOm[d_,s,t]) # E_rSub_m

    rSub0_t[t], -vSub[dTot,sTot,t]
    rSub0_s[ene,t], -vSub[dTot,ene,t]
    tE[s,t], -vtCO2[s,t]

    tYRest[s,t], -vtYRest[s,t]

    -vtNetY[off,t], vSubYRest[off,t]
  ;
  $GROUP G_taxes_static_calibration G_taxes_static_calibration$(tx0[t]);

  $BLOCK B_taxes_static_calibration$(tx0[t])
    E_rSub_y[d,s,t]$(d1IOy[d,s,t])..
      rSub_y[d,s,t] =E= (-tNetAfg_y[d,s,t] * pIOy[d,s,t] / (1+tIOy[d,s,t]) / (pnCPI[cTot,t-1]/fp)) $ (tNetAfg_y.l[d,s,t] < 0)
                      + (rSub0_t[t] + rSub0_s[s,t]) $ (tNetAfg_y.l[d,s,t] <> 0 and not i_[d]);

    E_rSub_m[d,s,t]$(d1IOm[d,s,t])..
      rSub_m[d,s,t] =E= (-tNetAfg_m[d,s,t] * pIOm[d,s,t] / (1+tIOm[d,s,t]) / (pnCPI[cTot,t-1]/fp)) $ (tNetAfg_m.l[d,s,t] < 0)
                      + (rSub0_t[t] + rSub0_s[s,t]) $ (tNetAfg_m.l[d,s,t] <> 0 and not i_[d]);
  $ENDBLOCK
  MODEL M_taxes_static_calibration /
    B_taxes
    B_taxes_static_calibration
  /;

  $GROUP G_taxes_static_calibration_newdata
    G_taxes_static_calibration
   ;
  MODEL M_taxes_static_calibration_newdata /
    M_taxes_static_calibration
  /;
$ENDIF

# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
# No changes so base-groups used in dynamic_calibration_newdata.gms
#  $GROUP G_taxes_dynamic_calibration
#    G_taxes_endo
#  ;
# No changes so base-model used in dynamic_calibration_newdata.gms
#  MODEL M_taxes_dynamic_calibration / 
#    B_taxes
#  /;
$ENDIF