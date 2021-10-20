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

echo Removing code documentation from generated/ ...
echo Executing:
echo   rd /s /q "%~dp0\*"
rd /s /q "%~dp0\*"
echo   ... done.


echo Removing specific directory - generated/teest/ :
  echo   rd /s /q "%~dp0\test\"
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

