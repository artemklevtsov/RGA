#' @title Goals
#' @description Gets a goal to which the user has access.
#' @param accountId character. Account ID to retrieve the goal for.
#' @param goalId character. Goal ID to retrieve the goal for.
#' @param profileId character. View (Profile) ID to retrieve the goal for.
#' @param webPropertyId character. Web property ID to retrieve the goal for.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @return A Goals resource describes a goal for one of a user's profiles.
#' \item{id}{Goal ID.}
#' \item{kind}{Resource type for an Analytics goal.}
#' \item{accountId}{Account ID to which this goal belongs.}
#' \item{webPropertyId}{Web property ID to which this goal belongs. The web property ID is of the form UA-XXXXX-YY.}
#' \item{internalWebPropertyId}{Internal ID for the web property to which this goal belongs.}
#' \item{profileId}{View (Profile) ID to which this goal belongs.}
#' \item{name}{Goal name.}
#' \item{value}{Goal value.}
#' \item{active}{Determines whether this goal is active.}
#' \item{type}{Goal type. Possible values are URL_DESTINATION, VISIT_TIME_ON_SITE, VISIT_NUM_PAGES, and EVENT.}
#' \item{created}{Time this goal was created.}
#' \item{updated}{Time this goal was last modified.}
#' \item{urlDestinationDetails}{Details for the goal of the type URL_DESTINATION.}
#' \item{visitTimeOnSiteDetails}{Details for the goal of the type VISIT_TIME_ON_SITE.}
#' \item{visitNumPagesDetails}{Details for the goal of the type VISIT_NUM_PAGES.}
#' \item{eventDetails}{Details for the goal of the type EVENT.}
#' \item{urlDestinationDetails.url}{URL for this goal.}
#' \item{urlDestinationDetails.caseSensitive}{Determines if the goal URL must exactly match the capitalization of visited URLs.}
#' \item{urlDestinationDetails.matchType}{Match type for the goal URL. Possible values are HEAD, EXACT, or REGEX.}
#' \item{urlDestinationDetails.firstStepRequired}{Determines if the first step in this goal is required.}
#' \item{urlDestinationDetails.steps.number}{Step number.}
#' \item{urlDestinationDetails.steps.name}{Step name.}
#' \item{urlDestinationDetails.steps.url}{URL for this step.}
#' \item{visitTimeOnSiteDetails.comparisonType}{Type of comparison. Possible values are LESS_THAN or GREATER_THAN.}
#' \item{visitTimeOnSiteDetails.comparisonValue}{Value used for this comparison.}
#' \item{visitNumPagesDetails.comparisonType}{Type of comparison. Possible values are LESS_THAN, GREATER_THAN, or EQUAL.}
#' \item{visitNumPagesDetails.comparisonValue}{Value used for this comparison.}
#' \item{eventDetails.useEventValue}{Determines if the event value should be used as the value for this goal.}
#' \item{eventDetails.eventConditions.type}{Type of this event condition. Possible values are CATEGORY, ACTION, LABEL, or VALUE.}
#' \item{eventDetails.eventConditions.matchType}{Type of the match to be performed. Possible values are REGEXP, BEGINS_WITH, or EXACT.}
#' \item{eventDetails.eventConditions.expression}{Expression used for this match.}
#' \item{eventDetails.eventConditions.comparisonType}{Type of comparison. Possible values are LESS_THAN, GREATER_THAN or EQUAL.}
#' \item{eventDetails.eventConditions.comparisonValue}{Value used for this comparison.}
#' @references \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/goals}{Management API - Goals Overview}
#' @family Management API
