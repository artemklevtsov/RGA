#' @title Make a Goolge Analytics API request
#'
#' @param url the url of the page to retrieve.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param simplify logical. Should the result be simplified to a vector, matrix or data.frame if possible?
#' @param verbose logical. Should print information verbose?
#'
#' @noRd
#'
#' @keywords internal
#'
#' @include token.R
#'
#' @importFrom httr GET
#' @importFrom httr config
#' @importFrom httr content
#' @importFrom httr http_status
#' @importFrom jsonlite fromJSON
#'
api_request = function(url, token, simplify = TRUE, verbose = getOption("rga.verbose", FALSE)) {
    stopifnot(is.character(url) && length(url) == 1L)
    if (.Platform$OS.type == "windows") {
        options(RCurlOptions = list(
            verbose = FALSE,
            capath = system.file("CurlSSL", "cacert.pem", package = "RCurl"),
            ssl.verifypeer = FALSE))
    }
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
    data.json <- fromJSON(content(request, as = "text"), simplifyVector = simplify)
    if (!is.null(data.json$error)) {
        stop(paste(http_status(request)$message, "Reason:",
                   paste(data.json$error$errors$message, collapse = "\n"), sep = "\n"))
    }
    # Return the list containing Google Analytics API response
    return(data.json)
}
