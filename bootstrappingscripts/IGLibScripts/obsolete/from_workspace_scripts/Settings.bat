
@echo off
rem Sets locations of various scripts, etc.

set SettingsScript_GitModule=%~dp0\Settings_GitModule.bat
set PrintSettingsScript_GitModule=%~dp0\PrintSettings_GitModule.bat

set GitUpdateModuleScript=%~dp0\UpdateModule.bat

rem Whether to output settings after utility scripts are run (0/1):
set PrintSettingsInScripts=1

