# ======================================================================================================================
# Fiscal sustainability module (HBI)
# - Net present values of government flows and the fiscal sustainability indicator (HBI)
# - Flow variables are defined in government, GovRevenues, and GovExpenses
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# ======================================================================================================================
$IF %stage% == "variables":

  # Variables for which present values are computed
  $GROUP G_HBI_nv_variables
    vPrimSaldo[t]
    vOffPrimInd
    vtDirekte
    vtKilde
    vtDoedsbo['tot']
    vtKommune['tot']
    vtBund['tot']
    vtEjd['tot']
    vtAktie
    vtVirksomhed['tot']
    vtKildeRest
    vtHhVaegt['tot']
    vtHhAM['tot']
    vtPersRest['tot']
    vtSelskab['tot']
    vtPAL
    vtIndirekte
    vtAfg['dTot','tot']
    vtMoms['dTot','tot']
    vtReg['dTot','tot']
    vtY['tot']
    vtGrund['tot']
    vtVirkVaegt['tot']
    vtAUB['tot']
    vtVirkAM['tot']
    vtYRest['tot']
    vOffIndRest
    vBidrag['tot']
    vBidragObl
    vBidragAK
    vBidragEL
    vBidragFri
    vBidragTjmp
    vtArv['tot']
    vOffAfskr['iTot']
    vJordrente
    vtKulbrinte
    vJordrenteRest
    vOffVirk
    vtKirke['tot']
    vOffFraUdlKap
    vOffFraUdlEU
    vOffFraUdlRest
    vOffFraVirk
    vOffFraHh
    vOffPrimUd
    vG['gTot']
    vGInd
    vGKol
    vOffInv
    vOvf['tot']
    vOvf['pension']
    vOvf['fortid']
    vOvf['efterl']
    vOvf['tjmand']
    vOvf['barsel']
    vOvf['syge']
    vOvf['uddsu']
    vOvf['boernyd']
    vOvf['boligst']
    vOvf['boligyd']
    vOffSub
    vSub['dTot','tot']
    vSubY
    vOffUdRest
    vOffOmv[t]
    vSaldo[t]
    vBNP
    vOffUdbytte[t]
    vOffInd[t]
    vOffUd[t]
    vRenteMarginal[t]
  ;

  $GROUP G_HBI_nv
    $LOOP G_HBI_nv_variables:
      n{name}{sets} "Present value of {name}"
    $ENDLOOP
  ;

  $GROUP G_HBI_variables
    rHBI[t] "Holdbarhedsindikator før korrektion ved beregningsmæssig skat til lukning, korrigeret HBI."
    rHBIxMerafkast[t] "Holdbarhedsindikator eksklusiv merafkast."
  ;

$ENDIF

# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":

  $BLOCK B_HBI G_HBI_endo $(tHBI.val <= t.val)
  # ----------------------------------------------------------------------------------------------------------------------
  # Holdbarhedsindikator
  # ----------------------------------------------------------------------------------------------------------------------
    $(t.val < tEnd.val)..
      rHBI[t] =E= (nvPrimSaldo[t] + nvOffOmv[t] - nvRenteMarginal[t] + vOff13Net[t-1]/fv * (1+mrOffRente[t+1])) / nvBNP[t];

    $(t.val < tEnd.val).. rHBIxMerafkast[t] =E= (nvPrimSaldo[t+1]*fv / (1+mrOffRente[t+1]) + vOff13Net[t]) / nvBNP[t];

    # Nutidsværdier til beregning og dekomponering af HBI.
    # Som terminalbetingelse anvendes gennemsnit af de 5 sidste år.
    $LOOP G_HBI_nv_variables:
      $({conditions} and t.val < tEnd.val)..
        n{name}{sets} =E= {name}{sets} + n{name}{sets}{$}[<t>t+1] * fv / (1+mrOffRente[t+1]);
      n{name}&_tEnd{sets}$({conditions} and tEnd[t])..
        n{name}{sets} =E= {name}{sets}
          + @mean(tt$[t.val-5 < tt.val and tt.val <= t.val], {name}{sets}{$}[<t>tt]) / (1 - fv / (1+mrOffRente[t]));
    $ENDLOOP

    $(t.val <= tEnd.val)..
      vRenteMarginal[t] =E= mrOffRente[t] * (vOff13Aktx[t-1]/fv + vOff13Aktier[t-1]/fv) - vOffRenteInd[t]
                             - (mrOffRente[t] * vOff13pas[t-1]/fv - vOffRenteUd[t]);
  $ENDBLOCK

  $GROUP+ G_Endo G_HBI_endo;

  Model M_HBI /
    B_HBI
  /;
  model M_base / M_HBI /;

$ENDIF

$IF %stage% == "exogenous_values":
# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  parameter HBI_lukning_profil[t];
  HBI_lukning_profil[t]$(%HBI_lukning_start% < t.val and t.val < %HBI_lukning_slut%)
    = 1-1/(1+((%HBI_lukning_slut%-%HBI_lukning_start%)/(t.val - %HBI_lukning_start%) - 1)**(-2));
  HBI_lukning_profil[t]$(t.val >= %HBI_lukning_slut%) = 1;
$ENDIF

# ======================================================================================================================
# Static calibration for new data years
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP+ G_static_calibration_newdata G_HBI_endo;
$ENDIF

# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_HBI_deep
    G_HBI_endo
    #  vtLukning[a_,t]$(aTot[a_] and t.val >= %HBI_lukning_start%) # E_vtLukning_aTot_deep, E_vtLukning_aTot_tEnd_deep
    #  rGLukning[t]$(t.val >= %HBI_lukning_start%) # E_rGLukning, E_vtLukning_aTot_tEnd
  ;
  $GROUP G_HBI_deep G_HBI_deep$(tx0[t]);
  # $BLOCK B_HBI_deep
  #    E_vtLukning_aTot_tEnd_deep[t]$(tEnd[t]).. vOffNet[t] / vBNP[t] =E= vOffNet[t-1] / vBNP[t-1];
  #    E_vtLukning_aTot_deep[t]$(tx0E[t] and t.val >= %HBI_lukning_start%).. tLukning[t] =E= HBI_lukning_profil[t] * tLukning[tEnd];
  #    #  E_rGLukning[t]$(tx0E[t] and t.val >= 2050).. rGLukning[t] =E= HBI_lukning_profil[t] * rGLukning[tEnd];
  # $ENDBLOCK
  MODEL M_HBI_deep /
    M_HBI
    # B_HBI_deep
  /;
  model M_deep_dynamic_calibration / M_HBI_deep /;
  $GROUP+ G_deep_dynamic_calibration G_HBI_deep;
$ENDIF

# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
  model M_dynamic_calibration_newdata / M_HBI /;
  $GROUP+ G_dynamic_calibration_newdata G_HBI_endo;
$ENDIF
