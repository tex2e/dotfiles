
SHELL = /bin/sh
.SUFFIXES:
.SUFFIXES: .pdf .tex .dvi

### how to make PDF from TEX ###
#
# to make PDF from TeX, type:
#
#     make init
#     make pdf
#

### Commands
#
# + init
#     create directory images/ and write latex template file.
#
# + pdf
#     create pdf from tex file.
#
# + open
#     create pdf and open it.
#
# + clean
#     delete all files such as .aux, .log and .dvi that are normally created by running make.
#
# + distclean
#     delete all generated file (including .pdf).
#

# directory composed
#  .
#  ├── Makefile
#  ├── images/
#  ├── report.aux
#  ├── report.fls
#  ├── report.log
#  ├── report.pdf
#  └── report.tex
#

TEXENV_DIR := "$(HOME)/.dotfiles/bash/texenvs"

TEX := platex -recorder

TEX_FILE := $(wildcard *.tex)
PDF_FILE := $(patsubst %.tex, %.pdf, $(TEX_FILE))

COMPILE_CNT := 1

.PHONY: help init pdf open clean distclean rebuild
.SILENT: help

all: pdf

help:
	echo 'make init      - create a directory images/ and write a tmeplate tex file'
	echo 'make pdf       - create pdf from tex file.'
	echo 'make open      - create pdf and open it.'
	echo 'make clean     - remove any temporary products such as .aux, .log and .dvi.'
	echo 'make distclean - remove any generated file.'

init: OUTPUT = report.tex
init:
	@printf 'creating directory images/ ... '
	@mkdir images 2>/dev/null && echo 'done' || echo 'file exist'

	@echo 'writing template tex file ... '
	@echo 'OUTPUT='$(OUTPUT)
	cp -i $(TEXENV_DIR)/template.tex $(PWD)/$(OUTPUT) || true

%.dvi: %.tex
	@for i in `seq 1 $(COMPILE_CNT)`; do \
		yes q | $(TEX) $<; \
	done
	@for i in `seq 1 3`; do \
		if grep -F 'Rerun to get cross-references right.' $(<:.tex=.log); then \
			yes q | $(TEX) $<; \
		else \
			exit 0; \
		fi; \
	done

%.pdf: %.dvi
	dvipdfmx -d5 $<

pdf: $(PDF_FILE)

open: $(PDF_FILE)
	open $(PDF_FILE)

clean:
	$(RM) *.{aux,log,dvi,fls}

distclean: clean
	$(RM) $(PDF_FILE)

rebuild:
	touch $(TEX_FILE)
	$(MAKE) pdf
