
# Zsh

.zshrc の設定


### インストール手順

1. zshのインストール
    ```bash
    $ sudo apt update
    $ sudo apt install zsh
    ```
2. dotfilesのbashのインストール（zshの前にbashが完了していること）
    ```bash
    $ ./bash/setup-linux.sh
    ```
3. zshセットアップコマンドの実行
  - Linuxの場合、setup-linux.sh を実行
  - Windowsの場合、setup-win-admin.cmd を実行

### Zsh追加カスタマイズのインストール手順

- zsh-autosuggestions : 入力時に候補が薄い色で表示される
- zsh-syntax-highlighting : コンソール文字の色付け
- command-not-found : 存在しないコマンドを入れた時に類似コマンドを表示する

```bash
sudo git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions /usr/local/share/zsh-autosuggestions
sudo git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/local/share/zsh-syntax-highlighting
sudo apt-get install command-not-found
```
