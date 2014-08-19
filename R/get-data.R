# Set the RCurlOptions for Windows
set_curl_opts <- function() {
    if (.Platform$OS.type == "windows") {
        options(RCurlOptions = list(
            verbose = FALSE,
            capath = system.file("CurlSSL", "cacert.pem", package = "RCurl"),
            ssl.verifypeer = FALSE))
    }
}

#' @title Make a Goolge Analytics API request
#'
#' @param url the url of the page to retrieve.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param simplify logical. Should the result be simplified to a vector, matrix or data.frame if possible?
#' @param verbose logical. Should print information verbose?
#'
#' @keywords internal
#'
#' @noRd
#'
#' @include auth.R
#'
#' @importFrom httr GET config content http_status
#' @importFrom jsonlite fromJSON
#'
make_request = function(url, token, simplify = TRUE, verbose = getOption("rga.verbose", FALSE)) {
    stopifnot(is.character(url) && length(url) == 1L)
    set_curl_opts()
    # Print the URL to the console
    if (verbose) {
        message("Sending request to Google Analytics...")
        message(url)
    }
    if (!missing(token)) {
        stopifnot(inherits(token, "Token2.0"))
        request <- GET(url = url, config = config(token = token))
    } else {
        if (token_exists("GAToken")) {
            token <- get_token("GAToken")
            stopifnot(inherits(token, "Token2.0"))
            request <- GET(url = url, config = config(token = token))
        } else
            request <- GET(url = url)
    }
    # Send query to Google Analytics API and capture the JSON reponse
    if (verbose)
        message(http_status(request)$message)
    # Convert the JSON response into a R list
    data_json <- fromJSON(content(request, as = "text"), simplifyVector = simplify)
    # Parse API error messages
    if (!is.null(data_json$error)) {
        code <- http_status(request)$message
        reasons <- data_json$error$errors$message
        stop(paste(code, paste("Reason:", reasons, collapse = "\n"), sep = "\n"))
    }
    # Return the list containing Google Analytics API response
    return(data_json)
}

#' @title Get a Google Analytics API response
#'
#' @param path list including a request parameters.
#' @param query list including a request parameters.
#' @param type character string including report type.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @return A list contatin Google Analytics API response.
#'
#' @keywords internal
#'
#' @noRd
#'
#' @include url.R
#'
get_data <- function(type, query, path, token, simplify = TRUE, verbose = getOption("rga.verbose", FALSE)) {
    url <- build_url(type = type, path = path, query = query)
    data_json <- make_request(url, token = token, simplify = simplify, verbose = verbose)
    return(data_json)
}

#' @include query.R
#'
test_request <- function(type, query, token, simplify = TRUE, verbose = getOption("rga.verbose", FALSE)) {
    if (verbose)
        message("Check query...")
    query$max.results <- 1L
    data_json <- get_data(type = type, query = query, token = token, simplify = simplify, verbose = verbose)
    return(data_json)
}

#' @include query.R
#'
get_pages <- function(type = c("ga", "mcf"), query, total.results, token, verbose = getOption("rga.verbose", FALSE)) {
    type <- match.arg(type)
    total.pages <- ceiling(total.results / query$max.results)
    rows <- vector(mode = "list", length = total.pages)
    for (page in 1:total.pages) {
        if (verbose)
            message(paste0("Fetching page ", page, " of ", total.pages, "..."))
        query$start.index <- query$max.results * (page - 1) + 1
        data_json <- get_data(type = type, query = query, token = token, verbose = verbose)
        rows[[page]] <- data_json$rows
    }
    if (inherits(rows[[1]], "matrix") || inherits(rows[[1]], "data.frame"))
        rows <- do.call(rbind, rows)
    else if (inherits(rows[[1]], "list"))
        rows <- do.call(c, rows)
    return(rows)
}

#' @include query.R
#'
get_rows <- function(type = c("ga", "mcf", "rt"), query, total.results, token, verbose = getOption("rga.verbose", FALSE)) {
    type <- match.arg(type)
    if (!is.null(query$max.results)) {
        stopifnot(query$max.results <= 10000)
        if (query$max.results < total.results)
            warning(paste("Only", query$max.results, "observations out of", total.results, "were obtained (set max.results = NULL to get all results)."))
        data_json <- get_data(type = type, query = query, token = token, verbose = verbose)
        rows <- data_json$rows
    } else {
        if (total.results <= 10000) {
            query$max.results <- total.results
            data_json <- get_data(type = type, query = query, token = token, verbose = verbose)
            rows <- data_json$rows
        } else {
            if (verbose)
                message("Response contain more then 10000 rows.")
            query$max.results <- 10000L
            if (type == "rt") {
                warning(paste("Only", query$max.results, "observations out of", total.results, "were obtained (the batch processing mode is not implemented for this report type)."))
                data_json <- get_data(type = type, query = query, token = token, verbose = verbose)
                rows <- data_json$rows
            } else {
                rows <- get_pages(type = type, query = query, total.results = total.results, verbose = verbose)
            }
        }
    }
    if (verbose)
        message("obtained data.frame with", nrow(rows), "rows and", ncol(rows), "columns.")
    return(rows)
}
