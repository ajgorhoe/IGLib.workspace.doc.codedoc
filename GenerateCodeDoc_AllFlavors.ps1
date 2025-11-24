
# Generates all flavors of code documentation.
Write-Host "`n`nDenerating all flavors of code documentation ...`n"

# Get the script directory such that relative paths can be resolved:
$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptPath -Parent
$scriptFilename = [System.IO.Path]::GetFileName($scriptPath)

Write-Host "`nGenerating BASIC IGLib documentation:`n"
& $(Join-Path $scriptDir "GenerateDocIGLib.ps1")

Write-Host "`nGenerating EXTENDED IGLib documentation:`n"
& $(Join-Path $scriptDir "GenerateDocIGLibAll.ps1")

Write-Host "`nGenerating BASIC IGLib documentation WITH SOURCES:`n"
& $(Join-Path $scriptDir "GenerateDocIGLibWithSources.ps1")

Write-Host "`nGenerating EXTENDED IGLib documentation WITH SOURCES:`n"
& $(Join-Path $scriptDir "GenerateDocIGLibAllWithSources.ps1")


Write-Host "  ... generation of ALL flavors of code documentation completed.`n`n"

