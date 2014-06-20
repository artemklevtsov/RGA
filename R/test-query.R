#' @title Checking Google Analytics report query
#'
#' @param type character string including report type. "ga" for core report, "mcf" for multi-channel funnels report.
#' @param query \code{GAQuery} class object including a request parameters.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param results logical. Return the results or logical?
#' @param messages logical. Should print information messages?
#'
#' @examples
#' \dontrun{
#' query <- set_query("ga:00000000")
#' test_qeury(query)
#' }
#'
#' @include build-url.R
#' @include api-request.R
#'

test_query <- function(type = c("ga", "mcf"), query, token, results = FALSE, messages = FALSE) {
    type <- match.arg(type)
    query$max.results <- 1L
    url <- build_url(type = type, query = query)
    data.json <- api_request(url = url, token = token, messages = messages)
    if (results)
        return(data.json)
    else
        return(TRUE)
}
