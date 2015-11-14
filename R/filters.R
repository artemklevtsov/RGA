#' @template get_filters
#' @include mgmt.R
#' @export
get_filter <- function(account.id, filter.id, token) {
    path <- sprintf("management/accounts/%s/filters/%s", account.id, filter.id)
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @template list_filters
#' @include mgmt.R
#' @export
list_filters <- function(account.id, start.index = NULL, max.results = NULL, token) {
    path <- sprintf("management/accounts/%s/filters", account.id)
    query <- list(start.index = start.index, max.results = max.results)
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
