#' @title Lists segments which the user has access to
#'
#' @param start.index integer. An index of the first segment to retrieve. Use this parameter as a pagi- nation mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of segments to include in this response.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return An segment collection lists Analytics segments that the user has access to. Each resource in the collection corresponds to a single Analytics segment.
#' \item{id}{Segment ID.}
#' \item{segment.id}{Segment ID. Can be used with the segment parameter in Data Feed.}
#' \item{name}{Segment name.}
#' \item{definition}{Segment definition.}
#' \item{type}{Type for a segment. Possible values are "BUILT_IN" or "CUSTOM".}
#' \item{created}{time the segment was created.}
#' \item{updated}{time the segment was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/segments}{Management API - Segments}
#'
#' \href{https://developers.google.com/analytics/devguides/reporting/core/v3/segments}{Core Reporting API - Segments}
#'
#' @family Management API
#'
#' @include mgmt.R
#'
#' @export
#'
list_segments = function(start.index = NULL, max.results = NULL, token) {
    path <- "segments"
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,segmentId,name,definition,type,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
