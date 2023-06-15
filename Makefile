default: ms.pdf ms.R

FIGS = $(wildcard figs/*.tex)

ms.pdf: $(FIGS)

.INTERMEDIATE: ms.tex

ms.pdf: header.tex defs.tex

include rules.mk

clean: .clean

fresh: .fresh
