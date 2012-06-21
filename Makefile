SHELL := /bin/sh
INSTALL := install
INSTALL_PROGRAM := $(INSTALL)
INSTALL_DATA := $(INSTALL) -m 644

ZIP := zip
MKTEXLSR := mktexlsr
TEX := tex
LATEX := pdflatex
MAKEINDEX := makeindex

name := longarrows
bundle := phst

texmf := $(shell kpsewhich --var-value=TEXMFHOME)
branch := latex/$(bundle)
destdir := $(texmf)/tex/$(branch)
docdir := $(texmf)/doc/$(branch)
auctexdir := ~/.emacs.d/auctex/style

TEXFLAGS := --file-line-error --interaction=scrollmode
LATEXFLAGS := $(TEXFLAGS)
LATEXFLAGS_DRAFT := $(LATEXFLAGS) --draftmode
LATEXFLAGS_FINAL := $(LATEXFLAGS) --synctex=1

source := $(name).dtx
driver := $(name).ins
destination := $(name).sty
cmfont := ot1cmr$(name).fd
lmfont := ot1lmr$(name).fd
class := $(shell kpsewhich phst-doc.cls)
manual := $(name).pdf
auctex_style := $(name).el
index_src := $(name).idx
index_dest := $(name).ind
index_log := $(name).ilg
index_sty := gind.ist
changes_src := $(name).glo
changes_dest := $(name).gls
changes_log := $(name).glg
changes_sty := gglo.ist
ctan_arch := $(name).zip
ctan_files := README MANIFEST Makefile $(source) $(driver) $(class) $(destination) $(cmfont) $(lmfont) $(auctex_style) $(manual)


all: $(destination) $(cmfont) $(lmfont) $(auctex_style)

pdf: $(manual)

complete: all pdf

ctan: $(ctan_arch)

install: all
	$(INSTALL) -d $(destdir)
	$(INSTALL_DATA) $(destination) $(destdir)
	$(INSTALL_DATA) $(cmfont) $(destdir)
	$(INSTALL_DATA) $(lmfont) $(destdir)
	$(INSTALL) -d $(auctexdir)
	$(INSTALL_DATA) $(auctex_style) $(auctexdir)
	$(MKTEXLSR)

install-pdf: pdf
	$(INSTALL) -d $(docdir)
	$(INSTALL_DATA) $(manual) $(docdir)
	$(MKTEXLSR)

install-complete: install install-pdf

$(destination) $(cmfont) $(lmfont): $(driver) $(source)
	$(TEX) $(TEXFLAGS) $<

$(manual): $(source) $(destination)
	$(LATEX) $(LATEXFLAGS_DRAFT) $<
	$(MAKEINDEX) -s $(index_sty) -o $(index_dest) -t $(index_log) $(index_src)
	$(MAKEINDEX) -s $(changes_sty) -o $(changes_dest) -t $(changes_log) $(changes_src)
	$(LATEX) $(LATEXFLAGS_DRAFT) $<
	$(LATEX) $(LATEXFLAGS_FINAL) $<

$(ctan_arch): $(ctan_files)
	$(ZIP) -v $@ $^

.SUFFIXES:

.PHONY: all pdf complete install install-pdf install-complete
