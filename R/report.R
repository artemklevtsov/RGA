#' @title Get Anaytics data for a view (profile)
#'
#' @description
#' \code{get_report} provide a query the Core or Multi-Channel Funnels Reporting API for Google Analytics report data.
#'
#' @param query \code{GAQuery} class object including a request parameters.
#' @param type character. Report type.
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
#' ga_query <- set_query("myProfileID", start.date = "30daysAgo", end.date = "today",
#'                       metrics = "ga:sessions", dimensions = "ga:source,ga:medium"
#'                       sort = "-ga:sessions")
#' # get report data
#' ga_data <- get_report(ga_query, type = "ga")
#' }
#'
#' @seealso \code{\link{authorize}} \code{\link{set_query}}
#'
#' @family The Google Analytics Reporting API
#'
#' @keywords internal
#'
#' @include get-data.R
#' @include test-query.R
#' @include get-rows.R
#' @include build-df.R
#'
#' @export
#'
get_report <- function(query, type = c("ga", "mcf", "rt"), token, verbose = getOption("rga.verbose")) {
    type <- match.arg(type)
    data.json <- test_query(type = type, query = query, token = token, verbose = verbose)
    cols <- data.json$columnHeaders
    formats <- cols$dataType
    if (data.json$totalResults > 0 && !is.null(data.json$rows))
        rows <- get_rows(type = type, query = query, total.results = data.json$totalResults, token = token, verbose = verbose)
    else {
        if(verbose)
            message("No results were obtained.")
        rows <- matrix(NA, nrow = 1L, ncol = nrow(cols))
    }
    if (!is.null(data.json$containsSampledData) && data.json$containsSampledData)
        warning("Data contains sampled data.")
    if(verbose)
        message("Building data frame...")
    data.df <- build_df(type, rows, cols)
    if(verbose)
        message("Converting data types...")
    data.df <- convert_datatypes(data.df, formats)
    return(data.df)
}

#' @title Get the Anaytics data from Core Reporting API for a view (profile)
#'
#' @param profile.id string or integer. Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
#' @param start.date character. Start date for fetching Analytics data. Requests can specify a start date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
#' @param end.date character. End date for fetching Analytics data. Request can should specify an end date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is yesterday.
#' @param metrics character. A comma-separated list of Analytics metrics. E.g., "ga:sessions,ga:pageviews". At least one metric must be specified.
#' @param dimensions character. A comma-separated list of Analytics dimensions. E.g., "ga:browser,ga:city".
#' @param sort character. A comma-separated list of dimensions or metrics that determine the sort order for Analytics data.
#' @param filters character. A comma-separated list of dimension or metric filters to be applied to Analytics data.
#' @param segment character. An Analytics segment to be applied to data.
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
#' @include query.R
#'
#' @export
#'
get_ga <- function(profile.id, start.date = "7daysAgo", end.date = "yesterday",
                   metrics = "ga:users,ga:sessions,ga:pageviews", dimensions = NULL,
                   sort = NULL, filters = NULL, segment = NULL, start.index = NULL, max.results = NULL,
                   token, verbose = getOption("rga.verbose")) {
    stopifnot(!is.null(profile.id), nzchar(profile.id),
              !is.null(start.date), nzchar(start.date),
              !is.null(end.date), nzchar(end.date),
              !is.null(metrics), nzchar(metrics))
    query <- set_query(profile.id = profile.id, start.date = start.date, end.date = end.date,
                       metrics = metrics, dimensions = dimensions, sort = sort, filters = filters,
                       segment = segment, start.index = start.index, max.results = max.results)
    data.df <- get_report(query = query, type = "ga", token = token, verbose = verbose)
    return(data.df)
}

#' @title Get the Anaytics data from Multi-Channel Funnels Reporting API for a view (profile)
#'
#' @param profile.id string or integer. Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
#' @param start.date character. Start date for fetching Analytics data. Requests can specify a start date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
#' @param end.date character. End date for fetching Analytics data. Request can should specify an end date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is yesterday.
#' @param metrics character. A comma-separated list of Multi-Channel Funnels metrics. E.g., "mcf:totalConversions,mcf:totalConversionValue". At least one metric must be specified.
#' @param dimensions character. A comma-separated list of Multi-Channel Funnels dimensions. E.g., "mcf:source,mcf:medium".
#' @param sort character. A comma-separated list of dimensions or metrics that determine the sort order for Analytics data.
#' @param filters character. A comma-separated list of dimension or metric filters to be applied to Analytics data.
#' @param start.index integer. An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of entries to include in this feed.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @return A data frame including the Analytics Multi-Channel Funnels data for a view (profile).
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
#'                    dimensions = "mcf:totalConversions,mcf:totalConversionValue")
#' }
#'
#' @include query.R
#'
#' @export
#'
get_mcf <- function(profile.id, start.date = "7daysAgo", end.date = "yesterday",
                    metrics = "mcf:totalConversions", dimensions = NULL,
                    sort = NULL, filters = NULL, start.index = NULL, max.results = NULL,
                    token, verbose = getOption("rga.verbose")) {
    stopifnot(!is.null(profile.id), nzchar(profile.id),
              !is.null(start.date), nzchar(start.date),
              !is.null(end.date), nzchar(end.date),
              !is.null(metrics), nzchar(metrics))
    query <- set_query(profile.id = profile.id, start.date = start.date, end.date = end.date,
                       metrics = metrics, dimensions = dimensions, sort = sort, filters = filters,
                       start.index = start.index, max.results = max.results)
    data.df <- get_report(query = query, type = "mcf", token = token, verbose = verbose)
    return(data.df)
}

#' @@title Get the Anaytics data from Real Time Reporting API for a view (profile)
#'
#' @param profile.id string or integer. Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
#' @param metrics character. A comma-separated list of real time metrics. E.g., "rt:activeUsers". At least one metric must be specified.
#' @param dimensions character. A comma-separated list of real time dimensions. E.g., "rt:medium,rt:city".
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
#' @include query.R
#'
#' @export
#'
get_rt <- function(profile.id, metrics = "rt:activeUsers", dimensions = NULL,
                         sort = NULL, filters = NULL, max.results = NULL,
                         token, verbose = getOption("rga.verbose")) {
    stopifnot(!is.null(profile.id), nzchar(profile.id),
              !is.null(metrics), nzchar(metrics))
    query <- set_query(profile.id = profile.id, metrics = metrics, dimensions = dimensions,
                       sort = sort, filters = filters, max.results = max.results)
    data.df <- get_report(query = query, type = "rt", token = token, verbose = verbose)
    return(data.df)
}
