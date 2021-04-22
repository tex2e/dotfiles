
# AutoHotKey

Windowsでキーボードとマウス操作の設定


### セットアップ手順

1. map-capslock-to-f13.reg を実行してCapsLockをF13に割当てる
   * もしくは、Windows上のVirtualBoxの仮想マシンにF13がキーマッピングされない問題を解決するために、
     CapsLockとInsertを入れ替える map-swap-caps-and-insert.reg を実行し、InsertをF13のように扱う
2. setup-win.cmd を実行して AutoHotkey.exe と HotCorner.exe をスタートアップに配置する

### 注意点

- エクスプローラー上 Ctrl+Shift+N によるファイル作成は 右クリック＞新規作成＞下から2番目をクリック のため、[ShellNewHandler.exe](https://sourceforge.net/projects/shellnewhandler/) で表示数を調整しておくこと



---

### regファイル作成方法

[Change Key](https://forest.watch.impress.co.jp/library/software/changekey/) をダウンロードして、管理者権限で実行して、キー配置変換後にレジストリエディタで「HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout」をエクスポートする。
