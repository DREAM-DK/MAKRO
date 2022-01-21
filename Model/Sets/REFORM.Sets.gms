*---------------------------------------------------------------------------------
*
* REFORM 73-sector setup
*
*---------------------------------------------------------------------------------

set ns73  "Investing industries in national accounting definition, 73 sectors" /
  01000  " 1 Agriculture and horticulture"
  02000  " 2 Forestry"
  03000  " 3 Fishing"
  0600a  " 4a Extration of oil"
  0600b  " 4b Extraction of gas (incl. coalimport)"
  08090  " 4c Extraction of gravel and stone and mining support service activities"
  10120  " 5 Manufacture of food products, beverages and tobacco"
  13150  " 6 Textiles and leather products"
  16000  " 7 Manufacture of wood and wood products"
  17000  " 8 Manufacture of paper and paper products"
  18000  " 9 Printing etc."
  19000  "10 Oil refinery etc."
  20000  "11 Manufacture of chemicals"
  21000  "12 Pharmaceuticals"
  22000  "13 Manufacture of rubber and plastic products"
  23000  "14 Manufacture of other non-metallic mineral products"
  24000  "15 Manufacture of basic metals"
  25000  "16 Manufacture of fabricated metal products"
  26000  "17 Manufacture of electronic components"
  27000  "18 Electrical equipment"
  28000  "19 Manufacture of machinery"
  29000  "20 Manufacture of motor vehicles and related parts"
  30000  "21 Manufacture of ships and other transport equipment"
  31320  "22 Manufacture of furniture and other manufacturing"
  33000  "23 Repair and installation of machinery and equipment"
  35001  "24a Production and distribution of electricity"
  35002  "24b Manufacture and distribution of gas"
  35003  "24c Steam and hot water supply"
  36000  "25 Water collection, purification and supply"
  37390  "26 Sewerage; waste collection, treatment and disposal activities etc."
  41430  "27 Construction"
  45000  "28 Wholesale and retail trade and repair of motor vehicles and motorcycles"
  46000  "29 Wholesale"
  47000  "30 Retail sale"
  49000  "31 Land transport and transport via pipelines"
  50000  "32 Water transport"
  51000  "33 Air transport"
  52000  "34 Support activities for transportation"
  53000  "35 Postal and courier activities"
  55560  "36 Accommodation and food service activities"
  58000  "37 Publishing activities"
  59600  "38 Motion picture and television programme prod., sound recording; radio and televisi"
  61000  "39 Telecommunications"
  62630  "40 IT and information service activities"
  64000  "41 Financial service activities, except insurance and pension funding"
  65000  "42 Insurance and pension funding"
  66000  "43 Other financial activities"
  68100  "44 Buying and selling of real estate"
  68300  "45 Renting of non-residential buildings"
  68203  "46 Renting of residential buildings"
  68204  "47 Owner-occupied dwellings"
  69700  "48 Legal and accounting activities; activities of head offices; management consultanc"
  71000  "49 Architectural and engineering activities"
  72001  "50 Scientific research and development (market)"
  72002  "51 Scientific research and development (non-market)"
  73000  "52 Advertising and market research"
  74750  "53 Other professional, scientific and technical activities; veterinary activities"
  77000  "54 Rental and leasing activities"
  78000  "55 Employment activities"
  79000  "56 Travel agent activities"
  80820  "57 Security and investigation; services to buildings and landscape; other businness s"
  84202  "58 Public administration etc."
  84101  "59 Rescue service etc. (market)"
  85202  "60 Education (non-market)"
  85101  "61 Education (market)"
  86000  "62 Human health activities"
  87880  "63 Residential care"
  90920  "64 Arts and entertainment; libraries, museums and other cultural activities; gambling"
  93000  "65 Sports activities and amusement and recreation activities"
  94000  "66 Activities of membership organisations"
  95000  "67 Repair of personal goods"
  96000  "68 Other personal service activities"
  97000  "69 Activities of households as employers of domestic personnel"
/;

set npi5 "Primary inputs in national accounting definition" / 
  nTp    "Commodity taxes, net"
  nTv    "VAT"
  nTo    "Other production taxes net (empty at constant or previous year's prices)"
  nW     "Compensation of employees (empty at constant or previous year's prices)"
  nCap   "Gross operating surplus and mixed income"
/;

alias(ns73,ns73c);
alias(ns73,ns73r);

set map732five(s,ns73)   "Mapping fra 73 til 5 brancher" /
cBol . (68203,68204)                                           
cPub . (72002,84101,84202,85202,86000,87880,90920)             
CCON . (41430)                                                 
cVar . (19000,
       35001,35002,35003,36000,
       01000,02000,03000,
       0600a,0600b,08090,
       10120,
       13150,16000,17000,18000,20000,21000,22000,23000,
       24000,25000,26000,27000,28000,29000,30000,31320,33000)   
cTje .  (50000,
        64000,65000,66000,
        37390,45000,47000,49000,52000,55560,59600,68100,
        68300,69700,71000,72001,73000,74750,77000,78000,
        85101,93000,94000,95000,96000,97000,
        46000,51000,53000,58000,61000,62630,79000,80820)
/;
