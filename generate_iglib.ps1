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


# Prefix used for setting/retrieving global variables
$ParameterGlobalVariablePrefix = "CurrentRepo_"

$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptPath -Parent


$global:CodeDoc_ConfigurationId = "iglib"
$global:CodeDoc_IsSourcesIncluded = $null








