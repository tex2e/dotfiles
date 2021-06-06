
# Sublime Packages

Sublime Text 4 の設定


### インストール手順

1. Windowsの場合、setup-win-admin.cmd を管理者権限で実行
2. MacOSの場合、以下のコマンドを実行

    ```
    cd "~/Library/Application Support/Sublime Text 3/Packages"
    rm -rf User
    ln -s "~/.dotfiles/sublime" User
    ```

### エディタの配色変更

- [GitHub's Sublime Text themes](https://github.com/mauroreisvieira/github-sublime-theme#githubs-sublime-text-themes)
  1. Ctrl+Shift+P でコマンドパレットを表示する
  2. 「Package Control: Install Packagse」を選択する
  3. GitHub Color Theme をインストールする
  4. Preferences > Chose Color Scheme > GitHub Dimmed を選択する
