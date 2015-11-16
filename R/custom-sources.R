#' @template list_custom_data_sources
#' @include mgmt.R
#' @export
list_custom_data_sources <- function(account.id, webproperty.id, start.index = NULL, max.results = NULL, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/customDataSources",
                    account.id, webproperty.id)
    list_mgmt(path, list(start.index = start.index, max.results = max.results), token)
}
