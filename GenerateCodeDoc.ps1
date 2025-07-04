<#
.SYNOPSIS
    Script file for generating code documentation for a specific 
	configuration.

.NOTES
    Copyright © Igor Grešovnik.
    Part of IGLib: https://github.com/ajgorhoe/IGLib.workspace.doc.codedoc
	License: https://github.com/ajgorhoe/IGLib.workspace.doc.codedoc/blob/master/LICENSE.md

.DESCRIPTION
    This script defines a function `UpdateOrCloneRepository` and various helper functions
    that clone or update a Git repository, optionally resolving parameters from global variables.
    It supports multiple remotes, references (branch/tag/commit), error handling, and more.

    When run with `-Execute`, the script calls `UpdateOrCloneRepository` with the
    specified or inferred parameters. When run with `-DefaultFromVars`,
    unspecified parameters are automatically pulled from global variables prefixed with 'CurrentRepo_'.

.PARAMETER Directory
    The local directory.


.EXAMPLE
    .\UpdateOrCloneRepository.ps1 -Directory "C:\Repos\Example" -Address "https://github.com/foo/bar.git" -Execute

    Clones or updates the repo in C:\Repos\Example, using the default remote name 'origin',
    and prints status messages to the console.

#>


param (
    [string]$ConfigurationId,
    [switch]$IsSourcesIncluded,
    [switch]$LaunchDoc
)
function Get-CanonicalAbsolutePath {
    param([string]$Path)
    if ([System.IO.Path]::IsPathRooted($Path)) {
        return [System.IO.Path]::GetFullPath($Path)
    } else {
        return [System.IO.Path]::GetFullPath((Join-Path -Path (Get-Location) -ChildPath $Path))
    }
}

Write-Host ""
Write-Host "============================================================"
Write-Host "GenerateCodeDoc.ps1:"
Write-Host ""

# Prefix used for setting/retrieving global variables
$ParameterGlobalVariablePrefix = "CodeDoc_"

$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptPath -Parent

# Update the binaries repository, ../codedoc_resources:
$updateBinariesScript = (Join-Path $scriptDir "UpdateRepo_codedoc_resources.ps1")
$binariesDir = (Join-Path $scriptDir "../codedoc_resources/")
$binariesDirGit = (Join-Path $binariesDir ".git/")
# Canonize the above paths:
$binariesDir = (Get-CanonicalAbsolutePath $binariesDir)
$binariesDirGit =  (Get-CanonicalAbsolutePath $binariesDirGit)

Write-Host "-----------------------------------------"
Write-Host "Script parameters:"
Write-Host "  ConfigurationId:   $ConfigurationId"
Write-Host "  IsSourcesIncluded: $IsSourcesIncluded"
Write-Host "  LaunchDoc:         $LaunchDoc"
Write-Host "Global variables:"

Write-Host "Derived parameters:"
Write-Host "  scriptPath:   $scriptPath"
Write-Host "  scriptDir:    $scriptDir"
Write-Host "  updateBinariesScript: $updateBinariesScript"
Write-Host "  binariesDir         : $binariesDir"
Write-Host "  binariesDirGit      : $binariesDirGit"
Write-Host "-----------------------------------------"
Write-Host ""

Write-Host "Updating binaries repo (`"UpdateRepo_codedoc_resources.ps1`")..."


Write-Host "Creating code documentation for configuration `"$ConfigurationId`"..."
# & $updateBinariesScript


Write-Host ""
Write-Host "Code documentation completed for `"$ConfigurationId`"."
Write-Host "-------------------------------------------------------------"
Write-Host ""




