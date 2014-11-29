# Get the management API data
#' @include get-data.R
#' @include convert.R
#'
get_mgmt <- function(path, query, token, verbose = getOption("rga.verbose", FALSE)) {
    data_json <- get_data(type = "mgmt", path = path, query = query, token = token, verbose = verbose)
    items <- data_json[["items"]]
    if (data_json$totalResults == 0 || is.null(items)) {
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
#' \item{permissions}{All the permissions that the user has for this account. These include any implied permissions (e.g., EDIT implies VIEW).}
#' \item{created}{Time the account was created.}
#' \item{updated}{Time the account was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/accounts}{Google Management API - Accounts}
#'
#' @family The Google Analytics Management API
#'
#' @export
#'
get_accounts = function(start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose", FALSE)) {
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
#' @return web property collection lists Analytics web properties to which the user has access. Each resource in the collection corresponds to a single Analytics web property.
#' \item{id}{Web property ID of the form UA-XXXXX-YY.}
#' \item{accountId}{Account ID to which this web property belongs.}
#' \item{internalWebPropertyId}{Internal ID for this web property.}
#' \item{name}{Name of this web property.}
#' \item{websiteUrl}{Website url for this web property.}
#' \item{level}{Level for this web property. Possible values are STANDARD or PREMIUM.}
#' \item{profileCount}{View (Profile) count for this web property.}
#' \item{industryVertical}{The industry vertical/category selected for this web property.}
#' \item{defaultProfileId}{Default view (profile) ID.}
#' \item{permissions}{All the permissions that the user has for this web property. These include any implied permissions (e.g., EDIT implies VIEW) or inherited permissions from the parent account.}
#' \item{created}{Time this web property was created.}
#' \item{updated}{Time this web property was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/webproperties}{Google Management API - Web Properties}
#'
#' @family The Google Analytics Management API
#'
#' @export
#'
get_webproperties = function(account.id = "~all", start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose", FALSE)) {
    path <- paste("accounts", account.id, "webproperties", sep = "/")
    query <- list(start.index = start.index, max.results = max.results)
    res <- get_mgmt(path = path, query = query, token = token, verbose = verbose)
    return(res)
}

#' @title Lists views (profiles) which the user has access to
#'
#' @param account.id integer or character. Account ID for the view (profiles) to retrieve. Can either be a specific account ID or '~all', which refers to all the accounts which the user has access to. Requires specified account.id.
#' @param webproperty.id character. Web property ID for the views (profiles) to retrieve. Can either be a specific web property ID or '~all', which refers to all the web properties which the user has access to.
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
#' \item{permissions}{All the permissions that the user has for this view (profile). These include any implied permissions (e.g., EDIT implies VIEW) or inherited permissions from the parent web property.}
#' \item{created}{Time this view (profile) was created.}
#' \item{updated}{Time this view (profile) was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/profiles}{Google Management API - Views (Profiles)}
#'
#' @family The Google Analytics Management API
#'
#' @export
#'
get_profiles = function(account.id = "~all", webproperty.id = "~all", start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose", FALSE)) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", sep = "/")
    query <- list(start.index = start.index, max.results = max.results)
    res <- get_mgmt(path = path, query = query, token = token, verbose = verbose)
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
get_goals = function(account.id = "~all", webproperty.id = "~all", profile.id = "~all", start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose", FALSE)) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "goals", sep = "/")
    query <- list(start.index = start.index, max.results = max.results)
    res <- get_mgmt(path = path, query = query, token = token, verbose = verbose)
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
get_segments = function(start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose", FALSE)) {
    path <- "segments"
    query <- list(start.index = start.index, max.results = max.results)
    res <- get_mgmt(path = path, query = query, token = token, verbose = verbose)
    return(res)
}

#' @title Lists unsampled reports which the user has access to
#'
#' @param account.id integer or character. The account ID to retrieve unsampled reports for. Must be a specific account ID, ~all is not supported.
#' @param webproperty.id character. Web property ID to retrieve unsampled reports for. Must be a specific web property ID, ~all is not supported. Requires specified \code{account.id}.
#' @param profile.id ineger or character. View (Profile) ID to retrieve unsampled reports for. Must be a specific view (profile) ID, ~all is not supported. Requires specified \code{account.id} and \code{webproperty.id}.
#' @param start.index integer. An index of the first unsampled report to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of unsampled reports to include in this response.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @return
#' \item{id}{Unsampled report ID.}
#' \item{title}{Title of the unsampled report.}
#' \item{accountId}{Account ID to which this unsampled report belongs.}
#' \item{webPropertyId}{Web property ID to which this unsampled report belongs. The web property ID is of the form UA-XXXXX-YY.}
#' \item{profileId}{View (Profile) ID to which this unsampled report belongs.}
#' \item{start-date}{The start date for the unsampled report.}
#' \item{end-date}{The end date for the unsampled report.}
#' \item{metrics}{The metrics for the unsampled report.}
#' \item{dimensions}{The dimensions for the unsampled report.}
#' \item{filters}{The filters for the unsampled report.}
#' \item{segment}{The segment for the unsampled report.}
#' \item{status}{Status of this unsampled report. Possible values are PENDING, COMPLETED, or FAILED.}
#' \item{downloadType}{The type of download you need to use for the report data file.}
#' \item{driveDownloadDetails.documentId}{Id of the document/file containing the report data.}
#' \item{cloudStorageDownloadDetails.bucketId}{Id of the bucket the file object is stored in.}
#' \item{cloudStorageDownloadDetails.objectId}{Id of the file object containing the report data.}
#' \item{created}{Time this unsampled report was created.}
#' \item{updated}{Time this unsampled report was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/unsampledReports}{Google Management API - Unsampled Reports}
#'
#' @family The Google Analytics Management API
#'
#' @export
#'
get_unsampled <- function(account.id, webproperty.id, profile.id, start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose", FALSE)) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "unsampledReports", sep = "/")
    query <- list(start.index = start.index, max.results = max.results)
    res <- get_mgmt(path = path, query = query, token = token, verbose = verbose)
    return(res)
}

#' @title List custom data sources which the user has access to
#'
#' @param account.id integer or character. Account Id for the custom data sources to retrieve. Must be a specific account ID, ~all is not supported.
#' @param webproperty.id character. Web property Id for the custom data sources to retrieve.  Must be a specific web property ID, ~all is not supported. Requires specified \code{account.id}.
#' @param start.index integer. A 1-based index of the first custom data source to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of custom data sources to include in this response.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @return Lists Analytics custom data sources to which the user has access. Each resource in the collection corresponds to a single Analytics custom data source.
#' \item{id}{Custom data source ID.}
#' \item{accountId}{Account ID to which this custom data source belongs.}
#' \item{webPropertyId}{Web property ID of the form UA-XXXXX-YY to which this custom data source belongs.}
#' \item{name}{Name of this custom data source.}
#' \item{description}{Description of custom data sourc}
#' \item{type}{Type of the custom data source.}
#' \item{uploadType}{The resource type with which the custom data source can be used to upload data; it can have the values "analytics#uploads" or "analytics#dailyUploads". Custom data sources with this property set to "analytics#dailyUploads" are deprecated and should be migrated using the uploads resource.}
#' \item{importBehavior}{How cost data metrics are treated when there are duplicate keys. If this property is set to "SUMMATION" the values are added; if this property is set to "OVERWRITE" the most recent value overwrites the existing value.}
#' \item{created}{Time this custom data source was created.}
#' \item{updated}{Time this custom data source was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/customDataSources}{Google Management API - Custom Data Sources}
#'
#' @family The Google Analytics Management API
#'
#' @export
#'
get_custom_sources <- function(account.id, webproperty.id, start.index = NULL, max.results = NULL, token, verbose = getOption("rga.verbose", FALSE)) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "customDataSources", sep = "/")
    query <- list(start.index = start.index, max.results = max.results)
    res <- get_mgmt(path = path, query = query, token = token, verbose = verbose)
    return(res)
}
