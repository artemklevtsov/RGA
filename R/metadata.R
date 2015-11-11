#' @title Lists all the dimensions and metrics for a particular report type
#'
#' @description
#' This dataset represents all of the dimensions and metrics for the reporting API with their attributes. Attributes returned include UI name, description, segments support, etc.
#'
#' @param report.type character. Report type. Allowed Values: "ga". Where "ga" corresponds to the Core Reporting API.
#'
#' @return A data.frame contains dimensions and metrics for a particular report type.
#' \item{id}{Parameter name.}
#' \item{type}{The type of column: \code{DIMENSION}, \code{METRIC}.}
#' \item{data.type}{The type of data this column represents: \code{STRING}, \code{INTEGER}, \code{PERCENT}, \code{TIME}, \code{CURRENCY}, \code{FLOAT}.}
#' \item{group}{The dimensions/metrics group the column belongs to.}
#' \item{status}{The status of the column: \code{PUBLIC}, \code{DEPRECATED}.}
#' \item{ui.name}{The name/label of the column used in user interfaces (UI).}
#' \item{description}{The full description of the column.}
#' \item{allowed.in.segments }{Indicates whether the column can be used in the segment query parameter.}
#' \item{replaced.by}{The replacement column to use for a column with a \code{DEPRECATED} status.}
#' \item{calculation}{Only available for calculated metrics. This shows how the metric is calculated.}
#' \item{min.template.index}{Only available for templatized columns. This is the minimum index for the column.}
#' \item{max.template.index}{Only available for templatized columns. This is the maximum index for the column.}
#' \item{premium.min.template.index}{Only available for templatized columns. This is the minimum index for the column for premium properties.}
#' \item{premium.max.template.index}{Only available for templatized columns. This is the maximum index for the column for premium properties.}
#'
#' @seealso \code{\link{shiny_dimsmets}} \code{\link{get_ga}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/reporting/metadata/v3/}{Google Analytics Metadata API}
#'
#' \href{https://developers.google.com/analytics/devguides/reporting/core/dimsmets}{Core Reporting API - Dimensions & Metrics Reference}
#'
#' @include url.R
#' @include request.R
#' @include utils.R
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ga_meta <- list_dimsmets("ga")
#' # a count of parameters types
#' table(ga_meta$type)
#' # parameters groups
#' table(ga_meta$group)
#' # get a deprecated parameters was replaced by
#' subset(ga_meta, status == "DEPRECATED", c(id, replaced.by))
#' # get a calculation metrics
#' subset(ga_meta, !is.na(calculation), c(id, calculation))
#' # get a not deprecated metrics from user group
#' subset(ga_meta, group == "User" & type == "METRIC" & status != "DEPRECATED", id)
#' # get parameters allowed in segments
#' subset(ga_meta, allowed.in.segments, id)
#' }
#'
list_dimsmets <- function(report.type = "ga") {
    url <- get_url(c("metadata", report.type, "columns"))
    response <- httr::GET(url)
    json_content <- process(response)
    res <- json_content$items
    res$kind <- NULL
    res <- convert_types.data.frame(res)
    names(res) <- to_separated(gsub("attributes.", "", names(res), fixed = TRUE), ".")
    return(res)
}

#' @title The Shiny Dimensions & Metrics Explorer
#'
#' @description
#' The dimensions and metrics explorer lists and describes all the dimensions and metrics available through the Core Reporting API. This app deployed to the \url{https://artemklevtsov.shinyapps.io/ga-dimsmets}.
#'
#' @seealso \code{\link{list_dimsmets}} \code{\link{get_ga}}
#'
#' @export
#'
shiny_dimsmets <- function() {
    appDir <- system.file("shiny-examples", "01-dimsmets", package = "RGA")
    if (appDir == "")
        stop("Could not find example directory. Try re-installing 'RGA' package.", call. = FALSE)
    shiny::runApp(appDir, display.mode = "normal")
}

#' @title Lists all columns for a Google Analytics core report type
#'
#' @usage
#' ga
#'
#' @description
#' This dataset represents all of the dimensions and metrics for the reporting API with their attributes. Attributes returned include UI name, description, segments support, etc.
#'
#' @format
#' A data frame with 436 rows and 14 variables containing the following columns:
#' \describe{
#' \item{id}{Parameter name.}
#' \item{type}{The type of column: \code{DIMENSION}, \code{METRIC}.}
#' \item{data.type}{The type of data this column represents: \code{STRING}, \code{INTEGER}, \code{PERCENT}, \code{TIME}, \code{CURRENCY}, \code{FLOAT}.}
#' \item{group}{The dimensions/metrics group the column belongs to.}
#' \item{status}{The status of the column: \code{PUBLIC}, \code{DEPRECATED}.}
#' \item{ui.name}{The name/label of the column used in user interfaces (UI).}
#' \item{description}{The full description of the column.}
#' \item{allowed.in.segments}{Indicates whether the column can be used in the segment query parameter.}
#' \item{replaced.by}{The replacement column to use for a column with a \code{DEPRECATED} status.}
#' \item{calculation}{Only available for calculated metrics. This shows how the metric is calculated.}
#' \item{min.template.index}{Only available for templatized columns. This is the minimum index for the column.}
#' \item{max.template.index}{Only available for templatized columns. This is the maximum index for the column.}
#' \item{premium.min.template.index}{Only available for templatized columns. This is the minimum index for the column for premium properties.}
#' \item{premium.max.template.index}{Only available for templatized columns. This is the maximum index for the column for premium properties.}
#' }
#'
#' @source \url{https://www.googleapis.com/analytics/v3/metadata/ga/columns?pp=1}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/reporting/metadata/v3/}{Google Analytics Metadata API}
#'
#' \href{https://developers.google.com/analytics/devguides/reporting/core/dimsmets}{Core Reporting API - Dimensions & Metrics Reference}
#'
#' @keywords data datasets
#' @docType data
#' @name ga
#'
#' @seealso \code{\link{get_ga}} \code{\link{list_dimsmets}}
#'
#' @examples
#' # a count of parameters types
#' table(ga$type)
#' # parameters groups
#' table(ga$group)
#' # get a deprecated parameters was replaced by
#' subset(ga, status == "DEPRECATED", c(id, replaced.by))
#' # get a calculation metrics
#' subset(ga, !is.na(calculation), c(id, calculation))
#' # get a not deprecated metrics from user group
#' subset(ga, group == "User" & type == "METRIC" & status != "DEPRECATED", id)
#' # get parameters allowed in segments
#' subset(ga, allowed.in.segments, id)
NULL
