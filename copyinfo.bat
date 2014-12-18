
set iglib1=..\..\base\iglib\License_IGLib_Redistributable.html
set iglib2=..\..\base\iglib\ReadMe_IGLib.html

set dociglib1=generated\iglib
set dociglib2=generated\iglib\html

set dociglib01=generated_with_sources\iglib
set dociglib02=generated_with_sources\iglib\html

set dociglib3=generated\develop
set dociglib4=generated\develop\html

set dociglib5=generated\simulationtools
set dociglib6=generated\simulationtools\html

set dociglib7=generated\shell
set dociglib8=generated\shell\html


mkdir %dociglib1%
mkdir %dociglib2%
copy /y %iglib1% %dociglib1%
copy /y %iglib2% %dociglib2%

mkdir %dociglib01%
mkdir %dociglib2%
copy /y %iglib1% %dociglib01%
copy /y %iglib2% %dociglib02%

copy /y %iglib1% %dociglib2%
copy /y %iglib2% %dociglib2%

mkdir %dociglib3%
mkdir %dociglib4%
REM copy /y %iglib1% %dociglib3%
REM copy /y %iglib2% %dociglib3%
copy /y %iglib1% %dociglib4%
copy /y %iglib2% %dociglib4%

mkdir %dociglib5%
mkdir %dociglib6%
REM copy /y %iglib1% %dociglib5%
REM copy /y %iglib2% %dociglib5%
copy /y %iglib1% %dociglib6%
copy /y %iglib2% %dociglib6%

mkdir %dociglib7%
mkdir %dociglib8%
REM copy /y %iglib1% %dociglib7%
REM copy /y %iglib2% %dociglib7%
copy /y %iglib1% %dociglib8%
copy /y %iglib2% %dociglib8%







