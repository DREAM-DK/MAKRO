# Settings
OPTION
  SYSOUT=OFF
  SOLPRINT=OFF
  LIMROW=0
  LIMCOL=0
  DECIMALS=6
  PROFILE = 1
  PROFILETOL = 0.05
;


# Lav funktion til at sætte lower bounds for variable 
$FUNCTION zero_bound({group}):
  $LOOP {group}:
    {name}.lo{sets}$({conditions} and {name}.up{sets} <> {name}.lo{sets}) = 0;
  $ENDLOOP
$ENDFUNCTION


# ======================================================================================================================
# MINI REFORM MODEL 
# ======================================================================================================================

# Definer sets 
Sets
j  "Input" /
s1  "Sektor 1"
s2  "Sektor 2"
s3  "Sektor 3"
s4  "Sektor 4"
s5  "Sektor 5" 
/
 
;

alias(j, i);
 
# Definer gruppe med endogene variable 
$GROUP G_Endo
    L[j]    "Input af arbejdskraft i sektor j"
    Y[j]    "produktion i sektor j"
    pY[j]   "pris på output fra sektor j"
    pM[j]   "pris på materialeinput til sektor j"
    M[j]    "materialeinput i sektor j"
    x[i,j]  "materialeinput fra sektor i til sektor j"
    C[j]    "Efterspørgsel efter sektor j gode"
    YD      "Disponibel indkomst"
    w       "Løn"
  ;

$GROUP G_Exo
	mu_YL[j]   "Andelsparameter"
	mu_YM[j]   "Andelsparameter"
	mu_x[i,j]  "Andelsparameter"
	fgamma[j]  "Andelsparameter"

	fprod[j] "Produktivitet i sektor j"
	eY[j]    "Substitutionselasticitet mellem M og L"
	eC[j]    "Substitutionselasticitet for forskellige goder"
	eM[j]    "Substitutionselasticitet for materialeinput"
  pC       "Forbrugerprisindeks"
	N        "Antal personer"
;


# ======================================================================================================================
# MODEL LIGNINGER 
# ======================================================================================================================
$BLOCK Mini_Reform 

    # Virksomhedsefterspørgsel 
    E_L[j]..     fprod[j] * L[j]  =E=   mu_YL[j] * (w / (fprod[j] * pY[j]))**(-eY[j]) * Y[j]  ;
    E_M[j]..                M[j]  =E=   mu_YM[j] * (pM[j] / pY[j])**(-eY[j]) * Y[j]  ;

    # materiale aggregat
    E_x[i,j]..              x[i,j]  =E=   mu_x[i,j] * (pY[i] / pM[j])**(-eM[j]) * M[j]  ;

    E_pM[j]..               pM[j] * M[j] =E= sum(i,x[i,j] * pY[i]) ; 

    # Nul Profit 
    E_pY[j]..     pY[j] * Y[j]     =E= pM[j] * M[j] + w * L[j] ; 

    # Efterspørgsel 
    E_C[j]..     C[j] =E= fgamma[j] * (pY[j] / pC)**(-eC[j]) * YD / pC  ;
    E_w..        YD   =E= sum(j, pY[j] * C[j]) ;  

    # Indkomst 
    E_YD..       YD    =E= w * N;  

    # Ligevægt
    E_Y[j]..     Y[j]  =E= sum(i, x[i,j]) + C[j] ; 

$ENDBLOCK

# ======================================================================================================================
# DATA OG INITIAL VÆRDIER 
# ======================================================================================================================
# Sæt først initial værdier for endogene variable (1 i udgangspunktet).
$LOOP ALL:
{name}.l{sets}${conditions} = 1;
$EndLoop

# Eksogene variable / parametre som ikke kalibreres 
	fprod.l[j]  = 1;
	eY.l[j]     = 0.7;
	eC.l[j]     = 0.5;
	eM.l[j]     = 0.5; 
	pC.l        = 1;


# Data 
# Hent data fra IO tabel 
$IMPORT IOdata4_2a.gms

# Sæt x[i,j] lig flows fra IO tabel. 
$FOR1 {I} in ['s1', 's2', 's3', 's4', 's5']:
	$FOR2 {X} in ['s1', 's2', 's3', 's4', 's5']:
		x.l['{X}','{I}']  = IO['{X}','{I}'] ; 
	$ENDFOR2
$ENDFOR1
 
# Sæt privat forbrug og lønsum til IO data. 
$FOR1 {X} in ['s1', 's2', 's3', 's4', 's5']:
		C.l['{X}']  = IO['{X}','PF'] ; 
		L.l['{X}']  = IO['lon','{X}'] ; # Lønnen er 1 i grundforløb, så total løn udbetaling er blot lig arbejdskraft. 
$ENDFOR1

# Udbud af arbejdskraft N skal være lig aggregeret input af arbejdskraft fra IO 
N.l = sum(j,L.l[j]) ;

# intial værdier for bestemte variable  
w.l = 1; 
YD.l  = w.l * N.l;  


# ======================================================================================================================
# Kalibrering 
# ======================================================================================================================

# Variable der er endogene under kalibreringen. 
$GROUP G_Kalib
G_Endo 
mu_YL[j], -L[j]$(not j.last) # E_gamma
mu_YM[j]  # E_mu
mu_x[i,j], -x[i,j] 
fgamma[j], -C[j]
;


# Kalibreringsligninger 
$BLOCK Mini_Reform_kalib
       E_mu[j]..        mu_YL[j] + mu_YM[j] =E= 1; 
       E_gamma..        sum(j,fgamma[j]) =E= 1; 
$ENDBLOCK 

$MODEL MR_Model_kalib 
Mini_Reform
Mini_Reform_kalib 
;

# Løs kalibreringsmodellen 
$FIX All; $UNFIX G_Kalib;
@zero_bound(G_Kalib)
solve MR_Model_kalib using CNS;

# Gem løsning 
# execute_unloaddi 'Output\kalib';  
 

# ======================================================================================================================
# Løs Model 
# ======================================================================================================================

# Løs nu faktisk model  
$MODEL MR_Model 
Mini_Reform  
;

$FIX All; $UNFIX G_Endo;
@zero_bound(G_Endo)
solve MR_Model using CNS;

$DISPLAY G_Endo ;

# Gem løsning 
 execute_unloaddi 'Output\model_Loesning';  


# ======================================================================================================================
# Stød
# ======================================================================================================================

# Stød 1
# 10 pct. stigning i sektor 1 og 2's produktivitet. 

#  fprod.l['s1']= fprod.l['s1'] * 1.1 ; 
#  fprod.l['s2']= fprod.l['s2'] * 1.1 ; 

#  $FIX All; $UNFIX G_Endo;
#  @zero_bound(G_Endo)
#  solve MR_Model using CNS;

#  execute_unloaddi 'Output\stod1';


# ======================================================================================================================
# Stød 2
# Forbrugselasticiteten er nu 2. Lad nu igen produktiviteten i sektor 1 og 2 stige med 10 pct. 

# Rekalibrer først.
#  eC.l[j]     = 2;

#  $FIX All; $UNFIX G_Kalib;
#  @zero_bound(G_Kalib)
#  solve MR_Model_kalib using CNS;

#  # Stød til modellen 
#  fprod.l['s1']= fprod.l['s1'] * 1.1 ; 
#  fprod.l['s2']= fprod.l['s2'] * 1.1 ; 

#  $FIX All; $UNFIX G_Endo;
#  @zero_bound(G_Endo)
#  solve MR_Model using CNS;

#  execute_unloaddi 'stod2';


# ======================================================================================================================
# Stød 3 
# Produktiviteten i sektor 2 falder med 10 pct. Hvor meget skal produktiviteten i sektor 1 stige for at generere en lønstigning på 3 pct.? 
 
#  fprod.l['s2']= fprod.l['s2'] * 0.9 ; 

#  $BLOCK Stod_ligning  
#         E_w_stod..        w =E= 1.03 * w.l ;  
#  $ENDBLOCK 

#  $MODEL MR_Model_stod  
#  Mini_Reform  
#  Stod_ligning
#  ;


#  $FIX All; $UNFIX G_Endo, fprod$(j.first) ;
#  @zero_bound(G_Endo)
#  solve MR_Model_stod using CNS;

#  execute_unloaddi 'Output\stod3';