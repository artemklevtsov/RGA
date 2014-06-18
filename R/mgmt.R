#' @title Lists all accounts to which the user has access
#'
#' @param token \code{Token2.0} class object.
#' @param start.index an index of the first account to retrieve.
#' @param max.results the maximum number of accounts to include in this response.
#'
#' @return A data frame with Google Analytics management data.
#' \item{id}{account ID.}
#' \item{name}{account name.}
#' \item{created}{time the account was created.}
#' \item{updated}{time the account was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' Google Management API - Accounts: \url{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/accounts}
#'
#' @family Management API
#'
#' @include build-url.R
#' @include api-request.R
#' @include build-df.R
#'
#' @export
#'
get_accounts = function(token, start.index = NULL, max.results = NULL) {
    path <- "accounts"
    query <-  list(start.index = start.index, max.results = max.results)
    url <- build_url(type = "mgmt", path = path, query = query)
    data.json <- api_request(url = url, token = token)
    cols <- c("id", "name", "created", "updated")
    return(build_mgmt(data.json, cols))
}

#' @title Lists web properties to which the user has access
#'
#' @param token \code{Token2.0} class object.
#' @param account.id account ID to retrieve web properties for. Can either be a specific account ID or "~all", which refers to all the accounts that user has access to.
#' @param start.index an index of the first entity to retrieve.
#' @param max.results the maximum number of web properties to include in this response.
#'
#' @return A data frame with Google Analytics management data.
#' \item{id}{web property ID of the form UA-XXXXX-YY.}
#' \item{name}{name of this web property.}
#' \item{websiteUrl}{website url for this web property.}
#' \item{level}{level for this web property. Acceptable values are: "PREMIUM", "STANDARD".}
#' \item{industryVertical}{we propetry industry vertical category.}
#' \item{profileCount}{view (Profile) count for this web property.}
#' \item{created}{time this web property was created.}
#' \item{updated}{time this web property was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' Google Management API - Web Properties: \url{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/webproperties}
#'
#' @family Management API
#'
#' @include build-url.R
#' @include api-request.R
#' @include build-df.R
#'
#' @export
#'
get_webproperties = function(token, account.id = "~all", start.index = NULL, max.results = NULL) {
    path <- paste("accounts", account.id, "webproperties", sep = "/")
    query <-  list(start.index = start.index, max.results = max.results)
    url <- build_url(type = "mgmt", path, query)
    data.json <- api_request(url = url, token = token)
    cols <- c("id", "name", "websiteUrl", "level", "profileCount", "industryVertical", "created", "updated")
    return(build_mgmt(data.json, cols))
}

#' @title Lists views (profiles) to which the user has access
#'
#' @param token \code{Token2.0} class object.
#' @param account.id account ID for the view (profiles) to retrieve. Can either be a specific account ID or "~all", which refers to all the accounts to which the user has access.
#' @param webproperty.id web property ID for the views (profiles) to retrieve. Can either be a specific web property ID or "~all", which refers to all the web properties to which the user has access.
#' @param start.index an index of the first entity to retrieve.
#' @param max.results the maximum number of views (profiles) to include in this response.
#'
#' @return A data frame with Google Analytics management data.
#' \item{id}{view (Profile) ID.}
#' \item{accountId}{account ID to which this view (profile) belongs.}
#' \item{webPropertyId}{web property ID of the form UA-XXXXX-YY to which this view (profile) belongs.}
#' \item{name}{name of this view (profile).}
#' \item{currency}{the currency type associated with this view (profile).}
#' \item{timezone}{time zone for which this view (profile) has been configured.}
#' \item{websiteUrl}{website URL for this view (profile).}
#' \item{type}{view (Profile) type. Supported types: WEB or APP.}
#' \item{eCommerceTracking}{indicates whether ecommerce tracking is enabled for this view (profile).}
#' \item{siteSearchQueryParameters}{the site search query parameters for this view (profile).}
#' \item{stripSiteSearchQueryParameters}{site search category parameters for this view (profile).}
#' \item{created}{time this view (profile) was created.}
#' \item{updated}{time this view (profile) was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' Google Management API - Views (Profiles): \url{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/profiles}
#'
#' @family Management API
#'
#' @include build-url.R
#' @include api-request.R
#' @include build-df.R
#'
#' @export
#'
get_profiles = function(token, account.id = "~all", webproperty.id = "~all", start.index = NULL, max.results = NULL) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", sep = "/")
    query <-  list(start.index = start.index, max.results = max.results)
    url <- build_url(type = "mgmt", path = path, query = query)
    data.json <- api_request(url = url, token = token)
    cols <- c("id", "accountId", "webPropertyId", "name", "currency", "timezone", "websiteUrl", "type", "siteSearchQueryParameters", "siteSearchCategoryParameters", "eCommerceTracking", "created", "updated")
    return(build_mgmt(data.json, cols))
}

#' @title Lists goals to which the user has access
#'
#' @param token \code{Token2.0} class object.
#' @param account.id account ID to retrieve goals for. Can either be a specific account ID or "~all", which refers to all the accounts that user has access to.
#' @param webproperty.id web property ID to retrieve goals for. Can either be a specific web property ID or "~all", which refers to all the web properties that user has access to.
#' @param profile.id view (Profile) ID to retrieve goals for. Can either be a specific view (profile) ID or "~all", which refers to all the views (profiles) that user has access to.'
#' @param start.index an index of the first goals to retrieve.
#' @param max.results the maximum number of goal to include in this response.
#'
#' @return A data frame with Google Analytics management data.
#' \item{id}{goal ID.}
#' \item{accountId}{account ID to which this goal belongs.}
#' \item{webPropertyId}{web property ID to which this goal belongs. The web property ID is of the form UA-XXXXX-YY.}
#' \item{profileId}{view (Profile) ID to which this goal belongs.}
#' \item{name}{goal name.}
#' \item{value}{goal value.}
#' \item{active}{determines whether this goal is active.}
#' \item{type}{goal type. Acceptable values are: "EVENT", "URL_DESTINATION", "VISIT_NUM_PAGES", "VISIT_TIME_ON_SITE"}
#' \item{created}{time this goal was created.}
#' \item{updated}{time this goal was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' Google Management API - Goals: \url{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/goals}
#'
#' @family Management API
#'
#' @include build-url.R
#' @include api-request.R
#' @include build-df.R
#'
#' @export
#'
get_goals = function(token, account.id = "~all", webproperty.id = "~all", profile.id = "~all", start.index = NULL, max.results = NULL) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "goals", sep = "/")
    query <-  list(start.index = start.index, max.results = max.results)
    url <- build_url(type = "mgmt", path = path, query = query)
    data.json <- api_request(url = url, token = token)
    cols <- c("id", "accountId", "webPropertyId", "profileId", "name", "value", "active", "type", "created", "updated")
    return(build_mgmt(data.json, cols))
}

#' @title Lists segments to which the user has access
#'
#' @param token \code{Token2.0} class object.
#' @param start.index an index of the first segments to retrieve.
#' @param max.results the maximum number of segment to include in this response.
#'
#' @return A data frame with Google Analytics management data.
#' \item{id}{segment ID.}
#' \item{segmentId}{segment ID. Can be used with the segment parameter in Data Feed.}
#' \item{name}{segment name.}
#' \item{definition}{segment definition.}
#' \item{type}{type for a segment. Possible values are "BUILT_IN" or "CUSTOM".}
#' \item{created}{time the segment was created.}
#' \item{updated}{time the segment was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' Google Management API - Segments: \url{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/segments}
#'
#' @family Management API
#'
#' @include build-url.R
#' @include api-request.R
#' @include build-df.R
#'
#' @export
#'
get_segments = function(token, start.index = NULL, max.results = NULL) {
    path <- "segments"
    query <-  list(start.index = start.index, max.results = max.results)
    url <- build_url(type = "mgmt", path = path, query = query)
    data.json <- api_request(url = url, token = token)
    cols <- c("id", "segmentId", "name", "definition", "type", "created", "updated")
    return(build_mgmt(data.json, cols))
}
