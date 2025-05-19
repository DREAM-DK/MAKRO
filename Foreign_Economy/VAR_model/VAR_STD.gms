$BLOCK B_VAR_STANDARDIZE$(tx1[t])
  # Real Oil Price Equation  (standardized)
  E_pOil_standardize[t]..
      pOil[t] =E= std_pOil * pOil_shock[t];

  # World Oil Production Equation (standardized)
  E_qOilWorld_standardize[t]..
      qOilWorld[t] =E= std_qOilWorld * qOilWorld_shock[t];

  # World Oil Inventories Equation (standardized)
  E_qOilInvWorld_standardize[t]..
      qOilInvWorld[t] =E= std_qOilInvWorld * qOilInvWorld_shock[t];

  # World Industrial Production Equation (standardized)
  E_qIndWorld_standardize[t]..
      qIndWorld[t] =E= std_qIndWorld * qIndWorld_shock[t];

  # U.S. Real Imports Equation (standardized)
  E_qUSImports_standardize[t]..
      qUSImports[t] =E= std_qUSImports * qUSImports_shock[t];

  # U.S. CPI Equation (standardized)
  E_pUSCPI_standardize[t]..
      pUSCPI[t] =E= std_pUSCPI * pUSCPI_shock[t];

  # U.S. Industrial Production Equation (standardized)
  E_qUSInd_standardize[t]..
      qUSInd[t] =E= std_qUSInd * qUSInd_shock[t];

$ENDBLOCK