#' @title Get the Anaytics reporting data
#'
#' @param type character. Report type. Allowed values: ga, mcf, rt.
#' @param query list. List of the data request query parameters.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return A data frame including the Analytics data for a view (profile).
#'
#' @keywords internal
#'
#' @include query.R
#' @include get-data.R
#' @include convert.R
#'
#' @noRd
#'
#' @examples
#' \dontrun{
#' # get token data
#' authorize(client.id = "client_id", client.secret = "client_sevret")
#' # set query
#' query <- list(profile.id = "XXXXXXXX", start.date = "31daysAgo", end.date = "today",
#'               metrics = "ga:users,ga:sessions", dimensions = "ga:userType")

#' # get report data
#' ga_data <- get_report(type = "ga", query = query)
#' }
#'
get_report <- function(type = c("ga", "mcf", "rt"), query, token) {
    type <- match.arg(type)
    if (type == "rt")
        query$fields <- "columnHeaders,rows"
    else
        query$fields <- "containsSampledData,columnHeaders,rows"
    data_json <- get_data(type = type, query = query, token = token)
    rows <- data_json$rows
    cols <- data_json$columnHeaders
    if (data_json$totalResults == 0L || is.null(rows)) {
        message("No results were obtained.")
        return(NULL)
    }
    if (is.list(rows)) {
        if (is.matrix(rows[[1L]]))
            rows <- do.call(rbind, rows)
        else if (is.list(rows[[1L]]) && !is.data.frame(rows[[1L]]))
            rows <- do.call(c, rows)
    }
    if (!is.null(data_json$containsSampledData) && data_json$containsSampledData)
        warning("Data contains sampled data.", call. = FALSE)
    data_df <- build_df(type, rows, cols)
    return(data_df)
}

#' @title Get the Anaytics data from Core Reporting API for a view (profile)
#'
#' @param profile.id integer or character. Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID. Can be obtained using the \code{\link{list_profiles}} or via the web interface Google Analytics.
#' @param start.date character. Start date for fetching Analytics data. Request can specify the start date formatted as YYYY-MM-DD or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
#' @param end.date character. End date for fetching Analytics data. Request can specify the end date formatted as YYYY-MM-DD or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is yesterday.
#' @param metrics character. A comma-separated list of Analytics metrics. E.g., \code{"ga:sessions,ga:pageviews"}. At least one metric must be specified.
#' @param dimensions character. A comma-separated list of Analytics dimensions. E.g., \code{"ga:browser,ga:city"}.
#' @param sort character. A comma-separated list of dimensions or metrics that determine the sort order for Analytics data.
#' @param filters character. A comma-separated list of dimension or metric filters to be applied to Analytics data.
#' @param segment character. An Analytics segment to be applied to data. Can be obtained using the \code{\link{list_segments}} or via the web interface Google Analytics.
#' @param sampling.level character. The desired sampling level. Allowed values: "default", "faster", "higher_precision".
#' @param start.index integer. An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of entries to include in this feed.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return A data frame including the Analytics data for a view (profile).
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/reporting/core/dimsmets}{Core Reporting API - Dimensions & Metrics Reference}
#'
#' \href{https://developers.google.com/analytics/devguides/reporting/core/v3/reference#q_details}{Core Reporting API - Query Parameter Details}
#'
#' \href{https://developers.google.com/analytics/devguides/reporting/core/v3/common-queries}{Core Reporting API - Common Queries}
#'
#' \href{https://ga-dev-tools.appspot.com/explorer/}{Query Explorer}
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
#' ga_data <- get_ga("profile_id", start.date = "30daysAgo", end.date = "today",
#'                   metrics = "ga:sessions", dimensions = "ga:source,ga:medium",
#'                   sort = "-ga:sessions")
#' }
#'
#' @export
#'
get_ga <- function(profile.id, start.date = "7daysAgo", end.date = "yesterday",
                   metrics = "ga:users,ga:sessions,ga:pageviews", dimensions = NULL,
                   sort = NULL, filters = NULL, segment = NULL, sampling.level = NULL,
                   start.index = NULL, max.results = NULL, token) {
    stopifnot(!is.null(profile.id), nzchar(profile.id),
              !is.null(start.date), nzchar(start.date),
              !is.null(end.date), nzchar(end.date),
              !is.null(metrics), nzchar(metrics))
    if (!is.null(sampling.level))
        sampling.level <- match.arg(sampling.level, c("default", "faster", "higher_precision"))
    query <- set_query(profile.id = profile.id, start.date = start.date, end.date = end.date,
                       metrics = metrics, dimensions = dimensions, sort = sort, filters = filters,
                       segment = segment, sampling.level = sampling.level,
                       start.index = start.index, max.results = max.results)
    res <- get_report(type = "ga", query = query, token = token)
    if (!is.null(res$date))
        res$date <- as.Date(as.character(res$date), "%Y%m%d")
    return(res)
}

#' @title Get the Anaytics data from Multi-Channel Funnels Reporting API for a view (profile)
#'
#' @param profile.id integer or character. Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID. Can be obtained using the \code{\link{list_profiles}} or via the web interface Google Analytics.
#' @param start.date character. Start date for fetching Analytics data. Request can specify a start date formatted as YYYY-MM-DD or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
#' @param end.date character. End date for fetching Analytics data. Request can specify an end date formatted as YYYY-MM-DD or as a relative date (e.g., today, yester-day, or 7daysAgo). The default value is yesterday.
#' @param metrics character. A comma-separated list of Multi-Channel Funnels metrics. E.g., \code{"mcf:totalConversions,mcf:totalConversionValue"}. At least one metric must be specified.
#' @param dimensions character. A comma-separated list of Multi-Channel Funnels dimensions. E.g., code{"mcf:source,mcf:medium"}.
#' @param sort character. character. A comma-separated list of dimensions or metrics that determine the sort order for Analytics data.
#' @param filters character. A comma-separated list of dimension or metric filters to be applied to Analytics data.
#' @param sampling.level character. The desired sampling level. Allowed values: "default", "faster", "higher_precision".
#' @param start.index integer. An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of entries to include in this feed.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return A data frame including the Analytics Multi-Channel Funnels data for a view (profile)
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
#' authorize(client.id = "client_id", client.secret = "client_sevret")
#' # get report data
#' ga_data <- get_mcf("profile_id", start.date = "30daysAgo", end.date = "today",
#'                    metrics = "mcf:totalConversions",
#'                    dimensions = "mcf:source,mcf:medium")
#' }
#'
#' @export
#'
get_mcf <- function(profile.id, start.date = "7daysAgo", end.date = "yesterday",
                    metrics = "mcf:totalConversions", dimensions = NULL,
                    sort = NULL, filters = NULL, sampling.level = NULL,
                    start.index = NULL, max.results = NULL, token) {
    stopifnot(!is.null(profile.id), nzchar(profile.id),
              !is.null(start.date), nzchar(start.date),
              !is.null(end.date), nzchar(end.date),
              !is.null(metrics), nzchar(metrics))
    if (!is.null(sampling.level))
        sampling.level <- match.arg(sampling.level, c("default", "faster", "higher_precision"))
    query <- set_query(profile.id = profile.id, start.date = start.date, end.date = end.date,
                       metrics = metrics, dimensions = dimensions, sort = sort, filters = filters,
                       sampling.level = sampling.level,
                       start.index = start.index, max.results = max.results)
    res <- get_report(type = "mcf", query = query, token = token)
    if (!is.null(res$conversion.date))
        res$conversion.date <- as.Date(as.character(res$conversion.date), "%Y%m%d")
    return(res)
}

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
#' @return A data frame including the real time data for a view (profile).
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
#' @export
#'
get_rt <- function(profile.id, metrics = "rt:activeUsers", dimensions = NULL,
                         sort = NULL, filters = NULL, max.results = NULL, token) {
    stopifnot(!is.null(profile.id), nzchar(profile.id),
              !is.null(metrics), nzchar(metrics))
    query <- set_query(profile.id = profile.id, metrics = metrics, dimensions = dimensions,
                       sort = sort, filters = filters, max.results = max.results)
    res <- get_report(type = "rt", query = query, token = token)
    return(res)
}

#' @title Get the first date with available data
#'
#' @param profile.id Google Analytics profile ID. Can be obtained using the \code{\link{list_profiles}} or via the web interface Google Analytics.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return Start date of collecting the Google Analytics statistics.
#'
#' @seealso \code{\link{authorize}}
#'
#' @family Reporting API
#'
#' @examples
#' \dontrun{
#' authorize(client.id = "client_id", client.secret = "client_sevret")
#' first_date <- get_firstdate(profile.id = "profile_id")
#' }
#'
#' @export
#'
get_firstdate <- function(profile.id, token) {
    res <- suppressWarnings(
        get_ga(profile.id = profile.id, start.date = "2005-01-01", end.date = "today",
               metrics = "ga:sessions", dimensions = "ga:date", filters = "ga:sessions>0",
               max.results = 1L, token = token)
    )
    return(res$date)
}
