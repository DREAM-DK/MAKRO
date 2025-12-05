# ----------------------------------------------------------------------------------------------------------------------
# Finansielle beholdninger
# ----------------------------------------------------------------------------------------------------------------------
SETS

  portefolje_elementer "Typer af portefølje-elementer" /
    Obl "Obligationer ekskl. realkreditobligationer."
    RealKred "Realkreditobligationer."
    IndlAktier "Danske aktier."
    UdlAktier "Udenlandske aktier."
    pensTot "Pensionsformue."
    Bank "Øvrige fordringer (Primært bank-indeståender/-gæld)."
    Guld "Monetært guld og særlige trækningsrettigheder."
  /

  portf_ "Typer af aktiver og passiver." /
    Tot "Total ekskl. udstedte aktier"
    set.portefolje_elementer
  /

  portf[portf_] "Typer af aktiver og passiver." /
    set.portefolje_elementer
  /

  fin_akt[portf_] /
    Obl "Obligationer ekskl. realkreditobligationer."
    RealKred "Realkreditobligationer."
    IndlAktier "Danske aktier."
    UdlAktier "Udenlandske aktier."
    Bank "Øvrige fordringer (Primært bank-indeståender/-gæld)."
  /

  portf_pens "Typer af pensioner" /
    PensX "Rate- og livrentepensioner samt ATP - beskattet på udbetalingstidspunktet"
    Kap "Kapitalpensioner beskattet på udbetalingstidspunkt med særlig sats"
    Alder "Aldersopsparing beskattet ved indbetalingstidspunktet"
  /

  pens_ "Typer af pensioner inklusiv total" /
    pensTot "Total over alle pensionstyper"
    set.portf_pens
  /

  pens[pens_] "Typer af pensioner" /
    set.portf_pens
  /

  pensTot[portf_] "Subset af portf_ bestående af PensTot" / pensTot /
  Guld[portf_] "Subset af portf_ bestående af Guld" / Guld /
  RealKred[portf_] "Subset af portf_ bestående af Guld" / RealKred /
  portfTot[portf_] " Subset af portf_ bestående af Tot" / Tot /
  Bank[portf_] "Subset af portf_ bestående af Bank" / Bank /
  IndlAktier[portf_] "Subset af portf_ bestående af IndlAktier" / IndlAktier /
  UdlAktier[portf_] "Subset af portf_ bestående af UdlAktier" / UdlAktier /
  Obl[portf_] "Subset af portf_ bestående af Obl" / Obl /

  PensX[pens_] "Subset af pens_ bestående af PensX" / PensX /
  Alder[pens_] "Subset af pens_ bestående af Alder" / Alder /
  Kap[pens_] "Subset af pens_ bestående af Kap" / Kap /
;

# Dummies for portfolios
SETS
  d1vHhAkt[portf_,t] "vHhAkt portefølje dummy" //
  d1vHhPas[portf_,t] "vHhPas portefølje dummy" //
  d1vHhPens[pens_,t] "vHhPens portefølje dummy" //
  d1vPensionAkt[portf_,t] "vPensionAkt portefølje dummy" //
  d1vVirkAkt[portf_,t] "vVirkAkt portefølje dummy" //
  d1vVirkPas[portf_,t] "vVirkPas portefølje dummy" //
  d1vOffAkt[portf_,t] "vOffAkt portefølje dummy" //
  d1vOffPas[portf_,t] "vOffPas portefølje dummy" //
  d1vUdlAkt[portf_,t] "vUdlAkt portefølje dummy" //
  d1vUdlPas[portf_,t] "vUdlPas portefølje dummy" //
;

Set ADAM_pension_LIST "ADAM-variable overført direkte i samme enhed som i ADAM ikke vækst- og inflationskorrigeret" /
 wpcr_bf
 wpir_bf
 tpcr_bf
 tpir_bf
 typcr_bf
 typir_bf
 wpco1_bf
 wpio1_bf
 tpco1_bf
 tpio1_bf
 typco1_bf
 typio1_bf
 wpco2_bf
 wpio2_bf
 tpco2_bf
 tpio2_bf
 typco2_bf
 typio2_bf
 wpcr_atp
 tpcr_atp
 typcr_atp
 wpco1_ld
 typco1_ld
 wpco2_ld
 tpco2_ld
 typco2_ld
/;
