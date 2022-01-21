# ======================================================================================================================
# Module for calculating pure output variables not present in the model
# - This model is run after the main model only
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_post_prices
    pLxUdn[sp,t] "User cost for effektiv arbejdskraft før kapacitetsudnyttelse i produktionsfunktion."
    pI_s[i_,s_,t]$((spTot[s_] and k[i_]) or iTot[i_]) "Investeringsdeflator fordelt på brancher, Kilde: ADAM[pI<i>] eller ADAM[pim<i>] eller ADAM[pib<i>]"
  ;
  $GROUP G_post_quantities
    qLxUdn[s,t] "Arbejdskraft i effektive enheder før kapacitetsudnyttelse."
    qI_s[i_,s_,t]$((spTot[s_] and k[i_]) or iTot[i_]) "Investeringer fordelt på brancher, Kilde: ADAM[fI<i>] eller ADAM[fIm<i>] eller ADAM[fIb<i>]" 
    qCR_NR[a_,t]$(a0t100[a_] or aTot[a_]) "Fremadskuende husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
    qCHtM_NR[a_,t]$(a0t100[a_] or aTot[a_]) "HtM-husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
    qC_NR[a_,t]$(a0t100[a_] or aTot[a_]) "Gns. husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
  ;
  $GROUP G_post_values
    vI_s[i_,s_,t]$(spTot[s_] and k[i_]) "Investeringer fordelt på brancher, Kilde: ADAM[I<i>] eller ADAM[Im<i>] eller ADAM[iB<i>]"
    vhWVirk[t] "Gennemsnitlig timeløn i den private sektor ekskl. produktionsskatter."
    vOffLoen[t] "Gennemsnitlig timeløn i den offentlige sektor inkl. produktionsskatter."
    vHhFormueR[a_,t]$(a0t100[a_] or aTot[a_]) "Samlet formue inklusiv bolig for fremadskuende husholdninger."
    vHhFormueHtM[a_,t]$(a0t100[a_] or aTot[a_]) "Samlet formue inklusiv bolig for HtM-husholdninger."
    vHhxR[a_,t]$(a0t100[a_] or aTot[a_]) "Fremadskuende husholdningers formue ekskl. pension og realkreditgæld."
    vHhPensR[a_,t]$(a0t100[a_] or aTot[a_]) "Pensionsformue for fremadskuende husholdninger EFTER SKAT."
    vHhPensHtM[a_,t]$(a0t100[a_] or aTot[a_]) "Pensionsformue for HtM-husholdninger EFTER SKAT."
    vHhPens[a_,t]$(a0t100[a_] or aTot[a_]) "Pensionsformue EFTER SKAT"  
    vFrivaerdiR[a_,t]$(a0t100[a_] or aTot[a_]) "Friværdi (boligværdi fratrukket realkreditgæld) for fremadskuende husholdninger."
    vFrivaerdiHtM[a_,t]$(a0t100[a_] or aTot[a_]) "Friværdi (boligværdi fratrukket realkreditgæld) for HtM-husholdninger."
    vHhIndHtM[a_,t]$(a0t100[a_] or aTot[a_]) "HtM-husholdningers indkomst."
    vHhIndR[a_,t]$(a0t100[a_] or aTot[a_]) "Fremadskuende husholdningers indkomst."
    vHhNetFinR[a_,t]$(a0t100[a_] or aTot[a_]) "Finansiel nettoformue for fremadskuende husholdninger."
    vHhNetFinHtM[a_,t]$(a0t100[a_] or aTot[a_]) "Finansiel nettoformue for HtM-husholdninger."
    vHhNetFin[a_,t]$(a0t100[a_] or aTot[a_]) "Finansiel nettoformue."
    vHhIndMvHtM[a_,t]$(a0t100[a_] or aTot[a_]) "HtM-husholdningers indkomst og lån i friværdi."
    vHhIndMvR[a_,t]$(a0t100[a_] or aTot[a_]) "Fremadskuende husholdningers indkomst og lån i friværdi."
    vHhIndMv[a_,t]$(a0t100[a_] or aTot[a_]) "Husholdningers indkomst og lån i friværdi."
    vCR_NR[a_,t]$(a0t100[a_] or aTot[a_]) "Fremadskuende husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
    vCHtM_NR[a_,t]$(a0t100[a_] or aTot[a_]) "HtM-husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
    vC_NR[a_,t]$(a0t100[a_] or aTot[a_]) "Gns. husholdningers forbrug som defineret i Nationalregnskabet - dvs. ud fra qC[cTot,t]"
    vW[s_,t]$(sTot[s_] or spTot[s_]) "Branche-specifik løn inklusiv lønsumsafgift."
    vHhFormue[a_,t]$((a0t100[a_] and t.val > 2015) or aTot[a_]) "Samlet formue inklusiv bolig."
    vBoligUdgiftR[a_,t]$(t.val > 2015) "Netto udgifter til køb/salg/forbrug af bolig for fremadskuende husholdninger."
    vBoligR[a_,t]$((a18t100[a_] or atot[a_]) and t.val > 2015) "Fremadskuende husholdningernes boligformue."
  ;
  $GROUP G_post_endo 
    nSoegBase[t]$(t.val > 2015) "Sum af jobsøgende og beskæftigede fra udenlandske og danske husholdninger."

    G_post_prices 
    G_post_quantities 
    G_post_values
  ;
  $GROUP G_post_endo G_post_endo$(tx0[t]); # Restrict endo group to tx0[t]

  $GROUP G_post_other
    hVirk[t] "Gennemsnitlig arbejdstid i privat sektor."
    hOff[t] "Gennemsnitlig arbejdstid i offentlig sektor."
    tPensKor[t] "Skattesats på ubeskattet pensionsformue til beregning af vHhFormue."
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_post
    # Arbejdsmarked
    E_vW_spTot[t]$(tx0[t]).. vW[spTot,t] * nL[spTot,t]=E= sum(sp, vW[sp,t] * nL[sp,t]);
    E_vW_sTot[t]$(tx0[t]).. vW[sTot,t] * nL[sTot,t] =E= sum(s, vW[s,t] * nL[s,t]);

    E_qLxUdn[s,t]$(tx0[t]).. qLxUdn[s,t] =E= qL[s,t] / rLUdn[s,t]; # =E= fProd[s,t] * qProd[t] * fW[s,t] * rL2nL[t] * (1-rOpslagOmk[s,t]) * nL[s,t];
    E_pLxUdn[sp,t]$(tx0[t]).. pLxUdn[sp,t] =E= pL[sp,t] * rLUdn[sp,t];

    E_nSoegBase[t]$(tx0[t] and t.val > 2015).. nSoegBase[t] =E= nSoegBaseHh[aTot,t] + nSoegBaseUdl[t];

    # Boliger er ikke en del af private erhvervsinvesteringer
    E_pI_s_spTot[i,t]$(tx0[t] and not sameas[i,'iL']).. pI_s[i,spTot,t] * qI_s[i,spTot,t] =E= vI_s[i,spTot,t];
    E_qI_s_spTot[i,t]$(tx0[t] and not sameas[i,'iL'])..
      qI_s[i,spTot,t] * pI_s[i,spTot,t-1]/fp =E= sum(sp, pI_s[i,sp,t-1]/fp * qI_s[i,sp,t]) - sameas[i,'iB'] * (pI_s[i,'bol',t-1]/fp * qIBolig[t]);
    E_vI_s_spTot[i,t]$(tx0[t] and not sameas[i,'iL']).. vI_s[i,spTot,t] =E= sum(sp, vI_s[i,sp,t]) - sameas[i,'iB'] * vIBolig[t];

    E_vhWVirk[t]$(tx0[t]).. vhWVirk[t] =E= sum(sp, vLoensum[sp,t] + vSelvstLoen[sp,t]) / (hVirk[t] * sum(sp, nL[sp,t]));

    # OBS: I modsætning til den private løn er offentlig løn inkl. lønsumsafgifter
    E_vOffLoen[t]$(tx0[t]).. vOffLoen[t] =E= (1 + tL['off',t]) * vLoensum['off',t] / (hOff[t] * nL['off',t]);

    # Branchevise samlede investeringer
    E_qI_iTot_s[s,t]$(tx0[t]).. qI_s[iTot,s,t] * pI_s[iTot,s,t-1]/fp =E= sum(i, pI_s[i,s,t-1]/fp * qI_s[i,s,t]);
    E_pI_iTot_s[s,t]$(tx0[t]).. pI_s[iTot,s,t] * qI_s[iTot,s,t] =E= vI_s[iTot,s,t];

    # Formuebegreb
    E_vHhFormue[a,t]$(a0t100[a] and tx0[t] and t.val > 2015)..
      vHhFormue[a,t] =E= vHh['NetFin',a,t] + vBolig[a,t] - tPensKor[t] * (vHh['pensx',a,t] + vHh['kap',a,t]);
    E_vHhFormue_tot[t]$(tx0[t])..
      vHhFormue[aTot,t] =E= vHh['NetFin',aTot,t] + vBolig[aTot,t] - tPensKor[t] * (vHh['pensx',aTot,t] + vHh['kap',aTot,t]);
    E_vHhPens[a,t]$(a0t100[a] and tx0[t])..
      vHhPens[a,t] =E= vHh['pens',a,t] - tPensKor[t] * (vHh['pensx',a,t] + vHh['kap',a,t]);
    E_vHhPens_tot[t]$(tx0[t]).. vHhPens[aTot,t] =E= sum(a, vHhPens[a,t] * nPop[a,t]);

    # Fremadskuende husholdninger
    E_vHhFormueR[a,t]$(a0t100[a] and tx0[t])..
      vHhFormueR[a,t] =E= (vHhFormue[a,t]
                           - rHtM * (1- tPensKor[t]) * vHh['pensx',a,t]
                           - rHtM * (1-rRealKred2Bolig[a,t]) * pBolig[t] * qBoligHtM[a,t]) / (1-rHtM);
    E_vHhFormueR_tot[t]$(tx0[t]).. vHhFormueR[aTot,t] =E= sum(a, (1-rHtM) * vHhFormueR[a,t] * nPop[a,t]);
    E_vHhxR[a,t]$(a0t100[a] and tx0[t])..
      vHhxR[a,t] =E= (vHhx[a,t]) / (1-rHtM);
    E_vHhxR_tot[t]$(tx0[t]).. vHhxR[aTot,t] =E= sum(a, (1-rHtM) * vHhxR[a,t] * nPop[a,t]);
    E_vHhPensR[a,t]$(a0t100[a] and tx0[t])..
      vHhPensR[a,t] =E= ((1 - tPensKor[t]) * (vHh['kap',a,t] + ( 1 - rHtM) * vHh['pensx',a,t]) + vHh['alder',a,t]) / (1-rHtM);
    E_vHhPensR_tot[t]$(tx0[t]).. vHhPensR[aTot,t] =E= sum(a, (1-rHtM) * vHhPensR[a,t] * nPop[a,t]);
    E_vFrivaerdiR[a,t]$(a0t100[a] and tx0[t])..
      vFrivaerdiR[a,t] =E= (pBolig[t] * (1-rRealKred2Bolig[a,t]) * qBoligR[a,t]);
    E_vFrivaerdiR_tot[t]$(tx0[t]).. vFrivaerdiR[aTot,t] =E= sum(a, (1-rHtM) * vFrivaerdiR[a,t] * nPop[a,t]);
    E_vHhIndR[a,t]$(a0t100[a] and tx0[t])..
      vHhIndR[a,t] =E= (vHhInd[a,t] - rHtM * vHhIndHtM[a,t]) / (1-rHtM);
    E_vHhIndR_tot[t]$(tx0[t]).. vHhIndR[aTot,t] =E= sum(a, (1-rHtM) * vHhIndR[a,t] * nPop[a,t]);
    E_vHhIndMvR[a,t]$(a0t100[a] and tx0[t])..
      vHhIndMvR[a,t] =E= vHhIndR[a,t] + (rRealKred2Bolig[a,t] * pBolig[t] - rRealKred2Bolig[a-1,t-1] * pBolig[t-1]) 
                                        * qBoligR[a-1,t-1]/fv * fMigration[a,t];
    E_vHhIndMvR_tot[t]$(tx0[t]).. vHhIndMvR[aTot,t] =E= sum(a, (1-rHtM) * vHhIndMvR[a,t] * nPop[a,t]);
    E_vCR_NR[a,t]$(a0t100[a] and tx0[t])..
      vCR_NR[a,t] =E= pC['cikkebol',t] * qCR[a,t] 
                    + pC['cbol',t] * qC['cbol',t] * (qKLejebolig[t-1] * (vCLejebolig[a,t] / vCLejebolig[aTot,t])
                                                     + (qKBolig[t-1]-qKLejebolig[t-1]) * (qBoligR[a,t] / qBolig[aTot,t]) )/qKBolig[t-1];
    E_vCR_NR_tot[t]$(tx0[t]).. vCR_NR[aTot,t] =E= sum(a, (1-rHtM) * vCR_NR[a,t] * nPop[a,t]);
    E_qCR_NR[a,t]$(a0t100[a] and tx0[t])..
      qCR_NR[a,t] =E= vCR_NR[a,t] / pC['ctot',t];
    E_qCR_NR_tot[t]$(tx0[t]).. qCR_NR[aTot,t] =E= vCR_NR[aTot,t] / pC['ctot',t];
    E_vHhNetFinR[a,t]$(a0t100[a] and tx0[t])..
      vHhNetFinR[a,t] =E= vHh['NetFin',a,t] - vHhNetFinHtM[a,t] * rHtM / (1-rHtM);
    E_vHhNetFinR_tot[t]$(tx0[t]).. vHhNetFinR[aTot,t] =E= sum(a,  rHtM * vHhNetFinR[a,t] * nPop[a,t]);

    E_vBoligUdgiftR[a,t]$(tx0[t]).. vBoligUdgift[a,t] =E= rHtM * vBoligUdgiftHtM[a,t] + vBoligUdgiftR[a,t] * (1-rHtM);
    E_vBoligUdgiftR_tot[t]$(tx0[t]).. vBoligUdgift[aTot,t] =E= vBoligUdgiftHtM[aTot,t] + vBoligUdgiftR[aTot,t] + vBoligUdgiftArv[t];

    E_vBoligR[a,t]$(a18t100[a] and tx0[t] and t.val > 2015).. vBoligR[a,t] =E= pBolig[t] * qBoligR[a,t];
    E_vBoligR_tot[t]$(tx0[t] and t.val > 2015).. vBoligR[aTot,t] =E= pBolig[t] * qBoligR[aTot,t];

    # HtM-husholdninger
    E_vHhFormueHtM[a,t]$(a0t100[a] and tx0[t])..
      vHhFormueHtM[a,t] =E=  (1 - tPensKor[t]) * vHh['pensx',a,t] + pBolig[t] * (1-rRealKred2Bolig[a,t]) * qBoligHtM[a,t];
    E_vHhFormueHtM_tot[t]$(tx0[t]).. vHhFormueHtM[aTot,t] =E= sum(a, rHtM * vHhFormueHtM[a,t] * nPop[a,t]);
    E_vHhPensHtM[a,t]$(a0t100[a] and tx0[t])..
      vHhPensHtM[a,t] =E= (1 - tPensKor[t]) * vHh['pensx',a,t];
    E_vHhPensHtM_tot[t]$(tx0[t]).. vHhPensHtM[aTot,t] =E= sum(a, rHtM * vHhPensHtM[a,t] * nPop[a,t]);
    E_vFrivaerdiHtM[a,t]$(a0t100[a] and tx0[t])..
      vFrivaerdiHtM[a,t] =E= (pBolig[t] * (1-rRealKred2Bolig[a,t]) * qBoligHtM[a,t]);
    E_vFrivaerdiHtM_tot[t]$(tx0[t]).. vFrivaerdiHtM[aTot,t] =E= sum(a, rHtM * vFrivaerdiHtM[a,t] * nPop[a,t]);
    E_vHhIndHtM[a,t]$(a0t100[a] and tx0[t])..
      vHhIndHtM[a,t] =E= vHhInd[a,t] - (vPensUdb['Pens',a,t] - vPensIndb['Pens',a,t]) 
                         + vPensUdb['PensX',a,t] - vPensIndb['PensX',a,t] + vtAktie[a,t] - vArvKorrektion[a,t];
    E_vHhIndHtM_tot[t]$(tx0[t]).. vHhIndHtM[aTot,t] =E= sum(a, rHtM * vHhIndHtM[a,t] * nPop[a,t]);
    E_vHhIndMvHtM[a,t]$(a0t100[a] and tx0[t])..
      vHhIndMvHtM[a,t] =E= vHhIndR[a,t] + (rRealKred2Bolig[a,t] * pBolig[t] - rRealKred2Bolig[a-1,t-1] * pBolig[t-1]) 
                                        * qBoligHtM[a-1,t-1]/fv * fMigration[a,t];
    E_vHhIndMvHtM_tot[t]$(tx0[t]).. vHhIndMvHtM[aTot,t] =E= sum(a, rHtM * vHhIndMvHtM[a,t] * nPop[a,t]);
    E_vCHtM_NR[a,t]$(a0t100[a] and tx0[t])..
      vCHtM_NR[a,t] =E= pC['cikkebol',t] * qCHtM[a,t] 
                      + pC['cbol',t] * qC['cbol',t] * (qKLejebolig[t-1] * (vCLejebolig[a,t] / vCLejebolig[aTot,t])
                                                       + (qKBolig[t-1]-qKLejebolig[t-1]) * (qBoligHtM[a,t] / qBolig[aTot,t]) )/qKBolig[t-1];
    E_vCHtM_NR_tot[t]$(tx0[t]).. vCHtM_NR[aTot,t] =E= sum(a, rHtM * vCHtM_NR[a,t] * nPop[a,t]);
    E_qCHtM_NR[a,t]$(a0t100[a] and tx0[t])..
      qCHtM_NR[a,t] =E= vCHtM_NR[a,t] / pC['ctot',t];
    E_qCHtM_NR_tot[t]$(tx0[t]).. qCHtM_NR[aTot,t] =E= vCHtM_NR[aTot,t] / pC['ctot',t];
    E_vHhNetFinHtM[a,t]$(a0t100[a] and tx0[t])..
      vHhNetFinHtM[a,t] =E= vHh['PensX',a,t] - pBolig[t] * rRealKred2Bolig[a,t] * qBoligHtM[a,t];
    E_vHhNetFinHtM_tot[t]$(tx0[t]).. vHhNetFinHtM[aTot,t] =E= sum(a,  rHtM * vHhNetFinHtM[a,t] * nPop[a,t]);

    E_vC_NR[a,t]$(a0t100[a] and tx0[t])..
      vC_NR[a,t] =E= (1-rHtM) * vCR_NR[a,t] + rHtM * vCHtM_NR[a,t];
    E_vC_NR_tot[t]$(tx0[t]).. vC_NR[aTot,t] =E= sum(a, vC_NR[a,t] * nPop[a,t]);
    E_qC_NR[a,t]$(a0t100[a] and tx0[t])..
      qC_NR[a,t] =E= vC_NR[a,t] / pC['cTot',t];
    E_qC_NR_tot[t]$(tx0[t]).. qC_NR[aTot,t] =E= vC_NR[aTot,t] / pC['cTot',t];
    E_vHhIndMv[a,t]$(a0t100[a] and tx0[t])..
      vHhIndMv[a,t] =E= vHhInd[a,t] + (rRealKred2Bolig[a,t] * pBolig[t] - rRealKred2Bolig[a-1,t-1] * pBolig[t-1]) 
                                      * qBolig[a-1,t-1]/fv * fMigration[a,t];
    E_vHhIndMv_tot[t]$(tx0[t]).. vHhIndMv[aTot,t] =E= sum(a, vHhIndMv[a,t] * nPop[a,t]);

  $ENDBLOCK
$ENDIF