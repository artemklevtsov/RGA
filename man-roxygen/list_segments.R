#' @title Segments
#' @description Lists segments to which the user has access.
#' @param max.results integer. The maximum number of segments to include in this response.
#' @param start.index integer. An index of the first segment to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @return The Segments collection is a set of Segment resources, each of which describes one of the user's default advanced segments or custom segments.
#' \item{id}{Segment ID.}
#' \item{kind}{Resource type for Analytics segment.}
#' \item{segmentId}{Segment ID. Can be used with the 'segment' parameter in Core Reporting API.}
#' \item{name}{Segment name.}
#' \item{definition}{Segment definition.}
#' \item{type}{Type for a segment. Possible values are "BUILT_IN" or "CUSTOM".}
#' \item{created}{Time the segment was created.}
#' \item{updated}{Time the segment was last modified.}
#' @references \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/segments}{Management API - Segments Overview}
#' @family Management API
