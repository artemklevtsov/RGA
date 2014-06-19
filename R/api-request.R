# Make a Goolge Analytics API request
#' @import RCurl
#' @import httr
#' @import jsonlite
#'
api_request = function(url, token, simplify = TRUE, messages = FALSE) {
    stopifnot(is.character(url) && length(url) == 1L)
    if (.Platform$OS.type == "windows") {
        options(RCurlOptions = list(
            verbose = FALSE,
            capath = system.file("CurlSSL", "cacert.pem", package = "RCurl"), ssl.verifypeer = FALSE))
    }
    # Print the URL to the console
    if (messages) {
        message("Sending request to Google Analytics...")
        message(url)
    }
    if (!missing(token)) {
        stopifnot(inherits(token, "Token2.0"))
        request <- GET(url = url, config = config(token = token))
    } else {
        if (token_exists("GAToken")) {
            token <- get_token("GAToken")
            stopifnot(inherits(token, "Token2.0"))
            request <- GET(url = url, config = config(token = token))
        } else
            request <- GET(url = url)
    }
    # Send query to Google Analytics API and capture the JSON reponse
    if (messages)
        message(http_status(request)$message)
    # Convert the JSON response into a R list
    data.json <- fromJSON(content(request, as = "text"), simplifyVector = simplify)
    if (!is.null(data.json$error))
        stop(paste(http_status(request)$message, "Reason:",
                   paste(data.json$error$errors$message, collapse = "\n"), sep = "\n"))
    # Return the list containing Google Analytics API response
    return(data.json)
}
