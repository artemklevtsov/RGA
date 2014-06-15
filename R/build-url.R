# Build URL path
#' @include utils.R
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
#' @import RCurl
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

# Build URL
build_url <- function(type = c("ga", "mcf", "mgmt"), path, query) {
    type <- match.arg(type)
    url <- switch(type,
                  ga = "https://www.googleapis.com/analytics/v3/data/ga",
                  mcf = "https://www.googleapis.com/analytics/v3/data/mcf",
                  mgmt = "https://www.googleapis.com/analytics/v3/management",
                  stop("Unknown report type."))
    if (!missing(path)) {
        if (length(path) > 1L)
            path <- build_path(path)
        if(nzchar(path))
            url <- paste(url, path, sep = "/")
    }
    if (!missing(query)) {
        if (length(query) > 1L)
            query <- build_query(query)
        if(nzchar(query))
            url <- paste(url, query, sep = "?")
    }
    return(url)
}
