
# Graphic Libraries - Code Documentation Generation Tools

This branch contains tools for **generating code documentation** that are adapted **for the repositories managed by the swrepos/GrLib/repoMain branch** of the [iglibmodules container repository](https://github.com/ajgorhoe/iglibmodules). This branch of the `iglibmodules` repository is intended to host some 3D graphics libraries of my interest.

The **main branch** for code documentation for this repository **is also called `iglibrepo/IGLibCore/repoMain`**. Other branches (for specific features, fixes, etc.) can be branched off this branch and merged back afterwards.

The documentation generation directory is located in the **`_doc/codedoc/`** subdirectory of the container repository, where it is cloned or updated by the `_doc/UpdateRepo_codedoc.ps1` script. The script clones the repository and checks out the above mentioned main repository branch, or updates the repository if it is already cloned.

## Customization steps

1. Branch `swrepos/GrLib/repoMain` was created form the `iglibrepo/IGLibCore/repoMain` branch of the `codedoc` repositoruy; it will serve as the main development branch for code documentation our projects
2. In the container repository where this `codedoc` repository is embedded, on the `iglibrepo/IGLibCore/repoMain` branch, the cloning and updatind script for 'codedoc' repository was modified such that:
    * The `iglibrepo/IGLibCore/repoMain` branch is checked out
    * Additional remotes are added where the code documentation tools for this specific case will be kept
3. First commit was made to the repository and tagged `tags/swrepos/GrLib/BeginCustomization`, such that we can always know where our branch,  `swrepos/GrLib/repoMain`, became separated from its base branch, `iglibrepo/IGLibCore/repoMain`.
