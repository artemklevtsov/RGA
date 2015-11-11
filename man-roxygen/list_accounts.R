#' @title Accounts
#' @description Lists all accounts to which the user has access.
#' @param max.results integer. The maximum number of accounts to include in this response.
#' @param start.index integer. An index of the first account to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @return The Accounts collection is a set of Account resources, each of which describes the account of an authenticated user.
#' \item{id}{Account ID.}
#' \item{kind}{Resource type for Analytics account.}
#' \item{name}{Account name.}
#' \item{permissions}{Permissions the user has for this account.}
#' \item{created}{Time the account was created.}
#' \item{updated}{Time the account was last modified.}
#' \item{permissions.effective}{All the permissions that the user has for this account. These include any implied permissions (e.g., EDIT implies VIEW).}
#' @references \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/accounts}{Management API - Accounts Overview}
#' @family Management API
