# Fix query fields
#' @include utils.R
#'
fix_query <- function(query) {
    stopifnot(is.list(query))
    if (!grepl("^ga:", query$profile.id))
        query$profile.id <- paste0("ga:", query$profile.id)
    if (!is.null(query$start.date) && !is.character(query$start.date))
        query$start.date <- as.character(query$start.date)
    if (!is.null(query$end.date) && !is.character(query$end.date))
        query$end.date <- as.character(query$end.date)
    if (!is.empty(query$metrics))
        query$metrics <- strip_spaces(query$metrics)
    if (!is.empty(query$dimensions))
        query$dimensions <- strip_spaces(query$dimensions)
    if (!is.empty(query$sort))
        query$sort <- strip_spaces(query$sort)
    if (!is.empty(query$filters))
        query$filters <- strip_ops(query$filters)
    if (!is.empty(query$segment))
        query$segment <- strip_ops(query$segment)
    if (!is.empty(query$sampling.level))
        query$sampling.level <- toupper(query$sampling.level)
    stopifnot(any(lapply(query, length) <= 1L))
    return(query)
}
