
@echo off
setlocal

:: Runs a command in local context (within setlocal/endlocal block) to avoid 
:: side effects. 

:: The command and its arguments are specified by arguments passed to this
:: script. 

:: The ERRORLEVEL WILL PROPAGATE to the calling environment when changed by 
:: the called command. 
:: To avoid this, call 
::   ResetErrorLevel.bat 
:: instead.

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


endlocal

