# This example demonstrates the benefit of using a two column
# matrix of indices to extract and modify arbitrary elements
# of matrices.

library(compiler)

idx.1 <- function(a, b, ivec, jvec) {
  for (k in 1:length(ivec)) {
    b[ivec[k], jvec[k]] <- a[ivec[k], jvec[k]]
  }
  b
}

idx.1.compiled <- cmpfun(idx.1)

idx.2 <- function(a, b, ivec, jvec) {
  idx <- cbind(ivec, jvec)
  b[idx] <- a[idx]
  b
}

# Generate test data
nr <- 400
nc <- 400
a <- matrix(rnorm(nr * nc), nr, nc)
b <- matrix(0, nr, nc)
n <- 40000
ivec <- sample(nrow(a), n, replace=TRUE)
jvec <- sample(ncol(a), n, replace=TRUE)

# Verify correct results
b1 <- idx.1(a, b, ivec, jvec)
b2 <- idx.2(a, b, ivec, jvec)
identical(b1, b2)

# Run benchmarks
library(microbenchmark)
res <- microbenchmark(
  idx.1=idx.1(a, b, ivec, jvec),
  idx.1.compiled=idx.1.compiled(a, b, ivec, jvec),
  idx.2=idx.2(a, b, ivec, jvec)
)
print(res)
