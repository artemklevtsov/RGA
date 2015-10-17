# Check if object is empty
is.empty <- function(x) {
    stopifnot(is.atomic(x))
    is.null(x) || is.na(x) || !length(x) || !nzchar(x)
}

# Reduce empty elements
compact <- function(x) {
    x[!vapply(x, is.empty, logical(1L))]
}

# Remove whitespaces
strip_spaces <- function(x) {
    gsub("\\s", "", paste(x, collapse = ","))
}

# Remove whitespace around operators
strip_ops <- function(x) {
    # available operators
    ops <- c("==", "!=", ">", "<", ">=", "<=", "<>", "\\[\\]", "=@", "!@", "=-", "!-", "\\|\\|", "&&", "OR", "AND")
    # build pattern for replace
    pattern <- sprintf("(\\s)+(%s)(\\s)+", paste(ops, collapse = "|"))
    # remove whitespaces around operators
    x <- gsub(pattern, "\\2", x)
    # replace logical operators
    x <- gsub("OR|\\|\\|", ",", x)
    x <- gsub("AND|&&", ";", x)
    return(x)
}

# Capitalize strings
capitalize <- function(x) {
    stopifnot(is.character(x))
    paste0(toupper(substring(x, 1, 1)), substring(x, 2))
}

#' @title Convert camelCase character vector to separated
#'
#' @param x a character vector to be converted.
#' @param sep a character string to separate the terms.
#'
#' @keywords internal
#'
#' @noRd
#'
to_separated <- function(x, sep = ".") {
    x <- gsub("PropertyId", "propertyId", x, fixed = TRUE)
    x <- gsub("-", ".", x, fixed = TRUE)
    x <- gsub("ids", "profile.id", x, fixed = TRUE)
    gsub("([[:lower:]])([[:upper:]])", paste0("\\1", sep, "\\L\\2"), x, perl = TRUE)
}

# Convert data types
convert_datatypes <- function(x) {
    stopifnot(is.list(x))
    chars <- vapply(x, is.character, logical(1L))
    x[chars] <- lapply(x[chars], type.convert, as.is = TRUE)
    lists <- vapply(x, is.list, logical(1L))
    x[lists] <- lapply(x[lists], convert_datatypes)
    names(x) <- to_separated(names(x), sep = ".")
    return(x)
}

parse_params <- function(x) {
    to_separated(gsub("^[a-z]+:", "", unlist(strsplit(x, ",|;"))), sep = ".")
}
