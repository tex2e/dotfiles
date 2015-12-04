
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
#     create directory 'images'. if cannot creating it, print 'nothing to be done'.
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

TEX := platex -recorder

TEX_FILE := $(wildcard *.tex)
PDF_FILE := $(patsubst %.tex, %.pdf, $(TEX_FILE))

COMPILE_CNT := 1

.PHONY: init pdf open clean distclean

all: pdf

original_init:
	@mkdir images 2>/dev/null && touch report.tex || printf "nothing to be done\n"

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
