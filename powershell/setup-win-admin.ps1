
# 実行ファイルのパスへ移動
$CurrentDir = Split-Path $MyInvocation.MyCommand.Path
cd $CurrentDir

# 実行ファイルのフォルダ名
$profileDir = Split-Path $profile -Parent
Write-Output $profileDir

echo "[*] pwd:"
pwd | select -expand Path

try {
  New-Item -Path $profileDir -ItemType Directory

  # Pathはシンボリックリンクの配置パス
  # Targetは参照先のパス
  echo "[*] Path: $profile"
  echo "[*] Target: .\Microsoft.PowerShell_profile.ps1"

  New-Item -ItemType SymbolicLink -Path "$profile" -Target ".\Microsoft.PowerShell_profile.ps1"

  echo "[+] Setup Finished!"
} catch {
  $_.Exception.Message
  echo "[-] Setup Failed!"
}

pause
