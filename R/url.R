# Build URL path
#' @include utils.R
#'
build_path <- function(x) {
    params <- names(x)
    values <- as.character(x)
    string <- paste(params, values, sep = "/", collapse = "/")
    string <- sub("^/", "", string)
    string <- gsub("//", "/", string, fixed = TRUE)
    return(string)
}

# Build URL query string
#' @importFrom RCurl curlEscape
#' @include utils.R
#'
build_query <- function(x) {
    x <- compact(x)
    params <- names(x)
    values <- as.character(x)
    values <- enc2utf8(values)
    values <- curlEscape(values)
    string <- paste(params, values, sep = "=", collapse = "&")
    return(string)
}

base_api_url <- "https://www.googleapis.com/analytics"
base_api_version <- "v3"

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
    type <- switch(type,
                  ga = "data/ga",
                  mcf = "data/mcf",
                  rt = "data/realtime",
                  mgmt = "management")
    url <- paste(base_api_url, base_api_version, type, sep = "/")
    if (!is.null(path)) {
        if (length(path) > 1)
            path <- build_path(path)
        url <- paste(url, path, sep = "/")
    }
    if (!is.null(query)) {
        if (length(query) > 1)
            query <- build_query(query)
        url <- paste(url, query, sep = "?")
    }
    return(url)
}
