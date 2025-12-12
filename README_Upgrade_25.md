
# GrapUpgrade of Configuration Files, December 2025

Upgrade was performed on the `codedoc` repository's branch `swrepos/GrLib/NewBinaries25`, which was branched off the branch `swrepos/GrLib/repoMain`. These adaptation branches are used for the [iglibmodules container repository](https://github.com/ajgorhoe/iglibmodules/tree/swrepos/GrLib/repoMain), adapted for container of 3D graphics librarieson the *repository branch* `iglibrepo/IGLibCore/repoMain`. See `codedoc` branches [swrepos/GrLib/repoMain](https://github.com/ajgorhoe/IGLib.workspace.doc.codedoc/tree/swrepos/GrLib/repoMain) and [swrepos/GrLib/NewBinaries25](https://github.com/ajgorhoe/IGLib.workspace.doc.codedoc/tree/swrepos/GrLib/NewBinaries25).

In December 2025, a new repository with Doxygen and Graphviz binarias was prepared, the **[codedoc_resources_25_12](https://github.com/ajgorhoe/codedoc_resources_25_12)**. It it provides binaries for **`Doxygen 1.15.0`** and **`Graphviz 14.1.0`**. It replaces [codedoc_resources](https://github.com/ajgorhoe/IGLib.workspace.codedoc_resources), whihc contains binaries for `Doxygen 1.8.17` and `Graphviz 2.38` from October 2021.

## Upgrade

### Switching Between Old and New Binaries

In order to switch between the new and the old binaries, just **change in `GenerateCodeDoc.ps1`** which **script for checking out binaries repository** is called:

* `UpdateRepo_codedoc_resources.ps1` for old binaries
* `UpdateRepo_codedoc_resources_25_12.ps1` for the new binaries

If the **binaries repository** is **already checked out** at `../codedoc_resources` and it is **not the intended one** then you also need to **remove it**. Which variant of the repository is checked out at that location can be easily checked by looking at the name of the `.url` file that points to the repository, e.g. existence of the `repo__codedoc_resources_25_12.url` file means that the repository is the new one, `codedoc_resources_25_12`. On Windows OS, you can double-click the `.url` file to open the repository page on Windows. Both repositories are checked out (by the aforementioned scripts) to the same directory because binaries need to be at the same relative locations to the clone directory of the `codedoc` repository.

### Errors Reeported with the New Binaries





