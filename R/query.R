# Set query
#' @include utils.R
set_query <- function(...) {
    query <- list(...)
    query <- compact(query)
    query <- fix_query(query)
    return(query)
}

# Fix query fields
#' @include utils.R
fix_query <- function(query) {
    stopifnot(is.list(query))
    if (!grepl("^ga:", query$profile.id, fixed = TRUE))
        query$profile.id <- paste0("ga:", query$profile.id)
    snames <- c("metrics", "dimensions", "sort")
    query[names(query) %in% snames] <- lapply(query[names(query) %in% snames], strip_spaces)
    onames <- c("filters", "segment")
    query[names(query) %in% onames] <- lapply(query[names(query) %in% onames], strip_ops)
    dnames <- c("start.date", "end.date")
    query[names(query) %in% dnames] <- lapply(query[names(query) %in% dnames], as.character)
    if (!is.empty(query$sampling.level))
        query$sampling.level <- toupper(query$sampling.level)
    stopifnot(any(lapply(query, length) <= 1L))
    names(query) <- sub("profile.id", "ids", names(query), fixed = TRUE)
    names(query) <- sub("sampling.level", "samplingLevel", names(query), fixed = TRUE)
    names(query) <- gsub(".", "-", names(query), fixed = TRUE)
    stopifnot(all(vapply(query, is.vector, logical(1))))
    return(query)
}
