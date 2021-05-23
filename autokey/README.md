
# AutoKey

### インストール手順

1. autokey-gtk インストール
    ```
    sudo apt install autokey-gtk
    autokey-gtk &
    ```
2. setup-linux.sh を実行


### ログイン時起動設定

設定 > システム > セッションと起動 > 自動開始アプリケーション > 追加

* 名前：Autokey
* コマンド：autokey-gtk
* トリガー：on login


### 設定ファイル

- CapsCtrl/
  - CapsLockをCtrlとして扱うための設定
- Replace/
  - 「dd」と入力すると日付に変換されるなどの展開の設定
