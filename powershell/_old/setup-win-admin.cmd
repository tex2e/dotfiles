@echo off

REM リンク先フォルダとリンク元フォルダ
set TO_DIR=%USERPROFILE%\Documents\WindowsPowerShell
set FROM_DIR=%~dp0

REM 管理者権限チェック
openfiles > NUL 2>&1
if NOT %ERRORLEVEL% EQU 0 goto NotAdmin

  mkdir "%TO_DIR%"
  call :backup_and_mklink Microsoft.PowerShell_profile.ps1

  echo [info]: Setup Finished!
goto End
:NotAdmin
  echo This command prompt is NOT ELEVATED
:End

pause

exit /b


REM サブルーチン：バックアップの作成とリンクの作成
REM call :backup_and_mklink リンク先 リンク元
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
