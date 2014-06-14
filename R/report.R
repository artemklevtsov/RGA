# Build report API url
#' @include utils.R
#' @import RCurl
#'
get_report_url <- function(query, type) {
    stopifnot(inherits(query, "GAQuery"))
    if (type == "ga")
        url <- "https://www.googleapis.com/analytics/v3/data/ga"
    else if (type == "mcf")
        url <- "https://www.googleapis.com/analytics/v3/data/mcf"
    else
        stop("Unknown report type.")
    query <- compact(query)
    params <- names(query)
    params <- gsub("profile\\.id", "ids", params)
    params <- gsub("\\.", "-", params)
    values <- as.vector(query, mode = "character")
    values <- curlEscape(values)
    string <- paste(params, values, sep = "=", collapse = "&")
    return(paste(url, string, sep = "?"))
}

#' @title Get Google Anaytics report data
#'
#' @description
#' \code{get_report} provide a query the Core or Multi-Channel Funnels Reporting API for Google Analytics report data.
#'
#' @param profile.id character or numeric. Google Analytics profile ID. Can be character (with or without "ga:" prefix) or integer.
#' @param start.date character. Start date for fetching Analytics data in YYYY-MM-DD format. Also allowed values "today", "yesterday", "ndaysAgo" whene n is number of days.
#' @param end.date character. End date for fetching Analytics data in YYYY-MM-DD format. Also allowed values "today", "yesterday", "ndaysAgo" whene n is number of days.
#' @param metrics  character. A comma-separated list of Analytics metrics, such as "ga:sessions,ga:bounces".
#' @param dimensions character. A comma-separated list of Analytics dimensions, such as "ga:browser,ga:city".
#' @param sort character. A comma-separated list of dimensions or metrics that determine the sort order for Analytics data.
#' @param filters character. A comma-separated list of dimension or metric filters to be applied to Analytics data.
#' @param segment character. An Analytics segment to be applied to data.
#' @param start.index character. An index of the first entity to retrieve.
#' @param max.results character. The maximum number of entries to include in this feed.
#' @param date.format character. A date format for output data.
#' @param type character string including report type. "ga" for core report, "mcf" for multi-channel funnels report.
#' @param token \code{Token2.0} class object with a valid authorization data.
#' @param messages logical. Should print information messages?
#' @param batch logical. Extract data in batches (extracting more observations than 10000).
#' @param query \code{GAQuery} class object including a request parameters.
#'
#' @return A data frame with Google Analytics reporting data. Columns are metrics and dimesnions.
#'
#' @examples
#' \dontrun{
#'     # get token data
#'     ga_token <- get_token(client.id = "myID", client.secret = "mySecret")
#'     # get reporting data
#'     ga_data <- get_report("myProfileID", start.date = "30daysAgo", end.date = "today",
#'                           metrics = "ga:sessions", dimensions = "ga:source,ga:medium"
#'                           sort = "-ga:sessions", token = ga_token)
#'     # same with query
#'     ga_query <- set_query("myProfileID", start.date = "30daysAgo", end.date = "today",
#'                           metrics = "ga:sessions", dimensions = "ga:source,ga:medium"
#'                           sort = "-ga:sessions")
#'     query
#'     ga_data <- get_report(ga_query, token = ga_token)
#' }
#'
#' @references
#' Core Reporting API - Dimensions & Metrics Reference: \url{https://developers.google.com/analytics/devguides/reporting/core/dimsmets}
#'
#' Multi-Channel Funnels Reporting API - Dimensions & Metrics Reference: \url{https://developers.google.com/analytics/devguides/reporting/mcf/dimsmets/}
#'
#' Google Analytics Query Explorer 2: \url{https://ga-dev-tools.appspot.com/explorer/}
#'
#' @seealso \code{\link{get_token}} \code{\link{set_query}}
#'
#' @include query.R
#' @include api-request.R
#' @include build-df.R
#' @include utils.R
#'
#' @export
#'
get_report <- function(profile.id, start.date = "7daysAgo", end.date = "yesterday",
                       metrics = "ga:users,ga:sessions,ga:pageviews", dimensions = NULL,
                       sort = NULL, filters = NULL, segment = NULL, start.index = NULL, max.results = 10000L,
                       date.format = "%Y-%m-%d", type = c("ga", "mcf"), query, token,
                       batch = FALSE, messages = FALSE) {
    if (!missing(query) && !missing(profile.id))
        stop("Must specify query or additional arguments.")
    if (missing(query) && !missing(profile.id)) {
        query <- set_query(profile.id = profile.id, start.date = start.date, end.date = end.date,
                           metrics = metrics, dimensions = dimensions, sort = sort, filters = filters,
                           segment = segment, start.index = start.index, max.results = max.results)
    }
    type <- match.arg(type)
    url <- get_report_url(query, type = type)
    data.json <- api_request(url, token = token, messages = messages)
    cols <- data.json$columnHeaders
    formats <- data.json$columnHeaders$dataType
    if (data.json$totalResults > 0 && !is.null(data.json$rows)) {
        rows <- data.json$rows
        total.pages <- ceiling(data.json$totalResults / data.json$itemsPerPage)
        if (total.pages > 1L && !batch)
            warning(paste("Only", data.json$itemsPerPage, "observations obtained of", data.json$totalResults, "total (set batch = TRUE to get all observations)."))
        if (total.pages > 1L && batch) {
            if (messages)
                message("Response contain more then 10000 rows.")
            for (page in 2:total.pages) {
                if (messages)
                    message(paste0("Fetching page ", page, " of ", total.pages, "..."))
                query$start.index <- query$max.results * (page - 1) + 1
                url <- get_report_url(query, type = type)
                data.json <- api_request(url, token = token, messages = messages)
                if (inherits(rows, "list"))
                    rows <- append(rows, data.json$rows)
                else if (inherits(rows, "matrix"))
                    rows <- rbind(rows, data.json$rows)
            }
        }
    } else
        rows <- matrix(NA, nrow = 1L, ncol = nrow(cols))
    sampled <- data.json$containsSampledData
    if (sampled)
        warning("Data contains sampled data.")
    if (type == "ga")
        data.r <- build_ga(rows, cols)
    else if (type == "mcf")
        data.r <- build_mcf(rows, cols)
    data.df <- convert_datatypes(data.r, formats, date.format = date.format)
    return(data.df)
}
