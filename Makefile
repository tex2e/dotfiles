
SHELL = /bin/sh

### Commands
#
# + path
#     create symlinks which link to .path which contains exported PATH list
#
# + path-f
#     do `make path` with --force
#
# + bash
#     create symlinks which link to .bash_profile and .bashrc into home dir
#
# + bash-f
#     do `make bash` with --force
#
# + zsh
#     create symlinks which link to .zshenv and .zshrc into home dir
#
# + zsh-f
#     do `make zsh` with --force
#
#
# + atom
#     link to your atom/snippets.cson
#     and install atom packages (ATOM_PKG_LIST)
#
# + vim
#     create vim settings
#
# + vim-plugin
#     download vim plugins
#
# + git
#     set a useful git aliases
#
# + rake
#     create ~/.rake directory and set global rakefile
#
# + rake-f
#     do `make rake` with --force
#

.PHONY: path path-f bash bash-f zsh zsh-f atom vim git rake rake-f

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

vim-plugin:
	~/.dotfiles/vim/.vim/setup.sh "~/.dotfiles/bin/fakegit"


# --- make git ---
git:
	git config --global alias.s 'status'
	git config --global alias.ss 'status -s'
	git config --global alias.b 'branch'
	git config --global alias.d 'diff'
	git config --global alias.dn 'diff --name-only'
	git config --global alias.dc 'diff --cached'
	git config --global alias.dt 'diff HEAD^ HEAD'
	git config --global alias.a 'add'
	git config --global alias.aa 'add -A'
	git config --global alias.c 'commit'
	git config --global alias.cm 'commit -m'
	git config --global alias.cam 'commit -am'
	git config --global alias.ch 'checkout'
	git config --global alias.chb 'checkout -b'
	git config --global alias.chm 'checkout master'
	git config --global alias.bclean '!f() { git branch --merged $${1-master} | grep -v " $${1-master}$$" | xargs git branch -d; }; f'
	git config --global alias.l 'log'
	git config --global alias.graph "log --graph --date=short --decorate=short --pretty=format:'%Cgreen%h %Creset%cd %Cblue%cn %Cred%d %Creset%s'"
	git config --global alias.r 'remote'
	git config --global alias.ru 'remote update'
	git config --global alias.bl 'blame'
	git config --global alias.gr 'grep -iI'
	git config --global alias.f 'fetch'
	git config --global alias.up '!git pull --prune $$@ && git submodule update --init --recursive'
	git config --global alias.amend 'commit --amend'
	git config --global alias.amendm 'commit --amend -m'
	git config --global alias.save '!git add -A && git commit -m "SAVEPOINT"'
	git config --global alias.undo 'reset HEAD~1 --mixed'
	git config --global alias.wipe '!git add -A && git commit -qm "WIPE SAVEPOINT" && git reset HEAD~1 --hard'
	git config --global alias.config 'config --global -e'
	git config --global alias.unstage 'reset HEAD'
	git config --global alias.sm 'submodule'
	git config --global alias.smi 'submodule init'
	git config --global alias.smu 'submodule update'
	git config --global alias.smf 'submodule foreach'


# --- make rake ---
rake:
	ln $(OPTION) -s "$(PWD)/rake/" "$(HOME)/.rake"

rake-f:
	$(MAKE) rake OPTION='-f'
