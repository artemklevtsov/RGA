#' @title Getting help Google Analytics metadata
#'
#' @param topic a name or character string specifying the topic for which help is sought.
#' @param exact logical; exact or partial matching.
#' @param type parameter type; metrics, dimensions or all.
#' @param depricated logical; print depricated parameters or not.
#' @param select string or number; columns \code{\link{ga}} dataset to be returned.
#' @param data a dataset for search (now available only "ga").
#'
#' @return
#' Subset the \code{\link{ga}} dataset accordingly search.
#'
#' @seealso \code{\link{ga}} \code{\link{grep}} \code{\link{agrep}}
#'
#' @examples
#' help_ga("visits", select = "short")
#' help_ga("session", type = "metric", select = id)
#' help_ga(depricated = TRUE, select = c(id, replacedBy))
#' # exact matching
#' help_ga("vists", select = "short", exact = TRUE)
#' # partial matching
#' help_ga("vists", select = "short", exact = FALSE)
#'
#' @export
#'
help_ga <- function(topic, exact = TRUE, type = c("all", "metric", "dimension"),
                    depricated = FALSE, select, data = ga) {
    if (exact)
        grep.fun <- grep
    else
        grep.fun <- agrep
    if (is.character(data) && length(data) == 1L)
        data <- get(data)
    type <- match.arg(type)
    if (type != "all")
        data <- data[data$type == toupper(type), ]
    if (depricated)
        data <- data[data$status == "DEPRECATED", ]
    if (!missing(select)) {
        nl <- as.list(seq_along(data))
        names(nl) <- names(data)
        vars <- eval(substitute(select), nl, parent.frame())
    } else
        vars <- TRUE
    if (missing(topic) || is.null(topic))
        idx <- TRUE
    else {
        topic <- as.character(topic)
        if (length(topic) != 1L)
            stop("'topic' must be of length 1")
        idx <- unique(grep.fun(topic, .subset2(data, "id"), ignore.case = TRUE, fixed = FALSE),
                      grep.fun(topic, .subset2(data, "uiName"), ignore.case = TRUE, fixed = FALSE))
    }
    return(data[idx, vars])
}
