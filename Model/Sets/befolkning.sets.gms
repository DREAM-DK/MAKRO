# ----------------------------------------------------------------------------------------------------------------------
# Befolkningsregnskab
# ----------------------------------------------------------------------------------------------------------------------
# vI anvender implicit set definition
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
/;

set soc_ "Arbejdsmarkedsstatus (FM definitioner) inkl. totaler" /
  set.activ
  bruttoled # (leddag,ledkont,ledarbj,ledintro,aktkontudd,sbeskjobtdag,sbeskjobtakt,aktkontj,aktdag,aktarbj, aktintroj)
  arbsty # (besk,beskuddsu,beskuddxsu,beskfortid,beskeft,beskpens,sbeskrest,sbeskflex,sbeskskaane,sbeskreval,sbeskjobtdag,sbeskjobtakt,dledkont,dleddag,leddag,ledkont,ledintro,ledarbj,aktkontj,aktkontudd,aktdag,aktarbj,aktintroj)
  #  aktdagtot # (aktarbj,aktdag)
  #  leddagtot # (leddag,ledarbj)
  nettoled # (leddag,ledarbj,ledkont,ledintro)
  nettoarbsty
  #  dled # (dledkont,dleddag)
  #  rest # (ovrige,selvpens)
  #  udd # (uddsu,uddxsu)
  #  besktot # (besk,beskuddsu,beskuddxsu,beskfortid,beskeft,beskpens,sbeskrest,sbeskflex,sbeskskaane,sbeskreval,sbeskjobtdag,sbeskjobtakt,dledkont,dleddag)
/;

set soc[soc_] "Arbejdsmarkedsstatus (FM definitioner) ekskl. totaler" /
  set.activ
/;

set bruttoled[soc_] "Bruttoledighed" /
  sbeskjobtdag            "Dagpengemodtagere i støttet beskæftigelse"
  sbeskjobtaktj           "Jobparate kontanthjælpsmodtagere i støttet beskæftigelse"
  sbeskjobtaktij          "Ikke-jobparate kontanthjælpsmodtagere i støttet beskæftigelse"
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

set nettoled[soc_] "Nettoledighed" /
  leddag                  "Ledige, forsikrede"
  ledkont                 "Ledige, ikke-forsikrede"
  ledarbj                 "FM special: Arbejdsmarkedsydelse - passive"
  ledintro                "FM special: integrationsydelse - aktive (nettoledige)"
/;

set besktot[soc_] "Beskæftigelse" /
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
/;

set arbsty[soc_] "Arbejdsstyrke" /
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
/;

set nettoarbsty[soc_] "Nettoarbejdsstyrke" /
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
/;

set soc_2soc[soc_,soc] "Mapping af aggregater til sociogrupper" /
  bruttoled . set.bruttoled
  arbsty . set.arbsty
  nettoled . set.nettoled
  nettoarbsty . set.nettoarbsty
/;

Set ovf_hh "Overførsler til husholdningerne" /
  ledigyd      "Ledighedsydelse"
  aktarbj      "Overførsler til aktiverede i arbejdsmarkedsydelsesordningen udenfor arbejdsstyrken"
#  sbeskjobtdag "Overførsler til dagpengemodtagere i offentlig løntilskudslignende ordning, uden for nettoarbejdsstyrken"
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
#  udlpens      "Folkepension til udland"
#  udlfortid    "Førtidspension til udland"
  boligyd      "Boligydelse"
  boligst      "Boligstøtte"
  skatpl       "Øvrige indkomstoverførsler, skattepligtige"
  iskatpl      "Øvrige indkomstoverførsler, ikke skattepligtige"
  groen        "Grøn check"
/;

Set ovf_udl         "Overførsler til udlandet" /
  udlpens      "Folkepension til udland"
  udlfortid    "Førtidspension til udland"
/;

Set ovf_         "Overførsler inkl. totaler" /
  set.ovf_hh
  set.ovf_udl
  tot
  hh
  a18t100
/;

Set ovf[ovf_]     "Overførsler ekskl. totaler" /
  set.ovf_hh
  set.ovf_udl
/;

Set ovfhh[ovf]     "Overførsler ekskl. totaler" /
  set.ovf_hh
/;

Set satsreg[ovf]     "Overførsler ekskl. totaler" /
  ledigyd      "Ledighedsydelse"
  aktarbj      "Overførsler til aktiverede i arbejdsmarkedsydelsesordningen udenfor arbejdsstyrken"
#  sbeskjobtdag "Overførsler til dagpengemodtagere i offentlig løntilskudslignende ordning, uden for nettoarbejdsstyrken"
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
#  groen        "Grøn check"
/;

Set ubeskat[ovf]     "Ubeskattede overførsler" /
  boernyd      "Børnefamilieydelse"
  boligyd      "Boligydelse"
  boligst      "Boligstøtte"
  iskatpl      "Øvrige indkomstoverførsler, ikke skattepligtige"
  groen        "Grøn check"
/;

Parameter nOvf2Soc[ovf_, soc] "Mapping mellem overførsler og BFR-grupper" /  
  ledigyd   . ledigyd      1 
  aktarbj   . aktarbj      1
  aktdag    . aktdag       1 
  aktkont   . aktkontudd   1
  aktkont   . aktkontj     1
  aktkont   . aktkontij    1
  aktkont   . aktintroj    0.5
  aktkont   . aktintroij   0.5
  reval     . reval        1
  uddsu     . uddsu        1
  uddsu     . beskuddsu    1
  leddag    . leddag       1
  ledarbj   . ledarbj      1
  ferie     . leddag       1
  syge      . syge         1
  syge      . besksyge     1
  barsel    . barsel       1
  barsel    . beskbarsel   1
  orlov     . orlov        1
  udvforlob . udvforlob    1
  udvforlob . jobafkl      1
  pension   . pension      1
  pension   . beskpens     1
  pension   . tidlpens     1
  pension   . besktidlpens 1
  fortid    . fortid       1
  fortid    . beskfortid   1
  efterl    . efterl       1
  efterl    . beskeft      1
  tjmand    . tjmand       1
  tillaeg   . pension      1
  tillaeg   . beskpens     1
  tillaeg   . tidlpens     1
  tillaeg   . besktidlpens 1
  tillaeg   . fortid       1
  tillaeg   . beskfortid   1
  tilbtrk   . pension      1
  tilbtrk   . beskpens     1
  tilbtrk   . tidlpens     1
  tilbtrk   . besktidlpens 1
  tilbtrk   . fortid       1
  tilbtrk   . beskfortid   1
  overg     . overg        1
  fleksyd   . fleksyd      1
  ledkont   . ledkont      1
  ledkont   . konthj       1
  ledkont   . ledintro     1
  kontflex  . sbeskflex    1
  kontrest  . sbeskreval   1
  kontrest  . sbeskrest    1
  intro     . intro        1
  intro     . aktintroj    0.5
  intro     . aktintroij   0.5
  udlpens   . pension      1
  udlpens   . beskpens     1
  udlpens   . tidlpens     1
  udlpens   . besktidlpens 1
  udlfortid . fortid       1
  udlfortid . beskfortid   1
  boligyd   . pension      1
  boligyd   . beskpens     1
  boligyd   . tidlpens     1
  boligyd   . besktidlpens 1
  boligyd   . fortid       1
  boligyd   . beskfortid   1

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
