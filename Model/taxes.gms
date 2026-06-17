# ======================================================================================================================
# Taxes
# - Tax rates and revenue
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_taxes_variables
    vtIOy[d_,s,t] "Samlet afgiftsprovenue for moms og punktafgifter inkl. subsidier og registreringsafgift fordelt på efterspørgselskomponenter og indenlandske brancher."
    vtIOm[d_,s,t] "Samlet afgiftsprovenue for told, moms og punktafgifter inkl. subsidier og registreringsafgift fordelt på efterspørgselskomponenter og import-grupper."
    vtMoms_y[d_,s,t] "Generelle afgiftsprovenu (oms/moms) fordelt på efterspørgselskomponenter og indenlandske brancher."
    vtMoms_m[d_,s,t] "Generelle afgiftsprovenu (oms/moms) fordelt på efterspørgselskomponenter og import-grupper."
    vtMoms_y_k[i_,r_,s_,t]$(k[i_] and d1IOy[i_,s_,t] and d1I_s[i_,r_,t]) "Generelle afgiftsprovenu (oms/moms) fordelt på efterspørgselskomponenter og indenlandske brancher fordelt på kapitaltype og branche til at foretage investeringingen"
    vtMoms_m_k[i_,r_,s_,t]$(k[i_] and d1IOm[i_,s_,t] and d1I_s[i_,r_,t]) "Generelle afgiftsprovenu (oms/moms) fordelt på efterspørgselskomponenter og import-grupper fordelt på kapitaltype og branche til at foretage investeringingen"
    vtNetAfg_y[d_,s,t] "Provenu af punktafgifter inkl. subsidier fordelt på efterspørgselskomponenter og indenlandske brancher."
    vtNetAfg_m[d_,s,t] "Provenu af punktafgifter inkl. subsidier fordelt på efterspørgselskomponenter og import-grupper."
    vtAfg_y_k[i_,r_,s_,t]$(k[i_] and d1IOy[i_,s_,t] and d1I_s[i_,r_,t]) "Provenu af punktafgifter ekskl. subsidier og registreringsafgift fra indenlandske brancher fordelt på kapitaltype og branche til at foretage investeringingen"
    vtAfg_m_k[i_,r_,s_,t]$(k[i_] and d1IOm[i_,s_,t] and d1I_s[i_,r_,t]) "Provenu af punktafgifter ekskl. subsidier og registreringsafgift fra import-grupper fordelt på kapitaltype og branche til at foretage investeringingen"
    vSub_y_k[i_,r_,s_,t]$(k[i_] and d1IOy[i_,s_,t] and d1I_s[i_,r_,t]) "Produktsubsidier fra indenlandske brancher fordelt på kapitaltype og branche til at foretage investeringingen."
    vSub_m_k[i_,r_,s_,t]$(k[i_] and d1IOm[i_,s_,t] and d1I_s[i_,r_,t]) "Sats for produktsubsidier fra import-grupper fordelt på kapitaltype og branche til at foretage investeringingen."
    vtAfg_y[d_,s,t] "Provenu af punktafgifter fordelt på efterspørgselskomponenter og indenlandske brancher ekskl. registreringsafgift."
    vtAfg_m[d_,s,t] "Provenu af punktafgifter fordelt på efterspørgselskomponenter og import-grupper ekskl. registreringsafgift."
    vSub_y[d_,s,t] "Udgift til produktsubsidier fordelt på efterspørgselskomponenter og indenlandske brancher."
    vSub_m[d_,s,t] "Udgift til produktsubsidier fordelt på efterspørgselskomponenter og import-grupper."
    vtReg_y[d_,s,t] "Registreringsafgiftsprovenu fordelt på efterspørgselskomponenter og indenlandske brancher."
    vtReg_m[d_,s,t] "Registreringsafgiftsprovenu fordelt på efterspørgselskomponenter og import-grupper."
    vtGrund[s_,t] "Ejendomsskatter fordelt på brancher, Kilde: ADAM[Spzej], ADAM[Spzejh] og ADAM[bspzej_x<i>]*ADAM[Spzejxh]"
    vtVirkAM[s_,t] "Provenu af arbejdsmarkedsbidrag (AMBI) vedr. værditilvækst eller lønsum, Kilde: ADAM[Spzam] og ADAM[bspzam_x<i>]"
    vtAUB[s_,t] "Provenu fra AUB - arbejdsgivernes uddannelsesbidrag mv. fra erhvervene, Kilde: ADAM[Spzaud] og ADAM[bspzaud_x<i>]"
    vtCO2[s_,t] "Grøn afgift, bortauktionering af CO2 kvoter fra 2013, Kilde: ADAM[Spzco2] og ADAM[bspzco2_x<i>]"
    vSubLoen[s_,t] "Provenu fra løntilskud fordelt på brancher, Kilde: ADAM[Spzul] og ADAM[bspzul_x<i>]"
    vtNetLoenAfg[s_,t] "Ikke-varefordelte indirekte afgifter vedrørende lønsum, Kilde: ADAM[Spzl] og ADAM[Spzl_x<i>]"
    vtNetY[s_,t] "Andre produktionsskatter (ikke-varefordelte indirekte skatter), netto, Kilde: ADAM[Spz]"
    vtNetYRest[s_,t] "Andre produktionsskatter, Restdel, Kilde: ADAM[Spzr]-(ADAM[Spzu]-ADAM[Spzul])"
    vtY[s_,t] "Produktionsskatter, brutto, Kilde: ADAM[Spz]-ADAM[Spzu] og imputeret branchefordeling"
    vtYRest[s_,t] "Øvrige produktionsskatter, Kilde: ADAM[Spzr]"
    tAUB[s_,t] "Afgiftssats for AUB-bidrag betalt af virksomheder."
    rSubLoen[s_,t] "Sats for løntilskud."
    tYRest[s_,t] "Øvrige produktionsskatter."
    tMoms[d_,t] "Implicit aggregeret momssats fordelt på efterspørgselskomponenter."
    nSubLoen[t] "Antal personer på lønstilskud"
    vtVirkVaegt[s_,t] "Vægtafgifter fra erhvervene fordelt på brancher, Kilde: ADAM[Spzv] og ADAM[bspzv_x<i>]"
    tVirkAM[s_,t] "Afgiftssats for AM-bidrag betalt af virksomheder "
    tIOy[d_,s,t] "Samlet afgiftssats for moms og punktafgifter inkl. subsidier og registreringsafgift fordelt på efterspørgselskomponenter og indenlandske brancher."
    tIOm[d_,s,t] "Samlet afgiftssats for moms og punktafgifter inkl. subsidier og registreringsafgift fordelt på efterspørgselskomponenter og import-grupper."
    vtMoms[d_,s_,t] "Generelle afgiftsprovenu (oms/moms) fordelt på efterspørgselskomponenter og brancher, Kilde: ADAM[Spg_<d>]"
    vtNetAfg[d_,s_,t] "Provenu af punktafgifter fordelt på efterspørgselskomponenter og brancher inkl. subsidier og registreringsafgift, Kilde: ADAM[Spp_<d>]"
    vtAfg[d_,s_,t] "Provenu af punktafgifter fordelt på efterspørgselskomponenter og brancher ekskl. registreringsafgift."
    vSub[d_,s_,t] "Udgift til produktsubsidier fordelt på efterspørgselskomponenter og brancher."
    vtReg[d_,s_,t] "Registreringsafgiftsprovenu, Kilde: ADAM[Spr_<d_>]"
    vtTold[d_,s_,t] "Toldprovenu fordelt på efterspørgselskomponenter og brancher, Kilde: ADAM[Spm_<i>]"
    tK[k,s_,t] "Kapitalafgiftssats (hhv. ejendomsskatter og vægtafgift)"
    tAfg_y[d_,s,t]$(d1IOy[d_,s,t]) "Punktafgiftssats ekskl. subsidier og registreringsafgift fra indenlandske brancher"
    tAfg_m[d_,s,t]$(d1IOm[d_,s,t]) "Punktafgiftssats ekskl. subsidier og registreringsafgift fra import-grupper"
    rSub_y[d_,s,t]$(d1IOy[d_,s,t]) "Sats for produktsubsidier fra indenlandske brancher."
    rSub_m[d_,s,t]$(d1IOm[d_,s,t]) "Sats for produktsubsidier fra import-grupper."
    tMoms_y[d_,s,t]$(d1IOy[d_,s,t]) "Momssats fordelt på efterspørgselskomponenter og input fra indenlandske brancher."
    tMoms_m[d_,s,t]$(d1IOm[d_,s,t]) "Momssats fordelt på efterspørgselskomponenter og input fra indenlandske brancher."
    tTold[d_,s,t]$(d1IO[d_,s,t]) "Toldsats fordelt på efterspørgselskomponenter og input fra import-grupper."
  ;
  
  $GROUP G_taxes_exogenous_forecast
    tAfg_y['iL',s,t]
    tAfg_m['iL',s,t]
    rSub_y['iL',s,t]
    rSub_m['iL',s,t]
    tTold['iL',s,t]
    tMoms_y['iL',s,t]
    tMoms_m['iL',s,t]
  ;
  $GROUP+ G_exogenous_forecast G_taxes_exogenous_forecast$(tx1[t]);

  $GROUP G_taxes_forecast_as_zero 
    # Her inkluderes hjælpevariable til kalibrering, som ikke ellers er en del af modellen
    vtMoms_k[i_,r_,s_,t]$(k[i_]) "Generelle afgiftsprovenu (oms/moms) fordelt på kapitaltype og branche til at foretage investeringingen og input-brancher, Kilde: ADAM[Spg_<k><r>]"
    vtNetAfg_k[i_,r_,s_,t]$(k[i_]) "Provenu af punktafgifter fordelt på kapitaltype og branche til at foretage investeringingen og input-brancher inkl. subsidier, Kilde: ADAM[Spp_<k><r>]"
  ;
  $GROUP+ G_forecast_as_zero G_taxes_forecast_as_zero$(tx1[t]);

  $GROUP G_taxes_ARIMA_forecast 
    tMoms_y[d,s,t]$(not di[d])
    tMoms_m[d,s,t]$(not di[d])
    tMoms_y_k[i_,r,s,t]$(k[i_]) "Momssats fordelt på kapitaltype, branche til at foretage investeringingen og input fra indenlandske brancher."
    tMoms_m_k[i_,r,s,t]$(k[i_]) "Momssats fordelt på kapitaltype, branche til at foretage investeringingen og input fra indenlandske brancher."
  ;
  $GROUP+ G_ARIMA_forecast G_taxes_ARIMA_forecast;

  $GROUP G_taxes_newdata_fixed_forecast
    rSubLoen[s_,t]$(s[s_])
    tVirkVaegt[s_,t] "Implicit sats for vægtafgift."
    tGrund[s,t] "Implicit sats for ejendomsskatter"
    tVirkAM[s_,t]$(s[s_])
    tAUB[s_,t]$(s[s_])
    tE[s_,t]$(s[s_]) "Energiafgiftssats - grøn afgift og bortauktionering af CO2 kvoter"

    tAfg_y[d,s,t]$(not di[d])
    tAfg_m[d,s,t]$(not di[d])
    rSub_y[d,s,t]$(not di[d])
    rSub_m[d,s,t]$(not di[d])
    tTold[d,s,t]$(not sameas['iL',d]) 
    tReg_y[d_,s,t]$(d[d_]) "Registreringsafgiftssats for biler."
    tReg_m[d_,s,t]$(d[d_]) "Registreringsafgiftssats for biler."
    tAfg_y_k[i_,r_,s_,t]$(k[i_] and d1IOy[i_,s_,t] and d1I_s[i_,r_,t]) "Punktafgiftssats ekskl. subsidier og registreringsafgift fra indenlandske brancher fordelt på kapitaltype og branche til at foretage investeringingen"
    tAfg_m_k[i_,r_,s_,t]$(k[i_] and d1IOm[i_,s_,t] and d1I_s[i_,r_,t]) "Punktafgiftssats ekskl. subsidier og registreringsafgift fra import-grupper fordelt på kapitaltype og branche til at foretage investeringingen"
    rSub_y_k[i_,r_,s_,t]$(k[i_] and d1IOy[i_,s_,t] and d1I_s[i_,r_,t]) "Sats for produktsubsidier fra indenlandske brancher fordelt på kapitaltype og branche til at foretage investeringingen."
    rSub_m_k[i_,r_,s_,t]$(k[i_] and d1IOm[i_,s_,t] and d1I_s[i_,r_,t]) "Sats for produktsubsidier fra import-grupper fordelt på kapitaltype og branche til at foretage investeringingen."

    tYRest[s,t]
  ;

  $GROUP+ G_newdata_forecast G_taxes_newdata_fixed_forecast;

$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_taxes G_taxes_endo $(tx0[t])
    # Samlet provenue for told, netto-afgifter og moms
    $(d1IOy[d,s,t])..
      vtIOy[d,s,t] =E= vtNetAfg_y[d,s,t] + vtMoms_y[d,s,t] + vtReg_y[d,s,t];

    $(d1IOm[d,s,t])..
      vtIOm[d,s,t] =E= vtNetAfg_m[d,s,t] + vtMoms_m[d,s,t] + vtReg_m[d,s,t] + vtTold[d,s,t];

    # Samlet sats for told, netto-afgifter og moms
    $(d1IOy[d,s,t])..
      tIOy[d,s,t] * (vIOy[d,s,t] - vtIOy[d,s,t]) =E= vtIOy[d,s,t];

    $(d1IOm[d,s,t])..
      tIOm[d,s,t] * (vIOm[d,s,t] - vtIOm[d,s,t]) =E= vtIOm[d,s,t];

    # Nettoprovenu fra punktafgifter, produktsubsidier og registreringsafgifter   
    .. vtNetAfg[d,s,t] =E= vtNetAfg_y[d,s,t] + vtNetAfg_m[d,s,t];

    $(d1IOy[d,s,t])..
      vtNetAfg_y[d,s,t] =E= vtAfg_y[d,s,t] - vSub_y[d,s,t];

    $(d1IOm[d,s,t])..
      vtNetAfg_m[d,s,t] =E= vtAfg_m[d,s,t] - vSub_m[d,s,t];

    # Provenu fra told
    $(d1IOm[d,s,t]).. 
      vtTold[d,s,t] =E= tTold[d,s,t] * (vIOm[d,s,t] - vtIOm[d,s,t]);

    # Provenu fra punktafgifter 
    .. vtAfg[d,s,t] =E= vtAfg_y[d,s,t] + vtAfg_m[d,s,t];

    $(d1IOy[d,s,t] and not dk[d])..
      vtAfg_y[d,s,t] =E= tAfg_y[d,s,t] * pnCPI[cTot,t-1]/fp * qIOy[d,s,t];
    tAfg_y[dk,s,t]$(d1IOy[dk,s,t])..
      vtAfg_y[dk,s,t] =E= tAfg_y[dk,s,t] * pnCPI[cTot,t-1]/fp * qIOy[dk,s,t];
    $(d1IOy[i_,s,t] and (sameas['iB',i_] or sameas['iM',i_]))..
      vtAfg_y[i_,s,t] =E= sum(r$d1I_s[i_,r,t], vtAfg_y_k[i_,r,s,t]);
    $(d1IOy[i_,s,t] and (sameas['iB',i_] or sameas['iM',i_]))..
      vtAfg_y_k[i_,r,s,t] =E= tAfg_y_k[i_,r,s,t] * pnCPI[cTot,t-1]/fp * rpI[i_,sTot,t] * qI_s[i_,r,t];

    $(d1IOm[d,s,t] and not dk[d])..
      vtAfg_m[d,s,t] =E= tAfg_m[d,s,t] * (1 + tTold[d,s,t]) * pnCPI[cTot,t-1]/fp * qIOm[d,s,t];
    tAfg_m[dk,s,t]$(d1IOm[dk,s,t])..
      vtAfg_m[dk,s,t] =E= tAfg_m[dk,s,t] * (1 + tTold[dk,s,t]) * pnCPI[cTot,t-1]/fp * qIOm[dk,s,t];
    $(d1IOm[i_,s,t] and (sameas['iB',i_] or sameas['iM',i_]))..
      vtAfg_m[i_,s,t] =E= sum(r$d1I_s[i_,r,t], vtAfg_m_k[i_,r,s,t]);
    $(d1IOm[i_,s,t] and (sameas['iB',i_] or sameas['iM',i_]))..
      vtAfg_m_k[i_,r,s,t] =E= tAfg_m_k[i_,r,s,t] * (1 + tTold[i_,s,t]) 
                                                 * pnCPI[cTot,t-1]/fp * rpI[i_,sTot,t] * qI_s[i_,r,t];

    # Udgifter til produktsubsidier
    .. vSub[d,s,t] =E= vSub_y[d,s,t] + vSub_m[d,s,t];

    $(d1IOy[d,s,t] and not dk[d])..
      vSub_y[d,s,t] =E= rSub_y[d,s,t] * pnCPI[cTot,t-1]/fp * qIOy[d,s,t];
    rSub_y[dk,s,t]$(d1IOy[dk,s,t])..
      vSub_y[dk,s,t] =E= rSub_y[dk,s,t] * pnCPI[cTot,t-1]/fp * qIOy[dk,s,t];
    $(d1IOy[i_,s,t] and (sameas['iB',i_] or sameas['iM',i_]))..
      vSub_y[i_,s,t] =E= sum(r$d1I_s[i_,r,t], vSub_y_k[i_,r,s,t]);
    $(d1IOy[i_,s,t] and (sameas['iB',i_] or sameas['iM',i_]))..
      vSub_y_k[i_,r,s,t] =E= rSub_y_k[i_,r,s,t] * pnCPI[cTot,t-1]/fp * rpI[i_,sTot,t] * qI_s[i_,r,t];

    $(d1IOm[d,s,t] and not dk[d])..
      vSub_m[d,s,t] =E= rSub_m[d,s,t] * (1 + tTold[d,s,t]) * pnCPI[cTot,t-1]/fp * qIOm[d,s,t];
    rSub_m[dk,s,t]$(d1IOm[dk,s,t])..
      vSub_m[dk,s,t] =E= rSub_m[dk,s,t] * (1 + tTold[dk,s,t]) * pnCPI[cTot,t-1]/fp * qIOm[dk,s,t];
    $(d1IOm[i_,s,t] and (sameas['iB',i_] or sameas['iM',i_]))..
      vSub_m[i_,s,t] =E= sum(r$d1I_s[i_,r,t], vSub_m_k[i_,r,s,t]);
    $(d1IOm[i_,s,t] and (sameas['iB',i_] or sameas['iM',i_]))..
      vSub_m_k[i_,r,s,t] =E= rSub_m_k[i_,r,s,t] * (1 + tTold[i_,s,t]) 
                                                * pnCPI[cTot,t-1]/fp * rpI[i_,sTot,t] * qI_s[i_,r,t];

    # Provenu fra moms  
    .. vtMoms[d,s,t] =E= vtMoms_y[d,s,t] + vtMoms_m[d,s,t];

    $(d1IOy[d,s,t] and not dk[d])..
      vtMoms_y[d,s,t] =E= tMoms_y[d,s,t] * (vIOy[d,s,t] - vtIOy[d,s,t] + vtNetAfg_y[d,s,t]);
    tMoms_y[dk,s,t]$(d1IOy[dk,s,t])..
      vtMoms_y[dk,s,t] =E= tMoms_y[dk,s,t] * (vIOy[dk,s,t] - vtIOy[dk,s,t] + vtNetAfg_y[dk,s,t]);
    $(d1IOy[i_,s,t] and (sameas['iB',i_] or sameas['iM',i_]))..
      vtMoms_y[i_,s,t] =E= sum(r$d1I_s[i_,r,t], vtMoms_y_k[i_,r,s,t]);
    $(d1IOy[i_,s,t] and (sameas['iB',i_] or sameas['iM',i_]))..
      vtMoms_y_k[i_,r,s,t] =E= tMoms_y_k[i_,r,s,t] * (pnCPI[cTot,t-1]/fp * rpI[i_,sTot,t] * qI_s[i_,r,t] 
                                                      + vtAfg_y_k[i_,r,s,t] - vSub_y_k[i_,r,s,t]);

    $(d1IOm[d,s,t] and not dk[d])..
      vtMoms_m[d,s,t] =E= tMoms_m[d,s,t] * (vIOm[d,s,t] - vtIOm[d,s,t] + vtNetAfg_m[d,s,t] + vtTold[d,s,t]);
    tMoms_m[dk,s,t]$(d1IOm[dk,s,t])..
      vtMoms_m[dk,s,t] =E= tMoms_m[dk,s,t] * (vIOm[dk,s,t] - vtIOm[dk,s,t] + vtNetAfg_m[dk,s,t] + vtTold[dk,s,t]);
    $(d1IOm[i_,s,t] and (sameas['iB',i_] or sameas['iM',i_]))..
      vtMoms_m[i_,s,t] =E= sum(r$d1I_s[i_,r,t], vtMoms_m_k[i_,r,s,t]);
    $(d1IOm[i_,s,t] and (sameas['iB',i_] or sameas['iM',i_]))..
      vtMoms_m_k[i_,r,s,t] =E= tMoms_m_k[i_,r,s,t] * ((1 + tTold[i_,s,t]) 
                                                      * pnCPI[cTot,t-1]/fp * rpI[i_,sTot,t] * qI_s[i_,r,t] 
                                                      + vtAfg_m_k[i_,r,s,t] - vSub_m_k[i_,r,s,t]);

    # Provenu fra registreringsafgifter
    .. vtReg[d,s,t] =E= vtReg_y[d,s,t] + vtReg_m[d,s,t];

    $(d1IOy[d,s,t])..
      vtReg_y[d,s,t] =E= tReg_y[d,s,t] * (vIOy[d,s,t] - vtIOy[d,s,t] + vtNetAfg_y[d,s,t] + vtMoms_y[d,s,t]);

    $(d1IOm[d,s,t])..
      vtReg_m[d,s,t] =E= tReg_m[d,s,t] * (vIOm[d,s,t] - vtIOm[d,s,t] + vtNetAfg_m[d,s,t] 
                                                      + vtMoms_m[d,s,t] + vtTold[d,s,t]);

      # PRODUCTION TAXES - brancheniveau
    vtGrund&_notbol[s,t]$(d1K['iB',s,t] and not bol[s])..
      vtGrund[s,t] =E= tGrund[s,t] * pI_s['iB',s,t-1]/fp * qK['iB',s,t-1]/fq;
    $(bol[s] and t.val > %cal_start%).. vtGrund[s,t] =E= tGrund[s,t] * (1 + rKLeje2Bolig[aTot,t]) * vLand[t-1]/fv;

    $(d1K['iM',s,t]).. vtVirkVaegt[s,t] =E= tVirkVaegt[s,t] * pnCPI[cTot,t-1]/fp * qK['iM',s,t-1]/fq;
    
    $(d1K['iB',s,t]).. tK['iB',s,t] * pI_s['iB',s,t] * qK['iB',s,t-1]/fq =E= vtGrund[s,t];

    $(d1K['iM',s,t]).. tK['iM',s,t] * pI_s['iM',s,t] =E= tVirkVaegt[s,t] * pnCPI[cTot,t-1]/fp;

    .. vtVirkAM[s,t] =E= tVirkAM[s,t] * vLoensum[s,t];

    .. vtAUB[s,t] =E= tAUB[s,t] * vLoensum[s,t];

    $(t.val >= %BFR_t1%).. vSubLoen[s,t] =E= rSubLoen[s,t] * vLoenIndeks[t] * nSubLoen[t];   

    .. vtNetLoenAfg[s,t] =E= vtVirkAM[s,t] + vtAUB[s,t] - vSubLoen[s,t];

    # Grønne afgifter på landbrug forventes primært knyttet til udledninger, som ikke afhænger af energiforbrug. 
    # Landbruget særbehandles derfor.
    .. vtCO2[s,t] =E= tE[s,t] * (vE[s,t] + vY[s,t]$(lan[s]));

    .. vtNetYRest[s,t] =E= vtYRest[s,t] - vSubYRest[s,t]; 

    .. vtNetY[s,t] =E= vtGrund[s,t] + vtVirkVaegt[s,t] + vtCO2[s,t] + vtNetLoenAfg[s,t] + vtNetYRest[s,t];

    .. vtYRest[s,t] =E= tYRest[s,t] * vY[s,t];

    .. vtY[s,t] =E= vtGrund[s,t] + vtVirkVaegt[s,t] + vtCO2[s,t] + vtVirkAM[s,t] + vtAUB[s,t] + vtYRest[s,t];

    # PRODUCTION TAXES - aggregater
    tK['iM',sTot,t].. vtVirkVaegt[sTot,t] =E= tK['iM',sTot,t] * pnCPI[cTot,t-1]/fp * qK['iM',sTot,t-1]/fq;

    tK['iB',sTot,t].. vtGrund[sTot,t] =E= tK['iB',sTot,t] * pKI['iB',sTot,t] * qK['iB',sTot,t-1]/fq;

    tVirkAM[sTot,t].. vtVirkAM[sTot,t] =E= tVirkAM[sTot,t] * vLoensum[sTot,t];

    tAUB[sTot,t].. vtAUB[sTot,t] =E= tAUB[sTot,t] * vLoensum[sTot,t];

    rSubLoen[sTot,t]$(t.val >= %BFR_t1%).. vSubLoen[sTot,t] =E= rSubLoen[sTot,t] * vLoenIndeks[t] * nSubLoen[t];

    $(t.val >= %BFR_t1%)..
      nSubLoen[t] =E= nSoc['sbeskflex',t]
                    - nOvf['kontflex',t]
                    + nSoc['sbeskskaane',t]
                    + nSoc['sbeskrest',t]
                    + nSoc['sbeskjobtaktj',t]
                    + nSoc['sbeskjobtaktij',t];

    .. vtNetLoenAfg[sTot,t] =E= vtVirkAM[sTot,t] + vtAUB[sTot,t] - vSubLoen[sTot,t];

    .. vtCO2[sTot,t] =E= sum(s, vtCO2[s,t]);

    .. vtNetYRest[sTot,t] =E= vtYRest[sTot,t] - vSubYRest[sTot,t]; 

    tYRest[sTot,t].. vtYRest[sTot,t] =E= tYRest[sTot,t] * vY[sTot,t];

    .. vtNetY[sTot,t] =E= vtGrund[sTot,t] 
                        + vtVirkVaegt[sTot,t] 
                        + vtCO2[sTot,t] 
                        + vtNetLoenAfg[sTot,t] 
                        + vtNetYRest[sTot,t];

    .. vtY[sTot,t] =E= vtGrund[sTot,t] 
                     + vtVirkVaegt[sTot,t] 
                     + vtCO2[sTot,t] 
                     + vtVirkAM[sTot,t] 
                     + vtAUB[sTot,t] 
                     + vtYRest[sTot,t];

    .. vtGrund[sTot,t] =E= sum(s, vtGrund[s,t]);
    .. vtVirkVaegt[sTot,t] =E= sum(s, vtVirkVaegt[s,t]);
    .. vtVirkAM[sTot,t] =E= sum(s, vtVirkAM[s,t]);
    .. vtAUB[sTot,t] =E= sum(s, vtAUB[s,t]);
    $(t.val >= %BFR_t1%).. vSubLoen[sTot,t] =E= sum(s, vSubLoen[s,t]);
    .. vtYRest[sTot,t] =E= sum(s, vtYRest[s,t]);

    .. tK[k,spTot,t] * pKI[k,spTot,t] * qK[k,spTot,t-1]/fq =E= sum(sp, tK[k,sp,t] * pI_s[k,sp,t] * qK[k,sp,t-1]/fq);

    ..  tE[spTot,t] * vE[spTot,t] =E= vtCO2[spTot,t] - tE[lan,t] * vY[lan,t];

    # Samlet provenue fra efterspørgselssiden for given branche på udbudssiden
    .. vtAfg[dTot,s,t] =E= sum(d, vtAfg[d,s,t]);

    # Samlet udgift fra efterspørgselssiden for given branche på udbudssiden
    .. vSub[dTot,s,t] =E= sum(d, vSub[d,s,t]);

    # ----------------------------------------------------------------------------------------------------------------------
    # Branche-totaler
    # ----------------------------------------------------------------------------------------------------------------------
    .. vtTold[d,sTot,t] =E= sum(s, vtTold[d,s,t]);
    .. vtAfg[d,sTot,t] =E= sum(s, vtAfg[d,s,t]);
    .. vSub[d,sTot,t] =E= sum(s, vSub[d,s,t]);
    .. vtNetAfg[d,sTot,t] =E= sum(s, vtNetAfg[d,s,t]);
    .. vtMoms[d,sTot,t] =E= sum(s, vtMoms[d,s,t]);
    .. vtReg[d,sTot,t] =E= sum(s, vtReg[d,s,t]);

    .. vtNetYRest[spTot,t] =E= vtNetYRest[sTot,t] - vtNetYRest['off',t]; 

    .. vtGrund[spTot,t] =E= sum(sp, vtGrund[sp,t]);
    .. vtVirkVaegt[spTot,t] =E= sum(sp, vtVirkVaegt[sp,t]);
    .. vtVirkAM[spTot,t] =E= sum(sp, vtVirkAM[sp,t]);
    .. vtAUB[spTot,t] =E= sum(sp, vtAUB[sp,t]);
    .. vtCO2[spTot,t] =E= sum(sp, vtCO2[sp,t]);
    $(t.val >= %BFR_t1%).. vSubLoen[spTot,t] =E= sum(sp, vSubLoen[sp,t]);
    .. vtNetLoenAfg[spTot,t] =E= sum(sp, vtNetLoenAfg[sp,t]);
    .. vtNetY[spTot,t] =E= sum(sp, vtNetY[sp,t]);

    # # ----------------------------------------------------------------------------------------------------------------------
    # # Efterspørgsels-totaler
    # # ----------------------------------------------------------------------------------------------------------------------
    .. vtMoms["cTot",sTot,t] =E= sum(c, vtMoms[c,sTot,t]);
    .. vtMoms["gTot",sTot,t] =E= sum(g, vtMoms[g,sTot,t]);
    .. vtMoms["xTot",sTot,t] =E= sum(x, vtMoms[x,sTot,t]);
    .. vtMoms["tot",sTot,t] =E= sum(r, vtMoms[r,sTot,t]);
    .. vtMoms["iTot",sTot,t] =E= sum(i, vtMoms[i,sTot,t]);
    .. vtMoms[dTot,sTot,t] =E= vtMoms[cTot,sTot,t]
                             + vtMoms[gTot,sTot,t]
                             + vtMoms[xTot,sTot,t]
                             + vtMoms[iTot,sTot,t]
                             + vtMoms[rtot,sTot,t];

    .. vtNetAfg["cTot",sTot,t] =E= sum(c, vtNetAfg[c,sTot,t]);
    .. vtNetAfg["gTot",sTot,t] =E= sum(g, vtNetAfg[g,sTot,t]);
    .. vtNetAfg["xTot",sTot,t] =E= sum(x, vtNetAfg[x,sTot,t]);   
    .. vtNetAfg["tot",sTot,t] =E= sum(r, vtNetAfg[r,sTot,t]);
    .. vtNetAfg["iTot",sTot,t] =E= sum(i, vtNetAfg[i,sTot,t]);
    .. vtNetAfg[dTot,sTot,t] =E= vtNetAfg[cTot,sTot,t]
                               + vtNetAfg[gTot,sTot,t]
                               + vtNetAfg[xTot,sTot,t]
                               + vtNetAfg[iTot,sTot,t]
                               + vtNetAfg[rtot,sTot,t];

    .. vtAfg["cTot",sTot,t] =E= sum(c, vtAfg[c,sTot,t]);
    .. vtAfg["gTot",sTot,t] =E= sum(g, vtAfg[g,sTot,t]);
    .. vtAfg["xTot",sTot,t] =E= sum(x, vtAfg[x,sTot,t]);
    .. vtAfg["tot",sTot,t] =E= sum(r, vtAfg[r,sTot,t]);
    .. vtAfg["iTot",sTot,t] =E= sum(i, vtAfg[i,sTot,t]);
    .. vtAfg[dTot,sTot,t] =E= vtAfg[cTot,sTot,t]
                            + vtAfg[gTot,sTot,t]
                            + vtAfg[xTot,sTot,t]
                            + vtAfg[iTot,sTot,t]
                            + vtAfg[rTot,sTot,t];
    .. vSub["cTot",sTot,t] =E= sum(c, vSub[c,sTot,t]);
    .. vSub["gTot",sTot,t] =E= sum(g, vSub[g,sTot,t]);
    .. vSub["xTot",sTot,t] =E= sum(x, vSub[x,sTot,t]);
    .. vSub["tot",sTot,t] =E= sum(r, vSub[r,sTot,t]);
    .. vSub["iTot",sTot,t] =E= sum(i, vSub[i,sTot,t]);
    .. vSub[dTot,sTot,t] =E= vSub[cTot,sTot,t]
                           + vSub[gTot,sTot,t]
                           + vSub[xTot,sTot,t]
                           + vSub[iTot,sTot,t]
                           + vSub[rTot,sTot,t];

    .. vtReg["cTot",sTot,t] =E= sum(c, vtReg[c,sTot,t]);
    .. vtReg["gTot",sTot,t] =E= sum(g, vtReg[g,sTot,t]);
    .. vtReg["xTot",sTot,t] =E= sum(x, vtReg[x,sTot,t]);
    .. vtReg["tot",sTot,t] =E= sum(r, vtReg[r,sTot,t]);
    .. vtReg["iTot",sTot,t] =E= sum(i, vtReg[i,sTot,t]);
    .. vtReg[dTot,sTot,t] =E= vtReg[cTot,sTot,t]
                            + vtReg[gTot,sTot,t]
                            + vtReg[xTot,sTot,t]
                            + vtReg[iTot,sTot,t]
                            + vtReg[rtot,sTot,t];

    .. vtTold["tot",sTot,t] =E= sum(r, vtTold[r,sTot,t]);
    .. vtTold["iTot",sTot,t] =E= sum(i, vtTold[i,sTot,t]);
    .. vtTold["gTot",sTot,t] =E= sum(g, vtTold[g,sTot,t]);
    .. vtTold["cTot",sTot,t] =E= sum(c, vtTold[c,sTot,t]);
    .. vtTold["xTot",sTot,t] =E= sum(x, vtTold[x,sTot,t]);
    .. vtTold[dTot,sTot,t] =E= vtTold[cTot,sTot,t]
                             + vtTold[gTot,sTot,t]
                             + vtTold[rtot,sTot,t]
                             + vtTold[iTot,sTot,t]
                             + vtTold[xTot,sTot,t];

    # ----------------------------------------------------------------------------------------------------------------------
    # Implicitte skattesatser for aggregater
    # ----------------------------------------------------------------------------------------------------------------------
    # Ingen moms på eksport - så ingen implicitte momssatser for disse - derfor benyttes dux
    ..
      tMoms[dux,t] =E= vtMoms[dux,sTot,t] / sum(s, vIO[dux,s,t] - (vtIOy[dux,s,t] + vtIOm[dux,s,t])
                                                   + vtNetAfg_y[dux,s,t] + vtNetAfg_m[dux,s,t] + vtTold[dux,s,t]);

  $ENDBLOCK

  model M_base / B_taxes /;
  $GROUP+ G_Endo G_taxes_endo;
  model M_static / B_taxes /;
  $GROUP+ G_static G_taxes_endo;
$ENDIF

$IF %stage% == "exogenous_values":
# ======================================================================================================================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_taxes_makrobk
    vtReg, vSub[dTot,sTot,t], vSub[dTot,ene,t], vtAfg[dTot,sTot,t], vtAfg[dTot,ene,t]
    vtNetAfg_y, vtNetAfg_m, vtAfg_y, vtAfg_m, vSub_y, vSub_m, 
    vtReg_y, vtReg_m
    vtTold, vtMoms_y, vtMoms_m, 
    tVirkAM$(s[s_]), tAUB$(s[s_]), vtNetY$(s[s_] or sTot[s_]), vtNetYRest$(s[s_] or sTot[s_]),
    vtY$(sTot[s_]), vtYRest
    vtGrund$(s[s_] or sTot[s_]), vtVirkVaegt$(s[s_] or sTot[s_]), 
    vtAUB$(s[s_] or sTot[s_]), vtCO2$(s[s_] or sTot[s_])
    vtVirkAM$(s[s_] or sTot[s_]), vSubLoen$(s[s_] or sTot[s_]), vtNetLoenAfg$(s[s_] or sTot[s_])
    # Der beregnes ikke en samlet total for energi og ikke-energi i data
    vtMoms$(not sameas[d_,'tot']), vtNetAfg$(not sameas[d_,'tot']) 
    vtNetAfg_k, vtMoms_k
    vtAfg_y_k, vtAfg_m_k, vSub_y_k, vSub_m_k, vtMoms_y_k, vtMoms_m_k
  ;
  @load(G_taxes_makrobk, "../Data/Makrobk/makrobk.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_taxes_data  
    G_taxes_makrobk
  ;

  $GROUP G_taxes_data_imprecise
    vtNetYRest$(s[s_] or sTot[s_])
    vtY$(sTot[s_]), vtYRest, vtNetY$(s[s_] or sTot[s_]), vtTold$(sameas[d_,'tot'] or dTot[d_]), vtMoms$(dTot[d_])
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

    tTold[d_,s,t]$(d1IOm[d_,s,t]), -vtTold[d_,s,t]$(d1IOm[d_,s,t])

    tAfg_y[d_,s,t]$(d1IOy[d_,s,t] and not (sameas['iB',d_] or sameas['iM',d_]))
    -vtAfg_y[d_,s,t]$(d1IOy[d_,s,t] and not (sameas['iB',d_] or sameas['iM',d_]))

    tAfg_m[d_,s,t]$(d1IOm[d_,s,t] and not (sameas['iB',d_] or sameas['iM',d_]))
    -vtAfg_m[d_,s,t]$(d1IOm[d_,s,t] and not (sameas['iB',d_] or sameas['iM',d_]))

    rSub_y[d_,s,t]$(d1IOy[d_,s,t] and not (sameas['iB',d_] or sameas['iM',d_]))
    -vSub_y[d_,s,t]$(d1IOy[d_,s,t] and not (sameas['iB',d_] or sameas['iM',d_]))

    rSub_m[d_,s,t]$(d1IOm[d_,s,t] and not (sameas['iB',d_] or sameas['iM',d_]))
    -vSub_m[d_,s,t]$(d1IOm[d_,s,t] and not (sameas['iB',d_] or sameas['iM',d_]))

    tMoms_y[d_,s,t]$(d1IOy[d_,s,t] and not (sameas['iB',d_] or sameas['iM',d_]))
    -vtMoms_y[d_,s,t]$(d1IOy[d_,s,t] and not (sameas['iB',d_] or sameas['iM',d_]))

    tMoms_m[d_,s,t]$(d1IOm[d_,s,t] and not (sameas['iB',d_] or sameas['iM',d_]))
    -vtMoms_m[d_,s,t]$(d1IOm[d_,s,t] and not (sameas['iB',d_] or sameas['iM',d_]))

    tReg_y[d_,s,t]$(d1IOy[d_,s,t]), -vtReg_y[d_,s,t]$(d1IOy[d_,s,t])
    tReg_m[d_,s,t]$(d1IOm[d_,s,t]), -vtReg_m[d_,s,t]$(d1IOm[d_,s,t])

    tAfg_y_k[k,r,s,t]$(d1IOy[k,s,t] and not (sameas['bol',r] and sameas['iM',k]))
    -vtAfg_y_k[k,r,s,t]$(d1IOy[k,s,t] and not (sameas['bol',r] and sameas['iM',k]))

    tAfg_m_k[k,r,s,t]$(d1IOm[k,s,t] and not (sameas['bol',r] and sameas['iM',k]))
    -vtAfg_m_k[k,r,s,t]$(d1IOm[k,s,t] and not (sameas['bol',r] and sameas['iM',k]))

    rSub_y_k[k,r,s,t]$(d1IOy[k,s,t] and not (sameas['bol',r] and sameas['iM',k]))
    -vSub_y_k[k,r,s,t]$(d1IOy[k,s,t] and not (sameas['bol',r] and sameas['iM',k]))

    rSub_m_k[k,r,s,t]$(d1IOm[k,s,t] and not (sameas['bol',r] and sameas['iM',k]))
    -vSub_m_k[k,r,s,t]$(d1IOm[k,s,t] and not (sameas['bol',r] and sameas['iM',k]))

    tMoms_y_k[k,r,s,t]$(d1IOy[k,s,t] and not (sameas['bol',r] and sameas['iM',k]))
    -vtMoms_y_k[k,r,s,t]$(d1IOy[k,s,t] and not (sameas['bol',r] and sameas['iM',k]))

    tMoms_m_k[k,r,s,t]$(d1IOm[k,s,t] and not (sameas['bol',r] and sameas['iM',k]))
    -vtMoms_m_k[k,r,s,t]$(d1IOm[k,s,t] and not (sameas['bol',r] and sameas['iM',k]))

    tE[s,t], -vtCO2[s,t]
    tYRest[s,t], -vtYRest[s,t]
    tGrund[s,t]$(not (bol[s] and t.val = %cal_start%)), -vtGrund[s,t]$(not (bol[s] and t.val = %cal_start%))
    tVirkVaegt[s,t], -vtVirkVaegt[s,t]
    rSubLoen[s,t], -vSubLoen[s,t]
  ;
  $GROUP G_taxes_static_calibration G_taxes_static_calibration$(tx0[t]);

#  $BLOCK B_taxes_static_calibration$(tx0[t])
#  $ENDBLOCK
  MODEL M_taxes_static_calibration /
    B_taxes
    # B_taxes_static_calibration
  /;
  model M_static_calibration / M_taxes_static_calibration /;
  $GROUP+ G_static_calibration G_taxes_static_calibration;

  $GROUP G_taxes_static_calibration_newdata
    G_taxes_static_calibration
   ;
  $GROUP+ G_static_calibration_newdata G_taxes_static_calibration_newdata;
$ENDIF

# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  model M_deep_dynamic_calibration / B_taxes /;
  $GROUP+ G_deep_dynamic_calibration G_taxes_endo;
$ENDIF

# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
  model M_dynamic_calibration_newdata / B_taxes /;
  $GROUP+ G_dynamic_calibration_newdata G_taxes_endo;
$ENDIF