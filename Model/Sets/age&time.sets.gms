# ======================================================================================================================
# Set definitions
# ======================================================================================================================

# ----------------------------------------------------------------------------------------------------------------------
# Time
# ----------------------------------------------------------------------------------------------------------------------
sets
  t "Comprehensive time set that includes all periods used anywhere" /1967*%terminal_year%/

  tx0[t]       "All endogenous periods except t0"
  tx1[t]       "All except t0 and t1"
  tx0E[t]      "All except t0 and tEnd"
  txE[t]       "All except tEnd"

  tIOdata[t]      "Years where we have input output data"
  tADAMdata[t]    "Years where we have ADAM data" /1967*%cal_end%/

  tFMdata[t]      "Years where we have FM ADAM data"
  tPSKAT2data[t]  "Years where we have PSKAT2 data"

  tAgeData[t]  "Years where we have data on cohort behavior" /%AgeData_t1%*%AgeData_tEnd%/

  # These are used dynamically throughout data management
  tData[t]     "Years with data"
  tForecast[t] "Periods after last data year"
  tDataX1[t]   "Years with data, except the first"
;

singleton sets
    t0[t]   ""
    t1[t]   "First endogenous period"
    t2[t]   "Second endogenous period"
    tEnd[t] "Terminal period"

    tData1[t]    "First period with data"
    tDataEnd[t]  "Last period with data"

    tBase[t]      "Base year in which prices are set to 1" /%base_year%/
    tDeep[t]      "Last calibration year with full age distribution" /%cal_deep%/
    tDataEnd[t]   "Last calibration year"

    tHBI[t] "Year in which rHBI is evaluated" /%rHBI_eval%/    
;

parameters
  dt[t] "Number of years since t1"
;

# ----------------------------------------------------------------------------------------------------------------------
# Age
# ----------------------------------------------------------------------------------------------------------------------
# Aldersgrænserne er hardcodede for at forbedre læseligheden (og de er forholdsvis nemme at ændre alligevel)
# Grænserne er:
# 0 år, første aldersgruppe
# 15 år, første aldersgruppe på arbejdsmarkedet
# 18 år, første aldersgruppe hvis forbrug modelleres eksplicit
# 100 år, sidste mulige leveår
# 101 år, ingen levende, men renter mv. som tilskrives beholdninger fra 100 årige året før, dateres 101

sets
  a_ "Cohort ages and aggregates over age groups" /a15t100, a0t17, a18t100, tot, 0 * 110/
  a[a_] "All age groups" /0 * 101/  
  a0t100[a_] "Aller levende personer." /0 * 100/
  a1t100[a_] "Alle levende personer undtagen nyfødte." /1 * 100/
  a0t14[a_] "Børn" /0 * 14/
  a0t17[a_] "Alle levende personer under 18." /0 * 17/
  a15t100[a_] "Aller levende personer, som kan være på arbejdsmarkedet." /15 * 100/
  a18t100[a_] "Alle levende personer for hvem privat forbrug modelleres." /18 * 100/
;
set aTotals2a[a_,a] /
  a15t100 . set.a15t100
  a0t17 . set.a0t17
  a18t100 . set.a18t100
  tot . set.a
/;
singleton sets
  atot[a_]    "Total of all age groups" /tot/
;
parameter aVal[a_] "Numeric value of age super set";
aVal[a_] = ord(a_)-5;

# ----------------------------------------------------------------------------------------------------------------------
# Permanent heterogeneity
# ----------------------------------------------------------------------------------------------------------------------
sets
  h_ "Types of consumers and aggregate" / R, tot/
  h[h_] "Types of consumers" / R/
;
set hTotals[h_,h] /
  tot . set.h
/;
singleton sets 
  hTot[h_] "Total of all perm. heterogeneity" /tot/
  hhR[h_] "R" /R/
;



# ----------------------------------------------------------------------------------------------------------------------
# Alias
# ----------------------------------------------------------------------------------------------------------------------
alias(t,tt);
alias(a,aa);
alias(a,aaa);
alias(a_,aa_);
alias(h,hh);


# ----------------------------------------------------------------------------------------------------------------------
# Dummies
# ----------------------------------------------------------------------------------------------------------------------
sets
  d1Arv[a_,t] "Aldersgrupper med arvemotiv" //
;


# ======================================================================================================================
# Macros related to sets
# ======================================================================================================================
# Set dynamic time subsets based on a start period (t0) and a terminal period (tEnd).
# This is used to vary the number of periods that the model runs.
$MACRO set_time_periods(start, end) \
  t0[t]   = yes$(t.val=&start);\
  tx0[t]  = yes$(t.val>&start and t.val<=&end);\
  t1[t]   = yes$(t.val=(&start+1));\
  t2[t]   = yes$(t.val=(&start+2));\
  tx1[t]  = yes$(t.val>(&start+1) and t.val<=&end);\
  tx0E[t] = yes$(t.val>&start and t.val<&end);\
  txE[t]  = yes$(t.val>=&start and t.val<&end);\
  tEnd[t] = yes$(t.val=&end);\
  dt[t] = t.val - t1.val;\

# Find the first and last elements of a subset of t and store their values in two scalars, start and end.
$MACRO get_set_start_end(subset)               \     
  scalars start, end; start = 9999; end = 0; \                 
  loop(t$subset[t],                          \
          start = min(t.val, start);         \         
          end = max(t.val, end);             \     
      );                                     \

# Call the set_time_periods macro using the first and last element in the subset as start and end.
$MACRO set_time_periods_from_subset(subset) \
  get_set_start_end(subset)\
  set_time_periods(start, end)

# Set the dynamic time subsets used to control which years we have data. It is used for data imports and management.
$MACRO set_data_periods(start, end) \
  tData[t]             = yes$(&start <= t.val and t.val <= &end);\
  tData1[t]            = yes$(t.val = &start);\
  tDataX1[t]           = yes$(&start < t.val and t.val<=&end);\
  tDataEnd[t]          = yes$(t.val = &end);\
  tForecast[t]         = yes$(t.val > &end and t.val <= %terminal_year%);\

# Call the set_data_periods macro using the first and last element in the subset as start and end.
$MACRO set_data_periods_from_subset(subset) \
  get_set_start_end(subset)\
  set_data_periods(start, end)

$MACRO max_val(s) smax(s, s.val)

$MACRO min_val(s) smin(s, s.val)

# Initialize time subsets
set_time_periods(%cal_end%, %terminal_year%);
set_data_periods(%cal_start%, %cal_end%);
