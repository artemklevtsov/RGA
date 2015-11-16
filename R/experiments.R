#' @template get_experiments
#' @include mgmt.R
#' @export
get_experiment <- function(account.id, webproperty.id, profile.id, experiment.id, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/profiles/%s/experiments/%s",
                    account.id, webproperty.id, profile.id, experiment.id)
    get_mgmt(path, token)
}

#' @template list_experiments
#' @include mgmt.R
#' @export
list_experiments <- function(account.id, webproperty.id, profile.id, start.index = NULL, max.results = NULL, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/profiles/%s/experiments",
                    account.id, webproperty.id, profile.id)
    list_mgmt(path, list(start.index = start.index, max.results = max.results), token)
}
