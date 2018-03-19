#!/bin/bash -u
#:readme:
#
# ## texenv(1) -- init LaTeX environment for writing reports
#
# [code](texenvs/texenv.sh)
#
# ### SYNOPSIS
#
#     texenv [make]
#
# ### Description
#
# init LaTeX environment for writing reports.
#
# ### Usage
#
# to create tex environment, type:
#
#     texenv && make init
#
# `texenv` creates a symbolic link to Makefile.mk
#
#     > texenv
#     linking Makefile ... done
#
#     > make init
#     creating directory images/ ... done
#     writing template tex file ...
#     OUTPUT=report.tex
#     cp -i "~/.dotfiles/bash/texenvs"/template.tex ~/path/to/dir/report.tex || true
#
#     > tree
#     .
#     ├── Makefile -> ~/.dotfiles/bash/texenvs/Makefile.mk
#     ├── images/
#     └── report.tex
#

TEXENV_DIR=${TEXENV_DIR:-$HOME/.dotfiles/bash/texenvs}

printf 'linking Makefile ... '
ln -s "$TEXENV_DIR/Makefile.mk" "$PWD/Makefile" &>/dev/null && \
echo 'done' || \
echo 'file exists'

exit 0
