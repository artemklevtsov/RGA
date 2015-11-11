#' @title Account Summaries
#' @description Lists account summaries (lightweight tree comprised of accounts/properties/profiles) to which the user has access.
#' @param max.results integer. The maximum number of account summaries to include in this response, where the largest acceptable value is 1000.
#' @param start.index integer. An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' @return
#' \item{id}{Account ID.}
#' \item{kind}{Resource type for Analytics AccountSummary.}
#' \item{name}{Account name.}
#' \item{web.properties}{List of web properties under this account.}
#' \item{web.properties.kind}{Resource type for Analytics WebPropertySummary.}
#' \item{web.properties.id}{Web property ID of the form UA-XXXXX-YY.}
#' \item{web.properties.name}{Web property name.}
#' \item{web.properties.internal.webproperty.id}{Internal ID for this web property.}
#' \item{web.properties.level}{Level for this web property. Possible values are STANDARD or PREMIUM.}
#' \item{web.properties.website.url}{Website url for this web property.}
#' \item{web.properties.profiles.kind}{Resource type for Analytics ProfileSummary.}
#' \item{web.properties.profiles.id}{View (profile) ID.}
#' \item{web.properties.profiles.name}{View (profile) name.}
#' \item{web.properties.profiles.type}{View (Profile) type. Supported types: WEB or APP.}
#' @references \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/accountSummaries}{Management API - Account Summaries Overview}
#' @family Management API
