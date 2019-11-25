
SHELL := /bin/sh
UNAME := $(shell uname)
.SUFFIXES:
.SUFFIXES: .pdf .tex .dvi

# # DEBUG
# OLD_SHELL := $(SHELL)
# SHELL = $(warning [Making: $@] [Dependencies: $^] [Changed: $?])$(OLD_SHELL)

### Usage ###
#
# to make PDF from TeX, type:
#
#     make init
#     make pdf
#

### Commands ###
#
# + init: write template tex file to create latex environment
# + init-presen: write template for presentation.
# + pdf: create pdf from tex file
# + punctuation: replace "。" and "、" with "．" and "，"
# + open: create pdf and open it
# + clean: rm *.{aux,log,dvi,fls}
# + distclean: rm *.{aux,log,dvi,fls,pdf}
# + rebuild: force to build a pdf
# + test: do test (requires ruby)
# + pptx: create pptx from pdf file (requires python3, ImageMagic, python-pptx)
#

TEXENV_DIR := $(HOME)/.dotfiles/bash/texenvs
TMP := /tmp

TEX := platex -recorder -interaction=nonstopmode -shell-escape

TEX_FILE  := $(wildcard *.tex)
PDF_FILE  := $(patsubst %.tex, %.pdf, $(TEX_FILE))
PPTX_FILE := $(patsubst %.tex, %.pptx, $(TEX_FILE))

IMG_TEX   := $(shell find img -type f -name '*.tex')
PNG_FILE  := $(patsubst %.tex, %.png, $(IMG_TEX))
EPS_FILE  := $(patsubst %.tex, %.eps, $(IMG_TEX))

BOOK_TEX_FILE := $(wildcard book/*.tex)

COMPILE_CNT := 1

ifeq ($(UNAME), Linux)
OPEN := xdg-open 2>/dev/null
else
ifeq ($(UNAME), Darwin)
OPEN := evince
else
OPEN := open
endif
endif

.PHONY: init pdf punctuation open clean distclean rebuild test

all: pdf

init: OUTPUT = report.tex
init:
	@echo 'Creating latex environment ...'
	-mkdir -p img && touch img/.keep
	@echo 'OUTPUT='$(OUTPUT)
	-cp -i $(TEXENV_DIR)/template.tex $(OUTPUT)
	-cp -i $(TEXENV_DIR)/.latexmkrc .

init-presen:
	@echo 'Creating presen environment ...'
	-mkdir -p img && touch img/.keep
	-mkdir -p pages && touch pages/.keep
	-cp -i $(TEXENV_DIR)/presen/.gitignore .
	-cp -R -i $(TEXENV_DIR)/presen/* .

init-standalone: OUTPUT = standalone.tex
init-standalone:
	@echo 'Creating standalone environment ...'
	-mkdir -p img && touch img/.keep
	-cp -i $(TEXENV_DIR)/standalone/.gitignore .
	-cp -i $(TEXENV_DIR)/standalone/standalone.tex img/$(OUTPUT)

# %.dvi: %.tex
# 	@for i in `seq 1 $(COMPILE_CNT)`; do \
# 		yes q | head | $(TEX) $<; \
# 	done
# 	@for i in `seq 1 3`; do \
# 		if grep -F 'Rerun to get cross-references right.' $(<:.tex=.log) || \
# 			grep -F 'Package rerunfilecheck Warning' $(<:.tex=.log); \
# 		then \
# 			yes q | head | $(TEX) $<; \
# 		else \
# 			exit 0; \
# 		fi; \
# 	done

# %.pdf: %.dvi
# 	dvipdfmx -d5 $<
# 	-test -f title.pdf && pdfunite title.pdf $@ /tmp/$$$$.pdf && mv /tmp/$$$$.pdf $@ || true

%.png: %.tex
	mkdir -p $(TMP)/$$$$ && \
	platex -shell-escape -halt-on-error -output-directory=$(TMP)/$$$$ $< && \
	dvipdfmx -d5 -o $(TMP)/$$$$/$(basename $(notdir $<)).pdf $(TMP)/$$$$/$(basename $(notdir $<)).dvi && \
	convert -density 200 $(TMP)/$$$$/$(basename $(notdir $<)).pdf -quality 90 $@ && \
	touch $@ \
	&& rm -r $(TMP)/$$$$ \
	|| rm -r $(TMP)/$$$$

%.eps: %.tex
	mkdir -p $(TMP)/$$$$ && \
	platex -shell-escape -halt-on-error -output-directory=$(TMP)/$$$$ $< && \
	dvipdfmx -d5 -o $(TMP)/$$$$/$(basename $(notdir $<)).pdf $(TMP)/$$$$/$(basename $(notdir $<)).dvi && \
	pdftops -level2 -eps $(TMP)/$$$$/$(basename $(notdir $<)).pdf $@ && \
	touch $@ \
	&& rm -r $(TMP)/$$$$ \
	|| rm -r $(TMP)/$$$$

FORCE:

%.pdf: FORCE
	latexmk $(patsubst %.pdf,%.tex,$@)

# %.pdf:
# 	-test -f title.pdf && pdfunite title.pdf $@ /tmp/$$$$.pdf && mv /tmp/$$$$.pdf $@ || true

presen.pptx: presen.pdf presen-note.txt
	./bin/pdf2pptx.sh

pdf: $(PDF_FILE)

pptx presen: presen.pptx

eps: $(EPS_FILE)

png: $(PNG_FILE)

punctuation punc pun: $(TEX_FILE) $(BOOK_TEX_FILE)
	$(foreach file, $?, \
		cat "$(file)" | sed -e 's/。/．/g' | sed -e 's/、/，/g' > /tmp/$$$$.tex \
		&& mv /tmp/$$$$.tex "$(file)"; \
	)

open: $(PDF_FILE)
	$(OPEN) $< &

open-report: report.pdf
	$(OPEN) report.pdf &

clean:
	$(RM) *.{aux,log,dvi,fls}

distclean: clean
	$(RM) $(PDF_FILE)

rebuild re:
	touch $(TEX_FILE)
	$(MAKE) pdf

test:
	latex-test $(TEX_FILE)

jlisting.sty:
	cp $(TEXENV_DIR)/jlisting.sty .
