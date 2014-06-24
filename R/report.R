#' @title Get Google Anaytics report data
#'
#' @description
#' \code{get_report} provide a query the Core or Multi-Channel Funnels Reporting API for Google Analytics report data.
#'
#' @inheritParams set_query
#' @param query \code{GAQuery} class object including a request parameters.
#' @param type character string including report type. "ga" for core report, "mcf" for multi-channel funnels report.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param messages logical. Should print information messages?
#'
#' @return A data frame with Google Analytics reporting data. Columns are metrics and dimesnions.
#'
#' @examples
#' \dontrun{
#' # get token data
#' authorize(client.id = "myID", client.secret = "mySecret")
#' # get reporting data
#' ga_data <- get_report("myProfileID", start.date = "30daysAgo", end.date = "today",
#'                       metrics = "ga:sessions", dimensions = "ga:source,ga:medium"
#'                       sort = "-ga:sessions")
#' # same with query
#' ga_query <- set_query("myProfileID", start.date = "30daysAgo", end.date = "today",
#'                       metrics = "ga:sessions", dimensions = "ga:source,ga:medium"
#'                       sort = "-ga:sessions")
#' ga_data <- get_report(ga_query)
#' }
#'
#' @references
#' Core Reporting API - Dimensions & Metrics Reference: \url{https://developers.google.com/analytics/devguides/reporting/core/dimsmets}
#'
#' Multi-Channel Funnels Reporting API - Dimensions & Metrics Reference: \url{https://developers.google.com/analytics/devguides/reporting/mcf/dimsmets/}
#'
#' Google Analytics Query Explorer 2: \url{https://ga-dev-tools.appspot.com/explorer/}
#'
#' @seealso \code{\link{authorize}} \code{\link{set_query}}
#'
#' @include query.R
#' @include get-data.R
#' @include get-pages.R
#' @include build-df.R
#'
#' @export
#'
get_report <- function(profile.id, start.date = "7daysAgo", end.date = "yesterday",
                       metrics = "ga:users,ga:sessions,ga:pageviews", dimensions = NULL,
                       sort = NULL, filters = NULL, segment = NULL, start.index = NULL, max.results = NULL,
                       type = c("ga", "mcf"), query, token, messages = FALSE) {
    type <- match.arg(type)
    if (type == "mcf" && !is.null(segment))
        segment <- NULL
    if (!missing(query) && !missing(profile.id))
        stop("Must specify query or additional arguments.")
    if (missing(query) && !missing(profile.id)) {
        query <- set_query(profile.id = profile.id, start.date = start.date, end.date = end.date,
                           metrics = metrics, dimensions = dimensions, sort = sort, filters = filters,
                           segment = segment, start.index = start.index, max.results = 1L)
    }
    data.json <- get_data(type = type, query = query, token = token, messages = messages)
    cols <- data.json$columnHeaders
    formats <- data.json$columnHeaders$dataType
    if (data.json$totalResults > 0 && !is.null(data.json$rows)) {
        if (!is.null(max.results)) {
            query$max.results <- max.results
            if (max.results < data.json$totalResults)
                warning(paste("Only", data.json$max.results, "observations out of", data.json$totalResults, "were obtained (set max.results = NULL to get all the results)."))
        } else {
            if (data.json$totalResults <= 10000)
                query$max.results <- data.json$totalResults
            else
                query$max.results <- 10000L
        }
        if (data.json$totalResults <= 10000) {
            data.json <- get_data(type = type, query = query, token = token, messages = messages)
            rows <- data.json$rows
        } else {
            if (messages)
                message("Response contain more then 10000 rows.")
            query$max.results <- 10000L
            rows <- get_pages(total.results = data.json$totalResults, type = type, query = query, token = token, messages = messages)
        }
    } else
        rows <- matrix(NA, nrow = 1L, ncol = nrow(cols))
    sampled <- data.json$containsSampledData
    if (sampled)
        warning("Data contains sampled data.")
    if(messages)
        message("Building data frame...")
    data.df <- build_df(type, rows, cols)
    if(messages)
        message("Converting data types...")
    data.df <- convert_datatypes(data.df, formats)
    return(data.df)
}
