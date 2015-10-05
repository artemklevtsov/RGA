#' @title Gets a upload to which the user has access to
#'
#' @param account.id Account Id for the upload to retrieve.
#' @param webproperty.id Web property Id for the upload to retrieve.
#' @param custom.data.source.id Custom data source Id for upload to retrieve.
#' @param upload.id Upload Id to retrieve.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return Metadata returned for an upload operation.
#' \item{id}{A unique ID for this upload.}
#' \item{account.id}{Account Id to which this upload belongs.}
#' \item{custom.data.source.id}{Custom data source Id to which this data import belongs.}
#' \item{status}{Upload status. Possible values: PENDING, COMPLETED, FAILED, DELETING, DELETED.}
#' \item{errors}{Data import errors collection.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/uploads}{Management API - Uploads}
#'
#' @family Management API
#'
#' @include mgmt.R
#'
#' @export
#'
get_upload <- function(account.id, webproperty.id, custom.data.source.id, upload.id, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id, "customDataSources", custom.data.source.id, "uploads", upload.id)
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @title Lists uploads to which the user has access to
#'
#' @param account.id Account Id for the uploads to retrieve.
#' @param webproperty.id Web property Id for the uploads to retrieve.
#' @param custom.data.source.id Custom data source Id for uploads to retrieve.
#' @param max.results The maximum number of uploads to include in this response.
#' @param start.index A 1-based index of the first upload to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return Upload collection lists Analytics uploads to which the user has access. Each custom data source can have a set of uploads. Each resource in the upload collection corresponds to a single Analytics data upload.
#' \item{id}{A unique ID for this upload.}
#' \item{account.id}{Account Id to which this upload belongs.}
#' \item{custom.data.source.id}{Custom data source Id to which this data import belongs.}
#' \item{status}{Upload status. Possible values: PENDING, COMPLETED, FAILED, DELETING, DELETED.}
#' \item{errors}{Data import errors collection.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/uploads}{Management API - Uploads}
#'
#' @family Management API
#'
#' @include mgmt.R
#'
#' @export
#'
list_uploads <- function(account.id, webproperty.id, custom.data.source.id, start.index = NULL, max.results = NULL, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id, "customDataSources", custom.data.source.id, "uploads")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,accountId,customDataSourceId,status,errors)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
