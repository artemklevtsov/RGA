# Error printing function
#' @include utils.R
stopreasons <- function(x) {
    code <- x$error$code
    message <- httr::http_status(code)$message
    reasons <- x$error$errors[, -1L]
    reasons$reason <- to_separated(reasons$reason, sep = " ")
    reasons <- paste(utils::capture.output(print(reasons, right = FALSE)), collapse = "\n")
    message <- c(message, "\n", reasons)
    stop(message, call. = FALSE)
}

# Process response
process <- function(x) {
    if (x$status_code == 404L) {
        url <- strsplit(x$url, split = "?", fixed = TRUE)[[1]][1]
        stop(sprintf("The requested URL not found. URL: %s.", url), call. = FALSE)
    }
    res <- jsonlite::fromJSON(httr::content(x, as = "text"), flatten = TRUE)
    if (!is.null(res$error))
        stopreasons(res)
    return(res)
}

# Get a Google Analytics API response
#' @include auth.R
GET_ <- function(url, token) {
    if (missing(token) && !token_exists("GAToken")) {
        authorize(cache = FALSE)
        return(eval(match.call()))
    }
    if (missing(token) && token_exists("GAToken"))
        token <- get_token("GAToken")
    if (validate_token(token))
        config <- httr::config(token = token)
    res <- httr::GET(url, config = config, httr::accept_json())
    res <- process(res)
    return(res)
}
