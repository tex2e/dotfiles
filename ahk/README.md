
# AutoHotKey (Windows)

Windowsでキーボードとマウス操作の設定


### AHKインストール

- https://autohotkey.com/download/ から v2 をインストールする
- 内容は "C:\Program Files\AutoHotkey" に配置される


### セットアップ手順

1. map-capslock-to-f13.reg を管理者権限を持つユーザで実行してCapsLockにF13を割り当てる（要再起動）
2. setup-win.cmd を実行して AutoHotkey.exe をスタートアップに配置する

### 注意点

- エクスプローラー上 Ctrl+Shift+M によるファイル作成は 右クリック＞新規作成＞下から2番目をクリック のため、[ShellNewHandler.exe](https://sourceforge.net/projects/shellnewhandler/) で表示数を調整しておくこと
- v1からv2へ移行する際は、まずv1のAHKを全てアンインストールしてから、v2をインストールすること（既存が残ったままだとコンパイル時にv2が選択できないため）
- v2インストール後は以下の設定を行うこと
  - AutoHotkey Dash > Compile > Options
    - Base File : v2.0.2 U64 AutoHotkey64.exe を選択
    - 修正後は、「Save」ボタンを押下



<br>

### （補足）regファイル作成方法

- [Change Key](https://forest.watch.impress.co.jp/library/software/changekey/) をダウンロードして、管理者権限で実行して、キー配置変換後にレジストリエディタで「HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout」をエクスポートする。
