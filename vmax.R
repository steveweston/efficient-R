# This example demonstrates the benefit of vector functions.
# Vector functions used include:
#   - ifelse
#   - pmax

# Call "max" in a for loop
vmax.for <- function(x, y) {
  z <- double(length(x))
  for (i in seq_along(x)) {
    z[i] <- max(x[i], y[i])
  }
  z
}

library(compiler)
vmax.for.compiled <- cmpfun(vmax.for)

# Use "ifelse" function
vmax.ifelse <- function(x, y) {
  ifelse(x >= y, x, y)
}

# Replace elements of "x" that are less than "y"
vmax.compare <- function(x, y) {
  # assume no NA's
  test <- y > x
  z <- x
  z[test] <- y[test]
  z
}

# Replace elements of "x" that are less than "y"
vmax.compare.2 <- function(x, y) {
  # assume no NA's
  test <- y > x
  if (sum(test) < length(x) / 2) {
    z <- x
    z[test] <- y[test]
  } else {
    z <- y
    test <- !test
    z[test] <- x[test]
  }
  z
}

vmax.compare.2.compiled <- cmpfun(vmax.compare.2)

# Use "pmax" function
vmax.pmax <- function(x, y) {
  pmax(x, y)
}

# Generate test data
n <- 100000
x <- rnorm(n)
y <- rnorm(n)

# Verify correct results
z1 <- vmax.for(x, y)
z2 <- vmax.for.compiled(x, y)
z3 <- vmax.ifelse(x, y)
z4 <- vmax.compare(x, y)
z5 <- vmax.compare.2(x, y)
z6 <- vmax.compare.2.compiled(x, y)
z7 <- vmax.pmax(x, y)
identical(z1, z2)
identical(z1, z3)
identical(z1, z4)
identical(z1, z5)
identical(z1, z6)
identical(z1, z7)

# Run benchmarks
library(microbenchmark)
res <- microbenchmark(
  vmax.for=vmax.for(x, y),
  vmax.for.compiled=vmax.for.compiled(x, y),
  vmax.ifelse=vmax.ifelse(x, y),
  vmax.compare=vmax.compare(x, y),
  vmax.compare.2=vmax.compare.2(x, y),
  vmax.compare.2.compiled=vmax.compare.2.compiled(x, y),
  vmax.pmax=vmax.pmax(x, y)
)
print(res)
