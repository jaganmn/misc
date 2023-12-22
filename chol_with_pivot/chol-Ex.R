## Bug 15853: https://bugs.r-project.org/show_bug.cgi?id=15853

set.seed(0)
m <- 20L
n <- 6L
X <- matrix(runif(m * n), m, n)
X[, 5L] <- X[, 4L]
X[, 1L] <- X[, 3L] + X[, 4L]


## Example 1: near-positive semidefinite with small negative minimum eigenvalue

(A1 <- crossprod(X))
e1 <- eigen(A1, symmetric = TRUE)
(l1 <- min(e1[["values"]]))
stopifnot(l1 < 0) # true for MJ, but perhaps not guaranteed ...

(R1 <- chol(A1, pivot = TRUE))
p1 <- attr(R1, "pivot")
r1 <- attr(R1, "rank")
stopifnot(r1 < n)

## The last computed pivot
R1[r1 + 1L, r1 + 1L]
## How it was computed by dpstrf
A1[p1, p1][r1 + 1L, r1 + 1L] - sum(crossprod(R1[1L:r1, r1 + 1L]))

## Zero the trailing submatrix
R1. <- R1
R1.[(r1 + 1L):n, (r1 + 1L):n] <- 0

## Relative backwards errors
norm(A1[p1, p1] - crossprod(R1 )) / norm(A1)
norm(A1[p1, p1] - crossprod(R1.)) / norm(A1)


## Example 2: near-positive semidefinite with small positive minimum eigenvalue

(A2 <- tcrossprod(e1[["vectors"]] * rep(sqrt(pmax(e1[["values"]], 4e-15)), each = n)))
e2 <- eigen(A2, symmetric = TRUE)
(l2 <- min(e2[["values"]]))
stopifnot(l2 > 0)

(R2 <- chol(A2, pivot = TRUE))
p2 <- attr(R2, "pivot")
r2 <- attr(R2, "rank")
stopifnot(r2 < n)

## The last computed pivot
R2[r2 + 1L, r2 + 1L]
## How it was computed by dpstrf
A2[p2, p2][r2 + 1L, r2 + 1L] - sum(crossprod(R2[1L:r2, r2 + 1L]))

## Zero the trailing submatrix
R2. <- R2
R2.[(r2 + 1L):n, (r2 + 1L):n] <- 0

## Relative backwards errors
norm(A2[p2, p2] - crossprod(R2 )) / norm(A2)
norm(A2[p2, p2] - crossprod(R2.)) / norm(A2)
