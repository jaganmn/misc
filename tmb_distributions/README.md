## TMB implementations of LKJ, Wishart, and inverse Wishart distributions

`distributions.h` is a header file implementing four functions:

```cpp
mvlgamma(Type x, int p)
dlkj(vector<Type> x, Type eta, int give_log)
dwishart(vector<Type> x, Type df, vector<Type> scale, int give_log = 1)
dwishart(vector<Type> x, Type df, vector<Type> scale, int give_log = 1)
```

`mvlgamma` evaluates the log 
[`p`-variate gamma function](https://en.wikipedia.org/wiki/Multivariate_gamma_function) 
at `x > 0.5 * (p - 1)`.

`dlkj` computes the
[Lewandowski-Kurowicka-Joe](https://mc-stan.org/docs/2_27/functions-reference/lkj-correlation.html)
(LKJ) density of the `n`-by-`n` unit diagonal, symmetric positive
definite matrix `X` parametrized by `x`. `x` is expected to have
length `n*(n-1)/2` and map to `X` as described
[here](https://kaskr.github.io/adcomp/classUNSTRUCTURED__CORR__t.html). 
`eta > 0` is a shape parameter controlling the concentration of the 
density around the identity matrix.

`dwishart` and `dinvwishart` compute the 
[Wishart](https://mc-stan.org/docs/2_27/functions-reference/wishart-distribution.html) 
and 
[inverse Wishart](https://mc-stan.org/docs/2_27/functions-reference/inverse-wishart-distribution.html) 
densities of the `n`-by-`n` symmetric positive definite matrix `X` 
parametrized by `x`. `x` is expected to have length `n*(n+1)/2`, 
with `head(x, n)` containing the log standard deviations `log(sqrt(diag(X)))` 
and `tail(x, n*(n-1)/2)` mapping to `cov2cor(X)` (see above). 
`df` is the degrees of freedom, which must be greater than `n - 1`. 
`scale`  is a vector of length `n*(n+1)/2` defining the `n`-by-`n` 
symmetric positive definite scale matrix `S`, in the same way that 
`x` defines `X`.

Computational details can be found in `notes.tex`.

Simple tests for agreement between the C++ functions and independently 
implemented R functions are provided in `distributions.R`. This compiles 
function template `distributions.cpp`. The function takes `DATA_*` from R, 
passes them as arguments to the C++ functions, and `REPORT`s the results 
back to R for validation.
