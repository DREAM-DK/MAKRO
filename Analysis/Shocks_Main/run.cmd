:: Set paths to programs
call ..\..\paths.cmd

:: gamY is a python script. We use the python installation that comes with GAMS.
set gamY=call %python% ..\..\gamY\gamY.py 

goto start
:start

:: Her køres stødene
:: Permanente stød
%gamY%  pshocks_Main.gms r=..\..\Model\Savepoints\model
IF %ERRORLEVEL% NEQ 0 GOTO errorHandling

:: SVAR-stød
%gamY%  VARshocks.gms r=..\..\Model\Savepoints\model --IRF_path="..\..\Data\IRFs.gdx"
IF %ERRORLEVEL% NEQ 0 GOTO errorHandling
goto end


:errorHandling

:end
:: Clean up temp files and folders
:: Del "tmp_gmx_*"
for /d %%i in (225*) do rd /s /q "%%~i"


