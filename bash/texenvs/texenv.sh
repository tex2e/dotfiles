#! /bin/bash

TEXENV_DIR="$HOME/.dotfiles/bash/texenvs"

cat << EOF > "$PWD"/Makefile

TEXENV_DIR=${TEXENV_DIR}
include \$(TEXENV_DIR)/Makefile.mk

.PHONY: init pdf clean distclean

init:
pdf:
clean:
distclean:

selfupdate:
	texenv
EOF
