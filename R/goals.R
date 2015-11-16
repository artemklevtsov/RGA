#' @template get_goals
#' @include mgmt.R
#' @export
get_goal <- function(account.id, webproperty.id, profile.id, goal.id, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/profiles/%s/goals/%s",
                    account.id, webproperty.id, profile.id, goal.id)
    get_mgmt(path, token)
}

#' @template list_goals
#' @include mgmt.R
#' @export
list_goals = function(account.id = "~all", webproperty.id = "~all", profile.id = "~all", start.index = NULL, max.results = NULL, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/profiles/%s/goals",
                    account.id, webproperty.id, profile.id)
    list_mgmt(path, list(start.index = start.index, max.results = max.results), token)
}
