
# Bash

.bashrc や自作コマンドの設定


### セットアップ手順

- Linuxの場合、setup-linux.sh を実行
- Windows (Git Bash) の場合、setup-win-admin.cmd を管理者権限で実行

### 注意事項

- Git Bash は起動時に .bash_profile しか読まないので、Git Bash向け設定は全て .bash_profile に記述すること

- 自作コマンドを使いたいときは PATH に `~/.dotfiles/bin` が追加されているか確認

  ```bash
  export PATH="$PATH:$HOME/.dotfiles/bin"
  ```
