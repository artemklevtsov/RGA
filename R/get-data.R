# Get the Google Analytics API data
#' @include url.R
#' @include request.R
#' @include convert.R
get_data <- function(path = NULL, query = NULL, token) {
    # Set limits
    if (grepl("management", paste(path, collapse = "/"))) {
        limit <- 1000L
        items <- "items"
    } else {
        limit <- 10000L
        items <- "rows"
    }
    if (is.null(query$max.results)) {
        pagination <- TRUE
        query$max.results <- limit
    } else {
        pagination <- FALSE
        if (query$max.results > limit)
            stop(sprintf("Can't retry more than %d results for this API. Set max.results = NULL (default value) to get all results.", limit), call. = FALSE)
    }
    # Make request
    res <- GET_(get_url(path, query), token)
    if (res$total.results == 0L || is.null(res[[items]]) || length(res[[items]]) == 0L)
        return(NULL)
    if (!isTRUE(pagination) && query$max.results < res$total.results)
        warning(sprintf("Only %d observations out of %d were obtained. Set max.results = NULL (default value) to get all results.", query$max.results, res$total.results), call. = FALSE)
    # Pagination
    if (isTRUE(pagination) && query$max.results < res$total.results) {
        if (grepl("data/realtime", paste(path, collapse = "/")))
            warning(sprintf("Only %d observations out of %d were obtained (the batch processing mode is not implemented for this report type).", query$max.results, res$total.results), call. = FALSE)
        else {
            message(sprintf("API response contains more then %d items. Batch processing mode enabled.", query$max.results))
            total.pages <- ceiling(res$total.results / query$max.results)
            pages <- vector(mode = "list", length = total.pages)
            pb <- txtProgressBar(min = 0, max = total.pages, initial = 1, style = 3)
            for (i in 2L:total.pages) {
                query$start.index <- query$max.results * (i - 1L) + 1L
                pages[[i]] <- GET_(get_url(path, query), token)[[items]]
                setTxtProgressBar(pb, i)
            }
            pages[[1L]] <- res[[items]]
            if (is.matrix(pages[[1L]]) || is.data.frame(pages[[1L]]))
                pages <- do.call(rbind, pages)
            else if (is.list(pages[[1L]]))
                pages <- do.call(c, pages)
            res[[items]] <- pages
            close(pb)
        }
    }
    res[[items]] <- build_df(res)
    return(res)
}
