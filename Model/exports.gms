# ======================================================================================================================
# Exports
# - Armington demand for exports of both domestically produced and imported goods
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_exports_prices
    empty_group_dummy[t]
  ;
  $GROUP G_exports_quantities
    qX[x_,t]$(x[x_] and t.val > 2015) "Eksport, Kilde: ADAM[fE] og ADAM[fE<i>]"
    qXy[x,t]$(not sameas['xEne',x]) "Direkte eksport."
    qXm[x,t]$(d1Xm[x,t]) "Import til reeksport."
    qCTurist[c,t]$(d1CTurist[c,t]) "Turisters forbrug i Danmark (imputeret)"
    qXMarked[x,t] "Eksportmarkedsstørrelse, Kilde: ADAM[fEe<i>]"
    qXSkala[x,t] "Endogen udbudseffekt på eksport."
    qXTraek[x,t] "Eksporttræk fra eksportmarkederne."
  ;
  $GROUP G_exports_values
    empty_group_dummy
  ;
  $GROUP G_exports_endo
    G_exports_quantities, -qXMarked
    G_exports_values
    rpXUdl2pXy[x,t] "Relative eksportpriser - dvs. eksportkonkurrerende priser over eksportpriser."
    rpXy2pXUdl[x,t] "Relative eksportpriser - dvs. eksportpriser over eksportkonkurrerende priser."
    uXy[x,t]$(sameas['xEne',x]) "Skalaparameter for direkte eksport."
    uCturisme[c,t] "Skalaparameter til fordeling af udenlandske turisters forbrug i Danmark på forbrugsgrupper."
    rpM2pXm[x,t] "Relativ pris på import vs. export fordelt på eksportgrupper."
  ;
  $GROUP G_exports_endo G_exports_endo$(tx0[t]); # Restrict endo group to tx0[t]

  $GROUP G_exports_exogenous_forecast
    qXy$(sameas['xEne',x])
  ;
  $GROUP G_exports_other
    rXTraeghed        "Træghed i på gennemslag fra eksportmarkedsvækst."
    upXyTraeghed      "Træghed i pris-effekt på eksportefterspørgsel."
    rXSkalaTraeghed   "Træghed i skalaeffekt på eksportefterspørgsel."
    eXUdl[x] "Eksportpriselasticitet."
    cpXyTraeghed[x,t] "Parameter som kalibreres for at fjerne træghed i pris-effekt på eksportefterspørgsel i grundforløb."
  ;
  $GROUP G_exports_ARIMA_forecast
    qXMarked
    uXTur[t] "Skalaparameter for eksport af turisme."
    uXy
    uXm[x,t] "Skalaparameter for import til reeksport."
    fuCturisme[t] "Korrektionsfaktor for skalaparametrene til fordeling af udenlandske turisters forbrug i Danmark på forbrugsgrupper."
    uCturisme0[c,t] "Skalaparameter til fordeling af udenlandske turisters forbrug i Danmark på forbrugsgrupper før endelig skalering."
  ;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_exports
    # We model domestically produced exports and imports-to-exports separately.
    # There is no substitution between the two.
    E_qXy[x,t]$(tx0[t] and d1Xy[x,t])..
      qXy[x,t] =E= uXy[x,t] * qXTraek[x,t] * qXSkala[x,t] * (rpXy2pXUdl[x,t])**(-eXUdl[x]);

    E_qXm[x,t]$(tx0[t] and d1Xm[x,t])..
      qXm[x,t] =E= uXm[x,t] * qXMarked[x,t] * rpM2pXm[x,t]**eXUdl[x];

    # Tourist consumption is produced in the same way as domestic consumption with substitution between domestic production and imports
    E_qX_xTur[x,t]$(tx0[t] and sameas[x,'xTur'])..
      qX[x,t] =E= uXTur[t] * qXTraek[x,t] * qXSkala[x,t] * (rpXy2pXUdl[x,t])**(-eXUdl[x]);

    # Domestic production and imports to exports are aggregated in a Laspeyres index 
    E_qX[x,t]$(tx0[t] and d1X[x,t] and not sameas[x,'xTur'] and t.val > 2015)..
      qX[x,t] * pX[x,t-1]/fp =E= qXy[x,t] * pXy[x,t-1]/fp + qXm[x,t] * pXm[x,t-1]/fp;

    # Rigidity in relative price effect on foreign demand
    E_rpXy2pXUdl[x,t]$(tx0E[t] and d1Xy[x,t])..
      rpXy2pXUdl[x,t] =E= pXy[x,t] / pXUdl[x,t]
                        - upXyTraeghed * rpXy2pXUdl[x,t] * (rpXy2pXUdl[x,t] / rpXy2pXUdl[x,t-1] - cpXyTraeghed[x,t]) * rpXy2pXUdl[x,t] / rpXy2pXUdl[x,t-1]
                        + upXyTraeghed * rpXy2pXUdl[x,t+1] * (rpXy2pXUdl[x,t+1] / rpXy2pXUdl[x,t] - cpXyTraeghed[x,t+1]) * (rpXy2pXUdl[x,t+1] / rpXy2pXUdl[x,t])
                        * qXy[x,t+1]*fq / qXy[x,t] * pXUdl[x,t+1]*fp / pXUdl[x,t]
                        / (1 + rOmv['UdlAktier',t+1] + rRente['UdlAktier',t+1]);

    E_rpXy2pXUdl_tEnd[x,t]$(tEnd[t] and d1Xy[x,t])..
      rpXy2pXUdl[x,t] =E= pXy[x,t] / pXUdl[x,t];

    E_rpXy2pXUdl_xTur[x,t]$(tx0E[t] and sameas[x,'xTur'])..
      rpXy2pXUdl[x,t] =E= pX[x,t] / pXUdl[x,t]
                        - upXyTraeghed * rpXy2pXUdl[x,t] * (rpXy2pXUdl[x,t] / rpXy2pXUdl[x,t-1] - cpXyTraeghed[x,t]) * rpXy2pXUdl[x,t] / rpXy2pXUdl[x,t-1]
                        + upXyTraeghed * rpXy2pXUdl[x,t+1] * (rpXy2pXUdl[x,t+1] / rpXy2pXUdl[x,t] - cpXyTraeghed[x,t+1]) * (rpXy2pXUdl[x,t+1] / rpXy2pXUdl[x,t])
                        * qX[x,t+1]*fq / qX[x,t] * pXUdl[x,t+1]*fp / pXUdl[x,t]
                        / (1 + rOmv['UdlAktier',t+1] + rRente['UdlAktier',t+1]);

    E_rpXy2pXUdl_xTur_tEnd[x,t]$(tEnd[t] and sameas[x,'xTur'])..
      rpXy2pXUdl[x,t] =E= pX[x,t] / pXUdl[x,t];

    # The price ratio for imports-to-exports only varies due to tariffs
    E_rpM2pXm[x,t]$(tx0[t] and d1Xm[x,t])..
      rpM2pXm[x,t] =E= sum(s$(d1IOm[x,s,t]), uIOXm[x,s,t] * pM[s,t]) / pXm[x,t];

    # Rigidity in spill over from increased foreign activity (qXMarked) to increased demand for domestically produced exports
    E_qXTraek[x,t]$(tx0[t])..
      qXTraek[x,t] =E= qXMarked[x,t]**(1-rXTraeghed) * (fq * qXTraek[x,t-1]/fq)**rXTraeghed;

    # Scale effect: increased supply in the long run increases demand for exports
    E_qXSkala[x,t]$(tx0[t] and d1X[x,t])..
      qXSkala[x,t] =E= sqL[spTot,t]**(1-rXSkalaTraeghed) * (fq * qXSkala[x,t-1]/fq)**rXSkalaTraeghed;

    # Tourist consumption in Denmark is split into different consumption groups. We currently do not model any substitution.
    E_qCTurist[c,t]$(tx0[t] and d1CTurist[c,t])..
      qCTurist[c,t] =E= uCturisme[c,t] * qX['xTur',t];

    E_uCturisme[c,t]$(tx0[t] and d1CTurist[c,t])..
      uCturisme[c,t] =E= fuCturisme[t] * uCturisme0[c,t] / sum(cc, uCturisme0[cc,t]);
  $ENDBLOCK
$ENDIF