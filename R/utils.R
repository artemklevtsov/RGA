# Check if object is empty
is.empty <- function(x) {
    stopifnot(is.atomic(x))
    is.null(x) || !length(x) || !nzchar(x)
}

# Reduce NULL and "" elements
compact <- function(x) {
    empty <- vapply(x, is.empty, logical(1))
    return(x[!empty])
}

# Remove whitespace around operators
strip_ops <- function(x) {
    # available operators
    ga_ops <- c("==", "!=", ">", "<", ">=", "<=", "<>", "=@", "!@", "=-", "!-", "\\|\\|", "&&", "OR", "AND")
    # build pattern for replace
    ops_pattern <- paste("(\\s)+(", paste(ga_ops, collapse = "|"), ")(\\s)+", sep = "")
    # remove whitespaces around operators
    x <- gsub(ops_pattern, "\\2", x)
    # replace logical operators
    x <- gsub("OR|\\|\\|", ",", x)
    x <- gsub("AND|&&", ";", x)
    return(x)
}
