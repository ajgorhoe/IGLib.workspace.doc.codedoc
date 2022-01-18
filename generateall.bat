
rem This script generates complete documentation in Doxygen. 
rem The script must be run in the directory that contains
rem the script.

time /T

echo
echo Generating all code documentation by Doxygen...
echo

md generated

CALL .\generate_lgm.bat
CALL .\generate_lgm_with_sources.bat

CALL .\generate_lgmall.bat
CALL .\generate_lgmall_with_sources.bat


CALL .\generate_iglib.bat


time /T
