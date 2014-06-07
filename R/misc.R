compact <- function(x) {
    Filter(Negate(is.null), x)
}

# available operators
ga_ops <- c("==", "!=", ">", "<", ">=", "<=", "<>", "=@", "!@", "=-", "!-", "\\|\\|", "&&", "OR", "AND")
