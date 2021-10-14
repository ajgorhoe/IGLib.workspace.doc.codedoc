
@echo off
setlocal

:: Prints values of environment variables that contain locations of the
:: IGLibScripts directory and some scripts that are used in cloning and
:: updating repositories. 

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
echo Variables containing locations of the IGLibScripts directory
echo and some relevant scripts:
echo.
echo   IGLibScripts: %IGLibScripts%
echo   UpdateRepo: %UpdateRepo%
echo   SetVar: %SetVar%
echo   PrintRepoSettings: %PrintRepoSettings%
echo.
echo   SetScriptReferences: %SetScriptReferences%
echo   PrintScriptReferences: %PrintScriptReferences%
echo.

:finalize
ver > nul

endlocal

