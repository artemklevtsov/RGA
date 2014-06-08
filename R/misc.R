compact <- function(x) {
    x <- x[!sapply(x, is.null)]
    x <- x[sapply(x, nzchar)]
    return(x)
}

# available operators
ga_ops <- c("==", "!=", ">", "<", ">=", "<=", "<>", "=@", "!@", "=-", "!-", "\\|\\|", "&&", "OR", "AND")
