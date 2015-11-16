#' @template get_profiles
#' @include mgmt.R
#' @export
get_profile <- function(account.id, webproperty.id, profile.id, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/profiles/%s",
                    account.id, webproperty.id, profile.id)
    get_mgmt(path, token)
}

#' @template list_profiles
#' @include mgmt.R
#' @export
list_profiles = function(account.id = "~all", webproperty.id = "~all", start.index = NULL, max.results = NULL, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/profiles",
                    account.id, webproperty.id)
    list_mgmt(path, list(start.index = start.index, max.results = max.results), token)
}
