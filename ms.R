## ----packages,include=FALSE,cache=FALSE---------------------------------------
library(tidyverse)
library(ggtree)
library(pomp)
library(cowplot)
library(viridis)
library(phylopomp)
stopifnot(getRversion() >= "4.3")
stopifnot(packageVersion("pomp")>="5.1")
stopifnot(packageVersion("phylopomp")>="0.10.1")
theme_set(theme_bw(base_family="serif"))
set.seed(1159254136)


## ----upo,fig.dim=c(6,8),out.width="60%",results="hide"------------------------
freeze(
  seed=522390503,
  simulate(
    "SEIR",
    Beta=1,sigma=0.5,gamma=0.1,psi=0.4,delta=0.1,
    S0=10,E0=1,I0=1,R0=0,
    time=10
  )
) -> x

pal <- c("#00274CFF","#FFCB05FF")

plot_grid(
  A=x |>
    plot(points=TRUE,prune=FALSE,obscure=FALSE,palette=pal)+
    lims(x=c(NA,10),y=c(3,NA))+
    geom_vline(xintercept=10,linewidth=0.2,color="black"),
  B=x |>
    plot(points=TRUE,prune=TRUE,obscure=FALSE,palette=pal)+
    lims(x=c(NA,10),y=c(3,NA))+
    geom_vline(xintercept=10,linewidth=0.2,color="black"),
  C=x |>
    plot(points=TRUE,prune=TRUE,obscure=TRUE,palette="#B3B3B3FF")+
    lims(x=c(NA,10),y=c(3,NA))+
    geom_vline(xintercept=10,linewidth=0.2,color="black")+
    labs(x="time"),
  ncol=1,
  align="hv",axis="tblr",
  labels="AUTO"
)

