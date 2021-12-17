PDFLATEX = pdflatex
BIBTEX = bibtex
MAKEIDX = makeindex
CP = cp
RM = rm -f

REXE = R --vanilla
RCMD = $(REXE) CMD
RSCRIPT = Rscript --vanilla

%.pdf: %.tex
	$(PDFLATEX) $*
	-$(BIBTEX) $*
	$(PDFLATEX) $*
	$(PDFLATEX) $*

%.so: %.c
	$(RCMD) SHLIB -o $*.so $*.c
	$(RM) $*.o

%.html: %.Rmd
	PATH=/usr/lib/rstudio/bin/pandoc:$$PATH \
	Rscript --vanilla -e "rmarkdown::render(\"$*.Rmd\",output_format=\"html_document\")"

%.html: %.md
	PATH=/usr/lib/rstudio/bin/pandoc:$$PATH \
	Rscript --vanilla -e "rmarkdown::render(\"$*.md\",output_format=\"html_document\")"

%.R: %.Rmd
	Rscript --vanilla -e "library(knitr); purl(\"$*.Rmd\",output=\"$*.R\")"

%.tex: %.Rnw
	$(RSCRIPT) -e "library(knitr); knit(\"$*.Rnw\")"

%.R: %.Rnw
	$(RSCRIPT) -e "library(knitr); purl(\"$*.Rnw\")"

%.idx: %.tex
	-$(PDFLATEX) $*

%.ind: %.idx
	$(MAKEIDX) $*

.clean:
	$(RM) *.log *.blg *.ilg *.aux *.lof *.lot *.toc *.idx
	$(RM) *.ttt *.fff *.out *.nav *.snm *.bak
	$(RM) *.ps *.bbl *.ind *.dvi
	$(RM) *.o *.so
	$(RM) *.synctex.gz *-concordance.tex
	$(RM) *.brf
	$(RM) Rplots.*

.fresh: clean
	$(RM) -r tmp
