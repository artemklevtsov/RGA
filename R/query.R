# Fix query fields
#' @include utils.R
fix_query <- function(query) {
    stopifnot(inherits(query, "list"))
    if (!grepl("^ga:", query$profile.id))
        query$profile.id <- paste0("ga:", query$profile.id)
    if (!is.null(query$metrics) && query$metrics != "")
        query$metrics <- gsub("\\s", "", query$metrics)
    if (!is.null(query$dimensions) && query$dimensions != "")
        query$dimensions <- gsub("\\s", "", query$dimensions)
    if (!is.null(query$sort) && query$sort != "")
        query$sort <- gsub("\\s", "", query$sort)
    # make pattern for gsub
    ops.pattern <- paste("(\\ )+(", paste(ga_ops, collapse = "|"), ")(\\ )+", sep = "")
    if (!is.null(query$filters) && query$filters != "") {
        # remove whitespaces around operators
        query$filters <- gsub(ops.pattern, "\\2", query$filters)
        # replace logical operators
        query$filters <- gsub("OR|\\|\\|", ",", query$filters)
        query$filters <- gsub("AND|&&", ";", query$filters)
    }
    if (!is.null(query$segment) && query$segment != "") {
        # remove whitespaces around operators
        query$segment <- gsub(ops.pattern, "\\2", query$segment)
        # replace logical operators
        query$segment <- gsub("OR|\\|\\|", ",", query$segment)
        query$segment <- gsub("AND|&&", ";", query$segment)
    }
    return(query)
}

#' @title Set Google Analytics report query
#'
#' @description
#' \code{set_query} provide a query the Core or Multi-Channel Funnels Reporting API for Google Analytics report data.
#'
#' @param profile.id Google Analytics profile ID. Can be character (with or without "ga:" prefix) or integer.
#' @param start.date start date for fetching Analytics data in YYYY-MM-DD format.
#' @param end.date rnd date for fetching Analytics data in YYYY-MM-DD format.
#' @param metrics a comma-separated list of Analytics metrics, such as ga:sessions,ga:bounces.
#' @param dimensions a comma-separated list of Analytics dimensions, such as ga:browser,ga:city.
#' @param sort a comma-separated list of dimensions or metrics that determine the sort order for Analytics data.
#' @param filters a comma-separated list of dimension or metric filters to be applied to Analytics data.
#' @param segment an Analytics segment to be applied to data.
#' @param start.index an index of the first entity to retrieve.
#' @param max.results the maximum number of entries to include in this feed.
#'
#' @return \code{GAQuery} class object.
#'
#' @examples
#' set_query(profile.id = "ga:00000000")
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
#' @references
#' Core Reporting API - Dimensions & Metrics Reference: \url{https://developers.google.com/analytics/devguides/reporting/core/dimsmets}
#'
#' Multi-Channel Funnels Reporting API - Dimensions & Metrics Reference: \url{https://developers.google.com/analytics/devguides/reporting/mcf/dimsmets/}
#'
#' Google Analytics Query Explorer 2: \url{https://ga-dev-tools.appspot.com/explorer/}
#'
#' @export
#'
set_query <- function(profile.id, start.date = "7daysAgo", end.date = "yesterday",
                      metrics = "ga:users,ga:sessions,ga:pageviews", dimensions = "ga:date",
                      sort = NULL, filters = NULL, segment = NULL, start.index = 1L, max.results = 10000L) {
    profile.id <- as.character(profile.id)
    start.date <- as.character(start.date)
    end.date <- as.character(end.date)
    # Checks
    stopifnot(!missing(profile.id),
              !is.null(start.date), start.date != "",
              !is.null(end.date), end.date != "",
              !is.null(metrics), metrics != "")
    if (grepl("ga:", metrics) && grepl("mcf:", metrics))
        stop("Only one prefix allowed: 'ga:' or 'mcf:'.")
    if (grepl("ga:", dimensions) && grepl("mcf:", dimensions))
        stop("Only one prefix allowed: 'ga:' or 'mcf:'.")
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
    if (grepl("mcf:", metrics) && grepl("mcf:", dimensions))
        class(query) <- c(class(query), "mcf")
    else if (grepl("ga:", metrics) && grepl("ga:", dimensions))
        class(query) <- c(class(query), "core")
    else
        stop("Metrics and dimensions should have same prefix: ga or mcf.")
    return(query)
}

#' @include utils.R
#' @export
print.GAQuery <- function(x, ...) {
    if (inherits(x, "mcf"))
        x <- c(report.type = "multi-channel funnels", x)
    else if (inherits(x, "core"))
        x <- c(report.type = "core", x)
    x <- compact(x)
    cat("<Google Analytics Query>\n")
    cat(paste0("  ", format(paste0(names(x), ": ")), unlist(x), collapse = "\n"))
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
    x[[name]] <- value
    x <- fix_query(x)
    class(x) <- cl
    return(x)
}

#'@export
`[[<-.GAQuery` <- `$<-.GAQuery`

#'@export
`[<-.GAQuery` <- `$<-.GAQuery`
