@echo off

REM VSCode settings directory
SET TO_DIR=%AppData%\Code\User
SET FROM_DIR=%~dp0

IF exist "%TO_DIR%\settings.json" (
  MOVE "%TO_DIR%\settings.json" "%TO_DIR%\settings.json.orig"
)
MKLINK "%TO_DIR%\settings.json" "%FROM_DIR%\settings.json"

IF exist "%TO_DIR%\keybindings.json" (
  MOVE "%TO_DIR%\keybindings.json" "%TO_DIR%\keybindings.json.orig"
)
MKLINK "%TO_DIR%\keybindings.json" "%FROM_DIR%\keybindings.json"

IF exist "%TO_DIR%\snippets\markdown.json" (
  MOVE "%TO_DIR%\snippets\markdown.json" "%TO_DIR%\snippets\markdown.json.orig"
)
MKLINK "%TO_DIR%\snippets\markdown.json" "%FROM_DIR%\snippets\markdown.json"

IF exist "%TO_DIR%\snippets\shellscript.json" (
  MOVE "%TO_DIR%\snippets\shellscript.json" "%TO_DIR%\snippets\shellscript.json.orig"
)
MKLINK "%TO_DIR%\snippets\shellscript.json" "%FROM_DIR%\snippets\shellscript.json"

echo "[info]: Setup Finished!"

PAUSE
