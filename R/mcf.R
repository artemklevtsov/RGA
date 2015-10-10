#' @title Get the Anaytics data from Multi-Channel Funnels Reporting API for a view (profile)
#'
#' @param profile.id integer or character. Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID. Can be obtained using the \code{\link{list_profiles}} or via the web interface Google Analytics.
#' @param start.date character. Start date for fetching Analytics data. Request can specify a start date formatted as "YYYY-MM-DD" or as a relative date (e.g., "today", "yesterday", or "7daysAgo"). The default value is "7daysAgo".
#' @param end.date character. End date for fetching Analytics data. Request can specify an end date formatted as "YYYY-MM-DD" or as a relative date (e.g., "today", "yesterday", or "7daysAgo"). The default value is "yesterday".
#' @param metrics character. A comma-separated list of Multi-Channel Funnels metrics. E.g., \code{"mcf:totalConversions,mcf:totalConversionValue"}. At least one metric must be specified.
#' @param dimensions character. A comma-separated list of Multi-Channel Funnels dimensions. E.g., \code{"mcf:source,mcf:medium"}.
#' @param sort character. character. A comma-separated list of dimensions or metrics that determine the sort order for Analytics data.
#' @param filters character. A comma-separated list of dimension or metric filters to be applied to Analytics data.
#' @param sampling.level character. The desired sampling level. Allowed values: "DEFAULT", "FASTER", "HIGHER_PRECISION".
#' @param start.index integer. An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of entries to include in this feed.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return A data frame including the Analytics Multi-Channel Funnels data for a view (profile). Addition information about profile and request query stored in the attributes.
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/reporting/mcf/dimsmets/}{MCF Reporting API - Dimensions & Metrics Reference}
#'
#' \href{https://developers.google.com/analytics/devguides/reporting/mcf/v3/reference#q_details}{MCF Reporting API - Query Parameter Details}
#'
#' @seealso \code{\link{authorize}}
#'
#' @family Reporting API
#'
#' @examples
#' \dontrun{
#' # get token data
#' authorize()
#' # get report data
#' ga_data <- get_mcf("profile_id", start.date = "30daysAgo", end.date = "today",
#'                    metrics = "mcf:totalConversions",
#'                    dimensions = "mcf:source,mcf:medium")
#' }
#'
#' @include report.R
#'
#' @export
#'
get_mcf <- function(profile.id, start.date = "7daysAgo", end.date = "yesterday",
                    metrics = "mcf:totalConversions", dimensions = NULL,
                    sort = NULL, filters = NULL, sampling.level = NULL,
                    start.index = NULL, max.results = NULL, token) {
    if (!is.null(sampling.level))
        sampling.level <- match.arg(sampling.level, c("DEFAULT", "FASTER", "HIGHER_PRECISION"))
    query <- build_query(profile.id = profile.id, start.date = start.date, end.date = end.date,
                         metrics = metrics, dimensions = dimensions, sort = sort, filters = filters,
                         sampling.level = sampling.level,
                         start.index = start.index, max.results = max.results)
    res <- get_report("data/mcf", query, token)
    return(res)
}
