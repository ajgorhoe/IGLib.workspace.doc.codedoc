
This directory contains generated code documentation that includes source
code.
The contained directories are therefore ignored.

Yet the directory itself is part of repository in because this arrangement
creates less trouble for maintenance and testing of code doc. generation.

When Doxygen is run directly by providing the configuration file, it 
does not run properly unless the containing directory of generated
documentation already exists.
Such a situation can be tricky because in console output, error 
notification is generated that is deceiving and hides the true cause of
error. The log file must be checked to get a clue of the cause. If the 
containing directory for code generation exits beforehand, such difficulties
are avoided altogetther.
 
