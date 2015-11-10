#' @template get_uploads
#' @include mgmt.R
#' @export
get_upload <- function(account.id, webproperty.id, custom.data.source.id, upload.id, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id, "customDataSources", custom.data.source.id, "uploads", upload.id)
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @template list_uploads
#' @include mgmt.R
#' @export
list_uploads <- function(account.id, webproperty.id, custom.data.source.id, start.index = NULL, max.results = NULL, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id, "customDataSources", custom.data.source.id, "uploads")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,accountId,customDataSourceId,status,errors)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
