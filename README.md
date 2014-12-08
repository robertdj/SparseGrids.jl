# Sparsegrid

[![Build Status](https://travis-ci.org/robertdj/WaveletGLG.jl.svg?branch=master)](https://travis-ci.org/robertdj/SparseGrid.jl)

This package computes sparse grids for quadrature rules used to compute multidimensional integrals.


## Installation ##

This package is not (yet) in `METADATA`, so clone the Git repository:

	git clone https://github.com/robertdj/SparseGrid.jl

The sparse grid computation depends on the [`Iterators`](https://github.com/JuliaLang/Iterators.jl) package.

The default procedure for generating the required 1 dimensional quadratures schemes uses the [`FastGaussQuadrature`](https://github.com/ajt60gaibb/FastGaussQuadrature.jl) package.


## Usage ##

The procedure for calculating the quadrature nodes and points is called `smolyak` (from the inventer of the approach).
It requires as arguments the dimension of the integrant and either cells with 1 dimensional nodes and weights or the order of the quadrature scheme from which the required nodes and weights are computed -- currently using the Gauss-Hermite scheme:

	nodes, weigths = smolyak(D, order)

The integral of a function `func` with real output can the be computed/approximated with the commands

	dot( func(nodes), weights )

See also the scripts in the `test` folder.


## Acknowledgements ##

The sparse grid quadrature rules are described in e.g.

* Thomas Gerstner, Michael Griebel, "Numerical integration using sparse grids", Numerical Algorithms, 1998, 209--232.
[DOI](http://dx.doi.org/10.1023/A:1019129717644)
* Florian Heiss, Victor Winschel, "Likelihood approximation by numerical integration on sparse grids", Journal of Econometrics, 2008, 144, 62-80.
[DOI](http://dx.doi.org/10.1016/j.jeconom.2007.12.004)
* Vesa Kaarnioja, "Smolyak Quadrature", Master's thesis, University of Helsinki, 2013.

The Matlab scripts released in connection with the paper by Heiss & Winschel have also served as an inspiration in the implementation. 
These are found at [http://www.sparse-grids.de](http://www.sparse-grids.de).

The algorithm for computing the integer D-vectors with constant 1-norm is found in e.g. Kaarnioja's thesis as Algorithm 1.11.

