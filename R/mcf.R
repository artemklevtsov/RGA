#' @title Multi-Channel Funnels Reporting API
#'
#' @description Get the Anaytics data from Multi-Channel Funnels Reporting API for a view (profile).
#'
#' @template get_report
#' @param metrics character. A comma-separated list of Multi-Channel Funnels metrics. E.g., \code{"mcf:totalConversions,mcf:totalConversionValue"}. At least one metric must be specified.
#' @param dimensions character. A comma-separated list of Multi-Channel Funnels dimensions. E.g., \code{"mcf:source,mcf:medium"}.
#' @param sort character. character. A comma-separated list of dimensions or metrics that determine the sort order for Analytics data.
#' @param filters character. A comma-separated list of dimension or metric filters to be applied to Analytics data.
#'
#' @return A data frame including the Analytics Multi-Channel Funnels data for a view (profile). Addition information about profile and request query stored in the attributes.
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/reporting/mcf/dimsmets/}{MCF Reporting API - Dimensions & Metrics Reference}
#'
#' \href{https://developers.google.com/analytics/devguides/reporting/mcf/v3/reference#q_details}{MCF Reporting API - Query Parameter Details}
#'
#' @examples
#' \dontrun{
#' # get token data
#' authorize()
#' # get report data
#' ga_data <- get_mcf(XXXXXXX, start.date = "30daysAgo", end.date = "today",
#'                    metrics = "mcf:totalConversions",
#'                    dimensions = "mcf:source,mcf:medium")
#' }
#'
#' @include date-ranges.R
#' @include report.R
#' @export
get_mcf <- function(profile.id, start.date = "7daysAgo", end.date = "yesterday",
                    metrics = "mcf:totalConversions", dimensions = NULL,
                    sort = NULL, filters = NULL, sampling.level = NULL,
                    start.index = NULL, max.results = NULL, fetch.by = NULL, token) {
    if (!is.null(sampling.level))
        sampling.level <- match.arg(sampling.level, c("DEFAULT", "FASTER", "HIGHER_PRECISION"))
    query <- build_query(profile.id = profile.id, start.date = start.date, end.date = end.date,
                         metrics = metrics, dimensions = dimensions, sort = sort, filters = filters,
                         sampling.level = sampling.level,
                         start.index = start.index, max.results = max.results)
    if (is.null(fetch.by))
        res <- get_report("data/mcf", query, token)
    else
        res <- fetch_by("data/mcf", query, fetch.by, token)
    return(res)
}
