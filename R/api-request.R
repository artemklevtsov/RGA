# Make a Goolge API request
#' @import RCurl
#' @import httr
#' @import jsonlite
get_api_request = function(url, token, messages = FALSE) {
    stopifnot(is.character(url) && length(url) == 1L)
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
    if (!is.null(data.json$error)) {
        error.msg <- paste(c(http_status(request)$message, data.json$error$errors$message), collapse = "\n")
        stop(error.msg)
    }
    # Return the list containing Google Analytics API response
    return(data.json)
}
