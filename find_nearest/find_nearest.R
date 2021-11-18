`[.dist` <- function(x, i, j, drop = TRUE) {
  class(x) <- NULL
  p <- length(x)
  n <- as.integer(round(0.5 * (1 + sqrt(1 + 8 * p)))) # p = n * (n - 1) / 2

  ## Column extraction
  if (missing(i) && !missing(j) && is.integer(j) && length(j) == 1L && !is.na(j) && j >= 1L && j <= n) {
    if (j == 1L) {
      return(c(0, x[seq_len(n - 1L)]))
    }
    ## Convert 2-ary index of 'D' to 1-ary index of 'D[lower.tri(D)]'
    ii <- rep.int(j - 1L, j - 1L)
    jj <- 1L:(j - 1L)
    if (j < n) {
      ii <- c(ii, j:(n - 1L))
      jj <- c(jj, rep.int(j, n - j))
    }
    kk <- ii + round(0.5 * (2L * (n - 1L) - jj) * (jj - 1L))
    ## Extract
    res <- double(n)
    res[-j] <- x[kk]
    nms <- attr(x, "Labels")
    if (drop) {
      names(res) <- nms
    } else {
      dim(res) <- c(n, 1L)
      dimnames(res) <- list(nms, nms[j])
    }
    return(res)
  }

  ## Element extraction with matrix indices
  if (missing(j) && !missing(i) && is.matrix(i) && dim(i)[2L] == 2L && is.integer(i) && !anyNA(i) && all(i >= 1L & i <= n)) {
    m <- dim(i)[1L]
    ## Subset off-diagonal entries
    d <- i[, 1L] == i[, 2L]
    i <- i[!d, , drop = FALSE]
    ## Transpose upper triangular entries
    u <- i[, 2L] > i[, 1L]
    i[u, 1:2] <- i[u, 2:1]
    ## Convert 2-ary index of 'D' to 1-ary index of 'D[lower.tri(D)]'
    ii <- i[, 1L] - 1L
    jj <- i[, 2L]
    kk <- ii + (jj > 1L) * round(0.5 * (2L * (n - 1L) - jj) * (jj - 1L))
    ## Extract
    res <- double(m)
    res[!d] <- x[kk]
    return(res)
  }

  ## Fall back on coercion for any other subset operation
  as.matrix(x)[i, j, drop = drop]
}

find_nearest <- function(data, dist, coordvar, idvar) {
  m <- match(coordvar, names(data), 0L)
  n <- nrow(data)
  if (n < 2L) {
    argmin <- NA_integer_[n]
    distance <- NA_real_[n]
  } else {
    ## Compute distance matrix
    D <- dist(data[m])
    ## Extract minimum off-diagonal distances
    patch.which.min <- function(x, i) {
      x[i] <- Inf
      which.min(x)
    }
    argmin <- integer(n)
    index <- seq_len(n)
    for (j in index) {
      argmin[j] <- forceAndCall(2L, patch.which.min, D[, j], j)
    }
    distance <- D[cbind(argmin, index)]
  }
  ## Return focal point data, nearest neighbour ID, distance
  r1 <- data[-m]
  r2 <- data[argmin, idvar, drop = FALSE]
  names(r2) <- paste0(idvar, "_nearest")
  data.frame(r1, r2, distance, row.names = NULL, stringsAsFactors = FALSE)
}
