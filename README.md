# Exact Phylodynamic Likelihood via Structured Markov Genealogy Processes

## Authors

[![Static Badge](https://img.shields.io/badge/Aaron%20A.%20King-orchid)](https://orcid.org/0000-0001-6159-3207)&nbsp;&nbsp;
[![Static Badge](https://img.shields.io/badge/Qianying%20Lin-orchid)](https://orcid.org/0000-0001-8620-9910)&nbsp;&nbsp;
[![Static Badge](https://img.shields.io/badge/Edward%20L.%20Ionides-orchid)](https://orcid.org/0000-0002-4190-0174)


## Abstract

We show that each member of a broad class of Markovian population models induces a unique stochastic process on the space of genealogies.  We construct this genealogy process and derive exact expressions for the likelihood of an observed genealogy in terms of a filter equation, the structure of which is completely determined by the population model.  We show that existing phylodynamic methods based on the coalescent and linear birth-death processes are special cases.  We derive some properties of filter equations and describe a class of algorithms that can be used to numerically solve them.  Importantly, because these algorithms rely only on simulation of the population model, they retain the plug-and-play property upon which simulation-based inference depends.  Our results open the door to statistically efficient likelihood-based phylodynamic inference for a much wider class of models than has been possible.

The paper has been accepted for publication in *Theoretical Population Biology*.

## Archives

A version is available on the arXiv:  
[![](https://img.shields.io/badge/doi-10.48550/arxiv.2405.17032-yellow.svg)](https://doi.org/10.48550/arxiv.2405.17032)

The codes needed to generate the text and figures are archived on Zenodo:  
[![](https://img.shields.io/badge/doi-10.5281/zenodo.21461034-yellow.svg)](https://doi.org/10.5281/zenodo.21461034)

## Software

The figures and numerical results in the paper were prepared using the **R** package **phylopomp**:  
[![](https://img.shields.io/badge/R-phylopomp-blue.svg)](https://github.com/kingaa/phylopomp)

## Contents

- `ms.pdf`: manuscript document.
- `ms.Rnw`: main manuscript file.
- `Makefile`, `rules.mk`: for use with GNU `make`.
  Running `make` will build the manuscript document *de novo*.
  To run all computations *de novo* delete or move the `results/` directory.
- `defs.tex`: LaTeX macro definitions.
- `ms_header.tex`: LaTeX header file.
- `ms.R`: **R** code contained in `ms.Rnw`.
- `ms.Rout`: output of running `ms.R`.
- `setup.R`: needed **R** definitions.
- `phylopomp_0.19.4.2.tar.gz`: source tarball of **phylopomp** package used in the computations.
- `preprint.bst`: BibTeX style file.
- `figures/`: directory containing LaTeX code for diagrams.
- `results/`: directory containing the results of some of the computations.
  By default, these will be read rather than recomputed. Move or delete these files to force re-computation.


## Related material

- **PhyloPOMP.jl**  
[![](https://img.shields.io/badge/Julia-PhyloPOMP.jl-blue)](https://kingaa.github.io/PhyloPOMP.jl/)
- **pomp**  
[![](https://img.shields.io/badge/R-pomp-blue)](https://kingaa.github.io/pomp/)&nbsp;&nbsp;
[![](https://img.shields.io/badge/CRAN-pomp-blue)](https://doi.org/10.32614/CRAN.package.pomp)
- A. A. King, Q. Lin, and E. L. Ionides, Markov genealogy processes. *Theoretical Population Biology* **143:**77&ndash;91, 2022.  
[![](https://img.shields.io/badge/doi-10.1016/j.tpb.2021.11.003-green.svg)](https://doi.org/10.1016/j.tpb.2021.11.003)
