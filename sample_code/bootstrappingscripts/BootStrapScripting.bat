
@echo off

:: Prepares environment for execution of repository updating scripts.

echo.
echo BootStrapScripting.bat:
echo   bootstrapping essential scripts...
echo.
echo Obtaining bootstrapping script repository settins...

:: Define initially script locations for bootstrapping:
set BootstrapSettings=%~dp0\SettingsIGLibScriptsBootstrap.bat
set UpdateRepo=%~dp0\UpdateRepo.bat
set SetVar=%~dp0\SetVar.bat
set PrintRepoSettings=%~dp0\PrintRepoSettings.bat

REM if 1 NEQ 0 (
  REM echo.
  REM echo Initial script paths:
  REM echo BootstrapSettings: "%BootstrapSettings%"
  REM echo UpdateRepo: "%UpdateRepo%"
  REM echo SetVar: "%SetVar%"
  REM echo PrintRepoSettings: "%PrintRepoSettings%"
REM )

:: Obtain for IGLibScripting repository for bootstrapping:
:: call "%~dp0\SettingsIGLibScriptsBootstrap.bat"
call "%BootstrapSettings%"

:: Derived variable - already defined in settings::
set ModuleGitSubdir=%ModuleDir%\.git\refs

REM :: Print settings for bootstrapping IGLib repo:
REM call "%PrintRepoSettings%"

set BootstrapRepoUpdated=0
if exist "%ModuleGitSubdir%" goto :SkipUpdate
  :: The IGLibScripts for bootstrapping not yet properly cloned, 
  :: perform repo update (cloning):
  call "%UpdateRepo%" "%BootstrapSettings%"
  set BootstrapRepoUpdated=1
:SkipUpdate


if not exist "%ModuleGitSubdir%" goto ErrorScriptRepo
  rem Update script locations to point intto IGLibScripts
  rem by calling SetScriptReferences.bat in IGLibScripts:
  call "%ModuleDir%\SetScriptReferences.bat"
  rem call "%PrintScriptReferences%"
  goto AfterScriptReferencesUpdate
:ErrorScriptRepo
  echo.
  echo ERROR in BOOTSTRAPPING scripts:
  echo   IGLibScripts module could not be cloned.
  echo   Fallback to bootstrapping scripts; may not work properly.
  echo.
:AfterScriptReferencesUpdate



:finalize

echo.
echo   ... bootstrappping essential scripts completed.
echo.
