
# VSCode

Visual Studio Code の設定


### インストール手順

1. Linuxの場合、setup-linux.sh を実行
2. Windowsの場合、setup-win-admin.cmd を管理者権限で実行
3. MacOSの場合、以下のコマンドを実行

    ```
    cd ~/Library/Application\ Support/Code/
    mv User User.bak
    ln -s ~/.dotfiles/vscode/ User
    ```
