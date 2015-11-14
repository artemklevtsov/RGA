#' @template get_webproperties
#' @include mgmt.R
#' @export
get_webproperty <- function(account.id, webproperty.id, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s",
                    account.id, webproperty.id)
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @template list_webproperties
#' @include mgmt.R
#' @export
list_webproperties = function(account.id = "~all", start.index = NULL, max.results = NULL, token) {
    path <- sprintf("management/accounts/%s/webproperties", account.id)
    query <- list(start.index = start.index, max.results = max.results)
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
