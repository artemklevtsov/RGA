#' @template get_goals
#' @include mgmt.R
#' @export
get_goal <- function(account.id, webproperty.id, profile.id, goal.id, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "goals", goal.id)
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @template list_goals
#' @include mgmt.R
#' @export
list_goals = function(account.id = "~all", webproperty.id = "~all", profile.id = "~all", start.index = NULL, max.results = NULL, token) {
    path <- c("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "goals")
    query <- list(start.index = start.index, max.results = max.results)
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
