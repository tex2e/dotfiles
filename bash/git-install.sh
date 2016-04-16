#!/bin/bash

INSTALL_DIR="$HOME/usr"
BIN_DIR="$HOME/usr/bin"

mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

fakegit clone https://github.com/git/git.git
cd git

make prefix="$INSTALL_DIR" all doc info \
  NO_OPENSSL=YesPlease \
  NO_EXPAT=YesPlease \
  NO_TCLTK=YesPlease \
  NO_GETTEXT=YesPlease \
