
# Xmodmap

CapsLockをCtrlにする (Linuxのみ)

### インストール手順

1. setup-linux.sh を実行
2. コンソールを再起動


### 設定ファイル

設定ファイル作成：

```
xmodmap -pke > "~/.Xmodmap"
vim ~/.Xmodmap

    remove Lock = Caps_Lock
    keysym Caps_Lock = Control_L
    add Control = Control_L
```

設定ファイル適用：

```
xmodmap ~/.Xmodmap
```

キーコードの確認：

```
xev
```



---

### Kali Linux

```
sudo apt install autokey-gtk
autokey-gtk &
```
設定 > システム > セッションと起動 > 自動開始アプリケーション > 追加

* 名前：Autokey
* コマンド：autokey-gtk
* トリガー：on login
