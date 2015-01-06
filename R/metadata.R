#' @title Lists all columns for a report type
#'
#' @description
#' This dataset represents all of the dimensions and metrics for the reporting API with their attributes. Attributes returned include UI name, description, segments support, etc.
#'
#' @param report.type character. Report type. Allowed Values: ga. Where ga corresponds to the Core Reporting API.
#'
#' @return A data.frame contains dimensions and metrics for a particular report type.
#' \item{id}{Parameter name.}
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
#' @seealso \code{\link{get_ga}} \code{\link{ga}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/reporting/metadata/v3/}{Google Analytics Metadata API}
#'
#' \href{https://developers.google.com/analytics/devguides/reporting/core/dimsmets}{Core Reporting API - Dimensions & Metrics Reference}
#'
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#'
#' @include url.R
#' @include request.R
#' @include convert.R
#'
#' @export
#'
#' @examples
#' \dontrun{
#' authorize(client.id = "client_id", client.secret = "client_secret")
#' ga_meta <- list_metadata("ga")
#' # a count of parameters types
#' table(ga_meta$type)
#' # parameters groups
#' table(ga_meta$group)
#' # get a deprecated parameters was replaced by
#' subset(ga_meta, status == "DEPRECATED", c(id, replacedBy))
#' # get a calculation metrics
#' subset(ga_meta, !is.na(calculation), c(id, calculation))
#' # get a not deprecated metrics from user group
#' subset(ga_meta, group == "User" & type == "METRIC" & status != "DEPRECATED", id)
#' # get parameters allowed in segments
#' subset(ga_meta, allowedInSegments, id)
#' }
#'
list_metadata <- function(report.type = "ga") {
    url <- paste(base_api_url, base_api_version, "metadata", report.type, "columns", sep = "/")
    resp <- GET(url)
    data_json <- fromJSON(content(resp, as = "text"), flatten = TRUE)
    if (!is.null(data_json$error))
        error_handler(data_json)
    data_df <- data_json$items
    data_df$kind <- NULL
    names(data_df) <- gsub("attributes.", "", names(data_df), fixed = TRUE)
    data_df$allowedInSegments <- as.logical(match(data_df$allowedInSegments, table = c(NA, "true")) - 1)
    data_df <- convert_datatypes(data_df)
    message(paste("Obtained data.frame with", nrow(data_df), "rows and", ncol(data_df), "columns."))
    return(data_df)
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
#' A data frame with 424 rows and 14 variables containing the following columns:
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
#' @seealso \code{\link{get_ga}} \code{\link{dimsmets}}
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
