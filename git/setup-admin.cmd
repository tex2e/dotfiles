@echo off

SET TO_DIR=%HomeDrive%%HomePath%
SET FROM_DIR=%~dp0

IF exist "%TO_DIR%\.gitconfig" (
  MOVE "%TO_DIR%\.gitconfig" "%TO_DIR%\.gitconfig.orig"
)
MKLINK "%TO_DIR%\.gitconfig" "%FROM_DIR%\.gitconfig"

IF exist "%TO_DIR%\.gitignore_global" (
  MOVE "%TO_DIR%\.gitignore_global" "%TO_DIR%\.gitignore_global.orig"
)
MKLINK "%TO_DIR%\.gitignore_global" "%FROM_DIR%\.gitignore_global"

echo "[info]: Setup Finished!"

PAUSE
