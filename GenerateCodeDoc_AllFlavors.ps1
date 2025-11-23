
# Generates all flavors of code documentation.
Write-Host "`n`nDenerating all flavors of code documentation ...`n"

# Get the script directory such that relative paths can be resolved:
$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptPath -Parent
$scriptFilename = [System.IO.Path]::GetFileName($scriptPath)

Write-Host "`nGenerating BASIC module documentation:`n"
& $(Join-Path $scriptDir "GenerateModuleDoc.ps1")

Write-Host "`nGenerating EXTENDED module documentation:`n"
& $(Join-Path $scriptDir "GenerateModuleDocAll.ps1")

Write-Host "`nGenerating BASIC module documentation WITH SOURCES:`n"
& $(Join-Path $scriptDir "GenerateModuleDocWithSources.ps1")

Write-Host "`nGenerating EXTENDED module documentation WITH SOURCES:`n"
& $(Join-Path $scriptDir "GenerateModuleDocAllWithSources.ps1")


Write-Host "  ... generation of ALL flavors of code documentation completed.`n`n"

