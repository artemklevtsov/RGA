base_api_url <- "https://www.googleapis.com/analytics"
base_api_version <- "v3"

# Build URL for Google Analytics request
#' @importFrom curl curl_escape
#' @include utils.R
get_url <- function(type = c("ga", "mcf", "rt", "mgmt"), path = NULL, query = NULL) {
    type <- match.arg(type)
    type <- switch(type,
                  ga = "data/ga",
                  mcf = "data/mcf",
                  rt = "data/realtime",
                  mgmt = "management")
    url <- paste(base_api_url, base_api_version, type, sep = "/")
    if (!is.null(path)) {
        path <- gsub("\\s", "", path)
        url <- paste(url, path, sep = "/")
    }
    if (!is.null(query)) {
        if (is.list(query)) {
            query <- compact(query)
            params <- names(query)
            params <- sub("profile.id", "ids", params, fixed = TRUE)
            params <- sub("sampling.level", "samplingLevel", params, fixed = TRUE)
            params <- gsub(".", "-", params, fixed = TRUE)
            values <- as.character(query)
            values <- enc2utf8(values)
            values <- curl_escape(values)
            query <- paste(params, values, sep = "=", collapse = "&")
        }
        url <- paste(url, query, sep = "?")
    }
    return(url)
}
