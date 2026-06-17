rm(list=ls())
start.time <- Sys.time()

## Installér pakker:
# Brug R/install_packages.R som kan køres med R/run_install_packages.cmd

library(tidyverse)
library(forecast)
library(xts)
library(lmtest)
library(parallel)
library(gamstransfer)

source("R/gamstransfer_ts.R") # hent aux. funktioner

## -------------------- Indstillinger i estimationen --------------------
plot.end <- 2099 ## Sidste år i plot af fremskrivningen

plot.path <- "Gdx/StaticCalib_AutoArima_Mega.pdf"
output.path <- "Gdx/ARIMA_forecasts.gdx"
input.path <- "Gdx/ARIMA_forecast_input.gdx"
min.bend.trend <- 5 ## minimum trendafbøjnings perioder

num.cores <- detectCores()
cl <- makeCluster(num.cores-1)

check.sanity <- FALSE # if TRUE, throw an error if sanity check fails. Otherwise, transform trends with issues (decrease trend).

if (check.sanity == TRUE) {
  log_file <- "sanity_check_log.txt"
  file.create(log_file)
}

## -------------------- Funktioner  --------------------
constant.series <- function (series.name, series) {
  # print(paste(series.name, "is constant"))
  list(x=series, is.constant=TRUE, series.name=series.name)
}

auto.arima.0 <- forecast::auto.arima

# Add try.force.drift parameter to auto.arima function
auto.arima.1 <- function(..., try.force.drift = FALSE) {
  if (try.force.drift) {
    tryCatch({
      return(auto.arima.0(..., include.mean = TRUE))
    }, error = function(e) {})
  }
  return(auto.arima.0(...))
}

# Add no.oscillation parameter to auto.arima function
auto.arima.2 <- function(..., max.p = 5, no.oscillation = FALSE) {
  arima <- auto.arima.1(..., max.p = max.p)
  if (no.oscillation) {
    p <- arima$arma[[1]]
    # Check if any p coefficients are negative or greater than the first p coefficient
    # If so, try again with lower maximum p
    if (p > 0 && (any(arima$coef[1:p] < 0) || any(arima$coef[1:p] > arima$coef[1]))){
      arima <- auto.arima.2(..., max.p = p-1, no.oscillation = no.oscillation)
    }
  }
  return(arima)
}

# Avoid using BoxCox transformation with negative drift - use either linear (=1) or log (=0) instead
auto.arima.3 <- function(..., lambda=1) {
  arima <- auto.arima.2(..., lambda=lambda)
  if (
    lambda < 0.9
    &&
    "drift" %in% names(arima$coef)
    &&
    arima$coef[["drift"]] < 0
  ){
    arima <- auto.arima.2(..., lambda=0.0001)
  }
  return(arima)
}

auto.arima <- auto.arima.3

clean.series <- function(series) {
  series[near(series, 0)] <- NA
  if (any(is.na(series))) series <- series[-1:-max(which(is.na(series)))]
  series
}

## Fit ARIMA til serie
fit.series <- function(series.name, series){
  data_start <- as.numeric(all.ARIMA_start[[series.name]][["value"]])
  estimation_end <- as.numeric(all.ARIMA_estimation_end[[series.name]][["value"]])
  full_series <- window(series, start = data_start, end = t.data.end) |> clean.series()
  if (length(full_series)==0) full_series <- ts(rep(0, t.data.end - data_start + 1), start=data_start, end=t.data.end)
  estimation_series <- window(full_series, end=estimation_end)
  last.observation <- estimation_series[length(estimation_series)]
  if (length(estimation_series) < 5 ||
      near(last.observation, estimation_series[length(estimation_series)-1]) ||
      near(last.observation, 0) || near(last.observation, 1)){
    constant_series <- list() # tom liste
    ## make sure output format is equal across return calls
    constant_series$drift <- constant.series(series.name, full_series)
    constant_series$nodrift <- constant.series(series.name, full_series)
    constant_series$is.constant <- TRUE
    
    return(constant_series)
  }
  # # print(paste("Fitting ARIMA to", series.name))
  
  # Parameter til Box-Cox-transformation. 0=log, 1=lineær transformation (igen effekt)
  if (all(estimation_series > 0)){
    lambda = BoxCox.lambda(estimation_series, lower=0.0001, upper=1.2)
  } else {
    lambda = 1
  }
  
  var_name <- get_variable_name(series.name)
  ## arima'er med og uden drift
  if (all.horizon[[series.name]][["value"]]!=0) { ## Tillad ikke drift hvis variablen har horizon = 0 
    
    arima_drift <- auto.arima(
      estimation_series,
      max.p = 2,
      max.q = if (ci_match(var_name, q0)){0} else {1}, # Restriktér q til 0 hvis variablen er i q0 listen
      max.d = if (ci_match(var_name, d0)){0} else {1}, # Restriktér d til 0 hvis variablen er i d0 listen
      seasonal = FALSE, ic = "aicc", stepwise = FALSE,
      lambda = lambda,
      allowdrift = TRUE,
      try.force.drift = TRUE,
      no.oscillation = TRUE,
    )
    lambda = arima_drift$lambda # overskriv hvis lambda erstattet p.g.a. negativ drift (auto.arima.3)
    
    arima_nodrift <- auto.arima(
      estimation_series,
      max.p = 2,
      max.q = if (ci_match(var_name, q0)){0} else {1}, # Restriktér q til 0 hvis variablen er i q0 listen
      max.d = if (ci_match(var_name, d0)){0} else {1}, # Restriktér d til 0 hvis variablen er i d0 listen
      seasonal = FALSE, ic = "aicc", stepwise = FALSE,
      lambda = lambda,
      allowdrift = FALSE, 
      no.oscillation = TRUE,
    )
    
  } else {
    arima_nodrift <- auto.arima(
      estimation_series,
      max.p = 2,
      max.q = if (ci_match(var_name, q0)){0} else {1}, # Restriktér q til 0 hvis variablen er i q0 listen
      max.d = if (ci_match(var_name, d0)){0} else {1}, # Restriktér d til 0 hvis variablen er i d0 listen
      seasonal = FALSE, ic = "aicc", stepwise = FALSE,
      lambda = lambda,
      allowdrift = FALSE, 
      no.oscillation = TRUE,
    )
    arima_drift <- arima_nodrift # if drift not allowed
  }
  
  ## Gem andre informationer i arima objekt
  arima_drift$series.name <- series.name
  arima_drift$is.constant <- all(arima_drift$coef == 0)
  arima_drift$n.observations <- sum(!is.na(estimation_series))
  arima_nodrift$series.name <- series.name
  arima_nodrift$n.observations <- arima_drift$n.observations
  arima_drift_forecast <- forecast::Arima(full_series, model = arima_drift)
  arima_nodrift_forecast <- forecast::Arima(full_series, model = arima_nodrift)
  
  ## Gem både drift og no drift arima'er
  arimas <- list(numeric(length = 0)) # tomt objekt
  arimas$drift <- arima_drift
  arimas$nodrift <- arima_nodrift
  arimas$drift_forecast <- arima_drift_forecast
  arimas$nodrift_forecast <- arima_nodrift_forecast
  arimas$is.constant <- arimas$drift$is.constant # til forecast tjek om konstant fremskrivning
  
  return(arimas)
}

trend.bound <- function(transformed_forecast, lambda, zero_to_one, T, decreasing, positive) {
  bound <- transformed_forecast[T]
  if (zero_to_one) bound <- min(bound, BoxCox(1, lambda))
  if (zero_to_one || (positive && decreasing)) { # Nedadgående trends i positive serier begrænses til ikke at skifte fortegn
    bound <- max(bound, BoxCox(0, lambda))
  }
  bound
}

first.monotone.suffix <- function(x, bound) {
  n <- length(x)
  monotone_from <- if (bound < x[1]) {
    vapply(seq_along(x), \(i) all(x[i:n] == cummin(x[i:n])), TRUE)
  } else {
    vapply(seq_along(x), \(i) all(x[i:n] == cummax(x[i:n])), TRUE)
  }
  which(monotone_from)[1]
}

bend.forecast <- function(x, bound) {
  if (bound == x[1]) return(x)
  
  # Keep short-run ARIMA adjustment, and bend only once the path moves monotonically towards the bound.
  bend_start <- first.monotone.suffix(x, bound)
  suffix <- x[bend_start:length(x)]
  if (suffix[1] != bound) {
    x[bend_start:length(x)] <- bound + (suffix[1] - bound) *
      exp((suffix - bound) / (suffix[1] - bound) - 1)
  }
  x
}

forecast.fails.sanity <- function(forecast, transformed_forecast, transformed_data) {
  any(is.infinite(forecast)) ||
    any(is.na(forecast)) ||
    max(abs(diff(transformed_forecast))) > max(abs(diff(transformed_data))) ||
    abs(max(transformed_forecast) - min(transformed_forecast)) > abs(max(transformed_data) - min(transformed_data))
}

log.sanity.failure <- function(series.name) {
  if (is.null(series.name) || is.na(series.name)) return()
  
  log_file <- "sanity_check_log.txt"
  if (!file.exists(log_file)) file.create(log_file)
  
  log_data <- data.frame(Time = format(Sys.time(), "%Y-%m-%d %H:%M:%S"), Series = series.name)
  write.table(log_data, file = log_file, row.names = FALSE, col.names = !file.exists(log_file), 
              sep = "\t", append = TRUE, quote = FALSE)
  print(paste("Sanity check failed for series:", series.name, ". Series name logged in", log_file))
}

sanity.fallback.bound <- function(transformed_data, decreasing) {
  max_dif <- abs(max(transformed_data) - min(transformed_data))
  transformed_data[length(transformed_data)] + ifelse(decreasing, -max_dif, max_dif)
}

## Funktion til at afbøje trend således at denne asymptotisk går mod T perioders forecast
bend.trend <- function(forecast, arima, zero_to_one, horizon, check.sanity, series.name=NULL) {
  decreasing <- forecast[1] > tail(forecast, n=1)
  positive <- forecast[1] > 0
  T <- max(horizon, min.bend.trend)
  
  if (T==0){ # ingen afbøjning
    return(forecast)}
  
  transformed_forecast <- BoxCox(forecast, arima$lambda)
  transformed_data <- BoxCox(arima$x, arima$lambda) # for sanity check
  
  bound <- trend.bound(transformed_forecast, arima$lambda, zero_to_one, T, decreasing, positive)
  transformed_forecast <- bend.forecast(transformed_forecast, bound)
  forecast <- InvBoxCox(transformed_forecast, arima$lambda)
  
  if (forecast.fails.sanity(forecast, transformed_forecast, transformed_data)) {
    if (check.sanity) log.sanity.failure(series.name)
    
    if (!check.sanity) {
      bound <- sanity.fallback.bound(transformed_data, decreasing)
      transformed_forecast <- bend.forecast(transformed_forecast, bound)
      forecast <- InvBoxCox(transformed_forecast, arima$lambda)
    }
  }
  
  return(forecast)
}


## Funktion til at mikse forecast med og uden drift blødt givet AICc kriterie (sigmoid)
sigmoid <- function(x, gamma = 1) {1 / (1 + exp(-gamma * x))}

## Fremskriv vha. ARIMA objekt og returner tidsserie.
arima.forecast <- function(series.name, arima, check.sanity, drift.factor = 1) {
  if (arima$is.constant) {
    forecast <- ts(arima$drift$x[[length(arima$drift$x)]], start = t.forecast.start, end = t.end)
    return(forecast)
  }
  
  # var_name <- get_variable_name(series.name)
  
  if ("drift" %in% names(arima$drift$coef)){
    # forecast with and without drift 
    forecast_drift <- forecast(arima$drift_forecast, h = forecast.periods)$mean %>% as.numeric()
    forecast_nodrift <- forecast(arima$nodrift_forecast, h = forecast.periods)$mean %>% as.numeric()
    
    # Sammenvej drift og ikke drift vha. sigmoid funktion over AICc kriterier;
    aicc_difference = arima$nodrift[["aicc"]] - arima$drift[["aicc"]]
    drift_weight <- sigmoid(aicc_difference)            
    
    # Tjek om forecast_drift er monoton. Hvis ikke-monoton, sæt drift_weight = 0.
    forecast_drift_slice = forecast_drift[t.monotonicity.check:length(forecast_drift)]
    always_increasing <- all(forecast_drift_slice == cummax(forecast_drift_slice))
    always_decreasing <- all(forecast_drift_slice == cummin(forecast_drift_slice))
    if(!(always_increasing || always_decreasing)){
      drift_weight = 0.0
    }
    
    # Afbøj trends (skal gøres særskilt da vægtet gennemsnit ikke altid er monotont)
    forecast_drift <- bend.trend(forecast_drift, arima$drift_forecast, all.zero_to_one[[series.name]][["value"]]==1, all.horizon[[series.name]][["value"]],check.sanity,series.name)
    forecast_nodrift <- bend.trend(forecast_nodrift, arima$nodrift_forecast, all.zero_to_one[[series.name]][["value"]]==1, all.horizon[[series.name]][["value"]],check.sanity,series.name)
    
    # Kombiner drift og ikke drift
    forecast = drift_weight * forecast_drift + (1-drift_weight) * forecast_nodrift    
  }
  else {
    forecast <- forecast(arima$drift_forecast, h = forecast.periods)$mean %>% as.numeric()
    forecast <- bend.trend(forecast, arima$drift_forecast, all.zero_to_one[[series.name]][["value"]]==1, all.horizon[[series.name]][["value"]],check.sanity,series.name)
  }  
  
  forecast <- ts(forecast, start = t.forecast.start, end = t.end)
  
  return(forecast)
}

## -------------------- Main --------------------
## Læs data fra GAMS 
input <- Container$new(input.path)
# Indlæs indstillinger fra GAMS
t.data.start <- input["ARIMA_start"]$records$value
t.end <- input["terminal_year"]$records$value
t.data.end <- input["ARIMA_end"]$records$value

q0 <- input["q0"]$records[[1]] |> as.character()
d0 <- input["d0"]$records[[1]] |> as.character()

t.forecast.start <- t.data.end + 1
t.forecast <- t.forecast.start:t.end
forecast.periods <- length(t.forecast)

t.monotonicity.check = 10 # tjek monotoni i drift forecast efter periode 10

## Indlæs evt. start-year for data anvendt i ARIMA fit
all.ARIMA_start <- map(
  input$listParameters()[grep('ARIMA_start', input$listParameters())],
  \(x) get_param(x, input)
) |>
  list_flatten()
all.ARIMA_start <- all.ARIMA_start[names(all.ARIMA_start) != "ARIMA_start"]
names(all.ARIMA_start) <- gsub("_ARIMA_start", "", names(all.ARIMA_start))

## Indlæs zero to one flag
all.zero_to_one <- map(
  input$listParameters()[grep('zero_to_one', input$listParameters())],
  \(x) get_param(x, input)
) |> 
  list_flatten()

## Indlæs evt. estimation end-year for data anvendt i ARIMA fit
all.ARIMA_estimation_end <- map(
  input$listParameters()[grep('ARIMA_estimation_end', input$listParameters())],
  \(x) get_param(x, input)
) |>
  list_flatten()
max.ARIMA_estimation_end <- max(map_dbl(all.ARIMA_estimation_end, \(x) as.numeric(x[["value"]])))
all.ARIMA_estimation_end <- all.ARIMA_estimation_end[names(all.ARIMA_estimation_end) != "ARIMA_estimation_end"]
names(all.ARIMA_estimation_end) <- gsub("_ARIMA_estimation_end", "", names(all.ARIMA_estimation_end))

## Indlæs alle tidsserier fra GDX filen
## Data load end is allowed to exceed ARIMA_end when estimation_end does
t.data.load.end <- max(t.data.end, max.ARIMA_estimation_end)
all.series <- map(
  input$listVariables(),
  \(x) get_tss(x, input, start_year = t.data.start, end_year = t.data.load.end)
) |> 
  list_flatten()

## Indlæs forecasting horizons
all.horizon <- map(
  input$listParameters()[grep('horizon', input$listParameters())],
  \(x) get_param(x, input)
) |> 
  list_flatten()

## Code snippet for debugging
# series.name <- "uXy[xTot]"
# series <- all.series[[series.name]]
# arima <- fit.series(series.name, series)
# # all.series <- all.series[sample(names(all.series), 5)] # Set all.series to 5 random samples
# arimas <- mapply(fit.series, names(all.series), all.series) # Run without parallelization for debugging
# forecast_ <- arima.forecast(series.name, arima, check.sanity)
# forecasts <- mapply(arima.forecast, names(all.series), arimas, check.sanity) # Run without parallelization for debugging

## Fit ARIMAer til samtlige serier
clusterExport(cl, list("near", "fit.series", "constant.series", "clean.series", "get_variable_name","all.horizon", "all.ARIMA_start", "all.ARIMA_estimation_end", "t.data.end", "q0", "d0", "BoxCox.lambda", "gqtest", "auto.arima", "auto.arima.0", "auto.arima.1", "auto.arima.2", "sigmoid", "ci_match", "str_equal"))
arimas <- clusterMap(cl, fit.series, names(all.series), all.series)

## Fremskriv serier vha. ARIMAerne
clusterExport(cl, list(
  "arima.forecast", "t.forecast.start", "t.end", "t.monotonicity.check",
  "min.bend.trend", "%>%", "forecast", "forecast.periods", "all.zero_to_one",
  "BoxCox", "map", "bend.trend", "trend.bound", "first.monotone.suffix",
  "bend.forecast", "forecast.fails.sanity", "log.sanity.failure",
  "sanity.fallback.bound", "InvBoxCox", "check.sanity"
))
forecasts <- clusterMap(cl, arima.forecast, names(all.series), arimas, check.sanity)

## -------------------- Plot serier --------------------
plot.series <- function(name) {
  arima_drift <- arimas[[name]]$drift
  arima_nodrift <- arimas[[name]]$nodrift
  
  if (arimas[[name]]$is.constant) {
    return()
  }
  
  if ("drift" %in% names(arima_drift$coef)){
    color <- "red"
    drift_weight <- sigmoid(arima_nodrift[["aicc"]] - arima_drift[["aicc"]])
    same_except_drift <- substr(get_arima_description(arima_drift),1,12) == substr(get_arima_description(arima_nodrift),1,12)
    label <- paste(
      name,
      "\n", substr(get_arima_description(arima_nodrift),1,12), "drift_w=", round(drift_weight, 2)
    )
    if (!same_except_drift) {label <- paste(label, "\n", get_arima_description(arima_drift))}
  } else {
    color <- "blue"
    label <- paste(name, "\n", substr(get_arima_description(arima_drift),1,12))
  }
  
  data <- window(all.series[[name]], end = t.data.end)
  forecast <- forecasts[[name]]
  
  nodrift_forecast <- forecast::forecast(arimas[[name]]$nodrift_forecast, h = forecast.periods)$mean %>% as.numeric()
  drift_forecast <- forecast::forecast(arimas[[name]]$drift_forecast, h = forecast.periods)$mean %>% as.numeric()
  
  # var_name <- get_variable_name(name)
  
  bend_nodrift_forecast <- bend.trend(nodrift_forecast, arimas[[name]]$nodrift_forecast, all.zero_to_one[[name]][["value"]]==1, all.horizon[[name]][["value"]], check.sanity)
  bend_drift_forecast <- bend.trend(drift_forecast, arimas[[name]]$drift_forecast, all.zero_to_one[[name]][["value"]]==1, all.horizon[[name]][["value"]], check.sanity)
  
  ts.plot(
    data,
    
    # nodrift_forecast %>% ts(start = t.forecast.start, end = t.end),
    # drift_forecast %>% ts(start = t.forecast.start, end = t.end),
    
    bend_nodrift_forecast %>% ts(start = t.forecast.start, end = t.end),
    bend_drift_forecast %>% ts(start = t.forecast.start, end = t.end), 
    
    forecast,
    
    col = c(
      "black" # data
      # , "gray", "gray" # uden og med drift
      , "gray", "gray" # afbøjede trends
      , color # forecast
    ),
    lty = c(
      "solid" # data
      # , "dashed", "dashed" # uden og med drift
      , "solid", "solid" # afbøjede trends
      , "solid" # forecast
    ),
    main = label,
    xlim = c(t.data.start, plot.end)
  )
  abline(h=0)
}

if (TRUE) {
  library(modeltime)
  pdf(file=plot.path, width = 6, height = 6)
  par(mfrow=c(4,4))
  par(mar=c(2,2.25,1.5,1))
  par(cex.main = 0.75, cex.axis = 0.75)
  map(names(forecasts), plot.series)
  dev.off()
}

## -------------------- Eksporter fremskrivninger --------------------
all.series.history <- map(all.series, \(x) window(x, end = t.data.end))
output <- mapply(
  function(d, f) ts(c(d, f), start=start(d), frequency=frequency(d)),
  all.series.history, forecasts,
  SIMPLIFY = FALSE
)

# Læg alle tidsrækker i en liste af lister af tidsrækker, opdelt på variabelnavn
var_names <- lapply(names(output), get_variable_name)
un_var_names <- unique(var_names)
names(un_var_names) <- un_var_names
ms <- lapply(un_var_names, \(x) output[var_names == x])

output_gdx <- Container$new()
set_series(ms, input, output_gdx)

output_gdx$write(output.path)

print(Sys.time() - start.time)

# Check if sanity checking is enabled and if the log file exists, throw an error
if (check.sanity && file.exists(log_file) && file.info(log_file)$size > 0) {
  stop(paste("Sanity check failed",
             ". Check the log file:", log_file, "for details."))
}

