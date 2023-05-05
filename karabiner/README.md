
# Karabiner

MacOSでキーボード操作の設定


### Karabinerインストール

- [Karabiner-Elements](https://karabiner-elements.pqrs.org/) からダウンロードする
- [Installation \| Karabiner-Elements](https://karabiner-elements.pqrs.org/docs/getting-started/installation/) のインストール手順を読みながらインストールする

### セットアップ手順

1. setup-macos.sh を実行して設定ファイルのシンボリックリンクを配置する

### 注意点

- Karabinerの設定画面から設定すると、シンボリックリンクが普通のファイルに書き換えられてしまうので、編集する際は karabiner.json を直接編集すること
- karabiner.json を編集した際は、再度 setup-macos.sh を実行するとすぐに設定が反映される
