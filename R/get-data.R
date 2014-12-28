# Get the Google Analytics API data
#' @include request.R
#' @include get-pages.R
#'
get_data <- function(type = c("ga", "rt", "mcf", "mgmt"), path = NULL, query = NULL, token) {
    type <- match.arg(type)
    if (type == "mgmt") {
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
    if (is.null(query$fields))
        query$fields <- paste("totalResults", items_name, sep = ",")
    else
        query$fields <- paste("totalResults", query$fields, sep = ",")
    data_json <- get_response(type = type, path = path, query = query, token = token)
    if (!isTRUE(pagination) && query$max.results < data_json$totalResults)
        warning(paste("Only", query$max.results, "observations out of", data_json$totalResults, "were obtained. Set max.results = NULL (default value) to get all results."), call. = FALSE)
    if (isTRUE(pagination) && query$max.results < data_json$totalResults) {
        if (type == "rt")
            warning(paste("Only", query$max.results, "observations out of", data_json$totalResults, "were obtained (the batch processing mode is not implemented for this report type)."), call. = FALSE)
        else {
            pages <- get_pages(type = type, path = path, query = query, total.results = data_json$totalResults)
            pages <- lapply(pages, `[[`, items_name)
            data_json[[items_name]] <- c(list(data_json[[items_name]]), pages)
        }
    }
    return(data_json)
}
