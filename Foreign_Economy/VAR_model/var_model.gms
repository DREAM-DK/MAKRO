# ======================================================================================================================
# VAR MODEL
# ======================================================================================================================

$GROUP G_VAR  # Model parameters
    pOil[t] "Real oil price"
    qOilWorld[t] "World oil production"
    qOilInvWorld[t] "World oil inventories"
    qIndWorld[t] "World oil inventories"
    qUSImports[t] "U.S. Real Imports"
    qUSInd[t] "U.S. Industrial Production"
    pUSCPI[t] "U.S. CPI"
;

$GROUP G_VAR_SHOCK
    jqOilWorld[t] "Oil (world) supply shock"
    jpOil[t] "Oil (world) supply shock"
;
$GROUP G_VAR # condition on tx1
  G_VAR$(tx1[t])
;

# initial values for all variables are zero because the VAR is in log-difference
$FIX(0) G_VAR, G_VAR_SHOCK;

$BLOCK B_VAR
# Real Oil Price Equation
  E_pOil[t]$(tx1[t])..
      pOil[t] =E=
              - 0.00248 * pOil[t-1]
              - 0.1935 * pOil[t-2]
              + 0.21944 * pOil[t-3]
              - 0.23288 * pOil[t-4]
              + 0.234444 * qOilWorld[t-1]
              - 0.31562 * qOilWorld[t-2]
              + 0.053447 * qOilWorld[t-3]
              - 0.17618 * qOilWorld[t-4]
              - 0.16228 * qOilInvWorld[t-1]
              + 0.014281 * qOilInvWorld[t-2]
              + 0.030157 * qOilInvWorld[t-3]
              - 0.01982 * qOilInvWorld[t-4]
              + 0.169796 * qIndWorld[t-1]
              - 0.02622 * qIndWorld[t-2]
              + 0.102304 * qIndWorld[t-3]
              + 0.11074 * qIndWorld[t-4]
              + 0.53343 * qUSInd[t-1]
              - 0.12697 * qUSInd[t-2]
              - 0.04546 * qUSInd[t-3]
              + 0.274436 * qUSInd[t-4]
              - 0.1257 * pUSCPI[t-1]
              + 0.0881 * pUSCPI[t-2]
              - 0.11292 * pUSCPI[t-3]
              - 0.17686 * pUSCPI[t-4]
              - 0.2112 * qUSImports[t-1]
              - 0.0785 * qUSImports[t-2]
              + 0.227207 * qUSImports[t-3]
              - 0.21688 * qUSImports[t-4]
              + jpOil[t];

  # World Oil Production Equation
  E_qOilWorld[t]$(tx1[t])..
      qOilWorld[t] =E=
                  + 0.007483 * pOil[t-1]
                  + 0.236501 * pOil[t-2]
                  - 0.2634 * pOil[t-3]
                  + 0.078628 * pOil[t-4]
                  - 0.0104 * qOilWorld[t-1]
                  + 0.143865 * qOilWorld[t-2]
                  + 0.10322 * qOilWorld[t-3]
                  + 0.176001 * qOilWorld[t-4]
                  - 0.35631 * qOilInvWorld[t-1]
                  - 0.37919 * qOilInvWorld[t-2]
                  - 0.14164 * qOilInvWorld[t-3]
                  + 0.046957 * qOilInvWorld[t-4]
                  - 0.25303 * qIndWorld[t-1]
                  - 0.19293 * qIndWorld[t-2]
                  - 0.25602 * qIndWorld[t-3]
                  + 0.053563 * qIndWorld[t-4]
                  + 0.071754 * qUSInd[t-1]
                  + 0.132243 * qUSInd[t-2]
                  + 0.141593 * qUSInd[t-3]
                  - 0.03746 * qUSInd[t-4]
                  - 0.13254 * pUSCPI[t-1]
                  + 0.25858 * pUSCPI[t-2]
                  - 0.23942 * pUSCPI[t-3]
                  + 0.086293 * pUSCPI[t-4]
                  - 0.00569 * qUSImports[t-1]
                  - 0.53905 * qUSImports[t-2]
                  - 0.23842 * qUSImports[t-3]
                  - 0.0453 * qUSImports[t-4]
                  + jqOilWorld[t];

# World Oil Inventories Equation
  E_qOilInvWorld[t]$(tx1[t])..
      qOilInvWorld[t] =E=
                    + 0.01003 * pOil[t-1]
                    + 0.147929 * pOil[t-2]
                    + 0.145333 * pOil[t-3]
                    + 0.057978 * pOil[t-4]
                    - 0.00818 * qOilWorld[t-1]
                    + 0.055965 * qOilWorld[t-2]
                    + 0.113399 * qOilWorld[t-3]
                    - 0.08641 * qOilWorld[t-4]
                    + 0.106136 * qOilInvWorld[t-1]
                    + 0.01809 * qOilInvWorld[t-2]
                    + 0.06301 * qOilInvWorld[t-3]
                    + 0.045077 * qOilInvWorld[t-4]
                    - 0.08485 * qIndWorld[t-1]
                    + 0.024539 * qIndWorld[t-2]
                    - 0.08226 * qIndWorld[t-3]
                    - 0.34319 * qIndWorld[t-4]
                    - 0.33522 * qUSInd[t-1]
                    + 0.018946 * qUSInd[t-2]
                    - 0.23815 * qUSInd[t-3]
                    + 0.08428 * qUSInd[t-4]
                    + 0.255218 * pUSCPI[t-1]
                    + 0.045209 * pUSCPI[t-2]
                    + 0.043357 * pUSCPI[t-3]
                    - 0.07122 * pUSCPI[t-4]
                    + 0.207942 * qUSImports[t-1]
                    - 0.09306 * qUSImports[t-2]
                    - 0.17367 * qUSImports[t-3]
                    + 0.248229 * qUSImports[t-4];

  # World Industrial Production Equation
  E_qIndWorld[t]$(tx1[t])..
        qIndWorld[t] =E=
                    - 0.00382 * pOil[t-1]
                    - 0.32629 * pOil[t-2]
                    - 0.16524 * pOil[t-3]
                    - 0.12016 * pOil[t-4]
                    + 0.124657 * qOilWorld[t-1]
                    - 0.06418 * qOilWorld[t-2]
                    + 0.08778 * qOilWorld[t-3]
                    + 0.006239 * qOilWorld[t-4]
                    - 0.00575 * qOilInvWorld[t-1]
                    + 0.060711 * qOilInvWorld[t-2]
                    - 0.05078 * qOilInvWorld[t-3]
                    + 0.018053 * qOilInvWorld[t-4]
                    + 0.095747 * qIndWorld[t-1]
                    - 0.25292 * qIndWorld[t-2]
                    + 0.038084 * qIndWorld[t-3]
                    + 0.110917 * qIndWorld[t-4]
                    + 0.774107 * qUSInd[t-1]
                    - 0.10578 * qUSInd[t-2]
                    - 0.05778 * qUSInd[t-3]
                    - 0.20054 * qUSInd[t-4]
                    - 0.08424 * pUSCPI[t-1]
                    + 0.278436 * pUSCPI[t-2]
                    + 0.07304 * pUSCPI[t-3]
                    + 0.211179 * pUSCPI[t-4]
                    - 0.31379 * qUSImports[t-1]
                    - 0.42697 * qUSImports[t-2]
                    + 0.043353 * qUSImports[t-3]
                    - 0.17031 * qUSImports[t-4];

  # U.S. Industrial Production Equation
  E_qUSInd[t]$(tx1[t])..
      qUSInd[t] =E=
                + 0.010506 * pOil[t-1]
                - 0.05763 * pOil[t-2]
                - 0.22466 * pOil[t-3]
                - 0.08758 * pOil[t-4]
                + 0.089716 * qOilWorld[t-1]
                + 0.006788 * qOilWorld[t-2]
                + 0.075727 * qOilWorld[t-3]
                + 0.129553 * qOilWorld[t-4]
                - 0.08486 * qOilInvWorld[t-1]
                + 0.026371 * qOilInvWorld[t-2]
                - 0.03823 * qOilInvWorld[t-3]
                + 0.01506 * qOilInvWorld[t-4]
                - 0.04573 * qIndWorld[t-1]
                - 0.23048 * qIndWorld[t-2]
                - 0.01762 * qIndWorld[t-3]
                + 0.06892 * qIndWorld[t-4]
                + 0.37251 * qUSInd[t-1]
                - 0.01464 * qUSInd[t-2]
                - 0.05085 * qUSInd[t-3]
                - 0.10011 * qUSInd[t-4]
                + 0.22384 * pUSCPI[t-1]
                + 0.01621 * pUSCPI[t-2]
                + 0.22583 * pUSCPI[t-3]
                + 0.008992 * pUSCPI[t-4]
                - 0.37437 * qUSImports[t-1]
                - 0.18556 * qUSImports[t-2]
                - 0.16943 * qUSImports[t-3]
                - 0.23929 * qUSImports[t-4];

  # U.S. CPI Equation
  E_pUSCPI[t]$(tx1[t])..
      pUSCPI[t] =E=
                - 0.00267 * pOil[t-1]
                - 0.1796 * pOil[t-2]
                - 0.16101 * pOil[t-3]
                - 0.09163 * pOil[t-4]
                + 0.215291 * qOilWorld[t-1]
                - 0.07926 * qOilWorld[t-2]
                - 0.02724 * qOilWorld[t-3]
                - 0.09516 * qOilWorld[t-4]
                + 0.030232 * qOilInvWorld[t-1]
                + 0.115934 * qOilInvWorld[t-2]
                + 0.098988 * qOilInvWorld[t-3]
                + 0.045729 * qOilInvWorld[t-4]
                - 0.0159 * qIndWorld[t-1]
                + 0.01482 * qIndWorld[t-2]
                + 0.019112 * qIndWorld[t-3]
                + 0.082638 * qIndWorld[t-4]
                + 0.195144 * qUSInd[t-1]
                + 0.064327 * qUSInd[t-2]
                - 0.10226 * qUSInd[t-3]
                + 0.061604 * qUSInd[t-4]
                + 0.080115 * pUSCPI[t-1]
                + 0.021357 * pUSCPI[t-2]
                + 0.094527 * pUSCPI[t-3]
                + 0.073836 * pUSCPI[t-4]
                + 0.019365 * qUSImports[t-1]
                - 0.04688 * qUSImports[t-2]
                + 0.311127 * qUSImports[t-3]
                + 0.007296 * qUSImports[t-4];

  # Real U.S. Import Equation
  E_qUSImports[t]$(tx1[t])..
      qUSImports[t] =E=
                - 0.00563 * pOil[t-1]
                - 0.21295 * pOil[t-2]
                - 0.21899 * pOil[t-3]
                - 0.11704 * pOil[t-4]
                + 0.058598 * qOilWorld[t-1]
                + 0.076002 * qOilWorld[t-2]
                + 0.018619 * qOilWorld[t-3]
                + 0.030828 * qOilWorld[t-4]
                + 0.078406 * qOilInvWorld[t-1]
                + 0.06917 * qOilInvWorld[t-2]
                - 0.02894 * qOilInvWorld[t-3]
                - 0.07022 * qOilInvWorld[t-4]
                - 0.09876 * qIndWorld[t-1]
                - 0.04274 * qIndWorld[t-2]
                + 0.005848 * qIndWorld[t-3]
                - 0.06559 * qIndWorld[t-4]
                + 0.327958 * qUSInd[t-1]
                - 0.12019 * qUSInd[t-2]
                + 0.109151 * qUSInd[t-3]
                - 0.21097 * qUSInd[t-4]
                + 0.224504 * pUSCPI[t-1]
                + 0.094994 * pUSCPI[t-2]
                - 0.05599 * pUSCPI[t-3]
                + 0.19059 * pUSCPI[t-4]
                - 0.32733 * qUSImports[t-1]
                - 0.18586 * qUSImports[t-2]
                - 0.07158 * qUSImports[t-3]
                - 0.01914 * qUSImports[t-4];
$ENDBLOCK

Model M_VAR / # pure VAR model
B_VAR
/;

# Model for feeding DGE shock into VAR model through output and prices
Model M_DGE2VAR / # pure VAR model
B_VAR
- E_qUSInd # GDP 
- E_pUSCPI # CPI 
/;
# ======================================================================================================================
# the VAR is normalized by std. deviations of the variables, so need to rescale.
parameter std_pOil, std_qOilWorld, std_qOilInvWorld, std_qIndWorld, std_qUSImports, 
          std_pUSCPI, std_qUSInd; 
std_pOil = 13.76238264; # standard deviation of oil price
std_qOilWorld = 1.986405607; # standard deviation of world oil production
std_qOilInvWorld = 1.765938695; # standard deviation of world oil inventories
std_qIndWorld = 1.095827412; # standard deviation of world industrial production
std_qUSImports = 3.520809887; # standard deviation of U.S. real imports
std_pUSCPI = 0.766284107; # standard deviation of U.S. CPI
std_qUSInd = 1.367754545; # standard deviation of U.S. industrial production
@set(All, _shock, .l);
$IMPORT VAR_model/VAR_STD.gms # import standardization block