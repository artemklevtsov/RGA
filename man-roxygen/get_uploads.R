#' @title Uploads
#' @description List uploads to which the user has access.
#' @param account.id character. Account Id for the upload to retrieve.
#' @param custom.data.source.id character. Custom data source Id for upload to retrieve.
#' @param upload.id character. Upload Id to retrieve.
#' @param webproperty.id character. Web property Id for the upload to retrieve.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @return The Uploads collection is a set of Upload resources, each of which describes an upload for one of the user's custom data sources. This resource should be used when uploading Dimension Widening data.
#' \item{id}{A unique ID for this upload.}
#' \item{kind}{Resource type for Analytics upload.}
#' \item{account.id}{Account Id to which this upload belongs.}
#' \item{custom.data.source.id}{Custom data source Id to which this data import belongs.}
#' \item{status}{Upload status. Possible values: PENDING, COMPLETED, FAILED, DELETING, DELETED.}
#' \item{errors}{Data import errors collection.}
#' @references \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/uploads}{Management API - Uploads Overview}
#' @family Management API
