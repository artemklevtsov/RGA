#' @title Custom Dimensions
#' 
#' @description Lists custom dimensions to which the user has access.
#' 
#' @param account.id character. Account ID for the custom dimensions to retrieve.
#' @param webproperty.id character. Web property ID for the custom dimensions to retrieve.
#' @param max.results integer. The maximum number of custom dimensions to include in this response.
#' @param start.index integer. An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' 
#' @return 
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
#' 
#' @references \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/customDimensions}{Management API - Custom Dimensions Overview}
#' 
#' @family Management API
