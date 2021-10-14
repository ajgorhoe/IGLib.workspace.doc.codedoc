
@echo off

:: Checks out or updates a repository to/at the specified location.
:: Usually used for reposiories that are embedded as full independent 
:: repositories rather than via submodules or some other Git mechanism.

:: Callinng this script has NO SIDE EFFECTS (the body is enclosed in setlocal
:: / endlocal block).

:: PARAMETERS of update are obtained via environment variables:
::   ModuleDir: root directory of cloned Repository
::   CheckoutBranch: branch that is checked out
::   RepositoryAddress: attress of the main remote repository
::   Remote: name of the remote that points to the above
::   RepositoryAddressSecondary: OPTIONAL, address of Secondary
::     remote Repository
::   RemoteSecondary: name of the remote that points to the above
::     (optional even if the above is defined)
::   RepositoryAddressLocal: OPTIONAL address of another alternative
::     remote repository, usually a local one
::   RemoteLocal: name of the remote that points to the above
::     (optional even if the above is defined)

:: One way to call the script is to set all environment variables
:: that define parameters of the update (see above), then call this
:: script to perform the update. AA better wat is to create a settings
:: script that sets all the required parameters, and call this script
:: via embedded calll mechanism simply by stating script path as parameter
:: when calling the script (the advantage is that scripts have no sde
:: effects (variables set or changed) that would propagate to the calling
:: environment). See below for explanation.

:: If any PARAMETERS are specified when calling the script, these are 
:: interpreted as EMBEDDED COMMAND with parameters, which is CALLED
:: BEFORE the body of the current script is executed, still WITHIN setlocal
:: / endlocal block.
:: This mechanism makes possible to define as parameter a script that sets
:: all the parameters as environment variables (the settings script), which
:: is called before the body of this script is executed. The advantage of
:: this approach is that settings for different repositories are packed into
:: the corresponding settings scripts and updating different repositories
:: is performed by calling the current script wih the appropriate settings
:: script as parameter. Annother advantage is that the calling environment
:: is not polluted with environment variables defining the parameters,
:: because this script takes care (by defining setlocal/endlocal block) that
:: variables set in the embedded call do not propagate to the callerr's 
:: environment.

:: As EXAMPLE, suppose we define the scrippt SettingsRepoIGLibCore, which
:: contains repository settings for the IGLibCore repository. Updating the
:: corresponding repositort is done simply by calling:

::   UpdateRepo.bat SettingsRepoIGLibCore.bat

:: It is advisable that the settings script is also created in such a way
:: that it can take an embedded script as parameter, and this script is 
:: run AFTER the environment variables (parameters for this script) are
:: set. In this way, some parameters can be simply overriden by recursively
:: nested commands, e.g.:
::   UpdateRepo.bat SettingsRepoIGLibCore.bat SetVar CheckoutBranch FeatureBranch1
:: This would cause the same as command with a single parameter, except that
:: the branch to be checked out would be different, i.e. FeatureBranch1
:: instead of the branch specified in SettingsRepoIGLibCore.bat (e.g. the
:: default master branch).


setlocal

:: Reset the error level (by running an always successfull command):
ver > nul
:: Base directories:
set ScriptDirUpdateRepo=%~dp0
set InitialDirUpdateRepo=%CD%

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


:: Print values of parameters relevant for repo updates/clone:
call  %~dp0\PrintRepoSettings.bat


:: Basic checks if something is forgotten
if not defined Remote (set Remote=origin)
if "%Remote%" EQU "" (set Remote=origin)
if not defined RemoteSecondary (set RemoteSecondary=originSecondary)
if "%RemoteSecondary%" EQU "" (set RemoteSecondary=originSecondary)
if not defined RemoteLocal (set RemoteLocal=local)
if "%RemoteLocal%" EQU "" (set RemoteLocal=local)

:: Derived parameters:
set ModuleGitSubdir=%ModuleDir%\.git\refs
echo Subdirectory identifying module correctness:
echo   "%ModuleGitSubdir%"
echo.

:: Defaults for eventually missing information:
set IsDefinedCheckoutBranch=0
if defined CheckoutBranch (
  if "%CheckoutBranch%" NEQ "" (
    set IsDefinedCheckoutBranch=1
  )
)
if %IsDefinedCheckoutBranch% EQU 0 (
  echo.
  echo CheckoutBranch set to default - master
  set CheckoutBranch=master
)
set IsDefinedRemote=0
if defined Remote (
  if "%Remote%" NEQ "" (
    set IsDefinedRemote=1
  )
)
if %IsDefinedRemote% EQU 0 (
  echo.
  echo Remote set to default - origin
  set Remote=origin
)

set IsDefinedRepositoryAddressSecondary=0
if defined RepositoryAddressSecondary (
  if "%RepositoryAddressSecondary%" NEQ "" (
    set IsDefinedRepositoryAddressSecondary=1
  )
)
if %IsDefinedRepositoryAddressSecondary% NEQ 0 (
    echo.
    echo Secondary repository address: %RepositoryAddressSecondary%
    echo.
) else (
    echo.
    echo Secondary repository address is not defined.
)
set IsDefinedRepositoryAddressLocal=0
if defined RepositoryAddressLocal (
  if "%RepositoryAddressLocal%" NEQ "" (
    set IsDefinedRepositoryAddressLocal=1
  )
)
if %IsDefinedRepositoryAddressLocal% NEQ 0 (
    echo.
    echo Local repository address: %RepositoryAddressLocal%
    echo.
) else (
    echo.
    echo Local repository address is not defined.
)

set IsDefinedRepositoryAddressSecondary=0
if defined RepositoryAddressSecondary (
  if "%RepositoryAddressSecondary%" NEQ "" (
    set IsDefinedRepositoryAddressSecondary=1
  )
)
if %IsDefinedRepositoryAddressSecondary% NEQ 0 (
    echo.
    echo Secondary repository address: %RepositoryAddressSecondary%
    echo.
) else (
    echo.
    echo Secondary repository address is not defined.
)

set IsClonedAlready=0
if exist "%ModuleGitSubdir%" (
    set IsClonedAlready=1
)

echo.
echo.
echo Updating / cloning of (embedded) repository:
echo   %RepositoryAddress%
echo   to directory:
echo   "%ModuleDir%"
echo   branch: %CheckoutBranch%
echo   remote: %Remote%
echo.

:: Clone the repo if one does not exist (remove its directory before):
if not exist "%ModuleGitSubdir%" (
  if exist "%ModuleDir%" (
    :: Remove eventually existing directory beforehand:
    echo.
    echo Removing the current directory - invalid repo...
    echo Executing:
    echo   rd /s /q "%ModuleDir%"
    rd /s /q "%ModuleDir%"
    echo.
  )
  echo.
  echo Cloning Git repository...
  echo Calling: 
  echo   git clone "%RepositoryAddress%" "%ModuleDir%"
  git clone "%RepositoryAddress%" "%ModuleDir%"
  echo   ... done.
  echo.
  ver > nul
) else (
    echo.
    echo Cloning skipped, repository already cloned.
    echo.
)

if not exist "%ModuleGitSubdir%" (
  echo.
  echo ERROR Could not clone the repository.
  echo.
  goto finalize
) else (
    echo.
    echo Repository exists.
    echo.
)

cd "%ModuleDir%"

echo.
if %IsClonedAlready% EQU 0 (
    :: Set the first remote if named differently than origin:
    if "%Remote%" EQU "origin" (
        echo Remote %Remote% not set, since remote "origin" is already set by default.
    ) else (
        echo setting remote %Remote% ...
        :: git remote remove %Remote% 
        :: ver > nul
        git remote add %Remote% "%RepositoryAddress%"
        ver > nul
    )
    :: Set the two alternative remotes when specified:
    if %IsDefinedRepositoryAddressSecondary% EQU 0 (
        echo Remote %RemoteSecondary% is not specified, not set.
    ) else (
        echo setting remote %RemoteSecondary% to   %RepositoryAddressSecondary% ...
        git remote add %RemoteSecondary% "%RepositoryAddressSecondary%"
        echo.
    )
    if %IsDefinedRepositoryAddressLocal% EQU 0 (
        echo Remote %RemoteLocal% is not specified, not set.
    ) else (
        echo setting remote %RemoteLocal% to   %RepositoryAddressLocal% ...
        git remote add %RemoteLocal% "%RepositoryAddressLocal%"
        echo.
    )
) else (
    echo Remotes are not set because directtory has already been cloned before.
    echo If remotes are not set correcly in the cloned repository, remove it first and run the script again.
    echo In this case, make sure that any changes to reposiory have been committed and pushed.
)
echo.

:: echo.
:: echo Fetching from %Remote%...
:: git fetch %Remote%

echo.
echo Try to check out remote branch...
:: Checkout the remote branch (in case not yet checked out):
git checkout -b "%CheckoutBranch%" "remotes/%Remote%/%CheckoutBranch%" --
ver > nul


echo.
:: Switch to checkout branch  (in case not yet checked out):
echo Switching to branch "%CheckoutBranch%"...
git switch "%CheckoutBranch%"

echo.
echo Pulling changes from %Remote%...
git pull %Remote%


:finalize

echo.
echo Update/clone completed for repository:
echo   %RepositoryAddress%
echo in directory:
echo   %ModuleDir%.
echo.
echo.
echo.

cd %InitialDirUpdateRepo%
ver > nul

endlocal

