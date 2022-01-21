# Overblik over Shocks_Main:

I denne mappe laves analysepapiret "Grundlæggende stødanalyser i MAKRO", 

## GRUNDLÆGGENDE STØDANALYSER I MAKRO (MAIN):

  Grundlæggende stødanalyser i MAKRO.lyx
  (Dette dokument er en master-fil, som samler afsnit fra undermapper i Shocks-mappen. Det kompileres til pdf.) 

  Har man kalibreret en ny model eller ændret stødfilerne, så skal graferne laves på ny:
    1) Først skal alle stødbankerne laves. 
       Kør run.cmd-filen fra kommando-prompten: Den eksekverer pShocks_Main.gms og VARshocks.gms. (Kræver GAMS, Python mv. installeret)
    2) Så skal alle graferne laves.
       Kør Grafer_Main.gcm-filen fra Gekko 
       (Gekko åbnes, vælger korrekt mappe som working folder under File, og filen køres med en Run-kommando)
       (Graffiler lægges automatisk i relevante undermapper til \Shocks\ og lyx-filer henter dem automatisk ind)
