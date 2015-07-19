# Error printing function
#' @include utils.R
#' @importFrom httr http_status
error_message <- function(x) {
    code <- x$error$code
    message <- http_status(code)$message
    reasons <- x$error$errors[, -1L]
    reasons$reason <- to_separated(reasons$reason, sep = " ")
    reasons <- paste(capture.output(print(reasons, right = FALSE)), collapse = "\n")
    stop(message, "\n", reasons, call. = FALSE)
}

#' @title Get a Google Analytics API response
#'
#' @param type character string including report type.
#' @param path list including a request parameters.
#' @param query list including a request parameters.
#' @param simplify logical. Coerce JSON arrays to a vector, matrix or data frame.
#' @param flatten logical. Automatically flatten nested data frames into a single non-nested data frame.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return A list contatin Google Analytics API response.
#'
#' @keywords internal
#'
#' @noRd
#'
#' @include auth.R
#' @include url.R
#'
#' @importFrom httr GET config accept_json content
#' @importFrom jsonlite fromJSON
#'
get_response <- function(type = c("ga", "rt", "mcf", "mgmt"), path = NULL, query = NULL,
                         simplify = TRUE, flatten = TRUE, token) {
    type <- match.arg(type)
    url <- get_url(type = type, path = path, query = query)
    if (missing(token) && token_exists(getOption("rga.token")))
        token <- get_token(getOption("rga.token"))
    if (!missing(token)) {
        stopifnot(inherits(token, "Token2.0"))
        config <- config(token = token)
    } else
        config <- NULL
    resp <- GET(url, accept_json(), config)
    data_json <- fromJSON(content(resp, as = "text"), simplifyVector = simplify, flatten = flatten)
    if (!is.null(data_json$error))
        error_message(data_json)
    return(data_json)
}
