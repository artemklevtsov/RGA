#' @include utils.R
get_report_url <- function(query) {
    stopifnot(inherits(query, "GAQuery"))
    if (inherits(query, "core"))
        url <- "https://www.googleapis.com/analytics/v3/data/ga"
    else if (inherits(query, "mcf"))
        url <- "https://www.googleapis.com/analytics/v3/data/mcf"
    else
        stop("Unknown report type.")
    query <- compact(query)
    params <- names(query)
    params <- gsub("profile.id", "ids", params)
    params <- gsub("\\.", "-", params)
    values <- as.vector(query, mode = "character")
    values <- curlEscape(values)
    string <- paste(params, values, sep = "=", collapse = "&")
    return(paste(url, string, sep = "?"))
}

build_core <- function(rows, cols) {
    cols$name <- gsub("ga:", "", cols$name)
    data.df <- as.data.frame(rows, stringsAsFactors = FALSE)
    colnames(data.df) <- cols$name
    return(data.df)
}

build_mcf <- function(rows, cols) {
    columns$name <- gsub("mcf:", "", cols$name)
    if ("MCF_SEQUENCE" %in% cols$dataType) {
        primitive.idx <- grep("MCF_SEQUENCE", cols$dataType, invert = TRUE)
        conversion.idx <- grep("MCF_SEQUENCE", cols$dataType)
        primitive <- lapply(lapply(rows, "[[", "primitiveValue"), "[", primitive.idx)
        primitive <- do.call(rbind, primitive)
        colnames(primitive) <- cols$name[primitive.idx]
        conversion <- lapply(lapply(rows, "[[", "conversionPathValue"), "[", conversion.idx)
        conversion <- lapply(conversion, function(x) lapply(x, function(i) apply(i, 1, paste, sep = "", collapse = ":")))
        conversion <- lapply(conversion, function(x) lapply(x, paste, collapse = " > "))
        conversion <- do.call(rbind, lapply(conversion, unlist))
        colnames(conversion) <- cols$name[conversion.idx]
        data.df <- data.frame(primitive, conversion, stringsAsFactors = FALSE)[, cols$name]
    } else {
        data.df <- as.data.frame(do.call(rbind, lapply(rows, unlist)), stringsAsFactors = FALSE)
        # insert column names
        colnames(data.df) <- cols$name
    }
    return(data.df)
}

convert_datatypes <- function(x, formats, date.format = "%Y-%m-%d") {
    formats[formats %in% c("INTEGER", "PERCENT", "TIME", "CURRENCY", "FLOAT")] <- "numeric"
    formats[formats == "STRING"] <- "character"
    formats[formats == "MCF_SEQUENCE"] <- "character"
    x[] <- lapply(seq_along(formats), function(i) as(x[[i]], Class = formats[i]))
    if ("date" %in% colnames(x)) {
        x$date <- format(as.Date(x$date, "%Y%m%d"), date.format)
    }
    if ("conversionDate" %in% colnames(x)) {
        x$conversionDate <- format(as.Date(x$conversionDate, "%Y%m%d"), date.format)
    }
    return(x)
}

#' @title Get Google Anaytics report data
#'
#' @description
#' \code{get_report} provide a query the Core or Multi-Channel Funnels Reporting API for Google Analytics report data.
#'
#' @param profile.id Google Analytics profile ID. Can be character (with or without "ga:" prefix) or integer.
#' @param start.date start date for fetching Analytics data in YYYY-MM-DD format.
#' @param end.date rnd date for fetching Analytics data in YYYY-MM-DD format.
#' @param metrics a comma-separated list of Analytics metrics, such as ga:sessions,ga:bounces.
#' @param dimensions a comma-separated list of Analytics dimensions, such as ga:browser,ga:city.
#' @param sort a comma-separated list of dimensions or metrics that determine the sort order for Analytics data.
#' @param filters a comma-separated list of dimension or metric filters to be applied to Analytics data.
#' @param segment an Analytics segment to be applied to data.
#' @param start.index an index of the first entity to retrieve.
#' @param max.results the maximum number of entries to include in this feed.
#' @param token \code{Token2.0} class object.
#' @param date.format date format for output data.
#' @param messages print information messages.
#' @param query \code{GAQuery} class object.
#'
#' @return A data frame with Google Analytics reporting data.
#'
#' @references
#' Core Reporting API - Dimensions & Metrics Reference: \url{https://developers.google.com/analytics/devguides/reporting/core/dimsmets}
#'
#' Multi-Channel Funnels Reporting API - Dimensions & Metrics Reference: \url{https://developers.google.com/analytics/devguides/reporting/mcf/dimsmets/}
#'
#' Google Analytics Query Explorer 2: \url{https://ga-dev-tools.appspot.com/explorer/}
#'
#' @seealso \code{\link{get_token}}
#'
#' @include api-request.R
#'
#' @export
#'
get_report <- function(profile.id, start.date = "7daysAgo", end.date = "yesterday",
                       metrics = "ga:users,ga:sessions,ga:pageviews", dimensions = "ga:date",
                       sort = NULL, filters = NULL, segment = NULL, start.index = 1L, max.results = 10000L,
                       date.format = "%Y-%m-%d", query, token, messages = FALSE) {
    if (!missing(query) && !missing(profile.id))
        stop("Must specify query or additional arguments.")
    if (missing(query) && !missing(profile.id)) {
        query <- set_query(profile.id = profile.id, start.date = start.date, end.date = end.date,
                           metrics = metrics, dimensions = dimensions, sort = sort, filters = filters,
                           segment = segment, start.index = start.index, max.results = max.results)
    }
    url <- get_report_url(query)
    data.json <- get_api_request(url, token = token, messages = messages)
    cols <- data.json$columnHeaders
    formats <- data.json$columnHeaders$dataType
    if (data.json$totalResults > 0 && !is.null(data.json$rows)) {
        rows <- data.json$rows
        max.rows <- min(data.json$totalResults, query$max.results)
        total.pages <- ceiling(max.rows / query$max.results)
        if (total.pages > 1L) {
            if (messages)
                message("Response contain more then 10000 rows.")
            for (page in 2:total.pages) {
                if (messages)
                    message(paste0("Fetching page ", page, " of ", total.pages, "..."))
                query$start.index <- query$max.results * (page - 1) + 1
                url <- get_report_url(query)
                data.json <- get_api_request(url, token = token, messages = messages)
                if (inherits(rows, "list"))
                    rows <- append(rows, data.json$rows)
                else if (inherits(rows, "matrix"))
                    rows <- rbind(rows, data.json$rows)
            }
        }
    }
    else
        rows <- matrix(NA, nrow = 1L, ncol = nrow(cols))
    sampled <- data.json$containsSampledData
    if (sampled)
        warning("Data contains sampled data.")
    if (inherits(query, "core"))
        data.r <- build_core(rows, cols)
    else if (inherits(query, "mcf"))
        data.r <- build_mcf(rows, cols)
    data.df <- convert_datatypes(data.r, formats, date.format = date.format)
    return(data.df)
}

#' @title Get the first date with available data
#'
#' @param profile.id Google Analytics profile ID.
#' @param token \code{Token2.0} class object.
#'
#' @return date in YYYY-MM-DD format.
#'
#' @examples
#' \dontrun{
#' first.date <- get_firstdate(profile.id = "myProfileID", token = ga_token)
#' }
#'
#' @include query.R
#'
#' @export
#'
get_firstdate <- function(profile.id, token) {
    data.r <- get_report(profile.id = profile.id, start.date = "2005-01-01",
                         metrics = "ga:sessions", dimensions = "ga:date",
                         filters = "ga:sessions!=0", max.results = 1L,
                         token = token, messages = FALSE)
    return(data.r$date)
}
