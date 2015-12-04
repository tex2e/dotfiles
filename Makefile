
SHELL = /bin/sh

### Commands
# 
# + link
#     create symbolic links.
#     After running this command, your home directory has a symbolic link 
#     which links to run-command file such as .bash_profile and .bashrc in .dotfiles/
#     

linked_file := \
	.bash_profile .bashrc .ubuntu.bashrc .zshenv .zshrc .vimrc

link: $(linked_file)
	@$(foreach file, $?, \
		ln -fs $(PWD)/$(file) $(HOME)/$(file); \
	)
