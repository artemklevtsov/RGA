# Make a Goolge API request
#' @import RCurl
#' @import httr
#' @import jsonlite
get_api_request = function(url, token, messages = FALSE) {
    stopifnot(is.character(url) && length(url) == 1L)
    url <- gsub(pattern = "\\+", replacement = "%2B", url)
    if (!missing(token)) {
        stopifnot(inherits(token, "Token2.0"))
        request <- GET(url = url, config = config(token = token))
    } else {
        request <- GET(url = url)
    }
    # Print the URL to the console
    if (messages) {
        message("Sending request to Google Analytics...")
        message(url)
    }
    if (.Platform$OS.type == "windows") {
        options(RCurlOptions = list(
            verbose = FALSE,
            capath = system.file("CurlSSL", "cacert.pem",
                                 package = "RCurl"), ssl.verifypeer = FALSE))
    }
    # Send query to Google Analytics API and capture the JSON reponse
    if (messages)
        message(http_status(request)$message)
    # Convert the JSON response into a R list
    data.json <- fromJSON(content(request, as = "text"))
    if (!is.null(data.json$error$message))
        stop(paste0(http_status(request)$message, ". Reason: ", data.json$error$message, "."))
    # Return the list containing Google Analytics API response
    return(data.json)
}
