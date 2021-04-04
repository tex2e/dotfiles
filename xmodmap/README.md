
# xmodmap

CapsLockをCtrlにする

```
xmodmap -pke > "~/.xmodmap"
vim ~/.xmodmap

remove Lock = Caps_Lock
keysym Caps_Lock = Control_L
add Control = Control_L
```

```bash
#!/bin/bash

xmodmap "$HOME/.xmodmap"
xmodmap "$HOME/.dotfiles/xmodmap/ubuntu-keymap"
```
