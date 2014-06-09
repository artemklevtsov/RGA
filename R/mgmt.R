#' @title Lists all accounts to which the user has access
#'
#' @param token \code{Token2.0} class object.
#' @param start.index an index of the first account to retrieve.
#' @param max.results the maximum number of accounts to include in this response.
#'
#' @return A data frame with Google Analytics management data.
#'
#' @seealso \code{\link{get_token}}
#'
#' @family Management API
#'
#' @include api-request.R
#'
#' @export
#'
get_accounts = function(token, start.index = 1L, max.results = 1000L) {
    url <- "https://www.googleapis.com/analytics/v3/management/accounts"
    query <- paste0("start-index=", start.index, "&max-results=", max.results)
    url <- paste(url, query, sep = "?")
    data.json <- get_api_request(url = url, token = token)
    cols <- c("id", "name", "created", "updated")
    if (data.json$totalResults > 0 && !is.null(data.json[["items"]])) {
        data.r <- data.json$items
        data.r <- data.r[, cols]
    }
    else {
        data.r <- data.frame(matrix(NA, nrow = 1L, ncol = length(cols)))
        colnames(data.r) <- cols
    }
    return(data.r)
}

#' @title Lists web properties to which the user has access
#'
#' @param token \code{Token2.0} class object.
#' @param account.id account ID to retrieve web properties for. Can either be a specific account ID or "~all", which refers to all the accounts that user has access to.
#' @param start.index an index of the first account to retrieve.
#' @param max.results the maximum number of accounts to include in this response.
#'
#' @return A data frame with Google Analytics management data.
#'
#' @seealso \code{\link{get_token}}
#'
#' @family Management API
#'
#' @include api-request.R
#'
#' @export
#'
get_webproperties = function(token, account.id = "~all", start.index = 1L, max.results = 1000L) {
    url <- paste("https://www.googleapis.com/analytics/v3/management/accounts",
                 account.id, "webproperties", sep = "/")
    query <- paste0("start-index=", start.index, "&max-results=", max.results)
    url <- paste(url, query, sep = "?")
    data.json <- get_api_request(url = url, token = token)
    cols <- c("id", "name", "websiteUrl", "level", "industryVertical", "created", "updated")
    if (data.json$totalResults > 0 && !is.null(data.json[["items"]])) {
        data.r <- data.json$items
        data.r <- data.r[, cols]
    }
    else {
        data.r <- data.frame(matrix(NA, nrow = 1L, ncol = length(cols)))
        colnames(data.r) <- cols
    }
    return(data.r)
}

#' @title Lists views (profiles) to which the user has access
#'
#' @param token \code{Token2.0} class object.
#' @param account.id account ID for the view (profiles) to retrieve. Can either be a specific account ID or "~all", which refers to all the accounts to which the user has access.
#' @param webproperty.id web property ID for the views (profiles) to retrieve. Can either be a specific web property ID or "~all", which refers to all the web properties to which the user has access.
#' @param start.index an index of the first account to retrieve.
#' @param max.results the maximum number of accounts to include in this response.
#'
#' @return A data frame with Google Analytics management data.
#'
#' @seealso \code{\link{get_token}}
#'
#' @family Management API
#'
#' @include api-request.R
#'
#' @export
#'
get_profiles = function(token, account.id = "~all", webproperty.id = "~all", start.index = 1L, max.results = 1000L) {
    url <- paste("https://www.googleapis.com/analytics/v3/management/accounts",
                 account.id, "webproperties", webproperty.id, "profiles", sep = "/")
    query <- paste0("start-index=", start.index, "&max-results=", max.results)
    url <- paste(url, query, sep = "?")
    data.json <- get_api_request(url = url, token = token)
    cols <- c("id", "accountId", "webPropertyId", "name", "currency", "timezone", "eCommerceTracking", "websiteUrl", "created", "updated")
    if (data.json$totalResults > 0 && !is.null(data.json[["items"]])) {
        data.r <- data.json$items
        data.r <- data.r[, cols]
    }
    else {
        data.r <- data.frame(matrix(NA, nrow = 1L, ncol = length(cols)))
        colnames(data.r) <- cols
    }
    return(data.r)
}

#' @title Lists goals to which the user has access
#'
#' @param token \code{Token2.0} class object.
#' @param account.id account ID to retrieve goals for. Can either be a specific account ID or "~all", which refers to all the accounts that user has access to.
#' @param webproperty.id web property ID to retrieve goals for. Can either be a specific web property ID or "~all", which refers to all the web properties that user has access to.
#' @param profile.id view (Profile) ID to retrieve goals for. Can either be a specific view (profile) ID or "~all", which refers to all the views (profiles) that user has access to.'
#' @param start.index an index of the first account to retrieve.
#' @param max.results the maximum number of accounts to include in this response.
#'
#' @return A data frame with Google Analytics management data.
#'
#' @seealso \code{\link{get_token}}
#'
#' @family Management API
#'
#' @include api-request.R
#'
#' @export
#'
get_goals = function(token, account.id = "~all", webproperty.id = "~all", profile.id = "~all", start.index = 1L, max.results = 1000L) {
    url <- paste("https://www.googleapis.com/analytics/v3/management/accounts",
                 account.id, "webproperties", webproperty.id, "profiles", profile.id, "goals", sep = "/")
    query <- paste0("start-index=", start.index, "&max-results=", max.results)
    url <- paste(url, query, sep = "?")
    data.json <- get_api_request(url = url, token = token)
    cols <- c("id", "accountId", "webPropertyId", "profileId", "name", "value", "active", "type", "created", "updated")
    if (data.json$totalResults > 0 && !is.null(data.json[["items"]])) {
        data.r <- data.json$items
        data.r <- data.r[, cols]
    }
    else {
        data.r <- data.frame(matrix(NA, nrow = 1L, ncol = length(cols)))
        colnames(data.r) <- cols
    }
    return(data.r)
}

#' @title Lists segments to which the user has access
#'
#' @param token \code{Token2.0} class object.
#' @param start.index an index of the first account to retrieve.
#' @param max.results the maximum number of accounts to include in this response.
#'
#' @return A data frame with Google Analytics management data.
#'
#' @seealso \code{\link{get_token}}
#'
#' @family Management API
#'
#' @include api-request.R
#'
#' @export
#'
get_segments = function(token, start.index = 1L, max.results = 1000L) {
    url <- paste("https://www.googleapis.com/analytics/v3/management/segments", sep = "")
    query <- paste0("start-index=", start.index, "&max-results=", max.results)
    url <- paste(url, query, sep = "?")
    data.json <- get_api_request(url = url, token = token)
    cols <- c("id", "segmentId", "name", "definition", "type")
    if (data.json$totalResults > 0 && !is.null(data.json[["items"]])) {
        data.r <- data.json$items
        data.r <- data.r[, cols]
    }
    else {
        data.r <- data.frame(matrix(NA, nrow = 1L, ncol = length(cols)))
        colnames(data.r) <- cols
    }
    return(data.r)
}
