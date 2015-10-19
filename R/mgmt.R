# Get the Management API data
#' @include get-data.R
list_mgmt <- function(path, query, token) {
    if (!is.null(query$fields))
        query$fields <- paste("kind", "totalResults", "username", query$fields, sep = ",")
    data_ <- get_data(c("management", path), query, token)
    if (is.null(data_$items) || length(data_$items) == 0) {
        message("No results were obtained.")
        return(invisible(NULL))
    }
    res <- data_$items
    if (!is.null(res$created))
        res$created <- as.POSIXct(strptime(res$created, format = "%Y-%m-%dT%H:%M:%OS", tz = "GMT"))
    if (!is.null(res$updated))
        res$updated <- as.POSIXct(strptime(res$updated, format = "%Y-%m-%dT%H:%M:%OS", tz = "GMT"))
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
        res$created <- as.POSIXct(strptime(res$created, format = "%Y-%m-%dT%H:%M:%OS", tz = "GMT"))
    if (!is.null(res$updated))
        res$updated <- as.POSIXct(strptime(res$updated, format = "%Y-%m-%dT%H:%M:%OS", tz = "GMT"))
    return(res)
}
