# This example demonstrates the classic mistake of repeatedly
# appending values rather than preallocating a result matrix.

# Classic bad for loop
bad <- function(n) {
  m <- NULL
  for (i in 1:n) {
    m <- rbind(m, rnorm(100))
  }
  m
}

# Standard preallocation of result vector
prealloc <- function(n) {
  m <- matrix(0, nrow=n, ncol=100)
  for (i in 1:n) {
    m[i,] <- rnorm(100)
  }
  m
}

# Use lapply and rbind (don't need to preallocate matrix)
lapplyrbind <- function(n) {
  do.call('rbind', lapply(1:n, function(i) rnorm(100)))
}

# Compute all rows at once
best <- function(n) {
  m <- rnorm(100 * n)
  dim(m) <- c(100, n)
  t(m)
}

# Generate test data
n <- 500

# Verify correct results
set.seed(100); a1 <- bad(n)
set.seed(100); a2 <- prealloc(n)
set.seed(100); a3 <- lapplyrbind(n)
set.seed(100); a4 <- best(n)
identical(a1, a2)
identical(a1, a3)
identical(a1, a4)

# Run benchmarks
library(microbenchmark)

for (n in c(200, 400, 600)) {
  res <- microbenchmark(
    bad=bad(n),
    prealloc=prealloc(n),
    lapplyrbind=lapplyrbind(n),
    best=best(n)
  )
  print(res)
}
