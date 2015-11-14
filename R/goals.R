#' @template get_goals
#' @include mgmt.R
#' @export
get_goal <- function(account.id, webproperty.id, profile.id, goal.id, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/profiles/%s/goals/%s",
                    account.id, webproperty.id, profile.id, goal.id)
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @template list_goals
#' @include mgmt.R
#' @export
list_goals = function(account.id = "~all", webproperty.id = "~all", profile.id = "~all", start.index = NULL, max.results = NULL, token) {
    path <- sprintf("management/accounts/%s/webproperties/%s/profiles/%s/goals",
                    account.id, webproperty.id, profile.id)
    query <- list(start.index = start.index, max.results = max.results)
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
