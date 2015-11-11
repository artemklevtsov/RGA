#' @title Custom Metrics
#' @description Get a custom metric to which the user has access.
#' @param account.id character. Account ID for the custom metric to retrieve.
#' @param custom.metric.id character. The ID of the custom metric to retrieve.
#' @param webproperty.id character. Web property ID for the custom metric to retrieve.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @return
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
#' @references \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/customMetrics}{Management API - Custom Metrics Overview}
#' @family Management API
