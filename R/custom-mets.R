#' @template get_custom_metrics
#' @include mgmt.R
#' @export
get_custom_metric <- function(account.id, webproperty.id, custom.metric.id, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/customMetrics/%s",
                    account.id, webproperty.id, custom.metric.id)
    get_mgmt(path, token)
}

#' @template list_custom_metrics
#' @include mgmt.R
#' @export
list_custom_metrics <- function(account.id, webproperty.id, start.index = NULL, max.results = NULL, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/customMetrics",
                    account.id, webproperty.id)
    list_mgmt(path, list(start.index = start.index, max.results = max.results), token)
}
