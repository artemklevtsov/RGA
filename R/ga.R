#' @title Core Reporting API
#'
#' @description Get the Anaytics data from Core Reporting API for a view (profile).
#'
#' @template get_report
#' @param metrics character. A comma-separated list of Analytics metrics. E.g., \code{"ga:sessions,ga:pageviews"}. At least one metric must be specified.
#' @param dimensions character. A comma-separated list of Analytics dimensions. E.g., \code{"ga:browser,ga:city"}.
#' @param sort character. A comma-separated list of dimensions or metrics that determine the sort order for Analytics data.
#' @param filters character. A comma-separated list of dimension or metric filters to be applied to Analytics data.
#' @param segment character. An Analytics segment to be applied to data. Can be obtained using the \code{\link{list_segments}} or via the web interface Google Analytics.
#'
#' @return A data frame including the Analytics data for a view (profile). Addition information about profile and request query stored in the attributes.
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/reporting/core/dimsmets}{Core Reporting API - Dimensions & Metrics Reference}
#'
#' \href{https://developers.google.com/analytics/devguides/reporting/core/v3/reference#q_details}{Core Reporting API - Query Parameter Details}
#'
#' \href{https://developers.google.com/analytics/devguides/reporting/core/v3/common-queries}{Core Reporting API - Common Queries}
#'
#' \href{https://ga-dev-tools.appspot.com/explorer/}{Google Analytics Demos & Tools - Query Explorer}
#'
#' @seealso \code{\link{authorize}} \code{\link{list_dimsmets}} \code{\link{shiny_dimsmets}}
#'
#' @family Reporting API
#'
#' @examples
#' \dontrun{
#' # get token data
#' authorize()
#' # get report data
#' ga_data <- get_ga(XXXXXXX, start.date = "30daysAgo", end.date = "today",
#'                   metrics = "ga:sessions", dimensions = "ga:source,ga:medium",
#'                   sort = "-ga:sessions")
#' }
#'
#' @include date-ranges.R
#' @include report.R
#'
#' @export
#'
get_ga <- function(profile.id, start.date = "7daysAgo", end.date = "yesterday",
                   metrics = "ga:users,ga:sessions,ga:pageviews", dimensions = NULL,
                   sort = NULL, filters = NULL, segment = NULL, sampling.level = NULL,
                   start.index = NULL, max.results = NULL, fetch.by = NULL, token) {
    if (!is.null(sampling.level))
        sampling.level <- match.arg(sampling.level, c("DEFAULT", "FASTER", "HIGHER_PRECISION"))
    query <- build_query(profile.id = profile.id, start.date = start.date, end.date = end.date,
                         metrics = metrics, dimensions = dimensions, sort = sort, filters = filters,
                         segment = segment, sampling.level = sampling.level,
                         start.index = start.index, max.results = max.results)
    if (is.null(fetch.by))
        res <- get_report("data/ga", query, token)
    else
        res <- fetch_by("data/ga", query, fetch.by, token)
    return(res)
}
