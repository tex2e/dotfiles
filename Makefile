
SHELL = /bin/sh
UNAME := $(shell uname)

### Commands
# + path
#     create symlinks which link to .path which contains exported PATH list
#
# + alias
#     create symlinks which link to .alias which contains useful alias list
#
# + bash
#     create bash config: .bash_profile and .bashrc
#
# + zsh
#     create zsh config: .zshenc and .zshrc
#
# + fish
#     create fish (friendly interactive shell) config
#
# + atom
#     create atom config: snippets.cson
#     and install atom packages (ATOM_PKG_LIST)
#
# + vim
#     create vim config
#
# + git
#     create git config
#
# + rake
#     create ~/.rake directory and create global rakefile
#
# + xmodmap
#     create xmodmap config
#
# + <command>-f
#     do `make <command>` with --force
#

.PHONY: path path-f alias alias-f bash bash-f zsh zsh-f fish fish-f atom vim git rake rake-f xmodmap xmodmap-f cygwin cygwin-f

all:
	@echo
	@echo "Commands:"
	@gawk '/^### Commands$$/, /^$$/ { print gensub(/^# ?(## Commands)?/, "", "g", $$0) }' ./Makefile


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
	minimap-highlight-selected

atom: atom-config atom-package

atom-config:
	@echo '=== configure atom ==='
	ln -fs $(HOME)/.dotfiles/atom/snippets.cson $(HOME)/.atom/snippets.cson
	ln -fs $(HOME)/.dotfiles/atom/config.cson $(HOME)/.atom/config.cson

atom-package:
	@echo '=== installing atom packages ==='
	apm install $(ATOM_PKG_LIST)


# --- make vim ---
vim:
	ln $(OPTION) -s "$(PWD)/vim/.vimrc" "$(HOME)/.vimrc"
	ln $(OPTION) -s "$(PWD)/vim/.vim/" "$(HOME)/.vim"

vim-f:
	$(MAKE) vim OPTION='-f'

# --- make git ---
ifeq ($(UNAME), Darwin)
GIT_CONFIG_ON_EACH_PLATFORM := "$(PWD)/git/.gitconfig.macos" "$(HOME)/.gitconfig.macos"
endif
ifeq ($(UNAME), Linux)
GIT_CONFIG_ON_EACH_PLATFORM := "$(PWD)/git/.gitconfig.linux" "$(HOME)/.gitconfig.linux"
endif

git:
	ln $(OPTION) -s "$(PWD)/git/.gitconfig" "$(HOME)/.gitconfig"
	ln $(OPTION) -s "$(PWD)/git/.gitignore_global" "$(HOME)/.gitignore_global"
	test "$(GIT_CONFIG_ON_EACH_PLATFORM)" && ln $(OPTION) -s $(GIT_CONFIG_ON_EACH_PLATFORM)

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


# --- make cygwin ---
cygwin:
	ln $(OPTION) -s "$(PWD)/cygwin/.inputrc" "$(HOME)/.inputrc"
	ln $(OPTION) -s "$(PWD)/cygwin/.minttyrc" "$(HOME)/.minttyrc"

cygwin-f:
	$(MAKE) cygwin OPTION='-f'


### Development ###

# --- make doc ---

doc: doc-bash doc-ruby

doc-bash:
	LANG=bash EXT=sh $(MAKE) doc-template

doc-ruby:
	LANG=ruby EXT=rb $(MAKE) doc-template

doc-template:
	@echo "=== creating $(LANG)/README.md ==="
	cat /dev/null > "$(LANG)/README.md"
	find $(LANG) -type f -name "*.$(EXT)" | sort | xargs gawk '/^#:readme:$$/, /^$$/ { print gensub(/^# ?(:readme:)?/, "", "g", $$0) }' >> "$(LANG)/README.md"
