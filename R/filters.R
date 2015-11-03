#' @title Filters
#'
#' @description Gets a filter to which the user has access to.
#'
#' @param account.id integer or character. Account ID to retrieve filters for.
#' @param filter.id integer or character. Filter ID to retrieve filters for.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return An Analytics account filter.
#' \item{id}{Filter ID.}
#' \item{kind}{Resource type for Analytics filter.}
#' \item{self.link}{Link for this filter.}
#' \item{account.id}{Account ID to which this filter belongs.}
#' \item{name}{Name of this filter.}
#' \item{type}{Type of this filter.}
#' \item{created}{Time this filter was created.}
#' \item{updated}{Time this filter was last modified.}
#' \item{parent.link.type}{Value is "analytics#account".}
#' \item{parent.link.href}{Link to the account to which this filter belongs.}
#' \item{include.details.kind}{Kind value for filter expression}
#' \item{include.details.field}{Field to filter.}
#' \item{include.details.match.type}{Match type for this filter.}
#' \item{include.details.expression.value}{Filter expression value}
#' \item{include.details.case.sensitive}{Determines if the filter is case sensitive.}
#' \item{exclude.details.kind}{Kind value for filter expression}
#' \item{exclude.details.field}{Field to filter.}
#' \item{exclude.details.match.type}{Match type for this filter.}
#' \item{exclude.details.expression.value}{Filter expression value}
#' \item{exclude.details.case.sensitive}{Determines if the filter is case sensitive.}
#' \item{lowercase.details.field}{Field to use in the filter.}
#' \item{uppercase.details.field}{Field to use in the filter.}
#' \item{search.and.replace.details.field}{Field to use in the filter.}
#' \item{search.and.replace.details.search.string}{Term to search.}
#' \item{search.and.replace.details.replace.string}{Term to replace the search term with.}
#' \item{search.and.replace.details.case.sensitive}{Determines if the filter is case sensitive.}
#' \item{advanced.details.field.a}{Field A.}
#' \item{advanced.details.extract.a}{Expression to extract from field A.}
#' \item{advanced.details.field.b}{Field B.}
#' \item{advanced.details.extract.b}{Expression to extract from field B.}
#' \item{advanced.details.output.to.field}{Output field.}
#' \item{advanced.details.output.constructor}{Expression used to construct the output value.}
#' \item{advanced.details.field.aRequired}{Indicates if field A is required to match.}
#' \item{advanced.details.field.bRequired}{Indicates if field B is required to match.}
#' \item{advanced.details.override.output.field}{Indicates if the existing value of the output field, if any, should be overridden by the output expression.}
#' \item{advanced.details.case.sensitive}{Indicates if the filter expressions are case sensitive.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/filters}{Management API - Filters}
#'
#' @family Management API
#'
#' @include mgmt.R
#'
#' @export
#'
get_filter <- function(account.id, filter.id, token) {
    path <- c("accounts", account.id, "filters", filter.id)
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @title Filters
#'
#' @description Lists all filters for an account which the user has access to.
#'
#' @param account.id Account ID to retrieve filters for.
#' @param max.results integer. The maximum number of filters to include in this response.
#' @param start.index integer. An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
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
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/filters}{Management API - Filters}
#'
#' @family Management API
#'
#' @include mgmt.R
#'
#' @export
#'
list_filters <- function(account.id, start.index = NULL, max.results = NULL, token) {
    path <- c("accounts", account.id, "filters")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,accountId,name,type,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
