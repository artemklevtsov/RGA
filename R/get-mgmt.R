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
