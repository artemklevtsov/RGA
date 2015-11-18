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
    gsub("(^|[[:space:]])([[:alpha:]])", "\\1\\U\\2", x, perl = TRUE)
}

#' @title Convert camelCase character vector to separated
#'
#' @param x a character vector to be converted.
#' @param sep a character string to separate the terms.
#'
#' @keywords internal
#' @noRd
to_separated <- function(x, sep = ".") {
    x <- gsub("(.)([[:upper:]][[:lower:]]+)", paste0("\\1", sep, "\\2"), x)
    x <- gsub("([[:lower:][:digit:]])([[:upper:]])", paste0("\\1", sep, "\\2"), x)
    x <- gsub(paste0("\\", sep, "+"), sep, x)
    tolower(x)
}

rename_params <- function(x) {
    x <- gsub("PropertyId", "propertyId", x, fixed = TRUE)
    x <- gsub("ids", "profile.id", x, fixed = TRUE)
    x <- gsub("start-date", "start.date", x, fixed = TRUE)
    x <- gsub("end-date", "end.date", x, fixed = TRUE)
    x <- gsub("max-results", "max.results", x, fixed = TRUE)
    x <- gsub("start-index", "start.index", x, fixed = TRUE)
    x <- gsub("include-empty-rows", "include.empty.rows", x, fixed = TRUE)
    to_separated(x)
}

convert_names <- function(x) {
    nm <- names(x)
    if(!is.null(nm)) {
        nm <- rename_params(nm)
        names(x) <- nm
    }
    return(x)
}

# Convert data types
convert_types <- function(x, ...) {
    UseMethod("convert_type")
}

convert_types.character <- function(x) {
    idx <- grep("^(true|false)$", x)
    if (length(idx))
        x[idx] <- toupper(x[idx])
    utils::type.convert(x, as.is = TRUE)
}

convert_types.list <- function(x) {
    chars <- vapply(x, is.character, logical(1L))
    x[chars] <- lapply(x[chars], convert_types.character)
    return(x)
}

convert_types.data.frame <- function(x) {
    convert_types.list(x)
}

parse_params <- function(x) {
    rename_params(gsub("^[a-z]+:", "", unlist(strsplit(x, ",", fixed = TRUE))))
}
