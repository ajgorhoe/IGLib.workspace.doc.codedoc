<#
.SYNOPSIS
    Script file for generating HTML code documentation for a specific 
	configuration.

.NOTES
    Copyright © Igor Grešovnik.
    Part of IGLib: https://github.com/ajgorhoe/IGLib.workspace.doc.codedoc
	License: https://github.com/ajgorhoe/IGLib.workspace.doc.codedoc/blob/master/LICENSE.md

.DESCRIPTION
    The configuration is spcified by the mandatory parameter $ConfigurationId.
    This defines the Doxygen file containing the configuration options for
    generation, which is simply ($ConfigurationId).dox, as well as the path 
    where the documentation is generated (generated/($ConfigurationId)/html,
    or in case that sources are included, similar path starting with
    "generated_with_sources").
    The output path must be specified in the corresponding .dox configuration 
    file, and must respect the above agreement. This includes inclusion of
    sources in the generated configuration, in which case the documentation
    must be generated in the direectory "generated_with_sources" rather than
    "generated".
    This script is usually run by another script, which is created for 
    generating a specific documentation. Examples are generate_test.ps1
    and generate_test_with_sources.ps1, which are aimed for testing. That
    script must provide correct parameter to this script, and it usually
    enables modifyig default values by explicitly specifying the parameters of
    that script, which have the same names as the corresponding parameters of
    this script.
    Boolean parameters are declared as [bool] rather than [switch], in order
    to make easier to specify parameters via variables or parameters of the
    calling script.
    The script automatically clones, if necessary, the repository containing
    binaries necessary for generation of code documentation (Doxygen and
    Graphviz).

.PARAMETER ConfigurationId
    Mandatory (exception is thrown if not specified). It specifies the
    configuration (a .dox file with the same name as the configuration ID)
    according to which the documentation is generated, which in turn 
    determines the location where the documentation is generated. If the 
    documentation includes source files, this location is 
    generated/($ConfigurationId)/html, otherwise it is
    generated_with_sources/($ConfigurationId)/html.

.PARAMETER IsSourcesIncluded
    Specifies whether sources are included or not. This is informative 
    parameter, but it is relevant when launch of the documentation is
    requested after generation, because knowledge of this parmeter value is
    necessary to determine the location of generated documentation.

.PARAMETER ForceUpdates
    If true then the repository containing the binaries necessary for 
    generation of documentation is updated evn if its clone exists at the
    expected location. Default is false.

.PARAMETER LaunchDoc
    If true the the index of generated HTML documentation is shown in the 
    default web browser after successful generation. Default is true, which 
    should be overridden when documentation is generated in the CI/CD pipeline.   
    
.EXAMPLE
    .\GenerateCodeDoc.ps1 -LaunchDoc 1

    Clones or updates the repo in C:\Repos\Example, using the default remote name 'origin',
    and prints status messages to the console.

#>

param (
    [string]$ConfigurationId,
    [bool]$IsSourcesIncluded = $true,
    [bool]$ForceUpdates = $false,
    [bool]$LaunchDoc = $true
)

if (-not $ConfigurationId) {
    throw "Missing required parameter: -ConfigurationId"
}

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

# # Prefix used for setting/retrieving global variables
# $ParameterGlobalVariablePrefix = "CodeDoc_"

$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptPath -Parent

# Update the binaries repository, ../codedoc_resources:
$updateBinariesScript = (Join-Path $scriptDir "UpdateRepo_codedoc_resources_25_12.ps1")
# New binaries repositrry, does not work yet (needs adaptation of .dox files)
# (Join-Path $scriptDir "UpdateRepo_codedoc_resources_25_12.ps1")
# Old binaries repository:
# (Join-Path $scriptDir "UpdateRepo_codedoc_resources.ps1")
$binariesDir = (Join-Path $scriptDir "../codedoc_resources/")
$binariesDirGit = (Join-Path $binariesDir ".git/")
# Canonize the above two paths:
$binariesDir = (Get-CanonicalAbsolutePath $binariesDir)
$binariesDirGit =  (Get-CanonicalAbsolutePath $binariesDirGit)
# Get executables for execution of Doxygen and for setting path do GraphViz: 
$doxygenExe = (Join-Path $binariesDir "bin/doxygen/doxygen.exe")
$graphvizDir = (Join-Path $binariesDir "bin/graphviz/bin/")
$doxygenConfig = (Join-Path $scriptDir ($ConfigurationId + ".dox"))
$docDir = "generated"
if ($IsSourcesIncluded) {
    $docDir = "generated_with_sources"
}
# Calculate path to the index.html of the generated documentation:
$docFile = (Join-Path $scriptDir ($docDir + "/" + $ConfigurationId + "/html/index.html"))

Write-Host "-----------------------------------------"
Write-Host "Script parameters:"
Write-Host "  ConfigurationId:   $ConfigurationId"
Write-Host "  IsSourcesIncluded: $IsSourcesIncluded"
Write-Host "  ForceUpdates:      $ForceUpdates"
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
Write-Host "  docFile           : $docFile"
Write-Host "-----------------------------------------"

Write-Host ""
$doUpdateBinaryDirectory = $false
# Check wheter the cloned repository with binaries exists, to decide whether
# we need to clone / update the repository:
if (Test-Path -Path $binariesDirGit -PathType Container) {
    # Code to run if the directory exists
    if ($ForceUpdates) {
        Write-Host "Binaries directory exists, but binaries repo is forced.`n`n"
        $doUpdateBinaryDirectory = $true
    } else {
        Write-Host "Binaries directory exists, updating/cloning will be skipped.`n"
    }
} else {
    # Code to run if it does not exist
    Write-Host "Binaries directory does NOT exist and will be cloned.`n`n"
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

$env:DOT_GRAPH_MAX_NODES = 300
Write-Host "`nIncreased DOT_GRAPH_MAX_NODES to $($env:DOT_GRAPH_MAX_NODES) .`n"

Write-Host "`nCreating code documentation for configuration `"$ConfigurationId`"...`n"
Write-Host "Executing:"
Write-Host "  & $doxygenExe $doxygenConfig"
Write-Host "`n"
& $doxygenExe $doxygenConfig


# If specified by parameters, open the generated documentation's index.html
# in default browser:
if ($LaunchDoc) {
    Write-Host "`nLaunching the generated documentation ..."
    Write-Host "Path: $docFile`n"
    Start-Process $docFile     # should work cross-platform
    # & $docFile    # not cross-platform (need to make file executable on Linux)
}

Write-Host ""
Write-Host "Code documentation completed for `"$ConfigurationId`"."
Write-Host "-------------------------------------------------------------"
Write-Host ""




