# Get the Management API data
#' @include get-data.R
list_mgmt <- function(path, query, token) {
    data_ <- get_data(c("management", path), query, token)
    if (is.null(data_$items) || length(data_$items) == 0) {
        message("No results were obtained.")
        return(invisible(NULL))
    }
    res <- data_$items
    if (!is.null(res$created))
        res$created <- lubridate::ymd_hms(res$created)
    if (!is.null(res$updated))
        res$updated <- lubridate::ymd_hms(res$updated)
    attr(res, "username") <- data_$username
    return(res)
}

# Get the Management API data
#' @include url.R
#' @include request.R
get_mgmt <- function(path, token) {
    res <- GET_(get_url(c("management", path)), token)
    res <- res[!names(res) %in% c("selfLink", "parentLink", "childLink")]
    if (!is.null(res$permissions))
        res$permissions <- unlist(res$permissions, use.names = FALSE)
    if (!is.null(res$created))
        res$created <- lubridate::ymd_hms(res$created)
    if (!is.null(res$updated))
        res$updated <- lubridate::ymd_hms(res$updated)
    return(res)
}
