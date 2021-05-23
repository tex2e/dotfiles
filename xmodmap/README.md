
# Xmodmap

LinuxでCapsLockをCtrlのように扱うための設定。

### インストール手順

1. setup-linux.sh を実行
2. コンソールを再起動


### 設定ファイル

```
xmodmap -pke > "~/.Xmodmap"
vim ~/.Xmodmap
```

CapsLock と Control を入れ替える場合：

```
remove Lock = Caps_Lock
keysym Caps_Lock = Control_L
add Control = Control_L
```

CapsLock に HyperKey を割当てる場合：

```
remove Lock = Caps_Lock
keysym Caps_Lock = Hyper_L
add Control = Hyper_L
```

設定ファイル適用：

```
xmodmap ~/.Xmodmap
```

キーコードの確認：

```
xev
```
