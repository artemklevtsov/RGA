# Pagination the Google Analytics API requests
#' @include request.R
get_pages <- function(type = c("ga", "mcf", "mgmt"), path = NULL, query = NULL, total.results, token) {
    stopifnot(is.integer(total.results))
    message(paste("Response contain more then", query$max.results, "rows. Batch processing mode enabled."))
    type <- match.arg(type)
    total.pages <- ceiling(total.results / query$max.results)
    res <- vector(mode = "list", length = total.pages)
    for (page in 2L:total.pages) {
        message(paste0("Fetching page ", page, " of ", total.pages, "..."))
        query$start.index <- query$max.results * (page - 1L) + 1L
        res[[page]] <- get_response(type = type, path = path, query = query, token = token)
    }
    return(res[-1L])
}
