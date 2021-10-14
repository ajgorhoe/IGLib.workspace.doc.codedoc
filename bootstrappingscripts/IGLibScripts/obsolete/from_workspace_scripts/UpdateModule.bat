
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
echo.
echo ================================
if defined ModuleDirRelative (
  echo Updating module %ModuleDirRelative% ...
) else (
  echo Updating module ...
)
if defined ContainingDir (
  echo   in:     %ContainingDir%
)
if defined RepositoryAddress (
  echo   repo:   %RepositoryAddress%
)
if defined CheckoutBranch (
  echo   branch: %CheckoutBranch%
)
if defined ModuleDir (
  echo Module directory:
  echo   "%ModuleDir%"
)

echo Resolving parameters...
if not exist "%SettingsScript%" (
  echo.
  echo In %0:
  echo INVALID OPERATION: Settings script does not exist:
  echo   %SettingsScript%
  echo Please ensure that settings script is located in the same directory
  echo as the script!
  echo.
  set StoredErrorLevel=1
  set ErrorMessage=Settings script %SettingsScriptName% could not be located.
  set 
  goto finalize
)
echo Calling: 
echo   call "%SettingsScript%" %*
call "%SettingsScript%" %*

rem echo UPDATEMODULE After settings

rem Report errors when necessary parameters are not defined:
if %IsDefinedRepositoryAddress% EQU 0 (
  set StoredErrorLevel=1
  set ErrorMessage=Repository address is not defined.
  goto finalize
)
if %IsDefinedModuleDir% EQU 0 (
  set StoredErrorLevel=1
  set ErrorMessage=Module's working directory is not defined.
  goto finalize
)

rem echo UPDATEMODULE After missing definitions checks



rem See e.g.:
rem https://stackoverflow.com/questions/10312521/how-to-fetch-all-git-branches

cd %ScriptDir%

echo.
echo Initializing scripts/ directory...
echo   at: %ScriptDir%
echo.

rem echo UPDATEMODULE Before cloning block


rem To reset error level if set:
ver > nul
if not exist "%ModuleDir%\.git" (
  if exist "%ModuleDir%" (
    echo.
    echo warning: directory already exists: 
	echo   %moduledir%
	echo operation may fail and you may need to remove the following dir.:
	echo   %moduledir%
	echo.
  )
  echo Repository not yet checked out, cloning the code...
  call git clone %RepositoryAddress% %ModuleDir%
  if %ERRORLEVEL% NEQ 0 (
    set StoredErrorLevel=1
	set ErrorMessage=Could not clone the repository.
  )
  call git remote add origin %RepositoryAddress%
  echo.
)

rem echo UPDATEMODULE After cloning block


ver > nul
cd %ModuleDir%
if %ERRORLEVEL% NEQ 0 (
    set StoredErrorLevel=1
	if not defined ErrorMessage (
	  set ErrorMessage=Could not clone the repository.
	)
	goto finalize
)



call git fetch --all
if %ERRORLEVEL% NEQ 0 (
  set StoredErrorLevel=1  
  if not defined ErrorMessage (
	set ErrorMessage=Fetching from repository failed.
  )
)
  
rem echo UPDATEMODULE After fetch
  
  
  ver > nul
  rem ?? Is this necessary - do we want this?
  call git pull --all
  ver > nul
  
rem echo UPDATEMODULE After pull
  
  
if %IsDefinedCheckoutBranch% NEQ 0 (
  call git checkout --track origin/%CheckoutBranch%
  ver > nul
  
  rem echo UPDATEMODULE After checkout branch with --track
  
  call git checkout %CheckoutBranch%
  ver > nul
  
  rem echo UPDATEMODULE After plain checkout branch (no ref. to origin)
  
  call git pull origin %CheckoutBranch%
  
  rem echo UPDATEMODULE After pull origin  branch
  
  if %ERRORLEVEL% NEQ 0 (
    set StoredErrorLevel=1  
	if not defined ErrorMessage (
	  set ErrorMessage=Pulling remote branch %CheckoutBranch% failed.
	)
  )
)

rem echo UPDATEMODULE After checkout block




:finalize

rem Output the settings used, if specified by env. variable:
if defined PrintSettingsInScripts (
  if %% NEQ 0 (
    echo.
    echo _____________________________________
    echo Module update script - SETTINGS used:
    call %ScriptDir%PrintSettings_UpdateModule.bat %*
    echo _____________________________________
    echo.
  )
)

rem restore current directory and environment to state before the call:
cd %InitialDir%
endlocal

rem Error reporting:
set IsDefinedStoredErrorLevel=0
if defined StoredErrorLevel (
  if %StoredErrorLevel% NEQ 0 (
	set ERRORLEVEL=%StoredErrorLevel%
	set IsDefinedStoredErrorLevel=1
  ) else (
    rem Undefine if 0:
    set StoredErrorLevel=
  )
)
if %ERRORLEVEL% EQU 0 (
  echo Updating module completed successfully.
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
    exit /b %StoredErrorLevel%
  )
)



