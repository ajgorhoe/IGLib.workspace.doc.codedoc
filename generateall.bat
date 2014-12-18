
rem This script generates complete documentation in Doxygen. 
rem The script must be run in the directory that contains
rem the script.

time /T

echo
echo Generating all code documentation by Doxygen...
echo

md generated

CALL .\generate_iglib.bat
CALL .\generate_iglib_withsources.bat
CALL .\generate_pythontools.bat

CALL .\generate_develop.bat
CALL .\generate_develop_nafems.bat
CALL .\generate_guest_marko_petek.bat
CALL .\generate_NeurApp.bat
CALL .\generate_shell.bat
REM CALL .\generate_simulationtools.bat


time /T
