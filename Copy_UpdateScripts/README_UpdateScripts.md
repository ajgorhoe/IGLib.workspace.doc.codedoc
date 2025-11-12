
# `codedoc` Cloning and Updating Scripts

This directory contains cloning / updating scripts for the `codedoc` repository.

Usage:

* Copy the `PowerShell` scripts and git ignore file (`UpdateOrCloneRepository.ps1`, `UpdateRepo_codedoc.ps1` and `.gitignore`) from this directory to the directory in which you want to clone the `codedoc` repository
* Adapt the settings in `UpdateRepo_codedoc.ps1` to match your situation
  * Adapt `CurrentRepo_Directory` if you want to clone the `codedoc` repository into a different directory (tha path is relative to the script location)
  * Change the `CurrentRepo_Ref` to match your repository branch where you have adapted the configuration files and generation scripts (see [the customization section](../README.md#customizing-the-repository-for-other-software-projects) of the documentation)
  * If you are using a different fork of the repository (applies to most cases), change the `CurrentRepo_Address` to match the address of your fork
* Run the `UpdateRepo_codedoc.ps1` to clone the repository.

This should work straight. Below are some additional explanations in case anything doesn't go as expected.

The `UpdateOrCloneRepository.ps1` is a general script for cloning or updating repositories, and `UpdateRepo_codedoc.ps1` contains the settings for the specific repository and it just calls the former script, passing it the settings, to clone (or update, if already cloned) the `codedoc` repository at the specified path and check out the specified branch.

Scripts and the repository clone (usually the `codedoc` directory) must be at the specified relative locations for everything to work correctly. 


