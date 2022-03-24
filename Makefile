TARGET=main

USEBIB=y


ifeq ($(USEBIB),y)
    DEPBIB=%.bbl
else
    DEPBIB=
endif

all: release

release: pdf clean-temp

grammalecte.txt: $(TARGET).txt
	grammalecte-cli --opt_off esp typo nbsp apos  -f main.txt > grammalecte.txt

%.txt: %.tex
	detex $< > $@

pdf: $(TARGET).pdf 

%.pdf: %.tex %.toc $(DEPBIB) 
	lualatex $<

%.bbl: %.bcf
	biber $<


%.bcf %.toc &: %.tex
	lualatex $<

clean: clean-temp
	rm -f *.pdf *.dvi *.synctex.gz

clean-temp:
	rm -f *.log *.toc *.aux *.bbl *.blg *.bcf *.run.xml *.out *.fdb_latexmk *.fls *.nav *.snm
