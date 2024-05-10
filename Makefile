default: ms.pdf ms.R

FIGS=$(wildcard figs/*.tex)
BIBFILE=phylopomp.bib

ms.pdf: ms.tex defs.tex header.tex $(FIGS) $(BIBFILE)



ms.tex: setup.R

.INTERMEDIATE: ms.tex

include rules.mk

clean: .clean

fresh: .fresh
	$(RM) ms.tex
