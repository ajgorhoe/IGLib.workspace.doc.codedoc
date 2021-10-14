
@echo off
rem Sets locations of various scripts, etc.

echo.
echo UpdateModule Settings:
echo.
echo RepositoryAddress: %RepositoryAddress%
echo ModuleDir: %ModuleDir%
echo CheckoutBranch: %CheckoutBranch%
echo.
echo Defined relevant parameters:
echo   IsDefinedRepositoryAddress: %IsDefinedRepositoryAddress%
echo   IsDefinedModuleDir : %IsDefinedModuleDir%
echo   IsDefinedCheckoutBranch : %IsDefinedCheckoutBranch%
echo.
echo Auxiliary variables (possibly used in deriving the relevant parameters):
echo   CallingScriptDir: %CallingScriptDir%
echo   InitialDir: %InitialDir%
echo   ModuleDirRelative: %ModuleDirRelative%
echo   ModuleContainingDir: %ModuleContainingDir%
echo.
echo Command-line arguments:
echo   Arg. 1: "%~1"
echo   Arg. 2: "%~2"
echo   Arg. 3: "%~3"
echo   Arg. 4: "%~4"
echo.
echo PrintSettingsInScripts: %PrintSettingsInScripts%

