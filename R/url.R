base_api_url <- "https://www.googleapis.com/analytics"
base_api_version <- "v3"

# Build URL for Google Analytics request
get_url <- function(type = c("ga", "mcf", "rt", "mgmt"), path = NULL) {
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
    return(url)
}
