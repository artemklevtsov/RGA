#' @title Gets a single unsampled report
#'
#' @param account.id integer or character. Account ID to retrieve unsampled report for.
#' @param webproperty.id integer or character. Web property ID to retrieve unsampled reports for.
#' @param profile.id integer or character. View (Profile) ID to retrieve unsampled report for.
#' @param unsampled.report.id integer or character. Web property ID to retrieve unsampled reports for.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return An Analytics unsampled report.
#' \item{id}{Unsampled report ID.}
#' \item{kind}{Resource type for an Analytics unsampled report.}
#' \item{self.link}{Link for this unsampled report.}
#' \item{title}{Title of the unsampled report.}
#' \item{account.id}{Account ID to which this unsampled report belongs.}
#' \item{webproperty.id}{Web property ID to which this unsampled report belongs. The web property ID is of the form UA-XXXXX-YY.}
#' \item{profile.id}{View (Profile) ID to which this unsampled report belongs.}
#' \item{start-date}{The start date for the unsampled report.}
#' \item{end-date}{The end date for the unsampled report.}
#' \item{metrics}{The metrics for the unsampled report.}
#' \item{dimensions}{The dimensions for the unsampled report.}
#' \item{filters}{The filters for the unsampled report.}
#' \item{segment}{The segment for the unsampled report.}
#' \item{status}{Status of this unsampled report.  Possible values are PENDING, COMPLETED, or FAILED.}
#' \item{download.type}{The type of download you need to use for the report data file.}
#' \item{drive.download.details}{Download details for a file stored in Google Drive.}
#' \item{cloud.storage.download.details}{Download details for a file stored in Google Cloud Storage.}
#' \item{created}{Time this unsampled report was created.}
#' \item{updated}{Time this unsampled report was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/unsampledReports}{Management API - Unsampled Reports}
#'
#' @family Management API
#'
#' @include mgmt.R
#'
#' @export
#'
get_unsampled_report <- function(account.id, webproperty.id, profile.id, unsampled.report.id, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "unsampledReports", unsampled.report.id)
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @title Lists unsampled reports which the user has access to
#'
#' @param account.id integer or character. The account ID to retrieve unsampled reports for. Must be a specific account ID, ~all is not supported.
#' @param webproperty.id character. Web property ID to retrieve unsampled reports for. Must be a specific web property ID, ~all is not supported. Requires specified \code{account.id}.
#' @param profile.id ineger or character. View (Profile) ID to retrieve unsampled reports for. Must be a specific view (profile) ID, ~all is not supported. Requires specified \code{account.id} and \code{webproperty.id}.
#' @param start.index integer. An index of the first unsampled report to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of unsampled reports to include in this response.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return An unsampled report collection lists Analytics unsampled reports to which the user has access. Each view (profile) can have a set of unsampled reports. Each resource in the unsampled report collection corresponds to a single Analytics unsampled report.
#' \item{id}{Unsampled report ID.}
#' \item{title}{Title of the unsampled report.}
#' \item{account.id}{Account ID to which this unsampled report belongs.}
#' \item{webproperty.id}{Web property ID to which this unsampled report belongs. The web property ID is of the form UA-XXXXX-YY.}
#' \item{profile.id}{View (Profile) ID to which this unsampled report belongs.}
#' \item{start-date}{The start date for the unsampled report.}
#' \item{end-date}{The end date for the unsampled report.}
#' \item{metrics}{The metrics for the unsampled report.}
#' \item{dimensions}{The dimensions for the unsampled report.}
#' \item{filters}{The filters for the unsampled report.}
#' \item{segment}{The segment for the unsampled report.}
#' \item{status}{Status of this unsampled report. Possible values are PENDING, COMPLETED, or FAILED.}
#' \item{download.type}{The type of download you need to use for the report data file.}
#' \item{created}{Time this unsampled report was created.}
#' \item{updated}{Time this unsampled report was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/unsampledReports}{Management API - Unsampled Reports}
#'
#' @family Management API
#'
#' @include mgmt.R
#'
#' @export
#'
list_unsampled_reports <- function(account.id, webproperty.id, profile.id, start.index = NULL, max.results = NULL, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "unsampledReports")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,title,accountId,webPropertyId,profileId,start-date,end-date,metrics,dimensions,filters,segment,status,downloadType,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
