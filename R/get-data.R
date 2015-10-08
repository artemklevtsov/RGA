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
    data_json <- GET_(get_url(path, query), token)
    if (data_json$totalResults == 0L || is.null(data_json[[items]]) || length(data_json[[items]]) == 0L)
        return(NULL)
    if (!isTRUE(pagination) && query$max.results < data_json$totalResults)
        warning(sprintf("Only %d observations out of %d were obtained. Set max.results = NULL (default value) to get all results.", query$max.results, data_json$totalResults), call. = FALSE)
    # Pagination
    if (isTRUE(pagination) && query$max.results < data_json$totalResults) {
        if (grepl("data/realtime", paste(path, collapse = "/")))
            warning(sprintf("Only %d observations out of %d were obtained (the batch processing mode is not implemented for this report type).", query$max.results, data_json$totalResults), call. = FALSE)
        else {
            message(sprintf("Response contain more then %d rows. Batch processing mode enabled.", query$max.results))
            total.pages <- ceiling(data_json$totalResults / query$max.results)
            pages <- vector(mode = "list", length = total.pages)
            for (page in 2L:total.pages) {
                message(sprintf("Fetching page %d of %d...", page, total.pages))
                query$start.index <- query$max.results * (page - 1L) + 1L
                pages[[page]] <- GET_(get_url(path, query), token)[[items]]
            }
            data_json[[items]] <- c(list(data_json[[items]]), pages[-1L])
        }
    }
    data_json[[items]] <- build_df(data_json)
    return(data_json)
}
