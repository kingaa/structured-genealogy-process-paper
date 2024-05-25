## ----packages,include=FALSE,cache=FALSE---------------------------------------
library(tidyverse)
library(ggtree)
library(pomp)
library(cowplot)
library(viridis)
library(phylopomp)
stopifnot(getRversion() >= "4.3")
stopifnot(packageVersion("pomp")>="5.8")
stopifnot(packageVersion("phylopomp")>="0.12.0.1")
theme_set(theme_bw(base_family="serif"))
options(
  width=150,
  keep.source=TRUE,
  encoding="UTF-8",
  stringsAsFactors=FALSE,
  dplyr.summarise.inform=FALSE,
  pomp_archive_dir="results"
)
set.seed(1159254136)


## ----geneal,fig.dim=c(4,2),out.width="50%"------------------------------------
freeze(
  seed=382490723,
  simulate(
    "SEIR",
    Beta=3,sigma=0.5,gamma=0.2,psi=0.3,omega=0.5,
    S0=15,E0=1,I0=2,R0=0,
    time=10
  )
) -> x

pal <- c("#00274CFF","#FFCB05FF")

x |> plot(points=TRUE,prune=FALSE,obscure=FALSE,palette=pal)+
  geom_vline(xintercept=10,linewidth=0.2,color="black")


## ----upo,fig.dim=c(4,6),out.width="50%"---------------------------------------
freeze(
  seed=522390503,
  simulate(
    "SEIR",
    Beta=1,sigma=0.5,gamma=0.1,psi=0.4,omega=0.1,
    S0=10,E0=1,I0=1,R0=0,
    time=10
  )
) -> x

pal <- c("#00274CFF","#FFCB05FF")

plot_grid(
  A=x |>
    plot(
      points=TRUE,prune=FALSE,obscure=FALSE,
      ladderize=FALSE,palette=pal
    )+
    geom_vline(xintercept=10,linewidth=0.2,color="black"),
  B=x |>
    plot(
      points=TRUE,prune=TRUE,obscure=FALSE,
      ladderize=FALSE,palette=pal
    )+
    geom_vline(xintercept=10,linewidth=0.2,color="black"),
  C=x |>
    plot(
      points=TRUE,prune=TRUE,obscure=TRUE,
      ladderize=FALSE,palette="#B3B3B3FF"
    )+
    geom_vline(xintercept=10,linewidth=0.2,color="black"),
  ncol=1,
  align="hv",axis="tblr",
  labels="AUTO"
)


## ----sirs3--------------------------------------------------------------------
data.frame(
  Beta=4,gamma=2,psi=1,omega=1,
  S0=97,I0=3,R0=0,t0=0,time=40
) -> sirs.params

bake(
  file="sirs3a.rds",
  seed=328168304L,
  dependson=sirs.params,
  {
    library(phylopomp)
    sirs.params |>
      with(
        runSIRS(
          Beta=Beta,gamma=gamma,psi=psi,omega=omega,
          S0=S0,I0=I0,R0=R0,t0=t0,time=time
        )
      )
  }
) -> sirs_tree

bake(
  file="sirs3b.rds",
  seed=621400057L,
  dependson=list(sirs_tree,sirs.params),
  {
    sirs.params |>
      with(
        expand_grid(
          Beta=Beta,
          ##      gamma=gamma,
          gamma=seq(1.7,2.3,by=0.02),
          psi=psi,
          omega=omega,
          ##      omega=seq(0.5,2,by=0.05),
          S0=S0,I0=I0,R0=R0,
          t0=t0,
          rep=1:16,
          Np=5000,
          )
      ) -> params

    library(iterators)
    library(doFuture)
    plan(multicore)

    foreach (
      p=iter(params,"row"),
      .combine=bind_rows,
      .options.future=list(seed=TRUE)
    ) %dofuture% {
      library(pomp)
      library(phylopomp)
      p |>
        with({
          sirs_tree |>
            sirs_pomp(
              Beta=Beta,gamma=gamma,psi=psi,omega=omega,
              S0=S0,I0=I0,R0=R0,t0=0
            ) |>
            pfilter(Np=Np) |>
            logLik()
        }) -> ll
      bind_cols(p,logLik=ll)
    } -> params
  }
) -> params

params |>
  with(
    mcap(logLik,gamma)
  ) -> mcap


## ----sirs3_plot,dependson="sirs1",fig.dim=c(8,2.8),out.width="100%"-----------
plot_grid(
  A=sirs_tree |>
    plot(points=FALSE,palette=c("#000000"))+
    labs(x="time"),
  B=params |>
    ggplot(aes(x=gamma,y=logLik))+
    geom_point(alpha=0.2)+
    geom_line(data=mcap$fit,aes(x=parameter,y=smoothed),color="blue")+
    geom_vline(xintercept=sirs.params$gamma,color="red")+
    geom_vline(xintercept=mcap$ci,linetype=2)+
    geom_hline(
      yintercept=max(mcap$fit$smoothed)-c(0,mcap$delta),
      linetype=2
    )+
    labs(
      color=character(0),
      y="log likelihood",
      x=expression(gamma)
    )+
    ## lims(y=c(max(params$logLik)-16,NA))+
    theme_classic()+
    theme(
      legend.position=c(0.5,0.27)
    ),
  labels="AUTO",
  nrow=1,
  rel_widths=c(1,1)
)


## ----seirs3-------------------------------------------------------------------
seirs.params <- data.frame(
  Beta=4,sigma=1,gamma=1,psi=1,omega=1,
  S0=200,E0=3,I0=5,R0=100,
  time=3
)

bake(
  file="seirs3a.rds",
  seed=831282841L,
  dependson=seirs.params,
  seirs.params |>
    with(
      runSEIR(
        Beta=Beta,sigma=sigma,gamma=gamma,psi=psi,omega=omega,
        S0=S0,E0=E0,I0=I0,R0=R0,
        time=time
      )
    )
) -> seirs_tree

bake(
  file="seirs3b.rds",
  seed=831282841L,
  dependson=list(seirs.params,seirs_tree),
  {
    library(phylopomp)
    library(circumstance)
    library(doFuture)
    plan(multicore)

    seirs.params |>
      with(
        seirs_tree |>
          seirs_pomp(
            Beta=Beta,sigma=sigma,gamma=gamma,psi=psi,omega=omega,
            S0=S0,E0=E0,I0=I0,R0=R0
          )
      ) -> po

    seq(0.2,2.5,by=0.1) |>
      lapply(
        \(s) {
          x <- po
          coef(x,"sigma") <- s
          x
        }
      ) |>
      concat() |>
      pfilter(Np=20000,Nrep=10)
  }
) -> pfs

left_join(
  pfs |> coef() |> melt() |> pivot_wider(),
  pfs |> logLik() |> melt() |> rename(logLik=value),
  by=c(".id"="name")
) -> params

params |>
  with(
    mcap(logLik,sigma,span=0.5)
  ) -> mcap


## ----seirs3_plot,fig.dim=c(8,2.8),out.width="100%",dependon="seirs3"----------
plot_grid(
  A=seirs_tree |>
    plot(points=TRUE,palette="#000000")+
    labs(x="time"),
  B=params |>
    ggplot()+
    geom_point(aes(x=sigma,y=logLik))+
    geom_line(data=mcap$fit,aes(x=parameter,y=smoothed),color="blue")+
    geom_vline(xintercept=seirs.params$sigma,color="red")+
    geom_vline(xintercept=mcap$ci,linetype=2)+
    geom_hline(
      yintercept=max(mcap$fit$smoothed)-c(0,mcap$delta),
      linetype=2
    )+
    ##        lims(y=c(max(params$logLik)-12,NA))+
    labs(
      color=character(0),
      y="log likelihood",
      x=expression(sigma)
    )+
    theme_classic(),
  labels="AUTO",
  nrow=1,
  rel_widths=c(3,4)
)


## ----lbdp3--------------------------------------------------------------------
lbdp.params <- data.frame(
  lambda=1.2,mu=0.8,psi=1,n0=5,
  time=10
)

bake(
  file="lbdp3a.rds",
  seed=915645370,
  dependson=lbdp.params,
  lbdp.params |>
    with(
      runLBDP(lambda=lambda,mu=mu,psi=psi,n0=n0,time=time)
    )
) -> lbdp_tree

bake(
  file="lbdp3b.rds",
  seed=712604404,
  dependson=list(lbdp_tree,lbdp.params),
  {
    lbdp.params |>
      with(
        expand_grid(
          rep=1:10,
          lambda=lambda,
          mu=seq(0.5,1.1,by=0.05),
          psi=psi,
          n0=n0,
          Np=1000*2^seq(0,7)
        )
      ) -> params

    library(iterators)
    library(doFuture)
    plan(multicore)

    foreach (
      p=iter(params,"row"),
      .combine=bind_rows,
      .options.future=list(seed=TRUE)
    ) %dofuture% {
      p |>
        with(
          lbdp_tree |>
            lbdp_exact(lambda=lambda,mu=mu,psi=psi,n0=n0)
        ) -> ll1
      p |>
        with(
          lbdp_tree |>
            lbdp_pomp(lambda=lambda,mu=mu,psi=psi,n0=n0) |>
            pfilter(Np=Np) |>
            logLik()
        ) -> ll2
      bind_cols(p,exact=ll1,pf=ll2)
    }-> params
  }
) -> params

params |>
  mutate(
    diff=pf-exact
  ) |>
  group_by(Np) |>
  summarize(
    rmse=sqrt(mean(diff*diff)),
    bias=abs(mean(diff)),
    prec=sqrt(rmse^2-bias^2)
  ) |>
  ungroup() -> stats


## ----lbdp3_plot,fig.dim=c(9,7),out.width="100%"-------------------------------
pal <- c(viridis_pal(option="H",begin=0.1,end=0.8)(8),"#000000")
names(pal) <- c("1k","2k","4k","8k","16k","32k","64k","128k","exact")

plot_grid(
  ncol=1,
  rel_heights=c(3,2),
  AB=plot_grid(
    labels=c("A","B"),
    nrow=1,
    rel_widths=c(3,5),
    A=lbdp_tree |>
      plot(points=FALSE,palette="#000000")+
      labs(x="time"),
    B=params |>
      pivot_longer(c(exact,pf)) |>
      unite(name,name,Np) |>
      mutate(
        name=if_else(grepl("exact",name),"exact",name),
        name=gsub("pf_","",name),
        name=gsub("000","k",name),
        name=ordered(name,levels=names(pal))
      ) |>
      group_by(lambda,mu,psi,n0,name) |>
      reframe(
        type=c("logLik","logLik_se"),
        value=logmeanexp(value,se=TRUE)
      ) |>
      ungroup() |>
      pivot_wider(names_from=type) |>
      mutate(
        y=logLik,
        ymax=logLik+2*logLik_se,
        ymin=logLik-2*logLik_se
      ) |>
      filter(logLik>max(logLik)-16) |>
      ggplot(
        aes(
          x=mu,group=name,color=name,
          y=y,ymin=ymin,ymax=ymax
        )
      )+
      geom_errorbar(
        position="dodge"
      )+
      geom_vline(xintercept=lbdp.params$mu,color="red")+
      geom_hline(
        yintercept=max(params$exact)-
          c(0,0.5*qchisq(p=0.95,df=1)),
        linetype=2
      )+
      scale_color_manual(values=pal)+
      labs(
        color="effort",
        y="log likelihood",
        x=expression(mu)
      )+
      theme(
        ## legend.position="inside",
        ## legend.position.inside=c(0.5,0.4),
        ## legend.background=element_rect(fill="white")
      )
  ),
  CDE=plot_grid(
    labels=c("C","D","E"),
    nrow=1,
    rel_widths=c(24,24,17),
    C=stats |>
      ggplot(aes(x=Np,y=rmse))+
      geom_smooth(formula=y~x,method="lm")+
      geom_point()+
      scale_x_log10(labels=\(x)aakmisc::scinot(x,simplify=TRUE))+
      scale_y_log10()+
      coord_fixed(ratio=1)+
      labs(x="effort",y="RMSE"),
    D=stats |>
      ggplot(aes(x=Np,y=prec))+
      geom_smooth(formula=y~x,method="lm")+
      geom_point()+
      scale_x_log10(labels=\(x)aakmisc::scinot(x,simplify=TRUE))+
      scale_y_log10()+
      coord_fixed(ratio=1)+
      labs(x="effort",y="SD"),
    E=stats |>
      ggplot(aes(x=Np,y=bias))+
      geom_smooth(formula=y~x,method="lm")+
      geom_point()+
      scale_x_log10(labels=\(x)aakmisc::scinot(x,simplify=TRUE))+
      scale_y_log10(labels=\(x)aakmisc::scinot(x,simplify=TRUE))+
      coord_fixed(ratio=1)+
      labs(x="effort",y=expression(group("|",bias,"|")))
  )
)


## ----sessioninfo,include=FALSE,purl=TRUE--------------------------------------
sessionInfo()

