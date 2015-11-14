#' @template list_accounts
#' @include mgmt.R
#' @export
list_accounts = function(start.index = NULL, max.results = NULL, token) {
    path <- "management/accounts"
    query <- list(start.index = start.index, max.results = max.results)
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
