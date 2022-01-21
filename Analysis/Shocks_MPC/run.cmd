:: Set paths to programs
call ..\..\paths.cmd
IF %ERRORLEVEL% NEQ 0 GOTO pathsNotFound

:: gamY is a python script. We use the python installation that comes with GAMS.
set gamY=call %python% ..\..\gamY\gamY.py 

goto start
:start

:: Denne kode skal køres til MARGINAL PROPENSITY TO CONSUME
%gamY%  pShocks_MPC.gms r=..\..\Model\Savepoints\model
IF %ERRORLEVEL% NEQ 0 GOTO errorHandling
rem goto end

:: Denne kode skal køres til ANALYSE AF STØD TIL PENSIONSINDBETALINGER
%gamY%  pShocks_Pension.gms r=..\..\Model\Savepoints\model
IF %ERRORLEVEL% NEQ 0 GOTO errorHandling

goto end

:pathsNotFound
ECHO ----------------------------------------------------------------------------------------------------
ECHO ERROR  -  paths.cmd not found
ECHO Run get_ini_and_paths_templates.cmd in main folder and adapt paths.cmd and gekko.ini to your local settings
ECHO ----------------------------------------------------------------------------------------------------

:errorHandling

:end
:: Clean up temp files and folders
:: Del "tmp_gmx_*"
for /d %%i in (225*) do rd /s /q "%%~i"


