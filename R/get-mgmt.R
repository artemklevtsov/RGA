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

#' @title Gets a single unsampled report
#'
#' @param account.id integer or character. Account ID to retrieve unsampled report for.
#' @param webproperty.id integer or character. Web property ID to retrieve unsampled reports for.
#' @param profile.id integer or character. View (Profile) ID to retrieve unsampled report for.
#' @param unsampled.report.id integer or character. Web property ID to retrieve unsampled reports for.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @param verbose logical. Should print information verbose?
#'
#' @return An Analytics unsampled report.
#' \item{id}{Unsampled report ID.}
#' \item{kind}{Resource type for an Analytics unsampled report.}
#' \item{selfLink}{Link for this unsampled report.}
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
#' \item{status}{Status of this unsampled report.  Possible values are PENDING, COMPLETED, or FAILED.}
#' \item{downloadType}{The type of download you need to use for the report data file.}
#' \item{driveDownloadDetails}{Download details for a file stored in Google Drive.}
#' \item{cloudStorageDownloadDetails}{Download details for a file stored in Google Cloud Storage.}
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
#' @include request.R
#'
#' @export
#'
get_unsampled_report <- function(account.id, webproperty.id, profile.id, unsampled.report.id, token, verbose = getOption("rga.verbose")) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "unsampledReports", unsampled.report.id, sep = "/")
    res <- get_mgmt(path = path, token = token, verbose = verbose)
    return(res)
}

#' @title Gets a filter to which the user has access to
#'
#' @param account.id integer or character. Account ID to retrieve filters for.
#' @param filter.id integer or character. Filter ID to retrieve filters for.
#'
#' @return An Analytics account filter.
#' \item{id}{Filter ID.}
#' \item{kind}{Resource type for Analytics filter.}
#' \item{selfLink}{Link for this filter.}
#' \item{accountId}{Account ID to which this filter belongs.}
#' \item{name}{Name of this filter.}
#' \item{type}{Type of this filter.}
#' \item{created}{Time this filter was created.}
#' \item{updated}{Time this filter was last modified.}
#' \item{parentLink.type}{Value is "analytics#account".}
#' \item{parentLink.href}{Link to the account to which this filter belongs.}
#' \item{includeDetails.kind}{Kind value for filter expression}
#' \item{includeDetails.field}{Field to filter.}
#' \item{includeDetails.matchType}{Match type for this filter.}
#' \item{includeDetails.expressionValue}{Filter expression value}
#' \item{includeDetails.caseSensitive}{Determines if the filter is case sensitive.}
#' \item{excludeDetails.kind}{Kind value for filter expression}
#' \item{excludeDetails.field}{Field to filter.}
#' \item{excludeDetails.matchType}{Match type for this filter.}
#' \item{excludeDetails.expressionValue}{Filter expression value}
#' \item{excludeDetails.caseSensitive}{Determines if the filter is case sensitive.}
#' \item{lowercaseDetails.field}{Field to use in the filter.}
#' \item{uppercaseDetails.field}{Field to use in the filter.}
#' \item{searchAndReplaceDetails.field}{Field to use in the filter.}
#' \item{searchAndReplaceDetails.searchString}{Term to search.}
#' \item{searchAndReplaceDetails.replaceString}{Term to replace the search term with.}
#' \item{searchAndReplaceDetails.caseSensitive}{Determines if the filter is case sensitive.}
#' \item{advancedDetails.fieldA}{Field A.}
#' \item{advancedDetails.extractA}{Expression to extract from field A.}
#' \item{advancedDetails.fieldB}{Field B.}
#' \item{advancedDetails.extractB}{Expression to extract from field B.}
#' \item{advancedDetails.outputToField}{Output field.}
#' \item{advancedDetails.outputConstructor}{Expression used to construct the output value.}
#' \item{advancedDetails.fieldARequired}{Indicates if field A is required to match.}
#' \item{advancedDetails.fieldBRequired}{Indicates if field B is required to match.}
#' \item{advancedDetails.overrideOutputField}{Indicates if the existing value of the output field, if any, should be overridden by the output expression.}
#' \item{advancedDetails.caseSensitive}{Indicates if the filter expressions are case sensitive.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/filters}{Google Management API - Filters}
#'
#' @family The Google Analytics Management API
#'
#' @include request.R
#'
#' @export
#'
get_filter <- function(account.id, filter.id, token, verbose = getOption("rga.verbose")) {
    path <- paste("accounts", account.id, "filters", filter.id, sep = "/")
    res <- get_response(type = "mgmt", path = path)
    return(res)
}
