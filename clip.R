# This example demonstrates the need to be very careful when modifying
# values in a matrix. In this case, the "named" bit of the matrix
# gets set to 2 by calling "nrow(a)". This can cause the matrix to be
# duplicated up to once per column in "a", resulting in very poor
# performance for large matrices.
#
# Note that "nrow" is a normal R function, while "dim" is a primitive
# function, so calling "nrow(a)" sets the "named" bit in "a",
# while calling "dim(a)" does not.
#
# See section 1.1.2 of the "R Internals" manual for more information
# on the "named" bit.
#
# For information on Luke Tierney's work to replace the NAMED mechanism
# with reference counting, see:
#   https://developer.r-project.org/Refcnt.html

# This can trigger up to one duplication of "a" per column
clip.1 <- function(a, x) {
  for (j in 1:ncol(a)) {
    for (i in 1:nrow(a)) {
      if (a[i,j] > x) {
        a[i,j] <- x
      }
    }
  }
  a
}

# This only triggers one duplication of "a"
clip.2 <- function(a, x) {
  for (j in 1:ncol(a)) {
    for (i in 1:dim(a)[1]) {
      if (a[i,j] > x) {
        a[i,j] <- x
      }
    }
  }
  a
}

# Generate test data
n <- 2000
a <- matrix(rnorm(n * n, mean=0, sd=100), n, n)

# Run larger benchmarks using system.time
print(system.time(clip.1(a, 50)))
print(system.time(clip.2(a, 50)))

####
n <- 10
a <- matrix(rnorm(n * n, mean=0, sd=100), n, n)
tracemem(a)
b <- clip.1(a, 50)
