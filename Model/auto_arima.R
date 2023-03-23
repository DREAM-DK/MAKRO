rm(list=ls())
start.time <- Sys.time()

## Installér pakker:
# install.packages("tidyverse")
# install.packages("forecast")
# install.packages("xts")
# install.packages("devtools")
# install.packages("modeltime")
# library("devtools")
# install_github("lolow/gdxtools")
# install.packages("parallel")

library(tidyverse)
library(forecast)
library(xts)
library(gdxtools)
library(lmtest)
library(parallel)

## -------------------- Indstillinger i estimationen --------------------
plot.end <- 2100 ## Sidste år i plot af fremskrivningen

plot.path <- "Gdx/StaticCalib_AutoArima_Mega.pdf"
output.path <- "Gdx/ARIMA_forecasts.gdx"
input.path <- "Gdx/ARIMA_forecast_input.gdx"

drift.periods <- 30  ## Væksthorisont for forsigtig fremskrivning med trends. Kan sættes til Inf hvis trends ikke skal afbøjes.
drift.factor <- 0.5 # Nedskalering af trends

num.cores <- detectCores()
cl <- makeCluster(num.cores-1)

## -------------------- Funktioner  --------------------
# Indlæs variabel fra GDX fil og returner en tidsserie pr unik set-kombination 
get.series <- function (variable.name, gdx) {
  v <- as_tibble(gdx[variable.name])
  v$t <- as.numeric(v$t)
  # Fjern værdier udenfor vores data-vindue
  v <- filter(v, t.data.start <= v$t & v$t <= t.data.end)

  # Lav named list med en timeseries for hver unik set-kombination
  time.series <- list()

  # Create series.name which combine set elements and symbol name, e.g. "sG_ym0[g,ser]"
  if (length(v) > 2) {
    sets <- v[1:(length(v)-2)]
    combined_sets <- do.call(paste, c(sets, sep=","))
    series.name <- paste(variable.name, "[", combined_sets, "]", sep="")

    for (s in unique(series.name)) {
      series <- v[which(series.name == s),]
      time.series[[s]] <-
        series %>%
        select(value) %>%
        ts(start = min(series$t), end = max(series$t))
    }
  } else {
    time.series[[variable.name]] <- ts(v$value, start = min(v$t), end = max(v$t))
  }

  return(time.series)
}

constant.series <- function (series.name, series) {
  # print(paste(series.name, "is constant"))
  list(x=series, is.constant=TRUE, series.name=series.name)
}

## Fit ARIMA til serie
fit.series <- function (series.name, series){
  last.observation <- series[length(series)]
  if (length(series) < 5 ||
      near(last.observation, series[length(series)-1]) ||
      near(last.observation, 0) || near(last.observation, 1)){
    return(constant.series(series.name, series))
  }

  # print(paste("Fitting ARIMA to", series.name))

  ## Fjern "falske observationer"
  series[1:length(series)-1][near(series, stats::lag(series, -1))] <- NA
  series[near(series, 0)] <- NA

  ## Vi bruger kun seneste række observationer uden NAer
  if (any(is.na(series))) series <- series[-1:-max(which(is.na(series)))]
  if (length(series) < 5) return(constant.series(series.name, series))

  ## Tillad drift med mindre variablen er på no.drift.allowed listen
  allowdrift = !(get.variable.name(series.name) %in% no.drift.allowed)

  ## Restriktér q eller d til 0 hvis variablen er i henholdsvis q0 og d0 listerne
  if (get.variable.name(series.name) %in% q0){max.q <- 0} else {max.q <- 1}
  if (get.variable.name(series.name) %in% d0){max.d <- 0} else {max.d <- 1}

  ## Valg af parameter til Box-Cox-transformation. 0=log, 1=lineær transformation (igen effekt)
  if (all(series > 0)){
    lambda <- BoxCox.lambda(series, lower=0, upper=1.2)
  } else {
    lambda = 1
  }

  ## Fit arima  
  ## Hvis der er negative autokorrelationer reducerer vi max.p og lader Auto ARIMA vælge en ny ARIMA
  max.p <- 2
  while (TRUE) {
    arima <- auto.arima(series, max.p = max.p,
      lambda=lambda, allowdrift=allowdrift, allowmean=TRUE, seasonal=FALSE, max.d=max.d, max.q=max.q, stepwise=FALSE,
    )
    p <- arima$arma[[1]]
    if (p == 0 | (all(arima$coef[1:p] > 0) & all(arima$coef[1:p] <= arima$coef[1]))){
      break
    } else {
      max.p <- p-1
    }
  }

  ## Gem andre informationer i arima objekt
  arima$series.name <- series.name
  arima$is.constant <- FALSE

  return(arima)
}

# # Funktion til at afbøje trend således at denne bliver flad efter T perioder
# bend.drift <- function(drift, t, T) {
#  t <- min(t, T)
#  return (drift.factor * drift * (t - t * (t + 1) * 0.5 / T))
# }

# Funktion til at afbøje trend således at denne assymptotisk går mod T perioders drift
bend.drift <- function(drift, t, T) {drift.factor * T * drift * t / (t + T)}

## Fremskriv vha. ARIMA objekt og returner tidsserie.
arima.forecast <- function(series.name, arima) {
  if (arima$is.constant) {
    forecast <- ts(arima$x[[length(arima$x)]], start = t.forecast.start, end = t.end)
    return(forecast)
  }
  
  forecast <- forecast(arima, h = forecast.periods)$mean %>% as.numeric()

  if ("drift" %in% names(arima$coef)){
    drift <- arima$coef[["drift"]]
  }
  else drift <- 0

  # if (drift.periods != Inf & drift != 0){
  if (drift.periods != Inf & drift != 0){
    ## Tilføj BoxCox transformation
    transformed <- BoxCox(forecast, arima$lambda)

    ## Fjern determininist trend
    trend <- seq(from = drift, by = drift, length = forecast.periods)
    detrended <- transformed - trend

    ## Aftrap trend
    trend <- map(1:forecast.periods, ~ bend.drift(drift, .x, drift.periods)) %>% as.numeric()

    ## Tilføj (modificeret) trend igen
    transformed <- detrended + trend

    # Fjern BoxCox transformation
    forecast <- InvBoxCox(transformed, arima$lambda)
  }

  ## Afbøj negative trends
  if (drift < 0){
    forecast <- forecast[1] * exp(forecast / forecast[1] - 1)
  }

  ## Afbøj positive trends hvis variablen ikke må overstige en
  if (get.variable.name(series.name) %in% zero.to.one & drift > 0){
    forecast <- 1 - (1-forecast[1]) * exp((1-forecast) / (1-forecast[1]) - 1)
  }

  forecast %>%
  ts(start = t.forecast.start, end = t.end) %>%
  return()
}

## Omdan tidsserie med langt[navn] til tibble som er kompatibel med GDX
series.to.dataframe <- function(name, series) {
  # Split series name into variable name and set elements
  identifiers <- strsplit(name, split="\\[|,|\\]")[[1]]
  elements <- identifiers[-1]

  # Get domain names from GDX file
  domnames = subset(input$variables, name == identifiers[1])$domnames[[1]]

  # Create dateframe with domain sets and series value
  df <- tibble(.rows=length(series))
  # df <- tibble(t = as.numeric(time(series)))
  if (length(elements)) {
    for (i in 1:length(elements)){
      df[domnames[i]] <- elements[i]
    }    
  }
  df$t <- as.numeric(time(series))
  df$value <- as.numeric(series)

  return(df)
}

## Uddrag variabel-navn fra langt[navn]
get.variable.name <- function(series.name) {
  toupper(strsplit(series.name, split="\\[|,|\\]")[[1]][1])
}

## Merge en liste af tidsserier sammen 
merge.series <- function(series) {
  variables <- list()
  for (series.name in names(series)) {
    name <- get.variable.name(series.name)
    variables[[name]] <- 
      rbind(if (name %in% names(variables)) variables[[name]], series.to.dataframe(series.name, series[[series.name]]))
  }
  return(variables)
}

## -------------------- Main --------------------
## Læs data fra GAMS 
if (length(Sys.getenv("GAMSDIR"))) {
  igdx(Sys.getenv("GAMSDIR"))
} else {
  igdx("C:\\GAMS\\40")
}
input <- gdx(input.path)

# Indlæs indstillinger fra GAMS
t.data.start <- input["ARIMA_start"]$value
t.end <- input["terminal_year"]$value
t.data.end <- input["ARIMA_end"]$value

no.drift.allowed <- input["no_drift_allowed"][[1]]
zero.to.one <- input["zero_to_one"][[1]]

q0 <- input["q0"][[1]]
d0 <- input["d0"][[1]]

# A bug in GAMS causes some set elements to be changed to upper case
no.drift.allowed <- c(no.drift.allowed, sapply(no.drift.allowed, toupper))
zero.to.one <- c(zero.to.one, sapply(zero.to.one, toupper))

q0 <- c(q0, sapply(q0, toupper))
d0 <- c(d0, sapply(d0, toupper))

t.forecast.start <- t.data.end + 1
t.forecast <- t.forecast.start:t.end
forecast.periods <- length(t.forecast)

## Indlæs alle tidsserier fra GDX filen
all.series <- flatten(map(input$variables$name, get.series, input))

## Fit ARIMAer til samtlige serier
clusterExport(cl, list("near", "fit.series", "constant.series", "get.variable.name", "no.drift.allowed", "q0", "d0", "BoxCox.lambda", "auto.arima")) 
arimas <- clusterMap(cl, fit.series, names(all.series), all.series, SIMPLIFY=FALSE)

names(arimas) <- names(all.series)

## Fremskriv serier vha. ARIMAerne
clusterExport(cl, list("arima.forecast", "t.forecast.start", "t.end", "%>%", "forecast", "forecast.periods", "drift.periods", "zero.to.one", "BoxCox", "map", "bend.drift", "drift.factor", "InvBoxCox")) 
forecasts <- clusterMap(cl, arima.forecast, names(arimas), arimas, SIMPLIFY=FALSE)
names(forecasts) <- names(all.series)

## -------------------- Plot serier --------------------
## only.drift kan sættes til TRUE for kun at plotte serier med drift
plot.series <- function(name, only.drift=FALSE) {
  arima <- arimas[[name]]
  
  if (arima$is.constant) return()

  if ("drift" %in% names(arima$coef)){
    color <- "red"
  } else if (only.drift) {
    return()
  } else {
    color <- "blue"
  }

  data <- all.series[[name]]
  forecast <- forecasts[[name]]
  ts.plot(
    data, forecast,
    col = c("black", color),
    main = paste(name, substr(get_arima_description(arima),1,12)),
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
write.gdx(output.path, vars_l=merge.series(forecasts))

print(Sys.time() - start.time)

