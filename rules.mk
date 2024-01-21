REXE = Rscript --no-save --no-restore --no-init-file
RBATCH = R CMD BATCH --no-save --no-restore
RSCRIPT = Rscript --vanilla
RCMD = $(REXE) CMD
PANDOC = pandoc -s -t html5+smart --mathjax
PDFLATEX = pdflatex -halt-on-error -file-line-error -interaction batchmode
BIBTEX = bibtex
CP = cp -f
RM = rm -f
ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

%.pdf: export BSTINPUTS=$(ROOT_DIR)
%.pdf: export BIBINPUTS=$(ROOT_DIR)
%.pdf: export TEXINPUTS=.:$(ROOT_DIR):$(shell echo $$TEXINPUTS)
%.pdf: export SOURCE_DATE_EPOCH=954590400

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
