# ======================================================================================================================
# Aggregates
# - This module calculates objects with ties to many other modules
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_aggregates_prices_endo empty_group_dummy[t];
  $GROUP G_aggregates_quantities_endo empty_group_dummy[t];
  $GROUP G_aggregates_values_endo
    vVirkBVT5aarSnit[t] "Centreret 5-års glidende gennemsnit af privat BVT."
    vBVT2hL[t] "BVT pr. arbejdstime i værdi."
    vBVT2hLsnit[t] "Glidende gennemsnit af BVT pr. arbejdstime i værdi."
    qBVT2hL[t] "BVT pr. arbejdstime i mængde."
    qBVT2hLsnit[t] "Glidende gennemsnit af BVT pr. arbejdstime i mængde."
    vBFI[t] "Bruttonationalindkomst, Kilde: ADAM[Yi]"
    vUdl[portf_,t]$(t.val >= 1994 and not (BankGaeld[portf_] or Guld[portf_] or pensTot[portf_] or pens[portf_])) "Udlandets finansielle portefølje, Kilde: jf. portfolio set."
    vUdlRenter[t]$(t.val >= 1994) "Udlandets nettoformueindkomst, Kilde: ADAM[Tin_e]"
    vUdlOmv[t]$(t.val >= 1994) "Omvurderinger af udenlandsk nettoformue, Kilde: ADAM[Wn_e]-ADAM[Wn_e][-1]-ADAM[Tfn_e]"
    vUdlNFE[t]$(t.val >= 1994) "Udlandets nettofordringserhvervelse, Kilde: ADAM[Tfn_e]"
  ;
  $GROUP G_aggregates_endo
    G_aggregates_values_endo
    rArbProd[t] "Timeproduktivitet."
    rBVTGab[t] "Outputgab."
    rBeskGab[t] "Strukturelt beskæftigelsesgab"    
    pCInflSnit[t] "Glidende gennemsnit af forbrugerprisstigninger ekskl. bolig."
  ;
  $GROUP G_aggregates_endo G_aggregates_endo$(tx0[t]); # Restrict endo group to tx0[t]

  $GROUP G_aggregates_prices_exo 
    empty_group_dummy[t]
  ;

  $GROUP G_aggregates_quantities_exo 
    empty_group_dummy[t]
  ;

  $GROUP G_aggregates_values_exo 
    vUdl$(BankGaeld[portf_] or Guld[portf_] or pensTot[portf_] or pens[portf_])
  ;

  $GROUP G_aggregates_prices
    G_aggregates_prices_endo
    G_aggregates_prices_exo
  ;

  $GROUP G_aggregates_quantities
    G_aggregates_quantities_endo
    G_aggregates_quantities_exo
  ;

  $GROUP G_aggregates_values
    G_aggregates_values_endo
    G_aggregates_values_exo
  ;





  $GROUP G_aggregates_forecast_as_zero
    # Forecast_as_zero
    jvBFI[t] "J-led."
  ;


  $GROUP G_aggregates_other
    rUdlRealkred[t] "Andel af udlandets realkredit i forhold til husholdnings samlet realkredit."
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_aggregates
    E_vVirkBVT5aarSnit[t]$(tx0[t] and t.val < tEnd.val-1)..
      vVirkBVT5aarSnit[t] =E= sum(sp, vBVT[sp,t-2]/fv/fv + vBVT[sp,t-1]/fv + vBVT[sp,t] + vBVT[sp,t+1]*fv + vBVT[sp,t+2]*fv*fv) / 5;
    E_vVirkBVT5aarSnit_t1End[t]$(tx0[t] and t.val = tEnd.val-1)..
      vVirkBVT5aarSnit[t] =E= sum(sp, vBVT[sp,t-2]/fv/fv + vBVT[sp,t-1]/fv + vBVT[sp,t] + vBVT[sp,t+1]*fv + vBVT[sp,t+1]*fv*fv) / 5;
    E_vVirkBVT5aarSnit_tEnd[t]$(tEnd[t])..
      vVirkBVT5aarSnit[t] =E= sum(sp, vBVT[sp,t-2]/fv/fv + vBVT[sp,t-1]/fv + vBVT[sp,t] + vBVT[sp,t]*fv   + vBVT[sp,t]*fv*fv) / 5;

    E_vBVT2hL[t]$(tx0[t]).. vBVT2hL[t] =E= vBVT[sTot,t] / hL[sTot,t];

    E_vBVT2hLsnit[t]$(tx0[t])..
      vBVT2hLsnit[t] =E= vBVT2hLsnit[t-1] * 0.8 + 0.2 * vBVT2hL[t];

    E_qBVT2hL[t]$(tx0[t]).. qBVT2hL[t] =E= qBVT[sTot,t] / hL[sTot,t];

    E_qBVT2hLsnit[t]$(tx0[t])..
      qBVT2hLsnit[t] =E= qBVT2hLsnit[t-1] * 0.8 + 0.2 * qBVT2hL[t];

    E_pCsnit[t]$(tx0[t])..
      pCInflSnit[t] =E= 0.8 * pCInflSnit[t-1] + 0.2 * (pC['cIkkeBol',t] / (pC['cIkkeBol',t-1]/fp) -1);

    E_vBFI[t]$(tx0[t])..
      vBFI[t] =E= vBNP[t]                               
                - vtEU[t] + vSubEU[t]  # Told og subsidier til og fra EU 
                - vWxDK[t]  # Lønninger til grænsearbejdere
                - vUdlRenter[t]  # Udenlandsk formueindkomst
                + jvBFI[t];

    # Udlandets portefølje er residualt givet
    E_vUdl_IndlAktier[t]$(tx0[t] and t.val >= 1994)..
      vUdl['IndlAktier',t] =E= vAktie[t] - vHh['IndlAktier',aTot,t] - vOff['IndlAktier',t] - vVirk['IndlAktier',t] - vPension['IndlAktier',t];
         
    E_vUdl_UdlAktier[t]$(tx0[t] and t.val >= 1994)..
      vUdl['UdlAktier',t] =E= - vHh['UdlAktier',aTot,t] - vOff['UdlAktier',t] - vVirk['UdlAktier',t] - vPension['UdlAktier',t];

    E_vUdl_Bank[t]$(tx0[t] and t.val >= 1994)..
      vUdl['Bank',t] =E= vHh['BankGaeld',aTot,t] - vHh['Bank',aTot,t] - vOff['Bank',t] - vVirk['Bank',t];

    E_vUdl_Obl[t]$(tx0[t] and t.val >= 1994)..
      vUdl['Obl',t] =E= vHh['RealKred',aTot,t] + vOff['RealKred',t] + vVirk['RealKred',t] + vUdl['RealKred',t]
                        - (vHh['Obl',aTot,t] + vOff['Obl',t] + vVirk['Obl',t] + vPension['Obl',t]);

    E_vUdl_NetFin[t]$(tx0[t] and t.val >= 1994)..
      vUdl['NetFin',t] =E= sum(akt, vUdl[akt,t]) - vUdl['RealKred',t];
    # Skal være lig vAktie[t] + vVirk['Guld',t] - vHh['NetFin',aTot,t] - vOff['NetFin',t] - vVirk['NetFin',t];

    E_vUdl_realkred[t]$(tx0[t] and t.val >= 1994).. vUdl['realkred',t] =E= rUdlRealkred[t] * vHh['realkred',aTot,t];

    E_vUdlRenter[t]$(tx0[t] and t.val >= 1994)..
      vUdlRenter[t] =E= sum(akt, rRente[akt,t] * vUdl[akt,t-1]/fv)
                      - rRente['Obl',t] * vUdl['RealKred',t-1]/fv
                      - vOffVirk[t] # Overskud fra off. virksomheder trækkes hverken fra HH eller virk.
                      - jvHhRenter[t] - jvVirkRenter[t] 
                      - sum(akt, jrHhRente[akt,t] * vHh[akt,atot,t-1]/fv) + sum(pas, jrHhRente[pas,t] * vHh[pas,atot,t-1]/fv)
                      - jrOffRenteInd[t] * vOffAkt[t-1]/fv
                      + jrOffRenteUd[t] * vOffPas[t-1]/fv
                      + rOffRenteInd[t] * vOffFonde[t-1]/fv  # Offentlig residual er ekskl. offentlige fonde
                      # Pensionssektoren kan have større afkast end gennemsnittet dette indgår indirekte i vHhRenter og direkte her
                      + sum(akt, rRente[akt,t] * vPension[akt,t-1]/fv);

    E_vUdlOmv[t]$(tx0[t] and t.val >= 1994)..
      vUdlOmv[t] =E= sum(akt, rOmv[akt,t] * vUdl[akt,t-1]/fv) 
                   - rOmv['RealKred',t] * vUdl['RealKred',t-1]/fv
                   - jvHhOmv[t] - jvVirkOmv[t] - jvOffOmv[t]
                   - sum(akt, jrHhOmv[akt,t] * vHh[akt,atot,t-1]/fv) + sum(pas, jrHhOmv[pas,t] * vHh[pas,atot,t-1]/fv)
                   + vVirk['Guld',t] - vVirk['Guld',t-1]/fv
                   # Pensionssektoren kan have større afkast end gennemsnittet dette indgår indirekte i vHhRenter og direkte her
                   + sum(akt, rOmv[akt,t] * vPension[akt,t-1]/fv);

    E_vUdlNFE[t]$(tx0[t] and t.val >= 1994).. vUdlNFE[t] =E= vUdl['NetFin',t] - vUdl['NetFin',t-1]/fv - vUdlOmv[t];

    E_rArbProd[t]$(tx0[t]).. rArbProd[t] =E= qBVT[sTot,t] / nL[sTot,t];

    # Key gaps between structural and actual levels
    E_rBVTGab[t]$(tx0[t]).. rBVTGab[t] =E= qBVT[sTot,t] / sqBVT[sTot,t] - 1;

    E_rBeskGab[t]$(tx0[t]).. rBeskGab[t] =E= nLHh[aTot,t] / snLHh[aTot,t] - 1;
  $ENDBLOCK
$ENDIF


$IF %stage% == "exogenous_values":
# ======================================================================================================================
# Data assignment
# - Assign data to variables. Complicated data work should be done where the data is read.
# ======================================================================================================================
  $GROUP G_aggregates_data  # Variable som er datadækket og ikke må ændres af kalibrering
    vBFI
  ;

  $GROUP G_aggregates_data_imprecise
    rBeskGab
    vUdlOmv$(t.val > 2009)
    vUdl$(t.val > 2009)
  ;

  $GROUP G_aggregates_data_load 
    G_aggregates_data, 
    G_aggregates_data_imprecise
    vUdlOmv
    vUdl
   ;
  @load(G_aggregates_data_load, "..\Data\makrobk\makrobk.gdx")

$ENDIF


# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_aggregates_static_calibration
    G_aggregates_endo
    -vBFI, jvBFI
    -vUdl$(RealKred[portf_]), rUdlRealkred$(t.val >= 1994)
   ;
  $GROUP G_aggregates_static_calibration G_aggregates_static_calibration$(tx0[t])
    vUdl$(t0[t] and NetFin[portf_]) # E_vUdl_NetFin_t0
    vBVT2hLsnit$(t0[t])
    qBVT2hLsnit$(t0[t])
  ;

  $BLOCK B_aggregates_static_calibration
     E_vUdl_NetFin_t0[t]$(t0[t]).. vUdl['NetFin',t] =E= sum(akt, vUdl[akt,t]) - vUdl['RealKred',t];
     E_vBVT2hLsnit_t0[t]$(t1[t]).. vBVT2hLsnit[t] =E= vBVT2hL[t];
     E_qBVT2hLsnit_t0[t]$(t1[t]).. qBVT2hLsnit[t] =E= qBVT2hL[t];
  $ENDBLOCK
  MODEL M_aggregates_static_calibration /
    B_aggregates
    B_aggregates_static_calibration
  /;
$ENDIF

# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_aggregates_deep    
    G_aggregates_endo
  ;
  $GROUP G_aggregates_deep G_aggregates_deep$(tx0[t]);

  MODEL M_aggregates_deep /B_aggregates/;
$ENDIF

# ======================================================================================================================
# Simple dynamic calibration
# ======================================================================================================================

$IF %stage% == "simple_dynamic_calibration":
# No changes so base-groups used in Simple_dynamic_calibration.gms
#  $GROUP G_aggregates_dynamic_calibration
#    G_aggregates_endo
#  ;
# No changes so base-model used in Simple_dynamic_calibration.gms
#  MODEL M_aggregates_dynamic_calibration / 
#    B_aggregates
#  /;
$ENDIF