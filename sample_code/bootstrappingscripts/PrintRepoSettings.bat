
@echo off
setlocal

:: Prints values of environment variables that are used for updating 
:: repositories, e.g. by the script UpdateREpo.bat .
:: Execution of the script does not have any siide effect such as setting 
:: on changing variables in the calling environment (executiion block is 
:: enclosed in setloca / endlocal calls).

:: BEFORE printing the values, this script treats eventual parameters as 
:: another command with parameters and executes that command. This adds 
:: the possibility to run the setting script before printing variable 
:: values. This is done in a single command line, and combination of 
:: scripts does not have side effects.

:: Reset the error level (by running an always successfull command):
ver > nul
:: Base directories:

if "%~1" EQU "" goto AfterCommandCall
	:: If any command-line arguments were specified then assemble a 
	:: command-line from these arguments and execute it:

	:: Assemble command-line from the remaining arguments....
	set CommandLine6945="%~1"
	:loop
	shift
	if [%1]==[] goto afterloop
	set CommandLine6945=%CommandLine6945% "%~1"
	goto loop
	:afterloop

	:: Call the assembled command-line:
	call %CommandLine6945%
:AfterCommandCall

echo.
echo Parameters for repository update:
echo.
echo ModuleDirRelative: "%ModuleDirRelative%"
echo ModuleDir:         "%ModuleDir%"
echo CheckoutBranch:    "%CheckoutBranch%"
echo Remote:            "%Remote%"
echo RemoteSecondary:   "%RemoteSecondary%"
echo RemoteLocal:       "%RemoteLocal%"
echo.
echo RepositoryAddress: "%RepositoryAddress%"
echo RepositoryAddressSecondary: "%RepositoryAddressSecondary%"
echo RepositoryAddressLocal: "%RepositoryAddressLocal%"
echo.
echo ModuleGitSubdir: "%ModuleGitSubdir%"
echo.

:finalize
ver > nul

endlocal

