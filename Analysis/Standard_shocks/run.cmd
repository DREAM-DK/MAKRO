:: Set paths to programs
call ..\..\paths.cmd

:: gamY is a python script. We use the python installation that comes with GAMS.
set gamY=call %python% ..\..\gamY\gamY.py 

goto start
:start


:: Kopier baseline gdx til Gdx mappe
copy "..\..\Model\Gdx\baseline.gdx" "Gdx\baseline.gdx"

:: Her køres stødene
:: Permanente stød
%gamY%  standard_shocks.gms r=..\..\Model\Savepoints\baseline
IF %ERRORLEVEL% NEQ 0 GOTO end

:: Lav figurer og åben html-rapport med standard output
%python% plot_standard_shocks.py
Output\standard_shocks.html

%python% plot_shocks.py


:end
:: Clean up temp files and folders
:: Del "tmp_gmx_*"
for /d %%i in (225*) do rd /s /q "%%~i"


