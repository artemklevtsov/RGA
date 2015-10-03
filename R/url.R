base_api_url <- "https://www.googleapis.com"
base_api_path <- "analytics"
base_api_version <- "v3"

# Build URL for Google Analytics request
#' @include utils.R
get_url <- function(path = NULL, query = NULL) {
    path <- c(base_api_path, base_api_version, path)
    path <- paste(path, collapse = "/")
    if (is.list(query)) {
        query <- compact(query)
        params <- names(query)
        params <- sub("profile.id", "ids", params, fixed = TRUE)
        params <- sub("sampling.level", "samplingLevel", params, fixed = TRUE)
        params <- gsub(".", "-", params, fixed = TRUE)
        names(query) <- params
    }
    url <- httr::modify_url(base_api_url, path = path, query = query)
    return(url)
}
