#' @title Unsampled Reports
#' @description Lists unsampled reports to which the user has access.
#' @param accountId character. Account ID to retrieve unsampled reports for. Must be a specific account ID, ~all is not supported.
#' @param profileId character. View (Profile) ID to retrieve unsampled reports for. Must be a specific view (profile) ID, ~all is not supported.
#' @param webPropertyId character. Web property ID to retrieve unsampled reports for. Must be a specific web property ID, ~all is not supported.
#' @param max.results integer. The maximum number of unsampled reports to include in this response.
#' @param start.index integer. An index of the first unsampled report to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @return
#' \item{id}{Unsampled report ID.}
#' \item{kind}{Resource type for an Analytics unsampled report.}
#' \item{title}{Title of the unsampled report.}
#' \item{accountId}{Account ID to which this unsampled report belongs.}
#' \item{webPropertyId}{Web property ID to which this unsampled report belongs. The web property ID is of the form UA-XXXXX-YY.}
#' \item{profileId}{View (Profile) ID to which this unsampled report belongs.}
#' \item{start.date}{The start date for the unsampled report.}
#' \item{end.date}{The end date for the unsampled report.}
#' \item{metrics}{The metrics for the unsampled report.}
#' \item{dimensions}{The dimensions for the unsampled report.}
#' \item{filters}{The filters for the unsampled report.}
#' \item{segment}{The segment for the unsampled report.}
#' \item{status}{Status of this unsampled report.  Possible values are PENDING, COMPLETED, or FAILED.}
#' \item{downloadType}{The type of download you need to use for the report data file. Possible values include `GOOGLE_DRIVE` and `GOOGLE_CLOUD_STORAGE`. If the value is `GOOGLE_DRIVE`, see the `driveDownloadDetails` field. If the value is `GOOGLE_CLOUD_STORAGE`, see the `cloudStorageDownloadDetails` field.}
#' \item{driveDownloadDetails}{Download details for a file stored in Google Drive.}
#' \item{cloudStorageDownloadDetails}{Download details for a file stored in Google Cloud Storage.}
#' \item{created}{Time this unsampled report was created.}
#' \item{updated}{Time this unsampled report was last modified.}
#' \item{driveDownloadDetails.documentId}{Id of the document/file containing the report data.}
#' \item{cloudStorageDownloadDetails.bucketId}{Id of the bucket the file object is stored in.}
#' \item{cloudStorageDownloadDetails.objectId}{Id of the file object containing the report data.}
#' @references \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/unsampledReports}{Management API - Unsampled Reports Overview}
#' @family Management API
