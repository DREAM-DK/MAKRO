# ----------------------------------------------------------------------------------------------------------------------
# Bounds
# Bounds are added to all endogenous variables to prevent bugs that are extremely difficult to track
# ----------------------------------------------------------------------------------------------------------------------
$GROUP G_negative_allowed  # Prices or quantities variables that can be negative
  pI$(iL[i_]), pI_s$(iL[i_]), pIO$(iL[d_]), pIOy$(iL[d_])
  pILager, pIStam, pIVaerdi

  pCPI, pnCPI # Disse bør fjernes med dummies i modulet istedet
  pBoligUC
  pBVT
  
  qBolig, qBolig_h
  qCx[a,t]$(%AgeData_t1% < t.val and t.val <= %cal_end%) # Negative aldersfordelte tal kan forekomme i statisk kalibrering, uden for år med aldersfordelt data
  qCx_h[h,a,t]$(%AgeData_t1% < t.val and t.val <= %cal_end%)
  qI, qI_s, qIBolig, qILager, qIStam, qIVaerdi
  qOffIndirInv, pOffIndirInv, fpOffIndirInv
  qIO$(i_[d_]), qIOy$(i_[d_]), qIOm$(i_[d_])
  qIO$(xSoe[d_] and t.val < 1991), qIOy$(xSoe[d_] and t.val < 1991)
  qIO$(udv[s_] and t.val < 2001), qIOy$(udv[s_] and t.val < 2001), qIOm$(udv[s_] and t.val < 1991)
  qHandelsbalance
  qProdxDK$(t.val < 2000) # Der er negativ aflønninger af grænsearbejdere i "data" før 2000 - dette bør rettes
  dqL2dnL, dqL2dnLlag
  qIO$(sameas('bol',d_) and sameas('byg',s_) and t.val = 1973) # Negativ IO-celle
  dvVirk2dpW
  sdvVirk2dpW
  ptNetYOff, qtNetYOff

  $LOOP G_forecast_as_zero: # Typisk j-led som gerne må være negative
    {name}
  $ENDLOOP

  qKInstOmk # Disse kan kalibreres til eksakt nul, hvorefter at bound kan give løsningsproblemer.

  pYfixed

  dpM2pYTraeghed
  pIOm$(iL[d_] and t.val = 1991)
;
$GROUP G_lower_bound # Variables that should be positive and not be close to zero
  qKELB, qY, qR, qX, qBNP, qBVT,
  srMatch, rpXy2pXUdl
  uh, hLHh
  nOpslag$(sTot[s_]), snOpslag
  pOlieBrent
  pLUdn, pKUdn
  qFormueBase, qArvBase
  qCxRef, qBoligxRef, qNytte
;
$GROUP G_well_scaled # Variables bounded close to 1 (prices are included here by default, to avoid negative prices and chain indices going to infinity)
  G_prices, -G_negative_allowed, -G_lower_bound
  rKUdn, rpIOm2pIOy,
  rSoeg2Opslag, srSoeg2Opslag
;
$GROUP G_zero_bound  # Variables with a lower bound very close to zero
  G_quantities, -G_negative_allowed, -G_well_scaled, -G_lower_bound
  -qIO$(sameas('cBol',d_) and sameas('lan',s_)) # Hvis denne ikke er slået fra bliver qIO['cBol','lan',t] = 0 i et par år, hvor den er meget lille mindre end 1e-9. Dette giver pivot-fejl i static-modellen. Den har åbenbart her brug for at lede i det negative område for ikke at sætte den til 0. Ved ikke helt hvorfor. 
;
$GROUP G_default_bounds
  All, -G_well_scaled, -G_lower_bound, -G_zero_bound, -G_government_nv
;

# Set bounds on three groups, G_lower_bound, G_zero_bound, and G_well_scaled
$FUNCTION set_bounds():
  @bound(G_default_bounds, -1e7, 1e7);
  @bound(G_lower_bound, 0.001, 1e7);
  @bound(G_zero_bound, 0, 1e7);
  @bound(G_well_scaled, 0.01, 100);

  @bound(rSoegBaseHh, -1, 1-1e-6); # Sligthly negative numbers are not a big issue for these (e.g. for 100 year olds), but 1 leads to division by zero
  @bound(srSoegBaseHh, -1, 1-1e-6);
$ENDFUNCTION

# Variables for which _data parameter is used,
# to get around having a base year later than the deep calibration year. 
$GROUP G_data_variables
  pOlieBrent
  rDollarKurs
  qBVTUdl
;
@set(G_data_variables, _data, .l)
