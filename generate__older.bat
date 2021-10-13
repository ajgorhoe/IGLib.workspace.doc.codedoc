
REM Older generation code is stored here for reference.
REM This was saved before merging modifications drom 2015 and later, used in
REM documentation for some freelance projects (IG) whose code had to be separated
REM from IGLib.
REM WARNING: DO NOT MODIFY this file. It can be deleted when no longer needed.

set docname=%1

rem This script generates documentation for %docname% in Doxygen. 
rem The script must be run in the directory that contains
rem the script.

time /T


echo 
echo 
echo NEW GENERATION SCRIPT.
echo 
echo 


echo Generating code documentation for %docname% by Doxygen...
echo

md generated
md generated_with_sources

SET PATH=C:\Program Files (x86)\Graphviz2.38\bin;%PATH%


CALL .\copyinfo.bat
CALL doxygen %docname%.dox

time /T
