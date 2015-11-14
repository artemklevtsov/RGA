#' @template get_custom_metrics
#' @include mgmt.R
#' @export
get_custom_metric <- function(account.id, webproperty.id, custom.metric.id, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/customMetrics/%s",
                    account.id, webproperty.id, custom.metric.id)
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @template list_custom_metrics
#' @include mgmt.R
#' @export
list_custom_metrics <- function(account.id, webproperty.id, start.index = NULL, max.results = NULL, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/customMetrics",
                    account.id, webproperty.id)
    query <- list(start.index = start.index, max.results = max.results)
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
