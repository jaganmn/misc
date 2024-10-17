# TMB implementations of LKJ, Wishart, and inverse Wishart distributions

[`distributions.hpp`](distributions.hpp) is a header file implementing
four functions:

```cpp
Type mvlgamma(Type x, unsigned int n = 1)
Type dlkj(const vector<Type> &x, Type shape, int give_log = 0)
Type dwishart(const vector<Type> &x, Type shape, const vector<Type> &scale, int give_log = 0)
Type dinvwishart(const vector<Type> &x, Type shape, const vector<Type> &scale, int give_log = 0)
```

`mvlgamma` evaluates the log
[`n`-variate gamma function](https://en.wikipedia.org/wiki/Multivariate_gamma_function)
at `x`, subject to the constraint `x > (n-1)/2`.

`dlkj` computes the
[Lewandowski-Kurowicka-Joe](https://en.wikipedia.org/wiki/Lewandowski-Kurowicka-Joe_distribution) (LKJ)
density of a symmetric positive definite matrix with unit diagonal
(i.e., a correlation matrix) `X`.
Vector `x` specifies matrix `X` indirectly as described
[here](https://kaskr.github.io/adcomp/classdensity_1_1UNSTRUCTURED__CORR__t.html).
Hence if `X` is an `n`-by-`n` matrix, then `x` must have length `n*(n-1)/2`.
`shape = log(eta)` is a shape parameter controlling the concentration of the
density around the identity matrix.

`dwishart` and `dinvwishart` compute the
[Wishart](https://en.wikipedia.org/wiki/Wishart_distribution)
and
[inverse Wishart](https://en.wikipedia.org/wiki/Inverse-Wishart_distribution)
densities of a symmetric positive definite matrix
(i.e., a covariance matrix) `X`.
Vector `x` specifies matrix `X` indirectly:
if `X` is an `n`-by-`n` matrix, then `x` must have length `n*(n+1)/2`,
`head(x, n)` must contain the log standard deviations `log(sqrt(diag(X)))`,
and `tail(x, n*(n-1)/2)` must specify `cov2cor(X)`
(see again [here](https://kaskr.github.io/adcomp/classdensity_1_1UNSTRUCTURED__CORR__t.html)).
`shape = log(nu - n - 1)` is a shape parameter specifying the degrees of
freedom `nu`, subject to the constraint `nu > n - 1`.
`scale` specifies the `n`-by-`n` symmetric positive definite scale matrix
`S` in the same way that `x` specifies `X`.

Computational details can be found in [`distributions.tex`](distributions.tex).

Tests for agreement between the C++ functions and independently implemented
R functions can be found in [`distributions.R`](distributions.R).
The script compiles function template [`distributions.cpp`](distributions.cpp).
The compiled function passes `DATA_*` objects from R as arguments to the C++
functions and `REPORT`s results back to R for validation.
