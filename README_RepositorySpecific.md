
# New IGLib Container - Code Documentation Generation Tools

This branch contains tools for **generating code documentation** that are adapted **for the [new IGLib container repository](https://github.com/ajgorhoe/iglibmodules/)** (the target repository). The **main branch** for code documentation for this repository **is `main`**. Other branches (for specific features, fixes, etc.) can be branched off this branch and merged back afterwards.

The documentation generation directory is located in the **`_doc/codedoc/`** directory within the target repository, where it is cloned or updated by the `_doc/UpdateRepo_codedoc.ps1` script. The script checks out the `codedoc` repository at the above mentioned branch.

Generation on this branch typically takes longer because documentation is generated for many code repositories that are cloned within the container repository. Before generating code documentation, make sure that all the repositories that are meant to be included are cloned and updated and the intended references (branch, tag, commit) are checked out. Use the updating scripts at the root of the repository to ensure that.
