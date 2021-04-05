
### Title ###

$hostversion="$($Host.Version.Major)`.$($Host.Version.Minor)"
$wid = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$prp = new-object System.Security.Principal.WindowsPrincipal($wid)
$admin = [System.Security.Principal.WindowsBuiltInRole]::Administrator
$isAdmin = $prp.IsInRole($admin)
if ($isAdmin) {
    $Host.UI.RawUI.WindowTitle = "[Administrator] PowerShell $hostversion"
} else {
    $Host.UI.RawUI.WindowTitle = "PowerShell $hostversion"
}


### Prompt ###

function Prompt {
  Write-Host ("PS " + (Get-Location | Get-Item).Name + ">") -NoNewLine `
    -ForegroundColor Green
  return " "
}


### Options ###

# Zsh風のタブ補完
Set-PSReadLineKeyHandler -Key Tab -Function Complete


### Alias ###

Set-Alias open Invoke-Item


### Function ###

# コマンドの場所やエイリアスの定義を取得する
function which($cmdname) {
  Get-Command $cmdname | Select-Object -ExpandProperty Definition
}

# 管理者権限でPowerShellを開く
function Start-PSElevate() {
  Start-Process powershell.exe -Verb RunAs
}


### Others ###

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
