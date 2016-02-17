# Sparsegrids

[![Build Status](https://travis-ci.org/robertdj/Sparsegrids.jl.svg?branch=master)](https://travis-ci.org/robertdj/SparseGrids.jl)

This package computes sparse grids for quadrature rules used to compute multidimensional integrals.


## Installation

In Julia, run 

```julia
Pkg.add("SparseGrids")
```


## Usage

From one-dimensional nodes `n` and weights `w`, the function `sparsegrid` computes the sparse extension to `D` dimensions:

```julia
nodes, weigths = sparsegrid(D, n, w)
```

Both `n` and `w` should be *cells* of nodes/weigths up to the desired order of the quadrature rule.

A variant of `sparsegrid` uses "known" nodes for computing integrals over `R^D` with integrants of the form `f(x) * exp(-|x|^2)`.
This kind of integral can be approximated with the Gauss-Hermite nodes or the Kronrod-Patterson nodes.
The Kronrod-Patterson nodes are *nested*, reducing the number of nodes in higher dimensions compared to the Gauss-Hermite nodes.

To approximate the integral, compute
```julia
dot( weigths, f(nodes) )
```

Note that when integrating against `exp(-|x|^2)` instead of the standard Gaussian density, the nodes and weigths are rescaled compared to e.g. the source of the Kronrod-Patterson nodes.


## References

The sparse grid quadrature rules are described in e.g.

* Thomas Gerstner, Michael Griebel, "Numerical integration using sparse grids", Numerical Algorithms, 1998, 209--232.
DOI: [10.1023/A:1019129717644](http://dx.doi.org/10.1023/A:1019129717644)
* Florian Heiss, Victor Winschel, "Likelihood approximation by numerical integration on sparse grids", Journal of Econometrics, 2008, vol. 144, pp. 62--80.
DOI: [10.1016/j.jeconom.2007.12.004](http://dx.doi.org/10.1016/j.jeconom.2007.12.004)
* Vesa Kaarnioja, "[Smolyak Quadrature](http://hdl.handle.net/10138/40159)", Master's thesis, University of Helsinki, 2013.

The Matlab scripts released in connection with the paper by Heiss & Winschel have also served as an inspiration in the implementation. 
These are found at [http://www.sparse-grids.de](http://www.sparse-grids.de).
Note that there are some disagreements between these Matlab scripts and the paper; the Matlab scripts are correct, as confirmed by testing.

The algorithm for computing the integer D-vectors with constant 1-norm is found in e.g. Kaarnioja's thesis as Algorithm 1.11.

The nested nodes are obtained from the sparse-grids web page.

## ToDos

At some point methods for *computing* nested nodes may be implemented using techniques from e.g.

* Sanjay Mehrotra, David Papp, "Generating nested quadrature formulas for general weight functions with known moments"
arXiv: [1203.1554 [math.NA]](http://arxiv.org/abs/1203.1554v1)

