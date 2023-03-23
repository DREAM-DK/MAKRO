# ----------------------------------------------------------------------------------------------------------------------
# Finansielle beholdninger
# ----------------------------------------------------------------------------------------------------------------------
SETS
  portf_akt "Typer af nettoaktiver ekskl. udstedte obligationer" /
    Obl "Netto beholdning af obligationer ekskl. (udstedte) realkreditobligationer."
    IndlAktier "Brutto beholdning af danske aktier."
    UdlAktier "Brutto beholdning af udenlandske aktier (passiv for udlandet)."
    Pens "Netto pensionsformue (passiv for pensionssektor)."
    Bank "Netto beholdning af øvrige fordringer (Primært bank-indeståender. Hos husholdningerne er ikke-realkredit gæld trukket ud)."
    Guld "Beholdning af monetært guld og særlige trækningsrettigheder."
  /

  portf_pas "Typer af passiver." /
    RealKred "Netto beholdning af (udstedte) realkreditobligationer."
    BankGaeld "Anden (ikke-realkredit) gæld (kun opgjort for husholdningerne)"
  /

  portf_pens "Typer af pensioner" /
    PensX "Rate- og livrentepensioner samt ATP - beskattet på udbetalingstidspunktet"
    Kap "Kapitalpensioner beskattet på udbetalingstidspunkt med særlig sats"
    Alder "Aldersopsparing beskattet ved indbetalingstidspunktet"
  /

  portf_ "Typer af aktiver og passiver." /
    NetFin "Nettoformue ekskl. udstedte aktier"
    set.portf_akt
    set.portf_pas
    set.portf_pens
  /

  portf[portf_] "Typer af aktiver og passiver." /
    set.portf_akt
    set.portf_pas
  /

  akt[portf_] "Typer af nettoaktiver ekskl. udstedte obligationer" / set.portf_akt /

  fin_akt[portf_] /
    Obl "Netto beholdning af obligationer ekskl. (udstedte) realkreditobligationer."
    IndlAktier "Brutto beholdning af danske aktier."
    UdlAktier "Brutto beholdning af udenlandske aktier (passiv for udlandet)."
    Bank "Netto beholdning af øvrige fordringer (Primært bank-indeståender. Hos husholdningerne er ikke-realkredit gæld trukket ud)."
  /

  pas[portf_] "Typer af passiver." / set.portf_pas /

  pens_[portf_] "Typer af pensioner inklusiv total" /
    Pens "Total over alle pensionstyper"
    set.portf_pens
  /

  Pens[portf_] "Typer af pensioner" /
    set.portf_pens
  /

  pensTot[portf_] "Subset af portf_ bestående af Pens" / Pens /
  BankGaeld[portf_] "Subset af portf_ bestående af BankGaeld" / BankGaeld /
  Guld[portf_] "Subset af portf_ bestående af Guld" / Guld /
  RealKred[portf_] "Subset af portf_ bestående af Guld" / RealKred /
  NetFin[portf_] " Subset af portf_ bestående af NetFin" / NetFin /
  Bank[portf_] "Subset af portf_ bestående af Bank" / Bank /
  IndlAktier[portf_] "Subset af portf_ bestående af IndlAktier" / IndlAktier /
  UdlAktier[portf_] "Subset af portf_ bestående af UdlAktier" / UdlAktier /
  Obl[portf_] "Subset af portf_ bestående af Obl" / Obl /
;

# Dummies for portfolios
SETS
  d1vHh[portf_,t] "Hh portefølje dummy" //
  d1vVirk[portf_, t] "vVirk portefølje dummy" //
;
