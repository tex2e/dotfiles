@echo off

SET TO_DIR=%HomeDrive%%HomePath%
SET FROM_DIR=%~dp0

IF exist "%TO_DIR%\.zshenv" (
  MOVE "%TO_DIR%\.zshenv" "%TO_DIR%\.zshenv.orig"
)
MKLINK "%TO_DIR%\.zshenv" "%FROM_DIR%\.zshenv"

IF exist "%TO_DIR%\.zshrc" (
  MOVE "%TO_DIR%\.zshrc" "%TO_DIR%\.zshrc.orig"
)
MKLINK "%TO_DIR%\.zshrc" "%FROM_DIR%\.zshrc"

echo "[info]: Setup Finished!"

PAUSE
