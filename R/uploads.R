#' @template get_uploads
#' @include mgmt.R
#' @export
get_upload <- function(account.id, webproperty.id, custom.data.source.id, upload.id, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/customDataSources/%s/uploads/%s",
                    account.id, webproperty.id, custom.data.source.id, upload.id)
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @template list_uploads
#' @include mgmt.R
#' @export
list_uploads <- function(account.id, webproperty.id, custom.data.source.id, start.index = NULL, max.results = NULL, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/customDataSources/%s/uploads",
                    account.id, webproperty.id, custom.data.source.id)
    query <- list(start.index = start.index, max.results = max.results)
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
