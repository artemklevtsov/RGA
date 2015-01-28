#' @title Gets a web property to which the user has access to
#'
#' @param account.id integer or character. Account ID to retrieve the web property for.
#' @param webproperty.id character. ID to retrieve the web property for.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return An Analytics web property.
#' \item{id}{Web property ID of the form UA-XXXXX-YY.}
#' \item{kind}{Resource type for Analytics Web.property.}
#' \item{self.link}{Link for this web property.}
#' \item{account.id}{Account ID to which this web property belongs.}
#' \item{internal.web.property.id}{Internal ID for this web property.}
#' \item{name}{Name of this web property.}
#' \item{website.url}{Website url for this web property.}
#' \item{level}{Level for this web property.}
#' \item{profile.count}{View (Profile) count for this web property.}
#' \item{industry.vertical}{The industry vertical/category selected for this web property.}
#' \item{default.profile.id}{Default view (profile) ID.}
#' \item{permissions}{Permissions the user has for this web property.}
#' \item{created}{Time this web property was created.}
#' \item{updated}{Time this web property was last modified.}
#' \item{parent.link}{Parent link for this web property. Points to the account to which this web property belongs.}
#' \item{child.link}{Child link for this web property. Points to the list of views (profiles) for this web property.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/webproperties}{Google Management API - Web Properties}
#'
#' @family Management API
#'
#' @include mgmt.R
#'
#' @export
#'
get_webproperty <- function(account.id, webproperty.id, token) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, sep = "/")
    res <- get_mgmt(path = path, token = token)
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
#' @include mgmt.R
#'
#' @export
#'
list_webproperties = function(account.id = "~all", start.index = NULL, max.results = NULL, token) {
    path <- paste("accounts", account.id, "webproperties", sep = "/")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,accountId,name,websiteUrl,level,industryVertical,defaultProfileId,permissions/effective,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}

#' @rdname list_webproperties
#'
#' @export
#'
get_webproperties <- function(account.id = "~all", start.index = NULL, max.results = NULL, token) {
    .Defunct("list_webproperties")
}