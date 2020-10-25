# SparseGrids

[![Build Status](https://travis-ci.org/robertdj/SparseGrids.jl.svg?branch=master)](https://travis-ci.org/robertdj/SparseGrids.jl)
[![codecov.io](https://codecov.io/github/robertdj/SparseGrids.jl/coverage.svg?branch=master)](https://codecov.io/github/robertdj/SparseGrids.jl?branch=master)

This package computes sparse grids for quadrature rules used to compute multidimensional integrals.


## Installation

In Julia switch to `Pkg` with `]` and run

```julia
add SparseGrids
```


## Usage

If `f` is a function that returns `nodes, weights = f(n)`, for any (integer) order `n`, then the function `sparsegrid` computes the sparse extension to `D` dimensions of order `O`:

```julia
nodes, weigths = sparsegrid(D, O, f)
```

By default, `f` is `gausshermite` from the [FastGaussQuadrature](https://github.com/ajt60gaibb/FastGaussQuadrature.jl) package.
The `gausshermite` quadrature rule is used for computing integrals over `R^D` with integrants of the form `g(x) * exp(-|x|^2)`.
To approximate such an integral, compute

```julia
dot(weigths, g.(nodes))
```

Note that when integrating against `exp(-|x|^2)` instead of the standard Gaussian density, the nodes and weigths are rescaled compared to e.g. the source of the Kronrod-Patterson nodes mentioned below.

This package offers another node generating function for "Gaussian" integrals, `kpn`, for the *nested* Kronrod-Patterson nodes.
When the 1D nodes are nested, the higher dimensional sparse grids contain fewer points.

The easy extension of 1D nodes (where the number of nodes also grows *much* faster) is by tensor products.
This is available by the function `tensorgrid` that takes the same inputs as `sparsegrid`.


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

