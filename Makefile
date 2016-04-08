
SHELL = /bin/sh

### Commands
#
# + rc
#     create symbolic links.
#     After running this command, your home directory has a symbolic link
#     which links to run-command file such as .bash_profile and .bashrc in .dotfiles/
#
# + atom
#     link to your atom/snippets.cson
#     and install atom packages (ATOM_PKG_LIST)
#
# + git
#     configure a git alias
#

.PHONY: rc atom git

linked_file := \
	.bash_profile .bashrc .ubuntu.bashrc .zshenv .zshrc .vimrc .path

rc: $(linked_file)
	@$(foreach file, $?, \
		ln -fs $(PWD)/$(file) $(HOME)/$(file); \
	)


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
