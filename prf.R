# This example demonstrates how to create a random forest model
# in parallel using the mclapply function from the parallel package.

library(microbenchmark)
library(parallel)
library(randomForest)

# Worker function called by mclapply
worker <- function(n) randomForest(x, y, ntree=n)

# Generate test data
x <- matrix(runif(500), 100)
y <- gl(2, 50)
ntree <- 1000
cores <- detectCores()
vntree <- rep(ntree %/% cores, cores)

# Run benchmarks
res <- microbenchmark(
  rf=randomForest(x, y, ntree=10000),
  prf=do.call('combine', mclapply(vntree, worker, mc.cores=cores))
)
print(res)
