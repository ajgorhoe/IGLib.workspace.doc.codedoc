@echo off 
rem Prints out some Git related info.

setlocal

echo.
echo ======================================== %~n0%~x0:
echo Git environment: 
echo.

echo.
if 1 NEQ 10(
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