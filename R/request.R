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
#' @param url character. The url of the page to retrieve.
#' @param simplify logical. See \code{\link[jsonlite]{fromJSON}}.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
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
make_request = function(url, simplify = TRUE, token, verbose = getOption("rga.verbose", FALSE)) {
    stopifnot(is.character(url) && length(url) == 1L)
    set_curl_opts()
    # Print the URL to the console
    if (verbose) {
        message("Sending request to the Google Analytics API...")
        message(paste("Query URL:", url))
    }
    if (!missing(token)) {
        stopifnot(inherits(token, "Token2.0"))
        if (verbose)
            message(paste("Use OAuth Token passed in", substitute(token), "variable."))
        request <- GET(url = url, config = config(token = token))
    } else {
        if (token_exists("GAToken")) {
            if (verbose)
                message("Use OAuth Token stored in RGA:::TokenEnv$GAToken.")
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
        message(paste("HTTP status", http_status(request)$message))
    # Convert the JSON response into a R list
    data_json <- fromJSON(content(request, as = "text"), simplifyVector = simplify, flatten = TRUE)
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
get_response <- function(type = c("ga", "rt", "mcf", "mgmt"), path = NULL, query = NULL, token, verbose = getOption("rga.verbose", FALSE)) {
    type <- match.arg(type)
    url <- build_url(type = type, path = path, query = query)
    data_json <- make_request(url, token = token, verbose = verbose)
    return(data_json)
}