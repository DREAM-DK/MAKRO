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
d1vHh[portf_,tx1]$(not pens[portf_]) = d1vHh[portf_,t1];

set load_d1vHh[portf_, t];
execute_load "..\Data\aldersprofiler\aldersprofiler.gdx", load_d1vHh = d1vHh;
d1vHh[portf_,t]$(pens[portf_]) = load_d1vHh[portf_, t];

# ----------------------------------------------------------------------------------------------------------------------
# Extend the last calibration as our forecast of parameters
# ----------------------------------------------------------------------------------------------------------------------
$LOOP All:
  #Select all variables in forecast period - set them equal to their value in the final data year
  {name}.l{sets}{$}[<t>tx1]${conditions} = {name}.l{sets}{$}[<t>t1];
  #Select all variables in the forecast year given that their value in the final data-year is equal to 1 or 0 - set them equal to their value in the year before the final data-year
  {name}.l{sets}{$}[<t>tx1]$({conditions} and ({name}.l{sets}{$}[<t>t1] = 1 or {name}.l{sets}{$}[<t>t1] = 0)) = sum(t$(t.val = t1.val - 1), {name}.l{sets});
$ENDLOOP
# Except those explictly added to G_exogenous_forecast and G_forecast_as_zero (fx demographic forecast)
$FIX(0) G_exogenous_forecast;
$FIX(0) G_forecast_as_zero;

# ----------------------------------------------------------------------------------------------------------------------
# Produktivitet
# ----------------------------------------------------------------------------------------------------------------------
rProdVaekst.l[t]$(tx1[t]) = gq;

# ----------------------------------------------------------------------------------------------------------------------
# Load ARIMA forecasts
# ----------------------------------------------------------------------------------------------------------------------
@load(G_ARIMA_forecast$[tx1[t]], "Gdx\ARIMA_forecasts.gdx")

# Add aggregate trends to variables (removed prior to fitting ARIMAs)
uXy.l[x,t] = uXy.l[x,t] * uXy.l[xTot,t];
uXm.l[x,t] = uXm.l[x,t] * uXm.l[xTot,t];

rAfskr.l[k,s,t] = rAfskr.l[k,s,t] * rAfskr.l[k,sTot,t];

uK.l[k,sp,t] = uK.l[k,sp,t] * uK.l[k,spTot,t];
uL.l[sp,t] = uL.l[sp,t] * uL.l[spTot,t];
uKL.l[sp,t] = uKL.l[sp,t] * uKL.l[spTot,t];
uKLB.l[sp,t] = uKLB.l[sp,t] * uKLB.l[spTot,t];
uR.l[sp,t] = uR.l[sp,t] * uR.l[spTot,t];

@save_as(G_ARIMA_forecast, _ARIMA)

# ----------------------------------------------------------------------------------------------------------------------
# Load pension forecasts
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_exogenous_forecast_pension
  rPensUdb_a[pens,a,t]$(tx1[t])
  rPensArv$(tx1[t])
  rPensIndb2loensum$(tx1[t])
  rPensAfk2Pens$(tx1[t])

;
@load(G_exogenous_forecast_pension, "..\Data\pension\pension.gdx") ;

# ----------------------------------------------------------------------------------------------------------------------
# Load demographic forecasts (BFR)
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_exogenous_forecast_BFR
  rOverlev, ErOverlev, rSeparation, srSeparation, snLHh, shLHh, rBoern
  dSoc2dBesk, dSoc2dPop
  nPop, nLxDK
;
$GROUP G_exogenous_forecast_BFR G_exogenous_forecast_BFR$(tx1[t]);
@load(G_exogenous_forecast_BFR, "..\Data\Befolkningsregnskab\BFR.gdx");

# Load parametre fra befolkningsregnskab (BFR)
$GDXIN ..\Data\Befolkningsregnskab\BFR.gdx
  $LOAD nOvf_a, nOvfFraSocResidual
$GDXIN

# ----------------------------------------------------------------------------------------------------------------------
# Exogenous forecasts based on BFR
# ---------------------------------------------------------------------------------------------------------------------- 
# Aldersmæssig fordelingsnøgle knyttet til dvOvf2dPop 
# Korrekt såfremt at overførsler knyttet til dvOvf2dPop vokser med samme rate, fx satsregulering
uHhOvfPop.l[a,t]$(a15t100[a] and tx1[t]) =          
  sum(ovfhh, vOvfSats.l[ovfhh,t1] * nOvfFraSocResidual[ovfhh,a,t]) / nPop.l[a,t]  # Samlede overførsler pr. person i alder a, som ikke afhænger af beskæftigelsesfrekvens
/ sum(ovfhh, vOvfSats.l[ovfhh,t1] * nOvfFraSocResidual[ovfhh,aTot,t]) * nPop.l['a15t100',t];  # Samlede overførsler i alt, som ikke afhænger af beskæftigelsesfrekvens

# vOvfUbeskat er endogen, men beregnes som hjælpevariabel til beregning af uOvfUbeskat
# Vi antager at satsregulerede overførsler vorkser med fv, mens at resten nominelt udfases
vOvfUbeskat.l[a,t]$(a15t100[a] and nPop.l[a,t] and tx1[t]) = (
      sum(ovf$(ubeskat[ovf] and satsreg[ovf]), vOvfSats.l[ovf,t1] * nOvf_a[ovf,a,t])
    + sum(ovf$(ubeskat[ovf] and not satsreg[ovf]), vOvfSats.l[ovf,t1] * inf_growth_factor[t] / inf_growth_factor[t1] * nOvf_a[ovf,a,t])
  ) / nPop.l[a,t];
vOvfUbeskat.l[aTot,t]$(tx1[t]) = sum(a, vOvfUbeskat.l[a,t] * nPop.l[a,t]);
uOvfUbeskat.l[a,t]$(vOvfUbeskat.l[a,t] <> 0 and  tx1[t]) = vOvfUbeskat.l[a,t]  / (vOvfUbeskat.l[aTot,t] / sum(aa, nPop.l[aa,t]));

nArvinger.l[a,t]$(tx1[t]) = sum(aa, rArv_a.l[a-1,aa-1] * nPop.l[aa,t]);

d1Arv[a,t]$(a18t100[a]) = (ErOverlev.l[a,t] < 0.995); # Kun aldersgrupper med forventet dødssansynlighed over 0.5% har arvemotiv

# ----------------------------------------------------------------------------------------------------------------------
# Inventory investments
# ----------------------------------------------------------------------------------------------------------------------
# In forecast years tax rates on net inventory investments follow the tax on material inputs.
# As inventory investments are net, but tax revenue is gross, the imputed tax rates are nonsense. 
rSub_y0.l['iL',s,tx1] = rSub_y0.l[s,s,t1];
rSub_m0.l['iL',s,tx1] = rSub_m0.l[s,s,t1];
tTold.l['iL',s,tx1] = tTold.l[s,s,t1];
tMoms_y.l['iL',s,tx1] = tMoms_y.l[s,s,t1];
tMoms_m.l['iL',s,tx1] = tMoms_m.l[s,s,t1];

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

rIndlAktiePrem.l[sp,t]$(tx1[t]) = max(0.03, 0.07 - rRente.l['Obl',t]);  # Om risikopræmie, se https://www.pwc.dk/da/publikationer/2020/vaerdiansaettelse-af-virk-pub.pdf og https://www.nationalbanken.dk/da/publikationer/Documents/2020/02/Eonomic%20Memo%20No.1_Do%20equity%20prices.pdf
rVirkDiskPrem.l[sp,t]$(tx1[t]) = rIndlAktiePrem.l[sp,t];
rBoligPrem.l[t]$(tx1[t]) = rIndlAktiePrem.l['bol',t];

# Sammensætningseffekt af ændrede uddannelsesbaggrunde etc. for offentligt ansatte
fpYoff.l[t]$(tx1[t]) = 1.0008;

vNulvaekstIndeks.l[t]$(tx1[t]) = inf_growth_factor[t];

# ----------------------------------------------------------------------------------------------------------------------
# Public finances
# ----------------------------------------------------------------------------------------------------------------------
# Særligt væsentlige offentlige-finansposter sættes for at opnå en rimelig holdbarhed mv. i den dybe kalibrering

# Vi fremskriver aktieskat ved konstant provenue som andel af privat-sektor-BVT
# baseret på gennemsnit af de seneste 10 år op til det dybe kalibreringsår
set t10[t];
t10[t] = yes$(%cal_deep% - 10 < t.val and t.val <= %cal_deep%);
rvtAktie2BVT.l[t]$(tx1[t]) = @mean(t10, rvtAktie2BVT.l[t10]);

# Korrektionsfaktor på selskabsskat fremskrives direkte (pga. ændringer i selskabsskattesats)
ftSelskab.l[t]$(tx1[t]) = @mean(t10, ftSelskab.l[t10]); 

# Medielicens afskaffes gradvist fremtil 2021 i data, her er vi mest interesseret i den langsigtede værdi
utMedie.l[t]$(t.val > 2021) = 0;

fHBIDisk.l[tHBI] = 1; # I tilfælde af at tHBI > t1

# ----------------------------------------------------------------------------------------------------------------------
# Exogenous forecasts re-uses from previous forecast
# ----------------------------------------------------------------------------------------------------------------------  
$GROUP G_load_from_previous_forecast
  fDemoTraek
  qY$(udv[s_])
  qXy$(xEne[x_])
  rtKilde2Loensum # Restfradrag sættes markant højere i fremskrivning, svarende til FMs mellemfristede fremskriving (skal tjekkes efter!)
;
$GROUP G_load_from_previous_forecast G_load_from_previous_forecast$(tx1[t]);
@load(G_load_from_previous_forecast, "Gdx\previous_smooth_calibration.gdx" )

# ----------------------------------------------------------------------------------------------------------------------
# Dummies and exogenous IO cells
# ----------------------------------------------------------------------------------------------------------------------
# Set scale parameters to zero and dummy out very small cells
# Dummy out cells where:
# 1) value of IO cell is below 1mn in all years
# 2) value of IO cell is 0 in last calibration year, or
# 3) The forecasted scale parameter is below 0.001
d1IOm[dux,s,t]$tx1[t] = (
  uIO0.l[dux,s,t] > 0.001
  and uIOm0.l[dux,s,t] > 0.001
  and sum(tData, vIOm.l[dux,s,tData]) > 0.001
  and vIOm.l[dux,s,t1] >= 0
);
d1IOy[dux,s,t]$tx1[t] = (
  uIO0.l[dux,s,t] > 0.001
  and uIOm0.l[dux,s,t] <= 1-0.001
  and sum(tData, vIOy.l[dux,s,tData]) > 0.001
  and vIOy.l[dux,s,t1] >= 0
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
d1I_s['iL',s,t]$tx1[t] = yes$(rIL2y.l[s,t] > 0 and uIO0.l['iL',s,t] > 0);
rIL2y.l[s,t]$(not d1I_s['iL',s,t]) = 0;
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
# Save snapshot of forecasts, to check that all forecasts are intact after calibration.
# ----------------------------------------------------------------------------------------------------------------------
@save_as(G_exogenous_forecast, _data)
@save_as(G_forecast_as_zero, _data)

# ----------------------------------------------------------------------------------------------------------------------
# Clear large objects that we no longer need from memory
# ----------------------------------------------------------------------------------------------------------------------
option clear = nOvf_a;
option clear = nOvfFraSocResidual;
@unload_all(Gdx\exogenous_forecast);
