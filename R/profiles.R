#' @title Gets a view (profile) to which the user has access to
#'
#' @param account.id integer or character. Account ID to retrieve the goal for.
#' @param webproperty.id character. Web property ID to retrieve the goal for.
#' @param profile.id View (Profile) ID to retrieve the goal for.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return An Analytics view (profile).
#' \item{id}{View (Profile) ID.}
#' \item{kind}{Resource type for Analytics view (profile).}
#' \item{self.link}{Link for this view (profile).}
#' \item{account.id}{Account ID to which this view (profile) belongs.}
#' \item{web.property.id}{Web property ID of the form UA-XXXXX-YY to which this view (profile) belongs.}
#' \item{internal.web.property.id}{Internal ID for the web property to which this view (profile) belongs.}
#' \item{name}{Name of this view (profile).}
#' \item{currency}{The currency type associated with this view (profile).}
#' \item{timezone}{Time zone for which this view (profile) has been configured. Time zones are identified by strings from the TZ database.}
#' \item{website.url}{Website URL for this view (profile).}
#' \item{site.search.query.parameters}{The site search query parameters for this view (profile).}
#' \item{strip.site.search.query.parameters}{Whether or not Analytics will strip search query parameters from the URLs in your reports.}
#' \item{type}{View (Profile) type. Supported types: WEB or APP.}
#' \item{permissions}{Permissions the user has for this view (profile).}
#' \item{created}{Time this view (profile) was created.}
#' \item{updated}{Time this view (profile) was last modified.}
#' \item{e.commerce.tracking}{Indicates whether ecommerce tracking is enabled for this view (profile).}
#' \item{parent.link}{Parent link for this view (profile). Points to the web property to which this view (profile) belongs.}
#' \item{child.link}{Child link for this view (profile). Points to the list of goals for this view (profile).}#'
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/profiles}{Google Management API - Unsampled Reports}
#'
#' @family Management API
#'
#' @include mgmt.R
#'
#' @export
#'
get_profile <- function(account.id, webproperty.id, profile.id, token) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, sep = "/")
    res <- get_mgmt(path = path, token = token)
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
#' @include mgmt.R
#'
#' @export
#'
list_profiles = function(account.id = "~all", webproperty.id = "~all", start.index = NULL, max.results = NULL, token) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", sep = "/")
    query <- list(start.index = start.index, max.results = max.results,
                  fields = "items(id,accountId,webPropertyId,name,currency,timezone,websiteUrl,type,eCommerceTracking,permissions/effective,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}

#' @noRd
#'
#' @export
#'
get_profiles = function(account.id = "~all", webproperty.id = "~all", start.index = NULL, max.results = NULL, token) {
    .Defunct("list_profiles")
}