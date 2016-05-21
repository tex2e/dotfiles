
SHELL = /bin/sh

### Commands
#
# + path
#     create symlinks which link to .path which contains exported PATH list
#
# + bash
#     create symlinks which link to .bash_profile and .bashrc into home dir
#
# + zsh
#     create symlinks which link to .zshenv and .zshrc into home dir
#
# + atom
#     link to your atom/snippets.cson
#     and install atom packages (ATOM_PKG_LIST)
#
# + vim
#     create vim settings
#
# + git
#     create git settings
#
# + rake
#     create ~/.rake directory and set global rakefile
#
# + xmodmap
#     create xmodmap settings
#
# + <command>-f
#     do `make <command>` with --force
#

.PHONY: path path-f alias alias-f bash bash-f zsh zsh-f fish fish-f atom vim git rake rake-f

all:
	@echo "Commands"
	@echo "+ path  -- create symlinks which link to .path which contains exported PATH list"
	@echo "+ bash  -- create symlinks which link to .bash_profile and .bashrc into home dir"
	@echo "+ zsh   -- create symlinks which link to .zshenv and .zshrc into home dir"
	@echo "+ atom  -- link to your atom/snippets.cson and install atom packages (ATOM_PKG_LIST)"
	@echo "+ vim   -- create vim settings"
	@echo "+ git   -- set a useful git aliases"
	@echo "+ rake  -- create ~/.rake directory and set global rakefile"


# --- make path ---
path:
	ln $(OPTION) -s "$(PWD)/.path" "$(HOME)/.path"

path-f:
	$(MAKE) path OPTION='-f'


# --- make alias ---
alias:
	ln $(OPTION) -s "$(PWD)/.alias" "$(HOME)/.alias"

alias-f:
	$(MAKE) alias OPTION='-f'


# --- make bash ---
bash: path
	ln $(OPTION) -s "$(PWD)/bash/.bash_profile" "$(HOME)/.bash_profile"
	ln $(OPTION) -s "$(PWD)/bash/.bashrc" "$(HOME)/.bashrc"
	ln $(OPTION) -s "$(PWD)/bash/.ubuntu.bashrc" "$(HOME)/.ubuntu.bashrc"

bash-f: path-f
	$(MAKE) bash OPTION='-f'


# --- make zsh ---
zsh: bash
	ln $(OPTION) -s "$(PWD)/zsh/.zshenv" "$(HOME)/.zshenv"
	ln $(OPTION) -s "$(PWD)/zsh/.zshrc" "$(HOME)/.zshrc"

zsh-f: bash-f
	$(MAKE) zsh OPTION='-f'


# --- make fish ---
fish: alias
	ln $(OPTION) -s "$(PWD)/fish/config.fish" "$(HOME)/.config/fish/config.fish"
	ln $(OPTION) -s "$(PWD)/.alias" "$(HOME)/.config/fish/aliases.fish"

fish-f: alias-f
	$(MAKE) fish OPTION='-f'


# --- make atom ---
ATOM_PKG_LIST := \
	minimap \
	file-icons \
	sublime-style-column-selection \
	highlight-selected \
	minimap-highlight-selected \
	script

atom:
	@echo '>>> linking atom snippets'
	-ln -s $(HOME)/.dotfiles/atom/snippets.cson $(HOME)/.atom/snippets.cson
	@echo '>>> installing atom packages'
	apm install $(ATOM_PKG_LIST)


# --- make vim ---
vim:
	ln $(OPTION) -s "$(PWD)/vim/.vimrc" "$(HOME)/.vimrc"
	ln $(OPTION) -s "$(PWD)/vim/.vim/" "$(HOME)/.vim"

vim-f:
	$(MAKE) vim OPTION='-f'


# --- make subl ---
subl-ubuntu:
	mkdir -p "$(HOME)/local"
	$(HOME)/.dotfiles/bash/install-sublime3.sh "$(HOME)/local" "3083"


# --- make git ---
git:
	ln $(OPTION) -s "$(PWD)/git/.gitconfig" "$(HOME)/.gitconfig"
	ln $(OPTION) -s "$(PWD)/git/.gitignore_global" "$(HOME)/.gitignore_global"

git-f:
	$(MAKE) git OPTION='-f'


# --- make rake ---
rake:
	ln $(OPTION) -s "$(PWD)/rake/" "$(HOME)/.rake"

rake-f:
	$(MAKE) rake OPTION='-f'


# --- make xmodmap ---
xmodmap:
	ln $(OPTION) -s "$(PWD)/xmodmap/.xmodmap" "$(HOME)/.xmodmap"

xmodmap-f:
	$(MAKE) xmodmap OPTION='-f'


### Development ###

# --- make doc ---

doc-bash:
	cat /dev/null > "bash/README.md"
	find . -type f -name "*.sh" -exec awk '/^#:readme:$$/, /^$$/ { print gensub(/^# ?(:readme:)?/, "", "g", $$0) }' {} \; >> "bash/README.md"
