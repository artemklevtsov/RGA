# Get the Management API data
#' @include get-data.R
list_mgmt <- function(path, query, token) {
    if (!is.null(query$fields))
        query$fields <- paste("kind", "totalResults", "username", query$fields, sep = ",")
    data_json <- get_data(c("management", path), query, token)
    if (is.null(data_json)) {
        message("No results were obtained.")
        return(invisible(NULL))
    }
    data_df <- data_json$items
    if (!is.null(data_df$created))
        data_df$created <- as.POSIXct(strptime(data_df$created, format = "%Y-%m-%dT%H:%M:%OS", tz = "GMT"))
    if (!is.null(data_df$updated))
        data_df$updated <- as.POSIXct(strptime(data_df$updated, format = "%Y-%m-%dT%H:%M:%OS", tz = "GMT"))
    attr(data_df, "username") <- data_json$username
    return(data_df)
}

# Get the Management API data
#' @include url.R
#' @include request.R
#' @include utils.R
get_mgmt <- function(path, token) {
    data_list <- GET_(get_url(c("management", path)), token)
    data_list <- data_list[!names(data_list) %in% c("selfLink", "parentLink", "childLink")]
    if (!is.null(data_list$permissions))
        data_list$permissions <- unlist(data_list$permissions, use.names = FALSE)
    names(data_list) <-  to_separated(names(data_list), sep = ".")
    torename <- vapply(data_list, is.list, logical(1))
    data_list[torename] <- lapply(data_list[torename], function(x) stats::setNames(x, to_separated(names(x), sep = ".")))
    data_list <- convert_datatypes(data_list)
    if (!is.null(data_list$created))
        data_list$created <- as.POSIXct(strptime(data_list$created, format = "%Y-%m-%dT%H:%M:%OS", tz = "GMT"))
    if (!is.null(data_list$updated))
        data_list$updated <- as.POSIXct(strptime(data_list$updated, format = "%Y-%m-%dT%H:%M:%OS", tz = "GMT"))
    return(data_list)
}
