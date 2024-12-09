# ----------------------------------------------------------------------------------------------------------------------
# Set time periods
# ----------------------------------------------------------------------------------------------------------------------
set_time_periods(%cal_deep%-1, %terminal_year%);
set_data_periods(%cal_start%, %cal_deep%);

# Forecast dummies as last data-year
d1IO[d_,s_,tx1] = d1IO[d_,s_,t1];
d1IOy[d_,s_,tx1] = d1IOy[d_,s_,t1];
d1IOm[d_,s_,tx1] = d1IOm[d_,s_,t1];
d1Xm[x_,tx1] = d1Xm[x_,t1];
d1Xy[x_,tx1] = d1Xy[x_,t1];
d1CTurist[c,tx1] = d1CTurist[c,t1];
d1X[x_,tx1] = d1X[x_,t1];      
d1I_s[i_,ds_,tx1] = d1I_s[i_,ds_,t1];
d1K[i_,s_,tx1] = d1K[i_,s_,t1];
d1R[r_,tx1] = d1R[r_,t1];      
d1C[c_,tx1] = d1C[c_,t1];      
d1G[g_,tx1] = d1G[g_,t1];
d1vHhAkt[portf_,tx1] = d1vHhAkt[portf_,t1];
d1vHhPas[portf_,tx1] = d1vHhPas[portf_,t1];
d1vVirkAkt[portf_,tx1] = d1vVirkAkt[portf_,t1];
d1vVirkPas[portf_,tx1] = d1vVirkPas[portf_,t1];
d1vOffAkt[portf_,tx1] = d1vOffAkt[portf_,t1];
d1vOffPas[portf_,tx1] = d1vOffPas[portf_,t1];
d1vUdlAkt[portf_,tx1] = d1vUdlAkt[portf_,t1];
d1vUdlPas[portf_,tx1] = d1vUdlPas[portf_,t1];
d1vPensionAkt[portf_,tx1] = d1vPensionAkt[portf_,t1];

sets load_d1vHhPens[pens_, t];
execute_load "..\Data\pension\pension.gdx", load_d1vHhPens = d1vHhPens;
d1vHhPens[pens_,t]$(t.val > %AgeData_t1%) = load_d1vHhPens[pens_,t];

# ----------------------------------------------------------------------------------------------------------------------
# Variable that are kept constant from the deep calibration year
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_fixed_forecast
  G_exports_fixed_forecast
  G_labor_market_fixed_forecast
  G_aggregates_fixed_forecast
  G_consumers_fixed_forecast
  G_finance_fixed_forecast
  G_GovExpenses_fixed_forecast
  G_GovRevenues_fixed_forecast
  G_government_fixed_forecast
  G_HHincome_fixed_forecast
  G_IO_fixed_forecast
  G_pricing_fixed_forecast
  G_production_private_fixed_forecast
  G_production_public_fixed_forecast
;
$LOOP G_fixed_forecast:
  {name}.l{sets}$(tx1[t] and {conditions}) = {name}.l{sets}{$}[<t>t1];
$ENDLOOP

# ----------------------------------------------------------------------------------------------------------------------
# Variables that use the static calibration value after the deep calibration year
# and are kept constant from the last data year (unless overwritten in this file or by dynamic calibration)
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_newdata_forecast
  G_GovExpenses_newdata_forecast
  G_taxes_newdata_fixed_forecast
  G_GovRevenues_newdata_forecast
;
$LOOP G_newdata_forecast:
  {name}.l{sets}$(t.val > %cal_end% and {conditions}) = {name}.l{sets}{$}[<t>'%cal_end%'];
$ENDLOOP

# ----------------------------------------------------------------------------------------------------------------------
# Other variable are set to zero, except if explicitly overwritten in this file or by dynamic calibration
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_set_to_zero
  All, -G_constants
  -G_newdata_forecast
  -G_fixed_forecast
;
$FIX(0) G_set_to_zero$(tx1[t]);

# ----------------------------------------------------------------------------------------------------------------------
# Produktivitet
# ----------------------------------------------------------------------------------------------------------------------
rProdVaekst.l[t]$(tx1[t]) = gq;

# ----------------------------------------------------------------------------------------------------------------------
# Load ARIMA forecasts
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_ARIMA_forecast G_ARIMA_forecast$(tx0[t]);
@load_as(G_ARIMA_forecast, "Gdx\ARIMA_forecasts.gdx", _ARIMA)

rE2KE_ARIMA[sp,t]$(tx0[t] and eKE.l[sp] > 0 and rE2KE_ARIMA[sp,t] > 0) = (rE2KE_ARIMA[sp,t]/rE2KE_ARIMA[sp,t1])**eKE.l[sp] * rE2KE_ARIMA[sp,t1];
rL2KEL_ARIMA[sp,t]$(tx0[t] and eKEL.l[sp] > 0 and rL2KEL_ARIMA[sp,t] > 0) = (rL2KEL_ARIMA[sp,t]/rL2KEL_ARIMA[sp,t1])**eKEL.l[sp] * rL2KEL_ARIMA[sp,t1];
rB2KELB_ARIMA[sp,t]$(tx0[t] and eKELB.l[sp] > 0 and rB2KELB_ARIMA[sp,t] > 0) = (rB2KELB_ARIMA[sp,t]/rB2KELB_ARIMA[sp,t1])**eKELB.l[sp] * rB2KELB_ARIMA[sp,t1];
rR2KELBR_ARIMA[sp,t]$(tx0[t] and eKELBR.l[sp] > 0 and rR2KELBR_ARIMA[sp,t] > 0) = (rR2KELBR_ARIMA[sp,t]/rR2KELBR_ARIMA[sp,t1])**eKELBR.l[sp] * rR2KELBR_ARIMA[sp,t1];
uIOm0_ARIMA[dux,s,t]$(tx0[t] and eIO.l[dux,s] > 0 and uIOm0_ARIMA[dux,s,t] > 0) = (uIOm0_ARIMA[dux,s,t]/uIOm0_ARIMA[dux,s,t1])**eIO.l[dux,s] * uIOm0_ARIMA[dux,s,t1];
uXy_ARIMA[x,t]$(tx0[t] and eXUdl.l[x] > 0 and uXy_ARIMA[x,t] > 0) = (uXy_ARIMA[x,t]/uXy_ARIMA[x,t1])**eXUdl.l[x] * uXy_ARIMA[x,t1];
uXm_ARIMA[x,t]$(tx0[t] and eXUdl.l[x] > 0 and uXm_ARIMA[x,t] > 0) = (uXm_ARIMA[x,t]/uXm_ARIMA[x,t1])**eXUdl.l[x] * uXm_ARIMA[x,t1];

### Korrektioner til ARIMA forecasts
# Vi tror ikke, at den posisitve trend i eksport af søfart skal fortsætte
uXy_ARIMA[x,t]$(xSoe[x] and tx1[t]) = uXy_ARIMA[x,t1];

# Der er et mærkeligt niveau-dyk tilbage mod gammelt niveau i tjenesteeksport, som vi ikke tror på
uXy_ARIMA[x,t]$(xTje[x] and tx1[t]) = uXy_ARIMA[x,t1];

# Turisme-eksport fremskrives uændret
uXy_ARIMA[x,t]$(xTur[x] and tx1[t]) = uXy_ARIMA[x,t1];

# Rentespændet sættes til 0
rRenteSpaend_ARIMA[t]$(tx1[t]) = 0;

# Markupper fremskrives som gennemsnit af ARIMAer og historisk gennemsnit
srMarkup_ARIMA[sp,t]$(tx1[t]) = 0.5 * @mean(tt$[t1.val - 20 < tt.val and tt.val <= t1.val], srMarkup_ARIMA[sp,tt])
                              + 0.5 * srMarkup_ARIMA[sp,t];
###

# Hvis ARIMA_forecasts.gdx ikke er opdateret niveau-forskydes tidligere fremskrivning for at passe med kalibrerede t1-værdier 
$IF not %ARIMAs_updated%:
  $LOOP G_ARIMA_forecast:
    {name}_ARIMA{sets}$({conditions} and tx0[t] and {name}_ARIMA{sets}{$}[<t>t1] <> 0 and {name}.l{sets}{$}[<t>t1] <> 0)
      = {name}_ARIMA{sets} / {name}_ARIMA{sets}{$}[<t>t1] * {name}.l{sets}{$}[<t>t1];

    {name}_ARIMA{sets}$({conditions} and tx0[t] and ({name}_ARIMA{sets}{$}[<t>t1] = 0 or {name}.l{sets}{$}[<t>t1] = 0))
      = {name}.l{sets}{$}[<t>t1];
  $ENDLOOP
$ENDIF

$GROUP G_test G_ARIMA_forecast$(t.val <= t1.val);
@assert_no_difference(G_test, 1e-6, .l, _ARIMA, "ARIMA forecasting changed calibrated value.");

# Variable sættes til ARIMA-fremskrivning
# Visse parametre kalibreres dynamisk pga. fremaskuende forventinger, men fremskrives med ARIMAer.
# Vi skalerer fremskrivningen i deep_calibration for at matche niveuaet i det dybe kalibreringsår.
# Til dette formål bruges fremskrivningerne med suffix _ARIMA direkte i kalibreringsligninger.
@set(G_ARIMA_forecast, .l, _ARIMA)

# ----------------------------------------------------------------------------------------------------------------------
# Load demographic forecasts (BFR)
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_exogenous_forecast_BFR
  rOverlev, ErOverlev,
  rSeparation, srSeparation,
  snLHh, shLHh, snLxDK
  dSoc2dBesk, snSoc
  nPop, nLxDK, nPop_inklOver100, nPop_Over100, rBoern
  nOvf2nSoc
;
$GROUP G_exogenous_forecast_BFR G_exogenous_forecast_BFR$(tx1[t]);
@load(G_exogenous_forecast_BFR, "..\Data\Befolkningsregnskab\BFR.gdx");

# Load parametre fra befolkningsregnskab (BFR)
$GDXIN ..\Data\Befolkningsregnskab\BFR.gdx
  $LOAD nOvf_a, nOvfFraSocResidual
$GDXIN

# ----------------------------------------------------------------------------------------------------------------------
# Load pension forecasts
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_exogenous_forecast_pension
  # Vi tager (som udgangspunkt) de aldersfordelte pensionsind- og udbetalinger fra FMs fremskrivning
  rPensUdb_a[pens,a,t]
  rPensArv
  rPensIndb2loensum
;
$GROUP G_exogenous_forecast_pension G_exogenous_forecast_pension$(tx1[t]);
@load(G_exogenous_forecast_pension, "..\Data\pension\pension.gdx") ;

# HACK - der er gået noget helt galt i FMs fremskrivning af udbetalingsrater for personer over 90 år
rPensUdb_a.l[pens,a,t]$(tx1[t] and a.val > 90) = rPensUdb_a.l[pens,a,t1];

# Investerings- og administrationsomkostninger antages fremadrettet at udgøre ½ pct.
rHhAktOmk.l['pensTot',t]$(tx1[t]) = 0.005;

# ----------------------------------------------------------------------------------------------------------------------
# Load forecast for world output and demand for exports
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_world_output_forecast
  qBVTUdl, uXMarked
;
@load_as(G_world_output_forecast, "..\Data\FM_exogenous_forecast.gdx", _forecast);
qBVTUdl_forecast[t] = qBVTUdl_forecast[t] / fqt[t];

# Smooth forecast growth rates to avoid using actual data as forecast
$LOOP G_world_output_forecast:
  {name}_forecast[t] = log({name}_forecast[t]);
  @HPfilter({name}_forecast, 6.25);
  {name}_forecast[t] = exp({name}_forecast[t]);
  {name}.l[t]$(tx1[t]) = {name}_forecast[t] / {name}_forecast[t1] * {name}.l[t1];
$ENDLOOP

# ----------------------------------------------------------------------------------------------------------------------
# Exogenous forecasts based on BFR
# ---------------------------------------------------------------------------------------------------------------------- 
# vOvfSats og vOvfUbeskat er endogene, men beregnes som hjælpevariabel til beregning af uHhOvfPop og uOvfUbeskat
# Vi antager at satsregulerede overførsler vokser med fv, prisregulerede vokser med fp, mens at resten nominelt udfases
vOvfSats.l[satsreg,t]$(t.val > %cal_end%) = vOvfSats.l[satsreg,'%cal_end%'];
vOvfSats.l[prisreg,t]$(t.val > %cal_end%) = vOvfSats.l[prisreg,'%cal_end%'] / fqt[t] * fqt['%cal_end%'];
vOvfSats.l[ovfHh,t]$(t.val > %cal_end% and not satsreg[ovfHh] and not prisreg[ovfHh])
  = vOvfSats.l[ovfHh,'%cal_end%'] / fvt[t] * fvt['%cal_end%'];

vOvfUbeskat.l[a,t]$(a15t100[a] and nPop.l[a,t] and t.val > %cal_end%) = sum(ovf$(ubeskat[ovf]), vOvfSats.l[ovf,t] * nOvf_a[ovf,a,t]) / nPop.l[a,t];
vOvfUbeskat.l[aTot,t]$(t.val > %cal_end%) = sum(a, vOvfUbeskat.l[a,t] * nPop.l[a,t]);

# Aldersmæssig fordelingsnøgle knyttet til dvOvf2dnPop 
# Korrekt såfremt at overførsler knyttet til dvOvf2dnPop vokser med samme rate, fx satsregulering
uHhOvfPop.l[a,t]$(a15t100[a] and t.val > %cal_end%) =
  sum(ovfHh, vOvfSats.l[ovfHh,t] * nOvfFraSocResidual[ovfHh,a,t]) / nPop.l[a,t]  # Samlede overførsler pr. person i alder a, som ikke afhænger af beskæftigelsesfrekvens
/ sum(ovfHh, vOvfSats.l[ovfHh,t] * nOvfFraSocResidual[ovfHh,aTot,t]) * nPop.l['a15t100',t];  # Samlede overførsler i alt, som ikke afhænger af beskæftigelsesfrekvens

uOvfUbeskat.l[a,t]$(vOvfUbeskat.l[a,t] <> 0 and t.val > %cal_end%) = vOvfUbeskat.l[a,t]  / (vOvfUbeskat.l[aTot,t] / sum(aa, nPop.l[aa,t]));

nArvinger.l[a,t]$(tx1[t]) = sum(aa, rArv_a.l[a-1,aa-1] * nPop.l[aa,t]);

d1Arv[a,t]$(a18t100[a]) = (ErOverlev.l[a,t] < 0.995); # Kun aldersgrupper med forventet dødssansynlighed over 0.5% har arvemotiv

# Asymptotisk maksimum for arbejdsmarkedsdeltagelse sættes til 3 gange strukturel beskæftigelse
# Sættes for at undgå ekstreme konjunktur-gab i beskæftigelse for meget gamle husholdninger
fSoegBaseHh.l[a,t]$(tx1[t] and nPop.l[a,t] <> 0) = min(nPop.l[a,t], 3 * snLHh.l[a,t]) / nPop.l[a,t];

# ----------------------------------------------------------------------------------------------------------------------
# Land til ejerboligere holdes konstant
# ----------------------------------------------------------------------------------------------------------------------
qLand.l[t]$(tx1[t]) = qLand.l[t1] * fqt[t1] / fqt[t];

# ----------------------------------------------------------------------------------------------------------------------
# Inventory investments
# ----------------------------------------------------------------------------------------------------------------------
# In forecast years tax rates on net inventory investments follow the tax on material inputs.
# As inventory investments are net, but tax revenue is gross, the imputed tax rates are nonsense. 
$LOOP G_IO_taxes:
  {name}.l['iL',s,tx1]$({conditions}) = {name}.l[s,s,tx1];
$ENDLOOP
# ARIMA-fremskrivning for lagerinvesteringer i landbrug er fejlbehæftet og erstattes
rILy2Y.l['lan',tx1] = rILy2Y.l['fre',tx1];

# ----------------------------------------------------------------------------------------------------------------------
# Interest rates and risk premia
# ---------------------------------------------------------------------------------------------------------------------- 
# Forecast of interest rate:
rRente.l['Obl',t]$(tx1[t] and t.val <= 2050) = (1 - (t.val-t1.val)/(2050-t1.val))**2 * (rRente.l['Obl',t1] - terminal_rente) + terminal_rente;
rRente.l['Obl',t]$(t.val > 2050) = terminal_rente;  

# Den eksogene EU-obligationsrente beregnes for at få den ønskede effekt på den gns. obligationsrenten
rRenteOblDK.l[t]$(tx1[t]) = rRente.l['Obl',t] - crRenteObl.l[t]; 
rRenteOblEU.l[t]$(tx1[t]) = rRenteOblDK.l[t] - rRenteSpaend.l[t];
rRenteECB.l[t]$(tx1[t]) = rRenteOblEU.l[t] - rOblPrem.l[t];

# Indlånsrenten har været højere end pengemarkedsrenten i perioden med negative renter - vi ønsker ikke at fremskrive dette og slår ARIMA fra
crRenteBankIndskud.l[t]$(tx1[t] and t.val <= 2050) = (1 - (t.val-t1.val)/(2050-t1.val))**2 * (rRente.l['Obl',t1] + 0.01) - 0.01;
crRenteBankIndskud.l[t]$(t.val > 2050) = -0.01;  

rAfk.l['IndlAktier',tx1] = 0.07; # Om risikopræmie, se https://www.pwc.dk/da/publikationer/2020/vaerdiansaettelse-af-virk-pub.pdf og https://www.nationalbanken.dk/da/publikationer/Documents/2020/02/Eonomic%20Memo%20No.1_Do%20equity%20prices.pdf
rAfk.l['UdlAktier',t]$(tx1[t]) = max(rRenteECB.l[t] + 0.07 - rRenteECB.l[tEnd], 0.07);
rVirkDisk.l[sp,t]$(tx1[t]) = max(rRenteECB.l[t] + 0.08 - rRenteECB.l[tEnd], 0.08);

# Realrente er endogen men bruges nedenfor og skal beregnes
rRente.l['RealKred',t]$(tx1[t]) = rRente.l['Obl',t] + crRenteRealKred.l[t];

# Pensionsformuen har en aktieandel, som sikrer et afkast på 4½ pct. (før skat) på sigt
parameter rPensionAfk_target;
parameter rPensionIndlAktier_target;
rPensionAfk_target = 0.045;
rPensionIndlAktier_target = (rPensionAfk_target - rRente.l['Obl',tEnd] + rHhAktOmk.l['pensTot',tEnd]
                             - rPensionAkt.l['RealKred',tEnd] * (rRente.l['RealKred',tEnd] - rRente.l['Obl',tEnd])
                             - rPensionAkt.l['UdlAktier',tEnd] * (rAfk.l['UdlAktier',tEnd] - rRente.l['Obl',tEnd]))
                            / (rAfk.l['IndlAktier',tEnd] - rRente.l['Obl',tEnd]);
rPensionAkt.l['IndlAktier',t]$(tx1[t] and t.val <= 2050) 
  = (1 - (t.val-t1.val)/(2050-t1.val))**2 * (rPensionAkt.l['IndlAktier',t1] - rPensionIndlAktier_target) 
     + rPensionIndlAktier_target;
rPensionAkt.l['IndlAktier',t]$(t.val > 2050) = rPensionIndlAktier_target;
rPensionAkt.l['Obl',t]$(tx1[t]) = 1 - rPensionAkt.l['RealKred',t] - rPensionAkt.l['UdlAktier',t] - rPensionAkt.l['IndlAktier',t];

rBoligPrem.l[t]$(tx1[t]) = max(0.03, 0.07 - rRente.l["Obl",t]);

# Sammensætningseffekt af ændrede uddannelsesbaggrunde etc. for offentligt ansatte
fpYoff.l[t]$(tx1[t]) = 1.0008;

vNulvaekstIndeks.l[t]$(tx1[t]) = 1/fvt[t];

#  # ----------------------------------------------------------------------------------------------------------------------
#  # Markupper går til historisk gennemsnit, dog mindst 0
#  # ----------------------------------------------------------------------------------------------------------------------
#  parameter aftrapprofil[t] "Profil for aftrapning af vissekalibrerede parametre til strukturelt niveau.";
#  aftrapprofil[t]$(tx0[t]) = 0.8**(dt[t]**1.5);
#  srMarkup.l[sp,t]$(tx0[t]) = srMarkup.l[sp,t1] * aftrapprofil[t] + (1-aftrapprofil[t]) * max(@mean(tData, srMarkup.l[sp,tData]), 0);

# ----------------------------------------------------------------------------------------------------------------------
# Public finances
# ----------------------------------------------------------------------------------------------------------------------
# Særligt væsentlige offentlige-finansposter sættes for at opnå en rimelig holdbarhed mv. i den dybe kalibrering

# Vi fremskriver aktieskat ved konstant provenue som andel af privat-sektor-BVT
# baseret på gennemsnit af de seneste 10 år op til det dybe kalibreringsår
set t10[t];
t10[t] = yes$(%cal_deep% - 10 < t.val and t.val <= %cal_deep% and t.val >= %cal_start%);
rvtAktie2BVT.l[t]$(tx1[t]) = @mean(t10, rvtAktie2BVT.l[t10]);

# Korrektionsfaktor på selskabsskat fremskrives direkte (pga. ændringer i selskabsskattesats)
ftSelskab.l[t]$(tx1[t]) = @mean(t10, ftSelskab.l[t10]); 

# Mellemskat og top-top-skat
tMellem.l[t]$(tx1[t] and t.val >= 2026) = 0.075;
tTopTop.l[t]$(tx1[t] and t.val >= 2026) = 0.05;

# Demografisk træk
$GROUP G_GovExpenses_DemoTraek
    fDemoTraek[a,t]$(tx1[t])
    fDemoTraek_Over100[t]$(tx1[t])
  ;
@load(G_GovExpenses_DemoTraek, "..\Data\Befolkningsregnskab\DemoTraek.gdx" )

# ----------------------------------------------------------------------------------------------------------------------
# Exogenous forecasts re-uses from previous forecast
# ----------------------------------------------------------------------------------------------------------------------  
$GROUP G_load_udv
  qY['udv',t]
;
@load_as(G_load_udv, "..\Data\FM_exogenous_forecast.gdx", _previous)
qY.l['udv',t]$(tx1[t]) = qY.l['udv',t1] * qY_previous['udv',t] / qY_previous['udv',t1];

# Produktion af olie/gas aftrappes gradvist efter 2040 for at hjælpe konvergens ift. bræt afslutning i fremskrivning
qY.l['udv',t]$(t.val > 2040) = qGrus.l[t] + (qY.l['udv','2040'] - qGrus.l['2040']) * 0.8**((t.val-2040)**1.5);

# Leverencer fra udvinding til eksport skaleres med indenlandsk produktion af udvinding.
# Øvrige leverencer tager tilpasning via. skalering i E_uIOXy.
uIOXy0.l[x,'udv',t]$(tx1[t]) = uIOXy0.l[x,'udv',t1] * (qY.l['udv',t] - qGrus.l[t]) / (qY.l['udv',t1] - qGrus.l[t1]);

# Enkelte ARIMA-fremskrivninger slås fra i udvnindingsbranche
rL2KEL_ARIMA['udv',t] = rL2KEL_ARIMA['udv',t1];
uL_ARIMA['udv',t] = uL_ARIMA['udv',t1];

# ----------------------------------------------------------------------------------------------------------------------
# Dummies and exogenous IO cells
# ----------------------------------------------------------------------------------------------------------------------
# Set scale parameters to zero and dummy out very small cells
# Dummy out cells where:
# 1) value of IO cell is below 1mn in all years
# 2) value of IO cell is 0 in last calibration year, or
# 3) The forecasted scale parameter is below 0.001
d1IOm[dux,s,t]$tx1[t] = (
  (uIO0.l[dux,s,t] > 0.001 or iL[dux])
  and uIOm0.l[dux,s,t] > 0.001 
  and sum(tData, abs(vIOm.l[dux,s,tData])) > 0.001
  and vIOm.l[dux,s,t1] <> 0
);
d1IOy[dux,s,t]$tx1[t] = (
  (uIO0.l[dux,s,t] > 0.001 or iL[dux])
  and uIOm0.l[dux,s,t] <= 1-0.001
  and sum(tData, abs(vIOy.l[dux,s,tData])) > 0.001
  and vIOy.l[dux,s,t1] <> 0
);
d1IOy[x,s,t]$tx1[t] = (
  uIOXy0.l[x,s,t] > 0.0001
  and sum(tData, vIOy.l[x,s,tData]) > 0.001
  and vIOy.l[x,s,t1] >= 0
);
d1IOm[x,s,t]$tx1[t] = (
  uIOXm0.l[x,s,t] > 0.0001
  and sum(tData, vIOm.l[x,s,tData]) > 0.001
  and vIOm.l[x,s,t1] >= 0
);
# Do not allow negative inventory investments in forecast
rILy2Y.l[s,t]$(tx1[t] and rILy2Y.l[s,t] < 0) = 0.001;
rILm2Y.l[s,t]$(tx1[t] and rILm2Y.l[s,t] < 0) = 0.001;
d1I_s['iL',s,t]$(tx1[t]) = d1IOy['iL',s,t] or d1IOm['iL',s,t];
d1IO['iL',s,t]$(not d1I_s['iL',s,t]) = No;
d1IOy['iL',s,t]$(not d1I_s['iL',s,t]) = No;
d1IOm['iL',s,t]$(not d1I_s['iL',s,t]) = No;
# Aggregate dummies
d1IO[d,s,t]$tx1[t] = d1IOy[d,s,t] or d1IOm[d,s,t];
d1IOy[dTots,s,t]$tx1[t] = sum(d$dTots2d[dTots,d], d1IOy[d,s,t]);
d1IOm[dTots,s,t]$tx1[t] = sum(d$dTots2d[dTots,d], d1IOm[d,s,t]);
d1IOy[d_,sTot,t]$tx1[t] = sum(s, d1IOy[d_,s,t]);
d1IOm[d_,sTot,t]$tx1[t] = sum(s, d1IOm[d_,s,t]);
d1Xy[x,t]$tx1[t] = d1IOy[x,sTot,t];
d1Xy['xTur',t]$tx1[t] = yes;
d1Xm[x,t]$tx1[t] = d1IOm[x,sTot,t];
# Set dummied out scale parameters and cells to zero
uIOXy0.l[x,s,t]$(tx1[t] and not d1IOy[x,s,t]) = 0;
uIOXm0.l[x,s,t]$(tx1[t] and not d1IOm[x,s,t]) = 0;
uIO0.l[dux,s,t]$(tx1[t] and not d1IO[dux,s,t]) = 0;
uIOm0.l[dux,s,t]$(tx1[t] and not d1IOy[dux,s,t]) = 1;
uIOm0.l[dux,s,t]$(tx1[t] and not d1IOm[dux,s,t]) = 0;
qIO.l[d,s,t]$(tx1[t] and not d1IO[d,s,t]) = 0;
vIO.l[d,s,t]$(tx1[t] and not d1IO[d,s,t]) = 0;
pIO.l[d,s,t]$(tx1[t] and not d1IO[d,s,t]) = 0;
qIOy.l[d,s,t]$(tx1[t] and not d1IOy[d,s,t]) = 0;
vIOy.l[d,s,t]$(tx1[t] and not d1IOy[d,s,t]) = 0;
pIOy.l[d,s,t]$(tx1[t] and not d1IOy[d,s,t]) = 0;
qIOm.l[d,s,t]$(tx1[t] and not d1IOm[d,s,t]) = 0;
vIOm.l[d,s,t]$(tx1[t] and not d1IOm[d,s,t]) = 0;
pIOm.l[d,s,t]$(tx1[t] and not d1IOm[d,s,t]) = 0;
$FOR {D}, {ds} in [("I_s", "i,s"), ("C", "c"), ("G", "g"), ("R", "r"), ("Xy", "x"), ("Xm", "x")]:
  q{D}.l[{ds},t]$(tx1[t] and not d1{D}[{ds},t]) = 0;
  v{D}.l[{ds},t]$(tx1[t] and not d1{D}[{ds},t]) = 0;
  p{D}.l[{ds},t]$(tx1[t] and not d1{D}[{ds},t]) = 0;
$ENDFOR
qK.l[k,s,t]$(tx1[t] and not d1k[k,s,t]) = 0;

# ----------------------------------------------------------------------------------------------------------------------
# Fremskrivning af alderspecifik produktivitet - bør rykkes til BFR på sigt
# ----------------------------------------------------------------------------------------------------------------------
execute_unloaddi "Gdx/qProdHh_a_forecast.gdx" qProdHh_a, BruttoArbsty, tDataEnd, tEnd;
embeddedCode Python:
  with open("age_productivity_forecast.py") as f: exec(f.read())
endEmbeddedCode
execute_load "Gdx/qProdHh_a_forecast.gdx" qProdHh_a;

# ----------------------------------------------------------------------------------------------------------------------
# Filtrering af aldersafhængige parametre
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_smooth_profiles
  ftBund_a
  ftKommune_a
  rTopSkatInd_a
  uPersIndRest_a$(a[a_])
  cHh_a
  rRealKred2Bolig_a
  rvCLejeBolig
  uBoernFraHh_a$(a0t17[a])
  mtIndRest
  mrKomp
  vHhx
;
@set(G_smooth_profiles, _presmooth, .l)
execute_unloaddi "Gdx/smooth_profiles_input.gdx" $LOOP G_smooth_profiles:, {name} $ENDLOOP, tDataEnd, tEnd;

embeddedCode Python:
  import dreamtools as dt
  import numpy as np
  import pandas as pd
  from scipy.optimize import curve_fit

  db = dt.Gdx("Gdx/smooth_profiles_input.gdx")
  tEnd = db.tEnd[0]
  tDataEnd = db.tDataEnd[0]

  # ----------------------------------------------------------------------------------------------------------------------
  # Smoothing
  # ----------------------------------------------------------------------------------------------------------------------
  # List of variables to be smoothed
  smoothing_vars = [
      (db["ftBund_a"], 15, 5),
      (db["ftKommune_a"], 15, 5),
      (db["rTopSkatInd_a"], 15, 5),
      (db["uPersIndRest_a"], 15, 5),
      (db["cHh_a"], 0, 4),
      (db["rRealKred2Bolig_a"], 18, 5),
      (db["rvCLejeBolig"], 18, 6),
      (db["uBoernFraHh_a"], 0, 3),
      (db["mtIndRest"], 15, 5),
      (db["mrKomp"], 15, 5),
      (db["vHhx"], 0, 5),
  ]

  for var, a_start, degrees in smoothing_vars:
      a = "a" if ("a" in var.index.names) else "a_"

      # Limit DataFrame to the years and age groups that we want to smooth (and remove any totals etc.)
      t_range = range(tDataEnd-1, tDataEnd + 1)
      a_range = range(a_start, 100 + 1)
      df = var.reset_index()
      df = df[df["t"].isin(t_range) & df[a].isin(a_range)]

      # Reset index to those of original variable
      df = df.set_index(var.index.names)

      # Groupby all sets except the age set
      levels = [i for i in df.index.names if i != a]
      grouped = df.groupby(levels, group_keys=False)

      # group = list(grouped)[-1][1]
      # group = grouped.get_group(('Obl',2017))
      M = N = degrees
      def polynomial_ratio(x, *args):
          a = args[:M+1]
          b = args[M+1:]
          return sum(a[i] * x**i for i in range(M+1)) / (1 - sum(b[i] * x**(i+1) for i in range(N)))

      def smooth(group):
          if len(group[var.name].unique()) < (N + M + 2):
              return group[var.name]
          y = group[var.name].values
          a1 = np.array(a_range).astype(float) - a_start
          starting_values = np.ones(M+N+1) / 100
          for i in range(10): # Max number of tries with new starting values
              try:
                  popt, pcov = curve_fit(polynomial_ratio, a1, y, p0=starting_values, maxfev=1000000)
                  if i > 0:
                      print(f"Fit of ratio of polynomiums of order M={M} and N={N} for group:\n{group} succeeded after {i} retries")
                  break
              except RuntimeError as e:
                  starting_values = np.random.rand(M+N+1) - 0.5
          else:
              msg = f"Failed to fit ratio of polynomiums of order M={M} and N={N} for group:\n{group}"
              print(msg)
              raise e

          group["fit"] = polynomial_ratio(a1, *popt)
          # import plotly.express as px
          # group[var.name] = y
          # px.line(group.reset_index(), x=a, y=[var.name, "fit"]).show()
          return group["fit"]

      # Apply smoothing function to each group
      smoothed = grouped.apply(smooth)
      smoothed *= (df[var.name] != 0) # Remove smoothing where original value was exactly zero

      # Overwrite database values with new smoothed profiles
      idx = [smoothed.index.get_level_values(i) for i in smoothed.index.names[:-1]]
      for year in range(tDataEnd, tEnd+1):
          db[var.name].loc[(*idx, year)] = smoothed.xs(tDataEnd, level="t").values

  db.export("smooth_profiles.gdx")
endEmbeddedCode

@load(G_smooth_profiles, "Gdx\smooth_profiles.gdx");
jqFormueBase.l[a,t1] = (vHhx.l[a,t1] - vHhx_presmooth[a,t1]) / pC.l['Cx',t1];
$GROUP G_reset G_smooth_profiles$(t1[t]);
@set(G_reset, .l, _presmooth);

# ----------------------------------------------------------------------------------------------------------------------
# Clear large objects that we no longer need from memory
# ----------------------------------------------------------------------------------------------------------------------
option clear = nOvf_a;
option clear = nOvfFraSocResidual;
@unload_all(Gdx\exogenous_forecast);