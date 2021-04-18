
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
