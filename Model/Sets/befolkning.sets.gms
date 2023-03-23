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
  beskuddxsu              "Employed students without student aid"                     # Beskæftigede uddannelsessøgende og børn med SU
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
  pension                 "Public pensioners"                                         # Folkepensionister
  tjmand                  "Civil servant pensioners"                                  # Tjenestemandspensionister
  jobafkl                                                                             # Jobafklaringsforløb
  ovrige                  "Others outside the labour force"                           # Øvrige udenfor arbejdsstyrken
  aktkontudd              "Jobparate (i bruttoledigheden) aktiverede kontanthjælpsmodtagere i uddannelsesordning"
  aktkontj                "FM special: Jobparate aktiverede kontanthjælpsmodtagere"
  aktkontij               "FM special: Ikke-jobparate aktiverede kontanthjælpsmodtagere"
  boern                   "FM special: Børn (alle 0-14-årige)"
  selvpens                "FM special: Selvpensionister"
  udvforlob               "FM special: Udviklings/ressourceforlob"
  ledarbj                 "FM special: Arbejdsmarkedsydelse - passive"
  aktarbj                 "FM special: Arbejdsmarkedsydelse - aktive"
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

set BruttoLedig[soc] "Bruttoledighed" /
  sbeskjobtdag            "Dagpengemodtagere i støttet beskæftigelse"
  sbeskjobtaktj           "Jobparate kontanthjælpsmodtagere i støttet beskæftigelse"
  leddag                  "Ledige, forsikrede"
  ledkont                 "Ledige, ikke-forsikrede"
  aktdag                  "Aktiverede, forsikrede"
  aktkontudd              "Jobparate (i bruttoledigheden) aktiverede kontanthjælpsmodtagere i uddannelsesordning"
  aktkontj                "FM special: Jobparate aktiverede kontanthjælpsmodtagere"
  ledarbj                 "FM special: Arbejdsmarkedsydelse - passive"
  aktarbj                 "FM special: Arbejdsmarkedsydelse - aktive"
  ledintro                "FM special: integrationsydelse - aktive (nettoledige)"
  aktintroj               "FM special: Jobparate aktiverede integrationsydelsesmodtagere"
/;

set NettoLedig[soc] "Nettoledighed" /
  leddag                  "Ledige, forsikrede"
  ledkont                 "Ledige, ikke-forsikrede"
  ledarbj                 "FM special: Arbejdsmarkedsydelse - passive"
  ledintro                "FM special: integrationsydelse - aktive (nettoledige)"
/;

set besktot[soc] "Beskæftigelse" /
  besk                    "Beskæftigede uden nærmere angivelse"
  beskuddsu               "Beskæftigede uddannelsessøgende med SU"
  beskuddxsu              "Beskæftigede uddannelsessøgende og børn med SU"
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
  beskuddxsu              "Beskæftigede uddannelsessøgende og børn med SU"
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
  aktkontudd              "Jobparate (i bruttoledigheden) aktiverede kontanthjælpsmodtagere i uddannelsesordning"
  aktkontj                "FM special: Jobparate aktiverede kontanthjælpsmodtagere"
  ledarbj                 "FM special: Arbejdsmarkedsydelse - passive"
  aktarbj                 "FM special: Arbejdsmarkedsydelse - aktive"
  ledintro                "FM special: integrationsydelse - aktive (nettoledige)"
  aktintroj               "FM special: Jobparate aktiverede integrationsydelsesmodtagere"
  besktidlpens            "Beta: Beskæftigede, Tidlig tilbagetrækning fra 2020"
  beskseniorpens          ""
/;

set NettoArbsty[soc] "Nettoarbejdsstyrke" /
  besk                    "Beskæftigede uden nærmere angivelse"
  beskuddsu               "Beskæftigede uddannelsessøgende med SU"
  beskuddxsu              "Beskæftigede uddannelsessøgende og børn med SU"
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
  ledarbj                 "FM special: Arbejdsmarkedsydelse - passive"
  ledintro                "FM special: integrationsydelse - aktive (nettoledige)"
  besktidlpens            "Beta: Beskæftigede, Tidlig tilbagetrækning fra 2020"
  beskseniorpens          ""
/;

Set ovf_hh "Overførsler til husholdningerne" /
  ledigyd      "Ledighedsydelse"
  aktarbj      "Overførsler til aktiverede i arbejdsmarkedsydelsesordningen udenfor arbejdsstyrken"
  sbeskjobtdag "Overførsler til dagpengemodtagere i offentlig løntilskudslignende ordning, uden for nettoarbejdsstyrken"
  aktdag       "Overførsler til AF aktiverede ekskl. arbejdsmarkedsydelse udenfor arbejdsstyrken (dagpenge)"
  aktkont      "Overførsler til aktiverede kontanthjælpsmodtagere"
  reval        "Revalideringsydelse"
  uddsu        "Statens uddannelsesstøtte"
  leddag       "Arbejdsløshedsdagpenge ekskl. arbejdsmarkedsydelse"
  ledarbj      "Arbejdsmarkedsydelse"
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
  ledkont      "Overførsler til ledige kontanthjælpsmodtagere"
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
#  seniorpens   "Seniorpension"
/;

Set ovf_udl "Overførsler til udlandet" /
  udlpens   "Folkepension til udland"
  udlfortid "Førtidspension til udland"
  udltidlpens  "Beta: Tidlig tilbagetrækning fra 2020 til udland"
#  udlseniorpens "Seniorpension til udlandet"
/;

Set ovf_ "Overførsler inkl. totaler" /
  set.ovf_hh
  set.ovf_udl
  tot
  hh
  a18t100
  a0t17
/;

Set ovftot[ovf_] "Subset bestående af tot" /
  tot
/;

Set ovf[ovf_] "Overførsler ekskl. totaler" /
  set.ovf_hh
  set.ovf_udl
/;

Set ovfhh[ovf] "Overførsler ekskl. totaler" /
  set.ovf_hh
/;

Set hh[ovf_] "Subset bestående af hh" /
  hh
/;

Set satsreg[ovf] "Overførsler ekskl. totaler" /
  ledigyd      "Ledighedsydelse"
  aktarbj      "Overførsler til aktiverede i arbejdsmarkedsydelsesordningen udenfor arbejdsstyrken"
  sbeskjobtdag "Overførsler til dagpengemodtagere i offentlig løntilskudslignende ordning, uden for nettoarbejdsstyrken"
  aktdag       "Overførsler til AF aktiverede ekskl. arbejdsmarkedsydelse udenfor arbejdsstyrken (dagpenge)"
  aktkont      "Overførsler til aktiverede kontantshjælpmodtagere"
  reval        "Revalideringsydelse"
  uddsu        "Statens uddannelsesstøtte"
  leddag       "Arbejdsløshedsdagpenge ekskl. arbejdsmarkedsydelse"
  ledarbj      "Arbejdsmarkedsydelse"
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
  ledkont      "Overførsler til ledige kontanthjælpsmodtagere"
  kontflex     "Overførsler til kontanthjælp i øvrigt, skattepligtig del (primært fleksjobtilskud)"
  kontrest     "Overførsler til kontanthjælp i øvrigt, ikke-skattepligtig del (inkl. løntilskud, revalidering mv.)"
  intro        "Modtagere af integrationsydelse, kontanthjælp til flygtninge, introduktionsydelse (passiv periode)"
  boernyd      "Børnefamilieydelse"
  udlpens      "Folkepension til udland"
  udlfortid    "Førtidspension til udland"
  boligyd      "Boligydelse"
  boligst      "Boligstøtte"
  skatpl       "Øvrige indkomstoverførsler, skattepligtige"
  iskatpl      "Øvrige indkomstoverførsler, ikke skattepligtige"
  tidlpens     "Beta: Tidlig tilbagetrækning fra 2020"
  udltidlpens  "Beta: Tidlig tilbagetrækning fra 2020 til udland"
#  seniorpens   "Seniorpension"
#  udlseniorpens "Seniorpension til udland"
  medie        "Mediecheck"
  lumpsumovf   "Skattefri lump sum overførsel til offentligt forsørgede"

#  groen        "Grøn check" - ikke satsreguleret
/;

Set ubeskat[ovf] "Ubeskattede overførsler" /
  boernyd "Børnefamilieydelse"
  boligyd "Boligydelse"
  boligst "Boligstøtte"
  iskatpl "Øvrige indkomstoverførsler, ikke skattepligtige"
  groen   "Grøn check"
  lumpsumovf   "Skattefri lump sum overførsel til offentligt forsørgede"
/;

Parameter nOvf2Soc[ovf_, soc] "Mapping mellem overførsler og BFR-grupper" /  
  ledigyd   . ledigyd         1 
  aktarbj   . aktarbj         1
  sbeskjobtdag . sbeskjobtdag 1
  aktdag    . aktdag          1 
  aktkont   . aktkontudd      1
  aktkont   . aktkontj        1
  aktkont   . aktkontij       1
  aktkont   . aktintroj       0.5
  aktkont   . aktintroij      0.5
  reval     . reval           1
  uddsu     . uddsu           1
  uddsu     . beskuddsu       1
  leddag    . leddag          1
  ledarbj   . ledarbj         1
  ferie     . leddag          1
  syge      . syge            1
  syge      . besksyge        1
  barsel    . barsel          1
  barsel    . beskbarsel      1
  orlov     . orlov           1
  udvforlob . udvforlob       1
  udvforlob . jobafkl         1
  pension   . pension         1
  pension   . beskpens        1
  pension   . seniorpens      1
  pension   . beskseniorpens  1
#  seniorpens . seniorpens     1
#  seniorpens . beskseniorpens 1
  tidlpens  . tidlpens        1
  tidlpens  . besktidlpens    1
  fortid    . fortid          1
  fortid    . beskfortid      1
  efterl    . efterl          1
  efterl    . beskeft         1
  tjmand    . tjmand          1
  tillaeg   . pension         1
  tillaeg   . beskpens        1
  tillaeg   . tidlpens        1
  tillaeg   . besktidlpens    1
  tillaeg   . seniorpens      1
  tillaeg   . beskseniorpens  1
  tillaeg   . fortid          1
  tillaeg   . beskfortid      1
  tilbtrk   . pension         1
  tilbtrk   . beskpens        1
  tilbtrk   . tidlpens        1
  tilbtrk   . besktidlpens    1
  tilbtrk   . seniorpens      1
  tilbtrk   . beskseniorpens  1
  tilbtrk   . fortid          1
  tilbtrk   . beskfortid      1
  overg     . overg           1
  fleksyd   . fleksyd         1
  ledkont   . ledkont         1
  ledkont   . konthj          1
  ledkont   . ledintro        1
  kontflex  . sbeskflex       1
  kontrest  . sbeskreval      1
  kontrest  . sbeskrest       1
  intro     . intro           1
  intro     . aktintroj       0.5
  intro     . aktintroij      0.5
  udlpens   . pension         1
  udlpens   . beskpens        1
  udlpens   . seniorpens      1
  udlpens   . beskseniorpens  1
#  udlseniorpens . seniorpens  1
#  udlseniorpens . beskseniorpens  1
  udltidlpens . tidlpens      1
  udltidlpens . besktidlpens  1
  udlfortid . fortid          1
  udlfortid . beskfortid      1
  boligyd   . pension         1
  boligyd   . beskpens        1
  boligyd   . tidlpens        1
  boligyd   . besktidlpens    1
  boligyd   . seniorpens      1
  boligyd   . beskseniorpens  1
  boligyd   . fortid          1
  boligyd   . beskfortid      1
  medie     . pension         1
  medie     . beskpens        1
  medie     . fortid          1
  medie     . beskfortid      1
  lumpsumovf . leddag         1
  lumpsumovf . ledkont        1
  lumpsumovf . uddsu          1
  lumpsumovf . orlov          1
  lumpsumovf . barsel         1
  lumpsumovf . syge           1
  lumpsumovf . aktdag         1
  lumpsumovf . reval          1
  lumpsumovf . ledigyd        1
  lumpsumovf . konthj         1
  lumpsumovf . fortid         1
  lumpsumovf . overg          1
  lumpsumovf . fleksyd        1
  lumpsumovf . efterl         1
  lumpsumovf . pension        1
  lumpsumovf . tjmand         1
  lumpsumovf . jobafkl        1
  lumpsumovf . ovrige         1
  lumpsumovf . aktkontudd     1
  lumpsumovf . aktkontj       1
  lumpsumovf . aktkontij      1
  lumpsumovf . udvforlob      1
  lumpsumovf . ledarbj        1
  lumpsumovf . aktarbj        1
  lumpsumovf . intro          1
  lumpsumovf . ledintro       1
  lumpsumovf . aktintroj      1
  lumpsumovf . aktintroij     1
  lumpsumovf . tidlpens       1
  lumpsumovf . besktidlpens   1
  lumpsumovf . seniorpens     1
  lumpsumovf . beskseniorpens 1
  #  boernyd   . a0t17        1
  #  boligst   . a18t100      1
  #  skatpl    . a18t100      1
  #  iskatpl   . a18t100      1
  #  groen     . a18t100      1
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
