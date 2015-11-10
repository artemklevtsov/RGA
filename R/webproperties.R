#' @template get_webproperties
#' @include mgmt.R
#' @export
get_webproperty <- function(account.id, webproperty.id, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id)
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @template list_webproperties
#' @include mgmt.R
#' @export
list_webproperties = function(account.id = "~all", start.index = NULL, max.results = NULL, token) {
    path <- c("accounts", account.id, "webproperties")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,accountId,name,websiteUrl,level,industryVertical,defaultProfileId,permissions/effective,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
