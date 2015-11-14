#' @template get_custom_dimensions
#' @include mgmt.R
#' @export
get_custom_dimension <- function(account.id, webproperty.id, custom.dimension.id, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/customDimensions/%s",
                    account.id, webproperty.id, custom.dimension.id)
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @template list_custom_dimensions
#' @include mgmt.R
#' @export
list_custom_dimensions <- function(account.id, webproperty.id, start.index = NULL, max.results = NULL, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/customDimensions",
                    account.id, webproperty.id)
    query <- list(start.index = start.index, max.results = max.results)
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
