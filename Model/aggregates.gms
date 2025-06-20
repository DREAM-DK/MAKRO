# ======================================================================================================================
# Aggregates
# - This module calculates objects with ties to many other modules
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_aggregates_endo
    qBVT2hL[s_,t]$(s[s_] or sTot[s_]) "BVT pr. arbejdstime i mængde."
    qBVT2hLsnit[t] "Glidende gennemsnit af BVT pr. arbejdstime i mængde."

    vVirkBVT5aarSnit[t] "Centreret 5-års glidende gennemsnit af privat BVT."
    vBVT2hL[s_,t]$(s[s_] or sTot[s_]) "BVT pr. arbejdstime i værdi."
    vBVT2hLsnit[t] "Glidende gennemsnit af BVT pr. arbejdstime i værdi."
    vBNI[t] "Bruttonationalindkomst, Kilde: ADAM[Yi]"
    vUdlNet[t]$(t.val >= %NettoFin_t1%) "Udlandets finansielle nettoportefølje ift. DK, Kilde: ADAM[Wn_e]."
    vUdlAkt[portf_,t]$(t.val >= %NettoFin_t1% and d1vUdlAkt[portf_,t] and not pensTot[portf_]) "Udlandets finansielle aktiver ift. DK, Kilde: jf. portfolio set."
    vUdlAkt[portf_,t]$(t.val > %NettoFin_t1% and d1vUdlAkt[portf_,t] and pensTot[portf_]) "Udlandets finansielle aktiver ift. DK, Kilde: jf. portfolio set."
    vUdlPas[portf_,t]$(t.val >= %NettoFin_t1% and d1vUdlPas[portf_,t]) "Udlandets finansielle passiver ift. DK, Kilde: jf. portfolio set."
    jvUdlNFE[t]$(t.val > %NettoFin_t1%) "J-led"
    vUdlNFE[t]$(t.val > %NettoFin_t1%) "Udlandets nettofordringserhvervelse, Kilde: ADAM[Tfn_e]"
    vBetalingsbalance[t]$(t.val > %NettoFin_t1%) "Saldo på den officelle betalingsbalances løbende poster. Kilde: ADAM[Enl]."

    vUdlPensUdb[t]$(t.val > %NettoFin_t1%) "Pensionsudbetalinger til udlandet, Kilde: ADAM[Typc_cf_e]"
    vUdlPensIndb[t]$(t.val > %NettoFin_t1%) "Pensionsindbetalinger fra udlandet, Kilde: ADAM[Tpc_e_z]"
    vtPALudl[t]$(t.val > %NettoFin_t1%) "PAL-skat betalt af udlændinge"
    vUdlPensAfk[t]$(t.val > %NettoFin_t1%) "Afkast fra pensionsformue EFTER SKAT for udlændinge."
    vPens[pens_,t]$(t.val >= %NettoFin_t1%) "Samlet pensionsformue fordelt på pensionstype"
    vPensIndb[pens_,t]$(t.val >= %NettoFin_t1%) "Pensionsindbetalinger samlet til både husholdninger og udland fordelt på ordning"
    vPensUdb[pens_,t]$(t.val >= %NettoFin_t1%) "Pensionsudbetalinger samlet til både husholdninger og udland fordelt på ordning"
    vPensAfk[pens_,t]$(t.val > %NettoFin_t1%) "Pensionsafkast samlet til både husholdninger og udland fordelt på ordning"
    vUdlNetRenter[t]$(t.val > %NettoFin_t1%) "Udlandets nettoformueindkomst ift. DK, Kilde: ADAM[Tin_e]"
    vUdlAktRenter[portf_,t]$(t.val > %NettoFin_t1% and d1vUdlAkt[portf_,t] and portf[portf_]) "Samlet formueindkomst fra aktiver for finansielle og ikke-finansielle selskaber"
    vUdlPasRenter[portf_,t]$(t.val > %NettoFin_t1% and d1vUdlPas[portf_,t] and portf[portf_]) "Samlet rente- og dividendeudskrivninger for finansielle og ikke-finansielle selskaber"

    vUdlOmv[t]$(t.val > %NettoFin_t1%) "Omvurderinger af udenlandsk nettoformue, Kilde: ADAM[Wn_e]-ADAM[Wn_e][-1]-ADAM[Tfn_e]"
    vUdlAktOmv[portf_,t]$(t.val > %NettoFin_t1% and d1vUdlAkt[portf_,t] and portf[portf_]) "Omvurderinger på selskabernes finansielle aktiver"
    vUdlPasOmv[portf_,t]$(t.val > %NettoFin_t1% and d1vUdlPas[portf_,t] and portf[portf_]) "Omvurderinger på selskabernes finansielle passiver"

    jrUdlAktRenter[portf_,t]$(t.val > %NettoFin_t1% and d1vUdlAkt[portf_,t] and portf[portf_]) "J-led som dækker forskel mellem selskabernes og den gennemsnitlige rente på aktivet/passivet."
    jrUdlPasRenter[portf_,t]$(t.val > %NettoFin_t1% and d1vUdlPas[portf_,t] and not d1vUdlAkt[portf_,t] and portf[portf_]) "J-led som dækker forskel mellem selskabernes og den gennemsnitlige rente på aktivet/passivet."
    jrUdlAktOmv[portf_,t]$(t.val > %NettoFin_t1% and d1vUdlAkt[portf_,t] and portf[portf_]) "J-led som dækker forskel mellem selskabernes og den gennemsnitlige omvurdering på aktivet/passivet."
    jrUdlPasOmv[portf_,t]$(t.val > %NettoFin_t1% and d1vUdlPas[portf_,t] and not d1vUdlAkt[portf_,t] and portf[portf_]) "J-led som dækker forskel mellem selskabernes og den gennemsnitlige omvurdering på aktivet/passivet."

    rUdlPensUdb[t]$(t.val > %NettoFin_t1%) "Udenlændinges pensionsudbetalingsrate."

    rArbProd[t] "Timeproduktivitet."
    rpCInflSnit[t] "Glidende gennemsnit af forbrugerprisstigninger"
  ;
  $GROUP G_aggregates_endo G_aggregates_endo$(tx0[t]); # Restrict endo group to tx0[t]

  $GROUP G_aggregates_forecast_as_zero
    jvBNI[t] "J-led."
    jrUdlPensUdb[t] "J-led"
    jvtPALudl[t] "J-led"
    vBetalingsbalanceRest[t] "Restpost indeholder bl.a. anskaffelse af værdigenstande og ikke-finansielle, ikke-producerede aktier"
    vUdlPensIndb[t] "Pensionsindbetalinger fra udlandet, Kilde: ADAM[Tpc_e_z]"
  ;

  $GROUP G_aggregates_fixed_forecast
    rUdlRealkred[t] "Udenlandsk realkreditgæld (i Danmark) ift. husholdningernes realkredit gæld."
    rUdlPensIndb[t] "Udenlandske pensionsindbetalinger ift. husholdningernes pensionsindbetalinger."
    rUdlAkt2IndlPas[portf_,t] "Udenlandske aktiver ift. indenlandske passiver"
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_aggregates_static$(tx0[t])
    E_vBVT2hL[s,t].. vBVT2hL[s,t] =E= vBVT[s,t] / hL[s,t];
    E_vBVT2hL_sTot[t].. vBVT2hL[sTot,t] =E= vBVT[sTot,t] / hL[sTot,t];

    E_vBVT2hLsnit[t]..
      vBVT2hLsnit[t] =E= vBVT2hLsnit[t-1] * 0.8 + 0.2 * vBVT2hL[sTot,t];

    E_qBVT2hL[s,t].. qBVT2hL[s,t] =E= qBVT[s,t] / hL[s,t];
    E_qBVT2hL_sTot[t].. qBVT2hL[sTot,t] =E= qBVT[sTot,t] / hL[sTot,t];

    E_qBVT2hLsnit[t]..
      qBVT2hLsnit[t] =E= qBVT2hLsnit[t-1] * 0.8 + 0.2 * qBVT2hL[sTot,t];

    E_rpCInflSnit[t]..
      rpCInflSnit[t] =E= 0.8 * rpCInflSnit[t-1] + 0.2 * (pC['cTot',t] / (pC['cTot',t-1]/fp) - 1);

    E_vBNI[t]..
      vBNI[t] =E= vBNP[t]                               
                - vtEU[t] + vSubEU[t]  # Told og subsidier til og fra EU 
                - vWxDK[t]  # Lønninger til grænsearbejdere
                - vUdlNetRenter[t]  # Udenlandsk formueindkomst
                + jvBNI[t];

    # Udlandets realkreditgæld følger husholdningernes (Her er virksomhedernes passiver residualt jf. finance.gms!)
    E_vUdlPas_RealKred[t]$(t.val >= %NettoFin_t1%).. 
      vUdlPas['RealKred',t] =E= rUdlRealkred[t] * vHhPas['RealKred',aTot,t];

    # Udlandets pensionsindbetalinger følger indlandets
    E_vUdlPensIndb[t]$(t.val > %NettoFin_t1%)..
      vUdlPensIndb[t] =E= rUdlPensIndb[t] * vHhPensIndb['PensTot',aTot,t];

    # Udlandets PAL-skattebetalinger
    E_vtPALudl[t]$(t.val > %NettoFin_t1%).. 
      vtPALudl[t] =E= vtPAL[t] * vUdlAkt['PensTot',t-1]/vPensionAkt['Tot',t-1] + jvtPAludl[t];

    # Udlandets pensionsafkast
    E_vUdlPensAfk[t]$(t.val > %NettoFin_t1%).. 
      vUdlPensAfk[t] =E= vUdlAktRenter['PensTot',t] + vUdlAktOmv['PensTot',t] - vtPALudl[t];

    # Udlandets pensionsudbetalingsrate følger indlandets
    E_rUdlPensUdb[t]$(t.val > %NettoFin_t1%)..
      rUdlPensUdb[t] =E= rPensUdb['PensX',aTot,t] + jrUdlPensUdb[t];

    # Udlandets pensionsudbetalinger
    E_vUdlPensUdb[t]$(t.val > %NettoFin_t1%)..
      vUdlPensUdb[t] =E= rUdlPensUdb[t] * (vUdlAkt['PensTot',t-1]/fv + vUdlPensAfk[t]
                                           + vUdlAktOmv['PensTot',t] + vUdlPensIndb[t]);

   # Udlandets pensionsbeholdning
    E_vUdlAkt_PensTot[t]$(t.val > %NettoFin_t1%).. 
      vUdlAkt['PensTot',t] =E= vUdlAkt['PensTot',t-1]/fv + vUdlPensAfk[t] + vUdlPensIndb[t] - vUdlPensUdb[t];

    # Samlede pensionsindbetalinger, -udbetalinger og -afkast
    E_vPens[pens,t]$(t.val >= %NettoFin_t1% and not PensX[pens])..
      vPens[pens,t] =E= vHhPens[pens,aTot,t];
    E_vPensIndb[pens,t]$(t.val >= %NettoFin_t1% and not PensX[pens])..
      vPensIndb[pens,t] =E= vHhPensIndb[pens,aTot,t];
    E_vPensUdb[pens,t]$(t.val >= %NettoFin_t1% and not PensX[pens])..
      vPensUdb[pens,t] =E= vHhPensUdb[pens,aTot,t];
    E_vPensAfk[pens,t]$(t.val > %NettoFin_t1% and not PensX[pens])..
      vPensAfk[pens,t] =E= vHhPensAfk[pens,aTot,t];
    E_vPens_PensX[t]$(t.val >= %NettoFin_t1%)..
      vPens['PensX',t] =E= vUdlAkt['pensTot',t] + vHhPens['PensX',aTot,t];
    E_vPensIndb_PensX[t]$(t.val >= %NettoFin_t1%)..
      vPensIndb['PensX',t] =E= vUdlPensIndb[t] + vHhPensIndb['PensX',aTot,t];
    E_vPensUdb_PensX[t]$(t.val >= %NettoFin_t1%)..
      vPensUdb['PensX',t] =E= vUdlPensUdb[t] + vHhPensUdb['PensX',aTot,t];
    E_vPensAfk_PensX[t]$(t.val > %NettoFin_t1%)..
      vPensAfk['PensX',t] =E= vUdlPensAfk[t] + vHhPensAfk['PensX',aTot,t];
    E_vPens_pensTot[t]$(t.val >= %NettoFin_t1%)..
      vPens['pensTot',t] =E= sum(pens,vPens[pens,t]);
    E_vPensIndb_pensTot[t]$(t.val >= %NettoFin_t1%)..
      vPensIndb['pensTot',t] =E= sum(pens,vPensIndb[pens,t]);
    E_vPensUdb_pensTot[t]$(t.val >= %NettoFin_t1%)..
      vPensUdb['pensTot',t] =E= sum(pens,vPensUdb[pens,t]);
    E_vPensAfk_pensTot[t]$(t.val > %NettoFin_t1%)..
      vPensAfk['pensTot',t] =E= sum(pens,vPensAfk[pens,t]);

    # En fast andel af danske obligationer er ejet af udlændinge og en fast andel af dansk bankgæld er taget i udenlandske banker
    E_vUdlAkt_andel[portf,t]$(t.val >= %NettoFin_t1% and (Obl[portf] or Bank[portf]))..
      vUdlAkt[portf,t] =E= rUdlAkt2IndlPas[portf,t] * (vHhPas[portf,aTot,t] + vVirkPas[portf,t] + vOffPas[portf,t]);

    # Realkreditobligationer og indenlandske aktier er residualt givet for udlandet på aktiv-siden
    E_vUdlAkt_residual[portf,t]$(t.val >= %NettoFin_t1% and (IndlAktier[portf] or RealKred[portf]))..
      vUdlAkt[portf,t] =E= - vHhAkt[portf,aTot,t] - vVirkAkt[portf,t] - vOffAkt[portf,t] - vPensionAkt[portf,t]
                           + vHhPas[portf,aTot,t] + vVirkPas[portf,t] + vOffPas[portf,t] + vUdlPas[portf,t];
    # Udlandets passivbeholdning er residualt givet (bortset fra realkredit og indenlandske aktier, hvor der for sidstnævnte ikke er nogen passiver)
    E_vUdlPas_residual[portf,t]$(t.val >= %NettoFin_t1% and d1vUdlPas[portf,t] and not RealKred[portf])..
      vUdlPas[portf,t] =E= vHhAkt[portf,aTot,t] + vVirkAkt[portf,t] + vOffAkt[portf,t] + vPensionAkt[portf,t] + vUdlAkt[portf,t]
                         - vHhPas[portf,aTot,t] - vVirkPas[portf,t] - vOffPas[portf,t];

    E_vUdlAkt_tot[t]$(t.val >= %NettoFin_t1%)..
      vUdlAkt['tot',t] =E= sum(portf, vUdlAkt[portf,t]);

    E_vUdlPas_tot[t]$(t.val >= %NettoFin_t1%)..
      vUdlPas['tot',t] =E= sum(portf, vUdlPas[portf,t]);

    E_vUdlNet[t]$(t.val >= %NettoFin_t1%)..
      vUdlNet[t] =E= vUdlAkt['tot',t] - vUdlPas['tot',t];

    # Renter og omvurderinger for udlandet
    E_vUdlAktRenter_via_jrUdlAktRenter[portf,t]$(d1vUdlAkt[portf,t] and t.val > %NettoFin_t1%)..
      vUdlAktRenter[portf,t] =E= (rRente[portf,t] + jrUdlAktRenter[portf,t]) * vUdlAkt[portf,t-1]/fv;

    E_vUdlPasRenter_via_jrUdlPasRenter[portf,t]$(d1vUdlPas[portf,t] and t.val > %NettoFin_t1%)..
      vUdlPasRenter[portf,t] =E= (rRente[portf,t] + jrUdlPasRenter[portf,t]) * vUdlPas[portf,t-1]/fv;

    E_vUdlNetRenter[t]$(t.val > %NettoFin_t1%)..
      vUdlNetRenter[t] =E= sum(portf, vUdlAktRenter[portf,t]) - sum(portf, vUdlPasRenter[portf,t]);

    E_vUdlAktOmv_via_jrUdlAktOmv[portf,t]$(d1vUdlAkt[portf,t] and t.val > %NettoFin_t1%)..
      vUdlAktOmv[portf,t] =E= (rOmv[portf,t] + jrUdlAktOmv[portf,t]) * vUdlAkt[portf,t-1]/fv;

    E_vUdlPasOmv_via_jrUdlPasOmv[portf,t]$(d1vUdlPas[portf,t] and t.val > %NettoFin_t1%)..
      vUdlPasOmv[portf,t] =E= (rOmv[portf,t] + jrUdlPasOmv[portf,t]) * vUdlPas[portf,t-1]/fv;

    E_vUdlOmv[t]$(t.val > %NettoFin_t1%)..
      vUdlOmv[t] =E= sum(portf, vUdlAktOmv[portf,t]) - sum(portf, vUdlPasOmv[portf,t]);

    # Renter og omvurderingerne til udlandets pensionsbeholdning er residualt givet ud fra husholdningernes renter og omvurderinger til pension
    E_vUdlAktRenter_Pens[portf,t]$(t.val > %NettoFin_t1% and PensTot[portf])..
      vUdlAktRenter[portf,t] =E= vPensionRenter[t] - vHhAktRenter[portf,t];
    E_vUdlAktOmv_Pens[portf,t]$(t.val > %NettoFin_t1% and PensTot[portf])..
      vUdlAktOmv[portf,t] =E= vPensionOmv[t] - vHhAktOmv[portf,t];

    # Udenlandske renter og omvurderinger på aktiver og passiver er residualt givet
    # Udgangspunktet er, at residualet ligger på aktiv-siden
    E_vUdlAktRenter[portf,t]$(t.val > %NettoFin_t1% and d1vUdlAkt[portf,t] and not PensTot[portf])..
      vUdlAktRenter[portf,t] =E= - vHhAktRenter[portf,t] - vOffAktRenter[portf,t] - vVirkAktRenter[portf,t] - vPensionAktRenter[portf,t]
                                 + vHhPasRenter[portf,t] + vOffPasRenter[portf,t] + vVirkPasRenter[portf,t] + vUdlPasRenter[portf,t];
    E_vUdlAktOmv[portf,t]$(t.val > %NettoFin_t1% and d1vUdlAkt[portf,t] and not PensTot[portf])..
      vUdlAktOmv[portf,t] =E= - vHhAktOmv[portf,t] - vOffAktOmv[portf,t] - vVirkAktOmv[portf,t] - vPensionAktOmv[portf,t]
                              + vHhPasOmv[portf,t] + vOffPasOmv[portf,t] + vVirkPasOmv[portf,t] + vUdlPasOmv[portf,t];

    # Findes ingen aktiv-side, så er udlandets passiv-side residual (dette gælder for udenlandske aktier)
    E_vUdlPasRenter[portf,t]$(t.val > %NettoFin_t1% and d1vUdlPas[portf,t] and not d1vUdlAkt[portf,t])..
      vUdlPasRenter[portf,t] =E= vHhAktRenter[portf,t] + vOffAktRenter[portf,t] + vVirkAktRenter[portf,t] + vPensionAktRenter[portf,t]
                               - vHhPasRenter[portf,t] - vOffPasRenter[portf,t] - vVirkPasRenter[portf,t];
    E_vUdlPasOmv[portf,t]$(t.val > %NettoFin_t1% and d1vUdlPas[portf,t] and not d1vUdlAkt[portf,t])..
      vUdlPasOmv[portf,t] =E= vHhAktOmv[portf,t] + vOffAktOmv[portf,t] + vVirkAktOmv[portf,t] + vPensionAktOmv[portf,t]
                            - vHhPasOmv[portf,t] - vOffPasOmv[portf,t] - vVirkPasOmv[portf,t];

    E_vUdlNFE_via_jvUdlNFE[t]$(t.val > %NettoFin_t1%).. 
      vUdlNFE[t] =E= vUdlNet[t] - vUdlNet[t-1]/fv - vUdlOmv[t]
                   - vVirkAkt['Guld',t] + (1+rOmv['Guld',t]) * vVirkAkt['Guld',t-1]/fv
                   + jvUdlNFE[t];

    E_vUdlNFE[t]$(t.val > %NettoFin_t1%)..
      vHhNFE[t] + vVirkNFE[t] + vSaldo[t] + vUdlNFE[t] =E= 0; 
      # Svarer til relationen i ADAM

    E_vBetalingsbalance[t]$(t.val > %NettoFin_t1%)..
      vBetalingsbalance[t] =E= vOffTilUdlKap[t] - vOffFraUdlKap[t] - vUdlNFE[t] + vBetalingsbalanceRest[t];

    E_rArbProd[t].. rArbProd[t] =E= qBVT[sTot,t] / nL[sTot,t];
  $ENDBLOCK

  $BLOCK B_aggregates_forwardlooking$(tx0[t])
    E_vVirkBVT5aarSnit[t]$(t.val < tEnd.val-1)..
      vVirkBVT5aarSnit[t] =E= (vBVT[spTot,t-2]/fv/fv + vBVT[spTot,t-1]/fv + vBVT[spTot,t] + vBVT[spTot,t+1]*fv + vBVT[spTot,t+2]*fv*fv) / 5;
    E_vVirkBVT5aarSnit_t1End[t]$(t.val >= tEnd.val-1)..
      vVirkBVT5aarSnit[t] =E= (vVirkBVT5aarSnit[t-1]/vBVT[sptot,t-1])*vBVT[sptot,t];
  $ENDBLOCK

  Model M_aggregates /
    B_aggregates_static
    B_aggregates_forwardlooking
  /;  

  $GROUP G_aggregates_static
    G_aggregates_endo
    -vVirkBVT5aarSnit # -E_vVirkBVT5aarSnit -E_vVirkBVT5aarSnit_t1End -E_vVirkBVT5aarSnit_tEnd
  ;
$ENDIF


$IF %stage% == "exogenous_values":
# ======================================================================================================================
# Data assignment
# - Assign data to variables. Complicated data work should be done where the data is read.
# ======================================================================================================================
  $GROUP G_aggregates_data  # Variable som er datadækket og ikke må ændres af kalibrering
    vBNI
    vBetalingsbalance
    vUdlNet, vUdlAkt, vUdlPas
    vUdlOmv
    vUdlAktRenter$(t.val <> 2005 and t.val <> 2007), vUdlPasRenter #!!! Tjek hvorfor vUdlAktRenter ikke rammer i 2005 og 2007
    vUdlAktOmv, vUdlPasOmv
    vtPALudl, vUdlPensIndb, vUdlPensUdb
    vUdlNFE, vUdlNetRenter
  ;

  $GROUP G_aggregates_data_imprecise
    vUdlNet, vUdlAkt, vUdlPas
    vUdlOmv, vUdlAktRenter$(t.val <> 2005 and t.val <> 2007), vUdlAktOmv
    vBVT[spTot,t]
    vUdlPasOmv$(UdlAktier[portf_] and (t.val = 2004 or t.val = 1999 or t.val=1998 or t.val=1997 or t.val=1996))
  ;

  $GROUP G_aggregates_data_load 
    G_aggregates_data, 
    G_aggregates_data_imprecise
   ;
  @load(G_aggregates_data_load, "..\Data\makrobk\makrobk.gdx")

# ======================================================================================================================
# Data assignment
# ======================================================================================================================
  #Set Dummy for foreign portfolio
  d1vUdlAkt[portf,t] = yes$(vUdlAkt.l[portf,t] <> 0);
  d1vUdlPas[portf,t] = yes$(vUdlPas.l[portf,t] <> 0);

  d1vUdlAkt['tot',t] = yes$(sum(portf,vUdlAkt.l[portf,t]) <> 0);
  d1vUdlPas['tot',t] = yes$(sum(portf,vUdlPas.l[portf,t]) <> 0);

  # Midlertidigt hack pga. problemer i data - PK 2025-02-19
  # vUdlPasOmv.l[UdlAktier,'1995'] = vHhAktOmv.l[UdlAktier,'1995'] + vOffAktOmv.l[UdlAktier,'1995'] + vVirkAktOmv.l[UdlAktier,'1995'] + vPensionAktOmv.l[UdlAktier,'1995'];
  # vUdlAktOmv.l[IndlAktier,'1995'] = - vHhAktOmv.l[IndlAktier,'1995'] - vOffAktOmv.l[IndlAktier,'1995'] - vVirkAktOmv.l[IndlAktier,'1995'] 
  #   - vPensionAktOmv.l[IndlAktier,'1995'] + vVirkPasOmv.l[IndlAktier,'1995'] + vUdlPasOmv.l[IndlAktier,'1995'];
  vUdlPasOmv.l[UdlAktier,'1995'] = 3.949;
  vUdlAktOmv.l[IndlAktier,'1995'] = -2.051;
  vUdlAkt.l[IndlAktier,'1994'] = 127.196;
  vUdlAkt.l['tot','1994'] = 1392.39;
  vUdlPas.l[UdlAktier,'1994'] = 156.755;
  vUdlPas.l['tot','1994'] = 826.896;
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_aggregates_static_calibration
    G_aggregates_endo
    -vBNI, jvBNI
    -vtPALudl$(t.val > %NettoFin_t1%), jvtPALudl$(t.val > %NettoFin_t1%)
    -vUdlPas[RealKred,t], rUdlRealkred$(t.val >= %NettoFin_t1%)
    -vUdlAkt[Obl,t]$(t.val >= %NettoFin_t1%), rUdlAkt2IndlPas[Obl,t]$(t.val >= %NettoFin_t1%)
    -vUdlAkt[Bank,t]$(t.val >= %NettoFin_t1%), rUdlAkt2IndlPas[Bank,t]$(t.val >= %NettoFin_t1%)
    -vUdlPasRenter[portf,t]$(t.val > %NettoFin_t1% and d1vUdlPas[portf,t] and d1vUdlAkt[portf,t]), jrUdlPasRenter[portf,t]$(t.val > %NettoFin_t1% and d1vUdlPas[portf,t] and d1vUdlAkt[portf,t])
    -vUdlPasOmv[portf,t]$(t.val > %NettoFin_t1% and d1vUdlPas[portf,t] and d1vUdlAkt[portf,t]), jrUdlPasOmv[portf,t]$(t.val > %NettoFin_t1% and d1vUdlPas[portf,t] and d1vUdlAkt[portf,t])
    -vBetalingsbalance$(t.val >= %NettoFin_t1%), vBetalingsbalanceRest$(t.val >= %NettoFin_t1%)
    -vUdlPensIndb$(t.val > %NettoFin_t1%), rUdlPensIndb$(t.val > %NettoFin_t1%)
    -vUdlPensUdb$(t.val > %NettoFin_t1%), jrUdlPensUdb$(t.val > %NettoFin_t1%)
   ;
  $GROUP G_aggregates_static_calibration G_aggregates_static_calibration$(tx0[t])
    vUdlNet[t0] # E_vUdlNet_t0
    vBVT2hLsnit[t0]
    qBVT2hLsnit[t0]
  ;

  $BLOCK B_aggregates_static_calibration
     E_vUdlNet_t0[t]$(t0[t]).. vUdlNet[t] =E= sum(portf, vUdlAkt[portf,t]) - sum(portf, vUdlPas[portf,t]);
     E_vBVT2hLsnit_t0[t]$(t1[t]).. vBVT2hLsnit[t] =E= vBVT2hL[sTot,t];
     E_qBVT2hLsnit_t0[t]$(t1[t]).. qBVT2hLsnit[t] =E= qBVT2hL[sTot,t];
  $ENDBLOCK
  MODEL M_aggregates_static_calibration /
    M_aggregates
    B_aggregates_static_calibration
  /;

  $GROUP G_aggregates_static_calibration_newdata
    G_aggregates_static_calibration
   ;
  MODEL M_aggregates_static_calibration_newdata /
    M_aggregates_static_calibration
  /;
$ENDIF

# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_aggregates_deep    
    G_aggregates_endo
    -vUdlPas[RealKred,t1], rUdlRealkred[t1]$(t.val >= %NettoFin_t1%)
    -vUdlAkt[Obl,t1]$(t1[t]), rUdlAkt2IndlPas[Obl,t1]$(t1[t])
    -vUdlAkt[Bank,t1]$(t1[t]), rUdlAkt2IndlPas[Bank,t1]$(t1[t])

  ;
  $GROUP G_aggregates_deep G_aggregates_deep$(tx0[t]);

  MODEL M_aggregates_deep /M_aggregates/;
$ENDIF

# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================

$IF %stage% == "dynamic_calibration_newdata":
  $GROUP G_aggregates_dynamic_calibration
  G_aggregates_endo
    -vUdlPas[RealKred,t1], rUdlRealkred[t1]$(t.val >= %NettoFin_t1%)
    -vUdlAkt[Obl,t1]$(t1[t]), rUdlAkt2IndlPas[Obl,t1]$(t1[t])
    -vUdlAkt[Bank,t1]$(t1[t]), rUdlAkt2IndlPas[Bank,t1]$(t1[t])
  ;
  MODEL M_aggregates_dynamic_calibration / 
    M_aggregates
  /;
$ENDIF
