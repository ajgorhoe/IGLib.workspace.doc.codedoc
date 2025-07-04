<#
    .SYNOPSIS
    Updates or clones a specific repository by calling UpdateOrCloneRepository.ps1 
    with parameters set through global variables.

    .DESCRIPTION
    This script defines a set of variables named with the 'CurrentRepo_' prefix in 
    the same order as UpdateOrCloneRepository.ps1 parameters. Then, it invokes 
    UpdateOrCloneRepository.ps1 *without* passing parameters, relying on 
    -DefaultFromVars to pick up the values from these global variables.
	
	When repository directory is specified as relative path, path is
	resolved with the scrit directory as base path.

    .NOTES
    Make sure UpdateOrCloneRepository.ps1 is accessible at the path specified in 
    $UpdatingScriptPath (absolute or relative).
#>

Write-Host "`n`n======================================================="
Write-Host "Updating/cloning a specific repository..."

########################################################################
# Custom section (USER DEFINED):

# Path to UpdateOrCloneRepository.ps1
$UpdatingScriptPath = "./UpdateOrCloneRepository.ps1"

# Define parameter variables for UpdateOrCloneRepository.ps1
#    in the same order as that script's parameters:

$global:CurrentRepo_Directory = "../IGLibScripting/"
$global:CurrentRepo_Ref = "main"
$global:CurrentRepo_Address = "https://github.com/ajgorhoe/IGLib.modules.IGLibScripting.git"
$global:CurrentRepo_Remote = "origin"
$global:CurrentRepo_AddressSecondary = $null
$global:CurrentRepo_RemoteSecondary = $null
$global:CurrentRepo_AddressTertiary = "d:/backup_sync/bk_code/git/ig/misc/iglib_modules/IGLibScripting"
$global:CurrentRepo_RemoteTertiary = "local"
$global:CurrentRepo_ThrowOnErrors = $false

# End of custom section
########################################################################

# $global:CurrentRepo_DefaultFromVars = $true # params set from variables above
$global:CurrentRepo_BaseDirectory = $null   # base dir will be set to script dir 

# Set CurrentRepo_BaseDirectory to the directory containing this script:
$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptPath -Parent
$scriptFilename = [System.IO.Path]::GetFileName($scriptPath)

# Set base directory for relative paths to the current script's directory:
$global:CurrentRepo_BaseDirectory = $scriptDir

# If $UpdatingScriptPath is a relative path, convert it to absolute
if (-not [System.IO.Path]::IsPathRooted($UpdatingScriptPath)) {
    $UpdatingScriptPath = Join-Path $scriptDir $UpdatingScriptPath
}

# Write-Host "`n${scriptFilename}:"
# Write-Host "  CurrentRepo_Directory: $CurrentRepo_Directory"
# Write-Host "  CurrentRepo_Address: $CurrentRepo_Address"
# Write-Host "  CurrentRepo_Ref: $CurrentRepo_Ref"
# # Write-Host "  UpdatingScriptPath: $UpdatingScriptPath"
# # Write-Host "  CurrentRepo_BaseDirectory: $CurrentRepo_BaseDirectory `n"

# Print all variables used as settings for updating / cloning repositories:
Write-Host "-------------------------------------------------------"
Write-Host "Variables for repository updating / cloning scripts:"
Write-Host "  CurrentRepo_Directory: $CurrentRepo_Directory"
Write-Host "  CurrentRepo_Ref:       $CurrentRepo_Ref"
Write-Host "  CurrentRepo_Address:   $CurrentRepo_Address"
Write-Host "  CurrentRepo_Remote:    $CurrentRepo_Remote"
Write-Host "  CurrentRepo_AddressSecondary: $CurrentRepo_AddressSecondary"
Write-Host "  CurrentRepo_RemoteSecondary:  $CurrentRepo_RemoteSecondary"
Write-Host "  CurrentRepo_AddressTertiary:  $CurrentRepo_AddressTertiary"
Write-Host "  CurrentRepo_RemoteTertiary:   $CurrentRepo_RemoteTertiary"
Write-Host "  CurrentRepo_ThrowOnErrors:    $CurrentRepo_ThrowOnErrors"
#
Write-Host "  CurrentRepo_DefaultFromVars:  $CurrentRepo_DefaultFromVars"
Write-Host "  CurrentRepo_BaseDirectory   : $CurrentRepo_BaseDirectory"
#
Write-Host "---------------------------------------------------------"

# # Uncomment the line below only when the print script exists!
# & (Join-Path $scriptDir PrintSettingsUpdateOrClone.ps1)

# Invoke UpdateOrCloneRepository.ps1 with no parameters, 
#    so it uses the global variables defined above:
Write-Host "`nCalling update script without parameters; it will use global variables..."
& $UpdatingScriptPath -Execute -DefaultFromVars

Write-Host "`nUpdating or cloning the repository completed."
Write-Host "---------------------------------------------------------`n`n"
