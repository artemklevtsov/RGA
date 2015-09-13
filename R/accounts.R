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
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/accounts}{Management API - Accounts}
#'
#' \href{https://ga-dev-tools.appspot.com/account-explorer/}{Google Analytics Demos & Tools - Account Explorer}
#'
#' \href{https://support.google.com/analytics/answer/1009618?vid=1-635777221050507375-76049587}{Analytics Help - Hierarchy of accounts, users, properties, and views}
#'
#' @family Management API
#'
#'
#' @include mgmt.R
#'
#' @export
#'
list_accounts = function(start.index = NULL, max.results = NULL, token) {
    path <- "accounts"
    query <- list(start.index = start.index, max.results = max.results, 
                  fields = "items(id,name,permissions/effective,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
