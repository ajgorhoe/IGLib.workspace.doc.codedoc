
REM New developments wil be added here.

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
