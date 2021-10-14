
@echo off

rem Example: cloning or updating module repositories.

rem Create a local context, such that the script will  have no side effects
rem (no environment variables modified or set in calling environment):
setlocal

rem Reset the error level (by running an always successfull command):
ver > nul

rem Set some auxiliary variables to point to relevant directories and 
rem scripts:
set ScriptContainingDir=%~dp0
set InitialDir=%CD%
set UpdateRepo=%ScriptContainingDir%\..\UpdateRepo.bat
set SetVar=%ScriptContainingDir%\..\SetVar.bat

echo.
echo Updating IGLib modules...
echo   ScriptContainingDir: %ScriptContainingDir%
echo   UpdateScript: %UpdateScript%
echo.

rem Update the repository according to settings in  
rem ExampleSettingsIGLibCore.bat :
call "%UpdateRepo%" "%ScriptContainingDir%\ExampleSettingsIGLibCore.bat"

rem Update the repository according to settings in  
rem ExampleSettingsIGLibScripts.bat , but with some modified parameters, 
rem such as diectory where repository is cloned (See further explanation below):
call "%UpdateRepo%" "%ScriptContainingDir%\ExampleSettingsIGLibScripts.bat" "%SetVar%" ModuleDir "%ScriptContainingDir%\scripts" "%SetVar%" RepositoryAddressSecondary https://ajgorhoe@bitbucket.org/ajgorhoe/iglib.modules.iglibscripts.git

rem How the above command works:
rem the UpdateRepo.bat script (whose path was stored in in variable 
rem UpdateRepo near top of the script) takes as parameter the setting
rem script that is execuded to set environment variables containiing 
rem the update parameters. If there are further parameters, these are
rem just passed to the setting script (ExampleSettingsIGLibScripts.bat
rem in this case). The trick is that the setting script is defined in
rem such a way that these remaining parameters are treated as embedded
rem command with its command-line parameters, which is executed after
rem the setting script sets its concrete parameters. This can be used for
rem overriding some parameters that define behavior of the UpdateRepo
rem script, provided that we know their names.

rem In the above case, overriding parameters was performed by using the
rem SetVar.bat script (whose path is was stored in the SetVar variable
rem for convenience). This script takes as parameters name of the
rem environment variable to be set and its value. In addition, the script 
rem is defined in such a way that eventual further parameters are again
rem interpreted as a new command with parameters, which is executed after
rem a specific variable is set.
rem In this way, we can chain calls to the SetVar.bat script after the rem script that sets update parameters, and commands ae called 
rem recursively. 
rem In the above case, we override values for the followiing parameters
rem from the ExampleSettingsIGLibScripts.bat script:
rem   ModuleDir, which specifies where the repository is cloned
rem   RepositoryAddress, which specifies address of the secondary 
rem     repository (to which remote named originSecondary is set via
rem     settings already defined in the settings script); this
rem     address was not specified in the original script. You can verify
rem     the effect of this change by checking the remotes defined on the
rem     cloned repository (without override there would be only one remote)


endlocal

