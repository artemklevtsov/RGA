# API constants
api_base_url <- "https://www.googleapis.com"
api_base_path <- "analytics"
api_version <- "v3"

# Build URL for Google Analytics request
#' @include utils.R
get_url <- function(path = NULL, query = NULL) {
    path <- c(api_base_path, api_version, path)
    path <- gsub("//", "/", paste(path, collapse = "/"), fixed = TRUE)
    if (is.list(query)) {
        query <- compact(query)
        params <- names(query)
        params <- sub("profile.id", "ids", params, fixed = TRUE)
        params <- sub("sampling.level", "samplingLevel", params, fixed = TRUE)
        params <- gsub(".", "-", params, fixed = TRUE)
        names(query) <- params
    }
    url <- httr::modify_url(api_base_url, path = path, query = query)
    return(url)
}
