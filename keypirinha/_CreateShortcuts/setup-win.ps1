
try {
  $shortcutsPath = "$HOME\Desktop\shortcuts"
  if (!(Test-Path -Path "$shortcutsPath")) {
    New-Item -Path "$shortcutsPath" -ItemType Directory
  }

  $links = @(
    @{path="$shortcutsPath\notepad.lnk";   target="C:\WINDOWS\system32\notepad.exe"},
    @{path="$shortcutsPath\HOME.lnk";      target="$HOME"},            # ホームディレクトリ
    @{path="$shortcutsPath\Documents.lnk"; target="$HOME\Documents"},  # ドキュメント
    @{path="$shortcutsPath\Downloads.lnk"; target="$HOME\Downloads"},  # ダウンロード
    @{path="$shortcutsPath\Desktop.lnk";   target="$HOME\Desktop"}     # デスクトップ
  )

  foreach ($link in $links) {
    $filepath = $link.path
    $target = $link.target
    "[*] $filepath -> $target"

    # ショートカット作成
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($filepath)
    $Shortcut.TargetPath = $target
    $Shortcut.Save()
  }

} catch {
  $_.Exception.Message
  "[-] Failed!"
}

pause
