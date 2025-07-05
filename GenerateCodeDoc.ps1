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
# Canonize the above two paths:
$binariesDir = (Get-CanonicalAbsolutePath $binariesDir)
$binariesDirGit =  (Get-CanonicalAbsolutePath $binariesDirGit)
# Get executables for execution of Doxygen and for setting path do GraphViz: 
$doxygenExe = (Join-Path $binariesDir "bin/doxygen/doxygen.exe")
$graphvizDir = (Join-Path $binariesDir "bin/graphviz/bin/")
$doxygenConfig = (Join-Path $scriptDir ($ConfigurationId + ".dox"))

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
Write-Host "  binariesDir       : $binariesDir"
Write-Host "  binariesDirGit    : $binariesDirGit"
Write-Host "  doxygenExe        : $doxygenExe"
Write-Host "  graphvizDir       : $graphvizDir"
Write-Host ""
Write-Host "  doxygenConfig     : $doxygenConfig"
Write-Host "-----------------------------------------"
Write-Host ""


$doUpdateBinaryDirectory = $false
if (Test-Path -Path $binariesDirGit -PathType Container) {
    # Code to run if the directory exists
    Write-Host "Binaries directory exists, update skipped."
} else {
    # Code to run if it does not exist
    Write-Host "Binaries directory does NOT exist."
    $doUpdateBinaryDirectory = $true
}
if ($doUpdateBinaryDirectory)
{
    Write-Host "Updating binaries repo (`"UpdateRepo_codedoc_resources.ps1`")..."
    & $updateBinariesScript
}
Write-Host "Adding Graphviz to the PATH environment variable..."
if (-not ($env:PATH -split [System.IO.Path]::PathSeparator | ForEach-Object { $_.Trim() } | Where-Object { $_ -eq $graphvizDir })) {
    $env:PATH = "$graphvizDir$([System.IO.Path]::PathSeparator)$env:PATH"
}
Write-Host ""
Write-Host "New path: $env:PATH"
Write-Host ""

Write-Host "Creating code documentation for configuration `"$ConfigurationId`"..."
& $doxygenExe $doxygenConfig

Write-Host ""
Write-Host "Code documentation completed for `"$ConfigurationId`"."
Write-Host "-------------------------------------------------------------"
Write-Host ""




