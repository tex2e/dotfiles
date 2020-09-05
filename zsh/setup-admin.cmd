@echo off

SET TO_DIR=%HomeDrive%%HomePath%
SET FROM_DIR=%~dp0

call :backup_and_mklink .zshenv
call :backup_and_mklink .zshrc

echo [info]: Setup Finished!

pause

exit /b


REM サブルーチン：バックアップの作成とリンクの作成
:backup_and_mklink
if exist "%TO_DIR%\%~1" (
  MOVE "%TO_DIR%\%~1" "%TO_DIR%\%~1.orig"
)
if "%~2"=="" (
  MKLINK "%TO_DIR%\%~1" "%FROM_DIR%\%~1"
) else (
  MKLINK "%TO_DIR%\%~1" "%FROM_DIR%\%~2"
)
exit /b