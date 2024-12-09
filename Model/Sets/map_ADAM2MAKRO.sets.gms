# ----------------------------------------------------------------------------------------------------------------------
# Mapping mellem ADAM og Makro
# ----------------------------------------------------------------------------------------------------------------------
SETS
  branche2s[s_,branche] "Mapping fra ADAM brancher til Makro brancher" /
    lan . (a) 
    byg . (b)                                                 
    ene . (ne, ng)                                                 
    udv . (e)                                                 
    bol . (h)                                           
    fre . (nf, nz)
    off . (o)             
    soe . (qs)
    tje . (qf, qz)
    
    tot . (set.branche)
  /

  mapax2s[s_,as]   "Map fra ADAM produktion til Makro brancher" /
    lan . (xa) 
    byg . (xb)                                                 
    ene . (xne, xng)                                                 
    udv . (xe)                                                 
    bol . (xh)                                           
    fre . (xnf, xnz)
    off . (xo)             
    soe . (xqs)
    tje . (xqf, xqz)
    tot . (set.as)
    spTot . (set.axp)
    sByTot . (xqf, xqz, xnf, xnz, xb, xne, xng)
  /

  mapam2s[s_,as]   "Mapping fra sitc grupper til Makro brancher" /
    #lan . () 
    #byg . ()                                                 
    ene . (m3q)                                                 
    udv . (m3k, m3r)                                                 
    #bol . ()                                           
    fre . (m01, m2, m59, m7b, m7y)
    #off . ()             
    #soe . ()
    tje . (ms,mt)
    tot . (set.as)
  /

  mapaxm2s[s_,as]   "Mapping fra ADAM produktion og sitc grupper til Makro brancher" / 
    lan . (xa) 
    byg . (xb)                                                 
    ene . (xne, xng)                                                 
    udv . (xe)                                                 
    bol . (xh)                                           
    fre . (xnf, xnz)
    off . (xo)             
    soe . (xqs)
    tje . (xqf, xqz)

    #lan . () 
    #byg . ()                                                 
    ene . (m3q)                                                 
    udv . (m3k, m3r)                                                 
    #bol . ()                                           
    fre . (m01, m2, m59, m7b, m7y)
    #off . ()             
    #soe . ()
    tje . (ms,mt)

    tot . (set.as)
  /

  mapai2i[i_,ai] "Mapping af investeringstyper fra ADAM til Makro" /
    iM   . (iM)
    iB   . (iB)
    iL . (ikn, iL, it)
    iTot . (iM, it, iB, ikn, iL)
  /

  mapak2k[k_,ak] "Mapping af investeringstyper fra ADAM til Makro" /
    iM   . (knm)
    iB   . (knb)
    iTot . (knm, knb)
  /

  mapacp2c[c_,acp]   "Mapping over forbrugsgrupper" /
    cBil . (cb)
    cEne . (cg,ce)
    cVar . (cf,cv)
    cBol . (ch)
    cTje . (cs)
    cTur . (ct)
    Cx . (cb, cg, ce, cf, cv, cs, ct)
    cTot . (set.acp)
  /

  mapae2x[x_,ae]   "Mapping over eksportgrupper" /
    xVar . (e01, e2, e59, e7y)
    xEne . (e3)
    xSoe . (ess)
    xTje . (esq)
    xTur . (et)
    xTot . (set.ae)
  /
;

Set map_ADAM2ovf[ovf_,ADAM_variables]       "Mapper MAKRO og ADAM overførsler" /
  tot.Ty_o           "Overførsler"
  # Overførsler til uddannelse og aktivering mv.
  ledigyd.Tyuly      "Ledighedsydelse"
  aktarbj.Tyuada     "Overførsler til aktiverede i arbejdsmarkedsydelsesordningen udenfor arbejdsstyrken"
  sbeskjobtdag.Tyuadj "Overførsler til dagpengemodtagere i offentlig løntilskudslignende ordning, uden for nettoarbejdsstyrken"
  aktdag.Tyuadr      "Overførsler til AF aktiverede ekskl. arbejdsmarkedsydelse udenfor arbejdsstyrken (dagpenge)"
  aktkont.Tyuak      "Overførsler til aktiverede kontantshjælpmodtagere"
  reval.Tyury        "Revalideringsydelse"
  uddsu.Tyusu        "Statens uddannelsesstøtte"
  # Overførsler til ledige arbejdsløshedsdagpengemodtagere, inkl. arbejdsmarkedsydelse
  leddag.Tydd        "Arbejdsløshedsdagpenge ekskl. arbejdsmarkedsydelse"
  ledarbj.Tyda       "Arbejdsmarkedsydelse"
  # Overførsler til midlertidigt fraværende fra arbejdsstyrken
  ferie.Tymlf        "Udbetalte feriedagpenge"
  syge.Tyms          "Overførsler til sygedagpenge"
  barsel.Tymb        "Overførsler til barselsdagpenge"
  orlov.Tymo         "Overførsler til arbejdsmarkedsorlov"
  udvforlob.Tymr     "Samlet ydelse til personer i resourceforløbsordning"
  # Pensioner og overførsler til personer på øvrige tilbagetrækningsordninger
  pension.Typfp      "Overførsler til folkepension (i Danmark)"
  udlpens.Typfp_e    "Folkepension til udland"
  fortid.Typfo       "Overførsler til førtidspension (i Danmark)"
  udlfortid.Typfo_e  "Førtidspension til udland"
  efterl.Typef       "Overførsler til efterløn"
  overg.Typov        "Overførsler til overgangsydelse"
  fleksyd.Typfy      "Overførsel til flexydelse"
  tidlpens.Typtp        "Tidlig pension"
  udltidlpens.Typtp_e   "Tidlig pension til udland"
  seniorpens.Typsp   "Seniorpension"
  udlseniorpens.Typsp_e "Seniorpension til udland"
  tjmand.Typt        "Overførsler til tjenestemandspension"
  tillaeg.Typpt      "Personlige tillæg"
  tilbtrk.Typq       "Pensioner og overførsler til personer på øvrige tilbagetrækningsordninger"
  # Øvrige indkomstoverførsler
  ledkont.(Tyrku,Tyrkk)  "Overførsler til ledige kontanthjælpsmodtagere"
  intro.Tyrki        "Modtagere af integrationsydelse, kontanthjælp til flygtninge, introduktionsydelse (passiv periode)"
  kontflex.Tyrkrs    "Overførsler til kontanthjælp i øvrigt, skattepligtig del"
  kontrest.(Tyrkrr,jTyrkr) "Overførsler til kontanthjælp i øvrigt, skattepligtig del"
  boernyd.Tyrbf      "Børnefamilieydelse"
  groen.Tyrgc        "Grøn check"
  medie.Tyrmc           "Mediecheck"
  lumpsumovf.Tyrre      "Skattefri lump sum overførsel til offentligt forsørgede"
  boligst.Tyrhs      "Boligstøtte"
  boligyd.Tyrhy      "Overførsler til boligydelse"
  skatpl.Tyrrs       "Øvrige indkomstoverførsler, skattepligtige"
  iskatpl.Tyrrr      "Øvrige indkomstoverførsler, ikke skattepligtige"
/;
# ADAM okt20:
# Ty_o =
# Tyuly +  Tyuada + Tyuadj + Tyuadr + Tyuak + Tyury + Tyusu 
# + Tydd + Tyda 
# + Tymlf + Tyms + Tymb + Tymo + Tymr
# + Typfp + Typfp_e + Typfo + Typfo_e + Typef + Typov + Typfy + Typtp + Typtp_e
# + Typt + Typpt + Typq 
# + Tyrku + Tyrkk + Tyrki + Tyrkrs + Tyrkrr + jTyrkr + Tyrbf + Tyrgc + Tyrmc + Tyrre + Tyrhs + Tyrhy + Tyrrs + Tyrrr;
