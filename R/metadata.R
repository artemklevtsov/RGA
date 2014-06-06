#' @title Lists all columns for a report type
#'
#' @param report.type report type (now allowed only 'ga').
#'
#' @return A data frame with metadata information.
#'
#' @references
#' Dimensions & Metrics Reference: \url{https://developers.google.com/analytics/devguides/reporting/core/dimsmets}
#'
#' @examples
#' ga_meta <- get_metadata()
#' names(ga_meta)
#' table(ga_meta$status)
#' table(ga_meta$type)
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
