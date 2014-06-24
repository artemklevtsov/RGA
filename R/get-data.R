#' @title Get a Google Analytics API response
#'
#' @param path list including a request parameters.
#' @param query list including a request parameters.
#' @param type character string including report type.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param messages logical. Should print information messages?
#'
#' @return A list contatin Google Analytics API response.
#'
#' @noRd
#'
#' @include build-url.R
#' @include api-request.R

get_data <- function(type, query, path, token, messages = FALSE) {
    url <- build_url(type = type, path = path, query = query)
    data.json <- api_request(url, token = token, messages = messages)
    return(data.json)
}
