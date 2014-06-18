#' @title Get Google Anaytics report data
#'
#' @description
#' \code{get_report} provide a query the Core or Multi-Channel Funnels Reporting API for Google Analytics report data.
#'
#' @inheritParams set_query
#' @param query \code{GAQuery} class object including a request parameters.
#' @param type character string including report type. "ga" for core report, "mcf" for multi-channel funnels report.
#' @param token \code{Token2.0} class object with a valid authorization data.
#' @param messages logical. Should print information messages?
#' @param batch logical. Extract data in batches (extracting more observations than 10000).
#' @param date.format character. A date format for output data.
#'
#' @return A data frame with Google Analytics reporting data. Columns are metrics and dimesnions.
#'
#' @examples
#' \dontrun{
#'     # get token data
#'     authorize(client.id = "myID", client.secret = "mySecret")
#'     # get reporting data
#'     ga_data <- get_report("myProfileID", start.date = "30daysAgo", end.date = "today",
#'                           metrics = "ga:sessions", dimensions = "ga:source,ga:medium"
#'                           sort = "-ga:sessions")
#'     # same with query
#'     ga_query <- set_query("myProfileID", start.date = "30daysAgo", end.date = "today",
#'                           metrics = "ga:sessions", dimensions = "ga:source,ga:medium"
#'                           sort = "-ga:sessions")
#'     ga_data <- get_report(ga_query)
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
#' @include build-url.R
#' @include api-request.R
#' @include build-df.R
#'
#' @export
#'
get_report <- function(profile.id, start.date = "7daysAgo", end.date = "yesterday", date.format = "%Y-%m-%d",
                       metrics = "ga:users,ga:sessions,ga:pageviews", dimensions = NULL,
                       sort = NULL, filters = NULL, segment = NULL, start.index = NULL, max.results = 10000L,
                       type = c("ga", "mcf"), query, token, batch = FALSE, messages = FALSE) {
    type <- match.arg(type)
    if (type == "mcf" && !is.null(segment))
        segment <- NULL
    if (!missing(query) && !missing(profile.id))
        stop("Must specify query or additional arguments.")
    if (missing(query) && !missing(profile.id)) {
        query <- set_query(profile.id = profile.id, start.date = start.date, end.date = end.date,
                           metrics = metrics, dimensions = dimensions, sort = sort, filters = filters,
                           segment = segment, start.index = start.index, max.results = max.results)
    }
    url <- build_url(type = type, query = query)
    data.json <- api_request(url, token = token, messages = messages)
    cols <- data.json$columnHeaders
    formats <- data.json$columnHeaders$dataType
    if (data.json$totalResults > 0 && !is.null(data.json$rows)) {
        rows <- data.json$rows
        total.pages <- ceiling(data.json$totalResults / data.json$itemsPerPage)
        if (total.pages > 1L && !batch)
            warning(paste("Only", data.json$itemsPerPage, "observations out of", data.json$totalResults, "were obtained (set batch = TRUE to get all the results)."))
        if (total.pages > 1L && batch) {
            if (messages)
                message("Response contain more then 10000 rows.")
            for (page in 2:total.pages) {
                if (messages)
                    message(paste0("Fetching page ", page, " of ", total.pages, "..."))
                query$start.index <- query$max.results * (page - 1) + 1
                url <- build_url(type = type, query = query)
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
