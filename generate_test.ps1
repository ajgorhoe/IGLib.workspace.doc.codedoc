<#
.SYNOPSIS
    Script for generating a TEST documentation (configuration ID "test"; 
    file test.dox).
    Except ConfigurationId, which is fixed, this script has the same 
    parameters as GenerateCodeDoc.ps1, which it calls. Overriding their
    default values changes the behavior of code generation, however, this
    is not needed in most cases. Exception is the LaunchDoc parameter, which 
    should be set to false wheen this script is called in CI/CD pipeline.
    Parameter $IsSourcesIncluded is also fixed, because it is determined by
    the configuration used.

.DESCRIPTION
    This file generates documentation for a small experimental code project 
    located in sample_code/IGLibEventAggregator/. The aim is to have a small 
    code, for which code documentation generation is fast, so one can easily 
    experiment with different settings and observe the effects. To browse
    generated code documentation, open generated/test/html/index.html.

#>

$ConfigurationId = "test"
$IsSourcesIncluded = $true
param (
    [bool]$ForceUpdates = $false,
    [bool]$LaunchDoc = $true
)

# Get the script path to determine the path of the documentation generating
# script:
$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptPath -Parent
$generationScript = (Join-Path $scriptDir "GenerateCodeDoc.ps1")

& $generationScript -ConfigurationId $ConfigurationId    `
    -IsSourcesIncluded $IsSourcesIncluded `
    -LaunchDoc $LaunchDoc  `
    $ForceUpdates $ForceUpdates  
