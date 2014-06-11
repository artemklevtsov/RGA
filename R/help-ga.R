#' @title Getting help Google Analytics metadata
#'
#' @param topic a name or character string specifying the topic for which help is sought.
#' @param data a dataset for search (now available only 'ga').
#' @param type parameter type; metrics, dimensions or all.
#' @param depricated logical; print depricated parameters or not.
#' @param select columns to be returned. "all" return all columns
#'
#' @return
#' Subset \code{\link{ga}} dataset accordingly search.
#'
#' @seealso \code{\link{ga}}
#'
#' @examples
#' help_ga("visit")
#' help_ga("session", type = "metric", select = "id")
#'
#' @export

help_ga <- function(topic, data = ga, type = c("all", "metric", "dimension"), depricated = FALSE,
                    select = c("id", "uiName", "description")) {
    stopifnot(is.character(topic))
    if (is.character(data) && length(data) == 1L)
        data <- get(data)
    type <- match.arg(type)
    if (type != "all")
        data <- data[data$type == toupper(type), ]
    if (depricated)
        data <- data[data$status != "DEPRECATED", ]
    stopifnot(select %in% colnames(data), select != "all", select != "")
    if (select == "all" || !nzchar(select))
        select <- colnames(data)
    idx <- unique(agrep(topic, .subset2(data, "id"), ignore.case = TRUE, fixed = FALSE),
                  agrep(topic, .subset2(data, "uiName"), ignore.case = TRUE, fixed = FALSE))
    return(data[idx, select])
}
