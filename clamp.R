# This example demonstrates several ways to modify the values
# of a matrix. The approaches include:
#   - for loop
#   - vector function (ifelse)
#   - matrix indexing

# C-style for loop
clamp.for <- function(a, x, y) {
  jvec <- seq_len(ncol(a))
  ivec <- seq_len(nrow(a))
  for (j in jvec) {
    for (i in ivec) {
      if (a[i,j] < x) {
        a[i,j] <- x
      } else if (a[i,j] > y) {
        a[i,j] <- y
      }
    }
  }
  a
}

# Compiled C-style for loop
library(compiler)
clamp.for.compiled <- cmpfun(clamp.for)

# Use "ifelse" function
clamp.ifelse <- function(a, x, y) {
  ifelse(a < x, x, ifelse(a > y, y, a))
}

# Use matrix indexing/assignment
clamp.idx <- function(a, x, y) {
  a[a < x] <- x
  a[a > y] <- y
  a
}

# Generate test data
nr <- 100
nc <- 100
a <- matrix(rnorm(nr * nc, mean=0, sd=100), nr, nc)

# Verify correct results
lo <- -50
up <- 50
b1 <- clamp.for(a, lo, up)
b2 <- clamp.for.compiled(a, lo, up)
b3 <- clamp.ifelse(a, lo, up)
b4 <- clamp.idx(a, lo, up)
identical(b1, b2)
identical(b1, b3)
identical(b1, b4)
rm(b1, b2, b3, b4)

# Run benchmarks
library(microbenchmark)
res <- microbenchmark(
  clamp.for=clamp.for(a, lo, up),
  clamp.for.compiled=clamp.for.compiled(a, lo, up),
  clamp.ifelse=clamp.ifelse(a, lo, up),
  clamp.idx=clamp.idx(a, lo, up)
)
print(res)

rm(a)

###########

# Generate larger test data
nr <- 10000
nc <- 10000
a <- matrix(rnorm(nr * nc, mean=0, sd=100), nr, nc)
print(object.size(a), units="GB")

# Run larger benchmarks using system.time
lo <- -50
up <- 50
print(system.time(clamp.for.compiled(a, lo, up)))
print(system.time(clamp.ifelse(a, lo, up)))
print(system.time(clamp.idx(a, lo, up)))
