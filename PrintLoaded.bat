@echo off
rem Loads settings for generation of code documentation and prints 
rem them. 
rem Used for testing only; has no side effects.

rem Prevent side effects:
setlocal

rem Reset error level:
ver > nul
echo.
echo ======================================== %~n0%~x0:

rem Set some script related variables.
set ScriptDir=%~dp0
SET InitialDir=%CD%
IF DEFINED ExePath (SET ExePath) ELSE (set ExePath=%ScriptDir%%0)

IF %ERRORLEVEL% NEQ 0 (if not defined ErrorMessage (set ErrorMessage="Error in initialization part." & echo. & echo FATAL ERROR: %ErrorMessage% & goto Finalize))


echo.
echo from PrintLoaded.bat:
echo.
echo ScriptDir: %ScriptDir%
echo ExePath:   %ExePath%
echo.

echo.
Echo Calling command: call "%ScriptDir%SettingsCodeDoc.bat" %*
call "%ScriptDir%SettingsCodeDoc.bat" %*
echo.

IF %ERRORLEVEL% NEQ 0 (if not defined ErrorMessage (set ErrorMessage="Error after loading settings." & echo. & echo ERROR: %ErrorMessage% & echo. ))

echo.
call "%ScriptDir%PrintSettings" %*
echo.

IF %ERRORLEVEL% NEQ 0 (if not defined ErrorMessage (set ErrorMessage="Error in printing settings." & echo. & echo ERROR: %ErrorMessage% & echo. ))

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

