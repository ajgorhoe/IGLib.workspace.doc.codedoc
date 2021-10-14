@echo off 
rem Stores some Git related info in env. variables.

rem echo.
rem echo ======================================== %~n0%~x0:

rem Storing git info for the checked out repository in variables...

for /f "tokens=*" %%g in ('git rev-parse --abbrev-ref HEAD') DO (set CurrentBranchName=%%g)

IF %ERRORLEVEL% NEQ 0 (if not defined ErrorMessage (set ErrorMessage="Error in obtaining current branch name." & echo. & echo ERROR: %ErrorMessage% & echo. ))

for /f "tokens=*" %%g in ('git rev-parse HEAD') DO (set CurrentCommitHash=%%g)
set ShortenedCommitHash=%CurrentCommitHash:~0,8%

IF %ERRORLEVEL% NEQ 0 (if not defined ErrorMessage (set ErrorMessage="Error in obtaining commit hash." & echo. & echo ERROR: %ErrorMessage% & echo. ))

rem replace unwanted characters in branch name:
set NormalizedBranchName=%NormalizedBranchName:"=_%
set NormalizedBranchName=%NormalizedBranchName:(=_%
set NormalizedBranchName=%NormalizedBranchName:)=_%
set NormalizedBranchName=%NormalizedBranchName:/=.%

IF %ERRORLEVEL% NEQ 0 (if not defined ErrorMessage (set ErrorMessage="Error in normalizing branch name." & echo. & echo ERROR: %ErrorMessage% & echo. ))

if 0 NEQ 0 (
    echo.
	echo Git info:
	echo CurrentBranchName: 
	echo   %CurrentBranchName%
	echo NormalizedBranchName: 
	echo   %NormalizedBranchName%
	echo CurrentCommitHash:
	echo   %CurrentCommitHash%
	echo Shortened commit hash:
	echo   %ShortenedCommitHash%
	echo.
)

if 0 NEQ 0 (
    echo.
	echo Current branch name: 
	git rev-parse --abbrev-ref HEAD
	echo Current commit hash:
	git rev-parse HEAD
	echo Shortened commit hash:
	rem Use single % character when run from console.
	git log --pretty=format:"%%h" -n 1
	echo.
)

:Finalize
rem echo ======== End: %~n0%~x0
rem echo.
IF %ERRORLEVEL% NEQ 0 (
  echo.
  echo An ERROR occurred in %~n0%~x0:
  echo   ERRORLEVEL = %ERRORLEVEL%
  echo   Error message: %ErrorMessage%
  echo.
)
