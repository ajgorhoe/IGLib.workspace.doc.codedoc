echo off
rem Sets variables for code documentation.

rem Reset the error level:
ver > nul

set ScriptDir=%~dp0
set InitialDir=%CD%
set ScriptPath=%ScriptDir%%~n0%~x0
set ExeFile=%~n0%~x0
set ErrorMessage=


rem Set default values for generation parameters, if not defined by caller:
if not defined ConfigurationExtension set ConfigurationExtension=.dox
if not defined ConfigurationID        set ConfigurationID=test
if not defined IsSourcesIncluded      set IsSourcesIncluded=1
rem if not defined ConfigurationSubdir    set ConfigurationSubdir=.\
if not defined LaunchDoc              set LaunchDoc=1
if not defined DeployDoc              set DeployDoc=0
if not defined BinariesDeploymentMode set BinariesDeploymentMode=manual
if not defined RunWithinCiBuild       set RunWithinCiBuild=0
set DocumentationBaseDir=generated_with_sources

if %ERRORLEVEL% NEQ 0 (if not defined ErrorMessage (set ErrorMessage="Error in basic definitions." & echo. & echo FATAL ERROR: %ErrorMessage% & goto Finalize))


rem take into account script arguments:
set NumArgs=0
for %%d in (%*) do set /A NumArgs+=1

echo Arguments to %~n0%~x0: NumArgs=%NumArgs%
if %NumArgs% GEQ 1 (echo   Arg. 1: %1)
if %NumArgs% GEQ 2 (echo   Arg. 2: %2)
if %NumArgs% GEQ 3 (echo   Arg. 3: %3)
if %NumArgs% GEQ 4 (echo   Arg. 4: %4)
if %NumArgs% GEQ 5 (echo   Arg. 5: %5)
if %NumArgs% GEQ 6 (echo   Arg. 6: %6)

rem Settings specified by parameters override those set in other ways:
If %NumArgs% GEQ 1 (set ConfigurationID=%1) 
If %NumArgs% GEQ 2 (set IsSourcesIncluded=%2) 
If %NumArgs% GEQ 3 (set ConfigurationSubdir=%3) 
If %NumArgs% GEQ 4 (set LaunchDoc=%4)
If %NumArgs% GEQ 5 (set BinariesDeploymentMode=%5)
If %NumArgs% GEQ 6 (set DeployDoc=%6)
rem Possible values for BinariesDeploymentMode (how binaries are provided):
  rem none       - Doxygen and Graphviz are run from local  installation
  rem repository - from git repository
  rem nuget      - from a NuGet package


IF %RunWithinCiBuild% NEQ 0 (
  REM Scripts are run within a CI pipeline, apply CI-specific settings:
  SET LaunchDoc=0
  SET BinariesDeploymentMode=manual
  SET DeployDoc=0
)

if %ERRORLEVEL% NEQ 0 (if not defined ErrorMessage (set ErrorMessage="Error in argument interpretation." & echo. & echo FATAL ERROR: %ErrorMessage% & goto Finalize))

set BinariesContainingPathManual=%ScriptDir%..\manual\codedoc_resources_manual
set BinariesContainingPathSharedDir=%ScriptDir%..\..\codedoc_resources_shareddir
set DoxygenVersionNuGet=1.8.14
set GraphvizVersionNuGet=2.38.0.2
set BinariesSourceRepository=https://github.com/ajgorhoe/IGLib.workspace.codedoc_resources.git
set BinariesSourceSharedDir=%ScriptDir%\bin
set DeploymentBaseDir=%ScriptDir%\..\deployment\codedoc

set BinariesContainingPathRepository=%ScriptDir%..\codedoc_resources

set BinariesContainingPath=%BinariesContainingPathRepository%
set PATH=%BinariesContainingPath%\bin\doxygen;%BinariesContainingPath%\bin\graphviz\bin;%PATH%
echo ... path specified, mode = repository:
goto AfterPathSpecified

rem Placeholder for additional logic to specify binary paths, if necessary...

:AfterPathSpecified


IF %ERRORLEVEL% NEQ 0 (if not defined ErrorMessage (set ErrorMessage="Error in defining executable location." & echo. & echo ERROR: %ErrorMessage% & echo. ))

rem Normalization of boolean parameters:
if %IsSourcesIncluded% NEQ 0 (set IsSourcesIncluded=1) else (set IsSourcesIncluded=0)
if %LaunchDoc% NEQ 0 (set LaunchDoc=1) else (set LaunchDoc=0)
if %DeployDoc% NEQ 0 (set DeployDoc=1) else (set DeployDoc=0)


if %IsSourcesIncluded% NEQ 0 (
  set DocumentationBaseDir=generated_with_sources
) else (
  set DocumentationBaseDir=generated
)

set ConfigurationFileName=%ConfigurationSubdir%%ConfigurationID%%ConfigurationExtension%
set ConfigurationFilePath=%ScriptDir%%ConfigurationFileName%
set DocumentationPath=%ScriptDir%%DocumentationBaseDir%\%ConfigurationID%
set DocumentationIndexPath=%DocumentationPath%\html\index.html

if %ERRORLEVEL% NEQ 0 (if not defined ErrorMessage (set ErrorMessage="Error after defining paths." & echo. & echo ERROR: %ErrorMessage% & echo. ))

echo.
echo Getting info from Git...
echo Executing:
echo   %ScriptDir%\SettingsGit.bat
call %ScriptDir%\SettingsGit.bat

rem Old deployment directories:
set DeploymentSubdir=%NormalizedBranchName%#%ShortenedCommitHash%
set DeploymentDir=%DeploymentBaseDir%\%DeploymentSubdir%
rem New deployment directories:
set DeploymentSubdirHead=%NormalizedBranchName%\head
set DeploymentSubdirCommit=%NormalizedBranchName%\commits\%ShortenedCommitHash%
set DeploymentDirHead=%DeploymentBaseDir%\%DeploymentSubdirHead%
set DeploymentDirCommit=%DeploymentBaseDir%\%DeploymentSubdirCommit%

if %ERRORLEVEL% NEQ 0 (if not defined ErrorMessage (set ErrorMessage="Error after defining deployment parameters." & echo. & echo ERROR: %ErrorMessage% & echo. ))

rem Placeholder: Set specific settings:
rem call "%ScriptDir%SettingsSpecific.bat"

:NextStatement


:EndOfScript


:Finalize
if %ERRORLEVEL% NEQ 0 (
  echo.
  echo An ERROR occurred in %~n0%~x0:
  echo   ERRORLEVEL = %ERRORLEVEL%
  echo   Error message: %ErrorMessage%
  echo.
)
echo.
echo Configuration variables for code documentation have been set.
echo.
echo.
