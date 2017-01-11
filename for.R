library(microbenchmark)

len <- cumprod(c(100, rep(2, 10)))
tm <- double(length(len))

for(j in seq_along(len)) {
  n <- len[j]
  res <- microbenchmark(for(i in seq_len(n)) {}, times=1000)
  tm[j] <- median(res$time)
}

print(tm)
plot(x=len, y=tm)
m <- lm(tm~len)
summary(m)
print(m)
