@echo off 
rem Prints out variables used for generation of code documentation.
rem Called from from scripts. For stand alone verston call PrintLoaded.bat. 
rem Does not have side effects for caller.

setlocal

echo.
echo ======================================== %~n0%~x0:
echo Settings for generation of code documentation: 
echo.

rem Count arguments:
set NumArgs=0
for %%d in (%*) do set /A NumArgs+=1
echo Number of command-line arguments: %NumArgs%
if %NumArgs% GTR 0 (
	echo Script args:   %*
)
echo.
if %NumArgs% GEQ 1 (echo   Arg. 1: %1)
if %NumArgs% GEQ 2 (echo   Arg. 2: %2)
if %NumArgs% GEQ 3 (echo   Arg. 3: %3)
if %NumArgs% GEQ 4 (echo   Arg. 4: %4)
if %NumArgs% GEQ 5 (echo   ...)
echo.
echo Script paths (drom calling env.):
echo InitialDir:   %InitialDir%
echo ScriptDir:    %ScriptDir%
echo ScriptPath:   %ScriptPath%
echo.
echo Git info:
echo CurrentBranchName:    %CurrentBranchName%
echo NormalizedBranchName: %NormalizedBranchName%
echo CurrentCommitHash:    %CurrentCommitHash%
echo Shortened hash:       %ShortenedCommitHash%
echo.
echo Configuration parameters:
echo ConfigurationID:        %ConfigurationID%
echo IsSourcesIncluded:      %IsSourcesIncluded%
echo LaunchDoc:              %LaunchDoc%
echo.
echo Generation paths:
echo DocumentationBaseDir:   %DocumentationBaseDir%
echo DocumentationPath:      %DocumentationPath%
echo DocumentationIndexPath: %DocumentationIndexPath%
echo.
echo Configuration paths:
echo ConfigurationExtension:  %ConfigurationExtension%
echo ConfigurationFileName:   %ConfigurationFileName%
echo ConfigurationFilePath:   %ConfigurationFilePath%
echo.
echo Binaries deployment (for Doxygen and Graphviz):
echo BinariesDeploymentMode:   %BinariesDeploymentMode%
echo BinariesContainingPath:   %BinariesContainingPath%
echo BinariesSourceRepository: %BinariesSourceRepository%
echo BinariesSourceSharedDir:  %BinariesSourceSharedDir%
echo.

if %ERRORLEVEL% NEQ 0 goto Finalize
echo.
echo Checking executables in PATH (not necessarily used):
where doxygen.exe
echo where gvmap.exe:
where gvmap.exe
echo.
ver > nul

rem echo.
rem echo PATH: %PATH%
rem echo.

:Finalize
echo ERRORLEVEL: %ERRORLEVEL%
echo.
echo ======== End: %~n0%~x0
echo.

endlocal