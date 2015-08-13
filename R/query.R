# Set query
#' @include utils.R
build_query <- function(...) {
    query <- list(...)
    query <- fix_query(query)
    return(query)
}

# Fix query fields
#' @include utils.R
fix_query <- function(query) {
    stopifnot(is.list(query))
    query <- compact(query)
    if (!grepl("^ga:", query$profile.id))
        query$profile.id <- paste0("ga:", query$profile.id)
    snames <- c("metrics", "dimensions", "sort")
    query[names(query) %in% snames] <- lapply(query[names(query) %in% snames], strip_spaces)
    onames <- c("filters", "segment")
    query[names(query) %in% onames] <- lapply(query[names(query) %in% onames], strip_ops)
    dnames <- c("start.date", "end.date")
    query[names(query) %in% dnames] <- lapply(query[names(query) %in% dnames], as.character)
    if (!is.empty(query$sampling.level))
        query$sampling.level <- toupper(query$sampling.level)
    return(query)
}
