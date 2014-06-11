#' @title Lists all columns for a Google Analytics core report type.
#'
#' @usage
#' ga
#'
#' @format
#' A data frame with 321 rows and 14 variables  containing the following columns:
#' \describe{
#'     \item{id}{Parameter name.}
#'     \item{type}{The type of column: \code{DIMENSION}, \code{METRIC}.}
#'     \item{dataType}{The type of data this column represents: \code{STRING}, \code{INTEGER}, \code{PERCENT}, \code{TIME}, \code{CURRENCY}, \code{FLOAT}.}
#'     \item{group}{The dimensions/metrics group the column belongs to.}
#'     \item{status}{The status of the column: \code{PUBLIC}, \code{DEPRECATED}.}
#'     \item{uiName}{The name/label of the column used in user interfaces (UI).}
#'     \item{description}{The full description of the column.}
#'     \item{allowedInSegments}{Indicates whether the column can be used in the segment query parameter.}
#'     \item{replacedBy}{The replacement column to use for a column with a \code{DEPRECATED} status.}
#'     \item{calculation}{Only available for calculated metrics. This shows how the metric is calculated.}
#'     \item{minTemplateIndex}{Only available for templatized columns. This is the minimum index for the column.}
#'     \item{maxTemplateIndex}{Only available for templatized columns. This is the maximum index for the column.}
#'     \item{premiumMinTemplateIndex}{Only available for templatized columns. This is the minimum index for the column for premium properties.}
#'     \item{premiumMaxTemplateIndex}{Only available for templatized columns. This is the maximum index for the column for premium properties.}
#' }
#'
#' @references
#' Dimensions & Metrics Reference: \url{https://developers.google.com/analytics/devguides/reporting/core/dimsmets}
#'
#' @keywords data datasets
#' @docType data
#' @name ga
#'
#' @examples
#' # get depricated ids
#' subset(ga, subset = status == "DEPRECATED", select = c(id, replacedBy))
#' # get not depricated metrics from user group
#' subset(ga, subset = group == "User" & type == "METRIC" & status != "DEPRECATED", select = id)
NULL
