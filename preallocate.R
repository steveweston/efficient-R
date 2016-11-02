# This example demonstrates the classic mistake of repeatedly
# appending values rather than preallocating a result vector.
#
# Note that tracemem events are not triggered in this case
# even though the result vector is copied.

# Classic bad for loop
bad <- function(n, x) {
  result <- NULL
  for (i in 1:n) {
    result[i] <- x
  }
  result
}

# Demonstrates strange way to improve performance
strange <- function(n, x) {
  result <- NULL
  for (i in n:1) {
    result[i] <- x
  }
  result
}

# Standard preallocation of result vector
okay <- function(n, x) {
  result <- double(n)
  for (i in 1:n) {
    result[i] <- x
  }
  result
}

# use of vector assignment
better <- function(n, x) {
  result <- double(n)
  result[] <- x
  result
}

# use of standard R function
best <- function(n, x) {
  rep(x, n)
}

# Generate test data
n <- 1000

# Verify correct results
a1 <- bad(n, 7)
a1.2 <- strange(n, 7)
a2 <- okay(n, 7)
a3 <- better(n, 7)
a4 <- best(n, 7)
identical(a1, a1.2)
identical(a1, a2)
identical(a1, a3)
identical(a1, a4)

# Run benchmarks
library(microbenchmark)
res <- microbenchmark(
  bad=bad(n, 7),
  strange=strange(n, 7),
  okay=okay(n, 7),
  better=better(n, 7),
  best=best(n, 7)
)
print(res)
