#' @title Goals
#' @description Gets a goal to which the user has access.
#' @param account.id character. Account ID to retrieve the goal for.
#' @param goal.id character. Goal ID to retrieve the goal for.
#' @param profile.id character. View (Profile) ID to retrieve the goal for.
#' @param webproperty.id character. Web property ID to retrieve the goal for.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @return A Goals resource describes a goal for one of a user's profiles.
#' \item{id}{Goal ID.}
#' \item{kind}{Resource type for an Analytics goal.}
#' \item{account.id}{Account ID to which this goal belongs.}
#' \item{webproperty.id}{Web property ID to which this goal belongs. The web property ID is of the form UA-XXXXX-YY.}
#' \item{internal.webproperty.id}{Internal ID for the web property to which this goal belongs.}
#' \item{profile.id}{View (Profile) ID to which this goal belongs.}
#' \item{name}{Goal name.}
#' \item{value}{Goal value.}
#' \item{active}{Determines whether this goal is active.}
#' \item{type}{Goal type. Possible values are URL_DESTINATION, VISIT_TIME_ON_SITE, VISIT_NUM_PAGES, and EVENT.}
#' \item{created}{Time this goal was created.}
#' \item{updated}{Time this goal was last modified.}
#' \item{url.destination.details}{Details for the goal of the type URL_DESTINATION.}
#' \item{visit.time.on.site.details}{Details for the goal of the type VISIT_TIME_ON_SITE.}
#' \item{visit.num.pages.details}{Details for the goal of the type VISIT_NUM_PAGES.}
#' \item{event.details}{Details for the goal of the type EVENT.}
#' \item{url.destination.details.url}{URL for this goal.}
#' \item{url.destination.details.case.sensitive}{Determines if the goal URL must exactly match the capitalization of visited URLs.}
#' \item{url.destination.details.match.type}{Match type for the goal URL. Possible values are HEAD, EXACT, or REGEX.}
#' \item{url.destination.details.first.step.required}{Determines if the first step in this goal is required.}
#' \item{url.destination.details.steps.number}{Step number.}
#' \item{url.destination.details.steps.name}{Step name.}
#' \item{url.destination.details.steps.url}{URL for this step.}
#' \item{visit.time.on.site.details.comparison.type}{Type of comparison. Possible values are LESS_THAN or GREATER_THAN.}
#' \item{visit.time.on.site.details.comparison.value}{Value used for this comparison.}
#' \item{visit.num.pages.details.comparison.type}{Type of comparison. Possible values are LESS_THAN, GREATER_THAN, or EQUAL.}
#' \item{visit.num.pages.details.comparison.value}{Value used for this comparison.}
#' \item{event.details.use.event.value}{Determines if the event value should be used as the value for this goal.}
#' \item{event.details.event.conditions.type}{Type of this event condition. Possible values are CATEGORY, ACTION, LABEL, or VALUE.}
#' \item{event.details.event.conditions.match.type}{Type of the match to be performed. Possible values are REGEXP, BEGINS_WITH, or EXACT.}
#' \item{event.details.event.conditions.expression}{Expression used for this match.}
#' \item{event.details.event.conditions.comparison.type}{Type of comparison. Possible values are LESS_THAN, GREATER_THAN or EQUAL.}
#' \item{event.details.event.conditions.comparison.value}{Value used for this comparison.}
#' @references \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/goals}{Management API - Goals Overview}
#' @family Management API
