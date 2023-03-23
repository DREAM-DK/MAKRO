rem --------------------------------------------------------------------------------------------------------------------
rem CHANGE THESE!
rem --------------------------------------------------------------------------------------------------------------------
rem Adapt the paths below to your local environment
set GAMSDIR=C:\GAMS\40

rem R is used for fitting ARIMAs in the calibration process, but is not neccessary for running shocks
set R=C:\"Program Files"\R\R-4.2.1\bin\R.exe

rem --------------------------------------------------------------------------------------------------------------------
rem DO NOT TOUCH THESE!
rem --------------------------------------------------------------------------------------------------------------------
rem These are set automatically based on the above
set gams=%GAMSDIR%\gams.exe
set python=%GAMSDIR%\GMSPython\python.exe
