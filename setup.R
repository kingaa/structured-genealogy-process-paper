## ----setup--------------------------------------------------
library(knitr)
opts_chunk$set(
  cache=TRUE,
  cache.path=paste0("tmp/",prefix,"/"),
  comment=NA,
  echo=FALSE,
  eval=TRUE,
  include=TRUE,
  dev="cairo_pdf",
  dev.args=list(bg='transparent'),
  dpi=300,
  error=FALSE,
  fig.align='center',
  fig.dim=c(4,6.83),
  fig.lp="fig:",
  fig.path=paste0("tmp/",prefix,"/"),
  fig.pos="h!",
  fig.show='asis',
  highlight=TRUE,
  message=FALSE,
  progress=TRUE,
  prompt=FALSE,
  purl=TRUE,
  results="markup",
  size='small',
  strip.white=TRUE,
  tidy=FALSE,
  warning=FALSE
  )

options(
  width=60,
  keep.source=TRUE,
  encoding="UTF-8"
)

registerS3method(
  "knit_print",
  "data.frame",
  function (x, ...) {
    print(x,row.names=FALSE)
  }
)
