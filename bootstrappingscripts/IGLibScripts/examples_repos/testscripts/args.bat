@echo off

:: Tests formation of command-line from script parameters
::
:: Try to run the following command:
:: 
::   args 1 args 3 args 5 6 "7 a" 8 9 10 11 12 13 14
:: or
::   args 1 args 3 4 5

echo.
echo ====================================================
echo.
echo Originally passed rguments: 
echo   %*
echo   1:%1 2:%2 3:%3 4:%4 5:%5 6:%6 7:%7 8:%8 9:%9 
echo.


goto skipShiftingBlock

shift
echo.
echo After shifting arguments once:
echo.
echo Arguments: %*
echo   1:%1 2:%2 3:%3 4:%4 5:%5 6:%6 7:%7 8:%8 9:%9 
echo.

shift
echo.
echo After shifting arguments twice:
echo.
echo Arguments: %*
echo   1:%1 2:%2 3:%3 4:%4 5:%5 6:%6 7:%7 8:%8 9:%9 
echo.


set allargs=%*
echo allargs = %allargs%


:skipShiftingBlock

echo.
echo arguments before forming command-line:
echo   %*
echo   1:%1 2:%2 3:%3 4:%4 5:%5 6:%6 7:%7 8:%8 9:%9 
echo.


echo.
echo.
echo Forming command-line via a loop with shift...

:: SPECIFY whether command is treated separately from parameters
::   (change value to 0 or 1 to switch the behavior):
set IsSeparateCommand=0

echo Skipping (consuming) the first argument...
set ConsumedArg=%~1
shift

set CommandName=
if %IsSeparateCommand% NEQ 0 (
	echo Assigning the second argument as recursive command...
	set CommandName=%~1
	shift
)

echo Forming command-line args from remaining arguments....
set params="%~1"
:loop
shift
:: echo in the loop after shift, %%1 = %1
if [%1]==[] goto afterloop
set params=%params% "%~1"
goto loop
:afterloop

echo.
echo After forming command-line:
echo Command treated separately: %IsSeparateCommand%
echo ConsumedArg: %consumedArg%
echo CommandName: %CommandName%
echo params : %params%

echo.
echo calling params as command-line:
echo calling: 
if %IsSeparateCommand% NEQ 0 (
	echo   call "%CommandName%" %params%
	call "%CommandName%" %params%
) else (
	echo   call %params%
	call %params%
)
