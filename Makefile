
SHELL = /bin/sh
UNAME := $(shell uname)


# # --- make xmodmap ---
# xmodmap:
# 	ln $(OPTION) -s "$(PWD)/xmodmap/.xmodmap" "$(HOME)/.xmodmap"
# xmodmap-f:
# 	$(MAKE) xmodmap OPTION='-f'


# # --- make cygwin ---
# cygwin:
# 	ln $(OPTION) -s "$(PWD)/cygwin/.inputrc" "$(HOME)/.inputrc"
# 	ln $(OPTION) -s "$(PWD)/cygwin/.minttyrc" "$(HOME)/.minttyrc"
# cygwin-f:
# 	$(MAKE) cygwin OPTION='-f'


# # --- make brew ---
# brew:
# 	ln $(OPTION) -s "$(PWD)/brew/.Brewfile" "$(HOME)/.Brewfile"
# 	test -d "$(HOME)/.brew-aliases" || \
# 	ln $(OPTION) -s "$(PWD)/brew/.brew-aliases" "$(HOME)/.brew-aliases"
# brew-f:
# 	$(MAKE) brew OPTION='-f'
