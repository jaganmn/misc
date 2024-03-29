dll <- "distributions"
cpp <- paste0(dll, ".cpp")
lib <- paste0(dll, .Platform[["dynlib.ext"]])

TMB::compile(cpp)
dyn.load(lib)


## ==== Utilities ======================================================

## Run the indicated test with the supplied data and return the result
get_test_res <- local({
	tt <- paste(readLines(cpp), collapse = "\n")
	tt <- sub("^.*?enum[ \t\n]+test[ \t\n]*\\{(.*?)\\};.*$", "\\1", tt)
	tt <- gsub("[ \t\n]", "", tt)
	test_enums <- strsplit(tt, ",")[[1L]]
	function(test_enum, ...) {
		data <- list(test_flag = match(test_enum, test_enums, 0L) - 1L, ...)
		obj <- TMB::MakeADFun(data = data,
		                      parameters = list(),
		                      type = "Fun",
		                      checkParameterOrder = FALSE,
		                      DLL = dll)
		obj[["report"]]()[["res"]]
	}
})

## Construct a covariance matrix Sigma from x = c(log_sd, theta)
make_Sigma <- function(x) {
	n <- 0.5 * (-1 + sqrt(1 + 8 * length(x)))
	R <- diag(n)
	R[upper.tri(R)] <- x[-seq_len(n)]
	Sigma <- t(R) %*% R
	diag_D <- exp(x[seq_len(n)] - 0.5 * log(diag(Sigma)))
	Sigma[] <- diag_D * Sigma * rep(diag_D, each = n)
	Sigma
}


## ==== Tests ==========================================================

mvlgamma <- function(x, p)
	0.25 * p * (p - 1) * log(pi) + rowSums(lgamma(outer(x, seq.int(0, by = 0.5, length.out = p), `-`)))

x <- 1:12
res1 <- get_test_res("mvlgamma", x = x, p = 1L)
stopifnot(all.equal(res1, mvlgamma(x, 1L)))
res2 <- get_test_res("mvlgamma", x = x, p = 4L)
stopifnot(all.equal(res2, mvlgamma(x, 4L)))

dlkj <- function(x, eta, give_log = FALSE) {
	n <- 0.5 * (1 + sqrt(1 + 8 * length(x)))
	R <- diag(n)
	R[upper.tri(R)] <- x
	log_res <- (eta - 1) * (-sum(log(colSums(R * R))))
	if (give_log) log_res else exp(log_res)
}
n <- 4L
x <- rnorm(0.5 * n * (n - 1L))
eta <- 2
res3 <- get_test_res("dlkj", x = x, eta = eta, give_log = 1L)
stopifnot(all.equal(res3, dlkj(x, eta, TRUE)))

dwishart <- function(x, df, scale, give_log = FALSE) {
	n <- 0.5 * (-1 + sqrt(1 + 8 * length(x)))
	X <- make_Sigma(x)
	S <- make_Sigma(scale)
	log_res <- -0.5 * (df * log(det(S)) + (-df + n + 1) * log(det(X)) + n * df * log(2) + 2 * mvlgamma(0.5 * df, n) + sum(diag(solve(S, X))))
	if (give_log) log_res else exp(log_res)
}
n <- 4L
x <- rnorm(0.5 * n * (n + 1L))
df <- 8
scale <- rnorm(length(x))
res4 <- get_test_res("dwishart", x = x, df = df, scale = scale, give_log = 1L)
stopifnot(all.equal(res4, dwishart(x, df, scale, TRUE)))

dinvwishart <- function(x, df, scale, give_log = FALSE) {
	n <- 0.5 * (-1 + sqrt(1 + 8 * length(x)))
	X <- make_Sigma(x)
	S <- make_Sigma(scale)
	log_res <- -0.5 * (-df * log(det(S)) + (df + n + 1) * log(det(X)) + n * df * log(2) + 2 * mvlgamma(0.5 * df, n) + sum(diag(solve(X, S))))
	if (give_log) log_res else exp(log_res)
}
n <- 4L
x <- rnorm(0.5 * n * (n + 1L))
df <- 8
scale <- rnorm(length(x))
res5 <- get_test_res("dinvwishart", x = x, df = df, scale = scale, give_log = 1L)
stopifnot(all.equal(res5, dinvwishart(x, df, scale, TRUE)))
