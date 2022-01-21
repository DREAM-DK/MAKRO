# ======================================================================================================================
# Data
# ======================================================================================================================
# Usually, in this file we import data from various sources and re-arrange the data as needed.
# We then assign data values to model variables.
# Finally, we adjust the model variables for inflation and growth.

# In this version, we only define a few parameters and do not rely on having access to any data.

# ----------------------------------------------------------------------------------------------------------------------
# Adjustment for inflation and growth
# ----------------------------------------------------------------------------------------------------------------------
parameters
  fq "1 year adjustment factor for growth in quantities"
  fp "1 year adjustment factor for price inflation"
  fv "1 year composite growth and inflation factor to adjust for growth in values"
  growth_factor[t] "Geometric series of fq, set to 1 in base_year"
  inf_factor[t] "Geometric series of fp, set to 1 in base_year"
  inf_growth_factor[t] "Geometric series of fv, set to 1 in base_year"
;
fq = (1 + gq);
fp = (1 + gp);
fv = fq * fp;
growth_factor[t] = 1/fq**(t.val - %base_year%);
inf_factor[t]    = 1/fp**(t.val - %base_year%);

# ----------------------------------------------------------------------------------------------------------------------
# Aldersfordelte socio-grupper og overførselsgrupper 
# ----------------------------------------------------------------------------------------------------------------------
parameters
  nOvf_a[ovf_,a_,t]             "Modtager-grupper fordelt på alder, antal 1.000 personer"
  nSoc_a[soc_,a_,t]             "Socio-grupper fordelt på alder, antal 1.000 personer"
  snSoc_a[soc_,a_,t]            "Strukturelle socio-grupper fordelt på alder, antal 1.000 personer"
  snSocFraBesk[soc_,a_,t]       "Strukturel beskæftigelseseffekt på socio-gruppe fordelt på alder, antal 1.000 personer"
  snSocResidual[soc_,a_,t]      "Strukturel residualeffekt fra befolkning på socio-gruppe fordelt på alder, antal 1.000 personer"
  nSocFraBesk[soc_,a_,t]        "Beskæftigelseseffekt på socio-gruppe fordelt på alder, antal 1.000 personer"
  nSocResidual[soc_,a_,t]       "Residualeffekt fra befolkning på socio-gruppe fordelt på alder, antal 1.000 personer"
  nOvfFraSocBesk[ovf_,a_,t]     "Beskæftigelseseffekt på modtager-gruppe fordelt på alder, antal 1.000 personer"
  nOvfFraSocResidual[ovf_,a_,t] "Residualeffekt fra befolkning på modtager-gruppe fordelt på alder, antal 1.000 personer"
;
