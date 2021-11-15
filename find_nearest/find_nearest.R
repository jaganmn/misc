library("Matrix")
setAs(from = "dist", to = "dspMatrix", function(from) {
  p <- length(from)
  if (p > 0L) {
    n <- as.integer(round(0.5 * (1 + sqrt(1 + 8 * p)))) # choose(n, 2) = p
    x <- double(p + n)
    i <- 1L + c(0L, cumsum(n:2L))
    x[-i] <- from
  } else {
    n <- 1L
    x <- 0
  }
  new("dspMatrix", uplo = "L", x = x, Dim = c(n, n))
})

applySymmetric <- function (X, FUN, ..., simplify = TRUE, check = FALSE) {
  if (isTRUE(check)) {
    stopifnot(isSymmetric(X))
  }
  FUN <- match.fun(FUN)
  simplify <- isTRUE(simplify)
  n <- dim(X)[1L]
  res <- vector("list", n)
  for (i in seq_len(n)) {
    res[[i]] <- forceAndCall(1L, FUN, X[, i], ...)
  }
  if (simplify && all(lengths(res) == 1L)) {
    res <- unlist(res, recursive = FALSE, use.names = FALSE)
  }
  names(res) <- dimnames(X)[[1L]]
  res
}

find_nearest <- function(data, dist, coordvar, idvar) {
  n <- nrow(data)
  if (n < 2L) {
    argmin <- NA_integer_[n]
    distance <- NA_real_[n]
  } else {
    ## Compute distance matrix
    m <- match(coordvar, names(data), 0L)
    D <- dist(as.matrix(data[m]))
    if (inherits(D, "dist")) {
      if (!requireNamespace("Matrix")) {
        stop("Install package 'Matrix' and try again.")
      }
      D <- as(D, "dspMatrix")
    }
    ## Extract minimum distances
    diag(D) <- Inf # want off-diagonal distances
    argmin <- applySymmetric(D, which.min)
    distance <- D[cbind(argmin, seq_len(n))]
  }
  ## Return focal point data, nearest neighbour ID, distance
  res <- data[argmin, idvar, drop = FALSE]
  names(res) <- paste0(idvar, "_nearest")
  data.frame(data, res, distance, row.names = NULL, stringsAsFactors = FALSE)
}
