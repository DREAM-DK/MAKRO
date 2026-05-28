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
  $GROUP G_IO_variables
    # Values
    vY[s_,t] "Produktionsværdi fordelt på brancher, Kilde: ADAM[X] eller ADAM[X<i>]"
    vM[s_,t] "Import fordelt på importgrupper, Kilde: ADAM[M] eller ADAM[M<i>]"
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
    vC[c_,t] "Husholdningernes samlede forbrug fordelt på forbrugsgrupper og aggregater inkl. lejebolig og imputeret ejerbolig. Kilde: ADAM[Cp]"
    vCTurist[c,t]$(d1CTurist[c,t]) "Turisters forbrug i Danmark fordelt på forbrugsgrupper."
    vCDK[c_,t] "Det private forbrug inkl. turisters fordelt på forbrugsgrupper, Kilde: ADAM[Cp] + ADAM[Et] og ADAM[C<i>]"
    vG[g_,t] "Offentligt forbrug, Kilde: ADAM[Co]"
    vI[i_,t] "Investeringer fordelt på investeringstype, Kilde: ADAM[I] eller ADAM[iM] eller ADAM[iB]"
    vI_s[i_,s_,t]$(d1I_s[i_,s_,t]) "Investeringer fordelt på brancher, Kilde: ADAM[I<i>] eller ADAM[iM<i>] eller ADAM[iB<i>]"

    # Tabel-variable
    vRE[r_,t] "Aggregeret materiale- og energiinput fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[V] eller ADAM[V<i>]"
    vHandelsbalance[t] "Nominel handelsbalance (nettoeksport)"
    vCGIX[t] "Samlet efterspørgsel"
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

    # Quantities
    qY[s_,t] "Produktion fordelt på brancher, Kilde: ADAM[fX]"
    qM[s_,t] "Import fordelt på importgrupper, Kilde: ADAM[fM] eller ADAM[fM<i>]"
    qBVT[s_,t] "BVT, Kilde: ADAM[fYf] eller ADAM[fYf<i>]"
    qBNP[t] "BNP, Kilde: ADAM[fY]"

    qIO[d_,s_,t]$(dux_[d_] and d1IO[d_,s_,t]) "Imputeret branchefordelte leverancer fra både import og indenlandsk produktion fordelt på efterspørgselskomponenter."
    qIOy[d_,s_,t]$(d1IOy[d_,s_,t]) "Imputeret branchefordelte leverancer fra indenlandsk produktion fordelt på efterspørgselskomponenter."
    qIOm[d_,s_,t]$(d1IOm[d_,s_,t]) "Imputeret branchefordelte leverancer fra import fordelt på efterspørgselskomponenter."

    qR[r_,t] "Materialeinput fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[fVm] eller ADAM[fVm<i>]"
    qE[r_,t] "Energiinput fordelt på aftager-brancher, Kilde: ADAM[fVe] eller ADAM[fVe<i>]"
    qCDK[c_,t] "Det private forbrug inkl. turisters fordelt på forbrugsgrupper, Kilde: ADAM[fC<i>]"
    qC[c_,t] "Husholdningernes samlede forbrug fordelt på forbrugsgrupper og aggregater inkl. lejebolig og imputeret ejerbolig. Kilde: ADAM[fCp]"
    qI[i_,t] "Investeringer fordelt på investeringstype, Kilde: ADAM[fI] eller ADAM[fIm] eller ADAM[fIb]"  
    qI_s[i_,s_,t] "Investeringer fordelt på brancher, Kilde: ADAM[fI<i>] eller ADAM[fIm<i>] eller ADAM[fIb<i>]"

    # Tabel-variable
    qRE[r_,t] "Aggregeret materiale- og energiinput fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[fV] eller ADAM[fV<i>]"
    qHandelsbalance[t] "Real handelsbalance"
    qBruttoHandel[t] "Eksport + import i kædepriser"
    qCGIX[t] "Samlet efterspørgsel"
    qCGI[t] "Indenlandsk efterspørgsel"
    qCGIxLager[t] "Indenlandsk efterspørgsel ekskl. lagerinvesteringer"
    qIbm[t] "Investeringer ekskl. lagerinvesteringer"
    qIErhverv[t] "Private investeringer ekskl. lager- og boliginvesteringer, Kilde: ADAM[fIfp1xh]"
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
    
    # Prices
    pY[s_,t] "Produktionsdeflator fordelt på brancher, Kilde: ADAM[pX] eller ADAM[pX<i>]"
    pM[s_,t] "Importdeflator fordelt på importgrupper, Kilde: ADAM[pM] eller ADAM[pM<i>]"
    pBVT[s_,t] "BVT-deflator, Kilde: ADAM[pyf] eller ADAM[pyf<i>]"
    pBNP[t] "BNP-deflator, Kilde: ADAM[pY]"

    pIO[d_,s_,t]$(dux_[d_] and d1IO[d_,s_,t]) "Imputeret deflator for branchefordelte leverancer fra både import og indenlandsk produktion fordelt på efterspørgselskomponenter."
    pIOy[d_,s_,t]$(d1IOy[d_,s_,t]) "Imputeret deflator for branchefordelte leverancer fra indenlandsk produktion fordelt på efterspørgselskomponenter."
    pIOm[d_,s_,t]$(d1IOm[d_,s_,t]) "Imputeret deflator for branchefordelte leverancer fra import fordelt på efterspørgselskomponenter."

    pX[x_,t] "Eksportdeflator fordelt på eksportgrupper, Kilde: ADAM[pe] eller ADAM[pe<i>]"
    pXm[x_,t]$(d1Xm[x_,t]) "Deflator på import til reeksport."
    pXy[x_,t] "Deflator på direkte eksport."
    pR[r_,t] "Deflator på materiale-input fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[pvm] eller ADAM[pvm<i>]"
    pE[r_,t] "Deflator på energi-input fordelt på aftager-brancher, Kilde: ADAM[pvm] eller ADAM[pvm<i>]"
    pCDK[c_,t] "Forbrugsdeflator for forbrug inkl. turisters fordelt på forbrugsgrupper, Kilde: ADAM[pC<i>]"
    pCTurist[c,t]$(d1CTurist[c,t]) "Price index of tourists consumption by consumption group."
    pG[g_,t] "Deflator for offentligt forbrug, Kilde: ADAM[pco]"
    pI[i_,t] "Investeringsdeflator fordelt på investeringstyper, Kilde: ADAM[pI] eller ADAM[pim] eller ADAM[pib]"
    pI_iL_lag[t] "Lagget lagerinvesteringsdeflator benyttet til foregående års priser"
    pI_s[i_,s_,t]$(d1I_s[i_,s_,t]d1IOy) "Investeringsdeflator fordelt på brancher, Kilde: ADAM[pI<i>] eller ADAM[pim<i>] eller ADAM[pib<i>]"
    pI_s[i_,s_,t] "Investeringsdeflator fordelt på brancher, Kilde: ADAM[pI<i>] eller ADAM[pim<i>] eller ADAM[pib<i>]"

    pC[c_,t] "Imputeret prisindeks for forbrugskomponenter for husholdninger - dvs. ekskl. turisters forbrug."

    # Tabel-variable
    pRE[r_,t] "Deflator for aggregeret materiale- og energiinput fordelt på brancherne som modtager materialeinputtet, Kilde: ADAM[pv] eller ADAM[pv<i>]"
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

    jluIOm[s,t] "J-led."

    # Skalaparameter (endogene pga. balancerings-mekanismer)
    uIO[d_,s,t] "Skalaparameter for efterspørgselskomponents vægt på diverse input."
    uIOy[dux,s,t] "Skalaparameter for efterspørgselskomponents vægt på diverse indenlandske input."
    uIOm[dux,s,t] "Skalaparameter for efterspørgselskomponents vægt på diverse importerede input."
    uIOXy[x,s,t] "Skalaparameter for eksportkomponents vægt på diverse indenlandske input."
    uIOXm[x,s,t] "Skalaparameter for eksportkomponents vægt på diverse importerede input."

    # Alt offentligt salg til private er udbudsdrevet og uIO0 hhv. uIOXy0 giver sig.
    uIO0[d_,s_,t] "Skalaparameter for efterspørgselskomponents vægt på diverse input før endelig skalering."
    uIOXy0[x,s,t] "Skalaparameter for eksportkomponents vægt på diverse indenlandske input før endelig skalering."

    rpIOm2pIOy[d_,s,t] "Relativ pris mellem import og egenproduktion."

    dpM2pYTraeghed[dux,s,t] "Hjælpevariabel til beregning af effekt fra pristræghed."

    rpI[i_,s_,t] "Relative laggede priser i investeringer vægtet med nutidige mængder."
    rpCDK[c_,t] "Relative laggede priser i forbrug inkl. turisters vægtet med nutidige mængder."
    rpBNP[t] "Relative laggede priser i BNP vægtet med nutidige mængder."
    rpBVT[s_,t] "Relative laggede priser i BVT vægtet med nutidige mængder."
    rpY[s_,t] "Relative laggede output-priser vægtet med nutidige mængder."
    rpM[t] "Relative laggede import-priser vægtet med nutidige mængder."
    rpR[s_,t] "Relative laggede materiale-input-priser vægtet med nutidige mængder."
    rpE[s_,t] "Relative laggede energi-input-priser vægtet med nutidige mængder."
    rpC[t] "Relative laggede priser i privat forbrug vægtet med nutidige mængder."
    rpBruttoHandel[t] "Relative laggede priser i sum af eksport og import vægtet med nutidige mængder."
    rpRE[r_,t] "Relative laggede priser for aggregeret materiale- og energiinput vægtet med nutidige mængder."
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

  $GROUP G_IO_exogenous_forecast
    qY[s_,t]$(udv[s_])
    uIOXy0[x,s,t]$(udv[s]) "Skalaparameter for eksportkomponents vægt på diverse indenlandske input før endelig skalering."
    uIO0[d_,s_,t]$(sameas['iL',d_]) "Skalaparameter for efterspørgselskomponents vægt på diverse input før endelig skalering."
    uIOm0[dux,s,t]$(sameas['iL',dux]) "Importandel i efterspørgselskomponent."
    fuIO[d_,t]$(sameas['iL',dux]) "Korrektionsfaktor for skalaparametrene for efterspørgselskomponents vægt på diverse input."
    fuIOym[dux,s,t]$(sameas['iL',dux]) "Korrektionsfaktor for skalaparametrene for efterspørgselskomponents vægt på diverse hhv. indenlandske og importerede input."
    vM_Processing[t] "Import af processing i løbende priser"
    vM_Merchanting[t] "Import af merchanting i løbende priser"
    qM_Processing[t] "Import af processing i kædede priser"
    qM_Merchanting[t] "Import af merchanting i kædede priser"
  ;
  $GROUP+ G_exogenous_forecast G_IO_exogenous_forecast$(tx1[t]);

  $GROUP G_IO_forecast_as_zero
    jfpIOy[d_,t] "Pristillæg fra mermarkup fordelt på efterspørgseler - er 0 historisk."
    jfpIOm[d_,t] "Pristillæg fra mermarkup fordelt på efterspørgseler - er 0 historisk."
    jfpIO[d_,t] "Pristillæg - fælles for indlandsk og import."
    jpI_iL_lag[t] "J-led"
    jpILager[t] "J-led"
    jpIStam[t] "J-led"
    jpIOm2pIOy[dux,s,t] "J-led"
    qILagerDiskripans[t] "Diskripans i kædeaggregatet for lagerinvesteringer - kan sikre rimelige priser i fremskrivning"

    vMvarProc[t] ""
    vMvarMerc[t] ""
    vMtjeProc[t] ""
    vXvarProc[t] ""
    vXvarMerc[t] ""
    vXtjeProc[t] ""
    qMvarProc[t] ""
    qMvarMerc[t] ""
    qMtjeProc[t] ""
    qXtjeProc[t] ""
    qXvarProc[t] ""
    qXvarMerc[t] ""
    qXtjeProc[t] ""
  ;
  $GROUP+ G_forecast_as_zero G_IO_forecast_as_zero$(tx1[t]);

  $GROUP G_IO_ARIMA_forecast
    uIO0[d,s,t]$(d1IO[d,s,t] and not sameas['iL',d])
    uIOm0[dux,s,t]$(d1IO[dux,s,t] and not sameas['iL',dux])
    uIOXy0[x,s,t]$(d1IO[x,s,t] and not udv[s])
    uIOXm0[x,s,t]$(d1IO[x,s,t]) "Skalaparameter for eksportkomponents vægt på diverse importerede input før endelig skalering."
  ;
  $GROUP+ G_ARIMA_forecast G_IO_ARIMA_forecast;

  $GROUP G_IO_constants
    rpMTraeghed[d_,s] "Parameter til at styre kortsigtet priselasticitet."
    upM2YTraeghed[dux,s] "Parameter til at styre kortsigtet import-priselasticitet."
    eIO[d_,s_] "Substitutionselasticitet mellem import og indenlandsk produktion for diverse input for efterspørgselskomponenterne."
  ;
  $GROUP+ G_constants G_IO_constants;

  $GROUP G_IO_fixed_forecast
    rqIOy2qYoff[d_,t] "Offentlige leverancer til salg og til direkte investeringer som andel af samlet offentlig produktion."
    rvILager2iL[t] "Lagerinvesteringers andel af lagerinvesteringer, værdigenstande og stambesætninger."
    rvIstam2iL[t] "Stambesætningers andel af lagerinvesteringer, værdigenstande og stambesætninger."

    qGrus[t] "Eksogen mængde af produktion fra udvindingsbranche som ikke udfases, men heller ikke indgår i Nordsøbeskatning."

    fuIO[d_,t]$(not sameas['iL',d_]) "Korrektionsfaktor for skalaparametrene for efterspørgselskomponents vægt på diverse input."
    fuIOe[r,t] "Korrektionsfaktor for skalaparametrene for energiinputs vægt på diverse input."
    fuIOym[dux,s,t]$(not sameas['iL',dux]) "Korrektionsfaktor for skalaparametrene for efterspørgselskomponents vægt på diverse hhv. indenlandske og importerede input."
    fuIOXm[x,t] "Korrektionsfaktor for skalaparametrene for efterspørgselskomponents vægt på diverse input."
    fuIOXy[x,t] "Korrektionsfaktor for skalaparametrene for efterspørgselskomponents vægt på diverse input."
    fpCTurist[c,t] "Korrektion som fanger at turisters forbrug har anden deflator end indenlandske husholdninger."
    upI_s[i,s,t] "Skalaparameter som fanger forskelle i branchernes investerings-deflatorer for samme investeringstype."
    fpI_s[i,t] "Korrektionsfaktor som sørger for at vI_s summerer til vI."
  ;
  $GROUP+ G_fixed_forecast G_IO_fixed_forecast;
$ENDIF

# ======================================================================================================================
# Equations  
# ======================================================================================================================
$IF %stage% == "equations":
# We turn off domain checking for the IO submodel
# as subsets of the demand superset d_ are not always compatible with the general set structure.
# E.g. c cannot be subset of d_ and c_ at the same time, and we use dc[d_] here instead of c[c_]
  $onUni

  $BLOCK B_IO_core G_IO_core $(tx0[t])
    # ------------------------------------------------------------------------------------------------------------------
    # IO-cellernes mængder er givet ud fra efterspørgslen
    # ------------------------------------------------------------------------------------------------------------------   
    # Efterspørgselkomponenter fordeles på brancher - vi har efterspørgselskomponenter fra andre moduler
    # NB: uIO'erne er endogene - står under behavior
    $(d1IO[dr,sMat,t]).. qIO[dr,sMat,t] =E= uIO[dr,sMat,t] * qR[dr,t];
    $(d1IO[dr,sEne,t]).. qIO[dr,sEne,t] =E= uIO[dr,sEne,t] * qE[dr,t];
    $(d1IO[dc,s,t]).. qIO[dc,s,t] =E= uIO[dc,s,t] * qCDK[dc,t];
    $(d1IO[di,s,t]).. qIO[di,s,t] =E= uIO[di,s,t] * qI[di,t];
    $(d1IO[dg,s,t]).. qIO[dg,s,t] =E= uIO[dg,s,t] * qG[dg,t];

    # Offentligt salg til private og direkte investeringer følger offentligt produktion (fremfor at følge efterspørgsel)
    # Øvrige leverencer tager tilpasning via. skalering i E_uIO_cgi_s.
    uIO0[d_,'off',t]$((r_[d_] or c_[d_] or i_[d_]) and d[d_] and d1IOy[d_,'off',t])..
      qIOy[d_,'off',t] =E= rqIOy2qYoff[d_,t] * (1 + tIOy[d_,'off',tBase]) * qY['off',t];

    uIOXy0[x,'off',t]$(d1IOy[x,'off',t])..
      qIOy[x,'off',t] =E= rqIOy2qYoff[x,t] * (1 + tIOy[x,'off',tBase]) * qY['off',t];

    # Eksport særbehandles, da vi ikke har substitution mellem direkte eksport og import til reeksport
    # Vi har opdelt efterspørgslen på direkte eksport og import til reeksport i export.gms
    $(d1IOy[dx,s,t] and not xTur[dx]).. qIOy[dx,s,t] =E= uIOXy[dx,s,t] * qXy[dx,t];
    $(d1IOm[dx,s,t]).. qIOm[dx,s,t] =E= uIOXm[dx,s,t] * qXm[dx,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Markedsligevægt - produktion og import fordelt på brancher er summen af efterspørgsel givet fra IO-celler
    # ------------------------------------------------------------------------------------------------------------------
    # Produktionen for offentlige tjenester, udvinding og boligbenyttelse er ikke givet fra efterspørgselssiden
    # Givet qY bestemmer nedenstående ligning: qG[gTot,t] for off, jluIOm['udv',t] for udv og qC['cBol',t] for bol
    .. qY[s,t] =E= sum(d, qIOy[d,s,t] / (1 + tIOy[d,s,tBase]));
    .. qM[s,t] =E= sum(d, qIOm[d,s,t] / (1 + tIOm[d,s,tBase]));

    # Værdier
    .. vY[sp,t] =E= pY[sp,t] * qY[sp,t];
    pY[off,t].. vY[off,t] =E= pY[off,t] * qY[off,t]; # Kan ikke slås sammen med ovenstående, da vi ønsker res_pY[off,t] i dataår
    .. vM[s,t] =E= pM[s,t] * qM[s,t];

    # ------------------------------------------------------------------------------------------------------------------
    # IO-cellernes mængder er givet ud fra efterspørgslen
    # ------------------------------------------------------------------------------------------------------------------   
    # Priser på egenproduktion og import bestemmes af inputpriser (disse bestemmes i pricing.gms)
    $(d1IOy[d,s,t] or d1IOy[d,s,t+1])..
      pIOy[d,s,t] =E= (1 + tIOy[d,s,t]) / (1 + tIOy[d,s,tBase])
                    * (1 + jfpIOy[d,t] + jfpIO[d,t] + jfpIOy_s[s,t])
                    * pY[s,t];

    $((d1IOm[d,s,t] or d1IOm[d,s,t+1]))..
      pIOm[d,s,t] =E= (1 + tIOm[d,s,t]) / (1 + tIOm[d,s,tBase])
                    * (1 + jfpIOm[d,t] + jfpIO[d,t] + jfpIOm_s[s,t])
                    * pM[s,t];

    # Only used if the user wishes to deviate from law of one price in the IO system.
    # IO system should ensure that demand equals supply. If you shock the demand prices through jfpIOy or jfpIOm
    # then these equations ensure that this is still the case.
    jfpIOy_s[s,t]$(t.val > %cal_end%)..
      pY[s,t] * qY[s,t] =E= sum(d, pIOy[d,s,t] / (1 + tIOy[d,s,t]) * qIOy[d,s,t]);

    jfpIOm_s[s,t]$(t.val > %cal_end% and m[s])..
      pM[s,t] * qM[s,t] =E= sum(d, pIOm[d,s,t] / (1 + tIOm[d,s,t]) * qIOm[d,s,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # IO-budget-begrænsninger
    # ------------------------------------------------------------------------------------------------------------------
    # Værdier
    $(d1IOy[d,s,t]).. vIOy[d,s,t] =E= pIOy[d,s,t] * qIOy[d,s,t];
    $(d1IOm[d,s,t]).. vIOm[d,s,t] =E= pIOm[d,s,t] * qIOm[d,s,t];
    $(d1IO[d,s,t]).. vIO[d,s,t] =E= vIOy[d,s,t] + vIOm[d,s,t];

    # Deflator for input for aggregeret import og indenlandske input fordelt på brancher
    $(d1IO[d,s,t] and dux[d]).. pIO[d,s,t] * qIO[d,s,t] =E= vIO[d,s,t];

    # Efterspørgselskomponenter i værdier bestemmes ud fra værdier og hermed priser i IO-system
    .. vR[r,t] =E= sum(s$sMat[s], vIO[r,s,t]); # vR inkluderer ikke energi-input
    .. vE[r,t] =E= sum(s$sEne[s], vIO[r,s,t]); # vE er alene energi-input
    .. vC[c,t] + vCTurist[c,t] =E= sum(s, vIO[c,s,t]); # c-komponent i IO-celler inkluderer turisters forbrug i DK
    .. vI[i,t] =E= sum(s, vIO[i,s,t]);
    .. vG[g,t] =E= sum(s, vIO[g,s,t]);
    $(not xTur[x]).. vXy[x,t] =E= sum(s, vIOy[x,s,t]); 
    .. vXy['xTur',t] =E= sum(c, vCTurist[c,t]); # Turisters forbrug i DK opgøres som eksport
    .. vXm[x,t] =E= sum(s, vIOm[x,s,t]); 
    .. vX[x,t] =E= vXy[x,t] + vXm[x,t];

    # Priser på efterspørgselskomponenter
    .. pR[r,t] * qR[r,t] =E= vR[r,t];
    .. pE[r,t] * qE[r,t] =E= vE[r,t];
    .. pC[c,t] * qC[c,t] =E= vC[c,t];
    .. pG[g,t] * qG[g,t] =E= vG[g,t];
    .. pI[i,t] * qI[i,t] =E= vI[i,t];
    .. pX[x,t] * qX[x,t] =E= vX[x,t];

    .. pXy[x,t] * qXy[x,t] =E= vXy[x,t];
    $(d1Xm[x,t]).. pXm[x,t] * qXm[x,t] =E= vXm[x,t];

    # ------------------------------------------------------------------------------------------------------------------
    # Særlige forhold for investeringer og forbrug
    # ------------------------------------------------------------------------------------------------------------------
    # Investeringer er fordelt på brancher i production_private.gms - her fås de totale
    rpI[i,sTot,t].. qI[i,t] =E= rpI[i,sTot,t] * sum(s, qI_s[i,s,t]);
    qI[i,t].. pI[i,t-1]/fp * qI[i,t] =E= sum(s, pI_s[i,s,t-1]/fp * qI_s[i,s,t]);
    # De branche-fordelte investeringspriser er proportionale med den samlede investeringspris
    $(d1I_s[i,s,t]).. pI_s[i,s,t] =E= fpI_s[i,t] * upI_s[i,s,t] * pI[i,t];
    # Der afstemmes for konsistens - dette overholdes ikke dataår pga. manglende numerisk præcision i datainput
    fpI_s[i,t]$(t.val > %cal_end%).. vI[i,t] =E= sum(s, vI_s[i,s,t]);
    # Værdier på branchefordelte investeringer
    vI_s[i,sp,t]$(d1I_s[i,sp,t]).. pI_s[i,sp,t] * qI_s[i,sp,t] =E= vI_s[i,sp,t];

    # Prisen på turisters forbrug følger prisen på danske husholdningers forbrug
    $(d1CTurist[c,t]).. pCTurist[c,t] =E= fpCTurist[c,t] * pC[c,t];
    $(d1CTurist[c,t]).. vCTurist[c,t] =E= pCTurist[c,t] * qCTurist[c,t];

    # Forbrug i Danmark er summen af turisters og husholdningers forbrug
    .. vCDK[c,t] =E= vC[c,t] + vCTurist[c,t];
    .. pCDK[c,t] * qCDK[c,t] =E= vCDK[c,t];
    rpCDK[c,t].. qCDK[c,t] =E= rpCDK[c,t] * (qC[c,t] + qCTurist[c,t]);
    .. qCDK[c,t] * pCDK[c,t-1]/fp =E= pC[c,t-1]/fp * qC[c,t] + pCTurist[c,t-1]/fp * qCTurist[c,t];

    .. vCDK[cTot,t] =E= sum(c, vCDK[c,t]);
    .. pCDK[cTot,t] * qCDK[cTot,t] =E= vCDK[cTot,t];
    rpCDK[cTot,t].. qCDK[cTot,t] =E= rpCDK[cTot,t] * sum(c, qCDK[c,t]);
    .. qCDK[cTot,t] * pCDK[cTot,t-1]/fp =E= sum(c, pCDK[c,t-1]/fp * qCDK[c,t]);

    # ------------------------------------------------------------------------------------------------------------------
    # BNP - givet ud fra efterspørgselskomponenter og import
    # ------------------------------------------------------------------------------------------------------------------   
    .. vBNP[t] =E= vC[cTot,t] + vG[gTot,t] + vI[iTot,t] + vX[xTot,t] - vM[sTot,t];

    rpBNP[t].. 
      qBNP[t] =E= rpBNP[t] * (qC[cTot,t] + qG[gTot,t] + qI[iTot,t] + qX[xTot,t] - qM[sTot,t]);
  
    .. qBNP[t] * pBNP[t-1]/fp =E= pC[cTot,t-1]/fp * qC[cTot,t]
                                + pG[gTot,t-1]/fp * qG[gTot,t] 
                                + pI[iTot,t-1]/fp * qI[iTot,t]
                                + pX[xTot,t-1]/fp * qX[xTot,t] 
                                - pM[sTot,t-1]/fp * qM[sTot,t];

    .. pBNP[t] * qBNP[t] =E= vBNP[t];

    # ------------------------------------------------------------------------------------------------------------------
    # BVT - produktion minus materialeinput
    # ------------------------------------------------------------------------------------------------------------------   
    .. vBVT[s,t] =E= vY[s,t] - vE[s,t] - vR[s,t];

    rpBVT[s,t].. qBVT[s,t] =E= rpBVT[s,t] * (qY[s,t] - qR[s,t] - qE[s,t]);

    .. qBVT[s,t] * pBVT[s,t-1]/fp =E= pY[s,t-1]/fp * qY[s,t] 
                                    - pR[s,t-1]/fp * qR[s,t]
                                    - pE[s,t-1]/fp * qE[s,t];

    .. pBVT[s,t] * qBVT[s,t] =E= vBVT[s,t];
  $ENDBLOCK

  $GROUP+ G_IO_core
    qG[gTot,tx0], -qY[off,tx0],
    jluIOm[udv,tx0], -qY[udv,tx0],
    qC[cBol,tx0], -qY[bol,tx0]
  ;

  $BLOCK B_IO_forwardlooking G_IO_forwardlooking $(tx0[t])
    # Kortsigts-træghed i import
    $(not tEnd[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0)..
      rpIOm2pIOy[dux,s,t] =E= pIOm[dux,s,t] / pIOy[dux,s,t]
                            - dpM2pYTraeghed[dux,s,t]
                            + dpM2pYTraeghed[dux,s,t+1] * vIOm[dux,s,t+1]*fv / vIOm[dux,s,t] / (1+rVirkDisk[spTot,t+1])
                            + jpIOm2pIOy[dux,s,t];

    &_tEnd[dux,s,t]$(tEnd[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0)..
      rpIOm2pIOy[dux,s,t] =E= pIOm[dux,s,t] / pIOy[dux,s,t]
                            - dpM2pYTraeghed[dux,s,t]
                            + dpM2pYTraeghed[dux,s,t]*fv / (1+rVirkDisk[spTot,t])
                            + jpIOm2pIOy[dux,s,t];
  $ENDBLOCK

  $BLOCK B_IO_behavior G_IO_behavior $(tx0[t])
    $(d1IOy[dux,s,t] and d1IOm[dux,s,t] and d1IOy[dux,s,t-1] and d1IOm[dux,s,t-1] and eIO.l[dux,s] > 0)..
      dpM2pYTraeghed[dux,s,t] =E= upM2YTraeghed[dux,s] * rpIOm2pIOy[dux,s,t]
                                * (rpIOm2pIOy[dux,s,t] / rpIOm2pIOy[dux,s,t-1] - 1)
                                * (rpIOm2pIOy[dux,s,t] / rpIOm2pIOy[dux,s,t-1]);

    # CES-efterspørgsel
    # Import
    $(d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0)..
      qIOm[dux,s,t] * uIOy[dux,s,t] * rpIOm2pIOy[dux,s,t]**eIO[dux,s] =E= uIOm[dux,s,t] * qIOy[dux,s,t];

    # Egenproduktion
    qIOy[dux,s,t]$(d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0)..
       qIO[dux,s,t] =E= (
          uIOy[dux,s,t]**(1/eIO[dux,s]) * qIOy[dux,s,t]**((eIO[dux,s]-1)/eIO[dux,s])
        + uIOm[dux,s,t]**(1/eIO[dux,s]) * qIOm[dux,s,t]**((eIO[dux,s]-1)/eIO[dux,s])
      )**(eIO[dux,s]/(eIO[dux,s]-1));

    # Equations in cases where there are no imports or only imports
    &_NoY$(d1IOm[dux,s,t] and not d1IOy[dux,s,t] and eIO.l[dux,s] > 0)..
      qIOm[dux,s,t] =E= uIOm[dux,s,t] * qIO[dux,s,t] * (pIOm[dux,s,t] / pIO[dux,s,t])**(-eIO[dux,s]);
    &_NoM$(d1IOy[dux,s,t] and not d1IOm[dux,s,t] and eIO.l[dux,s] > 0)..
      qIOy[dux,s,t] =E= uIOy[dux,s,t] * qIO[dux,s,t] * (pIOy[dux,s,t] / pIO[dux,s,t])**(-eIO[dux,s]);

    # Equations in cases of zero substitutability
    &_e0$(d1IOy[dux,s,t] and eIO.l[dux,s] = 0)..
      qIOy[dux,s,t] =E= uIOy[dux,s,t] * qIO[dux,s,t];
    &_e0$(d1IOm[dux,s,t] and eIO.l[dux,s] = 0)..
      qIOm[dux,s,t] =E= uIOm[dux,s,t] * qIO[dux,s,t];

    # --------------------------------------------------------------------------------------------------------------------
    # Endogen balancering af skala-parametre
    # --------------------------------------------------------------------------------------------------------------------
    $(d1IO[cgi,s,t])..
      uIO[cgi,s,t] =E= fuIO[cgi,t] * uIO0[cgi,s,t] / sum(ss, uIO0[cgi,ss,t]);
    &_sMat$(d1IO[dr,s,t] and sMat[s])..
      uIO[dr,s,t] =E= fuIO[dr,t] * uIO0[dr,s,t] / sum(ss$sMat[ss], uIO0[dr,ss,t]);
    &_sEne$(d1IO[dr,s,t] and sEne[s])..
      uIO[dr,s,t] =E= fuIOe[dr,t] * uIO0[dr,s,t] / sum(ss$sEne[ss], uIO0[dr,ss,t]);


    $(d1IOy[dux,s,t] and d1IOm[dux,s,t])..
      uIOy[dux,s,t] =E= fuIOym[dux,s,t] - uIOm[dux,s,t];
    &_NoM$(d1IOy[dux,s,t] and not d1IOm[dux,s,t])..
      uIOy[dux,s,t] =E= fuIOym[dux,s,t];

    &_jluIOm$(d1IOy[dux,s,t] and d1IOm[dux,s,t] and jluIOm.up[s,t] <> 0)..
      uIOm[dux,s,t] =E= fuIOym[dux,s,t] * uIOm0[dux,s,t] * (1 + jluIOm[s,t])
                      / (uIOm0[dux,s,t] * (1 + jluIOm[s,t]) + (1 - uIOm0[dux,s,t]) * (1 - jluIOm[s,t]));
    $(d1IOy[dux,s,t] and d1IOm[dux,s,t] and jluIOm.up[s,t] = 0)..
      uIOm[dux,s,t] =E= fuIOym[dux,s,t] * uIOm0[dux,s,t];

    &_NoY$(d1IOm[dux,s,t] and not d1IOy[dux,s,t])..
      uIOm[dux,s,t] =E= fuIOym[dux,s,t];

    $(d1IOy[x,s,t])..
      uIOXy[x,s,t] =E= fuIOXy[x,t] * uIOXy0[x,s,t] / sum(ss$(d1IOy[x,ss,t]), uIOXy0[x,ss,t]);
    $(d1IOm[x,s,t])..
      uIOXm[x,s,t] =E= fuIOXm[x,t] * uIOXm0[x,s,t] / sum(ss$(d1IOm[x,ss,t]), uIOXm0[x,ss,t]);
  $ENDBLOCK
  $offUni

  $BLOCK B_IO_bookkeeping G_IO_bookkeeping$(tx0[t])
    # ------------------------------------------------------------------------------------------------------------------
    # Beregning af totaler ud fra kædeindeks
    # ------------------------------------------------------------------------------------------------------------------   
    # Samlet BVT
    .. vBVT[sTot,t] =E= vY[sTot,t] - vR[rTot,t] - vE[rTot,t];
    rpBVT[sTot,t].. qBVT[sTot,t] =E= rpBVT[sTot,t] * (qY[sTot,t] - qR[rTot,t] - qE[rTot,t]);
    .. qBVT[sTot,t] * pBVT[sTot,t-1]/fp =E= pY[sTot,t-1]/fp * qY[sTot,t] 
                                          - pR[rTot,t-1]/fp * qR[rTot,t]
                                          - pE[rTot,t-1]/fp * qE[rTot,t];
    .. pBVT[sTot,t] * qBVT[sTot,t] =E= vBVT[sTot,t];

    # Privat BVT
    .. vBVT[spTot,t] =E= vY[spTot,t] - vE[spTot,t] - vR[spTot,t];
    rpBVT[spTot,t].. qBVT[spTot,t] =E= rpBVT[spTot,t] * (qY[spTot,t] - qR[spTot,t] - qE[spTot,t]);
    .. qBVT[spTot,t] * pBVT[spTot,t-1]/fp =E= pY[spTot,t-1]/fp * qY[spTot,t] 
                                            - pR[spTot,t-1]/fp * qR[spTot,t] 
                                            - pE[spTot,t-1]/fp * qE[spTot,t];
    .. pBVT[spTot,t] * qBVT[spTot,t] =E= vBVT[spTot,t];
  
    # BVT i private byerhverv
    .. vBVT[sByTot,t] =E= vY[sByTot,t] - vE[sByTot,t] - vR[sByTot,t];
    rpBVT[sByTot,t].. qBVT[sByTot,t] =E= rpBVT[sByTot,t] * (qY[sByTot,t] - qR[sByTot,t] - qE[sByTot,t]);
    .. qBVT[sByTot,t] * pBVT[sByTot,t-1]/fp =E= pY[sByTot,t-1]/fp * qY[sByTot,t]
                                              - pE[sByTot,t-1]/fp * qE[sByTot,t]
                                              - pR[sByTot,t-1]/fp * qR[sByTot,t];
    .. pBVT[sByTot,t] * qBVT[sByTot,t] =E= vBVT[sByTot,t];

    # Samlet produktion
    .. vY[sTot,t] =E= sum(s, vY[s,t]);
    rpY[sTot,t].. qY[sTot,t] =E= rpY[sTot,t] * sum(s, qY[s,t]);
    .. qY[sTot,t] * pY[sTot,t-1]/fp =E= sum(s, pY[s,t-1]/fp * qY[s,t]);
    .. pY[sTot,t] * qY[sTot,t] =E= vY[sTot,t];

    # Privat produktion
    .. vY[spTot,t] =E= sum(sp, vY[sp,t]);
    rpY[spTot,t].. qY[spTot,t] =E= rpY[spTot,t] * sum(sp, qY[sp,t]);
    .. qY[spTot,t] * pY[spTot,t-1]/fp =E= sum(sp, pY[sp,t-1]/fp * qY[sp,t]);
    .. pY[spTot,t] * qY[spTot,t] =E= vY[spTot,t];

    # Produktion i private byerhverv
    .. vY[sByTot,t] =E= sum(sBy, vY[sBy,t]);
    rpY[sByTot,t].. qY[sByTot,t] =E= rpY[sByTot,t] * sum(sBy, qY[sBy,t]);
    .. qY[sByTot,t] * pY[sByTot,t-1]/fp =E= sum(sBy, pY[sBy,t-1]/fp * qY[sBy,t]);
    .. pY[sByTot,t] * qY[sByTot,t] =E= vY[sByTot,t];

    # Samlet import
    .. vM[sTot,t] =E= sum(s, vM[s,t]);
    rpM[t].. qM[sTot,t] =E= rpM[t] * sum(s, qM[s,t]);
    .. qM[sTot,t] * pM[sTot,t-1]/fp =E= sum(s, pM[s,t-1]/fp * qM[s,t]);
    .. pM[sTot,t] * qM[sTot,t] =E= vM[sTot,t];

    # Samlet eksport
    .. pX[xTot,t] * qX[xTot,t] =E= vX[xTot,t];
    .. vX[xTot,t] =E= sum(x, vX[x,t]);

    # Samlet direkte eksport
    .. vXy[xTot,t] =E= sum(x, vXy[x,t]);
    .. pXy[xTot,t] * qXy[xTot,t] =E= vXy[xTot,t];

    # Samlet import til reeksport
    .. vXm[xTot,t] =E= sum(x, vXm[x,t]);
    .. pXm[xTot,t] * qXm[xTot,t] =E= vXm[xTot,t];

    # Samlede investeringer
    .. vI[iTot,t] =E= sum(i, vI[i,t]);
    rpI[iTot,sTot,t].. qI[iTot,t] =E= rpI[iTot,sTot,t] * sum(i, qI[i,t]);
    .. qI[iTot,t] * pI[iTot,t-1]/fp =E= sum(k, pI[k,t-1]/fp * qI[k,t]) + pI_iL_lag[t] * qI['iL',t];
    .. pI[iTot,t] * qI[iTot,t] =E= vI[iTot,t];

    # Lagerinvesteringsprisen er mange gange meget støjfyldt i foreløbige år og kan være negativ!
    # Det gør, at effekten fra lagerinvesteringerne på aggregatet i første fremskrivningsår kan være misvisende.
    # Indtil nu er data blevet revideret til noget mere fornuftigt for endelige år.
    # Vi benytter derfor ikke faktiske laggede priser, men en pris som inkluderer et j-led.
    # J-leddet sættes, så effekten fra lagerinvesteringerne på aggregatet i første fremskrivningsår er rimelig.
    .. pI_iL_lag[t] =E= pI['iL',t-1]/fp + jpI_iL_lag[t];

    # Samlet materialeinput til produktion ekskl. energi
    .. vR[rTot,t] =E= sum(r, vR[r,t]);
    rpR[rTot,t].. qR[rTot,t] =E= rpR[rTot,t] * sum(r, qR[r,t]);
    .. qR[rTot,t] * pR[rTot,t-1]/fp =E= sum(r, pR[r,t-1]/fp * qR[r,t]);
    .. pR[rTot,t] * qR[rTot,t] =E= vR[rTot,t];

    # Materialeinput ekskl. energi til private brancher
    .. vR[spTot,t] =E= sum(sp, vR[sp,t]);
    rpR[spTot,t].. qR[spTot,t] =E= rpR[spTot,t] * sum(sp, qR[sp,t]);
    .. qR[spTot,t] * pR[spTot,t-1]/fp =E= sum(sp, pR[sp,t-1]/fp * qR[sp,t]);
    .. pR[spTot,t] * qR[spTot,t] =E= vR[spTot,t];

    # Materialeinput ekskl. energi til private byerhverv
    .. vR[sByTot,t] =E= sum(sBy, vR[sBy,t]);
    rpR[sByTot,t].. qR[sByTot,t] =E= rpR[sByTot,t] * sum(sBy, qR[sBy,t]);
    .. qR[sByTot,t] * pR[sByTot,t-1]/fp =E= sum(sBy, pR[sBy,t-1]/fp * qR[sBy,t]);
    .. pR[sByTot,t] * qR[sByTot,t] =E= vR[sByTot,t];

    # Samlet energiinput til produktion
    .. vE[rTot,t] =E= sum(r, vE[r,t]);
    rpE[rTot,t].. qE[rTot,t] =E= rpE[rTot,t] * sum(r, qE[r,t]);
    .. qE[rTot,t] * pE[rTot,t-1]/fp =E= sum(r, pE[r,t-1]/fp * qE[r,t]);
    .. pE[rTot,t] * qE[rTot,t] =E= vE[rTot,t];

    # Samlet energiinput til produktion til private brancher
    .. vE[spTot,t] =E= sum(sp, vE[sp,t]);
    rpE[spTot,t].. qE[spTot,t] =E= rpE[spTot,t] * sum(sp, qE[sp,t]);
    .. qE[spTot,t] * pE[spTot,t-1]/fp =E= sum(sp, pE[sp,t-1]/fp * qE[sp,t]);
    .. pE[spTot,t] * qE[spTot,t] =E= vE[spTot,t];

    # Samlet energiinput til produktion til private byerhverv
    .. vE[sByTot,t] =E= sum(sBy, vE[sBy,t]);
    rpE[sByTot,t].. qE[sByTot,t] =E= rpE[sByTot,t] * sum(sBy, qE[sBy,t]);
    .. qE[sByTot,t] * pE[sByTot,t-1]/fp =E= sum(sBy, pE[sBy,t-1]/fp * qE[sBy,t]);
    .. pE[sByTot,t] * qE[sByTot,t] =E= vE[sByTot,t];

    # Samlet privat forbrug (til danske husholdninger)
    .. vC[cTot,t] =E= sum(c, vC[c,t]);
    rpC[t].. qC[cTot,t] =E= rpC[t] * sum(c, qC[c,t]);
    .. qC[cTot,t] * pC[cTot,t-1]/fp =E= sum(c, pC[c,t-1]/fp * qC[c,t]);
    .. pC[cTot,t] * qC[cTot,t] =E= vC[cTot,t];

    # Samlet offentligt forbrug
    .. vG[gTot,t] =E= sum(g, vG[g,t]);
    .. pG[gTot,t] =E= vG[gTot,t] / qG[gTot,t];

    # Samlede indenlandske input fordelt på efterspørgselskomponenter
    $(d1IOy[d,sTot,t]).. vIOy[d,sTot,t] =E= sum(s, vIOy[d,s,t]);

    # Samlede importinput fordelt på efterspørgselskomponenter
    $(d1IOm[d,sTot,t]).. vIOm[d,sTot,t] =E= sum(s, vIOm[d,s,t]);

    # Samlede indenlandske input fordelt på brancher
    $(d1IOy[dTots,s,t]).. vIOy[dTots,s,t] =E= sum(d$dTots2d[dtots,d], vIOy[d,s,t]);

    # Samlede importinput fordelt på brancher
    $(d1IOm[dTots,s,t]).. vIOm[dTots,s,t] =E= sum(d$dTots2d[dtots,d], vIOm[d,s,t]); 

    # Branchevise samlede investeringer
    .. vI_s[iTot,s,t] =E= sum(i, vI_s[i,s,t]);
    rpI[iTot,s,t].. qI_s[iTot,s,t] =E= rpI[iTot,s,t] * sum(i, qI_s[i,s,t]);
    .. qI_s[iTot,s,t] * pI_s[iTot,s,t-1]/fp =E= sum(i, pI_s[i,s,t-1]/fp * qI_s[i,s,t]);
    .. pI_s[iTot,s,t] * qI_s[iTot,s,t] =E= vI_s[iTot,s,t];

    # Investeringer i private brancher
    rpI[i,spTot,t]$(not iL[i]).. qI_s[i,spTot,t] =E= rpI[i,spTot,t] * sum(sp, qI_s[i,sp,t]);
    $(not iL[i]).. qI_s[i,spTot,t] * pI_s[i,spTot,t-1]/fp =E= sum(sp, pI_s[i,sp,t-1]/fp * qI_s[i,sp,t]);
    $(not iL[i]).. pI_s[i,spTot,t] * qI_s[i,spTot,t] =E= vI_s[i,spTot,t];
    $(not iL[i]).. vI_s[i,spTot,t] =E= sum(sp, vI_s[i,sp,t]);

    # Samlede investeringer i private brancher
    .. vI_s[iTot,spTot,t] =E= sum(sp, vI_s[iTot,sp,t]);

    # Investeringer i private byerhverv
    rpI[i,sByTot,t]$(not iL[i]).. qI_s[i,sByTot,t] =E= rpI[i,sByTot,t] * sum(sBy, qI_s[i,sBy,t]);
    $(not iL[i]).. qI_s[i,sByTot,t] * pI_s[i,sByTot,t-1]/fp =E= sum(sBy, pI_s[i,sBy,t-1]/fp * qI_s[i,sBy,t]);
    $(not iL[i]).. pI_s[i,sByTot,t] * qI_s[i,sByTot,t] =E= vI_s[i,sByTot,t];
    $(not iL[i]).. vI_s[i,sByTot,t] =E= sum(sBy, vI_s[i,sBy,t]);

    # -------------------------------------------------------------------------------------------------------------------
    # Ligninger til tabel-variable
    # -------------------------------------------------------------------------------------------------------------------
    .. pBruttoHandel[t] * qBruttoHandel[t] =E= vX[xTot,t] + vM[sTot,t]; 
    rpBruttoHandel[t].. qBruttoHandel[t] =E= rpBruttoHandel[t] * (qX[xTot,t] + qM[sTot,t]);
    .. qBruttoHandel[t] * pBruttoHandel[t-1]/fp =E= pX[xTot,t-1]/fp * qX[xTot,t] + pM[sTot,t-1]/fp * qM[sTot,t]; 
    .. qHandelsbalance[t] =E= vHandelsbalance[t] / pBruttoHandel[t];
    .. vHandelsbalance[t] =E= vX[xTot,t] - vM[sTot,t];

    # Materialeinput inkl. energi
    .. vRE[r,t] =E= vR[r,t] + vE[r,t];
    rpRE[r,t].. qRE[r,t] =E= rpRE[r,t] * (qR[r,t] + qE[r,t]);
    .. qRE[r,t] * pRE[r,t-1]/fp =E= pR[r,t-1]/fp * qR[r,t] + pE[r,t-1]/fp * qE[r,t];
    .. pRE[r,t] * qRE[r,t] =E= vRE[r,t];

    .. vRE[rTot,t] =E= vR[rTot,t] + vE[rTot,t];
    rpRE[rTot,t].. qRE[rTot,t] =E= rpRE[rTot,t] * (qR[rTot,t] + qE[rTot,t]);
    .. qRE[rTot,t] * pRE[rTot,t-1]/fp =E= pR[rTot,t-1]/fp * qR[rTot,t] + pE[rTot,t-1]/fp * qE[rTot,t];
    .. pRE[rTot,t] * qRE[rTot,t] =E= vRE[rTot,t];

    # Samlet efterspørgsel
    $(t.val >= 1995).. vCGIX[t] =E= vC[cTot,t] + vG[gTot,t] + vI[iTot,t] + vX[xTot,t];
    rpCGIX[t]$(t.val >= 1995).. 
      qCGIX[t] =E= rpCGIX[t] * (qC[cTot,t] + qG[gTot,t] + qI[iTot,t] + qX[xTot,t]);
    $(t.val >= 1995).. qCGIX[t] * pCGIX[t-1]/fp =E= pC[cTot,t-1]/fp * qC[cTot,t]
                                                  + pG[gTot,t-1]/fp * qG[gTot,t] 
                                                  + pI[iTot,t-1]/fp * qI[iTot,t]
                                                  + pX[xTot,t-1]/fp * qX[xTot,t];
    $(t.val >= 1995).. pCGIX[t] * qCGIX[t] =E= vCGIX[t];
 
    # Indenlandsk efterspørgsel
    .. vCGI[t] =E= vC[cTot,t] + vG[gTot,t] + vI[iTot,t];
    rpCGI[t].. qCGI[t] =E= rpCGI[t] * (qC[cTot,t] + qG[gTot,t] + qI[iTot,t]);
    .. qCGI[t] * pCGI[t-1]/fp =E= pC[cTot,t-1]/fp * qC[cTot,t]
                                + pG[gTot,t-1]/fp * qG[gTot,t] 
                                + pI[iTot,t-1]/fp * qI[iTot,t];
    .. pCGI[t] * qCGI[t] =E= vCGI[t];

    # Indenlandsk efterspørgsel ekskl. lagerinvesteringer
    .. vCGIxLager[t] =E= vCGI[t] - vILager[t];
    rpCGIxLager[t].. qCGIxLager[t] =E= rpCGIxLager[t] * (qCGI[t] - qILager[t]);
    .. qCGIxLager[t] * pCGIxLager[t-1]/fp =E= pCGI[t-1]/fp * qCGI[t] - pILager[t-1]/fp * qILager[t];
    .. pCGIxLager[t] * qCGIxLager[t] =E= vCGIxLager[t];

    # Investeringsaggregater
    .. vIbm[t] =E= vI['iB',t] + vI['iM',t];
    .. qIbm[t] * pIbm[t-1]/fp =E= pI['iB',t-1]/fp * qI['iB',t] + pI['iM',t-1]/fp * qI['iM',t];
    .. pIbm[t] * qIbm[t] =E= vIbm[t];
    .. vIbErhverv[t] =E= vI['iB',t] - vI_s['iB','off',t] - vI_s['iB','bol',t];
    rpIbErhverv[t].. qIbErhverv[t] =E= rpIbErhverv[t] * (qI['iB',t] - qI_s['iB','off',t] - qI_s['iB','bol',t]);
    .. qIbErhverv[t] * pIbErhverv[t-1]/fp =E= pI['iB',t-1]/fp * qI['iB',t]
                                            - pI_s['iB','off',t-1]/fp * qI_s['iB','off',t]
                                            - pI_s['iB','bol',t-1]/fp * qI_s['iB','bol',t];
    .. pIbErhverv[t] * qIbErhverv[t] =E= vIbErhverv[t];

    # Eksport-aggregater
    .. vXvarer[t] =E= vX['xVar',t] + vX['xEne',t];
    rpXvarer[t].. qXvarer[t] =E= rpXVarer[t] * (qX['xVar',t] + qX['xEne',t]);
    .. qXvarer[t] * pXvarer[t-1]/fp =E= pX['xVar',t-1]/fp * qX['xVar',t] 
                                                  + pX['xEne',t-1]/fp * qX['xEne',t];
    .. pXvarer[t] * qXvarer[t] =E= vXvarer[t];
    .. vXtjenester[t] =E= vX['xTje',t] + vX['xSoe',t] + vX['xTur',t];
    rpXtjenester[t].. 
      qXtjenester[t] =E= rpXtjenester[t] * (qX['xTje',t] + qX['xSoe',t] + qX['xTur',t]);
    .. qXtjenester[t] * pXtjenester[t-1]/fp =E= pX['xTje',t-1]/fp * qX['xTje',t]
                                                              + pX['xSoe',t-1]/fp * qX['xSoe',t]
                                                              + pX['xTur',t-1]/fp * qX['xTur',t];
    .. pXtjenester[t] * qXtjenester[t] =E= vXtjenester[t];

    # Import-aggregater
    .. vMvarer[t] =E= vM['fre',t] + vM['ene',t] + vM['udv',t];
    rpMvarer[t].. qMvarer[t] =E= rpMvarer[t] * (qM['fre',t] + qM['ene',t] + qM['udv',t]);
    .. qMvarer[t] * pMvarer[t-1]/fp =E= pM['fre',t-1]/fp * qM['fre',t] 
                                      + pM['ene',t-1]/fp * qM['ene',t]
                                      + pM['udv',t-1]/fp * qM['udv',t];
    .. pMvarer[t] * qMvarer[t] =E= vMvarer[t];

    .. vMenergi[t] =E= vM['ene',t] + vM['udv',t];
    rpMenergi[t].. qMenergi[t] =E= rpMenergi[t] * (qM['ene',t] + qM['udv',t]);
    .. qMenergi[t] * pMenergi[t-1]/fp =E= pM['ene',t-1]/fp * qM['ene',t]
                                        + pM['udv',t-1]/fp * qM['udv',t];
    .. pMenergi[t] * qMenergi[t] =E= vMenergi[t];

    .. vMtjenester[t] =E= vM['tje',t] + vM['soe',t];
    rpMtjenester[t].. qMtjenester[t] =E= rpMtjenester[t] * (qM['tje',t] + qM['soe',t]);
    .. qMtjenester[t] * pMtjenester[t-1]/fp =E= pM['tje',t-1]/fp * qM['tje',t] 
                                              + pM['soe',t-1]/fp * qM['soe',t];
    .. pMtjenester[t] * qMtjenester[t] =E= vMtjenester[t];

    .. vMx[t] =E= vM['tje',t] + vM['fre',t];
    rpMx[t].. qMx[t] =E= rpMx[t] * (qM['tje',t] + qM['fre',t]);
    .. qMx[t] * pMx[t-1]/fp =E= pM['tje',t-1]/fp * qM['tje',t] + pM['fre',t-1]/fp * qM['fre',t];
    .. pMx[t] * qMx[t] =E= vMx[t];

    # BVT-aggregater
    .. vBVTspxudv[t] =E= vBVT[spTot,t] - vBVT['udv',t];
    rpBVTspxudv[t].. qBVTspxudv[t] =E= rpBVTspxUdv[t] * (qBVT[spTot,t] - qBVT['udv',t]);
    .. qBVTspxudv[t] * pBVTspxudv[t-1]/fp =E= pBVT[spTot,t-1]/fp * qBVT[spTot,t]
                                            - pBVT['udv',t-1]/fp * qBVT['udv',t];
    .. pBVTspxudv[t] * qBVTspxudv[t] =E= vBVTspxudv[t];

    # Lagerinvesteringer fordelt på rene lagerinvesteringer, stambesætninger og værdigenstande
    .. vILager[t] =E= rvILager2iL[t] * vI['iL',t];
    .. pILager[t] =E= pI['iL',t] + jpILager[t];
    qILager[t].. vILager[t] =E= pILager[t] * qILager[t];

    .. vIStam[t] =E= rvIstam2iL[t] * vI['iL',t];
    .. pIStam[t] =E= pI['iL',t] + jpIStam[t];
    qIStam[t].. vIStam[t] =E= pIStam[t] * qIStam[t];

    vIVaerdi[t].. vI['iL',t] =E= vIStam[t] + vIVaerdi[t] + vILager[t];    
    rpIVaerdi[t].. qIVaerdi[t] =E= rpIVaerdi[t] * (qI['iL',t] - qIStam[t] - qILager[t]);
    qIVaerdi[t].. pI['iL',t-1]/fp * qI['iL',t] =E= pIStam[t-1]/fp * qIStam[t]
                                                 + pIVaerdi[t-1]/fp * qIVaerdi[t]
                                                 + pILager[t-1]/fp * qILager[t]
                                                 + pI['iL',t-1]/fp * qILagerDiskripans[t];
    pIVaerdi[t].. vIVaerdi[t] =E= pIVaerdi[t] * qIVaerdi[t];

    .. vIErhverv[t] =E= vIbm[t] - vI_s['iM','off',t] - vI_s['IB','off',t] - vI_s['IB','bol',t] + vIStam[t];
    rpIErhverv[t].. qIErhverv[t] =E= rpIErhverv[t] * (qIbm[t] - qI_s['iM','off',t] - qI_s['iB','off',t] - qI_s['iB','bol',t] + qIStam[t]);
    .. qIErhverv[t] * pIErhverv[t-1]/fp =E= pIbm[t-1]/fp * qIbm[t]
                                          - pI_s['iM','off',t-1]/fp * qI_s['iM','off',t]
                                          - pI_s['iB','off',t-1]/fp * qI_s['iB','off',t]
                                          - pI_s['iB','bol',t-1]/fp * qI_s['iB','bol',t]
                                          + pIStam[t-1]/fp * qIStam[t];
    .. pIErhverv[t] * qIErhverv[t] =E= vIErhverv[t];
  $ENDBLOCK

  $GROUP G_IO_endo G_IO_core, G_IO_forwardlooking, G_IO_behavior, G_IO_bookkeeping;
  $GROUP+ G_Endo G_IO_endo;

  MODEL M_IO /
    B_IO_core
    B_IO_forwardlooking
    B_IO_behavior
    B_IO_bookkeeping

    pCTurist(d1CTurist)
    qIO(d1IO)
    qIOy(d1IOy)
    qIOm(d1IOm)
    vIO(d1IO)
    vIOy(d1IOy)
    vIOm(d1IOm)
    vCTurist(d1CTurist)
  /;
  model M_base / M_IO /;

  $GROUP G_IO_static G_IO_endo, -G_IO_forwardlooking;
  $GROUP+ G_static G_IO_static;

  MODEL M_IO_static / M_IO - B_IO_forwardlooking /;
  model M_static / M_IO_static /;
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
    pXm$(x[x_] or xTot[x_]), 
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
    qIO$(s[s_] and d[d_]), qIOy$(s[s_]), qIOm$(s[s_]), qM[s,t], qM[sTot,t] 
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

    vMvarProc, vMvarMerc, vMtjeProc, vXvarProc, vXvarMerc, vXtjeProc
    qMvarProc, qMvarMerc, qMtjeProc, qXtjeProc, qXvarProc, qXvarMerc, qXtjeProc
  ;
  @load(G_IO_makrobk, "../Data/Makrobk/makrobk.gdx" )

  # Variable som er datadækket og ikke må ændres af kalibrering
  $GROUP G_IO_data
    G_IO_makrobk
    -pIOy$(not d1IOy[d_,s_,t])
    -pIOm$(not d1IOm[d_,s_,t])
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
    pRE$(r[r_] or rTot[r_]), qRE$(r[r_] or rTot[r_]), vRE$(r[r_] or rTot[r_])
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
  d1IOy[d,s,t] = vIOy.l[d,s,t] > 1e-4*fvt[t];
  d1IOm[d,s,t] = vIOm.l[d,s,t] > 1e-4*fvt[t];
  d1IOy[d,s,t]$(mapVal(vIOy.l[d,s,t]) = 5) = 0;
  d1IOm[d,s,t]$(mapVal(vIOm.l[d,s,t]) = 5) = 0;
  # I foreløbige år tillader vi ikke nye celler at opstå (men de må gerne udgå).
  # Hvis dette giver store residualer, er det fint at få en eksplicit residual-fejl, som bør undersøges.
  d1IOy[d,s,t]$(t.val > %cal_deep%) = smin(tt$(%cal_deep% <= tt.val and tt.val <= t.val), d1IOy[d,s,tt]);
  d1IOm[d,s,t]$(t.val > %cal_deep%) = smin(tt$(%cal_deep% <= tt.val and tt.val <= t.val), d1IOm[d,s,tt]);

  d1I_s[i_,s,t] = abs(vI_s.l[i_,s,t]) > 1e-9;
  d1K[k,s,t] = qK.l[k,s,t] > 1e-9;

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

  # Celler hvor enten vIOy eller vIOm i %cal_deep% er større end 100 gange den anden,
  # sættes elasticiteten til 0
  # (sikrer robusthed for solver)
  eIO.l[d,s]$(vIOy.l[d,s,'%cal_deep%'] > 100 * vIOm.l[d,s,'%cal_deep%']) = 0;
  eIO.l[d,s]$(vIOm.l[d,s,'%cal_deep%'] > 100 * vIOy.l[d,s,'%cal_deep%']) = 0;

  # Start-værdier for initialt laggede værdier
  rpIOm2pIOy.l[dux,s,t]$(d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0 and pIOy.l[dux,s,t] <> 0) = pIOm.l[dux,s,t]/pIOy.l[dux,s,t];
$ENDIF

# ======================================================================================================================
# Static calibration
# ======================================================================================================================
$IF %stage% == "static_calibration":
  $GROUP G_IO_static_calibration_base
    G_IO_endo

    -qIO[dux_,s_,t], uIO0[dux,s_,t]$(d1IO[dux,s_,t]), rqIOy2qYoff[d_,t]$(r_[d_] or c_[d_] or i_[d_] or x_[d_])
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
  ;

  $BLOCK B_IO_static_calibration   
    E_fuIO[cgi,t]$(tx0[t] and sum(s, d1IO[cgi,s,t])).. sum(s, uIO0[cgi,s,t]) =E= 1;
    E_fuIO_r[r,t]$(tx0[t] and sum(s$sMat[s], d1IO[r,s,t])).. sum(s$sMat[s], uIO0[r,s,t]) =E= 1;
    E_fuIOe[r,t]$(tx0[t] and sum(s$sEne[s], d1IO[r,s,t])).. sum(s$sEne[s], uIO0[r,s,t]) =E= 1;
    E_fuIOXy[x,t]$(tx0[t] and not xTur[x]).. sum(s$(d1IOy[x,s,t]), uIOXy0[x,s,t]) =E= 1;
    E_fuIOXm[x,t]$(tx0[t] and d1Xm[x,t]).. sum(s$(d1IOm[x,s,t]), uIOXm0[x,s,t]) =E= 1;
    E_uIOm0_NoM[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and not d1IOm[dux,s,t]).. uIOm0[dux,s,t] =E= 0;
    E_uIOm0_NoY[dux,s,t]$(tx0[t] and d1IOm[dux,s,t] and not d1IOy[dux,s,t]).. uIOm0[dux,s,t] =E= 1;
    E_rpIOm2pIOy_static[dux,s,t]$(tx0[t] and d1IOy[dux,s,t] and d1IOm[dux,s,t] and eIO.l[dux,s] > 0)..
      rpIOm2pIOy[dux,s,t] =E= pIOm[dux,s,t] / pIOy[dux,s,t]
                            - dpM2pYTraeghed[dux,s,t]
                            + dpM2pYTraeghed[dux,s,t]*fv / (1+rVirkDisk[spTot,t]);
  $ENDBLOCK
  MODEL M_IO_static_calibration /
    M_IO
    B_IO_static_calibration
    -E_rpIOm2pIOy_dux_s -E_rpIOm2pIOy_tEnd # E_rpIOm2pIOy_static
  /;
  model M_static_calibration / M_IO_static_calibration /;
  $GROUP+ G_static_calibration G_IO_static_calibration;

  $GROUP+ G_static_calibration_newdata G_IO_static_calibration_base$(tx0[t]);
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
  model M_deep_dynamic_calibration / M_IO_deep /;
  $GROUP+ G_deep_dynamic_calibration G_IO_deep;
$ENDIF

# ======================================================================================================================
# Dynamic calibration for new data years
# ======================================================================================================================
$IF %stage% == "dynamic_calibration_newdata":
  uIOm0.l[dux,s,t]$(tx1[t] and d1IOm[dux,s,t] and d1IOy[dux,s,t] and not sameas['iL',dux])
    = min(0.999, max(0.001, uIOm0.l[dux,s,t1] * uIOm0_baseline[dux,s,t] / uIOm0_baseline[dux,s,t1]));

  # Vi benytter IO-beregnet lagget pris for lagerinvesteringer til første fremskrivningsår for aggregerede investeringer
  pI_iL_lag.l[t2] = sum(s, uIO0.l['iL',s,t1] * uIOm0.l['iL',s,t1] * pIOm.l['iL',s,t1]
                         + uIO0.l['iL',s,t1] * (1-uIOm0.l['iL',s,t1]) * pIOy.l['iL',s,t1])/fp;
  # j-led for t1 nulstilles for at være konsistent med data
  jpI_iL_lag.l[t1] = 0;

  $GROUP G_IO_dynamic_calibration
    G_IO_endo
    -rpIOm2pIOy[dux,s,t1], jpIOm2pIOy[dux,s,t1]
    -pI_iL_lag[t2], jpI_iL_lag[t2]
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
  model M_dynamic_calibration_newdata / M_IO_dynamic_calibration /;
  $GROUP+ G_dynamic_calibration_newdata G_IO_dynamic_calibration;
$ENDIF
