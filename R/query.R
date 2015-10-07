# Fix query fields
#' @include utils.R
fix_query <- function(x) {
    stopifnot(is.list(x))
    x <- compact(x)
    if (!grepl("^ga:", x$profile.id))
        x$profile.id <- paste0("ga:", x$profile.id)
    snames <- c("metrics", "dimensions", "sort")
    x[names(x) %in% snames] <- lapply(x[names(x) %in% snames], strip_spaces)
    onames <- c("filters", "segment")
    x[names(x) %in% onames] <- lapply(x[names(x) %in% onames], strip_ops)
    dnames <- c("start.date", "end.date")
    x[names(x) %in% dnames] <- lapply(x[names(x) %in% dnames], as.character)
    return(x)
}

# Set query
build_query <- function(...) {
    dots <- list(...)
    query <- fix_query(dots)
    return(query)
}
