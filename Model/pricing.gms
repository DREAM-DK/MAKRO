# ======================================================================================================================
# Pricing
# - Price rigidities, markups, and foreign prices
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_pricing_endo
    pY[s_,t]$(sp[s_]) "Deflator for indenlandsk produktion, Kilde: ADAM[pX] eller ADAM[pX<i>]"
    # pY[off] beregnes i production_public
    pXUdl[x_,t]$(xTot[x_]) "Eksportkonkurrerende udenlandsk pris, Kilde: ADAM[pee<i>]"
    pOlie[t] "Oliepris i DKK, Kilde: ADAM[pee3r]."

    rMarkup[s_,t]$(sp[s_] or spTot[s_]) "Markup."
    srMarkup[s_,t]$(soe[s_]) "Strukturel mark-up."
    dpYTraeghed[sp,t] "Hjælpevariabel til beregning af effekt fra omstillingsomkostninger på markup."
    rpYTraeghed[sp,t] "Hjælpevariabel til beregning af effekt fra omstillingsomkostninger på markup."
    rYfixed[sp,t] "Andelsparameter for fast del af pY."
  ;
  $GROUP G_pricing_endo G_pricing_endo$(tx0[t]); # Restrict endo group to tx0[t]

  $GROUP G_pricing_exogenous_forecast
    rEffValKurs[t] "Effektiv valutakurs"
    pYfixed[sp,t] "Faste omkostninger, som ikke indgår i prisdannelse."
    rYfixed[sp,t] "Andelsparameter for fast del af pY."
  ;
  $GROUP G_pricing_forecast_as_zero
    jpY_bol[t] "j-led."
    jrMarkup[s_,t] "J-led."
    jrpYTraeghed[sp,t] "J-led."
  ;
  $GROUP G_pricing_ARIMA_forecast
    srMarkup[sp,t]
    pY[bol,t]
    upYUdv[t] "Skalaparameter for eksogen pris på udvinding."
  ;
  $GROUP G_pricing_constants
    upYTraeghed[sp] "Parameter for Rotemberg omkostning."
  ;
  $GROUP G_pricing_fixed_forecast
    eY[sp,t] "Substitutionselasticitet mellem intermediate goods og final goods i produktionen."
    rDollarKurs[t] "Dollarkursen, DKK/Dollar, Kilde: ADAM[ewus]"
    rEuroKurs[t] "Eurokursen, DKK/Euro, Kilde: ADAM[eweu]."
    pOlieBrent[t] "Prisnotering på råolie, Brent (dollar/tønde), Kilde: ADAM[boil]"
    pM[s_,t]$(m[s_]) "Importdeflator fordelt på importgrupper, Kilde: ADAM[pM] eller ADAM[pM<i>]"
  ;

  set sMarkup[s_] "Brancher som fremskrives med en eksogen strukturel markup forskellig fra 0" /tje, fre, byg, soe/;
  set sZeroMarkup[s_] "Brancher som fremskrives med 0 strukturel markup" /lan, ene/;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
# ----------------------------------------------------------------------------------------------------------------------
# Final goods pricing
# ----------------------------------------------------------------------------------------------------------------------
  $BLOCK B_pricing_static$(tx0[t])
    E_rMarkup[sp,t].. pY[sp,t] =E= (1+rMarkup[sp,t]) * (pY0[sp,t] - pYfixed[sp,t]);

    # Fixed ratio of pY0 with no markup
    E_rYfixed[sp,t].. pYfixed[sp,t] =E= rYfixed[sp,t] * pY0[sp,t];

    # Extraction sector prices (mostly oil and gas) follows import prices except for the small share that is gravel extraction
    # Marginal costs in gravel extraction are assumed to follow those of manufacturing
    E_pY_udv[t]..
      pY['udv',t] =E= upYUdv[t] * (
                        (1 - qGrus[t] / qY['udv',t]) * pM['udv',t]
                        + qGrus[t] / qY['udv',t] * pY0['fre',t] / pY0['fre',tEnd] * pY0['udv',tEnd]
                      );

    # Shipping industry chooses their markup to keep the relative export price constant
    E_srMarkup_soe[t]..
      pXy['xSoe',t] =E= rpXy2pXUdl['xSoe',t] * pXUdl['xSoe',t];

    # Synthetic housing sector rental price follows moving average of consumer price index
    E_pY_bol[t]..
      pY['bol',t] =E= (pY['bol',t-1]/fp * (1 + rpCInflSnit[t]) + jpY_bol[t]) * (1 + jrMarkup['bol',t]);

    E_pXUdl_tot[t].. pXUdl[xTot,t] * qX[xTot,t] =E= sum(x, pXUdl[x,t] * qX[x,t]);

    E_pOlie[t].. pOlie[t] =E= pOlieBrent[t] * rDollarKurs[t] / (pOlieBrent[tBase] * rDollarKurs[tBase]);

    # Aggregate markup
    E_rMarkup_spTot[t].. 1+rMarkup[spTot,t] =E= vY[spTot,t] / sum(sp, pY0[sp,t] * qY[sp,t]);
  $ENDBLOCK

  $BLOCK B_pricing_forwardlooking$(tx0[t])
    # Each sector set prices as a structural markup over marginal costs in the long run
    # while smoothing the rate of change due to adjustment costs
    E_pY[sp,t]$(tx0E[t] and not udv[sp] and not bol[sp])..
      rMarkup[sp,t] =E= srMarkup[sp,t] - dpYTraeghed[sp,t]              
                      + fVirkDisk[sp,t+1] * 2 * dpYTraeghed[sp,t+1] * qY[sp,t+1]*fq/qY[sp,t] * pY0[sp,t+1]*fp/pY0[sp,t]
                      + jrMarkup[sp,t];

    E_pY_tEnd[sp,t]$(tEnd[t] and not udv[sp] and not bol[sp])..
      rMarkup[sp,t] =E= srMarkup[sp,t] + jrMarkup[sp,t];

    E_rpYTraeghed[sp,t]..
      rpYTraeghed[sp,t] =E= pY[sp,t]/pY[sp,t-1] / (pY[sp,t-1]/pY[sp,t-2]) + jrpYTraeghed[sp,t];

    E_dpYTraeghed[sp,t]..
      dpYTraeghed[sp,t] =E= upYTraeghed[sp] * (rpYTraeghed[sp,t] - 1) * rpYTraeghed[sp,t];
  $ENDBLOCK

  MODEL M_pricing /
    B_pricing_static
    B_pricing_forwardlooking
  /;

  # Equations that do not need to be solved together with the full model and can instead be solved afterwards.   
  MODEL M_pricing_post /
    #  E_rMarkup 
    E_rMarkup_spTot
  /;

  # Endogenous variables that are solved for only after the main model.
  # Note that these may not appear anywhere in the main model (this results in a model not square error).
  $GROUP G_pricing_post
    rMarkup[s_,t]$(spTot[s_]) "Markup."
  ;
  $GROUP G_pricing_post G_pricing_post$(tx0[t]);

  $GROUP G_pricing_static
    G_pricing_endo
    -pY$(tx0[t] and sp[s_] and not bol[s_] and not udv[s_]) # Fastlæg eksogent gode bud pY
    -srMarkup$(tx0[t] and soe[s_]), pY$(tx0[t] and soe[s_])
    -dpYTraeghed
  ;

$ENDIF
  # $GROUP G_pricing_static G_pricing_static$(tx0[t]);


$IF %stage% == "exogenous_values":
# =============================================================================================½=========================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_pricing_makrobk
    pY$(s[s_]), pM, pOlieBrent, rDollarKurs, rEuroKurs, rEffValKurs
    pXy # pXUdl baseres på denne
  ;
  @load(G_pricing_makrobk, "..\Data\makrobk\makrobk.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_pricing_data  
    G_pricing_makrobk
    pXUdl$(x[x_])
  ;

  # Eksportkonkurrerende priser
  # I mangel på udenlanske prisindeks vægtet på produktniveau efter dansk eksport, ser vi foreløbigt bort fra eksplicitte priseffekter i data (de fanges dog i uXy)
  pXUdl.l[x,t] = pXy.l[x,t];

  rpXy2pXUdl.l[x,t]$(pXUdl.l[x,t] <> 0) = pXy.l[x,t] / pXUdl.l[x,t];

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  # Sættes for at matche SVARer mv.
  upYTraeghed.l[sp]$(sMarkup[sp]) = 4.301253;
  upYTraeghed.l[sp]$(sZeroMarkup[sp]) = 0;
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_pricing_static_calibration
    G_pricing_endo

    -pY[sZeroMarkup,t], pYfixed[sZeroMarkup,t]
    -pY[sMarkup,t], srMarkup[sMarkup,t]
    -pY[udv,t], upYUdv
    -pY[bol,t], jpY_bol
    -pY[soe,t], rpXy2pXUdl[xSoe,t]
    -pY[off,t], srMarkup[off,t]
  ;
  $GROUP G_pricing_static_calibration
    G_pricing_static_calibration$(tx0[t])
  ;

  $BLOCK B_pricing_static_calibration$(tx0[t])
    # E_pY using static expectations in the forward looking rigidity 
    E_srMarkup[sp,t]$(not (bol[sp] or udv[sp]))..
      rMarkup[sp,t] =E= srMarkup[sp,t];
  $ENDBLOCK
  MODEL M_pricing_static_calibration /
    M_pricing
    B_pricing_static_calibration
    - E_pY - E_pY_tEnd # E_srMarkup 
  /;

  $GROUP G_pricing_static_calibration_newdata
    G_pricing_static_calibration
   ;
  MODEL M_pricing_static_calibration_newdata /
    M_pricing_static_calibration
  /;
$ENDIF

# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_pricing_deep
    G_pricing_endo
    -pY[sMarkup,t1]$(not soe[sMarkup]), srMarkup[sMarkup,t1]$(not soe[sMarkup])
    -pY[sZeroMarkup,t1], pYfixed[sZeroMarkup,t1]
    pYfixed[sZeroMarkup,tx1]
    -srMarkup[soe,tx1], pXUdl[xSoe,tx1] # Ved stød er markuppen i søtransport endogen og prisen givet af udlandet. Her sætter vi en fast markup og antager at udlandet har samme omkostningsstruktur.
    -pY[udv,t1], upYUdv[t1]
    -pY[bol,t1], jpY_bol[t1]

    pOlieBrent[tx1]

    pXUdl[x,tx1]$(not xSoe[x]) # E_pXUdl_xTje, E_pXUdl_forecast
  ;
  $GROUP G_pricing_deep G_pricing_deep$(tx0[t]);

  $BLOCK B_pricing_deep
    # Forventet pris-stigning på begrænsede resourcer bør svarer til renten (arbitrage-betingelse)
    # Obligations-rente bruges foreløbigt (sammen med fast dollar-kurs).
    E_pOlieBrent_forecast[t]$(tx0E[t])..
      pOlieBrent[t] =E= pOlieBrent[t+1]*fp / (1 + rRente['obl',t+1]);

    E_pXUdl_xTje[t]$(tx1[t]).. pXUdl["xTje",t] =E= pXUdl["xTje",t1]; # Vækrate for udenlandske eksportkonkurrerende priser sættes lig raten for inflationskorrektion (gp=fp-1)
    E_pXUdl_forecast[x,t]$(tx1[t] and not xSoe[x] and not xTje[x])..
      pXUdl[x,t] / pXUdl["xTje",t] =E= pXy[x,t] / pXy["xTje",t]; # Relative forskydninger i pXUdl antages af følge forskydningerne i pXy

    E_pYfixed[sp,t]$(tx1[t] and sZeroMarkup[sp]).. rYfixed[sp,t] =E= rYfixed[sp,t1];
  $ENDBLOCK

  MODEL M_pricing_deep /
    M_pricing - M_pricing_post
    B_pricing_deep
  /;
$ENDIF

# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
  $GROUP G_pricing_dynamic_calibration
    G_pricing_endo
    -pY[sMarkup,t1]$(not soe[sMarkup]), srMarkup[sMarkup,t1]$(not soe[sMarkup])
    -pY[sZeroMarkup,t1], pYfixed[sZeroMarkup,t1]
    pYfixed[sZeroMarkup,tx1] # E_pYfixed
    -pY[udv,t1], upYUdv[t1]
    -pY[bol,t1], jpY_bol[t1]

    pOlieBrent[tx1] # E_pOlieBrent_forecast
    rDollarKurs[tx1] # E_rDollarKurs

    pXUdl[x,tx1]$(not xSoe[x]) # E_pXUdl_xTje, E_pXUdl_forecast
    pM[m,tx1] # E_pM_forecast
    pXUdl[xSoe,tx1] # E_pXUdl_xSoe

    # Vi ser bort fra pristræghed i foreløbige dataår
    jrpYTraeghed[sp,t1] # E_jrpYTraeghed_t1
  ;
  $BLOCK B_pricing_dynamic_calibration
    E_pYfixed[sp,t]$(tx1[t] and sZeroMarkup[sp]).. @gradual_return_to_baseline(rYfixed);

    E_rDollarKurs[t]$(tx1[t]).. rDollarKurs[t] =E= rDollarKurs[t1];

    E_pOlieBrent_forecast[t]$(tx0E[t])..
      pOlieBrent[t] =E= pOlieBrent[t+1]*fp / (1 + rRente['obl',t+1]);

    # Ændringer i eksportkonkurerende udover ændring i pXUdl[xTje] aftrappes gradvist
    E_pXUdl_xTje[t]$(tx1[t]).. pXUdl["xTje",t] =E= pXUdl["xTje",t1]; # Vækrate for udenlandske eksportkonkurrerende priser sættes lig raten for inflationskorrektion (gp=fp-1)
    # E_pXUdl_forecast[x,t]$(tx1[t] and not xSoe[x] and not xTje[x])..
    #   pXUdl[x,t] / pXUdl["xTje",t] =E= aftrapprofil[t] * (pXUdl[x,t1] / pXUdl["xTje",t1] - pXUdl_baseline[x,t1] / pXUdl_baseline["xTje",t1])
    #                                  + pXUdl_baseline[x,t] / pXUdl_baseline["xTje",t];
    E_pXUdl_forecast[x,t]$(tx1[t] and not xSoe[x] and not xTje[x])..
      pXUdl[x,t] / pXUdl["xTje",t] =E= pXy[x,t] / pXy["xTje",t]; # Relative forskydninger i pXUdl antages af følge forskydningerne i pXy

    # Ændringer i importpriser for fremstilling og tjenester antages at være permanente niveauændringer
    E_pM_tje_fre[s,t]$(tx1[t] and (tje[s] or fre[s]))..
      pM[s,t] / pM[s,t1] =E= pM_baseline[s,t] / pM_baseline[s,t1];

    # Øvrige importpriser (samt pXUdl[xSoe]) antages at følge en gradvis tilpasning til ændringer i importpriser for tjenester
    E_pM_forecast[s,t]$(tx1[t] and not (tje[s] or fre[s]) and m[s])..
      pM[s,t] =E= aftrapprofil[t] * (pM[s,t1] - pM_baseline[s,t1] * pM['tje',t1] / pM_baseline['tje',t1])
                + pM_baseline[s,t] * pM['tje',t1] / pM_baseline['tje',t1];

    E_pXUdl_xSoe[x,t]$(tx1[t] and xSoe[x])..
      pXUdl[x,t] =E= aftrapprofil[t] * (pXUdl[x,t1] - pXUdl_baseline[x,t1] * pM['tje',t1] / pM_baseline['tje',t1])
                   + pXUdl_baseline[x,t] * pM['tje',t1] / pM_baseline['tje',t1];

    E_jrpYTraeghed_t1[sp,t]$(t1[t]).. rpYTraeghed[sp,t] =E= 1;
  $ENDBLOCK
  MODEL M_pricing_dynamic_calibration /
    M_pricing
    B_pricing_dynamic_calibration
  /;
$ENDIF
