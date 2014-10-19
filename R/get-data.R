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
            if (verbose)
                message("Use token stored in RGA:::TokenEnv$GAToken.")
            token <- get_token("GAToken")
            stopifnot(inherits(token, "Token2.0"))
            request <- GET(url = url, config = config(token = token))
        } else {
            if (verbose)
                message("Send request without authorise data.")
            request <- GET(url = url)
        }
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
#' @param type character string including report type.
#' @param path list including a request parameters.
#' @param query list including a request parameters.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param simplify logical. Should the result be simplified to a vector, matrix or data.frame if possible?
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
get_response <- function(type = c("ga", "rt", "mcf", "mgmt"), path = NULL, query = NULL, token, simplify = TRUE, verbose = getOption("rga.verbose", FALSE)) {
    type <- match.arg(type)
    url <- build_url(type = type, path = path, query = query)
    data_json <- make_request(url, token = token, simplify = simplify, verbose = verbose)
    return(data_json)
}

#' @include query.R
#'
get_pages <- function(type = c("ga", "mcf", "mgmt"), path = NULL, query = NULL, total.results, token, verbose = getOption("rga.verbose", FALSE)) {
    if (verbose)
        message(paste("Response contain more then", query$max.results, "rows. Batch processing mode enabled."))
    type <- match.arg(type)
    total.pages <- ceiling(total.results / query$max.results)
    res <- vector(mode = "list", length = total.pages)
    for (page in 2:total.pages) {
        if (verbose)
            message(paste0("Fetching page ", page, " of ", total.pages, "..."))
        query$start.index <- query$max.results * (page - 1) + 1
        res[[page]] <- get_response(type = type, path = path, query = query, token = token, verbose = verbose)
    }
    return(res[-1])
}

#' @include query.R
#'
get_data <- function(type = c("ga", "rt", "mcf", "mgmt"), path = NULL, query = NULL, token, verbose = getOption("rga.verbose", FALSE)) {
    type <- match.arg(type)
    if (type == "mgmt") {
        resukts_linit <- 1000
        items_name <- "items"
    } else {
        resukts_linit <- 10000
        items_name <- "rows"
    }
    if (is.null(query$max.results)) {
        pagination <- TRUE
        query$max.results <- resukts_linit
    }
    else {
        pagination <- FALSE
        stopifnot(query$max.results <= resukts_linit)
    }
    data_json <- get_response(type = type, path = path, query = query, token = token, verbose = verbose)
    if (!isTRUE(pagination) && query$max.results < data_json$totalResults)
        warning(paste("Only", query$max.results, "observations out of", data_json$totalResults, "were obtained. Set max.results = NULL (default value) to get all results."))
    if (isTRUE(pagination) && query$max.results < data_json$totalResults) {
        if (type == "rt")
            warning(paste("Only", query$max.results, "observations out of", data_json$totalResults, "were obtained (the batch processing mode is not implemented for this report type)."))
        else {
            pages <- get_pages(type = type, query = query, total.results = data_json$totalResults, verbose = verbose)
            pages <- lapply(pages, `[[`, items_name)
            data_json[[items_name]] <- c(list(data_json[[items_name]]), pages)
        }
    }
    return(data_json)
}
