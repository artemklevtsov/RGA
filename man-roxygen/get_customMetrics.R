#' @title Custom Metrics
#' @description Get a custom metric to which the user has access.
#' @param accountId character. Account ID for the custom metric to retrieve.
#' @param customMetricId character. The ID of the custom metric to retrieve.
#' @param webPropertyId character. Web property ID for the custom metric to retrieve.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @return
#' \item{kind}{Kind value for a custom metric. Set to "analytics#customMetric". It is a read-only field.}
#' \item{id}{Custom metric ID.}
#' \item{accountId}{Account ID.}
#' \item{webPropertyId}{Property ID.}
#' \item{name}{Name of the custom metric.}
#' \item{index}{Index of the custom metric.}
#' \item{scope}{Scope of the custom metric: HIT or PRODUCT.}
#' \item{active}{Boolean indicating whether the custom metric is active.}
#' \item{type}{Data type of custom metric.}
#' \item{min_value}{Min value of custom metric.}
#' \item{max_value}{Max value of custom metric.}
#' \item{created}{Time the custom metric was created.}
#' \item{updated}{Time the custom metric was last modified.}
#' @references \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/customMetrics}{Management API - Custom Metrics Overview}
#' @family Management API
