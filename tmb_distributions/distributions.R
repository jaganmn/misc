dll <- "distributions"
cpp <- paste0(dll, ".cpp")
lib <- paste0(dll, .Platform[["dynlib.ext"]])

TMB::compile(cpp)
dyn.load(lib)


## ==== Utilities ======================================================

## Run the indicated test with the supplied data and return the result
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
makeSigma <- function(x) {
	n <- as.integer(0.5 * (-1 + sqrt(1 + 8 * length(x))))
	R <- diag(n)
	R[upper.tri(R)] <- x[-seq_len(n)]
	RTR <- crossprod(R)
	r <- exp(x[seq_len(n)] - 0.5 * log(diag(RTR)))
	r * RTR * rep(r, each = n)
}

## Compute sum(log(diag(crossprod(R)))) from x = theta
sumLogDiagRTR <- function(x) {
	n <- as.integer(0.5 * (1 + sqrt(1 + 8 * length(x))))
	R <- diag(n)
	R[upper.tri(R)] <- x
	sum(log(colSums(R * R)))
}

## ==== Tests ==========================================================

mvlgamma <- function(x, n)
	0.25 * n * (n - 1) * log(pi) + rowSums(lgamma(outer(x, seq.int(from = 0, by = 0.5, length.out = n), `-`)))

x <- 1:12
res1 <- report("mvlgamma", x = x, n = 1L)
stopifnot(all.equal(res1, mvlgamma(x, 1L)))
res2 <- report("mvlgamma", x = x, n = 4L)
stopifnot(all.equal(res2, mvlgamma(x, 4L)))

dlkj <- function(x, shape, give.log = FALSE) {
	n <- as.integer(0.5 * (1 + sqrt(1 + 8 * length(x))))
	r <- sumLogDiagRTR(x)
	eta <- exp(shape)
	j <- seq_len(max(0L, n - 1L))
	a <- eta - 1 + 0.5 * (j + 1)
	log.abs.det.jac <- -0.5 * (n + 2) * r
	log.res <- log.abs.det.jac + n * (n - 1) * (eta - 1 + (2 * n - 1)/6) * log(2) + (eta - 1) * -r + sum(2 * j * lgamma(a) - j * lgamma(2 * a))
	if (give.log) log.res else exp(log.res)
}

n <- 4L
x <- rnorm(0.5 * n * (n - 1L))
shape <- log(2)
res3 <- report("dlkj", x = x, shape = shape, give_log = 1L)
stopifnot(all.equal(res3, dlkj(x, shape, TRUE)))

dwishart <- function(x, shape, scale, give.log = FALSE) {
	n <- as.integer(0.5 * (-1 + sqrt(1 + 8 * length(x))))
	r <- sumLogDiagRTR(x[-seq_len(n)])
	nu <- exp(shape) + n - 1
	X <- makeSigma(x)
	S <- makeSigma(scale)
	log.abs.det.jac <- n * log(2) + 0.5 * (n + 1) * sum(log(diag(X))) - 0.5 * (n + 2) * r
	log.res <- log.abs.det.jac - 0.5 * (nu * log(det(S)) + (-nu + n + 1) * log(det(X)) + n * nu * log(2) + 2 * mvlgamma(0.5 * nu, n) + sum(diag(solve(S, X))))
	if (give.log) log.res else exp(log.res)
}

n <- 4L
x <- rnorm(0.5 * n * (n + 1L))
shape <- log(5)
scale <- rnorm(length(x))
res4 <- report("dwishart", x = x, shape = shape, scale = scale, give_log = 1L)
stopifnot(all.equal(res4, dwishart(x, shape, scale, TRUE)))

dinvwishart <- function(x, df, scale, give.log = FALSE) {
	n <- 0.5 * (-1 + sqrt(1 + 8 * length(x)))
	r <- sumLogDiagRTR(x[-seq_len(n)])
	nu <- exp(shape) + n - 1
	X <- makeSigma(x)
	S <- makeSigma(scale)
	log.abs.det.jac <- n * log(2) + 0.5 * (n + 1) * sum(log(diag(X))) - 0.5 * (n + 2) * r
	log.res <- log.abs.det.jac - 0.5 * (-nu * log(det(S)) + (nu + n + 1) * log(det(X)) + n * nu * log(2) + 2 * mvlgamma(0.5 * nu, n) + sum(diag(solve(X, S))))
	if (give.log) log.res else exp(log.res)
}

n <- 4L
x <- rnorm(0.5 * n * (n + 1L))
shape <- log(5)
scale <- rnorm(length(x))
res5 <- report("dinvwishart", x = x, shape = shape, scale = scale, give_log = 1L)
stopifnot(all.equal(res5, dinvwishart(x, shape, scale, TRUE)))
