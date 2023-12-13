# TMB implementations of LKJ, Wishart, and inverse Wishart distributions

[`distributions.hpp`](distributions.hpp) is a header file implementing
four functions:

```cpp
Type mvlgamma(Type x, int p = 1)
Type dlkj(const vector<Type> &x, Type eta, int give_log = 0)
Type dwishart(const vector<Type> &x, Type df, const vector<Type> &scale, int give_log = 0)
Type dinvwishart(const vector<Type> &x, Type df, const vector<Type> &scale, int give_log = 0)
```

`mvlgamma` evaluates the log
[`p`-variate gamma function](https://en.wikipedia.org/wiki/Multivariate_gamma_function)
at `x`, subject to the constraint `x > (p-1)/2`.

`dlkj` computes the
[Lewandowski-Kurowicka-Joe](https://mc-stan.org/docs/functions-reference/lkj-correlation.html)
density of a unit diagonal, symmetric positive definite matrix
(i.e., a correlation matrix) `X`.
Vector `x` specifies matrix `X` indirectly as described
[here](https://kaskr.github.io/adcomp/classdensity_1_1UNSTRUCTURED__CORR__t.html).
Hence if `X` is an `n`-by-`n` matrix, then `x` must have length `n*(n-1)/2`.
`eta` is a positive shape parameter controlling the concentration
of the density around the identity matrix.

`dwishart` and `dinvwishart` compute the
[Wishart](https://mc-stan.org/docs/functions-reference/wishart-distribution.html)
and
[inverse Wishart](https://mc-stan.org/docs/functions-reference/inverse-wishart-distribution.html)
densities of a symmetric positive definite matrix
(i.e., a covariance matrix) `X`.
Vector `x` specifies matrix `X` indirectly:
if `X` is an `n`-by-`n` matrix, then `x` must have length `n*(n+1)/2`,
`head(x, n)` must contain the log standard deviations `log(sqrt(diag(X)))`,
and `tail(x, n*(n-1)/2)` must specify `cov2cor(X)`
(see again [here](https://kaskr.github.io/adcomp/classdensity_1_1UNSTRUCTURED__CORR__t.html)).
`df` is the degrees of freedom, subject to the constraint `df > n - 1`.
`scale` specifies the `n`-by-`n` scale matrix `S` in the same way that
`x` specifies `X`.

Computational details can be found in [`distributions.tex`](distributions.tex).

Tests for agreement between the C++ functions and independently implemented
R functions can be found in [`distributions.R`](distributions.R).
The script compiles function template [`distributions.cpp`](distributions.cpp).
The compiled function passes `DATA_*` objects from R as arguments to the C++
functions and `REPORT`s results back to R for validation.
