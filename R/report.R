#' @title Get Anaytics data for a view (profile)
#'
#' @description
#' \code{get_report} provide a query the Core or Multi-Channel Funnels Reporting API for Google Analytics report data.
#'
#' @param type character. Report type.
#' @param query \code{GAQuery} class object including a request parameters.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @return A data frame with Google Analytics reporting data. Columns are metrics and dimesnions.
#'
#' @examples
#' \dontrun{
#' # get token data
#' authorize(client.id = "myID", client.secret = "mySecret")
#' # set query
#' ga_query <- list("ProfileID", start.date = "30daysAgo", end.date = "today",
#'                  metrics = "ga:sessions", dimensions = "ga:source,ga:medium"
#'                  sort = "-ga:sessions")
#' # get report data
#' ga_data <- get_report(type = "ga", ga_query)
#' }
#'
#' @seealso \code{\link{authorize}}
#'
#' @family The Google Analytics Reporting API
#'
#' @keywords internal
#'
#' @noRd
#'
#' @include query.R
#' @include get-data.R
#' @include convert.R
#'
get_report <- function(type = c("ga", "mcf", "rt"), query, token, verbose = getOption("rga.verbose", FALSE)) {
    type <- match.arg(type)
    query <- fix_query(query)
    data_json <- get_data(type = type, query = query, token = token, verbose = verbose)
    rows <- data_json$rows
    cols <- data_json$columnHeaders
    if (data_json$totalResults == 0 || is.null(rows)) {
        message("No results were obtained.")
        return(NULL)
    }
    if (is.list(rows)) {
        if (is.matrix(rows[[1]]))
            rows <- do.call(rbind, rows)
        else if (is.list(rows[[1]]))
            rows <- do.call(c, rows)
    }
    if (!is.null(data_json$containsSampledData) && data_json$containsSampledData)
        warning("Data contains sampled data.", call. = FALSE)
    data_df <- build_df(type, rows, cols, verbose = verbose)
    return(data_df)
}

#' @title Get the Anaytics data from Core Reporting API for a view (profile)
#'
#' @param profile.id integer or character. Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
#' @param start.date character. Start date for fetching Analytics data. Request can specify the start date formatted as YYYY-MM-DD or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
#' @param end.date character. End date for fetching Analytics data. Request can specify the end date formatted as YYYY-MM-DD or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is yesterday.
#' @param metrics character. A comma-separated list of Analytics metrics. E.g., \code{"ga:sessions,ga:pageviews"}. At least one metric must be specified.
#' @param dimensions character. A comma-separated list of Analytics dimensions. E.g., \code{"ga:browser,ga:city"}.
#' @param sort  character. A comma-separated list of dimensions or metrics that determine the sort order for Analytics data.
#' @param filters character. A comma-separated list of dimension or metric filters to be applied to Analytics data.
#' @param segment character. An Analytics segment to be applied to data. Can be obtained using the \code{\link{get_segments}} or via the web interface Google Analytics.
#' @param start.index integer. An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of entries to include in this feed.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @return A data frame including the Analytics data for a view (profile).
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/reporting/core/dimsmets}{Core Reporting API - Dimensions & Metrics Reference}
#'
#' \href{https://developers.google.com/analytics/devguides/reporting/core/v3/common-queries}{Core Reporting API - Common Queries}
#'
#' @seealso \code{\link{authorize}}
#'
#' @family The Google Analytics Reporting API
#'
#' @examples
#' \dontrun{
#' # get token data
#' authorize(client.id = "myID", client.secret = "mySecret")
#' # get report data
#' ga_data <- get_ga("myProfileID", start.date = "30daysAgo", end.date = "today",
#'                   metrics = "ga:sessions", dimensions = "ga:source,ga:medium",
#'                   sort = "-ga:sessions")
#' }
#'
#' @export
#'
get_ga <- function(profile.id, start.date = "7daysAgo", end.date = "yesterday",
                   metrics = "ga:users,ga:sessions,ga:pageviews", dimensions = NULL,
                   sort = NULL, filters = NULL, segment = NULL, start.index = NULL, max.results = NULL,
                   token, verbose = getOption("rga.verbose", FALSE)) {
    stopifnot(!is.null(profile.id), nzchar(profile.id),
              !is.null(start.date), nzchar(start.date),
              !is.null(end.date), nzchar(end.date),
              !is.null(metrics), nzchar(metrics))
    query <- list(profile.id = profile.id, start.date = start.date, end.date = end.date,
                  metrics = metrics, dimensions = dimensions, sort = sort, filters = filters,
                  segment = segment, start.index = start.index, max.results = max.results)
    res <- get_report(query = query, type = "ga", token = token, verbose = verbose)
    return(res)
}

#' @title Get the Anaytics data from Multi-Channel Funnels Reporting API for a view (profile)
#'
#' @param profile.id integer or character. Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
#' @param start.date character. Start date for fetching Analytics data. Request can specify a start date formatted as YYYY-MM-DD or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
#' @param end.date character. End date for fetching Analytics data. Request can specify an end date formatted as YYYY-MM-DD or as a relative date (e.g., today, yester-day, or 7daysAgo). The default value is yesterday.
#' @param metrics character. A comma-separated list of Multi-Channel Funnels metrics. E.g., \code{"mcf:totalConversions,mcf:totalConversionValue"}. At least one metric must be specified.
#' @param dimensions character. A comma-separated list of Multi-Channel Funnels dimensions. E.g., code{"mcf:source,mcf:medium"}.
#' @param sort character. character. A comma-separated list of dimensions or metrics that determine the sort order for Analytics data.
#' @param filters character. A comma-separated list of dimension or metric filters to be applied to Analytics data.
#' @param start.index integer. An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of entries to include in this feed.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @return A data frame including the Analytics Multi-Channel Funnels data for a view (profile)
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/reporting/mcf/dimsmets/}{Multi-Channel Funnels Reporting API - Dimensions & Metrics Reference}
#'
#' @seealso \code{\link{authorize}}
#'
#' @family The Google Analytics Reporting API
#'
#' @examples
#' \dontrun{
#' # get token data
#' authorize(client.id = "myID", client.secret = "mySecret")
#' # get report data
#' ga_data <- get_mcf("myProfileID", start.date = "30daysAgo", end.date = "today",
#'                    metrics = "mcf:totalConversions",
#'                    dimensions = "mcf:source,mcf:medium")
#' }
#'
#' @export
#'
get_mcf <- function(profile.id, start.date = "7daysAgo", end.date = "yesterday",
                    metrics = "mcf:totalConversions", dimensions = NULL,
                    sort = NULL, filters = NULL, start.index = NULL, max.results = NULL,
                    token, verbose = getOption("rga.verbose", FALSE)) {
    stopifnot(!is.null(profile.id), nzchar(profile.id),
              !is.null(start.date), nzchar(start.date),
              !is.null(end.date), nzchar(end.date),
              !is.null(metrics), nzchar(metrics))
    query <- list(profile.id = profile.id, start.date = start.date, end.date = end.date,
                  metrics = metrics, dimensions = dimensions, sort = sort, filters = filters,
                  start.index = start.index, max.results = max.results)
    res <- get_report(query = query, type = "mcf", token = token, verbose = verbose)
    return(res)
}

#' @title Get the Anaytics data from Real Time Reporting API for a view (profile)
#'
#' @param profile.id integer or character. Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
#' @param metrics character. A comma-separated list of real time metrics. E.g., \code{"rt:activeUsers"}. At least one metric must be specified.
#' @param dimensions character. A comma-separated list of real time dimensions. E.g., \code{"rt:medium,rt:city"}.
#' @param sort character. A comma-separated list of dimensions or metrics that determine the sort order for real time data.
#' @param filters character. A comma-separated list of dimension or metric filters to be applied to real time data.
#' @param max.results integer. The maximum number of entries to include in this feed.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @return A data frame including the real time data for a view (profile).
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/reporting/realtime/dimsmets/}{Real Time Reporting API - Dimensions & Metrics Reference}
#'
#' @seealso \code{\link{authorize}}
#'
#' @family The Google Analytics Reporting API
#'
#' @examples
#' \dontrun{
#' # get token data
#' authorize(client.id = "myID", client.secret = "mySecret")
#' # get report data
#' ga_data <- get_rt("myProfileID", metrics = "rt:activeUsers", dimensions = "rt:source,rt:medium")
#' # get active users in realtime (press Esc to abort)
#' while (TRUE) {
#'     cat("\014")
#'     print(get_rt("myProfileID", metrics = "rt:activeUsers"))
#'     Sys.sleep(2)
#' }
#' }
#'
#' @export
#'
get_rt <- function(profile.id, metrics = "rt:activeUsers", dimensions = NULL,
                         sort = NULL, filters = NULL, max.results = NULL,
                         token, verbose = getOption("rga.verbose", FALSE)) {
    stopifnot(!is.null(profile.id), nzchar(profile.id),
              !is.null(metrics), nzchar(metrics))
    query <- list(profile.id = profile.id, metrics = metrics, dimensions = dimensions,
                  sort = sort, filters = filters, max.results = max.results)
    res <- get_report(query = query, type = "rt", token = token, verbose = verbose)
    return(res)
}

#' @title Get the first date with available data
#'
#' @param profile.id Google Analytics profile ID.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @return Start date of collecting the Google Analytics statistics.
#'
#' @seealso \code{\link{authorize}}
#'
#' @family The Google Analytics Reporting API
#'
#' @examples
#' \dontrun{
#' authorize(client.id = "myID", client.secret = "mySecret")
#' first.date <- get_firstdate(profile.id = "myProfileID")
#' }
#'
#' @export
#'
get_firstdate <- function(profile.id, token, verbose = getOption("rga.verbose", FALSE)) {
    res <- suppressWarnings(
        get_ga(profile.id = profile.id, start.date = "2005-01-01", end.date = "today",
               metrics = "ga:sessions", dimensions = "ga:date", filters = "ga:sessions>0",
               max.results = 1L, token = token, verbose = verbose)
    )
    return(res$date)
}
