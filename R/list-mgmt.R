# Get the Management API data
#' @include get-data.R
#' @include convert.R
list_mgmt <- function(path, query, token) {
    data_json <- get_data(type = "mgmt", path = path, query = query, token = token)
    if (data_json$totalResults == 0L || is.null(data_json$items)) {
        message("No results were obtained.")
        return(NULL)
    }
    data_df <- build_df(type = "mgmt", data_json)
    data_df$created <- strptime(data_df$created, format = "%Y-%m-%dT%H:%M:%OS", tz = "UTC")
    data_df$updated <- strptime(data_df$updated, format = "%Y-%m-%dT%H:%M:%OS", tz = "UTC")
    return(data_df)
}

#' @title Lists all accounts which the user has access to
#'
#' @param start.index integer. An index of the first account to retrieve. Use this parameter as a pagi- nation mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of accounts to include in this response.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
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
#' @family Management API
#'
#' @export
#'
list_accounts = function(start.index = NULL, max.results = NULL, token) {
    path <- "accounts"
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,name,permissions/effective,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}

#' @title Lists web properties which the user has access to
#'
#' @param account.id integer or character. Account ID to retrieve web properties for. Can either be a specific account ID or "~all", which refers to all the accounts that user has access to.
#' @param start.index integer. An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of web properties to include in this response.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return A web property collection lists Analytics web properties to which the user has access. Each resource in the collection corresponds to a single Analytics web property.
#' \item{id}{Web property ID of the form UA-XXXXX-YY.}
#' \item{account.id}{Account ID to which this web property belongs.}
#' \item{name}{Name of this web property.}
#' \item{website.url}{Website url for this web property.}
#' \item{level}{Level for this web property. Possible values are STANDARD or PREMIUM.}
#' \item{profile.count}{View (Profile) count for this web property.}
#' \item{industry.vertical}{The industry vertical/category selected for this web property.}
#' \item{default.profile.id}{Default view (profile) ID.}
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
#' @family Management API
#'
#' @export
#'
list_webproperties = function(account.id = "~all", start.index = NULL, max.results = NULL, token) {
    path <- paste("accounts", account.id, "webproperties", sep = "/")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,accountId,name,websiteUrl,level,industryVertical,defaultProfileId,permissions/effective,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}

#' @title Lists views (profiles) which the user has access to
#'
#' @param account.id integer or character. Account ID for the view (profiles) to retrieve. Can either be a specific account ID or '~all', which refers to all the accounts which the user has access to.
#' @param webproperty.id character. Web property ID for the views (profiles) to retrieve. Can either be a specific web property ID or '~all', which refers to all the web properties which the user has access to. Requires specified \code{account.id}.
#' @param start.index integer. An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of views (profiles) to include in this response.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return A view (profile) collection lists Analytics views (profiles) to which the user has access. Each resource in the collection corresponds to a single Analytics view (profile).
#' \item{id}{View (Profile) ID.}
#' \item{account.id}{Account ID to which this view (profile) belongs.}
#' \item{web.property.id}{Web property ID of the form UA-XXXXX-YY to which this view (profile) belongs.}
#' \item{name}{Name of this view (profile).}
#' \item{currency}{The currency type associated with this view (profile).}
#' \item{timezone}{Time zone for which this view (profile) has been configured. Time zones are identified by strings from the TZ database.}
#' \item{website.url}{Website URL for this view (profile).}
#' \item{type}{View (Profile) type. Supported types: WEB or APP.}
#' \item{e.commerce.tracking}{Indicates whether ecommerce tracking is enabled for this view (profile).}
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
#' @family Management API
#'
#' @export
#'
list_profiles = function(account.id = "~all", webproperty.id = "~all", start.index = NULL, max.results = NULL, token) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", sep = "/")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,accountId,webPropertyId,name,currency,timezone,websiteUrl,type,eCommerceTracking,permissions/effective,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
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
#'
#' @return A goal collection lists Analytics goals to which the user has access. Each view (profile) can have a set of goals. Each resource in the Goal collection corresponds to a single Analytics goal.
#' \item{id}{Goal ID (number).}
#' \item{account.id}{Account ID which this goal belongs to.}
#' \item{webproperty.id}{Web property ID which this goal belongs to. The web property ID is of the form UA-XXXXX-YY.}
#' \item{profile.id}{View (Profile) ID to which this goal belongs.}
#' \item{name}{Goal name.}
#' \item{value}{Goal value.}
#' \item{active}{Determines whether this goal is active.}
#' \item{type}{Goal type. Acceptable values are: "EVENT", "URL_DESTINATION", "VISIT_NUM_PAGES", "VISIT_TIME_ON_SITE"}
#' \item{created}{Time this goal was created.}
#' \item{updated}{Time this goal was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/goals}{Google Management API - Goals}
#'
#' @family Management API
#'
#' @export
#'
list_goals = function(account.id = "~all", webproperty.id = "~all", profile.id = "~all", start.index = NULL, max.results = NULL, token) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "goals", sep = "/")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,accountId,webPropertyId,profileId,name,active,value,type,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}

#' @title Lists segments which the user has access to
#'
#' @param start.index integer. An index of the first segment to retrieve. Use this parameter as a pagi- nation mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of segments to include in this response.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return An segment collection lists Analytics segments that the user has access to. Each resource in the collection corresponds to a single Analytics segment.
#' \item{id}{Segment ID.}
#' \item{segment.id}{Segment ID. Can be used with the segment parameter in Data Feed.}
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
#' @family Management API
#'
#' @export
#'
list_segments = function(start.index = NULL, max.results = NULL, token) {
    path <- "segments"
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,segmentId,name,definition,type,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}

#' @title List custom data sources which the user has access to
#'
#' @param account.id integer or character. Account Id for the custom data sources to retrieve. Must be a specific account ID, ~all is not supported.
#' @param webproperty.id character. Web property Id for the custom data sources to retrieve.  Must be a specific web property ID, ~all is not supported. Requires specified \code{account.id}.
#' @param start.index integer. A 1-based index of the first custom data source to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of custom data sources to include in this response.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return Lists Analytics custom data sources to which the user has access. Each resource in the collection corresponds to a single Analytics custom data source.
#' \item{id}{Custom data source ID.}
#' \item{account.id}{Account ID to which this custom data source belongs.}
#' \item{web.property.id}{Web property ID of the form UA-XXXXX-YY to which this custom data source belongs.}
#' \item{name}{Name of this custom data source.}
#' \item{description}{Description of custom data sourc}
#' \item{type}{Type of the custom data source.}
#' \item{upload.type}{The resource type with which the custom data source can be used to upload data; it can have the values "analytics#uploads" or "analytics#dailyUploads". Custom data sources with this property set to "analytics#daily.uploads" are deprecated and should be migrated using the uploads resource.}
#' \item{import.behavior}{How cost data metrics are treated when there are duplicate keys. If this property is set to "SUMMATION" the values are added; if this property is set to "OVERWRITE" the most recent value overwrites the existing value.}
#' \item{created}{Time this custom data source was created.}
#' \item{updated}{Time this custom data source was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/customDataSources}{Google Management API - Custom Data Sources}
#'
#' @family Management API
#'
#' @export
#'
list_custom_sources <- function(account.id, webproperty.id, start.index = NULL, max.results = NULL, token) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "customDataSources", sep = "/")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,accountId,webPropertyId,name,description,type,uploadType,importBehavior,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
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
#'
#' @return An unsampled report collection lists Analytics unsampled reports to which the user has access. Each view (profile) can have a set of unsampled reports. Each resource in the unsampled report collection corresponds to a single Analytics unsampled report.
#' \item{id}{Unsampled report ID.}
#' \item{title}{Title of the unsampled report.}
#' \item{account.id}{Account ID to which this unsampled report belongs.}
#' \item{web.property.id}{Web property ID to which this unsampled report belongs. The web property ID is of the form UA-XXXXX-YY.}
#' \item{profile.id}{View (Profile) ID to which this unsampled report belongs.}
#' \item{start-date}{The start date for the unsampled report.}
#' \item{end-date}{The end date for the unsampled report.}
#' \item{metrics}{The metrics for the unsampled report.}
#' \item{dimensions}{The dimensions for the unsampled report.}
#' \item{filters}{The filters for the unsampled report.}
#' \item{segment}{The segment for the unsampled report.}
#' \item{status}{Status of this unsampled report. Possible values are PENDING, COMPLETED, or FAILED.}
#' \item{download.type}{The type of download you need to use for the report data file.}
#' \item{created}{Time this unsampled report was created.}
#' \item{updated}{Time this unsampled report was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/unsampledReports}{Google Management API - Unsampled Reports}
#'
#' @family Management API
#'
#' @export
#'
list_unsampled_reports <- function(account.id, webproperty.id, profile.id, start.index = NULL, max.results = NULL, token) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "unsampledReports", sep = "/")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,title,accountId,segmentId,profileId,start-date,end-date,metrics,dimensions,filters,segment,status,downloadType,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}

#' @title Lists all filters for an account which the user has access to
#'
#' @param account.id Account ID to retrieve filters for.
#' @param max.results The maximum number of filters to include in this response.
#' @param start.index An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return A filter collection lists filters created by users in an Analytics account. Each resource in the collection corresponds to a filter.
#' \item{id}{Filter ID.}
#' \item{account.id}{Account ID to which this filter belongs.}
#' \item{name}{Name of this filter.}
#' \item{type}{Type of this filter.}
#' \item{created}{Time this filter was created.}
#' \item{updated}{Time this filter was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/filters}{Google Management API - Filters}
#'
#' @family Management API
#'
#' @export
#'
list_filters <- function(account.id, start.index = NULL, max.results = NULL, token) {
    path <- paste("accounts", account.id, "filters", sep = "/")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,accountId,name,type,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}

#' @title Lists experiments to which the user has access to
#'
#' @param account.id Account ID to retrieve experiments for.
#' @param webproperty.id Web property ID to retrieve experiments for.
#' @param profile.id View (Profile) ID to retrieve experiments for.
#' @param max.results The maximum number of experiments to include in this response.
#' @param start.index An index of the first experiment to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return An experiment collection lists Analytics experiments to which the user has access. Each view (profile) can have a set of experiments. Each resource in the Experiment collection corresponds to a single Analytics experiment.
#' \item{id}{Experiment ID. Required for patch and update. Disallowed for create.}
#' \item{account.id}{Account ID to which this experiment belongs.}
#' \item{webproperty.id}{Web property ID to which this experiment belongs. The web property ID is of the form UA-XXXXX-YY.}
#' \item{profile.id}{View (Profile) ID to which this experiment belongs.}
#' \item{name}{Experiment name. This field may not be changed for an experiment whose status is ENDED.}
#' \item{description}{Notes about this experiment.}
#' \item{objective.metric}{The metric that the experiment is optimizing.}
#' \item{optimization.type}{Whether the objectiveMetric should be minimized or maximized.}
#' \item{status}{Experiment status.}
#' \item{winner.found}{Boolean specifying whether a winner has been found for this experiment.}
#' \item{rewrite.variation.urls.as.original}{Boolean specifying whether variations URLS are rewritten to match those of the original.}
#' \item{winner.confidence.level}{A floating-point number between 0 and 1. Specifies the necessary confidence level to choose a winner.}
#' \item{start.time}{The starting time of the experiment (the time the status changed from READY_TO_RUN to RUNNING).}
#' \item{end.time}{The ending time of the experiment (the time the status changed from RUNNING to ENDED).}
#' \item{minimum.experiment.length.in.days}{An integer number in [3, 90]. Specifies the minimum length of the experiment.}
#' \item{reason.experiment.ended}{Why the experiment ended.}
#' \item{editable.in.ga.ui}{If true, the end user will be able to edit the experiment via the Google Analytics user interface.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/experiments}{Google Management API - Experiments}
#'
#' @family Management API
#'
#' @export
#'
list_experiments <- function(account.id, webproperty.id, profile.id, start.index = NULL, max.results = NULL, token) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "experiments", sep = "/")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,accountId,webPropertyId,profileId,name,description,objectiveMetric,optimizationType,status,winnerFound,rewriteVariationUrlsAsOriginal,winnerConfidenceLevel,startTime,endTime,minimumExperimentLengthInDays,reasonExperimentEnded,editableInGaUi,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
