
SHELL = /bin/sh

### Commands
#
# + link
#     create symbolic links.
#     After running this command, your home directory has a symbolic link
#     which links to run-command file such as .bash_profile and .bashrc in .dotfiles/
#
# + atom
#     link to your atom/snippets.cson
#
# + git
#     configure a git alias
#

.PHONY: link atom git

linked_file := \
	.bash_profile .bashrc .ubuntu.bashrc .zshenv .zshrc .vimrc

link: $(linked_file)
	@$(foreach file, $?, \
		ln -fs $(PWD)/$(file) $(HOME)/$(file); \
	)

atom:
	ln -s ~/.dotfiles/atom/snippets.cson ~/.atom/snippets.cson

git:
	git config --global alias.s status
	git config --global alias.b branch
	git config --global alias.a add
	git config --global alias.c commit
	git config --global alias.ch checkout
	git config --global alias.l log
	git config --global alias.r remote
	git config --global alias.ru remote update
	git config --global alias.bl blame
	git config --global alias.gr grep
