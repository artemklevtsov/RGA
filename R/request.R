# Set the RCurlOptions for Windows
set_curl_opts <- function() {
    if (.Platform$OS.type == "windows") {
        options(RCurlOptions = list(
            verbose = FALSE,
            capath = system.file("CurlSSL", "cacert.pem", package = "RCurl"),
            ssl.verifypeer = FALSE))
    }
}

# Error printing function
#' @importFrom httr http_status
#'
error_handler <- function(x) {
    error_code <- x$error$code
    error_message <- http_status(error_code)$message
    error_tbl <- x$error$errors[, -1L]
    error_tbl$reason <- to_separated(error_tbl$reason, sep = " ")
    reasons <- paste(capture.output(print(error_tbl, right = FALSE)), collapse = "\n")
    stop(error_message, "\n", reasons, call. = FALSE)
}

#' @title Make a Goolge Analytics API request
#'
#' @param url character. The url of the request.
#' @param simplify logical. Coerce JSON arrays to a vector, matrix or data frame.
#' @param flatten logical. Automatically flatten nested data frames into a single non-nested data frame.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @keywords internal
#'
#' @noRd
#'
#' @include auth.R
#'
#' @importFrom httr GET config content verbose
#' @importFrom jsonlite fromJSON
#'
make_request = function(url, simplify = TRUE, flatten = TRUE, token, verbose = getOption("rga.verbose")) {
    stopifnot(is.character(url) && length(url) == 1L)
    set_curl_opts()
    if (verbose) {
        message("Sending request to the Google Analytics API...")
        message(paste("Query URL:", url))
    }
    if (missing(token) && token_exists(getOption("rga.token"))) {
        token <- get_token(getOption("rga.token"))
        if (verbose)
            message(paste0("Use OAuth Token stored in RGA:::TokenEnv$", getOption("rga.token"), "."))
    } else {
        if (verbose)
            message(paste("Use OAuth Token passed in", substitute(token), "variable."))
    }
    stopifnot(inherits(token, "Token2.0"))
    if (verbose)
        request <- GET(url, config(token = token), verbose(data_out = verbose))
    else
        request <- GET(url, config(token = token))
    data_json <- fromJSON(content(request, as = "text"), simplifyVector = simplify, flatten = flatten)
    if (!is.null(data_json$error))
        error_handler(data_json)
    return(data_json)
}

#' @title Get a Google Analytics API response
#'
#' @param type character string including report type.
#' @param path list including a request parameters.
#' @param query list including a request parameters.
#' @param simplify logical. Coerce JSON arrays to a vector, matrix or data frame.
#' @param flatten logical. Automatically flatten nested data frames into a single non-nested data frame.
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
get_response <- function(type = c("ga", "rt", "mcf", "mgmt"), path = NULL, query = NULL, simplify = TRUE, flatten = TRUE, token, verbose = getOption("rga.verbose")) {
    type <- match.arg(type)
    url <- build_url(type = type, path = path, query = query)
    data_json <- make_request(url, simplify = simplify, flatten = flatten, token = token, verbose = verbose)
    return(data_json)
}
