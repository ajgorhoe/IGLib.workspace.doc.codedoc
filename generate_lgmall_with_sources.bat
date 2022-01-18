@echo off
rem Generates code documentation for the specified configuraton.
rem Create local context to avoid side effects:
setlocal

rem Define configuration parameters for this specific script:
set ConfigurationID=lgmall_with_sources
set IsSourcesIncluded=1
set ConfigurationSubdir=.\


rem Define some script-related varibles:
set InitialDir=%CD%
set ThisScriptDir=%~dp0
set ExePath=%ThisScriptDir%%0

set OldGenerationMode=0

echo.
echo ======================================== %~n0%~x0:
echo Generating code doc., conf. %ConfigurationID% ...
echo.


if %OldGenerationMode% NEQ 0 (
  rem Old way of creating code dovumentation:
  echo.
  echo Generating code documentation rhe old way:
  echo.
  measuretime generate.bat %ConfigurationID%
  goto finalize
) 

rem Execute the script that generates the configured code 
rem documentation (the new way):
echo.
echo Running the generation script:
echo   "%ThisScriptDir%GenerateCodeDoc.bat" %ConfigurationID% %IsSourcesIncluded% %ConfigurationSubdir% %*
call "%ThisScriptDir%GenerateCodeDoc.bat" %ConfigurationID% %IsSourcesIncluded% %ConfigurationSubdir% %*

IF %ERRORLEVEL% NEQ 0 (
  echo.
  echo An error occurred in %0:
  echo   ERRORLEVEL = %ERRORLEVEL%
  echo   Error message: %ErrorMessage%
  echo.
)

:finalize

rem end local context:
endlocal
