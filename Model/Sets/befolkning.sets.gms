# ----------------------------------------------------------------------------------------------------------------------
# Befolkningsregnskab
# ----------------------------------------------------------------------------------------------------------------------
# Vi anvender implicit set definition
# GAMS Dokumentation: https://www.gams.com/latest/docs/UG_SetDefinition.html#UG_SetDefinition_ImplicitSetDefinition
$onMulti

# ----------------------------------------------------------------------------------------------------------------------
# Transfers
# ----------------------------------------------------------------------------------------------------------------------
set activ "Arbejdsmarkedsstatus (FM definitioner)" /
  besk                    "Employed n.e.c."                                           # Beskæftigede uden nærmere angivelse
  beskuddsu               "Employed students with student aid"                        # Beskæftigede uddannelsessøgende med SU
  beskuddxsu              "Employed students without student aid"                     # Beskæftigede uddannelsessøgende uden SU
  besksyge                "Employed receipients of sickness benefits"                 # Beskæftigede modtagere af sygedagpenge
  beskbarsel              "Beskæftiget på barsel"
  beskfortid              "Employed early pensioners, n.e.c."                         # Beskæftigede førtidspensionister u.n.a.
  beskeft                 "Employed voluntary early retirees"                         # Beskæftigede efterlønsmodtagere
  beskpens                "Employed public pensioners"                                # Beskæftigede folkepensionister
  sbeskrest               "Employed in service jobs and adult vocational traineeship" # Beskæftigede i servicejobs og voksenlærlinge
  sbeskflex               "Employed in flex jobs"                                     # Beskæftigede i fleksjob
  sbeskskaane             "Employed early pensioners with reduced strain jobs"        # Beskæftigede førtidspen. i skånejob
  sbeskreval              "Employed rehabilitation participants"                      # Beskæftigede revalidenter (Anvendes ikke)
  sbeskjobtdag            "Dagpengemodtagere i støttet beskæftigelse"
  sbeskjobtaktj           "Jobparate kontanthjælpsmodtagere i støttet beskæftigelse"
  sbeskjobtaktij          "Ikke-jobparate kontanthjælpsmodtagere i støttet beskæftigelse"
  dleddag                 "Partly unemployed, insured"                                # Delvist ledige, forsikrede
  dledkont                "Partly unemployed, not insured"                            # Delvist ledige, ikke-forsikrede
  leddag                  "Unemployed, insured"                                       # Ledige, forsikrede
  ledkont                 "Unemployed, not insured"                                   # Ledige, ikke-forsikrede
  uddsu                   "Students with student aid"                                 # Uddannelsessøgende med SU
  uddxsu                  "Students without student aid"                              # Uddannelsessøgende uden SU
  orlov                   "Labourmarket sabbatical absentees"                         # Arbejdsmarkedsorlov
  barsel                  "Maternity (parenthood) absentees"                          # Barselsorlov
  syge                    "Sickness benefit receipients"                              # Modtagere af sygedagpenge
  aktdag                  "In labourmarket activation, insured"                       # Aktiverede, forsikrede
  reval                   "Rehabilitation participants"                               # Revalidering
  ledigyd                 "Unemployment allowance receipients"                        # Ledighedsydelse
  konthj                  "Cash benefit receipients"                                  # Kontanthjælp
  fortid                  "Early pensioners"                                          # Førtidspensionister
  overg                   "Transitory voluntary early retirees"                       # Overgangsydelse
  fleksyd                 "Flexible early retirees"                                   # Fleksydelse
  efterl                  "Voluntary early retirees"                                  # Efterløn
  # OBS: nSoc[pension] er ekskl. de over 100-årige: BFR[pension] = nSoc[pension] + nPop_Over100
  pension                 "Public pensioners"                                         # Folkepensionister
  tjmand                  "Civil servant pensioners"                                  # Tjenestemandspensionister
  jobafkl                                                                             # Jobafklaringsforløb
  ovrige                  "Others outside the labour force"                           # Øvrige udenfor arbejdsstyrken
  aktkontj                "FM special: Jobparate aktiverede kontanthjælpsmodtagere"
  aktkontij               "FM special: Ikke-jobparate aktiverede kontanthjælpsmodtagere"
  boern                   "FM special: Børn (alle 0-14-årige)"
  selvpens                "FM special: Selvpensionister"
  udvforlob               "FM special: Udviklings/ressourceforlob"
  intro                   "FM special: Introductionary benefit receipients"                       # Intregrationsydelse
  ledintro                "FM special: integrationsydelse - aktive (nettoledige)"
  aktintroj               "FM special: Jobparate aktiverede integratinosydelsesmodtagere"
  aktintroij              "FM special: Ikke-jobparate aktiverede integratinosydelsesmodtagere"
  tidlpens                "Beta: Tidlig tilbagetrækning fra 2020"
  besktidlpens            "Beta: Beskæftigede, Tidlig tilbagetrækning fra 2020"
  seniorpens              ""
  beskseniorpens          ""
/;

set soc "Arbejdsmarkedsstatus (FM definitioner) ekskl. totaler" /
  set.activ
/;

set boern[soc] / boern /;

set socFraMAKROBK[soc] "Variable med data fra MAKROBK" /
  besksyge # qms
  beskbarsel# qmb
  beskfortid # qpfo
  beskpens # qpfp
  besktidlpens # qptp
  beskseniorpens # qpsp
  sbeskrest # qltr
  sbeskflex # qltf
  sbeskskaane # qlts
  sbeskreval # 0 
  sbeskjobtdag # qltjd
  sbeskjobtaktj # qltjkz = buakbr * qltjk
  sbeskjobtaktij # qltjkw = (1-buakbr) * qltjk
  dleddag # 0
  dledkont # 0
  leddag # uld
  ledkont # ulk - ulki
  orlov # umo
  barsel # umbxa
  syge # umsxa
  aktdag # uad
  reval # ury
  ledigyd # uly
  konthj # ukr
  fortid # upfo
  overg # upov
  fleksyd # upfy
  pension # upfp
  tjmand # upt
  aktkontj # for beregning jf. labor_market.gcm i data/makrobk-mappe
  aktkontij # for beregning jf. labor_market.gcm i data/makrobk-mappe
  intro # uki
  ledintro # ulki
  aktintroj # buakbi * Uaki
  aktintroij # (1-buakbi) * Uaki
  tidlpens # uptp
  seniorpens # upsp
/;
set socFraFM[soc] "Variable med data fra MAKROBK" /
  beskuddsu # qusu - beregnes af FM
  beskuddxsu # qxsu - beregnes af FM
  beskeft # qpef - beregnes af FM
  uddsu # uusu - beregnes af FM
  uddxsu # uuxsu - beregnes af FM
  efterl # upef - qpef beregnes af FM
  jobafkl # xxjob - beregnes af FM
  boern # ub - beregnes af FM (ikke lig med Ub fra ADAMs databank!)
  selvpens # upsvp - beregnes af FM
  udvforlob # umr - xxjob - beregnes af FM

  # Residual-beregnes og læses ikke ind
  # besk # quna = q - (graens + sortarb + qusu + qxsu + qpfo + qpfp + qpef + qltr + qltf + qlts + qltjd + qltjkz + qltjkw + qptp + qpsp) - residual ud fra samlet beskæftigelse, grænsearbejdere inkl. sort arbejde og ikke-ordinært beskæftigede
  # ovrige # urx = u - (q - (graens + sortarb)) - ul - (ub + uusu + uuxsu + umo + qmb + umbxa + qms + umsxa + ury + uly + umr + xxjob + ukr + uki + uad + uakkz + uakkw + uakiz + uakiw + upov + upfy + upef + upfo + upfp + upt + uptp + upsp) - residual ud fra befolkningen, grænsearbejdere inkl. sort arbejde og alle andre grupper i BFR
/;

set BruttoLedig[soc] "Bruttoledighed" /
  sbeskjobtdag            "Dagpengemodtagere i støttet beskæftigelse"
  sbeskjobtaktj           "Jobparate kontanthjælpsmodtagere i støttet beskæftigelse"
  leddag                  "Ledige, forsikrede"
  ledkont                 "Ledige, ikke-forsikrede"
  aktdag                  "Aktiverede, forsikrede"
  aktkontj                "FM special: Jobparate aktiverede kontanthjælpsmodtagere"
  ledintro                "FM special: integrationsydelse - aktive (nettoledige)"
  aktintroj               "FM special: Jobparate aktiverede integrationsydelsesmodtagere"
/;

set NettoLedig[soc] "Nettoledighed" /
  leddag                  "Ledige, forsikrede"
  ledkont                 "Ledige, ikke-forsikrede"
  ledintro                "FM special: integrationsydelse - aktive (nettoledige)"
/;

set besktot[soc] "Beskæftigelse" /
  besk                    "Beskæftigede uden nærmere angivelse"
  beskuddsu               "Beskæftigede uddannelsessøgende med SU"
  beskuddxsu              "Beskæftigede uddannelsessøgende uden SU"
  # besksyge                "Beskæftigede modtagere af sygedagpenge"
  # beskbarsel              "Beskæftiget på barsel"
  beskfortid              "Beskæftigede førtidspensionister u.n.a."
  beskeft                 "Beskæftigede efterlønsmodtagere"
  beskpens                "Beskæftigede folkepensionister"
  sbeskrest               "Beskæftigede i servicejobs og voksenlærlinge"
  sbeskflex               "Beskæftigede i fleksjob"
  sbeskskaane             "Beskæftigede førtidspen. i skånejob"
  sbeskreval              "Beskæftigede revalidenter (Anvendes ikke)"
  sbeskjobtdag            "Dagpengemodtagere i støttet beskæftigelse"
  sbeskjobtaktj           "Jobparate kontanthjælpsmodtagere i støttet beskæftigelse"
  sbeskjobtaktij          "Ikke-jobparate kontanthjælpsmodtagere i støttet beskæftigelse"
  dleddag                 "Delvist ledige, forsikrede"
  dledkont                "Delvist ledige, ikke-forsikrede"
  besktidlpens            "Beta: Beskæftigede, Tidlig tilbagetrækning fra 2020"
  beskseniorpens          ""
/;

set BruttoArbsty[soc] "Arbejdsstyrke" /
  besk                    "Beskæftigede uden nærmere angivelse"
  beskuddsu               "Beskæftigede uddannelsessøgende med SU"
  beskuddxsu              "Beskæftigede uddannelsessøgende uden SU"
  # besksyge                "Beskæftigede modtagere af sygedagpenge"
  # beskbarsel              "Beskæftiget på barsel"
  beskfortid              "Beskæftigede førtidspensionister u.n.a."
  beskeft                 "Beskæftigede efterlønsmodtagere"
  beskpens                "Beskæftigede folkepensionister"
  sbeskrest               "Beskæftigede i servicejobs og voksenlærlinge"
  sbeskflex               "Beskæftigede i fleksjob"
  sbeskskaane             "Beskæftigede førtidspen. i skånejob"
  sbeskreval              "Beskæftigede revalidenter (Anvendes ikke)"
  sbeskjobtdag            "Dagpengemodtagere i støttet beskæftigelse"
  sbeskjobtaktj           "Jobparate kontanthjælpsmodtagere i støttet beskæftigelse"
  sbeskjobtaktij          "Ikke-jobparate kontanthjælpsmodtagere i støttet beskæftigelse"
  dleddag                 "Delvist ledige, forsikrede"
  dledkont                "Delvist ledige, ikke-forsikrede"
  leddag                  "Ledige, forsikrede"
  ledkont                 "Ledige, ikke-forsikrede"
  aktdag                  "Aktiverede, forsikrede"
  aktkontj                "FM special: Jobparate aktiverede kontanthjælpsmodtagere"
  ledintro                "FM special: integrationsydelse - aktive (nettoledige)"
  aktintroj               "FM special: Jobparate aktiverede integrationsydelsesmodtagere"
  besktidlpens            "Beta: Beskæftigede, Tidlig tilbagetrækning fra 2020"
  beskseniorpens          ""
/;

set NettoArbsty[soc] "Nettoarbejdsstyrke" /
  besk                    "Beskæftigede uden nærmere angivelse"
  beskuddsu               "Beskæftigede uddannelsessøgende med SU"
  beskuddxsu              "Beskæftigede uddannelsessøgende uden SU"
  # besksyge                "Beskæftigede modtagere af sygedagpenge"
  # beskbarsel              "Beskæftiget på barsel"
  beskfortid              "Beskæftigede førtidspensionister u.n.a."
  beskeft                 "Beskæftigede efterlønsmodtagere"
  beskpens                "Beskæftigede folkepensionister"
  sbeskrest               "Beskæftigede i servicejobs og voksenlærlinge"
  sbeskflex               "Beskæftigede i fleksjob"
  sbeskskaane             "Beskæftigede førtidspen. i skånejob"
  sbeskreval              "Beskæftigede revalidenter (Anvendes ikke)"
  sbeskjobtdag            "Dagpengemodtagere i støttet beskæftigelse"
  sbeskjobtaktj           "Jobparate kontanthjælpsmodtagere i støttet beskæftigelse"
  sbeskjobtaktij          "Ikke-jobparate kontanthjælpsmodtagere i støttet beskæftigelse"
  dleddag                 "Delvist ledige, forsikrede"
  dledkont                "Delvist ledige, ikke-forsikrede"
  leddag                  "Ledige, forsikrede"
  ledkont                 "Ledige, ikke-forsikrede"
  ledintro                "FM special: integrationsydelse - aktive (nettoledige)"
  besktidlpens            "Beta: Beskæftigede, Tidlig tilbagetrækning fra 2020"
  beskseniorpens          ""
/;

Set ovf_til_husholdninger "Overførsler til husholdningerne" /
  ledigyd      "Ledighedsydelse"
  sbeskjobtdag "Overførsler til dagpengemodtagere i offentlig løntilskudslignende ordning, uden for nettoarbejdsstyrken"
  aktdag       "Overførsler til AF aktiverede udenfor arbejdsstyrken (dagpenge)"
  aktkont      "Overførsler til aktiverede kontanthjælpsmodtagere"
  reval        "Revalideringsydelse"
  uddsu        "Statens uddannelsesstøtte"
  leddag       "Arbejdsløshedsdagpenge"
  ferie        "Udbetalte feriedagpenge"
  syge         "Overførsler til sygedagpenge"
  barsel       "Overførsler til barselsdagpenge"
  orlov        "Overførsler til arbejdsmarkedsorlov"
  udvforlob    "Samlet ydelse til personer i resourceforløbsordning"
  pension      "Overførsler til folkepension (i Danmark)"
  fortid       "Overførsler til førtidspension (i Danmark)"
  efterl       "Overførsler til efterløn"
  tjmand       "Overførsler til tjenestemandspension"
  tillaeg      "Personlige tillæg"
  tilbtrk      "Pensioner og overførsler til personer på øvrige tilbagetrækningsordninger"
  overg        "Overførsler til overgangsydelse"
  fleksyd      "Overførsel til flexydelse"
  konthj       "Overførsler til kontanthjælpsmodtagere"
  kontflex     "Overførsler til kontanthjælp i øvrigt, skattepligtig del (primært fleksjobtilskud)"
  kontrest     "Overførsler til kontanthjælp i øvrigt, ikke-skattepligtig del (inkl. løntilskud, revalidering mv.)"
  intro        "Modtagere af integrationsydelse, kontanthjælp til flygtninge, introduktionsydelse (passiv periode)"
  boernyd      "Børnefamilieydelse"
  boligyd      "Boligydelse"
  boligst      "Boligstøtte"
  skatpl       "Øvrige indkomstoverførsler, skattepligtige"
  iskatpl      "Øvrige indkomstoverførsler, ikke skattepligtige"
  groen        "Grøn check"
  medie        "Mediecheck"
  lumpsumovf   "Skattefri lump sum overførsel til offentligt forsørgede"
  tidlpens     "Beta: Tidlig tilbagetrækning fra 2020"
  seniorpens   "Seniorpension"
/;

Set ovf_til_udenlandske_husholdninger "Overførsler til udlandet" /
  udlpens   "Folkepension til udland"
  udlfortid "Førtidspension til udland"
  udltidlpens  "Beta: Tidlig tilbagetrækning fra 2020 til udland"
  udlseniorpens "Seniorpension til udlandet"
/;

Set ovf_ "Overførsler inkl. totaler" /
  set.ovf_til_husholdninger
  set.ovf_til_udenlandske_husholdninger
  tot "Samlede overførsler"
  HhTot "Samlede overførsler til husholdninger"
  a18t100 "Overførsler som fordeles på alle personer i alderen 18-100 år"
  a0t17 "Overførsler som fordeles på alle personer i alderen 0-17 år"
/;

Set ovfTot[ovf_] "Subset bestående af tot" / tot /;

Set ovf[ovf_] "Overførsler ekskl. totaler" /
  set.ovf_til_husholdninger
  set.ovf_til_udenlandske_husholdninger
/;

Set ovfHh[ovf] "Overførsler ekskl. totaler" / set.ovf_til_husholdninger /;
Set ovfUdl[ovf] "Overførsler ekskl. totaler" / set.ovf_til_udenlandske_husholdninger /;

Set HhTot[ovf_] "Subset bestående af HhTot" / HhTot /;

Set ureguleret[ovf] "Overførsler som ikke reguleres" /
  groen   "Grøn check"
/;

Set prisreg[ovf] "Prisregulerede overførsler" /
  boernyd "Børnefamilieydelse"
  boligst "Boligstøtte (boligsikring)"
/;

Set intro[ovf] "Integrationsydelse (mindrereguleres)" /
  intro "Modtagere af integrationsydelse, kontanthjælp til flygtninge, introduktionsydelse (passiv periode)"
/;

Set loenreg[ovf] "Lønregulerede overførsler" /
  pension      "Overførsler til folkepension (i Danmark)"
  udlpens      "Folkepension til udland"
  uddsu        "Statens uddannelsesstøtte"
  tjmand       "Overførsler til tjenestemandspension"
  tillaeg      "Personlige tillæg"
  boligyd      "Boligydelse"
/;

Set oblpens[ovf] "Ydelser obligatorisk opsparing" /
  ledigyd      "Ledighedsydelse"
  reval        "Revalideringsydelse"
  aktdag       "Overførsler til AF aktiverede ekskl. arbejdsmarkedsydelse udenfor arbejdsstyrken (dagpenge)"
  aktkont      "Overførsler til aktiverede kontanthjælpsmodtagere"
  leddag       "Arbejdsløshedsdagpenge"
  ferie        "Udbetalte feriedagpenge"
  syge         "Overførsler til sygedagpenge"
  barsel       "Overførsler til barselsdagpenge"
  orlov        "Overførsler til arbejdsmarkedsorlov"
  udvforlob    "Samlet ydelse til personer i resourceforløbsordning"
  fortid       "Overførsler til førtidspension (i Danmark)"
  efterl       "Overførsler til efterløn"
  fleksyd      "Overførsel til flexydelse"
  kontflex     "Overførsler til kontanthjælp i øvrigt, skattepligtig del (primært fleksjobtilskud)"
  konthj       "Overførsler til ledige kontanthjælpsmodtagere"
  tidlpens     "Beta: Tidlig tilbagetrækning fra 2020"
  seniorpens   "Seniorpension"
  udlfortid    "Førtidspension til udland"
  udltidlpens  "Beta: Tidlig tilbagetrækning fra 2020 til udland"
  udlseniorpens "Seniorpension til udlandet"
/;

Set satsreg[ovf] "Satsregulerede overførsler" /
  sbeskjobtdag "Overførsler til dagpengemodtagere i offentlig løntilskudslignende ordning, uden for nettoarbejdsstyrken"
  tilbtrk      "Pensioner og overførsler til personer på øvrige tilbagetrækningsordninger"
  overg        "Overførsler til overgangsydelse"
  kontrest     "Overførsler til kontanthjælp i øvrigt, ikke-skattepligtig del (inkl. løntilskud, revalidering mv.)"
  medie        "Mediecheck"
  lumpsumovf   "Skattefri lump sum overførsel til offentligt forsørgede"
  skatpl       "Øvrige indkomstoverførsler, skattepligtige"
  iskatpl      "Øvrige indkomstoverførsler, ikke skattepligtige"
/;


Set ubeskat[ovf] "Ubeskattede overførsler" /
  boernyd "Børnefamilieydelse"
  boligyd "Boligydelse"
  iskatpl "Øvrige indkomstoverførsler, ikke skattepligtige"
  groen   "Grøn check"
  lumpsumovf "Skattefri lump sum overførsel til offentligt forsørgede"
/;

Set ovf_a18t100[ovf] "Overførsler som fordeles på alle over 18" /
  boligst
  skatpl
  iskatpl
  groen
/;
Set ovf_a0t17[ovf] "Overførsler som fordeles på alle under 18" /
  boernyd
/;
set ovfFraMAKROBK[ovf] "Variable med data fra MAKROBK" /
  ledigyd
  sbeskjobtdag
  aktdag
  reval
  leddag
  orlov
  overg
  fleksyd
  intro
  konthj
  kontrest
  aktkont
  syge
  barsel
  pension
  seniorpens
  tidlpens
  fortid

  ferie # ulf
  uddsu # usu
  efterl # upef
  udlpens # upfpu
  udlseniorpens # upspu
  udltidlpens # uptpu
  udlfortid # upfou
  udvforlob # umr
  kontflex # Qltf2

# ledkontudd #  ulku
# konthj # ulkk + ukr = ulkr + ukr + ulki
# aktkontudd # Uaku
#aktkont # Uakk
# leddagx # Uldd
# ledamydelse # Ulda
# aktdagx # Uadr
# aktamydelse # Uada
/;

Set ADAM_BFR_LIST "ADAM-variable overført direkte i samme enhed som i ADAM ikke vækst- og inflationskorrigeret" /
 umsy
 uaks
 buaks
 uryy
 uakry
 buakry
 ulyy
 uakly
 buakly
 ukiy
 qltjki
 buaki
 uakr
/;