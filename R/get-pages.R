#' @title Get Gogole Analytics report data in batch mode
#'
#' @param total.results total number of rows in the query result
#' @param type character string including report type.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param messages logical. Should print information messages?
#'
#' @return List or matrix.
#'
#' @noRd
#'
#' @include get-data.R
#'
get_pages <- function(total.results, type, query, token, messages = FALSE) {
    stopifnot(total.results, is.integer)
    type <- match.arg(type)
    total.pages <- ceiling(data.json$totalResults / query$max.results)
    if (messages)
        message("Response contain more then 10000 rows.")
    rows <- NULL
    for (page in 1:total.pages) {
        if (messages)
            message(paste0("Fetching page ", page, " of ", total.pages, "..."))
        query$start.index <- query$max.results * (page - 1) + 1
        data.json <- get_data(type = type, query = query, token = token, messages = messages)
        if (inherits(data.json$rows, "matrix") || inherits(data.json$rows, "data.frame"))
            rows <- rbind(rows, data.json$rows)
        else if (inherits(data.json$rows, "list"))
            rows <- c(rows, data.json$rows)
    }
    return(rows)
}
