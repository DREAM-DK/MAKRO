# ======================================================================================================================
# Pricing
# - Price rigidities, markups, and foreign prices
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_pricing_prices # Group that is growth and inflation adjusted
    pY[s_,t]$(s[s_]) "Deflator for indenlandsk produktion, Kilde: ADAM[pX] eller ADAM[pX<i>]"
    pXUdl[x_,t]$(x[x_]) "Eksportkonkurrerende udenlandsk pris, Kilde: ADAM[pee<i>]"
    pM[s_,t]$(s[s_] and d1IOm[dTot,s_,t]) "Importdeflator fordelt på importgrupper, Kilde: ADAM[pM] eller ADAM[pM<i>]"
    pUdl[t] "Indeks for udenlandsk prisniveau som andre udenlandske priser følger."
    pOlie[t] "Oliepris."
  ;
  $GROUP G_pricing_quantities # Group that is growth adjusted
    empty_group_dummy[t]
  ; 
  $GROUP G_pricing_values # Group that is adjusted for inflation
    empty_group_dummy[t]
  ; 

  $GROUP G_pricing_endo
    G_pricing_prices, -pUdl, -pOlie
    jrMarkup[s_,t] "Mark-up udover den fra mikrofundamentet, som kommer fra rMerPris - 0 i historiske år."
    rMarkup[s_,t] "Markup."
    srMarkup[s_,t]$(sameas[s_,'udv'] or sameas[s_,'soe']) "Strukturel mark-up."
  ;
  $GROUP G_pricing_endo G_pricing_endo$(tx0[t]); # Restrict endo group to tx0[t]

  $GROUP G_pricing_exogenous_forecast
    pOlie
    pUdl
    jpY_bol[t] "j-led."
  ;
  $GROUP G_pricing_ARIMA_forecast
    pY$(sameas[s_,'bol'])
    srMarkup
    upYUdv[t] "Skalaparameter for eksogen pris på udvinding."
    pXUdl[x,t]
    #  pM[s_,t]$(s[s_] and not sameas[s_,'tje'])
  ;
  $GROUP G_pricing_other
    upYTraeghed[sp] "Parameter for Rotemberg omkostning."
    eY[sp,t] "Substitutionselasticitet mellem intermediate goods og final goods i produktionen."
    epM2pOlie[s] "Oliepris-elasticitet for importpriser."
    epXUdl2pOlie[x] "Oliepris-elasticitet for udenlandske eksportkonkurrerende priser."
    upXSoe[t] ""
    upXUdl[x,t] "Skalaparameter for udenlandske eksportkonkurrerende priser."
    upM[s,t] "Skalaparameter for import-priser."
  ;

  set sMarkup[sp] "Brancher som fremskrives med en eksogen strukturel markup forskellig fra 0" /tje, fre/;
  set sZeroMarkup[sp] "Brancher som fremskrives med 0 strukturel markup" /lan, byg, ene, soe/;
$ENDIF


# ======================================================================================================================
# Equations
# ======================================================================================================================
$IF %stage% == "equations":
# ----------------------------------------------------------------------------------------------------------------------
# Final goods pricing
# ----------------------------------------------------------------------------------------------------------------------
  $BLOCK B_pricing
    E_rMarkup[s,t]$(tx0[t]).. rMarkup[s,t] =E= pY[s,t] / (pKLBR[s,t] + vtNetYAfgRest[s,t] / qY[s,t]) - 1;

    # The largest sectors set prices as a markup over marginal costs in the long run
    # while smoothing the rate of change (due to a type of second order Rotemberg cost) 
    E_pY_sMarkup[sp,t]$(tx0E[t] and sMarkup[sp])..
      pY[sp,t] =E= (1+srMarkup[sp,t] + jrMarkup[sp,t]) * (pKLBR[sp,t] + vtNetYAfgRest[sp,t] / qY[sp,t])

      - upYTraeghed[sp] * pY[sp,t] * (
          3/2 * sqr(pY[sp,t]/(pY[sp,t-1]/fp) / (pY[sp,t-1]/(pY[sp,t-2]/fp)))
          - 2 * pY[sp,t]/(pY[sp,t-1]/fp) / (pY[sp,t-1]/(pY[sp,t-2]/fp))
          + 1/2
        ) 

      + upYTraeghed[sp] / (1+rVirkDisk[sp,t+1]) * qY[sp,t+1]*fq / qY[sp,t] * 2 * pY[sp,t+1] * (
        sqr(pY[sp,t+1]*fp/pY[sp,t] / (pY[sp,t]/(pY[sp,t-1]/fp))) 
        - (pY[sp,t+1]*fp/pY[sp,t] / (pY[sp,t]/(pY[sp,t-1]/fp))) 
      )
    ;

    E_pY_sMarkup_tEnd[sp,t]$(tEnd[t] and sMarkup[sp])..
      pY[sp,t] =E= (1+srMarkup[sp,t] + jrMarkup[sp,t]) * (pKLBR[sp,t] + vtNetYAfgRest[sp,t] / qY[sp,t]);

    # Smaller sectors have no markup, but can still have rigidity
    E_pY_zero_markup[sp,t]$(tx0[t] and sZeroMarkup[sp])..
      pY[sp,t] =E= (1+srMarkup[sp,t] + jrMarkup[sp,t]) * (pKLBR[sp,t] + vtNetYAfgRest[sp,t] / qY[sp,t])
                 + upYTraeghed[sp] / 2 * pY[sp,t] * sqr(pY[sp,t]/(pY[sp,t-1]/fp) / (pY[sp,t-1]/(pY[sp,t-2]/fp)) - 1);

    # Public sector prices are equal to marginal costs
    E_pY_off[t]$(tx0[t])..
      pY['off',t] =E= (1+srMarkup['off',t] + jrMarkup['off',t]) * (pKLBR['off',t] + vtNetYAfg['off',t] / qY['off',t]);

    # Only used if the user wishes to deviate from law of one price in the IO system
    E_jrMarkup[s,t]$(tx0[t])..
      jrMarkup[s,t] * vY[s,t] =E= sum(d, rMerPris[d,t] * vIOy[d,s,t]);

    # Extraction sector prices (mostly oil and gas) follows import prices except for the small share that is gravel extraction
    E_srMarkup_udv[t]$(tx0[t])..
      pY['udv',t] =E= upYUdv[t] * (
                        (1 - qGrus[t] / qY['udv',t]) * pM['udv',t]
                        + qGrus[t] / qY['udv',t] * (pKLBR['udv',t] + vtNetYAfg['udv',t] / qY['udv',t])
                      );

    # Shipping industry chooses their markup to keep the relative export price constant 
    E_srMarkup_soe[t]$(tx0[t])..
      pX['xSoe',t] =E= upXSoe[t] * pXUdl['xSoe',t];

    # Synthetic housing sector rental price follows moving average of non-housing consumer price index
    E_pY_bol[t]$(tx0[t])..
      pY['bol',t] =E= pY['bol',t-1]/fp * (1 + pCInflSnit[t]) + jpY_bol[t];

    # Foreign prices follow a general foreign price index and the oil price with estimated elasticities
    E_pM[s,t]$(tx0[t] and d1IOm[dTot,s,t])..
      pM[s,t] =E= upM[s,t] * pOlie[t]**epM2pOlie[s] * pUdl[t]**(1-epM2pOlie[s]);

    E_pXUdl[x,t]$(tx0[t])..
      pXUdl[x,t] =E= upXUdl[x,t] * pOlie[t]**epXUdl2pOlie[x] * pUdl[t]**(1-epXUdl2pOlie[x]);
  $ENDBLOCK
$ENDIF