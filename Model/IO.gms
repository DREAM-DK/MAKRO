# ======================================================================================================================
# Input Output system
# - This module handles the details of the IO system.
#   The different demand components are satisfied with domestic production competing with imports.
# ======================================================================================================================

# ======================================================================================================================
# Variable definition
# - Define variables and group them based on endogeneity, inflation or growth adjustment, and how they should be forecast (if exogenous)
# ======================================================================================================================
$IF %stage% == "variables":
  $GROUP G_IO_prices_endo
    pY[s_,t]$(off[s_] or sTot[s_] or spTot[s_] or sByTot[s_]) "Produktionsdeflator fordelt på brancher, Kilde: ADAM[pX] eller ADAM[pX<i>]"
    pM[s_,t]$(sTot[s_]) "Importdeflator fordelt på importgrupper, Kilde: ADAM[pM] eller ADAM[pM<i>]"
    pBVT[s_,t] "BVT-deflator, Kilde: ADAM[pyf] eller ADAM[pyf<i>]"
    pBNP[t] "BNP-deflator, Kilde: ADAM[pY]"

    pIO[d_,s_,t]$(dux_[d_] and d1IO[d_,s_,t] and s[s_]) "Imputeret deflator for branchefordelte leverancer fra både import og indenlandsk produktion fordelt på efterspørgselskomponenter."
    pIOy[d_,s_,t]$((d1IOy[d_,s_,t] or d1IOy[d_,s_,t+1]) and s[s_]) "Imputeret deflator for branchefordelte leverancer fra indenlandsk produktion fordelt på efterspørgselskomponenter."
    pIOm[d_,s_,t]$((d1IOm[d_,s_,t] or d1IOm[d_,s_,t+1]) and s[s_]) "Imputeret deflator for branchefordelte leverancer fra import fordelt på efterspørgselskomponenter."

    pX[x_,t] "Eksportdeflator fordelt på eksportgrupper, Kilde: ADAM[pe] eller ADAM[pe<i>]"
    pXm[x_,t]$(d1Xm[x_,t]) "Deflator på import til reeksport."
    pXy[x_,t] "Deflator på direkte eksport."
    pR[r_,t] "Deflator på materiale-input fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[pvm] eller ADAM[pvm<i>]"
    pE[r_,t] "Deflator på energi-input fordelt på aftager-brancher, Kilde: ADAM[pvm] eller ADAM[pvm<i>]"
    pCDK[c_,t]$(c[c_] or cTot[c_]) "Forbrugsdeflator for forbrug inkl. turisters fordelt på forbrugsgrupper, Kilde: ADAM[pC<i>]"
    pCTurist[c,t]$(d1CTurist[c,t]) "Price index of tourists consumption by consumption group."
    pG[g_,t] "Deflator for offentligt forbrug, Kilde: ADAM[pco]"
    pI[i_,t] "Investeringsdeflator fordelt på investeringstyper, Kilde: ADAM[pI] eller ADAM[pim] eller ADAM[pib]"
    pI_s[i_,s_,t]$(d1I_s[i_,s_,t] and s[s_]) "Investeringsdeflator fordelt på brancher, Kilde: ADAM[pI<i>] eller ADAM[pim<i>] eller ADAM[pib<i>]"
    pI_s[i_,s_,t]$(i[i_] and not iL[i_] and (spTot[s_] or sByTot[s_])) "Investeringsdeflator fordelt på brancher, Kilde: ADAM[pI<i>] eller ADAM[pim<i>] eller ADAM[pib<i>]"

    pC[c_,t]$(c[c_] or cTot[c_]) "Imputeret prisindeks for forbrugskomponenter for husholdninger - dvs. ekskl. turisters forbrug."

    # Tabel-variable
    pRE[r_,t]$(r[r_] or rTot[r_]) "Deflator for aggregeret materiale- og energiinput fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[pv] eller ADAM[pv<i>]"
    pBruttoHandel[t] "Kædeprisindeks for eksport + import"
    pCGIX[t]$(t.val >= 1995) "Deflator for samlet efterspørgsel"
    pCGI[t] "Deflator for indenlandsk efterspørgsel"
    pCGIxLager[t] "Deflator for indenlandsk efterspørgsel ekskl. lagerinvesteringer"
    pIbm[t] "Deflator for investeringer ekskl. lagerinvesteringer"
    pIErhverv[t] "Deflator for private investeringer ekskl. lager- og boliginvesteringer"
    pIbErhverv[t] "Deflator for private bygningsinvesteringer ekskl. boliginvesteringer"
    pILager[t] "Deflator for lagerinvesteringer alene dvs. ekskl. stambesætninger og værdigenstande"
    pIStam[t] "Deflator for stambesætninger"
    pIVaerdi[t] "Deflator for værdigenstande"
    pMvarer[t] "Deflator for samlet vareimport"
    pMenergi[t] "Deflator for samlet import af energi"
    pMtjenester[t] "Deflator for samlet tjenesteimport"
    pMx[t] "Deflator for import af tjenester (ekslusiv søtransport) og fremstilling."
    pXvarer[t] "Deflator for samlet vareeksport inkl. energi"
    pXtjenester[t] "Deflator for samlet tjenesteeksport inkl. søfart og turisme"
    pBVTspxudv[t] "Deflator for BVT i private brancher ekskl. udvinding"

    jfpIOy_s[s_,t] "J-led."
    jfpIOm_s[s_,t]$(m[s_]) "J-led."
  ;
  $GROUP G_IO_quantities_endo
    qY[s_,t]$(not (udv[s_] or bol[s_]) and not off[s_]) "Produktion fordelt på brancher, Kilde: ADAM[fX]"
    qM[s_,t] "Import fordelt på importgrupper, Kilde: ADAM[fM] eller ADAM[fM<i>]"
    qBVT[s_,t] "BVT, Kilde: ADAM[fYf] eller ADAM[fYf<i>]"
    qBNP[t] "BNP, Kilde: ADAM[fY]"

    qIO[d_,s_,t]$(dux_[d_] and d1IO[d_,s_,t]) "Imputeret branchefordelte leverancer fra både import og indenlandsk produktion fordelt på efterspørgselskomponenter."
    qIOy[d_,s_,t]$(d1IOy[d_,s_,t]) "Imputeret branchefordelte leverancer fra indenlandsk produktion fordelt på efterspørgselskomponenter."
    qIOm[d_,s_,t]$(d1IOm[d_,s_,t]) "Imputeret branchefordelte leverancer fra import fordelt på efterspørgselskomponenter."

    qR[r_,t]$(not r[r_]) "Materialeinput fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[fVm] eller ADAM[fVm<i>]"
    qE[r_,t]$(not r[r_]) "Energiinput fordelt på aftager-brancher, Kilde: ADAM[fVe] eller ADAM[fVe<i>]"
    qCDK[c_,t]$(c[c_] or cTot[c_]) "Det private forbrug inkl. turisters fordelt på forbrugsgrupper, Kilde: ADAM[fC<i>]"
    qC[c_,t]$(cTot[c_]) "Husholdningernes samlede forbrug fordelt på forbrugsgrupper og aggregater inkl. lejebolig og imputeret ejerbolig. Kilde: ADAM[fCp]"
    qI[i_,t] "Investeringer fordelt på investeringstype, Kilde: ADAM[fI] eller ADAM[fIm] eller ADAM[fIb]"  
    qI_s[i_,s_,t]$(iTot[i_] and s[s_]) "Investeringer fordelt på brancher, Kilde: ADAM[fI<i>] eller ADAM[fIm<i>] eller ADAM[fIb<i>]"
    qI_s[i_,s_,t]$(i[i_] and not iL[i_] and (spTot[s_] or sbyTot[s_])) "Investeringer fordelt på brancher, Kilde: ADAM[fI<i>] eller ADAM[fIm<i>] eller ADAM[fIb<i>]"

    # Tabel-variable
    qRE[r_,t]$(r[r_] or rTot[r_]) "Aggregeret materiale- og energiinput fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[fV] eller ADAM[fV<i>]"
    qHandelsbalance[t] "Real handelsbalance"
    qBruttoHandel[t] "Eksport + import i kædepriser"
    qCGIX[t]$(t.val >= 1995) "Samlet efterspørgsel"
    qCGI[t] "Indenlandsk efterspørgsel"
    qCGIxLager[t] "Indenlandsk efterspørgsel ekskl. lagerinvesteringer"
    qIbm[t] "Investeringer ekskl. lagerinvesteringer"
    qIErhverv[t] "Private investeringer ekskl. lager- og boliginvesteringer"
    qIbErhverv[t] "Private bygningsinvesteringer ekskl. boliginvesteringer"
    qILager[t] "Lagerinvesteringer alene dvs. ekskl. stambesætninger og værdigenstande"
    qIStam[t] "Stambesætninger"
    qIVaerdi[t] "Værdigenstande"
    qMvarer[t] "Samlet vareimport"
    qMenergi[t] "Samlet import af energi"
    qMtjenester[t] "Samlet tjenesteimport"
    qMx[t] "Real import af tjenester (ekslusiv søtransport) og fremstilling."
    qXvarer[t] "Samlet vareeksport inkl. energi"
    qXtjenester[t] "Samlet tjenesteeksport inkl. søfart og turisme"
    qBVTspxudv[t] "BVT i private brancher ekskl. udvinding"
  ;
  $GROUP G_IO_values_endo
    vY[s_,t]$(sp[s_] or sTot[s_] or spTot[s_] or sByTot[s_]) "Produktionsværdi fordelt på brancher, Kilde: ADAM[X] eller ADAM[X<i>]"
    vM[s_,t]$(s[s_] or sTot[s_]) "Import fordelt på importgrupper, Kilde: ADAM[M] eller ADAM[M<i>]"
    vBVT[s_,t] "BVT, Kilde: ADAM[Yf] eller ADAM[Yf<i>]"
    vBNP[t] "BNP, Kilde: ADAM[Y]"

    vIO[d_,s_,t]$(d1IO[d_,s_,t]) "Imputeret branchefordelte leverancer fra både import og indenlandsk produktion fordelt på efterspørgselskomponenter."
    vIOy[d_,s_,t]$(d1IOy[d_,s_,t]) "Imputeret branchefordelte leverancer fra indenlandsk produktion fordelt på efterspørgselskomponenter."
    vIOm[d_,s_,t]$(d1IOm[d_,s_,t]) "Imputeret branchefordelte leverancer fra import fordelt på efterspørgselskomponenter."

    vX[x_,t] "Eksport fordelt på eksportgrupper, Kilde: ADAM[E] eller ADAM[E<i>]"
    vXy[x_,t] "Direkte eksport fordelt på eksportgrupper."
    vXm[x_,t] "Import til reeksport fordelt på eksportgrupper."
    vR[r_,t] "Materialeinput fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[Vm] eller ADAM[Vm<i>]"
    vE[r_,t] "Energiinput fordelt på aftager-brancher, Kilde: ADAM[Ve] eller ADAM[Ve<i>]"
    vC[c_,t]$(cTot[c_] or c[c_]) "Husholdningernes samlede forbrug fordelt på forbrugsgrupper og aggregater inkl. lejebolig og imputeret ejerbolig. Kilde: ADAM[Cp]"
    vCTurist[c,t]$(d1CTurist[c,t]) "Turisters forbrug i Danmark fordelt på forbrugsgrupper."
    vCDK[c_,t]$(cTot[c_] or c[c_]) "Det private forbrug inkl. turisters fordelt på forbrugsgrupper, Kilde: ADAM[Cp] + ADAM[Et] og ADAM[C<i>]"
    vG[g_,t] "Offentligt forbrug, Kilde: ADAM[Co]"
    vI[i_,t] "Investeringer fordelt på investeringstype, Kilde: ADAM[I] eller ADAM[iM] eller ADAM[iB]"
    vI_s[i_,s_,t]$(d1I_s[i_,s_,t] and i[i_] and sp[s_]) "Investeringer fordelt på brancher, Kilde: ADAM[I<i>] eller ADAM[iM<i>] eller ADAM[iB<i>]"
    vI_s[i_,s_,t]$(iTot[i_] and (s[s_] or spTot[s_])) "Investeringer fordelt på brancher, Kilde: ADAM[I<i>] eller ADAM[iM<i>] eller ADAM[iB<i>]"
    vI_s[i_,s_,t]$(i[i_] and not iL[i_] and (spTot[s_] or sByTot[s_])) "Investeringer fordelt på brancher, Kilde: ADAM[I<i>] eller ADAM[iM<i>] eller ADAM[iB<i>]"

    # Tabel-variable
    vRE[r_,t]$(r[r_] or rTot[r_]) "Aggregeret materiale- og energiinput fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[V] eller ADAM[V<i>]"
    vHandelsbalance[t] "Nominel handelsbalance (nettoeksport)"
    vCGIX[t]$(t.val >= 1995) "Samlet efterspørgsel"
    vCGI[t] "Indenlandsk efterspørgsel"
    vCGIxLager[t] "Indenlandsk efterspørgsel ekskl. lagerinvesteringer"
    vIbm[t] "Investeringer ekskl. lagerinvesteringer"
    vIErhverv[t] "Erhvervsinvesteringer: Private investeringer ekskl. boliginvesteringer, lagerinv. og værdigenstande, men inkl. stambesætninger"
    vIbErhverv[t] "Erhvervsinvesteringer i bygninger: Private bygningsinvesteringer ekskl. boliginvesteringer"
    vILager[t] "Lagerinvesteringer alene dvs. ekskl. stambesætninger og værdigenstande"
    vIStam[t] "Stambesætninger"
    vIVaerdi[t] "Værdigenstande"
    vMvarer[t] "Samlet vareimport"
    vMenergi[t] "Samlet import af energi"
    vMtjenester[t] "Samlet vareimport"
    vMx[t] "Nominel import af tjenester (ekslusiv søtransport) og fremstilling."
    vXvarer[t] "Samlet vareeksport inkl. energi"
    vXtjenester[t] "Samlet tjenesteeksport inkl. søfart og turisme"
    vBVTspxudv[t] "BVT i private brancher ekskl. udvinding"
  ;

  $GROUP G_IO_endo
    G_IO_prices_endo
    G_IO_quantities_endo
    G_IO_values_endo

    # qY[udv] er eksogen. 
    # jluIOm skalerer import-andel fra udvindingsbranche for at efterspørgsel rammer eksogen produktion.
    jluIOm[s,t]$(udv[s]) "J-led."

    # Skalaparameter (endogene pga. balancerings-mekanismer)
    uIO[d_,s,t] "Skalaparameter for efterspørgselskomponents vægt på diverse input."
    uIOy[dux,s,t] "Skalaparameter for efterspørgselskomponents vægt på diverse indenlandske input."
    uIOm[dux,s,t] "Skalaparameter for efterspørgselskomponents vægt på diverse importerede input."
    uIOXy[x,s,t] "Skalaparameter for eksportkomponents vægt på diverse indenlandske input."
    uIOXm[x,s,t] "Skalaparameter for eksportkomponents vægt på diverse importerede input."

    fpI_s[i,t]$(tForecast[t]) "Korrektionsfaktor som sørger for at vI_s summerer til vI."

    fpIVaerdi[t] "Korrektionsfaktor som sørger for at lagerinvesteringskomponenter kædeaggregerer"

    # vI fastholder en eksogen fordeling af offentlige nyinvesteringer på investeringstyper.
    # De tilhørende skalaparametre er endogene.
    uIO0[d_,s_,t]$(i_[d_] and not iL[d_] and off[s_] and d1IO[d_,s_,t]) "Skalaparameter for efterspørgselskomponents vægt på diverse input før endelig skalering."

    # Alt offentligt salg til privat forbrug antages at gå til forbrug af øvrige tjenester.
    # Den tilhørende skalaparameter er endogen.
    uIO0[d_,s_,t]$(c_[d_] and off[s_] and d1IO[d_,s_,t]) "Skalaparameter for efterspørgselskomponents vægt på diverse input før endelig skalering."

    qC[c_,t]$(cbol[c_])

    rpIOm2pIOy[d_,s,t] "Relativ pris mellem import og egenproduktion."
    rqIOm2qIO[d_,s_,t]$(dux[d_] and d1IOm[d_,s_,t] and s[s_]) "Importandel af IO-celle"
    frqIO[d_,s_,t]$(dux[d_] and d1IOy[d_,s_,t] and s[s_]) "Hjælpevariabel til static-modellen"
    rqIOm2qIO0[d_,s_,t]$(dux[d_] and d1IOm[d_,s_,t] and udv[s_]) "Relativt forhold mellem import og input-aggregat for j-led"
    qG$(gTot[g_]) "Total offentligt forbrug, Kilde: ADAM[fCo]"

    dpM2pYTraeghed[dux,s,t]$(d1IOy[dux,s,t] and d1IOm[dux,s,t] and d1IOy[dux,s,t-1] and d1IOm[dux,s,t-1]) "Hjælpevariabel til beregning af effekt fra pristræghed."

    rpI[i_,s_,t]$((i[i_] and (sTot[s_] or spTot[s_] or sByTot[s_])) or (iTot[i_] and (s[s_] or sTot[s_]))) "Relative laggede priser i investeringer vægtet med nutidige mængder."
    rpCDK[c_,t]$(c[c_] or cTot[c_]) "Relative laggede priser i forbrug inkl. turisters vægtet med nutidige mængder."
    rpBNP[t] "Relative laggede priser i BNP vægtet med nutidige mængder."
    rpBVT[s_,t]$(s[s_] or sTot[s_] or spTot[s_] or sByTot[s_]) "Relative laggede priser i BVT vægtet med nutidige mængder."
    rpY[s_,t]$(sTot[s_] or spTot[s_] or sByTot[s_]) "Relative laggede output-priser vægtet med nutidige mængder."
    rpM[t] "Relative laggede import-priser vægtet med nutidige mængder."
    rpR[s_,t]$(sTot[s_] or spTot[s_] or sByTot[s_]) "Relative laggede materiale-input-priser vægtet med nutidige mængder."
    rpE[s_,t]$(sTot[s_] or spTot[s_] or sByTot[s_]) "Relative laggede energi-input-priser vægtet med nutidige mængder."
    rpC[t] "Relative laggede priser i privat forbrug vægtet med nutidige mængder."
    rpBruttoHandel[t] "Relative laggede priser i sum af eksport og import vægtet med nutidige mængder."
    rpRE[r_,t]$(r[r_] or rTot[r_]) "Relative laggede priser for aggregeret materiale- og energiinput vægtet med nutidige mængder."
    rpCGIX[t] "Relative laggede priser på samlet efterspørgsel vægtet med nutidige mængder."
    rpCGI[t] "Relative laggede priser på indenlandsk efterspørgsel vægtet med nutidige mængder."
    rpCGIxLager[t] "Relative laggede priser for indenlandsk efterspørgsel ekskl. lagerinvesteringer vægtet med nutidige mængder."
    rpIbErhverv[t] "Relative laggede priser for bygningserhvervsinvesteringer vægtet med nutidige mængder."
    rpXvarer[t] "Relative laggede priser for vareeksport vægtet med nutidige mængder."
    rpXtjenester[t] "Relative laggede priser for tjenesteeksport vægtet med nutidige mængder."
    rpMvarer[t] "Relative laggede vareimport-priser vægtet med nutidige mængder."
    rpMenergi[t] "Relative laggede energiimport-priser vægtet med nutidige mængder."
    rpMtjenester[t] "Relative laggede tjenesteimport-priser vægtet med nutidige mængder."
    rpMx[t] "Relative laggede priser på import af fremstilling og tjenester ekskl. søfart vægtet med nutidige mængder."
    rpBVTspxudv[t] "Relative laggede priser i BVT ekskl. udvinding vægtet med nutidige mængder."
    rpIVaerdi[t] "Relative laggede priser i værdigenstande vægtet med nutidige mængder."
    rpIErhverv[t] "Relative laggede priser for erhvervsinvesteringer vægtet med nutidige mængder."
  ;
  $GROUP G_IO_endo G_IO_endo$(tx0[t]); # Restrict endo group to tx0[t]

  $GROUP G_IO_prices
    G_IO_prices_endo
  ;
  $GROUP G_IO_quantities
    G_IO_quantities_endo
    qGrus[t] "Eksogen mængde af produktion fra udvindingsbranche som ikke udfases, men heller ikke indgår i Nordsøbeskatning."
  ;
  $GROUP G_IO_values
    G_IO_values_endo
  ;

  $GROUP G_IO_exogenous_forecast
    qY[s_,t]$(udv[s_])
    uIOXy0[x,s,t]$(udv[s]) "Skalaparameter for eksportkomponents vægt på diverse indenlandske input før endelig skalering."
    uIO0[d_,s_,t]$(iL[d_]) "Skalaparameter for efterspørgselskomponents vægt på diverse input før endelig skalering."
    uIOm0[dux,s,t]$(iL[dux]) "Importandel i efterspørgselskomponent."
    fuIO[d_,t]$(iL[d_]) "Korrektionsfaktor for skalaparametrene for efterspørgselskomponents vægt på diverse input."
    fuIOym[dux,s,t]$(iL[d_]) "Korrektionsfaktor for skalaparametrene for efterspørgselskomponents vægt på diverse hhv. indenlandske og importerede input."
  ;
  $GROUP G_IO_forecast_as_zero
    jfpIOy[d_,t] "Pristillæg fra mermarkup fordelt på efterspørgseler - er 0 historisk."
    jfpIOm[d_,t] "Pristillæg fra mermarkup fordelt på efterspørgseler - er 0 historisk."
    jfpIO[d_,t] "Pristillæg - fælles for indlandsk og import."
    jfrqIOm2qIO[s,t] "j-led"
    jpILager[t] "J-led"
    jpIStam[t] "J-led"
    jpIOm2pIOy[dux,s,t] "J-led"
  ;
  $GROUP G_IO_ARIMA_forecast
    uIO0[d_,s_,t]$(not iL[d_]) "Skalaparameter for efterspørgselskomponents vægt på diverse input før endelig skalering."
    uIOm0[dux,s,t]$(not iL[dux]) "Importandel i efterspørgselskomponent."
    uIOXy0[x,s,t]$(not udv[s]) "Skalaparameter for eksportkomponents vægt på diverse indenlandske input før endelig skalering."
    uIOXm0[x,s,t] "Skalaparameter for eksportkomponents vægt på diverse importerede input før endelig skalering."
    uIOXyUdv0[x,t] "Skalaparameter for eksportkomponents vægt på indenlandsk udvinding før skalering til samlet indenlandsk udvinding."
  ;
  $GROUP G_IO_constants
    rpMTraeghed[d_,s] "Parameter til at styre kortsigtet priselasticitet."
    upM2YTraeghed[dux,s] "Parameter til at styre kortsigtet import-priselasticitet."
    eIO[d_,s_] "Substitutionselasticitet mellem import og indenlandsk produktion for diverse input for efterspørgselskomponenterne."
    tIOy_tBase[d,s] "Lig tIOy[d,s,tBase] i statisk kalibrering - nødvendigt når basisår er efter dyb kalibreringsår."
    tIOm_tBase[d,s] "Lig tIOm[d,s,tBase] i statisk kalibrering - nødvendigt når basisår er efter dyb kalibreringsår."
  ;
  $GROUP G_IO_fixed_forecast
    rqIO2qG[c,t] "Offentlige leverancer til privat forbrug som andel af samlet offentligt forbrug."
    rqIO2qYoff[i,t] "Offentlige leverancer til investeringer (F&U) som andel af samlet offentlig produktion."
    rvILager2iL[t] "Lagerinvesteringers andel af lagerinvesteringer, værdigenstande og stambesætninger."
    rvIstam2iL[t] "Stambesætningers andel af lagerinvesteringer, værdigenstande og stambesætninger."

    qGrus[t]

    fuIO[d_,t]$(not iL[d_]) "Korrektionsfaktor for skalaparametrene for efterspørgselskomponents vægt på diverse input."
    fuIOe[r,t] "Korrektionsfaktor for skalaparametrene for energiinputs vægt på diverse input."
    fuIOym[dux,s,t]$(not iL[dux]) "Korrektionsfaktor for skalaparametrene for efterspørgselskomponents vægt på diverse hhv. indenlandske og importerede input."
    fuIOXm[x,t] "Korrektionsfaktor for skalaparametrene for efterspørgselskomponents vægt på diverse input."
    fuIOXy[x,t] "Korrektionsfaktor for skalaparametrene for efterspørgselskomponents vægt på diverse input."
    fpCTurist[c,t] "Korrektion som fanger at turisters forbrug har anden deflator end indenlandske husholdninger."
    upI_s[i,s,t] "Skalaparameter som fanger forskelle i branchernes investerings-deflatorer for samme investeringstype."
  ;
$ENDIF


# ======================================================================================================================
# Equations  
# ======================================================================================================================
$IF %stage% == "equations":
  $BLOCK B_IO_core$(tx0[t])
    # ------------------------------------------------------------------------------------------------------------------
    # IO-cellernes mængder er givet ud fra efterspørgslen
    # ------------------------------------------------------------------------------------------------------------------   
    # Efterspørgselkomponenter fordeles på brancher - vi har efterspørgselskomponenter fra andre moduler
    # NB: uIO'erne er endogene - står under behavior
    E_qIO_R[r,s,t]$(d1IO[r,s,t] and sMat[s]).. qIO[r,s,t] =E= uIO[r,s,t] * qR[r,t];
    E_qIO_E[r,s,t]$(d1IO[r,s,t] and sEne[s]).. qIO[r,s,t] =E= uIO[r,s,t] * qE[r,t];
    E_qIO_c[c,s,t]$(d1IO[c,s,t]).. qIO[c,s,t] =E= uIO[c,s,t] * qCDK[c,t];
    E_qIO_i[i,s,t]$(d1IO[i,s,t]).. qIO[i,s,t] =E= uIO[i,s,t] * qI[i,t];
    E_qIO_g[g,s,t]$(d1IO[g,s,t]).. qIO[g,s,t] =E= uIO[g,s,t] * qG[g,t];

    # Offentlige leverancer til privat forbrug (fx privatfinansieret del af børnehaver) følger offentligt og ikke privat forbrug
    # Øvrige leverencer tager tilpasning via. skalering i E_uIO.
    E_uIO0_c_pub_via_qIO[c,t]$(d1IO[c,'off',t]).. qIO[c,'off',t] =E= rqIO2qG[c,t] * qG[gTot,t];

    # Offentlige direkte investeringer følger offentligt produktion (fremfor at følge samlede investeringer)
    # Øvrige leverencer tager tilpasning via. skalering i E_uIO.
    E_uIO0_i_pub_via_qIO[i,t]$(d1IO[i,'off',t] and not iL[i]).. qIO[i,'off',t] =E= rqIO2qYoff[i,t] * qY['off',t];

    # Eksport særbehandles, da vi ikke har substitution mellem direkte eksport og import til reeksport
    # Vi har opdelt efterspørgslen på direkte eksport og import til reeksport i export.gms
    E_qIOy_x[x,s,t]$(d1IOy[x,s,t] and not xTur[x]).. qIOy[x,s,t] =E= uIOXy[x,s,t] * qXy[x,t];
    E_qIOm_x[x,s,t]$(d1IOm[x,s,t]).. qIOm[x,s,t] =E= uIOXm[x,s,t] * qXm[x,t];

    # Aggregat af import og indenlandsk input fordelt på import og indenlandske input (modellering under behavior)
    E_rqIOm2qIO[dux,s,t]$(d1IOm[dux,s,t]).. 
      qIOm[dux,s,t] =E= rqIOm2qIO[dux,s,t] * qIO[dux,s,t];

    E_rqIOm2qIO0_udv[dux,s,t]$(udv[s] and d1IOm[dux,s,t]).. 
      rqIOm2qIO[dux,s,t] =E= rqIOm2qIO0[dux,s,t] * (1 + jfrqIOm2qIO[s,t]);

    E_frqIO[dux,s,t]$(d1IOy[dux,s,t])..
      qIO[dux,s,t] =E= frqIO[dux,s,t] * (qIOy[dux,s,t] + qIOm[dux,s,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # Markedsligevægt - produktion og import fordelt på brancher er summen af efterspørgsel givet fra IO-celler
    # ------------------------------------------------------------------------------------------------------------------
    # Produktionen for offentlige tjenester, udvinding og boligbenyttelse er ikke givet fra efterspørgselssiden
    # Givet qY bestemmer nedenstående ligning: qG[gTot,t] for off, jluIOm['udv',t] for udv og qC['cBol',t] for bol
    E_qY[s,t].. qY[s,t] =E= sum(d, qIOy[d,s,t] / (1 + tIOy_tBase[d,s]));
    E_qM[s,t].. qM[s,t] =E= sum(d, qIOm[d,s,t] / (1 + tIOm_tBase[d,s]));

    # Værdier
    E_vY_sp[s,t]$(sp[s]).. vY[s,t] =E= pY[s,t] * qY[s,t];
    E_pY_off[s,t]$(off[s]).. vY[s,t] =E= pY[s,t] * qY[s,t];
    E_vM[s,t].. vM[s,t] =E= pM[s,t] * qM[s,t];

    # ------------------------------------------------------------------------------------------------------------------
    # IO-cellernes mængder er givet ud fra efterspørgslen
    # ------------------------------------------------------------------------------------------------------------------   
    # Priser på egenproduktion og import bestemmes af inputpriser (disse bestemmes i pricing.gms)
    E_pIOy[d,s,t]$(d1IOy[d,s,t] or d1IOy[d,s,t+1])..
      pIOy[d,s,t] =E= (1 + tIOy[d,s,t]) / (1 + tIOy_tBase[d,s])
                    * (1 + jfpIOy[d,t] + jfpIO[d,t] + jfpIOy_s[s,t])
                    * pY[s,t];

    E_pIOm[d,s,t]$((d1IOm[d,s,t] or d1IOm[d,s,t+1]))..
      pIOm[d,s,t] =E= (1 + tIOm[d,s,t]) / (1 + tIOm_tBase[d,s])
                    * (1 + jfpIOm[d,t] + jfpIO[d,t] + jfpIOm_s[s,t])
                    * pM[s,t];

    # Only used if the user wishes to deviate from law of one price in the IO system.
    # IO system should ensure that demand equals supply. If you shock the demand prices through jfpIOy or jfpIOm
    # then these equations ensure that this is still the case.
    E_jfpIOy_s[s,t]..
      pY[s,t] * qY[s,t] =E= sum(d, pIOy[d,s,t] / (1 + tIOy[d,s,t]) * qIOy[d,s,t]);

    E_jfpIOm_s[s,t]$(m[s])..
      pM[s,t] * qM[s,t] =E= sum(d, pIOm[d,s,t] / (1 + tIOm[d,s,t]) * qIOm[d,s,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # IO-budget-begrænsninger
    # ------------------------------------------------------------------------------------------------------------------
    # Værdier
    E_vIOy[d,s,t]$(d1IOy[d,s,t]).. vIOy[d,s,t] =E= pIOy[d,s,t] * qIOy[d,s,t];
    E_vIOm[d,s,t]$(d1IOm[d,s,t]).. vIOm[d,s,t] =E= pIOm[d,s,t] * qIOm[d,s,t];
    E_vIO[d,s,t]$(d1IO[d,s,t]).. vIO[d,s,t] =E= vIOy[d,s,t] + vIOm[d,s,t];

    # Deflator for input for aggregeret import og indenlandske input fordelt på brancher
    E_pIO[d,s,t]$(d1IO[d,s,t] and dux[d]).. pIO[d,s,t] * qIO[d,s,t] =E= vIO[d,s,t];

    # Efterspørgselskomponenter i værdier bestemmes ud fra værdier og hermed priser i IO-system
    E_vR[r,t].. vR[r,t] =E= sum(s$sMat[s], vIO[r,s,t]); # vR inkluderer ikke energi-input
    E_vE[r,t].. vE[r,t] =E= sum(s$sEne[s], vIO[r,s,t]); # vE er alene energi-input
    E_vC[c,t].. vC[c,t] + vCTurist[c,t] =E= sum(s, vIO[c,s,t]); # c-komponent i IO-celler inkluderer turisters forbrug i DK
    E_vI[i,t].. vI[i,t] =E= sum(s, vIO[i,s,t]);
    E_vG[g,t].. vG[g,t] =E= sum(s, vIO[g,s,t]);
    E_vXy[x,t]$(not xTur[x]).. vXy[x,t] =E= sum(s, vIOy[x,s,t]); 
    E_vXy_xTur[t].. vXy['xTur',t] =E= sum(c, vCTurist[c,t]); # Turisters forbrug i DK opgøres som eksport
    E_vXm[x,t].. vXm[x,t] =E= sum(s, vIOm[x,s,t]); 
    E_vX[x,t].. vX[x,t] =E= vXy[x,t] + vXm[x,t];

    # Priser på efterspørgselskomponenter
    E_pR[r,t].. pR[r,t] * qR[r,t] =E= vR[r,t];
    E_pE[r,t].. pE[r,t] * qE[r,t] =E= vE[r,t];
    E_pC[c,t].. pC[c,t] * qC[c,t] =E= vC[c,t];
    E_pG[g,t].. pG[g,t] * qG[g,t] =E= vG[g,t];
    E_pI[i,t].. pI[i,t] * qI[i,t] =E= vI[i,t];
    E_pX[x,t].. pX[x,t] * qX[x,t] =E= vX[x,t];

    E_pXy[x,t].. pXy[x,t] * qXy[x,t] =E= vXy[x,t];
    E_pXm[x,t]$(d1Xm[x,t]).. pXm[x,t] * qXm[x,t] =E= vXm[x,t];
 
    # ------------------------------------------------------------------------------------------------------------------
    # Særlige forhold for investeringer og forbrug
    # ------------------------------------------------------------------------------------------------------------------
    # Investeringer er fordelt på brancher i production_private.gms - her fås de totale
    E_qI_via_rpI[i,t].. qI[i,t] =E= rpI[i,sTot,t] * sum(s, qI_s[i,s,t]);
    E_qI[i,t].. pI[i,t-1]/fp * qI[i,t] =E= sum(s, pI_s[i,s,t-1]/fp * qI_s[i,s,t]);
    # De branche-fordelte investeringspriser er proportionale med den samlede investeringspris
    E_pI_s[i,s,t]$(d1I_s[i,s,t]).. pI_s[i,s,t] =E= fpI_s[i,t] * upI_s[i,s,t] * pI[i,t];
    # Der afstemmes for konsistens - dette overholdes ikke dataår pga. manglende numerisk præcision i datainput
    E_fpI_s[i,t]$(tForecast[t]).. vI[i,t] =E= sum(s, vI_s[i,s,t]);
    # Værdier på branchefordelte investeringer
    E_vI_s_sp[i,sp,t]$(d1I_s[i,sp,t]).. pI_s[i,sp,t] * qI_s[i,sp,t] =E= vI_s[i,sp,t];

    # Prisen på turisters forbrug følger prisen på danske husholdningers forbrug
    E_pCTurist[c,t]$(d1CTurist[c,t]).. pCTurist[c,t] =E= fpCTurist[c,t] * pC[c,t];
    E_vCTurist[c,t]$(d1CTurist[c,t]).. vCTurist[c,t] =E= pCTurist[c,t] * qCTurist[c,t];

    # Forbrug i Danmark er summen af turisters og husholdningers forbrug
    E_vCDK[c,t].. vCDK[c,t] =E= vC[c,t] + vCTurist[c,t];
    E_pCDK[c,t].. pCDK[c,t] * qCDK[c,t] =E= vCDK[c,t];
    E_qCDK_via_rpCDK[c,t].. qCDK[c,t] =E= rpCDK[c,t] * (qC[c,t] + qCTurist[c,t]);
    E_qCDK[c,t].. qCDK[c,t] * pCDK[c,t-1]/fp =E= pC[c,t-1]/fp * qC[c,t] + pCTurist[c,t-1]/fp * qCTurist[c,t];

    E_vCDK_tot[t].. vCDK[cTot,t] =E= sum(c, vCDK[c,t]);
    E_pCDK_tot[t].. pCDK[cTot,t] * qCDK[cTot,t] =E= vCDK[cTot,t];
    E_qCDK_tot_via_rpCDK[t].. qCDK[cTot,t] =E= rpCDK[cTot,t] * sum(c, qCDK[c,t]);
    E_qCDK_tot[t].. qCDK[cTot,t] * pCDK[cTot,t-1]/fp =E= sum(c, pCDK[c,t-1]/fp * qCDK[c,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # BNP - givet ud fra efterspørgselskomponenter og import
    # ------------------------------------------------------------------------------------------------------------------   
    E_vBNP[t].. vBNP[t] =E= vC[cTot,t] + vG[gTot,t] + vI[iTot,t] + vX[xTot,t] - vM[sTot,t];

    E_qBNP_via_rpBNP[t].. 
      qBNP[t] =E= rpBNP[t] * (qC[cTot,t] + qG[gTot,t] + qI[iTot,t] + qX[xTot,t] - qM[sTot,t]);
  
    E_qBNP[t].. qBNP[t] * pBNP[t-1]/fp =E= pC[cTot,t-1]/fp * qC[cTot,t]
                                         + pG[gTot,t-1]/fp * qG[gTot,t] 
                                         + pI[iTot,t-1]/fp * qI[iTot,t]
                                         + pX[xTot,t-1]/fp * qX[xTot,t] 
                                         - pM[sTot,t-1]/fp * qM[sTot,t];

    E_pBNP[t].. pBNP[t] * qBNP[t] =E= vBNP[t];

    # ------------------------------------------------------------------------------------------------------------------
    # BVT - produktion minus materialeinput
    # ------------------------------------------------------------------------------------------------------------------   
    E_vBVT[s,t].. vBVT[s,t] =E= vY[s,t] - vE[s,t] - vR[s,t];

    E_qBVT_via_rpBVT[s,t].. qBVT[s,t] =E= rpBVT[s,t] * (qY[s,t] - qR[s,t] - qE[s,t]);

    E_qBVT[s,t].. qBVT[s,t] * pBVT[s,t-1]/fp =E= pY[s,t-1]/fp * qY[s,t] 
                                               - pR[s,t-1]/fp * qR[s,t]
                                               - pE[s,t-1]/fp * qE[s,t];

    E_pBVT[s,t].. pBVT[s,t] * qBVT[s,t] =E= vBVT[s,t];
  $ENDBLOCK

  $BLOCK B_IO_behavior$(tx0[t])
    # --------------------------------------------------------------------------------------------------------------------
    # Fastlæggelse af importandele i IO-system
    # --------------------------------------------------------------------------------------------------------------------
    # Kortsigts-træghed
    E_rpIOm2pIOy[dux,s,t]$(not tEnd[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0)..
      rpIOm2pIOy[dux,s,t] =E= pIOm[dux,s,t] / pIOy[dux,s,t]
                            - dpM2pYTraeghed[dux,s,t]
                            + dpM2pYTraeghed[dux,s,t+1] * vIOm[dux,s,t+1]*fv / vIOm[dux,s,t] / 2
                            + jpIOm2pIOy[dux,s,t];

    E_rpIOm2pIOy_tEnd[dux,s,t]$(tEnd[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0)..
      rpIOm2pIOy[dux,s,t] =E= pIOm[dux,s,t] / pIOy[dux,s,t]
                            - dpM2pYTraeghed[dux,s,t]
                            + dpM2pYTraeghed[dux,s,t]*fv / 2
                            + jpIOm2pIOy[dux,s,t];

    E_dpM2pYTraeghed[dux,s,t]$(d1IOy[dux,s,t] and d1IOm[dux,s,t]
                               and d1IOy[dux,s,t-1] and d1IOm[dux,s,t-1]
                               and eIO.l[dux,s] > 0)..
      dpM2pYTraeghed[dux,s,t] =E= upM2YTraeghed[dux,s] * rpIOm2pIOy[dux,s,t]
                                * (rpIOm2pIOy[dux,s,t] / rpIOm2pIOy[dux,s,t-1] - 1)
                                * (rpIOm2pIOy[dux,s,t] / rpIOm2pIOy[dux,s,t-1]);

    # CES-efterspørgsel
    # Import
    E_qIOm[dux,s,t]$(d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0)..
      qIOm[dux,s,t] * uIOy[dux,s,t] * rpIOm2pIOy[dux,s,t]**eIO[dux,s] =E= uIOm[dux,s,t] * qIOy[dux,s,t];

    # Egenproduktion
    E_qIOy[dux,s,t]$(d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0)..
       qIO[dux,s,t] =E= (
          uIOy[dux,s,t]**(1/eIO[dux,s]) * qIOy[dux,s,t]**((eIO[dux,s]-1)/eIO[dux,s])
        + uIOm[dux,s,t]**(1/eIO[dux,s]) * qIOm[dux,s,t]**((eIO[dux,s]-1)/eIO[dux,s])
      )**(eIO[dux,s]/(eIO[dux,s]-1));

    # Equations in cases where there are no imports or only imports
    E_qIOm_NoY[dux,s,t]$(d1IOm[dux,s,t] and not d1IOy[dux,s,t] and eIO.l[dux,s] > 0)..
      qIOm[dux,s,t] =E= uIOm[dux,s,t] * qIO[dux,s,t] * (pIOm[dux,s,t] / pIO[dux,s,t])**(-eIO[dux,s]);
    E_qIOy_NoM[dux,s,t]$(d1IOy[dux,s,t] and not d1IOm[dux,s,t] and eIO.l[dux,s] > 0)..
      qIOy[dux,s,t] =E= uIOy[dux,s,t] * qIO[dux,s,t] * (pIOy[dux,s,t] / pIO[dux,s,t])**(-eIO[dux,s]);

    # Equations in cases of zero substitutability
    E_qIOy_e0[dux,s,t]$(d1IOy[dux,s,t] and eIO.l[dux,s] = 0)..
      qIOy[dux,s,t] =E= uIOy[dux,s,t] * qIO[dux,s,t];
    E_qIOm_e0[dux,s,t]$(d1IOm[dux,s,t] and eIO.l[dux,s] = 0)..
      qIOm[dux,s,t] =E= uIOm[dux,s,t] * qIO[dux,s,t];

    # --------------------------------------------------------------------------------------------------------------------
    # Endogen balancering af skala-parametre
    # --------------------------------------------------------------------------------------------------------------------
    E_uIO[cgi,s,t]$(d1IO[cgi,s,t])..
      uIO[cgi,s,t] =E= fuIO[cgi,t] * uIO0[cgi,s,t] / sum(ss, uIO0[cgi,ss,t]);
    E_uIO_R[r,s,t]$(d1IO[r,s,t] and sMat[s])..
      uIO[r,s,t] =E= fuIO[r,t] * uIO0[r,s,t] / sum(ss$sMat[ss], uIO0[r,ss,t]);
    E_uIO_E[r,s,t]$(d1IO[r,s,t] and sEne[s])..
      uIO[r,s,t] =E= fuIOe[r,t] * uIO0[r,s,t] / sum(ss$sEne[ss], uIO0[r,ss,t]);

    E_uIOy[dux,s,t]$(d1IOy[dux,s,t] and d1IOm[dux,s,t])..
      uIOy[dux,s,t] =E= fuIOym[dux,s,t] - uIOm[dux,s,t];
    E_uIOy_NoM[dux,s,t]$(d1IOy[dux,s,t] and not d1IOm[dux,s,t])..
      uIOy[dux,s,t] =E= fuIOym[dux,s,t];

    E_uIOm_jluIOm[dux,s,t]$(d1IOy[dux,s,t] and d1IOm[dux,s,t] and jluIOm.up[s,t] <> 0)..
      uIOm[dux,s,t] =E= fuIOym[dux,s,t] * uIOm0[dux,s,t] * (1 + jluIOm[s,t])
                      / (uIOm0[dux,s,t] * (1 + jluIOm[s,t]) + (1 - uIOm0[dux,s,t]) * (1 - jluIOm[s,t]));
    E_uIOm[dux,s,t]$(d1IOy[dux,s,t] and d1IOm[dux,s,t] and jluIOm.up[s,t] = 0)..
      uIOm[dux,s,t] =E= fuIOym[dux,s,t] * uIOm0[dux,s,t];

    E_uIOm_NoY[dux,s,t]$(d1IOm[dux,s,t] and not d1IOy[dux,s,t])..
      uIOm[dux,s,t] =E= fuIOym[dux,s,t];

    E_uIOXy[x,s,t]$(d1IOy[x,s,t])..
      uIOXy[x,s,t] =E= fuIOXy[x,t] * uIOXy0[x,s,t] / sum(ss, uIOXy0[x,ss,t]);
    E_uIOXm[x,s,t]$(d1IOm[x,s,t])..
      uIOXm[x,s,t] =E= fuIOXm[x,t] * uIOXm0[x,s,t] / sum(ss, uIOXm0[x,ss,t]);
  $ENDBLOCK

  $BLOCK B_IO_bookkeep$(tx0[t])
    # ------------------------------------------------------------------------------------------------------------------
    # Beregning af totaler ud fra kædeindeks
    # ------------------------------------------------------------------------------------------------------------------   
    # Samlet BVT
    E_vBVT_tot[t].. vBVT[sTot,t] =E= vY[sTot,t] - vR[rTot,t] - vE[rTot,t];
    E_qBVT_tot_via_rpBVT[t].. qBVT[sTot,t] =E= rpBVT[sTot,t] * (qY[sTot,t] - qR[rTot,t] - qE[rTot,t]);
    E_qBVT_tot[t].. qBVT[sTot,t] * pBVT[sTot,t-1]/fp =E= pY[sTot,t-1]/fp * qY[sTot,t] 
                                                       - pR[rTot,t-1]/fp * qR[rTot,t]
                                                       - pE[rTot,t-1]/fp * qE[rTot,t];
    E_pBVT_tot[t].. pBVT[sTot,t] * qBVT[sTot,t] =E= vBVT[sTot,t];
  
    # Privat BVT
    E_vBVT_spTot[t].. vBVT[spTot,t] =E= vY[spTot,t] - vE[spTot,t] - vR[spTot,t];
    E_qBVT_spTot_via_rpBVT[t].. qBVT[spTot,t] =E= rpBVT[spTot,t] * (qY[spTot,t] - qR[spTot,t] - qE[spTot,t]);
    E_qBVT_spTot[t].. qBVT[spTot,t] * pBVT[spTot,t-1]/fp =E= pY[spTot,t-1]/fp * qY[spTot,t] 
                                                           - pR[spTot,t-1]/fp * qR[spTot,t] 
                                                           - pE[spTot,t-1]/fp * qE[spTot,t];
    E_pBVT_spTot[t].. pBVT[spTot,t] * qBVT[spTot,t] =E= vBVT[spTot,t];

    # BVT i private byerhverv
    E_vBVT_sByTot[t].. vBVT[sByTot,t] =E= vY[sByTot,t] - vE[sByTot,t] - vR[sByTot,t];
    E_qBVT_sBytot_via_rpBVT[t].. qBVT[sByTot,t] =E= rpBVT[sByTot,t] * (qY[sByTot,t] - qR[sByTot,t] - qE[sByTot,t]);
    E_qBVT_sByTot[t].. pBVT[sByTot,t-1]/fp * qBVT[sByTot,t] =E= pY[sByTot,t-1]/fp * qY[sByTot,t]
                                                              - pE[sByTot,t-1]/fp * qE[sByTot,t]
                                                              - pR[sByTot,t-1]/fp * qR[sByTot,t];
    E_pBVT_sByTot[t].. pBVT[sByTot,t] * qBVT[sByTot,t] =E= vBVT[sByTot,t];

    # Samlet produktion
    E_vY_tot[t].. vY[sTot,t] =E= sum(s, vY[s,t]);
    E_qY_tot_via_rpY[t].. qY[sTot,t] =E= rpY[sTot,t] * sum(s, qY[s,t]);
    E_qY_tot[t].. qY[sTot,t] * pY[sTot,t-1]/fp =E= sum(s, pY[s,t-1]/fp * qY[s,t]);
    E_pY_tot[t].. pY[sTot,t] * qY[sTot,t] =E= vY[sTot,t];

    # Privat produktion
    E_vY_spTot[t].. vY[spTot,t] =E= sum(sp, vY[sp,t]);
    E_qY_spTot_via_rpY[t].. qY[spTot,t] =E= rpY[spTot,t] * sum(sp, qY[sp,t]);
    E_qY_spTot[t].. qY[spTot,t] * pY[spTot,t-1]/fp =E= sum(sp, pY[sp,t-1]/fp * qY[sp,t]);
    E_pY_spTot[t].. pY[spTot,t] * qY[spTot,t] =E= vY[spTot,t];

    # Produktion i private byerhverv
    E_vY_sByTot[t].. vY[sByTot,t] =E= sum(sBy, vY[sBy,t]);
    E_qY_sBytot_via_rpY[t].. qY[sByTot,t] =E= rpY[sByTot,t] * sum(sBy, qY[sBy,t]);
    E_qY_sByTot[t].. qY[sByTot,t] * pY[sByTot,t-1]/fp =E= sum(sBy, pY[sBy,t-1]/fp * qY[sBy,t]);
    E_pY_sByTot[t].. pY[sByTot,t] * qY[sByTot,t] =E= vY[sByTot,t];

    # Samlet import
    E_vM_tot[t].. vM[sTot,t] =E= sum(s, vM[s,t]);
    E_qM_via_rpM[t].. qM[sTot,t] =E= rpM[t] * sum(s, qM[s,t]);
    E_qM_tot[t].. qM[sTot,t] * pM[sTot,t-1]/fp =E= sum(s, pM[s,t-1]/fp * qM[s,t]);
    E_pM_tot[t].. pM[sTot,t] * qM[sTot,t] =E= vM[sTot,t];

    # Samlet eksport
    E_pX_xTot[t].. pX[xTot,t] * qX[xTot,t] =E= vX[xTot,t];
    E_vX_xTot[t].. vX[xTot,t] =E= sum(x, vX[x,t]);

    # Samlet direkte eksport
    E_vXy_xTot[t].. vXy[xTot,t] =E= sum(x, vXy[x,t]);
    E_pXy_xTot[t].. pXy[xTot,t] * qXy[xTot,t] =E= vXy[xTot,t];

    # Samlet import til reeksport
    E_vXm_xTot[t].. vXm[xTot,t] =E= sum(x, vXm[x,t]);
    E_pXm_xTot[t].. pXm[xTot,t] * qXm[xTot,t] =E= vXm[xTot,t];

    # Samlede investeringer
    E_vI_iTot[t].. vI[iTot,t] =E= sum(i, vI[i,t]);
    E_qI_iTot_via_rpI[t].. qI[iTot,t] =E= rpI[iTot,sTot,t] * sum(i, qI[i,t]);
    E_qI_iTot[t].. qI[iTot,t] * pI[iTot,t-1]/fp =E= sum(i, pI[i,t-1]/fp * qI[i,t]);
    E_pI_iTot[t].. pI[iTot,t] * qI[iTot,t] =E= vI[iTot,t];

    # Samlet materialeinput til produktion ekskl. energi
    E_vR_tot[t].. vR[rTot,t] =E= sum(r, vR[r,t]);
    E_qR_tot_via_rpR[t].. qR[rTot,t] =E= rpR[rTot,t] * sum(r, qR[r,t]);
    E_qR_tot[t].. qR[rTot,t] * pR[rTot,t-1]/fp =E= sum(r, pR[r,t-1]/fp * qR[r,t]);
    E_pR_tot[t].. pR[rTot,t] * qR[rTot,t] =E= vR[rTot,t];

    # Materialeinput ekskl. energi til private brancher
    E_vR_spTot[t].. vR[spTot,t] =E= sum(sp, vR[sp,t]);
    E_qR_spTot_via_rpR[t].. qR[spTot,t] =E= rpR[spTot,t] * sum(sp, qR[sp,t]);
    E_qR_spTot[t].. qR[spTot,t] * pR[spTot,t-1]/fp =E= sum(sp, pR[sp,t-1]/fp * qR[sp,t]);
    E_pR_spTot[t].. pR[spTot,t] * qR[spTot,t] =E= vR[spTot,t];

    # Materialeinput ekskl. energi til private byerhverv
    E_vR_sByTot[t].. vR[sByTot,t] =E= sum(sBy, vR[sBy,t]);
    E_qR_sBytot_via_rpR[t].. qR[sByTot,t] =E= rpR[sByTot,t] * sum(sBy, qR[sBy,t]);
    E_qR_sByTot[t].. qR[sByTot,t] * pR[sByTot,t-1]/fp =E= sum(sBy, pR[sBy,t-1]/fp * qR[sBy,t]);
    E_pR_sByTot[t].. pR[sByTot,t] * qR[sByTot,t] =E= vR[sByTot,t];

    # Samlet energiinput til produktion
    E_vE_tot[t].. vE[rTot,t] =E= sum(r, vE[r,t]);
    E_qE_tot_via_rpE[t].. qE[rTot,t] =E= rpE[rTot,t] * sum(r, qE[r,t]);
    E_qE_tot[t].. qE[rTot,t] * pE[rTot,t-1]/fp =E= sum(r, pE[r,t-1]/fp * qE[r,t]);
    E_pE_tot[t].. pE[rTot,t] * qE[rTot,t] =E= vE[rTot,t];

    # Samlet energiinput til produktion til private brancher
    E_vE_spTot[t].. vE[spTot,t] =E= sum(sp, vE[sp,t]);
    E_qE_spTot_via_rpE[t].. qE[spTot,t] =E= rpE[spTot,t] * sum(sp, qE[sp,t]);
    E_qE_spTot[t].. qE[spTot,t] * pE[spTot,t-1]/fp =E= sum(sp, pE[sp,t-1]/fp * qE[sp,t]);
    E_pE_spTot[t].. pE[spTot,t] * qE[spTot,t] =E= vE[spTot,t];

    # Samlet energiinput til produktion til private byerhverv
    E_vE_sByTot[t].. vE[sByTot,t] =E= sum(sBy, vE[sBy,t]);
    E_qE_sByTot_via_rpE[t].. qE[sByTot,t] =E= rpE[sByTot,t] * sum(sBy, qE[sBy,t]);
    E_qE_sByTot[t].. qE[sByTot,t] * pE[sByTot,t-1]/fp =E= sum(sBy, pE[sBy,t-1]/fp * qE[sBy,t]);
    E_pE_sByTot[t].. pE[sByTot,t] * qE[sByTot,t] =E= vE[sByTot,t];

    # Samlet privat forbrug (til danske husholdninger)
    E_vC_tot[t].. vC[cTot,t] =E= sum(c, vC[c,t]);
    E_qC_tot_via_rpC[t].. qC[cTot,t] =E= rpC[t] * sum(c, qC[c,t]);
    E_qC_tot[t].. qC[cTot,t] * pC[cTot,t-1]/fp =E= sum(c, pC[c,t-1]/fp * qC[c,t]);
    E_pC_tot[t].. pC[cTot,t] * qC[cTot,t] =E= vC[cTot,t];

    # Samlet offentligt forbrug
    E_vG_Tot[t].. vG[gTot,t] =E= sum(g, vG[g,t]);
    E_pG_tot[t].. pG[gTot,t] =E= vG[gTot,t] / qG[gTot,t];

    # Samlede indenlandske input fordelt på efterspørgselskomponenter
    E_vIOy_sTot[d,t]$(d1IOy[d,sTot,t])..
      vIOy[d,sTot,t] =E= sum(s, vIOy[d,s,t]);

    # Samlede importinput fordelt på efterspørgselskomponenter
    E_vIOm_sTot[d,t]$(d1IOm[d,sTot,t])..
      vIOm[d,sTot,t] =E= sum(s, vIOm[d,s,t]);

    # Samlede indenlandske input fordelt på brancher
    E_vIOy_dTots[dTots,s,t]$(d1IOy[dTots,s,t])..
      vIOy[dTots,s,t] =E= sum(d$dTots2d[dtots,d], vIOy[d,s,t]);

    # Samlede importinput fordelt på brancher
    E_vIOm_dTots[dTots,s,t]$(d1IOm[dTots,s,t])..
      vIOm[dTots,s,t] =E= sum(d$dTots2d[dtots,d], vIOm[d,s,t]); 

    # Branchevise samlede investeringer
    E_vI_s_iTot[s,t].. vI_s[iTot,s,t] =E= sum(i, vI_s[i,s,t]);
    E_qI_s_iTot_via_rpI[s,t].. qI_s[iTot,s,t] =E= rpI[iTot,s,t] * sum(i, qI_s[i,s,t]);
    E_qI_s_iTot[s,t].. qI_s[iTot,s,t] * pI_s[iTot,s,t-1]/fp =E= sum(i, pI_s[i,s,t-1]/fp * qI_s[i,s,t]);
    E_pI_s_iTot[s,t].. pI_s[iTot,s,t] * qI_s[iTot,s,t] =E= vI_s[iTot,s,t];

    # Investeringer i private brancher
    E_qI_s_spTot_via_rpI[i,t]$(not iL[i]).. qI_s[i,spTot,t] =E= rpI[i,spTot,t] * sum(sp, qI_s[i,sp,t]);
    E_qI_s_spTot[i,t]$(not iL[i]).. qI_s[i,spTot,t] * pI_s[i,spTot,t-1]/fp =E= sum(sp, pI_s[i,sp,t-1]/fp * qI_s[i,sp,t]);
    E_pI_s_spTot[i,t]$(not iL[i]).. pI_s[i,spTot,t] * qI_s[i,spTot,t] =E= vI_s[i,spTot,t];
    E_vI_s_spTot[i,t]$(not iL[i]).. vI_s[i,spTot,t] =E= sum(sp, vI_s[i,sp,t]);

    # Samlede investeringer i private brancher
    E_vI_s_iTot_spTot[t].. vI_s[iTot,spTot,t] =E= sum(sp, vI_s[iTot,sp,t]);

    # Investeringer i private byerhverv
    E_qI_s_sByTot_via_rpI_i[i,t]$(not iL[i]).. qI_s[i,sByTot,t] =E= rpI[i,sByTot,t] * sum(sBy, qI_s[i,sBy,t]);
    E_qI_s_sByTot[i,t]$(not iL[i]).. qI_s[i,sByTot,t] * pI_s[i,sByTot,t-1]/fp =E= sum(sBy, pI_s[i,sBy,t-1]/fp * qI_s[i,sBy,t]);
    E_pI_s_sByTot[i,t]$(not iL[i]).. pI_s[i,sByTot,t] * qI_s[i,sByTot,t] =E= vI_s[i,sByTot,t];
    E_vI_s_sByTot[i,t]$(not iL[i]).. vI_s[i,sByTot,t] =E= sum(sBy, vI_s[i,sBy,t]);

    # -------------------------------------------------------------------------------------------------------------------
    # Ligninger til tabel-variable
    # -------------------------------------------------------------------------------------------------------------------
    E_pBruttoHandel[t].. pBruttoHandel[t] * qBruttoHandel[t] =E= vX[xTot,t] + vM[sTot,t]; 
    E_qBruttoHandel_via_rpBruttoHandel[t]..
      qBruttoHandel[t] =E= rpBruttoHandel[t] * (qX[xTot,t] + qM[sTot,t]);
    E_qBruttoHandel[t]..
      qBruttoHandel[t] * pBruttoHandel[t-1]/fp =E= pX[xTot,t-1]/fp * qX[xTot,t] + pM[sTot,t-1]/fp * qM[sTot,t]; 
    E_qHandelsbalance[t].. qHandelsbalance[t] =E= vHandelsbalance[t] / pBruttoHandel[t];
    E_vHandelsbalance[t].. vHandelsbalance[t] =E= vX[xTot,t] - vM[sTot,t];

    # Materialeinput inkl. energi
    E_vRE[r,t].. vRE[r,t] =E= vR[r,t] + vE[r,t];
    E_qRE_via_rpRE[r,t].. qRE[r,t] =E= rpRE[r,t] * (qR[r,t] + qE[r,t]);
    E_qRE[r,t].. qRE[r,t] * pRE[r,t-1]/fp =E= pR[r,t-1]/fp * qR[r,t] + pE[r,t-1]/fp * qE[r,t];
    E_pRE[r,t].. pRE[r,t] * qRE[r,t] =E= vRE[r,t];

    E_vRE_rTot[t].. vRE[rTot,t] =E= vR[rTot,t] + vE[rTot,t];
    E_qRE_rTot_via_rpRE[t].. qRE[rTot,t] =E= rpRE[rTot,t] * (qR[rTot,t] + qE[rTot,t]);
    E_qRE_rTot[t].. qRE[rTot,t] * pRE[rTot,t-1]/fp =E= pR[rTot,t-1]/fp * qR[rTot,t] + pE[rTot,t-1]/fp * qE[rTot,t];
    E_pRE_rTot[t].. pRE[rTot,t] * qRE[rTot,t] =E= vRE[rTot,t];

    # Samlet efterspørgsel
    E_vCGIX[t]$(t.val >= 1995).. vCGIX[t] =E= vC[cTot,t] + vG[gTot,t] + vI[iTot,t] + vX[xTot,t];
    E_qCGIX_via_rpCGIX[t]$(t.val >= 1995).. 
      qCGIX[t] =E= rpCGIX[t] * (qC[cTot,t] + qG[gTot,t] + qI[iTot,t] + qX[xTot,t]);
    E_qCGIX[t]$(t.val >= 1995).. qCGIX[t] * pCGIX[t-1]/fp =E= pC[cTot,t-1]/fp * qC[cTot,t]
                                                            + pG[gTot,t-1]/fp * qG[gTot,t] 
                                                            + pI[iTot,t-1]/fp * qI[iTot,t]
                                                            + pX[xTot,t-1]/fp * qX[xTot,t];
    E_pCGIX[t]$(t.val >= 1995).. pCGIX[t] * qCGIX[t] =E= vCGIX[t];
 
    # Indenlandsk efterspørgsel
    E_vCGI[t].. vCGI[t] =E= vC[cTot,t] + vG[gTot,t] + vI[iTot,t];
    E_qCGI_via_rpCGI[t].. qCGI[t] =E= rpCGI[t] * (qC[cTot,t] + qG[gTot,t] + qI[iTot,t]);
    E_qCGI[t]..
      qCGI[t] * pCGI[t-1]/fp =E= pC[cTot,t-1]/fp * qC[cTot,t]
                               + pG[gTot,t-1]/fp * qG[gTot,t] 
                               + pI[iTot,t-1]/fp * qI[iTot,t];
    E_pCGI[t].. pCGI[t] * qCGI[t] =E= vCGI[t];

    # Indenlandsk efterspørgsel ekskl. lagerinvesteringer
    E_vCGIxLager[t].. vCGIxLager[t] =E= vCGI[t] - vILager[t];
    E_qCGIxLager_via_rpCGIxLager[t].. qCGIxLager[t] =E= rpCGIxLager[t] * (qCGI[t] - qILager[t]);
    E_qCGIxLager[t].. 
      qCGIxLager[t] * pCGIxLager[t-1]/fp =E= pCGI[t-1]/fp * qCGI[t] - pILager[t-1]/fp * qILager[t];
    E_pCGIxLager[t].. pCGIxLager[t] * qCGIxLager[t] =E= vCGIxLager[t];

    # Investeringsaggregater
    E_vIbm[t].. vIbm[t] =E= vI['iB',t] + vI['iM',t];
    E_qIbm[t].. qIbm[t] * pIbm[t-1]/fp =E= pI['iB',t-1]/fp * qI['iB',t] + pI['iM',t-1]/fp * qI['iM',t];
    E_pIbm[t].. pIbm[t] * qIbm[t] =E= vIbm[t];
    E_vIbErhverv[t].. vIbErhverv[t] =E= vI['iB',t] - vI_s['iB','off',t] - vI_s['iB','bol',t];
    E_qIbErhverv_via_rqIbErhverv[t].. 
      qIbErhverv[t] =E= rpIbErhverv[t] * (qI['iB',t] - qI_s['iB','off',t] - qI_s['iB','bol',t]);
    E_qIbErhverv[t].. qIbErhverv[t] * pIbErhverv[t-1]/fp =E= pI['iB',t-1]/fp * qI['iB',t]
                                                           - pI_s['iB','off',t-1]/fp * qI_s['iB','off',t]
                                                           - pI_s['iB','bol',t-1]/fp * qI_s['iB','bol',t];
    E_pIbErhverv[t].. pIbErhverv[t] * qIbErhverv[t] =E= vIbErhverv[t];

    # Eksport-aggregater
    E_vXvarer[t].. vXvarer[t] =E= vX['xVar',t] + vX['xEne',t];
    E_qXvarer_via_rpXvarer[t].. qXvarer[t] =E= rpXVarer[t] * (qX['xVar',t] + qX['xEne',t]);
    E_qXvarer[t].. qXvarer[t] * pXvarer[t-1]/fp =E= pX['xVar',t-1]/fp * qX['xVar',t] 
                                                  + pX['xEne',t-1]/fp * qX['xEne',t];
    E_pXvarer[t].. pXvarer[t] * qXvarer[t] =E= vXvarer[t];
    E_vXtjenester[t].. vXtjenester[t] =E= vX['xTje',t] + vX['xSoe',t] + vX['xTur',t];
    E_qXtjenester_via_rpXtjenester[t].. 
      qXtjenester[t] =E= rpXtjenester[t] * (qX['xTje',t] + qX['xSoe',t] + qX['xTur',t]);
    E_qXtjenester[t].. qXtjenester[t] * pXtjenester[t-1]/fp =E= pX['xTje',t-1]/fp * qX['xTje',t]
                                                              + pX['xSoe',t-1]/fp * qX['xSoe',t]
                                                              + pX['xTur',t-1]/fp * qX['xTur',t];
    E_pXtjenester[t].. pXtjenester[t] * qXtjenester[t] =E= vXtjenester[t];

    # Import-aggregater
    E_vMvarer[t].. vMvarer[t] =E= vM['fre',t] + vM['ene',t] + vM['udv',t];
    E_qMvarer_via_rpMvarer[t].. qMvarer[t] =E= rpMvarer[t] * (qM['fre',t] + qM['ene',t] + qM['udv',t]);
    E_qMvarer[t].. qMvarer[t] * pMvarer[t-1]/fp =E= pM['fre',t-1]/fp * qM['fre',t] 
                                                           + pM['ene',t-1]/fp * qM['ene',t]
                                                           + pM['udv',t-1]/fp * qM['udv',t];
    E_pMvarer[t].. pMvarer[t] * qMvarer[t] =E= vMvarer[t];

    E_vMenergi[t].. vMenergi[t] =E= vM['ene',t] + vM['udv',t];
    E_qMenergi_via_rpMenergi[t].. qMenergi[t] =E= rpMenergi[t] * (qM['ene',t] + qM['udv',t]);
    E_qMenergi[t].. qMenergi[t] * pMenergi[t-1]/fp =E= pM['ene',t-1]/fp * qM['ene',t]
                                                     + pM['udv',t-1]/fp * qM['udv',t];
    E_pMenergi[t].. pMenergi[t] * qMenergi[t] =E= vMenergi[t];

    E_vMtjenester[t].. vMtjenester[t] =E= vM['tje',t] + vM['soe',t];
    E_qMtjenester_via_rpMtjenester[t].. qMtjenester[t] =E= rpMtjenester[t] * (qM['tje',t] + qM['soe',t]);
    E_qMtjenester[t].. qMtjenester[t] * pMtjenester[t-1]/fp =E= pM['tje',t-1]/fp * qM['tje',t] 
                                                              + pM['soe',t-1]/fp * qM['soe',t];
    E_pMtjenester[t].. pMtjenester[t] * qMtjenester[t] =E= vMtjenester[t];

    E_vMx[t].. vMx[t] =E= vM['tje',t] + vM['fre',t];
    E_qMx_via_rpMx[t].. qMx[t] =E= rpMx[t] * (qM['tje',t] + qM['fre',t]);
    E_qMx[t].. qMx[t] * pMx[t-1]/fp =E= pM['tje',t-1]/fp * qM['tje',t] + pM['fre',t-1]/fp * qM['fre',t];
    E_pMx[t].. pMx[t] * qMx[t] =E= vMx[t];

    # BVT-aggregater
    E_vBVTspxudv[t].. vBVTspxudv[t] =E= vBVT[spTot,t] - vBVT['udv',t];
    E_qBVTspxudv_via_rpBVTspxudv[t].. qBVTspxudv[t] =E= rpBVTspxUdv[t] * (qBVT[spTot,t] - qBVT['udv',t]);
    E_qBVTspxudv[t].. qBVTspxudv[t] * pBVTspxudv[t-1]/fp =E= pBVT[spTot,t-1]/fp * qBVT[spTot,t]
                                                           - pBVT['udv',t-1]/fp * qBVT['udv',t];
    E_pBVTspxudv[t].. pBVTspxudv[t] * qBVTspxudv[t] =E= vBVTspxudv[t];

    # Lagerinvesteringer fordelt på rene lagerinvesteringer, stambesætninger og værdigenstande
    E_vILager[t].. vILager[t] =E= rvILager2iL[t] * vI['iL',t];
    E_pILager[t].. pILager[t] =E= fpIVaerdi[t] * pI['iL',t] + jpILager[t];
    E_qILager[t].. vILager[t] =E= pILager[t] * qILager[t];

    E_vIStam[t].. vIStam[t] =E= rvIstam2iL[t] * vI['iL',t];
    E_pIStam[t].. pIStam[t] =E= fpIVaerdi[t] * pI['iL',t] + jpIStam[t];
    E_qIStam[t].. vIStam[t] =E= pIStam[t] * qIStam[t];

    E_vIVaerdi[t].. vI['iL',t] =E= vIStam[t] + vIVaerdi[t] + vILager[t];    
    E_qIVaerdi_via_rpIVaerdi[t].. qIVaerdi[t] =E= rpIVaerdi[t] * (qI['iL',t] - qIStam[t] - qILager[t]);
    E_qIVaerdi[t].. pI['iL',t-1]/fp * qI['iL',t] =E= pIStam[t-1]/fp * qIStam[t]
                                                   + pIVaerdi[t-1]/fp * qIVaerdi[t]
                                                   + pILager[t-1]/fp * qILager[t];
    E_pIVaerdi[t].. vIVaerdi[t] =E= pIVaerdi[t] * qIVaerdi[t];
    E_fpIVaerdi[t].. pIVaerdi[t] =E= fpIVaerdi[t] * pI['iL',t];

    E_vIErhverv[t].. vIErhverv[t] =E= vIbm[t] - vI_s['iM','off',t] - vI_s['IB','off',t] - vI_s['IB','bol',t] + vIStam[t];
    E_qIErhverv_via_rpIErhverv[t].. 
      qIErhverv[t] =E= rpIErhverv[t] * (qIbm[t] - qI_s['iM','off',t] - qI_s['iB','off',t] - qI_s['iB','bol',t] + qIStam[t]);
    E_qIErhverv[t].. qIErhverv[t] * pIErhverv[t-1]/fp =E= pIbm[t-1]/fp * qIbm[t]
                                                        - pI_s['iM','off',t-1]/fp * qI_s['iM','off',t]
                                                        - pI_s['iB','off',t-1]/fp * qI_s['iB','off',t]
                                                        - pI_s['iB','bol',t-1]/fp * qI_s['iB','bol',t]
                                                        + pIStam[t-1]/fp * qIStam[t];
    E_pIErhverv[t].. pIErhverv[t] * qIErhverv[t] =E= vIErhverv[t];
  $ENDBLOCK

  #  $BLOCK B_IO_forwardlooking
  #  $ENDBLOCK

  MODEL M_IO /
    B_IO_core
    B_IO_behavior
    B_IO_bookkeep
    #  B_IO_forwardlooking
    pCTurist(d1CTurist)
    qIO(d1IO)
    qIOy(d1IOy)
    qIOm(d1IOm)
    vIO(d1IO)
    vIOy(d1IOy)
    vIOm(d1IOm)
    vCTurist(d1CTurist)
  /;

  MODEL M_IO_static /
    M_IO
    -E_rpIOm2pIOy -E_rpIOm2pIOy_tEnd
    -E_uIOy -E_uIOy_NoM
    -E_uIOm_jluIOm -E_uIOm -E_uIOm_NoY
    -E_qIOy -E_qIOy_NoM -E_qIOy_e0
    -E_qIOm -E_qIOm_NoY -E_qIOm_e0
  /;

  $GROUP G_IO_static
    G_IO_endo
    qY$(udv[s_] and t.val < 1990), -jluIOm[s,t]$(udv[s] and t.val < 1990) # Går galt pga. negative importkvoter
    -jluIOm[s,t]$(udv[s] and t.val >= 1990), jfrqIOm2qIO$(udv[s] and t.val >= 1990)
    -rpIOm2pIOy # -E_rpIOm2pIOy -E_rpIOm2pIOy_ingen_historik
    -uIOy # -E_uIOy_jluIOm -E_uIOy -E_uIOy_NoM
    -uIOm # -E_uIOm -E_uIOm_NoY
    -frqIO # -E_qIOy -E_qIOy_NoM -E_qIOy_e0
    -rqIOm2qIO$(not udv[s_]), -rqIOm2qIO0$(udv[s_]) # -E_qIOm -E_qIOm_NoY -E_qIOm_e0
  ;

  $GROUP G_IO_static G_IO_static$(tx0[t]);
$ENDIF


$IF %stage% == "exogenous_values":
# ======================================================================================================================
# Load data
# ======================================================================================================================
  # Totaler og aggregater fra makrobk indlæses
  $GROUP G_IO_makrobk
    # Prices 
    pIOy$(d[d_])
    pIOm$(d[d_])
    pX, pIO$(d[d_]), pM, pCTurist$(d1CTurist[c,t]), pG, pC$(cTot[c_] or c[c_])
    pY$(s[s_] or sTot[s_] or spTot[s_])
    pXy$(xTot[x_]), pXm$(x[x_] or xTot[x_]), 
    pCDK[c_,t],
    pI_s$((s[s_] or (k[i_] and (sByTot[s_] or spTot[s_]))) and not (iM[i_] and bol[s_]))
    pI
    pBVT$(s[s_] or sTot[s_])
    pBNP
    pR$(r[r_] or rTot[r_])
    pE$(r[r_] or rTot[r_])
    # Values 
    vIO$(s[s_] and d[d_]), vIOy$(s[s_] and not dTots[d_]), vIOm$(s[s_] and not dTots[d_])
    vY$(s[s_] or sTot[s_])
    vC$(c[c_] or cTot[c_])
    vCTurist, vG, vI_s$(i[i_] and s[s_])
    VX, vI, vM 
    vR$(r[r_])
    vE$(r[r_])
    vBVT$(sTot[s_] or s[s_])
    vBNP
    # Quantities
    qIO$(s[s_] and d[d_]), qIOy$(s[s_]), qIOm$(s[s_]), qM, 
    qY$(s[s_] or sTot[s_])
    qX, qR$(r[r_] or rtot[r_]), qE$(r[r_] or rtot[r_])
    qI_s$(s[s_] and i[i_] or (k[i_] and sByTot[s_]))
    qCDK[c_,t], 
    qC$(cTot[c_]) # qC$(c[c_]) indlæses i consumers
    qBVT$(s[s_] or sTot[s_])
    qBNP
    qI
    qK$(k[i_] and s[s_])
    # Tabel-variable
    vRE$(r[r_] or rTot[r_]), qRE$(r[r_] or rTot[r_]), pRE$(r[r_] or rTot[r_])
    pCGIX, pCGI, pCGIxLager, pMvarer, pMenergi, pMtjenester, pXvarer, pXtjenester, pIbm, pIErhverv, pIbErhverv, pBVTspxudv
    vCGIX, vCGI, vCGIxLager, vMvarer, vMenergi, vMtjenester, vXvarer, vXtjenester, vIbm, vIErhverv, vIbErhverv, vBVTspxudv
    qCGIX, qCGI, qCGIxLager, qMvarer, qMenergi, qMtjenester, qXvarer, qXtjenester, qIbm, qIErhverv, qIbErhverv, qBVTspxudv
    pILager, pIStam, pIVaerdi
    vILager, vIStam, vIVaerdi
    qILager, qIStam, qIVaerdi
  ;
  @load(G_IO_makrobk, "..\Data\makrobk\makrobk.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_IO_data
    G_IO_makrobk
    -pIOy$(not d1IOy[d_,s_,t])
    -pIOm$(not d1IOm[d_,s_,t])
    pXUdl$(x[x_] and not xVar[x_] and not xTur[x_]) # Disse laves nedenfor og skal læses ind i fx foreløbige år
    fpI_s[i,t] 
  ;
  # Variable som er datadækket, men data ændres lidt ved kalibrering
  $GROUP G_IO_data_imprecise
    pY$(spTot[s_])
    qR$(rtot[r_])
    pBNP, qBNP, vBNP
    pBVT$(tje[s_])
    qC$(cTot[c_]), vC$(cTot[c_]) 
    vR$(tje[r_] or off[r_])
    qBVT$(sTot[s_] or tje[s_] or off[s_]),  
    vBVT$( sTot[s_] or tje[s_] or off[s_])
    vY$(sTot[s_] or tje[s_])
    qI
    qY$(sTot[s_] or tje[s_])
    pI
    pI_s$(spTot[s_] and iB[i_]), 
  # Disse er rykket over ved Aug21Data - da der er uoverensstemmelser her
    pR$(r[r_] or rTot[r_])
    pBVT$(s[s_] or sTot[s_])  
    vR$(r[r_]), 
    vBVT$(s[s_]),
    qBVT$(s[s_]), 
    # Tabel-variable
    pRE, qRE, vRE
    pCGIX, qCGIX, vCGIX
    pCGI, qCGI, vCGI
    pCGIxLager, qCGIxLager, vCGIxLager
    pMvarer, qMvarer, vMvarer
    pMenergi, qMenergi, vMenergi
    pMtjenester, qMtjenester, vMtjenester
    pXvarer, qXvarer, vXvarer
    pXtjenester, qXtjenester, vXtjenester
    pIbm, qIbm, vIbm
    pIErhverv, qIErhverv, vIErhverv
    pIbErhverv, qIbErhverv, vIbErhverv
    pBVTspxudv, qBVTspxudv, vBVTspxudv
    pILager, pIStam, pIVaerdi
    vILager, vIStam, vIVaerdi
    qILager, qIStam, qIVaerdi
  ;

# ======================================================================================================================
# Exogenous variables
# ======================================================================================================================
  eIO.l[d,s] = 1.82; # Kastrup, Vasi & Vikkelsø 2023

  # Import til reeksport skal ikke reagere på relative priser
  eIO.l[x,s] = 0;
  # Lagerinvesteringer skal ikke reagere på relative priser
  eIO.l['iL',s] = 0;

  # Udvinding er i store træk eksogent - produktionen er eksogen og importandel er modelleret anderledes
  eIO.l[d,'udv'] = 0;
  eIO.l['udv',s] = 0;

  # Energiimport afhænger i meget højere grad af andre faktorer end priserne og elasticiteten er sat til 0
  eIO.l[d,'ene'] = 0;

  # Elasticitet for importandele sættes til 0, hvor der kun er meget små leverancer, jf. nedenfor (under data assignment)

  # Fastsættelse af kortsigtstrægheder
  upM2YTraeghed.l[dux,s] = 19.999548;

  # Elasticitet mellem import og indenlandske input sat tæt på 1 for at få en ren overgang beskrevet ovenfor (kan ikke være 1 med CES formulering)
  eIO.l[g,s] = 1.01;

# ======================================================================================================================
# Data assignment
# ======================================================================================================================  
  # Skøn for output fra udvindingsbranchen, som ikke er underlagt nordsøbeskatning etc.,
  # og som ikke udfases med nordsøpruduktion. Antages at vokse med gq og være 2,5 mia. i 2010-priser
  qGrus.l[t] = 2.5 / pY.l['udv','2010'] * fqt[t]/fqt['2010'];

  fpI_s.l[i,t] = 1;

  pBVT.l[s_,tBase]$(not s[s_]) = 1;
  pY.l[s_,tBase]$(not s[s_]) = 1;
  pRE.l[r_,tBase]$(not r[r_]) = 1;
  pR.l[r_,tBase]$(not r[r_]) = 1;
  pE.l[r_,tBase]$(not r[r_]) = 1;
  pI_s.l[i_,s_,tBase]$(iTot[i_]) = 1;
  pBruttoHandel.l[tBase] = 1;
  pMx.l[tBase] = 1;

  # Create dummies base on IO data
  # IO cells are exogenized if their value is very close to zero
  parameter min_cell_size[t]; min_cell_size[t] = 1e-9 / fvt['2010'];
  d1IOy[d,s,t] = abs(vIOy.l[d,s,t]) > min_cell_size[t];
  d1IOm[d,s,t] = abs(vIOm.l[d,s,t]) > min_cell_size[t];

  d1I_s[i_,s,t] = abs(vI_s.l[i_,s,t]) > min_cell_size[t];
  d1K[k,s,t]    = (qK.l[k,s,t] > 0);

  d1IOy[dTots,s,t] = sum(d$dTots2d[dTots,d], d1IOy[d,s,t]);
  d1IOm[dTots,s,t] = sum(d$dTots2d[dTots,d], d1IOm[d,s,t]);
  d1IOy[d_,sTot,t] = sum(s, d1IOy[d_,s,t]);
  d1IOm[d_,sTot,t] = sum(s, d1IOm[d_,s,t]);
  d1IO[d_,s_,t] = d1IOy[d_,s_,t] or d1IOm[d_,s_,t];
  d1I_s[iTot,s,t] = sum(i, d1I_s[i,s,t]);
  d1I_s[i,sByTot,t] = sum(sBy, d1I_s[i,sBy,t]);

  d1K[k,sTot,t]  = sum(s, d1K[k,s,t]);
  d1K[k,sByTot,t]  = sum(sBy, d1K[k,sBy,t]);
  d1K[k,spTot,t]  = sum(sp, d1K[k,sp,t]);
  d1K[kTot,s_,t] = sum(k, d1K[k,s_,t]);
  d1Xy[x_,t] = d1IOy[x_,sTot,t];
  d1Xy['xTur',t] = yes;
  d1Xm[x_,t] = d1IOm[x_,sTot,t];

  # Celler med leverancer mindre end 0.1 mia. kr. i enten vIOy eller vIOm sidste historiske år får en elasticitet på 0 (sikrer robusthed for solver)
  eIO.l[d,s] = eIO.l[d,s] * (vIOy.l[d,s,'%cal_deep%'] > 0.1 / fvt['2010'] and vIOm.l[d,s,'%cal_deep%'] > 0.1 / fvt['2010']);

  # Start-værdier for initialt laggede værdier
  # HACK: Midlertidigt rettet til større end 1970, da der ikke er værdier for tje og off før!
  rpIOm2pIOy.l[dux,s,t]$(d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0 and t.val > 1970) = pIOm.l[dux,s,t]/pIOy.l[dux,s,t];
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_IO_static_calibration_base
    G_IO_endo

    -pIO[dux_,s_,t], uIO0[dux,s_,t]$(d1IO[dux,s_,t]), rqIO2qYoff, rqIO2qG
    fuIO # E_fuIO, E_fuIO_r
    fuIOe[r,t] # E_fuIOe

    -qIOy, fuIOym[dux,s,t]$(d1IO[dux,s,t]), uIOXy0[x,s,t]$(d1IOy[x,s,t])
    fuIOXy[x,t] # E_fuIOXy

    -qIOm, uIOm0[dux,s,t]$(d1IOm[dux,s,t]), uIOXm0[x,s,t]$(d1IOm[x,s,t])
    fuIOXm[x,t] # E_fuIOXm

    -pCTurist, fpCTurist

    -pI_s[i,s,t], upI_s[i,s,t]

    -qC[cBol,t], qY[bol,t]
    -jluIOm[udv,t], qY[udv,t]
    qY[off,t], -qG[gTot,t]

    # Tabelvariable
    -vILager, rvILager2iL
    -vIStam, rvIStam2iL
    -pILager, jpILager
    -pIStam, jpIStam
  ;
  $GROUP G_IO_static_calibration
    G_IO_static_calibration_base$(tx0[t])
    pI_s[iTot,s,t0], -pI_s[iTot,s,tBase]
    pR[spTot,t0], -pR[spTot,tBase], pR[sByTot,t0], -pR[sByTot,tBase]
    pE[spTot,t0], -pE[spTot,tBase], pE[sByTot,t0], -pE[sByTot,tBase]
    pY[sByTot,t0], -pY[sByTot,tBase]
    pBVT[spTot,t0], -pBVT[spTot,tBase], pBVT[sByTot,t0], -pBVT[sByTot,tBase]
    pBruttoHandel[t0], -pBruttoHandel[tBase]
    pMx[t0], -pMx[tBase]
    tIOy_tBase[d,s]$(d1IOy[d,s,tBase])
    tIOm_tBase[d,s]$(d1IOm[d,s,tBase])
  ;

  $BLOCK B_IO_static_calibration   
    E_fuIO[cgi,t]$(tx0[t] and sum(s, d1IO[cgi,s,t])).. sum(s, uIO0[cgi,s,t]) =E= 1;
    E_fuIO_r[r,t]$(tx0[t] and sum(s$sMat[s], d1IO[r,s,t])).. sum(s$sMat[s], uIO0[r,s,t]) =E= 1;
    E_fuIOe[r,t]$(tx0[t] and sum(s$sEne[s], d1IO[r,s,t])).. sum(s$sEne[s], uIO0[r,s,t]) =E= 1;
    E_fuIOXy[x,t]$(tx0[t] and not xTur[x]).. sum(s, uIOXy0[x,s,t]) =E= 1;
    E_fuIOXm[x,t]$(tx0[t] and d1Xm[x,t]).. sum(s, uIOXm0[x,s,t]) =E= 1;
    E_uIOm0_NoM[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and not d1IOm[dux,s,t]).. uIOm0[dux,s,t] =E= 0;
    E_uIOm0_NoY[dux,s,t]$(tx0[t] and d1IOm[dux,s,t] and not d1IOy[dux,s,t]).. uIOm0[dux,s,t] =E= 1;
    E_tIOy_tBase[d,s]$(d1IOy[d,s,tBase]).. tIOy_tBase[d,s] =E= tIOy[d,s,tBase];
    E_tIOm_tBase[d,s]$(d1IOm[d,s,tBase]).. tIOm_tBase[d,s] =E= tIOm[d,s,tBase];
    E_rpIOm2pIOy_static[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0)..
      rpIOm2pIOy[dux,s,t] =E= pIOm[dux,s,t] / pIOy[dux,s,t]
                            - dpM2pYTraeghed[dux,s,t]
                            + dpM2pYTraeghed[dux,s,t]*fv / 2;
  $ENDBLOCK
  MODEL M_IO_static_calibration /
    M_IO
    B_IO_static_calibration
    -E_rpIOm2pIOy -E_rpIOm2pIOy_tEnd # E_rpIOm2pIOy_static
  /;

  $GROUP G_IO_static_calibration_newdata
    G_IO_static_calibration_base$(tx0[t])
   ;
  MODEL M_IO_static_calibration_newdata /
    M_IO_static_calibration
  /;
$ENDIF


# ======================================================================================================================
# Dynamic calibration
# ======================================================================================================================
$IF %stage% == "deep_dynamic_calibration":
  $GROUP G_IO_deep
    G_IO_endo
    -qIOy[dux,s,t]$(t1[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0)
    fuIOym[dux,s,t]$(t1[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0)
    -qIOm[dux,s,t]$(t1[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0)
    uIOm0[dux,s,t]$(t1[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0)
  ;
  $GROUP G_IO_deep G_IO_deep$(tx0[t]);

  # $BLOCK B_IO_deep
  # $ENDBLOCK

  MODEL M_IO_deep /
    M_IO
    # B_IO_deep
  /;
$ENDIF

# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
  uIOm0.l[dux,s,t]$(tx1[t] and d1IOm[dux,s,t] and d1IOy[dux,s,t])
    = min(0.999, max(0.001, uIOm0.l[dux,s,t1] * uIOm0_baseline[dux,s,t] / uIOm0_baseline[dux,s,t1]));

  $GROUP G_IO_dynamic_calibration
    G_IO_endo
    -rpIOm2pIOy[dux,s,t1], jpIOm2pIOy[dux,s,t1]
    # -qIOy[dux,s,t]$(t1[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0)
    # fuIOym[dux,s,t]$(t1[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0)
    # -qIOm[dux,s,t]$(t1[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0)
    # uIOm0[dux,s,t]$(t1[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0)
    # uIOm0[dux,s,t]$(tx1[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0 and uIOm0_baseline[dux,s,tEnd] > 0.05 and uIOm0_baseline[dux,s,tEnd] < 0.95) # E_uIOm0_dynamic
  ;
  $GROUP G_IO_dynamic_calibration G_IO_dynamic_calibration$(tx0[t]);
  # $BLOCK B_IO_dynamic_calibration
  #   E_uIOm0_dynamic[dux,s,t]$(tx1[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0
  #                                   and uIOm0_baseline[dux,s,tEnd] > 0.05 and uIOm0_baseline[dux,s,tEnd] < 0.95)..
  #     uIOm0[dux,s,t] =E= uIOm0[dux,s,t1] * uIOm0_baseline[dux,s,t] / uIOm0_baseline[dux,s,t1];
  # $ENDBLOCK
  MODEL M_IO_dynamic_calibration /
    M_IO
    # B_IO_dynamic_calibration
  /;
$ENDIF
