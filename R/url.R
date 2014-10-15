# Build URL path
#' @include utils.R
#'
build_path <- function(x) {
    x <- compact(x)
    params <- names(x)
    params <- gsub("\\.", "-", params)
    values <- as.vector(x, mode = "character")
    string <- paste(params, values, sep = "/", collapse = "/")
    string <- sub("^/", "", string)
    string <- gsub("//", "/", string)
    return(string)
}

# Build URL query string
#' @include utils.R
#'
build_query <- function(x) {
    x <- compact(x)
    params <- names(x)
    params <- gsub("\\.", "-", params)
    params <- gsub("profile-id", "ids", params)
    values <- as.vector(x, mode = "character")
    string <- paste(params, values, sep = "=", collapse = "&")
    return(string)
}

#' @title Build URL for Google Analytics request
#'
#' @param type type of Google Analytics API data.
#' @param path URL path. May be list or character.
#' @param query URL query string. May be list or character.
#'
#' @return Character string.
#'
#' @keywords internal
#'
#' @noRd
#'
build_url <- function(type = c("ga", "mcf", "rt", "mgmt"), path = NULL, query = NULL) {
    type <- match.arg(type)
    url <- switch(type,
                       ga = "https://www.googleapis.com/analytics/v3/data/ga",
                       mcf = "https://www.googleapis.com/analytics/v3/data/mcf",
                       rt = "https://www.googleapis.com/analytics/v3/data/realtime",
                       mgmt = "https://www.googleapis.com/analytics/v3/management",
                       stop("Unknown API data type."))
    if (!is.null(path)) {
        path <- build_path(path)
        url <- paste(url, path, sep = "/")
    }
    if (!is.null(query)) {
        query <- build_query(query)
        url <- paste(url, query, sep = "?")
    }
    return(url)
}
