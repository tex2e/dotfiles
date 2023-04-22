@echo off

rem リンク先フォルダとリンク元フォルダ
set TO_DIR=%USERPROFILE%\.mintty\themes
set FROM_DIR=%~dp0
echo [*] TO_DIR=%TO_DIR%
echo [*] FROM_DIR=%FROM_DIR%
echo [ ]

rem 管理者権限チェック
openfiles > nul 2>&1
if not %ERRORLEVEL% == 0 (
  echo [-] This command prompt is NOT ELEVATED!
  goto L_end
)

rem シンボリックリンクの作成
mkdir %TO_DIR%
call :backup_and_mklink base16-google-light.minttyrc

if not %ERRORLEVEL% == 0 (
  echo [-] Failed!
  goto L_end
)

echo [+] Setup Finished!

:L_end
pause
exit /b


rem サブルーチン：バックアップの作成とリンクの作成
rem call :backup_and_mklink リンク先 リンク元
:backup_and_mklink
if exist "%TO_DIR%\%~1" (
  move "%TO_DIR%\%~1" "%TO_DIR%\%~1.orig"
)
if "%~2"=="" (
  mklink "%TO_DIR%\%~1" "%FROM_DIR%\%~1"
) else (
  mklink "%TO_DIR%\%~1" "%FROM_DIR%\%~2"
)
if not %ERRORLEVEL% == 0 exit /b 1
exit /b
