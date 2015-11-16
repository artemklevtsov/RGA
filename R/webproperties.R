#' @template get_webproperties
#' @include mgmt.R
#' @export
get_webproperty <- function(account.id, webproperty.id, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s",
                    account.id, webproperty.id)
    get_mgmt(path, token)
}

#' @template list_webproperties
#' @include mgmt.R
#' @export
list_webproperties = function(account.id = "~all", start.index = NULL, max.results = NULL, token) {
    path <- sprintf("management/accounts/%s/webproperties", account.id)
    list_mgmt(path, list(start.index = start.index, max.results = max.results), token)
}
