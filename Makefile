default: ms.pdf ms.R

publish: slides.pdf notes.pdf handout.pdf
	rsync --chmod=a+rX,go-w $^ salix:/var/www/html/kingaa/talks/2024/Lisbon/

FIGS=$(wildcard figs/*.tex)

ms.pdf: ms.tex defs.tex header.tex $(FIGS)

slides.pdf handout.pdf notes.pdf: talk.tex defs.tex talk_header.tex beamer.tex $(FIGS)

ms.tex: setup.R

.INTERMEDIATE: ms.tex

include rules.mk

clean: .clean

fresh: .fresh
	$(RM) ms.tex
