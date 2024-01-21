default: ms.pdf ms.R slides.pdf notes.pdf handout.pdf

FIGS=$(wildcard figs/*.tex)

slides.pdf handout.pdf notes.pdf: talk.tex

ms.tex: setup.R defs.tex $(FIGS)

.INTERMEDIATE: ms.tex

ms.pdf: ms.tex

ms.tex: header.tex

talk.tex: talk_header.tex beamer.tex

include rules.mk

clean: .clean

fresh: .fresh
	$(RM) ms.tex
