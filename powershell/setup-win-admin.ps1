
# 実行ファイルのパスへ移動
$CurrentDir = Split-Path $MyInvocation.MyCommand.Path
cd $CurrentDir

# リンク先フォルダとリンク元フォルダ
$TO_FILE = $profile
$TO_DIR = Split-Path $profile -Parent
$FROM_DIR = ".\Microsoft.PowerShell_profile.ps1"
"[*] TO_DIR=$TO_DIR"
"[*] FROM_DIR=$FROM_DIR"
"[ ]"

"[*] pwd:"
pwd | select -expand Path

# 管理者権限チェック
$wid = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$prp = new-object System.Security.Principal.WindowsPrincipal($wid)
$admin = [System.Security.Principal.WindowsBuiltInRole]::Administrator
$isAdmin = $prp.IsInRole($admin)
if (!$isAdmin) {
  "[-] This command prompt is NOT ELEVATED!"
  pause
  exit 1
}

try {
  # ディレクトリの作成
  New-Item -Path "$TO_DIR" -ItemType Directory

  # シンボリックリンクの作成
  New-Item -ItemType SymbolicLink -Path "$profile" -Target ".\Microsoft.PowerShell_profile.ps1"

  "[+] Setup Finished!"
} catch {
  $_.Exception.Message
  "[-] Failed!"
}

pause
