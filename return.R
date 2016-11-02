# This example demonstrates the use of the microbenchmark package
# on very small functions. It demonstrates:
#   - basic use of the microbenchmark package
#   - microbenchmark package can measure very short operations effectively
#   - minor performance differences between functions that use
#     a "return" and those that don't
#   - minor performance differences can become significant
#     in unusual circumstances

library(ggplot2)
library(compiler)

# Return a value using "return"
use.return <- function() {
  return(77)
}

use.return.compiled <- cmpfun(use.return)

# Return a value without using "return"
no.return <- function(x) {
  77
}

no.return.compiled <- cmpfun(no.return)

# Verify correct results
a1 <- use.return()
a2 <- no.return()
identical(a1, a2)

# Run benchmarks
library(microbenchmark)
res <- microbenchmark(
  use.return=use.return(),
  use.return.compiled=use.return.compiled(),
  no.return=no.return(),
  no.return.compiled=no.return.compiled(),
  times=1000L
)
print(res)

png('return.png')
autoplot(res)
dev.off()

####

many.use.return <- function(n=1000000) {
  for (i in 1:n) {
    use.return()
  }
}

many.use.return.compiled <- cmpfun(function(n=1000000) {
  for (i in 1:n) {
    use.return.compiled()
  }
})

many.no.return <- function(n=1000000) {
  for (i in 1:n) {
    no.return()
  }
}

many.no.return.compiled <- cmpfun(function(n=1000000) {
  for (i in 1:n) {
    no.return.compiled()
  }
})

print(system.time(many.use.return(100000000)))
print(system.time(many.use.return.compiled(100000000)))
print(system.time(many.no.return(100000000)))
print(system.time(many.no.return.compiled(100000000)))
