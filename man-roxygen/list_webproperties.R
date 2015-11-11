#' @title Web Properties
#' 
#' @description Lists properties to which the user has access.
#' 
#' @param account.id character. Account ID to retrieve web properties for. Can either be a specific account ID or '~all', which refers to all the accounts that user has access to.
#' @param max.results integer. The maximum number of web properties to include in this response.
#' @param start.index integer. An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#' 
#' @return The Webproperties collection is a set of Webproperty resources, each of which describes a web property available to an authenticated user.
#' \item{id}{Web property ID of the form UA-XXXXX-YY.}
#' \item{kind}{Resource type for Analytics WebProperty.}
#' \item{account.id}{Account ID to which this web property belongs.}
#' \item{internal.webproperty.id}{Internal ID for this web property.}
#' \item{name}{Name of this web property.}
#' \item{website.url}{Website url for this web property.}
#' \item{level}{Level for this web property.}
#' \item{profile.count}{View (Profile) count for this web property.}
#' \item{industry.vertical}{The industry vertical/category selected for this web property.  If this field is set, the correct values are:   UNSPECIFIED   ARTS_AND_ENTERTAINMENT   AUTOMOTIVE   BEAUTY_AND_FITNESS   BOOKS_AND_LITERATURE   BUSINESS_AND_INDUSTRIAL_MARKETS   COMPUTERS_AND_ELECTRONICS   FINANCE   FOOD_AND_DRINK   GAMES   HEALTHCARE   HOBBIES_AND_LEISURE   HOME_AND_GARDEN   INTERNET_AND_TELECOM   JOBS_AND_EDUCATION   LAW_AND_GOVERNMENT   NEWS   ONLINE_COMMUNITIES   OTHER   PEOPLE_AND_SOCIETY   PETS_AND_ANIMALS   REAL_ESTATE   REFERENCE   SCIENCE   SHOPPING   SPORTS   TRAVEL}
#' \item{default.profile.id}{Default view (profile) ID.}
#' \item{permissions}{Permissions the user has for this web property.}
#' \item{created}{Time this web property was created.}
#' \item{updated}{Time this web property was last modified.}
#' \item{permissions.effective}{All the permissions that the user has for this web property. These include any implied permissions (e.g., EDIT implies VIEW) or inherited permissions from the parent account.}
#' 
#' @references \href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/webproperties}{Management API - Web Properties Overview}
#' 
#' @family Management API
