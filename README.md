# dotfiles

This is a repository with my configuration files.

## Setup

```bash
git clone https://github.com/TeX2e/dotfiles ~/.dotfiles
cd ~/.dotfiles
```

```bash
git clone git@github.com:tex2e/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

When setup new pc:

```bash
ssh-keygen -t ed25519
cat ~/.ssh/id_ed25519.pub
cat <<EOS
Host github.com
    HostName github.com
    IdentityFile ~/.ssh/id_ed25519
    User git
EOS
ssh -T github.com
```


## License

    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
        Version 2, December 2004

    Copyright (C) 2016 @TeX2e

    Everyone is permitted to copy and distribute verbatim or modified
    copies of this license document, and changing it is allowed as long
    as the name is changed.

    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

    0. You just DO WHAT THE FUCK YOU WANT TO.
