#' @title Checking Google Analytics report query
#'
#' @param type character string including report type.
#' @param query \code{GAQuery} class object including a request parameters.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @noRd
#'
#' @include get-data.R
#'
test_query <- function(type, query, token, verbose = FALSE) {
    if (verbose)
        message("Check query...")
    query$max.results <- 1L
    data.json <- get_data(type = type, query = query, token = token, verbose = verbose)
    return(data.json)
}
