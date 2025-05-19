set_time_periods(%cal_deep%-1, %terminal_year%);
$FIX All; $UNFIX G_endo;
option mcp=convert;
solve M_base using mcp;