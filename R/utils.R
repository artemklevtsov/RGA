# Check if object is empty
is.empty <- function(x) {
    stopifnot(is.atomic(x))
    is.null(x) || is.na(x) || !length(x) || !nzchar(x)
}

# Reduce NULL and "" elements
compact <- function(x) {
    empty <- vapply(x, is.empty, logical(1))
    return(x[!empty])
}

# Remove whitespaces
strip_spaces <- function(x) {
    if (length(x) > 1L)
        x <- paste(x, collapse = ",")
    gsub("\\s", "", x)
}

# Remove whitespace around operators
strip_ops <- function(x) {
    # available operators
    ga_ops <- c("==", "!=", ">", "<", ">=", "<=", "<>", "\\[\\]", "=@", "!@", "=-", "!-", "\\|\\|", "&&", "OR", "AND")
    # build pattern for replace
    ops_pattern <- paste("(\\s)+(", paste(ga_ops, collapse = "|"), ")(\\s)+", sep = "")
    # remove whitespaces around operators
    x <- gsub(ops_pattern, "\\2", x)
    # replace logical operators
    x <- gsub("OR|\\|\\|", ",", x)
    x <- gsub("AND|&&", ";", x)
    return(x)
}

to_camel <- function(x, delim = "\\W", upper = FALSE) {
    stopifnot(is.character(x))
    if (length(x) > 1)
        return(vapply(x, to_camel, character(1)))
    splitted <- strsplit(x, delim)[[1]]
    first <- substring(splitted, 1, 1)
    if (isTRUE(upper))
        first <- toupper(first)
    else
        first[-1] <- toupper(first[-1])
    return(paste0(first, substring(splitted, 2), sep = "", collapse = ""))
}

to_period <- function(x) {
    x <- gsub("([a-z])([A-Z])", "\\1.\\2", x)
    return(tolower(x))
}

# Convert data types
convert_datatypes <- function(x) {
    stopifnot(is.list(x))
    x[] <- rapply(x, type.convert, classes = "character", how = "replace", as.is = TRUE)
    return(x)
}
