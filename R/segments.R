#' @template list_segments
#' @include mgmt.R
#' @export
list_segments = function(start.index = NULL, max.results = NULL, token) {
    path <- "segments"
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,segmentId,name,definition,type,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
