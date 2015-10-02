# Error printing function
#' @include utils.R
error_message <- function(x) {
    code <- x$error$code
    message <- httr::http_status(code)$message
    reasons <- x$error$errors[, -1L]
    reasons$reason <- to_separated(reasons$reason, sep = " ")
    reasons <- paste(utils::capture.output(print(reasons, right = FALSE)), collapse = "\n")
    message <- c(message, "\n", reasons)
    stop(message, call. = FALSE)
}

# Get a Google Analytics API response
#' @include auth.R
get_response <- function(url, token) {
    if (missing(token) && token_exists("GAToken"))
        token <- get_token("GAToken")
    if (validate_token(token))
        config <- httr::config(token = token)
    else
        config <- NULL
    resp <- httr::GET(url, config = config, httr::accept_json())
    if (resp$status_code == 401L) {
        authorize(cache = FALSE)
        return(eval(match.call()))
    } else if (resp$status_code == 404L) {
        u <- strsplit(resp$url, split = "?", fixed = TRUE)[[1]][1]
        stop(sprintf("The requested URL not found. URL: %s.", u), call. = FALSE)
    }
    data_json <- jsonlite::fromJSON(httr::content(resp, as = "text"), flatten = TRUE)
    if (!is.null(data_json$error))
        error_message(data_json)
    return(data_json)
}
