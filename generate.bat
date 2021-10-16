
REM The legacy general script for generation of code documentation, adapted
REM to new way of generation.
REM This enables use of the older specific generation scripts (like 
REM generate_simulationtools.bat) that have not switched to the newed general
REM generation script.
REM Script arguments:
REM   Arg. 1: ID of documentation configuration (expected but one can define REM     environment variable ConfigurationID instead).
REM   Arg. 2: whether source code is included in the generation (optional,
REM     default is 1); must coincide witth actual configuration parameter
REM     SOURCE_BROWSER in the .dox file.

REM The current script just redirects the call to the GenerateCodeDoc.bat
REM script, after adaptation of parameters.

REM The simpler original legacy script is saved in generate__older.bat .

setlocal 

set docname=%1

rem This script generates documentation for %docname% in Doxygen. 
rem The script must be run in the directory that contains
rem the script.

time /T


echo 
echo 
echo OLD GENERATION SCRIPT.
echo 
echo 


echo Generating code documentation for %docname% by Doxygen...
echo

md generated
md generated_with_sources

SET PATH=C:\Program Files (x86)\Graphviz2.38\bin;%PATH%


CALL .\copyinfo.bat

REM Older way:
REM CALL doxygen %docname%.dox

REM New way - delegate generation to the new script:
rem take into account script arguments:
set NumArgs=0
for %%d in (%*) do set /A NumArgs+=1
if %NumArgs% GEQ 1 (set ConfigurationID=%1)
if %NumArgs% GEQ 2 (set IsSourcesIncluded=%2) 
rem Take default value if parameter is not defined at this point:
if not defined IsSourcesIncluded (set IsSourcesIncluded=0)
rem Delegate generation to the new script:
call "%~dp0\GenerateCodeDoc.bat" %*
endlocal

time /T
