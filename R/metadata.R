#' @title Lists all columns for a report type
#'
#' @param report.type report type (now allowed only 'ga').
#'
#' @return A data frame with metadata information.
#' \item{ids}{Parameter name.}
#' \item{type}{The type of column: \code{DIMENSION}, \code{METRIC}.}
#' \item{dataType}{The type of data this column represents: \code{STRING}, \code{INTEGER}, \code{PERCENT}, \code{TIME}, \code{CURRENCY}, \code{FLOAT}.}
#' \item{group}{The dimensions/metrics group the column belongs to.}
#' \item{status}{The status of the column: \code{PUBLIC}, \code{DEPRECATED}.}
#' \item{uiName}{The name/label of the column used in user interfaces (UI).}
#' \item{description}{The full description of the column.}
#' \item{allowedInSegments}{Indicates whether the column can be used in the segment query parameter.}
#' \item{replacedBy}{The replacement column to use for a column with a \code{DEPRECATED} status.}
#' \item{calculation}{Only available for calculated metrics. This shows how the metric is calculated.}
#' \item{minTemplateIndex}{Only available for templatized columns. This is the minimum index for the column.}
#' \item{maxTemplateIndex}{Only available for templatized columns. This is the maximum index for the column.}
#' \item{premiumMinTemplateIndex}{Only available for templatized columns. This is the minimum index for the column for premium properties.}
#' \item{premiumMaxTemplateIndex}{Only available for templatized columns. This is the maximum index for the column for premium properties.}
#'
#' @references
#' Dimensions & Metrics Reference: \url{https://developers.google.com/analytics/devguides/reporting/core/dimsmets}
#'
#' @examples
#' # get GA metadata
#' ga_meta <- get_metadata()
#' # get column names
#' names(ga_meta)
#' table(ga_meta$type)
#' # get depricated ids
#' subset(ga_meta, subset = status == "DEPRECATED", select = c(ids, replacedBy))
#' # get nit depricated metrics from user group
#' subset(ga_meta, subset = group == "User" & type == "METRIC" & status != "DEPRECATED", select = ids)
#'
#' @include api-request.R
#'
#' @export
#'
get_metadata <- function(report.type = "ga") {
    stopifnot(is.character(report.type) && length(report.type) == 1L)
    url <- paste("https://www.googleapis.com/analytics/v3/metadata", report.type, "columns", sep = "/")
    data.json <- get_api_request(url)
    ids <- data.json$items$id
    attrs <- data.json$items$attributes
    data.r <- cbind(ids, attrs)
    return(data.r)
}
