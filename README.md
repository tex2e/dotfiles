# dotfiles

Windows, WSL, Git Bash, Ubuntu, Kali, MacOS の設定ファイル

## 前提条件

- Windowsの場合：Git for Windows（Git Bash）
- Linux系の場合：Gitコマンド

## ダウンロード

一時的な環境ですぐに使いたい場合：

```bash
git clone https://github.com/tex2e/dotfiles ~/.dotfiles
cd ~/.dotfiles
```

普段使う環境でメンテナンスしながら使う場合（SSH鍵必須、GitHubで二要素認証）：

```bash
ssh-keygen -t ed25519
cat <<EOS > ~/.ssh/config
Host github.com
    HostName github.com
    IdentityFile ~/.ssh/id_ed25519
    User git
EOS
cat ~/.ssh/id_ed25519.pub
# GitHubにアクセスしてSSH公開鍵を登録する。
# 以下は確認コマンド
ssh -T github.com

git clone git@github.com:tex2e/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

## インストール

各フォルダ内にあるコマンドを実行して、設定ファイルのシンボリックリンクを作成します。
詳細は各フォルダ内の README.md をご覧ください。

### Windows

各フォルダに移動してから setup-win-XXX.cmd を実行してください。
setup-win-admin.cmd のように末尾に「admin」が付いているものは管理者権限で実行してください。
レジストリ変更が必要な設定は、XXX.reg のファイルを実行してください。

### Linux / MacOS

各フォルダにある ./XXX/setup-linux.sh または ./XXX/setup-macos.sh を実行してください。
Windowsとは異なり、シンボリックリンクの作成に管理者権限は不要ですので、sudoなしで実行してください。


<br>

## License

    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
        Version 2, December 2004

    Copyright (C) 2016 @TeX2e

    Everyone is permitted to copy and distribute verbatim or modified
    copies of this license document, and changing it is allowed as long
    as the name is changed.

    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

    0. You just DO WHAT THE FUCK YOU WANT TO.
