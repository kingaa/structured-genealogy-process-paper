default: ms.pdf ms.R

.INTERMEDIATE: ms.tex

ms.pdf: header.tex defs.tex

include rules.mk

clean: .clean

fresh: .fresh
	$(RM) ms.tex
