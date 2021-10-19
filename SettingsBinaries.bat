@echo off 

rem WARNING: This script is currently not in use, but is kept in repository
rem for eventual later use when CI is set up on the source control service.

rem More elaborated inference of binaries path, can be optionally included
rem in settings script.

echo.
echo ======================================== %~n0%~x0:


rem Preliminary values:
set BinariesContainingPathManual=%ScriptDir%..\codedoc_resources_manual
set BinariesContainingPathSharedDir=%ScriptDir%..\codedoc_resources_shareddir
rem set DoxygenVersionNuGet=1.8.14
rem set GraphvizVersionNuGet=2.38.0.2
set BinariesContainingPathRepository=%ScriptDir%
set BinariesSourceRepository=https://github.com/ajgorhoe/IGLib.workspace.doc.codedoc.git
set BinariesSourceSharedDir=%ScriptDir%\bin
set DeploymentBaseDir=%ScriptDir%\..\deployment\codedoc


rem For some modes, check whether resources are actually available and,
rem if not, change mode to the one for which resources are available:

if "%BinariesDeploymentMode%" EQU "none" (
  rem Go to section where verification is done (whether binaries are in the
  rem   path) and mode changed if necessary:
  GOTO ChangeModeToNone
)

set RelOrAbsPath=%BinariesContainingPathManual%\bin\doxygen\doxygen.exe
if "%BinariesDeploymentMode%" EQU "manual" (
  REM rem Test existence of a file doxygen.exe (but not a directory)
  REM at the agreed location:
  IF EXIST "%RelOrAbsPath%" (
    IF NOT EXIST "%RelOrAbsPath%/" (
      rem The file, but not directory, EXISTS, no need for changing mode:
	  GOTO AfterChangingModeConsidered
	)
  )
  echo.
  echo The file DOES NOT EXIST: "%RelOrAbsPath%".
  goto ChangeModeToNone
)

REM The current binaries retrieval mode should be OK, skipping after the block:
GOTO AfterChangingModeConsidered

:ChangeModeToNone
echo Changing binaries retrieval mode from %BinariesDeploymentMode% to none...
rem Check whether doxygen executable is in the path:
where doxygen.exe
IF %ERRORLEVEL% NEQ 0 (
  echo Doxygen binaries are NOT IN THE PATH.
  rem Reset ERRORLEVEL and change binaries retrieval mode to repository...
  ver > nul
  GOTO ChangeModeToRepository
) ELSE (
  SET BinariesDeploymentMode=none
  echo   ... mode changed to none.
  echo.
)
GOTO AfterChangingModeConsidered

:ChangeModeToRepository
echo Changing binaries retrieval mode from %BinariesDeploymentMode% to repository ...
SET BinariesDeploymentMode=repository
echo   ... done, mode changed to repository.
echo.
GOTO AfterChangingModeConsidered

:AfterChangingModeConsidered


echo.
echo Specifying PATH for: BinariesDeploymentMode = %BinariesDeploymentMode%...
echo.
IF "%BinariesDeploymentMode%" EQU "none" (
  goto SpecifyPathNone
)
IF "%BinariesDeploymentMode%" EQU "manual" (
  goto SpecifyPathManual
)
IF "%BinariesDeploymentMode%" EQU "repository" (
  goto SpecifyPathRepository
)
IF "%BinariesDeploymentMode%" EQU "nuget" (
  goto SpecifyPathNuget
)
IF "%BinariesDeploymentMode%" EQU "shareddir" (
  goto SpecifyPathSharedDir
)

:SpecifyPathNone
rem set PATH=%BinariesContainingPathSharedDir%\bin\doxygen;%BinariesContainingPathSharedDir%\bin\graphviz\bin;%PATH%
echo ... path specified, mode = none:
goto AfterPathSpecified

:SpecifyPathManual
set PATH=%BinariesContainingPathManual%\bin\doxygen;%BinariesContainingPathManual%\bin\graphviz\bin;%PATH%
echo ... path specified, mode = manual:
goto AfterPathSpecified

:SpecifyPathRepository
set PATH=%BinariesContainingPathRepository%\bin\doxygen;%BinariesContainingPathRepository%\bin\graphviz\bin;%PATH%
echo ... path specified, mode = repository:
goto AfterPathSpecified

:SpecifyPathNuget
set PATH=%BinariesContainingPathNuGet%\bin\Doxygen.%DoxygenVersionNuGet%\tools;%BinariesContainingPathNuGet%\bin\Graphviz.%GraphvizVersionNuGet%;%PATH%
echo ... path specified, mode = nuget:
goto AfterPathSpecified

:AfterPathSpecified



echo ERRORLEVEL: %ERRORLEVEL%
echo.
echo ======== End: %~n0%~x0
echo.

endlocal