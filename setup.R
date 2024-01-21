library(knitr)
if (!exists("prefix")) prefix <- ""
opts_chunk$set(
             cache=TRUE,
             cache.extra=rand_seed,
             cache.path=paste0("tmp/",as.character(prefix),"/cache/"),
             progress=TRUE,
             prompt=FALSE,
             tidy=FALSE,
             strip.white=TRUE,
             message=FALSE,
             warning=FALSE,
             error=FALSE,
             echo=FALSE,
             results="hide",
             fig.show="asis",
             size="small",
             fig.lp="fig:",
             fig.path=paste0("tmp/",as.character(prefix),"/figure/"),
             fig.align="center",
             out.width="80%",
             fig.dim=c(6.83,4),
             dpi=300,
             dev="pdf",
             dev.args=list(bg="transparent")
           )

options(
  width=150,
  keep.source=TRUE,
  encoding="UTF-8",
  stringsAsFactors=FALSE,
  dplyr.summarise.inform=FALSE,
  pomp_archive_dir="results"
)

maize <- "#ffcb05"
blue <- "#00274c"

myround <- function (x, digits = 1L) {
  ## adapted from the broman package
  ## solves the bug that round() kills significant trailing zeros
  if (length(digits) > 1L) {
    digits <- digits[1L]
    warning("Using only digits[1]")
  }
  if (digits < 1L) {
    as.character(round(x,digits))
  } else {
    tmp <- sprintf(paste0("%.", digits, "f"), x)
    zero <- paste0("0.", paste(rep("0", digits), collapse = ""))
    tmp[tmp == paste0("-", zero)] <- zero
    tmp
  }
}

mysignif <- function (x, digits = 1L) {
  myround(x, digits - ceiling(log10(abs(x))))
}
