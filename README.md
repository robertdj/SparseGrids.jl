# Sparsegrids

[![Build Status](https://travis-ci.org/robertdj/Sparsegrids.jl.svg?branch=master)](https://travis-ci.org/robertdj/SparseGrids.jl)

This package computes sparse grids for quadrature rules used to compute multidimensional integrals.


## Installation ##

Run 

	Pkg.add("SparseGrids")

The sparse grid computation depends on the [Iterators](https://github.com/JuliaLang/Iterators.jl) package.

The default procedure for generating the required 1 dimensional quadratures schemes uses the [FastGaussQuadrature](https://github.com/ajt60gaibb/FastGaussQuadrature.jl) package.


## Usage ##

The procedure for calculating the quadrature nodes and points is called `sparsegrid` .
It requires as arguments the dimension of the integrant and either cells with 1 dimensional nodes and weights or the order of the quadrature scheme from which the required nodes and weights are computed -- currently using the Gauss-Hermite scheme:

	nodes, weigths = sparsegrid(D, order)

If `func` is a function of `D` variables with real output, the integral of `func*Gaussian` over `R^D` can be computed/approximated by

	dot( func(nodes), weights )

See also the scripts in the `test` folder.


## Acknowledgements ##

The sparse grid quadrature rules are described in e.g.

* Thomas Gerstner, Michael Griebel, "Numerical integration using sparse grids", Numerical Algorithms, 1998, 209--232.
DOI: [10.1023/A:1019129717644](http://dx.doi.org/10.1023/A:1019129717644)
* Florian Heiss, Victor Winschel, "Likelihood approximation by numerical integration on sparse grids", Journal of Econometrics, 2008, 144, 62--80.
DOI: [10.1016/j.jeconom.2007.12.004](http://dx.doi.org/10.1016/j.jeconom.2007.12.004)
* Vesa Kaarnioja, "[Smolyak Quadrature](http://hdl.handle.net/10138/40159)", Master's thesis, University of Helsinki, 2013.

The Matlab scripts released in connection with the paper by Heiss & Winschel have also served as an inspiration in the implementation. 
These are found at [http://www.sparse-grids.de](http://www.sparse-grids.de).
Note that there are some disagreements between these Matlab scripts and the paper; the Matlab scripts are correct, as confirmed by testing.

The algorithm for computing the integer D-vectors with constant 1-norm is found in e.g. Kaarnioja's thesis as Algorithm 1.11.


## ToDos ##

Sparse grids generated with nested quadrature rules have less points in higher dimensions. 
At some points this may be implemented from e.g.

* Sanjay Mehrotra, David Papp; "Generating nested quadrature formulas for general weight functions with known moments"
arXiv: [1203.1554 [math.NA]](http://arxiv.org/abs/1203.1554v1)

