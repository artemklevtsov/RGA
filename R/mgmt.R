# Remove some field and convert dates
fix_mgmt <- function(x) {
    x <- x[!grepl("(self|parent|child)\\.link", names(x))]
    if (!is.null(x$created))
        x$created <- lubridate::ymd_hms(x$created)
    if (!is.null(x$updated))
        x$updated <- lubridate::ymd_hms(x$updated)
    return(x)
}

# Get the Management API data
#' @include get-data.R
list_mgmt <- function(path, query, token) {
    data_ <- get_data(c("management", path), query, token)
    if (is.null(data_$items) || length(data_$items) == 0) {
        message("No results were obtained.")
        return(invisible(NULL))
    }
    res <- fix_mgmt(data_$items)
    attr(res, "username") <- data_$username
    return(res)
}

# Get the Management API data
#' @include url.R
#' @include request.R
get_mgmt <- function(path, token) {
    res <- GET_(get_url(c("management", path)), token)
    res <- fix_mgmt(res)
    return(res)
}
