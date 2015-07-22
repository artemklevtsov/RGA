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
#' \item{webproperty.id}{Web property ID of the form UA-XXXXX-YY to which this custom data source belongs.}
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
#' @include mgmt.R
#'
#' @export
#'
list_custom_sources <- function(account.id, webproperty.id, start.index = NULL, max.results = NULL, token) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "customDataSources", sep = "/")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,accountId,webPropertyId,name,description,type,uploadType,importBehavior,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
