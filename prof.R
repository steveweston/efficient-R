f <- function(a) {
  g1(a) + g2(2 * a)
}

g1 <- function(a) {
  h(a)
}

g2 <- function(a) {
  sqrt(a)
}

h <- function(a) {
  b <- double(length(a))
  for (i in seq_along(a)) {
    b[i] <- sqrt(a[i])
  }
  b
}

x <- 1:1000000
Rprof('prof.out')
for (i in 1:10) {
  y <- f(x)
}
Rprof(NULL)
print(summaryRprof("prof.out"))

# system("R CMD Rprof prof.out")
