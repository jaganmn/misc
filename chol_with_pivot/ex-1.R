m <- 20L
n <- 6L
X <- matrix(runif(m * n), m, n)
X[, 5L] <- X[, 4L]
X[, 1L] <- X[, 3L] + X[, 4L]

(A1 <- crossprod(X))
e1 <- eigen(A1, symmetric = TRUE)
min(e1[["values"]])
(R1 <- chol(A1, pivot = TRUE))
p1 <- attr(R1, "pivot")
r1 <- attr(R1, "rank")

R1[r1 + 1L, r1 + 1L]
A1[p1, p1][r1 + 1L, r1 + 1L] - sum(crossprod(R1[1L:r1, r1 + 1L]))

R1. <- R1
R1.[(r1 + 1L):n, (r1 + 1L):n] <- 0

norm(A1[p1, p1] - crossprod(R1 )) / norm(A1)
norm(A1[p1, p1] - crossprod(R1.)) / norm(A1)

(A2 <- tcrossprod(e1[["vectors"]] * rep(sqrt(pmax(e1[["values"]], 4e-15)), each = n)))
e2 <- eigen(A2, symmetric = TRUE)
min(e2[["values"]])
(R2 <- chol(A2, pivot = TRUE))
p2 <- attr(R2, "pivot")
r2 <- attr(R2, "rank")

R2[r2 + 1L, r2 + 1L]
A2[p2, p2][r2 + 1L, r2 + 1L] - sum(crossprod(R2[1L:r2, r2 + 1L]))

R2. <- R2
R2.[(r2 + 1L):n, (r2 + 1L):n] <- 0

norm(A2[p2, p2] - crossprod(R2 )) / norm(A2)
norm(A2[p2, p2] - crossprod(R2.)) / norm(A2)
