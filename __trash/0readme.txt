
# Trash directory

Used to temporarily store files and directories to be removed, and to quickly  
remove everything when wanted.

* removetrash.bat - Windows command (batch) script; initializes the directory
   (creates the save/ and trash_contents/ directories) and removes everything
   from trash_contents/
* removetrash.ps1 - PowerShell script which does the same.
* trash_contents/ - directory where you move directories and files to be 
   removed. Move files and directories here and run one of the scripts 
   mentioned above. If the directory does not exist, run the same scripts
   to create it.
* save/ - directory where you can temporarily store files and directories that
   you don't want to be removed when runing removetrash.bat or removetrash.ps.
   If the directory does not exist, run one of the above scripts to create it.
* .gitignore - imprtant only when this trash directory is used in Git 
   repositories. Prevents the files you put into save/ or trash_contents/
   directories from beiing committed (specifies that these files are ignored
   by Git).
   
## Use:

If sub-directories save/ or remove_trash don't exist, run any of the scripts
to create them.

Move directories and files that you intend to remove to remove_trash. When
sure that it is OK to remove the files, run either the rermovetrash.bat
or the removetrash.ps1 script.

When there is a need to temporarily store files or direectories that are 
intended for later deletion, or this can not be decided at this point but you
already want to move the files out of their usual location, move the files and
directories to the save/ sub-direectory. this directory is not affected by the
scripts. When you are sure that you will want to remove specific files or directories, just move them to the trash_contents/ directory and run the 
removal script to remove the contents of the directory.

REMARK about runnig the PowerShell scripts on Windows:
You may need to adjust PowerShell execution policy. In elevated PowerShell
(with administrator privilege), run:

> Set-ExecutionPolicy RemoteSigned

Run the PowerShell script by right-clicking it in File Explorer and selecting
"Run with PowerShell" in the context menu. In order to run PowerShell scripts
by double-clicking the script file, execute the following in elevated
Windows command:

> ftype Microsoft.PowerShellScript.1="%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%1" %*

There is a known issue with running PowerShell scripts by double-click on
Windows: If path of the directory where the script is located contains spaces,
the script might not run. Workaround is to run  the script by right-clicking
the script file and selecting "Run with PoweShell".

