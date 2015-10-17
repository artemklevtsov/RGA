# Error printing function
#' @include utils.R
stop_reasons <- function(x) {
    message <- httr::http_status(x$error$code)$message
    reasons <- x$error$errors
    reasons$reason <- capitalize(to_separated(reasons$reason, sep = " "))
    reasons$message <- gsub("\n", ". ", reasons$message, fixed = TRUE)
    if (!is.null(reasons$location)) {
        reasons$location <- sub("ids", "profile.id", reasons$location, fixed = TRUE)
        reasons$location <- sub("samplingLevel", "sampling.level", reasons$location, fixed = TRUE)
        reasons$location <- gsub("-", ".", reasons$location, fixed = TRUE)
        reasons <- paste(sprintf("%s '%s': %s", reasons$reason, reasons$location, reasons$message), collapse = "\n")
    } else
        reasons <- paste(sprintf("%s: %s", reasons$reason, reasons$message), collapse = "\n")
    stop(paste(message, reasons, sep = "\n"), call. = FALSE)
}

# Process response
#' @include utils.R
process <- function(x) {
    if (x$status_code == 404L) {
        url <- strsplit(x$url, split = "?", fixed = TRUE)[[1]][1]
        stop(sprintf("The requested URL not found. URL: %s.", url), call. = FALSE)
    }
    res <- jsonlite::fromJSON(httr::content(x, as = "text"), flatten = TRUE)
    if (!is.null(res$error))
        stop_reasons(res)
    res <- convert_datatypes(res)
    return(res)
}

# Get a Google Analytics API response
#' @include auth.R
GET_ <- function(url, token) {
    if (missing(token) && is.null(get_token()))
        GET_(url, token = authorize(cache = FALSE))
    if (missing(token) && !is.null(get_token()))
        token <- get_token()
    if (validate_token(token))
        config <- httr::config(token = token)
    res <- httr::GET(url, config = config, httr::accept_json())
    res <- process(res)
    return(res)
}
