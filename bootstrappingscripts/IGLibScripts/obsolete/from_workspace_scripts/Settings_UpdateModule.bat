
@echo off
rem Sets locations of various scripts, etc.


rem echo SETTINGS before calling settings.bat


if not exist "%~dp0\Settings.bat" (
  echo.
  echo ERROR - non-fatal:
  echo Base settings script, Settings.bat, coulld not be located.
  echo In: %0
  echo Expected at: 
  echo   %~dp0\Settings.bat
  echo.
) else (
  call "%~dp0\Settings.bat"
)

rem echo SETTINGS after calling settings.bat


set IsDefinedModuleDir=0
if defined ModuleDir (
  if "%ModuleDir%" NEQ "" (
    set IsDefinedModuleDir=1
  )
)

rem echo SETTINGS after setting IsDefinedModuleDir


if %IsDefinedModuleDir% EQU 0 (
  rem Module directory is not defined, try to infer it from other variables:
  if defined ModuleContainingDir (
    if "%ModuleContainingDir%" NEQ "" (
	  if defined ModuleDirRelative (
	    if "%ModuleDirRelative%" NEQ "" (
		  echo Inferred module directory ModuleDir:
		  set ModuleDir=%ModuleContainingDir%\%ModuleDirRelative%
		  set IsDefinedModuleDir=1
		  echo   %ModuleDir%
		)
	  )
	)
  )
)

rem echo SETTINGS after inferring ModuleDir


rem Establish which parameters are defined:
set IsDefinedRepositoryAddress=0
if defined RepositoryAddress (
  if "%RepositoryAddress%" NEQ "" (
    set IsDefinedRepositoryAddress=1
  )
)

set IsDefinedCheckoutBranch=0
if defined CheckoutBranch (
  if "%CheckoutBranch%" NEQ "" (
    set IsDefinedCheckoutBranch=1
  )
)

rem Take into account command-line arguments:
if "%~1" NEQ "" (
  if "%RepositoryAddress%" NEQ "%~1%" (
    echo %0:
    echo RepositoryAddress overridden by command-line argument:
	echo   %RepositoryAddress%
	echo   replaced by: 
	echo   %~1%
    echo   	
  )
  set RepositoryAddress=%~1
)
if "%~2" NEQ "" (
  if "%ModuleDir%" NEQ "%~2%" (
    echo %0:
    echo ModuleDir overridden by command-line argument:
	echo   %ModuleDir%
	echo   replaced by: 
	echo   %~2%
    echo.
  )
  set ModuleDir=%~2
)
if "%~3" NEQ "" (
  if "%CheckoutBranch%" NEQ "%~3%" (
    echo %0:
    echo CheckoutBranch overridden by command-line argument:
	echo   %CheckoutBranch%
	echo   replaced by: 
	echo   %~3%
    echo   	
  )
  set CheckoutBranch=%~3
)


rem echo SETTINGS END


