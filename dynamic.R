# create length 10 list
x <- vector('list', 10)

# extend x by assignment
x[[20]] <- 100
length(x)

# resize/truncate x
length(x) <- 5
x

# recyling example
x[1:5] <- 100
x

# remove elements
x[2:4] <- NULL
x
