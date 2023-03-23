# ======================================================================================================================
#
# ADAM 12-sector setup
#
# ======================================================================================================================

# ----------------------------------------------------------------------------------------------------------------------
# Define all elements in base sets with long names.
# These are used to construct the sets we need after.
# ----------------------------------------------------------------------------------------------------------------------
# Create a set of ADAM variables by reading from the ADAM bank and FM ADAM bank
set load_ADAM_variables;
$GDXIN "..\Data\ADAM\ADAM_set.gdx" $load load_ADAM_variables=ADAM_variables $GDXIN
set ADAM_variables /
    set.load_ADAM_variables
    c_et, pC_et                 # We add a foreign tourist consumption group
    ita, pita, fita, fknta      # We add investments and capital in breeding herds to the agricultural sector a
    ULBGAP, qgap, FFYGAP, UAGAP, woski, wosku, WOSK, Syc_e, tion2, FCODEM, FYGAP , lnda  #FM-specific variables are added
    pfbvgt,pfgvgt, pfevgt,pffvgt,pfvvgt,pfhvgt,pfsvgt,pftvgt,pfpb, pfpe, pfpg,pfpf,pfph,pfps,pfpt, pfpv, pfp #Variables to consumer price idnex
    vbhicp,vghicp, vehicp,vfhicp,vvhicp,vhhicp,vshicp,vthicp , pfphicp #Variables to consumer price idnex
    pnpb,pnpg, pnpe,pnpf,pnpv,pnph,pnps,pnpt, pnp,  pnbvgt,pngvgt, pnevgt,pnfvgt,pnvvgt,pnhvgt,pnsvgt,pntvgt    #Variables to consumer price idnex
    e3x                         # Variable som var med i jul17x, men ikke i okt20
 /; 


# ----------------------------------------------------------------------------------------------------------------------
# Raw sets that we use to construct actual sets below
# ----------------------------------------------------------------------------------------------------------------------
sets 
    ADAM_brancher /
        a     "Agricultural sector"
        b     "Construction sector"
        e     "Extraction sector"
        h     "Housing sector"
        o     "Public service sector"
        ne    "Energy manufactoring sector"
        nf    "Foodstuff manufactoring sector"
        ng    "Refinery manufactoring sector"
        nz    "Manufactoring sector (other)"
        qf    "Financial services"
        qs    "Seatransport services"
        qz    "Services"
    /
    ADAM_commodity_imports /
        m01    "Imports of foodstuff"
        m2     "Imports of nonfood raw materials"
        m3k    "Imports of energy - coal"
        m3r    "Imports of energy - crude oil"
        m3q    "Imports of energy - other"
        m59    "Imports of manufacturing"
        m7b    "Imports of cars"
        m7y    "Imports of ships and planes"
    /
    ADAM_service_imports /
        ms     "Imports of services"
        mt     "Imports of turism"
    /
    ADAM_private_production_sectors /
        xa     "Production from agricultural sector"
        xb     "Production from construction sector"
        xe     "Production from extraction sector"
        xh     "Production from housing sector"
        xne    "Production from energy manufactoring sector"
        xnf    "Production from foodstuff manufactoring sector"
        xng    "Production from refinery manufactoring sector"
        xnz    "Production from other manufactoring sector"
        xqf    "Production from financial services"
        xqs    "Production from seatransport services"
        xqz    "Production from other services"
    /
    ADAM_customs_groups /
        spm01  "Customs on foodstuff"
        spm2   "Customs on nonfood raw materials"
        spm3k  "Customs on energy - coal"
        spm3r  "Customs on energy - crude oil"
        spm3q  "Customs on energy - other"
        spm59  "Customs on manufacturing"
        spm7b  "Customs on cars"
        spm7y  "Customs on ships and planes"
        spms   "Customs on services"
        spmt   "Customs on turism"
    /
    ADAM_taxes /
        spm    "Customs"
        spp    "Duty"
        spg    "VAT"
#         spr    "Registration duty for cars"
        spz    "Other production taxes"
    /
    ADAM_incomes /
        yw     "Wagesum"
        yr     "Other capital income"
    /
    ADAM_non_energy_input /
        vma    "Non-energy production input from agricultural sector"
        vmb    "Non-energy production input from construction sector"
        vme    "Non-energy production input from extraction sector"
        vmh    "Non-energy production input from housing sector"
        vmo    "Non-energy production input from public service sector"
        vmne   "Non-energy production input from energy manufactoring sector"
        vmnf   "Non-energy production input from foodstuff manufactoring sector"
        vmng   "Non-energy production input from refinery manufactoring sector"
        vmnz   "Non-energy production input from other manufactoring sector"
        vmqf   "Non-energy production input from financial services"
        vmqs   "Non-energy production input from seatransport services"
        vmqz   "Non-energy production input from other services"
    /
    ADAM_energy_input /
        vea    "Energy production input from agricultural sector"
        veb    "Energy production input from construction sector"
        vee    "Energy production input from extraction sector"
        veh    "Energy production input from housing sector"
        veo    "Energy production input from public service sector"
        vene   "Energy production input from energy manufactoring sector"
        venf   "Energy production input from foodstuff manufactoring sector"
        veng   "Energy production input from refinery manufactoring sector"
        venz   "Energy production input from other manufactoring sector"
        veqf   "Energy production input from financial services"
        veqs   "Energy production input from seatransport services"
        veqz   "Energy production input from other services"
    /
    ADAM_private_consumption /
        ch     "Private consumption of housing"
        cg     "Private consumption of petrol for cars"
        cb     "Private consumption of cars"
        ce     "Private consumption of heating"
        cf     "Private consumption of foodstuff"
        cv     "Private consumption of other goods"
        ct     "Private consumption of turism"
        cs     "Private consumption of other services"
        c_et    "Excluding consumption from turists"
    /
    ADAM_public_consumption /
        co     "Public consumption"
    /
    ADAM_export_groups /
        e01    "Exports of foodstuff"
        e2     "Exports of nonfood raw materials"
        e3     "Exports of energy"
        e59    "Exports of manufacturing"
        e7y    "Exports of ships and planes"
        ess    "Exports of shipping services"
        esq    "Exports of other services"
        et     "Exports of turism"
    /
    ADAM_investment_groups /
        im     "Investments in machinery"
        iB     "Investments in buildings"
        it     "Investments in breeding stock"
        ikn    "Investments in valuables"
        il     "Investments in stockbuilding"
    /
    ADAM_capital_groups /
        knm     "Machinery"
        knb     "Buildings"
        knt     "Breeding stock"
    /
;

# ----------------------------------------------------------------------------------------------------------------------
# Actual set structure
# ----------------------------------------------------------------------------------------------------------------------
sets 
    branche "ADAM sectors"      / set.ADAM_brancher /

    ak "ADAM investment and capital groups" / set.ADAM_capital_groups /

    ADAM_production_sectors[ADAM_variables] "Both private and public production sectors" /
        set.ADAM_private_production_sectors
        xo
    /

    asad[ADAM_variables] "All ADAM demand and supply components, sectors, and investment groups" /
        set.ADAM_production_sectors
        set.ADAM_commodity_imports
        set.ADAM_service_imports
        set.ADAM_taxes
        set.ADAM_incomes

        set.ADAM_non_energy_input
        set.ADAM_energy_input
        set.ADAM_private_consumption
        set.ADAM_public_consumption
        set.ADAM_investment_groups
        set.ADAM_export_groups

        e3x
        imx
        imxo7y
    /
    as[asad] "ADAM supply" /
        set.ADAM_production_sectors
        set.ADAM_commodity_imports
        set.ADAM_service_imports
        set.ADAM_taxes
        set.ADAM_incomes
    /
    ax[as]   "ADAM production sectors"                    / set.ADAM_production_sectors /
    axp[as]  "ADAM private production sectors"           / set.ADAM_private_production_sectors /
    amv[as]  "ADAM commodity import groups"               / set.ADAM_commodity_imports  /
    am[as]   "ADAM import groups"                         / set.ADAM_commodity_imports, set.ADAM_service_imports /
    axm[as]  "Input from domestic and foreign production" / set.ADAM_production_sectors, set.am /
    axpm[as] "Input from domestic and foreign private production" / set.ADAM_private_production_sectors, set.am /
    axmt[as] "Input from domestic and foreign production incl. product taxes" / set.axm, spp, spg, spm /

    ad[asad]  "ADAM demand" /
        set.ADAM_non_energy_input
        set.ADAM_energy_input
        set.ADAM_private_consumption
        set.ADAM_public_consumption
        set.ADAM_investment_groups
        set.ADAM_export_groups
    /
    ai[ad]   "ADAM investment groups"           / set.ADAM_investment_groups       /
    avm[ad]  "ADAM non-energy production input" / set.ADAM_non_energy_input        /
    ave[ad]  "ADAM energy production input"     / set.ADAM_energy_input            /
    av[ad]   "ADAM production input"            / set.avm, set.ave                 /
    acp[ad]  "ADAM private consumption groups"  / set.ADAM_private_consumption     /
    ae[ad]   "ADAM export groups"               / set.ADAM_export_groups           /

    ad_v[asad]  "ADAM demand" /
        set.ADAM_private_consumption
        set.ADAM_public_consumption
        set.ADAM_investment_groups
        set.ADAM_export_groups
    /

    aee  "ADAM export market groups" /
        ee01    "Export market for foodstuff"
        ee2     "Export market for nonfood raw materials"
        exe_e3  "Export market for energy - crude oil"
        ee3x    "Export market for energy - excl. crude oil"
        ee59    "Export market for manufacturing"
        ee7y    "Export market for ships and planes"
        eess    "Export market for shipping services"
        eesq    "Export market for other services"
        eet     "Export market for turism"
    /
;

alias[branche,branche1];
alias[amv,amv1];
alias[axm,axm1];
alias[axpm,axpm1];
alias[ave,ave1];
alias[asad,asad1];
alias[avm,avm1];
alias[axmt,axmt1];
alias[ad,ad1];


sets mapai2ak[ak,ai] "Mapping from ADAM investment groups to ADAM capital groups" /
    knm . im
    knb . iB
    knt . it
/;

# ----------------------------------------------------------------------------------------------------------------------
# Mappings
# ----------------------------------------------------------------------------------------------------------------------
set mapave2branche[branche,ave] "Mapping fra energi materialer til brancher" /
    a  . vea 
    b  . veb 
    ne . vene 
    ng . veng 
    e  . vee 
    h  . veh 
    nf . venf 
    nz . venz 
    o  . veo 
    qs . veqs 
    qf . veqf 
    qz . veqz 
/;

set mapavm2branche[branche,avm] "Mapping fra ikke-energi materialer til brancher" /
    a  . vma 
    b  . vmb 
    ne . vmne 
    ng . vmng 
    e  . vme 
    h  . vmh 
    nf . vmnf 
    nz . vmnz 
    o  . vmo 
    qs . vmqs 
    qf . vmqf 
    qz . vmqz 
/;

set mapax2branche[branche,ax] "Mapping fra produktion til brancher" /
    a  . xa 
    b  . xb 
    ne . xne 
    ng . xng 
    e  . xe 
    h  . xh 
    nf . xnf 
    nz . xnz 
    o  . xo 
    qs . xqs 
    qf . xqf 
    qz . xqz 
/;

set mapave2avm[avm,ave] "Mapping fra energi materialer til brancher" /
    vma  . vea 
    vmb  . veb 
    vmne . vene 
    vmng . veng 
    vme  . vee 
    vmh  . veh 
    vmnf . venf 
    vmnz . venz 
    vmo  . veo 
    vmqs . veqs 
    vmqf . veqf 
    vmqz . veqz 
/;
