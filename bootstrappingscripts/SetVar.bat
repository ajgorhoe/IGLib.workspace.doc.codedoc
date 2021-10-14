
@echo off

:: This script sets the variable whose name is derived from its first 
:: argument to the value specified by the second argument of the script, 
:: e.g. the following sets variable ScriptDir to '..\My Files\Scripts' :
::
::  SetVar ScriptDir "..\My Files\Scripts"
::
:: AFTER setting the variable, if there are more arguments, the script treats the rest
:: of the arguments as command with parameters and executes it. This can propagate 
:: RECURSIVELY, therefore the following command would set both variables a and b:
::
::   SetVar a 22 SetVar b 33

:: Examples:
:: This sets variable a to xx:
::   SetVar a xx
:: This sets variable a to value "123 xyz" (without quotes):
::   SetVar a "123 xyz"
:: The value must be in quotes in this case, otherwise 123 and xyz would be treated
:: as two arguments, value would be set to 123, and xyz would be treated as command 
:: to be called recursively.
::
:: The following would set variable cc to XXYY, then variable bb to "11 12", and finally 
:: variable aa to "123 xyz" (all values without quotes). This is because the ::aining 
:: arguments after the second one are treated as another command that is called after setting
:: the variable, and this is don twoce recursively in this case:
::
::   SetVar aa "123 xyz" SetVar bb "11 12" SetVar cc XXYY
::
:: Beside setting the specified variable, this script has a side effect as
:: it defines an auxiliary variable called CommandLine6945


echo Setting variable %~1 to value: %~2
call set %~1=%~2

:: Skip the first two arguments that were consummed vor seting a variable:
shift
shift

if "%~1" EQU "" goto AfterCommandCall
	:: If additional command-line arguments were specified then assemble a 
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


:finalize

ver > nul

