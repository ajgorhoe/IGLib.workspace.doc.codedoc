
# IGLibCore - Code Documentation Generation Tools

This branch contains tools for **generating code documentation** that are adapted **for the [IGLibCore repository](https://github.com/ajgorhoe/IGLib.modules.IGLibCore/)**. The **main branch** for code documentation for this repository **is `iglibrepo/IGLibCore/repoMain`**. Other branches (for specific features, fixes, etc.) can be branched off this branch and merged back afterwards.

The documentation generation directory is located in the **`doc/codedoc/`** directory, where it is cloned or updated by the `doc/UpdateRepo_codedoc.ps1` script. The script clones the repository and checks out the above mentioned main repository branch, or updates the repository if it is already cloned.

This branch can serve as template for [adapting](./README.md#customizing-the-repository-for-other-software-projects) the **[`codedoc` repository](https://github.com/ajgorhoe/IGLib.workspace.doc.codedoc)** for generation of code documentation for other source code projects.
