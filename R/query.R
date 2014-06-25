# Fix query fields
#' @include utils.R
#'
fix_query <- function(query) {
    stopifnot(inherits(query, "list"))
    if (!grepl("^ga:", query$profile.id))
        query$profile.id <- paste0("ga:", query$profile.id)
    if (!is.empty(query$metrics))
        query$metrics <- gsub("\\s", "", query$metrics)
    if (!is.empty(query$dimensions))
        query$dimensions <- gsub("\\s", "", query$dimensions)
    if (!is.empty(query$sort))
        query$sort <- gsub("\\s", "", query$sort)
    if (!is.empty(query$filters))
        query$filters <- strip_ops(query$filters)
    if (!is.empty(query$segment))
        query$segment <- strip_ops(query$segment)
    return(query)
}

#' @title Set Google Analytics report query
#'
#' @description
#' \code{set_query} create a query object the for Google Analytics report data.
#'
#' @param profile.id character or integer. Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
#' @param start.date character. Start date for fetching Analytics data. Requests can specify a start date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
#' @param end.date character. End date for fetching Analytics data. Request can should specify an end date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is yesterday.
#' @param metrics character. A comma-separated list of Analytics metrics.
#' @param dimensions character. A comma-separated list of Analytics dimensions.
#' @param sort character. A comma-separated list of dimensions or metrics that determine the sort order for Analytics data.
#' @param filters character. A comma-separated list of dimension or metric filters to be applied to Analytics data.
#' @param segment character. An Analytics segment to be applied to data.
#' @param start.index integer. An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of entries to include in this feed.
#'
#' @return \code{GAQuery} class object.
#'
#' @examples
#' set_query(profile.id = "ga:00000000", start.date = "7daysAgo", end.date = "yesterday",
#'           metrics = "ga:users,ga:sessions,ga:pageviews", dimensions = "ga:date")
#' query <- set_query(profile.id = "ga:00000000", start.date = "31daysAgo", end.date = "yesterday",
#'                    metrics = "ga:sessions,ga:pageviews", dimensions = "ga:source,ga:medium")
#' query
#' query$sort <- "-ga:sessions"
#' query
#' query$sort <- NULL
#' query
#'
#' @keywords internal
#'
#' @export
#'
set_query <- function(profile.id = NULL, start.date = NULL, end.date = NULL,
                      metrics = NULL, dimensions = NULL, sort = NULL, filters = NULL,
                      segment = NULL, start.index = NULL, max.results = NULL) {
    profile.id <- as.character(profile.id)
    # Build query
    query <- list(profile.id = profile.id,
                  start.date = start.date,
                  end.date = end.date,
                  metrics = metrics,
                  dimensions = dimensions,
                  sort = sort,
                  filters = filters,
                  segment = segment,
                  start.index = start.index,
                  max.results = max.results)
    stopifnot(any(lapply(query, length) <= 1L))
    # Fix query
    query <- fix_query(query)
    class(query) <- c(class(query), "GAQuery")
    return(query)
}

#' @include utils.R
#' @export
print.GAQuery <- function(x, ...) {
    x <- compact(x)
    cat("<Google Analytics Query>\n")
    cat(paste0("  ", format(paste0(names(x), ": ")), as.vector(x, mode = "character"), collapse = "\n"))
    cat("\n")
    invisible(x)
}

#' @export
`$<-.GAQuery` <- function(x, name, value) {
    cl <- oldClass(x)
    class(x) <- NULL
    if (!name %in% names(x))
        stop(paste("Field", name, "not found: allowed assign only existing fields."))
    # Prevent remove a list element if value is NULL
    if (is.null(value))
        value <- list(NULL)
    x[name] <- value
    x <- fix_query(x)
    class(x) <- cl
    return(x)
}

#'@export
`[[<-.GAQuery` <- `$<-.GAQuery`

#'@export
`[<-.GAQuery` <- `$<-.GAQuery`
