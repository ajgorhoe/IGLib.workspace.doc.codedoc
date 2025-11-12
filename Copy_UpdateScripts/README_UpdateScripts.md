
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

## Tips for Customizing the `codedoc` repository for Generation of Code Documentation for Your Software

The `UpdateOrCloneRepository.ps1` is a general script for cloning or updating repositories, and `UpdateRepo_codedoc.ps1` contains the settings for the specific repository and it just calls the former script and passes it the settings. This clones (or updates, if already cloned) the `codedoc` repository at the specified path and checks out the specified branch.

Scripts and the repository clone (usually the `codedoc` directory) must be at the configured relative locations with respect to the target code repository (for which documentation should be generated) for everything to work correctly:

* In `UpdateRepo_codedoc.ps1`, the `UpdatingScriptPath` specifies the relative location of `UpdateRepo_codedoc.ps1`, and `CurrentRepo_Directory` specifies relative path where the `codedoc` repository is cloned
* Within the cloned `codedoc` repository, script files need to correctly specify relative paths of the other scripts they call and of the configuration files for generating documentation (`.docx`) they use. The configuration files need to correctly define relative paths of source file directories. In particular, check the following settings (tags) in `.dox` files:
  * `INPUT` (code directories and files included in documentation)
  * `EXCLUDE`  (directories or files within the previous that are excluded from documentation)
  * `OUTPUT_DIRECTORY`  (location of generated documentation)
  * `STRIP_FROM_PATH`  (this part of relative paths is removed when paths are displayed)
  * `WARN_LOGFILE`  (log file for the configuration, useful for debugging when something goes wrong)
  * It is also helpful to set the following settings in a meaningful way:
    * `PROJECT_NAME` (appears as title)
    * `PROJECT_NUMBER`  (version number)
    * `PROJECT_BRIEF`  (short description)
    * `PROJECT_LOGO` (icon or logo - optional)

Running the appropriate generation script should create the documentation and open it in the browser, such that you can see the results immediately. Afterwards, you can access the documentation via 

If there is still something that goes wrong persistently, you can try the following:

* Run the `generate_test.ps1` and `generate_test_with_sources.ps1` scripts. They generate code documentation for a small sample code project that is located within the repository itself, therefore at predictable relative location with respect to the script. The generation lasts seconds instead of minutes (or hours for really large code bases), which makes it easier to experiment. If this generation fails then there is really something seriously wrong. If it succeeds and your adapted scripts / configurations fail, then something is wrong there. The first things to check would be whether the nested scripts are actually called, and whether the relative path in configuration files are correct (also, are the target source code projects actually checked out).
  * If these simpler cases work, they are a good starting point to figure out crucial dependencies: which downstream scripts are called form the specific generation script, what is the final Doxygen command that is called, how the configuration file (`.dox`) is passed to Doxygen, etc.
  * If the simple cases don't work, check the logs. Sometimes there may be breaking changes in Doxygen configuration files and you may use a newer version of the software, which breaks things (actually, this is why Doxygen is run from stored binaries of certain version). Run generation from command-line shell and check the logs.
* You can also check how things are done for another software project, such as [IGLibCore](https://github.com/ajgorhoe/IGLib.modules.IGLibCore/):
  * Clone the `IGLibCore` repository
  * Open the directory where the `codedoc/` repository clone should be located (in this case, the `doc/` subdirectory of the cloned `IGLibCore` repository)
  * Run the `codedoc` clone / update script, the `UpdateRepo_codedoc.ps1` (located in the `doc/` subdirectory)
  * Open the repository clone directory (in this case `doc/codedoc/`), and run one of the `PowerShell` scripts (extension `.ps1`) for generating a specific type of code documentation
  * If the script works correctly and successfully generates the documentation, you can check how it calls other scripts for generation and how configuration file is passed to the final command that runs `Doxygen`. You can also check the `.dox` configuration files that is used and see how paths andd other settings should b defined.
