
# PowerShell

Windowsでコンソール起動時に実行するPowerShellスクリプトの設定


### インストール手順

1. PowerShellの許可（管理者権限で実行）

    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    ```

2. setup-win-admin.ps1 を管理者権限で実行
