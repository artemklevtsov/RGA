#' @template list_custom_data_sources
#' @include mgmt.R
#' @export
list_custom_data_sources <- function(account.id, webproperty.id, start.index = NULL, max.results = NULL, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id, "customDataSources")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,accountId,webPropertyId,name,description,type,uploadType,importBehavior,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
