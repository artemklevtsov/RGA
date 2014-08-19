#' @title Lists all columns for a Google Analytics core report type
#'
#' @usage
#' ga
#'
#' @description
#' This dataset represents all of the dimensions and metrics for the reporting API with their attributes. Attributes returned include UI name, description, segments support, etc.
#'
#' @format
#' A data frame with 321 rows and 14 variables containing the following columns:
#' \describe{
#'   \item{id}{Parameter name.}
#'   \item{type}{The type of column: \code{DIMENSION}, \code{METRIC}.}
#'   \item{dataType}{The type of data this column represents: \code{STRING}, \code{INTEGER}, \code{PERCENT}, \code{TIME}, \code{CURRENCY}, \code{FLOAT}.}
#'   \item{group}{The dimensions/metrics group the column belongs to.}
#'   \item{status}{The status of the column: \code{PUBLIC}, \code{DEPRECATED}.}
#'   \item{uiName}{The name/label of the column used in user interfaces (UI).}
#'   \item{description}{The full description of the column.}
#'   \item{allowedInSegments}{Indicates whether the column can be used in the segment query parameter.}
#'   \item{replacedBy}{The replacement column to use for a column with a \code{DEPRECATED} status.}
#'   \item{calculation}{Only available for calculated metrics. This shows how the metric is calculated.}
#'   \item{minTemplateIndex}{Only available for templatized columns. This is the minimum index for the column.}
#'   \item{maxTemplateIndex}{Only available for templatized columns. This is the maximum index for the column.}
#'   \item{premiumMinTemplateIndex}{Only available for templatized columns. This is the minimum index for the column for premium properties.}
#'   \item{premiumMaxTemplateIndex}{Only available for templatized columns. This is the maximum index for the column for premium properties.}
#' }
#'
#' @source \url{https://www.googleapis.com/analytics/v3/metadata/ga/columns?pp=1}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/reporting/metadata/v3/}{Google Analytics Metadata API}
#'
#' \href{https://developers.google.com/analytics/devguides/reporting/core/dimsmets}{Dimensions & Metrics Reference}
#'
#' @keywords data datasets
#' @docType data
#' @name ga
#'
#' @export ga
#'
#' @seealso
#' \code{show_dimsmets(ga)}
#'
#' @examples
#' # a count of parameters types
#' table(ga$type)
#' # parameters groups
#' table(ga$group)
#' # get a deprecated parameters was replaced by
#' subset(ga, status == "DEPRECATED", c(id, replacedBy))
#' # get a calculation metrics
#' subset(ga, !is.na(calculation), c(id, calculation))
#' # get a not deprecated metrics from user group
#' subset(ga, group == "User" & type == "METRIC" & status != "DEPRECATED", id)
#' # get parameters allowed in segments
#' subset(ga, allowedInSegments, id)
NULL
