@echo off
rem Generates code documentation by Doxygen.
rem Configuration is read from from SettingsCodeDoc.bat. 

rem Start local context to prevent side effects:
setlocal
set ScriptDir=%~dp0
set StoredErrorLevel=0
rem Reset the error level:
ver > nul

rem Read configuration:
echo.
echo Setting configuration variables, calling: 
echo   "%ScriptDir%SettingsCodeDoc.bat" %*
echo
call "%ScriptDir%SettingsCodeDoc.bat" %*
rem Print configuration:
call "%ScriptDir%SettingsCodeDoc.bat"

if %ERRORLEVEL% NEQ 0 (if not defined ErrorMessage (set ErrorMessage="Error in reading settings." & echo. & echo FATAL ERROR: %ErrorMessage% & goto Finalize))

rem Clone the binaries repository if it does not exist:
if not exist "%BinariesContainingPathRepository%\.git\objects" (
  echo.
  echo Repository cloning directory does not exist.
  echo Cloning the repository...
  git.exe clone --progress -v "%BinariesSourceRepository%" "%BinariesContainingPathRepository%"
  echo   ... done.
) else (
  echo.
  echo Repository cloning directory exists.
  echo Updating contents using git pull...
  cd %BinariesContainingPathRepository%
  git.exe pull --progress -v --no-rebase "origin"
  cd %ScriptDir%
  echo   ... done.
)
echo.
echo ... binaries from repository available.
goto AfterBinariesRetrieved

rem Placeholder for more complex binary update schemes:
:AfterBinariesRetrieved


cd "%ScriptDir%%ConfigurationSubdir%"
REM Run gneration of code documentation with the appropriate configuration:
CALL doxygen "%ConfigurationFilePath%"
cd "%ScriptDir%"

IF %ERRORLEVEL% NEQ 0 (if not defined ErrorMessage (set ErrorMessage="Error in Doxygen generation process." & echo. & echo FATAL ERROR: %ErrorMessage% & goto Finalize))






if %StoredErrorLevel% NEQ 0 (
  set ERRORLEVEL=%StoredErrorLevel%
  echo An error occurred in %0:
  echo   StoredErrorLevel = %StoredErrorLevel%
  rem echo   ERRORLEVEL = %ERRORLEVEL%
  echo   Error message: %ErrorMessage%
  exit /b %StoredErrorLevel%
)

endlocal

