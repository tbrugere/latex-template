BUILDDIR=build
# FILENAMES=main supplementary
FILENAMES=main
# LATEX=lualatex
LATEX=TEXINPUTS=resources//: pdflatex
ALL_TEX=$(shell fd -e tex . resources/ text/)

aux_filenames=$(patsubst %,$(BUILDDIR)/%.aux,$(FILENAMES))
pdf_filenames=$(patsubst %,%.pdf,$(FILENAMES))
synctex_filenames=$(patsubst %,%.synctex.gz,$(FILENAMES))

BIBTEX ?=bibtex

all: $(pdf_filenames) $(synctex_filenames) $(ALL_TEX)

$(BUILDDIR)/resources: resources | $(BUILDDIR)
	cd $(BUILDDIR);  ln -s ../resources .

$(BUILDDIR)/text : text | $(BUILDDIR)
	cd $(BUILDDIR);  ln -s ../text .

$(BUILDDIR)/%.aux: $(BUILDDIR)/%.tex | $(BUILDDIR)/resources  $(BUILDDIR)/text
	cd $(@D); \
	$(LATEX) -draftmode  $(*F) && \
	$(BIBTEX) $(*F) && \
	makeglossaries $(*F) && \
	$(LATEX) -draftmode $(*F) 

$(BUILDDIR)/%.pdf $(BUILDDIR)/%.synctex.gz: $(BUILDDIR)/%.tex $(BUILDDIR)/%.aux $(aux_filenames) $(ALL_TEX) | $(BUILDDIR)/resources $(BUILDDIR)/text
	cd $(@D) ; \
	$(LATEX) --synctex=1 $(*F)

$(BUILDDIR)/%.tex: %.tex resources | $(BUILDDIR)
	cp $< $@

rebuttal/%.pdf: $(BUILDDIR)/rebuttal/%.pdf
	cp $< $@

%.pdf: $(BUILDDIR)/%.pdf
	cp $< $@

%.synctex.gz:  $(BUILDDIR)/%.synctex.gz
	cp $< $@

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

clean:
	rm build/*
