<#
.SYNOPSIS
    Script for generating a TEST documentation (configuration ID "test"; file test.dox). 

.NOTES
    Copyright © Igor Grešovnik.
    Part of IGLib: https://github.com/ajgorhoe/IGLib.workspace.doc.codedoc
	License: https://github.com/ajgorhoe/IGLib.workspace.doc.codedoc/blob/master/LICENSE.md

.DESCRIPTION
    This file generates documentation for a small experimental code project 
    located in sample_code/IGLibEventAggregator/. The aim is to have a small 
    code, for which code documentation generation is fast, so one can easily 
    experiment with different settings and observe the effects. To browse
    generated code documentation, open generated/test/html/index.html.

.PARAMETER Directory
    The local directory.


.EXAMPLE
    .\UpdateOrCloneRepository.ps1 -Directory "C:\Repos\Example" -Address "https://github.com/foo/bar.git" -Execute

    Clones or updates the repo in C:\Repos\Example, using the default remote name 'origin',
    and prints status messages to the console.

#>

param (
    [string]$ConfigurationId = "test",
    [bool]$IsSourcesIncluded = $false,
    [bool]$ForceUpdates = $false,
    [bool]$LaunchDoc = $true
)

$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptPath -Parent
$generationScript = (Join-Path $scriptDir "GenerateCodeDoc.ps1")

& $generationScript -ConfigurationId $ConfigurationId    `
    -IsSourcesIncluded $IsSourcesIncluded `
    -LaunchDoc $LaunchDoc  `
    $ForceUpdates $ForceUpdates  
    

