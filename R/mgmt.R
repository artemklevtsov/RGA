# Get the Management API data
#' @include get-data.R
list_mgmt <- function(path, query, token) {
    data_json <- get_data(type = "mgmt", path = path, query = query, token = token)
    if (is.null(data_json)) {
        message("No results were obtained.")
        return(invisible(NULL))
    }
    data_df <- data_json$items
    data_df$created <- as.POSIXct(strptime(data_df$created, format = "%Y-%m-%dT%H:%M:%OS", tz = "GMT"))
    data_df$updated <- as.POSIXct(strptime(data_df$updated, format = "%Y-%m-%dT%H:%M:%OS", tz = "GMT"))
    attr(data_df, "username") <- data_json$username
    return(data_df)
}

# Get the Management API data
#' @include url.R
#' @include request.R
#' @include convert.R
#' @include utils.R
get_mgmt <- function(path, token) {
    url <- get_url(c("management", path))
    data_list <- GET_(url, token)
    data_list <- ls_mgmt(data_list)
    data_list <- convert_datatypes(data_list)
    data_list$created <- as.POSIXct(strptime(data_list$created, format = "%Y-%m-%dT%H:%M:%OS", tz = "GMT"))
    data_list$updated <- as.POSIXct(strptime(data_list$updated, format = "%Y-%m-%dT%H:%M:%OS", tz = "GMT"))
    return(data_list)
}
