# This examples demonstrates the benefit of vector functions
# on matrices. Vector functions used include:
#   - max
#   - which
#   - which.max
#   - arrayInd

mmax.for <- function(m) {
  mx <- m[1,1]
  imx <- c(1,1)
  jvec <- 1:ncol(m)
  ivec <- 1:nrow(m)
  for (j in jvec) {
    for (i in ivec) {
      # This assumes "m" contains no NA's
      if (m[i,j] > mx) {
        mx <- m[i,j]
        imx <- c(i,j)
      }
    }
  }
  matrix(imx, 1, 2)
}

mmax.for.max <- function(m) {
  mx <- max(m, na.rm=TRUE)
  jvec <- 1:ncol(m)
  ivec <- 1:nrow(m)
  for (j in jvec) {
    for (i in ivec) {
      if (m[i,j] == mx)
        return(matrix(c(i, j), 1, 2))
    }
  }
}

library(compiler)
mmax.for.compiled <- cmpfun(mmax.for)
mmax.for.max.compiled <- cmpfun(mmax.for.max)

mmax.which <- function(m) {
  which(m == max(m, na.rm=TRUE), arr.ind=TRUE)[1,,drop=FALSE]
}

mmax.which.max <- function(m) {
  arrayInd(which.max(m), dim(m))
}

nr <- 1000
nc <- 1000
m <- matrix(rnorm(nr * nc), nr, nc)
m[1,1] <- 100

y1 <- mmax.for(m)
y2 <- mmax.for.compiled(m)
y3 <- mmax.for.max(m)
y4 <- mmax.for.max.compiled(m)
y5 <- mmax.which(m)
y6 <- mmax.which.max(m)

print(y1)
y1 == y2
y1 == y3
y1 == y3
y1 == y4
y1 == y5
y1 == y6

library(microbenchmark)
res <- microbenchmark(
  mmax.for=mmax.for(m),
  mmax.for.compiled=mmax.for.compiled(m),
  mmax.for.max=mmax.for.max(m),
  mmax.for.max.compiled=mmax.for.max.compiled(m),
  mmax.which=mmax.which(m),
  mmax.which.max=mmax.which.max(m)
)
print(res)

####

m[1,1] <- -100
m[nr,nc] <- 100

res <- microbenchmark(
  mmax.for=mmax.for(m),
  mmax.for.compiled=mmax.for.compiled(m),
  mmax.for.max=mmax.for.max(m),
  mmax.for.max.compiled=mmax.for.max.compiled(m),
  mmax.which=mmax.which(m),
  mmax.which.max=mmax.which.max(m)
)
print(res)
