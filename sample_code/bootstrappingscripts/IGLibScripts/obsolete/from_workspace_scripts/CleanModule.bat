
@echo off
setlocal

if defined ScriptDir (
  if "%ScriptDir%" NEQ "" (
    rem Store eventual directory of the calling script to use it in settings:
    set CallingScriptDir=%ScriptDir%
  )
)
set InitialDir = %CD%
set ScriptDir=%~dp0
set SettingsScriptName=Settings_UpdateModule.bat
set SettingsScript=%ScriptDir%%SettingsScriptName%
rem Reset error information (undefine aux. variables):
set StoredErrorLevel=
set ErrorMessage=

echo.
echo.
echo ====
echo.

rem Take into account command-line arguments:
if "%~1" NEQ "" (
  if defined ModuleDir (
    if "%ModuleDir%" NEQ "%~1%" (
      echo %0:
      echo ModuleDir overridden by command-line argument:
      echo   %ModuleDir%
      echo   replaced by:
      echo   %~1%
      echo.
	)
	echo Module directory not defined, set to arg. 1.
  )
  set ModuleDir=%~1
)

rem In  case ModuleDir is not defined, exit:
if not defined ModuleDir (
  echo.
  echo Module direcory NOT DEFINED, exiting...
  echo.
  set StoredErrorLevel=1
  set ErrorMessage=Module's directory is not defined.
  goto finalize
)

Rem Check existence of ModuleDir. If it does not exist, combine original
rem value with ScriptDir, if still not OK, with InitialDir:
set ModuleDirOriginalForm=%ModuleDir%
if not exist "%ModuleDir%" (
  echo.
  echo ModuleDir does not exist: 
  echo   "%ModuleDir%"
  echo Attempting to combine CallingScriptDir and ModuleDir ...
  set ModuleDir=%CallingScriptDir%\%ModuleDirOriginalForm%
)
if not exist "%ModuleDir%" (
  echo.
  echo ModuleDir does not exist: 
  echo   "%ModuleDir%"
  echo Attempting to combine InitialDir and ModuleDir ...
  set ModuleDir=%InitialDir%\%ModuleDirOriginalForm%
)

rem Do some additional verifications:
if not exist "%ModuleDir%" (
  echo.
  echo Module direcory DOES NOT EXIST, exiting:
  echo   "%ModuleDir%"
  echo.
  set StoredErrorLevel=1
  set ErrorMessage=Module's directory does not exist.
  goto finalize
)
set ModuleGitDir=%ModuleDir%\.git\
if not exist "%ModuleGitDir%" (
  echo.
  echo Module direcory NOT PROPER Git DIRECTORY, exiting:
  echo   "%ModuleDir%"
  echo.
  set StoredErrorLevel=1
  set ErrorMessage=Module's directory is not a Git directory.
  goto finalize
)

echo CLEANING Module directory (removing untracked files and dirs):
echo   "%ModuleDir%"
echo Executing:
echo   git clean -f -x -d

cd  "%ModuleDir%"
git clean -f -x -d
cd "%InitialDir%"


:finalize

rem Output the settings used, if specified by env. variable:
if defined PrintSettingsInScripts (
  if %% NEQ 0 (
    echo.
    echo _____________________________________
    echo Module REMOVAL script - SETTINGS used:
    call %ScriptDir%PrintSettings_UpdateModule.bat %*
    echo _____________________________________
    echo.
  )
)

rem Error reporting:
set IsDefinedStoredErrorLevel=0

if defined StoredErrorLevel (
  if "%StoredErrorLevel%" NEQ 0 (
	set ERRORLEVEL=%StoredErrorLevel%
	set IsDefinedStoredErrorLevel=1
  ) else (
    rem Undefine if 0
    set StoredErrorLevel=
  )
)

if %ERRORLEVEL% EQU 0 (
  echo Remove module completed successfully.
) else (
  echo.
  echo An ERROR occurred in %0:
  if %IsDefinedStoredErrorLevel% NEQ 0 (
    echo   StoredErrorLevel = %StoredErrorLevel%
  ) else (
    echo ERRORLEVEL: %ERRORLEVEL%
  )
  if defined ErrorMessage (
    if "%ErrorMessage%" NEQ "" (
      echo   Error message: %ErrorMessage%
	)
  )
  echo.
  if %IsDefinedStoredErrorLevel% NEQ 0 (
    rem Also properly propagate error level to the calling environment:
	endlocal 
    exit /b %StoredErrorLevel%
  )
)

echo Finished module cleanup:
echo   "%ModuleDir%"
echo --------------------

rem restore current directory and environment to state before the call:
cd %InitialDir%
endlocal



