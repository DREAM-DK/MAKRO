:: Set paths to programs
call ..\paths.cmd

:: gamY can be run as an executable or as a Python script
set gamY=call %python% ..\gamY\gamY.py

:: Settings
%gamY%  settings.gms s=Savepoints\settings
IF %ERRORLEVEL% NEQ 0 GOTO end

:: Import sets
%gamY%  sets.gms r=Savepoints\settings s=Savepoints\sets
IF %ERRORLEVEL% NEQ 0 GOTO errorHandling

:: Import data
%gamY%  data.gms r=Savepoints\sets s=Savepoints\data
IF %ERRORLEVEL% NEQ 0 GOTO errorHandling

:: Model calibration
%gamY%  model.gms r=Savepoints\data s=Savepoints\model
IF %ERRORLEVEL% NEQ 0 GOTO errorHandling

:end
:: Clean up temp files and folders
:: Del "tmp_gmx_*"
for /d %%i in (225*) do rd /s /q "%%~i"


