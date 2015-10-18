# Error printing function
#' @include utils.R
format_reasons <- function(x) {
    message <- httr::http_status(x$error$code)$message
    reasons <- x$error$errors
    reasons$reason <- capitalize(to_separated(reasons$reason, sep = " "))
    reasons$message <- gsub("\n", ". ", reasons$message, fixed = TRUE)
    if (!is.null(reasons$location)) {
        reasons$location <- sub("ids", "profile.id", reasons$location, fixed = TRUE)
        reasons$location <- sub("samplingLevel", "sampling.level", reasons$location, fixed = TRUE)
        reasons$location <- gsub("-", ".", reasons$location, fixed = TRUE)
        reasons <- sprintf("%s '%s': %s", reasons$reason, reasons$location, reasons$message)
    } else
        reasons <- sprintf("%s: %s", reasons$reason, reasons$message)
    reasons <- paste(reasons, collapse = "\n")
    paste(message, reasons, sep = "\n")
}

# Wrapper to request data with exponential backoff
#' @include env.R
exp_backoff <- function(x) {
    stopifnot(inherits(x, "response"))
    if (.RGAEnv$Attempt <= 5L) {
        if (.RGAEnv$Attempt == 1L)
            message("There has been an error. Trying to request data with exponential backoff.")
        Sys.sleep(.RGAEnv$Attempt * 2L + runif(1L))
        .RGAEnv$Attempt <- .RGAEnv$Attempt + 1L
        GET_(x$url, x$request$auth_token)
    } else {
        .RGAEnv$Attempt <- 0L # reset attempts
        stop("There has been an error, the request never succeeded.", call. = FALSE)
    }
}

# Process response
#' @include utils.R
process <- function(x) {
    stopifnot(inherits(x, "response"))
    if (x$status_code == 404L) {
        url <- strsplit(x$url, split = "?", fixed = TRUE)[[1L]][1L]
        stop(sprintf("The requested URL not found. URL: %s.", url), call. = FALSE)
    }
    res <- jsonlite::fromJSON(httr::content(x, as = "text"), flatten = TRUE)
    if (!is.null(res$error)) {
        if (res$error$errors$reason == "userRateLimitExceeded" || res$error$errors$reason == "quotaExceeded")
            exp_backoff(x)
        else
            stop(format_reasons(res), call. = FALSE)
    }
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
