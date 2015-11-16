#' @template get_filters
#' @include mgmt.R
#' @export
get_filter <- function(account.id, filter.id, token) {
    path <- sprintf("management/accounts/%s/filters/%s", account.id, filter.id)
    get_mgmt(path, token)
}

#' @template list_filters
#' @include mgmt.R
#' @export
list_filters <- function(account.id, start.index = NULL, max.results = NULL, token) {
    path <- sprintf("management/accounts/%s/filters", account.id)
    list_mgmt(path, list(start.index = start.index, max.results = max.results), token)
}
