#' @template list_accounts
#' @include mgmt.R
#' @export
list_accounts = function(start.index = NULL, max.results = NULL, token) {
    path <- "accounts"
    query <- list(start.index = start.index, max.results = max.results,
                  fields = "items(id,name,permissions/effective,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
