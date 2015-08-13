#' @title Get the Anaytics data from Real Time Reporting API for a view (profile)
#'
#' @param profile.id integer or character. Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID. Can be obtained using the \code{\link{list_profiles}} or via the web interface Google Analytics.
#' @param metrics character. A comma-separated list of real time metrics. E.g., \code{"rt:activeUsers"}. At least one metric must be specified.
#' @param dimensions character. A comma-separated list of real time dimensions. E.g., \code{"rt:medium,rt:city"}.
#' @param sort character. A comma-separated list of dimensions or metrics that determine the sort order for real time data.
#' @param filters character. A comma-separated list of dimension or metric filters to be applied to real time data.
#' @param max.results integer. The maximum number of entries to include in this feed.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return A data frame including the real time data for a view (profile). Addition information about profile and request query stored in the attributes.
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/reporting/realtime/dimsmets/}{Real Time Reporting API - Dimensions & Metrics Reference}
#'
#' @seealso \code{\link{authorize}}
#'
#' @family Reporting API
#'
#' @examples
#' \dontrun{
#' # get token data
#' authorize(client.id = "client_id", client.secret = "client_sevret")
#' # get report data
#' ga_data <- get_rt("profile_id", metrics = "rt:activeUsers", dimensions = "rt:source,rt:medium")
#' # get active users in realtime (press Esc to abort)
#' while (TRUE) {
#'     cat("\014")
#'     print(get_rt("profile_id", metrics = "rt:activeUsers"))
#'     Sys.sleep(2)
#' }
#' }
#'
#' @include report.R
#'
#' @export
#'
get_rt <- function(profile.id, metrics = "rt:activeUsers", dimensions = NULL,
                   sort = NULL, filters = NULL, max.results = NULL, token) {
    query <- build_query(profile.id = profile.id, metrics = metrics, dimensions = dimensions,
                         sort = sort, filters = filters, max.results = max.results)
    res <- get_report(type = "rt", query = query, token = token)
    return(res)
}
