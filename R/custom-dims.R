#' @title Custom Dimensions
#'
#' @description Gets a custom dimension to which the user has access to.
#'
#' @param account.id Account ID for the custom dimension to retrieve.
#' @param webproperty.id Web property ID for the custom dimension to retrieve.
#' @param dimension.id The ID of the custom dimension to retrieve.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return An Analytics custom dimension.
#' \item{kind}{Kind value for a custom dimension. Set to "analytics#customDimension". It is a read-only field.}
#' \item{id}{Custom dimension ID.}
#' \item{account.id}{Account ID.}
#' \item{webproperty.id}{Property ID.}
#' \item{name}{Name of the custom dimension.}
#' \item{index}{Index of the custom dimension.}
#' \item{scope}{Scope of the custom dimension: HIT, SESSION, USER or PRODUCT.}
#' \item{active}{Boolean indicating whether the custom dimension is active.}
#' \item{created}{Time the custom dimension was created.}
#' \item{updated}{Time the custom dimension was last modified.}
#' \item{self.link}{Link for the custom dimension}
#' \item{parent.link}{Parent link for the custom dimension. Points to the property to which the custom dimension belongs.}
#' \item{parent.link.type}{Type of the parent link. Set to "analytics#webproperty".}
#' \item{parent.link.href}{Link to the property to which the custom dimension belongs.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/customDimensions}{Management API - Custom Dimensions}
#'
#' @family Management API
#'
#' @include mgmt.R
#'
#' @export
#'
get_custom_dimension <- function(account.id, webproperty.id, dimension.id, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id, "customDimensions", dimension.id)
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @title Custom Dimensions
#'
#' @description Lists custom dimensions to which the user has access to.
#'
#' @param account.id Account ID for the custom dimensions to retrieve.
#' @param webproperty.id Web property ID for the custom dimensions to retrieve.
#' @param max.results The maximum number of custom dimensions to include in this response.
#' @param start.index An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return An Analytics custom dimension.
#' \item{id}{Custom dimension ID.}
#' \item{account.id}{Account ID.}
#' \item{webproperty.id}{Property ID.}
#' \item{name}{Name of the custom dimension.}
#' \item{index}{Index of the custom dimension.}
#' \item{scope}{Scope of the custom dimension: HIT, SESSION, USER or PRODUCT.}
#' \item{active}{Boolean indicating whether the custom dimension is active.}
#' \item{created}{Time the custom dimension was created.}
#' \item{updated}{Time the custom dimension was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/customDimensions}{Management API - Custom Dimensions}
#'
#' @family Management API
#'
#' @include mgmt.R
#'
#' @export
#'
list_custom_dimensions <- function(account.id, webproperty.id, start.index = NULL, max.results = NULL, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id, "customDimensions")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,accountId,webPropertyId,name,index,scope,active,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
