#' @title Gets a goal to which the user has access to
#'
#' @param account.id integer or character. Account ID to retrieve the goal for.
#' @param webproperty.id character. Web property ID to retrieve the goal for.
#' @param profile.id ineger or character. View (Profile) ID to retrieve the goal for.
#' @param goal.id ineger or character. Goal ID to retrieve the goal for.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return An Analytics goal resource
#' \item{id}{Goal ID.}
#' \item{kind}{Resource type for an Analytics goal.}
#' \item{self.link}{Link for this goal.}
#' \item{account.id}{Account ID to which this goal belongs.}
#' \item{web.property.id}{Web property ID to which this goal belongs. The web property ID is of the form UA-XXXXX-YY.}
#' \item{internal.web.property.id}{Internal ID for the web property to which this goal belongs.}
#' \item{profile.id}{View (Profile) ID to which this goal belongs.}
#' \item{name}{Goal name.}
#' \item{value}{Goal value.}
#' \item{active}{Determines whether this goal is active.}
#' \item{type}{Goal type. Possible values are URL_DESTINATION, VISIT_TIME_ON_SITE, VISIT_NUM_PAGES, and EVENT.}
#' \item{created}{Time this goal was created.}
#' \item{updated}{Time this goal was last modified.}
#' \item{parent.link}{Parent link for a goal. Points to the view (profile) to which this goal belongs.}
#' \item{visit.time.on.site.details}{Details for the goal of the type VISIT_TIME_ON_SITE.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/goals}{Google Management API - Goals}
#'
#' @family Management API
#'
#' @include mgmt.R
#'
#' @export
#'
get_goal <- function(account.id, webproperty.id, profile.id, goal.id, token) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "goals", goal.id, sep = "/")
    res <- get_mgmt(path = path, token = token)
    return(res)
}

#' @title Lists goals which the user has access to
#'
#' @param account.id integer or character. The account ID to retrieve goals for. Can either be a specific account ID or '~all', which refers to all the accounts that user has access to.
#' @param webproperty.id character. Web property ID to retrieve goals for. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to. Requires specified \code{account.id}.
#' @param profile.id ineger or character. View (Profile) ID to retrieve goals for. Can either be a specific view (profile) ID or '~all', which refers to all the views (profiles) that user has access to. Requires specified \code{account.id} and \code{webproperty.id}.
#' @param start.index integer. An index of the first goal to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of goals to include in this response.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return A goal collection lists Analytics goals to which the user has access. Each view (profile) can have a set of goals. Each resource in the Goal collection corresponds to a single Analytics goal.
#' \item{id}{Goal ID (number).}
#' \item{account.id}{Account ID which this goal belongs to.}
#' \item{webproperty.id}{Web property ID which this goal belongs to. The web property ID is of the form UA-XXXXX-YY.}
#' \item{profile.id}{View (Profile) ID to which this goal belongs.}
#' \item{name}{Goal name.}
#' \item{value}{Goal value.}
#' \item{active}{Determines whether this goal is active.}
#' \item{type}{Goal type. Acceptable values are: "EVENT", "URL_DESTINATION", "VISIT_NUM_PAGES", "VISIT_TIME_ON_SITE"}
#' \item{created}{Time this goal was created.}
#' \item{updated}{Time this goal was last modified.}
#'
#' @seealso \code{\link{authorize}}
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/goals}{Google Management API - Goals}
#'
#' @family Management API
#'
#' @include mgmt.R
#'
#' @export
#'
list_goals = function(account.id = "~all", webproperty.id = "~all", profile.id = "~all", start.index = NULL, max.results = NULL, token) {
    path <- paste("accounts", account.id, "webproperties", webproperty.id, "profiles", profile.id, "goals", sep = "/")
    query <- list(start.index = start.index, max.results = max.results, fields = "items(id,accountId,webPropertyId,profileId,name,active,value,type,created,updated)")
    res <- list_mgmt(path = path, query = query, token = token)
    return(res)
}
