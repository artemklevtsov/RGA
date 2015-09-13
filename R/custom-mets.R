#' @title Gets a custom metric to which the user has access to
#'
#' @param account.id Account ID for the custom metric to retrieve.
#' @param webproperty.id Web property ID for the custom metric to retrieve.
#' @param metric.id The ID of the custom metric to retrieve.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return An Analytics custom metric.
#' \item{kind}{Kind value for a custom metric. Set to "analytics#customMetric". It is a read-only field.}
#' \item{id}{Custom metric ID.}
#' \item{account.id}{Account ID.}
#' \item{webproperty.id}{Property ID.}
#' \item{name}{Name of the custom metric.}
#' \item{index}{Index of the custom metric.}
#' \item{scope}{Scope of the custom metric: HIT or PRODUCT.}
#' \item{active}{Boolean indicating whether the custom metric is active.}
#' \item{type}{Data type of custom metric.}
#' \item{min_value}{Min value of custom metric.}
#' \item{max_value}{Max value of custom metric.}
#' \item{created}{Time the custom metric was created.}
#' \item{updated}{Time the custom metric was last modified.}
#' \item{self.link}{Link for the custom metric}
#' \item{parent.link}{Parent link for the custom metric. Points to the property to which the custom metric belongs.}
#' \item{parent.link.type}{Type of the parent link. Set to "analytics#webproperty".}
#' \item{parent.link.href}{Link to the property to which the custom metric belongs.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/customMetrics}{Management API - Custom metrics}
#'
#' @family Management API
#'
#' @include mgmt.R
#'
#' @export
#'
get_custom_metric <- function(account.id, webproperty.id, metric.id, token) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "customMetrics", metric.id, sep = "/")
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @title Lists custom metrics to which the user has access to
#'
#' @param account.id Account ID for the custom metrics to retrieve.
#' @param webproperty.id Web property ID for the custom metrics to retrieve.
#' @param max.results The maximum number of custom metrics to include in this response.
#' @param start.index An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return An Analytics custom metric.
#' \item{id}{Custom metric ID.}
#' \item{account.id}{Account ID.}
#' \item{webproperty.id}{Property ID.}
#' \item{name}{Name of the custom metric.}
#' \item{index}{Index of the custom metric.}
#' \item{scope}{Scope of the custom metric: HIT or PRODUCT.}
#' \item{active}{Boolean indicating whether the custom metric is active.}
#' \item{type}{Data type of custom metric.}
#' \item{min_value}{Min value of custom metric.}
#' \item{max_value}{Max value of custom metric.}
#' \item{created}{Time the custom metric was created.}
#' \item{updated}{Time the custom metric was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/customMetrics}{Management API - Custom metrics}
#'
#' @family Management API
#'
#' @include mgmt.R
#'
#' @export
#'
list_custom_metrics <- function(account.id, webproperty.id, start.index = NULL, max.results = NULL, token) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "customMetrics", sep = "/")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,accountId,webPropertyId,name,index,scope,active,type,min_value,max_value,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
