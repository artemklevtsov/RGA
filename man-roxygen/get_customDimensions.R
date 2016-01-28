#' @title Custom Dimensions
#' @description Get a custom dimension to which the user has access.
#' @param accountId character. Account ID for the custom dimension to retrieve.
#' @param customDimensionId character. The ID of the custom dimension to retrieve.
#' @param webPropertyId character. Web property ID for the custom dimension to retrieve.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @return
#' \item{kind}{Kind value for a custom dimension. Set to "analytics#customDimension". It is a read-only field.}
#' \item{id}{Custom dimension ID.}
#' \item{accountId}{Account ID.}
#' \item{webPropertyId}{Property ID.}
#' \item{name}{Name of the custom dimension.}
#' \item{index}{Index of the custom dimension.}
#' \item{scope}{Scope of the custom dimension: HIT, SESSION, USER or PRODUCT.}
#' \item{active}{Boolean indicating whether the custom dimension is active.}
#' \item{created}{Time the custom dimension was created.}
#' \item{updated}{Time the custom dimension was last modified.}
#' @references \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/customDimensions}{Management API - Custom Dimensions Overview}
#' @family Management API
