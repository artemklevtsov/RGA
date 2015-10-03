# Get the Google Analytics API data
#' @include url.R
#' @include request.R
get_data <- function(path = NULL, query = NULL, token) {
    # Set limits
    if (grepl("management", paste(path, collapse = "/"))) {
        results_limit <- 1000L
        items_name <- "items"
    } else {
        results_limit <- 10000L
        items_name <- "rows"
    }
    if (is.null(query$max.results)) {
        pagination <- TRUE
        query$max.results <- results_limit
    } else {
        pagination <- FALSE
        stopifnot(query$max.results <= results_limit)
    }
    # Make request
    url <- get_url(path, query)
    data_json <- GET_(url, token)
    if (data_json$totalResults == 0L || is.null(data_json[[items_name]]) || length(data_json[[items_name]]) == 0L)
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
                url <- get_url(path, query)
                pages[[page]] <- GET_(url, token)
            }
            pages <- pages[-1L]
            pages <- lapply(pages, .subset2, items_name)
            data_json[[items_name]] <- c(list(data_json[[items_name]]), pages)
        }
    }
    data_json[[items_name]] <- build_df(data_json)
    return(data_json)
}
