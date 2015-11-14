#' @template list_segments
#' @include mgmt.R
#' @export
list_segments = function(start.index = NULL, max.results = NULL, token) {
    path <- "management/segments"
    query <- list(start.index = start.index, max.results = max.results)
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
