
@echo off
rem Windows command file; creates the trash_contents/ and save/
rem subdirectories, removes contents of trash_contents/

echo.
echo.
echo Removing the trash_contents/ subdirectory...

setlocal
cd %~dp0
echo Base path:
echo   %~dp0
rmdir /s /q trash_contents
md trash_contents
md save
endlocal
echo   ... done.
echo.
echo.
