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


echo.
echo Removing code documentation from generated/ ...
rem echo Directories to be removed:
rem FOR /D %%d IN ("%~dp0\generated\*") DO echo   "%%d" 
echo Executing:
echo   FOR /D %%d IN ("%~dp0\generated\*") DO rmdir /s /q "%%d" 
FOR /D %%d IN ("%~dp0\generated\*") DO rmdir /s /q "%%d" 
echo   ... removal from generated/ done.
echo.


echo.
echo Removing code documentation from generated_with_sources/ ...
rem echo Directories to be removed:
rem FOR /D %%d IN ("%~dp0\generated\*") DO echo   "%%d" 
echo Executing:
echo   FOR /D %%d IN ("%~dp0\generated_with_sources\*") DO rmdir /s /q "%%d" 
FOR /D %%d IN ("%~dp0\generated_with_sources\*") DO rmdir /s /q "%%d" 
echo   ... removal from generated_with_sources/ done.
echo.


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

