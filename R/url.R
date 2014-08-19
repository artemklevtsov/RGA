# Build URL path
#' @include utils.R
#'
build_path <- function(x) {
    stopifnot(inherits(x, "list"))
    x <- compact(x)
    params <- names(x)
    params <- gsub("\\.", "-", params)
    values <- as.vector(x, mode = "character")
    string <- paste(params, values, sep = "/", collapse = "/")
    string <- gsub("//", "/", string)
    return(string)
}

# Build URL query string
#' @include utils.R
#' @importFrom RCurl curlEscape
#'
build_query <- function(x) {
    stopifnot(inherits(x, "list"))
    x <- compact(x)
    params <- names(x)
    params <- gsub("\\.", "-", params)
    params <- gsub("profile-id", "ids", params)
    values <- as.vector(x, mode = "character")
    values <- curlEscape(values)
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
build_url <- function(type = c("ga", "mcf", "rt", "mgmt"), path, query) {
    type <- match.arg(type)
    base_url <- switch(type,
                       ga = "https://www.googleapis.com/analytics/v3/data/ga",
                       mcf = "https://www.googleapis.com/analytics/v3/data/mcf",
                       rt = "https://www.googleapis.com/analytics/v3/data/realtime",
                       mgmt = "https://www.googleapis.com/analytics/v3/management",
                       stop("Unknown API data type."))
    if (!missing(path)) {
        if (length(path) > 1L)
            path <- build_path(path)
        if (nzchar(path))
            url <- paste(base_url, path, sep = "/")
    }
    if (!missing(query)) {
        if (length(query) > 1L)
            query <- build_query(query)
        if (nzchar(query))
            url <- paste(base_url, query, sep = "?")
    }
    return(url)
}
