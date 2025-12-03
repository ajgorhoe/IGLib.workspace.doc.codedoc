
# New IGLib Container - Code Documentation Generation Tools (branch `main`)

This branch contains tools for **generating code documentation** that are adapted **for the [new IGLib container repository](https://github.com/ajgorhoe/iglibmodules/)** (the target repository). The **branch** for code documentation for this repository **is `main`**, and it is responsible for generating documentation over multiple IGLib repositories. Other branches (for specific features, fixes, etc.) can be branched off this branch and merged back afterwards.

The documentation generation directory is located in the **`_doc/codedoc/`** directory within the target repository, where it is cloned or updated by the `_doc/UpdateRepo_codedoc.ps1` script. The script checks out the `codedoc` repository at the above mentioned branch.

Generation on this branch typically takes longer because documentation is generated for many code repositories that are cloned within the container repository. *Before generating* code documentation, make sure that all the *repositories* that are meant *to be included are cloned and updated and the intended references* (branch, tag, commit) are checked out. This is **not done automatically**, in order to allow more freedom in which repositories are included and which references are used. For standard setups, use the updating scripts at the root of the repository to ensure consistency.

## Customization for Other repositories

Tools in this repository can be easily customized for other groups of software repositories. This can be done for arbitrary repositories, but when documentation is generated for a group of repositories, this can be done by customizing both the current [codedoc repository](https://github.com/ajgorhoe/IGLib.workspace.doc.codedoc) and the [iglibmodules container repository](https://github.com/ajgorhoe/iglibmodules/).

A simple example with step-by-step description of such customization is on the branches `swrepos/GrLib/repoMain` on both repositories. In such a customization, the `iglibmodules` repository is responsible both for cloning the repositories to be documented and for cloning of customized code documentation tools in the `_doc/codedoc/` directory. Cloning and generation of code documentation is perform by simply runnning the appeopriate scripts, which are configured in the customization process. 

Information on customization for graphic libraries, with step-by-step description, is available on the `swrepos/GrLib/repoMain` branch of the [codedoc repository](https://github.com/ajgorhoe/IGLib.workspace.doc.codedoc/blob/swrepos/GrLib/repoMain/README_RepositorySpecific.md) and of the [iglibmodules repository](https://github.com/ajgorhoe/iglibmodules/blob/swrepos/GrLib/repoMain/README_Customization_GrLib.md). 

