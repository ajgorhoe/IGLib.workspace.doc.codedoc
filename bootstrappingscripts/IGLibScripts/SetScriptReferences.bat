
@echo off

:: This script sets the variable that contain location of the IGLibScripts
:: dorectory and scripts contained in it that are essential for cloning
:: and updating module repositories.

:: The script is commonly used in bootstrapping.

set IGLibScripts=%~dp0
set UpdateRepo=%~dp0UpdateRepo.bat
set SetVar=%~dp0SetVar.bat
set PrintRepoSettings=%~dp0PrintRepoSettings.bat

set SetScriptReferences=%~dp0SetScriptReferences.bat
set PrintScriptReferences=%~dp0PrintScriptReferences.bat


