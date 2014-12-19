# Get the Management API data
#' @include get-data.R
#' @include convert.R
#'
get_mgmt <- function(path, query, token, verbose = getOption("rga.verbose")) {
    data_json <- get_data(type = "mgmt", path = path, query = query, token = token, verbose = verbose)
    items <- data_json[["items"]]
    if (data_json$totalResults == 0L || is.null(items)) {
        message("No results were obtained.")
        return(NULL)
    }
    data_df <- build_df(type = "mgmt", items, verbose = verbose)
    return(data_df)
}

#' @title Lists all accounts which the user has access to
#'
#' @param start.index integer. An index of the first account to retrieve. Use this parameter as a pagi- nation mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of accounts to include in this response.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @return An account collection provides a list of Analytics accounts to which a user has access. The account collection is the entry point to all management information. Each resource in the collection corresponds to a single Analytics account.
#' \item{id}{Account ID.}
#' \item{name}{Account name.}
#' \item{permissions}{Permissions the user has for this account.}
#' \item{created}{Time the account was created.}
#' \item{updated}{Time the account was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/accounts}{Google Management API - Accounts}
#'
#' \href{https://ga-dev-tools.appspot.com/account-explorer/}{Google Analytics Demos & Tools - Account Explorer}
#'
#' @family The Google Analytics Management API
#'
#' @export
#'
list_accounts = function(start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose")) {
    path <- "accounts"
    query <- list(start.index = start.index, max.results = max.results)
    res <- get_mgmt(path = path, query = query, token = token, verbose = verbose)
    return(res)
}

#' @rdname list_accounts
#'
#' @export
#'
get_accounts <- function(start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose")) {
    .Deprecated("list_accounts")
    path <- "accounts"
    query <- list(start.index = start.index, max.results = max.results)
    res <- get_mgmt(path = path, query = query, token = token, verbose = verbose)
    return(res)
}


#' @title Lists web properties which the user has access to
#'
#' @param account.id integer or character. Account ID to retrieve web properties for. Can either be a specific account ID or "~all", which refers to all the accounts that user has access to.
#' @param start.index integer. An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of web properties to include in this response.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @return A web property collection lists Analytics web properties to which the user has access. Each resource in the collection corresponds to a single Analytics web property.
#' \item{id}{Web property ID of the form UA-XXXXX-YY.}
#' \item{accountId}{Account ID to which this web property belongs.}
#' \item{internalWebPropertyId}{Internal ID for this web property.}
#' \item{name}{Name of this web property.}
#' \item{websiteUrl}{Website url for this web property.}
#' \item{level}{Level for this web property. Possible values are STANDARD or PREMIUM.}
#' \item{profileCount}{View (Profile) count for this web property.}
#' \item{industryVertical}{The industry vertical/category selected for this web property.}
#' \item{defaultProfileId}{Default view (profile) ID.}
#' \item{permissions}{Permissions the user has for this web property.}
#' \item{created}{Time this web property was created.}
#' \item{updated}{Time this web property was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/webproperties}{Google Management API - Web Properties}
#'
#' \href{https://ga-dev-tools.appspot.com/account-explorer/}{Google Analytics Demos & Tools - Account Explorer}
#'
#' @family The Google Analytics Management API
#'
#' @export
#'
list_webproperties = function(account.id = "~all", start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose")) {
    path <- paste("accounts", account.id, "webproperties", sep = "/")
    query <- list(start.index = start.index, max.results = max.results)
    res <- get_mgmt(path = path, query = query, token = token, verbose = verbose)
    return(res)
}

#' @rdname list_webproperties
#'
#' @export
#'
get_webproperties = function(account.id = "~all", start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose")) {
    .Deprecated("list_webproperties")
    path <- paste("accounts", account.id, "webproperties", sep = "/")
    query <- list(start.index = start.index, max.results = max.results)
    res <- get_mgmt(path = path, query = query, token = token, verbose = verbose)
    return(res)
}

#' @title Gets a web property to which the user has access to
#'
#' @param account.id integer or character. Account ID to retrieve the web property for.
#' @param webproperty.id character. ID to retrieve the web property for.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @return An Analytics web property.
#' \item{id}{Web property ID of the form UA-XXXXX-YY.}
#' \item{kind}{Resource type for Analytics WebProperty.}
#' \item{selfLink}{Link for this web property.}
#' \item{accountId}{Account ID to which this web property belongs.}
#' \item{internalWebPropertyId}{Internal ID for this web property.}
#' \item{name}{Name of this web property.}
#' \item{websiteUrl}{Website url for this web property.}
#' \item{level}{Level for this web property.}
#' \item{profileCount}{View (Profile) count for this web property.}
#' \item{industryVertical}{The industry vertical/category selected for this web property.}
#' \item{defaultProfileId}{Default view (profile) ID.}
#' \item{permissions}{Permissions the user has for this web property.}
#' \item{created}{Time this web property was created.}
#' \item{updated}{Time this web property was last modified.}
#' \item{parentLink}{Parent link for this web property. Points to the account to which this web property belongs.}
#' \item{childLink}{Child link for this web property. Points to the list of views (profiles) for this web property.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/webproperties}{Google Management API - Web Properties}
#'
#' @family The Google Analytics Management API
#'
#' @include request.R
#'
#' @export
#'
get_webproperty <- function(account.id, webproperty.id, token, verbose = getOption("rga.verbose")) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, sep = "/")
    res <- get_response(type = "mgmt", path = path)
    return(res)
}

#' @title Lists views (profiles) which the user has access to
#'
#' @param account.id integer or character. Account ID for the view (profiles) to retrieve. Can either be a specific account ID or '~all', which refers to all the accounts which the user has access to.
#' @param webproperty.id character. Web property ID for the views (profiles) to retrieve. Can either be a specific web property ID or '~all', which refers to all the web properties which the user has access to. Requires specified \code{account.id}.
#' @param start.index integer. An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of views (profiles) to include in this response.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @return A view (profile) collection lists Analytics views (profiles) to which the user has access. Each resource in the collection corresponds to a single Analytics view (profile).
#' \item{id}{View (Profile) ID.}
#' \item{accountId}{Account ID to which this view (profile) belongs.}
#' \item{webPropertyId}{Web property ID of the form UA-XXXXX-YY to which this view (profile) belongs.}
#' \item{internalWebPropertyId}{Internal ID for the web property to which this view (profile) belongs.}
#' \item{name}{Name of this view (profile).}
#' \item{currency}{The currency type associated with this view (profile).}
#' \item{timezone}{Time zone for which this view (profile) has been configured. Time zones are identified by strings from the TZ database.}
#' \item{websiteUrl}{Website URL for this view (profile).}
#' \item{type}{View (Profile) type. Supported types: WEB or APP.}
#' \item{siteSearchCategoryParameters}{Site search category parameters for this view (profile).}
#' \item{stripSiteSearchCategoryParameters}{Whether or not Analytics will strip search category parameters from the URLs in your reports.}
#' \item{excludeQueryParameters}{The query parameters that are excluded from this view (profile).}
#' \item{eCommerceTracking}{Indicates whether ecommerce tracking is enabled for this view (profile).}
#' \item{permissions}{Permissions the user has for this view (profile).}
#' \item{created}{Time this view (profile) was created.}
#' \item{updated}{Time this view (profile) was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/profiles}{Google Management API - Views (Profiles)}
#'
#' \href{https://ga-dev-tools.appspot.com/account-explorer/}{Google Analytics Demos & Tools - Account Explorer}
#'
#' @family The Google Analytics Management API
#'
#' @export
#'
list_profiles = function(account.id = "~all", webproperty.id = "~all", start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose")) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", sep = "/")
    query <- list(start.index = start.index, max.results = max.results)
    res <- get_mgmt(path = path, query = query, token = token, verbose = verbose)
    return(res)
}

#' @rdname list_profiles
#'
#' @export
#'
get_profiles = function(account.id = "~all", webproperty.id = "~all", start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose")) {
    .Deprecated("list_profiles")
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", sep = "/")
    query <- list(start.index = start.index, max.results = max.results)
    res <- get_mgmt(path = path, query = query, token = token, verbose = verbose)
    return(res)
}

#' @title Gets a view (profile) to which the user has access to
#'
#' @param account.id integer or character. Account ID to retrieve the goal for.
#' @param webproperty.id character. Web property ID to retrieve the goal for.
#' @param profile.id View (Profile) ID to retrieve the goal for.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @return An Analytics view (profile).
#' \item{id}{View (Profile) ID.}
#' \item{kind}{Resource type for Analytics view (profile).}
#' \item{selfLink}{Link for this view (profile).}
#' \item{accountId}{Account ID to which this view (profile) belongs.}
#' \item{webPropertyId}{Web property ID of the form UA-XXXXX-YY to which this view (profile) belongs.}
#' \item{internalWebPropertyId}{Internal ID for the web property to which this view (profile) belongs.}
#' \item{name}{Name of this view (profile).}
#' \item{currency}{The currency type associated with this view (profile).}
#' \item{timezone}{Time zone for which this view (profile) has been configured. Time zones are identified by strings from the TZ database.}
#' \item{websiteUrl}{Website URL for this view (profile).}
#' \item{siteSearchQueryParameters}{The site search query parameters for this view (profile).}
#' \item{stripSiteSearchQueryParameters}{Whether or not Analytics will strip search query parameters from the URLs in your reports.}
#' \item{type}{View (Profile) type. Supported types: WEB or APP.}
#' \item{permissions}{Permissions the user has for this view (profile).}
#' \item{created}{Time this view (profile) was created.}
#' \item{updated}{Time this view (profile) was last modified.}
#' \item{eCommerceTracking}{Indicates whether ecommerce tracking is enabled for this view (profile).}
#' \item{parentLink}{Parent link for this view (profile). Points to the web property to which this view (profile) belongs.}
#' \item{childLink}{Child link for this view (profile). Points to the list of goals for this view (profile).}#'
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/profiles}{Google Management API - Unsampled Reports}
#'
#' @family The Google Analytics Management API
#'
#' @include request.R
#'
#' @export
#'
get_profile <- function(account.id, webproperty.id, profile.id, token, verbose = getOption("rga.verbose")) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, sep = "/")
    res <- get_response(type = "mgmt", path = path)
    return(res)
}

#' @title Lists goals which the user has access to
#'
#' @param account.id integer or character. The account ID to retrieve goals for. Can either be a specific account ID or '~all', which refers to all the accounts that user has access to.
#' @param webproperty.id character. Web property ID to retrieve goals for. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to. Requires specified \code{account.id}.
#' @param profile.id ineger or character. View (Profile) ID to retrieve goals for. Can either be a specific view (profile) ID or '~all', which refers to all the views (profiles) that user has access to. Requires specified \code{account.id} and \code{webproperty.id}.
#' @param start.index integer. An index of the first goal to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of goals to include in this response.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @return A goal collection lists Analytics goals to which the user has access. Each view (profile) can have a set of goals. Each resource in the Goal collection corresponds to a single Analytics goal.
#' \item{id}{Goal ID (number).}
#' \item{accountId}{Account ID which this goal belongs to.}
#' \item{webPropertyId}{Web property ID which this goal belongs to. The web property ID is of the form UA-XXXXX-YY.}
#' \item{internalWebPropertyId}{Internal ID for the web property to which this goal belongs.}
#' \item{profileId}{View (Profile) ID to which this goal belongs.}
#' \item{name}{Goal name.}
#' \item{value}{Goal value.}
#' \item{active}{Determines whether this goal is active.}
#' \item{type}{Goal type. Acceptable values are: "EVENT", "URL_DESTINATION", "VISIT_NUM_PAGES", "VISIT_TIME_ON_SITE"}
#' \item{visitTimeOnSiteDetails.comparisonType}{Type of comparison. Possible values are LESS_THAN or GREATER_THAN.}
#' \item{visitTimeOnSiteDetails.comparisonValue}{Value used for this comparison.}
#' \item{visitNumPagesDetails.comparisonType}{Type of comparison. Possible values are LESS_THAN, GREATER_THAN, or EQUAL.}
#' \item{visitNumPagesDetails.comparisonValue}{Value used for this comparison.}
#' \item{urlDestinationDetails.url}{URL for this goal.}
#' \item{urlDestinationDetails.caseSensitive}{Determines if the goal URL must exactly match the capitalization of visited URLs.}
#' \item{urlDestinationDetails.matchType}{Match type for the goal URL. Possible values are HEAD, EXACT, or REGEX.}
#' \item{urlDestinationDetails.firstStepRequired}{Determines if the first step in this goal is required.}
#' \item{created}{Time this goal was created.}
#' \item{updated}{Time this goal was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/goals}{Google Management API - Goals}
#'
#' @family The Google Analytics Management API
#'
#' @export
#'
list_goals = function(account.id = "~all", webproperty.id = "~all", profile.id = "~all", start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose")) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "goals", sep = "/")
    query <- list(start.index = start.index, max.results = max.results)
    res <- get_mgmt(path = path, query = query, token = token, verbose = verbose)
    return(res)
}

#' @rdname list_goals
#'
#' @export
#'
get_goals = function(account.id = "~all", webproperty.id = "~all", profile.id = "~all", start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose")) {
    .Deprecated("list_goals")
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "goals", sep = "/")
    query <- list(start.index = start.index, max.results = max.results)
    res <- get_mgmt(path = path, query = query, token = token, verbose = verbose)
    return(res)
}

#' @title Gets a goal to which the user has access to
#'
#' @param account.id integer or character. Account ID to retrieve the goal for.
#' @param webproperty.id character. Web property ID to retrieve the goal for.
#' @param profile.id ineger or character. View (Profile) ID to retrieve the goal for.
#' @param goal.id ineger or character. Goal ID to retrieve the goal for.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @return An Analytics goal resource
#' \item{id}{Goal ID.}
#' \item{kind}{Resource type for an Analytics goal.}
#' \item{selfLink}{Link for this goal.}
#' \item{accountId}{Account ID to which this goal belongs.}
#' \item{webPropertyId}{Web property ID to which this goal belongs. The web property ID is of the form UA-XXXXX-YY.}
#' \item{internalWebPropertyId}{Internal ID for the web property to which this goal belongs.}
#' \item{profileId}{View (Profile) ID to which this goal belongs.}
#' \item{name}{Goal name.}
#' \item{value}{Goal value.}
#' \item{active}{Determines whether this goal is active.}
#' \item{type}{Goal type. Possible values are URL_DESTINATION, VISIT_TIME_ON_SITE, VISIT_NUM_PAGES, and EVENT.}
#' \item{created}{Time this goal was created.}
#' \item{updated}{Time this goal was last modified.}
#' \item{parentLink}{Parent link for a goal. Points to the view (profile) to which this goal belongs.}
#' \item{visitTimeOnSiteDetails}{Details for the goal of the type VISIT_TIME_ON_SITE.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/goals}{Google Management API - Goals}
#'
#' @family The Google Analytics Management API
#'
#' @include request.R
#'
#' @export
#'
get_goal <- function(account.id, webproperty.id, profile.id, goal.id, token, verbose = getOption("rga.verbose")) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "goals", goal.id, sep = "/")
    res <- get_response(type = "mgmt", path = path)
    return(res)
}

#' @title Lists segments which the user has access to
#'
#' @param start.index integer. An index of the first segment to retrieve. Use this parameter as a pagi- nation mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of segments to include in this response.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @return An segment collection lists Analytics segments that the user has access to. Each resource in the collection corresponds to a single Analytics segment.
#' \item{id}{Segment ID.}
#' \item{segmentId}{Segment ID. Can be used with the segment parameter in Data Feed.}
#' \item{name}{Segment name.}
#' \item{definition}{Segment definition.}
#' \item{type}{Type for a segment. Possible values are "BUILT_IN" or "CUSTOM".}
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
#' @export
#'
list_segments = function(start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose")) {
    path <- "segments"
    query <- list(start.index = start.index, max.results = max.results)
    res <- get_mgmt(path = path, query = query, token = token, verbose = verbose)
    return(res)
}

#' @rdname list_segments
#'
#' @export
#'
get_segments = function(start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose")) {
    path <- "segments"
    .Deprecated("list_segments")
    query <- list(start.index = start.index, max.results = max.results)
    res <- get_mgmt(path = path, query = query, token = token, verbose = verbose)
    return(res)
}
