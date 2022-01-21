# Overblik over Shocks_Partielle:

I denne mappe laves analysepapirerne "Marginal propensity to consume" og "Analyse af stød til pensionsindbetalinger":

Analyse af stød til pensionsindbetalingerne.lyx
Marginal propensity to consume.lyx
(Disse dokumenter er master-filer, som samler afsnit fra undermapper i Shocks-mappen. De kompileres til pdf.)  

Har man kalibreret en ny model eller ændret stødfilerne, så skal graferne laves på ny:
  1) Først skal alle stødbankerne laves. 
     Kør run.cmd-filen fra kommando-prompten: Den eksekverer pShocks_MPC.gms og pShocks_Pension.gms. (Kræver GAMS, Python mv. installeret)
    2) Så skal alle graferne laves.
      2a) Graferne til pensionspapiret skal laves i Gekko.
         Kør Grafer_Pension.gcm fra Gekko for at lave pensionsgraferne
         (Gekko åbnes, vælger korrekt mappe som working folder under File, og filen køres med en Run-kommando)
         (Graffiler lægges automatisk i relevante undermapper til \Shocks\ og lyx-filer henter dem automatisk ind)
      2b) Graferne til MPC-papiret skal laves i Python.
