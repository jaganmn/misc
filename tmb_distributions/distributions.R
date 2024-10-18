dll <- "distributions"
cpp <- paste0(dll, ".cpp")
lib <- paste0(dll, .Platform[["dynlib.ext"]])

TMB::compile(cpp)
dyn.load(lib)


## ==== Utilities ======================================================

## Run the indicated test with the supplied data and return the result;
## the length of the result is always 1
report <-
local({
	tt <- paste(readLines(cpp), collapse = "\n")
	tt <- sub("^.*?enum[ \t\n]+test[ \t\n]*\\{(.*?)\\};.*$", "\\1", tt)
	tt <- gsub("[ \t\n]", "", tt)
	enums <- strsplit(tt, ",")[[1L]]
	function(enum, ...) {
		data <- list(flag = match(enum, enums, 0L) - 1L, ...)
		obj <- TMB::MakeADFun(data = data,
		                      parameters = list(),
		                      type = "Fun",
		                      checkParameterOrder = FALSE,
		                      DLL = dll)
		obj[["report"]]()[["res"]]
	}
})

## Construct a covariance matrix Sigma from x = c(log_sd, theta)
makeSigma <-
function(x) {
	n <- as.integer(0.5 * (-1 + sqrt(1 + 8 * length(x))))
	R <- diag(n)
	R[upper.tri(R)] <- x[-seq_len(n)]
	RTR <- crossprod(R)
	r <- exp(x[seq_len(n)] - 0.5 * log(diag(RTR)))
	r * RTR * rep(r, each = n)
}

## Compute sum(log(diag(crossprod(R)))) from x = theta
sumLogDiagRTR <-
function(x) {
	n <- as.integer(0.5 * (1 + sqrt(1 + 8 * length(x))))
	R <- diag(n)
	R[upper.tri(R)] <- x
	sum(log(colSums(R * R)))
}


## ==== Tests ==========================================================

## FIXME: so far mainly testing that C++ and R implementations give equal
##        results, _not_ that the results are mathematically correct

Cmvlgamma <-
function(x, n = 1L)
	report("mvlgamma", x = x, n = n)
Rmvlgamma <-
function(x, n = 1L)
	0.25 * n * (n - 1) * log(pi) + rowSums(lgamma(outer(x, seq.int(from = 0, by = 0.5, length.out = n), `-`)))

set.seed(0xafafaf)
for (n in 1:4)
for (x in (n - 1)/2 + runif(10L, 1, 100))
stopifnot(all.equal(Cmvlgamma(x, n), Rmvlgamma(x, n)))


Cdlkj <-
function(x, shape, give.log = 0L)
	report("dlkj", x = x, shape = shape,
	       give_log = give.log)
Rdlkj <-
function(x, shape, give.log = 0L) {
	n <- as.integer(0.5 * (1 + sqrt(1 + 8 * length(x))))
	r <- sumLogDiagRTR(x)
	eta <- exp(shape)
	j <- seq_len(max(0L, n - 1L))
	a <- eta - 1 + 0.5 * (j + 1)
	log.abs.det.jac <- -0.5 * (n + 2) * r
	log.res <- log.abs.det.jac + n * (n - 1) * (eta - 1 + (2 * n - 1)/6) * log(2) + (eta - 1) * -r + sum(2 * j * lgamma(a) - j * lgamma(2 * a))
	if (give.log) log.res else exp(log.res)
}

set.seed(0xfafafa)
n <- 4L
p <- (n * (n - 1L)) %/% 2L
x <- rnorm(p)
shape <- 1
stopifnot(all.equal(Cdlkj(x, shape, 1L), Rdlkj(x, shape, 1L)))

## Integrate over space of 2-by-2 correlation matrices
## parametrized bijectively by y = L[2, 1] = R[1, 2]
integrand <- function(y) vapply(y, Cdlkj, 0, shape = 1, give.log = 0L)
if (FALSE) # FIXME
stopifnot(all.equal(integrate(integrand, -Inf, Inf)[["value"]], 1))


Cdwishart <-
function(x, shape, scale, give.log = 0L)
	report("dwishart", x = x, shape = shape, scale = scale,
	       give_log = give.log)
Rdwishart <-
function(x, shape, scale, give.log = 0L) {
	n <- as.integer(0.5 * (-1 + sqrt(1 + 8 * length(x))))
	r <- sumLogDiagRTR(x[-seq_len(n)])
	nu <- exp(shape) + n - 1
	X <- makeSigma(x)
	S <- makeSigma(scale)
	log.abs.det.jac <- n * log(2) + 0.5 * (n + 1) * sum(log(diag(X))) - 0.5 * (n + 2) * r
	log.res <- log.abs.det.jac - 0.5 * (nu * log(det(S)) + (-nu + n + 1) * log(det(X)) + n * nu * log(2) + 2 * Rmvlgamma(0.5 * nu, n) + sum(diag(solve(S, X))))
	if (give.log) log.res else exp(log.res)
}
Cdinvwishart <-
function(x, shape, scale, give.log = 0L)
	report("dinvwishart", x = x, shape = shape, scale = scale,
	       give_log = give.log)
Rdinvwishart <-
function(x, shape, scale, give.log = FALSE) {
	n <- 0.5 * (-1 + sqrt(1 + 8 * length(x)))
	r <- sumLogDiagRTR(x[-seq_len(n)])
	nu <- exp(shape) + n - 1
	X <- makeSigma(x)
	S <- makeSigma(scale)
	log.abs.det.jac <- n * log(2) + 0.5 * (n + 1) * sum(log(diag(X))) - 0.5 * (n + 2) * r
	log.res <- log.abs.det.jac - 0.5 * (-nu * log(det(S)) + (nu + n + 1) * log(det(X)) + n * nu * log(2) + 2 * Rmvlgamma(0.5 * nu, n) + sum(diag(solve(X, S))))
	if (give.log) log.res else exp(log.res)
}

n <- 4L
p <- (n * (n + 1L)) %/% 2L
x <- rnorm(p)
shape <- 1
scale <- rnorm(p)

stopifnot(all.equal(Cdwishart   (x, shape, scale, TRUE),
                    Rdwishart   (x, shape, scale, TRUE)),
          all.equal(Cdinvwishart(x, shape, scale, TRUE),
                    Rdinvwishart(x, shape, scale, TRUE)))

## Integrate over space of 1-by-1 covariance matrices
## parametrized bijectively by y = log(sqrt(X[1, 1]))
for (Cd in list(Cdwishart, Cdinvwishart)) {
integrand <- function(y) vapply(y, Cd, 0, shape = 1, scale = 1, give.log = 0L)
stopifnot(all.equal(integrate(integrand, -Inf, Inf)[["value"]], 1))
}
