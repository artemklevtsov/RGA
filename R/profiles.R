#' @template get_profiles
#' @include mgmt.R
#' @export
get_profile <- function(account.id, webproperty.id, profile.id, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/profiles/%s",
                    account.id, webproperty.id, profile.id)
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @template list_profiles
#' @include mgmt.R
#' @export
list_profiles = function(account.id = "~all", webproperty.id = "~all", start.index = NULL, max.results = NULL, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/profiles",
                    account.id, webproperty.id)
    query <- list(start.index = start.index, max.results = max.results)
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
