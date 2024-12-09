# ----------------------------------------------------------------------------------------------------------------------
# To make growth and inflation adjustment easier, we create groups for all prices, quantities, and values respectively.
# We generate groups of prices, quantities, and values by looking at the the prefix of the variable names
# ----------------------------------------------------------------------------------------------------------------------

# Parameter definitions
parameters
  fq "1 year adjustment factor for growth in quantities, =1+gq"
  fp "1 year adjustment factor for price inflation, =1+gp"
  fv "1 year composite growth and inflation factor to adjust for growth in values, =(1+gq)(1+gp)"
  fqt[t] "Growth adjusment factor, =fq**(t-tBase)"
  fpt[t] "Inflation adjustment factor, =fp**(t-tBase)"
  fvt[t] "Geometric series for fv, =fv**(t-tBase)"
;
fq = (1 + gq);
fp = (1 + gp);
fv = fq * fp;
fqt[t] = fq**(t.val - %base_year%);
fpt[t] = fp**(t.val - %base_year%);
fvt[t] = fpt[t] * fqt[t];


# Exceptions to to the naming scheme can be added in the groups below

$GROUP G_prices # Variables that should be adjusted for steady state inflation
;

$GROUP G_quantities # Variables that should be adjusted for steady state productivity growth
  dvHhxAfk2dqBolig
  dvVirk2dpW
  sdvVirk2dpW
  jsqBVT
;

$GROUP G_values # Variables that should be adjusted for both steady state inflation and productivity growth
;

$GROUP G_variables_to_be_assigned_by_prefix
  All, - G_constants, - G_prices, - G_quantities, - G_values
;

$GROUP+ G_prices
  $EvalPython
    ",".join(
      name
      for name in self.groups["G_variables_to_be_assigned_by_prefix"]
      if (
        any(name.startswith(prefix) for prefix in ["p", "jp", "sp", "Ep", "mp"]) and "2p" not in name
      ) or (
        any(name.startswith(prefix) for prefix in ["dp", "sdp"]) and "2" in name and not any(x in name for x in ["2dp", "2dq", "2dv"])
      )
    )
  $EndEvalPython
;

$GROUP+ G_quantities
  $EvalPython
    ",".join(
      name
      for name in self.groups["G_variables_to_be_assigned_by_prefix"]
      if (
        any(name.startswith(prefix) for prefix in ["q", "jq", "sq", "Eq", "mq"]) and "2q" not in name
      ) or (
        any(name.startswith(prefix) for prefix in ["dq", "sdq"]) and "2" in name and not any(x in name for x in ["2dp", "2dq", "2dv"])
      )
    )
  $EndEvalPython
;

$GROUP+ G_values
  $EvalPython
    ",".join(
      name
      for name in self.groups["G_variables_to_be_assigned_by_prefix"]
      if (
        any(name.startswith(prefix) for prefix in ["v", "jv", "sv", "Ev", "mv", "nv"]) and "2v" not in name
      ) or (
        any(name.startswith(prefix) for prefix in ["dv", "sdv"]) and "2" in name and not any(x in name for x in ["2dp", "2dq", "2dv"])
      )
    )
  $EndEvalPython
;
