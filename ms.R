## ----packages,include=FALSE,cache=FALSE---------------------------------------
library(tidyverse)
library(ggtree)
library(pomp)
library(cowplot)
library(phylopomp)
stopifnot(getRversion() >= "4.3")
stopifnot(packageVersion("pomp")>="5.1")
stopifnot(packageVersion("phylopomp")>="0.9.2")
theme_set(theme_bw(base_family="serif"))
set.seed(1159254136)

