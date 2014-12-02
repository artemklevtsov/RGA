# Pagination the Google Analytics API requests
#' @include request.R
#'
get_pages <- function(type = c("ga", "mcf", "mgmt"), path = NULL, query = NULL, total.results, token, verbose = getOption("rga.verbose", FALSE)) {
    if (verbose)
        message(paste("Response contain more then", query$max.results, "rows. Batch processing mode enabled."))
    type <- match.arg(type)
    total.pages <- ceiling(total.results / query$max.results)
    res <- vector(mode = "list", length = total.pages)
    for (page in 2:total.pages) {
        if (verbose)
            message(paste0("Fetching page ", page, " of ", total.pages, "..."))
        query$start.index <- query$max.results * (page - 1) + 1
        res[[page]] <- get_response(type = type, path = path, query = query, token = token, verbose = verbose)
    }
    return(res[-1])
}
