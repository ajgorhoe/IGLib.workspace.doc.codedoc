
rem This script generates complete documentation in Doxygen. 
rem The script must be run in the directory that contains
rem the script.

time /T

echo
echo Generating all code documentation by Doxygen...
echo

md generated

CALL .\generate_g3sim.bat
CALL .\generate_g3simall.bat
CALL .\generate_g3sim_withsources.bat
CALL .\generate_g3simall_withsources.bat



time /T
