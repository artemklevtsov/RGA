#' @template get_filters
#' @include mgmt.R
#' @export
get_filter <- function(account.id, filter.id, token) {
    path <- c("accounts", account.id, "filters", filter.id)
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @template list_filters
#' @include mgmt.R
#' @export
list_filters <- function(account.id, start.index = NULL, max.results = NULL, token) {
    path <- c("accounts", account.id, "filters")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,accountId,name,type,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
