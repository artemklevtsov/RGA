# Check if object is empty
is.empty <- function(x) {
    stopifnot(is.atomic(x))
    is.null(x) || is.na(x) || !length(x) || !nzchar(x)
}

# Reduce empty elements
compact <- function(x) {
    empty <- vapply(x, is.empty, logical(1))
    x[!empty]
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

#' @title Convert character vector to camelCase
#'
#' @param a character vector to be converted.
#' @param delim a string containing regular expression word delimiter (defaults to non-words - "\W").
#' @param capitalize a logical value indicating if the first letter of the first word should be capitalised (defaults to FALSE).
#'
#' @keywords internal
#'
#' @noRd
#'
to_camel <- function(x, delim = "\\W", capitalize = FALSE) {
    stopifnot(is.character(x))
    if (length(x) > 1)
        return(vapply(x, to_camel, character(1)))
    splitted <- strsplit(x, delim)[[1]]
    first <- substring(splitted, 1, 1)
    if (isTRUE(capitalize))
        first <- toupper(first)
    else
        first[-1] <- toupper(first[-1])
    paste0(first, substring(splitted, 2), sep = "", collapse = "")
}

# Capitalize strings
capitalize <- function(x) {
    stopifnot(is.character(x))
    paste0(toupper(substring(x, 1, 1)), substring(x, 2))
}

#' @title Convert camelCase character vectove to separated
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
    chars <- vapply(x, is.character, logical(1))
    x[chars] <- lapply(x[chars], type.convert, as.is = TRUE)
    lists <- vapply(x, is.list, logical(1))
    x[lists] <- lapply(x[lists], convert_datatypes)
    names(x) <- to_separated(names(x), sep = ".")
    return(x)
}

parse_params <- function(x) {
    to_separated(gsub("^[a-z]+:", "", unlist(strsplit(x, ",|;"))), sep = ".")
}
