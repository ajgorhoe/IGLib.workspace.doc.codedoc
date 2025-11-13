
# Code Documentation Generation Tools (codedoc)

**Contents**:

* See also:
  * **[Specifics for the Target Repository](./README_RepositorySpecific.md)**
* [About this Repository](#about-this-repository)
  * [List of Branches](#list-of-repository-branches)
* [Use with IGLib](#use-with-the-investigative-generic-library-iglib)
* [Customizing the Repository for Other Software Projects](#customizing-the-repository-for-other-software-projects)
* [Use with the Legacy IGLib](#use-with-the-legacy-iglib)
* [Misc Remarks](#miscellaneous-remarks)

## About this Repository

This repository contains *scripts for generating **[code documentation](CodeDocumentation.html)*** for *IGLib ([legacy](https://github.com/ajgorhoe/IGLib.workspace.base.iglib/blob/master/README.md) & [new](https://github.com/ajgorhoe/IGLib.modules.IGLibCore/blob/main/README.md))* and other software projects. It uses **[Doxygen](https://www.doxygen.nl/index.html)** with **[Graphviz](https://graphviz.gitlab.io/)** to generate a rich and easily readable HTML documentation of computer code ([example can be seen here](https://ajgorhoe.github.io/IGLibFrameworkCodedoc/generated/16_04_igliball_1.7.2/html/d4/d6b/classIG_1_1Num_1_1BoundingBox.html)). The repository can be [easily customized to support other software projects](#customizing-the-repository-for-other-software-projects).

Doxygen and other binaries are automatically downloaded (by cloning a dedicated repository) when documentation is generated via scripts. Currently, documentation can only be generated on Windows because the binaries are provided only for this OS. This can be fixed by providing binaries for other systems and adding them to the binaries repository. Currently, the cross-platform scripts don't use system's installation of Doxygen and GraphViz (the older batch scripts have this possibility), but this can be fixed, too.

### List of Repository Branches

This repository uses different **branches** to contain code documentation generation scripts **for different target repositories**. Since setting may different a lot between different repositories, these branches will not be merged into one another. If some developments can be copied between them, this will be done manually. **Main repository branches** related to IGLib are the following ([as explained here](#customizing-the-repository-for-other-software-projects), the `codedoc` repository can be easily adapted for other repositories, too):

* **`main`** ([browse here](https://github.com/ajgorhoe/IGLib.workspace.doc.codedoc/tree/main/)) - `codedoc` utilities for the **[new IGLib container repository](https://github.com/ajgorhoe/iglibmodules/)** , located in `_doc/codedoc/`. This also includes documentation for some legacy IGLib repositories (still used with the new IGLib) managed by the new container repository
* **`iglibrepo/iglibcontainerLegacy/repoMain`** ([browse here](https://github.com/ajgorhoe/IGLib.workspace.doc.codedoc/tree/iglibrepo/iglibcontainerLegacy/repoMain/)) - `codedoc` utilities for the **[legacy IGLib container repository](https://github.com/ajgorhoe/iglibcontainer/)**, located in `ws/workspace/codedoc/`
* **`iglibrepo/IGLibCore/repoMain`** ([browse here](https://github.com/ajgorhoe/IGLib.workspace.doc.codedoc/tree/iglibrepo/IGLibCore/repoMain/)) - `codedoc` utilities for the **[IGLibCore repository](https://github.com/ajgorhoe/IGLib.modules.IGLibCore/)** (the base reposiory for the new IGLib), located at `doc/codedoc/` within the repository; this branch can be used as template for customization for other repositories.

For feature development and other tasks, sub-branches can be branched off the main repository brenches and later merged back.

**Current development and future plans**:

In July 2025, all maintained configurations switched to PowerShell scripts instead of batch scripts, which simplified the scripts and made them cross-platform.

In November 2025, main repository branches were introduced (see above), which contain configuration and scripts for different target repositories. This makes customization and adaptation for new repositories much easier. Complete scripts for legacy IGLib (the "Framework" version) that work with the [old repo container](https://github.com/ajgorhoe/iglibcontainer) (`generate_iglib.ps1`, etc.) are lef in the repository on the legacy branch (`iglibrepo/iglibcontainerLegacy/repoMain`).

 In the future, the ability to **use Doxygen and Graphviz from system installation** might be added to the PowerShell generation scripts. This possibility was provied by the old batch scripts that were removed (except on the legacy branch).

## Use with the Investigative Generic Library (IGLib)

The easiest way to use this repository for generating code documentation for the new IGLib libraries is via the *IGLib container repository*. First, **clone the container repository** located at:

> https://github.com/ajgorhoe/iglibmodules

Then, **run one of the clone/update *[PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell)* scripts** in the cloned container repository in order to clone the source code repositories from which code documentation will be generated. For example, run the

`UpdateRepos_Extended.ps1`

**Change directory to the cloned *igmodules* repository**, then **run the *PowerShell*** (*Windows*) or the [*cross-platform PowerShell (**pwsh**)* (*Windows, Linux, MacOS*...)](https://github.com/PowerShell/PowerShell) and **execute** the command

`./UpdateRepoGroup_Extended.ps1`

Alternatively, you can run the following command *in system command shell*:

`pwsh -File ./UpdateRepoGroup_Extended.ps1`

(you can use `PowerShell` instead of `pwsh` on Windows). You can *[download PowerShell here](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell)*.

Next, you need to **clone the **codedoc** repository** at the correct location. In the cloned *igmodules* repository, **change directory to the *_doc/*** subdirectory and run the following command in PowerShell:

`./UpdateRepo_codedoc.ps1`

Then, **change directory to the *_doc/codedoc/*** subdirectory of the cloned *igmodules* repository and **run one of the scripts** for generating IGLib code documentation:

* `GenerateDocIGLib.ps1` generates the basic IGLib code documentation.
* `GenerateDocIGLibAll.ps1` generats the *extended* IGLib code documnentation, with some additional code included in generation, such as tests, experimental code and some external libraries.
* `GenerateDocIGLibWithSources.ps1` generates the basic IGLib documentation (from the same sources as 'GenerateDocIGLib.ps1'), but *with source code included* (in form of HTML) in the documentation. This features the powerful linkage between the documentation and definitions of documented entities in the source code, and vice versa.
* `GenerateDocIGLibAllWithSources.ps1` generats the *extended* IGLib code documnentation (from the same sources as 'GenerateDocIGLibAll.ps1'), but *with source code included* (in form of HTML) in the documentation. This documentation features the powerful linkage between the documentation and definitions of documented entities in the source code, and vice versa.

Documentation that does not include source code is *generated in the `_doc/codedoc/generated/`* subdirectory of the cloned *igmodules* repository, and documentation that includes source code is *generated in `_doc/codedoc/generated_with_sources/`*. Such separation is a common practice in generation of code documentation with this repository because deployment of documentation that includes complete source code is in many cases more restricted than documentation without source code.

After the particular flavor of code documentation is generated, it is usually opened in the default browser. The generated code documentation can also be conveniently browsed from the following index page within the cloned *igmodules* repository:

> ***[_doc/codedoc/CodeDocumentation.html](./CodeDocumentation.html)***

## Customizing the Repository for Other Software Projects

This repositoty can be easily utilized for generation of code documentation for other purposes. All that is needed is to **add or adapt the appropriate Doxygen configuration files and scripts for triggering generation**. These files should be adapted **on a new ["repository" branch](#list-of-repository-branches)** because the original repository is meant to be used for the new `IGLib` only. The simplest way is to create a new branch from the `iglibrepo/IGLibCore/repoMain` repository branch and adapt paths, descriptions and titles in the `.dox` configuration files. It is also recommended to create your own **fork of the `codedoc` repository**. Then, **copy the cloning / updating scripts** (`UpdateOrCloneRepository.ps1` and `UpdateRepo_codedoc.ps1`) from the [Copy_UpdateScripts/](./Copy_UpdateScripts/) directory to the directory where you will clone the `codedoc` repository and update settings in the latter script (relative path to clone directory, branch to check out, and `codedoc` repository address if you use a fork of the repository). Next, in the `codedoc` repository cloned and set to the new branch by the `UpdateRepo_codedoc.ps1` script, **adapt the `.docx` configuraion files** (especially the `INPUT` setting) to match your own situation, such as relative path to directories containing source files (see the [update scripts directory's README](./Copy_UpdateScripts/README_UpdateScripts.md)). After you can successfully generate the documentation, you can also rename script files, configuration directories, and output directories, remove unnecessary configurations and scripts or add new ones, and adapt the [HTML file with links to documentation](./CodeDocumentation.html). This is all it takes to customize the `codedoc` repository for generating good code documentation for your software, and it can be done in couple of hours. A more verbose description is below, in case it is needed.

Below is a sequence of steps that will make use of your customized scripts really comfortable.

* **Decide where** to put the code documentation tools (this repository). The best possibility is to put it within another repository that contains the code to be documented, or in a special place of a container repository, which will contain clones of several repositories whose code you want to document (this approach is [used in case of IGLib](#use-with-the-investigative-generic-library-iglib)). In this way, when/whereever you clone the original repositories, you will have documentation generation tools at hand.
* **Create** your own **fork of the *codedoc* repository**.
  * Do not touch the main branch. Create a new branch to contain your scripts and configurations.
  * You can always update the improved general tools from the original repository. Just *set the original codedoc repository as one of remotes*, then you can *occasionally pull changes from the main branch of the original codedoc repository*.
* Next to the location where you want to have the *codedoc* repository cloned, **copy the cloning/updating scripts *[UpdateRepo_codedoc.ps1](https://github.com/ajgorhoe/iglibmodules/blob/main/_doc/UpdateRepo_codedoc.ps1)* and *[UpdateOrCloneRepository.ps1](https://github.com/ajgorhoe/iglibmodules/blob/main/_scripts/UpdateOrCloneRepository.ps1)***. You may need to **correct** the `UpdateRepo_codedoc.ps1`, such that the variable `UpdatingScriptPath` contains teh correct relative path (with respect to the script) of the `UpdateOrCloneRepository.ps1` scripts (in the link, the relative path is adapted to the situation in the *codedoc* repository where the scripts are located in different directories).
* In your forked *codedoc* repository, **create the branch that will contain your customizations**.
* In the ***`UpdateRepo_codedoc.ps1` script*** that you have copied to clone or update the forked *codeedoc* repository, make the following changes:
  * Change the ***`global:CurrentRepo_Ref`*** variable such that it contains the name of **your dedicated branch** containing your customizations.
  * Change the ***`global:CurrentRepo_Address`*** variable such that it contains the **address of your forked *codedoc* repository**.
  Set variables ***`global:CurrentRepo_AddressSecondary`*** and **`global:CurrentRepo_AddressTertiary`** to **empty strings**, or (if you will maintain several mirror repositories), set them to the addresses of your mirror repositories of the forked *codedoc* repository.
* **customize your dedicated branch**:
  * **Add the PowerShell generation scripts** for generating different flavors / versions of your code documentation. You can use the `GenerateDocIGLib.ps1` as template.
  * For each generation script, **add the corresponding Doxygen configuration file**. You can use the `DocIGLib.dox` as template.
  * Take care of the following:
    * In the generation script, you will probably only need to modify the fixed parameters:
      * Choose the suitable value for ***`ConfigurationId`***, which identifies the configuration of documentation generation. This **must correspond to the name of your Doxygen configuration file** (**without the extension** *.dox*), and will also be the name of the subdirectory in which the code documentation is generated.
      * Set the ***`IsSourcesIncluded`*** to either **`$true`** (if **sources** are **included** in the generated documentation) or **`$false`** (if **sources** are **not included**).
        * **Important**: the value **must correspond to the value of the `SOURCE_BROWSER` configuration option** in the corresponding **Doxygen configuration file (.dox)** (where it must be **`YES`** for `$true` and **`NO`** for `$false`).
    * In the **corresponding Doxygen configuration file**, make sure to **adapt** the following **configuration options** according to your specific options:
      * `PROJECT_NAME`, `PROJECT_BRIEF` (title and short description), which are dispayed in the generated documentation to distinguish different documentations and provide short information, and `PROJECT_LOGO` (an icon also displayed in the documentation).
      * `OUTPUT_DIRECTORY` - the directory where the documentation will be generated, relative to the configuration file. You can keep using the IGLib's conventions: documentations without source code are generated in the `generated/` subdirectory of the `codedoc` repository, and documentaitons with source code included are generated in the `generated_with_sources` subdirectory. Within these directories, there is another directory, which by IGLib convention should have the same name as the Doxygen configuration file used (without the `.dox` extension).
      * `INPUT` specifies the directories (and / or files) from which the source code for generated documentation is obtained. Paths are relative to the location of Doxygen configuration file. You can put each entry in a separate line and end lines with a backslash character `\`, which tell the configuration parser that the next line is also part of the value assigned to the configuration option.
        * `FILE_PATTERNS` specifies file extensions of the files that should be accounted for in the generated documentation. If the documented software projects contain code in programming languages different than specified in the current configuration, source files extensions used should be added here.
        * `EXCLUDE` contains the directories and files that should be excluded from the generated documentation.
      * `WARN_LOGFILE` specifies the file where warning and error messages are written to. Specify a different log file for each configuration and give it the same name as the configuration itself, this will simplify things.
    * Check fo eventual other configuration options that you might want to modify.
* It is recommended to ***clean the branch*** containing your custom scripts (delete files and directories that you don't need), such that it is easily navigate the directory and find stuff.
  * **Leave** the **`GenerateCodeDoc.ps1`**, **`UpdateOrCloneRepository.ps1`**, and **`UpdateRepo_codedoc_resources.ps1`** scripts untouched, because they are crucial for source generation.
  * It is recommended to leave the directories `css/` (contains custom cascading style sheets that you can use to nicely format the documentation), `sample_code/` (contains sample code for test generation, which is very fast and us useful to experiment with different configuration options), and `generated` and `generated_with_sources` directories.
  * It is recommended to *leave the test generation scripts and configurations* (`generate_test.ps1`, `generate_test_with_sources.ps1`, `test.dox`, and `test_with_sources.dox`) on the bustomized branch. These generate two flavors of documentation (one without the source code and the other including the source code) for a small code set. Generations are very fast and therefore these files are suitable for playing with different configuration options or different ways of launching the generation scripts.
  * Apart from the above, you can remove all generation scripts and Doxygen configurations that you don't need, i.e., the following pre-existing files:
    * `generate_*.bat`, `*.dox`, `generate_*.ps1`, `GenerateDoc*.ps1` (except those created by yourself as part of customization).
    * If you will not use batch scripts for generation (the old way of using the repository), then you can delete all `.bat` files and also the `bootstrappingscripts` auxiliary directory.
  * **Modify `CodeDocumentation.html` or replace it** with your own file, such that the HTML file contains links to your own generated code documentation indices for easier browsing.  

## Use with the Legacy IGLib

In order to use this repository, clone it by using the IGLib container repository located at:

> *https://github.com/ajgorhoe/iglibcontainer.git*

After cloning the repository, navigate to the **workspace/base/** subdirectory and run the PowerShell script

`UpdateRepoGroup_Extended.ps1`

without parameters. This will clone all the repositories needed to create code documentation. Next, navigate to the **workspace/base/** subdirectory and run the PowerShell script

`UpdateRepo_codedoc.ps1`

(also without parameters). This will clone the `codedoc` direectory that contains the generation scripts and other necessary ingredients. Navigate to the **workspace/codedoc/** subdirectory and run one of the generations scripts, for example

`generate_iglib.ps1`

After running this script, a basic IGLib code documentation should be generated in *workspace/codedoc/**, in the following subdirectory:

`generated/iglib/html/`

Open the `index.html` in order to browse the documentation. Its complete path relative to the `codedoc` clone directory should be:

> .../workspace/codedoc/generated/iglib/html/index.html

You can also open the

> ...//workspace/codedoc/CodeDocumentation.html

file, which contains links to various flavors of the generated documentation. Links will work only after the documentation is generated. Normally, documentation should also be launched in a browser after generation.

There are **different flavors of documentation** for the same code project, which you can generate by running different scripts:

* `generate_iglib.ps1` creates the most basic IGLib documentation.
* `generate_iglib_all.ps1` creates basic documentation, but include extended set of code not included in the previous configuration, such as tests and some external libraries.
* `generate_iglib_with_sources.ps1` includes source code in the generated documentation. functions, classes, properties, etc., are linked to their definition of syntax-highlighted source code represented in HTML. Conversely, entities in code are back-linked to their documentation, which is a truly powerful feature that makes navigation easy.
* `generate_igliball_with_sources.ps1` creates documentation for extended set of sources, with source code included.

For additional information, you can also check the readme file of the above container repository (e.g., for information about how to properly clone and use IGLib repositories). Useful informatoin can also be found in the `README.md` file of IGLib base repository located at:

> *https://github.com/ajgorhoe/IGLib.workspace.base.iglib.git*

## Miscellaneous Remarks

### Important - Running Doxygen directly

When running Doxygen directly (not through scripts and passing only the configuration file), directories where generated documentation is put must already exist (Doxygen will not create it and will exit with unrelated error message if the directory does not exist).

Logs will give you better information that console output if Doxygen 
fails.

**Important**:
The following things must match for each kind of documentaion:

* Environment variable ConfigurationID set in the generation script
* Name of Doxygen configuration file
* Name of output directory in the above file, under OUTPUT_DIRECTORY

Location: `.../workspace/doc/codedoc/`

This directory contains source code documentation that is generated by Doxygen.

In order to update (re-create) documentation, run one of the configuration
files with Doxygen, e.g.

~~~shell
doxygen iglib.dox
~~~

You can edit configuration files by any text editor, or by a GUI-driven configuration tool (doxygen graphical front end) named doxywizard, e.g.

~~~shell
doxyvizard iglib.dox
~~~

Use if doxywizard is not very recommended, however, especially not to correct  path information.

## License and Terms of Use

Copyright (c) Igor Grešovnik
See [LICENSE.md](./LICENSE.md) ([original is located here](https://github.com/ajgorhoe/IGLib.workspace.doc.codedoc/blob/master/LICENSE.md)) for terms of use.

This repository is part of the *[Investigative Generic Library](https://github.com/ajgorhoe/IGLib.modules.IGLibCore/blob/main/README.md) (**IGLib**)*.

Disclaimer:  
The repository owner reserves the right to change the license to one of the permissive open source licenses, such as the Apache-2 or MIT license.

