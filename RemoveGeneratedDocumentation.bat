@echo off
rem Removes the generated code documentaton.

rem Prevent side effects:
setlocal

rem Reset error level:
ver > nul
echo.
echo ======================================== %~n0%~x0:

rem Set some script related variables.
set ScriptDir=%~dp0
SET InitialDir=%CD%

rem FOR /D %%p IN ("%~dp0\generated\*") DO rmdir "%%p" /s /q

echo.
echo Removing code documentation from generated/ ...
echo Directories to be removed:
FOR /D %%d IN ("%~dp0\generated\*") DO echo   "%%d" 
echo Executing:
echo   FOR /D %%d IN ("%~dp0\generated\*") DO rmdir /s /q "%%d" 
FOR /D %%d IN ("%~dp0\generated\*") DO rmdir /s /q "%%d" 
echo   ... removal from generated/ done.
echo.


REM echo Removing code documentation from generated/ ...
REM echo Executing:
REM echo   rd /s /q "%~dp0\generated\te*\"
REM rd /s /q "%~dp0\*"
REM echo   ... done.


echo Removing specific directory - generated/teest/ :
echo   rd /s /q "%~dp0\generated\test"
echo EXCLUDED.
rem rd /s /q "%~dp0\generated\test"
echo   ... done.


:Finalize
IF %ERRORLEVEL% NEQ 0 (
  echo.
  echo An error occurred in %0:
  echo   ERRORLEVEL = %ERRORLEVEL%
  echo   Error message: %ErrorMessage%
  echo.
)
echo.
echo ======== End: %~n0%~x0
echo.
rem End local contect for env. variables:
endlocal

