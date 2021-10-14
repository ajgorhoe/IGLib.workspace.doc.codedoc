@echo off 
rem Stores some Git related info in env. variables.

echo.
echo ======================================== %~n0%~x0:
echo.

rem Storing git info for the checked out repository in variables...

for /f "tokens=*" %%g in ('git rev-parse --abbrev-ref HEAD') DO (set CurrentBranchName=%%g)

for /f "tokens=*" %%g in ('git rev-parse HEAD') DO (set CurrentCommitHash=%%g)
set ShortenedCommitHash=%CurrentCommitHash:~0,8%

rem replace unwanted characters in branch name:
set NormalizedBranchName=%NormalizedBranchName:"=_%
set NormalizedBranchName=%NormalizedBranchName:(=_%
set NormalizedBranchName=%NormalizedBranchName:)=_%
set NormalizedBranchName=%NormalizedBranchName:/=.%

if 1 NEQ 0 (
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

echo ERRORLEVEL: %ERRORLEVEL%
echo.
echo ======== End: %~n0%~x0
echo.

endlocal