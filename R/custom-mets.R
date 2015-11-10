#' @template get_custom_metrics
#' @include mgmt.R
#' @export
get_custom_metric <- function(account.id, webproperty.id, custom.metric.id, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id, "customMetrics", metric.id)
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @template list_custom_metrics
#' @include mgmt.R
#' @export
list_custom_metrics <- function(account.id, webproperty.id, start.index = NULL, max.results = NULL, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id, "customMetrics")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,accountId,webPropertyId,name,index,scope,active,type,min_value,max_value,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
