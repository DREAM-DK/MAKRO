$SETLOCAL shock_year 2026;
set_time_periods(%shock_year%-1, %terminal_year%)
@save(All);

# ======================================================================================================================
# Partiel model, som simulerer stød til en enkelt husholdning til beregning af MPC og pensions-fortrængning
# ======================================================================================================================
#  Aggregater beregnet bottom-up
$BLOCK B_bottom_up_aggregater
  E_vHhInd_aTot_bottom_up[t]$(tx0[t]).. vHhInd[aTot,t] =E= sum(a$(a0t100[a]), vHhInd[a,t] * nPop[a,t]);
  E_vHhx_aTot_bottom_up[t]$(tx0[t]).. vHhx[aTot,t] =E= sum(a$(a0t100[a]), vHhx[a,t] * nPop[a,t]);
  E_vHh_pens_aTot_bottom_up[pens_,t]$(tx0[t]).. vHh[pens_,aTot,t] =E= sum(a$(a0t100[a]), vHh[pens_,a,t] * nPop[a,t]);  
  E_vHh_NetFin_aTot_bottom_up[t]$(tx0[t]).. vHh['NetFin',aTot,t] =E= sum(a$(a0t100[a]), vHh['NetFin',a,t] * nPop[a,t]);

  E_vBolig_aTot_bottom_up[t]$(tx0[t]).. vBolig[aTot,t] =E= sum(a$(a0t100[a]), vBolig[a,t] * nPop[a,t]);
  E_qBolig_aTot_bottom_up[t]$(tx0[t]).. qBolig[aTot,t] =E= sum(a$(a0t100[a]), qBolig[a,t] * nPop[a,t]);
$ENDBLOCK

# Nogle ligninger erstattes
$BLOCK B_partiel
  # Det samlede-boligforbrug følger boligmængden i den partielle model
  E_qC_cbol_partiel[t]$(tx0[t]).. qC['cbol',t] =E= qC.l['cbol',t] * qBolig[aTot,t] / qBolig.l[aTot,t];

  # Boligkapitalen følger boligmængden i den partielle model
  E_qKBolig_partiel[t]$(tx0[t]).. qKBolig[t] =E= qKBolig.l[t] * qBolig[aTot,t] / qBolig.l[aTot,t];
$ENDBLOCK

#  Det er ikke givet hvorvidt referenceforbrug skal eksogeniseres eller ej. Hvis indkomststød betragtes som at være til en enkelt husholdning,
#  da vil man skulle eksogenisere denne, hvis referenceforbrug fortolkes som et gennemsnit af adfærd fra lignende husholdninger.
#  Man vil dog muligvis gerne have effekten med alligevel. I så fald kan det ses som at indkomststødet er til få husholdninger, 
#  der anser hinanden som referencegruppe.
$MODEL B_ref_endogen
  E_qCRxRef, 
  E_qCRxRef_a18 
  E_qBoligRxRef 
  E_qBoligRxRef_a18
;

$BLOCK B_ref_eksogen
  E_qCRxRef_eks[a,t]$(tx0[t] and a18t100[a] and a.val <> 18)..
    qCRxRef[a,t] =E= qCR[a,t] / fHh[a,t] - rRef * qCR.l[a-1,t-1]/fq / fHh[a-1,t-1];
  E_qCRxRef_a18_eks[a,t]$(tx0[t] and a.val = 18)..
    qCRxRef[a,t] =E= qCR[a,t] - rRef * qCR.l[a,t]/fq;

  E_qBoligRxRef_eks[a,t]$(a18t100[a] and a.val <> 18 and tx0[t])..
    qBoligRxRef[a,t] =E= qBoligR[a,t] / fHh[a,t] - rRefBolig * rOverlev[a-1,t-1] * qBoligR.l[a-1,t-1]/fq / fHh[a-1,t-1];
  E_qBoligRxRef_a18_eks[a,t]$(a.val = 18 and tx0[t])..
    qBoligRxRef[a,t] =E= qBoligR[a,t] - rRefBolig * rOverlev[a-1,t-1] * qBoligR.l[a,t]/fq;
$ENDBLOCK

$BLOCK B_realkred_endogen
  E_cHh_a_obl[a,t]$(tx0[t] and a0t100[a])..     
      cHh_a['obl',a,t] * vBVT2hLsnit[t] =E= cHh_a.l['obl',a,t] * vBVT2hLsnit[t] + 0.4 * (1 - dvHh2dvHhx.l['obl',t]) * (vHhx[a,t] - vHhx.l[a,t]);
  E_cHh_a[akt,a,t]$(tx0[t] and fin_akt[akt] and not sameas['obl',akt] and a0t100[a])..     
      cHh_a[akt,a,t] * vBVT2hLsnit[t] =E= cHh_a.l[akt,a,t] * vBVT2hLsnit[t] - 0.4 * dvHh2dvHhx.l[akt,t] * (vHhx[a,t] - vHhx.l[a,t]);
$ENDBLOCK

# Vurdering af de 0.4 ovenfor ved: PLOT <18u 100u> (0.8-a(rRealKred2Bolig)[2017])*a(vBolig)[2017],0.4*a(vHhx)[2017]+0.1;

$MODEL B_post_partiel
  E_vHhFormue
  E_vHhFormue_tot
  E_vHhPens
  E_vHhPens_tot
  E_vHhFormueR
  E_vHhFormueR_tot
  E_vHhxR
  E_vHhxR_tot
  E_vHhPensR
  E_vHhPensR_tot
  E_vFrivaerdiR
  E_vFrivaerdiR_tot
  E_vHhIndR
  E_vHhIndR_tot
  E_vHhIndMvR
  E_vHhIndMvR_tot
  E_vCR_NR
  E_vCR_NR_tot
  E_qCR_NR
  E_qCR_NR_tot
  E_vHhNetFinR
  E_vHhNetFinR_tot
  E_vBoligR
  E_vBoligR_tot
  E_vHhFormueHtM
  E_vHhFormueHtM_tot
  E_vHhPensHtM
  E_vHhPensHtM_tot
  E_vFrivaerdiHtM
  E_vFrivaerdiHtM_tot
  E_vHhIndHtM
  E_vHhIndHtM_tot
  E_vHhIndMvHtM
  E_vHhIndMvHtM_tot
  E_vCHtM_NR
  E_vCHtM_NR_tot
  E_qCHtM_NR
  E_qCHtM_NR_tot
  E_vHhNetFinHtM
  E_vHhNetFinHtM_tot
  E_vC_NR
  E_vC_NR_tot
  E_qC_NR
  E_qC_NR_tot
  E_vHhIndMv
  E_vHhIndMv_tot

  E_qCHtM_tot
  E_vBoligHtM_tot
  E_qBoligHtM_tot
  E_qCR_tot
  E_vHh_RealKred_aTot
  E_rRealKred2Bolig_aTot
  E_qBoligR_tot
  E_vHh_aTot

  B_bottom_up_aggregater
 ;

$GROUP G_post_partiel
  vHhFormue[a_,t]$((a0t100[a_] and t.val > 2015) or aTot[a_]) "Samlet formue inklusiv bolig."
  vHhPens[a_,t]$(a0t100[a_] or aTot[a_]) "Pensionsformue EFTER SKAT"
  vHhFormueR[a_,t]$(a0t100[a_] or aTot[a_]) "Samlet formue inklusiv bolig for fremadskuende husholdninger"
  vHhxR[a_,t]$(a0t100[a_] or aTot[a_]) "Fremadskuende husholdningers formue ekskl. pension og realkreditgæld"
  vHhPensR[a_,t]$(a0t100[a_] or aTot[a_]) "Pensionsformue for fremadskuende husholdninger EFTER SKAT"
  vFrivaerdiR[a_,t]$(a0t100[a_] or aTot[a_]) "Friværdi (boligværdi fratrukket realkreditgæld) for fremadskuende husholdninger"
  vHhIndR[a_,t]$(a0t100[a_] or aTot[a_]) "Fremadskuende husholdningers indkomst"
  vHhIndMvR[a_,t]$(a0t100[a_] or aTot[a_]) "Fremadskuende husholdningers indkomst og lån i friværdi"
  vCR_NR[a_,t]$(a0t100[a_] or aTot[a_]) "Fremadskuende husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
  qCR_NR[a_,t]$(a0t100[a_] or aTot[a_]) "Fremadskuende husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
  vHhNetFinR[a_,t]$(a0t100[a_] or aTot[a_]) "Finansiel nettoformue for fremadskuende husholdninger"
  vBoligR[a_,t]$((a18t100[a_] or atot[a_]) and t.val > 2015) "Fremadskuende husholdningernes boligformue."
  vHhFormueHtM[a_,t]$(a0t100[a_] or aTot[a_]) "Samlet formue inklusiv bolig for HtM-husholdninger"
  vHhPensHtM[a_,t]$(a0t100[a_] or aTot[a_]) "Pensionsformue for HtM-husholdninger EFTER SKAT"
  vFrivaerdiHtM[a_,t]$(a0t100[a_] or aTot[a_]) "Friværdi (boligværdi fratrukket realkreditgæld) for HtM-husholdninger"
  vHhIndHtM[a_,t]$(a0t100[a_] or aTot[a_]) "HtM-husholdningers indkomst"
  vHhIndMvHtM[a_,t]$(a0t100[a_] or aTot[a_]) "HtM-husholdningers indkomst og lån i friværdi"
  vCHtM_NR[a_,t]$(a0t100[a_] or aTot[a_]) "HtM-husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
  qCHtM_NR[a_,t]$(a0t100[a_] or aTot[a_]) "HtM-husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
  vHhNetFinHtM[a_,t]$(a0t100[a_] or aTot[a_]) "Finansiel nettoformue for HtM-husholdninger"
  vC_NR[a_,t]$(a0t100[a_] or aTot[a_]) "Gns. husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
  qC_NR[a_,t]$(a0t100[a_] or aTot[a_]) "Gns. husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
  vHhIndMv[a_,t]$(a0t100[a_] or aTot[a_]) "Fremadskuende husholdningers indkomst og lån i friværdi"

  vHhInd[a_,t]$(atot[a_]) "Husholdningernes indkomst."
  vHhx[a_,t]$(aTot[a_]) "Husholdningernes formue ekskl. pension og realkreditgæld (vægtet gns. af Hand-to-Mouth og rationelle forbrugere)"
  vHh$(sameas[portf_, "NetFin"] and aTot[a_])
  vHh$(pens[portf_] and atot[a_]) ""
  vHh$(sameas[portf_, "pens"] and atot[a_]) ""
  vBolig[a_,t]$(atot[a_]) "Husholdningernes boligformue"
  qBolig[a_,t]$(atot[a_])     "Ejerboliger ejet af husholdningerne (aggregat af kapital og land)"
  
  qCHtM[a_,t]$(aTot[a_])    "Individuel forbrug ekskl. bolig for hand-to-mouth agenter."
  vBoligHtM[a_,t]$(atot[a_]) "Hånd-til-mund husholdningernes boligformue."
  qBoligHtM[a_,t]$(aTot[a_])  "Ejerboliger ejet af hand-to-mouth husholdningerne."
  qCR[a_,t]$(aTot[a_])       "Individuel forbrug ekskl. bolig for rationelle fremadskuende agenter"
  vHh$(sameas[portf_, "RealKred"] and aTot[a_])
  rRealKred2Bolig[a_,t]$(atot[a_])  "Husholdningernes realkreditgæld relativt til deres boligformue."
  qBoligR[a_,t]$(aTot[a_])    "Ejerboliger ejet af rationelle fremadskuende husholdningerne."
  vHh$(fin_akt[portf_] and aTot[a_])
;

$GROUP G_Partiel
  vC_a[a,t]$(a18t100[a]) "Individuelt forbrug ekskl. bolig"
  qC_a[a,t]$(a18t100[a]) "Individuelt forbrug ekskl. bolig"
  qCHtM[a_,t]$(a18t100[a_])    "Individuel forbrug ekskl. bolig for hand-to-mouth agenter."
  vBoligUdgiftHtM[a_,t] "Netto udgifter til køb/salg/forbrug af bolig for hand-to-mouth husholdninger."
  vBoligHtM[a_,t]$(a18t100[a_]) "Hånd-til-mund husholdningernes boligformue."
  qBoligHtM[a_,t]$(a18t100[a_])  "Ejerboliger ejet af hand-to-mouth husholdningerne."
  qBoligHtMxRef[a_,t]$(a18t100[a_])  "Ejerboliger ejet af hand-to-mouth husholdningerne eksl. referenceforbrug."
  qCHtMxRef[a_,t]$(a18t100[a_])   "Individuel forbrug ekskl. bolig og referenceforbrug for hand-to-mouth agenter ."
  qCR[a_,t]$(a18t100[a_])       "Individuel forbrug ekskl. bolig for rationelle fremadskuende agenter"
  EmUC[a,t] "Expected marginal utility of consumption."
  mUC[a,t] "Marginal utility of consumption"
  qNytte[a,t]                                "CES nest af bolig og andet privat forbrug."
  dFormue[a_,t] "Formue-nytte differentieret med hensyn til bolig"
  qFormueBase[a,t] "Hjælpevariabel til førsteordensbetingelse for nytte af formue."
  vHh$(sameas[portf_, "NetFin"] and a0t100[a_])
  vHh$(sameas[portf_, "RealKred"] and a18t100[a_])
  vHhx[a_,t]$(a0t100[a_]) "Husholdningernes formue ekskl. pension og realkreditgæld (vægtet gns. af Hand-to-Mouth og rationelle forbrugere)"
  vBoligUdgift[a_,t]$(aVal[a_] > 0) "Cash-flow-udgift til bolig - dvs. inkl. afbetaling på gæld og inkl. øvrige omkostninger fx renter og bidragssats på realkreditlån"
  vBolig[a_,t]$(a18t100[a_]) "Husholdningernes boligformue"
  qBolig[a_,t]$(a18t100[a_])     "Ejerboliger ejet af husholdningerne (aggregat af kapital og land)"
  qBoligRxRef[a_,t]$(a18t100[a_]) "Ejerboliger ejet af husholdningerne ekskl. referenceforbrug"
  mUBolig[a,t]$(a18t100[a]) "Marginal nytte af boligkapital"
  dArv[a_,t]$(a18t100[a_]) "Arvefunktion differentieret med hensyn til bolig"
  qArvBase[a,t] "Hjælpevariabel til førsteordensbetingelse for arve-nytte."
  rRealKred2Bolig[a_,t]$(a18t100[a_])  "Husholdningernes realkreditgæld relativt til deres boligformue."
  pBoligRigid[a,t] "Rigid boligpris til brug i rRealKred2Bolig"

  vHhInd[a_,t]$(a0t100[a_]) "Husholdningernes indkomst."
  vPensIndb[portf_,a_,t]$(pens_[portf_] and a15t100[a_]) "Pensionsindbetalinger"
  vPensUdb[portf_,a_,t]$(pens_[portf_] and a15t100[a_]) "Pensionsudbetalinger"
  vHh$(pens[portf_] and a15t100[a_]) ""
  vHh$(sameas[portf_, "pens"] and a15t100[a_]) ""
  vPensArv[portf_,a_,t]$(pens_[portf_] and (aVal[a_] >= 15)) "Pension udbetalt til arvinger i tilfælde af død."
  vHhPensAfk "Afkast fra pensionsformue EFTER SKAT"
#  vArv[a_,t]  "Arv modtaget af en person med alderen a"
  vArvGivet[a,t] "Arv givet af hele kohorten med alder a"
  vArvKorrektion[a_,t]$(a0t100[a_]) "Arv som tildeles afdødes kohorte for at korregerer for selektionseffekt (formue og døds-sandsynlighed er mod-korreleret)."

  vHhxAfk[a_,t]$(aVal[a_] > 0)  "Imputeret afkast på husholdningernes formue ekskl. bolig og pension"
  vHh$(sameas[portf_, "BankGaeld"] and a[a_])
  vHh$(fin_akt[portf_] and a0t100[a_])
  vHhFinAkt[a_,t]$(a0t100[a_]) "Finansielle aktiver ejer af husholdningerne ekskl. pension"

  qCRxRef[a,t]$(a18t100[a]) "Forbrug ekskl. bolig og eksklusiv referenceforbrug"
  qBoligR[a_,t]$(a18t100[a_])    "Ejerboliger ejet af rationelle fremadskuende husholdningerne."

  qC[c_,t]$(sameas[c_, "cbol"]) "Husholdningernes samlede forbrug fordelt på forbrugsgrupper og aggregater inkl. lejebolig og imputeret ejerbolig"
  qKBolig[t]                    "Kapitalmængde af ejerboliger, Kilde: ADAM[fKnbhe]"

  # G_incl_taxes
  vtHhx[a,t]$(a0t100[a_])        "Skatter knyttet til husholdningerne i MAKRO ekskl. pensionsafkastskat, ejendomsværdiskat og dødsboskat"
  vtBund[a_,t]$(a15t100[a_])     "Bundskatter, Kilde: ADAM[Ssysp1]"
  vtTop[a_,t]$(a15t100[a_])      "Topskatter, Kilde: ADAM[Ssysp2]+ADAM[Ssysp3]"
  vtKommune[a_,t]$(a15t100[a_])  "Kommunal indkomstskatter, Kilde: ADAM[Ssys1]+ADAM[Ssys2]"
  vtAktie[a_,t]$(a0t100[a_])     "Aktieskat, Kilde: ADAM[Ssya]"
  vtPersRest[a_,t]$(a15t100[a_]) "Andre personlige indkomstskatter, Kilde: ADAM[Syp]"
  vtKapPens[a_,t]$(a15t100[a_])  "Andre personlige indkomstskatter fratrukket andre personlige indkomstskatter resterende, ADAM[Syp]-ADAM[Sypr]"
  vPersInd[a_,t]$(a15t100[a_] and tx0[t])
  vNetKapIndPos[a_,t]$(a15t100[a_])
  vKapIndPos[a_,t]$(a15t100[a_])
  vSkatteplInd[a_,t]$(a15t100[a_])
  vNetKapInd[a_,t]$(a15t100[a_])
  vKapIndNeg[a_,t]$(a15t100[a_])
  vRealiseretAktieOmv[a_,t]$(a0t100[a_])
  vtArv$( t.val > 2015)  

;

#  Partiel model
$MODEL M_partiel
  E_vC_a 
  E_qC_a 
    E_qCHtM
     E_vBoligUdgiftHtM 
      E_vBoligHtM
      E_qBoligHtM
       E_qBoligHtMxRef, E_qBoligHtMxRef_a18
       E_qCHtMxRef, E_qCHtMxRef_a18 
    E_qCR, E_qCR_tEnd
     E_EmUC, E_EmUC_tEnd, E_EmUC_aEnd, E_EmUC_aEnd_tEnd
     E_mUC, E_mUC_unge
      E_qNytte
     E_dFormue
      E_qFormueBase
        E_vHh_NetFin
         E_vHh_RealKred
         E_vHhx
          E_vBoligUdgift
           E_vBolig
            E_qBolig
              E_qBoligR # Knytter sig til qBoligRxRef
               E_mUBolig, E_mUBolig_tEnd
     E_dArv, E_dArv_tEnd
      E_qArvBase
  E_rRealKred2Bolig
  E_pBoligRigid, E_pBoligRigid_a18

  E_vHhInd
    E_vPensIndb, E_vPensIndb_pension
  E_vPensUdb, E_vPensUdb_pension
    E_vHh_pens
    E_vHh_pension
      E_vPensArv, E_vPensArv_pension
      E_vHhPensAfk
# Arv beregnes ikke i et partielt stød, da denne fordeles ud bredt
#    E_vArv, E_vArv_aTot
      E_vArvGivet
# Arvekorrektionen medtages, da det udtrykker selektion i dem af udvalgte, der dør
      E_vArvKorrektion

  E_vHhxAfk
    E_vHh_BankGaeld
      E_vHhFinAkt
    E_vHh_akt

  E_qC_cbol_partiel
  E_qKBolig_partiel

  B_ref_endogen

  # M_incl_tax
  E_vtHhx
  E_vtBund
  E_vPersInd
  E_vNetKapIndPos
  E_vKapIndPos
  E_vtTop
  E_vtKommune
  E_vSkatteplInd
  E_vNetKapInd
  E_vKapIndNeg
  E_vtAktie
  E_vRealiseretAktieOmv
  E_vtPersRest
  E_vtKapPens
  E_vtArv

;

@reset(All);
$FIX ALL; $UNFIX G_Partiel$(tx0[t]);
@solve(M_partiel);
$FIX All; $UNFIX G_post_partiel$(tx0[t]);
@solve(B_post_partiel);
@unload(Gdx\partiel);