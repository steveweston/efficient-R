# This script demonstrates the use of tracemem to monitor object
# duplication.
#
# Note that it doesn't seem to work as my comments say when using RStudio.
# I'd like to find out when exactly this happens and why.

x <- double(10)
tracemem(x)
.Internal(inspect(x))  # x has NAM(1)

y <- x
.Internal(inspect(x))  # x now has NAM(2)
.Internal(inspect(y))  # y is same as x

y[1] <- 10             # generates trace message
.Internal(inspect(x))  # x still has NAM(2)
.Internal(inspect(y))  # y is new object with NAM(1)

x[1] <- 50             # generates trace message
.Internal(inspect(x))  # x is new object with NAM(1)
                       # previous x will be gc'd
.Internal(inspect(y))  # y is unchanged

z <- y
.Internal(inspect(y))  # y now has NAM(2)
.Internal(inspect(z))  # z is same as y

z[1] <- 100            # generates trace message
.Internal(inspect(y))  # y still has NAM(2)
.Internal(inspect(z))  # z is new object with NAM(1)

####

x <- double(10)
.Internal(inspect(x))  # x has NAM(1)

# Passing "x" to a primitive function doesn't set NAMED bit
y <- sum(x)
.Internal(inspect(x))  # x has NAM(1)

# Passing "x" to an anonymous function doesn't set NAMED bit
y <- function(x) { s <- 0; for (e in x) s <- s + e; s }(x)
.Internal(inspect(x))  # x has NAM(1)

# Passing "x" to a named function does set NAMED bit
fun <- function(x) { s <- 0; for (e in x) s <- s + e; s }
y <- fun(x)
.Internal(inspect(x))  # x has NAM(2)

is.primitive(sum)

####

x <- double(0)
tracemem(x)
.Internal(inspect(x))  # x has NAM(1)

x[1] <- 1              # no trace message
.Internal(inspect(x))  # x is new object, len=1, NAM(1), no TR bit
                       # previous x will be gc'd

x[2] <- 2              # no trace message
.Internal(inspect(x))  # x is new object, len=2, NAM(1), no TR bit
                       # previous x will be gc'd

# etc, etc, ...
