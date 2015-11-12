# Error printing function
#' @include utils.R
error_reasons <- function(x) {
    message <- httr::http_status(x$error$code)$message
    reasons <- x$error$errors
    reasons$reason <- capitalize(to_separated(reasons$reason, sep = " "))
    reasons$message <- gsub("\n", ". ", reasons$message, fixed = TRUE)
    if (!is.null(reasons$location)) {
        reasons$location <- gsub("ids", "profile.id", reasons$location, fixed = TRUE)
        reasons$location <- gsub("-", ".", reasons$location, fixed = TRUE)
        reasons <- sprintf("%s '%s': %s", reasons$reason, to_separated(reasons$location), reasons$message)
    } else
        reasons <- sprintf("%s: %s", reasons$reason, reasons$message)
    reasons <- paste(reasons, collapse = "\n")
    paste(message, reasons, sep = "\n")
}

# Process response
#' @include utils.R
process_response <- function(response) {
    stopifnot(inherits(response, "response"))
    res <- jsonlite::fromJSON(httr::content(response, as = "text"), flatten = TRUE)
    if (response$status_code == 404L)
        stop(sprintf("The requested URL not found. URL: %s.", strsplit(url, "?", fixed = TRUE)[[1L]][1L]), call. = FALSE)
    if (!is.null(res$error))
        stop(error_reasons(res), call. = FALSE)
    res <- convert_types.list(res)
    res <- convert_names(res)
    idx <- sapply(res, is.list)[!grepl("^(rows|items)$", names(res))]
    res[idx] <- lapply(res[idx], convert_types.list)
    res[idx] <- lapply(res[idx], convert_names)
    return(res)
}

# Get a Google Analytics API response
#' @include auth.R
api_request <- function(url, token) {
    if (missing(token) && is.null(get_token()))
        api_request(url, token = authorize(cache = FALSE))
    if (missing(token) && !is.null(get_token()))
        token <- get_token()
    if (validate_token(token))
        config <- httr::config(token = token)
    for (i in 0L:6L) {
        response <- httr::GET(url, config = config, httr::accept_json())
        res <- try(process_response(response), silent = TRUE)
        if (!inherits(res, "try-error"))
            break
        else if (grepl("User rate limit exceeded|Quota exceeded", res) & i < 6L)
            Sys.sleep(2L^i + stats::runif(1L))
        else
            stop(res, call. = FALSE)
    }
    return(res)
}
