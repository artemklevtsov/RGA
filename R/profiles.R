#' @template get_profiles
#' @include mgmt.R
#' @export
get_profile <- function(account.id, webproperty.id, profile.id, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id)
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @template list_profiles
#' @include mgmt.R
#' @export
list_profiles = function(account.id = "~all", webproperty.id = "~all", start.index = NULL, max.results = NULL, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id, "profiles")
    query <- list(start.index = start.index, max.results = max.results,
                  fields = "items(id,accountId,webPropertyId,name,currency,timezone,websiteUrl,type,eCommerceTracking,permissions/effective,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
