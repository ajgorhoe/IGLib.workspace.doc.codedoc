echo off
rem Sets variables for code documentation
rem Reset the error level:
ver > nul






:NextStatement


:EndOfScript


:Finalize
IF %ERRORLEVEL% NEQ 0 (
  echo.
  echo An ERROR occurred in %0:
  echo   ERRORLEVEL = %ERRORLEVEL%
  echo   Error message: %ErrorMessage%
  echo.
)
echo.
echo Configuration variables for code documentation have been set.
echo.
echo.
