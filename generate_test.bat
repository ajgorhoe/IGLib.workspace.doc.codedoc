@echo off

rem Generates code documentation for the specified configuraton.

rem Create local context to avoid side effects:
setlocal


rd /s /q generated\test\html\

if 1 NEQ 0 (
  measuretime generate.bat test
  goto finalize
)

:finalize

endlocal
