
repo
=====

show git repositories status which is registered

Requirements
------------

add following snippets to your .bashrc

~~~ bash
# external alias
repo_alias="$HOME/.dotfiles/bash/repos/repo_alias"
if [[ -f "$repo_alias" ]]; then
  source "$repo_alias"
fi
~~~

Usage
-------

- `repo -a <repository>`
    - add existing git repository
- `repo [<repository>...]`
    - show git repository status
