# Make a Goolge API request
get_api_request = function(url, token, messages = FALSE) {
    url <- gsub(pattern = "\\+", replacement = "%2B", url)
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
    response <- GET(url = url, config = config(token = token))
    if (messages)
        message(http_status(response)$message)
    # Convert the JSON response into a R list
    data.r <- fromJSON(content(response, as = "text"))
    if (!is.null(data.r$error$message))
        stop(paste(http_status(response)$message, ". Reason: ", data.r$error$message, "."))
    # Return the list containing Google Analytics API response
    return(data.r)
}
