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
#' @return GAQuery class object.
#'
#' @examples
#' \dontrun{
#' query <- set_query(profile.id = "ga:00000000")
#' print(query)
#' query <- set_query(profile.id = "ga:00000000", start.date = get_firstfate(profile.id = "ga:myProfileID", token = ga_token),
#'                    end.date = "today", metrics = "ga:users,ga:sessions,ga:pageviews", dimensions = "ga:date")
#' print(query)
#' }
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
set_query <- function(profile.id, start.date = Sys.Date() - 8, end.date = Sys.Date() - 1,
                      metrics = "ga:users,ga:sessions,ga:pageviews", dimensions = "ga:date",
                      sort = NULL, filters = NULL, segment = NULL, start.index = 1L, max.results = 10000L) {
    # Checks
    stopifnot(!missing(profile.id))
    stopifnot(!is.null(start.date))
    stopifnot(!is.null(end.date))
    stopifnot(!is.null(metrics))
    stopifnot(length(metrics) == 1L)
    stopifnot(length(dimensions) == 1L)
    if (length(strsplit(metrics, split = ",")[[1L]]) > 10L)
        stop("Not allowd more than 10 metrics.")
    if (length(strsplit(dimensions, split = ",")[[1L]]) > 7L)
        stop("Not allowd more than 7 dimensions.")
    if (!grepl("ga:|mcf:", metrics))
        stop("Invalid metrics: add 'ga:' or 'mcf:' prefix.")
    if (!grepl("ga:|mcf:", dimensions))
        stop("Invalid dimensions: add 'ga:' or 'mcf:' prefix.")
    if (!is.null(sort))
        stopifnot(length(sort) == 1L)
    if (!is.null(filters)) {
        stopifnot(length(filters) == 1L)
        # available operators
        ops <- c("==", "!=", ">", "<", ">=", "<=", "=@", "!@", "=-", "!-", "\\|\\|", "&&", "OR", "AND")
        # make pattern for gsub
        opsw <- paste("(\\ )+(", paste(ops, collapse = "|"), ")(\\ )+", sep = "")
        # remove whitespaces around operators
        filters <- gsub(opsw, "\\2", filters)
        # replace logical operators
        filters <- gsub("OR|\\|\\|", ",", filters)
        filters <- gsub("AND|&&", ";", filters)
    }
    if (max.results > 10000L)
        stop("Not allowed max.results more then 10000.")
    # Fix profile ID
    if (!grepl("ga:", profile.id))
        profile.id <- paste("ga:", profile.id, sep = "")
    if (nchar(profile.id) != 11L)
        stop("Profile ID length must be equal 11 symbols.")
    # Remove whitespaces
    metrics <- gsub("\\s", "", metrics)
    dimensions <- gsub("\\s", "", dimensions)
    # Build query
    query <- list(profile.id = profile.id,
                  start.date = as.character(start.date),
                  end.date = as.character(end.date),
                  metrics = metrics,
                  dimensions = dimensions,
                  sort = sort,
                  filters = filters,
                  segment = segment,
                  start.index = start.index,
                  max.results = max.results)
    class(query) <- c(class(query), "GAQuery")
    if (grepl("mcf:", metrics) && grepl("mcf:", dimensions))
        class(query) <- c(class(query), "mcf")
    else if (grepl("ga:", metrics) && grepl("ga:", dimensions))
        class(query) <- c(class(query), "core")
    else
        stop("Metrics and dimensions should have same prefix: ga or mcf.")
    return(query)
}

#' @include misc.R
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
