#' @title Lists all accounts to which the user has access
#'
#' @param start.index integer. An index of the first account to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of accounts to include in this response.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
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
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/accounts}{Google Management API - Accounts}
#'
#' @family The Google Analytics Management API
#'
#' @include get-data.R
#' @include convert.R
#'
#' @export
#'
get_accounts = function(start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose", FALSE)) {
    path <- "accounts"
    query <- list(start.index = start.index, max.results = max.results)
    data_json <- get_data(type = "mgmt", path = path, query = query, token = token, verbose = verbose)
    cols <- c("id", "name", "created", "updated")
    return(build_mgmt(data_json, cols))
}

#' @title Lists web properties to which the user has access
#'
#' @param account.id character. Account ID to retrieve web properties for. Can either be a specific account ID or "~all", which refers to all the accounts that user has access to.
#' @param start.index integer. An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of web properties to include in this response.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @return A data frame with Google Analytics management data.
#' \item{accountId}{Account ID to which this web property belongs.}
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
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/webproperties}{Google Management API - Web Properties}
#'
#' @family The Google Analytics Management API
#'
#' @include get-data.R
#' @include convert.R
#'
#' @export
#'
get_webproperties = function(account.id = "~all", start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose", FALSE)) {
    path <- paste("accounts", account.id, "webproperties", sep = "/")
    query <- list(start.index = start.index, max.results = max.results)
    data_json <- get_data(type = "mgmt", path = path, query = query, token = token, verbose = verbose)
    cols <- c("accountId", "id", "name", "websiteUrl", "level", "profileCount", "industryVertical", "created", "updated")
    return(build_mgmt(data_json, cols))
}

#' @title Lists views (profiles) to which the user has access
#'
#' @param account.id character. Account ID for the view (profiles) to retrieve. Can either be a specific account ID or '~all', which refers to all the accounts to which the user has access. Requere spcify \code{account.id}.
#' @param webproperty.id character. Web property ID for the views (profiles) to retrieve. Can either be a specific web property ID or '~all', which refers to all the web properties to which the user has access.
#' @param start.index integer. An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of views (profiles) to include in this response.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @return A data frame with Google Analytics management data.
#' \item{accountId}{account ID to which this view (profile) belongs.}
#' \item{webPropertyId}{web property ID of the form UA-XXXXX-YY to which this view (profile) belongs.}
#' \item{id}{view (Profile) ID.}
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
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/profiles}{Google Management API - Views (Profiles)}
#'
#' @family The Google Analytics Management API
#'
#' @include get-data.R
#' @include convert.R
#'
#' @export
#'
get_profiles = function(account.id = "~all", webproperty.id = "~all", start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose", FALSE)) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", sep = "/")
    query <- list(start.index = start.index, max.results = max.results)
    data_json <- get_data(type = "mgmt", path = path, query = query, token = token, verbose = verbose)
    cols <- c("accountId", "webPropertyId", "id", "name", "websiteUrl", "type", "siteSearchQueryParameters", "siteSearchCategoryParameters", "eCommerceTracking", "currency", "timezone", "created", "updated")
    return(build_mgmt(data_json, cols))
}

#' @title Lists goals to which the user has access
#'
#' @param account.id character. Account ID to retrieve goals for. Can either be a specific account ID or '~all', which refers to all the accounts that user has access to.
#' @param webproperty.id character. Web property ID to retrieve goals for. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to. Requere spcify \code{account.id}.
#' @param profile.id character. View (Profile) ID to retrieve goals for. Can either be a specific view (profile) ID or '~all', which refers to all the views (profiles) that user has access to. Requere spcify \code{account.id} and \code{webproperty.id}.
#' @param start.index integer. An index of the first goal to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of goals to include in this response.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @return A data frame with Google Analytics management data.
#' \item{accountId}{account ID to which this goal belongs.}
#' \item{webPropertyId}{web property ID to which this goal belongs. The web property ID is of the form UA-XXXXX-YY.}
#' \item{profileId}{view (Profile) ID to which this goal belongs.}
#' \item{id}{goal ID (number).}
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
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/goals}{Google Management API - Goals}
#'
#' @family The Google Analytics Management API
#'
#' @include get-data.R
#' @include convert.R
#'
#' @export
#'
get_goals = function(account.id = "~all", webproperty.id = "~all", profile.id = "~all", start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose", FALSE)) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "goals", sep = "/")
    query <- list(start.index = start.index, max.results = max.results)
    data_json <- get_data(type = "mgmt", path = path, query = query, token = token, verbose = verbose)
    cols <- c("accountId", "webPropertyId", "profileId", "id", "name", "value", "active", "type", "created", "updated")
    return(build_mgmt(data_json, cols))
}

#' @title Lists segments to which the user has access
#'
#' @param start.index integer. An index of the first segment to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of segments to include in this response.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
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
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/segments}{Google Management API - Segments}
#'
#' \href{https://developers.google.com/analytics/devguides/reporting/core/v3/segments}{Core Reporting API - Segments}
#'
#' @family The Google Analytics Management API
#'
#' @include get-data.R
#' @include convert.R
#'
#' @export
#'
get_segments = function(start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose", FALSE)) {
    path <- "segments"
    query <- list(start.index = start.index, max.results = max.results)
    data_json <- get_data(type = "mgmt", path = path, query = query, token = token, verbose = verbose)
    cols <- c("segmentId", "id", "name", "definition", "type", "created", "updated")
    return(build_mgmt(data_json, cols))
}
