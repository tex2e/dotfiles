@echo off

SET SHELL_STARTUP=%AppData%\Microsoft\Windows\Start Menu\Programs\Startup

REM --- AutoHotkeyScript.ahk ---
SET AHK_SCRIPT=AutoHotkeyScript.ahk
SET AHK_EXE=AutoHotkeyScript.exe

REM 1. Compile
"C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in "%AHK_SCRIPT%" /out "%AHK_EXE%"

REM 2. Kill AutoHotKey process
TASKKILL /im "%AHK_EXE%"
TIMEOUT 1

REM 3. Move exe to shell:startup folder
MOVE /y "%AHK_EXE%" "%SHELL_STARTUP%"

REM 4. Execute AutoHotKey
START /b "AutoHotKey" "%SHELL_STARTUP%\%AHK_EXE%"
