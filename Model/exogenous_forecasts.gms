# ----------------------------------------------------------------------------------------------------------------------
# Set time periods
# ----------------------------------------------------------------------------------------------------------------------
set_time_periods(%cal_deep%-1, %terminal_year%);
set_data_periods(%cal_start%, %cal_deep%);

# Forecast dummies as last data-year
d1IO[d_,s_,t]$(t.val > %cal_end%) = d1IO[d_,s_,'%cal_end%'];
d1IOy[d_,s_,t]$(t.val > %cal_end%) = d1IOy[d_,s_,'%cal_end%'];
d1IOm[d_,s_,t]$(t.val > %cal_end%) = d1IOm[d_,s_,'%cal_end%'];
d1Xm[x_,t]$(t.val > %cal_end%) = d1Xm[x_,'%cal_end%'];
d1Xy[x_,t]$(t.val > %cal_end%) = d1Xy[x_,'%cal_end%'];
d1CTurist[c,t]$(t.val > %cal_end%) = d1CTurist[c,'%cal_end%'];
d1X[x_,t]$(t.val > %cal_end%) = d1X[x_,'%cal_end%'];      
d1I_s[i_,ds_,t]$(t.val > %cal_end%) = d1I_s[i_,ds_,'%cal_end%'];
d1K[i_,s_,t]$(t.val > %cal_end%) = d1K[i_,s_,'%cal_end%'];
d1R[r_,t]$(t.val > %cal_end%) = d1R[r_,'%cal_end%'];      
d1C[c_,t]$(t.val > %cal_end%) = d1C[c_,'%cal_end%'];      
d1G[g_,t]$(t.val > %cal_end%) = d1G[g_,'%cal_end%'];
d1vHhAkt[portf_,t]$(t.val > %cal_end%) = d1vHhAkt[portf_,'%cal_end%'];
d1vHhPas[portf_,t]$(t.val > %cal_end%) = d1vHhPas[portf_,'%cal_end%'];
d1vVirkAkt[portf_,t]$(t.val > %cal_end%) = d1vVirkAkt[portf_,'%cal_end%'];
d1vVirkPas[portf_,t]$(t.val > %cal_end%) = d1vVirkPas[portf_,'%cal_end%'];
d1vOffAkt[portf_,t]$(t.val > %cal_end%) = d1vOffAkt[portf_,'%cal_end%'];
d1vOffPas[portf_,t]$(t.val > %cal_end%) = d1vOffPas[portf_,'%cal_end%'];
d1vUdlAkt[portf_,t]$(t.val > %cal_end%) = d1vUdlAkt[portf_,'%cal_end%'];
d1vUdlPas[portf_,t]$(t.val > %cal_end%) = d1vUdlPas[portf_,'%cal_end%'];
d1vPensionAkt[portf_,t]$(t.val > %cal_end%) = d1vPensionAkt[portf_,'%cal_end%'];

sets load_d1vHhPens[pens_, t];
execute_load "../Data/Pension/pension.gdx", load_d1vHhPens = d1vHhPens;
d1vHhPens[pens_,t]$(t.val > %AgeData_t1%) = load_d1vHhPens[pens_,t];

# ----------------------------------------------------------------------------------------------------------------------
# Variable that are kept constant from the deep calibration year
# ----------------------------------------------------------------------------------------------------------------------
$LOOP G_fixed_forecast:
  {name}.l{sets}$(tx1[t] and {conditions}) = {name}.l{sets}{$}[<t>t1];
$ENDLOOP

# ----------------------------------------------------------------------------------------------------------------------
# Variables that use the static calibration value after the deep calibration year
# and are kept constant from the last data year (unless overwritten in this file or by dynamic calibration)
# ----------------------------------------------------------------------------------------------------------------------
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
  # Lagerinvesteringerne fremskrives ud fra static_calibration i tBase for at få korrekte priser på piom og pioy
  -uIO0['iL',s_,t]$(t.val <= tBase.val)
  -uIOm0['iL',s,t]$(t.val <= tBase.val)
  -fuIO['iL',t]$(t.val <= tBase.val)
  -fuIOym['iL',s,t]$(t.val <= tBase.val)
  -tAfg_y['iL',s,t]$(t.val <= tBase.val)
  -tAfg_m['iL',s,t]$(t.val <= tBase.val)
  -rSub_y['iL',s,t]$(t.val <= tBase.val)
  -rSub_m['iL',s,t]$(t.val <= tBase.val)
  -tTold['iL',s_,t]$(t.val <= tBase.val)
  -tMoms_y['iL',s,t]$(t.val <= tBase.val)
  -tMoms_m['iL',s,t]$(t.val <= tBase.val)
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
@load_as(G_ARIMA_forecast, "Gdx/ARIMA_forecasts.gdx", _ARIMA)

# Blev nedskaleret i ARIMA_options og skaleres nu tilbage til neutral
rE2KE_ARIMA[sp,t]$(tx0[t] and eKE.l[sp] > 0 and rE2KE_ARIMA[sp,t] > 0) = (rE2KE_ARIMA[sp,t]/rE2KE_ARIMA[sp,t1])**eKE.l[sp] * rE2KE_ARIMA[sp,t1];
rL2KEL_ARIMA[sp,t]$(tx0[t] and eKEL.l[sp] > 0 and rL2KEL_ARIMA[sp,t] > 0) = (rL2KEL_ARIMA[sp,t]/rL2KEL_ARIMA[sp,t1])**eKEL.l[sp] * rL2KEL_ARIMA[sp,t1];
rB2KELB_ARIMA[sp,t]$(tx0[t] and eKELB.l[sp] > 0 and rB2KELB_ARIMA[sp,t] > 0) = (rB2KELB_ARIMA[sp,t]/rB2KELB_ARIMA[sp,t1])**eKELB.l[sp] * rB2KELB_ARIMA[sp,t1];
rR2KELBR_ARIMA[sp,t]$(tx0[t] and eKELBR.l[sp] > 0 and rR2KELBR_ARIMA[sp,t] > 0) = (rR2KELBR_ARIMA[sp,t]/rR2KELBR_ARIMA[sp,t1])**eKELBR.l[sp] * rR2KELBR_ARIMA[sp,t1];
uIOm0_ARIMA[dux,s,t]$(tx0[t] and eIO.l[dux,s] > 0 and uIOm0_ARIMA[dux,s,t] > 0) = (uIOm0_ARIMA[dux,s,t]/uIOm0_ARIMA[dux,s,t1])**eIO.l[dux,s] * uIOm0_ARIMA[dux,s,t1];
uXy_ARIMA[x,t]$(tx0[t] and eXUdl.l[x] > 0 and uXy_ARIMA[x,t] > 0) = (uXy_ARIMA[x,t]/uXy_ARIMA[x,t1])**eXUdl.l[x] * uXy_ARIMA[x,t1];
uXm_ARIMA[x,t]$(tx0[t] and eXUdl.l[x] > 0 and uXm_ARIMA[x,t] > 0) = (uXm_ARIMA[x,t]/uXm_ARIMA[x,t1])**eXUdl.l[x] * uXm_ARIMA[x,t1];

# ARIMA-fremskrivninger niveau-forskydes for at passe med kalibrerede t1-værdier 
# I tilfælde af at ARIMA_forecasts.gdx ikke er opdateret
$LOOP G_ARIMA_forecast:
  {name}_ARIMA{sets}$({conditions} and tx0[t] and {name}_ARIMA{sets}{$}[<t>t1] <> 0 and {name}.l{sets}{$}[<t>t1] <> 0)
    = {name}_ARIMA{sets} / {name}_ARIMA{sets}{$}[<t>t1] * {name}.l{sets}{$}[<t>t1];

  {name}_ARIMA{sets}$({conditions} and tx0[t] and ({name}_ARIMA{sets}{$}[<t>t1] = 0 or {name}.l{sets}{$}[<t>t1] = 0))
    = {name}.l{sets}{$}[<t>t1];
$ENDLOOP

# Enkelte ARIMA-fremskrivninger slås fra i udvnindingsbranche
rL2KEL_ARIMA['udv',t] = rL2KEL_ARIMA['udv',t1];
uL_ARIMA['udv',t] = uL_ARIMA['udv',t1];

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
  snLHh, shLHh, snLxDK
  dSoc2dBesk, snSoc
  nPop, nLxDK, nPop_Over100, rBoern
  nOvf2nSoc
;
$GROUP G_exogenous_forecast_BFR G_exogenous_forecast_BFR$(tx1[t]);
@load(G_exogenous_forecast_BFR, "../Data/Befolkningsregnskab/BFR.gdx");

snLHh_vaekst.l[a,t]$(snLHh.l[a-1,t-1] > 0) = snLHh.l[a,t] / snLHh.l[a-1,t-1];
snLHh_vaekst.l[a,t]$(aVal[a] = 15 and snLHh.l[a,t-1] > 0 and nPop.l[a,t] > 0 and nPop.l[a,t-1] > 0)
  = snLHh.l[a,t]/nPop.l[a,t] / (snLHh.l[a,t-1]/nPop.l[a,t-1]);


snSoc_vaekst.l[soc,t]$(snSoc.l[soc,t-1] > 0) = snSoc.l[soc,t] / snSoc.l[soc,t-1];

# Load parametre fra befolkningsregnskab (BFR)
$GDXIN ../Data/Befolkningsregnskab/BFR.gdx
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
@load(G_exogenous_forecast_pension, "../Data/Pension/pension.gdx") ;

# Investerings- og administrationsomkostninger antages fremadrettet at udgøre ½ pct.
rHhAktOmk.l['pensTot',t]$(tx1[t]) = 0.005;

# ----------------------------------------------------------------------------------------------------------------------
# Load forecast for world output and demand for exports
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_world_output_forecast
  qBVTUdl, uXMarked
;
@load_as(G_world_output_forecast, "../Data/FM_exogenous_forecast.gdx", _forecast);
qBVTUdl_forecast[t] = qBVTUdl_forecast[t] / fqt[t];

# Smooth forecast growth rates to avoid using actual data as forecast
$LOOP G_world_output_forecast:
  {name}_forecast[t] = log({name}_forecast[t]);
  @HPfilter({name}_forecast, 6.25, %cal_start%, %terminal_year%);
  {name}_forecast[t] = exp({name}_forecast[t]);
  {name}.l[t]$(tx1[t]) = {name}_forecast[t] / {name}_forecast[t1] * {name}.l[t1];
$ENDLOOP

# ----------------------------------------------------------------------------------------------------------------------
# Exogenous forecasts based on BFR
# ---------------------------------------------------------------------------------------------------------------------- 
# vOvfSats og vOvfUbeskat er endogene, men beregnes som hjælpevariabel til beregning af uHhOvfPop og uOvfUbeskat
# Vi antager at satsregulerede overførsler vokser med fv, prisregulerede vokser med fp, mens at resten nominelt udfases
vOvfSats.l[satsreg,t]$(t.val > %cal_end%) = vOvfSats.l[satsreg,'%cal_end%'];
vOvfSats.l[oblpens,t]$(t.val > %cal_end%) = vOvfSats.l[oblpens,'%cal_end%'];
vOvfSats.l[loenreg,t]$(t.val > %cal_end%) = vOvfSats.l[loenreg,'%cal_end%'];
vOvfSats.l[prisreg,t]$(t.val > %cal_end%) = vOvfSats.l[prisreg,'%cal_end%'] / fqt[t] * fqt['%cal_end%'];
vOvfSats.l[ovfHh,t]$(t.val > %cal_end% and not satsreg[ovfHh] and not oblpens[ovfHh] and not loenreg[ovfHh] and not prisreg[ovfHh])
  = vOvfSats.l[ovfHh,'%cal_end%'] / fvt[t] * fvt['%cal_end%'];

vOvfUbeskat.l[a,t]$(a15t100[a] and nPop.l[a,t] and t.val > %cal_end%)
  = sum(ubeskat, vOvfSats.l[ubeskat,t] * nOvf_a[ubeskat,a,t]) / nPop.l[a,t];
vOvfUbeskat.l[aTot,t]$(t.val > %cal_end%) = sum(a, vOvfUbeskat.l[a,t] * nPop.l[a,t]);

# Aldersmæssig fordelingsnøgle knyttet til dvOvf2dnPop 
# Korrekt såfremt at overførsler knyttet til dvOvf2dnPop vokser med samme rate, fx satsregulering
uHhOvfPop.l[a,t]$(a15t100[a] and t.val > %cal_end%) =
  sum(ovfHh, vOvfSats.l[ovfHh,t] * nOvfFraSocResidual[ovfHh,a,t]) / nPop.l[a,t]  # Samlede overførsler pr. person i alder a, som ikke afhænger af beskæftigelsesfrekvens
/ sum(ovfHh, vOvfSats.l[ovfHh,t] * nOvfFraSocResidual[ovfHh,aTot,t]) * nPop.l['a15t100',t];  # Samlede overførsler i alt, som ikke afhænger af beskæftigelsesfrekvens

uOvfUbeskat.l[a,t]$(vOvfUbeskat.l[a,t] <> 0 and t.val > %cal_end%)
  = vOvfUbeskat.l[a,t]  / (vOvfUbeskat.l[aTot,t] / sum(aa, nPop.l[aa,t]));

uPensIndbOP.l[a,t]$(tx1[t] and nPop.l[a,t] <> 0)
  = sum(oblpens, vOvfSats.l[oblpens,t] * nOvf_a[oblpens,a,t]) / nPop.l[a,t]
  / sum(oblpens, vOvfSats.l[oblpens,t] * nOvf_a[oblpens,aTot,t]);

nArvinger.l[a,t]$(tx1[t]) = sum(aa, rArv_a.l[a-1,aa] * nPop.l[aa,t]);

d1Arv[a,t]$(a18t100[a]) = (ErOverlev.l[a,t] < 0.995); # Kun aldersgrupper med forventet dødssansynlighed over 0.5% har arvemotiv

# Asymptotisk maksimum for arbejdsmarkedsdeltagelse sættes til 3 gange strukturel beskæftigelse
# Sættes for at undgå ekstreme konjunktur-gab i beskæftigelse for meget gamle husholdninger
fSoegBaseHh.l[a,t]$(tx1[t] and nPop.l[a,t] <> 0) = min(nPop.l[a,t], 3 * snLHh.l[a,t]) / nPop.l[a,t];

# ----------------------------------------------------------------------------------------------------------------------
# Land til ejerboligere holdes konstant
# ----------------------------------------------------------------------------------------------------------------------
qLand.l[t]$(tx1[t]) = qLand.l[t1] * fqt[t1] / fqt[t];

# ----------------------------------------------------------------------------------------------------------------------
# Interest rates and risk premia
# ---------------------------------------------------------------------------------------------------------------------- 
# Forecast of interest rate:
rRente.l['Obl',t]$(tx1[t] and t.val <= 2050)
  = (1 - (t.val-t1.val)/(2050-t1.val))**2 * (rRente.l['Obl',t1] - terminal_rente) + terminal_rente;
rRente.l['Obl',t]$(t.val > 2050) = terminal_rente;  

rRenteECB.l[t]$(tx1[t] and t.val <= 2050)
  = (1 - (t.val-t1.val)/(2050-t1.val))**2 * (rRenteECB.l[t1] - terminal_ECB_rente) + terminal_ECB_rente;
rRenteECB.l[t]$(t.val > 2050) = terminal_ECB_rente;

# Den eksogene EU-obligationsrente beregnes for at få den ønskede effekt på den gns. obligationsrenten
rRenteOblDK.l[t]$(tx1[t]) = rRente.l['Obl',t] - crRenteObl.l[t]; 
rRenteOblEU.l[t]$(tx1[t]) = rRenteOblDK.l[t] - rRenteSpaend.l[t];

# Indlånsrenten har været højere end pengemarkedsrenten i perioden med negative renter - vi ønsker ikke at fremskrive dette og slår ARIMA fra
rHhAktOmk.l['Bank',t]$(tx1[t] and t.val <= 2050) = 0.01 - (1 - (t.val-t1.val)/(2050-t1.val))**2 * (rRente.l['Obl',t1] + 0.01);
rHhAktOmk.l['Bank',t]$(t.val > 2050) = 0.01;  

rAfk.l['IndlAktier',tx1] = 0.07; # Om risikopræmie, se https://www.pwc.dk/da/publikationer/2020/vaerdiansaettelse-af-virk-pub.pdf og https://www.nationalbanken.dk/da/publikationer/Documents/2020/02/Eonomic%20Memo%20No.1_Do%20equity%20prices.pdf
rAfk.l['UdlAktier',t]$(tx1[t]) = 0.07;

# Offentligt ejede aktier giver lavere afkast end øvrige aktier
jrOffAktOmv.l[portf,t]$(tx1[t] and (IndlAktier[portf] or UdlAktier[portf])) = -0.02;

# Realrente er endogen men bruges nedenfor og skal beregnes
rRenteFast.l[t]$(tx1[t]) = rRente.l['Obl',t] + crRenteFast.l[t];
rRenteFlex.l[t]$(tx1[t]) = rRente.l['Obl',t] + crRenteFlex.l[t];
rRente.l['RealKred',t]$(tx1[t]) = 0.5 * rRenteFast.l[t] + 0.5 * rRenteFlex.l[t];

# Prisstigning på guld tilsvarer obligationsrenten
rOmv.l['Guld',t]$(tx1[t]) = rRente.l['Obl',t];

# Pensionsformuen har en aktieandel, som sikrer et afkast på 4½ pct. (før skat) på sigt
$IF %FM_baseline%:
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
$ENDIF
$IF %DREAM_baseline% or %DORS_baseline%:
  # Pensionsformuen fordeling er ARIMA-fremskrevet. Juster proportionalt.
  rPensionAkt.l[portf,t]$(tx1[t]) = rPensionAkt.l[portf,t] / sum(fin_akt, rPensionAkt.l[fin_akt,t]);
$ENDIF

rBoligPrem.l[t]$(tx1[t]) = max(0.03, 0.07 - rRente.l["Obl",t]);

$IF %FM_baseline%:
  # Produktivitetsvæksten i det offentlige sættes til 0.6 pct.
  uL.l['off',t]$(tx1[t]) = uL.l['off',t1] * (1.006)**(t.val - t1.val) / (fqt[t] / fqt[t1]);

  # Sammensætningseffekt af ændrede uddannelsesbaggrunde etc. for offentligt ansatte
  fqLOffInput.l[t]$(tx1[t]) = fqLOffInput.l[t1] * (1.0008)**(t.val - t1.val);
$ENDIF

vNulvaekstIndeks.l[t]$(tx1[t]) = 1/fvt[t];

# ----------------------------------------------------------------------------------------------------------------------
# Public finances
# ----------------------------------------------------------------------------------------------------------------------
# Særligt væsentlige offentlige-finansposter sættes for at opnå en rimelig holdbarhed mv. i den dybe kalibrering

rNet2KapIndPos.l[aTot,tx1] = rNet2KapIndPos.l[aTot,'%cal_end%'];

# Mellemskat og top-top-skat
tMellem.l[t]$(tx1[t] and t.val >= 2026) = 0.075;
tTopTop.l[t]$(tx1[t] and t.val >= 2026) = 0.05;

#Obligatorisk opsparing
rOblOpsp2Ovf.l[t]$(t.val = 2020) = 0.003;
rOblOpsp2Ovf.l[t]$(t.val = 2021) = 0.006;
rOblOpsp2Ovf.l[t]$(t.val = 2022) = 0.009;
rOblOpsp2Ovf.l[t]$(t.val = 2023) = 0.012;
rOblOpsp2Ovf.l[t]$(t.val = 2024) = 0.015;
rOblOpsp2Ovf.l[t]$(t.val = 2025) = 0.018;
rOblOpsp2Ovf.l[t]$(t.val = 2026) = 0.021;
rOblOpsp2Ovf.l[t]$(t.val = 2027) = 0.024;
rOblOpsp2Ovf.l[t]$(t.val = 2028) = 0.027;
rOblOpsp2Ovf.l[t]$(t.val = 2029) = 0.030;
rOblOpsp2Ovf.l[t]$(t.val >=2030) = 0.033;

# Demografisk træk
$GROUP G_GovExpenses_DemoTraek
  fDemoTraek[a,t]$(tx1[t])
  fDemoTraek_Over100[t]$(tx1[t])
;
$IF %FM_baseline%:
  @load(G_GovExpenses_DemoTraek, "../Data/Befolkningsregnskab/DemoTraek.gdx" )
  $GROUP G_FM_Demo
    fDemoTraek_FM[t]  "Finansministeriets opgørelse af det demografisk træk"
  ;
  @load(G_FM_demo, "../Data/FM_exogenous_forecast.gdx")
  uvGxAfskr.l[t]$(tx1[t]) = uvGxAfskr.l[t1] * fDemoTraek_FM.l[t] / fDemoTraek_FM.l[t1];
$ENDIF

$IF %DORS_baseline% or %DREAM_baseline%:
  @load(G_GovExpenses_DemoTraek, "../Data/DREAM_BFR/DemoTraek.gdx" )
$ENDIF


# ----------------------------------------------------------------------------------------------------------------------
# Inventory investments
# ----------------------------------------------------------------------------------------------------------------------
# Det giver ikke mening at have permanent negative lagerinvesteringer, og de svinger meget
set t10[t];
t10[t] = yes$(%cal_deep% - 10 < t.val and t.val <= %cal_deep% and t.val >= %cal_start%);

parameter rIL2Y_mean10[s,t];
rIL2Y_mean10[s,t] = sum(t10, rIL2Y.l[s,t10]) / sum(t10, 1) ;
rIL2Y.l[s,t]$(tx1[t] and fre[s]) = max(rIL2Y_mean10[s,t1], 0.005);
rIL2Y.l[s,t]$(tx1[t] and not fre[s]) = max(rIL2Y_mean10[s,t1], 0);

parameter qIO_iL_mean10[s,t];
parameter qIO_iL_sum[t];
parameter qIO_iL_sum_mean10[t];
parameter qIOm_iL_mean10[s,t];
parameter qIOym_iL_sum[s,t];
parameter qIOym_iL_sum_mean10[s,t];
parameter pnCPI_1[t];
qIO_iL_mean10[s,t] = sum(t10, qIO.l['iL',s,t10]) / sum(t10, 1) ;
qIO_iL_sum[t] = sum(s, qIO.l['iL',s,t]);
qIO_iL_sum_mean10[t] = sum(t10, qIO_iL_sum[t10]) / sum(t10, 1) ;
qIOm_iL_mean10[s,t] = sum(t10, qIOm.l['iL',s,t10]) / sum(t10, 1) ;
qIOym_iL_sum[s,t] = qIOy.l['iL',s,t] + qIOm.l['iL',s,t];
qIOym_iL_sum_mean10[s,t] = sum(t10, qIOym_iL_sum[s,t10]) / sum(t10, 1) ;
pnCPI_1[t] = pnCPI.l[cTot,t-1]/fp;

uIO0.l['iL',s,t]$(tx1[t] and d1IO['iL',s,t]) = max(qIO_iL_mean10[s,t1] / qIO_iL_sum_mean10[t1], 0);
uIOm0.l['iL',s,t]$(tx1[t] and d1IO['iL',s,t]) = min(max(qIOm_iL_mean10[s,t1] / qIOym_iL_sum_mean10[s,t1], 0), 1);
# HACK
uIOm0.l['iL','tje',t]$(t.val > %cal_end%) = 0;
uIOm0.l['iL','udv',t]$(t.val > %cal_end%) = 0;

fuIOym.l['iL',s,t]$(tx1[t] and t.val > tBase.val) = 1;
fuIO.l['iL',t]$(tx1[t] and t.val > tBase.val) = 1;

# Afgifterne på lagerinvesteringer svinger meget - så vi vil ikke bare fremskrive sidste års skattesats
tTold.l['iL',s,t]$(tx1[t] and d1IOm['iL',s,t] and t.val > tBase.val) 
                  = max(@mean(t10, vtTold.l['iL',s,t10]) 
                        / (@mean(t10, vIOm.l['iL',s,t10] - vtIOm.l['iL',s,t10])), 0);
tAfg_y.l['iL',s,t]$(tx1[t] and d1IOy['iL',s,t] and t.val > tBase.val) 
                  = max(@mean(t10, vtAfg_y.l['iL',s,t10]) 
                        / (@mean(t10, pnCPI_1[t10] * qIOy.l['iL',s,t10])), 0);
tAfg_m.l['iL',s,t]$(tx1[t] and d1IOm['iL',s,t] and t.val > tBase.val) 
                  = max(@mean(t10, vtAfg_m.l['iL',s,t10]) 
                        / (@mean(t10, [1 + tTold.l['iL',s,t10]] * pnCPI_1[t10] * qIOm.l['iL',s,t10])), 0);
rSub_y.l['iL',s,t]$(tx1[t] and d1IOy['iL',s,t] and t.val > tBase.val) 
                  = max(@mean(t10, vSub_y.l['iL',s,t10]) 
                        / (@mean(t10, pnCPI_1[t10] * qIOy.l['iL',s,t10])), 0);
rSub_m.l['iL',s,t]$(tx1[t] and d1IOm['iL',s,t] and t.val > tBase.val) 
                  = max(@mean(t10, vSub_m.l['iL',s,t10]) 
                        / (@mean(t10, [1 + tTold.l['iL',s,t10]] * pnCPI_1[t10] * qIOm.l['iL',s,t10])), 0);
tMoms_y.l['iL',s,t]$(tx1[t] and d1IOy['iL',s,t] and t.val > tBase.val) 
                    = max(@mean(t10, vtMoms_y.l['iL',s,t10]) 
                        / (@mean(t10, vIOy.l['iL',s,t10] - vtIOy.l['iL',s,t10] + vtNetAfg_y.l['iL',s,t10])), 0);
tMoms_m.l['iL',s,t]$(tx1[t] and d1IOm['iL',s,t] and t.val > tBase.val) 
                    = max(@mean(t10, vtMoms_m.l['iL',s,t10]) 
                          / (@mean(t10, vIOm.l['iL',s,t10] - vtIOm.l['iL',s,t10] 
                                        + vtNetAfg_m.l['iL',s,t10] + vtTold.l['iL',s,t10])), 0);
                                                
# ----------------------------------------------------------------------------------------------------------------------
# Exogenous forecast of oil and gas extraction
# ----------------------------------------------------------------------------------------------------------------------  
$GROUP G_load_udv
  qY['udv',t]
;
@load_as(G_load_udv, "../Data/FM_exogenous_forecast.gdx", _previous)
qY.l['udv',t]$(tx1[t]) = qY.l['udv',t1] * qY_previous['udv',t] / qY_previous['udv',t1];

# Produktion af olie/gas aftrappes gradvist efter 2040 for at hjælpe konvergens ift. bræt afslutning i fremskrivning
qY.l['udv',t]$(t.val > 2040) = qGrus.l[t] + (qY.l['udv','2040'] - qGrus.l['2040']) * 0.8**((t.val-2040)**1.5);

# Leverancer fra udvinding til eksport skaleres med indenlandsk produktion af udvinding.
# Øvrige leverancer tager tilpasning via. skalering i E_uIOXy.
uIOXy0.l[x,'udv',t]$(tx1[t]) = uIOXy0.l[x,'udv',t1] * (1 + (qY.l['udv',t] - qY.l['udv',t1]) / sum(xx, qIOy.l[xx,'udv',t1]));
uIOXy0.l[x,'udv',t]$(tx1[t]) = max(0, uIOXy0.l[x,'udv',t]);

# ----------------------------------------------------------------------------------------------------------------------
# Dummies and exogenous IO cells
# ----------------------------------------------------------------------------------------------------------------------
# Extend dummies from last calibration year and dummy out cells where scale parameter gets close to zero.
# Scale parameters are set to zero for dummied out cells.
d1IOy[dux,s,t]$(t.val > %cal_end%) = (
  (uIO0.l[dux,s,t] > 0.001)
  and uIOm0.l[dux,s,t] <= 1-0.001
  and d1IOy[dux,s,'%cal_end%']
);
d1IOm[dux,s,t]$(t.val > %cal_end%) = (
  (uIO0.l[dux,s,t] > 0.001)
  and uIOm0.l[dux,s,t] > 0.001
  and d1IOm[dux,s,'%cal_end%']
);
d1IOy[x,s,t]$(t.val > %cal_end%) = (
  uIOXy0.l[x,s,t] > 0.0001
  and d1IOy[x,s,'%cal_end%']
);
d1IOm[x,s,t]$(t.val > %cal_end%) = (
  uIOXm0.l[x,s,t] > 0.0001
  and d1IOm[x,s,'%cal_end%']
);
# If a cell is dummied out, we do not let it re-appear later (even if the scale parameter is above 0.001)
d1IOy[d,s,t]$tx1[t] = smin(tt$(t1.val <= tt.val and tt.val <= t.val), d1IOy[d,s,tt]);
d1IOm[d,s,t]$tx1[t] = smin(tt$(t1.val <= tt.val and tt.val <= t.val), d1IOm[d,s,tt]);

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
uIO0.l[dux,s,t]$(tx1[t] and not d1IO[dux,s,t]) = 0;
uIOm0.l[dux,s,t]$(tx1[t] and not d1IOy[dux,s,t]) = 1;
uIOm0.l[dux,s,t]$(tx1[t] and not d1IOm[dux,s,t]) = 0;
uIOXy0.l[x,s,t]$(tx1[t] and not d1IOy[x,s,t]) = 0;
uIOXm0.l[x,s,t]$(tx1[t] and not d1IOm[x,s,t]) = 0;

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
$IF %FM_baseline% or %DREAM_baseline%:
  execute_unloaddi "Gdx/qProdHh_a_forecast.gdx" qProdHh_a, BruttoArbsty, tDataEnd, tEnd;
  embeddedCode Python:
    with open("age_productivity_forecast.py") as f: exec(f.read())
  endEmbeddedCode
  execute_load "Gdx/qProdHh_a_forecast.gdx" qProdHh_a;
$ENDIF
$IF %DORS_baseline%:
  parameter qProdHh_a_DREAM[a,t];
  execute_load "../Data/DREAM_BFR/qProdHh_a_DREAM.gdx" qProdHh_a_DREAM;
  qProdHh_a.l[a,t]$(t.val > %cal_deep%) = qProdHh_a_DREAM[a,t];
$ENDIF

# ----------------------------------------------------------------------------------------------------------------------
# Fremskrivning af alderspecifikke job-separations-rater
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_exogenous_forecast_aldersprofiler
  rSeparation, srSeparation
;
$GROUP G_exogenous_forecast_aldersprofiler G_exogenous_forecast_aldersprofiler$(tx1[t]);
@load(G_exogenous_forecast_aldersprofiler, "../Data/Aldersprofiler/aldersprofiler.gdx");

# ----------------------------------------------------------------------------------------------------------------------
# Filtrering af aldersafhængige parametre
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_smooth_profiles
  ftBund_a
  ftAktieHh_a
  ftKommune_a
  rTopSkatInd_a
  uPersIndRest_a$(a[a_])
  cHh_a
  rRealKred2Bolig_a
  rKLeje2Bolig_a
  uBoernFraHh_a$(a0t17[a])
  mtIndRest
  mrKomp
  vHhx
  jrHhAktieInd_a
;

# Create orthogonal basis for "vandermonde-space" using arnoldi orthogonalization for numerical stability 
# Vandermonde with Arnoldi
# https://people.maths.ox.ac.uk/trefethen/vandermonde.pdf

$setlocal polygrad 6
sets 
  grader "grader til polynomiel regression" /0*%polygrad%/;
alias(grader,grader_);
parameter 
  v[a] "basisvektor under opbygning"
  qtv "indre produkt i Gram-Schmidt"
  Q[a,grader] "Matrix med ortogonalbasis";

  Q[a,'0'] = 1/sqrt(card(a));
loop(grader$(ord(grader) < card(grader)),
  v[a] = a.val * Q[a,grader];
  loop(grader_$(ord(grader_) <= ord(grader)),
    qtv = sum(a,Q[a,grader_] * v[a]);
    v[a] = v[a] - qtv*Q[a,grader_];
  );
  qtv = sum(a,sqr(v[a]));
  Q[a,grader+1] = v[a]/sqrt(qtv);
);

# ----------------------------------------------------------------------------------------------------------------------
# Aggregation equations for use as smoothing constraints
# ----------------------------------------------------------------------------------------------------------------------
set_time_periods(%cal_deep%-1, %cal_deep%)

$BLOCK B_smooth_aggregation$(t1[t])
E_vHhx_smooth_aTot$(t1[t]).. vHhx[aTot,t] =E= sum(a, vHhx[a,t] * nPop[a,t]);
$ENDBLOCK

# Smooth variables 

# ---- ftBund_a ----
@smooth_setup(ftBund_a, a15t100, 5)

$GROUP+ G_smooth_ftBund_a_endo
  vtBund$(a15t100[a_])
  ftBund$(a15t100[a_])
;
$MODEL M_smooth_ftBund_a
  B_smooth_ftBund_a
  E_vtBund_a
  E_vtBund_aTot
  E_ftBund_a
;

@smooth_solve(ftBund_a)

# ---- ftAktieHh_a ----
@smooth_setup(ftAktieHh_a, a15t100, 4)

$GROUP+ G_smooth_ftAktieHh_a_endo
  vtAktieHh$(a15t100[a_])
  ftAktieHh$(a15t100[a_])
;
$MODEL M_smooth_ftAktieHh_a
  B_smooth_ftAktieHh_a
  E_vtAktieHh_a
  E_vtAktieHh_aTot
  E_ftAktieHh_a
;

@smooth_solve(ftAktieHh_a)

# ---- ftKommune_a ----
@smooth_setup(ftKommune_a, a15t100, 5)

$GROUP+ G_smooth_ftKommune_a_endo
  vtKommune$(a15t100[a_])
  ftKommune$(a15t100[a_])
;
$MODEL M_smooth_ftKommune_a
  B_smooth_ftKommune_a
  E_vtKommune_a
  E_vtKommune_aTot
  E_ftKommune_a
;

@smooth_solve(ftKommune_a)

# ---- rTopSkatInd_a ----
@smooth_setup(rTopSkatInd_a, a15t100, 3)

$GROUP+ G_smooth_rTopSkatInd_a_endo
  vtTop$(a15t100[a_])
  rTopSkatInd$(a15t100[a_])
;
$MODEL M_smooth_rTopSkatInd_a
  B_smooth_rTopSkatInd_a
  E_vtTop_a
  E_vtTop_aTot
  E_rTopSkatInd_a
;

@smooth_solve(rTopSkatInd_a)

# ---- uPersIndRest_a ----
@smooth_setup(uPersIndRest_a, a15t100, 5)

$GROUP+ G_smooth_uPersIndRest_a_endo
  vPersIndRest$(a15t100[a_])
  vPersIndx$(a15t100[a_])
  vPersInd$(a15t100[a_])
;
$MODEL M_smooth_uPersIndRest_a
  B_smooth_uPersIndRest_a
  E_vPersIndRest_a
  E_vPersIndx_a
  E_vPersInd_a
  E_vPersInd_aTot
;

@smooth_solve(uPersIndRest_a)

# ---- rRealKred2Bolig_a ----
@smooth_setup(rRealKred2Bolig_a, a18t100, 4)

$GROUP+ G_smooth_rRealKred2Bolig_a_endo
  rRealKred2Bolig$(a18t100[a_])
  vHhPas$(RealKred[portf_] and a18t100[a_])
;
$MODEL M_smooth_rRealKred2Bolig_a
  B_smooth_rRealKred2Bolig_a
  E_rRealKred2Bolig
  E_vHhPas_RealKred
  E_vHhPas_RealKred_aTot
;

@smooth_solve(rRealKred2Bolig_a)

# ---- rKLeje2Bolig_a ----
@smooth_setup(rKLeje2Bolig_a, a18t100, 6)

$GROUP+ G_smooth_rKLeje2Bolig_a_endo
  qKLejeBolig[a18t100,t]
  rKLeje2Bolig[a18t100,t]
;
$MODEL M_smooth_rKLeje2Bolig_a
  B_smooth_rKLeje2Bolig_a
  E_rKLeje2Bolig_a
  E_rKLeje2Bolig_a_a
  E_qKLejeBolig_aTot
;

@smooth_solve(rKLeje2Bolig_a)

# ---- uBoernFraHh_a ----
@smooth_setup(uBoernFraHh_a, a0t17, 3)

$GROUP+ G_smooth_uBoernFraHh_a_endo
  uBoernFraHh$(a0t17[a])
  vHhx$(a0t17[a_])
;
$MODEL M_smooth_uBoernFraHh_a
  B_smooth_uBoernFraHh_a
  E_uBoernFraHh_a
  E_vBoernFraHh_a
  E_vHhx_smooth_aTot
;

@smooth_solve(uBoernFraHh_a)

# ---- mtIndRest ----
@smooth_setup(mtIndRest, a15t100, 5)

$MODEL M_smooth_mtIndRest
  B_smooth_mtIndRest
;

@smooth_solve(mtIndRest)

# ---- mrKomp ----
@smooth_setup(mrKomp, a15t100, 5)

$MODEL M_smooth_mrKomp
  B_smooth_mrKomp
;

@smooth_solve(mrKomp)

# ---- vHhx ----
@smooth_setup(vHhx, a0t100, 4)

$MODEL M_smooth_vHhx
  B_smooth_vHhx
  E_vHhx_smooth_aTot
;

@smooth_solve(vHhx)

# ---- jrHhAktieInd_a ----
@smooth_setup(jrHhAktieInd_a, a15t100, 3)

$GROUP+ G_smooth_jrHhAktieInd_a_endo
  jrHhAktieInd$(a15t100[a_])
  vHhAktieInd$(a15t100[a_])
;
$MODEL M_smooth_jrHhAktieInd_a
  B_smooth_jrHhAktieInd_a
  E_jrHhAktieInd_a
  E_vHhAktieInd_a
  E_vHhAktieInd_aTot
;

@smooth_solve(jrHhAktieInd_a)

# ---- cHh_a (Obl) ----
@smooth_setup_with_set(cHh_a, Obl, a0t100, 4)

$GROUP+ G_smooth_cHh_a_Obl_endo
  vHhAkt$(fin_akt[portf_] and d1vHhAkt[portf_,t] and a[a_])
;
$MODEL M_smooth_cHh_a_Obl
  B_smooth_cHh_a_Obl
  E_vHhAkt
  E_cHh_a_aTot
;

@smooth_solve_with_set(cHh_a, Obl)

# ---- cHh_a (RealKred) ----
@smooth_setup_with_set(cHh_a, RealKred, a0t100, 4)

$GROUP+ G_smooth_cHh_a_RealKred_endo
  vHhAkt$(fin_akt[portf_] and d1vHhAkt[portf_,t] and a[a_])
;
$MODEL M_smooth_cHh_a_RealKred
  B_smooth_cHh_a_RealKred
  E_vHhAkt
  E_cHh_a_aTot
;

@smooth_solve_with_set(cHh_a, RealKred)

# ---- cHh_a (IndlAktier) ----
@smooth_setup_with_set(cHh_a, IndlAktier, a0t100, 2)

$GROUP+ G_smooth_cHh_a_IndlAktier_endo
  vHhAkt$(fin_akt[portf_] and d1vHhAkt[portf_,t] and a[a_])
;

$MODEL M_smooth_cHh_a_IndlAktier
  B_smooth_cHh_a_IndlAktier
  E_vHhAkt
  E_cHh_a_aTot
;

@smooth_solve_with_set(cHh_a, IndlAktier)

# ---- cHh_a (UdlAktier) ----
@smooth_setup_with_set(cHh_a, UdlAktier, a0t100, 3)

$GROUP+ G_smooth_cHh_a_UdlAktier_endo
  vHhAkt$(fin_akt[portf_] and d1vHhAkt[portf_,t] and a[a_])
;
$MODEL M_smooth_cHh_a_UdlAktier
  B_smooth_cHh_a_UdlAktier
  E_vHhAkt
  E_cHh_a_aTot
;

@smooth_solve_with_set(cHh_a, UdlAktier)

# ---- cHh_a (Bank) ----
@smooth_setup_with_set(cHh_a, Bank, a0t100, 4)

$GROUP+ G_smooth_cHh_a_Bank_endo
  vHhAkt$(fin_akt[portf_] and d1vHhAkt[portf_,t] and a[a_])
;
$MODEL M_smooth_cHh_a_Bank
  B_smooth_cHh_a_Bank
  E_vHhAkt
  E_cHh_a_aTot
;

@smooth_solve_with_set(cHh_a, Bank)

jvFormueBase.l[a,t1] = vHhx.l[a,t2] - vHhx_presmooth[a,t1];

# ----------------------------------------------------------------------------------------------------------------------
# Clear large objects that we no longer need from memory
# ----------------------------------------------------------------------------------------------------------------------
option clear = nOvf_a;
option clear = nOvfFraSocResidual;
@unload_all(Gdx/exogenous_forecast);
