
# `codedoc` Cloning and Updating Scripts

This directory contains cloning / updating scripts for the `codedoc` repository.

Usage:

* Copy the `PowerShell` scripts and git ignore file (`UpdateOrCloneRepository.ps1`, `UpdateRepo_codedoc.ps1` and `.gitignore`) from this directory to the directory in which you want to clone the `codedoc` repository
* Adapt the settings in `UpdateRepo_codedoc.ps1` to match your situation
  * Adapt `CurrentRepo_Directory` if you want to clone the `codedoc` repository into a different directory (tha path is relative to the script location)
  * Change the `CurrentRepo_Ref` to match your repository branch where you have adapted the configuration files and generation scripts (***see [the customization section](../README.md#customizing-the-repository-for-other-software-projects)*** of the documentation)
  * If you are using a different fork of the repository (applies to most cases), change the `CurrentRepo_Address` to match the address of your fork
* Run the `UpdateRepo_codedoc.ps1` to clone the repository.

This should work straight. Below are some additional explanations in case anything doesn't go as expected.

The `UpdateOrCloneRepository.ps1` is a general script for cloning or updating repositories, and `UpdateRepo_codedoc.ps1` contains the settings for the specific repository and it just calls the former script and passes it the settings. This clones (or updates, if already cloned) the `codedoc` repository at the specified path and checks out the specified branch.

Scripts and the repository clone (usually the `codedoc` directory) must be at the configured relative locations with respect to the target code repository (for which documentation should be generated) for everything to work correctly:

  * In `UpdateRepo_codedoc.ps1`, the `UpdatingScriptPath` specifies the relative location of `UpdateRepo_codedoc.ps1`, and `CurrentRepo_Directory` specifies relative path where the `codedoc` repository is cloned
  * Within the cloned `codedoc` repository, script files need to correctly specify relative paths of the other scripts they call and of the configuration files for generating documentation (`.docx`) they use. The configuration files need to correctly define relative paths of source file directories. In particular, check the following settings in `.dox` files:
    * `STRIP_FROM_PATH`
    * `INPUT`
    * `EXCLUDE`

Running the appropriate generation script should create the documentation and open it in the browser, such that you can see the results immediately. Afterwards, you can access the documentation via 

If something still goes wrong 
