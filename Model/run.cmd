:: Set paths to programs
call ..\paths.cmd
IF %ERRORLEVEL% NEQ 0 GOTO end

:: gamY is a python script. We use the python installation that comes with GAMS.
set gamY=call %python% ..\gamY\gamY.py 

:: Install python modules in python installation that comes with GAMS
rem curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
rem %python% get-pip.py
rem %GAMSDIR%\GMSPython\Scripts\pip install numpy scipy==1.8.1 statsmodels xlwings dream-tools plotly kaleido==0.1.0.post1 xhtml2pdf

:: SETTINGS
%gamY%  settings.gms s=Savepoints\settings
IF %ERRORLEVEL% NEQ 0 GOTO end
goto start
:start

:: Import sets
%gamY%  sets.gms r=Savepoints\settings s=Savepoints\sets
IF %ERRORLEVEL% NEQ 0 GOTO end

:: Model calibration
%gamY%  variables.gms r=Savepoints\sets s=Savepoints\variables
IF %ERRORLEVEL% NEQ 0 GOTO end

%gamY%  equations.gms r=Savepoints\variables s=Savepoints\equations
IF %ERRORLEVEL% NEQ 0 GOTO end

rem %gamY%  exogenous_values.gms r=Savepoints\equations s=Savepoints\exogenous_values
rem IF %ERRORLEVEL% NEQ 0 GOTO end

rem %gamY%  static_calibration.gms r=Savepoints\exogenous_values s=Savepoints\static_calibration
rem IF %ERRORLEVEL% NEQ 0 GOTO end

rem :: Skip the R program to not fit new arimas
rem %R% --vanilla --file=auto_arima.R
rem IF %ERRORLEVEL% NEQ 0 GOTO end

rem %gamY%  exogenous_forecasts.gms r=Savepoints\static_calibration s=Savepoints\exogenous_forecasts
rem IF %ERRORLEVEL% NEQ 0 GOTO end

rem %gamY%  deep_dynamic_calibration.gms r=Savepoints\exogenous_forecasts s=Savepoints\deep_dynamic_calibration
rem IF %ERRORLEVEL% NEQ 0 GOTO end

rem %gamY%  smoothed_parameters_calibration.gms r=Savepoints\deep_dynamic_calibration s=Savepoints\smoothed_parameters_calibration
rem IF %ERRORLEVEL% NEQ 0 GOTO end

rem %python% ..\Analysis\Baseline\baseline.py
rem ..\Analysis\Baseline\Output\baseline.html

rem %gamY%  calibration_2018.gms r=Savepoints\static_calibration s=Savepoints\calibration_2018
rem IF %ERRORLEVEL% NEQ 0 GOTO end

rem %gamY%  calibration_2019.gms r=Savepoints\static_calibration s=Savepoints\calibration_2019
rem IF %ERRORLEVEL% NEQ 0 GOTO end

rem %gamY%  calibration_2020.gms r=Savepoints\static_calibration s=Savepoints\calibration_2020
rem IF %ERRORLEVEL% NEQ 0 GOTO end

rem %gamY%  calibration_2021.gms r=Savepoints\static_calibration s=Savepoints\calibration_2021
rem IF %ERRORLEVEL% NEQ 0 GOTO end

rem %gamY%  remove_data.gms r=Savepoints\calibration_2021
rem IF %ERRORLEVEL% NEQ 0 GOTO end

%gamY%  baseline.gms r=Savepoints\equations s=Savepoints\baseline
IF %ERRORLEVEL% NEQ 0 GOTO end

:end
:: Clean up temp files and folders
:: Del "tmp_gmx_*"
for /d %%i in (225*) do rd /s /q "%%~i"
