<#
.SYNOPSIS
    Script for generating a TEST documentation (configuration ID 
    "test_with_sources"; file test_with_sources.dox).
    Except ConfigurationId and IsSourcesIncluded, which are fixed, this script
    has the same parameters as GenerateCodeDoc.ps1, which it calls to do the 
    work. Overriding their default values changes the behavior of code
    generation, but in many use cases this is not necessary and the script can
    be called without parameters.
    The LaunchDoc parameter  should be set to false wheen this script is called
    in CI/CD pipelines. If newer binaries are provided in the codedoc_resources
    repository, call this script with ForceUpdates set to true once, or just
    execute the UpdateRepo_codedoc_resources.ps1 script.

.DESCRIPTION
    This file generates documentation for a small experimental code project 
    located in sample_code/IGLibEventAggregator/. The aim is to have a small 
    code, for which code documentation generation is fast, so one can easily 
    experiment with different settings and observe the effects. To browse
    generated code documentation, open generated/test/html/index.html.

#>

# Parameters for GenerateCodeDoc.ps1 that can be modified:
param (
    [bool]$ForceUpdates = $false,
    [bool]$LaunchDoc = $true
)

# Fixed parameters for calling GenerateCodeDoc.ps1:  # this block must come after param(...)
$ConfigurationId = "test_with_sources"
$IsSourcesIncluded = $true

########################### Fixed part of the code:

# Get the script path to determine the path of the documentation generating
# script:
$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptPath -Parent
$generationScript = (Join-Path $scriptDir "GenerateCodeDoc.ps1")

# Call GenerateCodeDoc.ps1 to do the job:
& $generationScript -ConfigurationId $ConfigurationId    `
    -IsSourcesIncluded $IsSourcesIncluded `
    -LaunchDoc $LaunchDoc  `
    $ForceUpdates $ForceUpdates  
