<#
.SYNOPSIS
    Script file for updating or cloning a Git repository.
    Contains the UpdateOrCloneRepository function and helper routines.

.NOTES
    Copyright © Igor Grešovnik.
    Part of IGLib: https://github.com/ajgorhoe/IGLib.modules.IGLibScripts
	License:
	https://github.com/ajgorhoe/IGLib.modules.IGLibScripts/blob/main/LICENSE.md

.DESCRIPTION
    This script defines a function `UpdateOrCloneRepository` and various helper functions
    that clone or update a Git repository, optionally resolving parameters from global variables.
    It supports multiple remotes, references (branch/tag/commit), error handling, and more.

    When run with `-Execute`, the script calls `UpdateOrCloneRepository` with the
    specified or inferred parameters. When run with `-DefaultFromVars`,
    unspecified parameters are automatically pulled from global variables prefixed with 'CurrentRepo_'.

.PARAMETER Directory
    The local repository clone directory.
    If specified as relative path, then: if the BaseDirectory is specified then
    the path is taken relative to the BaseDirectory. Otherwise, the path is 
    taken relative to script directory, if defined, and if not, the path is
    taken relative to the current directory.

.PARAMETER Ref
    The reference (branch, commit, tag) to be checked out.

.PARAMETER Address
    Address of the repository (of the primary remote).

.PARAMETER Remote
    Name of the primary remote. Default is "origin".

.PARAMETER AddressSecondary
    Address of the secondary remote. Optional.

.PARAMETER RemoteSecondary
    Name of the secondary remote. Default is "mirror".

.PARAMETER AddressTertiary
    Address of the tertiary remote. By convention, this is usually (but not 
    necessary) a remote that exists on a local machine.

.PARAMETER RemoteTertiary
    Name of the tertiary remote. Default is "local".

.PARAMETER ThrowOnErrors
    If specified (true) then exceptions are thrown on errors (by default,
    exceptions are caught internally and not thrown).

.PARAMETER DefaultFromVars
    If true then default values of parameters are set from environment 
    variables with the agreed upon names. These names are parameter names
    prefixed by 'CurrentRepo_' (contained in the constant
    ParameterGlobalVariablePrefix).

.PARAMETER Execute
    If true then the main function UpdateOrCloneRepository() is executed
    according to the specified parameters. If false then the main function
    is not executed, and running the script just brings in the definitions of
    functions defined in it. If not specified at all, then the main function
    is executed if sufficient parameters are provided, i.e., if either the
    Address or the Directory parameters are specified.

.PARAMETER ParamsToVars
    If specified (true) then parameter passed to the script are written to the
    environment variables that by convention contain the default values of 
    parameters (see description of the DefaultFromVars).

.PARAMETER BaseDirectory
    If specified then if the Directory parameter is specified as relative path,
    this path is taken relative to the BaseDirectory.

.EXAMPLE
    .\UpdateOrCloneRepository.ps1 -Directory "C:\Repos\Example" -Address "https://github.com/foo/bar.git" -Execute

    Clones or updates the repo in C:\Repos\Example, using the default remote name 'origin',
    and prints status messages to the console.

.EXAMPLE
    # Rely on global variables for parameters
    $global:CurrentRepo_Directory = "C:\MyGlobalRepo"
    $global:CurrentRepo_Address   = "https://github.com/foo/myglobal.git"
    .\UpdateOrCloneRepository.ps1 -DefaultFromVars -Execute

    Pulls the Directory and Address from the global variables, then clones/updates the repo.
#>

param (
    [string]$Directory,
    [string]$Ref,
    [string]$Address,
    [string]$Remote = "origin",
    [string]$AddressSecondary,
    [string]$RemoteSecondary = "mirror",
    [string]$AddressTertiary,
    [string]$RemoteTertiary = "local",
    [switch]$ThrowOnErrors,
    [switch]$DefaultFromVars,
    [switch]$Execute,
    [switch]$ParamsToVars,
    [string]$BaseDirectory
)

###############################################################################
# Constants & Defaults
###############################################################################

# Prefix used for setting/retrieving global variables
$ParameterGlobalVariablePrefix = "CurrentRepo_"

# Default values
$DefaultRemote          = "origin"
$DefaultRemoteSecondary = "mirror"
$DefaultRemoteTertiary  = "local"

###############################################################################
# Logging & Error-Handling Helpers
###############################################################################

function Write-Info {
    param([string]$Message)
    Write-Host "Info: $Message" -ForegroundColor Cyan
}

function Write-Warn {
    param([string]$Message)
    Write-Host "Warning: $Message" -ForegroundColor Yellow
}

function Write-ErrorReport {
    param([string]$Message, [switch]$throwOnErrors)
    Write-Host "ERROR: $Message" -ForegroundColor Red
    if ($throwOnErrors) {
        throw $Message
    }
}

###############################################################################
# Git Helper Functions
###############################################################################

<#
.SYNOPSIS
    Checks whether a given directory (or one of its parent directories) is a Git repository.

.DESCRIPTION
    This function starts at the specified directory and checks if `.git` is present
    (with a valid `HEAD` file) in it or any of its parents until it reaches the filesystem root.

.PARAMETER directoryPath
    The directory path to inspect. If it's within a Git repo or is itself a Git repo root, returns $true.

.EXAMPLE
    IsGitRepository "C:\Projects\MyRepo"
    # Returns $true if MyRepo is or contains a valid .git folder.

#>
function IsGitRepository {
    param ([string]$directoryPath)
    # Check upwards if the path is nested within a repository.
    while ($directoryPath -and (Test-Path $directoryPath)) {
        if (Test-Path (Join-Path $directoryPath ".git")) {
            # Quick check inside .git folder:
            if (Test-Path (Join-Path $directoryPath ".git\\HEAD")) {
                return $true
            }
        }
        $parentPath = Split-Path $directoryPath -Parent
        if ($parentPath -eq $directoryPath) { break }
        $directoryPath = $parentPath
    }
    return $false
}

<#
.SYNOPSIS
    Finds the root directory of a Git repository.

.DESCRIPTION
    Similar logic to IsGitRepository, but instead of returning $true or $false,
    it returns the actual path where `.git` and a valid `HEAD` file are found,
    or $null if not found.

.PARAMETER directoryPath
    The starting directory from which to search upward.

.EXAMPLE
    $root = GetGitRepositoryRoot "C:\Projects\MyRepo\src"
    # If MyRepo is a Git repo, returns "C:\Projects\MyRepo"

#>
function GetGitRepositoryRoot {
    param ([string]$directoryPath)
    while ($directoryPath -and (Test-Path $directoryPath)) {
        if (Test-Path (Join-Path $directoryPath ".git")) {
            if (Test-Path (Join-Path $directoryPath ".git\\HEAD")) {
                return $directoryPath
            }
        }
        $parentPath = Split-Path $directoryPath -Parent
        if ($parentPath -eq $directoryPath) {
            return $null
        }
        $directoryPath = $parentPath
    }
    return $null
}

<#
.SYNOPSIS
    Retrieves the URL of a specific remote from a Git repository.

.DESCRIPTION
    Looks up the Git repository root (via GetGitRepositoryRoot)
    and runs `git remote get-url <remoteName>` to obtain the address.

.PARAMETER directoryPath
    A path inside the repository.

.PARAMETER remoteName
    The name of the remote (e.g. 'origin').

.EXAMPLE
    GetGitRemoteAddress "C:\Projects\MyRepo" "origin"
    # Might return "https://github.com/user/MyRepo.git"
#>
function GetGitRemoteAddress {
    param (
        [string]$directoryPath,
        [string]$remoteName
    )
    $rootDir = GetGitRepositoryRoot $directoryPath
    if (-not $rootDir) { return $null }
    try {
        return git -C $rootDir remote get-url $remoteName 2>$null
    } catch {
        return $null
    }
}

<#
.SYNOPSIS
    Extracts the repository name from a Git address.

.DESCRIPTION
    This function takes a repository address (URL or local path),
    and returns the last path component, removing a trailing `.git`.

.PARAMETER repositoryAddress
    The address of the repository. E.g. "https://github.com/foo/bar.git" or "/repos/bar.git".

.EXAMPLE
    GetGitRepositoryName "https://github.com/foo/bar.git"
    # Returns "bar"
#>
function GetGitRepositoryName {
    param ([string]$repositoryAddress)
    if (-not $repositoryAddress) { return $null }
    $leaf = Split-Path $repositoryAddress -Leaf
    # Remove trailing .git if it exists
    $leaf = $leaf -replace "\.git$", ""
    return $leaf
}

<#
.SYNOPSIS
    Checks if two Git remote addresses are consistent, performing basic normalization.

.DESCRIPTION
    Removes trailing slashes for HTTP(S) addresses, attempts to resolve local paths,
    then does a case-insensitive comparison. Returns $true if they match, $false otherwise.

.PARAMETER expected
    The first address to compare (e.g. user-specified remote).

.PARAMETER actual
    The second address to compare (e.g. existing remote in the local repo).

.EXAMPLE
    CheckGitAddressConsistency "https://github.com/foo/bar.git" "https://github.com/foo/bar.git/"
    # Returns $true
#>
function CheckGitAddressConsistency {
    param (
        [string]$expected,
        [string]$actual
    )

    # Both empty => consistent
    if ([string]::IsNullOrWhiteSpace($expected) -and [string]::IsNullOrWhiteSpace($actual)) {
        return $true
    }
    # One empty, other not => inconsistent
    if ([string]::IsNullOrWhiteSpace($expected) -xor [string]::IsNullOrWhiteSpace($actual)) {
        return $false
    }

    # Minimal normalizations:
    # 1) Trim whitespace
    $exp = $expected.Trim()
    $act = $actual.Trim()

    # 2) If HTTP(S), remove trailing slash
    if ($exp -match '^https?://') { $exp = $exp.TrimEnd('/') }
    if ($act -match '^https?://') { $act = $act.TrimEnd('/') }

    # 3) If local path, attempt to resolve path if it exists
    function TryResolvePath([string]$p) {
        try {
            if (Test-Path $p) {
                # Return the resolved path (canonical)
                return (Resolve-Path -LiteralPath $p -ErrorAction Stop).Path
            }
            else {
                # Return the original
                return $p
            }
        } catch {
            return $p
        }
    }

    # A naive check for local paths: if it doesn't start with 'http' or 'ssh' or 'git@', treat as local
    if ($exp -notmatch '^(https?://|ssh://|git@)' ) { $exp = TryResolvePath $exp }
    if ($act -notmatch '^(https?://|ssh://|git@)' ) { $act = TryResolvePath $act }

    # 4) Case-insensitive comparison
    return ([string]::Equals($exp, $act, [System.StringComparison]::OrdinalIgnoreCase))
}

<#
.SYNOPSIS
    Returns the absolute path for a given path, optionally relative to BaseDirectory.

.DESCRIPTION
    If the given path is rooted (absolute), it attempts to resolve it.
    If not, and BaseDirectory is provided, it joins them. Otherwise,
    it falls back to the script directory or current directory.

.PARAMETER Path
    The path to resolve (may be absolute or relative).

.PARAMETER BaseDirectory
    If set, the returned path is combined with BaseDirectory if Path is not rooted.

.EXAMPLE
    EnsureFullPath -Path "Repo" -BaseDirectory "C:\Projects"
    # Returns "C:\Projects\Repo" if it exists or the best guess if it does not.
#>
function EnsureFullPath {
    param (
        [string]$Path,
        [string]$BaseDirectory
    )
    # If the path is already absolute, we just try to resolve.
    if ([IO.Path]::IsPathRooted($Path)) {
        try {
            return (Resolve-Path -LiteralPath $Path -ErrorAction Stop).Path
        } catch {
            return $Path  # Return raw path if it doesn't exist
        }
    }
    else {
        # The path is relative. If BaseDirectory is specified & valid, we use that.
        if ($BaseDirectory) {
            try {
                if (Test-Path $BaseDirectory -PathType Container) {
                    $combinedPath = Join-Path $BaseDirectory $Path
                    # Try to resolve:
                    return (Resolve-Path -LiteralPath $combinedPath -ErrorAction Stop).Path
                }
                else {
                    # If BaseDirectory does not exist, we just combine as raw path
                    return Join-Path $BaseDirectory $Path
                }
            } catch {
                return Join-Path $BaseDirectory $Path
            }
        }
        else {
            # Fall back to old logic: combine with script directory or current dir
            if ($MyInvocation.MyCommand.Path) {
                $scriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent
                $combinedPath = Join-Path $scriptDir $Path
            } else {
                $combinedPath = Join-Path (Get-Location) $Path
            }
            try {
                return (Resolve-Path -LiteralPath $combinedPath -ErrorAction Stop).Path
            } catch {
                return $combinedPath
            }
        }
    }
}

<#
.SYNOPSIS
    Clones or updates a Git repository in a specified directory, with support for multiple remotes
    and references.

.DESCRIPTION
    The UpdateOrCloneRepository function checks if the directory contains an existing Git repository
    matching the specified remote address. If not found, it clones. If found, it fetches from the primary remote,
    checks out a specified reference (branch/tag/commit), and can also configure secondary/tertiary remotes.

.PARAMETER Directory
    The directory where the repository should be cloned or updated.

.PARAMETER Ref
    A branch, tag, or commit to check out.

.PARAMETER Address
    The primary remote address (e.g. "https://github.com/user/repo.git").

.PARAMETER Remote
    The name for the primary remote (default: origin).

.PARAMETER AddressSecondary
    URL for a secondary remote, if needed.

.PARAMETER RemoteSecondary
    Name of the secondary remote (default: mirror).

.PARAMETER AddressTertiary
    URL for a tertiary remote, if needed.

.PARAMETER RemoteTertiary
    Name of the tertiary remote (default: local).

.PARAMETER ThrowOnErrors
    If set, the function throws on fatal errors instead of returning gracefully.

.PARAMETER DefaultFromVars
    If set, unspecified parameters are filled from global variables (e.g. $global:CurrentRepo_Directory).

.PARAMETER BaseDirectory
    If non-empty and Directory is relative, Directory is resolved relative to BaseDirectory.

.EXAMPLE
    UpdateOrCloneRepository -Directory "C:\Repos\MyRepo" -Address "https://github.com/foo/bar.git" -Ref "main"

.NOTES
    Additional usage details can be found in the script's overall comment or via 
    external documentation tools like PlatyPS.
#>
function UpdateOrCloneRepository {
    param (
        [string]$Directory,
        [string]$Ref,
        [string]$Address,
        [string]$Remote = $DefaultRemote,
        [string]$AddressSecondary,
        [string]$RemoteSecondary = $DefaultRemoteSecondary,
        [string]$AddressTertiary,
        [string]$RemoteTertiary = $DefaultRemoteTertiary,
        [switch]$ThrowOnErrors,
        [switch]$DefaultFromVars,
        [string]$BaseDirectory
    )

    Write-Info "Updating or cloning a repository..."

    ############################################################################
    # (1) If $DefaultFromVars, fill any missing parameters from global variables
    ############################################################################
    if ($DefaultFromVars) {
        Write-Info "DefaultFromVars is set (function scope). Checking for missing parameters..."
        $paramList = 'Directory','Ref','Address','Remote','AddressSecondary','RemoteSecondary','AddressTertiary','RemoteTertiary','BaseDirectory'
        foreach ($p in $paramList) {
            # Did the caller explicitly specify this parameter?
            if (-not $PSBoundParameters.ContainsKey($p)) {
                # The user did NOT pass this parameter, so let's try to fill from global
                $upperParam   = $p.Substring(0,1).ToUpper() + $p.Substring(1)
                $globalVarName = "${ParameterGlobalVariablePrefix}${upperParam}"
                $currentVal = Get-Variable -Name $p -Scope 0 -ErrorAction SilentlyContinue

                # We must check .Value to see if the param is actually set
                if ($currentVal -and $currentVal.Value) {
                    Write-Info "  $p is already set. Value: $($currentVal.Value)"
                    continue
                }

                Write-Info "  Checking global variable: $globalVarName"
                $globalVal = (Get-Variable -Name $globalVarName -Scope Global -ErrorAction SilentlyContinue).Value
                Write-Info "  >> Global variable value: $globalVal"

                if ($globalVal) {
                    Set-Variable -Name $p -Value $globalVal -Scope 0
                    Write-Info "  $p set from $globalVarName to $globalVal"
                }
                else {
                    Write-Info "  $p not set from global variable."
                }
            }
            else {
                Write-Info "  $p was explicitly provided by the caller."
            }
        }
    }

    ############################################################################
    # (2) Apply default values if not set
    ############################################################################
    if (-not $Remote)          { $Remote          = $DefaultRemote }
    if (-not $RemoteSecondary) { $RemoteSecondary = $DefaultRemoteSecondary }
    if (-not $RemoteTertiary)  { $RemoteTertiary  = $DefaultRemoteTertiary }

    ############################################################################
    # (3) Additional logic for deduce Directory from Address (if needed)
    ############################################################################
    # But if Directory is relative and BaseDirectory is specified, we do that logic in EnsureFullPath.
    if (-not $Directory -and $Address) {
        $repoName = GetGitRepositoryName $Address
        if ($repoName) {
            $Directory = Join-Path (Split-Path $MyInvocation.MyCommand.Path -Parent) $repoName
        } else {
            $Directory = Join-Path (Split-Path $MyInvocation.MyCommand.Path -Parent) "Repo"
        }
    }

    # Convert to full path (honoring BaseDirectory if set)
    if ($Directory) {
        $Directory = EnsureFullPath -Path $Directory -BaseDirectory $BaseDirectory
    }

    # If Directory is specified but Address is not, try to deduce from existing remote
    if (-not $Address -and $Directory) {
        if (Test-Path $Directory -PathType Container -and (IsGitRepository $Directory)) {
            $existingAddr = GetGitRemoteAddress $Directory $Remote
            if ($existingAddr) {
                $Address = $existingAddr
                Write-Info "Deduced address from existing remote '$Remote': $Address"
            }
        }
    }

    ############################################################################
    # (4) Print final parameter values (after resolution), then validate
    ############################################################################
    Write-Host "Final Parameter Values:" -ForegroundColor DarkCyan
    Write-Host "  Directory:         $Directory"
    Write-Host "  Ref:               $Ref"
    Write-Host "  Address:           $Address"
    Write-Host "  Remote:            $Remote"
    Write-Host "  AddressSecondary:  $AddressSecondary"
    Write-Host "  RemoteSecondary:   $RemoteSecondary"
    Write-Host "  AddressTertiary:   $AddressTertiary"
    Write-Host "  RemoteTertiary:    $RemoteTertiary"
    Write-Host "  ThrowOnErrors:     $ThrowOnErrors"
    Write-Host "  DefaultFromVars:   $DefaultFromVars"
    Write-Host "  BaseDirectory:     $BaseDirectory"
    Write-Host ""

    # Validate that we have either an existing repo or an Address
    if (-not $Address -and $Directory) {
        if (-not (Test-Path $Directory)) {
            Write-ErrorReport "Directory ${Directory} does not exist, and no Address specified to clone from." -throwOnErrors:$ThrowOnErrors
            return
        } else {
            if (-not (IsGitRepository $Directory)) {
                Write-ErrorReport "Directory ${Directory} is not a valid Git repository, and no Address was specified." -throwOnErrors:$ThrowOnErrors
                return
            }
        }
    }

    # If Directory doesn't exist, create it so we can clone
    $dirExists = $false
    if ($Directory) {
        $dirExists = Test-Path $Directory -PathType Container
        if (-not $dirExists) {
            try {
                New-Item -ItemType Directory -Path $Directory | Out-Null
                Write-Info "Created directory: $Directory"
                $dirExists = $true
            }
            catch {
                Write-ErrorReport "Could not create directory: ${Directory}" -throwOnErrors:$ThrowOnErrors
                return
            }
        }
    }

    # If directory exists and is non-empty, ensure correct repository
    if ($dirExists) {
        $items = Get-ChildItem -Path $Directory
        $isEmpty = ($items | Measure-Object).Count -eq 0
        if (-not $isEmpty) {
            if (-not (IsGitRepository $Directory)) {
                Write-ErrorReport "Repository directory (${Directory}) is not empty and does not contain a valid Git repo." -throwOnErrors:$ThrowOnErrors
                return
            } else {
                # Check remote consistency if $Address is set
                if ($Address) {
                    $existingRemote = GetGitRemoteAddress $Directory $Remote
                    if ($existingRemote) {
                        $consistent = CheckGitAddressConsistency $Address $existingRemote
                        if (-not $consistent) {
                            Write-ErrorReport "Repository directory (${Directory}) has remote '$Remote' set to '$existingRemote' but should be '$Address'." -throwOnErrors:$ThrowOnErrors
                            return
                        }
                    }
                }
            }
        }
    }

    # Clone if needed
    if ($Address -and (!$dirExists -or ($dirExists -and $isEmpty))) {
        try {
            Write-Info "Cloning repository from $Address into $Directory..."
            git clone --origin $Remote $Address $Directory
            if ($LASTEXITCODE -ne 0) {
                Write-ErrorReport "Failed to clone repository from $Address into ${Directory}." -throwOnErrors:$ThrowOnErrors
                return
            }
        }
        catch {
            Write-ErrorReport ("Exception occurred while cloning from ${Address} into ${Directory}: " + $_) -throwOnErrors:$ThrowOnErrors
            return
        }
    } else {
        # If we already have the repository, fetch from the primary remote
        if ($Address) {
            Write-Info "Fetching changes from remote '$Remote'..."
            try {
                git -C $Directory fetch $Remote
                if ($LASTEXITCODE -ne 0) {
                    Write-ErrorReport "Failed to fetch updates in ${Directory}." -throwOnErrors:$ThrowOnErrors
                    return
                }
            }
            catch {
                Write-ErrorReport ("Exception occurred while fetching in ${Directory}: " + $_) -throwOnErrors:$ThrowOnErrors
                return
            }
        }
    }

    # Handle secondary remote
    if ($AddressSecondary) {
        Write-Info "Ensuring secondary remote ($RemoteSecondary) points to $AddressSecondary"
        try {
            git -C $Directory remote add $RemoteSecondary $AddressSecondary 2>$null
            if ($LASTEXITCODE -ne 0) {
                # If add fails, try set-url
                git -C $Directory remote set-url $RemoteSecondary $AddressSecondary
                if ($LASTEXITCODE -ne 0) {
                    Write-Warn "Could not set secondary remote '$RemoteSecondary' to '$AddressSecondary'."
                } else {
                    Write-Warn "Changed address of existing remote '$RemoteSecondary' to '$AddressSecondary'"
                }
            } else {
                Write-Info "Remote '$RemoteSecondary' set to '$AddressSecondary'"
            }
        }
        catch {
            Write-ErrorReport ("Exception occurred while setting secondary remote: " + $_) -throwOnErrors:$ThrowOnErrors
            return
        }
    }

    # Handle tertiary remote
    if ($AddressTertiary) {
        Write-Info "Ensuring tertiary remote ($RemoteTertiary) points to $AddressTertiary"
        try {
            git -C $Directory remote add $RemoteTertiary $AddressTertiary 2>$null
            if ($LASTEXITCODE -ne 0) {
                # If add fails, try set-url
                git -C $Directory remote set-url $RemoteTertiary $AddressTertiary
                if ($LASTEXITCODE -ne 0) {
                    Write-Warn "Could not set tertiary remote '$RemoteTertiary' to '$AddressTertiary'."
                } else {
                    Write-Warn "Changed address of existing remote '$RemoteTertiary' to '$AddressTertiary'"
                }
            } else {
                Write-Info "Remote '$RemoteTertiary' set to '$AddressTertiary'"
            }
        }
        catch {
            Write-ErrorReport ("Exception occurred while setting tertiary remote: " + $_) -throwOnErrors:$ThrowOnErrors
            return
        }
    }

    # Check out Ref if specified
    if ($Ref) {
        Write-Info "Ensuring repository is checked out at reference '$Ref'"
        try {
            git -C $Directory checkout $Ref 2>$null
            if ($LASTEXITCODE -ne 0) {
                Write-Info "Local branch/ref '$Ref' not found, attempting to fetch and create local branch."
                git -C $Directory fetch $Remote
                if ($LASTEXITCODE -ne 0) {
                    Write-ErrorReport "Failed to fetch from remote '$Remote'." -throwOnErrors:$ThrowOnErrors
                    return
                }
                git -C $Directory checkout -b $Ref "$Remote/$Ref"
                if ($LASTEXITCODE -ne 0) {
                    Write-ErrorReport "Failed to check out new branch '$Ref' from remote '$Remote'." -throwOnErrors:$ThrowOnErrors
                    return
                }
                Write-Warn "Current branch changed to '$Ref' (new local branch tracking '$Remote/$Ref')."
            } else {
                Write-Warn "Repository switched to '$Ref' (could be branch, tag, or commit)."
            }
        }
        catch {
            Write-ErrorReport ("Failed to checkout reference '$Ref': " + $_) -throwOnErrors:$ThrowOnErrors
            return
        }
        # If it's a branch, we can pull to update
        $currentBranch = (git -C $Directory branch --show-current 2>$null).Trim()
        if ($currentBranch -eq $Ref) {
            Write-Info "Pulling latest commits for branch '$Ref' from '$Remote'"
            try {
                git -C $Directory pull $Remote $Ref
                if ($LASTEXITCODE -ne 0) {
                    Write-ErrorReport "Failed to pull latest changes for branch '$Ref'." -throwOnErrors:$ThrowOnErrors
                    return
                }
            }
            catch {
                Write-ErrorReport ("Exception occurred while pulling latest changes for branch '$Ref': " + $_) -throwOnErrors:$ThrowOnErrors
                return
            }
            Write-Info "Repository in '${Directory}' is now updated to the latest commit of branch '$Ref'"
        }
        else {
            # Possibly a detached HEAD if Ref is a tag or commit
            Write-Info "The repository in '${Directory}' is checked out at '$Ref' (possibly a detached HEAD)."
            Write-Info "Fetching from remote '$Remote' in case the tag or commit was updated..."
            try {
                git -C $Directory fetch $Remote --tags
            }
            catch {
                Write-Warn ("Could not fetch from remote '$Remote' for tag or commit: " + $_)
            }
        }
    }
    else {
        Write-Info "No Ref specified. Repository remains on its current branch/tag/commit."
    }

    Write-Info "Repository is up to date in directory: ${Directory}"
}

<#
.SYNOPSIS
    Resolves script-level parameters from global variables, applying defaults if needed.

.DESCRIPTION
    If -DefaultFromVars is set at the script level, this function attempts to copy
    values from global variables named $CurrentRepo_<PropertyName> into the script's
    local parameter variables (e.g. Directory, Address, etc.). It also applies default
    values for Remote, etc., if they remain unset.

.NOTES
    This function is called automatically near the end of the script, before deciding
    whether to execute UpdateOrCloneRepository.
#>
function Resolve-ScriptParameters {
    # 1) Fill from global variables if $DefaultFromVars is set, then apply defaults, etc.
    if ($DefaultFromVars) {
        Write-Info "Resolve-ScriptParameters called with DefaultFromVars = $DefaultFromVars. Attempting to fill script parameters from global variables..."

        $paramList = 'Directory','Ref','Address','Remote','AddressSecondary','RemoteSecondary','AddressTertiary','RemoteTertiary','BaseDirectory'
        foreach ($p in $paramList) {
            $scriptParamValue = (Get-Variable -Name $p -Scope 1 -ErrorAction SilentlyContinue).Value
            if ($scriptParamValue) {
                Write-Info "  $p is already set in script parameters to: $scriptParamValue"
            }
            else {
                $upperParam  = $p.Substring(0,1).ToUpper() + $p.Substring(1)
                $globalVarName = "${ParameterGlobalVariablePrefix}${upperParam}"

                Write-Info "  Checking global variable name: $globalVarName"
                $globalVal = (Get-Variable -Name $globalVarName -Scope Global -ErrorAction SilentlyContinue).Value
                Write-Info "  >> Global variable value: $globalVal"

                if ($globalVal) {
                    Set-Variable -Name $p -Value $globalVal -Scope 1
                    Write-Info "  $p set from $globalVarName to $globalVal"
                }
                else {
                    Write-Info "  $p not set from global variable."
                }
            }
        }
    }

    # 2) Apply default values if not set
    if (-not $Remote)          { $Remote          = $DefaultRemote }
    if (-not $RemoteSecondary) { $RemoteSecondary = $DefaultRemoteSecondary }
    if (-not $RemoteTertiary)  { $RemoteTertiary  = $DefaultRemoteTertiary }
}

<#
.SYNOPSIS
    Copies current script parameter values into global variables if requested.

.DESCRIPTION
    If -ParamsToVars is set, for each recognized parameter name, this function
    updates the corresponding $CurrentRepo_<Name> global variable to the parameter's value.

.NOTES
    This is typically used so that after the script completes, the parameter values 
    remain accessible in the global scope.
#>
function Set-GlobalVarsIfRequested {
    if ($ParamsToVars) {
        $paramList = 'Directory','Ref','Address','Remote','AddressSecondary','RemoteSecondary','AddressTertiary','RemoteTertiary','BaseDirectory'
        foreach ($p in $paramList) {
            $value = (Get-Variable -Name $p -Scope 1 -ErrorAction SilentlyContinue).Value
            if ($null -ne $value) {
                $upperParam  = $p.Substring(0,1).ToUpper() + $p.Substring(1)
                $globalVarName = "${ParameterGlobalVariablePrefix}${upperParam}"

                Set-Variable -Name $globalVarName -Value $value -Scope Global
                Write-Info "Set global variable $globalVarName to $value"
            }
        }
    }
}

Resolve-ScriptParameters

# Decide whether to call the main function based on the logic described:
# 1) If $Execute is true, run the main function unconditionally.
# 2) If $Execute is false, do NOT run the main function.
# 3) If $Execute is not specified, but Address or Directory are specified, run the main function.

$shouldExecute = $false
if ($Execute.IsPresent) {
    if ($Execute) {
        $shouldExecute = $true
    } else {
        $shouldExecute = $false
    }
}
else {
    if ($PSBoundParameters.ContainsKey('Address') -or $PSBoundParameters.ContainsKey('Directory')) {
        $shouldExecute = $true
    }
}

Set-GlobalVarsIfRequested

if ($shouldExecute) {
    UpdateOrCloneRepository `
        -Directory $Directory `
        -Ref $Ref `
        -Address $Address `
        -Remote $Remote `
        -AddressSecondary $AddressSecondary `
        -RemoteSecondary $RemoteSecondary `
        -AddressTertiary $AddressTertiary `
        -RemoteTertiary $RemoteTertiary `
        -ThrowOnErrors:$ThrowOnErrors `
        -DefaultFromVars:$DefaultFromVars `
        -BaseDirectory $BaseDirectory
}
