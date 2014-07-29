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
#' @importFrom httr GET config content http_status
#' @importFrom jsonlite fromJSON
#'
make_request = function(url, token, simplify = TRUE, verbose = getOption("rga.verbose", FALSE)) {
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
    data_json <- fromJSON(content(request, as = "text"), simplifyVector = simplify)
    # Hamdle errors
    if (!is.null(data_json$error)) {
        stop(paste(http_status(request)$message, "Reason:",
                   paste(data_json$error$errors$message, collapse = "\n"), sep = "\n"))
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
#' @noRd
#'
#' @include url.R
#'
get_data <- function(type, query, path, token, simplify = TRUE, verbose = getOption("rga.verbose", FALSE)) {
    url <- build_url(type = type, path = path, query = query)
    data_json <- make_request(url, token = token, simplify = simplify, verbose = verbose)
    return(data_json)
}

#' @title Checking Google Analytics report query
#'
#' @inheritParams get_data
#'
#' @noRd
#'
test_request <- function(type, query, token, simplify = TRUE, verbose = getOption("rga.verbose", FALSE)) {
    if (verbose)
        message("Check query...")
    query$max.results <- 1L
    data_json <- get_data(type = type, query = query, token = token, simplify = simplify, verbose = verbose)
    return(data_json)
}
