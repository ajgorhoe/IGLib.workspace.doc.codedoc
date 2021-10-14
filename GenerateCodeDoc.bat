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
call "%ScriptDir%SettingsCodeDoc.bat" %*

IF %ERRORLEVEL% NEQ 0 (if not defined ErrorMessage (set ErrorMessage="Error in reading settings." & echo. & echo FATAL ERROR: %ErrorMessage% & goto Finalize))





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

